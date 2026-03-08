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
			qbnkCtgrList('upCtgrId');
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
				qbnkCtgrList('upCtgrId');
			// 다른 시험
			} else if(type == "another") {
				$("#qbankCopy").css("display", "none");
				$("#anotherCopy").css("display", "list-item");
				$(".copyQuizList").css("display", "none");
				$(".qstnList").css("display", "none");
			}
		}

		/**
		 * 문제은행분류 목록 조회
		 * @param {String} 	type 			- (ctgrId : 하위분류, upCtgrId : 상위분류)
		 * @param {String}  sbjctId 	- 과목개설아이디
		 * @param {String}  upQbnkCtgrId 	- 상위문제은행분류아이디
		 * @param {String}  qbnkQstnGbncd 	- 문제은행문항구분코드 ( QUIZ : 퀴즈, SRVY : 설문 )
		 * @returns {list} 문제은행분류 목록
		 */
		function qbnkCtgrList(type) {
			$(".qstnList").find("input[name=allCheck]").prop("checked", false).trigger("change");
			var url = "/qbnk/profQbnkCtgrListAjax.do";
			var upQbnkCtgrId = type == "ctgrId" ? $("#upQbnkCtgrId").val() : "";

			var data = {
				"sbjctId" 	: "${vo.sbjctId}",
				"upQbnkCtgrId" 	: upQbnkCtgrId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var html = "";

	        			html += "<option value='' selected><spring:message code='exam.label.sel.categori' /></option>";/* 분류 선택 */
		        	if(type == "upCtgrId") {
		        		html += "<option value='-'><spring:message code='exam.label.not.categori' /></option>";	// 미분류
		        	}
	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
							html += "<option value='" + v.qbnkCtgrId + "'>" + v.ctgrnm + "</option>";
	        			});
	        		}

	        		if(type == "upCtgrId") {
	        			$("#upQbnkCtgrId").empty().append(html);
	        			$("#upQbnkCtgrId").dropdown("clear");
	        		} else if(type == "ctgrId") {
	        			$("#qbnkCtgrId").empty().append(html);
	        			$("#qbnkCtgrId").dropdown("clear");
	            		//$("#qbnkCtgrId").trigger("change");
	        		}
	            } else {
	             	alert(data.message);
	            }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
    		});
		}

		/**
		 * 문제은행분류선택
		 * @param {obj}  obj - 선택한 문제은행분류
		 */
		function qbnkCtgrChc(obj) {
			if($(obj).attr("id") == "upQbnkCtgrId") {
				qbnkCtgrList("ctgrId");
			}
			var qbnkCtgrId = $("#upQbnkCtgrId").val();
			if($("#qbnkCtgrId").val() != null && $("#qbnkCtgrId").val() != "") {
				qbnkCtgrId = $("#qbnkCtgrId").val();
			}

			var url  = "/qbnk/profQstnCopyQbnkQstnListAjax.do";
			var data = {
				"qbnkCtgrId" : qbnkCtgrId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		$(".copyQuizList").css("display", "block");
	        		$(".copyQuizList > ul.tbl-simple").show();
	        		$("div.qstnList").css("display", "none");
	    			$("table.qstnList").css("display", "none");
	    			var returnList = data.returnList || [];
	    			createQuizQstnListHTML(returnList, "qbnk");	// 퀴즈문항 리스트 HTML 생성
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
				"sbjctId"  : $(obj).val(),
				"examGbncd" 	: "QUIZ"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var html = "";

	        		if(returnList.length > 0) {
	        			html += "<option value='' selected><spring:message code='exam.label.sel.paper' /></option>";/* 시험지 선택 */
	        			returnList.forEach(function(v, i) {
							html += "<option value='" + v.examDtlId + "'>" + v.examTtl + "</option>";
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
			var url  = "/quiz/profQstnCopyQuizQstnListAjax.do";
			var data = {
				"examDtlId" : $(obj).val()
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		$(".copyQuizList").css("display", "block");
	        		$(".copyQuizList > ul.tbl-simple").hide();
	        		$(".qstnList").find("input[name=allCheck]").prop("checked", false).trigger("change");
	        		var returnList = data.returnList || [];
	        		createQuizQstnListHTML(returnList, "examppr");	// 퀴즈문항 리스트 HTML 생성
	            } else {
	             	alert(data.message);
	            }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
    		});
		}

		// 퀴즈문항 리스트 HTML 생성
		function createQuizQstnListHTML(list, type) {
			var html  = "<thead>";
				html += "	<tr>";
				html += "		<th class='tr'>";
				html += "			<div class='ui checkbox'>";
				html += "				<input type='checkbox' id='allCheck' name='allCheck' value='all' tabindex='0' class='hidden' onchange='changeCheckBox(this)' />";
				html += "				<label for='allCheck'></label>";
				html += "			</div>";
				html += "		</th>";
				if(type == "qbnk") {
					html += "	<th>상위분류</th>";
					html += "	<th>하위분류</th>";
					html += "	<th>문제유형</th>";
					html += "	<th>제목</th>";
					html += "	<th>난이도</th>";
				} else if(type == "examppr") {
					html += "	<th>학사년도</th>";
					html += "	<th>학기</th>";
					html += "	<th>문제유형</th>";
					html += "	<th>문제번호</th>";
					html += "	<th>후보문제번호</th>";
					html += "	<th>제목</th>";
					html += "	<th>난이도</th>";
				}
				html += "	</tr>";
				html += "</thead>";
				html += "<tbody id='quizListTable'>";
			if(list.length > 0) {
				list.forEach(function(v, i) {
					html += "<tr>";
					html += "	<td>";
					html += "		<div class='ui checkbox'>";
					html += "			<input type='checkbox' tabindex='0' name='qstnId' data-id='" + v.qstnId + "' class='hidden chk' onchange='changeCheckBox(this)' />";
					html += "	</td>";
					if(type == "qbnk") {
						html += "<td class='tl'>" + v.upQbnkCtgrnm + "</td>";
						html += "<td class='tl'>" + v.qbnkCtgrnm + "</td>";
						html += "<td class='tl'>" + v.qstnRspnsTynm + "</td>";
						html += "<td class='tl'>" + v.qstnTtl + "</td>";
						html += "<td class='tl'>" + v.qstnDfctlvTynm + "</td>";
					} else if(type == "examppr") {
						html += "<td class='tl'></td>";
						html += "<td class='tl'></td>";
						html += "<td class='tl'></td>";
						html += "<td class='tl'></td>";
						html += "<td class='tl'></td>";
						html += "<td class='tl'></td>";
						html += "<td class='tl'></td>";
					}
					html += "</tr>";
				});
			}
				html += "</tbody>"

	        //$("#quizListTable tr.footable-empty").remove();
	        $("#quizQstnTable").empty().html(html);
	        $("#quizQstnTable").addClass("table type2");
	        $("div.qstnList").css("display", "block");
		    $("#quizQstnTable").footable();
		    $(".qstnList").find("input[name=allCheck]").prop("checked", false).trigger("change");
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
	        		window.parent.closeDialog();
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
				if($("#upQbnkCtgrId").val() == "") {
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
								<select class="ui dropdown p_w40" id="upQbnkCtgrId" onchange="qbnkCtgrChc(this)">
						            <option value=""><spring:message code="exam.label.upper.categori" /></option><!-- 상위분류 -->
						        </select>
								<select class="ui dropdown p_w40" id="qbnkCtgrId" onchange="qbnkCtgrChc(this)">
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
					<table class="mt20 qstnList" id="quizQstnTable" data-sorting="false" data-paging="false">
					</table>
				</div>
        	</div>

            <div class="bottom-content mt70">
                <button class="ui blue button" onclick="copyQuizQstn()"><spring:message code="exam.label.copy" /></button><!-- 가져오기 -->
                <button class="ui black cancel button" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
