<%@page import="knou.lms.user.vo.UsrUserInfoVO"%>
<%@page import="java.util.List"%>
<%@page import="knou.lms.menu.vo.SysMenuVO"%>
<%@page import="knou.framework.common.MenuInfo"%>
<%@ page import="knou.framework.common.SessionInfo"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<c:set var="lnbOrgId" value="${orgId}"/>
<c:set var="lnbMenuType" value="${menuType}"/>

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
sysMenuVO.setMenuTycd(menuType);
sysMenuVO.setCrsCreCd(crsCreCd);
SysMenuVO menuInfo = MenuInfo.getMenuInfo(request, sysMenuVO);
pageContext.setAttribute("menuInfo", menuInfo);

pageContext.setAttribute("disablilityYn", SessionInfo.getDisablilityYn(request)); // 장애인여부
pageContext.setAttribute("auditYn", SessionInfo.getAuditYn(request)); // 청강생여부

pageContext.setAttribute("curParMenuCd", SessionInfo.getCurParMenuCd(request));
pageContext.setAttribute("curMenuCd", SessionInfo.getCurMenuCd(request));
%>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_lnb.css" />
<script type="text/javascript">
	$(function(){
		procBbsInfo();
		checkEnterAble();
		initClassLnbMenu();
	});
	
	var moveBbsInfo = {};
	
	function procBbsInfo() {
		var menuBbsList = $("#lnbDiv").find("ul > li[mtype='BBS']");
		
		for (var i=0; i<menuBbsList.length; i++) {
			var bbs = $(menuBbsList[i]);
			moveBbsInfo[bbs.attr("bbscd")] = [bbs.attr("bbsid"), bbs.attr("parmenucd"), bbs.attr("menucd")];
		}
	}
	

	function moveMenu(menuUrl, bbsId, bbsCd, parMenuCd, menuCd){
		
		if (menuUrl.indexOf("?") > -1) {
			menuUrl += "&param="+btoa("MENU,"+parMenuCd+","+menuCd);
		}
		else {
			menuUrl += "?param="+btoa("MENU,"+parMenuCd+","+menuCd);
		}
		
		$("#moveForm").attr("action", menuUrl);
		
		if(bbsId !== undefined){
			$("#lnbBbsId").val(bbsId);
		} else {
			$("#lnbBbsId").val("");
		}
		
		if(bbsCd !== undefined){
			$("#lnbBbsCd").val(bbsCd);
		} else {
			$("#lnbBbsCd").val("");
		}
		
		$("#moveForm").submit();
	}
</script>


