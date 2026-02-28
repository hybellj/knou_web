<%@page import="knou.lms.user.vo.UsrUserInfoVO"%>
<%@page import="java.util.List"%>
<%@page import="knou.lms.menu.vo.SysMenuVO"%>
<%@page import="knou.framework.common.MenuInfo"%>
<%@page import="knou.framework.common.SessionInfo"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<c:set var="lnbOrgId" value="${orgId}"/>
<c:set var="lnbMenuType" value="${menuType}"/>
<c:set var="lnbUserGbn" value="${userGbn}"/>

<%
// 과목CD를 파라메터로 받고, 없는 경우 세션에서도 체크(임시처리...)
String crsCreCd = request.getParameter("crsCreCd");
if (crsCreCd == null || "".equals(crsCreCd)) {
	crsCreCd = SessionInfo.getCrsCreCd(request);
}

String orgId = (String)pageContext.getAttribute("lnbOrgId");
String menuType = (String)pageContext.getAttribute("lnbMenuType");

// 메뉴 가져오기
SysMenuVO sysMenuVO = new SysMenuVO();
sysMenuVO.setOrgId(orgId);
sysMenuVO.setAuthrtGrpcd(menuType);
sysMenuVO.setCrsCreCd(crsCreCd);
SysMenuVO menuInfo = MenuInfo.getMenuInfo(request, sysMenuVO);
pageContext.setAttribute("menuInfo", menuInfo);

pageContext.setAttribute("disablilityYn", SessionInfo.getDisablilityYn(request)); // 장애인여부
pageContext.setAttribute("auditYn", SessionInfo.getAuditYn(request)); // 청강생여부

pageContext.setAttribute("curParMenuCd", SessionInfo.getCurParMenuCd(request));
pageContext.setAttribute("curMenuCd", SessionInfo.getCurMenuCd(request));

%>
<script type="text/javascript">
	$(function(){
		initClassLnbMenu();
	});
</script>

	<aside id="gnb" class="common ">

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
						<img src="/webdoc/dm_assets/img/common/photo_user_sample.png" aria-hidden="true" alt="사진">
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
			                class="<c:if test='${menu.menuCd == curParMenuCd}'>current</c:if>"
			                onclick="if('${menu.menuUrl}' != ''){ moveMenu('${menu.menuUrl}', null, null, '${menu.parMenuCd}', '${menu.menuCd}'); } return false;"
			                title="${menu.menuNm}">
			                <i class="${menu.leftMenuImg}" aria-hidden="true"></i>
			                <span>${menu.menuNm}</span>
			            </a>
			
			            <!-- 서브 메뉴 -->
			            <c:if test="${not empty menu.subList}">
			                <ul>
			                    <c:forEach items="${menu.subList}" var="sub">
			                        <li id="${sub.menuCd}">
			                            <a href="#class_lnb"
			                                class="<c:if test='${sub.menuCd == curMenuCd}'>active</c:if>"
			                                onclick="moveMenu('${sub.menuUrl}', null, null, '${sub.parMenuCd}', '${sub.menuCd}'); return false;"
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
	</script>