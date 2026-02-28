<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
   	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
	<script type="text/javascript">
		$(document).ready(function() {
		});
		
		var excelAuthGrpExample = "${excelAuthGrpExample}";
		
		if("${isKnou}" == "true") {
			var excelGrid = {
				colModel:[
				    {label:"<spring:message code='user.title.userinfo.manage.userid' />*",	align:'left',	width:'4000',	colums:'A'},/* 아이디 */
				    {label:"<spring:message code='user.title.userinfo.password' />*",	align:'left',	width:'10000',	colums:'B',	headerMemo:{rowSize:'1',colSize:'2',text:`<spring:message code='user.title.userinfo.password.validation' />`}},/* 비밀번호 *//* 8~16자\n영/숫자/특수문자\n중 2개조합 */
				    {label:"<spring:message code='user.title.userinfo.manage.usernm' />*", align:'left',	width:'4000',	colums:'C'},/* 이름 */
				    {label:"<spring:message code='user.title.userinfo.manage.userdiv' />*", align:'left',	width:'13500',	colums:'D',	headerMemo:{rowSize:'1',colSize:'4',text:excelAuthGrpExample+"<spring:message code='user.title.userinfo.auth.grp.validation' />"}},/* 구분 *//* \n(다수입력시 ','로 구분)\n교수, (조교,사용자,비인가자)는 같이 사용 불가능 */
				    {label:"<spring:message code='user.title.userdept.dept.nm' />*", align:'left',	width:'9000',	colums:'E',	headerMemo:{rowSize:'1',colSize:'2',text:"<spring:message code='user.message.userdept.menu.reference' />"}},/* 학과명 *//* 학과관리 메뉴의 학과명 참조 */
				    //{label:"<spring:message code='user.title.userinfo.grade' />", align:'left',	width:'9000',	colums:'F',	headerMemo:{rowSize:'1',colSize:'3',text:userGradeExample}},/* 학년 */
				    {label:"<spring:message code='user.title.userinfo.phoneno' />*", align:'left',	width:'4000',	colums:'F'},/* 전화번호 */
				    {label:"<spring:message code='user.title.userinfo.manage.email' />*", align:'left',	width:'6000',	colums:'G'}/* 이메일 */
				]
			};
		} else {
			var excelGrid = {
				colModel:[
				    {label:"<spring:message code='user.title.userinfo.manage.userid' />*",	align:'left',	width:'4000',	colums:'A'}, // 학번
				    {label:"<spring:message code='user.title.userinfo.rrnend.front' />*",	align:'left',	width:'10000',	colums:'B'}, // 주민등록번호 앞자리
				    {label:"<spring:message code='user.title.userinfo.manage.usernm' />*", align:'left',	width:'4000',	colums:'C'}, // 이름
				    {label:"<spring:message code='user.title.userinfo.manage.userdiv' />*", align:'left',	width:'13500',	colums:'D',	headerMemo:{rowSize:'1',colSize:'4',text:excelAuthGrpExample+"<spring:message code='user.title.userinfo.auth.grp.validation' />"}},/* 구분 *//* \n(다수입력시 ','로 구분)\n교수, (조교,사용자,비인가자)는 같이 사용 불가능 */
				    {label:"<spring:message code='user.title.userdept.dept.nm' />", align:'left',	width:'9000',	colums:'E',	headerMemo:{rowSize:'1',colSize:'2',text:"<spring:message code='user.message.userdept.menu.reference' />"}},/* 학과명 *//* 학과관리 메뉴의 학과명 참조 */
				    //{label:"<spring:message code='user.title.userinfo.grade' />", align:'left',	width:'9000',	colums:'F',	headerMemo:{rowSize:'1',colSize:'3',text:userGradeExample}},/* 학년 */
				    {label:"<spring:message code='user.title.userinfo.phoneno' />", align:'left',	width:'4000',	colums:'F'},/* 전화번호 */
				    {label:"<spring:message code='user.title.userinfo.manage.email' />*", align:'left',	width:'6000',	colums:'G'}/* 이메일 */
				]
			};
		}
		
		// 등록
		function uploadExcel(fileObj) {
			var fileUploader = dx5.get("fileUploader");
			var url = '/user/userMgr/userExcelUpload.do';
			var data = {
				  uploadFiles   : fileObj
				, uploadPath	: "/user"
				, repoCd		: "EXCEL_UPLOAD"
				, excelGrid		: JSON.stringify(excelGrid)
			}
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
	            	  alert("<spring:message code='user.message.userinfo.excel.upload.success' />"); // 엑셀 업로드 사용자 등록이 완료되었습니다.
	                  window.parent.listUser(1);
	                  window.parent.closeModal();
	              } else {
	                  alert(data.message);
	                  fileUploader.clearItems();
	                  
	              }
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />"); // 에러가 발생했습니다!
			}, true);
		}
		
		// 엑셀 샘플 다운로드
		function sampleExcelDown() {
			$("form[name='excelForm']").remove();
			var excelForm = $('<form></form>');
	        excelForm.attr("name","excelForm");
	        excelForm.attr("action","/user/userMgr/userExcelSampleDownload.do");
	        excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', value:JSON.stringify(excelGrid)}));
	        excelForm.appendTo('body');
	        excelForm.submit();
		}
		
		// 저장 확인
		function saveConfirm() {
			var fileUploader = dx5.get("fileUploader");
			// 파일이 있으면 업로드 시작
			if (fileUploader.getFileCount() > 0) {
				fileUploader.startUpload();
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
	    			var fileObj = fileUploader.getUploadFiles();
	    			
	    			uploadExcel(fileObj);
	    		} else {
	    			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    		}
	    	}, function(xhr, status, error) {
	    		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    	});
		}
	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
		<div class="ui info message">
			<p><spring:message code="common.excel.upload.warning.title.msg" /></p><!-- 주의사항 -->
       		<ul class="notice_list">
	            <li><i>&middot;</i><span><spring:message code="common.excel.upload.warning.msg1" /></span></li><!-- xlsx 파일만 업로드해야 하며, 지정된 형식을 맞춰야 합니다. 지정된 형식은 샘플 다운로드 받으시면 자세히 보실 수 있습니다. -->
	            <li><i>&middot;</i><span><spring:message code="common.excel.upload.warning.msg2" /></span></li><!-- 잘못된 형식으로 파일을 등록하면, 정보가 제대로 적용되지 않을 수 있습니다. -->
	            <li><i>&middot;</i><span><spring:message code="common.excel.upload.warning.msg3" /></span></li><!-- 샘플 파일의 명시사항을 절대 수정하지 마시고, 입력란에 데이터를 입력, 저장 후 등록해 주세요. -->
	            <li><i>&middot;</i><span><spring:message code="common.excel.upload.warning.msg4" /></span></li><!-- 자료를 작성하실 때 항목은 빈란으로 두지 마세요. -->
			</ul>
       	</div>
       	<button class="ui basic button mb10" onclick="sampleExcelDown()"><spring:message code="exam.button.excel.sample.down" /></button><!-- 엑셀 샘플 다운로드 -->
		<div id="fileUploadBlock">
			<!-- 파일업로더 -->
			<uiex:dextuploader
				id="fileUploader"
				path="/user"
				limitCount="1"
				limitSize="100"
				oneLimitSize="100"
				listSize="2"
				finishFunc="finishUpload()"
				useFileBox="false"
				allowedTypes="xlsx"
			/>
		</div>
       	
		<div class="bottom-content mt50">
			<button class="ui blue button" onclick="saveConfirm()"><spring:message code="user.button.reg" /></button><!-- 등록 -->
			<button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code='user.button.close' /></button><!-- 닫기 -->
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>