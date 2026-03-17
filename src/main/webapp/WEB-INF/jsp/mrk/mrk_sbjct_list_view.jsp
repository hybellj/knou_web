<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="dashboard"/>
    </jsp:include>
</head>
<style>
    .inScore {
        padding-left: 0 !important;
        padding-right: 3px !important;
        text-align: right !important;
    }
/*    .table.type2 {
        min-width: 1000px !important;
    }*/
    i.right {
        margin-right: 0;
        width: 1em;
    }
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
<body class="home colorA "  style=""><!-- 컬러선택시 클래스변경 -->
    <script type="text/javascript">
        let SEARCH_OBJ;
        let ratioArr = [];
        let midexamHead, lstexamHead, atndcHead, asmtHead, dscsHead, quizHead, srvyHead, smnrHead, etcHead = "";

        $(document).ready(function() {
            changeSbjctList();

            // 평가점수 가져오기(점수입력 초기화)
            $("#btnScoreCalInit").on("click", function () {
                isMrkProcPeriod().done(function () {
                    onScoreCalInit();
                });
            });
        });

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
                        alert(data.message);
                    }
                },
                error: function(xhr, status, error) {
                    alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
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
                        alert(data.message);
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
                    $("#sbjctTbody").empty()
                    if (data.result > 0) {
                        let returnList = data.returnList || [];
                        let html = "";

                        if (returnList.length > 0) {
                            $.each(returnList, function(i, vo) {
                                let deptnm = vo.deptnm != null ? vo.deptnm : '-';
                                let crdts = vo.crdts != null ? vo.crdts * 1 : '-';

                                html += `
                                        <tr class="sbjctList" data-sbjctId="\${vo.sbjctId}" >
                                            <td>\${(i + 1)}</td>
                                            <td>\${vo.sbjctYr}</td>
                                            <td>\${vo.sbjctSmstr}</td>
                                            <td>\${vo.orgnm}</td>
                                            <td>\${deptnm}</td>
                                            <td>\${vo.sbjctId}</td>
                                            <td class="">\${vo.sbjctnm}</td>
                                            <td>\${vo.dvclasNo}</td>
                                            <td>\${crdts}</td>
                                            <td>-</td>
                                            <td>-</td>
                                            <td>-</td>
                                        </tr>`;
                            });

                            $("#ttlSbjctCnt").text(returnList.length);
                            $("#sbjctTbody").html(html);
                            $("#scoreAllListDiv").css("display", "none");

                            $("#sbjctTbody > tr").on("click", function () {
                                listStdMrk("",$(this).attr("data-sbjctId"));
                            });

                            $("#sbjctTable").parent().removeClass("scoreTable").addClass("scoreTable");
                            $("#sbjctTbody > tr").css("cursor", "pointer");

                        }
                    }else {
                        alert(data.message);
                    }
                },
                error: function(xhr, status, error) {
                    alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
                }
            });
        }

        // 학생 성적 목록 조회
        function listStdMrk(searchType, sbjctId) {

            $.ajax({
                url : "/mrk/profMrkRfltrtSelectAjax.do",
                data: { sbjctId : sbjctId, searchType: searchType },
                type: "GET",
                success: function (data) {
                    $("#sSbjctid").val(sbjctId);

                    let returnList  = data.returnList || [];
                    let returnVO    = data.returnVO || {};
                    let returnSubVO = data.returnSubVO || [];
                    ratioArr = [];

                    let html = "";
                    let colCnt = 10;

                    if (returnSubVO == null) {
                        alert("<spring:message code='score.label.process.msg19' />");/*해당과목의 평가기준을 먼저 입력해주세요.*/
                        $("#scoreAllListDiv").css("display", "none");
                        return;
                    }

                    $(".sbjctList").removeClass("on");
                    $(".sbjctList").filter("[data-sbjctId=" + sbjctId + "]").addClass("on");
                    $("#scoreAllListDiv").css("display", "block");

                    // 전체인원 최초1번 세팅
                    if ( !searchType && !$("#searchValue").val() ) {
                        if (!$("#totCnt").hasClass("init")) {
                            $("#totCnt").text(returnVO.totalCnt);
                            $("#totCnt").addClass("init")
                        }
                    }

                    // 해당 과목의 성적 반영비율 세팅
                    for (let i = 0; i < returnSubVO.length; i++) {
                        let subVO = returnSubVO[i];
                        let mrkRfltrt = Number(subVO.mrkRfltrt || 0);

                        switch (subVO.mrkItmTycd) {
                            case "MIDEXAM" :
                                midexamHead = mrkRfltrt;
                                if (mrkRfltrt != 0)  {ratioArr.push("midexamScore"); colCnt += 1;}
                                break;
                            case "LSTEXAM" :
                                lstexamHead = mrkRfltrt;
                                if (mrkRfltrt != 0)  {ratioArr.push("lstexamScore"); colCnt += 1;}
                                break;
                            case "ATNDC" :
                                atndcHead = mrkRfltrt;
                                if (mrkRfltrt != 0)  {ratioArr.push("atndcScore"); colCnt += 1;}
                                break;
                            case "ASMT" :
                                asmtHead = mrkRfltrt;
                                if (mrkRfltrt != 0)  {ratioArr.push("asmtScore"); colCnt += 1;}
                                break;
                            case "DSCS" :
                                dscsHead = mrkRfltrt;
                                if (mrkRfltrt != 0)  {ratioArr.push("dscsScore"); colCnt += 1;}
                                break;
                            case "QUIZ" :
                                quizHead = mrkRfltrt;
                                if (mrkRfltrt != 0)  {ratioArr.push("quizScore"); colCnt += 1;}
                                break;
                            case "SRVY" :
                                srvyHead = mrkRfltrt;
                                if (mrkRfltrt != 0)  {ratioArr.push("srvyScore"); colCnt += 1;}
                                break;
                            case "SMNR" :
                                smnrHead = mrkRfltrt;
                                if (mrkRfltrt != 0)  {ratioArr.push("smnrScore"); colCnt += 1;}
                                break;
                        }
                    }

                    // row 세팅
                    html += `
                        <div class="table-wrap">
                            <table class="table-type2" id="sTable">
                                <colgroup>
                                    <col style="width:50px">
                                    <col style="width:50px">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th data-sortable="false">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>
                                        </th>
                                        <th data-sortable="false">No</th>
                                        <th data-breakpoints="xs sm md" style="min-width:150px"><spring:message code="common.dept_name" /></th>
                                        <th data-breakpoints=""><spring:message code="common.label.student.number" /></th>
                                        <th data-breakpoints=""><spring:message code="common.name" /></th>
                    `;

                    for(const val of ratioArr) {
                        switch (val) {
                            case "midexamScore": // 중간고사
                                html += setScoreHeader("<spring:message code='forum.label.type.exam.M' />", midexamHead);
                                break;
                            case "lstexamScore":   // 기말고사
                                html += setScoreHeader("<spring:message code='forum.label.type.exam.L' />", lstexamHead);
                                break;
                            case "atndcScore": // 출석/강의
                                html += setScoreHeader("<spring:message code='crs.label.attend' /> / <spring:message code='dashboard.lesson' />", atndcHead);
                                break;
                            case "asmtScore": // 과제
                                html += setScoreHeader("<spring:message code='dashboard.cor.asmnt' />", asmtHead);
                                break;
                            case "dscsScore":  // 토론
                                html += setScoreHeader("<spring:message code='dashboard.cor.forum' />", dscsHead);
                                break;
                            case "quizScore":   // 퀴즈
                                html += setScoreHeader("<spring:message code='dashboard.cor.quiz' />", quizHead);
                                break;
                            case "srvyScore":   // 설문
                                html += setScoreHeader("<spring:message code='dashboard.cor.resch' />", srvyHead);
                                break;
                            case "smnrScore":
                                html += setScoreHeader("<spring:message code='dashboard.seminar' />", smnrHead);
                                break;
                        }
                    }

                    html += `
                                <th> 산출<br class="desktop-elem"><spring:message code="common.label.total.point" /> </th>
                                <th> 환산<br class="desktop-elem"><spring:message code="common.label.total.point" /></th>
                                <th name="etcDataTd" data-type="number"><spring:message code="common.label.total.include.point" /></th>
                                <th data-type="number"><spring:message code="common.label.final" /><br class="desktop-elem">점수 </th>
                                <th><spring:message code="score.manage.label" /></th>
                            </tr>
                        </thead>
                        <tbody>
                    `;

                    if (returnList.length <= 0) {
                        html += `<tr><td colspan="\${colCnt}"><spring:message code="common.nodata.msg"/></td></tr>`;
                    }

                    // 학생 성적 목록 프린트
                    $.each(returnList, function (i, vo) {
                        let atndcScore  = Number(vo.atndcScore) == "-1" ? "-" : Number(vo.atndcScore);
                        let midexamScore= Number(vo.midexamScore) == "-1" ? "-" : Number(vo.midexamScore);
                        let lstexamScore= Number(vo.lstexamScore) == "-1" ? "-" : Number(vo.lstexamScore);
                        let asmtScore   = Number(vo.asmtScore) == "-1" ? "-" : Number(vo.asmtScore);
                        let dscsScore   = Number(vo.dscsScore) == "-1" ? "-" : Number(vo.dscsScore);
                        let quizScore   = Number(vo.quizScore) == "-1" ? "-" : Number(vo.quizScore);
                        let srvyScore   = Number(vo.srvyScore) == "-1" ? "-" : Number(vo.srvyScore);
                        let etcScore    = Number(vo.etcScore);

                        let atndcScoreAvg   = Number(vo.atndcScoreAvg);
                        let midexamScoreAvg = Number(vo.midexamScoreAvg);
                        let lstexamScoreAvg = Number(vo.lstexamScoreAvg);
                        let testScoreAvg    = Number(vo.testScoreAvg);
                        let asmtScoreAvg    = Number(vo.asmtScoreAvg);
                        let dscsScoreAvg    = Number(vo.dscsScoreAvg);
                        let quizScoreAvg    = Number(vo.quizScoreAvg);
                        let srvyScoreAvg    = Number(vo.srvyScoreAvg);

                        let gradeSort = "0";

                        //todo: ???
                        if (vo.scoreStatus == "2") {
                            gradeSort = "z";

                        }else if (vo.scoreStatus == "3"){
                            gradeSort = vo.scoreGrade;

                            if (vo.scoreGrade.indexOf("+") > -1) {
                                gradeSort = vo.scoreGrade.replace("+", "0");
                            }else {
                                gradeSort = o.scoreGrade + "1";
                            }
                        }

                        let calTotScr = parseFloat((atndcScoreAvg + midexamScoreAvg + lstexamScoreAvg + asmtScoreAvg
                                                    + dscsScoreAvg + quizScoreAvg + srvyScoreAvg + smnrScoreAvg).toFixed(2));

                        calTotScr = calTotScr < 0 ? "-" : calTotScr;

                        let midTdColor = "";
                        let lastTdColor = "";

                        let green   = "bcGreenAlpha30";
                        let blue    = "bcBlueAlpha30";
                        let yellow  = "bcYellowAlpha30";
                        let greenYellow = "bcGreenYellowAlpha30";
                        let blueYellow = "bcBlueYellowAlpha30";

                        if (o.apprStatM) {
                            if (o.apprStatM == "APPLICATE" || o.apprStatM == "RAPPLICATE") {
                                midTdColor = green;
                            } else if (o.apprStatM == "APPROVE") {
                                midTdColor = blue;
                            }
                        }

                        if (o.apprStatL) {
                            if (o.apprStatL == "APPLICATE" || o.apprStatL == "RAPPLICATE") {
                                lastTdColor = green;
                            } else if (o.apprStatL == "APPROVE") {
                                lastTdColor = blue;
                            }
                        }

                        if (o.reExamYnM && o.reExamYnM == "Y") {
                            if (midTdColor == green) {
                                midTdColor = greenYellow;
                            } else if (midTdColor == blue) {
                                midTdColor = blueYellow;
                            } else {
                                midTdColor = yellow;
                            }
                        }

                        if (o.reExamYnL && o.reExamYnL == "Y") {
                            if (lastTdColor == green) {
                                lastTdColor = greenYellow;
                            } else if (lastTdColor == blue) {
                                lastTdColor = blueYellow;
                            } else {
                                lastTdColor = yellow;
                            }
                        }

                        html += `
                            <tr data-sort-user-no="\${o.userId}">
                                <td>
                                    <div class="ui checkbox">
                                        <input type="checkbox" readonly="readonly" name="list[\${i}].dataChk" tabindex="0" user_id="\${vo.userId}" user_nm="\${vo.userNm}" mobile="\${vo.userMobileNo}" email="\${vo.userEmail}">
                                        <label></label>
                                    </div>
                                </td>
                                <td name="lineNo">\${vo.lineNo}</td>
                                <td data-sort-value="\${vo.deptNm}"><span>\${vo.deptNm}</span></td>
                                <td data-sort-value="\${vo.stdntNo}"><span>\${vo.stdntNo}</span></td>
                                <td class="word_break_none tc" data-sort-value="A\${o.userId.padEnd(12, '0')}">
                                    <span>\${vo.usernm}</span>
                                    <input type="hidden" name="list[\${i}].stdntNo" value="\${vo.stdntNo}">
                                    <input type="hidden" name="list[\${i}].userId" value="\${vo.userId}">
                                    <!--<input type="hidden" name="list[\${i}].userMobileNo" value="\${vo.userMobileNo}">-->
                                    <!--<input type="hidden" name="list[\${i}].userEmail" value="\${vo.userEmail}">-->
                                    <input type="hidden" name="list[\${i}].lessonItemId" value="\${vo.lessonItemId}">
                                    <input type="hidden" name="list[\${i}].middleTestItemId" value="\${vo.middleTestItemId}">
                                    <input type="hidden" name="list[\${i}].lastTestItemId" value="\${vo.lastTestItemId}">
                                    <input type="hidden" name="list[\${i}].assignmentItemId" value="\${vo.assignmentItemId}">
                                    <input type="hidden" name="list[\${i}].forumItemId" value="\${vo.forumItemId}">
                                    <input type="hidden" name="list[\${i}].quizItemId" value="\${vo.quizItemId}">
                                    <input type="hidden" name="list[\${i}].reshItemId" value="\${vo.reshItemId}">
                                    <input type="hidden" name="list[\${i}].smnrItemId" value="\${vo.smnrItemId}">
                                    <input type="hidden" name="list[\${i}].rowStatus" value="N">
                                    <i class="xi-pen-o f120" onclick="setMemo('\${vo.userId}')" style="cursor:pointer" title="메모"></i>
                                </td>
                                <td class="word_break_none tc">\${vo.usernm}</td>
                        `;

                        let isTestNoJoinUser = false;

                        if (vo.midexamScore <= 0 && vo.lstexamScore <= 0) {
                            if (vo.middleTestUseYn == "Y" && vo.lastTestUseYn == "Y" && vo.middleTestNoYn == "Y" && vo.lastTestNoYn == "Y") {
                                isTestNoJoinUser = true;
                            } else if (vo.middleTestUseYn == "Y" && vo.lastTestUseYn == "N" && vo.middleTestNoYn == "Y") {
                                isTestNoJoinUser = true;
                            } else if (vo.middleTestUseYn == "N" && vo.lastTestUseYn == "Y" && vo.lastTestNoYn == "Y") {
                                isTestNoJoinUser = true;
                            }
                        }

                        for (const val of ratioArr) {
                            if (val == "midexamScore") {
                                let midNoEvalClass = vo.midNoEvalCnt > 0 ? 'bcRedAlpha30' : '';
                                let scoreInputColor = "";
                                let scoreTextColor = "fcBlue";

                                if (isTestNoJoinUser) {
                                    scoreInputColor = "fcRed";
                                    scoreTextColor = "fcRed";
                                }

                                html += `
                                    <td class='word_break_none \${midTdColor}' data-sort-value='getSortScore(\${midexamScore})'>
                                        <span name='chgSpanText'>\${midexamScore}</span>
                                        <div class='ui input w50' name='chgInputText'>
                                            <input type='text' name='list[\${i}].middleTestInput' class='inScore \${midNoEvalClass} \${scoreInputColor}'
                                                   value='\${midexamScore}' placeholder='0' inputmask="numeric" mask="999.99" maxVal="100">
                                        </div>
                                        <i class='right chevron icon f075 opacity5'></i>
                                `;

                                if (midexamScore > -1) {
                                    html += `<span class="\${scoreTextColor}">\${midexamScoreAvg}</span>`;
                                } else {
                                    html += `<a onclick="goCrsCreCtgr('minTest')"><span class="\${scoreTextColor}">-</span></a>`;
                                }

                                html += `
                                        <input type="hidden" name="list[\${i}].midexamScoreAvg" value="\${midexamScoreAvg}" placeholder="0">
                                    </td>
                                `;

                            } else if (val == "lstexamScore") {
                                let lastNoEvalClass = vo.lastNoEvalCnt > 0 ? 'bcRedAlpha30' : '';
                                let scoreInputColor = "";
                                let scoreTextColor = "fcBlue";

                                if (isTestNoJoinUser) {
                                    scoreInputColor = "fcRed";
                                    scoreTextColor = "fcRed";
                                }

                                html += `
                                    <td class='word_break_none \${lastTdColor}' data-sort-value='getSortScore(\${lstexamScore})'>
                                       <span name='chgSpanText'>\${lstexamScore} </span>
                                       <div class='ui input w50' name='chgInputText'>
                                            <input type='text' name='list[\${i}].lastTestInput' class='inScore \${lastNoEvalClass} \${scoreInputColor}'
                                                   value='\${lstexamScore}' placeholder='0' inputmask="numeric" mask="999.99" maxVal="100">
                                        </div>
                                       <i class='right chevron icon f075 opacity5'></i>
                                `;

                                if (lstexamScore > -1) {
                                    html += `       <span class='\${scoreTextColor}'>\${lstexamScoreAvg}</span>`;
                                } else {
                                    html += `       <a href='javascript:;' onclick='goCrsCreCtgr("lastTest")'><span class='\${scoreTextColor}'>-</span></a>`;
                                }

                                html += `
                                        <input type='hidden' name='list[\${i}].lstexamScoreAvg' value='\${lstexamScoreAvg}' placeholder='0'>
                                    </td>
                                `;

                            } else if (val == "atndcScore") {
                                isNoAttendUser = atndcScore === 0 ? true : false;
                                html += `
                                    <td class='word_break_none' data-sort-value='getSortScore(\${atndcScore})'>
                                       <span name='chgSpanText'>\${atndcScore}</span>
                                       <div class='ui input w50 tr' name='chgInputText'>
                                          \${atndcScore}
                                          <input type='hidden' name='list[\${i}].lessonInput' class='inScore' value='\${atndcScore}' placeholder='0' inputmask="numeric" mask="999.99" maxVal="100" readonly='readonly' />
                                       </div>
                                       <i class='right chevron icon f075 opacity5'></i>
                                       <span class='fcBlue'>\${atndcScoreAvg}</span>
                                       <input type='hidden' name='list[\${i}].atndcScoreAvg' value='\${atndcScoreAvg}' placeholder='0'>
                                    </td>
                                `;
                            } else if (val == "asmtScore") {
                                var asmntNoEvalClass = vo.asmntNoEvalCnt > 0 ? 'bcRedAlpha30' : '';

                                html += `
                                    <td class='word_break_none' data-sort-value='getSortScore(\${asmtScore})'>
                                       <span name='chgSpanText'>\${asmtScore}</span>
                                       <div class='ui input w50' name='chgInputText'>
                                            <input type='text' name='list[\${i}].assignmentInput' class='inScore \${asmntNoEvalClass}' value='\${asmtScore}' placeholder='0' inputmask="numeric" mask="999.99" maxVal="100">
                                       </div>
                                       <i class='right chevron icon f075 opacity5'></i>
                                `;
                                if (asmtScore > -1) {
                                    html += `       <span class='fcBlue'>\${asmtScoreAvg}</span>`;
                                } else {
                                    html += `       <a href='javascript:;' onclick='goCrsCreCtgr("asmt")'><span class='fcBlue'>-</span></a>`;
                                }
                                html += `
                                       <input type='hidden' name='list[\${i}].asmtScoreAvg' value='\${asmtScoreAvg}' placeholder='0'>
                                    </td>
                                `;
                            } else if (val == "dscsScore") {
                                let forumNoEvalClass = vo.forumNoEvalCnt > 0 ? 'bcRedAlpha30' : '';

                                html += `
                                    <td class='word_break_none' data-sort-value='getSortScore(\${dscsScore})'>
                                       <span name='chgSpanText'>\${dscsScore}</span>
                                       <div class='ui input w50' name='chgInputText'>
                                            <input type='text' name='list[\${i}].forumInput' class='inScore \${forumNoEvalClass}' value='\${dscsScore}' placeholder='0' inputmask="numeric" mask="999.99" maxVal="100">
                                       </div>
                                       <i class='right chevron icon f075 opacity5'></i>
                                `;
                                if (dscsScore > -1) {
                                    html += `       <span class='fcBlue'>\${dscsScoreAvg}</span>`;
                                } else {
                                    html += `       <a href='javascript:;' onclick='goCrsCreCtgr("forum")'><span class='fcBlue'>-</span></a>`;
                                }
                                html += `
                                       <input type='hidden' name='list[\${i}].dscsScoreAvg' value='\${dscsScoreAvg}' placeholder='0'>
                                    </td>
                                `;
                            } else if (val == "quizScore") {
                                let quizNoEvalClass = o.quizNoEvalCnt > 0 ? 'bcRedAlpha30' : '';

                                html += `
                                    <td class='word_break_none' data-sort-value='getSortScore(\${quizScore})'>
                                       <span name='chgSpanText'>\${quizScore}</span>
                                       <div class='ui input w50' name='chgInputText'>
                                            <input type='text' name='list[\${i}].quizInput' class='inScore \${quizNoEvalClass}' value='\${quizScore}' placeholder='0' inputmask="numeric" mask="999.99" maxVal="100">
                                       </div>
                                       <i class='right chevron icon f075 opacity5'></i>
                                `;
                                if (quizScore > -1) {
                                    html += `       <span class='fcBlue'>\${quizScoreAvg}</span>`;
                                } else {
                                    html += `       <a href='javascript:;' onclick='goCrsCreCtgr("quiz")'><span class='fcBlue'>-</span></a>`;
                                }
                                html += `
                                       <input type='hidden' name='list[\${i}].quizScoreAvg' value='\${quizScoreAvg}' placeholder='0' >
                                    </td>
                                `;
                            } else if (val == "srvyScore") {
                                let reschNoEvalClass = vo.reschNoEvalCnt > 0 ? 'bcRedAlpha30' : '';

                                html += `
                                    <td class='word_break_none' data-sort-value='getSortScore(\${srvyScore})'>
                                       <span name='chgSpanText'>\${srvyScore}</span>
                                       <div class='ui input w50' name='chgInputText'>
                                            <input type='text' name='list[\${i}].reshInput' class='inScore \${reschNoEvalClass}' value='\${srvyScore}' placeholder='0' maxlength='5' onKeyup="scoreValidation(this)">
                                       </div>
                                       <i class='right chevron icon f075 opacity5'></i>
                                `;
                                if (srvyScore > -1) {
                                    html += `       <span class='fcBlue'>\${srvyScoreAvg}</span>`;
                                } else {
                                    html += `       <a href='javascript:;' onclick='goCrsCreCtgr("resh")'><span class='fcBlue'>-</span></a>`;
                                }
                                html += `
                                       <input type='hidden' name='list[\${i}].srvyScoreAvg' value='\${srvyScoreAvg}' placeholder='0' >
                                    </td>
                                `;
                            }
                        }

                        html += `
                            <td class='tc' data-sort-value='getSortScore(\${calTotScr})'>
                               <span class='fcBlue'>\${calTotScr}</span>
                               <input type='hidden' name='list[\${i}].finalScore' value='\${calTotScr}' placeholder='0'>
                            </td>
                        `;

                        html += `<td data-sort-value='getSortScore(o.prvScore)'>`;

                        if (o.scoreStatus == "2") {
                            html += "-";
                        } else if (o.scoreStatus == "3") {
                            html += `   <span name='totScoreSpan'>\${o.prvScore}</span>`;
                            if (isNoAttendUser) {
                                html += `
                                    <div class='ui input w50 tr' name='totScoreDiv'>
                                        \${Number(o.prvScore)}
                                        <input type='hidden' name='list[\${i}].totScoreData' class='inScore' value='\${o.prvScore}' placeholder='0' inputmask="numeric" mask="999.99" maxVal="100" readonly='readonly' />
                                    </div>
                                `;
                            } else {
                                html += `
                                    <div class='ui input w50' name='totScoreDiv'>
                                        <input type='text' name='list[\${i}].totScoreData' class='inScore' value='\${o.prvScore}' placeholder='0' inputmask="numeric" mask="999.99" maxVal="100" data-tot-score-idx='\${i}' />
                                    </div>
                                `;
                            }
                        }
                        html += "</td>";

                        html += `
                            <td name='etcDataTd' data-sort-value='getSortScore(\${etcScore})'>
                                <span>\${etcScore}</span>
                            </td>
                        `;

                        html += `
                            <td name='etcDataTd' data-sort-value='getSortScore(\${vo.totScore})'>
                                <span>\${vo.totScore}</span>
                            </td>
                        `;

                        html += `<td data-sort-value='\${gradeSort}' data-grade-idx='\${i}'>`;
                        if (o.scoreStatus == "2") {
                            html += "-";
                        } else if (o.scoreStatus == "3") {
                            if (o.scoreGrade == "F") {
                                html += `<span class="fcRed fweb">\${vo.scoreGrade}</span>`;
                            } else {
                                html += vo.scoreGrade;
                            }
                        }
                        html += `</td>`;

                        $("#scoreStatus").val(vo.scoreStatus);

                        html += `
                                        <td>
                                            <a href="javascript:onScoreOverallDtlPop('\${vo.sbjctId}', '\${vo.userId}', '\${vo.stdntNo}');\">상세</a>
                                        </td>
                                    </tr>

                        `;
                    });

                    html += `
                            </tbody>
                        </table>
                    `;

                    let wh = $(window).height() - 250;
                    if (wh < 400) wh = 400;

                    $("#tableDiv").css("max-height", (wh) + "px");
                    $("#tableDiv").empty().html(html);
                },
                error: function(xhr, status, error) {
                    alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
                }
            });
        }

        function setScoreHeader(label, score) {
            return `<th class="">\${label}<br class="desktop-elem"><small>(\${score}%)</small></th>`;
        }
    </script>


    <input type="hidden" id="sUserId" name="sUserId" value="<c:out value="${sUserId}" />"/>

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

                        <div class="table-wrap">
                            <table class="table-type2" id="sbjctTable">
                                <colgroup>
                                    <col style="width: 50px">
                                    <col style="width: 50px">
                                    <col style="width: 50px">
                                    <col>
                                    <col>
                                    <col style="width: 15%">
                                    <col style="width: 20%">
                                    <col style="width: 50px">
                                    <col style="width: 50px">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th><spring:message code="common.no"/></th><!-- 번호 -->
                                        <th><spring:message code="common.year"/></th><!-- 년도 -->
                                        <th><spring:message code="common.term"/></th><!-- 학기 -->
                                        <th><spring:message code="common.label.org" /></th><!-- 기관 -->
                                        <th><spring:message code="common.dept_name"/></th><!-- 학과 -->
                                        <th><spring:message code="crs.open.course.code"/></th><!-- 개설과목코드 -->
                                        <th><spring:message code="crs.label.crecrs.nm"/></th><!-- 과목명 -->
                                        <th><spring:message code="common.label.decls.no"/></th><!-- 분반 -->
                                        <th><spring:message code="common.label.credit"/></th><!-- 학점 -->
                                        <th><spring:message code="crs.label.associate"/></th><!-- 공동교수 -->
                                        <th><spring:message code="common.label.tutor"/></th><!-- 튜터 -->
                                        <th><spring:message code="common.teaching.assistant"/></th><!-- 조교 -->
                                    </tr>
                                </thead>
                                <tbody id="sbjctTbody">
                                    <tr><td colspan="12">조회된 데이터가 없습니다.</td></tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- 성적처리 테이블 -->
                        <div id="scoreAllListDiv" style="display:none; margin-top: 50px">
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
                                        <button type="button" class="btn sm type4" name="chgButton2" id="btnSave">
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
                                        [ <spring:message code="exam.label.stare.user.cnt" /><!-- 대상인원 --><span id="listTotCnt">0</span> <spring:message code="forum.label.person" /><!-- 명 -->]
                                    </small>
                                </div>

                                <%--<script type="text/javascript">
                                    //초기화 방법 1__일반적인 형식
                                    $('#tabPopupF .item').tab();

                                    $(function () {
                                        $("#btnF").popup({
                                            popup: '#popupF',
                                            hoverable: true,
                                            position: 'left center',
                                            onShow: function () {
                                                $("#popupFTab1").trigger("click");
                                            }
                                        });
                                    });
                                </script>--%>

                            </div>

                            <form id="tableForm">
                                <input type="hidden" id="scoreStatus" name="scoreStatus"/>
                                <input type="hidden" id="sSbjctid" name="sSbjctid"  />
                                <div id="tableDiv" style="padding:0;margin:0 0 3px 0;border:1px solid var(--darkB);"></div>
                            </form>

                            <div class="row">
                                <div class="col">
                                    <div class="option-content gap4 header2">
                                        <div class="sec_head mra">
                                            <spring:message code="common.label.grade.chart"/>: <spring:message code="dashboard.all"/><!-- 성적 등급 분포도 : 전체 -->
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
            let data = {"subjectId" : $("#sSbjctid").val()};

            ajaxCall(url, data, function (data) {

                if (data.result > 0) {
                    let returnVO = data.returnVO;

                    if (returnVO ==  null) {
                        alert('<spring:message code="sys.alert.already.job.sch" />'); // 등록된 일정이 없습니다.
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

                        alert(msg);
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
    </script>

</body>

</html>
