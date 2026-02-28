<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    <link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>
    <script type="text/javascript">
        $(document).ready(function () {
        });

        function tabAllChk(index) {
            if ($("#tab" + index + " .footable-header input").is(":checked")) {
                $("input[name=tabChk" + index + "]").prop("checked", true);
            } else {
                $("input[name=tabChk" + index + "]").prop("checked", false);
            }
        }

        // 강의/출석
        function selectTab1() {

            if ($("#tab1 select").eq(0).val() == '') {
                /* 강의/출석 주차를 선택해주세요. */
                alert('<spring:message code="crs.confirm.select.lecture.week" />');
                return false;
            }

            // 주차 시작 종료 여부
            var startDtYn = $("#tab1 select").eq(0).find("option:selected").data("startDtYn");
            var endDtYn = $("#tab1 select").eq(0).find("option:selected").data("endDtYn");

            var url = "/std/stdLect/listAttendByLessonSchedule.do";
            var data = {
                crsCreCd: '<c:out value="${crsCreCd}" />'
                , lessonScheduleId: $("#tab1 select").eq(0).val()
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    var returnList = data.returnList || [];
                    var html = '';
                    var no = 1;

                    returnList.forEach(function (v, i) {
                        var vCd = v.studyStatusCd == null || v.studyStatusCd == '' ? 'NOSTUDY' : v.studyStatusCd;
                        if (vCd == $("#tab1 select:eq(1) :selected").val() || $("#tab1 select:eq(1) :selected").val() == "ALL") no++;
                    });
                    returnList.forEach(function (v, i) {
                        var vCd = v.studyStatusCd == null || v.studyStatusCd == '' ? 'NOSTUDY' : v.studyStatusCd;
                        if (vCd == $("#tab1 select:eq(1) :selected").val() || $("#tab1 select:eq(1) :selected").val() == "ALL") {
                            no = no - 1;
                            html += '<tr>';
                            html += '	<td>';
                            html += '		<input type="checkbox" name="tabChk1" tabindex="0" user_id="' + v.userId + '" user_nm="' + v.userNm + '" mobile="' + v.mobileNo + '" email="' + v.email + '">';
                            html += '	</td>';
                            html += '	<td>' + v.lineNo + '</td>';
                            html += '	<td>' + v.deptNm + '</td>';
                            html += '	<td>' + v.userId + '</td>';
                            html += '	<td>' + v.hy + '</td>';
                            html += '	<td>' + v.userNm + '</td>';
                            html += '	<td>' + v.entrYy + '</td>';
                            html += '	<td>' + v.entrHy + '</td>';
                            html += '	<td>' + v.entrGbnNm + '</td>';
                            html += '	<td>';
                            if (vCd == "COMPLETE") {
                                html += '<spring:message code="lesson.label.study.status.complete" />'; 	// 출석
                            } else if (vCd == "LATE") {
                                html += '<spring:message code="lesson.label.study.status.late" />'; 				// 지각
                            } else if (vCd == "STUDY") {
                                html += '<spring:message code="lesson.label.study.status.study" />'; 			// 학습중
                            } else if (vCd == "NOSTUDY") {
                                if (startDtYn == "N" || (startDtYn == "Y" && endDtYn == "N")) {
                                    html += '<spring:message code="lesson.lecture.study.ready" />'; 				// 미학습
                                } else {
                                    html += '<spring:message code="lesson.label.study.status.nostudy" />'; 	// 결석
                                }
                            }
                            html += '	</td>';
                            html += '</tr>';
                        }
                    });

                    $("#tabList1").empty().html(html);
                    $("#tab1 table").footable({
                        "breakpoints": {
                            "xs": 375,
                            "sm": 560,
                            "md": 768,
                            "lg": 1024,
                            "w_lg": 1200
                        }
                    });
                    $("#tab1 table").find(".ui.checkbox").checkbox();
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
            });
        }

        // 과제
        function selectTab2() {

            if ($("#tab2 select").eq(0).val() == '') {
                /* 과제를 선택해주세요. */
                alert('<spring:message code="common.asmnt.message.select" />');
                return false;
            }

            var url = "/asmt/profAsmtSbmsnPtcpntSelect.do";
            var data = {
                "selectType": "LIST",
                "crsCreCd": '<c:out value="${crsCreCd}" />',
                "asmntCd": $("#tab2 select").eq(0).val()
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    var returnList = data.returnList || [];
                    var html = '';
                    var no = 1;

                    returnList.forEach(function (v, i) {
                        if (v.asmntSubmitStatusCd == $("#tab2 select").eq(1).val() || $("#tab2 select").eq(1).val() == "ALL") no++;
                    });
                    returnList.forEach(function (v, i) {
                        if (v.asmntSubmitStatusCd == $("#tab2 select").eq(1).val() || $("#tab2 select").eq(1).val() == "ALL") {
                            no = no - 1;
                            html += '<tr>';
                            html += '	<td>';
                            html += '		<input type="checkbox" name="tabChk2" tabindex="0" user_id="' + v.userId + '" user_nm="' + v.userNm + '" mobile="' + v.mobileNo + '" email="' + v.email + '">';
                            html += '	</td>';
                            html += '	<td>' + no + '</td>';
                            html += '	<td>' + v.deptNm + '</td>';
                            html += '	<td>' + v.userId + '</td>';
                            html += '	<td>' + v.hy + '</td>';
                            html += '	<td>' + v.userNm + '</td>';
                            html += '	<td>' + v.entrYy + '</td>';
                            html += '	<td>' + v.entrHy + '</td>';
                            html += '	<td>' + v.entrGbnNm + '</td>';
                            html += '	<td>' + v.asmntSubmitStatusNm + '</td>';
                            html += '</tr>';
                        }
                    });

                    $("#tabList2").empty().html(html);
                    $("#tab2 table").footable({
                        "breakpoints": {
                            "xs": 375,
                            "sm": 560,
                            "md": 768,
                            "lg": 1024,
                            "w_lg": 1200
                        }
                    });
                    $("#tab2 table").find(".ui.checkbox").checkbox();
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
            });
        }

        //토론
        function selectTab3() {

            if ($("#tab3 select").eq(0).val() == '') {
                /* 토론을 선택해주세요. */
                alert('<spring:message code="common.forum.message.select" />');
                return false;
            }

            var url = "/forum/forumLect/forumJoinUserList.do";
            var data = {
                "crsCreCd": '<c:out value="${crsCreCd}" />',
                "forumCd": $("#tab3 select").eq(0).val()
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    var returnList = data.returnList || [];
                    var html = '';
                    var no = 1;

                    returnList.forEach(function (v, i) {
                        if (v.joinStatus == $("#tab3 select").eq(1).val() || $("#tab3 select").eq(1).val() == "ALL") no++;
                    });
                    returnList.forEach(function (v, i) {
                        if (v.joinStatus == $("#tab3 select").eq(1).val() || $("#tab3 select").eq(1).val() == "ALL") {
                            no = no - 1;
                            html += '<tr>';
                            html += '	<td>';
                            html += '		<input type="checkbox" name="tabChk3" tabindex="0" user_id="' + v.userId + '" user_nm="' + v.userNm + '" mobile="' + v.mobileNo + '" email="' + v.email + '">';
                            html += '	</td>';
                            html += '	<td>' + no + '</td>';
                            html += '	<td>' + v.deptNm + '</td>';
                            html += '	<td>' + v.userId + '</td>';
                            html += '	<td>' + v.hy + '</td>';
                            html += '	<td>' + v.userNm + '</td>';
                            html += '	<td>' + v.entrYy + '</td>';
                            html += '	<td>' + v.entrHy + '</td>';
                            html += '	<td>' + v.entrGbnNm + '</td>';
                            html += '	<td>' + v.joinStatus + '</td>';
                            html += '</tr>';
                        }
                    });

                    $("#tabList3").empty().html(html);
                    $("#tab3 table").footable({
                        "breakpoints": {
                            "xs": 375,
                            "sm": 560,
                            "md": 768,
                            "lg": 1024,
                            "w_lg": 1200
                        }
                    });
                    $("#tab3 table").find(".ui.checkbox").checkbox();
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
            });
        }

        //수시
        function selectTab4() {

            if ($("#tab4 select").eq(0).val() == '') {
                /* 수시를 선택해주세요. */
                alert('<spring:message code="common.any.message.select" />');
                return false;
            }

            var url = "/quiz/quizStareUserList.do";
            var data = {
                "examCd": $("#tab4 select").eq(0).val()
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    var returnList = data.returnList || [];
                    var html = '';
                    var no = 1;

                    returnList.forEach(function (v, i) {
                        var type = v.stareCnt > 0 ? '<spring:message code="crs.label.join" />' : '<spring:message code="crs.label.no.join" />';	// 응시/미응시
                        if (type == $("#tab4 select").eq(1).val() || $("#tab4 select").eq(1).val() == "ALL") no++;
                    });
                    returnList.forEach(function (v, i) {
                        var type = v.stareCnt > 0 ? "응시" : "미응시";
                        if (type == $("#tab4 select").eq(1).val() || $("#tab4 select").eq(1).val() == "ALL") {
                            no = no - 1;
                            html += '<tr>';
                            html += '	<td>';
                            html += '		<input type="checkbox" name="tabChk4" tabindex="0" user_id="' + v.userId + '" user_nm="' + v.userNm + '" mobile="' + v.mobileNo + '" email="' + v.email + '">';
                            html += '	</td>';
                            html += '	<td>' + no + '</td>';
                            html += '	<td>' + v.deptNm + '</td>';
                            html += '	<td>' + v.userId + '</td>';
                            html += '	<td>' + v.hy + '</td>';
                            html += '	<td>' + v.userNm + '</td>';
                            html += '	<td>' + v.entrYy + '</td>';
                            html += '	<td>' + v.entrHy + '</td>';
                            html += '	<td>' + v.entrGbnNm + '</td>';
                            html += '	<td>' + type + '</td>';
                            html += '</tr>';
                        }
                    });

                    $("#tabList4").empty().html(html);
                    $("#tab4 table").footable({
                        "breakpoints": {
                            "xs": 375,
                            "sm": 560,
                            "md": 768,
                            "lg": 1024,
                            "w_lg": 1200
                        }
                    });
                    $("#tab4 table").find(".ui.checkbox").checkbox();
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
            });
        }

        // 퀴즈
        function selectTab5() {

            if ($("#tab5 select").eq(0).val() == '') {
                /* 퀴즈를 선택해주세요. */
                alert('<spring:message code="common.quiz.message.select" />');
                return false;
            }

            var url = "/quiz/quizStareUserList.do";
            var data = {
                "examCd": $("#tab5 select").eq(0).val()
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    var returnList = data.returnList || [];
                    var html = '';
                    var no = 1;

                    returnList.forEach(function (v, i) {
                        var type = v.stareCnt > 0 ? "응시" : "미응시";
                        if (type == $("#tab5 select").eq(1).val() || $("#tab5 select").eq(1).val() == "ALL") no++;
                    });
                    returnList.forEach(function (v, i) {
                        var type = v.stareCnt > 0 ? "응시" : "미응시";
                        if (type == $("#tab5 select").eq(1).val() || $("#tab5 select").eq(1).val() == "ALL") {
                            no = no - 1;
                            html += '<tr>';
                            html += '	<td>';
                            html += '		<input type="checkbox" name="tabChk5" tabindex="0" user_id="' + v.userId + '" user_nm="' + v.userNm + '" mobile="' + v.mobileNo + '" email="' + v.email + '">';
                            html += '	</td>';
                            html += '	<td>' + no + '</td>';
                            html += '	<td>' + v.deptNm + '</td>';
                            html += '	<td>' + v.userId + '</td>';
                            html += '	<td>' + v.hy + '</td>';
                            html += '	<td>' + v.userNm + '</td>';
                            html += '	<td>' + v.entrYy + '</td>';
                            html += '	<td>' + v.entrHy + '</td>';
                            html += '	<td>' + v.entrGbnNm + '</td>';
                            html += '	<td>' + type + '</td>';
                            html += '</tr>';
                        }
                    });

                    $("#tabList5").empty().html(html);
                    $("#tab5 table").footable({
                        "breakpoints": {
                            "xs": 375,
                            "sm": 560,
                            "md": 768,
                            "lg": 1024,
                            "w_lg": 1200
                        }
                    });
                    $("#tab5 table").find(".ui.checkbox").checkbox();
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
            });
        }

        // 설문
        function selectTab6() {

            if ($("#tab6 select").eq(0).val() == '') {
                /* 설문을 선택해주세요. */
                alert('<spring:message code="common.resch.message.select" />');
                return false;
            }

            var url = "/resh/reshJoinUserList.do";
            var data = {
                "reschCd": $("#tab6 select").eq(0).val()
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    var returnList = data.returnList || [];
                    var html = '';
                    var no = 1;

                    returnList.forEach(function (v, i) {
                        var type = v.regDttm != null ? "참여" : "미참여";
                        if (type == $("#tab6 select").eq(1).val() || $("#tab6 select").eq(1).val() == "ALL") no++;
                    });
                    returnList.forEach(function (v, i) {
                        var type = v.regDttm != null ? "참여" : "미참여";
                        if (type == $("#tab6 select").eq(1).val() || $("#tab6 select").eq(1).val() == "ALL") {
                            no = no - 1;
                            html += '<tr>';
                            html += '	<td>';
                            html += '		<input type="checkbox" name="tabChk6" tabindex="0" user_id="' + v.userId + '" user_nm="' + v.userNm + '" mobile="' + v.mobileNo + '" email="' + v.email + '">';
                            html += '	</td>';
                            html += '	<td>' + no + '</td>';
                            html += '	<td>' + v.deptNm + '</td>';
                            html += '	<td>' + v.userId + '</td>';
                            html += '	<td>' + v.hy + '</td>';
                            html += '	<td>' + v.userNm + '</td>';
                            html += '	<td>' + v.entrYy + '</td>';
                            html += '	<td>' + v.entrHy + '</td>';
                            html += '	<td>' + v.entrGbnNm + '</td>';
                            html += '	<td>' + type + '</td>';
                            html += '</tr>';
                        }
                    });

                    $("#tabList6").empty().html(html);
                    $("#tab6 table").footable({
                        "breakpoints": {
                            "xs": 375,
                            "sm": 560,
                            "md": 768,
                            "lg": 1024,
                            "w_lg": 1200
                        }
                    });
                    $("#tab6 table").find(".ui.checkbox").checkbox();
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
            });
        }

        // 메세지 보내기
        function sendMsg(index) {
            var rcvUserInfoStr = "";
            var sendCnt = 0;

            $.each($('input[name="tabChk' + index + '"]:checked'), function () {
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

            var form = window.parent.document.alarmForm;
            form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
            form.target = "msgWindow";
            form[name = 'alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
            form[name = 'rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
            form.submit();
        }
    </script>
</head>

<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>

<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
<div id="wrap" class="flex flex-column min-h100per">
    <div class="ui form">
        <div class="listTab mb10">
            <ul class="">
                <c:if test="${not empty lessonScheduleList }">
                    <li class="select mw120"><!-- 가로길이 고정 min-width : 120px -->
                        <a href="#tab1">강의/출석</a>
                    </li>
                </c:if>
                <c:if test="${not empty asmntList }">
                    <li class="mw120"><a href="#tab2">과제</a></li>
                </c:if>
                <c:if test="${not empty forumList }">
                    <li class="mw120"><a href="#tab3">토론</a></li>
                </c:if>
                <c:if test="${not empty quizList }">
                    <li class="mw120"><a href="#tab5">퀴즈</a></li>
                </c:if>
                <c:if test="${not empty reshList }">
                    <li class="mw120"><a href="#tab6">설문</a></li>
                </c:if>
                <c:if test="${not empty examList }">
                    <li class="mw120"><a href="#tab4">수시</a></li>
                </c:if>
            </ul>
        </div>

        <div id="tab1" class="tab_content" style="display: block">
            <div class="ui message flex flex-wrap tc gap4 rowgap8 ">
                <div class="col-5 field m0"><!-- col-3( col-1 ~ col-12) field -->
                    <select class="ui fluid dropdown text-truncate-cell">
                        <option value="">선택</option>
                        <c:forEach items="${lessonScheduleList }" var="list" varStatus="status">
                            <option value="${list.lessonScheduleId}" data-start-dt-yn="${list.startDtYn}"
                                    data-end-dt-yn="${list.endDtYn}">${list.lessonScheduleNm}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-3 field flex m0">
                    <select class="ui fluid dropdown">
                        <option value="ALL">전체</option>
                        <option value="COMPLETE">출석</option>
                        <option value="LATE">지각</option>
                        <option value="NOSTUDY">결석/미학습</option>
                        <option value="STUDY">학습중</option>
                    </select>
                    <button class="ui icon button flex-shrink0" type="button" aria-label="조회하기" onclick="selectTab1();">
                        <i class="search icon"></i>
                    </button>
                </div>
            </div>

            <div class="option-content mb10">
                <button type="button" class="ui basic button small mla" onClick="sendMsg('1')"><i
                        class="paper plane outline icon"></i><spring:message code="common.button.message" /><!-- 메시지 -->
                </button>
            </div>

            <div class="scrollbox max-h350">
                <table class="table type2 table-layout-fixed" data-sorting="true" data-paging="false"
                       data-empty="검색 결과가 없습니다.">
                    <thead>
                    <tr>
                        <th scope="col" class="w50" data-sortable="false">
                            <input type="checkbox" onClick="tabAllChk('1')" tabindex="0"><label></label>
                        </th>
                        <th scope="col" class="w60" data-sortable="false">No</th>
                        <th scope="col" class=""><spring:message code="std.label.dept" /><!-- 학과 --></th>
                        <th scope="col" class="" data-breakpoints="xs">
                            <spring:message code="std.label.user_id" /><!-- 학번 --></th>
                        <th scope="col" class="" data-breakpoints="xs">
                            <spring:message code="std.label.hy" /><!-- 학년 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">
                            <spring:message code="std.label.name" /><!-- 이름 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">
                            <spring:message code="std.label.enter.year" /><!-- 입학년도 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">
                            <spring:message code="std.label.enter.hy" /><!-- 입학학년 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">
                            <spring:message code="std.label.enter.gbn" /><!-- 입학구분 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">출결</th>
                    </tr>
                    </thead>
                    <tbody id="tabList1"></tbody>
                </table>
            </div>
        </div>

        <div id="tab2" class="tab_content">
            <div class="ui message flex flex-wrap tc gap4 rowgap8 ">
                <div class="col-5 field m0"><!-- col-3( col-1 ~ col-12) field -->
                    <select class="ui fluid dropdown text-truncate-cell">
                        <option value="">선택</option>
                        <c:forEach items="${asmntList }" var="list" varStatus="status">
                            <option value="${list.asmntCd}">${list.asmntTitle}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-3 field flex m0">
                    <select class="ui fluid dropdown">
                        <option value="ALL">전체</option>
                        <option value="SUBMIT">제출</option>
                        <option value="NO">미제출</option>
                        <option value="LATE">지각제출</option>
                    </select>
                    <button class="ui icon button flex-shrink0" type="button" aria-label="조회하기" onclick="selectTab2();">
                        <i class="search icon"></i>
                    </button>
                </div>
            </div>

            <div class="option-content mb10">
                <button type="button" class="ui basic button small mla" onClick="sendMsg('2')"><i
                        class="icon envelope outline"></i>보내기
                </button>
            </div>

            <div class="scrollbox max-h350">
                <table class="table type2 table-layout-fixed" data-sorting="true" data-paging="false"
                       data-empty="검색 결과가 없습니다.">
                    <thead>
                    <tr>
                        <th scope="col" class="w50" data-sortable="false">
                            <input type="checkbox" onClick="tabAllChk('2')" tabindex="0"><label></label>
                        </th>
                        <th scope="col" class="w60" data-sortable="false">No</th>
                        <th scope="col" class=""><spring:message code="std.label.dept" /><!-- 학과 --></th>
                        <th scope="col" class="" data-breakpoints="xs">
                            <spring:message code="std.label.user_id" /><!-- 학번 --></th>
                        <th scope="col" class="" data-breakpoints="xs">
                            <spring:message code="std.label.hy" /><!-- 학년 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">
                            <spring:message code="std.label.name" /><!-- 이름 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">
                            <spring:message code="std.label.enter.year" /><!-- 입학년도 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">
                            <spring:message code="std.label.enter.hy" /><!-- 입학학년 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">
                            <spring:message code="std.label.enter.gbn" /><!-- 입학구분 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">제출여부</th>
                    </tr>
                    </thead>
                    <tbody id="tabList2"></tbody>
                </table>
            </div>
        </div>
        <div id="tab3" class="tab_content">
            <div class="ui message flex flex-wrap tc gap4 rowgap8 ">
                <div class="col-5 field m0"><!-- col-3( col-1 ~ col-12) field -->
                    <select class="ui fluid dropdown text-truncate-cell">
                        <option value="">선택</option>
                        <c:forEach items="${forumList }" var="list" varStatus="status">
                            <option value="${list.forumCd}">${list.forumTitle}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-3 field flex m0">
                    <select class="ui fluid dropdown">
                        <option value="ALL">전체</option>
                        <option value="참여">참여</option>
                        <option value="미참여">미참여</option>
                    </select>
                    <button class="ui icon button flex-shrink0" type="button" aria-label="조회하기" onclick="selectTab3();">
                        <i class="search icon"></i>
                    </button>
                </div>
            </div>

            <div class="option-content mb10">
                <button type="button" class="ui basic button small mla" onClick="sendMsg('3')"><i
                        class="icon envelope outline"></i>보내기
                </button>
            </div>

            <div class="scrollbox max-h350">
                <table class="table type2 table-layout-fixed" data-sorting="true" data-paging="false"
                       data-empty="검색 결과가 없습니다.">
                    <thead>
                    <tr>
                        <th scope="col" class="w50" data-sortable="false">
                            <input type="checkbox" onClick="tabAllChk('3')" tabindex="0"><label></label>
                        </th>
                        <th scope="col" class="w60" data-sortable="false">No</th>
                        <th scope="col" class=""><spring:message code="std.label.dept" /><!-- 학과 --></th>
                        <th scope="col" class="" data-breakpoints="xs">
                            <spring:message code="std.label.user_id" /><!-- 학번 --></th>
                        <th scope="col" class="" data-breakpoints="xs">
                            <spring:message code="std.label.hy" /><!-- 학년 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">
                            <spring:message code="std.label.name" /><!-- 이름 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">
                            <spring:message code="std.label.enter.year" /><!-- 입학년도 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">
                            <spring:message code="std.label.enter.hy" /><!-- 입학학년 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">
                            <spring:message code="std.label.enter.gbn" /><!-- 입학구분 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">참여여부</th>
                    </tr>
                    </thead>
                    <tbody id="tabList3"></tbody>
                </table>
            </div>
        </div>
        <div id="tab4" class="tab_content">
            <div class="ui message flex flex-wrap tc gap4 rowgap8 ">
                <div class="col-5 field m0"><!-- col-3( col-1 ~ col-12) field -->
                    <select class="ui fluid dropdown text-truncate-cell">
                        <option value="">선택</option>
                        <c:forEach items="${examList }" var="list" varStatus="status">
                            <option value="${list.examCd}">${list.examTitle}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-3 field flex m0">
                    <select class="ui fluid dropdown">
                        <option value="ALL">전체</option>
                        <option value="응시">응시</option>
                        <option value="미응시">미응시</option>
                    </select>
                    <button class="ui icon button flex-shrink0" type="button" aria-label="조회하기" onclick="selectTab4();">
                        <i class="search icon"></i>
                    </button>
                </div>
            </div>

            <div class="option-content mb10">
                <button type="button" class="ui basic button small mla" onClick="sendMsg('4')"><i
                        class="icon envelope outline"></i>보내기
                </button>
            </div>

            <div class="scrollbox max-h350">
                <table class="table type2 table-layout-fixed" data-sorting="true" data-paging="false"
                       data-empty="검색 결과가 없습니다.">
                    <thead>
                    <tr>
                        <th scope="col" class="w50" data-sortable="false">
                            <input type="checkbox" onClick="tabAllChk('4')" tabindex="0"><label></label>
                        </th>
                        <th scope="col" class="w60" data-sortable="false">No</th>
                        <th scope="col" class=""><spring:message code="std.label.dept" /><!-- 학과 --></th>
                        <th scope="col" class="" data-breakpoints="xs">
                            <spring:message code="std.label.user_id" /><!-- 학번 --></th>
                        <th scope="col" class="" data-breakpoints="xs">
                            <spring:message code="std.label.hy" /><!-- 학년 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">
                            <spring:message code="std.label.name" /><!-- 이름 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">
                            <spring:message code="std.label.enter.year" /><!-- 입학년도 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">
                            <spring:message code="std.label.enter.hy" /><!-- 입학학년 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">
                            <spring:message code="std.label.enter.gbn" /><!-- 입학구분 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">응시여부</th>
                    </tr>
                    </thead>
                    <tbody id="tabList4"></tbody>
                </table>
            </div>
        </div>
        <div id="tab5" class="tab_content">
            <div class="ui message flex flex-wrap tc gap4 rowgap8 ">
                <div class="col-5 field m0"><!-- col-3( col-1 ~ col-12) field -->
                    <select class="ui fluid dropdown text-truncate-cell">
                        <option value="">선택</option>
                        <c:forEach items="${quizList }" var="list" varStatus="status">
                            <option value="${list.examCd}">${list.examTitle}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-3 field flex m0">
                    <select class="ui fluid dropdown">
                        <option value="ALL">전체</option>
                        <option value="응시">응시</option>
                        <option value="미응시">미응시</option>
                    </select>
                    <button class="ui icon button flex-shrink0" type="button" aria-label="조회하기" onclick="selectTab5();">
                        <i class="search icon"></i>
                    </button>
                </div>
            </div>

            <div class="option-content mb10">
                <button type="button" class="ui basic button small mla" onClick="sendMsg('5')"><i
                        class="icon envelope outline"></i>보내기
                </button>
            </div>

            <div class="scrollbox max-h350">
                <table class="table type2 table-layout-fixed" data-sorting="true" data-paging="false"
                       data-empty="검색 결과가 없습니다.">
                    <thead>
                    <tr>
                        <th scope="col" class="w50" data-sortable="false">
                            <input type="checkbox" onClick="tabAllChk('5')" tabindex="0"><label></label>
                        </th>
                        <th scope="col" class="w60" data-sortable="false">No</th>
                        <th scope="col" class=""><spring:message code="std.label.dept" /><!-- 학과 --></th>
                        <th scope="col" class="" data-breakpoints="xs">
                            <spring:message code="std.label.user_id" /><!-- 학번 --></th>
                        <th scope="col" class="" data-breakpoints="xs">
                            <spring:message code="std.label.hy" /><!-- 학년 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">
                            <spring:message code="std.label.name" /><!-- 이름 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">
                            <spring:message code="std.label.enter.year" /><!-- 입학년도 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">
                            <spring:message code="std.label.enter.hy" /><!-- 입학학년 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">
                            <spring:message code="std.label.enter.gbn" /><!-- 입학구분 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">참여여부</th>
                    </tr>
                    </thead>
                    <tbody id="tabList5"></tbody>
                </table>
            </div>
        </div>
        <div id="tab6" class="tab_content">
            <div class="ui message flex flex-wrap tc gap4 rowgap8 ">
                <div class="col-5 field m0"><!-- col-3( col-1 ~ col-12) field -->
                    <select class="ui fluid dropdown text-truncate-cell">
                        <option value="">선택</option>
                        <c:forEach items="${reshList }" var="list" varStatus="status">
                            <option value="${list.reschCd}">${list.reschTitle}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-3 field flex m0">
                    <select class="ui fluid dropdown">
                        <option value="ALL">전체</option>
                        <option value="참여">참여</option>
                        <option value="미참여">미참여</option>
                    </select>
                    <button class="ui icon button flex-shrink0" type="button" aria-label="조회하기" onclick="selectTab6();">
                        <i class="search icon"></i>
                    </button>
                </div>
            </div>

            <div class="option-content mb10">
                <button type="button" class="ui basic button small mla" onClick="sendMsg('6')"><i
                        class="icon envelope outline"></i>보내기
                </button>
            </div>

            <div class="scrollbox max-h350">
                <table class="table type2 table-layout-fixed" data-sorting="true" data-paging="false"
                       data-empty="검색 결과가 없습니다.">
                    <thead>
                    <tr>
                        <th scope="col" class="w50" data-sortable="false">
                            <input type="checkbox" onClick="tabAllChk('6')" tabindex="0"><label></label>
                        </th>
                        <th scope="col" class="w60" data-sortable="false">No</th>
                        <th scope="col" class=""><spring:message code="std.label.dept" /><!-- 학과 --></th>
                        <th scope="col" class="" data-breakpoints="xs">
                            <spring:message code="std.label.user_id" /><!-- 학번 --></th>
                        <th scope="col" class="" data-breakpoints="xs">
                            <spring:message code="std.label.hy" /><!-- 학년 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">
                            <spring:message code="std.label.name" /><!-- 이름 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">
                            <spring:message code="std.label.enter.year" /><!-- 입학년도 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">
                            <spring:message code="std.label.enter.hy" /><!-- 입학학년 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">
                            <spring:message code="std.label.enter.gbn" /><!-- 입학구분 --></th>
                        <th scope="col" class="" data-breakpoints="xs sm">참여여부</th>
                    </tr>
                    </thead>
                    <tbody id="tabList6"></tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="bottom-content mta">
        <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message
                code="common.button.close"/></button><!-- 닫기 -->
    </div>
</div>

<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
