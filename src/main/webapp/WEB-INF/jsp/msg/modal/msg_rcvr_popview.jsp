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

<script type="text/javascript">
    let EPARAM = '<c:out value="${encParams}" />';
    const IS_ADMIN = '<c:out value="${isAdmin}" />' === 'true';
    const MGR_PREFIX = IS_ADMIN ? '/admMsgMgr' : '/msgMgr';
    let currentPage = 1;
    const listScale = 10;
    let searchTable;

    $(document).ready(function() {
        fn_initFilters();
        fn_loadPopOrgList();
    });

    function fn_refreshChosen(selector) {
        const $el = $(selector);
        if ($el.data('chosen')) {
            $el.chosen('destroy');
        }
        $el.chosen({disable_search: true});
    }

    function fn_initFilters() {
        $('#popOrgId').on('change', function() { fn_loadPopSbjctList(); });
    }

    function fn_loadPopOrgList() {
        ajaxCall(MGR_PREFIX + 'OrgListAjax.do', { encParams: EPARAM }, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0 && res.returnList) {
                let html = '<option value=""><spring:message code="msg.modal.org" text="기관"/></option>';
                res.returnList.forEach(function(v) {
                    html += '<option value="' + v.orgId + '">' + UiComm.escapeHtml(v.orgnm) + '</option>';
                });
                $('#popOrgId').html(html);
                fn_refreshChosen('#popOrgId');
                fn_loadPopSbjctList();
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>","error");
        });
    }

    function fn_loadPopSbjctList() {
        const param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams({ orgId: $('#popOrgId').val(), gubun: 'POPUP' })
        };
        ajaxCall(MGR_PREFIX + 'SbjctListAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0 && res.returnList) {
                let html = '<option value=""><spring:message code="msg.modal.sbjctSelect" text="과목선택"/></option>';
                res.returnList.forEach(function(v) {
                    html += '<option value="' + v.sbjctId + '">' + UiComm.escapeHtml(v.sbjctnm) + '</option>';
                });
                $('#popSbjctId').html(html);
                fn_refreshChosen('#popSbjctId');
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>","error");
        });
    }

    function fn_search(pageIndex) {
        if (pageIndex) currentPage = pageIndex;

        const extData = {
            userTycd: $('#popUserTycd').val(),
            orgId: $('#popOrgId').val(),
            sbjctId: $('#popSbjctId').val(),
            searchText: $('#popSearchText').val(),
            gubun: 'POPUP',
            pageIndex: currentPage,
            listScale: listScale
        };

        const param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams(extData)
        };
        ajaxCall(MGR_PREFIX + 'RcvrSearchAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0) {
                const dataList = fn_createListData(res.returnList, res.pageInfo);
                searchTable.clearData();
                searchTable.replaceData(dataList);
                searchTable.setPageInfo(res.pageInfo);
                const total = res.pageInfo ? res.pageInfo.totalRecordCount : 0;
                $('#searchTotalCnt').text(total);
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    const userTycdMap = {};
    <c:if test="${isAdmin}">
    userTycdMap['ADM'] = '<spring:message code="msg.modal.staff" text="교직원"/>';
    </c:if>
    <c:forEach var="uty" items="${userTycdList}">
    userTycdMap['<c:out value="${uty.authrtCd}"/>'] = '<c:out value="${uty.authrtnm}"/>';
    </c:forEach>

    function fn_createListData(list, pageInfo) {
        const dataList = [];
        if (!list || list.length === 0) return dataList;

        const total = pageInfo ? pageInfo.totalRecordCount : 0;

        list.forEach(function(v, i) {
            const rnum = total - ((currentPage - 1) * listScale) - i;
            dataList.push({
                no: rnum,
                userId: v.userId || '',
                userTycdNm: userTycdMap[v.userTycd] || v.userTycd || '',
                stdntNo: v.stdntNo || '',
                usernm: v.usernm || '',
                mblPhn: v.mblPhn || '',
                eml: v.eml || ''
            });
        });
        return dataList;
    }

    function fn_addSelected() {
        const rows = searchTable.getSelectedRows();
        if (!rows || rows.length === 0) {
            UiComm.showMessage('<spring:message code="common.item.select.msg"/>', 'warning');
            return;
        }

        const selectedList = [];
        rows.forEach(function(row) {
            const d = row.getData();
            selectedList.push({
                userId: d.userId,
                usernm: d.usernm,
                stdntNo: d.stdntNo,
                mblPhn: d.mblPhn,
                eml: d.eml
            });
        });

        if (parent && parent.fn_addSelectedRcvrs) {
            parent.fn_addSelectedRcvrs(selectedList);
        }
    }

    function fn_searchKeyDown(e) {
        if (e.keyCode === 13) fn_search(1);
    }
</script>

<body style="margin:0; padding:15px;">
<div id="loading_page" style="display:none;"></div>

<!-- 검색 영역 -->
<div class="board_top">
    <select class="form-select" id="popUserTycd">
        <option value=""><spring:message code="msg.modal.userTycd" text="사용자 구분"/></option>
        <c:if test="${isAdmin}">
            <option value="ADM"><spring:message code="msg.modal.staff" text="교직원"/></option>
        </c:if>
        <c:forEach var="uty" items="${userTycdList}">
            <option value="<c:out value='${uty.authrtCd}'/>"><c:out value="${uty.authrtnm}"/></option>
        </c:forEach>
    </select>
    <select class="form-select" id="popOrgId">
        <option value=""><spring:message code="msg.modal.org" text="기관"/></option>
    </select>
    <select class="form-select wide" id="popSbjctId">
        <option value=""><spring:message code="msg.modal.sbjctSelect" text="과목선택"/></option>
    </select>
    <div class="search-typeC">
        <input class="form-control" type="text" id="popSearchText" value="" placeholder="<spring:message code="msg.modal.userSearchPlaceholder" text="이름/아이디/사번 입력"/>" onkeydown="fn_searchKeyDown(event)">
        <button type="button" class="btn basic icon search" aria-label="<spring:message code="msg.modal.search" text="검색"/>" onclick="fn_search(1)"><i class="icon-svg-search"></i></button>
    </div>
</div>

<!-- 결과 목록 -->
<div id="searchResultList"></div>

<script>
    searchTable = UiTable("searchResultList", {
        lang: "ko",
        selectRow: "checkbox",
        pageFunc: fn_search,
        columns: [
            {title:"<spring:message code='msg.modal.col.no' text='No'/>",                  field:"no",         headerHozAlign:"center", hozAlign:"center", width:45,  minWidth:35},
            {title:"<spring:message code='msg.modal.col.userTycd' text='사용자구분'/>",     field:"userTycdNm", headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:60},
            {title:"<spring:message code='msg.modal.col.stdntNo' text='학번/사번'/>",       field:"stdntNo",    headerHozAlign:"center", hozAlign:"center", width:90,  minWidth:70},
            {title:"<spring:message code='msg.modal.col.usernm' text='이름'/>",             field:"usernm",     headerHozAlign:"center", hozAlign:"center", width:100, minWidth:70},
            {title:"<spring:message code='msg.modal.col.mblPhn' text='연락처'/>",           field:"mblPhn",     headerHozAlign:"center", hozAlign:"center", width:120, minWidth:90},
            {title:"<spring:message code='msg.modal.col.eml' text='이메일'/>",              field:"eml",        headerHozAlign:"center", hozAlign:"left"}
        ]
    });
</script>

<!-- 하단 버튼 -->
<div class="modal_btns">
    <button type="button" class="btn type1" onclick="fn_addSelected()"><spring:message code="msg.modal.addBtn" text="추가하기"/></button>
    <button type="button" class="btn type2" onclick="parent.rcvrDlg.close()"><spring:message code="msg.modal.close" text="닫기"/></button>
</div>

</body>
</html>
