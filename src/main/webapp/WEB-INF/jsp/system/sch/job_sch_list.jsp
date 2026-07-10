<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
	$(document).ready(function () {
		if(!${empty vo.haksaYear}) {
			//listJobSch(1);
		}
		$("#searchValue").on("keyup", function(e) {
			if(e.keyCode == 13) {
				//listJobSch(1);
			}
		});
	});
	
	// 업무일정 목록
	function listJobSch(page) {

		if($("#haksaYear").val() == "") {
			alert("<spring:message code='sys.alert.select.haksa.year'/>"); // 개설년도를 선택하세요.
			return;
		}

		/*
		if($("#haksaTerm").val() == "") {
			alert("<spring:message code='sys.alert.select.haksa.term'/>"); // 학기구분을 선택하세요.
			return;
		}
		*/
		
		jobSchListTable.clearData();

		var url  = "/jobSchMgr/jobSchListPaging.do";
		var data = {
			"haksaYear"   : $("#haksaYear").val(),
			"haksaTerm"	  : $("#haksaTerm").val(),
			"codeOptn"	  : $("#codeOptn").val(),
			"searchValue" : $("#searchValue").val(),
			"pageIndex"   : page,
			"listScale"   : 10
		};

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var returnList = data.returnList || [];
        		var html = "";
        		
        		if(returnList.length > 0) {
        			var dataList = [];
        			returnList.forEach(function(v, i) {
        				var schStartDt = v.schStartDt.substring(0, 4) + "." + v.schStartDt.substring(4, 6) + "." + v.schStartDt.substring(6, 8) + " " + v.schStartDt.substring(8, 10) + ":" + v.schStartDt.substring(10, 12);
        				var schEndDt   = v.schEndDt.substring(0, 4) + "." + v.schEndDt.substring(4, 6) + "." + v.schEndDt.substring(6, 8) + " " + v.schEndDt.substring(8, 10) + ":" + v.schEndDt.substring(10, 12);
        				var type = "";
        				if(v.codeOptn === "1") {
							type = "<spring:message code='common.label.uni.college'/>"; // 대학교
						} else if(v.codeOptn === "2") {
							type = "<spring:message code='common.label.uni.graduate'/>"; // 대학원
						}
        				
        				dataList.push({
        					calendarCtgr: v.calendarCtgr,
        					calendarCtgrNm: v.calendarCtgrNm,
        					type: type,
        					haksaYear: v.haksaYear,
        					haksaTermNm: v.haksaTermNm,
        					jobSchNm: "<a class='fcBlue' href='javascript:viewJobSch(\""+v.jobSchSn+"\")'>"+v.jobSchNm+"</a>",
        					schStartDt: schStartDt,
        					schEndDt: schEndDt,
        					manage: "<a href=\"javascript:viewSch(2,'"+v.jobSchSn+"')\" class='ui basic mini button'><spring:message code='sys.button.modify'/></a> <a href=\"javascript:delJobSch('"+v.jobSchSn+"')\" class='ui basic mini button'><spring:message code='sys.button.delete'/></a>"
        				});
        			});
        			
        			jobSchListTable.addData(dataList);
        			jobSchListTable.redraw();
        		} 
        		
		    	var params = {
			    	totalCount 	  : data.pageInfo.totalRecordCount,
			    	listScale 	  : data.pageInfo.recordCountPerPage,
			    	currentPageNo : data.pageInfo.currentPageNo,
			    	eventName 	  : "listJobSch"
			    };
			    
			    //gfn_renderPaging(params);
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		});
	}
	
	// 업무일정 상세정보 팝업
	function viewJobSch(jobSchSn) {
		$("#viewJobSchForm input[name=jobSchSn]").val(jobSchSn);
		$("#viewJobSchForm").attr("target", "viewJobSchPopIfm");
        $("#viewJobSchForm").attr("action", "/jobSchMgr/viewJobSchPop.do");
        $("#viewJobSchForm").submit();
        $('#viewJobSchPop').modal('show');
	}
	
	// 페이지 이동
	function viewSch(tab, jobSchSn) {
		var urlMap = {
			"1" : "/jobSchMgr/Form/writeJobSch.do",		// 등록 페이지
			"2" : "/jobSchMgr/Form/editJobSch.do"		// 수정 페이지
		};
		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "viewForm");
		form.attr("action", urlMap[tab]);
		form.append($('<input/>', {type: 'hidden', name: 'jobSchSn', value: jobSchSn}));
		form.append($('<input/>', {type: 'hidden', name: 'haksaYear', value: $("#haksaYear").val()}));
		form.append($('<input/>', {type: 'hidden', name: 'haksaTerm', value: $("#haksaTerm").val()}));
		form.append($('<input/>', {type: 'hidden', name: 'codeOptn', value: $("#codeOptn").val()}));
		form.append($('<input/>', {type: 'hidden', name: 'searchValue', value: $("#searchValue").val()}));
		form.appendTo("body");
		form.submit();
	}
	
	// 업무일정 삭제
	function delJobSch(jobSchSn) {
		var result = confirm("<spring:message code='sys.alert.delete.confirm'/>"); // 정말 삭제하시겠습니까?

		if(!result){return false;}
		
		var url  = "/jobSchMgr/delJobSch.do";
		var data = {
			"jobSchSn" : jobSchSn
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				alert("<spring:message code='sys.alert.delete.job.sch' />");/* 업무일정 삭제가 완료되었습니다. */
				listJobSch(1);
			} else {
				alert(data.message);
			}
		}, function(xhr, status, error) {
			alert("<spring:message code='sys.error.delete.job.sch' />");/* 업무일정 삭제 중 에러가 발생하였습니다. */
		});
	}
	
	// erp 연동
	function getErpSch() {
		if(window.confirm("<spring:message code='sch.confirm.erp.sch.link' />")) {/* 지금 ERP에서 업무일정을 가져오시겠습니까? */
			var url  = "/jobSchMgr/getErpSch.do";
			var data = {
				"haksaYear" : $("#haksaYear").val(),
				"haksaTerm" : $("#haksaTerm").val()
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					alert("<spring:message code='sch.alert.erp.sch.link.y' />");/* ERP 업무일정 연동이 완료되었습니다. */
					listJobSch(1);
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert("<spring:message code='sch.alert.erp.sch.link.n' />");/* ERP 업무일정 연동 중 에러가 발생하였습니다. */
			}, true);
		}
	}
