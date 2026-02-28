<%@page import="knou.framework.common.SessionInfo"%>
<%@page import="knou.framework.common.MenuInfo"%>
<%@page import="knou.lms.menu.vo.SysMenuVO"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib  prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="lnbOrgId" value="${orgId}"/>
<c:set var="lnbMenuType" value="${menuType}"/>

<%
String orgId = (String)pageContext.getAttribute("lnbOrgId");
String menuType = (String)pageContext.getAttribute("lnbMenuType");

//메뉴 가져오기
SysMenuVO sysMenuVO = new SysMenuVO();
sysMenuVO.setOrgId(orgId);
sysMenuVO.setMenuType(menuType);
SysMenuVO menuInfo = MenuInfo.getMenuInfo(request, sysMenuVO);
pageContext.setAttribute("menuInfo", menuInfo);

pageContext.setAttribute("curParMenuCd", SessionInfo.getCurParMenuCd(request));
pageContext.setAttribute("curMenuCd", SessionInfo.getCurMenuCd(request));
pageContext.setAttribute("curUserType", SessionInfo.getAuthrtCd(request));
%>
<script type="text/javascript">
	const config = {
		//name of the Tab div
		tabContainer :'tab_',
		
	    //name of the content div
	    tabContentContainer:'tabContent_',
	}
		        
	const newTab = new LiveTabs( config ,'newTab');

	function moveMenu(menuName, menuUrl, parMenuCd, menuCd){
		
		function fallback() {
			setTimeout(() => {
			//	$('#tabContent_' + menuCd).load( menuUrl );
				$('#tabContent_' + menuCd).attr('src', menuUrl);
			}, 1);  // 1ms 후 실행
		}
	
		newTab.createTab(menuName, menuCd, fallback);
	}

</script>

<div id="admin-lnb">
	<form id="moveForm" method="post">
		<input type="hidden" id="lnbOrgId" value="${orgId}"/>
		<input type="hidden" id="lnbMenuType" value="${menuType}"/>
		<input type="hidden" id="lnbAuthGrpCd" value="${authGrpCd}"/>
	</form>
    <div class="straight">
        <button class="admin-menu-btn"><i class="ion-navicon"></i></button>
    </div>
    <ul class="clearfix" id="lnbUl">
  		<c:if test="${not empty menuInfo}">
  			<li class="<c:if test="${menuInfo.menuCd == curMenuCd}">open</c:if>">
				<a href="javascript:moveMenu('${menuInfo.menuNm}', '${menuInfo.menuUrl}','${menuInfo.parMenuCd}','${menuInfo.menuCd}');">
					<span>${menuInfo.menuNm}<c:if test="${orgId ne 'ORG0000001'}"><small style="margin-left: 3px; letter-spacing: 1px">(${orgId})</small></c:if></span>
				</a>
			</li>
			
			<c:if test="${not empty menuInfo.subList}">
	  			<c:forEach items="${menuInfo.subList}" var="menu">
	  				<c:set var="viewAuthGrpCdArr" value="${fn:split(menu.viewAuthGrpCds, ',')}" />
	  				<c:set var="viewAuth" value="N" />
	  				
	  				<c:forEach items="${viewAuthGrpCdArr}" var="authGrpCd">
	  					<c:if test="${fn:contains(curUserType, authGrpCd)}">
	  						<c:set var="viewAuth" value="Y" />
	  					</c:if>
	  				</c:forEach>
	  				
	  				<%-- <c:if test="${viewAuth eq 'Y'}"> --%>
		  				<li class="<c:if test="${not empty menu.subList}">sub-menu</c:if><c:if test="${menu.menuCd == curParMenuCd or menu.menuCd == curMenuCd}"> open</c:if>">
		  					<c:if test="${not empty menu.menuUrl and menu.menuUrl ne ''}">
	       						<a class="" href="javascript:moveMenu('${menu.menuNm}', '${menu.menuUrl}','${menu.parMenuCd}','${menu.menuCd}')" title="${menu.menuNm}"><span>${menu.menuNm}</span></a>
	       					</c:if>
	       					<c:if test="${empty menu.menuUrl or menu.menuUrl eq ''}">
	       						<a class="" href="javascript:;" title="${menu.menuNm}"><span>${menu.menuNm}</span></a>
	       					</c:if>
		  					
		  					<c:if test="${not empty menu.subList}">
		  						<ul>
			  						<c:forEach items="${menu.subList}" var="sub">
			  							<li class="<c:if test="${sub.menuCd == curMenuCd}">open</c:if>">
			  								<c:if test="${not empty sub.menuUrl and sub.menuUrl ne ''}">
					       						<a class="" href="javascript:moveMenu('${sub.menuNm}', '${sub.menuUrl}','${sub.parMenuCd}','${sub.menuCd}')" title="${sub.menuNm}"><span>${sub.menuNm}</span></a>
					       					</c:if>
					       					<c:if test="${empty sub.menuUrl or sub.menuUrl eq ''}">
					       						<a class="" href="javascript:;" title="${sub.menuNm}"><span>${sub.menuNm}</span></a>
					       					</c:if>
			  							</li>
			  						</c:forEach>
		  						</ul>
		  					</c:if>
		  				</li>
	  				<%-- </c:if> --%>
	  			</c:forEach>
  			</c:if>
  		</c:if>
    </ul>
    <script>
        $(function() {
            /********** NAV 메뉴 **********/
            $('.admin-menu-btn').on('click', function() {
                $('#admin-lnb').toggleClass('fold');
                $('#container').toggleClass('push-left');
            });
            /********** admin menuPush **********/
            var overlay = $('.overlay');

            $('.menu-btn').click(function() {
                $(this).parents().find('#admin-lnb').toggleClass('active');
                overlay.show();
            });
            overlay.click(function() {
                $(this).parents().find('#admin-lnb').toggleClass('active');
                overlay.hide();
            });
            
            $('#admin-lnb > ul > li').click(function() {
                if ($(this).hasClass("open") != true) {
                    $('#admin-lnb > ul > li').removeClass("open");
                    $(this).addClass("open");
                } else {
                    $('#admin-lnb > ul > li').removeClass("open");
                }
            });
            $('.admin-menu-btn').click(function() {
                $('.ui.sticky').sticky('refresh');
            });
        });
    </script>
</div>
<div class="overlay"></div>
