<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!-- 받는 사람 추가 모달 -->
<div class="modal-overlay" id="rcvrModal" role="dialog" aria-modal="true" aria-hidden="true">
    <div class="modal-content modal-xl" tabindex="-1">
        <div class="modal-header">
            <h2><spring:message code="msg.modal.rcvrTitle" text="받는 사람 추가"/></h2>
            <button class="modal-close" aria-label="<spring:message code='msg.modal.close' text='닫기'/>" onclick="fn_closeModal('rcvrModal')"><i class="icon-svg-close"></i></button>
        </div>
        <div class="modal-body">
            <iframe src="about:blank" style="width:100%; height:660px; border:none;"></iframe>
        </div>
    </div>
</div>

<!-- 메시지 불러오기 모달 -->
<div class="modal-overlay" id="tmpltModal" role="dialog" aria-modal="true" aria-hidden="true">
    <div class="modal-content modal-lg" tabindex="-1">
        <div class="modal-header">
            <h2><spring:message code="msg.modal.tmpltLoad" text="메시지 불러오기"/></h2>
            <button class="modal-close" aria-label="<spring:message code='msg.modal.close' text='닫기'/>" onclick="fn_closeModal('tmpltModal')"><i class="icon-svg-close"></i></button>
        </div>
        <div class="modal-body">
            <div class="board_top">
                <h3 class="board-title"><spring:message code="msg.modal.indvMsg" text="개인 문구"/></h3>
                <div class="right-area">
                    <div class="tab_btn">
                        <a href="#0" class="current" data-tmplt-tab="INDV_MSG" onclick="fn_tmpltChangeTab('INDV_MSG'); return false;"><spring:message code="msg.modal.indvMsg" text="개인 문구"/></a>
                        <a href="#0" data-tmplt-tab="ORG_MSG" onclick="fn_tmpltChangeTab('ORG_MSG'); return false;"><spring:message code="msg.modal.deptMsg" text="학과/부서 문구"/></a>
                    </div>
                </div>
            </div>

            <div class="table-wrap">
                <table class="table-type5">
                    <colgroup>
                        <col class="width-15per"/>
                        <col/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th><label for="tmpltEditTtl"><spring:message code="msg.modal.ttl" text="제목"/></label></th>
                            <td>
                                <div class="form-row">
                                    <input class="form-control width-100per" type="text" id="tmpltEditTtl" placeholder="<spring:message code="msg.modal.ttlPlaceholder" text="제목 입력"/>">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th><label for="tmpltEditCts"><spring:message code="msg.modal.cts" text="내용"/></label></th>
                            <td>
                                <label class="width-100per"><textarea rows="4" class="form-control resize-none" id="tmpltEditCts"></textarea></label>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="modal_btns mt10">
                <button type="button" class="btn type1" onclick="fn_tmpltApply()"><spring:message code="msg.modal.useMsg" text="사용하기"/></button>
            </div>

            <div class="board_top">
                <h4 class="sub-title"><spring:message code="msg.modal.tmpltListTitle" text="문구 목록"/></h4>
                <div class="right-area">
                    <div class="search-typeC">
                        <input class="form-control" type="text" id="tmpltPopSearch" value="" placeholder="<spring:message code="msg.modal.searchPlaceholder" text="제목/내용 검색"/>" onkeydown="if(event.keyCode===13) fn_tmpltLoadList()">
                        <button type="button" class="btn basic icon search" aria-label="<spring:message code="msg.modal.search" text="검색"/>" onclick="fn_tmpltLoadList()"><i class="icon-svg-search"></i></button>
                    </div>
                    <button type="button" class="btn basic" onclick="fn_tmpltSelectAll()"><spring:message code="msg.modal.selectAll" text="전체선택"/></button>
                    <button type="button" class="btn basic" onclick="fn_tmpltDeleteSelected()"><spring:message code="msg.modal.delete" text="삭제"/></button>
                </div>
            </div>

            <div id="tmpltCardWrap" class="message_list" style="max-height:300px; overflow-y:auto;"></div>

            <div class="modal_btns">
                <button type="button" class="btn type2" onclick="fn_closeModal('tmpltModal')"><spring:message code="msg.modal.close" text="닫기"/></button>
            </div>
        </div>
    </div>
