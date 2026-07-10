<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/srvy/common/srvy_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="editor,fileuploader"/>
	</jsp:include>

	<script type="text/javascript">
		var editorMap = {};

		$(document).ready(function() {
			// 팀설문시
			if("${vo.srvyGbn}" == "SRVY_TEAM") {
				document.querySelector('li[name="teamButton"][value="${vo.subSrvyId}"] a').click();	// 팀버튼선택
			} else {
				srvypprQstnListSelect();	// 설문지문항목록조회
			}
		});

		/*
		 * 설문지문항목록조회
		 * @param srvyId	설문아이디
		 */
		function srvypprQstnListSelect() {
			// 출제상태별 표시여부 변경
			const items = document.querySelectorAll('.srvyQstnsCmptnClass');
			items.forEach(item => item.classList.toggle("hide", $("#srvyQstnsCmptnyn").val() !== "N"));

			const url  = "/srvy/srvypprQstnListAjax.do";
			const data = {
				srvyId : $("#srvyId").val()
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					const list = data.data.srvypprList.map(srvyppr => ({
						...srvyppr,
						qstn: data.data.srvyQstnList.filter(qstn => qstn.srvypprId === srvyppr.srvypprId)
					}));
					let qstnCnt = 0;
					if(list.length > 0) qstnCnt = list.reduce((sum, item) => sum + (item.qstn?.length ?? 0), 0);
					$("#qstnCnt").text(qstnCnt);

	        		if(list.length > 0) {
	        			let html = "";
	        			list.forEach(function(v, i) {
							html += "<div class='course_history srvypprDiv' data-id='" + v.srvypprId + "' data-seqno='" + v.srvySeqno + "'>";
							html += "	<div class='h_top'>";
							html += "		<div class='h_left'>";
							html += "			<h4><i class='xi-arrows m_handle mr10' aria-label='위젯 이동' role='button' tabindex='0' aria-grabbed='false'></i><spring:message code='srvy.label.page' /> " + v.srvySeqno + ". " + UiComm.escapeHtml(v.srvyTtl) + "</h4>";/* 페이지 */
							html += "		</div>";
							html += "		<div class='h_right'>";
							html += "			<a href='javascript:qstnAddFrmView(\"" + v.srvypprId + "\")' class='btn basic small'><spring:message code='srvy.button.add.qstn' /></a>";/* 문항 추가 */
		        			html += "			<a href='javascript:popupOption.srvyppr(\"${vo.subSrvyId}\", \"" + v.srvypprId + "\", \"MODIFY\", \"PROF\")' class='btn basic small'><spring:message code='srvy.button.modify.page' /></a>";/* 페이지 수정 */
		        			html += "			<a href='javascript:srvypprDelete(\"" + v.srvyId + "\", \"" + v.srvypprId + "\", \"" + v.srvySeqno + "\")' class='btn basic type2 small'><spring:message code='srvy.button.delete.page' /></a>";/* 페이지 삭제 */
							html += "		</div>";
							html += "	</div>";
							html += "	<div class='question_area srvyQstnDiv'>";
							if(v.qstn.length == 0) {
								html += "	<p class='text-center'><spring:message code='srvy.label.qstn.cmptnn.info' /></p>";/* 출제 문항이 없습니다. */
							} else {
								v.qstn.forEach(function(vv, ii) {
									html += "<div class='question_con sortQstnDiv' data-id='" + vv.srvyQstnId + "' data-seqno='" + vv.qstnSeqno + "' data-pprid='" + vv.srvypprId + "' data-mvmnyn='" + vv.srvyMvmnUseyn + "'>";
									html += "	<div class='q_top bd0'>";
									html += "		<div class='flex-item width-100per'>";
									html += "			<i class='btn basic small mr10 xi-arrows-v m_handle'></i>";
									html += "			<p class='flex-none mr15'><b>" + v.srvySeqno + "-" + vv.qstnSeqno + "</b></p>";
									html += "			<div class='flex-1 tal fcBlue cursor-pointer' onclick='qstnModFrmView(\"" + v.srvypprId + "\", \"" + vv.srvyQstnId + "\")'>" + UiComm.escapeHtml(vv.qstnTtl) + "</div>";
									html += "			<p class='flex-none ml15 mr15'>" + vv.qstnRspnsTynm + "</p>";
									html += "			<button type='button' onclick='qstnDelete(\"" + v.srvypprId + "\", \"" + vv.srvyQstnId + "\", \"" + vv.qstnSeqno + "\")' class='btn basic type2 small flex-none'><spring:message code='srvy.button.delete' /></button>";/* 삭제 */
									html += "		</div>";
									html += "	</div>";
									html += "</div>";
								});
							}
							html += "	</div>";
							html += "</div>";
	        			});
	        			$("#srvypprDiv").empty().html(html);

	        			$('#srvypprDiv').sortable({
	        	            connectWith: '#srvypprDiv',
	        	            placeholderClass: '.srvypprDiv',
	        	            placeholder: "portlet-placeholder",
	        	            handle: ".xi-arrows",
	        	            opacity: 0.6,
	        	            stop: function(event, ui) {
	        	            	srvySeqnoChange(ui.item);	// 설문지순번 변경
	        	            }
	        	        });

	        			$('.srvyQstnDiv').sortable({
	        	            connectWith: '.srvyQstnDiv',
	        	            placeholderClass: '.sortQstnDiv',
	        	            placeholder: "portlet-placeholder",
	        	            handle: ".xi-arrows-v",
	        	            opacity: 0.6,
	        	            receive: function(event, ui) {
	        	                $(ui.sender).sortable('cancel');
	        	            },
	        	            stop: function(event, ui) {
								qstnSeqnoChange(ui.item);	// 문항순번 변경
	        	            }
	        	        });
	        		} else {
	        			$("#srvypprDiv").empty();
	        		}
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='srvy.error.list' />", "error");	/* 리스트 조회 중 에러가 발생하였습니다. */
			});
		}

	 	/*
		 * 설문팀선택
		 * @param srvyId	설문아이디
		 */
	 	function srvyTeamSelect(srvyId) {
			$("#srvyId").val(srvyId);

			// 팀 버튼 색상 변경
			const teamButtons = document.querySelectorAll('[name="teamButton"]');
			teamButtons.forEach(button => button.classList.remove('select'));
			document.querySelector('li[name="teamButton"][value="' + srvyId + '"]').classList.add('select');

			// 문제 관리 버튼 변경
			let html = "";
			<c:forEach var="team" items="${srvyTeamList }">
				if("${team.srvyId}" == srvyId) {
					$("#srvyQstnsCmptnyn").val("${team.srvyQstnsCmptnyn}");
					if("${team.srvyQstnsCmptnyn}" == "Y") {
						html += "<a href='javascript:srvyQstnsCmptnModify(\"edit\", \"dtl\")' class='btn basic type2'><spring:message code='srvy.button.modify' /></a>";/* 수정 */
					} else {
						html += "<a href='javascript:popupOption.srvyppr(\"${vo.subSrvyId}\", \"\", \"REGIST\", \"PROF\")' class='btn basic'><spring:message code='srvy.button.add.page' /></a>";/* 페이지 추가 */
						html += "<a href='javascript:srvyCopyPopup()' class='btn basic'><spring:message code='srvy.button.copy.srvy' /></a>";/* 설문 가져오기 */
						html += "<a href='javascript:qstnExcelUploadPopup()' class='btn basic'><spring:message code='srvy.button.excel.upload.qstn' /></a>";/* 엑셀 문항등록 */
						html += "<a href='javascript:srvyQstnsCmptnModify(\"save\", \"dtl\")' class='btn basic type2'><spring:message code='srvy.button.qstn.cmptny' /></a>";/* 출제완료 */
					}
				}
			</c:forEach>
			$("#qstnBtnDiv").empty().html(html);

			srvypprQstnListSelect();	// 설문지문항목록조회
	 	}

		/*
		 * 설문지삭제
		 * @param srvyId		설문아이디
		 * @param srvypprId		설문지아이디
		 * @param srvySeqno 	설문지순번
		 */
		function srvypprDelete(srvyId, srvypprId, srvySeqno) {
			if(!canSrvyEdit("")) {
				return false;
			}

			srvypprPtcpCntSelect(srvyId, srvypprId).done(function(returnVO) {
				let confirm = "<spring:message code='srvy.confirm.delete.answer.user.n' />";/* 설문 응시한 학습자가 없습니다. 삭제 하시겠습니까? */
				if(returnVO > 0) {
					confirm = "<spring:message code='srvy.confirm.delete.answer.user.y' />";/* 설문 응시한 학습자가 있습니다. 삭제 시 학습정보가 삭제됩니다. 정말 삭제하시겠습니까? */
		     	}
				UiComm.showMessage(confirm, "confirm")
				.then(function(result) {
					if (result) {
						const url  = "/srvy/srvypprDeleteAjax.do";
						const data = {
							srvyId 		: srvyId,
							srvypprId 	: srvypprId,
							srvySeqno	: srvySeqno
						};

						ajaxCall(url, data, function(data) {
							if (data.result > 0) {
								UiComm.showMessage("<spring:message code='srvy.alert.delete' />", "success");	// 정상 삭제되었습니다.
						 		srvypprQstnListSelect();	// 설문지문항목록조회
						     } else {
						      	UiComm.showMessage(data.message, "error");
						     }
						}, function(xhr, status, error) {
							UiComm.showMessage('<spring:message code="srvy.error.delete" />', "error");	// 삭제 중 에러가 발생하였습니다.
						}, true);
					}
				});
			});
		}

		/*
		 * 설문가져오기팝업
		 * @param srvyId	설문아이디
		 * @param sbjctId 	과목아이디
		 */
		function srvyCopyPopup() {
			if(!canSrvyEdit("")) {
				return false;
			}

			dialog = UiDialog("dialog1", {
				title	: "<spring:message code='srvy.button.copy.srvy' />"/* 설문 가져오기 */,
				width	: 700,
				height	: 700,
				url		: "/srvy/profSrvyQstnCopyPopup.do?encParams="+EPARAM+"&addParams="+UiComm.makeEncParams({srvyId : $("#srvyId").val()})
			});
		}

		/*
		 * 문항추가폼보기
		 * @param srvypprId		설문지아이디
		 */
	    function qstnAddFrmView(srvypprId) {
	    	if(!canSrvyEdit("")) {
	    		return false;
	    	}

	    	qstnFrmInit(srvypprId, "REGIST");												// 문항 폼 초기화
	    	let formId  	= "qstnWriteForm"+srvypprId;									// 문항 추가용 form 아이디
	    	let btnId   	= "qstnAddDiv"+srvypprId;										// 문항 추가용 최상위 div 아이디
	    	let qstnSeqno 	= $(".sortQstnDiv[data-pprid='" + srvypprId + "']").length + 1;	// 문항순번
	    	$("#" + formId + " input[name=qstnSeqno]").val(qstnSeqno);
	    	$("#" + formId + " input[name=qstnTtl]").val(qstnSeqno + "<spring:message code='srvy.label.qstn' />"/* 문항 */);
	    	$("#" + formId + " input[name=qstnGbncd]").val("GENERAL");
	    	$("#" + formId + " input[name=srvypprId]").val(srvypprId);
	    	$("#" + btnId + " .addBtn").attr("href", "javascript:qstnSave('" + formId + "', 'REGIST')");
	    }

		/*
		 * 문항수정폼보기
		 * @param srvypprId 	설문지아이디
		 * @param srvyQstnId	설문문항아이디
		 */
	    function qstnModFrmView(srvypprId, srvyQstnId) {
			if(!canSrvyEdit("")) {
		    	return false;
		    }

			qstnFrmInit(srvypprId, "MODIFY");			// 문항 폼 초기화
			let formId	= "qstnWriteForm"+srvypprId;	// 문항 추가용 form 아이디
			let btnId   = "qstnAddDiv"+srvypprId;		// 문항 추가용 최상위 div 아이디
		    $("#"+btnId+" .addBtn").attr("href", "javascript:qstnSave('" + formId + "', 'MODIFY')");
	    	const url  = "/srvy/srvyQstnSelectAjax.do";
	    	const data = {
				srvypprId  : srvypprId,
				srvyQstnId : srvyQstnId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					let qstn 		= data.data.srvyQstnVO;				// 설문문항정보
					let vwitmList 	= data.data.srvyVwitmList;			// 설문보기항목목록
					let lvlList 	= data.data.srvyQstnVwitmLvlList;	// 설문문항보기항목레벨목록

					// 공통 값 적용
	        		$("#"+formId+" input[name=srvypprId]").val(qstn.srvypprId);															// 설문지아이디
	        		$("#"+formId+" input[name=srvyQstnId]").val(qstn.srvyQstnId);														// 설문문항아이디
	        		$("#"+formId+" input[name=qstnSeqno]").val(qstn.qstnSeqno);															// 문항순번
	        		$("#"+formId+" input[name=qstnTtl]").val(qstn.qstnTtl);																// 문항제목
	        		editorMap["editor"+srvypprId].openHTML(qstn.qstnCts);																// 문항내용
	        		$("#"+formId+" select[name=qstnRspnsTycd]").val(qstn.qstnRspnsTycd).trigger("change").trigger("chosen:updated");	// 문항답변유형코드
	        		if(qstn.esntlRspnsyn == "Y") UiSwitcherOn(formId+"esntlRspnsyn");													// 필수선택

	        		// 단일, 다중, OX선택형
	        		if(qstn.qstnRspnsTycd == "ONE_CHC" || qstn.qstnRspnsTycd == "MLT_CHC" || qstn.qstnRspnsTycd == "OX_CHC") {
						// 단일, 다중선택형
						if(qstn.qstnRspnsTycd !== "OX_CHC") {
							let vwitmCnt = qstn.etcInptUseyn == "Y" ? vwitmList.length - 1 : vwitmList.length;
		        			$("#"+formId+" select[name=vwitmCnt]").val(vwitmCnt).trigger("change").trigger("chosen:updated");			// 보기개수
		        			vwitmList.forEach(vwitm => $("#"+formId+"Vwitm_"+vwitm.vwitmSeqno).val(vwitm.vwitmCts));					// 보기내용
		        			if(qstn.etcInptUseyn == "Y") $("#"+formId+"etcInptUseyn").click();											// 기타보기
						}

	        			// 분기 선택
	        			if(qstn.srvyMvmnUseyn == "Y") {
	        				$("#"+formId+"srvyMvmnUseyn").click();
	        				vwitmList.forEach((vwitm, index) => $("#"+formId+" select[name=mvmnSrvypprId]").eq(index).val(vwitm.mvmnSrvypprId).trigger('chosen:updated'));
	        			}

					// 레벨형
	        		} else if(qstn.qstnRspnsTycd == "LEVEL") {
						// 평가 문항
	        			vwitmList.forEach(function(v, i) {
							if(i > 0) qstnOption.createLevelQstnAddHTML(formId);	// 레벨형 문항 추가 HTML 추가
							$("#"+formId+" input[name=vwitmCts]").eq(i).val(v.vwitmCts);
	        			});
						// 평가 등급
						let lvlLength = lvlList.length == 3 || lvlList.length == 5 ? lvlList.length : 10;
						$("#"+formId+" input[name=vwitmLvl][value='"+lvlLength+"']").prop("checked", true).trigger("change");
						const qstnLvlList = Object.fromEntries(
							lvlList.map(item => [item.lvlScr, item.lvlCts])
						);
						qstnOption.createLevelChgHTML(formId, qstnLvlList);			// 평가 등급 변경 HTML 추가
	        		}
	        	} else {
	        		UiComm.showMessage(data.message, "error");
	        	}
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");	/* 에러가 발생했습니다! */
			});
	    }

	 	/*
		 * 문항폼초기화
		 * @param srvypprId 	설문지아이디
		 * @param type			(REGIST : 등록, MODIFY : 수정)
		 */
	    function qstnFrmInit(srvypprId, type) {
			let qstnDivId 	= "qstnAddDiv"+srvypprId;		// 문항 추가용 최상위 div 아이디
			let qstnHeader	= type == "REGIST" ? "<spring:message code='srvy.button.add.qstn' />"/* 문항 추가 */ : "<spring:message code='srvy.button.modify.qstn' />"/* 문항 수정 */;
			let addFormId	= "qstnWriteForm"+srvypprId;	// 문항 추가용 form 아이디
	    	let editorKey 	= "editor"+srvypprId;			// 문항 내용 에디터 저장 키 값
	    	let editorId 	= "qstnCts"+srvypprId;			// 문항 내용 에디터 아이디

	    	$("#"+qstnDivId).remove();
	    	let html  = "<div class='question_con question_con_add' id='" + qstnDivId + "'>";
	    		html += "	<div class='q_top'>";
				html += "		<div class='flex-item width-100per'>";
				html += "			<p class='flex-none mr15'><b class='sub-title'>" + qstnHeader + "</b></p>";
				html += "		</div>";
				html += "	</div>";
				html += "	<div class='q_cont_form content'>";
				html += "	</div>";
				html += "</div>";
	    	$(".srvypprDiv[data-id='"+srvypprId+"']").find("div.srvyQstnDiv").append(html);

	    	qstnOption.createQstnHeaderHTML(qstnDivId, addFormId, editorId);	// 문제 말머리 HTML 추가
	    	qstnOption.createQstnBtnHTML(qstnDivId, addFormId);					// 문제 버튼 HTML 추가
	    	editorMap[editorKey] = UiEditor({
				targetId: editorId,
				uploadPath: "${vo.uploadPath}",
				height: "250px"
			});																	// 문항내용 html 에디터 생성
			qstnOption.qstnRspnsTycdChgChange(addFormId);						// 문항답변유형코드 변경 이벤트
	    }

		/*
		 * 설문지참여수조회
		 * @param srvyId 		설문아이디
		 * @param srvypprId 	설문지아이디
		 * @param sbjctId 		과목아이디
		 */
		function srvypprPtcpCntSelect(srvyId, srvypprId) {
			let deferred = $.Deferred();

			const extData = {
				srvyId 		: srvyId,
				srvypprId 	: srvypprId
			};

			const url  = "/srvy/srvypprPtcpCntSelectAjax.do";
			const param = {
				encParams	: EPARAM,
				addParams	: UiComm.makeEncParams(extData)
			};

			ajaxCall(url, param, function(data) {
				if(data.result >= 0) {
					deferred.resolve(data.result);
			    } else {
			    	UiComm.showMessage(data.message, "error");
			    	deferred.reject();
			    }
			}, function(xhr, status, error) {
				UiComm.showMessage('<spring:message code="fail.common.msg" />', "error");// 에러가 발생했습니다!
				deferred.reject();
			}, true);

			return deferred.promise();
		}

		/*
		 * 문항등록, 수정
		 * @param formId	문제 추가용 form 아이디
		 * @param type		(REGIST : 등록, MODIFY : 수정)
		 */
		function qstnSave(formId, type) {
			if(!canSrvyEdit("")) {
		    	return false;
		    }

			UiValidator(formId).then(function(result) {
				if (result) {
					if(!qstnOption.isValidQstn(formId)) {
					 	return false;
					}

					let url = "/srvy/srvyQstnRegistAjax.do";
					if(type == "MODIFY") url = "/srvy/srvyQstnModifyAjax.do";

					ajaxCall(url, $("#"+formId).serialize(), function(data) {
						if (data.result > 0) {
							srvypprQstnListSelect();	// 설문지문항목록조회
			            } else {
			            	UiComm.showMessage(data.message, "error");
			            }
					}, function(xhr, status, error) {
						if(type == "REGIST") UiComm.showMessage("<spring:message code='srvy.error.qstn.insert' />", "error");/* 문항 등록 중 에러가 발생하였습니다. */
						if(type == "MODIFY") UiComm.showMessage("<spring:message code='srvy.error.qstn.update' />", "error");/* 문항 수정 중 에러가 발생하였습니다. */
					}, true);
				}
			});
	    }

		/*
		 * 문항삭제
		 * @param srvypprId 	설문지아이디
		 * @param srvyQstnId 	설문문항아이디
		 * @param qstnSeqno 	문항순번
		 */
		function qstnDelete(srvypprId, srvyQstnId, qstnSeqno) {
			if(!canSrvyEdit("")) {
		    	return false;
		    }

			let srvyId = $("#srvyId").val();
			srvypprPtcpCntSelect(srvyId, srvypprId).done(function(returnVO) {
				let confirm = "<spring:message code='srvy.confirm.delete.answer.user.n' />";/* 설문 응시한 학습자가 없습니다. 삭제 하시겠습니까? */
				if(returnVO > 0) {
					confirm = "<spring:message code='srvy.confirm.delete.answer.user.y' />";/* 설문 응시한 학습자가 있습니다. 삭제 시 학습정보가 삭제됩니다. 정말 삭제하시겠습니까? */
		     	}
				UiComm.showMessage(confirm, "confirm")
				.then(function(result) {
					if (result) {
						const url  = "/srvy/srvyQstnDeleteAjax.do";
						const data = {
							srvypprId 	: srvypprId,
							srvyQstnId 	: srvyQstnId,
							qstnSeqno	: qstnSeqno,
							delyn		: "Y"
						};

						ajaxCall(url, data, function(data) {
							if (data.result > 0) {
								UiComm.showMessage("<spring:message code='srvy.alert.delete' />", "success");	// 정상 삭제되었습니다.
						 		srvypprQstnListSelect();	// 설문지문항목록조회
						     } else {
						      	UiComm.showMessage(data.message, "error");
						     }
						}, function(xhr, status, error) {
							UiComm.showMessage("<spring:message code='srvy.error.qstn.delete' />", "error");/* 문항 삭제 중 에러가 발생하였습니다. */
						}, true);
					}
				});
			});
		}

		/*
		 * 설문수정가능여부
		 * @param type	(edit : 수정, save : 제출완료)
		 */
		function canSrvyEdit(type) {
			let isSubmit = $("#srvyQstnsCmptnyn").val() == "Y";		// 출제 완료 여부
			let isWait	 = "${today}" > "${vo.srvySdttm}";			// 시작 전 여부
			let isJoin   = parseInt("${vo.ptcpUserCnt}") > 0;		// 제출자 여부

			if(isSubmit && type == "") {
				UiComm.showMessage("<spring:message code='srvy.alert.click.edit.submit.btn' />", "info");	/* 수정 버튼 클릭 후 문제 수정이 가능합니다. */
				return false;
			}
			if(isSubmit && type == "edit" && isWait && isJoin) {
				UiComm.showMessage("<spring:message code='srvy.confirm.answer.user.y.edit.item' />", "confirm")	/* 설문 응시자가 있습니다. 설문 문항을 수정하시겠습니까? */
				.then(function(result) {
					return result;
				});
			}

			return true;
		}

		/*
		 * 설문지순번변경
		 * @param obj	문항순번 변경할 문항
		 */
	    function srvySeqnoChange(obj) {
			if(!canSrvyEdit("")) {
		    	return false;
		    }

	    	let seqno 	  	= obj.attr("data-seqno");	// 설문지순번
	    	let newSeqno 	= 1;						// 변경할 설문지순번

	    	$("div.srvypprDiv").each(function(i) {
	    		if(seqno == $(this).attr("data-seqno")) newSeqno = i + 1;
	    	});

	    	if(seqno != newSeqno) {
	    		const url  = "/srvy/srvySeqnoModifyAjax.do";
	    		const data = {
	    			srvyId		: $("#srvyId").val(),
	    			srvySeqno	: newSeqno,
	    			searchKey 	: seqno
	    		};

	    		ajaxCall(url, data, function(data) {
	    			if (data.result > 0) {
	    				srvypprQstnListSelect();	// 설문지문항목록조회
	                } else {
	                	UiComm.showMessage(data.message, "error");
	                }
	    		}, function(xhr, status, error) {
	    			UiComm.showMessage("<spring:message code='srvy.error.srvyppr.sort' />", "error");/* 설문지순번 변경 중 에러가 발생하였습니다. */
	    		}, true);
	    	}
	    }

		/*
		 * 문항순번변경
		 * @param obj	문항후보순번 변경할 문항
		 */
		function qstnSeqnoChange(obj) {
			if(!canSrvyEdit("")) {
		    	return false;
		    }

			let srvypprId 		= obj.attr("data-pprId");	// 설문지아이디
			let qstnSeqno 		= obj.attr("data-seqno");	// 문항순번
			let newQstnSeqno 	= 1;						// 변경할 문항순번

			// 변경할 순번값 찾기
			$("div.srvypprDiv[data-id='"+srvypprId+"'] div.sortQstnDiv").each(function(i) {
				if(qstnSeqno == $(this).attr("data-seqno")) newQstnSeqno = i + 1;
			});

			if(qstnSeqno != newQstnSeqno) {
				const url  = "/srvy/qstnSeqnoModifyAjax.do";
				const data = {
					srvypprId	: srvypprId,
					qstnSeqno	: newQstnSeqno,
					searchKey 	: qstnSeqno
				};

				ajaxCall(url, data, function(data) {
					if (data.result > 0) {
						srvypprQstnListSelect();	// 설문지문항목록조회
		            } else {
		            	UiComm.showMessage(data.message, "error");
		            }
				}, function(xhr, status, error) {
					UiComm.showMessage("<spring:message code='srvy.error.qstn.sort' />", "error");/* 문항순번 변경 중 에러가 발생하였습니다. */
				}, true);
			}
		}

		/*
		 * 문항엑셀업로드팝업
		 * @param srvyId	설문아이디
		 */
		function qstnExcelUploadPopup() {
			if(!canSrvyEdit("")) {
		    	return false;
		    }

			dialog = UiDialog("dialog1", {
				title		: "<spring:message code='srvy.button.excel.upload.qstn' />",/* 엑셀 문항등록 */
				width		: 600,
				height		: 500,
				url			: "/srvy/profSrvyQstnExcelUploadPopup.do?srvyId="+$("#srvyId").val(),
				autoresize	: true
			});
		}

		/*
		 * 설문출제완료수정
		 * @param upSrvyId	상위설문아이디
		 * @param srvyId	설문아이디
		 * @param srvyGbncd	설문구분코드
		 * @param type		저장 구분 ( save : 저장, edit : 수정 )
		 * @param gbn		구분 ( bsc : 전체, dtl : 팀 )
		 */
	    function srvyQstnsCmptnModify(type, gbn) {
			 let isQstn = true;
			 if(type == "save") {
			 	if($(".srvypprDiv").length == 0) {
			 		isQstn = false;
			 	} else {
			 		$('.srvypprDiv').each(function(index) {
			 		    if($(this).find('.sortQstnDiv').length == 0) {
			 				isQstn = false;
			 				return;
			 		    }
			 		});
			 	}
			 }

			 if(!isQstn) {
				UiComm.showMessage("<spring:message code='srvy.alert.add.qstn.submit' />", "warning");	/* 문항 추가 후 출제완료 가능합니다. */
				return false;
			}

			if(gbn != undefined && gbn == "bsc") {
				if(${not isQstnsCmptn}) {
					UiComm.showMessage("<spring:message code='srvy.alert.all.team.submit' />", "info");/* 모든 팀의 문제를 출제완료 해주세요. */
					return false;
				}
			}

			if(canSrvyEdit(type)) {
				let confirmMsg = "<spring:message code='srvy.confirm.qstn.submit' />"; // 문제를 출제하시겠습니까?
				if(type == "edit") {
					confirmMsg = "<spring:message code='srvy.confirm.qstn.edit' />"; // 문제를 수정하시겠습니까?
				}
				UiComm.showMessage(confirmMsg, "confirm")
				.then(function(result) {
					if (result) {
						const url  = "/srvy/srvyQstnsCmptnModifyAjax.do";
						const data = {
							upSrvyId   	: "${vo.srvyId}",
							srvyId		: $("#srvyId").val(),
							srvyGbncd	: "${vo.srvyGbn}",
							searchGubun : type,
							searchKey	: gbn
						};

						ajaxCall(url, data, function(data) {
							if (data.result > 0) {
								srvyViewMv("${vo.srvyId}", "PROFQSTN");	// 교수 설문 문항 관리 화면
				            } else {
				            	UiComm.showMessage(data.message, "error");
				            }
						}, function(xhr, status, error) {
							UiComm.showMessage("<spring:message code='srvy.error.qstn.submit' />", "error");/* 문항 출제 중 에러가 발생하였습니다. */
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
                                <spring:message code="srvy.common.srvy" /><!-- 설문 -->
                            </h2>
				        </div>

				        <div class="listTab">
					        <ul>
					            <li><a onclick="srvyViewMv('${vo.srvyId}', 'PROFEVL')"><spring:message code="srvy.tab.evl" /><!-- 설문정보 및 평가 --></a></li>
					            <li class="select"><a onclick="srvyViewMv('${vo.srvyId}', 'PROFQSTN')"><spring:message code="srvy.tab.qstn" /><!-- 문항관리 --></a></li>
					        </ul>
					    </div>

				        <div class="board_top">
				        	<h3 class="board-title"><spring:message code="srvy.tab.qstn" /><!-- 문항관리 --></h3>
					        <div class="right-area">
					        	<a href="javascript:srvyViewMv('', 'PROFLIST')" class="btn type2 big"><spring:message code="srvy.button.list" /></a><!-- 목록 -->
					        </div>
				        </div>

					    <%--설문 정보--%>
	                    <jsp:include page="/WEB-INF/jsp/srvy/common/srvy_info_inc.jsp"/>
	                    <%--설문 정보--%>

                        <c:if test="${vo.srvyGbn eq 'SRVY_TEAM' }">
                        	<div class="board_top margin-top-4">
								<div class="right-area">
									<c:choose>
										<c:when test="${vo.srvyQstnsCmptnyn eq 'Y' }">
											<a href="javascript:srvyQstnsCmptnModify('edit', 'bsc')" class="btn type2 big"><spring:message code="srvy.button.modify" /><!-- 수정 --></a>
										</c:when>
										<c:otherwise>
											<a href="javascript:srvyQstnsCmptnModify('save', 'bsc')" class="btn type2 big"><spring:message code="srvy.button.qstn.cmptny" /><!-- 출제완료 --></a>
										</c:otherwise>
									</c:choose>
								</div>
							</div>
							<div class="listTab">
	                            <ul>
	                            	<c:forEach var="item" items="${srvyTeamList }">
	                            		<li name="teamButton" value="${item.srvyId }"><a onclick="srvyTeamSelect('${item.srvyId }')">${item.teamnm }</a></li>
	                            	</c:forEach>
	                            </ul>
	                        </div>
                        </c:if>

						<div class="margin-bottom-5">
							<input type="hidden" id="srvyId" value="${vo.subSrvyId }" />
							<input type="hidden" id="srvyQstnsCmptnyn" value="${vo.srvyQstnsCmptnyn }" />
							<div class="board_top">
								<h3><spring:message code="srvy.label.submit.qstn" /><!-- 출제 문항 --> : <span id="qstnCnt">0</span><spring:message code="srvy.label.qstn" /><!-- 문항 --></h3>
								<c:if test="${vo.srvyQstnsCmptnyn ne 'Y' || vo.srvyGbn ne 'SRVY_TEAM' }">
									<div class="right-area" id="qstnBtnDiv">
										<c:choose>
											<c:when test="${vo.srvyQstnsCmptnyn eq 'Y'}">
												<a href="javascript:srvyQstnsCmptnModify('edit', 'dtl')" class="btn basic type2"><spring:message code="srvy.button.modify" /><!-- 수정 --></a>
											</c:when>
											<c:otherwise>
												<a href="javascript:popupOption.srvyppr('${vo.subSrvyId }', '', 'REGIST', 'PROF')" class="btn basic"><spring:message code="srvy.button.add.page" /><!-- 페이지 추가 --></a>
												<a href="javascript:srvyCopyPopup()" class="btn basic"><spring:message code="srvy.button.copy.srvy" /><!-- 설문 가져오기 --></a>
										        <a href="javascript:qstnExcelUploadPopup()" class="btn basic"><spring:message code="srvy.button.excel.upload.qstn" /><!-- 엑셀 문항등록 --></a>
										        <a href="javascript:srvyQstnsCmptnModify('save', 'dtl')" class="btn basic type2"><spring:message code="srvy.button.qstn.cmptny" /><!-- 출제완료 --></a>
											</c:otherwise>
										</c:choose>
									</div>
								</c:if>
							</div>

							<div class="grid-content modal-type ui-sortable ml0" id="srvypprDiv"></div>
						</div>

						<div class="msg-box srvyQstnsCmptnClass">
                            <ul class="list-dot">
                                <li><spring:message code="srvy.label.qstn.submit.info1" /><!-- 출제완료 클릭 전에는 “임시저장” 상태입니다. --></li>
                                <li><spring:message code="srvy.label.qstn.submit.info2" /><!-- 문항 출제 완료되면 “출제완료” 버튼을 반드시 클릭해 주세요. --></li>
                            </ul>
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