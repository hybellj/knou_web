<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<%-- 에디터 --%>
<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
</head>

<script type="text/javascript">
$(document).ready(function() {
});

//저장 확인
function saveConfirm() {
	var fileUploader = dx5.get("fileUploader");
	// 파일이 있으면 업로드 시작
	if (fileUploader.getFileCount() > 0) {
		fileUploader.startUpload();
	}
	else {
		addActl();
	}
}

// 파일 업로드 완료
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
			alert("<spring:message code='success.common.file.transfer.fail'/>1"); // 업로드를 실패하였습니다.
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='success.common.file.transfer.fail'/>2"); // 업로드를 실패하였습니다.
	});
}

// 게시글 등록/수정
function addActl(){
	var fileUploader = dx5.get("fileUploader");
	var prosConsTypeCd = $("#prosConsTypeCd").val();
	var cts = editor.getPublishingHtml();
	var atclStatus = $("#atclStatus").val();
	var uploadPath = $("#uploadPath").val();
	$("#copyFiles").val(fileUploader.getCopyFiles());
	$("#delFileIdStr").val(fileUploader.getDelFileIdStr());

	if(editor.isEmpty() || editor.getTextContent().trim() === ""){
		alert("<spring:message code='forum.forumBBsViewWrite.atcl'/>"); //토론 내용을 입력해주시기 바랍니다.
		return false;
	} else {
		if(atclStatus == 'E') { // 수정
			var atclSn = $("#atclSn").val();
			var url = "/forum/forumLect/Form/editAtcl.do";
			var data = $("#forumAtclForm").serialize();
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					alert("<spring:message code='forum.alert.edit.forum.atcl_success'/>"); // 토론 게시글 수정에 성공하였습니다.
					window.parent.closeModal();
					window.parent.listForum(1);
				} else {
					alert("<spring:message code='forum.alert.edit.forum.atcl_fail'/>"); // 토론 게시글에 수정에 실패하였습니다. 다시 시도해주시기 바랍니다.
				}
			}, function(xhr, status, error) {
				alert("<spring:message code='forum.common.error'/>"); // 에러가 발생했습니다.
			}, true);
		} else { // 등록
			var atclTypeCd = "${forumVo.forumCtgrCd}" + "_"+ "${forumVo.prosConsForumCfg}";
			var atclSn = $("#atclSn").val();
			
			var url = "/forum/forumLect/Form/addAtcl.do";
			var data = {
				"atclSn" : atclSn,
				"prosConsTypeCd" : prosConsTypeCd,
				"atclTypeCd"	: atclTypeCd,
				"cts" : cts,
				"forumCd" : "${forumVo.forumCd}",
				"userId" : "${userId}",
				"userName" : "${userName}",
				"userType" : "P",
				"crsCreCd" : "${forumVo.crsCreCd}",
				"uploadFiles" : fileUploader.getUploadFiles(),
				"uploadPath" : uploadPath,
				"repoCd" : "FORUM"
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					alert("<spring:message code='forum.alert.add.forum.atcl_success'/>"); // 토론 게시글 등록에 성공하였습니다.
					window.parent.closeModal();
					window.parent.listForum(1);
				} else {
					alert("<spring:message code='forum.alert.add.forum.atcl_fail'/>"); // 토론 게시글에 등록에 실패하였습니다. 다시 시도해주시기 바랍니다.
				}
			}, function(xhr, status, error) {
				alert("<spring:message code='forum.common.error'/>"); // 에러가 발생했습니다.
			}, true);
		}
		window.parent.listForum(1);
	}
}
</script>

<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="wrap">
		<div id="container">
			<!-- 본문 content 부분 -->
			<div class="content stu_section">
				<c:set var="path" value="/forum/${atclSn}" />
				<form:form id="forumAtclForm" name="forumAtclForm" method="post" action="">
				<input type="hidden" name="forumCd" id="forumCd" value="${forumVo.forumCd}">
				<input type="hidden" name="userId" id="userId" value="${userId}">
				<input type="hidden" name="crsCreCd" id="crsCreCd" value="${forumVo.crsCreCd}">
				<input type="hidden" name="repoCd" id="repoCd" value="FORUM">
				<input type="hidden" name="uploadPath" id="uploadPath" value="${path}">
				<input type="hidden" name="copyFiles" id="copyFiles" value="" />
				<input type="hidden" name="uploadFiles" id="uploadFiles" value="">
				<input type="hidden" name="delFileIdStr" id="delFileIdStr" value="">
				<input type="hidden" name="prosConsTypeCd" id = "prosConsTypeCd" value="F"/>
				<input type="hidden" name="atclStatus" id = "atclStatus" value="${empty forumAtclVO.atclSn ? 'A' : 'E'}"/>
				<input type="hidden" name="atclSn" id = "atclSn" value="${atclSn}"/>
	
					<div class="ui segment">
						<div class="ui form">
							<ul class="tbl-simple st2">
								<li>
									<dl><dd style="height:300px">
									<div style="height:100%">
										<textarea name="cts" id="cts">${forumAtclVO.cts}</textarea>
										<script>
											// html 에디터 생성
											var editor = HtmlEditor('cts', THEME_MODE, '${path}');
										</script>
									</div>
									</dd></dl>
								</li>
								<li>
									<!-- 파일업로더 -->
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
					<button class="ui blue cancel button" onclick="saveConfirm();return false;"><spring:message code='forum.button.save'/><!-- 저장 --></button>
					<button class="ui black cancel button" onclick="window.parent.closeModal();return false;"><spring:message code='forum.button.close'/><!-- 닫기 --></button>
				</div>
			</div>
		</div>
		<!-- //본문 content 부분 -->
	</div>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
