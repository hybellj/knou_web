<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

    <link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>
    <script type="text/javascript">
        var CURRENT_MONTH = '<c:out value="${nowMonth}" />';
        var CHART;

        $(document).ready(function () {
            // 1.학습현황 영역
            setAttendList();

            // 2.학습요소 참여현황 영역
            setStudyStatusArea();

            // 3.강의실 접속 현황 영역 세팅
            setEnterStatusArea();

            // 4.강의실 활동기록 영역
            setActivityHistoryArea();
        });

        // 1.학습현황 영역
        function setAttendList() {
            var stdNo = '<c:out value="${stdVO.stdNo}" />';

            // 주차
            $.each($("[data-lesson-schedule-order]"), function () {
                $(this).html("-");
            });

            // 주차 세팅
            var url = "/std/stdLect/listStdAttend.do";
            var data = {
                crsCreCd: '<c:out value="${vo.crsCreCd}" />'
                , stdNo: stdNo
            };

            var completeIcon = '<span class=""><i class="ico icon-solid-circle fcBlue"></i></span>';
            var lateIcon = '<span class=""><i class="ico icon-triangle fcYellow"></i></span>';
            var nostudyIcon = '<span class=""><i class="ico icon-cross fcRed"></i></span>';
            var emptyIcon = '<span class=""><i class="ico icon-slash"></i></span>';
            var readyIcon = '<span class=""><i class="ico icon-hyphen"></i></span>';
            var ingIcon = '<span class=""><i class="fcBlue ico icon-state-ing"></i></span>';

            var serverMode = "<%=CommConst.SERVER_MODE%>";
            if (serverMode.indexOf("local") > -1 || serverMode.indexOf("devel") > -1) {
                var ingIcon = '<span class=""><i class="ico icon-hyphen"></i></span>';
            }

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    var attendInfo = data.returnList[0] || {};
                    var html = emptyIcon;

                    var completeCnt = 0;
                    var lateCnt = 0;
                    var noStudyCnt = 0;

                    $.each($("[data-lesson-schedule-id]"), function () {
                        var id = $(this).data("lessonScheduleId");
                        var startDtYn = $(this).data("startDtYn");
                        var endDtYn = $(this).data("endDtYn");
                        var wekClsfGbn = $(this).data("wekClsfGbn");
                        var prgrVideoCnt = 1 * $(this).data("prgrVideoCnt");

                        var key = "stuSttCd_" + id;
                        var studyStatusCd = attendInfo[key];
                        var html = '-';

                        if (wekClsfGbn == "04" || wekClsfGbn == "05") {
                            html = readyIcon;
                        } else {
                            if (!(wekClsfGbn == "02" || wekClsfGbn == "03") && prgrVideoCnt == 0) {
                                if (startDtYn == "N") {
                                    html = emptyIcon;
                                } else {
                                    html = readyIcon;
                                }
                            } else if (studyStatusCd == "COMPLETE") {
                                html = completeIcon;
                                completeCnt++;
                            } else if (studyStatusCd == "LATE") {
                                html = lateIcon;
                                lateCnt++;
                            } else if (startDtYn == "N") {
                                html = emptyIcon;
                            } else if (startDtYn == "Y" && endDtYn == "N") {
                                if (studyStatusCd == "STUDY") {
                                    html = ingIcon;
                                } else {
                                    html = readyIcon;
                                }
                            } else {
                                html = nostudyIcon;
                                noStudyCnt++;
                            }
                        }

                        $(this).html(html);
                    });

                    $("#endCompleteCntText").html(completeCnt);
                    $("#endLateCntText").html(lateCnt);
                    $("#endNostudyCntText").html(noStudyCnt);
                }
            }, function (xhr, status, error) {
            });
        }

        // 2.학습요소 참여현황 영역 세팅
        function setStudyStatusArea() {
            // 과제 (제출/전체)
            $("#asmntCnt").text("0");
            $("#asmntJoinCnt").text("0");
            // 퀴즈 (제출/전체)
            $("#quizCnt").text("0");
            $("#quizJoinCnt").text("0");
            // 설문 (제출/전체)
            $("#reschCnt").text("0");
            $("#reschJoinCnt").text("0");
            // 토론 (제출/전체)
            $("#forumCnt").text("0");
            $("#forumJoinCnt").text("0");

            // 학습요소 세팅
            var url = "/std/stdLect/listStdJoinStatus.do";
            var data = {
                crsCreCd: '<c:out value="${vo.crsCreCd}" />'
                , stdNo: '<c:out value="${stdVO.stdNo}" />'
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    var returnVO = data.returnList[0];

                    if (returnVO) {
                        // 과제 (제출/전체)
                        $("#asmntCnt").text(returnVO.asmntCnt);
                        $("#asmntJoinCnt").text(returnVO.asmntJoinCnt);
                        // 퀴즈 (제출/전체)
                        $("#quizCnt").text(returnVO.quizCnt);
                        $("#quizJoinCnt").text(returnVO.quizJoinCnt);
                        // 설문 (제출/전체)
                        $("#reschCnt").text(returnVO.reschCnt);
                        $("#reschJoinCnt").text(returnVO.reschJoinCnt);
                        // 토론 (제출/전체)
                        $("#forumCnt").text(returnVO.forumCnt);
                        $("#forumJoinCnt").text(returnVO.forumJoinCnt);
                    }
                }
            }, function (xhr, status, error) {
            });
        }

        // 3.강의실 접속 현황 영역 세팅
        function setEnterStatusArea() {
            setChart([], [], []);

            var year = '<c:out value="${nowYear}" />';
            var month = ("" + CURRENT_MONTH).padStart(2, "0");
            var searchTo = ("" + year) + month;

            var url = "/lesson/lessonLect/stdEnterStatusList.do";
            var data = {
                crsCreCd: '<c:out value="${vo.crsCreCd}" />'
                , stdNo: '<c:out value="${stdVO.stdNo}" />'
                , searchTo: searchTo
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    var returnVO = data.returnVO;
                    var returnList = data.returnList || [];

                    // 강의실 접속현황 차트 세팅
                    var prevList = new Array(31);
                    var nowList = new Array(31);
                    var avgList = new Array(31);

                    var prevObj = {};
                    var nowObj = {};
                    var avgObj = {};

                    returnList.forEach(function (v, i) {
                        var days = v.days * 1;

                        if (v.label == "prevMonth") {
                            prevObj[days] = v.stdDayCnt;
                        } else if (v.label == "nowMonth") {
                            nowObj[days] = v.stdDayCnt;
                            avgObj[days] = v.avgStdDayCnt;
                        }
                    });

                    for (var i = 0; i < 31; i++) {
                        var days = i + 1;

                        if (typeof prevObj[days] !== "undefined") {
                            prevList[i] = prevObj[days];
                        } else {
                            prevList[i] = 0;
                        }

                        if (typeof nowObj[days] !== "undefined") {
                            nowList[i] = nowObj[days];
                            avgList[i] = avgObj[days];
                        } else {
                            nowList[i] = 0;
                            avgList[i] = 0;
                        }
                    }

                    setChart(prevList, nowList, avgList);
                }
            }, function (xhr, status, error) {
            });
        }

        // 강의실 접속현황 차트 세팅
        function setChart(prevList, nowList, avgList) {
            var ctx = document.getElementById("lineChart");

            if (CHART) {
                CHART.destroy();
            }

            CHART = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"],
                    datasets: [
                        {
                            label: '<spring:message code="std.label.last_month" />', // 지난달
                            fill: false,
                            lineTension: 0,
                            backgroundColor: "rgba(172, 172, 172,0.4)",
                            borderColor: "rgba(172, 172, 172,1)",
                            borderCapStyle: 'butt',
                            borderDash: [],
                            borderDashOffset: 0.0,
                            borderJoinStyle: 'miter',
                            pointBorderColor: "rgba(172, 172, 172,1)",
                            pointBackgroundColor: "#fff",
                            pointBorderWidth: 1,
                            pointHoverRadius: 5,
                            pointHoverBackgroundColor: "rgba(172, 172, 172,1)",
                            pointHoverBorderColor: "rgba(0,0,0,0.4)",
                            pointHoverBorderWidth: 2,
                            pointRadius: 2,
                            pointHitRadius: 10,
                            data: prevList,
                            spanGaps: false,
                            borderWidth: 1
                        },
                        {
                            label: '<spring:message code="std.label.learner2" />', // 학습자
                            fill: false,
                            lineTension: 0,
                            backgroundColor: "rgba(255,99,132,0.4)",
                            borderColor: "rgba(255,99,132,1)",
                            borderCapStyle: 'butt',
                            borderDash: [],
                            borderDashOffset: 0.0,
                            borderJoinStyle: 'miter',
                            pointBorderColor: "rgba(255,99,132,1)",
                            pointBackgroundColor: "#fff",
                            pointBorderWidth: 1,
                            pointHoverRadius: 5,
                            pointHoverBackgroundColor: "rgba(255,99,132,1)",
                            pointHoverBorderColor: "rgba(0,0,0,0.4)",
                            pointHoverBorderWidth: 2,
                            pointRadius: 2,
                            pointHitRadius: 10,
                            data: nowList,
                            spanGaps: false,
                            borderWidth: 1
                        },
                        {
                            label: '<spring:message code="std.label.avg" />', // 평균
                            fill: false,
                            lineTension: 0,
                            backgroundColor: "rgba(54, 162, 235,0.4)",
                            borderColor: "rgba(54, 162, 235,1)",
                            borderCapStyle: 'butt',
                            borderDash: [],
                            borderDashOffset: 0.0,
                            borderJoinStyle: 'miter',
                            pointBorderColor: "rgba(54, 162, 235,1)",
                            pointBackgroundColor: "#fff",
                            pointBorderWidth: 1,
                            pointHoverRadius: 5,
                            pointHoverBackgroundColor: "rgba(54, 162, 235,1)",
                            pointHoverBorderColor: "rgba(0,0,0,0.4)",
                            pointHoverBorderWidth: 2,
                            pointRadius: 2,
                            pointHitRadius: 10,
                            data: avgList,
                            spanGaps: false,
                            borderWidth: 1
                        }
                    ]
                },
                options: {
                    responsive: true,
                    scales: {
                        yAxes: [{
                            ticks: {
                                beginAtZero: true,
                                // stepSize: 1,
                                // suggestedMax: 10,
                                callback: function (value) {
                                    return value + "건"
                                }
                            }
                        }]
                    },
                    legend: {
                        display: true,
                        position: 'bottom',
                        labels: {
                            boxWidth: 12
                        }
                    }
                }
            });
        }

        // 월 선택 변경
        function changeEnterStatusMonth(type) {
            var nowMonth = '<c:out value="${nowMonth}" />';

            // 현재년도 내에서 조회
            if (type == "left" && CURRENT_MONTH == 1) return;
            if (type == "right" && (CURRENT_MONTH == 12 || CURRENT_MONTH == nowMonth)) return;

            $("#monthLeftBtn").prop("disabled", false);
            $("#monthRightBtn").prop("disabled", false);

            if (type == "left") {
                CURRENT_MONTH = CURRENT_MONTH * 1 - 1;

                if (CURRENT_MONTH == 1) {
                    $("#monthLeftBtn").prop("disabled", true);
                }
            } else if (type == "right") {
                CURRENT_MONTH = CURRENT_MONTH * 1 + 1;

                if (CURRENT_MONTH == 12 || CURRENT_MONTH == nowMonth) {
                    $("#monthRightBtn").prop("disabled", true);
                }
            }

            $("#monthText").val(CURRENT_MONTH + '<spring:message code="std.label.month" />'); // 월

            setEnterStatusArea();
        }

        // 4.강의실 활동기록 영역 세팅
        function setActivityHistoryArea() {
            listPaging(1);
        }

        // 강의실 활동 기록 조회
        function listPaging(pageIndex) {
            var url = "/lesson/lessonLect/lessonActnHstyList.do";
            var data = {
                crsCreCd: '<c:out value="${vo.crsCreCd}" />'
                , pageIndex: pageIndex
                , userId: '<c:out value="${stdVO.userId}" />'
                , listScale: $("#listScale").val()
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    var returnList = data.returnList || [];
                    var pageInfo = data.pageInfo;
                    var html = "";

                    returnList.forEach(function (v, i) {
                        var regDttmFmt = (v.regDttm || "").length == 14 ? v.regDttm.substring(0, 4) + '.' + v.regDttm.substring(4, 6) + '.' + v.regDttm.substring(6, 8) + ' ' + v.regDttm.substring(8, 10) + ':' + v.regDttm.substring(10, 12) : v.regDttm;

                        html += '<tr>';
                        html += '	<td>' + v.lineNo + '</td>';
                        html += '	<td>' + regDttmFmt + '</td>';
                        html += '	<td>' + v.actnHstyCts + '</td>';
                        html += '	<td>' + v.deviceTypeCd + '</td>';
                        html += '	<td>' + v.regIp + '</td>';
                        html += '</tr>';
                    });

                    $("#enterStatusList").empty().html(html);
                    $("#enterStatusListTable").footable();

                    var params = {
                        totalCount: pageInfo.totalRecordCount,
                        listScale: pageInfo.recordCountPerPage,
                        currentPageNo: pageInfo.currentPageNo,
                        eventName: "listPaging"
                    };

                    gfn_renderPaging(params);
                } else {
                    $("#enterStatusList").empty().html("");
                    $("#enterStatusListTable").footable();
                }
            }, function (xhr, status, error) {
                $("#enterStatusList").empty().html("");
                $("#enterStatusListTable").footable();
            });
        }

        // 강의실 활동 기록 엑셀 다운로드
        function downExcel() {
            var excelGrid = {
                colModel: [
                    {
                        label: '<spring:message code="main.common.number.no" />',
                        name: 'lineNo',
                        align: 'right',
                        width: '1000'
                    }, // NO
                    {
                        label: '<spring:message code="std.label.date_time" />',
                        name: 'regDttm',
                        align: 'center',
                        width: '5000',
                        formatter: 'date',
                        formatOptions: {srcformat: 'yyyyMMddHHmmss', newformat: 'yyyy.MM.dd HH:mm', defaultValue: '-'}
                    },
                    {
                        label: '<spring:message code="std.label.activity_content" />',
                        name: 'actnHstyCts',
                        align: 'left',
                        width: '5000'
                    }, // 활동 내용
                    {
                        label: '<spring:message code="std.label.access_device" />',
                        name: 'deviceTypeCd',
                        align: 'left',
                        width: '5000'
                    }, // 접근 장비
                    {
                        label: '<spring:message code="user.title.manage.userinfo.conn.ip" />',
                        name: 'regIp',
                        align: 'center',
                        width: '5000'
                    }, // 접속IP
                ]
            };

            var url = "/lesson/lessonLect/lessonActnHstyExcelDown.do";
            var form = $("<form></form>");
            form.attr("method", "POST");
            form.attr("name", "excelForm");
            form.attr("action", url);
            form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '<c:out value="${vo.crsCreCd}" />'}));
            form.append($('<input/>', {type: 'hidden', name: 'userId', value: '<c:out value="${stdVO.userId}" />'}));
            form.append($('<input/>', {type: 'hidden', name: 'excelGrid', value: JSON.stringify(excelGrid)}));
            form.appendTo("body");
            form.submit();

            $("form[name=excelForm]").remove();
        }

        // 주차별 학습현황 상세 팝업
        /*
        function studyStatusByWeekModal(lessonScheduleId, stdNo) {
            $("#studyStatusByWeekForm > input[name='lessonScheduleId']").val(lessonScheduleId);
            $("#studyStatusByWeekForm > input[name='stdNo']").val(stdNo);
            $("#studyStatusByWeekForm").attr("target", "studyStatusByWeekIfm");
            $("#studyStatusByWeekForm").attr("action", "/std/stdPop/studyStatusByWeekPop.do");
            $("#studyStatusByWeekForm").submit();
            $('#studyStatusByWeekModal').modal('show');

            $("#studyStatusByWeekForm > input[name='lessonScheduleId']").val("");
            $("#studyStatusByWeekForm > input[name='stdNo']").val("");
        }
         */

        // 제출/참여 이력 팝업
        function submitJoinHistoryModal(stdNo, searchKey) {
            $("#submitJoinHistoryForm > input[name='searchKey']").val(searchKey);
            $("#submitJoinHistoryForm > input[name='stdNo']").val(stdNo);
            $("#submitJoinHistoryForm").attr("target", "submitJoinHistoryIfm");
            $("#submitJoinHistoryForm").attr("action", "/std/stdPop/submitJoinHistoryPop.do");
            $("#submitJoinHistoryForm").submit();
            $('#submitJoinHistoryModal').modal('show');

            $("#submitJoinHistoryForm > input[name='searchKey']").val("");
            $("#submitJoinHistoryForm > input[name='stdNo']").val("");
        }
    </script>
