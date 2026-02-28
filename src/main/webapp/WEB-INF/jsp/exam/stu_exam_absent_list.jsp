<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/main_default.css?v=3" />
<script type="text/javascript">
	$(document).ready(function() {
		listExamAbsent();
	});
	
	// 결시원 목록 조회
	function listExamAbsent() {
		var url  = "/exam/listAllStuAbsentExam.do";
		var data = {
			  creYear     : $("#creYear").val()
			, creTerm     : $("#creTerm").val()
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
        		var html = '';
        		returnList.forEach(function(v, i) {
        			var examStareTypeNm = "";
        			var bgColor = "";
        			
        			if(v.examStareTypeCd == "M") {
        				examStareTypeNm = '<span class="fcGreen"><spring:message code="exam.label.mid.exam" /></span>'; // 중간고사
        				bgColor = "bcLgrey9";
        			} else if(v.examStareTypeCd == "L") {
        				examStareTypeNm = '<span class="fcBrown"><spring:message code="exam.label.end.exam" /></span>'; // 기말고사
        			}
        			
        			var examStartDttmFmt = (v.examStartDttm || "").length == 14 ? v.examStartDttm.substring(0, 4) + '.' + v.examStartDttm.substring(4, 6) + '.' + v.examStartDttm.substring(6, 8) + ' ' + v.examStartDttm.substring(8, 10) + ':' + v.examStartDttm.substring(10, 12) : v.examStartDttm;
        			
        			html += '<tr class="' + bgColor + '">';
        			html += '	<td>' + (i + 1) + '</td>';
        			html += '	<td>' + (v.deptNm || '-') + '</td>';
        			html += '	<td>' + v.crsCd + '</td>';
        			html += '	<td>' + v.declsNo + '</td>';
        			html += '	<td>' + v.crsCreNm + '</td>';
        			html += '	<td>' + v.tchNm + '</td>';
        			html += '	<td>';
        			if(v.apprStat == null) {
        				html += '	<span class="fcGrey"><spring:message code="exam.label.applicate.n" /></span>'; // 신청 전
        			} else {
        				html += '	<a href="javascript:examAbsentApprView(\'' + v.examAbsentCd + '\')">';
            			if(v.apprStat == "COMPANION") {
            				html += '	<span class="fcBlue"><spring:message code="exam.label.companion" /></span>'; // 반려
            			} else if(v.apprStat == "APPROVE") {
            				html += '	<span class="fcBlue"><spring:message code="exam.label.approve" /></span>'; // 승인
            			} else if(v.apprStat == "APPLICATE") {
            				html += '	<span class="fcBlue"><spring:message code="exam.label.applicate" /></span>'; // 신청
            			} else if(v.apprStat == "RAPPLICATE") {
            				html += '	<span class="fcBlue"><spring:message code="exam.label.rapplicate" /></span>'; // 재신청
            			}
            			html += '	</a>';
        			}
        			html += '	</td>';
        			html += '	<td>' + examStartDttmFmt + '</td>';
        			html += '	<td>' + examStareTypeNm + '</td>';
        			html += '	<td>';
        			if(v.apprStat == null) {
        				html += '	<a href="javascript:examAbsentApplicate(\'' + v.crsCreCd + '\', \'' + v.examCd + '\', \'' + v.stdNo + '\', \'' + v.examStareTypeCd + '\')" class="ui blue button w70"><spring:message code="exam.label.apply" /></a>'; // 신청하기
        			} else if(v.apprStat == "COMPANION") {
        				html += '	<a href="javascript:examAbsentApplicate(\'' + v.crsCreCd + '\', \'' + v.examCd + '\', \'' + v.stdNo + '\', \'' + v.examStareTypeCd + '\')" class="ui blue button w70"><spring:message code="exam.label.rapplicate" /></a>'; // 재신청
        			} else {
        				html += '	<a href="javascript:void(0)" class="ui blue button w70 disabled" style="visibility:hidden"></a>';
        			}
        			html += '	</td>';
        			html += '</tr>';
        		});
        		
        		$("#totalCnt").text(returnList.length);
        		$("#examList").empty().html(html);
        		$("#examTable").footable();
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
		});
	}
	
	// 결시원 신청하기
	function examAbsentApplicate(crsCreCd, examCd, stdNo, examStareTypeCd) {
		var calendarCtgr;
		
		if(examStareTypeCd == "M") {
			calendarCtgr = "00190902"; // 결시원신청(학생) 중간
		} else if(examStareTypeCd == "L") {
			calendarCtgr = "00190903"; // 결시원신청(학생) 기말
		}
		
		var url = "/jobSchHome/viewSysJobSch.do";
		var data = {
			"crsCreCd"     : crsCreCd,
			"calendarCtgr" : calendarCtgr,
			"haksaYear"	   : $("#creYear").val(),
			"haksaTerm"    : $("#creTerm").val()
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnVO = data.returnVO;
				if(returnVO != null) {
					var jobSchPeriodYn = returnVO.jobSchPeriodYn;
					
					if(jobSchPeriodYn == "Y") {
						var url = "/exam/examStareByStdNo.do";
						var data = {
							"examCd" : examCd,
							"stdNo"  : stdNo
						};
						
						ajaxCall(url, data, function(data) {
							if(data.result > 0) {
								if(data.returnVO.examStareYn == "Y") {
									var examStareTypeNm = data.returnVO.examStareTypeCd == "M" ? "<spring:message code='exam.label.mid' />"/* 중간 */ : "<spring:message code='exam.label.final' />"/* 기말 */;
									alert(data.returnVO.haksaYear + " / " + data.returnVO.haksaTerm + " / [" + examStareTypeNm+"] <spring:message code='exam.alert.exam.stare.y.not.absent.aplicate' />");/* 실시간 시험을 이미 응시하여서 결시원 신청이 불가합니다. */
								} else {
									var kvArr = [];
									kvArr.push({'key' : 'stdNo', 	'val' : stdNo});
									kvArr.push({'key' : 'examCd', 	'val' : examCd});
									kvArr.push({'key' : 'crsCreCd', 'val' : crsCreCd});
									
									submitForm("/exam/stuExamAbsentApplicatePop.do", "examPopIfm", "absentAppl", kvArr);
								}
				        	} else {
				        		alert(data.message);
				        	}
						}, function(xhr, status, error) {
							alert("<spring:message code='exam.error.info' />");// 정보 조회 중 에러가 발생하였습니다.
						});
					} else {
						alert("<spring:message code='exam.alert.absent.applicate.not.datetime' />");// 결시원 신청은 신청기간 안에만 가능합니다.
					}
				} else {
					alert("<spring:message code='sys.alert.already.job.sch' />");// 등록된 일정이 없습니다.
				}
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.info' />");// 정보 조회 중 에러가 발생하였습니다.
		});
	}
	
	// 결시 내역 팝업
	function examAbsentApprView(examAbsentCd) {
		var kvArr = [];
		kvArr.push({'key' : 'examAbsentCd', 'val' : examAbsentCd});
		
		submitForm("/exam/stuExamAbsentApprViewPop.do", "examPopIfm", "absentView", kvArr);
	}
	
	// 체크박스 이벤트
	function checkUser(obj) {
		if(obj.value == "all") {
			$("input[name=evalChk]").prop("checked", obj.checked);
		} else {
			$("#allChk").prop("checked", $("input[name=evalChk]").length == $("input[name=evalChk]:checked").length);
		}
	}
