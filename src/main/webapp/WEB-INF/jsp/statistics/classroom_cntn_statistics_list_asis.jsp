<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
		});
		
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
			<!-- 본문 content 부분 -->
			<div class="content">
				<div id="info-item-box">
                	<h2 class="page-title flex-item">
					   	 수강통계
					    <div class="ui breadcrumb small">
					        <small class="section">강의실 활동 기록</small>
					    </div>
					</h2>
				</div>
				<div class="ui divider mt0"></div>
					<!-- ui form -->
					<div class="ui form">
						<div class="option-content gap4">
							<div class="ui pointing secondary tabmenu menu">
								<a class="item pt0 active" data-tab="1" onclick="">강의실 접속 기록</a>
							</div>
						</div>
						<!-- 탭 콘텐츠 -->
						<div class="ui tab active" data-tab="1">
							<div class="ui segment searchArea">
								<!-- 학기구분 -->
								<select class="ui dropdown" id="haksaYear2" onchange="changeTerm()">
			                   		<c:forEach var="item" begin="${termVO.haksaYear - 4}" end="${termVO.haksaYear + 2}" step="1">
										<option value="${item}" ${item eq termVO.haksaYear ? 'selected' : ''}><c:out value="${item}" /></option>
									</c:forEach>
			                   	</select>
			                   	<select class="ui dropdown" id="haksaTerm2" onchange="changeTerm()">
			                   		<option value=""><spring:message code="common.term" /><!-- 학기 --></option>
									<c:forEach var="item" items="${haksaTermList}">
										<c:if test="${item.codeCd eq '10' or item.codeCd eq '20'}">
											<c:set var="haksaTerm" value="${termVO.haksaTerm}" />
											<c:if test="${termVO.haksaTerm eq '11'}">
												<c:set var="haksaTerm" value="10" />
											</c:if>
											<c:if test="${termVO.haksaTerm eq '21'}">
												<c:set var="haksaTerm" value="20" />
											</c:if>
											<option value="${item.codeCd}" ${item.codeCd eq haksaTerm ? 'selected' : ''}><c:out value="${item.codeNm}" /></option>
										</c:if>
									</c:forEach>
			                   	</select>
			                   	<!-- 대학구분 -->
	                            <select class="ui dropdown" id="uniCd2" onchange="changeUniCd(this.value)">
	                    			<option value=""><spring:message code="common.label.uni.type" /></option><!-- 대학구분 -->
	                    			<option value="ALL"><spring:message code="common.all" /></option><!-- 전체 -->
	                    			<option value="C"><spring:message code="common.label.uni.college" /><!-- 대학교 -->
	                    			<option value="G"><spring:message code="common.label.uni.graduate" /></option><!-- 대학원 -->
	                    		</select>
                        		<!-- 학과 선택 -->
						  		<select id="deptCd2" class="ui dropdown w250" onchange="changeDeptCd(this.value)">
									<option value=""><spring:message code="user.title.userdept.select" /></option>
									<option value="ALL"><spring:message code="common.all" /><!-- 전체 --></option>
                            	</select>
                            	<!-- 과목 선택 -->
                            	<select id="crsCreCd2" class="ui dropdown w250">
		                    		<option value=""><spring:message code="common.subject" /><!-- 과목 --> <spring:message code="common.select" /><!-- 선택 --></option>
		                    	</select>
								<div class="ui input w250">
									<input id="searchValue2" type="text" placeholder="<spring:message code="contents.label.crscrenm" />/<spring:message code="common.label.prof.nm" />/<spring:message code="contents.label.crscd" />" />
							    </div>
							    <div class="button-area mt10 tc">
									<a href="javascript:void(0)" class="ui blue button w100" onclick="listTab2(1)"><spring:message code="exam.button.search" /><!-- 검색 --></a>
								</div>
							</div>
							<div class="option-content gap4">
								<h3 class="sec_head" id="title2"></h3>
	   							<span class="pl10">[ <spring:message code="common.page.total.cnt" /><!-- 총 건수 --> : <label id="totalCntText2">0</label> ]</span>
		       					<div class="mla">
		       						<a class="ui green button" href="javascript:downExcel2()"><spring:message code="exam.button.excel.down" /><!-- 엑셀 다운로드 --></a>
		       						<select class="ui dropdown list-num" id="listScale2" onchange="listTab2(1)">
							            <option value="10">10</option>
							            <option value="20">20</option>
							            <option value="50">50</option>
							            <option value="100">100</option>
							        </select>
		       					</div>
							</div>
							<div class="footable_box type2 max-height-550">
								<table class="tBasic" data-sorting="false" data-paging="false" data-empty="<spring:message code='common.nodata.msg' />" id="table2"><!-- 등록된 내용이 없습니다. -->
									<thead class="sticky top0">
										<tr>
											<th class="tc p_w5"><spring:message code="common.number.no"/></th><!-- NO -->
											<th class="tc p_w10"><spring:message code="common.label.student.number" /><!-- 학번 --></th>
											<th class="tc p_w10"><spring:message code="common.name" /><!-- 이름 --></th>
											<th class="tc p_w10">학과</th>
											<th class="tc p_w5"><spring:message code="common.crs.cd" /><!-- 학수번호 --></th>
											<th class="tc p_w10">과목</th>
											<th class="tc p_w5">분반</th>
											<th class="tc p_w10">디바이스</th>
											<th class="tc p_w10">접속일시</th>
											<th class="tc p_w10">종료일시</th>
											<th class="tc p_w10">접속시간(초)</th>
										</tr>
									</thead>
									<tbody id="list2">
									</tbody>
								</table>
								<div class="none tc pt10" id="tableResultNone2" style="display: none;">
									<span><spring:message code="common.nodata.msg"/></span><!-- 등록된 내용이 없습니다. -->
								</div>
							</div>
							<div id="paging2" class="paging mt10"></div>
						</div>
						<script> 
                            //초기화 방법 1__일반적인 형식
                            $('.tabmenu.menu .item').tab(); 

                            //초기화 방법 2__탭을 선택해 초기화 할 경우
                            //$('.tabmenu.menu .item').tab('change tab', 'tabcont2'); 
                        </script>
					</div>
                   <!-- //ui form -->
			</div>
			<!-- //본문 content 부분 -->
		</div>
		<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
</body>
</html>