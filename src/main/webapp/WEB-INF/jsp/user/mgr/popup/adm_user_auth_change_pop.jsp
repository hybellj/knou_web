<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
    </jsp:include>
    <script type="text/javascript">
        const CTX = '<%=request.getContextPath()%>';
        let EPARAM = '<c:out value="${encParams}" />';
        const USER_ID = '<c:out value="${detail.userId}" />';

        function fn_saveAuth() {
            const authrtId = $('input[name=authrtId]:checked').val();
            if (!authrtId) {
                UiComm.showMessage('관리자 구분을 선택해 주세요.', 'warning');
                return;
            }

            ajaxCall(CTX + '/user/userMgr/admModifyUserMgrAuth.do', {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams({userId: USER_ID, authrtId: authrtId})
            }, function(res) {
                if (res.encParams) {
                    EPARAM = res.encParams;
                }
                if (res.result > 0) {
                    UiComm.showMessage(res.message || '권한이 변경되었습니다.', 'success').then(function() {
                        if (window.parent && typeof window.parent.fn_authChangeCallback === 'function') {
                            window.parent.fn_authChangeCallback();
                        }
                    });
                } else {
                    UiComm.showMessage(res.message || '처리 중 오류가 발생하였습니다.', 'error');
                }
            }, function() {
                UiComm.showMessage('처리 중 오류가 발생하였습니다.', 'error');
            }, true);
        }
    </script>
</head>

<body class="modal-page">
<div id="wrap">
    <div class="modal-body">
        <div class="table-wrap">
            <c:set var="curAdminNm" value=""/>
            <c:forEach var="item" items="${authrtList}">
                <c:forEach var="ownId" items="${userAuthrtIds}">
                    <c:if test="${ownId eq item.authrtId}"><c:set var="curAdminNm" value="${item.authrtnm}"/></c:if>
                </c:forEach>
            </c:forEach>
            <table class="table-type3">
                <colgroup>
                    <col><col><col><col><col><col><col style="width:20%">
                </colgroup>
                <thead>
                    <tr>
                        <th scope="col">관리자 구분</th>
                        <th scope="col">사용자 구분</th>
                        <th scope="col">기관</th>
                        <th scope="col">학과/부서</th>
                        <th scope="col">학번/사번</th>
                        <th scope="col">이름</th>
                        <th scope="col">관리</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td data-th="관리자 구분"><c:out value="${empty curAdminNm ? '-' : curAdminNm}"/></td>
                        <td data-th="사용자 구분">교직원</td>
                        <td data-th="기관"><c:out value="${detail.orgnm}"/></td>
                        <td data-th="학과/부서"><c:out value="${detail.deptnm}"/></td>
                        <td data-th="학번/사번" class="fcRed"><c:out value="${detail.stdntNo}"/></td>
                        <td data-th="이름" class="fcBlue"><c:out value="${detail.usernm}"/></td>
                        <td data-th="관리" class="t_left">
                            <ul>
                                <c:forEach var="item" items="${authrtList}">
                                    <c:set var="checkedYn" value="N"/>
                                    <c:forEach var="ownId" items="${userAuthrtIds}">
                                        <c:if test="${ownId eq item.authrtId}"><c:set var="checkedYn" value="Y"/></c:if>
                                    </c:forEach>
                                    <li>
                                        <span class="custom-input">
                                            <input type="radio" name="authrtId" id="auth_${item.authrtId}" value="${item.authrtId}" <c:if test="${checkedYn eq 'Y'}">checked="checked"</c:if>/>
                                            <label for="auth_${item.authrtId}"><c:out value="${item.authrtnm}"/></label>
                                        </span>
                                    </li>
                                </c:forEach>
                            </ul>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="btns">
            <button type="button" class="btn type1" onclick="fn_saveAuth();">저장</button>
            <button type="button" class="btn type2" onclick="window.parent.closeDialog();">닫기</button>
        </div>
    </div>
</div>
<script type="text/javascript" src="<c:url value='/webdoc/js/iframe-content.js'/>"></script>
</body>
</html>
