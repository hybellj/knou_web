<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/xeicon.css"/>
<link rel="stylesheet" type="text/css" href="/webdoc/css/xeicon.min.css"/>

<script type="text/javascript">
    var SEARCH_OBJ;

    $(function () {
        //조회, 미평가, 결시원승인, 결시원신청
        $("#searchBtn, #btnZero, #btnApprove, #btnApplicate, #btnReExam, #btnF").on("click", function () {
            onSearch($(this).attr("id"));
        });

        $("#searchValue").on("keydown", function (e) {
            if (e.keyCode == 13) {
                creCrsList();
            }
        });
    });

    //과정유형 선택
    function selectContentCrsType(obj) {
        if ($(obj).hasClass("basic")) {
            $(obj).removeClass("basic").addClass("active");
        } else {
            $(obj).removeClass("active").addClass("basic");
        }
    }

    // 과목 목록
    function creCrsList() {
        var crsTypeCd = "";
        $(".crsTypeBtn").each(function (i, v) {
            if ($(v).hasClass("active")) {
                if (crsTypeCd == "") {
                    crsTypeCd = $(v).attr("data-crs-type-cd");
                } else {
                    crsTypeCd += "," + $(v).attr("data-crs-type-cd");
                }
            }
        });
        var url = "/grade/gradeMgr/gradeInputCreCrsList.do";
        var data = {
            "creYear": $("#creYear").val(),
            "creTerm": $("#creTerm").val(),
            "uniCd": $("#uniCd").val(),
            "crsTypeCd": crsTypeCd,
            "mngtDeptCd": $("#mngtDeptCd").val(),
            "searchValue": $("#searchValue").val()
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnList = data.returnList || [];
                var totCnt = returnList.length > 0 ? returnList.length : 0;
                var html = "";

                if (returnList.length > 0) {
                    returnList.forEach(function (v, i) {
                        var uniNm = v.uniCd == "C" ? "<spring:message code='common.label.uni.c' />"/* 대학 */ : "<spring:message code='common.label.uni.g' />"/* 대학원 */;
                        html += "<tr data-crsCreCd=\"" + v.crsCreCd + "\">"
                        html += "	<td>" + v.lineNo + "</td>";
                        html += "	<td>" + uniNm + "</td>";
                        html += "	<td>" + v.deptNm + "</td>";
                        html += "	<td>" + v.crsCd + "</td>";
                        html += "	<td>" + v.declsNo + "</td>";
                        html += "	<td>" + v.crsCreNm + "</td>";
                        html += "	<td>" + v.compDvNm + "</td>";
                        html += "	<td>" + v.credit + "</td>";
                        html += "	<td>" + v.tchNm + "</td>";
                        html += "	<td>" + v.tchNo + "</td>";
                        html += "	<td>" + v.stdCnt + "</td>";
                        html += "	<td>" + v.scoreEvalTypeNm + "</td>";
                        html += "	<td>등급</td>";
                        html += "</tr>";
                    });
                }

                $("#creCrsCnt").text(totCnt);
                $("#creCrsTbody").empty().html(html);
                $("#creCrsTable").footable();
                $(".stdDiv").hide();

                $("#creCrsTbody tr").off("click").on("click", function () {
                    $("#creCrsTable tr").removeClass("on");
                    $(this).addClass("on");
                    onSearch();
                });
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
        });
    }

    var middleTestHead, lastTestHead, testHead, lessonHead, assignmentHead, forumHead, quizHead = "", reshHead;
    var ratioArr = new Array();

    // 수강생 목록
    function onSearch(searchType) {
        var url = "/score/scoreOverall/selectOverallList.do";
        var param = {
            crsCreCd: $("#creCrsTbody tr.on").attr("data-crsCreCd"),
            searchValue: $("#stdSearchValue").val(),
            searchType: searchType,
        };

        ajaxCall(url, param, function (data) {
            if (data.result > 0) {
                var returnList = data.returnList || [];
                var subVO = data.returnSubVO;
                var html = "";

                middleTestHead = Number(subVO && subVO.middleTestScoreRatio);
                lastTestHead = Number(subVO && subVO.lastTestScoreRatio);
                testHead = Number(subVO && subVO.testScoreRatio);

                lessonHead = Number(subVO && subVO.lessonScoreRatio);
                assignmentHead = Number(subVO && subVO.assignmentScoreRatio);
                forumHead = Number(subVO && subVO.forumScoreRatio);
                quizHead = Number(subVO && subVO.quizScoreRatio);
                reshHead = Number(subVO && subVO.reshScoreRatio);

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

                // 테이블 생성
                html += "<table class='table type2' id='stdTable' data-sorting='true' data-paging='false' data-empty='" + "<spring:message code='common.content.not_found' />" + "'>";
                html += "	<thead>";
                html += "		<tr>";
                html += "			<th>";
                html += "				<div class='ui checkbox'>";
                html += "					<input type='checkbox' name='allEvalChk' id='allChk' value='all' onclick='checkStd(this)'>";
                html += "					<label class='toggle_btn' for='allChk'></label>";
                html += "				</div>";
                html += "			</th>";
                html += "			<th>No</th>";
                html += "			<th>학과</th>";
                html += "			<th>학번</th>";
                html += "			<th>이름</th>";
                html += "			<th>학점등급</th>";
                html += "			<th>환산총점</th>";
                html += "			<th>산출총점</th>";
                if (middleTestHead > 0) html += "<th>중간고사(" + middleTestHead + "%)</th>";
                if (lastTestHead > 0) html += "<th>기말고사(" + lastTestHead + "%)</th>";
                if (testHead > 0) html += "<th>수시평가(" + testHead + "%)</th>";
                if (lessonHead > 0) html += "<th>출석/강의(" + lessonHead + "%)</th>";
                if (assignmentHead > 0) html += "<th>과제(" + assignmentHead + "%)</th>";
                if (forumHead > 0) html += "<th>토론(" + forumHead + "%)</th>";
                if (quizHead > 0) html += "<th>퀴즈(" + quizHead + "%)</th>";
                if (reshHead > 0) html += "<th>설문(" + reshHead + "%)</th>";
                html += "			<th>상태</th>";
                html += "			<th>관리</th>";
                html += "		</tr>";
                html += "	</thead>";
                html += "	<tbody>";
                if (returnList.length > 0) {
                    returnList.forEach(function (v, i) {
                        var scoreGrade = v.scoreStatus == "3" && v.scoreGrade != null ? v.scoreGrade : "-";
                        var totScore = v.scoreStatus == "3" && v.totScore != null ? v.totScore : "-";
                        var finalScore = v.finalScore == null ? "-" : v.finalScore;
                        var scoreStatus = v.scoreStatus == "1" ? "환산 전" : v.scoreStatus == "2" ? "환산 중" : "환산 완료";

                        var middleTestScore = Number(v.middleTestScore) == "-1" ? "-" : Number(v.middleTestScore);
                        var lastTestScore = Number(v.lastTestScore) == "-1" ? "-" : Number(v.lastTestScore);
                        var testScore = Number(v.testScore) == "-1" ? "-" : Number(v.testScore);
                        var lessonScore = Number(v.lessonScore) == "-1" ? "-" : Number(v.lessonScore);
                        var assignmentScore = Number(v.assignmentScore) == "-1" ? "-" : Number(v.assignmentScore);
                        var forumScore = Number(v.forumScore) == "-1" ? "-" : Number(v.forumScore);
                        var quizScore = Number(v.quizScore) == "-1" ? "-" : Number(v.quizScore);
                        var reshScore = Number(v.reshScore) == "-1" ? "-" : Number(v.reshScore);
                        var etcScore = Number(v.etcScore);

                        var lessonScoreAvg = Number(v.lessonScoreAvg);
                        var middleTestScoreAvg = Number(v.middleTestScoreAvg);
                        var lastTestScoreAvg = Number(v.lastTestScoreAvg);
                        var testScoreAvg = Number(v.testScoreAvg);
                        var assignmentScoreAvg = Number(v.assignmentScoreAvg);
                        var forumScoreAvg = Number(v.forumScoreAvg);
                        var quizScoreAvg = Number(v.quizScoreAvg);
                        var reshScoreAvg = Number(v.reshScoreAvg);

                        var midTdColor = "";
                        var lastTdColor = "";

                        if (v.apprStatM) {
                            if (v.apprStatM == "APPLICATE" || v.apprStatM == "RAPPLICATE") {
                                midTdColor = "bcGreenAlpha30";
                            } else if (v.apprStatM == "APPROVE") {
                                midTdColor = "bcBlueAlpha30";
                            }
                        }

                        if (v.apprStatL) {
                            if (v.apprStatL == "APPLICATE" || v.apprStatL == "RAPPLICATE") {
                                lastTdColor = "bcGreenAlpha30";
                            } else if (v.apprStatM == "APPROVE") {
                                lastTdColor = "bcBlueAlpha30";
                            }
                        }

                        if (v.reExamYnM && v.reExamYnM == "Y") {
                            if (midTdColor == "bcGreenAlpha30") {
                                midTdColor = "bcGreenYellowAlpha30";
                            } else if (midTdColor == "bcBlueAlpha30") {
                                midTdColor = "bcBlueYellowAlpha30";
                            } else {
                                midTdColor = "bcYellowAlpha30";
                            }
                        }

                        if (v.reExamYnL && v.reExamYnL == "Y") {
                            if (lastTdColor == "bcGreenAlpha30") {
                                lastTdColor = "bcGreenYellowAlpha30";
                            } else if (lastTdColor == "bcBlueAlpha30") {
                                lastTdColor = "bcBlueYellowAlpha30";
                            } else {
                                lastTdColor = "bcYellowAlpha30";
                            }
                        }


                        html += "		<tr data-sort-user-no='" + v.userId + "'>";
                        html += "			<td>";
                        html += "				<div class='ui checkbox'>";
                        html += "					<input type='checkbox' name='list[" + i + "].dataChk' id='evalChk" + i + "' onclick='checkStd(this)' user_id='" + v.userId + "' user_nm='" + v.userNm + "' mobile='" + v.userMobileNo + "' email='" + v.userEmail + "' />";
                        html += "					<label class='toggle_btn' for='evalChk" + i + "'></label>";
                        html += "				</div>";
                        html += "			</td>";
                        html += "			<td name='lineNo'>" + v.lineNo + "</td>";
                        html += "			<td data-sort-value=\"" + v.deptNm + "\"><span class=''>" + v.deptNm + "</span></td>";
                        html += "    		<td class='word_break_none tc' data-sort-value='A" + v.userId.padEnd(12, "0") + "'>";
                        html += "        		<span class=''>" + v.userId + "</span>";
                        html += "        		<input type='hidden' name='list[" + i + "].stdNo' value='" + v.stdNo + "'>";
                        html += "        		<input type='hidden' name='list[" + i + "].userId' value='" + v.userId + "'>";
                        html += "        		<input type='hidden' name='list[" + i + "].userMobileNo' value='" + v.userMobileNo + "'>";
                        html += "       		<input type='hidden' name='list[" + i + "].userEmail' value='" + v.userEmail + "'>";
                        html += "        		<input type='hidden' name='list[" + i + "].lessonItemId' value='" + v.lessonItemId + "'>";
                        html += "        		<input type='hidden' name='list[" + i + "].middleTestItemId' value='" + v.middleTestItemId + "'>";
                        html += "        		<input type='hidden' name='list[" + i + "].lastTestItemId' value='" + v.lastTestItemId + "'>";
                        html += "        		<input type='hidden' name='list[" + i + "].testItemId' value='" + v.testItemId + "'>";
                        html += "        		<input type='hidden' name='list[" + i + "].assignmentItemId' value='" + v.assignmentItemId + "'>";
                        html += "        		<input type='hidden' name='list[" + i + "].forumItemId' value='" + v.forumItemId + "'>";
                        html += "        		<input type='hidden' name='list[" + i + "].quizItemId' value='" + v.quizItemId + "'>";
                        html += "        		<input type='hidden' name='list[" + i + "].reshItemId' value='" + v.reshItemId + "'>";
                        html += "        		<input type='hidden' name='list[" + i + "].rowStatus' value='N'>";
                        html += "        		<i class='xi-pen-o f120' onclick=\"setMemo('" + v.stdNo + "')\" style='cursor:pointer' title='메모'></i>";
                        html += "			</td>";
                        html += "			<td class='word_break_none tc' data-sort-value='" + v.userNm + "'><span class=''>" + v.userNm + "</span><a href='javascript:userInfoPop(\"" + v.userId + "\")' class='ml5'><i class='ico icon-info'></i></a></td>";
                        html += "			<td>" + scoreGrade + "</td>";
                        html += "			<td>" + totScore + "</td>";
                        html += "			<td>" + finalScore + "</td>";
                        if (subVO.middleTestScoreRatio > 0) {
                            var midNoEvalClass = v.midNoEvalCnt > 0 ? 'bcRedAlpha30' : '';
                            html += "			<td class='word_break_none " + midTdColor + "' data-sort-value='" + getSortScore(middleTestScore) + "'>";
                            html += "				<span name='chgSpanText'>" + middleTestScore + "</span>";
                            html += "    			<div class='ui input w50' name='chgInputText'>";
                            html += "            		<input type='text' name='list[" + i + "].middleTestInput' class='inScore " + midNoEvalClass + "' value='" + middleTestScore + "' placeholder='0' maxlength='5' onKeyup=\"scoreValidation(this)\">";
                            html += "       		</div>";
                            html += "    			<i class='right chevron icon f075 opacity5'></i>";
                            if (middleTestScore > -1) {
                                html += "    			<span class='fcBlue'>" + middleTestScoreAvg + "</span>";
                            } else {
                                html += "    			<a href='javascript:;' onclick='goCrsCreCtgr(\"minTest\")'><span class='fcBlue'>-</span></a>";
                            }
                            html += "       		<input type='hidden' name='list[" + i + "].middleTestScoreAvg' value='" + middleTestScoreAvg + "' placeholder='0'>";
                            html += "			</td>";
                        }
                        if (subVO.lastTestScoreRatio > 0) {
                            var lastNoEvalClass = v.lastNoEvalCnt > 0 ? 'bcRedAlpha30' : '';
                            html += "			<td class='word_break_none " + lastTdColor + "' data-sort-value='" + getSortScore(lastTestScore) + "'>";
                            html += "				<span name='chgSpanText'>" + lastTestScore + "</span>";
                            html += "    			<div class='ui input w50' name='chgInputText'>";
                            html += "            		<input type='text' name='list[" + i + "].lastTestInput' class='inScore " + lastNoEvalClass + "' value='" + lastTestScore + "' placeholder='0' maxlength='5' onKeyup=\"scoreValidation(this)\">";
                            html += "        		</div>";
                            html += "    			<i class='right chevron icon f075 opacity5'></i>";
                            if (lastTestScore > -1) {
                                html += "    		<span class='fcBlue'>" + lastTestScoreAvg + "</span>";
                            } else {
                                html += "    		<a href='javascript:;' onclick='goCrsCreCtgr(\"lastTest\")'><span class='fcBlue'>-</span></a>";
                            }
                            html += "       		<input type='hidden' name='list[" + i + "].lastTestScoreAvg' value='" + lastTestScoreAvg + "' placeholder='0'>";
                            html += "			</td>";
                        }
                        if (subVO.testScoreRatio > 0) {
                            var testNoEvalClass = v.testNoEvalCnt > 0 ? 'bcRedAlpha30' : '';
                            html += "			<td class='word_break_none' data-sort-value='" + getSortScore(testScore) + "'>";
                            html += "				<span name='chgSpanText'>" + testScore + "</span>";
                            html += "    			<div class='ui input w50' name='chgInputText'>";
                            html += "            		<input type='text' name='list[" + i + "].testInput' class='inScore " + testNoEvalClass + "' value='" + testScore + "' placeholder='0' maxlength='5' onKeyup=\"scoreValidation(this)\">";
                            html += "        		</div>";
                            html += "    			<i class='right chevron icon f075 opacity5'></i>";
                            if (testScore > -1) {
                                html += "    		<span class='fcBlue'>" + testScoreAvg + "</span>";
                            } else {
                                html += "    		<a href='javascript:;' onclick='goCrsCreCtgr(\"test\")'><span class='fcBlue'>-</span></a>";
                            }
                            html += "       		<input type='hidden' name='list[" + i + "].testScoreAvg' value='" + testScoreAvg + "' placeholder='0'>";
                            html += "			</td>";
                        }
                        if (subVO.lessonScoreRatio > 0) {
                            html += "			<td class='word_break_none' data-sort-value='" + getSortScore(lessonScore) + "'>";
                            html += "				<span name='chgSpanText'>" + lessonScore + "</span>";
                            html += "    			<div class='ui input w50 tr' name='chgInputText'>";
                            html += "    				" + lessonScore + "";
                            html += "            		<input type='hidden' name='list[" + i + "].lessonInput' class='inScore' value='" + lessonScore + "' placeholder='0' maxlength='5' onKeyup=\"scoreValidation(this)\" readonly='readonly' />";
                            html += "        		</div>";
                            html += "    			<i class='right chevron icon f075 opacity5'></i>";

                            html += "    			<span class='fcBlue'>" + lessonScoreAvg + "</span>";
                            html += "       		<input type='hidden' name='list[" + i + "].lessonScoreAvg' value='" + lessonScoreAvg + "' placeholder='0'>";
                            html += "			</td>";
                        }
                        if (subVO.assignmentScoreRatio > 0) {
                            var asmntNoEvalClass = v.asmntNoEvalCnt > 0 ? 'bcRedAlpha30' : '';
                            html += "			<td class='word_break_none' data-sort-value='" + getSortScore(assignmentScore) + "'>";
                            html += "				<span name='chgSpanText'>" + assignmentScore + "</span>";
                            html += "    			<div class='ui input w50' name='chgInputText'>";
                            html += "            		<input type='text' name='list[" + i + "].assignmentInput' class='inScore " + asmntNoEvalClass + "' value='" + assignmentScore + "' placeholder='0' maxlength='5' onKeyup=\"scoreValidation(this)\">";
                            html += "        		</div>";
                            html += "    			<i class='right chevron icon f075 opacity5'></i>";
                            if (assignmentScore > -1) {
                                html += "    		<span class='fcBlue'>" + assignmentScoreAvg + "</span>";
                            } else {
                                html += "    		<a href='javascript:;' onclick='goCrsCreCtgr(\"asmt\")'><span class='fcBlue'>-</span></a>";
                            }
                            html += "       		<input type='hidden' name='list[" + i + "].assignmentScoreAvg' value='" + assignmentScoreAvg + "' placeholder='0'>";
                            html += "			</td>";
                        }
                        if (subVO.forumScoreRatio > 0) {
                            var forumNoEvalClass = v.forumNoEvalCnt > 0 ? 'bcRedAlpha30' : '';
                            html += "			<td class='word_break_none' data-sort-value='" + getSortScore(forumScore) + "'>";
                            html += "				<span name='chgSpanText'>" + forumScore + "</span>";
                            html += "    			<div class='ui input w50' name='chgInputText'>";
                            html += "            		<input type='text' name='list[" + i + "].forumInput' class='inScore " + forumNoEvalClass + "' value='" + forumScore + "' placeholder='0' maxlength='5' onKeyup=\"scoreValidation(this)\">";
                            html += "        		</div>";
                            html += "    			<i class='right chevron icon f075 opacity5'></i>";
                            if (forumScore > -1) {
                                html += "    		<span class='fcBlue'>" + forumScoreAvg + "</span>";
                            } else {
                                html += "    		<a href='javascript:;' onclick='goCrsCreCtgr(\"forum\")'><span class='fcBlue'>-</span></a>";
                            }
                            html += "       		<input type='hidden' name='list[" + i + "].forumScoreAvg' value='" + forumScoreAvg + "' placeholder='0'>";
                            html += "			</td>";
                        }
                        if (subVO.quizScoreRatio > 0) {
                            var quizNoEvalClass = v.quizNoEvalCnt > 0 ? 'bcRedAlpha30' : '';
                            html += "			<td class='word_break_none' data-sort-value='" + getSortScore(quizScore) + "'>";
                            html += "				<span name='chgSpanText'>" + quizScore + "</span>";
                            html += "    			<div class='ui input w50' name='chgInputText'>";
                            html += "            		<input type='text' name='list[" + i + "].quizInput' class='inScore  " + quizNoEvalClass + "' value='" + quizScore + "' placeholder='0' maxlength='5' onKeyup=\"scoreValidation(this)\">";
                            html += "       		</div>";
                            html += "    			<i class='right chevron icon f075 opacity5'></i>";
                            if (quizScore > -1) {
                                html += "    		<span class='fcBlue'>" + quizScoreAvg + "</span>";
                            } else {
                                html += "    		<a href='javascript:;' onclick='goCrsCreCtgr(\"quiz\")'><span class='fcBlue'>-</span></a>";
                            }
                            html += "       		<input type='hidden' name='list[" + i + "].quizScoreAvg' value='" + quizScoreAvg + "' placeholder='0' >";
                            html += "			</td>";
                        }
                        if (subVO.quizScoreRatio > 0) {
                            var reschNoEvalClass = v.reschNoEvalCnt > 0 ? 'bcRedAlpha30' : '';
                            html += "			<td class='word_break_none' data-sort-value='" + getSortScore(reshScore) + "'>";
                            html += "				<span name='chgSpanText'>" + reshScore + "</span>";
                            html += "    			<div class='ui input w50' name='chgInputText'>";
                            html += "            		<input type='text' name='list[" + i + "].reshInput' class='inScore  " + reschNoEvalClass + "' value='" + reshScore + "' placeholder='0' maxlength='5' onKeyup=\"scoreValidation(this)\">";
                            html += "       		</div>";
                            html += "    			<i class='right chevron icon f075 opacity5'></i>";
                            if (quizScore > -1) {
                                html += "    		<span class='fcBlue'>" + reshScoreAvg + "</span>";
                            } else {
                                html += "    		<a href='javascript:;' onclick='goCrsCreCtgr(\"resh\")'><span class='fcBlue'>-</span></a>";
                            }
                            html += "       		<input type='hidden' name='list[" + i + "].reshScoreAvg' value='" + reshScoreAvg + "' placeholder='0' >";
                            html += "			</td>";
                        }
                        html += "			<td>" + scoreStatus + "</td>";
                        html += "			<td><button type='button' class='ui blue small button' onclick='onScoreOverallDtlPop(\"" + v.crsCreCd + "\", \"" + v.userId + "\", \"" + v.stdNo + "\")'>상세정보</button></td>";
                        html += "		</tr>";

                        $("#scoreStatus").val(v.scoreStatus);
                    });
                }
                html += "	</tbody>";
                html += "</table>";

                $("#listTotCnt").text(returnList.length);
                $("#totCnt").text(data.returnVO.totalCnt);

                $("#stdTableDiv").empty().html(html);
                $("#stdTable").footable({
                    on: {
                        "after.ft.sorting": function (e, ft, sorter) {
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
                onAbsentSearch();
                onOverallGraph("all");
                onOverallGridCase("all");
                chgButton(returnList.length > 0 ? returnList[0].scoreStatus : "1");
                chgText(returnList.length > 0 ? returnList[0].scoreStatus : "1");
                if (returnList.length > 0) {
                    if (returnList[0].scoreStatus == "1") {
                        $(".btn2").hide();
                        $(".btn1").show();
                    } else {
                        $(".btn1").hide();
                        $(".btn2").show();
                    }
                    if (returnList[0].scoreStatus == "3") {
                        $("#btnScoreCal").attr("onclick", "onScoreCal()");
                    } else {
                        $("#btnScoreCal").attr("onclick", "onAllEvlModal()");
                    }
                } else {
                    $(".btn2").hide();
                    $(".btn1").show();
                    $("#btnScoreCal").attr("onclick", "onAllEvlModal()");
                }
                var scoreStatusStr = returnList.length > 0 ? returnList[0].scoreStatus : "1";
                $("b[name=scoreStatusText]").removeClass("opacity9 fcBlue");
                $("#scoreStatusText" + scoreStatusStr).addClass("opacity9 fcBlue");
                $(".stdDiv").show();
                onAbsentSearch();

                $("input[name*=Input]").on("blur", function () {
                    this.value = Number(this.value);
                    scoreValidation(this);
                });

                // 입력값 유효성 검증 obj 세팅
                $.each($("input[name*=Input]"), function () {
                    prevInputObj[this.name] = this.value;
                });

                SEARCH_OBJ = param;
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
        }, true);
    }

    // 수강생 체크박스
    function checkStd(obj) {
        if (obj.value == "all") {
            $("input[name*=dataChk]").prop("checked", obj.checked);
            if (obj.checked) {
                $("input[name*=dataChk]").val("Y");
            } else {
                $("input[name*=dataChk]").val("N");
            }
        } else {
            $("#allChk").prop("checked", $("input[name*=dataChk]").length == $("input[name*=dataChk]:checked").length);
            if (obj.checked) {
                obj.value = "Y";
            } else {
                obj.value = "N";
            }
        }
    }

    //메세지 보내기
    function sendMsg() {
        if ($("#stdTable").find("input[name=evalChk]:checked").length == 0) {
            /* 체크된 값이 없습니다. */
            alert('<spring:message code="score.label.ect.eval.oper.msg14" />');
            return;
        }
        var rcvUserInfoStr = "";

        var sendCnt = 0;
        $.each($("#stdTable").find("input[name=evalChk]:checked"), function () {
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

    function onAbsentSearch() {
        var url = "/score/scoreOverall/selectAbsentInfo.do";
        var param = {
            crsCreCd: $("#creCrsTbody tr.on").attr("data-crsCreCd")
        };

        ajaxCall(url, param, function (data) {
            /*
            // 평가점수가져오기 상태
            $("#btnScoreCalInitStatus").removeClass("fcBlue").removeClass("fcRed")
            $("#btnScoreCalInitStatus").html("");

            // 성적환산 상태
            $("#btnScoreCalStatus").removeClass("fcBlue").removeClass("fcRed")
            $("#btnScoreCalStatus").html("");
             */
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

                /*
                if(data.scoreStatus == "2" || data.scoreStatus == "3") {
                    var initDttm = data.initDttm;
                    var initDttmFmt = initDttm.length == 14 ? initDttm.substring(0, 4) + '.' + initDttm.substring(4, 6) + '.' + initDttm.substring(6, 8) + ' ' + initDttm.substring(8, 10) + ':' + initDttm.substring(10, 12) : initDttm;

                    $("#btnScoreCalInitStatus").html(' (

                <spring:message code="score.label.excute" />[' + initDttmFmt + '])').addClass("fcBlue"); // 실행

					if(data.scoreStatus == "3") {
						var calDttm = data.calDttm;
						var calDttmFmt = calDttm.length == 14 ? calDttm.substring(0, 4) + '.' + calDttm.substring(4, 6) + '.' + calDttm.substring(6, 8) + ' ' + calDttm.substring(8, 10) + ':' + calDttm.substring(10, 12) : calDttm;

						$("#btnScoreCalStatus").html(' (

                <spring:message code="score.label.excute" />[' + calDttmFmt + '])').addClass("fcBlue"); // 실행
					} else {
						$("#btnScoreCalStatus").html(' (

                <spring:message code="score.label.unexcute" />)').addClass("fcRed"); // 미실행
					}
				} else {
					$("#btnScoreCalInitStatus").html(' (

                <spring:message code="score.label.unexcute" />)').addClass("fcRed"); // 미실행
					$("#btnScoreCalStatus").html(' (

                <spring:message code="score.label.unexcute" />)').addClass("fcRed"); // 미실행
				}
				 */
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
            alert("에러가 발생했습니다!");
        }, true);
    }

    //오른쪽 그리드 및 그래프 조회
    function onOverallGridCase(val) {
        var graphData = {
            selectType: val
            , crsCreCd: $("#creCrsTbody tr.on").attr("data-crsCreCd")
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
                                        return value
                                    }
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
        var graphData = {
            selectType: val
            , crsCreCd: $("#creCrsTbody tr.on").attr("data-crsCreCd")
        }

        var url = "";
        if (val == "all") {
            url = "/score/scoreOverall/selectOverallGraphListByGrade.do";
        } else {
            url = "/score/scoreOverall/selectOverallGraphList.do";
        }

        ajaxCall(url, graphData, function (data) {
            if (data.result > 0) {

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
                                        stepSize: 20,
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

    // 차트 변경
    function chartSet() {
        $("#scoreTypeStr").text($("#graphSelect option:selected").text());
        onOverallGraph($("#graphSelect option:selected").val());
        onOverallGridCase($("#graphSelect option:selected").val());
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
        form.append($('<input/>', {
            type: 'hidden',
            name: 'crsCreCd',
            value: $("#creCrsTbody tr.on").attr("data-crsCreCd")
        }));
        form.attr("action", url);
        form.appendTo("body");
        form.submit();
    }

    //상단버튼 변경 (초반:1, 전체:2)
    function chgButton(type) {
        if (type == "1") {
            $("#stdTableDiv").removeClass();
            $("#stdTableDiv").addClass("step bcGreenAlpha10");
        } else if (type == "2") {
            $("#stdTableDiv").removeClass();
            $("#stdTableDiv").addClass("step bcBlueAlpha10");
        } else if (type == "3") {
            $("#stdTableDiv").removeClass();
            $("#stdTableDiv").addClass("step bcdark1Alpha10");
        }
    }

    //텍스트 변경 (초반:1, 전체:2)
    function chgText(type) {
        if (type == "1") {
            $("[name=chgSpanText]").show();
            $("[name=chgInputText]").hide();
        } else {
            $("[name=chgSpanText]").hide();
            $("[name=chgInputText]").show();
        }
    }

    // 상세정보 팝업
    function onScoreOverallDtlPop(crsCreCd, userId, stdNo) {
        $("#modalScoreOverallDtlForm [name=crsCreCd]").val(crsCreCd);
        $("#modalScoreOverallDtlForm [name=userId]").val(userId);
        $("#modalScoreOverallDtlForm [name=stdNo]").val(stdNo);
        $("#modalScoreOverallDtlForm").attr("target", "modalScoreOverallDtlIfm");
        $("#modalScoreOverallDtlForm").attr("action", "/score/scoreOverall/scoreOverallDtlPopup.do");
        $("#modalScoreOverallDtlForm").submit();
        $("#modalScoreOverallDtl").modal('show');
    }

    // 엑셀 다운로드
    function excelDown() {
        if (!SEARCH_OBJ) return;
        var sortUserIdList = [];

        $.each($("[data-sort-user-no]"), function () {
            var userId = $(this).data("sortUserId");

            sortUserIdList.push(userId);
        });

        var excelGrid = {
            colModel: [
                {label: '<spring:message code="common.number.no" />', name: 'lineNo', align: 'right', width: '1000'} // No.
                , {label: '<spring:message code="common.dept_name" />', name: 'deptNm', align: 'left', width: '8000'} // 학과
                , {
                    label: '<spring:message code="common.label.student.number" />',
                    name: 'userId',
                    align: 'center',
                    width: '3000'
                } // 학번
                , {
                    label: '<spring:message code="common.label.userdept.grade" />',
                    name: 'hy',
                    align: 'center',
                    width: '1000'
                } // 학년
                , {
                    label: '<spring:message code="exam.label.academic.status" />',
                    name: 'schregGbn',
                    align: 'center',
                    width: '3000'
                } // 학적상태
                , {
                    label: '<spring:message code="filemgr.label.userauth.usernm" />',
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
        var excelForm = $('<form name="excelForm" method="post"></form>');
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
            crsCreCd: $("#creCrsTbody tr.on").attr("data-crsCreCd")
        };

        ajaxCall(url, param, function (data) {
            if (data.result > 0) {
                $("#modalScoreCalForm > input[name=crsCreCd]").val($("#creCrsTbody tr.on").attr("data-crsCreCd"));
                var returnVO = data.returnVO;
                var scoreEvalType = returnVO.scoreEvalType;

                if (scoreEvalType == "RELATIVE") {
                    //상대평가 팝업
                    $("#modalTitleId").html("<spring:message code='score.label.evaluation.stand' />");	// 상대평가 환산기준
                    $("#modalScoreCalForm").attr("target", "modalScoreCalIfm");
                    $("#modalScoreCalForm").attr("action", "/score/scoreOverall/scoreOverallScoreCalRelativePopup.do");
                    $("#modalScoreCalForm").submit();
                    $("#modalScoreCal").modal('show');
                } else if (scoreEvalType == "ABSOLUTE") {
                    //절대평가 팝업
                    $("#modalTitleId").html("<spring:message code='score.label.absolute.stand' />");	// 절대평가 환산 기준
                    $("#modalScoreCalForm").attr("target", "modalScoreCalIfm");
                    $("#modalScoreCalForm").attr("action", "/score/scoreOverall/scoreOverallScoreCalAbsolutePopup.do");
                    $("#modalScoreCalForm").submit();
                    $("#modalScoreCal").modal('show');
                } else if (scoreEvalType == "PF") {
                    //절대평가 팝업
                    $("#modalTitleId").html("P/F <spring:message code='score.label.conversion.stand' />");	// P/F 환산기준
                    $("#modalScoreCalForm").attr("target", "modalScoreCalIfm");
                    $("#modalScoreCalForm").attr("action", "/score/scoreOverall/scoreOverallScoreCalPfPopup.do");
                    $("#modalScoreCalForm").submit();
                    $("#modalScoreCal").modal('show');
                } else {
                    alert("<spring:message code='score.errors.not.found.score.eval.type' />"); // 과목의 평가구분 정보를 찾을 수 없습니다.
                }
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            // 에러가 발생했습니다!
            alert('<spring:message code="fail.common.msg" />');
        }, true);
    }

    //일괄평가 팝업
    function onAllEvlModal() {
        getNoEvalItem($("#creCrsTbody tr.on").attr("data-crsCreCd")).done(function (noEvalItem) {
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

    // 성적환산 팝업 콜백
    function scoreConvertCallBack() {
        onAbsentSearch();
        onSearch();
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
            alert('<spring:message code="fail.common.msg" />');
        }, true);
    }

    // 저장
    function onSave() {
        if ($("input[name*=dataChk]:checked").length == 0) {
            // 변동된 내역이 없습니다.
            alert('<spring:message code="score.alert.no.changed" />');
            return;
        }

        //if("${scoreOverAllYn}" == "0") {
        //	/* 성적처리기간이 아닙니다. */
        //	alert('<spring:message code="score.label.ect.eval.oper.msg9" />');
        //	return;
        //}

        var chkFormData = $("#tableForm").serialize();

        // 저장하시겠습니까?
        if (confirm("<spring:message code='common.save.msg'/>")) {
            ajaxCall("/score/scoreOverall/saveOverallList.do", chkFormData, function (data) {
                if (data.result > 0) {
                    /* 저장되었습니다.  */
                    alert('<spring:message code="info.regok.msg" />');

                    onAbsentSearch();
                    onSearch();
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                /* 에러가 발생했습니다! */
                alert('<spring:message code="fail.common.msg" />');
            }, true);
        }
    }

    //메모
    function setMemo(stdNo) {
        $("#modalStdMemoForm [name=crsCreCd]").val($("#creCrsTbody tr.on").attr("data-crsCreCd"));
        $("#modalStdMemoForm [name=stdNo]").val(stdNo);
        $("#modalStdMemoForm").attr("target", "modalStdMemoIfm");
        $("#modalStdMemoForm").attr("action", "/score/scoreOverall/scoreOverallStdMemoPopup.do");
        $("#modalStdMemoForm").submit();
        $("#modalStdMemo").modal('show');
    }

    // 미평가 항목조회
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
</script>
<body>
<div id="wrap" class="pusher">
    <!-- header -->
    <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
    <!-- //header -->

    <!-- lnb -->
    <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
    <!-- //lnb -->

    <div id="container">

        <!-- 본문 content 부분 -->
        <div class="content">
            <div class="ui form">
                <div id="info-item-box">
                    <h2 class="page-title"><spring:message code="score.label.grade.manage" /><!-- 성적평가관리 --> > 성적입력</h2>
                </div>
                <div class="ui segment">
                    <div class="option-content" style="<%=(!SessionInfo.isKnou(request) ? "display:none" : "")%>">
                        <div class="ui buttons">
                            <button class="ui blue button active crsTypeBtn" data-crs-type-cd="UNI"
                                    onclick="selectContentCrsType(this)">
                                <spring:message code="crs.label.crs.uni" /><!-- 학기제 --></button>
                            <%-- <button class="ui basic blue button crsTypeBtn" data-crs-type-cd="CO" onclick="selectContentCrsType(this)"><spring:message code="crs.label.crs.co" /><!-- 기수제 --></button>
                            <button class="ui basic blue button crsTypeBtn" data-crs-type-cd="LEGAL" onclick="selectContentCrsType(this)"><spring:message code="crs.label.crs.court" /><!-- 법정교육 --></button>
                            <button class="ui basic blue button crsTypeBtn" data-crs-type-cd="OPEN" onclick="selectContentCrsType(this)"><spring:message code="crs.label.crs.open" /><!-- 공개강좌 --></button> --%>
                        </div>
                    </div>
                    <div class="option-content">
                        <select class="ui dropdown mr5" id="creYear">
                            <c:forEach var="year" items="${yearList }">
                                <option value="${year}" <c:if test="${year eq '2024'}">selected</c:if>>
                                    ${year}<spring:message code="date.year" /><!-- 년 --></option>
                            </c:forEach>
                        </select>
                        <select class="ui dropdown mr5" id="creTerm">
                            <c:forEach var="term" items="${termList }">
                                <%-- <option value="${term.codeCd }" <c:if test="${term.codeCd eq curTerm }">selected</c:if>>${term.codeNm }</option> --%>
                                <option value="${term.codeCd }"
                                        <c:if test="${term.codeCd eq '20' }">selected</c:if>>${term.codeNm }</option>
                            </c:forEach>
                        </select>
                        <c:if test="${orgId eq 'ORG0000001' }">
                            <select class="ui dropdown mr5" id="uniCd">
                                <option value="ALL">
                                    <spring:message code="common.label.uni.type" /><!-- 대학구분 --></option>
                                <option value="C">
                                    <spring:message code="common.label.uni.college" /><!-- 대학교 --></option>
                                <option value="G">
                                    <spring:message code="common.label.uni.graduate" /><!-- 대학원 --></option>
                            </select>
                        </c:if>
                        <select class="ui dropdown mr5" id="mngtDeptCd">
                            <option value="ALL"><spring:message code="common.dept_name" /><!-- 학과 --></option>
                            <c:forEach var="dept" items="${usrDeptCdList }">
                                <option value="${dept.deptCd }">${dept.deptNm }</option>
                            </c:forEach>
                        </select>
                        <input type="text" class="ui input w400 mr5"
                               placeholder="<spring:message code="crs.label.crecrs.nm" />/<spring:message code="common.crs.cd" />/<spring:message code="common.label.prof.nm" />"
                               id="searchValue"/><!-- 과목명/학수번호/교수명 -->
                        <div class="mla">
                            <button type="button" class="ui green button" onclick="creCrsList()">
                                <spring:message code="common.button.search" /><!-- 검색 --></button>
                        </div>
                    </div>
                </div>
                <div class="option-content">
                    <h3 class="sec_head"><spring:message code="crs.label.open.crs" /><!-- 개설과목 --></h3>
                    <div class="mla">
                        <p>[ <spring:message code="message.all" /><!-- 총 --> <span class="fcBlue"
                                                                                   id="creCrsCnt">0</span>
                            <spring:message code="message.count" /><!-- 건 --> ]</p>
                    </div>
                </div>
                <table class="table type2" id="creCrsTable" data-sorting="false" data-paging="false"
                       data-empty="<spring:message code='common.content.not_found' />"><!-- 등록된 내용이 없습니다. -->
                    <thead>
                    <tr>
                        <th>No</th>
                        <th><spring:message code="common.type" /><!-- 구분 --></th>
                        <th><spring:message code="common.phy.dept_name" /><!-- 관장학과 --></th>
                        <th><spring:message code="common.crs.cd" /><!-- 학수번호 --></th>
                        <th><spring:message code="common.label.decls.no" /><!-- 분반 --></th>
                        <th><spring:message code="crs.label.crecrs.nm" /><!-- 과목명 --></th>
                        <th><spring:message code="common.label.crsauth.comtype" /><!-- 이수구분 --></th>
                        <th><spring:message code="common.label.credit" /><!-- 학점 --></th>
                        <th><spring:message code="common.charge.professor" /><!-- 담당교수 --></th>
                        <th><spring:message code="crs.label.no.enseignement" /><!-- 교직원번호 --></th>
                        <th><spring:message code="crs.attend.person.nm" /><!-- 수강인원 --></th>
                        <th>성적평가구분</th>
                        <th>성적부여방법</th>
                    </tr>
                    </thead>
                    <tbody id="creCrsTbody">
                    </tbody>
                </table>
                <div class="mt30 stdDiv" style="display:none;">
                    <h3><spring:message code="common.student.list" /><!-- 수강생 목록 --></h3>
                    <div class="option-content">
                        <div class="mla">
                            <div class="ui breadcrumb small">
                                <b>진행 단계 : </b>
                                <b id="scoreStatusText1" name="scoreStatusText" class="">성적환산 전</b>
                                <i class="right chevron icon divider"></i>
                                <b id="scoreStatusText2" name="scoreStatusText" class="">성적환산 시작</b>
                                <i class="right chevron icon divider"></i>
                                <b id="scoreStatusText3" name="scoreStatusText" class="">성적환산 완료</b>
                            </div>
                        </div>
                    </div>
                    <div class="option-content">
                        <a href="javascript:;" onclick="sendMsg();return false;" class="ui basic small button mra"><i
                                class="paper plane outline icon"></i>
                            <spring:message code="common.button.message" /><!-- 메시지 --></a>
                        <div class="mla">
                            <button type="button" class="ui blue small button btn2" onclick="onSave()">저장</button>
                            <button type="button" id="btnScoreCal" onclick="onAllEvlModal()"
                                    class="ui blue small button btn2">성적 환산
                            </button>
                            <button type="button" class="ui blue small button btn1">일괄평가</button>
                            <button type="button" class="ui blue small button" onclick="excelDown()">
                                <spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></button>
                        </div>
                    </div>
                    <div class="option-content gap4 mt10 mb10">
                        <div class="ui action input search-box">
                            <input id="stdSearchValue" type="text" placeholder="학과/학번/이름입력">
                            <button class="ui icon button" type="button" id="searchBtn">
                                <i class="search icon"></i>
                            </button>
                        </div>

                        <div class="ui basic small buttons flex flex-wrap">
                            <!-- <button type="button" class="ui button" id="btnM">중간 결시원 [ 제출 : <span id="absentInfoM1">0</span>명, 승인 : <span id="absentInfoM2">0</span>명 ]</button> -->
                            <!-- <button type="button" class="ui button" id="btnL">기말 결시원 [ 제출 : <span id="absentInfoL1">0</span>명, 승인 : <span id="absentInfoL2">0</span>명 ]</button> -->
                            <button type="button" class="ui button basic p5 m0 inline-flex-item pl10 pr10" id="btnZero">
                                <span class="bcRedAlpha30 w30 d-inline-block mr5"
                                      style="height: 25px;"></span><spring:message code="exam.label.eval.n"/> [ <span
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
                                    code="common.label.alternate"/> [<span id="reExamCnt">0</span><spring:message
                                    code="message.count"/>]
                            </button><!-- 대체 -->
                        </div>

                        <div class="mla flex">
                            <button type="button" class="ui button basic p5 m0 inline-flex-item pl10 pr10 red mr5"
                                    id="btnF"><span class="d-inline-block" style="height: 26px;"></span>F
                                <spring:message code="score.button.concern"/> [<span id="fCnt">0</span><spring:message
                                        code="forum.label.person"/>]
                            </button><!-- F 대상자 -->
                            <small class="inline-flex-item">[
                                <spring:message code="score.label.target.people" /><!-- 대상인원 --> : <span
                                        id="listTotCnt"></span> <spring:message code="message.person" /><!-- 명 -->
                                ]</small>
                            <small class="inline-flex-item ml5">[
                                <spring:message code="score.label.total.person" /><!-- 전체인원 --> : <span
                                        id="totCnt"></span> <spring:message code="message.person" /><!-- 명 -->]</small>
                        </div>
                    </div>
                    <form:form id="tableForm" commandName="list">
                        <input type="hidden" name="scoreStatus" id="scoreStatus"/>
                        <div id="stdTableDiv"></div>
                    </form:form>
                </div>

                <div class="row stdDiv" style="display:none;">
                    <div class="col">
                        <div class="option-content gap4 header2">
                            <div class="sec_head mra"><spring:message code="common.label.score"/> <spring:message
                                    code="common.label.grade.chart"/> : <span id="scoreTypeStr"><spring:message
                                    code="score.label.university.score"/></span></div><!-- 성적 등급 분포도 : 종합성적 -->
                            <select class="ui dropdown" id="graphSelect" onchange="chartSet()">
                                <option value="all">
                                    <spring:message code="score.label.university.score" /><!-- 종합성적 --></option>
                                <option value="2"><spring:message code="exam.label.mid.exam" /><!-- 중간고사 --></option>
                                <option value="3"><spring:message code="exam.label.end.exam" /><!-- 기말고사 --></option>
                                <option value="1"><spring:message code="common.label.attendance" /><!-- 출석 -->/
                                    <spring:message code="common.label.lecture" /><!-- 강의 --></option>
                                <option value="5"><spring:message code="common.label.asmnt" /><!-- 과제 --></option>
                                <option value="6"><spring:message code="common.label.forum" /><!-- 토론 --></option>
                                <option value="7"><spring:message code="common.label.question" /><!-- 퀴즈 --></option>
                            </select>
                        </div>
                        <div id="graphDiv">
                            <p class="option-content gap4 mb5">
                                <spring:message code="common.label.score" /><!-- 성적 -->
                                <spring:message code="common.label.grade.chart" /><!-- 등급 분포도 -->
                                <small class="mla">[ <spring:message code="exam.label.stare.user.cnt" /><!-- 대상인원 --> :
                                    <span id="graphTotCnt"></span><spring:message code="message.person" /><!-- 명 -->
                                    ]</small>
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
                                            <td data-label="<spring:message code="message.marks" />">100</td><!-- 배점 -->
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

        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>

        <!-- 종합성적처리 상세팝업 -->
        <form class="ui form" id="modalScoreOverallDtlForm" name="modalScoreOverallDtlForm" method="POST" action="">
            <input type="hidden" name="crsCreCd"/>
            <input type="hidden" name="userId"/>
            <input type="hidden" name="stdNo"/>
            <div class="modal fade" id="modalScoreOverallDtl" tabindex="-1" role="dialog"
                 aria-labelledby="<spring:message code="score.label.university.score.detail.info" />"
                 aria-hidden="false">
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

        <!-- 일괄평가 확인팝업 -->
        <form class="ui form" id="modalEvlWarningForm" name="modalEvlWarningForm" method="POST" action="">
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
            <div class="modal fade" id="modalScoreCal" tabindex="-1" role="dialog" aria-labelledby="모달영역"
                 aria-hidden="false">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
                                <span aria-hidden="true">&times;</span>
                            </button>
                            <h4 id="modalTitleId" class="modal-title"></h4>
                        </div>
                        <div class="modal-body">
                            <iframe src="" id="modalScoreCalIfm" name="modalScoreCalIfm" width="100%"
                                    scrolling="no"></iframe>
                        </div>
                    </div>
                </div>
            </div>
        </form>
        <!-- 종합성적처리 학생메모 팝업 -->
        <form class="ui form" id="modalStdMemoForm" name="modalStdMemoForm" method="POST" action="">
            <input type="hidden" name="stdNo"/>
            <input type="hidden" name="crsCreCd"/>
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
                            <iframe src="" id="modalStdMemoIfm" name="modalStdMemoIfm" width="100%"
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

    </div>
</div>

</body>

</html>

