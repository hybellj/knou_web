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
		var dialog;

		$(document).ready(function () {
			quizListSelect(1);

			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					quizListSelect(1);
				}
			});

			$("#listType").on("click", function() {
				$(this).children("i").toggleClass("list th");
				quizListSelect(1);
			});
		});

		// list scale 변경
		function changeListScale() {
			quizListSelect(1);
		}

		/**
		 * 퀴즈 목록 조회
		 * @param {Integer} pageIndex 		- 현재 페이지
		 * @param {String}  listScale 		- 페이징 목록 수
		 * @param {String}  sbjctId 		- 과목아이디
		 * @param {String}  searchValue 	- 검색어(퀴즈명)
		 * @returns {list} 퀴즈 목록
		 */
		function quizListSelect(page) {
			var url = "/quiz/profQuizListAjax.do";
			var data = {
				"pageIndex" 	: page,
				"listScale" 	: $('[id^="listScale"]').eq(0).val(),
				"sbjctId"		: "${sbjctId}",
				"searchValue" 	: $("#searchValue").val()
			};

			UiComm.showLoading(true);
			$.ajax({
	            url 	 : url,
	            async	 : false,
	            type 	 : "POST",
	            dataType : "json",
	            data 	 : data,
	        }).done(function(data) {
	        	UiComm.showLoading(false);
	        	if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var dataList = createQuizListHTML(returnList);	// 퀴즈 리스트 HTML 생성

	        		quizListTable.clearData();
	        		quizListTable.replaceData(dataList);
	        		quizListTable.setPageInfo(data.pageInfo);
	        		UiInputmask();

	        		mrkRfltrtFrmTrsf(2);	// 성적 반영비율 폼 변환
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
	        }).fail(function() {
	        	UiComm.showLoading(false);
	        	UiComm.showMessage("<spring:message code='exam.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
	        });
		}

		 /**
		  * 성적 반영비율 폼 변환
		  * @param {Integer} type - 변환 타입 번호 ( 1 : 입력폼 활성화, 2 : 취소)
		  */
		function mrkRfltrtFrmTrsf(type) {
			if(type == 1) {
				$("#mrkRfltrtFrmTrsfBtn").hide();
				$(".mrkRfltrtFrmTrsfDiv").css("display", "inline-block");
				$(".mrkInputDiv").show();
				$(".mrkRfltrtDiv").hide();
			} else {
				$("#mrkRfltrtFrmTrsfBtn").css("display", "inline-block");
				$(".mrkRfltrtFrmTrsfDiv").hide();
				$(".mrkInputDiv").hide();
				$(".mrkRfltrtDiv").show();
			}
		}

		// 성적 반영비율 수정
		function mrkRfltrtModify() {
			var isMrkCheck = true;		// 성적 합계 확인 유무
			var sumMrkRfltrt = 0;		// 성적반영비율 합계
			var examMrkList = [];		// 시험 성적 목록

			$(".mrkRfltrt").each(function(i) {
				if(Number($(this).val()) < 0 || Number($(this).val()) > 100) {
					UiComm.showMessage("<spring:message code='exam.alert.score.max.100' />", "info");/* 점수는 100점 까지 입력 가능 합니다. */
					isMrkCheck = false;
					return false;
				}
				if(Number($(this).val()) == 0) {
					UiComm.showMessage("<spring:message code='exam.alert.score.ratio.0' />", "info");/* 0점은 입력할 수 없습니다. 다른 값을 입력해주세요. */
					isMrkCheck = false;
					return false;
				}

				sumMrkRfltrt += parseInt($(this).val());

				var examMrk = {
					examBscId : $(this).attr("data-examBscId"),		// 시험기본아이디
					mrkRfltrt : $(this).val()						// 성적반영비율
				};
				examMrkList.push(examMrk);
			});

			if($(".mrkRfltrt").length == 0) {
				isChk = false;
				quizListSelect(1);
			}

			if(isMrkCheck) {
				if(Number(sumMrkRfltrt) != 100) {
					UiComm.showMessage("["+sumMrkRfltrt+"] <spring:message code='exam.alert.always.exam.score.ratio.100' />", "info");/* 상시 성적 반영 비율이 100%여야 합니다. */
					return false;
				} else {
					$.ajax({
		                url: "/quiz/quizMrkRfltrtModifyAjax.do",
		                type: "POST",
		                contentType: "application/json",
		                data: JSON.stringify(examMrkList),
		                dataType: "json",
		                beforeSend: function () {
		                	UiComm.showLoading(true);
		                },
		                success: function (data) {
		                    if (data.result > 0) {
		                    	UiComm.showMessage("<spring:message code='exam.alert.insert' />", "success");/* 정상 저장 되었습니다. */
				        		quizListSelect(1);
		                    } else {
		                    	UiComm.showMessage(data.message, "error");
		                    }
		                    UiComm.showLoading(false);
		                },
		                error: function (xhr, status, error) {
		                	UiComm.showMessage("<spring:message code='exam.error.score.ratio' />", "error");/* 반영 비율 저장 중 에러가 발생하였습니다. */
		                },
		                complete: function () {
		                	UiComm.showLoading(false);
		                },
		            });
				}
			}
		}

		/**
		 * 성적 공개여부 수정
		 * @param {String} examBscId 		- 시험기본아이디
		 * @param {String} mrkOyn 			- 성적공개여부
		 * @param {String} examQstnsCmptnyn - 시험문제출제완료여부
		 */
		document.addEventListener('change', (e) => {
			if(e.target.classList.contains('switch')) {
				if(e.target.dataset.qstnscmptn == "N") {
					if(e.target.checked) {
						UiComm.showMessage("<spring:message code='exam.alert.already.qstn.submit' />", "info");/* 문항 출제 완료 후 성적 공개가 가능합니다. */
						e.target.checked = false;
						return;
					}
				}
				var mrkOyn 		= e.target.checked ? "Y" : "N";
				var url  = "/quiz/quizMrkOynModifyAjax.do";
				var data = {
					"examBscId" 	: e.target.value,
					"mrkOyn" 		: mrkOyn,
					"exampprOyn" 	: mrkOyn
				};

				ajaxCall(url, data, function(data) {
					if (data.result > 0) {
		        		quizListSelect(1);
		            } else {
		            	UiComm.showMessage(data.message, "error");
		            }
				}, function(xhr, status, error) {
					UiComm.showMessage("<spring:message code='exam.error.score.open' />", "error");/* 성적 공개 변경 중 에러가 발생하였습니다. */
				}, true);
			}
		});

		/**
		 * 성적 공개여부 수정
		 * @param {Object} obj - 성적 공개 변경할 객체
		 * @param {String} examQstnsCmptnyn - 시험문제출제완료여부
		 */
		function mrkOynModify(obj, examQstnsCmptnyn) {
			if(examQstnsCmptnyn == "N") {
				if(obj.checked) {
					UiComm.showMessage("<spring:message code='exam.alert.already.qstn.submit' />", "info");/* 문항 출제 완료 후 성적 공개가 가능합니다. */
					$(obj).prop("checked", false);
				}
			}
			var examBscId	= $(obj).val();
			var mrkOyn 		= obj.checked ? "Y" : "N";
			var url  = "/quiz/quizMrkOynModifyAjax.do";
			var data = {
				"examBscId" 	: examBscId,
				"mrkOyn" 		: mrkOyn,
				"exampprOyn" 	: mrkOyn
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		quizListSelect(1);
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='exam.error.score.open' />", "error");/* 성적 공개 변경 중 에러가 발생하였습니다. */
			}, true);
		}

		/**
		 * 퀴즈 화면 이동
		 * @param {String}  examBscId 		- 시험기본아이디
		 * @param {String}  sbjctId 		- 과목아이디
		 */
		function quizViewMv(examBscId, tab) {
			var urlMap = {
				"1" : "/quiz/profQuizQstnMngView.do",		// 퀴즈 문항 관리 화면
				"2" : "/quiz/profQuizRetkexamMngView.do",	// 퀴즈 재응시 관리 화면
				"3" : "/quiz/profQuizEvlMngView.do",		// 퀴즈 평가 관리 화면
				"4" : "/qbnk/profQbnkListView.do",			// 문제은행 목록 화면
				"8" : "/quiz/profQuizRegistView.do", 		// 퀴즈 등록 화면
				"9" : "/quiz/profQuizModifyView.do" 		// 퀴즈 수정 화면
			};

			var kvArr = [];

			kvArr.push({'key' : 'examBscId',   	'val' : examBscId});
			kvArr.push({'key' : 'sbjctId', 		'val' : "${sbjctId}"});

			submitForm(urlMap[tab], "", "", kvArr);
		}

		/**
		 * 퀴즈시험지미리보기팝업
		 * @param {String}  examBscId - 시험기본아이디
		 */
		function quizExampprPreviewPopup(examBscId) {
			 dialog = UiDialog("dialog1", {
				title: "퀴즈시험지 미리보기",
				width: 600,
				height: 500,
				url: "/quiz/profQuizExampprPreviewPopup.do?examBscId="+examBscId,
				autoresize: true
			});
		}

		/**
		 * 퀴즈 삭제
		 * @param {String}  examBscId 		- 시험기본아이디
		 * @param {String}  sbjctId 		- 과목아이디
		 * @param {String}  delyn 			- 삭제여부
		 */
		function quizDelete(examBscId, joinCnt) {
			var confirm = "";
			if(joinCnt > 0) {
				confirm = "<spring:message code='exam.label.quiz' /> <spring:message code='exam.confirm.exist.answer.user.y' />";/* 퀴즈 *//* 응시한 학습자가 있습니다. 삭제 시 학습정보가 삭제됩니다.정말 삭제하시겠습니까? */
			} else {
				confirm = "<spring:message code='exam.label.quiz' /> <spring:message code='exam.confirm.exist.answer.user.n' />";/* 퀴즈 *//* 응시한 학습자가 없습니다. 삭제 하시겠습니까? */
			}
			UiComm.showMessage(confirm, "confirm")
			.then(function(result) {
				if (result) {
					var url  = "/quiz/quizDeleteAjax.do";
					var data = {
						  examBscId 	: examBscId
						, "sbjctId"		: "${sbjctId}"
						, "delyn"		: "Y"
					};

					ajaxCall(url, data, function(data) {
						if (data.result > 0) {
							UiComm.showMessage("<spring:message code='exam.alert.delete' />", "success");/* 정상 삭제 되었습니다. */
			        		quizListSelect(1);
			            } else {
			             	UiComm.showMessage(data.message, "error");
			            }
		    		}, function(xhr, status, error) {
		    			UiComm.showMessage("<spring:message code='exam.error.delete' />", "error");/* 삭제 중 에러가 발생하였습니다. */
		    		}, true);
				}
			});
		}

		// 퀴즈 리스트 HTML 생성
		function createQuizListHTML(quizList) {
			let dataList = [];

			if(quizList.length == 0) {
				return dataList;
			} else {
				quizList.forEach(function(v,i) {
					// 제목
					var examTtl = "<a href='javascript:quizViewMv(\""+v.examBscId+"\", 3)' class='header header-icon link'>" + escapeHtml(v.examTtl) + "</a>";
					// 시간
					var examMnts = v.examMnts + "<spring:message code='exam.label.stare.min' />";/* 분 */
					// 기간
					var examDttm = dateFormat("date", v.examPsblSdttm) + " ~ " + dateFormat("date", v.examPsblEdttm);
					// 성적반영비율
					var mrkRfltrt  = "<div class='mrkInputDiv ui input'>";
						mrkRfltrt += "	<input type='text' class='mrkRfltrt w80' data-examGbncd=\"" + v.examGbncd + "\" data-examBscId=\"" + v.examBscId + "\" value=\"" + v.mrkRfltrt + "\" inputmask='numeric' inputmode='decimal' maxVal='100' />";
						mrkRfltrt += "</div>";
						mrkRfltrt += "<div class='mrkRfltrtDiv'>" + v.mrkRfltrt + "%</div>";
					if(v.examGbncd.indexOf("EXAM") != -1) {
						mrkRfltrt = v.examGbnnm;
					} else if(v.mrkRfltyn == 'N') {
						mrkRfltrt = "0%";
					}
					// 응시현황
					var tkexamStatus = "<a href='javascript:quizViewMv(\"" + v.examBscId + "\", 3)' class='fcBlue'>" + v.examExamneeCnt +"/" + v.examTrgtrCnt + "</a>";
					// 평가현황
					var evlStatus = "<a href='javascript:quizViewMv(\"" + v.examBscId + "\", 3)' class='fcBlue'>" + v.examEvlteeCnt +"/" + v.examExamneeCnt + "</a>";
					// 출제상태
					var examQstnsCmptnyn = "";
					if(v.examQstnsCmptnyn == 'Y' || v.examQstnsCmptnyn == 'M') {
						examQstnsCmptnyn = "<spring:message code='exam.label.qstn.submit.y' />";/* 출제완료 */
					} else {
						examQstnsCmptnyn = "<span class='fcRed'><spring:message code='exam.label.qstn.temp.save' /></span>";/* 임시저장 */
					}
					// 성적공개
					var mrkOyn = "";
					if(v.mrkRfltyn == 'N' || !(v.examGbncd == 'QUIZ' || v.examGbncd == 'QUIZ_TEAM')) {
						mrkOyn = "-";
					} else {
						mrkOyn = "<input type='checkbox' value=\"" + v.examBscId + "\" class='switch small' " + (v.mrkOyn == "Y" ? "checked" : "") + " data-qstnsCmptn=\"" + v.examQstnsCmptnyn + "\" >";
					}
					// 미리보기
					var preview = "-";
					var previewBtn = "";
					if(v.examQstnsCmptnyn == 'Y') {
						preview = "<a href='javascript:quizExampprPreviewPopup(\"" + v.examBscId + "\")' class='btn basic small'><spring:message code='exam.label.preview' />​</a>";/* 미리보기 */
						previewBtn = "<div class='item'><a href='javascript:quizExampprPreviewPopup(\"" + v.examBscId + "\")'><spring:message code='exam.label.preview' />​</a></div>";/* 미리보기 */
					}
					// 재응시기간
					var reexamDttm = "-";
					var reexamBtn = "";
					if(v.reexamyn == "Y") {
						reexamDttm = dateFormat("date", v.reexamPsblSdttm) + " ~ " + dateFormat("date", v.reexamPsblEdttm);
						reexamBtn = "<div class='item'><a href='javascript:quizViewMv(\"" + v.examBscId + "\", 2)'>미응시 관리</a></div>";
					}
					dataList.push({
						no: 				v.lineNo,
						examGbnnm: 			v.examGbnnm,
						examTtl: 			examTtl,
						examMnts: 			examMnts,
						examDttm: 			examDttm,
						mrkRfltrt: 			mrkRfltrt,
						tkexamStatus: 		tkexamStatus,
						evlStatus: 			evlStatus,
						examQstnsCmptnyn: 	examQstnsCmptnyn,
						mrkOyn: 			mrkOyn,
						preview: 			preview,
						examBscId: 			v.examBscId,
						reexamDttm: 		reexamDttm,
						examExamneeCnt: 	v.examExamneeCnt,
						previewBtn: 		previewBtn,
						reexamBtn: 			reexamBtn
					});
				});
			}

			return dataList;
		}
	</script>
