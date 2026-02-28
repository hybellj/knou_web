<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
$(document).ready(function(){
	listReview(1);
			
	$("#searchValue").on("keydown", function(e) {
		if(e.keyCode == 13) {
			listReview(1);
		}
	});

	// setDeptCdList('<c:out value="${orgId}" />');
});
	
	// 과정유형 선택
	function selectContentCrsType(obj) {
		if($(obj).hasClass("basic")){
			$(obj).removeClass("basic").addClass("active");
		}else{
			$(obj).removeClass("active").addClass("basic");
		}
		listReview(1);
	};
	
	// 학과 목록 세팅
	function setDeptCdList(orgId) {

		var url = "/user/userMgr/deptList.do";
		var data = {
			orgId: orgId
		};
		
		$.getJSON(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
				var html = '';
				
				html += '<option value="all"><spring:message code="std.label.select_dept" /></option>'; // 학과 선택
				
				returnList.forEach(function(v, i) {
					html += '<option value="' + v.deptCd + '">' + v.deptNm + '</option>';
				});
				
				$("#deptCd").empty();
				$("#deptCd").off("change");
				$("#deptCd").html(html);

				setTimeout(function() {
					$("#deptCd").dropdown("clear");
					$("#deptCd").dropdown("set value", "all");
					$("#deptCd").on("change", function() {
						listReview(1);
					});
					listReview(1);
				}, 0);
	    	} else {
	    		alert(data.message);
	    	}
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
		});
	};

	function listReview(page) {
		var url = "/menu/menuMgr/reviewList.do";
		
		var crsTypeCdList = [];
		$.each($("[data-crs-type-cd]"), function(){
			var crsTypeCd = $(this).data("crsTypeCd");
			
			if($(this).hasClass("active")) {
				crsTypeCdList.push(crsTypeCd);
			}
		});

		var paramData = {
			"pageIndex" 		: page
			, "listScale"  		: $("#listScale").val()
			, "creYear"			: $("#creYear").val()
			, "creTerm"			: $("#creTerm").val()
			, "termCd"			: $("#termCd").val()
			, "deptCd"			: ($("#deptCd").val() || "").replace("all", "")
			, "searchValue"	: $("#searchValue").val()
			, "uniCd"			: $("#uniCd").val()
		};

		if(crsTypeCdList.length > 0) {
			paramData.crsTypeCds = crsTypeCdList.join(",");
		}

		$("#reviewListBlcok").load(
			url, paramData, function () {}
		);
	};

	// 수강생 엑셀 다운로드
	function downExcel() {
		var excelGrid = {
		    colModel:[
	            {label:'<spring:message code="common.number.no" />', 	 name:'lineNo',  align:'right', 	width:'1000'},					// NO.
	            {label:'<spring:message code="review.label.crscre.dept" />', name:'deptNm',  align:'center',	width:'10000'}, 			// 개설학과
	            {label:'<spring:message code="review.label.crscd" />',    		 name:'crsCd',  align:'center',   width:'5000'}, 			// 학수번호
	            {label:'<spring:message code="review.label.crscrenm" />', 	 name:'crsCreNm',	align:'center',  width:'10000'}, 			// 과목명
	            {label:'<spring:message code="review.label.decls" />',  		 name:'declsNo', align:'center',   width:'1000'}, 			// 분반
	            {label:'<spring:message code="review.period.setting" />', 	 name:'reviewStatus', align:'center',  width:'10000'}
    		]
		};

		// 학기제, 기수제, 법정교육, 공개강좌
		var crsTypeCdList = [];
		$.each($("[data-crs-type-cd]"), function(){
			var crsTypeCd = $(this).data("crsTypeCd");
			
			if($(this).hasClass("active")) {
				crsTypeCdList.push(crsTypeCd);
			}
		});

		var url  = "/menu/menuMgr/downExcelReviewList.do";
		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "excelForm");
		form.attr("action", url);
		form.append($('<input/>', {type: 'hidden', name: 'orgId',    			value: $("#orgId").val()}));
		form.append($('<input/>', {type: 'hidden', name: 'crsTypeCdList',    value: crsTypeCdList}));
		form.append($('<input/>', {type: 'hidden', name: 'termCd',    			value: $("#termCd").val()}));
		form.append($('<input/>', {type: 'hidden', name: 'searchValue', 		value: $("#searchValue").val()}));
		form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   		value: JSON.stringify(excelGrid)}));
	
		form.appendTo("body");
		form.submit();
		
		$("form[name=excelForm]").remove();
	};
	
    /**
     *  복습기간  총 카운트 표시
     */
    function displayReviewTotoCnt(cnt) {
        $("#reviewCount").text("<spring:message code="common.page.total" /> " + cnt + "<spring:message code="common.page.total_count" />");//총//건
    }
