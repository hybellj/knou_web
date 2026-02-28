<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<!-- <link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" /> -->
<link rel="stylesheet" type="text/css" href="/webdoc/css/main_default.css?v=3"/>

<style>
    .inScore {
        padding-left: 0 !important;
        padding-right: 3px !important;
        text-align: right !important;
    }

    .table.type2 {
        min-width: 1000px !important;
    }

    /* .footable.type2 .footable-header th {
    padding: 4px 4px;
} */
    i.right {
        margin-right: 0;
        width: 1em;
    }

    /* .footable.type2 {
    border-spacing: 0px 3px;
}
.footable.type2 tbody tr > td {
    padding: 3px 5px;
} */

    .step[class*="bc"] .table tbody tr:nth-child(10n-9), .step[class*="bc"] .table tbody tr:nth-child(10n-8), .step[class*="bc"] .table tbody tr:nth-child(10n-7), .step[class*="bc"] .table tbody tr:nth-child(10n-6), .step[class*="bc"] .table tbody tr:nth-child(10n-5) {
        background-color: #e4ecff;
    }

    .ui.ordered.steps .step:before {
        font-size: 2em;
    }

    .ui.steps .step {
        padding: 1.14285714em 1.1em;
        line-height: 1.3em;
    }

    .footable.type2 .footable-header th {
        color: #475a81;
        border-top: 1px solid #d9e4eb !important;
        border-bottom: 1px solid #d9e4eb !important;
        background: #f5f9fb;
    }

    .ui.selection.dropdown.visible, .ui.selection.dropdown.active {
        z-index: 2000;
    }

    .scoreTable {
        max-height: 470px;
    }

    @media all and (max-height: 800px) {
        .scoreTable {
            max-height: 310px;
        }
    }
