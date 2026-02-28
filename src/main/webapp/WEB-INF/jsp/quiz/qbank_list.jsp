<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

<script type="text/javascript">
	$(document).ready(function () {
		listQbank(1);
		
		$("#searchValue").on("keyup", function(e) {
			if(e.keyCode == 13) {
				listQbank(1);
			}
		});
	});
	
	// 리스트 조회
	function listQbank(page) {
		var url  = "/quiz/qbankList.do";
		if($("#listScale").val() == "0") {
			url = "/quiz/qbankQstnList.do";
		}
		var data = {
			"pageIndex" 		 : page,
			"listScale" 		 : $("#listScale").val(),
			"searchValue" 		 : $("#searchValue").val(),
			"parExamQbankCtgrCd" : $("#searchParExamQbankCtgrCd").val(),
			"examQbankCtgrCd" 	 : $("#searchExamQbankCtgrCd").val(),
			"crsNo" 			 : $("#searchCrsNo").val(),
			"searchKey"			 : "${creCrsVO.tchNo}",
			"creYear"			 : "${creCrsVO.creYear}",
			"creTerm"			 : "${creCrsVO.creTerm}"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		html = ``;
        		
        		data.returnList.forEach(function(v, i) {
        			html += `<tr>`;
        			html += `	<td class="tc">\${v.lineNo}</td>`;
        			html += `	<td>\${v.parExamCtgrNm}</td>`;
        			html += `	<td>\${v.examCtgrNm}</td>`;
        			html += `	<td class="tl">\${v.crsNm}</td>`;
        			html += `	<td class="tc">\${v.userNm}</td>`;
        			html += `	<td><a href="javascript:editQbank('\${v.examQbankQstnSn}')" class="fcBlue">\${v.title}</a></td>`;
        			html += `	<td class="tc">\${v.qstnTypeNm}</td>`;
        			html += `	<td class="tc"><a href="javascript:qbankQstnView('\${v.crsNo}', '\${v.examQbankQstnSn}')" class="ui basic small button"><spring:message code="exam.label.qstn" /><spring:message code="exam.label.qstn.item" />​</a></td>`;/* 문제 *//* 보기 */
        			html += `</tr>`;
        		});
        		
        		$("#qbankList").empty().html(html);
	    		$(".table").footable();
	    		if($("#listScale").val() != "0") {
		    		var params = {
				    	totalCount 	  : data.pageInfo.totalRecordCount,
				    	listScale 	  : data.pageInfo.pageSize,
				    	currentPageNo : data.pageInfo.currentPageNo,
				    	eventName 	  : "listQbank"
				    };
				    
				    gfn_renderPaging(params);
	    		}
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
		});
	}
	
	// 문제보기 팝업
	function qbankQstnView(crsNo, examQbankQstnSn) {
		var kvArr = [];
		kvArr.push({'key' : 'crsNo', 		   'val' : crsNo});
		kvArr.push({'key' : 'examQbankQstnSn', 'val' : examQbankQstnSn});
		
		submitForm("/quiz/qbankQstnViewPop.do", "quizPopIfm", "qbankView", kvArr);
	}
	
	// 분류코드 등록 팝업
	function writeQbankCtgr() {
		var kvArr = [];
		kvArr.push({'key' : 'crsNo', 	'val' : "${vo.crsNo}"});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
		
		submitForm("/quiz/writeQbankCtgrPop.do", "quizPopIfm", "qbankCtgr", kvArr);
	}
	
	// 문제 등록
	function writeQbank() {
		var kvArr = [];
		kvArr.push({'key' : 'crsNo', 	'val' : "${vo.crsNo}"});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
		
		submitForm("/quiz/Form/writeQbank.do", "", "", kvArr);
	}
	
	// 문제 수정
	function editQbank(examQbankQstnSn) {
		var kvArr = [];
		kvArr.push({'key' : 'crsNo', 		   'val' : "${vo.crsNo}"});
		kvArr.push({'key' : 'crsCreCd', 	   'val' : "${vo.crsCreCd}"});
		kvArr.push({'key' : 'examQbankQstnSn', 'val' : examQbankQstnSn});
		
		submitForm("/quiz/Form/editQbank.do", "", "", kvArr);
	}
	
	// 엑셀 다운로드
	function qbankExcelDown() {
		var excelGrid = {
			colModel:[
		        {label:'<spring:message code="common.number.no" />', name:'lineNo', align:'center', width:'1000'},/* NO */
		        {label:"<spring:message code='exam.label.upper.categori' />",	name:'parExamCtgrNm',	align:'left', width:'5000'},/* 상위분류 */
		        {label:"<spring:message code='exam.label.sub.categori' />", name:'examCtgrNm', align:'left',  width:'5000'},/* 하위분류 */
		        {label:"<spring:message code='crs.label.crecrs' />", name:'crsNm', align:'right', width:'5000'},/* 과목 */
		        {label:"<spring:message code='exam.label.tch.rep' />", name:'userNm', align:'right',   width:'5000'},/* 담당교수 */
		        {label:"<spring:message code='exam.label.title' />", name:'title', align:'right', width:'5000'},/* 제목 */
		        {label:"<spring:message code='exam.label.qstn.type' />", name:'qstnTypeNm', align:'right', width:'5000'},/* 문제유형 */
			]
		};
		
		var kvArr = [];
		kvArr.push({'key' : 'crsNo', 			  'val' : $("#searchCrsNo").val()});
		kvArr.push({'key' : 'parExamQbankCtgrCd', 'val' : $("#searchParExamQbankCtgrCd").val()});
		kvArr.push({'key' : 'examQbankCtgrCd',	  'val' : $("#searchExamQbankCtgrCd").val()});
		kvArr.push({'key' : 'searchValue', 		  'val' : $("#searchValue").val()});
		kvArr.push({'key' : 'excelGrid', 		  'val' : JSON.stringify(excelGrid)});
		
		submitForm("/quiz/qbankExcelDown.do", "", "", kvArr);
	}
	
	// 하위 분류 목록 가져오기
    function chgCtgrCd(obj) {
    	var url  = "/quiz/listExamQbankCtgrCd.do";
		var data = {
			"parExamQbankCtgrCd" : $(obj).val(),
			"userId"			 : "${vo.userId}",
			"searchType"		 : "UNDER"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var returnList = data.returnList || [];
        		html = "<option value='all'><spring:message code='exam.label.sub.categori' /></option>";/* 하위분류 */
        		
        		if(returnList.length > 0 && $(obj).val() != "all") {
        			returnList.forEach(function(v, i) {
	        			html += `<option value="\${v.examQbankCtgrCd}">\${v.examCtgrNm}</option>`;
	        		});
        		}
        		
        		$("#searchExamQbankCtgrCd").empty().append(html);
        		$("#searchExamQbankCtgrCd").dropdown("clear");
        		$("#searchExamQbankCtgrCd option[value='all']").prop("selected", true).trigger("change");
        		listQbank(1);
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
		});
    }
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>

        <div id="container">
            <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>
            <!-- 본문 content 부분 -->
            <div class="content stu_section">
            	<%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
        		<div class="ui form">
        			<div class="layout2">
        				<script>
						$(document).ready(function () {
							// set location
							setLocationBar('<spring:message code="exam.label.qbank" />', '<spring:message code="exam.button.list" />');
						});
						</script>
		                <div id="info-item-box">
		                	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="exam.label.qbank" /><!-- 문제은행 -->
                            </h2>
		                    <div class="button-area">
		                        <a href="javascript:writeQbankCtgr()" class="ui blue button"><spring:message code="exam.label.categori.code" /> <spring:message code="exam.button.reg" /></a><!-- 분류코드 --><!-- 등록 -->
		                    </div>
		                </div>
		                <div class="row">
		                	<div class="col">
				                <div class="option-content mb10">
				                    <div class="button-area flex-left-auto">
					                    <a href="javascript:writeQbank()" class="ui blue button"><spring:message code="exam.label.qstn" /> <spring:message code="exam.button.reg" /></a><!-- 문제 --><!-- 등록 -->
				                    </div>
				                </div>
				                <div class="option-content ui segment">
				                	<div class="button-area">
				                		<select class="ui dropdown w200 mr5" onchange="listQbank(1)" id="searchCrsNo">
							                <option value="all"><spring:message code="crs.label.crecrs" /></option><!-- 과목 -->
							                <c:forEach var="item" items="${crsList }">
							                	<option value="${item.crsCd }">${item.crsNm }</option>
							                </c:forEach>
							            </select>
						                <select class="ui dropdown mr5" onchange="chgCtgrCd(this)" id="searchParExamQbankCtgrCd">
							                <option value="all"><spring:message code="exam.label.upper.categori" /></option><!-- 상위분류 -->
							                <c:forEach var="item" items="${ctgrList }">
							                	<option value="${item.examQbankCtgrCd }">${item.parExamCtgrNm }</option>
							                </c:forEach>
							            </select>
						                <select class="ui dropdown mr5" onchange="listQbank(1)" id="searchExamQbankCtgrCd">
							                <option value="all"><spring:message code="exam.label.sub.categori" /></option><!-- 하위분류 -->
							            </select>
				                	</div>
				                    <div class="ui action input search-box mr5">
				                        <input type="text" id="searchValue" class="w300" placeholder="<spring:message code='exam.label.categori.nm' />/<spring:message code='crs.label.crecrs' />/<spring:message code='exam.label.tch.rep' />/<spring:message code='exam.label.title' /> <spring:message code='exam.label.input' />"><!-- 분류명 --><!-- 과목 --><!-- 담당교수 --><!-- 제목 --><!-- 입력 -->
				                        <button class="ui icon button" onclick="listQbank(1)"><i class="search icon"></i></button>
				                    </div>
				                </div>
				                <div class="option-content mb10">
				                    <div class="button-area flex-left-auto">
					                    <a href="javascript:qbankExcelDown()" class="ui blue button"><spring:message code="exam.button.excel.down" /></a><!-- 엑셀 다운로드 -->
					                    <select class="ui dropdown mr5 list-num" id="listScale" onchange="listQbank(1)">
							                <option value="10">10</option>
							                <option value="20">20</option>
							                <option value="50">50</option>
							                <option value="100">100</option>
							                <option value="0"><spring:message code="exam.common.search.all" /><!-- 전체 --></option>
							            </select>
				                    </div>
				                </div>
				                <div>
				                	<table class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code='exam.common.empty' />"><!-- 등록된 내용이 없습니다. -->
										<thead>
											<tr>
												<th scope="col" class="tc num"><spring:message code="common.number.no" /></th><!-- NO. -->
												<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code="exam.label.upper.categori" /></th><!-- 상위분류 -->
												<th scope="col" class="tc" data-breakpoints="xs sm"><spring:message code="exam.label.sub.categori" /></th><!-- 하위분류 -->
												<th scope="col" class="tc"><spring:message code="crs.label.crecrs" /></th><!-- 과목 -->
												<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code="exam.label.tch.rep" /></th><!-- 담당교수 -->
												<th scope="col" class="tc"><spring:message code="exam.label.title" /></th><!-- 제목 -->
												<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="exam.label.qstn.type" /></th><!-- 문제유형 -->
												<th scope="col" class="tc"><spring:message code="exam.label.qstn" /><spring:message code="exam.label.qstn.item" /></th><!-- 문제 --><!-- 보기 -->
											</tr>
										</thead>
										<tbody id="qbankList">
										</tbody>
									</table>
									<div id="paging" class="paging"></div>
				                </div>
		                	</div>
		                </div>
        			</div>
        		</div>
            </div>
            <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
        </div>
        <!-- //본문 content 부분 -->
    </div>
</body>
</html>