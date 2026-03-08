<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>

	<script type="text/javascript">
		var PAGE_INDEX = 1;
		var LIST_SCALE = 10;
		var isRatioEditMode = false;	// 반영비율 편집 모드 상태

		$(document).ready(function() {
			loadExamList();

			/* 성적공개 switch 변경 이벤트 */
			$(document).on("change", "#examList .exam-pp-switch", function() {
				var $switch = $(this);
				var examBscId = $switch.data("examBscId");
				var mrkOyn = $switch.is(":checked") ? "Y" : "N";

				UiComm.showMessage("수정 하시겠습니까?", "confirm")
				.then(function(result) {
					if (result) {
						$.ajax({
							url: "/exam/editMrkOyn.do",
							type: "POST",
							data: { examBscId: examBscId, mrkOyn: mrkOyn },
							success: function() {
								UiComm.showMessage("공개 상태가 수정되었습니다.", "success");
								initExamSwitcher();
							},
							error: function() {
								UiComm.showMessage("저장에 실패했습니다.", "error");
							}
						});
					} else {
						// 취소 시 체크박스 원래 상태로 복원
						var prevChecked = mrkOyn !== "Y";
						$switch.prop("checked", prevChecked);
						$switch.prev(".ui-switcher").attr("aria-checked", prevChecked);
					}
				});
			});

			/* 시험 등록 버튼 */
			$("#exam-add-btn").on("click", function() {
				location.href = "/exam/Form/examWrite.do";
			});

			/* 성적반영 비율조정 버튼 */
			$("#mrkRfltrt-modify-btn").on("click", function() {
				if (!isRatioEditMode) {
					isRatioEditMode = true;
					$(this).text("비율 저장 완료");
					enableRatioInputs(true);
				} else {
					// 반영비율 합계 검증 (EXAM_MID, EXAM_LST 제외)
					var totalRatio = 0;
					$('#examList .ratio-input:visible').each(function() {
						var examGubuncd = $(this).data('examGbncd');
						if (examGubuncd !== 'EXAM_MID' && examGubuncd !== 'EXAM_LST') {
							totalRatio += parseInt($(this).val()) || 0;
						}
					});
					if (totalRatio !== 100) {
						UiComm.showMessage("성적반영 비율 합이 100%가 되어야 합니다.\n다시 확인 바랍니다.", "warning");
						return;
					}
					isRatioEditMode = false;
					$(this).text("성적반영 비율조정");
					enableRatioInputs(false);
					// TODO: AJAX 저장
				}
			});

			/* ===== 테스트용 버튼 ===== */
			$("#test1, #test2").on("click", function() {
				location.href = "/exam/Form/examInfoManage.do";
			});
		});

		/* 시험 목록 조회 */
		function loadExamList(pageIndex) {
			PAGE_INDEX = pageIndex || PAGE_INDEX;

			var url = "/exam/profExamPaging.do";
			var param = {
				pageIndex: PAGE_INDEX,
				listScale: LIST_SCALE
			};

			UiComm.showLoading(true);

			$.ajax({
				url: url,
				type: "GET",
				data: param,
				dataType: "json",
				success: function(data) {
					if (data.result > 0) {
						var returnList = data.returnList || [];
						var tableData = createExamListData(returnList, data.pageInfo);

						examListTable.clearData();
						examListTable.replaceData(tableData);
						examListTable.setPageInfo(data.pageInfo);

						// 스위치 초기화 (동적으로 추가된 체크박스를 ui-switcher로 변환)
						initExamSwitcher();
					} else {
						alert(data.message);
					}
				},
				error: function(xhr, status, error) {
					alert("에러가 발생했습니다!");
				},
				complete: function() {
					UiComm.showLoading(false);
				}
			});
		}

		/* 시험 목록 데이터 생성 */
		function createExamListData(list, pageInfo) {
			var dataList = [];

			if (!list || list.length == 0) {
				return dataList;
			}

			list.forEach(function(v, i) {
				var lineNo = pageInfo.totalRecordCount - v.lineNo + 1;

				var mrkOynHtml = '<input type="checkbox" class="switch exam-pp-switch"' +
					' data-lineno="' + v.lineNo + '"' +
					' data-exam-bsc-id="' + v.examBscId + '"' +
					(v.mrkOyn === 'Y' ? ' checked="checked"' : '') + '>';

				// 관리 버튼
				var manageExamBtns =
					'<button type="button" class="btn small" data-exam-bsc-id="' + v.examBscId + '" data-exam-gbn-cd="' + v.examGbncd + '">시험 대체</button> ' +
					'<button type="button" class="btn small" data-exam-bsc-id="' + v.examBscId + '" data-exam-gbn-cd="' + v.examGbncd + '">응시현황</button> ' +
					'<button type="button" class="btn small" data-exam-bsc-id="' + v.examBscId + '" data-exam-gbn-cd="' + v.examGbncd + '">시험지 보기</button> ' +
					'<button type="button" class="btn small" data-exam-bsc-id="' + v.examBscId + '" data-exam-gbn-cd="' + v.examGbncd + '">장애인/고령자 지원현황</button> ' +
					'<button type="button" class="btn small" data-exam-bsc-id="' + v.examBscId + '" data-exam-gbn-cd="' + v.examGbncd + '">결시현황</button>';

				var manageQuizBtns =
					'<button type="button" class="btn small" data-exam-bsc-id="' + v.examBscId + '" data-exam-gbn-cd="' + v.examGbncd + '">퀴즈정보 및 평가</button>';

				var manageOtherBtns =
					'<button type="button" class="btn small" data-exam-bsc-id="' + v.examBscId + '" data-exam-gbn-cd="' + v.examGbncd + '">응시현황</button> ' +
					'<button type="button" class="btn small" data-exam-bsc-id="' + v.examBscId + '" data-exam-gbn-cd="' + v.examGbncd + '">시험지 보기</button> ' +
					'<button type="button" class="btn small" data-exam-bsc-id="' + v.examBscId + '" data-exam-gbn-cd="' + v.examGbncd + '">결시현황</button>';

                var manageBtns;
                // 1. 시험(팀)일 경우
                // 2. 중간, 기말 시험(팀)일 경우
                if (v.examGbncd === 'EXAM' || v.examGbncd === 'EXAM_TEAM') {
                    // 1-1. 실시간 온라인
                    // 1-2. 퀴즈
                    if (v.tkexamMthdCd === 'RLTM') {
                        manageBtns = manageOtherBtns;
                    } else if (v.tkexamMthdCd === 'QUIZ') {
                        manageBtns = manageQuizBtns;
                    }
                } else {
                    if (v.tkexamMthdCd === 'RLTM') {
                        manageBtns = manageExamBtns;
                    } else if (v.tkexamMthdCd === 'QUIZ') {
                        manageBtns = manageQuizBtns;
                    }
                }

                // 카드 관리 버튼 (option-wrap 용)
				var manageCardExamBtns =
					'<div class="item" data-exam-bsc-id="' + v.examBscId + '" data-exam-gbn-cd="' + v.examGbncd + '"><a href="#0">시험 대체</a></div>' +
					'<div class="item" data-exam-bsc-id="' + v.examBscId + '" data-exam-gbn-cd="' + v.examGbncd + '"><a href="#0">응시현황</a></div>' +
					'<div class="item" data-exam-bsc-id="' + v.examBscId + '" data-exam-gbn-cd="' + v.examGbncd + '"><a href="#0">시험지 보기</a></div>' +
					'<div class="item" data-exam-bsc-id="' + v.examBscId + '" data-exam-gbn-cd="' + v.examGbncd + '"><a href="#0">장애인/고령자 지원현황</a></div>' +
					'<div class="item" data-exam-bsc-id="' + v.examBscId + '" data-exam-gbn-cd="' + v.examGbncd + '"><a href="#0">결시현황</a></div>' +
                    '<div class="item" data-exam-bsc-id="' + v.examBscId + '" data-exam-gbn-cd="' + v.examGbncd + '"><a href="#0">수정</a></div>' +
                    '<div class="item" data-exam-bsc-id="' + v.examBscId + '" data-exam-gbn-cd="' + v.examGbncd + '"><a href="#0">삭제</a></div>';

				var manageCardQuizBtns =
					'<div class="item" data-exam-bsc-id="' + v.examBscId + '" data-exam-gbn-cd="' + v.examGbncd + '"><a href="#0">퀴즈정보 및 평가</a></div>' +
                    '<div class="item" data-exam-bsc-id="' + v.examBscId + '" data-exam-gbn-cd="' + v.examGbncd + '"><a href="#0">수정</a></div>' +
                    '<div class="item" data-exam-bsc-id="' + v.examBscId + '" data-exam-gbn-cd="' + v.examGbncd + '"><a href="#0">삭제</a></div>';

				var manageCardOtherBtns =
					'<div class="item" data-exam-bsc-id="' + v.examBscId + '" data-exam-gbn-cd="' + v.examGbncd + '"><a href="#0">응시현황</a></div>' +
					'<div class="item" data-exam-bsc-id="' + v.examBscId + '" data-exam-gbn-cd="' + v.examGbncd + '"><a href="#0">시험지 보기</a></div>' +
					'<div class="item" data-exam-bsc-id="' + v.examBscId + '" data-exam-gbn-cd="' + v.examGbncd + '"><a href="#0">결시현황</a></div>'+
                    '<div class="item" data-exam-bsc-id="' + v.examBscId + '" data-exam-gbn-cd="' + v.examGbncd + '"><a href="#0">수정</a></div>' +
                    '<div class="item" data-exam-bsc-id="' + v.examBscId + '" data-exam-gbn-cd="' + v.examGbncd + '"><a href="#0">삭제</a></div>';

				var manageCardBtns;
                // 1. 시험(팀)일 경우
                // 2. 중간, 기말 시험(팀)일 경우
                if (v.examGbncd === 'EXAM' || v.examGbncd === 'EXAM_TEAM') {
                    // 1-1. 실시간 온라인
                    // 1-2. 퀴즈
                    if (v.tkexamMthdCd === 'RLTM') {
                        manageCardBtns = manageCardOtherBtns;
                    } else if (v.tkexamMthdCd === 'QUIZ') {
                        manageCardBtns = manageCardQuizBtns;
                    }
                } else {
                    if (v.tkexamMthdCd === 'RLTM') {
                        manageCardBtns = manageCardExamBtns;
                    } else if (v.tkexamMthdCd === 'QUIZ') {
                        manageCardBtns = manageCardQuizBtns;
                    }
                }

				// 숫자만 추출 (ex. "30%" → "30")
				var ratioNum = String(v.mrkRfltrt).replace('%', '').trim();
				var isFixed = (v.examGbncd === 'EXAM_MID' || v.examGbncd === 'EXAM_LST');
				var ratioColor = isFixed ? ' color:#FFC107;' : '';
				var mrkRfltrtHtml = '<input type="text" style="width:50px;' + ratioColor + '" class="ratio-input" inputmask="numeric" maxVal="100"' +
					' data-exam-gbncd="' + v.examGbncd + '"' +
					' value="' + ratioNum + '" min="0" max="100" disabled>' +
					'<span class="ratio-pct"' + (isFixed ? ' style="color:#FFC107;"' : '') + '>%</span>';

				dataList.push({
					no:                     lineNo
					, examGbnnm:            v.examGbnnm
					, examGbncd:            v.examGbncd
					, tkexamMthdNm:         v.tkexamMthdNm
					, examTtl:              v.examTtl
					, examDrtn:             v.examDrtn
					, examMnts:             v.examMnts
					, mrkRfltrt:            mrkRfltrtHtml
					, tkexamCmptnynTot:     v.tkexamCmptnynTot
					, evlynTot:             v.evlynTot
					, examQstnsCmptnyn:     v.examQstnsCmptnyn
					, mrkOyn:               mrkOynHtml
					, manage:               manageBtns
					, manageCard:           manageCardBtns
                    , examBscId:            v.examBscId //hidden 컬럼
                    , tkexamMthdCd:         v.tkexamMthdCd // hidden 컬럼
				});
			});

			return dataList;
		}

		/* 반영비율 input 활성/비활성화 (EXAM_MID, EXAM_LST 제외) */
		function enableRatioInputs(enable) {
			$('#examList .ratio-input').each(function() {
				var examGubuncd = $(this).data('examGbncd');
				if (examGubuncd !== 'EXAM_MID' && examGubuncd !== 'EXAM_LST') {
					$(this).prop('disabled', !enable);
				}
			});
		}

		/* 스위치 초기화 */
		function initExamSwitcher() {
			var switches = $('#examList .switch:visible');
			if (switches.length > 0) {
				$.switcher(switches);
			} else if ($('#examList').length > 0) {
				requestAnimationFrame(initExamSwitcher);
			}
		}

		/* 페이지당 건수 변경 */
		function changeListScale(scale) {
			LIST_SCALE = scale;
			loadExamList(1);
		}
	</script>
