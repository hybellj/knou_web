<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="admin"/>
			<jsp:param name="module" value="table"/>
		</jsp:include>
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
		// 저장
		function save() {
			let validator = UiValidator("authrtForm");
			validator.then(function(result) {
				if (result) {
					const url = "/smnr/pltfrm/admOnlnPltfrmAdmAcntRegistAjax.do";

					ajaxCall(url, $("#authrtForm").serialize(), function(data) {
						if (data.result > 0) {
							UiComm.showMessage("저장이 완료되었습니다.", "success", 500)
							.then(function(result) {
								window.parent.onlnPltfrmAuthrtListSelect(1);
			                    window.parent.closeDialog();
							});
					    } else {
					    	UiComm.showMessage(data.message, "error");
					    }
					}, function(xhr, status, error) {
						UiComm.showMessage("<spring:message code='exam.error.insert' />", "error");	/* 저장 중 에러가 발생하였습니다. */
					}, true);
				}
			});
		}
	</script>

	<body class="modal-page">
        <div id="wrap">
        	<form id="authrtForm" method="POST" onsubmit="return false;">
        		<input type="hidden" name="onlnPltfrmStngId"	value="${vo.onlnPltfrmStngId }" />
        		<input type="hidden" name="pltfrmGbncd" 		value="${vo.pltfrmGbncd }" />
	        	<table class="table-type3 text-left">
	        		<colgroup>
	        			<col class="width-25per" />
	        			<col />
	        		</colgroup>
	        		<tbody>
	        			<tr>
	        				<th colspan="2">ZOOM 관리자 계정 정보</th>
	        			</tr>
	        			<tr class="cpn">
	        				<th class="req">기관</th>
	        				<td>
	        					<select class="form-select wide" name="orgId">
	                            	<c:forEach var="org" items="${orgList }">
	                            		<option value="${org.orgId }" ${org.orgId eq vo.orgId ? 'selected' : '' }>${org.orgnm }</option>
	                            	</c:forEach>
	                            </select>
	        				</td>
	        			</tr>
	        			<tr>
	        				<th class="req">API ACCOUNT ID</th>
	        				<td><input type="text" class="width-100per" name="pltfrmCntnId" inputmask="byte" maxLen="300" required="true" ${not empty vo.onlnPltfrmStngId ? 'placeholder="새로 입력"' : '' } /></td>
	        			</tr>
	        			<tr>
	        				<th class="req">API CLIENT ID</th>
	        				<td><input type="text" class="width-100per" name="pltfrmCntnClientId" inputmask="byte" maxLen="300" required="true" ${not empty vo.onlnPltfrmStngId ? 'placeholder="새로 입력"' : '' } /></td>
	        			</tr>
	        			<tr>
	        				<th class="req">API CLIENT SECRET</th>
	        				<td><input type="text" class="width-100per" name="pltfrmCntnClientPswd" inputmask="byte" maxLen="300" required="true" ${not empty vo.onlnPltfrmStngId ? 'placeholder="새로 입력"' : '' } /></td>
	        			</tr>
	        		</tbody>
	        	</table>
        	</form>

            <div class="btns">
                <button class="btn type2" onclick="save()">저장</button>
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>