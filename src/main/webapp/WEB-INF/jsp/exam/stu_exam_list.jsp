<%@page import="knou.framework.util.CommonUtil" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>

<script type="text/javascript">
    $(document).ready(function () {
        if ("${vo.examType}" == "EXAM") {
            selectExam('M');
        } else if ("${vo.examType}" == "ADMISSION") {
            listEtcExam();
        } else if ("${vo.examType}" == "DSBL") {
            listExamDsblReq();
        } else if ("${vo.examType}" == "ABSENT") {
            listExamAbsent();
        }
    });

    // 수시평가 목록 조회
    function listEtcExam() {
        var url = "/exam/examListByEtc.do";
        var data = {
            "crsCreCd": "${vo.crsCreCd}",
            "examStareTypeCd": "A",
            "stdNo": "${vo.stdNo}",
            "searchKey": "STUDENT"
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnList = data.returnList || [];
                var html = "";

                if (returnList.length > 0) {
                    returnList.forEach(function (v, i) {
                        var examStartDttm = dateFormat("date", v.examStartDttm);
                        var scoreAplyYn = v.scoreAplyYn == "Y" ? "<spring:message code='exam.common.yes' />"/* 예 */ : "<spring:message code='exam.common.no' />"/* 아니오 */;
                        var examTypeCd = v.examTypeCd == "QUIZ" ? "<spring:message code='exam.label.quiz' />"/* 퀴즈 */ : v.examTypeCd == "ETC" ? "<spring:message code='exam.label.etc' />"/* 기타 */ : "<spring:message code='exam.label.real.time' />"/* 실시간 */;
                        var examStareTm = v.examStareTm != null ? v.examStareTm : "0";
                        html += "<tr>";
                        html += "	<td class='tc'>" + v.lineNo + "</td>";
                        html += "	<td><a href='javascript:insInfoView(\"EXAM\", \"" + v.examCd + "\", \"" + v.examStartDttm + "\", \"" + v.examEndDttm + "\", \"" + v.periodAfterWriteYn + "\")' class='fcBlue'>" + v.examTitle + "</a></td>";
                        if (v.examTypeCd == "QUIZ") {
                            html += "	<td class='tc'><a href='javascript:insInfoView(\"QUIZ\", \"" + v.insRefCd + "\", \"" + v.examStartDttm + "\", \"" + v.examEndDttm + "\", \"" + v.periodAfterWriteYn + "\")' class='fcBlue'>" + examTypeCd + "</a></td>";
                        } else {
                            html += "	<td class='tc'>" + examTypeCd + "</td>";
                        }
                        html += "	<td class='tc'>" + examStartDttm + "</td>";
                        html += "	<td class='tc'>" + examStareTm + "<spring:message code='exam.label.stare.min' /></td>";/* 분 */
                        html += "	<td class='tc'>" + scoreAplyYn + "</td>";
                        html += "	<td class='tc'></td>";
                        html += "	<td class='tc'>";
                        if (v.examTypeCd == "QUIZ") {
                            if (v.insJoinYn == "Y") {
                                html += "		<a href='javascript:quizAnswerPop(\"" + v.insRefCd + "\", \"" + v.examStatus + "\", \"" + v.gradeViewYn + "\")' class='ui basic small button " + (PROFESSOR_VIRTUAL_LOGIN_YN == "Y" ? 'disabled' : '') + "'><spring:message code='exam.button.review.answer' /></a>";/* 제출답안 */
                            } else {
                                html += "		<a href='javascript:quizJoinPop(\"" + v.insRefCd + "\")' class='ui basic small button " + (PROFESSOR_VIRTUAL_LOGIN_YN == "Y" ? 'disabled' : '') + "'><spring:message code='exam.label.quiz' /> <spring:message code='exam.button.stare.start' /></a>";/* 퀴즈 *//* 응시 */
                            }
                        } else {
                            html += "		<a href='javascript:examStare(\"" + v.examStareTypeCd + "\", \"" + v.examCd + "\", \"" + v.examStartDttm + "\", \"" + v.examEndDttm + "\")' class='ui basic small button " + (v.todayYn == "Y" ? 'togglebgColorBtn' : '') + "  " + (PROFESSOR_VIRTUAL_LOGIN_YN == "Y" ? 'disabled' : '') + "'><spring:message code='exam.label.exam' /> <spring:message code='exam.button.stare.start' /></a>";/* 시험 *//* 응시 */
                        }
                        html += "	</td>";
                        html += "</tr>";
                    });
                }

                $("#examEtcList").empty().html(html);
                $("#examEtcListTable").footable();
                $("#examEtcListTable").parent("div").addClass("max-height-450");
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
        });
    }

    // 중간, 기말 시험 정보 가져오기
    function selectExam(type) {
        var url = "/exam/examCopy.do";
        var data = {
            "crsCreCd": "${vo.crsCreCd}",
            "stdNo": "${vo.stdNo}",
            "examCtgrCd": "EXAM",
            "examSubmitYn": "Y",
            "examStareTypeCd": type
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var html = ``;
                var typeNm = type == "M" ? "<spring:message code='exam.label.mid.exam' />"/* 중간고사 */ : "<spring:message code='exam.label.end.exam' />"/* 기말고사 */;
                html += `<div class="option-content">`;
                html += `	<h3 class="sec_head"> \${typeNm} <spring:message code="exam.label.info" /></h3>`;/* 정보 */
                if (data.returnVO != null && data.returnVO.examTypeCd == "EXAM" && PROFESSOR_VIRTUAL_LOGIN_YN != "Y") {
                    html += `	<div class="mla" id="\${type}BtnDiv">`;
                    html += `		<a href="javascript:submitOathPop('\${data.returnVO.examCd}', '\${data.returnVO.examStareTypeCd}')" id="\${type}OathBtn" class="ui basic small button"><spring:message code="exam.label.oath.submit" /></a>`;/* 서약서 제출 */
                    html += `		<a href="javascript:etsExamTaste('\${data.returnVO.examCd}')" class="ui basic small button"><spring:message code="exam.label.exam.taste" /></a>`;/* 시험 맛보기 */
                    html += `	</div>`;
                }
                html += `</div>`;
                html += `<div class="ui segment flex1 flex flex-column mt0 test-wrap">`;
                if (data.returnVO != null) {
                    var examVO = data.returnVO;
                    var examStareTm = examVO.examStareTm == null ? "-" : examVO.examStareTm;
                    html += `<div class="option-content header2">`;
                    if (examVO.scoreRatio == 0) {
                        html += `	<a href="javascript:void(0)">[ \${examVO.examTypeNm} ] \${examVO.examTitle}</a>`;
                    } else {
                        // var typeStr = examVO.examTypeCd != "ETC" && examVO.examTypeCd != "EXAM" ? "기타 : " : "";
                        var typeStr = examVO.examTypeCd != "ETC" && examVO.examTypeCd != "EXAM" ? "<spring:message code='std.label.etc' /> : " : "";
                        html += `	<a href="javascript:examView('\${examVO.examCd}', '\${examVO.examTypeCd}', '\${examVO.insRefCd}', '\${examVO.insStartDttm}', '\${examVO.insEndDttm}', '\${examVO.periodAfterWriteYn}', '\${examVO.extSendAcptYn}', '\${examVO.extSendDttm}')">[ \${typeStr}\${examVO.examTypeNm} ] \${examVO.examTitle}</a>`;
                        //if(examVO.examTypeCd == "EXAM" && PROFESSOR_VIRTUAL_LOGIN_YN != "Y") {
                        //html += `	<div class="mla">`;
                        //	if(examVO.examAbsentYn == "Y") {
                        //html += `		<a href="javascript:examAbsentApprView('\${examVO.examAbsentCd}')" class="ui blue small button"><spring:message code="exam.label.exam.absent.applicate.view" /></a>`;/* 결시원 신청확인 */
                        //	} else {
                        //html += `		<button class="ui blue button small" onclick="examAbsentApplicate('\${examVO.crsCreCd}', '\${examVO.examCd}', '${vo.stdNo}', '\${type}')"><spring:message code="exam.label.absent" /> <spring:message code="exam.label.applicate" /></button>`;/* 결시원 *//* 신청 */
                        //	}
                        //html += `	</div>`;
                        //}
                    }

                    html += `</div>`;
                    html += `<ul class="tbl-simple dt-sm">`;
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
                            html += `			<span><spring:message code="common.etc" /> (<spring:message code="common.ready" />)</span>`;
                        } else {
                            html += `			<span><spring:message code="crs.label.live.exam" /> <spring:message code="common.ready" />(3<spring:message code="common.schedule.now" /> <spring:message code="common.announce.schedule" />)</span>`;
                        }
                        html += `		</div>`;
                        html += `	</div>`;
                    } else {
                        // 실시간 시험이 아니고 기타시험이 등록되지 않은 경우
                        if (examVO.examTypeCd == "ETC" || (examVO.examTypeCd != "EXAM" && examVO.insRefCd == null)) {
                            html += `	<p class="flex-container m-hAuto"><spring:message code="exam.label.empty.exam" /></p>`;/* 등록된 시험 정보가 없습니다. */
                            // 실시간 시험인 경우
                        } else if (examVO.examTypeCd == "EXAM") {
                            var examStartDate = examVO.examStartDttm != null ? dateFormat("dateWeek", examVO.examStartDttm) : "-";
                            var openYn = {
                                "Y": "<spring:message code='exam.label.open.y' />"/* 공개 */,
                                "N": "<spring:message code='exam.label.open.n' />"/* 비공개 */
                            };
                            var startDate = new Date(examVO.examStartDttm.substring(0, 4), examVO.examStartDttm.substring(4, 6) - 1, examVO.examStartDttm.substring(6, 8), examVO.examStartDttm.substring(8, 10), examVO.examStartDttm.substring(10, 12));
                            startDate.setMinutes(startDate.getMinutes() + examVO.examStareTm);
                            var endDttm = startDate.getFullYear() + "" + pad((startDate.getMonth() + 1), 2) + "" + pad(startDate.getDate(), 2) + "" + pad(startDate.getHours(), 2) + "" + pad(startDate.getMinutes(), 2) + "" + pad(startDate.getSeconds(), 2);
                            var stareStr = "";
                            if ("${today}" < examVO.examStartDttm) {
                                stareStr = "<spring:message code='exam.label.prev.stare' />";
                            } else if ("${today}" > examVO.examStartDttm && "${today}" <= endDttm) {
                                stareStr = "<spring:message code='exam.label.subject.participate' />";
                            } else if ("${today}" > endDttm && examVO.stuEvalYn == "N") {
                                stareStr = "<spring:message code='std.label.end' />";
                            } else {
                                stareStr = "<spring:message code='exam.label.no.stare' />";/* 미응시 */
                                if (examVO.stareStatusCd == "C") {
                                    if (examVO.scoreOpenYn == "Y") {
                                        if (examVO.totGetScore == null) {
                                            stareStr = "<spring:message code='exam.label.complete.stare' />/-";/* 응시완료 */
                                        } else {
                                            stareStr = "<spring:message code='exam.label.complete.stare' />/" + examVO.totGetScore + "<spring:message code='exam.label.score.point' />";/* 응시완료 *//* 점 */
                                        }
                                    } else {
                                        stareStr = "<spring:message code='exam.label.complete.stare' />"/* 응시완료 */;
                                    }
                                }
                            }
                            // 추후 성적 공개 일자 나뉘면 해당 기간 안에만 성적 공개로 표시
                            html += `	<li>`;
                            html += `		<dl>`;
                            html += `			<dt><label><spring:message code="exam.label.exam.dttm" /></label></dt>`;/* 시험일시 */
                            html += `			<dd>\${examStartDate}</dd>`;
                            html += `		</dl>`;
                            html += `	</li>`;
                            html += `	<li class="pt0">`;
                            html += `		<dl>`;
                            html += `			<dt><label><spring:message code="exam.label.exam.time" /></label></dt>`;/* 시험시간 */
                            html += `			<dd>\${examStareTm}<spring:message code="exam.label.stare.min" /></dd>`;/* 분 */
                            html += `		</dl>`;
                            html += `	</li>`;
                            html += `	<li class="pt0">`;
                            html += `		<dl>`;
                            html += `			<dt><label><spring:message code="exam.label.open.yn" /></label></dt>`;/* 공개여부 */
                            html += `			<dd>`;
                            html += `				<spring:message code="exam.label.grade.score" /> \${openYn[examVO.scoreOpenYn]} |`;/* 성적 */
                            html += `				<spring:message code="exam.label.paper" /> \${openYn[examVO.gradeViewYn]}`;/* 시험지 */
                            html += `			</dd>`;
                            html += `		</dl>`;
                            html += `	</li>`;
                            html += `	<li class="pt0">`;
                            html += `		<dl>`;
                            html += `			<dt><label><spring:message code="exam.label.eval.stare.status" /></label></dt>`;/* 응시/평가현황 */
                            html += `			<dd>\${stareStr}</dd>`;
                            html += `		</dl>`;
                            html += `	</li>`;
                            // 시험퀴즈, 시험토론, 시험과제 인경우
                        } else {
                            var insStartDttm = examVO.insStartDttm != null ? dateFormat("date", examVO.insStartDttm) : "-";
                            var insEndDttm = examVO.insEndDttm != null ? dateFormat("date", examVO.insEndDttm) : "-";
                            var insJoinStr = "";
                            if (examVO.insJoinYn == "N") {
                                insJoinStr = examVO.examTypeCd == "QUIZ" ? "<spring:message code='exam.label.no.stare' />"/* 미응시 */ : examVO.examTypeCd == "ASMNT" ? "<spring:message code='exam.label.submit.n' />"/* 미제출 */ : "<spring:message code='exam.label.not.submit' />"/* 미참여 */;
                            } else {
                                insJoinStr = examVO.examTypeCd == "QUIZ" ? "<spring:message code='exam.label.complete.stare' />"/* 응시완료 */ : examVO.examTypeCd == "ASMNT" ? "<spring:message code='exam.label.ins.submit' />"/* 제출완료 */ : "<spring:message code='exam.label.ins.participation' />"/* 참여완료 */;

                                if (examVO.insScoreOpenYn == "Y") {
                                    var insScore = examVO.insScore == null ? "-" : examVO.insScore;
                                    if (insScore != "-") {
                                        insJoinStr += "/" + insScore + "<spring:message code='exam.label.score.point' />";/* 점 */
                                    } else {
                                        insJoinStr += "/" + insScore;
                                    }
                                }
                            }
                            html += `	<li>`;
                            html += `		<dl>`;
                            html += `			<dt><label><spring:message code="exam.label.ins.ref.title" /></label></dt>`;/* 평가명 */
                            html += `			<dd><a href="javascript:insInfoView('\${examVO.examTypeCd}' ,'\${examVO.insRefCd}', '\${examVO.insStartDttm}', '\${examVO.insEndDttm}', '\${examVO.periodAfterWriteYn}', '\${examVO.extSendAcptYn}', '\${examVO.extSendDttm}')" class="fcBlue">\${examVO.insRefNm}</a></dd>`;
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
                            html += `			<dt><label><spring:message code="exam.label.eval.submit.status" /></label></dt>`;/* 제출/평가현황 */
                            html += `			<dd>\${insJoinStr}</dd>`;
                            html += `		</dl>`;
                            html += `	</li>`;
                        }
                    }
                    html += `</ul>`;
                    html += `<div class="option-content mt10">`;
                    if (PROFESSOR_VIRTUAL_LOGIN_YN != "Y") {
                        if (examVO.examTypeCd == "EXAM") {
                            if (examVO.todayYn == "Y") {
                                html += `	<a href="javascript:examStare('\${examVO.examStareTypeCd}', '\${examVO.examCd}', '\${examVO.examStartDttm}', '\${examVO.examEndDttm}', '\${examVO.examStareTypeCd}')" class="ui basic small button mla togglebgColorBtn"><spring:message code="exam.label.exam" /> <spring:message code="exam.button.stare.start" /></a>`;/* 시험 *//* 응시 */
                            } else if (examVO.examStatus == "종료") {
                                html += `	<a href="javascript:examStare('\${examVO.examStareTypeCd}', '\${examVO.examCd}', '\${examVO.examStartDttm}', '\${examVO.examEndDttm}', '\${examVO.examStareTypeCd}')" class="ui basic small button mla"><spring:message code="exam.label.exam" /> <spring:message code="exam.button.stare.end" /></a>`;/* 시험 *//* 종료 */
                            } else {
                                html += `	<a href="javascript:examStare('\${examVO.examStareTypeCd}', '\${examVO.examCd}', '\${examVO.examStartDttm}', '\${examVO.examEndDttm}', '\${examVO.examStareTypeCd}')" class="ui basic small button mla"><spring:message code="exam.label.exam" /> <spring:message code="exam.button.stare.start" /></a>`;/* 시험 *//* 응시 */
                            }
                        } else if (examVO.examTypeCd != "ETC" && examVO.examTypeCd != "EXAM" && examVO.insRefCd != null) {
                            var insTypeCd = examVO.insRefCd.split("_")[0];
                            insTypeCd = insTypeCd == "EXAM" ? "QUIZ" : insTypeCd;
                            if (examVO.examTypeCd == 'QUIZ' && (examVO.examSubmitYn == 'Y' || examVO.examSubmitYn == 'M')) {
                                html += `	<a href="javascript:quizJoinPop('\${examVO.insRefCd}')" class="ui basic small button mla"><spring:message code="exam.label.quiz" /> <spring:message code="exam.label.submit" /></a>`;/* 퀴즈 *//* 참여 */
                            } else if (examVO.examTypeCd == 'ASMNT' || (examVO.examTypeCd == 'EXAM' && insRefCd == 'ASMNT' && examVO.examAbsentApproveYn == 'Y')) {
                                html += `	<a href="javascript:insInfoView('\${insTypeCd}' ,'\${examVO.insRefCd}', '\${examVO.insStartDttm}', '\${examVO.insEndDttm}', '\${examVO.periodAfterWriteYn}', '\${examVO.extSendAcptYn}', '\${examVO.extSendDttm}')" class="ui basic small button mla"><spring:message code="asmnt.label.asmnt" /> <spring:message code="exam.label.submit.y" /></a>`;/* 과제 *//* 제출 */
                            } else if (examVO.examTypeCd == 'FORUM' || (examVO.examTypeCd == 'EXAM' && insRefCd == 'FORUM' && examVO.examAbsentApproveYn == 'Y')) {
                                html += `	<a href="javascript:insInfoView('\${insTypeCd}' ,'\${examVO.insRefCd}', '\${examVO.insStartDttm}', '\${examVO.insEndDttm}', '\${examVO.periodAfterWriteYn}', '\${examVO.extSendAcptYn}', '\${examVO.extSendDttm}')" class="ui basic small button mla"><spring:message code="forum.label.forum" /> <spring:message code="exam.label.submit" /></a>`;/* 토론 *//* 참여 */
                            }
                        }
                    }
                    html += `</div>`;
                    // 대체 퀴즈, 토론, 과제가 있는 경우
                    if (examVO.examTypeCd == "EXAM" && examVO.insRefCd != null && examVO.insRefCd != "" && examVO.examAbsentApproveYn == 'Y' && examVO.insSubmitYn == 'Y') {
                        var insTypeCd = examVO.insRefCd.split("_")[0];
                        insTypeCd = insTypeCd == "EXAM" ? "QUIZ" : insTypeCd;
                        // var insTypeNm = insTypeCd == "QUIZ" ? "퀴즈" : insTypeCd == "ASMNT" ? "과제" : insTypeCd == "FORUM" ? "토론" : "-";
                        var quiz = "<spring:message code='sch.cor.quiz' />";
                        var asmnt = "<spring:message code='sch.cor.asmnt' />";
                        var forum = "<spring:message code='sch.cor.forum' />";
                        var insTypeNm = insTypeCd == "QUIZ" ? quiz : insTypeCd == "ASMNT" ? asmnt : insTypeCd == "FORUM" ? forum : "-";
                        html += `</div>`;
                        html += `<div class="ui segment flex1 flex flex-column mt0 test-wrap">`;
                        html += `<div class="option-content header2">`;
                        html += `	<p>[ \${insTypeNm} ]</p>`;
                        html += `</div>`;
                        html += `<ul class="tbl-simple dt-sm">`;
                        var insStartDttm = examVO.insStartDttm != null ? dateFormat("date", examVO.insStartDttm) : "-";
                        var insEndDttm = examVO.insEndDttm != null ? dateFormat("date", examVO.insEndDttm) : "-";
                        html += `	<li>`;
                        html += `		<dl>`;
                        html += `			<dt><label><spring:message code="exam.label.ins.ref.title" /></label></dt>`;/* 평가명 */
                        html += `			<dd><a class="fcBlue" href="javascript:insInfoView('\${insTypeCd}' ,'\${examVO.insRefCd}', '\${examVO.insStartDttm}', '\${examVO.insEndDttm}', '\${examVO.periodAfterWriteYn}', '\${examVO.extSendAcptYn}', '\${examVO.extSendDttm}')">\${examVO.insRefNm}</a></dd>`;
                        html += `		</dl>`;
                        html += `	</li>`;
                        html += `	<li class="pt0">`;
                        html += `		<dl>`;
                        html += `			<dt><label><spring:message code="exam.label.submit.date" /></label></dt>`;/* 제출기간 */
                        html += `			<dd>\${insStartDttm} ~ \${insEndDttm}</dd>`;
                        html += `		</dl>`;
                        html += `	</li>`;
                        // 토론, 과제인경우
                        if (examVO.insRefTypeNm == "과제" || examVO.insRefTypeNm == "토론") {
                            var extSendDttm = examVO.extSendDttm != null ? dateFormat("date", examVO.extSendDttm) : "-";
                            html += `	<li class="pt0">`;
                            html += `		<dl>`;
                            html += `			<dt><label><spring:message code="exam.label.ext.submit" /></label></dt>`;/* 지각제출 */
                            html += `			<dd>\${extSendDttm}</dd>`;
                            html += `		</dl>`;
                            html += `	</li>`;
                        }
                        var insJoinStr = "";
                        if (examVO.insJoinYn == "N") {
                            insJoinStr = examVO.examTypeCd == "QUIZ" ? "<spring:message code='exam.label.no.stare' />"/* 미응시 */ : examVO.examTypeCd == "ASMNT" ? "<spring:message code='exam.label.submit.n' />"/* 미제출 */ : "<spring:message code='exam.label.not.submit' />"/* 미참여 */;
                        } else {
                            insJoinStr = examVO.examTypeCd == "QUIZ" ? "<spring:message code='exam.label.complete.stare' />"/* 응시완료 */ : examVO.examTypeCd == "ASMNT" ? "<spring:message code='exam.label.ins.submit' />"/* 제출완료 */ : "<spring:message code='exam.label.ins.participation' />"/* 참여완료 */;
                            var insScore = examVO.insScore == null ? "0" : examVO.insScore;
                            if (examVO.insScoreOpenYn == "Y") insJoinStr += "/" + insScore + "<spring:message code='exam.label.score.point' />";/* 점 */
                        }
                        html += `	<li class="pt0">`;
                        html += `		<dl>`;
                        html += `			<dt><label><spring:message code="exam.label.eval.submit.status" /></label></dt>`;/* 제출/평가현황 */
                        html += `			<dd>\${insJoinStr}</dd>`;
                        html += `		</dl>`;
                        html += `	</li>`;
                        html += `</ul>`;
                        html += `<div class="option-content mt10">`;
                        if (PROFESSOR_VIRTUAL_LOGIN_YN != "Y") {
                            if (insTypeCd == 'QUIZ') {
                                html += `	<a href="javascript:quizJoinPop('\${examVO.insRefCd}')" class="ui basic small button mla"><spring:message code="exam.label.quiz" /> <spring:message code="exam.label.submit" /></a>`;/* 퀴즈 *//* 참여 */
                            } else if (insTypeCd == 'ASMNT') {
                                html += `	<a href="javascript:insInfoView('\${insTypeCd}' ,'\${examVO.insRefCd}', '\${examVO.insStartDttm}', '\${examVO.insEndDttm}', '\${examVO.periodAfterWriteYn}', '\${examVO.extSendAcptYn}', '\${examVO.extSendDttm}')" class="ui basic small button mla"><spring:message code="asmnt.label.asmnt" /> <spring:message code="exam.label.submit.y" /></a>`;/* 과제 *//* 제출 */
                            } else if (insTypeCd == 'FORUM') {
                                html += `	<a href="javascript:insInfoView('\${insTypeCd}' ,'\${examVO.insRefCd}', '\${examVO.insStartDttm}', '\${examVO.insEndDttm}', '\${examVO.periodAfterWriteYn}')" class="ui basic small button mla"><spring:message code="forum.label.forum" /> <spring:message code="exam.label.submit" /></a>`;/* 토론 *//* 참여 */
                            }
                        }
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
                }
                html += `</div>`;
                var examDiv = type == "M" ? "midExamDiv" : "endExamDiv";
                $("#" + examDiv).empty().html(html);
            } else {
                alert(data.message);
            }
            if (type == "M") selectExam('L');

            if (type == "L") {
                oathCheck();
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='exam.error.info' />");/* 정보 조회 중 에러가 발생하였습니다. */
        });
    }

    // 결시원 목록 조회
    function listExamAbsent() {
        var url = "/exam/listAllStuAbsentExam.do";
        var data = {
            "crsCreCd": "${vo.crsCreCd}",
            "creYear": "${creCrsVO.creYear}",
            "creTerm": "${creCrsVO.creTerm}"
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnList = data.returnList || [];
                var html = "";

                if (returnList.length > 0) {
                    var isMidCreated = false;
                    var isLastCreated = false;

                    returnList.forEach(function (v, i) {
                        var regDttm = v.regDttm != null ? dateFormat("date", v.regDttm) : "";
                        var modDttm = v.modDttm != null && v.apprStat != "APPLICATE" ? dateFormat("date", v.modDttm) : "";
                        var apprStatNm = "";

                        if (v.apprStat == "APPLICATE") {
                            apprStatNm = "<span class='fcBlue'><spring:message code='exam.label.applicate' /></span>"; // 신청
                        } else if (v.apprStat == "RAPPLICATE") {
                            apprStatNm = "<span class='fcBlue'><spring:message code='exam.label.rapplicate' /></span>"; // 재신청
                        } else if (v.apprStat == "APPROVE") {
                            apprStatNm = "<span class='fcGreen'><spring:message code='exam.label.approve' /></span>"; // 승인
                        } else if (v.apprStat == "COMPANION") {
                            apprStatNm = "<span class='fcRed'><spring:message code='exam.label.companion' /></span>"; // 반려
                        }

                        var examStareTypeNm = "";

                        if (v.examStareTypeCd == "M") {
                            examStareTypeNm = '<span class="fcGreen"><spring:message code="exam.label.mid.exam" /></span>';
                        } else if (v.examStareTypeCd == "L") {
                            examStareTypeNm = '<span class="fcBrown"><spring:message code="exam.label.end.exam" /></span>';
                        }

                        html += `<tr>`;
                        html += `	<td class='tc'>\${i+1}</td>`;
                        html += `	<td class='tc'>\${v.crsCreNm}</td>`;
                        html += `	<td class='tc'>\${v.declsNo}</td>`;
                        html += `	<td class='tc'>\${examStareTypeNm}</td>`;
                        html += `	<td class='tc'>\${regDttm}</td>`;
                        html += `	<td class='tc'>\${v.examStareYn}</td>`;
                        html += `	<td class='tc'>\${apprStatNm}</td>`;
                        html += `	<td class='tc'>\${modDttm}</td>`;
                        if (v.apprStat == null) {
                            html += `	<td class='tc'><a href="javascript:examAbsentApplicate('\${v.crsCreCd}', '\${v.examCd}', '\${v.stdNo}', '\${v.examStareTypeCd}')" class="ui blue small button"><spring:message code="exam.label.apply" /></a></td>`;/* 신청하기 */
                        } else {
                            html += `	<td class='tc'>`;
                            html += `		<a href="javascript:examAbsentApprView('\${v.examAbsentCd}')" class="ui grey small button"><spring:message code="exam.label.absent.list" /></a>`;/* 결시내역 */
                            if (v.apprStat == "COMPANION") {
                                html += '	<a href="javascript:examAbsentApplicate(\'' + v.crsCreCd + '\', \'' + v.examCd + '\', \'' + v.stdNo + '\', \'' + v.examStareTypeCd + '\')" class="ui blue button w70"><spring:message code="exam.label.rapplicate" /></a>'; // 재신청
                            } else {
                                html += '	<a href="javascript:void(0)" class="ui blue button w70 disabled" style="visibility:hidden"></a>';
                            }
                            html += `	</td>`;
                        }
                        html += `</tr>`;
                    });
                }

                $("#examAbsentList").empty().html(html);
                $("#absentListTable").footable();
                $("#examAbsentCnt").text(returnList.length);
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
        });
    }

    // 장애 지원 신청 목록 조회
    function listExamDsblReq() {
        var url = "/exam/stuExamDsblReqList.do";
        var data = {
            "crsCreCd": "${vo.crsCreCd}",
            "userId": "${vo.userId}"
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnList = data.returnList || [];
                var html = "";
                var dsblYn = "N";

                returnList.forEach(function (v, i) {
                    dsblYn = v.disablilityExamYn == "Y" ? "Y" : "N";
                    var examAppr = '';
                    var apprColor = '';

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
                    }

                    if (v.disablilityExamYn == "Y") {
                        if (v.dsblConfirmDtYn == "Y") {
                            examAppr = '<spring:message code="exam.label.review" />'; // 심사중

                            if (v.midApprStat || v.endApprStat) {
                                examAppr = '<spring:message code="exam.label.approve" /><spring:message code="exam.label.complete" />'; // 승인완료
                                apprColor = 'fcBlue';

                                if (v.midExamYn == "Y") {
                                    addTimeList.push(v.dsblConfirmDtYn == "Y" ? "<spring:message code='exam.label.late' />(" + v.midAddTime + "<spring:message code='exam.label.stare.min' />)" : "-"); // 연장 분
                                }

                                if (v.lastExamYn == "Y") {
                                    addTimeList.push(v.dsblConfirmDtYn == "Y" ? "<spring:message code='exam.label.late' />(" + v.endAddTime + "<spring:message code='exam.label.stare.min' />)" : ""); // 연장 분
                                }
                            }
                        } else if (v.dsblReqDtYn == "Y") {
                            //examAppr = '<spring:message code="exam.label.applicate" />'; // 신청
                            examAppr = '<spring:message code="exam.label.review" />'; // 심사중
                        } else {
                            examAppr = '-';
                        }
                    } else {
                        examAppr = '<spring:message code="exam.label.applicate.n" />'; // 신청 전
                    }

                    var cancelStat = v.disabilityCancelGbn == null ? "-" : v.disabilityCancelGbn == "APPLICATE" ? "<spring:message code='exam.label.applicate' />"/* 신청 */ : "<spring:message code='exam.label.approve' />"/* 승인 */;
                    html += `<tr>`;
                    html += `	<td class='tc'>\${v.lineNo}</td>`;
                    html += `	<td class='tc'>\${v.crsCreNm}</td>`;
                    html += `	<td class='tc'>\${v.declsNo}</td>`;
                    html += '	<td class="tc">' + (appliExamList.join("/") || "-") + '</td>';
                    html += '	<td class="tc">' + (examReqList.join("/") || "-") + '</td>';
                    html += '	<td class="tc">' + (addTimeList.join("/") || "-") + '</td>';
                    html += '	<td class="tc ' + apprColor + ' ">' + examAppr + '</td>';
                    html += '	<td class="tc">' + cancelStat + '</td>';
                    html += '</tr>';
                });

                $("#examDsblReqList").empty().html(html);
                $("#dsblReqListTable").footable();
                $("#examDsblReqCnt").text(returnList.length);
                $(".dsblBtn").hide();
                if (dsblYn == "Y") {
                    $("#cancelBtn").show();
                } else {
                    $("#applicateBtn").show();
                }
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
        });
    }

    // 퀴즈 참여 팝업
    function quizJoinPop(examCd) {
        if (examCd == 'null' || examCd == "") {
            alert("<spring:message code='exam.alert.already.quiz.reg' />");/* 퀴즈가 등록되어 있지 않습니다. */
        }
        var url = "/exam/examCopy.do";
        var data = {
            "examCd": examCd,
            "crsCreCd": "${vo.crsCreCd}",
            "stdNo": "${vo.stdNo}",
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnVO = data.returnVO;
                if (returnVO != null) {
                    if (returnVO.examSubmitYn == "N" || !(returnVO.examStatus == "진행" || (returnVO.stuReExamYn == "Y" && returnVO.reExamStatus == "진행"))) {
                        alert("<spring:message code='exam.alert.already.quiz.submit.n' />");/* 비공개 상태입니다. 공개 후 시험응시 바랍니다. */
                    } else {
                        var kvArr = [];
                        kvArr.push({'key': 'examCd', 'val': examCd});
                        kvArr.push({'key': 'stdNo', 'val': "${vo.stdNo}"});
                        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
                        kvArr.push({'key': 'goUrl', 'val': "tempForm"});

                        submitForm("/quiz/quizJoinAlarmPop.do", "examPopIfm", "joinInfo", kvArr);
                    }
                }
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='exam.error.info' />");/* 정보 조회 중 에러가 발생하였습니다. */
        });
    }

    // 퀴즈 제출 답안 팝업
    function quizAnswerPop(examCd, examStatus, gradeViewYn) {
        if (examStatus != "완료") {
            alert("<spring:message code='exam.alert.already.quiz.answer.pop' />");/* 퀴즈기간 종료 후 확인 가능합니다. */
            return;
        } else if (gradeViewYn != "Y") {
            alert("<spring:message code='exam.alert.grade.view.n' />");/* 시험지공개 전입니다. */
            return;
        }

        var kvArr = [];
        kvArr.push({'key': 'examCd', 'val': examCd});
        kvArr.push({'key': 'stdNo', 'val': "${vo.stdNo}"});
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});

        submitForm("/quiz/quizSubmitAnswerPop.do", "examPopIfm", "quizAnswer", kvArr);
    }

    // 서약서 제출 여부 확인
    function oathCheck() {
        var url = "/exam/oathHeader.do";

        ajaxCall(url, null, function (data) {
            var url = "<%=CommConst.EXT_URL_EXAMOATH_CHECK%>findExamOathDocLists";
            var param = {
                persNo: '${vo.userId}'
                , yyTmGbn: '${creCrsVO.creYear}${creCrsVO.creTerm}'
            };
            //console.log(param, data)
            $.ajax({
                url: url
                , type: "POST"
                , data: JSON.stringify(param)
                , dataType: 'json'
                , beforeSend: function (xhr) {
                    xhr.setRequestHeader("Content-type", "application/json");
                    xhr.setRequestHeader("ApiValue", data);
                }
                , success: function (data) {
                    if (data.code == "1") {
                        var resultList = data.result || [];

                        resultList.forEach(function (result, i) {
                            if (result.oathyn == "Y") {
                                if (result.examGbn == "01") {
                                    $("#MOathBtn").remove();
                                    $("#MBtnDiv").prepend("<span class='mr20'><spring:message code='exam.label.oath.submit.complete'/><!--서약서 제출 완료--></span>");
                                } else if (result.examGbn == "02") {
                                    $("#LOathBtn").remove();
                                    $("#LBtnDiv").prepend("<span class='mr20'><spring:message code='exam.label.oath.submit.complete'/><!--서약서 제출 완료--></span>");
                                }
                            }
                        });
                    }
                }
                , error: function (jqXHR) {
                    console.log(jqXHR.responseText);
                }
            });
        }, function (xhr, status, error) {
            alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
        });
    }

    // 서약서 제출 팝업
    function submitOathPop(examCd, examStareTypeCd) {
        var calendarCtgr = examStareTypeCd == "M" ? "00190812" : "00190813";
        var url = "/jobSchHome/viewSysJobSch.do";
        var data = {
            "crsCreCd": "${vo.crsCreCd}",
            "calendarCtgr": calendarCtgr,
            "termCd": "${termVO.termCd}"
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnVO = data.returnVO;
                if (returnVO != null) {
                    var startDt = returnVO.excSchStartDt != null ? returnVO.excSchStartDt : returnVO.schStartDt;
                    var endDt = returnVO.excSchEndDt != null ? returnVO.excSchEndDt : returnVO.schEndDt;
                    if (startDt < "${today}" && "${today}" < endDt) {
                        var url = "/exam/oathHeader.do";

                        ajaxCall(url, null, function (data) {
                            var url = "<%=CommConst.EXT_URL_EXAMOATH_CHECK%>findExamOathDocLists";
                            var param = {
                                persNo: '${vo.userId}'
                                , yyTmGbn: '${creCrsVO.creYear}${creCrsVO.creTerm}'
                            };

                            $.ajax({
                                url: url
                                , type: "POST"
                                , data: JSON.stringify(param)
                                , beforeSend: function (xhr) {
                                    xhr.setRequestHeader("Content-type", "application/json");
                                    xhr.setRequestHeader("ApiValue", data);
                                }
                                , success: function (data) {
                                    if (data.code == "1") {
                                        var resultList = data.result || [];
                                        var isSubmitM = false;
                                        var isSubmitL = false;

                                        resultList.forEach(function (result, i) {
                                            if (result.oathyn == "Y" && result.examGbn == "01") {
                                                isSubmitM = true;
                                            } else if (result.oathyn == "Y" && result.examGbn == "02") {
                                                isSubmitL = true;
                                            }
                                        });

                                        if (examStareTypeCd == "M" && isSubmitM) {
                                            alert("<spring:message code='exam.alert.already.submit.oath' />");/* 이미 서약서를 제출하였습니다. */
                                        } else if (examStareTypeCd == "L" && isSubmitL) {
                                            alert("<spring:message code='exam.alert.already.submit.oath' />");/* 이미 서약서를 제출하였습니다. */
                                        } else {
                                            openExamOauthPop(examStareTypeCd);
                                        }
                                    }
                                }
                                , error: function (jqXHR) {
                                    console.log(jqXHR.responseText);
                                }
                            });
                        }, function (xhr, status, error) {
                            alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
                        });
                    } else {
                        var start = dateFormat("date", startDt);
                        var end = dateFormat("date", endDt);
                        alert("<spring:message code='exam.alert.oath.submit.dttm' arguments='"+start+","+end+"' />");/* 시험서약서 제출 기간은 {0} ~ {1}입니다. */
                    }
                } else {
                    alert("<spring:message code='sys.alert.already.job.sch' />");/* 등록된 일정이 없습니다. */
                }
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='exam.error.info' />");/* 정보 조회 중 에러가 발생하였습니다. */
        });
    }

    // 서약서 화면 호출
    function openExamOauthPop(type) {
        var url = "";
        if (type == "M") {
            url = "${examOathMidUrl}";
        } else if (type == "L") {
            url = "${examOathEndUrl}";
        }
        window.open(url, "examOathWin", "scrollbars=yes,width=900,height=950,location=no,resizable=yes");
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

    // 장애인 시험지원 신청
    /* function examDsblReqApplicate() {
        var url  = "/exam/stuExamDsblReqApplicate.do";
        var data = {
            "userId" : "${vo.userId}"
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				alert("<spring:message code='exam.alert.apply' />"); // 신청이 완료되었습니다.
				listExamDsblReq();
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.apply' />"); // 신청 중 에러가 발생하였습니다.
		});
	} */

    // 장애학생 시험지원 취소
    /* function examDsblReqCancel() {
        if(window.confirm("<spring:message code='exam.confirm.exam.dsbl.req.cancel' />")) { // 장애인 시험지원 신청을 취소하시겠습니까?
			var url  = "/exam/stuExamDsblReqCancel.do";
			var data = {
				"userId" : "${vo.userId}",
				"disabilityCancelGbn" : "APPLICATE"
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					alert("<spring:message code='exam.alert.cancel' />"); // 취소가 완료되었습니다.
					listExamDsblReq();
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert("<spring:message code='exam.error.cancel' />"); // 취소 중 에러가 발생하였습니다.
			});
		}
	} */

    // 결시원 신청하기
    function examAbsentApplicate(crsCreCd, examCd, stdNo, type) {
        var calendarCtgr;

        if (type == "M") {
            calendarCtgr = "00190902"; // 결시원신청(학생) 중간
        } else if (type == "L") {
            calendarCtgr = "00190903"; // 결시원신청(학생) 기말
        }

        var url = "/jobSchHome/viewSysJobSch.do";
        var data = {
            "crsCreCd": crsCreCd,
            "calendarCtgr": calendarCtgr,
            "termCd": "${termVO.termCd}"
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnVO = data.returnVO;
                if (returnVO != null) {
                    var jobSchPeriodYn = returnVO.jobSchPeriodYn;

                    if (jobSchPeriodYn == "Y") {
                        var url = "/exam/examStareByStdNo.do";
                        var data = {
                            "examCd": examCd,
                            "stdNo": stdNo
                        };

                        ajaxCall(url, data, function (data) {
                            if (data.result > 0) {
                                if (data.returnVO.examStareYn == "Y") {
                                    var examStareTypeNm = data.returnVO.examStareTypeCd == "M" ? "<spring:message code='exam.label.mid' />"/* 중간 */ : "<spring:message code='exam.label.final' />"/* 기말 */;
                                    alert(data.returnVO.haksaYear + " / " + data.returnVO.haksaTerm + " / [" + examStareTypeNm + "] <spring:message code='exam.alert.exam.stare.y.not.absent.aplicate' />");/* 실시간 시험을 이미 응시하여서 결시원 신청이 불가합니다. */
                                } else {
                                    var kvArr = [];
                                    kvArr.push({'key': 'stdNo', 'val': stdNo});
                                    kvArr.push({'key': 'crsCreCd', 'val': crsCreCd});
                                    kvArr.push({'key': 'examCd', 'val': examCd});
                                    kvArr.push({'key': 'searchMenu', 'val': type});

                                    submitForm("/exam/stuExamAbsentApplicatePop.do", "examPopIfm", "absentAppl", kvArr);
                                }
                            } else {
                                alert(data.message);
                            }
                        }, function (xhr, status, error) {
                            alert("<spring:message code='exam.error.info' />");// 정보 조회 중 에러가 발생하였습니다.
                        });
                    } else {
                        alert("<spring:message code='exam.alert.absent.applicate.not.datetime' />");/* 결시원 신청은 신청기간 안에만 가능합니다. */
                    }
                } else {
                    alert("<spring:message code='sys.alert.already.job.sch' />");/* 등록된 일정이 없습니다. */
                }
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='exam.error.info' />");/* 정보 조회 중 에러가 발생하였습니다. */
        });
    }

    // 결시 내역 팝업
    function examAbsentApprView(examAbsentCd) {
        var kvArr = [];
        kvArr.push({'key': 'examAbsentCd', 'val': examAbsentCd});

        submitForm("/exam/stuExamAbsentApprViewPop.do", "examPopIfm", "absentView", kvArr);
        $("#examPop > div.modal-dialog").addClass("modal-extra-lg");
    }

    // 시험 응시
    function examStare(type, examCd, examStartDttm, examEndDttm, examStareTypeCd) {
        if ("mobile" == "<%=CommonUtil.getDeviceType(request)%>") {
            alert("<spring:message code='exam.alert.not_avail_mobile' />");
            return;
        }

        if (type == "A") {
            var siteCd = type == "A" ? "0003" : "${creCrsVO.uniCd}" == "G" ? "0004" : "0001";
            var url = "/exam/examStareEncrypto.do";
            var data = {
                "siteCd": siteCd,
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
                alert("<spring:message code='fail.common.msg' />");// 에러가 발생했습니다!
            });
        } else {
            getExamInfo(examCd).done(function (examInfo) {
                if (examInfo.erpExamStatus == "완료") {
                    var siteCd = type == "A" ? "0003" : "${creCrsVO.uniCd}" == "G" ? "0004" : "0001";
                    var url = "/exam/examStareEncrypto.do";
                    var data = {
                        "siteCd": siteCd,
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
                        alert("<spring:message code='fail.common.msg' />"); // 에러가 발생했습니다!
                    });
                } else if (examInfo.erpExamStatus == "진행") {
                    var url = "/exam/oathHeader.do";

                    ajaxCall(url, null, function (data) {
                        // 시험 서약서 제출 여부 확인
                        var url = "<%=CommConst.EXT_URL_EXAMOATH_CHECK%>findExamOathDocLists";
                        var param = {
                            persNo: '${vo.userId}'
                            , yyTmGbn: '${creCrsVO.creYear}${creCrsVO.creTerm}'
                        };

                        $.ajax({
                            url: url
                            , type: "POST"
                            , data: JSON.stringify(param)
                            , beforeSend: function (xhr) {
                                xhr.setRequestHeader("Content-type", "application/json");
                                xhr.setRequestHeader("ApiValue", data);
                            }
                            , success: function (data) {
                                if (data.code == "1") {
                                    var resultList = data.result || [];
                                    var isSubmitM = false;
                                    var isSubmitL = false;

                                    resultList.forEach(function (result, i) {
                                        if (result.oathyn == "Y" && result.examGbn == "01") {
                                            isSubmitM = true;
                                        } else if (result.oathyn == "Y" && result.examGbn == "02") {
                                            isSubmitL = true;
                                        }
                                    });

                                    if ((type == "M" && isSubmitM) || (type == "L" && isSubmitL)) {
                                        var siteCd = type == "A" ? "0003" : "${creCrsVO.uniCd}" == "G" ? "0004" : "0001";
                                        var url = "/exam/examStareEncrypto.do";
                                        var data = {
                                            "siteCd": siteCd,
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
                                            alert("<spring:message code='fail.common.msg' />"); // 에러가 발생했습니다!
                                        });
                                    } else {
                                        openExamOauthPop(examStareTypeCd);
                                    }
                                }
                            }
                            , error: function (jqXHR) {
                                console.log(jqXHR.responseText);
                            }
                        });
                    }, function (xhr, status, error) {
                        alert("<spring:message code='fail.common.msg' />"); // 에러가 발생했습니다!
                    });
                } else {
                    alert("<spring:message code='exam.alert.exam.stare.day' />"); // 시험 당일에만 응시가능합니다.
                }
            });
        }
    }

    // 시험 정보 페이지
    function examView(examCd, examTypeCd, insRefCd, insStartDttm, insEndDttm, periodAfterWriteYn, extSendAcptYn, extSendDttm) {
        var typeMap = {
            "ASMNT": {"url": "/asmt/stu/asmtInfoManage.do", "code": "asmntCd", "codeCd": insRefCd},
            "FORUM": {"url": "/forum/forumHome/Form/forumView.do", "code": "forumCd", "codeCd": insRefCd},
            "QUIZ": {"url": "/exam/stuExamView.do", "code": "examCd", "codeCd": examCd},
            "EXAM": {"url": "/exam/stuExamView.do", "code": "examCd", "codeCd": examCd}
        };

        if (examTypeCd == "FORUM" || examTypeCd == "ASMNT") {
            if (!timeCheck(insStartDttm, insEndDttm, periodAfterWriteYn, examTypeCd, extSendAcptYn, extSendDttm)) {
                return false;
            }
        }

        var kvArr = [];
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'stdNo', 'val': "${vo.stdNo}"});
        kvArr.push({'key': 'examType', 'val': "${vo.examType}"});
        kvArr.push({'key': typeMap[examTypeCd]["code"], 'val': typeMap[examTypeCd]["codeCd"]});

        submitForm(typeMap[examTypeCd]["url"], "", "", kvArr);
    }

    // 대체 과제 참여
    function insInfoView(type, code, startDttm, endDttm, periodAfterWriteYn, extSendAcptYn, extSendDttm) {
        var typeMap = {
            "EXAM": {"url": "/exam/stuExamView.do", "code": "examCd"},
            "QUIZ": {"url": "/quiz/stuQuizView.do", "code": "examCd"},
            "ASMNT": {"url": "/asmt/stu/asmtInfoManage.do", "code": "asmntCd"},
            "FORUM": {"url": "/forum/forumHome/Form/forumView.do", "code": "forumCd"}
        }

        if (type == "FORUM" || type == "ASMNT") {
            if (!timeCheck(startDttm, endDttm, periodAfterWriteYn, type, extSendAcptYn, extSendDttm)) {
                return false;
            }
        }

        var kvArr = [];
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'stdNo', 'val': "${vo.stdNo}"});
        kvArr.push({'key': 'examType', 'val': "${vo.examType}"});
        kvArr.push({'key': typeMap[type]["code"], 'val': code});

        submitForm(typeMap[type]["url"], "", "", kvArr);
    }

    // 기간 체크
    function timeCheck(startDttm, endDttm, periodAfterWriteYn, type, extSendAcptYn, extSendDttm) {
        var date = new Date();
        var year = date.getFullYear();
        var month = ("0" + (1 + date.getMonth())).slice(-2);
        var day = ("0" + date.getDate()).slice(-2);
        var hours = ("0" + date.getHours()).slice(-2);
        var minutes = ("0" + date.getMinutes()).slice(-2);
        var seconds = ("0" + date.getSeconds()).slice(-2);

        var today = year + month + day + hours + minutes + seconds;

        if (startDttm <= today && today <= endDttm) {
        } else {
            if (type == "FORUM") {
                if (periodAfterWriteYn == 'Y') {
                } else {
                    alert("<spring:message code='forum.alert.forum.date.no' />"); // 토론기간이 아닙니다.
                    return false;
                }
            } else if (type == "ASMNT") {
                if (extSendAcptYn == "Y" && today <= extSendDttm) {
                } else {
                    alert("<spring:message code='asmnt.alert.not.send.date' />");/* 과제 제출기간이 아닙니다. */
                    return false;
                }
            }
        }
        return true;
    }

    // 시험 정보 조회
    function getExamInfo(examCd) {
        var deferred = $.Deferred();

        var url = "/exam/examCopy.do";
        var data = {
            crsCreCd: "${vo.crsCreCd}"
            , stdNo: "${vo.stdNo}"
            , examCtgrCd: "EXAM"
            , examSubmitYn: "Y"
            , examCd: examCd
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnVO = data.returnVO;
                deferred.resolve(returnVO);
            } else {
                alert(data.message);
                deferred.reject();
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='exam.error.info' />"); // 정보 조회 중 에러가 발생하였습니다.
            deferred.reject();
        }, true);

        return deferred.promise();
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
                    </div>
                    <c:if test="${vo.examType eq 'EXAM' }">
                        <div class="row">
                            <div class="col flex flex-column" id="midExamDiv"></div>
                            <div class="col flex flex-column" id="endExamDiv"></div>
                        </div>
                        <%
                            if("mobile".equals(CommonUtil.getDeviceType(request))) {
                        %>
                        <div class="ui small error message">
                            <i class="info circle icon"></i>
                            <spring:message code='exam.alert.not_avail_mobile'/>
                            <!-- 실시간 시험은 모바일로 응시할 수 없으니 PC로 접속해주시기 바랍니다. -->
                        </div>
                        <%
                            }
                        %>
                    </c:if>
                    <c:if test="${vo.examType eq 'ADMISSION' }">
                        <div class="row">
                            <div class="col">
                                <div class="option-content pb10">
                                    <h3 class="sec_head">
                                        <spring:message code="exam.label.always.exam" /><!-- 수시평가 --></h3>
                                </div>
                                <table class="table type2" data-sorting="false" data-paging="false"
                                       data-empty="<spring:message code='exam.common.empty' />" id="examEtcListTable">
                                    <!-- 등록된 내용이 없습니다. -->
                                    <caption class="hide"><spring:message code="exam.label.always.exam"/></caption>
                                    <thead>
                                    <tr class="ui native sticky top0">
                                        <th class="tc">No</th>
                                        <th class="tc">
                                            <spring:message code="exam.label.admission.nm" /><!-- 수시평가명 --></th>
                                        <th class="tc" data-breakpoints="xs sm">
                                            <spring:message code="exam.label.exam.type" /><!-- 시험유형 --></th>
                                        <th class="tc" data-breakpoints="xs">
                                            <spring:message code="exam.label.exam.dttm" /><!-- 시험일시 --></th>
                                        <th class="tc" data-breakpoints="xs">
                                            <spring:message code="exam.label.exam.time" /><!-- 시험시간 --></th>
                                        <th class="tc" data-breakpoints="xs sm">
                                            <spring:message code="exam.label.score.aply.y" /><!-- 성적반영 --></th>
                                        <th class="tc" data-breakpoints="xs sm md">
                                            <spring:message code="exam.label.eval.stare.status" /><!-- 응시/평가현황 --></th>
                                        <th class="tc"><spring:message code="exam.label.manage" /><!-- 관리 --></th>
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
                                    <h3 class="sec_head mr20"><spring:message code="exam.label.dsbl.req"/>
                                        <spring:message code="exam.label.applicate"/></h3><!-- 장애인 시험지원 --><!-- 신청 -->
                                    <span>[ <spring:message code="exam.label.total.cnt"/> : <label id="examDsblReqCnt"
                                                                                                   class="fcBlue"></label> ]</span>
                                    <!-- 총 건수 -->
                                        <%-- <c:if test="${PROFESSOR_VIRTUAL_LOGIN_YN ne 'Y'}">
                                        <div class="mla">
                                            <button class="ui blue button small dsblBtn" id="applicateBtn" onclick="examDsblReqApplicate()"><spring:message code="exam.label.dsbl.req.applicate" /></button><!-- 장애학생 시험지원 신청 -->
                                            <button class="ui blue button small dsblBtn" id="cancelBtn" onclick="examDsblReqCancel()"><spring:message code="exam.label.dsbl.req.cancel" /></button><!-- 장애학생 시험지원 취소 -->
                                        </div>
                                        </c:if> --%>
                                </div>
                                <table class="table type2" data-sorting="false" data-paging="false"
                                       data-empty="<spring:message code='exam.common.empty' />" id="dsblReqListTable">
                                    <!-- 등록된 내용이 없습니다. -->
                                    <caption class="hide"><spring:message code="exam.label.dsbl.req"/></caption>
                                    <thead>
                                    <tr>
                                        <th scope="col" class="tc num">NO.</th>
                                        <th scope="col" class="tc"><spring:message code="crs.label.crecrs.nm"/></th>
                                        <!-- 과목명 -->
                                        <th scope="col" class="tc" data-breakpoints="xs"><spring:message
                                                code="crs.label.decls"/></th><!-- 분반 -->
                                        <th scope="col" class="tc" data-breakpoints="xs"><spring:message
                                                code="exam.label.applicate"/><spring:message
                                                code="exam.label.term"/></th><!-- 신청 --><!-- 학기 -->
                                        <th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message
                                                code="exam.label.std.request"/></th><!-- 학생요청사항 -->
                                        <th scope="col" class="tc" data-breakpoints="xs sm"><spring:message
                                                code="exam.label.request.result"/></th><!-- 요청결과 -->
                                        <th scope="col" class="tc"><spring:message
                                                code="exam.label.approve.status"/></th><!-- 승인상태 -->
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
                                <div class="option-content">
                                    <h3 class="sec_head mr20"><spring:message code="exam.label.absent"/> <spring:message
                                            code="exam.label.applicate"/></h3><!-- 결시원 --><!-- 신청 -->
                                    <span>[ <spring:message code="exam.label.total.cnt"/> : <label id="examAbsentCnt"
                                                                                                   class="fcBlue"></label> ]</span>
                                    <!-- 총 건수 -->
                                </div>
                                <div class="mb20 tc bcLYellow p10 ui message">
                                    <fmt:parseDate var="midSchStartDtFmt" pattern="yyyyMMddHHmmss"
                                                   value="${midSysJobSchVO.schStartDt }"/>
                                    <fmt:formatDate var="midSchStartDt" pattern="yyyy.MM.dd HH:mm"
                                                    value="${midSchStartDtFmt }"/>
                                    <fmt:parseDate var="midSchEndDtFmt" pattern="yyyyMMddHHmmss"
                                                   value="${midSysJobSchVO.schEndDt }"/>
                                    <fmt:formatDate var="midSchEndDt" pattern="yyyy.MM.dd HH:mm"
                                                    value="${midSchEndDtFmt }"/>

                                    <fmt:parseDate var="lastSchStartDtFmt" pattern="yyyyMMddHHmmss"
                                                   value="${lastSysJobSchVO.schStartDt }"/>
                                    <fmt:formatDate var="lastSchStartDt" pattern="yyyy.MM.dd HH:mm"
                                                    value="${lastSchStartDtFmt }"/>
                                    <fmt:parseDate var="lastSchEndDtFmt" pattern="yyyyMMddHHmmss"
                                                   value="${lastSysJobSchVO.schEndDt }"/>
                                    <fmt:formatDate var="lastSchEndDt" pattern="yyyy.MM.dd HH:mm"
                                                    value="${lastSchEndDtFmt }"/>

                                    <b><spring:message code="exam.label.absent"/> <spring:message
                                            code="exam.label.applicate"/><spring:message code="exam.label.period"/></b>
                                    <!-- 결시원 --><!-- 신청 --><!-- 기간 -->
                                    <br/>
                                    <span class="fcOrange"><spring:message code="exam.label.mid.exam" /><!-- 중간고사 --> : <c:choose><c:when
                                            test="${empty midSysJobSchVO}">-</c:when><c:otherwise>${midSchStartDt} ~ ${midSchEndDt}</c:otherwise></c:choose></span>
                                    <span class="ml5 mr5">|</span>
                                    <span class="fcOrange"><spring:message code="exam.label.end.exam" /><!-- 기말고사 --> : <c:choose><c:when
                                            test="${empty lastSysJobSchVO}">-</c:when><c:otherwise>${lastSchStartDt} ~ ${lastSchEndDt}</c:otherwise></c:choose></span>
                                    <br/>
                                    <!-- 결시원 승인여부 및 대체평가 등의 후속조치는 <span class="fcBlue">담당과목 교수님의 재량으로 교수님께 문의</span>하여 주시기 바랍니다. -->
                                    <spring:message code="exam.label.exam.absent.period.guide"/>
                                </div>
                                <table class="table type2" data-sorting="false" data-paging="false"
                                       data-empty="<spring:message code='exam.common.empty' />" id="absentListTable">
                                    <!-- 등록된 내용이 없습니다. -->
                                    <caption class="hide"><spring:message code="exam.label.absent"/></caption>
                                    <thead>
                                    <tr>
                                        <th scope="col" class="tc num">NO.</th>
                                        <th scope="col" class="tc"><spring:message code="crs.label.crecrs.nm"/></th>
                                        <!-- 과목명 -->
                                        <th scope="col" class="tc" data-breakpoints="xs"><spring:message
                                                code="crs.label.decls"/></th><!-- 분반 -->
                                        <th scope="col" class="tc" data-breakpoints="xs sm"><spring:message
                                                code="exam.label.exam"/><spring:message
                                                code="exam.label.stare.type"/></th><!-- 시험 --><!-- 구분 -->
                                        <th scope="col" class="tc" data-breakpoints="xs sm"><spring:message
                                                code="exam.label.applicate.dttm"/></th><!-- 신청일시 -->
                                        <th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message
                                                code="exam.label.real.time.exam"/><spring:message
                                                code="exam.label.answer.yn"/></th><!-- 실시간시험 --><!-- 응시여부 -->
                                        <th scope="col" class="tc" data-breakpoints="xs"><spring:message
                                                code="exam.label.process.status"/></th><!-- 처리상태 -->
                                        <th scope="col" class="tc" data-breakpoints="xs"><spring:message
                                                code="exam.label.process.dttm"/></th><!-- 처리일시 -->
                                        <th scope="col" class="tc"><spring:message code="exam.label.applicate"/></th>
                                        <!-- 신청 -->
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