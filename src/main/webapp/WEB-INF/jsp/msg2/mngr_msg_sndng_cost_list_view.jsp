<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
<script type="text/javascript">
    let costMap = {};

    let MSG_TYCD_LIST = ['PUSH', 'SHRTNT', 'EML', 'ALIM_TALK', 'SMS', 'LMS', 'MMS'];

    let MSG_LABEL_UNIT_PRICE = '<spring:message code="msg.sndngCost.label.unitPrice"/>';
    let MSG_LABEL_SAVE = '<spring:message code="msg.sndngCost.label.save"/>';
    let MSG_INPUT_NUMBER = '<spring:message code="msg.sndngCost.msg.inputNumber"/>';

    $(document).ready(function() {
        fn_loadCostList();
    });

    /* 단가 목록 조회 */
    function fn_loadCostList() {
        ajaxCall('/msgSndngCostListAjax.do', { pageIndex: 1, listScale: 100 }, function(res) {
            if (res.result > 0) {
                costMap = {};
                if (res.returnList) {
                    res.returnList.forEach(function(v) {
                        costMap[v.msgTycd] = v;
                    });
                }
                fn_renderCostRow();
            }
        }, function() {
            alert('<spring:message code="fail.common.select"/>');
        }, true);
    }

    /* 단가 행 렌더링 */
    function fn_renderCostRow() {
        let $tr = $('#costRow');
        $tr.empty();
        $tr.append('<th>' + MSG_LABEL_UNIT_PRICE + '</th>');

        MSG_TYCD_LIST.forEach(function(tycd) {
            let item = costMap[tycd];
            let cost = item ? item.sndngCost : 0;

            let td = '<td data-tycd="' + tycd + '" style="cursor:pointer;" onclick="fn_clickCost(this, \'' + tycd + '\')">' + cost + '</td>';
            $tr.append(td);
        });
    }

    /* 금액 클릭 → 인풋 + 저장 버튼 표시 */
    function fn_clickCost(td, tycd) {
        let $td = $(td);
        if ($td.hasClass('cost-edit')) return;
        $td.addClass('cost-edit');

        let item = costMap[tycd];
        let currentCost = item ? item.sndngCost : 0;

        $td.css('cursor', 'default');
        $td.html(
            '<input type="text" value="' + currentCost + '" inputmask="numeric" '
            + 'onkeydown="if(event.key===\'Enter\') fn_saveCost(\'' + tycd + '\'); if(event.key===\'Escape\') fn_renderCostRow();">'
            + '<button type="button" class="btn type5 btn-save" onclick="fn_saveCost(\'' + tycd + '\')">' + MSG_LABEL_SAVE + '</button>'
        );
        $td.find('input').focus().select();
    }

    /* 저장 (등록 또는 수정) */
    function fn_saveCost(tycd) {
        let $td = $('td[data-tycd="' + tycd + '"]');
        let newCost = $td.find('input').val();

        if (!newCost || isNaN(newCost) || Number(newCost) < 0) {
            alert(MSG_INPUT_NUMBER);
            $td.find('input').focus();
            return;
        }

        let item = costMap[tycd];

        if (item && item.sndngCostId) {
            /* 수정 */
            ajaxCall('/msgSndngCostModifyAjax.do', {
                sndngCostId: item.sndngCostId,
                msgTycd: tycd,
                sndngCost: newCost,
                useyn: item.useyn || 'Y'
            }, function(res) {
                if (res.result > 0) {
                    fn_loadCostList();
                } else {
                    alert(res.message || '<spring:message code="fail.common.update"/>');
                }
            }, function() {
                alert('<spring:message code="fail.common.update"/>');
            }, true);
        } else {
            /* 신규 등록 */
            ajaxCall('/msgSndngCostRegistAjax.do', {
                msgTycd: tycd,
                sndngCost: newCost,
                useyn: 'Y'
            }, function(res) {
                if (res.result > 0) {
                    fn_loadCostList();
                } else {
                    alert(res.message || '<spring:message code="fail.common.insert"/>');
                }
            }, function() {
                alert('<spring:message code="fail.common.insert"/>');
            }, true);
        }
    }
</script>
</head>

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
                            <h2 class="page-title"><spring:message code="msg.sndngCost.label.title"/></h2>
                        </div>

                        <!-- 단가 정보 -->
                        <div class="board_top">
                            <h3 class="board-title"><spring:message code="msg.sndngCost.label.costInfo"/></h3>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:10%">
                                    <col style="width:12%">
                                    <col style="width:12%">
                                    <col style="width:12%">
                                    <col style="width:12%">
                                    <col style="width:12%">
                                    <col style="width:12%">
                                    <col style="width:12%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th rowspan="2"><spring:message code="msg.sndngCost.label.gbn"/></th>
                                        <th rowspan="2">PUSH</th>
                                        <th rowspan="2"><spring:message code="msg.title.msg.shrtnt"/></th>
                                        <th rowspan="2"><spring:message code="msg.title.msg.eml"/></th>
                                        <th rowspan="2"><spring:message code="msg.title.msg.alimTalk"/></th>
                                        <th colspan="3"><spring:message code="msg.sndngCost.label.sms"/></th>
                                    </tr>
                                    <tr>
                                        <th>SMS</th>
                                        <th>LMS</th>
                                        <th>MMS</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr id="costRow">
                                    </tr>
                                </tbody>
                            </table>
                            <div class="msg-box">
                                <p class="txt"><i class="icon-svg-warning" aria-hidden="true"></i><spring:message code="msg.sndngCost.label.costGuide"/></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- //content -->

        </main>
        <!-- //admin -->
    </div>
</body>
</html>
