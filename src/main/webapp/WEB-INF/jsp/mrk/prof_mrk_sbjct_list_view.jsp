<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>
<style>
    /*.inputScore, .totScore, .nonEvalScore {*/
    /*    width: 60px !important;*/
    /*    min-width: auto !important;*/
    /*    max-width: none !important;*/
    /*    text-align: center !important;*/
    /*}*/
</style>
<body class="class ${uiex:getTheme()}  ${bodyClass}"  style=""><!-- 컬러선택시 클래스변경 -->
    <script type="text/javascript">
        let SEARCH_OBJ;
        let ratioArr = [];
        let midexamHead, lstexamHead, progHead, exrcsHead, examHead, asmtHead, dscsHead, quizHead, srvyHead, smnrHead, etcHead = "";
        let autoSaveInterval = null;

        $(function () {
            /*이벤트 바인딩 시작*/
            bindScoreInitEvents() // 평가점수 가져오기 버튼
            //bindScoreModifyEvents() // 점수 수정
            /*이벤트 바인딩 끝*/

        });

        // 평가점수 가져오기(점수입력 초기화)
        function bindScoreInitEvents() {
            $("#btnScoreCalInit").on("click", function () {
                isMrkProcPeriod().done(function () {
                    onScoreCalInit();
                });
            });
        }

        // rawScore 수정 이벤트 (drvtnScr 계산 및 totScore 재산정)
        // function bindScoreModifyEvents() {
        //     $(document).on("blur", "input[class*=inputScore]", function () {
        //
        //         let inputScore = this.value;    // 입력점수
        //         let mrkItmTycd = this.dataset.mrkitmtycd;   // 입력한 성적항목유형코드
        //
        //         let $row = $(this).closest(".tabulator-row"); //row 선택
        //
        //         // 기존 점수
        //         let prevRawScr = this.dataset.prevscr;
        //         let prevDrvtnScr = $row.find("input[name=drvtnScr]").data("prevscr");
        //
        //         // 1. 최종점수 계산
        //         let calScore = calcScr(inputScore, mrkItmTycd); // 입력점수에 대한 최종점수
        //         $row.find("input[name=drvtnScr][data-mrkitmtycd='" + mrkItmTycd + "']").val(calScore); // 산출 총점 재계산을 위해 선반영
        //
        //         // 2. 산출 총점 재계산
        //         let lstScr = 0;
        //         $row.find("input[name*=drvtnScr]").each(function () { //성적항목별 최종점수 합치기
        //             let drvtnScr = $(this).val() == "-" ? 0 : parseFloat($(this).val());
        //             lstScr += drvtnScr;
        //         });
        //         lstScr = Number(lstScr.toFixed(2));
        //
        //         // 3. 총점 재계산
        //         let totScr = 0;
        //         let adtnScr = Number($row.find("input[name=adtnScr]").val());
        //         let etcScr = Number($row.find("input[name=etcScr]").val());
        //         totScr = lstScr + adtnScr + etcScr;
        //
        //         if (totScr > 100) {
        //             // 기존 점수로 복구
        //             $(this).val(prevRawScr);
        //             $row.find("input[name=drvtnScr][data-mrkitmtycd='" + mrkItmTycd + "']").val(prevDrvtnScr);
        //
        //             $(this).focus();
        //             UiComm.showMessage("총점은 100점을 넘길 수 없습니다.", "warning");
        //             return false;
        //         }
        //
        //         // 최종점수 반영
        //         $row.find("input[name=drvtnScr][data-mrkitmtycd='" + mrkItmTycd + "']").val(calScore); // 성적항목 최종점수 input
        //         $row.find("span[name=drvtnScrTxt][data-mrkitmtycd='" + mrkItmTycd + "']").text(calScore); // 성적항목 최종점수 input
        //
        //         // 산출 총점 반영
        //         $row.find("input[name=lstScr]").val(lstScr);
        //         $row.find("span[name=lstScrTxt]").text(lstScr);
        //
        //         // 총점 반영
        //         $row.find("input[name=totScr]").val(totScr);
        //     });
        // }

        // 학생 성적 목록 조회
        function listStdMrk(searchType = '') {
            UiComm.showLoading(true);
            let sbjctId = rowData.sbjctId;

            $.ajax({
                url : "/mrk/profMrkListBySbjctAjax.do",
                data: { sbjctId : sbjctId, searchType: searchType, encParams: EPARAM },
                type: "GET",
                success: function (data) {
                    $("#sSbjctId").val(sbjctId);

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

                    if (mrkTable) {
                        mrkTable.destroy();
                    }

                    initStdMrkTable(mrkRfltrtInfoList);

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
                        //     .then(function () {
                        //     // 데이터가 화면에 그려진 후 실행
                        //     mrkTable.getRows().forEach(row => {
                        //         const data = row.getData();
                        //         const rowEl = row.getElement();
                        //         $(rowEl).attr("data-user-id", data.userId);
                        //         $(rowEl).attr("data-chgyn", "N");
                        //     })
                        // })
                    });

                    $("#scoreAllListDiv").css("display", "block");
                    UiComm.showLoading(false);
                    setAutoSave("ON");
                }
            });

        }

        // 평가점수 가져오기
        function onScoreCalInit() {
            UiComm.showLoading(true);
            let scoreStatus = $("#scoreStatus").val();

            if (scoreStatus == "MRK_CNVS_ING" || scoreStatus == "MRK_CNVS_CMPTN") {
                // 기존 저장된 성적이 초기화됩니다. 평가점수를 가져오시겠습니까?
                if (!confirm('<spring:message code="score.confirm.select.msg1" />\r\n<spring:message code="score.confirm.select.msg2" />')) return false;
            }

            let sbjctId = $("#sSbjctId").val();
            let param = {"sbjctId": sbjctId};

            $.ajax({
                url : "/mrk/profStdMrkInitAjax.do",
                data: param,
                type: "POST",
                success: function (data) {
                    if (data.result > 0) {
                        listStdMrk({"sbjctId": param});
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

        // 총점(totScr) 계산
        function calcScr() {

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
                }, 0.5 * 60 * 1000);
            }
        }
    </script>

    <div id="wrap" class="main">

        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- 본문 content 부분 -->
            <div id="content" class="content-wrap common">
				<!-- class_sub_top -->
				<jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
				<!-- //class_sub_top -->

                <div class="class_sub">
					<!-- class_info -->
					<jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
					<!-- //class_info -->

                    <div class="dashboard_sub">

                        <div class="sub-content">
                            <div class="listTab">
                                <ul>
                                    <li class="select"><a href="#">성적관리</a></li>
                                    <li><a href="/mrk/lec/profMrkObjctAplyView.do?encParams=${encParams}">성적이의신청</a></li>
                                </ul>
                            </div>

                            <div class="page-info">
                                <%--타이틀--%>
                                    <h4 class="sub-title">성적관리</h4><!-- 종합성적 -->
                                <%--<uiex:navibar type="main"/>--%> <%-- 네비게이션바 --%>
                                    <div class="navi_bar">
                                    <ul>
                                        <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                        <li><span class="current">성적관리</span></li>
                                    </ul>
                                </div>
                            </div>

                            <!-- 성적처리 테이블 -->
                            <div id="scoreAllListDiv">
                                <div class="ui small info message">
                                    <p><i class="info circle icon"></i></p>
                                </div>

                                <div class="board_top">


                                    <div class="right-area">
                                        <c:if test="${TUT_YN ne 'Y' }">
                                            <small>성적처리 중 10분마다 자동저장됩니다.</small>
                                            <button type="button" class="btn sm" id="btnScoreCalInit">
                                                <spring:message code="asmnt.label.eval.score"/><spring:message code="common.button.copy"/><!-- 평가점수가져오기 -->
                                            </button>
                                            <button type="button" class="btn sm type1" name="chgButton2" id="btnScoreCal">
                                                <spring:message code="button.calculate.score"/><!-- 성적산출 -->
                                            </button>
                                            <button type="button" class="btn sm type4" name="chgButton2" id="btnSave" onclick="onSave()">
                                                <spring:message code="sys.button.save"/><!-- 저장 -->
                                            </button>
                                        </c:if>
                                        <button type="button" class="btn sm type7" id="btnScoreOverallExcel">
                                            <spring:message code="asmnt.label.excel.download"/><!-- 엑셀다운로드 -->
                                        </button>
                                    </div>
                                </div>

                                <div style="height: 0.1px; background-color: lightgrey"></div>

                                <div class="option-content gap4 mt10 mb10">
                                    <div class="board_top">
                                        <input id="searchValue" type="text" placeholder="<spring:message code="user.message.search.input.userinfo.no.dept.nm" />" value="">
                                        <button class="btn basic icon search" type="button" id="searchBtn"> <i class="icon-svg-search"></i> </button>

                                        <button type="button" class="btn sm" id="btnApprove">
                                            <small><i class="icon-svg-search"></i><spring:message code="score.button.exam.absent.approve"/> [<span id="midAbsAplyCnt">0</span><spring:message code="message.count"/>]</small>
                                        </button><!-- 결시 승인 -->
                                        <button type="button" class="btn sm" id="btnApplicate">
                                            <small><i class="icon-svg-search"></i><spring:message code="score.button.exam.absent.applicate"/> [<span id="absentApplicateCnt">0</span><spring:message code="message.count"/>]</small>
                                        </button><!-- 결시 신청 -->
                                        <button type="button" class="btn sm" id="btnZero">
                                            <small><i class="icon-svg-search"></i><spring:message code="exam.label.eval.n"/> [ <span id="absentInfoZeroCnt">0</span><spring:message code="forum.label.person"/> ]</small><!-- 미평가 n명 -->
                                        </button>

                                        <small class="right-area">
                                            [ <spring:message code="exam.label.stare.user.cnt" /><!-- 대상인원 --><span id="totCnt">0</span> <spring:message code="forum.label.person" /><!-- 명 -->]
                                        </small>
                                    </div>
                                </div>

                                <input type="hidden" id="scrCnvsStscd" name="scrCnvsStscd"/>
                                <input type="hidden" id="sSbjctId" name="sSbjctId"  />
                                <div id="stdMrkList"></div>
                                <script>
                                    // 성적 테이블
                                    let mrkTable;

                                    $(function () {
                                        const cols = [
                                            {title: "No",   field: "no",     headerHozAlign: "center", hozAlign: "center", width: 50, minWidth: 50},
                                            {title: "학과",  field: "deptnm", headerHozAlign: "center", hozAlign: "center", width: 150, minWidth: 150},
                                            {title: "대표아이디",field: "userId",headerHozAlign: "center", hozAlign: "center", width: 130, minWidth: 130},
                                            {title: "학번",  field: "stdntNo", headerHozAlign: "center", hozAlign: "center", width: 150, minWidth: 150},
                                            {title: "이름",  field: "usernm", headerHozAlign: "center", hozAlign: "center", width: 80, minWidth: 80}
                                        ];

                                        // 성적항목별 컬럼세팅
                                        let mrkItmStngList = ${mrkItmStngList};
                                        <c:forEach items="mrkItmStngList" var="item">
                                            mrkItmStngList.forEach(item =>
                                                cols.push(
                                                    {title: `\${item.mrkItmTynm}</br>(\${item.mrkRfltrt}%)`, field: item.mrkItmTycd, headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 100}
                                                )
                                            );
                                        </c:forEach>

                                        cols.push(
                                            {title: "산출</br>총점",    field: "lstScr",    headerHozAlign: "center", hozAlign: "center", width: 50, minWidth: 50},
                                            {title: "가산</br>점수",    field: "adtnScr",   headerHozAlign: "center", hozAlign: "center", width: 50, minWidth: 50},
                                            {title: "기타</br>점수",    field: "etcScr",     headerHozAlign: "center", hozAlign: "center", width: 70, minWidth: 70},
                                            {title: "최종</br>점수",    field: "totScr",   headerHozAlign: "center", hozAlign: "center", width: 70, minWidth: 70},
                                            {title: "상세정보",         field: "details",   headerHozAlign: "center", hozAlign: "center", width: 80, minWidth: 80, headerSort: false}
                                        );

                                        mrkTable = UiTable("stdMrkList", {
                                            lang: "ko",
                                            selectRow: "checkbox",
                                            columns: cols
                                        });
                                    });
                                </script>

                            </div>
                        </div>
                    </div><!-- //ui form -->
                </div> <!-- //class_sub -->
            </div><!-- //content -->

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

        function createStdMrkListHTML(list, mrkItmList) {
            let scrCnvsSts = false;
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

            for (let i = 0; i < list.length; i++) {
                let std = list[i];
                let scrCnvsStscd = std.scrCnvsStscd || "MRK_CNVS_BFR";
                if (scrCnvsStscd == "MRK_CNVS_CMPTN") {
                    scrCnvsSts = true;
                }
                $("#scoreStatus").val(scrCnvsStscd);

                let row = {
                    no      : (i+1),
                    deptnm  : std.deptnm,
                    userId  : std.userId,
                    userRprsId  : std.userRprsId,
                    stdntNo : std.stdntNo,
                    usernm  : std.usernm,
                    totScr  : `<input type="text" class="totScore" name="totScr" value="\${std.totScr || 0}" inputmask="numeric" mask="999.99" maxVal="100">`,
                    adtnScr : `<input type="hidden" name="adtnScr" value="\${std.adtnScr}" inputmask="numeric" mask="999.99" maxVal="100"><span>\${std.adtnScr || 0}</span>`,
                    etcScr  : `<input type="text" class="inputScore" name="etcScr"  data-prevscr="\${std.etcScr || 0}" value="\${std.etcScr || 0}" inputmask="numeric" mask="999.99" maxVal="100">`,
                    lstScr  : `<input type="hidden" name="lstScr" value="\${std.lstScr}" inputmask="numeric" mask="999.99" maxVal="100"><span name="lstScrTxt">\${std.lstScr || 0}</span>`,
                    details: `<button type="button" class="btn basic small" onclick='goDetailStd("\${std.userId}", "\${std.sbjctId}")'>상세보기</button>`,
                    updateYn    : "N"
                };


                mrkItmList.forEach(item => {
                   if (item.mrkRfltrt > 0) {
                       const mrkItmTycd = item.mrkItmTycd;
                       const acqsScrKey = acqsScrMapping[mrkItmTycd];
                       const drvtnScrKey = drvtnScrMapping[mrkItmTycd];

                       let html = "";

                       let acqsScr  = std[acqsScrKey]  !== null ? std[acqsScrKey]   : "" ;
                       let drvtnScr = std[drvtnScrKey] !== (null || -1) ? std[drvtnScrKey]  : "";

                       if (acqsScr == -1) {
                           html += `<input type="text" class="inputScore" name="acqsScr" data-mrkitmtycd="\${mrkItmTycd}" value="-" inputmask="numeric" mask="999.99" maxVal="100" style="margin: 0 !important;" readonly>`;
                       } else {

                           html += `<input type="text" class="inputScore" name="acqsScr" data-mrkitmtycd="\${mrkItmTycd}" data-prevscr="\${std[acqsScrKey]}" value="\${std[acqsScrKey]}" inputmask="numeric" mask="999.99" maxVal="100" style="margin: 0 !important;">`
                       }

                       html += `
                            <span>&nbsp;>&nbsp;</span>
                            <span name="drvtnScrTxt" data-mrkitmtycd="\${mrkItmTycd}">\${drvtnScr}</span>
                            <input type="hidden" name="drvtnScr" data-mrkitmtycd="\${mrkItmTycd}" data-prevscr="\${drvtnScr}" value="\${drvtnScr}" inputmask="numeric" mask="999.99" maxVal="100">
                        `;

                       row[mrkItmTycd] = html;
                   }
                });

                dataList.push(row);
            }

            // 환산상태가 안맞는 경우
            if (scrCnvsSts && $("#scoreStatus").val() == "MRK_CNVS_BFR") {
                $("#scoreStatus").val("MRK_CNVS_BFR"); // 환산 전 상태로 초기화
            }

            // inputMask 작동되도록 재호출
            setTimeout(() => {
                UiInputmask();
            }, 600);

            return dataList;
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

    </script>

</body>

</html>
