<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/main_default.css?v=3" />

    <body class="<%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap" class="main">
            
			<!-- class_top 인클루드  -->
			<%
			// 기관:한사대
            /* if (SessionInfo.isKnou(request)) { */
				%>
				<jsp:include page="/WEB-INF/jsp/common/frontLnb.jsp">
					<jsp:param name="coList" value="${coList}" />
				</jsp:include>
				<%
            /* } */
			%>

                <div id="container" class="ui form">
                    
                        <%@ include file="/WEB-INF/jsp/common/frontGnb.jsp" %>

							<!-- 본문 content 부분 -->
                            <main class="common">

                                <div class="col-left"> 

                                    <!-- 정보+아이콘 -->
                                    <ul class="infoIconSet" style="<%=(SessionInfo.getAuthrtGrpcd(request).contains("ADM") == true ? "_display:none" : "")%>">
                                        <li class="info bcPurpleAlpha85 <%if(!SessionInfo.isKnou(request)){%>bcPeruBlue90<%}%>">
                                            <div class="flex-item">
                                                <div class="alt_icon">
                                                    <i class="icon-calender-check ico" aria-hidden="true"></i>
                                                </div>
                                                <div class="alt_txt ">
                                                	<c:set var="lsnOdr" value="-" />
                                                   	<c:if test="${not empty dashboardCurrentWeek}">
                                                   		<c:choose>
                                                   			<c:when test="${dashboardCurrentWeek.lsnOdrMin eq dashboardCurrentWeek.lsnOdrMax}">
                                                   				<c:set var="lsnOdr" value="${dashboardCurrentWeek.lsnOdrMin}" />
                                                   			</c:when>
                                                   			<c:otherwise>
                                                   				<c:set var="lsnOdr" value="${dashboardCurrentWeek.lsnOdrMin}~${dashboardCurrentWeek.lsnOdrMax}" />
                                                   			</c:otherwise>
                                                   		</c:choose>
                                                   	
	                                                   	<fmt:parseDate var="startDtFmt" pattern="yyyyMMdd" value="${dashboardCurrentWeek.startDtMin}" />
														<fmt:formatDate var="startDt" pattern="yyyy.MM.dd" value="${startDtFmt}" />
														<fmt:parseDate var="endDtFmt" pattern="yyyyMMdd" value="${dashboardCurrentWeek.endDtMax}" />
														<fmt:formatDate var="endDt" pattern="MM.dd" value="${endDtFmt}" />
	                                                </c:if>
                                                                        	
                                                    <c:out value="${lsnOdr}"/><small class=""><spring:message code="seminar.label.schedule" /></small><!-- 주차 -->
                                                </div>
                                            </div>                                                
                                            <c:if test="${not empty dashboardCurrentWeek}">
                                            	<small class=""><c:out value="${startDt}"/> ~ <c:out value="${endDt}"/></small>
                                            </c:if>
                                        </li>
                                        <li class="info bcDarkblueAlpha85 <%if(!SessionInfo.isKnou(request)){%>bcPeruBlue70<%}%>">    
                                            <div class="flex-item">                                        
                                                <div class="alt_icon"><i class="icon-users ico " aria-hidden="true"></i></div>
                                                <div class="tooltiptext tooltip-top alertToggle flex1 flex-justify-right"><spring:message code="common.label.connect" /> <i class="ion-ios-arrow-down"></i></div><!-- 접속 -->
                                            </div>
                                            <div class="alt_txt">${userConnCnt}<span>${stdCnt}</span></div>
                                            <!-- alert_modal -->
                                            <div class="alert_modal">
                                            	<div class="flex mb5">
	                                                <div class="sort_btn mra">
	                                                	<button type="button" onclick="sortUserConnList('USER_NM')"><spring:message code="common.name" /><i class="sort amount up icon"></i></button><!-- 이름 -->
	                                                    <button type="button" onclick="sortUserConnList('USER_ID')"><spring:message code="forum.label.user.no" /><i class="sort amount up icon"></i></button><!-- 학번 -->
	                                                </div>
	                                                <%
                                                    if (SessionInfo.isKnou(request)) {
                                                      	%>
                                                      	<button type="button" onclick="allSendMsg()" class="p2 flex-item flex-none"><spring:message code="common.all.signal" /><i class="icon-bell ico" aria-hidden="true"></i></button><!-- 전체알림 -->
                                                        <%
                                                    }
                                                    %>	                                                
                                            	</div>
                                                <div class="scrollbox">
                                                    <ul class="u_list" id="userConnList">
                                                    	<c:forEach var="user" items="${userConnList}">
	                                                        <li data-conn-user-no="${user.userId}" data-conn-user-nm="${user.userNm}" data-conn-mobile-no="${user.mobileNo}" data-conn-email="${user.email}">
	                                                            <div class="initial-img sm bcLgrey">
	                                                            	<c:if test="${not empty user.phtFile}">
	                                                            		<img src="${user.phtFile}">
	                                                            	</c:if>
	                                                            	<c:if test="${empty user.phtFile}">
	                                                            		<img src="/webdoc/img/icon-hycu-symbol-grey.svg">
	                                                            	</c:if>
	                                                            </div>
	                                                            <div>
	                                                            	<span class="u_name">${user.userNm}</span>
	                                                            	<span class="fcGrey">${user.userId}</span>
	                                                            </div>
	                                                            <div class="btn_wrap">
	                                                            	<%
	                                                            	if (SessionInfo.isKnou(request)) {
		                                                            	%>
		                                                            	<button type="button" class="" onclick="viewUserInfo('${user.userId}');return false;" title="<spring:message code='common.information' /><spring:message code='exam.label.qstn.item' />"><i class="xi-info-o"></i></button><!-- 정보보기 -->
                                                          				<button type="button" class="" onclick="viewSendMsg('${user.userId}','${user.userNm}','${user.mobileNo}','${user.email}');return false;" title="<spring:message code='user.title.userinfo.manage.send' />"><i class="xi-bell-o"></i></button><!-- 메시지 발신 -->
	                                                                 	<%
	                                                            	}
                                                                 	%>
	                                                            </div>
	                                                        </li>
                                                    	</c:forEach>
                                                    </ul>
                                                </div>
                                            </div>
                                            <!-- //alert_modal -->                                                                           
                                        </li>
                                        
                                        <%
                                        if (!SessionInfo.getAuthrtGrpcd(request).contains("ADM")) {
	                                        %>
	                                        <%-- 
	                                        <li class="info">  
	                                            <div class="flex-item">                                          
	                                                <div class="alt_icon"><i class="icon-alert-triangle ico" aria-hidden="true"></i></div>
	                                                <span class="tooltiptext tooltip-top"><spring:message code="dashboard.course.risk.danager" /></span><!-- 이수위험 -->
	                                            </div>
	                                            <div class="alt_txt"><c:out value="${empty dashboardStat ? '0': dashboardStat.stdRiskCnt}"/><span><c:out value="${empty dashboardStat ? '0': dashboardStat.stdCnt}"/></span></div>
	                                            <div class="alt_txt">0<span>0</span></div>
	                                        </li>
	                                         --%>
	                                        <%
                                        }
	                                    %>

                                        <%
                                        if (SessionInfo.isKnou(request)) {
                                        	%>
	                                        <!-- 결시원 -->
	                                        <c:if test="${examAbsentPeroidYn eq 'Y'}">
		                                        <li class="info" onclick="location.href='/exam/examAbsentList.do'">
		                                        	<div class="flex-item">
		                                        		<div class="alt_icon"><i class="icon-user-no ico" aria-hidden="true"></i></div>
	                                                	<span class="tooltiptext tooltip-top"><spring:message code="exam.label.absent" /></span><!-- 결시원 -->
		                                            </div>
		                                            <div class="alt_txt"><c:out value="${empty dashboardStat ? '0': dashboardStat.examAbsentApproveCnt}"/><span><c:out value="${empty dashboardStat ? '0': dashboardStat.examAbsentCnt}"/></span></div>
		                                        </li>
	                                        </c:if>
	                                        
	                                        <!-- 성적이의신청 -->
	                                        <c:if test="${examAbsentPeroidYn eq 'Y'}">
		                                        <li class="info" onclick="location.href='/exam/examAbsentList.do'">
		                                        	<div class="flex-item">
		                                        		<div class="alt_icon"><i class="icon-user-no ico" aria-hidden="true"></i></div>
	                                                	<span class="tooltiptext tooltip-top">성적이의신청</span>
		                                            </div>
		                                            <div class="alt_txt"><c:out value="${empty dashboardStat ? '0': dashboardStat.scoreObjtProcCnt}"/><span><c:out value="${empty dashboardStat ? '0': dashboardStat.scoreObjtCnt}"/></span></div>
		                                        </li>
	                                        </c:if>
	                                        <!-- 과목명 -->
	                                        <c:forEach var="cors" items="${corsList}" varStatus="status">
		                                        <li class="info" onclick="location.href='/crs/crsHomeProf.do?crsCreCd=${cors.crsCreCd}'">
		                                        	<div class="flex-item">
		                                        		<div class="alt_icon"><i class="icon-user-no ico" aria-hidden="true"></i></div>
	                                                	<span class="tooltiptext tooltip-top">${cors.crsCreNm}</span>
		                                            </div>
		                                           <div class="alt_txt"><c:out value="${cors.stdCnt}"/><span><c:out value="50"/></span></div>
		                                        </li>
	                                        </c:forEach>
	                                        <!-- 성적재확인 -->
	                                        <c:if test="${scoreObjtPeriodYn eq 'Y'}">
		                                        <li class="info">
		                                        	<div class="flex-item">
		                                            	<div class="alt_icon"><i class="icon-user-question ico" aria-hidden="true"></i></div>
		                                            	<span class="tooltiptext tooltip-top"><spring:message code="common.label.score.reconfirm.yn" /></span><!-- 성적재확인 신청 -->
		                                            </div>
		                                            <div class="alt_txt">
		                                            	<c:choose>
		                                            		<c:when test="${not empty dashboardStat and dashboardStat.scoreObjtCnt > 0}">
		                                            			<a href="/score/scoreOverall/scoreOverallCourseMain.do" title="<spring:message code="common.label.score.reconfirm" />"><c:out value="${empty dashboardStat ? '0': dashboardStat.scoreObjtProcCnt}"/><span><c:out value="${empty dashboardStat ? '0': dashboardStat.scoreObjtCnt}"/></span></a>
		                                            		</c:when>
		                                            		<c:otherwise>
		                                            			<c:out value="${empty dashboardStat ? '0': dashboardStat.scoreObjtProcCnt}"/><span><c:out value="${empty dashboardStat ? '0': dashboardStat.scoreObjtCnt}"/></span>	
		                                            		</c:otherwise>
		                                            	</c:choose>
		                                            </div>
		                                        </li>
	                                        </c:if>

                                        	<!-- 장애인 지원 -->
											<c:if test="${dsblReqPeriodYn eq 'Y'}">
		                                        <li class="info">
		                                        	<div class="flex-item">
		                                            	<div class="alt_icon"><i class="icon-wheelchair ico" aria-hidden="true"></i></div>
		                                            	<span class="tooltiptext tooltip-top"><spring:message code="dashboard.dsbl_support" /></span><!-- 장애인 지원 -->
		                                            </div>
		                                            <div class="alt_txt"><c:out value="${empty dashboardStat ? '0': dashboardStat.examDsblReqApproveCnt}"/><span><c:out value="${empty dashboardStat ? '0': dashboardStat.examDsblReqCnt}"/></span></div>
		                                        </li>
	                                        </c:if>
                                        	<%
                                        }
                                        %>
                                    </ul>
                                    <!-- //정보+아이콘 -->
                                    <div class="component22">
                                    	<input type="hidden" id="calStartDt" value="${today }" />
                                        <div class="option-content">
                                            <div class="sec_head"><spring:message code="dashboard.cal_this_month" /> <spring:message code="dashboard.class_schedule" /></div>
                                                <div class="panel-head">
                                                    <a class="btn-prev" href="#0" onclick="moveMonth('prev');return false;"><i class="ion-ios-arrow-back"></i><span class="blind">Prev</span></a>
                                                    <div id="corCalendarMonth" class="this-month">-<small>월</small></div>
                                                    <a class="btn-next" href="#0"  onclick="moveMonth('next');return false;"><i class="ion-ios-arrow-forward"></i><span class="blind">Next</span></a>
                                                </div>
                                        </div>
                                        <ul id="corCalendar" class="">
                                        </ul>
                                        
	                                    <script type="text/javascript">
	                                    	listSchedule('course', '${today}');

		                                	// 월 이동
		                                	function moveMonth(type) {
		                                		var gubun = "";
		                                		$(".btn_area button").each(function(i, v) {
		                                			if($(v).hasClass("active")) {
		                                				gubun = $(v).attr("data-value");
		                                				return false;
		                                			}
		                                		});
		                                		gubun = gubun == "" ? "all" : gubun;
		                                		var year = $("#calStartDt").val().substring(0,4);
		                                		var month = $("#calStartDt").val().substring(4,6);
		                                		month = type == "prev" ? parseInt(month) - 1 : parseInt(month) + 1;
		                                		if(month < 1) {
		                                			month = 12;
		                                			year = parseInt(year) - 1;
		                                		} else if(month > 12) {
		                                			month = 1;
		                                			year = parseInt(year) + 1;
		                                		}
		                                		month = month < 10 ? "0" + month : month;
		                                		listSchedule(gubun, year+""+month+"01");
		                                	}
		                                	
		                                	// 일정 리스트
		                                	function listSchedule(type, startDt) {
		                                		$("#corCalendar").html("");
		                                		
		                                		startDt = startDt == undefined ? $("#calStartDt").val() : startDt;
		                                		if("${fn:substring(today,0,6)}" == startDt.substring(0,6)) {
		                                			startDt = "${today}";
		                                		}
		                                		var dt = new Date(startDt.substring(0,4), startDt.substring(4,6), 0);
		                                		var endDt = startDt.substring(0,6) + dt.getDate();
		                                		$("#calStartDt").val(startDt);
		                                		startDt = startDt.substring(0,6) + "01";

												/*
		                                		var url  = "/dashboard/profSchCalendarList.do";
		                						var data = {
		                								"searchKey"	: type,
		                								"startDt"			: startDt,
		                								"endDt"			: endDt,
		                								"termCd"		: "${dashboardVO.termCd}",
		                								"uniCd"			: "${param.uniCd}",
		                								"coList"			: "${coList}"
		                						};	                                		
												*/

		                                		var url  = "/dashboard/acadSchList.do";
		                                		var data = {
		                                	        "startDt" 	: startDt,
		                                			"endDt" 	: endDt,
		                                			"uniCd"		: "${param.uniCd}"
		                                		};
		                                		
		                                		$("#corCalendarMonth").html(parseInt(startDt.substring(4,6))+"<small>월</small>");

		                                		ajaxCall(url, data, function(data) {
		                                			if(data.result > 0) {
		                                				var returnList = data.returnList || [];
		                                        		var html = "";
		                                        		var dataMap = new Map();
		                                        		
		                                        		if(returnList.length > 0) {
		                                        			returnList.forEach(function(v, i) {
		                                        				var start = v.startDt.substring(4, 6) + "." + v.startDt.substring(6, 8);
		                                        				var end = v.endDt.substring(4, 6) + "." + v.endDt.substring(6, 8);
		                                        				var date = start == end ? start : start + " ~ " + end;
		                                        				
		                                        				/*
		                                        				html += "<li>";
	                                            				html += "	<small class='s_date'>"+date+"</small>";
	                                            				html += "	<div class='s_txt'>";
	                                            				html += "		<p class=''>"+v.title+"</p>";
	                                            				html += "		<p class='fcGrey' style='font-size:0.9em'>";
	                                            				html += "			"+v.name+"<spring:message code='crs.label.room' />";
	                                            				html += "		</p>";
	                                            				html += "	</div>";
	                                            				html += "</li>";
	                                            				*/

																html += "<li>";
	                                            				html += "	<small class='s_date'>"+date+"</small>";
	                                            				html += "	<div class='s_txt'>";
	                                            				html += "		<p class=''>"+v.title+"</p>";
	                                            				html += "	</div>";
	                                            				html += "</li>";
		                                        			});
		                                        			$("#corCalendar").html(html);
		                                        		} else {
		                            	        			html += "<li class='p_h100'><div class='flex-container min-height-auto'>";
		                            	        			html += "<div class='cont-none'><i class='icon-list-no ico'></i><span><spring:message code='common.content.not_found'/></span></div>";
		                            	        			html += "</div></li>";
		                            	        			
		                            	        			$("#corCalendar").html(html);
		                                        		}
		                                        	} else {
		                                        		//alert(data.message);
		                                        	}
		                                		}, function(xhr, status, error) {
		                                			/* 에러가 발생했습니다! */
		                                			alert("<spring:message code='fail.common.msg' /> [schedule]");
		                                		}, false);
		                                	}
	                                    </script>
                                        
                                    </div>
                                    <!-- //교수_일정_230517 -->
                                </div>

                                <div class="mainCnt">

                                    <!-- 공지글 -->
                                    <div class="component33 off" data-medi-ui="more-off" data-ctrl-off="더보기">

                                        <!-- 탭메뉴 -->
                                        <div class="listTab2 noti" data-target="tab_contents1">
                                        	<div data-target="#tab1" class="active">
                                        		<c:choose>
	                                        		<c:when test="${isKnou eq 'true'}"><spring:message code="dashboard.notice_all"/><!-- 전체공지 --></c:when>
	                                        		<c:otherwise><spring:message code="dashboard.notice_course"/><!-- 강의공지 --></c:otherwise>
	                                        	</c:choose>
                                       		</div>
                                            <div data-target="#tab2">
                                            	<c:choose>
	                                        		<c:when test="${isKnou eq 'true'}"><spring:message code="dashboard.notice_course"/><!-- 강의공지 --></c:when>
	                                        		<c:otherwise><spring:message code="dashboard.notice_all"/><!-- 전체공지 --></c:otherwise>
	                                        	</c:choose>
                                           	</div>
                                            <div data-target="#tab3"><spring:message code="dashboard.course_qna"/><span class="msg_num">${not empty qnaNoAnsInfo ? qnaNoAnsInfo.noAnsCnt : 0}</span></div><%-- 강의 Q&A --%>
                                            <div data-target="#tab4"><spring:message code="dashboard.councel"/><span class="msg_num">${not empty secretNoAnsInfo ? secretNoAnsInfo.noAnsCnt : 0}</span></div><%-- 1:1 상담 --%>
                                            <div data-target="#tab5">ALL</div><%-- ALL --%>
                                        </div>  
                                        <!-- //탭메뉴 -->

                                        <!-- 탭메뉴_콘텐츠 -->
                                        <div class="tab_contents1"> 
                                            <div id="tab1" class="tab_content on">
                                                <c:choose>
                                                	<c:when test="${isKnou eq 'true'}">
                                                		<div class="cont_header">
		                                                    <button class="btn-icon more" aria-label="<spring:message code="common.label.view.more" />" onclick="document.location.href='/bbs/bbsHome/atclList.do?bbsId=${sysNoticeId}&uniCd=${param.uniCd}';" title="<spring:message code="common.label.view.more" />"><i class="ion-plus"></i></button>
		                                                </div>
                                                		<c:if test="${not empty sysNoticeList}">
			                                                <div class="cont_body">
			                                                    <ul class="list_line_S2">
			                                                        <c:forEach var="notice" items="${sysNoticeList}" varStatus="status">
			                                                        	<c:if test="${status.index < 4}">
			                                                        	<li>
				                                                            <a href="/bbs/bbsHome/Form/atclView.do?bbsId=${notice.bbsId}&atclId=${notice.atclId}">
			                                                                    <div class="n_tit <c:if test="${notice.viewYn eq 'Y'}">opacity7</c:if>">
			                                                                        <p class="head">
			                                                                            <span><c:out value="${notice.atclTitle}"/></span>
			                                                                            <c:if test="${notice.isNew eq 'Y' and notice.viewYn ne 'Y'}">
																							<i class="ui pink circular mini label f060"></i>
																						</c:if>
			                                                                        </p>
			                                                                    </div>
			
			                                                                    <div class="n_date">
			                                                                        <small><spring:message code="bbs.label.view" /> : <c:out value="${notice.hits}"/></small>
				                                                                    <small><uiex:formatDate value="${notice.regDttm}" type="date"/></small>
			                                                                    </div>
			                                                                </a>
			                                                            </li>
			                                                            </c:if>
			                                                       	</c:forEach>
			                                                    </ul>
			                                                </div>
			                                            </c:if>
		                                                <c:if test="${empty sysNoticeList}">
		                                                 	<div class="flex-container">
		                                                 		<!-- 등록된 내용이 없습니다. -->
		                                                 		<div class="cont-none"><i class="icon-list-no ico"></i><span><spring:message code="common.content.not_found"/></span></div>
		                                                 	</div>
		                                                </c:if>
                                                	</c:when>
                                                	<c:otherwise>
                                                		<div class="cont_header"></div>
                                                		<c:if test="${not empty cosNoticeList}">
			                                                <div class="cont_body">
			                                                    <ul class="list_line_S2">
			                                                    	<c:forEach var="notice" items="${cosNoticeList}" varStatus="status">
				                                                    	<c:if test="${status.index < 4}">
				                                                     	<li>
				                                                             <a href="javascript:moveCrs('/bbs/bbsLect/Form/atclView.do?crsCreCd=${notice.crsCreCd}&bbsId=${notice.bbsId}&atclId=${notice.atclId}')" title="<c:out value="${notice.atclTitle}"/>">
				                                                                 <div class="n_tit <c:if test="${notice.viewYn eq 'Y'}">opacity7</c:if>">
				                                                                     <p class="head">
				                                                                         <span><c:out value="${notice.atclTitle}"/></span>
				                                                                         <c:if test="${notice.isNew eq 'Y' and notice.viewYn ne 'Y'}">
																				    	<i class="ui pink circular mini label f060"></i>
																						</c:if>
				                                                                     </p>
				                                                                     <span class="sub"><c:out value="${notice.crsCreNm}"/> (<c:out value="${notice.declsNo}"/>반)</span>
				                                                                 </div>
				
				                                                                 <div class="n_date">
				                                                                     <small><spring:message code="bbs.label.view" /> : <c:out value="${notice.hits}"/></small>
				                                                                     <small><uiex:formatDate value="${notice.regDttm}" type="date"/></small>
				                                                                 </div>
				                                                             </a>
				                                                         </li>
				                                                         </c:if>
			                                                    	</c:forEach>
			                                                    </ul>
			                                                </div>
		                                                </c:if>
		                                                <c:if test="${empty cosNoticeList}">
		                                                	<div class="flex-container">
		                                                		<!-- 등록된 내용이 없습니다. -->
		                                                		<div class="cont-none"><i class="icon-list-no ico"></i><span><spring:message code="common.content.not_found"/></span></div>
		                                                	</div>
		                                                </c:if>
                                                	</c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div id="tab2" class="tab_content">
                                                <c:choose>
                                                	<c:when test="${isKnou eq 'true'}">
                                                		<div class="cont_header"></div>
                                                		<c:if test="${not empty cosNoticeList}">
			                                                <div class="cont_body">
			                                                    <ul class="list_line_S2">
			                                                    	<c:forEach var="notice" items="${cosNoticeList}" varStatus="status">
				                                                    	<c:if test="${status.index < 4}">
				                                                     	<li>
				                                                             <a href="javascript:moveCrs('/bbs/bbsLect/Form/atclView.do?crsCreCd=${notice.crsCreCd}&bbsId=${notice.bbsId}&atclId=${notice.atclId}')" title="<c:out value="${notice.atclTitle}"/>">
				                                                                 <div class="n_tit <c:if test="${notice.viewYn eq 'Y'}">opacity7</c:if>">
				                                                                     <p class="head">
				                                                                         <span><c:out value="${notice.atclTitle}"/></span>
				                                                                         <c:if test="${notice.isNew eq 'Y' and notice.viewYn ne 'Y'}">
																				    	<i class="ui pink circular mini label f060"></i>
																						</c:if>
				                                                                     </p>
				                                                                     <span class="sub"><c:out value="${notice.crsCreNm}"/> (<c:out value="${notice.declsNo}"/>반)</span>
				                                                                 </div>
				
				                                                                 <div class="n_date">
				                                                                     <small><spring:message code="bbs.label.view" /> : <c:out value="${notice.hits}"/></small>
				                                                                     <small><uiex:formatDate value="${notice.regDttm}" type="date"/></small>
				                                                                 </div>
				                                                             </a>
				                                                         </li>
				                                                         </c:if>
			                                                    	</c:forEach>
			                                                    </ul>
			                                                </div>
		                                                </c:if>
		                                                <c:if test="${empty cosNoticeList}">
		                                                	<div class="flex-container">
		                                                		<!-- 등록된 내용이 없습니다. -->
		                                                		<div class="cont-none"><i class="icon-list-no ico"></i><span><spring:message code="common.content.not_found"/></span></div>
		                                                	</div>
		                                                </c:if>
                                                	</c:when>
                                                	<c:otherwise>
                                                		<div class="cont_header">
		                                                    <button class="btn-icon more" aria-label="<spring:message code="common.label.view.more" />" onclick="document.location.href='/bbs/bbsHome/atclList.do?bbsId=${sysNoticeId}&uniCd=${param.uniCd}';" title="<spring:message code="common.label.view.more" />"><i class="ion-plus"></i></button>
		                                                </div>
                                                		<c:if test="${not empty sysNoticeList}">
			                                                <div class="cont_body">
			                                                    <ul class="list_line_S2">
			                                                        <c:forEach var="notice" items="${sysNoticeList}" varStatus="status">
			                                                        	<c:if test="${status.index < 4}">
			                                                        	<li>
				                                                            <a href="/bbs/bbsHome/Form/atclView.do?bbsId=${notice.bbsId}&atclId=${notice.atclId}">
			                                                                    <div class="n_tit <c:if test="${notice.viewYn eq 'Y'}">opacity7</c:if>">
			                                                                        <p class="head">
			                                                                            <span><c:out value="${notice.atclTitle}"/></span>
			                                                                            <c:if test="${notice.isNew eq 'Y' and notice.viewYn ne 'Y'}">
																							<i class="ui pink circular mini label f060"></i>
																						</c:if>
			                                                                        </p>
			                                                                    </div>
			
			                                                                    <div class="n_date">
			                                                                        <small><spring:message code="bbs.label.view" /> : <c:out value="${notice.hits}"/></small>
				                                                                    <small><uiex:formatDate value="${notice.regDttm}" type="date"/></small>
			                                                                    </div>
			                                                                </a>
			                                                            </li>
			                                                            </c:if>
			                                                       	</c:forEach>
			                                                    </ul>
			                                                </div>
			                                            </c:if>
		                                                <c:if test="${empty sysNoticeList}">
		                                                 	<div class="flex-container">
		                                                 		<!-- 등록된 내용이 없습니다. -->
		                                                 		<div class="cont-none"><i class="icon-list-no ico"></i><span><spring:message code="common.content.not_found"/></span></div>
		                                                 	</div>
		                                                </c:if>
                                                	</c:otherwise>
                                               	</c:choose>
                                            </div>
											<div id="tab3" class="tab_content">
                                            	<div class="cont_header"></div>
                                            	<c:if test="${not empty cosQnaList}">
                                                	<div class="cont_body">
	                                                   <ul class="list_line_S2">
	                                                   	<c:forEach var="notice" items="${cosQnaList}" varStatus="status">
	                                                   		<c:if test="${status.index < 4}">
	                                                    	<li>
	                                                            <a href="javascript:moveCrs('/bbs/bbsLect/Form/atclView.do?crsCreCd=${notice.crsCreCd}&bbsId=${notice.bbsId}&atclId=${notice.atclId}')" title="<c:out value="${notice.atclTitle}"/>">
	                                                                <div class="n_tit <c:if test="${notice.viewYn eq 'Y'}">opacity7</c:if>">
	                                                                    <p class="head">
	                                                                        <span><c:out value="${notice.atclTitle}"/></span>
	                                                                        <c:if test="${notice.isNew eq 'Y' and notice.viewYn ne 'Y'}">
																			    <i class="ui pink circular mini label f060"></i>
																			</c:if>
	                                                                    </p>
	                                                                    <span class="sub"><c:out value="${notice.crsCreNm}"/> (<c:out value="${notice.declsNo}"/>반)</span>
	                                                                </div>
	
	                                                                <div class="n_date">
	                                                                	<c:choose >
				                                                            <c:when test="${notice.answerYn eq 'Y'}">
																	            <small class="ui green small label"><spring:message code="dashboard.qna.answer"/><!-- 답변 --></small>
																	        </c:when>
																	        <c:otherwise>
																	            <small class="ui orange small label"><spring:message code="dashboard.qna.wait"/><!-- 미답변 --></small>
																	        </c:otherwise>
	                                                                	</c:choose>
	                                                                    <small><uiex:formatDate value="${notice.regDttm}" type="date"/></small>
	                                                                </div>
	                                                            </a>
	                                                        </li>
	                                                        </c:if>
	                                                   	</c:forEach>
													</ul>
												</div>
												</c:if>
												<c:if test="${empty cosQnaList}">
                                                 	<div class="flex-container">
                                                 		<!-- 등록된 내용이 없습니다. -->
                                                 		<div class="cont-none"><i class="icon-list-no ico"></i><span><spring:message code="common.content.not_found"/></span></div>
													</div>
												</c:if>
                                            </div>
                                            <div id="tab4" class="tab_content">
                                            	<c:if test="${not empty cosSecretList}">
                                                <div class="cont_body">
                                                    <ul class="list_line_S2">
                                                    <c:set var="secretViewYn">
	                                            		<%=(SessionInfo.getAuthrtCd(request).contains("TUT") == true ? "N" : "Y") %>
	                                            	</c:set>
                                                   	<c:forEach var="notice" items="${cosSecretList}" varStatus="status">
                                                   		<c:if test="${status.index < 4}">
                                                     	<li>
                                                     		<c:choose>
                                                     			<c:when test="${secretViewYn eq 'Y'}">
                                                     		<a href="javascript:moveCrs('/bbs/bbsLect/Form/atclView.do?crsCreCd=${notice.crsCreCd}&bbsId=${notice.bbsId}&atclId=${notice.atclId}')" title="<c:out value="${notice.atclTitle}"/>">
                                                     			</c:when>
                                                     			<c:otherwise>
                                                     		<a href="javascript:alert('<spring:message code="bbs.alert.no.auth.atcl"/>')" title="<c:out value="${notice.atclTitle}"/>">	
                                                     			</c:otherwise>
                                                     		</c:choose>
                                                                 <div class="n_tit <c:if test="${notice.viewYn eq 'Y'}">opacity7</c:if>">
                                                                     <p class="head">
                                                                         <span><c:out value="${notice.atclTitle}"/></span>
                                                                         <c:if test="${notice.isNew eq 'Y' and notice.viewYn ne 'Y'}">
																    	<i class="ui pink circular mini label f060"></i>
																		</c:if>
                                                                     </p>
                                                                     <span class="sub"><c:out value="${notice.crsCreNm}"/> (<c:out value="${notice.declsNo}"/>반)</span>
                                                                 </div>

                                                                 <div class="n_date">
                                                                 	<c:choose >
	                                                                  	<c:when test="${notice.answerYn eq 'Y'}">
																            <small class="ui green small label"><spring:message code="dashboard.qna.answer"/><!-- 답변 --></small> 
																        </c:when>
																        <c:otherwise>
																            <small class="ui orange small label"><spring:message code="dashboard.qna.wait"/><!-- 미답변 --></small>
																        </c:otherwise>
	                                                                </c:choose>
                                                                     <small><uiex:formatDate value="${notice.regDttm}" type="date"/></small>
                                                                 </div>
                                                             </a>
                                                         </li>
                                                         </c:if>
                                                   	</c:forEach>
                                                    </ul>
                                                </div>
                                            	</c:if>
                                            	<c:if test="${empty cosSecretList}">
                                                 	<div class="flex-container">
                                                 		<!-- 등록된 내용이 없습니다. -->
                                                 		<div class="cont-none"><i class="icon-list-no ico"></i><span><spring:message code="common.content.not_found"/></span></div>
                                                 	</div>
                                                 </c:if>
                                            </div>
                                            <div id="tab5" class="tab_content">
                                            	<c:choose>
                                                	<c:when test="${isKnou eq 'true'}">
                                                		<div class="cont_header">
		                                                    <button class="btn-icon more" aria-label="<spring:message code="common.label.view.more" />" onclick="document.location.href='/bbs/bbsHome/atclList.do?bbsId=${sysNoticeId}&uniCd=${param.uniCd}';" title="<spring:message code="common.label.view.more" />"><i class="ion-plus"></i></button>
		                                                </div>
                                                		<c:if test="${not empty allNoticeList}">
			                                                <div class="cont_body">
			                                                    <ul class="list_line_S2">
			                                                        <c:forEach var="notice" items="${allNoticeList}" varStatus="status">
			                                                        	<c:if test="${status.index < 4}">
			                                                        	<li>
				                                                            <a href="/bbs/bbsHome/Form/atclView.do?bbsId=${notice.bbsId}&atclId=${notice.atclId}">
			                                                                    <div class="n_tit <c:if test="${notice.viewYn eq 'Y'}">opacity7</c:if>">
			                                                                        <p class="head">
			                                                                            <span><c:out value="${notice.atclTitle}"/></span>
			                                                                            <c:if test="${notice.isNew eq 'Y' and notice.viewYn ne 'Y'}">
																							<i class="ui pink circular mini label f060"></i>
																						</c:if>
			                                                                        </p>
			                                                                    </div>
			
			                                                                    <div class="n_date">
			                                                                        <small><spring:message code="bbs.label.view" /> : <c:out value="${notice.hits}"/></small>
				                                                                    <small><uiex:formatDate value="${notice.regDttm}" type="date"/></small>
			                                                                    </div>
			                                                                </a>
			                                                            </li>
			                                                            </c:if>
			                                                       	</c:forEach>
			                                                    </ul>
			                                                </div>
			                                            </c:if>
		                                                <c:if test="${empty allNoticeList}">
		                                                 	<div class="flex-container">
		                                                 		<!-- 등록된 내용이 없습니다. -->
		                                                 		<div class="cont-none"><i class="icon-list-no ico"></i><span><spring:message code="common.content.not_found"/></span></div>
		                                                 	</div>
		                                                </c:if>
                                                	</c:when>
                                                	<c:otherwise>
                                                		<div class="cont_header"></div>
                                                		<c:if test="${not empty cosNoticeList}">
			                                                <div class="cont_body">
			                                                    <ul class="list_line_S2">
			                                                    	<c:forEach var="notice" items="${cosNoticeList}" varStatus="status">
				                                                    	<c:if test="${status.index < 4}">
				                                                     	<li>
				                                                             <a href="javascript:moveCrs('/bbs/bbsLect/Form/atclView.do?crsCreCd=${notice.crsCreCd}&bbsId=${notice.bbsId}&atclId=${notice.atclId}')" title="<c:out value="${notice.atclTitle}"/>">
				                                                                 <div class="n_tit <c:if test="${notice.viewYn eq 'Y'}">opacity7</c:if>">
				                                                                     <p class="head">
				                                                                         <span><c:out value="${notice.atclTitle}"/></span>
				                                                                         <c:if test="${notice.isNew eq 'Y' and notice.viewYn ne 'Y'}">
																				    	<i class="ui pink circular mini label f060"></i>
																						</c:if>
				                                                                     </p>
				                                                                     <span class="sub"><c:out value="${notice.crsCreNm}"/> (<c:out value="${notice.declsNo}"/>반)</span>
				                                                                 </div>
				
				                                                                 <div class="n_date">
				                                                                     <small><spring:message code="bbs.label.view" /> : <c:out value="${notice.hits}"/></small>
				                                                                     <small><uiex:formatDate value="${notice.regDttm}" type="date"/></small>
				                                                                 </div>
				                                                             </a>
				                                                         </li>
				                                                         </c:if>
			                                                    	</c:forEach>
			                                                    </ul>
			                                                </div>
		                                                </c:if>
		                                                <c:if test="${empty cosNoticeList}">
		                                                	<div class="flex-container">
		                                                		<!-- 등록된 내용이 없습니다. -->
		                                                		<div class="cont-none"><i class="icon-list-no ico"></i><span><spring:message code="common.content.not_found"/></span></div>
		                                                	</div>
		                                                </c:if>
                                                	</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <!-- //탭메뉴_콘텐츠 -->
                                            
                                    </div>
                                    <!-- //공지글 -->