</head>
<body class="<%=SessionInfo.getThemeMode(request)%>">
<div id="wrap" class="pusher">
    <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>

    <div id="container">
        <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>

        <!-- 본문 content 부분 -->
        <div class="content stu_section">
            <%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>

            <div class="ui form">
                <div class="layout2">
                    <!-- 타이틀 -->
                    <div id="info-item-box">
                        <script>
                            $(document).ready(function () {
                                var title1 = '<spring:message code="std.label.learn_info" />'; // 수강정보
                                var title2 = '<spring:message code="std.label.attend_status" />'; // 출석현황

                                // set location
                                setLocationBar(title1, title2);
                            });
                        </script>
                        <h2 class="page-title flex-item flex-wrap gap4 columngap16">
                            <spring:message code="std.label.attend_status" /><!-- 출석현황 -->
                        </h2>
                        <div class="button-area">
                        </div>
                    </div>

                    <!-- 영역1 -->
                    <div class="row" style="flex-wrap: nowrap;">
                        <div class="col">
                            <div class="ui segment f080">
                                <span class="mr10"><spring:message code="std.label.dept" /><!-- 학과 --> : <c:out
                                        value="${empty stdVO.deptNm ? '-' : stdVO.deptNm}"/></span>
                                <span class="mr10"><spring:message code="std.label.user_id" /><!-- 학번 --> : <c:out
                                        value="${stdVO.userId}"/></span>
                                <span><spring:message code="std.label.name" /><!-- 이름 --> : <c:out
                                        value="${stdVO.userNm}"/></span>
                            </div>

                            <div class="flex">
                                <h3 class="mb10">•&nbsp;
                                    <spring:message code="lesson.label.study.status" /><!-- 학습현황 --></h3>
                                <div class="flex-left-auto flex pb5" style="align-items: flex-end;">
                                    <div class="flex-item">
                                        <i class="ico icon-solid-circle fcBlue"></i>
                                        <spring:message code="std.label.attend" /><!-- 출석 -->
                                    </div>
                                    <div class="flex-item">
                                        <i class="ico icon-triangle fcYellow"></i>
                                        <spring:message code="std.label.late" /><!-- 지각 -->
                                    </div>
                                    <div class="flex-item">
                                        <i class="ico icon-cross fcRed"></i>
                                        <spring:message code="std.label.noattend" /><!-- 결석 -->
                                    </div>
                                </div>
                            </div>

                            <table class="tbl tablet">
                                <caption class="hide"><spring:message code="lesson.label.study.status"/></caption>
                                <thead>
                                <tr>
                                    <c:forEach items="${listLessonSchedule}" var="row">
                                        <th scope="col" class="p5"><c:out value="${row.lessonScheduleOrder}"/></th>
                                    </c:forEach>
                                    <th scope="col" class="p5"><spring:message code="std.label.attend" /><!-- 출석 -->/
                                        <spring:message code="std.label.late" /><!-- 지각 --> /
                                        <spring:message code="std.label.noattend" /><!-- 결석 --></th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <c:forEach items="${listLessonSchedule}" var="row">
                                        <td class="w60" class="p5" data-title="${row.lessonScheduleOrder}주차"
                                            data-lesson-schedule-id="<c:out value="${row.lessonScheduleId}" />"
                                            data-start-dt-yn="<c:out value="${row.startDtYn}" />"
                                            data-end-dt-yn="<c:out value="${row.endDtYn}" />"
                                            data-wek-clsf-gbn="<c:out value="${row.wekClsfGbn}" />"
                                            data-prgr-video-cnt="<c:out value="${row.prgrVideoCnt}" />"></td>
                                    </c:forEach>
                                    <td class="w250"
                                        data-title="<spring:message code="std.label.attend" />/<spring:message code="std.label.late" />/<spring:message code="std.label.noattend" />">
                                        <div class="flex-item-center">
                                            <span class="ui blue circular label" id="endCompleteCntText">-</span>
                                            <span class="ui yellow circular label" id="endLateCntText">-</span>
                                            <span class="ui red circular label" id="endNostudyCntText">-</span>
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>

                            <h3 class="mb10 mt10">•&nbsp;
                                <spring:message code="std.label.lesson_cnt_join_status" /><!-- 학습요소 참여현황 --></h3>
                            <table class="table type2">
                                <caption class="hide"><spring:message
                                        code="std.label.lesson_cnt_join_status"/></caption>
                                <thead>
                                <tr>
                                    <th scope="col" class="tc p0"><spring:message code="std.label.asmnt" /><!-- 과제 -->
                                        <br/>(<spring:message code="std.label.submit" /><!-- 제출 --> /
                                        <spring:message code="std.label.total" /><!-- 전체 --> )
                                    </th>
                                    <th scope="col" class="tc p0"><spring:message code="std.label.forum" /><!-- 토론 -->
                                        <br/>(<spring:message code="std.label.submit" /><!-- 제출 --> /
                                        <spring:message code="std.label.total" /><!-- 전체 --> )
                                    </th>
                                    <th scope="col" class="tc p0"><spring:message code="std.label.quiz" /><!-- 퀴즈 -->
                                        <br/>(<spring:message code="std.label.submit" /><!-- 제출 --> /
                                        <spring:message code="std.label.total" /><!-- 전체 --> )
                                    </th>
                                    <th scope="col" class="tc p0"><spring:message code="std.label.resch" /><!-- 설문 -->
                                        <br/>(<spring:message code="std.label.submit" /><!-- 제출 --> /
                                        <spring:message code="std.label.total" /><!-- 전체 --> )
                                    </th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <td class="fweb tc"><a href="javascript:void(0)"
                                                           onclick="submitJoinHistoryModal('<c:out
                                                                   value="${stdVO.stdNo}"/>', 'ASMNT')"
                                                           class="fcBlue"><span id="asmntJoinCnt">-</span>/<span
                                            id="asmntCnt">-</span></a></td>
                                    <td class="fweb tc"><a href="javascript:void(0)"
                                                           onclick="submitJoinHistoryModal('<c:out
                                                                   value="${stdVO.stdNo}"/>', 'FORUM')"
                                                           class="fcBlue"><span id="forumJoinCnt">-</span>/<span
                                            id="forumCnt">-</span></a></td>
                                    <td class="fweb tc"><a href="javascript:void(0)"
                                                           onclick="submitJoinHistoryModal('<c:out
                                                                   value="${stdVO.stdNo}"/>', 'QUIZ')"
                                                           class="fcBlue"><span id="quizJoinCnt">-</span>/<span
                                            id="quizCnt">-</span></a></td>
                                    <td class="fweb tc"><a href="javascript:void(0)"
                                                           onclick="submitJoinHistoryModal('<c:out
                                                                   value="${stdVO.stdNo}"/>', 'RESCH')"
                                                           class="fcBlue"><span id="reschJoinCnt">-</span>/<span
                                            id="reschCnt">-</span></a></td>
                                </tr>
                                </tbody>
                            </table>

                            <!-- 3. 강의실 접속 현황 -->
                            <div class="ui segment mt5">
                                <div class="flex">
                                    <spring:message code="std.label.class_enter_status" /><!-- 강의실 접속 현황 -->
                                    <div class="flex ml10">
                                        <button type="button" class="ui button small basic m0"
                                                onclick="changeEnterStatusMonth('left')" id="monthLeftBtn"
                                                <c:if test="${nowMonth eq 1}">disabled="disabled"</c:if>><i
                                                class="xi-angle-left"></i></button>
                                        <label for="monthText" class="hide">Month</label>
                                        <input type="text"
                                               value="<c:out value="${nowMonth}" /><spring:message code="std.label.month" />"
                                               class="w50 tc" readonly="readonly" id="monthText"/>
                                        <button type="button" class="ui button small basic"
                                                onclick="changeEnterStatusMonth('right')" id="monthRightBtn"
                                                disabled="disabled"><i class="xi-angle-right"></i></button>
                                    </div>
                                </div>
                                <div class="ui divider mt5"></div>
                                <canvas id="lineChart" height="80"></canvas>
                            </div>

                            <!-- 4. 강의실 활동 기록 -->
                            <div class="ui segment mt5">
                                <spring:message code="std.label.class_activity_history" /><!-- 강의실 활동 기록 -->
                                <div class="ui divider mt5"></div>
                                <!-- 검색조건 -->
                                <div class="option-content mb10">
                                    <div class="select_area">
                                        <a href="javascript:void(0)" onclick="downExcel()" class="ui basic button">
                                            <spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></a>
                                        <label for="listScale" class="hide">list scale</label>
                                        <select class="ui dropdown list-num" id="listScale" onchange="listPaging(1)">
                                            <option value="10">10</option>
                                            <option value="20">20</option>
                                            <option value="50">50</option>
                                            <option value="100">100</option>
                                        </select>
                                    </div>
                                </div>
                                <table id="enterStatusListTable" class="table type2" data-sorting="false"
                                       data-paging="false"
                                       data-empty="<spring:message code="common.content.not_found" />">
                                    <caption class="hide"><spring:message
                                            code="std.label.class_activity_history"/></caption>
                                    <thead>
                                    <tr>
                                        <th scope="col" data-type="number" class="num">
                                            <spring:message code="main.common.number.no" /><!-- NO. --></th>
                                        <th scope="col"><spring:message code="std.label.date_time" /><!-- 일시 --></th>
                                        <th scope="col">
                                            <spring:message code="std.label.activity_content" /><!-- 활동 내용 --></th>
                                        <th scope="col" data-breakpoints="xs">
                                            <spring:message code="std.label.access_device" /><!-- 접근 장비 --></th>
                                        <th scope="col" data-breakpoints="xs">
                                            <spring:message code="user.title.manage.userinfo.conn.ip" /><!-- 접속 IP --></th>
                                    </tr>
                                    </thead>
                                    <tbody id="enterStatusList">
                                    </tbody>
                                </table>
                                <div id="paging" class="paging"></div>
                            </div>
                        </div><!-- //col -->
                    </div><!-- //row -->

                </div><!-- //layout2 -->
            </div><!-- //ui form -->
        </div><!-- //content stu_section -->

        <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
    </div><!-- //container -->

