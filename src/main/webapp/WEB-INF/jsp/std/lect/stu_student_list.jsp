<%@ page import="knou.lms.common.web.CommonController"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<script type="text/javascript">
	$(document).ready(function() {
		$(document).ready(function() {
			$("#searchValue").on("keydown", function(e) {
				if(e.keyCode == 13) {
					list();
				}
			});
		});
		
		// 수강생 조회
		list();
	});
	
	// 수강생 조회
	function list() {
		var searchValue = $("#searchValue").val();

		if(searchValue.length > 0) {
			// 숫자만 입력한경우 - 5자이상 입력
			var onlyNumberRegExp = /^[0-9]+$/;
			
			if(onlyNumberRegExp.test(searchValue) && searchValue.length < 5) {
				alert('<spring:message code="std.alert.enter.number5" />'); // 숫자는 5자리이상 입력하세요.
				return;
			} else if (searchValue.length < 2) {
				alert('<spring:message code="std.alert.enter.word2" />'); // 검색어를 2자리이상 입력하세요.
				return;
			}
		}

		var url = "/std/stdLect/listStudent.do";
		var data = {
			crsCreCd : '<c:out value="${crsCreCd}" />',
			searchValue : $("#searchValue").val(),
			//searchKey : $("#searchKey").val().trim()
		};

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				var returnList = data.returnList || [];
				var html = '';

				returnList.forEach(function(v, i) {
					//var lineNo = returnList.length - v.lineNo + 1;
					var lineNo = parseInt(v.lineNo);
					var userId = v.userId.substring(0,5) + "***" + v.userId.substring(8);

					html += '<tr>';
					html += '	<td class="tc">' + lineNo + '</td>';
					html += '	<td class="word_break_none">' + (v.deptNm || '') + '</td>';
					html += '	<td class="tc word_break_none">' + userId + '</td>';
					html += '	<td class="tc">' + (v.hy || '-') + '</td>';
					html += '	<td class="tc word_break_none">' + v.userNm + '</td>';
					/*
					html += '	<td class="tc">' + (v.auditYn == 'Y' ? '<spring:message code="std.label.auditor" />' : '<spring:message code="std.label.student" />') + '</td>'; // 청강생 : 학생
					html += '	<td class="tc">' + v.entrYy + '</td>';
					html += '	<td class="tc">' + v.readmiYy + '</td>';
					html += '	<td class="tc">' + v.entrHy + '</td>';
					html += '	<td class="tc">' + v.entrGbnNm + '</td>';
					html += '	<td class="tc">-</td>';
					*/
					html += '</tr>';
				});

				$("#studentList").empty().html(html);
				$("#studentListTable").footable();
				$("#studentListTable").find(".ui.checkbox").checkbox();

				$("#totalCntText").text(returnList.length);
			} else {
				alert(data.message);
				$("#totalCntText").text("0");
			}
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			$("#totalCntText").text("0");
		});
	}
	
</script>
<body class="<%=SessionInfo.getThemeMode(request)%>">
	<div id="wrap" class="pusher">
		<%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>
		
		<div id="container">
			 <!-- class_top 인클루드  -->
        	<%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>
			
			<!-- 본문 content 부분 -->
			<div class="content stu_section">
            	<%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
		        
		        <div class="ui form">
		        	<div class="layout2">
		        		<!-- 타이틀 -->
						<div id="info-item-box">
							<script>
							$(document).ready(function () {
								// set location
								setLocationBar('<spring:message code="std.label.learn_info" />');
							});
							</script>
						
		                    <h2 class="page-title flex-item flex-wrap gap4 columngap16">
		                    	<spring:message code="std.label.learner_info" /><!-- 수강생정보 -->
		                    </h2>
		                    <div class="button-area">
		                    </div>
		                </div>
		                
		                <!-- 영역1 -->
                        <div class="row">
                            <div class="col">
                            	<!-- 검색조건 -->
								<div class="option-content mb10">
									<%-- 
									<select class="ui dropdown mr5" id="searchKey" onchange="list()">
										<option value=" "><spring:message code="common.all" /><!-- 전체 --></option>
										<option value="normal"><spring:message code="std.label.learner" /><!-- 수강생 --></option>
										<option value="disablilityY"><spring:message code="std.label.dis_studend" /><!-- 장애학생 --></option>
										<option value="auditY"><spring:message code="std.label.auditor" /><!-- 청강생 --></option>
							        </select>
							         --%>
									<div class="ui action input search-box">
										<label for="searchValue" style="display: none"><h4><spring:message code="std.common.placeholder" /></h4></label>
										<input id="searchValue" type="text" placeholder="<spring:message code="std.common.placeholder" />" value="${param.searchValue}" />
										<button class="ui icon button" type="button" onclick="list()">
											<i class="search icon"></i>
										</button>
									</div>
									<h3 class="ml5">(<spring:message code="std.label.total_cnt" /><!-- 총 -->&nbsp;:&nbsp;<span id="totalCntText">0</span><spring:message code="message.person" /><!-- 명 -->)</h3>
									<div class="select_area">
									</div>
								</div>
                            	
                           		<table id="studentListTable" class="table type2" data-sorting="true" data-paging="false" data-empty="<spring:message code="common.content.not_found" />">
									<caption class="hide"><spring:message code="std.label.learner_info" /></caption>
									<thead>
										<tr>
											<th scope="col" data-sortable="false" data-type="number" class="num tc"><spring:message code="main.common.number.no" /><!-- NO --></th>
											<th scope="col" data-breakpoints="xs" class="tc"><spring:message code="std.label.dept" /><!-- 학과 --></th>
											<th scope="col" class="tc"><spring:message code="std.label.user_id" /><!-- 학번 --></th>
											<th scope="col" class="tc"><spring:message code="std.label.hy" /><!-- 학년 --></th>
											<th scope="col" class="tc"><spring:message code="std.label.name" /><!-- 이름 --></th>
											<%-- 
											<th scope="col" data-sortable="false" data-breakpoints="xs" class="tc"><spring:message code="std.label.type" /><!-- 구분 --></th>
											<th scope="col" class="tc"><spring:message code="std.label.enter.year" /><!-- 입학년도 --></th>
											<th scope="col" class="tc"><spring:message code="std.label.readmi.year" /><!-- 재입학년도 --></th>
											<th scope="col" class="tc"><spring:message code="std.label.enter.hy" /><!-- 입학학년 --></th>
											<th scope="col" class="tc"><spring:message code="std.label.enter.gbn" /><!-- 입학구분 --></th>
											<th scope="col" data-sortable="false" data-breakpoints="xs" class="tc"><spring:message code="std.label.risk_learn" /><!-- 학업중단 위험지수 --></th>
											--%>
										</tr>
									</thead>
									<tbody id="studentList">
									</tbody>
								</table>
                            	
                            </div><!-- //col -->
                        </div><!-- //row -->
                        
		        	</div><!-- //layout2 -->
		        </div><!-- //ui form -->
			</div><!-- //content stu_section -->
			
			<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
		</div><!-- //container -->
				
	</div><!-- //wrap -->
</body>