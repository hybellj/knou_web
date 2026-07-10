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
    const PAGE_INDEX = '<c:out value="${vo.pageIndex}" />' || 1;
    let LIST_SCALE = '<c:out value="${vo.listScale}" />';
    let EPARAM = '<c:out value="${encParams}" />';
    let TOTAL_CNT = 0;
    let CURRENT_PAGE = PAGE_INDEX;
    let popupNtcTable;

    const PNTTIME_MAP = {
        'BFLGN': '<spring:message code="msg.popupNtc.label.bflgn"/>',
        'AFLGN': '<spring:message code="msg.popupNtc.label.aflgn"/>'
    };

    const TRGT_MAP = {
        'ALL': '<spring:message code="msg.popupNtc.label.trgtAll"/>',
        'PROF': '<spring:message code="msg.popupNtc.label.trgtProf"/>',
        'TUTOR': '<spring:message code="msg.popupNtc.label.trgtTutor"/>',
        'STDNT': '<spring:message code="msg.popupNtc.label.trgtStdnt"/>'
    };

    $(document).ready(function () {
        fn_initSearch();
        if ('${vo.orgId}') $('#selectOrg').val('${vo.orgId}');
        if ('${vo.searchText}') $('#inputSearchText').val('<c:out value="${vo.searchText}"/>');
        fn_loadList(PAGE_INDEX);
    });

    function fn_initSearch() {
        $('#inputSearchText').on('keydown', function (e) {
            if (e.keyCode === 13) fn_search();
        });
    }

    function fn_search() {
        fn_loadList(1);
    }

    function fn_loadList(pageIndex) {
        CURRENT_PAGE = pageIndex;

        const extData = {
            pageIndex: pageIndex,
            listScale: LIST_SCALE,
            orgId: $('#selectOrg').val(),
            searchText: $('#inputSearchText').val()
        };

        const param = {
            encParams: EPARAM
            , addParams: UiComm.makeEncParams(extData)
        };
        ajaxCall('/admPopupNtcListAjax.do', param, function (res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0) {
                const dataList = fn_createListData(res.returnList, res.pageInfo);
                TOTAL_CNT = res.pageInfo ? res.pageInfo.totalRecordCount : 0;
                $('#totalCntText').text(TOTAL_CNT);

                popupNtcTable.clearData();
                popupNtcTable.replaceData(dataList);
                popupNtcTable.setPageInfo(res.pageInfo);
            } else {
                UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error");
            }
        }, function (xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    function fn_createListData(returnList, pageInfo) {
        const dataList = [];
        if (!returnList) return dataList;

        const startNo = pageInfo ? pageInfo.totalRecordCount - ((pageInfo.currentPageNo - 1) * LIST_SCALE) : returnList.length;

        returnList.forEach(function (v, i) {
            const periodStr = UiComm.formatDate(v.popupNtcSdttm, 'datetime2') + ' ~ ' + UiComm.formatDate(v.popupNtcEdttm, 'datetime2');
            const trgtStr = fn_convertTrgt(v.popupNtcTrgt);
            const pnttimeStr = PNTTIME_MAP[v.popupPnttimeGbncd] || v.popupPnttimeGbncd || '';
            const useynChecked = v.useyn === 'Y' ? 'checked="checked"' : '';

            const useynHtml = '<input type="checkbox" class="switch yesno small" ' + useynChecked
                + ' onchange="fn_toggleUseyn(\'' + v.popupNtcId + '\', this)">';

            const manageHtml = '<button class="btn basic small" onclick="fn_preview(\'' + v.popupNtcId + '\')">'
                + '<spring:message code="msg.popupNtc.label.preview"/></button> '
                + '<button class="btn basic small" onclick="fn_goModify(\'' + v.popupNtcId + '\')">'
                + '<spring:message code="msg.popupNtc.label.modify"/></button> '
                + '<button class="btn basic small" onclick="fn_delete(\'' + v.popupNtcId + '\')">'
                + '<spring:message code="msg.popupNtc.label.delete"/></button>';

            dataList.push({
                no: startNo - i,
                orgnm: UiComm.escapeHtml(v.orgnm || ''),
                popupNtcTtl: '<a href="javascript:fn_goDetail(\'' + v.popupNtcId + '\')" class="title link">' + UiComm.escapeHtml(v.popupNtcTtl) + '</a>',
                period: periodStr,
                trgt: trgtStr,
                pnttime: pnttimeStr,
                useyn: useynHtml,
                manage: manageHtml
            });
        });

        return dataList;
    }

    function fn_convertTrgt(trgtStr) {
        if (!trgtStr) return '';
        const codes = trgtStr.split(',');
        const names = [];
        codes.forEach(function (code) {
            const name = TRGT_MAP[code.trim()];
            if (name) names.push(name);
        });
        return names.join(', ');
    }

    function fn_changeListScale(scale) {
        LIST_SCALE = scale;
        fn_loadList(1);
    }

    function fn_goRegist() {
        location.href = '/admPopupNtcRegistView.do?encParams=' + EPARAM;
    }

    function fn_goDetail(popupNtcId) {
        location.href = '/admPopupNtcSelectView.do?encParams=' + EPARAM + '&addParams=' + UiComm.makeEncParams({popupNtcId: popupNtcId});
    }

    function fn_goModify(popupNtcId) {
        location.href = '/admPopupNtcModifyView.do?encParams=' + EPARAM + '&addParams=' + UiComm.makeEncParams({popupNtcId: popupNtcId});
    }

    function fn_toggleUseyn(popupNtcId, el) {
        const useyn = el.checked ? 'Y' : 'N';

        const param = {
            encParams: EPARAM
            , addParams: UiComm.makeEncParams({popupNtcId: popupNtcId, useyn: useyn})
        };
        ajaxCall('/admPopupNtcUseynModifyAjax.do', param, function (res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result <= 0) {
                el.checked = !el.checked;
                UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error");
            }
        }, function (xhr, status, error) {
            el.checked = !el.checked;
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    function fn_delete(popupNtcId) {
        UiComm.showMessage('<spring:message code="msg.popupNtc.msg.confirmDelete"/>', 'confirm').then(function (result) {
            if (!result) return;

            const param = {
                encParams: EPARAM
                , addParams: UiComm.makeEncParams({popupNtcId: popupNtcId})
            };
            ajaxCall('/admPopupNtcDeleteAjax.do', param, function (res) {
                if (res.encParams) EPARAM = res.encParams;
                if (res.result > 0) {
                    UiComm.showMessage('<spring:message code="msg.popupNtc.msg.deleteSuccess"/>', 'success');
                    fn_loadList(CURRENT_PAGE);
                } else {
                    UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error");
                }
            }, function (xhr, status, error) {
                UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
            }, true);
        });
    }

    function fn_preview(popupNtcId) {
        const param = {
            encParams: EPARAM
            , addParams: UiComm.makeEncParams({popupNtcId: popupNtcId})
        };
        ajaxCall('/admPopupNtcSelectAjax.do', param, function (res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0 && res.returnVO) {
                const vo = res.returnVO;
                const w = vo.popupWinWdthsz || 300;
                const h = vo.popupWinHght || 500;

                $('#previewContent').html(vo.popupNtcCts || '');
                $('#previewTdstop').toggle(vo.popupNtcTdstopUseyn === 'Y');

                const dlg = UiDialog('previewDialog', {
                    title: UiComm.escapeHtml(vo.popupNtcTtl),
                    width: w,
                    height: h,
                    html: $('#previewArea').html()
                });
            } else {
                UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error");
            }
        }, function (xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }
</script>

<body class="admin">
<div id="wrap" class="main">
    <!-- common header -->
    <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>

    <!-- admin -->
    <main class="common">

        <!-- gnb -->
        <%@ include file="/WEB-INF/jsp/common_new/admin_aside.jsp" %>

        <!-- content -->
        <div id="content" class="content-wrap common">
            <div class="admin_sub">
                <div class="sub-content">
                    <!-- page info -->
                    <div class="page-info">
                        <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                        <uiex:navibar type="admin"/>
                    </div>

                    <!-- search -->
                    <div class="search-typeA">
                        <div class="item">
                            <span class="item_tit"><spring:message code="msg.popupNtc.label.org"/></span>
                            <div class="itemList">
                                <select id="selectOrg" class="form-select">
                                    <option value=""><spring:message code="msg.sndrDsctn.label.all" text="전체"/></option>
                                    <c:forEach var="org" items="${orgList}">
                                        <option value="${org.orgId}"><c:out value="${org.orgnm}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><spring:message code="msg.popupNtc.label.search"/></span>
                            <div class="itemList">
                                <input type="text" id="inputSearchText" class="form-control wide"
                                       placeholder="<spring:message code="msg.popupNtc.label.searchPlaceholder"/>"
                                       onkeypress="if(event.keyCode==13) fn_search();">
                            </div>
                        </div>
                        <div class="button-area">
                            <button type="button" class="btn search" onclick="fn_search();"><spring:message
                                    code="msg.popupNtc.label.search"/></button>
                        </div>
                    </div>

                    <!-- board top -->
                    <div class="board_top">
                        <h3 class="board-title"><spring:message code="msg.common.label.list"/>
                        [<spring:message code="msg.sndrDsctn.label.totalCnt" text="총건수"/> : <b
                            id="totalCntText">0</b><spring:message code="msg.sndrDsctn.label.cnt" text="건"/> ]
                        </h3>
                        <div class="right-area">
                            <button type="button" class="btn type1" onclick="fn_goRegist();"><spring:message code="msg.popupNtc.label.regist"/></button>
                            <uiex:listScale func="fn_changeListScale" value="${vo.listScale}"/>
                        </div>
                    </div>

                    <!-- table -->
                    <div id="popupNtcList"></div>
                    <script>
                        popupNtcTable = UiTable("popupNtcList", {
                            lang: "ko",
                            pageFunc: fn_loadList,
                            columns: [
                                {
                                    title: '<spring:message code="msg.popupNtc.col.no"/>',
                                    field: "no",
                                    headerHozAlign: "center",
                                    hozAlign: "center",
                                    width: 60,
                                    headerSort: false
                                },
                                {
                                    title: '<spring:message code="msg.popupNtc.col.org"/>',
                                    field: "orgnm",
                                    headerHozAlign: "center",
                                    hozAlign: "center",
                                    width: 130,
                                    headerSort: false
                                },
                                {
                                    title: '<spring:message code="msg.popupNtc.col.ttl"/>',
                                    field: "popupNtcTtl",
                                    headerHozAlign: "center",
                                    hozAlign: "left",
                                    minWidth: 150,
                                    formatter: "html",
                                    headerSort: false
                                },
                                {
                                    title: '<spring:message code="msg.popupNtc.col.period"/>',
                                    field: "period",
                                    headerHozAlign: "center",
                                    hozAlign: "center",
                                    width: 280,
                                    headerSort: false
                                },
                                {
                                    title: '<spring:message code="msg.popupNtc.col.trgt"/>',
                                    field: "trgt",
                                    headerHozAlign: "center",
                                    hozAlign: "center",
                                    width: 100,
                                    headerSort: false
                                },
                                {
                                    title: '<spring:message code="msg.popupNtc.col.pnttime"/>',
                                    field: "pnttime",
                                    headerHozAlign: "center",
                                    hozAlign: "center",
                                    width: 100,
                                    headerSort: false
                                },
                                {
                                    title: '<spring:message code="msg.popupNtc.col.useyn"/>',
                                    field: "useyn",
                                    headerHozAlign: "center",
                                    hozAlign: "center",
                                    width: 80,
                                    formatter: "html",
                                    headerSort: false
                                },
                                {
                                    title: '<spring:message code="msg.popupNtc.col.manage"/>',
                                    field: "manage",
                                    headerHozAlign: "center",
                                    hozAlign: "center",
                                    width: 220,
                                    formatter: "html",
                                    headerSort: false
                                }
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
