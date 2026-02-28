<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	
	<script type="text/javascript">
		var TERM_LESSON_LIST = [];
	
		$(document).ready(function() {
			
			// 학기 목록 조회
			listTerm();
		});
		
		// 학기 목록 조회
		function listTerm() {
			var url = "/crs/termMgr/listTermLesson.do"
			var data = {
				  termCd : '<c:out value="${vo.termCd}" />'
				, enrlType: "ONLINE"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		
	        		returnList = returnList;
	        		
	        		if(returnList.length > 0) {
	        			TERM_LESSON_LIST = returnList;
	        			
	        			createTermLessonList();
	        		} else {
	        			for(var i = 0; i < 15; i++) {
	        				TERM_LESSON_LIST.push({});
	        				
	        				// 주차 목록 생성
	        				createTermLessonList();
	        			}
	        		}
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		// 주차 목록 생성
		function createTermLessonList() {
			$("#lessonTermList").empty();
			$("#lessonTermList2").empty();

			// 좌측
			TERM_LESSON_LIST.forEach(function(v, i) {
				var lsnOdr = (i + 1);
				var startDt = v.startDt || "";
				var endDt = v.endDt || "";
				
				startDt = startDt.length >= 8 ? startDt.substring(0, 4) + "." + startDt.substring(4, 6) + "." + startDt.substring(6, 8) : "";
				endDt = endDt.length >= 8 ? endDt.substring(0, 4) + "." + endDt.substring(4, 6) + "." + endDt.substring(6, 8) : "";
				console.log("lsnOdr=====>"+lsnOdr + " // " + "startDt========>"+startDt)
				var html = '';
				html += '<div class="inline fields" data-lsn-odr="' + lsnOdr+ '">';
				html += '	<label class="w80">' + lsnOdr + '<spring:message code="common.week"/></label>'; // 주차
				html += '	 <div class="field">';
				html += '	   <div class="ui calendar" id="cStartdt' + lsnOdr + '" >';
				html += '			<div class="ui input left icon"> ';
				html += '				<i class="calendar alternate outline icon"></i> ';
				html += '				<input id="startDt' + lsnOdr + '" name="startDt' + lsnOdr + '"  type="text" value="' + startDt + '" placeholder="<spring:message code="common.start.date"/>" autocomplete="off" />'; // 시작일
				html += '			</div>';
				html += '		</div>';
				html += '	</div>';
				html += '	<span class="time-sort">~</span> ';
				html += '	<div class="field"> ';
				html += '		<div class="ui calendar" id="cEnddt' + lsnOdr + '" >';
				html += '			<div class="ui input left icon">';
				html += '				<i class="calendar alternate outline icon"></i>';
				html += '				<input id="endDt' + lsnOdr + '" name="endDt' + lsnOdr + '" type="text"  value="' + endDt + '" placeholder="<spring:message code="common.enddate"/>" autocomplete="off" />'; // 종료일
				html += '			</div>';
				html += '		</div>';
				html += '	</div>';
				html += '	<div class="img-button">';
				html += '		<button type="button" class="icon_cancel" onclick="delRow(\'' + lsnOdr + '\')">';
				html += '	</div> ';
				html += '</div>';
				
				$("#lessonTermList").append(html);
				
				setTimeout(function() {
					createCalendar($("#cStartdt" + lsnOdr), $("#cStartdt" + lsnOdr), $("#cEnddt" + lsnOdr), 'START');
					createCalendar($("#cEnddt" + lsnOdr), $("#cStartdt" + lsnOdr), $("#cEnddt" + lsnOdr), 'END');
				}, 0);
			});
			
			// 우측
			TERM_LESSON_LIST.forEach(function(v, i) {
				var lsnOdr = (i + 1);
				var ltDetmFrDt = v.ltDetmFrDt || "";
				var ltDetmToDt = v.ltDetmToDt || "";
				
				ltDetmFrDt = ltDetmFrDt.length >= 8 ? ltDetmFrDt.substring(0, 4) + "." + ltDetmFrDt.substring(4, 6) + "." + ltDetmFrDt.substring(6, 8) : "";
				ltDetmToDt = ltDetmToDt.length >= 8 ? ltDetmToDt.substring(0, 4) + "." + ltDetmToDt.substring(4, 6) + "." + ltDetmToDt.substring(6, 8) : "";
				
				var html = '';
				html += '<div class="inline fields">';
				html += '	<label class="w80">' + lsnOdr + '<spring:message code="common.week"/></label>'; // 주차
				html += '	 <div class="field">';
				html += '	   <div class="ui calendar" id="cLtDetmFrDt' + lsnOdr + '" >';
				html += '			<div class="ui input left icon"> ';
				html += '				<i class="calendar alternate outline icon"></i> ';
				html += '				<input id="ltDetmFrDt' + lsnOdr + '" name="ltDetmFrDt' + lsnOdr + '"  type="text" value="' + ltDetmFrDt + '" placeholder="<spring:message code="common.start.date"/>" autocomplete="off" />'; // 시작일
				html += '			</div>';
				html += '		</div>';
				html += '	</div>';
				html += '	<span class="time-sort">~</span> ';
				html += '	<div class="field"> ';
				html += '		<div class="ui calendar" id="cLtDetmToDt' + lsnOdr + '" >';
				html += '			<div class="ui input left icon">';
				html += '				<i class="calendar alternate outline icon"></i>';
				html += '				<input id="ltDetmToDt' + lsnOdr + '" name="ltDetmToDt' + lsnOdr + '" type="text"  value="' + ltDetmToDt + '" placeholder="<spring:message code="common.enddate"/>" autocomplete="off" />'; // 종료일
				html += '			</div>';
				html += '		</div>';
				html += '	</div>';
				html += '</div>';
				
				$("#lessonTermList2").append(html);
				
				setTimeout(function() {
					createCalendar($("#cLtDetmFrDt" + lsnOdr), $("#cLtDetmFrDt" + lsnOdr), $("#cLtDetmToDt" + lsnOdr), 'START');
					createCalendar($("#cLtDetmToDt" + lsnOdr), $("#cLtDetmFrDt" + lsnOdr), $("#cLtDetmToDt" + lsnOdr), 'END');
				}, 0);
			});
		}
	
		// 주차 추가 
		function addRow() {
			TERM_LESSON_LIST.push({});
			
			// 주차 목록 생성
			createTermLessonList();
		}
		
		// 주차 삭제
		function delRow(lsnOdr) {
			// 리스트 날짜 세팅
			setTermListValue();
			
			// 선택 주차 제거
			TERM_LESSON_LIST = TERM_LESSON_LIST.filter(function(v, i) {
				return (i + 1) != lsnOdr;
			});
			
			// 주차 목록 생성
			createTermLessonList();
		}
		
		// 저장
		function saveTermLesson() {
			var isValid = true;
			
			var termCd = '<c:out value="${vo.termCd}" />';
			var saveList = [];
			
			$.each($("#lessonTermList > [data-lsn-odr]"), function() {
				var lsnOdr = $(this).data("lsnOdr");
				var startDt = ($("#startDt" + lsnOdr).val() || "").replaceAll(".", "");
				var endDt = ($("#endDt" + lsnOdr).val() || "").replaceAll(".", "");
				var ltDetmFrDt = ($("#ltDetmFrDt" + lsnOdr).val() || "").replaceAll(".", "");
				var ltDetmToDt = ($("#ltDetmToDt" + lsnOdr).val() || "").replaceAll(".", "");
				
				var msgPrefix = lsnOdr + '<spring:message code="common.week"/>'; // 주차
				
				if(!$.trim(startDt)) {
					var msg = msgPrefix + '';
					alert('<spring:message code="common.alert.input.eval_start_date" arguments="' + msg + '" />'); // [{0}] 시작일을 입력하세요.
					$("#startDt" + lsnOdr).focus();
					isValid = false;
					return false;
				}
				
				if(!$.trim(endDt)) {
					var msg = msgPrefix + '';
					alert('<spring:message code="common.alert.input.eval_end_date" arguments="' + msg + '" />'); // [{0}] 종료일을 입력하세요.
					$("#endDt" + lsnOdr).focus();
					isValid = false;
					return false;
				}
				
				if(($.trim(ltDetmFrDt) || $.trim(ltDetmToDt)) && (!$.trim(ltDetmFrDt) || !$.trim(ltDetmToDt))) {
					if(!$.trim(ltDetmFrDt)) {
						var msg = msgPrefix + ' <spring:message code="lesson.label.lt.dttm"/>'; // 출석인정 기간
						alert('<spring:message code="common.alert.input.eval_start_date" arguments="' + msg + '" />'); // [{0}] 시작일을 입력하세요.
						$("#ltDetmFrDt" + lsnOdr).focus();
					} else if(!$.trim(ltDetmToDt)) {
						var msg = msgPrefix + ' <spring:message code="lesson.label.lt.dttm"/>'; // 출석인정 기간
						alert('<spring:message code="common.alert.input.eval_end_date" arguments="' + msg + '" />'); // [{0}] 종료일을 입력하세요.
						$("#ltDetmToDt" + lsnOdr).focus();
					}
					
					isValid = false;
					return false;
				}
				
				saveList.push({
					  termCd: termCd
					, lsnOdr: lsnOdr
					, startDt: startDt
					, endDt: endDt
					, ltDetmFrDt: ltDetmFrDt ? ltDetmFrDt : null
					, ltDetmToDt: ltDetmToDt ? ltDetmToDt : null
				});
			});
			
			if(!isValid) return;
			
			if(saveList.length == 0) {
				alert("주차를 추가하세요.");
				return;
			}
			
			var url = "/crs/termMgr/saveTermLesson.do"
			var data = JSON.stringify(saveList);
			
			$.ajax({
				url: url,
				type: "POST",
				contentType: "application/json",
				data: data,
				dataType: "json",
				beforeSend : function() {
					showLoading();
				},
				success: function(data) {
					if(data.result === 1) {
						alert('<spring:message code="common.result.success" />'); // 성공적으로 작업을 완료하였습니다.
				
						// 학기 목록 조회
						listTerm();
					} else {
						alert(data.message);
					}
				},
				error: function(xhr, status, error) {
					alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
				},
				complete: function() {
					hideLoading();
				},
			});
		}
		
		// 리스트 날짜 세팅
		function setTermListValue() {
			$.each($("#lessonTermList > [data-lsn-odr]"), function() {
				var lsnOdr = $(this).data("lsnOdr");
				
				TERM_LESSON_LIST[lsnOdr - 1].startDt = ($("#startDt" + lsnOdr).val() || "").replaceAll(".", "");
				TERM_LESSON_LIST[lsnOdr - 1].endDt = ($("#endDt" + lsnOdr).val() || "").replaceAll(".", "");
				
				TERM_LESSON_LIST[lsnOdr - 1].ltDetmFrDt = ($("#ltDetmFrDt" + lsnOdr).val() || "").replaceAll(".", "");
				TERM_LESSON_LIST[lsnOdr - 1].ltDetmToDt = ($("#ltDetmToDt" + lsnOdr).val() || "").replaceAll(".", "");
			});
		}
		
		// 달력 생성
		function createCalendar(calObj, startCalObj, endCalObj, startOrEndFlag) {
			var startCal;
			var endCal;
			if(startOrEndFlag == 'START') {
				endCal = $(endCalObj);
			} else if (startOrEndFlag == 'END') {
				startCal = $(startCalObj);
				endCal = $(endCalObj);
			}

			$(calObj).calendar({
				type: 'date',
				startCalendar: startCal,
				endCalendar: endCal,
				formatter: {
					date: function(date, settings) {
						if (!date) return '';
						
						var day  = (date.getDate()) + '';
						var month = settings.text.monthsShort[date.getMonth()];
						if(month.length < 2) {
							month = '0' + month;
						}
						if(day.length < 2) {
							day = '0' + day;
						}
						var year = date.getFullYear();
						
						return year + '.' + month + '.' + day;
					}
				},
				onChange: function (date, text, mode) {
					// 리스트 날짜 세팅
					setTimeout(function() {
						setTermListValue();
					}, 0);
				}
			});
		}
		
		// 이전
		function previous() {
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "moveForm");
			form.attr("action", "/crs/termMgr/Form/crsTermInfoWrite.do");
			form.append($('<input/>', {type: 'hidden', name: "termCd", value: '<c:out value="${vo.termCd}" />'}));
			form.appendTo("body");
			form.submit();
		}
	</script>
</head>
<body>
	<div id="wrap" class="pusher">
	    <!-- header -->
	    <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
	    <!-- //header -->
	    <!-- lnb -->
	    <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
	    <!-- //lnb -->
	    <div id="container">
			<div class="content">
				<div id="info-item-box">
			    	<h2 class="page-title"><spring:message code="crs.label.semester.week.setting"/></h2> <!-- 학기 주차 설정 -->
			       	<div class="button-area">
			        	<a href="javascript:previous();" class="btn"><spring:message code="common.label.previous"/></a> <!-- 이전 -->
			           	<a href="javascript:saveTermLesson();" class="btn btn-primary"><spring:message code="button.add"/></a> <!-- 저장 -->
			           	<a href="/crs/termMgr/Form/crsTermForm.do" class="btn btn-negative"><spring:message code="button.list"/></a> <!-- 목록 -->
			       	</div>
				</div>
				<div class="ui divider mt0"></div>
			   	<div class="ui form">
			    	<ol class="cd-multi-steps text-bottom count">
			        	<li><a onclick="javascript:previous();"><span><spring:message code="crs.label.register.course.info"/></span></a></li> <!-- 학기 정보 등록 -->
			          	<li class="current"><span><spring:message code="crs.label.semester.week.setting"/></span></li> <!-- 학기 주차 설정 -->
			      	</ol>
					<div class="ui stackable two column grid stretched row">
						<div class="column">
							<div class="ui top attached message">
								<div class="header"><spring:message code='crs.label.semester.week.setting'/></div> <!-- 학기 주차 설정 -->
							</div>
							<div class="ui bottom attached segment">
								<div id="lessonTermList"></div>
								<div class="ui divider"></div>
								<button type="button" class="fluid ui basic black button" onclick="addRow();"><spring:message code='common.label.add.week'/></button> <!-- 주차 추가 -->
							</div>
						</div>
						<div class="column">
							<div class="ui top attached message">
								<div class="header"><spring:message code='lesson.label.lt.dttm'/></div> <!-- 출석인정 기간 -->
							</div>
							<div class="ui bottom attached segment">
								<div id="lessonTermList2"></div>
							</div>
						</div>
					</div>
				</div>
				<!-- //ui form -->
			</div>
			<!-- //본문 content 부분 -->
	    </div>
	    <!-- footer 영역 부분 -->
	   	<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
	</div>
</body>
</html>