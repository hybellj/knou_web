<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>
<body class="admin ${bodyClass}">
<div id="wrap" class="main rubricmng-page">
    <jsp:include page="/WEB-INF/jsp/common_new/admin_header.jsp"/>

    <main class="common">
        <jsp:include page="/WEB-INF/jsp/common_new/admin_aside.jsp"/>

        <div id="content" class="content-wrap common">
            <div class="admin_sub">
                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                        <uiex:navibar type="admin"/>
                    </div>

                    <div class="search-typeA">
                        <div class="item">
                            <span class="item_tit"><spring:message code="common.label.org"/><%--기관--%></span>
                            <div class="itemList">
                                <select id="searchOrgId" class="form-select type-num w300">
                                    <c:if test="${allOrgYn eq 'Y'}">
                                        <option value=""><spring:message code="common.all"/><%--전체--%></option>
                                    </c:if>
                                    <c:forEach var="org" items="${orgInfoList}">
                                        <option value="${org.orgId}" <c:if test="${org.orgId eq vo.orgId}">selected="selected"</c:if>><c:out value="${empty org.orgNm ? org.orgnm : org.orgNm}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="button-area">
                            <button type="button" class="btn search" onclick="fn_loadRubricMngList(1);"><spring:message code="common.button.search"/><%--검색--%></button>
                        </div>
                    </div>

                    <div class="board_top">
                        <h3 class="board-title"><spring:message code="common.button.list"/><%--목록--%></h3>
                        <span class="total_num"><spring:message code="crs.rubric.mng.total.prefix"/><%--총--%> <strong id="totalCnt">0</strong> <spring:message code="crs.rubric.mng.total.suffix"/><%--건--%></span>
                        <div class="right-area">
                            <button type="button" class="btn type2" onclick="fn_goWrite();"><spring:message code="common.button.create"/><%--등록--%></button>
                            <uiex:listScale func="fn_changeListScale" value="${empty vo.listScale ? 20 : vo.listScale}"/>
                        </div>
                    </div>

                    <div id="rubricMngList"></div>
                </div>
            </div>
        </div>
    </main>
</div>

