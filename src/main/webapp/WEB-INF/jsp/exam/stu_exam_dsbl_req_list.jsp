<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
	<link rel="stylesheet" type="text/css" href="/webdoc/css/main_default.css?v=3" />
	<script type="text/javascript">
		$(document).ready(function() {
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					listExamDsblReq();
				}
			});
			
			listExamDsblReq();
		});
		
		// 장애인 시험 지원 목록 조회
		function listExamDsblReq() {
			var url  = "/exam/stuExamDsblReqList.do";
			var data = {
				  userId		: "${vo.userId}"
				, creYear		: $("#creYear").val()
				, creTerm		: $("#creTerm").val()
				, searchValue	: $("#searchValue").val()
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
	        		var html = '';
	        		
        			returnList.forEach(function(v, i) {
        				var examAppr = '';
        				var apprColor = '';
        				
        				var appliExamList = [];
        				var examReqList = [];
        				var addTimeList = [];
        				
        				if(v.disablilityExamYn == "Y") {
	        				if(v.midExamYn == "Y") {
	        					appliExamList.push("<spring:message code='exam.label.mid' />"); // 중간
	        					examReqList.push("<spring:message code='exam.label.time.late' />"); //시간연장
	        				} 
	        				
	        				if(v.lastExamYn == "Y") {
	        					appliExamList.push("<spring:message code='exam.label.final' />"); // 기말
	        					examReqList.push("<spring:message code='exam.label.time.late' />"); //시간연장
	        				}
        				}
        				
        				if(v.disablilityExamYn == "Y") {
        					if(v.dsblConfirmDtYn == "Y") {
    							examAppr = '<spring:message code="exam.label.review" />'; // 심사중
    							
    							if(v.midApprStat || v.endApprStat) {
    								examAppr = '<spring:message code="exam.label.approve" /><spring:message code="exam.label.complete" />'; // 승인완료
            						apprColor = 'fcBlue';
    								
    								if(v.midExamYn == "Y") {
    									addTimeList.push(v.dsblConfirmDtYn == "Y" ? "<spring:message code='exam.label.late' />("+v.midAddTime+"<spring:message code='exam.label.stare.min' />)" : "-"); // 연장 분
    								} 
    								
    								if(v.lastExamYn == "Y") {
    									addTimeList.push(v.dsblConfirmDtYn == "Y" ? "<spring:message code='exam.label.late' />("+v.endAddTime+"<spring:message code='exam.label.stare.min' />)" : ""); // 연장 분
    								}
    							}
    						} else if(v.dsblReqDtYn == "Y") {
    							//examAppr = '<spring:message code="exam.label.applicate" />'; // 신청
    							examAppr = '<spring:message code="exam.label.review" />'; // 심사중
    						} else {
    							examAppr = '-';
    						}
        				} else {
        					examAppr = '<spring:message code="exam.label.applicate.n" />'; // 신청 전
        				}
        				
    					html += '<tr>';
    					html += '	<td>' + v.lineNo + '</td>';
    					html += '	<td>' + v.crsCreNm + '</td>';
    					html += '	<td>' + v.declsNo + '</td>';
    					html += '	<td>' + (appliExamList.join("/") || "-") + '</td>';
    					html += '	<td>' + (examReqList.join("/") || "-") + '</td>';
    					html += '	<td>' + (addTimeList.join("/") || "-") + '</td>';
    					html += '	<td class="' + apprColor + ' ">' + examAppr + '</td>';
    					html += '</tr>';
        			});
	        		
	        		//$("#examDsblReqCnt").text(returnList.length);
	        		var dttm = "";
        			if(returnList[0] && returnList[0].regDttm != null) {
        				dttm = dateFormat("date", returnList[0].regDttm);
        				if(returnList[0].disablilityExamYn == "Y") {
        					dttm += "에 신청하셨습니다.";
        				} else {
        					dttm += "에 취소하셨습니다.";
        				}
        				$("#dsblDttm").text(dttm);
        			}
	        		
	        		$("#examDsblReqList").empty().html(html);
	        		$(".table").footable();
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert("<spring:message code='exam.error.list' />"); // 리스트 조회 중 에러가 발생하였습니다.
			}, true);
		}
		
		// 장애인 시험지원 신청
		function examDsblReqApplicate() {
			var msg = '<spring:message code="exam.alert.dsbl.req.applicate.not.datetime" />'; // 시험지원 신청은 신청기간 안에만 가능합니다.
			
			checkJobSch(msg).done(function() {
				var url  = "/exam/stuExamDsblReqApplicate.do";
				var data = {
					"userId" : "${vo.userId}"
				};
				
				ajaxCall(url, data, function(data) {
					if(data.result > 0) {
						alert("<spring:message code='exam.alert.apply' />"); // 신청이 완료되었습니다.
						window.location.reload();
		        	} else {
		        		alert(data.message);
		        	}
				}, function(xhr, status, error) {
					alert("<spring:message code='exam.error.apply' />"); // 신청 중 에러가 발생하였습니다.
				});
			});
		}
		
		// 장애학생 시험지원 취소
		function examDsblReqCancel() {
			var msg = '<spring:message code="exam.alert.dsbl.req.cancel.not.datetime" />'; // 시험지원 취소는 신청기간 안에만 가능합니다.
			
			checkJobSch(msg).done(function() {
				// 장애인 시험지원 신청을 취소하시겠습니까?
				if(!window.confirm("<spring:message code='exam.confirm.exam.dsbl.req.cancel' />")) return;
				
				var url  = "/exam/stuExamDsblReqCancel.do";
				var data = {
					"userId" : "${vo.userId}",
					"disabilityCancelGbn" : "APPROVE"
				};
				
				ajaxCall(url, data, function(data) {
					if(data.result > 0) {
						alert("<spring:message code='exam.alert.cancel' />"); // 취소가 완료되었습니다.
						window.location.reload();
		        	} else {
		        		alert(data.message);
		        	}
				}, function(xhr, status, error) {
					alert("<spring:message code='exam.error.cancel' />"); // 취소 중 에러가 발생하였습니다.
				});
			});
		}
		
		// 업무일정 체크
		function checkJobSch(msg) {
			var deferred = $.Deferred();
			
			var url = "/jobSchHome/viewSysJobSch.do";
			var data = {
				"calendarCtgr" : "00190805", 			// 시험지원요청
				"termCd"	   : "${termVO.termCd}", 	// 현재학기
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnVO = data.returnVO;
					if(returnVO != null) {
						var jobSchPeriodYn = returnVO.jobSchPeriodYn;
						var jobSchExcPeriodYn = returnVO.jobSchExcPeriodYn;
						var schStartDt = returnVO.schStartDt;
						var schEndDt = returnVO.schEndDt;
						
						if(jobSchPeriodYn == "Y" || jobSchExcPeriodYn == "Y") {
							deferred.resolve();
						} else {
							alert(msg);
							deferred.reject();
						}
					} else {
						alert('<spring:message code="sys.alert.already.job.sch" />'); // 등록된 일정이 없습니다.
						deferred.reject();
					}
		    	} else {
		    		alert(data.message);
		    		deferred.reject();
		    	}
			}, function(xhr, status, error) {
				alert("<spring:message code='exam.error.info' />"); // 정보 조회 중 에러가 발생하였습니다.
				deferred.reject();
			});
			
			return deferred.promise();
		}
	</script>
