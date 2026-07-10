<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>
<body class="modal-page rubricmng-pop">
<div id="wrap">
    <div class="table-wrap margin-bottom-4">
        <div id="rubricMngPopList"></div>
    </div>
    <div class="btns">
        <button type="button" class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="common.button.close"/><%--닫기--%></button>
    </div>
</div>

<script type="text/javascript">
    var PAGE_INDEX = 1;
    var LIST_SCALE = 10;
    var CTX = '<%=request.getContextPath()%>';
    var orgId = '<c:out value="${vo.orgId}"/>';
    var rubricMngPopTable = null;

    $(function() {
        fn_initTable();
        fn_loadList(1);
    });

    function fn_initTable() {
        if (rubricMngPopTable) {
            return;
        }

        rubricMngPopTable = UiTable("rubricMngPopList", {
            lang: "ko",
            pageFunc: fn_loadList,
            columns: [
                {title: "No", field: "lineNo", headerHozAlign: "center", hozAlign: "center", width: 60, minWidth: 60, headerSort: false},
                {title: "<spring:message code='crs.label.rubric.name' /><%--루브릭명--%>", field: "rubricTtl", headerHozAlign: "center", hozAlign: "left", minWidth: 220, widthGrow: 2, headerSort: false},
                {title: "<spring:message code='common.label.qstn.count' /><%--문항수--%>", field: "rubricQstnCnt", headerHozAlign: "center", hozAlign: "center", width: 90, minWidth: 90, headerSort: false},
                {title: "<spring:message code='common.button.choice' /><%--선택--%>", field: "manage", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100, formatter: "html", headerSort: false}
            ]
        });
    }

    function fn_loadList(pageIndex) {
        PAGE_INDEX = pageIndex || 1;

        ajaxCall(CTX + "/rubricmng/admListRubricMng.do", {
            orgId: orgId,
            pageIndex: PAGE_INDEX,
            listScale: LIST_SCALE
        }, function(res) {
            if (res.result > 0) {
                if (res.pageInfo && res.pageInfo.recordCountPerPage) {
                    LIST_SCALE = Number(res.pageInfo.recordCountPerPage) || LIST_SCALE;
                }
                rubricMngPopTable.clearData();
                rubricMngPopTable.replaceData(fn_makeRowData(res.returnList || [], res.pageInfo));
                rubricMngPopTable.setPageInfo(res.pageInfo);
            } else {
                UiComm.showMessage(res.message, "warning");
            }
        }, function() {
            UiComm.showMessage("<spring:message code='fail.common.select' /><%--조회에 실패하였습니다.--%>", "error");
        }, false);
    }

    function fn_makeRowData(list, pageInfo) {
        var pageScale = pageInfo && pageInfo.recordCountPerPage ? Number(pageInfo.recordCountPerPage) : LIST_SCALE;
        pageScale = pageScale || 10;
        var totalCount = pageInfo && pageInfo.totalRecordCount ? Number(pageInfo.totalRecordCount) : list.length;

        return $.map(list, function(item, index) {
            var rowNo = Number(item.lineNo || item.LINE_NO || 0);
            var displayNo = rowNo > 0 ? totalCount - rowNo + 1 : totalCount - (((pageInfo ? pageInfo.currentPageNo : 1) - 1) * pageScale) - index;
            var targetOrgId = item.orgId || item.ORG_ID || orgId;
            var rubricId = item.rubricId || item.RUBRIC_ID || "";

            return {
                lineNo: displayNo,
                rubricTtl: item.rubricTtl || item.RUBRIC_TTL || "",
                rubricQstnCnt: item.rubricQstnCnt || item.RUBRIC_QSTN_CNT || 0,
                manage: "<div class='flex-item-center'><button type='button' class='btn basic small' onclick=\"fn_import('" + targetOrgId + "', '" + rubricId + "');\"><spring:message code='common.button.choice' /><%--선택--%></button></div>"
            };
        });
    }

    function fn_import(targetOrgId, rubricId) {
        ajaxCall(CTX + "/rubricmng/admListRubricMngInfo.do", {
            orgId: targetOrgId || orgId,
            rubricId: rubricId
        }, function(data) {
            window.parent.loadRubricImport(data || []);
            window.parent.closeDialog();
        }, function() {
            UiComm.showMessage("<spring:message code='crs.rubric.mng.error.info' /><%--루브릭 정보를 불러오는 중 오류가 발생하였습니다.--%>", "error");
        }, false);
    }
</script>
<script type="text/javascript" src="<c:url value='/webdoc/js/iframe-content.js'/>"></script>
</body>
</html>
