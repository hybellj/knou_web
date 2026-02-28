<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
$(document).ready(function() {
    $("#searchValue").on("keyup",function(key){
        if(key.keyCode==13) {
        	 crsList(1);
        }
    });
    crsList(1);
});

<%-- 과정 목록 조회 --%>
function crsList(page) {
	
	var crsNm = $('#searchValue').val();
	var crsTypeCd = $('#crsTypeCd').val();
	var crsOperTypeCd = $("#crsOperTypeCd").val();
	var listScale = $("#listScale option:selected").val();
	var searchValue = $('#searchValue').val();
	var useYn = "";
	
	if($("#chkUse").is(":checked")) {
		useYn = "Y";
	} else {
		useYn = "";
	}

	var crsTypeCdList = [];
	$.each($("[data-crs-type-cd]"), function(){
		var crsTypeCd = $(this).data("crsTypeCd");
		
		if($(this).hasClass("active")) {
			crsTypeCdList.push(crsTypeCd);
		}
	});

	showLoading();

	var url  = "/crs/crsMgr/crsList.do";
	var data = {
	  	"pageIndex" : page
		, "crsNm":crsNm
		, "crsTypeCd":crsTypeCd
		, "crsOperTypeCd":crsOperTypeCd
		, "useYn":useYn
		, "curPage":page
		, "listScale":listScale
		, "searchValue":searchValue
	};
	
	if(crsTypeCdList.length > 0) {
		data.crsTypeCds = crsTypeCdList.join(",");
	}
	
	$("#crsList").load(url, data, function (){
		hideLoading();
	});
}

