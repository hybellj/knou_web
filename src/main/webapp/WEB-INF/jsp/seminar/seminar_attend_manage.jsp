
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<%@ include file="/WEB-INF/jsp/seminar/common/seminar_common_inc.jsp" %>
	
	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
	
	<script type="text/javascript">
		$(document).ready(function () {
			stdAttendForm("view");
			
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					listStd();
				}
			});
			
			$(".accordion").accordion();
		});
		var formType = "view";
		
		// 목록
		function listSeminar() {
			var kvArr = [];
			kvArr.push({'key' : 'crsCreCd', 'val' : "${crsCreCd}"});
			
			submitForm("/seminar/seminarHome/Form/seminarList.do", "", "", kvArr);
		}
		
		// 세미나 수정
		function editSeminar() {
			//if("${vo.seminarStartYn}" == "Y") {
			//	alert("<spring:message code='seminar.alert.already.seminar' />");/* 세미나 시작일시 이후 수정 불가합니다. */
			//} else {
				var kvArr = [];
				kvArr.push({'key' : 'crsCreCd',  'val' : "${vo.crsCreCd}"});
				kvArr.push({'key' : 'seminarId', 'val' : "${vo.seminarId}"});
				
				submitForm("/seminar/seminarHome/Form/seminarEdit.do", "", "", kvArr);
			//}
		}
		
		// 세미나 삭제
		function delSeminar(seminarId) {
			var confirm = window.confirm("<spring:message code='seminar.confirm.delete' />");/* 삭제 하시겠습니까? */
			
			if(confirm) {
				var url  = "/seminar/seminarHome/delSeminar.do";
				var data = {
					"seminarId" : "${vo.seminarId}"
				};
				
				ajaxCall(url, data, function(data) {
					if (data.result > 0) {
						alert("<spring:message code='seminar.alert.delete' />");/* 정상 삭제되었습니다. */
						listSeminar();
		            } else {
		             	alert(data.message);
		            }
				}, function(xhr, status, error) {
					alert("<spring:message code='seminar.error.delete' />");/* 삭제 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
				});
			}
		}
		
		// 수강생 목록
		function listStd() {
			var univGbn = "${creCrsVO.univGbn}";
			var url  = "/seminar/seminarHome/seminarStdList.do";
			var data = {
				"crsCreCd" 	  	: "${crsCreCd}",
				"searchValue"	: $("#searchValue").val(),
				"seminarId"		: "${vo.seminarId}",
				"atndCd"		: $("#atndCd").val()
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var returnList = data.returnList || [];
					var html = "";
					var stdNos = $("#stdNos").val().split(",");
					
					if(returnList.length > 0) {
						returnList.forEach(function(v, i) {
							var isChecked   = '';
		        			if(stdNos != "") {
		        				stdNos.forEach(function(vv, ii) {
		        					if(vv == v.stdNo) {
		        						isChecked = 'checked';
		        					}
		        				});
		        			}
							html += "<tr data-stdNo='"+v.stdNo+"'>";
							html += "	<td class='tc'>";
							html += "		<div class='ui checkbox'>";
							html += "			<input type='checkbox' name='evalChk' id='evalChk"+i+"' onchange='checkStdNoToggle(this)' data-stdNo=\""+v.stdNo+"\" "+isChecked+" user_id=\""+v.userId+"\" user_nm=\""+v.userNm+"\" mobile=\""+v.mobileNo+"\" email=\""+v.email+"\">";
							html += "			<label class='toggle_btn' for='evalChk"+i+"'></label>";
							html += "		</div>";
							html += "	</td>";
							html += "	<td class='tc' name='lineNo'>"+v.lineNo+"</td>";
							html += "	<td data-sort-value='"+v.deptNm+"' class='word_break_none'>"+v.deptNm+"</td>";
							html += "	<td data-sort-value='"+v.userId+"' class='tc'>"+v.userId+"</td>";
							html += "	<td data-sort-value='"+v.hy+"' class='tc'>"+(v.hy == null ? '-' : v.hy)+"</td>";
							if(univGbn == "3" || univGbn == "4") {
								html += '<td class="tc word_break_none" data-sort-value="'+(v.grscDegrCorsGbnNm || '-')+'">' + (v.grscDegrCorsGbnNm || '-') + '</td>';
							}
							html += "	<td class='tc word_break_none' data-sort-value=\""+v.userNm+"\"><a class='fcBlue' href='javascript:studyStatusModal(\""+v.stdNo+"\")'>"+v.userNm+"</a>";
							html +=		userInfoIcon("<%=SessionInfo.isKnou(request)%>", "userInfoPop('"+v.userId+"')");
							html += "	</td>";
							html += "	<td data-sort-value='"+v.entrYy+"' class='tc'>"+v.entrYy+"</td>";
							html += "	<td data-sort-value='"+v.entrHy+"' class='tc'>"+v.entrHy+"</td>";
							html += "	<td data-sort-value='"+v.entrGbnNm+"' class='tc'>"+v.entrGbnNm+"</td>";
							if("${vo.seminarCtgrCd}" == "free") {
							html += "	<td class='tc'>"+dateFormat("date", v.atndDttm)+"</td>";
							} else {
							if(formType == "edit") {
							var checked = {true : "checked"};
							html += "	<td class='tc word_break_none'>"+dateFormat("date", v.regDttm)+"</td>";
							html += "	<td class='tc word_break_none'>";
							html += "		<div class='fields' data-userId=\""+v.userId+"\" data-seminarAtndId=\""+dataNullCheck("nonhyphen", v.seminarAtndId)+"\">";
							html += "			<div class='field'>";
							html += "				<div class='ui radio checkbox'>";
							html += "					<input type='radio' name='atndCd_"+v.stdNo+"' value='ATTEND' class='hidden' id='attend_"+v.stdNo+"' "+checked[v.atndCd == 'ATTEND']+" />";
							html += "					<label class='fcBlue' for='attend_"+v.stdNo+"'><spring:message code='seminar.label.attend' /></label>";/* 출석 */
							html += "				</div>";
							html += "			</div>";
							html += "			<div class='field'>";
							html += "				<div class='ui radio checkbox'>";
							html += "					<input type='radio' name='atndCd_"+v.stdNo+"' value='LATE' class='hidden' id='late_"+v.stdNo+"' "+checked[v.atndCd == 'LATE']+" />";
							html += "					<label class='fcYellow' for='late_"+v.stdNo+"'><spring:message code='seminar.label.late' /></label>";/* 지각 */
							html += "				</div>";
							html += "			</div>";
							html += "			<div class='field'>";
							html += "				<div class='ui radio checkbox'>";
							html += "					<input type='radio' name='atndCd_"+v.stdNo+"' value='ABSENT' class='hidden' id='absent_"+v.stdNo+"' "+checked[v.atndCd == "ABSENT" || v.atndCd == null]+" />";
							html += "					<label class='fcRed' for='absent_"+v.stdNo+"'><spring:message code='seminar.label.absent' /></label>";/* 결석 */
							html += "				</div>";
							html += "			</div>";
							html += "		</div>";
							html += "	</td>";
							} else {
							var attendClass = attendFormat("suspense", v.atndCd) == "출석" ? "fcBlue" : attendFormat("suspense", v.atndCd) == "지각" ? "fcYellow" : attendFormat("suspense", v.atndCd) == "결석" ? "fcRed" : "";
							html += "	<td class='tc'>"+dateFormat("time", v.atndTime)+"</td>";
							html += "	<td class='tc word_break_none'>"+dateFormat("date", v.atndDttm)+"</td>";
							html += "	<td class='tc "+attendClass+"'>"+attendFormat("suspense", v.atndCd)+"</td>";
							}
							html += "	<td class='tc word_break_none'><a href='javascript:seminarHstyPop(\""+v.stdNo+"\")' class='ui mini basic button'><spring:message code='seminar.button.view' /></a></td>";/* 보기 */
							}
							html += "</tr>";
						});
					}
					$("#stdList").empty().html(html);
					$("#stdTable").footable({
	   					on: {
	   						"after.ft.sorting": function(e, ft, sorter){
	   							$("#stdList tr").each(function(z, k){
	   								$(k).find("td[name=lineNo]").html((z+1));
	   							});
	   						}
	   					}
	   				});
					$("#stdCnt").text(returnList.length);
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='seminar.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
			});
		}
		
		// 세미나 출결 상세 팝업
		function seminarHstyPop(stdNo) {
			// 버튼 클릭 확인용
			$("#stdList > tr").removeClass("focused");
			$("#stdList > tr[data-stdNo='"+stdNo+"']").addClass("focused");
			
			var kvArr = [];
			kvArr.push({'key' : 'stdNo', 	 'val' : stdNo});
			kvArr.push({'key' : 'crsCreCd',  'val' : "${crsCreCd}"});
			kvArr.push({'key' : 'seminarId', 'val' : "${vo.seminarId}"});
			
			submitForm("/seminar/seminarHome/seminarAttendStatPop.do", "seminarPopIfm", "attendStat", kvArr);
		}
		
		// 출결 체크 폼
		function stdAttendForm(type) {
			$(".attendBtn").hide();
			$("."+type+"Btn").show();
			formType = type;
			stdTableForm();
			listStd();
		}
		
		// 수강생 테이블 폼
		function stdTableForm() {
			$("#stdTable thead th:gt(8)").remove();
			if("${vo.seminarCtgrCd}" == "free") {
				$("#stdTable thead tr").append("<th class='tc' data-breakpoints='xs sm md'><spring:message code='seminar.label.part.date' /></th>");/* 참여일시 */
			} else {
				if(formType == "edit") {
					$("#stdTable thead tr").append("<th class='tc' data-breakpoints='xs sm md'><spring:message code='seminar.label.attend.date' /></th>");/* 출석체크일시 */
					$("#stdTable thead tr").append("<th class='tc'><spring:message code='seminar.button.attend.manage' /></th>");/* 출결관리 */
					$("#stdTable thead tr").append("<th class='tc' data-breakpoints='xs sm md'><spring:message code='seminar.label.details' /></th>");/* 상세내역 */
				} else {
					$("#stdTable thead tr").append("<th class='tc' data-breakpoints='xs sm'><spring:message code='seminar.label.total.study.time' /></th>");/* 총 학습시간 */
					$("#stdTable thead tr").append("<th class='tc' data-breakpoints='xs sm md'><spring:message code='seminar.label.part.date' /></th>");/* 참여일시 */
					$("#stdTable thead tr").append("<th class='tc' data-breakpoints='xs sm md'><spring:message code='seminar.label.attendance.status' /></th>");/* 출석현황 */
					$("#stdTable thead tr").append("<th class='tc' data-breakpoints='xs sm md'><spring:message code='seminar.label.manage' /></th>");/* 관리 */
				}
			}
		}
		
		// 전체 출결 체크
		function attendAllCheck(type) {
			var confirmStr = "";
			if(type == "ATTEND") confirmStr = "<spring:message code='seminar.confirm.all.attend' />";/* 전체 출석 처리하시겠습니까? */
			if(type == "ABSENT") confirmStr = "<spring:message code='seminar.confirm.all.absent' />";/* 전체 결석 처리하시겠습니까? */
			var confirm = window.confirm(confirmStr);
			if(confirm) {
				$("input[name^=atndCd_][value=\""+type+"\"]").prop("checked", true);
			}
		}
		
		// 출결 기록 저장
		function saveAttend() {
			$("#attendSetForm").find("input[name=attendStdList]").remove();
			$("input[name^=atndCd_]:checked").each(function(i, v) {
				var userId = $(v).parents(".fields").attr("data-userId");
				var stdNo  = v.id.substring(v.id.indexOf("_")+1);
				var atndCd = v.value;
				var atndId = $(v).parents(".fields").attr("data-seminarAtndId");
				$("#attendSetForm").append("<input type='hidden' name='attendStdList' value='"+ userId + "|" + stdNo + "|" + atndCd + "|" + atndId +"' />");
			});
			var url  = "/seminar/seminarHome/seminarAtndEdit.do";
			var data = $("#attendSetForm").serialize();
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					alert("<spring:message code='seminar.alert.change.attend.status' />");/* 출결상태 변경이 완료되었습니다. */
					stdAttendForm("view");
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='seminar.error.change.attend.status' />");/* 출결상태 변경 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
			});
		}
		
		// Zoom 출결정보 가져오기 API 호출
		function zoomAttendSetApi() {
			var url  = "/seminar/seminarHome/zoomAttendSet.do";
			var data = {
				"seminarId" : "${vo.seminarId }",
				"zoomId"	: "${vo.zoomId}",
				"crsCreCd"	: "${crsCreCd}",
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					alert("<spring:message code='seminar.alert.process.zoom.attend' />");/* Zoom 출결 처리가 완료되었습니다. */
					location.reload();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='seminar.error.process.zoom.attend' />");/* Zoom 출결 처리 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
			}, true);
		}
		
		// ZOOM 시작 ( 호스트 )
		function startHost() {
			if("${vo.seminarEndYn}" == "Y") {
				alert("<spring:message code='seminar.alert.end.seminar' />");/* 해당 세미나는 종료되었습니다. */
				return false;
			}
			var url  = "/seminar/seminarHome/zoomHostStart.do";
			var data = {
				"seminarId" : "${vo.seminarId }"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var windowOpener = window.open();
					windowOpener.location = data.returnVO.hostUrl;
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
			});
		}
		
		// ZOOM 참여 ( 참여자 )
		function startJoin() {
			if("${vo.seminarEndYn}" == "Y") {
				alert("<spring:message code='seminar.alert.end.seminar' />");/* 해당 세미나는 종료되었습니다. */
				return false;
			} else if("${vo.seminarStartYn}" == "N") {
				alert("<spring:message code='seminar.alert.not.seminar.ten.minutes.before.start' />");/* 세미나 시작시간이 아닙니다. 10분 전부터 시작 가능합니다. */
				return false;
			}
			var url  = "/seminar/seminarHome/zoomJoinStart.do";
			var data = {
				"seminarId" : "${vo.seminarId }",
				"crsCreCd"  : "${crsCreCd }"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					if("${IPHONE_YN}" == "Y") {
						window.location.href = data.returnVO.joinUrl;
					} else {
						var windowOpener = window.open();
						windowOpener.location = data.returnVO.joinUrl;
					}
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
			});
		}
		
		// 수강생 학습현황 팝업
		function studyStatusModal(stdNo) {
			var kvArr = [];
			kvArr.push({'key' : 'stdNo', 	'val' : stdNo});
			kvArr.push({'key' : 'crsCreCd', 'val' : "${crsCreCd}"});
			
			submitForm("/std/stdPop/studyStatusPop.do", "seminarPopIfm", "stdStat", kvArr);
		}
		
		//사용자 정보 팝업
	 	function userInfoPop(userId) {
	 		var userInfoUrl = "${userInfoPopUrl}" + btoa(`{"stuno":"\${userId}"}`);
	 		var options = 'top=100, left=150, width=1200, height=800';
	 		window.open(userInfoUrl, "", options);
	 	}
		
	 	// 녹화영상 보기
		function recordView() {
			var kvArr = [];
			kvArr.push({'key' : 'seminarId', 'val' : "${vo.seminarId}"});
			kvArr.push({'key' : 'zoomId', 'val' : "${vo.zoomId}"});
			
			submitForm("/seminar/seminarHome/recordViewPop.do", "seminarPopIfm", "recordView", kvArr);
		}
	 	
		// 메세지 보내기
		function sendMsg() {
			var rcvUserInfoStr = "";
			var sendCnt = 0;
			
			$.each($('#stdList').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
				sendCnt++;
				if (sendCnt > 1) rcvUserInfoStr += "|";
				rcvUserInfoStr += $(this).attr("user_id");
				rcvUserInfoStr += ";" + $(this).attr("user_nm"); 
				rcvUserInfoStr += ";" + $(this).attr("mobile");
				rcvUserInfoStr += ";" + $(this).attr("email"); 
			});
			
			if (sendCnt == 0) {
				/* 메시지 발송 대상자를 선택하세요. */
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
		
		// 전체 체크박스 이벤트
		function checkAllStdNoToggle(obj) {
			$("input[name=evalChk]").prop("checked", obj.checked);
			if(obj.checked) {
				$("input[name=evalChk]").closest("tr").addClass("on");
			} else {
				$("input[name=evalChk]").closest("tr").removeClass("on");
			}
		}
		
		// 단일 체크박스 이벤트
		function checkStdNoToggle(obj) {
			if(obj.checked) {
				$(obj).closest("tr").addClass("on");
			} else {
				$(obj).closest("tr").removeClass("on");
			}
			if($("input[name=evalChk]").length == $("input[name=evalChk]:checked").length) {
				$("#allChk").prop("checked", true);
			} else {
				$("#allChk").prop("checked", false);
			}
		}
		
		// ZOOM 참석로그 보기 팝업
		function stdAttendListPop() {
			var kvArr = [];
			kvArr.push({'key' : 'zoomId', 'val' : "${vo.zoomId}"});
			kvArr.push({'key' : 'crsCreCd', 'val' : "${crsCreCd}"});
			
			submitForm("/seminar/seminarHome/attendListPop.do", "seminarPopIfm", "attendList", kvArr);
		}
	</script>
</head>
<body class="<%=SessionInfo.getThemeMode(request)%>">
	<form id="attendSetForm" method="POST">
		<input type="hidden" name="seminarId" value="${vo.seminarId }" />
	</form>
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>

        <div id="container">
            <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>
            
            <!-- 본문 content 부분 -->
            <div class="content stu_section">
		        <%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
		        
		        <div class="ui form">
		        	<div class="layout2">
		        		<script>
							$(document).ready(function () {
								// set location
								setLocationBar('<spring:message code="seminar.label.seminar" />', '<spring:message code="seminar.label.attend.status" />'); // 세미나 출결현황
							});
						</script>
						
				        <div id="info-item-box">
				        	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="seminar.label.seminar" /><!-- 세미나 -->
                            </h2>
				            <div class="button-area">
					            <a href="javascript:editSeminar()" class="ui blue button"><spring:message code="seminar.button.edit" /><!-- 수정 --></a>
					            <c:if test="${vo.seminarStartYn ne 'Y' }">
						            <a href='javascript:delSeminar()' class='ui basic button'><spring:message code='seminar.button.delete' /><!-- 삭제 --></a>
					            </c:if>
				            	<a href="javascript:listSeminar()" class="ui basic button"><spring:message code="seminar.button.list" /><!-- 목록 --></a>
				            </div>
				        </div>
				        <div class="row">
				        	<div class="col">
								<div class="ui styled fluid accordion week_lect_list card" style="border:none;">
									<div class="title active">
										<div class="title_cont">
											<div class="left_cont">
												<div class="lectTit_box">
													<fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss" value="${vo.seminarStartDttm }" />
													<fmt:formatDate var="seminarStartDttm" pattern="yyyy.MM.dd HH:mm" value="${startDateFmt }" />
													<fmt:parseNumber var="hour" value="${vo.seminarTime / 60 }" integerOnly="true" />
													<fmt:parseNumber var="min" value="${vo.seminarTime % 60 }" integerOnly="true" />
													<p class="lect_name">${vo.seminarNm }</p>
													<span class="fcGrey">
														<small class="fcBlue">${vo.seminarCtgrNm }</small> | 
														<small><spring:message code="seminar.label.progress.date" /><!-- 진행일시 --> : ${seminarStartDttm }</small> | 
														<small><c:if test="${hour > 0 }">${hour }<spring:message code="seminar.label.time" /><!-- 시간 --> </c:if>${min }<spring:message code="seminar.label.min" /><!-- 분 --></small>
														<c:if test="${vo.seminarCtgrCd eq 'online' }">
															 | <small class="fcBlue">
																<spring:message code="seminar.label.attend.aply" /><!-- 출결반영 --> : 
																<c:choose>
																	<c:when test="${vo.attProcYn eq 'Y' }">
																		<spring:message code="seminar.common.yes" /><!-- 예 -->
																	</c:when>
																	<c:otherwise>
																		<spring:message code="seminar.common.no" /><!-- 아니오 -->
																	</c:otherwise>
																</c:choose>
															</small>
														</c:if>
													</span>
												</div>
											</div>
										</div>
										<i class="dropdown icon ml20"></i>
									</div>
									<div class="content active">
										<div class="ui segment">
											<ul class="tbl" style="word-break: break-word;">
												<li>
													<dl>
														<dt>
															<label for="subjectLabel"><spring:message code="seminar.label.seminar.cts" /><!-- 세미나 내용 --></label>
														</dt>
														<dd><pre>${vo.seminarCts }</pre></dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label for="teamLabel"><spring:message code="seminar.label.progress.time" /><!-- 진행시간 --></label>
														</dt>
														<dd class="fcBlue">
															<c:if test="${hour > 0 }">${hour }<spring:message code="seminar.label.time" /><!-- 시간 --> </c:if>${min }<spring:message code="seminar.label.min" /><!-- 분 -->
														</dd>
														<dt>
															<label><spring:message code="seminar.label.schedule" /><!-- 주차 --></label>
														</dt>
														<dd>
															<c:choose>
																<c:when test="${not empty vo.lessonScheduleOrder && not empty vo.lessonTimeOrder }">
																	${vo.lessonScheduleOrder }<spring:message code="seminar.label.schedule" /><!-- 주차 -->
																</c:when>
																<c:otherwise>
																	<spring:message code="seminar.label.not.applicable" /><!-- 해당없음 -->
																</c:otherwise>
															</c:choose>
														</dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label for="contLabel"><spring:message code="seminar.label.file" /><!-- 첨부파일 --></label>
														</dt>
														<dd>
															<c:forEach var="list" items="${vo.fileList }">
																<button class="ui icon small button" id="file_${list.fileSn }" title="파일다운로드" onclick="fileDown(`${list.fileSn }`, `${list.repoCd }`)"><i class="ion-android-download"></i> </button>
																<script>
																	byteConvertor("${list.fileSize}", "${list.fileNm}", "${list.fileSn}");
																</script>
															</c:forEach>
														</dd>
													</dl>
												</li>
												<c:if test="${vo.seminarCtgrCd eq 'online' || vo.seminarCtgrCd eq 'free' }">
													<li>
														<dl>
															<dt><label>Zoom <spring:message code="seminar.label.meeting" /><!-- 회의 --> ID</label></dt>
															<dd>${vo.zoomId }</dd>
														</dl>
													</li>
													<li>
														<dl>
															<dt><label>Zoom <spring:message code="seminar.label.meeting" /><!-- 회의 --> PW</label></dt>
															<dd class="ui form">
																<div class="option-content">
																	${vo.zoomPw }
																	<div class="mla mr20">
																		<c:choose>
																			<c:when test="${vo.profNo eq userId }">
																				<a href="javascript:startHost()" class="ui black button">Zoom <spring:message code="seminar.button.participation" /><!-- 참여하기 --></a>
																			</c:when>
																			<c:otherwise>
																				<a href="javascript:startJoin()" class="ui black button">Zoom <spring:message code="seminar.button.participation" /><!-- 참여하기 --></a>
																			</c:otherwise>
																		</c:choose>
																	</div>
																</div>
															</dd>
														</dl>
													</li>
													<li>
														<dl>
															<dt><label>Zoom <spring:message code="seminar.label.stu" /><!-- 학생 --> URL</label></dt>
															<dd>${vo.joinUrl }</dd>
														</dl>
													</li>
													<c:if test="${vo.attProcYn eq 'Y' }">
														<li>
															<dl>
																<dt><label><spring:message code="seminar.label.real.progress.time" /><!-- 실진행시간 --></label></dt>
																<dd class="fcBlue">
																	<fmt:parseNumber var="atndMin" value="${vo.tchAtndTime / 60 }" integerOnly="true" />
																	<fmt:parseNumber var="atndSec" value="${vo.tchAtndTime % 60 }" integerOnly="true" />
																	<c:if test="${atndMin > 0 }">${atndMin }<spring:message code="seminar.label.min" /><!-- 분 --></c:if> ${atndSec }<spring:message code="seminar.label.sec" /><!-- 초 -->
																</dd>
															</dl>
														</li>
													</c:if>
												</c:if>
											</ul>
										</div>
									</div>
								</div>

				        		<div class="ui segment">
						        	<div class="option-content mb20">
						        		<p class="mr15"><spring:message code="seminar.label.student" /><!-- 수강생 --></p>
						        		<span>[ <spring:message code="seminar.label.total" /><!-- 총 --> <label id="stdCnt" class="fcBlue"></label><spring:message code="seminar.label.cnt" /><!-- 건 --> ]</span>
						        		<div class="mla">
						        			<uiex:msgSendBtn func="sendMsg()" styleClass="ui basic small button"/><!-- 메시지 -->
						        			
						        			<c:if test="${vo.seminarStatus eq '완료' }">
							        			<c:if test="${vo.seminarCtgrCd eq 'offline' }">
							        				<a href="javascript:stdAttendForm('edit')" class="ui blue small button viewBtn attendBtn"><spring:message code="seminar.button.attend.process" /><!-- 출결 체크 하기 --></a>
							        			</c:if>
							        			<c:if test="${vo.seminarCtgrCd eq 'online' }">
							        				<c:if test="${vo.attProcYn eq 'N' }">
								        				<a href="javascript:zoomAttendSetApi()" class="ui blue small button"><spring:message code="seminar.button.atnd.info.set" /><!-- 출결정보 가져오기 --></a>
							        				</c:if>
							        				<c:if test="${vo.attProcYn eq 'Y' }">
							        					<a href="javascript:stdAttendListPop()" class="ui blue small button"><spring:message code="seminar.label.zoom.attend.log" /><!-- ZOOM 참석로그 보기 --></a>
								        				<a href="javascript:stdAttendForm('edit')" class="ui blue small button viewBtn attendBtn"><spring:message code="seminar.button.attend.bring.edit" /><!-- 출결 일괄 수정 --></a>
							        				</c:if>
							        			</c:if>
							        			<c:if test="${vo.seminarCtgrCd eq 'free' }">
							        				<a href="javascript:stdAttendListPop()" class="ui blue small button"><spring:message code="seminar.label.zoom.attend.log" /><!-- ZOOM 참석로그 보기 --></a>
							        			</c:if>
								        		<a href="javascript:stdAttendForm('edit')" class="ui blue small button editBtn attendBtn"><spring:message code="seminar.button.attend.log.save.cancel" /><!-- 출결 기록 저장 취소 --></a>
								        		<a href="javascript:saveAttend()" class="ui blue small button editBtn attendBtn"><spring:message code="seminar.button.attend.log.save" /><!-- 출결 기록 저장 --></a>
								        		<c:if test="${(vo.seminarCtgrCd eq 'online' || vo.seminarCtgrCd eq 'free') && vo.autoRecordYn eq 'Y' }">
								        			<a href="javascript:recordView()" class="ui blue small button"><spring:message code="seminar.button.record.view" /><!-- 녹화영상 보기 --></a>
								        		</c:if>
						        			</c:if>
						        		</div>
						        	</div>
						        	<div class="option-content mb20">
						        		<div class="mla editBtn attendBtn">
							        		<a href="javascript:attendAllCheck('ATTEND')" class="ui blue small button"><spring:message code="seminar.button.all.attend.check" /><!-- 전체 출석 체크 --></a>
							        		<a href="javascript:attendAllCheck('ABSENT')" class="ui red small button"><spring:message code="seminar.button.all.absent.check" /><!-- 전체 결석 체크 --></a>
						        		</div>
						        	</div>
						        	<div class="option-content mb20">
						        		<select class="ui dropdown" id="atndCd" onchange="listStd()">
						        			<option value="ALL"><spring:message code="seminar.common.search.all" /><!-- 전체 --></option>
						        			<option value="ATTEND"><spring:message code="seminar.label.attend" /><!-- 출석 --></option>
						        			<option value="LATE"><spring:message code="seminar.label.late" /><!-- 지각 --></option>
						        			<option value="ABSENT"><spring:message code="seminar.label.absent" /><!-- 결석 --></option>
						        			<option value="NONE"><spring:message code="seminar.label.pending" /><!-- 미걸 --></option>
						        		</select>
						        		<div class="ui action input search-box">
										    <input type="text" placeholder="<spring:message code='seminar.label.dept' />, <spring:message code='seminar.label.user.no' />, <spring:message code='seminar.label.user.nm' /> <spring:message code='seminar.button.input' />" class="w250" id="searchValue"><!-- 학과 --><!-- 학번 --><!-- 이름 --><!-- 입력 -->
										    <button class="ui icon button" onclick="listStd()"><i class="search icon"></i></button>
										</div>
						        	</div>
						        	<table class="table type2" data-sorting="true" data-paging="false" data-empty="<spring:message code='seminar.common.empty' />" id="stdTable"><!-- 등록된 내용이 없습니다. -->
						        		<thead>
						        			<tr>
						        				<th scope="col" class="tc num" data-sortable="false">
													<div class="ui checkbox">
														<input type="hidden" id="stdNos" name="stdNos">
									                    <input type="checkbox" name="allEvalChk" id="allChk" value="all" onchange="checkAllStdNoToggle(this)">
									                    <label class="toggle_btn" for="allChk"></label>
									                </div>
												</th>
												<th class="tc" data-sortable="false"><spring:message code="common.number.no" /></th><!-- NO. -->
												<th class="tc" data-breakpoints="xs"><spring:message code="seminar.label.dept" /><!-- 학과 --></th>
												<th class="tc"><spring:message code="seminar.label.user.no" /><!-- 학번 --></th>
												<th class="tc" data-breakpoints="xs"><spring:message code="seminar.label.user.grade" /><!-- 학년 --></th>
												<c:if test="${creCrsVO.univGbn eq '3' or creCrsVO.univGbn eq '4'}">
													<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="common.label.grsc.degr.cors.gbn" /><!-- 학위과정 --></th>
												</c:if>
												<th class="tc"><spring:message code="seminar.label.user.nm" /><!-- 이름 --></th>
												<th class="tc" data-breakpoints="xs"><spring:message code="seminar.label.admission.year" /><!-- 입학년도 --></th>
												<th class="tc" data-breakpoints="xs"><spring:message code="seminar.label.admission.grade" /><!-- 입학학년 --></th>
												<th class="tc" data-breakpoints="xs"><spring:message code="seminar.label.admission.type" /><!-- 입학구분 --></th>
						        			</tr>
						        		</thead>
						        		<tbody id="stdList">
						        		</tbody>
						        	</table>
						        </div>
						        <div class="option-content">
						        	<div class="mla">
							            <a href="javascript:editSeminar()" class="ui blue button"><spring:message code="seminar.button.edit" /><!-- 수정 --></a>
							            <c:if test="${vo.seminarStartYn ne 'Y' }">
								            <a href='javascript:delSeminar()' class='ui basic button'><spring:message code='seminar.button.delete' /><!-- 삭제 --></a>
							            </c:if>
						            	<a href="javascript:listSeminar()" class="ui basic button"><spring:message code="seminar.button.list" /><!-- 목록 --></a>
						            </div>
						        </div>
				        	</div>
				        </div>
		        	</div>
		        </div>
            </div>
            <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
        </div>
        <!-- //본문 content 부분 -->
    </div>

</body>

</html>

