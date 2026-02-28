<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>

<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>

<script type="text/javascript">
    $(document).ready(function () {
        if ("${vo.examType}" == "EXAM") {
            selectExam('M');
            selectExam('L');
        } else if ("${vo.examType}" == "ADMISSION") {
            listEtcExam();
        } else if ("${vo.examType}" == "DSBL") {
            listExamDsblReq();
            $("#dsblReqSearchValue").on("keyup", function (e) {
                if (e.keyCode == 13) {
                    listExamDsblReq();
                }
            });
        } else if ("${vo.examType}" == "ABSENT") {
            listExamAbsent();
            $("#absentSearchValue").on("keyup", function (e) {
                if (e.keyCode == 13) {
                    listExamAbsent();
                }
            });
        }
    });

    // 시험 수시평가 목록 조회
    function listEtcExam() {
        var url = "/exam/examListByEtc.do";
        var data = {
            "crsCreCd": "${vo.crsCreCd}",
            "examStareTypeCd": "A",
            "searchKey": "PROFESSOR"
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnList = data.returnList || [];
                var html = "";

                if (returnList.length > 0) {
                    returnList.forEach(function (v, i) {
                        var examStartDttm = v.examStartDttm != null ? dateFormat("date", v.examStartDttm) : "-";
                        var scoreOpenDttm = v.scoreOpenYn == "Y" && v.scoreOpenDttm != null ? dateFormat("date", v.scoreOpenDttm) : "-";
                        var scoreOpen = v.scoreOpenYn == "Y" ? "<spring:message code='exam.label.open.y' />"/* 공개 */ : "<spring:message code='exam.label.open.n' />";/* 비공개 */
                        var examSubmit = v.examSubmitYn == "Y" || v.examSubmitYn == "M" ? "<spring:message code='exam.label.qstn.submit.y' />"/* 출제완료 */ : "<spring:message code='exam.label.qstn.temp.save' />";/* 임시저장 */
                        var scoreRatio = v.scoreAplyYn == "Y" ? v.scoreRatio : "-";
                        var examTypeCd = v.examTypeCd == "QUIZ" ? "<spring:message code='exam.label.etc' />(<spring:message code='exam.label.quiz' />)"/* 기타 *//* 퀴즈 */ : v.examTypeCd == "ETC" ? "<spring:message code='exam.label.etc' />"/* 기타 */ : "<spring:message code='exam.label.real.time.exam' />"/* 실시간시험 */;
                        var examStareTm = v.examStareTm != null ? v.examStareTm : "0";
                        var checkYn = {
                            "Y": "",
                            "M": "",
                            "N": "class='fcRed'"
                        };
                        html += "<tr>";
                        html += "	<td class='tc'>" + v.lineNo + "</td>";
                        html += "	<td><a href='javascript:etcInfoView(\"EXAM\", \"" + v.examCd + "\", \"N\")' class='fcBlue'>" + v.examTitle + "</a></td>";
                        if (v.examTypeCd == "QUIZ") {
                            html += "	<td class='tc'><a href='javascript:etcInfoView(\"QUIZ\", \"" + v.insRefCd + "\", \"" + v.insDelYn + "\")' class='fcBlue'>" + examTypeCd + "</a></td>";
                        } else {
                            html += "	<td class='tc'><a href='javascript:;' class='fcBlue'>" + examTypeCd + "</a></td>";
                        }
                        html += "	<td class='tc'>";
                        if (v.scoreAplyYn == 'N') {
                            html += "			0%";
                        } else {
                            html += "			<div class='scoreInputDiv ui input'>";
                            html += "				<input type='number' class='scoreRatio w50' data-examCd=\"" + v.examCd + "\" value=\"" + scoreRatio + "\" />";
                            html += "			</div>";
                            html += "			<div class='scoreRatioDiv'>" + scoreRatio + "%</div>";
                        }
                        html += "	</td>";
                        html += "	<td class='tc'>" + examStartDttm + "</td>";
                        html += "	<td class='tc'>" + examStareTm + "<spring:message code='exam.label.stare.min' /></td>";/* 분 */
                        html += "	<td class='tc' " + checkYn[v.scoreOpenYn] + ">" + scoreOpen + "</td>";
                        html += "	<td class='tc'>" + scoreOpenDttm + "</td>";
                        if (v.examTypeCd == "EXAM") {
                            html += "	<td class='tc'>-</td>";
                        } else {
                            html += "	<td class='tc' " + checkYn[v.examSubmitYn] + ">" + examSubmit + "</td>";
                        }
                        html += "</tr>";
                    });
                }

                $("#examEtcList").empty().html(html);
                $("#examEtcListTable").footable();
                $("#examEtcListTable").parent("div").addClass("max-height-450");
                chgScoreRatio(0);
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
        });
    }

    // 성적 공개 변경
    function chgScoreOpen(obj) {
        var examCd = $(obj).val();
        var openYn = obj.checked ? "Y" : "N";
        var url = "/exam/editExamScoreOpen.do";
        var data = {
            "examCd": examCd,
            "scoreOpenYn": openYn,
            "gradeViewYn": openYn
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                listExam();
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='exam.error.score.open' />");/* 성적 공개 변경 중 에러가 발생하였습니다. */
        });
    }

    // 중간, 기말 시험 정보 가져오기
    function selectExam(type) {
        var url = "/exam/examCopy.do";
        var data = {
            "crsCreCd": "${vo.crsCreCd}",
            "examCtgrCd": "EXAM",
            "examStareTypeCd": type
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var html = ``;
                var examTypeNm = {
                    "M": "<spring:message code='exam.label.mid.exam' />",/* 중간고사 */
                    "L": "<spring:message code='exam.label.end.exam' />"/* 기말고사 */
                }
                html += `<div class="option-content">`;
                html += `	<h3 class="sec_head"> \${examTypeNm[type]} <spring:message code="exam.label.info" /></h3>`;/* 정보 */
                html += `	<div class="mla">`;
                if (data.returnVO != null && data.returnVO.examTypeCd == "EXAM") {
                    html += `		<a href="javascript:etsExamTaste('\${data.returnVO.examCd}')" class="ui blue small button"><spring:message code="exam.label.exam.taste" /></a>`;/* 시험 맛보기 */
                }
                html += `	</div>`;
                html += `</div>`;
                html += `<div class="ui segment flex1 flex flex-column mt0 test-wrap pb50">`;
                if (data.returnVO != null) {
                    var examVO = data.returnVO;
                    var examStareTm = examVO.examStareTm == null ? "-" : examVO.examStareTm;
                    var examTypeNmStr = examVO.examTypeCd == "EXAM" || examVO.examTypeCd == "ETC" ? examVO.examTypeNm : "<spring:message code='exam.label.etc' /> : " + examVO.examTypeNm;/* 기타 */
                    html += `<div class="option-content header2">`;
                    html += `	<p>[ \${examTypeNmStr} ] \${examVO.examTitle}</p>`;
                    html += `	<div class="mla">`;
                    if (examVO.examStartDttm != null && examVO.scoreRatio > 0) {
                        if (examVO.examTypeCd == "EXAM") {
                            html += `		<spring:message code="exam.button.stare.start" /> \${examVO.examJoinUserCnt}/\${examVO.examTotalUserCnt}`;/* 응시 */
                        }
                    }
                    if (examVO.examTypeCd == "ETC" && examVO.scoreRatio != 0) {
                        html += `		<a href="javascript:etcSetInsRef('\${examVO.examCd}', '\${examVO.examStareTypeCd}')" class="ui basic small button"><spring:message code="exam.label.subs.link" /></a>`;/* 평가요소 변경 */
                    }
                    if (examVO.examTypeCd != "EXAM" && examVO.insRefCd != null) {
                        html += `		<a href="javascript:etcResetInsRef('\${examVO.examCd}', '\${examVO.examTypeCd}', '\${examVO.insRefCd}', '\${examVO.examStareTypeCd}')" class="ui basic small button"><spring:message code="exam.label.subs.link.cancel" /></a>`;/* 평가요소 해제 */
                    }
                    html += `	</div>`;
                    html += `</div>`;
                    html += `<ul class="tbl-simple dt-sm" style="min-height:160.94px">`;
                    // 실시간 시험이 아니고 기타시험이 등록되지 않은 경우
                    if (examVO.scoreRatio == 0) {
                        html += `	<div class="flex-container m-hAuto">`;
                        html += `		<div class="no_content">`;
                        html += `			<span>평가 대상이 아닙니다.</span>`;
                        html += `		</div>`;
                        html += `	</div>`;
                    } else if (examVO.examStartDttm == null) {
                        html += `	<div class="flex-container m-hAuto">`;
                        html += `		<div class="no_content wmax">`;
                        if (examVO.examTypeCd == "ETC") {
                            html += `			<span>기타 (준비중)</span>`;
                        } else {
                            html += `			<span>실시간 시험 준비 중 ( 3주차 중 발표 예정 )</span>`;
                        }
                        html += `		</div>`;
                        html += `	</div>`;
                        if (examVO.examTypeCd == "ETC") {
                            html += `<div class="option-content pt10">`;
                            html += `	<a href="javascript:examEdit('\${type}', '\${examVO.examCd}')" class="ui blue small button mla">\${examTypeNm[type]} <spring:message code="exam.button.reg" /></a>`;/* 등록 */
                            html += `</div>`;
                        }
                    } else {
                        if (examVO.examTypeCd == "ETC" || (examVO.examTypeCd != "EXAM" && examVO.insRefCd == null)) {
                            html += `	<p class="flex-container m-hAuto"><spring:message code="exam.label.empty.exam" /></p>`;/* 등록된 시험 정보가 없습니다. */
                            // 실시간 시험인 경우
                        } else if (examVO.examTypeCd == "EXAM") {
                            var examStartDate = examVO.examStartDttm != null ? dateFormat("dateWeek", examVO.examStartDttm) : "-";
                            var openYn = {
                                "Y": "<spring:message code='exam.label.open.y' />"/* 공개 */,
                                "N": "<spring:message code='exam.label.open.n' />"/* 비공개 */
                            };
                            html += `	<li>`;
                            html += `		<dl>`;
                            html += `			<dt><label><spring:message code="exam.label.exam.dttm" /></label></dt>`;/* 시험일시 */
                            html += `			<dd>\${examStartDate}</dd>`;
                            html += `		</dl>`;
                            html += `	</li>`;
                            html += `	<li class="pt0">`;
                            html += `		<dl>`;
                            html += `			<dt><label><spring:message code="exam.label.exam.time" /></label></dt>`;/* 시험시간 */
                            html += `			<dd>\${examStareTm}<spring:message code="exam.label.min.time" /></dd>`;/* 분 */
                            html += `		</dl>`;
                            html += `	</li>`;
                            html += `	<li class="pt0">`;
                            html += `		<dl>`;
                            html += `			<dt><label><spring:message code="exam.label.open.yn" /></label></dt>`;/* 공개 여부 */
                            html += `			<dd>`;
                            html += `				<spring:message code="exam.label.grade.score" /> \${openYn[examVO.scoreOpenYn]} |`;/* 성적 */
                            html += `				<spring:message code="exam.label.paper" /> \${openYn[examVO.gradeViewYn]}`;/* 시험지 */
                            html += `			</dd>`;
                            html += `		</dl>`;
                            html += `	</li>`;
                            // 시험퀴즈, 시험토론, 시험과제 인경우
                        } else {
                            var insStartDttm = examVO.insStartDttm != null ? dateFormat("date", examVO.insStartDttm) : "-";
                            var insEndDttm = examVO.insEndDttm != null ? dateFormat("date", examVO.insEndDttm) : "-";
                            html += `	<li>`;
                            html += `		<dl>`;
                            html += `			<dt><label><spring:message code="exam.label.ins.ref.title" /></label></dt>`;/* 평가명 */
                            html += `			<dd><a class="fcBlue" href="javascript:insInfoView('\${examVO.examTypeCd}', '\${examVO.insRefCd}')">\${examVO.insRefNm}</a></dd>`;
                            html += `		</dl>`;
                            html += `	</li>`;
                            html += `	<li class="pt0">`;
                            html += `		<dl>`;
                            html += `			<dt><label><spring:message code="exam.label.submit.date" /></label></dt>`;/* 제출기간 */
                            html += `			<dd>\${insStartDttm} ~ \${insEndDttm}</dd>`;
                            html += `		</dl>`;
                            html += `	</li>`;
                            // 토론, 과제인경우
                            if (examVO.examTypeCd == "ASMNT" || examVO.examTypeCd == "FORUM") {
                                var extSendDttm = examVO.extSendDttm != null ? dateFormat("date", examVO.extSendDttm) : "-";
                                html += `	<li class="pt0">`;
                                html += `		<dl>`;
                                html += `			<dt><label><spring:message code="exam.label.ext.submit" /></label></dt>`;/* 지각제출 */
                                html += `			<dd>\${extSendDttm}</dd>`;
                                html += `		</dl>`;
                                html += `	</li>`;
                            }
                            html += `	<li class="pt0">`;
                            html += `		<dl>`;
                            html += `			<dt><label><spring:message code="exam.label.submission.status" /></label></dt>`;/* 제출현황 */
                            html += `			<dd>\${examVO.insJoinUserCnt}/\${examVO.examTotalUserCnt}</dd>`;
                            html += `		</dl>`;
                            html += `	</li>`;
                            html += `	<li>`;
                            html += `		<dl>`;
                            html += `			<dt><label><spring:message code="exam.label.eval.submit.cnt" /></label></dt>`;/* 평가된 인원수 / 제출인원수 */
                            html += `			<dd><a class="fcBlue cur_point" href="javascript:insInfoView('\${examVO.examTypeCd}', '\${examVO.insRefCd}')">\${examVO.insEvalUserCnt}/\${examVO.insJoinUserCnt}</a></dd>`;
                            html += `		</dl>`;
                            html += `	</li>`;
                        }
                    }
                    html += `</ul>`;
                    if (examVO.examStartDttm != null && examVO.scoreRatio > 0) {
                        html += `<div class="option-content mt10">`;
                        html += `	<div class="mla">`;
                        if (examVO.examTypeCd == "QUIZ" && examVO.insSubmitYn != "Y" && examVO.insRefCd != null) {
                            html += `		<a href="javascript:quizQstnManage('\${examVO.insRefCd}')" class="ui basic small button"><spring:message code="eaxm.tab.qstn.manage" /></a>`;/* 문제 관리 */
                        }
                        if ((examVO.examTypeCd == "QUIZ" || examVO.examTypeCd == "ASMNT" || examVO.examTypeCd == "FORUM") && examVO.insRefCd != null) {
                            html += `		<a href="javascript:viewExamScore('\${examVO.examTypeCd}', '\${examVO.insRefCd}')" class="ui blue small button"><spring:message code="exam.button.eval" /></a>`;/* 평가하기 */
                        } else if ((examVO.examTypeCd == "EXAM" && (examVO.insRefCd == null || examVO.insRefCd == "")) || examVO.examTypeCd == "ETC" || (examVO.examTypeCd != "EXAM" && examVO.insRefCd == null)) {
                            html += `		<a href="javascript:examEdit('\${type}', '\${examVO.examCd}')" class="ui blue small button"><spring:message code="exam.label.sub" /><spring:message code="exam.tab.eval" /> <spring:message code="exam.button.reg" /></a>`;/* 대체 *//* 평가 *//* 등록 */
                        }
                        html += `	</div>`;
                        html += `</div>`;
                    }
                    // 대체 퀴즈, 토론, 과제가 있는 경우
                    if (examVO.examTypeCd == "EXAM" && examVO.insRefCd != null && examVO.insRefCd != "" && examVO.insDelYn == "N") {
                        var insTypeCd = examVO.insRefCd.split("_")[0];
                        insTypeCd = insTypeCd == "EXAM" ? "QUIZ" : insTypeCd;
                        var insTypeNm = insTypeCd == "QUIZ" ? "퀴즈" : insTypeCd == "ASMNT" ? "과제" : insTypeCd == "FORUM" ? "토론" : "-";
                        insTypeNm = insTypeNm != "-" ? "<spring:message code='exam.label.subs' /> : " + insTypeNm : insTypeNm;/* 대체평가 */
                        html += `</div>`;
                        html += `<div class="ui segment flex1 flex flex-column mt0 test-wrap">`;
                        html += `<div class="option-content header2">`;
                        html += `	<p>[ \${insTypeNm} ]</p>`;
                        html += `	<div class="mla">`;
                        html += `		<button class="ui blue small button" onclick="examEdit('\${type}', '\${examVO.examCd}')"><spring:message code="exam.button.mod" /></button>`;/* 수정 */
                        html += `		<button class="ui basic small button" onclick="insRefDelete('\${type}', '\${examVO.examCd}')"><spring:message code="exam.button.del" /></button>`;/* 삭제 */
                        html += `	</div>`;
                        html += `</div>`;
                        html += `<ul class="tbl-simple dt-sm">`;
                        var insStartDttm = examVO.insStartDttm != null ? dateFormat("date", examVO.insStartDttm) : "-";
                        var insEndDttm = examVO.insEndDttm != null ? dateFormat("date", examVO.insEndDttm) : "-";
                        html += `	<li>`;
                        html += `		<dl>`;
                        html += `			<dt><label><spring:message code="exam.label.ins.ref.title" /></label></dt>`;/* 평가명 */
                        html += `			<dd><a class="fcBlue" href="javascript:insInfoView('\${insTypeCd}', '\${examVO.insRefCd}')">\${examVO.insRefNm}</a></dd>`;
                        html += `		</dl>`;
                        html += `	</li>`;
                        html += `	<li class="pt0">`;
                        html += `		<dl>`;
                        html += `			<dt><label><spring:message code="exam.label.submit.date" /></label></dt>`;/* 제출기간 */
                        html += `			<dd>\${insStartDttm} ~ \${insEndDttm}</dd>`;
                        html += `		</dl>`;
                        html += `	</li>`;
                        // 토론, 과제인경우
                        if (examVO.examTypeCd == "ASMNT" || examVO.examTypeCd == "FORUM") {
                            var extSendDttm = examVO.extSendDttm != null ? dateFormat("date", examVO.extSendDttm) : "-";
                            html += `	<li class="pt0">`;
                            html += `		<dl>`;
                            html += `			<dt><label><spring:message code="exam.label.ext.submit" /></label></dt>`;/* 지각제출 */
                            html += `			<dd>\${extSendDttm}</dd>`;
                            html += `		</dl>`;
                            html += `	</li>`;
                        }
                        html += `	<li class="pt0">`;
                        html += `		<dl>`;
                        html += `			<dt><label><spring:message code="exam.label.submission.status" /></label></dt>`;/* 제출현황 */
                        html += `			<dd>\${examVO.insJoinUserCnt}/\${examVO.examSubsTotalCnt}</dd>`;
                        html += `		</dl>`;
                        html += `	</li>`;
                        html += `	<li>`;
                        html += `		<dl>`;
                        html += `			<dt><label><spring:message code="common.label.eval" /></label></dt>`;/* 평가 */
                        html += `			<dd><a class="fcBlue cur_point" href="javascript:insInfoView('\${insTypeCd}', '\${examVO.insRefCd}')">\${examVO.insEvalUserCnt}/\${examVO.insJoinUserCnt}</a></dd>`;
                        html += `		</dl>`;
                        html += `	</li>`;
                        html += `</ul>`;
                        html += `<div class="option-content mt10">`;
                        html += `	<div class="mla">`;
                        if (examVO.insSubmitYn != "Y") {
                            html += `		<a href="javascript:quizQstnManage('\${examVO.insRefCd}')" class="ui basic small button"><spring:message code="eaxm.tab.qstn.manage" /></a>`;/* 문제 관리 */
                        }
                        html += `		<a href="javascript:viewExamScore('\${insTypeCd}', '\${examVO.insRefCd}')" class="ui blue small button"><spring:message code="exam.button.eval" /></a>`;/* 평가하기 */
                        html += `	</div>`;
                        html += `</div>`;
                    }
                } else {
                    var typeNm = type == "M" ? "<spring:message code='exam.label.mid.exam' />"/* 중간고사 */ : "<spring:message code='exam.label.end.exam' />"/* 기말고사 */;
                    html += `<div class="option-content header2">`;
                    html += `	[ - ] \${typeNm}`;
                    html += `</div>`;
                    html += `<div class="flex-container m-hAuto">`;
                    html += `	<div class="no_content">`;
                    html += `		<i class="icon-cont-none ico f170"></i>`;
                    html += `		<span><spring:message code="exam.common.empty" /></span>`;/* 등록된 내용이 없습니다. */
                    html += `	</div>`;
                    html += `</div>`;
                    //if("${orgId}" != "ORG0000001") {
                    //html += `<div class="option-content mt10">`;
                    //html += `	<a href="javascript:examWrite('\${type}')" class="ui basic small button mla">\${examTypeNm[type]} <spring:message code="exam.button.reg" /></a>`;/* 등록 */
                    //html += `</div>`;
                    //}
                }
                html += `</div>`;
                if (type == "M") {
                    $("#midExamDiv").empty().html(html);
                } else if (type == "L") {
                    $("#endExamDiv").empty().html(html);
                }
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
        });
    }

    // 중간/기말 삭제
    function insRefDelete(examStareTypeCd, examCd) {
        var url = "/exam/delExam.do";
        var data = {
            "examCd": examCd,
            "examStareTypeCd": examStareTypeCd,
            "searchKey": "insRef"
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                location.reload();
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='exam.error.delete' />");/* 삭제 중 에러가 발생하였습니다. */
        });
    }

    // 결시원 목록 조회
    function listExamAbsent() {
        var univGbn = "${creCrsVO.univGbn}";
        var url = "/exam/examAbsentList.do";
        var data = {
            "crsCreCd": "${vo.crsCreCd}",
            "examStareTypeCd": $("#absentStareType").val(),
            "apprStat": $("#absentApprStat").val(),
            "searchValue": $("#absentSearchValue").val(),
            /* "searchTo"		  : "ONE" */
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnList = data.returnList || [];
                var html = "";
                var userIds = $("#absentUserIds").val().split(",");

                if (returnList.length > 0) {
                    returnList.forEach(function (v, i) {
                        var isChecked = false;
                        if (userIds != "") {
                            userIds.forEach(function (vv, ii) {
                                if (vv == v.userId) {
                                    isChecked = true;
                                }
                            });
                        }
                        var regDttm = v.regDttm != null ? dateFormat("date", v.regDttm) : "-";
                        var modDttm = v.apprStat == "APPLICATE" || v.apprStat == "RAPPLICATE" ? "-" : dateFormat("date", v.modDttm);
                        var modNm = v.apprStat == "APPLICATE" || v.apprStat == "RAPPLICATE" ? "-" : v.modNm;
                        var apprStatNm = v.apprStat == "APPLICATE" ? "<spring:message code='exam.label.applicate' />"/* 신청 */ : v.apprStat == "RAPPLICATE" ? "<span class='fcRed'><spring:message code='exam.label.rapplicate' /></span>"/* 재신청 */ : v.apprStat == "APPROVE" ? "<spring:message code='exam.label.approve' />"/* 승인 */ : v.apprStat == "COMPANION" ? "<spring:message code='exam.label.companion' />"/* 반려 */ : "";

                        var examStareTypeNm = "";

                        if (v.examStareTypeCd == "M") {
                            examStareTypeNm = '<span class="fcGreen"><spring:message code="exam.label.mid.exam" /></span>';
                        } else if (v.examStareTypeCd == "L") {
                            examStareTypeNm = '<span class="fcBrown"><spring:message code="exam.label.end.exam" /></span>';
                        }

                        var color = "";

                        if (v.apprStat == "APPLICATE" || v.apprStat == "RAPPLICATE") {
                            color = "fcBlue";
                        } else if (v.apprStat == "APPROVE") {
                            color = "fcGreen";
                        } else if (v.apprStat == "COMPANION") {
                            color = "fcRed";
                        }

                        html += `<tr>`;
                        html += `	<td class='tc'>`;
                        html += `		<div class='ui checkbox'>`;
                        html += `			<input type='checkbox' name='absentChk' id='absentChk\${i}' data-userId='\${v.userId}' onchange="checkUserIdToggle(this, 'absent')" \${isChecked ? 'checked' : ''} user_id='\${v.userId}' user_nm='\${v.userNm}' mobile='\${v.mobileNo}' email='\${v.email}'>`;
                        html += `			<label class='toggle_btn' for='absentChk\${i}'>\${v.lineNo}</label>`;
                        html += `		</div>`;
                        html += `	</td>`;
                        html += `	<td class='tc'>\${v.deptNm}</td>`;
                        html += `	<td class='tc'>\${v.userId}</td>`;
                        if (univGbn == "3" || univGbn == "4") {
                            html += '<td class="tc word_break_none">' + (v.grscDegrCorsGbnNm || '-') + '</td>';
                        }
                        html += `	<td class='tc word_break_none'>`;
                        html += `		\${v.userNm}`;
                        html += userInfoIcon("<%=SessionInfo.isKnou(request)%>", "userInfoPop('" + v.userId + "')");
                        html += `	</td>`;
                        html += `	<td class='tc \${color}'>\${apprStatNm}</td>`;
                        html += `	<td class='tc'>\${regDttm}</td>`;
                        html += `	<td class='tc'>\${examStareTypeNm}</td>`;
                        html += `	<td class='tc'>\${v.examStareYn}</td>`;
                        html += `	<td class='tc'>\${modDttm}</td>`;
                        html += `	<td class='tc'>\${modNm}</td>`;
                        html += `	<td class='tc'>`;
                        if (v.apprStat == "APPLICATE" || v.apprStat == "RAPPLICATE") {
                            html += `		<button type='button' class='ui basic small button' onclick="viewExamAbsent('\${v.examAbsentCd}', '\${v.stdNo}')">처리하기</button>`;
                        }
                        html += `		<button type='button' class='ui basic small button' onclick="viewExamAbsentList('\${v.stdNo}')">신청이력</button>`;
                        html += `	</td>`;
                        html += `</tr>`;
                    });
                }

                $("#examAbsentList").empty().html(html);
                $("#examAbsentCnt").text(returnList.length);
                $("#absentListTable").footable();
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
        });
    }

    // 장애 지원 신청 목록 조회
    function listExamDsblReq() {
        var univGbn = "${creCrsVO.univGbn}";
        var url = "/exam/allExamDsblReqList.do";
        var data = {
            crsCreCd: "${vo.crsCreCd}",
            creYear: "${creCrsVO.creYear}",
            creTerm: "${creCrsVO.creTerm}",
            apprStat: ($("#dsblApprStat").val() || "").replace("ALL", ""),
            examStareTypeCd: ($("#dsblExamStareTypeCd").val() || "").replace("ALL", ""),
            searchValue: $("#dsblReqSearchValue").val()
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnList = data.returnList || [];
                var html = "";
                var userIds = $("#dsblReqUserIds").val().split(",");

                if (returnList.length > 0) {
                    returnList.forEach(function (v, i) {
                        var cancelStat = v.disabilityCancelGbn == null ? "-" : v.disabilityCancelGbn == "APPLICATE" ? "<spring:message code='exam.label.applicate' />"/* 신청 */ : "<spring:message code='exam.label.approve' />"/* 승인 */;
                        var isChecked = false;
                        if (userIds != "") {
                            userIds.forEach(function (vv, ii) {
                                if (vv == v.userId) {
                                    isChecked = true;
                                }
                            });
                        }

                        var appliExamList = [];
                        var examReqList = [];
                        var addTimeList = [];

                        if (v.disablilityExamYn == "Y") {
                            if (v.midExamYn == "Y") {
                                appliExamList.push("<spring:message code='exam.label.mid' />"); // 중간
                                examReqList.push("<spring:message code='exam.label.time.late' />"); //시간연장
                            }

                            if (v.lastExamYn == "Y") {
                                appliExamList.push("<spring:message code='exam.label.final' />"); // 기말
                                examReqList.push("<spring:message code='exam.label.time.late' />"); //시간연장
                            }

                            if (v.midApprStat || v.endApprStat) {
                                if (v.midExamYn == "Y") {
                                    addTimeList.push("<spring:message code='exam.label.late' />(" + v.midAddTime + "<spring:message code='exam.label.stare.min' />)"); // 연장 분
                                }

                                if (v.lastExamYn == "Y") {
                                    addTimeList.push("<spring:message code='exam.label.late' />(" + v.endAddTime + "<spring:message code='exam.label.stare.min' />)"); // 연장 분
                                }
                            }
                        }

                        html += `<tr>`;
                        html += `	<td class='tc'>`;
                        html += `		<div class='ui checkbox'>`;
                        html += `			<input type='checkbox' name='dsblReqChk' id='dsblReqChk\${i}' data-userId='\${v.userId}' onchange="checkUserIdToggle(this, 'dsblReq')" \${isChecked ? 'checked' : ''} user_id='\${v.userId}' user_nm='\${v.userNm}' mobile='\${v.mobileNo}' email='\${v.email}'>`;
                        html += `			<label class='toggle_btn' for='dsblReqChk\${i}'></label>`;
                        html += `		</div>`;
                        html += `	</td>`;
                        html += `	<td class='tc'>\${v.lineNo}</td>`;
                        html += `	<td class='tc'>\${v.deptNm}</td>`;
                        html += `	<td class='tc'>\${v.userId}</td>`;
                        if (univGbn == "3" || univGbn == "4") {
                            html += '<td class="tc">' + (v.grscDegrCorsGbnNm || '-') + '</td>';
                        }
                        html += `	<td class='tc word_break_none'>`;
                        if (v.disablilityExamYn == "Y") {
                            html += `		<a class="fcBlue" href="javascript:viewExamDsblReq('\${v.stdNo}', '\${v.crsCreCd}', '\${v.dsblReqCd}')">\${v.userNm}</a>`;
                        } else {
                            html += `		\${v.userNm}`;
                        }
                        html += userInfoIcon("<%=SessionInfo.isKnou(request)%>", "userInfoPop('" + v.userId + "')");
                        html += `	</td>`;
                        html += `	<td class='tc'>\${v.crsCreNm}</td>`;
                        html += `	<td class='tc'>\${v.declsNo}</td>`;
                        html += `	<td class='tc'>\${v.schregGbn ? v.schregGbn : '-'}</td>`;
                        html += `	<td class='tc'>\${v.disabilityCdNm}</td>`;
                        html += `	<td class='tc'>\${v.disabilityLvNm}</td>`;
                        html += '	<td>' + (appliExamList.join("/") || "-") + '</td>';
                        html += '	<td>' + (examReqList.join("/") || "-") + '</td>';
                        html += '	<td>' + (addTimeList.join("/") || "-") + '</td>';
                        html += `	<td class="tc">\${cancelStat}</td>`;
                        html += `</tr>`;
                    });
                }

                $("#examDsblReqList").empty().html(html);
                $("#examDsblReqCnt").text(returnList.length);
                $("#dsblReqListTable").footable();
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
        });
    }

    // 중간/기말 참여현황 목록
    function examStareJoinList() {
        var kvArr = [];
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'examType', 'val': "${vo.examType}"});

        submitForm("/exam/Form/examStareJoinList.do", "", "", kvArr);
    }

    // 서약서 제출 목록
    function viewPledgeList(examCd) {
        var kvArr = [];
        kvArr.push({'key': 'examCd', 'val': examCd});
        kvArr.push({'key': 'oathCd', 'val': ""});
        kvArr.push({'key': 'stdNo', 'val': ""});
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'searchKey', 'val': "VIEW"});

        submitForm("/exam/examOathPop.do", "examPopIfm", "examOathList", kvArr);
    }

    // 결시원 신청 정보 팝업
    function viewExamAbsent(examAbsentCd, stdNo) {
        var kvArr = [];
        kvArr.push({'key': 'stdNo', 'val': stdNo});
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'examAbsentCd', 'val': examAbsentCd});
        kvArr.push({'key': 'termCd', 'val': "${termVO.termCd}"});

        submitForm("/exam/examAbsentViewPop.do", "examPopIfm", "absent", kvArr);
    }

    // 결시원 신청이력
    function viewExamAbsentList(stdNo) {
        var kvArr = [];
        kvArr.push({'key': 'stdNo', 'val': stdNo});
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});

        submitForm("/exam/examAbsentListPop.do", "examPopIfm", "absentApplHsty", kvArr);
        $("#examPop > div.modal-dialog").addClass("modal-extra-lg");
    }

    // 지원 신청 정보 팝업
    function viewExamDsblReq(stdNo, crsCreCd, dsblReqCd) {
        var url = "/jobSchHome/viewSysJobSch.do";
        var data = {
            "crsCreCd": crsCreCd,
            "calendarCtgr": "00190806", // 시험지원요청(교수)
            "termCd": "${termVO.termCd}"
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnVO = data.returnVO;
                if (returnVO != null) {
                    var jobSchPeriodYn = returnVO.jobSchPeriodYn;
                    var jobSchExcPeriodYn = returnVO.jobSchExcPeriodYn;

                    if (jobSchPeriodYn == "Y" || jobSchExcPeriodYn == "Y") {
                        var kvArr = [];
                        kvArr.push({'key': 'stdNo', 'val': stdNo});
                        kvArr.push({'key': 'dsblReqCd', 'val': dsblReqCd});
                        kvArr.push({'key': 'crsCreCd', 'val': crsCreCd});

                        submitForm("/exam/viewExamDsblReqPop.do", "examPopIfm", "dsblReq", kvArr);
                    } else {
                        alert("<spring:message code='exam.alert.dsbl.req.approve.not.datetime' />"); // 시험지원 승인은 승인기간 안에만 가능합니다.
                    }
                } else {
                    alert("<spring:message code='sys.alert.already.job.sch' />"); // 등록된 일정이 없습니다.
                }
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='exam.error.info' />"); // 정보 조회 중 에러가 발생하였습니다.
        });
    }

    // 시험 등록 폼
    function examWrite(examStareTypeCd) {
        var kvArr = [];
        kvArr.push({'key': 'examStareTypeCd', 'val': examStareTypeCd});
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'examType', 'val': "${vo.examType}"});

        submitForm("/exam/Form/examWrite.do", "", "", kvArr);
    }

    // 시험 수정 폼
    function examEdit(examStareTypeCd, examCd) {
        var kvArr = [];
        kvArr.push({'key': 'examCd', 'val': examCd});
        kvArr.push({'key': 'examStareTypeCd', 'val': examStareTypeCd});
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'examType', 'val': "${vo.examType}"});

        submitForm("/exam/Form/examEdit.do", "", "", kvArr);
    }

    // 응시현황/평가 화면
    function viewExamScore(examTypeCd, insRefCd) {
        var typeMap = {
            "QUIZ": {"url": "/quiz/quizScoreManage.do", "code": "examCd"},
            "ASMNT": {"url": "/asmtprofAsmtEvlView.do", "code": "asmntCd"},
            "FORUM": {"url": "/forum/forumLect/Form/scoreManage.do", "code": "forumCd"}
        };

        var kvArr = [];
        kvArr.push({'key': typeMap[examTypeCd]["code"], 'val': insRefCd});
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});

        submitForm(typeMap[examTypeCd]["url"], "", "", kvArr);
    }

    // 장애인 시험지원 엑셀 다운로드
    function examDsblReqExcelDown() {
        var univGbn = "${creCrsVO.univGbn}";
        var excelGrid = {colModel: []};

        excelGrid.colModel.push({label: 'No.', name: 'lineNo', align: 'center', width: '1000'}); // No.
        excelGrid.colModel.push({
            label: "<spring:message code='exam.label.dept' />",
            name: 'deptNm',
            align: 'left',
            width: '5000'
        }); // 학과
        excelGrid.colModel.push({
            label: "<spring:message code='exam.label.user.no' />",
            name: 'userId',
            align: 'left',
            width: '5000'
        }); // 학번
        if (univGbn == "3" || univGbn == "4") {
            excelGrid.colModel.push({
                label: '<spring:message code="common.label.grsc.degr.cors.gbn" />',
                name: 'grscDegrCorsGbnNm',
                align: 'left',
                width: '4000'
            }); // 학위과정
        }
        excelGrid.colModel.push({
            label: "<spring:message code='exam.label.user.nm' />",
            name: 'userNm',
            align: 'left',
            width: '5000'
        }); // 이름
        excelGrid.colModel.push({
            label: "<spring:message code='crs.label.crecrs.nm' />",
            name: 'crsCreNm',
            align: 'left',
            width: '5000'
        }); // 과목명
        excelGrid.colModel.push({
            label: "<spring:message code='crs.label.decls' />",
            name: 'declsNo',
            align: 'center',
            width: '5000'
        }); // 분반
        excelGrid.colModel.push({
            label: "<spring:message code='exam.label.academic.status' />",
            name: 'schregGbn',
            align: 'left',
            width: '5000'
        }); // 학적상태
        excelGrid.colModel.push({
            label: "<spring:message code='exam.label.dsbl.req.type' />",
            name: 'disabilityCdNm',
            align: 'left',
            width: '5000'
        }); // 장애종류
        excelGrid.colModel.push({
            label: "<spring:message code='exam.label.dsbl.req.degree' />",
            name: 'disabilityLvNm',
            align: 'left',
            width: '5000'
        }); // 장애정도
        excelGrid.colModel.push({
            label: "<spring:message code='exam.label.late.time.mid.exam' />",
            name: 'midAddTime',
            align: 'center',
            width: '5000'
        }); // 연장시간(분) 중간고사
        excelGrid.colModel.push({
            label: "<spring:message code='exam.label.late.time.end.exam' />",
            name: 'endAddTime',
            align: 'center',
            width: '5000'
        }); // 연장시간(분) 기말고사


        var kvArr = [];
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'apprStat', 'val': ($("#dsblApprStat").val() || "").replace("ALL", "")});
        kvArr.push({'key': 'examStareTypeCd', 'val': ($("#dsblExamStareTypeCd").val() || "").replace("ALL", "")});
        kvArr.push({'key': 'searchValue', 'val': $("#dsblReqSearchValue").val()});
        kvArr.push({'key': 'excelGrid', 'val': JSON.stringify(excelGrid)});

        submitForm("/exam/examDsblReqExcelDown.do", "", "", kvArr);
    }

    // 결시원 엑셀 다운로드
    function examAbsentExcelDown() {
        var univGbn = "${creCrsVO.univGbn}";
        var excelGrid = {colModel: []};

        excelGrid.colModel.push({label: 'No.', name: 'lineNo', align: 'center', width: '1000'}); // No.
        excelGrid.colModel.push({
            label: "<spring:message code='exam.label.dept' />",
            name: 'deptNm',
            align: 'left',
            width: '5000'
        }); // 학과
        excelGrid.colModel.push({
            label: "<spring:message code='exam.label.user.no' />",
            name: 'userId',
            align: 'left',
            width: '5000'
        }); // 학번
        if (univGbn == "3" || univGbn == "4") {
            excelGrid.colModel.push({
                label: '<spring:message code="common.label.grsc.degr.cors.gbn" />',
                name: 'grscDegrCorsGbnNm',
                align: 'left',
                width: '4000'
            }); // 학위과정
        }
        excelGrid.colModel.push({
            label: "<spring:message code='exam.label.user.nm' />",
            name: 'userNm',
            align: 'right',
            width: '5000'
        }); // 이름
        excelGrid.colModel.push({
            label: "<spring:message code='crs.label.crecrs.nm' />",
            name: 'crsCreNm',
            align: 'right',
            width: '5000'
        }); // 과목명
        excelGrid.colModel.push({
            label: "<spring:message code='crs.label.decls' />",
            name: 'declsNo',
            align: 'right',
            width: '5000'
        }); // 분반
        excelGrid.colModel.push({
            label: "<spring:message code='exam.label.process.status' />",
            name: 'apprStat',
            align: 'right',
            width: '5000',
            codes: {
                APPLICATE: "<spring:message code='exam.label.applicate' />",
                RAPPLICATE: "<spring:message code='exam.label.rapplicate' />",
                APPROVE: "<spring:message code='exam.label.approve' />",
                COMPANION: "<spring:message code='exam.label.companion' />"
            }
        }); // 처리상태
        excelGrid.colModel.push({
            label: "<spring:message code='exam.label.applicate.dt' />",
            name: 'regDttm',
            align: 'right',
            width: '5000'
        }); // 신청일
        excelGrid.colModel.push({
            label: "<spring:message code='exam.label.exam.stare.type' />",
            name: 'examStareTypeNm',
            align: 'right',
            width: '5000'
        }); // 시험구분
        excelGrid.colModel.push({
            label: "<spring:message code='exam.label.real.time.exam.answer.yn' />",
            name: 'examStareYn',
            align: 'right',
            width: '5000'
        }); // 실시간시험응시여부
        excelGrid.colModel.push({
            label: "<spring:message code='exam.label.process.dttm' />",
            name: 'modDttm',
            align: 'right',
            width: '5000'
        }); // 처리일시
        excelGrid.colModel.push({
            label: "<spring:message code='exam.label.process.manage' />",
            name: 'modNm',
            align: 'right',
            width: '5000'
        }); // 처리담당자


        var kvArr = [];
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'examStareTypeCd', 'val': $("#absentStareType").val()});
        kvArr.push({'key': 'apprStat', 'val': $("#absentApprStat").val()});
        kvArr.push({'key': 'searchValue', 'val': $("#absentSearchValue").val()});
        kvArr.push({'key': 'excelGrid', 'val': JSON.stringify(excelGrid)});

        submitForm("/exam/examAbsentExcelDown.do", "", "", kvArr);
    }

    // 대체 과제 정보 페이지
    function insInfoView(type, code) {
        var typeMap = {
            "QUIZ": {"url": "/quiz/quizScoreManage.do", "code": "examCd"},
            "ASMNT": {"url": "/asmtprofAsmtEvlView.do", "code": "asmntCd"},
            "FORUM": {"url": "/forum/forumLect/Form/scoreManage.do", "code": "forumCd"}
        }

        var kvArr = [];
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': typeMap[type]["code"], 'val': code});

        submitForm(typeMap[type]["url"], "", "", kvArr);
    }

    // 수시평가 정보 페이지
    function etcInfoView(type, examCd, delYn) {
        if (type == "QUIZ" && delYn == "Y") {
            alert("<spring:message code='exam.alert.already.quiz.reg' />");/* 퀴즈가 등록되어 있지 않습니다. */
            return false;
        } else {
            var urlMap = {
                "EXAM": "/exam/examInfoManage.do",
                "QUIZ": "/quiz/quizScoreManage.do"
            };

            var examType = type == "EXAM" ? "ADMISSION" : "";
            var kvArr = [];
            kvArr.push({'key': 'examCd', 'val': examCd});
            kvArr.push({'key': 'examType', 'val': examType});
            kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});

            submitForm(urlMap[type], "", "", kvArr);
        }
    }

    // 전체 선택 / 해제
    function checkAllUserIdToggle(obj, type) {
        $("input:checkbox[name=" + type + "Chk]").prop("checked", $(obj).is(":checked"));

        $('input:checkbox[name=' + type + 'Chk]').each(function (idx) {
            if ($(obj).is(":checked")) {
                addSelectedUserIds($(this).attr("data-userId"), type);
                $("input:checkbox[name=" + type + "Chk]").closest("tr").addClass("on");
            } else {
                removeSelectedUserIds($(this).attr("data-userId"), type);
                $("input:checkbox[name=" + type + "Chk]").closest("tr").removeClass("on");
            }
        });
    }

    // 한건 선택 / 해제
    function checkUserIdToggle(obj, type) {
        if ($(obj).is(":checked")) {
            addSelectedUserIds($(obj).attr("data-userId"), type);
            $(obj).closest("tr").addClass("on");
        } else {
            removeSelectedUserIds($(obj).attr("data-userId"), type);
            $(obj).closest("tr").removeClass("on");
        }
        var totChkCnt = $("input:checkbox[name=" + type + "Chk]").length;
        var chkCnt = $("input:checkbox[name=" + type + "Chk]:checked").length;
        if (totChkCnt == chkCnt) {
            $("input:checkbox[name=all" + type + "Chk]").prop("checked", true);
        } else {
            $("input:checkbox[name=all" + type + "Chk]").prop("checked", false);
        }
    }

    // 선택된 학습자 번호 추가
    function addSelectedUserIds(userId, type) {
        var selectedUserIds = $("#" + type + "UserIds").val();
        if (selectedUserIds.indexOf(userId) == -1) {
            if (selectedUserIds.length > 0) {
                selectedUserIds += ',';
            }
            selectedUserIds += userId;
            $("#" + type + "UserIds").val(selectedUserIds);
        }
    }

    // 선택된 학습자 번호 제거
    function removeSelectedUserIds(userId, type) {
        var selectedUserIds = $("#" + type + "UserIds").val();
        if (selectedUserIds.indexOf(userId) > -1) {
            selectedUserIds = selectedUserIds.replace(userId, "");
            selectedUserIds = selectedUserIds.replace(",,", ",");
            selectedUserIds = selectedUserIds.replace(/^[,]*/g, '');
            selectedUserIds = selectedUserIds.replace(/[,]*$/g, '');
            $("#" + type + "UserIds").val(selectedUserIds);
        }
    }

    //사용자 정보 팝업
    function userInfoPop(userId) {
        var userInfoUrl = "${userInfoPopUrl}" + btoa(`{"stuno":"\${userId}"}`);
        var options = 'top=100, left=150, width=1200, height=800';
        window.open(userInfoUrl, "", options);
    }

    // 실시간 시험 맛보기
    function etsExamTaste(examCd) {
        var url = "/exam/examStareEncrypto.do";
        var data = {
            "examCd": examCd
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnVO = data.returnVO;
                window.open(returnVO.goUrl);
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
        });
    }

    // 성적 반영비율 입력 폼 변환
    function chgScoreRatio(type) {
        if (type == 1) {
            $("#chgScoreRatioBtn").hide();
            $(".chgScoreRatioDiv").css("display", "inline-block");
            $(".scoreInputDiv").show();
            $(".scoreRatioDiv").hide();
        } else {
            $("#chgScoreRatioBtn").css("display", "inline-block");
            $(".chgScoreRatioDiv").hide();
            $(".scoreInputDiv").hide();
            $(".scoreRatioDiv").show();
        }
    }

    // 성적 반영비율 저장
    function saveScoreRatio() {
        var isChk = true;
        var scoreRatio = 0;	// 시험 반영 점수
        var examCds = "";
        var scoreRatios = "";

        $(".scoreRatio").each(function (i) {
            scoreRatio += parseInt($(this).val());
            if (i > 0) {
                examCds += "|";
                scoreRatios += "|";
            }
            examCds += $(this).attr("data-examCd");
            scoreRatios += $(this).val();
            if (Number($(this).val()) < 0 || Number($(this).val()) > 100) {
                alert("<spring:message code='exam.alert.score.max.100' />");/* 점수는 100점 까지 입력 가능 합니다. */
                isChk = false;
                return false;
            }
        });

        if (isChk) {
            if (Number(scoreRatio) != 100 && $(".scoreRatio").length > 0) {
                alert("<spring:message code='exam.alert.always.exam.score.ratio.100' />");/* 상시 성적 반영 비율이 100%여야 합니다. */
                return false;
            } else {
                var url = "/quiz/editQuizAjax.do";
                var data = {
                    "examCds": examCds,
                    "scoreRatios": scoreRatios
                };

                ajaxCall(url, data, function (data) {
                    if (data.result > 0) {
                        alert("<spring:message code='exam.alert.insert' />");/* 정상 저장 되었습니다. */
                        listEtcExam();
                    } else {
                        alert(data.message);
                    }
                }, function (xhr, status, error) {
                    alert("<spring:message code='exam.error.score.ratio' />");/* 반영 비율 저장 중 에러가 발생하였습니다. */
                });
            }
        }
    }

    // 메세지 보내기
    function sendMsg(type) {
        var listMap = {
            "dsblReq": {"list": "examDsblReqList", "check": "dsblReqChk"},
            "absent": {"list": "examAbsentList", "check": "absentChk"}
        }

        var rcvUserInfoStr = "";
        var sendCnt = 0;

        $.each($('#' + listMap[type]["list"]).find("input:checkbox[name=\"" + listMap[type]["check"] + "\"]:not(:disabled):checked"), function () {
            sendCnt++;
            if (sendCnt > 1) rcvUserInfoStr += "|";
            rcvUserInfoStr += $(this).attr("user_id");
            rcvUserInfoStr += ";" + $(this).attr("user_nm");
            rcvUserInfoStr += ";" + $(this).attr("mobile");
            rcvUserInfoStr += ";" + $(this).attr("email");
        });

        if (sendCnt == 0) {
            /* 메시지 발송 대상자를 선택하세요. */
            alert("<spring:message code='common.alert.sysmsg.select_user'/>");
            return;
        }

        window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");

        var form = document.alarmForm;
        form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
        form.target = "msgWindow";
        form[name = 'alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
        form[name = 'rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
        form.submit();
    }

    // 퀴즈 문제 관리 페이지
    function quizQstnManage(insRefCd) {
        var kvArr = [];
        kvArr.push({'key': 'examCd', 'val': insRefCd});
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});

        submitForm("/quiz/quizQstnManage.do", "", "", kvArr);
    }

    // 대체과제 연결
    function etcSetInsRef(examCd, examStareTypeCd) {
        var kvArr = [];
        kvArr.push({'key': 'examCd', 'val': examCd});
        kvArr.push({'key': 'examStareTypeCd', 'val': examStareTypeCd});
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});

        submitForm("/exam/examInsRefLinkPop.do", "examPopIfm", "examInsLink", kvArr);
    }

    // 대체과제 해제
    function etcResetInsRef(examCd, examTypeCd, insRefCd, examStareTypeCd) {
        var examStr = examStareTypeCd == "M" ? "<spring:message code='exam.label.mid.exam' />"/* 중간고사 */ : "<spring:message code='exam.label.end.exam' />"/* 기말고사 */;

        if (window.confirm("<spring:message code='exam.confirm.reset.ins.ref.link' arguments='"+examStr+"' />")) {
            var url = "/exam/setInsRefCancel.do";
            var data = {
                "examCd": examCd,
                "examTypeCd": examTypeCd,
                "insRefCd": insRefCd
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    alert("<spring:message code='exam.alert.subs.link.cancel' />");/* 대체평가 연결해제가 완료되었습니다. */
                    location.reload();
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
            });
        }
    }
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
<div id="wrap" class="pusher">

    <!-- class_top 인클루드  -->
    <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>

    <div id="container">

        <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>

        <!-- 본문 content 부분 -->
        <div class="content">
            <%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>

            <div class="ui form">
                <div class="layout2">
                    <c:set var="examTypeStr"><spring:message code="exam.label.mid.end.exam" /><!-- 중간/기말 -->
                    </c:set>
                    <c:if test="${vo.examType eq 'ADMISSION' }"><c:set var="examTypeStr"><spring:message code="exam.label.always.exam" /><!-- 수시평가 -->
                    </c:set>
                    </c:if>
                    <c:if test="${vo.examType eq 'DSBL' }"><c:set var="examTypeStr"><spring:message code="exam.label.dsbl.req" /><!-- 장애인 시험지원 -->
                    </c:set>
                    </c:if>
                    <c:if test="${vo.examType eq 'ABSENT' }"><c:set var="examTypeStr"><spring:message code="exam.label.absent" /><!-- 결시원 -->
                    </c:set>
                    </c:if>
                    <script>
                        $(document).ready(function () {
                            // set location
                            setLocationBar('<spring:message code="exam.label.exam" />', '${examTypeStr}');
                        });
                    </script>

                    <div id="info-item-box">
                        <h2 class="page-title flex-item flex-wrap gap4 columngap16">${examTypeStr }</h2>
                        <c:if test="${vo.examType eq 'EXAM' || vo.examType eq 'ADMISSION' }">
                            <div class="button-area">
                                <c:if test="${vo.examType eq 'EXAM' }">
                                    <a href="javascript:examStareJoinList()" class="ui blue button">
                                        <spring:message code="exam.label.mid.end.exam" /><!-- 중간/기말 -->
                                        <spring:message code="exam.label.stare.status" /><!-- 응시현황 -->
                                    </a>
                                </c:if>
                                <c:if test="${vo.examType eq 'ADMISSION'}"><a href="javascript:examWrite('A')"
                                                                              class="ui blue button">
                                    <spring:message code="exam.label.always.exam" /><!-- 수시평가 -->
                                    <spring:message code="exam.button.reg" /><!-- 등록 --></a></c:if>
                            </div>
                        </c:if>
                    </div>
                    <c:if test="${vo.examType eq 'EXAM' }">
                        <div class="row">
                            <div class="col flex flex-column" id="midExamDiv"></div>
                            <div class="col flex flex-column" id="endExamDiv"></div>
                        </div>
                    </c:if>
                    <c:if test="${vo.examType eq 'ADMISSION' }">
                        <div class="row">
                            <div class="col">
                                <div class="option-content pb10">
                                    <h3 class="sec_head">
                                        <spring:message code="exam.label.always.exam" /><!-- 수시평가 --></h3>
                                    <div class="mla">
                                        <div class="chgScoreRatioDiv">
                                            <a href="javascript:saveScoreRatio()"
                                               class="ui blue small button"><spring:message
                                                    code="exam.label.grade.score"/> <spring:message
                                                    code="exam.label.score.aply.rate"/> <spring:message
                                                    code="exam.button.save"/></a><!-- 성적 --><!-- 반영비율 --><!-- 저장 -->
                                            <a href="javascript:chgScoreRatio(2)"
                                               class="ui basic small button"><spring:message
                                                    code="exam.button.cancel"/></a>
                                        </div>
                                        <a href="javascript:chgScoreRatio(1)" id="chgScoreRatioBtn"
                                           class="ui blue small button"><spring:message code="exam.label.grade.score"/>
                                            <spring:message code="exam.label.score.aply.rate"/> <spring:message
                                                    code="exam.button.reg"/></a><!-- 성적 --><!-- 반영비율 --><!-- 등록 -->
                                    </div>
                                </div>
                                <table class="table type2" data-sorting="false" data-paging="false"
                                       data-empty="<spring:message code='exam.common.empty' />" id="examEtcListTable">
                                    <!-- 등록된 내용이 없습니다. -->
                                    <thead>
                                    <tr class="ui native sticky top0">
                                        <th class="tc">No</th>
                                        <th class="tc">
                                            <spring:message code="exam.label.admission.nm" /><!-- 수시평가명 --></th>
                                        <th class="tc" data-breakpoints="xs sm md">
                                            <spring:message code="exam.label.exam" /><!-- 시험 -->
                                            <spring:message code="exam.label.type" /><!-- 유형 --></th>
                                        <th class="tc"><spring:message code="exam.label.grade.score" /><!-- 성적 -->
                                            <spring:message code="exam.label.score.aply.rate" /><!-- 반영비율 --></th>
                                        <th class="tc" data-breakpoints="xs">
                                            <spring:message code="exam.label.exam" /><!-- 시험 -->
                                            <spring:message code="exam.label.dttm" /><!-- 일시 --></th>
                                        <th class="tc" data-breakpoints="xs">
                                            <spring:message code="exam.label.exam" /><!-- 시험 -->
                                            <spring:message code="exam.label.time" /><!-- 시간 --></th>
                                        <th class="tc" data-breakpoints="xs sm">
                                            <spring:message code="exam.label.score.open.y" /><!-- 성적공개 --></th>
                                        <th class="tc" data-breakpoints="xs sm">
                                            <spring:message code="exam.label.score.open.dttm" /><!-- 성적공개일시 --></th>
                                        <th class="tc" data-breakpoints="xs sm md">
                                            <spring:message code="exam.label.qstn.submit.status" /><!-- 출제상태 --></th>
                                    </tr>
                                    </thead>
                                    <tbody id="examEtcList">
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${vo.examType eq 'DSBL' }">
                        <div class="row">
                            <div class="col">
                                <div class="pb15 option-content">
                                    <h3 class="sec_head"><spring:message code="exam.label.dsbl.req"/> <spring:message
                                            code="exam.label.applicate"/></h3><!-- 장애인 시험지원 --><!-- 신청 -->
                                    <div class="button-area mla">
                                        <uiex:msgSendBtn func="sendMsg('dsblReq')" styleClass="ui basic small button"/><!-- 메시지 -->
                                        <a href="javascript:examDsblReqExcelDown()"
                                           class="ui basic small button"><spring:message
                                                code="exam.button.excel.down"/></a><!-- 엑셀 다운로드 -->
                                    </div>
                                </div>
                                <div class="option-content pb10">
                                    <select class="ui dropdown" id="dsblExamStareTypeCd" onchange="listExamDsblReq()">
                                        <option value="ALL"><spring:message code="exam.common.search.all"/></option>
                                        <!-- 전체 -->
                                        <option value="M"><spring:message code="exam.label.mid.exam"/></option>
                                        <!-- 중간고사 -->
                                        <option value="L"><spring:message code="exam.label.end.exam"/></option>
                                        <!-- 기말고사 -->
                                    </select>
                                    <select class="ui dropdown" id="dsblApprStat" onchange="listExamDsblReq()">
                                        <option value="ALL"><spring:message code='exam.common.search.all'/></option>
                                        <!-- 전체 -->
                                        <option value="WAIT"><spring:message code="exam.label.applicate.n"/></option>
                                        <!-- 미신청자 -->
                                        <option value="COMPL"><spring:message code="exam.label.applicate.y"/></option>
                                        <!-- 신청자 -->
                                    </select>
                                    <div class="ui action input search-box">
                                        <input type="text"
                                               placeholder="<spring:message code='exam.label.dept' />/<spring:message code='exam.label.user.no' />/<spring:message code='exam.label.user.nm' /> <spring:message code='exam.label.input' />"
                                               class="w250" id="dsblReqSearchValue"><!-- 학과 --><!-- 학번 --><!-- 이름 -->
                                        <!-- 입력 -->
                                        <button class="ui icon button" onclick="listExamDsblReq()"><i
                                                class="search icon"></i></button>
                                    </div>
                                    <div class="mla">
                                        [ <spring:message code="exam.label.support.cnt"/> : <span
                                            id="examDsblReqCnt"></span><spring:message code="exam.label.nm"/> ]
                                        <!-- 지원인원 --><!-- 명 -->
                                    </div>
                                </div>
                                <table class="table type2" data-sorting="false" data-paging="false"
                                       data-empty="<spring:message code='exam.common.empty' />" id="dsblReqListTable">
                                    <!-- 등록된 내용이 없습니다. -->
                                    <thead>
                                    <tr>
                                        <th scope="col" class="tc">
                                            <div class="ui checkbox">
                                                <input type="hidden" id="dsblReqUserIds" name="dsblReqUserIds">
                                                <input type="checkbox" name="alldsblReqChk" id="alldsblReqChk"
                                                       value="all" onchange="checkAllUserIdToggle(this, 'dsblReq')">
                                                <label class="toggle_btn" for="alldsblReqChk"></label>
                                            </div>
                                        </th>
                                        <th scope="col" class="tc num">NO.</th>
                                        <th scope="col" class="tc" data-breakpoints="xs sm"><spring:message
                                                code="exam.label.dept"/></th><!-- 학과 -->
                                        <th scope="col" class="tc" data-breakpoints="xs sm"><spring:message
                                                code="exam.label.user.no"/></th><!-- 학번 -->
                                        <c:if test="${creCrsVO.univGbn eq '3' or creCrsVO.univGbn eq '4'}">
                                            <th scope="col" class="tc" data-breakpoints="xs sm">
                                                <spring:message code="common.label.grsc.degr.cors.gbn" /><!-- 학위과정 --></th>
                                        </c:if>
                                        <th scope="col" class="tc"><spring:message code="exam.label.user.nm"/></th>
                                        <!-- 이름 -->
                                        <th scope="col" class="tc" data-breakpoints="xs sm"><spring:message
                                                code="crs.label.crecrs.nm"/></th><!-- 과목명 -->
                                        <th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message
                                                code="crs.label.decls"/></th><!-- 분반 -->
                                        <th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message
                                                code="exam.label.academic"/><spring:message
                                                code="exam.label.situation"/></th><!-- 학적 --><!-- 상태 -->
                                        <th scope="col" class="tc" data-breakpoints="xs"><spring:message
                                                code="exam.label.dsbl.req.type"/></th><!-- 장애종류 -->
                                        <th scope="col" class="tc" data-breakpoints="xs"><spring:message
                                                code="exam.label.dsbl.req.degree"/></th><!-- 장애정도 -->
                                        <th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message
                                                code="exam.label.applicate"/><spring:message
                                                code="exam.label.term"/></th><!-- 신청 --><!-- 학기 -->
                                        <th scope="col" class="tc"><spring:message code="exam.label.std.request"/></th>
                                        <!-- 학생요청사항 -->
                                        <th scope="col" class="tc"><spring:message
                                                code="exam.label.request.result"/></th><!-- 요청결과 -->
                                        <th scope="col" class="tc"><spring:message
                                                code="exam.label.cancel.request"/></th><!-- 취소요청 -->
                                    </tr>
                                    </thead>
                                    <tbody id="examDsblReqList">
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${vo.examType eq 'ABSENT' }">
                        <div class="row">
                            <div class="col">
                                <div class="pb15 option-content">
                                    <h3 class="sec_head"><spring:message code="exam.label.absent"/> <spring:message
                                            code="exam.label.applicate"/></h3><!-- 결시원 --><!-- 신청 -->
                                    <div class="button-area mla">
                                        <uiex:msgSendBtn func="sendMsg('absent')" styleClass="ui basic small button"/><!-- 메시지 -->
                                        <a href="javascript:examAbsentExcelDown()"
                                           class="ui basic small button"><spring:message
                                                code='exam.button.excel.down'/></a><!-- 엑셀 다운로드 -->
                                    </div>
                                </div>
                                <div class="option-content pb10">
                                    <select class="ui dropdown" id="absentStareType" onchange="listExamAbsent()">
                                        <option value="ALL"><spring:message code="exam.common.search.all"/></option>
                                        <!-- 전체 -->
                                        <option value="M"><spring:message code="exam.label.mid.exam"/></option>
                                        <!-- 중간고사 -->
                                        <option value="L"><spring:message code="exam.label.end.exam"/></option>
                                        <!-- 기말고사 -->
                                    </select>
                                    <select class="ui dropdown" id="absentApprStat" onchange="listExamAbsent()">
                                        <option value="ALL"><spring:message code="exam.label.approve.yn"/></option>
                                        <!-- 승인여부 -->
                                        <option value="APPLICATE"><spring:message code="exam.label.applicate"/></option>
                                        <!-- 신청 -->
                                        <option value="APPROVE"><spring:message code="exam.label.approve"/></option>
                                        <!-- 승인 -->
                                        <option value="COMPANION"><spring:message code="exam.label.companion"/></option>
                                        <!-- 반려 -->
                                    </select>
                                    <div class="ui action input search-box">
                                        <input type="text"
                                               placeholder="<spring:message code='exam.label.dept' />/<spring:message code='exam.label.user.no' />/<spring:message code='exam.label.user.nm' /> <spring:message code='exam.label.input' />"
                                               class="w250" id="absentSearchValue"><!-- 학과 --><!-- 학번 --><!-- 이름 -->
                                        <!-- 입력 -->
                                        <button class="ui icon button" onclick="listExamAbsent()"><i
                                                class="search icon"></i></button>
                                    </div>
                                    <div class="mla">
                                        [ <spring:message code="exam.label.support.cnt"/> : <span
                                            id="examAbsentCnt"></span><spring:message code="exam.label.nm"/> ]
                                        <!-- 지원인원 --><!-- 명 -->
                                    </div>
                                </div>
                                <table class="table type2" data-sorting="false" data-paging="false"
                                       data-empty="<spring:message code='exam.common.empty' />" id="absentListTable">
                                    <!-- 등록된 내용이 없습니다. -->
                                    <thead>
                                    <tr>
                                        <th scope="col" class="tc">
                                            <div class="ui checkbox">
                                                <input type="hidden" id="absentUserIds" name="absentUserIds">
                                                <input type="checkbox" name="allabsentChk" id="allabsentChk" value="all"
                                                       onchange="checkAllUserIdToggle(this, 'absent')">
                                                <label class="toggle_btn" for="allabsentChk">NO.</label>
                                            </div>
                                        </th>
                                        <th scope="col" class="tc" data-breakpoints="xs"><spring:message
                                                code="exam.label.dept"/></th><!-- 학과 -->
                                        <th scope="col" class="tc" data-breakpoints="xs"><spring:message
                                                code="exam.label.user.no"/></th><!-- 학번 -->
                                        <c:if test="${creCrsVO.univGbn eq '3' or creCrsVO.univGbn eq '4'}">
                                            <th scope="col" class="tc" data-breakpoints="xs sm md">
                                                <spring:message code="common.label.grsc.degr.cors.gbn" /><!-- 학위과정 --></th>
                                        </c:if>
                                        <th scope="col" class="tc"><spring:message code="exam.label.user.nm"/></th>
                                        <!-- 이름 -->
                                        <th scope="col" class="tc"><spring:message
                                                code="exam.label.process.status"/></th><!-- 처리상태 -->
                                        <th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message
                                                code="exam.label.applicate"/><spring:message
                                                code="exam.label.day"/></th><!-- 신청 --><!-- 일 -->
                                        <th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message
                                                code="exam.label.exam"/><spring:message
                                                code="exam.label.stare.type"/></th><!-- 시험 --><!-- 구분 -->
                                        <th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message
                                                code="exam.label.real.time.exam"/><spring:message
                                                code="exam.label.answer.yn"/></th><!-- 실시간시험 --><!-- 응시여부 -->
                                        <th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message
                                                code="exam.label.process.dttm"/></th><!-- 처리일시 -->
                                        <th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message
                                                code="exam.label.process.manage"/></th><!-- 처리담당자 -->
                                        <th scope="col" class="tc"><spring:message code="exam.label.manage"/></th>
                                        <!-- 관리 -->
                                    </tr>
                                    </thead>
                                    <tbody id="examAbsentList">
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
        <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
    </div>
    <!-- //본문 content 부분 -->
</div>

</body>
</html>