<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
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
<link rel="stylesheet" type="text/css" href="/webdoc/css/main_default.css"/>
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

    });

    function fnCreateCalendar() {

        // common_calendars.js 에 정의된 전역 변수 CalendarList[] 에 값을 넣는다.
        fnCreateCalendarList();

        var Calendar = tui.Calendar;
        createCalendar(window, Calendar, 'calendar', false, "<%=SessionInfo.getThemeMode(request)%>"); //common_app.js 에 정의, <div id="calendar"></div> 가 있어야 함

        setCalendarList(); //common_app.js 에 정의,  <div id="calendarList"> 가 있어야 함
    }

    function fnCreateCalendarList() {
        var calendar;

        <c:forEach items="${calendarList }" var="item">
        var name = ${item.calendarId eq 'course' || item.calendarId eq 'personal'} ? "${item.name}" : "${item.name} (${item.declsNo}<spring:message code='crs.label.room' />)"/* 반 */;
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
            url: "/dashboard/schCalendarList.do",
            success: function (data) {
                var returnList = data.returnList || [];

                if (returnList.length > 0) {
                    returnList.forEach(function (v, i) {
                        schedule = new ScheduleInfo();
                        schedule.id = v.scheduleId;
                        schedule.calendarId = v.calendarId;
                        schedule.color = '#000000';

                        schedule.title = v.prefix + ' ' + v.title;
                        schedule.content = v.content;
                        //if(v.calendarId == "course" || v.calendarId == "personal"){ //학사일정
                        //	schedule.title = v.prefix+' '+v.title;
                        //}else{ //그외 링크 넣기
                        //	schedule.title = `<a class="wmax" href="javascript:fnChangeStrToLink('\${v.scheduleGubun}','\${v.calendarId}','\${v.scheduleId}','\${v.prefix}','\${v.title}');" style="text-decoration:underline;color:\${schedule.color}">\${v.prefix} \${v.title}</a>`;
                        //}

                        schedule.category = 'time';
                        schedule.start = v.start;
                        schedule.end = v.end;
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

        //상세팝업의 title 영역 링크로 교체
        var link = $('<a href="javascript:goToDetail(\'' + scheduleGubun + '\',\'' + calendarId + '\',\'' + scheduleId + '\',\'' + prefix + '\',\'' + title + '\');" style="text-decoration:underline;color:#000000">' + prefix + ' ' + title + '</a>');
        $('.tui-full-calendar-schedule-title').prepend(link);

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
        $("#writeSchPop h4").text("<spring:message code='dashboard.cal_schedule' /> <spring:message code='common.button.create' />");/* 일정 *//* 등록 */
        if (type != null) {
            var start = new Date(type.start);
            var end = new Date(type.end);
            $("#writeSchForm input[name=start]").val(start.getFullYear() + "" + pad(start.getMonth() + 1, 2) + "" + pad(start.getDate(), 2) + "" + pad(start.getHours(), 2) + "" + pad(start.getMinutes(), 2) + "" + pad(start.getSeconds(), 2));
            $("#writeSchForm input[name=end]").val(end.getFullYear() + "" + pad(end.getMonth() + 1, 2) + "" + pad(end.getDate(), 2) + "" + pad(end.getHours(), 2) + "" + pad(end.getMinutes(), 2) + "" + pad(end.getSeconds(), 2));
        }
        $("#writeSchForm").attr("target", "writeSchPopIfm");
        $("#writeSchForm").attr("action", "/dashboard/writeSchPop.do");
        $("#writeSchForm").submit();
        $('#writeSchPop').modal('show');
    }

    // 일정 수정 팝업
    function editSchPop(acadSchSn) {
        $("#writeSchPop h4").text("<spring:message code='dashboard.cal_schedule' /> <spring:message code='common.button.modify' />");/* 일정 *//* 수정 */
        $("#writeSchForm input[name=acadSchSn]").val(acadSchSn);
        $("#writeSchForm").attr("target", "writeSchPopIfm");
        $("#writeSchForm").attr("action", "/dashboard/editSchPop.do");
        $("#writeSchForm").submit();
        $('#writeSchPop').modal('show');
    }

    // 일정 삭제
    function deleteSch(acadSchSn) {
        var url = "/dashboard/delSch.do";
        var data = {
            "acadSchSn": acadSchSn
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                alert("<spring:message code='dashboard.alert.cal_delete' />");/* 일정 삭제가 완료되었습니다. */
                listCalendar();
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='dashboard.error.cal_delete' />");/* 일정 삭제 중 에러가 발생하였습니다. */
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
        if ((calendarId == "course" && "${menuType}" == "PROFESSOR") || (calendarId == "personal")) {
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
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
<form id="writeSchForm" method="POST">
    <input type="hidden" name="acadSchSn"/>
    <input type="hidden" name="start"/>
    <input type="hidden" name="end"/>
</form>
<div id="wrap" class="pusher">
    <!-- class_top 인클루드  -->
    <%@ include file="/WEB-INF/jsp/common/frontGnb.jsp" %>

    <div id="container">
        <%@ include file="/WEB-INF/jsp/common/frontLnb.jsp" %>

        <!-- 본문 content 부분 -->
        <div class="content">
            <%@ include file="/WEB-INF/jsp/common/location.jsp" %>
            <div class="ui form stu_section grid-content-box backcolorArea">
                <div class="calendar-wrap">
                    <div class="calendar-header" id="menu-navi">
                        <button type="button" class="ui basic circular icon button setting-button"><i
                                class="ion-android-settings"></i></button>
                        <div class="w200 mr20"></div>
                        <div class="">
                            <button type="button" class="ui basic button" data-action="move-today"><spring:message
                                    code="dashboard.cal_today"/></button><!-- 오늘 -->
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
                                    <spring:message code="dashboard.cal_week"/></button><!-- 주별 -->
                                <button class="ui blue button item" role="menuitem" data-action="toggle-monthly">
                                    <spring:message code="dashboard.cal_month"/></button><!-- 월별 -->
                            </div>
                            <button type="button" class="ui basic blue button icon p10 f120 mb5"
                                    onclick="writeSchPop()"><i class="plus icon"></i></button>
                        </div>
                    </div>
                    <div class="calendar-content">
                        <aside>
                            <div class="lnb-schedule">
                                <div id="lnb-calendars" class="lnb-calendars">
                                    <div>
                                        <div class="lnb-calendars-item">
                                            <button type="button" class="ui blue button w150 mb10" value="all">
                                                <spring:message code="dashboard.cal_all"/><spring:message
                                                    code="dashboard.cal_schedule"/></button><!-- 전체 --><!-- 일정 -->
                                            <button type="button" class="ui blue button w150 mb10" value="course">
                                                <spring:message code="dashboard.cal_course"/><spring:message
                                                    code="dashboard.cal_schedule"/></button><!-- 과목 --><!-- 일정 -->
                                            <button type="button" class="ui blue button w150 mb10" value="personal">
                                                <spring:message code="dashboard.cal_private"/><spring:message
                                                    code="dashboard.cal_schedule"/></button><!-- 개인 --><!-- 일정 -->
                                        </div>
                                    </div>
                                    <div id="calendarList" class="lnb-calendars-d1 hide">
                                    </div>
                                </div>
                            </div>
                        </aside>
                        <div id="calendar"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- //본문 content 부분 -->
    <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
    <!-- 일정 등록 팝업 -->
    <div class="modal fade" id="writeSchPop" tabindex="-1" role="dialog"
         aria-labelledby="<spring:message code="sys.label.job.sch.add" />" aria-hidden="false">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"
                            aria-label="<spring:message code='user.button.close' />"><!-- 닫기 -->
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title"><spring:message code="sys.label.job.sch.add"/></h4><!-- 일정등록 -->
                </div>
                <div class="modal-body">
                    <iframe src="" id="writeSchPopIfm" name="writeSchPopIfm" width="100%" scrolling="no"></iframe>
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
</div>
</body>
</html>