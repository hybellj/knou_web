<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
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

		$(document).ready(function() {
            /* 초기 시험 목록 가져오기 */
			loadExamList();

            /* 검색 영역 엔터키 입력 */
            $("#examTtl").on("keyup", function(e) {
                if(e.keyCode === 13) {
                    loadExamList(1);
                }
            });
		});

        /**
         * 시험 화면 이동
         * - 인자 1개 (tab)          : exam 컨텍스트 없이 이동 (예: 시험 등록) → isModify=N
         * - 인자 4개 (examBscId, tkexamMthdCd, byteamSubrexamUseyn, tab) : 특정 시험 컨텍스트로 이동 → isModify=Y
         */
        function examViewMv(examBscId, tkexamMthdCd, byteamSubrexamUseyn, tab) {
            var urlMap = {
                "1" : "/exam/profExamInfoEvlView.do",   // 시험 상세 [시험 정보 및 평가 탭]
                "2" : "/exam/profExamSbstView.do",      // 시험 상세 [시험 대체 탭]
                "3" : "/exam/profExamAbsnceView.do",    // 시험 상세 [결시 내용 및 현황 탭]
                "4" : "/exam/profExamDsblView.do",      // 시험 상세 [장애인/고령자 지원 현황 탭]
                "5" : "/exam/profExamQuizMngView.do",   // 시험 상세 [퀴즈 관리 탭]
                "9" : "/exam/profExamWriteView.do"      // 시험 등록/수정 화면
            };

            var kvArr = [];

            if (arguments.length === 1) {
                // tab 번호만 전달된 경우 (시험 등록)
                tab = examBscId;
                kvArr.push({'key' : 'isModify', 'val' : 'N'});
            } else {
                // 시험 컨텍스트와 함께 전달된 경우 (시험 수정)
                kvArr.push({'key' : 'examBscId',          'val' : examBscId});
                kvArr.push({'key' : 'tkexamMthdCd',       'val' : tkexamMthdCd});
                kvArr.push({'key' : 'byteamSubrexamUseyn','val' : byteamSubrexamUseyn});
                kvArr.push({'key' : 'isModify',           'val' : 'Y'});
            }

            submitForm(urlMap[tab], "", "", kvArr);
        }

		/**
		 * 시험 목록 조회
		 * @param {Integer}   pageIndex - 현재 페이지
		 * @param {String}    listScale - 페이징 목록 수
         * @param {String}    examTtl   - 시험 명
         * @return {list}
         *
		 */
		function loadExamList(page) {
			var url = "/exam/profExamPaging.do";
			var data = {
				"pageIndex"     : page,
				"listScale"     : $('[id^="listScale"]').eq(0).val(),
                "examTtl"       : $("#examTtl").val()
			};

			UiComm.showLoading(true);
			$.ajax({
                url         : url,
                async       : false,
                type        : "GET",
                dataType    : "json",
                data        : data,
            }).done(function(data) {
                UiComm.showLoading(false);
                if (data.result > 0) {
                    var returnList = data.returnList || [];
                    var dataList = createExamListHtml(returnList);

                    examListTable.clearData();
                    examListTable.replaceData(dataList);
                    examListTable.setPageInfo(data.pageInfo);
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

        /*
         * 시험 Tabulator 데이터로 Html 요소 생성
         */
        function createExamListHtml(examList) {
            let dataList = [];
            if (examList.length == 0) {
                return dataList;
            } else {
                examList.forEach(function(v, i) {
                    // 시험 제목 (EXAM_TTL)
                    var examTtl = "<a href='javascript:examViewMv(\"" + v.examBscId + "\",\"" + v.tkexamMthdCd + "\",\"" + v.byteamSubrexamUseyn + "\", 1)' class='header header-icon link'>"
                        + escapeHtml(v.examTtl) + "</a>";
                    // 시험 일시 (기간)
                    var examDrtn = dateFormat("date", v.examPsblSdttm) + " ~ " + dateFormat("date", v.examPsblEdttm);
                    // 시험 시간
                    var examMnts = v.examMnts + "<spring:message code='exam.label.stare.min' />";
                    // 성적 반영비율
                    var mrkRfltrt  = "<span class='mrkInputDiv ui input' style='display:none'>";
                        mrkRfltrt += "	<input type='text' class='mrkRfltrt w80' data-examGbncd=\"" + v.examGbncd + "\" data-examBscId=\"" + v.examBscId
                                        + "\" data-mrkRfltyn =\"" + v.mrkRfltyn + "\" value=\"" + v.mrkRfltrt + "\" "
                                        + "inputmask='numeric' inputmode='decimal' maxVal='100' />";
                        mrkRfltrt += "</span>";
                        mrkRfltrt += "<span class='mrkRfltrtDiv'>" + v.mrkRfltrt + "%</span>";
                    if((v.examGbncd.indexOf("LST") != -1) || (v.examGbncd.indexOf("MID") != -1)) {
                        mrkRfltrt = "<a class = 'fcOrange'>" + v.mrkRfltrt + "%" + "</a>";
                    } else if(v.mrkRfltyn == 'N') {
                        mrkRfltrt = "0%";
                    }
                    // 응시 현황
                    var tkexamCmptnynTot = "<a class='fcBlue'>" + v.tkexamCmptnynTot + "</a>";
                    // 평가현황
                    var evlynTot = "<a class='fcBlue'>" + v.evlynTot + "</a>";
                    // 출제현황
                    var examQstnsCmptnyn = "";
                    if(v.examQstnsCmptnyn == 'Y' ) {
                        examQstnsCmptnyn = "<spring:message code='exam.label.qstn.submit.y' />";/* 출제완료 */
                    } else {
                        examQstnsCmptnyn = "<span class='fcRed'><spring:message code='exam.label.qstn.temp.save' /></span>";/* 임시저장 */
                    }
                    // 성적공개
                    var  mrkOyn = "<input type='checkbox' value=\"" + v.examBscId + "\" class='switch small' " + (v.mrkOyn == "Y" ? "checked" : "") + " data-qstnsCmptn=\"" + v.examQstnsCmptnyn + "\" >";
                    // 관리버튼 (공통 파라미터 축약)
                    var _p = "\"" + v.examBscId + "\",\"" + v.tkexamMthdCd + "\",\"" + v.byteamSubrexamUseyn + "\"";
                    /* context 에 spring message 등록 해야 함 */
                    var manageBtnDefault = "<a href='javascript:examViewMv(" + _p + ", 1)' class='btn basic small'>응시현황</a>"
                                        + "<a href='javascript:examViewMv(" + _p + ", 1)' class='btn basic small'>시험지 보기</a>"
                                        + "<a href='javascript:examViewMv(" + _p + ", 3)' class='btn basic small'>결시현황</a>";
                    var manageCardBtnDefault = "<div class='item'><a href='javascript:examViewMv(" + _p + ", 1)'>응시현황</a></div>"
                                        + "<div class='item'><a href='javascript:examViewMv(" + _p + ", 1)'>시험지 보기</a></div>"
                                        + "<div class='item'><a href='javascript:examViewMv(" + _p + ", 3)'>결시현황</a></div>"
                                        + "<div class='item'><a href='javascript:examViewMv(" + _p + ", 9)'>수정</a></div>"
                                        + "<div class='item'><a href='javascript:examViewMv(" + _p + ", 9)'>삭제</a></div>";
                    var manageBtnQuiz = "<a href='javascript:examViewMv(" + _p + ", 1)' class='btn basic small'>퀴즈정보 및 평가</a>";
                    var manageCardBtnQuiz = "<div class='item'><a href='javascript:examViewMv(" + _p + ", 1)'>퀴즈정보 및 평가</a></div>"
                                        + "<div class='item'><a href='javascript:examViewMv(" + _p + ", 9)'>수정</a></div>"
                                        + "<div class='item'><a href='javascript:examViewMv(" + _p + ", 9)'>삭제</a></div>";
                    var manageBtnExam = "<a href='javascript:examViewMv(" + _p + ", 2)' class='btn basic small'>시험대체</a>"
                                        + "<a href='javascript:examViewMv(" + _p + ", 1)' class='btn basic small'>응시현황</a>"
                                        + "<a href='javascript:examViewMv(" + _p + ", 1)' class='btn basic small'>시험지 보기</a>"
                                        + "<a href='javascript:examViewMv(" + _p + ", 4)' class='btn basic small'>장애인/고령자 지원현황</a>"
                                        + "<a href='javascript:examViewMv(" + _p + ", 3)' class='btn basic small'>결시현황</a>";
                    var manageCardBtnExam = "<div class='item'><a href='javascript:examViewMv(" + _p + ", 2)'>시험대체</a></div>"
                                        + "<div class='item'><a href='javascript:examViewMv(" + _p + ", 1)'>응시현황</a></div>"
                                        + "<div class='item'><a href='javascript:examViewMv(" + _p + ", 1)'>시험지 보기</a></div>"
                                        + "<div class='item'><a href='javascript:examViewMv(" + _p + ", 4)'>장애인/고령자 지원현황</a></div>"
                                        + "<div class='item'><a href='javascript:examViewMv(" + _p + ", 3)'>결시현황</a></div>"
                                        + "<div class='item'><a href='javascript:examViewMv(" + _p + ", 9)'>수정</a></div>"
                                        + "<div class='item'><a href='javascript:examViewMv(" + _p + ", 9)'>삭제</a></div>";

                    var manage = "-";
                    var manageBtn = "";
                    if(v.examGbncd === 'EXAM' || v.examGbncd === 'EXAM_TEAM') {
                        // 1-1. 실시간 온라인
                        // 1-2. 퀴즈
                        if (v.tkexamMthdCd === 'RLTM') {
                            manage = manageBtnDefault;
                            manageBtn = manageCardBtnDefault;
                        } else if (v.tkexamMthdCd === 'QUIZ') {
                            manage = manageBtnQuiz;
                            manageBtn = manageCardBtnQuiz;
                        }
                    } else {
                        if (v.tkexamMthdCd === 'RLTM') {
                            manage = manageBtnExam;
                            manageBtn = manageCardBtnExam;
                        } else if (v.tkexamMthdCd === 'QUIZ') {
                            manage = manageBtnQuiz;
                            manageBtn = manageCardBtnQuiz;
                        }
                    }
                    dataList.push({
                        no:                     v.lineNo
                        , examGbnnm:            v.examGbnnm
                        , examGbncd:            v.examGbncd
                        , tkexamMthdNm:         v.tkexamMthdNm
                        , examTtl:              examTtl
                        , examDrtn:             examDrtn
                        , examMnts:             examMnts
                        , mrkRfltrt:            mrkRfltrt
                        , tkexamCmptnynTot:     tkexamCmptnynTot
                        , evlynTot:             evlynTot
                        , examQstnsCmptnyn:     examQstnsCmptnyn
                        , mrkOyn:               mrkOyn
                        , manage:               manage
                        , manageBtn:            manageBtn
                        , examBscId:            v.examBscId //hidden 컬럼
                        , tkexamMthdCd:         v.tkexamMthdCd // hidden 컬럼
                        , byteamSubrexamUseyn:  v.byteamSubrexamUseyn // hidden 컬럼
                    })

                });
            }
            return dataList;

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

            $(".mrkRfltrt:visible").each(function(i) {
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

            if($(".mrkRfltrt:visible").length == 0) {
                isChk = false;
                loadExamList(1);
            }

            if(isMrkCheck) {
                if(Number(sumMrkRfltrt) != 100) {
                    UiComm.showMessage("["+sumMrkRfltrt+"] <spring:message code='exam.alert.always.exam.score.ratio.100' />", "info");/* 상시 성적 반영 비율이 100%여야 합니다. */
                    return false;
                } else {
                    $.ajax({
                        url: "/exam/editMrkRfltrt.do",
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
                                loadExamList(1);
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
         */
        document.addEventListener('change', (e) => {
            if(e.target.classList.contains('switch')) {
                if(e.target.dataset.qstnscmptn == "N") {
                    if(e.target.checked) {
                        /* 문항 출제 완료 후 성적 공개가 가능합니다. */
                        UiComm.showMessage("<spring:message code='exam.alert.already.qstn.submit' />", "info");
                        e.target.checked = false;
                        return;
                    }
                }
                var mrkOyn = e.target.checked ? "Y" : "N";
                var url = "/exam/editMrkOyn.do";
                var data = {
                    "examBscId" 	: e.target.value,
                    "mrkOyn" 		: mrkOyn
                };

                ajaxCall(url, data, function(data) {
                    if (data.result > 0) {
                        loadExamList(1);
                    } else {
                        UiComm.showMessage(data.message, "error");
                    }
                }, function(xhr, status, error) {
                    /* 성적 공개 변경 중 에러가 발생하였습니다. */
                    UiComm.showMessage("<spring:message code='exam.error.score.open' />", "error");
                }, true);
            }
        });
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

                    <div class="sub-content">
                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit">
                                    <label for="searchValue">
                                        <spring:message code='common.search.keyword'/><!-- 검색어 -->
                                    </label>
                                </span>
                                <div class="itemList">
                                    <!-- 시험 --><!-- 명 --><!-- 입력 -->
                                    <input class="form-control wide" type="text" name="examTtl" id="examTtl" value="${param.examTtl}"
                                           placeholder = "<spring:message code='exam.label.exam' /><spring:message code='exam.label.nm' /> <spring:message code='exam.label.input' />">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="loadExamList(1)">
                                    <spring:message code='button.search'/><!-- 검색 -->
                                </button>
                            </div>
                        </div>
                        <%-- 시험 목록 (list) --%>
                        <div id = "examListArea">
                            <!-- 상단 영역 -->
                            <div class="board_top">
                                <i class="icon-svg-openbook"></i>
                                <h3 class="board-title">시험목록</h3>
                                <div class="right-area">
                                    <!-- 버튼 ID들 지정 해야함 -->
                                    <div class="mrkRfltrtFrmTrsfDiv">
                                        <a href="javascript:mrkRfltrtModify()" class="btn type2">
                                            <spring:message code="exam.label.grade.score" /> <!-- 성적 -->
                                            <spring:message code="exam.label.score.aply.rate" /> <!-- 반영비율 -->
                                            <spring:message code="exam.button.save" /><!-- 저장 -->
                                        </a>
                                        <a href="javascript:mrkRfltrtFrmTrsf(2)" class="btn type2">
                                            <spring:message code="exam.button.cancel" /><!-- 취소 -->
                                        </a>
                                    </div>
                                    <a href="javascript:mrkRfltrtFrmTrsf(1)" id="mrkRfltrtFrmTrsfBtn" class="btn type2">
                                        <spring:message code="exam.label.grade.score" /> <!-- 성적 -->
                                        <spring:message code="exam.label.score.aply.rate" /> <!-- 반영비율 -->
                                        <spring:message code="exam.button.adju" /><!-- 조정 -->
                                    </a>
                                    <button type="button" class="btn type2" onclick = "examViewMv(9)">시험 등록</button>
                                    <button type="button" class="btn basic">시험 맛보기</button>
                                    <%-- 리스트/카드 전환 버튼 (UiTable 자동 렌더링) --%>
                                    <span class="list-card-button"></span>
                                    <%-- 목록 스케일 선택 --%>
                                    <uiex:listScale func="changeListScale" value="10" />
                                </div>
                            </div>
                            <!-- 시험 리스트 -->
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
                                            <button type="button" class="btn basic icon set settingBtn" aria-label="시험 관리" onclick="this.nextElementSibling.classList.toggle('show')">
                                                <i class="xi-ellipsis-v"></i>
                                            </button>
                                            <div class="option-wrap">
                                                #[manageBtn]
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div class="desc">
                                        <p><label class="label-title">방식</label><strong>#[tkexamMthdNm]</strong></p>
                                        <p><label class="label-title">시험일시</label><strong>#[examDrtn]</strong></p>
                                        <p><label class="label-title">시험시간</label><strong>#[examMnts]</strong></p>
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
                        </div>

                        <script type="text/javascript">
                        let examListTable = UiTable("examList", {
                            lang: "ko",
                            pageFunc: loadExamList,
                            columns: [
                                {title:"No",            field:"no",               headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:50},
                                {title:"구분",          field:"examGbnnm",         headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                                {title:"방식",          field:"tkexamMthdNm",      headerHozAlign:"center", hozAlign:"center", width:120, minWidth:120},
                                {title:"시험",          field:"examTtl",           headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:200},
                                {title:"시험일시(기간)", field:"examDrtn",          headerHozAlign:"center", hozAlign:"center", width:280, minWidth:280},
                                {title:"시험시간",       field:"examMnts",          headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:80},
                                {title:"반영비율",       field:"mrkRfltrt",         headerHozAlign:"center", hozAlign:"center", width:80,   minWidth:100},
                                {title:"응시현황",       field:"tkexamCmptnynTot",  headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},
                                {title:"평가현황",       field:"evlynTot",          headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},
                                {title:"출제상태",       field:"examQstnsCmptnyn",  headerHozAlign:"center", hozAlign:"center", width:90,  minWidth:90},
                                {title:"성적공개",       field:"mrkOyn",            headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:80},
                                {title:"관리",          field:"manage",            headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:600}
                            ]
                        });

                        // (renderComplete 제거: 반영비율 편집 로직은 별도 단계에서 quiz 방식으로 교체 예정)
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
