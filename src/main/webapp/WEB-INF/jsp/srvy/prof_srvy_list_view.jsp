<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/srvy/common/srvy_common_inc.jsp" %>
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
					srvyListSelect(1);
				}
			});

			if(!PAGE_INDEX) {
				PAGE_INDEX = 1;
			}

			srvyListSelect(PAGE_INDEX);
		});

		// list scale 변경
		function changeListScale(scale) {
			LIST_SCALE = scale;
			srvyListSelect(1);
		}

		/*
		 * 설문목록조회
		 * @param pageNo	이동페이지
		 */
		function srvyListSelect(pageNo) {
			PAGE_INDEX   = pageNo || PAGE_INDEX;
			SEARCH_VALUE = $("#searchValue").val();

			const url   = "/srvy/profSrvyListAjax.do";
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

    	        		srvyListTable.clearData();
    	        		srvyListTable.replaceData(dataList);
    	        		srvyListTable.setPageInfo(data.pageInfo);
    	        		UiInputmask();

    	        		mrkRfltrtFrmTrsf(2);	// 성적 반영비율 폼 변환
                    } else {
                    	UiComm.showMessage(data.message, "error");
                    }
                },
                error		: () => UiComm.showMessage("<spring:message code='srvy.error.list' />", "error"),/* 리스트 조회 중 에러가 발생하였습니다. */
                complete	: () => UiComm.showLoading(false)
            });
		}

		/*
		 * 성적반영비율폼변환
		 * @param type		변환 타입 번호 ( 1 : 입력폼 활성화, 2 : 취소)
		 */
		function mrkRfltrtFrmTrsf(type) {
			if(type == 1 && $("span.list-card-button > button").hasClass("card")) {
				$("span.list-card-button > button").trigger("click");
			}
			$(".mrkInputDiv").toggle(type == 1);
			$("#mrkRfltrtFrmTrsfBtn").toggle(type != 1);
			$(".mrkRfltrtFrmTrsfDiv").toggleClass("hidden", type != 1);
			$(".mrkRfltrtDiv").toggleClass("hidden", type == 1);
		}

		/*
		 * 성적반영비율수정
		 * @param srvyId		설문아이디
		 * @param mrkRfltrt		성적반영비율
		 */
		function mrkRfltrtModify() {
			let isMrkCheck 			= true;		// 성적 합계 확인 유무
			let sumMrkRfltrt 		= 0;		// 성적반영비율 합계
			let prevSumMrkRfltrt	= 0;		// 기존 성적반영비율 합계
			let srvyMrkList 		= [];		// 설문 성적 목록

			$(".mrkRfltrt").each(function(i) {
				const mrk = Number($(this).val());

				if(mrk <= 0 || mrk > 100) {
					const msg = mrk == 0 ? "<spring:message code='srvy.alert.score.ratio.0' />"/* 0점은 입력할 수 없습니다. 다른 값을 입력해주세요. */ : "<spring:message code='srvy.alert.score.max.100' />"/* 점수는 100점 까지 입력 가능 합니다. */;
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

				srvyMrkList.push({
					srvyId 		: $(this).attr("data-srvyId"),	// 설문아이디
					mrkRfltrt 	: val							// 성적반영비율
				});
			});

			if($(".mrkRfltrt").length == 0) {
				isMrkCheck = false;
				srvyListSelect(1);	// 설문목록조회
			}

			if(isMrkCheck) {
				if(sumMrkRfltrt !== prevSumMrkRfltrt) {
					UiComm.showMessage("<spring:message code='srvy.alert.score.ratio.not.match' arguments='"+(prevSumMrkRfltrt / 100).toFixed(2)+","+(sumMrkRfltrt / 100).toFixed(2)+"' />", "info");/* 기존성적반영비율 : {0} / 새성적반영비율 : {1} 성적반영비율 합계가 일치하지 않습니다. */
					return false;
				} else {
					$.ajax({
		                url			: "/srvy/srvyMrkRfltrtModifyAjax.do",
		                type		: "POST",
		                contentType	: "application/json",
		                data		: JSON.stringify(srvyMrkList),
		                dataType	: "json",
		                beforeSend	: () => UiComm.showLoading(true),
		                success		: function (data) {
		                    if (data.result > 0) {
		                    	UiComm.showMessage("<spring:message code='srvy.alert.insert' />", "success");/* 정상 저장 되었습니다. */
				        		srvyListSelect(1);	// 설문목록조회
		                    } else {
		                    	UiComm.showMessage(data.message, "error");
		                    }
		                },
		                error		: () => UiComm.showMessage("<spring:message code='srvy.error.score.ratio' />", "error"),/* 반영 비율 저장 중 에러가 발생하였습니다. */
		                complete	: () => UiComm.showLoading(false)
		            });
				}
			}
		}

		/*
		 * 성적공개여부수정
		 * @param obj	수정할객체
		 */
		function modifyMrkOyn(obj) {
			sbjctMrkOynSrvyCntSelect().done(function(result) {
				if(result > 0 && obj.checked) {
					UiComm.showMessage("<spring:message code='srvy.alert.sbjct.score.one.srvy' />", "info");/* 과목당 한 개의 설문만 성적 공개가 가능합니다. */
					UiSwitcherOff(obj.id);
					return;
				}

				if(obj.dataset.qstnscmptn == "N" && obj.checked) {
					UiComm.showMessage("<spring:message code='srvy.alert.already.qstn.submit' />", "info");/* 문항 출제 완료 후 성적 공개가 가능합니다. */
					UiSwitcherOff(obj.id);
					return;
				}

				const url  = "/srvy/srvyMrkOynModifyAjax.do";
				const data = {
					srvyId 	: obj.value,
					mrkOyn 	: obj.checked ? "Y" : "N"
				};

				ajaxCall(url, data, function(data) {
					if (data.result > 0) {
			    		srvyListSelect(1);	// 설문목록조회
			        } else {
			        	UiComm.showMessage(data.message, "error");
			        }
				}, function(xhr, status, error) {
					UiComm.showMessage("<spring:message code='srvy.error.score.open' />", "error");/* 성적 공개 변경 중 에러가 발생하였습니다. */
				}, true);
			});
		}

		/*
		 * 설문지미리보기팝업
		 * @param srvyId	설문아이디
		 */
		function srvypprPreviewPopup(srvyId) {
			 dialog = UiDialog("dialog1", {
				title		: "<spring:message code='srvy.label.preview.srvyppr' />",/* 설문지 미리보기 */
				url			: "/srvy/profSrvypprPreviewPopup.do?srvyId="+srvyId+"&searchValue=GNRL",
				fullscreen	: true
			});
		}

		/*
		 * 설문삭제
		 * @param srvyId 	설문아이디
		 * @param joinCnt 	응시수
		 */
		function srvyDelete(srvyId, joinCnt) {
			let confirm = "<spring:message code='srvy.confirm.delete.answer.user.n' />";/* 설문 응시한 학습자가 없습니다. 삭제 하시겠습니까? */
			if(joinCnt > 0) {
				confirm = "<spring:message code='srvy.confirm.delete.answer.user.y' />";/* 설문 응시한 학습자가 있습니다. 삭제 시 학습정보가 삭제됩니다. 정말 삭제하시겠습니까? */
			}
			UiComm.showMessage(confirm, "confirm")
			.then(function(result) {
				if (result) {
					const extData = {
						srvyId 	: srvyId,
						delyn	: "Y"
					};

					const url   = "/srvy/srvyDeleteAjax.do";
					const param = {
						encParams	: EPARAM,
						addParams	: UiComm.makeEncParams(extData)
					};

					ajaxCall(url, param, function(data) {
						if (data.result > 0) {
							UiComm.showMessage("<spring:message code='srvy.alert.delete' />", "success");/* 정상 삭제 되었습니다. */
			        		srvyListSelect(1);	// 설문목록조회
			            } else {
			             	UiComm.showMessage(data.message, "error");
			            }
		    		}, function(xhr, status, error) {
		    			UiComm.showMessage("<spring:message code='srvy.error.delete' />", "error");/* 삭제 중 에러가 발생하였습니다. */
		    		}, true);
				}
			});
		}

		// 목록 HTML 생성
		function createListHTML(list) {
			let dataList = [];

			if(list.length == 0) return dataList;

			list.forEach(function(v,i) {
				// 설문구분
				let srvyGbnnm = {
					"SRVY"		: "<spring:message code='srvy.common.srvy' />"/* 설문 */,
					"SRVY_TEAM"	: "<spring:message code='srvy.common.srvy.team' />"/* 설문 팀 */
				};
				// 성적반영비율
				let mrkRfltrt  = "<div class='mrkInputDiv ui input' style='display: none;'>";
					mrkRfltrt += "	<input type='text' class='mrkRfltrt w80' data-srvyId=\"" + v.srvyId + "\" data-mrkRfltrt=\"" + v.mrkRfltrt + "\" value=\"" + v.mrkRfltrt + "\" inputmask='numeric' inputmode='decimal' maxVal='100' />";
					mrkRfltrt += "</div>";
					mrkRfltrt += "<div class='mrkRfltrtDiv'>" + v.mrkRfltrt + "%</div>";
				if(v.mrkRfltyn == 'N') {
					mrkRfltrt = "0%";
				}
				// 출제상태
				let srvyQstnsCmptnyn = wrapLabel("<spring:message code='exam.label.qstn.temp.save' />", "fcRed");/* 임시저장 */
				if(v.srvyQstnsCmptnyn == 'Y') {
					srvyQstnsCmptnyn = "<spring:message code='exam.label.qstn.submit.y' />";/* 출제완료 */
				}
				// 성적공개
				let mrkOyn = "-";
				if(v.mrkRfltyn == 'Y') {
					mrkOyn = "<input type='checkbox' value=\"" + v.srvyId + "\" class='switch small' " + (v.mrkOyn == "Y" ? "checked" : "") + " onchange='modifyMrkOyn(this)' data-qstnsCmptn=\"" + v.srvyQstnsCmptnyn + "\">";
				}
				// 미리보기
				let preview = "-";
				let previewBtn = "";
				if(v.srvyQstnsCmptnyn == 'Y') {
					preview = "<a style='line-height: 40px;' href='javascript:srvypprPreviewPopup(\"" + v.srvyId + "\")' class='btn basic small'><spring:message code='srvy.button.preview' />​</a>";/* 미리보기 */
					previewBtn = "<div class='item'><a href='javascript:srvypprPreviewPopup(\"" + v.srvyId + "\")'><spring:message code='srvy.button.preview' />​</a></div>";/* 미리보기 */
				}
				dataList.push({
					no: 				v.lineNo,
					srvyGbnnm: 			srvyGbnnm[v.srvyGbn],
					srvyTtl: 			"<a href='javascript:srvyViewMv(\""+v.srvyId+"\", \"PROFEVL\")' class='header header-icon link'>" + UiComm.escapeHtml(v.srvyTtl) + "</a>",
					srvyDttm: 			UiComm.formatDate(v.srvySdttm, "datetime2") + " ~ " + UiComm.formatDate(v.srvyEdttm, "datetime2"),
					mrkRfltrt: 			mrkRfltrt,
					ptcpStatus: 		"<a href='javascript:srvyViewMv(\"" + v.srvyId + "\", \"PROFEVL\")' class='fcBlue'>" + v.srvyPtcpCnt +"/" + v.srvyTrgtCnt + "</a>",
					evlStatus: 			"<a href='javascript:srvyViewMv(\"" + v.srvyId + "\", \"PROFEVL\")' class='fcBlue'>" + v.srvyEvlteeCnt +"/" + v.srvyPtcpCnt + "</a>",
					srvyQstnsCmptnyn: 	srvyQstnsCmptnyn,
					mrkOyn: 			mrkOyn,
					preview: 			preview,
					srvyId: 			v.srvyId,
					srvyPtcpCnt: 		v.srvyPtcpCnt,
					previewBtn: 		previewBtn,
				});
			});

			return dataList;
		}

		/*
		 * 과목성적공개설문수조회
		 * @param sbjctId 	과목아이디
		 */
		function sbjctMrkOynSrvyCntSelect() {
			let deferred = $.Deferred();

			const url  = "/srvy/sbjctMrkOynSrvyCntSelectAjax.do";
			const data = {
				encParams : EPARAM
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
                                <spring:message code="srvy.common.srvy" /><!-- 설문 -->
                            </h2>
				        </div>
				        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="searchValue"><spring:message code='common.search.keyword'/></label></span><%-- 검색어 --%>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" id="searchValue" value="${vo.searchValue}" placeholder="<spring:message code='srvy.placeholder.input.srvy.ttl' />"><!-- 설문명 입력 -->
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="srvyListSelect(1)"><spring:message code="srvy.button.search" /></button><%-- 검색 --%>
                            </div>
                        </div>

						<div id="srvyListArea">
							<div class="board_top">
	                            <h3 class="board-title"><spring:message code="srvy.label.list" /><!-- 목록 --></h3>
	                            <div class="right-area">
									<div class="mrkRfltrtFrmTrsfDiv">
								     	<a href="javascript:mrkRfltrtModify()" class="btn type2"><spring:message code="resh.button.score.ratio.save" /><!-- 성적반영비율저장 --></a>
								     	<a href="javascript:mrkRfltrtFrmTrsf(2)" class="btn type2"><spring:message code="srvy.button.cancel" /><!-- 취소 --></a>
							        </div>
							        <a href="javascript:mrkRfltrtFrmTrsf(1)" id="mrkRfltrtFrmTrsfBtn" class="btn type2"><spring:message code="resh.button.score.ratio.chg" /><!-- 성적반영비율조정 --></a>
						            <a href="javascript:srvyViewMv('', 'PROFREGIST')" class="btn type2"><spring:message code="srvy.button.reg.srvy" /><!-- 설문 등록 --></a>

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
                                                <div class="item"><a href="javascript:srvyViewMv('#[srvyId]', 'PROFQSTN')"><spring:message code="srvy.button.qstn" /><!-- 문항관리 --></a></div>
                                                <div class="item"><a href="javascript:srvyViewMv('#[srvyId]', 'PROFEVL')"><spring:message code="srvy.button.evl" /><!-- 설문평가 --></a></div>
                                                <div class="item"><a href="javascript:srvyViewMv('#[srvyId]', 'PROFMODIFY')"><spring:message code="srvy.button.modify" /><!-- 수정 --></a></div>
                                                <div class="item"><a href="javascript:srvyDelete('#[srvyId]', '#[srvyPtcpCnt]')"><spring:message code="srvy.button.delete" /><!-- 삭제 --></a></div>
                                            </div>
                                        </div>
									</div>
								</div>

								<div class="card-body">
									<div class="desc">
										<p><label class="label-title"><spring:message code="srvy.label.period" /><!-- 설문기간 --></label><strong>#[srvyDttm]</strong></p>
										<p><label class="label-title"><spring:message code="srvy.label.score.ratio" /><!-- 성적 반영비율 --></label><strong>#[mrkRfltrt]</strong></p>
										<p><label class="label-title"><spring:message code="srvy.label.evl.status" /><!-- 평가현황 --></label><strong>#[evlStatus]</strong></p>
										<p><label class="label-title"><spring:message code="srvy.label.score.open.yn" /><!-- 성적공개 --></label><strong>#[mrkOyn]</strong></p>
									</div>
								</div>
							</div>

							<script>
								// 리스트 테이블
								let srvyListTable = UiTable("list", {
									lang: "ko",
									pageFunc: srvyListSelect,
									columns: [
										{title:"No", 													field:"no",					headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
										{title:"<spring:message code='srvy.label.type' />", 			field:"srvyGbnnm",			headerHozAlign:"center", hozAlign:"left",	width:100,	minWidth:100},/* 구분 */
										{title:"<spring:message code='srvy.common.srvy' />", 			field:"srvyTtl",			headerHozAlign:"center", hozAlign:"left",	width:0,	minWidth:200},/* 설문 */
										{title:"<spring:message code='srvy.label.period' />", 			field:"srvyDttm", 			headerHozAlign:"center", hozAlign:"center", width:280,	minWidth:280},/* 설문기간 */
										{title:"<spring:message code='srvy.label.ratio' />", 			field:"mrkRfltrt", 			headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},/* 반영비율 */
										{title:"<spring:message code='srvy.label.ptcp.status' />", 		field:"ptcpStatus",	 		headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},/* 참여현황 */
										{title:"<spring:message code='srvy.label.evl.status' />", 		field:"evlStatus",	 		headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},/* 평가현황 */
										{title:"<spring:message code='srvy.label.submit.status' />", 	field:"srvyQstnsCmptnyn", 	headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},/* 출제상태 */
										{title:"<spring:message code='srvy.label.score.open.yn' />", 	field:"mrkOyn", 			headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},/* 성적공개 */
										{title:"<spring:message code='srvy.button.preview' />", 		field:"preview", 			headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},/* 미리보기 */
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