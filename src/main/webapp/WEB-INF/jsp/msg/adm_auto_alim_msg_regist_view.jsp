<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
    </jsp:include>
</head>

<script type="text/javascript">
    let EPARAM = '<c:out value="${encParams}" />';
    const LIST_EPARAM = EPARAM;

    function fn_save() {
        if (!fn_validate()) return;

        let tycds = [];
        $('input[name=autoAlimTrgtTycds]:checked').each(function() {
            tycds.push($(this).val());
        });

        let extData = {
            orgId: $('#orgId').val(),
            autoAlimnm: $('#autoAlimnm').val().trim(),
            autoAlimMsgCts: $('#autoAlimMsgCts').val().trim(),
            sndngCndtnCts: $('#sndngCndtnCts').val().trim(),
            autoAlimTrgtTycdStr: tycds.join(',')
        };

        let param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams(extData)
        };

        ajaxCall('/admAutoAlimMsgRegistAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0) {
                UiComm.showMessage('등록되었습니다.', 'success');
                fn_goList();
            } else {
                UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error");
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    function fn_validate() {
        if (!$('#orgId').val()) {
            UiComm.showMessage('기관을 선택하세요.', 'warning');
            $('#orgId').focus();
            return false;
        }
        if (!$('#autoAlimnm').val().trim()) {
            UiComm.showMessage('자동 알림 구분을 입력하세요.', 'warning');
            $('#autoAlimnm').focus();
            return false;
        }
        if (!$('#autoAlimMsgCts').val().trim()) {
            UiComm.showMessage('사용 문구 예시를 입력하세요.', 'warning');
            $('#autoAlimMsgCts').focus();
            return false;
        }
        if (!$('#sndngCndtnCts').val().trim()) {
            UiComm.showMessage('발신 조건을 입력하세요.', 'warning');
            $('#sndngCndtnCts').focus();
            return false;
        }
        if ($('input[name=autoAlimTrgtTycds]:checked').length === 0) {
            UiComm.showMessage('알림 대상을 선택하세요.', 'warning');
            return false;
        }
        return true;
    }

    function fn_goList() {
        let form = $('<form></form>');
        form.attr('method', 'POST');
        form.attr('action', '/admAutoAlimMsgListView.do');
        form.append($('<input/>', { type: 'hidden', name: 'encParams', value: LIST_EPARAM }));
        form.appendTo('body');
        form.submit();
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

                        <div class="box">
                            <div class="board_top">
                                <h3 class="board-title">등록</h3>
                            </div>

                            <!-- table-type -->
                            <div class="table-wrap">
                                <table class="table-type5">
                                    <colgroup>
                                        <col class="width-15per" />
                                        <col />
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                            <th><label for="orgId" class="req">기관</label></th>
                                            <td>
                                                <div class="form-row">
                                                    <select class="form-select" id="orgId">
                                                        <option value="">선택</option>
                                                        <c:forEach var="org" items="${orgList}">
                                                            <option value="${org.orgId}"><c:out value="${org.orgnm}"/></option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><label for="autoAlimnm" class="req">자동 알림 구분</label></th>
                                            <td>
                                                <div class="form-row">
                                                    <input class="form-control width-100per" type="text" id="autoAlimnm" maxlength="300">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><label for="autoAlimMsgCts" class="req">사용 문구 예시</label></th>
                                            <td>
                                                <div class="form-row">
                                                    <input class="form-control width-100per" type="text" id="autoAlimMsgCts" maxlength="4000">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><label for="sndngCndtnCts" class="req">발신 조건</label></th>
                                            <td>
                                                <div class="form-row">
                                                    <input class="form-control width-100per" type="text" id="sndngCndtnCts" maxlength="500">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><label class="req">알림 대상</label></th>
                                            <td>
                                                <div class="form-row">
                                                    <span class="custom-input"><input type="checkbox" name="autoAlimTrgtTycds" id="chkWHOL_PROF" value="WHOL_PROF"><label for="chkWHOL_PROF">전체 교수</label></span>
                                                    <span class="custom-input"><input type="checkbox" name="autoAlimTrgtTycds" id="chkCHRG_PROF" value="CHRG_PROF"><label for="chkCHRG_PROF">담당 교수</label></span>
                                                    <span class="custom-input"><input type="checkbox" name="autoAlimTrgtTycds" id="chkWHOL_TUT" value="WHOL_TUT"><label for="chkWHOL_TUT">전체 튜터</label></span>
                                                    <span class="custom-input"><input type="checkbox" name="autoAlimTrgtTycds" id="chkCHRG_TUT" value="CHRG_TUT"><label for="chkCHRG_TUT">담당 튜터</label></span>
                                                    <span class="custom-input"><input type="checkbox" name="autoAlimTrgtTycds" id="chkWHOL_ASSI" value="WHOL_ASSI"><label for="chkWHOL_ASSI">전체 조교</label></span>
                                                    <span class="custom-input"><input type="checkbox" name="autoAlimTrgtTycds" id="chkCHRG_ASSI" value="CHRG_ASSI"><label for="chkCHRG_ASSI">담당 조교</label></span>
                                                    <span class="custom-input"><input type="checkbox" name="autoAlimTrgtTycds" id="chkWHOL_STDNT" value="WHOL_STDNT"><label for="chkWHOL_STDNT">전체 수강생</label></span>
                                                    <span class="custom-input"><input type="checkbox" name="autoAlimTrgtTycds" id="chkSBJCT_STDNT" value="SBJCT_STDNT"><label for="chkSBJCT_STDNT">해당 과목 수강생</label></span>
                                                    <span class="custom-input"><input type="checkbox" name="autoAlimTrgtTycds" id="chkSTDNT" value="STDNT"><label for="chkSTDNT">해당 수강생</label></span>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <!-- //table-type -->
                        </div>

                        <div class="btns">
                            <button type="button" class="btn type1" onclick="fn_save()">저장</button>
                            <button type="button" class="btn type2" onclick="fn_goList()">목록</button>
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
