<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	
	<script type="text/javascript">
		$(document).ready(function(){
			$("#searchValue").on("keydown", function(e) {
				if(e.keyCode == 13) {
					haksaInfoList();
				}
			});
		});
		
		function haksaInfoList() {
			var url = "/std/stdMgr/listHaksaStdCheck.do";
			var data = {
				year: $("#creYear").val(),
				semester: $("#creTerm").val(),
				searchValue: $("#searchValue").val()
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var returnVO = data.returnVO || {};
					
					var checkCount = returnVO.checkCount || "0";
					var ernollList = returnVO.ernollList || [];
					
					var html = "";
					
					if(ernollList.length > 0) {
						ernollList.forEach(function(v, i) {
							var termNm = "";
							
							if(v.semester == "10") {
								termNm = '<spring:message code="common.haksa.term.spring" />';
							} else if(v.semester == "11") {
								termNm = '<spring:message code="common.haksa.term.summer" />';
							} else if(v.semester == "20") {
								termNm = '<spring:message code="common.haksa.term.fall" />';
							} else if(v.semester == "21") {
								termNm = '<spring:message code="common.haksa.term.winter" />';
							} 
							
							termNm += '(' + v.semester + ')';
							
							html += '<tr>';
							html += '	<td class="tc">' + (i + 1) + '</td>';
							html += ' 	<td class="tc">' + v.studentId + '</td>';
							html += ' 	<td class="tc">' + v.year + '</td>';
							html += ' 	<td class="tc">' + termNm + '</td>';
							html += ' 	<td class="tc">' + v.courseCode + '</td>';
							html += ' 	<td class="tc">' + v.section + '</td>';
							html += ' 	<td class="tc">' + v.enrollYn + '</td>';
							html += ' 	<td class="tc">' + v.auditYn + '</td>';
							html += ' 	<td class="tc">' + (v.insertAt ? formatTimestamp(v.insertAt) : "") + '</td>';
							html += ' 	<td class="tc">' + (v.modifyAt ? formatTimestamp(v.modifyAt) : "") + '</td>';
							html += '</tr>';
						});
						
						$("#resultNone").hide();
					} else {
						$("#resultNone").show();
					}
					
					$("#tableList").html(html);
					$("#totalCnt").text(checkCount);
				} else {
					alert(data.message);
					$("#totalCnt").text("0");
					$("#resultNone").show();
				}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
				$("#totalCnt").text("0");
				$("#resultNone").show();
			}, true);
		}
		
		function listExcel() {
			var excelGrid = {
				colModel:[
	               {label:"<spring:message code='common.number.no'/>",name:'order', align:'center', width:'2000'}, // NO
	               {label:"<spring:message code='lesson.label.user.no'/>",name:'studentId', align:'center',   width:'4000'}, // 학번
	               {label:"<spring:message code='common.haksa.year' />",name:'year', align:'left',   width:'3000'}, // 학년도
	               {label:"<spring:message code='exam.label.term' />", name:'semester', align:'center',  width:'4000', codes:{10:'1학기 (10)',11:'여름학기 (11)',20:'2학기 (20)',21:'겨울학기 (21)'}}, // 학기
	               {label:"<spring:message code='contents.label.crscd'/>", name:'courseCode', align:'center',  width:'4000'}, // 학수번호
	               {label:"<spring:message code='common.label.decls.no'/>", name:'section', align:'center',  width:'2000'}, // 분반
	               {label:"<spring:message code='common.label.register.course.yn'/>", name:'enrollYn', align:'center',  width:'4000'}, // 수강신청여부
	               {label:"<spring:message code="lesson.auditor.whether" />", name:'auditYn', align:'center',  width:'2000'}, // 청강여부
	               {label:"<spring:message code='common.registration.date'/>", name:'insertExcelAt', align:'center',  width:'8000'}, // 등록일자
	               {label:'<spring:message code="common.modified.date"/>', name:'modifyExcelAt', align:'center',  width:'8000'}, // 수정일자
                 ]
			};
			
			var excelForm = $('<form></form>');
			excelForm.attr("name","excelForm");
			excelForm.attr("action","/std/stdMgr/listHaksaStdExcelDown.do");
			excelForm.append($('<input/>', {type: 'hidden', name: 'year', value: $("#creYear").val()}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'semester', value: $("#creTerm").val()}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'searchValue', value: $('#searchValue').val()}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', value:JSON.stringify(excelGrid)}));
			excelForm.appendTo('body');
			excelForm.submit();	  
		}
		
		function formatTimestamp(timestamp) {
		    var date = new Date(timestamp);
		    
		    var year = date.getFullYear();
		    var month = String(date.getMonth() + 1).padStart(2, '0');
		    var day = String(date.getDate()).padStart(2, '0');
		    var hours = String(date.getHours()).padStart(2, '0');
		    var minutes = String(date.getMinutes()).padStart(2, '0');
		    
		    return year + '.' + month + '.' + day + ' ' + hours + ':' + minutes;
		}
	</script>
 </head>
