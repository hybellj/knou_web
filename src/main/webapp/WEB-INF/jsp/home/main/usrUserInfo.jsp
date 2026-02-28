<%@ taglib prefix="c"      		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt"    		uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"     		uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="form"   		uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" 		uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="validator" 	uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ taglib prefix="ui"     		uri="http://egovframework.gov/ctl/ui" %>
<%@ page import="knou.framework.common.CommConst" %>
<jsp:include page="/WEB-INF/jsp/common/common.jsp" />
<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta name="title" content="">
	<meta http-equiv="pragma" content="no-cache" />
	<meta http-equiv="Cache-Control" content="No-Cache" />
	<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
	<title>sampleMain</title>

	<!-- <script src="https://code.jquery.com/jquery-3.2.1.min.js"></script> -->
	<script type="text/javascript">
		editProfile1 = function(){
			ajaxCall("/home/main/updateUsrUserInfo.do", $("#innerform").serialize(), function(data){
			}, function(){});
		}
		</script>
		</head>
		<body>
			<div class="ui-wrap">
				<header class="header">
					<jsp:include page="/WEB-INF/jsp/common/frontGnb.jsp" />
				</header>

				<div class="container">
					<div class="lnb">
						<jsp:include page="/WEB-INF/jsp/common/frontLnb.jsp" />
					</div>

					<div class="contents">
						<div id="context">
							<div id="info-item-box">
	                            <h2 class="page-title"><spring:message code="common.label.profile.manage" /></h2><!-- 프로필 관리 -->
	                            <div class="button-area">
	                                <a href="javascript:editProfile1();" class="btn btn-primary"><spring:message code="exam.button.save" /></a><!-- 저장 -->
	                                <a href="#0" class="btn btn-negative"><spring:message code="exam.button.cancel" /></a><!-- 취소 -->
	                            </div>
	                        </div>
	                        <div class="ui form">
	                        	<form id="innerform">
	                            <div class="ui grid stretched row">
	                                <div class="sixteen wide tablet eight wide computer column">
	                                    <div class="ui attached message">
	                                        <div class="header"><spring:message code="user.title.userinfo.user.myinfo.edit" /></div><!-- 개인 정보 수정 -->
	                                    </div>
	                                    <div class="ui bottom attached segment">
	                                        <ul class="tbl-simple">
	                                            <li>
	                                                <dl>
	                                                    <dt><label><spring:message code="asmnt.label.user_id" /></label></dt><!-- 아이디 -->
	                                                    <dd>${usruserinfoVO.userId}</dd>
	                                                </dl>
	                                            </li>
	                                            <li>
	                                                <dl>
	                                                    <dt><label for="pwLabel"><spring:message code="common.label.password" /></label></dt><!-- 비밀번호 -->
	                                                    <dd>
	                                                        <div class="inline field">
	                                                            <label for="pwLabel" class="w150"><spring:message code="user.title.login.password.now" /></label><!-- 현재 비밀번호 -->
	                                                            <input type="password" id="pwLabel"  name="pwLabel">
	                                                        </div>
	                                                        <div class="inline field">
	                                                            <label for="pwNewLabel" class="w150"><spring:message code="user.title.login.password.new" /></label><!-- 새 비밀번호 -->
	                                                            <input type="password" id="pwNewLabel" name ="pwNewLabel"  onkeyup="checkPwdValidation(this.value);">
	                                                        </div>
	                                                        <div class="inline field">
	                                                            <label for="pwNewLabel2" class="w150"><spring:message code="user.title.login.password.new.confirm" /></label><!-- 새 비밀번호 확인 -->
	                                                            <input type="password" id="pwNewLabel2" name= "pwNewLabel2" onkeyup="checkPwdConfirm(this.value);">
	                                                        </div>
	                                                        <ul class="list-sm" style=" color: red; font-size: small;" id="pwdText"></ul>
						                                    <ul class="list-sm" style=" color: red; font-size: small;" id="pwdConfirmText"></ul>
						                                    <ul id="pwdNewText" class="list-sm" style="background: url(/home/001/img/icon_dot.gif) 0 1em no-repeat; padding: 6px 4px 6px 8px; display:none;">
						                                        <li><spring:message code="user.title.userjoin.password.validation" /></li><!-- 영문(대소문자구분)/숫자/특수문자 중 2가지 이상 조합, 8자~16자 -->
						                                    </ul>
	                                                    </dd>
	                                                    
	                                                </dl>
	                                            </li>
	                                            <li>
	                                                <dl>
	                                                    <dt><label for="emailLabel" class="req"><spring:message code="common.email" /></label></dt><!-- 이메일 -->
	                                                    <dd>
	                                                        <input type="text" id="emailStr" name="emailStr" value="${usruserinfoVO.email }">
	                                                        <!-- 
	                                                        <div class="ui checkbox mh10">
	                                                            <input type="checkbox" name="">
	                                                            <label>관련 정보 이메일을 수신하시겠습니까?</label>
	                                                        </div> 
	                                                        -->
	                                                    </dd>
	                                                </dl>
	                                            </li>
	                                            <li>
	                                                <dl>
														<dt><label for="mobileLabel" class="req"><spring:message code="std.label.mobile" /></label></dt><!-- 휴대전화 -->
	                                                    <dd>
	                                                    <input type="text" id="mobileNo" name="mobileNo" value="${usruserinfoVO.mobileNo }">
	                                                    <%-- 
	                                                    <div class="equal width fields mb0">
	                                                            <div class="field">
	                                                            	<c:set var="mobile1" value=""/>
	                                                                <select name="mobile1" id="mobile1" class="ui dropdown">
	                                                                    <option value="010" <c:if test="${mobile1 eq '010' }">selected</c:if>>010</option>
	                                                                    <option value="011" <c:if test="${mobile1 eq '011' }">selected</c:if>>011</option>
	                                                                    <option value="016" <c:if test="${mobile1 eq '016' }">selected</c:if>>016</option>
	                                                                    <option value="017" <c:if test="${mobile1 eq '017' }">selected</c:if>>017</option>
	                                                                    <option value="018" <c:if test="${mobile1 eq '018' }">selected</c:if>>018</option>
	                                                                    <option value="019" <c:if test="${mobile1 eq '019' }">selected</c:if>>019</option>
	                                                                </select>
	                                                            </div>
	                                                            <span class="time-sort">-</span>
	                                                            <div class="field">
	                                                                <input type="text" maxlength="4" value="" id="mobile2" name="mobile2" onkeyup="checkMobileNumber(this.value);">
	                                                            </div>
	                                                            <span class="time-sort">-</span>
	                                                            <div class="field">
	                                                                <input type="text" maxlength="4" value="" id="mobile3" name="mobile3" onkeyup="checkMobileNumber(this.value);">
	                                                            </div>
	                                                        </div>
	                                                        <!-- 
	                                                        <div class="ui checkbox mh10">
	                                                            <input type="checkbox" name="" checked>
	                                                            <label>SMS 수신을 동의하시겠습니까?</label>
	                                                        </div> 
	                                                        --> 
	                                                    --%>
	                                                    </dd>
	                                                </dl>
	                                            </li>
	                                        </ul>
	                                    </div>
	                                </div>
	                                <div class="sixteen wide tablet eight wide computer column">
	                                    <div class="ui attached message">
	                                        <div class="header"><spring:message code="user.title.userinfo.profile.image.edit" /></div><!-- 프로필 이미지 수정 -->
	                                    </div>
	                                    <div class="ui bottom attached segment">
	                                        <ul class="tbl-simple">
	                                            <li>
	                                                <dl class="row">
	                                                    <dt><label for="lectureFileLabel"><spring:message code="user.title.userinfo.profile.image.upload" /></label></dt><!-- 이미지 업로드 -->
	                                                    <dd>
	                                                    	<%-- 
	                                                    	<c:choose>
	                                                    		<c:when test="${not empty userVO.photoFile.fileSn }">
	                                                    			<img id="profileImg" src="/home/app/file/view/${userVO.photoFile.fileSn }" style="max-height: 300px; margin: 0 25%;">
	                                                    		</c:when>
	                                                    		<c:otherwise>
	                                                    			<img id="profileImg" src="" style="max-height: 300px; margin: 0 25%;">
	                                                    		</c:otherwise>
	                                                    	</c:choose> 
	                                                    	--%>
	                                                        <div class="upload">
	                                                            <div class="drop" id="uploadDiv">
	                                                                <a href="javascript:uploderclick('atchuploader');" id="lectureFileLabel"><spring:message code="button.select.file" /><!-- 파일선택 --></a><spring:message code="common.drag.file.here" /><!-- 또는 파일을 여기에 드래그 해 주세요. -->
	                                                                <input type="file" name="atchuploader" id="atchuploader" title="<spring:message code="exam.label.file" />" multiple="" style="display:none">
	                                                                <div id="atchprogress" class="progress">
																		<div class="progress-bar progress-bar-success"></div>
																	</div>
	                                                            </div>
	                                                            <ul id="atchfiles" class="multi_inbox"></ul>
	                                                            <!-- 
	                                                            <ul>
	                                                                <li>
	                                                                    <p>15120851_ml15120851.jpg<small>185.83 KB</small></p>
	                                                                    <span>삭제</span>
	                                                                </li>
	                                                            </ul>
	                                                            -->
	                                                        </div>
	                                                    </dd>
	                                                </dl>
	                                            </li>
	                                            <li>
	                                                <dl>
	                                                    <dt><label><spring:message code="button.preview" /></label></dt><!-- 미리보기 -->
	                                                    <dd>
	                                                        <div class="initial-img lg c-4" id="croppedDiv">석현</div>
	                                                    </dd>
	                                                </dl>
	                                            </li>
	                                        </ul>
	                                    </div>
	                                </div>
	                            </div>
	                            </form>
	                        </div>
	                    </div>
				</div>
			</div>
		<footer class="footer">
			<jsp:include page="/WEB-INF/jsp/common/frontFooter.jsp" />
		</footer>
	</div>
</body>
</html>