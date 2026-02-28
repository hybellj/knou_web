<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

<script type="text/javascript">
	$(document).ready(function () {
		if(${not empty vo.insRefCd && vo.insSubmitYn eq 'Y'}) {
			insInfoView();
		}
	});
	
	// 기타(퀴즈) 폼
	function insInfoView() {
		var url  = "/exam/selectExamInsInfo.do";
		var data = {
			"insRefCd" : "${vo.insRefCd}",
			"crsCreCd" : "${vo.crsCreCd}",
			"stdNo"	   : "${vo.stdNo}"
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnVO = data.returnVO;
				var html = "";
				
				if(returnVO != null) {
					html += "<li>";
					html += "	<dl>";
					html += "		<dt>["+returnVO.typeNm+"] "+returnVO.title+"</dt>";
					html += "	</dl>";
					html += "</li>";
					html += "<li>";
					html += "	<dl>";
					html += "		<dt><spring:message code='exam.label.cts' /></dt>";/* 내용 */
					html += "		<dd><pre>"+returnVO.cts+"</pre></dd>";
					html += "	</dl>";
					html += "</li>";
					html += "<li>";
					html += "	<dl>";
					html += "		<dt><spring:message code='exam.label.period' /></dt>";/* 기간 */
					html += "		<dd>"+dateFormat("date", returnVO.startDttm)+" ~ "+dateFormat("date", returnVO.endDttm)+"</dd>";
					html += "		<dt><spring:message code='exam.label.qstn.random' /></dt>";/* 문제 섞기 */
					html += "		<dd>"+returnVO.qstnSetTypeNm+"</dd>";
					html += "	</dl>";
					html += "</li>";
					html += "<li>";
					html += "	<dl>";
					html += "		<dt><spring:message code='exam.label.quiz' /><spring:message code='exam.label.time' /></dt>";/* 퀴즈 *//* 시간 */
					html += "		<dd>"+returnVO.examStareTm+"<spring:message code='exam.label.min.time' /></dd>";/* 분 */
					html += "		<dt><spring:message code='exam.label.empl.random' /></dt>";/* 보기 섞기 */
					html += "		<dd>"+returnVO.emplRandomNm+"</dd>";
					html += "	</dl>";
					html += "</li>";
					html += "<li>";
					html += "	<dl>";
					html += "		<dt><spring:message code='exam.label.file' /></dt>";/* 첨부파일 */
					html += "		<dd>";
					returnVO.fileList.forEach(function(v, i) {
					html += "			<button class='ui icon small button' id='file_"+v.fileSn+"' title='파일다운로드' onclick='fileDown(\""+v.fileSn+"\", \""+v.repoCd+"\")'><i class='ion-android-download'></i> </button>";
					});
					html += "		</dd>";
					html += "		<dt><spring:message code='exam.label.target.absent' /></dt>";/* 대상/결시원 */
					html += "		<dd>"+returnVO.totalCnt+"<spring:message code='exam.label.nm' /></dd>";/* 명 */
					html += "	</dl>";
					html += "</li>";
					html += "<li>";
					html += "	<dl>";
					var scoreStr = "<spring:message code='exam.label.no.stare' />";/* 미응시 */
					if(returnVO.joinYn == "Y" && returnVO.scoreOpenYn != "Y") scoreStr = "<spring:message code='exam.label.complete.stare' />";/* 응시완료 */
					if(returnVO.joinYn == "Y" && returnVO.scoreOpenYn == "Y") scoreStr = returnVO.score + "<spring:message code='exam.label.score.point' />";/* 점 */
					html += "		<dt><spring:message code='exam.label.eval.stare.status' /></dt>";/* 응시/평가현황 */
					html += "		<dd>";
					html += "			"+scoreStr;
					if(returnVO.joinYn == "Y") {
					html += "			<a href='javascript:quizPop(\"quizAnswer\", \""+returnVO.status+"\", \""+returnVO.gradeViewYn+"\")' class='ui basic small button fr'><spring:message code='exam.button.review.answer' /></a>";/* 제출답안 */
					} else {
						if(PROFESSOR_VIRTUAL_LOGIN_YN != "Y") {
							html += "	<a href='javascript:quizPop(\"joinInfo\", \""+returnVO.status+"\", \""+returnVO.gradeViewYn+"\")' class='ui basic small button fr'><spring:message code='exam.label.quiz' /><spring:message code='exam.button.stare.start' /></a>";/* 퀴즈 *//* 응시 */
						}
					}
					html += "		</dd>";
					html += "		<dt></dt>";
					html += "		<dd></dd>";
					html += "	</dl>";
					html += "</li>";
				}
				
				$("#examInfoUl").append(html);
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		});
	}
	
	// 퀴즈 팝업
	function quizPop(type, status, gradeViewYn) {
		if(type == "quizAnswer" && status != "완료") {
			alert("<spring:message code='exam.alert.already.quiz.answer.pop' />");/* 퀴즈기간 종료 후 확인 가능합니다. */
			return;
		} else if(type == "quizAnswer" && gradeViewYn != "Y") {
			alert("<spring:message code='exam.alert.grade.view.n' />");/* 시험지공개 전입니다. */
			return;
		}
		var urlMap = {
			"joinInfo"   : "/quizJoinAlarmPop.do",		// 퀴즈 응시
			"quizAnswer" : "/quiz/quizSubmitAnswerPop.do"	// 제출답안
		};
		var kvArr = [];
		kvArr.push({'key' : 'examCd', 	'val' : "${vo.insRefCd}"});
		kvArr.push({'key' : 'stdNo', 	'val' : "${vo.stdNo}"});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
		kvArr.push({'key' : 'goUrl',    'val' : "tempForm"});
		
		submitForm(urlMap[type], "examPopIfm", type, kvArr);
	}
	
	// 목록
	function viewExamList() {
		var kvArr = [];
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
		kvArr.push({'key' : 'examType', 'val' : "${examType}"});
		
		submitForm("/exam/Form/stuExamList.do", "", "", kvArr);
	}
	
	// 시험 응시
	function examStare() {
		var date = new Date();
		var nowDate = date.getFullYear() + "" + pad((date.getMonth()+1),2) + "" + pad(date.getDate(),2);
		var startDate = "${fn:substring(vo.examStartDttm,0,8)}";
		if("${vo.examStareTypeCd}" == "A") {
			var type = "${vo.examStareTypeCd}";
			var siteCd = type == "A" ? "0003" : type == "F" ? "0004" : "0001";
			var url  = "/exam/examStareEncrypto.do";
			var data = {
				"siteCd" : siteCd,
				"examCd" : "${vo.examCd}"
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnVO = data.returnVO;
					window.open(returnVO.goUrl);
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
			});
		} else {
			if(nowDate >= startDate) {
				// 시험 서약서 제출 여부 확인
				var url = "/exam/viewOath.do";
				var data = {
					"crsCreCd" : "${vo.crsCreCd}"
				};
				
				ajaxCall(url, data, function(data) {
					if(data.result > 0) {
						var returnVO = data.returnVO;
						// 서약서 미제출시 서약서 팝업
						if(returnVO == null) {
							var kvArr = [];
							kvArr.push({'key' : 'examCd', 	'val' : "${vo.examCd}"});
							kvArr.push({'key' : 'stdNo', 	'val' : "${vo.stdNo}"});
							kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
							
							submitForm("/exam/examOathViewPop.do", "examPopIfm", "examOath", kvArr);
						// 응시 EMS URL 가져오기
						} else {
							var type = "${vo.examStareTypeCd}";
							var siteCd = type == "A" ? "0003" : type == "F" ? "0004" : "0001";
							var url  = "/exam/examStareEncrypto.do";
							var data = {
								"siteCd" : siteCd,
								"examCd" : "${vo.examCd}"
							};
							
							ajaxCall(url, data, function(data) {
								if(data.result > 0) {
									var returnVO = data.returnVO;
									window.open(returnVO.goUrl);
					        	} else {
					        		alert(data.message);
					        	}
							}, function(xhr, status, error) {
								alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
							});
						}
		        	} else {
		        		alert(data.message);
		        	}
				}, function(xhr, status, error) {
					alert("<spring:message code='exam.error.info' />");/* 정보 조회 중 에러가 발생하였습니다. */
				});
			} else {
				alert("<spring:message code='exam.alert.exam.stare.day' />");/* 시험 당일에만 응시가능합니다. */
			}
		}
	}
	
	// 서약서 제출 팝업
	function submitOathPop(examCd, examStareTypeCd) {
		var calendarCtgr = examStareTypeCd == "M" ? "00190812" : "00190813";
		var url = "/jobSchHome/viewSysJobSch.do";
		var data = {
			"crsCreCd"     : "${vo.crsCreCd}",
			"calendarCtgr" : calendarCtgr,
			"termCd"	   : "${termVO.termCd}"
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnVO = data.returnVO;
				if(returnVO != null) {
					var startDt  = returnVO.excSchStartDt != null ? returnVO.excSchStartDt : returnVO.schStartDt;
					var endDt    = returnVO.excSchEndDt != null ? returnVO.excSchEndDt : returnVO.schEndDt;
					if(startDt < "${today}" && "${today}" < endDt) {
						var url = "/exam/viewOath.do";
						var data = {
							"crsCreCd" : "${vo.crsCreCd}"
						};
						
						ajaxCall(url, data, function(data) {
							if(data.result > 0) {
								var returnVO = data.returnVO;
								if(returnVO == null) {
									var kvArr = [];
									kvArr.push({'key' : 'examCd', 	'val' : examCd});
									kvArr.push({'key' : 'stdNo', 	'val' : "${vo.stdNo}"});
									kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
									
									submitForm("/exam/examOathViewPop.do", "examPopIfm", "examOath", kvArr);
								} else {
									alert("<spring:message code='exam.alert.already.submit.oath' />");/* 이미 서약서를 제출하였습니다. */
								}
				        	} else {
				        		alert(data.message);
				        	}
						}, function(xhr, status, error) {
							alert("<spring:message code='exam.error.info' />");/* 정보 조회 중 에러가 발생하였습니다. */
						});
					} else {
						var start = dateFormat("date", startDt);
						var end   = dateFormat("date", endDt);
						alert("<spring:message code='exam.alert.oath.submit.dttm' arguments='"+start+","+end+"' />");/* 시험서약서 제출 기간은 {0} ~ {1}입니다. */
					}
				} else {
					alert("<spring:message code='sys.alert.already.job.sch' />");/* 등록된 일정이 없습니다. */
				}
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.info' />");/* 정보 조회 중 에러가 발생하였습니다. */
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
        				<c:set var="examTypeStr"><spring:message code="exam.label.mid.end.exam" /><!-- 중간/기말 --></c:set>
        				<c:if test="${examType eq 'ADMISSION' }"><c:set var="examTypeStr"><spring:message code="exam.label.always.exam" /><!-- 수시평가 --></c:set></c:if>
        				<script>
							$(document).ready(function () {
								// set location
								setLocationBar('<spring:message code="exam.label.exam" />', '${examTypeStr}');
							});
						</script>
		                <div id="info-item-box">
		                	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                ${examTypeStr }
                            </h2>
                            <div class="button-area">
				                <a href="javascript:viewExamList()" class="ui blue button"><spring:message code="exam.button.list" /></a><!-- 목록 -->
                            </div>
		                </div>
	        			<div class="row">
		                	<div class="col">
		                		<div class="ui segment">
			                		<div class="option-content header2">
			                			<spring:message code="exam.common.yes" var="yes" /><!-- 예 -->
			                			<spring:message code="exam.common.no" var="no" /><!-- 아니오 -->
			                			<fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss" value="${vo.examStartDttm }" />
										<fmt:formatDate var="examStartDttm" pattern="yyyy.MM.dd HH:mm (E요일)" value="${startDateFmt }" />
			                			<h3 class="sec_head wmax">[${vo.examTypeNm }] ${vo.examTitle }</h3>
			                			<small><spring:message code="exam.label.exam.dttm" /><!-- 시험일시 --> : ${vo.examTypeCd eq 'EXAM' ? examStartDttm : '-' }</small> |
			                			<small><spring:message code="exam.label.exam.time" /><!-- 시험시간 --> : ${vo.examTypeCd eq 'EXAM' ? vo.examStareTm+='Min' : '-' }</small> |
			                			<small><spring:message code="exam.label.score.open.y" /><!-- 성적공개 --> : ${vo.examTypeCd eq 'EXAM' ? vo.scoreOpenYn eq 'Y' ? yes : no : '-' }</small> |
			                			<small><spring:message code="exam.label.paper.open" /><!-- 시험지 공개 --> : ${vo.examTypeCd eq 'EXAM' ? vo.gradeViewYn eq 'Y' ? yes : no : '-' }</small>
			                			<c:if test="${(vo.examStareTypeCd eq 'M' || vo.examStareTypeCd eq 'L') && vo.examTypeCd eq 'EXAM' }">
				                			<div class="mla">
				                				<c:if test="${PROFESSOR_VIRTUAL_LOGIN_YN ne 'Y'}">
				                				<a href="javascript:submitOathPop()" class="ui basic small button"><spring:message code="exam.label.oath" /><!-- 서약서 --></a>
				                				</c:if>
				                				<a href="javascript:etsExamTaste()" class="ui basic small button"><spring:message code="exam.label.exam.taste" /><!-- 시험 맛보기 --></a>
				                			</div>
			                			</c:if>
			                		</div>
			                		<ul class="tbl" id="examInfoUl">
			                			<li>
			                				<dl>
			                					<dt><spring:message code="exam.label.exam.stare.type" /><!-- 시험구분 --></dt>
			                					<dd>${vo.examStareTypeNm }</dd>
			                					<dt><spring:message code="exam.label.exam.type" /><!-- 시험유형 --></dt>
			                					<dd>${vo.examTypeNm }</dd>
			                				</dl>
			                			</li>
			                			<li>
			                				<dl>
			                					<dt><spring:message code="exam.label.stare.status" /><!-- 응시현황 --></dt>
			                					<dd>
			                						<c:choose>
			                							<c:when test="${vo.examTypeCd eq 'EXAM' }">
			                								<c:choose>
					                							<c:when test="${today < vo.examStartDttm }">
					                								<spring:message code="exam.label.prev.stare" /><!-- 응시전 -->
					                							</c:when>
					                							<c:when test="${today >= vo.examStartDttm && today <= endDttm }">
					                								<spring:message code="exam.label.subject.participate" /><!-- 응시대상 -->
					                							</c:when>
					                							<c:when test="${today > endDttm && vo.stuEvalYn eq 'N' }">
					                								<spring:message code="exam.label.end" /><!-- 종료 -->
					                							</c:when>
					                							<c:otherwise>
					                								<c:choose>
					                									<c:when test="${vo.stareStatusCd eq 'C' }">
					                										<c:choose>
					                											<c:when test="${vo.scoreOpenYn eq 'Y' }">
					                												${vo.totGetScore }<spring:message code="exam.label.score.point" /><!-- 점 -->
					                											</c:when>
					                											<c:otherwise>
					                												<spring:message code="exam.label.complete.stare" /><!-- 응시완료 -->
					                											</c:otherwise>
					                										</c:choose>
					                									</c:when>
					                									<c:otherwise>
					                										<spring:message code="exam.label.no.stare" /><!-- 미응시 -->
					                									</c:otherwise>
					                								</c:choose>
					                							</c:otherwise>
					                						</c:choose>
					                						<c:if test="${PROFESSOR_VIRTUAL_LOGIN_YN ne 'Y'}">
			                								<a href="javascript:examStare()" class="ui basic small button fr"><spring:message code="exam.button.stare" /><!-- 응시하기 --></a>
			                								</c:if>
			                							</c:when>
			                							<c:otherwise>
			                								-
			                							</c:otherwise>
			                						</c:choose>
			                					</dd>
			                					<dt></dt>
			                					<dd></dd>
			                				</dl>
			                			</li>
			                		</ul>
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