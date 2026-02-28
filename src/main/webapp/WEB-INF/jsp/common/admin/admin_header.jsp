<%@ page import="knou.framework.common.SessionInfo"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      		uri="http://java.sun.com/jsp/jstl/core" %>

<header>
    <div class="inner-box">

        <a href="#0" class="menu-btn">
            <span class="barTop"></span>
            <span class="barMid"></span>
            <span class="barBot"></span>
        </a>
        <h1><a href="/dashboard/main.do"><img src="/webdoc/img/logo2.png" alt="LMS LOGO"></a></h1>

        <ul class="util">

            <li class="user-img ui dropdown">
              	<div class="initial-img sm c-2"><spring:message code="common.mgr" /></div><!-- 관리 -->
                <div class="menu">
                    <div class="item profile">
		               	<div class="initial-img sm c-2"><spring:message code="common.mgr" /></div><!-- 관리 -->
                        <ul>
                            <li></li>
                        </ul>
                    </div>
                    <div class="divider m0"></div>
                    <div class="item"><a href="#0" onclick="userProfilePop('<%=SessionInfo.getUserId(request)%>');return false;"><i class="user circle icon"></i><spring:message code="common.my.information" /></a></div><!-- 내정보 -->

                    <div class="divider m0"></div>
                    <div class="item"><a href="/user/userHome/logout.do" onclick="localStorage.removeItem('USER_PHOTO_<%=SessionInfo.getUserId(request)%>')" title="Logout"><i class="sign-out icon"></i><spring:message code="button.logout" /></a></div>
                </div>
            </li>
        </ul>
        <script type="text/javascript">
			// 내정보 관리 팝업
			function userProfilePop(userId) {
                $("#profileForm").remove();
                var url  = "/user/userHome/userProfilePop.do";
                var form = $("<form></form>");
                form.attr("method", "POST");
                form.attr("id", "profileForm");
                form.attr("target", "userProfilePopIfm");
                form.attr("action", url);
                form.appendTo("body");
                form.submit();
                $("#userProfilePop").modal("show");
                $('iframe').iFrameResize();
			}
            
			window.closeModal = function() {
				$('.modal').modal('hide');
			};
        </script>
    </div>

    <!-- 내정보 관리 팝업 -->
    <div class="modal fade" id="userProfilePop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="common.my.information" /><spring:message code="common.mgr" />" aria-hidden="false">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="common.button.close" />"><!-- 닫기 -->
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title"><spring:message code="common.my.information" /><spring:message code="common.mgr" /></h4>
                </div>
                <div class="modal-body">
                    <iframe src="" id="userProfilePopIfm" name="userProfilePopIfm" width="100%" scrolling="no" title="userProfilePopIfm"></iframe>
                </div>
            </div>
        </div>
    </div>
    <!-- 통합 메시지폼 -->
    <form id="alarmForm" name="alarmForm" method="post" style="position:absolute;left:1000">
        <input type="hidden" name="rcvUserInfoStr" />
        <input type="hidden" name="sysCd" value="LMS" />
        <input type="hidden" name="orgId" value="KNOU" />
        <input type="hidden" name="bussGbn" value="LMS" />
        <input type="hidden" name="alarmType" value="S"/>
        <input type="hidden" name="menuId" value="LMS"/>
    </form>
</header>
