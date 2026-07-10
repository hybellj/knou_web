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
        var isModify = '<c:out value="${isModify}" />';   // [등록|수정] 여부
        var sbjctId  = '<c:out value="${sbjctId}" />';   // 과목 ID
        var EPARAM   = '<c:out value="${encParams}" />';  // encParams
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
         * 3. getDtlInfos :         팀 시험 팀 그룹별 부 주제 목록 수집
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
                            teamGrpSubsbjctUseyn:        $('#teamGrpSubsbjctUseyn_1').is(':checked') ? 'Y' : 'N',
                            dtlInfos:                   $('#byteam-subrexam-useyn-y-rd').is(':checked') ? getDtlInfos() : '',
                            teamGrpIds:                  $('#teamGrpId1').val(),
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
                                UiComm.showMessage("<spring:message code='exam.alert.insert' />", "info")   /* 정상 저장 되었습니다. */
                                .then(function() {
                                    location.href = "/exam/profExamListView.do?encParams=" + EPARAM;
                                });
                            } else {
                                UiComm.showMessage(data.message, "error");
                            }
                        }).fail(function() {
                            UiComm.showLoading(false);
                            UiComm.showMessage(
                                isModify === "true"
                                    ? "<spring:message code='exam.error.update' />"     /* 수정 중 에러가 발생하였습니다. */
                                    : "<spring:message code='exam.error.insert' />",    /* 저장 중 에러가 발생하였습니다. */
                                "error"
                            );
                        });
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
                $("input[name=teamGrpnm]:visible").each(function(i, e) {
                    if(e.value == "") {
                        isResult = false;
                        alertMsg = "<spring:message code='exam.alert.team.grp.select' />";   /* 팀 그룹을 지정하세요. */
                        return false;
                    }
                });

                // 팀 시험 팀 그룹별 부 주제 설정시
                $("input[name='teamGrpSubsbjctUseyn']:checked").each(function(i, e) {
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
            $("input[name='teamGrpSubsbjctUseyn']:checked").each(function(i, e) {
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
         * 2. teamGrpSubasmtStngynChange :   팀 그룹별 시험 설정 체크박스 변경
         * 3. teamGrpChcPopup :             팀 그룹지정 팝업
         * 4. selectTeam :                  팀 그룹 선택 및 HTML 요소 생성
         * 5. closeDialog :                 3번에 의해 열린 팝업 창 닫기
         * 6. loadGrpInfo :                 팀 그룹 세팅 (수정 일 경우)
         * 7. buildTeamDtlFromServer :      examDtlInfoVO로 팀별 시험 설정 HTML 빌드 (teamGrpSubsbjctUseyn = 'Y' 인 경우 호출)
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
        function teamGrpSubasmtStngynChange(obj) {
            var suffix = obj.id.split("_")[1];
            if (obj.checked) {
                $("#subInfoDiv" + suffix).show();
                // 수정 진입 시 팀 그룹이 이미 선택되어 있으나 subInfoDiv가 비어있으면 데이터 로드
                var teamGrpIdVal = $("#teamGrpId" + suffix).val();
                if (teamGrpIdVal && $("#subInfoDiv" + suffix).children().length === 0) {
                    var teamGrpId  = teamGrpIdVal.split(":")[0];
                    var examBscId = $(obj).data("bscId");
                    var url  = "/exam/examTeamGrpSubAsmtListAjax.do";
                    var data = { teamGrpId: teamGrpId, examBscId: examBscId };
                    ajaxCall(url, data, function(data) {
                        if (data.result > 0) {
                            var returnList = data.returnList || [];
                            var html = "";
                            if (returnList.length > 0) {
                                html += "<table class='table-type5'>";
                                html += "	<colgroup><col class='width-10per' /><col class='' /><col class='width-10per' /></colgroup>";
                                html += "	<tbody>";
                                html += "		<tr><th><spring:message code='exam.label.team.name' /></th><th><spring:message code='exam.label.sub.tpc' /></th><th><spring:message code='exam.label.team.grp' /> <spring:message code='exam.label.team.members' /></th></tr>"; /* 팀명 */ /* 부 주제 */ /* 팀 그룹 */ /* 구성원 */
                                returnList.forEach(function(v, i) {
                                    html += "	<tr class='subQuizTr' id='" + v.teamId + "'>";
                                    html += "		<th><label>" + v.teamnm + "</label></th>";
                                    html += "		<td><table class='table-type5'><colgroup><col class='width-10per' /><col class='' /></colgroup><tbody>";
                                    html += "			<tr><th><label for='" + v.teamId + "_dtlExamTtl_" + i + "' class='req'><spring:message code='exam.label.sub.tpc' /></label></th>";  /* 부 주제 */
                                    html += "			<td><input type='text' id='" + v.teamId + "_dtlExamTtl_" + i + "' name='subExamTtl' value='" + (v.examTtl == null ? '' : v.examTtl) + "' inputmask='byte' maxLen='200' class='width-100per' /></td></tr>";
                                    html += "			<tr><th><label for='" + v.teamId + "_contentTextArea_" + i + "' class='req'><spring:message code='exam.label.cts' /></label></th>"; /* 내용 */
                                    html += "			<td><div class='editor-box'><textarea name='" + v.teamId + "_contentTextArea_" + i + "' id='" + v.teamId + "_contentTextArea_" + i + "'>" + (v.examCts == null ? '' : v.examCts) + "</textarea></div></td></tr>";
                                    html += "		</tbody></table></td>";
                                    html += "		<th>" + v.leadernm + " <spring:message code='exam.label.and' /> " + (v.teamMbrCnt - 1) + "</th>"; /* 외 */
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
                        UiComm.showMessage("<spring:message code='exam.error.copy' />", "error");   /* 가져오기 중 에러가 발생하였습니다. */
                    });
                }
            } else {
                $("#subInfoDiv" + suffix).hide();
            }
        }
        /* 3 */
        function teamGrpChcPopup(i, sbjctId) {
            dialog = UiDialog("dialog1", {
                title: "<spring:message code='exam.label.team.grp.set' />",   /*  팀 그룹 지정 */
                width: 600,
                height: 500,
                url: "/team/teamHome/teamCtgrSelectPop.do?sbjctId="+sbjctId+"&searchFrom="+i + ":" + sbjctId,
                autoresize: true
            });
        }
        /* 4 */
        function selectTeam(teamGrpId, teamGrpnm, id) {
            var idList = id.split(':');
            $("#teamGrpId" + idList[0]).val(teamGrpId + ":" + idList[1]);
            $("#teamGrpnm" + idList[0]).val(teamGrpnm);
            $("#setExamTeamDiv" + idList[0]).show();

            var url  = "/exam/examTeamGrpSubAsmtListAjax.do";
            var data = {
                teamGrpId  : teamGrpId,
                examBscId : $("#teamGrpSubasmtStngyn_" + idList[0]).data("bscid")
            };

            ajaxCall(url, data, function(data) {
                if (data.result > 0) {
                    var returnList = data.returnList || [];
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
                        html += "			<th><spring:message code='exam.label.team.name' /></th>";   /* 팀명 */
                        html += "			<th><spring:message code='exam.label.sub.tpc' /></th>"; /* 부 주제 */
                        html += "			<th><spring:message code='exam.label.team.grp' /> <spring:message code='exam.label.team.members' /></th>";   /* 팀 그룹 */ /* 구성원 */
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
                            html += "						<th><label for='" + v.teamId + "_dtlExamTtl_" + i + "' class='req'><spring:message code='exam.label.sub.tpc' /></label></th>";  /* 부 주제 */
                            html += "						<td><input type='text' id='" + v.teamId + "_dtlExamTtl_" + i + "' name='subExamTtl' value='" + (v.examTtl == null ? '' : v.examTtl) + "' inputmask='byte' maxLen='200' class='width-100per' /></td>";
                            html += "					</tr>";
                            html += "					<tr>";
                            html += "						<th><label for='" + v.teamId + "_contentTextArea_" + i + "' class='req'><spring:message code='exam.label.cts' /></label></th>"; /* 내용 */
                            html += "						<td>";
                            html += "							<div class='editor-box'>";
                            html += "								<textarea name='" + v.teamId + "_contentTextArea_" + i + "' id='" + v.teamId + "_contentTextArea_" + i + "'>" + (v.examCts == null ? '' : v.examCts) + "</textarea>";
                            html += "							</div>";
                            html += "						</td>";
                            html += "					</tr>";
                            html += "				</tbody>";
                            html += "			</table>";
                            html += "		</td>";
                            html += "		<th>" + v.leadernm + " <spring:message code='exam.label.and' /> " + (v.teamMbrCnt - 1) + "</th>";   /* 외 */
                            html += "	</tr>";
                        });
                        html += "	</tbody>";
                        html += "</table>";
                    }

                    if ($("#teamGrpSubsbjctUseyn_" + idList[0]).is(':checked')) {
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
                // teamGrpId hidden 필드 세팅
                <c:if test="${not empty examDtlInfoVO}">
                $("#teamGrpId1").val("<c:out value='${examDtlInfoVO[0].teamGrpId}'/>:<c:out value='${crsCreCd}'/>");
                </c:if>
                // 팀 그룹 설정 영역 노출
                $("#setExamTeamDiv1").show();
                // teamGrpSubsbjctUseyn = Y 인 경우 서버 데이터로 팀 시험 HTML 빌드
                if ("${examVO.teamGrpSubsbjctUseyn}" === "Y") {
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
                html += "			<th><spring:message code='exam.label.team.name' /></th>";   /* 팀명 */
                html += "			<th><spring:message code='exam.label.sub.tpc' /></th>"; /* 부 주제 */
                html += "			<th><spring:message code='exam.label.team.grp' /> <spring:message code='exam.label.team.members' /></th>";   /* 팀 그룹 */ /* 구성원 */
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
                    html += "                        <th><label for='" + v.teamId + "_dtlExamTtl_" + i + "' class='req'><spring:message code='exam.label.sub.tpc' /></label></th>"; /* 부 주제 */
                    html += "                        <td><input type='text' id='" + v.teamId + "_dtlExamTtl_" + i + "' name='subExamTtl' value='" + (v.examTtl || '') + "' inputmask='byte' maxLen='200' class='width-100per' /></td>";
                    html += "                    </tr>";
                    html += "                    <tr>";
                    html += "                        <th><label for='" + v.teamId + "_contentTextArea_" + i + "' class='req'><spring:message code='exam.label.cts' /></label></th>";    /* 내용 */
                    html += "                        <td>";
                    html += "                            <div class='editor-box'>";
                    html += "                                <textarea name='" + v.teamId + "_contentTextArea_" + i + "' id='" + v.teamId + "_contentTextArea_" + i + "'>" + v.examCts + "</textarea>";
                    html += "                            </div>";
                    html += "                        </td>";
                    html += "                    </tr>";
                    html += "                </tbody>";
                    html += "            </table>";
                    html += "        </td>";
                    html += "        <th>" + v.ldrnm + " <spring:message code='exam.label.and' /> " + (v.teamMbrTot - 1) +  " <spring:message code='exam.label.stdnt' />" + "</th>";    /* 외 */ /* 명 */
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
                UiComm.showMessage("<spring:message code='exam.alert.go.back' />", "confirm")   /* 목록으로 돌아가시겠습니까? */
                    .then(function(result) {
                        if (result) {
                            location.href = "/exam/profExamListView.do?encParams=" + EPARAM;
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

            examSaveBtnEvent();
            backToListViewBtn ();
		});

        $(window).on('load', function() {
            loadGrpInfo();
        });
    </script>
</head>

<body class="class ${uiex:getTheme()} "><!-- 컬러선택시 클래스변경 -->
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
				<!-- class_sub_top -->
				<jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
				<!-- //class_sub_top -->

                <div class="class_sub">
                    <!-- 강의실 상단 -->
                    <jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
                    <!-- 콘텐츠 영역 -->
                    <div class="sub-content">
                        <!-- 상단 영역 -->
                        <div class="board_top">
                            <i class="icon-svg-openbook"></i>
                            <h3 class="board-title">
                                <spring:message code='exam.label.exam' /><!-- 시험 -->
                                <spring:message code='exam.button.reg' /><!-- 등록 -->
                            </h3>
                            <div class="right-area">
                                <button type="button" id = "examWriteSave" class="btn type2"><spring:message code='exam.button.save' /></button><!-- 저장 -->
                                <button type="button" id = "examWriteCancle" class="btn basic"><spring:message code='exam.button.list' /></button><!-- 목록 -->
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
                                    <tbody>
                                        <!-- 시험 구분 -->
                                        <tr>
                                            <th>
                                                <label for="exam-gubun-label"><spring:message code='exam.label.exam.stare.type' /></label><!-- 시험구분 -->
                                            </th>
                                            <td>
                                                <div class="form-inline">
                                                    <span class="custom-input">
                                                        <input type="radio" name="exam-gubun-rd" id="middle-rd" value="EXAM_MID" ${examVO.examGbncd eq 'EXAM_MID' || examVO.examGbncd eq 'EXAM_MID_TEAM' || empty vo.examBscId ? 'checked' : '' }>
                                                        <label for="middle-rd"><spring:message code='exam.label.mid.exam' /></label><!-- 중간고사 -->
                                                    </span>
                                                    <span class="custom-input ml5">
                                                        <input type="radio" name="exam-gubun-rd" id="final-rd" value="EXAM_LST" ${examVO.examGbncd eq 'EXAM_LST' || examVO.examGbncd eq 'EXAM_LST_TEAM' ? 'checked' : '' }>
                                                        <label for="final-rd"><spring:message code='exam.label.end.exam' /></label><!-- 기말고사 -->
                                                    </span>
                                                    <span class="custom-input ml5">
                                                        <input type="radio" name="exam-gubun-rd" id="exam-rd" value="EXAM" ${examVO.examGbncd eq 'EXAM' || examVO.examGbncd eq 'EXAM_TEAM' ? 'checked' : '' }>
                                                        <label for="exam-rd"><spring:message code='exam.label.exam' /></label><!-- 시험 -->
                                                    </span>
                                                    <span class="custom-input ml5">
                                                        <input type="radio" name="exam-gubun-rd" id="comprehensive-rd" value="EXAM_CMP" ${examVO.examGbncd eq 'EXAM_CMP' || examVO.examGbncd eq 'EXAM_CMP_TEAM' ? 'checked' : '' }>
                                                        <label for="comprehensive-rd"><spring:message code='exam.label.cmp.exam' /></label><!-- 종합시험 -->
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 시험유형 -->
                                        <tr>
                                            <th>
                                                <label for="exam-type-label"><spring:message code='exam.label.exam.type' /></label><!-- 시험유형 -->
                                            </th>
                                            <td>
                                                <div class="form-inline">
                                                    <span class="custom-input">
                                                        <input type="radio" name="exam-type-rd" id="real-time-rd" value="RLTM" ${examVO.tkexamMthdCd eq 'RLTM' || empty vo.examBscId ? 'checked' : '' }>
                                                        <label for="real-time-rd"><spring:message code='exam.label.real.time' /> <spring:message code='exam.label.exam' /></label><!-- 실시간 --><!-- 시험 -->
                                                    </span>
                                                    <span class="custom-input">
                                                        <input type="radio" name="exam-type-rd" id="quiz-rd" value="QUIZ" ${examVO.tkexamMthdCd eq 'QUIZ' ? 'checked' : '' }>
                                                        <label for="quiz-rd"><spring:message code='exam.label.quiz' /></label><!-- 퀴즈 -->
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 시험명 -->
                                        <tr>
                                            <th>
                                                <label for="exam-ttl-label" class = "req"><spring:message code='exam.label.exam.nm' /></label><!-- 시험명 -->
                                            </th>
                                            <td>
                                                <div class="form-row">
                                                    <input class="form-control width-50per"
                                                        type="text" name="name" id="exam-ttl" value="${examVO.examTtl}"
                                                        placeholder="<spring:message code='exam.alert.input.examnm.input' />" required="true" inputmask="byte"
                                                        maxlen="150" autocomplete="off">
                                                        <!-- 시험명 입력 -->
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 시험내용 -->
                                        <tr>
                                            <th>
                                                <label for="contTextarea" class = "req"><spring:message code='exam.label.exam' /><spring:message code='exam.label.cts' /></label><!-- 시험 --><!-- 내용 -->
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
                                                <label for="noticeLabel" class = "req"><spring:message code='exam.label.exam.dttm' /></label><!-- 시험일시 -->
                                            </th>
                                            <td>
                                                <div class="date_area">
                                                    <input type="text" class="datepicker" id="dateSt" name="dateSt" timeId="timeSt" toDate="dateEd" required="true" placeholder="<spring:message code='exam.label.start.dt'/>" value="${fn:substring(examVO.examPsblSdttm,0,8)}"><!-- 시작일 -->
                                                    <input type="text" class="timepicker" id="timeSt" name="timeSt" dateId="dateSt" required="true" placeholder="<spring:message code='exam.label.start.tm'/>" value="${fn:substring(examVO.examPsblSdttm,8,12)}"><!-- 시작시간 -->
                                                    <span class="txt-sort">~</span>
                                                    <input type="text" class="datepicker" id="dateEd" name="dateEd" timeId="timeEd" fromDate="dateSt" required="true" placeholder="<spring:message code='exam.label.end.dt'/>" value="${fn:substring(examVO.examPsblEdttm,0,8)}"><!-- 종료일 -->
                                                    <input type="text" class="timepicker" id="timeEd" name="timeEd" dateId="dateEd" required="true" placeholder="<spring:message code='exam.label.end.tm'/>" value="${fn:substring(examVO.examPsblEdttm,8,12)}"><!-- 종료시간 -->
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 시험시간 -->
                                        <tr>
                                            <th>
                                                <label for="timeLabel" class = "req"><spring:message code='exam.label.exam.time'/></label><!-- 시험시간 -->
                                            </th>
                                            <td>
                                                <div class="form-row">
                                                    <div class="input_btn">
                                                        <input class="form-control sm" id="examMnts" type="text" inputmask="numeric" maxlength="3" required="true" value="${examVO.examMnts}"><label><spring:message code='exam.label.min.time'/></label><!-- 분 -->
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 성적반영 -->
                                        <tr>
                                            <th>
                                                <label for="mkr-rfltyn-label"><spring:message code="exam.label.score.aply.y" /></label><!-- 성적반영 -->
                                            </th>
                                            <td>
                                                <div class="form-inline">
                                                    <span class="custom-input">
                                                        <input type="radio" name="mkr-rfltyn-rd" id="mkr-rfltyn-y-rd" value="Y" ${examVO.mrkRfltyn eq 'Y' || empty vo.examBscId ? 'checked' : '' }>
                                                        <label for="mkr-rfltyn-y-rd"><spring:message code="exam.common.yes" /></label><!-- 예 -->
                                                    </span>
                                                    <span class="custom-input ml5">
                                                        <input type="radio" name="mkr-rfltyn-rd" id="mkr-rfltyn-n-rd" value="N" ${examVO.mrkRfltyn eq 'N' ? 'checked' : '' }>
                                                        <label for="mkr-rfltyn-n-rd"><spring:message code="exam.common.no" /></label><!-- 아니오 -->
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 성적공개 -->
                                        <tr>
                                            <th>
                                                <label for="mkr-oyn-label"><spring:message code="exam.label.score.open.y" /></label><!-- 성적공개 -->
                                            </th>
                                            <td>
                                                <div class="form-inline">
                                                    <span class="custom-input">
                                                        <input type="radio" name="mkr-oyn-rd" id="mkr-oyn-y-rd" value="Y" ${examVO.mrkOyn eq 'Y' || empty vo.examBscId ? 'checked' : '' }>
                                                        <label for="mkr-oyn-y-rd"><spring:message code="exam.common.yes" /></label><!-- 예 -->
                                                    </span>
                                                    <span class="custom-input ml5">
                                                        <input type="radio" name="mkr-oyn-rd" id="mkr-oyn-n-rd" value="N" ${examVO.mrkOyn eq 'N' ? 'checked' : '' }>
                                                        <label for="mkr-oyn-n-rd"><spring:message code="exam.common.no" /></label><!-- 아니오 -->
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 시험지 공개 -->
                                        <tr>
                                            <th>
                                                <label for="examppr-oyn-label"><spring:message code='exam.label.paper.open' /></label><!-- 시험지 공개 -->
                                            </th>
                                            <td>
                                                <div class="form-inline">
                                                    <span class="custom-input">
                                                        <input type="radio" name="examppr-oyn-rd" id="examppr-oyn-y-rd" value="Y" ${examVO.exampprOyn eq 'Y' ? 'checked' : '' }>
                                                        <label for="examppr-oyn-y-rd"><spring:message code="exam.common.yes" /></label><!-- 예 -->
                                                    </span>
                                                    <span class="custom-input ml5">
                                                        <input type="radio" name="examppr-oyn-rd" id="examppr-oyn-n-rd" value="N" ${examVO.exampprOyn eq 'N' || empty vo.examBscId ? 'checked' : '' }>
                                                        <label for="examppr-oyn-n-rd"><spring:message code="exam.common.no" /></label><!-- 아니오 -->
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 팀 시험 -->
                                        <tr>
                                            <th>
                                                <label for="exam-team-label"><spring:message code="exam.label.team" /> <spring:message code="exam.label.exam" /></label><!-- 팀 --><!-- 시험 -->
                                            </th>
                                            <td>
                                                <span class="custom-input">
                                                    <input type="radio" name="byteam-subrexam-useyn-rd" id="byteam-subrexam-useyn-y-rd" value="Y" onchange="teamynChange(this.value)" ${examVO.byteamSubrexamUseyn eq 'Y' ? 'checked' : '' }>
                                                    <label for="byteam-subrexam-useyn-y-rd"><spring:message code="exam.common.yes" /></label><!-- 예 -->
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" name="byteam-subrexam-useyn-rd" id="byteam-subrexam-useyn-n-rd" value="N" onchange="teamynChange(this.value)" ${examVO.byteamSubrexamUseyn eq 'N' || empty vo.examBscId ? 'checked' : '' }>
                                                    <label for="byteam-subrexam-useyn-n-rd"><spring:message code="exam.common.no" /></label><!-- 아니오 -->
                                                </span>
                                                <!-- 시험 기본 ID || 팀별부시험여부 = Y 일 경우 -->
                                                <div class="mt5" id = "teamDiv" ${empty vo.examBscId || examVO.byteamSubrexamUseyn ne 'Y' ? 'style="display: none"' : ''} >
                                                    <div class="form-row" id="teamGrpView">
                                                        <div class="input_btn width-100per">
                                                            <label><spring:message code="exam.label.decls" /></label><!-- 반 -->
                                                            <input type="hidden" id="teamGrpId1" name="teamGrpIds" value="">
                                                            <input class="form-control width-60per" type="text" name="teamGrpnm" id="teamGrpnm1" placeholder="팀 분류를 선택해 주세요." value="${examDtlInfoVO[0].teamGrpnm}" readonly="" autocomplete="off">
                                                            <a class="btn type1 small" onclick="teamGrpChcPopup('1',sbjctId)"><spring:message code="exam.label.team.grp.set" /></a><!-- 팀 그룹 지정 -->
                                                        </div>
                                                    </div>
                                                    <div class="form-inline">
                                                        <small class="note2">! <spring:message code="exam.alert.team.grp.warn" /></small><!-- 구성된 팀이 없는 경우 메뉴 “과목설정 > 팀 그룹지정”에서 팀을 생성해 주세요. -->
                                                    </div>
                                                    <div class="ui segment" id="setExamTeamDiv1" style="display:none;">
                                                        <span class="custom-input">
                                                            <input type="checkbox" name="teamGrpSubsbjctUseyn" id="teamGrpSubsbjctUseyn_1" value="Y"
                                                                   data-bscId="${not empty vo.examBscId ? vo.examBscId : '' }"
                                                                   onchange="teamGrpSubasmtStngynChange(this)" ${not empty vo.examBscId && examVO.teamGrpSubsbjctUseyn eq 'Y' ? 'checked' : '' }>
                                                            <label for="teamGrpSubsbjctUseyn_1"><spring:message code="exam.label.team.grp.set.exam" /></label><!-- 팀 그룹별 시험 설정 -->
                                                        </span>
                                                    </div>
                                                    <div id="subInfoDiv1" ${not empty vo.examBscId && examVO.teamGrpSubsbjctUseyn ne 'Y' ? 'style="display: none;"' : ''}></div>
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
