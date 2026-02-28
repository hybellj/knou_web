<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    
    <script type="text/javascript">
    	$(document).ready(function(){
    	});
    	var isCheckedEmailAuth = "${orgId}" == "ORG0000001" ? true : false;
    	
    	// 저장 확인
        function saveConfirm() {
        	var fileUploader = dx5.get("fileUploader");
        	// 파일이 있으면 업로드 시작
     		if (fileUploader.getFileCount() > 0) {
     			// 프로필 사진 변경시 현재 강의실 본인 프로필 사진이 변경됩니다. 프로필 사진을 변경하시겠습니까?
        		if(!confirm("<spring:message code='user.message.useredit.guide' />")) return;
     		
    			fileUploader.startUpload();
    		} else {
    			if($("#phtFileDelYn").is(":checked")) {
    				// 프로필 사진 변경시 현재 강의실 본인 프로필 사진이 변경됩니다. 프로필 사진을 변경하시겠습니까?
            		if(!confirm("<spring:message code='user.message.useredit.guide' />")) return;
    				
    				editUserProfile();
    			} else {
    				// 수정할 정보가 없어서 참 닫음.
        			window.parent.closeModal();
    			}
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
	    			$("#userProfileForm input[name=uploadFiles]").val(fileUploader.getUploadFiles());
	         		$("#userProfileForm input[name=copyFiles]").val(fileUploader.getCopyFiles());
	         		$("#userProfileForm input[name=uploadPath]").val("/user/${vo.userId}");
	        		
	         		editUserProfile();
	    		} else {
	    			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    		}
	    	}, function(xhr, status, error) {
	    		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    	});
        }

     	// 수정
     	function editUserProfile() {
     		if("${orgId}" != "ORG0000001") {
	     		if(!nullCheck()) {
	     			return false;
	     		}
	     		if(!passCheck()) {
	     			return false;
	     		}
	     		if(!isCheckedEmailAuth) {
	     			alert("<spring:message code='user.message.useredit.email.check' />");/* 이메일 인증을 해주세요. */
	     			return false;
	     		}
	     		setValue();
     		}
     		
     		// 프로필 사진 삭제여부 세팅
     		var phtFileDelYn = $("#phtFileDelYn").is(":checked") ? "Y" : "N";
     		$("#userProfileForm input[name=phtFileDelYn]").val(phtFileDelYn);
     		
     		showLoading();
     		var url = "/user/userHome/editUser.do";

    		$.ajax({
                url 	 : url,
                async	 : false,
                type 	 : "POST",
                dataType : "json",
                data     : $("#userProfileForm").serialize(),
            }).done(function(data) {
            	hideLoading();
            	if (data.result > 0) {
            		window.parent.location.reload();
                } else {
                 	alert(data.message);
                }
            }).fail(function() {
            	hideLoading();
            	alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
            });
     	}

     	// 빈 값 체크
     	function nullCheck() {
     		var isCheck = true;
     		var reg_email = /^([0-9a-zA-Z_\.-]+)@([0-9a-zA-Z_-]+)(\.[0-9a-zA-Z_-]+){1,2}$/;
     		
     		if($.trim($("#passChk").val()) == "") {
     			alert("<spring:message code='user.message.userjoin.validate.password.input' />");/* 비밀번호 확인을 입력해주세요. */
     			return false;
     		} else if(!reg_email.test($("#email").val())) {
    			alert("<spring:message code='user.message.userjoin.validate.email.format' />");/* 이메일 형식이 잘못되었습니다. */
    			return false;
    		} else if($.trim($("#userNm").val()) == "") {
    			alert("<spring:message code='user.message.userjoin.vaildate.user.nm.input' />");/* 이름을 입력해주세요. */
    			return false;
    		} else if($("#mobile2").val() == "" || $("#mobile3").val() == "") {
    			alert("<spring:message code='user.message.userjoin.vaildate.mobile.no.input' />");/* 휴대전화 번호를 입력해주세요. */
    			return false;
    		}
     		return isCheck;
     	}

     	// 비밀번호 확인
     	function passCheck() {
     		showLoading();
     		var url = "/user/userHome/userPassLoginCheck.do";
 			var data = {
 				"userId"   : "${vo.userId}",
 				"userPass" : $("#passChk").val()
 			};
        	
    		$.ajax({
                url   : url,
                async : false,
                type  : "POST",
                data  : data,
            }).done(function(data) {
            	hideLoading();
            	if (data.result > 0) {
                } else {
                 	alert("<spring:message code='user.message.userjoin.validate.password.check' />");/* 비밀번호 확인이 일치하지 않습니다. */
                 	return false;
                }
            }).fail(function() {
            	hideLoading();
            	alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
            });
     	}
     	
     	// 값 채우기
     	function setValue() {
     		$("#userProfileForm input[name=mobileNo]").val($("#mobile1").val()+"-"+$("#mobile2").val()+"-"+$("#mobile3").val());
     	}
     	
     	// 인증메일 발송
     	function senderAuthCode() {
     		var reg_email = /^([0-9a-zA-Z_\.-]+)@([0-9a-zA-Z_-]+)(\.[0-9a-zA-Z_-]+){1,2}$/;
     		if($("#email").val() == "") {
     			alert("<spring:message code='user.message.userjoin.vaildate.email.input' />");/* 이메일을 입력해주세요. */
     			return false;
     		} else {
	     		if(!reg_email.test($("#email").val())) {
	     			alert("<spring:message code='user.message.userjoin.validate.email.format' />");/* 이메일 형식이 잘못되었습니다. */
	    			return false;
	     		}
     		}
     		
     		showLoading();
     		var url = "/user/userHome/sendEmailAuth.do";
 			var data = {
 				"userEmailAuthId" : "${usrEmailAuthVO.userEmailAuthId}",
 				"receiverEmail"   : $("#email").val()
 			};
        	
    		$.ajax({
                url   : url,
                async : false,
                type  : "POST",
                data  : data,
            }).done(function(data) {
            	hideLoading();
            	if (data.result > 0) {
            		var returnVO = data.returnVO;
    				if(returnVO != null) {
    					var url  = "<%=CommConst.SYSMSG_URL_INSERT%>";
    					var rcvEmailArray = new Array();
    					var rcvEmailVO = null;
    	                rcvEmailVO = new Object();
    	                rcvEmailVO.rcvNo = returnVO.userId;                //수신자 개인번호1
    	                rcvEmailVO.rcvNm = returnVO.userNm;                //수신자 이름1
    	                rcvEmailVO.rcvEmailAddr = returnVO.rcvEmailAddr;   //수신자 이메일 주소1
    	                
    	                rcvEmailArray.push(rcvEmailVO);
    	                var rcvJsonData = JSON.stringify(rcvEmailArray).replace(/\"/gi, "\\\"");
    					
    		    		var data = {
    		    			"alarmType" 	: returnVO.alarmType,
    		    			"userId"		: returnVO.userId,
    		    			"userNm"		: returnVO.userNm,
    		    			"sysCd"			: returnVO.sysCd,
    		    			"orgId"			: returnVO.orgId,
    		    			"bussGbn"		: returnVO.bussGbn,
    		    			"sendRcvGbn"	: returnVO.sendRcvGbn,
    		    			"subject"		: returnVO.subject,
    		    			"ctnt"			: returnVO.ctnt,
    		    			"sendDttm"		: "",
    		    			"sndrPersNo"	: returnVO.sndrPersNo,
    		    			"sndrDeptCd"	: returnVO.sndrDeptCd,
    		    			"sndrNm"		: returnVO.sndrNm,
    		    			"sndrEmailAddr"	: returnVO.sndrEmailAddr,
    		    			"logDesc"		: returnVO.logDesc,
    		    			"rcvJsonData"	: rcvJsonData
    		    		};
    		    		
    		    		ajaxCall(url, data, function(data) {
    		    			if (data.result > 0) {
    		    				$("#authCode").prop("disabled", false);
    		    				alert("<spring:message code='user.message.useredit.email.transfer.succ' />");/* 인증메일이 전송되었습니다. */
    		    			} else {
    		    				$("#authCode").prop("disabled", true);
    		    				$("#authCode").val("");
    		                 	alert(data.message);
    		                }
    		    		}, function(xhr, status, error) {
    		    			alert("<spring:message code='user.message.login.reset.pass.failed' />");/* 이메일 전송과정에 문제가 발생했습니다. */
    		    		});
    				}
                } else {
                	alert(data.message);
                 	return false;
                }
            }).fail(function() {
            	hideLoading();
            	alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
            });
     	}
     	
     	// 이메일 인증 체크
    	function checkEmailAuth(value) {
    		isCheckedEmailAuth = false;
    		$("#emailAuthBtn").prop("disabled", false);   // 메일인증 버튼 활성화
    		
    		if(value.length == 8) {
    			// 이메일 인증코드 유효성 검사
    			var url = "/user/userHome/emailAuthCheck.do";
    			var data = {
	    		   	"authCode" 	: value,
	    		   	"email"		: $("#email").val()
	    		   };
	    		   
	    		ajaxCall(url, data, function(data) {
	    			if(data.result > 0) {
	                    alert("<spring:message code='user.message.useredit.email.auth.complete' />");/* 메일인증이 완료되었습니다. */
	                    $("#authCode").prop("disabled", true);     // 인증코드 input 비활성화
	                    $("#mailAuthText").html("");               // 인증코드 유효성 텍스트
	                    $("#emailAuthBtn").prop("disabled", true); // 메일인증 버튼 비활성화
	                    
	                    isCheckedEmailAuth = true;
	                } else {
	                    $("#authCode").prop("disabled", false);     // 인증코드 input 활성화
	                    $("#mailAuthText").html("<spring:message code='user.message.useredit.email.invalid.auth' />");/* 인증코드가 올바르지 않습니다. */
	                }
	    		}, function(xhr, status, error) {
	    		   	alert("<spring:message code='user.message.login.reset.pass.failed' />");/* 이메일 전송과정에 문제가 발생했습니다. */
	    		});
    		} else {
    			$("#authCode").prop("disabled", false);    // 인증코드 input 활성화
    			
    			// 인증코드 유효성 텍스트 세팅
    			if(value.length == 0) {
    				$("#mailAuthText").html("");
    			} else {
    				$("#mailAuthText").html("<spring:message code='user.message.useredit.email.empty.auth' />");/* 인증코드 8자리를 입력해주세요. */
    			}
    		}
    	}
    </script>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<body class="modal-page _<%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
            <div class="option-content">
                <div class="mla">
                </div>
            </div>
			<form name="userProfileForm" id="userProfileForm" method="POST" onsubmit="return false;">
	        	<input type="hidden" name="userId" value="${vo.userId}" />
	        	<input type="hidden" name="mobileNo" value="${vo.mobileNo}" />
	        	<input type="hidden" name="repoCd" value="USER_PROFILE" />
	        	<input type="hidden" name="uploadFiles" />
				<input type="hidden" name="copyFiles" />
				<input type="hidden" name="uploadPath" />
				<input type="hidden" name="phtFileDelYn" />
				<c:set var="reqClass" value="${orgId ne 'ORG0000001' ? 'req' : '' }" />
	            <div class="ui form userInfoManage">
	                    <div class="userImg">
	                        <div class="image">
			        				<c:choose>
			        					<c:when test="${not empty vo.phtFile}">
											<img alt="<spring:message code="crs.title.letcuser" /><spring:message code="lesson.label.img" />" style="max-width:100%;max-height:100%" src='${vo.phtFile}'>
			        					</c:when>
			        					<c:otherwise>
			        						<img alt="<spring:message code="crs.title.letcuser" /><spring:message code="lesson.label.img" />" style="max-width:100%;min-width:60%;max-height:100%" src="/webdoc/img/icon-hycu-symbol-grey.svg">
			        					</c:otherwise>
									</c:choose>
	                        </div>
	                    <c:if test="${not empty vo.phtFile}">
							<div class="ui checkbox">
		                    	<input type="checkbox" id="phtFileDelYn" tabindex="0" class="hidden" />
		                        <label class="toggle_btn" for="phtFileDelYn"><spring:message code="user.title.userinfo.profile.image" /><spring:message code="common.button.delete" /></label><!-- 프로필 사진 --> <!-- 삭제 -->
		                    </div>
			        	</c:if>
	                    </div>
	                    <ul class="tbl">
	                        <li>
	                            <dl>
	                                <dt><spring:message code="user.title.userinfo.affiliation" /></dt><!-- 소속 -->
	                                <dd>
	                                    ${vo.deptNm}
	                                    <%-- 
	                                    <div class="ui info small message flex p4">
	                                        <i class="icon info circle" aria-hidden="true"></i><spring:message code="user.message.useredit.org.info1" />
	                                        <!-- <spring:message code="user.message.useredit.org.info3" /> -->
	                                    </div>
	                                    --%>
	                                </dd>
	                            </dl>                            
	                        </li>
	                        <li>
	                            <dl>
	                                <dt><spring:message code="user.title.userinfo.manage.usernm" /></dt><!-- 이름 -->
	                                <dd>
										<c:choose>
						        				<c:when test="${orgId ne 'ORG0000001'}">
						        					<input type="text" id="userNm" name="userNm" value="${vo.userNm}" />
						        				</c:when>
						        				<c:otherwise>
							        				<b>${vo.userNm}</b>
							        				<input type="hidden" name="userNm" value="${vo.userNm}" />
						        				</c:otherwise>
						        			</c:choose>
										</dd>
	                                <dt><spring:message code="user.title.userinfo.user.no" /></dt><!-- 학번/사번 -->
	                                <dd>${vo.userId}</dd>
	                            </dl> 
	                        </li>
						<c:if test="${orgId ne 'ORG0000001' }">
				        	<li>
				        		<dl>
				        			 <dt><spring:message code="user.title.userjoin.password.confirm" /></dt><!-- 비밀번호 확인 -->
				        			 <dd><input type="password" placeholder="<spring:message code='user.message.search.input.userpass' />" id="passChk" /></dd><!-- 비밀번호 입력 -->
				        		<dl>
				        	</li>
				        </c:if>
	                        <li>
	                            <dl>
	                                <dt><spring:message code="user.title.userinfo.mobileno" /></dt><!-- 휴대폰 번호 -->
	                                <dd>
				        				<c:choose>
				        					<c:when test="${orgId ne 'ORG0000001' }">
						        				<div class="fields">
								        			<div class="field p_w30">
								        				<select class="ui dropdown wmax" id="mobile1">
								        					<c:forEach var="item" items="${phoneCodeList }">
								        						<option value="${item.codeCd }" ${fn:split(vo.mobileNo,'-')[0] ne item.codeCd ? 'selected' : '' }>${item.codeNm }</option>
								        					</c:forEach>
								        				</select>
								        			</div>
								        			<div class="field p_w5 tc f150 pt10">-</div>
								        			<div class="field p_w30">
								        				<input type="text" id="mobile2" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="4" value="${fn:split(vo.mobileNo,'-')[1] }" />
								        			</div>
								        			<div class="field p_w5 tc f150 pt10">-</div>
								        			<div class="field p_w30">
								        				<input type="text" id="mobile3" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="4" value="${fn:split(vo.mobileNo,'-')[2] }" />
								        			</div>
								        		</div>
				        					</c:when>
				        					<c:otherwise>
						        				<b>${vo.mobileNo }</b>
				        					</c:otherwise>
				        				</c:choose>
									</dd>
	                            </dl> 
	                        </li>
	                        <li>
	                            <dl>
	                                <dt><spring:message code="user.title.userinfo.email" /></dt><!-- 이메일 -->
	                                <dd>
		                                <c:choose>
					        				<c:when test="${orgId ne 'ORG0000001' }">
						        				<input type="text" placeholder="<spring:message code='user.message.search.input.email' />" id="email" name="email" /><!-- 이메일 입력 -->
						        				<div class="ui action input search-box mt5 wmax">
									                <input type="text" id="authCode" disabled placeholder="<spring:message code='user.title.userinfo.auth.code' />" onblur="checkEmailAuth(this.value);"><!-- 인증코드 -->
									                <button class="ui black button" id="emailAuthBtn" onclick="senderAuthCode()"><spring:message code='user.title.userinfo.mail.auth' /><!-- 메일인증 --></button>
									            </div>
									            <ul class="list-sm" style="color: red; font-size: small;" id="mailAuthText"></ul>
					        				</c:when>
					        				<c:otherwise>
												${vo.email}
					        				</c:otherwise>
					        			</c:choose>
	                                </dd>
	                            </dl>   
	                        </li>
	                        <li>
	                            <dl>
	                                <dt><spring:message code="user.title.userinfo.profile.image" /></dt><!-- 프로필 사진 -->
	                                <dd>
	                                	<uiex:dextuploader
											id="fileUploader"
											path="/user/${vo.userId }"
											limitCount="1"
											limitSize="3"
											oneLimitSize="3"
											listSize="1"
											finishFunc="finishUpload()"
											useFileBox="false"
											allowedTypes="jpg,jpeg,png.gif"
											style="single"
										/>                  
	                                </dd>
	                            </dl>   
	                        </li>
	                    </ul>
	                </div>
	            </div>
        	</form>
            <div class="bottom-content tc">
                <button class="ui blue button w100" onclick="saveConfirm()"><spring:message code="user.button.save" /></button><!-- 저장 -->
                <button class="ui basic blue button w100" onclick="window.parent.closeModal();"><spring:message code="user.button.cancel" /></button><!-- 취소 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
	
</html>