</script>
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
            <div class="content" >
            	
				<!-- admin_location -->
                <%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
                <!-- //admin_location -->
        		
        		<div class="ui form">
        			<div class="layout2">
        			
		                <div id="info-item-box">
		                    <h2 class="page-title"><spring:message code="review.lecture.content.state" /></h2><!-- 복습기간 현황 -->
		                    <div class="button-area"></div>
		                    <div class="option-content mt20">
		                    	<div class="ui buttons">
			                    	<button class="ui blue button active" data-crs-type-cd="UNI" onclick="selectContentCrsType(this)"><spring:message code="common.button.uni" /></button><!-- 학기제 -->
			                    	<button class="ui basic blue button" data-crs-type-cd="CO" onclick="selectContentCrsType(this)"><spring:message code="common.button.co" /></button><!-- 기수제 -->
			                    	<button class="ui basic blue button" data-crs-type-cd="LEGAL" onclick="selectContentCrsType(this)"><spring:message code="common.button.legal" /></button><!-- 법정교육 -->
			                    	<button class="ui basic blue button" data-crs-type-cd="OPEN" onclick="selectContentCrsType(this)"><spring:message code="common.button.open" /></button><!-- 공개강좌 -->
		                    	</div>
		                    </div>

							<!-- 검색조건 -->
		                    <div class="option-content mt10">

								<!-- 개설년도 -->
								<%-- <select class="ui dropdown mr5" id="creYear" onchange="listReview(1)">
		                    		<option value=""><spring:message code="crs.label.open.year" /></option>
		                    		<c:forEach var="item" begin="${year - 2}" end="${year + 2}" step="1">
										<option value="${item}" ${item eq year ? 'selected' : ''}>${item}</option>
									</c:forEach>
		                    	</select> --%>
		                    	
		                    	<!-- 개설학기 -->
						        <%-- <select class="ui dropdown mr5" id="creTerm" onchange="listReview(1)">
		                    		<c:forEach var="list" items="${termList}">
										<option value="${list.codeCd}" ${list.codeCd eq 1 ? 'selected' : ''}>${list.codeNm}</option>
									</c:forEach>
		                    	</select> --%>

								<!-- 학기목록 -->
								<select class="ui dropdown mr5 w300" id="termCd" onchange="listReview(1);">
									<%-- <option value=""><spring:message code="sys.label.select.haksa.term" /></option> --%>
									<c:forEach var="item2" items="${creTermList}" varStatus="status">
										<option value="${item2.termCd}" <c:if test="${vo.termCd eq item2.termCd}">selected</c:if>>${item2.termNm}</option>
									</c:forEach>
								</select>

								<!-- 대학구분 -->
			                    <%-- 
			                    <c:if test="${orgId eq 'ORG0000001'}">
			                    	<select class="ui dropdown mr5 w300" id="orgId" onchange="listReview(1); setDeptCdList(this.value);">
			                    		<option value=""><spring:message code="std.label.uni_type" /></option>
		                    			<c:forEach var="list" items="${orgInfoList}" varStatus="status">
		                    					<option value="${list.orgId}" <c:if test="${status.index eq 0}">selected</c:if> >${list.orgNm}</option>
										</c:forEach>
			                    	</select>
			                    </c:if> 
			                    --%>
			                    	
			                	<select class="ui dropdown mr5" id="uniCd" onchange="listReview(1);">
									<option value=""><spring:message code="exam.label.org.type" /></option>
									<option value="C"><spring:message code="common.knou.label.uni.c" /></option>
									<option value="G"><spring:message code="common.knou.label.uni.g" /></option>
								</select>

								<!-- 학과 선택 -->
						        <%-- 
						        <select class="ui dropdown mr5" id="deptCd"></select>
						        <select class="ui dropdown" id="deptCd" onchange="listReview(1)">
		                    		<option value="all"><spring:message code="user.title.userdept.select" /></option>
		                    		<c:forEach var="item" items="${deptCdList }">
		                    			<option value="${item.deptCd }">${item.deptNm }</option>
		                    		</c:forEach>
	                    		</select> 
	                    		--%>

								<div class="ui action input search-box">
									<input id="searchValue" type="text" placeholder="<spring:message code="review.label.crscrenm" />" value="${param.searchValue}" /><!-- 과목명 -->
									<button class="ui icon button" type="button" onclick="listReview(1)">
										<i class="search icon"></i>
									</button>
								</div>

								<div class="mla">
									<select class="ui dropdown mr5 list-num" id="listScale" onchange="listReview(1)">
									    <option value="10">10</option>
									    <option value="20">20</option>
									    <option value="50">50</option>
									    <option value="100">100</option>
									</select>
									<a href="javascript:void(0)" onclick="downExcel()" class="ui basic button"><spring:message code="common.button.excel_down" /></a><!-- 엑셀 다운로드 -->
								</div>
		                    </div>
		                </div>

		                <div class="row">
		                	<div class="col">
		                		<div class="option-content mb20">
			                		<h3 class="graduSch"><spring:message code="review.lecture.list" /></h3><!-- 복습기간 목록 -->
			                		<div class="mla">
			                			[&nbsp;<span id="reviewCount">0</span>&nbsp;]
			                		</div>
		                		</div>
		                		<div id="reviewListBlcok"></div>
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
