<%@page import="knou.framework.util.SecureUtil"%>
<%@page import="knou.framework.util.StringUtil"%>
<%@page import="knou.framework.common.CommConst"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	request.setAttribute("menuType", SessionInfo.getAuthrtGrpcd(request));
%>

<!-- Header 영역 부분 --> 
<header class="common">

	<!-- location -->
	<%@ include file="/WEB-INF/jsp/common/class_location.jsp" %>

		<ul class="util" id="headerUtil">
			<%
			// 기관:한사대만 메시지 표시
	        if (SessionInfo.isKnou(request)) {
	           	%>
				<li class="message">
					<%
					// 기관:한사대만 메시지 표시
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
					<a href="#headerUtil" data-medi-ui="alarm" title="<spring:message code='common.message.sysmsg.alt1'/>" onclick="viewSysmsgBox(this);return false;"><i class="icon-bell ico" aria-hidden="true"></i><span class="blind">Message</span></a>
					<label id="sysmsgCount" class="count">0</label>
					
					<div class="menu">
						<div class=" ui pointing secondary tabmenu tMenubar ml8 mr8"> <!-- 클래스 flex p8 gap4 변경_230717  -->
							<a class="tmItem active" data-tab="sysmsgList1">PUSH<small class="msg_num" id="sysmsgCount1">0</small></a>
							<a class="tmItem" data-tab="sysmsgList2"><spring:message code="exam.button.eval.msg" /><small class="msg_num" id="sysmsgCount2">0</small></a><!-- 쪽지 -->
						</div>
	
						<div class="scrollbox_inside" style="">
							<div class="p8 ui tab active" id="sysmsgList1" data-tab="sysmsgList1">  <!--  클래스 수정 dataset 추가 _230717 -->
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
			%>

			<li class="mode">
				<a href="#headerUtil" onclick="changeThemeMode();return false;" title="<spring:message code="crs.label.theme.change" />"><i class="theme-light-dark ico" aria-hidden="true"></i><span class="blind"><spring:message code="crs.label.theme.change" /></span></a><!-- 테마변경 -->
			</li>
			
			<%-- 
			<li class="mode">
				<%
				String menuType = SessionInfo.getAuthrtGrpcd(request);
				if (menuType != null && menuType.contains("USR")) {
					String langTitle = "Change to English";
					String lang = "en";
					if ("en".equals(SessionInfo.getLocaleKey(request))) {
						langTitle = "Change to Korean";
						lang = "ko";
					}
					%>
					<a href="/dashboard/main.do?language=<%=lang%>" title="<%=langTitle%>"><i class="language-change ico" aria-hidden="true"></i><span class="blind">Language</span></a>
					<%
				}
				%>
			</li>
			--%>
		</ul>
		<script>
			$('.tabmenu.tMenubar .tmItem').tab();

			$(".tabmenu.tMenubar .tmItem").on("click", function(e){
				let tabStr = $(e) == "sysmsgList1" ? "PUSH" : "<spring:message code='exam.button.eval.msg' />";	// PUSH : 쪽지
				var url = "/logLesson/saveLessonActnHsty.do";
				var data = {
					  actnHstyCd	: "LECTURE_HOME"
					, actnHstyCts	: "<spring:message code='system.fail.alt' /> > "+tabStr+" <spring:message code='common.label.connect' />"	// 알림 > 접속
					, crsCreCd		: "${crsCreCd}"
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
			let userId = "<%=StringUtil.nvl(SessionInfo.getUserId(request))%>";
			let sysmsgConn = true;

			$(document).ready(function() {
				<%
				// 기관:한사대만 메시지 표시
		        if (SessionInfo.isKnou(request)) {
		           	%>
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
						<%
						if ("Y".equals(CommConst.SYSMSG_CHECK_YN)) {
							%>
							getSysMsg(reload);
							<%
						}
						%>
					});
					<%
		        }
		        %>
				
				$("#alarmForm > input[name='courseCd']").val($("#lnbCrsCreCd").val());
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
				$(obj).parents("li").toggleClass("on");
				if($(obj).parents("li").hasClass("on")) {
					getSysMsg(true);
					$(".tmItem").each(function() {
						if($(this).hasClass("active")) {
							let tabStr = $(this).attr("data-tab") == "sysmsgList1" ? "PUSH" : "<spring:message code='exam.button.eval.msg' />";	// 쪽지
							var url = "/logLesson/saveLessonActnHsty.do";
							var data = {
								  actnHstyCd	: "LECTURE_HOME"
								, actnHstyCts	: "<spring:message code='system.fail.alt' /> > "+tabStr+" <spring:message code='common.label.connect' />"	// 알림 > 접속
								, crsCreCd		: "${crsCreCd}"
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
			}
			
			// 통합 메시지 가져오기
			function getSysMsg(reload) {
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
			}

			// 통합메시지 가져오기
			function getSysmsgData(type, reload, msgToken) {
				if ("" == userId) return;

				var countBox = $("#sysmsgCount1");
				var listBox = $("#sysmsgList1");
				var head = "";
				var param = {
					alarmType : type,	  	// 알림유형 (필수) S : SMS, P : PUSH, E : EMAIL, N:쪽지 
					userId : userId,		// 사용자번호
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
									html += "	<a href='#0' onclick=\"goSysmsgList('"+type+"');return false;\" title='<spring:message code='common.label.view' />'>";	// 내용보기
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
								sysmsgStore.put(sysnoteCount, userId+"_count_N");
							}
							else {
								sysmsgCount = msgUnreadCount;
								countBox.html(msgUnreadCount);
								listBox.append(html);
								sysmsgStore.put(sysmsgCount, userId+"_count_T");
							}

							$("#sysmsgCount").text(sysnoteCount + sysmsgCount);

							// indexdb에 저장
							sysmsgStore.put(html, userId+"_data_"+type);
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
						});
						sysmsgStore.get(userId+"_data_"+type).done(function(data){
							listBox.append(data);
						});
					}
				}
			}

			// 통합메시지 목록 화면 호출
			function goSysmsgList(type) {
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
						, userId : "<%=SessionInfo.getUserId(request)%>"
						, userNm : "<%=SessionInfo.getUserNm(request)%>"
						, sysCd : "LMS"
						, orgId : "KNOU"
						, bussGbn : "LMS"
						, ctnt : ctnt
						, sndrPersNo : "<%=SessionInfo.getUserId(request)%>"
						, sndrNm : "<%=SessionInfo.getUserNm(request)%>"
						, sndrDeptCd : "10000"
						, logDesc : "<spring:message code='user.button.msg.answer.send' />" // 쪽지 답장 발송
						, rcvJsonData : rcvJsonData
						, uploadFiles : ""
						, uploadPath : "/msg"
						, token : msgToken
					}

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
						viewSysmsgBox(idx);
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
						, userId : "<%=SessionInfo.getUserId(request)%>"
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
						, userId : "<%=SessionInfo.getUserId(request)%>"
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
		<input type="hidden" name="courseCd" value=""/>
		<input type="hidden" name="menuId" value="LMS"/>
	</form>