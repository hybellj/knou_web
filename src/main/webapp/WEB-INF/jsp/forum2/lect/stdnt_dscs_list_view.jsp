<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/forum2/common/dscs_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
    <script type="text/javascript">
    var SEARCH_VALUE = '<c:out value="${dscsListVO.searchValue}" />';
    var PAGE_INDEX = '<c:out value="${dscsListVO.pageIndex}" />';
    var LIST_SCALE = '<c:out value="${dscsListVO.listScale}" />';
    var EPARAM = '<c:out value="${encParams}" />';
    var dialog;

    $(document).ready(function() {
        listPaging(PAGE_INDEX || 1);

        $("#searchValue").on("keydown", function(e) {
            if (e.keyCode == 13) {
                e.preventDefault();
                listPaging(1);
            }
        });

        if (!LIST_SCALE) {
            LIST_SCALE = 10;
        }
    });

    // 목록 표시 개수를 변경한다.
    function changeListScale(scale) {
        LIST_SCALE = scale;
        listPaging(1);
    }

    // 토론 목록을 조회하고 테이블을 갱신한다.
    function listPaging(pageIndex) {
        PAGE_INDEX = pageIndex || 1;
        SEARCH_VALUE = $("#searchValue").val();

        var extData = {
            pageIndex: PAGE_INDEX,
            listScale: LIST_SCALE,
            searchValue: SEARCH_VALUE
        };

        var param = {
            encParams: EPARAM,
            addParams: UiComm.makeEncParams(extData)
        };

        ajaxCall("/forum2/forumHome/forumList.do", param, function(data) {
            if (data.encParams != null && data.encParams != "") {
                EPARAM = data.encParams;
            }

            if (data.result > 0) {
                var returnList = data.returnList || [];
                var dataList = createDscsListHTML(returnList, data.pageInfo);
                dscsListTable.clearData();
                dscsListTable.replaceData(dataList);
                dscsListTable.setPageInfo(data.pageInfo);
            } else {
                UiComm.showMessage(data.message || "<spring:message code='forum.common.error'/>", "error"); // 오류가 발생했습니다!
            }
        }, function() {
            UiComm.showMessage("<spring:message code='forum.common.error'/>", "error"); // 오류가 발생했습니다!
        }, true);
    }

    // 조회된 토론 목록을 화면 표시용 데이터로 변환한다.
    function createDscsListHTML(dscsList, pageInfo) {
        var dataList = [];
        if (dscsList.length === 0) {
            return dataList;
        }

        dscsList.forEach(function(v) {
            var lineNo = pageInfo.totalRecordCount - v.lineNo + 1;
            var learnerDscsId = v.learnerDscsId || v.dscsId;
            var learnerTeamId = v.learnerTeamId || "";
            var joined = toInt(v.dscsMyAtclCnt) > 0;
            var title = "";
            var safeTitle = escHtml(v.dscsTtl || "");

            title += '<a href="javascript:goDscsPtcp(\'' + v.dscsId + '\')" title="' + safeTitle + '" class="header header-icon link">';
            title += safeTitle;
            title += '</a>';

            var joinStatusHtml = joined
                ? "<span class='fcBlue'><spring:message code='forum.label.join'/></span>" /* 참여 */
                : "<span><spring:message code='forum.label.not.join'/></span>"; /* 미참여 */

            var feedbackHtml = "<a href=\"javascript:feedbackView('"
                + safeJs(learnerDscsId) + "', '"
                + safeJs(learnerTeamId) + "', '"
                + safeJs(v.sbjctId || "") + "')\" class=\"link\">"
                + toInt(v.dscsFdbkCnt) + "</a>";

            var mngHtml = "";
            mngHtml += "<div style='display:flex;align-items:center;justify-content:center;gap:0 3px'>";
            mngHtml += "<a href=\"javascript:goDscsBbs('" + v.dscsId + "')\" class=\"btn basic small\"><spring:message code='forum.label.forum.bbs'/></a>"; // 토론방
            mngHtml += "&nbsp;</div>"

            dataList.push({
                no: lineNo,
                dscsUnitTycd: formatDscsUnitTycd(v.dscsUnitTycd),
                dscsTtl: title,
                dscsSdttmEdtm: formatDateRange(v.dscsSdttm, v.dscsEdttm),
                dscsAtclCnt: toInt(v.dscsMyAtclCnt),
                dscsCmntCnt: toInt(v.dscsMyCmntCnt),
                mrkRfltyn: escHtml(v.mrkRfltyn || "N"),
                progressStatus: formatProgressStatus(v.dscsSdttm, v.dscsEdttm),
                joinStatus: joinStatusHtml,
                score: formatScore(v),
                feedback: feedbackHtml,
                mng: mngHtml,
                dscsUserTotalCnt: toInt(v.dscsUserTotalCnt),
                dscsJoinUserCnt: toInt(v.dscsJoinUserCnt),
                valDscsId: v.dscsId,
                label: ""
            });
        });

        return dataList;
    }

    // 토론 구분 코드를 표시명으로 변환한다.
    function formatDscsUnitTycd(dscsUnitTycd) {
        return dscsUnitTycd === "TEAM" ? "<spring:message code='forum.label.type.teamForum'/>" /* 팀토론 */ : "<spring:message code='forum.label.type.forum'/>" /* 일반토론 */;
    }

    // 상세 화면 이동 URL을 생성한다.
    function buildDetailUrl(path, dscsId) {
        var url = path + "?dscsId=" + encodeURIComponent(dscsId);
        if (EPARAM) {
            url += "&encParams=" + encodeURIComponent(EPARAM);
        }
        return url;
    }

    // 토론정보 및 참여 화면으로 이동한다.
    function goDscsPtcp(dscsId) {
        location.href = buildDetailUrl("/forum2/forumHome/Form/stdntPtcpStatusView.do", dscsId);
    }

    // 토론방 화면으로 이동한다.
    function goDscsBbs(dscsId) {
        location.href = buildDetailUrl("/forum2/forumHome/Form/stdntBbsView.do", dscsId);
    }

    // 피드백 팝업을 표시한다.
    function feedbackView(dscsId, teamId, sbjctId) {
        var url = "/forum2/forumHome/dscsFdbkPop.do";
        url += "?dscsId=" + encodeURIComponent(dscsId || "");
        url += "&teamId=" + encodeURIComponent(teamId || "");
        url += "&encParams=" + encodeURIComponent(EPARAM || "");
        dialog = UiDialog("dialog1", {
            title: "<spring:message code='forum.label.feedback'/>", // 피드백
            width: 800,
            height: 600,
            url: url,
            modal: true
        });
    }

    // 참여기간 표시 문구를 생성한다.
    function formatDateRange(start, end) {
        return UiComm.formatDate(start, "datetime") + " ~ " + UiComm.formatDate(end, "datetime");
    }

    // 현재 시각 기준 진행상태를 판단한다.
    function formatProgressStatus(start, end) {
        var now = getCurrentDttm();
        var startDttm = normalizeDttm(start);
        var endDttm = normalizeDttm(end);

        if (startDttm && now < startDttm) {
            return "<spring:message code='forum.label.progress.before'/>"; // 진행 전
        }
        if (endDttm && now > endDttm) {
            return "<spring:message code='forum.label.progress.end'/>"; // 마감
        }
        return "<spring:message code='forum.label.progress.ing'/>"; // 진행 중
    }

    // 현재 일시를 비교용 문자열로 생성한다.
    function getCurrentDttm() {
        var now = new Date();
        return String(now.getFullYear())
            + pad2(now.getMonth() + 1)
            + pad2(now.getDate())
            + pad2(now.getHours())
            + pad2(now.getMinutes())
            + pad2(now.getSeconds());
    }

    // 일시 값을 비교 가능한 형식으로 정리한다.
    function normalizeDttm(value) {
        var dttm = String(value || "").replace(/[^0-9]/g, "");
        if (dttm.length === 8) {
            return dttm + "000000";
        }
        return dttm.length >= 14 ? dttm.substring(0, 14) : "";
    }

    // 숫자를 두 자리 문자열로 보정한다.
    function pad2(value) {
        return value < 10 ? "0" + value : String(value);
    }

    // 평가점수 노출 여부와 표시값을 처리한다.
    function formatScore(item) {
        if (item.mrkOyn !== "Y" || item.scr == null || item.scr === "") {
            return "-";
        }
        return escHtml(item.scr);
    }

    // 값을 숫자로 변환한다.
    function toInt(value) {
        return value == null ? 0 : Number(value);
    }

    // 자바스크립트 문자열 값을 이스케이프한다.
    function safeJs(value) {
        return String(value || "").replace(/\\/g, "\\\\").replace(/'/g, "\\'");
    }

    // HTML 출력 값을 이스케이프한다.
    function escHtml(value) {
        return String(value || "")
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#39;");
    }
    </script>
</head>
<body class="class ${uiex:getTheme()}">
    <div id="wrap" class="main">
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>

        <main class="common">
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_stu.jsp"/>

            <div id="content" class="content-wrap common">
                <jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>

                <div class="class_sub">
                    <jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title"><spring:message code='forum.label.forum' /></h2><%-- 토론 --%>
                        </div>

                        <div id="forumListArea">
                            <div class="board_top">
                                <h3 class="board-title"><spring:message code='forum.label.list' /></h3><%-- 목록 --%>
                                <div class="right-area">
                                    <div class="search-typeC">
                                        <input class="form-control" type="text" name="searchValue" id="searchValue" value="${dscsListVO.searchValue}" placeholder="<spring:message code="forum.button.forumNm.input"/>"><%-- 토론명 입력 --%>
                                        <button type="button" class="btn basic icon search" aria-label="search" onclick="listPaging(1)"><i class="icon-svg-search"></i></button>
                                    </div>
                                    <span class="list-card-button"></span>
                                    <uiex:listScale func="changeListScale" value="${dscsListVO.listScale}" />
                                </div>
                            </div>

                            <div id="forumList"></div>

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
                                                <div class="item"><a href="javascript:goDscsBbs('#[valDscsId]')"><spring:message code='forum.label.forum.bbs'/></a></div><%-- 토론방 --%>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="card-body">
                                    <div class="desc">
                                        <%--<p><label class="label-title"><spring:message code='forum.label.status.join'/></label>#[joinStatus]</p>--%><%-- 참여현황 --%>
                                        <p><label class="label-title"><spring:message code='forum.label.forum.date'/></label><strong>#[dscsSdttmEdtm]</strong></p><%-- 참여기간 --%>
                                        <%--<p><label class="label-title"><spring:message code='forum.label.forum.bbsCnt'/></label><strong>#[dscsAtclCnt]</strong></p>--%><%-- 토론 글수 --%>
                                        <%--<p><label class="label-title"><spring:message code='forum.label.forum.commCnt'/></label><strong>#[dscsCmntCnt]</strong></p>--%><%-- 댓글수 --%>
                                        <p><label class="label-title"><spring:message code='forum.label.scoreAply'/></label><strong>#[mrkRfltyn]</strong></p><%-- 성적반영 --%>
                                        <%--<p><label class="label-title"><spring:message code='forum.label.progress.status'/></label><strong>#[progressStatus]</strong></p>--%><%-- 진행상태 --%>
                                        <p><label class="label-title"><spring:message code='forum.label.eval.score'/></label><strong>#[score]</strong></p><%-- 평가점수 --%>
                                        <p><label class="label-title"><spring:message code='forum.label.feedback'/></label><strong>#[feedback]</strong></p><%-- 피드백 --%>
                                    </div>
                                </div>
                            </div>

                            <script>
                                let dscsListTable = UiTable("forumList", {
                                    lang: "ko",
                                    pageFunc: listPaging,
                                    columns: [
                                        {title:"No.", field:"no", headerHozAlign:"center", hozAlign:"center", width:40, minWidth:40},
                                        {title:"<spring:message code='forum.label.type'/>", field:"dscsUnitTycd", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100}, <%-- 구분 --%>
                                        {title:"<spring:message code='forum.label.forum'/>", field:"dscsTtl", headerHozAlign:"center", hozAlign:"left", width:0, minWidth:200, frozen:true}, <%-- 토론 --%>
                                        {title:"<spring:message code='forum.label.forum.date'/>", field:"dscsSdttmEdtm", headerHozAlign:"center", hozAlign:"center", width:200, minWidth:200}, <%-- 참여기간 --%>
                                        {title:"<spring:message code='forum.label.forum.bbsCnt'/>", field:"dscsAtclCnt", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100}, <%-- 토론 글수 --%>
                                        {title:"<spring:message code='forum.label.forum.commCnt'/>", field:"dscsCmntCnt", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100}, <%-- 댓글수 --%>
                                        {title:"<spring:message code='forum.label.scoreAply'/>", field:"mrkRfltyn", headerHozAlign:"center", hozAlign:"center", width:90, minWidth:90}, <%-- 성적반영 --%>
                                        {title:"<spring:message code='forum.label.progress.status'/>", field:"progressStatus", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100}, <%-- 진행상태 --%>
                                        {title:"<spring:message code='forum.label.join.yn'/>", field:"joinStatus", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100}, <%-- 참여여부 --%>
                                        {title:"<spring:message code='forum.label.eval.score'/>", field:"score", headerHozAlign:"center", hozAlign:"center", width:90, minWidth:90}, <%-- 평가점수 --%>
                                        {title:"<spring:message code='forum.label.feedback'/>", field:"feedback", headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80}, <%-- 피드백 --%>
                                        {title:"<spring:message code='forum.label.manage'/>", field:"mng", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100} <%-- 관리 --%>
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
