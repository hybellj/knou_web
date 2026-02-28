<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">

<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/seminar/common/seminar_common_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

<script type="text/javascript">
	$(document).ready(function () {
		listSeminar();
		
		$("#searchValue").on("keyup", function(e) {
			if(e.keyCode == 13) {
				listSeminar();
			}
		});
		
		$("#listType").on("click", function() {
			$(this).children("i").toggleClass("list th");
			listSeminar();
		});
	});
	
	// 페이지 이동
	function viewSeminar(tab, seminarId) {
		var urlMap = {
			"1" : "/seminar/seminarHome/Form/seminarWrite.do",		// 세미나 등록 페이지
			"2" : "/seminar/seminarHome/seminarAttendManage.do"		// 세미나 출결관리 페이지
		};
		
		var kvArr = [];
		kvArr.push({'key' : 'crsCreCd',  'val' : "${crsCreCd}"});
		kvArr.push({'key' : 'seminarId', 'val' : seminarId});
		
		submitForm(urlMap[tab], "", "", kvArr);
	}
	
	// 세미나 목록
	function listSeminar() {
		var	url = "/seminar/seminarHome/seminarList.do";
		var data = {
			"crsCreCd" 	  : "${crsCreCd}",
			"searchValue" : $("#searchValue").val()
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				var returnList = data.returnList || [];
        		var html = createSeminarListHTML(returnList);
        		
        		$("#list").empty().html(html);
        		if($("#listType i").hasClass("th")){
	    			$("#seminarTable").footable();
        		} else {
        			$(".ui.dropdown").dropdown();
        			$(".card-item-center .title-box label").unbind('click').bind('click', function(e) {
        		        $(".card-item-center .title-box label").toggleClass('active');
        		    });
        		}
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='seminar.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
		});
	}
	
	// 세미나 목록 폼 생성
	function createSeminarListHTML(returnList) {
		var html = "";
		
		if($("#listType i").hasClass("th")){
			html += "<table class='table type2' data-sorting='false' data-paging='false' data-empty='"+"<spring:message code='seminar.common.empty' />"+"' id='seminarTable'>";/* 등록된 내용이 없습니다. */
			html += "	<thead>";
			html += "		<tr>";
			html += "			<th class='tc'><spring:message code='common.number.no' /></th>";/*NO.*/
			html += "			<th class='tc'><spring:message code='seminar.label.type' /></th>";/* 구분 */
			html += "			<th class='tc'><spring:message code='seminar.label.seminar.nm' /></th>";/* 세미나명 */
			html += "			<th class='tc' data-breakpoints='xs'><spring:message code='seminar.label.progress.date' /></th>";/* 진행일시 */
			html += "			<th class='tc' data-breakpoints='xs'><spring:message code='seminar.label.progress.time' /></th>";/* 진행시간 */
			html += "			<th class='tc' data-breakpoints='xs sm md'><spring:message code='seminar.label.schedule' /></th>";/* 주차 */
			html += "			<th class='tc' data-breakpoints='xs sm md'><spring:message code='seminar.label.lesson.time' /></th>";/* 교시 */
			html += "			<th class='tc'><spring:message code='seminar.label.part.atnd.status' /></th>";/* 참여/출결현황 */
			html += "		</tr>";
			html += "	</thead>";
			html += "	<tbody>";
			returnList.forEach(function(v, i) {
			html += "		<tr>";
			html += "			<td class='tc'>" + v.lineNo + "</td>";
			html += "			<td class='tc'>" + v.seminarCtgrNm + "</td>";
			html += "			<td><a href='javascript:viewSeminar(2, \"" + v.seminarId + "\")' class='header header-icon link'>" + v.seminarNm + "</a></td>";
			html += "			<td class='tc'>" + dateFormat("date", v.seminarStartDttm) + "</td>";
			html += "			<td class='tc'>" + dateFormat("timeStr", v.seminarTime) + "</td>";
			html += "			<td class='tc'>" + dataNullCheck("hyphen", v.lessonScheduleOrder) + "</td>";
			html += "			<td class='tc'>" + dataNullCheck("hyphen", v.lessonTimeOrder) + "</td>";
			html += "			<td class='tc'>";
			if(v.seminarStatus == "완료") {
				if(v.seminarCtgrCd == "online" && v.attProcYn == "N") {
			html += "				<a href='javascript:zoomAttendSetApi(\"" + v.seminarId + "\", \"" + v.zoomId + "\")' class='ui small blue button'><spring:message code='seminar.button.atnd.info.set' /></a>";/* 출결정보 가져오기 */
				} else if(v.seminarCtgrCd == "free") {
				} else {
			html += "				<spring:message code='seminar.label.attend' /> <span class='fcBlue'>" + v.seminarAttendUserCnt + "</span> <spring:message code='seminar.label.late' /> <span class='fcYellow'>" + v.seminarLateUserCnt + "</span> <spring:message code='seminar.label.absent' /> <span class='fcRed'>" + v.seminarAbsentUserCnt + "</span>";/* 출석 *//* 지각 *//* 결석 */
				}
			} else if(v.seminarCtgrCd == "online" && v.seminarStartYn == "Y") {
				if(v.profNo == "${userId}") {
			html += "				<a href='javascript:startHost(\"" + v.seminarId + "\")' class='ui small blue button'><spring:message code='seminar.button.seminar.start' /></a>";/* 세미나 시작 */
				} else {
			html += "				<a href='javascript:startJoin(\"" + v.seminarId + "\")' class='ui small blue button'><spring:message code='seminar.button.seminar.part' /></a>";/* 세미나 참여 */
				}
			}
			html += "			</td>";
			html += "		</tr>";
			});
			html += "	</tbody>";
			html += "</table>";
		} else {
			if(returnList.length > 0) {
				html += "<div class='ui two stackable cards info-type mt10'>";
				returnList.forEach(function(v, i) {
				var lessonScheduleOrder = v.lessonScheduleOrder == null ? "-" : v.lessonScheduleOrder;
				var lessonTimeOrder  = v.lessonTimeOrder == null ? "-" : v.lessonTimeOrder;
				var lessonSchedule	 = v.lessonScheduleOrder == null && v.lessonTimeOrder == null ? "<spring:message code='seminar.label.not.applicable' />"/* 해당없음 */ : lessonScheduleOrder + "<spring:message code='seminar.label.schedule' /> / "/* 주차 */ + lessonTimeOrder + "<spring:message code='seminar.label.lesson.time' />"/* 교시 */;
				var attendPersent    = parseInt((v.seminarJoinStdCnt * 100) / v.seminarTotalStdCnt);
				var absentPersent	 = parseInt(((v.seminarTotalStdCnt - v.seminarJoinStdCnt) * 100) / v.seminarTotalStdCnt);
				html += "<div class='card'>";
				html += "	<div class='content card-item-center'>";
				html += "		<div class='title-box'>";
				html += "			<label class='ui blue label active'><spring:message code='seminar.label.seminar' />​</label>";/* 세미나 */
				html += "			<a href='javascript:viewSeminar(2, \"" + v.seminarId + "\")' class='header header-icon link'>" + v.seminarNm + "</a>";
				html += "		</div>";
				html += "		<div class='ui top right pointing dropdown right-box'>";
				html += "			<span class='bars'><spring:message code='seminar.label.menu' /></span>";/* 메뉴 */
				html += "			<div class='menu'>";
				html += "				<a href='javascript:viewSeminar(2, \"" + v.seminarId + "\")' class='item'><spring:message code='seminar.button.attend.manage' /></a>";/* 출결관리 */
				if(v.rgtrId == "${userId}" && v.seminarStartYn != "Y") {
				html += "				<a href='javascript:delSeminar(\"" + v.seminarId + "\")' class='item'><spring:message code='seminar.button.delete' /></a>";/* 삭제 */
				}
				html += "			</div>";
				html += "		</div>";
				html += "	</div>";
				html += "	<div class='sum-box'>";
				html += "		<ul class='process-bar'>";
				html += "			<li class='bar-blue' style='width: " + attendPersent + "%;'>" + v.seminarJoinStdCnt + "<spring:message code='seminar.label.persons' /></li>";/* 명 */
				html += "			<li class='bar-softgrey' style='width: " + absentPersent + "%;'>" + (v.seminarTotalStdCnt-v.seminarJoinStdCnt) + "<spring:message code='seminar.label.persons' /></li>";/* 명 */
				html += "		</ul>";
				html += "	</div>";
				html += "	<div class='content ui form equal width'>";
				html += "		<div class='fields'>";
				html += "			<div class='inline field'>";
				html += "				<label class='label-title-lg'><spring:message code='seminar.label.progress.date' /></label>";/* 진행일시 */
				html += "				<i>" + dateFormat("date", v.seminarStartDttm) + "</i>";
				html += "			</div>";
				html += "		</div>";
				html += "		<div class='fields'>";
				html += "			<div class='inline field'>";
				html += "				<label class='label-title-lg'><spring:message code='seminar.label.progress.time' /></label>";/* 진행시간 */
				html += "				<i>" + dateFormat("timeStr", v.seminarTime) + "</i>";
				html += "			</div>";
				html += "		</div>";
				html += "		<div class='fields'>";
				html += "			<div class='inline field'>";
				html += "				<label class='label-title-lg'><spring:message code='seminar.label.schedule' />/<spring:message code='seminar.label.lesson.time' /></label>";/* 주차 *//* 교시 */
				html += "				<i>" + lessonSchedule + "</i>";
				html += "			</div>";
				html += "		</div>";
				html += "		<div class='fields'>";
				html += "			<div class='inline field'>";
				html += "				<label class='label-title-lg'><spring:message code='seminar.label.type' /></label>";/* 구분 */
				html += "				<i>" + v.seminarCtgrNm + "</i>";
				html += "			</div>";
				html += "		</div>";
				html += "		<div class='fields'>";
				html += "			<div class='inline field'>";
				html += "				<label class='label-title-lg'><spring:message code='seminar.label.attend.status' /></label>";/* 출결현황 */
				if(v.seminarCtgrCd == "online" && v.attProcYn == "N") {
				html += "				<i>-</i>";
				} else if(v.seminarCtgrCd == "free") {
				} else {
				html += "				<i><spring:message code='seminar.label.attend' /> <span class='fcBlue'>" + v.seminarAttendUserCnt + "</span> <spring:message code='seminar.label.late' /> <span class='fcYellow'>" + v.seminarLateUserCnt + "</span> <spring:message code='seminar.label.absent' /> <span class='fcRed'>" + v.seminarAbsentUserCnt + "</span></i>";/* 출석 *//* 지각 *//* 결석 */
				}
				html += "			</div>";
				html += "		</div>";
				html += "		<div class='tr'>";
				if(v.seminarStatus == "완료") {
				html += "			<a href='javascript:void(0)' class='ui blue small button'><spring:message code='seminar.button.seminar.end' /></a>";/* 세미나 종료 */
				} else if(v.seminarCtgrCd == "online" && v.seminarStartYn == "Y") {
					if(v.profNo == "${userId}") {
				html += "			<a href='javascript:startHost(\"" + v.seminarId + "\")' class='ui blue small button'><spring:message code='seminar.button.seminar.start' /></a>";/* 세미나 시작 */
					} else {
				html += "			<a href='javascript:startJoin(\"" + v.seminarId + "\")' class='ui blue small button'><spring:message code='seminar.button.seminar.part' /></a>";/* 세미나 참여 */
					}
				}
				html += "		</div>";
				html += "	</div>";
				html += "</div>";
				});
				html += "</div>";
			} else {
				html += "<div class='flex-container m-hAuto'>";
				html += "	<div class='no_content'>";
				html += "		<i class='icon-cont-none ico f170'></i>";
				html += "		<span><spring:message code='common.content.not_found' /></span>";/* 등록된 내용이 없습니다. */
				html += "	</div>";
				html += "</div>";
			}
		}
		
		return html;
	}
	
	// 세미나 삭제
	function delSeminar(seminarId) {
		var confirm = window.confirm("<spring:message code='seminar.confirm.delete' />");/* 삭제 하시겠습니까? */
		
		if(confirm) {
			var url  = "/seminar/seminarHome/delSeminar.do";
			var data = {
				"seminarId" : seminarId
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
	
	// 세미나 시작 ( 호스트 )
	function startHost(seminarId) {
		var url  = "/seminar/seminarHome/zoomHostStart.do";
		var data = {
			"seminarId" : seminarId
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
	
	// 세미나 참여 ( 참여자 )
	function startJoin(seminarId) {
		var url  = "/seminar/seminarHome/zoomJoinStart.do";
		var data = {
			"seminarId" : seminarId,
			"crsCreCd"  : "${crsCreCd}"
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
	
	// Zoom 출결 확정 API 호출
	function zoomAttendSetApi(seminarId, zoomId) {
		var url  = "/seminar/seminarHome/zoomAttendSet.do";
		var data = {
			"seminarId" : seminarId,
			"zoomId"	: zoomId,
			"crsCreCd"  : "${crsCreCd}"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				alert("<spring:message code='seminar.alert.process.zoom.attend' />");/* Zoom 출결 처리가 완료되었습니다. */
				listSeminar();
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='seminar.error.process.zoom.attend' />");/* Zoom 출결 처리 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
		});
	}
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
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
							setLocationBar('<spring:message code="seminar.label.seminar" />', '<spring:message code="seminar.button.list" />');
						});
						</script>
						
				        <div id="info-item-box">
				        	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="seminar.label.seminar" /><!-- 세미나 -->
                            </h2>
				            <div class="button-area">
				            	<a href="javascript:viewSeminar(1, '')" class="ui blue button"><spring:message code="seminar.button.seminar.add" /><!-- 세미나 등록 --></a>
				            </div>
				        </div>
				        <div class="row">
				        	<div class="col">
				        		<div class="option-content mb20">
					        		<button class="ui basic icon button" id="listType" title="리스트형 출력"><i class="th ul icon"></i></button>
				        			<div class="ui action input search-box">
									    <input type="text" placeholder="<spring:message code='seminar.label.seminar.nm' /> <spring:message code='seminar.button.input' />" class="w250" id="searchValue"><!-- 세미나명 --><!-- 입력 -->
									    <button class="ui icon button" onclick="listSeminar()"><i class="search icon"></i></button>
									</div>
				        		</div>
				        		<div id="list"></div>
				        		<div class="option-content">
				        			<div class="mla">
						            	<a href="javascript:viewSeminar(1, '')" class="ui blue button"><spring:message code="seminar.button.seminar.add" /><!-- 세미나 등록 --></a>
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

