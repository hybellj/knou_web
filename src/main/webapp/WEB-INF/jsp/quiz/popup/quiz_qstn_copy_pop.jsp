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
			$(".qstnList").css("display", "none");
			qbankCtgrList('parCtgrCd');
		});
	
		// 체크박스 이벤트
		function changeCheckBox(obj) {
			if(obj.value == "all") {
				$(".chk").prop("checked", obj.checked);
				if(obj.checked) {
					$(".chk").closest("tr").addClass("on");
				} else {
					$(".chk").closest("tr").removeClass("on");
				}
			} else {
				if(obj.checked) {
					$(obj).closest("tr").addClass("on");
				} else {
					$(obj).closest("tr").removeClass("on");
				}
				$("input:checkbox[name=allCheck]").prop("checked", $(".chk").length == $(".chk:checked").length);
			}
		}
		
		// 퀴즈 가져오기 위치 선택
		function quizCopyTypeChk() {
			var type = $("#copyType").val();
			$(".qstnList").find("input[name=allCheck]").prop("checked", false).trigger("change");
			
			// 문제 은행
			if(type == "qbank") {
				$("#qbankCopy").css("display", "list-item");
				$("#anotherCopy").css("display", "none");
				$(".copyQuizList").css("display", "none");
				$(".qstnList").css("display", "none");
				qbankCtgrList('parCtgrCd');
			// 다른 시험
			} else if(type == "another") {
				$("#qbankCopy").css("display", "none");
				$("#anotherCopy").css("display", "list-item");
				$(".copyQuizList").css("display", "none");
				$(".qstnList").css("display", "none");
			}
		}
		
		// 문제은행 분류 가져오기
		function qbankCtgrList(type) {
			$(".qstnList").find("input[name=allCheck]").prop("checked", false).trigger("change");
			var url = "/quiz/listExamQbankCtgrCd.do";
			var parExamQbankCtgrCd = type == "ctgrCd" ? $("#qbankType").val() : "";
			var searchType = type == "ctgrCd" ? "UNDER" : "UPPER";
			
			var data = {
				"searchKey" 		 : "${creCrsVO.tchNo}",
				"parExamQbankCtgrCd" : parExamQbankCtgrCd,
				"searchType"		 : searchType,
				"crsNo"				 : "${creCrsVO.crsCd}"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var html = "";
	        		
	        			html += "<option value='' selected><spring:message code='exam.label.sel.categori' /></option>";/* 분류 선택 */
		        	if(type == "parCtgrCd") {
		        		html += "<option value='-'><spring:message code='exam.label.not.categori' /></option>";	// 미분류
		        	}
	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
	        				var examCtgrNm = type == "ctgrCd" ? v.examCtgrNm : v.parExamCtgrNm;
	        				html += `<option value="\${v.examQbankCtgrCd}">\${examCtgrNm}</option>`;
	        			});
	        		}
	        		
	        		if(type == "parCtgrCd") {
	        			$("#qbankType").empty().append(html);
	        			$("#qbankType").dropdown("clear");
	        		} else if(type == "ctgrCd") {
	        			$("#qbankSubType").empty().append(html);
	        			$("#qbankSubType").dropdown("clear");
	            		$("#qbankSubType").trigger("change");
	        		}
	            } else {
	             	alert(data.message);
	            }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
    		});
		}
		
		// 문제은행 분류 선택
		function qbankTypeChk(obj) {
			if($(obj).attr("id") == "qbankType") {
				qbankCtgrList("ctgrCd");
			}
			var examQbankCtgrCd = $("#qbankType").val();
			if($("#qbankSubType").val() != null && $("#qbankSubType").val() != "") {
				examQbankCtgrCd = $("#qbankSubType").val();
			}
			
			var url  = "/quiz/qbankList.do";
			var data = {
				"parExamQbankCtgrCd" : examQbankCtgrCd
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		$(".copyQuizList").css("display", "block");
	        		$(".copyQuizList > ul.tbl-simple").show();
	        		$("div.qstnList").css("display", "none");
	    			$("table.qstnList").css("display", "none");
	    			qstnChk(obj);
	            } else {
	             	alert(data.message);
	            }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
    		});
		}
		
		// 퀴즈 학년도 학기 선택
		function userCreCrsChk(obj) {
			var url  = "/crs/creCrsHome/listTchCrsCreByTerm.do";
			var data = {
				"termCd"   : $(obj).val(),
				"crsCreCd" : "${crsCreCd}"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var html = "";
	        		
	        		if(returnList.length > 0) {
	        			html += "<option value='' selected><spring:message code='exam.label.sel.crs' /></option>";/* 과목 선택 */
	        			returnList.forEach(function(v, i) {
	        				html += `<option value="\${v.crsCreCd}">\${v.crsCreNm} (\${v.declsNo}<spring:message code="exam.label.decls" />)</option>`;/* 반 */
	        			});
	        		}
	        		
	        		$("#copyCreCrsCd").empty().append(html);
	        		$(".copyQuizList").css("display", "none");
	        		$(".qstnList").find("input[name=allCheck]").prop("checked", false).trigger("change");
	            } else {
	             	alert(data.message);
	            }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
    		});
		}
		
		// 퀴즈 과목 선택
		function creCrsQuizChk(obj) {
			var url  = "/exam/examList.do";
			var data = {
				"crsCreCd"   : $(obj).val(),
				"examCtgrCd" : "QUIZ"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var html = "";
	        		
	        		if(returnList.length > 0) {
	        			html += "<option value='' selected><spring:message code='exam.label.sel.paper' /></option>";/* 시험지 선택 */
	        			returnList.forEach(function(v, i) {
	        				html += `<option value="\${v.examCd}">\${v.examTitle}</option>`;
	        			});
	        		}
	        		
	        		$("#quizQstnPage").empty().append(html);
	        		$(".copyQuizList").css("display", "none");
	        		$(".qstnList").find("input[name=allCheck]").prop("checked", false).trigger("change");
	            } else {
	             	alert(data.message);
	            }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
    		});
		}
		
		// 퀴즈 시험지 선택
		function quizQstnPageChk(obj) {
			var url  = "/quiz/listQuizQstn.do";
			var data = {
				"examCd" : $(obj).val()
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		$(".copyQuizList").css("display", "block");
	        		$(".copyQuizList > ul.tbl-simple").hide();
	        		$(".qstnList").find("input[name=allCheck]").prop("checked", false).trigger("change");
	        		qstnChk(obj);
	            } else {
	             	alert(data.message);
	            }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
    		});
		}
		
		// 문제 선택
		function qstnChk(obj) {
			var type = $("#copyType").val();
			var examCd = "";
			var examQbankCtgrCd = "";
			var url = "";
			
			if(type == "qbank") {
				if($("#qbankSubType option:checked").val() == "" || $("#qbankSubType option:checked").val() == null || $("#qbankSubType option:checked").val() == undefined) {
					examQbankCtgrCd = $("#qbankType option:checked").val();
				} else {
					examQbankCtgrCd = $("#qbankSubType option:checked").val();
				}
				url = "/quiz/qbankQstnList.do";
			} else if(type == "another") {
				examCd = $(obj).val().split("|")[0];
				url = "/quiz/listQuizQstn.do";
			}
			
			var data   = {
				"parExamQbankCtgrCd" : examQbankCtgrCd,
				"examCd" : examCd,
				"searchKey" : "${creCrsVO.tchNo}"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var html = "";
	        		
	        		if(returnList.length > 0) { 
	        			returnList.forEach(function(v, i) {
	        				var qstnSn = "";
	        				var chkId = "";
	        				if(type == "qbank") {
	        					qstnSn = v.examQbankQstnSn;
	        					chkId  = v.examQbankQstnSn + "_" + v.examQbankCtgrCd + "_" + v.qstnNo + "_" + v.subNo;
	        				} else if(type="another") {
	        					qstnSn = v.examQstnSn;
	        					chkId  = v.examCd + "_" + v.qstnNo + "_" + v.subNo;
	        				}
	        				if($("#"+chkId).length == 0) {
	        					var copyType = $("#copyType").val();
	        					var copyCd   = type == "qbank" ? examQbankCtgrCd : $("#quizQstnPage").val();
		        				html += `<tr>`;
		        				html += `	<td>`;
		        				html += `		<div class='ui checkbox'>`; 
		        				html += `			<input type='checkbox' tabindex='0' copyCd="\${copyCd}" copyType="\${copyType}" name="qstnSn" value="\${qstnSn}" id="\${chkId}" class='hidden chk' onchange='changeCheckBox(this)'>`;
		        				html += `			<label for="\${chkId}"></label>`;
		        				html += `		</div>`;
		        				html += `	</td>`;
		        				html += `	<td class="tl">\${v.title}</td>`;
		        				html += `	<td class="tl">\${v.qstnCts == null ? "" : v.qstnCts}</td>`;
		        				html += `</tr>`;
	        				}
	        			});
	        		}
	        		
	        		$("#quizListTable tr.footable-empty").remove();
	        		$("#quizListTable").append(html);
	        		$("div.qstnList").css("display", "block");
	    			$("#quizQstnTable").footable();
	    			$(".qstnList").find("input[name=allCheck]").prop("checked", false).trigger("change");
	            } else {
	             	alert(data.message);
	            }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
    		});
		}
		
		// 문제 가져오기
		function copyQuizQstn() {
			if(!copyQstnChk()) {
				return false;
			}
			var url = "/quiz/insertCopyQstn.do";
			var copyType = "";
			var copyCd = "";
			var copyQstnSn = "";

			$("#quizListTable").find("input[name=qstnSn]:checked").each(function(i){
				if(i > 0) {
					copyQstnSn += "|";
					copyType += "|";
					copyCd += "|";
				}
				copyQstnSn += $(this).val();
				copyType += $(this).attr("copyType");
				copyCd += $(this).attr("copyCd");
			});
			
			var data = {
				"examCd" 	 : "${vo.examCd}",
				"examQstnSn" : 0,
				"qstnNo" 	 : "${qstnCnt + 1}",
				"copyType" 	 : copyType,
				"copyCd" 	 : copyCd,
				"copyQstnSn" : copyQstnSn
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					window.parent.editQstnScoreAll("${vo.examCd}");
	        		window.parent.listQuizQstn();
	        		window.parent.closeModal();
	            } else {
	             	alert(data.message);
	            }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='exam.error.copy' />");/* 가져오기 중 에러가 발생하였습니다. */
    		});
		}
		
		// 가져오기 체크 확인
		function copyQstnChk() {
			var isChk    = true;
			var copyType = $("#copyType").val();
			
			// 문제 은행
			if(copyType == "qbank") {
				if($("#qbankType").val() == "") {
					alert("<spring:message code='exam.alert.select.upper.categori' />");/* 상위 분류를 선택하세요. */
					return false;
				}
			// 다른 시험
			} else if(copyType == "another") {
				if($("#copyTermCd").val() == "") {
					alert("<spring:message code='exam.alert.select.year.term' />");/* 학년도 학기를 선택하세요. */
					return false;
				}
				if($("#copyCreCrsCd").val() == "") {
					alert("<spring:message code='exam.alert.select.crs' />");/* 과목을 선택하세요. */
					return false;
				}
				if($("#quizQstnPage").val() == "") {
					alert("<spring:message code='exam.alert.select.paper' />");/* 시험지를 선택하세요. */
					return false;
				}
			}
			
			if($("#quizListTable").find("input[name=qstnSn]:checked").length == 0) {
				alert("<spring:message code='exam.alert.select.copy.qstn' />");/* 복사할 문항을 선택하세요. */
				return false;
			}
			return isChk;
		}
		
		// 이전 버튼
		function formReset() {
			$("div.qstnList").css("display", "none");
			$("div.copyQuizList").css("display", "none");
		}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<div class="option-content pb35">
	            <ul class="tbl-simple">
					<li>
						<dl>
							<dt class="tc">
								<label for="teamLabel"><spring:message code="exam.label.locate" /></label><!-- 위치 -->
							</dt>
							<dd>
								<select class="ui dropdown wmax" id="copyType" name="copyType" onchange="quizCopyTypeChk()">
						            <option value="qbank"><spring:message code="exam.label.copy.qbank" /></option><!-- 문제은행에서 가져오기 -->
						            <option value="another"><spring:message code="exam.label.copy.another.exam" /></option><!-- 다른 퀴즈에서 가져오기 -->
						        </select>
							</dd>
						</dl>
					</li>
					<li id="qbankCopy">
						<dl class="mb20">
							<dt class="tc">
								<label for="teamLabel"><spring:message code="exam.label.sel.categori" /></label><!-- 분류 선택 -->
							</dt>
							<dd>
								<select class="ui dropdown p_w40" id="qbankType" onchange="qbankTypeChk(this)">
						            <option value=""><spring:message code="exam.label.upper.categori" /></option><!-- 상위분류 -->
						        </select>
								<select class="ui dropdown p_w40" id="qbankSubType" onchange="qbankTypeChk(this)">
						            <option value=""><spring:message code="exam.label.sub.categori" /></option><!-- 하위분류 -->
						        </select>
							</dd>
						</dl>
					</li>
					<li id="anotherCopy" style="display:none;">
						<dl class="mb20">
							<dt class="tc">
								<label for="teamLabel"><spring:message code="exam.label.open.crs.year.term" /></label><!-- 개설년도_학기 -->
							</dt>
							<dd>
								<select class="ui dropdown wmax" id="copyTermCd" onchange="userCreCrsChk(this)">
						            <option value=""><spring:message code="exam.label.open.crs.year.term" /> <spring:message code="exam.button.select" /></option><!-- 개설년도_학기 --><!-- 선택 -->
						            <c:forEach var="item" items="${termList }">
						            	<option value="${item.termCd }">
							            	${item.haksaYear }<spring:message code="exam.label.year" /> ${item.haksaTermNm }<!-- 학년도 -->
						            	</option>
						            </c:forEach>
						        </select>
							</dd>
						</dl>
						<dl class="mb20">
							<dt class="tc">
								<label for="teamLabel"><spring:message code="crs.label.crecrs" /></label><!-- 과목 -->
							</dt>
							<dd>
								<select class="ui dropdown wmax" id="copyCreCrsCd" onchange="creCrsQuizChk(this)">
						            <option value=""><spring:message code="crs.label.crecrs.sel" /></option><!-- 과목 선택 -->
						        </select>
							</dd>
						</dl>
						<dl class="mb20">
							<dt class="tc">
								<label for="teamLabel"><spring:message code="exam.label.paper" /></label><!-- 시험지 -->
							</dt>
							<dd>
								<select class="ui dropdown wmax" id="quizQstnPage" onchange="quizQstnPageChk(this)">
						            <option value=""><spring:message code="exam.label.sel.paper" /></option><!-- 시험지 선택 -->
						        </select>
							</dd>
						</dl>
					</li>
				</ul>
				<div class="ui form copyQuizList wmax" style="display:none;">
					<table class="table type2 mt20 qstnList" id="quizQstnTable" data-sorting="false" data-paging="false" data-empty="<spring:message code='exam.common.empty' />"><!-- 등록된 내용이 없습니다. -->
						<colgroup>
							<col width="5%">
							<col width="25%">
							<col width="*">
						</colgroup>
						<thead>
							<tr>
								<th scope="col" class="tr">
									<div class="ui checkbox">
										<input type="checkbox" id="allCheck" name="allCheck" value="all" tabindex="0" class="hidden" onchange="changeCheckBox(this)">
										<label for="allCheck"></label>
									</div>
								</th>
								<th scope="col"><spring:message code="exam.label.qstn" /></th><!-- 문제 -->
								<th scope="col" data-breakpoints="xs"><spring:message code="exam.label.qstn.item" /></th><!-- 보기 -->
							</tr>
						</thead>
						<tbody id="quizListTable">
						</tbody>
					</table>
					<%--
					<div class="ui segment qstnList">
						<ul class="tbl-simple">
							<li>
								<dl>
									<dt class="fcBlue"><spring:message code="exam.label.insert.new.paper" /></dt><!-- 신규생성 시험지명 -->
									<dd>
										<select class="ui dropdown" id="copyExamQstn">
											<option value="0|${qstnCnt + 1 }">새 문제로 등록</option>
											<c:forEach var="item" items="${qstnList }">
												<option value="${item.examQstnSn }|${item.qstnNo}">${item.qstnNo }<spring:message code="exam.label.no" /></option><!-- 번 -->
											</c:forEach>
								        </select>
								        <spring:message code="exam.label.insert.sub.qstn" /><!-- 문제의 후보(하위) 문항으로 등록 -->
									</dd>
								</dl>
							</li>
						</ul>
					</div>
					--%>
				</div>
        	</div>
	        
            <div class="bottom-content mt70">
                <%-- <button class="ui blue button" onclick="formReset()"><spring:message code="exam.label.prev" /></button><!-- 이전 --> --%>
                <button class="ui blue button" onclick="copyQuizQstn()"><spring:message code="exam.label.copy" /></button><!-- 가져오기 -->
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
