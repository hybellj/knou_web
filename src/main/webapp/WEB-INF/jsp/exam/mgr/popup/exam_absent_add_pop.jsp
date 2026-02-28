<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
		<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/table.css" />
	    <script type="text/javascript" src="/webdoc/js/iframe.js"></script>
    </head>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<script type="text/javascript">
		$(document).ready(function() {
		});
		
		// 사용자 검색
		function selectUserList() {
			parent.$("#absentAddForm").attr("target", "examPopIfm");
	        parent.$("#absentAddForm").attr("action", "/user/userMgr/studentSearchListPop.do");
	        parent.$("#absentAddForm").submit();
	        parent.$('#examPop').modal('show');
		}
		
		// 실시간시험 과목 검색
		function searchCreCrs(page) {
			if($("#searchUserId").val() == "") {
				alert("<spring:message code='exam.alert.select.std' />");/* 학습자를 선택하세요. */
				return false;
			}
			
			var url  = "/exam/examMgr/examAbsentNotApplicateList.do";
			var data = {
				"creYear"   : "${vo.creYear}",
				"creTerm"   : "${vo.creTerm}",
				"userId"	: $("#searchUserId").val(),
				"pageIndex"	: page,
				"listScale"	: 10,
				"searchType" : "${vo.searchType}"
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					var returnVO = data.returnVO;
	        		var html = "";
	        		
	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
	        				var examStartDttm = dateFormat("date", v.examStartDttm);
	        				var examAbsentCd = v.examAbsentCd != null ? v.examAbsentCd : "";
	        				html += "<tr onclick='viewCreCrs(\""+v.examCd+"\", \""+examAbsentCd+"\", this)'>";
	        				html += "	<td>"+v.examStareTypeNm+"</td>";
	        				html += "	<td>"+examStartDttm+"</td>";
	        				html += "	<td>"+v.crsDeptNm+"</td>";
	        				html += "	<td>"+v.crsCd+"</td>";
	        				html += "	<td>"+v.declsNo+"</td>";
	        				html += "	<td>"+v.crsCreNm+"</td>";
	        				html += "	<td>"+v.tchNm+"</td>";
	        				html += "</tr>";
	        			});
	        		}
	        		
	        		$("#examCreCrsList").empty().html(html);
	        		$("#userCreCrsTable").footable();
	        		var params = {
				    	totalCount 	  : data.pageInfo.totalRecordCount,
				    	listScale 	  : data.pageInfo.pageSize,
				    	currentPageNo : data.pageInfo.currentPageNo,
				    	eventName 	  : "searchCreCrs"
				    };
				    
				    gfn_renderPaging(params);
				    
				    if(returnVO != null) {
				    	$("#usrUserId").text(returnVO.userId);
				    	$("#usrUserNm").text(returnVO.userNm);
				    	$("#usrDeptNm").text(returnVO.deptNm);
				    	$("#usrMobileNo").text(returnVO.mobileNo);
				    }
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
			});
		}
		
		// 과목 선택
		function viewCreCrs(examCd, examAbsentCd, obj) {
			$("#examCreCrsList tr").removeClass("bcLblue");
			$(obj).attr("class", "bcLblue");
			var url  = "/exam/examMgr/selectCreCrsByExam.do";
			var data = {
				"examCd" : examCd,
				"userId" : $("#searchUserId").val()
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnVO = data.returnVO;
					if(returnVO != null) {
						var examStartDttm = dateFormat("date", returnVO.examStartDttm);
						$("#crsDeptNm").text(returnVO.crsDeptNm);
						$("#crsCd").text(returnVO.crsCd + " / " + returnVO.declsNo);
						$("#crsCreNm").text(returnVO.crsCreNm);
						$("#tchNm").text(returnVO.tchNm);
						$("#examStareTypeNm").text(returnVO.examStareTypeNm);
						$("#examStartDttm").text(examStartDttm);
						$("#addExamAbsentForm input[name=crsCreCd]").val(returnVO.crsCreCd);
						$("#addExamAbsentForm input[name=stdNo]").val(returnVO.stdNo);
					}
					$("#addExamAbsentForm input[name=examCd]").val(examCd);
					$("#addExamAbsentForm input[name=examAbsentCd]").val(examAbsentCd);
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert("<spring:message code='exam.error.info' />");/* 정보 조회 중 에러가 발생하였습니다. */
			});
		}
		
		// 추가
		function addExamAbsent() {
			setValue();
			
			var formValues = $("#addExamAbsentForm").serialize();
			var url  = "/exam/examMgr/examAbsentApplicate.do";
			var data = formValues;
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					alert("<spring:message code='exam.alert.add' />");/* 추가가 완료되었습니다. */
					window.parent.listExamAbsent();
					window.parent.closeModal();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='exam.error.add' />");/* 추가 중 에러가 발생하였습니다. */
			}, true);
		}
		
		// 빈 값 체크
		function nullCheck() {
			if($("#searchUserId").val() == "") {
				alert("<spring:message code='exam.alert.select.std' />");/* 학습자를 선택하세요. */
				return false;
			}
			if($("#addExamAbsentForm input[name=crsCreCd]").val() == "") {
				alert("<spring:message code='exam.alert.select.crs' />");/* 과목을 선택하세요. */
				return false;
			}
			if($.trim($("#absentCts").val()) == "") {
				alert("<spring:message code='exam.alert.absent.reason' />");/* 결시 사유를 입력하세요. */
				return false;
			}
			
			var fileUploader = dx5.get("fileUploader");
			if(fileUploader.getFileCount() == 0) {
				alert("<spring:message code='exam.alert.evidence' />");/* 증빙자료를 첨부하세요. */
				return false;
			}
			
			return true;
		}
		
		// 값 채우기
		function setValue() {
			$("#addExamAbsentForm input[name=absentCts]").val($("#absentCts").val());
			$("#addExamAbsentForm input[name=mgrCmnt]").val($("#mgrCmnt").val());
		}
		
		// 저장 확인
	    function saveConfirm() {
	    	if(!nullCheck()) {
				return false;
			}
	    	
	    	// 파일이 있으면 업로드 시작
	    	var fileUploader = dx5.get("fileUploader");
	 		if (fileUploader.getFileCount() > 0) {
				fileUploader.startUpload();
			}
			else {
				// 저장 호출
				addExamAbsent();
			}        	
	    }
	    
	 	// 파일 업로드 완료
	    function finishUpload() {
	    	var fileUploader = dx5.get("fileUploader");
	    	var url = "/file/fileHome/saveFileInfo.do";
	    	var data = {
	    		"uploadFiles" : fileUploader.getUploadFiles(),
	    		"copyFiles"   : fileUploader.getCopyFiles(),
	    		"uploadPath"  : fileUploader.getUploadPath()
	    	};
	    	
	    	ajaxCall(url, data, function(data) {
	    		if(data.result > 0) {
	    			$("#addExamAbsentForm input[name=uploadFiles]").val(fileUploader.getUploadFiles());
	    	 		$("#addExamAbsentForm input[name=copyFiles]").val(fileUploader.getCopyFiles());
	    	 		$("#addExamAbsentForm input[name=uploadPath]").val("/exam");
	    			
	    	 		addExamAbsent();
	    		} else {
	    			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    		}
	    	}, function(xhr, status, error) {
	    		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    	});
	    }
	</script>
	
	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<h3 class="pl10">
        		<c:out value="${vo.creYear }" /><spring:message code="date.year" /><!-- 년 --> 
        		<c:if test="${vo.creTerm eq 10 }"><spring:message code="common.haksa.term.spring" /></c:if>
        		<c:if test="${vo.creTerm eq 11 }"><spring:message code="common.haksa.term.summer" /></c:if>
        		<c:if test="${vo.creTerm eq 20 }"><spring:message code="common.haksa.term.fall" /></c:if>
        		<c:if test="${vo.creTerm eq 21 }"><spring:message code="common.haksa.term.winter" /></c:if>
        	</h3>
        	<div class="option-content p10">
        		<div class="ui fluid input w200">
	        		<input type="text" id="searchUserId" class="bcLgrey" placeholder="<spring:message code='exam.label.user.no' />" readonly="readonly" value="${vo.userId }" /><!-- 학번 -->
				</div>
	        	<div class="ui action input search-box">
			        <input type="text" id="searchUserNm" placeholder="<spring:message code='exam.label.user.nm' />" class="w150 bcLgrey" readonly="readonly" value="${vo.userNm }" /><!-- 이름 -->
				    <button class="ui icon button" onclick="selectUserList()"><i class="search icon"></i></button>
				</div>
				<div class="mla">
					<a href="javascript:searchCreCrs(1)" class="ui green button"><spring:message code="exam.button.search" /></a><!-- 검색 -->
				</div>
        	</div>
        	<form id="addExamAbsentForm" method="POST">
        		<input type="hidden" name="examCd" 		 value="" />
        		<input type="hidden" name="crsCreCd" 	 value="" />
        		<input type="hidden" name="stdNo" 		 value="" />
        		<input type="hidden" name="uploadFiles"  value="" />
        		<input type="hidden" name="copyFiles"	 value="" />
        		<input type="hidden" name="uploadPath"	 value="" />
        		<input type="hidden" name="examAbsentCd" value="" />
        		<input type="hidden" name="absentCts"	 value="" />
        		<input type="hidden" name="mgrCmnt"		 value="" />
        		<input type="hidden" name="absentTitle"  value="결시원 신청" />
        		<input type="hidden" name="repoCd"		 value="EXAM_SAMPLE" />
        	</form>
        	<div class="option-content p10 mt10">
        		<h3 class="sec_head"><spring:message code="exam.label.real.time.exam.crs.list" /><!-- 실시간시험 과목 목록 --></h3>
        		<table class="table mt20" data-sorting="false" data-paging="false" data-empty="<spring:message code='exam.common.empty' />" id="userCreCrsTable"><!-- 등록된 내용이 없습니다. -->
        			<thead>
        				<tr>
        					<th><spring:message code="exam.label.exam.stare.type" /><!-- 시험구분 --></th>
        					<th><spring:message code="exam.label.exam.dttm" /><!-- 시험일시 --></th>
        					<th><spring:message code="crs.label.open.dept" /><!-- 개설학과 --></th>
        					<th><spring:message code="crs.label.crs.cd" /><!-- 학수번호 --></th>
        					<th><spring:message code="crs.label.decls" /><!-- 분반 --></th>
        					<th><spring:message code="crs.label.crecrs.nm" /><!-- 과목명 --></th>
        					<th><spring:message code="exam.label.tch.nm" /><!-- 교수명 --></th>
        				</tr>
        			</thead>
        			<tbody id="examCreCrsList">
        			</tbody>
        		</table>
	        	<div id="paging" class="paging" style="margin:auto;"></div>
        	</div>
        	<div class="option-content p10">
        		<h3 class="sec_head"><spring:message code="exam.label.std.info" /><!-- 학생정보 --></h3>
        		<ul class="sixteen wide field tbl dt-sm mt10">
        			<li id="viewUser">
        				<dl>
        					<dt><spring:message code="exam.label.user.no" /><!-- 학번 --></dt>
        					<dd id="usrUserId"></dd>
        					<dt><spring:message code="exam.label.user.nm" /><!-- 이름 --></dt>
        					<dd id="usrUserNm"></dd>
        				</dl>
        				<dl>
        					<dt><spring:message code="exam.label.dept" /><!-- 학과 --></dt>
        					<dd id="usrDeptNm"></dd>
        					<dt><spring:message code="exam.label.mobile.no" /><!-- 연락처 --></dt>
        					<dd id="usrMobileNo"></dd>
        				</dl>
        			</li>
        		</ul>
        		<h3 class="sec_head mt20"><spring:message code="crs.label.crecrs.info" /><!-- 과목정보 --></h3>
        		<ul class="sixteen wide field tbl dt-sm mt10">
        			<li id="viewCreCrs">
        				<dl>
        					<dt><spring:message code="crs.label.open.dept" /><!-- 개설학과 --></dt>
        					<dd id="crsDeptNm"></dd>
        					<dt><spring:message code="crs.label.crs.cd" /><!-- 학수번호 -->/<spring:message code="crs.label.decls" /><!-- 분반 --></dt>
        					<dd id="crsCd"></dd>
        				</dl>
        				<dl>
        					<dt><spring:message code="crs.label.crecrs.nm" /><!-- 과목명 --></dt>
        					<dd id="crsCreNm"></dd>
        					<dt><spring:message code="exam.label.tch.nm" /><!-- 교수명 --></dt>
        					<dd id="tchNm"></dd>
        				</dl>
        				<dl>
        					<dt><spring:message code="exam.label.exam.stare.type" /><!-- 시험구분 --></dt>
        					<dd id="examStareTypeNm"></dd>
        					<dt><spring:message code="exam.label.exam.dttm" /><!-- 시험일시 --></dt>
        					<dd id="examStartDttm"></dd>
        				</dl>
        			</li>
        		</ul>
        		<h3 class="sec_head mt20"><spring:message code="exam.label.absent.reason" /><!-- 결시 사유 --></h3>
        		<ul class="sixteen wide field tbl dt-sm mt10">
        			<li>
        				<dl>
        					<dt class="req"><spring:message code="exam.label.absent.reason" /><!-- 결시 사유 --></dt>
        					<dd><textarea rows="5" style="resize:none;" id="absentCts"></textarea></dd>
        				</dl>
        				<dl>
        					<dt><spring:message code="exam.label.evidence" /><!-- 증빙자료 --></dt>
        					<dd>
								<uiex:dextuploader
									id="fileUploader"
									path="/exam"
									limitCount="5"
									limitSize="100"
									oneLimitSize="100"
									listSize="3"
									fileList="${fileList}"
									finishFunc="finishUpload()"
									allowedTypes="*"
								/>
        					</dd>
        				</dl>
        			</li>
        		</ul>
        		<h3 class="sec_head mt20"><spring:message code="exam.label.process.list" /><!-- 처리내역 --></h3>
        		<ul class="sixteen wide field tbl dt-sm mt10">
        			<li>
        				<dl>
        					<dt><spring:message code="exam.label.process.status" /><!-- 처리상태 --></dt>
        					<dd><spring:message code="exam.label.applicate" /><!-- 신청 --></dd>
        				</dl>
        				<dl>
        					<dt><spring:message code="exam.label.process.cts" /><!-- 처리내용 --></dt>
        					<dd><textarea rows="5" id="mgrCmnt"></textarea></dd>
        				</dl>
        			</li>
        		</ul>
        	</div>
        	
            <div class="bottom-content mt50 tc">
            	<button class="ui blue button" onclick="saveConfirm()"><spring:message code="exam.button.add" /><!-- 추가 --></button>
                <button class="ui basic button" onclick="window.parent.closeModal();"><spring:message code="exam.button.cancel" /><!-- 취소 --></button>
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
