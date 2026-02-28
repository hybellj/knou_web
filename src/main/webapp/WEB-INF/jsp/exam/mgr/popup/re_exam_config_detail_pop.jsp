<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<script type="text/javascript">
		$(document).ready(function() {
			reExamStdList();
		});
		
		// 미응시자 목록
		function reExamStdList() {
			var url = "/exam/examMgr/reExamStdList.do";
			var param = {
				  haksaYear			: '<c:out value="${haksaYear}" />'
				, haksaTerm			: '<c:out value="${haksaTerm}" />'
				, crsCreCd			: '<c:out value="${creCrsVO.crsCreCd}" />'
				, examStareTypeCd	: '<c:out value="${examVO.examStareTypeCd}" />'
				, reExamYn			: 'Y'
			};
			
			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					var html = '';
					
					returnList = returnList.sort(function(a, b) {
						if(a.deptNm < b.deptNm) return -1;
						if(a.deptNm > b.deptNm) return 1;
						if(a.deptNm == b.deptNm) {
							if(a.userNm < b.userNm) return -1;
							if(a.userNm > b.userNm) return 1;
						}
						return 0;
					});
					
					returnList.forEach(function(v, i) {
						var uniNm = "-";
						
						if(v.uniCd == "C") {
							uniNm = '<spring:message code="common.label.uni.college" />'; // 대학교
						} else if(v.uniCd == "G") {
							uniNm = '<spring:message code="common.label.uni.graduate" />'; // 대학원
						}
						
						var examStareTypeNm = "-";
						
						if(v.examStareTypeCd == "M") {
							examStareTypeNm = '<spring:message code="exam.label.mid.exam" />'; // 중간고사
						} else if(v.examStareTypeCd == "L") {
							examStareTypeNm = '<spring:message code="exam.label.end.exam" />'; // 기말고사
						}
						
						html += '<tr>';
						html += '	<td>' + (i + 1) + '</td>';
						html += '	<td>' + uniNm + '</td>';
						html += '	<td>' + examStareTypeNm + '</td>';
						html += '	<td>' + v.deptNm + '</td>';
						html += '	<td>' + v.userId + '</td>';
						html += '	<td>' + v.userNm + '</td>';
						html += '	<td>' + v.crsCd + '</td>';
						html += '	<td>' + v.declsNo + '</td>';
						html += '	<td>' + v.crsCreNm + '</td>';
						html += '	<td>' + v.tchNm + '</td>';
						html += '</tr>';
					});
					
					$("#reExamStdList").html(html);
					$("#reExamStdTable").footable();
		    			
					$("#totalCntText").text(returnList.length);
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
	</script>
	
	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
            <div class="ui form">
            	<div class="option-content">
	        		<h3 class="sec_head"><spring:message code='exam.label.re.exam.regist.info' /><!-- 재시험 등록 정보 --></h3>
	        	</div>
            	<ul class="tbl dt-sm">
                    <li>
                        <dl>
                            <dt><spring:message code='exam.label.stare.year' /><!-- 응시년도 -->/<spring:message code='exam.label.term' /><!-- 학기 --></dt>
                            <dd><span class="fcBlue"><c:out value="${haksaYear}" /><spring:message code='exam.label.year' /><!-- 년 --> <c:out value="${haksaTermNm}" /></span></dd>
                            <dt><spring:message code="exam.label.crs.dept" /><!-- 관장학과 --></dt>
                            <dd><c:out value="${creCrsVO.deptNm}" /></dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><spring:message code="exam.label.exam.stare.type" /><!-- 시험구분 --></dt>
                            <dd>
                            	<c:choose>
                            		<c:when test="${examVO.examStareTypeCd eq 'M'}">
                            			<spring:message code='exam.label.mid.exam' /><!-- 중간고사 -->
                            		</c:when>
                            		<c:when test="${examVO.examStareTypeCd eq 'L'}">
                            			<spring:message code='exam.label.end.exam' /><!-- 기말고사 -->
                            		</c:when>
                            	</c:choose>
                           	</dd>
                            <dt><spring:message code="crs.label.crs.cd" /><!-- 학수번호 --></dt>
                            <dd><c:out value="${creCrsVO.crsCd}" /></dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><spring:message code="exam.label.re.exam.dttm" /><!-- 재시험 일시 --></dt>
                            <dd>
                            	<fmt:parseDate  var="reExamStartDttmFmt"  pattern="yyyyMMddHHmmss" value="${examVO.reExamStartDttm}" />
	                            <fmt:formatDate var="reExamStartDttm" pattern="yyyy.MM.dd HH:mm" value="${reExamStartDttmFmt}" />
                            	<c:out value="${reExamStartDttm}" />
                           	</dd>
                            <dt><spring:message code='crs.label.crecrs.nm' /><!-- 과목명 --></dt>
                            <dd><c:out value="${creCrsVO.crsCreNm}" /></dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><spring:message code='exam.label.exam.time'/><!-- 시험시간 --></dt>
                            <dd><c:out value="${examVO.reExamStareTm}" /><spring:message code="exam.label.min.time" /><!-- 분 --></dd>
                            <dt><spring:message code="crs.label.decls" /><!-- 분반 --></dt>
                            <dd><c:out value="${creCrsVO.declsNo}" /></dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><spring:message code='exam.label.dsbl.req'/><!-- 장애인 시험지원 --></dt>
                            <dd><c:out value="${examVO.dsblAddTm}" /><spring:message code="exam.label.min.time" /><!-- 분 --></dd>
                            <dt><spring:message code="exam.label.tch.rep" /><!-- 담당교수 --></dt>
                            <dd><c:out value="${creCrsVO.repUserNm}" /></dd>
                        </dl>
                    </li>
                </ul>
                
                <div class="option-content">
	        		<h3 class="sec_head"><spring:message code='exam.label.re.exam.target' /><!-- 재시험 대상자 --></h3>
	        		<span class="pl10">[ <spring:message code="exam.label.total.cnt" /><!-- 총 건수 --> : <label id="totalCntText">0</label> ]</span>
	        	</div>
	        	
	        	<div style="max-height: 260px; overflow: auto;">
		        	<table class="table type2" data-empty="<spring:message code='exam.common.empty' />" id="reExamStdTable"><!-- 등록된 내용이 없습니다. -->
		            	<thead>
		       				<tr>
		       					<th class=""><spring:message code="main.common.number.no" /><!-- NO. --></th>
		       					<th class="" data-breakpoints="xs"><spring:message code="exam.label.org.type" /><!-- 대학구분 --></th>
		       					<th class="" data-breakpoints="xs"><spring:message code="exam.label.exam.stare.type" /><!-- 시험구분 --></th>
		       					<th class="" data-breakpoints="xs"><spring:message code="exam.label.user.dept" /><!-- 소속학과 --></th>
		       					<th class="" data-breakpoints="xs"><spring:message code="exam.label.user.no" /><!-- 학번 --></th>
		       					<th class="" data-breakpoints="xs"><spring:message code="exam.label.user.nm" /><!-- 이름 --></th>
		       					<th class="" data-breakpoints="xs"><spring:message code="crs.label.crs.cd" /><!-- 학수번호 --></th>
		       					<th class="" data-breakpoints="xs"><spring:message code="crs.label.decls" /><!-- 분반 --></th>
		       					<th class="" data-breakpoints="xs"><spring:message code="crs.label.crecrs.nm" /><!-- 과목명 --></th>
		       					<th class="" data-breakpoints="xs"><spring:message code="exam.label.tch.rep" /><!-- 담당교수 --></th>
		       				</tr>
		       			</thead>
		       			<tbody id="reExamStdList">
		       			</tbody>
		            </table>
	            </div>
            </div>
        	
        	<div class="bottom-content">
                <button type="button" class="ui basic button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /><!-- 닫기 --></button>
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
