<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/forum2/common/forum_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
    <title>교수자 토론 목록</title>
    <script type="text/javascript">
        var SEARCH_VALUE	= '<c:out value="${dscsListVO.dscsTtl}" />';
        var PAGE_INDEX		= '<c:out value="${dscsListVO.pageIndex}" />';
        var LIST_SCALE		= '<c:out value="${dscsListVO.listScale}" />';
        var EPARAM			= '<c:out value="${encParams}" />';

        $(document).ready(function() {
            // 최초 조회
            listPaging(1);
            // 엔터키
            $("#dscsTtl").on("keydown", function(e) {
                if(e.keyCode == 13) {
                    listPaging(1);
                }
            });

            $('#btnSearch').on('click', function () {
                $('#pageIndex').val('1');
                listPaging();
            });

            $('#btnGoRegist').on('click', function () {
                goWrite('');
            });

            if(!PAGE_INDEX) {
                PAGE_INDEX = 1;
            }

            if(!LIST_SCALE) {
                LIST_SCALE = 10;
            }
        });

        let scoreInputMode = false; // 성적비율 입력 모드

        // 리스트테이블에서 모드 변경될때 이벤트
        function chanageModeEvent(mode) {
            if (mode === "card") {
                mrkRfltrtFrmTrsf(2);
            }
            else if (scoreInputMode) {
                mrkRfltrtFrmTrsf(1);
            }
        }

        // list scale 변경
        function changeListScale(scale) {
            LIST_SCALE = scale;
            listPaging(1);
        }

        function parseResult(data) {
            return {
                code: data.resultCode || data.result || data.resultStatus || 0,
                message: data.resultMessage || data.message || '',
                status: data.resultStatus || data.resultCode || data.result || 0
            };
        }

        //리스트 조회
        function listPaging(pageIndex) {
            PAGE_INDEX = pageIndex;

            var param = {
                pageIndex		: pageIndex
                , listScale		: LIST_SCALE
                , dscsTtl       : $("#dscsTtl").val()
                , sbjctId       : '<c:out value="${dscsListVO.sbjctId}" />'
            };

            var url = '<c:url value="/forum2/forumLect/profDscsList.do" />';

            UiComm.showLoading(true);
            ajaxCall(url, param, function(data) {
                UiComm.showLoading(false);
                if (data.result > 0) {
                    let returnList = data.returnList || [];

                    // 테이블 데이터 설정
                    let dataList = createDscsListHTML(returnList, data.pageInfo);
                    dscsListTable.clearData();
                    dscsListTable.replaceData(dataList);
                    dscsListTable.setPageInfo(data.pageInfo);
                    UiInputmask();
                } else {
                    UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
                }
            }, function(xhr, status, error) {
                UiComm.showLoading(false);
                UiComm.showMessage("<spring:message code='fail.common.msg'/>","error"); // 에러가 발생했습니다!
            });
        }

        /**
         * 성적 반영비율 폼 변환
         * @param {Integer} type - 변환 타입 번호 (1 : 입력폼 노출, 2 : 취소)
         */
        function mrkRfltrtFrmTrsf(type) {
            if(type == 1) {
                // 현재 테이블모드가 list 이면 성적반영비율 입력필드 표시
                if (dscsListTable.mode === "list") {
                    $("#mrkRfltrtFrmTrsfBtn").hide();
                    $(".mrkRfltrtFrmTrsfDiv").css("display", "inline-block");
                    $(".mrkInputDiv").show();
                    $(".mrkRfltrtDiv").hide();
                    UiInputmask();
                    scoreInputMode = true;
                }
                // 현재 테이블모드가 card 이며 list 모드로 변경
                else {
                    dscsListTable.changeMode("list");
                    scoreInputMode = false;
                    setTimeout(function(){
                        mrkRfltrtFrmTrsf(1);
                    },100);
                }
            } else {
                $("#mrkRfltrtFrmTrsfBtn").css("display", "inline-block");
                $(".mrkRfltrtFrmTrsfDiv").hide();
                $(".mrkInputDiv").hide();
                $(".mrkRfltrtDiv").show();
                scoreInputMode = false;
            }
        }

        // 성적 반영비율 수정
        function mrkRfltrtModify() {
            var isMrkCheck = true;
            var sumMrkRfltrt = 0;
            var dscsMrkList = [];

            $(".mrkRfltrt").each(function(i) {
                if(Number($(this).val()) < 0 || Number($(this).val()) > 100) {
                    UiComm.showMessage("점수는 100까지 입력 가능합니다.", "info");
                    isMrkCheck = false;
                    return false;
                }
                if(Number($(this).val()) == 0) {
                    UiComm.showMessage("0점은 입력할 수 없습니다. 다른 값을 입력해 주세요.", "info");
                    isMrkCheck = false;
                    return false;
                }

                sumMrkRfltrt += parseInt($(this).val(), 10);
                dscsMrkList.push({
                    dscsId : $(this).attr("data-dscsId"),
                    mrkRfltrt : $(this).val()
                });
            });

            if($(".mrkRfltrt").length == 0) {
                listPaging(1);
                return false;
            }

            if(isMrkCheck) {
                if(Number(sumMrkRfltrt) != 100) {
                    // 성적반영 비율 합이 100%가 되어야 합니다./n다시 확인 바랍니다.
                    UiComm.showMessage("<spring:message code="forum.alert.total"/>", "info");
                    return false;
                } else {
                    $.ajax({
                        url: "/forum2/forumLect/forumMrkRfltrtModifyAjax.do",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify(dscsMrkList),
                        dataType: "json",
                        beforeSend: function () {
                            UiComm.showLoading(true);
                        }
                    }).done(function(data) {
                        UiComm.showLoading(false);
                        if (data.result > 0) {
                            UiComm.showMessage("<spring:message code='success.common.save' />", "success");/* 정상 저장 되었습니다. */
                            listPaging(1);
                        } else {
                            UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
                        }
                    }).fail(function() {
                        UiComm.showLoading(false);
                        UiComm.showMessage("<spring:message code='fail.common.msg'/>","error"); // 에러가 발생했습니다!
                    });
                }
            }
        }

        function createDscsListHTML(dscsList, pageInfo) {
            let dataList = [];
            if(dscsList.length === 0) {
                return dataList;
            }

            dscsList.forEach(function(v, i) {
                var lineNo = pageInfo.totalRecordCount - v.lineNo + 1;

                let col0 = "";
                let colLabel = "";
                col0 = lineNo;

                let mrkOynHtml = '<input type="checkbox" value="Y" class="switch small" onchange="modifyMrkOyn(this, \'' + v.dscsId + '\', this.checked)"';
                if (v.mrkOyn === 'Y') {
                    mrkOynHtml += '	checked="checked">';
                } else {
                    mrkOynHtml += '>';
                }

                // 토론 제목
                var dscsTtl = v.dscsTtl.replaceAll("<", "&lt").replaceAll(">", "&gt");
                var linkUrl = 'javascript:goDscsScore(\'' + v.dscsId + '\')';
                let title = "";
                title += '<a href="' + linkUrl + '" title="' + dscsTtl + '" class="header header-icon link">';
                title += dscsTtl;
                title += '</a>';

                // 성적 반영비율
                var mrkRfltrt = "<span class='mrkInputDiv ui input' style='display:none'>";
                mrkRfltrt += "    <input type='text' class='mrkRfltrt' data-dscsId=\"" + v.dscsId + "\" value=\"" + (v.mrkRfltrt == null ? 0 : v.mrkRfltrt) + "\" inputmask='numeric' inputmode='decimal' maxVal='100' />";
                mrkRfltrt += "</span>";
                mrkRfltrt += "<span class='mrkRfltrtDiv'>" + (v.mrkRfltrt == null ? 0 : v.mrkRfltrt) + "%</span>";
                if (v.mrkRfltyn == 'N') {
                    mrkRfltrt = "0%";
                }

                // 참여현황
                var joinUserStatusHtml = "<a href='javascript:goDscsScore(\"" + v.dscsId + "\", 3)' class='fcBlue'>" + v.forumJoinUserCnt + "/" + v.forumUserTotalCnt + "</a>";

                // 평가현황
                var mrkStatusHtml = "<a href='javascript:goDscsScore(\"" + v.dscsId + "\", 3)' class='fcBlue'>" + v.forumEvalCnt + "/" + v.forumJoinUserCnt + "</a>";

                // 관리메뉴 추가
                var mngHtml = "";
                mngHtml += "<a href=\"javascript:goDscsBbs('" + v.dscsId + "')\" class=\"btn basic small\"><spring:message code='forum.label.forum.bbs'/></a>";// 토론방
                mngHtml += "<a href=\"javascript:goDscsScore('" + v.dscsId + "')\" class=\"btn basic small\"><spring:message code='forum.button.eval'/></a>"; // 토론평가
                mngHtml += "<a href=\"javascript:goWrite('" + v.dscsId + "')\" class=\"btn basic small\"><spring:message code='forum.button.mod'/></a>"; // 수정
                mngHtml += "<a href=\"javascript:deleteDscs('" + v.dscsId + "')\" class=\"btn basic small\"><spring:message code='forum.button.del'/></a>"; // 삭제

                dataList.push({
                    no: col0,
                    dscsUnitTycd: formatDscsUnitTycd(v.dscsUnitTycd),
                    dscsTtl: title,
                    dscsSdttmEdtm: UiComm.formatDate(v.dscsSdttm, 'datetime') + ' ~ ' + UiComm.formatDate(v.dscsEdttm, 'datetime'),
                    dscsAtclCnt: v.forumAtclCnt,
                    dscsCmntCnt: v.forumCmntCnt,
                    scoreRate: mrkRfltrt,
                    joinCnt: joinUserStatusHtml,
                    mrkStatus: mrkStatusHtml,
                    mrkOyn: mrkOynHtml,
                    forumJoinUserCnt: v.forumJoinUserCnt,
                    forumUserTotalCnt: v.forumUserTotalCnt,
                    mng: mngHtml,
                    valDscsId: v.dscsId,
                    label: colLabel
                });
            });

            return dataList;
        }

        function formatDscsUnitTycd(dscsUnitTycd) {
            // 팀토론 , 일반토론
            return dscsUnitTycd === 'TEAM' ? '<spring:message code='forum.label.type.teamForum'/>' : '<spring:message code='forum.label.type.forum'/>';
        }

        //성적공개여부 수정
        function modifyMrkOyn(el, dscsId) {
            var $el = $(el);
            var isChecked = $el.is(":checked");

            $el.prop("disabled", true);
            var param = {
                dscsId: dscsId
                , mrkOyn: isChecked ? 'Y' : 'N'
            };

            var url = "/forum2/forumLect/profDscsMrkOynModify.do";
            ajaxCall(url, param, function (data) {
                $el.prop("disabled", false);
                if (data.result > 0) {
                    // do something
                } else {
                    $el.prop("checked", !isChecked);
                    UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
                }
            }, function(xhr, status, error) {
                $el.prop("disabled", false);
                UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
            });
        }

        // 토론등록/수정
        function goWrite(dscsId) {
            if (dscsId != null && dscsId != "") {
                let extData = {
                    dscsId	: dscsId
                };
                location.href = "<c:url value='/forum2/forumLect/profDscsEditView.do' />?" + "encParams="+EPARAM+"&addParams="+UiComm.makeEncParams(extData) + '&sbjctId=<c:out value="${dscsListVO.sbjctId}" />';
            } else {
                let extData = {
                    dscsId	: ''
                };
                /*location.href = "<c:url value='/forum2/forumLect/profDscsWriteView.do' />?" + "encParams="+EPARAM+"&addParams="+UiComm.makeEncParams(extData);*/
                location.href = "<c:url value='/forum2/forumLect/profDscsWriteView.do' />?" + '&sbjctId=<c:out value="${dscsListVO.sbjctId}" />';
            }
        }

        // 토론방
        function goDscsBbs(dscsId) {
            location.href = '/forum2/forumLect/Form/bbsManage.do?dscsId=' + encodeURIComponent(dscsId) + '&sbjctId=<c:out value="${dscsListVO.sbjctId}" />';
        }

        // 토론평가
        function goDscsScore(dscsId) {
            location.href = '/forum2/forumLect/Form/scoreManage.do?dscsId=' + encodeURIComponent(dscsId) + '&sbjctId=<c:out value="${dscsListVO.sbjctId}" />';
        }

        // 토론삭제
        function deleteDscs(dscsId) {
            UiComm.showMessage("<spring:message code='forum.alert.confirm.delete' />", "confirm")/*  정말 토론을 삭제 하시겠습니까?  */
                .then(function(result) {
                    if (result) {
                        // '확인' 선택
                        $.ajax({
                            url: "/forum2/forumLect/profDscsDelete.do",
                            type: "POST",
                            contentType: "application/json",
                            data: JSON.stringify({dscsId:dscsId}),
                            dataType: "json",
                            beforeSend: function () {
                                UiComm.showLoading(true);
                            }
                        }).done(function(data) {
                            UiComm.showLoading(false);
                            if (data.result > 0) {
                                UiComm.showMessage("<spring:message code='success.common.save' />", "success");/* 정상 저장 되었습니다. */
                                listPaging(PAGE_INDEX);
                            } else {
                                UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
                            }
                        }).fail(function() {
                            UiComm.showLoading(false);
                            UiComm.showMessage("<spring:message code='fail.common.msg'/>","error"); // 에러가 발생했습니다!
                        });
                    }
                });
        }
    </script>
