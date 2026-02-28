<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<script type="text/javascript">
		var USER_DEPT_LIST = [];
		var IS_KNOU = <%=SessionInfo.isKnou(request)%>;
	
		$(function(){
			// 부서정보
			<c:forEach var="item" items="${deptList}">
				USER_DEPT_LIST.push({
					  deptCd: '<c:out value="${item.deptCd}" />'
					, deptNm: '<c:out value="${item.deptNm}" />'
					, deptCdOdr: '<c:out value="${item.deptCdOdr}" />'
				});
			</c:forEach>
			
			// 부서명 정렬
			USER_DEPT_LIST.sort(function(a, b) {
				if(a.deptCdOdr < b.deptCdOdr) return -1;
				if(a.deptCdOdr > b.deptCdOdr) return 1;
				if(a.deptCdOdr == b.deptCdOdr) {
					if(a.deptNm < b.deptNm) return -1;
					if(a.deptNm > b.deptNm) return 1;
				}
				return 0;
			});
			
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					onSearch(1);
				}
			});
			
			changeTerm();
		});
		
		//학기 변경
		function changeTerm() {
			$("#univGbn").off("change");
			$("#univGbn").dropdown("clear");
			
			// 학기 과목정보 조회
			var url = "/crs/creCrsHome/listCrsCreDropdown.do";
			var data = {
				  creYear	: $("#curYear").val()
				, creTerm	: $("#curTerm").val()
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					
					this["CRS_CRE_LIST"] = returnList.sort(function(a, b) {
						if(a.crsCreNm < b.crsCreNm) return -1;
						if(a.crsCreNm > b.crsCreNm) return 1;
						if(a.crsCreNm == b.crsCreNm) {
							if(a.declsNo < b.declsNo) return -1;
							if(a.declsNo > b.declsNo) return 1;
						}
						return 0;
					});
					
					// 대학 구분 변경
					changeUnivGbn("ALL");
					
					$("#univGbn").on("change", function() {
						changeUnivGbn(this.value);
					});
		    	} else {
		    		alert(data.message);
		    	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		// 대학구분 변경
		function changeUnivGbn(univGbn) {
			var deptCdObj = {};
			
			this["CRS_CRE_LIST"].forEach(function(v, i) {
				if((univGbn == "ALL" || v.univGbn == univGbn) && v.deptCd) {
					deptCdObj[v.deptCd] = true;
				}
			});
			
			var html = '<option value="ALL"><spring:message code="user.title.userdept.select" /></option>'; // 학과 선택
			USER_DEPT_LIST.forEach(function(v, i) {
				if(deptCdObj[v.deptCd]) {
					html += '<option value="' + v.deptCd + '">' + v.deptNm + '</option>';
				}
			});
			
			// 부서 초기화
			$("#deptCd").html(html);
			$("#deptCd").dropdown("clear");
		}
		
		function onSearch() {
			$("#taskDiv").hide();
		
			listTable.clearData();
			
			var param = {
					crsTypeCd    : "UNI"
				  , curYear      : $("#curYear").val()
				  , curTerm	     : $("#curTerm").val()
				  , univGbn      : ($("#univGbn").val() || "").replace("ALL", "").replace("C", "U")
				  , deptCd       : $("#deptCd").val()
				  , searchValue  : $("#searchValue").val()
				  , searchType   : "PLAN"
			}
		
			ajaxCall("/grade/gradeMgr/selectEvlStandardList.do", param, function(data) {
				if(data.returnList != null){
					var dataList = [];
					
					$.each(data.returnList, function(i, o){
						dataList.push({
							uniGbnNm: o.uniGbnNm,
							deptNm: o.deptNm,
							crsCd: o.crsCd,
							declsNo: o.declsNo,
							crsCreNm: o.crsCreNm,
							credit: o.credit,
							tchNm: (o.tchNm || "-"),
							tchNo: (o.tchNo || "-"),
							tutNm: (o.tutNm || "-"),
							tutNo: (o.tutNo || "-"),
							middleTest: o.middleTestScoreRatio,
							middleTestEx: "<span class='"+scoreRatioClass(o.middleTestScoreRatio, o.midTestCnt)+"'>" + o.midTestCnt + "</span>",
							lastTest: o.lastTestScoreRatio,
							lastTestEx: "<span class='"+scoreRatioClass(o.lastTestScoreRatio, o.lastTestCnt)+"'>" + o.lastTestCnt + "</span>",
							assignment: o.assignmentScoreRatio,
							assignmentEx: "<span class='"+scoreRatioClass(o.assignmentScoreRatio, o.asmntCnt)+"'>" + o.asmntCnt + "</span>",
							forum: o.forumScoreRatio,
							forumEx: "<span class='"+scoreRatioClass(o.forumScoreRatio, o.forumCnt)+"'>" + o.forumCnt + "</span>",
							quiz: o.quizScoreRatio,
							quizEx: "<span class='"+scoreRatioClass(o.quizScoreRatio, o.quizCnt)+"'>" + o.quizCnt + "</span>",
							resh: o.reshScoreRatio,
							reshEx: "<span class='"+scoreRatioClass(o.reshScoreRatio, o.reschCnt)+"'>" + o.reschCnt + "</span>",
							test: o.testScoreRatio,
							testEx: "<span class='"+scoreRatioClass(o.testScoreRatio, o.testCnt)+"'>" + o.testCnt + "</span>",
							manage: "<a href=\"javascript:evalCriteriaModal('" + o.crsCreCd + "')\" class='ui button mini basic'><spring:message code='common.label.eval.crit'/></a>"
						});
					});
					
					listTable.addData(dataList);
					listTable.redraw();
				}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		// 평가기준 목록 클래스 반환
		function scoreRatioClass(ratio, cnt) {
			if(ratio == "-" && cnt > 0) {
				return "fcBlue";
			} else if(ratio != "-" && cnt == 0) {
				return "fcRed"
			}
		}
		
		// 엑셀 다운로드
		function excelDown() {
			var colArr = [
				{label:'<spring:message code="main.common.number.no"/>', 													name:'lineNo', 					width:'1000'},	// NO.
				{label:'<spring:message code="contents.label.division" />', 												name:'uniGbnNm', 				width:'3000'},	// 구분
				{label:'<spring:message code="exam.label.crs.dept" />', 													name:'deptNm', 					width:'6000'},	// 관장학과
				{label:'<spring:message code="contents.label.crscd" />', 													name:'crsCd', 					width:'5000'},	// 학수번호
				{label:'<spring:message code="contents.label.decls" />', 													name:'declsNo', 				width:'2000'},	// 분반
				{label:'<spring:message code="contents.label.crscrenm" />', 												name:'crsCreNm', 				width:'8000'},	// 과목명
				{label:'<spring:message code="crs.label.credit" />', 														name:'credit', 					width:'2000'},	// 학점
				{label:'<spring:message code="common.teaching.professor" />', 												name:'tchNm', 					width:'3000'},	// 대표교수
				{label:'<spring:message code="exam.label.tch.no" />', 														name:'tchNo', 					width:'5000'},	// 교수사번
				{label:'<spring:message code="crs.label.rep.assistant" />', 												name:'tutNm', 					width:'3000'},	// 담당조교
				{label:'<spring:message code="crs.label.rep.assistant.no" />', 												name:'tutNo', 					width:'5000'}	// 조교사번
			];
			
			if (IS_KNOU) {
				colArr.push({label:'<spring:message code="crs.label.mid_exam"/>', 														name:'middleTestScoreRatio', 	width:'2500'});	// 중간고사
				colArr.push({label:'<spring:message code="crs.label.mid_exam"/> <spring:message code="score.label.enforcement" />', 	name:'midTestCnt', 				width:'2500'});	// 중간고사 시행
				colArr.push({label:'<spring:message code="crs.label.final_exam" />', 													name:'lastTestScoreRatio', 		width:'2500'});	// 기말고사
				colArr.push({label:'<spring:message code="crs.label.final_exam" /> <spring:message code="score.label.enforcement" />', 	name:'lastTestCnt', 			width:'2500'});	// 기말고사 시행);
			}
			
			colArr.push({label:'<spring:message code="crs.label.asmnt" />', 														name:'assignmentScoreRatio', 	width:'2500'});	// 과제
			colArr.push({label:'<spring:message code="crs.label.asmnt" /> <spring:message code="score.label.enforcement" />', 		name:'asmntCnt', 				width:'2500'});	// 과제 시행
			colArr.push({label:'<spring:message code="crs.label.forum" />', 														name:'forumScoreRatio', 		width:'2500'});	// 토론
			colArr.push({label:'<spring:message code="crs.label.forum" /> <spring:message code="score.label.enforcement" />', 		name:'forumCnt', 				width:'2500'});	// 토론 시행
			colArr.push({label:'<spring:message code="crs.label.quiz" />', 															name:'quizScoreRatio', 			width:'2500'});	// 퀴즈
			colArr.push({label:'<spring:message code="crs.label.quiz" /> <spring:message code="score.label.enforcement" />', 		name:'quizCnt', 				width:'2500'});	// 퀴즈 시행
			colArr.push({label:'<spring:message code="crs.label.resch" />', 														name:'reshScoreRatio', 			width:'2500'});	// 설문
			colArr.push({label:'<spring:message code="crs.label.resch" /> <spring:message code="score.label.enforcement" />', 		name:'reschCnt', 				width:'2500'});	// 설문 시행
			colArr.push({label:'<spring:message code="crs.label.attend" />', 														name:'lessonScoreRatio', 		width:'2500'});	// 출석
			
			if (IS_KNOU) {
				colArr.push({label:'<spring:message code="crs.label.nomal_exam" />', 													name:'testScoreRatio', 			width:'2500'});	// 수시평가
				colArr.push({label:'<spring:message code="crs.label.nomal_exam" /> <spring:message code="score.label.enforcement" />', 	name:'testCnt', 				width:'2500'});	// 수시평가 시행
			}
			
			var excelGrid = {colModel:colArr};
			
			$("form[name='excelForm']").remove();
			var excelForm = $('<form></form>');
			excelForm.attr("name","excelForm");
			excelForm.attr("action","/grade/gradeMgr/gradeEvlStandardPlanExcelDown.do");
			excelForm.append($('<input/>', {type: 'hidden', name: 'crsTypeCd', 		value: "UNI"}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'curYear', 		value: $("#curYear").val()}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'curTerm', 		value: $("#curTerm").val()}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'univGbn', 		value: ($("#univGbn").val() || "").replace("ALL", "")}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'deptCd', 		value: $("#deptCd").val()}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'searchValue', 	value: $("#searchValue").val()}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'searchType', 	value: "PLAN"}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', 		value:JSON.stringify(excelGrid)}));
			excelForm.appendTo('body');
			excelForm.submit();
		}
		
		// 평가기준 모달
		function evalCriteriaModal(crsCreCd) {
			$("#evalCriteriaForm > input[name='crsCreCd']").val(crsCreCd);
			$("#evalCriteriaForm").attr("target", "evalCriteriaIfm");
		    $("#evalCriteriaForm").attr("action", "/crs/evalCriteriaPop.do");
		    $("#evalCriteriaForm").submit();
		    $('#evalCriteriaModal').modal('show');
		}
		
		// 평가기준 수정  모달 콜백
		function evalCriteriaCallBack() {
			onSearch();
		}
	</script>
</head>
<body>
    <div id="wrap" class="pusher">
    	<!-- header -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
        <!-- //header -->

		<!-- lnb -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
        <!-- //lnb -->

        <div id="container">

            <!-- 본문 content 부분 -->
            <div class="content" >
            	<div class="ui form">
	                <div id="info-item-box">
	                    <h2 class="page-title">
	                    	<spring:message code="common.label.mut.eval.score" /> > <spring:message code="crs.label.eval.criteria.plan" />
	                    </h2><!-- 성적평가관리 > 평가기준 시행현황 -->
	                </div>

	                <div class="ui segment searchArea">
						<div class="fields">
							<div class="two wide field ">
								<select class="ui fluid dropdown selection" id="curYear" name="curYear" onchange="changeTerm()">
			                        <c:forEach var="yearList" items="${yearList}" varStatus="status">
							        	<option value="${yearList}" <c:if test="${yearList eq termVO.haksaYear}">selected</c:if>>${yearList}</option>
						            </c:forEach>
			                    </select>
							</div>
							<div class="three wide field ">
								<select class="ui fluid dropdown selection" id="curTerm" name="curTerm" onchange="changeTerm()">
									<c:forEach var="item" items="${termList }">
										<option value="${item.codeCd }" <c:if test="${item.codeCd eq termVO.haksaTerm }">selected</c:if>>${item.codeNm }</option>
									</c:forEach>
								</select>
							</div>
							<c:if test="${orgId eq 'ORG0000001'}">
								<div class="two wide field ">
									<select class="ui fluid dropdown selection" id="univGbn">
				                    	<option value=""><spring:message code="common.label.uni.type" /></option><!-- 대학구분 -->
					                   	<option value="ALL"><spring:message code="common.all" /></option><!-- 전체 -->
					                   	<c:forEach var="item" items="${univGbnList}">
											<option value="${item.codeCd}" ${item.codeCd}><c:out value="${item.codeNm}" /></option>
										</c:forEach>
				                    </select>
								</div>
							</c:if>
							<div class="three wide field ">
								<select class="ui fluid dropdown selection" id="deptCd" name="deptCd">
									<option value=""><spring:message code="common.dept_name" /><!-- 학과 --> <spring:message code="common.select" /><!-- 선택 --></option>
								</select>
							</div>
							<div class="six wide field ">
								<div class="ui input"><!-- 과목명/학수번호/교수명/조교명 입력 -->
									<input type="text" placeholder="<spring:message code="user.message.search.input.crscd.crsnm.tchnm.assnm" />" name="searchValue" id="searchValue" >
								</div>
							</div>
						</div>

						<div class="button-area mt10 tc">
							<a href="#" class="ui blue button w100" onclick="onSearch();"><spring:message code="exam.button.search" /></a> <!-- 검색 -->
						</div>
					</div>

					<div class="option-content gap4 mt10 mb10">
                        <div class="flex gap4 mra">
                            <div class="sec_head"><spring:message code="crs.label.eval.criteria.plan" /></div><!-- 평가기준 시행현황 -->
                        </div>
                        <div class="mla">
                        	<button type="button" class="ui green small button" onclick="excelDown()"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></button>
                        </div>
                    </div>

					<div id="listTable"></div>
   					<script>
   					var knouVisible = IS_KNOU;
   					var othVisible = (IS_KNOU ? false : true);
   					
   					var listTable = listTable = new Tabulator("#listTable", {
                    		maxHeight: "600px",
                    		minHeight: "100px",
                    		layout: "fitColumns",
                    		selectableRows: false,
                    		headerSortClickElement: "icon",
                    		renderVertical: "basic",
                    		placeholder:"<spring:message code='common.content.not_found'/>",
                    		columns: [
                    		    {title:"<spring:message code='common.number.no'/>", 			field:"lineNo", 	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:50, 		formatter:"rownum",		headerSort:false},	// NO
                    		    {title:"<spring:message code='contents.label.division'/>",		field:"uniGbnNm", 	headerHozAlign:"center", hozAlign:"center",	vertAlign:"middle", width:80,		formatter:"plaintext", 	headerSort:false},	// 구분			                        		    
                    		    {title:"<spring:message code='exam.label.crs.dept'/>", 			field:"deptNm", 	headerHozAlign:"center", hozAlign:"left",	vertAlign:"middle", minWidth:100,	formatter:"plaintext", 	headerSort:true, sorter:"string", sorterParams:{locale:"en"}}, // 관장학과
                    		    {title:"<spring:message code='contents.label.crscd'/>",			field:"crsCd", 		headerHozAlign:"center", hozAlign:"center",	vertAlign:"middle", width:100,		formatter:"plaintext", 	headerSort:true},	// 학수번호
                    		    {title:"<spring:message code='contents.label.decls'/>",			field:"declsNo", 	headerHozAlign:"center", hozAlign:"center",	vertAlign:"middle", width:50,		formatter:"plaintext", 	headerSort:false},	// 분반
                    		    {title:"<spring:message code='contents.label.crscrenm'/>",		field:"crsCreNm", 	headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:150,	formatter:"plaintext", 	headerSort:true, sorter:"string", sorterParams:{locale:"en"}, frozen:true}, // 과목명
                    		    {title:"<spring:message code='crs.label.credit'/>",				field:"credit", 	headerHozAlign:"center", hozAlign:"center",	vertAlign:"middle", width:50,		formatter:"plaintext", 	headerSort:false},	// 학점
                    		    {title:"<spring:message code='common.teaching.professor'/>",	field:"tchNm",	 	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", minWidth:80,	formatter:"plaintext",	headerSort:false},	// 대표교수
                    		    {title:"<spring:message code='common.label.prof.no'/>", 		field:"tchNo",		headerHozAlign:"center", hozAlign:"center",	vertAlign:"middle", width:80, 		formatter:"plaintext", 	headerSort:false},	// 사번
                    		    {title:"<spring:message code='crs.label.rep.assistant'/>", 		field:"tutNm",		headerHozAlign:"center", hozAlign:"center",	vertAlign:"middle", width:80, 		formatter:"plaintext", 	headerSort:false},	// 담당조교
                    		    {title:"<spring:message code='crs.label.rep.assistant.no'/>",	field:"tutNo",	 	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", minWidth:80,	formatter:"plaintext",	headerSort:false},	// 조교사번
                    		    {title:"<spring:message code='crs.label.mid_exam'/>",			field:"middleTest",	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:70,		formatter:"plaintext",	headerSort:false, visible:knouVisible},	// 중간고사 
                    		    {title:"<spring:message code='crs.label.mid_exam'/><br><spring:message code='score.label.enforcement'/>",	field:"middleTestEx",	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:70,		formatter:"html",	headerSort:false, visible:knouVisible},	// 중간고사 시행
                    		    {title:"<spring:message code='crs.label.final_exam'/>",			field:"lastTest",	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:70,		formatter:"plaintext",	headerSort:false, visible:knouVisible},	// 기말고사
                    		    {title:"<spring:message code='crs.label.final_exam'/><br><spring:message code='score.label.enforcement'/>",	field:"lastTestEx",		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:70,		formatter:"html",	headerSort:false, visible:knouVisible},	// 기말고사 시행
                    		    {title:"<spring:message code='crs.label.asmnt'/>",				field:"assignment",	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:60,		formatter:"plaintext",	headerSort:false},	// 과제 
                    		    {title:"<spring:message code='crs.label.asmnt'/><br><spring:message code='score.label.enforcement'/>",		field:"assignmentEx",	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:60,		formatter:"html",	headerSort:false},	// 과제 시행
                    		    {title:"<spring:message code='crs.label.forum'/>",				field:"forum",		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:60,		formatter:"plaintext",	headerSort:false},	// 토론
                    		    {title:"<spring:message code='crs.label.forum'/><br><spring:message code='score.label.enforcement'/>",		field:"forumEx",		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:60,		formatter:"html",	headerSort:false},	// 토론 시행
                    		    {title:"<spring:message code='crs.label.quiz'/>",				field:"quiz",		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:60,		formatter:"plaintext",	headerSort:false},	// 퀴즈 
                    		    {title:"<spring:message code='crs.label.quiz'/><br><spring:message code='score.label.enforcement'/>",		field:"quizEx",			headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:60,		formatter:"html",	headerSort:false},	// 퀴즈 시행
                    		    {title:"<spring:message code='crs.label.resch'/>",				field:"resh",		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:60,		formatter:"plaintext",	headerSort:false},	// 설문
                    		    {title:"<spring:message code='crs.label.resch'/><br><spring:message code='score.label.enforcement'/>",		field:"reshEx",			headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:60,		formatter:"html",	headerSort:false},	// 설문 시행
                    		    {title:"<spring:message code='crs.label.attend'/>",				field:"lesson",		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:60,		formatter:"plaintext",	headerSort:false},	// 출석 
                    		    {title:"<spring:message code='crs.label.nomal_exam'/>",			field:"test",		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:70,		formatter:"plaintext",	headerSort:false},	// 수시평가
                    		    {title:"<spring:message code='crs.label.nomal_exam'/><br><spring:message code='score.label.enforcement'/>",	field:"testEx",			headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:70,		formatter:"html",	headerSort:false},	// 수시평가 시행
                    		    {title:"<spring:message code='common.mgr'/>",					field:"manage",		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:70,		formatter:"html",		headerSort:false, visible:othVisible},	// 관리
                    		]
                   	});
                    </script>
	           </div>
		   	</div>
		</div>
		<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
	</div>
	<!-- 평가기준 팝업 -->
	<form id="evalCriteriaForm" name="evalCriteriaForm" method="post" style="position:absolute">
		<input type="hidden" name="crsCreCd" value="" />
	</form>
	<div class="modal fade in" id="evalCriteriaModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="crs.label.eval.criteria" /><spring:message code="exam.label.manage" />" aria-hidden="false" style="display: none; padding-right: 17px;">
	    <div class="modal-dialog modal-lg" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="common.button.close" />">
	                    <span aria-hidden="true">&times;</span>
	                </button>
	                <h4 class="modal-title"><spring:message code="crs.label.eval.criteria" /><spring:message code="exam.label.manage" /></h4>
	            </div>
	            <div class="modal-body">
	                <iframe src="" width="100%" id="evalCriteriaIfm" name="evalCriteriaIfm" title="evalCriteriaIfm"></iframe>
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