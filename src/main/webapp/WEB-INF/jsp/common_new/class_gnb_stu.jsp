<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="knou.lms.user.vo.UsrUserInfoVO"%>
<%@page import="java.util.List"%>
<%@page import="knou.lms.menu.vo.MenuVO"%>
<%@page import="knou.framework.common.MenuInfo"%>
<%@page import="knou.framework.common.ParamInfo"%>
<%@page import="knou.framework.common.SessionInfo"%>
<%@include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%
String authrtGrpcd = SessionInfo.getAuthrtGrpcd(request);
String orgId = ParamInfo.getParamValue(request, "orgId");
String sbjctId = ParamInfo.getParamValue(request, "sbjctId");

// 강의실메뉴 가져 오기
MenuVO menuVO = new MenuVO();
menuVO.setAuthrtGrpcd(authrtGrpcd);
menuVO.setMenuGbncd(CommConst.MENU_GBN_LECT);
menuVO.setOrgId(orgId);
menuVO.setSbjctId(sbjctId);
List<MenuVO> menuList = MenuInfo.getLectMenuInfo(request, menuVO);
pageContext.setAttribute("menuList", menuList);
%>

	<aside id="gnb_class" class="common class gnb-menu expanded">
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

        <!-- class -->
        <div class="class-title">
            <span>강의실</span>
        </div>

		<div class="scrollarea">
            <!-- gnb menu -->
            <nav class="gnb_class">
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
			                <ul id="SUB_${menu.menuId}" style="<c:if test='${menu.menuId == curUpMenuId}'>display:block</c:if>">
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
