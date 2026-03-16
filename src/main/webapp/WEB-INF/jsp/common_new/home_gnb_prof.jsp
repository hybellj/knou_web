<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="knou.lms.user.vo.UsrUserInfoVO"%>
<%@page import="java.util.List"%>
<%@page import="knou.lms.menu.vo.SysMenuVO"%>
<%@page import="knou.framework.common.MenuInfo"%>
<%@page import="knou.framework.common.SessionInfo"%>
<%@include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>

<c:if test="${pageType ne 'iframe' or param.view eq 'on'}">

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
			    <c:forEach items="${menuInfo.subList}" var="menu" varStatus="status">
			        <div class="gnb-item">
			            <!-- 상위 메뉴 -->
			            <a href="#class_lnb" index="${status.index}"
			                class="<c:if test='${menu.menuId == curUpMenuId}'>current</c:if>"
			                menuUrl="${menu.menuUrl}" upMenuId="${menu.upMenuId}" menuId="${menu.menuId}"
			                onclick="if('${menu.menuUrl}' != ''){ moveMenu(this, '${menu.menuUrl}','${menu.upMenuId}', '${menu.menuId}'); } return false;"
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
			                                onclick="moveMenu(this, '${sub.menuUrl}', '${sub.upMenuId}', '${sub.menuId}'); return false;"
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

	// 메뉴 이동
	function moveMenu(obj, menuUrl, upMenuId, menuId){
		let index = $(obj).attr("index");
		let menuNm = $(obj).children("span").html();

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

		if (index == "0") { 
			$("#moveForm").attr("action", menuUrl);
			$("#moveForm").submit();
		}
		else {
			if (typeof TAB_MENU == 'undefined') {
				let url = "/dashboard/mainTabpage.do"
				$("#moveForm").attr("action", url);
				$("#moveForm").submit();
			}
			else {
				TAB_MENU.addTabMenu(menuNm, menuUrl, upMenuId, menuId)
			}
		}
	}

	</script>
	
</c:if>