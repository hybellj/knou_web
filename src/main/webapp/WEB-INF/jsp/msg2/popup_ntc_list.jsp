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
    let listScale = ${pageSize};
    let totalCnt = 0;
    let popupNtcTable;

    let PNTTIME_MAP = {
        'BFLGN': '<spring:message code="msg.popupNtc.label.bflgn"/>',
        'AFLGN': '<spring:message code="msg.popupNtc.label.aflgn"/>'
    };

    let TRGT_MAP = {
        'ALL': '<spring:message code="msg.popupNtc.label.trgtAll"/>',
        'PROF': '<spring:message code="msg.popupNtc.label.trgtProf"/>',
        'TUTOR': '<spring:message code="msg.popupNtc.label.trgtTutor"/>',
        'STDNT': '<spring:message code="msg.popupNtc.label.trgtStdnt"/>'
    };

    $(document).ready(function() {
        fn_loadOrgList();
        fn_loadList(1);
    });

    /* 기관 목록 조회 */
    function fn_loadOrgList() {
        ajaxCall('/popupNtcOrgListAjax.do', {}, function(res) {
            let $sel = $('#selectOrg');
            $sel.find('option:gt(0)').remove();
            if (res.result > 0 && res.returnList) {
                res.returnList.forEach(function(v) {
                    $sel.append('<option value="' + v.orgId + '">' + (v.orgNm || '') + '</option>');
                });
            }
            $sel.trigger('chosen:updated');
        });
    }

    /* 검색 */
    function fn_search() {
        fn_loadList(1);
    }

    /* 목록 조회 */
    function fn_loadList(pageIndex) {
        currentPage = pageIndex;

        let param = {
            pageIndex: pageIndex,
            listScale: listScale,
            orgId: $('#selectOrg').val(),
            searchText: $('#searchText').val()
        };

        ajaxCall('/popupNtcListAjax.do', param, function(res) {
            if (res.result > 0) {
                let dataList = fn_createListData(res.returnList, res.pageInfo);
                totalCnt = res.pageInfo ? res.pageInfo.totalRecordCount : 0;
                $('#totalCnt').text(totalCnt);

                popupNtcTable.clearData();
                popupNtcTable.replaceData(dataList);
                popupNtcTable.setPageInfo(res.pageInfo);
            } else {
                alert(res.message || '<spring:message code="fail.common.select"/>');
            }
        }, function() {
            alert('<spring:message code="fail.common.select"/>');
        }, true);
    }

    /* 데이터 가공 */
    function fn_createListData(returnList, pageInfo) {
        let dataList = [];
        if (!returnList) return dataList;

        let startNo = pageInfo ? pageInfo.totalRecordCount - ((pageInfo.currentPageNo - 1) * listScale) : returnList.length;

        returnList.forEach(function(v, i) {
            let periodStr = UiComm.formatDate(v.popupNtcSdttm, 'datetime') + ' ~ ' + UiComm.formatDate(v.popupNtcEdttm, 'datetime');
            let trgtStr = fn_convertTrgt(v.popupNtcTrgt);
            let pnttimeStr = PNTTIME_MAP[v.popupPnttimeGbncd] || v.popupPnttimeGbncd || '';
            let useynChecked = v.useyn === 'Y' ? 'checked="checked"' : '';

            let useynHtml = '<input type="checkbox" class="switch yesno small" ' + useynChecked
                + ' onchange="fn_toggleUseyn(\'' + v.popupNtcId + '\', this)">';

            let manageHtml = '<button class="btn basic small" onclick="fn_preview(\'' + v.popupNtcId + '\')">'
                + '<spring:message code="msg.popupNtc.label.preview"/></button> '
                + '<button class="btn basic small" onclick="fn_goModify(\'' + v.popupNtcId + '\')">'
                + '<spring:message code="msg.popupNtc.label.modify"/></button> '
                + '<button class="btn basic small" onclick="fn_delete(\'' + v.popupNtcId + '\')">'
                + '<spring:message code="msg.popupNtc.label.delete"/></button>';

            dataList.push({
                no: startNo - i,
                orgNm: UiComm.escapeHtml(v.orgNm || ''),
                popupNtcTtl: '<a href="javascript:fn_goDetail(\'' + v.popupNtcId + '\')">' + UiComm.escapeHtml(v.popupNtcTtl) + '</a>',
                period: periodStr,
                trgt: trgtStr,
                pnttime: pnttimeStr,
                useyn: useynHtml,
                manage: manageHtml
            });
        });

        return dataList;
    }

    /* 공지대상 코드 변환 */
    function fn_convertTrgt(trgtStr) {
        if (!trgtStr) return '';
        let codes = trgtStr.split(',');
        let names = [];
        codes.forEach(function(code) {
            let name = TRGT_MAP[code.trim()];
            if (name) names.push(name);
        });
        return names.join(', ');
    }

    /* 페이지 스케일 변경 */
    function fn_changeListScale(scale) {
        listScale = scale;
        fn_loadList(1);
    }

    /* 등록 화면 이동 */
    function fn_goRegist() {
        location.href = '/popupNtcRegist.do';
    }

    /* 상세보기 화면 이동 */
    function fn_goDetail(popupNtcId) {
        location.href = '/popupNtcDetail.do?popupNtcId=' + popupNtcId;
    }

    /* 수정 화면 이동 */
    function fn_goModify(popupNtcId) {
        location.href = '/popupNtcModify.do?popupNtcId=' + popupNtcId;
    }

    /* 전시여부 토글 */
    function fn_toggleUseyn(popupNtcId, el) {
        let useyn = el.checked ? 'Y' : 'N';

        ajaxCall('/popupNtcUseynModifyAjax.do', {popupNtcId: popupNtcId, useyn: useyn}, function(res) {
            if (res.result <= 0) {
                el.checked = !el.checked;
                alert(res.message || '<spring:message code="fail.common.update"/>');
            }
        }, function() {
            el.checked = !el.checked;
            alert('<spring:message code="fail.common.update"/>');
        });
    }

    /* 삭제 */
    function fn_delete(popupNtcId) {
        if (!confirm('<spring:message code="msg.popupNtc.msg.confirmDelete"/>')) return;

        ajaxCall('/popupNtcDeleteAjax.do', {popupNtcId: popupNtcId}, function(res) {
            if (res.result > 0) {
                alert('<spring:message code="msg.popupNtc.msg.deleteSuccess"/>');
                fn_loadList(currentPage);
            } else {
                alert(res.message || '<spring:message code="fail.common.delete"/>');
            }
        }, function() {
            alert('<spring:message code="fail.common.delete"/>');
        }, true);
    }

    /* 미리보기 */
    function fn_preview(popupNtcId) {
        ajaxCall('/popupNtcSelectAjax.do', {popupNtcId: popupNtcId}, function(res) {
            if (res.result > 0 && res.returnVO) {
                let vo = res.returnVO;
                let w = vo.popupWinWdthsz || 300;
                let h = vo.popupWinHght || 500;

                $('#previewContent').html(vo.popupNtcCts || '');
                $('#previewTdstop').toggle(vo.popupNtcTdstopUseyn === 'Y');

                let dlg = UiDialog('previewDialog', {
                    title: UiComm.escapeHtml(vo.popupNtcTtl),
                    width: w,
                    height: h,
                    html: $('#previewArea').html()
                });
            } else {
                alert(res.message || '<spring:message code="fail.common.select"/>');
            }
        }, function() {
            alert('<spring:message code="fail.common.select"/>');
        }, true);
    }