<%-- 엑셀 다운로드 --%>
function listExcel() {
	
	var crsNm = $('#searchValue').val();
	var crsTypeCd = $('#crsTypeCd').val();
	var crsTypeNm = $("#crsTypeCd option:selected").val() == "ALL" ? "ALL" : $("#crsTypeCd option:selected").text(); 
	var searchValue = $('#searchValue').val();
	var useYn = "";
	
	if($("#chkUse").is(":checked")) {
		useYn = "Y";
	} else {
		useYn = "";
	}
		
	var excelGrid = {
	    colModel:[
	        {label:'<spring:message code="common.number.no"/>',   		name:'lineNo', align:'center', width:'1000'}, <%-- No. --%>
	        {label:'<spring:message code="crs.label.crs.category"/>',   		name:'crsTypeNm', align:'center', width:'3000'}, <%-- 과목분류--%>
	        {label:'<spring:message code="crs.title.education.method"/>', name:'crsOperTypeNm', align:'center', width:'3000'}, <%-- 강의형태 --%>
	        {label:'<spring:message code="crs.crsnm"/>',   						name:'crsNm', align:'left',   width:'8000'}, <%-- 과목명 --%>
	        {label:'<spring:message code="contents.label.crscd" />',   		name:'crsCd', align:'left',   width:'8000'}, <%-- 학수번호 --%>
	        {label:'<spring:message code="crs.course.cnt"/>',   				name:'creCrsCnt', align:'right',   width:'8000'}, <%-- 개설 과목 수 --%>
	        {label:'<spring:message code="common.use.yn"/>', 				name:'useYn', align:'center',  width:'4000', codes:{Y :'<spring:message code="common.use"/>',N:'<spring:message code="button.useyn_n"/>'}}, <%-- 사용여부, 사용, 사용안함 --%>
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
	
	var excelForm = $('<form></form>');
	excelForm.attr("name","excelForm");
	excelForm.attr("action","/crs/crsMgr/crsListExcel.do");
	excelForm.append($('<input/>', {type: 'hidden', name: 'crsNm', value: crsNm }));
	excelForm.append($('<input/>', {type: 'hidden', name: 'crsTypeCd', value: crsTypeCd }));
	excelForm.append($('<input/>', {type: 'hidden', name: 'crsTypeNm', value: crsTypeNm }));
	excelForm.append($('<input/>', {type: 'hidden', name: 'crsTypeCdList', value: crsTypeCdList}));
	excelForm.append($('<input/>', {type: 'hidden', name: 'useYn', value: useYn }));
	excelForm.append($('<input/>', {type: 'hidden', name: 'searchValue', value: searchValue }));
	excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', value:JSON.stringify(excelGrid)}));

	excelForm.appendTo('body');
	excelForm.submit();	  
}

// 과정유형 선택
function selectContentCrsType(obj) {
	if($(obj).hasClass("basic")){
		$(obj).removeClass("basic").addClass("active");
	} else {
		$(obj).removeClass("active").addClass("basic");
	}
	crsList(1);
}
</script>

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
	
	            <!-- admin_location -->
	            <%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
	            <!-- //admin_location -->
	            
					<div id="info-item-box">
						<h2 class="page-title"><spring:message code="crs.lecture.management"/></h2> <%-- 과목 관리 --%>
						<div class="button-area">
							<a href="javascript:listExcel()" class="btn"><spring:message code="button.download.excel"/></a> <%-- 엑셀다운로드 --%> 
							<a href="/crs/crsMgr/Form/crsWriteForm.do" class="btn btn-primary"><spring:message code="common.subject"/><spring:message code="button.write"/></a> <%-- 과목등록 --%>
						</div>
					</div>
			
					<div class="ui form">
					
						<div class="option-content">
						
							<div class="option-content mt20">
		                    	<div class="ui buttons">
			                    	<button class="ui blue button active" data-crs-type-cd="UNI" onclick="selectContentCrsType(this)"><spring:message code="common.button.uni" /><!-- 학기제 --></button>
			                    	<button class="ui basic blue button" data-crs-type-cd="CO" onclick="selectContentCrsType(this)"><spring:message code="common.button.co" /><!-- 기수제 --></button>
			                    	<button class="ui basic blue button" data-crs-type-cd="LEGAL" onclick="selectContentCrsType(this)"><spring:message code="common.button.legal" /><!-- 법정교육 --></button>
			                    	<button class="ui basic blue button" data-crs-type-cd="OPEN" onclick="selectContentCrsType(this)"><spring:message code="common.button.open" /><!-- 공개강좌 --></button>
		                    	</div>
		                    </div>
		                    
						    <%-- <select class="ui dropdown mr5" id="crsTypeCd" onchange="crsList(1)">
						        <option value="ALL"><spring:message code="crs.label.crs.category"/></option> 과목분류
								<c:forEach items="${crsTypeList}" var="list">
									<option value="${list.codeCd}" >
										<c:out value="${list.codeNm}"/> 
									</option>
								</c:forEach>
							</select> 
							--%>
							
						    <%-- 
						    <select class="ui dropdown mr5" id="crsOperTypeCd" onchange="crsList(1)">
						        <option value="ALL"><spring:message code="crs.title.education.method"/></option> 강의형태
								<c:forEach items="${learningTypeList}" var="list">
									<option value="${list.codeCd}" >
										<c:out value="${list.codeNm}"/> 
									</option>
								</c:forEach>
							</select>
							--%>
							
							<div class="ui action input search-box">
								<input type="text" placeholder="<spring:message code="crs.crsnm"/>" name="searchValue" id="searchValue"> <%-- 검색 --%>
								<a class="ui icon button" onclick="crsList(1)">
									<i class="search icon"></i>
								</a>
							</div>

							<div class="button-area">
								<select class="ui dropdown list-num" id="listScale" onchange="crsList(1)">
									<option value="10">10</option>
									<option value="20">20</option>
									<option value="50">50</option>
									<option value="100">100</option>
									<option value="300">300</option>
									<option value="500">500</option>
									<option value="1000">1000</option>
								</select>
							</div>
						</div>
						<div id="crsList"></div>
					</div>
			</div>
	    </div>
	    <!-- //본문 content 부분 -->
	    <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
	</div>
</body>
</html>