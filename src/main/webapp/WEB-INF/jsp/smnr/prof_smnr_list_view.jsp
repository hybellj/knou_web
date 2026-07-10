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
		var SEARCH_VALUE	= '<c:out value="${vo.searchValue}" />';
		var PAGE_INDEX		= '<c:out value="${vo.pageIndex}" />';
		var LIST_SCALE		= '<c:out value="${vo.listScale}" />';

		$(document).ready(function () {
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					smnrListSelect(1);
				}
			});

			if(!PAGE_INDEX) {
				PAGE_INDEX = 1;
			}

			smnrListSelect(PAGE_INDEX);
		});

		// list scale 변경
		function changeListScale(scale) {
			LIST_SCALE = scale;
			smnrListSelect(1);
		}

		/**
		 * 세미나목록조회
		 * @param page	이동페이지
		 */
		function smnrListSelect(pageNo) {
			PAGE_INDEX   = pageNo;
			SEARCH_VALUE = $("#searchValue").val();

			const url   = "/smnr/profSmnrListAjax.do";
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
    	            	let dataList = createSmnrListHTML(data.returnList);	// 세미나 리스트 HTML 생성

    	        		smnrListTable.clearData();
    	        		smnrListTable.replaceData(dataList);
    	        		smnrListTable.setPageInfo(data.pageInfo);
    	        		UiInputmask();

    	        		mrkRfltrtFrmTrsf(2);	// 성적반영비율폼변환
                    } else {
                    	UiComm.showMessage(data.message, "error");
                    }
                },
                error		: () => UiComm.showMessage("<spring:message code='exam.error.list' />", "error"),/* 리스트 조회 중 에러가 발생하였습니다. */
                complete	: () => UiComm.showLoading(false)
            });
		}

		 /**
		  * 성적반영비율폼변환
		  * @param type - 변환 타입 번호 ( 1 : 입력폼 활성화, 2 : 취소)
		  */
		function mrkRfltrtFrmTrsf(type) {
			if(type == 1) {
				if($("span.list-card-button > button").hasClass("card")) {
					$("span.list-card-button > button").trigger("click");
				}
			}
			$(".mrkInputDiv").toggle(type == 1);
			$("#mrkRfltrtFrmTrsfBtn").toggle(type != 1);
			$(".mrkRfltrtFrmTrsfDiv").toggleClass("hidden", type != 1);
			$(".mrkRfltrtDiv").toggleClass("hidden", type == 1);
		}

		// 성적반영비율수정
		function mrkRfltrtModify() {
			let isMrkCheck 			= true;		// 성적 합계 확인 유무
			let sumMrkRfltrt 		= 0;		// 성적반영비율 합계
			let prevSumMrkRfltrt	= 0;		// 기존 성적반영비율 합계
			let smnrMrkList 		= [];		// 세미나 성적 목록

			$(".mrkRfltrt").each(function(i) {
				const mrk = Number($(this).val());

				if(mrk <= 0 || mrk > 100) {
					const msg = mrk == 0 ? "<spring:message code='exam.alert.score.ratio.0' />"/* 0점은 입력할 수 없습니다. 다른 값을 입력해주세요. */ : "<spring:message code='exam.alert.score.max.100' />"/* 점수는 100점 까지 입력 가능 합니다. */;
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

				smnrMrkList.push({
					srvyId 		: $(this).attr("data-smnrId"),	// 세미나아이디
					mrkRfltrt 	: val							// 성적반영비율
				});
			});

			if($(".mrkRfltrt").length == 0) {
				isMrkCheck = false;
				smnrListSelect(1);
			}

			if(isMrkCheck) {
				if(sumMrkRfltrt !== prevSumMrkRfltrt) {
					UiComm.showMessage("기존성적반영비율 : " + (prevSumMrkRfltrt / 100).toFixed(2) +
									   " / 새성적반영비율 : " + (sumMrkRfltrt / 100).toFixed(2) +
									   " 성적반영비율 합계가 일치하지 않습니다.", "info");
					return false;
				} else {
					$.ajax({
		                url			: "/smnr/smnrMrkRfltrtModifyAjax.do",
		                type		: "POST",
		                contentType	: "application/json",
		                data		: JSON.stringify(smnrMrkList),
		                dataType	: "json",
		                beforeSend	: () => UiComm.showLoading(true),
		                success		: function (data) {
		                    if (data.result > 0) {
		                    	UiComm.showMessage("<spring:message code='exam.alert.insert' />", "success");/* 정상 저장 되었습니다. */
				        		smnrListSelect(1);
		                    } else {
		                    	UiComm.showMessage(data.message, "error");
		                    }
		                },
		                error		: () => UiComm.showMessage("<spring:message code='exam.error.score.ratio' />", "error"),/* 반영 비율 저장 중 에러가 발생하였습니다. */
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
			const url  = "/smnr/smnrMrkOynModifyAjax.do";
			const data = {
				smnrId 	: obj.value,
				mrkOyn 	: obj.checked ? "Y" : "N"
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

		/**
		 * 세미나삭제
		 * @param smnrId 	- 세미나아이디
		 */
		function smnrDelete(smnrId) {
			const extData = {
				smnrId 	: smnrId
			};

			const url   = "/smnr/smnrDeleteAjax.do";
			const param = {
				encParams	: EPARAM,
				addParams	: UiComm.makeEncParams(extData)
			};

			ajaxCall(url, param, function(data) {
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
					// 성적반영비율
					let mrkRfltrt  = "<div class='mrkInputDiv ui input' style='display: none;'>";
						mrkRfltrt += "	<input type='text' class='mrkRfltrt w80' data-smnrId=\"" + v.smnrId + "\" data-mrkRfltrt=\"" + v.mrkRfltrt + "\" value=\"" + v.mrkRfltrt + "\" inputmask='numeric' inputmode='decimal' maxVal='100' />";
						mrkRfltrt += "</div>";
						mrkRfltrt += "<div class='mrkRfltrtDiv'>" + v.mrkRfltrt + "%</div>";
					if(v.mrkRfltyn == 'N') {
						mrkRfltrt = "0%";
					}
					// 성적공개
					let mrkOyn = "-";
					if(v.mrkRfltyn == 'Y') {
						mrkOyn = "<input type='checkbox' value=\"" + v.smnrId + "\" class='switch small' " + (v.mrkOyn == "Y" ? "checked" : "") + " onchange='modifyMrkOyn(this)' />";
					}
					// 관리
					let manage = "-";
					let manageBtn = "";
					// 오프라인 세미나
					if(v.smnrGbncd == "OFLN_SMNR") {
						manage = "<a style='line-height: 40px;' href='javascript:smnrViewMv(\"" + v.smnrId + "\", \"EVL\")' class='btn basic small'>참여관리</a>";
						manageBtn = "<div class='item'><a href='javascript:smnrViewMv(\"" + v.smnrId + "\", \"EVL\")'>참여관리​</a></div>";
					// 온라인 세미나
					} else if(v.smnrGbncd == "ONLN_SMNR") {
						// 세미나 시작가능 and 종료 전
						if(v.smnrStartyn == "Y" && v.smnrEndyn == "N") {
							// 메인교수 계정
							if("${userCtx.userId}" == v.profId) {
								manage = "<a style='line-height: 40px;' href='javascript:zoomHostStart(\"" + v.smnrId + "\")' class='btn basic small'>ZOOM 시작</a>";
								manageBtn = "<div class='item'><a href='javascript:zoomHostStart(\"" + v.smnrId + "\")'>ZOOM 시작​</a></div>";
							// 그 외
							} else {
								manage = "<a style='line-height: 40px;' href='javascript:zoomUserStart(\"" + v.smnrId + "\")' class='btn basic small'>ZOOM 시작</a>";
								manageBtn = "<div class='item'><a href='javascript:zoomUserStart(\"" + v.smnrId + "\")'>ZOOM 시작​</a></div>";
							}
						// 세미나 종료
						} else if(v.smnrEndyn == "Y") {
//							// 세미나 참석기록반영 전
//							if(v.atndRcdPfltyn == "N") {
//								manage = "<a href='javascript:zoomAtndRegist(\"" + v.smnrId + "\")' class='btn basic small'>참여기록 가져오기</a>";
//								manageBtn = "<div class='item'><a href='javascript:zoomAtndRegist(\"" + v.smnrId + "\")'>참여기록 가져오기​</a></div>";
//							// 세미나 참석기록반영 후
//							} else {
//								manage = "<a href='javascript:smnrViewMv(\"" + v.smnrId + "\", \"EVL\")' class='btn basic small'>참여관리</a>";
//								manageBtn = "<div class='item'><a href='javascript:smnrViewMv(\"" + v.smnrId + "\", \"EVL\")'>참여관리​</a></div>";
//							}
							manage = "<a style='line-height: 40px;' href='javascript:smnrViewMv(\"" + v.smnrId + "\", \"EVL\")' class='btn basic small'>참여관리</a>";
							manageBtn = "<div class='item'><a href='javascript:smnrViewMv(\"" + v.smnrId + "\", \"EVL\")'>참여관리​</a></div>";
						}
					}
					dataList.push({
						no: 				v.lineNo,
						smnrGbn: 			v.smnrGbn == "SMNR_TEAM" ? "세미나 팀" : "세미나",
						smnrGbnnm: 			v.smnrGbnnm,
						smnrnm: 			"<a href='javascript:smnrViewMv(\""+v.smnrId+"\", \"EVL\")' class='header header-icon link'>" + v.smnrnm + "</a>",
						smnrDttm: 			UiComm.formatDate(v.smnrSdttm, "datetime2") + " ~ " + UiComm.formatDate(v.smnrEdttm, "datetime2"),
						smnrMnts:			v.smnrMnts + "분",
						mrkRfltrt: 			mrkRfltrt,
						atndStatus: 		v.smnrAtndCnt +"/" + v.smnrTrgtCnt,
						evlStatus: 			"<a href='javascript:smnrViewMv(\"" + v.smnrId + "\", \"EVL\")' class='fcBlue'>" + v.smnrEvlteeCnt +"/" + v.smnrAtndCnt + "</a>",
						mrkOyn: 			mrkOyn,
						manage: 			manage,
						smnrId: 			v.smnrId,
						smnrAtndCnt: 		v.smnrAtndCnt,
						manageBtn: 			manageBtn,
						cardMrkRfltrt:		v.mrkRfltyn == 'N' ? "0%" : v.mrkRfltrt + "%"
					});
				});
			}

			return dataList;
		}

		// ZOOM 호스트 시작
		function zoomHostStart(smnrId) {
			const url  = "/zoom/zoomHostUrlSelectAjax.do";
			const data = {
	   			smnrId : smnrId
	   		};

			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					let windowOpener = window.open();
					windowOpener.location = data.data.start_url;
	        	} else {
	        		UiComm.showMessage(data.message, "error");
	        	}
			}, function(xhr, status, error) {
				UiComm.showMessage('<spring:message code="fail.common.msg" />', "error");// 에러가 발생했습니다!
			}, true);
		}

		// ZOOM 참여자 시작
		function zoomUserStart(smnrId) {
			const url  = "/zoom/zoomUserUrlSelectAjax.do";
			const data = {
	   			smnrId : smnrId
	   		};

			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					let windowOpener = window.open();
					windowOpener.location = data.data.trgtrCntnUrl;
	        	} else {
	        		UiComm.showMessage(data.message, "error");
	        	}
			}, function(xhr, status, error) {
				UiComm.showMessage('<spring:message code="fail.common.msg" />', "error");// 에러가 발생했습니다!
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
				        <div class="page-info">
				        	<h2 class="page-title">
                                세미나
                            </h2>
				        </div>
				        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="searchValue"><spring:message code='common.search.keyword'/></label></span><%-- 검색어 --%>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" name="" id="searchValue" value="${vo.searchValue}" placeholder="세미나명 입력">
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
						            <a href="javascript:smnrViewMv('', 'REGIST')" class="btn type2">세미나 등록</a>

									<%-- 리스트/카드 선택 버튼 --%>
									<span class="list-card-button"></span>

									<%-- 목록 스케일 선택 --%>
									<uiex:listScale func="changeListScale" value="${vo.listScale}" />
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
                                                <div class="item"><a href="javascript:smnrViewMv('#[smnrId]', 'MODIFY')">수정</a></div>
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
										{title:"관리", 		field:"manage", 			headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:130},
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