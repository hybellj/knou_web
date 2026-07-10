<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/exrcs_sddn_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="table,editor"/>
	</jsp:include>

	<script type="text/javascript">
		const editors = {};

		$(window).on('load', function() {
			if(${empty vo.exrcsSddnQstnBscId}) {
				$(".viewDiv").hide();
			} else {
				$(".inputDiv").hide();
			}

			if(${empty vo.exrcsSddnQstnBscId || vo.qstnsCmptnyn eq 'N' }) {
				// 분반 클릭 이벤트 해제
				const checkbox = document.querySelector('input[name="sbjctIds"].readonly');
				checkbox.addEventListener('click', (e) => {
					e.preventDefault();
				});
			}

			if(${not empty vo.exrcsSddnQstnBscId}) {
				qstnListSelect();
			}
		});

		/**
		 * 분반 선택 변경
		 * @param obj - 선택한 분반 체크박스
		 */
		function dvclasChcChange(obj) {
			if(obj.value == "all") {
				$("input[name=sbjctIds]").not(".readonly").prop("checked", obj.checked);
			} else {
				$("#allDeclas").prop("checked", $("input[name=sbjctIds]").length == $("input[name=sbjctIds]:checked").length);
			}
		}

		// 연습문제등록
		function exrcsQstnRegist() {
			let validator = UiValidator("exrcsQstnRegistFrm");
			validator.then(function(result) {
				if (result) {
					let url = "/quiz/exrcsQstnRegistAjax.do";
					if(${not empty vo.exrcsSddnQstnBscId}) {
						url = "/quiz/exrcsQstnModifyAjax.do";
					}

					ajaxCall(url, $("#exrcsQstnRegistFrm").serialize(), function (data) {
		                if (data.result > 0) {
		                	UiComm.showMessage("<spring:message code='quiz.alert.insert' />", "info")/* 정상 저장 되었습니다. */
							.then(function(result) {
								exrcsSddnViewMv(data.data.exrcsSddnQstnBscId, "PROFEXRCSMODIFY", "EXRCS_QSTN");	// 교수 연습문제 수정 화면
							});
		                } else {
		                    UiComm.showMessage(data.message, "error");
		                }
		            }, function () {
		            	if(${empty vo.exrcsSddnQstnBscId}) {
							UiComm.showMessage("<spring:message code='quiz.error.insert' />", "error");	/* 저장 중 에러가 발생하였습니다. */
						} else {
							UiComm.showMessage("<spring:message code='quiz.error.update' />", "error");	/* 수정 중 에러가 발생하였습니다. */
						}
		            }, true);
				}
			});
		}

		// 모드변경
		function modeChg() {
			$("#saveBtn").text("<spring:message code='common.button.save' />");/* 저장 */
			$("#saveBtn").attr("href", "javascript:exrcsQstnRegist()");
			$(".viewDiv").hide();
			$(".inputDiv").show();
		}

		/**
		 * 문항 목록 조회
		 */
		 function qstnListSelect() {
			// 출제상태별 표시여부 변경
			const items = document.querySelectorAll('.qstnsCmptnClass');

			items.forEach(item => {
				item.classList.toggle("hide", "${vo.qstnsCmptnyn}" != "N");
			});

		 	const url  = "/quiz/quizQstnListAjax.do";
		 	const data = {
				exrcsSddnQstnBscId 	: "${vo.exrcsSddnQstnBscId}",
				qstnGbncd			: "EXRCS_QSTN"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
		     		let qstnList = data.returnList || [];
		     		let isExamSubmit = "${vo.qstnsCmptnyn}" == "M" || "${vo.qstnsCmptnyn}" == "Y";	// 문제출제완료여부
		     		let linkQstnList = [];
		     		$("#qstnCnt").text(qstnList.length > 0 ? qstnList[0].qstnCnt : 0);

		     		if(qstnList.length > 0) {
		     			let html = "";

		     			for(var i = 1; i <= qstnList[0].qstnCnt; i++) {
		     				html += "<div class='course_history qstnList' data-qstnSeqno='" + i + "'>";
		     				html += "	<div class='h_top'>";
		     				html += "		<div class='h_left'>";
		     				html += "			<h4><i class='xi-arrows m_handle mr10' aria-label='위젯 이동' role='button' tabindex='0' aria-grabbed='false'></i><spring:message code='quiz.label.qstn' /> " + i + "</h4>";	// 문제
		     				html += "		</div>";
		     				html += "		<div class='h_right'>";
		     				html += "			<a href='javascript:qstnDelete(\"${vo.exrcsSddnQstnBscId}\", \"" + i + "\")' class='btn basic type2 small'><spring:message code='common.button.delete' /></a>";/* 삭제 */
		     				html += "		</div>";
		     				html += "	</div>";
		     				html += "	<div class='question_area qstn" + i + "'>";
		     				qstnList.forEach(function(v, ii) {
			        			if(i == v.qstnSeqno) {
									html += "<div class='question_con' data-qstnSeqno='" + v.qstnSeqno + "' data-qstnCnddtSeqno='" + v.qstnCnddtSeqno + "' data-qstnId='" + v.qstnId + "'>";
									html += "	<div class='q_top'>";
									html += "		<div class='flex-item width-100per'>";
									html += "			<p class='flex-none mr15'><b>" + v.qstnSeqno + "-" + v.qstnCnddtSeqno + "</b></p>";
									html += "			<div class='flex-1 tal fcBlue cursor-pointer' onclick='exrcsOption.isExistQstnModFrm(\"" + v.exrcsSddnQstnBscId + "\", \"" + v.qstnId + "\")'>" + v.qstnTtl + "</div>";
									html += "			<p class='flex-none ml15 mr15'>" + v.qstnRspnsTynm + "</p>";
									html += "		</div>";
									html += "	</div>";
			        				html += 	previewOption.createQstnPreviewHTML(v);
			        				html += "</div>";
			        			}
			        		});
		     				html += "	</div>";
		     				html += "</div>";
		     			}
		     			$("#qstnDiv").empty().html(html);

		     			$('#qstnDiv').sortable({
		     	            connectWith: '#qstnDiv',
		     	            placeholderClass: '.qstnList',
		     	            placeholder: "portlet-placeholder",
		     	            handle: ".xi-arrows",
		     	            opacity: 0.6,
		     	            stop: function(event, ui) {
		     	            	qstnSeqnoChange(ui.item);	// 문항순번 변경
		     	            }
		     	        });
		     		} else {
		     			$("#qstnDiv").empty();
		     		}
		         }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='quiz.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
			}, true);
		}

		/**
		 * 문항 등록
		 * @param parentId 	- 문제 추가용 최상위 div 아이디
		 * @param formId 	- 문제 추가용 form 아이디
		 */
		function qstnRegist(parentId, formId) {
			UiValidator(formId).then(function(result) {
				if (result) {
					if(!qstnOption.isValidQstn("")) {
					 	return false;
					}

					const url = "/quiz/exrcsQstnBulkQstnRegistAjax.do";

					ajaxCall(url, $("#"+formId).serialize(), function (data) {
			            if (data.result > 0) {
			            	qstnListSelect();
					 		$("#"+parentId).remove();
			            } else {
			                UiComm.showMessage(data.message, "error");
			            }
			        }, function (xhr, status, error) {
			        	UiComm.showMessage("<spring:message code='quiz.error.qstn.insert' />", "error");/* 문항 등록 중 에러가 발생하였습니다. */
			        }, true);
				}
			});
	    }

		/**
		 * 문항 수정
		 * @param qstnSeqno - 문항순번
		 */
		function qstnModify(qstnSeqno) {
			let formId = "qstnWriteForm"+qstnSeqno;
			UiValidator(formId).then(function(result) {
				if (result) {
					if(!qstnOption.isValidQstn(qstnSeqno)) {
					 	return false;
					}

					const url = "/quiz/exrcsQstnBulkQstnModifyAjax.do";

					ajaxCall(url, $("#"+formId).serialize(), function (data) {
			            if (data.result > 0) {
			            	qstnListSelect();
			            } else {
			                UiComm.showMessage(data.message, "error");
			            }
			        }, function (xhr, status, error) {
			        	UiComm.showMessage("<spring:message code='quiz.error.qstn.update' />", "error");/* 문항 수정 중 에러가 발생하였습니다. */
			        }, true);
				}
			});
		}

		/**
		 * 문항순번 변경
		 * @param obj - 문항순번 변경할 문항
		 */
		function qstnSeqnoChange(obj) {
			if(!exrcsOption.canQstnEdit("edit")) {
				qstnListSelect();
				return false;
			}

			let qstnSeqno 	  	= obj.attr("data-qstnSeqno");	// 문항순번
			let newqstnSeqno 	= 1;							// 변경할 문항순번

			$("div.qstnList").each(function(i) {
				if(qstnSeqno == $(this).attr("data-qstnSeqno")) {
					newqstnSeqno = i + 1;
				}
			});

			if(qstnSeqno != newqstnSeqno) {
				const url  = "/quiz/exrcsQstnBulkQstnSeqnoModifyAjax.do";
				const data = {
					exrcsSddnQstnBscId	: "${vo.exrcsSddnQstnBscId}",
					qstnSeqno			: newqstnSeqno,
					searchKey 			: qstnSeqno
				};

				ajaxCall(url, data, function(data) {
					if (data.result > 0) {
		        		qstnListSelect();
		            } else {
		            	UiComm.showMessage(data.message, "error");
		            }
				}, function(xhr, status, error) {
					UiComm.showMessage("<spring:message code='quiz.error.qstn.sort' />", "error");/* 문제 번호 변경 중 에러가 발생하였습니다. */
				}, true);
			}
		}

		 /**
		 * 문항 삭제
		 * @param exrcsSddnQstnBscId 	- 연습돌발문항기본아이디
		 * @param qstnSeqno 			- 문항순번
		 */
		function qstnDelete(exrcsSddnQstnBscId, qstnSeqno) {
			if(!exrcsOption.canQstnEdit("edit")) {
				return false;
			}

			const url  = "/quiz/exrcsQstnBulkQstnDeleteAjax.do";
			const data = {
				exrcsSddnQstnBscId	: exrcsSddnQstnBscId,
				qstnSeqno 			: qstnSeqno
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					UiComm.showMessage("<spring:message code='quiz.alert.delete' />", "success");/* 정상 삭제되었습니다. */
					qstnListSelect();
			    } else {
			    	UiComm.showMessage(data.message, "error");
			    }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='quiz.error.qstn.delete' />", "error");/* 문항 삭제 중 에러가 발생하였습니다. */
			}, true);
		}

		// 문제 가져오기 팝업
		function qstnCopyPopup() {
			if(!exrcsOption.canQstnEdit("edit")) {
				return false;
			}

			dialog = UiDialog("dialog1", {
				title	: "<spring:message code='quiz.button.qstn.copy' />",/* 문제 가져오기 */
				width	: 800,
				height	: 650,
				url		: "/quiz/profExrcsQstnCopyPopup.do?encParams="+EPARAM+"&addParams="+UiComm.makeEncParams({exrcsSddnQstnBscId : "${vo.exrcsSddnQstnBscId}"})
			});
		}

		// 문항엑셀업로드팝업
	 	function qstnExcelUploadPopup() {
	 		if(!exrcsOption.canQstnEdit("edit")) {
	 			return false;
	 		}

	 		const data = "exrcsSddnQstnBscId=${vo.exrcsSddnQstnBscId}&qstnGbncd=EXRCS_QSTN";

			dialog = UiDialog("dialog1", {
				title		: "<spring:message code='quiz.button.excel.upload.qstn' />",/* 엑셀 문항등록 */
				width		: 600,
				height		: 500,
				url			: "/quiz/profQstnExcelUploadPopup.do?"+data,
				autoresize	: true
			});
	 	}

	 	/**
		 * 문제출제완료수정
		 * @param type	- 저장 구분 ( save : 저장, edit : 수정 )
		 */
	    function qstnsCmptnModify(type) {
			if(exrcsOption.canQstnEdit("submit")) {
				let confirmMsg = "<spring:message code='quiz.confirm.qstn.submit' />"; // 문제를 출제하시겠습니까?
				if(type == "edit") {
					confirmMsg = "<spring:message code='quiz.confirm.qstn.edit' />"; // 문제를 수정하시겠습니까?
				}
				UiComm.showMessage(confirmMsg, "confirm")
				.then(function(result) {
					if (result) {
						const url  = "/quiz/exrcsQstnsCmptnModifyAjax.do";
						const data = {
							exrcsSddnQstnBscId 	: "${vo.exrcsSddnQstnBscId}",
							searchGubun			: type
						};

						ajaxCall(url, data, function (data) {
				            if (data.result > 0) {
				            	exrcsSddnViewMv("${vo.exrcsSddnQstnBscId}", "PROFEXRCSMODIFY", "EXRCS_QSTN");	// 교수 연습문제 수정 화면
				            } else {
				                UiComm.showMessage(data.message, "error");
				            }
				        }, function (xhr, status, error) {
				        	UiComm.showMessage("<spring:message code='quiz.error.qstn.submit' />", "error");/* 문항 출제 중 에러가 발생하였습니다. */
				        }, true);
					}
				});
			}
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

		        	<div class="sub-content qstn">
				        <div class="page-info">
				        	<h2 class="page-title">
                                <spring:message code="quiz.common.exrcs.qstn" /><!-- 연습문제 -->
                            </h2>
				        </div>
				        <spring:message code="common.button.save" 	var="save" /><!-- 저장 -->
				        <spring:message code="common.button.modify"	var="modify" /><!-- 수정 -->
				        <div class="board_top">
					        <div class="right-area">
					        	<c:if test="${empty vo.exrcsSddnQstnBscId }">
					        		<a href="javascript:exrcsQstnRegist()" class="btn type2 big">${save }</a>
					        	</c:if>
					        	<c:if test="${not empty vo.exrcsSddnQstnBscId && vo.qstnsCmptnyn ne 'N' }">
					        		<a href="javascript:modeChg()" class="btn type2 big" id="saveBtn">${modify }</a>
					        	</c:if>
					            <a href="javascript:exrcsSddnViewMv('', 'PROFEXRCSLIST', 'EXRCS_QSTN')" class="btn type2 big"><spring:message code="common.button.list" /></a><!-- 목록 -->
					        </div>
				        </div>
				        <!-- table-type-->
				        <div class="table-wrap">
				        	<form id="exrcsQstnRegistFrm" onsubmit="return false;">
				        		<input type="hidden" name="encParams"			value="<c:out value='${encParams}' />"	id="encParams" />
				        		<input type="hidden" name="exrcsSddnQstnBscId"	value="${vo.exrcsSddnQstnBscId }" />
				        		<input type="hidden" name="qstnGbncd"			value="EXRCS_QSTN" />
					        	<table class="table-type5">
					        		<colgroup>
							        	<col class="width-20per" />
							        	<col class="" />
							        </colgroup>
							        <tbody>
							        	<tr>
							        		<th><label class="req" for="qstnTtl"><spring:message code="quiz.label.exrcs.qstn.ttl" /><!-- 연습문제 제목 --></label></th>
							        		<td>
							        			<div class="inputDiv">
									        		<input type="text" name="qstnTtl" id="qstnTtl" inputmask="byte" maxLen="200" class="width-100per" required="true" value="${vo.qstnTtl }">
							        			</div>
							        			<div class="viewDiv">
							        				<c:out value="${vo.qstnTtl }" />
							        			</div>
							        		</td>
							        	</tr>
							        	<tr>
							        		<th><label class="req" for="sddnQstnCts"><spring:message code="quiz.label.exrcs.qstn.cts" /><!-- 연습문제 내용 --></label></th>
							        		<td>
							        			<div class="inputDiv">
										        	<div class="editor-box">
														<%-- HTML 에디터 --%>
														<textarea id="exrcsQstnCts" name="qstnCts" required="true"><c:out value="${vo.qstnCts}"/></textarea>
			                                             <script>
			                                                 // HTML 에디터
			                                                 UiEditor({
			                                                     targetId: "exrcsQstnCts",
			                                                     uploadPath: "${vo.uploadPath}",
			                                                     height: "300px"
			                                                 });
			                                             </script>
													</div>
							        			</div>
							        			<div class="viewDiv">
							        				<div class="htmlText">${vo.qstnCts }</div>
							        			</div>
							        		</td>
							        	</tr>
							        	<c:if test="${empty vo.exrcsSddnQstnBscId || vo.qstnsCmptnyn eq 'N' }">
								        	<tr ${not empty vo.exrcsSddnQstnBscId ? 'class="cpn"' : '' }>
								        		<th><label class="req"><spring:message code="quiz.label.dvclas.batch.regist" /><!-- 분반 일괄 등록 --></label></th>
								        		<td>
								        			<div class="checkbox_type">
							        					<span class="custom-input">
															<input type="checkbox" name="allDeclasNo" value="all" id="allDeclas" onchange="dvclasChcChange(this)">
															<label for="allDeclas"><spring:message code="quiz.common.all" /><!-- 전체 --></label>
														</span>
														<c:forEach var="list" items="${dvclasList }">
													        <span class="custom-input">
																<input type="checkbox" ${list.sbjctId eq uiex:getParamValue('sbjctId') || fn:contains(sbjctIds, list.sbjctId) ? 'class="readonly" checked' : '' } name="sbjctIds" id="declas_${list.sbjctId }" value="${list.sbjctId }" onchange="dvclasChcChange(this)">
																<label for="declas_${list.sbjctId }">${list.dvclasNo }<spring:message code="quiz.label.decls" /><!-- 반 --></label>
															</span>
												        </c:forEach>
							        				</div>
								        		</td>
								        	</tr>
							        	</c:if>
							        </tbody>
					        	</table>
				        	</form>
				        </div>
				        <!-- //table-type-->

						<c:if test="${not empty vo.exrcsSddnQstnBscId }">
					        <div class="margin-top-3">
								<div class="board_top">
									<h3><spring:message code="quiz.label.submit.qstn" /><!-- 출제 문제 --> : <span id="qstnCnt">0</span><spring:message code="quiz.label.qstn" /><!-- 문제 --></h3>
									<div class="right-area" id="qstnBtnDiv">
										<c:choose>
											<c:when test="${vo.qstnsCmptnyn eq 'Y'}">
												<a href="javascript:qstnsCmptnModify('edit')" class="btn type2"><spring:message code="common.button.modify" /><!-- 수정 --></a>
											</c:when>
											<c:otherwise>
												<a href="javascript:qstnCopyPopup()" class="btn basic"><spring:message code="quiz.button.qstn.copy" /><!-- 문제 가져오기 --></a>
										        <a href="javascript:qstnExcelUploadPopup()" class="btn basic"><spring:message code="quiz.button.excel.upload.qstn" /><!-- 엑셀 문항등록 --></a>
										        <a href="javascript:qstnsCmptnModify('save')" class="btn type2"><spring:message code="quiz.button.qstn.cmptny" /><!-- 출제 완료 --></a>
											</c:otherwise>
										</c:choose>
									</div>
								</div>

								<div class="grid-content modal-type ui-sortable ml0" id="qstnDiv"></div>
							</div>

							<div class="text-center margin-top-5 margin-bottom-5">
	                            <button onclick="exrcsOption.qstnAddFrmView()" class="btn type1"><spring:message code="quiz.button.qstn.add" /></button><!-- 문제 추가 -->
	                        </div>

							<div class="msg-box qstnsCmptnClass">
								<ul class="list-dot">
	                                <li><spring:message code="quiz.label.qstn.submit.info1" /><!-- 출제완료 클릭 전에는 “임시저장” 상태입니다. --></li>
	                                <li><spring:message code="quiz.label.qstn.submit.info2" /><!-- 문항 출제 완료되면 “출제완료” 버튼을 반드시 클릭해 주세요. --></li>
	                            </ul>
							</div>
						</c:if>
				    </div>
				</div>
        	</div>
            <!-- //content -->
        </main>
        <!-- //classroom-->
    </div>
</body>
</html>