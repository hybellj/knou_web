<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>

<head>
	<meta charset="UTF-8">
	<meta name="title" content="">
	<meta http-equiv="pragma" content="no-cache" />
	<meta http-equiv="Cache-Control" content="No-Cache" />
	<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
	<title>sampleMain</title>

	<!-- <script src="https://code.jquery.com/jquery-3.2.1.min.js"></script> -->
	<script type="text/javascript">
		$(function(){
			//맨처음 학기제/ 기수제/ 공개 셀렉트 박스만 보여주기 위해서
			if("${empty creCrsVo.termType}"){
				//changeTerm();
			}
		});

		//전체
		 function changeCrsTypeCd(){
			var crsTypeCd =  $("#crsTypeCd option:selected").val();
			if("UNI" == crsTypeCd){
				$("#termType").parent().show();
				$("#termCd").parent().show();
				$("#crsOperTypeCd").parent().show();
				$("#searchKey").parent().show();
				$("#searchArea").show();
				//$("#crsYear").parent().hide();
				changeTerm();
			}else if("CO" == crsTypeCd){
				$("#termType").parent().hide();
				$("#termCd").parent().hide();
				$("#crsOperTypeCd").parent().hide();
				$("#searchKey").parent().show();
				$("#searchArea").show();
				//$("#crsYear").parent().show();
				onSearch(1);
			}else if("OPEN" == crsTypeCd){
				$("#termType").parent().hide();
				$("#termCd").parent().hide();
				$("#crsOperTypeCd").parent().hide();
				$("#searchKey").parent().show();
				$("#searchArea").show();
				//$("#crsYear").parent().hide();
				onSearch(1);
			}
		} 
		 
		 function changeTerm(obj){
			//과정 셀렉트 박스
			var crsTypeCdVal = $("#crsTypeCd option:selected").val();
			if(crsTypeCdVal == 'UNI'){
			    var termType =  $("#termType option:selected").val();
			    var temp = "";
			    var termArr= [];
			    var first ="";
			    var termStatusVal = "";
			    if(obj != undefined){
			  	  termStatusVal = obj.value;
			    }else{
			  	  //처음세팅
			  	  termStatusVal = "SERVICE";
			    }
			    
			    ajaxCall("/crs/termHome/selectListHomeTermStatus.do", {"termType" : termType, "termStatus" : termStatusVal}, function(data){
				  	if(data != null){
				  		$("#termCd option").remove();
				  	    for(var i = 0 in data){ 
					  	  termArr[i] = data[i];
					  	  first = termArr[0].termNm;
					  	  temp +="<option value='"+termArr[i].termCd+"'>"+termArr[i].termNm+"</option>";
					  	}
				  	    $("#termCd").append(temp);
				  		$("#ter mCd").parent().children("div.text").text(first);
			  	    }
				  	
				  	onSearch(1);
			    }, function(){});
			} else {
			 onSearch(1);
			}
		  }
		
		onSearch = function(curPage){
			 var crsTypeCd = $("#crsTypeCd option:selected").val();
			 var year = $("#crsYear option:selected").val();
			 var termNm = $("#termCd option:selected").text();
			 if(crsTypeCd == 'OPEN'){
				 year = "";
			 }
			 
			 var data = {};
			 
			 if(crsTypeCd == 'UNI'){
				 data = {
					 "pageIndex" : curPage
					,"listScale" : "10"// $("#listScale").val()
					,"searchValue" : $('#searchValue').val()
					,"crsTypeCd" : $("#crsTypeCd option:selected").val()
					,"termType" : $("#termType option:selected").val()
					,"termCd" : $("#termCd option:selected").val()
					,"termStatus" : $("#termStatus option:selected").val()
					,"searchKey" : $("#searchKey option:selected").val() 
				 }
			 }else{
				 data = {
					 "pageIndex" : curPage
					,"listScale" : "10"// $("#listScale").val()$("#listScale").val()
					,"searchValue" : $('#searchValue').val() 
					,"crsTypeCd" : $("#crsTypeCd option:selected").val()
					,"termStatus" : $("#termStatus option:selected").val()
					,"crsYear" : year
					,"searchKey" : $("#searchKey option:selected").val()
				 }
			 }
			ajaxCall("/crs/creCrsHome/Form/selectStdCreCrsList.do", data, function(data){
				console.log(data);
				
				var html = "";
				$("#tbodyId > tr").remove();
				
				if(data.returnList.length > 0){
					$.each(data.returnList, function(i, o){
						html += "<tr>";
						html += "<td>" + o.crsCreCd + "</td>";
						html += "<td>" + o.crsCreNm + "</td>";
						html += "<td>" + o.gubun + "</td>";
						html += "<td>" + o.crsTypeCd + "</td>";
						html += "<td>" + o.termType + "</td>";
						html += "<td>" + o.declsNo + "</td>";
						html += "<td>" + o.compDvCd + "</td>";
						html += "<td>" + o.credit + "</td>";
						html += "<td>" + o.crsOperTypeCd + "</td>";
						html += "<td>" + o.stdTotalCnt + "</td>";
						html += "<td>" + o.userNm + "</td>";
						html += "</tr>";
					});
				} else {
					html += "<tr>";
					html += "<td colspan='11'><spring:message code='filebox.common.empty' /></td>";
					html += "</tr>";
				}
				$("#tbodyId").html(html);
				
				 /* if(crsTypeCd == "UNI" || crsTypeCd == "OPEN"){
				 	$("#crsYear").parent().hide();
				 }else{
					$("#crsYear").parent().show();
				 } */
				 
				var params = {
					totalCount : data.pageInfo.totalRecordCount,
					listScale : 10,
					currentPageNo : data.pageInfo.currentPageNo,
					eventName : "onSearch"
				};
				gfn_renderPaging(params);
				 
			}, function(){});
		}
	</script>
