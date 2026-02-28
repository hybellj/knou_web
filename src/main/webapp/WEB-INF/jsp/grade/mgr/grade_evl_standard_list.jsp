<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	
	<script type="text/javascript">
		var USER_DEPT_LIST = [];
		var CRS_CRE_LIST   = [];
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
			$("#deptCd").on("change", function() {
				changeDeptCd(this.value);
			});
			
			// 학과 초기화
			$("#crsCreCd").empty();
			$("#crsCreCd").dropdown("clear");
			
			// 부서변경
			changeDeptCd("ALL");
		}
		
		// 학과 변경
		function changeDeptCd(deptCd) {
			var univGbn = ($("#univGbn").val() || "").replace("ALL", "");
			var deptCd = (deptCd || "").replace("ALL", "");
			
			var html = '<option value="ALL"><spring:message code="common.subject.select" /></option>'; // 과목 선택
			
			CRS_CRE_LIST.forEach(function(v, i) {
				if((!univGbn || v.univGbn == univGbn) && (!deptCd || v.deptCd == deptCd)) {
					var declsNo = v.declsNo;
					declsNo = '(' + declsNo + ')';
					
					html += '<option value="' + v.crsCreCd + '">' + v.crsCreNm + declsNo + '</option>';
				}
			});
			
			$("#crsCreCd").html(html);
			$("#crsCreCd").dropdown("clear");
		}
		
		function onClickSearchAreaBtn(obj){
			if($(obj).hasClass("blue")){
				$(obj).removeClass("blue");
			}else{
				$(obj).addClass("blue");
			}
		}
		
		function onSearch() {
			$("#taskDiv").hide();
		
			listTable.clearData();
		
			var param = {
					crsTypeCd    : "UNI"
				  , curYear      : $("#curYear").val()
				  , curTerm	     : $("#curTerm").val()
				  , univGbn      : ($("#univGbn").val() || "").replace("ALL", "")
				  , deptCd       : ($("#deptCd").val() || "").replace("ALL", "")
				  , crsCreCd     : ($("#crsCreCd").val() || "").replace("ALL", "")
				  , searchValue  : $("#searchValue").val()
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
							tchNo: (o.tchNo || "-"),
							tchNm: (o.tchNm || "-"),
							middleTest: o.middleTestScoreRatio,
							lastTest: o.lastTestScoreRatio,
							assignment: o.assignmentScoreRatio,
							forum: o.forumScoreRatio,
							quiz: o.quizScoreRatio,
							resh: o.reshScoreRatio,
							test: o.testScoreRatio,
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
		
		function onClickEventRow(obj){
			$("#tbodyId tr").removeClass("on");
			$(obj).addClass('on');
			$("#crsCreCd").val($(obj).data('cd'));
		
			onSearchDtl();
		}
		
		function onSearchDtl(){
			ajaxCall("/grade/gradeMgr/selectStdScoreItemConfInfo.do", {crsCreCd : $("#crsCreCd").val()}, function(data) {
				if(data.returnVO != null){
					$("#lessonScoreRatio").html( (data.returnVO.lessonScoreRatio == null ? "-" : data.returnVO.lessonScoreRatio) );
					$("#middleTestScoreRatio").html( (data.returnVO.middleTestScoreRatio == null ? "-" : data.returnVO.middleTestScoreRatio) );
					$("#lastTestScoreRatio").html( (data.returnVO.lastTestScoreRatio == null ? "-" : data.returnVO.lastTestScoreRatio) );
					$("#testScoreRatio").html( (data.returnVO.testScoreRatio == null ? "-" : data.returnVO.testScoreRatio) );
					$("#assignmentScoreRatio").html( (data.returnVO.assignmentScoreRatio == null ? "-" : data.returnVO.assignmentScoreRatio) );
					$("#forumScoreRatio").html( (data.returnVO.forumScoreRatio == null ? "-" : data.returnVO.forumScoreRatio) );
					$("#quizScoreRatio").html( (data.returnVO.quizScoreRatio == null ? "-" : data.returnVO.quizScoreRatio) );
					$("#reshScoreRatio").html( (data.returnVO.reshScoreRatio == null ? "-" : data.returnVO.reshScoreRatio) );
					$("#etcScoreRatio").html( (data.returnVO.etcScoreRatio == null ? "-" : data.returnVO.etcScoreRatio) );
				} else {
					$("#lessonScoreRatio").html( "-" );
					$("#middleTestScoreRatio").html( "-" );
					$("#lastTestScoreRatio").html( "-" );
					$("#testScoreRatio").html( "-" );
					$("#assignmentScoreRatio").html( "-" );
					$("#forumScoreRatio").html( "-" );
					$("#quizScoreRatio").html( "-" );
					$("#reshScoreRatio").html( "-" );
					$("#etcScoreRatio").html( "-" );
				}
		
				$("#taskDiv").show();
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		function onEvlStandardSaveModal() {
		    $("#modalEvlForm").attr("target", "modalEvlIfm");
		    $("#modalEvlForm").attr("action", "/grade/gradeMgr/gradeEvlRegPopup.do");
		    $("#modalEvlForm").submit();
		    $("#modalEvl").modal('show');
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
	                    	<spring:message code="common.label.mut.eval.score" /> > <spring:message code="crs.label.eval.criteria" />
	                    </h2><!-- 성적평가관리 > 평가기준 -->
	                    <div class="button-area" style="<%=(!SessionInfo.isKnou(request) ? "display:none" : "")%>">
	                    	<button type="button" class="ui orange small button">ERP에서 가져오기</button>
	                    </div>
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
							<div class="three wide field ">
								<select class="ui fluid dropdown selection" id="crsCreCd" name="crsCreCd">
									<option value=""><spring:message code="common.subject" /><!-- 과목 --> <spring:message code="common.select" /><!-- 선택 --></option>
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
                            <div class="sec_head"><spring:message code="crs.label.open.crs" /></div>
                        </div>
                    </div>

					
					<div id="listTable"></div>
   					<script>
   					var knouVisible = IS_KNOU;
   					var othVisible = (IS_KNOU ? false : true);
   					
   					var listTable = new Tabulator("#listTable", {
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
                    		    {title:"<spring:message code='contents.label.crscrenm'/>",		field:"crsCreNm", 	headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:150,	formatter:"plaintext", 	headerSort:true, sorter:"string", sorterParams:{locale:"en"}}, // 과목명
                    		    {title:"<spring:message code='crs.label.credit'/>",				field:"credit", 	headerHozAlign:"center", hozAlign:"center",	vertAlign:"middle", width:50,		formatter:"plaintext", 	headerSort:false},	// 학점
                    		    {title:"<spring:message code='exam.label.tch.no'/>", 			field:"tchNo",		headerHozAlign:"center", hozAlign:"center",	vertAlign:"middle", width:80, 		formatter:"plaintext", 	headerSort:false},	// 사번
                    		    {title:"<spring:message code='common.teaching.professor'/>",	field:"tchNm",	 	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", minWidth:80,	formatter:"plaintext",	headerSort:false},	// 대표교수
                    		    {title:"<spring:message code='crs.label.mid_exam'/>",			field:"middleTest",	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:70,		formatter:"plaintext",	headerSort:false, visible:knouVisible},	// 중간고사 
                    		    {title:"<spring:message code='crs.label.final_exam'/>",			field:"lastTest",	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:70,		formatter:"plaintext",	headerSort:false, visible:knouVisible},	// 기말고사
                    		    {title:"<spring:message code='crs.label.asmnt'/>",				field:"assignment",	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:70,		formatter:"plaintext",	headerSort:false},	// 과제 
                    		    {title:"<spring:message code='crs.label.forum'/>",				field:"forum",		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:70,		formatter:"plaintext",	headerSort:false},	// 토론
                    		    {title:"<spring:message code='crs.label.quiz'/>",				field:"quiz",		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:70,		formatter:"plaintext",	headerSort:false},	// 퀴즈 
                    		    {title:"<spring:message code='crs.label.resch'/>",				field:"resh",		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:70,		formatter:"plaintext",	headerSort:false},	// 설문
                    		    {title:"<spring:message code='crs.label.attend'/>",				field:"lesson",		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:70,		formatter:"plaintext",	headerSort:false},	// 출석 
                    		    {title:"<spring:message code='crs.label.nomal_exam'/>",			field:"test",		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:70,		formatter:"plaintext",	headerSort:false},	// 수시평가
                    		    {title:"<spring:message code='common.mgr'/>",					field:"manage",		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:70,		formatter:"html",		headerSort:false, visible:othVisible},	// 관리
                    		]
                   	});
                    </script>

		            <div id="taskDiv" style="display:none;">
		            	<div class="option-content gap4 mt10 mb10">
                            <div class="flex gap4 mra">
                                <div class="sec_head"><spring:message code="crs.label.eval.criteria" />(<spring:message code="common.label.class.plan" />)</div><!-- 평가기준(수업계획서) -->
                            </div>
                            <div class="">
                                <a href="javascript:onEvlStandardSaveModal();" class="ui basic small button"><i class="paper plane outline icon"></i><spring:message code="crs.label.eval_criteria_reg" /></a><!-- 평가기준 등록 -->
                            </div>
                        </div>

                        <table class="tBasic mt10">
						    <tbody>
						        <tr>
						            <th class="p_w10"><spring:message code="crs.label.eval_item" /></th><!-- 평가항목 -->
						            <th class="p_w10"><spring:message code="crs.label.lecture" /></th><!-- 강의 -->
						            <%
						            if (SessionInfo.isKnou(request)) {
							            %>
								  	    <th class="p_w10"><spring:message code="crs.label.mid_exam" /></th><!-- 중간고사 -->
								  	    <th class="p_w10"><spring:message code="crs.label.final_exam" /></th><!-- 기말고사 -->
								  	    <th class="p_w10"><spring:message code="crs.label.nomal_exam" /></th><!-- 수시평가 -->
							  	    	<%
							  	    }
							  	    %>
							  	    <th class="p_w10"><spring:message code="crs.label.asmnt" /></th><!-- 과제 -->
								    <th class="p_w10"><spring:message code="crs.label.forum" /></th><!-- 토론 -->
								    <th class="p_w10"><spring:message code="crs.label.quiz" /></th><!-- 퀴즈 -->
								    <th class="p_w10"><spring:message code="crs.label.resch" /></th><!-- 설문 -->
								    <th class="p_w10"><spring:message code="std.label.etc" /></th><!-- 기타 -->
						        </tr>
						        <tr>
						            <th><spring:message code="crs.label.rate" /></th>	<!-- 비율 -->
						            <td id="lessonScoreRatio"></td>
						            <%
						            if (SessionInfo.isKnou(request)) {
							            %>
							            <td id="middleTestScoreRatio"></td>
							            <td id="lastTestScoreRatio"></td>
							            <td id="testScoreRatio"></td>
							            <%
							  	    }
							  	    %>
						            <td id="assignmentScoreRatio"></td>
						            <td id="forumScoreRatio"></td>
						            <td id="quizScoreRatio"></td>
						            <td id="reshScoreRatio"></td>
						            <td id="etcScoreRatio"></td>
						        </tr>
						    </tbody>
						</table>
	            	</div>

					<!-- 평가기준 팝업 -->
					<form id="evalCriteriaForm" name="evalCriteriaForm" method="post" style="">
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
			        <form class="ui form" id="modalEvlForm" name="modalEvlForm" method="POST" action="">
				        <input type="hidden" id="crsCreCd" name="crsCreCd" >
				        <!-- 팝업 -->
					    <div class="modal fade" id="modalEvl" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="crs.label.eval_criteria_reg" />" aria-hidden="false">
					        <div class="modal-dialog modal-lg" role="document">
					            <div class="modal-content">
					                <div class="modal-header">
					                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="team.common.close"/>" onclick="onSearchDtl();">
					                        <span aria-hidden="true">&times;</span>
					                    </button>
					                    <h4 class="modal-title"><spring:message code="crs.label.eval_criteria_reg" /></h4><!-- 평가기준 등록 -->
					                </div>
					                <div class="modal-body">
					                    <iframe src="" id="modalEvlIfm" name="modalEvlIfm" width="100%" scrolling="no"></iframe>
					                </div>
					            </div>
					        </div>
					    </div>
				    </form>
				    <script>
				        $('iframe').iFrameResize();
				        window.closeModal = function() {
				            $('.modal').modal('hide');
				        };
				    </script>
	           </div>
		   	</div>
		</div>
		<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
	</div>
</body>
</html>