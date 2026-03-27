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
    let currentPage = 1;
    let listScale = 10;
    let searchTable;

    $(document).ready(function() {
        fn_initFilters();
        fn_loadPopOrgList();
        fn_search(1);
    });

    /* Chosen 셀렉트박스 갱신 */
    function fn_refreshChosen(selector) {
        let $el = $(selector);
        if ($el.data('chosen')) {
            $el.chosen('destroy');
        }
        $el.chosen({disable_search: true});
    }

    /* 필터 초기화 */
    function fn_initFilters() {
        $('#popOrgId').on('change', function() { fn_loadPopDeptList(); });
        $('#popDeptId').on('change', function() { fn_loadPopSbjctList(); });
    }

    /* 기관 목록 */
    function fn_loadPopOrgList() {
        ajaxCall('/msgShrtntOrgListAjax.do', {}, function(res) {
            if (res.result > 0 && res.returnList) {
                let html = '<option value=""><spring:message code="msg.rcptnAgre.label.org" text="기관"/></option>';
                res.returnList.forEach(function(v) {
                    html += '<option value="' + v.orgId + '">' + UiComm.escapeHtml(v.orgnm) + '</option>';
                });
                $('#popOrgId').html(html);
                fn_refreshChosen('#popOrgId');
                fn_loadPopDeptList();
            }
        });
    }

    /* 학과/부서 목록 */
    function fn_loadPopDeptList() {
        ajaxCall('/msgShrtntDeptListAjax.do', { gubun: 'POPUP' }, function(res) {
            if (res.result > 0 && res.returnList) {
                let html = '<option value=""><spring:message code="msg.sndrDsctn.label.deptAll" text="학과/부서선택"/></option>';
                res.returnList.forEach(function(v) {
                    html += '<option value="' + v.deptId + '">' + UiComm.escapeHtml(v.deptnm) + '</option>';
                });
                $('#popDeptId').html(html);
                fn_refreshChosen('#popDeptId');
                fn_loadPopSbjctList();
            }
        });
    }

    /* 과목 목록 */
    function fn_loadPopSbjctList() {
        let deptId = $('#popDeptId').val();
        ajaxCall('/msgShrtntSbjctListAjax.do', { deptId: deptId, gubun: 'POPUP' }, function(res) {
            if (res.result > 0 && res.returnList) {
                let html = '<option value=""><spring:message code="msg.sndrDsctn.label.sbjctAll" text="과목선택"/></option>';
                res.returnList.forEach(function(v) {
                    html += '<option value="' + v.sbjctId + '">' + UiComm.escapeHtml(v.sbjctnm) + '</option>';
                });
                $('#popSbjctId').html(html);
                fn_refreshChosen('#popSbjctId');
            }
        });
    }

    /* 검색 */
    function fn_search(pageIndex) {
        if (pageIndex) currentPage = pageIndex;

        let param = {
            userTycd: $('#popUserTycd').val(),
            orgId: $('#popOrgId').val(),
            deptId: $('#popDeptId').val(),
            sbjctId: $('#popSbjctId').val(),
            searchText: $('#popSearchText').val(),
            gubun: 'POPUP',
            pageIndex: currentPage,
            listScale: listScale
        };

        ajaxCall('/msgShrtntRcvrSearchAjax.do', param, function(res) {
            if (res.result > 0) {
                let dataList = fn_createListData(res.returnList, res.pageInfo);
                searchTable.clearData();
                searchTable.replaceData(dataList);
                searchTable.setPageInfo(res.pageInfo);
                let total = res.pageInfo ? res.pageInfo.totalRecordCount : 0;
                $('#searchTotalCnt').text(total);
                $('#popRcvrChkAll').prop('checked', false);
            }
        }, function() {
            alert('<spring:message code="fail.common.select"/>');
        }, true);
    }

    /* 사용자구분 코드 변환 */
    let userTycdMap = {
        'STDNT': '<spring:message code="msg.rcptnAgre.label.stdnt" text="학생"/>',
        'PROF': '<spring:message code="msg.rcptnAgre.label.prof" text="교직원"/>'
    };

    /* 목록 데이터 생성 */
    function fn_createListData(list, pageInfo) {
        let dataList = [];
        if (!list || list.length === 0) return dataList;

        let total = pageInfo ? pageInfo.totalRecordCount : 0;

        list.forEach(function(v, i) {
            let rnum = total - ((currentPage - 1) * listScale) - i;
            let chkData = UiComm.escapeHtml(v.userId)
                + '" data-usernm="' + UiComm.escapeHtml(v.usernm || '')
                + '" data-stdntno="' + UiComm.escapeHtml(v.stdntNo || '')
                + '" data-rprsid="' + UiComm.escapeHtml(v.userRprsId2 || '')
                + '" data-mblphn="' + UiComm.escapeHtml(v.mblPhn || '')
                + '" data-eml="' + UiComm.escapeHtml(v.eml || '');

            dataList.push({
                chk: '<span class="custom-input onlychk"><input type="checkbox" name="popRcvrChk" id="popRcvrChk' + i + '" value="' + chkData + '"><label for="popRcvrChk' + i + '">&nbsp;</label></span>',
                no: rnum,
                userTycdNm: UiComm.escapeHtml(userTycdMap[v.userTycd] || v.userTycd || ''),
                stdntNo: UiComm.escapeHtml(v.stdntNo || ''),
                usernm: UiComm.escapeHtml(v.usernm || ''),
                deptnm: UiComm.escapeHtml(v.deptnm || ''),
                mblPhn: UiComm.escapeHtml(v.mblPhn || ''),
                rprsEml: UiComm.escapeHtml(v.eml || '')
            });
        });
        return dataList;
    }

    /* 선택 추가 */
    function fn_addSelected() {
        let checked = $('input[name=popRcvrChk]:checked');
        if (checked.length === 0) {
            alert('<spring:message code="common.item.select.msg"/>');
            return;
        }

        let selectedList = [];
        checked.each(function() {
            selectedList.push({
                userId: $(this).val(),
                usernm: $(this).data('usernm'),
                stdntNo: $(this).data('stdntno'),
                rprsId: $(this).data('rprsid'),
                mblPhn: $(this).data('mblphn'),
                eml: $(this).data('eml')
            });
        });

        if (parent && parent.fn_addSelectedRcvrs) {
            parent.fn_addSelectedRcvrs(selectedList);
        }
    }

    /* 전체 선택/해제 */
    function fn_toggleAllChk(obj) {
        $('input[name=popRcvrChk]').prop('checked', $(obj).is(':checked'));
    }

    /* 엔터키 검색 */
    function fn_searchKeyDown(e) {
        if (e.keyCode === 13) fn_search(1);
    }