</head>
<body>
	<div class="ui-wrap">
		<header class="header">
			<jsp:include page="/WEB-INF/jsp/common/frontGnb.jsp" />
		</header>

		<div class="container">
			<div class="lnb">
				<jsp:include page="/WEB-INF/jsp/common/frontLnb.jsp" />
			</div>
			
			<div>
			    <h2><spring:message code="common.label.enroll.course" /></h2><!-- 수강과목 -->
			</div>
			
			<div class="contents">
				<select class="ui dropdown mr5" id="termStatus" onchange="changeTerm(this)">
					<option value="SERVICE" <c:if test="${'SERVICE' eq creCrsVo.termStatus}">selected</c:if>><spring:message code="crs.common.lecture.running"/></option><!-- 운영중 과목 -->
					<option value="FINISH" <c:if test="${'FINISH' eq creCrsVo.termStatus}">selected</c:if>><spring:message code="crs.common.lecture.history"/></option><!-- 강의 이력 -->
				</select>
				<select class="ui dropdown mr5" id="crsTypeCd" onchange="changeCrsTypeCd(this)">
					<c:forEach items="${crsTypeList}" var="list">
						<option value="${list.codeCd}" <c:if test="${list.codeCd eq creCrsVo.crsTypeCd}">selected</c:if>><c:out value="${list.codeNm}"/></option>
					</c:forEach>
				</select>
				<select class="ui dropdown mr5" id="termType" onchange="changeTerm()">
					<c:forEach var="item" items="${termTypeList}" varStatus="status">
					<option value="${item.codeCd}">${item.codeNm}</option> 
					</c:forEach>
				</select>
				<select class="ui dropdown w200 mr5" id="termCd" onchange="list(1)"></select>
				<!-- 기수제 -->
				<select name="crsYear" id="crsYear" onchange="list(1)" class="ui compact dropdown mr5 ">
				<c:forEach items="${yearList}" var="year">
					<c:if test="${year == curYear}">
					<option value="${year}" selected="selected">${year}</option>
					</c:if>
					<c:if test="${year != curYear}">
					<option value="${year}">${year}</option>
					</c:if>
				</c:forEach>
				</select> 
				<select class="ui dropdown mr5" id="searchKey">
					<option value=""><spring:message code="forum.common.search.all" /></option>	<!-- 전체 -->
					<option value="crsCreNm"><spring:message code="common.label.crsauth.crsnm"/></option>	<!-- 과목명 -->
					<option value="crsCreCd"><spring:message code="common.label.crsauth.crscd"/></option>		<!-- 과목코드 -->
					<option value="usreNm"><spring:message code="common.label.lecture.form"/></option>	<!-- 교수명 --> 
				</select>
				<div class="search" id="searchArea">
					<input type="text" name="searchValue" id="searchValue" name="searchValue" value="" autocomplete="off">	<!-- 검색 -->
					<a href="javascript:onSearch(1)"><spring:message code="button.search" /></a>	
				</div>
				<div class="table">
					<table>
						<colgroup>
							<col />
							<col />
							<col />
							<col />
							<col />
							<col />
							<col />
							<col />
							<col />
							<col />
							<col />
						</colgroup>
						<thead>
							<tr>crsCreCd</tr>
							<tr>crsCreNm</tr>
							<tr>gubun</tr>
							<tr>crsTypeCd</tr>
							<tr>termType</tr>
							<tr>declsNo</tr>
							<tr>compDvCd</tr>
							<tr>credit</tr>
							<tr>crsOperTypeCd</tr>
							<tr>stdTotalCnt</tr>
							<tr>userNm</tr>
						</thead>
						<tbody id="tbodyId">
						</tbody>
					</table>
				</div>
				<div id="paging" class="paging">
	            </div>
			</div>
		</div>

		<footer class="footer">
			<jsp:include page="/WEB-INF/jsp/common/frontFooter.jsp" />
		</footer>
	</div>
</body>