<%--                                  	<%
									// 기관:한사대만 메시지 표시
							        if (SessionInfo.isKnou(request)) {
					           		%>   
                                    <!-- PUSH/쪽지 글목록 -->
                                    <div id="stuDashMsgDiv" class="component55 p2" style="overflow: hidden;">
	                                    <div class="menu">
	                                    	<div class=" ui pointing secondary tabmenu tMenubar ml8 mr8 flex">
												<a class="tmItem active" data-dash-tab="PUSH">PUSH<small class="msg_num" id="dashPushCount">0</small></a>
												<a class="tmItem" data-dash-tab="SMS">SMS<small class="msg_num" id="dashSmsCount">0</small></a><!-- SMS -->
												<a class="tmItem" data-dash-tab="MSG"><spring:message code="exam.button.eval.msg" /><small class="msg_num" id="dashMsgCount">0</small></a><!-- 쪽지 -->
												<a class="tmItem" data-dash-tab="TALK">알림톡<small class="msg_num" id="dashTalkCount">0</small></a><!-- 알림톡 -->
											</div>
	                                    </div>
                                    	<div class="p8 ui tab active" id="dashPushList" style="height: 100%;">
											<div class="flex-container m-hAuto">
												<div class="no_content">
													<span><spring:message code='common.message.sysmsg.alt4'/></span><!-- 수신한 메시지가 없습니다. -->
													<a href="javascript:stuDashMsg.moveMsgList('P')" class="ui basic small button mt5"><spring:message code="common.button.viewMsgBox"/></a>
												</div>
											</div>
										</div>
										<div class="p8 ui tab" id="dashSmsList" style="height: 100%;">
											<div class="flex-container m-hAuto">
												<div class="no_content">
													<span><spring:message code='common.message.sysmsg.alt4'/></span><!-- 수신한 메시지가 없습니다. -->
													<a href="javascript:stuDashMsg.moveMsgList('S')" class="ui basic small button mt5"><spring:message code="common.button.viewMsgBox"/></a>
												</div>
											</div>
										</div>
										<div class="p8 ui tab" id="dashMsgList" style="height: 100%;">
											<div class="flex-container m-hAuto">
												<div class="no_content">
													<span><spring:message code='common.message.sysmsg.alt4'/></span><!-- 수신한 메시지가 없습니다. -->
													<a href="javascript:stuDashMsg.moveMsgList('N')" class="ui basic small button mt5"><spring:message code="common.button.viewMsgBox"/></a>
												</div>
											</div>
										</div>
										<div class="p8 ui tab" id="dashTalkList" style="height: 100%;">
											<div class="flex-container m-hAuto">
												<div class="no_content">
													<span><spring:message code='common.message.sysmsg.alt4'/></span><!-- 수신한 메시지가 없습니다. -->
													<a href="javascript:stuDashMsg.moveMsgList('T')" class="ui basic small button mt5"><spring:message code="common.button.viewMsgBox"/></a>
												</div>
											</div>
										</div>
                                    </div>
                                    <script type="text/javascript">
		                                $(document).ready(function() {
	                                		stuDashMsg.init();
		                            	});
		                                
		                                var stuDashMsg = {
		                                	isTabLoad: false,
		                                	init: function() {
		                                		// 대시보드 메세지 탭 이벤트 설정
		                                		$("[data-dash-tab]").off("click").on("click", function() {
			                                		var dashTab = $(this).data("dashTab");
			                                		
			                                		if(dashTab == "PUSH") {
			                                			$("#dashPushList").show();
			                                			$("#dashMsgList").hide();
			                                			$("#dashSmsList").hide();
			                                			$("#dashTalkList").hide();
			                                		} else if(dashTab == "MSG") {
			                                			$("#dashMsgList").show();
			                                			$("#dashPushList").hide();
			                                			$("#dashSmsList").hide();
			                                			$("#dashTalkList").hide();
			                                		} else if(dashTab == "SMS") {
			                                			$("#dashSmsList").show();
			                                			$("#dashPushList").hide();
			                                			$("#dashMsgList").hide();
			                                			$("#dashTalkList").hide();
			                                		} else if(dashTab == "TALK") {
			                                			$("#dashTalkList").show();
			                                			$("#dashPushList").hide();
			                                			$("#dashMsgList").hide();
			                                			$("#dashSmsList").hide();
			                                		}
			                                		
			                                		$("[data-dash-tab]").removeClass("active")
			                                		$(this).addClass("active");
			                                		
			                                		stuDashMsg.reloadMsg(true);
			                                	});
		                                		
		                                		// frontLnb 메세지 조회후 실행 등록
		                                		if(typeof sysmsgSubFnObj != "undefined") {
			                                		sysmsgSubFnObj["syncDashSysmsg"] = function() {
			                                			// frontLnb 메세지 조회값
			                                			if(typeof getSysmsgStore === "function") {
			                                				getSysmsgStore().done(function(msgStoreObj) {
			                                					stuDashMsg.setPushTab(msgStoreObj["pushList"]);
			                                					stuDashMsg.setMsgTab(msgStoreObj["msgList"]);
			                                					stuDashMsg.setSmsTab(msgStoreObj["smsList"]);
			                                					stuDashMsg.setTalkTab(msgStoreObj["talkList"]);
					                                		});
			                                			}
		                                			}
			                                	}
		                                		
		                                		setTimeout(function() {
		                                			if(!stuDashMsg.isTabLoad) {
		                                				stuDashMsg.reloadMsg(false);
			                                		}
												}, 0);
		                                	},
		                                	createEmptyHtml: function(type) {
		                                		var html = '';
		                                		html += '<div class="flex-container m-hAuto">';
		                                		html += '	<div class="no_content">';
		                                		html += '		<span><spring:message code="common.message.sysmsg.alt4" /></span>'; // 수신한 메시지가 없습니다.
		                                		html += '		<a href="javascript:stuDashMsg.moveMsgList(\'' + type + '\')" class="ui basic small button mt5"><spring:message code="common.button.viewMsgBox"/></a>'; // 수신함 보기
			                                	html += '	</div>';
			                                	html += '</div>';
			                                	return html;
		                                	},
		                                	reloadMsg: function() {
		                                		// frontLnb 통합메시지 가져오기
		                                		if(typeof getSysMsg != "undefined") {
		                                			getSysMsg(true);
		                                		}
		                                	},
		                                	moveMsgList: function(type) {
		                                		// frontLnb 통합메시지 이동
		                                		if(typeof goSysmsgList != "undefined") {
		                                			goSysmsgList(type);
		                                		}
		                                	},
		                                	setPushTab: function(pushList) {
		                                		var pushList = pushList || [];
		                                		
		                                		var unreadCount = 0;
		                                		
		                                		pushList.forEach(function(v, i) {
			                                		if(v.readYn == "N") {
			                                			unreadCount++;
			                                		}
			                                	});
		                                		
		                                		var list = pushList.slice(0, 4);
		                                		var html = '';
		                                		
		                                		if(list.length > 0) {
		                                			html += '<div class="ui segment p5" style="height: 100%">';
			                                		list.forEach(function(v, i) {
				                                		html += '<div class="item flex-row p8 ' + (v.readYn == "N" ? "" : "opacity7") + '">';
				                                		html += '	<div class="flex overflow-hidden">';
				                                		html += '		<a href="javascript:stuDashMsg.moveMsgList(\'P\')" class="f100 overflow-hidden" title="<spring:message code="common.label.view" />">'; // 내용보기
				                                		html += '			<p class="item-title mb5 text-truncate">' + v.subject + '</p>';
				                                		html += '			<small class="f080">' + v.sendDttm + '</small>';
				                                		html += '		</a>';
				                                		html += '	</div>';
				                                		html += '</div>';
			                                		});
			                                		html += '</div>';
		                                		} else {
		                                			html = this.createEmptyHtml('P');
		                                		}
		                                		
		                                		$("#dashPushList").html(html);
		                                		$("#dashPushCount").text(unreadCount);
		                                		
		                                		this.isTabLoad = true;
		                                	},
		                                	setMsgTab: function(msgList) {
		                                		var msgList = msgList || [];
												var unreadCount = 0;
		                                		
												msgList.forEach(function(v, i) {
			                                		if(v.readYn == "N") {
			                                			unreadCount++;
			                                		}
			                                	});
		                                		
		                                		var list = msgList.slice(0, 4);
		                                		var html = '';
		                                		
		                                		if(list.length > 0) {
		                                			html += '<div class="ui segment p5" style="height: 100%">';
			                                		list.forEach(function(v, i) {
				                                		html += '<div class="item flex-row p8 ' + (v.readYn == "N" ? "" : "opacity7") + '">';
				                                		html += '	<div class="flex overflow-hidden">';
				                                		html += '		<a href="javascript:stuDashMsg.moveMsgList(\'N\')" class="f100 overflow-hidden" title="<spring:message code="common.label.view" />">'; // 내용보기
				                                		html += '			<p class="item-title mb5 text-truncate">' + v.ctnt + '</p>';
				                                		html += '			<small class="f080">' + v.sendDttm + '</small>';
				                                		html += '		</a>';
				                                		html += '	</div>';
				                                		html += '</div>';
				                                	});
				                                	html += '</div>';
		                                		} else {
		                                			html = this.createEmptyHtml('N');
		                                		}
		                                		
		                                		$("#dashMsgList").html(html);
		                                		$("#dashMsgCount").text(unreadCount);
		                                		
		                                		this.isTabLoad = true;
		                                	},
		                                	setSmsTab: function(smsList) {
		                                		var smsList = smsList || [];
												var unreadCount = 0;
		                                		
												smsList.forEach(function(v, i) {
			                                		if(v.readYn == "N") {
			                                			unreadCount++;
			                                		}
			                                	});
		                                		
		                                		var list = smsList.slice(0, 4);
		                                		var html = '';
		                                		
		                                		if(list.length > 0) {
		                                			html += '<div class="ui segment p5" style="height: 100%">';
			                                		list.forEach(function(v, i) {
				                                		html += '<div class="item flex-row p8 ' + (v.readYn == "N" ? "" : "opacity7") + '">';
				                                		html += '	<div class="flex overflow-hidden">';
				                                		html += '		<a href="javascript:stuDashMsg.moveMsgList(\'S\')" class="f100 overflow-hidden" title="<spring:message code="common.label.view" />">'; // 내용보기
				                                		html += '			<p class="item-title mb5 text-truncate">' + v.ctnt + '</p>';
				                                		html += '			<small class="f080">' + v.sendDttm + '</small>';
				                                		html += '		</a>';
				                                		html += '	</div>';
				                                		html += '</div>';
				                                	});
				                                	html += '</div>';
		                                		} else {
		                                			html = this.createEmptyHtml('S');
		                                		}
		                                		
		                                		$("#dashSmsList").html(html);
		                                		$("#dashSmsCount").text(unreadCount);
		                                		
		                                		this.isTabLoad = true;
		                                	},
		                                	setTalkTab: function(talkList) {
		                                		var talkList = talkList || [];
												var unreadCount = 0;
		                                		
												talkList.forEach(function(v, i) {
			                                		if(v.readYn == "N") {
			                                			unreadCount++;
			                                		}
			                                	});
		                                		
		                                		var list = talkList.slice(0, 4);
		                                		var html = '';
		                                		
		                                		if(list.length > 0) {
		                                			html += '<div class="ui segment p5" style="height: 100%">';
			                                		list.forEach(function(v, i) {
				                                		html += '<div class="item flex-row p8 ' + (v.readYn == "N" ? "" : "opacity7") + '">';
				                                		html += '	<div class="flex overflow-hidden">';
				                                		html += '		<a href="javascript:stuDashMsg.moveMsgList(\'T\')" class="f100 overflow-hidden" title="<spring:message code="common.label.view" />">'; // 내용보기
				                                		html += '			<p class="item-title mb5 text-truncate">' + v.ctnt + '</p>';
				                                		html += '			<small class="f080">' + v.sendDttm + '</small>';
				                                		html += '		</a>';
				                                		html += '	</div>';
				                                		html += '</div>';
				                                	});
				                                	html += '</div>';
		                                		} else {
		                                			html = this.createEmptyHtml('T');
		                                		}
		                                		
		                                		$("#dashTalkList").html(html);
		                                		$("#dashTalkCount").text(unreadCount);
		                                		
		                                		this.isTabLoad = true;
		                                	}
		                                }
	                                </script>
	                                <style>
	                                	@media (max-width: 767px) {
										    #stuDashMsgDiv {
										    	display: none;
										    }
										}
	                                </style>
	                                <!-- PUSH/쪽지 글목록 -->
                                    <%
						        }
						        %> --%>
                                 	<%
									// 기관:한사대만 메시지 표시
							        if (SessionInfo.isKnou(request)) {
					           		%>   
                                    <!-- PUSH/쪽지 글목록 -->
                                    <div id="stuDashMsgDiv" class="component55 p2" style="overflow: hidden;">
	                                    <div class="menu">
	                                    	<div class=" ui pointing secondary tabmenu tMenubar ml8 mr8 flex">
												<a class="tmItem active" data-dash-tab="Push">PUSH<small class="msg_num" id="dashPushCount">0</small></a>
												<a class="tmItem" data-dash-tab="Sms">SMS<small class="msg_num" id="dashSmsCount">0</small></a><!-- SMS -->
												<a class="tmItem" data-dash-tab="Msg"><spring:message code="exam.button.eval.msg" /><small class="msg_num" id="dashMsgCount">0</small></a><!-- 쪽지 -->
												<a class="tmItem" data-dash-tab="Talk">알림톡<small class="msg_num" id="dashTalkCount">0</small></a><!-- 알림톡 -->
											</div>
	                                    </div>
                                    	<div class="p8 ui tab active dash-tab-content" id="dashPushList" style="height: 100%;">
	                                    	<c:if test="${not empty pushList}">
	                                    		<c:forEach var="push" items="${pushList}" varStatus="status">
	                                    			<c:if test="${status.index < 4}">
	                                    			<div class="item flex-row p8 <c:if test="${push.readYn eq 'Y' }" >opacity7</c:if>">
					                                	<div class="flex overflow-hidden">
					                                		<a href="javascript:stuDashMsg.moveMsgList('P')" class="f100 overflow-hidden" title="<spring:message code="common.label.view" />">
					                                			<p class="item-title mb5 text-truncate"><c:out value="${push.contents}"/></p>
					                                			<!-- <small class="f080">v.sendDttm</small> -->
					                                		</a>
					                                	</div>
					                                </div>
				                                	</c:if>
			                                	</c:forEach>
											</c:if>
											<c:if test="${empty pushList}">
	                                           	<div class="flex-container m-hAuto">
													<div class="no_content">
														<span><spring:message code='common.message.sysmsg.alt4'/></span><!-- 수신한 메시지가 없습니다. -->
														<a href="javascript:stuDashMsg.moveMsgList('P')" class="ui basic small button mt5"><spring:message code="common.button.viewMsgBox"/></a>
													</div>
												</div>
											</c:if>
										</div>
										<div class="p8 ui tab dash-tab-content" id="dashSmsList" style="height: 100%;">
											<c:if test="${not empty smsList}">
	                                    		<c:forEach var="sms" items="${smsList}" varStatus="status">
	                                    			<c:if test="${status.index < 4}">
	                                    			<div class="item flex-row p8 <c:if test="${sms.readYn eq 'Y' }" >opacity7</c:if>">
					                                	<div class="flex overflow-hidden">
					                                		<a href="javascript:stuDashMsg.moveMsgList('S')" class="f100 overflow-hidden" title="<spring:message code="common.label.view" />">
					                                			<p class="item-title mb5 text-truncate"><c:out value="${sms.contents}"/></p>
					                                			<!-- <small class="f080">v.sendDttm</small> -->
					                                		</a>
					                                	</div>
					                                </div>
				                                	</c:if>
			                                	</c:forEach>
											</c:if>
											<c:if test="${empty smsList}">
	                                           	<div class="flex-container m-hAuto">
													<div class="no_content">
														<span><spring:message code='common.message.sysmsg.alt4'/></span><!-- 수신한 메시지가 없습니다. -->
														<a href="javascript:stuDashMsg.moveMsgList('S')" class="ui basic small button mt5"><spring:message code="common.button.viewMsgBox"/></a>
													</div>
												</div>
											</c:if>
										</div>
										<div class="p8 ui tab dash-tab-content" id="dashMsgList" style="height: 100%;">
											<c:if test="${not empty msgList}">
	                                    		<c:forEach var="msg" items="${msgList}" varStatus="status">
	                                    			<c:if test="${status.index < 4}">
	                                    			<div class="item flex-row p8 <c:if test="${msg.readYn eq 'Y' }" >opacity7</c:if>">
					                                	<div class="flex overflow-hidden">
					                                		<a href="javascript:stuDashMsg.moveMsgList('M')" class="f100 overflow-hidden" title="<spring:message code="common.label.view" />">
					                                			<p class="item-title mb5 text-truncate"><c:out value="${msg.contents}"/></p>
					                                			<!-- <small class="f080">v.sendDttm</small> -->
					                                		</a>
					                                	</div>
					                                </div>
				                                	</c:if>
			                                	</c:forEach>
											</c:if>
											<c:if test="${empty msgList}">
	                                           	<div class="flex-container m-hAuto">
													<div class="no_content">
														<span><spring:message code='common.message.sysmsg.alt4'/></span><!-- 수신한 메시지가 없습니다. -->
														<a href="javascript:stuDashMsg.moveMsgList('M')" class="ui basic small button mt5"><spring:message code="common.button.viewMsgBox"/></a>
													</div>
												</div>
											</c:if>
										</div>
										<div class="p8 ui tab dash-tab-content" id="dashTalkList" style="height: 100%;">
											<c:if test="${not empty talkList}">
	                                    		<c:forEach var="talk" items="${talkList}" varStatus="status">
	                                    			<c:if test="${status.index < 4}">
	                                    			<div class="item flex-row p8 <c:if test="${talk.readYn eq 'Y' }" >opacity7</c:if>">
					                                	<div class="flex overflow-hidden">
					                                		<a href="javascript:stuDashMsg.moveMsgList('T')" class="f100 overflow-hidden" title="<spring:message code="common.label.view" />">
					                                			<p class="item-title mb5 text-truncate"><c:out value="${talk.contents}"/></p>
					                                			<!-- <small class="f080">v.sendDttm</small> -->
					                                		</a>
					                                	</div>
					                                </div>
				                                	</c:if>
			                                	</c:forEach>
											</c:if>
											<c:if test="${empty talkList}">
	                                           	<div class="flex-container m-hAuto">
													<div class="no_content">
														<span><spring:message code='common.message.sysmsg.alt4'/></span><!-- 수신한 메시지가 없습니다. -->
														<a href="javascript:stuDashMsg.moveMsgList('T')" class="ui basic small button mt5"><spring:message code="common.button.viewMsgBox"/></a>
													</div>
												</div>
											</c:if>
										</div>
                                    </div>
                                    <script type="text/javascript">
	                                    $(document).ready(function() {
	                                		stuDashMsg.init();
		                            	});
	                                    var stuDashMsg = {
			                                	/* isTabLoad: false, */
			                                	init: function() {
			                                		// 대시보드 메세지 탭 이벤트 설정
			                                		$("[data-dash-tab]").off("click").on("click", function () {
			                                		    var dashTab = $(this).data("dashTab");

			                                		    $(".dash-tab-content").hide();          // 모든 탭 숨기기
			                                		    $("#dash" + dashTab + "List").show(); // 선택된 탭 보이기

			                                		    $("[data-dash-tab]").removeClass("active");
			                                		    $(this).addClass("active");
			                                		});

				                                		
			                                	},
			                                	moveMsgList: function(type){
			                                		// 알림 이동
			                                		
			                                	}
	                                    
		                                }
                                    </script>
	                                <style>
	                                	@media (max-width: 767px) {
										    #stuDashMsgDiv {
										    	display: none;
										    }
										}
	                                </style>
	                                <!-- PUSH/쪽지 글목록 -->
                                    <%
						        }
						        %>
                               
                                    
                                    <!-- 강의 Q&A -->
                                    <div class="component66 off" data-medi-ui="more-off" data-ctrl-off="더보기">
                                            	<div class="flex-item"><spring:message code="dashboard.course_qna"/><span class="msg_num">${not empty qnaNoAnsInfo ? qnaNoAnsInfo.noAnsCnt : 0}</span></div><%-- 강의 Q&A --%>
                                            	
                                            	<c:if test="${not empty cosQnaList}">
                                                	<div class="cont_body">
	                                                   <ul class="list_line_S2">
	                                                   	<c:forEach var="notice" items="${cosQnaList}" varStatus="status">
	                                                   		<c:if test="${status.index < 4}">
	                                                    	<li>
	                                                            <a href="javascript:moveCrs('/bbs/bbsLect/Form/atclView.do?crsCreCd=${notice.crsCreCd}&bbsId=${notice.bbsId}&atclId=${notice.atclId}')" title="<c:out value="${notice.atclTitle}"/>">
	                                                                <div class="n_tit <c:if test="${notice.viewYn eq 'Y'}">opacity7</c:if>">
	                                                                    <p class="head">
	                                                                        <span><c:out value="${notice.atclTitle}"/></span>
	                                                                        <c:if test="${notice.isNew eq 'Y' and notice.viewYn ne 'Y'}">
																			    <i class="ui pink circular mini label f060"></i>
																			</c:if>
	                                                                    </p>
	                                                                    <span class="sub"><c:out value="${notice.crsCreNm}"/> (<c:out value="${notice.declsNo}"/>반)</span>
	                                                                </div>
	
	                                                                <div class="n_date">
	                                                                	<c:choose >
				                                                            <c:when test="${notice.answerYn eq 'Y'}">
																	            <small class="ui green small label"><spring:message code="dashboard.qna.answer"/><!-- 답변 --></small>
																	        </c:when>
																	        <c:otherwise>
																	            <small class="ui orange small label"><spring:message code="dashboard.qna.wait"/><!-- 미답변 --></small>
																	        </c:otherwise>
	                                                                	</c:choose>
	                                                                    <small><uiex:formatDate value="${notice.regDttm}" type="date"/></small>
	                                                                </div>
	                                                            </a>
	                                                        </li>
	                                                        </c:if>
	                                                   	</c:forEach>
													</ul>
												</div>
												</c:if>
												<c:if test="${empty cosQnaList}">
                                                 	<div class="flex-container">
                                                 		<!-- 등록된 내용이 없습니다. -->
                                                 		<div class="cont-none"><i class="icon-list-no ico"></i><span><spring:message code="common.content.not_found"/></span></div>
													</div>
												</c:if>
                                    </div>
                                    <!-- //강의 Q&A -->
                                    <!-- 1:1 상담 -->
                                    <div class="component66 off" data-medi-ui="more-off" data-ctrl-off="더보기">
                                           	<div class="flex-item"><spring:message code="dashboard.councel"/><span class="msg_num">${not empty secretNoAnsInfo ? secretNoAnsInfo.noAnsCnt : 0}</span></div><%-- 1:1 상담 --%>
                                            	<c:if test="${not empty cosSecretList}">
                                                <div class="cont_body">
                                                    <ul class="list_line_S2">
                                                    <c:set var="secretViewYn">
	                                            		<%=(SessionInfo.getAuthrtCd(request).contains("TUT") == true ? "N" : "Y") %>
	                                            	</c:set>
                                                   	<c:forEach var="notice" items="${cosSecretList}" varStatus="status">
                                                   		<c:if test="${status.index < 4}">
                                                     	<li>
                                                     		<c:choose>
                                                     			<c:when test="${secretViewYn eq 'Y'}">
                                                     		<a href="javascript:moveCrs('/bbs/bbsLect/Form/atclView.do?crsCreCd=${notice.crsCreCd}&bbsId=${notice.bbsId}&atclId=${notice.atclId}')" title="<c:out value="${notice.atclTitle}"/>">
                                                     			</c:when>
                                                     			<c:otherwise>
                                                     		<a href="javascript:alert('<spring:message code="bbs.alert.no.auth.atcl"/>')" title="<c:out value="${notice.atclTitle}"/>">	
                                                     			</c:otherwise>
                                                     		</c:choose>
                                                                 <div class="n_tit <c:if test="${notice.viewYn eq 'Y'}">opacity7</c:if>">
                                                                     <p class="head">
                                                                         <span><c:out value="${notice.atclTitle}"/></span>
                                                                         <c:if test="${notice.isNew eq 'Y' and notice.viewYn ne 'Y'}">
																    	<i class="ui pink circular mini label f060"></i>
																		</c:if>
                                                                     </p>
                                                                     <span class="sub"><c:out value="${notice.crsCreNm}"/> (<c:out value="${notice.declsNo}"/>반)</span>
                                                                 </div>

                                                                 <div class="n_date">
                                                                 	<c:choose >
	                                                                  	<c:when test="${notice.answerYn eq 'Y'}">
																            <small class="ui green small label"><spring:message code="dashboard.qna.answer"/><!-- 답변 --></small> 
																        </c:when>
																        <c:otherwise>
																            <small class="ui orange small label"><spring:message code="dashboard.qna.wait"/><!-- 미답변 --></small>
																        </c:otherwise>
	                                                                </c:choose>
                                                                     <small><uiex:formatDate value="${notice.regDttm}" type="date"/></small>
                                                                 </div>
                                                             </a>
                                                         </li>
                                                         </c:if>
                                                   	</c:forEach>
                                                    </ul>
                                                </div>
                                            	</c:if>
                                            	<c:if test="${empty cosSecretList}">
                                                 	<div class="flex-container">
                                                 		<!-- 등록된 내용이 없습니다. -->
                                                 		<div class="cont-none"><i class="icon-list-no ico"></i><span><spring:message code="common.content.not_found"/></span></div>
                                                 	</div>
                                                 </c:if>
                                            </div
                                            <!-- //1:1 상담 -->
                                    

                                    <!-- 수업운영점수_추가된 요소_230517 -->
                                    <div class="component66" style="<%=(SessionInfo.getAuthrtGrpcd(request).contains("ADM") == true ? "display:none" : "")%>;">
										<%
										if (SessionInfo.isKnou(request)) {
											%>
	                                        <div class="option-content">
	                                            <div class="sec_head"><spring:message code="score.label.prof.oper.score" /></div><!-- 수업운영점수 -->
	                                            <div class="button-area">
	                                            	<c:set var="mType">
	                                            		<%=(SessionInfo.getAuthrtCd(request).contains("TUT") == true ? "ASSISTANT" : "PROFESSOR") %>
	                                            	</c:set>
	                                                <a href="javascript:evalPop('${mType }')" target="" class="txt-link"><spring:message code="dashboard.label.oper.criteria.view" /><i class="ion-ios-arrow-forward" aria-hidden="true"></i></a><!-- 수업운영 평가기준 보기 -->
	                                            </div>
	                                        </div>
	                                        <div class="area2" style="cursor: pointer;" onclick="oprScoreStatusPop()">
	                                            <div>
	                                                <i class="icon-state-course ico" aria-hidden="true"></i>
	                                                <span><spring:message code="contents.label.award.score.stats" /></span><!-- 상점 취득 현황 -->
	                                            </div>
	                                            <div>
	                                                <p><spring:message code="contents.label.term.total.score" /> <b><c:out value="${empty lessonManageMap.oprTotScore ? '-' : lessonManageMap.oprTotScore}"/></b></p><!-- 학기 총 상점 -->
	                                                <p><spring:message code="contents.label.prev.plus.score" /> <b><c:out value="${empty lessonManageMap.lastWeekOprScore ? '-' : lessonManageMap.lastWeekOprScore}"/></b></p><!-- 지난 주 상점 -->
	                                            </div>
	                                        </div>
	                                        <%
										}
	                                    %>
                                        <ul class="score-area">
                                            <li style="max-height:100px">
                                                <dl>
                                                    <dt><spring:message code="dashboard.course_qna" /></dt><!-- 강의 Q&A -->
                                                    <dd><spring:message code="contents.label.user.njoin.num" /> <span>${empty lessonManageMap.qnaNoAnsCnt ? '-' : lessonManageMap.qnaNoAnsCnt}</span></dd><!-- 미응답수 -->
                                                    <%--
                                                    <dd><spring:message code="common.my.response.time" /> <span>${empty lessonManageMap.qnaHour ? '-' : lessonManageMap.qnaHour}</span></dd>내 응답시간
                                                    <dd><spring:message code="common.all.avg" /> <span>0</span></dd> 전체평균
                                                    --%>
                                                </dl>
                                            </li>
                                            <li style="max-height:100px">
                                                <dl>
                                                    <dt><spring:message code="dashboard.councel" /></dt><!-- 1:1 상담 -->
                                                    <dd><spring:message code="contents.label.user.njoin.num" /> <span>${empty lessonManageMap.secretNoAnsCnt ? '-' : lessonManageMap.secretNoAnsCnt}</span></dd><!-- 미응답수 -->
                                                   	<%-- 
                                                   	<dd><spring:message code="common.my.response.time" /> <span>${empty lessonManageMap.secretHour ? '-' : lessonManageMap.secretHour}</span></dd>내 응답시간
                                                    <dd><spring:message code="common.all.avg" /> <span>0</span></dd> 전체평균
                                                    --%>
                                                </dl>
                                            </li>                                            
                                        </ul>
                                    </div>
                                    <!-- //수업운영점수_추가된 요소_230517 -->

                                    <!-- 과목 -->
                                    <div class="col-12 component55">
                                        <div class="option-content header2">                                                    
                                            <div class="listTab2" data-target="tab_contents2">
                                                <a data-target="#tab5" class="<c:if test="${empty param.tabCd or param.tabCd eq '1'}">active</c:if>" data-course-tab="1"><h3><spring:message code="dashboard.regular_course" /></h3></a><!-- 정규과목 -->
                                                <%
                                                if (SessionInfo.isKnou(request)) {
                                                	%>
                                                	<a data-target="#tab6" class="<c:if test="${param.tabCd eq '2'}">active</c:if>" data-course-tab="2"><h3><spring:message code="dashboard.course.monitor" /></h3></a><!-- 모니터링과목 -->
                                                	<a data-target="#tab7" class="<c:if test="${param.tabCd eq '3'}">active</c:if>" data-course-tab="3" id="legalTab"><h3><spring:message code="dashboard.course.legal" /></h3></a><!-- 법정과목 -->
                                                	<a data-target="#tab8" class="<c:if test="${param.tabCd eq '4'}">active</c:if>" data-course-tab="4" id="openTab"><h3>공개과정</h3></a><!-- 공개과정 -->
                                                	<%
                                                }
                                                %>
                                            </div>
                                            
                                            <div class="select_area">
		                                    	<div style="display:inline-block;width:200px;">
		                                    		<label for="courseTerm" class="hide">Term</label>
			                                        <select id="courseTerm" class="ui dropdown fluid mr5" onchange="changeTerm();return false;">
			                                        	<c:forEach var="term" items="${termList}">
			                                        		<option value="${term.termCd}" <c:if test="${dashboardVO.termCd eq term.termCd}">selected</c:if>>${term.termNm}</option>
			                                        	</c:forEach>
			                                        </select>
			                                        <script>
				                                     	// 학기변경
				                                     	function changeTerm() {
															var tabCd = "1";
				                                     		
				                                     		$.each($("[data-course-tab]"), function() {
				                                     			if($(this).hasClass("active")) {
				                                     				tabCd = $(this).data("courseTab") || "";
				                                     			}
				                                     		});
				                                     		
				                                     		var termCd = $("#courseTerm option:selected").val();
				                                     		document.location.href = "<c:url value='/dashboard/dashboard.do'/>?termCd="+termCd + "&tabCd=" + tabCd;
				                                     	}
			                                        </script>
		                                        </div>
                                            </div>
                                        </div>      
                                        <div class="tab_contents2"> <!-- 클래스 수정_230517 -->
                                            <div id="tab5" class="tab_content <c:if test="${empty param.tabCd or param.tabCd eq '1'}">on</c:if>">  

												<!-- 정규과목 목록 -->
                                                <%@ include file="/WEB-INF/jsp/dashboard/prof_dashboard_cors_list.jsp" %>                                                
                                                    
                                            </div>
                                            <div id="tab6" class="tab_content <c:if test="${param.tabCd eq '2'}">on</c:if>">
                                            
                                                <!-- 모니터링과목 목록 -->
                                                <%@ include file="/WEB-INF/jsp/dashboard/prof_dashboard_cors_mon_list.jsp" %>
                                                
                                            </div>
                                            <div id="tab7" class="tab_content <c:if test="${param.tabCd eq '3'}">on</c:if>">
                                            	
                                            	<!-- 법정과목 목록 -->
                                            	<%@ include file="/WEB-INF/jsp/dashboard/prof_dashboard_cors_legal_list.jsp" %>
                                            	
                                            </div>
                                            <div id="tab8" class="tab_content <c:if test="${param.tabCd eq '4'}">on</c:if>">
                                            	
                                            	<!-- 공개과정 목록 -->
                                            	<%@ include file="/WEB-INF/jsp/dashboard/prof_dashboard_cors_open_list.jsp" %>
                                            	
                                            </div>
                                        </div>
                                    </div>
                                    <!-- //과목 -->
                                </div>
                            </main>
                            
                            <div class="modal fade in" id="evalModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="dashboard.label.prof.oper.criteria.write" />" aria-hidden="false" style="display: none; padding-right: 17px;">
						        <div class="modal-dialog modal-lg" role="document">
						            <div class="modal-content">
						                <div class="modal-header">
						                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="team.common.close"/>"><!-- 닫기 -->
						                        <span aria-hidden="true">&times;</span>
						                    </button>
						                    <h4 class="modal-title"><spring:message code="dashboard.label.prof.oper.criteria.write" /></h4><!-- 교수 수업운영 평가기준 등록 -->
						                </div>
						                <div class="modal-body">
						                    <iframe src="" width="100%" id="evalModalIfm" name="evalModalIfm" title="evalModalIfm"></iframe>
						                </div>
						            </div>
						        </div>
						    </div>
                            <script type="text/javascript">
                            	var $userConnList;
                            	var userIdOrder = "ASC";
                            	var userNmOrder = "ASC";
                            	
                            	$(document).ready(function() {
                            		changeAppNaviBarState("showBar");
                            		
                            		$userConnList = $(".u_list > li"); // 접속현황 목록
                            	
                            		// 탭 자동선택
                            		var tabCd = '<c:out value="${param.tabCd}" />';
                        			
                        			if(tabCd == "LEGAL") {
                        				$("#legalTab").trigger("click");
                        			}
                        			
                        			popupNoticeModal();
                            	});
                            	
                            	// 접속현황 목록 정렬
                            	function sortUserConnList(sortKey) {
                            		if($userConnList.length == 0) return;
                            		var list = [];
                            		
                            		$.each($userConnList, function() {
                            			list.push(this);
                            		});
                            		
                            		// 오름차순 정렬
                            		list.sort(function(a, b) {
                            			var connUserId1 = $(a).data("connUserId");
                            			var connUserId2 = $(b).data("connUserId");
                            			var connUserNm1 = $(a).data("connUserNm");
                            			var connUserNm2 = $(b).data("connUserNm");
                            			
                            			if(sortKey == "USER_ID") {
                            				if(connUserId1 < connUserId2) return -1;
                                			if(connUserId1 > connUserId2) return 1;
                                			if(connUserId1 == connUserId2) return 0;
                            			} else if(sortKey == "USER_NM") {
                            				if(connUserNm1 < connUserNm2) return -1;
                                			if(connUserNm1 > connUserNm2) return 1;
                                			if(connUserNm1 == connUserNm2) {
                                				if(connUserId1 < connUserId2) return -1;
                                    			if(connUserId1 > connUserId2) return 1;
                                    			
                                				return 0;
                                			}
                            			}
                            		});
                            		
                            		if(sortKey == "USER_ID") {
                            			userIdOrder = (userIdOrder == "ASC") ? "DESC" : "ASC";
                            			userNmOrder = "DESC";
                            			
                            			if(userIdOrder == "DESC") {
                            				list = list.reverse();
                            			}
                            		} else if(sortKey == "USER_NM") {
                            			
                            			userIdOrder = "DESC";
                            			userNmOrder = (userNmOrder == "ASC") ? "DESC" : "ASC";
                            			
                            			if(userNmOrder == "DESC") {
                            				list = list.reverse();
                            			}
                            		}
                            		
                            		$("#userConnList").empty();
                            		$.each(list, function () {
                            			$("#userConnList").append(this);
                            		});
                            	}
                            
                                $(".listTab2 > * ").on('click', function(e) {
                                    this.parentNode.querySelectorAll(".listTab2 > * ").forEach( elem => { elem.classList.remove("active"); });
                                    $(this).addClass("active");

                                    [...document.querySelector("." + this.parentNode.dataset.target).children].map(elem => elem.classList.remove("on") );
                                    [...document.querySelector("." + this.parentNode.dataset.target).children].map(elem => {
                                        "#"+elem.id === $(this).data('target') ? elem.classList.add("on") : ' ' ;
                                    });
                                    
                                    if( this.parentNode.parentNode.classList.contains("off") ){
                                        this.parentNode.parentNode.classList.remove("off");
                                    }
                                });
                                
                                var alertToggleClose = false;
                                $(".alertToggle").unbind('click').bind('click', function (e) {
                                	if ($(this).hasClass("on")) {
                                		$(this).removeClass("on");
                                		alertToggleClose = false;
                                	}
                                	else {
                                		if (!alertToggleClose) {
	                                		$(this).addClass("on");
	                                		$('.alert_modal').slideToggle();
	                                		
	                                		// 정렬전 원본 리스트 세팅
	                    					$("#userConnList").empty();
	                                		$.each($userConnList, function () {
	                                			$("#userConnList").append(this);
	                                		});
	                                		
	                                		userIdOrder = "ASC";
	                                		userNmOrder = "ASC";
                                		}
                                		
                                		alertToggleClose = false;
                                	}
                                });
                                
                             	// 외부영역 클릭 시 접속현황 닫기
                            	$(document).off("mouseup.alertModal").on("mouseup.alertModal", function(e) {
                            		var alertModal = e.target.closest(".alert_modal");
                            		
                            		if(!alertModal) {
                            			if ($('.alert_modal').is(':visible') == true) {
                            				$(".alertToggle").removeClass("on");
                            				$('.alert_modal').slideUp();
                            				alertToggleClose = true;
                            				
                            				setTimeout(function() {
                            					alertToggleClose = false;
                            				}, 200);
                                    	}
                            		}
                            	});
                             	
                             	// 전체 메시지 보내기 팝업
                             	function allSendMsg() {
                             		var rcvUserInfoStr = "";
                            		var sendCnt = 0;
                            		
                            		$("#userConnList > li").each(function(i, v) {
                            			sendCnt++;
                            			if (sendCnt > 1) rcvUserInfoStr += "|";
                            			rcvUserInfoStr += $(v).attr("data-conn-user-no");
                            			rcvUserInfoStr += ";" + $(v).attr("data-conn-user-nm"); 
                            			rcvUserInfoStr += ";" + $(v).attr("data-conn-mobile-no");
                            			rcvUserInfoStr += ";" + $(v).attr("data-conn-email"); 
                            		});
                            		
                            		if (sendCnt == 0) {
                            			alert("<spring:message code='common.alert.sysmsg.select_user'/>");
                            			return;
                            		}
                            		
                                    window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");

                                    var form = document.alarmForm;
                                    form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
                                    form.target = "msgWindow";
                                    form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
                                    form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
                                    form.submit();
                             	}
                            	
                            	// 메시지보내기 팝업
                            	function viewSendMsg(userId, userNm, mobile, email) {
                            		var rcvUserInfoStr = userId+";"+userNm+";"+mobile+";"+email;
                            		
                                    window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");

                                    var form = document.alarmForm;
                                    form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
                                    form.target = "msgWindow";
                                    form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
                                    form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
                                    form.submit();
                            	}
                            	
                            	// 수업운영 평가기준 팝업
                            	function evalPop(type) {
                            		$("form[name=tempForm]").remove();
                            		$("#evalModal h4.modal-title").text(type == "PROFESSOR" ? "<spring:message code='dashboard.professor.class.eval.crit' />" : "<spring:message code='score.label.assist.oper.criteria' />"); // 교수 수업운영 평가기준, 조교 수업운영 평가기준
                            		var form = $("<form></form>");
                            		form.attr("method", "POST");
                            		form.attr("name", "tempForm");
                            		form.attr("action", type == "PROFESSOR" ? "/score/scoreMgr/oprScoreProfCriteriaPop.do" : "/score/scoreMgr/oprScoreAssistCriteriaPop.do");
                            		form.attr("target", "evalModalIfm");
                            		form.appendTo("body");
                            		form.submit();
                            		$('#evalModal').modal('show');
                            	}
                            	
                            	$('iframe').iFrameResize();
                                window.closeModal = function() {
                                    $('.modal').modal('hide');
                                };
                                
                             	// 앱 네비바 표시 바꾸기
                            	function changeAppNaviBarState(state){
                            	    const scheme = 'smartq://hycu?action=' + state;
                            	    try {
                            	        webkit.messageHandlers.callbackHandler.postMessage(scheme); // IOS
                            	    } catch(err) {}

                            	    try{
                            	        window.Android.goScheme(scheme); // Andriod
                            	    } catch(err){}
                            	}
                             	
                             	// 수업운영 점수현황 팝업
                             	function oprScoreStatusPop() {
                             		var userType = "<%=SessionInfo.getAuthrtCd(request)%>";
                             		
                             		if(userType.indexOf("PFS") > -1) {
                             			// 교수 수업운영 점수현황 팝업
                             			$("#oprScoreStatusForm > input[name='termCd']").val($("#courseTerm").val());
                             			$("#oprScoreStatusForm").attr("target", "oprScoreStatusIfm");
                             			$("#oprScoreStatusForm").attr("action", "/score/scoreHome/oprScoreProfStatusPop.do");
                             			$("#oprScoreStatusForm").submit();
                             			$('#oprScoreStatusModal').modal('show');
                             			
                             		} else if (userType.indexOf("TUT") > -1) {
                             			// 조교 수업운영 점수현황 팝업
                             			$("#oprScoreStatusForm > input[name='termCd']").val($("#courseTerm").val());
                             			$("#oprScoreStatusForm").attr("target", "oprScoreStatusIfm");
                             			$("#oprScoreStatusForm").attr("action", "/score/scoreHome/oprScoreAssistStatusPop.do");
                             			$("#oprScoreStatusForm").submit();
                             			$('#oprScoreStatusModal').modal('show');
                             		}
                             	}
                             	
                        		function oprScoreAssistDetailModal(crsCreCd, lessonScheduleId, userId) {
                        			$("#oprScoreAssistDetailForm > input[name='crsCreCd']").val(crsCreCd);
                        			$("#oprScoreAssistDetailForm > input[name='lessonScheduleId']").val(lessonScheduleId);
                        			$("#oprScoreAssistDetailForm > input[name='userId']").val(userId);
                        			$("#oprScoreAssistDetailForm").attr("target", "oprScoreAssistWriteIfm");
                        	        $("#oprScoreAssistDetailForm").attr("action", "/score/scoreMgr/oprScoreAssistDetailPop.do");
                        	        $("#oprScoreAssistDetailForm").submit();
                        	        $('#oprScoreAssistDetailModal').modal('show');
                        	        
                        	        $("#oprScoreAssistDetailForm > input[name='crsCreCd']").val("");
                        	        $("#oprScoreAssistDetailForm > input[name='lessonScheduleId']").val("");
                        			$("#oprScoreAssistDetailForm > input[name='userId']").val("");
                        		}
                        		
                        		function oprScoreProfDetailModal(crsCreCd, lessonScheduleId, userId) {
                        			$("#oprProfDetailForm > input[name='crsCreCd']").val(crsCreCd);
                        			$("#oprProfDetailForm > input[name='lessonScheduleId']").val(lessonScheduleId);
                        			$("#oprProfDetailForm > input[name='userId']").val(userId);
                        			$("#oprProfDetailForm").attr("target", "oprProfDetailIfm");
                        	        $("#oprProfDetailForm").attr("action", "/score/scoreMgr/oprScoreProfDetailPop.do");
                        	        $("#oprProfDetailForm").submit();
                        	        $('#oprProfDetailModal').modal('show');
                        	        
                        	        $("#oprProfDetailForm > input[name='crsCreCd']").val("");
                        	        $("#oprProfDetailForm > input[name='lessonScheduleId']").val("");
                        			$("#oprProfDetailForm > input[name='userId']").val("");
                        		}
                        		
                        		// 팝업공지 모달
                        		function popupNoticeModal() {
                        			var popNoticeSn = "${popupNoticeVO.popNoticeSn}";
                        			var noticeTitle = "${popupNoticeVO.noticeTitle}" || "팝업공지";
                        			var xPercent = "${popupNoticeVO.xPercent}" || "50";
                        			var legalStdOpenYn = "${popupNoticeVO.legalStdOpenYn}" || "N";
                        			var legalPopUseYn = "${legalPopUseYn}" || "N";
                        			
                        			if(legalStdOpenYn == "Y" && legalPopUseYn != "Y") {
                        				return;
                        			}
                        		    
                        			if(popNoticeSn) {
                        				$("#popupNoticeTitle").text(noticeTitle);
                        				$("#popupNoticeDiv").css("width", xPercent + "%");
                        				
                        				$("#popupNoticeForm input[name=popNoticeSn]").val(popNoticeSn);
                        				$("#popupNoticeForm").attr("target", "popupNoticeIfm");
                        		        $("#popupNoticeForm").attr("action", "/sch/schHome/popupNoticeViewPop.do");
                        		        $("#popupNoticeForm").submit();
                        		        $("#popupNoticeModal").modal("show");
                        			}
                        		}
                            </script>

                        <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
                </div>
        </div>
        
        <!-- 수업운영 점수현황 팝업 --> 
		<form id="oprScoreStatusForm" name="oprScoreStatusForm" method="post">
			<input type="hidden" name="termCd" value="" />
		</form>
	    <div class="modal fade in" id="oprScoreStatusModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="dashboard.label.score.condition" />" aria-hidden="false" style="display: none; padding-right: 17px;">
	        <div class="modal-dialog modal-lg" role="document">
	            <div class="modal-content">
	                <div class="modal-header">
	                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="exam.button.close" />	">
	                        <span aria-hidden="true">&times;</span>
	                    </button>
	                    <h4 class="modal-title"><spring:message code="dashboard.label.score.condition" /><!-- 수업운영 점수현황 --></h4>
	                </div>
	                <div class="modal-body">
	                    <iframe src="" width="100%" id="oprScoreStatusIfm" name="oprScoreStatusIfm"></iframe>
	                </div>
	            </div>
	        </div>
	    </div>
    
    
	    <!-- 조교 수업운영 평가기준 팝업 -->
	    <form id="oprScoreAssistDetailForm" name="oprScoreAssistDetailForm">
			<input type="hidden" name="crsCreCd" value="" />
	    	<input type="hidden" name="lessonScheduleId" value="" />
	    	<input type="hidden" name="userId" value="" />
		</form>
	    <div class="modal fade in" id="oprScoreAssistDetailModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="score.label.assist.oper.criteria"/>" aria-hidden="false" style="display: none; padding-right: 17px;">
	        <div class="modal-dialog modal-lg" role="document">
	            <div class="modal-content">
	                <div class="modal-header">
	                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="team.common.close"/>">
	                        <span aria-hidden="true">&times;</span>
	                    </button>
	                    <h4 class="modal-title"><spring:message code="score.label.assist.oper.criteria"/><!-- 교수 수업운영 평가기준 --></h4>
	                </div>
	                <div class="modal-body">
	                    <iframe src="" width="100%" id="oprScoreAssistDetailIfm" name="oprScoreAssistWriteIfm"></iframe>
	                </div>
	            </div>
	        </div>
	    </div>


	    <!-- 교수 수업운영 평가기준 등록 팝업 -->
	    <form id="oprProfDetailForm" name="oprProfDetailForm">
	    	<input type="hidden" name="crsCreCd" value="" />
	    	<input type="hidden" name="lessonScheduleId" value="" />
	    	<input type="hidden" name="userId" value="" />
		</form>
	    <div class="modal fade in" id="oprProfDetailModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="common.modal.field" />" aria-hidden="false" style="display: none; padding-right: 17px;">
	        <div class="modal-dialog modal-lg" role="document">
	            <div class="modal-content">
	                <div class="modal-header">
	                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="team.common.close"/>">
	                        <span aria-hidden="true">&times;</span>
	                    </button>
	                    <h4 class="modal-title"><spring:message code='score.label.prof.oper.criteria' /><!-- 교수 수업운영 평가기준 --></h4>
	                </div>
	                <div class="modal-body">
	                    <iframe src="" width="100%" id="oprProfDetailIfm" name="oprProfDetailIfm"></iframe>
	                </div>
	            </div>
	        </div>
	    </div>
		<!-- 팝업공지 -->
	    <form id="popupNoticeForm" name="popupNoticeForm">
	    	<input type="hidden" name="popNoticeSn" value="" />
	    	<input type="hidden" name="lectEvalUrl" value="" />
		</form>
	    <div class="modal fade in" id="popupNoticeModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="common.modal.field" />" aria-hidden="false" style="display: none; padding-right: 17px;">
	        <div class="modal-dialog modal-lg" role="document" id="popupNoticeDiv" style="width: 50%;min-width:300px;">
	            <div class="modal-content">
	                <div class="modal-header">
	                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="team.common.close"/>">
	                        <span aria-hidden="true">&times;</span>
	                    </button>
	                    <h4 class="modal-title" id="popupNoticeTitle"></h4>
	                </div>
	                <div class="modal-body">
	                    <iframe src="" width="100%" id="popupNoticeIfm" name="popupNoticeIfm"></iframe>
	                </div>
	            </div>
	        </div>
	    </div>
	    <script>
	        $('#oprScoreStatusIfm').iFrameResize();
	        $('#oprScoreAssistDetailIfm').iFrameResize();
	        $('#oprProfDetailIfm').iFrameResize();
	        window.closeModal = function() {
	            $('.modal').modal('hide');
	        };
	        window.closeAssistDetailModal = function() {
	        	$("#oprScoreAssistDetailModal").modal('hide');
	        };
	        window.closeprofDetailModal = function() {
	        	$("#oprProfDetailModal").modal('hide');
	        };
	    </script>
    </body>
</html>