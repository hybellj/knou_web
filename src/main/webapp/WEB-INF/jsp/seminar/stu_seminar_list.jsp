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
	
	// 세미나 목록
	function listSeminar() {
		var url = "/seminar/seminarHome/seminarList.do";
		var data = {
			"crsCreCd" 	  : "${crsCreCd}",
			"stdNo"		  : "${stdVO.stdNo}",
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
			html += "<table class='table type2' data-sorting='false' data-paging='false' data-empty='" + "<spring:message code='seminar.common.empty' />" + "' id='seminarTable'>";/* 등록된 내용이 없습니다. */
			html += "	<thead>";
			html += "		<tr>";
			html += "			<th class='tc'><spring:message code='common.number.no' /></th>";/* NO. */
			html += "			<th class='tc'><spring:message code='seminar.label.type' /></th>";/* 구분 */
			html += "			<th class='tc'><spring:message code='seminar.label.seminar.nm' /></th>";/* 세미나명 */
			html += "			<th class='tc' data-breakpoints='xs'><spring:message code='seminar.label.progress.date' /></th>";/* 진행일시 */
			html += "			<th class='tc' data-breakpoints='xs'><spring:message code='seminar.label.progress.time' /></th>";/* 진행시간 */
			html += "			<th class='tc' data-breakpoints='xs sm md'><spring:message code='seminar.label.schedule' /></th>";/* 주차 */
			html += "			<th class='tc' data-breakpoints='xs sm md'><spring:message code='seminar.label.lesson.time' /></th>";/* 교시 */
			html += "			<th class='tc' data-breakpoints='xs sm'><spring:message code='seminar.label.attend.status' /></th>";/* 출결현황 */
			html += "			<th class='tc'>Zoom <spring:message code='seminar.label.participation' /></th>";/* 참여 */
			html += "		</tr>";
			html += "	</thead>";
			html += "	<tbody>";
			returnList.forEach(function(v, i) {
			html += "		<tr>";
			html += "			<td class='tc'>" + v.lineNo + "</td>";
			html += "			<td class='tc'>" + v.seminarCtgrNm + "</td>";
			html += "			<td><a href='javascript:seminarView(\"" + v.seminarId + "\")' class='header header-icon link'>" + v.seminarNm + "</a></td>";
			html += "			<td class='tc'>" + dateFormat("date", v.seminarStartDttm) + "</td>";
			html += "			<td class='tc'>" + dateFormat("timeStr", v.seminarTime) + "</td>";
			html += "			<td class='tc'>" + dataNullCheck("hyphen", v.lessonScheduleOrder) + "</td>";
			html += "			<td class='tc'>" + dataNullCheck("hyphen", v.lessonTimeOrder) + "</td>";
			if("${auditYn}" == "Y") {
			html += "			<td class='tc'>-</td>";
			} else {
			html += "			<td class='tc'>" + attendFormat("nonsuspense", v.stdAttendStatus) + "</td>";
			}
			html += "			<td class='tc'>";
			if("${auditYn}" != "Y") {
				if(v.seminarStatus == "완료") {
			html += "				<a href='javascript:seminarView(\""+v.seminarId+"\")' class='ui small basic button'><spring:message code='seminar.button.participation.info' /></a>";/* 참여정보 */
				}
				if(v.seminarCtgrCd == "online" && v.seminarStatus != "완료" && v.seminarStartYn == "Y") {
			html += "				<a href='javascript:startJoin(\""+v.seminarId+"\")' class='ui small basic button'><spring:message code='seminar.button.participation' /></a>";/* 참여하기 */
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
				var lessonSchedule	 = v.lessonScheduleOrder == null && v.lessonTimeOrder == null ? "<spring:message code='seminar.label.not.applicable' />"/* 해당없음 */ : v.lessonScheduleOrder + "<spring:message code='seminar.label.schedule' /> / "/* 주차 */ + v.lessonTimeOrder + "<spring:message code='seminar.label.lesson.time' />"/* 교시 */;
				var statusClass	     = v.seminarStatus == "진행" ? "bar-blue" : "bar-softgrey";
				html += "<div class='card'>";
				html += "	<div class='content card-item-center'>";
				html += "		<div class='title-box'>";
				html += "			<label class='ui blue label active'><spring:message code='seminar.label.seminar' /></label>";/* 세미나 */
				html += "			<a href='javascript:seminarView(\"" + v.seminarId + "\")' class='header header-icon link'>" + v.seminarNm + "</a>";
				html += "		</div>";
				html += "	</div>";
				html += "	<div class='sum-box'>";
				html += "		<ul class='process-bar'>";
				html += "			<li class=\"" + statusClass + "\" style='width: 100%;'><spring:message code='seminar.label.seminar' /> " + v.seminarStatus + "</li>";/* 세미나 */
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
				html += "				<i>" + attendFormat("attendColor", v.stdAttendStatus) + "</i>";
				html += "			</div>";
				html += "		</div>";
				if(v.seminarCtgrCd == "online" && v.seminarStatus != "완료" && v.seminarStartYn == "Y" && "${auditYn}" != "Y") {
				html += "		<div class='tr'>";
				html += "			<a href='javascript:startJoin(\"" + v.seminarId + "\")' class='ui blue button'><spring:message code='seminar.button.seminar.part' /></a>";/* 세미나 참여 */
				html += "		</div>";
				}
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
	
	// 세미나 정보 페이지
	function seminarView(seminarId) {
		var kvArr = [];
		kvArr.push({'key' : 'seminarId', 'val' : seminarId});
		kvArr.push({'key' : 'stdNo',     'val' : "${stdVO.stdNo}"});
		kvArr.push({'key' : 'crsCreCd',  'val' : "${crsCreCd}"});
		
		submitForm("/seminar/seminarHome/stuSeminarView.do", "", "", kvArr);
	}
	
	// 세미나 참여
	function startJoin(seminarId) {
		var url  = "/seminar/seminarHome/zoomJoinStart.do";
		var data = {
			"seminarId" : seminarId,
			"crsCreCd"  : "${crsCreCd}",
			"stdNo"		: "${stdVO.stdNo}"
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
				        </div>
				        <div class="row">
				        	<div class="col">
				        		<div class="option-content mb20">
					        		<button class="ui basic icon button" id="listType" title="리스트형 출력"><i class="list ul icon"></i></button>
				        			<div class="ui action input search-box">
				        				<label for="searchSeminarValue" class="hide"><spring:message code='seminar.label.seminar.nm' /></label>
									    <input id="searchSeminarValue" type="text" placeholder="<spring:message code='seminar.label.seminar.nm' /> <spring:message code='seminar.button.input' />" class="w250" id="searchValue"><!-- 세미나명 --><!-- 입력 -->
									    <button class="ui icon button" onclick="listSeminar(1)"><i class="search icon"></i></button>
									</div>
				        		</div>
				        		<div id="list"></div>
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

