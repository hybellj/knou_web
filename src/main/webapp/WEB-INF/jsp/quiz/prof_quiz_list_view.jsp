<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>

	<script type="text/javascript">
		var SEARCH_VALUE	= '<c:out value="${vo.searchValue}" />';	// 검색어 ( 퀴즈명 )
		var PAGE_INDEX		= '<c:out value="${vo.pageIndex}" />';		// 현재 페이지
		var LIST_SCALE		= '<c:out value="${vo.listScale}" />';		// 목록별 퀴즈 수

		$(document).ready(function () {
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					quizListSelect(1);
				}
			});

			if(!PAGE_INDEX) {
				PAGE_INDEX = 1;
			}

			quizListSelect(PAGE_INDEX);
		});

		// listScale변경
		function changeListScale(scale) {
			LIST_SCALE = scale;
			quizListSelect(1);
		}

		/**
		 * 퀴즈목록조회
		 * @param pageNo	이동페이지
		 */
		function quizListSelect(pageNo) {
			PAGE_INDEX   = pageNo || PAGE_INDEX;
			SEARCH_VALUE = $("#searchValue").val();

			const url   = "/quiz/profQuizListAjax.do";
			const param = {
				currentPageNo 		: PAGE_INDEX,
				recordCountPerPage 	: LIST_SCALE,
				searchValue 		: SEARCH_VALUE,
				pageSize 			: 10,
				sbjctId				: "${vo.sbjctId}"
			};

			$.ajax({
                url			: url,
                type		: "POST",
                data		: param,
                dataType	: "json",
                beforeSend	: () => UiComm.showLoading(true),
                success		: function(data) {
                    if (data.result > 0) {
    	            	let dataList = createListHTML(data.returnList);	// 목록 HTML 생성

    	        		quizListTable.clearData();
    	        		quizListTable.replaceData(dataList);
    	        		quizListTable.setPageInfo(data.pageInfo);
    	        		UiInputmask();

    	        		mrkRfltrtFrmTrsf(2);	// 성적 반영비율 폼 변환
                    } else {
                    	UiComm.showMessage(data.message, "error");
                    }
                },
                error		: () => UiComm.showMessage("<spring:message code='quiz.error.list' />", "error"),/* 리스트 조회 중 에러가 발생하였습니다. */
                complete	: () => UiComm.showLoading(false)
            });
		}

		 /**
		  * 성적 반영비율 폼 변환
		  * @param type - 변환 타입 번호 ( 1 : 입력폼 활성화, 2 : 취소)
		  */
		function mrkRfltrtFrmTrsf(type) {
			if(type == 1) {
				if($("span.list-card-button > button").hasClass("card")) {
					$("span.list-card-button > button").trigger("click");
				}
			}
			$("#mrkRfltrtFrmTrsfBtn").toggle(type != 1);
			$(".mrkRfltrtFrmTrsfDiv").toggleClass("hidden", type != 1);
			$(".mrkRfltrtDiv").toggleClass("hidden", type == 1);
			$(".mrkInputDiv").toggle(type == 1);
		}

		// 성적 반영비율 수정
		function mrkRfltrtModify() {
			let isMrkCheck 			= true;		// 성적 합계 확인 유무
			let sumMrkRfltrt 		= 0;		// 성적반영비율 합계
			let prevSumMrkRfltrt	= 0;		// 기존 성적반영비율 합계
			let examMrkList 		= [];		// 시험 성적 목록

			$(".mrkRfltrt").each(function(i) {
				const mrk = Number($(this).val());

				if(mrk <= 0 || mrk > 100) {
					const msg = mrk == 0 ? "<spring:message code='quiz.alert.score.ratio.0' />"/* 0점은 입력할 수 없습니다. 다른 값을 입력해주세요. */ : "<spring:message code='exam.alert.score.max.100' />"/* 점수는 100점 까지 입력 가능 합니다. */;
					UiComm.showMessage(msg, "info");
					isMrkCheck = false;
					return false;
				}

				// 소수점 2자리 변환
				const val 	  = parseFloat(mrk.toFixed(2));
			    const prevVal = parseFloat(parseFloat($(this).attr("data-mrkRfltrt")).toFixed(2));

			    // 정수로 합산
				sumMrkRfltrt 	 += Math.round(val * 100);
				prevSumMrkRfltrt += Math.round(prevVal * 100);

				examMrkList.push({
					srvyId 		: $(this).attr("data-examBscId"),	// 시험기본아이디
					mrkRfltrt 	: val								// 성적반영비율
				});
			});

			if($(".mrkRfltrt").length == 0) {
				isChk = false;
				quizListSelect(1);
			}

			if(isMrkCheck) {
				if(sumMrkRfltrt !== prevSumMrkRfltrt) {
					UiComm.showMessage("<spring:message code='quiz.alert.score.ratio.not.match' arguments='"+(prevSumMrkRfltrt / 100).toFixed(2)+","+(sumMrkRfltrt / 100).toFixed(2)+"' />", "info");/* 기존성적반영비율 : {0} / 새성적반영비율 : {1} 성적반영비율 합계가 일치하지 않습니다. */
					return false;
				} else {
					$.ajax({
		                url			: "/quiz/quizMrkRfltrtModifyAjax.do",
		                type		: "POST",
		                contentType	: "application/json",
		                data		: JSON.stringify(examMrkList),
		                dataType	: "json",
		                beforeSend	: () => UiComm.showLoading(true),
		                success		: function (data) {
		                    if (data.result > 0) {
		                    	UiComm.showMessage("<spring:message code='quiz.alert.insert' />", "success");/* 정상 저장 되었습니다. */
				        		quizListSelect(1);
		                    } else {
		                    	UiComm.showMessage(data.message, "error");
		                    }
		                },
		                error		: () => UiComm.showMessage("<spring:message code='quiz.error.score.ratio' />", "error"),/* 반영 비율 저장 중 에러가 발생하였습니다. */
		                complete	: () => UiComm.showLoading(false)
		            });
				}
			}
		}

		/**
		 * 성적공개여부수정
		 * @param obj - 수정할객체
		 */
		function modifyMrkOyn(obj) {
			if(obj.dataset.qstnscmptn == "N" && obj.checked) {
				UiComm.showMessage("<spring:message code='quiz.alert.already.qstn.submit' />", "info");/* 문항 출제 완료 후 성적 공개가 가능합니다. */
				UiSwitcherOff(obj.id);
				return;
			}

			const url  = "/quiz/quizMrkOynModifyAjax.do";
			const data = {
				examBscId 	: obj.value,
				mrkOyn 		: obj.checked ? "Y" : "N",
				exampprOyn 	: obj.checked ? "Y" : "N"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		quizListSelect(1);
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='quiz.error.score.open' />", "error");/* 성적 공개 변경 중 에러가 발생하였습니다. */
			}, true);
		}

		/**
		 * 퀴즈시험지미리보기팝업
		 * @param examBscId - 시험기본아이디
		 */
		function quizExampprPreviewPopup(examBscId) {
			 dialog = UiDialog("dialog1", {
				title		: "<spring:message code='quiz.label.preview.examppr' />",/* 퀴즈시험지 미리보기 */
				url			: "/quiz/profQuizExampprPreviewPopup.do?examBscId="+examBscId,
				fullscreen	: true
			});
		}

		/**
		 * 퀴즈 삭제
		 * @param examBscId - 시험기본아이디
		 * @param joinCnt 	- 응시수
		 */
		function quizDelete(examBscId, joinCnt) {
			let confirm = "<spring:message code='quiz.confirm.delete.answer.user.n' />";/* 퀴즈 응시한 학습자가 없습니다. 삭제 하시겠습니까? */
			if(joinCnt > 0) {
				confirm = "<spring:message code='quiz.confirm.delete.answer.user.y' />";/* 퀴즈 응시한 학습자가 있습니다. 삭제 시 학습정보가 삭제됩니다. 정말 삭제하시겠습니까? */
			}
			UiComm.showMessage(confirm, "confirm")
			.then(function(result) {
				if (result) {
					const extData = {
						  examBscId 	: examBscId
						, delyn			: "Y"
					};

					const url   = "/quiz/quizDeleteAjax.do";
					const param = {
						  encParams	: EPARAM
						, addParams	: UiComm.makeEncParams(extData)
					};

					ajaxCall(url, param, function(data) {
						if (data.result > 0) {
							UiComm.showMessage("<spring:message code='quiz.alert.delete' />", "success");/* 정상 삭제되었습니다. */
			        		quizListSelect(1);
			            } else {
			             	UiComm.showMessage(data.message, "error");
			            }
		    		}, function(xhr, status, error) {
		    			UiComm.showMessage("<spring:message code='quiz.error.delete' />", "error");/* 삭제 중 에러가 발생하였습니다. */
		    		}, true);
				}
			});
		}

		// 목록 HTML 생성
		function createListHTML(list) {
			let dataList = [];

			if(list.length == 0) return dataList;

			list.forEach(function(v,i) {
				// 성적반영비율
				let mrkRfltrt  = "<div class='mrkInputDiv ui input' style='display: none;'>";
					mrkRfltrt += "	<input type='text' class='mrkRfltrt w80' data-examGbncd=\"" + v.examGbncd + "\" data-examBscId=\"" + v.examBscId + "\" data-mrkRfltrt=\"" + v.mrkRfltrt + "\" value=\"" + v.mrkRfltrt + "\" inputmask='numeric' inputmode='decimal' maxVal='100' />";
					mrkRfltrt += "</div>";
					mrkRfltrt += "<div class='mrkRfltrtDiv'>" + v.mrkRfltrt + "%</div>";
				if(v.examGbncd.indexOf("EXAM") != -1) {
					mrkRfltrt = v.examGbnnm;
				} else if(v.mrkRfltyn == 'N') {
					mrkRfltrt = "0%";
				}
				// 출제상태
				let examQstnsCmptnyn = wrapLabel("<spring:message code='quiz.label.qstn.temp.save' />", "fcRed");/* 임시저장 */
				if(v.examQstnsCmptnyn == 'Y' || v.examQstnsCmptnyn == 'M') {
					examQstnsCmptnyn = "<spring:message code='quiz.label.qstn.submit.y' />";/* 출제완료 */
				}
				// 성적공개
				let mrkOyn = "<input type='checkbox' value=\"" + v.examBscId + "\" class='switch small' " + (v.mrkOyn == "Y" ? "checked" : "") + " onchange='modifyMrkOyn(this)' data-qstnsCmptn=\"" + v.examQstnsCmptnyn + "\" >";
				if(v.mrkRfltyn == 'N' || !(v.examGbncd == 'QUIZ' || v.examGbncd == 'QUIZ_TEAM')) {
					mrkOyn = "-";
				}
				dataList.push({
					no: 				v.lineNo,
					examGbnnm: 			v.examGbnnm,
					examTtl: 			"<a href='javascript:quizViewMv(\""+v.examBscId+"\", \"EVL\")' class='header header-icon link'>" + UiComm.escapeHtml(v.examTtl) + "</a>",
					examMnts: 			v.examMnts + "<spring:message code='date.minute' />"/* 분 */,
					examDttm: 			UiComm.formatDate(v.examPsblSdttm, "datetime2") + " ~ " + UiComm.formatDate(v.examPsblEdttm, "datetime2"),
					mrkRfltrt: 			mrkRfltrt,
					tkexamStatus: 		"<a href='javascript:quizViewMv(\"" + v.examBscId + "\", \"EVL\")' class='fcBlue'>" + v.examExamneeCnt +"/" + v.examTrgtrCnt + "</a>",
					evlStatus: 			"<a href='javascript:quizViewMv(\"" + v.examBscId + "\", \"EVL\")' class='fcBlue'>" + v.examEvlteeCnt +"/" + v.examExamneeCnt + "</a>",
					examQstnsCmptnyn: 	examQstnsCmptnyn,
					mrkOyn: 			mrkOyn,
					preview: 			v.examQstnsCmptnyn == 'Y' ? "<a style='line-height: 40px;' href='javascript:quizExampprPreviewPopup(\"" + v.examBscId + "\")' class='btn basic small'><spring:message code='quiz.button.preview' />​</a>"/* 미리보기 */ : "-",
					examBscId: 			v.examBscId,
					reexamDttm: 		v.reexamyn == "Y" ? UiComm.formatDate(v.reexamPsblSdttm, "datetime2") + " ~ " + UiComm.formatDate(v.reexamPsblEdttm, "datetime2") : "-",
					examExamneeCnt: 	v.examExamneeCnt,
					previewBtn: 		v.examQstnsCmptnyn == 'Y' ? "<div class='item'><a href='javascript:quizExampprPreviewPopup(\"" + v.examBscId + "\")'><spring:message code='quiz.button.preview' />​</a></div>"/* 미리보기 */ : "",
					reexamBtn: 			v.reexamyn == "Y" ? "<div class='item'><a href='javascript:quizViewMv(\"" + v.examBscId + "\", \"RETKEXAM\")'><spring:message code='quiz.button.not.tkexam.manage' /></a></div>"/* 미응시 관리 */ : ""
				});
			});

			return dataList;
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
				        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="searchValue"><spring:message code='common.search.keyword'/></label></span><%-- 검색어 --%>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" id="searchValue" value="${vo.searchValue}" placeholder="<spring:message code='quiz.placeholder.input.quiz.nm' />"><!-- 퀴즈명 입력 -->
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="quizListSelect(1)"><spring:message code="common.button.search" /></button><%-- 검색 --%>
                            </div>
                        </div>

						<div id="quizListArea">
							<div class="board_top">
	                            <h3 class="board-title"><spring:message code="common.button.list" /><!-- 목록 --></h3>
	                            <div class="right-area">
									<div class="mrkRfltrtFrmTrsfDiv">
								     	<a href="javascript:mrkRfltrtModify()" class="btn type2"><spring:message code="quiz.button.score.ratio.save" /></a><!-- 성적반영비율저장 -->
								     	<a href="javascript:mrkRfltrtFrmTrsf(2)" class="btn type2"><spring:message code="common.button.cancel" /><!-- 취소 --></a>
							        </div>
							        <a href="javascript:mrkRfltrtFrmTrsf(1)" id="mrkRfltrtFrmTrsfBtn" class="btn type2"><spring:message code="quiz.button.score.ratio.chg" /></a><!-- 성적반영비율조정 -->
						            <a href="javascript:quizViewMv('', 'REGIST')" class="btn type2"><spring:message code="quiz.button.regist" /></a><!-- 퀴즈등록 -->
						            <a href="javascript:quizViewMv('', 'QBNKLIST')" class="btn type2"><spring:message code="quiz.common.qbnk" /></a><!-- 문제은행 -->

									<%-- 리스트/카드 선택 버튼 --%>
									<span class="list-card-button"></span>

									<%-- 목록 스케일 선택 --%>
									<uiex:listScale func="changeListScale" value="${vo.listScale}" />
	                            </div>
	                        </div>

	                        <%-- 퀴즈 리스트 --%>
							<div id="list"></div>

							<%-- 게시글 리스트 카드 폼 --%>
							<div id="list_cardForm" class="lecture_box" style="display:none">
								<div class="card-header">
									#[examGbnnm]
									<div class="card-title">
										#[examTtl]
									</div>
									<div class="btn_right">
										<div class="dropdown">
                                            <button type="button" class="btn basic icon set settingBtn" aria-label="퀴즈 관리" onclick="this.nextElementSibling.classList.toggle('show')">
                                                <i class="xi-ellipsis-v"></i>
                                            </button>
                                            <div class="option-wrap">
                                                #[previewBtn]
                                                <div class="item"><a href="javascript:quizViewMv('#[examBscId]', 'QSTN')"><spring:message code="quiz.tab.qstn" /><!-- 문항관리 --></a></div>
                                                #[reexamBtn]
                                                <div class="item"><a href="javascript:quizViewMv('#[examBscId]', 'EVL')"><spring:message code="quiz.button.evl" /><!-- 퀴즈평가 --></a></div>
                                                <div class="item"><a href="javascript:quizViewMv('#[examBscId]', 'MODIFY')"><spring:message code="common.button.modify" /><!-- 수정 --></a></div>
                                                <div class="item"><a href="javascript:quizDelete('#[examBscId]', '#[examExamneeCnt]')"><spring:message code="common.button.delete" /><!-- 삭제 --></a></div>
                                            </div>
                                        </div>
									</div>
								</div>

								<div class="card-body">
									<div class="desc">
										<p><label class="label-title"><spring:message code="quiz.label.period" /><!-- 응시기간 --></label><strong>#[examDttm]</strong></p>
										<p><label class="label-title"><spring:message code="quiz.label.reperiod" /><!-- 재응시기간 --></label><strong>#[reexamDttm]</strong></p>
										<p><label class="label-title"><spring:message code="quiz.label.mrk.rfltrt" /><!-- 성적반영비율 --></label><strong>#[mrkRfltrt]</strong></p>
										<p><label class="label-title"><spring:message code="quiz.label.mnts" /><!-- 퀴즈시간 --></label><strong>#[examMnts]</strong></p>
										<p><label class="label-title"><spring:message code="quiz.label.evl.status" /><!-- 평가현황 --></label><strong>#[evlStatus]</strong></p>
										<p><label class="label-title"><spring:message code="quiz.label.mrk.oyn" /><!-- 성적공개 --></label><strong>#[mrkOyn]</strong></p>
									</div>
								</div>
							</div>

							<script>
								// 리스트 테이블
								let quizListTable = UiTable("list", {
									lang: "ko",
									pageFunc: quizListSelect,
									columns: [
										{title:"No", 														field:"no",					headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
										{title:"<spring:message code='common.type' />", 					field:"examGbnnm",			headerHozAlign:"center", hozAlign:"left",	width:130,	minWidth:130},/* 구분 */
										{title:"<spring:message code='quiz.common.quiz' />", 				field:"examTtl",			headerHozAlign:"center", hozAlign:"left",	width:0,	minWidth:200},/* 퀴즈 */
										{title:"<spring:message code='quiz.label.mnts' />", 				field:"examMnts", 			headerHozAlign:"center", hozAlign:"center", width:100, 	minWidth:100},/* 퀴즈시간 */
										{title:"<spring:message code='quiz.label.period' />", 				field:"examDttm", 			headerHozAlign:"center", hozAlign:"center", width:280,	minWidth:280},/* 응시기간 */
										{title:"<spring:message code='quiz.label.ratio' />", 				field:"mrkRfltrt", 			headerHozAlign:"center", hozAlign:"center", width:130,	minWidth:130},/* 반영비율 */
										{title:"<spring:message code='quiz.label.attendance.status' />", 	field:"tkexamStatus",	 	headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},/* 응시현황 */
										{title:"<spring:message code='quiz.label.evl.status' />", 			field:"evlStatus",	 		headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},/* 평가현황 */
										{title:"<spring:message code='quiz.label.submit.status' />", 		field:"examQstnsCmptnyn", 	headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},/* 출제상태 */
										{title:"<spring:message code='quiz.label.mrk.oyn' />", 				field:"mrkOyn", 			headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},/* 성적공개 */
										{title:"<spring:message code='quiz.button.preview' />", 			field:"preview", 			headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},/* 미리보기 */
									]
								});
							</script>
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