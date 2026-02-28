<%@page import="knou.framework.common.SessionInfo"%>
<%@page import="knou.framework.common.MenuInfo"%>
<%@page import="knou.lms.menu.vo.SysMenuVO"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib  prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="lnbOrgId" value="${orgId}"/>
<c:set var="lnbAuthrtCd" value="${authrtCd}"/>

<%
String orgId = (String)pageContext.getAttribute("lnbOrgId");
String authrtCd = (String)pageContext.getAttribute("lnbAuthrtCd");

//메뉴 가져오기
SysMenuVO sysMenuVO = new SysMenuVO();
sysMenuVO.setOrgId(orgId);
sysMenuVO.setAuthrtGrpcd(authrtCd);
SysMenuVO menuInfo = MenuInfo.getMenuInfo(request, sysMenuVO);
pageContext.setAttribute("menuInfo", menuInfo);

pageContext.setAttribute("curParMenuCd", SessionInfo.getCurParMenuCd(request));
pageContext.setAttribute("curMenuCd", SessionInfo.getCurMenuCd(request));
pageContext.setAttribute("curUserType", SessionInfo.getAuthrtCd(request));

%>

<script type="text/javascript">
	$(document).ready(function() {
	    // LNB 메뉴 클릭 이벤트
	    $("#admin-lnb .sub-menu > a").on("click", function(e) {
	        // 현재 클릭한 메뉴의 하위 ul이 있는지 확인
	        var $nextUl = $(this).next("ul");
	        
	        if ($nextUl.length > 0) {
	            e.preventDefault();
	            e.stopPropagation();
	
	            var $parentLi = $(this).parent("li");
	            
	            if ($parentLi.hasClass("open")) {
	                $parentLi.removeClass("open");
	                $nextUl.slideUp(200);
	            } else {
	                $parentLi.addClass("open");
	                $nextUl.slideDown(200);
	            }
	        }
	    });
	});

	function moveMenu(menuUrl, parMenuCd, menuCd){
		if (menuUrl.indexOf("?") > -1) {
			menuUrl += "&param="+btoa("MENU,"+parMenuCd+","+menuCd);
		}
		else {
			menuUrl += "?param="+btoa("MENU,"+parMenuCd+","+menuCd);
		}
		
		$("#moveForm").attr("action", menuUrl);
		$("#moveForm").submit();
	}

</script>
<div id="admin-lnb">
	<form id="moveForm" method="post">
		<input type="hidden" id="lnbOrgId" value="${orgId}"/>
		<input type="hidden" id="lnbAuthrtCd" value="${authrtCd}"/>
		<input type="hidden" id="lnbAuthGrpCd" value="${authGrpCd}"/>
	</form>
    <div class="straight">
        <button class="admin-menu-btn"><i class="ion-navicon"></i></button>
    </div>
    <ul class="clearfix" id="lnbUl">
	    <c:if test="${not empty menuInfo}">
	        <li class="<c:if test="${menuInfo.menuCd == curMenuCd}">open</c:if>">
	            <a href="javascript:moveMenu('${menuInfo.menuUrl}','${menuInfo.parMenuCd}','${menuInfo.menuCd}');">
	                <span>${menuInfo.menuNm}
	                    <c:if test="${orgId ne 'ORG0000001'}">
	                        <small style="margin-left: 3px; letter-spacing: 1px">(${orgId})</small>
	                    </c:if>
	                </span>
	            </a>
	        </li>
	        
	        <c:if test="${not empty menuInfo.subList}">
	            <c:forEach items="${menuInfo.subList}" var="menu"> <li class="<c:if test="${not empty menu.subList}">sub-menu</c:if><c:if test="${menu.menuCd == curParMenuCd or menu.menuCd == curMenuCd}"> open</c:if>">
	                    <a href="${not empty menu.menuUrl ? "javascript:moveMenu('" += menu.menuUrl += "','" += menu.parMenuCd += "','" += menu.menuCd += "')" : "javascript:;"}" title="${menu.menuNm}">
	                        <span>${menu.menuNm}</span>
	                    </a>
	                    
	                    <c:if test="${not empty menu.subList}">
	                        <ul>
								<c:forEach items="${menu.subList}" var="sub">
								    <c:set var="isChildActive" value="false" />
								    <c:forEach items="${sub.subList}" var="checkL4">
								        <c:if test="${checkL4.menuCd == curMenuCd}">
								            <c:set var="isChildActive" value="true" />
								        </c:if>
								    </c:forEach>
								
								    <li class="<c:if test="${not empty sub.subList}">sub-menu</c:if> <c:if test="${sub.menuCd == curMenuCd or isChildActive}">open</c:if>">
								        <a href="${not empty sub.menuUrl ? "javascript:moveMenu('" += sub.menuUrl += "','" += sub.parMenuCd += "','" += sub.menuCd += "')" : "javascript:;"}">
								            <span>${sub.menuNm}</span>
								        </a>
								
								        <c:if test="${not empty sub.subList}">
								            <ul <c:if test="${sub.menuCd != curMenuCd and !isChildActive}">style="display:none;"</c:if>>
								                <c:forEach items="${sub.subList}" var="subL4">
								                    <li class="<c:if test="${subL4.menuCd == curMenuCd}">open</c:if>">
								                        <a href="javascript:moveMenu('${subL4.menuUrl}','${subL4.parMenuCd}','${subL4.menuCd}')">
								                            <span>${subL4.menuNm}</span>
								                        </a>
								                    </li>
								                </c:forEach>
								            </ul>
								        </c:if>
								    </li>
								</c:forEach>
	                        </ul>
	                    </c:if>
	                </li>
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