</head>
<body class="class colorA">
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <!-- classroom -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
            <!-- //gnb -->

            <div id="content" class="content-wrap common">
                <div class="class_sub_top">
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
                            <button type="button" class="btn type2"><i class="xi-log-out"></i>강의실나가기</button>
                        </div>
                    </div>
                </div>

                <div class="class_sub">
                    <!-- 강의실 상단 -->
                    <div class="segment class-area sub">
                        <div class="class_info">
                            <div class="class_tit">
                                <p class="labels">
                                    <label class="label uniA">대학원</label>
                                </p>
                                <h2>데이터베이스의 이해와 활용 1반</h2>
                            </div>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>강의실</li>
                                    <li><span class="current">토론</span></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <!-- //강의실 상단 -->

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title"><spring:message code='forum.label.forum' /></h2><%--토론--%>
                        </div>

                        <!-- List 영역 -->
                        <div id="forumListArea">
                            <div class="board_top">
                                <h3 class="board-title"><spring:message code='forum.label.list' /></h3><%--목록--%>
                                <div class="right-area">
                                    <!-- search small -->
                                    <div class="search-typeC">
                                        <input class="form-control" type="text" name="dscsTtl" id="dscsTtl" value="" placeholder="<spring:message code="forum.button.forumNm.input"/>"><%--토론명 입력--%>
                                        <button type="button" class="btn basic icon search" aria-label="검색" onclick="listPaging(1);"><i class="icon-svg-search"></i></button>
                                    </div>
                                    <div class="mrkRfltrtFrmTrsfDiv" style="display:none;">
                                        <a href="javascript:mrkRfltrtModify()" class="btn type2"><spring:message code="forum.button.scoreRatio.save" /></a><!-- 성적반영비율저장 -->
                                        <a href="javascript:mrkRfltrtFrmTrsf(2)" class="btn type2"><spring:message code="button.cancel" /></a>
                                    </div>
                                    <a href="javascript:mrkRfltrtFrmTrsf(1)" id="mrkRfltrtFrmTrsfBtn" class="btn basic"><spring:message code="forum.button.scoreRatio.change" /></a><!-- 성적반영비율조정 -->
                                    <button type="button" class="btn type2" id="btnGoRegist"><spring:message code="button.write.forum" /></button><!-- 토론 등록 -->

                                    <%-- 리스트/카드 선택 버튼 --%>
                                    <span class="list-card-button"></span>

                                    <%-- 목록 스케일 선택 --%>
                                    <uiex:listScale func="changeListScale" value="${dscsListVO.listScale}" />
                                </div>
                            </div>

                            <%-- 리스트 --%>
                            <div id="forumList"></div>

                            <%-- 카드 폼 --%>
                            <div id="forumList_cardForm" class="lecture_box" style="display:none">
                                <div class="card-header">
                                    <label class="label s_c02">#[dscsUnitTycd]</label>
                                    <div class="card-title">
                                        #[dscsTtl]
                                    </div>
                                    <div class="btn_right">
                                        <div class="dropdown">
                                            <button type="button" class="btn basic icon set settingBtn" aria-label="토론 관리" onclick="this.nextElementSibling.classList.toggle('show')">
                                                <i class="xi-ellipsis-v"></i>
                                            </button>
                                            <div class="option-wrap">
                                                <div class="item"><a href="javascript:goDscsBbs('#[valDscsId]')"><spring:message code='forum.label.forum.bbs'/></a></div><!-- 토론방 -->
                                                <div class="item"><a href="javascript:goDscsScore('#[valDscsId]')"><spring:message code='forum.button.eval'/></a></div><!-- 토론평가 -->
                                                <div class="item"><a href="javascript:goWrite('#[valDscsId]')"><spring:message code='forum.button.mod'/></a></div><!-- 수정 -->
                                                <div class="item"><a href="javascript:deleteDscs('#[valDscsId]')"><spring:message code='forum.button.del'/></a></div><!-- 삭제 -->
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="card-body">
                                    <div class="desc">
                                        <p><label class="label-title"><spring:message code='forum.label.status.join'/></label><strong>#[forumJoinUserCnt]/#[forumUserTotalCnt]</strong></p>
                                        <p><label class="label-title"><spring:message code='forum.label.forum.date'/></label><strong>#[dscsSdttmEdtm]</strong></p>
                                        <p><label class="label-title"><spring:message code='forum.label.score.ratio'/></label>#[scoreRate]</p>
                                        <p><label class="label-title"><spring:message code='forum.label.eval.status'/></label><strong>#[mrkStatus]</strong></p>
                                        <p><label class="label-title"><spring:message code='forum.label.score.open'/></label><strong>#[mrkOyn]</strong></p>
                                    </div>
                                </div>
                            </div>

                            <script>
                                <%-- 리스트 테이블 --%>
                                let dscsListTable = UiTable("forumList", {
                                    lang: "ko",
                                    pageFunc: listPaging,
                                    changeFunc: chanageModeEvent,
                                    columns: [
                                        {title:"No", 													field:"no",				headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},	// No
                                        {title:"<spring:message code='forum.label.type'/>", 			field:"dscsUnitTycd",	headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},	// 구분
                                        {title:"<spring:message code='forum.label.forum'/>", 			field:"dscsTtl", 		headerHozAlign:"center", hozAlign:"left", 	width:0, 	minWidth:100},	// 토론제목
                                        {title:"<spring:message code='forum.label.forum.date'/>", 		field:"dscsSdttmEdtm", 	headerHozAlign:"center", hozAlign:"center", width:200,	minWidth:200},	// 토론기간
                                        {title:"<spring:message code='forum.label.forum.bbsCnt'/>", 	field:"dscsAtclCnt", 	headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},	// 토론글수
                                        {title:"<spring:message code='forum.label.forum.commCnt'/>",	field:"dscsCmntCnt", 	headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},	// 댓글수
                                        {title:"<spring:message code='forum.label.score.ratio'/>", 		field:"scoreRate", 		headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},	// 성적 반영비율
                                        {title:"<spring:message code='forum.label.status.join'/>", 		field:"joinCnt", 		headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},	// 참여현황
                                        {title:"<spring:message code='forum.label.eval.status'/>", 		field:"mrkStatus", 		headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},	// 평가현황
                                        {title:"<spring:message code='forum.label.score.open'/>", 		field:"mrkOyn", 		headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},	// 성적공개
                                        {title:"<spring:message code='forum.label.manage'/>", 		    field:"mng",    		headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:300},	// 관리
                                    ]
                                });
                            </script>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>

