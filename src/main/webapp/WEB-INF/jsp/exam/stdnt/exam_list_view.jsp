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
		var EXAM_TTL   = '<c:out value="${vo.examTtl}" />';

        var dsblYn  = '<c:out value="${dsblYn}" />';

        /*****************************************************************************
         * tabulator 관련 기능
         * 1. loadExamList :            시험 목록 조회 (ajax)
         * 2. createExamListHtml :      각 컬럼에 들어갈 데이터 세팅 및 버튼 요소 생성
         *****************************************************************************/
		/* 1 */
		function loadExamList(page) {
            PAGE_INDEX = page || PAGE_INDEX;
            UiComm.showLoading(true);
			$.ajax({
                url      : "/exam/stdntExamPaging.do",
                type     : "GET",
                dataType : "json",
                data     : {
                    pageIndex   : PAGE_INDEX,
                    listScale   : $('[id^="listScale"]').eq(0).val(),
                    encParams   : EPARAM,
                    examTtl     : $("#examTtl").val()
                },
                success: function(data) {
                    if (data.result > 0) {
                        if (data.encParams != null && data.encParams != "") {
                            EPARAM = data.encParams;
                        }
                        var returnList = data.returnList || [];
                        var dataList = createExamListHtml(returnList);

                        examListTable.clearData();
                        examListTable.replaceData(dataList);
                        examListTable.setPageInfo(data.pageInfo);
                        UiInputmask();
                    } else {
                        UiComm.showMessage(data.message, "error");
                    }
                },
                error: function() {
                    UiComm.showMessage("<spring:message code='exam.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
                },
                complete: function() {
                    UiComm.showLoading(false);
                }
            });
        }
        /* 2 */
        function createExamListHtml(examList) {
            let dataList = [];
            if (examList.length == 0) {
                return dataList;
            } else {
                examList.forEach(function(v, i) {
                    // 시험 제목 (EXAM_TTL)
                    var examTtl = "<a href='javascript:stdntExamDtlViewMv(\"" + v.examBscId + "\",\"" + v.tkexamMthdCd + "\",\"" + v.byteamSubrexamUseyn + "\",\"" + v.absnceYn + "\",\"" + dsblYn + "\",\"" + v.tkexamYn + "\", 1)' class='header header-icon link'>"
                        + escapeHtml(v.examTtl) + "</a>";
                    // 시험 일시 (기간)
                    var examDrtn = dateFormat("date", v.examPsblSdttm) + " ~ " + dateFormat("date", v.examPsblEdttm);
                    // 시험 시간
                    var examMnts = v.examMnts + "<spring:message code='exam.label.stare.min' />";   /* 분 */
                    // 성적반영
                    var mrkRfltyn = "";
                    if (v.mrkRfltyn === "Y") {
                        mrkRfltyn = "<spring:message code='exam.common.yes' />";    /* 예 */
                    } else {
                        mrkRfltyn = "<spring:message code='exam.common.no' />";     /* 아니오 */
                    }
                    // 진행상태
                    var examProgress
                    if (v.nowDttm < v.examPsblSdttm) {
                        examProgress = "<spring:message code='exam.label.prgr.bfr' />"; /* 진행 전 */
                    } else if ((v.examPsblSdttm <= v.nowDttm) && (v.nowDttm <= v.examPsblEdttm)) {
                        examProgress = "<spring:message code='exam.label.prgr.in' />";  /* 진행 중 */
                    } else {
                        examProgress = "<spring:message code='exam.label.end' />";      /* 마감 */
                    }
                    // 응시여부
                    var tkexamYn = "";
                    if (v.nowDttm < v.examPsblSdttm) {
                        tkexamYn = "-";
                    } else if (v.tkexamYn === "N") {
                        tkexamYn = "<a class='fcRed'>" + "<spring:message code='exam.label.no.stare' />" + "</a>";  /* 미응시 */
                    } else if (v.tkexamYn === "Y") {
                        tkexamYn = "<spring:message code='exam.label.yes.stare' />";    /* 응시 */
                    }
                    // 평가점수
                    var totScr = "";
                    if (v.examPsblEdttm < v.nowDttm) {
                        if (v.mrkRfltyn === "Y" && v.totScr != null) {
                            totScr = v.totScr + " <spring:message code='exam.label.score.point' />";  /* 점 */
                        } else if (v.mrkRfltyn === "Y") {
                            totScr = "0 <spring:message code='exam.label.score.point' />";  /* 점 */
                        } else {
                            totScr = "- <spring:message code='exam.label.score.point' />";  /* 점 */
                        }
                    } else {
                        totScr = "- <spring:message code='exam.label.score.point' />";  /* 점 */
                    }
                    // 피드백
                    var fdbkCnt = "";
                        if (v.fdbkCnt > 0) {
                            fdbkCnt += "<a href='javascript:fdbkPopup(\"" + v.examBscId + "\")' class='header header-icon link'>" + v.fdbkCnt + "</a>";
                        } else {
                            fdbkCnt = v.fdbkCnt
                        }

                    // 관리버튼 (공통 파라미터 축약)
                    var _p  = "\"" + v.examBscId + "\",\"" + v.tkexamMthdCd + "\",\"" + v.byteamSubrexamUseyn + "\",\"" + v.absnceYn + "\",\"" + dsblYn + "\",\"" + v.tkexamYn + "\"";

                    var manageBtn = "<div style='display:flex;align-items:center;gap:0 3px'>";
                                    // (진행전) 현재날짜 < 시험 시작일
                                    if (v.nowDttm < v.examPsblSdttm) {
                                        manageBtn += "<a href='javascript:stdntExamDtlViewMv(" + _p + ", 3)' class='btn basic small'><spring:message code='exam.label.absnce.aply' /></a>"; /* 결시신청 */
                                    }
                                    // (진행중) 시험 시작일 <= 현재날짜 <= 시험 종료일 and 시험 미응시
                                    if (((v.examPsblSdttm <= v.nowDttm) && (v.nowDttm <= v.examPsblEdttm)) && (v.tkexamYn === "N")) {
                                        // Todo: 온라인 시험시스템 시험지 URL 링크
                                        manageBtn += "<a href='javascript:onlinePprViewMv()' class='btn basic small'><spring:message code='exam.label.exam' /><spring:message code='exam.button.stare.start' /></a>";   /* 시험 */ /* 응시 */
                                    }
                                    // (진행중) 시험 시작일 < 현재날짜 and 결시 승인
                                    if ((v.examPsblSdttm < v.nowDttm) && (v.absnceYn === "Y")) {
                                        manageBtn += "<a href='javascript:stdntExamDtlViewMv(" + _p + ", 2)' class='btn basic small'><spring:message code='exam.label.exam' /><spring:message code='exam.label.sub' /></a>";  /* 시험 */ /* 대체 */
                                    }
                                    // (마감) 시험 종료일 < 현재날짜 and 시험 응시
                                    if ((v.examPsblEdttm < v.nowDttm) && (v.tkexamYn === "Y")) {
                                        manageBtn += "<a href='javascript:stdntExamDtlViewMv(" + _p + ", 1)' class='btn basic small'><spring:message code='exam.button.stare.start' /><spring:message code='exam.label.info' /></a>";  /* 응시 */ /* 정보 */
                                    }
                                    // (마감) 시험 종료일 < 현재날짜 and 시험 응시 and 시험지 공개
                                    if (((v.examPsblEdttm < v.nowDttm) && (v.tkexamYn === "Y")) && (v.exampprOyn === "Y")) {
                                        if (v.tkexamMthdCd === "RLTM") {
                                            // 실시간 온라인
                                            // Todo: 온라인 시험시스템 시험지 URL 링크
                                            manageBtn += "<a href='javascript:onlinePprViewMv()' class='btn basic small'><spring:message code='exam.button.view.paper' />(<spring:message code='exam.label.onln' />)</a>"; /* 시험지 보기 */ /* 온라인 */
                                        } else {
                                            // 퀴즈
                                            // Todo: LMS 퀴즈 시험지 URL 링크
                                            manageBtn += "<a href='javascript:quizPprViewMv()' class='btn basic small'><spring:message code='exam.button.view.paper' />(<spring:message code='exam.label.quiz' />)</a>";    /* 시험지 보기 */ /* 퀴즈 */
                                        }
                                    }
                                    manageBtn += "&nbsp;</div>";

                    var manageCardBtn = "";
                                        // (진행전) 현재날짜 < 시험 시작일
                                        if (v.nowDttm < v.examPsblSdttm) {
                                            manageCardBtn += "<div class='item'><a href='javascript:stdntExamDtlViewMv(" + _p + ", 3)'><spring:message code='exam.label.absnce.aply' /></a></div>"; /* 결시신청 */
                                        }
                                        // (진행중) 시험 시작일 <= 현재날짜 <= 시험 종료일 and 시험 미응시
                                        if (((v.examPsblSdttm <= v.nowDttm) && (v.nowDttm <= v.examPsblEdttm)) && (v.tkexamYn === "N")) {
                                            // Todo: 온라인 시험시스템 시험지 URL 링크
                                            manageCardBtn += "<div class='item'><a href='javascript:onlinePprViewMv()'><spring:message code='exam.label.exam' /><spring:message code='exam.button.stare.start' /></a></div>";   /* 시험 */ /* 응시 */
                                        }
                                        // (진행중) 시험 시작일 < 현재날짜 and 결시 승인
                                        if ((v.examPsblSdttm < v.nowDttm) && (v.absnceYn === "Y")) {
                                            manageCardBtn += "<div class='item'><a href='javascript:stdntExamDtlViewMv(" + _p + ", 2)'><spring:message code='exam.label.exam' /><spring:message code='exam.label.sub' /></a></div>";    /* 시험 */ /* 대체 */
                                        }
                                        // (마감) 시험 종료일 < 현재날짜 and 시험 응시
                                        if ((v.examPsblEdttm < v.nowDttm) && (v.tkexamYn === "Y")) {
                                            manageCardBtn += "<div class='item'><a href='javascript:stdntExamDtlViewMv(" + _p + ", 1)'><spring:message code='exam.button.stare.start' /><spring:message code='exam.label.info' /></a></div>";   /* 응시 */ /* 정보 */
                                        }
                                        // (마감) 시험 종료일 < 현재날짜 and 시험 응시 and 시험지 공개
                                        if (((v.examPsblEdttm < v.nowDttm) && (v.tkexamYn === "Y")) && (v.exampprOyn === "Y")) {
                                            if (v.tkexamMthdCd === "RLTM") {
                                                // 실시간 온라인
                                                // Todo: 온라인 시험시스템 시험지 URL 링크
                                                manageCardBtn += "<div class='item'><a href='javascript:onlinePprViewMv()'><spring:message code='exam.button.view.paper' />(<spring:message code='exam.label.onln' />)</a></div>";  /* 시험지 보기 */ /* 온라인 */
                                            } else {
                                                // 퀴즈
                                                // Todo: LMS 퀴즈 시험지 URL 링크
                                                manageCardBtn += "<div class='item'><a href='javascript:quizPprViewMv()'><spring:message code='exam.button.view.paper' />(<spring:message code='exam.label.quiz' />)</a></div>";    /* 시험지 보기 */ /* 퀴즈 */
                                            }
                                        }
                    var manageCardBottomBtn = "";
                                        // 1. (진행중) 시험 시작일 <= 현재날짜 <= 시험 종료일 and 시험 미응시
                                        // 2. (마감) 시험 종료일 < 현재날짜 and 시험 응시
                                        if (((v.examPsblSdttm <= v.nowDttm) && (v.nowDttm <= v.examPsblEdttm)) && (v.tkexamYn === "N")) {
                                            manageCardBottomBtn += "<div class='board_top mb0 margin-top-2'>"
                                            manageCardBottomBtn += "    <div class='right-area'>"
                                            manageCardBottomBtn += "        <button type='button' class='btn type1 small' onclick='onlinePprViewMv()'><spring:message code='exam.label.exam' /><spring:message code='exam.button.stare.start' /></button>"  /* 시험 */ /* 응시 */
                                            manageCardBottomBtn += "    </div>"
                                            manageCardBottomBtn += "</div>"
                                        } else if ((v.examPsblEdttm < v.nowDttm) && (v.tkexamYn === "Y")) {
                                            manageCardBottomBtn += "<div class='board_top mb0 margin-top-2'>"
                                            manageCardBottomBtn += "    <div class='right-area'>"
                                            manageCardBottomBtn += "        <button type='button' class='btn type2 small' onclick='stdntExamDtlViewMv(" + _p + ", 1)'><spring:message code='exam.button.stare.start' /><spring:message code='exam.label.info' /></button>" /* 응시 */ /* 정보 */
                                            manageCardBottomBtn += "    </div>"
                                            manageCardBottomBtn += "</div>"
                                        }

                    dataList.push({
                        no:                     v.lineNo
                        , examGbnnm:            v.examGbnnm
                        , tkexamMthdNm:         v.tkexamMthdNm
                        , examTtl:              examTtl
                        , examDrtn:             examDrtn
                        , examMnts:             examMnts
                        , mrkRfltyn:            mrkRfltyn
                        , examProgress:         examProgress
                        , tkexamYn:             tkexamYn
                        , totScr:               totScr
                        , fdbkCnt:              fdbkCnt
                        , manage:               manageBtn
                        , manageBtn:            manageCardBtn
                        , manageCardBottomBtn:  manageCardBottomBtn
                        , examBscId:            v.examBscId //hidden 컬럼
                        , tkexamMthdCd:         v.tkexamMthdCd // hidden 컬럼
                        , byteamSubrexamUseyn:  v.byteamSubrexamUseyn // hidden 컬럼
                    })

                });
            }
            return dataList;
        }

        function stdntExamDtlViewMv(examBscId, tkexamMthdCd, byteamSubrexamUseyn, absnceYn, dsblYn, tkexamYn, tab) {
            var url;
            if (tab == 1) {
                url = (tkexamMthdCd === "RLTM")
                    ? "/exam/stdntExamInfoTkexamView.do"
                    : "/exam/stdntExamInfoQuizView.do";
            } else {
                var urlMap = {
                    "2" : "/exam/stdntExamInfoSbstView.do",
                    "3" : "/exam/stdntExamInfoAbsnceRsltView.do",
                    "4" : "/exam/stdntExamInfoDsblView.do",
                };
                url = urlMap[tab];
            }

            var extData = {
                examBscId           : examBscId,
                tkexamMthdCd        : tkexamMthdCd,
                byteamSubrexamUseyn : byteamSubrexamUseyn,
                absnceYn            : absnceYn,
                dsblYn              : dsblYn,
                tkexamYn            : tkexamYn,
                tabType             : tab
            };

            document.location.href = url
                + "?encParams=" + EPARAM
                + "&addParams=" + UiComm.makeEncParams(extData);
        }

        /**
         * 피드백 팝업
         * @param {String} examBscId - 시험기본아이디
         */
        function fdbkPopup(examBscId) {
            dialog = UiDialog("dialog1", {
                title: "<spring:message code='exam.label.fdbk' />", /* 피드백 */
                width: 800,
                height: 500,
                url: "/exam/sbstAsmtFdbkPopup.do?examBscId=" + examBscId + "&encParams=" + EPARAM,
                autoresize: true
            });
        }

        function onlinePprViewMv() {
            UiComm.showMessage("온라인 시험 시스템 연동시 작성 예정입니다.", "error");
        }

        function dsblSprtMv() {
            UiComm.showMessage("장애인/고령자 시험지원 화면 작성 후 기능 작성 예정입니다.", "error");
        }

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
	</script>
</head>

<body class="class ${uiex:getTheme()} "><!-- 컬러선택시 클래스변경 -->
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
                    <!-- 강의실 상단 -->
                    <jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
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
                                    <input class="form-control wide" type="text" name="examTtl" id="examTtl" value="${vo.examTtl}"
                                           placeholder = "<spring:message code='exam.label.exam' /><spring:message code='exam.label.nm' /> <spring:message code='exam.label.input' />">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="loadExamList(1)">
                                    <spring:message code='button.search'/><!-- 검색 -->
                                </button>
                            </div>
                        </div>
                        <!-- 시험 목록 (list) -->
                        <div id = "examListArea">
                            <!-- 상단 영역 -->
                            <div class="board_top">
                                <i class="icon-svg-openbook"></i>
                                <h3 class="board-title">
                                    <spring:message code="exam.label.exam" /> <!-- 시험 -->
                                    <spring:message code="exam.button.list" /><!-- 목록 -->
                                </h3>
                                <div class="right-area">
                                    <!-- Todo: 장애인/고령자 시험지원 화면 링크 -->
                                    <button type="button" class="btn type2" onclick="dsblSprtMv()">
                                        <spring:message code="exam.label.dsbl" />/<!-- 장애인 -->
                                        <spring:message code="exam.label.snrs" /> <!-- 고령자 -->
                                        <spring:message code="exam.label.exam.req" /><!-- 시험지원 -->
                                    </button>
                                    <!-- Todo: 온라인시험 맛보기 레이어 팝업 -->
                                    <button type="button" class="btn basic" onclick="onlinePprViewMv()">
                                        <spring:message code="exam.label.exam.taste" /><!-- 시험 맛보기 -->
                                    </button>
                                    <!-- 리스트/카드 전환 버튼 (UiTable 자동 렌더링) -->
                                    <span class="list-card-button"></span>
                                    <!-- 목록 스케일 선택 -->
                                    <uiex:listScale func="changeListScale" value="10" />
                                </div>
                            </div>
                            <!-- 시험 리스트 -->
                            <div id="examList"></div>
                            <!-- 시험 목록 카드 폼 -->
                            <div id="examList_cardForm" style="display:none">
                                <div class="card-header">
                                    #[examGbnnm]
                                    <div class="card-title">
                                        #[examTtl]
                                    </div>
                                    <div class = "btn_right">
                                        <div class = "dropdown">
                                            <!-- 시험 --> <!-- 관리 -->
                                            <button type="button" class="btn basic icon set settingBtn"
                                                    aria-label="<spring:message code="exam.label.exam" /> <spring:message code="exam.label.manage" />"
                                                    onclick="this.nextElementSibling.classList.toggle('show')">
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
                                        <p><label class="label-title"><spring:message code="exam.label.exam" /> <spring:message code="exam.label.dttm" /></label><strong>#[examDrtn]</strong></p>   <!-- 시험 --> <!-- 일시 -->
                                        <p><label class="label-title"><spring:message code="exam.label.exam" /> <spring:message code="exam.label.time" /></label><strong>#[examMnts]</strong></p>   <!-- 시험 --> <!-- 시간 -->
                                    </div>
                                    <div class="etc">
                                        <p><label class="label-title"><spring:message code="exam.label.score.aply.y" /></label><strong>#[mrkRfltyn]</strong></p><!-- 성적반영 -->
                                        <p><label class="label-title"><spring:message code="exam.label.eval.score" /></label><strong>#[totScr]</strong></p><!-- 평가점수 -->
                                        <p><label class="label-title"><spring:message code="exam.label.fdbk" /></label><strong>#[fdbkCnt]</strong></p><!-- 피드백 -->
                                    </div>
                                    #[manageCardBottomBtn]
                                </div>
                            </div>
                        </div>
                        <script type="text/javascript">
                        let examListTable = UiTable("examList", {
                            lang: "ko",
                            pageFunc: loadExamList,
                            columns: [
                                {title:"No", field:"no", headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:50},
                                {title:"<spring:message code="exam.label.stare.type" />", field:"examGbnnm", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},                  /* 구분 */
                                {title:"<spring:message code="exam.label.type" />", field:"tkexamMthdNm", headerHozAlign:"center", hozAlign:"center", width:120, minWidth:120},                     /* 유형 */
                                {title:"<spring:message code="exam.label.exam.nm" />", field:"examTtl", headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:260},                       /* 시험명*/
                                {title:"<spring:message code="exam.label.exam" /><spring:message code="exam.label.dttm" />(<spring:message code="exam.label.period" />)", field:"examDrtn", headerHozAlign:"center", hozAlign:"center", width:260, minWidth:260},   /* 시험 */ /* 일시 */ /* 기간 */
                                {title:"<spring:message code="exam.label.exam" /> <spring:message code="exam.label.time" />", field:"examMnts", headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:80},    /* 시험 */ /* 시간 */
                                {title:"<spring:message code="exam.label.score.aply.y" />", field:"mrkRfltyn", headerHozAlign:"center", hozAlign:"center", width:80,   minWidth:80},                /* 성적반영 */
                                {title:"<spring:message code="exam.label.progress.status" />", field:"examProgress", headerHozAlign:"center", hozAlign:"center", width:80,   minWidth:80},          /* 진행상태 */
                                {title:"<spring:message code="exam.label.answer.yn" />", field:"tkexamYn", headerHozAlign:"center", hozAlign:"center", width:80,   minWidth:80},                    /* 응시여부 */
                                {title:"<spring:message code="exam.label.eval.score" />", field:"totScr", headerHozAlign:"center", hozAlign:"center", width:80,   minWidth:80},                     /* 평가점수 */
                                {title:"<spring:message code="exam.label.fdbk" />", field:"fdbkCnt", headerHozAlign:"center", hozAlign:"center", width:60,   minWidth:60},                          /* 피드백 */
                                {title:"<spring:message code='exam.label.manage' />", field:"manage", headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:200}                          /* 관리 */
                            ]
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
