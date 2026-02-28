<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/resh/common/resh_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<script type="text/javascript">
	$(document).ready(function() {
		listResh(1);
		
		$("#searchValue").on("keyup", function(e) {
			if(e.keyCode == 13) {
				listResh(1);
			}
		});
	});
	
	// 리스트 조회
	function listResh(page) {
		var url  = "/resh/reshListPaging.do";
		if($("#listScale").val() == "0") {
			url = "/resh/reshList.do";
		}
		var data = {
			"crsCreCd"    : "${vo.crsCreCd}",
			"userId"	  : "${vo.userId}",
			"joinTrgt"	  : "${vo.joinTrgt}",
			"reschTypeCd" : "HOME",
			"pageIndex"   : page,
			"listScale"   : $("#listScale").val(),
			"searchValue" : $("#searchValue").val()
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
				html = "";
				
				if(returnList.length > 0) {
					returnList.forEach(function(v, i) {
						// 시작일자
						var reschStartDttm = dateFormat("date", v.reschStartDttm);
						// 종료일자
						var reschEndDttm   = dateFormat("date", v.reschEndDttm);
						// 설문 결과 조회 가능 여부
						var rsltOpenYn	   = v.rsltTypeCd == "ALL" || (v.rsltTypeCd == "JOIN" && v.joinYn == "Y") ? "<spring:message code='resh.label.open.y' />"/* 공개 */ : "<span class='fcRed'><spring:message code='resh.label.open.n' /></span>";/* 비공개 */
						// 설문 참여 가능시 함수
						var joinFunction   = v.joinYn == "N" && v.reschStatus == "진행" && v.reschSubmitYn == "Y" ? "javascript:reshJoinPop('"+v.reschCd+"')" : "#0";
						// 설문 참여 가능 클래스명
						var joinClass	   = v.joinYn == "N" && v.reschStatus == "진행" && v.reschSubmitYn == "Y" ? "blue" : "grey";
						// 설문 결과 조회 가능시 함수
						var resultFunction = (v.rsltTypeCd == "ALL" || (v.rsltTypeCd == "JOIN" && v.joinYn == "Y")) && v.reschStatus == "완료" ? "javascript:reshResult('"+v.reschCd+"')" : "#0";
						// 설문 결과 가능 클래스명
						var resultClass	   = (v.rsltTypeCd == "ALL" || (v.rsltTypeCd == "JOIN" && v.joinYn == "Y")) && v.reschStatus == "완료" ? "blue" : "grey";
						html += `<tr>`;
						html += `	<td class='tc'>`;
						html += `		\${v.lineNo}`;
						html += `	</td>`;
						html += `	<td>\${v.reschTitle}</td>`;
						html += `	<td class='tc'>\${reschStartDttm} ~ \${reschEndDttm}</td>`;
						html += `	<td class='tc'>\${v.reschQstnCnt}</td>`;
						html += `	<td class='tc'>\${rsltOpenYn}</td>`;
						html += `	<td class='tc'>`;
						html += `		<a href="\${joinFunction}" class="ui small \${joinClass} button"><spring:message code="resh.label.resh.join" /></a>`;/* 설문참여 */
						html += `		<a href="\${resultFunction}" class="ui small \${resultClass} button"><spring:message code="resh.label.status.submit" /></a>`;/* 제출 현황 */
						html += `	</td>`;
						html += `</tr>`;
					});
				}
        		
        		$("#reshList").empty().html(html);
        		$(".table").footable();
        		if($("#listScale").val() != "0") {
	    			var params = {
				    	totalCount 	  : data.pageInfo.totalRecordCount,
				    	listScale 	  : data.pageInfo.pageSize,
				    	currentPageNo : data.pageInfo.currentPageNo,
				    	eventName 	  : "listResh"
				    };
				    
				    gfn_renderPaging(params);
        		}
        		var totalCnt = returnList.length > 0 ? returnList[0].totalCnt : "0";
        		$("#reshTotalCnt").text(totalCnt);
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			alert("<spring:message code='resh.error.list' />");/* 설문 리스트 조회 중 에러가 발생하였습니다. */
		});
	}
	
	// 설문 참여
	function reshJoinPop(reschCd) {
		var kvArr = [];
		kvArr.push({'key' : 'reschCd', 	 'val' : reschCd});
		kvArr.push({'key' : 'userId', 	 'val' : "${vo.userId }"});
		kvArr.push({'key' : 'searchKey', 'val' : "list"});
		
		submitForm("/resh/reshJoinPop.do", "reshPopIfm", "join", kvArr);
	}
	
	// 설문 결과
	function reshResult(reschCd) {
		var kvArr = [];
		kvArr.push({'key' : 'reschCd', 'val' : reschCd});
		
		submitForm("/resh/homeReshResult.do", "", "", kvArr);
	}
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/frontGnb.jsp" %>
        <%@ include file="/WEB-INF/jsp/common/frontLnb.jsp" %>

        <!-- 본문 content 부분 -->
        <div class="content">
			<div class="ui form">
				<div class="layout2">
		        	<div id="info-item-box">
		        		<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                            <spring:message code="resh.label.home.resh" /><!-- 전체 설문 -->
                        </h2>
		            </div>
		            <div class="row">
		            	<div class="col">
				            <p class="f110"><spring:message code="resh.label.home.resh.info" /></p><!-- 전체 설문 참여 및 결과 확인이 가능합니다. -->
				            <div class="option-content p10 mt40">
							    <div class="ui action input search-box">
							        <input type="text" placeholder="<spring:message code='resh.label.title' /> <spring:message code='resh.label.input' />" id="searchValue" class="w250"><!-- 설문명 --><!-- 입력 -->
							        <button class="ui icon button" onclick="listResh(1)"><i class="search icon"></i></button>
							    </div>
							    <div class="flex-left-auto">
							    	[ <spring:message code="resh.label.tot" /> <spring:message code="resh.label.cnt.item" /> : <span id="reshTotalCnt"></span><spring:message code="resh.label.cnt" /> ] <!-- 총 --><!-- 건수 --><!-- 건 -->
							    	<select class="ui dropdown ml5 list-num" id="listScale" onchange="listResh(1)">
						                <option value="10">10</option>
						                <option value="20">20</option>
						                <option value="50">50</option>
						                <option value="100">100</option>
						                <option value="0"><spring:message code="resh.common.search.all" /><!-- 전체 --></option>
						            </select>
							    </div>
							</div>
							<table class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code='resh.common.empty' />"><!-- 등록된 내용이 없습니다. -->
								<thead>
									<tr>
										<th class='tc'>
								            NO.
										</th>
										<th class='tc'><spring:message code="resh.label.title" /></th><!-- 설문명 -->
										<th class='tc' data-breakpoints="xs sm"><spring:message code="resh.label.period" /></th><!-- 설문기간 -->
										<th class='tc' data-breakpoints="xs sm md"><spring:message code="resh.label.item.cnt" /></th><!-- 문항수 -->
										<th class='tc' data-breakpoints="xs sm md"><spring:message code="resh.label.result" /><spring:message code="resh.label.open.y" /></th><!-- 결과 --><!-- 공개 -->
										<th class='tc'><spring:message code="resh.label.manage" /></th><!-- 관리 -->
									</tr>
								</thead>
								<tbody id="reshList">
								</tbody>
							</table>
							<div id="paging" class="paging"></div>
		            	</div>
		            </div>
				</div>
			</div>
        </div>
        <!-- //본문 content 부분 -->
    </div>
    <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
</body>
</html>