<!-- main_menu 영역 부분 --> 
<nav class="gnb<%=("mobile".equals(SessionInfo.getDeviceType(request)) ? "" : " on")%>">
    <button type="button" class="menu_btn on" title="<spring:message code="common.menu" /><spring:message code="common.label.button" />" data-medi-ui="gnbmenu"><i class="ion-navicon" aria-hidden="true"></i></button>

    <div id="class_lnb" class="menu_box">

        <!-- 로고/사용자정보 -->
        <div class="top">

            <h1 class="logo">
                <a href="/dashboard/main.do" title="<spring:message code="dashboard.lms_home" />"><!-- 강의실 홈 -->
                    <img src="/webdoc/img/logo.png" alt="<spring:message code="common.logo" />">
                </a>
            </h1>

            <!-- 사용자정보 -->
            <div class="user_info">

                <!-- header 에 있던 사용자 이미지/드롭다운  위치 이동_230517-->
                <div class="user-img ui dropdown mla">
                    <div class="initial-img sm" style="min-width:35px">
	                    <%
	                  	// 사용자사진
	                  	if (!"".equals(SessionInfo.getUserPhoto(request))) {
	                  		%>
	                  		<img id="userPhoto1" src="<%=SessionInfo.getUserPhoto(request)%>" alt="user photo">
	                  		<%
	                  	}
	                  	else {
							%>
	                  		<img id="userPhoto1" src="/webdoc/img/no_user.gif" alt="user photo">
	                  		<%
	                  	}
	                  	%>
                  	</div>
                    <div class="menu">
                        <div class="item profile">
                            <div class="initial-img sm" style="min-width:35px">
			                    <%
			                  	// 사용자사진
			                  	if (!"".equals(SessionInfo.getUserPhoto(request))) {
			                  		%>
			                  		<img id="userPhoto2" src="<%=SessionInfo.getUserPhoto(request)%>" alt="user photo">
			                  		<%
			                  	}
			                  	else {
									%>
			                  		<img id="userPhoto2" src="/webdoc/img/no_user.gif" alt="user photo">
			                  		<%
			                  	}
			                  	%>
                            </div>
                            <ul>
                                <li><div style="max-width:250px;min-width:200px;word-wrap:break-word;white-space: normal;"><%= SessionInfo.getUserNm(request) %> (<%= SessionInfo.getUserId(request) %>)</div></li>
                            </ul>
                        </div>
                        <div class="divider m0"></div>
                        <%
                       	if (!SessionInfo.isVirtualLogin(request)) {
                       		List<UsrUserInfoVO> userRltnList = SessionInfo.getUserRltnList(request);
							pageContext.setAttribute("userRltnList", userRltnList);
							pageContext.setAttribute("loginOrgId", SessionInfo.getOrgId(request));
	                       	%>
	                        <div class="item"><a href="javascript:userProfilePop('<%=SessionInfo.getUserId(request)%>');" title="<spring:message code='user.title.userinfo.myinfo' />"><i class="user circle icon"></i><spring:message code='user.title.userinfo.myinfo' /></a></div>
	                        <div class="divider m0"></div>
	                        
	                        <%-- 기관 사용자 연결이 있는 경우 --%>
							<c:if test="${not empty userRltnList}">
								<c:forEach items="${userRltnList}" var="user">
									<c:if test="${loginOrgId ne user.orgId}">
										<div class="item">
											<a href="/dashboard/main.do?type=change&orgId=${user.orgId}&userId=${user.userId}" title="<spring:message code='user.title.change_user' />"><i class="user circle icon"></i>${user.orgNm} (${user.userNm})</a>
										</div>
										<div class="divider m0"></div>
									</c:if>
								</c:forEach>
							</c:if>
	                        
	                        <div class="item"><a href="/user/userHome/logout.do" onclick="localStorage.removeItem('USER_PHOTO_<%=SessionInfo.getUserId(request)%>')" title="<spring:message code='user.button.logout' />"><i class="sign-out icon"></i><spring:message code='user.button.logout' /><!-- 로그아웃 --></a></div>
	                        <%
                       	}
        	            %>
                    </div>
                    
					<script>
						// 세션에 사용자 사진이 있으면 처리
						<%
						if (!"".equals(SessionInfo.getUserPhoto(request))) {
							// 사진정보 localStorage에 저장, 세션에서 삭제
							%>
							localStorage.setItem("userPhoto_<%=SessionInfo.getUserId(request)%>", "<%=SessionInfo.getUserPhoto(request)%>");
							<%
							SessionInfo.removeUserPhoto(request);
						}
						%>
						let userPhoto = localStorage.getItem("USER_PHOTO_<%=SessionInfo.getUserId(request)%>");
						if (userPhoto != undefined && userPhoto != "") {
							$("#userPhoto1").attr("src", userPhoto);
							$("#userPhoto2").attr("src", userPhoto);
						}
					</script>
                </div>
            </div>
            <!-- //사용자정보 -->

        </div>
        <!-- //로고/사용자정보 -->

        <!-- 메뉴 영역 -->
        <div class="scrollarea">
			<form id="moveForm" method="post">
				<input type="hidden" id="crsCreCd" name="crsCreCd" value="<%=crsCreCd%>"/>
				<input type="hidden" id="lnbOrgId" value="${orgId}"/>
				<input type="hidden" id="lnbMenuType" value="${menuType}"/>
				<input type="hidden" id="lnbAuthGrpCd" value="${authGrpCd}"/>
				<input type="hidden" id="lnbCrsCreCd" value="<%=crsCreCd%>"/>
				<input type="hidden" id="lnbBbsId" name="bbsId" value=""/>
				<input type="hidden" id="lnbBbsCd" name="bbsCd" value=""/>	
			</form>

            <!-- 과목홈 메뉴 -->

            <div id="main_menu" class="menu">
                <ul id="lnbDiv">
                	<c:if test="${not empty menuInfo}">
                		<c:choose>
                			<c:when test="${fn:indexOf(menuInfo.menuUrl, '/crs/crsHome.do') > -1}">
                				<li id="${menuInfo.menuCd}"><a href="#class_lnb" class='go-home' onclick="moveMenu('${menuInfo.menuUrl}?crsCreCd=<%=crsCreCd%>',null,null,'${menuInfo.parMenuCd}','${menuInfo.menuCd}');return false;" title="${menuInfo.menuNm}"><i class='ico-home-circle-outline ico' aria-hidden='true'></i><span>${menuInfo.menuNm}</span></a></li>
                			</c:when>
                			<c:otherwise>
                				<li id="${menuInfo.menuCd}"><a href="#class_lnb" onclick="moveMenu('${menuInfo.menuUrl}' + '?crsCreCd=<%=crsCreCd%>',null,null,'${menuInfo.parMenuCd}','${menuInfo.menuCd}');return false;" title="${menuInfo.menuNm}"><i class='${menuInfo.leftMenuImg}'></i><span>${menuInfo.menuNm}</span></a></li>
                			</c:otherwise>
                		</c:choose>
                		
                		<c:if test="${not empty menuInfo.subList}">
                			<c:forEach items="${menuInfo.subList}" var="menu">
                				<c:choose>
	                				<%-- 청강생 시험, 종합성적 제외 --%>
	                				<c:when test="${auditYn == 'Y' and (menu.menuCd == 'STU0000000028' || menu.menuCd == 'STU0000000032')}">
	                				</c:when>
	                				
	                				<c:otherwise>
		                				<li id="${menu.menuCd}" class="sub-menu <c:if test="${menu.menuCd == curParMenuCd}">open</c:if>">
		                					<c:if test="${not empty menu.menuUrl and menu.menuUrl ne ''}">
		                						<a class="" href="#class_lnb" onclick="moveMenu('${menu.menuUrl}',null,null,'${menu.parMenuCd}','${menu.menuCd}');return false;" title="${menu.menuNm}"><i class='${menu.leftMenuImg}'></i><span>${menu.menuNm}</span></a>
		                					</c:if>
		                					<c:if test="${empty menu.menuUrl or menu.menuUrl eq ''}">
		                						<a class="" href="#class_lnb" title="${menu.menuNm}"><i class='${menu.leftMenuImg}'></i><span>${menu.menuNm}</span></a>
		                					</c:if>
		
			                				<c:if test="${not empty menu.subList}">
			                					<ul>
			                						<c:forEach items="${menu.subList}" var="sub">
			                							<c:choose>
			                								<%-- 비장애인 장애인지원 제외 --%>
			                								<c:when test="${disablilityYn != 'Y' and sub.menuCd == 'STU0000000043'}">
			                								</c:when>
			                								
			                								<%-- 청강생 출석현황 제외 --%>
			                								<c:when test="${auditYn == 'Y' and sub.menuCd == 'STU0000000030'}">
			                								</c:when>
			                								
			                								<%-- 학생 게시판 --%>
			                								<c:when test="${sub.menuCd == 'STU0000000009'}">
			                									<%-- (학생) 전체공지--%>
			                									<%
			                									if (SessionInfo.isKnou(request)) { // 한사대 전체공지
				                									%>
																	<li id="${sub.menuCd}D"><a href='#class_lnb' class="<c:if test="${(sub.menuCd += 'D') == curMenuCd}">active</c:if>" onclick="moveMenu('/bbs/bbsLect/atclList.do','<%=CommConst.BBS_ID_SYSTEM_NOTICE%>',null,'${sub.parMenuCd}','${sub.menuCd}D');return false;" title="${sub.menuNm}">${sub.menuNm}</a></li>
																	<%
			                									}
			                									else { // 다른기관 전체공지
			                										%>
			                										<%
			                									}
			                									%>
																
																<c:if test="${not empty menuInfo.bbsList}">
																	<c:forEach items="${menuInfo.bbsList}" var="bbs" varStatus="status" >
																		<li id="${sub.menuCd}E${status.index}" mtype="BBS" bbscd="${bbs.bbsCd}" bbsid="${bbs.bbsId}" parmenucd="${sub.parMenuCd}" menucd="${sub.menuCd}E${status.index}"><a href='#class_lnb' class="<c:if test="${(sub.menuCd += 'E' += status.index) == curMenuCd}">active</c:if>" onclick="moveMenu('/bbs/bbsLect/atclList.do','${bbs.bbsId}',null,'${sub.parMenuCd}','${sub.menuCd}E${status.index}');return false;" title="${bbs.bbsNm}">${bbs.bbsNm}</a></li>
																	</c:forEach>
																</c:if>
			                								</c:when>
			                								
			                								<%-- 교수 게시판 --%>
			                								<c:when test="${sub.menuCd == 'PRO0000000016'}">
			                									<%-- 통합게시판 --%>
			                									<li id="${sub.menuCd}A"><a href='#class_lnb' class="<c:if test="${(sub.menuCd += 'A') == curMenuCd}">active</c:if>" onclick="moveMenu('/bbs/bbsLect/atclList.do','','ALARM','${sub.parMenuCd}','${sub.menuCd}A');return false;" title="${sub.menuNm}">${sub.menuNm}</a></li>
			                									
			                									<c:if test="${not empty menuInfo.bbsList}">
																	<c:forEach items="${menuInfo.bbsList}" var="bbs" varStatus="status" >
																		<c:if test="${bbs.sysDefaultYn == 'Y'}">
																			<li id="${sub.menuCd}E${status.index}" mtype="BBS" bbscd="${bbs.bbsCd}" bbsid="${bbs.bbsId}" parmenucd="${sub.parMenuCd}" menucd="${sub.menuCd}A" class="blind"></li>
																		</c:if>
																		<c:if test="${bbs.sysDefaultYn != 'Y'}">
																			<li id="${sub.menuCd}E${status.index}"><a href='#class_lnb' class="<c:if test="${(sub.menuCd += 'E' += status.index) == curMenuCd}">active</c:if>" onclick="moveMenu('/bbs/bbsLect/atclList.do','${bbs.bbsId}',null,'${sub.parMenuCd}','${sub.menuCd}E${status.index}');return false;" title="${bbs.bbsNm}">${bbs.bbsNm}</a></li>
																		</c:if>
																	</c:forEach>
																</c:if>
			                								</c:when>
			                								
			                								<%-- 팀게시판 --%>
			                								<c:when test="${sub.menuCd == 'STU0000000015' || sub.menuCd == 'PRO0000000022' }">
																<li id="${sub.menuCd}F"><a href='#class_lnb' class="<c:if test="${(sub.menuCd += 'F') == curMenuCd}">active</c:if>" onclick="moveMenu('/bbs/bbsLect/atclList.do',null,'TEAM','${sub.parMenuCd}','${sub.menuCd}F');return false;" title="${sub.menuNm}">${sub.menuNm}</a></li>
			                								</c:when>
			                								
			                								<c:otherwise>
			                									<li id="${sub.menuCd}">
					                								<a href="#class_lnb" class="<c:if test="${sub.menuCd == curMenuCd}">active</c:if>" onclick="moveMenu('${sub.menuUrl}',null,null,'${sub.parMenuCd}','${sub.menuCd}');return false;" title="${sub.menuNm}">${sub.menuNm}</a>
					                							</li>
			                								</c:otherwise>
			                							</c:choose>
			                						</c:forEach>
			                					</ul>
			                				</c:if>
		                				</li>	                				
	                				</c:otherwise>
                				</c:choose>
                			</c:forEach>
                		</c:if>
                	</c:if>
                
                </ul>
            </div>
            <!-- //과목홈 메뉴 -->

        </div>
        <!-- //메뉴 영역 -->
            
    </div>
