<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
	
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/xeicon.min.css" />
   	
   	<script type="text/javascript">
	   	$(document).ready(function() {
	   		listLessonStatusByStd();
	   	});
	   	
	   	function listLessonStatusByStd() {
	   		var url = "/dashboard/listLessonStatusByStd.do";
			var param = {
				  haksaYear		: '<c:out value="${vo.haksaYear}" />'
				, haksaTerm		: '<c:out value="${vo.haksaTerm}" />'
				, userId		: '<c:out value="${vo.userId}" />'
				, searchKey		: 'lessonStatusPop'
			};
			
			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					
					if(returnList.length == 0) {
						$("#tableResultNone").show();
						$("#hy").text("-");
					} else {
						$("#tableResultNone").hide();
						
						returnList.sort(function(a, b) {
							if(a.crsCreNm < b.crsCreNm) return -1;
							if(a.crsCreNm > b.crsCreNm) return 1;
							if(a.crsCreNm == b.crsCreNm) {
								if(a.declsNo < b.declsNo) return -1;
								if(a.declsNo > b.declsNo) return 1;
							}
							return 0;
						});
						
						// 학년정보 세팅
						var hy = "-";
						returnList.forEach(function(v, i) {
							if(v.hy) {
								hy = v.hy;
								return false;
							}
						});
						$("#hy").text(hy);
					}
					
					var html = '';
					returnList.forEach(function(v, i) {
						var entrYy = v.entrYy;
						var entrHy = v.entrHy;
						var enterDt = "-";
						
						if(entrYy && entrHy) {
							enterDt = entrYy + "-" + entrHy;
						}
						
						var iconMap = {
							  COMPLETE	: '<i class="ico icon-solid-circle fcBlue"></i>'
							, LATE		: '<i class="ico icon-triangle fcYellow"></i>'
							, STUDY		: '<i class="ico icon-hyphen"></i>'
							, NOSTUDY	: '<i class="ico icon-cross fcRed"></i>'
							, READY		: '<i class="ico icon-slash"></i>'
						};
						
						var emptyIcon = '<i class="ico icon-slash"></i>';
						
						var icon1 = iconMap[v.studyStatusCd1] || emptyIcon;
						var icon2 = iconMap[v.studyStatusCd2] || emptyIcon;
						var icon3 = iconMap[v.studyStatusCd3] || emptyIcon;
						var icon4 = iconMap[v.studyStatusCd4] || emptyIcon;
						var icon5 = iconMap[v.studyStatusCd5] || emptyIcon;
						var icon6 = iconMap[v.studyStatusCd6] || emptyIcon;
						var icon7 = iconMap[v.studyStatusCd7] || emptyIcon;
						var icon8 = iconMap[v.studyStatusCd8] || emptyIcon;
						var icon9 = iconMap[v.studyStatusCd9] || emptyIcon;
						var icon10 = iconMap[v.studyStatusCd10] || emptyIcon;
						var icon11 = iconMap[v.studyStatusCd11] || emptyIcon;
						var icon12 = iconMap[v.studyStatusCd12] || emptyIcon;
						var icon13 = iconMap[v.studyStatusCd13] || emptyIcon;
						var icon14 = iconMap[v.studyStatusCd14] || emptyIcon;
						var icon15 = iconMap[v.studyStatusCd15] || emptyIcon;
						
						var examCntList = (v.examCnt || "0/0").split('/');
						var qnaCntList = (v.qnaCnt || "0/0").split('/');
						var secretCntList = (v.secretCnt || "0/0").split('/');
						var asmntCntList = (v.asmntCnt || "0/0").split('/');
						var forumCntList = (v.forumCnt || "0/0").split('/');
						var quizCntList = (v.quizCnt || "0/0").split('/');
						var reschCntList = (v.reschCnt || "0/0").split('/');
						var aexamCntList = (v.aexamCnt || "0/0").split('/');
						var seminarCntList = (v.seminarCnt || "0/0").split('/');
						
						html += '<tr>';
						html += '	<td rowspan="2" class="tc p5">' + (i + 1) + '</td>';
						html += '	<td rowspan="2" class="p5 word_break_none">' + v.crsCreNm + ' (' + v.declsNo + ')</td>';
						html += '	<td class="tc p5">' + icon1 + '</td>';
						html += '	<td class="tc p5">' + icon2 + '</td>';
						html += '	<td class="tc p5">' + icon3 + '</td>';
						html += '	<td class="tc p5">' + icon4 + '</td>';
						html += '	<td class="tc p5">' + icon5 + '</td>';
						html += '	<td class="tc p5">' + icon6 + '</td>';
						html += '	<td class="tc p5">' + icon7 + '</td>';
						html += '	<td rowspan="2" class="tc p5">' + v.studyRate + '%</td>';
						html += '	<td rowspan="2" class="tc p5"><span class="fcBlue">' + examCntList[0] + '</span>/' + examCntList[1] + '</td>';
						html += '	<td rowspan="2" class="tc p5"><span class="fcBlue">' + qnaCntList[0] + '</span>/' + qnaCntList[1] + '</td>';
						html += '	<td rowspan="2" class="tc p5"><span class="fcBlue">' + secretCntList[0] + '</span>/' + secretCntList[1] + '</td>';
						html += '	<td rowspan="2" class="tc p5"><span class="fcBlue">' + asmntCntList[0] + '</span>/' + asmntCntList[1] + '</td>';
						html += '	<td rowspan="2" class="tc p5"><span class="fcBlue">' + forumCntList[0] + '</span>/' + forumCntList[1] + '</td>';
						html += '	<td rowspan="2" class="tc p5"><span class="fcBlue">' + quizCntList[0] + '</span>/' + quizCntList[1] + '</td>';
						html += '	<td rowspan="2" class="tc p5"><span class="fcBlue">' + reschCntList[0] + '</span>/' + reschCntList[1] + '</td>';
						html += '	<td rowspan="2" class="tc p5"><span class="fcBlue">' + aexamCntList[0] + '</span>/' + aexamCntList[1] + '</td>';
						html += '	<td rowspan="2" class="tc p5"><span class="fcBlue">' + seminarCntList[0] + '</span>/' + seminarCntList[1] + '</td>';
						html += '</tr>';
						html += '<tr>';
						html += '	<td class="tc p5">' + icon9 + '</td>';
						html += '	<td class="tc p5">' + icon10 + '</td>';
						html += '	<td class="tc p5">' + icon11 + '</td>';
						html += '	<td class="tc p5">' + icon12 + '</td>';
						html += '	<td class="tc p5">' + icon13 + '</td>';
						html += '	<td class="tc p5">' + icon14 + '</td>';
						html += '	<td class="tc p5">' + icon15 + '</td>';
						html += '</tr>';
					});
					
					$("#lessonStatusByStdList").html(html);
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				/* 에러가 발생했습니다! */
				alert('<spring:message code="fail.common.msg" />');
			}, true);
	   	}
   	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
        <div class="ui form">
			<div class="fields">
                <div class="two wide field">
                    <div class="initial-img border-radius0" id="pthFileDiv" style="width:100px">
                    	<c:choose>
        					<c:when test="${not empty userInfoVO.phtFile}">
								<img alt="<spring:message code="forum.common.user.img" />" style="max-width:100%;max-height:100%" src='${userInfoVO.phtFile}'>
        					</c:when>
        					<c:otherwise>
        						<img alt="<spring:message code="forum.common.user.img" />" style="max-width:100%;min-width:60%;max-height:100%" src="/webdoc/img/icon-hycu-symbol-grey.svg">
        					</c:otherwise>
        				</c:choose>
                    </div>                                            
                </div>
                <ul class="fourteen wide field tbl dt-sm">
                    <li>
                        <dl>
                            <dt><spring:message code="std.label.user_id" /></dt><!-- 학번 -->
                            <dd><c:out value="${empty userInfoVO.userId ? '-' : userInfoVO.userId}" /></dd>
                            <dt><spring:message code="std.label.name" /></dt><!-- 이름 -->
                            <dd><c:out value="${empty userInfoVO.userNm ? '-' : userInfoVO.userNm}" /></dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><spring:message code="std.label.dept" /></dt><!-- 학과 -->
                            <dd><c:out value="${empty userInfoVO.deptNm ? '-' : userInfoVO.deptNm}" /></dd>
                            <dt><spring:message code="std.label.enter.year" /></dt><!-- 입학년도 -->
                            <dd>
                            	<c:choose>
                            		<c:when test="${not empty userInfoVO.entrYy}">
                            			<c:out value="${userInfoVO.entrYy}" />
                            		</c:when>
                            		<c:otherwise>
                            			-
                            		</c:otherwise>
                            	</c:choose>
                           	</dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><spring:message code="std.label.hy" /></dt><!-- 학년 -->
                            <dd id="hy"></dd>
                        </dl>
                    </li>
                </ul>
            </div>
            <div class="option-content mt20 mb10">
                <div class="sec_head"><spring:message code="std.button.stu_status" /></div><!-- 학습현황 -->
                <div class="flex-left-auto">
                </div>
            </div>
            
            <div class="footable_box type2 max-height-550">
				<table class="tBasic" data-sorting="false" data-paging="false" data-empty="<spring:message code='common.content.not_found' />" >
					<thead class="sticky top0">
						<tr>
							<th rowspan="3" class="p5"><spring:message code="common.number.no" /></th><!-- NO -->
							<th rowspan="3" class="p5"><spring:message code="common.subject"/></th><!-- 과목 -->
							<th colspan="7" class="p5"><spring:message code="dashboard.attend.status"/></th><!-- 출석현황 -->
							<th rowspan="3" class="p5"><spring:message code="dashboard.prog"/></th><!-- 진도율 -->
							<th rowspan="3" class="p5"><spring:message code="dashboard.cor.exam"/></th><!-- 시험 -->
							<th rowspan="3" class="p5"><spring:message code="dashboard.qna" /></th><!-- Q&A -->
							<th rowspan="3" class="p5"><spring:message code="dashboard.cor.councel" /></th><!-- 1:1 -->
							<th rowspan="3" class="p5"><spring:message code="common.label.asmnt"/></th><!-- 과제 -->
							<th rowspan="3" class="p5"><spring:message code="common.label.forum"/></th><!-- 토론 -->
							<th rowspan="3" class="p5"><spring:message code="common.label.question"/></th><!-- 퀴즈 -->
							<th rowspan="3" class="p5"><spring:message code="common.label.resh"/></th><!-- 설문 -->
							<th rowspan="3" class="p5"><spring:message code="dashboard.cor.admission"/></th><!-- 수시 -->
							<th rowspan="3" class="p5"><spring:message code="dashboard.seminar"/></th><!-- 세미나 -->
						</tr>
						<tr>
							<th class="p5">1</th>
							<th class="p5">2</th>
							<th class="p5">3</th>
							<th class="p5">4</th>
							<th class="p5">5</th>
							<th class="p5">6</th>
							<th class="p5">7</th>
						</tr>
						<tr>
							<th class="p5">9</th>
							<th class="p5">10</th>
							<th class="p5">11</th>
							<th class="p5">12</th>
							<th class="p5">13</th>
							<th class="p5">14</th>
							<th class="p5">/</th>
						</tr>
					</thead>
					<tbody id="lessonStatusByStdList">
					</tbody>
				</table>
				<div class="none tc pt10" id="tableResultNone">
					<span><spring:message code="common.nodata.msg"/></span><!-- 등록된 내용이 없습니다. -->
				</div>
			</div>
		</div>
		<div class="bottom-content">
			<button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>