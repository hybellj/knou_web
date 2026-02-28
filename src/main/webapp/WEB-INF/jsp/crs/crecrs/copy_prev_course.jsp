<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

<script type="text/javascript">
	$(document).ready(function() {
		changeCrsCre();
	});
	
	// 년도, 학기변경
	function changeCrsCre() {
		var crsCreCd = '<c:out value="${creCrsVO.crsCreCd}" />';
		var crsCd = '<c:out value="${creCrsVO.crsCd}" />';
		
		var url  = "/crs/creCrsHome/listRepUserCrsCreByTerm.do";
		var data = {
			  creYear 		: $("#creYear").val()
			, creTerm 		: $("#creTerm").val()
			, repUserId		: '<c:out value="${creCrsVO.repUserId}" />'
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var returnList = data.returnList || [];
        		
        		// 동일학수번호 과목 조회
        		/*
        		returnList = returnList.filter(function(v) {
        			return v.crsCreCd != crsCreCd && v.crsCd == crsCd;
        		});
        		*/
        		
        		returnList.sort(function(a, b) {
					if(a.crsCreNm < b.crsCreNm) return -1;
					if(a.crsCreNm > b.crsCreNm) return 1;
					if(a.crsCreNm == b.crsCreNm) {
						if(a.declsNo < b.declsNo) return -1;
						if(a.declsNo > b.declsNo) return 1;
					}
					return 0;
				});
        		
        		var html = "";
       			returnList.forEach(function(v, i) {
     				html += '<option value="' + v.crsCreCd + '" ' + (returnList.length == 1 ? "selected" : "") + ' >' + v.crsCreNm + ' (' + v.declsNo + '<spring:message code="exam.label.decls" />)</option>'; // 반	
       			});
        		
        		$("#copyCrsCreCd").empty().html(html);
        		
        		if(returnList.length == 1) {
        			$("#copyCrsCreCd").dropdown("set text", $("#copyCrsCreCd > option:selected")[0].innerText);
        		} else {
        			$("#copyCrsCreCd").dropdown("clear");
        		}
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.list' />"); // 리스트 조회 중 에러가 발생하였습니다.
		});
	}
	
	// 이전과목 가져오기
	function getPrevInfo(gubun) {
		var copyCrsCreCd = $("#copyCrsCreCd").val();
		
		if(!copyCrsCreCd) {
			alert('<spring:message code="common.label.select.crs" />'); // 과목을 선택하세요.
			return;
		}
		
		var crsCreNm = $("#copyCrsCreCd option:selected").text();
		
		var confirmMsg = '<spring:message code="common.regist.msg" />?'; // 등록하시겠습니까?
		
		if(gubun == "ALL") {
			// 가져오기 등록하시겠습니까?
			if(!confirm(crsCreNm + ' <spring:message code="common.button.copy" /> <spring:message code="common.regist.msg" />?')) return;
		} else if(gubun == "LESSON") {
			// 학습자료 등록하시겠습니까?
			if(!confirm(crsCreNm + ' <spring:message code="lesson.label.lesson.cnts" /> <spring:message code="common.regist.msg" />?')) return;
		} else if(gubun == "NOTICE") {
			// 과목공지 등록하시겠습니까?
			if(!confirm(crsCreNm + ' <spring:message code="common.label.lect.notice" /> <spring:message code="common.regist.msg" />?')) return;
		} else if(gubun == "PDS") {
			// 강의자료실 등록하시겠습니까?
			if(!confirm(crsCreNm + ' <spring:message code="common.label.pds" /> <spring:message code="common.regist.msg" />?')) return;
		} else if(gubun == "ASMNT") {
			// 과제 등록하시겠습니까?
			if(!confirm(crsCreNm + ' <spring:message code="common.label.asmnt" /> <spring:message code="common.regist.msg" />?')) return;
		} else if(gubun == "FORUM") {
			// 토론 등록하시겠습니까?
			if(!confirm(crsCreNm + ' <spring:message code="common.label.forum" /> <spring:message code="common.regist.msg" />?')) return;
		} else if(gubun == "QUIZ") {
			// 퀴즈 등록하시겠습니까?
			if(!confirm(crsCreNm + ' <spring:message code="common.label.question" /> <spring:message code="common.regist.msg" />?')) return;
		} else if(gubun == "RESCH") {
			// 설문 등록하시겠습니까?
			if(!confirm(crsCreNm + ' <spring:message code="common.label.resh" /> <spring:message code="common.regist.msg" />?')) return;
		}
		
		var url = "/crs/creCrsHome/copyPrevCourse.do";
		var data = {
			  crsCreCd : '<c:out value="${creCrsVO.crsCreCd}" />'
			, copyCrsCreCd: copyCrsCreCd
			, gubun: gubun
		};

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				var returnVO = data.returnVO || {};
				
				var msgList = [];
				var lessonMsg = '<spring:message code="lesson.label.lesson.cnts" /> : ' + (returnVO["LESSON"] || 0) + '<spring:message code="common.page.total_count" />'; // 학습자료 : 0 건
				var noticeMsg = '<spring:message code="common.label.lect.notice" /> : ' + (returnVO["NOTICE"] || 0) + '<spring:message code="common.page.total_count" />'; // 과목공지 : 0 건
				var pdsMsg = '<spring:message code="common.label.pds" /> : ' + (returnVO["PDS"] || 0) + '<spring:message code="common.page.total_count" />'; // 강의자료실 : 0 건
				var asmntMsg = '<spring:message code="common.label.asmnt" /> : ' + (returnVO["ASMNT"] || 0) + '<spring:message code="common.page.total_count" />'; // 과제 : 0 건
				var forumMsg = '<spring:message code="common.label.forum" /> : ' + (returnVO["ASMNT"] || 0) + '<spring:message code="common.page.total_count" />'; // 토론 : 0 건
				var quizMsg = '<spring:message code="common.label.question" /> : ' + (returnVO["QUIZ"] || 0) + '<spring:message code="common.page.total_count" />'; // 퀴즈 : 0 건
				var reschMsg = '<spring:message code="common.label.resh" /> : ' + (returnVO["RESCH"] || 0) + '<spring:message code="common.page.total_count" />'; // 설문 : 0 건
				
				if(gubun == "ALL" || gubun == "LESSON") {
					msgList.push(lessonMsg);
				}
				
				if(gubun == "ALL" || gubun == "NOTICE") {
					msgList.push(noticeMsg);
				}
				
				if(gubun == "ALL" || gubun == "PDS") {
					msgList.push(pdsMsg);
				}
				
				if(gubun == "ALL" || gubun == "ASMNT") {
					msgList.push(asmntMsg);
				}
				
				if(gubun == "ALL" || gubun == "FORUM") {
					msgList.push(forumMsg);
				}
				
				if(gubun == "ALL" || gubun == "QUIZ") {
					msgList.push(quizMsg);
				}
				
				if(gubun == "ALL" || gubun == "RESCH") {
					msgList.push(reschMsg);
				}
				
				alert('<spring:message code="common.result.success" />\n' + msgList.join(", ")); // 성공적으로 작업을 완료하였습니다.
			} else {
				alert(data.message);
			}
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
		});
	}
