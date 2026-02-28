<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
	
	<link rel="stylesheet" type="text/css" href="/webdoc/css/xeicon.min.css" />
	
   	<script type="text/javascript">
	   	$(document).ready(function() {
		});
   	</script>
</head>
<body class="p20" style="overflow: auto; ">
	<div id="wrap">
		<div class="p10 fcWhite bcBlue f120 tc">
			학습현황
		</div>

		<c:if test="${result == '1'}">
	        <div class="ui segment">
	        	<table id="studentListTable" class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code="common.content.not_found" />">
					<thead>
						<tr>
							<th scope="col" class="tc p_w20">과목명</th>
							<th scope="col" class="tc p_w30">
								<div class="tc">출석현황</div>
								<div class="flex">
			      					<div class="p4 w30 word_break_none tc">1</div>
			      					<div class="p4 w30 word_break_none tc">2</div>
			      					<div class="p4 w30 word_break_none tc">3</div>
			      					<div class="p4 w30 word_break_none tc">4</div>
			      					<div class="p4 w30 word_break_none tc">5</div>
			      					<div class="p4 w30 word_break_none tc">6</div>
			      					<div class="p4 w30 word_break_none tc">7</div>
		        				</div>
		        				<div class="flex">
			      					<div class="p4 w30 word_break_none tc">9</div>
			      					<div class="p4 w30 word_break_none tc">10</div>
			      					<div class="p4 w30 word_break_none tc">11</div>
			      					<div class="p4 w30 word_break_none tc">12</div>
			      					<div class="p4 w30 word_break_none tc">13</div>
			      					<div class="p4 w30 word_break_none tc">14</div>
		        				</div>
							</th>
							<th scope="col" class="tc word_break_none">진도율</th>
							<th scope="col" class="tc word_break_none">Q&A</th>
							<th scope="col" class="tc word_break_none">시험</th>
							<th scope="col" class="tc word_break_none">상담</th>
							<th scope="col" class="tc word_break_none">과제</th>
							<th scope="col" class="tc word_break_none">토론</th>
							<th scope="col" class="tc word_break_none">퀴즈</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="cors" items="${corsList}" varStatus="status">
			        		<c:set var="lessonList" value="${cors.lessonScheduleList}"/>
			        		<tr>
			        			<td class="fwb word_break_none"><c:if test="${cors.gvupYn eq 'Y'}">[수강포기]</c:if> <c:out value="${cors.crsCreNm}"/> (<c:out value="${cors.declsNo}"/>반)</td>
			        			<td class="tc word_break_none">
			        				<div class="flex">
				        				<c:forEach var="lesn" items="${lessonList}" varStatus="weekStatus">
											<c:if test="${empty lesn.examStareTypeCd and weekStatus.index < 7}">
								         		<c:choose>
								         			<c:when test="${!(lesn.wekClsfGbn eq '02' or lesn.wekClsfGbn eq '03') and lesn.prgrVideoCnt eq 0}">
								         				<c:choose>
								         					<c:when test="${lesn.startDtYn eq 'N'}">
								         						<span class="p4 w30"><i class="ico icon-state-slash"></i></span>
								         					</c:when>
								         					<c:otherwise>
								         						<span class="p4 w30"><i class="ico icon-hyphen"></i></span>
								         					</c:otherwise>
								         				</c:choose>
							      					</c:when>
									      			<c:when test="${lesn.studyStatusCd eq 'COMPLETE'}">
														<div class="p4 w30"><i class="ico icon-solid-circle fcBlue"></i></div>
									      			</c:when>
									      			<c:when test="${lesn.studyStatusCd eq 'LATE'}">
									      				<div class="p4 w30"><i class="ico icon-triangle fcYellow"></i></div>
									      			</c:when>
									      			<c:when test="${lesn.startDtYn eq 'N'}">
									      				<span class="p4 w30"><i class="ico icon-state-slash"></i></span>
									      			</c:when>
									      			<c:when test="${lesn.startDtYn eq 'Y' and lesn.endDtYn eq 'N'}">
							      						<c:choose>
															<c:when test="${lesn.studyStatusCd eq 'STUDY'}">
																<span class="p4 w30"><i class="ico icon-hyphen"></i></span>
															</c:when>
															<c:otherwise>
																<span class="p4 w30"><i class="ico icon-hyphen"></i></span>
															</c:otherwise>
														</c:choose>
									      			</c:when>
									      			<c:otherwise>
									      				<div class="p4 w30"><i class="ico icon-cross fcRed"></i></div>
									      			</c:otherwise>
									      		</c:choose>
											</c:if>
				        				</c:forEach>
			        				</div>
			        				<div class="flex">
				        				<c:forEach var="lesn" items="${lessonList}" varStatus="weekStatus">
											<c:if test="${empty lesn.examStareTypeCd and weekStatus.index > 7}">
								         		<c:choose>
								         			<c:when test="${!(lesn.wekClsfGbn eq '02' or lesn.wekClsfGbn eq '03') and lesn.prgrVideoCnt eq 0}">
								         				<c:choose>
								         					<c:when test="${lesn.startDtYn eq 'N'}">
								         						<span class="p4 w30"><i class="ico icon-state-slash"></i></span>
								         					</c:when>
								         					<c:otherwise>
								         						<span class="p4 w30"><i class="ico icon-hyphen"></i></span>
								         					</c:otherwise>
								         				</c:choose>
							      					</c:when>
									      			<c:when test="${lesn.studyStatusCd eq 'COMPLETE'}">
														<div class="p4 w30"><i class="ico icon-solid-circle fcBlue"></i></div>
									      			</c:when>
									      			<c:when test="${lesn.studyStatusCd eq 'LATE'}">
									      				<div class="p4 w30"><i class="ico icon-triangle fcYellow"></i></div>
									      			</c:when>
									      			<c:when test="${lesn.startDtYn eq 'N'}">
									      				<span class="p4 w30"><i class="ico icon-state-slash"></i></span>
									      			</c:when>
									      			<c:when test="${lesn.startDtYn eq 'Y' and lesn.endDtYn eq 'N'}">
							      						<c:choose>
															<c:when test="${lesn.studyStatusCd eq 'STUDY'}">
																<span class="p4 w30"><i class="ico icon-hyphen"></i></span>
															</c:when>
															<c:otherwise>
																<span class="p4 w30"><i class="ico icon-hyphen"></i></span>
															</c:otherwise>
														</c:choose>
									      			</c:when>
									      			<c:otherwise>
									      				<div class="p4 w30"><i class="ico icon-cross fcRed"></i></div>
									      			</c:otherwise>
									      		</c:choose>
									      	</c:if>	        				
				        				</c:forEach>
			        				</div>
			        			</td>
			        			<td class="tc">
			        				<c:set var="lessonCnt" value="0" />
			        				<c:set var="completeCnt" value="0" />
			        				<c:set var="lateCnt" value="0" />
			        				<c:forEach var="lesn" items="${lessonList}" varStatus="weekStatus">
			        					<c:if test="${lesn.wekClsfGbn eq '02' or lesn.wekClsfGbn eq '03' or lesn.prgrVideoCnt > 0 and lesn.startDtYn eq 'Y'}">
		        							<c:set var="lessonCnt" value="${lessonCnt + 1}" />
			        						<c:choose>
								      			<c:when test="${lesn.studyStatusCd eq 'COMPLETE'}">
													<c:set var="completeCnt" value="${completeCnt + 1}" />
								      			</c:when>
								      			<c:when test="${lesn.studyStatusCd eq 'LATE'}">
								      				<c:set var="lateCnt" value="${lateCnt + 1}" />
								      			</c:when>
								      		</c:choose>
			        					</c:if>
			        				</c:forEach>
			        				<c:choose>
			        					<c:when test="${lessonCnt eq 0}">
			        						0%
			        					</c:when>
			        					<c:otherwise>
			        						<c:set var="number" value="${(completeCnt + lateCnt) / lessonCnt * 100}" />
			        						<c:set var="number" value="${fn:substringBefore(number, '.')}" />
			        						<c:out value="${empty number ? 0 : number}" />%
			        					</c:otherwise>
			        				</c:choose>
			        			</td>
			        			<td class="tc">
			        				<c:choose>
			        					<c:when test="${cors.qnaCnt > 0}">
			        						<c:out value="${cors.qnaAnsCnt}"/>/<c:out value="${cors.qnaCnt}"/>
			        					</c:when>
			        					<c:when test="${cors.qnaCnt == 0}">
			        						-
			        					</c:when>
			        				</c:choose>
			        				
			        			</td>
			        			<td class="tc">
			        				<c:choose>
			        					<c:when test="${cors.examCnt > 0}">
			        						<c:out value="${cors.examAnsCnt}"/>/<c:out value="${cors.examCnt}"/>
			        					</c:when>
			        					<c:when test="${cors.examCnt == 0}">
			        						-
			        					</c:when>
			        				</c:choose>
			        			</td>
			        			<td class="tc">
			        				<c:choose>
			        					<c:when test="${cors.secretCnt > 0}">
			        						<c:out value="${cors.secretAnsCnt}"/>/<c:out value="${cors.secretCnt}"/>
			        					</c:when>
			        					<c:when test="${cors.secretCnt == 0}">
			        						-
			        					</c:when>
			        				</c:choose>
			        			</td>
			        			<td class="tc">
			        				<c:choose>
			        					<c:when test="${cors.asmntCnt > 0}">
			        						<c:out value="${cors.asmntSbmtCnt}"/>/<c:out value="${cors.asmntCnt}"/>
			        					</c:when>
			        					<c:when test="${cors.asmntCnt == 0}">
			        						-
			        					</c:when>
			        				</c:choose>
			        				
			        			</td>
			        			<td class="tc">
			        				<c:choose>
			        					<c:when test="${cors.forumCnt > 0}">
			        						<c:out value="${cors.forumAnsCnt}"/>/<c:out value="${cors.forumCnt}"/>
			        					</c:when>
			        					<c:when test="${cors.forumCnt == 0}">
			        						-
			        					</c:when>
			        				</c:choose>
			        			</td>
			        			<td class="tc">
			        				<c:choose>
			        					<c:when test="${cors.quizCnt > 0}">
			        						<c:out value="${cors.quizAnsCnt}"/>/<c:out value="${cors.quizCnt}"/>
			        					</c:when>
			        					<c:when test="${cors.quizCnt == 0}">
			        						-
			        					</c:when>
			        				</c:choose>
			        			</td>
			        		</tr>
			        	</c:forEach>
					</tbody>
				</table>
			</div>
		</c:if>

		<c:if test="${result == '-1'}">
			<div class="ui error message">
				비 정상적인 접근입니다.
			</div>
		</c:if>

	</div>
</body>
</html>