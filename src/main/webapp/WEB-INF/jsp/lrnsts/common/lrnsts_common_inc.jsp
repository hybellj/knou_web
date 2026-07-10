<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
    학습현황 상세 공통 영역.
    lrnsts_detail.jsp와 lrnsts_class_detail.jsp에서 본문/스크립트를 공통으로 사용한다.
--%>
                        <div class="sub-box">
                            <div class="board_top">
                                <h3 class="board-title"><spring:message code="cls.label.student.info"/><%-- 수강생 정보 --%></h3>
                            </div>
                            <div class="user-wrap mb30">
                                <div class="user-img">
                                    <div class="user-photo">
                                        <img id="infoPhoto" src="" alt="photo" hidden style="width:100%; height:100%; object-fit:cover;">
                                    </div>
                                </div>
                                <div class="table_list">
                                    <ul class="list"><li class="head"><label><spring:message code="cls.label.org"/><%-- 기관 --%></label></li><li id="infoOrg">-</li></ul>
                                    <ul class="list"><li class="head"><label><spring:message code="common.name"/><%-- 이름 --%></label></li><li id="infoNm">-</li></ul>
                                    <ul class="list"><li class="head"><label><spring:message code="cls.label.student.no"/><%-- 학번 --%></label></li><li id="infoStdntNo">-</li></ul>
                                    <ul class="list"><li class="head"><label><spring:message code="common.id"/><%-- 아이디 --%></label></li><li id="infoUserId">-</li></ul>
                                    <ul class="list"><li class="head"><label><spring:message code="cls.label.mobile.number"/><%-- 휴대폰번호 --%></label></li><li id="infoMobile">-</li></ul>
                                    <ul class="list"><li class="head"><label><spring:message code="common.email"/><%-- 이메일 --%></label></li><li id="infoEmail">-</li></ul>
                                </div>
                            </div>
                        </div>

                        <div class="sub-box">
                            <div class="board_top">
                                <h3 class="board-title"><spring:message code="cls.label.learning.status"/><%-- 학습 현황 --%></h3>
                                <div class="right-area">
                                    <div class="state-txt-label">
                                        <p><span class="state_ok">○</span> <spring:message code="cls.label.attendance"/><%-- 출석 --%></p>
                                        <p><span class="state_late">△</span> <spring:message code="cls.label.late"/><%-- 지각 --%></p>
                                        <p><span class="state_no">X</span> <spring:message code="cls.label.absence"/><%-- 결석 --%></p>
                                    </div>
                                </div>
                            </div>

                            <div class="table-wrap">
                                <table class="table-type1">
                                    <colgroup>
                                        <col style="width:8%">
                                        <c:forEach begin="1" end="${not empty wkCnt ? wkCnt : 15}"><col style="width:5.2%"/></c:forEach>
                                        <col/>
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th><spring:message code="common.type"/><%-- 구분 --%></th>
                                        <c:forEach begin="1" end="${not empty wkCnt ? wkCnt : 15}" var="w"><th>${w}</th></c:forEach>
                                        <th><spring:message code="cls.label.attendance.status"/><%-- 출석/지각/결석 --%></th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <th><spring:message code="common.week"/><%-- 주차 --%></th>
                                        <c:forEach begin="1" end="${not empty wkCnt ? wkCnt : 15}" var="w">
                                            <td class="t_center" id="wkSts${w}">-</td>
                                        </c:forEach>
                                        <td class="t_center" id="wkSummary">-</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>

                            <div class="table-wrap">
                                <table class="table-type1">
                                    <colgroup>
                                        <col/>
                                        <col style="width:15%"/><col style="width:15%"/>
                                        <col style="width:15%"/><col style="width:15%"/>
                                        <col style="width:15%"/><col style="width:15%"/>
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th><spring:message code="common.type"/><%-- 구분 --%></th>
                                        <th><spring:message code="cls.label.qna"/><%-- Q&A --%><br/><span class="fs-sm">(<spring:message code="cls.label.reply"/><%-- 답변 --%>/<spring:message code="cls.label.register"/><%-- 등록 --%>)</span></th>
                                        <th><spring:message code="cls.label.discussion.board"/><%-- 토론방 --%><br/><span class="fs-sm">(<spring:message code="cls.label.comment.count"/><%-- 댓글수 --%>)</span></th>
                                        <th><spring:message code="cls.label.assignment"/><%-- 과제 --%><br/><span class="fs-sm">(<spring:message code="cls.label.submit"/><%-- 제출 --%>/<spring:message code="common.all"/><%-- 전체 --%>)</span></th>
                                        <th><spring:message code="cls.label.quiz"/><%-- 퀴즈 --%><br/><span class="fs-sm">(<spring:message code="cls.label.stare"/><%-- 응시 --%>/<spring:message code="common.all"/><%-- 전체 --%>)</span></th>
                                        <th><spring:message code="cls.label.survey"/><%-- 설문 --%><br/><span class="fs-sm">(<spring:message code="common.label.join"/><%-- 참여 --%>/<spring:message code="common.all"/><%-- 전체 --%>)</span></th>
                                        <th><spring:message code="cls.label.discussion"/><%-- 토론 --%><br/><span class="fs-sm">(<spring:message code="common.label.join"/><%-- 참여 --%>/<spring:message code="common.all"/><%-- 전체 --%>)</span></th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <th><spring:message code="cls.label.learning.element"/><%-- 학습요소 --%></th>
                                        <td class="t_center" id="elemQa">-</td>
                                        <td class="t_center" id="elemTalk">-</td>
                                        <td class="t_center" id="elemAsmt">-</td>
                                        <td class="t_center" id="elemQuiz">-</td>
                                        <td class="t_center" id="elemSrvy">-</td>
                                        <td class="t_center" id="elemDscs">-</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>

                            <div class="table-wrap">
                                <table class="table-type1">
                                    <colgroup>
                                        <col/>
                                        <col style="width:15%"/><col style="width:15%"/>
                                        <col style="width:15%"/><col style="width:15%"/>
                                        <col style="width:15%"/><col style="width:15%"/>
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th><spring:message code="common.type"/><%-- 구분 --%></th>
                                        <th><spring:message code="cls.label.midterm"/><%-- 중간고사 --%><br/><span class="fs-sm">(<spring:message code="cls.label.realtime"/><%-- 실시간 --%>)</span></th>
                                        <th><spring:message code="cls.label.midterm"/><%-- 중간고사 --%><br/><span class="fs-sm">(<spring:message code="cls.label.alternative"/><%-- 대체 --%>)</span></th>
                                        <th><spring:message code="cls.label.midterm"/><%-- 중간고사 --%><br/><span class="fs-sm">(<spring:message code="common.etc"/><%-- 기타 --%>)</span></th>
                                        <th><spring:message code="cls.label.finalterm"/><%-- 기말고사 --%><br/><span class="fs-sm">(<spring:message code="cls.label.realtime"/><%-- 실시간 --%>)</span></th>
                                        <th><spring:message code="cls.label.finalterm"/><%-- 기말고사 --%><br/><span class="fs-sm">(<spring:message code="cls.label.alternative"/><%-- 대체 --%>)</span></th>
                                        <th><spring:message code="cls.label.finalterm"/><%-- 기말고사 --%><br/><span class="fs-sm">(<spring:message code="common.etc"/><%-- 기타 --%>)</span></th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <th><spring:message code="cls.label.midterm.final"/><%-- 중간/기말 --%></th>
                                        <td class="t_center" id="examMidLive">-</td>
                                        <td class="t_center" id="examMidAlt">-</td>
                                        <td class="t_center" id="examMidEtc">-</td>
                                        <td class="t_center" id="examFinalLive">-</td>
                                        <td class="t_center" id="examFinalAlt">-</td>
                                        <td class="t_center" id="examFinalEtc">-</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="sub-box">
                            <div class="board_top">
                                <h3 class="board-title"><spring:message code="cls.label.class.access.history"/><%-- 강의실 접속 현황 --%></h3>
                                <span class="total_num" id="chartPeriod"></span>
                            </div>
                            <div class="chart-container" style="height:300px;">
                                <canvas id="lineChartUser"></canvas>
                            </div>
                        </div>

                        <div class="sub-box">
                            <div class="board_top">
                                <h3 class="board-title"><spring:message code="cls.label.class.activity.history"/><%-- 강의실 활동기록 --%></h3>
                                <div class="right-area">
                                    <div class="search-typeC">
                                        <input class="form-control" type="text" id="actKeyword" placeholder="<spring:message code='cls.placeholder.keyword.input'/><%-- 검색어 입력 --%>"/>
                                        <button type="button" class="btn basic icon search" onclick="loadActivityLog(1)">
                                            <i class="icon-svg-search"></i>
                                        </button>
                                    </div>
                                    <button type="button" class="btn basic" onclick="downloadActExcel()"><spring:message code="common.button.excel_down"/><%-- 엑셀 다운로드 --%></button>
                                    <input type="hidden" id="actListScale" value="10"/>
                                    <uiex:listScale func="changeActListScale" value="10"/>
                                </div>
                            </div>

                            <div class="table-wrap">
                                <div id="activityLogTable"></div>
                            </div>
                        </div>

