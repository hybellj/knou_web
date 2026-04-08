<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="dashboard"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>

<script type="text/javascript">
    let currentPage = 1;
    let listScale = '<c:out value="${vo.listScale}" />';
    let totalCnt = 0;
    let selectedTmpltId = '';
    let currentTab = '${vo.msgCtsGbncd eq "ORG_MSG" ? "ORG_MSG" : "INDV_MSG"}';
    let isAdmin = ${isAdmin};
    let EPARAM = '<c:out value="${encParams}" />';

    $(document).ready(function() {
        fn_loadList(1);
        fn_updateUIByTab();
    });

    /* 탭 전환 */
    function fn_changeTab(tab) {
        currentTab = tab;
        $('.tab_btn a').removeClass('current');
        if (tab === 'INDV_MSG') {
            $('.tab_btn a').eq(0).addClass('current');
        } else {
            $('.tab_btn a').eq(1).addClass('current');
        }
        fn_resetForm();
        fn_loadList(1);
        fn_updateUIByTab();
    }

    /* 검색 */
    function fn_search() {
        fn_loadList(1);
    }

    /* 검색 엔터 */
    function fn_searchKeydown(e) {
        if (e.keyCode === 13) fn_search();
    }

    /* 목록 조회 */
    function fn_loadList(pageIndex) {
        if (pageIndex) currentPage = pageIndex;

        let extData = {
            pageIndex: currentPage,
            listScale: listScale,
            msgCtsGbncd: currentTab,
            searchText: $('#inputSearch1').val()
        };

        let param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams(extData)
        };
        ajaxCall('/msgTmpltListAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0) {
                fn_renderCards(res.returnList);
                totalCnt = res.pageInfo ? res.pageInfo.totalRecordCount : 0;
                fn_renderPaging(res.pageInfo);
            } else {
                UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error");
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    /* 카드 목록 렌더링 */
    function fn_renderCards(list) {
        let $ul = $('.message_card');
        $ul.empty();

        if (!list || list.length === 0) {
            $ul.append('<li class="empty-data"><p><spring:message code="common.content.not_found"/></p></li>');
            return;
        }

        let isOrgTab = (currentTab === 'ORG_MSG');
        let canEdit = !isOrgTab || isAdmin;

        list.forEach(function(v) {
            let chkHtml = '';
            if (canEdit) {
                chkHtml = '<span class="custom-input onlychk">'
                    + '<input type="checkbox" name="chkTmplt" value="' + v.msgTmpltId + '" id="chk_' + v.msgTmpltId + '">'
                    + '<label for="chk_' + v.msgTmpltId + '"></label></span>';
            }

            let activeClass = (selectedTmpltId === v.msgTmpltId) ? ' active' : '';
            let clickAttr = canEdit ? ' onclick="fn_selectCard(\'' + v.msgTmpltId + '\')"' : '';

            let html = '<li>'
                + '<a href="javascript:void(0)" class="card_item' + activeClass + '" data-id="' + v.msgTmpltId + '"' + clickAttr + '>'
                + '<div class="item_header">'
                + chkHtml
                + '<div class="msg_tit">' + UiComm.escapeHtml(v.msgTmpltTtl || '') + '</div>'
                + '</div>'
                + '<div class="extra">'
                + '<p class="desc">' + UiComm.escapeHtml(v.msgTmpltCts || '').replace(/\n/g, '<br>') + '</p>'
                + '</div>'
                + '</a></li>';

            $ul.append(html);
        });

        $ul.find('input[type=checkbox]').on('click', function(e) {
            e.stopPropagation();
        });
    }

    /* 카드 선택 - 상세 조회 */
    function fn_selectCard(msgTmpltId) {
        selectedTmpltId = msgTmpltId;

        $('.card_item').removeClass('active');
        $('.card_item[data-id="' + msgTmpltId + '"]').addClass('active');

        let param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams({ msgTmpltId: msgTmpltId })
        };
        ajaxCall('/msgTmpltSelectAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result === 1 && res.returnVO) {
                $('#formTmpltId').val(res.returnVO.msgTmpltId);
                $('#formTmpltTtl').val(res.returnVO.msgTmpltTtl);
                $('#formTmpltCts').val(res.returnVO.msgTmpltCts);
            } else {
                UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error");
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    /* 폼 초기화 */
    function fn_resetForm() {
        selectedTmpltId = '';
        $('#formTmpltId').val('');
        $('#formTmpltTtl').val('');
        $('#formTmpltCts').val('');
    }

    /* 저장 */
    function fn_save() {
        let ttl = $('#formTmpltTtl').val().trim();
        let cts = $('#formTmpltCts').val().trim();

        if (!ttl) {
            alert('<spring:message code="msg.tmplt.label.ttl"/> <spring:message code="common.item.select.msg"/>');
            $('#formTmpltTtl').focus();
            return;
        }
        if (!cts) {
            alert('<spring:message code="msg.tmplt.label.cts"/> <spring:message code="common.item.select.msg"/>');
            $('#formTmpltCts').focus();
            return;
        }

        let tmpltId = $('#formTmpltId').val();
        let url = tmpltId ? '/msgTmpltModifyAjax.do' : '/msgTmpltRegistAjax.do';

        let extData = {
            msgTmpltTtl: ttl,
            msgTmpltCts: cts,
            msgCtsGbncd: currentTab
        };

        if (tmpltId) {
            extData.msgTmpltId = tmpltId;
        }

        let param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams(extData)
        };
        ajaxCall(url, param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result === 1) {
                fn_resetForm();
                fn_loadList(1);
            } else {
                UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error");
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    /* 선택 삭제 */
    function fn_deleteSelected() {
        let checkedIds = [];
        $('input[name=chkTmplt]:checked').each(function() {
            checkedIds.push($(this).val());
        });

        if (checkedIds.length === 0) {
            alert('<spring:message code="common.item.select.msg"/>');
            return;
        }

        if (!confirm('<spring:message code="msg.tmplt.msg.confirmDelete"/>')) return;

        let param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams({ msgTmpltIds: checkedIds })
        };
        ajaxCall('/msgTmpltDeleteAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result === 1) {
                fn_resetForm();
                fn_loadList(currentPage);
            } else {
                UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error");
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true, { traditional: true });
    }

    /* 전체 삭제 */
    function fn_deleteAll() {
        if (!confirm('<spring:message code="msg.tmplt.msg.confirmDeleteAll"/>')) return;

        let param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams({ msgCtsGbncd: currentTab })
        };
        ajaxCall('/msgTmpltAllDeleteAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result === 1) {
                fn_resetForm();
                fn_loadList(1);
            } else {
                UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error");
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    /* 엑셀 다운로드 */
    function fn_excelDown() {
        let excelGrid = { colModel: [] };
        excelGrid.colModel.push({label: '<spring:message code="msg.tmplt.col.ttl"/>', name: 'msgTmpltTtl', align: 'left', width: '8000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.tmplt.col.cts"/>', name: 'msgTmpltCts', align: 'left', width: '15000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.tmplt.col.regDttm"/>', name: 'regDttm', align: 'center', width: '5000', formatter: 'date'});

        let form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "excelForm");
        form.attr("action", "/msgTmpltExcelDown.do");
        form.append($('<input/>', { type: 'hidden', name: 'msgCtsGbncd', value: currentTab }));
        form.append($('<input/>', { type: 'hidden', name: 'searchText', value: $('#inputSearch1').val() }));
        form.append($('<input/>', { type: 'hidden', name: 'excelGrid', value: JSON.stringify(excelGrid) }));
        form.appendTo("body");
        form.submit();
        $("form[name=excelForm]").remove();
    }

    /* 페이징 렌더링 */
    function fn_renderPaging(pageInfo) {
        let $area = $('#pagingArea');
        $area.empty();

        if (!pageInfo || pageInfo.totalRecordCount === 0) return;

        let pageNo = pageInfo.currentPageNo;
        let lastPage = pageInfo.lastPageNo || Math.ceil(pageInfo.totalRecordCount / pageInfo.recordCountPerPage);
        let totalPage = pageInfo.totalPageCount || lastPage;
        let firstOnList = pageInfo.firstPageNoOnPageList || 1;
        let lastOnList = pageInfo.lastPageNoOnPageList || lastPage;
        let prev = (pageNo > 1) ? pageNo - 1 : 1;
        let next = (pageNo < lastPage) ? pageNo + 1 : lastPage;

        let html = '<div class="tabulator-footer"><div class="tabulator-footer-contents">';
        html += '<span class="tabulator-page-counter">';
        html += '<span class="total_page">전체 <b>' + pageInfo.totalRecordCount + '</b>건</span>';
        html += '<span class="current_page">현재 페이지 <strong>' + pageNo + '</strong>/' + totalPage + '</span>';
        html += '</span>';
        html += '<span class="tabulator-paginator">';
        html += '<button class="tabulator-page first" type="button" data-page="1"' + (pageNo === 1 ? ' disabled' : '') + '><i class="icon-page-first"></i></button>';
        html += '<button class="tabulator-page" type="button" data-page="' + prev + '"' + (pageNo === 1 ? ' disabled' : '') + '><i class="icon-page-prev"></i></button>';
        html += '<span class="tabulator-pages">';

        for (let i = firstOnList; i <= lastOnList; i++) {
            html += '<button class="tabulator-page' + (i === pageNo ? ' active' : '') + '" type="button" data-page="' + i + '">' + i + '</button>';
        }

        html += '</span>';
        html += '<button class="tabulator-page" type="button" data-page="' + next + '"' + (pageNo === lastPage ? ' disabled' : '') + '><i class="icon-page-next"></i></button>';
        html += '<button class="tabulator-page" type="button" data-page="' + lastPage + '"' + (pageNo === lastPage ? ' disabled' : '') + '><i class="icon-page-last"></i></button>';
        html += '</span>';
        html += '</div></div>';

        $area.html(html);
        $area.find('.tabulator-page').on('click', function() {
            if ($(this).prop('disabled')) return;
            let page = parseInt($(this).attr('data-page'));
            if (page !== pageNo) fn_loadList(page);
        });
    }

    /* 탭별 UI 업데이트 */
    function fn_updateUIByTab() {
        let isOrgTab = (currentTab === 'ORG_MSG');
        let canEdit = !isOrgTab || isAdmin;

        if (canEdit) {
            $('#btnExcel, #btnDelete, #btnDeleteAll').show();
            $('.tmplt-form-area').show();
        } else {
            $('#btnExcel, #btnDelete, #btnDeleteAll').hide();
            $('.tmplt-form-area').hide();
        }

        if (isOrgTab) {
            $('#boardTitle').text('<spring:message code="msg.tmplt.label.orgMsg" text="기관 문구"/>');
            $('#radioGbnLabel').text('<spring:message code="msg.tmplt.label.orgMsg" text="기관 문구"/>');
            $('#formTitle').text('<spring:message code="msg.tmplt.label.formTitleOrg" text="기관 문구 등록/수정"/>');
        } else {
            $('#boardTitle').text('<spring:message code="msg.tmplt.label.indvMsg" text="개인 문구"/>');
            $('#radioGbnLabel').text('<spring:message code="msg.tmplt.label.indvMsg" text="개인 문구"/>');
            $('#formTitle').text('<spring:message code="msg.tmplt.label.formTitleIndv" text="개인 문구 등록/수정"/>');
        }
    }
</script>

<body class="home colorA ${bodyClass}">
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp"/>
        <!-- //common header -->

        <!-- dashboard -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="dashboard_sub">

                    <div class="sub-content">
                        <!-- page-info -->
                        <div class="page-info">
                            <h2 class="page-title"><span><spring:message code="msg.sndrDsctn.label.msgBox" text="메시지함"/></span><spring:message code="msg.tmplt.label.title" text="메시지 문구 관리"/></h2>
                            <uiex:navibar type="main"/>
                        </div>
                        <!-- //page-info -->

                        <!-- board_top -->
                        <div class="board_top">
                            <h3 id="boardTitle" class="board-title"><spring:message code="msg.tmplt.label.indvMsg" text="개인 문구"/></h3>
                            <div class="right-area">
                                <!-- Tab btn -->
                                <div class="tab_btn">
                                    <a href="javascript:void(0)" class="<c:if test="${vo.msgCtsGbncd ne 'ORG_MSG'}">current</c:if>" onclick="fn_changeTab('INDV_MSG')"><spring:message code="msg.tmplt.label.indvMsg" text="개인 문구"/></a>
                                    <a href="javascript:void(0)" class="<c:if test="${vo.msgCtsGbncd eq 'ORG_MSG'}">current</c:if>" onclick="fn_changeTab('ORG_MSG')"><spring:message code="msg.tmplt.label.orgMsg" text="기관 문구"/></a>
                                </div>
                                <!-- search small -->
                                <div class="search-typeC">
                                    <input class="form-control" type="text" id="inputSearch1" value="<c:out value="${vo.searchText}"/>" placeholder="<spring:message code="msg.tmplt.label.searchPlaceholder" text="제목/내용 검색"/>" onkeydown="fn_searchKeydown(event)">
                                    <button type="button" class="btn basic icon search" aria-label="<spring:message code="msg.tmplt.label.search" text="검색"/>" onclick="fn_search()"><i class="icon-svg-search"></i></button>
                                </div>
                                <button type="button" id="btnExcel" class="btn basic" onclick="fn_excelDown()"><spring:message code="msg.tmplt.label.excelDown" text="엑셀 다운로드"/></button>
                                <button type="button" id="btnDelete" class="btn basic" onclick="fn_deleteSelected()"><spring:message code="msg.tmplt.label.delete" text="삭제"/></button>
                                <button type="button" id="btnDeleteAll" class="btn basic" onclick="fn_deleteAll()"><spring:message code="msg.tmplt.label.deleteAll" text="전체삭제"/></button>
                            </div>
                        </div>
                        <!-- //board_top -->

                        <!-- 문구 카드 목록 -->
                        <div class="message_list">
                            <ul class="message_card"></ul>
                        </div>

                        <!-- paging -->
                        <div id="pagingArea" class="tabulator"></div>

                        <!-- 등록/수정 폼 -->
                        <div class="tmplt-form-area">
                            <h4 id="formTitle" class="sub-title"><spring:message code="msg.tmplt.label.formTitleIndv" text="개인 문구 등록/수정"/></h4>
                            <input type="hidden" id="formTmpltId" value="" />
                            <div class="table-wrap">
                                <table class="table-type5">
                                    <colgroup>
                                        <col class="width-15per" />
                                        <col />
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                            <th><label for="formTmpltTtl"><spring:message code="msg.tmplt.label.ttl" text="제목"/></label></th>
                                            <td>
                                                <div class="form-row">
                                                    <input class="form-control width-100per" type="text" id="formTmpltTtl" placeholder="<spring:message code="msg.tmplt.label.ttlPlaceholder" text="제목 입력"/>" maxlength="200">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><label for="formTmpltCts"><spring:message code="msg.tmplt.label.cts" text="내용"/></label></th>
                                            <td>
                                                <label class="width-100per"><textarea rows="4" class="form-control resize-none" id="formTmpltCts" placeholder="<spring:message code="msg.tmplt.label.ctsPlaceholder" text="내용 입력"/>" maxlength="4000"></textarea></label>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="btns">
                                <button type="button" class="btn type1" onclick="fn_save()"><spring:message code="msg.tmplt.label.save" text="저장"/></button>
                            </div>
                        </div>
                        <!-- //등록/수정 폼 -->

                    </div>

                </div>
            </div>
            <!-- //content -->

            <!-- common footer -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
            <!-- //common footer -->

        </main>
        <!-- //dashboard-->

    </div>

</body>
</html>
