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
		const editors = {};					// 에디터 목록 저장용
		let subQuizUploaderIds = [];        // 팀별 업로더 ID 목록 (순서 보장)
        let subQuizUploadResults = {};      // { uploaderId : { uploadFiles, uploadPath, delFileIdStr, copyFiles } }

		$(window).on('load', function() {
			// 팀퀴즈수정시
			if(${not empty vo.examBscId && vo.examGbncd eq 'QUIZ_TEAM' }) {
				$("input[name='teamGrpSubasmtStngyns']").each(function(i, e) {
					let sbjctId 	= e.value.split(":")[1];							// 과목아이디
					let teamGrpId 	= $("#teamGrpId" + sbjctId).val().split(":")[0];	// 팀그룹아이디
					let teamGrpnm 	= $("#teamGrpnm" + sbjctId).val();					// 팀그룹명

					// 팀선택
					selectTeam(teamGrpId, teamGrpnm, e.value, "LOAD");
				});
			}

			// 분반선택변경
			dvclasChcChange($("#allDeclas")[0]);

			// 퀴즈등록 분반 클릭이벤트 해제
			const checkbox = document.querySelector('input[name="sbjctIds"].readonly');
			checkbox.addEventListener('click', (e) => {
				e.preventDefault();
			});

			// 재응시사용여부변경
			reexamynChange("${vo.examDtlVO.reexamyn eq 'Y' ? 'Y' : 'N'}");
		});

	 	// 이전 퀴즈 가져오기 팝업
		function bfrQuizCopyPopup() {
			dialog = UiDialog("dialog1", {
				title	: "<spring:message code='quiz.button.prev.quiz.copy' />"/* 이전퀴즈 가져오기 */,
				width	: 800,
				height	: 580,
				url		: "/quiz/profBfrQuizCopyPopup.do?encParams="+$("#encParams").val()
			});
		}

	 	/**
		 * 퀴즈가져오기
		 * @param examBscId	- 시험기본아이디
		 */
	 	function quizCopy(examBscId) {
	 		const url  = "/quiz/quizSelectAjax.do";
	 		const data = {
				examBscId : examBscId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		let quiz = data.data;

	        		$("#examTtl").val(quiz.examTtl);														// 퀴즈명
	        		editors['editor'].openHTML($.trim(quiz.examCts) == "" ? " " : quiz.examCts);			// 퀴즈 내용
	        		$("#examMnts").val(quiz.examDtlVO.examMnts);											// 퀴즈 시간
	        		$("input[name=mrkRfltyn][value='" + quiz.mrkRfltyn + "']").trigger("click");			// 성적 반영 여부
	        		$("input[name=qstnDsplyGbncd][value='" + quiz.qstnDsplyGbncd + "']").trigger("click");	// 문제 표시 방식
	        		$("#qstnRndmynChk").prop("checked", quiz.qstnRndmyn == "Y");							// 문제 섞기
	        		$("#qstnVwitmRndmynChk").prop("checked", quiz.qstnVwitmRndmyn == "Y");					// 보기 섞기
	        		$("#qstnCnddtUseynChk").prop("checked", quiz.qstnCnddtUseyn == "Y");					// 문항후보사용여부
	        		$("#searchValue").val(quiz.examDtlVO.examDtlId);										// 복사 시험기본아이디
	        		dialog.close();
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='quiz.error.copy' />", "error");/* 가져오기 중 에러가 발생하였습니다. */
			}, true);
	 	}

	 	// 저장 확인
	    function saveConfirm() {
	    	let validator = UiValidator("writeQuizForm");
			validator.then(function(result) {
				if (result) {
					let dx = dx5.get("fileUploader");
		    		if (dx.availUpload()) {
		    			dx.startUpload();
		    		} else {
		    			continueSubQuizUploadChain(0);
		    		}
				}
			});
	    }

	 	// 파일 업로드 완료
	    function finishUpload() {
	    	let url = "/common/uploadFileCheck.do"; // 업로드된 파일 검증 URL
        	let dx = dx5.get("fileUploader");
        	let data = {
        		uploadFiles : dx.getUploadFiles(),
        		uploadPath  : dx.getUploadPath()
        	};

        	// 업로드된 파일 체크
        	ajaxCall(url, data, function(data) {
        		if(data.result > 0) {
        			$("#uploadFiles").val(dx.getUploadFiles());

        			continueSubQuizUploadChain(0);
        		} else {
					UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
        		}
        	},
        	function(xhr, status, error) {
        		UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
        	}, true);
	    }

	 	// 팀그룹부퀴즈업로드처리
	    function continueSubQuizUploadChain(uploadIdx) {
            if (uploadIdx >= subQuizUploaderIds.length) {
                save();
                return;
            }

            const uploaderId = subQuizUploaderIds[uploadIdx];
            const dx = dx5.get(uploaderId);

            if (!dx) {
                subQuizUploadResults[uploaderId] = {
                    uploadFiles	: "",
                    uploadPath	: "",
                    delFileIdStr: ""
                };
                continueSubQuizUploadChain(uploadIdx + 1);
                return;
            }

            if (dx.availUpload()) {
                dx.startUpload();
            } else {
                subQuizUploadResults[uploaderId] = {
                    uploadFiles	: "",
                    uploadPath	: dx.getUploadPath(),
                    delFileIdStr: dx.getDelFileIdStr ? dx.getDelFileIdStr() : ""
                };
                continueSubQuizUploadChain(uploadIdx + 1);
            }
        }

	 	// 팀그룹부과제업로드완료
	    function onSubQuizUploadComplete(uploaderId) {

            const uploadIdx = subQuizUploaderIds.indexOf(uploaderId);
            const dx = dx5.get(uploaderId);

            const url  = "/common/uploadFileCheck.do";
            const data = {
                uploadFiles	: dx.getUploadFiles(),
                uploadPath	: dx.getUploadPath()
            };

            ajaxCall(url, data, function (resp) {
                if (resp.result > 0) {
                    subQuizUploadResults[uploaderId] = {
                        uploadFiles	: dx.getUploadFiles(),
                        uploadPath	: dx.getUploadPath(),
                        delFileIdStr: dx.getDelFileIdStr ? dx.getDelFileIdStr() : ""
                    };

                    continueSubQuizUploadChain(uploadIdx + 1);
                } else {
                    UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
                }
            }, function () {
                UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
            }, true);
        }

	    // 퀴즈 등록, 수정
	    function save() {
	    	setValue();

			let dx = dx5.get("fileUploader");
    		$("#delFileIdStr").val(dx.getDelFileIdStr()); // 삭제파일 ID 설정

			let url = "/quiz/quizRegistAjax.do";
			if(${not empty vo.examBscId}) {
				url = "/quiz/quizModifyAjax.do";
			}

			ajaxCall(url, $("#writeQuizForm").serialize(), function (data) {
                if (data.result > 0) {
                	if(${empty vo.examBscId} || ${vo.examQstnsCmptnyn ne 'Y'}) {
						UiComm.showMessage("<spring:message code='quiz.alert.qstn.mng.create.qstn' />", "info")	/* 문제관리에서 문제를 출제 해 주세요. */
						.then(function(result) {
							// 메시지 닫은후 실행
							quizViewMv(data.data.examBscId, "QSTN");	// 퀴즈 문항 관리 화면
						});
					} else {
						quizViewMv("", "LIST");	// 퀴즈 목록 화면
					}
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }, function () {
            	if(${empty vo.examBscId}) {
					UiComm.showMessage("<spring:message code='quiz.error.insert' />", "error");	/* 저장 중 에러가 발생하였습니다. */
				} else {
					UiComm.showMessage("<spring:message code='quiz.error.update' />", "error");	/* 수정 중 에러가 발생하였습니다. */
				}
            }, true);
	    }

	    // 값 채우기
	    function setValue() {
			$("#examPsblSdttm").val(UiComm.getDateTimeVal("dateSt", "timeSt") + "00");					// 퀴즈 시작일시
			$("#examPsblEdttm").val(UiComm.getDateTimeVal("dateEd", "timeEd") + "59");					// 퀴즈 종료일시
			$("#qstnRndmyn").val($("#qstnRndmynChk").is(":checked") ? "Y" : "N");						// 문제 섞기
			$("#qstnVwitmRndmyn").val($("#qstnVwitmRndmynChk").is(":checked") ? "Y" : "N");				// 보기 섞기
			$("#qstnCnddtUseyn").val($("#qstnCnddtUseynChk").is(":checked") ? "Y" : "N");				// 문항후보사용여부
			$("#dvclasRegyn").val($("input:checkbox[name=sbjctIds]:checked").length > 1 ? "Y" : "N");	// 분반 체크 여부
			$("#examGbncd").val($("#quizTeamynY").is(":checked") ? "QUIZ_TEAM" : "QUIZ");				// 퀴즈구분코드

			// 재응시사용시
			if($("#reexamynY").is(":checked")) {
				$("#reexamPsblSdttm").val(UiComm.getDateTimeVal("redateSt", "retimeSt") + "00");		// 재응시 시작일시
				$("#reexamPsblEdttm").val(UiComm.getDateTimeVal("redateEd", "retimeEd") + "59");		// 재응시 종료일시
			}

			// 팀퀴즈시
	    	if($("#quizTeamynY").is(":checked")) {
				const dtlInfos = [];
				// 팀그룹별퀴즈설정시
	    		$("input[name='teamGrpSubasmtStngyns']:checked").each(function(i, e) {
	    			$("#subInfoDiv"+e.value.split(":")[1]+" tr.subQuizTr").each(function(index, element) {
						let ttl 			= $(element).find("input[name='subExamTtl']");		// 부주제
						let teamId 			= ttl[0].id.split("_")[0];							// 팀아이디
						let uploaderId 		= "subQuizFileUploader_" + teamId + "_" + index;	// 업로더아이디
						let uploadResult 	= subQuizUploadResults[uploaderId] || {};			// 업로더상세값

						dtlInfos.push({
							id			: teamId,
							ttl			: $.trim($(ttl).val()),
							cts			: $("#"+teamId+'_subExamCts_'+index).val(),
							uploadFiles	: uploadResult.uploadFiles || "",
							uploadPath	: uploadResult.uploadPath || "${vo.uploadPath}",
							delFileIdStr: uploadResult.delFileIdStr || ""
						});
	    			});
	    		});
	    		$("#dtlInfos").val(JSON.stringify(dtlInfos));
	    	}
	    }

		/**
		 * 분반선택변경
		 * @param obj - 선택한 분반 체크박스
		 */
		function dvclasChcChange(obj) {
			if(obj.value == "all") {
				$("input[name=sbjctIds]").not(".readonly").prop("checked", obj.checked);

				if(obj.checked) {
					$("div[id^='teamGrpView']").css("display", "flex");
					$("input[name='teamGrpSubasmtStngyns']:checked").each(function(i, e) {
						$("#setQuizDiv" + e.value.split(":")[1]).show();
					});
				} else {
					let fixSbjct = $("input[name=sbjctIds]").filter(".readonly")[0].value;
					$("div[id^='teamGrpView']").not("#teamGrpView"+fixSbjct).hide();
					$("div[id^='setQuizDiv']").not("#setQuizDiv"+fixSbjct).hide();
				}
			} else {
				$("#allDeclas").prop("checked", $("input[name=sbjctIds]").length == $("input[name=sbjctIds]:checked").length);

				$("#setQuizDiv" + obj.value).toggle(obj.checked);
				if(obj.checked) {
					$("#teamGrpView" + obj.value).css("display", "flex");
				} else {
					$("#teamGrpView" + obj.value).hide();
				}
			}

			// 팀그룹 필수변경
			document.querySelectorAll('#teamQuizDiv input[name=teamGrpnm]').forEach(input => {
				if($("#quizTeamynY").is(":checked")) {
					input.setAttribute("required", $(input).is(':visible') ? "true" : "false");
				} else {
					input.setAttribute("required", "false");
				}
			});
		}

		/**
		 * 팀 퀴즈 여부 변경
		 * @param value - 팀 퀴즈 여부
		 */
		function teamynChange(value) {
			$("#teamQuizDiv").toggle(value == "Y");

			// 팀그룹 필수변경
			document.querySelectorAll('#teamQuizDiv input[name=teamGrpnm]').forEach(input => {
				if($("#quizTeamynY").is(":checked")) {
					input.setAttribute("required", $(input).is(':visible') ? "true" : "false");
				} else {
					input.setAttribute("required", "false");
				}
			});
		}

		/**
		 * 팀그룹지정 팝업
		 * @param i			- 분반 순서
		 * @param sbjctId 	- 과목아이디
		 */
	    function teamGrpChcPopup(i, sbjctId) {
			dialog = UiDialog("dialog1", {
				title	: "<spring:message code='srvy.button.assign.teams' />"/* 팀그룹지정 */,
				width	: 600,
				height	: 500,
				url		: "/team/teamHome/teamCtgrSelectPop.do?sbjctId="+sbjctId+"&searchFrom="+i + ":" + sbjctId
			});
		}

	    /**
		 * 팀선택
		 * @param teamGrpId	- 팀그룹아이디
		 * @param teamGrpnm	- 팀그룹명
		 * @param id 		- 분반 순서:과목개설아이디
		 */
	    function selectTeam(teamGrpId, teamGrpnm, id, type) {
	    	let idList = id.split(':');
	    	$("#teamGrpId" + idList[1]).val(teamGrpId + ":" + idList[1]);
	    	$("#teamGrpnm" + idList[1]).val(teamGrpnm);
	    	$("#setQuizDiv" + idList[1]).show();

	    	let bscId = type == "LOAD" ? $("#teamGrpSubasmtStngyn_" + idList[1]).data("bscid") : "";
	    	const url  = "/quiz/quizTeamGrpSubQuizListAjax.do";
	    	const data = {
				teamGrpId  	: teamGrpId,
				examBscId 	: bscId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					let returnList = data.returnList || [];
					let html = "";

	        		if(returnList.length > 0) {
						html += "<table class='table-type5 in_table'>";
						html += "	<colgroup>";
						html += "		<col class='width-5per' />";
						html += "		<col class='width-15per' />";
						html += "		<col class='' />";
						html += "	</colgroup>";
						html += "	<tbody>";
	        			returnList.forEach(function(v, i) {
							html += "	<tr class='subQuizTr'>";
							html += "		<th rowspan='3' class='group-header'><label>" + v.teamnm + "</label></th>";
							html += "		<th><label for='" + v.teamId + "_dtlExamTtl_" + i + "' class='req'><spring:message code='quiz.label.sub.title' /></label></th>";/* 부주제 */
							html += "		<td>";
							html += "			<div class='form-row'>";
							html += "				<input type='text' id='" + v.teamId + "_dtlExamTtl_" + i + "' name='subExamTtl' value='" + (v.examTtl == null ? '' : v.examTtl) + "' inputmask='byte' maxLen='200' class='form-control width-100per' />";
							html += "			</div>";
							html += "		</td>"
							html += "	</tr>";
							html += "	<tr>";
							html += "		<th><label for='" + v.teamId + "_subExamCts_" + i + "' class='req'><spring:message code='common.label.contents' /></label></th>";/* 내용 */
							html += "		<td>";
							html += "			<label class='width-100per'>";
							html += "				<textarea rows='4'";
							html += "						  class='form-control resize-none'";
							html += "						  name='" + v.teamId + "_subExamCts_" + i + "'";
							html += "						  id='" + v.teamId + "_subExamCts_" + i + "'>";
							html += 					(v.examCts == null ? '' : v.examCts);
							html += "				</textarea>";
							html += "			</label>";
							html += "		</td>";
							html += "	</tr>";
							html += "	<tr>";
							html += "		<th><label><spring:message code='common.attachments' /></label></th>";/* 첨부파일 */
							html += "		<td>";
							html += "			<div id='subQuizUploaderWrap_" + v.teamId + "_" + i + "'></div>";
							html += "		</td>";
							html += "	</tr>";
	        			});
						html += "	</tbody>";
						html += "</table>";
	        		}

	        		$("#subInfoDiv" + idList[1]).empty().html(html);
	        		/*
                     * 재조회 시 중복 방지
                     */
                    subQuizUploaderIds 		= [];
                    subQuizUploadResults 	= {};

	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
	        				// html 에디터 생성
	        				const editorId = v.teamId + "_subExamCts_" + i;
							editors[editorId] = UiEditor({
													targetId: editorId,
													uploadPath: "${vo.uploadPath}",
													height: "250px"
												});
	        			});

	        			initFileuploader(idList[1]);
	        		}
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='quiz.error.copy' />", "error");	/* 가져오기 중 에러가 발생하였습니다. */
			}, true);
	    }

	    function initFileuploader(sbjctId) {
			if($("#subInfoDiv" + sbjctId).is(":visible")) {
				$("#subInfoDiv"+sbjctId+" tr.subQuizTr").each(function(index, element) {
					let teamId 		= $(element).find("input[name='subExamTtl']")[0].id.split("_")[0];
					let uploaderId 	= "subQuizFileUploader_" + teamId + "_" + index;
					let wrapId 		= "subQuizUploaderWrap_" + teamId + "_" + index;

					if(!subQuizUploaderIds.includes(uploaderId)) {
						UiFileUploader({
			                id: uploaderId,
			                targetId: wrapId,
			                path: "${vo.uploadPath}",
			                limitCount: 5,
			                limitSize: 1024,
			                oneLimitSize: 1024,
			                listSize: 3,
			                fileList: "",
			                finishFunc: onSubQuizUploadComplete,
			                allowedTypes: "*"
			            });

						subQuizUploaderIds.push(uploaderId);
					}
    			});
			}
		}

	    /**
		 * 팀그룹 설정여부 변경
		 * @param obj - 분반 팀그룹 퀴즈 설정 체크박스
		 */
	    function teamGrpSubasmtStngynChange(obj) {
	    	$("#subInfoDiv" + obj.id.split("_")[1]).toggle(obj.checked);

	    	if(obj.checked) initFileuploader(obj.id.split("_")[1]);

	    	// 부주제, 내용 필수변경
	    	document.querySelectorAll('#subInfoDiv'+obj.id.split("_")[1]+' input[name=subExamTtl], #subInfoDiv'+obj.id.split("_")[1]+' textarea').forEach(input => {
				input.setAttribute("required", obj.checked ? "true" : "false");
			});
	    }

		/**
		 * 재응시사용여부변경
		 * @param value - 재응시 사용여부
		 */
		function reexamynChange(value) {
			$(".reexamDiv").toggle(value == "Y");

			// 재응시값 필수변경
			document.querySelectorAll('.reexamDiv input').forEach(input => {
				input.setAttribute("required", value == "Y" ? "true" : "false");
			});
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
				        <div class="page-info">
				        	<h2 class="page-title">
                                <spring:message code="quiz.common.quiz" /><!-- 퀴즈 -->
                            </h2>
				        </div>
				        <!--table-type-->
				        <spring:message code="quiz.common.yes" var="yes" /><!-- 예 -->
				        <spring:message code="quiz.common.no"  var="no" /><!-- 아니오 -->
				        <div class="table-wrap">
							<form name="writeQuizForm" id="writeQuizForm" method="POST" autocomplete="off" onsubmit="return false;">
						        <input type="hidden" name="encParams"    				value="<c:out value='${encParams}' />" 		id="encParams" />
						    	<input type="hidden" name="examBscId" 					value="${vo.examBscId }" />
						        <input type="hidden" name="examGrpId" 					value="${vo.examGrpId }" />
						        <input type="hidden" name="examDtlVO.examDtlId" 		value="${vo.examDtlVO.examDtlId }" />
						        <input type="hidden" name="mrkRfltrt" 					value="0" />
						        <input type="hidden" name="examDtlVO.cnsdrAddMnts" 		value="0" />
						        <input type="hidden" name="maxTkexamCnt" 				value="99" />
						        <input type="hidden" name="avgMrkOyn" 					value="N" />
						        <input type="hidden" name="examTycd"					value="QUIZ" />
						        <input type="hidden" name="examDtlVO.examtmLmtyn"		value="Y" />
						        <input type="hidden" name="examtmAllocGbncd"			value="REMAINDER" />
						        <input type="hidden" name="examtmExpsrTycd"				value="LEFT" />
						        <input type="hidden" name="examGbncd"					value=""									id="examGbncd" />
						        <input type="hidden" name="examDtlVO.examPsblSdttm" 	value="${vo.examDtlVO.examPsblSdttm }" 		id="examPsblSdttm" />
						        <input type="hidden" name="examDtlVO.examPsblEdttm" 	value="${vo.examDtlVO.examPsblEdttm }"  	id="examPsblEdttm" />
						        <input type="hidden" name="qstnRndmyn" 					value="${vo.qstnRndmyn }"   				id="qstnRndmyn" />
						        <input type="hidden" name="qstnVwitmRndmyn" 			value="${vo.qstnVwitmRndmyn }"   			id="qstnVwitmRndmyn" />
						        <input type="hidden" name="qstnCnddtUseyn" 				value="${vo.qstnCnddtUseyn }"   			id="qstnCnddtUseyn" />
						        <input type="hidden" name="examDtlVO.reexamPsblSdttm" 	value="${vo.examDtlVO.reexamPsblSdttm }" 	id="reexamPsblSdttm" />
						        <input type="hidden" name="examDtlVO.reexamPsblEdttm" 	value="${vo.examDtlVO.reexamPsblEdttm }"   	id="reexamPsblEdttm" />
						        <input type="hidden" name="dvclasRegyn" 				value="${vo.dvclasRegyn }"	   				id="dvclasRegyn" />
						        <input type="hidden" name="imdtAnswShtInqyn"			value=""					   				id="imdtAnswShtInqyn" />
						        <input type="hidden" name="dtlInfos" 					value=""					   				id="dtlInfos"/>
						        <input type="hidden" name="uploadFiles"  				value=""									id="uploadFiles" />
								<input type="hidden" name="uploadPath"   				value="${vo.uploadPath}"					id="uploadPath"   />
								<input type="hidden" name="delFileIdStr" 				value=""									id="delFileIdStr" />
								<input type="hidden" name="searchValue" 				value=""									id="searchValue" />
						        <table class="table-type5">
						        	<colgroup>
						        		<col class="width-15per" />
						        		<col class="" />
						        	</colgroup>
						        	<tbody>
						        		<tr>
						        			<th><label for="examTtl" class="req"><spring:message code="quiz.label.ttl" /><!-- 퀴즈명 --></label></th>
						        			<td>
						        				<input type="text" name="examTtl" id="examTtl" inputmask="byte" maxLen="200" class="width-100per" required="true" value="${vo.examTtl }">
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="contentTextArea" class="req"><spring:message code="quiz.label.cts" /><!-- 퀴즈내용 --></label></th>
						        			<td>
						        				<div class="editor-box">
													<%-- HTML 에디터 --%>
                                                    <textarea id="examCts" name="examCts" required="true"><c:out value="${vo.examCts}"/></textarea>
                                                    <script>
                                                        // HTML 에디터
                                                        editors['editor'] = UiEditor({
                                                            targetId: "examCts",
                                                            uploadPath: "${vo.uploadPath}",
                                                            height: "300px"
                                                        });
                                                    </script>
												</div>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="contLabel" class="req"><spring:message code="quiz.label.dvclas.batch.regist" /><!-- 분반 일괄 등록 --></label></th>
						        			<td>
						        				<div class="checkbox_type">
						        					<span class="custom-input">
														<input type="checkbox" name="allDeclasNo" value="all" id="allDeclas" onchange="dvclasChcChange(this)">
														<label for="allDeclas"><spring:message code="quiz.common.all" /><!-- 전체 --></label>
													</span>
													<c:forEach var="list" items="${dvclasList }">
												        <c:set var="sbjctChk" value="N" />
												        <c:forEach var="item" items="${sbjctList }">
												        	<c:if test="${item.sbjctId eq list.sbjctId }">
												        		<c:set var="sbjctChk" value="Y" />
												        	</c:if>
												        </c:forEach>
												        <span class="custom-input">
															<input type="checkbox" ${list.sbjctId eq uiex:getParamValue('sbjctId') || sbjctChk eq 'Y' ? 'class="readonly" checked' : '' } name="sbjctIds" id="declas_${list.sbjctId }" value="${list.sbjctId }" onchange="dvclasChcChange(this)">
															<label for="declas_${list.sbjctId }">${list.dvclasNo }<spring:message code="quiz.label.decls" /><!-- 반 --></label>
														</span>
											        </c:forEach>
						        				</div>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="contLabel" class="req"><spring:message code="quiz.label.set.lctr.wkno" /><!-- 강의목록 주차 설정 --></label></th>
						        			<td>
						        				<select class="form-select" name="lctrWknoSchdlId" required="true">
			                                		<option value=""><spring:message code="common.label.lesson.schedule" /><!-- 주차 --></option>
				                                    <c:forEach var="item" items="${lctrWknoList }">
										            	<option value="${item.lctrWknoSchdlId }" ${item.lctrWknoSchdlId eq vo.lctrWknoSchdlId || item.curLctrWkno eq 'Y' ? 'selected' : '' }>${item.lctrWknonm }</option>
										            </c:forEach>
				                                </select>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="dateSt" class="req"><spring:message code="quiz.label.period" /><!-- 응시기간 --></label></th>
						        			<td>
						        				<input id="dateSt" type="text" name="dateSt" class="datepicker" timeId="timeSt" toDate="dateEd" value="${fn:substring(vo.examDtlVO.examPsblSdttm,0,8)}" required="true">
												<input id="timeSt" type="text" name="timeSt" class="timepicker" dateId="dateSt" value="${fn:substring(vo.examDtlVO.examPsblSdttm,8,12)}" required="true">
												<span class="txt-sort">~</span>
												<input id="dateEd" type="text" name="dateEd" class="datepicker" timeId="timeEd" fromDate="dateSt" value="${fn:substring(vo.examDtlVO.examPsblEdttm,0,8)}" required="true">
												<input id="timeEd" type="text" name="timeEd" class="timepicker" dateId="dateEd" value="${fn:substring(vo.examDtlVO.examPsblEdttm,8,12)}" required="true">
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="examStareTm" class="req"><spring:message code="quiz.label.mnts" /><!-- 퀴즈시간 --></label></th>
						        			<td>
						        				<div class="form-row">
													<div class="input_btn">
														<input class="form-control md" name="examDtlVO.examMnts" id="examMnts" type="text" inputmask="numeric" value="${vo.examDtlVO.examMnts }" required="true"><label><spring:message code="date.minute" /><!-- 분 --></label>
														<div class="form-inline">
															<small class="note2"><spring:message code="quiz.label.examppr.mnts.notice" /><!-- ! 퀴즈 시험지의 시간 표시는 남은 시간이 표시됩니다. --></small>
														</div>
													</div>
												</div>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label class="req"><spring:message code="quiz.label.mrk.rfltyn" /><!-- 성적반영 --></label></th>
						        			<td>
						        				<span class="custom-input">
													<input type="radio" name="mrkRfltyn" id="mrkRfltynY" value="Y" ${vo.mrkRfltyn eq 'Y' || empty vo.examBscId ? 'checked' : '' }>
													<label for="mrkRfltynY">${yes }</label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="mrkRfltyn" id="mrkRfltynN" value="N" ${vo.mrkRfltyn eq 'N' ? 'checked' : '' }>
													<label for="mrkRfltynN">${no }</label>
												</span>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label class="req"><spring:message code="quiz.label.mrk.oyn" /><!-- 성적공개 --></label></th>
						        			<td>
						        				<span class="custom-input">
													<input type="radio" name="mrkOyn" id="mrkOynY" value="Y" ${vo.mrkOyn eq 'Y' || empty vo.examBscId ? 'checked' : '' }>
													<label for="mrkOynY">${yes }</label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="mrkOyn" id="mrkOynN" value="N" ${vo.mrkOyn eq 'N' ? 'checked' : '' }>
													<label for="mrkOynN">${no }</label>
												</span>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label class="req"><spring:message code="quiz.label.qstn.dsply.mode" /><!-- 문제표시방식 --></label></th>
						        			<td>
						        				<span class="custom-input">
													<input type="radio" name="qstnDsplyGbncd" id="wholViewQstn" value="WHOL" ${vo.qstnDsplyGbncd eq 'WHOL' || empty vo.examBscId ? 'checked' : '' }>
													<label for="wholViewQstn"><spring:message code="quiz.label.all.view.qstn" /><!-- 전체문제 표시 --></label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="qstnDsplyGbncd" id="eachViewQstn" value="EACH" ${vo.qstnDsplyGbncd eq 'EACH' ? 'checked' : '' }>
													<label for="eachViewQstn"><spring:message code="quiz.label.each.view.qstn" /><!-- 페이지별로 1문제씩 표시 --></label>
												</span>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="teamLabel"><spring:message code="quiz.label.qstn.shuffle" /><!-- 문제 섞기 --></label></th>
						        			<td>
						        				<div class="form-row">
													<input type="checkbox" id="qstnRndmynChk" id="qstnRndmynChk" class="switch yesno" ${vo.qstnRndmyn eq 'Y' ? 'checked' : '' }>
												</div>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="teamLabel"><spring:message code="quiz.label.vwitm.shuffle" /><!-- 보기 섞기 --></label></th>
						        			<td>
						        				<div class="form-row">
													<input type="checkbox" id="qstnVwitmRndmynChk" id="qstnVwitmRndmynChk" class="switch yesno" ${vo.qstnVwitmRndmyn eq 'Y' ? 'checked' : '' }>
												</div>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="teamLabel"><spring:message code="quiz.label.qstn.cnddt.useyn" /><!-- 문항후보사용여부 --></label></th>
						        			<td>
						        				<div class="form-row">
													<input type="checkbox" id="qstnCnddtUseynChk" id="qstnCnddtUseynChk" class="switch yesno" ${vo.qstnCnddtUseyn eq 'Y' ? 'checked' : '' }>
												</div>
						        			</td>
						        		</tr>
						        		<tr>
											<th><label for="attchFile"><spring:message code="common.attachments" /><!-- 첨부파일 --></label></th>
											<td>
												<uiex:dextuploader
													id="fileUploader"
													path="${vo.uploadPath}"
													limitCount="5"
													limitSize="100"
													oneLimitSize="100"
													listSize="3"
													fileList="${vo.fileList}"
													finishFunc="finishUpload()"
													allowedTypes="*"
												/>
											</td>
										</tr>
										<tr>
						        			<th><label><spring:message code="quiz.common.team.quiz" /><!-- 팀 퀴즈 --></label></th>
						        			<td>
						        				<div class="form-inline">
							        				<span class="custom-input">
														<input type="radio" name="quizTeamyn" id="quizTeamynY" value="Y" onchange="teamynChange(this.value)" ${vo.examGbncd eq 'QUIZ_TEAM' ? 'checked' : ''}>
														<label for="quizTeamynY">${yes }</label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="quizTeamyn" id="quizTeamynN" value="N" onchange="teamynChange(this.value)" ${empty vo.examBscId || vo.examGbncd ne 'QUIZ_TEAM' ? 'checked' : ''}>
														<label for="quizTeamynN">${no }</label>
													</span>
						        				</div>
												<div id="teamQuizDiv" class="team_item" ${empty vo.examBscId || vo.examGbncd ne 'QUIZ_TEAM' ? 'style="display:none"' : '' }>
										        	<c:forEach var="list" items="${dvclasList }" varStatus="i">
										        		<div class="item" id="teamGrpView${list.sbjctId}">
		                                                    <label class="label_num">${list.dvclasNo }반</label>
		                                                    <input type='hidden' id='teamGrpId${list.sbjctId}' name='teamGrpIds' value="${empty vo.examBscId ? '' : list.teamGrpId}:${list.sbjctId}">
		                                                    <input class="form-control wide" type="text" name="teamGrpnm" id="teamGrpnm${list.sbjctId}" placeholder="<spring:message code='quiz.placeholder.select.team.group' />" value="${empty vo.examBscId ? '' : list.teamGrpnm}" readonly="true" autocomplete="off"><!-- 팀그룹을 선택해 주세요. -->
															<button type="button" class="btn basic" onclick="teamGrpChcPopup('${list.dvclasNo}','${list.sbjctId }')"><spring:message code="srvy.button.assign.teams" /><!-- 팀그룹지정 --></a>
		                                                </div>
											        	<c:if test="${i.count eq 1 }">
															<small class="note2"><spring:message code="quiz.label.select.team.group.notice" /><!-- ! 구성된 팀이 없는 경우 메뉴 “과목설정 > 팀그룹지정”에서 팀을 생성해 주세요 --></small>
											        	</c:if>
											        	<div class="item_setting" id="setQuizDiv${list.sbjctId }" style="display:none;">
		                                                    <div class="checkbox_type">
		                                                        <span class="custom-input">
		                                                            <input type="checkbox" id="teamGrpSubasmtStngyn_${list.sbjctId }" name="teamGrpSubasmtStngyns" data-bscId="${not empty vo.examBscId && list.teamGrpSubasmtStngyn eq 'Y' ? list.examBscId : '' }" value="${list.dvclasNo}:${list.sbjctId }" onchange="teamGrpSubasmtStngynChange(this)" ${not empty vo.examBscId && list.teamGrpSubasmtStngyn eq 'Y' ? 'checked' : '' }>
		                                                            <label for="teamGrpSubasmtStngyn_${list.sbjctId }"><spring:message code="quiz.label.team.group.set.quiz" /><!-- 팀그룹별 퀴즈 설정 --></label>
		                                                        </span>
		                                                    </div>
		                                                </div>
		                                                <div id="subInfoDiv${list.sbjctId }" class="table-wrap mb30" ${not empty vo.examBscId && list.teamGrpSubasmtStngyn eq 'Y' ? '' : 'style="display: none;"' }></div>
										        	</c:forEach>
										        </div>
						        			</td>
						        		</tr>
						        	</tbody>
						        </table>
						        <div class="options_wrap">
		                            <ul class="accordion">
		                                <li class=""><!-- 클릭시 active 추가 -->
		                                    <div class="title-wrap">
		                                        <a class="title" href="#">
		                                            <div class="lecture_tit">
		                                                <strong><spring:message code="quiz.label.option" /><!-- 옵션 --></strong>
		                                            </div>
		                                            <i class="arrow xi-angle-down"></i>
		                                        </a>
		                                    </div>
		                                    <div class="cont">
		                                        <div class="table-wrap">
		                                            <table class="table-type5">
		                                                <colgroup>
		                                                    <col class="width-15per" />
		                                                    <col />
		                                                </colgroup>
		                                                <tbody>
		                                                    <tr>
		                                                        <th>
		                                                            <label for="reexamynY"><spring:message code="quiz.label.retkexam.allow" /><!-- 재응시 사용 --></label>
		                                                        </th>
		                                                        <td>
		                                                            <div class="form-inline">
		                                                                <span class="custom-input ml5">
		                                                                    <input type="radio" id="reexamynY" name="examDtlVO.reexamyn" value="Y" onchange="reexamynChange(this.value)" ${vo.examDtlVO.reexamyn eq 'Y' ? 'checked' : ''}>
		                                                                    <label for="reexamynY"><spring:message code="quiz.common.yes" /><!-- 예 --></label>
		                                                                </span>
		                                                                <span class="custom-input">
		                                                                    <input type="radio" id="reexamynN" name="examDtlVO.reexamyn" value="N" onchange="reexamynChange(this.value)" ${empty vo.examBscId || vo.examDtlVO.reexamyn eq 'N' ? 'checked' : ''}>
		                                                                    <label for="reexamynN"><spring:message code="quiz.common.no" /><!-- 아니오 --></label>
		                                                                </span>
		                                                            </div>

		                                                            <div class="custom-txt mt10 reexamDiv">
		                                                                <span class="tit"><spring:message code="quiz.label.reperiod" /><!-- 채응시기간 --></span>
		                                                                <div class="date_area">
		                                                                    <input type="text" placeholder="<spring:message code='quiz.placeholder.start.date' />" 	id="redateSt" 	name="redateSt" class="datepicker" toDate="redateEd" 	timeId="retimeSt" 	value="${fn:substring(vo.examDtlVO.reexamPsblSdttm,0,8)}"><!-- 시작일 -->
		                                                                    <input type="text" placeholder="<spring:message code='quiz.placeholder.start.time' />" 	id="retimeSt" 	name="retimeSt" class="timepicker" dateId="redateSt" 	value="${fn:substring(vo.examDtlVO.reexamPsblSdttm,8,12)}"><!-- 시작시간 -->
		                                                                    <span class="txt-sort">~</span>
		                                                                    <input type="text" placeholder="<spring:message code='quiz.placeholder.end.date' />" 	id="redateEd" 	name="redateEd" class="datepicker" fromDate="redateSt" 	timeId="retimeEd" 	value="${fn:substring(vo.examDtlVO.reexamPsblEdttm,0,8)}"><!-- 종료일 -->
		                                                                    <input type="text" placeholder="<spring:message code='quiz.placeholder.end.time' />" 	id="retimeEd" 	name="retimeEd" class="timepicker" dateId="redateEd" 	value="${fn:substring(vo.examDtlVO.reexamPsblEdttm,8,12)}"><!-- 종료시간 -->
		                                                                </div>
		                                                            </div>


		                                                            <div class="custom-txt mt10 reexamDiv">
		                                                                <span class="tit"><spring:message code="quiz.label.retkexam.scr.weight" /><!-- 재응시 적용률 --></span>
		                                                                <div class="form-row">
		                                                                    <div class="input_btn">
																				<input class="form-control md" name="examDtlVO.reexamMrkRfltrt" id="reexamMrkRfltrt" type="text" inputmask="numeric" maxVal="100" value="${vo.examDtlVO.reexamMrkRfltrt }" autocomplete="off"><label>%</label>
																			</div>
		                                                                </div>
		                                                            </div>
		                                                        </td>
		                                                    </tr>
		                                                </tbody>
		                                            </table>
		                                        </div>
		                                    </div>
		                                </li>
		                            </ul>
		                        </div>
							</form>
				        </div>
				        <!--table-type-->
				        <spring:message code="common.button.save" 	var="save" /><!-- 저장 -->
				        <spring:message code="common.button.modify" var="modify" /><!-- 수정 -->
				        <div class="btns">
					        <a href="javascript:saveConfirm()" class="btn type1">${empty vo.examBscId ? save : modify }</a>
					        <a href="javascript:bfrQuizCopyPopup()" class="btn type2"><spring:message code="quiz.button.prev.quiz.copy" /></a><!-- 이전퀴즈 가져오기 -->
					        <a href="javascript:quizViewMv('', 'LIST')" class="btn type2"><spring:message code="common.button.list" /></a><!-- 목록 -->
                        </div>
				    </div>
				</div>
        	</div>
            <!-- //content -->
        </main>
        <!-- //classroom-->
    </div>
</body>
</html>