</style>
<script type="text/javascript">
    var SEARCH_OBJ;

    $(function () {
        listCreCrs();

        $("#graphDiv").hide();

        //조회, 미평가, 결시원승인, 결시원신청
        $("#searchBtn, #btnZero, #btnApprove, #btnApplicate, #btnReExam, #btnF").on("click", function () {
            onSearch($(this).attr("id"));
        });


        //이전화면으로
        /* $("#btnPrev").on("click", function(){
		if($("#scoreStatus").val() == "2"){
			updateScoreStatus("1");
		} else if($("#scoreStatus").val() == "3"){
			//updateScoreStatus("2");
		}
	}); */

        //일괄평가
        /* $("#btnChgAllEvl").on("click", function(){
		onAllEvlModal();
	}); */

        //저장
        $("#btnSave").on("click", function () {
            checkJobSch().done(function () {
                onSave();
            });
        });

        //성적환산
        $("#btnScoreCal").on("click", function () {
            if ($("#scoreStatus").val() == "3") {
                onScoreCal();
            } else {
                checkJobSch().done(function () {
                    onAllEvlModal();
                });
            }
        });

        if ($("#openYn").val() == "Y") {
            $("#openYn").prop("checked", true);
        } else {
            $("#openYn").prop("checked", false);
        }

        //공개여부
        $("#openYn").on("change", function () {
            onOpenYn(this);
        });

        //엑셀다운로드
        $("#btnScoreOverallExcel").on("click", function () {
            onScoreOverAllExcelDown();
        });

        //초기화
        $("#btnScoreCalInit").on("click", function () {
            checkJobSch().done(function () {
                onScoreCalInit();
            });
        });
    });

    //운영과목 리스트
    function listCreCrs() {
        var url = "/score/scoreOverall/selectOverallMainList.do";
        var data = {
            creYear: $("#creYear").val()
            , creTerm: $("#creTerm").val()
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnList = data.returnList || [];
                var html = "";

                returnList.forEach(function (v, i) {
                    var deptNm = v.deptNm != null ? v.deptNm : '-';
                    var userId = v.userId != null ? v.userId : '-';
                    var credit = v.credit != null ? v.credit * 1 : '-';
                    var compDvNm = v.compDvNm != null ? v.compDvNm : '-';

                    var convert = '<spring:message code="score.label.conversion" /><spring:message code="seminar.label.webcam.start" />'; // 성적환산 시작
                    var convertComplete = '<spring:message code="score.label.conversion" /><spring:message code="common.label.finish" />'; // 성적환산 완료
                    var statusNm = v.scoreStatus == "2" ? convert : convertComplete;

                    var scoreEvalType = v.scoreEvalType;
                    var scoreEvalTypeNm = '-';
                    var scoreEvalApplyNm = '-';

                    if (scoreEvalType) {
                        if (scoreEvalType == "RELATIVE") {
                            scoreEvalTypeNm = '<spring:message code="score.label.relative" />'; // 상대평가
                            scoreEvalApplyNm = '<spring:message code="score.label.grade" />'; // 등급
                        } else if (scoreEvalType == "ABSOLUTE") {
                            scoreEvalTypeNm = '<spring:message code="score.label.absolute" />'; // 절대평가
                            scoreEvalApplyNm = '<spring:message code="score.label.grade" />'; // 등급
                        } else if (scoreEvalType == "PF") {
                            scoreEvalTypeNm = '<spring:message code="score.label.absolute" />'; // 절대평가
                            scoreEvalApplyNm = 'P/F';
                        }
                    }

                    html += '<tr class="crsList" data-crsCreCd="' + v.crsCreCd + '" data-uniCd="' + v.uniCd + '" >';
                    html += '	<td class="tc">' + (i + 1) + '</td>';
                    html += '	<td class="tc">' + v.orgNm + '</td>';
                    html += '	<td class="tc">' + deptNm + '</td>';
                    html += '	<td class="tc">' + v.crsCd + '</td>';
                    html += '	<td class="tc">' + v.declsNo + '</td>';
                    html += '	<td class="">' + v.crsCreNm + '</td>';
                    html += '	<td class="tc">' + credit + '</td>';
                    html += '	<td class="tc">' + v.totStdCnt + '</td>';
                    html += '	<td class="tc">' + scoreEvalTypeNm + '</td>';
                    html += '	<td class="tc">' + scoreEvalApplyNm + '</td>';
                    html += '	<td class="tc">' + statusNm + '</td>';
                    html += '</tr>';
                });

                $("#totCrsCnt").text(returnList.length);
                $("#creCrsTbody").empty().html(html);
                $("#creCrsTable").footable();
                $("#scoreAllListDiv").css("display", "none");

                $("#creCrsTbody > tr").on("click", function () {
                    $("#sCrsCreCd").val($(this).attr("data-crsCreCd"));
                    $("#sUniCd").val($(this).attr("data-uniCd"));
                    //console.log($("#sCrsCreCd").val());
                    onAbsentSearch();
                    onSearch();
                });

                $("#creCrsTable").parent().removeClass("scoreTable").addClass("scoreTable");
                $("#creCrsTbody > tr").css("cursor", "pointer");
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 에러가 발생했습니다! */
            alert("<spring:message code='fail.common.msg' />");
        });
    }

    function onAbsentSearch() {
        var url = "/score/scoreOverall/selectAbsentInfo.do";
        var param = {
            crsCreCd: $("#sCrsCreCd").val()
        };

        ajaxCall(url, param, function (data) {
            // 평가점수가져오기 상태
            $("#btnScoreCalInitStatus").removeClass("fcBlue").removeClass("fcRed")
            $("#btnScoreCalInitStatus").html("");

            // 성적환산 상태
            $("#btnScoreCalStatus").removeClass("fcBlue").removeClass("fcRed")
            $("#btnScoreCalStatus").html("");

            if (data.result > 0) {
                var returnVO = data.returnVO;
                var scoreStatus = returnVO.scoreStatus;
                var initDttm = returnVO.initDttm;
                var calDttm = returnVO.calDttm;
                var absentApproveCnt = 1 * returnVO.m2 + 1 * returnVO.l2;
                var absentApplicateCnt = 1 * returnVO.m1 + 1 * returnVO.l1;
                var absentInfoZeroCnt = returnVO.zeroCnt;
                var reExamCnt = returnVO.reExamCnt;
                var fCnt = returnVO.fCnt;

                if (scoreStatus == "2" || scoreStatus == "3") {
                    var initDttm = initDttm;
                    var initDttmFmt = "";
                    if (initDttm != null) {
                        initDttmFmt = initDttm.length == 14 ? initDttm.substring(0, 4) + '.' + initDttm.substring(4, 6) + '.' + initDttm.substring(6, 8) + ' ' + initDttm.substring(8, 10) + ':' + initDttm.substring(10, 12) : initDttm;
                    }

                    $("#btnScoreCalInitStatus").html('(<spring:message code="score.label.excute" /> : ' + initDttmFmt + ')').addClass("fcBlue"); // 실행

                    if (scoreStatus == "3") {
                        var calDttm = calDttm;
                        var calDttmFmt = calDttm.length == 14 ? calDttm.substring(0, 4) + '.' + calDttm.substring(4, 6) + '.' + calDttm.substring(6, 8) + ' ' + calDttm.substring(8, 10) + ':' + calDttm.substring(10, 12) : calDttm;

                        $("#btnScoreCalStatus").html('(<spring:message code="score.label.excute" /> : ' + calDttmFmt + ')').addClass("fcBlue"); // 실행
                    } else {
                        $("#btnScoreCalStatus").html('(<spring:message code="score.label.unexcute" />)').addClass("fcRed"); // 미실행
                    }
                } else {
                    $("#btnScoreCalInitStatus").html('(<spring:message code="score.label.unexcute" />)').addClass("fcRed"); // 미실행
                    //$("#btnScoreCalStatus").html('(<spring:message code="score.label.unexcute" />)').addClass("fcRed"); // 미실행
                }

                //$("#absentInfoM1").html(data.m1);
                //$("#absentInfoM2").html(data.m2);
                //$("#absentInfoL1").html(data.l1);
                //$("#absentInfoL2").html(data.l2);
                $("#absentApproveCnt").html(absentApproveCnt);
                $("#absentApplicateCnt").html(absentApplicateCnt);
                $("#absentInfoZeroCnt").html(absentInfoZeroCnt);
                $("#reExamCnt").html(reExamCnt);
                $("#fCnt").html(fCnt);
            } else {
                //$("#absentInfoM1").html("0");
                //$("#absentInfoM2").html("0");
                //$("#absentInfoL1").html("0");
                //$("#absentInfoL2").html("0");
                alert(data.message);
                $("#absentApproveCnt").html("0");
                $("#absentApplicateCnt").html("0");
                $("#absentInfoZeroCnt").html("0");
                $("#reExamCnt").html("0");
                $("#fCnt").html("0");
            }
        }, function (xhr, status, error) {
            /* 에러가 발생했습니다! */
            alert("<spring:message code='fail.common.msg' />");
        }, true);
    }

    function onScoreCalInit() {
        var scoreStatus = $("#scoreStatus").val();

        if (scoreStatus == "2" || scoreStatus == "3") {
            // 기존 저장된 성적이 초기화됩니다. 평가점수를 가져오시겠습니까?
            if (!confirm('<spring:message code="score.confirm.select.msg1" />\r\n<spring:message code="score.confirm.select.msg2" />')) return false;
        }

        ajaxCall("/score/scoreOverall/updateOverallScoreInit.do", {crsCreCd: $("#sCrsCreCd").val()}, function (data) {
            if (data.result > 0) {
                // location.reload();
                onAbsentSearch();
                onSearch();
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            // 에러가 발생했습니다!
            alert("<spring:message code='fail.common.msg' />");
        }, true);
    }

    function onScoreOverAllExcelDown() {
        if (!SEARCH_OBJ) return;
        var sortUserIdList = [];

        $.each($("[data-sort-user-no]"), function () {
            var userId = $(this).data("sortUserId");

            sortUserIdList.push(userId);
        });

        var excelGrid = {
            colModel: [
                {label: '<spring:message code="common.number.no" />', name: 'lineNo', align: 'right', width: '1000'} // No.
                , {label: "<spring:message code="common.dept_name" />", name: 'deptNm', align: 'left', width: '8000'} // 학과
                , {
                    label: "<spring:message code="common.label.student.number" />",
                    name: 'userId',
                    align: 'center',
                    width: '3000'
                } // 학번
                , {
                    label: "<spring:message code="common.label.userdept.grade" />",
                    name: 'hy',
                    align: 'center',
                    width: '1000'
                } // 학년
                , {
                    label: "<spring:message code="exam.label.academic.status" />",
                    name: 'schregGbn',
                    align: 'center',
                    width: '3000'
                } // 학적상태
                , {
                    label: "<spring:message code="filemgr.label.userauth.usernm" />",
                    name: 'userNm',
                    align: 'left',
                    width: '3000'
                } // 이름
            ]
        };

        var parentHeaderRowColIndex = excelGrid.colModel.length;
        if ((ratioArr || []).length > 0) {
            excelGrid.parentHeaderRowColspan = [];
        }

        var label;
        var labelScore = "<spring:message code='score.label.acquired.score' />"; // 취득점수
        var labelScoreAvg = "<spring:message code='score.label.calculation.score' />"; // 산출점수
        $.each(ratioArr, function (i, o) {
            if (o == "middleTestScore") {
                // 중간고사
                label = "<spring:message code='forum.label.type.exam.M' />(" + middleTestHead + "%)";
                excelGrid.parentHeaderRowColspan.push({
                    label: label,
                    firstCol: parentHeaderRowColIndex++,
                    lastCol: parentHeaderRowColIndex++
                });
                excelGrid.colModel.push({
                    label: labelScore,
                    name: "middleTestScore",
                    align: "right",
                    width: "3000",
                    formatter: 'number',
                    formatOptions: {pattern: '#,###.##'}
                });
                excelGrid.colModel.push({
                    label: labelScoreAvg,
                    name: "middleTestScoreAvg",
                    align: "right",
                    width: "3000",
                    formatter: 'number',
                    formatOptions: {pattern: '#,###.##'}
                });
            } else if (o == "lastTestScore") {
                2
                // 기말고사
                label = "<spring:message code='forum.label.type.exam.L' />(" + lastTestHead + "%)";
                excelGrid.parentHeaderRowColspan.push({
                    label: label,
                    firstCol: parentHeaderRowColIndex++,
                    lastCol: parentHeaderRowColIndex++
                });
                excelGrid.colModel.push({
                    label: labelScore,
                    name: "lastTestScore",
                    align: "right",
                    width: "3000",
                    formatter: 'number',
                    formatOptions: {pattern: '#,###.##'}
                });
                excelGrid.colModel.push({
                    label: labelScoreAvg,
                    name: "lastTestScoreAvg",
                    align: "right",
                    width: "3000",
                    formatter: 'number',
                    formatOptions: {pattern: '#,###.##'}
                });
            } else if (o == "testScore") {
                // 수시평가
                label = "<spring:message code='crs.label.nomal_exam' />(" + testHead + "%)";
                excelGrid.parentHeaderRowColspan.push({
                    label: label,
                    firstCol: parentHeaderRowColIndex++,
                    lastCol: parentHeaderRowColIndex++
                });
                excelGrid.colModel.push({
                    label: labelScore,
                    name: "testScore",
                    align: "right",
                    width: "3000",
                    formatter: 'number',
                    formatOptions: {pattern: '#,###.##'}
                });
                excelGrid.colModel.push({
                    label: labelScoreAvg,
                    name: "testScoreAvg",
                    align: "right",
                    width: "3000",
                    formatter: 'number',
                    formatOptions: {pattern: '#,###.##'}
                });
            } else if (o == "lessonScore") {
                // 출석/강의
                label = "<spring:message code='crs.label.attend' />/<spring:message code='dashboard.lesson' />(" + lessonHead + "%)";
                excelGrid.parentHeaderRowColspan.push({
                    label: label,
                    firstCol: parentHeaderRowColIndex++,
                    lastCol: parentHeaderRowColIndex++
                });
                excelGrid.colModel.push({
                    label: labelScore,
                    name: "lessonScore",
                    align: "right",
                    width: "3000",
                    formatter: 'number',
                    formatOptions: {pattern: '#,###.##'}
                });
                excelGrid.colModel.push({
                    label: labelScoreAvg,
                    name: "lessonScoreAvg",
                    align: "right",
                    width: "3000",
                    formatter: 'number',
                    formatOptions: {pattern: '#,###.##'}
                });
            } else if (o == "assignmentScore") {
                // 과제
                label = "<spring:message code='dashboard.cor.asmnt' />(" + assignmentHead + "%)";
                excelGrid.parentHeaderRowColspan.push({
                    label: label,
                    firstCol: parentHeaderRowColIndex++,
                    lastCol: parentHeaderRowColIndex++
                });
                excelGrid.colModel.push({
                    label: labelScore,
                    name: "assignmentScore",
                    align: "right",
                    width: "3000",
                    formatter: 'number',
                    formatOptions: {pattern: '#,###.##'}
                });
                excelGrid.colModel.push({
                    label: labelScoreAvg,
                    name: "assignmentScoreAvg",
                    align: "right",
                    width: "3000",
                    formatter: 'number',
                    formatOptions: {pattern: '#,###.##'}
                });
            } else if (o == "forumScore") {
                // 토론
                label = "<spring:message code='dashboard.cor.forum' />(" + forumHead + "%)";
                excelGrid.parentHeaderRowColspan.push({
                    label: label,
                    firstCol: parentHeaderRowColIndex++,
                    lastCol: parentHeaderRowColIndex++
                });
                excelGrid.colModel.push({
                    label: labelScore,
                    name: "forumScore",
                    align: "right",
                    width: "3000",
                    formatter: 'number',
                    formatOptions: {pattern: '#,###.##'}
                });
                excelGrid.colModel.push({
                    label: labelScoreAvg,
                    name: "forumScoreAvg",
                    align: "right",
                    width: "3000",
                    formatter: 'number',
                    formatOptions: {pattern: '#,###.##'}
                });
            } else if (o == "quizScore") {
                // 퀴즈
                label = "<spring:message code='dashboard.cor.quiz' />(" + quizHead + "%)";
                excelGrid.parentHeaderRowColspan.push({
                    label: label,
                    firstCol: parentHeaderRowColIndex++,
                    lastCol: parentHeaderRowColIndex++
                });
                excelGrid.colModel.push({
                    label: labelScore,
                    name: "quizScore",
                    align: "right",
                    width: "3000",
                    formatter: 'number',
                    formatOptions: {pattern: '#,###.##'}
                });
                excelGrid.colModel.push({
                    label: labelScoreAvg,
                    name: "quizScoreAvg",
                    align: "right",
                    width: "3000",
                    formatter: 'number',
                    formatOptions: {pattern: '#,###.##'}
                });
            } else if (o == "reshScore") {
                // 설문
                label = "<spring:message code='dashboard.cor.resch' />(" + reshHead + "%)";
                excelGrid.parentHeaderRowColspan.push({
                    label: label,
                    firstCol: parentHeaderRowColIndex++,
                    lastCol: parentHeaderRowColIndex++
                });
                excelGrid.colModel.push({
                    label: labelScore,
                    name: "reshScore",
                    align: "right",
                    width: "3000",
                    formatter: 'number',
                    formatOptions: {pattern: '#,###.##'}
                });
                excelGrid.colModel.push({
                    label: labelScoreAvg,
                    name: "reshScoreAvg",
                    align: "right",
                    width: "3000",
                    formatter: 'number',
                    formatOptions: {pattern: '#,###.##'}
                });
            }
        });

        excelGrid.colModel.push({
            label: "<spring:message code='common.label.production.total.point' />",
            name: 'calTotScr',
            align: 'right',
            width: '2500',
            formatter: 'number',
            formatOptions: {pattern: '#,###.##'}
        }); // 산출총점
        excelGrid.colModel.push({
            label: "<spring:message code='common.label.exchange.total.point' />",
            name: 'prvScore',
            align: 'right',
            width: '2500',
            formatter: 'number',
            formatOptions: {pattern: '#,###.##'}
        }); // 환산총점
        excelGrid.colModel.push({
            label: "<spring:message code='common.label.total.include.point.other' />",
            name: 'etcScore',
            align: 'right',
            width: '2500',
            formatter: 'number',
            formatOptions: {pattern: '#,###.##'}
        }); // 기타(가산점)
        excelGrid.colModel.push({
            label: "<spring:message code='common.label.final' /><spring:message code='common.score' />",
            name: 'totScore',
            align: 'right',
            width: '2500',
            formatter: 'number',
            formatOptions: {pattern: '#,###.##'}
        }); // 최종점수
        excelGrid.colModel.push({
            label: "<spring:message code='common.label.credit.grade' />",
            name: 'scoreGrade',
            align: 'center',
            width: '2500'
        }); // 학점등급

        $("form[name=excelForm]").remove();
        var excelForm = $('<form name="excelForm" method="post" ></form>');
        excelForm.attr("action", "/score/scoreOverall/selectScoreOverAllExcelDown.do");
        excelForm.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: SEARCH_OBJ.crsCreCd}));
        excelForm.append($('<input/>', {type: 'hidden', name: 'searchValue', value: SEARCH_OBJ.searchValue}));
        excelForm.append($('<input/>', {type: 'hidden', name: 'SearchTypeExcel', value: SEARCH_OBJ.searchType}));
        excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', value: JSON.stringify(excelGrid)}));
        sortUserIdList.forEach(function (userId, i) {
            excelForm.append($('<input/>', {type: 'hidden', name: 'sortUserIds', value: userId}));
        });
        excelForm.appendTo('body');
        excelForm.submit();
    }

    function onOpenYn(obj) {
        var openYnTxt = "";
        if ($(obj).is(":checked")) {
            $(obj).val("Y");
            openYnTxt = "<spring:message code='message.open' />";		// 공개
        } else {
            $(obj).val("N");
            openYnTxt = "<spring:message code='message.private' />";	//비공개
        }

        ajaxCall("/score/scoreOverall/updateOverallScoreOpenYn.do", {
            openYn: $(obj).val(),
            crsCreCd: $("#sCrsCreCd").val()
        }, function (data) {
            if (data.result > 0) {
                /* 처리가 되었습니다. */
                alert(openYnTxt + "<spring:message code='score.label.ect.eval.oper.msg17' />");
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 에러가 발생했습니다! */
            alert("<spring:message code='fail.common.msg' />");
        }, true);
    }

    //오른쪽 그리드 및 그래프 조회
    function onOverallGridCase(val) {
        if (val == "select") {
            $("#graphDiv").hide();
            return;
        }

        var graphData = {
            selectType: val
            , crsCreCd: $("#sCrsCreCd").val()
        }

        ajaxCall("/score/scoreOverall/selectOverallGridCase.do", graphData, function (data) {
            if (data.result > 0) {

                var dataVo = data.returnVO;

                $("#gridCol1").html(dataVo.avgScore);
                $("#gridCol2").html(dataVo.avg10Score);
                $("#gridCol3").html(dataVo.maxScore);
                $("#gridCol4").html(dataVo.minScore);
                $("#gridCol5").html(dataVo.totStdCnt);

                $("#graphTotCnt").html(dataVo.totStdCnt);

                $("#graphDiv").show();

                var cTitle = "";
                /* "평균", "상위10%평균", "최고점수", "최저점수" */
                var cLabel = ["<spring:message code='exam.label.avg' />", "<spring:message code='exam.label.avg.upper.10' />", "<spring:message code='forum.label.max.score' />", "<spring:message code='forum.label.min.score' />"];
                var cData = [dataVo.avgScore, dataVo.avg10Score, dataVo.maxScore, dataVo.minScore];

                var ctx = document.getElementById("barChart");
                var myChart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: cLabel,
                        datasets: [{
                            data: cData,
                            backgroundColor: [
                                'rgba(75, 192, 192, .6)',
                                'rgba(54, 162, 235, .6)',
                                'rgba(255, 99, 132, .6)'
                            ],
                            borderWidth: 1
                        }]
                    },
                    options: {
                        events: false,
                        showTooltips: false,
                        maintainAspectRatio: false,
                        title: {
                            display: true,
                            text: cTitle,
                            fontSize: 14,
                            fontColor: "#666",
                        },
                        animation: {
                            duration: 1000,
                            onComplete: function () {
                                var ctx = this.chart.ctx;
                                ctx.font = Chart.helpers.fontString(Chart.defaults.global.defaultFontSize, 'normal', Chart.defaults.global.defaultFontFamily);
                                ctx.fillStyle = this.chart.config.options.defaultFontColor;
                                ctx.textAlign = 'center';
                                ctx.textBaseline = 'bottom';
                                this.data.datasets.forEach(function (dataset) {
                                    for (var i = 0; i < dataset.data.length; i++) {
                                        var model = dataset._meta[Object.keys(dataset._meta)[0]].data[i]._model;
                                        ctx.fillStyle = '#fff';
                                        ctx.fillText(dataset.data[i], model.x, model.y + 20);
                                    }
                                });
                            }
                        },
                        scales: {
                            yAxes: [{
                                ticks: {
                                    min: 0,
                                    max: 100,
                                    stepSize: 20,
                                    callback: function (value) {
                                        return value + "<spring:message code='exam.label.score.point' />"
                                    }	// 점
                                },
                                scaleLabel: {
                                    display: true
                                }
                            }],
                            xAxes: [{
                                barPercentage: 0.6
                            }]
                        },
                        legend: {
                            display: false
                        }
                    }
                });
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 에러가 발생했습니다! */
            alert("<spring:message code='fail.common.msg' />");
        }, true);
    }

    //그래프 조회
    function onOverallGraph(val) {
        if (val == "select") {
            return;
        }

        var graphData = {
            selectType: val
            , crsCreCd: $("#sCrsCreCd").val()
        }

        var url = "";
        if (val == "all") {
            url = "/score/scoreOverall/selectOverallGraphListByGrade.do";
        } else {
            url = "/score/scoreOverall/selectOverallGraphList.do";
        }

        ajaxCall(url, graphData, function (data) {
            if (data.result > 0) {

                $("#graphSelect").dropdown('set value', val);

                var list = data.returnList || [];

                if (list.length > 0) {
                    var stareCnt = 0;
                    var labelsArray = new Array();
                    var dataArray = new Array();
                    var colorArray = new Array();

                    list.forEach(function (v, i) {
                        stareCnt += Number(v.cnt);
                        labelsArray.push(v.label);
                        dataArray.push(v.cnt);
                        colorArray.push('rgba(54, 162, 235, .6)');
                    });
                    var ctx = document.getElementById("horiBarChart");
                    var myChart = new Chart(ctx, {
                        type: 'horizontalBar',
                        data: {
                            labels: labelsArray,
                            datasets: [{
                                backgroundColor: colorArray,
                                borderWidth: 1,
                                data: dataArray
                            }]
                        },
                        options: {
                            events: false,
                            showTooltips: false,
                            maintainAspectRatio: false,
                            title: {
                                display: true,
                                text: "<spring:message code='exam.label.distribution.ratio' /> (%)",	// 분포도비율
                                fontSize: 14,
                                fontColor: "#666",
                            },
                            animation: {
                                duration: 1000,
                                onComplete: function () {
                                    var ctx = this.chart.ctx;
                                    ctx.font = Chart.helpers.fontString(Chart.defaults.global.defaultFontSize, 'normal', Chart.defaults.global.defaultFontFamily);
                                    ctx.fillStyle = this.chart.config.options.defaultFontColor;
                                    ctx.textAlign = 'center';
                                    ctx.textBaseline = 'bottom';
                                    this.data.datasets.forEach(function (dataset) {
                                        for (var i = 0; i < dataset.data.length; i++) {
                                            var model = dataset._meta[Object.keys(dataset._meta)[0]].data[i]._model;
                                            var persent = (dataset.data[i] / stareCnt * 100).toFixed(2);
                                            persent = isFinite(persent) ? persent : 0;
                                            ctx.fillStyle = '#000';
                                            ctx.fillText(dataset.data[i] + "<spring:message code='exam.label.nm' />(" + (1 * persent) + '%)', model.x + 38, model.y + 8);/* 명 */
                                        }
                                    });
                                }
                            },
                            scales: {
                                yAxes: [{
                                    barPercentage: 0.8,
                                    scaleLabel: {
                                        display: true
                                    }
                                }],
                                xAxes: [{
                                    ticks: {
                                        min: 0,
                                        max: 100,
                                        stepSize: 10,
                                        callback: function (value) {
                                            return value
                                        }
                                    }
                                }]
                            },
                            legend: {
                                display: false
                            }
                        }
                    });
                }
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 에러가 발생했습니다! */
            alert("<spring:message code='fail.common.msg' />");
        }, true);
    }

    //성적환산
    function onScoreCal() {
        if ($("#scoreStatus").val() == "2") {
            chgButton("2");
            chgText("2");
            window.closeModal();
            updateScoreStatus("2");
        }

        var url = "/score/scoreOverall/selectCreCrsEval.do";
        var param = {
            crsCreCd: $("#sCrsCreCd").val()
        };

        ajaxCall(url, param, function (data) {
            if (data.result > 0) {
                var returnVO = data.returnVO;
                var scoreEvalType = returnVO.scoreEvalType;

                if (scoreEvalType == "RELATIVE") {
                    //상대평가 팝업
                    $("#modalTitleId").html("<spring:message code='score.label.evaluation.stand' />");	// 상대평가환산기준
                    $("#modalScoreCalForm [name=crsCreCd]").val($("#sCrsCreCd").val());
                    $("#modalScoreCalForm").attr("target", "modalScoreCalIfm");
                    $("#modalScoreCalForm").attr("action", "/score/scoreOverall/scoreOverallScoreCalRelativePopup.do");
                    $("#modalScoreCalForm").submit();
                    $("#modalScoreCal").modal('show');
                } else if (scoreEvalType == "ABSOLUTE") {
                    checkJobSch().done(function () {
                        //절대평가 팝업
                        $("#modalTitleId").html("<spring:message code='score.label.absolute.stand' />");	// 절대평가 환산 기준
                        $("#modalScoreCalForm [name=crsCreCd]").val($("#sCrsCreCd").val());
                        $("#modalScoreCalForm").attr("target", "modalScoreCalIfm");
                        $("#modalScoreCalForm").attr("action", "/score/scoreOverall/scoreOverallScoreCalAbsolutePopup.do");
                        $("#modalScoreCalForm").submit();
                        $("#modalScoreCal").modal('show');
                    });
                } else if (scoreEvalType == "PF") {
                    checkJobSch().done(function () {
                        //절대평가 팝업
                        $("#modalTitleId").html("P/F <spring:message code='score.label.conversion.stand' />");	// P/F 환산기준
                        $("#modalScoreCalForm [name=crsCreCd]").val($("#sCrsCreCd").val());
                        $("#modalScoreCalForm").attr("target", "modalScoreCalIfm");
                        $("#modalScoreCalForm").attr("action", "/score/scoreOverall/scoreOverallScoreCalPfPopup.do");
                        $("#modalScoreCalForm").submit();
                        $("#modalScoreCal").modal('show');
                    });
                } else {
                    alert("<spring:message code='score.errors.not.found.score.eval.type' />"); // 과목의 평가구분 정보를 찾을 수 없습니다.
                }
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            // 에러가 발생했습니다!
            alert("<spring:message code='fail.common.msg' />");
        }, true);
    }

    //저장
    function onSave() {
        if ($("input[name*=dataChk]:checked").length == 0) {
            // 변동된 내역이 없습니다.
            alert('<spring:message code="score.alert.no.changed" />');
            return;
        }

        //var chkFormData = $("#tableForm [name*=dataChk]:checked").parents("tr").find("input").serialize();
        var chkFormData = $("#tableForm").serialize();

        // 저장하시겠습니까?
        if (confirm("<spring:message code='common.save.msg'/>")) {
            ajaxCall("/score/scoreOverall/saveOverallList.do", chkFormData, function (data) {
                if (data.result > 0) {
                    /* 저장되었습니다.  */
                    alert('<spring:message code="info.regok.msg" />');
                    // location.reload();

                    clearInterval(interval);
                    onAbsentSearch();
                    onSearch();
                    /*
				if($("#scoreStatus").val() == "3") {
					try {
						// erp 테스트 데이터 전송
						saveTestScoreIgnore();
					} catch (e) {
						console.log(e);
					}
				}
				 */
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                /* 에러가 발생했습니다! */
                alert("<spring:message code='fail.common.msg' />");
            }, true);
        }
    }

    var middleTestHead, lastTestHead, testHead, lessonHead, assignmentHead, forumHead, quizHead, reshHead, etcHead = "";
    var ratioArr = new Array();
    var interval;

    //조회
    function onSearch(searchType) {
        var url = "/score/scoreOverall/selectOverallList.do";
        var param = {
            searchValue: $("#searchValue").val()
            , crsCreCd: $("#sCrsCreCd").val()
            , searchType: searchType
        };

        ajaxCall(url, param, function (data) {
            if (data.result > 0) {
                var returnList = data.returnList || [];
                ratioArr = new Array();

                var html = "";
                var totSum = 0;

                if (data.returnSubVO == null) {
                    /* 해당과목의 평가기준을 먼저 입력해주세요. */
                    alert("<spring:message code='score.label.process.msg19' />");
                    $("#scoreAllListDiv").css("display", "none");
                    return;
                } else {
                    $(".crsList").removeClass("on");
                    $(".crsList").filter("[data-crsCreCd=" + $("#sCrsCreCd").val() + "]").addClass("on");
                    $("#scoreAllListDiv").css("display", "block");
                }

                $("#listTotCnt").text(returnList.length);
                $("#totCnt").text(data.returnVO.totalCnt);

                // 전체인원 최초1번 세팅
                if (!searchType && !$("#searchValue").val()) {
                    if (!$("#totCnt").hasClass("init")) {
                        $("#totCnt").text(data.returnVO.totalCnt);
                        $("#totCnt").addClass("init")
                    }
                }

                middleTestHead = Number(data.returnSubVO && data.returnSubVO.middleTestScoreRatio);
                lastTestHead = Number(data.returnSubVO && data.returnSubVO.lastTestScoreRatio);
                testHead = Number(data.returnSubVO && data.returnSubVO.testScoreRatio);

                lessonHead = Number(data.returnSubVO && data.returnSubVO.lessonScoreRatio);
                assignmentHead = Number(data.returnSubVO && data.returnSubVO.assignmentScoreRatio);
                forumHead = Number(data.returnSubVO && data.returnSubVO.forumScoreRatio);
                quizHead = Number(data.returnSubVO && data.returnSubVO.quizScoreRatio);
                reshHead = Number(data.returnSubVO && data.returnSubVO.reshScoreRatio);

                if (middleTestHead != 0) {
                    ratioArr.push("middleTestScore");
                }
                if (lastTestHead != 0) {
                    ratioArr.push("lastTestScore");
                }
                if (testHead != 0) {
                    ratioArr.push("testScore");
                }
                if (lessonHead != 0) {
                    ratioArr.push("lessonScore");
                }
                if (assignmentHead != 0) {
                    ratioArr.push("assignmentScore");
                }
                if (forumHead != 0) {
                    ratioArr.push("forumScore");
                }
                if (quizHead != 0) {
                    ratioArr.push("quizScore");
                }
                if (reshHead != 0) {
                    ratioArr.push("reshScore");
                }

                html += "<table class='table sticky' data-sorting='true' data-paging='false' data-empty='<spring:message code='exam.common.empty' />' id='sTable'>";
                html += "<thead>";
                html += "	<tr>";
                //html += "        <th class='tc w20' data-breakpoints='' data-sortable='false'><div class='ui checkbox'><input type='checkbox' tabindex='0' id='chkAll'><label></label></div></th>";
                html += "        <th class='tc w20' data-sortable='false'></th>";
                html += "        <th class='tc' data-breakpoints='' data-sortable='false'>No</th>";
                html += "        <th class='tc wf7' data-breakpoints='xs sm md' style='min-width:150px'><spring:message code='exam.label.dept' /></th>";// 학과
                html += "        <th class='tc' data-breakpoints=''><spring:message code='exam.label.user.no' /></th>";// 학번
                html += "        <th class='tc' data-breakpoints=''><spring:message code='asmnt.label.user.grade' /></th>";// 학년
                html += "        <th class='tc' data-breakpoints=''><spring:message code='exam.label.academic.status' /></th>";// 학적상태
                html += "        <th class='tc' data-breakpoints=''><spring:message code='filemgr.label.userauth.usernm' /></th>";// 이름

                $.each(ratioArr, function (i, o) {
                    if (o == "middleTestScore") {
                        // 중간고사
                        html += "        <th class=''><spring:message code='forum.label.type.exam.M' /><br class='desktop-elem'><small>(" + middleTestHead + "%)</small></th>";
                    } else if (o == "lastTestScore") {
                        // 기말고사
                        html += "        <th class=''><spring:message code='forum.label.type.exam.L' /><br class='desktop-elem'><small>(" + lastTestHead + "%)</small></th>";
                    } else if (o == "testScore") {
                        // 수시평가
                        html += "        <th class=''><spring:message code='crs.label.nomal_exam' /><br class='desktop-elem'><small>(" + testHead + "%)</small></th>";
                    } else if (o == "lessonScore") {
                        // 출석 / 강의
                        html += "        <th class=''><spring:message code='crs.label.attend' /> / <spring:message code='dashboard.lesson' /><br class='desktop-elem'><small>(" + lessonHead + "%)</small></th>";
                    } else if (o == "assignmentScore") {
                        // 과제
                        html += "        <th class=''><spring:message code='dashboard.cor.asmnt' /><br class='desktop-elem'><small>(" + assignmentHead + "%)</small></th>";
                    } else if (o == "forumScore") {
                        // 토론
                        html += "        <th class=''><spring:message code='dashboard.cor.forum' /><br class='desktop-elem'><small>(" + forumHead + "%)</small></th>";
                    } else if (o == "quizScore") {
                        // 퀴즈
                        html += "        <th class=''><spring:message code='dashboard.cor.quiz' /><br class='desktop-elem'><small>(" + quizHead + "%)</small></th>";
                    } else if (o == "reshScore") {
                        // 설문
                        html += "        <th class=''><spring:message code='dashboard.cor.resch' /><br class='desktop-elem'><small>(" + reshHead + "%)</small></th>";
                    }
                });

                html += "        <th class='tc'>산출<br class='desktop-elem'><spring:message code='common.label.total.point' /></th>";	// 산출총점
                html += "        <th class='tc'>환산<br class='desktop-elem'><spring:message code='common.label.total.point' /></th>";	// 환산총점
                html += "        <th name='etcDataTd' class='tc' data-type='number'><spring:message code='common.label.total.include.point' /></th>";	// 가산점
                html += "        <th class='tc' data-type='number'><spring:message code='common.label.final' /><br class='desktop-elem'>점수</th>";	// 최정점수
                html += "        <th class='tc'><spring:message code='common.label.score' /><br/><spring:message code='exam.label.level' /></th>";	// 성적등급
                //html += "        <th class='tc' data-breakpoints='xs sm md lg' style='display:none'>상태</th>";
                html += "        <th class='tc'><spring:message code='score.manage.label' /></th>";	// 관리
                html += "    </tr>";
                html += "</thead>";
                html += "<tbody>";

                $.each(data.returnList, function (i, o) {
                    var lessonScore = Number(o.lessonScore) == "-1" ? "-" : Number(o.lessonScore);
                    var middleTestScore = Number(o.middleTestScore) == "-1" ? "-" : Number(o.middleTestScore);
                    var lastTestScore = Number(o.lastTestScore) == "-1" ? "-" : Number(o.lastTestScore);
                    var testScore = Number(o.testScore) == "-1" ? "-" : Number(o.testScore);
                    var assignmentScore = Number(o.assignmentScore) == "-1" ? "-" : Number(o.assignmentScore);
                    var forumScore = Number(o.forumScore) == "-1" ? "-" : Number(o.forumScore);
                    var quizScore = Number(o.quizScore) == "-1" ? "-" : Number(o.quizScore);
                    var reshScore = Number(o.reshScore) == "-1" ? "-" : Number(o.reshScore);
                    var etcScore = Number(o.etcScore);

                    var lessonScoreAvg = Number(o.lessonScoreAvg);
                    var middleTestScoreAvg = Number(o.middleTestScoreAvg);
                    var lastTestScoreAvg = Number(o.lastTestScoreAvg);
                    var testScoreAvg = Number(o.testScoreAvg);
                    var assignmentScoreAvg = Number(o.assignmentScoreAvg);
                    var forumScoreAvg = Number(o.forumScoreAvg);
                    var quizScoreAvg = Number(o.quizScoreAvg);
                    var reshScoreAvg = Number(o.reshScoreAvg);
                    var gradeSort = "0";

                    if (o.scoreStatus == "2") {
                        gradSort = "z";
                    } else if (o.scoreStatus == "3") {
                        gradeSort = o.scoreGrade;
                        if (o.scoreGrade.indexOf("+") > -1) {
                            gradeSort = o.scoreGrade.replace("+", "0");
                        } else {
                            gradeSort = o.scoreGrade + "1";
                        }
                    }

                    var calTotScr = parseFloat((lessonScoreAvg + middleTestScoreAvg + lastTestScoreAvg + testScoreAvg + assignmentScoreAvg + forumScoreAvg + quizScoreAvg + reshScoreAvg).toFixed(2));

                    calTotScr = calTotScr < 0 ? "-" : calTotScr;

                    var midTdColor = "";
                    var lastTdColor = "";

                    if (o.apprStatM) {
                        if (o.apprStatM == "APPLICATE" || o.apprStatM == "RAPPLICATE") {
                            midTdColor = "bcGreenAlpha30";
                        } else if (o.apprStatM == "APPROVE") {
                            midTdColor = "bcBlueAlpha30";
                        }
                    }

                    if (o.apprStatL) {
                        if (o.apprStatL == "APPLICATE" || o.apprStatL == "RAPPLICATE") {
                            lastTdColor = "bcGreenAlpha30";
                        } else if (o.apprStatL == "APPROVE") {
                            lastTdColor = "bcBlueAlpha30";
                        }
                    }

                    if (o.reExamYnM && o.reExamYnM == "Y") {
                        if (midTdColor == "bcGreenAlpha30") {
                            midTdColor = "bcGreenYellowAlpha30";
                        } else if (midTdColor == "bcBlueAlpha30") {
                            midTdColor = "bcBlueYellowAlpha30";
                        } else {
                            midTdColor = "bcYellowAlpha30";
                        }
                    }

                    if (o.reExamYnL && o.reExamYnL == "Y") {
                        if (lastTdColor == "bcGreenAlpha30") {
                            lastTdColor = "bcGreenYellowAlpha30";
                        } else if (lastTdColor == "bcBlueAlpha30") {
                            lastTdColor = "bcBlueYellowAlpha30";
                        } else {
                            lastTdColor = "bcYellowAlpha30";
                        }
                    }

                    html += "<tr data-sort-user-no='" + o.userId + "'>";
                    html += "    <td class='tc'><div class='ui checkbox'><input type='checkbox' readonly='readonly' name='list[" + i + "].dataChk' tabindex='0' user_id='" + o.userId + "' user_nm='" + o.userNm + "' mobile='" + o.userMobileNo + "' email='" + o.userEmail + "'><label></label></div></td>";
                    html += "    <td name='lineNo' class='tc'>" + o.lineNo + "</td>";
                    html += "    <td data-sort-value='" + o.deptNm + "'>";
                    html += "        <span class=''>" + o.deptNm + "</span>";
                    html += "    </td>";
                    html += "    <td class='word_break_none tc' data-sort-value='A" + o.userId.padEnd(12, "0") + "'>";
                    html += "        <span class=''>" + o.userId + "</span>";
                    html += "        <input type='hidden' name='list[" + i + "].stdNo' value='" + o.stdNo + "'>";
                    html += "        <input type='hidden' name='list[" + i + "].userId' value='" + o.userId + "'>";
                    html += "        <input type='hidden' name='list[" + i + "].userMobileNo' value='" + o.userMobileNo + "'>";
                    html += "        <input type='hidden' name='list[" + i + "].userEmail' value='" + o.userEmail + "'>";
                    html += "        <input type='hidden' name='list[" + i + "].lessonItemId' value='" + o.lessonItemId + "'>";
                    html += "        <input type='hidden' name='list[" + i + "].middleTestItemId' value='" + o.middleTestItemId + "'>";
                    html += "        <input type='hidden' name='list[" + i + "].lastTestItemId' value='" + o.lastTestItemId + "'>";
                    html += "        <input type='hidden' name='list[" + i + "].testItemId' value='" + o.testItemId + "'>";
                    html += "        <input type='hidden' name='list[" + i + "].assignmentItemId' value='" + o.assignmentItemId + "'>";
                    html += "        <input type='hidden' name='list[" + i + "].forumItemId' value='" + o.forumItemId + "'>";
                    html += "        <input type='hidden' name='list[" + i + "].quizItemId' value='" + o.quizItemId + "'>";
                    html += "        <input type='hidden' name='list[" + i + "].reshItemId' value='" + o.reshItemId + "'>";
                    html += "        <input type='hidden' name='list[" + i + "].rowStatus' value='N'>";
                    html += "        <i class='xi-pen-o f120' onclick=\"setMemo('" + o.stdNo + "')\" style='cursor:pointer' title='메모'></i>";
                    html += "    </td>";

                    html += "    <td class='word_break_none tc'>";
                    html += o.hy;
                    html += "    </td>";

                    html += "    <td class='word_break_none tc' data-sort-value='" + o.schregGbnCd + "'>";
                    html += o.schregGbn;
                    html += "    </td>";

                    html += "    <td class='word_break_none tc' data-sort-value='" + o.userNm + "'>";
                    html += "        <span class=''>" + o.userNm + "</span>";
                    html += "        <a href='javascript:userInfoPop(\"" + o.userId + "\")' title='학생정보보기'><i class='ico icon-info '></i></a>";
                    html += "    </td>";

                    var isNoAttendUser = false;
                    var isTestNoJoinUser = false;

                    if (o.middleTestScore <= 0 && o.lastTestScore <= 0) {
                        if (o.middleTestUseYn == "Y" && o.lastTestUseYn == "Y" && o.middleTestNoYn == "Y" && o.lastTestNoYn == "Y") {
                            isTestNoJoinUser = true;
                        } else if (o.middleTestUseYn == "Y" && o.lastTestUseYn == "N" && o.middleTestNoYn == "Y") {
                            isTestNoJoinUser = true;
                        } else if (o.middleTestUseYn == "N" && o.lastTestUseYn == "Y" && o.lastTestNoYn == "Y") {
                            isTestNoJoinUser = true;
                        }
                    }

                    $.each(ratioArr, function (j, z) {
                        if (z == "middleTestScore") {
                            var midNoEvalClass = o.midNoEvalCnt > 0 ? 'bcRedAlpha30' : '';
                            var scoreInputColor = "";
                            var scoreTextColor = "fcBlue";

                            if (isTestNoJoinUser) {
                                scoreInputColor = "fcRed";
                                scoreTextColor = "fcRed";
                            }

                            html += "    <td class='word_break_none " + midTdColor + "' data-sort-value='" + getSortScore(middleTestScore) + "'>";
                            html += "    	<span name='chgSpanText'>";
                            html += "    		" + middleTestScore + "";
                            html += "    	</span>";
                            html += "    	<div class='ui input w50' name='chgInputText'>";
                            html += "            <input type='text' name='list[" + i + "].middleTestInput' class='inScore " + midNoEvalClass + " " + scoreInputColor + "' value='" + middleTestScore + "' placeholder='0' maxlength='5' onKeyup=\"scoreValidation(this)\">";
                            html += "       </div>";
                            html += "    	<i class='right chevron icon f075 opacity5'></i>";
                            if (middleTestScore > -1) {
                                html += "    	<span class='" + scoreTextColor + "'>" + middleTestScoreAvg + "</span>";
                            } else {
                                html += "    	<a href='javascript:;' onclick='goCrsCreCtgr(\"minTest\")'><span class='" + scoreTextColor + "'>-</span></a>";
                            }
                            html += "       <input type='hidden' name='list[" + i + "].middleTestScoreAvg' value='" + middleTestScoreAvg + "' placeholder='0'>";
                            html += "    </td>";
                        } else if (z == "lastTestScore") {
                            var lastNoEvalClass = o.lastNoEvalCnt > 0 ? 'bcRedAlpha30' : '';
                            var scoreInputColor = "";
                            var scoreTextColor = "fcBlue";

                            if (isTestNoJoinUser) {
                                scoreInputColor = "fcRed";
                                scoreTextColor = "fcRed";
                            }

                            html += "    <td class='word_break_none " + lastTdColor + "' data-sort-value='" + getSortScore(lastTestScore) + "'>";
                            html += "    	<span name='chgSpanText'>";
                            html += "    		" + lastTestScore + " ";
                            html += "    	</span>";
                            html += "    	<div class='ui input w50' name='chgInputText'>";
                            html += "            <input type='text' name='list[" + i + "].lastTestInput' class='inScore " + lastNoEvalClass + " " + scoreInputColor + "' value='" + lastTestScore + "' placeholder='0' maxlength='5' onKeyup=\"scoreValidation(this)\">";
                            html += "        </div>";
                            html += "    	<i class='right chevron icon f075 opacity5'></i>";
                            if (lastTestScore > -1) {
                                html += "    	<span class='" + scoreTextColor + "'>" + lastTestScoreAvg + "</span>";
                            } else {
                                html += "    	<a href='javascript:;' onclick='goCrsCreCtgr(\"lastTest\")'><span class='" + scoreTextColor + "'>-</span></a>";
                            }
                            html += "       <input type='hidden' name='list[" + i + "].lastTestScoreAvg' value='" + lastTestScoreAvg + "' placeholder='0'>";
                            html += "    </td>";
                        } else if (z == "testScore") {
                            var testNoEvalClass = o.testNoEvalCnt > 0 ? 'bcRedAlpha30' : '';

                            html += "    <td class='word_break_none' data-sort-value='" + getSortScore(testScore) + "'>";
                            html += "    	<span name='chgSpanText'>";
                            html += "    		" + testScore + " ";
                            html += "    	</span>";
                            html += "    	<div class='ui input w50' name='chgInputText'>";
                            html += "            <input type='text' name='list[" + i + "].testInput' class='inScore " + testNoEvalClass + "' value='" + testScore + "' placeholder='0' maxlength='5' onKeyup=\"scoreValidation(this)\">";
                            html += "        </div>";
                            html += "    	<i class='right chevron icon f075 opacity5'></i>";
                            if (testScore > -1) {
                                html += "    	<span class='fcBlue'>" + testScoreAvg + "</span>";
                            } else {
                                html += "    	<a href='javascript:;' onclick='goCrsCreCtgr(\"test\")'><span class='fcBlue'>-</span></a>";
                            }
                            html += "       <input type='hidden' name='list[" + i + "].testScoreAvg' value='" + testScoreAvg + "' placeholder='0'>";
                            html += "    </td>";
                        } else if (z == "lessonScore") {
                            isNoAttendUser = lessonScore === 0 ? true : false;
                            html += "    <td class='word_break_none' data-sort-value='" + getSortScore(lessonScore) + "'>";
                            html += "    	<span name='chgSpanText'>";
                            html += "    		" + lessonScore + "";
                            html += "    	</span>";
                            html += "    	<div class='ui input w50 tr' name='chgInputText'>";
                            html += lessonScore;
                            html += "			<input type='hidden' name='list[" + i + "].lessonInput' class='inScore' value='" + lessonScore + "' placeholder='0' maxlength='5' onKeyup=\"scoreValidation(this)\" readonly='readonly' />";
                            html += "        </div>";
                            html += "    	<i class='right chevron icon f075 opacity5'></i>";

                            html += "    	<span class='fcBlue'>" + lessonScoreAvg + "</span>";
                            html += "       <input type='hidden' name='list[" + i + "].lessonScoreAvg' value='" + lessonScoreAvg + "' placeholder='0'>";
                            html += "    </td>";
                        } else if (z == "assignmentScore") {
                            var asmntNoEvalClass = o.asmntNoEvalCnt > 0 ? 'bcRedAlpha30' : '';

                            html += "    <td class='word_break_none' data-sort-value='" + getSortScore(assignmentScore) + "'>";
                            html += "    	<span name='chgSpanText'>";
                            html += "    		" + assignmentScore + "";
                            html += "    	</span>";
                            html += "    	<div class='ui input w50' name='chgInputText'>";
                            html += "            <input type='text' name='list[" + i + "].assignmentInput' class='inScore " + asmntNoEvalClass + "' value='" + assignmentScore + "' placeholder='0' maxlength='5' onKeyup=\"scoreValidation(this)\">";
                            html += "        </div>";
                            html += "    	<i class='right chevron icon f075 opacity5'></i>";
                            if (assignmentScore > -1) {
                                html += "    	<span class='fcBlue'>" + assignmentScoreAvg + "</span>";
                            } else {
                                html += "    	<a href='javascript:;' onclick='goCrsCreCtgr(\"asmt\")'><span class='fcBlue'>-</span></a>";
                            }
                            html += "       <input type='hidden' name='list[" + i + "].assignmentScoreAvg' value='" + assignmentScoreAvg + "' placeholder='0'>";
                            html += "    </td>";
                        } else if (z == "forumScore") {
                            var forumNoEvalClass = o.forumNoEvalCnt > 0 ? 'bcRedAlpha30' : '';

                            html += "    <td class='word_break_none' data-sort-value='" + getSortScore(forumScore) + "'>";
                            html += "    	<span name='chgSpanText'>";
                            html += "    		" + forumScore + "";
                            html += "    	</span>";
                            html += "    	<div class='ui input w50' name='chgInputText'>";
                            html += "            <input type='text' name='list[" + i + "].forumInput' class='inScore  " + forumNoEvalClass + "' value='" + forumScore + "' placeholder='0' maxlength='5' onKeyup=\"scoreValidation(this)\">";
                            html += "        </div>";
                            html += "    	<i class='right chevron icon f075 opacity5'></i>";
                            if (forumScore > -1) {
                                html += "    	<span class='fcBlue'>" + forumScoreAvg + "</span>";
                            } else {
                                html += "    	<a href='javascript:;' onclick='goCrsCreCtgr(\"forum\")'><span class='fcBlue'>-</span></a>";
                            }
                            html += "       <input type='hidden' name='list[" + i + "].forumScoreAvg' value='" + forumScoreAvg + "' placeholder='0'>";
                            html += "    </td>";
                        } else if (z == "quizScore") {
                            var quizNoEvalClass = o.quizNoEvalCnt > 0 ? 'bcRedAlpha30' : '';

                            html += "    <td class='word_break_none' data-sort-value='" + getSortScore(quizScore) + "'>";
                            html += "    	<span name='chgSpanText'>";
                            html += "    		" + quizScore + "";
                            html += "    	</span>";
                            html += "    	<div class='ui input w50' name='chgInputText'>";
                            html += "            <input type='text' name='list[" + i + "].quizInput' class='inScore " + quizNoEvalClass + "' value='" + quizScore + "' placeholder='0' maxlength='5' onKeyup=\"scoreValidation(this)\">";
                            html += "       </div>";
                            html += "    	<i class='right chevron icon f075 opacity5'></i>";
                            if (quizScore > -1) {
                                html += "    	<span class='fcBlue'>" + quizScoreAvg + "</span>";
                            } else {
                                html += "    	<a href='javascript:;' onclick='goCrsCreCtgr(\"quiz\")'><span class='fcBlue'>-</span></a>";
                            }
                            html += "       <input type='hidden' name='list[" + i + "].quizScoreAvg' value='" + quizScoreAvg + "' placeholder='0' >";
                            html += "    </td>";
                        } else if (z == "reshScore") {
                            var reschNoEvalClass = o.reschNoEvalCnt > 0 ? 'bcRedAlpha30' : '';

                            html += "    <td class='word_break_none' data-sort-value='" + getSortScore(reshScore) + "'>";
                            html += "    	<span name='chgSpanText'>";
                            html += "    		" + reshScore + "";
                            html += "    	</span>";
                            html += "    	<div class='ui input w50' name='chgInputText'>";
                            html += "            <input type='text' name='list[" + i + "].reshInput' class='inScore " + reschNoEvalClass + "' value='" + reshScore + "' placeholder='0' maxlength='5' onKeyup=\"scoreValidation(this)\">";
                            html += "       </div>";
                            html += "    	<i class='right chevron icon f075 opacity5'></i>";
                            if (reshScore > -1) {
                                html += "    	<span class='fcBlue'>" + reshScoreAvg + "</span>";
                            } else {
                                html += "    	<a href='javascript:;' onclick='goCrsCreCtgr(\"resh\")'><span class='fcBlue'>-</span></a>";
                            }
                            html += "       <input type='hidden' name='list[" + i + "].reshScoreAvg' value='" + reshScoreAvg + "' placeholder='0' >";
                            html += "    </td>";
                        }
                    });

                    html += "    <td class='tc' data-sort-value='" + getSortScore(calTotScr) + "'>";
                    html += "    	<span class='fcBlue'>" + calTotScr + "</span>";
                    html += "       <input type='hidden' name='list[" + i + "].finalScore' value='" + calTotScr + "' placeholder='0'>";
                    html += "    </td>";

                    html += "<td class='tc' data-sort-value='" + getSortScore(o.prvScore) + "'>";
                    if (o.scoreStatus == "2") {
                        html += "-";
                    } else if (o.scoreStatus == "3") {
                        html += "	<span name='totScoreSpan'>" + o.prvScore + "</span>";
                        if (isNoAttendUser) {
                            html += "	<div class='ui input w50 tr' name='totScoreDiv'>";
                            html += Number(o.prvScore);
                            html += "		<input type='hidden' name='list[" + i + "].totScoreData' class='inScore' value='" + o.prvScore + "' placeholder='0' maxlength='5' onKeyup=\"scoreValidation(this)\" readonly='readonly' />";
                            html += "	</div>";
                        } else {
                            html += "	<div class='ui input w50' name='totScoreDiv'>";
                            html += "		<input type='text' name='list[" + i + "].totScoreData' class='inScore' value='" + o.prvScore + "' placeholder='0' maxlength='5' onKeyup=\"scoreValidation(this)\" data-tot-score-idx='" + i + "' />";
                            html += "	</div>";
                        }
                    }
                    html += "    </td>";

                    html += "    <td name='etcDataTd' class='tc' data-sort-value='" + getSortScore(etcScore) + "'>";
                    html += "    	<span>";
                    html += "    		" + etcScore + "";
                    html += "    	</span>";
                    //html += "    	<div class='ui input w50' name='chgInputText' data-chkType='etcDiv'>";
                    //html += "            <input type='text' name='list["+i+"].etcScoreInput' value='" + etcScore + "' placeholder='0' maxlength='5' onKeyup=\"scoreValidation(this)\">";
                    //html += "       </div>";
                    html += "    </td>";

                    html += "   <td class='tc' data-sort-value='" + getSortScore(o.totScore) + "'>";
                    html += o.totScore;
                    html += "   </td>";


                    html += "    <td class='tc' data-sort-value='" + gradeSort + "' data-grade-idx='" + i + "' >"
                    if (o.scoreStatus == "2") {
                        html += "-";
                    } else if (o.scoreStatus == "3") {
                        if (o.scoreGrade == "F") {
                            html += '<span class="fcRed fweb">' + o.scoreGrade + '</span>';
                        } else {
                            html += o.scoreGrade;
                        }
                    }
                    html += "    </td>";

                    /*
	            html += "    <td class='word_break_none tc'>";
	            if(o.scoreStatus == "2"){
	            	html += "환산중";
	            } else if(o.scoreStatus == "3"){
	            	html += "완료";
	            }*/

                    $("#scoreStatus").val(o.scoreStatus);

                    //html += "    </td>";

                    html += "    <td class='tc'>";
                    html += "        <a href=\"javascript:onScoreOverallDtlPop('" + o.crsCreCd + "', '" + o.userId + "', '" + o.stdNo + "');\" class='ui basic small button'>상세</a>  ";
                    html += "    </td>";
                    html += "</tr>";
                });
                html += "</tbody>";
                html += "</table>";

                var wh = $(window).height() - 250;
                if (wh < 400) wh = 400;
                $("#tableDiv").css("max-height", (wh) + "px");

                $("#tableDiv").empty().html(html);

                $("#sTable").footable({
                    on: {
                        "after.ft.sorting": function (e, ft, sorter) {
                            $("#tableDiv table tbody tr").each(function (z, k) {
                                $(k).find("td[name=lineNo]").html((z + 1));
                            });
                        },
                        "before.ft.sorting": function (e, ft, sorter) {
                            var index = sorter.column.index;
                            ft.rows.array.forEach(function (v, i) {
                                if (v.cells.length > 0) {
                                    var cell = v.cells[index];

                                    if (cell && cell.sortValue !== cell.$el[0].dataset.sortValue) {
                                        cell.sortValue = cell.$el[0].dataset.sortValue;
                                        cell.$el.data("sortValue", cell.sortValue);
                                    }
                                }
                            });

                            /*
							$("#tableDiv table tbody tr td input[type=text].inScore").each(function(z, k){
								var sco = $(k).val();

								if (sco.indexOf(".") > -1) {
									sco = "A" + String(sco[0]).padStart(3, "0") + "" + String(sco[1]).padEnd(2, "0");
								}
								else {
									sco = "A" + String(sco).padStart(3, "0")+"00";
								}

								$(k).parent().parent().attr("data-sort-value", sco);
							});
							*/
                        }
                    },
                    breakpoints: {
                        "xs": 375,
                        "sm": 560,
                        "md": 768,
                        "lg": 1024,
                        "w_lg": 1200
                    }
                });

                $('.ui.checkbox').checkbox();

                $("#chkAll").on("change", function () {
                    if ($(this).is(":checked")) {
                        $("input[name*=dataChk]").prop("checked", true);
                        $("input[name*=dataChk]").val("Y");
                    } else {
                        $("input[name*=dataChk]").prop("checked", false);
                        $("input[name*=dataChk]").val("N");
                    }
                });

                $("input[name*=dataChk]").on("change", function () {
                    if ($(this).is(":checked")) {
                        $(this).val("Y");
                    } else {
                        $(this).val("N");
                    }
                });

                $("input[name*=Input]").on("blur", function () {
                    this.value = Number(this.value);
                    scoreValidation(this);
                    calTotSum(this);
                });

                $("input[name*=totScoreData]").on("blur", function () {
                    this.value = Number(this.value);
                    scoreValidation(this);

                    if (prevTotalScoreObj[this.name] != this.value) {
                        var totScoreIdx = $(this).data("totScoreIdx");

                        prevTotalScoreObj[this.name] = this.value;
                        getNewGrade(totScoreIdx, this.value);
                    }
                });

                $("input[name*=Input]").keyup(function (e) {
                    var idx = $(this).parents("tr").index();
                    var nm = $(this).attr("name");
                    var targetNm = nm.substring(nm.indexOf(".") + 1);

                    if (e.keyCode == "38") {
                        //위 38
                        if (idx == 0) {
                            $("#tableDiv table > tbody > tr").eq(0).find("[name*=" + targetNm + "]").focus();
                        } else {
                            $("#tableDiv table > tbody > tr").eq((idx - 1)).find("[name*=" + targetNm + "]").focus();
                        }

                    } else if (e.keyCode == "40") {
                        //아래 40
                        if (idx == ($("#tableDiv table > tbody > tr").length - 1)) {
                            $("#tableDiv table > tbody > tr").eq(0).find("[name*=" + targetNm + "]").focus();
                        } else {
                            $("#tableDiv table > tbody > tr").eq((idx + 1)).find("[name*=" + targetNm + "]").focus();
                        }
                    }
                });

                $("input[name*=Input]").on("keydown", function (e) {
                    if ($(this).is('[readonly]')) return;

                    //if(!(e.keyCode < 48 || e.keyCode > 57)){
                    var idx = $(this).parents("tr").index();
                    $("#tableDiv table > tbody > tr").eq(idx).find("[type='checkbox']").prop("checked", true);
                    $("#tableDiv table > tbody > tr").eq(idx).find("[type='checkbox']").val("Y");
                });

                $("input[name*=totScoreData]").on("keydown", function (e) {
                    if ($(this).is('[readonly]')) return;

                    //if(!(e.keyCode < 48 || e.keyCode > 57)){
                    var idx = $(this).parents("tr").index();
                    $("#tableDiv table > tbody > tr").eq(idx).find("[type='checkbox']").prop("checked", true);
                    $("#tableDiv table > tbody > tr").eq(idx).find("[type='checkbox']").val("Y");
                    $("#tableDiv table > tbody > tr").eq(idx).find("[name*=rowStatus]").val("Y");
                });

                $("input[name*=ScoreAvg]").on("change", function () {
                    updateAvg(this);
                });

                var selectHtml = "";

                $("#graphSelect option").remove();
                selectHtml += "<option value='select'>선택</option>";
                selectHtml += "<option value='all'>전체</option>";
                $.each(ratioArr, function (i, o) {

                    if (o == "middleTestScore") {
                        selectHtml += "<option value='2'><spring:message code='forum.label.type.exam.M' /></option>";// 중간고사
                    } else if (o == "lastTestScore") {
                        selectHtml += "<option value='3'><spring:message code='forum.label.type.exam.L' /></option>";// 기말고사
                    } else if (o == "testScore") {
                        selectHtml += "<option value='4'><spring:message code='crs.label.nomal_exam' /></option>";// 수시평가
                    } else if (o == "lessonScore") {
                        selectHtml += "<option value='1'><spring:message code='crs.label.attend' />/<spring:message code='dashboard.lesson' /></option>";// 출석/강의
                    } else if (o == "assignmentScore") {
                        selectHtml += "<option value='5'><spring:message code='dashboard.cor.asmnt' /></option>";// 과제
                    } else if (o == "forumScore") {
                        selectHtml += "<option value='6'><spring:message code='dashboard.cor.forum' /></option>";//토론
                    } else if (o == "quizScore") {
                        selectHtml += "<option value='7'><spring:message code='dashboard.cor.quiz' /></option>";//퀴즈
                    } else if (o == "reshScore") {
                        selectHtml += "<option value='8'><spring:message code='dashboard.cor.resch' /></option>";//설문
                    }
                });

                $("#graphSelect").html(selectHtml);
                //$("#graphSelect").dropdown();

                //그래프 조회
                $("#graphSelect").on("change", function () {
                    onOverallGraph(this.value);
                    onOverallGridCase(this.value);
                });

                //$("#graphSelect").val("all");
                //$("#graphSelect").trigger("change");

                onOverallGraph("all");
                onOverallGridCase("all");

                initSet($("#scoreStatus").val());

                // 입력값 유효성 검증 obj 세팅
                $.each($("input[name*=Input]"), function () {
                    prevInputObj[this.name] = this.value;
                });

                $.each($("input[name*=totScoreData]"), function () {
                    prevInputObj[this.name] = this.value;
                    prevTotalScoreObj[this.name] = this.value;
                });

                $(".inScore").on("focus", function () {
                    if ($(this).val() == "-") {
                        $(this).val("");
                    }
                });

                SEARCH_OBJ = param;
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 에러가 발생했습니다! */
            alert("<spring:message code='fail.common.msg' />");
        }, true);
    }

    function getSortScore(val) {
        if (val == null || val == '' || val == '-') {
            val = 0;
        }
        var value = String(val);
        if (value.indexOf(".") > -1) {
            value = value.split(".");
            value = String(value[0]).padStart(3, "0") + "" + String(value[1]).padEnd(2, "0");
        } else {
            value = String(value).padStart(3, "0") + "00";
        }

        return value;
    }

    function onTotScoreUpd(obj) {
        var param = {
            crsCreCd: $("#sCrsCreCd").val()
            , stdNo: $(obj).parents("tr").find("input[type=hidden][name*=stdNo]").val()
            , userId: $(obj).parents("tr").find("input[type=hidden][name*=userId]").val()
            , modScore: $(obj).find("input").val()
        }

        ajaxCall("/score/scoreOverall/updateTotScoreByStdNo.do", param, function (data) {
            onAbsentSearch();
            onSearch();
        }, function (xhr, status, error) {
            /* 에러가 발생했습니다! */
            alert("<spring:message code='fail.common.msg' />");
        }, true);

        //$(obj).hide();
        //$(obj).parent("td").find("span").show();
    }

    //상세
    function onScoreOverallDtlPop(crsCreCd, userId, stdNo) {
        $("#modalScoreOverallDtlForm [name=crsCreCd]").val(crsCreCd);
        $("#modalScoreOverallDtlForm [name=userId]").val(userId);
        $("#modalScoreOverallDtlForm [name=stdNo]").val(stdNo);
        $("#modalScoreOverallDtlForm").attr("target", "modalScoreOverallDtlIfm");
        $("#modalScoreOverallDtlForm").attr("action", "/score/scoreOverall/scoreOverallDtlPopup.do");
        $("#modalScoreOverallDtlForm").submit();
        $("#modalScoreOverallDtl").modal('show');
    }

    //메모
    function setMemo(stdNo) {
        $("#modalStdMemoForm [name=crsCreCd]").val($("#sCrsCreCd").val());
        $("#modalStdMemoForm [name=stdNo]").val(stdNo);
        $("#modalStdMemoForm").attr("target", "modalStdMemoIfm");
        $("#modalStdMemoForm").attr("action", "/score/scoreOverall/scoreOverallStdMemoPopup.do");
        $("#modalStdMemoForm").submit();
        $("#modalStdMemo").modal('show');
    }

    //ROW별 산출총점 이벤트
    function updateCalTotSum(obj) {
        var sumVal = 0;

        //각각 점수 합산
        $(obj).parents("tr").find("input[name*=ScoreAvg][type=hidden]").each(function (i, o) {
            sumVal += Number($(o).val());
        });

        //가산점까지 합산
        //가산점은 스크립트에서 계산하지않는다 주석으로 변경.
        //sumVal += Number($(obj).parents("tr").find("[name*=etcScoreInput]").val());
        sumVal = parseFloat(sumVal.toFixed(2));

        $(obj).parents("tr").find("input[name*=finalScore]").val(sumVal);
        $(obj).parents("tr").find("input[name*=finalScore]").prev("span").html(sumVal);
    }

    //각각 산출점수 계산 및 텍스트 반영
    function updateAvg(obj) {
        if ($(obj).prev("span").length == 0) {
            $(obj).prev("a").find("span").html(obj.value);
        } else {
            $(obj).prev("span").html(obj.value);
        }
        updateCalTotSum(obj);
    }

    function calTotSum(obj) {

        var _name = obj.name;
        var _nameStrLen, _nameEndLen, headVal, inputVal, calVal;

        if (_name.indexOf("etc") < 0) {
            _name = obj.name;
            _nameStrLen = _name.indexOf(".");
            _nameEndLen = _name.indexOf("Input");
            headVal = Number(eval(_name.substring(_nameStrLen + 1, _nameEndLen) + "Head"));
            if (obj.value != "-") {
                inputVal = Number(obj.value);
                calVal = parseFloat(multiply(inputVal, headVal / 100).toFixed(2));

                $(obj).parent().parent().find("input[type=hidden]").val(calVal);
                $(obj).parent().parent().find("input[type=hidden]").trigger("change");
            }

        } else {
            //가산점은 바로 총점계산
            //updateCalTotSum(obj);
        }

        $(obj).parent().prev().html(obj.value);
    }

    //소수점 곱셈
    function multiply(a, b, point) {
        point = point || 2; // 소수 자리수
        var unit = Math.pow(10, point);
        a = a * unit;
        b = b * unit;

        return (a * b) / (unit * unit);
    }

    //일괄평가 팝업
    function onAllEvlModal() {
        getNoEvalItem($("#sCrsCreCd").val()).done(function (noEvalItem) {
            if (noEvalItem) {
                // 미평가된 [{0}]이/가 있습니다. 이대로 성적환산 하시겠습니까?
                if (!confirm('<spring:message code="score.alert.no.eval.item.exist" arguments="' + noEvalItem + '" />')) return;
            }

            $("#modalEvlWarningForm").attr("target", "modalEvlWarningIfm");
            $("#modalEvlWarningForm").attr("action", "/score/scoreOverall/scoreOverallEvlWarningPopup.do");
            $("#modalEvlWarningForm").submit();
            $("#modalEvlWarning").modal('show');
        }).fail(function () {
            $("#modalEvlWarningForm").attr("target", "modalEvlWarningIfm");
            $("#modalEvlWarningForm").attr("action", "/score/scoreOverall/scoreOverallEvlWarningPopup.do");
            $("#modalEvlWarningForm").submit();
            $("#modalEvlWarning").modal('show');
        });
    }

    //성적환산 팝업 콜백
    function scoreConvertCallBack() {
        onAbsentSearch();
        onSearch();
        /*
	try {
		// erp 테스트 데이터 전송
		saveTestScoreIgnore();
	} catch (e) {
		console.log(e);
	}
	 */
    }

    function onAllEvlModalOkRtn() {
        chgButton("2");
        chgText("2");
        window.closeModal();
        updateScoreStatus("2");
    }

    function updateScoreStatus(status) {
        $("#scoreStatus").val(status);
        ajaxCall("/score/scoreOverall/updateOverallScoreStatus.do", $("#tableForm").serialize(), function (data) {
            if (data.result > 0) {
                onAbsentSearch();
                onSearch();
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 에러가 발생했습니다! */
            alert("<spring:message code='fail.common.msg' />");
        }, true);
    }

    function chgScoreStatusText() {
        /*
	var scoreStatusVal = $("#scoreStatus").val();

	if(gfn_isNull(scoreStatusVal)){
		scoreStatusVal = "2";
	}

	$("[name=scoreStatusText]").attr("class", "");
	$("#scoreStatusText"+scoreStatusVal).attr("class", "opacity9 fcBlue");
	 */
    }

    function initSet(status) {
        //버튼 제어
        chgButton(status);

        //그리드 인풋 제어
        chgText(status);

        //상태값 제어
        chgScoreStatusText();

        //10분에 한번씩 저장
        clearInterval(interval);
        interval = setInterval(function () {
            if ($("#scoreStatus").val() == "2" && $("input[name*=dataChk]:checked").length > 0) {
                onSave();
            }
        }, 600000);
    }

    //상단버튼 변경 (초반:1, 전체:2)
    function chgButton(type) {
        if (type == "1") {
            /* $("[name=chgButton1]").show();
		$("[name=chgButton2]").hide(); */

            $("#tableDiv").removeClass();
            $("#tableDiv").addClass("step bcGreenAlpha10");
        } else if (type == "2") {
            /* $("[name=chgButton1]").hide();
		$("[name=chgButton2]").show(); */

            $("#tableDiv").removeClass();
            $("#tableDiv").addClass("step bcBlueAlpha10");
        } else if (type == "3") {
            /* $("[name=chgButton1]").hide();
		$("[name=chgButton2]").show();
		$("#btnScoreCal").show();
		*/
            $("#tableDiv").removeClass();
            $("#tableDiv").addClass("step bcdark1Alpha10");
        }
    }

    //텍스트 변경 (초반:1, 전체:2)
    function chgText(type) {
        if (type == "1") {
            $("[name=chgSpanText]").show();
            $("[name=chgInputText]").hide();
            $("[name=etcDataTd]").show();
        } else if (type == "2") {
            $("[name=chgSpanText]").hide();
            $("[name=chgInputText]").show();
            $("[name=etcDataTd]").hide();
        } else if (type == "3") {
            $("[name=chgSpanText]").hide();
            $("[name=chgInputText]").show();
            $("[name=etcDataTd]").show();

            $("[name=totScoreSpan]").hide();
            $("[name=totScoreDiv]").show();
            /*
		$("[name=totScoreSpan]").on("click", function(){
			$(this).hide();
			$(this).parent("td").find("div").show();

			$(this).parent("td").find("div input").focus();
			//$("[name=totScoreDiv]").show();
		}); */
        }

        //$("[name=totScoreDiv]").hide();
    }

    //메세지 보내기
    function sendMsg() {
        if ($("#tableForm").find("input[name*=dataChk]:checked").length == 0) {
            /* 체크된 값이 없습니다. */
            alert('<spring:message code="score.label.ect.eval.oper.msg14" />');
            return;
        }
        var rcvUserInfoStr = "";

        var sendCnt = 0;
        $.each($("#tableForm").find("input[name*=dataChk]:checked"), function () {
            sendCnt++;
            if (sendCnt > 1) rcvUserInfoStr += "|";
            rcvUserInfoStr += $(this).attr("user_id");
            rcvUserInfoStr += ";" + $(this).attr("user_nm");
            rcvUserInfoStr += ";" + $(this).attr("mobile");
            rcvUserInfoStr += ";" + $(this).attr("email");
        });

        window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");

        var form = document.alarmForm;
        form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
        form.target = "msgWindow";
        form[name = 'alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
        form[name = 'rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
        form.submit();
    }

    //과목 당 항목별 이동
    function goCrsCreCtgr(ctgr) {
        var url = "";

        if (ctgr == "midTest") {
            url = "/exam/Form/examList.do?examType=EXAM";
        } else if (ctgr == "lastTest") {
            url = "/exam/Form/examList.do?examType=EXAM";
        } else if (ctgr == "lesson") {
            url = "/crs/Form/crsProfLesson.do";
        } else if (ctgr == "asmt") {
            url = "/asmt/profAsmtListView.do";
        } else if (ctgr == "forum") {
            url = "/forum/forumLect/Form/forumList.do";
        } else if (ctgr == "test") {
            url = "/exam/Form/examList.do?examType=ADMISSION";
        } else if (ctgr == "quiz") {
            url = "quiz/profQzListView.do";
        } else if (ctgr == "resh") {
            url = "/resh/Form/reshList.do";
        }

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "crsCreCtgrForm");
        form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: $("#sCrsCreCd").val()}));
        form.attr("action", url);
        form.appendTo("body");
        form.submit();
    }

    //등급 재조회
    var prevTotalScoreObj = {};

    function getNewGrade(idx, modScore) {
        ajaxCall("/score/scoreOverall/selectModGrade.do", {
            crsCreCd: $("#sCrsCreCd").val(),
            modScore: modScore
        }, function (data) {
            if (data.result > 0) {
                var returnVO = data.returnVO || {};
                var modGrade = returnVO.modGrade || "";

                if (modGrade) {
                    if ($("[data-grade-idx='" + idx + "']").length == 1) {
                        $("[data-grade-idx='" + idx + "']").html(modGrade == "F" ? '<span class="fcRed fweb">F</span>' : modGrade);

                        var gradeSort = modGrade;

                        if (modGrade.indexOf("+") > -1) {
                            gradeSort = modGrade.replace("+", "0");
                        } else {
                            gradeSort = modGrade + "1";
                        }

                        //$("[data-grade-idx='" + idx + "']")[0].setAttribute('data-sort-value', gradeSort);
                        $("[data-grade-idx='" + idx + "']")[0].dataset.sortValue = gradeSort;
                    }
                }
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
        }, true);
    }

    //미평가 항목조회
    function getNoEvalItem(crsCreCd) {
        var deferred = $.Deferred();

        var url = "/score/scoreOverall/selectOverallList.do";
        var param = {
            crsCreCd: crsCreCd
        };

        ajaxCall(url, param, function (data) {
            if (data.result > 0) {
                var returnList = data.returnList || [];
                var noEvalObj = {};

                $.each(returnList, function (i, o) {
                    $.each(ratioArr, function (j, z) {
                        if (z == "middleTestScore") {
                            if (o.midNoEvalCnt > 0) {
                                noEvalObj['<spring:message code="forum.label.type.exam.M" />'] = true; // 중간고사
                            }
                        } else if (z == "lastTestScore") {
                            if (o.lastNoEvalCnt > 0) {
                                noEvalObj['<spring:message code="forum.label.type.exam.L" />'] = true; // 기말고사
                            }
                        } else if (z == "testScore") {
                            if (o.testNoEvalCnt > 0) {
                                noEvalObj['<spring:message code="crs.label.nomal_exam" />'] = true; // 수시평가
                            }
                        } else if (z == "lessonScore") {
                        } else if (z == "assignmentScore") {
                            if (o.asmntNoEvalCnt > 0) {
                                noEvalObj['<spring:message code="dashboard.cor.asmnt" />'] = true; // 과제
                            }
                        } else if (z == "forumScore") {
                            if (o.forumNoEvalCnt > 0) {
                                noEvalObj['<spring:message code="dashboard.cor.forum" />'] = true; // 토론
                            }
                        } else if (z == "quizScore") {
                            if (o.quizNoEvalCnt > 0) {
                                noEvalObj['<spring:message code="dashboard.cor.quiz" />'] = true; // 퀴즈
                            }
                        } else if (z == "reshScore") {
                            if (o.reschNoEvalCnt > 0) {
                                noEvalObj['<spring:message code="dashboard.cor.resch" />'] = true; // 설문
                            }
                        }
                    });
                });

                var noEvalItemList = Object.keys(noEvalObj);

                if (noEvalItemList.length > 0) {
                    var msg = noEvalItemList.join(", ");

                    deferred.resolve(msg);
                } else {
                    deferred.resolve("");
                }
            } else {
                deferred.resolve("");
            }
        }, function (xhr, status, error) {
            deferred.resolve("");
        }, true);

        return deferred.promise();
    }

    var prevInputObj = {};

    function scoreValidation(obj) {
        var regex = /^\./;

        if (regex.test(obj.value)) {
            obj.value = "0" + obj.value;
        }

        // 100 이하의 정수 또는 소수점인지 확인
        //var regex = /^100(\.0+)?(\.[0-9]+)?$|^(\d{0,2}(\.\d{0,2})?)?$/;
        var regex = /^100(\.0+)?(\.\d{1,4})?$|^\d{0,2}(\.\d{0,4})?$/;

        // 입력값이 정규식과 일치하지 않으면 이전 값으로 복원
        if (!regex.test(obj.value)) {
            obj.value = prevInputObj[obj.name];
        } else {
            prevInputObj[obj.name] = obj.value;
        }
    }

    //업무일정 체크
    function checkJobSch() {
        var deferred = $.Deferred();

        var uniCd = $("#sUniCd").val();
        var calendarCtgr = "";

        // 성적입력기간
        if (uniCd == "G") {
            calendarCtgr = "00210207";
        } else {
            calendarCtgr = "00210206";
        }

        var url = "/jobSchHome/viewSysJobSch.do";
        var data = {
            "crsCreCd": $("#sCrsCreCd").val(),
            "calendarCtgr": calendarCtgr,
            "haksaYear": $("#creYear").val(),
            "haksaTerm": $("#creTerm").val(),
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnVO = data.returnVO;
                if (returnVO != null) {
                    var jobSchPeriodYn = returnVO.jobSchPeriodYn;
                    var jobSchExcPeriodYn = returnVO.jobSchExcPeriodYn;
                    var schStartDt = returnVO.schStartDt;
                    var schEndDt = returnVO.schEndDt;

                    if (jobSchPeriodYn == "Y" || jobSchExcPeriodYn == "Y") {
                        deferred.resolve();
                    } else {
                        var argu = '<spring:message code="score.label.score.proc" />'; // 성적처리
                        var msg = '<spring:message code="score.alert.no.job.sch.period" arguments="' + argu + '" />'; // 기간이 아닙니다.

                        if (schStartDt && schEndDt.length == 14 && schEndDt && schEndDt.length == 14) {
                            //msg += '\n<spring:message code="common.period" /> : [' + getDateFmt(schStartDt) + ' ~ ' + getDateFmt(schEndDt) + ']'; // 기간
                        }

                        alert(msg);
                        deferred.reject();
                    }
                } else {
                    alert('<spring:message code="sys.alert.already.job.sch" />'); // 등록된 일정이 없습니다.
                    deferred.reject();
                }
            } else {
                alert(data.message);
                deferred.reject();
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='exam.error.info' />"); // 정보 조회 중 에러가 발생하였습니다.
            deferred.reject();
        });

        return deferred.promise();
    }

    //날짜 포멧 변환 (yyyy.mm.dd || yyyy.mm.dd hh:ii)
    function getDateFmt(dateStr) {
        var fmtStr = (dateStr || "");

        if (fmtStr.length == 14) {
            fmtStr = fmtStr.substring(0, 4) + '.' + fmtStr.substring(4, 6) + '.' + fmtStr.substring(6, 8) + ' ' + fmtStr.substring(8, 10) + ':' + fmtStr.substring(10, 12);
        } else if (fmtStr.length == 8) {
            fmtStr = fmtStr.substring(0, 4) + '.' + fmtStr.substring(4, 6) + '.' + fmtStr.substring(6, 8);
        }

        return fmtStr;
    }

    //erp 테스트 전송
    function saveTestScoreIgnore() {
        ajaxCall("/score/scoreOverall/insertTestScore.do", {crsCreCd: $("#sCrsCreCd").val()}, function (data) {
        }, function (xhr, status, error) {
        }, true);
    }

    //사용자 정보 팝업
    function userInfoPop(userId) {
        var userInfoUrl = "${userInfoPopUrl}" + btoa(`{"stuno":"\${userId}"}`);
        var options = 'top=100, left=150, width=1200, height=800';
        window.open(userInfoUrl, "", options);
    }
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
<input type="hidden" id="sUserId" name="sUserId" value="<c:out value="${sUserId}" />"/>

<div id="wrap" class="main">
    <%@ include file="/WEB-INF/jsp/common/frontLnb.jsp" %>

    <div id="container">
        <%@ include file="/WEB-INF/jsp/common/frontGnb.jsp" %>

        <!-- 본문 content 부분 -->
        <div class="content">
            <div class="ui form">
                <div class="layout2">
                    <div class="classInfo">
                        <div class="mra">
                            <h2 class="page-title"><spring:message code="score.label.university.score"/></h2>
                            <!-- 종합성적 -->
                        </div>
                    </div>

                    <div class="row">
                        <div class="col">
                            <div class="option-content">
                                <div>
                                    <p class="f110"><spring:message code="score.label.ect.eval.oper.msg19"/></p>
                                    <!-- 운영중인 과목의 종합성적을 관리합니다. -->
                                    <%--
					            		<div class="mt15 mb15 tc bcYellow p10">
											<fmt:parseDate var="schStartDtFmt" pattern="yyyyMMddHHmmss" value="${sysJobSchVO.schStartDt }" />
											<fmt:formatDate var="schStartDt" pattern="yyyy.MM.dd HH:mm" value="${schStartDtFmt }" />
									    	<fmt:parseDate var="schEndDtFmt" pattern="yyyyMMddHHmmss" value="${sysJobSchVO.schEndDt }" />
											<fmt:formatDate var="schEndDt" pattern="yyyy.MM.dd HH:mm" value="${schEndDtFmt }" />
									    	<spring:message code="score.label.university.score" /><spring:message code="score.label.university.score.period" /> : ${schStartDt } ~ ${schEndDt }<!-- 종합성적 성적입력기간 -->
									    </div>
									     --%>
                                    <h3 class="sec_head mb10"><spring:message code="score.label.service.lecture"/></h3>
                                    <!-- 운영과목 -->
                                </div>
                                <div class="mla">
                                    <%-- <a href="#" class="ui basic button"><spring:message code="score.button.manual.down" /><!-- 매뉴얼 다운로드 --></a> --%>
                                    <a href="https://lms.hycu.ac.kr/content/score/manual/종합성적평가_매뉴얼_ver_202302.pdf"
                                       target="_blank" class="ui basic button">
                                        <spring:message code="score.button.manual.down" /><!-- 매뉴얼 다운로드 --></a>
                                </div>
                            </div>

                            <div class="option-content mb20">
                                <select class="ui dropdown" id="creYear" onchange="listCreCrs()">
                                    <option value=""><spring:message code="std.label.year"/></option><!-- 년도 -->
                                    <c:forEach var="item" items="${yearList }">
                                        <option value="${item }" ${item eq termVO.haksaYear ? 'selected' : '' }>${item }</option>
                                    </c:forEach>
                                </select>
                                <select class="ui dropdown" id="creTerm" onchange="listCreCrs()">
                                    <option value=""><spring:message code="crs.label.open.term"/></option><!-- 개설학기 -->
                                    <c:forEach var="list" items="${termList }">
                                        <option value="${list.codeCd }" ${list.codeCd eq termVO.haksaTerm ? 'selected' : '' }>${list.codeNm }</option>
                                        <%-- <option value="${list.codeCd }" ${list.codeCd eq '20' ? 'selected' : '' }>${list.codeNm }</option> --%>
                                    </c:forEach>
                                </select>
                                <div class="mla">
                                    <p>[ <spring:message code="exam.label.total"/><span class="fcBlue"
                                                                                        id="totCrsCnt">0</span><spring:message
                                            code="exam.label.cnt"/> ]</p><!-- 총 건 -->
                                </div>
                            </div>

                            <table class="table type2 sticky" id="creCrsTable" data-sorting="true" data-paging="false"
                                   data-empty="<spring:message code="filebox.common.empty" />"><!-- 등록된 내용이 없습니다. -->
                                <thead>
                                <tr>
                                    <th scope="col" class="tc"><spring:message code="main.common.number.no"/></th>
                                    <!-- NO. -->
                                    <th scope="col" class="tc"><spring:message code="resh.label.type"/></th><!-- 구분 -->
                                    <th scope="col" class="tc"><spring:message code="std.label.crscre_dept"/></th>
                                    <!-- 개설학과 -->
                                    <th scope="col" class="tc"><spring:message code="std.label.crs_cd"/></th>
                                    <!-- 학수번호 -->
                                    <th scope="col" class="tc"><spring:message code="std.label.decls"/></th><!-- 분반 -->
                                    <th scope="col" class="tc"><spring:message code="std.label.crscre_nm"/></th>
                                    <!-- 과목명 -->
                                    <%-- <th scope="col" class="tc"><spring:message code="std.label.hy" /></th><!-- 학년 --> --%>
                                    <!-- <th scope="col" class="tc">이수구분</th> -->
                                    <th scope="col" class="tc"><spring:message code="common.label.credit"/></th>
                                    <!-- 학점 -->
                                    <%-- <th scope="col" class="tc"><spring:message code="common.teaching.professor" /></th><!-- 대표교수 --> --%>
                                    <%-- <th scope="col" class="tc"><spring:message code="std.label.rep_prof_no" /></th><!-- 교수번호 --> --%>
                                    <th scope="col" class="tc"><spring:message code="score.label.std.cnt"/></th>
                                    <!-- 수강인원 -->
                                    <th scope="col" class="tc"><spring:message code="score.label.garde.type"/></th>
                                    <!-- 성적평가구분 -->
                                    <th scope="col" class="tc"><spring:message
                                            code="score.label.score.grade.type"/></th><!-- 성적부여방법 -->
                                    <th scope="col" class="tc"><spring:message code="common.label.going.stage"/></th>
                                    <!-- 진행단계 -->
                                </tr>
                                </thead>
                                <tbody id="creCrsTbody"></tbody>
                            </table>

                            <div id="scoreAllListDiv" style="display:none;">
                                <!-- 종합성적 처리 -->
                                <div class="ui small info message">
                                    <p><i class="info circle icon"></i><spring:message
                                            code="score.label.prof.oper.criteria.guide4"/></p>
                                    <!-- 강의운영(평가기준)에 근거한 최종 성적을 입력/산출 합니다. -->
                                    <p><i class="info circle icon"></i><spring:message
                                            code="score.label.prof.oper.criteria.guide5"/></p>
                                    <!-- 성적 환산 전에는 10분에 한번씩 자동 저장됩니다. -->
                                </div>
                                <%--
	                                <div class="ui segment m0">
		                                <ol class="cd-multi-steps text-bottom count mb0 flex-align-center">
					                        <li class="flex1">
					                        	<a id="btnScoreCalInit" href="javascript:void(0);">
					                        		<spring:message code="asmt.label.eval.score" /><spring:message code="common.button.copy" />
				                        			<span id="btnScoreCalInitStatus" class="d-block f080"></span>
				                        		</a><!-- 평가점수가져오기 -->
				                        	</li>
											<li  class="flex1">
												<a id="btnScoreCal" href="javascript:void(0);">
													<spring:message code="score.label.conversion" />
													<span id="btnScoreCalStatus" class="d-block f080"></span>
												</a><!-- 성적환산 -->
											</li>
					                        <li class="current flex1">
					                        	<a href="javascript:void(0)">
					                        		<spring:message code="common.label.finish" /><!-- 완료 -->
					                        		<span class="d-block f080" style="visibility: hidden">.</span>
					                        	</a>
				                        	</li>
					                    </ol>
				                    </div>
				                     --%>
                                <div class="flex-item-center mb10">
                                    <div class="ui ordered steps">
                                        <div class="step pt5 pb5 tl" id="scoreStatusStep1" style="min-width: 240px;">
												<span class="content">
													<span class="title">
														<spring:message code="asmnt.label.eval.score" /><spring:message code="common.button.copy" /><!-- 평가점수가져오기 -->
														<span id="btnScoreCalInitStatus" class="d-block"></span>
													</span>
												</span>
                                        </div>
                                        <div class="step pt5 pb5 tl" id="scoreStatusStep2" style="min-width: 240px;">
												<span class="content">
													<span class="title">
														<span class="inline-flex-item">
															<span class="bcRedAlpha30 d-inline-block mr3"
                                                                  style="width:15px; height: 15px;"></span><span
                                                                class="mr5"><spring:message code="exam.label.eval.n" /><!-- 미평가 -->,</span>
															<span class="bcBlueAlpha30 d-inline-block"
                                                                  style="width:15px; height: 15px; margin-right: 1px"></span>
															<span class="bcGreenAlpha30 d-inline-block mr3"
                                                                  style="width:15px; height: 15px;"></span><span
                                                                class="mr5"><spring:message code="exam.label.absent" /><!-- 결시원 -->,</span>
														</span>
														<br/>
														<span class="bcYellowAlpha30 d-inline-block mr3"
                                                              style="width:15px; height: 15px;"></span><span><spring:message code="exam.label.subs" /><!-- 대체평가 --></span>
                                                        <spring:message code="common.inspection" /><!-- 점검 -->
													</span>
												</span>
                                        </div>
                                        <div class="step pt5 pb5 tl" id="scoreStatusStep3" style="min-width: 240px;">
												<span class="content">
													<span class="title">
														<spring:message code="score.label.conversion" /><!-- 성적환산 -->
														<span id="btnScoreCalStatus" class="d-block"></span>
													</span>
												</span>
                                        </div>
                                        <div class="step pt5 pb5 tl" id="scoreStatusStep4" style="min-width: 240px;">
												<span class="content">
													<span class="title" class="inline-flex-item" style="height: 20px;">
														<button type="button"
                                                                class="ui button basic m0 inline-flex-item pl10 pr10 red"
                                                                style="padding: 3px; cursor: default;" id="btnF2">&nbsp;F
                                                            <spring:message code="score.button.concern" /><!-- 고려 --></button>
                                                        <spring:message code="common.inspection" /><!-- 점검 -->
														<br/> / <spring:message code="common.button.save" /><!-- 저장 -->
                                                        <spring:message code="common.finish" /><!-- 종료 -->
													</span>
												</span><!-- 완료 -->
                                        </div>
                                    </div>
                                </div>
                                <!-- 팝업 -->
                                <div class="ui flowing popup left center transition hidden" id="popupF2">
                                    <div class="w400">
                                        <div class="ui pointing secondary tabmenu menu mb10" id="tabPopupF2">
                                            <a class="item f100 p10 active flex1" id="popupF2Tab1" data-tab="f2cont1"
                                               style="max-width: 200px;"><i
                                                    class="icon circle info fcBlue opacity7 mr5"></i>
                                                <spring:message code="score.label.concern.f.msg1" /><!-- F처리 고려 대상 조회 -->
                                            </a>
                                            <a class="item f100 p10 flex1" data-tab="f2cont2" style="max-width: 200px;"><i
                                                    class="icon circle info fcBlue opacity7 mr5"></i>
                                                <spring:message code="score.label.rule.msg1" /><!-- 성적평가 규정 --></a>
                                        </div>
                                        <div class="ui tab active" data-tab="f2cont1">
                                            <div class="ui message m0">
                                                <p class="fweb bullet_dot mb10">
                                                    <spring:message code="score.label.concern.f.msg2" /><!-- 정기시험(중간/기말) 모두 미응시자와 산출총점 10점 미만 학생수가 표기되고 클릭 시 명단이 조회됩니다. -->
                                                </p>
                                                <p class="fweb mb10 pl5">
                                                    - <spring:message code="score.label.concern.f.msg6"/>
                                                </p>
                                                <p class="fweb mb10 pl5">
                                                    - <spring:message code="score.label.concern.f.msg7"/>
                                                </p>
                                                <p class="fweb mb10 pl5">
                                                    - <spring:message code="score.label.concern.f.msg8"/>
                                                </p>
                                                <p class="fweb bullet_dot pl5">
                                                    <spring:message code="score.label.concern.f.msg4"/>
                                                    <!-- 시스템에서 제공하는 기본 기능 외의 방법으로 평가한 경우를 대비하여 자동 F처리는 하지 않고 있으며,  -->
                                                    <spring:message code="score.label.concern.f.msg5" /><!-- 특이 사항이 없는 경우 환산 총점을 60점 미만으로 조정하여 F처리 후 [저장] 종료하면 됩니다. -->
                                                </p>
                                            </div>
                                        </div>
                                        <div class="ui tab" data-tab="f2cont2">
                                            <div class="ui message m0">
                                                <p class="fweb mb10">
                                                    <spring:message code="score.label.rule.msg2"/>
                                                </p>
                                                <p class=" mb10 pl5">
                                                    <span style="font-size: 1.15em;">①</span> <spring:message
                                                        code="score.label.rule.msg3"/>
                                                </p>
                                                <p class=" mb10 pl5">
                                                    <span style="font-size: 1.15em;">②</span> <spring:message
                                                        code="score.label.rule.msg4"/>
                                                </p>
                                                <p class=" mb10 pl5">
                                                    <span style="font-size: 1.15em;">③</span> <spring:message
                                                        code="score.label.rule.msg5"/>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <script type="text/javascript">
                                    //초기화 방법 1__일반적인 형식
                                    $('#tabPopupF2 .item').tab();

                                    $(function () {
                                        $("#btnF2").popup({
                                            popup: '#popupF2'
                                            , hoverable: true
                                            , position: 'left center'
                                            , onShow: function () {
                                                $("#popupF2Tab1").trigger("click");
                                            }
                                        });
                                    });
                                </script>
                                <!-- 팝업 -->
                                <%--
	                                <div class="tr mb10 mt10">
	                                    <div class="ui breadcrumb small">
	                                        <b><spring:message code="common.label.going.stage" /> : </b><!-- 진행단계 -->
	                                        <!--
	                                        <b id="scoreStatusText1" name="scoreStatusText" class="">성적환산 전</b>
	                                        <i class="right chevron icon divider"></i>
	                                        -->
	                                    	<b id="scoreStatusText2" name="scoreStatusText" class=""><spring:message code="score.label.conversion" /><spring:message code="seminar.label.webcam.start" /></b><!-- 성적환산 시작 -->
                                        	<i class="right chevron icon divider"></i>
                                        	<b id="scoreStatusText3" name="scoreStatusText" class=""><spring:message code="score.label.conversion" /><spring:message code="common.label.finish" /></b><!-- 성적환산 완료-->
	                                    </div>
	                                </div>
	                                 --%>

                                <div class="option-content gap4 ">
                                    <%-- <a href="javascript:;" onclick="sendMsg();return false;" class="ui basic button mra"><i class="paper plane outline icon"></i><spring:message code="common.button.message" /></a><!-- 메시지 --> --%>

                                    <div class="flex flex-wrap gap4 mla">
                                        <c:if test="${TUT_YN ne 'Y' }">
                                            <a class="ui blue button" id="btnScoreCalInit"><spring:message
                                                    code="asmnt.label.eval.score"/><spring:message
                                                    code="common.button.copy"/></a><!-- 평가점수가져오기 -->
                                            <a class="ui blue button" name="chgButton2" id="btnScoreCal"><spring:message
                                                    code="score.label.conversion"/></a><!-- 성적환산 -->
                                            <!-- 토글버튼 추가_230419 -->
                                            <%--
		                                        <label class="ui togglebtn" name="openLabel">
		                                            <input type="checkbox" class="slide" id="openYn" value="${openYn}">
		                                            <span class="label bcBlue">공개</span>
		                                            <span class="label">비공개</span>
		                                        </label>
		                                        --%>
                                            <!-- //토글버튼 추가_230419 -->
                                            <!-- <a class="ui basic small button" name="chgButton2" id="btnPrev">이전화면으로</a> -->
                                            <a class="ui orange button" name="chgButton2" id="btnSave"><spring:message
                                                    code="sys.button.save"/></a><!-- 저장 -->
                                            <!-- <a class="ui basic small button" name="chgButton1" id="btnChgAllEvl">일괄평가</a> -->
                                        </c:if>
                                        <a class="ui green button" id="btnScoreOverallExcel"><spring:message
                                                code="asmnt.label.excel.download"/></a><!-- 엑셀다운로드 -->
                                    </div>
                                </div>

                                <div class="ui divider"></div>

                                <div class="option-content gap4 mt10 mb10">
                                    <div class="ui action input search-box">
                                        <input id="searchValue" type="text"
                                               placeholder="<spring:message code="user.message.search.input.userinfo.no.dept.nm" />"
                                               value="">
                                        <button class="ui icon button" type="button" id="searchBtn">
                                            <i class="search icon"></i>
                                        </button>
                                    </div>

                                    <%-- <button type="button" class="ui button" id="btnM"><spring:message code="dashboard.absent" /> [ <spring:message code="exam.label.submit.y" /> : <span id="absentInfoM1">0</span><spring:message code="forum.label.person" />, <spring:message code="exam.label.approve" /> : <span id="absentInfoM2">0</span><spring:message code="forum.label.person" /> ]</button><!-- 중간결시원 제출 승인 명 --> --%>
                                    <%-- <button type="button" class="ui button" id="btnL"><spring:message code="dashboard.absent" /> [ <spring:message code="exam.label.submit.y" /> : <span id="absentInfoL1">0</span><spring:message code="forum.label.person" />, <spring:message code="exam.label.approve" /> : <span id="absentInfoL2">0</span><spring:message code="forum.label.person" /> ]</button><!-- 기말겨시원 제출 승인 명 --> --%>
                                    <button type="button" class="ui button basic p5 m0 inline-flex-item pl10 pr10"
                                            id="btnZero"><span class="bcRedAlpha30 w30 d-inline-block mr5"
                                                               style="height: 25px;"></span><spring:message
                                            code="exam.label.eval.n"/> [ <span
                                            id="absentInfoZeroCnt">0</span><spring:message code="forum.label.person"/> ]
                                    </button><!-- 미평가 명 -->
                                    <button type="button" class="ui button basic p5 m0 inline-flex-item pl10 pr10"
                                            id="btnApprove"><span class="bcBlueAlpha30 w30 d-inline-block mr5"
                                                                  style="height: 26px;"></span><spring:message
                                            code="score.button.exam.absent.approve"/> [<span
                                            id="absentApproveCnt">0</span><spring:message code="message.count"/>]
                                    </button><!-- 결시 승인 -->
                                    <button type="button" class="ui button basic p5 m0 inline-flex-item pl10 pr10"
                                            id="btnApplicate"><span class="bcGreenAlpha30 w30 d-inline-block mr5"
                                                                    style="height: 26px;"></span><spring:message
                                            code="score.button.exam.absent.applicate"/> [<span
                                            id="absentApplicateCnt">0</span><spring:message code="message.count"/>]
                                    </button><!-- 결시 신청 -->
                                    <button type="button" class="ui button basic p5 m0 inline-flex-item pl10 pr10"
                                            id="btnReExam"><span class="bcYellowAlpha30 w30 d-inline-block mr5"
                                                                 style="height: 26px;"></span><spring:message
                                            code="common.label.alternate"/> [<span
                                            id="reExamCnt">0</span><spring:message code="message.count"/>]
                                    </button><!-- 대체 -->
                                    <div class="mla flex">
                                        <button type="button"
                                                class="ui button basic p5 m0 inline-flex-item pl10 pr10 red mr5"
                                                id="btnF"><span class="d-inline-block" style="height: 26px;"></span>F
                                            <spring:message code="score.button.concern"/> [<span
                                                    id="fCnt">0</span><spring:message code="forum.label.person"/>]
                                        </button><!-- F 대상자 -->
                                        <!-- 팝업 -->
                                        <div class="ui flowing popup left center transition hidden" id="popupF">
                                            <div class="w400">
                                                <div class="ui pointing secondary tabmenu menu mb10" id="tabPopupF">
                                                    <a class="item f100 p10 active flex1" id="popupFTab1"
                                                       data-tab="fcont1" style="max-width: 200px;"><i
                                                            class="icon circle info fcBlue opacity7 mr5"></i>
                                                        <spring:message code="score.label.concern.f.msg1" /><!-- F처리 고려 대상 조회 -->
                                                    </a>
                                                    <a class="item f100 p10 flex1" data-tab="fcont2"
                                                       style="max-width: 200px;"><i
                                                            class="icon circle info fcBlue opacity7 mr5"></i>
                                                        <spring:message code="score.label.rule.msg1" /><!-- 성적평가 규정 -->
                                                    </a>
                                                </div>
                                                <div class="ui tab active" data-tab="fcont1">
                                                    <div class="ui message m0">
                                                        <p class="fweb bullet_dot mb10">
                                                            <spring:message code="score.label.concern.f.msg2" /><!-- 정기시험(중간/기말) 모두 미응시자와 산출총점 10점 미만 학생수가 표기되고 클릭 시 명단이 조회됩니다. -->
                                                        </p>
                                                        <p class="fweb mb10 pl5">
                                                            - <spring:message code="score.label.concern.f.msg6"/>
                                                        </p>
                                                        <p class="fweb mb10 pl5">
                                                            - <spring:message code="score.label.concern.f.msg7"/>
                                                        </p>
                                                        <p class="fweb mb10 pl5">
                                                            - <spring:message code="score.label.concern.f.msg8"/>
                                                        </p>
                                                        <p class="fweb bullet_dot pl5">
                                                            <spring:message code="score.label.concern.f.msg4"/>
                                                            <!-- 시스템에서 제공하는 기본 기능 외의 방법으로 평가한 경우를 대비하여 자동 F처리는 하지 않고 있으며,  -->
                                                            <spring:message code="score.label.concern.f.msg5" /><!-- 특이 사항이 없는 경우 환산 총점을 60점 미만으로 조정하여 F처리 후 [저장] 종료하면 됩니다. -->
                                                        </p>
                                                    </div>
                                                </div>
                                                <div class="ui tab" data-tab="fcont2">
                                                    <div class="ui message m0">
                                                        <p class="fweb mb10">
                                                            <spring:message code="score.label.rule.msg2"/>
                                                        </p>
                                                        <p class=" mb10 pl5">
                                                            <span style="font-size: 1.15em;">①</span> <spring:message
                                                                code="score.label.rule.msg3"/>
                                                        </p>
                                                        <p class=" mb10 pl5">
                                                            <span style="font-size: 1.15em;">②</span> <spring:message
                                                                code="score.label.rule.msg4"/>
                                                        </p>
                                                        <p class=" mb10 pl5">
                                                            <span style="font-size: 1.15em;">③</span> <spring:message
                                                                code="score.label.rule.msg5"/>
                                                        </p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <script type="text/javascript">
                                            //초기화 방법 1__일반적인 형식
                                            $('#tabPopupF .item').tab();

                                            $(function () {
                                                $("#btnF").popup({
                                                    popup: '#popupF'
                                                    , hoverable: true
                                                    , position: 'left center'
                                                    , onShow: function () {
                                                        $("#popupFTab1").trigger("click");
                                                    }
                                                });
                                            });
                                        </script>
                                        <small class="inline-flex-item">
                                            [ <spring:message code="exam.label.stare.user.cnt" /><!-- 대상인원 --><span
                                                id="listTotCnt"></span>
                                            <spring:message code="forum.label.person" /><!-- 명 -->]
                                            [ <spring:message code="score.label.total.person"/><span id="totCnt"></span>
                                            <spring:message code="forum.label.person"/>]<!-- 수강인원 명 -->
                                        </small>
                                    </div>
                                </div>

                                <form:form id="tableForm" commandName="list">
                                    <input type="hidden" name="scoreStatus" id="scoreStatus"/>
                                    <input type="hidden" id="sCrsCreCd" name="crsCreCd"/>
                                    <input type="hidden" id="sUniCd"/>
                                    <div id="tableDiv"
                                         style="padding:0;margin:0 0 3px 0;border:1px solid var(--darkB);"></div>
                                </form:form>

                                <div class="row">
                                    <div class="col">
                                        <div class="option-content gap4 header2">
                                            <div class="sec_head mra"><spring:message code="common.label.grade.chart"/>
                                                : <spring:message code="dashboard.all"/></div><!-- 성적 등급 분포도 : 전체 -->
                                            <select class="ui dropdown" id="graphSelect">
                                            </select>
                                        </div>
                                        <div id="graphDiv">
                                            <p class="option-content gap4 mb5">
                                                <spring:message code="common.label.score.all" /><spring:message code="common.label.grade.chart" /><!-- 전체 성적 등급 분포도 -->
                                                <small>[<spring:message code="exam.label.stare.user.cnt" /><!-- 대상인원 -->
                                                    : <span id="graphTotCnt"></span> ]</small>
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
                                                            <th scope="col" class="">
                                                                <spring:message code="message.marks" /><!-- 배점 --></th>
                                                            <th scope="col" class="">
                                                                <spring:message code="exam.label.avg" /><!-- 평균 --></th>
                                                            <th scope="col" class="">
                                                                <spring:message code="exam.label.avg.upper.10" /><!-- 상위10%평균 --></th>
                                                            <th scope="col" class="">
                                                                <spring:message code="asmnt.label.max.score" /><!-- 최고점수 --></th>
                                                            <th scope="col" class="">
                                                                <spring:message code="asmnt.label.min.score" /><!-- 최저점수 --></th>
                                                            <th scope="col" class="">
                                                                <spring:message code="exam.label.total.join.user" /><!-- 총응시자수 --></th>
                                                        </tr>
                                                        </thead>
                                                        <tbody>
                                                        <tr>
                                                            <td data-label="<spring:message code="message.marks" />">
                                                                100
                                                            </td><!-- 배점 -->
                                                            <td data-label="<spring:message code="exam.label.avg" />"
                                                                id="gridCol1"></td><!-- 평균 -->
                                                            <td data-label="<spring:message code="exam.label.avg.upper.10" />"
                                                                id="gridCol2"></td><!-- 상위10%평균 -->
                                                            <td data-label="<spring:message code="asmnt.label.max.score" />"
                                                                id="gridCol3"></td><!-- 최고점 -->
                                                            <td data-label="<spring:message code="asmnt.label.min.score" />"
                                                                id="gridCol4"></td><!-- 최저점 -->
                                                            <td data-label="<spring:message code="exam.label.total.join.user" />"
                                                                id="gridCol5"></td><!-- 총응시자수 -->
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
                    </div>
                </div>
            </div><!-- //ui form -->
        </div><!-- //content -->
        <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
    </div><!-- //container -->
</div><!-- //pusher -->
<!-- 일괄평가 확인팝업 -->
<form class="ui form" id="modalEvlWarningForm" name="modalEvlWarningForm" method="POST" action="">
    <input type="hidden" name="crsCreCd"/>
    <div class="modal fade" id="modalEvlWarning" tabindex="-1" role="dialog"
         aria-labelledby="<spring:message code="score.label.batch.evaluation" />" aria-hidden="false">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"
                            aria-label="<spring:message code="sys.button.close" />">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title">
                        <spring:message code="score.label.batch.evaluation" /><!-- 일괄평가 시 주의사항 --></h4>
                </div>
                <div class="modal-body">
                    <iframe src="" id="modalEvlWarningIfm" name="modalEvlWarningIfm" width="100%"
                            scrolling="no"></iframe>
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
                    <button type="button" class="close" data-dismiss="modal"
                            aria-label="<spring:message code="sys.button.close" />">
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
                    <button type="button" class="close" data-dismiss="modal"
                            aria-label="<spring:message code="sys.button.close" />">
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
    $('iframe').iFrameResize();
    window.closeModal = function () {
        $('.modal').modal('hide');
    };
</script>
</body>

</html>
