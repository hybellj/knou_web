<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
	$(document).ready(function(){
		
		$("#searchValue").bind("keydown", enterSearch);
		function enterSearch(event) {
			if (event.keyCode == '13') {
				event.preventDefault();
				listDept(1);
			}
		}				
		listDept(1);
	});
	
	<%-- 학과 목록 --%>
	function listDept(page) {
		$("#listDiv").load("/user/userMgr/listDeptPaging.do",
		{
			"pageIndex" : page,
			"listScale" : $("#listScale").val(),
			"searchValue" : $("#searchValue").val()
		},
		function (){
		});
	}

	// 엑셀 다운로드
	function deptExcelDown() {
		var excelGrid = {
			colModel:[
		        {label:"<spring:message code='main.common.number.no' />",				name:'lineNo',      	align:'center',  width:'1000'},	/* NO. */
		        {label:"<spring:message code='user.title.userdept.dept.code' />",		name:'deptCd',		align:'left',    width:'5000'},		/* 학과/부서 코드 */
		        {label:"<spring:message code='user.title.userdept.par.dept.cd' />",		name:'parDeptCd',	align:'left',    width:'5000'},		/* 상위 학과/부서 코드 */
		        {label:"<spring:message code='user.title.userdept.dept.name.kr' />",	name:'deptNm',		align:'left',    width:'7000'},		/* 학과/부서명 (KR) */
			]
		};
		$("form[name=excelForm]").remove();
		var url  = "/user/userMgr/deptExcelDownload.do";
		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "excelForm");
		form.attr("action", url);
		form.append($('<input/>', {type: 'hidden', name: 'useYn', 		value: "Y"}));
		form.append($('<input/>', {type: 'hidden', name: 'searchValue',	value: $("#searchValue").val()}));
		form.append($('<input/>', {type: 'hidden', name: 'excelGrid', 	value: JSON.stringify(excelGrid)}));
		form.appendTo("body");
		form.submit();
	}
	
	// 파일로 등록
	function deptExcelUpload() {
		$("#deptExcelUploadForm").attr("target", "deptExcelUploadPopIfm");
        $("#deptExcelUploadForm").attr("action", "/user/userMgr/deptExcelUploadPop.do");
        $("#deptExcelUploadForm").submit();
        $('#deptExcelUploadPop').modal('show');
	}
	
	//사용여부
	function togleUseYn(obj_id) {
		var useYn = "Y";
		if($("#"+obj_id+"").is(":checked")) {
			useYn = "N"; 
		} 
		var deptCd = obj_id.substr(obj_id.indexOf('_')+1);
		$.getJSON("/user/userMgr/editUseYn.do",
			{
				"deptCd" : deptCd
				, "useYn" : useYn
			},
			function(data){
				if(data.result > 0) {
					if(useYn == "N") {
						/* 사용 여부를 미사용으로 변경 하였습니다. */
						alert("<spring:message code='crs.no.use.type.setting.undisclosed'/>");
					} else if(useYn == "Y") {
						/* 사용 여부를 사용으로 변경 하였습니다. */
						alert("<spring:message code='crs.no.use.type.setting.disclosed'/>");
					}
				} else {
					/* 사용 여부 설정 실패하였습니다. */
					alert("<spring:message code='crs.use.type.setting.fail'/>");
				}
			}
		);
	}
</script>

