<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<script type="text/javascript">
	var pwdValidation = false;
	var pwdConfirm = false;
	var idDuplication = false;
	
	$(document).ready(function() {
		if(${not empty userVO.userId}) {
			//findUserAuthGrp();
			pwdValidation = true;
			pwdConfirm = true;
			idDuplication = true;
		}
	});
	
	// 사용자 구분 선택
	/*
	function findUserAuthGrp() {
		var authGrpCd = $("#authGrpCd").val();
		// 사용자 구분(학습자, 조교) 학년 셀렉트박스 출력
		if(authGrpCd.indexOf("USR") > -1) {
			$("#grade").css("display", "list-item");
		} else {
			$("#grade").css("display", "none");
		}
	}
	*/
	
	// 아이디 중복체크
	function checkIdDuplication() {
		if($("#userId").val() == ""){
			alert("<spring:message code='user.message.login.alert.input.userid' />");/* 아이디를 입력해주세요. */
			return;
		}else{
			var userId = $("#userId").val();
			var url  = "/user/userMgr/joinIdCheck.do";
			var data = {
				"userId" : userId
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					if(data.message == 'Y') {
						idDuplication = true;
						/* 사용 가능한 아이디입니다. */
						alert("<spring:message code='user.message.userjoin.alert.avail.id' />");
					} else {
						idDuplication = false;
						/* 이미 사용중인 아이디입니다. 다른 아이디를 입력해주세요. */
						alert("<spring:message code='user.message.userjoin.validate.id.used' />");
					}
	            } else {
	             	alert(data.message);
	            }
    		}, function(xhr, status, error) {
    			/* 에러가 발생했습니다! */
    			alert("<spring:message code='fail.common.msg' />");
    		});
		}
	}
	
	// 비밀번호 패턴 확인
	function checkPwdValidation(obj){
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
	
	// 사용자 등록, 수정
	function save() {
		if(!nullCheck()) {
			return false;
		}
		setValue();
		
		showLoading();
		var url = "";
		if(${empty userVO.userId }) {
			url = "/user/userMgr/addUser.do";
		} else {
			url = "/user/userMgr/editUser.do";
		}
	    
		$.ajax({
            url 	 : url,
            async	 : false,
            type 	 : "POST",
            dataType : "json",
            data 	 : $("#userForm").serialize(),
        }).done(function(data) {
        	hideLoading();
        	if (data.result > 0) {
        		if(${empty userVO.userId }) {
	        		alert("<spring:message code='user.message.userinfo.add.success' />");/* 사용자 정보를 등록하였습니다. */
        		} else {
        			alert("<spring:message code='user.message.userinfo.edit.success' />");/* 사용자 정보를 수정하였습니다. */
        		}
        		location.href = "/user/userMgr/Form/manageUser.do";
            } else {
             	alert(data.message);
            }
        }).fail(function() {
        	hideLoading();
        	if(${empty userVO.userId }) {
	        	alert("<spring:message code='user.messgae.userinfo.add.failed' />");/* 사용자 정보를 등록하지 못하였습니다. */
        	} else {
        		alert("<spring:message code='user.messgae.userinfo.edit.failed' />");/* 사용자 정보를 수정하지 못하였습니다. */
        	}
        });
	}
	
	// 빈 값 체크
	function nullCheck() {
		var userId = "${userVO.userId }";
		var isKnou = "${isKnou}" == "true" ? true : false;
		var reg_email = /^([0-9a-zA-Z_\.-]+)@([0-9a-zA-Z_-]+)(\.[0-9a-zA-Z_-]+){1,2}$/;
		var authGrpCd = $("#authGrpCd").val() || "";
		
		if(isKnou) {
			if(!idDuplication) {
				alert("<spring:message code='user.message.userjoin.validate.id.dup' />");/* 아이디 중복확인을 해주세요. */
				return false;
			} else if(!pwdValidation) {
				alert("<spring:message code='user.message.userjoin.validate.password.cond' />");/* 비밀번호가 조건에 맞지 않습니다. */
				return false;
			} else if(!pwdConfirm) {
				alert("<spring:message code='user.message.userjoin.validate.password.reconfirm' />");/* 비밀번호 확인을 다시 해주세요. */
				return false;
			} else if($("#authGrpCd").val() == null) {
				alert("<spring:message code='user.message.userjoin.vaildate.user.div' />");/* 사용자 구분을 선택해주세요. */
				return false;
			} else if(authGrpCd.indexOf("USR") > -1 && (authGrpCd.indexOf("PFS") > -1 || authGrpCd.indexOf("TUT") > -1)) {
				alert("<spring:message code='user.message.userjoin.vaildate.user.div.not.select' />");/* 학생과 (교수, 조교)는 같이 사용할 수 없습니다. */
				return false;
			} else if($("#deptCd").val() == "") {
				alert("<spring:message code='user.message.userjoin.vaildate.dept.select' />");/* 학과를 선택해주세요. */
				return false;
			}/*  else if((authGrpCd.indexOf("USR") > -1) && $("#userGrade").val() == "") {
				alert("<spring:message code='user.message.userjoin.vaildate.user.grade.select' />");// 학년을 선택해주세요.
				return false;
			}  */else if($("#userNm").val() == "") {
				alert("<spring:message code='user.message.userjoin.vaildate.user.nm.input' />");/* 이름을 입력해주세요. */
				return false;
			} else if($("#mobile2").val() == "" || $("#mobile3").val() == "") {
				alert("<spring:message code='user.message.userjoin.vaildate.mobile.no.input' />");/* 휴대전화 번호를 입력해주세요. */
				return false;
			} else if($("#email").val() == "") {
				alert("<spring:message code='user.message.userjoin.vaildate.email.input' />");/* 이메일을 입력해주세요. */
				return false;
			} else if(!reg_email.test($("#email").val())) {
				alert("<spring:message code='user.message.userjoin.validate.email.format' />");/* 이메일 형식이 잘못되었습니다. */
				return false;
			} else if($("#disabilityCd").val() != "" && $("#disabilityLv").val() == "") {
				alert("<spring:message code='user.message.userjoin.vaildate.disability.lv.select' />");/* 장애등급을 선택해주세요. */
				return false;
			} else if($("#disabilityCd").val() == "" && $("#disabilityLv").val() != "") {
				alert("<spring:message code='user.message.userjoin.vaildate.disability.cd.select' />");/* 장애유형을 선택해주세요. */
				return false;
			}
		} else {
			if(!idDuplication) {
				alert("<spring:message code='user.message.login.alert.input.stu.no.dup' />"); // 학번 중복확인을 해주세요.
				return false;
			} else if(!userId && (!$("#userPass").val() || $.trim($("#userPass").val()).length != 6)) {
				alert("<spring:message code='user.message.login.alert.input.front.resid.num' />"); // 주민등록번호 앞자리를 입력하세요.
				return false;
			} else if($("#authGrpCd").val() == null) {
				alert("<spring:message code='user.message.userjoin.vaildate.user.div' />");/* 사용자 구분을 선택해주세요. */
				return false;
			} else if($("#userNm").val() == "") {
				alert("<spring:message code='user.message.userjoin.vaildate.user.nm.input' />");/* 이름을 입력해주세요. */
				return false;
			} else if($("#email").val() && !reg_email.test($("#email").val())) {
				alert("<spring:message code='user.message.userjoin.validate.email.format' />");/* 이메일 형식이 잘못되었습니다. */
				return false;
			}
		}
		return true;
	}
	
	// 값 채우기
	function setValue() {
		// 장애 여부
		if($("#disabilityCd") != "" && $("#disabilityLv").val() != "") {
			$("#disablilityYn").val("Y");
		} else {
			$("#disablilityYn").val("N");
		}
		if($("#mobile2").val() && $("#mobile3").val()) {
			// 핸드폰 번호
			$("#mobileNo").val($("#mobile1").val()+"-"+$("#mobile2").val()+"-"+$("#mobile3").val());
		}
		/* 
		$($("#authGrpCd").val()).each(function(index, item){
			// 교수 구분
			if(item == "PFS" || item == "TUT") {
				$("#profAuthGrpCd").val($("#profAuthGrpCd").val()+"/"+item);
			// 학습자 구분
			} else if(item == "USR") {
				$("#wwwAuthGrpCd").val($("#wwwAuthGrpCd").val()+"/"+item);
			// 관리자 구분
			} else {
				$("#mngAuthGrpCd").val($("#mngAuthGrpCd").val()+"/"+item);
			}
		});
		 */
		$("#profAuthGrpCd").val("");
		$("#wwwAuthGrpCd").val("");
		$("#mngAuthGrpCd").val("");
		var authGrpCd = $("#authGrpCd").val();
		// 교수 구분
		if(authGrpCd == "PFS" || authGrpCd == "TUT") {
			$("#profAuthGrpCd").val("/" + authGrpCd);
		// 학습자 구분
		} else if(authGrpCd == "USR") {
			$("#wwwAuthGrpCd").val("/" + authGrpCd);
		// 관리자 구분
		} else {
			$("#mngAuthGrpCd").val("/" + authGrpCd);
		}
		 
		// 기존 구분 제거
		if(${not empty userVO.userId}) {
			$("#authGrpCd").val("");
		}
		// 학과명
		$("#deptNm").val($("#deptCd :selected").text());
	}
	
    // 한사대계정 연결 팝업
    function viewKnouUserPop() {
    	$("#knouUserForm").attr("target", "knouUserPopIfm");
        $("#knouUserForm").attr("action", "/user/userMgr/knouUserSelectPop.do");
        $("#knouUserForm").submit();
        $('#knouUserPop').modal('show');
    }
    
    function clearHycuUser() {
    	$("#knouUserId").val("");
    	$("#knouUserInfo").val("");
    	$("#knouUserDelBtn").hide();
    }
</script>

<body>
	<div class="ui form">
		<div class="layout2">
	        <div id="info-item-box">
	        	<spring:message code="user.button.reg"  var="reg" /><!-- 등록 -->
			   	<spring:message code="user.button.save" var="save" /><!-- 저장 -->
			   	<spring:message code="user.button.mod"  var="modify" /><!-- 수정 -->
				<h2 class="page-title flex-item flex-wrap gap4 columngap16">
					<spring:message code="user.title.userinfo.manage" /><!-- 사용자 관리 -->
					<div class="ui breadcrumb small">
					    <small class="section">${empty userVO.userId ? reg : modify }</small>
					</div>
             	</h2>
				<div class="button-area">
       				<a href="javascript:save()" class="ui green button">${empty userVO.userId ? save : modify }</a>
				</div>
      		</div>
      		
			<div class="row">
				<div class="col">
					<form class="ui form" autocomplete="off" onsubmit="return false;" id="userForm" method="POST">
			       		<input type="hidden" name="wwwAuthGrpCd"  id="wwwAuthGrpCd"  value="">
			       		<input type="hidden" name="profAuthGrpCd" id="profAuthGrpCd" value="">
			       		<input type="hidden" name="mngAuthGrpCd"  id="mngAuthGrpCd"  value="">
			       		<input type="hidden" name="disablilityYn" id="disablilityYn" value="">
			       		<input type="hidden" name="mobileNo" 	  id="mobileNo" 	 value="">
			       		<input type="hidden" name="deptNm" 		  id="deptNm" 		 value="">
			       		<input type="hidden" name="userId" 		  id="userId" 		 value="${userVO.userId }">
			       		
						<div class="ui segment">
							<ul class="tbl">
								<li>
									<dl>
										<dt>
											<label class="req" for="orgInfo"><i class="mr10 f150">&middot;</i><spring:message code="user.title.userinfo.affiliation" /></label><!-- 소속 -->
										</dt>
										<dd>
											<select class="ui dropdown selection" name="orgId" id="orgId">
												<c:forEach var="item" items="${orgInfoList }">
													<c:choose>
														<c:when test="${authGrpCd.contains('SUP')}">
															<option value="${item.orgId }">${item.orgNm }</option>
														</c:when>
														<c:otherwise>
															<c:if test="${orgId eq item.orgId}">
																<option value="${item.orgId }">${item.orgNm }</option>
															</c:if>
														</c:otherwise>
													</c:choose>
												</c:forEach>
											</select>
										</dd>
									</dl>
								</li>
								<li>
									<dl>
										<dt>
											<label class="req" for="userId"><i class="mr10 f150">&middot;</i>
												<c:choose>
													<c:when test="${isKnou eq 'true'}">
														<spring:message code="user.title.userinfo.user.id" /><!-- 학번/아이디 -->
													</c:when>
													<c:otherwise>
														<spring:message code="user.title.userinfo.manage.userid" /><!-- 학번 -->
													</c:otherwise>
												</c:choose>
											</label>
										</dt>
										<dd>
											<div class="ui action input search-box wmax">
												<c:choose>
													<c:when test="${isKnou eq 'true'}">
														<input type="text" placeholder="<spring:message code='user.message.search.input.userinfo.id' />" name="userId" id="userId" value="${userVO.userId }" ${not empty userVO.userId ? 'disabled' : '' } style="max-width:300px"><!-- 학번/아이디 입력 -->
													</c:when>
													<c:otherwise>
														<input type="text" placeholder="<spring:message code='user.title.userinfo.manage.userid' />" name="userId" id="userId" value="${userVO.userId }" ${not empty userVO.userId ? 'disabled' : '' } style="max-width:300px"><!-- 학번 -->
													</c:otherwise>
												</c:choose>
												<button class="ui black button" ${not empty userVO.userId ? 'disabled' : '' } onclick="checkIdDuplication()"><spring:message code="user.title.userjoin.dub.confirm" /></button><!-- 중복확인 -->
											</div>
										</dd>
									</dl>
								</li>
								
								<c:if test="${empty userVO.userId and isKnou eq 'true'}">
									<li>
										<dl>
											<dt>
												<label class="req" for="userPass"><i class="mr10 f150">&middot;</i><spring:message code="user.title.userinfo.password" /></label><!-- 비밀번호 -->
											</dt>
											<dd>
												<input type="password" placeholder="<spring:message code='user.message.search.input.userpass' />" name="userPass" id="userPass" onkeyup="checkPwdValidation(this.value)" /><!-- 비밀번호 입력 -->
											</dd>
											<dt>
												<label class="req" for="userPassChk"><i class="mr10 f150">&middot;</i><spring:message code="user.title.userjoin.password.confirm" /></label><!-- 비밀번호 확인 -->
											</dt>
											<dd>
												<input type="password" placeholder="<spring:message code='user.message.search.input.userpass.confirm' />" id="userPassChk" onkeyup="checkPwdConfirm(this.value)" /><!-- 비밀번호 재입력 -->
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
										<div class="ui error message" id="pwConfirmTextDiv" style="display:none;">
											<i class="info triangle icon"></i>
											<span id="pwConfirmText"><spring:message code="user.message.userjoin.validate.password.confirm" /></span><!-- * 비밀번호와 비밀번호 확인이 일치하지 않습니다. -->
										</div>
										<div class="ui info message mb15">
											<i class="info circle icon"></i>
											<span><spring:message code="user.message.userjoin.vaildate.password.confirm.info" /></span><!-- * 영문(대소문자구분)/숫자/특수문자 중 2가지 이상조합, 8자~16자 -->
										</div>
									</li>
								</c:if>
								<c:if test="${empty userVO.userId and isKnou ne 'true'}">
									<li>
										<dl>
											<dt>
												<label class="req" for="userPass"><i class="mr10 f150">&middot;</i><spring:message code="user.title.userinfo.rrnend.front" /><!-- 주민등록번호 앞자리 --></label>
											</dt>
											<dd>
												<input type="text" id="userPass" name="userPass" class="w200" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="6" value="" placeholder="900101" />
											</dd>
										</dl>
									</li>
								</c:if>
								<li>
									<dl>
										<dt>
											<label class="req" for="authGrpCd"><i class="mr10 f150">&middot;</i><spring:message code="user.title.userinfo.user.div" /></label><!-- 사용자 구분 -->
										</dt>
										<dd>
											<select class="ui dropdown selection w200" id="authGrpCd" name="authGrpCd" onchange="<!-- findUserAuthGrp() -->">
						                              <option value=""><spring:message code="user.common.select" /></option><!-- 선택하세요 -->
						                              <c:forEach var="item" items="${userTypeList }">
						                              	<option value="${item.codeCd }" ${fn:contains(userVO.wwwAuthGrpCd, item.codeCd) ? 'selected' : '' }>${item.codeNm }</option>
						                              </c:forEach>
						                          </select>
										</dd>
									</dl>
								</li>
								<li>
									<dl>
										<dt>
											<label class="<c:if test="${isKnou eq 'true'}">req</c:if>" for="deptCd"><i class="mr10 f150">&middot;</i><spring:message code="user.title.userdept.dept" /></label><!-- 학과/부서 -->
										</dt>
										<dd>
											<select class="ui dropdown selection w200" name="deptCd" id="deptCd">
												<option value=""><spring:message code="user.common.select" /></option><!-- 선택하세요 -->
												<c:forEach var="item" items="${deptCdList }">
													<option value="${item.deptCd }" ${userVO.deptCd eq item.deptCd ? 'selected' : '' }>${item.deptNm }</option>
												</c:forEach>
											</select>
										</dd>
									</dl>
								</li>
								<%-- 
								<li id="grade" style="display:none;">
									<dl>
										<dt>
											<label class="req" for="deptCd"><i class="mr10 f150">&middot;</i><spring:message code="user.title.userinfo.grade" /></label><!-- 학년 -->
										</dt>
										<dd>
											<select class="ui dropdown selection" name="userGrade" id="userGrade">
												<option value=""><spring:message code="user.common.select" /></option><!-- 선택하세요 -->
												<c:forEach var="item" items="${userGradeList }">
													<option value="${item.codeCd }" ${userVO.userGrade eq item.codeCd ? 'selected' : '' }>${item.codeNm }</option>
												</c:forEach>
											</select>
										</dd>
									</dl>
								</li>
								 --%>
								<li>
									<dl>
										<dt>
											<label class="req" for="userNm"><i class="mr10 f150">&middot;</i><spring:message code="user.title.userinfo.manage.usernm" /></label><!-- 이름 -->
										</dt>
										<dd>
											<input type="text" placeholder="<spring:message code='user.message.search.input.user.nm' />" name="userNm" id="userNm" value="${userVO.userNm }"  class="w300"/><!-- 이름 입력 -->
										</dd>
									</dl>
								</li>
								<li>
									<dl>
										<dt>
											<label for="userNmEng"><i class="mr10 f150">&middot;</i><spring:message code="user.title.userinfo.manage.usernm.en" /></label><!-- 이름 (영문) -->
										</dt>
										<dd>
											<input type="text" placeholder="<spring:message code='user.message.search.input.user.nm' />" name="userNmEng" id="userNmEng" value="${userVO.userNmEng }"  class="w300"/><!-- 이름 입력 -->
										</dd>
									</dl>
								</li>
								<li>
									<dl>
										<dt>
											<label class="<c:if test="${isKnou eq 'true'}">req</c:if>" for="mobile1"><i class="mr10 f150">&middot;</i><spring:message code="user.title.userinfo.mobileno" /></label><!-- 휴대폰 번호 -->
										</dt>
										<dd>
											<div class="fields">
												<div class="">
													<select class="ui dropdown" id="mobile1">
														<c:forEach var="item" items="${phoneCodeList }">
															<option value="${item.codeCd }" ${fn:split(userVO.mobileNo,'-')[0] eq item.codeCd ? 'selected' : '' }>${item.codeNm }</option>
														</c:forEach>
													</select>
												</div>
												<div class="field tc f150 pt10">-</div>
												<div class="field">
													<input type="text" id="mobile2" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="4" value="${fn:split(userVO.mobileNo,'-')[1] }" />
												</div>
												<div class="field tc f150 pt10">-</div>
												<div class="field">
													<input type="text" id="mobile3" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="4" value="${fn:split(userVO.mobileNo,'-')[2] }" />
												</div>
											</div>
										</dd>
									</dl>
								</li>
								<li>
									<dl>
										<dt>
											<label class="<c:if test="${isKnou eq 'true'}">req</c:if>" for="email"><i class="mr10 f150">&middot;</i><spring:message code="user.title.userinfo.email" /></label><!-- 이메일 -->
										</dt>
										<dd>
											<input type="text" name="email" id="email" placeholder="sample@hycu.ac.kr" value="${userVO.email }" class="w300"/>
										</dd>
									</dl>
								</li>
								<li>
									<dl>
										<dt>
											<label for="disabilityCd"><i class="mr10 f150">&middot;</i><spring:message code="user.title.userinfo.disability" /></label><!-- 장애 유형 및 등급 -->
										</dt>
										<dd>
											<select class="ui dropdown selection upward" name="disabilityCd" id="disabilityCd">
												<option value=""><spring:message code="user.message.search.select.disability.cd" /></option><!-- 장애유형 선택 -->
												<c:forEach var="item" items="${disabilityCdList }">
													<option value="${item.codeCd }" ${userVO.disabilityCd eq item.codeCd ? 'selected' : '' }>${item.codeNm }</option>
												</c:forEach>
											</select>
											<select class="ui dropdown selection upward" name="disabilityLv" id="disabilityLv">
												<option value=""><spring:message code="user.message.search.select.disability.lv" /></option><!-- 장애등급 선택 -->
												<c:forEach var="item" items="${disabilityLvList }">
													<option value="${item.codeCd }" ${userVO.disabilityLv eq item.codeCd ? 'selected' : '' }>${item.codeNm }</option>
												</c:forEach>
											</select>
										</dd>
									</dl>
								</li>
		
							<%
							if (!SessionInfo.isKnou(request)) {
								%>
								<li>
									<dl>
										<dt>
											<label class="" for="knouUserId"><i class="mr10 f150">&middot;</i><spring:message code="user.title.knou_rltn" /></label><!-- 한사대 계정 연결 -->
										</dt>
										<dd class="ui action input search-box">
											<input type="hidden" name="knouUserId" id="knouUserId" value="<c:if test="${not empty userVO.knouUserId}">${userVO.knouUserId}</c:if>"/>
											<input type="text" name="knouUserInfo" id="knouUserInfo" value="<c:if test="${not empty userVO.knouUserId}">${userVO.knouUserNm} (${userVO.knouUserId})</c:if>" class="w300" readonly="readonly"/>
											<button class="ui white button" onclick="viewHycuUserPop()"><spring:message code="button.choice" /></button><!-- 선택 -->
											
											<button id="knouUserDelBtn" class="ui white button ml10" onclick="clearKnouUser()" style="display:<c:if test="${empty userVO.knouUserId}">none</c:if>"><spring:message code="button.delete" /></button><!-- 삭제 -->
										</dd>
									</dl>
								</li>
								<%
							}
							%>
							</ul>
						</div>
					</form>
					<div class="tc mt20">
						<a href="javascript:save()" class="ui green button w100">${empty userVO.userId ? save : modify }</a>
						<a class="ui basic button w100" href="/user/userMgr/Form/manageUser.do"><spring:message code="user.button.cancel" /></a><!-- 취소 -->
					</div>
				</div>
			</div>
		</div>
	</div>
			
    <!-- 한사대 계정 연결 팝업 --> 
	<div class="modal fade" id="hycuUserPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="user.title.knou_rltn" />" aria-hidden="false">
	    <div class="modal-dialog modal-lg" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='user.button.close' />"><!-- 닫기 -->
	                    <span aria-hidden="true">&times;</span>
	                </button>
	                <h4 class="modal-title"><spring:message code="user.title.knou_rltn" /></h4><!-- 한사대 계정 연결 -->
	            </div>
	            <div class="modal-body">
	                <iframe src="" id="hycuUserPopIfm" name="hycuUserPopIfm" width="100%" scrolling="no"></iframe>
	            </div>
	        </div>
	    </div>
	</div>

<!-- 	<form id="hycuUserForm" method="POST">
	</form> -->
	
	<script>
	    $('iframe').iFrameResize();
	    window.closeModal = function() {
	        $('.modal').modal('hide');
	    };
	</script>	
</body>
</html>