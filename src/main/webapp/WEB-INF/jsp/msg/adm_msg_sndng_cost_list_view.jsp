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
    let EPARAM    = '<c:out value="${encParams}" />';
    let COST_MAP  = {};

    const MSG_TYCD_LIST        = ['ALIM_TALK', 'SMS', 'LMS'];
    const MSG_LABEL_UNIT_PRICE = '<spring:message code="msg.sndngCost.label.unitPrice"/>';
    const MSG_LABEL_SAVE       = '<spring:message code="msg.sndngCost.label.save"/>';
    const MSG_INPUT_NUMBER     = '<spring:message code="msg.sndngCost.msg.inputNumber"/>';

    $(document).ready(function() {
        fn_loadCostList();
    });

    function fn_loadCostList() {
        const param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams({ pageIndex: 1, listScale: 100 })
        };
        ajaxCall('/admMsgSndngCostListAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0) {
                COST_MAP = {};
                if (res.returnList) {
                    res.returnList.forEach(function(v) {
                        COST_MAP[v.msgTycd] = v;
                    });
                }
                fn_renderCostRow();
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    function fn_renderCostRow() {
        const $tr = $('#costRow');
        $tr.empty();
        $tr.append('<th>' + MSG_LABEL_UNIT_PRICE + '</th>');

        MSG_TYCD_LIST.forEach(function(tycd) {
            const item = COST_MAP[tycd];
            const cost = item ? item.sndngCost : 0;

            const td = '<td data-tycd="' + tycd + '" style="cursor:pointer;" onclick="fn_clickCost(this, \'' + tycd + '\')">' + cost + '</td>';
            $tr.append(td);
        });
    }

    function fn_clickCost(td, tycd) {
        const $td = $(td);
        if ($td.hasClass('cost-edit')) return;
        $td.addClass('cost-edit');

        const item = COST_MAP[tycd];
        const currentCost = item ? item.sndngCost : 0;

        $td.css('cursor', 'default');
        $td.html(
            '<input type="text" style=\'width: 100px; text-align: right;\' value="' + currentCost + '" inputmask="numeric" '
            + 'onkeydown="if(event.key===\'Enter\') fn_saveCost(\'' + tycd + '\'); if(event.key===\'Escape\') fn_renderCostRow();">'
            + '<button type="button" class="btn type5 btn-save" onclick="fn_saveCost(\'' + tycd + '\')">' + MSG_LABEL_SAVE + '</button>'
        );
        $td.find('input').focus().select();
    }

    function fn_saveCost(tycd) {
        const $td = $('td[data-tycd="' + tycd + '"]');
        const newCost = $td.find('input').val();

        if (!newCost || isNaN(newCost) || Number(newCost) < 0) {
            UiComm.showMessage(MSG_INPUT_NUMBER, 'warning');
            $td.find('input').focus();
            return;
        }

        const item = COST_MAP[tycd];

        if (item && item.sndngCostId) {
            const param = {
                  encParams: EPARAM
                , addParams: UiComm.makeEncParams({ sndngCostId: item.sndngCostId, msgTycd: tycd, sndngCost: newCost, useyn: item.useyn || 'Y' })
            };
            ajaxCall('/admMsgSndngCostModifyAjax.do', param, function(res) {
                if (res.encParams) EPARAM = res.encParams;
                if (res.result > 0) {
                    fn_loadCostList();
                } else {
                    UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error");
                }
            }, function(xhr, status, error) {
                UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
            }, true);
        } else {
            const param = {
                  encParams: EPARAM
                , addParams: UiComm.makeEncParams({ msgTycd: tycd, sndngCost: newCost, useyn: 'Y' })
            };
            ajaxCall('/admMsgSndngCostRegistAjax.do', param, function(res) {
                if (res.encParams) EPARAM = res.encParams;
                if (res.result > 0) {
                    fn_loadCostList();
                } else {
                    UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error");
                }
            }, function(xhr, status, error) {
                UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
            }, true);
        }
    }
</script>
</head>

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
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th rowspan="2"><spring:message code="msg.sndngCost.label.gbn"/></th>
                                        <th rowspan="2"><spring:message code="msg.title.msg.alimTalk"/></th>
                                        <th colspan="2"><spring:message code="msg.sndngCost.label.sms"/></th>
                                    </tr>
                                    <tr>
                                        <th>SMS</th>
                                        <th>LMS</th>
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
