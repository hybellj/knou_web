<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/main_default.css?v=3" />
	<script type="text/javascript">
		$(document).ready(function() {
			var lectEvalViewYn = "<c:out value="${lectEvalViewYn}"/>";
			
			if(lectEvalViewYn == "Y") {
	            var resultValue = "N";
	            var userId = "<%=SessionInfo.getUserId(request)%>";
	            var url = "<%=CommConst.ERP_API_LECT_EVAL_KEY%>" + userId + "/findLtApprUnRunLtCnt"; 
	            var data = {};
	            
	            $.ajax({
	                url : url
	                , type: "GET"
	                //, data : data
	                , beforeSend: function (xhr) {
	                    xhr.setRequestHeader("Content-type","application/json");
	                    xhr.setRequestHeader("ApiValue", "${langApiHeader}");
	                }                
	                , success: function (data) {
	                      if (data.code == "1") {
	                          if (parseInt(data.result) > 0) {
	                        	  popupNoticeModal();
	                          } 
	                      }
	                }
	                , error: function (jqXHR) 
	                { 
	                    console.log(jqXHR.responseText); 
	                }            
	            }); 
			} else {
				popupNoticeModal();
			}
			
			// 탭 자동선택
			var tabCd = '<c:out value="${param.tabCd}" />';
			
			if(tabCd == "LEGAL") {
				$("#legalTab").trigger("click");
			}
		});
		
		function languageApiCheck() {
			$.ajax({
		        type: "GET",
		        url: "${langApiUrl}",
		        beforeSend: function (xhr) {
		            xhr.setRequestHeader("Content-type","application/json");
		            xhr.setRequestHeader("ApiValue", "${langApiHeader}");
		        },
		        success: function (data) {
		            if (data.code == "1") {
		            	let lang = "<%=SessionInfo.getLocaleKey(request)%>";
		            	let apiLang = "ko";
		            	if (data.result == "2") {
		            		apiLang = "en";
		            	}
		            	if (lang != apiLang) {
		            		document.location.href = "/dashboard/main.do?language="+apiLang;
		            	}
		            }
		        },
		        timeout: 3000
		    });
		}
		<c:if test="${langApiCheck == 'Y'}">
			languageApiCheck();
		</c:if>
		
		// 팝업공지 모달
		function popupNoticeModal() {
			var popNoticeSn = "${popupNoticeVO.popNoticeSn}";
			var noticeTitle = "${popupNoticeVO.noticeTitle}" || "팝업공지";
			var xPercent = "${popupNoticeVO.xPercent}" || "50";
			var lectEvalUrl = "${lectEvalUrl}" || "50";
			var legalStdOpenYn = "${popupNoticeVO.legalStdOpenYn}" || "N";
			var legalPopUseYn = "${legalPopUseYn}" || "N";
			
			if(legalStdOpenYn == "Y" && legalPopUseYn != "Y") {
				return;
			}
		    
			if(popNoticeSn) {
				$("#popupNoticeTitle").text(noticeTitle);
				$("#popupNoticeDiv").css("width", xPercent + "%");
				
				$("#popupNoticeForm input[name=popNoticeSn]").val(popNoticeSn);
				$("#popupNoticeForm input[name=lectEvalUrl]").val(lectEvalUrl);
				$("#popupNoticeForm").attr("target", "popupNoticeIfm");
		        $("#popupNoticeForm").attr("action", "/sch/schHome/popupNoticeViewPop.do");
		        $("#popupNoticeForm").submit();
		        $("#popupNoticeModal").modal("show");
			}
		}
	</script>
	
    <body class="<%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap" class="main">

			<!-- class_top 인클루드  -->
			<%
			// 기관:한사대
            if (SessionInfo.isKnou(request)) {
				%>
				<jsp:include page="/WEB-INF/jsp/common/frontLnb.jsp">
					<jsp:param name="coList" value="${coList}" />
				</jsp:include>
				<%
            }
			%>

                <div id="container" class="ui form">
                    
                        <%@ include file="/WEB-INF/jsp/common/frontGnb.jsp" %>

                        	<!-- 본문 content 부분 -->
                            <main class="common">

                                <div class="col-left"> 

                                    <!-- 정보+아이콘 -->
                                    <ul class="infoIconSet" style="<%=("mobile".equals(SessionInfo.getDeviceType(request)) ? "display:none" : "")%>">
                                    	<!-- 현재주차 -->
                                        <li class="info bcPurpleAlpha85">
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
                                        
                                            <div class="flex-item">
                                                <div class="alt_icon">
                                                    <i class="icon-calender-check ico" aria-hidden="true"></i>
                                                </div>
                                                <div class="alt_txt ">
                                                    <c:out value="${lsnOdr}"/><small class=""><spring:message code="common.label.lesson.schedule" /></small><!-- 주차 -->
                                                </div>
                                            </div>
                                            <c:if test="${not empty dashboardCurrentWeek}">
                                            	<small class=""><c:out value="${startDt}"/> ~ <c:out value="${endDt}"/></small>
                                            </c:if>
                                        </li>
                                        
                                        <!-- 접속자 -->
                                        <li class="info bcDarkblueAlpha85 connStat">    
                                            <div class="flex-item">                                  
                                                <div class="alt_icon"><i class="icon-users ico " aria-hidden="true"></i></div>
                                                <div class="tooltiptext tooltip-top alertToggle flex1 flex-justify-right"><spring:message code="dashboard.connect" /><i class="ion-ios-arrow-down"></i></div><!-- 접속 -->
                                            </div>
                                            <div class="alt_txt">${userConnCnt}<span>${stdCnt}</span></div>                            
                                            <!-- alert_modal -->
                                            <div class="alert_modal">
                                                <div class="sort_btn">
                                                    <button type="button" onclick="sortUserConnList('USER_NM')"><spring:message code="dashboard.user_name" /><i class="sort amount up icon"></i></button><!-- 이름 -->
                                                </div>
                                                <div class="scrollbox">
                                                    <!-- style="height:200px" -->
                                                    <ul class="u_list" id="userConnList">
                                                    	<c:forEach var="user" items="${userConnList}">
	                                                        <li data-conn-user-no="${user.userId}" data-conn-user-nm="${user.userNm}">
	                                                            <div class="initial-img sm bcLgrey">
	                                                            	<c:if test="${not empty user.phtFile}">
	                                                            		<img src="${user.phtFile}" alt="photo">
	                                                            	</c:if>
	                                                            	<c:if test="${empty user.phtFile}">
	                                                            		<img src="/webdoc/img/icon-hycu-symbol-grey.svg" alt="photo">
	                                                            	</c:if>
	                                                            </div>
	                                                            <div>
	                                                            	<span class="u_name">${user.userNm}</span>
	                                                            </div>
	                                                            <div class="btn_wrap">
	                                                            </div>
	                                                        </li>
                                                    	</c:forEach>
                                                    </ul>
                                                </div>
                                            </div>
                                            <!-- //alert_modal -->                                                                           
                                        </li>
                                        
                                        <!-- 전체출석 -->
                                        <li class="info">
                                           	<c:set var="totalLessonCnt" value="0" />
											<c:set var="totalCompleteCnt" value="0" />
                                           	<c:forEach var="cors" items="${corsList}" varStatus="status">
                                           		<c:if test="${cors.auditYn ne 'Y'}">
	                                           		<c:forEach var="lesn" items="${cors.lessonScheduleList}" varStatus="weekStatus">
	                                           			<c:if test="${lesn.wekClsfGbn ne '04' and lesn.wekClsfGbn ne '05'}">
							                    			<c:if test="${lesn.startDtYn eq 'Y' and (lesn.wekClsfGbn eq '02' or lesn.wekClsfGbn eq '03' or lesn.prgrVideoCnt > 0)}">
								                    			<c:set var="totalLessonCnt" value="${totalLessonCnt + 1}" />
								                    		</c:if>
								                    		<c:if test="${lesn.startDtYn eq 'Y' and (lesn.wekClsfGbn eq '02' or lesn.wekClsfGbn eq '03' or lesn.prgrVideoCnt > 0) and (lesn.studyStatusCd eq 'LATE' or lesn.studyStatusCd eq 'COMPLETE')}">
							                    				<c:set var="totalCompleteCnt" value="${totalCompleteCnt + 1}" />
							                    			</c:if>
					                    				</c:if>
		                                            </c:forEach>
	                                            </c:if>
	                                        </c:forEach>
                                            <div class="flex-item">
                                            	<div class="alt_icon"><i class="icon-timewatch ico" aria-hidden="true"></i></div>                                          
                                                <!-- <div class="alt_icon"><i class="icon-alert-triangle ico" aria-hidden="true"></i></div> -->
                                                <span class="tooltiptext tooltip-top"><spring:message code="common.label.all.attendance" /></span><!-- 전체출석 -->
                                            </div>
                                            <div class="alt_txt"><c:out value="${totalCompleteCnt}"/><span><c:out value="${totalLessonCnt}"/></span></div>
                                        </li>
                                        
                                        <!-- 결시원 -->
                                        <c:if test="${examAbsentPeroidYn eq 'Y'}">
	                                        <li class="info" onclick="location.href='/exam/Form/stuExamAbsentList.do'">
	                                        	<div class="flex-item">                                        
	                                                <div class="alt_icon"><i class="icon-user-no ico" aria-hidden="true"></i></div>
	                                                <span class="tooltiptext tooltip-top"><spring:message code="dashboard.absent" /></span><!-- 결시원 -->
	                                            </div>
	                                            <div class="alt_txt"><c:out value="${empty dashboardStat ? '0': dashboardStat.examAbsentApproveCnt}"/><span><c:out value="${empty dashboardStat ? '0': dashboardStat.examAbsentCnt}"/></span></div>
	                                        </li>
                                        </c:if>

										<!-- 성적재확인 신청(이의신청) -->
										<c:if test="${scoreObjtPeriodYn eq 'Y'}">
	                                        <li class="info">
	                                        	<div class="flex-item">
	                                                <div class="alt_icon"><i class="icon-user-question ico" aria-hidden="true"></i></div>
	                                                <span class="tooltiptext tooltip-top"><spring:message code="common.label.score.reconfirm.yn" /></span><!-- 성적재확인 신청 -->
	                                            </div>
	                                           <div class="alt_txt"><c:out value="${empty dashboardStat ? '0': dashboardStat.scoreObjtProcCnt}"/><span><c:out value="${empty dashboardStat ? '0': dashboardStat.scoreObjtCnt}"/></span></div>
	                                        </li>
                                        </c:if>
                                        
                                        <!-- 장애인지원 -->
                                        <%-- <c:if test="${dsblReqPeriodYn eq 'Y'}"> --%>
                                        <c:if test="${disablilityYn eq 'Y'}">
	                                        <li class="info">
	                                        	<div class="flex-item">
	                                                <div class="alt_icon"><i class="icon-wheelchair ico" aria-hidden="true"></i></div>
	                                                <span class="tooltiptext tooltip-top"><spring:message code="dashboard.dsbl_support" /></span><!-- 장애인지원 -->
	                                            </div>
	                                            <div class="alt_txt"><c:out value="${empty dashboardStat ? '0': dashboardStat.examDsblReqApproveCnt}"/><span><c:out value="${empty dashboardStat ? '0': dashboardStat.examDsblReqCnt}"/></span></div>
	                                        </li>
                                        </c:if>
                                    </ul>
                                    <!-- //정보+아이콘 -->

                                    <!-- 강의이어보기 -->
                                    <div class="component44">
                                        <div class="option-content">
                                            <div class="sec_head">
                                                <spring:message code="lesson.label.continue_learning"/> <!-- 강의 이어보기 -->
                                            </div>
                                        </div>
                                        <div class="cont_body">
                                           	<c:choose>
                                           		<c:when test="${listStdUncompletedLesson.size() > 0}">
                                                 <ul class="tempSlide">
                                                 	<c:forEach items="${listStdUncompletedLesson}" var="row">
		                                                <li>
		                                                    <a href="javascript:void(0)" onclick="checkEnterMoveCrs('<c:out value="${row.crsCreCd}"/>', '/crs/crsHomeStdRedirect.do?crsCreCd=<c:out value="${row.crsCreCd}"/>&viewLessonScheduleId=<c:out value="${row.lessonScheduleId}"/>')">
		                                                        <div class="n_tit">
		                                                            <p class="head">
		                                                                <span>[<c:out value="${row.crsCreNm}"/> (<c:out value="${row.declsNo}"/>)] <c:out value="${row.lessonScheduleOrder}"/><spring:message code="lesson.label.progress.week"/><!-- 주차 --></span>
		                                                            </p>
		                                                            <p class="sub">
		                                                                <small><c:out value="${row.prgrRatio}"/>% (<c:out value="${row.mi}"/>:<c:out value="${row.sec}"/>)</small>
		                                                            </p>
		                                                        </div>
		                                                    </a>
		                                                </li>
                                					</c:forEach>
                                                 </ul>
                                                 <script>
                                                 $('.tempSlide').slick({
                                                     infinite: true,
                                                     slidesToShow: 1,
                                                     slidesToScroll: 1,
                                                     autoplay : false,
                                                     dots: true,                                                        
                                                     customPaging: function (slider, i) {
                                                         slider.$slider[0].classList.add('page_num');
                                                         slider.$slider[0].dataset.slidecount = slider.slideCount; //Math.ceil( /2)
                                                         slider.$slider[0].dataset.slidecountMobile = slider.slideCount;
                                                         return  "<span>" + (i + 1) + "</span>";  
                                                     }
                                                 });
                                                 </script>
                                           		</c:when>
                                           		<c:otherwise>
                                           			<div class="ui message tc"><spring:message code="lesson.alert.message.no_continue_lesson" /><!-- 이어보기 가능한 강의가 없습니다. --></div>
                                           		</c:otherwise>
                                           	</c:choose>
                                        </div>
                                    </div>
                                    <!-- //강의이어보기 -->
                                <%
								// 기관:한사대만 메시지 표시
						        if (SessionInfo.isKnou(request)) {
						           	%>
                                    <!-- PUSH/쪽지 글목록 -->
                                    <div id="stuDashMsgDiv" class="component55 p2" style="overflow: hidden;">
	                                    <div class="menu">
	                                    	<div class=" ui pointing secondary tabmenu tMenubar ml8 mr8 flex">
												<a class="tmItem active" data-dash-tab="PUSH">PUSH<small class="msg_num" id="dashPushCount">0</small></a>
												<a class="tmItem" data-dash-tab="MSG"><spring:message code="exam.button.eval.msg" /><small class="msg_num" id="dashMsgCount">0</small></a><!-- 쪽지 -->
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
										<div class="p8 ui tab" id="dashMsgList" style="height: 100%;">
											<div class="flex-container m-hAuto">
												<div class="no_content">
													<span><spring:message code='common.message.sysmsg.alt4'/></span><!-- 수신한 메시지가 없습니다. -->
													<a href="javascript:stuDashMsg.moveMsgList('N')" class="ui basic small button mt5"><spring:message code="common.button.viewMsgBox"/></a>
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
			                                		} else if(dashTab == "MSG") {
			                                			$("#dashMsgList").show();
			                                			$("#dashPushList").hide();
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
                                </div>
								
                                <div class="mainCnt">

                                    <!-- 공지글 -->
                                    <div class="component33 off" data-medi-ui="more-off" data-ctrl-off="<spring:message code="common.label.view.more" />"><!-- 더보기 -->

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
                                            <div data-target="#tab3"><spring:message code="dashboard.course_qna"/><span class="msg_num">${not empty qnaNoAnsInfo ? qnaNoAnsInfo.ansCnt : 0}/${not empty qnaNoAnsInfo ? qnaNoAnsInfo.totalCnt : 0}</span></div><%-- 강의 Q&A --%>
                                            <div data-target="#tab4"><spring:message code="dashboard.councel"/><span class="msg_num">${not empty secretNoAnsInfo ? secretNoAnsInfo.ansCnt : 0}/${not empty secretNoAnsInfo ? secretNoAnsInfo.totalCnt : 0}</span></div><%-- 1:1 상담 --%>
                                        </div>  
                                        <!-- //탭메뉴 -->

                                        <!-- 탭메뉴_콘텐츠 -->
                                        <div class="tab_contents1"> 
                                            <div id="tab1" class="tab_content on">
                                            	<c:choose>
                                                	<c:when test="${isKnou eq 'true'}">
                                                		<div class="cont_header">
		                                                    <button class="btn-icon more" aria-label="<spring:message code="common.label.view.more" />" onclick="document.location.href='/bbs/bbsHome/atclList.do?bbsId=${sysNoticeId}&uniCd=${uniCd}';" title="<spring:message code="common.label.view.more" />"><i class="ion-plus"></i></button><!-- 더보기 -->
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
			                                                                        <small><spring:message code="bbs.label.view" /> : <c:out value="${notice.hits}"/></small><!-- 조회 -->
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
				                                                             <a href="javascript:checkEnterMoveCrs('${notice.crsCreCd}', '/bbs/bbsLect/Form/atclView.do?crsCreCd=${notice.crsCreCd}&bbsId=${notice.bbsId}&atclId=${notice.atclId}')" title="<c:out value="${notice.atclTitle}"/>">
				                                                                 <div class="n_tit <c:if test="${notice.viewYn eq 'Y'}">opacity7</c:if>">
				                                                                     <p class="head">
				                                                                         <span><c:out value="${notice.atclTitle}"/></span>
				                                                                         <c:if test="${notice.isNew eq 'Y' and notice.viewYn ne 'Y'}">
																				    	<i class="ui pink circular mini label f060"></i>
																						</c:if>
				                                                                     </p>
				                                                                     <span class="sub"><c:out value="${notice.crsCreNm}"/> (<c:out value="${notice.declsNo}"/><spring:message code="dashboard.cor.dev_class" />)</span><!-- 반 -->
				                                                                 </div>
				
				                                                                 <div class="n_date">
				                                                                     <small><spring:message code="bbs.label.view" /> : <c:out value="${notice.hits}"/></small><!-- 조회 -->
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
				                                                             <a href="javascript:checkEnterMoveCrs('${notice.crsCreCd}', '/bbs/bbsLect/Form/atclView.do?crsCreCd=${notice.crsCreCd}&bbsId=${notice.bbsId}&atclId=${notice.atclId}')" title="<c:out value="${notice.atclTitle}"/>">
				                                                                 <div class="n_tit <c:if test="${notice.viewYn eq 'Y'}">opacity7</c:if>">
				                                                                     <p class="head">
				                                                                         <span><c:out value="${notice.atclTitle}"/></span>
				                                                                         <c:if test="${notice.isNew eq 'Y' and notice.viewYn ne 'Y'}">
																				    	<i class="ui pink circular mini label f060"></i>
																						</c:if>
				                                                                     </p>
				                                                                     <span class="sub"><c:out value="${notice.crsCreNm}"/> (<c:out value="${notice.declsNo}"/><spring:message code="dashboard.cor.dev_class" />)</span><!-- 반 -->
				                                                                 </div>
				
				                                                                 <div class="n_date">
				                                                                     <small><spring:message code="bbs.label.view" /> : <c:out value="${notice.hits}"/></small><!-- 조회 -->
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
		                                                    <button class="btn-icon more" aria-label="<spring:message code="common.label.view.more" />" onclick="document.location.href='/bbs/bbsHome/atclList.do?bbsId=${sysNoticeId}&uniCd=${uniCd}';" title="<spring:message code="common.label.view.more" />"><i class="ion-plus"></i></button><!-- 더보기 -->
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
			                                                                        <small><spring:message code="bbs.label.view" /> : <c:out value="${notice.hits}"/></small><!-- 조회 -->
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
	                                                            <a href="javascript:checkEnterMoveCrs('${notice.crsCreCd}', '/bbs/bbsLect/Form/atclView.do?crsCreCd=${notice.crsCreCd}&bbsId=${notice.bbsId}&atclId=${notice.atclId}')" title="<c:out value="${notice.atclTitle}"/>">
	                                                                <div class="n_tit <c:if test="${notice.ansViewYn eq 'Y'}">opacity7</c:if>">
	                                                                    <p class="head">
	                                                                        <span><c:out value="${notice.atclTitle}"/></span>
	                                                                        <c:if test="${notice.isNew eq 'Y' and notice.viewYn ne 'Y'}">
																			    <i class="ui pink circular mini label f060"></i>
																			</c:if>
	                                                                    </p>
	                                                                    <span class="sub"><c:out value="${notice.crsCreNm}"/> (<c:out value="${notice.declsNo}"/><spring:message code="dashboard.cor.dev_class" />)</span><!-- 반 -->
	                                                                </div>
	
	                                                                <div class="n_date">
	                                                                	<c:choose >
				                                                            <c:when test="${notice.answerYn eq 'Y'}">
																	            <small class="ui green small label"><spring:message code="dashboard.qna.answer"/></small><!-- 답변 -->
																	        </c:when>
																	        <c:otherwise>
																	            <small class="ui orange small label"><spring:message code="dashboard.qna.wait"/></small><!-- 미답변 -->
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
	                                                    	<c:forEach var="notice" items="${cosSecretList}" varStatus="status">
	                                                    		<c:if test="${status.index < 4}">
		                                                     	<li>
		                                                             <a href="javascript:checkEnterMoveCrs('${notice.crsCreCd}', '/bbs/bbsLect/Form/atclView.do?crsCreCd=${notice.crsCreCd}&bbsId=${notice.bbsId}&atclId=${notice.atclId}')" title="<c:out value="${notice.atclTitle}"/>">
		                                                                 <div class="n_tit <c:if test="${notice.ansViewYn eq 'Y'}">opacity7</c:if>">
		                                                                     <p class="head">
		                                                                         <span><c:out value="${notice.atclTitle}"/></span>
		                                                                         <c:if test="${notice.isNew eq 'Y' and notice.viewYn ne 'Y'}">
																		    	<i class="ui pink circular mini label f060"></i>
																				</c:if>
		                                                                     </p>
		                                                                     <span class="sub"><c:out value="${notice.crsCreNm}"/> (<c:out value="${notice.declsNo}"/><spring:message code="dashboard.cor.dev_class" />)</span><!-- 반 -->
		                                                                 </div>
		
		                                                                 <div class="n_date">
		                                                                 	<c:choose >
			                                                                  	<c:when test="${notice.answerYn eq 'Y'}">
																		            <small class="ui green small label"><spring:message code="dashboard.qna.answer"/></small> <!-- 답변 -->
																		        </c:when>
																		        <c:otherwise>
																		            <small class="ui orange small label"><spring:message code="dashboard.qna.wait"/></small><!-- 미답변 -->
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
                                        </div>
                                        <!-- //탭메뉴_콘텐츠 -->
                                            
                                    </div>
                                    <!-- //공지글 -->

                                	<!-- 과목일정 -->
                                    <div class="component22" style="<%=("mobile".equals(SessionInfo.getDeviceType(request)) ? "display:none" : "")%>">
                                    	<input type="hidden" id="calStartDt" value="${today }" />
                                        <div class="option-content">
                                            <div class="sec_head"><spring:message code="crs.title.subject.calendar" /></div><!-- 과목일정 -->
                                                <div class="panel-head">
                                                    <a class="btn-prev" href="#0" onclick="moveMonth('prev');return false;"><i class="ion-ios-arrow-back"></i><span class="blind">Prev</span></a>
                                                    <div id="corCalendarMonth" class="this-month">-<small><spring:message code="exam.label.month" /></small></div><!-- 월 -->
                                                    <a class="btn-next" href="#0"  onclick="moveMonth('next');return false;"><i class="ion-ios-arrow-forward"></i><span class="blind">Next</span></a>
                                                </div>
                                        </div>
                                        <ul id="corCalendar" class="">
                                        </ul>
                                        
	                                    <script type="text/javascript">
	                                    	listSchedule('course', '${today}');
		                                    
		                                	// 활동 로그 등록
		                    	        	$(".connStat").on("click", function(e) {
		                    	        		if($(this).children(".flex-item").children("div.tooltiptext.tooltip-top.alertToggle").hasClass("on")) {
		                    	        			var url = "/logLesson/saveLessonActnHsty.do";
		                    	        			var data = {
		                    	        				  actnHstyCd	: "COURSE_HOME"
		                    	        				, actnHstyCts	: "<spring:message code='crs.site.access.state.check' />" // <!-- 접속현황 확인 -->
		                    	        			};

		                    	        			ajaxCall(url, data, function(data) {
		                    	        				if(data.result > 0) {
		                    	        				} else {
		                    	        					alert(data.message);
		                    	        				}
		                    	        			}, function(xhr, status, error) {
		                    	        				console.log('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
		                    	        			});
		                    	        		}
		                    	        	});
		                                	
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
		                                		var url  = "/dashboard/stuSchCalendarList.do";

		                						var data = {
		                								"searchKey"	: type,
		                								"startDt"	: startDt,
		                								"endDt"		: endDt,
		                								"termCd"	: "${dashboardVO.termCd}",
		                								"uniCd"		: "${param.uniCd}",
		                								"coList"	: "${coListStr}",
		                						};
		                                		
		                                		$("#corCalendarMonth").html(showCorCalendarMonth(parseInt(startDt.substring(4,6)))); // 월
		                                		
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
		                                        				var prefix = v.prefix || "";
		                                        				
		                                        				if(v.scheduleGubun != "EXAM") {
		                                        					prefix = "";
		                                        				}
		                                        				
		                                        				html += "<li>";
	                                            				html += "	<small class='s_date'>" + date + "</small>";
	                                            				html += "	<div class='s_txt'>";
	                                            				html += "		<p class=''>" + prefix + " " + v.title + "</p>";
	                                            				html += "		<span class='sub' style='font-size:0.9em'>";
	                                            				html += "			" + v.name + "<spring:message code='crs.label.room' />";
	                                            				html += "		</span>";
	                                            				html += "	</div>";
	                                            				html += "</li>";
		                                        			});
		                                        			$("#corCalendar").html(html);
		                                        		} else {
		                            	        			html += "<li class='p_h100'><div class='flex-container min-height-auto'>";
		                            	        			html += "<div class='cont-none'><i class='icon-list-no ico'></i><span class=''><spring:message code='common.content.not_found'/></span></div>";
		                            	        			html += "</div></li>";
		                            	        			
		                            	        			$("#corCalendar").html(html);
		                                        		}
		                                        	} else {
		                                        		//alert(data.message);
		                                        	}
		                                		}, function(xhr, status, error) {
		                                			// alert("에러가 발생했습니다! [schedule]");
		                                			console.log("<spring:message code='fail.common.msg' /> [schedule]");
		                                		}, false);
		                                	}
		                                	
		                                	// 언어별 월 표시
		                                	function showCorCalendarMonth(mon) {
		                                		var monStr = "";
		                                		var lang = "<%=SessionInfo.getLocaleKey(request)%>";
		                                		if (lang == "en") {
		                                			monStr = mon;
		                                			monStr += "<small>";
		                                			if (mon == 1) monStr += "Jan";
		                                			else if (mon == 2) monStr += "Feb";
		                                			else if (mon == 3) monStr += "Mar";
		                                			else if (mon == 4) monStr += "Apr";
		                                			else if (mon == 5) monStr += "May";
		                                			else if (mon == 6) monStr += "Jun";
		                                			else if (mon == 7) monStr += "Jul";
		                                			else if (mon == 8) monStr += "Aug";
		                                			else if (mon == 9) monStr += "Sep";
		                                			else if (mon == 10) monStr += "Oct";
		                                			else if (mon == 11) monStr += "Nov";
		                                			else if (mon == 12) monStr += "Dec";
		                                			monStr += "</small>";
		                                		}
		                                		else {
		                                			monStr = mon + "<small><spring:message code='date.month' /></small>";
		                                		}
		                                		return monStr;
		                                	}
	                                    </script>
                                        
                                    </div>
                                    <!-- //과목일정 -->

                                    <!-- 과목 -->
                                    <div class="col-12 component55">
                                        <div class="option-content header2">                                                    
                                            <div class="listTab2" data-target="tab_contents2">
                                                <a data-target="#tab5" class="<c:if test="${empty param.tabCd or param.tabCd eq '1'}">active</c:if>" data-course-tab="1"><h3><spring:message code="common.label.enroll.course" /></h3></a><!-- 수강과목 -->
                                                <%
                                                if (SessionInfo.isKnou(request)) {
                                                	%>
                                                	<a data-target="#tab6" class="<c:if test="${param.tabCd eq '2'}">active</c:if>" data-course-tab="2" id="legalTab"><h3><spring:message code="dashboard.course.legal" /></h3></a><!-- 법정과목 -->
                                                	<%
                                                }
                                                %>
                                            </div>
                                            <div class="select_area">
		                                    	<div style="display:inline-block;width:200px;">
		                                    		<label for="courseTerm" class="blind"><spring:message code="sys.label.select.haksa.term" /></label><!-- 학기선택 -->
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
				                                     		document.location.href = "<c:url value='/dashboard/stuDashboard.do'/>?termCd="+termCd + "&tabCd=" + tabCd;
				                                     	}
			                                        </script>
		                                        </div>
                                            </div>
                                        </div>      
                                        <div class="tab_contents2">
                                            <div id="tab5" class="tab_content <c:if test="${empty param.tabCd or param.tabCd eq '1'}">on</c:if>">  
												
												<!-- 수강과목 목록 -->
                                                <%@ include file="/WEB-INF/jsp/dashboard/stu_dashboard_cors_list.jsp" %>
                                                    
                                            </div>
                                            <div id="tab6" class="tab_content <c:if test="${param.tabCd eq '2'}">on</c:if>">
                                            	
                                            	<!-- 법정과목 목록 -->
                                            	<%@ include file="/WEB-INF/jsp/dashboard/stu_dashboard_cors_legal_list.jsp" %>
                                            	
                                            </div>
                                        </div>
                                    </div>
                                    <!-- //과목 -->


									<!-- 학점교류 과목 -->
									<c:if test="${not empty hpIntchList}">
										<div class="col-12 component55">
	                                        <div class="option-content header2">                                                    
	                                            <div class="listTab2" data-target="tab_contents3" style="margin-bottom:-13px;">
	                                                <a data-target="#tab6" class="active"><h3>학점교류 과목</h3></a><!-- 학점교류 과목 -->
	                                            </div>
	                                        </div>
	                                        
	                                        <div class="tab_contents3">
	                                            <div id="tab6" class="tab_content on">
	                                            	<c:forEach var="cors" items="${hpIntchList}" varStatus="status">
	                                            		<section class="item">
														    <div class="header" style="max-width:100%;width:100%">
														    	<div class="option-content" style="display: table;width:100%">
														    		<div class="fcDark4 f110 fwb" style="display:table-cell;">${cors.scNm}</div>
	                                            					<div class="tr fcDark4" style="display:table-cell;">
	                                            						${cors.urlNm}
	                                            						<c:if test="${empty cors.urlNm}">-</c:if>
	                                            						<c:if test="${not empty cors.url}">
	                                            							(<a href="${cors.url}" title="${cors.urlNm}" target="_blank" class="fwb f100">${cors.url}</a>)
	                                            						</c:if>
	                                            					</div>
	                                            				</div>
	                                            			</div>
	                                            		</section>
	                                            	</c:forEach>
	                                            </div>
	                                        </div>
	                                    </div>
									</c:if>
									<!-- //학점교류 과목 -->
                                </div>
                            </main>

                            <script type="text/javascript">
	                            var $userConnList;
	            	        	var userNmOrder = "ASC";
	            	        	
	            	        	$(document).ready(function() {
	            	        		changeAppNaviBarState("showBar");
	            	        		
                            		$userConnList = $(".u_list > li"); // 접속현황 목록
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
                            			
                           				if(connUserNm1 < connUserNm2) return -1;
                               			if(connUserNm1 > connUserNm2) return 1;
                               			if(connUserNm1 == connUserNm2) {
                               				if(connUserId1 < connUserId2) return -1;
                                   			if(connUserId1 > connUserId2) return 1;
                                   			
                               				return 0;
                               			}
                            		});
                            		
                            		userNmOrder = (userNmOrder == "ASC") ? "DESC" : "ASC";
                        			
                        			if(userNmOrder == "DESC") {
                        				list = list.reverse();
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
                                    
                                    if($(this).closest("div.listTab2").hasClass("noti")){
                                    	let tabTarget = $(this).attr("data-target");
                                    	let tabStr = "<spring:message code='bbs.label.system_notice' /> <spring:message code='filebox.button.ok' />";								// 전체공지 확인
                                    	if(tabTarget == "#tab2") tabStr = "<spring:message code='bbs.label.class_notice' /> <spring:message code='filebox.button.ok' />";		// 강의공지 확인
                                    	if(tabTarget == "#tab3") tabStr = "<spring:message code='dashboard.course_qna' /> <spring:message code='filebox.button.ok' />";	// 강의 Q&A 확인
                                    	if(tabTarget == "#tab4") tabStr = "<spring:message code='dashboard.councel' /> <spring:message code='filebox.button.ok' />";			// 1:1상담 확인
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
                                    }
                                });

                                // 정규과목 table,grid 선택
                                $("button.waffle").on('click', function (e) {
                                    $(this).toggleClass("on");
                                    $('.body-content .list-table').toggleClass('card-table');
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
                             	
                             	// 강의실 접속가능 여부 체크
                             	function checkEnterAble(crsCreCd) {
                             		var deferred = $.Deferred();
                             		
                             		var url = "<c:url value='/crs/termHome/selectTermByCrsCreCd.do'/>";
                            		var param = {
                            			crsCreCd : crsCreCd
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
                           						alert('<spring:message code="common.not.svc.start.dttm" arguments="' + svcStartDttmFmt + '" />'); // '지금은 강의실에 접속할 수 없습니다. 강의시작일은 [' + svcStartDttmFmt + '] 부터입니다.';
                           						deferred.reject();
                           					}
                           					
                           					// 복습기간종료 후
                           					if(svcEndYn == "Y") {
                           						alert('<spring:message code="common.not.svc.end.dttm" />'); // 복습기간이 종료되었습니다.
                           						deferred.reject();
                           					}
                                    	}
                            			
                            			deferred.resolve();
                            		}, function(xhr, status, error) {
                            			alert('<spring:message code="common.error.svc.dttm.check" />'); // 강의실 접속여부 체크에 실패햐였습니다.
                            			deferred.reject();
                            		});
                            		
                            		return deferred.promise();
                             	}
                             	
                            	// 강의실 접속가능 일시 체크
                            	function checkEnter(crsCreCd, link) {
                            		checkEnterAble(crsCreCd).done(function() {
                            			window.location.href = link;
                            		});
                            	}
                            	
                            	// 강의실 접속체크 후 강의실 세션 이동
                             	function checkEnterMoveCrs(crsCreCd, link) {
                             		checkEnterAble(crsCreCd).done(function() {
                             			moveCrs(link);
                            		});
                             	}
                            	
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
                            </script>
                      
                        <!-- //본문 content 부분 -->
                        <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
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
	                <div class="modal-body p5">
	                    <iframe src="" width="100%" id="popupNoticeIfm" name="popupNoticeIfm"></iframe>
	                </div>
	            </div>
	        </div>
	    </div>
	    <script>
	        $('iframe').iFrameResize();
	        window.closeModal = function() {
	            $('.modal').modal('hide');
	        };
	    </script>
    </body>
</html>