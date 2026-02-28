<%@page import="knou.lms.user.vo.UsrUserInfoVO"%>
<%@page import="java.util.List"%>
<%@page import="knou.framework.util.LocaleUtil"%>
<%@page import="knou.framework.util.SecureUtil"%>
<%@page import="knou.framework.util.StringUtil"%>
<%@page import="knou.framework.common.CommConst"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%
	request.setAttribute("menuType", SessionInfo.getAuthrtGrpcd(request));
%>

<style>
@keyframes blink {
	0% {color: red;}
	50% {color: var(--dark1);}
}
 
@-webkit-keyframes blink {
	0% {color: red;}
	50% {color: var(--dark1);}
}

.blinkMsg {
	animation: blink 1s step-end infinite;
	-webkit-animation: blink 1s step-end infinite;
}

header.common ul.util > li .user-img .menu.org-user {
    width:auto;
}
</style>

<!-- Header 영역 부분 --> 
<header class="common">

	<!-- location -->
	<%@ include file="/WEB-INF/jsp/common/location_sample.jsp" %>

		<ul class="util" id="headerUtil">
		
			<a href="javascript:void(0)" class="ui bcWhite button mb5" onclick="widgetSettingModal()"><spring:message code="common.button.widgetSetting" /></a>
			
			<%
			// 기관:한사대만 메시지 표시
	        if (SessionInfo.isKnou(request)) {
	           	%>
				<li class="message">
				<%
		        if (SessionInfo.getAuthrtGrpcd(request) != null && SessionInfo.getAuthrtGrpcd(request).contains("USR")) {
		           	%>
					<a href="javascript:void(0)" onclick='goSysmsgList("P");return false;' title="<spring:message code='common.label.msg_system'/>"><i class="icon-talk-to-talk ico" aria-hidden="true"></i><span class="blind">Message</span></a>
					<%
		        } else {
					%>
					<a href="javascript:void(0)" onclick='goSysmsgList("");return false;' title="<spring:message code='common.label.msg_system'/>"><i class="icon-talk-to-talk ico" aria-hidden="true"></i><span class="blind">Message</span></a>
					<%
	        	}
				%>
				</li>
			
				<li id="sysmsgIcon" class="mail"> 
					<a href="#headerUtil" data-medi-ui="alarm" title="<spring:message code='common.message.sysmsg.alt1'/>" onclick="viewSysmsgBox(this);return false;"><i class="icon-bell ico" aria-hidden="true"></i><span style="display:none">Message</span></a>
					<label id="sysmsgCount" class="count">0</label>
					
					<div class="menu">
						<div class=" ui pointing secondary tabmenu tMenubar ml8 mr8">
							<a class="tmItem active" data-tab="sysmsgList1">PUSH<small class="msg_num" id="sysmsgCount1">0</small></a>
							<a class="tmItem" data-tab="sysmsgList2"><spring:message code="exam.button.eval.msg" /><small class="msg_num" id="sysmsgCount2">0</small></a><!-- 쪽지 -->
						</div>
	
						<div class="scrollbox_inside" style="">
							<div class="p8 ui tab active" id="sysmsgList1" data-tab="sysmsgList1">
								<div class="flex-container m-hAuto">
									<div class="no_content">
										<span><spring:message code='common.message.sysmsg.alt4'/></span><!-- 수신한 메시지가 없습니다. -->
										<div class="flex tc mt10 gap4">
											<a href="#headerUtil" class="ui basic small button" onclick='goSysmsgList("P");return false;'><spring:message code='common.button.viewMsgBox'/></a>
										</div>
									</div>
								</div>
							</div>
							<div class="p8 ui tab" id="sysmsgList2" data-tab="sysmsgList2">  <!--  클래스 수정 dataset 추가 _230717 -->
								<div class="flex-container m-hAuto">
									<div class="no_content">
										<span><spring:message code='common.message.sysmsg.alt4'/></span><!-- 수신한 메시지가 없습니다. -->
										<div class="flex tc mt10 gap4">
											<a href="#headerUtil" class="ui basic small button" onclick='goSysmsgList("N");return false;'><spring:message code='common.button.viewMsgBox'/></a>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="flex p8">
							<button type="button" class="ui basic button small mra" onclick="readAllSysmsg()"><spring:message code="exam.label.item.read.all.process" /></button><!-- 모두읽음처리 -->
							<button type="button" onclick="allSysmsgList()" class="ui basic button small"><spring:message code="msg.button.all.list" /></button><!-- 전체목록 -->
						</div>
					</div>
				</li>
				<%
	        }
	        else {
	        	%>
	        	<li >
				<div class="user-img ui dropdown mla org-user">
					<div class="initial-img sm" style="min-width:35px">
					<%
					// 사용자사진
					if (!"".equals(SessionInfo.getUserPhoto(request))) {
						%>
						<img id="userPhoto1" src="<%=SessionInfo.getUserPhoto(request)%>" alt='user photo'>
						<%
					} else {
						%>
						<img id="userPhoto1" src="/webdoc/img/icon-hycu-symbol-grey.svg" alt='user photo'>
						<%
					}
					%>
					</div>
					<div class="menu org-user">
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
								<img id="userPhoto2" src="/webdoc/img/icon-hycu-symbol-grey.svg" alt='user photo'>
								<%
							}
							%>
							</div>
							<ul>
								<li><div style=""><%= SessionInfo.getUserNm(request) %> (<%= SessionInfo.getUserId(request) %>)</div></li>
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
							<div class="item"><a href="javascript:userProfilePop('<%= SessionInfo.getUserRprsId(request) %>');" title="<spring:message code='user.title.userinfo.myinfo' />"><i class="user circle icon"></i><spring:message code='user.title.userinfo.myinfo' /></a></div><!-- 내정보 -->
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
							
							<div class="item"><a href="/user/userHome/logout.do" title="<spring:message code='user.button.logout' />" onclick="localStorage.removeItem('USER_PHOTO_<%=SessionInfo.getUserRprsId(request)%>')"><i class="sign-out icon"></i><spring:message code='user.button.logout' /></a></div><!-- 로그아웃 -->
							<%
						}
						%>
					</div>
					
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
					<script type="text/javascript">
						// 세션에 사용자 사진이 있으면 처리
						<%
						if (!"".equals(SessionInfo.getUserPhoto(request))) {
							// 사진정보 localStorage에 저장, 세션에서 삭제
							%>
							localStorage.setItem("userPhoto_<%=SessionInfo.getUserRprsId(request)%>", "<%=SessionInfo.getUserPhoto(request)%>");
							<%
							SessionInfo.removeUserPhoto(request);
						}
						%>
						let userPhoto = localStorage.getItem("USER_PHOTO_<%=SessionInfo.getUserRprsId(request)%>");
						if (userPhoto != undefined && userPhoto != "") {
							$("#userPhoto1").attr("src", userPhoto);
							$("#userPhoto2").attr("src", userPhoto);
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
					</script>
					
				</div>
	        		
	        	</li>
	        	<%
	        }
			%>

			<li class="mode">
				<a href="#headerUtil" onclick="changeThemeMode();return false;" title="<spring:message code="crs.label.theme.change" />"><i class="theme-light-dark ico" aria-hidden="true"></i><span class="blind"><spring:message code="crs.label.theme.change" /></span></a><!-- 테마변경 -->
			</li>
			
			 
			<li class="mode">
				<%
				String menuType = SessionInfo.getAuthrtGrpcd(request);
				
				if (menuType != null && menuType.contains("USR") || (menuType != null && menuType.contains("PROF") && !SessionInfo.isKnou(request))) {
					String langTitle = "Change to English";
					String lang = "en";
					if ("en".equals(SessionInfo.getLocaleKey(request))) {
						langTitle = "Change to Korean";
						lang = "ko";
					}
					%>
					<a href="/dashboard/main.do?language=<%=lang%>" title="<%=langTitle%>"><i class="language-change ico" aria-hidden="true"></i><span class="blind">Language</span></a><!-- 언어변경 -->
					<%
				}
				%>
			</li>
			
		</ul>
		<script>
			$('.tabmenu.tMenubar .tmItem').tab();

			$(".tabmenu.tMenubar .tmItem").on("click", function(e) {
				let tabStr = $(this).attr("data-tab") == "sysmsgList1" ? "PUSH" : "<spring:message code='exam.button.eval.msg' />";	// PUSH : 쪽지
				var url = "/logLesson/saveLessonActnHsty.do";
				var data = {
					  actnHstyCd	: "COURSE_HOME"
					, actnHstyCts	: "<spring:message code='system.fail.alt' /> > "+tabStr+" <spring:message code='common.label.connect' />"	// 알림 > 접속
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

			let reloadTime = 30; // 메시지를 다시 가져오는 시간
			let sysmsgCount = 0; // 메시지 count
			let sysnoteCount = 0; // 쪽지 count
			let sysmsgStore = $.indexedDB("SysmsgDB").objectStore("SysmsgStore", true); // indexdb 정의
			let userId = "<%=StringUtil.nvl(SessionInfo.getUserRprsId(request))%>";
			let sysmsgConn = true;
			let msgCount = 0;
			let sysmsgSubFnObj = {}; // 메세지 조회후 실행할 함수 등록

			$(document).ready(function() {
				sysmsgStore.get(userId+"_checkTime").done(function(data){
					let reload = true;
					
					// 지난 체크시간 비교
					if (data != undefined && (new Date().getTime() - data) < (reloadTime * 1000)) {
						reload = false;
					}
					else {
						sysmsgStore.put((new Date()).getTime(), userId+"_checkTime");
					}
					
					// 통합 메시지 가져오기
					<% /////////////////////
					if ("Y".equals(CommConst.SYSMSG_CHECK_YN)) {
						%>
						getSysMsg(reload);
						<%
					}
					%>
				});
			});
			
			// 전체 목록 리스트 이동
			function allSysmsgList() {
				$("a.tmItem").each(function(i) {
					if($(this).hasClass("active")) {
						if($(this).attr("data-tab") == "sysmsgList1") {
							goSysmsgList("P");
						} else if($(this).attr("data-tab") == "sysmsgList2") {
							goSysmsgList("N");
						}
					}
				});
			}

			// 통합메시지 박스 표시
			function viewSysmsgBox(obj) {
				alert("[준비중] 메시지함");
				/*
				$(obj).parents("li").toggleClass("on");
				if($(obj).parents("li").hasClass("on")) {
					getSysMsg(true);
					$(".tmItem").each(function() {
						if($(this).hasClass("active")) {
							let tabStr = $(this).attr("data-tab") == "sysmsgList1" ? "PUSH" : "<spring:message code='exam.button.eval.msg' />";	// 쪽지
							var url = "/logLesson/saveLessonActnHsty.do";
							var data = {
								  actnHstyCd	: "COURSE_HOME"
								, actnHstyCts	: "<spring:message code='system.fail.alt' /> > "+tabStr+" <spring:message code='common.label.connect' />"	// 알림 > 접속
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
				}
				*/
			}
			
			// 통합 메시지 가져오기
			function getSysMsg(reload) {
				/*
				$.ajax({
					type : "POST",
					async: true,
					dataType : "json",
					url : "/api/getMesageToken.do",
					timeout: 3000,
					success : function(data){
						if (data.result == "1") {
							getSysmsgData("P", reload, data.value); // PUSH
							getSysmsgData("N", reload, data.value); // 쪽지
						}
						else if (data.result == "-1") {
							console.log("error.............");
						}
					},
					error: function(xhr, Status, error) {
						console.log("error.............");
					}
				});
				*/
			}

			// 통합메시지 가져오기
			function getSysmsgData(type, reload, msgToken) {
				if ("" == userId) return;

				var countBox = $("#sysmsgCount1");
				var listBox = $("#sysmsgList1");
				var head = "";

				var param = {
					alarmType : type,	  	// 알림유형 (필수) S : SMS, P : PUSH, E : EMAIL, N:쪽지 
					userId : userId,	 	// 사용자번호
					searchCnd : "TOTAL",
					token : msgToken,
				};

				// SMS, PUSH, EMAIL
				if (type == "P") {
					param["searchPeriodDays"] = 7; //날짜(지정일 이내 목록)
				}
				// 쪽지
				else if (type == "N") {
					//head = "[M] ";
					param["searchCnd"] = "UNREAD";
					countBox = $("#sysmsgCount2");
					listBox = $("#sysmsgList2");
				}

				listBox.html("");

				if (reload && sysmsgConn) {
					$.ajax({
						type : "POST",
						async: true,
						dataType : "json",
						data : param,
						url : "<%=CommConst.SYSMSG_URL_SEARCH%>",
						timeout: 3000,
						success : function(data){
							var msgUnreadCount = 0;
							var html = "";

							if (data.result < 0) {
								console.log("Message service error : "+data.message);

								html += "<div class='flex-container m-hAuto'>";
								html += "<div class='no_content'>";
								html += "	<span><spring:message code='common.message.sysmsg.alt4'/></span>";
								html += "	<div class='flex mt10 tc gap4'>";
								html += "		<a href='#0' class='ui basic small button' onclick='goSysmsgList(\""+ type +"\");return false;'><spring:message code='common.button.viewMsgBox'/></a>";
								html += "	</div>";
								html += "</div>";
								html += "</div>";
								listBox.html(html);

								return;
							}

							var msgdata = data.returnList || [];

							$.each(msgdata, function(i, o){
								var unReadClass = "opacity7";
								if(o.readYn == "N") {
									msgUnreadCount++;
									unReadClass = "";
								}
								
								if (o.msgGbn != undefined) {
									//head = "["+o.msgGbn+"] ";
								}

								html += "<div class='item'>";
								if (type == "N") {
									html += "<div class='flex " + unReadClass + "'>";
									html += "	<a href='#0' onclick=\"goSysmsgList('"+type+"');return false;\" title='<spring:message code='common.label.view' />'>"; // 내용보기
									html += "		<p class='item-title'>"+head + o.ctnt+"</p>";
									html += "		<small class='f075'>"+o.sendDttm+"</small></a>";
									html += "	<button type='button' class='ui basic mini button boxShadowNone mla flex-shrink0' onclick=\"viewSysmsgSendBox('"+type+i+"')\" title='<spring:message code='user.title.answer' />'><i class='xi-reply'></i></button>";	// 답장
									html += "</div>";
									html += "<div id='sysmsg_sendbox_"+type+i+"' class='field flex flex-column gap4 mt10' style='display:none !important'>";
									html += "	<textarea id='sysmsg_"+type+i+"' rows='2'></textarea>";
									html += "	<button class='ui basic mini button mla' onclick=\"sendSysmsg('N',"+i+",'"+o.sndrPersNo+"','"+o.sndrNm+"');return false;\"><spring:message code='common.button.send' /></button>";	// 보내기
									html += "</div>";
								}
								else {
									html += "<a href='#0' class='" + unReadClass + "' onclick=\"goSysmsgList('"+o.msgGbn+"');return false;\" title='<spring:message code='common.label.view' />'>";	// 내용보기
									html += "	<p class='item-title text-truncate'>"+head + o.subject+"</p>"; 
									html += "	<small class='f075'>"+o.sendDttm+"</small></a>";
								}
								html += "</div>";
							});

							if (msgdata.length == 0) {
								html += "<div class='flex-container m-hAuto'>";
								html += "<div class='no_content'>";
								html += "	<span><spring:message code='common.message.sysmsg.alt4'/></span>";
								html += "	<div class='flex mt10 tc gap4'>";
								html += "		<a href='#0' class='ui basic small button' onclick='goSysmsgList(\""+ type +"\");return false;'><spring:message code='common.button.viewMsgBox'/></a>";
								html += "	</div>";
								html += "</div>";
								html += "</div>";
							}

							if (type == "N") {
								sysnoteCount = msgUnreadCount;
								countBox.html(msgUnreadCount);
								listBox.html(html);
								sysmsgStore.put(msgdata.length, userId+"_count_N");
							}
							else {
								sysmsgCount = msgUnreadCount;
								countBox.html(msgUnreadCount);
								listBox.append(html);
								sysmsgStore.put(sysmsgCount, userId+"_count_T");
							}

							$("#sysmsgCount").text(sysnoteCount + sysmsgCount);
							
							if ((sysnoteCount + sysmsgCount) > 0) {
								$("#sysmsgIcon .ico").addClass("blinkMsg");
							}
							else {
								$("#sysmsgIcon .ico").removeClass("blinkMsg");
							}

							// indexdb에 저장
							sysmsgStore.put(html, userId+"_data_"+type);
							sysmsgStore.put(msgdata, userId+"_dataList_"+type);
							
							(Object.keys(sysmsgSubFnObj) || []).forEach(function(key, i) {
								if(typeof sysmsgSubFnObj[key] === "function") {
									sysmsgSubFnObj[key]();
								}
							});
						},
						error: function(xhr, Status, error) {
							console.log("get sysmsg error.............");
							sysmsgConn = false;
						}
					});
				}
				else {
					if (type == "N") {
						sysmsgStore.get(userId+"_count_N").done(function(data){
							if (data == undefined) data = 0;
							sysnoteCount = parseInt(data);
							countBox.html(data);
							$("#sysmsgCount").text(sysnoteCount + sysmsgCount);
							
							if ((sysnoteCount + sysmsgCount) > 0) {
								$("#sysmsgIcon .ico").addClass("blinkMsg");
							}
							else {
								$("#sysmsgIcon .ico").removeClass("blinkMsg");
							}
 						});
						sysmsgStore.get(userId+"_data_"+type).done(function(data){
							listBox.html(data);
 						});
					}
					else {
						sysmsgStore.get(userId+"_count_T").done(function(data){
							if (data == undefined) data = 0;
							sysmsgCount = parseInt(data);
							countBox.html(data);
							$("#sysmsgCount").text(sysnoteCount + sysmsgCount);
							
							if ((sysnoteCount + sysmsgCount) > 0) {
								$("#sysmsgIcon .ico").addClass("blinkMsg");
							}
							else {
								$("#sysmsgIcon .ico").removeClass("blinkMsg");
							}
						});
						sysmsgStore.get(userId+"_data_"+type).done(function(data){
							listBox.append(data);
						});
					}
				}
			}

			// 통합메시지 목록 화면 호출
			function goSysmsgList(type) {
				alert("[준비중] 메시지 화면");
				
				/*
				try {
					event.stopPropagation();	
				} catch (e) {
				}

		    	var agent = navigator.userAgent.toLowerCase();
		    	var hycuapp = "N";
		        if(agent.indexOf("hycuapp") > -1) {
		        	hycuapp = "Y";
		        }
				
		    	var form = document.alarmForm;
				form.action = "<%=CommConst.SYSMSG_URL_LIST%>";
		    	
				if (hycuapp == "Y") {
		    		form.target = "_self";
		    	}
		    	else {
					window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
					form.target = "msgWindow";
		    	}
		    	
		    	form[name='alarmType'].value = type;
				form.submit();
				*/
			}

			// 통합메시지 답장 보내기 표시
			function viewSysmsgSendBox(idx) {
				if ($("#sysmsg_sendbox_"+idx).is(':visible')) {
					$("#sysmsg_sendbox_"+idx).attr("style", "display:none !important;");
				}
				else {
					$("#sysmsg_sendbox_"+idx).show();
					$("#sysmsg_sendbox_"+idx).children("textarea").focus();
				}
				
				this.event.stopPropagation();
			}

			// 통합메시지 답장 보내기
			function sendSysmsg(type, idx, userId, userNm) {
				$.ajax({
					type : "POST",
					async: true,
					dataType : "json",
					url : "/api/getMesageToken.do",
					timeout: 3000,
					success : function(data){
						if (data.result == "1") {
							sendSysmsgCall(type, idx, userId, userNm, data.value);
						}
						else if (data.result == "-1") {
							console.log("error.............");
						}
					},
					error: function(xhr, Status, error) {
						console.log("error.............");
					}
				});
			}

			// 통합메시지 답장 보내기 Call
			function sendSysmsgCall(type, idx, userId, userNm, msgToken) {
				var ctnt = $.trim($("#sysmsg_"+type+idx).val());
				if (ctnt == "") {
					// 내용을 입력하세요.
					alert("<spring:message code='common.empty.msg'/>");
					$("#sysmsg_"+type+idx).focus();
					this.event.stopPropagation();
					return;
				}
				
				var rcvAlarmArray = new Array() ;
				var rcvAlarmVO = new Object() ;
					rcvAlarmVO.rcvNo = userId;
					rcvAlarmVO.rcvNm = userNm;
					rcvAlarmArray.push(rcvAlarmVO);
				var rcvJsonData = JSON.stringify(rcvAlarmArray).replace(/\"/gi, "\\\"");
				
				var param = {
					alarmType : type
					, userId : "<%=SessionInfo.getUserRprsId(request)%>"
					, userNm : "<%=SessionInfo.getUserNm(request)%>"
					, sysCd : "LMS"
					, orgId : "KNOU"
					, bussGbn : "LMS"
					, ctnt : ctnt
					, sndrPersNo : "<%=SessionInfo.getUserRprsId(request)%>"
					, sndrNm : "<%=SessionInfo.getUserNm(request)%>"
					, sndrDeptCd : "10000"
					, logDesc : "<spring:message code='user.button.msg.answer.send' />" // 쪽지 답장 발송
					, rcvJsonData : rcvJsonData
					, uploadFiles : ""
					, uploadPath : "/msg"
					, token : msgToken
				};

				$.ajax({
					type : "POST",
					async: false,
					dataType : "json",
					data : param,
					url : "<%=CommConst.SYSMSG_URL_INSERT%>",
					success : function(data) {
						if (data.result > 0) {
								alert("<spring:message code='common.alert.sysmsg.send.success'/>");
						}
						else {
								alert("<spring:message code='fail.common.msg'/>");
						}
						
						$("#sysmsg_"+type+idx).val("");
						$("#sysmsg_sendbox_"+type+idx).attr("style", "display:none !important;");
					},
					error: function(xhr,  Status, error) {
						console.log(error);
						alert("<spring:message code='fail.common.msg'/> [MSG]");
					}
				});
			}
			
			// 통합메시지 모두읽음처리
			function readAllSysmsg() {
				getSysmsgToken().done(function(msgToken) {
					// 쪽지 모두읽음
					var param = {
						  alarmType : "N"
						, token : msgToken
						, userId : "<%=SessionInfo.getUserRprsId(request)%>"
						, modIp : "<%=SessionInfo.getLoginIp(request)%>"
						, readType : "A"
					};
					
					$.ajax({
						type : "POST",
						async: false,
						dataType : "json",
						data : param,
						url : "<%=CommConst.SYSMSG_URL_READ%>",
						success : function(data) {
							if (data.result > 0) {
								getSysmsgData("N", true, msgToken); // 쪽지
							}
							else {
								console.log(data.message);
							}
						},
						error: function(xhr,  Status, error) {
							console.log(error);
						}
					});
					
					// PUSH 모두읽음
					var param2 = {
						  alarmType : "P"
						, token : msgToken
						, userId : "<%=SessionInfo.getUserRprsId(request)%>"
						, modIp : "<%=SessionInfo.getLoginIp(request)%>"
						, readType : "A"
					};
					
					$.ajax({
						type : "POST",
						async: false,
						dataType : "json",
						data : param2,
						url : "<%=CommConst.SYSMSG_URL_READ%>",
						success : function(data) {
							if (data.result > 0) {
								getSysmsgData("P", true, msgToken); // PUSH
							}
							else {
								console.log(data.message);
							}
						},
						error: function(xhr,  Status, error) {
							console.log(error);
						}
					});
				});
			}
			
			// 통합메시지 토큰조회
			function getSysmsgToken() {
				var deferred = $.Deferred();
				
				$.ajax({
					type : "POST",
					dataType : "json",
					url : "/api/getMesageToken.do",
					timeout: 3000,
					success : function(data){
						if (data.result == "1") {
							deferred.resolve(data.value);
						}
						else if (data.result == "-1") {
							console.log("error.............");
							deferred.reject();
						}
					},
					error: function(xhr, Status, error) {
						console.log("error.............");
						deferred.reject();
					}
				});
				
				return deferred.promise();
			}
			
			// 통합메세지 조회 정보 리턴
			function getSysmsgStore() {
				var deferred = $.Deferred();
				
				var returnObj = {};
				var userId = "<%=SessionInfo.getUserRprsId(request)%>";
		
				sysmsgStore.get(userId+"_dataList_P").done(function(dataListT) {
					returnObj["pushList"] = dataListT || [];
					sysmsgStore.get(userId+"_dataList_N").done(function(dataListN) {
						returnObj["msgList"] = dataListN || [];
						
						deferred.resolve(returnObj);
					});
				});
				
				return deferred.promise();
			}

			// 테마 모드 변경
			function changeThemeMode() {
				var themeMode = "";
				var darkYN = "";
				if (THEME_MODE != undefined && THEME_MODE == "dark") {
					themeMode = "white"
					darkYN = "N";
					$("body").removeClass("dark");
				}
				else {
					themeMode = "dark";
					darkYN = "Y";
					$("body").removeClass("white");
				}

				$("body").addClass(themeMode);
				setCookie("darkYN", darkYN, 365, "hycu.ac.kr");

				var param = {
					confType: "theme",
					confVal: themeMode
				};

				$.ajax({
					type : "POST",
					async: false,
					dataType : "json",
					data : param,
					url : "/user/userHome/setUserConf.do",
					success : function(data) {
						THEME_MODE = themeMode;
					},
					error: function(xhr,  Status, error) {
						console.log(error);
					}
				});
			}
		</script>
</header>

	<!-- 통합 메시지폼 -->
	<form id="alarmForm" name="alarmForm" method="post" style="position:absolute;left:1000">
		<input type="hidden" name="rcvUserInfoStr" />
		<input type="hidden" name="sysCd" value="LMS" />
		<input type="hidden" name="orgId" value="KNOU" />
		<input type="hidden" name="bussGbn" value="LMS" />
		<input type="hidden" name="alarmType" value="N"/>
		<input type="hidden" name="pushSndRcv" value="RECEIVE"/>
		<input type="hidden" name="noteSndRcv" value="RECEIVE"/>
		<input type="hidden" name="menuId" value="LMS"/>
	</form>
