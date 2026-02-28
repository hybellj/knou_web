<%@ page import="knou.framework.util.StringUtil"%>
<%@ page import="knou.framework.common.SessionInfo"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<div class="location-wrap">
    <!-- <div class="inner"> 삭제_230517-->
    <!-- 페이지 정보 -->
    <div class="ui menu">
        <a href="<%=SessionInfo.getCurUserHome(request)%>" class="home r_btn" title="Home"><img src="/webdoc/img/location_home.gif" alt="<spring:message code="button.go.home" />"></a><!-- 홈으로 -->
        <div class="pageTit_wrap">                
            <ul class="page_locat"> 
                <li><a href="<%=SessionInfo.getCurUserHome(request)%>"><spring:message code="bbs.label.bbs_lect_home" /></a></li><!-- 강의실 홈 -->
            </ul>
            <div class="r_btn_wrap desktop-elem flex-item">
                <p class="desktop-elem">
                    <small>
                        <span><spring:message code="main.prev.login" /></span> <span><%=SessionInfo.getLastLogin(request)%></span><!-- 이전로그인 -->
                    </small>
                </p>
				<%
                if (StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request)).contains("ADM")) {
					%>
	                <a href="/dashboard/adminDashboard.do" class="" title="<spring:message code="exam.label.class.management.tool" />">
	                    <small class="flex-item">
	                        <i class="icon-stuff-ruler ico"></i>
	                        <span class="desktop-elem"><spring:message code="exam.label.class.management.tool" /></span><!-- 수업운영도구 -->
	                    </small>
	                </a>
					<%
                }
	            %>
            </div>
            
			<%
			// 모바일화면을 위한 수업운영도구 버튼
            if (StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request)).contains("ADM")) {
				%>
	            <div class="admin-mobile-wrap">
	            	<a href="/dashboard/adminDashboard.do" class="" title="<spring:message code="exam.label.class.management.tool" />">
	                    <small class="flex-item">
	                        <i class="icon-stuff-ruler ico"></i>
	                        <span class="desktop-elem"><spring:message code="exam.label.class.management.tool" /></span><!-- 수업운영도구 -->
	                    </small>
	                </a>
	            </div>            
	            <%
            }
            %>
        </div>
    </div>

</div>
