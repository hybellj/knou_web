<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/srvy/common/srvy_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="admin"/>
		<jsp:param name="module" value="table,editor"/>
	</jsp:include>
	<link rel="stylesheet" href="../../webdoc/assets/css/classroom.css">

	<script type="text/javascript">
		var editorMap = {};

		$(document).ready(function () {
			srvypprQstnListSelect();	// 설문지문항목록조회
		});

		/*
		 * 설문지문항목록조회
		 * @param srvyId	설문아이디
		 */
		function srvypprQstnListSelect() {
			const url  = "/srvy/admSrvypprQstnListAjax.do";
			const data = {
				srvyId : "${vo.srvyId}"
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
	        			let html = htmlOption.createAdmSrvypprQstnHTML(list);	// 관리자설문지문항 HTML 리턴
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
				UiComm.showMessage("<spring:message code='srvy.error.list' />", "error");	/* 설문 리스트 조회 중 에러가 발생하였습니다. */
			});
		}

		/*
		 * 설문지삭제
		 * @param srvyId 		설문아이디
		 * @param srvypprId		설문지아이디
		 * @param srvySeqno 	설문지순번
		 */
		function srvypprDelete(srvyId, srvypprId, srvySeqno) {
			if(!canSrvyEdit("")) {
				return false;
			}

			const url  = "/srvy/admSrvypprDeleteAjax.do";
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
				UiComm.showMessage('<spring:message code="srvy.error.page.delete" />', "error");	// 설문 페이지 삭제 중 에러가 발생하였습니다.
			}, true);
		}

		/*
		 * 문항가져오기팝업
		 * @param srvyId 	설문아이디
		 * @param orgId 	기관아이디
		 */
		function qstnCopyPopup() {
			if(!canSrvyEdit("")) {
				return false;
			}

			var data = "srvyId=${vo.srvyId}&orgId=${vo.orgId}"

			dialog = UiDialog("dialog1", {
				title	: "<spring:message code='srvy.button.copy.qstn' />",/* 문항 가져오기 */
				width	: 700,
				height	: 700,
				url		: "/srvy/admSrvyLctrEvlQstnCopyPopup.do?"+data
			});
		}

		/*
		 * 문항엑셀업로드팝업
		 * @param srvyId 	설문아이디
		 */
		function qstnExcelUploadPopup() {
			if(!canSrvyEdit("")) {
		    	return false;
		    }

			dialog = UiDialog("dialog1", {
				title		: "<spring:message code='srvy.button.excel.upload.qstn' />",/* 엑셀 문항등록 */
				width		: 600,
				height		: 500,
				url			: "/srvy/admSrvyQstnExcelUploadPopup.do?srvyId=${vo.srvyId}",
				autoresize	: true
			});
		}

		/**
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
	    		if(seqno == $(this).attr("data-seqno")) {
	    			newSeqno = i + 1;
	    		}
	    	});

	    	if(seqno != newSeqno) {
	    		const url  = "/srvy/admSrvySeqnoModifyAjax.do";
	    		const data = {
	    			srvyId		: $("#srvyId").val(),
	    			srvySeqno	: newSeqno,
	    			searchKey 	: seqno
	    		};

	    		ajaxCall(url, data, function(data) {
	    			if (data.result > 0) {
	    				srvypprQstnListSelect();
	                } else {
	                	UiComm.showMessage(data.message, "error");
	                }
	    		}, function(xhr, status, error) {
	    			UiComm.showMessage("<spring:message code='srvy.error.srvyppr.sort' />", "error");/* 설문지순번 변경 중 에러가 발생하였습니다. */
	    		}, true);
	    	}
	    }

		/**
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
				if(qstnSeqno == $(this).attr("data-seqno")) {
					newQstnSeqno = i + 1;
				}
			});

			if(qstnSeqno != newQstnSeqno) {
				const url  = "/srvy/admQstnSeqnoModifyAjax.do";
				const data = {
					srvypprId	: srvypprId,
					qstnSeqno	: newQstnSeqno,
					searchKey 	: qstnSeqno
				};

				ajaxCall(url, data, function(data) {
					if (data.result > 0) {
						srvypprQstnListSelect();
		            } else {
		            	UiComm.showMessage(data.message, "error");
		            }
				}, function(xhr, status, error) {
					UiComm.showMessage("<spring:message code='srvy.error.qstn.sort' />", "error");/* 문항순번 변경 중 에러가 발생하였습니다. */
				}, true);
			}
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
	    	$("#" + formId + " input[name=qstnTtl]").val(qstnSeqno + "<spring:message code='srvy.label.qstn' />");/* 문항 */
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
			let formId  = "qstnWriteForm"+srvypprId;	// 문항 추가용 form 아이디
			let btnId   = "qstnAddDiv"+srvypprId;		// 문항 추가용 최상위 div 아이디
		    $("#"+btnId+" .addBtn").attr("href", "javascript:qstnSave('" + formId + "', 'MODIFY')");
	    	const url  = "/srvy/admSrvyQstnSelectAjax.do";
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
	        		if(qstn.esntlRspnsyn == "Y") UiSwitcherOn(formId+"esntlRspnsyn");													// 필수 선택

	        		// 단일, 다중, OX선택형
	        		if(qstn.qstnRspnsTycd == "ONE_CHC" || qstn.qstnRspnsTycd == "MLT_CHC" || qstn.qstnRspnsTycd == "OX_CHC") {
						// 단일, 다중선택형
						if(qstn.qstnRspnsTycd !== "OX_CHC") {
							let vwitmCnt = qstn.etcInptUseyn == "Y" ? vwitmList.length - 1 : vwitmList.length;
		        			$("#"+formId+" select[name=vwitmCnt]").val(vwitmCnt).trigger("change").trigger("chosen:updated");			// 보기개수
		        			vwitmList.forEach(vwitm => $("#"+formId+"Vwitm_"+vwitm.vwitmSeqno).val(vwitm.vwitmCts));					// 보기내용
		        			if(qstn.etcInptUseyn == "Y") $("#"+formId+"etcInptUseyn").click();											// 기타 보기
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
			let qstnDivId 	= "qstnAddDiv"+srvypprId;					// 문항 추가용 최상위 div 아이디
			let qstnHeader	= type == "REGIST" ? "<spring:message code='srvy.button.add.qstn' />"/* 문항 추가 */ : "<spring:message code='srvy.button.modify.qstn' />"/* 문항 수정 */;
			let addFormId	= "qstnWriteForm"+srvypprId;				// 문항 추가용 form 아이디
	    	let editorKey 	= "editor"+srvypprId;						// 문항 내용 에디터 저장 키 값
	    	let editorId 	= "qstnCts"+srvypprId;						// 문항 내용 에디터 아이디

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

	    /**
		 * 설문출제완료수정
		 * @param type	- 저장 구분 ( save : 저장, edit : 수정 )
		 */
	    function srvyQstnsCmptnModify(type) {
			 let isQstn = true;
			 if(type == "save") {
			 	if($(".srvypprDiv").length == 0) {
			 		isQstn = false;
			 	} else {
			 		$('.srvypprDiv').each(function(index) {
			 		    const count = $(this).find('.sortQstnDiv').length;
			 		    if(count == 0) {
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

			if(canSrvyEdit(type)) {
				let confirmMsg = "<spring:message code='srvy.confirm.qstn.submit' />"; // 문제를 출제하시겠습니까?
				if(type == "edit") {
					confirmMsg = "<spring:message code='srvy.confirm.qstn.edit' />"; // 문제를 수정하시겠습니까?
				}
				UiComm.showMessage(confirmMsg, "confirm")
				.then(function(result) {
					if (result) {
						const url  = "/srvy/admSrvyQstnsCmptnModifyAjax.do";
						const data = {
							srvyId		: "${vo.srvyId}",
							searchGubun : type
						};

						ajaxCall(url, data, function(data) {
							if (data.result > 0) {
								srvyViewMv("${vo.srvyId}", "ADMEVLQSTN");	// 관리자 설문 강의평가 문항관리 화면
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

					let url = "/srvy/admSrvyQstnRegistAjax.do";
					if(type == "MODIFY") url = "/srvy/admSrvyQstnModifyAjax.do";

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
		 * 문항 삭제
		 * @param srvypprId 	설문지아이디
		 * @param srvyQstnId 	설문문항아이디
		 * @param qstnSeqno 	문항순번
		 */
		function qstnDelete(srvypprId, srvyQstnId, qstnSeqno) {
			if(!canSrvyEdit("")) {
		    	return false;
		    }

			const url  = "/srvy/admSrvyQstnDeleteAjax.do";
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

	    /*
		* 설문수정가능여부
		* @param type	(edit : 수정, save : 제출완료)
		*/
		function canSrvyEdit(type) {
			let isSubmit = "${vo.srvyQstnsCmptnyn}" == "Y";		// 출제 완료 여부
			let isWait	 = "${vo.srvyPrgrsSts}" > "PRE_SRVY";	// 시작 전 여부

			if(isSubmit && type == "") {
				UiComm.showMessage("<spring:message code='srvy.alert.click.edit.submit.btn' />", "info");	/* 수정 버튼 클릭 후 문제 수정이 가능합니다. */
				return false;
			}
			if(isWait && type == "edit") {
				UiComm.showMessage("<spring:message code='srvy.alert.already.start.lctr.evl.modify' />", "info");/* 강의평가가 시작되어 수정이 불가능합니다. */
				return false;
			}

			return true;
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
							<h3 class="board-title"><spring:message code="srvy.button.qstn" /><!-- 문항관리 --></h3>
							<div class="right-area">
								<c:choose>
									<c:when test="${vo.srvyQstnsCmptnyn eq 'Y'}">
								        <button type="button" class="btn type2 big" onclick="srvyQstnsCmptnModify('edit')"><spring:message code="srvy.button.modify" /><!-- 수정 --></button>
									</c:when>
									<c:otherwise>
								        <button type="button" class="btn type2 big" onclick="srvyQstnsCmptnModify('save')"><spring:message code="srvy.button.qstn.cmptny" /><!-- 출제완료 --></button>
									</c:otherwise>
								</c:choose>
								<button type="button" class="btn type2 big" onclick="srvyViewMv('', 'ADMEVLLIST')"><spring:message code="srvy.button.list" /><!-- 목록 --></button>
							</div>
						</div>

						<%--설문 정보--%>
	                    <jsp:include page="/WEB-INF/jsp/srvy/common/srvy_info_inc.jsp"/>
	                    <%--설문 정보--%>

						<div class="margin-bottom-5">
							<div class="board_top">
								<h3><spring:message code="srvy.label.submit.qstn" /><!-- 출제 문항 --> : <span id="qstnCnt">0</span><spring:message code="srvy.label.qstn" /><!-- 문항 --></h3>
								<div class="right-area">
									<button type="button" class="btn type2" onclick="qstnCopyPopup()"><spring:message code="srvy.button.copy.qstn" /><!-- 문항 가져오기 --></button>
									<button type="button" class="btn type2" onclick="qstnExcelUploadPopup()"><spring:message code="srvy.button.reg.file" /><!-- 파일로 등록 --></button>
									<button type="button" class="btn type2" onclick="popupOption.srvyppr('${vo.srvyId}', '', 'REGIST', 'ADM')"><spring:message code="srvy.button.add.page" /><!-- 페이지 추가 --></button>
								</div>
							</div>

							<div class="grid-content modal-type ui-sortable ml0" id="srvypprDiv"></div>
						</div>
                    </div>
                </div>
            </div>
            <!-- //content -->
        </main>
        <!-- //admin-->
    </div>
</body>
</html>