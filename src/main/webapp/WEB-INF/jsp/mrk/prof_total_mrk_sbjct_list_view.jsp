<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="dashboard"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>
<style>
    .inputScore {
        width: 60px !important;
        min-width: auto !important;
        max-width: none !important;
        text-align: center !important;
    }
</style>
<body class="home ${uiex:getTheme()}  ${bodyClass}"  style=""><!-- 컬러선택시 클래스변경 -->
    <script type="text/javascript">
        let EPARAM = "${encParams}";
        let LIST_SCALE = '<c:out value="${vo.listScale}" />';
        let PAGE_INDEX = '<c:out value="${vo.pageIndex}" />';
        // let SEARCH_OBJ;
        // let ratioArr = [];
        let midexamHead, lstexamHead, prgHead, exrcsHead, examHead,asmtHead, dscsHead, quizHead, srvyHead, smnrHead, etcHead = "";
        let autoSaveInterval = null;
        let dialog;

        $(function () {
            changeSbjctList(); // 학기기수 세팅 변경

            /*이벤트 바인딩 시작*/
            bindScoreInitEvents() // 평가점수 가져오기 버튼
            bindScoreModifyEvents() // 점수 수정
            /*이벤트 바인딩 끝*/

        });

        // 평가점수 가져오기(점수입력 초기화)
        function bindScoreInitEvents() {
            $("#btnScoreCalInit").on("click", function () {
                // isMrkProcPeriod().done(function () {
                //     onScoreCalInit();
                // });
                onScoreCalInit();
            });
        }

        // acqsScore 수정 이벤트 (drvtnScr 계산 및 tot/lstScr 재산정)
        function bindScoreModifyEvents() {
            $(document).on("blur", "input[class*=inputScore]", function () {

                let mrkItmTycd = this.dataset.mrkitmtycd; // 해당 성적항목유형코드

                let $row = $(this).closest(".tabulator-row"); // 입력한 row

                // 기존 점수
                let prevAcqsScr = this.dataset.prevscr;
                let prevDrvtnScr = 0;

                // 새로 입력/계산된 점수
                let newAcqsScr = this.value; // 입력점수
                let newDrvtnScr;

                if (mrkItmTycd === "etcScr") { // 기타점수 => 산출 계산 pass
                    prevDrvtnScr = this.dataset.prevScr;
                    newDrvtnScr = newAcqsScr;
                }else {
                    prevDrvtnScr = $row.find("input[name=drvtnScr]").data("prevscr");

                    // 1. 성적반영비율에 따른 점수 산출 (newDrvtnScr)
                    newDrvtnScr = calcScr(newAcqsScr, mrkItmTycd);
                    let $InputDrvtnScr = $row.find("input[name=drvtnScr][data-mrkitmtycd='" + mrkItmTycd + "']"); // 계산용 환산점수 input
                    $InputDrvtnScr.val(newDrvtnScr); // 산출 총점 재계산을 위해 선반영
                }

                // 2. 총점(totScr) 재계산
                let totScr = 0;
                $row.find("input[name*=drvtnScr]").each(function () { //성적항목별 최종점수 합치기
                    let drvtnScr = $(this).val() === "-" ? 0 : parseFloat($(this).val());
                    totScr += drvtnScr;
                });
                totScr = Number(totScr.toFixed(2));

                // 3. 최종점수(lstScr) 재계산
                let adtnScr = Number($row.find("input[name=adtnScr]").val());
                let etcScr = Number($row.find("input[name=etcScr]").val());

                let lstScr = totScr + adtnScr + etcScr;

                if (lstScr > 100) {
                    // 기존 점수로 복구
                    $(this).val(prevAcqsScr);
                    $row.find("input[name=drvtnScr][data-mrkitmtycd='" + mrkItmTycd + "']").val(prevDrvtnScr);

                    $(this).focus();
                    UiComm.showMessage("총점은 100점을 넘길 수 없습니다.", "warning");
                    return false;
                }

                // 최종점수 반영
                $row.find("input[name=drvtnScr][data-mrkitmtycd='" + mrkItmTycd + "']").val(newDrvtnScr); // 성적항목 최종점수 input
                $row.find("span[name=drvtnScrTxt][data-mrkitmtycd='" + mrkItmTycd + "']").text(newDrvtnScr); // 성적항목 최종점수 input

                // 산출 총점 반영
                $row.find("input[name=totScr]").val(totScr);
                $row.find("span[name=totScrTxt]").text(totScr);

                // 총점 반영
                $row.find("input[name=lstScr]").val(lstScr);
            });
        }

        // 학기기수 세팅 변경
        function changeSmstrChrt() {
            let $dgrsSmstr = $('#dgrsSmstr');

            $dgrsSmstr.empty();

            $.ajax({
                url  : "/crs/termMgr/admSmstrListByDgrsYrAjax.do",
                data : {
                    dgrsYr 	: $("#dgrsYr").val()
                    <%--	,orgId	: $("#orgId").val() --%>
                },
                type : "GET",
                headers: {"X-Requested-With": "XMLHttpRequest"},
                success: function(data) {
                    if (data.result > 0) {
                        let resultList = data.returnList;

                        $dgrsSmstr.append( `<option value='ALL'><spring:message code="crs.label.open.term" /></option>`);

                        if (resultList.length > 0) {
                            $.each(resultList, function(i, smstrChrtVO) {
                                $dgrsSmstr.append(`<option value="\${smstrChrtVO.smstrChrtId}">\${smstrChrtVO.smstrChrtnm}</option>`);
                            })
                        }

                        $dgrsSmstr.trigger("chosen:updated");
                    }else {
                        UiComm.showMessage(data.message, "error");
                    }
                },
                error: function(xhr, status, error) {
                    UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
                }
            });
        }

        // 학과부서 변경에 따른 개설과목 목록 조회
        function changeSbjctList() {
            let $sbjctId = $('#sbjctId');

            $sbjctId.empty();

            let url = "/crs/creCrsMgr/sbjctListAjax.do";

            let data = {
                sbjctYr		: $("#dgrsYr").val(),
                smstrChrtId	: $("#dgrsSmstr").val() == 'ALL' ? '' : $("#dgrsSmstr").val(),
                orgId		: $("#orgId").val(),
                deptId		: $("#deptId").val()
            };

            $.ajax({
                url	: url,
                data: data,
                type: "GET",
                headers: {"X-Requested-With": "XMLHttpRequest"},
                success	: function(data) {
                    if (data.result > 0) {
                        let resultList = data.returnList;

                        $sbjctId.append(`<option value='ALL'><spring:message code='sch.cal_course' /></option>`);

                        if (resultList.length > 0) {
                            $.each(resultList, function(i, sbjctVO) {
                                $sbjctId.append('<option'+' value="'+sbjctVO.sbjctId+'" >' + sbjctVO.sbjctnm + '</option>');
                            })
                        }

                        $sbjctId.trigger("chosen:updated");
                    }else {
                        UiComm.showMessage(data.message, "error");
                    }
                }
            });
        }

        // 학생 성적 목록 조회
        function listStdMrk(rowData, searchType = '') {
            UiComm.showLoading(true);
            let sbjctId = rowData.sbjctId;

            $.ajax({
                url : "/mrk/profMrkListBySbjctAjax.do",
                data: { sbjctId : sbjctId, searchType: searchType, encParams: EPARAM },
                type: "GET",
                headers: {"X-Requested-With": "XMLHttpRequest"},
                success: function (data) {

                    let sbjctMrkList  = data.returnList || [];
                    let cntSummary  = data.returnVO || {};
                    let mrkRfltrtInfoList = data.returnListSub || [];

                    if (mrkRfltrtInfoList.length <= 0 ) {
                        $("#scoreAllListDiv").css("display", "none");
                        UiComm.showMessage("<spring:message code='score.label.process.msg19' />", "warning");/*해당과목의 평가기준을 먼저 입력해주세요.*/
                        UiComm.showLoading(false);
                        setAutoSave("OFF");
                        return;
                    }

                    $("#sSbjctId").val(sbjctId);
                    // const scrCnvsStscd = ;
                    $("#scrCnvsStscd").val(sbjctMrkList[0].scrCnvsStscd || "MRK_CNVS_BFR");

                    if (mrkTable) {
                        mrkTable.destroy();
                    }

                    // 성적처리 테이블 헤더 동적 변경
                    initStdMrkTable(mrkRfltrtInfoList);

                    // 데이터가 들어가서 화면에 인풋 태그들이 실제로 전부 그려질 때마다 실행
                    mrkTable.on("renderComplete", function() {
                        // 화면에 input들이 완전히 준비된 이 시점에 마스크를 입힘.
                        if (typeof UiInputmask === "function") {
                            UiInputmask();
                        }
                    });

                    // 전체인원 최초1번 세팅
                    if ( !searchType && !$("#searchValue").val() ) {
                        if (!$("#totCnt").hasClass("init")) {
                            $("#totCnt").text(cntSummary.totCnt);
                            $("#totCnt").addClass("init")
                        }
                    }

                    $("#midAbsAplyCnt").text(cntSummary.midAbsAplyCnt);
                    $("#midAbsAprvCnt").text(cntSummary.midAbsAprvCnt);
                    $("#lstAbsAplyCnt").text(cntSummary.lstAbsAplyCnt);
                    $("#lstAbsAprvCnt").text(cntSummary.lstAbsAprvCnt);
                    $("#nonEvlCnt").text(cntSummary.nonEvlCnt);

                    let dataList = createStdMrkListHTML(sbjctMrkList, mrkRfltrtInfoList);
                    mrkTable.on("tableBuilt", function() {
                        mrkTable.replaceData(dataList)
                    });

                    $("#scoreAllListDiv").css("display", "block");
                    UiComm.showLoading(false);

                    if ($("#scrCnvsStscd").val() !== "MRK_CNVS_CMPTN") {
                       setAutoSave("ON");
                    }
                }
            });
        }

        // 평가점수 가져오기
        function onScoreCalInit() {
            UiComm.showLoading(true);
            let scrCnvsStscd = $("#scrCnvsStscd").val();

            if (scrCnvsStscd == "MRK_CNVS_ING" || scrCnvsStscd == "MRK_CNVS_CMPTN") {
                // 기존 저장된 성적이 초기화됩니다. 평가점수를 가져오시겠습니까?
                if (!confirm('<spring:message code="score.confirm.select.msg1" />\r\n<spring:message code="score.confirm.select.msg2" />')) return false;
            }

            let sbjctId = $("#sSbjctId").val();
            let param = {"sbjctId": sbjctId};

            $.ajax({
                url : "/mrk/profStdMrkInitAjax.do",
                data: param,
                type: "POST",
                headers: {"X-Requested-With": "XMLHttpRequest"},
                success: function (data) {
                    if (data.result > 0) {
                        listStdMrk(param);
                    }else {
                        UiComm.showMessage(data.message, "error");
                        setAutoSave("OFF");
                    }
                },
                error: function(xhr, status, error) {
                    UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
                    setAutoSave("OFF");
                }, complete: function () {
                    UiComm.showLoading(false);
                }
            });
        }

        // 성적반영 비율에 따른 환산점수 계산
        function calcScr(inputScr, mrkItmTycd) {

            // 성적반영 비율
            const mrkRfltrtMap = {
                "MIDEXAM"   : midexamHead / 100,
                "LSTEXAM"   : lstexamHead / 100,
                "PRG"       : prgHead / 100,
                "EXRCS_QSTN": exrcsHead / 100,
                "EXAM"      : examHead  / 100,
                "ASMT"      : asmtHead / 100,
                "DSCS"      : dscsHead / 100,
                "QUIZ"      : quizHead / 100,
                "SRVY"      : srvyHead / 100,
                "SMNR"      : smnrHead / 100
            };

            return (inputScr * mrkRfltrtMap[mrkItmTycd]).toFixed(2);
        }

        // @deprecated 총점(totScr) 계산
        function calcAllScr() {

            // 성적반영 비율
            const mrkRfltrtMap = {
                "MIDEXAM"   : midexamHead / 100,
                "LSTEXAM"   : lstexamHead / 100,
                "PRG"       : prgHead / 100,
                "EXRCS_QSTN": exrcsHead / 100,
                "EXAM"      : examHead  / 100,
                "ASMT"      : asmtHead / 100,
                "DSCS"      : dscsHead / 100,
                "QUIZ"      : quizHead / 100,
                "SRVY"      : srvyHead / 100,
                "SMNR"      : smnrHead / 100
            };

            // 각 행 순회하며 환산점수 계산
            mrkTable.getRows().forEach(function (row) {
                const $row = $(row.getElement());

                const $etcScr     = $row.find('input[name="etcScr"]');
                const $totScr     = $row.find(`input[name="totScr"]`);
                const $totScrTxt  = $row.find(`span[name="totScrTxt"]`);
                const $lstScr     = $row.find('input[name="lstScr"]');

                const etcScr  = parseFloat($etcScr.val()) || 0;
                const adtnScr = parseFloat($row.find('input[name="adtnScr"]').val()) || 0;
                let totScr    = 0; // 성적항목 점수 총합

                if (etcScr !== parseFloat($etcScr.data('prevscr'))) $etcScr.data('updateYn', 'Y');

                // 성적항목 순회하며 계산
                Object.keys(mrkRfltrtMap).forEach(function (mrkItmTycd) {

                    const mrkRfltrt = mrkRfltrtMap[mrkItmTycd];

                    if (mrkRfltrt === 0) return;

                    // mrkItmTycd에 맞는 점수 input 요소 가져오기
                    const $acqsInput    = $row.find(`input[name="acqsScr"][data-mrkitmtycd="\${mrkItmTycd}"]`);
                    const $drvtnScr     = $row.find(`input[name="drvtnScr"][data-mrkitmtycd="\${mrkItmTycd}"]`);
                    const $drvtnScrTxt  = $row.find(`span[name="drvtnScrTxt"][data-mrkitmtycd="\${mrkItmTycd}"]`);
                    const prevScr = parseFloat($acqsInput.data('prevscr'));

                    if ($acqsInput.length <= 0) return;

                    let acqsScr = $.trim($acqsInput.val());
                    let drvtnScr = "";
                    // console.log(mrkItmTycd + ": " + acqsScr);

                    // 미평가 또는 빈값 처리
                    if (acqsScr === '-' || acqsScr === '' || acqsScr < 0) {
                        drvtnScr = "";
                    } else {
                        acqsScr = parseFloat(acqsScr);
                        drvtnScr = parseFloat( (acqsScr * mrkRfltrt).toFixed(2) );
                        totScr += drvtnScr; // 총점에 누적
                    }

                    if (acqsScr !== prevScr) $acqsInput.data('updateYn', 'Y');

                    $acqsInput.val(acqsScr);
                    $drvtnScrTxt.text(drvtnScr);
                    $drvtnScr.val(drvtnScr);
                });

                totScr = parseFloat(totScr.toFixed(2));

                // 산출총점(totScr) 업데이트
                $totScr.val(totScr);
                $totScrTxt.text(totScr);

                // 최종점수(lstScr) 업데이트
                $lstScr.val(parseFloat((totScr + adtnScr + etcScr).toFixed(2)));
            });
        }

        // 자동저장
        function setAutoSave(status) {
            clearInterval(autoSaveInterval);

            if (status == "OFF") {
                autoSaveInterval = null;
            } else if(status == "ON") {
                autoSaveInterval = setInterval(function () {
                    onSave("Y");
                }, 10 * 60 * 1000);
            }
        }
    </script>

    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp"/>
        <!-- //common header -->

        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- 본문 content 부분 -->
            <div id="content" class="content-wrap common">
                <div class="dashboard_sub">

                    <div class="sub-content">
                        <div class="page-info">
                            <%--타이틀--%>
                            <h2 class="page-title">성적관리</h2><!-- 종합성적 -->
                            <uiex:navibar type="main"/> <%-- 네비게이션바 --%>
                        </div>

                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label>학사년도/학기</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="dgrsYr" onchange="changeSmstrChrt()">
                                        <option value=""><spring:message code="std.label.year"/></option><!-- 년도 -->
                                        <c:forEach var="item" items="${filterOptions.yearList }">
                                            <option value="${item }" ${item eq filterOptions.curYear ? 'selected' : '' }>${item }</option>
                                        </c:forEach>
                                    </select>
                                    <select class="form-select" id="dgrsSmstr">
                                        <option value=""><spring:message code="crs.label.open.term"/></option><!-- 개설학기 -->
                                        <c:forEach var="list" items="${filterOptions.smstrChrtList }">
                                            <option smstrChrtnm="${list.smstrChrtId }">${list.smstrChrtnm }</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label>운영과목</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="orgId"><!-- 기관 -->
                                        <option value="">기관</option>
                                        <c:forEach var="list" items="${filterOptions.orgList }">
                                            <option value="${list.orgId }" ${list.orgId eq filterOptions.orgId ? 'selected' : '' }>${list.orgnm }</option>
                                        </c:forEach>
                                    </select>
                                    <select class="form-select" id="deptId" onchange="changeSbjctList()">
                                        <option value=""><spring:message code="exam.label.dept" /></option><!-- 학과 -->
                                        <c:forEach var="list" items="${filterOptions.deptList }">
                                            <option value="${list.deptId }">${list.deptnm }</option>
                                        </c:forEach>
                                    </select>
                                    <select class="form-select wide" id="sbjctId">
                                        <option value=""><spring:message code="common.subject" /></option><!-- 과목 -->
                                    </select>
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="listSbjct(1)"><spring:message code="sys.button.search" /></button>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title"><spring:message code="score.label.service.lecture"/></h3><!-- 운영과목 -->
                            <%--<span>[ <spring:message code="exam.label.total"/> <span class="fcBlue" id="ttlSbjctCnt"> 0</span><spring:message code="exam.label.cnt"/> ]</span><!-- 총 건 -->--%>
                        </div>
                        <div class="table-wrap" id="sbjctList"> </div>
                        <script type="text/javascript">
                            // 과목 리스트 테이블
                            let sbjctListTable

                            $(function () {
                                sbjctListTable = UiTable("sbjctList", {
                                    lang: "ko",
                                    selectRow: "1",
                                    selectRowFunc: listStdMrk,
                                    pageFunc: listSbjct,
                                    columns: [
                                        {title: "번호",       field: "no",        headerHozAlign: "center", hozAlign: "center", width: 50, minWidth: 50},
                                        {title: "연도",       field: "sbjctYr",   headerHozAlign: "center", hozAlign: "center", width: 50, minWidth: 50},
                                        {title: "학기",       field: "sbjctSmstr",headerHozAlign: "center", hozAlign: "center", width: 50, minWidth: 50},
                                        {title: "소속",       field: "orgnm",     headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100},
                                        {title: "학과",       field: "deptnm",    headerHozAlign: "center", hozAlign: "center", width: 160, minWidth: 150},
                                        {title: "개설과목코드",field: "sbjctId",    headerHozAlign: "center", hozAlign: "center", width: 160, minWidth: 150},
                                        {title: "과목명",     field: "sbjctnm",    headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 200},
                                        {title: "분반",       field: "dvclasNo",  headerHozAlign: "center", hozAlign: "center", width: 50, minWidth: 50},
                                        {title: "학점",       field: "crdts",     headerHozAlign: "center", hozAlign: "center", width: 40, minWidth: 40},
                                        {title: "공동교수",   field: "coProf",     headerHozAlign: "center", hozAlign: "center", width: 80, minWidth: 80},
                                        {title: "튜터",      field: "tutor",      headerHozAlign: "center", hozAlign: "center", width: 80, minWidth: 80},
                                        {title: "조교",      field: "subProf",    headerHozAlign: "center", hozAlign: "center", width: 80, minWidth: 80}
                                    ]
                                });
                            });

                            //운영과목 리스트 조회
                            function listSbjct(pageIndex) {
                                UiComm.showLoading(true);

                                PAGE_INDEX = pageIndex;

                                let extData = {
                                    pageIndex: pageIndex,
                                    listScale: LIST_SCALE,
                                    sbjctYr		: $("#dgrsYr").val(),
                                    smstrChrtId	: $("#dgrsSmstr").val() == 'ALL' ? '' : $("#dgrsSmstr").val(),
                                    orgId		: $("#orgId").val(),
                                    deptId		: $("#deptId").val()
                                };

                                let param = {
                                    encParams: EPARAM,
                                    addParams: UiComm.makeEncParams(extData)
                                };

                                $.ajax({
                                    url	: "/crs/creCrsMgr/sbjctListAjax.do",
                                    data: param,
                                    type: "GET",
                                    headers: {"X-Requested-With": "XMLHttpRequest"},
                                    success	: function(data) {
                                        if (data.result > 0) {
                                            let returnList = data.returnList || [];

                                            sbjctListTable.clearData();
                                            sbjctListTable.replaceData(createSubjectListHTML(returnList, data.pageInfo));
                                            sbjctListTable.setPageInfo(data.pageInfo);

                                            $("#scoreAllListDiv").css("display", "none");

                                        } else {
                                            UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
                                        }
                                    },
                                    error: function(xhr, status, error) {
                                        UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
                                    },
                                    complete: function (){
                                        UiComm.showLoading(false);
                                    }
                                });
                            }

                        </script>

                        <!-- 성적처리 테이블 -->
                        <div id="scoreAllListDiv" style="display: none;">
                            <div class="msg-box warning mt20">
                                <p class="txt ct"><strong>성적처리기간 : </strong>2026.07.25 09:00 ~ 2026.09.25 23:59</p>
                            </div>

                            <div class="board_top t_line">
                                <h4 class="sub-title">성적처리</h4>
                                <c:choose>
                                    <c:when test="${TUT_YN ne 'Y'}">
                                        <span class="info_inline"><small class="note2">성적처리 중 10분마다 자동 저장됩니다.</small></span>
                                        <div class="right-area">
                                            <button type="button" class="btn sm" id="btnScoreCalInit">
                                                <spring:message code="asmnt.label.eval.score"/><spring:message code="common.button.copy"/><%--평가점수가져오기--%>
                                            </button>
                                            <button type="button" class="btn sm type1" id="btnScoreCal" onclick="openSavePop()">
                                                <spring:message code="button.calculate.score"/><%--성적산출--%>
                                            </button>
                                            <button type="button" class="btn sm type4" id="btnSave" onclick="onSave()">
                                                <spring:message code="sys.button.save"/><%--저장--%>
                                            </button>
                                            <button type="button" class="btn sm type4" id="btnFinalConfirm" onclick="fianlConfirm()" style="display: none">
                                                <spring:message code="score.button.save.final.confirm"/><%--최종확정--%>
                                            </button>
                                            <button type="button" class="btn sm type4" id="btnCancelConfirm" onclick="cancelConfirm()" style="display: none">
                                                <spring:message code="score.button.cancel.final.confirm"/><%--평가취소--%>
                                            </button>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="right-area">
                                            <button type="button" class="btn sm type7" id="btnScoreOverallExcel">
                                                <spring:message code="asmnt.label.excel.download"/><!-- 엑셀다운로드 -->
                                            </button>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div style="height: 0.1px; background-color: lightgrey"></div>

                            <div class="board_top in_table">
                                <!-- search small -->
                                <div class="search-typeC">
                                    <input class="form-control" type="text" id="searchValue" placeholder="<spring:message code="user.message.search.input.userinfo.no.dept.nm" />" value="" placeholder="학과/학번/이름 입력">
                                    <button type="button" class="btn basic icon search" id="searchBtn"><i class="icon-svg-search"></i></button>
                                </div>
                                <button type="button" class="btn basic" id="btnMidAbsnce"><i class="icon-svg-search"></i>중간 결시신청 [ 제출 : <span id="midAbsAplyCnt">0</span><spring:message code="message.count"/>, 승인 : <span id="midAbsAprvCnt">0</span><spring:message code="message.count"/> ]</button>
                                <button type="button" class="btn basic" id="btnLstAbsnce"><i class="icon-svg-search"></i>기말 결시신청 [ 제출 : <span id="lstAbsAplyCnt">0</span><spring:message code="message.count"/>, 승인 : <span id="lstAbsAprvCnt">0</span><spring:message code="message.count"/> ]</button>
                                <button type="button" class="btn basic" id="btnZero"><i class="icon-svg-search"></i>미평가 [ <span id="nonEvlCnt">0</span><spring:message code="forum.label.person"/> ]</button>
                                <div class="right-area">
                                    <span class="total_txt">[ <spring:message code="exam.label.stare.user.cnt" /><%--대상인원--%> <b id="totCnt">50</b><spring:message code="message.count"/> ]</span>
                                </div>
                            </div>

                            <form id="tableForm">
                                <input type="hidden" id="scrCnvsStscd" name="scrCnvsStscd"/>
                                <input type="hidden" id="sSbjctId" name="sSbjctId"  />
                                <div id="stdMrkList"></div>
                                <script>
                                    let mrkTable;

                                    // 학생 성적 목록 테이블 초기화
                                    function initStdMrkTable(rateData) {
                                        // 기본 고정 헤더 (앞부분)
                                        let cols = [
                                            {title: "번호",   field: "no",     headerHozAlign: "center", hozAlign: "center", width: 40, minWidth: 40},
                                            {title: "학과",  field: "deptnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 130},
                                            {title: "대표아이디",field: "userRprsId",headerHozAlign: "center", hozAlign: "center", width: 130, minWidth: 130},
                                            {title: "학번",  field: "stdntNo", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 100},
                                            {title: "이름",  field: "usernm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 80}
                                        ];

                                        // 성적반영비율에 따른 동적 헤더 추가
                                        rateData.forEach(item => {
                                            const mrkItmTycd    = item.mrkItmTycd;  // 성적항목유형코드
                                            const mrkRfltrt     = item.mrkRfltrt;   // 성적반영비율
                                            const mrkItmTynm    = item.mrkItmTynm;  // 성적항목유형명

                                            if      (mrkItmTycd == "MIDEXAM")   midexamHead = mrkRfltrt;
                                            else if (mrkItmTycd == "LSTEXAM")   lstexamHead = mrkRfltrt;
                                            else if (mrkItmTycd == "PRG")       prgHead     = mrkRfltrt;
                                            else if (mrkItmTycd == "EXRCS_QSTN")exrcsHead   = mrkRfltrt;
                                            else if (mrkItmTycd == "EXAM")      examHead    = mrkRfltrt;
                                            else if (mrkItmTycd == "ASMT")      asmtHead    = mrkRfltrt;
                                            else if (mrkItmTycd == "DSCS")      dscsHead    = mrkRfltrt;
                                            else if (mrkItmTycd == "QUIZ")      quizHead    = mrkRfltrt;
                                            else if (mrkItmTycd == "SRVY")      srvyHead    = mrkRfltrt;
                                            else if (mrkItmTycd == "SMNR")      smnrHead    = mrkRfltrt;

                                            if (item.mrkRfltrt <= 0 ) return;

                                            cols.push(
                                                {title: `\${mrkItmTynm}</br>(\${mrkRfltrt}%)`, field: `\${mrkItmTycd}`, headerHozAlign: "center", hozAlign: "center", width: 130, minWidth: 100}
                                            );
                                        });

                                        cols.push(
                                            {title: "산출</br>총점",    field: "totScr",    headerHozAlign: "center", hozAlign: "center", width: 50, minWidth: 50},
                                            {title: "가산</br>점수",    field: "adtnScr",   headerHozAlign: "center", hozAlign: "center", width: 50, minWidth: 50},
                                            {title: "기타</br>점수",    field: "etcScr",     headerHozAlign: "center", hozAlign: "center", width: 70, minWidth: 70},
                                            {title: "최종</br>점수",    field: "lstScr",   headerHozAlign: "center", hozAlign: "center", width: 70, minWidth: 70},
                                            {title: "상세정보",         field: "details",   headerHozAlign: "center", hozAlign: "center", width: 80, minWidth: 80, headerSort: false}
                                        );

                                        return mrkTable = UiTable("stdMrkList", {
                                            lang: "ko",
                                            selectRow: "checkbox",
                                            columns: cols

                                        });
                                    }
                                </script>
                            </form>

                            <%--<div class="row">
                                <div class="col">
                                    <div class="option-content gap4 header2">
                                        <div class="sec_head mra">
                                            <spring:message code="common.label.grade.chart"/>: <spring:message code="dashboard.all"/><!-- 성적 등급 분포도 : 전체 -->
                                            <input type="text" id="testInput" value="">
                                        </div>
                                        <select class="ui dropdown" id="graphSelect">
                                        </select>
                                    </div>
                                    <div id="graphDiv">
                                        <p class="option-content gap4 mb5">
                                            <spring:message code="common.label.score.all" /><spring:message code="common.label.grade.chart" /><!-- 전체 성적 등급 분포도 -->
                                            <small>[<spring:message code="exam.label.stare.user.cnt" /><!-- 대상인원 -->: <span id="graphTotCnt"></span> ]</small>
                                        </p>

                                        <div class="ui stackable grid mt0 mb0 p_w100">
                                            <div class="ten wide column pt0">
                                                <div class="chart-container" style="height: 400px;">
                                                    <canvas id="horiBarChart"></canvas>
                                                </div>
                                            </div>
                                            <div class="six wide column pt0">
                                                <table class="grid-table type2" id="graphTable">
                                                    <thead>
                                                    <tr>
                                                        <th scope="col" class=""> <spring:message code="message.marks" /><!-- 배점 --></th>
                                                        <th scope="col" class=""> <spring:message code="exam.label.avg" /><!-- 평균 --></th>
                                                        <th scope="col" class=""> <spring:message code="exam.label.avg.upper.10" /><!-- 상위10%평균 --></th>
                                                        <th scope="col" class="">  <spring:message code="asmnt.label.max.score" /><!-- 최고점수 --></th>
                                                        <th scope="col" class=""> <spring:message code="asmnt.label.min.score" /><!-- 최저점수 --></th>
                                                        <th scope="col" class=""> <spring:message code="exam.label.total.join.user" /><!-- 총응시자수 --></th>
                                                    </tr>
                                                    </thead>
                                                    <tbody>
                                                    <tr>
                                                        <td data-label="<spring:message code="message.marks" />"> 100</td><!-- 배점 -->
                                                        <td data-label="<spring:message code="exam.label.avg" />" id="gridCol1"></td><!-- 평균 -->
                                                        <td data-label="<spring:message code="exam.label.avg.upper.10" />" id="gridCol2"></td><!-- 상위10%평균 -->
                                                        <td data-label="<spring:message code="asmnt.label.max.score" />" id="gridCol3"></td><!-- 최고점 -->
                                                        <td data-label="<spring:message code="asmnt.label.min.score" />" id="gridCol4"></td><!-- 최저점 -->
                                                        <td data-label="<spring:message code="exam.label.total.join.user" />" id="gridCol5"></td><!-- 총응시자수 -->
                                                    </tr>
                                                    </tbody>
                                                </table>

                                                <div class="chart-container" style="height: 330px;">
                                                    <canvas id="barChart"></canvas>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>--%>
                        </div>

                    </div>
                </div><!-- //ui form -->
            </div><!-- //content -->


            <!-- common footer -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
            <!-- //common footer -->
        </main><!-- //container -->
    </div><!-- //pusher -->

    <script>
        //성적처리기간 여부 체크
        function isMrkProcPeriod() {
            let deferred = $.Deferred();

            let url = "/crs/sbjct/sbjctMrkProcPeriodSelectAjax.do";
            let data = {"sbjctId" : $("#sSbjctId").val()};

            ajaxCall(url, data, function (data) {

                if (data.result > 0) {
                    let returnVO = data.returnVO;

                    if (returnVO ==  null) {
                        UiComm.showMessage('<spring:message code="sys.alert.already.job.sch" />', "warning"); // 등록된 일정이 없습니다.
                        deferred.reject();
                        return;
                    }

                    let isMrkProcPeriod = returnVO.isMrkProcPeriod == "Y" ? true : false;
                    let mrkProcSdttm = returnVO.mrkProcSdttm;
                    let mrkProcEdttm = returnVO.mrkProcEdttm;

                    if (isMrkProcPeriod) {
                        deferred.resolve();
                    } else {
                        let argu = '<spring:message code="score.label.score.proc" />'; // 성적처리
                        let msg = `<spring:message code="score.alert.no.job.sch.period" arguments="\${argu}}" />`; // 성적처리 기간이 아닙니다.

                        UiComm.showMessage(msg, "warning");
                        deferred.reject();
                    }
                } else {
                    UiComm.showMessage(data.message, "error");
                    deferred.reject();
                }
            }, function (xhr, status, error) {
                UiComm.showMessage("<spring:message code='exam.error.info' />", "error"); // 정보 조회 중 에러가 발생하였습니다.
                deferred.reject();
            });

            return deferred.promise();
        }

        // 과목 목록 세팅
        function createSubjectListHTML(list) {
            let dataList = [];

            if (list.length <= 0) return dataList;

            for (let i = 0; i < list.length; i++) {
                dataList.push({
                    no: (i + 1),
                    sbjctYr: list[i].sbjctYr,
                    sbjctSmstr: list[i].sbjctSmstr,
                    orgnm: list[i].orgnm,
                    deptnm: list[i].deptnm || '-',
                    sbjctId: list[i].sbjctId,
                    sbjctnm: list[i].sbjctnm,
                    dvclasNo: list[i].dvclasNo,
                    crdts: (list[i].crdts * 1) || '-',
                    coProf: '-',
                    tutor: '-',
                    subProf: '-'
                });
            }
            return dataList;
        }

        // 성적 목록 세팅
        function createStdMrkListHTML(list, mrkItmList) {
            // let scrCnvsSts = false;
            let dataList = [];
            if (list.length <= 0) return dataList;

            // 성적항목타입코드와 점수필드명 매핑
            const acqsScrMapping = {
                "MIDEXAM"   : "midexamAcqsScr",
                "LSTEXAM"   : "lstexamAcqsScr",
                "PRG"       : "prgAcqsScr",
                "EXRCS_QSTN": "exrcsQstnAcqsScr",
                "EXAM"      : "examAcqsScr",
                "ASMT"      : "asmtAcqsScr",
                "DSCS"      : "dscsAcqsScr",
                "QUIZ"      : "quizAcqsScr",
                "SRVY"      : "srvyAcqsScr",
                "SMNR"      : "smnrAcqsScr"
            };
            const drvtnScrMapping = {
                "MIDEXAM"   : "midexamDrvtnScr",
                "LSTEXAM"   : "lstexamDrvtnScr",
                "PRG"       : "prgDrvtnScr",
                "EXRCS_QSTN": "exrcsQstnDrvtnScr",
                "EXAM"      : "examDrvtnScr",
                "ASMT"      : "asmtDrvtnScr",
                "DSCS"      : "dscsDrvtnScr",
                "QUIZ"      : "quizDrvtnScr",
                "SRVY"      : "srvyDrvtnScr",
                "SMNR"      : "smnrDrvtnScr"
            };

            // 성적 환산 상태코드
            // let scrCnvsStscd = $("#scrCnvsStscd").val();
            const isComplete = scrCnvsStscd === "MRK_CNVS_CMPTN" ? true : false;

            for (let i = 0; i < list.length; i++) {
                let std = list[i];
                let row = {};

                // let scrCnvsStscd = std.scrCnvsStscd || "MRK_CNVS_BFR";
                // if (scrCnvsStscd == "MRK_CNVS_CMPTN") scrCnvsSts = true;
                // $("#scrCnvsStscd").val(scrCnvsStscd);

                if (isComplete) {
                    row = {
                        no          : (i+1),
                        deptnm      : std.deptnm,
                        userId      : std.userId,
                        userRprsId  : std.userRprsId,
                        stdntNo     : std.stdntNo,
                        usernm      : std.usernm,
                        totScr      : std.totScr || 0,
                        adtnScr     : std.adtnScr || 0,
                        etcScr      : td.etcScr || 0,
                        lstScr      : std.lstScr || 0,
                        details     : `<button type="button" class="btn basic small" onclick='goDetailStd("\${std.userId}", "\${std.sbjctId}")'>상세보기</button>`,
                        updateYn    : "N"
                    };
                } else {
                    row = {
                        no          : (i+1),
                        deptnm      : std.deptnm,
                        userId      : std.userId,
                        userRprsId  : std.userRprsId,
                        stdntNo     : std.stdntNo,
                        usernm      : std.usernm,
                        totScr      : `<input type="hidden" name="totScr"   value="\${std.totScr}" inputmask="numeric" mask="999.99" maxVal="100"><span name="totScrTxt">\${std.lstScr || 0}</span>`,
                        adtnScr     : `<input type="hidden" name="adtnScr"  value="\${std.adtnScr}" inputmask="numeric" mask="999.99" maxVal="100"><span>\${std.adtnScr || 0}</span>`,
                        etcScr      : `<input type="text" class="inputScore" name="etcScr" data-mrkitmtycd="etcScr" data-prevscr="\${std.etcScr || 0}" value="\${std.etcScr || 0}" inputmask="numeric" mask="999.99" maxVal="100">`,
                        lstScr      : `<input type="text" class="t_num5 final" name="lstScr" value="\${std.lstScr || 0}" inputmask="numeric" mask="999.99" maxVal="100">`,
                        details     : `<button type="button" class="btn basic small" onclick='goDetailStd("\${std.userId}", "\${std.sbjctId}")'>상세보기</button>`,
                        updateYn    : "N"
                    };
                }

                mrkItmList.forEach(item => {
                    if (item.mrkRfltrt > 0) {
                        const mrkItmTycd = item.mrkItmTycd;
                        const acqsScrKey = acqsScrMapping[mrkItmTycd];
                        const drvtnScrKey = drvtnScrMapping[mrkItmTycd];

                        let html = "";

                        let acqsScr  = std[acqsScrKey]  !== null ? std[acqsScrKey]   : "" ;
                        let drvtnScr = std[drvtnScrKey] !== (null || -1) ? std[drvtnScrKey]  : "";

                        // '미평가'인 경우
                        if (acqsScr == -1) {
                            if (isComplete) {
                                html += "-";
                            } else {
                                html += `<input type="text" class="inputScore" name="acqsScr" data-mrkitmtycd="\${mrkItmTycd}" value="-" style="margin: 0 !important;" readonly>`;
                            }

                        } else {
                            if (isComplete) {
                                html += acqsScr;
                            } else {
                               html += `<input type="text" class="inputScore" name="acqsScr" data-mrkitmtycd="\${mrkItmTycd}" data-prevscr="\${acqsScr}" value="\${acqsScr}" inputmask="numeric" mask="999.99" maxVal="100" style="margin: 0 !important;">`
                            }
                        }

                        html += `
                          <span>&nbsp;>&nbsp;</span>
                          <span name="drvtnScrTxt" class="fcBlue" data-mrkitmtycd="\${mrkItmTycd}">\${drvtnScr}</span>
                          <input type="hidden" name="drvtnScr" data-mrkitmtycd="\${mrkItmTycd}" value="\${drvtnScr}" inputmask="numeric" mask="999.99" maxVal="100">
                        `;

                        row[mrkItmTycd] = html;
                    }
                });

                dataList.push(row);
            }

            return dataList;
        }

        // 최종점수 배열 가져오기
        function getLstScrArr() {
            const lstScrArr = [];

            // 각 행 순회하며 최종점수 가져오기
            mrkTable.getRows().forEach(row => {
                const $row = $(row.getElement());

                lstScrArr.push($row.find('input[name="lstScr"]').val())
            });

            return lstScrArr;
        }

        // 성적처리저장 팝업
        function openSavePop() {
            const params = "sbjctId=" + $("#sSbjctId").val() + "&encParams=" + EPARAM;

            dialog = UiDialog("aplyListDialog", {
                title: "<spring:message code="score.label.absolute.ratio"/>", /*절대평가 비중*/
                width: 900,
                height: 750,
                url: "/mrk/profStdGrdrtListPop.do?" + params,
                autoresize: true
            });
        }

        // 성적 저장
        function onSave(autoSaveYn) {
            UiComm.showLoading(true);

            // 성적반영 비율
            const mrkRfltrtMap = {
                "MIDEXAM"   : midexamHead,
                "LSTEXAM"   : lstexamHead,
                "PRG"       : prgHead,
                "EXRCS_QSTN": exrcsHead,
                "EXAM"      : examHead,
                "ASMT"      : asmtHead,
                "DSCS"      : dscsHead,
                "QUIZ"      : quizHead,
                "SRVY"      : srvyHead,
                "SMNR"      : smnrHead
            };

            /**
             * stdMrkList => key: userId, value: stdMrkInfo
             * stdMrkInfo => key: mrkItmTycd, value: acqsScr
             */
            const stdMrkList = {};
            const rows = mrkTable.getRows();

            outerLoop:
            for(let i = 0; i < rows.length; i++) {
                const row = rows[i];
                const $row = $(row.getElement());

                let updateYn = row.getData().updateYn;
                const userId = row.getData().userId;

                // 학생 성적 객체 => {"ASMT": 80, ..., "etcScr": 5}
                let stdMrkInfo  = {};

                // 성적항목별 점수 세팅
                const mrkItmTycdList = Object.keys(mrkRfltrtMap);
                for(let j = 0; j < mrkItmTycdList.length; j++) {
                    const mrkItmTycd = mrkItmTycdList[j];
                    const mrkRfltrt = mrkRfltrtMap[mrkItmTycd];

                    if (mrkRfltrt === 0) continue;

                    // mrkItmTycd에 맞는 취득점수 input 요소 가져오기
                    const $acqsInput = $row.find(`input[name="acqsScr"][data-mrkitmtycd="\${mrkItmTycd}"]`);

                    if ($acqsInput.length <= 0) continue;

                    let acqsScr = $.trim($acqsInput.val());

                    if (acqsScr === '-' || acqsScr === '' || acqsScr < 0) {
                        // alert("미평가 혹은 점수가 올바르게 입력되지 않은 항목이 존재합니다.");
                        // break outerLoop;
                        acqsScr = 0;
                    }
                    acqsScr = parseFloat(acqsScr);

                    if ( acqsScr !== parseFloat($acqsInput.data('prevscr') || 0) ) updateYn = "Y";

                    stdMrkInfo[mrkItmTycd] = acqsScr;
                }

                // 기타 점수 세팅
                const $etcScr   = $row.find('input[name="etcScr"]');
                const etcScr    = parseFloat($etcScr.val() || 0);

                if (etcScr !== parseFloat($etcScr.data('prevscr') || 0)) updateYn = "Y";

                stdMrkInfo.etcScr = etcScr;

                if (updateYn === "Y") stdMrkList[userId] = stdMrkInfo;
            }

            const param = {
                "sbjctId": $("#sSbjctId").val(),
                "sbjctMrkListStr": JSON.stringify(stdMrkList)
            };

            $.ajax({
                url : "/mrk/profStdMrkModify.do",
                type : "POST",
                data : JSON.stringify(param),
                dataType: "json",
                headers: {"X-Requested-With": "XMLHttpRequest"},
                contentType : "application/json; charset=utf-8",
                success: function (data) {
                    if (data.result > 0) {
                        if (autoSaveYn != 'Y') { // 자동저장 여부
                            UiComm.showMessage('<spring:message code="score.alert.success_save.message" />', "success");
                        }
                        listStdMrk({"sbjctId": $("#sSbjctId").val()})
                    } else{
                        UiComm.showMessage(data.message, "error");
                    }
                },
                error: function(xhr, status, error) {
                    UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
                },
                complete: function () {
                    UiComm.showLoading(false);
                }
            });
        }

        // 성적 처리 저장
        function finalSave() {
            onSave(); <%-- 저장 처리 --%>
            setAutoSave("OFF"); <%-- 자동저장 종료 --%>

            $("#btnScoreCalInit, #btnScoreCal, #btnSave").hide(); //저장 및 성적처리 버튼 노출해제

            $("#btnFinalConfirm").show();  // 최종확정 버튼 노출

            // todo: 성적처리 저장 후 수정 못하게 막아야되나?
        }

        // 점수 환상상태 변경
        function changeScrCnvsSts(scrCnvsStscd) {

            let sbjctId = $("#sSbjctId").val();

            $.ajax({
                url  : "/mrk/profStdScrCnvsStsModify.do",
                data : {
                    scrCnvsStscd : scrCnvsStscd,
                    sbjctId      : sbjctId
                },
                type : "POST",
                headers: {"X-Requested-With": "XMLHttpRequest"},
                success: function(data) {
                    if (data.result > 0) {
                        $("#scrCnvsStscd").val(scrCnvsStscd);

                        listStdMrk({"sbjctId": sbjctId});

                    }else {
                        UiComm.showMessage(data.message || '<spring:message code="fail.common.msg" />', "error");
                    }
                },
                error: function(xhr, status, error) {
                    UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
                }
            });
        }

        // 평가 취소
        function cancelConfirm() {

        }

        // 학생 전체 최종점수 조회
        function getAllLstScr() {
            let lstScrArr = [];

            // 각 행 순회하며 최종점수 가져오기
            mrkTable.getRows().forEach(function (row) {
                const $row = $(row.getElement());
                const lstScr = $row.find('input[name="lstScr"]').val();

                lstScrArr.push(lstScr);
            });

            return lstScrArr;
        }

        /**
         * 팝업 dialog 닫기 (window.parent.closeDialog()로 호출됨)
         */
        function closeDialog() {
            if (dialog) {
                dialog.close();
            }
        }
    </script>

</body>

</html>