<body>
<form id="deptExcelUploadForm" method="POST"></form>
    <div id="wrap" class="pusher">

 		<!-- header -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
        <!-- //header -->

		<!-- lnb -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
        <!-- //lnb -->

        <div id="container">

            <!-- 본문 content 부분 -->
            <div class="content stu_section">

				<!-- admin_location -->
                <%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
                <!-- //admin_location -->
        		
        		<div class="ui form">
        			<div class="layout2">
		                <div id="info-item-box">
		                    <h2 class="page-title"><spring:message code="user.title.userdept.dept.manage" /></h2><!-- 학과/부서 관리 -->
		                    <div class="button-area">
                            	<a href="javascript:deptExcelDown()" class="btn"><spring:message code="button.download.excel"/></a><%-- 엑셀 다운로드 --%>
                            	<a href="javascript:deptExcelUpload()" class="btn"><spring:message code="common.label.upload.for.file"/></a><%-- 파일로 등록 --%>
                        	</div>
		                </div>
		        		<div class="row">
		        			<div class="col">
		        				<div class="option-content">
		        					<div class="ui action input search-box">
									    <input type="text" placeholder="<spring:message code='user.message.search.input.userdept.code.nm' />" class="w250" id="searchValue"><!-- 코드/학과명 입력 -->
									    <button class="ui icon button" onclick="listDept(1)"><i class="search icon"></i></button>
									</div>
									<div class="mla">
									    <select class="ui dropdown mr5 list-num" id="listScale" onchange="listDept(1)">
									        <option value="10">10</option>
									        <option value="20">20</option>
									        <option value="50">50</option>
									        <option value="100">100</option>
									    </select>
									</div>
		        				</div>
		        				<div class="fields five column align-items-end">
		        					<div class="field">
		        						<label class="req"><spring:message code="user.title.userdept.dept.code" /></label><!-- 학과/부서 코드 -->
		        						<div class="ui input">
                                        	<input type="text" id="deptCd" name="deptCd">
                                    	</div>
		        					</div>
		        					<div class="field">
		        						<label><spring:message code="user.title.userdept.par.dept.code" /></label><!-- 상위 학과/부서 코드 -->
										<select class="ui dropdown" id="parDeptCd" name="parDeptCd">
	                                        <option value=""><spring:message code="common.label.select"/></option><%-- 선택하세요 --%>
	                                        <c:forEach items="${deptList}" var="item">
	                                        	<option value="${item.deptCd}">${item.deptNm}</option>
	                                        </c:forEach>
                                    	</select>
				        				
		        					</div>
		        					<div class="field">
		        						<label class="req"><spring:message code="user.title.userdept.dept.name.kr" /></label><!-- 학과/부서명 (KR) -->
		        						<div class="ui input">
                                        	<input type="text" id="deptNm" name="deptNm">
                                    	</div>
		        					</div>
		        					<%-- 
		        					<div class="field">
		        						<label class="req"><spring:message code="user.title.userdept.dept.name.en" /></label><!-- 학과/부서명 (EN) -->
										<div class="ui input mr10" style="width: calc(100% - 100px)">
                                        	<input type="text" id="deptNmEn" name="deptNmEn">
                                    	</div>
		        					</div> 
		        					--%>
		        					<a href="javascript:addDept()" id="deptBtn" class="ui basic button"><spring:message code="user.button.save" /></a><!-- 저장 -->
		        					<a href="javascript:clearDeptForm()" id="clearDeptBtn" class="ui basic button"><spring:message code="user.button.cancel" /></a><!-- 취소 -->
		        				</div>
		        				<div id="listDiv"></div>
		        			</div>
		        		</div>
        			</div>
        		</div>
			</div>
        </div>
        <!-- //본문 content 부분 -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
    
    <!-- 학과/부서 엑셀 업로드 팝업 --> 
	<div class="modal fade" id="deptExcelUploadPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="user.title.userdept.upload.excel.pop" />" aria-hidden="false">
	    <div class="modal-dialog modal-lg" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="common.button.close" />"><!-- 닫기 -->
	                    <span aria-hidden="true">&times;</span>
	                </button>
	                <h4 class="modal-title"><spring:message code="user.title.userdept.upload.excel.pop" /></h4><!-- 학과/부서 엑셀 업로드 -->
	            </div>
	            <div class="modal-body">
	                <iframe src="" id="deptExcelUploadPopIfm" name="deptExcelUploadPopIfm" width="100%" scrolling="no"></iframe>
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