</head>

<body class="class colorA "><!-- 컬러선택시 클래스변경 -->
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
                            <li><span class="current">시험</span></li>
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
                    <!-- 강의실 상단 -->
                    <div class="segment class-area">
                        <div class="info-left">
                            <div class="class_info">
                                <h2>데이터베이스의 이해와 활용 1반</h2>
                                <div class="classSection">
                                    <div class="cls_btn">
                                        <a href="#0" class="btn">강의계획서</a>
                                        <a href="#0" class="btn">학습진도관리</a>
                                        <a href="#0" class="btn">평가기준</a>
                                    </div>
                                </div>
                            </div>
                            <div class="info-cnt">
                                <div class="info_iconSet">
                                    <a href="#0" class="info"><span>공지</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>Q&A</span><div class="num_txt point">17</div></a>
                                    <a href="#0" class="info"><span>1:1</span><div class="num_txt point">3</div></a>
                                    <a href="#0" class="info"><span>과제</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>토론</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>세미나</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>퀴즈</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>설문</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>시험</span><div class="num_txt">2</div></a>
                                </div>
                                <div class="info-set">
                                    <div class="info">
                                        <p class="point"><span class="tit">중간고사:</span><span>2025.04.26 16:00</span></p>
                                        <p class="desc"><span class="tit">시간:</span><span>40분</span></p>
                                    </div>
                                    <div class="info">
                                        <p class="point"><span class="tit">기말고사:</span><span>2025.07.26 16:00</span></p>
                                        <p class="desc"><span class="tit">시간:</span><span>40분</span></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="info-right">
                            <div class="flex">
                                <div class="item week">
                                    <div class="item_icon"><i class="icon-svg-calendar-check-02" aria-hidden="true"></i></div>
                                    <div class="item_tit">2025.04.14 ~ 04.20</div>
                                    <div class="item_info"><span class="big">7</span><span class="small">주차</span></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- //강의실 상단 -->

                    <div class="segment">
                        <!-- 상단 영역 -->
                        <div class="board_top">
                            <i class="icon-svg-openbook"></i>
                            <h3 class="board-title">시험목록</h3>
                            <div class="right-area">
                                <!-- 테스트용 버튼 -->
                                <button type="button" id="test1" class="btn basic" data-exam-gbn-cd="QUIZ_TEAM">상세 퀴즈</button>
                                <button type="button" id="test2" class="btn basic" data-exam-gbn-cd="EXAM_LST">상세 시험</button>
                                <!-- 버튼 ID들 지정 해야함 -->
                                <button type="button" id="mrkRfltrt-modify-btn" class="btn basic">성적반영 비율조정</button>
                                <button type="button" id = "exam-add-btn" class="btn type2">시험 등록</button>
                                <button type="button" class="btn basic">시험 맛보기</button>
                                <%-- 리스트/카드 전환 버튼 (UiTable 자동 렌더링) --%>
                                <span class="list-card-button"></span>
                                <%-- 목록 스케일 선택 --%>
                                <uiex:listScale func="changeListScale" value="10" />
                            </div>
                        </div>

                        <%-- 시험 목록 (list) --%>
                        <div id="examList"></div>

                        <%-- 시험 목록 카드 폼 --%>
                        <div id="examList_cardForm" style="display:none">
                            <div class="card-header">
                                #[examGbnnm]
                                <div class="card-title">
                                    #[examTtl]
                                </div>
                                <div class = "btn_right">
                                    <div class = "dropdown">
                                        <button type="button" class="btn basic icon set settingBtn" aria-label="퀴즈 관리" onclick="this.nextElementSibling.classList.toggle('show')">
                                            <i class="xi-ellipsis-v"></i>
                                        </button>
                                        <div class="option-wrap">
                                            #[manageCard]
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="desc">
                                    <p><label class="label-title">방식</label><strong>#[tkexamMthdNm]</strong></p>
                                    <p><label class="label-title">시험일시</label><strong>#[examDrtn]</strong></p>
                                    <p><label class="label-title">시험시간</label><strong>#[examMnts]분</strong></p>
                                    <p><label class="label-title">반영비율</label><span>#[mrkRfltrt]</span></p>
                                </div>
                                <div class="etc">
                                    <p><label class="label-title">응시현황</label><strong>#[tkexamCmptnynTot]</strong></p>
                                    <p><label class="label-title">평가현황</label><strong>#[evlynTot]</strong></p>
                                    <p><label class="label-title">출제상태</label><strong>#[examQstnsCmptnyn]</strong></p>
                                    <p><label class="label-title">성적공개</label><strong>#[mrkOyn]</strong></p>
                                </div>
                            </div>
                        </div>

                        <script type="text/javascript">
                        var examListTable = UiTable("examList", {
                            lang: "ko",
                            pageFunc: loadExamList,
                            columns: [
                                {title:"No", field:"no", headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:50},
                                {title:"구분", field:"examGbnnm", headerHozAlign:"center", hozAlign:"center", width:90,  minWidth:90},
                                {title:"방식", field:"tkexamMthdNm", headerHozAlign:"center", hozAlign:"center", width:120,  minWidth:120},
                                {title:"시험", field:"examTtl", headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:200},
                                {title:"시험일시(기간)", field:"examDrtn", headerHozAlign:"center", hozAlign:"center", width:200, minWidth:180},
                                {title:"시험시간", field:"examMnts", headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:80},
                                {title:"반영비율", field:"mrkRfltrt", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:90,  formatter:"html"},
                                {title:"응시현황", field:"tkexamCmptnynTot", headerHozAlign:"center", hozAlign:"center", width:90,  minWidth:90},
                                {title:"평가현황", field:"evlynTot", headerHozAlign:"center", hozAlign:"center", width:90,  minWidth:90},
                                {title:"출제상태", field:"examQstnsCmptnyn", headerHozAlign:"center", hozAlign:"center", width:90,  minWidth:90},
                                {title:"성적공개", field:"mrkOyn", headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:80,  formatter:"html"},
                                {title:"관리", field:"manage", headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:600, formatter:"html"}
                            ]
                        });

                        // 카드/리스트 모드 전환 시 반영비율 편집 상태 유지
                        examListTable.on("renderComplete", function() {
                            if (isRatioEditMode) {
                                requestAnimationFrame(function() { enableRatioInputs(true); });
                            }
                        });
                        </script>
                    </div>
                </div>

            </div>
            <!-- //content -->

        </main>
        <!-- //classroom-->

    </div>

</body>
</html>