</div><!-- //wrap -->

<!-- 주차별 학습현황 상세 팝업 -->
<%--
<form id="studyStatusByWeekForm" name="studyStatusByWeekForm" method="post">
    <input type="hidden" name="crsCreCd" value="<c:out value="${vo.crsCreCd}" />" />
    <input type="hidden" name="lessonScheduleId" value="" />
    <input type="hidden" name="stdNo" />
</form>
<div class="modal fade in" id="studyStatusByWeekModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="std.label.study_status_detail_week" />" aria-hidden="false" style="display: none; padding-right: 17px;">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="asmt.button.close" />">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title"><spring:message code="std.label.study_status_detail_week" /><!-- 주차별 학습현황 상세 --></h4>
            </div>
            <div class="modal-body">
                <iframe src="" width="100%" id="studyStatusByWeekIfm" name="studyStatusByWeekIfm"></iframe>
            </div>
        </div>
    </div>
</div>
 --%>

<!-- 제출/참여 이력 팝업 -->
<form id="submitJoinHistoryForm" name="submitJoinHistoryForm" method="post">
    <input type="hidden" name="crsCreCd" value="<c:out value="${vo.crsCreCd}" />"/>
    <input type="hidden" name="stdNo"/>
    <input type="hidden" name="searchKey"/>
</form>
<div class="modal fade in" id="submitJoinHistoryModal" tabindex="-1" role="dialog"
     aria-labelledby="<spring:message code="std.label.submit_join_history" />" aria-hidden="false"
     style="display: none; padding-right: 17px;">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"
                        aria-label="<spring:message code="common.button.close" />">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title"><spring:message code="std.label.submit_join_history" /><!-- 제출/참여 이력 --></h4>
            </div>
            <div class="modal-body">
                <iframe src="" width="100%" id="submitJoinHistoryIfm" name="submitJoinHistoryIfm"
                        title="<spring:message code="std.label.submit_join_history" />"></iframe>
            </div>
        </div>
    </div>
</div>
<script>
    $('iframe').iFrameResize();
    window.closeModal = function () {
        $('.modal').modal('hide');
    };
</script>
</body>