<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

<script type="text/javascript">
	$(document).ready(function () {
		listMemo(1);
		
		$("#searchValue").on("keyup", function(e) {
			if(e.keyCode == 13) {
				listMemo(1);
			}
		});
	});
	
	// 메모 목록
	function listMemo(page) {
		var pagingYn = $("#listScale").val() == "200" ? "N" : "Y";
		var url  = "/lesson/lessonLect/lessonStudyMemoList.do";
		var data = {
			"pageIndex"    : page,
			"listScale"    : $("#listScale").val(),
			"searchValue"  : $("#searchValue").val(),
			"crsCreCd"	   : "${vo.crsCreCd}",
			"pagingYn"	   : pagingYn
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var returnList = data.returnList || [];
        		var html = "";
        		var cnt = 0;
        		
        		if(returnList.length > 0) {
        			returnList.forEach(function(v, i) {
        				cnt = v.totalCnt;
        				var regDttm = v.regDttm.substring(0, 4) + "." + v.regDttm.substring(4, 6) + "." + v.regDttm.substring(6, 8) + " " + v.regDttm.substring(8, 10) + ":" + v.regDttm.substring(10, 12);
        				html += "<tr>";
        				html += "	<td>" + v.lineNo + "</td>";
        				html += "	<td>" + v.lessonScheduleOrder + " <spring:message code='lesson.label.schedule' /></td>";
        				html += "	<td>" + v.lessonTimeOrder + " <spring:message code='lesson.label.time' /></td>";
        				html += "	<td class='tl'><a class='fcBlue' href='javascript:viewMemo(\"" + v.studyMemoId + "\")'>" + v.memoTitle + "</a></td>";
        				html += "	<td>" + regDttm + "</td>";
        				html += "</tr>";
        			});
        		}
        		
        		$("#studyMemoList").empty().html(html);
		    	$("#studyMemoTable").footable();
		    	$("#memoCnt").text(cnt);
		    	if($("#listScale").val() != "200") {
		    		$("#paging").show();
			    	var params = {
						totalCount 	  : data.pageInfo.totalRecordCount,
						listScale 	  : data.pageInfo.recordCountPerPage,
						currentPageNo : data.pageInfo.currentPageNo,
						eventName 	  : "listMemo"
					};
					
					gfn_renderPaging(params);
		    	} else {
		    		$("#paging").hide();
		    	}
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		});
	}
	
	// 메모 정보 팝업
	function viewMemo(studyMemoId) {
		$("#lessonStudyMemoForm input[name=studyMemoId]").val(studyMemoId);
		$("#lessonStudyMemoForm input[name=crsCreCd]").val("${vo.crsCreCd}");
		$("#lessonStudyMemoForm").attr("target", "lessonStudyMemoPopIfm");
        $("#lessonStudyMemoForm").attr("action", "/lesson/lessonPop/lessonStudyMemoViewPop.do");
        $("#lessonStudyMemoForm").submit();
        $('#lessonStudyMemoPop').modal('show');
	}
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
	<form id="lessonStudyMemoForm" method="POST">
		<input type="hidden" name="studyMemoId" />
		<input type="hidden" name="crsCreCd" />
	</form>
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
								setLocationBar('<spring:message code="lesson.label.learning.activity" />', '<spring:message code="lesson.label.study.memo" />');
							});
						</script>
		                <div id="info-item-box">
		                    <h2 class="page-title flex-item flex-wrap gap4 columngap16"><spring:message code="lesson.label.study.memo" /><!-- 학습메모 --></h2>
		                </div>
		                <div class="row">
		                	<div class="col">
		                		<div class="option-content mb20">
		                			<div class="ui action input search-box mr5">
		                				<label for="searchValue" class="hide"><spring:message code='lesson.label.memo.cnts.input' /></label>
				                        <input type="text" id="searchValue" class="w300" placeholder="<spring:message code='lesson.label.memo.cnts.input' />"><!-- 메모내용 입력 -->
				                        <button class="ui icon button" onclick="listMemo(1)"><i class="search icon"></i></button>
				                    </div>
				                    <div class="mla">
				                    	<span>[ <spring:message code="common.page.total.cnt" /><!-- 총 건수 --> : <label id="memoCnt"></label><spring:message code="common.page.total_count" /><!-- 건 --> ]</span>
				                    	<label for="listScale" class="hide">list scale</label>
				                    	<select class="ui dropdown list-num" id="listScale" onchange="listMemo(1)">
				                    		<option value="10">10</option>
				                    		<option value="20">20</option>
				                    		<option value="50">50</option>
				                    		<option value="100">100</option>
				                    		<option value="200"><spring:message code="common.all" /><!-- 전체 --></option>
				                    	</select>
				                    </div>
		                		</div>
		                		<table id="studyMemoTable" class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code='common.content.not_found' />"><!-- 등록된 내용이 없습니다. -->
		                			<caption class="hide"><spring:message code="lesson.label.study.memo" /></caption>
		                			<colgroup>
		                				<col width="5%">
		                				<col width="10%">
		                				<col width="10%">
		                				<col width="*">
		                				<col width="20%">
		                			</colgroup>
		                			<thead>
		                				<tr>
		                					<th scope="col"><spring:message code="common.number.no" /><!-- NO. --></th>
		                					<th scope="col"><spring:message code="lesson.label.schedule" /><!-- 주차 --></th>
		                					<th scope="col"><spring:message code="lesson.label.time" /><!-- 교시 --></th>
		                					<th scope="col"><spring:message code="lesson.label.memo" /><!-- 메모 --></th>
		                					<th scope="col"><spring:message code="lesson.label.reg.dt" /><!-- 등록일 --></th>
		                				</tr>
		                			</thead>
		                			<tbody id="studyMemoList">
		                			</tbody>
		                		</table>
		                		<div id="paging" class="paging"></div>
		                	</div>
		                </div>
        			</div>
        		</div>
            </div>
            <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
        </div>
        <!-- //본문 content 부분 -->
    </div>
    <!-- 학슴메모 정보 팝업 --> 
	<div class="modal fade" id="lessonStudyMemoPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="lesson.label.study.memo" />" aria-hidden="false">
	    <div class="modal-dialog modal-lg" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="common.button.close" />"><!-- 닫기 -->
	                    <span aria-hidden="true">&times;</span>
	                </button>
	                <h4 class="modal-title"><spring:message code="lesson.label.study.memo" /><!-- 학습메모 --></h4>
	            </div>
	            <div class="modal-body">
	                <iframe src="" id="lessonStudyMemoPopIfm" name="lessonStudyMemoPopIfm" width="100%" scrolling="no" title="학습메모"></iframe>
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