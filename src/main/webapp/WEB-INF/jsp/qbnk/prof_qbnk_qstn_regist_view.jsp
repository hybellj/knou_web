<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="editor,fileuploader"/>
	</jsp:include>

	<script type="text/javascript">
		$(document).ready(function () {
			qstnOption.qstnRspnsTycdChgChange("qstnWriteForm");	// 문항답변유형코드변경

			if(${not empty qbnkQstnVO.qbnkQstnId}) {
				qbnkQstnSetting();	// 문제은행문항설정
			}
		});

	    /**
		 * 문제은행하위분류목록조회
		 * @param qbnkCtgrId 	- 문제은행분류아이디
		 */
	    function subQbnkCtgrList(qbnkCtgrId) {
	    	const extData = {
				upQbnkCtgrId 	: qbnkCtgrId,
			};

	    	const url   = "/qbnk/profQbnkCtgrListAjax.do";
	    	const param = {
				encParams	: EPARAM,
				addParams	: UiComm.makeEncParams(extData)
			};

			ajaxCall(url, param, function(data) {
				if (data.result > 0) {
	        		let returnList = data.returnList || [];
	        		let html = "<option value=''><spring:message code='quiz.label.sub.category' /></option>";/* 하위분류 */

	        		if(returnList.length > 0 && qbnkCtgrId != "") {
	        			returnList.forEach(function(v, i) {
							html += "<option value='" + v.qbnkCtgrId + "'>" + v.ctgrnm + "</option>";
		        		});
	        		}

	        		let ctgrId = "${not empty qbnkQstnVO.upQbnkCtgrId ? qbnkQstnVO.qbnkCtgrId : ''}";
	        		$("#selectQbnkCtgrId").empty().append(html);
	        		$("#selectQbnkCtgrId").val(ctgrId).trigger("chosen:updated");
	        		$("#selectQbnkCtgrId").val(ctgrId).prop("selected", true).trigger("change");
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='quiz.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
			}, true);
	    }

	    function setValue() {
			if($("#selectQbnkCtgrId").val() == "") {
				$("#qbnkCtgrId").val($("#upQbnkCtgrId").val());
			} else {
				$("#qbnkCtgrId").val($("#selectQbnkCtgrId").val());
			}
	    }

		// 문제은행문항등록
		function qbnkQstnRegist() {
			UiValidator("qstnWriteForm").then(function(result) {
				if (result) {
					if(!qstnOption.isValidQstn("")) {
						return false;
					}

					setValue();

					let url = "/qbnk/qbnkQstnRegistAjax.do";
					if(${not empty qbnkQstnVO.qbnkQstnId}) {
						url = "/qbnk/qbnkQstnModifyAjax.do";
					}

					ajaxCall(url, $("#qstnWriteForm").serialize(), function (data) {
		                if (data.result > 0) {
		                	quizViewMv("", "QBNKLIST");
		                } else {
		                	UiComm.showMessage(data.message, "error");
		                }
		            }, function () {
		            	if(${not empty qbnkQstnVO.qbnkQstnId}) {
							 UiComm.showMessage("<spring:message code='quiz.error.qstn.update' />", "error");/* 문항 수정 중 에러가 발생하였습니다. */
						 } else {
							 UiComm.showMessage("<spring:message code='quiz.error.qstn.insert' />", "error");/* 문항 등록 중 에러가 발생하였습니다. */
						 }
		            }, true);
				}
			});
		}

		// 문제은행문항설정
		function qbnkQstnSetting() {
			// 상위, 하위분류 disabled
			let qbnkCtgrId = "${not empty qbnkQstnVO.upQbnkCtgrId ? qbnkQstnVO.upQbnkCtgrId : qbnkQstnVO.qbnkCtgrId}";
			$("#upQbnkCtgrId").val(qbnkCtgrId).trigger("change").prop("disabled", true).trigger("chosen:updated");
			$("#selectQbnkCtgrId").prop("disabled", true).trigger("chosen:updated");

			const formId 		= "qstnWriteForm";
			const qstnRspnsTycd = "${qbnkQstnVO.qstnRspnsTycd}";

		    // 난이도
		    $("#"+formId+"QstnDfctlvTycd").val("${qbnkQstnVO.qstnDfctlvTycd}").trigger("change").trigger("chosen:updated");

			// 단일, 다중선택형
	        if(qstnRspnsTycd == "ONE_CHC" || qstnRspnsTycd == "MLT_CHC") {
	        	$("#"+formId+" select[name=vwitmCnt]").val("${fn:length(qbnkQstnVwitmList)}").trigger("chosen:updated");
	    		$("#"+formId+" select[name=vwitmCnt]").val("${fn:length(qbnkQstnVwitmList)}").trigger("change");
	    		<c:forEach var="vwitm" items="${qbnkQstnVwitmList}">
	    			$("#"+formId+"Vwitm_${vwitm.vwitmSeqno}").val("${vwitm.vwitmCts}");
    				$("#"+formId+"VwitmSeqno_${vwitm.vwitmSeqno}").prop("checked", "${vwitm.cransyn}" == "Y" ? true : false);
			    </c:forEach>

	        // OX선택형
	        } else if(qstnRspnsTycd == "OX_CHC") {
	        	<c:forEach var="vwitm" items="${qbnkQstnVwitmList}">
	        		if("${vwitm.cransyn}" == "Y") $("#"+formId+" input[name='qstnVwitmCts'][value='${vwitm.vwitmCts}']").trigger("click");
			    </c:forEach>

	        // 연결형
	        } else if(qstnRspnsTycd == "LINK") {
	        	$("#"+formId+" select[name=vwitmCnt]").val("${fn:length(qbnkQstnVwitmList)}").trigger("chosen:updated");
    			$("#"+formId+" select[name=vwitmCnt]").val("${fn:length(qbnkQstnVwitmList)}").trigger("change");
    			<c:forEach var="vwitm" items="${qbnkQstnVwitmList}">
	        		if("${vwitm.cransyn}" == "Y") {
	    				$("#"+formId+"VwitmTtl_${vwitm.vwitmSeqno}").val("${fn:split(vwitm.vwitmCts, '|')[0]}");
	    				$("#"+formId+"VwitmCts_${vwitm.vwitmSeqno}").val("${fn:split(vwitm.vwitmCts, '|')[1]}");
	        		}
			    </c:forEach>

	        // 단답형
	        } else if(qstnRspnsTycd == "SHORT_TEXT") {
	        	$("#"+formId+" input[name=cransTycd]:input[value='${qbnkQstnVO.cransTycd}']").trigger("click");
	        	<c:forEach var="vwitm" items="${qbnkQstnVwitmList}" varStatus="status">
	        		if("${status.index}" > "0") qstnOption.createTextQstnAddHTML(formId, "");	// 단답형 문항 추가 HTML 추가

	        		<c:forEach items="${fn:split(vwitm.vwitmCts, '|')}" var="cts" varStatus="ctsStatus">
	        			$("."+formId+"_shortTr:eq(${status.index})").find("input[name=qstnVwitmCts]:eq(${ctsStatus.index})").val("${cts}");
		        	</c:forEach>
			    </c:forEach>
	        }
		}

		// 문제은행문항삭제
		function qbnkQstnDelete() {
			const url  = "/qbnk/qbnkQstnDeleteAjax.do";
			const data = {
				qbnkQstnId 	: "${qbnkQstnVO.qbnkQstnId}"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					quizViewMv("", "QBNKLIST");
	            } else {
	             	UiComm.showMessage(data.message, "error");
	            }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='quiz.error.qstn.delete' />", "error");/* 문항 삭제 중 에러가 발생하였습니다. */
    		}, true);
		}
	</script>
