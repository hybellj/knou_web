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
    const PAGE_INDEX  = '<c:out value="${vo.pageIndex}" />' || 1;
    const LIST_SCALE  = '<c:out value="${vo.listScale}" />';
    const IS_ADMIN    = ${isAdmin};
    let EPARAM        = '<c:out value="${encParams}" />';
    let TOTAL_CNT     = 0;
    let CURRENT_PAGE  = PAGE_INDEX;
    let CURRENT_TAB   = '${vo.msgCtsGbncd eq "ORG_MSG" ? "ORG_MSG" : "INDV_MSG"}';
    let SELECTED_TMPLT_ID = '';

    $(document).ready(function() {
        fn_initSearch();
        fn_updateUIByTab();
        fn_loadList(PAGE_INDEX);
    });

    function fn_initSearch() {
        $('#inputSearch1').on('keydown', function(e) {
            if (e.keyCode === 13) fn_search();
        });
    }

    function fn_changeTab(tab) {
        CURRENT_TAB = tab;
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

    function fn_search() {
        fn_loadList(1);
    }

    function fn_loadList(pageIndex) {
        CURRENT_PAGE = pageIndex;

        const extData = {
            pageIndex: pageIndex,
            listScale: LIST_SCALE,
            msgCtsGbncd: CURRENT_TAB,
            searchText: $('#inputSearch1').val()
        };

        const param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams(extData)
        };
        ajaxCall('/admMsgTmpltListAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0) {
                fn_renderCards(res.returnList);
                TOTAL_CNT = res.pageInfo ? res.pageInfo.totalRecordCount : 0;
                $('#totalCnt').text(TOTAL_CNT);
                UiComm.showPaging('pagingArea', { pageInfo: res.pageInfo, pageFunc: fn_loadList });
            } else {
                UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error");
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    function fn_renderCards(list) {
        const $ul = $('.message_card');
        $ul.empty();

        if (!list || list.length === 0) {
            $ul.append('<li class="empty-data"><p><spring:message code="common.content.not_found"/></p></li>');
            return;
        }

        const isOrgTab = (CURRENT_TAB === 'ORG_MSG');
        const canEdit = !isOrgTab || IS_ADMIN;

        list.forEach(function(v) {
            let chkHtml = '';
            if (canEdit) {
                chkHtml = '<span class="custom-input onlychk">'
                    + '<input type="checkbox" name="chkTmplt" value="' + v.msgTmpltId + '" id="chk_' + v.msgTmpltId + '">'
                    + '<label for="chk_' + v.msgTmpltId + '"></label></span>';
            }

            const activeClass = (SELECTED_TMPLT_ID === v.msgTmpltId) ? ' active' : '';
            const clickAttr = canEdit ? ' onclick="fn_selectCard(\'' + v.msgTmpltId + '\')"' : '';

            const html = '<li>'
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

    function fn_selectCard(msgTmpltId) {
        SELECTED_TMPLT_ID = msgTmpltId;

        $('.card_item').removeClass('active');
        $('.card_item[data-id="' + msgTmpltId + '"]').addClass('active');

        const param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams({ msgTmpltId: msgTmpltId })
        };
        ajaxCall('/admMsgTmpltSelectAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result === 1 && res.returnVO) {
                $('#formTmpltId').val(res.returnVO.msgTmpltId);
                $('#formTmpltTtl').val(res.returnVO.msgTmpltTtl);
                $('#formTmpltCts').val(res.returnVO.msgTmpltCts);
                const gbncd = res.returnVO.msgCtsGbncd || CURRENT_TAB;
                $('input[name=formMsgCtsGbncd][value="' + gbncd + '"]').prop('checked', true);
            } else {
                UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error");
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    function fn_resetForm() {
        SELECTED_TMPLT_ID = '';
        $('#formTmpltId').val('');
        $('#formTmpltTtl').val('');
        $('#formTmpltCts').val('');
        $('input[name=formMsgCtsGbncd][value="' + CURRENT_TAB + '"]').prop('checked', true);
    }

    function fn_save() {
        const ttl = $('#formTmpltTtl').val().trim();
        const cts = $('#formTmpltCts').val().trim();

        if (!ttl) {
            UiComm.showMessage('<spring:message code="msg.tmplt.label.ttl"/> <spring:message code="common.item.select.msg"/>', 'warning');
            $('#formTmpltTtl').focus();
            return;
        }
        if (!cts) {
            UiComm.showMessage('<spring:message code="msg.tmplt.label.cts"/> <spring:message code="common.item.select.msg"/>', 'warning');
            $('#formTmpltCts').focus();
            return;
        }

        const tmpltId = $('#formTmpltId').val();
        const url = tmpltId ? '/admMsgTmpltModifyAjax.do' : '/admMsgTmpltRegistAjax.do';

        const formGbncd = $('input[name=formMsgCtsGbncd]:checked').val() || CURRENT_TAB;
        const extData = {
            msgTmpltTtl: ttl,
            msgTmpltCts: cts,
            msgCtsGbncd: formGbncd
        };

        if (tmpltId) {
            extData.msgTmpltId = tmpltId;
        }

        const param = {
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

    function fn_deleteSelected() {
        const checkedIds = [];
        $('input[name=chkTmplt]:checked').each(function() {
            checkedIds.push($(this).val());
        });

        if (checkedIds.length === 0) {
            UiComm.showMessage('<spring:message code="common.item.select.msg"/>', 'warning');
            return;
        }

        UiComm.showMessage('<spring:message code="msg.tmplt.msg.confirmDelete"/>', 'confirm').then(function(result) {
            if (!result) return;

            const $form = $('#frmTmpltAction');
            $form.attr('action', '/admMsgTmpltDelete.do');
            $form.find('input[name=encParams]').val(EPARAM);
            $form.find('input[name=msgTmpltIds]').remove();
            $form.find('input[name=msgCtsGbncd]').val(CURRENT_TAB);
            $form.find('input[name=pageIndex]').val(CURRENT_PAGE);
            $form.find('input[name=searchText]').val($('#inputSearch1').val());
            checkedIds.forEach(function(id) {
                $form.append($('<input>', { type: 'hidden', name: 'msgTmpltIds', value: id }));
            });
            $form.submit();
        });
    }

    function fn_deleteAll() {
        UiComm.showMessage('<spring:message code="msg.tmplt.msg.confirmDeleteAll"/>', 'confirm').then(function(result) {
            if (!result) return;

            const $form = $('#frmTmpltAction');
            $form.attr('action', '/admMsgTmpltAllDelete.do');
            $form.find('input[name=encParams]').val(EPARAM);
            $form.find('input[name=msgTmpltIds]').remove();
            $form.find('input[name=msgCtsGbncd]').val(CURRENT_TAB);
            $form.find('input[name=pageIndex]').val(1);
            $form.find('input[name=searchText]').val('');
            $form.submit();
        });
    }

    function fn_excelDown() {
        const excelGrid = { colModel: [] };
        excelGrid.colModel.push({label: '<spring:message code="msg.tmplt.col.ttl"/>', name: 'msgTmpltTtl', align: 'left', width: '8000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.tmplt.col.cts"/>', name: 'msgTmpltCts', align: 'left', width: '15000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.tmplt.col.regDttm"/>', name: 'regDttm', align: 'center', width: '5000', formatter: 'date'});

        const form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "excelForm");
        form.attr("action", "/admMsgTmpltExcelDown.do");
        form.append($('<input/>', { type: 'hidden', name: 'msgCtsGbncd', value: CURRENT_TAB }));
        form.append($('<input/>', { type: 'hidden', name: 'searchText', value: $('#inputSearch1').val() }));
        form.append($('<input/>', { type: 'hidden', name: 'excelGrid', value: JSON.stringify(excelGrid) }));
        form.appendTo("body");
        form.submit();
        $("form[name=excelForm]").remove();
    }

    function fn_updateUIByTab() {
        const isOrgTab = (CURRENT_TAB === 'ORG_MSG');
        const canEdit = !isOrgTab || IS_ADMIN;

        if (canEdit) {
            $('#btnExcel, #btnDelete, #btnDeleteAll').show();
            $('.tmplt-form-area').show();
        } else {
            $('#btnExcel, #btnDelete, #btnDeleteAll').hide();
            $('.tmplt-form-area').hide();
        }

        if (isOrgTab) {
            $('#boardTitle').text('<spring:message code="msg.tmplt.label.orgMsg" text="기관 문구"/>');
            $('#formTitle').text('<spring:message code="msg.tmplt.label.formTitleOrg" text="기관 문구 등록/수정"/>');
        } else {
            $('#boardTitle').text('<spring:message code="msg.tmplt.label.indvMsg" text="개인 문구"/>');
            $('#formTitle').text('<spring:message code="msg.tmplt.label.formTitleIndv" text="개인 문구 등록/수정"/>');
        }
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

                        <!-- board top -->
                        <div class="board_top">
                            <h3 id="boardTitle" class="board-title"><spring:message code="msg.tmplt.label.indvMsg" text="개인 문구"/></h3>
                            <div class="right-area">
                                <!-- tab -->
                                <div class="tab_btn">
                                    <a href="javascript:void(0)" class="<c:if test="${vo.msgCtsGbncd ne 'ORG_MSG'}">current</c:if>" onclick="fn_changeTab('INDV_MSG')"><spring:message code="msg.tmplt.label.indvMsg" text="개인 문구"/></a>
                                    <a href="javascript:void(0)" class="<c:if test="${vo.msgCtsGbncd eq 'ORG_MSG'}">current</c:if>" onclick="fn_changeTab('ORG_MSG')"><spring:message code="msg.tmplt.label.orgMsg" text="기관 문구"/></a>
                                </div>
                                <!-- search small -->
                                <div class="search-typeC">
                                    <input class="form-control" type="text" id="inputSearch1" value="<c:out value="${vo.searchText}"/>" placeholder="<spring:message code="msg.tmplt.label.searchPlaceholder" text="제목/내용 검색"/>">
                                    <button type="button" class="btn basic icon search" aria-label="<spring:message code="msg.tmplt.label.search" text="검색"/>" onclick="fn_search()"><i class="icon-svg-search"></i></button>
                                </div>
                                <button type="button" id="btnExcel" class="btn basic" onclick="fn_excelDown()"><spring:message code="msg.tmplt.label.excelDown" text="엑셀 다운로드"/></button>
                                <button type="button" id="btnDelete" class="btn basic" onclick="fn_deleteSelected()"><spring:message code="msg.tmplt.label.delete" text="삭제"/></button>
                                <button type="button" id="btnDeleteAll" class="btn basic" onclick="fn_deleteAll()"><spring:message code="msg.tmplt.label.deleteAll" text="전체삭제"/></button>
                            </div>
                        </div>

                        <!-- 문구 카드 목록 -->
                        <div class="message_list">
                            <ul class="message_card"></ul>
                        </div>

                        <!-- paging -->
                        <div id="pagingArea" class="board_foot simple"></div>

                        <!-- 등록/수정 폼 -->
                        <div class="tmplt-form-area">
                            <h4 id="formTitle" class="sub-title"><spring:message code="msg.tmplt.label.formTitleIndv" text="개인 문구 등록/수정"/></h4>
                            <input type="hidden" id="formTmpltId" value="" />
                            <div class="table-wrap">
                                <table class="table-type5">
                                    <colgroup>
                                        <col class="width-15per" />
                                        <col class="" />
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                            <th><label><spring:message code="common.label.gbn" text="구분"/></label></th>
                                            <td>
                                                <div class="form-inline">
                                                    <span class="custom-input">
                                                        <input type="radio" name="formMsgCtsGbncd" id="formMsgCtsGbncdIndv" value="INDV_MSG" checked="">
                                                        <label for="formMsgCtsGbncdIndv"><spring:message code="msg.tmplt.label.indvMsg" text="개인 문구"/></label>
                                                    </span>
                                                    <span class="custom-input">
                                                        <input type="radio" name="formMsgCtsGbncd" id="formMsgCtsGbncdOrg" value="ORG_MSG">
                                                        <label for="formMsgCtsGbncdOrg"><spring:message code="msg.tmplt.label.orgMsg" text="기관 문구"/></label>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
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

                        <form id="frmTmpltAction" method="POST" style="display:none;">
                            <input type="hidden" name="encParams" value="<c:out value='${encParams}'/>" />
                            <input type="hidden" name="returnView" value="/admMsgTmpltListView.do" />
                            <input type="hidden" name="msgCtsGbncd" value="" />
                            <input type="hidden" name="pageIndex" value="" />
                            <input type="hidden" name="searchText" value="" />
                        </form>

                    </div>
                </div>
            </div>
            <!-- //content -->

        </main>
        <!-- //admin -->
    </div>
</body>
</html>