</script>

<body class="admin">
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/admin_header.jsp"/>

        <!-- admin -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/admin_aside.jsp"/>

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="admin_sub">

                    <div class="sub-content">
                        <!-- page info -->
                        <div class="page-info">
                            <h2 class="page-title"><spring:message code="msg.popupNtc.label.title"/></h2>
                        </div>

                        <!-- search -->
                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><spring:message code="msg.popupNtc.label.org"/></span>
                                <div class="itemList">
                                    <select id="selectOrg" class="form-select">
                                        <option value=""><spring:message code="msg.popupNtc.label.orgAll"/></option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><spring:message code="msg.popupNtc.label.search"/></span>
                                <div class="itemList">
                                    <input type="text" id="searchText" class="form-control wide" placeholder="<spring:message code="msg.popupNtc.label.searchPlaceholder"/>" onkeypress="if(event.keyCode==13) fn_search();">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="fn_search();"><spring:message code="msg.popupNtc.label.search"/></button>
                            </div>
                        </div>

                        <!-- board top -->
                        <div class="board_top">
                            <div class="left">
                                <span class="total"><spring:message code="msg.popupNtc.label.totalCnt"/> : <strong id="totalCnt">0</strong> <spring:message code="msg.popupNtc.label.cnt"/></span>
                            </div>
                            <div class="right-area">
                                <button type="button" class="btn type1" onclick="fn_goRegist();"><spring:message code="msg.popupNtc.label.regist"/></button>
                                <uiex:listScale func="fn_changeListScale" value="${pageSize}"/>
                            </div>
                        </div>

                        <!-- table -->
                        <div id="popupNtcList"></div>
                        <script>
                            popupNtcTable = UiTable("popupNtcList", {
                                lang: "ko",
                                pageFunc: fn_loadList,
                                columns: [
                                    {title: '<spring:message code="msg.popupNtc.col.no"/>', field: "no", headerHozAlign: "center", hozAlign: "center", width: 60, headerSort: false},
                                    {title: '<spring:message code="msg.popupNtc.col.org"/>', field: "orgNm", headerHozAlign: "center", hozAlign: "center", width: 130, headerSort: false},
                                    {title: '<spring:message code="msg.popupNtc.col.ttl"/>', field: "popupNtcTtl", headerHozAlign: "center", hozAlign: "left", minWidth: 150, formatter: "html", headerSort: false},
                                    {title: '<spring:message code="msg.popupNtc.col.period"/>', field: "period", headerHozAlign: "center", hozAlign: "center", width: 280, headerSort: false},
                                    {title: '<spring:message code="msg.popupNtc.col.trgt"/>', field: "trgt", headerHozAlign: "center", hozAlign: "center", width: 100, headerSort: false},
                                    {title: '<spring:message code="msg.popupNtc.col.pnttime"/>', field: "pnttime", headerHozAlign: "center", hozAlign: "center", width: 100, headerSort: false},
                                    {title: '<spring:message code="msg.popupNtc.col.useyn"/>', field: "useyn", headerHozAlign: "center", hozAlign: "center", width: 80, formatter: "html", headerSort: false},
                                    {title: '<spring:message code="msg.popupNtc.col.manage"/>', field: "manage", headerHozAlign: "center", hozAlign: "center", width: 220, formatter: "html", headerSort: false}
                                ]
                            });
                        </script>

                    </div>
                </div>
            </div>
            <!-- //content -->

            <!-- preview hidden area -->
            <div id="previewArea" style="display:none;">
                <div style="padding:15px;">
                    <div id="previewContent"></div>
                    <div id="previewTdstop" style="margin-top:10px; padding-top:10px; border-top:1px solid #ddd; display:none;">
                        <span class="custom-input"><input type="checkbox" id="previewTdstopChk"><label for="previewTdstopChk"><spring:message code="msg.popupNtc.label.tdstop"/></label></span>
                    </div>
                </div>
            </div>

        </main>
        <!-- //admin -->
    </div>
</body>
</html>