<script type="text/javascript">
    var PAGE_INDEX = Number('<c:out value="${vo.pageIndex}"/>') || 1;
    var LIST_SCALE = Number('<c:out value="${vo.listScale}"/>') || 20;
    var EPARAM = '<c:out value="${encParams}"/>';
    var MENU_ID = '<c:out value="${vo.menuId}"/>';
    var CTX = '<%=request.getContextPath()%>';
    var rubricMngTable = null;

    $(function() {
        fn_initRubricMngTable();
        fn_loadRubricMngList(PAGE_INDEX);
    });

    function fn_initRubricMngTable() {
        if (rubricMngTable) {
            return;
        }

        rubricMngTable = UiTable("rubricMngList", {
            lang: "ko",
            pageFunc: fn_loadRubricMngList,
            columns: [
                {title: "No", field: "lineNo", headerHozAlign: "center", hozAlign: "center", width: 60, minWidth: 60, headerSort: false},
                {title: "<spring:message code='crs.label.rubric.name' /><%--루브릭명--%>", field: "rubricTtl", headerHozAlign: "center", hozAlign: "left", minWidth: 260, widthGrow: 2, headerSort: false},
                {title: "<spring:message code='common.label.qstn.count' /><%--문항수--%>", field: "rubricQstnCnt", headerHozAlign: "center", hozAlign: "center", width: 90, minWidth: 90, headerSort: false},
                {title: "<spring:message code='common.registrant' /><%--등록자--%>", field: "rgtrnm", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120, headerSort: false},
                {title: "<spring:message code='common.registration.date' /><%--등록일자--%>", field: "regDttm", headerHozAlign: "center", hozAlign: "center", width: 150, minWidth: 150, headerSort: false},
                {title: "<spring:message code='common.label.use.type.yn' /><%--사용여부--%>", field: "useyn", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100, formatter: "html", headerSort: false},
                {title: "<spring:message code='crs.rubric.mng.manage' /><%--관리--%>", field: "manage", headerHozAlign: "center", hozAlign: "center", width: 150, minWidth: 150, formatter: "html", headerSort: false}
            ]
        });
    }

    function fn_changeListScale(scale) {
        LIST_SCALE = Number(scale) || 20;
        fn_loadRubricMngList(1);
    }

    function fn_getSearchOrgId() {
        return $("#searchOrgId").val() || "";
    }

    function fn_makeSearchParams(pageIndex) {
        return {
            orgId: fn_getSearchOrgId(),
            pageIndex: pageIndex,
            listScale: LIST_SCALE
        };
    }

    function fn_formatDate(value) {
        var raw = String(value || "").replace(/[^0-9]/g, "");
        if (raw.length >= 12) {
            return raw.substring(0, 4) + "." + raw.substring(4, 6) + "." + raw.substring(6, 8)
                + " " + raw.substring(8, 10) + ":" + raw.substring(10, 12);
        }
        return value || "";
    }

    function fn_makeRowData(list, pageInfo) {
        var pageScale = pageInfo && pageInfo.recordCountPerPage ? Number(pageInfo.recordCountPerPage) : LIST_SCALE;
        pageScale = pageScale || 20;
        var totalCount = pageInfo && pageInfo.totalRecordCount ? Number(pageInfo.totalRecordCount) : list.length;

        return $.map(list, function(item, index) {
            var rowNo = Number(item.lineNo || item.LINE_NO || 0);
            var displayNo = rowNo > 0 ? totalCount - rowNo + 1 : totalCount - (((pageInfo ? pageInfo.currentPageNo : 1) - 1) * pageScale) - index;
            var rubricId = item.rubricId || item.RUBRIC_ID || "";
            var orgId = item.orgId || item.ORG_ID || fn_getSearchOrgId();
            var useynVal = item.useyn || item.USEYN || "N";

            return {
                lineNo: displayNo,
                rubricTtl: item.rubricTtl || item.RUBRIC_TTL || "",
                rubricQstnCnt: item.rubricQstnCnt || item.RUBRIC_QSTN_CNT || 0,
                rgtrnm: item.rgtrnm || item.RGTRNM || "",
                regDttm: fn_formatDate(item.regDttm || item.REG_DTTM || ""),
                useyn: "<input type='checkbox' value='" + rubricId + "' class='switch small' " + (useynVal === "Y" ? "checked='checked'" : "") + " onchange=\"fn_changeUseyn(this, '" + orgId + "', '" + rubricId + "');\">",
                manage: "<div class='form-inline justify-content-center'>"
                    + "<button type='button' class='btn basic small' onclick=\"fn_goWrite('" + rubricId + "', '" + orgId + "');\"><spring:message code='common.button.modify' /><%--수정--%></button>"
                    + "<button type='button' class='btn basic small' onclick=\"fn_deleteRubric('" + orgId + "', '" + rubricId + "');\"><spring:message code='common.button.delete' /><%--삭제--%></button>"
                    + "</div>"
            };
        });
    }

    function fn_loadRubricMngList(pageIndex) {
        PAGE_INDEX = pageIndex || 1;

        ajaxCall(CTX + "/rubricmng/admListRubricMng.do", {
            encParams: EPARAM,
            addParams: UiComm.makeEncParams(fn_makeSearchParams(PAGE_INDEX))
        }, function(res) {
            if (res.encParams) {
                EPARAM = res.encParams;
            }

            if (res.result > 0) {
                if (res.pageInfo && res.pageInfo.recordCountPerPage) {
                    LIST_SCALE = Number(res.pageInfo.recordCountPerPage) || LIST_SCALE;
                }
                var rowData = fn_makeRowData(res.returnList || [], res.pageInfo);
                $("#totalCnt").text(res.pageInfo ? res.pageInfo.totalRecordCount : rowData.length);
                rubricMngTable.clearData();
                rubricMngTable.replaceData(rowData);
                rubricMngTable.setPageInfo(res.pageInfo);
            } else {
                $("#totalCnt").text(0);
                rubricMngTable.clearData();
                rubricMngTable.replaceData([]);
                UiComm.showMessage(res.message, "warning");
            }
        }, function() {
            $("#totalCnt").text(0);
            rubricMngTable.clearData();
            rubricMngTable.replaceData([]);
            UiComm.showMessage("<spring:message code='fail.common.select' /><%--조회에 실패하였습니다.--%>", "error");
        }, false);
    }

    function fn_goWrite(rubricId, orgId) {
        var targetOrgId = orgId || fn_getSearchOrgId();
        var addParams = UiComm.makeEncParams({
            rubricId: rubricId || "",
            orgId: targetOrgId || ""
        });
        var params = [];

        if (EPARAM) {
            params.push("encParams=" + encodeURIComponent(EPARAM));
        }
        params.push("addParams=" + encodeURIComponent(addParams));

        location.href = fn_appendMenuId(CTX + "/rubricmng/admRubricMngWrite.do" + (params.length > 0 ? "?" + params.join("&") : ""));
    }

    function fn_appendMenuId(url) {
        if (!MENU_ID) {
            return url;
        }
        return url + (url.indexOf("?") > -1 ? "&" : "?") + "menuId=" + encodeURIComponent(MENU_ID);
    }

    function fn_changeUseyn(obj, orgId, rubricId) {
        ajaxCall(CTX + "/rubricmng/admRubricMngUseynModify.do", {
            rubricId: rubricId,
            orgId: orgId,
            useyn: obj.checked ? "Y" : "N"
        }, function(res) {
            if (res.result <= 0) {
                obj.checked = !obj.checked;
                UiComm.showMessage(res.message, "warning");
            }
        }, function() {
            obj.checked = !obj.checked;
            UiComm.showMessage("<spring:message code='crs.error.rubric.useyn' /><%--루브릭 사용여부 변경 중 에러가 발생했습니다.--%>", "error");
        }, false);
    }

    function fn_deleteRubric(orgId, rubricId) {
        UiComm.showMessage("<spring:message code='crs.confirm.rubric.delete' /><%--루브릭을 삭제 하시겠습니까?--%>", "confirm").then(function(result) {
            if (!result) {
                return;
            }

            ajaxCall(CTX + "/rubricmng/admRubricMngDelete.do", {
                rubricId: rubricId,
                orgId: orgId
            }, function(res) {
                if (res.result > 0) {
                    UiComm.showMessage("<spring:message code='success.common.delete' /><%--정상적으로 삭제되었습니다.--%>", "success");
                    fn_loadRubricMngList(PAGE_INDEX);
                } else {
                    UiComm.showMessage(res.message, "warning");
                }
            }, function() {
                UiComm.showMessage("<spring:message code='crs.error.rubric.delete' /><%--루브릭 삭제가 실패하였습니다. 다시 시도해주세요.--%>", "error");
            }, false);
        });
    }
</script>
</body>
</html>