<script type="text/javascript">
    var CTX = "<%=request.getContextPath()%>";
    var EPARAM = '<c:out value="${encParams}" />';
    var sbjctId = '<c:out value="${sbjctId}" />';
    var dvclasNo = '<c:out value="${dvclasNo}" />';
    var userId = '<c:out value="${userId}" />';
    var wkCnt = parseInt('${not empty wkCnt ? wkCnt : 15}', 10) || 15;
    var accessChartObj = null;
    var activityLogTable = null;

    $(function () {
        setChartPeriod();
        initActivityLogTable();
        loadDetail();
        loadWkStatus();
        loadAccessChart();
        loadActivityLog(1);

        $("#actKeyword").on("keydown", function (e) {
            if (e.keyCode === 13) {
                loadActivityLog(1);
            }
        });

        $(document).on("click", ".wkCell", function (e) {
            e.preventDefault();
            openWeekPopup($(this).data("wkNo"));
        });
    });

    function moveList() {
        var url = CTX + "/lrnsts/selectLrnStsListView.do";
        if (EPARAM) {
            url += "?encParams=" + encodeURIComponent(EPARAM);
        }
        location.href = url;
    }

    function setChartPeriod() {
        var now = new Date();
        var yyyy = now.getFullYear();
        var mm = String(now.getMonth() + 1).padStart(2, "0");
        var lastDay = new Date(yyyy, now.getMonth() + 1, 0).getDate();
        $("#chartPeriod").text(yyyy + "." + mm + ".01 ~ " + yyyy + "." + mm + "." + String(lastDay).padStart(2, "0"));
    }

    function baseData() {
        var data = { sbjctId: sbjctId, userId: userId };
        if (EPARAM) {
            data.encParams = EPARAM;
        }
        return data;
    }

    function loadDetail() {
        ajaxCall(CTX + "/lrnsts/selectLrnStsDetail.do", baseData(), function (res) {
                if (!res || res.result !== 1 || !res.returnVO) {
                    return;
                }

                if (res.encParams) {
                    EPARAM = res.encParams;
                }

                var d = res.returnVO;
                $("#infoOrg").text(nvl(d.orgNm));
                $("#infoNm").text(nvl(d.usernm));
                $("#infoStdntNo").text(nvl(d.stdntNo));
                $("#infoUserId").text(nvl(d.userId));
                $("#infoMobile").text(nvl(d.mobileNo));
                $("#infoEmail").text(nvl(d.email));
                renderProfilePhoto(d.photoFileId, "#infoPhoto");

                $("#wkSummary").html(
                    '<span class="state_ok total_label">' + nvlNum(d.atndCnt) + '</span>'
                    + '<span class="state_late total_label">' + nvlNum(d.lateCnt) + '</span>'
                    + '<span class="state_no total_label">' + nvlNum(d.absnCnt) + '</span>'
                );

                $("#elemQa").text(nvlNum(d.qaAnsCnt) + "/" + nvlNum(d.qaRegCnt));
                $("#elemTalk").text(nvlNum(d.talkReplyCnt));
                $("#elemAsmt").text(nvlNum(d.asmtSbmsnCnt) + "/" + nvlNum(d.asmtTrgtCnt));
                $("#elemQuiz").text(nvlNum(d.quizSbmsnCnt) + "/" + nvlNum(d.quizTrgtCnt));
                $("#elemSrvy").text(nvlNum(d.srvySbmsnCnt) + "/" + nvlNum(d.srvyTrgtCnt));
                $("#elemDscs").text(nvlNum(d.dscsSbmsnCnt) + "/" + nvlNum(d.dscsTrgtCnt));

                $("#examMidLive").text(formatScore(d.midLiveScore));
                $("#examMidAlt").text(formatScore(d.midAltScore));
                $("#examMidEtc").text(formatScore(d.midEtcScore));
                $("#examFinalLive").text(formatScore(d.finalLiveScore));
                $("#examFinalAlt").text(formatScore(d.finalAltScore));
                $("#examFinalEtc").text(formatScore(d.finalEtcScore));
            }, null, false);
    }

    function loadWkStatus() {
        ajaxCall(CTX + "/lrnsts/selectLrnStsWkStsList.do", baseData(), function (res) {
                if (!res || res.result !== 1 || !res.returnList) {
                    return;
                }

                if (res.encParams) {
                    EPARAM = res.encParams;
                }

                var wkMap = {};
                $.each(res.returnList, function (_, item) {
                    wkMap[item.wkNo] = item.atndSts;
                });

                for (var w = 1; w <= wkCnt; w++) {
                    $("#wkSts" + w).html(renderWkCell(w, wkMap[w]));
                }
            }, null, false);
    }

    function loadAccessChart() {
        ajaxCall(CTX + "/lrnsts/selectLrnStsAccessChartList.do", baseData(), function (res) {
                if (res && res.encParams) {
                    EPARAM = res.encParams;
                }

                var days = [], prevData = [], stdntData = [], avgData = [];
                if (res && res.result === 1 && res.returnList && res.returnList.length > 0) {
                    $.each(res.returnList, function (_, row) {
                        days.push(row.day);
                        prevData.push(nvlNum(row.prevCnt));
                        stdntData.push(nvlNum(row.stdntCnt));
                        avgData.push(nvlNum(row.avgCnt));
                    });
                } else {
                    for (var d = 1, lastDay = getChartLastDay(); d <= lastDay; d++) {
                        days.push(d);
                        prevData.push(0);
                        stdntData.push(0);
                        avgData.push(0);
                    }
                }
                renderChart(days, prevData, stdntData, avgData);
            }, function () {
                var days = [], prevData = [], stdntData = [], avgData = [];
                for (var d = 1, lastDay = getChartLastDay(); d <= lastDay; d++) {
                    days.push(d);
                    prevData.push(0);
                    stdntData.push(0);
                    avgData.push(0);
                }
                renderChart(days, prevData, stdntData, avgData);
            }, false);
    }

    function getChartLastDay() {
        var now = new Date();
        return new Date(now.getFullYear(), now.getMonth() + 1, 0).getDate();
    }

    function renderChart(labels, prevData, stdntData, avgData) {
        if (typeof Chart === "undefined") {
            return;
        }

        var ctx = document.getElementById("lineChartUser").getContext("2d");
        if (accessChartObj) {
            accessChartObj.destroy();
        }

        accessChartObj = new Chart(ctx, {
            type: "line",
            data: {
                labels: labels,
                datasets: [
                    {
                        label: '<spring:message code="cls.label.prev.month"/><%-- 지난달 --%>',
                        data: prevData,
                        fill: false,
                        lineTension: 0,
                        backgroundColor: "rgba(172,172,172,0.4)",
                        borderColor: "rgba(172,172,172,1)",
                        pointBorderColor: "rgba(172,172,172,1)",
                        pointBackgroundColor: "#fff",
                        pointRadius: 2,
                        pointHoverRadius: 5,
                        borderWidth: 1,
                        spanGaps: false
                    },
                    {
                        label: '<spring:message code="common.label.learner"/><%-- 학습자 --%>',
                        data: stdntData,
                        fill: false,
                        lineTension: 0,
                        backgroundColor: "rgba(246,92,158,0.4)",
                        borderColor: "rgba(246,92,158,1)",
                        pointBorderColor: "rgba(246,92,158,1)",
                        pointBackgroundColor: "#fff",
                        pointRadius: 2,
                        pointHoverRadius: 5,
                        borderWidth: 1,
                        spanGaps: false
                    },
                    {
                        label: '<spring:message code="cls.label.average"/><%-- 평균 --%>',
                        data: avgData,
                        fill: false,
                        lineTension: 0,
                        backgroundColor: "rgba(85,154,226,0.6)",
                        borderColor: "rgba(54,162,235,1)",
                        pointBorderColor: "rgba(54,162,235,1)",
                        pointBackgroundColor: "#fff",
                        pointRadius: 2,
                        pointHoverRadius: 5,
                        borderWidth: 1,
                        spanGaps: false
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: "bottom",
                        labels: { boxWidth: 15 }
                    }
                },
                scales: {
                    y: {
                        fontColor: "#333",
                        fontSize: 12,
                        display: true,
                        min: 0,
                        suggestedMax: 10,
                        ticks: {
                            stepSize: 1,
                            callback: function (value) {
                                return value + '<spring:message code="common.page.total_count"/><%-- 건 --%>';
                            }
                        }
                    }
                }
            }
        });
    }

    /**
     * 강의실 활동기록 UiTable을 초기화한다.
     */
    function initActivityLogTable() {
        activityLogTable = UiTable("activityLogTable", {
            lang: "ko",
            pageFunc: loadActivityLog,
            placeholder: "<spring:message code='cls.empty.activity.log'/>", <%-- 조회된 활동기록이 없습니다. --%>
            columns: [
                {
                    title: '<spring:message code="common.number.no"/><%-- 번호 --%>',
                    field: "lineNo",
                    headerHozAlign: "center",
                    hozAlign: "center",
                    width: 90,
                    minWidth: 90
                },
                {
                    title: '<spring:message code="cls.label.datetime"/><%-- 일시 --%>',
                    field: "actDttm",
                    headerHozAlign: "center",
                    hozAlign: "center",
                    width: 180,
                    minWidth: 180
                },
                {
                    title: '<spring:message code="cls.label.activity.content"/><%-- 활동 내용 --%>',
                    field: "actConts",
                    headerHozAlign: "center",
                    hozAlign: "left",
                    width: 0,
                    minWidth: 260
                },
                {
                    title: '<spring:message code="cls.label.access.device"/><%-- 접속기기 --%>',
                    field: "deviceNm",
                    headerHozAlign: "center",
                    hozAlign: "center",
                    width: 150,
                    minWidth: 150
                },
                {
                    title: "IP",
                    field: "ipAddr",
                    headerHozAlign: "center",
                    hozAlign: "center",
                    width: 160,
                    minWidth: 160
                }
            ]
        });
    }

    function loadActivityLog(page) {
        var scale = parseInt($("#actListScale").val(), 10) || 10;
        var data = baseData();
        data.keyword = $("#actKeyword").val();
        data.pageIndex = page;
        data.listScale = scale;

        ajaxCall(CTX + "/lrnsts/selectLrnStsActivityLogList.do", data, function (res) {
                if (!res || res.result !== 1) {
                    activityLogTable.replaceData([]);
                    activityLogTable.setPageInfo({
                        currentPageNo: 1,
                        firstPageNoOnPageList: 1,
                        lastPageNoOnPageList: 1,
                        lastPageNo: 1,
                        totalPageCount: 1,
                        totalRecordCount: 0
                    });
                    return;
                }

                if (res.encParams) {
                    EPARAM = res.encParams;
                }

                var returnList = res.returnList || [];

                activityLogTable.replaceData(createActivityLogData(returnList));
                if (res.pageInfo) {
                    activityLogTable.setPageInfo(res.pageInfo);
                }
            }, function () {
                activityLogTable.replaceData([]);
                activityLogTable.setPageInfo({
                    currentPageNo: 1,
                    firstPageNoOnPageList: 1,
                    lastPageNoOnPageList: 1,
                    lastPageNo: 1,
                    totalPageCount: 1,
                    totalRecordCount: 0
                });
            }, false);
    }

    /**
     * 활동기록 목록 데이터를 UiTable 표시 형식으로 변환한다.
     */
    function createActivityLogData(list) {
        if (!list || list.length === 0) {
            return [];
        }

        return list.map(function (row) {
            return {
                lineNo: nvl(row.lineNo),
                actDttm: nvl(row.actDttm),
                actConts: UiComm.escapeHtml(String(nvl(row.actConts))),
                deviceNm: UiComm.escapeHtml(String(nvl(row.deviceNm))),
                ipAddr: UiComm.escapeHtml(String(nvl(row.ipAddr)))
            };
        });
    }

    /**
     * 활동기록 목록 수 변경 시 첫 페이지부터 다시 조회한다.
     */
    function changeActListScale(scale) {
        $("#actListScale").val(scale || 10);
        loadActivityLog(1);
    }

    function openWeekPopup(wkNo) {
        if (!wkNo) {
            return;
        }

        var url = CTX + "/lrnsts/selectLrnStsWkDetailPopupView.do"
            + "?sbjctId=" + encodeURIComponent(sbjctId)
            + "&dvclasNo=" + encodeURIComponent(dvclasNo || "")
            + "&userId=" + encodeURIComponent(userId)
            + "&wkNo=" + encodeURIComponent(wkNo);

        if (EPARAM) {
            url += "&encParams=" + encodeURIComponent(EPARAM);
        }

        UiDialog("lrnStsWeekPop_" + wkNo, {
            title: "<spring:message code='cls.title.learner.weekly.learning.status'/>", <%-- 학습자 주차 학습현황 --%>
            width: 1140,
            height: 820,
            url: url
        });

        setTimeout(function () {
            $(".ui-dialog:visible").last().find(".ui-dialog-titlebar-close")
                .removeAttr("title")
                .attr("aria-label", "<spring:message code='common.button.close'/>"); <%-- 닫기 --%>
        }, 100);
    }

    function downloadActExcel() {
        var excelGrid = {
            colModel: [
                {label: "<spring:message code='common.number.no'/><%-- 번호 --%>", name: "lineNo", align: "center", width: "3000"},
                {label: "<spring:message code='cls.label.datetime'/><%-- 일시 --%>", name: "actDttm", align: "center", width: "8000"},
                {label: "<spring:message code='cls.label.activity.content'/><%-- 활동 내용 --%>", name: "actConts", align: "left", width: "8000"},
                {label: "<spring:message code='cls.label.access.device'/><%-- 접속기기 --%>", name: "deviceNm", align: "center", width: "5000"},
                {label: "IP", name: "ipAddr", align: "center", width: "6000"}
            ]
        };

        $("form[name=actExcelForm]").remove();

        var $form = $('<form name="actExcelForm" method="post"></form>');
        $form.attr("action", CTX + "/lrnsts/selectLrnStsActivityLogExcelDown.do");
        $form.append($('<input/>', {type: "hidden", name: "sbjctId", value: sbjctId}));
        $form.append($('<input/>', {type: "hidden", name: "userId", value: userId}));
        $form.append($('<input/>', {type: "hidden", name: "keyword", value: $("#actKeyword").val()}));
        $form.append($('<input/>', {type: "hidden", name: "encParams", value: EPARAM}));
        $form.append($('<input/>', {type: "hidden", name: "excelGrid", value: JSON.stringify(excelGrid)}));
        $form.appendTo("body").submit();
    }

    function renderProfilePhoto(photoFileId, selector) {
        if (isRenderablePhotoFileId(photoFileId)) {
            $(selector)
                .off("error")
                .on("error", function () {
                    $(this).prop("hidden", true).attr("src", "");
                })
                .attr("src", photoFileId)
                .prop("hidden", false);
        } else {
            $(selector).off("error").prop("hidden", true).attr("src", "");
        }
    }

    function isRenderablePhotoFileId(photoFileId) {
        if (!photoFileId) return false;
        var normalized = String(photoFileId).trim();
        if (!normalized || normalized === "user_img") return false;
        if (normalized.indexOf("photo_user_sample") !== -1) return false;
        if (normalized.indexOf("user_no_img") !== -1) return false;
        return normalized.indexOf("data:image") === 0
            || normalized.indexOf("/") === 0
            || normalized.indexOf("http://") === 0
            || normalized.indexOf("https://") === 0
            || normalized.indexOf("blob:") === 0;
    }

    function renderWkCell(wkNo, sts) {
        if (!sts) {
            return "-";
        }
        return '<a href="#_" class="wkCell" data-wk-no="' + wkNo + '" aria-label="' + '<spring:message code="cls.button.view.weekly.record"/>' + '">' + renderAtndBadge(sts) + '</a>'; <%-- 주차별 학습기록 보기 --%>
    }

    function renderAtndBadge(sts) {
        if (sts === "ATND") return '<span class="state_ok">○</span>';
        if (sts === "LATE") return '<span class="state_late">△</span>';
        if (sts === "ABSNT") return '<span class="state_no">X</span>';
        if (sts === "NOTSTARTED" || sts === "STUDY") return '<span class="state_none" aria-label="<spring:message code="cls.label.study.notlearned"/>">-</span>';
        return "-";
    }

    function formatScore(value) {
        return value === null || value === undefined || value === "" ? "-" : value;
    }

    function nvl(value) {
        return value === null || value === undefined || value === "" ? "-" : value;
    }

    function nvlNum(value) {
        return value === null || value === undefined || value === "" ? 0 : value;
    }

</script>
