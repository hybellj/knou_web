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
    let tmpltList = [];

    $(document).ready(function() {
        fn_initContent();
        fn_loadList();
    });

    /* 내용 초기화 (부모에서 전달받은 제목, 내용) */
    function fn_initContent() {
        let params = new URLSearchParams(window.location.search);
        let ttl = decodeURIComponent(params.get('ttl') || '');
        let txtCts = decodeURIComponent(params.get('txtCts') || '');
        $('#saveTtl').val(ttl);
        $('#saveCts').val(txtCts);
    }

    /* 기존 템플릿 목록 조회 */
    function fn_loadList() {
        ajaxCall('/msgTmpltListAjax.do', { pageIndex: 1, listScale: 100, msgCtsGbncd: 'INDV_MSG' }, function(res) {
            if (res.result > 0) {
                tmpltList = res.returnList || [];
                fn_renderCards();
            }
        }, function() {});
    }

    /* 카드 렌더링 */
    function fn_renderCards() {
        let html = '';
        if (tmpltList.length === 0) {
            html = '<div style="text-align:center; padding:30px; color:#999;"><spring:message code="common.content.not_found"/></div>';
        } else {
            html = '<ul class="message_card">';
            tmpltList.forEach(function(v, i) {
                html += '<li>';
                html += '<a href="#0" class="card_item">';
                html += '<div class="item_header">';
                html += '<span class="custom-input onlychk"><input type="checkbox" name="tmpltChk" id="saveChk' + i + '" value="' + v.msgTmpltId + '"><label for="saveChk' + i + '"></label></span>';
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

    /* 저장하기 */
    function fn_save() {
        let ttl = $('#saveTtl').val().trim();
        if (!ttl) {
            alert('<spring:message code="msg.shrtnt.msg.requiredTtl"/>');
            $('#saveTtl').focus();
            return;
        }

        let param = {
            msgTmpltTtl: ttl,
            msgTmpltCts: $('#saveCts').val(),
            msgCtsGbncd: 'INDV_MSG'
        };

        ajaxCall('/msgTmpltRegistAjax.do', param, function(res) {
            if (res.result > 0) {
                alert('<spring:message code="success.common.save"/>');
                fn_loadList();
                $('#saveTtl').val('');
            } else {
                alert(res.message || '<spring:message code="fail.common.insert"/>');
            }
        }, function() { UiComm.showLoading(false); });
    }
</script>

<body style="margin:0; padding:15px;">
<div id="loading_page" style="display:none;"></div>

    <!-- 저장 폼 -->
    <div class="table-wrap">
        <table class="table-type5">
            <colgroup>
                <col class="width-15per" />
                <col class="" />
            </colgroup>
            <tbody>
                <tr>
                    <th><label for="saveTtl" class="req"><spring:message code="msg.shrtnt.label.ttl" text="제목"/></label></th>
                    <td>
                        <div class="form-row">
                            <input class="form-control width-100per" type="text" id="saveTtl" placeholder="<spring:message code="msg.shrtnt.label.tmpltTtlPlaceholder" text="제목입력"/>">
                        </div>
                    </td>
                </tr>
                <tr>
                    <th><label for="saveCts"><spring:message code="msg.shrtnt.label.cts" text="내용"/></label></th>
                    <td>
                        <label class="width-100per"><textarea rows="5" class="form-control resize-none" id="saveCts"></textarea></label>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    <div class="modal_btns mt10">
        <button type="button" class="btn type1" onclick="fn_save()"><spring:message code="msg.shrtnt.label.tmpltSaveBtn" text="저장하기"/></button>
    </div>

    <!-- 기존 템플릿 카드 목록 -->
    <div class="board_top">
        <h4 class="sub-title"><spring:message code="msg.shrtnt.label.indvMsg" text="개인 문구"/></h4>
    </div>

    <div id="cardWrap" class="message_list" style="max-height:250px; overflow-y:auto;"></div>

    <!-- 하단 버튼 -->
    <div class="modal_btns">
        <button type="button" class="btn type2" onclick="parent.tmpltSaveDlg.close()"><spring:message code="msg.shrtnt.label.closeBtn" text="닫기"/></button>
    </div>

</body>
</html>
