<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<script type="text/javascript">
	$(document).ready(function() {
		$("#searchValue").on("keydown", function(e) {
			if(e.keyCode == 13) {
				listPaging(1);
			}
		});
		
		listPaging(1);
	});
	
	// 수강생 조회
	function listPaging(pageIndex) {
		var url = "/std/stdMgr/listPagingLearnStopRiskIndex.do";
		var data = {
			  pubYear 		: $("#creYear").val()
			, pubTerm 		: ($("#creTerm").val() || "").replace("ALL", "")
			, searchValue 	: $("#searchValue").val()
			, listScale		: $("#listScale").val()
			, pageIndex		: pageIndex
		};
		
		console.log(data)

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				var returnList = data.returnList || [];
				var html = '';
				
				returnList.forEach(function(v, i) {
					var creTerm;
					
					if(v.creTerm == "10") {
						creTerm = "1";
					} else if(v.creTerm == "20") {
						creTerm = "2";
					} else {
						creTerm = v.creTerm
					}
					
					var pubTerm;
					
					if(v.pubTerm == "10") {
						pubTerm = "1";
					} else if(v.pubTerm == "20") {
						pubTerm = "2";
					} else {
						pubTerm = v.pubTerm
					}
					
					html += '<tr>';
					html += '	<td class="tc">' + v.lineNo + '</td>';
					html += '	<td class="tc">' + v.userId + '</td>';
					html += '	<td class="">' + v.userNm + '</td>';
					html += '	<td class="">' + v.deptNm + '</td>';
					html += '	<td class="tc">' + v.creYear + '-' + creTerm + '</td>';
					html += '	<td class="tc">' + v.pubYear + '-' + pubTerm + '</td>';
					html += '	<td class="tc">' + v.riskIndex + '%</td>';
					html += '	<td class="tc">' + v.riskGrade + '</td>';
					html += '</tr>';
				});

				$("#riskIndexList").empty().html(html);
				$("#riskIndexTable").footable();
				$("#totalCntText").text(data.pageInfo.totalRecordCount);
				
				var params = {
					totalCount : data.pageInfo.totalRecordCount,
					listScale : data.pageInfo.recordCountPerPage,
					currentPageNo : data.pageInfo.currentPageNo,
					eventName : "listPaging"
				};

				gfn_renderPaging(params);
			} else {
				alert(data.message);
				$("#totalCntText").text("0");
			}
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			$("#totalCntText").text("0");
		});
	}
	
	// 엑셀 업로드
	function uploadExcel() {
		$("#excelUploadForm > input[name='haksaYear']").val('<c:out value="${vo.haksaYear}" />');
		$("#excelUploadForm > input[name='haksaTerm']").val('<c:out value="${vo.haksaTerm}" />');
		$("#excelUploadForm").attr("target", "excelUploadPopIfm");
        $("#excelUploadForm").attr("action", "/std/stdMgr/learnStopRiskIndexUploadPop.do");
        $("#excelUploadForm").submit();
        $('#excelUploadModal').modal('show');
	}
