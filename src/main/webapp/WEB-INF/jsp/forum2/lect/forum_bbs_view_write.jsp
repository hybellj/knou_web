<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<%-- ������ --%>
<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
</head>

<script type="text/javascript">
$(document).ready(function() {
});

//���� Ȯ��
function saveConfirm() {
	var fileUploader = dx5.get("fileUploader");
	// ������ ������ ���ε� ����
	if (fileUploader.getFileCount() > 0) {
		fileUploader.startUpload();
	}
	else {
		addActl();
	}
}

// ���� ���ε� �Ϸ�
function finishUpload() {
	var fileUploader = dx5.get("fileUploader");
	var url = "/file/fileHome/saveFileInfo.do";
	var data = {
		"uploadFiles" : fileUploader.getUploadFiles(),
		"copyFiles"   : fileUploader.getCopyFiles(),
		"uploadPath"  : fileUploader.getUploadPath()
	};
	
	ajaxCall(url, data, function(data) {
		if(data.result > 0) {
			$("#uploadFiles").val(fileUploader.getUploadFiles());
			
			addActl();
		} else {
			alert("<spring:message code='success.common.file.transfer.fail'/>1"); // ���ε带 �����Ͽ����ϴ�.
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='success.common.file.transfer.fail'/>2"); // ���ε带 �����Ͽ����ϴ�.
	});
}

// �Խñ� ���/����
function addActl(){
	var fileUploader = dx5.get("fileUploader");
	var oknokGbncd = $("#oknokGbncd").val();
	var cts = editor.getPublishingHtml();
	var atclStatus = $("#atclStatus").val();
	var uploadPath = $("#uploadPath").val();
	$("#copyFiles").val(fileUploader.getCopyFiles());
	$("#delFileIdStr").val(fileUploader.getDelFileIdStr());

	if(editor.isEmpty() || editor.getTextContent().trim() === ""){
		alert("<spring:message code='forum.forumBBsViewWrite.atcl'/>"); //��� ������ �Է����ֽñ� �ٶ��ϴ�.
		return false;
	} else {
		if(atclStatus == 'E') { // ����
			var dscsAtclId = $("#dscsAtclId").val();
			var url = "/forum2/forumLect/Form/editAtcl.do";
			var data = $("#forumAtclForm").serialize();
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					alert("<spring:message code='forum.alert.edit.forum.atcl_success'/>"); // ��� �Խñ� ������ �����Ͽ����ϴ�.
					window.parent.closeModal();
					window.parent.listForum(1);
				} else {
					alert("<spring:message code='forum.alert.edit.forum.atcl_fail'/>"); // ��� �Խñۿ� ������ �����Ͽ����ϴ�. �ٽ� �õ����ֽñ� �ٶ��ϴ�.
				}
			}, function(xhr, status, error) {
				alert("<spring:message code='forum.common.error'/>"); // ������ �߻��߽��ϴ�.
			}, true);
		} else { // ���
			var dscsAtclTycd = "${dscsForumVO.dscsUnitTycd}" + "_"+ "${dscsForumVO.prosConsForumCfg}";
			var dscsAtclId = $("#dscsAtclId").val();
			
			var url = "/forum2/forumLect/Form/addAtcl.do";
			var data = {
				"dscsAtclId" : dscsAtclId,
				"oknokGbncd" : oknokGbncd,
				"dscsAtclTycd"	: dscsAtclTycd,
				"atclCts" : cts,
				"dscsId" : "${dscsForumVO.dscsId}",
				"userId" : "${userId}",
				"userName" : "${userName}",
				"userType" : "P",
				"crsCreCd" : "${dscsForumVO.crsCreCd}",
				"uploadFiles" : fileUploader.getUploadFiles(),
				"uploadPath" : uploadPath,
				"repoCd" : "FORUM"
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					alert("<spring:message code='forum.alert.add.forum.atcl_success'/>"); // ��� �Խñ� ��Ͽ� �����Ͽ����ϴ�.
					window.parent.closeModal();
					window.parent.listForum(1);
				} else {
					alert("<spring:message code='forum.alert.add.forum.atcl_fail'/>"); // ��� �Խñۿ� ��Ͽ� �����Ͽ����ϴ�. �ٽ� �õ����ֽñ� �ٶ��ϴ�.
				}
			}, function(xhr, status, error) {
				alert("<spring:message code='forum.common.error'/>"); // ������ �߻��߽��ϴ�.
			}, true);
		}
		window.parent.listForum(1);
	}
}
</script>

<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="wrap">
		<div id="container">
			<!-- ���� content �κ� -->
			<div class="content stu_section">
				<c:set var="path" value="/forum2/${atclSn}" />
				<form:form id="forumAtclForm" name="forumAtclForm" method="post" action="">
				<input type="hidden" name="dscsId" id="dscsId" value="${dscsForumVO.dscsId}">
				<input type="hidden" name="userId" id="userId" value="${userId}">
				<input type="hidden" name="crsCreCd" id="crsCreCd" value="${dscsForumVO.crsCreCd}">
				<input type="hidden" name="repoCd" id="repoCd" value="FORUM">
				<input type="hidden" name="uploadPath" id="uploadPath" value="${path}">
				<input type="hidden" name="copyFiles" id="copyFiles" value="" />
				<input type="hidden" name="uploadFiles" id="uploadFiles" value="">
				<input type="hidden" name="delFileIdStr" id="delFileIdStr" value="">
				<input type="hidden" name="oknokGbncd" id = "oknokGbncd" value="F"/>
				<input type="hidden" name="atclStatus" id = "atclStatus" value="${empty forumAtclVO.dscsAtclId ? 'A' : 'E'}"/>
				<input type="hidden" name="dscsAtclId" id = "dscsAtclId" value="${atclSn}"/>
	
					<div class="ui segment">
						<div class="ui form">
							<ul class="tbl-simple st2">
								<li>
									<dl><dd style="height:300px">
									<div style="height:100%">
										<textarea name="atclCts" id="cts">${forumAtclVO.atclCts}</textarea>
										<script>
											// html ������ ����
											var editor = HtmlEditor('cts', THEME_MODE, '${path}');
										</script>
									</div>
									</dd></dl>
								</li>
								<li>
									<!-- ���Ͼ��δ� -->
									<uiex:dextuploader
										id="fileUploader"
										path="${path}"
										limitCount="5"
										limitSize="1024"
										oneLimitSize="1024"
										listSize="3"
										fileList="${fileList}"
										finishFunc="finishUpload()"
										useFileBox="true"
										allowedTypes="*"
										bigSize="false"
									/>
								</li>
							</ul>
						</div>
					</div>
				</form:form>
	
				<div class="bottom-content">
					<button class="ui blue cancel button" onclick="saveConfirm();return false;"><spring:message code='forum.button.save'/><!-- ���� --></button>
					<button class="ui black cancel button" onclick="window.parent.closeModal();return false;"><spring:message code='forum.button.close'/><!-- �ݱ� --></button>
				</div>
			</div>
		</div>
		<!-- //���� content �κ� -->
	</div>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