</head>
<body class="<%=SessionInfo.getThemeMode(request)%>">
    <div id="wrap" class="main">
        <%@ include file="/WEB-INF/jsp/common/frontLnb.jsp" %>

		<div id="container">
			<%@ include file="/WEB-INF/jsp/common/frontGnb.jsp" %>
			
	        <!-- 본문 content 부분 -->
	        <div class="content">
	        	<div class="ui form">
	        		<div class="layout2">
	        			<div class="classInfo">
                			<div class="mra">
                				<h2 class="page-title"><spring:message code="exam.label.dsbl.req" /> <spring:message code="exam.label.applicate" /><!-- 장애인 시험지원 --><!-- 신청 --></h2>
                			</div>
                		</div>
			            <div class="row">
			            	<div class="col">
			            		<div class="ui segment">
			            			<p><b>${termVO.termNm } <spring:message code="exam.label.exam.req" /> <spring:message code="exam.label.applicate" /></b><!-- 시험지원 --><!-- 신청 --></p>
			            			<p>
			            				<fmt:parseDate var="startDtFmt" pattern="yyyyMMddHHmmss" value="${sysJobSchVO.schStartDt }" />
										<fmt:formatDate var="schStartDt" pattern="yyyy.MM.dd HH:mm" value="${startDtFmt }" />
										<fmt:parseDate var="endDtFmt" pattern="yyyyMMddHHmmss" value="${sysJobSchVO.schEndDt }" />
										<fmt:formatDate var="schEndDt" pattern="yyyy.MM.dd HH:mm" value="${endDtFmt }" />
			            				* <spring:message code="exam.label.dsbl.req.applicate.dt" /><!-- 신청기간 --> : ${schStartDt } ~ ${schEndDt }
			            			</p>
			            			<p>
			            				<fmt:parseDate var="startDtFmt2" pattern="yyyyMMddHHmmss" value="${sysJobSchVO2.schStartDt }" />
										<fmt:formatDate var="schStartDt2" pattern="yyyy.MM.dd HH:mm" value="${startDtFmt2 }" />
										<fmt:parseDate var="endDtFmt2" pattern="yyyyMMddHHmmss" value="${sysJobSchVO2.schEndDt }" />
										<fmt:formatDate var="schEndDt2" pattern="yyyy.MM.dd HH:mm" value="${endDtFmt2 }" />
			            				* <spring:message code="exam.label.dsbl.req.check.dt" /><!-- 확인기간 --> : ${schStartDt2 } ~ ${schEndDt2 }
			            			</p>
			            			<br />
			            			<p><b><spring:message code="exam.label.exam.dsbl.req.info.msg1" /><!-- * 우리 대학 장애학생은 시험지원 신청을 통해 실시간 시험에 대하여 시험 시간을 연장받을 수 있습니다. 신청을 원할 경우 우측 신청 버튼을 눌러주세요. --></b></p>
				            		<p><spring:message code="exam.label.exam.dsbl.req.info.msg2" /><!-- * 신청 후에는 별도 취소하기 전까지 매 학기 실시간 시험 시간 연장이 지원됩니다. --></p>
				            		<p><spring:message code="exam.label.exam.dsbl.req.info.msg3" /><!-- * 신청 결과는 확인 기간 중에는 '심사중'으로 표기되며 확인 기간에 연장된 시간이 표기됩니다. --></p>
				            		<p><spring:message code="exam.label.exam.dsbl.req.info.msg4" /><!-- * 신청을 취소하고자 하는 경우 취소 버튼을 눌러주세요. 취소 시 실시간 시험 시간 연장을 지원 받을 수 없습니다. --></p>
				            		<p><spring:message code="exam.label.exam.dsbl.req.info.msg5" /><!-- * 장애등급 및 유형에 변동이 있을 경우 반드시 소속 학과를 통해 학교에 알리고 증빙 자료를 제출하시기 바랍니다. --></p>
			            		</div>
							    <div class="option-content pl10 mt30">
								    <h3 class="sec_head inline-block pr20"><spring:message code="exam.label.real.time.exam.list" /></h3><!-- 실시간 시험 목록 -->
								    <%-- <span>[ <spring:message code="exam.label.total.cnt" /> : <label id="examDsblReqCnt" class="fcBlue"></label> ]</span><!-- 총 건수 --> --%>
							    </div>
							    <div class="option-content p10">
									<select class="ui dropdown" id="creYear" onchange="listExamDsblReq()">
										<option value=""><spring:message code="exam.label.open.year" /></option><!-- 개설년도 -->
										<c:forEach var="item" items="${yearList }">
											<option value="${item }" ${item eq termVO.haksaYear ? 'selected' : '' }>${item }</option>
										</c:forEach>
								    </select>
									<select class="ui dropdown" id="creTerm" onchange="listExamDsblReq()">
										<option value=""><spring:message code="exam.label.open.term" /></option><!-- 개설학기 -->
										<c:forEach var="list" items="${termList }">
											<option value="${list.codeCd }" ${list.codeCd eq termVO.haksaTerm ? 'selected' : '' }>${list.codeNm }</option>
										</c:forEach>
								    </select>
								    <div class="ui action input search-box">
								        <input type="text" placeholder="<spring:message code='crs.label.crecrs.nm' /> <spring:message code='exam.label.input' />" id="searchValue" class="w250"><!-- 과목명 --><!-- 입력 -->
								        <button class="ui icon button" onclick="listExamDsblReq()"><i class="search icon"></i></button>
								    </div>
								    <div class="mla">
								    	<div class="option-content">
										    <span id="dsblDttm"></span>
									    	<button class="ui blue button" ${uuivo.disablilityExamYn eq 'N' ? "style='display:block'" : "style='display:none'"} onclick="examDsblReqApplicate()"><spring:message code="exam.label.dsbl.req.applicate" /></button><!-- 장애학생 시험지원 신청 -->
									    	<button class="ui blue button" ${uuivo.disablilityExamYn eq 'Y' ? "style='display:block'" : "style='display:none'"} onclick="examDsblReqCancel()"><spring:message code="exam.label.dsbl.req.cancel" /></button><!-- 장애학생 시험지원 취소 -->
								    	</div>
								    </div>
								</div>
								<table class="table type2 mt10" data-sorting="true" data-paging="false" data-empty="<spring:message code='exam.common.empty' />"><!-- 등록된 내용이 없습니다. -->
									<thead>
										<tr>
											<th scope="col"><spring:message code="main.common.number.no" /></th><!-- NO. -->
											<th scope="col"><spring:message code="crs.label.crecrs.nm" /></th><!-- 과목명 -->
											<th scope="col" data-breakpoints="xs sm"><spring:message code="crs.label.decls" /></th><!-- 분반 -->
											<th scope="col" data-breakpoints="xs sm md"><spring:message code="exam.label.applicate.term" /></th><!-- 신청학기 -->
											<th scope="col" data-breakpoints="xs sm md"><spring:message code="exam.label.std.request" /></th><!-- 학생요청사항 -->
											<th scope="col" data-breakpoints="xs sm"><spring:message code="exam.label.request.result" /></th><!-- 요청결과 -->
											<th scope="col"><spring:message code="exam.label.approve.status" /></th><!-- 승인상태 -->
										</tr>
									</thead>
									<tbody id="examDsblReqList">
									</tbody>
								</table>
			            	</div>
			            </div>
	        		</div>
	        	</div>
	        </div>
	        <!-- //본문 content 부분 -->
	        <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
		</div>
    </div>
</body>
</html>