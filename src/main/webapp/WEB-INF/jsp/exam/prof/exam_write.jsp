<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="table,editor,fileuploader"/>
	</jsp:include>

	<script type="text/javascript">
        var isModify = "${isModify}";   // [등록|수정] 여부
        var sbjctId = "${sbjctId}";     // 과목 ID
        var dialog;                     // UiDialog 인스턴스
        var getExamBscId = "";
        const editors = {};	            // 에디터 목록 저장용
        var setUrl = "";                // 등록|수정 URL

        /* examDtlInfoVO를 JS 배열로 직렬화 (수정일 경우) */
        var examDtlInfoList = [
            <c:forEach var="dtl" items="${examDtlInfoVO}" varStatus="st">
            {
                teamId:     "<c:out value='${dtl.teamId}'/>",
                teamnm:     "<c:out value='${dtl.teamnm}'/>",
                ldrnm:      "<c:out value='${dtl.ldrnm}'/>",
                examTtl:    "<c:out value='${dtl.examTtl}'/>",
                examCts:    "<c:out value='${dtl.examCts}'/>",
                teamMbrTot: ${empty dtl.teamMbrTot ? 0 : dtl.teamMbrTot}
            }<c:if test="${!st.last}">,</c:if>
            </c:forEach>
        ];

        /*****************************************************************************
         * 저장 버튼 기능
         * 1. examSaveBtnEvent :    데이터 [등록|수정] 버튼 이벤트 (ajax)
         * 2. isNull :              필수 값 Input 영역 비어있는지 확인하는 함수
         * 3. getDtlInfos :         팀 시험 학습그룹별 부 주제 목록 수집
         *****************************************************************************/
        /* 1 */
        function examSaveBtnEvent () {
            $("#examWriteSave").on("click", function() {
                var validator = UiValidator("exam-write1");
                validator.then(function(result) {
                    if (result) {
                        if(!isNull()) {
                            return false;
                        }
                        /* 만약 span 요소에 작성된 텍스트만 필요하다면.. 아래 주석 해제 후 사용 */
                        // var examContents = $("<div>").html(editor.getPublishingHtml()).text();
                        var examContents = editors['editor'].getPublishingHtml();
                        var trnsStdt = UiComm.getDateTimeVal("dateSt", "timeSt") + "00";
                        var trnsEddt = UiComm.getDateTimeVal("dateEd", "timeEd") + "59";
                        var formData = {
                            examBscId:                  "${vo.examBscId}",
                            examGbncd:                  $('input[name="exam-gubun-rd"]:checked').val(),
                            tkexamMthdCd:               $('input[name="exam-type-rd"]:checked').val(),
                            examTtl:                    $('#exam-ttl').val(),
                            examCts:                    examContents,
                            "examDtlVO.examPsblSdttm":  trnsStdt,   // examPsblSdttm → examDtlVO.examPsblSdttm
                            "examDtlVO.examPsblEdttm":  trnsEddt,   // examPsblEdttm → examDtlVO.examPsblEdttm
                            "examDtlVO.examMnts":       $('#examMnts').val(),  // examMnts → examDtlVO.examMnts
                            mrkRfltyn:                  $('input[name="mkr-rfltyn-rd"]:checked').val(),
                            mrkOyn:                     $('input[name="mkr-oyn-rd"]:checked').val(),
                            exampprOyn:                 $('input[name="examppr-oyn-rd"]:checked').val(),
                            byteamSubrexamUseyn:        $('#byteam-subrexam-useyn-y-rd').is(':checked') ? 'Y' : 'N',
                            lrnGrpSubsbjctUseyn:        $('#lrnGrpSubsbjctUseyn_1').is(':checked') ? 'Y' : 'N',
                            dtlInfos:                   $('#byteam-subrexam-useyn-y-rd').is(':checked') ? getDtlInfos() : '',
                            lrnGrpIds:                  $('#lrnGrpId1').val(),
                            sbjctId:                    sbjctId
                        };

                        UiComm.showLoading(true);
                        $.ajax({
                            url:      setUrl,
                            async:    false,
                            type:     "POST",
                            dataType: "json",
                            data:     formData
                        }).done(function(data) {
                            UiComm.showLoading(false);
                            if (data.result > 0) {
                                UiComm.showMessage("저장되었습니다.", "info")
                                .then(function() {
                                    location.href = "/exam/profExamListView.do?sbjctId=${sbjctId}";
                                });
                            } else {
                                UiComm.showMessage(data.message, "error");
                            }
                        }).fail(function() {
                            UiComm.showLoading(false);
                            UiComm.showMessage(
                                isModify === "true"
                                    ? "<spring:message code='exam.error.update' />"
                                    : "<spring:message code='exam.error.insert' />",
                                "error"
                            );
                        });
                        console.log(formData);
                    }
                });
            });
        }
        /* 2 */
        function isNull() {
            // 팀 시험 설정시
            if($("#byteam-subrexam-useyn-y-rd").is(":checked")) {
                var isResult = true;
                var alertMsg = "";
                $("input[name=lrnGrpnm]:visible").each(function(i, e) {
                    if(e.value == "") {
                        isResult = false;
                        alertMsg = "학습그룹을 지정하세요.";
                        return false;
                    }
                });

                // 팀 시험 학습그룹별 부 주제 설정시
                $("input[name='lrnGrpSubsbjctUseyn']:checked").each(function(i, e) {
                    if(!isResult) return false;
                    $("#subInfoDiv"+e.id.split("_")[1]+" tr.subQuizTr").each(function(index, element) {
                        var ttl = $(element).find("input[name='subExamTtl']");
                        if($.trim($(ttl).val()) == "") {
                            isResult = false;
                            alertMsg = "<spring:message code='exam.alert.input.title' />"	/* 제목을 입력하세요. */
                            return false;
                        }

                        var teamId = ttl[0].id.split("_")[0];
                        if(editors[teamId+'_editor'+index].isEmpty() || editors[teamId+'_editor'+index].getTextContent().trim() === "") {
                            isResult = false;
                            alertMsg = "<spring:message code='exam.alert.input.contents' />";	/* 내용을 입력하세요. */
                            return false;
                        }
                    });
                });
                if(!isResult) {
                    UiComm.showMessage(alertMsg, "warning");
                    return false;
                }
            }
            return true;
        }
        /* 3 */
        function getDtlInfos() {
            const dtlInfos = [];
            $("input[name='lrnGrpSubsbjctUseyn']:checked").each(function(i, e) {
                var dvclasNo = e.id.split("_")[1];
                $("#subInfoDiv" + dvclasNo + " tr.subQuizTr").each(function(index, element) {
                    var teamId = $(element).attr("id");                            // TR의 id 속성에서 teamId 추출
                    var ttl    = $(element).find("input[name='subExamTtl']");
                    dtlInfos.push({
                        id:  teamId,
                        ttl: $.trim($(ttl).val()),
                        cts: editors[teamId + "_editor" + index].getPublishingHtml()
                    });
                });
            });
            return JSON.stringify(dtlInfos);
        }

        /*****************************************************************************
         * 팀 관련 기능
         * 1. teamynChange :                팀 여부 변경 (DIV 영역 히든 <=> show)
         * 2. lrnGrpSubasmtStngynChange :   학습그룹별 시험 설정 체크박스 변경
         * 3. teamGrpChcPopup :             학습그룹지정 팝업
         * 4. selectTeam :                  학습그룹 선택 및 HTML 요소 생성
         * 5. closeDialog :                 3번에 의해 열린 팝업 창 닫기
         * 6. loadGrpInfo :                 학습그룹 세팅 (수정 일 경우)
         * 7. buildTeamDtlFromServer :      examDtlInfoVO로 팀별 시험 설정 HTML 빌드 (lrnGrpSubsbjctUseyn = 'Y' 인 경우 호출)
         *****************************************************************************/
        /* 1 */
        function teamynChange(value) {
            if(value == "Y") {
                $("#teamDiv").show();
            } else {
                $("#teamDiv").hide();
            }
        }
        /* 2 */
        function lrnGrpSubasmtStngynChange(obj) {
            var suffix = obj.id.split("_")[1];
            if (obj.checked) {
                $("#subInfoDiv" + suffix).show();
                // 수정 진입 시 학습그룹이 이미 선택되어 있으나 subInfoDiv가 비어있으면 데이터 로드
                var lrnGrpIdVal = $("#lrnGrpId" + suffix).val();
                if (lrnGrpIdVal && $("#subInfoDiv" + suffix).children().length === 0) {
                    var lrnGrpId  = lrnGrpIdVal.split(":")[0];
                    var examBscId = $(obj).data("bscId");
                    var url  = "/exam/examLrnGrpSubAsmtListAjax.do";
                    var data = { lrnGrpId: lrnGrpId, examBscId: examBscId };
                    ajaxCall(url, data, function(data) {
                        if (data.result > 0) {
                            var returnList = data.returnList || [];
                            var html = "";
                            if (returnList.length > 0) {
                                html += "<table class='table-type5'>";
                                html += "	<colgroup><col class='width-10per' /><col class='' /><col class='width-10per' /></colgroup>";
                                html += "	<tbody>";
                                html += "		<tr><th>팀 명</th><th>부 주제</th><th>학습그룹 구성원</th></tr>";
                                returnList.forEach(function(v, i) {
                                    html += "	<tr class='subQuizTr' id='" + v.teamId + "'>";
                                    html += "		<th><label>" + v.teamnm + "</label></th>";
                                    html += "		<td><table class='table-type5'><colgroup><col class='width-10per' /><col class='' /></colgroup><tbody>";
                                    html += "			<tr><th><label for='" + v.teamId + "_dtlExamTtl_" + i + "' class='req'>부 주제</label></th>";
                                    html += "			<td><input type='text' id='" + v.teamId + "_dtlExamTtl_" + i + "' name='subExamTtl' value='" + (v.examTtl == null ? '' : v.examTtl) + "' inputmask='byte' maxLen='200' class='width-100per' /></td></tr>";
                                    html += "			<tr><th><label for='" + v.teamId + "_contentTextArea_" + i + "' class='req'>내용</label></th>";
                                    html += "			<td><div class='editor-box'><textarea name='" + v.teamId + "_contentTextArea_" + i + "' id='" + v.teamId + "_contentTextArea_" + i + "'>" + (v.examCts == null ? '' : v.examCts) + "</textarea></div></td></tr>";
                                    html += "		</tbody></table></td>";
                                    html += "		<th>" + v.leadernm + " 외 " + (v.teamMbrCnt - 1) + "</th>";
                                    html += "	</tr>";
                                });
                                html += "	</tbody></table>";
                            }
                            $("#subInfoDiv" + suffix).empty().html(html);
                            returnList.forEach(function(v, i) {
                                editors[v.teamId + '_editor' + i] = UiEditor({
                                    targetId: v.teamId + '_contentTextArea_' + i,
                                    uploadPath: "/exam",
                                    height: "200px"
                                });
                            });
                        } else {
                            UiComm.showMessage(data.message, "error");
                        }
                    }, function(xhr, status, error) {
                        UiComm.showMessage("<spring:message code='exam.error.copy' />", "error");
                    });
                }
            } else {
                $("#subInfoDiv" + suffix).hide();
            }
        }
        /* 3 */
        function teamGrpChcPopup(i, sbjctId) {
            dialog = UiDialog("dialog1", {
                title: "학습그룹지정",
                width: 600,
                height: 500,
                url: "/team/teamHome/teamCtgrSelectPop.do?sbjctId="+sbjctId+"&searchFrom="+i + ":" + sbjctId,
                autoresize: true
            });
        }
        /* 4 */
        function selectTeam(lrnGrpId, lrnGrpnm, id) {
            var idList = id.split(':');
            $("#lrnGrpId" + idList[0]).val(lrnGrpId + ":" + idList[1]);
            $("#lrnGrpnm" + idList[0]).val(lrnGrpnm);
            $("#setExamTeamDiv" + idList[0]).show();

            var url  = "/exam/examLrnGrpSubAsmtListAjax.do";
            var data = {
                lrnGrpId  : lrnGrpId,
                examBscId : $("#lrnGrpSubasmtStngyn_" + idList[0]).data("bscid")
            };

            ajaxCall(url, data, function(data) {
                if (data.result > 0) {
                    var returnList = data.returnList || [];
                    console.log(returnList);
                    var html = "";

                    if(returnList.length > 0) {
                        html += "<table class='table-type5'>";
                        html += "	<colgroup>";
                        html += "		<col class='width-10per' />";
                        html += "		<col class='' />";
                        html += "		<col class='width-10per' />";
                        html += "	</colgroup>";
                        html += "	<tbody>";
                        html += "		<tr>";
                        html += "			<th>팀 명</th>";
                        html += "			<th>부 주제</th>";
                        html += "			<th>학습그룹 구성원</th>";
                        html += "		</tr>";
                        returnList.forEach(function(v, i) {
                            html += "	<tr class='subQuizTr' id='" + v.teamId + "'>"; // teamId를 TR id에 직접 바인딩
                            html += "		<th><label>" + v.teamnm + "</label></th>";
                            html += "		<td>";
                            html += "			<table class='table-type5'>";
                            html += "				<colgroup>";
                            html += "					<col class='width-10per' />";
                            html += "					<col class='' />";
                            html += "				</colgroup>";
                            html += "				<tbody>";
                            html += "					<tr>";
                            html += "						<th><label for='" + v.teamId + "_dtlExamTtl_" + i + "' class='req'>부 주제</label></th>";
                            html += "						<td><input type='text' id='" + v.teamId + "_dtlExamTtl_" + i + "' name='subExamTtl' value='" + (v.examTtl == null ? '' : v.examTtl) + "' inputmask='byte' maxLen='200' class='width-100per' /></td>";
                            html += "					</tr>";
                            html += "					<tr>";
                            html += "						<th><label for='" + v.teamId + "_contentTextArea_" + i + "' class='req'>내용</label></th>";
                            html += "						<td>";
                            html += "							<div class='editor-box'>";
                            html += "								<textarea name='" + v.teamId + "_contentTextArea_" + i + "' id='" + v.teamId + "_contentTextArea_" + i + "'>" + (v.examCts == null ? '' : v.examCts) + "</textarea>";
                            html += "							</div>";
                            html += "						</td>";
                            html += "					</tr>";
                            html += "				</tbody>";
                            html += "			</table>";
                            html += "		</td>";
                            html += "		<th>" + v.leadernm + " 외 " + (v.teamMbrCnt - 1) + "</th>";
                            html += "	</tr>";
                        });
                        html += "	</tbody>";
                        html += "</table>";
                    }

                    if ($("#lrnGrpSubsbjctUseyn_" + idList[0]).is(':checked')) {
                        $("#subInfoDiv" + idList[0]).empty().html(html);
                        if(returnList.length > 0) {
                            returnList.forEach(function(v, i) {
                                // html 에디터 생성
                                editors[v.teamId+'_editor'+i] = UiEditor({
                                    targetId: v.teamId+'_contentTextArea_'+i,
                                    uploadPath: "/exam",
                                    height: "200px"
                                });
                            });
                        }
                    }
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }, function(xhr, status, error) {
                UiComm.showMessage("<spring:message code='exam.error.copy' />", "error");	/* 가져오기 중 에러가 발생하였습니다. */
            });
        }
        /* 5 */
        function closeDialog() {
            if (dialog) { dialog.close(); }
        }
        /* 6 */
        function loadGrpInfo() {
            if("${not empty vo.examBscId}" === "true") {
                // lrnGrpId hidden 필드 세팅
                <c:if test="${not empty examDtlInfoVO}">
                $("#lrnGrpId1").val("<c:out value='${examDtlInfoVO[0].lrnGrpId}'/>:<c:out value='${crsCreCd}'/>");
                </c:if>
                // 학습그룹 설정 영역 노출
                $("#setExamTeamDiv1").show();
                // lrnGrpSubsbjctUseyn = Y 인 경우 서버 데이터로 팀 시험 HTML 빌드
                if ("${examVO.lrnGrpSubsbjctUseyn}" === "Y") {
                    buildTeamDtlFromServer();
                }
            }
        }
        /* 7 */
        function buildTeamDtlFromServer() {
            var returnList = examDtlInfoList;
            var html = "";

            if (returnList.length > 0) {
                html += "<table class='table-type5'>";
                html += "    <colgroup>";
                html += "        <col class='width-10per' />";
                html += "        <col class='' />";
                html += "        <col class='width-10per' />";
                html += "    </colgroup>";
                html += "    <tbody>";
                html += "        <tr>";
                html += "            <th>팀 명</th>";
                html += "            <th>부 주제</th>";
                html += "            <th>학습그룹 구성원</th>";
                html += "        </tr>";
                returnList.forEach(function(v, i) {
                    var examCts = $('#serverExamCts_' + i).val() || '';
                    html += "    <tr class='subQuizTr' id='" + v.teamId + "'>";
                    html += "        <th><label>" + v.teamnm + "</label></th>";
                    html += "        <td>";
                    html += "            <table class='table-type5'>";
                    html += "                <colgroup>";
                    html += "                    <col class='width-10per' />";
                    html += "                    <col class='' />";
                    html += "                </colgroup>";
                    html += "                <tbody>";
                    html += "                    <tr>";
                    html += "                        <th><label for='" + v.teamId + "_dtlExamTtl_" + i + "' class='req'>부 주제</label></th>";
                    html += "                        <td><input type='text' id='" + v.teamId + "_dtlExamTtl_" + i + "' name='subExamTtl' value='" + (v.examTtl || '') + "' inputmask='byte' maxLen='200' class='width-100per' /></td>";
                    html += "                    </tr>";
                    html += "                    <tr>";
                    html += "                        <th><label for='" + v.teamId + "_contentTextArea_" + i + "' class='req'> 내용</label></th>";
                    html += "                        <td>";
                    html += "                            <div class='editor-box'>";
                    html += "                                <textarea name='" + v.teamId + "_contentTextArea_" + i + "' id='" + v.teamId + "_contentTextArea_" + i + "'>" + v.examCts + "</textarea>";
                    html += "                            </div>";
                    html += "                        </td>";
                    html += "                    </tr>";
                    html += "                </tbody>";
                    html += "            </table>";
                    html += "        </td>";
                    html += "        <th>" + v.ldrnm + " 외 " + (v.teamMbrTot - 1) +  " 명" + "</th>";
                    html += "    </tr>";
                });
                html += "    </tbody>";
                html += "</table>";
            }

            $("#subInfoDiv1").empty().html(html);

            if (returnList.length > 0) {
                returnList.forEach(function(v, i) {
                    editors[v.teamId + '_editor' + i] = UiEditor({
                        targetId: v.teamId + '_contentTextArea_' + i,
                        uploadPath: "/exam",
                        height: "200px"
                    });
                });
            }
        }

        /*****************************************************************************
         * 목록 버튼 기능
         * 1. backToListViewBtn :   목록으로 돌아감
         *****************************************************************************/
        /* 1 */
        function backToListViewBtn () {
            $("#examWriteCancle").on("click", function() {
                UiComm.showMessage("목록으로 돌아가시겠습니까?", "confirm")
                    .then(function(result) {
                        if (result) {
                            location.href = "/exam/profExamListView.do?sbjctId=${sbjctId}";
                        }
                    });
            });
        }

        $(document).ready(function() {
            // 등록|수정 URL 세팅
            if (isModify == "Y") {
                setUrl = "/exam/examModify.do"
            } else {
                setUrl = "/exam/examRegist.do"
            }
            console.log ("isModify ? " + isModify);
            console.log ("sbjctId ? " + sbjctId);
            console.log ("setUrl ? " + setUrl);

            examSaveBtnEvent();
            backToListViewBtn ();
		});

        $(window).on('load', function() {
            loadGrpInfo();
        });
    </script>
</head>

<body class="class colorA "><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <!-- classroom -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="class_sub_top">
                    <div class="navi_bar">
                        <ul>
                            <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                            <li>강의실</li>
                            <li><span class="current">시험</span></li>
                        </ul>
                    </div>
                    <div class="btn-wrap">
                        <div class="first">
                            <select class="form-select">
                                <option value="2025년 2학기">2025년 2학기</option>
                                <option value="2025년 1학기">2025년 1학기</option>
                            </select>
                            <select class="form-select wide">
                                <option value="">강의실 바로가기</option>
                                <option value="2025년 2학기">2025년 2학기</option>
                                <option value="2025년 1학기">2025년 1학기</option>
                            </select>
                        </div>
                        <div class="sec">
                            <button type="button" class="btn type1"><i class="xi-book-o"></i>교수 매뉴얼</button>
                            <button type="button" class="btn type1"><i class="xi-info-o"></i>학습안내정보</button>
                        </div>
                    </div>
                </div>

                <div class="class_sub">
                    <!-- 강의실 상단 -->
                    <div class="segment class-area">
                        <div class="info-left">
                            <div class="class_info">
                                <h2>데이터베이스의 이해와 활용 1반</h2>
                                <div class="classSection">
                                    <div class="cls_btn">
                                        <a href="#0" class="btn">강의계획서</a>
                                        <a href="#0" class="btn">학습진도관리</a>
                                        <a href="#0" class="btn">평가기준</a>
                                    </div>
                                </div>
                            </div>
                            <div class="info-cnt">
                                <div class="info_iconSet">
                                    <a href="#0" class="info"><span>공지</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>Q&A</span><div class="num_txt point">17</div></a>
                                    <a href="#0" class="info"><span>1:1</span><div class="num_txt point">3</div></a>
                                    <a href="#0" class="info"><span>과제</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>토론</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>세미나</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>퀴즈</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>설문</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>시험</span><div class="num_txt">2</div></a>
                                </div>
                                <div class="info-set">
                                    <div class="info">
                                        <p class="point"><span class="tit">중간고사:</span><span>2025.04.26 16:00</span></p>
                                        <p class="desc"><span class="tit">시간:</span><span>40분</span></p>
                                    </div>
                                    <div class="info">
                                        <p class="point"><span class="tit">기말고사:</span><span>2025.07.26 16:00</span></p>
                                        <p class="desc"><span class="tit">시간:</span><span>40분</span></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="info-right">
                            <div class="flex">
                                <div class="item week">
                                    <div class="item_icon"><i class="icon-svg-calendar-check-02" aria-hidden="true"></i></div>
                                    <div class="item_tit">2025.04.14 ~ 04.20</div>
                                    <div class="item_info"><span class="big">7</span><span class="small">주차</span></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- //강의실 상단 -->

                    <div class="segment">
                        <!-- 상단 영역 -->
                        <div class="board_top">
                            <i class="icon-svg-openbook"></i>
                            <h3 class="board-title">시험등록</h3>
                            <div class="right-area">
                                <button type="button" id = "examWriteSave" class="btn type2">저장</button>
                                <button type="button" id = "examWriteCancle" class="btn basic">목록</button>
                            </div>
                        </div>

                        <!-- 등록 영역 -->
                        <div class = "table-wrap">
                            <form id = "exam-write1" name = "exam-write1">
                                <table class = "table-type5">
                                    <colgroup>
                                        <col class="width-15per" />
                                        <col class="" />
                                    </colgroup>
                                    <!-- input 입력 폼 (id 전부 db에 맞게 변경해야 함) -->
                                    <tbody>
                                        <!-- 시험 구분 -->
                                        <tr>
                                            <th>
                                                <label for="exam-gubun-label">시험구분</label>
                                            </th>
                                            <td>
                                                <div class="form-inline">
                                                    <span class="custom-input">
                                                        <input type="radio" name="exam-gubun-rd" id="middle-rd" value="EXAM_MID" ${examVO.examGbncd eq 'EXAM_MID' || examVO.examGbncd eq 'EXAM_MID_TEAM' || empty vo.examBscId ? 'checked' : '' }>
                                                        <label for="middle-rd">중간고사</label>
                                                    </span>
                                                    <span class="custom-input ml5">
                                                        <input type="radio" name="exam-gubun-rd" id="final-rd" value="EXAM_LST" ${examVO.examGbncd eq 'EXAM_LST' || examVO.examGbncd eq 'EXAM_LST_TEAM' ? 'checked' : '' }>
                                                        <label for="final-rd">기말고사</label>
                                                    </span>
                                                    <span class="custom-input ml5">
                                                        <input type="radio" name="exam-gubun-rd" id="exam-rd" value="EXAM" ${examVO.examGbncd eq 'EXAM' || examVO.examGbncd eq 'EXAM_TEAM' ? 'checked' : '' }>
                                                        <label for="exam-rd">시험</label>
                                                    </span>
                                                    <span class="custom-input ml5">
                                                        <input type="radio" name="exam-gubun-rd" id="comprehensive-rd" value="EXAM_CMP" ${examVO.examGbncd eq 'EXAM_CMP' || examVO.examGbncd eq 'EXAM_CMP_TEAM' ? 'checked' : '' }>
                                                        <label for="comprehensive-rd">종합시험</label>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 시험방식 -->
                                        <tr>
                                            <th>
                                                <label for="exam-type-label">시험방식</label>
                                            </th>
                                            <td>
                                                <div class="form-inline">
                                                    <span class="custom-input">
                                                        <input type="radio" name="exam-type-rd" id="real-time-rd" value="RLTM" ${examVO.tkexamMthdCd eq 'RLTM' || empty vo.examBscId ? 'checked' : '' }>
                                                        <label for="real-time-rd">실시간 시험</label>
                                                    </span>
                                                    <span class="custom-input">
                                                        <input type="radio" name="exam-type-rd" id="quiz-rd" value="QUIZ" ${examVO.tkexamMthdCd eq 'QUIZ' ? 'checked' : '' }>
                                                        <label for="quiz-rd">퀴즈</label>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 시험명 -->
                                        <tr>
                                            <th>
                                                <label for="exam-ttl-label" class = "req">시험명</label>
                                            </th>
                                            <td>
                                                <div class="form-row">
                                                    <input class="form-control width-50per" 
                                                        type="text" name="name" id="exam-ttl" value="${examVO.examTtl}"
                                                        placeholder="시험명을 입력하세요." required="true" inputmask="byte" 
                                                        maxlen="150" autocomplete="off">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>
                                                <label for="contTextarea" class = "req">시험내용</label>
                                            </th>
                                            <td data-th="입력">
                                                <li>
                                                    <dl>
                                                        <dd>
                                                            <div class="editor-box">
                                                                <label for="examCts" class="hide">Content</label>
                                                                <textarea id="examCts" name="examCts" required="true">
                                                                    <c:out value="${examVO.examCts}"/>
                                                                </textarea>
                                                                <script>
                                                                    // HTML 에디터
                                                                    editors['editor'] = UiEditor({
                                                                        targetId: "examCts",
                                                                        uploadPath: "/exam",
                                                                        height: "400px"
                                                                    });
                                                                </script>
                                                            </div>
                                                        </dd>
                                                    </dl>
                                                </li>
                                            </section>
                                            <!--//섹션 에디터-->
                                            </td>
                                        </tr>
                                        <!-- 시험일시 -->
                                        <tr>
                                            <th>
                                                <label for="noticeLabel" class = "req">시험일시</label>
                                            </th>
                                            <td>
                                                <div class="date_area">
                                                    <input type="text" class="datepicker" id="dateSt" name="dateSt" timeId="timeSt" toDate="dateEd" required="true" placeholder="시작일" value="${fn:substring(examVO.examPsblSdttm,0,8)}">
                                                    <input type="text" class="timepicker" id="timeSt" name="timeSt" dateId="dateSt" required="true" placeholder="시작시간" value="${fn:substring(examVO.examPsblSdttm,8,12)}">
                                                    <span class="txt-sort">~</span>
                                                    <input type="text" class="datepicker" id="dateEd" name="dateEd" timeId="timeEd" fromDate="dateSt" required="true" placeholder="종료일" value="${fn:substring(examVO.examPsblEdttm,0,8)}">
                                                    <input type="text" class="timepicker" id="timeEd" name="timeEd" dateId="dateEd" required="true" placeholder="종료시간" value="${fn:substring(examVO.examPsblEdttm,8,12)}">
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 시험시간 -->
                                        <tr>
                                            <th>
                                                <label for="timeLabel" class = "req">시험시간</label>
                                            </th>
                                            <td>
                                                <div class="form-row">
                                                    <div class="input_btn">
                                                        <input class="form-control sm" id="examMnts" type="text" inputmask="numeric" maxlength="3" required="true" value="${examVO.examMnts}"><label>분</label>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 성적반영 -->
                                        <tr>
                                            <th>
                                                <label for="mkr-rfltyn-label">성적반영</label>
                                            </th>
                                            <td>
                                                <div class="form-inline">
                                                    <span class="custom-input">
                                                        <input type="radio" name="mkr-rfltyn-rd" id="mkr-rfltyn-y-rd" value="Y" ${examVO.mrkRfltyn eq 'Y' || empty vo.examBscId ? 'checked' : '' }>
                                                        <label for="mkr-rfltyn-y-rd">예</label>
                                                    </span>
                                                    <span class="custom-input ml5">
                                                        <input type="radio" name="mkr-rfltyn-rd" id="mkr-rfltyn-n-rd" value="N" ${examVO.mrkRfltyn eq 'N' ? 'checked' : '' }>
                                                        <label for="mkr-rfltyn-n-rd">아니오</label>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 성적공개 -->
                                        <tr>
                                            <th>
                                                <label for="mkr-oyn-label">성적공개</label>
                                            </th>
                                            <td>
                                                <div class="form-inline">
                                                    <span class="custom-input">
                                                        <input type="radio" name="mkr-oyn-rd" id="mkr-oyn-y-rd" value="Y" ${examVO.mrkOyn eq 'Y' || empty vo.examBscId ? 'checked' : '' }>
                                                        <label for="mkr-oyn-y-rd">예</label>
                                                    </span>
                                                    <span class="custom-input ml5">
                                                        <input type="radio" name="mkr-oyn-rd" id="mkr-oyn-n-rd" value="N" ${examVO.mrkOyn eq 'N' ? 'checked' : '' }>
                                                        <label for="mkr-oyn-n-rd">아니오</label>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 시험지공개 -->
                                        <tr>
                                            <th>
                                                <label for="examppr-oyn-label">시험지공개</label>
                                            </th>
                                            <td>
                                                <div class="form-inline">
                                                    <span class="custom-input">
                                                        <input type="radio" name="examppr-oyn-rd" id="examppr-oyn-y-rd" value="Y" ${examVO.exampprOyn eq 'Y' ? 'checked' : '' }>
                                                        <label for="examppr-oyn-y-rd">예</label>
                                                    </span>
                                                    <span class="custom-input ml5">
                                                        <input type="radio" name="examppr-oyn-rd" id="examppr-oyn-n-rd" value="N" ${examVO.exampprOyn eq 'N' || empty vo.examBscId ? 'checked' : '' }>
                                                        <label for="examppr-oyn-n-rd">아니오</label>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 팀 시험 -->
                                        <tr>
                                            <th>
                                                <label for="exam-team-label">팀 시험</label>
                                            </th>
                                            <td>
                                                <span class="custom-input">
                                                    <input type="radio" name="byteam-subrexam-useyn-rd" id="byteam-subrexam-useyn-y-rd" value="Y" onchange="teamynChange(this.value)" ${examVO.byteamSubrexamUseyn eq 'Y' ? 'checked' : '' }>
                                                    <label for="byteam-subrexam-useyn-y-rd">예</label>
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" name="byteam-subrexam-useyn-rd" id="byteam-subrexam-useyn-n-rd" value="N" onchange="teamynChange(this.value)" ${examVO.byteamSubrexamUseyn eq 'N' || empty vo.examBscId ? 'checked' : '' }>
                                                    <label for="byteam-subrexam-useyn-n-rd">아니오</label>
                                                </span>
                                                <!-- 시험 기본 ID || 팀별부시험여부 = Y 일 경우 -->
                                                <div class="mt5" id = "teamDiv" ${empty vo.examBscId || examVO.byteamSubrexamUseyn ne 'Y' ? 'style="display: none"' : ''} >
                                                    <div class="form-row" id="lrnGrpView">
                                                        <div class="input_btn width-100per">
                                                            <label>반</label>
                                                            <input type="hidden" id="lrnGrpId1" name="lrnGrpIds" value="">
                                                            <input class="form-control width-60per" type="text" name="lrnGrpnm" id="lrnGrpnm1" placeholder="팀 분류를 선택해 주세요." value="${examDtlInfoVO[0].lrnGrpnm}" readonly="" autocomplete="off">
                                                            <a class="btn type1 small" onclick="teamGrpChcPopup('1',sbjctId)">학습그룹지정</a>
                                                        </div>
                                                    </div>
                                                    <div class="form-inline">
                                                        <small class="note2">! 구성된 팀이 없는 경우 메뉴 “과목설정 > 학습그룹지정”에서 팀을 생성해 주세요</small>
                                                    </div>
                                                    <div class="ui segment" id="setExamTeamDiv1" style="display:none;">
                                                        <span class="custom-input">
                                                            <input type="checkbox" name="lrnGrpSubsbjctUseyn" id="lrnGrpSubsbjctUseyn_1" value="Y"
                                                                   data-bscId="${not empty vo.examBscId ? vo.examBscId : '' }"
                                                                   onchange="lrnGrpSubasmtStngynChange(this)" ${not empty vo.examBscId && examVO.lrnGrpSubsbjctUseyn eq 'Y' ? 'checked' : '' }>
                                                            <label for="lrnGrpSubsbjctUseyn_1">학습그룹별 시험 설정</label>
                                                        </span>
                                                    </div>
                                                    <div id="subInfoDiv1" ${not empty vo.examBscId && examVO.lrnGrpSubsbjctUseyn ne 'Y' ? 'style="display: none;"' : ''}></div>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
