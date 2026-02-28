<%@page import="knou.lms.menu.vo.SysMenuVO"%>
<%@page import="knou.framework.common.MenuInfo"%>
<%@page import="knou.framework.common.SessionInfo"%>

<%@page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<c:set var="lnbOrgId" value="${orgId}"/>
<c:set var="lnbMenuType" value="${menuType}"/>
<c:set var="lnbMenuGbn" value="${menuGbn}"/>

<%
String orgId = (String)pageContext.getAttribute("lnbOrgId");
String menuType = (String)pageContext.getAttribute("lnbMenuType");
String menuGbn = (String)pageContext.getAttribute("lnbMenuGbn");

// 메뉴 가져오기
SysMenuVO sysMenuVO = new SysMenuVO();
sysMenuVO.setOrgId(orgId);
sysMenuVO.setMenuType(menuType);
sysMenuVO.setMenuGbn(menuGbn);
SysMenuVO menuInfo = MenuInfo.getMenuInfo(request, sysMenuVO);

pageContext.setAttribute("menuInfo", menuInfo);
%>

<script type="text/javascript">
	$(function(){
		initClassLnbMenu();
	});
</script>

	<aside id="gnb_class" class="common class ">
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
            <!-- <nav class="gnb_class">
                            
                <div class="gnb-item">
                    <a href="#0" class="current"><i class="icon-svg-monitor" aria-hidden="true"></i><span>내강의실</span></a>
                </div>
                
                <div class="gnb-item">
                    <a href="#0" ><i class="icon-svg-notice" aria-hidden="true"></i><span>공지사항</span></a>
                    <ul>
                        <li><a href="#0"><span>2depth</span></a></li>
                        <li><a href="#0"><span>2depth</span></a></li>
                    </ul>
                </div>                
                
                <div class="gnb-item">
                    <a href="#0" ><i class="icon-svg-save" aria-hidden="true"></i><span>강의자료실</span></a>
                </div>  
                
                <div class="gnb-item">
                    <a href="#0" ><i class="icon-svg-question" aria-hidden="true"></i><span>강의Q&A</span></a>
                </div>

                <div class="gnb-item">
                    <a href="#0" ><i class="icon-svg-message" aria-hidden="true"></i><span>1:1상담</span></a>
                </div>	

                <div class="gnb-item">
                    <a href="#0" ><i class="icon-svg-users-edit" aria-hidden="true"></i><span>팀게시판</span></a>
                </div>

                <div class="gnb-item">
                    <a href="#0" ><i class="icon-svg-edit" aria-hidden="true"></i><span>과제</span></a>
                </div>

                <div class="gnb-item">
                    <a href="#0" ><i class="icon-svg-quiz" aria-hidden="true"></i><span>퀴즈</span></a>
                </div>

                <div class="gnb-item">
                    <a href="#0" ><i class="icon-svg-check-done" aria-hidden="true"></i><span>설문</span></a>
                </div>

                <div class="gnb-item">
                    <a href="#0" ><i class="icon-svg-message-chat" aria-hidden="true"></i><span>토론</span></a>                    
                </div>

                <div class="gnb-item">
                    <a href="#0" ><i class="icon-svg-presentation" aria-hidden="true"></i><span>세미나</span></a>                    
                </div>

                <div class="gnb-item">
                    <a href="#0" ><i class="icon-svg-alarm-clock" aria-hidden="true"></i><span>시험</span></a>                    
                </div>

                <div class="gnb-item">
                    <a href="#0" ><i class="icon-svg-calendar" aria-hidden="true"></i><span>수업일정</span></a>                    
                </div>                               		

                <div class="gnb-item">
                    <a href="#0" ><i class="icon-svg-pie-chart" aria-hidden="true"></i><span>성적관리</span></a>
                </div>
                
                <div class="gnb-item">
                    <a href="#0" ><i class="icon-svg-folder-search" aria-hidden="true"></i><span>수강현황</span></a>
                </div>

                <div class="gnb-item">
                    <a href="#0" ><i class="icon-svg-group" aria-hidden="true"></i><span>수강생정보</span></a>
                </div>

                <div class="gnb-item">
                    <a href="#0" ><i class="icon-svg-user-square" aria-hidden="true"></i><span>교수/튜터/조교정보</span></a>
                </div>

                <div class="gnb-item">
                    <a href="#0" ><i class="icon-svg-setting" aria-hidden="true"></i><span>과목설정</span></a>
                </div>

            </nav> -->
            
            <nav class="gnb_class">
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
	</aside>
	
