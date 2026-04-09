<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="knou.lms.user.vo.UsrUserInfoVO"%>
<%@page import="java.util.List"%>
<%@page import="knou.lms.menu.vo.MenuVO"%>
<%@page import="knou.framework.common.MenuInfo"%>
<%@page import="knou.framework.common.SessionInfo"%>
<%@include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>

<%-- 페이지가 iframe이 아닌 경우만 메뉴 표시 --%>
<c:if test="${pageType ne 'iframe' or param.view eq 'on'}">

<%
String orgId = SessionInfo.getOrgId(request);
String authrtGrpcd = SessionInfo.getAuthrtGrpcd(request);

// 메인메뉴 가져 오기
MenuVO menuVO = new MenuVO();
menuVO.setOrgId(orgId);
menuVO.setMenuTycd(authrtGrpcd);
menuVO.setMenuGbncd("MAIN");
List<MenuVO> menuList = MenuInfo.getMenuInfo(request, menuVO);
pageContext.setAttribute("menuList", menuList);

pageContext.setAttribute("disablilityYn", SessionInfo.getDisablilityYn(request)); // 장애인여부
pageContext.setAttribute("auditYn", SessionInfo.getAuditYn(request)); // 청강생여부
%>

	<aside id="gnb" class="common gnb-menu expanded">
		<form id="moveForm" method="post">
			<input name="encParams" type="hidden" value="${encParams}">
			<input name="addParams" type="hidden" value="">
			<input name="menunm"    type="hidden" value="">
			<input name="menuUrl"   type="hidden" value="">
			<input name="upMenuId"  type="hidden" value="">
			<input name="menuId"    type="hidden" value="">
		</form>

		<div class="option-control-wrap">
			<button type="button" class="btn border-0 btn-close ctrl-gnb">
				<i class="icon-svg-close mobile-elem" aria-hidden="true"></i>
				<i class="icon-svg-ctrl-collapse desktop-elem" aria-hidden="true"></i>
				<span class="title">메뉴접기</span>
			</button>
		</div>

		<div class="scrollarea">

			<!-- user info -->
			<div class="user-info">
				<div class="box">
					<div class="user-photo">
						<img src="<%=request.getContextPath()%>/webdoc/assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진">
					</div>
					<a href="#0"><div class="btn-setting"><i class="icon-svg-setting" aria-hidden="true"></i></div></a>
					<div class="user-desc">
						<p class="name">나방송 <span class="prof">학생</span></p>
						<p class="major">마케팅·애널리틱스</p>
					</div>
				</div>
			</div>

			<!-- gnb menu -->
			<nav class="gnb">
			    <c:forEach items="${menuList}" var="menu" varStatus="status">
			        <div class="gnb-item">
			            <%-- 상위 메뉴 --%>
			            <a id="MENU_${menu.menuId}" href="#0"
			                class="<c:if test='${menu.menuId == curMenuId or (empty curMenuId and status.index == 0)}'>current</c:if>"
			                onclick='moveMenu(this, "${menu.menuUrl}", "${menu.upMenuId}", "${menu.menuId}", "${menu.menunm}", "${menu.linkTargetTycd}");return false;'
			                title="${menu.menunm}">
			                <i class="${menu.menuImgFileId}" aria-hidden="true"></i>
			                <span>${menu.menunm}</span>
			            </a>

			            <%-- 서브 메뉴 --%>
			            <c:if test="${not empty menu.subMenuList}">
			                <ul id="SUB_${menu.menuId}">
			                    <c:forEach items="${menu.subMenuList}" var="sub">
			                        <li id="${sub.menuId}">
			                            <a id="SUBMENU_${sub.menuId}" href="#0"
			                                class="<c:if test='${sub.menuId == curMenuId}'>current</c:if>"
			                                onclick='moveMenu(this, "${sub.menuUrl}", "${sub.upMenuId}", "${sub.menuId}", "${sub.menunm}", "${sub.linkTargetTycd}");return false;'
			                                title="${sub.menunm}">
			                                <span>${sub.menunm}</span>
			                            </a>
			                        </li>
			                    </c:forEach>
			                </ul>
			            </c:if>
			        </div>
			    </c:forEach>
			</nav>
			<!-- //gnb menu -->

			<script type="text/javascript">
				// 메뉴 스크롤
				scrollGnbMenu("${curUpMenuId}", "${curMenuId}");
			</script>
		</div>

	</aside>

</c:if>