</script>

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
                				<h2 class="page-title"><spring:message code="exam.label.absent" /> <spring:message code="exam.label.applicate" /><!-- 결시원 --><!-- 신청 --></h2>
                			</div>
                			<%-- <div class="button-area">
                				<a href="javascript:void(0);" class="ui bcPurpleAlpha85 button" onclick="listExamAbsent()"><spring:message code="common.label.search" /><!-- 조회 --></a>
                			</div> --%>
                		</div>
			            <div class="row">
			            	<div class="col">
							    <p class="f110"><spring:message code="exam.label.absent.info.std" /></p><!-- 결시원 신청 및 승인 여부 확인을 합니다 -->
							    <div class="mt20 mb20 tc bcLYellow p10 fcDark1">
							    	<fmt:parseDate var="midSchStartDtFmt" pattern="yyyyMMddHHmmss" value="${midSysJobSchVO.schStartDt }" />
									<fmt:formatDate var="midSchStartDt" pattern="yyyy.MM.dd HH:mm" value="${midSchStartDtFmt }" />
							    	<fmt:parseDate var="midSchEndDtFmt" pattern="yyyyMMddHHmmss" value="${midSysJobSchVO.schEndDt }" />
									<fmt:formatDate var="midSchEndDt" pattern="yyyy.MM.dd HH:mm" value="${midSchEndDtFmt }" />
									
									<fmt:parseDate var="lastSchStartDtFmt" pattern="yyyyMMddHHmmss" value="${lastSysJobSchVO.schStartDt }" />
									<fmt:formatDate var="lastSchStartDt" pattern="yyyy.MM.dd HH:mm" value="${lastSchStartDtFmt }" />
							    	<fmt:parseDate var="lastSchEndDtFmt" pattern="yyyyMMddHHmmss" value="${lastSysJobSchVO.schEndDt }" />
									<fmt:formatDate var="lastSchEndDt" pattern="yyyy.MM.dd HH:mm" value="${lastSchEndDtFmt }" />
									
							    	<b><spring:message code="exam.label.absent" /> <spring:message code="exam.label.applicate" /><spring:message code="exam.label.period" /></b><!-- 결시원 --><!-- 신청 --><!-- 기간 -->
							    	<br />
							    	<span class="fcOrange"><spring:message code="exam.label.mid.exam" /><!-- 중간고사 --> : <c:choose><c:when test="${empty midSysJobSchVO}">-</c:when><c:otherwise>${midSchStartDt} ~ ${midSchEndDt}</c:otherwise></c:choose></span>
							    	<span class="ml5 mr5">|</span>
							    	<span class="fcOrange"><spring:message code="exam.label.end.exam" /><!-- 기말고사 --> : <c:choose><c:when test="${empty lastSysJobSchVO}">-</c:when><c:otherwise>${lastSchStartDt} ~ ${lastSchEndDt}</c:otherwise></c:choose></span>
							    	<br />
							    	<!-- 결시원 승인여부 및 대체평가 등의 후속조치는 <span class="fcBlue">담당과목 교수님의 재량으로 교수님께 문의</span>하여 주시기 바랍니다. -->
							    	<spring:message code="exam.label.exam.absent.period.guide" />
							    </div>
							    <div class="option-content mb5">
								    <h3 class="sec_head inline-block pr20"><spring:message code="exam.label.live.exam.crs.list" /><!-- 실시간시험 과목 목록 --></h3>
								    <span>[ <spring:message code="exam.label.total.cnt" /> : <label id="totalCnt" class="fcBlue">-</label> ]</span><!-- 총 건수 -->
							    </div>
							    <div class="option-content mb10">
							    	<label for="creYear" class="hide"><spring:message code="exam.label.open.year" /></label>
									<select class="ui dropdown" id="creYear" onchange="listExamAbsent()">
										<option value=""><spring:message code="exam.label.open.year" /></option><!-- 개설년도 -->
										<c:forEach var="item" items="${yearList }">
											<option value="${item }" ${item eq termVO.haksaYear ? 'selected' : '' }>${item }</option>
										</c:forEach>
								    </select>
								    <label for="creTerm" class="hide"><spring:message code="exam.label.open.term" /></label>
									<select class="ui dropdown" id="creTerm" onchange="listExamAbsent()">
										<option value=""><spring:message code="exam.label.open.term" /></option><!-- 개설학기 -->
										<c:forEach var="list" items="${termList }">
											<option value="${list.codeCd }" ${list.codeCd eq termVO.haksaTerm ? 'selected' : '' }>${list.codeNm }</option>
										</c:forEach>
								    </select>
							    </div>
								<table class="table type2" data-sorting="true" data-paging="false" data-empty="<spring:message code='exam.common.empty' />" id="examTable"><!-- 등록된 내용이 없습니다. -->
									<caption class="hide"><spring:message code="exam.label.absent" /></caption>
									<thead>
										<tr>
											<th scope="col" data-breakpoints="xs" data-sortable="false" data-type="number" class="num tc"><spring:message code="common.number.no" /></th>
											<th scope="col" data-breakpoints="xs sm md"><spring:message code="exam.label.crs.dept" /></th><!-- 관장학과 -->
											<th scope="col" data-breakpoints="xs"><spring:message code="exam.label.haksu.no" /></th><!-- 학수번호 -->
											<th scope="col"><spring:message code="common.label.decls.no" /></th><!-- 분반 -->
											<th scope="col"><spring:message code="crs.label.crecrs.nm" /></th><!-- 과목명 -->
											<th scope="col" data-breakpoints="xs"><spring:message code="exam.label.tch.nm" /></th><!-- 교수명 -->
											<th scope="col" data-breakpoints="xs"><spring:message code="exam.label.process.status" /></th><!-- 처리상태 -->
											<th scope="col" data-breakpoints="xs"><spring:message code="exam.label.exam.dttm" /></th><!-- 시험일시 -->
											<th scope="col"><spring:message code="exam.label.exam" /><spring:message code="exam.label.stare.type" /></th><!-- 시험 --><!-- 구분 -->
											<th scope="col"><spring:message code="exam.label.applicate" /></th><!-- 신청 -->
										</tr>
									</thead>
									<tbody id="examList">
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