</script>

<body>
	<form id="viewJobSchForm" method="POST">
		<input type="hidden" name="jobSchSn" />
	</form>
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>

        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>

        <div id="container">
            <!-- 본문 content 부분 -->
            <div class="content">
            	<%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
        		<div class="ui form">
				<!-- 페이지 시작 -->
					<div id="info-item-box">
						<h2 class="page-title flex-item flex-wrap gap4 columngap16">
							<spring:message code="sys.label.basic.job.info.manage" /><!-- 업무기초정보관리 -->
							<div class="ui breadcrumb small">
								<small class="section"><spring:message code="sys.label.job.sch.manage" /><!-- 업무일정관리 --></small>
							</div>
						</h2>
					</div>
					
					<div class="ui segment searchArea">
						<div class="fields">
							<!-- 검색 -->
							<div class="two wide field ">
								<select class="ui dropdown" id="haksaYear">
									<option value=""><spring:message code="sys.label.select.haksa.year" /><!-- 년도선택 --></option>
									<c:forEach var="item" items="${yearList }">
										<option value="${item }" ${item eq vo.haksaYear or item eq termVO.haksaYear ? 'selected' : '' }>${item }</option>
									</c:forEach>
								</select>
							</div>
							<div class="two wide field ">
								<select class="ui dropdown" id="haksaTerm">
									<option value=""><spring:message code="sys.label.select.haksa.term" /><!-- 학기선택 --></option>
									<option value="all"><spring:message code="sys.common.search.all" /><!-- 전체 --></option>
									<c:forEach var="list" items="${termList }">
										<option value="${list.cd }" ${list.cd eq termVO.haksaTerm or list.cd eq vo.haksaTerm ? 'selected' : '' }>${list.cdnm}</option>
									</c:forEach>
								</select>
							</div>
							<div class="three wide field ">
								<c:if test="${orgId eq 'ORG0000001' or orgId eq 'ORG0000002'}">
								<select class="ui dropdown" id="codeOptn">
									<option value="" ${ empty vo.codeOptn ? 'selected' : '' }><spring:message code="sys.label.select.org.cd" /><!-- 대학구분 --></option>
									<option value="all" ${vo.codeOptn eq 'all' ? 'selected' : '' }><spring:message code="sys.common.search.all" /><!-- 전체 --></option>
									<option value="1" ${vo.codeOptn eq '1' ? 'selected' : '' }><spring:message code="common.label.uni.college" /><!-- 대학교 --></option>
									<option value="2" ${vo.codeOptn eq '2' ? 'selected' : '' }><spring:message code="common.label.uni.graduate" /><!-- 대학원 --></option>
								</select>
								</c:if>
							</div>
							<div class="ui input search-box">
								<input type="text"
									placeholder="<spring:message code='sys.label.calendar.ctgr' />, <spring:message code='sys.label.job.sch.nm' /> <spring:message code='sys.button.search' />"
									class="w250" id="searchValue" value="${vo.searchValue}"><!-- 일정코드 , 업무일점영  검색 -->
							</div>
							<!-- 검색 -->
						</div>
						<div class="button-area mt10 tc">
							<button type="button" class="ui blue button" onclick="listJobSch(1)"><spring:message code="sys.button.search" /><!-- 검색 --></button>
						</div>
					</div>
			
					<div class="option-content mt30 mb20">
						<h3 class="sec_head">
							<spring:message code="sys.label.job.sch.list" />
							<!-- 업무일정목록 -->
						</h3>
						<div class="mla">
							<%-- <c:if test="${orgId eq 'ORG0000001'}">
								<button type="button" class="ui basic button" onclick="getErpSch()">ERP연동</button>
							</c:if>
							<c:if test="${orgId ne 'ORG0000001'}">
								<button type="button" class="ui orange button"
									onclick="viewSch(1, '')">
									<spring:message code="sys.label.job.sch.add" />
									<!-- 일정등록 -->
								</button>
							</c:if> --%>
								<button type="button" class="ui basic button" onclick="getErpSch()">ERP연동</button>
								<button type="button" class="ui orange button"onclick="viewSch(1, '')">
									<spring:message code="sys.label.job.sch.add" /><!-- 일정등록 -->
								</button>
						</div>
					</div>
				
					<!-- 목록 시작 -->
					<div id="jobSchListTable"></div>
					<script>
						var manageVisible = <%=(SessionInfo.isKnou(request) == true ? "false" : "true")%>;
						
						// 일정 목록 테이블
						var jobSchListTable = new Tabulator("#jobSchListTable", {
                     		maxHeight: "600px",
                     		minHeight: "100px",
                     		layout: "fitColumns",
                     		selectableRows: false,
                     		headerSortClickElement: "icon",
                     		renderVertical: "basic",
                     		placeholder:"<spring:message code='common.content.not_found'/>",
                     		columns: [
                     			{title:"<spring:message code='common.number.no'/>", 			field:"lineNo", 		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:60,		formatter:"rownum",		headerSort:false}, // NO
                     			{title:"<spring:message code='sys.label.calendar.ctgr'/>", 		field:"calendarCtgr", 	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:100,		formatter:"plaintext",	headerSort:false}, // 일정코드
                     			{title:"<spring:message code='sys.label.calendar.ctgr.type'/>",	field:"calendarCtgrNm", headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:100,	formatter:"plaintext",	headerSort:false}, // 업무구분
                     		    {title:"<spring:message code='sys.label.type'/>",				field:"type", 			headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:100,		formatter:"plaintext",	headerSort:false}, // 구분
                     		    {title:"<spring:message code='sys.label.haksa.year'/>", 		field:"haksaYear",		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:80,		formatter:"plaintext",	headerSort:false}, // 개설년도
                     		    {title:"<spring:message code='sys.label.haksa.term'/>", 		field:"haksaTermNm", 	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:80,		formatter:"plaintext",	headerSort:false}, // 학기
                     		    {title:"<spring:message code='sys.label.job.sch.nm'/>", 		field:"jobSchNm",		headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:150,	formatter:"html",		headerSort:false}, // 업무일정명
                     		    {title:"<spring:message code='sys.label.start.dt'/>", 			field:"schStartDt", 	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:130,		formatter:"plaintext",	headerSort:false}, // 시작일시
                     		    {title:"<spring:message code='sys.label.end.dt'/>", 			field:"schEndDt",		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:130,		formatter:"plaintext", 	headerSort:false}, // 종료일시
                     		    {title:"<spring:message code='sys.label.manage'/>", 			field:"manage", 		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:100,		formatter:"html",		headerSort:false, visible:manageVisible}  // 관리
                     		]
                    	});
						
					</script>
					<!-- 목록 끝 -->

				<!-- 페이지 끝-->
				</div>
			</div>
        </div>
        <!-- //본문 content 부분 -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
    <!-- 업무일정 상세정보 팝업 --> 
	<div class="modal fade" id="viewJobSchPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="sys.label.job.sch.view.detail" />" aria-hidden="false">
	    <div class="modal-dialog modal-lg" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="common.button.close" />"><!-- 닫기 -->
	                    <span aria-hidden="true">&times;</span>
	                </button>
	                <h4 class="modal-title"><spring:message code="sys.label.job.sch.view.detail" /><!-- 업무일정 상세정보 --></h4>
	            </div>
	            <div class="modal-body">
	                <iframe src="" id="viewJobSchPopIfm" name="viewJobSchPopIfm" width="100%" scrolling="no"></iframe>
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