</head>

<body class="class ${uiex:getTheme()}">
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <!-- classroom -->
        <main class="common">

        	<!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
				<!-- class_sub_top -->
				<jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
				<!-- //class_sub_top -->

				<div class="class_sub">
					<!-- class_info -->
					<jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
					<!-- //class_info -->

					<div class="sub-content">
						<div class="listTab">
					        <ul>
					            <li class="select mw120"><a onclick="quizViewMv('', 'QBNKLIST')"><spring:message code="quiz.common.qbnk" /><!-- 문제은행 --></a></li>
					            <li class="mw120"><a onclick="quizViewMv('', 'QBNKCTGR')"><spring:message code="quiz.tab.category" /><!-- 분류코드 관리 --></a></li>
					        </ul>
					    </div>
		        		<div class="page-info">
				        	<h2 class="page-title">
                                <spring:message code="quiz.common.qbnk" /><!-- 문제은행 -->
                            </h2>
				        </div>
				        <div class="board_top">
				        	<h3 class="board-title"><spring:message code="common.button.create" /><!-- 등록 --></h3>
				        	<div class="right-area">
				        		<button type="button" class="btn type2" onclick="qbnkQstnRegist()"><spring:message code="common.button.save" /><!-- 저장 --></button>
				        		<c:if test="${not empty qbnkQstnVO.qbnkQstnId }">
				        			<button type="button" class="btn type2" onclick="qbnkQstnDelete()"><spring:message code="common.button.delete" /><!-- 삭제 --></button>
				        		</c:if>
				        		<button type="button" class="btn type2" onclick="quizViewMv('', 'QBNKLIST')"><spring:message code="common.button.list" /><!-- 목록 --></button>
				        	</div>
				        </div>

				        <form id="qstnWriteForm" onsubmit="return false;">
				        	<input type="hidden" name="qbnkCtgrId" 	id="qbnkCtgrId" value="${qbnkQstnVO.qbnkCtgrId }" />
				        	<input type="hidden" name="qbnkQstnId"	id="qbnkQstnId"	value="${qbnkQstnVO.qbnkQstnId }" />
				        	<input type="hidden" name="qstnScr"		value="0" />
				        	<div class="table-wrap">
					        	<table class="table-type5">
					        		<colgroup>
					        			<col class="width-15per" />
					        			<col class="" />
					        		</colgroup>
					        		<tbody>
					        			<tr>
					        				<th><label for="upQbnkCtgrId" class="req"><spring:message code="common.label.ctgr" /><!-- 분류 --></label></th>
					        				<td>
					        					<select class="form-select" name="upQbnkCtgrId" id="upQbnkCtgrId" onchange="subQbnkCtgrList(this.value)" required="true">
			                                		<option value=""><spring:message code="quiz.label.upper.category" /></option><!-- 상위분류 -->
				                                    <c:forEach var="item" items="${upQbnkCtgrList }">
										            	<option value="${item.qbnkCtgrId }">${item.ctgrnm }</option>
										            </c:forEach>
				                                </select>
			                                	<select class="form-select" name="selectQbnkCtgrId" id="selectQbnkCtgrId">
			                                		<option value=""><spring:message code="quiz.label.sub.category" /></option><!-- 하위분류 -->
				                                </select>
					        				</td>
					        			</tr>
					        			<tr>
						        			<th><label class="req"><spring:message code="common.label.crsauth.crscd" /><!-- 과목코드 -->/<spring:message code="common.subject" /><!-- 과목 --></label></th>
						        			<td>
						        				<input class="form-control" type="text" name="sbjctId" value="${qbnkSbjct.sbjctId }" readonly="true" autocomplete="off" required="true">
						        				<span>( ${qbnkSbjct.sbjctnm } ${qbnkSbjct.dvclasNo }<spring:message code="quiz.label.decls" /><!-- 반 --> )</span>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label><spring:message code="common.label.prof.no" /><!-- 교수사번 -->/<spring:message code="common.label.prof.nm" /><!-- 교수명 --></label></th>
						        			<td>
						        				<input class="form-control" type="text" name="userId" value="${qbnkSbjct.userId }" readonly="true" autocomplete="off">
						        				<span>( ${qbnkSbjct.usernm } <spring:message code="common.professor" /><!-- 교수 --> )</span>
						        			</td>
						        		</tr>
					        		</tbody>
					        	</table>
				        	</div>
							<div class="board_top" id="qstnRegistDiv">
								<h3>[ <spring:message code="quiz.button.qstn.add" /><!-- 문제 추가 --> ]</h3>
								<div class="table-wrap qstnTypeDiv">
									<table class="table-type5">
										<colgroup>
											<col class="width-15per">
											<col class="">
										</colgroup>
										<tbody>
											<tr class="titleTr notEmptyTr">
												<th><spring:message code="quiz.label.qstn" /><!-- 문제 --></th>
												<td>
													<div class="form-row gap-2">
														<input type="text" class="form-control width-80per" inputmask="byte" maxLen="200" name="qstnTtl" required="true" value="${qbnkQstnVO.qstnTtl }" />
														<select class="form-select width-20per" name="qstnRspnsTycd" onchange="qstnOption.qstnRspnsTycdChgChange('qstnWriteForm')" required="true">
															<c:forEach var="code" items="${qstnRspnsTycdList }">
																<option value="${code.cd }" ${qbnkQstnVO.qstnRspnsTycd eq code.cd ? 'selected' : '' }>${code.cdnm }</option>
															</c:forEach>
														</select>
													</div>
													<small class="note2"><spring:message code="quiz.label.another.title" /><!-- ! 기본 설정된 제목 대신 다른 제목을 넣으시면 좀 더 쉽게 문제를 구분하실 수 있습니다. --></small>
												</td>
											</tr>
											<tr class="notEmptyTr">
												<th><spring:message code="common.label.contents" /><!-- 내용 --></th>
												<td>
													<div class="editor-box">
														<textarea name="qstnCts" id="qstnCts" required="true">${qbnkQstnVO.qstnCts }</textarea>
														<script>
															// HTML 에디터
															var editor = UiEditor({
																					targetId: "qstnCts",
																					uploadPath: "${vo.uploadPath}",
																					height: "300px"
																				});
														</script>
													</div>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
				        </form>
					</div>
				</div>
            </div>
            <!-- //content -->

        </main>
        <!-- //classroom -->
    </div>
</body>
</html>