<body>
	<div id="wrap" class="pusher">
	    <!-- class_top 인클루드  -->
		<!-- header -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
	    <!-- //header -->
	
		<!-- lnb -->
	    <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
	    <!-- //lnb -->
	
		<div id="container">
			<!-- 본문 content 부분 -->
	        <div class="content">
	        	<div id="info-item-box">
	               	<h2 class="page-title flex-item">
					    <spring:message code='common.term.subject' /><!-- 학기/과목 -->
					    <div class="ui breadcrumb small">
					        <small class="section"><spring:message code="crs.title.student.no.interlocker.management" /><!-- 학생 수강신청 미연동 내역 --></small>
					    </div>
					</h2>
					<div class="button-area">
						<a href="javascript:listExcel()" class="btn"><spring:message code="button.download.excel"/></a> <!-- 엑셀다운로드 -->
					</div>
				</div>
				<div class="ui divider mt0"></div>
				<div class="ui form">
					<!-- 검색영역 -->
					<div class="ui segment searchArea">
						<div class="fields">
							<div class="two wide field">
								<select class="ui dropdown mr5" id="creYear" name="creYear">
									<option value=""><spring:message code="crs.label.open.year" /></option>
									<c:forEach var="year" items="${yearList}">
										<option value="${year}" <c:if test="${year eq currentYear}">selected</c:if>>${year}</option>
									</c:forEach>
								</select>
							</div>
							<div class="two wide field">
								<select class="ui dropdown mr5" id="creTerm" name="creTerm">
									<option value=""><spring:message code="common.term.info" /></option>
			                        <c:forEach var="item" items="${termList}">
										<option value="${item.codeCd}" <c:if test="${item.codeCd eq currentTerm}">selected</c:if>>${item.codeNm}</option>
			                    	</c:forEach>
								</select>			  
			              	</div>
							<div class="three wide field ">
								<label class="blind"></label>
								<div class="ui input">
									<input id="searchValue" type="text" placeholder="<spring:message code='user.message.search.input.crs.cd.user.no' />" class="w250" /><!-- 학수번호/과목명/교수명 입력 -->
								</div>
							</div>
						</div>
						<div class="button-area mt10 tc">
							<a href="javascript:void(0)" onclick="haksaInfoList();" class="ui blue button w100"><spring:message code="common.button.search" /></a><!-- 검색 -->
						</div>
					</div>	
					<!-- //검색영역 -->
					<div class="ui info message">
						<i class="info triangle icon"></i> <spring:message code="user.messgae.userinfo.search.thousand"/><!-- 검색은 최대 1000건 까지 가능합니다. -->&nbsp; (<spring:message code="common.page.total.not.connection.cnt" />:&nbsp;<span id="totalCnt">0</span>&nbsp;<spring:message code="common.page.total_count" />)
					</div>	
					<div class="ui bottom attached segment">
						<div class="footable_box type2 max-height-550">
							<table class="tBasic mt10" data-sorting="false" data-paging="false">
								<thead class="sticky top0">
									<tr>
										<th scope="col" data-type="number" class="num tc"><spring:message code="common.number.no"/></th> <!-- NO. -->
										<th scope="col" class="tc"><spring:message code="lesson.label.user.no"/></th><!-- 학번 -->
										<th scope="col" class="tc"><spring:message code="common.haksa.year" /><!-- 학년도 -->
										<th scope="col" class="tc"><spring:message code="exam.label.term" /><!-- 학기 -->
										<th scope="col" class="tc"><spring:message code="contents.label.crscd" /></th> <!-- 학수번호 -->
										<th scope="col" data-breakpoints="xs sm" class="tc"><spring:message code="common.label.decls.no"/></th> <!-- 분반 -->
										<th scope="col" class="tc"><spring:message code="common.label.register.course.yn"/></th><!-- 수강신청여부 -->
										<th scope="col" class="tc"><spring:message code="lesson.auditor.whether" /></th><!-- 청강여부 -->
										<th scope="col" class="tc"><spring:message code="common.registration.date" /></th><!-- 등록일자 -->
										<th scope="col" class="tc"><spring:message code="common.modified.date" /></th><!-- 수정일자 -->
									</tr>
								</thead>
								<tbody id="tableList">
								</tbody>
							</table>
							<div class="none tc pt10" id="resultNone">
								<span><spring:message code="common.content.not_found" /></span><!-- 등록된 내용이 없습니다. -->
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- //본문 content 부분 -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
	</div>
</body>
</html>