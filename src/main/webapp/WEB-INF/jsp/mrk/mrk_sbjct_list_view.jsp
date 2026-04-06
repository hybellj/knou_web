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
    .inputScore, .totScore, .nonEvalScore {
        width: 60px !important;
        min-width: auto !important;
        max-width: none !important;
        text-align: center !important;
    }
</style>
<body class="home colorA "  style=""><!-- 컬러선택시 클래스변경 -->
    <script type="text/javascript">
        let SEARCH_OBJ;
        let ratioArr = [];
        let midexamHead, lstexamHead, atndcHead, asmtHead, dscsHead, quizHead, srvyHead, smnrHead, etcHead = "";
        let autoSaveInterval = null;

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
                isMrkProcPeriod().done(function () {
                    onScoreCalInit();
                });
            });
        }

        // rawScore 수정 이벤트 (finalScore 계산 및 totScore 재산정)
        function bindScoreModifyEvents() {
            $(document).on("blur", "input[class*=inputScore]", function () {

                let inputScore = this.value;    // 입력점수
                let mrkItmTycd = this.dataset.mrkitmtycd;   // 입력한 성적항목유형코드

                let $row = $(this).closest(".tabulator-row"); //row 선택

                // 기존 점수
                let prevRawScr = this.dataset.prevscr;
                let prevFinalScr = $row.find("input[name=finalScr]").data("prevscr");

                // 1. 최종점수 계산
                let calScore = calcScr(inputScore, mrkItmTycd); // 입력점수에 대한 최종점수
                $row.find("input[name=finalScr][data-mrkitmtycd='" + mrkItmTycd + "']").val(calScore); // 산출 총점 재계산을 위해 선반영

                // 2. 산출 총점 재계산
                let lstScr = 0;
                $row.find("input[name*=finalScr]").each(function () { //성적항목별 최종점수 합치기
                    let finalScore = $(this).val() == "-" ? 0 : parseFloat($(this).val());
                    lstScr += finalScore;
                });
                lstScr = Number(lstScr.toFixed(2));

                // 3. 총점 재계산
                let totScr = 0;
                let adtnScr = Number($row.find("input[name=adtnScr]").val());
                let etcScr = Number($row.find("input[name=etcScr]").val());
                totScr = lstScr + adtnScr + etcScr;

                if (totScr > 100) {
                    // 기존 점수로 복구
                    $(this).val(prevRawScr);
                    $row.find("input[name=finalScr][data-mrkitmtycd='" + mrkItmTycd + "']").val(prevFinalScr);

                    $(this).focus();
                    UiComm.showMessage("총점은 100점을 넘길 수 없습니다.", "warning");
                    return false;
                }

                // 최종점수 반영
                $row.find("input[name=finalScr][data-mrkitmtycd='" + mrkItmTycd + "']").val(calScore); // 성적항목 최종점수 input
                $row.find("span[name=finalScrTxt][data-mrkitmtycd='" + mrkItmTycd + "']").text(calScore); // 성적항목 최종점수 input

                // 산출 총점 반영
                $row.find("input[name=lstScr]").val(lstScr);
                $row.find("span[name=lstScrTxt]").text(lstScr);

                // 총점 반영
                $row.find("input[name=totScr]").val(totScr);
            });
        }

        // 학기기수 세팅 변경
        function changeSmstrChrt() {
            let $dgrsSmstr = $('#dgrsSmstr');

            $dgrsSmstr.empty();

            $.ajax({
                url  : "/crs/termMgr/smstrListByDgrsYr.do",
                data : {
                    dgrsYr 	: $("#dgrsYr").val()
                    <%--	,orgId	: $("#orgId").val() --%>
                },
                type : "GET",
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

            let url = "/crs/creCrsMgr/sbjctOfrngList.do";

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

        //운영과목 리스트 조회
        function listSbjct() {
            let url = "/crs/creCrsMgr/sbjctOfrngList.do";
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
                success	: function(data) {
                    if (data.result > 0) {
                        let returnList = data.returnList || [];
                        let dataList = createSubjectListHTML(returnList);
                        sbjctListTable.clearData();
                        sbjctListTable.replaceData(dataList);

                        $("#ttlSbjctCnt").text(returnList.length);

                        $("#scoreAllListDiv").css("display", "none");

                    } else {
                        UiComm.showMessage(data.message, "warning");
                    }
                },
                error: function(xhr, status, error) {
                    UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
                }
            });
        }

        // 학생 성적 목록 조회
        function listStdMrk(rowData, searchType = '') {
            UiComm.showLoading(true);
            let sbjctId = rowData.sbjctId;

            $.ajax({
                url : "/mrk/profMrkRfltrtSelectAjax.do",
                data: { sbjctId : sbjctId, searchType: searchType },
                type: "GET",
                success: function (data) {
                    $("#sSbjctId").val(sbjctId);

                    let returnList  = data.returnList || [];
                    let returnVO    = data.returnVO || {};
                    let mrkRfltrtInfoMapList = data.returnSubVO || [];

                    if (mrkRfltrtInfoMapList.length <= 0 ) {
                        $("#scoreAllListDiv").css("display", "none");
                        UiComm.showMessage("<spring:message code='score.label.process.msg19' />", "warning");/*해당과목의 평가기준을 먼저 입력해주세요.*/
                        UiComm.showLoading(false);
                        setAutoSave("OFF");
                        return;
                    }

                    if (mrkTable) {
                        mrkTable.destroy();
                    }

                    initStdMrkTable(mrkRfltrtInfoMapList);

                    // 전체인원 최초1번 세팅
                    if ( !searchType && !$("#searchValue").val() ) {
                        if (!$("#totCnt").hasClass("init")) {
                            $("#totCnt").text(returnVO.totCnt);
                            $("#totCnt").addClass("init")
                        }
                    }

                    let dataList = createStdMrkListHTML(returnList, mrkRfltrtInfoMapList);
                    mrkTable.on("tableBuilt", function() {
                        mrkTable.replaceData(dataList).then(function () {
                            // 데이터가 화면에 그려진 후 실행
                            mrkTable.getRows().forEach(row => {
                                const data = row.getData();
                                const rowEl = row.getElement();
                                $(rowEl).attr("data-user-id", data.userId);
                                $(rowEl).attr("data-chgyn", "N");
                            })
                        })
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
        function calcScr(input, mrkItmTycd) {
            let mrkRfltrt = 0;
            if ( mrkItmTycd == "MIDEXAM") {
                mrkRfltrt = midexamHead;
            } else if (mrkItmTycd == "LSTEXAM") {
                mrkRfltrt = lstexamHead;
            }  else if (mrkItmTycd == "ATNDC") {
                mrkRfltrt = atndcHead;
            }  else if (mrkItmTycd == "ASMT") {
                mrkRfltrt = asmtHead;
            }  else if (mrkItmTycd == "DSCS") {
                mrkRfltrt = dscsHead;
            }  else if (mrkItmTycd == "QUIZ") {
                mrkRfltrt = quizHead;
            }  else if (mrkItmTycd == "SRVY") {
                mrkRfltrt = srvyHead;
            }  else if (mrkItmTycd == "SMNR") {
                mrkRfltrt = smnrHead;
            }

            return (input * mrkRfltrt / 100).toFixed(2);
        }

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
        <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp"/>
        <!-- //common header -->

        <main class="common">
            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- 본문 content 부분 -->
            <div id="content" class="content-wrap common">
                <div class="dashboard_sub">

                    <!-- page_tab -->
                    <jsp:include page="/WEB-INF/jsp/common_new/home_page_tab.jsp"/>
                    <!-- //page_tab -->
                    <div class="sub-content">

                        <div class="page-info">
                            <%--타이틀--%>
                            <h2 class="page-title">성적관리</h2><!-- 종합성적 -->
                            <%--네비게이션바--%>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li><span class="current">성적관리</span></li>
                                </ul>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title"><spring:message code="score.label.service.lecture"/></h3><!-- 운영과목 -->
                            <span>[ <spring:message code="exam.label.total"/> <span class="fcBlue" id="ttlSbjctCnt"> 0</span><spring:message code="exam.label.cnt"/> ]</span><!-- 총 건 -->
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
                                    <select class="form-select" id="orgId" disabled><!-- 기관 -->
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
                                    <select class="form-select" id="sbjctId">
                                        <option value=""><spring:message code="common.subject" /></option><!-- 과목 -->
                                    </select>
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="listSbjct()"><spring:message code="sys.button.search" /></button>
                            </div>
                        </div>

                        <div class="table-wrap" id="sbjctList"> </div>
                        <script>
                            // 과목 리스트 테이블
                            let sbjctListTable = UiTable("sbjctList", {
                                lang: "ko",
                                height: 300,
                                selectRow: "1",
                                selectRowFunc: listStdMrk,
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
                        </script>

                        <!-- 성적처리 테이블 -->
                        <div id="scoreAllListDiv" style="display: none; margin-top: 50px">
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
                                        <small><i class="icon-svg-search"></i><spring:message code="score.button.exam.absent.approve"/> [<span id="absentApproveCnt">0</span><spring:message code="message.count"/>]</small>
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

                            <form id="tableForm">
                                <input type="hidden" id="scrCnvsStscd" name="scrCnvsStscd"/>
                                <input type="hidden" id="sSbjctId" name="sSbjctId"  />
                                <div id="stdMrkList"></div>
                                <script>

                                    let mrkTable;

                                    // 학생 성적 목록 테이블 초기화
                                    function initStdMrkTable(rateData) {
                                        // 기본 고정 헤더 (앞부분)
                                        let dynamicHeader = [
                                            {title: "No",   field: "no",     headerHozAlign: "center", hozAlign: "center", width: 50, minWidth: 50},
                                            {title: "학과",  field: "deptnm", headerHozAlign: "center", hozAlign: "center", width: 150, minWidth: 150},
                                            {title: "대표아이디",field: "userId",headerHozAlign: "center", hozAlign: "center", width: 130, minWidth: 130},
                                            {title: "학번",  field: "stdntNo", headerHozAlign: "center", hozAlign: "center", width: 150, minWidth: 150},
                                            {title: "이름",  field: "usernm", headerHozAlign: "center", hozAlign: "center", width: 80, minWidth: 80}
                                        ];

                                        // 성적반영비율에 따른 동적 헤더 추가
                                        rateData.forEach(item => {
                                            const mrkItmTycd = item.mrkItmTycd;
                                            const mrkRfltrt = item.mrkRfltrt;

                                            if ( mrkItmTycd == "MIDEXAM") {
                                                midexamHead = mrkRfltrt;
                                            } else if (mrkItmTycd == "LSTEXAM") {
                                                lstexamHead = mrkRfltrt;
                                            }  else if (mrkItmTycd == "ATNDC") {
                                                atndcHead = mrkRfltrt;
                                            }  else if (mrkItmTycd == "ASMT") {
                                                asmtHead = mrkRfltrt;
                                            }  else if (mrkItmTycd == "DSCS") {
                                                dscsHead = mrkRfltrt;
                                            }  else if (mrkItmTycd == "QUIZ") {
                                                quizHead = mrkRfltrt;
                                            }  else if (mrkItmTycd == "SRVY") {
                                                srvyHead = mrkRfltrt;
                                            }  else if (mrkItmTycd == "SMNR") {
                                                smnrHead = mrkRfltrt;
                                            }
                                            if (item.mrkRfltrt > 0)  {
                                                dynamicHeader.push(
                                                    {title: `\${item.mrkItmTynm}</br>(\${item.mrkRfltrt}%)`, field: `\${item.mrkItmTycd}`, headerHozAlign: "center", hozAlign: "center", width: 130, minWidth: 100}
                                                );
                                            }
                                        });

                                        dynamicHeader.push(
                                            {title: "산출</br>총점",    field: "lstScr",    headerHozAlign: "center", hozAlign: "center", width: 50, minWidth: 50},
                                            {title: "가산</br>점수",    field: "adtnScr",   headerHozAlign: "center", hozAlign: "center", width: 50, minWidth: 50},
                                            {title: "기타</br>점수",    field: "etcScr",     headerHozAlign: "center", hozAlign: "center", width: 70, minWidth: 70},
                                            {title: "최종</br>점수",    field: "totScr",   headerHozAlign: "center", hozAlign: "center", width: 70, minWidth: 70},
                                            {title: "상세정보",         field: "details",   headerHozAlign: "center", hozAlign: "center", width: 80, minWidth: 80, headerSort: false}
                                        );

                                        return mrkTable = UiTable("stdMrkList", {
                                            lang: "ko",
                                            selectRow: "checkbox",
                                            columns: dynamicHeader
                                        })
                                    }
                                </script>
                            </form>

                            <div class="row">
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
                            </div>
                        </div>

                    </div>
                </div><!-- //ui form -->
            </div><!-- //content -->


            <!-- common footer -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
            <!-- //common footer -->
        </main><!-- //container -->
    </div><!-- //pusher -->


<!-- 일괄평가 확인팝업 -->
<form class="ui form" id="modalEvlWarningForm" name="modalEvlWarningForm" method="POST" action="">
    <input type="hidden" name="crsCreCd"/>
    <div class="modal fade" id="modalEvlWarning" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="score.label.batch.evaluation" />" aria-hidden="false">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="sys.button.close" />">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title"><spring:message code="score.label.batch.evaluation" /><!-- 일괄평가 시 주의사항 --></h4>
                </div>
                <div class="modal-body">
                    <iframe src="" id="modalEvlWarningIfm" name="modalEvlWarningIfm" width="100%" scrolling="no"></iframe>
                </div>
            </div>
        </div>
    </div>
</form>

<!-- 성적환산 팝업 -->
<form class="ui form" id="modalScoreCalForm" name="modalScoreCalForm" method="POST" action="">
    <input type="hidden" name="crsCreCd"/>
    <div class="modal fade" id="modalScoreCal" tabindex="-1" role="dialog" aria-labelledby="" aria-hidden="false">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="sys.button.close" />">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 id="modalTitleId" class="modal-title"></h4>
                </div>
                <div class="modal-body">
                    <iframe src="" id="modalScoreCalIfm" name="modalScoreCalIfm" width="100%" scrolling="no"></iframe>
                </div>
            </div>
        </div>
    </div>
</form>

<!-- 종합성적처리 학생메모 팝업 -->
<form class="ui form" id="modalStdMemoForm" name="modalStdMemoForm" method="POST" action="">
    <input type="hidden" name="crsCreCd"/>
    <input type="hidden" name="stdNo"/>
    <div class="modal fade" id="modalStdMemo" tabindex="-1" role="dialog"
         aria-labelledby="<spring:message code="common.label.learner" /><spring:message code="exam.label.memo" />"
         aria-hidden="false">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="sys.button.close" />">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title">
                        <spring:message code="common.label.learner" /><spring:message code="exam.label.memo" /><!-- 학습자메모 --></h4>
                </div>
                <div class="modal-body">
                    <iframe src="" id="modalStdMemoIfm" name="modalStdMemoIfm" width="100%" scrolling="no"></iframe>
                </div>
            </div>
        </div>
    </div>
</form>

<!-- 종합성적처리 상세팝업 -->
<form class="ui form" id="modalScoreOverallDtlForm" name="modalScoreOverallDtlForm" method="POST" action="">
    <input type="hidden" name="crsCreCd"/>
    <input type="hidden" name="userId"/>
    <input type="hidden" name="stdNo"/>
    <div class="modal fade" id="modalScoreOverallDtl" tabindex="-1" role="dialog"
         aria-labelledby="<spring:message code="score.label.university.score.detail.info" />" aria-hidden="false">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"
                            aria-label="<spring:message code="sys.button.close" />">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title">
                        <spring:message code="score.label.university.score.detail.info" /><!-- 종합성적 상세정보 --></h4>
                </div>
                <div class="modal-body">
                    <iframe src="" id="modalScoreOverallDtlIfm" name="modalScoreOverallDtlIfm" width="100%"
                            scrolling="no"></iframe>
                </div>
            </div>
        </div>
    </div>
</form>

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

        function createStdMrkListHTML(list, rateData) {
            let scrCnvsSts = false;
            let dataList = [];
            if (list.length <= 0) return dataList;

            // 성적항목타입코드와 점수필드명 매핑
            const rawScoreMapping = {
                "MIDEXAM": "midexamScore",
                "LSTEXAM": "lstexamScore",
                "ATNDC":   "atndcScore",
                "ASMT":    "asmtScore",
                "DSCS":    "dscsScore",
                "QUIZ":    "quizScore",
                "SRVY":    "srvyScore",
                "SMNR":    "smnrScore"
            };
            const finalScoreMapping = {
                "MIDEXAM": "midexamScoreAvg",
                "LSTEXAM": "lstexamScoreAvg",
                "ATNDC":   "atndcScoreAvg",
                "ASMT":    "asmtScoreAvg",
                "DSCS":    "dscsScoreAvg",
                "QUIZ":    "quizScoreAvg",
                "SRVY":    "srvyScoreAvg",
                "SMNR":    "smnrScoreAvg"
            };

            for (let i = 0; i < list.length; i++) {
                let std = list[i];
                let scrCnvsStscd = std.scrCnvsStscd || "MRK_CNVS_BFR";
                if (scrCnvsStscd == "MRK_CNVS_CMPTN") {
                    scrCnvsSts = true;
                }
                $("#scoreStatus").val(scrCnvsStscd);

                let row = {
                    no: (i+1),
                    deptnm: std.deptnm,
                    userId: std.userId,
                    stdntNo: std.stdntNo,
                    usernm: std.usernm,
                    lstScr: `<input type="hidden" name="lstScr" value="\${std.lstScr}" inputmask="numeric" mask="999.99" maxVal="100"><span name="lstScrTxt">\${std.lstScr || 0}</span>`,
                    adtnScr: `<input type="hidden" name="adtnScr" value="\${std.adtnScr}" inputmask="numeric" mask="999.99" maxVal="100"><span>\${std.adtnScr || 0}</span>`,
                    etcScr: `<input type="text" class="inputScore" name="etcScr"  data-prevscr="\${std.etcScr || 0}" value="\${std.etcScr || 0}" inputmask="numeric" mask="999.99" maxVal="100">`,
                    totScr: `<input type="text" class="totScore" name="totScr" value="\${std.totScr || 0}" inputmask="numeric" mask="999.99" maxVal="100">`,
                //     ------------ 상세정보 버튼 클릭 시 넘길 데이터
                    details: `<button type="button" class="btn basic small" onclick='goDetailStd("\${std.userId}", "\${std.sbjctId}")'>상세보기</button>`
                };


                rateData.forEach(item => {
                   if (item.mrkRfltrt > 0) {
                       const tycd = item.mrkItmTycd;
                       const rawScore = rawScoreMapping[tycd];
                       const finalScore = finalScoreMapping[tycd];

                       let html = "";

                       if (std[rawScore] == -1) html += `<input type="text" class="inputScore" name="rowScr" data-mrkitmtycd="\${tycd}" value="-" inputmask="numeric" mask="999.99" maxVal="100" style="margin: 0 !important;" readonly>`;

                       row[tycd] = `
                            <input type="text" class="inputScore" name="rowScr" data-mrkitmtycd="\${tycd}" data-prevscr="\${std[rawScore]}" value="\${std[rawScore]}" inputmask="numeric" mask="999.99" maxVal="100" style="margin: 0 !important;">
                            <span>&nbsp;>&nbsp;</span>
                            <span name="finalScrTxt" data-mrkitmtycd="\${tycd}">\${std[finalScore]}</span>
                            <input type="hidden" name="finalScr" data-mrkitmtycd="\${tycd}" data-prevscr="\${std[finalScore]}" value="\${std[finalScore]}" inputmask="numeric" mask="999.99" maxVal="100">
                        `;
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
            }, 500);

            return dataList;
        }

        // 성적 저장
        function onSave(autoSaveYn) {
            UiComm.showLoading(true);

            // 학생 성적을 담을 배열
            const stdMrkList = {};

            // 모든 성적행 찾아 루프돌기
            $("#scoreAllListDiv").find(".tabulator-row").each(function () {
                const $row = $(this);

                // 학생 객체 생성
                const userId = $row.attr("data-user-id");

                // 해당 userId 키가 없으면 빈 객체 생성 및 초기화
                if (!stdMrkList[userId]){
                    stdMrkList[userId] = {};
                }

                // 학생 성적 정보 insert
                // -- 평가점수
                $row.find("input[name=rowScr]").each(function () {
                    stdMrkList[userId][this.dataset.mrkitmtycd] = this.value;
                });
                // -- 최종점수는 백단에서 계산
                // -- 기타점수
                stdMrkList[userId]["etcScr"]=$row.find("input[name=etcScr]").val();
            });

            const param = {
                "sbjctId": $("#sSbjctId").val(),
                "stdMrkList": stdMrkList
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