</head>

<body class="class colorA">
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
            	<div class="class_sub_top">
					<div class="navi_bar">
						<ul>
							<li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
							<li>강의실</li>
							<li><span class="current">내강의실</span></li>
						</ul>
					</div>
					<div class="btn-wrap">
						<div class="first">
							<select class="form-select">
								<option value="2025년 2학기">2025년 2학기</option>
								<option value="2025년 1학기">2025년 1학기</option>
							</select>
							<select class="form-select wide">
								<option value="">강의실 바로가기</option>
								<option value="2025년 2학기">2025년 2학기</option>
								<option value="2025년 1학기">2025년 1학기</option>
							</select>
						</div>
						<div class="sec">
							<button type="button" class="btn type1"><i class="xi-book-o"></i>교수 매뉴얼</button>
							<button type="button" class="btn type1"><i class="xi-info-o"></i>학습안내정보</button>
						</div>
					</div>
				</div>

		        <div class="class_sub">
		        	<div class="sub-content">
				        <div class="page-info">
				        	<h2 class="page-title">
                                <spring:message code="exam.label.quiz" /><!-- 퀴즈 -->
                            </h2>
				        </div>
				        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="searchValue"><spring:message code='common.search.keyword'/></label></span><%-- 검색어 --%>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" name="" id="searchValue" value="${param.searchValue}" placeholder="<spring:message code='exam.label.quiz' /><spring:message code='exam.label.nm' /> <spring:message code='exam.label.input' />"><!-- 퀴즈 --><!-- 명 --><!-- 입력 -->
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="quizListSelect(1)"><spring:message code='button.search'/></button><%-- 검색 --%>
                            </div>
                        </div>

						<div id="quizListArea">
							<div class="board_top">
	                            <h3 class="board-title">목록</h3>
	                            <div class="right-area">
									<div class="mrkRfltrtFrmTrsfDiv">
								     	<a href="javascript:mrkRfltrtModify()" class="btn type2"><spring:message code="exam.label.grade.score" /> <spring:message code="exam.label.score.aply.rate" /> <spring:message code="exam.button.save" /></a><!-- 성적 --><!-- 반영비율 --><!-- 저장 -->
								     	<a href="javascript:mrkRfltrtFrmTrsf(2)" class="btn type2"><spring:message code="exam.button.cancel" /></a>
							        </div>
							        <a href="javascript:mrkRfltrtFrmTrsf(1)" id="mrkRfltrtFrmTrsfBtn" class="btn type2"><spring:message code="exam.label.grade.score" /> <spring:message code="exam.label.score.aply.rate" /> <spring:message code="exam.button.adju" /></a><!-- 성적 --><!-- 반영비율 --><!-- 조정 -->
						            <a href="javascript:quizViewMv('', 8)" class="btn type2"><spring:message code="exam.label.quiz" /><spring:message code="exam.button.reg" /></a><!-- 퀴즈 --><!-- 등록 -->
						            <a href="javascript:quizViewMv('', 4)" class="btn type2"><spring:message code="exam.label.qbank" /></a><!-- 문제은행 -->

									<%-- 리스트/카드 선택 버튼 --%>
									<span class="list-card-button"></span>

									<%-- 목록 스케일 선택 --%>
									<uiex:listScale func="changeListScale" value="" />
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
                                                <div class="item"><a href="javascript:quizViewMv('#[examBscId]', 1)">문제 관리</a></div>
                                                #[reexamBtn]
                                                <div class="item"><a href="javascript:quizViewMv('#[examBscId]', 3)">퀴즈평가</a></div>
                                                <div class="item"><a href="javascript:quizViewMv('#[examBscId]', 9)">수정</a></div>
                                                <div class="item"><a href="javascript:quizDelete('#[examBscId]', '#[examExamneeCnt]')">삭제</a></div>
                                            </div>
                                        </div>
									</div>
								</div>

								<div class="card-body">
									<div class="desc">
										<p><label class="label-title">응시기간</label><strong>#[examDttm]</strong></p>
										<p><label class="label-title">재응시기간</label><strong>#[reexamDttm]</strong></p>
										<p><label class="label-title">성적 반영비율</label><strong>#[mrkRfltrt]</strong></p>
										<p><label class="label-title">퀴즈시간</label><strong>#[examMnts]</strong></p>
										<p><label class="label-title">평가현황</label><strong>#[evlStatus]</strong></p>
										<p><label class="label-title">성적공개</label><strong>#[mrkOyn]</strong></p>
									</div>
								</div>
							</div>

							<script>
								// 리스트 테이블
								let quizListTable = UiTable("list", {
									lang: "ko",
									pageFunc: quizListSelect,
									columns: [
										{title:"No", 		field:"no",					headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
										{title:"구분", 		field:"examGbnnm",			headerHozAlign:"center", hozAlign:"left",	width:0,	minWidth:100},
										{title:"퀴즈", 		field:"examTtl",			headerHozAlign:"center", hozAlign:"left",	width:0,	minWidth:200},
										{title:"퀴즈시간", 	field:"examMnts", 			headerHozAlign:"center", hozAlign:"center", width:100, 	minWidth:100},
										{title:"응시기간", 	field:"examDttm", 			headerHozAlign:"center", hozAlign:"center", width:280,	minWidth:280},
										{title:"반영비율", 	field:"mrkRfltrt", 			headerHozAlign:"center", hozAlign:"center", width:0,	minWidth:100},
										{title:"응시현황", 	field:"tkexamStatus",	 	headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},
										{title:"평가현황", 	field:"evlStatus",	 		headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},
										{title:"출제상태", 	field:"examQstnsCmptnyn", 	headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},
										{title:"성적공개", 	field:"mrkOyn", 			headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},
										{title:"미리보기", 	field:"preview", 			headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},
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