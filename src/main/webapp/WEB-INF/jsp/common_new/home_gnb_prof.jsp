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
%>

	<aside id="gnb" class="common gnb-menu expanded">
		<form id="moveForm" method="post">
			<input name="menuNm" type="hidden" value="">
			<input name="menuUrl" type="hidden" value="">
			<input name="upMenuId" type="hidden" value="">
			<input name="menuId" type="hidden" value="">
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
						<img src="/webdoc/assets/img/common/photo_user_sample.png" aria-hidden="true" alt="사진">
					</div>
					<a href="#0"><div class="btn-setting"><i class="icon-svg-setting" aria-hidden="true"></i></div></a>
					<div class="user-desc">
						<p class="name">홍길동 <span class="prof">교수</span></p>
						<!-- <p class="major">마케팅·애널리틱스</p> -->
					</div>
				</div>
			</div>

			<!-- gnb menu -->
			<nav class="gnb">
			    <c:forEach items="${menuList}" var="menu" varStatus="status">
			        <div class="gnb-item">
			            <%-- 상위 메뉴 --%>
			            <a id="MENU_${menu.menuId}" href="#class_lnb" index="${status.index}"
			                class="<c:if test='${menu.menuId == curMenuId}'>current</c:if>"
			                menuUrl="${menu.menuUrl}" upMenuId="${menu.upMenuId}" menuId="${menu.menuId}" linkTargetTycd="${menu.linkTargetTycd}"
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
			                            <a id="SUBMENU_${sub.menuId}" href="#class_lnb"
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

	// 메뉴 이벤트 설정
	function initClassLnbMenu() {
    	/*
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

		let index = "";

		if (obj != null) {
			index = obj != null ? $(obj).attr("index") : "";
			if (!menuNm) {
				menuNm = $(obj).children("span").html();
			}
		}

		if (menuUrl.indexOf("?") > -1) {
			menuUrl += "&param="+btoa("MENU,"+upMenuId+","+menuId);
		}
		else {
			menuUrl += "?param="+btoa("MENU,"+upMenuId+","+menuId);
		}

		$("#moveForm input[name=menuNm]").val(menuNm);
		$("#moveForm input[name=menuUrl]").val(menuUrl);
		$("#moveForm input[name=upMenuId]").val(upMenuId);
		$("#moveForm input[name=menuId]").val(menuId);

		// Tab에 표시
		if (linkTargetTycd == "tab") {
			if (typeof TAB_MENU == 'undefined') {
				let url = "/dashboard/mainTabpage.do"
				$("#moveForm").attr("action", url);
				$("#moveForm").submit();
			}
			else {
				TAB_MENU.addTabMenu(menuNm, menuUrl, upMenuId, menuId)
			}
		}
		// 타 사이트 호출
		else if (linkTargetTycd == "other") {
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

</c:if>