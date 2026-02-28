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
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					bfrQuizListSelect(1);
				}
			});
		});

		/**
		 * 이전 퀴즈 목록 조회
		 * @param {Integer} pageIndex 		- 현재 페이지
		 * @param {String}  dgrsYr 			- 학사년도
		 * @param {String}  dgrsSmstrChrt 	- 학기
		 * @param {String}  sbjctId	 		- 과목아이디
		 * @param {String}  listScale 		- 페이징 목록 수
		 * @param {String}  searchValue 	- 검색어 ( 퀴즈명 )
		 * @param {String}  userId 			- 사용자아이디
		 * @returns {list} 퀴즈 목록
		 */
    	function bfrQuizListSelect(page) {
    		var url  = "/quiz/profAuthrtSbjctQuizListAjax.do";
    		var data = {
    			"pageIndex"   	: page,
    			"dgrsYr" 	  	: $("#dgrsYr").val(),
    			"dgrsSmstrChrt" : $("#dgrsSmstrChrt").val(),
    			"sbjctId" 		: $("#sbjctId").val(),
    			"listScale"   	: $("#listScale").val(),
    			"searchValue" 	: $("#searchValue").val(),
    			"userId"		: "${vo.userId}"
    		};

    		ajaxCall(url, data, function(data) {
    			if (data.result > 0) {
            		var returnList = data.returnList || [];
            		var html = "";

            		if(returnList.length > 0) {
            			returnList.forEach(function(v, i) {
							html += "<tr>";
							html += "	<td>" + v.lineNo + "</td>";
							html += "	<td>" + v.sbjctnm + "</td>";
							html += "	<td>" + v.dvclasNo + "<spring:message code='exam.label.decls' /></td>";/* 반 */
							html += "	<td>" + v.examGbnnm + "</td>";
							html += "	<td class='tl'>" + v.examTtl + "</td>";
							html += "	<td><a href='javascript:window.parent.quizCopy(\"" + v.examBscId + "\")' class='ui blue button roundBtntype2'><spring:message code='exam.button.select' />​</a></td>";/* 선택 */
							html += "</tr>";
            			});
            		}

            		$("#copyList").empty().html(html);
	    	    	$(".table").footable();
	    	    	if($("#listScale").val() != "0") {
	    	    		$("#paging").show();
		    	    	var params = {
			    			totalCount 	  : data.pageInfo.totalRecordCount,
			    			listScale 	  : data.pageInfo.pageSize,
			    			currentPageNo : data.pageInfo.currentPageNo,
			    			eventName 	  : "bfrQuizListSelect"
			    		};

			    		gfn_renderPaging(params);
	    	    	} else {
	    	    		$("#paging").hide();
	    	    	}
                } else {
                 	alert(data.message);
                }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
    		});
    	}

    	// 선택 학기로 과목 가져오기
    	function copyCreCrsList() {
    		var url  = "/crs/creCrsHome/listAuthCrsCreByTerm.do";
    		var data = {
    			"dgrsYr" 	 		: $("#dgrsYr").val(),
    			"dgrsSmstrChrt" 	: $("#dgrsSmstrChrt").val(),
    			"userId" 	 		: "${vo.userId}",
    			"searchMenu" 		: "selectYear"
    		};

    		ajaxCall(url, data, function(data) {
    			if (data.result > 0) {
            		var returnList = data.returnList || [];
            		var html = "";

            		if(returnList.length > 0) {
            			html += "<option value=' '><spring:message code='exam.common.search.all' /></option>";/* 과목 선택 */
            			returnList.forEach(function(v, i) {
            				html += `<option value="\${v.sbjctId}">\${v.sbjctnm} (\${v.dvclasNo}<spring:message code="exam.label.decls" />)</option>`;/* 반 */
            			});
            		}

            		$("#sbjctId").empty().html(html);
            		$("#sbjctId").dropdown("clear");
            		$("#sbjctId").trigger("change");
                } else {
                 	alert(data.message);
                }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
    		});
    	}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<p class="ui small error message">
                <i class="info circle icon"></i><spring:message code="exam.label.select.copy.info" /><!-- 선택 시 정보가 복사됩니다. -->
            </p>
            <div class="option-content mb10 mt20">
            	<select class="ui dropdown mr5" id="dgrsYr" onchange="copyCreCrsList()">
            		<option value=" " hidden><spring:message code="crs.label.open.year" /><!-- 개설년도 --></option>
            		<c:forEach var="item" items="${creYearList }">
            			<option value="${item.haksaYear }">${item.haksaYear }</option>
            		</c:forEach>
            	</select>
            	<select class="ui dropdown mr5" id="dgrsSmstrChrt" onchange="copyCreCrsList()">
            		<option value=" " hidden><spring:message code="crs.label.open.term" /><!-- 개설학기 --></option>
            		<c:forEach var="item" items="${smstrTycdList }">
            			<option value="${item.cd }">${item.cdnm }</option>
            		</c:forEach>
            	</select>
                <select class="ui dropdown mr5 w250" id="sbjctId" onchange="bfrQuizListSelect(1)">
                	<option value=""><spring:message code='exam.common.search.all' /></option><!-- 전체 -->
                </select>

                <div class="ui action input search-box mr5">
                    <input type="text" placeholder="<spring:message code='exam.label.quiz' /><spring:message code='exam.label.nm' /> <spring:message code='exam.label.input' />" id="searchValue"><!-- 퀴즈 --><!-- 명 --><!-- 입력 -->
                    <button class="ui black icon button" onclick="bfrQuizListSelect(1)"><i class="search icon"></i></button>
                </div>

                <div class="mla">
	                <select class="ui dropdown mr5 list-num" id="listScale" onchange="bfrQuizListSelect(1)">
	                    <option value="10">10</option>
	                    <option value="20">20</option>
	                    <option value="30">30</option>
	                    <option value="50">50</option>
	                    <option value="0"><spring:message code="exam.common.search.all" /><!-- 전체 --></option>
	                </select>
                </div>
            </div>

            <div class="ui form">
	            <table class="table type2" data-sorting="true" data-paging="false" data-empty="<spring:message code='exam.common.empty' />"><!-- 등록된 내용이 없습니다. -->
	            	<colgroup>
	            		<col width="7%">
	            		<col width="15%">
	            		<col width="10%">
	            		<col width="10%">
	            		<col width="*">
	            		<col width="10%">
	            	</colgroup>
					<thead>
						<tr>
							<th scope="col" class="num tc"><spring:message code="common.number.no" /><!-- NO. --></th>
							<th scope="col" class="tc"><spring:message code="crs.label.crecrs.nm" /><!-- 과목명 --></th>
							<th scope="col" class="tc"><spring:message code="crs.label.decls" /><!-- 분반 --></th>
							<th scope="col" class="tc"><spring:message code="exam.label.quiz" /><!-- 퀴즈 --> <spring:message code="exam.label.stare.type" /><!-- 구분 --></th>
							<th scope="col" class="tc"><spring:message code="exam.label.quiz" /><spring:message code="exam.label.nm" /></th><!-- 퀴즈 --><!-- 명 -->
							<th scope="col" class="tc"><spring:message code="exam.button.select" /></th><!-- 선택 -->
						</tr>
					</thead>
					<tbody id="copyList">
					</tbody>
				</table>
				<div id="paging" class="paging"></div>
            </div>

            <div class="bottom-content">
                <button class="ui black cancel button" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
