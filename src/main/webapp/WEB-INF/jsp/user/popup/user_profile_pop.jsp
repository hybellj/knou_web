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
    	$(document).ready(function() {
    	});
    	
    	// 내정보 수정 팝업
    	function editProfilePop() {
			parent.profileForm.target = "userProfilePopIfm";
			parent.profileForm.action = "/user/userHome/userProfileEditPop.do";
			parent.profileForm.submit();
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
            <div class="ui form userInfoManage">
                    <div class="userImg">
                        <div class="image">
                            <c:choose>
	        					<c:when test="${not empty phtFile}">
									<img alt="<spring:message code="crs.title.letcuser" /><spring:message code="lesson.label.img" />" style="max-width:100%;max-height:100%" src='${phtFile}'>
	        					</c:when>
	        					<c:otherwise>
	        						<img alt="<spring:message code="crs.title.letcuser" /><spring:message code="lesson.label.img" />" style="max-width:100%;min-width:60%;max-height:100%" src="/webdoc/img/icon-hycu-symbol-grey.svg">
	        					</c:otherwise>
	        				</c:choose>
	        				<%-- <c:if test="${vo.menuType.contains('ADMIN') or vo.menuType.contains('PROFESSOR')}">
                            	<a href="javascript:editProfilePop()" class="ui icon button" title="<spring:message code="user.button.mod" />"><i class="ico-setting-outline ico" aria-hidden="true"></i></a><!-- 수정 -->
	        				</c:if> --%>
                        </div>
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
                                        <!-- <spring:message code="user.message.useredit.org.info2" /> -->
                                    </div>
                                    --%>
                                </dd>
                            </dl>                            
                        </li>
                        <li>
                            <dl>
                                <dt><spring:message code="user.title.userinfo.manage.usernm" /></dt><!-- 이름 -->
                                <dd>${vo.userNm}</dd>
                                <dt><spring:message code="user.title.userinfo.user.no" /></dt><!-- 학번/사번 -->
                                <dd>${vo.userId}</dd>
                            </dl> 
                        </li>
                        <li>
                            <dl>
                                <dt><spring:message code="user.title.userinfo.mobileno" /></dt><!-- 휴대폰 번호 -->
                                <dd>${vo.mobileNo}</dd>
                            </dl> 
                        </li>
                        <li>
                            <dl>
                                <dt><spring:message code="user.title.userinfo.email" /></dt><!-- 이메일 -->
                                <dd>
                                	${vo.email}
                                </dd>
                            </dl>   
                        </li>
                    </ul>
                </div>
            </div>
            
            <div class="bottom-content tr">
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="user.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
	
</html>