</script>
<body>
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>

        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>

        <div id="container">
            <!-- 본문 content 부분 -->
            <div class="content">
                <div id="info-item-box">
                	<h2 class="page-title flex-item">
					    <spring:message code='std.label.risk_learn' /><!-- 학업중단 위험지수 -->
					    <!-- <div class="ui breadcrumb small">
					        <small class="section"></small>
					    </div> -->
					</h2>
				</div>
				<div class="ui divider mt0"></div>
				<div class="ui form">
					<div class="ui segment searchArea">
						<select class="ui dropdown mr5" id="creYear">
	                   		<c:forEach var="item" begin="${termVO.haksaYear - 2}" end="${termVO.haksaYear + 2}" step="1">
								<option value="${item}" ${item eq termVO.haksaYear ? 'selected' : ''}><c:out value="${item}" /></option>
							</c:forEach>
	                   	</select>
	                   	<select class="ui dropdown mr5" id="creTerm">
	                   		<option value=""><spring:message code="common.term" /><!-- 학기 --></option>
	                   		<option value="ALL"><spring:message code="common.all" /><!-- 전체 --></option>
							<c:forEach var="item" items="${haksaTermList}">
								<c:if test="${item.codeCd eq '10' or item.codeCd eq '20'}">
									<option value="${item.codeCd}" ${item.codeCd eq termVO.haksaTerm ? 'selected' : ''}><c:out value="${item.codeNm}" /></option>
								</c:if>
							</c:forEach>
	                   	</select>
						<div class="ui input">
							<input id="searchValue" type="text" placeholder="<spring:message code="std.common.placeholder3" />" value="" class="w250" />
						</div>
						<div class="button-area mt10 tc">
							<a href="javascript:void(0)" class="ui blue button w100" onclick="listPaging(1)"><spring:message code="exam.button.search" /><!-- 검색 --></a>
						</div>
					</div>
					<div class="option-content gap4">
						<h3 class="sec_head"><spring:message code='std.label.risk_learn' /><!-- 학업중단 위험지수 --></h3>
						<span class="pl10">[ <spring:message code="common.page.total.cnt" /><!-- 총 건수 --> : <label id="totalCntText">0</label> ]</span>
						<div class="mla">
	   						<a class="ui green button" href="javascript:uploadExcel()"><spring:message code="std.button.excel.upload" /><!-- 엑셀 업로드 --></a>
	   						<select class="ui dropdown mr5 list-num" id="listScale" onchange="listPaging(1)">
						        <option value="10">10</option>
						        <option value="20">20</option>
						        <option value="50">50</option>
						        <option value="100">100</option>
						    </select>
	   					</div>
					</div>
					<table class="tBasic" data-sorting="true" data-paging="false" data-empty="<spring:message code='common.content.not_found' />" id="riskIndexTable"><!-- 등록된 내용이 없습니다. -->
       					<thead>
       						<tr>
       							<th class=""><spring:message code="common.number.no"/></th><!-- NO -->
       							<th class="" data-sortable="true"><spring:message code="std.label.user_id" /></th><!-- 학번 -->
       							<th class="" data-sortable="true"><spring:message code="std.label.name" /></th><!-- 이름 -->
       							<th class="" data-sortable="true"><spring:message code="std.label.dept" /></th><!-- 학과 -->
       							<th class="" data-sortable="false"><spring:message code="std.label.learn_year" /><br />-<spring:message code="common.term" /></th><!-- 학습년도 -->
       							<th class="" data-sortable="false"><spring:message code="std.label.pub_yaer" /><br />-<spring:message code="common.term" /></th><!-- 게시년도 -->
       							<th class="" data-sortable="true"><spring:message code="std.label.risk_index" /></th><!-- 위험지수 -->
       							<th class="" data-sortable="true"><spring:message code="std.label.risk_grade" /></th><!-- 위험등급 -->
       						</tr>
		        		</thead>
		        		<tbody id="riskIndexList">
		        		</tbody>
		        	</table>
		        	<div id="paging" class="paging mt10"></div>
	  				<!-- //콘텐츠 영역 -->
				</div>
				<!-- //ui form -->
			</div>
			<!-- //본문 content 부분 -->
        </div>
        <!-- footer 영역 부분 -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
    
    <!-- 엑셀 업로드 팝업 --> 
    <form id="excelUploadForm" method="POST">
    	<input type="hidden" hidden="haksaYear" value="" />
    	<input type="hidden" hidden="haksaTerm" value="" />
	</form>
	<div class="modal fade" id="excelUploadModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="std.button.excel.upload" />" aria-hidden="false">
	    <div class="modal-dialog modal-lg" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='common.button.close' />"><!-- 닫기 -->
	                    <span aria-hidden="true">&times;</span>
	                </button>
	                <h4 class="modal-title"><spring:message code="std.button.excel.upload" /></h4><!-- 엑셀 업로드 -->
	            </div>
	            <div class="modal-body">
	                <iframe src="" id="excelUploadPopIfm" name="excelUploadPopIfm" width="100%" scrolling="no"></iframe>
	            </div>
	        </div>
	    </div>
	</div>
	<script>
	    $('iframe').iFrameResize();
	    window.closeModal = function() {
	        $('.modal').modal('hide');
	    };
	</script>
</body>
</html>