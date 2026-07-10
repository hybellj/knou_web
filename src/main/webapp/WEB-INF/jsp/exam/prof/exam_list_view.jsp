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
                url      : "/exam/profExamPaging.do",
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

                        mrkRfltrtFrmTrsf(2);	// 성적 반영비율 폼 변환
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
                    if((v.examGbncd.indexOf("LST") != -1) || (v.examGbncd.indexOf("MID") != -1) || (v.examGbncd.indexOf("CMP") != -1)) {
                        mrkRfltrt = "<a class = 'fcOrange'>" + v.mrkRfltrt + "%" + "</a>";
                    } else if(v.mrkRfltyn == 'N') {
                        mrkRfltrt = "<a class = 'fcRed'>" + "0%" + "</a>";
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
                    var _p  = "\"" + v.examBscId + "\",\"" + v.tkexamMthdCd + "\",\"" + v.byteamSubrexamUseyn + "\"";
                    var _dp = "\"" + v.examBscId + "\",\"" + v.byteamSubrexamUseyn + "\"";
                    var _tk = "\"" + v.sbjctId + "\"";

                    var manageBtnDefault = "<div style='display:flex;align-items:center;gap:0 3px'>"
                                        + "<a href='javascript:tkexamStatPop(" + _tk + ")' class='btn basic small'><spring:message code='exam.label.stare.status' /></a>"       /* 응시현황 */
                                        + "<a href='javascript:examViewMv(" + _p + ", 1)' class='btn basic small'><spring:message code='exam.button.view.paper' /></a>"         /* 시험지 보기 */
                                        + "<a href='javascript:examViewMv(" + _p + ", 3)' class='btn basic small'><spring:message code='exam.button.miss.status' /></a>"        /* 결시현황 */
                                        + "&nbsp;</div>";
                    var manageCardBtnDefault = "<div class='item'><a href='javascript:tkexamStatPop(" + _tk + ")'><spring:message code='exam.label.stare.status' /></a></div>"  /* 응시현황 */
                                        + "<div class='item'><a href='javascript:examViewMv(" + _p + ", 1)'><spring:message code='exam.button.view.paper' /></a></div>"         /* 시험지 보기 */
                                        + "<div class='item'><a href='javascript:examViewMv(" + _p + ", 3)'><spring:message code='exam.button.miss.status' /></a></div>"        /* 결시현황 */
                                        + "<div class='item'><a href='javascript:examViewMv(" + _p + ", 9)'><spring:message code='exam.button.mod' /></a></div>"                /* 수정 */
                                        + "<div class='item'><a href='javascript:examDelete(" + _dp + ")'><spring:message code='exam.button.del' /></a></div>";                 /* 삭제 */
                    var manageBtnQuiz = "<div style='display:flex;align-items:center;gap:0 3px'>"
                                        + "<a href='javascript:examViewMv(" + _p + ", 1)' class='btn basic small'><spring:message code='exam.label.quiz' /> <spring:message code='exam.label.info.score.manage' /></a>" /* 퀴즈 */ /* 정보 및 평가 */
                                        + "&nbsp;</div>";
                    var manageCardBtnQuiz = "<div class='item'><a href='javascript:examViewMv(" + _p + ", 1)'><spring:message code='exam.label.quiz' /> <spring:message code='exam.label.info.score.manage' /></a></div>"   /* 퀴즈 */ /* 정보 및 평가 */
                                        + "<div class='item'><a href='javascript:examViewMv(" + _p + ", 9)'><spring:message code='exam.button.mod' /></a></div>"                /* 수정 */
                                        + "<div class='item'><a href='javascript:examDelete(" + _dp + ")'><spring:message code='exam.button.del' /></a></div>";                 /* 삭제 */
                    var manageBtnExam = "<div style='display:flex;align-items:center;gap:0 3px'>"
                                        + "<a href='javascript:examViewMv(" + _p + ", 2)' class='btn basic small'><spring:message code='exam.label.exam' /> <spring:message code='exam.label.sub' /></a>"     /* 시험 */ /* 대체 */
                                        + "<a href='javascript:tkexamStatPop(" + _tk + ")' class='btn basic small'><spring:message code='exam.label.stare.status' /></a>"       /* 응시현황 */
                                        + "<a href='javascript:examViewMv(" + _p + ", 1)' class='btn basic small'><spring:message code='exam.button.view.paper' /></a>"         /* 시험지 보기 */
                                        + "<a href='javascript:examViewMv(" + _p + ", 4)' class='btn basic small'><spring:message code='exam.label.dsbl' />/<spring:message code='exam.label.snrs' /> <spring:message code='exam.label.support.stts' /></a>"    /* 장애인 */ /* 고령자 */ /* 지원 현황 */
                                        + "<a href='javascript:examViewMv(" + _p + ", 3)' class='btn basic small'><spring:message code='exam.button.miss.status' /></a>"        /* 결시현황 */
                                        + "&nbsp;</div>";
                    var manageCardBtnExam = "<div class='item'><a href='javascript:examViewMv(" + _p + ", 2)'><spring:message code='exam.label.exam' /> <spring:message code='exam.label.sub' /></a></div>" /* 시험 */ /* 대체 */
                                        + "<div class='item'><a href='javascript:tkexamStatPop(" + _tk + ")'><spring:message code='exam.label.stare.status' /></a></div>"       /* 응시현황 */
                                        + "<div class='item'><a href='javascript:examViewMv(" + _p + ", 1)'><spring:message code='exam.button.view.paper' /></a></div>"         /* 시험지 보기 */
                                        + "<div class='item'><a href='javascript:examViewMv(" + _p + ", 4)'><spring:message code='exam.label.dsbl' />/<spring:message code='exam.label.snrs' /> <spring:message code='exam.label.support.stts' /></a></div>"    /* 장애인 */ /* 고령자 */ /* 지원 현황 */
                                        + "<div class='item'><a href='javascript:examViewMv(" + _p + ", 3)'><spring:message code='exam.button.miss.status' /></a></div>"        /* 결시현황 */
                                        + "<div class='item'><a href='javascript:examViewMv(" + _p + ", 9)'><spring:message code='exam.button.mod' /></a></div>"                /* 수정 */
                                        + "<div class='item'><a href='javascript:examDelete(" + _dp + ")'><spring:message code='exam.button.del' /></a></div>";                 /* 삭제 */

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

        /*****************************************************************************
         * 성적 반영비율 관련 기능
         * 1. mrkRfltrtFrmTrsf :        성적 반영비율 폼 변환
         * 2. mrkRfltrtModify :         성적 반영비율 수정 (ajax)
         *****************************************************************************/
        /* 1 */
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
        /* 2 */
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

            var extData;
            if (arguments.length === 1) {
                tab = examBscId;
                extData = { tabType: tab, isModify: 'N' };
            } else {
                extData = {
                    examBscId           : examBscId,
                    tkexamMthdCd        : tkexamMthdCd,
                    byteamSubrexamUseyn : byteamSubrexamUseyn,
                    tabType             : tab,
                    isModify            : 'Y'
                };
            }

            document.location.href = urlMap[tab]
                + "?encParams=" + EPARAM
                + "&addParams=" + UiComm.makeEncParams(extData);
        }

        /**
         * 시험 삭제
         */
        function examDelete(examBscId, byteamSubrexamUseyn) {
            var url = "/exam/tkexamUserCount.do";
            var data = { examBscId: examBscId, byteamSubrexamUseyn: byteamSubrexamUseyn };
            ajaxCall(url, data, function(data) {
                // 응시자가 있을 경우
                if (data.pageInfo.totalRecordCount > 0) {
                    UiComm.showMessage("<spring:message code='exam.confirm.exist.answer.user.y' />", "confirm") /* 응시한 학습자가 있습니다. 삭제 시 학습정보가 삭제됩니다. 정말 삭제하시겠습니까? */
                    .then(function(result) {
                        if (result) {
                            ajaxCall("/exam/examDelete.do", { examBscId: examBscId, byteamSubrexamUseyn: byteamSubrexamUseyn }, function(data) {
                                if (data.result > 0) {
                                    UiComm.showMessage("<spring:message code='exam.alert.delete' />", "info")   /* 정상 삭제 되었습니다. */
                                        .then(function() {
                                            location.reload();
                                        });
                                } else {
                                    UiComm.showMessage(data.message, "error");
                                }
                            }, function(xhr, status, error) {
                                UiComm.showMessage("<spring:message code='exam.error.delete' />", "error"); /* 삭제 중 에러가 발생하였습니다. */
                            }, true);
                        }
                    });
                } else {
                    UiComm.showMessage("<spring:message code='exam.confirm.exist.answer.user.n' />", "confirm") /* 응시한 학습자가 없습니다. 삭제하시겠습니까? */
                    .then(function(result) {
                        if (result) {
                            ajaxCall("/exam/examDelete.do", { examBscId: examBscId, byteamSubrexamUseyn: byteamSubrexamUseyn }, function(data) {
                                if (data.result > 0) {
                                    UiComm.showMessage("<spring:message code='exam.alert.delete' />", "info")   /* 정상 삭제 되었습니다. */
                                    .then(function() {
                                        location.reload();
                                    });
                                } else {
                                    UiComm.showMessage(data.message, "error");
                                }
                            }, function(xhr, status, error) {
                                UiComm.showMessage("<spring:message code='exam.error.delete' />", "error"); /* 삭제 중 에러가 발생하였습니다. */
                            }, true);
                        }
                    });
                }
            }, function(xhr, status, error) {
                UiComm.showMessage("<spring:message code='exam.error.delete' />", "error"); /* 삭제 중 에러가 발생하였습니다. */
            });
        }

        /**
         * 응시현황 팝업
         * @param {String}  sbjctId 	- 과목아이디
         */
        function tkexamStatPop(sbjctId) {
            var data = "sbjctId="+sbjctId;

            dialog = UiDialog("dialog1", {
                title: "<spring:message code='exam.label.stare.status' />", /* 응시현황 */
                width: 800,
                height: 500,
                url: "/exam/tkexamStatListPopup.do?"+data,
                autoresize: true
            });
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
                                    <button type="button" class="btn type2" onclick = "examViewMv(9)">
                                        <spring:message code="exam.label.exam" /> <!-- 시험 -->
                                        <spring:message code="exam.button.reg" /><!-- 등록 -->
                                    </button>
                                    <button type="button" class="btn basic">
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
                                        <p><label class="label-title"><spring:message code="exam.label.type" /></label><strong>#[tkexamMthdNm]</strong></p>                                         <!-- 유형 -->
                                        <p><label class="label-title"><spring:message code="exam.label.exam" /> <spring:message code="exam.label.dttm" /></label><strong>#[examDrtn]</strong></p>   <!-- 시험 --> <!-- 일시 -->
                                        <p><label class="label-title"><spring:message code="exam.label.exam" /> <spring:message code="exam.label.time" /></label><strong>#[examMnts]</strong></p>   <!-- 시험 --> <!-- 시간 -->
                                        <p><label class="label-title"><spring:message code="exam.label.score.aply.rate" /></label><span>#[mrkRfltrt]</span></p>                                     <!-- 반영비율 -->
                                    </div>
                                    <div class="etc">
                                        <p><label class="label-title"><spring:message code='exam.label.stare.status' /></label><strong>#[tkexamCmptnynTot]</strong></p>                             <!-- 응시현황 -->
                                        <p><label class="label-title"><spring:message code='exam.label.eval.status' /></label><strong>#[evlynTot]</strong></p>                                      <!-- 평가현황 -->
                                        <p><label class="label-title"><spring:message code='exam.label.qstn.submit.status' /></label><strong>#[examQstnsCmptnyn]</strong></p>                       <!-- 출제상태 -->
                                        <p><label class="label-title"><spring:message code='exam.label.score.open.y' /></label><strong>#[mrkOyn]</strong></p>                                       <!-- 성적공개 -->
                                    </div>
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
                                {title:"<spring:message code="exam.label.exam.nm" />", field:"examTtl", headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:200},                       /* 시험명*/
                                {title:"<spring:message code="exam.label.exam" /><spring:message code="exam.label.dttm" />(<spring:message code="exam.label.period" />)", field:"examDrtn", headerHozAlign:"center", hozAlign:"center", width:280, minWidth:280},   /* 시험 */ /* 일시 */ /* 기간 */
                                {title:"<spring:message code="exam.label.exam" /> <spring:message code="exam.label.time" />", field:"examMnts", headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:80},    /* 시험 */ /* 시간 */
                                {title:"<spring:message code="exam.label.score.aply.rate" />", field:"mrkRfltrt", headerHozAlign:"center", hozAlign:"center", width:80,   minWidth:100},            /* 반영비율 */
                                {title:"<spring:message code='exam.label.stare.status' />", field:"tkexamCmptnynTot", headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},           /* 응시현황 */
                                {title:"<spring:message code='exam.label.eval.status' />", field:"evlynTot", headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},                    /* 평가현황 */
                                {title:"<spring:message code='exam.label.qstn.submit.status' />", field:"examQstnsCmptnyn", headerHozAlign:"center", hozAlign:"center", width:90,  minWidth:90},    /* 출제상태 */
                                {title:"<spring:message code='exam.label.score.open.y' />", field:"mrkOyn", headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:80},                    /* 성적공개 */
                                {title:"<spring:message code='exam.label.manage' />", field:"manage", headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:600}                          /* 관리 */
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