</script>

<body style="margin:0; padding:15px;">
<div id="loading_page" style="display:none;"></div>

<!-- 검색 영역 -->
<div class="board_top">
    <select class="form-select" id="popUserTycd">
        <option value=""><spring:message code="msg.shrtnt.label.userTycd" text="사용자 구분"/></option>
        <option value="STDNT"><spring:message code="msg.rcptnAgre.label.stdnt" text="학생"/></option>
        <option value="PROF"><spring:message code="msg.rcptnAgre.label.prof" text="교직원"/></option>
    </select>
    <select class="form-select" id="popOrgId">
        <option value=""><spring:message code="msg.rcptnAgre.label.org" text="기관"/></option>
    </select>
    <select class="form-select wide" id="popDeptId">
        <option value=""><spring:message code="msg.sndrDsctn.label.deptAll" text="학과/부서선택"/></option>
    </select>
    <select class="form-select wide" id="popSbjctId">
        <option value=""><spring:message code="msg.sndrDsctn.label.sbjctAll" text="과목선택"/></option>
    </select>
    <div class="search-typeC">
        <input class="form-control" type="text" id="popSearchText" value="" placeholder="<spring:message code="msg.rcptnAgre.label.stdntNo" text="이름/아이디/사번 입력"/>" onkeydown="fn_searchKeyDown(event)">
        <button type="button" class="btn basic icon search" aria-label="<spring:message code="msg.shrtnt.label.rcvrSearch" text="검색"/>" onclick="fn_search(1)"><i class="icon-svg-search"></i></button>
    </div>
</div>

<!-- 결과 목록 -->
<div id="searchResultList"></div>

<script>
    searchTable = UiTable("searchResultList", {
        lang: "ko",
        pageFunc: fn_search,
        columns: [
            {title:"<span class='custom-input onlychk'><input type='checkbox' id='popRcvrChkAll' onclick='fn_toggleAllChk(this)'><label for='popRcvrChkAll'>&nbsp;</label></span>", field:"chk", headerHozAlign:"center", hozAlign:"center", width:45, minWidth:40, formatter:"html"},
            {title:"<spring:message code='msg.shrtnt.col.no' text='No'/>",                                   field:"no",         headerHozAlign:"center", hozAlign:"center", width:45,  minWidth:35},
            {title:"<spring:message code='msg.shrtnt.col.userTycd' text='사용자구분'/>",                      field:"userTycdNm", headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:60},
            {title:"<spring:message code='msg.shrtnt.col.stdntNo' text='학번/사번'/>",                        field:"stdntNo",    headerHozAlign:"center", hozAlign:"center", width:90,  minWidth:70},
            {title:"<spring:message code='msg.shrtnt.col.usernm' text='이름'/>",                              field:"usernm",     headerHozAlign:"center", hozAlign:"center", width:100, minWidth:70},
            {title:"<spring:message code='msg.shrtnt.col.deptnm' text='학과/부서'/>",                         field:"deptnm",     headerHozAlign:"center", hozAlign:"center", width:180, minWidth:100},
            {title:"<spring:message code='msg.shrtnt.col.mblPhn' text='연락처'/>",                            field:"mblPhn",     headerHozAlign:"center", hozAlign:"center", width:120, minWidth:90},
            {title:"<spring:message code='msg.shrtnt.col.eml' text='이메일'/>",                               field:"rprsEml",    headerHozAlign:"center", hozAlign:"left"}
        ]
    });
</script>

<!-- 하단 버튼 -->
<div class="modal_btns">
    <button type="button" class="btn type1" onclick="fn_addSelected()"><spring:message code="msg.shrtnt.label.addBtn" text="추가하기"/></button>
    <button type="button" class="btn type2" onclick="parent.rcvrDlg.close()"><spring:message code="msg.shrtnt.label.closeBtn" text="닫기"/></button>
</div>

</body>
</html>
