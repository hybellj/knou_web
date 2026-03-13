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
					bfrSrvyListSelect(1);
				}
			});
		});

		/**
		 * 이전설문목록조회
		 * @param {Integer} pageIndex 		- 현재 페이지
		 * @param {String}  smstrChrtId 	- 학사년도/학기
		 * @param {String}  sbjctId	 		- 과목아이디
		 * @param {String}  listScale 		- 페이징 목록 수
		 * @param {String}  searchValue 	- 검색어 ( 설문명 )
		 * @param {String}  userId 			- 사용자아이디
		 * @returns {list} 설문목록
		 */
    	function bfrSrvyListSelect(page) {
    		var url  = "/srvy/profAuthrtSbjctSrvyListAjax.do";
    		var data = {
    			"pageIndex"   	: page,
    			"smstrChrtId" 	: $("#smstrChrtId").val(),
    			"sbjctId" 		: $("#sbjctId").val(),
    			"listScale"   	: $("#listScale").val(),
    			"searchValue" 	: $("#searchValue").val(),
    			"userId"		: "${vo.userId}"
    		};

			$.ajax({
		        url 	  : url,
		        async	  : false,
		        type 	  : "POST",
		        dataType  : "json",
		        data 	  : JSON.stringify(data),
		        contentType: "application/json; charset=UTF-8",
		    }).done(function(data) {
	        	if (data.result > 0) {
	        		var returnList = data.returnList || [];
            		var html = "";

            		if(returnList.length > 0) {
            			returnList.forEach(function(v, i) {
            				var srvyGbnnm = v.srvyGbn == "SRVY_TEAM" ? "설문 팀" : "설문";
							html += "<tr>";
							html += "	<td>" + v.lineNo + "</td>";
							html += "	<td>" + v.sbjctnm + "</td>";
							html += "	<td>" + v.dvclasNo + "<spring:message code='exam.label.decls' /></td>";/* 반 */
							html += "	<td>" + srvyGbnnm + "</td>";
							html += "	<td class='tl'>" + v.srvyTtl + "</td>";
							html += "	<td><a href='javascript:window.parent.srvyCopy(\"" + v.srvyId + "\")' class='ui blue button roundBtntype2'><spring:message code='exam.button.select' />​</a></td>";/* 선택 */
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
			    			eventName 	  : "bfrSrvyListSelect"
			    		};

			    		gfn_renderPaging(params);
	    	    	} else {
	    	    		$("#paging").hide();
	    	    	}
	            } else {
	            	alert(data.message);
	            }
		    }).fail(function() {
		    	alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
		    });
    	}

		 /**
		 * 설문학기기수선택
		 * @param {String}  smstrChrtId - 학기기수아이디
		 * @param {String}  sbjctId 	- 과목아이디
		 */
		function srvySmstrChrtChc(smstrChrtId) {
			var url  = "/quiz/copyQstnSbjctListAjax.do";
			var data = {
				"smstrChrtId"   : smstrChrtId,
				"sbjctId" 		: "${vo.sbjctId}"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
				   	var returnList = data.returnList || [];
				   	var html = "";

				   	if(returnList.length > 0) {
				   		html += "<option value='' selected><spring:message code='exam.label.sel.crs' /></option>";/* 과목 선택 */
				   		returnList.forEach(function(v, i) {
						html += "<option value='" + v.sbjctId + "'>" + v.sbjctnm + " " + v.dvclasNo + "반</option>";
				   		});
				   	}

				   	$("#sbjctId").empty().append(html);
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
            	<select class="ui dropdown mr5" id="smstrChrtId" onchange="srvySmstrChrtChc(this.value)">
            		<option value=""><spring:message code="exam.label.open.crs.year.term" /> <spring:message code="exam.button.select" /></option><!-- 개설년도_학기 --><!-- 선택 -->
            		<c:forEach var="item" items="${srvySearchSmstrList }">
						<option value="${item.smstrChrtId }">${item.smstrChrtnm }</option>
					</c:forEach>
            	</select>
                <select class="ui dropdown mr5 w250" id="sbjctId" onchange="bfrSrvyListSelect(1)">
                	<option value=""><spring:message code='crs.label.crecrs.sel' /></option><!-- 과목 선택 -->
                </select>

                <div class="ui action input search-box mr5">
                    <input type="text" placeholder="설문명 입력" id="searchValue">
                    <button class="ui black icon button" onclick="bfrSrvyListSelect(1)"><i class="search icon"></i></button>
                </div>

                <div class="mla">
	                <select class="ui dropdown mr5 list-num" id="listScale" onchange="bfrSrvyListSelect(1)">
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
							<th scope="col" class="tc">설문구분</th>
							<th scope="col" class="tc">설문명</th>
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