</nav>

<!-- 내정보 관리 팝업 --> 
<div class="modal fade" id="userProfilePop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code='user.title.userinfo.myinfo' />" aria-hidden="false">
    <div class="modal-dialog modal-md" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='user.button.close' />"><!-- 닫기 -->
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title"><spring:message code='user.title.userinfo.myinfo' /><!-- 내정보 --></h4>
            </div>
            <div class="modal-body">
                <iframe src="" id="userProfilePopIfm" name="userProfilePopIfm" width="100%" scrolling="no" title="userProfilePopIfm"></iframe>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        if ("false" == "<%=SessionInfo.isKnou(request)%>" && $("#STU0000000008").hasClass("open") != true) {
        	$("#STU0000000017").addClass("open");
        }
    });
    
 	// 내정보 관리 팝업
    function userProfilePop(userId) {
 		$("#profileForm").remove();
    	var url  = "/user/userHome/userProfilePop.do";
		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("id", "profileForm");
		form.attr("target", "userProfilePopIfm");
		form.attr("action", url);
		form.appendTo("body");
		form.submit();
		$("#userProfilePop").modal("show");
		$('iframe').iFrameResize();
    }
    
    window.closeModal = function() {
        $('.modal').modal('hide');
    };
    
    $(window).resize(function() {
        var width = $(window).width();
        
        // gnb는 기본 펼쳐진 상태_ 콘텐츠 너비를 크게 가져가서 1280 이하에서는 기본 접힌 상태로 변경함_230524 
        if (width <= 1280) {
        	if( document.querySelector(".gnb") !== null ){ 
                document.querySelector(".gnb").classList.remove("on");
                document.querySelector(".menu_btn").classList.remove("on");
                
                document.querySelector("body").classList.remove("gnbon");
            }
        }
    });
    
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
    
 	// 강의실 접속가능 여부 체크
 	function checkEnterAble() {
 		<%
		// 학생모드는 체크 안함
		if (SessionInfo.isVirtualLogin(request) == true) {
			%>
			return;
			<%
		}
		%>
		
		<%
		// 학생일 경우만 체크
		if (SessionInfo.getAuthrtGrpcd(request) != null && !SessionInfo.getAuthrtGrpcd(request).contains("USR")) {
			%>
			return;
			<%
		}
		%>
		
 		var url = "<c:url value='/crs/termHome/selectTermByCrsCreCd.do'/>";
		var param = {
			crsCreCd : '<%=crsCreCd%>'
		}
		
		ajaxCall(url, param, function(data) {
			if(data.result > 0) {
				var returnVO = data.returnVO;
				var svcStartDttm = returnVO.svcStartDttm; 	// 강의시작일
				var svcEndDttm = returnVO.svcEndDttm; 	// 복습기간이 종료일
				
				var svcStartYn = returnVO.svcStartYn; 		// 강의시작 여부
				var svcEndYn = returnVO.svcEndYn; 			// 복습기간이 종료 여부
				
				/* 강의시작일 & 복습기간이 종료일 세팅된경우만 체크 */
				
				// 강의시작 전
				if(svcStartYn == "N") {
					var svcStartDttmFmt = (svcStartDttm || "").length == 14 ? svcStartDttm.substring(0, 4) + '.' + svcStartDttm.substring(4, 6) + '.' + svcStartDttm.substring(6, 8) + ' ' + svcStartDttm.substring(8, 10) + ':' + svcStartDttm.substring(10, 12) : svcStartDttm;
					alert('<spring:message code="common.not.svc.start.dttm" arguments="' + svcStartDttmFmt + '" />'); // // '지금은 강의실에 접속할 수 없습니다. 강의시작일은 [' + svcStartDttmFmt + '] 부터입니다.';
					window.location.href = "/dashboard/main.do";
				}
				
				// 복습기간종료 후
				if(svcEndYn == "Y") {
					alert('<spring:message code="common.not.svc.end.dttm" />'); // 복습기간이 종료되었습니다.
					window.location.href = "/dashboard/main.do";
				}
        	}
			// 에러난경우 체크안함
		}, function(xhr, status, error) {
			// 에러난경우 체크안함
		});
 	}
</script>
