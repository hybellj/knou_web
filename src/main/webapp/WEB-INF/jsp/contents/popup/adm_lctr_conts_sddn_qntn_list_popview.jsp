<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
    <script type="text/javascript">
        var ORG_ID = '<c:out value="${orgId}" />';
        var SBJCT_ID = '<c:out value="${contsSddnQstnPageInfo.sbjctId}" />';
        var PAGE_INDEX = 1;
        var LIST_SCALE = 10;

        $(document).ready(function() {
            selectAdmSddnQstnList(1);
        });

        // 완료된 돌발퀴즈 목록을 조회한다.
        function selectAdmSddnQstnList(pageIndex) {
            PAGE_INDEX = pageIndex || 1;
            ajaxCall("/contents/admConts/admLctrContsSddnQstnList.do", {
                orgId: ORG_ID,
                sbjctId: SBJCT_ID,
                searchValue: "",
                currentPageNo: PAGE_INDEX,
                recordCountPerPage: LIST_SCALE,
                pageSize: 10
            }, function(res) {
                if(res.result > 0) {
                    var dataList = createSddnQstnListData(res.returnList || [], res.pageInfo);
                    sddnQstnListTable.clearData();
                    sddnQstnListTable.replaceData(dataList);
                    sddnQstnListTable.setPageInfo(res.pageInfo);
                } else {
                    UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error"); /* 에러가 발생했습니다! */
                }
            }, function() {
                UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error"); /* 에러가 발생했습니다! */
            });
        }

        // 서버 응답 돌발퀴즈 목록을 UiTable 데이터 형식으로 변환한다.
        function createSddnQstnListData(list, pageInfo) {
            var dataList = [];
            (list || []).forEach(function(item) {
                var row = {};
                row.no = pageInfo.totalRecordCount - item.lineNo + 1;
                row.qstnTtl = escapeHtml(item.qstnTtl || "-");
                row.sbjctnm = escapeHtml(item.sbjctnm || "-");
                row.qstnCnt = escapeHtml(item.qstnCnt || "0");
                row.regDttm = escapeHtml(item.regDttm || "-");
                row.select = '<button type="button" class="btn basic small" onclick="chooseSddnQstn(\'' + escapeJs(item.exrcsSddnQstnBscId || "") + '\', \'' + escapeJs(item.qstnTtl || "") + '\')"><spring:message code="contents.label.test.paper.select"/></button>'; /* 시험지 선택 */
                dataList.push(row);
            });
            return dataList;
        }

        // 선택한 돌발퀴즈를 부모 팝업으로 전달한다.
        function chooseSddnQstn(exrcsSddnQstnBscId, qstnTtl) {
            if(window.parent && window.parent !== window && typeof window.parent.selectSddnQstn === "function") {
                window.parent.selectSddnQstn({
                    exrcsSddnQstnBscId: exrcsSddnQstnBscId,
                    qstnTtl: qstnTtl
                });
            }
        }

        // HTML 표시값을 이스케이프한다.
        function escapeHtml(value) {
            return String(value == null ? "" : value)
                    .replace(/&/g, "&amp;")
                    .replace(/</g, "&lt;")
                    .replace(/>/g, "&gt;")
                    .replace(/"/g, "&quot;")
                    .replace(/'/g, "&#39;");
        }

        // 문자열을 인라인 JavaScript 인자로 사용할 수 있게 이스케이프한다.
        function escapeJs(value) {
            return String(value == null ? "" : value)
                    .replace(/\\/g, "\\\\")
                    .replace(/'/g, "\\'")
                    .replace(/\r/g, "")
                    .replace(/\n/g, " ");
        }
    </script>
</head>
<body class="modal-page">
    <div class="wrap">
        <div id="sddnQstnList"></div>
        <script type="text/javascript">
            var sddnQstnListTable = UiTable("sddnQstnList", {
                lang: "ko",
                pageFunc: selectAdmSddnQstnList,
                columns: [
                    {title:"No", field:"no", headerHozAlign:"center", hozAlign:"center", width:50, minWidth:50},
                    {title:"<spring:message code='contents.label.subject.name'/>" /* 과목명 */, field:"sbjctnm", headerHozAlign:"center", hozAlign:"left", width:180, minWidth:140},
                    {title:"<spring:message code='contents.label.title'/>" /* 콘텐츠제목 */, field:"qstnTtl", headerHozAlign:"center", hozAlign:"left", width:0, minWidth:220},
                    {title:"<spring:message code='contents.label.quiz'/>" /* 연습문제 */, field:"qstnCnt", headerHozAlign:"center", hozAlign:"right", width:90, minWidth:80},
                    {title:"<spring:message code='contents.label.management'/>" /* 관리 */, field:"select", headerHozAlign:"center", hozAlign:"center", width:120, minWidth:100}
                ]
            });
        </script>

        <div class="btns">
            <button type="button" class="btn type2" onclick="if(window.parent && window.parent.closeSddnQstnListPop){window.parent.closeSddnQstnListPop();}"><spring:message code="common.button.close"/><%-- 닫기 --%></button>
        </div>
    </div>
</body>
</html>
