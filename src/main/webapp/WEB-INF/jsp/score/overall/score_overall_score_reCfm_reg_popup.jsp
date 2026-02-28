<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
	    <script type="text/javascript" src="/webdoc/js/iframe.js"></script>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    <script type="text/javascript">
    $(document).ready(function() {
    });
    
    function finishUpload(){
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
    	    	var uploadPath = fileUploader.getUploadPath();

    	    	onReCfmRegSave(fileObj, uploadPath);
    		} else {
    			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
    		}
    	}, function(xhr, status, error) {
    		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
    	});
	}
    
    // 저장 확인
    function saveConfirm() {
    	if(!$.trim($("#overAllRegText").val())) {
    		alert('<spring:message code="score.alert.objt.reg.text.empty" />'); // 신청사유를 작성해주세요.
    		return;
    	}
    	
    	// 파일이 있으면 업로드 시작
    	var fileUploader = dx5.get("fileUploader");
 		if (fileUploader.getFileCount() > 0) {
 			// 신청 후에는 수정 불가합니다. 신청하시겠습니까 ?
			if(confirm('<spring:message code="score.label.ect.eval.oper.msg7" />')){
				fileUploader.startUpload();
			}
		} else {
			// 신청 후에는 수정 불가합니다. 신청하시겠습니까 ?
			if(confirm('<spring:message code="score.label.ect.eval.oper.msg7" />')){
				onReCfmRegSave();
			}
		}
    }
    
	 // 등록
	function onReCfmRegSave(fileObj, uploadPath) {
		 var fileUploader = dx5.get("fileUploader");
		 var delFileIds = fileUploader.getDelFileIds();
		 var url = "/score/scoreOverall/insertStdScoreObjt.do";
		 
		 var data = {
		       uploadFiles	: fileObj, 
		       uploadPath	: uploadPath,
		       objtCtnt		: $("#overAllRegText").val(),
		       stdNo		: "${stdVo.stdNo}",
		       scoreObjtCd	: "${stdVo.scoreObjtCd}",
		       delFileIds	: delFileIds,
		       crsCreCd		: "${stdVo.crsCreCd}"
		 };
		
		 ajaxCall(url, data, function(data) {
			 if(data.result > 0) {
				 /* 성적 재확인 신청 성공 하였습니다. */
			 	 alert('<spring:message code="score.label.ect.eval.oper.msg7_1" />');
			 	 if(typeof window.parent.scoreReCfmModPopupCallBack === "function") {
			 		window.parent.scoreReCfmModPopupCallBack();
			 	 } else {
			 		window.parent.onObjtSearch();
			 	 }
			 	 window.parent.closeModal();
			 } else {
				 alert(data.message);
				 window.parent.closeModal();
			 }
		 }, function(xhr, status, error) {
			 /* 성적 재확인 신청 실패 하였습니다. */
		 	 alert('<spring:message code="score.label.ect.eval.oper.msg7" />');
		 }, true);
	}
    </script>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
            <div class="ui form">
            	<div class="flex1 flex-column" style="display: flex;">
	                <ul class="tbl flex0">
	                    <li>
	                        <dl>            
	                            <dt><spring:message code="std.label.crscre_dept" /></dt><!-- 개설학과 -->
	                            <dd>${tchVo.crsNm}</dd>   
	                            <dt><spring:message code="std.label.crs_cd" /></dt><!-- 학수번호 -->
	                            <dd>${tchVo.crsCreCd}</dd>     
	                        </dl> 
	                    </li>
	                    <li>  
	                        <dl>            
	                            <dt><spring:message code="exam.label.subject.nm" /></dt><!-- 교과명 -->
	                            <dd>${tchVo.crsCreNm}</dd>   
	                            <dt><spring:message code="filemgr.label.crsauth.partclass" /></dt><!-- 분반 -->
	                            <dd>${tchVo.declsNo}</dd>     
	                        </dl>
	                    </li>
	                    <li>        
	                        <dl>            
	                            <dt><spring:message code="common.label.prof.nm" /></dt><!-- 교수명 -->
	                            <dd>${tchVo.tchNm}</dd>   
	                            <dt><spring:message code="common.label.tutor" /></dt><!-- 개별지도교사 -->
	                            <dd>${tchVo.assNm}</dd>     
	                        </dl>  
	                    </li>   
	                </ul>
	            </div>
	           
	            <div class="flex1 flex-column" style="display: flex;">
	                <ul class="tbl flex0">
	                    <li>        
	                        <dl>            
	                            <dt><spring:message code="forum.label.user.no" /></dt><!-- 학번 -->
	                            <dd>${stdVo.stdUserId}</dd>   
	                            <dt><spring:message code="exam.label.user.nm" /></dt><!-- 이름 -->
	                            <dd>${stdVo.stdUserNm}</dd>     
	                        </dl> 
	                    </li>
	                    <li>  
	                        <dl>            
	                            <dt><spring:message code="exam.label.dept" /></dt><!-- 학과 -->     
	                            <dd>${stdVo.stdDeptNm}</dd>   
	                            <dt><spring:message code="exam.label.mobile.no" /></dt><!-- 연락처 -->
	                            <dd>${stdVo.stdMobileNo}</dd>     
	                        </dl>
	                    </li>
	                    <li> 
	                        <dl>            
	                            <dt><label for="overAllRegText"><spring:message code="score.label.request.reason" /></label></dt><!-- 신청사유 -->
	                            <dd style="height:250px">
                            		<div style="height:100%">
                                   		<textarea name="overAllRegText" id="overAllRegText" rows="10" style="height:100%">${stdVo.objtCtnt}</textarea>
                                   	</div>	    
	                            </dd>   
	                        </dl>
	                    </li>       
	                    <li> 
	                        <dl>            
	                            <dt><spring:message code="common.label.attend" /></dt><!-- 자료첨부 -->        
	                            <dd>
									<uiex:dextuploader
										id="fileUploader"
										path="/score/scoreObjt"
										limitCount="1"
										limitSize="100"
										oneLimitSize="100"
										listSize="2"
										finishFunc="finishUpload()"
										useFileBox="false"
										allowedTypes="*"
									/>		   
	                            </dd>   
	                        </dl>
	                    </li>  
	                </ul>
	            </div>
                <span><spring:message code="score.label.ect.eval.oper.msg8" /></span><br/><!-- 이상의 성적 재확인신청을 담당 과목 교수님께 보냅니다. -->
                <span><spring:message code="user.title.userinfo.date.reg" /> : ${curYear}<spring:message code="exam.label.year" /> ${curMonth}<spring:message code="exam.label.month" /> ${curDay}<spring:message code="exam.label.day" /></span><br/><!-- 신청일 년월일 -->
                <span><spring:message code="exam.label.applicant" /> : ${stdVo.stdUserNm}</span><br/><!-- 신청자 -->
	            <div class="bottom-content">
	            <c:choose>
	            	<c:when test="${not empty stdVo.scoreObjtCd}">
	            		<button type="button" class="ui blue button" onclick="saveConfirm();"><spring:message code="common.button.modify" /></button><!-- 수정 -->
	            	</c:when>
	            	<c:otherwise>
	            		<button type="button" class="ui blue button" onclick="saveConfirm();"><spring:message code="common.label.request" /></button><!-- 신청 -->
	            	</c:otherwise>
	            </c:choose>
	                <button type="button" class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
	            </div>
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
