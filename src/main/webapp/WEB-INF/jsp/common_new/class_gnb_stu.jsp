<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="knou.lms.user.vo.UsrUserInfoVO"%>
<%@page import="java.util.List"%>
<%@page import="knou.lms.menu.vo.MenuVO"%>
<%@page import="knou.framework.common.MenuInfo"%>
<%@page import="knou.framework.common.ParamInfo"%>
<%@page import="knou.framework.common.SessionInfo"%>
<%@include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%
String orgId = SessionInfo.getOrgId(request);
String authrtGrpcd = SessionInfo.getAuthrtGrpcd(request);
String sbjctId = ParamInfo.getParamValue(request, "sbjctId");

// 강의실메뉴 가져 오기
MenuVO menuVO = new MenuVO();
menuVO.setAuthrtGrpcd(authrtGrpcd);
menuVO.setMenuGbncd("LECT");
menuVO.setSbjctId(sbjctId);
List<MenuVO> menuList = MenuInfo.getLectMenuInfo(request, menuVO);
pageContext.setAttribute("menuList", menuList);
%>

	<aside id="gnb_class" class="common class gnb-menu expanded">
		<form id="moveForm" method="post">
			<input name="eparam" type="hidden" value="${eparam}">
			<input name="extParam" type="hidden" value="">
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
			            <a id="MENU_${menu.menuId}" href="#_" index="${status.index}"
			                class="<c:if test='${menu.menuId == curMenuId or (empty curMenuId && status.index eq 0)}'>current</c:if>"
			                onclick="moveMenu(this, '${menu.menuUrl}','${menu.upMenuId}', '${menu.menuId}', '${menu.menunm}', '${menu.linkTargetTycd}');return false;"
			                title="${menu.menunm}">
			                <i class="${menu.menuImgFileId}" aria-hidden="true"></i>
			                <span>${menu.menunm}</span>
			            </a>

			            <%-- 서브 메뉴 --%>
			            <c:if test="${not empty menu.subMenuList}">
			                <ul id="SUB_${menu.menuId}">
			                    <c:forEach items="${menu.subMenuList}" var="sub">
			                        <li id="${sub.menuId}">
			                            <a id="SUBMENU_${sub.menuId}" href="#_"
			                                class="<c:if test='${sub.menuId == curMenuId}'>current</c:if>"
			                                onclick="moveMenu(this, '${sub.menuUrl}', '${sub.upMenuId}', '${sub.menuId}', '${menu.menunm}', '${menu.linkTargetTycd}'); return false;"
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

		</div>

	</aside>

	<script>
	function initClassLnbMenu() {
		/*
    	// NAV 메뉴
        $('#class_lnb ul > li').click(function() {
            if ($(this).hasClass("open") != true) {
                $('#class_lnb ul > li').removeClass("open");
                $(this).addClass("open");
            } else {
                $('#class_lnb ul > li').removeClass("open");
            }
        });
		*/
    }

	// 메뉴 이동
	function moveMenu(obj, menuUrl, upMenuId, menuId, menuNm, linkTargetTycd){
		if (menuUrl === '') {
			return;
		}

		let extParam = UiComm.makeExtParam({upMenuId: upMenuId, menuId: menuId});
		$("#moveForm input[name=extParam]").val(extParam);

		// 타 사이트 호출
		if (linkTargetTycd == "other") {
			window.open(menuUrl, '_blank');
		}
		// self 표시
		else {
			$("#moveForm").attr("action", menuUrl);
			$("#moveForm").submit();
		}
	}

	initClassLnbMenu();
	</script>