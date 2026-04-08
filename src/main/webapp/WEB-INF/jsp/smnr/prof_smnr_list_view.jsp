<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/smnr/common/smnr_common_inc.jsp" %>
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
			smnrListSelect(1);

			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					smnrListSelect(1);
				}
			});
		});

		// list scale 변경
		function changeListScale() {
			smnrListSelect(1);
		}

		/**
		 * 세미나목록조회
		 * @param {Integer} pageIndex 		- 현재 페이지
		 * @param {String}  listScale 		- 페이징 목록 수
		 * @param {String}  sbjctId 		- 과목아이디
		 * @param {String}  searchValue 	- 검색어(세미나명)
		 * @returns {list} 세미나목록
		 */
		function smnrListSelect(page) {
			var url = "/smnr/profSmnrListAjax.do";
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
	        		var dataList = createSmnrListHTML(returnList);	// 세미나 리스트 HTML 생성

	        		smnrListTable.clearData();
	        		smnrListTable.replaceData(dataList);
	        		smnrListTable.setPageInfo(data.pageInfo);
	        		UiInputmask();

	        		mrkRfltrtFrmTrsf(2);	// 성적반영비율폼변환
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
				if($("span.list-card-button > button").hasClass("card")) {
					$("span.list-card-button > button").trigger("click");
				}
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
			var smnrMrkList = [];		// 세미나 성적 목록

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

				sumMrkRfltrt += Number($(this).val());

				var smnrMrk = {
					smnrId : $(this).attr("data-smnrId"),	// 세미나아이디
					mrkRfltrt : $(this).val()				// 성적반영비율
				};
				smnrMrkList.push(smnrMrk);
			});

			if($(".mrkRfltrt").length == 0) {
				isMrkCheck = false;
				smnrListSelect(1);
			}

			if(isMrkCheck) {
				if(Number(sumMrkRfltrt) != 100) {
					UiComm.showMessage("["+sumMrkRfltrt+"] <spring:message code='exam.alert.always.exam.score.ratio.100' />", "info");/* 상시 성적 반영 비율이 100%여야 합니다. */
					return false;
				} else {
					$.ajax({
		                url: "/smnr/smnrMrkRfltrtModifyAjax.do",
		                type: "POST",
		                contentType: "application/json",
		                data: JSON.stringify(smnrMrkList),
		                dataType: "json",
		                beforeSend: function () {
		                	UiComm.showLoading(true);
		                },
		                success: function (data) {
		                    if (data.result > 0) {
		                    	UiComm.showMessage("<spring:message code='exam.alert.insert' />", "success");/* 정상 저장 되었습니다. */
				        		smnrListSelect(1);
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
		 * @param {String} smnrId	- 세미나아이디
		 * @param {String} mrkOyn 	- 성적공개여부
		 */
		document.addEventListener('change', (e) => {
			if(e.target.classList.contains('switch')) {
				var mrkOyn = e.target.checked ? "Y" : "N";
				var url  = "/smnr/smnrMrkOynModifyAjax.do";
				var data = {
					"smnrId" 	: e.target.value,
					"mrkOyn" 	: mrkOyn
				};

				ajaxCall(url, data, function(data) {
					if (data.result > 0) {
				    		smnrListSelect(1);
				        } else {
				        	UiComm.showMessage(data.message, "error");
				        }
				}, function(xhr, status, error) {
					UiComm.showMessage("<spring:message code='exam.error.score.open' />", "error");/* 성적 공개 변경 중 에러가 발생하였습니다. */
				}, true);
			}
		});

		/**
		 * 세미나화면이동
		 * @param {String}  smnrId 		- 세미나아이디
		 * @param {String}  sbjctId 	- 과목아이디
		 */
		function smnrViewMv(smnrId, tab) {
			var urlMap = {
				"1" : "/srvy/profSrvyQstnMngView.do",		// 세미나 평가 관리 화면
				"8" : "/smnr/profSmnrRegistView.do", 		// 세미나 등록 화면
				"9" : "/smnr/profSmnrModifyView.do" 		// 세미나 수정 화면
			};

			var kvArr = [];

			kvArr.push({'key' : 'smnrId',   	'val' : smnrId});
			kvArr.push({'key' : 'sbjctId', 		'val' : "${sbjctId}"});

			submitForm(urlMap[tab], kvArr);
		}

		/**
		 * 세미나삭제
		 * @param {String}  smnrId 		- 세미나아이디
		 * @param {String}  sbjctId 	- 과목아이디
		 */
		function smnrDelete(smnrId) {
			var url  = "/smnr/smnrDeleteAjax.do";
			var data = {
				  "smnrId" 	: smnrId
				, "sbjctId"	: "${sbjctId}"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					UiComm.showMessage("<spring:message code='exam.alert.delete' />", "success");/* 정상 삭제 되었습니다. */
			    		smnrListSelect(1);
			        } else {
			         	UiComm.showMessage(data.message, "error");
			        }
		    }, function(xhr, status, error) {
		    	UiComm.showMessage("<spring:message code='exam.error.delete' />", "error");/* 삭제 중 에러가 발생하였습니다. */
		    }, true);
		}

		// 세미나 리스트 HTML 생성
		function createSmnrListHTML(smnrList) {
			let dataList = [];

			if(smnrList.length == 0) {
				return dataList;
			} else {
				smnrList.forEach(function(v,i) {
					var smnrGbn = v.smnrGbn == "SMNR_TEAM" ? "세미나 팀" : "세미나";
					// 제목
					var smnrnm = "<a href='javascript:smnrViewMv(\""+v.smnrId+"\", 2)' class='header header-icon link'>" + v.smnrnm + "</a>";
					// 기간
					var smnrDttm = UiComm.formatDate(v.smnrSdttm, "datetime2") + " ~ " + UiComm.formatDate(v.smnrEdttm, "datetime2");
					// 시간
					var smnrMnts = v.smnrMnts + "분";
					// 성적반영비율
					var cardMrkRfltrt = v.mrkRfltrt + "%";
					var mrkRfltrt  = "<div class='mrkInputDiv ui input'>";
						mrkRfltrt += "	<input type='text' class='mrkRfltrt w80' data-smnrId=\"" + v.smnrId + "\" value=\"" + v.mrkRfltrt + "\" inputmask='numeric' inputmode='decimal' maxVal='100' />";
						mrkRfltrt += "</div>";
						mrkRfltrt += "<div class='mrkRfltrtDiv'>" + v.mrkRfltrt + "%</div>";
					if(v.mrkRfltyn == 'N') {
						mrkRfltrt = "0%";
						cardMrkRfltrt = "0%";
					}
					// 참석현황
					var atndStatus = "<a href='javascript:smnrViewMv(\"" + v.smnrId + "\", 2)' class='fcBlue'>" + v.smnrAtndCnt +"/" + v.smnrTrgtCnt + "</a>";
					// 평가현황
					var evlStatus = "<a href='javascript:smnrViewMv(\"" + v.smnrId + "\", 2)' class='fcBlue'>" + v.smnrEvlteeCnt +"/" + v.smnrAtndCnt + "</a>";
					// 성적공개
					var mrkOyn = "";
					if(v.mrkRfltyn == 'N') {
						mrkOyn = "-";
					} else {
						mrkOyn = "<input type='checkbox' value=\"" + v.smnrId + "\" class='switch small' " + (v.mrkOyn == "Y" ? "checked" : "") + " />";
					}
					// 관리
					var manage = "-";
					var manageBtn = "";
					// 오프라인 세미나
					if(v.smnrGbncd == "OFLN_SMNR") {
						manage = "<a href='javascript:smnrViewMv(\"" + v.smnrId + "\", 1)' class='btn basic small'>참여관리</a>";
						manageBtn = "<div class='item'><a href='javascript:smnrViewMv(\"" + v.smnrId + "\", 1)'>참여관리​</a></div>";
					// 온라인 세미나
					} else if(v.smnrGbncd == "ONLN_SMNR") {
						// 세미나 시작가능 and 종료 전
						if(v.smnrStartyn == "Y" && v.smnrEndyn == "N") {
							// 메인교수 계정
							if("${userId}" == v.profId) {
								manage = "<a href='javascript:zoomHostStart(\"" + v.smnrId + "\")' class='btn basic small'>ZOOM 시작</a>";
								manageBtn = "<div class='item'><a href='javascript:zoomHostStart(\"" + v.smnrId + "\")'>ZOOM 시작​</a></div>";
							// 그 외
							} else {
								manage = "<a href='javascript:zoomUserStart(\"" + v.smnrId + "\")' class='btn basic small'>ZOOM 시작</a>";
								manageBtn = "<div class='item'><a href='javascript:zoomUserStart(\"" + v.smnrId + "\")'>ZOOM 시작​</a></div>";
							}
						// 세미나 종료
						} else if(v.smnrEndyn == "Y") {
							// 세미나 참석기록반영 전
							if(v.atndRcdPfltyn == "N") {
								manage = "<a href='javascript:zoomAtndRegist(\"" + v.smnrId + "\")' class='btn basic small'>참여기록 가져오기</a>";
								manageBtn = "<div class='item'><a href='javascript:zoomAtndRegist(\"" + v.smnrId + "\")'>ZOOM 시작​</a></div>";
							// 세미나 참석기록반영 후
							} else {
								manage = "<a href='javascript:smnrViewMv(\"" + v.smnrId + "\", 1)' class='btn basic small'>참여관리</a>";
								manageBtn = "<div class='item'><a href='javascript:smnrViewMv(\"" + v.smnrId + "\", 1)'>참여관리​</a></div>";
							}
						}
					}
					dataList.push({
						no: 				v.lineNo,
						smnrGbn: 			smnrGbn,
						smnrGbnnm: 			v.smnrGbnnm,
						smnrnm: 			smnrnm,
						smnrDttm: 			smnrDttm,
						smnrMnts:			smnrMnts,
						mrkRfltrt: 			mrkRfltrt,
						atndStatus: 		atndStatus,
						evlStatus: 			evlStatus,
						mrkOyn: 			mrkOyn,
						manage: 			manage,
						smnrId: 			v.smnrId,
						smnrAtndCnt: 		v.smnrAtndCnt,
						manageBtn: 			manageBtn,
						cardMrkRfltrt:		cardMrkRfltrt
					});
				});
			}

			return dataList;
		}

		// ZOOM 호스트 시작
		function zoomHostStart(smnrId) {
			var url = "/zoom/zoomHostUrlSelectAjax.do";
			var data = {
	   			"smnrId" : smnrId
	   		};

			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var windowOpener = window.open();
					windowOpener.location = data.returnVO.start_url;
	        	} else {
	        		UiComm.showMessage(data.message, "error");
	        	}
			}, function(xhr, status, error) {
				UiComm.showMessage('<spring:message code="fail.common.msg" />', "error");// 에러가 발생했습니다!
			}, true);
		}

		// ZOOM 참여자 시작 ( 임시 )
		function zoomUserStart(smnrId) {
			var url = "/zoom/zoomHostUrlSelectAjax.do";
			var data = {
	   			"smnrId" : smnrId
	   		};

			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var windowOpener = window.open();
					windowOpener.location = data.returnVO.join_url;
	        	} else {
	        		UiComm.showMessage(data.message, "error");
	        	}
			}, function(xhr, status, error) {
				UiComm.showMessage('<spring:message code="fail.common.msg" />', "error");// 에러가 발생했습니다!
			}, true);
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
                                세미나
                            </h2>
				        </div>
				        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="searchValue"><spring:message code='common.search.keyword'/></label></span><%-- 검색어 --%>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" name="" id="searchValue" value="${param.searchValue}" placeholder="세미나명 입력">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="smnrListSelect(1)"><spring:message code='button.search'/></button><%-- 검색 --%>
                            </div>
                        </div>

						<div id="smnrListArea">
							<div class="board_top">
	                            <h3 class="board-title">목록</h3>
	                            <div class="right-area">
									<div class="mrkRfltrtFrmTrsfDiv">
								     	<a href="javascript:mrkRfltrtModify()" class="btn type2">성적반영비율저장</a>
								     	<a href="javascript:mrkRfltrtFrmTrsf(2)" class="btn type2">취소</a>
							        </div>
							        <a href="javascript:mrkRfltrtFrmTrsf(1)" id="mrkRfltrtFrmTrsfBtn" class="btn type2">성적반영비율조정</a>
						            <a href="javascript:smnrViewMv('', 8)" class="btn type2">세미나 등록</a>

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
									#[smnrGbn]
									<div class="card-title">
										#[smnrnm]
									</div>
									<div class="btn_right">
										<div class="dropdown">
                                            <button type="button" class="btn basic icon set settingBtn" aria-label="설문 관리" onclick="this.nextElementSibling.classList.toggle('show')">
                                                <i class="xi-ellipsis-v"></i>
                                            </button>
                                            <div class="option-wrap">
                                                #[manageBtn]
                                                <div class="item"><a href="javascript:smnrViewMv('#[smnrId]', 9)">수정</a></div>
                                                <div class="item"><a href="javascript:smnrDelete('#[smnrId]')">삭제</a></div>
                                            </div>
                                        </div>
									</div>
								</div>

								<div class="card-body">
									<div class="desc">
										<p><label class="label-title">진행일시</label><strong>#[smnrDttm]</strong></p>
										<p><label class="label-title">진행시간</label><strong>#[smnrMnts]</strong></p>
										<p><label class="label-title">성적반영비율</label><strong>#[cardMrkRfltrt]</strong></p>
										<p><label class="label-title">평가현황</label><strong>#[evlStatus]</strong></p>
										<p><label class="label-title">성적공개</label><strong>#[mrkOyn]</strong></p>
										<p><label class="label-title">방식</label><strong>#[smnrGbnnm]</strong></p>
									</div>
								</div>
							</div>

							<script>
								// 리스트 테이블
								let smnrListTable = UiTable("list", {
									lang: "ko",
									pageFunc: smnrListSelect,
									columns: [
										{title:"No", 		field:"no",					headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
										{title:"구분", 		field:"smnrGbn",			headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},
										{title:"방식", 		field:"smnrGbnnm",			headerHozAlign:"center", hozAlign:"center",	width:130,	minWidth:130},
										{title:"세미나", 		field:"smnrnm",				headerHozAlign:"center", hozAlign:"left",	width:0,	minWidth:200},
										{title:"진행일시", 	field:"smnrDttm", 			headerHozAlign:"center", hozAlign:"center", width:280,	minWidth:280},
										{title:"진행시간", 	field:"smnrMnts", 			headerHozAlign:"center", hozAlign:"center", width:0,	minWidth:100},
										{title:"반영비율", 	field:"mrkRfltrt",	 		headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},
										{title:"참여현황", 	field:"atndStatus",	 		headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},
										{title:"평가현황", 	field:"evlStatus", 			headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},
										{title:"성적공개", 	field:"mrkOyn", 			headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},
										{title:"관리", 		field:"manage", 			headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},
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