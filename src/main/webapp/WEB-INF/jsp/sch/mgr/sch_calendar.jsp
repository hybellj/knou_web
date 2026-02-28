<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<script src="/webdoc/js/calendar/chance.min.js"></script>
<script src="/webdoc/js/calendar/tui-code-snippet.min.js"></script>
<script src="/webdoc/js/calendar/tui-time-picker.min.js"></script>
<script src="/webdoc/js/calendar/tui-date-picker.min.js"></script>
<script src="/webdoc/js/calendar/moment.min.js"></script>
<script src="/webdoc/js/calendar/tui-calendar.js"></script>
<script src="/webdoc/js/calendar/common_calendars.js"></script>
<script src="/webdoc/js/calendar/schedules.js"></script>
<script src="/webdoc/js/calendar/common_app.js"></script>

<link rel="stylesheet" type="text/css" href="/webdoc/js/calendar/tui-date-picker.css"/>
<link rel="stylesheet" type="text/css" href="/webdoc/js/calendar/tui-time-picker.css"/>
<link rel="stylesheet" type="text/css" href="/webdoc/js/calendar/tui-calendar.css"/>

<script type="text/javascript">
    var messageJs = {
        mod: "<spring:message code='common.button.modify' />" // 수정
        , del: "<spring:message code='common.button.delete' />" // 삭제
    };

    var acadMap = new Map();
    $(document).ready(function () {
        fnCreateCalendar();
        schList(1);
    });

    $(document).mouseup(function (e) {
        var schPopup = $(".schPopup");
        if (schPopup.has(e.target).length === 0) {
            schPopup.hide();
        }
    });

    function fnCreateCalendar() {

        // common_calendars.js 에 정의된 전역 변수 CalendarList[] 에 값을 넣는다.
        fnCreateCalendarList();

        var Calendar = tui.Calendar;
        createCalendar(window, Calendar, 'calendar', false, ""); //common_app.js 에 정의, <div id="calendar"></div> 가 있어야 함

        //setCalendarList(); //common_app.js 에 정의,  <div id="calendarList"> 가 있어야 함
    }

    function fnCreateCalendarList() {
        var calendar;

        <c:forEach items="${calendarList }" var="item">
        var name = ${item.calendarId eq 'course' || item.calendarId eq 'personal'} ? "${item.name}" : "${item.name} (${item.declsNo}<spring:message code='sch.label.room' />)"/* 반 */;
        calendar = new CalendarInfo();
        calendar.id = '${item.calendarId}';
        calendar.name = name;
        calendar.checked = true; //문자열(예를들어 'true')로 넣으면 안됨
        calendar.color = '#FFFFFF';
        calendar.bgColor = '${item.bgColor}';
        calendar.dragBgColor = '${item.bgColor}';
        calendar.borderColor = '${item.bgColor}';

        CalendarList.push(calendar);
        </c:forEach>

    }

    // schedules.js 의 generateSchedule 함수를 재정의
    // 위에서 createCalendar() 함수를 호출하면  안에서 setSchedules() 함수를 호출한다.
    // 다시 setSchedules() 안에서 generateSchedule() 을 호출한다.
    function generateSchedule(viewName, renderStart, renderEnd) {

        var startDt = moment(renderStart.getTime()).format('YYYYMMDD');
        var endDt = moment(renderEnd.getTime()).format('YYYYMMDD');

        ScheduleList = [];
        var schedule = null;

        $.ajax({
            type: "POST",
            async: false,
            dataType: "json",
            data: {
                "startDt": startDt,
                "endDt": endDt
            },
            url: "/sch/schMgr/schCalendarList.do",
            success: function (data) {
                var returnList = data.returnList || [];

                if (returnList.length > 0) {
                    returnList.forEach(function (v, i) {
                        schedule = new ScheduleInfo();
                        schedule.id = v.scheduleId;
                        schedule.calendarId = v.calendarId;
                        schedule.color = '#000000';

                        schedule.title = v.uniCd + ' ' + v.title;
                        schedule.content = v.content;
                        //if(v.calendarId == "course" || v.calendarId == "personal"){ //학사일정
                        //	schedule.title = v.prefix+' '+v.title;
                        //}else{ //그외 링크 넣기
                        //	schedule.title = `<a class="wmax" href="javascript:fnChangeStrToLink('\${v.scheduleGubun}','\${v.calendarId}','\${v.scheduleId}','\${v.prefix}','\${v.title}');" style="text-decoration:underline;color:\${schedule.color}">\${v.prefix} \${v.title}</a>`;
                        //}

                        schedule.category = 'time';
                        schedule.start = v.startFmt;
                        schedule.end = v.endFmt;
                        schedule.isReadOnly = true;

                        ScheduleList.push(schedule);
                        acadMap.set(v.scheduleId, v.name);
                    });
                }
            }
        });

    }

    //상세팝업의 title 영역을 링크로 교체
    function fnChangeStrToLink(scheduleGubun, calendarId, scheduleId, prefix, title) {

        // 상세팝업의 title 영역 지움
        $('.tui-full-calendar-schedule-title').empty();

        // 상세팝업의 title 영역 링크로 교체
        // var link = $('<a href="javascript:goToDetail(\''+scheduleGubun+'\',\''+calendarId+'\',\''+scheduleId+'\',\''+prefix+'\',\''+title+'\');" style="text-decoration:underline;color:#000000">'+prefix+' '+title+'</a>');
        // $('.tui-full-calendar-schedule-title').prepend(link);
    }

    //상세화면으로 이동(lec_act_my_page.jsp 에도 동일하게 적용)
    function goToDetail(scheduleGubun, calendarId, scheduleId, prefix, title) {
        var goToForm = "";
        switch (scheduleGubun) {

            case 'ONLINE': //온라인
                var idarr = scheduleId.split('|');
                goToForm = $('<form id="' + scheduleGubun + '" name="' + scheduleGubun + '"></form>');
                goToForm.attr("action", "/lesson/lessonLect/Form/creLessonCntsView");
                goToForm.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: calendarId}));
                goToForm.append($('<input/>', {type: 'hidden', name: 'lessonCntsId', value: idarr[0]}));
                goToForm.append($('<input/>', {type: 'hidden', name: 'lessonScheduleId', value: idarr[1]}));

                goToForm.appendTo('body');
                goToForm.submit();
                break;

            case 'ASMNT': //과제
                goToForm = $('<form id="' + scheduleGubun + '" name="' + scheduleGubun + '"></form>');

                if ("${menuType}" == "STUDENT") {
                    goToForm.attr("action", "/asmt/stu/asmtInfoManage.do");
                } else {
                    goToForm.attr("action", "/asmtProfAsmtSelectView.do");
                }

                goToForm.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: calendarId}));
                goToForm.append($('<input/>', {type: 'hidden', name: 'asmntCd', value: scheduleId}));

                goToForm.appendTo('body');
                goToForm.submit();
                break;

            case 'FORUM': //토론
                goToForm = $('<form id="' + scheduleGubun + '" name="' + scheduleGubun + '"></form>');

                if ("${menuType}" == "STUDENT") {
                    goToForm.attr("action", "/forum/forumHome/Form/forumView.do");
                } else {
                    goToForm.attr("action", "/forum/forumLect/Form/infoManage.do?tab=0");
                }

                goToForm.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: calendarId}));
                goToForm.append($('<input/>', {type: 'hidden', name: 'forumCd', value: scheduleId}));

                goToForm.appendTo('body');
                goToForm.submit();
                break;

            case 'EXAM': //시험
                goToForm = $('<form id="' + scheduleGubun + '" name="' + scheduleGubun + '"></form>');

                if ("${menuType}" == "STUDENT") {
                    goToForm.attr("action", "/exam/stuExamView.do");
                } else {
                    goToForm.attr("action", "/exam/examInfoManage.do");
                }

                goToForm.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: calendarId}));
                goToForm.append($('<input/>', {type: 'hidden', name: 'examCd', value: scheduleId}));

                goToForm.appendTo('body');
                goToForm.submit();
                break;

            case 'QUIZ': //퀴즈
                goToForm = $('<form id="' + scheduleGubun + '" name="' + scheduleGubun + '"></form>');

                if ("${menuType}" == "STUDENT") {
                    goToForm.attr("action", "/quiz/stuQuizView.do");
                } else {
                    goToForm.attr("action", "/quiz/quizScoreManage.do");
                }

                goToForm.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: calendarId}));
                goToForm.append($('<input/>', {type: 'hidden', name: 'examCd', value: scheduleId}));

                goToForm.appendTo('body');
                goToForm.submit();
                break;

            case 'RESCH': //설문
                goToForm = $('<form id="' + scheduleGubun + '" name="' + scheduleGubun + '"></form>');

                if ("${menuType}" == "STUDENT") {
                    goToForm.attr("action", "/resh/stuReshView.do");
                } else {
                    goToForm.attr("action", "/resh/reshResultManage.do");
                }

                goToForm.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: calendarId}));
                goToForm.append($('<input/>', {type: 'hidden', name: 'reschCd', value: scheduleId}));

                goToForm.appendTo('body');
                goToForm.submit();
                break;

            default:
                break;
        }
    }

    // 일정 등록 팝업
    function writeSchPop(type) {
        $("#writeSchPop h4").text("<spring:message code='sch.cal_lesson' /> <spring:message code='sch.cal_schedule' /> <spring:message code='common.button.create' />"); /* 수업 *//* 일정 *//* 등록 */
        if (type != null) {
            var start = new Date(type.start);
            var end = new Date(type.end);
            $("#writeSchForm input[name=start]").val(start.getFullYear() + "" + pad(start.getMonth() + 1, 2) + "" + pad(start.getDate(), 2) + "" + pad(start.getHours(), 2) + "" + pad(start.getMinutes(), 2) + "" + pad(start.getSeconds(), 2));
            $("#writeSchForm input[name=end]").val(end.getFullYear() + "" + pad(end.getMonth() + 1, 2) + "" + pad(end.getDate(), 2) + "" + pad(end.getHours(), 2) + "" + pad(end.getMinutes(), 2) + "" + pad(end.getSeconds(), 2));
        }
        $("#writeSchForm").attr("target", "writeSchPopIfm");
        $("#writeSchForm").attr("action", "/sch/schMgr/writeSchPop.do");
        $("#writeSchForm").submit();
        $('#writeSchPop').modal('show');
    }

    // 일정 수정 팝업
    function editSchPop(acadSchSn) {
        $(".schPopup").hide();
        $("#writeSchPop h4").text("<spring:message code='sch.cal_lesson' /> <spring:message code='sch.cal_schedule' /> <spring:message code='common.button.modify' />"); /* 수업 *//* 일정 *//* 수정 */
        $("#writeSchForm input[name=acadSchSn]").val(acadSchSn);
        $("#writeSchForm").attr("target", "writeSchPopIfm");
        $("#writeSchForm").attr("action", "/sch/schMgr/editSchPop.do");
        $("#writeSchForm").submit();
        $('#writeSchPop').modal('show');
    }

    // 일정 삭제
    function deleteSch(acadSchSn) {
        var result = confirm("<spring:message code='sch.alert.confirm.del' />"); // 정말 삭제하시겠습니까?
        if (!result) {
            return false;
        }

        var url = "/sch/schMgr/delSch.do";
        var data = {
            "acadSchSn": acadSchSn
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                alert("<spring:message code='sch.alert.cal_delete' />");/* 일정 삭제가 완료되었습니다. */
                $(".schPopup").hide();
                listCalendar();
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='sch.error.cal_delete' />");/* 일정 삭제 중 에러가 발생하였습니다. */
        });
    }

    // 날짜 자리수 채우기
    function pad(number, length) {
        var str = number.toString();
        while (str.length < length) {
            str = '0' + str;
        }
        return str;
    }

    // 일정 정보 팝업 창 오픈
    function showDetailPop(calendarId, schedulerId) {
        if ((calendarId == "course" && ("${menuType}" == "ADMIN" || "${menuType}" == "PROFESSOR")) || (calendarId == "personal")) {
            $(".tui-full-calendar-button-div").removeClass("hide");
        }
        $(".tui-full-calendar-popup-detail-item .tui-full-calendar-content").text(acadMap.get(schedulerId));
    }

    // 캘린더 리스트 초기화
    function listCalendar() {
        $('.calendarDiv .item[role="menuitem"]').each(function (i, v) {
            if (!$(v).hasClass("basic")) {
                $(v).trigger("click");
                return false;
            }
        });
    }

    // 목록 보기 타입 변경
    function listViewType() {
        $(".schDiv").hide();
        if ($("#listBtn").hasClass("listBtn")) {
            $("#listBtn").text("목록으로 보기");
            $("#listBtn").removeClass("listBtn").addClass("calendarBtn");
            $("#calendarDiv").show();
            listCalendar();
        } else {
            $("#listBtn").text("달력으로 보기");
            $("#listBtn").removeClass("calendarBtn").addClass("listBtn");
            $("#listDiv").show();
        }
    }

    // 목록 리스트
    function schList(page) {
        var url = "/sch/schMgr/schListPaging.do";
        var data = {
            creYear: $("#creYear").val()
            , uniCd: $("#uniCd").val()
            , pageIndex: page
            , listScale: $("#listScale").val()
            , searchValue: $("#searchValue").val()
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnList = data.returnList || [];
                var html = "";

                if (returnList.length > 0) {
                    returnList.forEach(function (v, i) {
                        var uniNm = v.uniCd == "A" ? "<spring:message code='sch.uniCd.A' />"/* 공통 */ : v.uniCd == "C" ? "<spring:message code='sch.uniCd.C' />"/* 대학 */ : "<spring:message code='sch.uniCd.G' />"/* 대학원 */;
                        var startDt = v.startDt.substring(0, 4) + "." + v.startDt.substring(4, 6) + "." + v.startDt.substring(6, 8) + " " + v.startDt.substring(8, 10) + ":" + v.startDt.substring(10, 12) + ":" + v.startDt.substring(12, 14);
                        var endDt = v.endDt.substring(0, 4) + "." + v.endDt.substring(4, 6) + "." + v.endDt.substring(6, 8) + " " + v.endDt.substring(8, 10) + ":" + v.endDt.substring(10, 12) + ":" + v.endDt.substring(12, 14);
                        html += "<tr>";
                        html += "	<td>" + v.lineNo + "</td>";
                        html += "	<td>" + uniNm + "</td>";
                        html += "	<td>";
                        html += "		<a class='fcBlue' href='javascript:void(0)' onclick='schPop(this)'>" + v.title + "</a>";

                        html += "		<div class='tui-full-calendar-floating-layer tui-view-55 schPopup' style='display: none; position: fixed; z-index: 1001;'><div class='tui-full-calendar-popup tui-full-calendar-popup-detail'>";
                        html += "			<div class='tui-full-calendar-popup-container'>";
                        html += "				<div class='tui-full-calendar-popup-section tui-full-calendar-section-header'>";
                        html += "					<div>";
                        html += "						<span class='tui-full-calendar-schedule-private tui-full-calendar-icon tui-full-calendar-ic-private'></span>";
                        html += "						<span class='tui-full-calendar-schedule-title'>[" + uniNm + "] " + v.title + "</span>";
                        html += "					</div>";
                        html += "					<div class='tui-full-calendar-popup-detail-date tui-full-calendar-content'>" + startDt + " - " + endDt + "</div>";
                        html += "				</div>";
                        html += "				<div class='content-div mb15'>";
                        html += `					<pre>\${v.content}</pre>`;
                        html += "				</div>";
                        html += "				<div class='tui-full-calendar-button-div tc mb15'>";
                        html += "					<button class='ui blue small button' onclick='editSchPop(\"" + v.scheduleId + "\")'>수정</button><button class='ui blue small button' onclick='deleteSch(\"" + v.scheduleId + "\")'>삭제</button>";
                        html += "				</div>";
                        html += "				<div class='tui-full-calendar-popup-top-line' style='background-color: #a1b56c'></div>";
                        html += "				<div id='tui-full-calendar-popup-arrow' class='tui-full-calendar-popup-arrow tui-full-calendar-arrow-right'>";
                        html += "					<div class='tui-full-calendar-popup-arrow-border'>";
                        html += "						<div class='tui-full-calendar-popup-arrow-fill'></div>";
                        html += "					</div>";
                        html += "				</div>";
                        html += "			</div>";
                        html += "		</div></div>";

                        html += "	</td>";
                        html += "	<td>" + startDt + "</td>";
                        html += "	<td>" + endDt + "</td>";
                        html += "</tr>";
                    });
                }

                $("#schTbody").empty().html(html);
                var params = {
                    totalCount: data.pageInfo.totalRecordCount,
                    listScale: data.pageInfo.recordCountPerPage,
                    currentPageNo: data.pageInfo.currentPageNo,
                    eventName: "schList"
                };

                gfn_renderPaging(params);

                $("#schTable").footable();
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
        }, true);
    }

    function schPop(obj) {
        $(".schPopup").hide();
        $(obj).siblings(".schPopup").show();
    }
