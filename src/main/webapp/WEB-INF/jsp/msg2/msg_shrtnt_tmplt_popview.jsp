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

<style>
    .modal_btns + .board_top { margin-top: 2.5rem; padding-top: 1rem; border-top: 2px solid #F0F2F6; }
    .message_card { grid-template-columns: repeat(2, 1fr); margin-bottom: 0; }
    .message_card > li .card_item .extra { height: 9.5rem; }
</style>

<script type="text/javascript">
    let EPARAM = '<c:out value="${encParams}" />';
    let currentTab = 'INDV_MSG';
    let tmpltList = [];
    let selectedTmplt = null;

    $(document).ready(function() {
        fn_loadList();
    });

    /* 탭 변경 */
    function fn_changeTab(tabCd) {
        currentTab = tabCd;
        $('#popTmpltSearch').val('');
        selectedTmplt = null;
        fn_clearPreview();

        $('.tab_btn a').removeClass('current');
        $('[data-tab="' + tabCd + '"]').addClass('current');

        fn_loadList();
    }

    /* 목록 조회 */
    function fn_loadList() {
        let extData = {
            pageIndex: 1,
            listScale: 100,
            msgCtsGbncd: currentTab,
            searchText: $('#popTmpltSearch').val()
        };

        let param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams(extData)
        };
        ajaxCall('/msgTmpltListAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0) {
                tmpltList = res.returnList || [];
                fn_renderCards();
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    /* 카드 렌더링 */
    function fn_renderCards() {
        let html = '';
        if (tmpltList.length === 0) {
            html = '<div style="text-align:center; padding:40px; color:#999;"><spring:message code="common.content.not_found"/></div>';
        } else {
            html = '<ul class="message_card">';
            tmpltList.forEach(function(v, i) {
                let activeClass = (selectedTmplt && selectedTmplt.msgTmpltId === v.msgTmpltId) ? ' active' : '';
                html += '<li>';
                html += '<a href="#0" class="card_item' + activeClass + '" onclick="fn_selectCard(' + i + '); return false;">';
                html += '<div class="item_header">';
                html += '<span class="custom-input onlychk"><input type="checkbox" name="tmpltChk" id="tmpltChk' + i + '" value="' + v.msgTmpltId + '" onclick="event.stopPropagation()"><label for="tmpltChk' + i + '"></label></span>';
                html += '<div class="msg_tit">' + UiComm.escapeHtml(v.msgTmpltTtl || '') + '</div>';
                html += '</div>';
                html += '<div class="extra"><p class="desc">' + UiComm.escapeHtml(v.msgTmpltCts || '') + '</p></div>';
                html += '</a>';
                html += '</li>';
            });
            html += '</ul>';
        }
        $('#cardWrap').html(html);
    }

    /* 카드 선택 */
    function fn_selectCard(idx) {
        selectedTmplt = tmpltList[idx];
        $('.card_item').removeClass('active');
        $('.card_item').eq(idx).addClass('active');

        $('#editTtl').val(selectedTmplt.msgTmpltTtl || '');
        $('#editCts').val(selectedTmplt.msgTmpltCts || '');
    }

    /* 편집 필드 초기화 */
    function fn_clearPreview() {
        $('#editTtl').val('');
        $('#editCts').val('');
    }

    /* 사용하기 */
    function fn_apply() {
        let ttl = $('#editTtl').val().trim();
        let cts = $('#editCts').val().trim();
        if (!ttl && !cts) {
            alert('<spring:message code="common.item.select.msg"/>');
            return;
        }
        if (parent && parent.fn_applyTemplate) {
            parent.fn_applyTemplate(ttl, cts);
        }
    }

    /* 전체선택 */
    function fn_selectAll() {
        let allChecked = $('input[name=tmpltChk]').length === $('input[name=tmpltChk]:checked').length;
        $('input[name=tmpltChk]').prop('checked', !allChecked);
    }

    /* 선택 삭제 */
    function fn_deleteSelected() {
        let checked = $('input[name=tmpltChk]:checked');
        if (checked.length === 0) {
            alert('<spring:message code="common.item.select.msg"/>');
            return;
        }
        if (!confirm('<spring:message code="msg.shrtnt.msg.confirmDelete"/>')) return;

        let ids = [];
        checked.each(function() { ids.push($(this).val()); });

        let param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams({ msgTmpltIds: ids.join(',') })
        };
        ajaxCall('/msgTmpltDeleteAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0) {
                alert('<spring:message code="msg.shrtnt.msg.deleteSuccess"/>');
                selectedTmplt = null;
                fn_clearPreview();
                fn_loadList();
            } else {
                UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>","error");
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    /* 엔터키 검색 */
    function fn_searchKeyDown(e) {
        if (e.keyCode === 13) fn_loadList();
    }
</script>

<body style="margin:0; padding:15px;">
<div id="loading_page" style="display:none;"></div>

    <!-- 탭 -->
    <div class="board_top">
        <div class="right-area">
            <div class="tab_btn">
                <a href="#0" class="current" data-tab="INDV_MSG" onclick="fn_changeTab('INDV_MSG'); return false;"><spring:message code="msg.shrtnt.label.indvMsg" text="개인 문구"/></a>
                <a href="#0" data-tab="ORG_MSG" onclick="fn_changeTab('ORG_MSG'); return false;"><spring:message code="msg.shrtnt.label.deptMsg" text="학과/부서 문구"/></a>
            </div>
        </div>
    </div>

    <!-- 선택된 템플릿 편집 영역 -->
    <div class="table-wrap">
        <table class="table-type5">
            <colgroup>
                <col class="width-15per" />
                <col class="" />
            </colgroup>
            <tbody>
                <tr>
                    <th><label for="editTtl"><spring:message code="msg.shrtnt.label.ttl" text="제목"/></label></th>
                    <td>
                        <div class="form-row">
                            <input class="form-control width-100per" type="text" id="editTtl" placeholder="<spring:message code="msg.shrtnt.label.tmpltTtlPlaceholder" text="제목 입력"/>">
                        </div>
                    </td>
                </tr>
                <tr>
                    <th><label for="editCts"><spring:message code="msg.shrtnt.label.cts" text="내용"/></label></th>
                    <td>
                        <label class="width-100per"><textarea rows="4" class="form-control resize-none" id="editCts"></textarea></label>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    <div class="modal_btns mt10">
        <button type="button" class="btn type1" onclick="fn_apply()"><spring:message code="msg.shrtnt.label.useMsg" text="사용하기"/></button>
    </div>

    <!-- 문구 목록 -->
    <div class="board_top">
        <h4 class="sub-title"><spring:message code="msg.shrtnt.label.tmpltLoad" text="문구 목록"/></h4>
        <div class="right-area">
            <div class="search-typeC">
                <input class="form-control" type="text" id="popTmpltSearch" value="" placeholder="<spring:message code="msg.tmplt.label.searchPlaceholder" text="제목/내용 검색"/>" onkeydown="fn_searchKeyDown(event)">
                <button type="button" class="btn basic icon search" aria-label="<spring:message code="msg.shrtnt.label.rcvrSearch" text="검색"/>" onclick="fn_loadList()"><i class="icon-svg-search"></i></button>
            </div>
            <button type="button" class="btn basic" onclick="fn_selectAll()"><spring:message code="msg.shrtnt.label.selectAll" text="전체선택"/></button>
            <button type="button" class="btn basic" onclick="fn_deleteSelected()"><spring:message code="msg.shrtnt.label.delete" text="삭제"/></button>
        </div>
    </div>

    <!-- 카드 목록 -->
    <div id="cardWrap" class="message_list" style="max-height:300px; overflow-y:auto;"></div>

    <!-- 하단 버튼 -->
    <div class="modal_btns">
        <button type="button" class="btn type2" onclick="parent.tmpltDlg.close()"><spring:message code="msg.shrtnt.label.closeBtn" text="닫기"/></button>
    </div>

</body>
</html>
