<%@page import="knou.lms.user.vo.UsrUserInfoVO"%>
<%@page import="java.util.List"%>
<%@page import="knou.lms.menu.vo.SysMenuVO"%>
<%@page import="knou.framework.common.MenuInfo"%>
<%@page import="knou.framework.common.SessionInfo"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>

<%
String orgId = SessionInfo.getOrgId(request);
String authrtGrpcd = SessionInfo.getAuthrtGrpcd(request);

// 메뉴 가져오기
SysMenuVO sysMenuVO = new SysMenuVO();
sysMenuVO.setOrgId(orgId);
sysMenuVO.setAuthrtGrpcd(authrtGrpcd);
SysMenuVO menuInfo = MenuInfo.getMenuInfo(request, sysMenuVO);
pageContext.setAttribute("menuInfo", menuInfo);

pageContext.setAttribute("disablilityYn", SessionInfo.getDisablilityYn(request)); // 장애인여부
pageContext.setAttribute("auditYn", SessionInfo.getAuditYn(request)); // 청강생여부

pageContext.setAttribute("curUpMenuId", SessionInfo.getCurUpMenuId(request));
pageContext.setAttribute("curMenuId", SessionInfo.getCurMenuId(request));

%>
<script type="text/javascript">
	$(function(){
		initClassLnbMenu();
	});
</script>

	<aside id="gnb" class="common gnb-menu expanded">
		<form id="moveForm" method="post"></form>

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
			    <c:forEach items="${menuInfo.subList}" var="menu">
			        <div class="gnb-item">
			            <!-- 상위 메뉴 -->
			            <a href="#class_lnb"
			                class="<c:if test='${menu.menuId == curUpMenuId}'>current</c:if>"
			                onclick="if('${menu.menuUrl}' != ''){ moveMenu('${menu.menuUrl}','${menu.upMenuId}', '${menu.menuId}'); } return false;"
			                title="${menu.menuNm}">
			                <i class="${menu.menuImgFileId}" aria-hidden="true"></i>
			                <span>${menu.menuNm}</span>
			            </a>

			            <!-- 서브 메뉴 -->
			            <c:if test="${not empty menu.subList}">
			                <ul>
			                    <c:forEach items="${menu.subList}" var="sub">
			                        <li id="${sub.menuId}">
			                            <a href="#class_lnb"
			                                class="<c:if test='${sub.menuId == curUpMenuId}'>active</c:if>"
			                                onclick="moveMenu('${sub.menuUrl}', '${sub.upMenuId}', '${sub.menuId}'); return false;"
			                                title="${sub.menuNm}">
			                                <span>${sub.menuNm}</span>
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
    	/********** NAV 메뉴 **********/
        $('#class_lnb ul > li').each(function() {
            if ($(this).find('ul').length == true) {
                //$(this).addClass('sub-menu');
            };
        });
        $('#class_lnb ul > li').click(function() {
            if ($(this).hasClass("open") != true) {
                $('#class_lnb ul > li').removeClass("open");
                $(this).addClass("open");
            } else {
                $('#class_lnb ul > li').removeClass("open");
            }
        });
    }

	function moveMenu(menuUrl, upMenuId, menuId){
		if (menuUrl.indexOf("?") > -1) {
			menuUrl += "&param="+btoa("MENU,"+upMenuId+","+menuId);
		}
		else {
			menuUrl += "?param="+btoa("MENU,"+upMenuId+","+menuId);
		}

		$("#moveForm").attr("action", menuUrl);
		$("#moveForm").submit();
	}
	</script>