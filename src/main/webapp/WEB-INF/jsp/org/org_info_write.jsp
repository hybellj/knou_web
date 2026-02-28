<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	
	<%-- 에디터 --%>
	<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>


	<script type="text/javascript">
		var pwdValidation = false;
		var pwdConfirm = false;
		var idDuplication = false;
	
		$(document).ready(function() {
			
		});
		
		// 저장 확인
		function saveConfirm() {
			if(!$.trim($("#orgId").val())) {
				var msg = '<spring:message code="common.label.org.cd" />'; // 소속코드
				alert('<spring:message code="errors.required" arguments="' + msg + '" />'); // [{0}]은 필수 입력값입니다.
				$("#orgId").focus();
				return;
			}
			
			if(!$.trim($("#orgNm").val())) {
				var msg = '<spring:message code="common.label.org" />'; // 소속
				alert('<spring:message code="errors.required" arguments="' + msg + '" />'); // [{0}]은 필수 입력값입니다.
				$("#orgNm").focus();
				return;
			}
			
			/* if(!$.trim($("#orgSnm").val())) {
				var msg = '<spring:message code="common.label.org" /> Short Name'; // 소속
				alert('<spring:message code="errors.required" arguments="' + msg + '" />'); // [{0}]은 필수 입력값입니다.
				$("#orgSnm").focus();
				return;
			} */
			
			/* if(!$.trim($("#orgBizNo").val())) {
				var msg = '<spring:message code="common.label.biz.no" />'; // 사업자등록번호
				alert('<spring:message code="errors.required" arguments="' + msg + '" />'); // [{0}]은 필수 입력값입니다.
				$("#orgBizNo").focus();
				return;
			} */
			
			if(!'<c:out value="${orgInfoVO.orgId}" />') {
				if(!$.trim($("#userId").val())) {
					var msg = '<spring:message code="common.id" />'; // 아이디
					alert('<spring:message code="errors.required" arguments="' + msg + '" />'); // [{0}]은 필수 입력값입니다.
					$("#userId").focus();
					return;
				}
				
				if(!$("#userPass").val()) {
					var msg = '<spring:message code="user.title.userinfo.password" />'; // 비밀번호
					alert('<spring:message code="errors.required" arguments="' + msg + '" />'); // [{0}]은 필수 입력값입니다.
					$("#userPass").focus();
					return;
				}
				
				if(!$("#userPassConfirm").val()) {
					var msg = '<spring:message code="user.title.userjoin.password.confirm" />'; // 비밀번호 확인
					alert('<spring:message code="errors.required" arguments="' + msg + '" />'); // [{0}]은 필수 입력값입니다.
					$("#userPassConfirm").focus();
					return;
				}
				
				if(!$.trim($("#userNm").val())) {
					var msg = '<spring:message code="user.title.userinfo.manage.usernm" />'; // 이름
					alert('<spring:message code="errors.required" arguments="' + msg + '" />'); // [{0}]은 필수 입력값입니다.
					$("#userNm").focus();
					return;
				}
				
				if(!$.trim($("#email").val())) {
					var msg = '<spring:message code="user.title.userinfo.email" />'; // 이메일
					alert('<spring:message code="errors.required" arguments="' + msg + '" />'); // [{0}]은 필수 입력값입니다.
					$("#email").focus();
					return;
				}
				
				if(!$.trim($("#ofceTelno").val())) {
					var msg = '<spring:message code="common.label.contact.info" />'; // 연락처
					alert('<spring:message code="errors.required" arguments="' + msg + '" />'); // [{0}]은 필수 입력값입니다.
					$("#ofceTelno").focus();
					return;
				}
				
				if(!$.trim($("#mobileNo").val())) {
					var msg = '<spring:message code="user.title.userinfo.mobileno" />'; // 휴대폰번호
					alert('<spring:message code="errors.required" arguments="' + msg + '" />'); // [{0}]은 필수 입력값입니다.
					$("#mobileNo").focus();
					return;
				}
				
				if(!idDuplication) {
					alert("<spring:message code='user.message.userjoin.validate.id.dup' />"); // 아이디 중복확인을 해주세요.
					return;
				}
				
				if(!pwdValidation) {
					alert("<spring:message code='user.message.userjoin.validate.password.cond' />"); // 비밀번호가 조건에 맞지 않습니다.
					return;
				}
				
				if(!pwdConfirm) {
					alert("<spring:message code='user.message.userjoin.validate.password.reconfirm' />"); // 비밀번호 확인을 다시 해주세요.
					return;
				}
			}
			
			$("input[name='uploadFiles']").val("");
			$("input[name='copyFiles']").val("");
			$("input[name='uploadPath']").val("");
			save();
		}
		
		// 저장
		function save() {
			var url = '';
			
			if('<c:out value="${orgInfoVO.orgId}" />') {
				url = '/org/orgMgr/updateOrgInfo.do';
			} else {
				url = '/org/orgMgr/insertOrgInfo.do';
			}
			
			var param = $("#orgWriteForm").serialize();
			
			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					alert('<spring:message code="common.result.success" />'); // 성공적으로 작업을 완료하였습니다.
					moveList();
				} else {
					alert(data.message);
				}
			}, function() {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		// 목록 이동
		function moveList() {
			var menu = '<c:out value="${menu}" />'
			
			if(menu == "orgInfo") {
				var form = $("<form></form>");
				form.attr("method", "POST");
				form.attr("name", "moveForm");
				form.attr("action", "/org/orgMgr/Form/orgInfo.do");
				form.appendTo("body");
				form.submit();
			} else {
				var form = $("<form></form>");
				form.attr("method", "POST");
				form.attr("name", "moveForm");
				form.attr("action", "/org/orgMgr/Form/orgManageList.do");
				form.appendTo("body");
				form.submit();
			}
		}
		
		// 중복확인
		function checkDupUserId() {
			if(!$.trim($("#userId").val())) {
				var msg = "아이디";
				alert('<spring:message code="errors.required" arguments="' + msg + '" />'); // [{0}]은 필수 입력값입니다.
				$("#userId").focus();
				return;
			}
			
			var url = "/user/userMgr/joinIdCheck.do";
			var param = {
				userId : $("#userId").val()
			};
			
			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					if(data.message == 'Y') {
						alert("<spring:message code='user.message.userjoin.alert.avail.id' />");
						idDuplication = true;
					} else {
						alert("<spring:message code='user.message.userjoin.validate.id.used' />");
						idDuplication = false;
					}
				} else {
					alert(data.message);
					idDuplication = false;
				}
			}, function(){
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
				idDuplication = false;
			}, true);
		}
		
		// 비밀번호 패턴 확인
		function checkPwdValidation(obj) {
			var text = "";
			var num = obj.search(/[0-9]/g) > -1 ? 1 : 0;
			var eng = obj.search(/[a-z]/ig) > -1 ? 1 : 0;
			var spe = obj.search(/[`~!@@#$%^&*|₩₩₩'₩";:₩/?]/gi) > -1 ? 1 : 0;
			
			if(obj.length < 8 || obj.length > 16){
				text += "<spring:message code='user.message.userjoin.validate.password.length' />";/* * 8자 이상 16자 이하로 입력해주세요.<br/> */
				pwdValidation = false;
			}
			
			if(num + eng + spe < 2){
				text += "<spring:message code='user.message.userjoin.validate.password.comb' />";/* * 영문(대소문자구분)/숫자/특수문자 중 2가지 이상 조합해주세요.<br/> */
				pwdValidation = false;
			}
			
			if(obj == $("#userId").val()){
				text += "<spring:message code='user.message.userjoin.validate.same.userinfo' />";/* * 아이디와 비밀번호는 동일할 수 없습니다.<br/> */
				pwdValidation = false;
			}
			
			if((obj.length >= 8 && obj.length <= 16) && (num + eng + spe >= 2) && obj != $("#userId").val()) {
				pwdValidation = true;
			}
			
			if(text != "") {
				$("#pwText").html(text);
				$("#pwTextDiv").css("display", "block");
			} else {
				$("#pwText").html(text);
				$("#pwTextDiv").css("display", "none");
			}
		}
		
		// 비밀번호 일치 확인
		function checkPwdConfirm(obj) {
			if(obj != "" && obj != $("#userPass").val()) {
				$("#pwConfirmTextDiv").css("display", "block");
				pwdConfirm = false;
			} else {
				$("#pwConfirmTextDiv").css("display", "none");
				pwdConfirm = true;
			}
		}
	</script>
</head>
<body>
    <div id="wrap" class="pusher">
    	<!-- header -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
        <!-- //header -->
		<!-- lnb -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
        <!-- //lnb -->
        
        <div id="container">
            <!-- 본문 content 부분 -->
            <div class="content ">
            	<div id="info-item-box">
                    <h2 class="page-title flex-item">
                    	<spring:message code="common.label.org.mgr" /><!-- 소속(테넌시) 관리 -->
                    	<div class="ui breadcrumb small">
					        <small class="section">
					        	<c:choose>
					        		<c:when test="${empty orgInfoVO.orgId}">
					        			<spring:message code='common.button.create' /><!-- 등록 -->
					        		</c:when>
					        		<c:otherwise>
					        			<spring:message code='common.button.modify' /><!-- 수정 -->
					        		</c:otherwise>
					        	</c:choose>
				        	</small>
					    </div>
                   	</h2>
                    <div class="button-area">
						<a href="javascript:moveList()" class="ui basic button"><spring:message code='common.button.cancel' /><!-- 취소 --></a>
                    </div>
                </div>
            	<div class="ui divider mt0"></div>
	            <div class="ui form">
	            	<form id="orgWriteForm" name="orgWriteForm">
	            		<input type="hidden" name="uploadPath" />
 						<input type="hidden" name="uploadFiles" />
 						<input type="hidden" name="copyFiles" />
               			<div class="ui bottom attached segment">
	            		   	<ul class="tbl">
			                    <li>
			                        <dl>
			                            <dt><label for="orgId" class="req"><spring:message code="common.label.org.cd" /><!-- 소속코드 --></label></dt>
			                            <dd>
		                                	<c:choose>
		                                		<c:when test="${empty orgInfoVO.orgId}">
		                                			<input type="text" id="orgId" name="orgId" placeholder="<spring:message code="common.label.org.cd" />" value="" maxlength="10"/>
		                                		</c:when>
		                                		<c:otherwise>
		                                			<input type="text" id="orgId" name="orgId" placeholder="<spring:message code="common.label.org.cd" />" value="<c:out value="${orgInfoVO.orgId}" />" readonly="readonly" />
		                                		</c:otherwise>
		                                    </c:choose>
			                            </dd>
			                        </dl>
			                    </li>
			                    <li>
			                        <dl>
			                            <dt><label for="orgNm" class="req"><spring:message code="common.label.org" /><!-- 소속 --></label></dt>
			                            <dd>
			                            	<input type="text" id="orgNm" name="orgNm" placeholder="<spring:message code="common.label.org" />" value="<c:out value="${orgInfoVO.orgNm}" />" />
			                            </dd>
			                        </dl>
			                    </li>
			                    <li>
			                        <dl>
			                            <dt><label for="domainNm" class="req">접속경로</label></dt>
			                            <dd style="line-height:38px">
		                                	<span>https://lms.knou.ac.kr/</span><input type="text" id="domainNm" name="domainNm" placeholder="접속경로" value="<c:out value="${orgInfoVO.domainNm}" />"  style="display:inline;width:100px !important;"/>
			                            </dd>
			                        </dl>
			                    </li>
			                    <li>
			                        <dl>
			                            <dt><label for="domainNm" class="req">기본언어</label></dt>
			                            <dd>
		                                	<select name="dfltLangCd" style="width:150px">
		                                		<option value="ko" <c:if test="${orgInfoVO.dfltLangCd eq 'ko'}">selected</c:if>>한국어(ko)</option>
		                                		<option value="en" <c:if test="${orgInfoVO.dfltLangCd eq 'en'}">selected</c:if>>영어(en)</option>
		                                	</select>
			                            </dd>
			                        </dl>
			                    </li>
			                    
			                    <%-- 
			                    <li>
			                        <dl>
			                            <dt><label for="orgSnm" class="req"><spring:message code="common.label.org" /><!-- 소속 --> Short Name</label></dt>
			                            <dd>
			                            	<div class="ui action fluid input">
			                                	<input type="text" id="orgSnm" name="orgSnm" placeholder="<spring:message code="common.label.org" /> Short Name" value="<c:out value="${orgInfoVO.orgSnm}" />" />
			                                </div>
			                            </dd>
			                        </dl>
			                    </li>
			                    <li>
			                        <dl>
			                            <dt><label for="orgPost"><spring:message code="common.label.post.no" /><!-- 우편번호 --></label></dt>
			                            <dd>
			                            	<div class="ui action fluid input">
			                                	<input type="text" id="orgPost" name="orgPost" placeholder="<spring:message code="common.label.post.no" />" value="<c:out value="${orgInfoVO.orgPost}" />" maxlength="5" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" />
			                                </div>
			                            </dd>
			                        </dl>
			                    </li>
			                    <li>
			                        <dl>
			                            <dt><label for="orgAddr"><spring:message code="common.label.address" /><!-- 주소 --></label></dt>
			                            <dd>
			                            	<div class="ui action fluid input">
			                                	<input type="text" id="orgAddr" name="orgAddr" placeholder="<spring:message code="common.label.address" />" value="<c:out value="${orgInfoVO.orgAddr}" />" />
			                                </div>
			                            </dd>
			                        </dl>
			                    </li>
			                    <li>
			                        <dl>
			                            <dt><label for="rprstPhoneNo"><spring:message code="common.label.org.support.team" /><!-- 고객지원팀 --></label></dt>
			                            <dd>
			                            	<div class="ui action fluid input">
			                                	<input type="text" id="rprstPhoneNo" name="rprstPhoneNo" value="<c:out value="${orgInfoVO.rprstPhoneNo}" />" onkeyup="" maxlength="13" /> 
			                                </div>
			                            </dd>
			                        </dl>
			                    </li>
			                    <li>
			                        <dl>
			                            <dt><label for="rprstFaxNo"><spring:message code="common.fax" /><!-- 팩스 --></label></dt>
			                            <dd>
			                            	<div class="ui action fluid input">
			                                	<input type="text" id="rprstFaxNo" name="rprstFaxNo" value="<c:out value="${orgInfoVO.rprstFaxNo}" />" onkeyup="" maxlength="13" />
			                                </div>
			                            </dd>
			                        </dl>
			                    </li>
			                    <li>
			                        <dl>
			                            <dt><label for="orgBizNo" class="req"><spring:message code="common.label.biz.no" /><!-- 사업자등록번호 --></label></dt>
			                            <dd>
			                            	<div class="ui action fluid input">
			                                	<input type="text" id="orgBizNo" name="orgBizNo" value="<c:out value="${orgInfoVO.orgBizNo}" />" onkeyup="" maxlength="12" /> 
			                                </div>
			                            </dd>
			                        </dl>
			                    </li> --%>
			                </ul>
           	 				<c:if test="${not empty orgInfoVO.orgId}">
							<!-- 하단 버튼 -->
					        <div class="button-area tc mt10">
					        	<a href="javascript:void(0);" class="ui blue button" onclick="saveConfirm();"><spring:message code='common.button.save' /><!-- 저장 --></a>
					        </div>
				        	</c:if>
           				</div>
                    
                    	<c:if test="${empty orgInfoVO.orgId}">
	                    <div class="ui attached message">
	                    	<div class="header"><spring:message code="common.label.orgadm" /><!-- 운영자 --></div>
	                    </div>
	                    <div class="ui bottom attached segment">
			                <ul class="tbl-simple st2">
				            	<li>
				                	<dl>
				                    	<dt><label for="userId" class="req"><spring:message code="common.id" /><!-- 아이디 --></label></dt>
			                        	<dd>
			                            	<div class="ui action fluid input">
			                                	<input type="text" id="userId" name="userId" placeholder="<spring:message code="common.id" />" value="" maxlength="30" />
			                                    <button type="button" class="ui black button" data-toggle="modal" data-target="#modal-team-target" onclick="checkDupUserId()"><spring:message code="common.label.duplicate.confirm" /><!-- 중복확인 --></button>
			                               	</div>
			                            </dd>
				                    </dl>
				            	</li>
		                        <li>
		                            <dl>
		                                <dt><label for="userPass" class="req"><spring:message code="user.title.userinfo.password" /><!-- 비밀번호 --></label>
		                                <dd>
		                                    <div class="ui action fluid input">
		                                        <input type="password" id="userPass" name="userPass" placeholder="<spring:message code='user.message.search.input.userpass' />" onkeyup="checkPwdValidation(this.value)" /><!-- 비밀번호 입력 -->
		                                    </div>
		                                </dd>
		                            </dl>
		                            <div class="ui error message" id="pwTextDiv" style="display:none;">
			        					<div class="fields">
				        					<div class="field">
					       						<i class="info triangle icon"></i>
				        					</div>
				        					<div class="field">
					       						<span id="pwText"></span>
				        					</div>
			        					</div>
			        				</div>
		                        </li>
		                        <li>
		                            <dl>
		                                <dt><label for="userPassConfirm" class="req"><spring:message code="user.title.userjoin.password.confirm" /><!-- 비밀번호 확인 --></label>
		                                <dd>
		                                    <div class="ui action fluid input">
		                                        <input type="password" id="userPassConfirm" name="userPassConfirm" placeholder="<spring:message code='user.message.search.input.userpass.confirm' />" id="userPassChk" onkeyup="checkPwdConfirm(this.value)" /><!-- 비밀번호 재입력 -->
		                                    </div>
		                                </dd>
		                            </dl>
		                        </li>
		                        <li>
		                            <dl>
		                                <dt><label for="userNm" class="req"><spring:message code="user.title.userinfo.manage.usernm" /><!-- 이름 --></label></dt>
		                                <dd>
		                                	<div class="ui action fluid input">
		                                    	<input type="text" id="userNm" name="userNm" placeholder="<spring:message code="user.title.userinfo.manage.usernm" />" value="" />
		                                    </div>
		                                </dd>
		                            </dl>
		                        </li>
		                        <li>
		                            <dl>
		                                <dt><label for="email" class="req"><spring:message code="user.title.userinfo.email" /><!-- 이메일 --></label></dt>
		                                <dd>
		                                	<div class="ui action fluid input">
		                                    	<input type="text" id="email" name="email" placeholder="sample@hycu.ac.kr" value="" />
		                                    </div>
		                                </dd>
		                            </dl>
		                        </li>
		                        <li>
		                            <dl>
		                                <dt><label for="ofceTelno" class="req"><spring:message code="common.label.contact.info" /><!-- 연락처 --></label></dt>
		                                <dd>
		                                	<div class="ui action fluid input">
		                                    	<input type="text" id="ofceTelno" name="ofceTelno" placeholder="<spring:message code="common.label.contact.info" />" value="" onkeyup="" maxlength="13" />
		                                    </div>
		                                </dd>
		                            </dl>
		                        </li>
		                        <li>
		                            <dl>
		                                <dt><label for="mobileNo" class="req"><spring:message code="user.title.userinfo.mobileno" /><!-- 휴대폰번호 --></label></dt>
		                                <dd>
		                                	<div class="ui action fluid input">
		                                    	<input type="text" id="mobileNo" name="mobileNo" placeholder="<spring:message code="user.title.userinfo.mobileno" />" value="" onkeyup="" maxlength="13" /> 
		                                    </div>
		                                </dd>
		                            </dl>
		                        </li>
		                    </ul>
							<!-- 하단 버튼 -->
					        <div class="button-area tc mt10"> 
					        	<a href="javascript:void(0);" class="ui blue button" onclick="saveConfirm();"><spring:message code='common.button.save' /><!-- 저장 --></a>
					        </div>
						</div>
						</c:if>
					</form>
                </div>
                <!-- //ui form -->
            </div>
            <!-- //본문 content 부분 -->
        </div>
    	<!-- footer 영역 부분 -->
    	<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
</body>
</html>