<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
    var searchTypeExcel = "";
    var gridSortTarget = "";
    var gridSortDirection = "";
    var USER_DEPT_LIST = [];
    var CRS_CRE_LIST = [];

    $(function () {
        // 부서정보
        <c:forEach var="item" items="${deptList}">
        USER_DEPT_LIST.push({
            deptCd: '<c:out value="${item.deptCd}" />'
            , deptNm: '<c:out value="${item.deptNm}" />'
            , deptCdOdr: '<c:out value="${item.deptCdOdr}" />'
        });
        </c:forEach>

        // 부서명 정렬
        USER_DEPT_LIST.sort(function (a, b) {
            if (a.deptCdOdr < b.deptCdOdr) return -1;
            if (a.deptCdOdr > b.deptCdOdr) return 1;
            if (a.deptCdOdr == b.deptCdOdr) {
                if (a.deptNm < b.deptNm) return -1;
                if (a.deptNm > b.deptNm) return 1;
            }
            return 0;
        });

        $("#searchValue").on("keyup", function (e) {
            if (e.keyCode == 13) {
                onSearch(1);
            }
        });

        changeTerm();
    });

    //학기 변경
    function changeTerm() {
        // 학기 과목정보 조회
        var url = "/crs/creCrsHome/listCrsCreDropdown.do";
        var data = {
            creYear: $("#curYear").val()
            , creTerm: $("#curTerm").val()
            , crsTypeCd: "UNI"
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnList = data.returnList || [];

                this["CRS_CRE_LIST"] = returnList.filter(function (v) {
                    if ((v.crsCd || "").indexOf("JLPT") > -1) {
                        return false;
                    }
                    return true;
                }).sort(function (a, b) {
                    if (a.crsCreNm < b.crsCreNm) return -1;
                    if (a.crsCreNm > b.crsCreNm) return 1;
                    if (a.crsCreNm == b.crsCreNm) {
                        if (a.declsNo < b.declsNo) return -1;
                        if (a.declsNo > b.declsNo) return 1;
                    }
                    return 0;
                });

                // 대학 구분 변경
                changeUnivGbn("ALL");

                $("#univGbn").on("change", function () {
                    changeUnivGbn(this.value);
                });
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
        }, true);
    }

    // 대학구분 변경
    function changeUnivGbn(univGbn) {
        var deptCdObj = {};

        this["CRS_CRE_LIST"].forEach(function (v, i) {
            if ((univGbn == "ALL" || v.univGbn == univGbn) && v.deptCd) {
                deptCdObj[v.deptCd] = true;
            }
        });

        var html = '<option value="ALL"><spring:message code="user.title.userdept.select" /></option>'; // 학과 선택
        USER_DEPT_LIST.forEach(function (v, i) {
            if (deptCdObj[v.deptCd]) {
                html += '<option value="' + v.deptCd + '">' + v.deptNm + '</option>';
            }
        });

        // 부서 초기화
        $("#deptCd").html(html);
        $("#deptCd").dropdown("clear");
        $("#deptCd").on("change", function () {
            changeDeptCd(this.value);
        });

        // 학과 초기화
        $("#crsCreCd").empty();
        $("#crsCreCd").dropdown("clear");

        // 부서변경
        changeDeptCd("ALL");
    }

    // 학과 변경
    function changeDeptCd(deptCd) {
        var univGbn = ($("#univGbn").val() || "").replace("ALL", "");
        var deptCd = (deptCd || "").replace("ALL", "");

        var html = '<option value="ALL"><spring:message code="common.subject.select" /></option>'; // 과목 선택

        CRS_CRE_LIST.forEach(function (v, i) {
            if ((!univGbn || v.univGbn == univGbn) && (!deptCd || v.deptCd == deptCd)) {
                var declsNo = v.declsNo;
                declsNo = '(' + declsNo + ')';

                html += '<option value="' + v.crsCreCd + '">' + v.crsCreNm + declsNo + '</option>';
            }
        });

        $("#crsCreCd").html(html);
        $("#crsCreCd").dropdown("clear");
    }

    //과정유형 선택
    function selectContentCrsType(obj) {
        if ($(obj).hasClass("basic")) {
            $(obj).removeClass("basic").addClass("active");
        } else {
            $(obj).removeClass("active").addClass("basic");
        }
    }

    function onSearch() {
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

        var param = {
            crsTypeCd: crsTypeCd
            , curYear: $("#curYear").val()
            , curTerm: $("#curTerm").val()
            , univGbn: ($("#univGbn").val() || "").replace("ALL", "")
            , deptCd: ($("#deptCd").val() || "").replace("ALL", "")
            , crsCreCd: ($("#crsCreCd").val() || "").replace("ALL", "")
            , mrksGrdGvGbn: $("#mrksGrdGvGbn").val()
            , searchValue: $("#searchValue").val()
        }

        ajaxCall("/grade/gradeMgr/selectEvlList.do", param, function (data) {
            var html = "";
            if (data.returnList != null) {
                $.each(data.returnList, function (i, o) {
                    html += "<tr onClick='onClickEventRow(this);' data-cd='" + o.crsCreCd + "'>";
                    html += "<td>" + o.lineNo + "</td>";
                    html += "<td>" + o.uniGbnNm + "</td>";
                    html += "<td>" + o.deptNm + "</td>";
                    html += "<td>";
                    html += o.crsCreCd;
                    html += "<input type='hidden' name='list[" + i + "].crsCreCd' value='" + o.crsCreCd + "' />";
                    html += "</td>";
                    html += "<td>" + o.declsNo + "</td>";
                    html += "<td>" + o.crsCreNm + "</td>";
                    html += "<td>" + o.compDvNm + "</td>";
                    html += "<td>" + o.credit + "</td>";
                    html += "<td>" + (o.tchNm == null ? "-" : o.tchNm) + "</td>";
                    html += "<td>" + (o.tchNo == null ? "-" : o.tchNo) + "</td>";
                    html += "<td>";
                    if (o.scoreEvalGbn == "RELATIVE") {
                        html += "<spring:message code='crs.relative.evaluation' />";		// 상대평가
                    } else if (o.scoreEvalGbn == "ABSOLUTE") {
                        html += "<spring:message code='crs.absolute.evaluation' />";	// 절대평가
                    } else if (o.scoreEvalGbn == "PF") {
                        html += "P/F";
                    }
                    html += "</td>";
                    html += "<td>" + (o.enrlNop == null ? "-" : o.enrlNop) + "</td>";
                    html += "</tr>";
                });
            }

            $("#lTbody1").empty().html(html);
            $("#lTable1").footable();

        }, function (xhr, status, error) {
            /* 에러가 발생했습니다! */
            alert('<spring:message code="fail.common.msg" />');
        }, true);

    }

    function onClickEventRow(obj) {
        $("#lTbody1 tr").removeClass("on");
        $(obj).addClass('on');
        //$("#crsCreCd").val($(obj).data('cd'));

        onSearchDtl();
    }

    function onSearchDtl() {
        var url = "/score/scoreOverall/selectOverallListAdmin.do";
        var param = {
            searchType: "searchBtn"
            , crsCreCd: $("#lTbody1 tr.on").data('cd')
        };

        ajaxCall(url, param, function (data) {
            if (data.result > 0) {
                ratioArr = new Array();

                var html = "";
                var rowColorCss = "";
                var totSum = 0;

                $("#listTotCnt").text(data.returnVO.totalCnt);
                var middleTestHead = 0;
                var lastTestHead = 0;
                var testHead = 0;
                var lessonHead = 0;
                var assignmentHead = 0;
                var forumHead = 0;
                var quizHead = 0;
                var reshHead = 0;

                if (data.retrunSubVo != null) {
                    middleTestHead = Number(data.returnSubVO.middleTestScoreRatio);
                    lastTestHead = Number(data.returnSubVO.lastTestScoreRatio);
                    testHead = Number(data.returnSubVO.testScoreRatio);

                    lessonHead = Number(data.returnSubVO.lessonScoreRatio);
                    assignmentHead = Number(data.returnSubVO.assignmentScoreRatio);
                    forumHead = Number(data.returnSubVO.forumScoreRatio);
                    quizHead = Number(data.returnSubVO.quizScoreRatio);
                    reshHead = Number(data.returnSubVO.reshScoreRatio);

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
                }

                html += "<table id='lTable2' class='table ' data-sorting='true' data-paging='false' data-empty='<spring:message code='common.nodata.msg' />'>";
                html += "<thead>";
                html += "	<tr>";
                html += "        <th class='tc w20' data-breakpoints='' data-sortable='false'><div class='ui checkbox'><input type='checkbox' tabindex='0' id='chkAll'><label></label></div></th>";
                html += "        <th class='tc' data-breakpoints='' data-sortable='false'><spring:message code='main.common.number.no' /></th>"; // NO
                html += "        <th class='tc wf7' data-breakpoints='xs sm md' style='min-width:150px'><spring:message code='exam.label.dept' /></th>"; // 학과
                html += "        <th class='tc' data-breakpoints=''><spring:message code='exam.label.user.no' /></th>"; // 학번
                html += "        <th class='tc' data-breakpoints=''><spring:message code='exam.label.user.grade' /></th>"; // 학년
                html += "        <th class='tc' data-breakpoints=''><spring:message code='exam.label.user.nm' /></th>"; // 이름

                $.each(ratioArr, function (i, o) {
                    if (o == "middleTestScore") {
                        html += "        <th class='' data-breakpoints='xs sm md lg'><spring:message code='forum.label.type.exam.M' /><br class='desktop-elem'><small>(" + middleTestHead + "%)</small></th>"; // 중간고사
                    } else if (o == "lastTestScore") {
                        html += "        <th class='' data-breakpoints='xs sm md lg'><spring:message code='forum.label.type.exam.L' /><br class='desktop-elem'><small>(" + lastTestHead + "%)</small></th>"; // 기말고사
                    } else if (o == "testScore") {
                        html += "        <th class='' data-breakpoints='xs sm md lg'><spring:message code='std.label.always' /><br/><spring:message code='asmnt.button.eval' /><br class='desktop-elem'><small>(" + testHead + "%)</small></th>"; // 수시 평가
                    } else if (o == "lessonScore") {
                        html += "        <th class='' data-breakpoints='xs sm md lg'><spring:message code='common.label.attendance' />/<spring:message code='crs.label.lecture' /><br class='desktop-elem'><small>(" + lessonHead + "%)</small></th>"; // 출석/강의
                    } else if (o == "assignmentScore") {
                        html += "        <th class='' data-breakpoints='xs sm md lg'><spring:message code='crs.label.asmnt' /><br class='desktop-elem'><small>(" + assignmentHead + "%)</small></th>"; // 과제
                    } else if (o == "forumScore") {
                        html += "        <th class='' data-breakpoints='xs sm md lg'><spring:message code='crs.button.forum' /><br class='desktop-elem'><small>(" + forumHead + "%)</small></th>"; // 토론
                    } else if (o == "quizScore") {
                        html += "        <th class='' data-breakpoints='xs sm md lg'><spring:message code='crs.button.quiz' /><br class='desktop-elem'><small>(" + quizHead + "%)</small></th>"; // 퀴즈
                    } else if (o == "reshScore") {
                        html += "        <th class='' data-breakpoints='xs sm md lg'><spring:message code='crs.button.resch' /><br class='desktop-elem'><small>(" + reshHead + "%)</small></th>"; // 설문
                    }
                });

                html += "        <th class='tc' data-breakpoints='xs'><spring:message code='common.label.production' /><br class='desktop-elem'><spring:message code='common.label.total.point' /></th>"; // 산출 총점
                html += "        <th class='tc' data-breakpoints='xs'><spring:message code='common.label.exchange' /><br class='desktop-elem'><spring:message code='common.label.total.point' /></th>"; // 환산 총점
                html += "        <th name='etcDataTd' class='tc' data-breakpoints='xs sm md lg' data-type='number'><spring:message code='common.label.total.include.point' /></th>"; // 가산점
                html += "        <th class='tc' data-breakpoints='xs' data-type='number'><spring:message code='common.label.final' /><br class='desktop-elem'><spring:message code='common.score' /></th>"; // 최종 점수
                html += "        <th class='tc' data-breakpoints='xs sm md lg'><spring:message code='exam.label.grade' /><br/><spring:message code='exam.label.level' /></th>"; // 성적등급
                html += "        <th class='tc' data-breakpoints='xs sm md lg'><spring:message code='exam.label.manage' /></th>"; // 관리
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

                    var cssCnt = 0;

                    $.each(ratioArr, function (j, z) {
                        if (eval(z) == "-") {
                            cssCnt++;
                        }
                    });

                    if (cssCnt > 0) {
                        rowColorCss = "fcOrange";
                    } else {
                        rowColorCss = "";
                    }

                    html += "<tr>";
                    html += "    <td class='tc'><div class='ui checkbox'><input type='checkbox' name='list[" + i + "].dataChk' tabindex='0' user_id='" + o.userId + "' user_nm='" + o.userNm + "' mobile='" + o.userMobileNo + "' email='" + o.userEmail + "'><label></label></div></td>";
                    html += "    <td name='lineNo' class='tc'>" + o.lineNo + "</td>";
                    html += "    <td data-sort-value='" + o.deptNm + "'>";
                    html += "        <span class='" + rowColorCss + "'>" + o.deptNm + "</span>";
                    html += "    </td>";
                    html += "    <td class='word_break_none tc' data-sort-value='A" + o.userId.padEnd(12, "0") + "'>";
                    html += "        <span class='" + rowColorCss + "'>" + o.userId + "</span>";
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
                    html += "    <td class='word_break_none tc' data-sort-value='" + o.userNm + "'>";
                    html += "        <span class='" + rowColorCss + "'>" + o.userNm + "</span>";
                    html += "        <a href='' title='<spring:message code='exam.label.std.info' /><spring:message code='exam.label.qstn.item' />'><i class='ico icon-info '></i></a>"; // 학생정보보기
                    html += "    </td>";

                    $.each(ratioArr, function (j, z) {
                        if (z == "middleTestScore") {
                            html += "    <td class='word_break_none' data-sort-value='" + getSortScore(middleTestScore) + "'>";
                            html += "    	<span name='chgSpanText'>";
                            html += "    		" + middleTestScore + "";
                            html += "    	</span>";
                            html += "    	<i class='right chevron icon f075 opacity5'></i>";
                            if (middleTestScore > -1) {
                                html += "    	<span class='fcBlue'>" + middleTestScoreAvg + "</span>";
                            } else {
                                html += "<span class='fcBlue'>-</span>";
                                //html += "    	<a href='javascript:;' onclick='goCrsCreCtgr(\"minTest\")'><span class='fcBlue'>-</span></a>";
                            }
                            html += "       <input type='hidden' name='list[" + i + "].middleTestScoreAvg' value='" + middleTestScoreAvg + "' placeholder='0'>";
                            html += "    </td>";
                        } else if (z == "lastTestScore") {
                            html += "    <td class='word_break_none' data-sort-value='" + getSortScore(lastTestScore) + "'>";
                            html += "    	<span name='chgSpanText'>";
                            html += "    		" + lastTestScore + " ";
                            html += "    	</span>";
                            html += "    	<i class='right chevron icon f075 opacity5'></i>";
                            if (lastTestScore > -1) {
                                html += "    	<span class='fcBlue'>" + lastTestScoreAvg + "</span>";
                            } else {
                                html += "<span class='fcBlue'>-</span>";
                                //html += "    	<a href='javascript:;' onclick='goCrsCreCtgr(\"lastTest\")'><span class='fcBlue'>-</span></a>";
                            }
                            html += "       <input type='hidden' name='list[" + i + "].lastTestScoreAvg' value='" + lastTestScoreAvg + "' placeholder='0'>";
                            html += "    </td>";
                        } else if (z == "testScore") {
                            html += "    <td class='word_break_none' data-sort-value='" + getSortScore(testScore) + "'>";
                            html += "    	<span name='chgSpanText'>";
                            html += "    		" + testScore + " ";
                            html += "    	</span>";
                            html += "    	<i class='right chevron icon f075 opacity5'></i>";
                            if (testScore > -1) {
                                html += "    	<span class='fcBlue'>" + testScoreAvg + "</span>";
                            } else {
                                html += "<span class='fcBlue'>-</span>";
                                //html += "    	<a href='javascript:;' onclick='goCrsCreCtgr(\"test\")'><span class='fcBlue'>-</span></a>";
                            }
                            html += "       <input type='hidden' name='list[" + i + "].testScoreAvg' value='" + testScoreAvg + "' placeholder='0'>";
                            html += "    </td>";
                        } else if (z == "lessonScore") {
                            html += "    <td class='word_break_none' data-sort-value='" + getSortScore(lessonScore) + "'>";
                            html += "    	<span name='chgSpanText'>";
                            html += "    		" + lessonScore + "";
                            html += "    	</span>";
                            html += "    	<i class='right chevron icon f075 opacity5'></i>";

                            html += "    	<span class='fcBlue'>" + lessonScoreAvg + "</span>";
                            html += "       <input type='hidden' name='list[" + i + "].lessonScoreAvg' value='" + lessonScoreAvg + "' placeholder='0'>";
                            html += "    </td>";
                        } else if (z == "assignmentScore") {
                            html += "    <td class='word_break_none' data-sort-value='" + getSortScore(assignmentScore) + "'>";
                            html += "    	<span name='chgSpanText'>";
                            html += "    		" + assignmentScore + "";
                            html += "    	</span>";
                            html += "    	<i class='right chevron icon f075 opacity5'></i>";
                            if (assignmentScore > -1) {
                                html += "    	<span class='fcBlue'>" + assignmentScoreAvg + "</span>";
                            } else {
                                html += "<span class='fcBlue'>-</span>";
                                //html += "    	<a href='javascript:;' onclick='goCrsCreCtgr(\"asmt\")'><span class='fcBlue'>-</span></a>";
                            }
                            html += "       <input type='hidden' name='list[" + i + "].assignmentScoreAvg' value='" + assignmentScoreAvg + "' placeholder='0'>";
                            html += "    </td>";
                        } else if (z == "forumScore") {
                            html += "    <td class='word_break_none' data-sort-value='" + getSortScore(forumScore) + "'>";
                            html += "    	<span name='chgSpanText'>";
                            html += "    		" + forumScore + "";
                            html += "    	</span>";
                            html += "    	<i class='right chevron icon f075 opacity5'></i>";
                            if (forumScore > -1) {
                                html += "    	<span class='fcBlue'>" + forumScoreAvg + "</span>";
                            } else {
                                html += "<span class='fcBlue'>-</span>";
                                //html += "    	<a href='javascript:;' onclick='goCrsCreCtgr(\"forum\")'><span class='fcBlue'>-</span></a>";
                            }
                            html += "       <input type='hidden' name='list[" + i + "].forumScoreAvg' value='" + forumScoreAvg + "' placeholder='0'>";
                            html += "    </td>";
                        } else if (z == "quizScore") {
                            html += "    <td class='word_break_none' data-sort-value='" + getSortScore(quizScore) + "'>";
                            html += "    	<span name='chgSpanText'>";
                            html += "    		" + quizScore + "";
                            html += "    	</span>";
                            html += "    	<i class='right chevron icon f075 opacity5'></i>";
                            if (quizScore > -1) {
                                html += "    	<span class='fcBlue'>" + quizScoreAvg + "</span>";
                            } else {
                                html += "<span class='fcBlue'>-</span>";
                                //html += "    	<a href='javascript:;' onclick='goCrsCreCtgr(\"quiz\")'><span class='fcBlue'>-</span></a>";
                            }
                            html += "       <input type='hidden' name='list[" + i + "].quizScoreAvg' value='" + quizScoreAvg + "' placeholder='0' >";
                            html += "    </td>";
                        } else if (z == "reshScore") {
                            html += "    <td class='word_break_none' data-sort-value='" + getSortScore(reshScore) + "'>";
                            html += "    	<span name='chgSpanText'>";
                            html += "    		" + reshScore + "";
                            html += "    	</span>";
                            html += "    	<i class='right chevron icon f075 opacity5'></i>";
                            if (reshScore > -1) {
                                html += "    	<span class='fcBlue'>" + reshScoreAvg + "</span>";
                            } else {
                                html += "<span class='fcBlue'>-</span>";
                                //html += "    	<a href='javascript:;' onclick='goCrsCreCtgr(\"resh\")'><span class='fcBlue'>-</span></a>";
                            }
                            html += "       <input type='hidden' name='list[" + i + "].reshScoreAvg' value='" + reshScoreAvg + "' placeholder='0' >";
                            html += "    </td>";
                        }
                    });

                    html += "    <td class='tc' data-sort-value='" + getSortScore(calTotScr) + "'>";
                    html += "    	<span class='fcBlue'>" + calTotScr + "</span>";
                    html += "       <input type='hidden' name='list[" + i + "].finalScore' value='" + calTotScr + "' placeholder='0'>";
                    html += "    </td>";

                    html += "<td class='tc' data-sort-value='" + getSortScore(o.totScore) + "'>";
                    if (o.scoreStatus == "2") {
                        html += "-";
                    } else if (o.scoreStatus == "3") {
                        html += "	<span name='totScoreSpan'>" + o.prvScore + "</span>";
                    }
                    html += "    </td>";

                    html += "    <td name='etcDataTd' class='tc' data-sort-value='" + getSortScore(etcScore) + "'>";
                    html += "    	<span>";
                    html += "    		" + etcScore + "";
                    html += "    	</span>";
                    html += "    </td>";

                    html += "   <td class='tc' data-sort-value='" + getSortScore(o.totScore) + "'>";
                    html += o.totScore;
                    html += "   </td>";


                    html += "    <td class='tc' data-sort-value='" + gradeSort + "'>"
                    if (o.scoreStatus == "2") {
                        html += "-";
                    } else if (o.scoreStatus == "3") {
                        html += o.scoreGrade;
                    }
                    html += "    </td>";

                    $("#scoreStatus").val(o.scoreStatus);

                    html += "    <td class='tc'>";
                    html += "        <a href=\"javascript:onScoreOverallDtlPop('" + o.crsCreCd + "', '" + o.userId + "', '" + o.stdNo + "');\" class='ui basic small button'><spring:message code='button.detail' /></a>  ";	// 상세
                    html += "    </td>";
                    html += "</tr>";
                });
                html += "</tbody>";
                html += "</table>";

                $("#tableDiv").empty().html(html);

                $("#lTable2").footable({
                    on: {
                        "after.ft.sorting": function (e, ft, sorter) {
                            gridSortTarget = sorter.column.title;
                            gridSortDirection = sorter.column.direction;

                            $("#tableDiv table tbody tr").each(function (z, k) {
                                $(k).find("td[name=lineNo]").html((z + 1));
                            });
                        },
                        "before.ft.sorting": function (e, ft, sorter) {
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

                var selectHtml = "";

                $("#graphSelect").dropdown("clear");
                selectHtml += "<option value='all'><spring:message code='common.all' /></option>";	// 전체
                $.each(ratioArr, function (i, o) {

                    if (o == "middleTestScore") {
                        selectHtml += "<option value='2'><spring:message code="crs.label.mid_exam" /></option>";	// 중간고사
                    } else if (o == "lastTestScore") {
                        selectHtml += "<option value='3'><spring:message code='forum.label.type.exam.L' /></option>";	// 기말고사
                    } else if (o == "testScore") {
                        selectHtml += "<option value='4'><spring:message code='crs.label.nomal_exam' /></option>";	// 수시평가
                    } else if (o == "lessonScore") {
                        selectHtml += "<option value='1'><spring:message code='common.label.attendance' />/<spring:message code='crs.label.lecture' /></option>";	// 출석/강의
                    } else if (o == "assignmentScore") {
                        selectHtml += "<option value='5'><spring:message code='crs.label.asmnt' /></option>";	// 과제
                    } else if (o == "forumScore") {
                        selectHtml += "<option value='6'><spring:message code='crs.button.forum' /></option>";	// 토론
                    } else if (o == "quizScore") {
                        selectHtml += "<option value='7'><spring:message code='crs.button.quiz' /></option>";	// 퀴즈
                    } else if (o == "reshScore") {
                        selectHtml += "<option value='8'><spring:message code='crs.button.resch' /></option>";	// 설문
                    }
                });

                $("#graphSelect").html(selectHtml);
                $("#graphSelect").dropdown("set text", "<spring:message code='common.all' />");	// 전체

                // 그래프 조회
                $("#graphSelect").on("change", function () {
                    onOverallGraph(this.value);
                    onOverallGridCase(this.value);
                });

                onOverallGraph("all");
                onOverallGridCase("all");
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 에러가 발생했습니다! */
            alert('<spring:message code="fail.common.msg" />');
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

    function onScoreOverAllExcelDown() {
        var gridSortCol = "";

        if (gridSortTarget.indexOf("학과") > -1) {
            gridSortCol = "DEPT_NM";
        } else if (gridSortTarget.indexOf("학번") > -1) {
            gridSortCol = "USER_ID";
        } else if (gridSortTarget.indexOf("학년") > -1) {
            gridSortCol = "HY";
        } else if (gridSortTarget.indexOf("이름") > -1) {
            gridSortCol = "USER_NM";
        } else if (gridSortTarget.indexOf("중간고사") > -1) {
            gridSortCol = "MIDDLE_TEST_SCORE_AVG";
        } else if (gridSortTarget.indexOf("기말고사") > -1) {
            gridSortCol = "LAST_TEST_SCORE_AVG";
        } else if (gridSortTarget.indexOf("출석") > -1) {
            gridSortCol = "LESSON_SCORE_AVG";
        } else if (gridSortTarget.indexOf("수시") > -1) {
            gridSortCol = "TEST_SCORE_AVG";
        } else if (gridSortTarget.indexOf("과제") > -1) {
            gridSortCol = "ASSIGNMENT_SCORE_AVG";
        } else if (gridSortTarget.indexOf("토론") > -1) {
            gridSortCol = "FORUM_SCORE_AVG";
        } else if (gridSortTarget.indexOf("퀴즈") > -1) {
            gridSortCol = "QUIZ_SCORE_AVG";
        } else if (gridSortTarget.indexOf("설문") > -1) {
            gridSortCol = "RESH_SCORE_AVG";
        } else if (gridSortTarget.indexOf("산출") > -1) {
            gridSortCol = "CAL_TOT_SCR";
        } else if (gridSortTarget.indexOf("가산점") > -1) {
            gridSortCol = "ETC_SCORE";
        } else if (gridSortTarget.indexOf("환산") > -1 || gridSortTarget.indexOf("최종") > -1) {
            if ($("#scoreStatus").val() == "3") {
                gridSortCol = "TOT_SCORE";
            } else {
                gridSortCol = "USER_NM";
            }
        } else if (gridSortTarget.indexOf("등급") > -1) {
            gridSortCol = "TOT_SCORE";
        } else {
            gridSortCol = "USER_NM";
        }

        var excelArr = new Array();
        var excelGrid = {
            colModel: [
                {
                    label: "<spring:message code='main.common.number.no' />",
                    name: 'lineNo',
                    align: 'center',
                    width: '1000'
                },/* NO */
                {label: "<spring:message code='exam.label.dept' />", name: 'deptNm', align: 'center', width: '8000'},/* 학과 */
                {label: "<spring:message code='exam.label.user.no' />", name: 'userId', align: 'center', width: '3000'},/* 학번 */
                {label: "<spring:message code='exam.label.user.grade' />", name: 'hy', align: 'center', width: '1000'},/* 학년 */
                {label: "<spring:message code='exam.label.user.nm' />", name: 'userNm', align: 'center', width: '3000'}/* 이름 */
            ]
        };
        var excelObj = {};

        var label, name = "";
        var splice = 0;
        $.each(ratioArr, function (i, o) {
            excelObj = {};

            if (o == "middleTestScore") {
                label = "<spring:message code='forum.label.type.exam.M' />(" + middleTestHead + "%)";	// 중간고사
                name = "middleTestScoreAvg";
            } else if (o == "lastTestScore") {
                label = "<spring:message code='forum.label.type.exam.L' />(" + lastTestHead + "%)";	// 기말고사
                name = "lastTestScoreAvg";
            } else if (o == "testScore") {
                label = "<spring:message code='crs.label.nomal_exam' />(" + testHead + "%)";	// 수시평가
                name = "testScoreAvg";
            } else if (o == "lessonScore") {
                label = "<spring:message code='common.label.attendance' />/<spring:message code='crs.label.lecture' />(" + lessonHead + "%)";	// 출석/강의
                name = "lessonScoreAvg";
            } else if (o == "assignmentScore") {
                label = "<spring:message code='crs.label.asmnt' />(" + assignmentHead + "%)";	// 과제
                name = "assignmentScoreAvg";
            } else if (o == "forumScore") {
                label = "<spring:message code='crs.button.forum' />(" + forumHead + "%)";	// 토론
                name = "forumScoreAvg";
            } else if (o == "quizScore") {
                label = "<spring:message code='crs.button.quiz' />(" + quizHead + "%)";	// 퀴즈
                name = "quizScoreAvg";
            } else if (o == "reshScore") {
                label = "<spring:message code='crs.button.resch' />(" + reshHead + "%)";	// 설문
                name = "reshScoreAvg";
            }

            excelObj = {
                label: label
                , name: name
                , align: "right"
                , width: "2500"
            }

            excelGrid.colModel.push(excelObj);
        });

        excelObj = {
            label: "<spring:message code='common.label.production.total.point' />",
            name: 'finalScore',
            align: 'right',
            width: '2500'
        };	// 산출총점
        excelGrid.colModel.push(excelObj);
        excelObj = {
            label: "<spring:message code='common.label.exchange.total.point' />",
            name: 'prvScore',
            align: 'right',
            width: '2500'
        };	// 환산총점
        excelGrid.colModel.push(excelObj);
        excelObj = {
            label: "<spring:message code='common.label.total.include.point.other' />",
            name: 'etcScore',
            align: 'right',
            width: '2500'
        };	// 기타(가산점)
        excelGrid.colModel.push(excelObj);
        excelObj = {
            label: "<spring:message code='common.label.exchange.total.point' />",
            name: 'totScore',
            align: 'right',
            width: '2500'
        };	// 환산총점
        excelGrid.colModel.push(excelObj);
        excelObj = {
            label: "<spring:message code='common.label.credit.grade' />",
            name: 'scoreGrade',
            align: 'center',
            width: '2500'
        };	// 학점등급
        excelGrid.colModel.push(excelObj);

        $("form[name=excelForm]").remove();
        var excelForm = $('<form name="excelForm" method="post" ></form>');
        excelForm.attr("action", "/score/scoreOverall/selectScoreOverAllExcelDownAdmin.do");
        excelForm.append($('<input/>', {
            type: 'hidden',
            name: 'searchTypeExcel',
            value: gfn_isNull(searchTypeExcel) ? "" : searchTypeExcel
        }));
        excelForm.append($('<input/>', {type: 'hidden', name: 'gridSortCol', value: gridSortCol}));
        excelForm.append($('<input/>', {
            type: 'hidden',
            name: 'gridSortDirection',
            value: gfn_isNull(gridSortDirection) ? "ASC" : gridSortDirection
        }));
        excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', value: JSON.stringify(excelGrid)}));
        excelForm.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: $("#lTbody1 tr.on").data('cd')}));
        excelForm.appendTo('body');
        excelForm.submit();
    }

    //오른쪽 그리드 및 그래프 조회
    function onOverallGridCase(val) {
        if (val == "select") {
            $("#graphDiv").hide();
            return;
        }

        var graphData = {
            selectType: val
            , crsCreCd: $("#lTbody1 tr.on").data('cd')
        }

        ajaxCall("/score/scoreOverall/selectOverallGridCaseAdmin.do", graphData, function (data) {
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
                                        return value + "<spring:message code='forum.label.point' />"
                                    } // 점
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
            alert('<spring:message code="fail.common.msg" />');
        }, true);
    }

    //그래프 조회
    function onOverallGraph(val) {
        if (val == "select") {
            return;
        }

        var graphData = {
            selectType: val
            , crsCreCd: $("#lTbody1 tr.on").data('cd')
        }

        var url = "";
        if (val == "all") {
            url = "/score/scoreOverall/selectOverallGraphListByGrade.do";
        } else {
            url = "/score/scoreOverall/selectOverallGraphListAdmin.do";
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
                                text: "<spring:message code='exam.label.distribution.ratio' /> (%)", // 분포도비율
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
                                            var persent = Math.floor(dataset.data[i] / stareCnt * 100);
                                            persent = isFinite(persent) ? persent : 0;
                                            ctx.fillStyle = '#000';
                                            ctx.fillText(dataset.data[i] + "<spring:message code='exam.label.nm' />(" + persent + '%)', model.x + 30, model.y + 8);/* 명 */
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
            alert('<spring:message code="fail.common.msg" />');
        }, true);
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
                    <h2 class="page-title">
                        <spring:message code="common.label.mut.eval.score"/> > <spring:message
                            code="common.label.lecture.report.breakdown"/>
                    </h2><!-- 성적평가관리 > 강의별 성적내역 조회 -->
                </div>

                <div class="ui segment bcLgrey9">
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

                    <div class="option-content mb10">
                        <select class="ui dropdown mr5" id="curYear" onchange="changeTerm()">
                            <c:forEach var="item" items="${yearList}" varStatus="status">
                                <option value="${item}"
                                        <c:if test="${item eq termVO.haksaYear}">selected</c:if>>${item}</option>
                            </c:forEach>
                        </select>
                        <select class="ui dropdown mr5" id="curTerm" onchange="changeTerm()">
                            <c:forEach var="item" items="${termList }">
                                <option value="${item.codeCd }"
                                        <c:if test="${item.codeCd eq termVO.haksaTerm}">selected</c:if>>${item.codeNm }</option>
                                <%-- <option value="${item.codeCd }" <c:if test="${item.codeCd eq '20'}">selected</c:if>>${item.codeNm }</option> --%>
                            </c:forEach>
                        </select>
                        <c:if test="${orgId eq 'ORG0000001'}">
                            <select id="univGbn" class="ui dropdown mr5" onchange="changeUnivGbn()">
                                <option value=""><spring:message code="common.label.uni.type"/></option><!-- 대학구분 -->
                                <option value="ALL"><spring:message code="common.all"/></option><!-- 전체 -->
                                <c:forEach var="item" items="${univGbnList}">
                                    <option value="${item.codeCd}" ${item.codeCd}><c:out
                                            value="${item.codeNm}"/></option>
                                </c:forEach>
                            </select>
                        </c:if>
                        <select id="deptCd" class="ui dropdown w250" onchange="changeDeptCd()">
                            <option value=""><spring:message code="common.dept_name" /><!-- 학과 -->
                                <spring:message code="common.select" /><!-- 선택 --></option>
                        </select>
                        <select id="crsCreCd" class="ui dropdown mr5 w250" onchange="onSearch()">
                            <option value=""><spring:message code="common.subject" /><!-- 과목 -->
                                <spring:message code="common.select" /><!-- 선택 --></option>
                        </select>
                        <select class="ui dropdown mr5 w200" id="mrksGrdGvGbn" name="mrksGrdGvGbn">
                            <option value="all"><spring:message code="common.all"/></option><!-- 전체 -->
                            <option value="RELATIVE"><spring:message code="crs.relative.evaluation"/></option>
                            <!-- 상대평가 -->
                            <option value="ABSOLUTE"><spring:message code="crs.absolute.evaluation"/></option>
                            <!-- 절대평가 -->
                            <option value="PF">P/F</option>
                        </select>
                        <div class="ui input search-box mr5">
                            <input type="text"
                                   placeholder="<spring:message code="crs.label.crecrs.nm" />/<spring:message code="common.crs.cd" />/<spring:message code="common.label.prof.nm" />"
                                   name="searchValue" id="searchValue"><!-- 과목명/학수번호/교수명 -->
                        </div>
                        <button type="button" class="ui green button mla" onclick="onSearch();">
                            <spring:message code="common.button.search" /><!-- 검색 --></button>
                    </div>

                    <div class="footable_box type2 mt15 max-height-300">
                        <table id="lTable1" class="table footable type2" data-sorting="true" data-paging="false"
                               data-empty="<spring:message code="asmnt.common.empty" />">
                            <thead class="sticky top0">
                            <tr>
                                <th scope="col" class="num tc">
                                    <spring:message code="main.common.number.no" /><!-- NO --></th>
                                <th scope="col"><spring:message code="bbs.label.type" /><!-- 구분 --></th>
                                <th scope="col"><spring:message code="contents.label.crscre.dept" /><!-- 개설학과 --></th>
                                <th scope="col"><spring:message code="contents.label.crscd" /><!-- 학수번호 --></th>
                                <th scope="col"><spring:message code="contents.label.decls" /><!-- 분반 --></th>
                                <th scope="col"><spring:message code="contents.label.crscrenm" /><!-- 과목명 --></th>
                                <th scope="col"><spring:message code="crs.label.compdv" /><!-- 이수구분 --></th>
                                <th scope="col"><spring:message code="crs.label.credit" /><!-- 학점 --></th>
                                <th scope="col"><spring:message code="dashboard.prof" /><!-- 담당교수 --></th>
                                <th scope="col"><spring:message code="crs.label.no.enseignement" /><!-- 교직원번호 --></th>
                                <th scope="col">
                                    <spring:message code="forum.label.score.eval.type" /><!-- 성적평가구분 --></th>
                                <th scope="col"><spring:message code="crs.attend.person" /><!-- 수강인원(명) --></th>
                            </tr>
                            </thead>
                            <tbody id="lTbody1"></tbody>
                        </table>
                    </div>
                </div>

                <div class="ui segment">
                    <div class="option-content mb10">
                        <h3 class="graduSch"><spring:message code="std.label.learner_list" /><!-- 수강생목록 --> [
                            <spring:message code="std.label.total_cnt" /><!-- 총 -->&nbsp;<span class="fcBlue"
                                                                                               id="listTotCnt">0</span>&nbsp;
                            <spring:message code="user.title.count" /><!-- 건 -->&nbsp;]</h3>
                        <div class="mla">
                            <button class="ui green button" onClick="onScoreOverAllExcelDown();">
                                <spring:message code="asmnt.label.excel.download" /><!-- 엑셀다운로드 --></button>
                        </div>
                    </div>
                    <div id="tableDiv" class="footable_box type2 mt15 max-height-300">
                        <table class="table" data-sorting="true" data-paging="false"
                               data-empty="<spring:message code="common.nodata.msg" />">
                            <thead>
                            <tr>
                                <th data-sortable='false'>
                                    <div class='ui checkbox'><input type='checkbox' tabindex='0'
                                                                    id='chkAll'><label></label></div>
                                </th>
                                <th data-sortable='false'>
                                    <spring:message code="main.common.number.no" /><!-- NO --></th>
                                <th style='min-width:150px'><spring:message code="exam.label.dept" /><!-- 학과 --></th>
                                <th><spring:message code="exam.label.user.no" /><!-- 학번 --></th>
                                <th><spring:message code="exam.label.user.grade" /><!-- 학년 --></th>
                                <th><spring:message code="exam.label.user.nm" /><!-- 이름 --></th>
                                <th><spring:message code="forum.label.type.exam.M" /><!-- 중간고사 --><br
                                        class='desktop-elem'></th>
                                <th><spring:message code="forum.label.type.exam.L" /><!-- 기말고사 --><br
                                        class='desktop-elem'></th>
                                <th><spring:message code="std.label.always" /><!-- 수시 --><br/>
                                    <spring:message code="asmnt.button.eval" /><!-- 평가 --><br class='desktop-elem'></th>
                                <th><spring:message code="common.label.attendance" /><!-- 출석 -->/
                                    <spring:message code="crs.label.lecture" /><!-- 강의 --><br class='desktop-elem'></th>
                                <th><spring:message code="crs.label.asmnt" /><!-- 과제 --><br class='desktop-elem'></th>
                                <th><spring:message code="crs.button.forum" /><!-- 토론 --><br class='desktop-elem'></th>
                                <th><spring:message code="crs.button.quiz" /><!-- 퀴즈 --><br class='desktop-elem'></th>
                                <th><spring:message code="crs.button.resch" /><!-- 설문 --><br class='desktop-elem'></th>
                                <th><spring:message code="common.label.production" /><!-- 산출 --><br
                                        class='desktop-elem'>
                                    <spring:message code="common.label.total.point" /><!-- 총점 --></th>
                                <th><spring:message code="common.label.exchange" /><!-- 환산 --><br class='desktop-elem'>
                                    <spring:message code="common.label.total.point" /><!-- 총점 --></th>
                                <th name='etcDataTd' data-type='number'>
                                    <spring:message code="common.label.total.include.point" /><!-- 가산점 --></th>
                                <th data-type='number'><spring:message code="common.label.final" /><!-- 최종 --><br
                                        class='desktop-elem'><spring:message code="common.score"/>    <!-- 점수 --></th>
                                <th><spring:message code="exam.label.grade" /><!-- 성적 --><br/>
                                    <spring:message code="exam.label.level" /><!-- 등급 --></th>
                                <th><spring:message code="exam.label.manage" /><!-- 관리 --></th>
                            </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>

                <div class="ui segment">
                    <div class="option-content mb10">
                        <h3 class="graduSch"><spring:message code="common.label.score"/><spring:message
                                code="common.label.grade.chart"/> : <spring:message code="dashboard.all"/></h3>
                        <!-- 성적 등급 분포도 : 전체 -->
                        <div class="mla">
                            <select class="ui dropdown" id="graphSelect"></select>
                        </div>
                    </div>
                    <div id="graphDiv">
                        <p class="option-content gap4 mb5">
                            <spring:message code="common.label.score.all" /><spring:message code="common.label.grade.chart" /><!-- 전체 성적 등급 분포도 -->
                            <small>[ <spring:message code="exam.label.stare.user.cnt" /><!-- 대상인원 --> : <span
                                    id="graphTotCnt"></span> ]</small>
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
                                        <th scope="col" class=""><spring:message code="message.marks" /><!-- 배점 --></th>
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
                                        <td data-label="<spring:message code="exam.label.avg" />" id="gridCol1"></td>
                                        <!-- 평균 -->
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
