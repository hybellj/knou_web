<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/exrcs_sddn_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="admin"/>
		<jsp:param name="module" value="table,editor"/>
	</jsp:include>

	<script type="text/javascript">
		const editors = {};

		$(document).ready(function () {
			// 학사년도
			$('#dgrsYr').on('change', function() {
				selectOption.smstrChrt("${empty vo.exrcsSddnQstnBscId ? '' : vo.smstrChrtId}")
			    .then(() => selectOption.sbjct("${empty vo.exrcsSddnQstnBscId ? '' : vo.sbjctId}"))
			    .then(() => lctrWknoListSelect())
			    .catch(() => {});
		    });

			// 학기기수
			$('#smstrChrtId').on('change', function() {
				selectOption.sbjct("${empty vo.exrcsSddnQstnBscId ? '' : vo.sbjctId}")
			    .then(() => lctrWknoListSelect())
			    .catch(() => {});
		    });

			selectOption.smstrChrt("${empty vo.exrcsSddnQstnBscId ? '' : vo.smstrChrtId}")
		    .then(() => selectOption.sbjct("${empty vo.exrcsSddnQstnBscId ? '' : vo.sbjctId}"))
		    .then(() => lctrWknoListSelect())
		    .catch(() => {});

			if(${empty vo.exrcsSddnQstnBscId}) {
				sddnOption.qstnAddFrmView();
			} else {
				sddnOption.qstnModFrmView("${vo.exrcsSddnQstnBscId}", "${qstnId}");
			}
		});

		// 주차목록조회
		function lctrWknoListSelect() {
			const url  = "/quiz/admLctrWknoListAjax.do";
			const data = {
				sbjctId 	: $("#sbjctId").val()
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		let returnList = data.returnList || [];
	        		let html = "<option value=''><spring:message code='common.week' /></option>";/* 주차 */

	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
							html += "<option value='" + v.lctrWknoSchdlId + "'>" + v.lctrWknonm + "</option>";
	        			});
	        		}

	        		$("#lctrWknoSchdlId").empty().append(html);
	        		let lctrWknoSchdlId = "${not empty vo.exrcsSddnQstnBscId ? vo.lctrWknoSchdlId : ''}";
		        	$("#lctrWknoSchdlId").val(lctrWknoSchdlId).trigger("chosen:updated");
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='quiz.error.list' />", "error");	/* 리스트 조회 중 에러가 발생하였습니다. */
    		}, true);
		}

		// 돌발퀴즈유효성검사
		function sddnQuizValid() {
			UiValidator("sddnQuizRegistFrm").then(function(result) {
				if (result) {
					UiValidator("qstnWriteForm").then(function(result) {
						if (result) {
							if(!qstnOption.isValidQstn("")) {
							 	return false;
							}

							const url  = "/quiz/admSddnQuizLctrWknoRegistQstnCntSelectAjax.do";
							const data = {
								exrcsSddnQstnBscId  : "${vo.exrcsSddnQstnBscId}",
								lctrWknoSchdlId 	: $("#lctrWknoSchdlId option:selected").val(),
								qstnGbncd 			: "SURPRISE_QUIZ",
								qstnSeqno 			: $("#qstnSeqno").val(),
								sbjctId				: $("#sbjctId").val()
							};

							$.ajax({
						        url 	  	: url,
						        async	  	: false,
						        type 	  	: "POST",
						        dataType  	: "json",
						        data 	  	: JSON.stringify(data),
						        contentType	: "application/json; charset=UTF-8",
						        beforeSend	: () => UiComm.showLoading(true),
				                success		: function (data) {
				                	if(data.result == 0) {
										sddnQuizRegist();
									} else if(data.result > 0) {
										UiComm.showMessage("<spring:message code='quiz.alert.already.week.regist.qstn' />", "info");/* 해당주차에 문항이 이미 등록되어 있습니다. */
									}
				                },
				                error		: () => UiComm.showMessage("<spring:message code='quiz.error.info' />", "error"),	/* 정보 조회 중 에러가 발생하였습니다. */
				                complete	: () => UiComm.showLoading(false)
						    });
						}
					});
				}
			});
		}

		// 돌발퀴즈등록
		function sddnQuizRegist() {
			let url = "/quiz/admSddnQuizRegistAjax.do";
			if(${not empty vo.exrcsSddnQstnBscId}) {
				url = "/quiz/admSddnQuizModifyAjax.do";
			}

			ajaxCall(url, $("#sddnQuizRegistFrm").serialize() + "&" + $("#qstnWriteForm").serialize(), function(data) {
				if (data.result > 0) {
					UiComm.showMessage("<spring:message code='quiz.alert.insert' />", "info")/* 정상 저장 되었습니다. */
					.then(function(result) {
						exrcsSddnViewMv("", "ADMSDDNLIST", "SURPRISE_QUIZ");	// 관리자 돌발퀴즈 목록 화면
					});
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
			}, function(xhr, status, error) {
				if(${empty vo.exrcsSddnQstnBscId}) {
					UiComm.showMessage("<spring:message code='quiz.error.insert' />", "error");	/* 저장 중 에러가 발생하였습니다. */
				} else {
					UiComm.showMessage("<spring:message code='quiz.error.update' />", "error");	/* 수정 중 에러가 발생하였습니다. */
				}
			}, true);
		}
	</script>
</head>

<body class="admin">
    <div id="wrap" class="main">
        <!-- common header -->
        <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>
        <!-- //common header -->

        <!-- admin -->
        <main class="common">

            <!-- gnb -->
            <%@ include file="/WEB-INF/jsp/common_new/admin_aside.jsp" %>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="admin_sub">
                    <div class="sub-content qstn">
                        <div class="page-info">
                            <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                            <uiex:navibar type="admin"/>
                        </div>

						<div class="board_top">
					        <div class="right-area">
					        	<a href="javascript:sddnQuizValid()" class="btn type2"><spring:message code="common.button.save" /></a><!-- 저장 -->
					            <a href="javascript:exrcsSddnViewMv('', 'ADMSDDNLIST', 'SURPRISE_QUIZ')" class="btn type2"><spring:message code="common.button.list" /></a><!-- 목록 -->
					        </div>
				        </div>
				        <!-- table-type-->
				        <div class="table-wrap">
				        	<form id="sddnQuizRegistFrm" onsubmit="return false;">
				        		<input type="hidden" name="exrcsSddnQstnBscId"	value="${vo.exrcsSddnQstnBscId }" />
				        		<input type="hidden" name="qstnGbncd"			value="SURPRISE_QUIZ" />
					        	<table class="table-type5">
					        		<colgroup>
							        	<col class="width-20per" />
							        	<col class="" />
							        </colgroup>
							        <tbody>
							        	<tr>
							        		<th><label for="orgId"><spring:message code="common.label.org" /><!-- 기관 --></label></th>
							        		<td>
								        		<select class="form-select wide" id="orgId" disabled="true">
				                                    <c:forEach var="org" items="${orgList }">
				                                		<option value="${org.orgId }" ${org.orgId eq userCtx.orgId || org.orgId eq vo.orgId ? 'selected' : '' }>${org.orgnm }</option>
				                                	</c:forEach>
				                                </select>
							        		</td>
							        	</tr>
							        	<tr>
							        		<th><label for="smstrChrtId"><spring:message code="quiz.label.year.smstr" /><!-- 학사년도/학기 --></label></th>
							        		<td>
			                                    <select class="form-select wide" id="dgrsYr">
			                                    	<c:forEach var="year" items="${yearList }">
			                                    		<option value="${year }" ${(not empty vo.exrcsSddnQstnBscId && vo.dgrsYr eq year) || year eq curYear ? 'selected' : '' }>${year }</option>
			                                    	</c:forEach>
			                                    </select>
									        	<select class="form-select wide" id="smstrChrtId">
		                                    	</select>
							        		</td>
							        	</tr>
							        	<tr>
							        		<th><label for="sbjctId"><spring:message code="common.subject" /><!-- 과목 --></label></th>
							        		<td>
				                                <select class="form-select wide" id="sbjctId" name="sbjctId" required="true" onchange="lctrWknoListSelect()">
				                                    <option value=""><spring:message code="common.subject" /><!-- 과목 --></option>
				                                </select>
							        		</td>
							        	</tr>
							        	<tr>
							        		<th><label class="req" for="qstnTtl"><spring:message code="quiz.label.sddn.quiz.ttl" /><!-- 돌발퀴즈 제목 --></label></th>
							        		<td>
									        	<input type="text" name="qstnTtl" id="qstnTtl" inputmask="byte" maxLen="200" class="width-100per" required="true" value="${vo.qstnTtl }">
							        		</td>
							        	</tr>
							        	<tr>
							        		<th><label class="req" for="sddnQuizCts"><spring:message code="quiz.label.sddn.quiz.cts" /><!-- 돌발퀴즈 내용 --></label></th>
							        		<td>
												<div class="editor-box">
													<%-- HTML 에디터 --%>
													<textarea id="sddnQuizCts" name="sddnQuizCts" required="true"><c:out value="${vo.qstnCts}"/></textarea>
				                                    <script>
				                                        // HTML 에디터
				                                        UiEditor({
				                                            targetId: "sddnQuizCts",
				                                            uploadPath: "${vo.uploadPath}",
				                                            height: "300px"
				                                        });
				                                    </script>
												</div>
							        		</td>
							        	</tr>
							        	<tr>
							        		<th><label class="req" for="lctrWknoSchdlId"><spring:message code="common.week" /><!-- 주차 --></label></th>
							        		<td>
							        			<div class="form-row">
													<div class="input_btn">
									        			<select class="form-select" id="lctrWknoSchdlId" name="lctrWknoSchdlId" required="true">
									        				<option value=""><spring:message code="common.week" /><!-- 주차 --></option>
					                                    </select>
														<div class="form-inline">
															<small class="note2"><spring:message code="quiz.label.sddn.quiz.lctr.wkno.select.notice" /><!-- ! 돌발퀴즈를 적용할 강의동영상의 주차 선택 --></small>
														</div>
													</div>
												</div>
							        		</td>
							        	</tr>
							        	<tr>
							        		<th><label class="req" for="qstnSeqno"><spring:message code="quiz.label.qstn.no" /><!-- 문제 번호 --></label></th>
							        		<td>
							        			<div class="form-row">
													<div class="input_btn">
														<input type="text" class="w80" id="qstnSeqno" name="qstnSeqno" inputmask="numeric" maxVal="100" required="true">
														<div class="form-inline">
															<small class="note2"><spring:message code="quiz.label.input.integer.notice" /><!-- ! 자연수만 입력 가능 --></small>
														</div>
													</div>
												</div>
							        		</td>
							        	</tr>
							        </tbody>
					        	</table>
				        	</form>
				        </div>
				        <!-- //table-type-->
                    </div>
                </div>
            </div>
            <!-- //content -->
        </main>
        <!-- //admin-->
    </div>
</body>
</html>