</script>

<body>
<form id="writeSchForm" method="POST">
    <input type="hidden" name="acadSchSn"/>
    <input type="hidden" name="start"/>
    <input type="hidden" name="end"/>
</form>
<form id="viewJobSchForm" method="POST">
    <input type="hidden" name="jobSchSn"/>
</form>
<div id="wrap" class="pusher">
    <!-- class_top 인클루드  -->
    <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>

    <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>

    <div id="container">
        <!-- 본문 content 부분 -->
        <div class="content">
            <div class="ui form">
                <!-- 페이지 시작 -->
                <div id="info-item-box">
                    <h2 class="page-title flex-item flex-wrap gap4 columngap16">
                        <spring:message code="sch.label.basic.job.info.manage" /><!-- 수업일정관리 -->
                    </h2>
                    <div class="button-area">
                        <button type="button" class="ui basic small button listBtn" id="listBtn"
                                onclick="listViewType()">달력으로 보기
                        </button>
                        <button type="button" class="ui green small button" onclick="writeSchPop()">
                            <spring:message code="common.button.create" /><!-- 등록 --></button>
                    </div>
                </div>

                <div class="schDiv" id="listDiv">
                    <div class="option-content">
                        <select class="ui dropdown mr5" id="creYear" onchange="schList(1)">
                            <c:forEach var="item" items="${yearList }">
                                <option value="${item }" ${item eq curYear ? 'selected' : '' }>${item }</option>
                            </c:forEach>
                        </select>
                        <select class="ui dropdown mr5" id="uniCd" onchange="schList(1)">
                            <option value=""><spring:message code="common.type" /><!-- 구분 --></option>
                            <option value="all"><spring:message code="sch.uniCd.A" /><!-- 공통 --></option>
                            <option value="C"><spring:message code="sch.uniCd.C" /><!-- 대학교 --></option>
                            <option value="G"><spring:message code="sch.uniCd.G" /><!-- 대학원 --></option>
                        </select>
                        <div class="ui action input search-box">
                            <input type="text" placeholder="제목 입력" class="w250" id="searchValue">
                            <button class="ui icon button" onclick="schList(1)"><i class="search icon"></i></button>
                        </div>
                        <select class="ui dropdown mla" id="listScale" onchange="schList(1)">
                            <option value="10">10</option>
                            <option value="20">20</option>
                            <option value="50">50</option>
                            <option value="100">100</option>
                        </select>
                    </div>
                    <table class="table type2" data-sorting="false" data-paging="false"
                           data-empty="<spring:message code='user.common.empty' />" id="schTable"><!-- 등록된 내용이 없습니다. -->
                        <thead>
                        <tr>
                            <th>NO</th>
                            <th><spring:message code="common.type" /><!-- 구분 --></th>
                            <th><spring:message code="common.label.title" /><!-- 제목 --></th>
                            <th><spring:message code="common.date.start.dt" /><!-- 시작일시 --></th>
                            <th><spring:message code="common.date.end.dt" /><!-- 종료일시 --></th>
                        </tr>
                        </thead>
                        <tbody id="schTbody"></tbody>
                    </table>
                    <div id="paging" class="paging mt20"></div>
                </div>
                <div class="calendar-wrap schDiv" id="calendarDiv" style="display:none;">
                    <div class="calendar-header" id="menu-navi">
                        <button type="button" class="ui basic circular icon button setting-button"><i
                                class="ion-android-settings"></i></button>
                        <div class="w200 mr20"></div>
                        <div class="">
                            <button type="button" class="ui basic button" data-action="move-today"><spring:message
                                    code="sch.cal_today"/></button><!-- 오늘 -->
                            <button type="button" class="ui circular icon move-day f120" data-action="move-prev">
                                <i class="caret left icon" data-action="move-prev"></i>
                            </button>
                            <span id="renderRange" class="f130 fcBlue"></span>
                            <button type="button" class="ui circular icon move-day f120" data-action="move-next">
                                <i class="caret right icon" data-action="move-next"></i>
                            </button>
                        </div>
                        <div class="flex-left-auto">
                            <div class="ui buttons calendarDiv">
                                <button class="ui basic blue button item" role="menuitem" data-action="toggle-weekly">
                                    <spring:message code="sch.cal_week"/></button><!-- 주별 -->
                                <button class="ui blue button item" role="menuitem" data-action="toggle-monthly">
                                    <spring:message code="sch.cal_month"/></button><!-- 월별 -->
                            </div>
                        </div>
                    </div>
                    <div class="calendar-content">
                        <div id="calendar"></div>
                    </div>
                </div>
                <!-- 페이지 끝-->
            </div>
        </div>
    </div>
    <!-- //본문 content 부분 -->
    <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
</div>

<!-- 일정 등록 팝업 -->
<div class="modal fade" id="writeSchPop" tabindex="-1" role="dialog"
     aria-labelledby="<spring:message code="dashboard.class_schedule" /><spring:message code="forum.button.reg" />"
     aria-labelledby="modal" aria-hidden="false">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"
                        aria-label="<spring:message code='common.button.close' />"><!-- 닫기 -->
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title"><spring:message code="dashboard.class_schedule"/><spring:message
                        code="forum.button.reg"/></h4><!-- 수업일정 등록 -->
            </div>
            <div class="modal-body">
                <iframe src="" id="writeSchPopIfm" name="writeSchPopIfm" width="100%" scrolling="no"></iframe>
            </div>
        </div>
    </div>
</div>
<!-- 일정 등록 팝업 -->

<script>
    $('iframe').iFrameResize();
    window.closeModal = function () {
        $('#writeSchPop').modal('hide');
    };
</script>
</body>
</html>