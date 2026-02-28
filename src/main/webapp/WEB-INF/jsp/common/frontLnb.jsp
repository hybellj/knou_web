<%@page import="knou.lms.user.vo.UsrUserInfoVO"%>
<%@page import="java.util.List"%>
<%@ page import="knou.framework.util.StringUtil"%>
<%@ page import="knou.framework.common.CommConst"%>
<%@ page import="knou.framework.common.SessionInfo"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<!-- main_menu 영역 부분 --> 
<nav class="gnb<%=("mobile".equals(SessionInfo.getDeviceType(request)) ? "" : " on")%> <%=StringUtil.nvl(SessionInfo.getAuthrtCd(request)).contains("USR") ? "col2" : ""%>">
	<button type="button" class="menu_btn on" title="<spring:message code="common.menu" />" data-medi-ui="gnbmenu"><i class="ion-navicon" aria-hidden="true"></i></button>
	<div id="main_menu" class="menu_box">
		<div class="top">

			<h1 class="logo">
				<a href="<%= SessionInfo.getCurUserHome(request) %>" title="<spring:message code="common.label.classroom" />">
					<img src="/webdoc/img/logo.png" alt="<spring:message code="common.logo" />">
				</a>
			</h1>

			<!-- 사용자정보 -->
			<div class="user_info">
			<%
				if(StringUtil.nvl(SessionInfo.getAuthrtCd(request)).contains("PFS")) {
			%>
				<label for="insti_box" class="hide"><spring:message code="sys.label.job.univ" />/<spring:message code="score.label.univ" /><spring:message code="team.common.select" /></label><!-- 대학/학부 선택 -->
					<select class="ui dropdown compact  select_sm" id="insti_box" name="insti_box" onchange="changeUni(this.value)">
						<option value=" "><spring:message code="main.all" /></option><!-- 전체 -->
						<option value="C" <c:if test="${param.uniCd eq 'C'}">selected</c:if>><spring:message code="common.label.uni.college" /></option><!-- 대학교 -->
						<option value="G" <c:if test="${param.uniCd eq 'G'}">selected</c:if>><spring:message code="common.label.uni.graduate" /></option><!-- 대학원 -->
					</select>
					<script type="text/javascript">
						// 대학교, 대학원 변경
						function changeUni(uniCd) {
							var url = new URL(location.href);
							var urlParams = new URLSearchParams(url.search);
							var paramsObj = Object.fromEntries(urlParams.entries());
							
							if((uniCd || "").trim()) {
								paramsObj.uniCd = uniCd;
							} else {
								if(paramsObj.uniCd) {
									delete paramsObj.uniCd;
								}
							}
							
							var queryStr = new URLSearchParams(paramsObj).toString();
							var newUrl = url.origin + url.pathname + "?" + queryStr;
							
							document.location.href = newUrl;
						}
					</script>
			<%
				}
			%>
				<div class="user-img ui dropdown mla">
					<div class="initial-img sm" style="min-width:35px">
					<%
						// 사용자사진
						if (!"".equals(SessionInfo.getUserPhoto(request))) {
					%>
							<img id="userPhoto1" src="<%=SessionInfo.getUserPhoto(request)%>" alt='user photo'>
					<%
						} else {
					%>
							<img id="userPhoto1" src="/webdoc/img/no_user.gif" alt='user photo'>
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
									<img id="userPhoto2" src="<%=SessionInfo.getUserPhoto(request)%>" alt='user photo'>
							<%
								} else {
							%>
									<img id="userPhoto2" src="/webdoc/img/no_user.gif" alt='user photo'>
							<%
								}
							%>
							</div>
							<ul>
								<li><div style="max-width:250px;min-width:200px;word-wrap:break-word;white-space: normal;"><%= SessionInfo.getUserNm(request) %> (<%= SessionInfo.getUserId(request) %>)</div></li>
								<!-- <li><a href="#0" class="link">프로필 관리</a></li> -->
							</ul>
						</div>
						<div class="divider m0"></div>
					<%
						if(!SessionInfo.isVirtualLogin(request)) {
							List<UsrUserInfoVO> userRltnList = SessionInfo.getUserRltnList(request);
							pageContext.setAttribute("userRltnList", userRltnList);
							pageContext.setAttribute("loginOrgId", SessionInfo.getOrgId(request));
					%>
							<div class="item"><a href="javascript:userProfilePop('<%= SessionInfo.getUserId(request) %>');" title="<spring:message code='user.title.userinfo.myinfo' />"><i class="user circle icon"></i><spring:message code='user.title.userinfo.myinfo' /></a></div><!-- 내정보 -->
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
							
							<div class="item"><a href="/user/userHome/logout.do" onclick="localStorage.removeItem('USER_PHOTO_<%=SessionInfo.getUserId(request)%>')" title="<spring:message code='user.button.logout' />"><i class="sign-out icon"></i><spring:message code='user.button.logout' /></a></div><!-- 로그아웃 -->
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

		<!-- 메뉴 영역 -->
		<div class="scrollarea">

			<%
			if(StringUtil.nvl(SessionInfo.getAuthrtCd(request)).contains("USR")) {
				// 기관:한사대
                if (SessionInfo.isKnou(request)) {
					%>
					<div class="menu">
						<ul class="d_item">
							<li><a href="javascript:alert('[준비중] 홈페이지 이동')"><i class="icon-search-web ico" aria-hidden="true"></i>홈페이지</a></li>
						</ul>
						
						<ul class="d_item">
							<li><a href="/exam/Form/stuExamAbsentList.do"><i class="icon-user-no ico" aria-hidden="true"></i></i><spring:message code="dashboard.absent" /></a></li><!-- 결시원 -->
							<%
							if (SessionInfo.getDisablilityYn(request) != null && SessionInfo.getDisablilityYn(request).equals("Y")) {
								%>
							<li><a href="/exam/Form/stuExamDsblReqList.do"><i class="icon-paper-pencil ico" aria-hidden="true"></i></i><spring:message code="exam.label.exam.req" /></a></li><!-- 시험지원 -->
								<%
							} else {
							    %>
							<li></li><!-- 시험지원 -->
							    <%
							}
							%>
							<!-- 강의평가 -->
							<%
							if (SessionInfo.getLectEvalUrl(request) != null) {
								%>
							<li><a href="javascript:goLectEval()" title="<spring:message code="resh.label.lect.eval" />"><i class="icon-board-checked ico" aria-hidden="true"></i><spring:message code="resh.label.lect.eval" /></a></li><!-- 강의평가 -->
								<%
							} else {
							    %>
						    <li></li><!-- 강의평가 -->
							    <%
							}
							%>
							<li><a href="/score/scoreOverall/scoreOverallMainList.do" _target="_blank"><i class="icon-find-list ico" aria-hidden="true"></i><spring:message code="common.check.grades" /></a></li>
						</ul>
						<ul class="d_item">
							<li><a href="/file/fileHome/Form/fileBox.do" title="<spring:message code="filemgr.label.my.file.box" />"><i class="icon-floppy-diskette ico" aria-hidden="true"></i><spring:message code="filemgr.label.my.file.box" /></a></li><!-- 개인자료실 -->
						</ul>
					</div>
					<%
                }
			} 
			else {
				// 기관:한사대
                if (SessionInfo.isKnou(request)) {
                   	%>
                   	<div class="menu">
						<%-- <ul class="c_item">
							<li><a href="<%=CommConst.LSNPLAN_POP_URL%>" target="_blank" title="<spring:message code="common.label.class.plan" />"><i class="icon-paper-rollup ico" aria-hidden="true"></i><spring:message code="common.label.class.plan" /></a></li><!-- 수업계획서 -->
							<li><a href="<%=CommConst.LECT_EVAL_PROF_URL%>" target="_blank" title="<spring:message code="resh.label.lect.eval" />"><i class="icon-board-checked ico" aria-hidden="true"></i><spring:message code="resh.label.lect.eval" /></a></li><!-- 강의평가 -->
							<li><a href="<%=CommConst.EXT_URL_LCDMS%>" target="_blank"><i class="icon-chair-rolling ico" aria-hidden="true"></i><spring:message code="common.lcdms" /></a></li><!-- LCDMS -->
						</ul>
						
						<ul class="c_item">
							<li><a href="<%=CommConst.EXT_URL_EMS%>" target="_blank"><i class="icon-laptop ico" aria-hidden="true"></i><spring:message code="common.undergraduate.studies.ems" /></a></li><!-- 학부 EMS -->
							<li><a href="<%=CommConst.EXT_URL_GEMS%>" target="_blank"><i class="icon-laptop ico" aria-hidden="true"></i><spring:message code="common.graduate.schoo.ems" /></a></li><!-- 대학원 EMS -->
						</ul> --%>
						
						<ul class="c_item">
							<li><a href="/stats/profLrnPrgrtListView.do"><i class="icon-paper-pencil ico" aria-hidden="true"></i></i><spring:message code="common.label.lesson.process.manage" /></a></li><!-- 학습진도관리 -->
							<li><a href="/exam/examAbsentList.do"><i class="icon-user-no ico" aria-hidden="true"></i><spring:message code="dashboard.absent" /></a></li><!-- 결시원 -->
							<li><a href="/exam/examDsblReqList.do"><i class="icon-paper-pencil ico" aria-hidden="true"></i></i><spring:message code="exam.label.exam.req" /></a></li><!-- 시험지원 -->
							<li><a href="/score/scoreOverall/scoreOverallMainList.do"><i class="icon-paper-pencil ico" aria-hidden="true"></i></i><spring:message code="score.label.university.score" /></a></li><!-- 종합성적 -->
							<li><a href="/score/scoreOverall/scoreOverallCourseMain.do"><i class="icon-paper-pencil ico" aria-hidden="true"></i></i><spring:message code="common.label.score.reconfirm" /></a></li><!-- 성적재확인 -->
							<li><a href="/file/fileHome/Form/fileBox.do" title="<spring:message code="filemgr.label.my.file.box" />"><i class="icon-floppy-diskette ico" aria-hidden="true"></i><spring:message code="filemgr.label.my.file.box" /></a></li><!-- 개인자료실 -->
							<%-- <li><a href="/dashboard/profDashboard.do?sample=1" title="<spring:message code="filemgr.label.my.file.box" />"><i class="icon-floppy-diskette ico" aria-hidden="true"></i>위젯 샘플1</a></li> --%><!-- 위젯 샘플1 -->
							<%-- <li><a href="/dashboard/profDashboard.do?sample=2" title="<spring:message code="filemgr.label.my.file.box" />"><i class="icon-floppy-diskette ico" aria-hidden="true"></i>위젯 샘플2</a></li> --%><!-- 위젯 샘플2 -->
						</ul>
	
					</div>
					<%
                }
				// 다른기관
                else {
                   	%>
                   	<div class="menu">
	                   	<ul class="c_item">
							<li><a href="/file/fileHome/Form/fileBox.do" title="<spring:message code="filemgr.label.my.file.box" />"><i class="icon-floppy-diskette ico" aria-hidden="true"></i><spring:message code="filemgr.label.my.file.box" /></a></li><!-- 개인자료실 -->
							
							<li><a href="/score/scoreOverall/scoreOverallMainList.do"><i class="icon-paper-pencil ico" aria-hidden="true"></i></i><spring:message code="score.label.university.score" /></a></li><!-- 종합성적 -->
							<li><a href="/score/scoreOverall/scoreOverallCourseMain.do"><i class="icon-paper-pencil ico" aria-hidden="true"></i></i><spring:message code="common.label.score.reconfirm" /></a></li><!-- 성적재확인 -->
							<li><a href="/stats/profLrnPrgrtListView.do"><i class="icon-paper-pencil ico" aria-hidden="true"></i></i><spring:message code="common.label.lesson.process.manage" /></a></li><!-- 학습진도관리 -->
							
							<li><a href="javascript:return false;" title="<spring:message code="common.label.lesson.statistics" />"><i class="icon-statistics ico" aria-hidden="true"></i><spring:message code="common.label.lesson.statistics" /></a></li><!-- 학습통계 -->
						</ul>
					</div>
                   	<%
                }
			}
			%>
		</div>
		<!-- //메뉴 영역 -->
	</div>
	
	<script>
		// 학습자 탭 로그 등록
		function openTab(goUrl, tab) {
			var urlMap = {
				"portal" 			: "<spring:message code='common.label.knou.university' /> <spring:message code='common.label.connect' />",	// 한사대로 접속
				"mail"   			: "<spring:message code='common.mail' /> <spring:message code='common.label.connect' />",	// 메일 접속
				"haksa"  		    : "<spring:message code='crs.title.calendar' /> <spring:message code='common.label.connect' />",	// 학사일정 접속
				"scholarship" 	    : "<spring:message code='common.an.application.for.scholarship' /> <spring:message code='common.label.connect' />",	// 장학신청 접속
				"graduate"		    : "<spring:message code='common.graduation.diagnosis' /> <spring:message code='common.label.connect' />",	// 졸업진단 접속
				"myInfo"			: "<spring:message code='common.my.information' /> <spring:message code='exam.button.check' />",	// 내정보 확인
				"deptComm"		    : "<spring:message code='common.academic.community' /> <spring:message code='common.label.connect' />"	// 학과커뮤니티 접속
			};
			var url = "/logLesson/saveLessonActnHsty.do";
			var data = {
				  actnHstyCd	: "COURSE_HOME"
				, actnHstyCts	: urlMap[tab]
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					window.open(goUrl, "_blank");
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				/* 에러가 발생했습니다! */
				alert('<spring:message code="fail.common.msg" />');
			});
		}
	
		// 내정보 관리 팝업
		function userProfilePop(userId) {
			$("#profileForm").remove();
			var url  = "/user/userHome/userProfilePop.do";
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("id", "profileForm");
			form.attr("target", "userProfilePopIfm");
			form.attr("action", url);
			form.append($('<input/>', {type: 'hidden', name: 'userId', 	value: userId}));
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
			if(width <= 1280) {
				if( document.querySelector(".gnb") !== null ){ 
					document.querySelector(".gnb").classList.remove("on");
					document.querySelector(".menu_btn").classList.remove("on");
					document.querySelector("body").classList.remove("gnbon");
				}
			}
		});
		
		function listSchedule(type) {
			var now	  = new Date("${fn:substring(today, 0, 4)}", parseInt("${fn:substring(today, 4, 6)}")-1, "${fn:substring(today, 6, 8)}");
			var startDay = now.getDay() > 1 ? (now.getDay() - 1) * -1 : now.getDay() < 1 ? -6 : 0;
			var endDay   = now.getDay() > 0 ? 7 - now.getDay() : 0;
			var start	= new Date(now.setDate(now.getDate()+startDay));
			now.setDate(now.getDate()-startDay);
			var end		 = new Date(now.setDate(now.getDate()+endDay));
			if(type == "next") {
				start 	 = new Date(start.setDate(start.getDate()+7));
				end		 = new Date(end.setDate(end.getDate()+7));
			}
			var startDt  = start.getFullYear() + "" + pad(start.getMonth()+1,2) + "" + pad(start.getDate(),2);
			var endDt	 = end.getFullYear() + "" + pad(end.getMonth()+1,2) + "" + pad(end.getDate(),2);
			var url  = "/dashboard/schCalendarList.do";
			
			var data = {
				"startDt" 	  		: startDt,
				"endDt" 	  			: endDt,
				"termCd"	  		: "<%=SessionInfo.getCurTerm(request) %>",
				"searchGubun" 	: type,
				"uniCd"		  		: "${param.uniCd}",
				"coList"				: "${param.coList}"
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					var html = "";
					
					if(returnList.length > 0) {
						returnList.forEach(function(v, i) {
							var startDt = v.startDt.substring(4,6)+"."+v.startDt.substring(6,8);
							var endDt	= v.endDt.substring(4,6)+"."+v.endDt.substring(6,8);
							
							html += "<div class='item on'>";
							html += "<small>"+startDt+" ~ "+endDt+"</small>";
							html += "	<div class='ci_item_box'>";
							html += "		<div class='ci_item'>";
							html += "			<p>"+v.title+"</p>";
							html += "			<small class='opacity7'>"+v.name+"<spring:message code='crs.label.room' /></small>";
							html += "		</div>";
							html += "	</div>";
							html += "</div>";
						});
					} else {
						html += "<div class='flex-container'>";
						html += "<div class='cont-none'><i class='icon-list-no ico'></i><span><spring:message code='sys.alert.already.job.sch' /></span></div>";/* 등록된 일정이 없습니다. */
						html += "</div>";
					}
					
					if (type == "this") {
						$("#schedule_tab1").html(html);
					} else {
						$("#schedule_tab2").html(html);
					}
				}
			}, function(xhr, status, error) {
				console.log("에러가 발생했습니다! [week schedule]");
			}, false);
		}
		
		function goLectEval() {
			alert("[준비중] 강의평가");
			/*
			var url = "/jobSchHome/checkLectEvalPeriod.do";
			var data = {
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var evalUrl = '<%=SessionInfo.getLectEvalUrl(request)%>';
	        		window.open(evalUrl, '_blank');
	        	} else if(data.result == 0) {
	        		alert("<spring:message code='sch.alert.no.eval.period' />"); // 강의평가 기간이 아닙니다.
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert("<spring:message code='exam.error.info' />"); // 정보 조회 중 에러가 발생하였습니다.
			});
			*/
		}
		
		$(".listTab2 > * ").on('click', function(e) {
			this.parentNode.querySelectorAll(".listTab2 > * ").forEach( elem => { elem.classList.remove("active"); });
			$(this).addClass("active");

			[...document.querySelector("." + this.parentNode.dataset.target).children].map(elem => elem.classList.remove("on") );
			[...document.querySelector("." + this.parentNode.dataset.target).children].map(elem => {
				"#"+elem.id === $(this).data('target') ? elem.classList.add("on") : ' ' ;
			});
			
			var tabStr = $(this).attr("data-target") == "#schedule_tab1" ? "금주일정 확인" : "차주일정 확인";
			var url = "/logLesson/saveLessonActnHsty.do";
			var data = {
				  actnHstyCd	: "COURSE_HOME"
				, actnHstyCts	: tabStr
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
		});

		sessionStorage.setItem("CLS_PAR_MENU_CD", null);
		sessionStorage.setItem("CLS_MENU_CD", null);
	</script>
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
				<iframe src="" id="userProfilePopIfm" name="userProfilePopIfm" width="100%" scrolling="no" title="MyInfo"></iframe>
			</div>
		</div>
	</div>
</div>