</script>
<body class="<%=SessionInfo.getThemeMode(request)%>">
	<div id="wrap" class="pusher">
		<!-- class_top 인클루드  -->
		<%@ include file="/WEB-INF/jsp/common/class_lnb.jsp"%>
		
		<div id="container">
			<%@ include file="/WEB-INF/jsp/common/class_header.jsp"%>
			
			<!-- 본문 content 부분 -->
			<div class="content stu_section">
				<%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
		        
		        <div class="ui form">
                	<div class="layout2">
                		<!-- 타이틀 -->
                        <div id="info-item-box">
                        	<script type="text/javascript">
								$(document).ready(function () {
									var title1 = '<spring:message code="crs.label.import.prev.subject" />'; // 이전과목 가져오기
									var title2 = "";
									
									setLocationBar(title1, title2);
								});
							</script>
							
                            <h2 class="page-title flex-item flex-wrap gap4 columngap16">
								<spring:message code="crs.label.import.prev.subject" /><!-- 이전과목 가져오기 -->
                            </h2>
                            <div class="button-area">
                            </div>
                        </div>
                	
	                	<!-- 영역1 -->
	                    <div class="row">
	                        <div class="col">
		                        <!-- 검색조건 -->
								<div class="option-content mb10">
									<select class="ui dropdown mr5" id="creYear" onchange="changeCrsCre()">
										<c:forEach var="item" items="${yearList}" varStatus="status">
											<option value="${item}" <c:if test="${item eq prevYear}">selected</c:if>>${item}</option>
										</c:forEach>
									</select>
									<select class="ui dropdown mr5" id="creTerm" onchange="changeCrsCre()">
										<c:forEach var="item" items="${termList}">
											<option value="${item.codeCd}" <c:if test="${item.codeCd eq prevTerm}">selected</c:if>>${item.codeNm}</option>
										</c:forEach>
									</select>
									<select class="ui dropdown mr5 w300" id="copyCrsCreCd">
										<option value=""><spring:message code="crs.label.crecrs.sel" /><!-- 과목 선택 --></option>
									</select>
								</div>
								<div class="ui segment">
									<ul class="tbl border-top-grey">
										<li>
				                			<dl>
												<dt class="p5">
													<a href="javascript:getPrevInfo('ALL')" class="ui fluid button blue <c:if test="${prevCourseYn eq 'Y'}">disabled</c:if>">전체 가져오기</a>
												</dt>
												<dd class="bcLgrey">
													<spring:message code="crs.label.import.prev.subject.guide1" /><!-- 하단 목록의 모든 데이터를 한 과목으로 가져 옵니다. -->
												</dd>
											</dl>
				                		</li>
				                		<li>
				                			<spring:message code="lesson.label.lesson.cnts" var="msgArgu" /><!-- 학습자료 -->
				                			<dl>
												<dt class="p5 bcWhite">
													<a href="javascript:getPrevInfo('LESSON')" class="ui fluid button basic <c:if test="${prevCourseYn eq 'Y'}">disabled</c:if>"><c:out value="${msgArgu}" /></a>
												</dt>
												<dd>
													1. <spring:message code="crs.label.import.prev.subject.guide2" arguments="${msgArgu}"  /><!-- 이전학기의 {0} 전체를 가져옵니다. -->
												</dd>
											</dl>
				                		</li>
				                		<li>
				                			<spring:message code="common.label.lect.notice" var="msgArgu" /><!-- 과목공지 -->
				                			<dl>
												<dt class="p5 bcWhite">
													<a href="javascript:getPrevInfo('NOTICE')" class="ui fluid button basic <c:if test="${prevCourseYn eq 'Y'}">disabled</c:if>"><c:out value="${msgArgu}" /></a>
												</dt>
												<dd>
													2. <spring:message code="crs.label.import.prev.subject.guide2" arguments="${msgArgu}"  /><!-- 이전학기의 {0} 전체를 가져옵니다. -->
												</dd>
											</dl>
				                		</li>
				                		<li>
				                			<spring:message code="common.label.pds" var="msgArgu" /><!-- 강의자료실 -->
				                			<dl>
												<dt class="p5 bcWhite">
													<a href="javascript:getPrevInfo('PDS')" class="ui fluid button basic <c:if test="${prevCourseYn eq 'Y'}">disabled</c:if>"><c:out value="${msgArgu}" /></a>
												</dt>
												<dd>
													3. <spring:message code="crs.label.import.prev.subject.guide2" arguments="${msgArgu}"  /><!-- 이전학기의 {0} 전체를 가져옵니다. -->
												</dd>
											</dl>
				                		</li>
				                		<li>
				                			<spring:message code="common.label.asmnt" var="msgArgu" /><!-- 과제 -->
				                			<dl>
												<dt class="p5 bcWhite">
													<a href="javascript:getPrevInfo('ASMNT')" class="ui fluid button basic <c:if test="${prevCourseYn eq 'Y'}">disabled</c:if>"><c:out value="${msgArgu}" /></a>
												</dt>
												<dd>
													4. <spring:message code="crs.label.import.prev.subject.guide2" arguments="${msgArgu}"  /><!-- 이전학기의 {0} 전체를 가져옵니다. -->
												</dd>
											</dl>
				                		</li>
				                		<li>
				                			<spring:message code="common.label.forum" var="msgArgu" /><!-- 토론 -->
				                			<dl>
												<dt class="p5 bcWhite">
													<a href="javascript:getPrevInfo('FORUM')" class="ui fluid button basic <c:if test="${prevCourseYn eq 'Y'}">disabled</c:if>"><c:out value="${msgArgu}" /></a>
												</dt>
												<dd>
													5. <spring:message code="crs.label.import.prev.subject.guide2" arguments="${msgArgu}"  /><!-- 이전학기의 {0} 전체를 가져옵니다. -->
												</dd>
											</dl>
				                		</li>
				                		<li>
				                			<spring:message code="common.label.question" var="msgArgu" /><!-- 설문 -->
				                			<dl>
												<dt class="p5 bcWhite">
													<a href="javascript:getPrevInfo('QUIZ')" class="ui fluid button basic <c:if test="${prevCourseYn eq 'Y'}">disabled</c:if>"><c:out value="${msgArgu}" /></a>
												</dt>
												<dd>
													6. <spring:message code="crs.label.import.prev.subject.guide2" arguments="${msgArgu}"  /><!-- 이전학기의 {0} 전체를 가져옵니다. -->
												</dd>
											</dl>
				                		</li>
				                		<li>
				                			<spring:message code="common.label.resh" var="msgArgu" /><!-- 설문 -->
				                			<dl>
												<dt class="p5 bcWhite">
													<a href="javascript:getPrevInfo('RESCH')" class="ui fluid button basic <c:if test="${prevCourseYn eq 'Y'}">disabled</c:if>"><c:out value="${msgArgu}" /></a>
												</dt>
												<dd>
													7. <spring:message code="crs.label.import.prev.subject.guide2" arguments="${msgArgu}"  /><!-- 이전학기의 {0} 전체를 가져옵니다. -->
												</dd>
											</dl>
				                		</li>
									</ul>
								</div>
	                        </div><!-- //col -->
	                 	</div><!-- //row -->
                	
                	</div><!-- //layout2 -->
	        	</div><!-- //ui form -->
			</div><!-- //content stu_section -->
			
			<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
		</div><!-- //container -->
		
	</div><!-- //wrap -->
</body>
</html>