</div>

<!-- 템플릿에 저장 모달 -->
<div class="modal-overlay" id="tmpltSaveModal" role="dialog" aria-modal="true" aria-hidden="true">
    <div class="modal-content modal-lg" tabindex="-1">
        <div class="modal-header">
            <h2><spring:message code="msg.modal.tmpltSave" text="템플릿에 저장"/></h2>
            <button class="modal-close" aria-label="<spring:message code='msg.modal.close' text='닫기'/>" onclick="fn_closeModal('tmpltSaveModal')"><i class="icon-svg-close"></i></button>
        </div>
        <div class="modal-body">
            <iframe src="about:blank" style="width:100%; height:730px; border:none;"></iframe>
        </div>
    </div>
</div>

<!-- 공통 모달/템플릿 스크립트 (채널별 부모 JSP 공유) -->
<script type="text/javascript">
    let TMPLT_CURRENT_TAB = 'INDV_MSG';
    let TMPLT_LIST = [];
    let TMPLT_SELECTED = null;

    const TMPLT_MODAL_PREFIX = (function() {
        const seg = location.pathname.substring(location.pathname.lastIndexOf('/') + 1);
        return seg.toLowerCase().indexOf('adm') === 0 ? '/admMsgTmplt' : '/msgTmplt';
    })();

    function fn_openModal(modalId, url) {
        const $modal = $('#' + modalId);
        if (url) {
            $modal.find('iframe').attr('src', url);
        }
        $modal.addClass('active').attr('aria-hidden', 'false');
        document.body.style.overflow = 'hidden';
    }

    function fn_closeModal(modalId) {
        const $modal = $('#' + modalId);
        $modal.removeClass('active').attr('aria-hidden', 'true');
        $modal.find('iframe').attr('src', 'about:blank');
        document.body.style.overflow = '';
    }

    window.rcvrDlg = { close: function() { fn_closeModal('rcvrModal'); } };
    window.tmpltSaveDlg = { close: function() { fn_closeModal('tmpltSaveModal'); } };

    $(document).ready(function() {
        $('.modal-overlay').on('click', function(e) {
            if ($(e.target).hasClass('modal-overlay')) {
                fn_closeModal(this.id);
            }
        });

        $(document).on('keydown', function(e) {
            if (e.key === 'Escape') {
                $('.modal-overlay.active').each(function() {
                    fn_closeModal(this.id);
                });
            }
        });
    });

    function fn_openTmpltPopup() {
        TMPLT_CURRENT_TAB = 'INDV_MSG';
        TMPLT_SELECTED = null;
        fn_tmpltClearPreview();
        $('#tmpltPopSearch').val('');
        $('[data-tmplt-tab]').removeClass('current');
        $('[data-tmplt-tab="INDV_MSG"]').addClass('current');
        fn_openModal('tmpltModal');
        fn_tmpltLoadList();
    }

    function fn_tmpltChangeTab(tabCd) {
        TMPLT_CURRENT_TAB = tabCd;
        $('#tmpltPopSearch').val('');
        TMPLT_SELECTED = null;
        fn_tmpltClearPreview();
        $('[data-tmplt-tab]').removeClass('current');
        $('[data-tmplt-tab="' + tabCd + '"]').addClass('current');
        fn_tmpltLoadList();
    }

    function fn_tmpltLoadList() {
        const data = {
            pageIndex: 1,
            listScale: 100,
            msgCtsGbncd: TMPLT_CURRENT_TAB,
            searchText: $('#tmpltPopSearch').val()
        };
        const param = { encParams: EPARAM, addParams: UiComm.makeEncParams(data) };
        ajaxCall(TMPLT_MODAL_PREFIX + 'ListAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0) {
                TMPLT_LIST = res.returnList || [];
                fn_tmpltRenderCards();
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    function fn_tmpltRenderCards() {
        let html = '';
        if (TMPLT_LIST.length === 0) {
            html = '<div style="text-align:center; padding:40px; color:#999;"><spring:message code="common.content.not_found"/></div>';
        } else {
            html = '<ul class="message_card">';
            TMPLT_LIST.forEach(function(v, i) {
                const activeClass = (TMPLT_SELECTED && TMPLT_SELECTED.msgTmpltId === v.msgTmpltId) ? ' active' : '';
                html += '<li>';
                html += '<a href="#0" class="card_item' + activeClass + '" onclick="fn_tmpltSelectCard(' + i + '); return false;">';
                html += '<div class="item_header">';
                html += '<span class="custom-input onlychk" onclick="event.stopPropagation()"><input type="checkbox" name="tmpltChk" id="tmpltChk' + i + '" value="' + v.msgTmpltId + '"><label for="tmpltChk' + i + '"></label></span>';
                html += '<div class="msg_tit">' + UiComm.escapeHtml(v.msgTmpltTtl || '') + '</div>';
                html += '</div>';
                html += '<div class="extra"><p class="desc">' + UiComm.escapeHtml(v.msgTmpltCts || '') + '</p></div>';
                html += '</a>';
                html += '</li>';
            });
            html += '</ul>';
        }
        $('#tmpltCardWrap').html(html);
    }

    function fn_tmpltSelectCard(idx) {
        TMPLT_SELECTED = TMPLT_LIST[idx];
        $('#tmpltCardWrap .card_item').removeClass('active');
        $('#tmpltCardWrap .card_item').eq(idx).addClass('active');
        $('#tmpltEditTtl').val(TMPLT_SELECTED.msgTmpltTtl || '');
        $('#tmpltEditCts').val(TMPLT_SELECTED.msgTmpltCts || '');
    }

    function fn_tmpltClearPreview() {
        $('#tmpltEditTtl').val('');
        $('#tmpltEditCts').val('');
    }

    function fn_tmpltApply() {
        const ttl = $('#tmpltEditTtl').val().trim();
        const cts = $('#tmpltEditCts').val().trim();
        if (!ttl && !cts) {
            UiComm.showMessage('<spring:message code="common.item.select.msg"/>', 'warning');
            return;
        }
        $('#ttl').val(ttl);
        $('#txtCts').val(cts);
        fn_closeModal('tmpltModal');
    }

    function fn_tmpltSelectAll() {
        const allChecked = $('input[name=tmpltChk]').length === $('input[name=tmpltChk]:checked').length;
        $('input[name=tmpltChk]').prop('checked', !allChecked);
    }

    function fn_tmpltDeleteSelected() {
        const checked = $('input[name=tmpltChk]:checked');
        if (checked.length === 0) {
            UiComm.showMessage('<spring:message code="common.item.select.msg"/>', 'warning');
            return;
        }
        UiComm.showMessage('<spring:message code="msg.modal.tmpltConfirmDelete"/>', 'confirm').then(function(result) {
            if (!result) return;
            const ids = [];
            checked.each(function() { ids.push($(this).val()); });

            fn_tmpltDeleteBatch(ids, 0, { failCnt: 0 });
        });
    }

    function fn_tmpltDeleteBatch(ids, index, state) {
        if (index >= ids.length) {
            if (state.failCnt > 0) {
                UiComm.showMessage("<spring:message code='fail.common.delete'/>", "error");
            } else {
                UiComm.showMessage('<spring:message code="msg.modal.deleteSuccess"/>', 'success');
            }
            TMPLT_SELECTED = null;
            fn_tmpltClearPreview();
            fn_tmpltLoadList();
            return;
        }
        ajaxCall(TMPLT_MODAL_PREFIX + 'DeleteAjax.do',
            { encParams: EPARAM, addParams: UiComm.makeEncParams({ msgTmpltId: ids[index] }) },
            function(res) {
                if (res.encParams) EPARAM = res.encParams;
                if (res.result !== 1) state.failCnt++;
                fn_tmpltDeleteBatch(ids, index + 1, state);
            },
            function() {
                state.failCnt++;
                fn_tmpltDeleteBatch(ids, index + 1, state);
            },
            true);
    }
</script>
