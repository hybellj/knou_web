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
			srvyListSelect(1);

			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					srvyListSelect(1);
				}
			});
		});

		// list scale 변경
		function changeListScale() {
			srvyListSelect(1);
		}

		/**
		 * 설문목록조회
		 * @param {Integer} pageIndex 		- 현재 페이지
		 * @param {String}  listScale 		- 페이징 목록 수
		 * @param {String}  sbjctId 		- 과목아이디
		 * @param {String}  searchValue 	- 검색어(설문명)
		 * @returns {list} 설문목록
		 */
		function srvyListSelect(page) {
			var url = "/srvy/profSrvyListAjax.do";
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
	        		var dataList = createSrvyListHTML(returnList);	// 설문 리스트 HTML 생성

	        		srvyListTable.clearData();
	        		srvyListTable.replaceData(dataList);
	        		srvyListTable.setPageInfo(data.pageInfo);
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
		  * 성적반영비율폼변환
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

		// 성적반영비율수정
		function mrkRfltrtModify() {
			var isMrkCheck = true;		// 성적 합계 확인 유무
			var sumMrkRfltrt = 0;		// 성적반영비율 합계
			var srvyMrkList = [];		// 설문 성적 목록

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

				var srvyMrk = {
					srvyId : $(this).attr("data-srvyId"),	// 설문아이디
					mrkRfltrt : $(this).val()				// 성적반영비율
				};
				srvyMrkList.push(srvyMrk);
			});

			if($(".mrkRfltrt").length == 0) {
				isChk = false;
				srvyListSelect(1);
			}

			if(isMrkCheck) {
				if(Number(sumMrkRfltrt) != 100) {
					UiComm.showMessage("["+sumMrkRfltrt+"] <spring:message code='exam.alert.always.exam.score.ratio.100' />", "info");/* 상시 성적 반영 비율이 100%여야 합니다. */
					return false;
				} else {
					$.ajax({
		                url: "/srvy/srvyMrkRfltrtModifyAjax.do",
		                type: "POST",
		                contentType: "application/json",
		                data: JSON.stringify(srvyMrkList),
		                dataType: "json",
		                beforeSend: function () {
		                	UiComm.showLoading(true);
		                },
		                success: function (data) {
		                    if (data.result > 0) {
		                    	UiComm.showMessage("<spring:message code='exam.alert.insert' />", "success");/* 정상 저장 되었습니다. */
				        		srvyListSelect(1);
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
		 * 성적공개여부수정
		 * @param {String} srvyId	 		- 설문아이디
		 * @param {String} mrkOyn 			- 성적공개여부
		 * @param {String} srvyQstnsCmptnyn - 설문문항출제완료여부
		 */
		document.addEventListener('change', (e) => {
			if(e.target.classList.contains('switch')) {
				sbjctMrkOynSrvyCntSelect().done(function(result) {
					if(result > 0 && e.target.checked) {
						UiComm.showMessage("과목당 한 개의 설문만 성적 공개가 가능합니다.", "info");
						UiSwitcherOff(e.target.id);
						return;
					} else {
						if(e.target.dataset.qstnscmptn == "N" && e.target.checked) {
							UiComm.showMessage("<spring:message code='exam.alert.already.qstn.submit' />", "info");/* 문항 출제 완료 후 성적 공개가 가능합니다. */
							UiSwitcherOff(e.target.id);
							return;
						}

						var mrkOyn = e.target.checked ? "Y" : "N";
						var url  = "/srvy/srvyMrkOynModifyAjax.do";
						var data = {
							"srvyId" 	: e.target.value,
							"mrkOyn" 	: mrkOyn
						};

						ajaxCall(url, data, function(data) {
							if (data.result > 0) {
				        		srvyListSelect(1);
				            } else {
				            	UiComm.showMessage(data.message, "error");
				            }
						}, function(xhr, status, error) {
							UiComm.showMessage("<spring:message code='exam.error.score.open' />", "error");/* 성적 공개 변경 중 에러가 발생하였습니다. */
						}, true);
					}
				});
			}
		});

		/**
		 * 설문화면이동
		 * @param {String}  srvyId 		- 설문아이디
		 * @param {String}  sbjctId 	- 과목아이디
		 */
		function srvyViewMv(srvyId, tab) {
			var urlMap = {
				"1" : "/quiz/profQuizQstnMngView.do",		// 퀴즈 문항 관리 화면
				"2" : "/quiz/profQuizEvlMngView.do",		// 퀴즈 평가 관리 화면
				"8" : "/srvy/profSrvyRegistView.do", 		// 설문 등록 화면
				"9" : "/srvy/profSrvyModifyView.do" 		// 설문 수정 화면
			};

			var kvArr = [];

			kvArr.push({'key' : 'srvyId',   	'val' : srvyId});
			kvArr.push({'key' : 'sbjctId', 		'val' : "${sbjctId}"});

			submitForm(urlMap[tab], "", "", kvArr);
		}

		/**
		 * 설문지미리보기팝업 ( 미완료 )
		 * @param {String}  srvyId - 설문아이디
		 */
		function srvypprPreviewPopup(srvyId) {
			 dialog = UiDialog("dialog1", {
				title: "설문지 미리보기",
				width: 600,
				height: 500,
				url: "/srvy/profSrvypprPreviewPopup.do?srvyId="+srvyId,
				autoresize: true
			});
		}

		/**
		 * 설문삭제
		 * @param {String}  srvyId 		- 설문아이디
		 * @param {String}  sbjctId 	- 과목아이디
		 * @param {String}  delyn 		- 삭제여부
		 */
		function srvyDelete(srvyId, joinCnt) {
			var confirm = "";
			if(joinCnt > 0) {
				confirm = "설문 응시한 학습자가 있습니다. 삭제 시 학습정보가 삭제됩니다. 정말 삭제하시겠습니까?";
			} else {
				confirm = "<spring:message code='resh.confirm.exist.answer.user.n' />";/* 설문 응시한 학습자가 없습니다. 삭제 하시겠습니까? */
			}
			UiComm.showMessage(confirm, "confirm")
			.then(function(result) {
				if (result) {
					var url  = "/srvy/srvyDeleteAjax.do";
					var data = {
						  "srvyId" 	: srvyId
						, "sbjctId"	: "${sbjctId}"
						, "delyn"	: "Y"
					};

					ajaxCall(url, data, function(data) {
						if (data.result > 0) {
							UiComm.showMessage("<spring:message code='exam.alert.delete' />", "success");/* 정상 삭제 되었습니다. */
			        		srvyListSelect(1);
			            } else {
			             	UiComm.showMessage(data.message, "error");
			            }
		    		}, function(xhr, status, error) {
		    			UiComm.showMessage("<spring:message code='exam.error.delete' />", "error");/* 삭제 중 에러가 발생하였습니다. */
		    		}, true);
				}
			});
		}

		// 설문리스트HTML생성
		function createSrvyListHTML(srvyList) {
			let dataList = [];

			if(srvyList.length == 0) {
				return dataList;
			} else {
				srvyList.forEach(function(v,i) {
					var srvyGbnnm = v.srvyGbn == "SRVY_TEAM" ? "설문 팀" : "설문";
					// 제목
					var srvyTtl = "<a href='javascript:srvyViewMv(\""+v.srvyId+"\", 2)' class='header header-icon link'>" + escapeHtml(v.srvyTtl) + "</a>";
					// 기간
					var srvyDttm = dateFormat("date", v.srvySdttm) + " ~ " + dateFormat("date", v.srvyEdttm);
					// 성적반영비율
					var mrkRfltrt  = "<div class='mrkInputDiv ui input'>";
						mrkRfltrt += "	<input type='text' class='mrkRfltrt w80' data-examGbn=\"" + v.srvyGbn + "\" data-srvyId=\"" + v.srvyId + "\" value=\"" + v.mrkRfltrt + "\" inputmask='numeric' inputmode='decimal' maxVal='100' />";
						mrkRfltrt += "</div>";
						mrkRfltrt += "<div class='mrkRfltrtDiv'>" + v.mrkRfltrt + "%</div>";
					if(v.mrkRfltyn == 'N') {
						mrkRfltrt = "0%";
					}
					// 참여현황
					var ptcpStatus = "<a href='javascript:srvyViewMv(\"" + v.srvyId + "\", 2)' class='fcBlue'>" + v.srvyPtcpCnt +"/" + v.srvyTrgtCnt + "</a>";
					// 평가현황
					var evlStatus = "<a href='javascript:srvyViewMv(\"" + v.srvyId + "\", 2)' class='fcBlue'>" + v.srvyEvlteeCnt +"/" + v.srvyPtcpCnt + "</a>";
					// 출제상태
					var srvyQstnsCmptnyn = "";
					if(v.srvyQstnsCmptnyn == 'Y' || v.srvyQstnsCmptnyn == 'M') {
						srvyQstnsCmptnyn = "<spring:message code='exam.label.qstn.submit.y' />";/* 출제완료 */
					} else {
						srvyQstnsCmptnyn = "<span class='fcRed'><spring:message code='exam.label.qstn.temp.save' /></span>";/* 임시저장 */
					}
					// 성적공개
					var mrkOyn = "";
					if(v.mrkRfltyn == 'N') {
						mrkOyn = "-";
					} else {
						mrkOyn = "<input type='checkbox' value=\"" + v.srvyId + "\" class='switch small' " + (v.mrkOyn == "Y" ? "checked" : "") + " data-qstnsCmptn=\"" + v.srvyQstnsCmptnyn + "\" >";
					}
					// 미리보기
					var preview = "-";
					var previewBtn = "";
					if(v.examQstnsCmptnyn == 'Y') {
						preview = "<a href='javascript:srvypprPreviewPopup(\"" + v.srvyId + "\")' class='btn basic small'><spring:message code='exam.label.preview' />​</a>";/* 미리보기 */
						previewBtn = "<div class='item'><a href='javascript:srvypprPreviewPopup(\"" + v.srvyId + "\")'><spring:message code='exam.label.preview' />​</a></div>";/* 미리보기 */
					}
					dataList.push({
						no: 				v.lineNo,
						srvyGbnnm: 			srvyGbnnm,
						srvyTtl: 			srvyTtl,
						srvyDttm: 			srvyDttm,
						mrkRfltrt: 			mrkRfltrt,
						ptcpStatus: 		ptcpStatus,
						evlStatus: 			evlStatus,
						srvyQstnsCmptnyn: 	srvyQstnsCmptnyn,
						mrkOyn: 			mrkOyn,
						preview: 			preview,
						srvyId: 			v.srvyId,
						srvyPtcpCnt: 		v.srvyPtcpCnt,
						previewBtn: 		previewBtn,
					});
				});
			}

			return dataList;
		}

		// 과목성적공개설문수조회
		function sbjctMrkOynSrvyCntSelect() {
			var deferred = $.Deferred();

			var url = "/srvy/sbjctMrkOynSrvyCntSelectAjax.do";
			var data = {
	   			"sbjctId" : "${sbjctId}"
	   		};

			ajaxCall(url, data, function(data) {
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
                                설문
                            </h2>
				        </div>
				        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="searchValue"><spring:message code='common.search.keyword'/></label></span><%-- 검색어 --%>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" name="" id="searchValue" value="${param.searchValue}" placeholder="설문명 입력">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="srvyListSelect(1)"><spring:message code='button.search'/></button><%-- 검색 --%>
                            </div>
                        </div>

						<div id="srvyListArea">
							<div class="board_top">
	                            <h3 class="board-title">목록</h3>
	                            <div class="right-area">
									<div class="mrkRfltrtFrmTrsfDiv">
								     	<a href="javascript:mrkRfltrtModify()" class="btn type2">성적반영비율저장</a>
								     	<a href="javascript:mrkRfltrtFrmTrsf(2)" class="btn type2">취소</a>
							        </div>
							        <a href="javascript:mrkRfltrtFrmTrsf(1)" id="mrkRfltrtFrmTrsfBtn" class="btn type2">성적반영비율조정</a>
						            <a href="javascript:srvyViewMv('', 8)" class="btn type2">설문 등록</a>

									<%-- 리스트/카드 선택 버튼 --%>
									<span class="list-card-button"></span>

									<%-- 목록 스케일 선택 --%>
									<uiex:listScale func="changeListScale" value="" />
	                            </div>
	                        </div>

	                        <%-- 설문 리스트 --%>
							<div id="list"></div>

							<%-- 게시글 리스트 카드 폼 --%>
							<div id="list_cardForm" class="lecture_box" style="display:none">
								<div class="card-header">
									#[srvyGbnnm]
									<div class="card-title">
										#[srvyTtl]
									</div>
									<div class="btn_right">
										<div class="dropdown">
                                            <button type="button" class="btn basic icon set settingBtn" aria-label="설문 관리" onclick="this.nextElementSibling.classList.toggle('show')">
                                                <i class="xi-ellipsis-v"></i>
                                            </button>
                                            <div class="option-wrap">
                                                #[previewBtn]
                                                <div class="item"><a href="javascript:srvyViewMv('#[srvyId]', 1)">문항관리</a></div>
                                                <div class="item"><a href="javascript:srvyViewMv('#[srvyId]', 2)">설문평가</a></div>
                                                <div class="item"><a href="javascript:srvyViewMv('#[srvyId]', 9)">수정</a></div>
                                                <div class="item"><a href="javascript:srvyDelete('#[srvyId]', '#[srvyPtcpCnt]')">삭제</a></div>
                                            </div>
                                        </div>
									</div>
								</div>

								<div class="card-body">
									<div class="desc">
										<p><label class="label-title">설문기간</label><strong>#[srvyDttm]</strong></p>
										<p><label class="label-title">성적 반영비율</label><strong>#[mrkRfltrt]</strong></p>
										<p><label class="label-title">평가현황</label><strong>#[evlStatus]</strong></p>
										<p><label class="label-title">성적공개</label><strong>#[mrkOyn]</strong></p>
									</div>
								</div>
							</div>

							<script>
								// 리스트 테이블
								let srvyListTable = UiTable("list", {
									lang: "ko",
									pageFunc: srvyListSelect,
									columns: [
										{title:"No", 		field:"no",					headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
										{title:"구분", 		field:"srvyGbnnm",			headerHozAlign:"center", hozAlign:"left",	width:0,	minWidth:100},
										{title:"설문", 		field:"srvyTtl",			headerHozAlign:"center", hozAlign:"left",	width:0,	minWidth:200},
										{title:"설문기간", 	field:"srvyDttm", 			headerHozAlign:"center", hozAlign:"center", width:280,	minWidth:280},
										{title:"반영비율", 	field:"mrkRfltrt", 			headerHozAlign:"center", hozAlign:"center", width:0,	minWidth:100},
										{title:"참여현황", 	field:"ptcpStatus",	 		headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},
										{title:"평가현황", 	field:"evlStatus",	 		headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},
										{title:"출제상태", 	field:"srvyQstnsCmptnyn", 	headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},
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