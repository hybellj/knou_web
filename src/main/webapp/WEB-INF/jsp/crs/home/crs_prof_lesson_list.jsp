<%@page import="knou.framework.common.SessionInfo" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
    var SORT_ODR = "ASC";				// 강의 주차 정렬
    var IS_SCROLL_TOP_ACTION = false;	// 강의 주차 스크롤 이동 여부
    var LESSON_SCHEDULE_LIST = []; 		// 강의 주차 목록
    var STD_JOIN_STATUS_OBJ = {}; 		// 강의실 홈 학생 참여현황
    var IS_REFERESH_ACTION = false;		// 강의 주차 목록 갱신여부
    var LCDMS_LINK_YN = "${creCrsVO.lcdmsLinkYn}";

    $(document).ready(function () {
        changeAppNaviBarState("showBar");

        $('.learn_progress .my_average,.learn_progress .all_average').progress({
            duration: 100
            , total: 100
        });

        // 주차 목록 조회
        listLessonSchedule();
    });

    // 주차 선택
    function selectLessonSchedule(lessonScheduleId) {
        // 주차목록 초기화
        setLessonScheduleList();

        // 강의실 홈 학생 참여현황 세팅
        setStdJoinStatus();

        var isActive = $("[data-acc-lesson-schedule-id='" + lessonScheduleId + "']").hasClass("active");

        if (isActive) {
            //lessonScheduleScrollTop(lessonScheduleId);
        } else {
            IS_SCROLL_TOP_ACTION = true;

            // 해당 주차의 아코디언 펼침
            $('#acc_' + lessonScheduleId).accordion("open", 0);
        }

        var top = $('#acc_' + lessonScheduleId).offset().top - 10;

        // 주차위치로 스크롤
        $("html").scrollTop(top);

        setTimeout(function () {
            if ($("header.common").css("position") == "fixed") {
                $("html").scrollTop(top - $("header.common").height());
            }
        }, 100);

        // 선택된 주차를 맨 위로 이동
        //$("#lessonScheduleList").prepend($('#acc_' + lessonScheduleId));

        // 모바일인경우 화면 스크롤
        //if (DEVICE_TYPE != undefined && DEVICE_TYPE == "mobile") {
        //	$("html").scrollTop($(".week-list").offset().top - 70);
        //}
    }

    // 주차별 참여 현황 - 주차 포커스 이동
    function lessonScheduleScrollTop(lessonScheduleId) {
        var top = $('#acc_' + lessonScheduleId).offset().top;
        $("html").animate({scrollTop: top}, 300);

        IS_SCROLL_TOP_ACTION = false;
    }

    // 전체 주차 버튼 - 전체 아코디언 닫기/열기
    function toggleLessonScheduleOpen() {
        var $accordionTitle = $('#lessonScheduleList > .ui.accordion > .title');
        var accordionCnt = $accordionTitle.length;
        var openAccordionCnt = 0;

        $.each($accordionTitle, function () {
            var isActive = $(this).hasClass("active");

            if (isActive) {
                openAccordionCnt++;
            }
        });

        $.each($accordionTitle, function () {
            if (openAccordionCnt == accordionCnt) {
                $('#lessonScheduleList > .ui.accordion').accordion("close", 0);
            } else {
                $('#lessonScheduleList > .ui.accordion').accordion("open", 0);
            }
        });
    }

    // 주차 목록 정렬 버튼
    function toggleLessonScheduleSortOrder(el) {
        var toggleClass = (SORT_ODR == "ASC" ? "down" : "up");

        SORT_ODR = (SORT_ODR == "ASC" ? "DESC" : "ASC");
        $(el).find("i").removeClass("up").removeClass("down").addClass(toggleClass);

        // 주차 목록 조회
        if (IS_REFERESH_ACTION) {
            listLessonSchedule();
        } else {
            LESSON_SCHEDULE_LIST = LESSON_SCHEDULE_LIST.reverse();

            // 주차목록 세팅
            setLessonScheduleList();

            // 강의실 홈 학생 참여현황 세팅
            setStdJoinStatus();
        }
    }

    // 주차 목록 조회
    function listLessonSchedule() {
        var deferred = $.Deferred();

        var url = "/crs/listCrsHomeLessonSchedule.do";
        var data = {
            crsCreCd: '<c:out value="${crsCreCd}" />',
            lcdmsLinkYn: '<c:out value="${creCrsVO.lcdmsLinkYn}"/>'
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnList = data.returnList || [];

                if (SORT_ODR == "DESC") {
                    returnList = returnList.reverse();
                }

                LESSON_SCHEDULE_LIST = returnList;
                IS_REFERESH_ACTION = false;

                // 주차목록 세팅
                setLessonScheduleList();

                // 강의실 홈 학생 참여현황 조회
                listCrsHomeStdJoinStatus();

                deferred.resolve();
            } else {
                alert(data.message);
                deferred.reject();
            }
        }, function (xhr, status, error) {
            alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
            deferred.reject();
        });

        return deferred.promise();
    }

    // 주차목록 세팅
    function setLessonScheduleList() {
        var html = createLessonScheduleHtml(LESSON_SCHEDULE_LIST);

        $("#lessonScheduleList").empty().html(html);
        $('.ui.dropdown').dropdown();

        $('#lessonScheduleList > .ui.accordion').accordion({
            exclusive: false,
            selector: {
                trigger: '.title'
            },
            duration: 100,
            onOpen: function () {
                if (IS_SCROLL_TOP_ACTION) {
                    // 포거스 스크롤 이동
                    var lessonScheduleId = $(this).data("accLessonScheduleId");
                    //lessonScheduleScrollTop(lessonScheduleId);
                }

                IS_SCROLL_TOP_ACTION = false;
            },
            onClose: function () {
                $(this).find(".add-elem-box").hide();
            }
        });
    }

    // 강의실 홈 학생 참여현황 조회
    function listCrsHomeStdJoinStatus() {
        var lessonScheduleIdObj = {};
        //var lessonCntsIdObj = {};
        var aEaxmCdObj = {};
        var asmntCdObj = {};
        var forumCdObj = {};
        var quizCdObj = {};
        var reschCdObj = {};
        var seminarIdObj = {};

        LESSON_SCHEDULE_LIST.forEach(function (v, i) {
            var listLessonTime = v.listLessonTime || [];
            var listCrsHomeAExam = v.studyElementMap.listCrsHomeAExam || [];
            var listCrsHomeAsmnt = v.studyElementMap.listCrsHomeAsmnt || [];
            var listCrsHomeForum = v.studyElementMap.listCrsHomeForum || [];
            var listCrsHomeQuiz = v.studyElementMap.listCrsHomeQuiz || [];
            var listCrsHomeResch = v.studyElementMap.listCrsHomeResch || [];
            var listCrsHomeSeminar = v.studyElementMap.listCrsHomeSeminar || [];

            if (v.lessonScheduleProgress != "READY" && !v.examStareTypeCd) {
                // 주차
                lessonScheduleIdObj[v.lessonScheduleId] = true;

                // 학습자료
                /*
                listLessonTime.forEach(function(vv, j) {
                    var listLessonCnts = vv.listLessonCnts || [];

                    listLessonCnts.forEach(function(vvv, k) {
                        lessonCntsIdObj[vvv.lessonCntsId] = true;
                    });
                });
                 */

                // 상시시험
                listCrsHomeAExam.forEach(function (vv, j) {
                    aEaxmCdObj[vv.examCd] = true;
                });

                // 과제
                listCrsHomeAsmnt.forEach(function (vv, j) {
                    asmntCdObj[vv.asmntCd] = true;
                });

                // 토론
                listCrsHomeForum.forEach(function (vv, j) {
                    forumCdObj[vv.forumCd] = true;
                });

                // 퀴즈
                listCrsHomeQuiz.forEach(function (vv, j) {
                    quizCdObj[vv.examCd] = true;
                });

                // 설문
                listCrsHomeResch.forEach(function (vv, j) {
                    reschCdObj[vv.reschCd] = true;
                });

                // 세미나
                listCrsHomeSeminar.forEach(function (vv, j) {
                    seminarIdObj[vv.seminarId] = true;
                });
            }
        });

        var url = "/crs/crsHomeScheduleListStatus.do";
        var data = {
            crsCreCd: '<c:out value="${crsCreCd}" />'
            , lessonScheduleIds: Object.keys(lessonScheduleIdObj).join(",")
            //, lessonCntsIds		: Object.keys(lessonCntsIdObj).join(",")
            , aExamCds: Object.keys(aEaxmCdObj).join(",")
            , asmntCds: Object.keys(asmntCdObj).join(",")
            , forumCds: Object.keys(forumCdObj).join(",")
            , quizCds: Object.keys(quizCdObj).join(",")
            , reschCds: Object.keys(reschCdObj).join(",")
            , seminarIds: Object.keys(seminarIdObj).join(",")
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnVO = data.returnVO;

                STD_JOIN_STATUS_OBJ = returnVO;

                // 강의실 홈 학생 참여현황 세팅
                setStdJoinStatus();
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
        });
    }

    // 강의실 홈 학생 참여현황 세팅
    function setStdJoinStatus() {
        var stdCnt = STD_JOIN_STATUS_OBJ.stdCnt;
        var joinStatusLessonScheduleList = STD_JOIN_STATUS_OBJ.joinStatusLessonScheduleList || [];
        //var joinStatusLessonCntsList = STD_JOIN_STATUS_OBJ.joinStatusLessonCntsList || [];
        var joinStatusAExamList = STD_JOIN_STATUS_OBJ.joinStatusAExamList || [];
        var joinStatusAsmntList = STD_JOIN_STATUS_OBJ.joinStatusAsmntList || [];
        var joinStatusForumList = STD_JOIN_STATUS_OBJ.joinStatusForumList || [];
        var joinStatusQuizList = STD_JOIN_STATUS_OBJ.joinStatusQuizList || [];
        var joinStatusReschList = STD_JOIN_STATUS_OBJ.joinStatusReschList || [];
        var joinStatusSeminarList = STD_JOIN_STATUS_OBJ.joinStatusSeminarList || [];

        // 주차 참여현황 세팅
        joinStatusLessonScheduleList.forEach(function (v, i) {
            var lessonScheduleId = v.lessonScheduleId;
            var lessonScheduleCompleteCnt = v.lessonScheduleCompleteCnt;
            var lessonScheduleLateCnt = v.lessonScheduleLateCnt;

            var noJoinCnt = stdCnt - lessonScheduleCompleteCnt - lessonScheduleLateCnt;

            $("#lessonScheduleStatus1_" + lessonScheduleId).text(lessonScheduleCompleteCnt);
            $("#lessonScheduleStatus2_" + lessonScheduleId).text(lessonScheduleLateCnt);
            $("#lessonScheduleStatus3_" + lessonScheduleId).text(noJoinCnt);

            $(".lessonScheduleStatus").show();
            $("#lessonScheduleJoinRate_" + lessonScheduleId).text(v.lessonScheduleJoinRate.toFixed(1) + "%").css("visibility", "visible");
        });

        // 학습자료 참여현황 세팅
        /*
        joinStatusLessonCntsList.forEach(function(v, i) {
            var lessonCntsId = v.lessonCntsId;
            var lessonCntsJoinCnt = v.lessonCntsJoinCnt;

            var noJoinCnt = stdCnt - lessonCntsJoinCnt;

            $("#lessonCntsStatus1_" + lessonCntsId).text("수강 : " + lessonCntsJoinCnt);
            $("#lessonCntsStatus2_" + lessonCntsId).text("미수강 : " + noJoinCnt);
        });
         */

        // 상시시험 참여현황 세팅
        joinStatusAExamList.forEach(function (v, i) {
            var examCd = v.examCd;
            var examJoinCnt = v.examJoinCnt;

            var noJoinCnt = stdCnt - examJoinCnt;

            $(".aExamStatus1_" + examCd).text("<spring:message code='crs.label.join' /> : " + examJoinCnt);	// 응시
            $(".aExamStatus2_" + examCd).text("<spring:message code='crs.label.no.join' /> : " + noJoinCnt);	// 미응시
        });

        // 과제 참여현황 세팅
        joinStatusAsmntList.forEach(function (v, i) {
            var asmntCd = v.asmntCd;
            var asmntSubmitCnt = v.asmntSubmitCnt;
            var asmntLateCnt = v.asmntLateCnt;
            var asmntIndStdCnt = v.asmntIndStdCnt;

            var noJoinCnt;

            if (asmntIndStdCnt != null) {
                noJoinCnt = asmntIndStdCnt - asmntSubmitCnt - asmntLateCnt;
            } else {
                noJoinCnt = stdCnt - asmntSubmitCnt - asmntLateCnt
            }

            $(".asmntStatus1_" + asmntCd).text("<spring:message code='std.label.asmnt_submit' /> : " + asmntSubmitCnt);	// 제출
            $(".asmntStatus2_" + asmntCd).text("<spring:message code='std.label.late' /> : " + asmntLateCnt);					// 지각
            $(".asmntStatus3_" + asmntCd).text("<spring:message code='std.label.asmnt_nosubmit' /> : " + noJoinCnt);		// 미제출
        });

        // 토론 참여현황 세팅
        joinStatusForumList.forEach(function (v, i) {
            var forumCd = v.forumCd;
            var forumJoinCnt = v.forumJoinCnt;

            var noJoinCnt = stdCnt - forumJoinCnt;

            $(".forumStatus1_" + forumCd).text("<spring:message code='crs.label.atnd' /> : " + forumJoinCnt);	// 참여
            $(".forumStatus2_" + forumCd).text("<spring:message code='crs.label.no.atnd' /> : " + noJoinCnt);	// 미참여
        });

        // 퀴즈 참여현황 세팅
        joinStatusQuizList.forEach(function (v, i) {
            var quizCd = v.quizCd;
            var quizJoinCnt = v.quizJoinCnt;
            var quizReJoinCnt = v.quizReJoinCnt;

            var noJoinCnt = stdCnt - quizJoinCnt - quizReJoinCnt;

            $(".quizStatus1_" + quizCd).text("<spring:message code='crs.label.atnd' /> : " + quizJoinCnt);					// 참여
            $(".quizStatus2_" + quizCd).text("<spring:message code='common.label.reexam' /> : " + quizReJoinCnt);	// 재시험
            $(".quizStatus3_" + quizCd).text("<spring:message code='crs.label.no.atnd' /> : " + noJoinCnt);					// 미참여
        });

        // 설문 참여현황 세팅
        joinStatusReschList.forEach(function (v, i) {
            var reschCd = v.reschCd;
            var reschJoinCnt = v.reschJoinCnt;

            var noJoinCnt = stdCnt - reschJoinCnt;

            $(".reschStatus1_" + reschCd).text("<spring:message code='crs.label.atnd' /> : " + reschJoinCnt);	// 참여
            $(".reschStatus2_" + reschCd).text("<spring:message code='crs.label.no.atnd' /> : " + noJoinCnt);	// 미참여
        });

        // 세미나 참여현황 세팅
        joinStatusSeminarList.forEach(function (v, i) {
            var seminarId = v.seminarId;
            var seminarAttendCnt = v.seminarAttendCnt;
            var seminarLateCnt = v.seminarLateCnt;
            var seminarAbsentCnt = v.seminarAbsentCnt;

            if (v.seminarCtgrCd == "offline") {
                $(".seminarStatus1_" + seminarId).text("<spring:message code='lesson.label.study.status.complete' /> : " + seminarAttendCnt);	// 출석
                $(".seminarStatus2_" + seminarId).text("<spring:message code='lesson.label.study.status.late' /> : " + seminarLateCnt);				// 지각
                $(".seminarStatus3_" + seminarId).text("<spring:message code='lesson.label.study.status.nostudy' /> : " + seminarAbsentCnt);	// 결석
            } else {
                $(".seminarStatus1_" + seminarId).text(seminarAttendCnt + "<spring:message code='resh.label.nm' />");		// 명
                $(".seminarStatus2_" + seminarId).text(seminarLateCnt + "<spring:message code='resh.label.nm' />");		// 명
                $(".seminarStatus3_" + seminarId).text(seminarAbsentCnt + "<spring:message code='resh.label.nm' />");	// 명
            }
        });
    }

    // 1.주차
    function createLessonScheduleHtml(listLessonSchedule) {
        var deptCd = '<c:out value="${deptCd}" />';
        var userId = '<c:out value="${userId}" />';
        var prevCourseYn = '<c:out value="${prevCourseYn}" />';
        var seminarAttendAuthYn = '<c:out value="${seminarAttendAuthYn}" />';

        var html = '';

        if (listLessonSchedule && listLessonSchedule.length > 0) {

            listLessonSchedule.forEach(function (v, i) {
                var listLessonTime = v.listLessonTime || [];
                var listCrsHomeExam = v.studyElementMap && v.studyElementMap.listCrsHomeExam || [];

                var lessonStartDtFmt = getDateFmt(v.lessonStartDt);
                var lessonEndDtFmt = getDateFmt(v.lessonEndDt);

                var lessonProgressHtml = '';
                var lessonProgressNm = '';
                var lessonProgressClass = '';
                var scheduleFrDt = getDateFmt(v.ltDetmFrDt) || lessonStartDtFmt;
                var scheduleToDt = getDateFmt(v.ltDetmToDt) || lessonEndDtFmt;

                /*
                if(v.lessonScheduleProgress == "READY") {
                    lessonProgressHtml = 'state_wait';
                    lessonProgressNm = '대기';
                } else if(v.lessonScheduleProgress == "PROGRESS") {
                    lessonProgressHtml = 'lect_ing state_open';
                    lessonProgressNm = '수업중';
                } else if(v.lessonScheduleProgress == "END") {
                    lessonProgressHtml = 'dead_line state_end';
                    lessonProgressNm = '마감';
                }
                */

                if (v.lessonScheduleStat == "READY") {
                    lessonProgressHtml = 'state_wait';
                    lessonProgressNm = '<spring:message code="common.label.ready" />';	// 대기
                } else if (v.lessonScheduleStat == "PROGRESS") {
                    //lessonProgressHtml = 'lect_ing state_open';
                    lessonProgressHtml = 'state_open';
                    lessonProgressNm = '<spring:message code="lesson.label.status.progress" />';	// 수업중
                } else if (v.lessonScheduleStat == "END") {
                    //lessonProgressHtml = 'dead_line state_end';
                    lessonProgressHtml = 'state_end';
                    lessonProgressNm = '<spring:message code="lesson.label.status.end" />';	// 마감
                }

                var openYnHtml = '';
                /*
                if(v.startDtYn == "Y") {
                    openYnHtml = '<span class="ui deepblue2 small label">공개</span>';
                } else {
                    openYnHtml = '<span class="ui pink small label">비공개</span>';
                }
                */

                // 중간/기말 시험 정보
                var examInfo = {};
                var examTitle;
                var scoreOpenYnText;
                var open = '<spring:message code="message.open" />';			// 공개
                var privates = '<spring:message code="message.private" />';	// 비공개

                if (v.examStareTypeCd) {
                    listCrsHomeExam.forEach(function (vv, i) {
                        if (v.examStareTypeCd == "M" && vv.examStareTypeCd == "M") {
                            examInfo = vv;
                        } else if (v.examStareTypeCd == "L" && vv.examStareTypeCd == "L") {
                            examInfo = vv;
                        }
                    });

                    if (examInfo.examCd) {
                        examTitle = examInfo.examTitle;
                        scoreOpenYnText = examInfo.examQuizScoreOpenYn == "Y" ? open : privates;	// 공개 비공개
                    } else {
                        if (v.examStareTypeCd == "M") {
                            examTitle = "<spring:message code='crs.label.mid_exam' />";	// 중간고사
                        } else if (v.examStareTypeCd == "L") {
                            examTitle = "<spring:message code='crs.label.final_exam' />";	// 기말고사
                        }
                    }
                }

                // 기본 오픈 아코디언 (현재주차)
                var activeAccordionClass = '';
                if (v.lessonScheduleProgress == "PROGRESS") {
                    activeAccordionClass = "active";
                }

                // 강의보기 버튼 사용여부
                var hasVideoCnts = false;
                var firstLessonTimeId;

                if (listLessonTime.length > 0) {
                    // 1주차 기준 동영상 컨텐츠가 있는경우
                    var listLessonCnts = listLessonTime[0].listLessonCnts || [];

                    firstLessonTimeId = listLessonTime[0].lessonTimeId;

                    listLessonCnts.forEach(function (vv, j) {
                        if (vv.cntsGbn == "VIDEO" || vv.cntsGbn == "VIDEO_LINK") {
                            hasVideoCnts = true;
                            return false;
                        }
                    });
                }

                var hasAttendAuth = false;
                var seminarId = "";

                // 수업지원팀(20042), 교육플랫폼혁신팀(20134), 대학원교학팀(20040)
                if ((deptCd == "20042" || deptCd == "20134" || deptCd == "20040" || userId == "mediadmin") && v.prgrVideoCnt > 0) {
                    hasAttendAuth = true;
                } else {
                    if (v.startDtYn == "Y" && v.lessonScheduleEnd14Yn == "N" && (v.wekClsfGbn == "02" || v.wekClsfGbn == "03") && seminarAttendAuthYn == "Y") {
                        var listSeminar = listLessonTime[0].listSeminar || [];

                        listSeminar.forEach(function (vv, j) {
                            seminarId = vv.seminarId;
                        });

                        hasAttendAuth = true;
                    }
                }

                //html += '<div id="acc_' + v.lessonScheduleId + '" class="ui accordion courseItem ' + lessonProgressHtml + ' ml40">';
                html += '<div id="acc_' + v.lessonScheduleId + '" class="ui accordion courseItem ' + lessonProgressHtml + ' mt10">';
                html += '	<div class="title mainInfo ' + activeAccordionClass + '" style="cursor:pointer">';

                //html += '		<div class="option-content lectInfo">';
                //html += '			<span class="ui small label state"><i class="ico"></i>' + lessonProgressNm + '</span>';
                //html += '			<span class="ui small label state">' + lessonProgressNm + '</span>';
                //html += 			openYnHtml;
                //html += '		</div>';

                if (v.examStareTypeCd) {
                    html += '	<div class="lect">';
                    html += '    	<div class="info">';
                    html += '    		<p class="lect_name"><span>' + examTitle + '</span>';
                    html += '		      <span class="lectInfo">';
                    html += '			    <span class="ui small label state">' + lessonProgressNm + '</span>';
                    html += openYnHtml + ' <small class="fwb fcDark9">' + lessonStartDtFmt + ' ~ ' + lessonEndDtFmt + '</small>';
                    html += '		      </span>';
                    html += '           </p>';
                    html += '    		<ul class="list_verticalline">';
                    html += '        		<li>';
                    //html += '					<small class="">일시</small>';
                    //html += '					<small class="">' + lessonStartDtFmt + ' ~ ' + lessonEndDtFmt + '</small>';
                    html += '				</li>';
                    /*
                    if(examInfo.examCd) {
                        html += '        	<li>';
                        if(examInfo.examTypeCd == "EXAM" || examInfo.examTypeCd == "QUIZ") {
                            html += '            	<small class="">' + (examInfo.examStareTm || ' - ') + '분</small>';
                        } else {
                            html += '            	<small class="">성적 : ' + scoreOpenYnText + '</small>';
                        }
                        html += '			</li>';
                    }
                    */
                    html += '			</ul>';
                    html += '		</div>'; // info
                    html += '		<div class="button-area">';
                    var examType = examInfo.examStareTypeCd == "A" ? "ADMISSION" : "EXAM";
                    if (examInfo.examTypeCd == "EXAM") {
                        html += '		<button type="button" class="ui basic small button ml5" type="button" onclick="event.stopPropagation(); moveListExam(\'ABSENT\')"><spring:message code="dashboard.absent" /></button>';	// 결시원
                        html += '		<button type="button" class="ui orange small button ml5" type="button" onclick="event.stopPropagation(); moveListExam(\'' + examType + '\')"><spring:message code="exam.label.exam.manage" /></button>';	// 시험관리
                    }
                    if (examInfo.examTypeCd == "QUIZ") {
                        html += '		<button type="button" class="ui basic small button ml5" type="button" onclick="event.stopPropagation(); moveListExam(\'' + examType + '\')"><spring:message code="exam.label.exam.manage" /></button>';	// 시험관리
                    } else if (examInfo.examTypeCd == "ASMNT") {
                        html += '		<button type="button" class="ui basic small button ml5" type="button" onclick="event.stopPropagation(); moveListExam(\'' + examType + '\')"><spring:message code="exam.label.exam.manage" /></button>';	// 시험관리
                    } else if (examInfo.examTypeCd == "FORUM") {
                        html += '		<button type="button" class="ui basic small button ml5" type="button" onclick="event.stopPropagation(); moveListExam(\'' + examType + '\')"><spring:message code="exam.label.exam.manage" /></button>';	// 시험관리
                    }
                    html += '    	</div>';
                    html += '    	<i class="angle down icon"></i>';
                    html += '	</div>'; // lect
                } else {
                    html += '	<div class="lect">';
                    html += '    	<div class="info">';
                    html += '    		<p class="lect_name"><span>' + convertWeekName(v.lessonScheduleNm) + '</span>';
                    html += '		      <span class="lectInfo">';
                    html += '			    <span class="ui small label state">' + lessonProgressNm + '</span>';
                    html += openYnHtml + ' <!--<small class="fwb fcDark9">' + lessonStartDtFmt + ' ~ ' + lessonEndDtFmt + '</small>-->';
                    html += '		      </span>';
                    html += '           </p>';

                    html += '    		<ul class="list_verticalline">';
                    html += '        		<li>';
                    //html += '					<small>수강</small>';
                    //html += '					<small>' + lessonStartDtFmt + ' ~ ' + lessonEndDtFmt + '</small>';
                    html += '					<small class=""><spring:message code="seminar.label.attend.approval.day" /> : ' + scheduleFrDt + ' ~ ' + scheduleToDt + '</small>';	// 출석인정 기간
                    html += '				</li>';
                    html += '        		<li>';
                    html += '            		<small>' + v.lbnTm + '<spring:message code="std.label.minute" /></small>';	// 분
                    html += '				</li>';
                    if (v.lessonScheduleProgress != "READY") {
                        html += '			<li class="lessonScheduleStatus" style="display:none">';
                        html += '				<small><spring:message code="lesson.label.study.status.complete" /></small>';		// 출석
                        html += '				<small id="lessonScheduleStatus1_' + v.lessonScheduleId + '">-<spring:message code="team.common.memberCnt" /></small>';	// 명
                        html += '			</li>';
                        html += '			<li class="lessonScheduleStatus" style="display:none">';
                        html += '				<small><spring:message code="lesson.label.study.status.late" /></small>';				// 지각
                        html += '				<small id="lessonScheduleStatus2_' + v.lessonScheduleId + '">-<spring:message code="team.common.memberCnt" /></small>';	// 명
                        html += '			</li>';
                        html += '			<li class="lessonScheduleStatus" style="display:none">';
                        html += '				<small><spring:message code="lesson.label.study.status.nostudy" /></small>';		// 결석
                        html += '				<small id="lessonScheduleStatus3_' + v.lessonScheduleId + '">-<spring:message code="team.common.memberCnt" /></small>';	// 명
                        html += '			</li>';
                    }
                    html += '			</ul>';
                    html += '		</div>'; // info
                    html += '		<div class="button-area">';
                    if (hasVideoCnts) {
                        html += '		<button type="button" class="ui basic small button" onclick="event.stopPropagation(); viewLesson(\'' + v.lessonScheduleId + '\', \'' + firstLessonTimeId + '\', 0); return false;" title="<spring:message code="lesson.label.view.lesson" />"><spring:message code="lesson.label.view.lesson" /></button>'; // 강의보기
                    }
                    if (v.ltNote && v.ltNoteOfferYn == "Y") {
                        html += '		<button type="button" class="ui purple small button" onclick="ltNoteDown(\'' + v.ltNote + '\', \'' + v.lessonScheduleOrder + '\')" title="<spring:message code="contents.label.lcture.note" />"><spring:message code="contents.label.lcture.note" /></button>';	// 강의노트
                    }

                    if (hasAttendAuth) {
                        if ((v.wekClsfGbn == "02" || v.wekClsfGbn == "03") && seminarId) {
                            html += '	<button type="button" class="ui darkblue small button" onclick="event.stopPropagation(); moveListSeminar(\'' + seminarId + '\'); return false;" title="<spring:message code="sch.seminar" /> <spring:message code="seminar.button.attend.manage" />"><spring:message code="sch.seminar" /> <spring:message code="seminar.button.attend.manage" /></button>';	// 출결관리
                        } else {
                            html += '	<button type="button" class="ui darkblue small button" onclick="event.stopPropagation(); attendManageModal(\'' + v.lessonScheduleId + '\'); return false;" title="<spring:message code="seminar.button.attend.manage" />"><spring:message code="seminar.button.attend.manage" /></button>';	// 출결관리
                        }
                    }
                    /*
                    if(v.lessonScheduleProgress == "READY") {
                        html += '		<button type="button" class="ui blue small button" onclick="event.stopPropagation(); lessonTimeWriteModal(\'' + v.lessonScheduleId + '\'); return false;" title="교시추가">교시추가</button>';
                    }
                     */
                    if (prevCourseYn != 'Y') {
                        html += '		<button type="button" class="ui grey small button plus elem-add-btn" onclick="event.stopPropagation(); viewElemBox(\'acc_' + v.lessonScheduleId + '\');" title="<spring:message code="lesson.label.lesson.cnts.write" />"><i class="ion-plus"></i></button>';	// 학습자료 추가
                    }
                    html += '    	</div>';
                    html += '    	<i class="angle down icon"></i>';
                    html += '	</div>'; // lect
                }
                html += '	</div>'; // title mainInfo
                html += '	<div data-acc-lesson-schedule-id="' + v.lessonScheduleId + '" class="content ui styled fluid itemExtraInfo ' + activeAccordionClass + '">';
                if (v.examStareTypeCd) {
                    html += createExamListHtml(examInfo);
                    //html += 	createLearnListHtml(v.studyElementMap, v);
                } else {
                    html += createLessonTimeListHtml(listLessonTime, v);
                    //html += 	createLearnListHtml(v.studyElementMap, v);
                }
                html += '	</div>'; // title mainInfo

                html += '</div>'; // ui accordion courseItem
                // 주차별 학습요소 리스트
                html += '<div>';
                html += createLearnListHtml(v.studyElementMap, v);
                html += '</div>';
            });
        }
        return html;
    }

    // 2.교시
    function createLessonTimeListHtml(listLessonTime, lessonScheduleInfo) {
        var prevCourseYn = '<c:out value="${prevCourseYn}" />';
        var html = '';

        if (listLessonTime && listLessonTime.length > 0) {
            var lessonTimeCnt = listLessonTime.length; // 총 교시 수

            listLessonTime.forEach(function (v, i) {
                var listLessonCnts = v.listLessonCnts || [];
                var stdyMethodNm = "";

                if (v.stdyMethod == "RND") {
                    stdyMethodNm = "<spring:message code='std.label.stdy_method_rnd' />";	// 랜덤학습
                } else if (v.stdyMethod == "SEQ") {
                    stdyMethodNm = "<spring:message code='std.label.stdy_method_seq' />";	// 순차학습
                }

                // 1교시 이상만 교시타이틀 생성
                if (lessonTimeCnt > 1) {
                    if (v.lessonTimeOrder > 1) {
                        html += '<div class="titleTemp">';
                        html += '	<div class="title_cont">';
                        html += '		<div class="left_cont">';
                        html += '			<div class="lectTit_box">';
                        //html += '				<p id="lessonTimeNmText_' + v.lessonTimeId + '" class="lect_name"><span>' + v.lessonTimeOrder + '<spring:message code="contents.label.lesson.cnts" /></span> ' + v.lessonTimeNm + '</p>';	// 교시
                        html += '				<p id="lessonTimeNmText_' + v.lessonTimeId + '" class="lect_name">' + v.lessonTimeNm + '</p>';	// 교시
                        html += '			</div>';
                        html += '		</div>';
                        if (v.lessonTimeOrder != 1 && prevCourseYn != 'Y') {
                            html += '	<div class="button-area mla">';
                            html += '		<div class="ui icon top right pointing dropdown" title="<spring:message code="contents.label.lesson.cnts.editing" />" tabindex="0">';	// 교시편집
                            html += '			<i class="xi-ellipsis-v"></i>';
                            html += '			<div class="menu" tabindex="-1">';
                            html += '				<button type="button" class="item" onclick="lessonTimeWriteModal(\'' + lessonScheduleInfo.lessonScheduleId + '\', \'' + v.lessonTimeId + '\')"><spring:message code="contents.label.lesson.cnts.fertilize" /></button>'; // 교시수정
                            html += '				<button type="button" class="item" onclick="removeLessonTime(\'' + lessonScheduleInfo.lessonScheduleId + '\', \'' + v.lessonTimeId + '\')"><spring:message code="contents.label.lesson.cnts.delete" /></button>'; // 교시삭제
                            html += '			</div>';
                            html += '		</div>';
                            html += '	</div>';
                        }
                        html += '	</div>';
                        html += '</div>';
                    }
                }
                html += createLessonCntsListHtml(listLessonCnts, v, lessonScheduleInfo);
            });
        }
        return html;
    }

    // 3. 학습콘텐츠
    function createLessonCntsListHtml(listLessonCnts, lessonTimeInfo, lessonScheduleInfo) {
        var prevCourseYn = '<c:out value="${prevCourseYn}" />';
        var html = '';

        if (listLessonCnts && listLessonCnts.length > 0) {
            listLessonCnts.forEach(function (v, i) {
                //var lessonStartDttmFmt = getDateFmt(lessonScheduleInfo.lessonStartDt);
                //var lessonEndDttmFmt = getDateFmt(lessonScheduleInfo.lessonEndDt);

                var seqHtml = '<div class="each_lect_box" data-list-num="-">';
                if (lessonTimeInfo.stdyMethod == "SEQ") {
                    seqHtml = '<div class="each_lect_box" data-list-num="' + v.lessonCntsOrder + '">';
                }

                html += '<div class="content active">';
                html += '	<ul class="each_lect_list">';
                html += '		<li>';
                html += seqHtml;
                html += '			<div class="each_lect_tit">';
                html += '				<p>';
                if (v.cntsGbn == "VIDEO" || v.cntsGbn == "VIDEO_LINK") {
                    html += '				<a href="javascript:void(0)" onclick="viewLesson(\'' + lessonScheduleInfo.lessonScheduleId + '\', \'' + lessonTimeInfo.lessonTimeId + '\', ' + i + ');" title="<spring:message code="lesson.label.view.lesson"/>">';
                    html += '					<span class="ui green small label">' + (v.cntsGbn == "VIDEO_LINK" ? "VIDEO" : v.cntsGbn) + '</span>'; // 강의
                    html += ' ' + v.lessonCntsNm;
                    html += '				</a>';
                } else {
                    html += '				<span class="ui green small label">' + (v.cntsGbn == "VIDEO_LINK" ? "VIDEO" : v.cntsGbn) + '</span>'; // 강의
                    html += ' ' + v.lessonCntsNm;
                }
                html += '				</p>';
                html += '				<p>';
                //html += '					<small class="bullet_dot">기간 : ' + lessonStartDttmFmt + ' ~ ' + lessonEndDttmFmt + '</small>';
                if (v.prgrYn == "Y") {
                    html += '				<small class="bullet_dot"><spring:message code="lesson.label.stdy.prgr.y" /></small>';	// 출결대상
                } else {
                    html += '				<small class="bullet_dot"><spring:message code="lesson.label.stdy.prgr.n" /></small>';	// 출결대상 아님
                }
                html += '				</p>';
                html += '			</div>';
                html += '			<div class="each_lect_desc">';
                html += '				<div class="button-area">';
                // 다운로드, 링크, 강의보기 버튼
                if (v.cntsGbn == "FILE" || v.cntsGbn == "PDF") {
                    html += '				<button type="button" class="ui basic small button" onclick="downLessonCnts(\'' + v.lessonCntsId + '\');" title="<spring:message code="button.download" />"><spring:message code="button.download" /></button>'; // 다운로드
                } else if (v.cntsGbn == "LINK" || (v.cntsGbn == "SOCIAL" && (v.lessonCntsUrl || "").indexOf("iframe") == -1)) {
                    html += '				<button type="button" class="ui basic small button" onclick="window.open(\'' + v.lessonCntsUrl + '\', \'_blank\')" title="<spring:message code="common.button.link" />"><spring:message code="common.button.link" /></button>'; // 링크
                } else {
                    if (v.cntsGbn == "VIDEO" || v.cntsGbn == "VIDEO_LINK") {
                        //html += '			<button type="button" class="ui basic small button" onclick="viewLesson(\'' + lessonScheduleInfo.lessonScheduleId + '\', \'' + lessonTimeInfo.lessonTimeId + '\', ' + i + ')"><spring:message code="lesson.label.view.lesson"/></button>'; // 강의보기
                    } else {
                        html += '			<button type="button" class="ui basic small button" onclick="viewLesson(\'' + lessonScheduleInfo.lessonScheduleId + '\', \'' + lessonTimeInfo.lessonTimeId + '\', ' + i + ')"><spring:message code="contents.label.learning" /></button>'; // 학습콘텐츠
                    }
                }
                if (prevCourseYn != 'Y') {
                    html += '				<div class="ui icon top right pointing dropdown" title="<spring:message code="contents.label.editing" />" tabindex="0" style="' + ((v.cntsGbn == "VIDEO_LINK" && LCDMS_LINK_YN == "Y") ? 'visibility: hidden' : '') + '">';	// 콘텐츠 편집
                    html += '					<i class="xi-ellipsis-v"></i>';
                    html += '					<div class="menu">';

                    if (v.cntsGbn != "VIDEO_LINK" || (v.cntsGbn == "VIDEO_LINK" && LCDMS_LINK_YN == "N")) {
                        html += '				<button type="button" class="item" onclick="lessonCntsWriteModal(\'' + lessonScheduleInfo.lessonScheduleId + '\', \'' + lessonTimeInfo.lessonTimeId + '\', \'' + v.lessonCntsId + '\')"><div class="item"><spring:message code="sys.button.modify" /></div></button>';	// 수정
                        html += '				<button type="button" class="item" onclick="removeLessonCnts(\'' + lessonScheduleInfo.lessonScheduleId + '\', \'' + v.lessonCntsId + '\')"><div class="item"><spring:message code="sys.button.delete" /></div></button>';	// 삭제
                    }

                    html += '					</div>';
                    html += '				</div>';
                }
                html += '				</div>';
                html += '			</div>';
                html += '		</li>';
                html += '	</ul>';
                html += '</div>';
            });
        }

        // 교시 세미나
        if (lessonTimeInfo.listSeminar.length > 0) {
            lessonTimeInfo.listSeminar.forEach(function (v, i) {
                var seminarStartDttmFmt = v.seminarStartDttm != undefined ? getDateFmt(v.seminarStartDttm) : "-";
                var seminarEndDttmFmt = v.seminarEndDttm != undefined ? getDateFmt(v.seminarEndDttm) : "-";
                var seminarTime = parseInt(v.seminarTime / 60) > 0 ? parseInt(v.seminarTime / 60) + "<spring:message code='date.time' />" + v.seminarTime % 60 + "<spring:message code='lesson.label.min' />" : v.seminarTime % 60 + "<spring:message code='lesson.label.min' />";

                if (v.seminarCtgrCd == "online" || v.seminarCtgrCd == "free") {
                    html += '<div class="content active">';
                    html += '	<ul class="each_lect_list">';
                    html += '		<li>';
                    html += '			<div class="each_lect_tit">';
                    html += '				<div class="ui blue button p20" onclick="seminarStart(\'' + v.seminarId + '\')">';
                    html += '					<i class="laptop icon f150"></i>';
                    html += '					<a class="tl fcWhite" href="javascript:void(0)"><spring:message code="seminar.label.webcam" /><br><spring:message code="seminar.label.webcam.begin" /></a>';	// 화상세미나 시작하기
                    html += '				</div>';
                    html += '			</div>';
                    html += '			<div class="ml30">';
                    html += '				<p><small class="bullet_dot"><spring:message code="seminar.label.seminar.nm" /> : ' + v.seminarNm + '</small></p>';			// 세미나명
                    html += '				<p><small class="bullet_dot"><spring:message code="seminar.label.start.date" /> : ' + seminarStartDttmFmt + '</small></p>';	// 시작일시
                    html += '				<p><small class="bullet_dot"><spring:message code="seminar.label.progress.time" /> : ' + seminarTime + '</small></p>';			// 진행시간
                    html += '			</div>';
                    html += '			<div class="mla mr20">';
                    html += '				<span class="ui blue small label pl10 pr10 seminarStatus1_' + v.seminarId + '"></span>';
                    html += '				<span class="ui yellow small label pl10 pr10 seminarStatus2_' + v.seminarId + '"></span>';
                    html += '				<span class="ui grey small label pl10 pr10 seminarStatus3_' + v.seminarId + '"></span>';
                    html += '				<button type="button" class="ui basic small button" onclick="moveListSeminar(\'' + v.seminarId + '\')"><spring:message code="sch.seminar" /><spring:message code="seminar.button.attend.manage" /></button>';	// 세미나 출결관리
                    html += '			</div>';
                    html += '		</li>';
                    html += '	</ul>';
                    html += '</div>';
                } else if (v.seminarCtgrCd == "offline") {
                    html += '<div class="content active">';
                    html += '	<ul class="each_lect_list">';
                    html += '		<li>';
                    html += '			<div class="each_lect_box" data-list-num="-">';
                    html += '				<div class="each_lect_tit">';
                    html += '					<p>';
                    html += '						<a href="javascript:moveListSeminar(\'' + v.seminarId + '\')">';
                    html += '							<span class="ui deepblue1 small label"><spring:message code="sch.seminar" /></span>';	// 세미나
                    html += '							' + v.seminarNm;
                    html += '						</a>';
                    html += '                   </p>';
                    html += '                   <p>';
                    html += '                       <small class="bullet_dot"><spring:message code="exam.label.period" /> : ' + seminarStartDttmFmt + ' ~ ' + seminarEndDttmFmt + '</small>';	// 기간
                    html += '                   </p>';
                    html += '               </div>';
                    if (lessonScheduleInfo.openYn == "Y") {
                        html += '			<div class="list_verticalline">';
                        html += '				<small class="seminarStatus1_' + v.seminarId + '"><spring:message code="lesson.label.study.status.complete" /> : -</small>';	// 출석
                        html += '				<small class="seminarStatus2_' + v.seminarId + '"><spring:message code="lesson.label.study.status.late" /> : -</small>';			// 지각
                        html += '				<small class="seminarStatus3_' + v.seminarId + '"><spring:message code="lesson.label.study.status.nostudy" /> : -</small>';	// 결석
                        html += '			</div>';
                    }
                    html += '				<div class="each_lect_desc">';
                    html += '					<div class="button-area">';
                    html += '						<button type="button" class="ui basic small button" onclick="moveListSeminar(\'' + v.seminarId + '\')"><spring:message code="sch.seminar" /><spring:message code="seminar.button.attend.manage" /></button>'; // 세미나 출결관리
                    html += '						<div class="ui icon top right pointing dropdown" title="<spring:message code="seminar.label.seminar.editing" />" tabindex="0">';	// 세미나편집
                    html += '							<i class="xi-ellipsis-v"></i>';
                    html += '                       	<div class="menu" tabindex="-1">';
                    html += '                           	<button type="button" class="item" onclick="moveEditSeminar(\'' + v.seminarId + '\')"><spring:message code="sys.button.modify" /></button>';		// 수정
                    html += '                           	<button type="button" class="item" onclick="moveRemoveSeminar(\'' + v.seminarId + '\')"><spring:message code="sys.button.delete" /></button>';	// 삭제
                    html += '							</div>';
                    html += '						</div>';
                    html += '					</div>';
                    html += '				</div>';
                    html += '			</div>';
                    html += '		</li>';
                    html += '	</ul>';
                    html += '</div>';
                }
            });
        }

        // 학습요소 추가 버튼 모음
        if (prevCourseYn != 'Y') {
            html += createResourceBtnHtml(lessonScheduleInfo.lessonScheduleId, lessonTimeInfo.lessonTimeId);
        }
        return html;
    }

    // 주차별 학습할것 목록
    function createLearnListHtml(studyElementMap, lessonScheduleInfo) {
        var prevCourseYn = '<c:out value="${prevCourseYn}" />';
        var tmpOrderObj = {
            "AEXAM": true
            , "ASMNT": true
            , "FORUM": true
            , "QUIZ": true
            , "RESCH": true
            , "SEMINAR": true
        };

        var html = '<div class="">';

        Object.keys(tmpOrderObj).forEach(function (key, i) {
            if (key == "AEXAM") {
                studyElementMap.listCrsHomeAExam.forEach(function (v, i) {
                    var examStartDttmFmt = getDateFmt(v.examStartDttm);
                    var examEndDttmFmt = getDateFmt(v.examEndDttm);
                    var examType = v.examStareTypeCd == "A" ? "ADMISSION" : "EXAM";

                    html += '<div class="content active">';
                    html += '	<ul class="each_lect_list">';
                    html += '   	<li>';
                    html += '       	<div class="each_lect_box" data-list-num="-">';
                    html += '           	<div class="each_lect_tit">';
                    html += '               	<p>';
                    html += '                   	<span class="ui brown small label"><spring:message code="crs.label.nomal_exam" /></span>';	// 수시평가
                    html += '                       <a href="javascript:moveDetailExam(\'' + examType + '\', \'' + v.examCd + '\')">' + v.examTitle + '</a>';
                    html += '                   </p>';
                    html += '                   <p>';
                    html += '                       <small class="bullet_dot"><spring:message code="exam.label.period" /> : ' + examStartDttmFmt + ' ~ ' + examEndDttmFmt + '</small>';	// 기간
                    html += '                   </p>';
                    html += '               </div>';
                    if (lessonScheduleInfo.openYn == "Y") {
                        html += '			<div class="list_verticalline">';
                        html += '				<small class="aExamStatus1_' + v.examCd + '"><spring:message code="crs.label.join" /> : -</small>';		// 응시
                        html += '               <small class="aExamStatus2_' + v.examCd + '"><spring:message code="crs.label.no.join" /> : -</small>';	// 미응시
                        html += '			</div>';
                    }
                    html += '				<div class="each_lect_desc">';
                    html += '               	<div class="button-area">';
                    html += '	                	<button type="button" class="ui basic small button" onclick="moveListExam(\'' + examType + '\')"><spring:message code="exam.label.exam.manage" /></button>';
                    if (prevCourseYn != 'Y') {
                        html += '                   <div class="ui icon top right pointing dropdown" title="<spring:message code="exam.label.exam.editing" />" tabindex="0">';
                        html += '                       <i class="xi-ellipsis-v"></i>';
                        html += '                       <div class="menu" tabindex="-1">';
                        html += '                           <button type="button" class="item" onclick="moveEditExam(\'' + v.examCd + '\', \'' + v.examStareTypeCd + '\')"><spring:message code="sys.button.modify" /></button>';	// 수정
                        html += '                           <button type="button" class="item" onclick="moveRemoveAExam(\'' + v.examCd + '\', \'' + examType + '\')"><spring:message code="sys.button.delete" /></button>'; // 삭제
                        html += '                       </div>';
                        html += '               	</div>';
                    }
                    html += '           		</div>';
                    html += '       		</div>';
                    html += '       	</div>';
                    html += '   	</li>';
                    html += '	</ul>';
                    html += '</div>';
                });
            } else if (key == "ASMNT") {
                studyElementMap.listCrsHomeAsmnt.forEach(function (v, i) {
                    var open = '<spring:message code="message.open" />';			// 공개
                    var privates = '<spring:message code="message.private" />';	// 비공개
                    var sendStartDttmFmt = getDateFmt(v.sendStartDttm);
                    var asmntEndDttmFmt = getDateFmt(v.asmntEndDttm);

                    var scoreOpenYnText = v.scoreOpenYn == "Y" ? open : privates;

                    html += '<div class="content active">';
                    html += '	<ul class="each_lect_list">';
                    html += '   	<li>';
                    html += '       	<div class="each_lect_box" data-list-num="-">';
                    html += '           	<div class="each_lect_tit">';
                    html += '               	<p>';
                    html += '                   	<span class="ui pink small label"><spring:message code="filemgr.label.crsauth.asmt" /></span>';	// 과제
                    html += '                       <a href="javascript:moveDetailAsmnt(\'' + v.asmntCd + '\')">' + v.asmntTitle + '</a>';
                    html += '                   </p>';
                    html += '                   <p>';
                    html += '                       <small class="bullet_dot"><spring:message code="exam.label.period" /> : ' + sendStartDttmFmt + ' ~ ' + asmntEndDttmFmt + '</small>';	// 기간
                    html += '					    <small class="bullet_dot"><spring:message code="asmnt.label.grade" />	 : ' + scoreOpenYnText + '</small>';	// 성적
                    html += '                   </p>';
                    html += '               </div>';
                    if (lessonScheduleInfo.openYn == "Y") {
                        html += '			<div class="list_verticalline">';
                        html += '           	<small class="asmntStatus1_' + v.asmntCd + '"><spring:message code="std.label.asmnt_submit" /> : -</small>';			// 제출
                        html += '               <small class="asmntStatus2_' + v.asmntCd + '"><spring:message code="std.label.late" /> : -</small>';						// 지각
                        html += '               <small class="asmntStatus3_' + v.asmntCd + '"><spring:message code="std.label.asmnt_nosubmit" /> : -</small>';	// 미제출
                        html += '           </div>';
                    }
                    html += '				<div class="each_lect_desc">';
                    html += '               	<div class="button-area">';
                    html += '	                	<button type="button" class="ui basic small button" onclick="moveListAsmnt()"><spring:message code="asmnt.button.asmnt.manage" /></button>';	// 과제관리
                    if (prevCourseYn != 'Y') {
                        html += '                   <div class="ui icon top right pointing dropdown" title="<spring:message code="asmnt.button.asmnt.editing" />" tabindex="0">'; // 과제편집
                        html += '                       <i class="xi-ellipsis-v"></i>';
                        html += '                       <div class="menu" tabindex="-1">';
                        html += '                           <button type="button" class="item" onclick="moveEditAsmnt(\'' + v.asmntCd + '\')"><spring:message code="sys.button.modify" /></button>';		// 수정
                        html += '                          	<button type="button" class="item" onclick="moveRemoveAsmnt(\'' + v.asmntCd + '\')"><spring:message code="sys.button.delete" /></button>';	// 삭제
                        html += '                       </div>';
                        html += '                   </div>';
                    }
                    html += '               	</div>';
                    html += '           	</div>';
                    html += '           </div>';
                    html += '   		</li>';
                    html += '	</ul>';
                    html += '</div>';
                });
            } else if (key == "FORUM") {
                studyElementMap.listCrsHomeForum.forEach(function (v, i) {
                    var open = '<spring:message code="message.open" />';			// 공개
                    var privates = '<spring:message code="message.private" />';	// 비공개

                    var forumStartDttmFmt = getDateFmt(v.forumStartDttm);
                    var forumEndDttmFmt = getDateFmt(v.forumEndDttm);

                    var scoreOpenYnText = v.scoreOpenYn == "Y" ? open : privates;

                    html += '<div class="content active">';
                    html += '	<ul class="each_lect_list">';
                    html += '   	<li>';
                    html += '       	<div class="each_lect_box" data-list-num="-">';
                    html += '           	<div class="each_lect_tit">';
                    html += '               	<p>';
                    html += '                   	<span class="ui purple small label"><spring:message code="common.label.discussion" /></span>';	// 토론
                    html += '                       <a href="javascript:moveDetailForum(\'' + v.forumCd + '\')">' + v.forumTitle + '</a>';
                    html += '                   </p>';
                    html += '                   <p>';
                    html += '                       <small class="bullet_dot"><spring:message code="exam.label.period" /> : ' + forumStartDttmFmt + ' ~ ' + forumEndDttmFmt + '</small>';	// 기간
                    html += '					    <small class="bullet_dot"><spring:message code="asmnt.label.grade" /> : ' + scoreOpenYnText + '</small>';	// 성적
                    html += '                   </p>';
                    html += '               </div>';
                    if (lessonScheduleInfo.openYn == "Y") {
                        html += '			<div class="list_verticalline">';
                        html += '           	<small class="forumStatus1_' + v.forumCd + '"><spring:message code="crs.label.atnd" /> : -</small>';	// 참여
                        html += '               <small class="forumStatus2_' + v.forumCd + '"><spring:message code="crs.label.no.atnd" /> : -</small>';	// 미참여
                        html += '			</div>';
                    }

                    html += '				<div class="each_lect_desc">';
                    html += '               	<div class="button-area">';
                    html += '	                	<button type="button" class="ui basic small button" onclick="moveListForum()"><spring:message code="forum.label.forum.manage" /></button>';	// 토론관리
                    if (prevCourseYn != 'Y') {
                        html += '                   <div class="ui icon top right pointing dropdown" title="<spring:message code="forum.label.forum.editing" />" tabindex="0">';	// 토론편집
                        html += '                       <i class="xi-ellipsis-v"></i>';
                        html += '                       <div class="menu" tabindex="-1">';
                        html += '                          	<button type="button" class="item" onclick="moveEditForum(\'' + v.forumCd + '\')"><spring:message code="sys.button.modify" /></button>';		// 수정
                        html += '                          	<button type="button" class="item" onclick="moveRemoveForum(\'' + v.forumCd + '\')"><spring:message code="sys.button.delete" /></button>';	// 삭제
                        html += '                       </div>';
                        html += '               	</div>';
                    }
                    html += '           		</div>';
                    html += '       		</div>';
                    html += '       	</div>';
                    html += '   	</li>';
                    html += '	</ul>';
                    html += '</div>';
                });
            } else if (key == "QUIZ") {
                studyElementMap.listCrsHomeQuiz.forEach(function (v, i) {
                    var open = '<spring:message code="message.open" />';	// 공개
                    var privates = '<spring:message code="message.private" />';	// 비공개
                    var examStartDttmFmt = getDateFmt(v.examStartDttm);
                    var examEndDttmFmt = getDateFmt(v.examEndDttm);

                    var scoreOpenYnText = v.scoreOpenYn == "Y" ? open : privates;

                    html += '<div class="content active">';
                    html += '	<ul class="each_lect_list">';
                    html += '		<li>';
                    html += '			<div class="each_lect_box" data-list-num="-">';
                    html += '				<div class="each_lect_tit">';
                    html += '					<p>';
                    html += '						<span class="ui orange small label"><spring:message code="std.label.quiz" /></span>';	// 퀴즈
                    html += '                       <a href="javascript:moveDetailQuiz(\'' + v.examCd + '\')">' + v.examTitle + '</a>';
                    html += '                   </p>';
                    html += '                   <p>';
                    html += '                       <small class="bullet_dot"><spring:message code="exam.label.period" /> : ' + examStartDttmFmt + ' ~ ' + examEndDttmFmt + '</small>';	// 기간
                    html += '					    <small class="bullet_dot"><spring:message code="asmnt.label.grade" /> : ' + scoreOpenYnText + '</small>';	// 성적
                    html += '                   </p>';
                    html += '               </div>';
                    if (lessonScheduleInfo.openYn == "Y") {
                        html += '			<div class="list_verticalline">';
                        html += '				<small class="quizStatus1_' + v.examCd + '"><spring:message code="crs.label.atnd" /> : -</small>';					// 참여
                        html += '				<small class="quizStatus2_' + v.examCd + '"><spring:message code="common.label.reexam" /> : -</small>';	// 재시험
                        html += '				<small class="quizStatus3_' + v.examCd + '"><spring:message code="crs.label.no.atnd" /> : -</small>';			// 미참여
                        html += '			</div>';
                    }
                    html += '				<div class="each_lect_desc">';
                    html += '					<div class="button-area">';
                    html += '						<button type="button" class="ui basic small button" onclick="moveListQuiz()"><spring:message code="exam.label.subs.quiz.manage" /></button>';	// 퀴즈
                    if (prevCourseYn != 'Y') {
                        html += '					<div class="ui icon top right pointing dropdown" title="<spring:message code="exam.label.subs.quiz.editing" />" tabindex="0">'; // 퀴즈편집
                        html += '                       <i class="xi-ellipsis-v"></i>';
                        html += '						<div class="menu" tabindex="-1">';
                        html += '                       	<button type="button" class="item" onclick="moveEditQuiz(\'' + v.examCd + '\')"><spring:message code="sys.button.modify" /></button>';	// 수정
                        html += '                          	<button type="button" class="item" onclick="moveRemoveQuiz(\'' + v.examCd + '\')"><spring:message code="sys.button.delete" /></button>'; // 삭제
                        html += '						</div>';
                        html += '					</div>';
                    }
                    html += '					</div>';
                    html += '				</div>';
                    html += '			</div>';
                    html += '		</li>';
                    html += '	</ul>';
                    html += '</div>';
                });
            } else if (key == "RESCH") {
                studyElementMap.listCrsHomeResch.forEach(function (v, i) {
                    var reschStartDttmFmt = getDateFmt(v.reschStartDttm);
                    var reschEndDttmFmt = getDateFmt(v.reschEndDttm);

                    html += '<div class="content active">';
                    html += '	<ul class="each_lect_list">';
                    html += '		<li>';
                    html += '			<div class="each_lect_box" data-list-num="-">';
                    html += '				<div class="each_lect_tit">';
                    html += '					<p>';
                    html += '						<span class="ui deepblue1 small label"><spring:message code="resh.label.resh" /></span>';	// 설문
                    html += '						<a href="javascript:moveDetailResch(\'' + v.reschCd + '\')">' + v.reschTitle + '</a>';
                    html += '                   </p>';
                    html += '                   <p>';
                    html += '                       <small class="bullet_dot"><spring:message code="exam.label.period" /> : ' + reschStartDttmFmt + ' ~ ' + reschEndDttmFmt + '</small>';	// 기간
                    html += '					    <small class="bullet_dot"><spring:message code="resh.label.resh.result" /> : ' + v.reschRsltTypeNm + '</small>';	// 설문결과
                    html += '                   </p>';
                    html += '               </div>';
                    if (lessonScheduleInfo.openYn == "Y") {
                        html += '			<div class="list_verticalline">';
                        html += '				<small class="reschStatus1_' + v.reschCd + '"><spring:message code="crs.label.atnd" /> : -</small>';	// 참여
                        html += '				<small class="reschStatus2_' + v.reschCd + '"><spring:message code="crs.label.no.atnd" /> : -</small>';	// 미참여
                        html += '			</div>';
                    }
                    html += '				<div class="each_lect_desc">';
                    html += '					<div class="button-area">';
                    html += '						<button type="button" class="ui basic small button" onclick="moveListResch()"><spring:message code="common.label.resh.manage" /></button>';	// 설문관리
                    if (prevCourseYn != 'Y') {
                        html += '					<div class="ui icon top right pointing dropdown" title="<spring:message code="common.label.resh.editing" />" tabindex="0">';	// 설문편집
                        html += '						<i class="xi-ellipsis-v"></i>';
                        html += '                       <div class="menu" tabindex="-1">';
                        html += '                          	<button type="button" class="item" onclick="moveEditResch(\'' + v.reschCd + '\')"><spring:message code="sys.button.modify" /></button>';	// 수정
                        html += '                          	<button type="button" class="item" onclick="moveRemoveResch(\'' + v.reschCd + '\')"><spring:message code="sys.button.delete" /></button>';	// 삭제
                        html += '						</div>';
                        html += '					</div>';
                    }
                    html += '					</div>';
                    html += '				</div>';
                    html += '			</div>';
                    html += '		</li>';
                    html += '	</ul>';
                    html += '</div>';
                });
            } else if (key == "SEMINAR") {
                studyElementMap.listCrsHomeSeminar.forEach(function (v, i) {
                    // 교시에 속하지 않은 세미나만 출력
                    if (v.lessonTimeId != "") {
                        return;
                    }
                    var seminarStartDttmFmt = getDateFmt(v.seminarStartDttm);
                    var seminarEndDttmFmt = getDateFmt(v.seminarEndDttm);
                    var seminarTime = parseInt(v.seminarTime / 60) > 0 ? parseInt(v.seminarTime / 60) + "<spring:message code='seminar.label.time' />" + v.seminarTime % 60 + "<spring:message code='seminar.label.min' />" : v.seminarTime % 60 + "<spring:message code='seminar.label.min' />";

                    if (v.seminarCtgrCd == "online") {
                        html += '<div class="content active">';
                        html += '	<ul class="each_lect_list">';
                        html += '		<li>';
                        html += '			<div class="each_lect_tit">';
                        html += '				<div class="ui blue button p20" onclick="seminarStart(\'' + v.seminarId + '\')">';
                        html += '					<i class="laptop icon f150"></i>';
                        html += '					<a class="tl fcWhite" href="javascript:void(0)"><spring:message code="seminar.label.webcam" /><br><spring:message code="forum.button.forum.join" /></a>';	// 화상세미나 참여하기
                        html += '				</div>';
                        html += '			</div>';
                        html += '			<div class="ml30">';
                        html += '				<p><small class="bullet_dot"><spring:message code="seminar.label.seminar.nm" /> : ' + v.seminarNm + '</small></p>';			// 세미나명
                        html += '				<p><small class="bullet_dot"><spring:message code="seminar.label.start.date" /> : ' + seminarStartDttmFmt + '</small></p>';	// 시작일시
                        html += '				<p><small class="bullet_dot"><spring:message code="seminar.label.progress.time" /> : ' + seminarTime + '</small></p>';			// 진행시간
                        html += '			</div>';
                        html += '			<div class="mla mr20">';
                        html += '				<span class="ui blue small label pl10 pr10 seminarStatus1_' + v.seminarId + '"></span>';
                        html += '				<span class="ui yellow small label pl10 pr10 seminarStatus2_' + v.seminarId + '"></span>';
                        html += '				<span class="ui grey small label pl10 pr10 seminarStatus3_' + v.seminarId + '"></span>';
                        html += '				<button type="button" class="ui basic small button" onclick="moveListSeminar(\'' + v.seminarId + '\')"><spring:message code="sch.seminar" /><spring:message code="seminar.button.attend.manage" /></button>'; // 세미나 출결관리
                        html += '			</div>';
                        html += '		</li>';
                        html += '	</ul>';
                        html += '	<div class="bcBlueAlpha15 mt15 p10">';
                        html += '		<p><spring:message code="seminar.message.zoom.info1" /></p>';	/* [중요] 반드시 Zoom Meeting 프로그램을 실행하여 참가해 주세요. */
                        html += '		<p class="fcRed"><spring:message code="seminar.message.zoom.info2" /></p>';	/* Zoom 프로그램이 아닌 브라우저 상의"브라우저에서 참가"를 클릭하여 입장한 경우에는 출결이 기록되지 않습니다. */
                        html += '	</div>';
                        html += '</div>';
                    } else if (v.seminarCtgrCd == "offline") {
                        html += '<div class="content active">';
                        html += '	<ul class="each_lect_list">';
                        html += '		<li>';
                        html += '			<div class="each_lect_box" data-list-num="-">';
                        html += '				<div class="each_lect_tit">';
                        html += '					<p>';
                        html += '						<span class="ui deepblue1 small label">세미나</span>';
                        html += '						<a href="javascript:moveListSeminar(\'' + v.seminarId + '\')">' + v.seminarNm + '</a>';
                        html += '                   </p>';
                        html += '                   <p>';
                        html += '                       <small class="bullet_dot"><spring:message code="exam.label.period" /> : ' + seminarStartDttmFmt + ' ~ ' + seminarEndDttmFmt + '</small>';
                        html += '                   </p>';
                        html += '               </div>';
                        if (lessonScheduleInfo.openYn == "Y") {
                            html += '			<div class="list_verticalline">';
                            html += '				<small class="seminarStatus1_' + v.seminarId + '"><spring:message code="lesson.label.study.status.complete" /> : -</small>';	// 출석
                            html += '				<small class="seminarStatus2_' + v.seminarId + '"><spring:message code="lesson.label.study.status.late" /> : -</small>';	// 지각
                            html += '				<small class="seminarStatus3_' + v.seminarId + '"><spring:message code="lesson.label.study.status.nostudy" /> : -</small>';	// 결석
                            html += '			</div>';
                        }
                        html += '				<div class="each_lect_desc">';
                        html += '					<div class="button-area">';
                        html += '						<button type="button" class="ui basic small button" onclick="moveListSeminar(\'' + v.seminarId + '\')"><spring:message code="seminar.button.seminar.manage" /></button>';	// 세미나 관리
                        if (prevCourseYn != 'Y') {
                            html += '					<div class="ui icon top right pointing dropdown" title="<spring:message code="seminar.button.seminar.editing" />" tabindex="0">'; // 세미나편집
                            html += '						<i class="xi-ellipsis-v"></i>';
                            html += '                       <div class="menu" tabindex="-1">';
                            html += '                           <button type="button" class="item" onclick="moveEditSeminar(\'' + v.seminarId + '\')"><spring:message code="sys.button.modify" /></button>';	// 수정
                            html += '                          	<button type="button" class="item" onclick="moveRemoveSeminar(\'' + v.seminarId + '\')"><spring:message code="sys.button.delete" /></button>';	// 삭제
                            html += '						</div>';
                            html += '					</div>';
                        }
                        html += '					</div>';
                        html += '				</div>';
                        html += '			</div>';
                        html += '		</li>';
                        html += '	</ul>';
                        html += '</div>';
                    }
                });
            }
        });
        html += '</div>';

        return html;
    }

    // 시험 상세 정보
    function createExamListHtml(examInfo) {
        var examStartDttmFmt;
        var examEndDttmFmt;

        var examLabel = '';
        var title = '';
        var subTitle = '';
        var scoreOpenYnText = '';
        var examBtnNm = '';
        var examText = '';

        var html = '';

        // 1.실시간시험 || 시험(퀴즈, 과제, 토론)
        if (examInfo.examTypeCd == "EXAM" || examInfo.examTypeCd == "QUIZ" || examInfo.examTypeCd == "ASMNT" || examInfo.examTypeCd == "FORUM" || examInfo.examTypeCd == "ETC") {

            // 실시간시험
            if (examInfo.examTypeCd == "EXAM") {
                examStartDttmFmt = getDateFmt(examInfo.examStartDttm);
                examEndDttmFmt = getDateFmt(examInfo.examEndDttm);

                examLabel = "<spring:message code='filemgr.label.crsauth.exam' />";	// 시험
                title = examInfo.examTitle;
                subTitle = examInfo.examStareTm + "<spring:message code='seminar.label.min' />";	// 분
                examBtnNm = "<spring:message code='exam.label.exam.manage' />";	// 시험관리
                /* 실시간 시험 준비중 (3주차 중 발표 예정) */
                examText = "<spring:message code='crs.label.live.exam' /> <spring:message code='common.ready' />(3<spring:message code='common.schedule.now' /> <spring:message code='common.announce.schedule' />)";
            }
            // 시험 퀴즈
            else if (examInfo.examTypeCd == "QUIZ") {
                examStartDttmFmt = getDateFmt(examInfo.examQuizStartDttm);
                examEndDttmFmt = getDateFmt(examInfo.examQuizEndDttm);

                examLabel = "<spring:message code='exam.label.exam.quiz' />";		// 시험퀴즈
                title = examInfo.examQuizTitle;
                subTitle = examInfo.examStareTm + "<spring:message code='seminar.label.min' />";	// 분
                examBtnNm = "<spring:message code='exam.label.subs.quiz.manage' />";	// 퀴즈관리
            }
            // 시험 과제
            else if (examInfo.examTypeCd == "ASMNT") {

                var open = '<spring:message code="message.open" />';	// 공개
                var privates = '<spring:message code="message.private" />';	// 비공개
                examStartDttmFmt = getDateFmt(examInfo.examAsmntSendStartDttm);
                examEndDttmFmt = getDateFmt(examInfo.examAsmntSendEndDttm);

                scoreOpenYnText = examInfo.examAsmntScoreOpenYn == "Y" ? open : privates;
                examLabel = "<spring:message code='exam.label.exam.asmnt' />";	// 시험과제
                title = examInfo.examAsmntTitle;
                subTitle = '<spring:message code="common.label.score" /> :' + scoreOpenYnText;	// 성적
                examBtnNm = "<spring:message code='asmnt.button.asmnt.manage' />";	// 과제관리
            }
            // 시험 토론
            else if (examInfo.examTypeCd == "FORUM") {

                var open = '<spring:message code="message.open" />';	// 공개
                var privates = '<spring:message code="message.private" />';	// 비공개
                examStartDttmFmt = getDateFmt(examInfo.examForumStartDttm);
                examEndDttmFmt = getDateFmt(examInfo.examForumEndDttm);

                scoreOpenYnText = examInfo.examForumScoreOpenYn == "Y" ? open : privates;

                examLabel = "<spring:message code='forum.label.type.exam' />";	// 시험토론
                title = examInfo.examForumTitle;
                subTitle = '<spring:message code="common.label.score" /> :' + scoreOpenYnText;	// 성적
                examBtnNm = "<spring:message code='forum.label.forum.manage' />";	// 토론관리
            }
            // 기타
            else if (examInfo.examTypeCd == "ETC") {

                examLabel = "<spring:message code='resh.label.etc' />";	// 기타
                title = examInfo.examTitle;
                examText = "<spring:message code='resh.label.etc' />(<spring:message code='common.ready' />)"; // 기타 (준비중)
            }
            // 비중 없을 때
            if (examInfo.scoreRatio == 0) {
                examText = "-";
            }

            html += '<div class="content active">';
            html += '	<ul class="each_lect_list">';
            html += '		<li>';
            html += '			<div class="each_lect_box" data-list-num="-">';
            html += '				<div class="each_lect_tit">';
            html += '					<p>';
            html += '						<span class="ui teal small label mr5">' + examLabel + '</span>';
            html += title;
            html += '					</p>';
            html += '					<p>';
            if (examInfo.scoreRatio == 0 || examInfo.examStartDttm == undefined) {
                html += '						<small class="bullet_dot">' + examText + '</small>';
            } else {
                html += '						<small class="bullet_dot"><spring:message code="exam.label.period" /> : ' + examStartDttmFmt + ' ~ ' + examEndDttmFmt + '</small>';	// 기간
                html += '						<small class="bullet_dot">' + subTitle + '</small>';
            }
            html += '					</p>';
            html += '				</div>';
            html += '				<div class="button-area">';
            if (examInfo.scoreRatio != 0 && examInfo.examStartDttm != undefined) {
                html += '					<button type="button" class="ui basic small button" onclick="moveListExam(\'EXAM\')">' + examBtnNm + '</button>';
            }
            html += '				</div>';
            html += '			</div>';
            html += '		</li>';
            html += '	</ul>';
            html += '</div>';

            // 2.대체시험 (퀴즈, 과제, 토론)
            if (examInfo.examTypeCd == "EXAM" && (examInfo.examQuizCd || examInfo.examAsmntCd || examInfo.examForumCd)) {
                if (examInfo.examQuizCd) {
                    var open = '<spring:message code="message.open" />';	// 공개
                    var privates = '<spring:message code="message.private" />';	// 비공개
                    examStartDttmFmt = getDateFmt(examInfo.examQuizStartDttm);
                    examEndDttmFmt = getDateFmt(examInfo.examQuizEndDttm);

                    scoreOpenYnText = examInfo.examQuizScoreOpenYn == "Y" ? open : privates;

                    examLabel = "<spring:message code='exam.label.subs.quiz' />";	// 대체퀴즈
                    title = examInfo.examQuizTitle;
                    subTitle = '<spring:message code="common.label.score" /> : ' + scoreOpenYnText;	// 성적
                    examBtnNm = '<spring:message code="exam.label.subs.quiz.manage" />';	// 퀴즈관리

                } else if (examInfo.examAsmntCd) {
                    var open = '<spring:message code="message.open" />';	// 공개
                    var privates = '<spring:message code="message.private" />';	// 비공개
                    examStartDttmFmt = getDateFmt(examInfo.examAsmntSendStartDttm);
                    examEndDttmFmt = getDateFmt(examInfo.examAsmntSendEndDttm);

                    scoreOpenYnText = examInfo.examAsmntScoreOpenYn == "Y" ? open : privates;

                    examLabel = "<spring:message code='asmnt.label.subs.asmnt' />";	// 대체과제
                    title = examInfo.examAsmntTitle;
                    subTitle = '<spring:message code="common.label.score" /> : ' + scoreOpenYnText;
                    examBtnNm = '<spring:message code="asmnt.button.asmnt.manage" />';	// 과제관리

                } else if (examInfo.examForumCd) {

                    var open = '<spring:message code="message.open" />';	// 공개
                    var privates = '<spring:message code="message.private" />';	// 비공개
                    examStartDttmFmt = getDateFmt(examInfo.examForumStartDttm);
                    examEndDttmFmt = getDateFmt(examInfo.examForumEndDttm);

                    scoreOpenYnText = examInfo.examForumScoreOpenYn == "Y" ? open : privates;

                    examLabel = '<spring:message code="forum.label.type.subs" />';	// 대체토론
                    title = examInfo.examForumTitle;
                    subTitle = '<spring:message code="common.label.score" /> : ' + scoreOpenYnText;
                    examBtn = '<spring:message code="forum.label.forum.manage" />';// 토론관리
                }

                html += '<div class="content active">';
                html += '	<ul class="each_lect_list">';
                html += '		<li>';
                html += '			<div class="each_lect_box" data-list-num="-">';
                html += '				<div class="each_lect_tit">';
                html += '					<p>';
                html += '						<span class="ui teal small label mr5">' + examLabel + '</span>';
                html += title;
                html += '					</p>';
                html += '					<p>';
                html += '						<small class="bullet_dot"><spring:message code="exam.label.period" /> : ' + examStartDttmFmt + ' ~ ' + examEndDttmFmt + '</small>';	// 기간
                html += '						<small class="bullet_dot">' + subTitle + '</small>';
                if (examInfo.examQuizCd) {
                    html += '					<small class="bullet_dot">' + examInfo.examQuizExamStareTm + '분</small>';
                }
                html += '					</p>';
                html += '				</div>';
                html += '				<div class="button-area">';
                html += '					<button type="button" class="ui basic small button" onclick="moveListExam(\'EXAM\')">' + examBtnNm + '</button>';
                html += '				</div>';
                html += '			</div>';
                html += '		</li>';
                html += '	</ul>';
                html += '</div>';
            }
        } else if (examInfo.examTypeCd == undefined) {
            html += '<div class="content active">';
            html += '	<ul class="each_lect_list">';
            html += '		<li>';
            html += '			<div class="each_lect_box" data-list-num="-">';
            html += '				<div class="each_lect_tit">';
            html += '					<p class="fcDark9"><spring:message code="exam.label.empty.exam" /><!-- 등록된 시험 정보가 없습니다. --></p>';
            html += '				</div>';
            html += '			</div>';
            html += '		</li>';
            html += '	</ul>';
            html += '</div>';
        }
        return html;
    }

    // 학습요소 추가 버튼
    function createResourceBtnHtml(lessonScheduleId, lessonTimeId) {
        var html = '';

        html += '<div><div class="content active pt0 add-elem-box" style="display:none">';
        html += '	<ul class="each_lect_list">';
        html += '		<li class="gap8 p0">';
        html += '			<div class="ui message basic col-12 p0 flex  flex-wrap button-list">';
        html += '				<div class="header flex bcBlue p4 desktop-elem">';
        html += '					<div class="flex flex-column tc p5">';
        //html += '						<i class="sort amount down icon"></i>';
        html += '						<small><spring:message code="exam.button.add" /></small>';	// 추가
        html += '					</div>';
        html += '				</div>';
        html += '				<div class="contents flex flex-wrap">';
        html += '					<div class="flex flex-wrap columngap4 p8 col-7">';
        html += '						<div class="col-12 p0"><small class="opacity7 fs12"><spring:message code="lesson.label.lesson.cnts.write" /></small></div>';	// 학습자료추가
        html += '						<button type="button" class="btn flex-column p4" onclick="lessonCntsWriteModal(\'' + lessonScheduleId + '\', \'' + lessonTimeId + '\', null, \'FILE_BOX\')">';
        html += '							<i class="icon-folder ico"></i>';
        html += '							<span class="fs12"><spring:message code="lesson.label.file.box" /></span>';	// 내파일함
        html += '						</button>';
        html += '						<button type="button" class="btn flex-column p4" onclick="lessonCntsWriteModal(\'' + lessonScheduleId + '\', \'' + lessonTimeId + '\', null, \'VIDEO\')">';
        html += '							<i class="icon-circle-player ico"></i>';
        html += '							<span class="fs12"><spring:message code="lesson.label.video" /></span>';	// 동영상
        html += '						</button>';

        if ("N" == LCDMS_LINK_YN) {
            html += '						<button type="button" class="btn flex-column p4" onclick="lessonCntsWriteModal(\'' + lessonScheduleId + '\', \'' + lessonTimeId + '\', null, \'VIDEO_LINK\')">';
            html += '							<i class="icon-square-play ico"></i>';
            html += '							<span class="fs12">LCDMS</span>';	// LCDMS
            html += '						</button>';
        }

        html += '						<button type="button" class="btn flex-column p4" onclick="lessonCntsWriteModal(\'' + lessonScheduleId + '\', \'' + lessonTimeId + '\', null, \'PDF\')">';
        html += '							<i class="icon-pdf ico"></i>';
        html += '							<span class="fs12">PDF</span>';
        html += '						</button>';
        html += '						<button type="button" class="btn flex-column p4" onclick="lessonCntsWriteModal(\'' + lessonScheduleId + '\', \'' + lessonTimeId + '\', null, \'FILE\')">';
        html += '							<i class="icon-paperclip ico"></i>';
        html += '							<span class="fs12"><spring:message code="lesson.label.file" /></span>';	// 파일
        html += '						</button>';
        html += '						<button type="button" class="btn flex-column p4" onclick="lessonCntsWriteModal(\'' + lessonScheduleId + '\', \'' + lessonTimeId + '\', null, \'SOCIAL\')">';
        html += '							<i class="icon-social-connect ico"></i>';
        html += '							<span class="fs12"><spring:message code="lesson.label.social" /></span>';	// 소셜
        html += '						</button>';
        html += '						<button type="button" class="btn flex-column p4" onclick="lessonCntsWriteModal(\'' + lessonScheduleId + '\', \'' + lessonTimeId + '\', null, \'LINK\')">';
        html += '							<i class="icon-link ico"></i>';
        html += '							<span class="fs12"><spring:message code="lesson.label.web.link" /></span>';	// 웹링크
        html += '						</button>';
        html += '						<button type="button" class="btn flex-column p4" onclick="lessonCntsWriteModal(\'' + lessonScheduleId + '\', \'' + lessonTimeId + '\', null, \'TEXT\')">';
        html += '							<i class="icon-paper-text ico"></i>';
        html += '							<span class="fs12"><spring:message code="lesson.label.text" /></span>';	// 텍스트
        html += '						</button>';
        html += '					</div>';
        html += '					<div class="flex flex-wrap columngap4 p8 col-4">';
        html += '						<div class="col-12 p0"><small class="opacity7 fs12"><spring:message code="std.label.lesson.cnt.add" /></small></div>';	// 학습요소추가
        html += '						<button type="button" class="btn flex-column p4" onclick="moveWriteAsmnt(\'' + lessonScheduleId + '\')">';
        html += '							<i class="icon-paper-pencil ico"></i>';
        html += '							<span class="fs12"><spring:message code="std.label.asmnt" /></span>';	// 과제
        html += '						</button>';
        html += '						<button type="button" class="btn flex-column p4" onclick="moveWriteQuiz(\'' + lessonScheduleId + '\')">';
        html += '							<i class="icon-paper-check ico"></i>';
        html += '							<span class="fs12"><spring:message code="std.label.quiz" /></span>';	// 퀴즈
        html += '						</button>';
        html += '						<button type="button" class="btn flex-column p4" onclick="moveWriteForum(\'' + lessonScheduleId + '\')">';
        html += '							<i class="icon-talk-talk ico"></i>';
        html += '							<span class="fs12"><spring:message code="std.label.forum" /></span>';	// 토론
        html += '						</button>';
        html += '						<button type="button" class="btn flex-column p4" onclick="moveWriteResch()">';
        html += '							<i class="icon-dubblebox-check ico"></i>';
        html += '							<span class="fs12"><spring:message code="std.label.resch" /></span>';	// 설문
        html += '						</button>';

        if ("G" == "${creCrsVO.uniCd}") { // 대학원과목만 세미나 버튼 표시
            html += '						<button type="button" class="btn flex-column p4" onclick="moveWriteSeminar(\'' + lessonScheduleId + '\', \'' + lessonTimeId + '\')">';
            html += '							<i class="icon-microphone ico"></i>';
            html += '							<span class="fs12"><spring:message code="sch.seminar" /></span>';	// 세미나
            html += '						</button>';
        } else {
            html += '						<button type="button" class="btn flex-column p4" style="visibility:hidden">';
            html += '							<i class="icon-microphone ico"></i>';
            html += '							<span class="fs12"><spring:message code="sch.seminar" /></span>';	// 세미나
            html += '						</button>';
        }

        html += '					</div>';
        html += '				</div>';
        html += '			</div>';
        html += '		</li>';
        html += '	</ul>';
        html += '</div></div>';

        return html;
    }

    // 교시 등록 팝업 콜백
    function lessonTimeWritePopCallback(data) {
        // 주차 목록 조회
        listLessonSchedule().done(function () {
            var lessonScheduleId = data.lessonScheduleId;

            if (lessonScheduleId) {
                // 주차 선택
                selectLessonSchedule(lessonScheduleId);
            }

            /* 정상적으로 저장되었습니다. */
            alert('<spring:message code="score.alert.success_save.message" />');
            closeModal();
        });
    }

    // 출결관리 모달
    function attendManageModal(lessonScheduleId) {
        var frameId = "attendManageIfm";
        var frameHtml = '<iframe src="" width="100%" id="' + frameId + '" name="' + frameId + '" title="Attend"></iframe>';
        var $frameParent = $("#" + frameId).parent();

        $("#" + frameId).remove();
        $frameParent.append(frameHtml);
        $("#" + frameId).iFrameResize();

        $("#attendManageForm > input[name='lessonScheduleId']").val(lessonScheduleId);
        $("#attendManageForm").attr("target", frameId);
        $("#attendManageForm").attr("action", "/lesson/lessonPop/attendManagePop.do");
        $("#attendManageForm").submit();
        $("#attendManageModal").modal('show');

        $("#attendManageForm > input[name='lessonScheduleId']").val("");
    }

    // 교시추가 모달
    function lessonTimeWriteModal(lessonScheduleId, lessonTimeId) {
        $("#lessonTimeWriteForm > input[name='lessonScheduleId']").val(lessonScheduleId);
        $("#lessonTimeWriteForm > input[name='lessonTimeId']").val(lessonTimeId);
        $("#lessonTimeWriteForm").attr("target", "lessonTimeWriteIfm");
        $("#lessonTimeWriteForm").attr("action", "/lesson/lessonPop/lessonTimeWritePop.do");
        $("#lessonTimeWriteForm").submit();
        $('#lessonTimeWriteModal').modal('show');

        $("#lessonTimeWriteForm > input[name='lessonScheduleId']").val("");
        $("#lessonTimeWriteForm > input[name='lessonTimeId']").val("");
    }

    // 교시삭제
    function removeLessonTime(lessonScheduleId, lessonTimeId) {
        /* 교시를 삭제하겠습니까? */
        if (!confirm('<spring:message code="seminar.alert.delete.lesson.time" />')) {
            return;
        }

        var url = "/lesson/lessonLect/deleteLessonTime.do";
        var data = {
            crsCreCd: '<c:out value="${crsCreCd}" />'
            , lessonTimeId: lessonTimeId
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                // 주차 목록 조회
                listLessonSchedule().done(function () {
                    // 주차 선택
                    selectLessonSchedule(lessonScheduleId);
                    /* 삭제에 성공하였습니다. */
                    alert('<spring:message code="forum.alert.del_success" />');
                });
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
        });
    }

    // 학습자료 추가 모달
    function lessonCntsWriteModal(lessonScheduleId, lessonTimeId, lessonCntsId, cntsGbn) {
        $("#lessonCntsWriteForm > input[name='lessonScheduleId']").val(lessonScheduleId);
        $("#lessonCntsWriteForm > input[name='lessonTimeId']").val(lessonTimeId);
        $("#lessonCntsWriteForm > input[name='lessonCntsId']").val(lessonCntsId);
        $("#lessonCntsWriteForm > input[name='cntsGbn']").val(cntsGbn);
        $("#lessonCntsWriteForm").attr("target", "lessonCntsWriteIfm");
        $("#lessonCntsWriteForm").attr("action", "/lesson/lessonPop/lessonCntsWritePop.do");
        $("#lessonCntsWriteForm").submit();
        $('#lessonCntsWriteModal').modal('show');

        $("#lessonCntsWriteForm > input[name='lessonScheduleId']").val("");
        $("#lessonCntsWriteForm > input[name='lessonTimeId']").val("");
        $("#lessonCntsWriteForm > input[name='lessonCntsId']").val("");
        $("#lessonCntsWriteForm > input[name='cntsGbn']").val("");
    }

    // 학습자료 추가 팝업 저장 콜백
    function lessonCntsWritePopSaveCallback(data, msg) {
        var lessonScheduleId = data.lessonScheduleId;

        // 주차 목록 조회
        listLessonSchedule().done(function () {
            if (lessonScheduleId) {
                // 주차 선택
                selectLessonSchedule(lessonScheduleId);
            }

            // 정상적으로 저장되었습니다.
            alert(msg || '<spring:message code="score.alert.success_save.message" />');
            closeModal();
        });
    }

    // 학습자료 추가 팝업 동영상저장 실패 콜백
    function lessonCntsWritePopVideoSaveFailCallback(data) {
        // 주차 목록 조회
        listLessonSchedule().done(function () {
            selectLessonSchedule(data.lessonScheduleId);
        });

        lessonCntsWriteModal(data.lessonScheduleId, data.lessonTimeId, data.lessonCntsId, data.cntsGbn);
    }

    // 학습자료 추가 팝업 삭제 콜백
    function lessonCntsWritePopRemoveCallback(data) {
        var lessonScheduleId = data.lessonScheduleId;

        // 주차 목록 조회
        listLessonSchedule().done(function () {
            if (lessonScheduleId) {
                // 주차 선택
                selectLessonSchedule(lessonScheduleId);
            }
            /* 삭제에 성공하였습니다. */
            alert('<spring:message code="forum.alert.del_success" />');
            closeModal();
        });
    }

    // 학습자료삭제
    function removeLessonCnts(lessonScheduleId, lessonCntsId) {
        var crsCreCd = '<c:out value="${crsCreCd}" />';

        var url = "/lesson/lessonLect/countLessonCntsStudyRecord.do";
        var data = {
            crsCreCd: crsCreCd
            , lessonCntsId: lessonCntsId
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnVO = data.returnVO;
                var totalCnt = returnVO.totalCnt;
                var confirmMsg = "";

                if (totalCnt == 0) {
                    /* 학습 중인 학습자가 없습니다. 삭제 가능합니다. */
                    confirmMsg = "<spring:message code="lesson.confirm.delete.lesson.cnts.std.not.exist" />";
                } else {
                    /* 학습 중인 학습자가 있습니다. 삭제할 경우 모든 학습자의 학습 정보가 삭제됩니다. 그래도 삭제 하시겠습니까? */
                    confirmMsg = "<spring:message code="lesson.confirm.delete.lesson.cnts.std.exist" />";
                }

                if (!confirm(confirmMsg)) return;

                url = "/lesson/lessonLect/deleteLessonCnts.do";
                data = {
                    crsCreCd: crsCreCd
                    , lessonCntsId: lessonCntsId
                    , year: "<c:out value="${creCrsVO.creYear}"/>"
                    , semester: "<c:out value="${creCrsVO.creTerm}"/>"
                    , lcdmsLinkYn: "<c:out value="${creCrsVO.lcdmsLinkYn}"/>"
                };

                console.log(data);

                ajaxCall(url, data, function (data) {
                    if (data.result > 0) {
                        // 주차 목록 조회
                        listLessonSchedule().done(function () {
                            // 주차 선택
                            selectLessonSchedule(lessonScheduleId);
                            /* 삭제에 성공하였습니다. */
                            alert('<spring:message code="forum.alert.del_success" />');
                        });
                    } else {
                        alert(data.message);
                    }
                }, function (xhr, status, error) {
                    /* 삭제 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
                    alert("<spring:message code="asmnt.message.error.del" />");
                });
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 삭제 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
            alert("<spring:message code="asmnt.message.error.del" />");
        });
    }

    // 시험 목록페이지 이동
    function moveListExam(examType) {
        var url = "/exam/Form/examList.do";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: "examType", value: examType}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 시험 상세페이지 이동
    function moveDetailExam(examType, examCd) {
        var url = "/exam/examInfoManage.do";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: "examType", value: examType}));
        form.append($('<input/>', {type: 'hidden', name: "examCd", value: examCd}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 시험 수정페이지 이동
    function moveEditExam(examCd, examStareTypeCd) {
        var examType = examStareTypeCd == "A" ? "ADMISSION" : "EXAM";
        var url = "/exam/Form/examEdit.do";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: "examCd", value: examCd}));
        form.append($('<input/>', {type: 'hidden', name: "examStareTypeCd", value: examStareTypeCd}));
        form.append($('<input/>', {type: 'hidden', name: "examType", value: examType}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 상시시험 삭제페이지 이동
    function moveRemoveAExam(examCd, examType) {
        var url = "/exam/examInfoManage.do";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: "examCd", value: examCd}));
        form.append($('<input/>', {type: 'hidden', name: "examType", value: examType}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 과제 목록페이지 이동
    function moveListAsmnt() {
        var url = "/asmt/profAsmtListView.do";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 과제 상세페이지 이동
    function moveDetailAsmnt(asmntCd) {
        var url = "/asmtProfAsmtEvlView.do";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: "asmntCd", value: asmntCd}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 과제 등록페이지 이동
    function moveWriteAsmnt(lessonScheduleId) {
        var url = "/asmtProfAsmtRegistView.do";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: "lessonScheduleId", value: lessonScheduleId}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 과제 수정페이지 이동
    function moveEditAsmnt(asmntCd) {
        var url = "/asmtProfAsmtRegistView.do";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: "asmntCd", value: asmntCd}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 과제 삭제페이지 이동
    function moveRemoveAsmnt(asmntCd) {
        var url = "/asmtProfAsmtSelectView.do";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: "asmntCd", value: asmntCd}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 토론 목록페이지 이동
    function moveListForum() {
        var url = "/forum/forumLect/Form/forumList.do";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 토론 상세페이지 이동
    function moveDetailForum(forumCd) {
        var url = "/forum/forumLect/Form/bbsManage.do?tab=1";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: "forumCd", value: forumCd}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 토론 등록페이지 이동
    function moveWriteForum(lessonScheduleId) {
        var url = "/forum/forumLect/Form/addForumForm.do";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: "lessonScheduleId", value: lessonScheduleId}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 토론 수정페이지 이동
    function moveEditForum(forumCd) {
        var url = "/forum/forumLect/Form/editForumForm.do";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: "forumCd", value: forumCd}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 토론 삭제페이지 이동
    function moveRemoveForum(forumCd) {
        var url = "/forum/forumLect/Form/infoManage.do?tab=0";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: "forumCd", value: forumCd}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 퀴즈 목록페이지 이동
    function moveListQuiz() {
        var url = "/quiz/profQzListView.do";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 퀴즈 상세페이지 이동
    function moveDetailQuiz(examCd) {
        var url = "/quiz/quizScoreManage.do";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: "examCd", value: examCd}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 퀴즈 등록페이지 이동
    function moveWriteQuiz(lessonScheduleId) {
        var url = "/quiz/Form/writeQuiz.do";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: "lessonScheduleId", value: lessonScheduleId}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 퀴즈 수정페이지 이동
    function moveEditQuiz(examCd) {
        var url = "/quiz/Form/editQuiz.do";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: "examCd", value: examCd}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 퀴즈 삭제페이지 이동
    function moveRemoveQuiz(examCd) {
        var url = "/quiz/quizScoreManage.do";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: "examCd", value: examCd}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 설문 목록페이지 이동
    function moveListResch() {
        var url = "/resh/Form/reshList.do";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 설문 상세페이지 이동
    function moveDetailResch(reschCd) {
        var url = "/resh/reshResultManage.do";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: "reschCd", value: reschCd}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 설문 등록페이지 이동
    function moveWriteResch(reschCd) {
        var url = "/resh/Form/writeResh.do";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 설문 수정페이지 이동
    function moveEditResch(reschCd) {
        var url = "/resh/Form/editResh.do";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: "reschCd", value: reschCd}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 설문 삭제페이지 이동
    function moveRemoveResch(reschCd) {
        var url = "/resh/reshResultManage.do";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: "reschCd", value: reschCd}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 세미나 목록 페이지 이동
    function moveListSeminar(seminarId) {
        var url = "/seminar/seminarHome/seminarAttendManage.do";
        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: 'seminarId', value: seminarId}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 세미나 등록페이지 이동
    function moveWriteSeminar(lessonScheduleId, lessonTimeId) {
        var url = "/seminar/seminarHome/seminarCntBySchedule.do";
        var data = {
            lessonScheduleId: lessonScheduleId,
            crsCreCd: "${crsCreCd}"
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var url = "/seminar/seminarHome/Form/seminarWrite.do";
                var form = $("<form></form>");
                form.attr("method", "POST");
                form.attr("name", "moveform");
                form.attr("action", url);
                form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '<c:out value="${crsCreCd}" />'}));
                form.append($('<input/>', {type: 'hidden', name: 'lessonScheduleId', value: lessonScheduleId}));
                form.append($('<input/>', {type: 'hidden', name: 'lessonTimeId', value: lessonTimeId}));
                form.appendTo("body");
                form.submit();

                $("form[name='moveform']").remove();
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
        });
    }

    // 세미나 수정페이지 이동
    function moveEditSeminar(seminarId) {
        var url = "/seminar/seminarHome/Form/seminarEdit.do";
        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: "seminarId", value: seminarId}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 세미나 삭제페이지 이동
    function moveRemoveSeminar(seminarId) {
        var url = "/seminar/seminarHome/seminarAttendManage.do";
        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: "seminarId", value: seminarId}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 날짜 포멧 변환 (yyyy.mm.dd || yyyy.mm.dd hh:ii)
    function getDateFmt(dateStr) {
        var fmtStr = (dateStr || "");

        if (fmtStr.length == 14) {
            fmtStr = fmtStr.substring(0, 4) + '.' + fmtStr.substring(4, 6) + '.' + fmtStr.substring(6, 8) + ' ' + fmtStr.substring(8, 10) + ':' + fmtStr.substring(10, 12);
        } else if (fmtStr.length == 8) {
            fmtStr = fmtStr.substring(0, 4) + '.' + fmtStr.substring(4, 6) + '.' + fmtStr.substring(6, 8);
        }

        return fmtStr;
    }

    // 화상 세미나 참여하기
    function seminarStart(seminarId) {
        var url = "/seminar/seminarHome/viewSeminar.do";
        var data = {
            seminarId: seminarId
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnVO = data.returnVO;
                if (returnVO.seminarEndYn == "Y") {
                    alert("<spring:message code='seminar.alert.end.seminar' />");/* 해당 세미나는 종료되었습니다. */
                } else if (returnVO.seminarStartYn == "N") {
                    alert("<spring:message code='seminar.alert.not.seminar.ten.minutes.before.start' />");/* 세미나 시작시간이 아닙니다. 10분 전부터 시작 가능합니다. */
                } else {
                    var hostYn = returnVO.hostYn;
                    url = hostYn == "Y" ? "/seminar/seminarHome/zoomHostStart.do" : "/seminar/seminarHome/zoomJoinStart.do";
                    data = {
                        seminarId: seminarId,
                        crsCreCd: "<c:out value='${crsCreCd}'/>"
                    }

                    ajaxCall(url, data, function (data) {
                        if (data.result > 0) {
                            var zoomUrl = hostYn == "Y" ? data.returnVO.hostUrl : data.returnVO.joinUrl;
                            if ("${IPHONE_YN}" == "Y") {
                                window.location.href = data.returnVO.joinUrl;
                            } else {
                                var windowOpener = window.open();
                                windowOpener.location = zoomUrl;
                            }
                        }
                    });
                }
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
        });
    }

    // 강의콘텐츠 다운로드
    function downLessonCnts(lessonCntsId) {
        var url = "/lesson/lessonHome/selectLessonCntsFilePath.do";
        var data = {
            crsCreCd: '<c:out value="${crsCreCd}" />'
            , lessonCntsId: lessonCntsId
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnVO = data.returnVO;

                if (returnVO && returnVO.downloadPath) {
                    var path = returnVO.downloadPath;

                    var downloadUrl = '<%= CommConst.CONTEXT_FILE_DOWNLOAD %>?path=';
                    var form = $("<form></form>");
                    form.attr("method", "POST");
                    form.attr("name", "downloadForm");
                    form.attr("id", "downloadForm");
                    form.attr("target", "downloadIfm");
                    form.attr("action", downloadUrl + path);
                    form.appendTo("body");
                    form.submit();

                    $("#downloadForm").remove();
                } else {
                    alert('<spring:message code="lesson.error.not.exists.lesson.cnts" />'); // 학습자료 정보를 찾을 수 없습니다.
                }
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
        });
    }

    function viewElemBox(boxId) {
        $("#" + boxId).find(".add-elem-box").show();
    }

    // 강의노트 다운로드
    function ltNoteDown(ltNote, lessonScheduleOrder) {
        try {
            event.stopPropagation();
        } catch (e) {
        }

        <%
        String agentS = request.getHeader("User-Agent") != null ? request.getHeader("User-Agent") : "";
        String appIos = "N";
        if (agentS.indexOf("hycuapp") > -1 && (agentS.indexOf("iPhone") > -1 || agentS.indexOf("iPad") > -1)) {
            appIos = "Y";
        }
        %>

        var creNm = encodeURIComponent("${creCrsVO.crsCreNm}");
        var fileName = creNm + "_" + (lessonScheduleOrder.length < 2 ? "0" + lessonScheduleOrder : lessonScheduleOrder);
        var viewPath = "{\"path\":\"" + ltNote + "\",\"fileName\":\"" + fileName + "\",\"date\":\"" + (new Date().getTime()) + "\"}";
        var ltNoteUrl = "<%=CommConst.EXT_URL_LONOTE_VIEWER%>" + btoa(viewPath);

        var appIos = "<%=appIos%>";
        if (appIos == "Y") {
            document.location.href = ltNoteUrl;
        } else {
            window.open(ltNoteUrl, '_blank');
        }
    }

    // 앱 네비바 표시 바꾸기
    function changeAppNaviBarState(state) {
        const scheme = 'smartq://hycu?action=' + state;
        try {
            webkit.messageHandlers.callbackHandler.postMessage(scheme); // IOS
        } catch (err) {
        }

        try {
            window.Android.goScheme(scheme); // Andriod
        } catch (err) {
        }
    }

    // 주차명 변경 표시(영문)
    function convertWeekName(weekName) {
        if ("en" == "<%=SessionInfo.getLocaleKey(request)%>") {
            weekName = "Week " + weekName.replace("주차", "");
        }
        return weekName;
    }
</script>

<div class="row week-list">
    <div class="col backcolorArea">
        <div class="sec_head"><spring:message code="common.label.lecture.list"/></div><!-- 강의목록 -->

        <ul class="flex-tab week">
            <c:forEach var="lesson" items="${lessonScheduleList}" varStatus="status">
                <c:set var="ingClass" value=""/>
                <c:set var="emptyClass" value=""/>
                <c:if test="${lesson.lessonScheduleProgress eq 'PROGRESS'}">
                    <c:set var="ingClass" value="state_now"/>
                </c:if>
                <c:if test="${lesson.wekClsfGbn eq '04' or lesson.wekClsfGbn eq '05'}">
                    <c:set var="emptyClass" value="ico"/>
                </c:if>
                <c:if test="${lesson.lessonScheduleProgress eq 'READY'}">
                    <c:set var="emptyClass" value="ico"/>
                </c:if>

                <li class="<c:out value="${ingClass}"/> state">
                    <a href="javascript:selectLessonSchedule('<c:out value="${lesson.lessonScheduleId}"/>')">
           				<span class="week">
	                    	<c:choose>
                                <c:when test="${lesson.wekClsfGbn eq '04'}">중간</c:when>
                                <c:when test="${lesson.wekClsfGbn eq '05'}">기말</c:when>
                                <c:otherwise>${lesson.lessonScheduleOrder}</c:otherwise>
                            </c:choose>
	                    </span>
                        <i id="lessonScheduleJoinRate_<c:out value="${lesson.lessonScheduleId}"/>"
                           class="<c:out value="${emptyClass}"/>"></i>
                    </a>
                </li>
            </c:forEach>
        </ul>
    </div>

    <div class="col">
        <div class="option-content header2">
            <button class="ui basic small button" type="button" id="openCloseBtn" onclick="toggleLessonScheduleOpen()">
                <spring:message code="common.label.lesson.schedule"/></button><!-- 전체 주차 -->
            <button title="<spring:message code="crs.label.week.range" />" class="ui basic icon button ml_auto"
                    type="button" onclick="toggleLessonScheduleSortOrder(this)"><i class="sort amount up icon"></i>
            </button>
        </div>

        <!-- 주차 목록 -->
        <div id="lessonScheduleList" class="courseItemList timeline"></div>
    </div>
</div>


<!-- 출결관리 팝업 -->
<form id="attendManageForm" name="attendManageForm" method="post">
    <input type="hidden" name="crsCreCd" value="<c:out value="${crsCreCd}"/>"/>
    <input type="hidden" name="lessonScheduleId" value=""/>
</form>
<div class="modal fade in" id="attendManageModal" tabindex="-1" role="dialog"
     aria-labelledby="<spring:message code="seminar.button.attend.manage" />" aria-hidden="false"
     style="display: none; padding-right: 17px;">
    <div class="modal-dialog modal-lg2" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"
                        aria-label="<spring:message code="resh.button.close" />">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title"><spring:message code="seminar.button.attend.manage" /><!-- 출결관리 --></h4>
            </div>
            <div class="modal-body">
                <iframe src="" width="100%" id="attendManageIfm" name="attendManageIfm"
                        title="attendManageIfm"></iframe>
            </div>
        </div>
    </div>
</div>

<!-- 교시추가 팝업 -->
<form id="lessonTimeWriteForm" name="lessonTimeWriteForm" method="post">
    <input type="hidden" name="crsCreCd" value="<c:out value="${crsCreCd}"/>"/>
    <input type="hidden" name="lessonScheduleId" value=""/>
    <input type="hidden" name="lessonTimeId" value=""/>
</form>
<div class="modal fade in" id="lessonTimeWriteModal" tabindex="-1" role="dialog"
     aria-labelledby="<spring:message code="lesson.label.time.add" />" aria-hidden="false"
     style="display: none; padding-right: 17px;">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"
                        aria-label="<spring:message code="resh.button.close" />">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title"><spring:message code="lesson.label.time.add" /><!-- 교시 추가 --></h4>
            </div>
            <div class="modal-body">
                <iframe src="" width="100%" id="lessonTimeWriteIfm" name="lessonTimeWriteIfm"
                        title="lessonTimeWriteIfm"></iframe>
            </div>
        </div>
    </div>
</div>

<!-- 학습자료 추가 팝업 -->
<form id="lessonCntsWriteForm" name="lessonCntsWriteForm" method="post">
    <input type="hidden" name="crsCreCd" value="<c:out value="${crsCreCd}"/>"/>
    <input type="hidden" name="lessonScheduleId" value=""/>
    <input type="hidden" name="lessonTimeId" value=""/>
    <input type="hidden" name="lessonCntsId" value=""/>
    <input type="hidden" name="cntsGbn" value=""/>
    <input type="hidden" name="courseCode" value="<c:out value="${creCrsVO.crsCd}"/>"/>
    <input type="hidden" name="year" value="<c:out value="${creCrsVO.creYear}"/>"/>
    <input type="hidden" name="semester" value="<c:out value="${creCrsVO.creTerm}"/>"/>
    <input type="hidden" name="lcdmsLinkYn" value="<c:out value="${creCrsVO.lcdmsLinkYn}"/>"/>
</form>
<div class="modal fade in" id="lessonCntsWriteModal" tabindex="-1" role="dialog"
     aria-labelledby="<spring:message code="lesson.label.lesson.cnts.write" />" aria-hidden="false"
     style="display: none; padding-right: 17px;">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"
                        aria-label="<spring:message code="resh.button.close" />">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title"><spring:message code="lesson.label.lesson.cnts.write" /><!-- 학습자료 추가 --></h4>
            </div>
            <div class="modal-body">
                <iframe src="" width="100%" id="lessonCntsWriteIfm" name="lessonCntsWriteIfm"
                        title="lessonCntsWriteIfm"></iframe>
            </div>
        </div>
    </div>
</div>

<!-- 강의보기 팝업 -->
<form id="lessonViewForm" name="lessonViewForm" method="post">
    <input type="hidden" name="crsCreCd" value="${crsCreCd}"/>
    <input type="hidden" name="lessonScheduleId" value=""/>
    <input type="hidden" name="lessonTimeId" value=""/>
    <input type="hidden" name="lessonCntsIdx" value=""/>
</form>
<div class="modal fade in" id="lessonViewModal" tabindex="-1" role="dialog"
     aria-labelledby="<spring:message code="lesson.label.view.lesson" />" aria-hidden="false"
     style="display: none; padding-right: 17px;">
    <div class="modal-dialog modal-extra-lg" role="document">
        <div id="lessonViewDialog" class="modal-content">
            <div class="modal-header bcGreen">
                <button type="button" class="close" data-dismiss="modal"
                        aria-label="<spring:message code="resh.button.close" />">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title"><spring:message code="lesson.label.view.lesson" /><!-- 강의보기 --></h4>
            </div>
            <div class="modal-body">
                <iframe src="" width="100%" id="lessonViewIfm" name="lessonViewIfm" style="min-height:800px"
                        title="lessonViewIfm"></iframe>
            </div>
        </div>
    </div>
</div>
<iframe id="downloadIfm" name="downloadIfm" style="visibility: none; display: none;" title="downloadIfm"></iframe>

<script>
    var lessonViewDialog = null;

    // 강의보기 팝업 호출
    function viewLesson(lessonScheduleId, lessonTimeId, cntsIdx) {
        var popW = 1200;
        var popH = 850;
        var winW = $(window).width();
        var winH = $(window).height();
        var fixfull = false;
        if (DEVICE_TYPE != undefined && DEVICE_TYPE == "mobile") {
            fixfull = true;
        }

        if (winW < popW + 80) {
            popW = winW - 80 - 10;
        }
        if (winH < popH + 90) {
            popH = winH - 90 - 10;
        }

        var lessonScheduleOrderText;

        LESSON_SCHEDULE_LIST.forEach(function (v, i) {
            if (v.lessonScheduleId == lessonScheduleId) {
                lessonScheduleOrderText = v.lessonScheduleOrder + '<spring:message code="lesson.label.schedule"/> '; // 주차
                return false;
            }
        });

        var modalTitle = lessonScheduleOrderText + '<spring:message code="lesson.label.view.lesson"/>'; // 강의보기

        var url = "/crs/crsProfLessonView.do?crsCreCd=${crsCreCd}"
            + "&lessonScheduleId=" + lessonScheduleId + "&lessonTimeId=" + lessonTimeId + "&lessonCntsIdx=" + cntsIdx;

        document.location.href = url;

        /*
        lessonViewDialog = UiDialog("lessonView", modalTitle, "width="+popW+",height="+popH+",resizable=true,draggable=true,modal=true,fullscreen=true,fixfull="+fixfull+"", "lesson-view");
        lessonViewDialog.html("<iframe id='lessonViweFrame' frameborder='0' scrolling='auto' style='width:100%;height:99%' src=\""+url+"\" title='lessonViweFrame'></iframe>");
        lessonViewDialog.open();

        lessonViewDialog.on("dialogclose", function( event, ui ) {
        	$("#DIALOG_lessonView").remove();
        });

        if (DEVICE_TYPE != undefined && DEVICE_TYPE == "mobile") {
        	var orient = 0;
            if (winW > winH) orient = 1;
            lessonViewDialog.onFullscreen(orient);

			$(window).on("orientationchange",function(){
				if(window.orientation == 0) { // Portrait
					setTimeout(function(){
			         	lessonViewDialog.onFullscreen(0);
						$('html,body').scrollTop(0);
			        },100);
				}
				else { // Landscape
					setTimeout(function(){
			        	lessonViewDialog.onFullscreen(1);
						$('html,body').scrollTop(0);
					},100);
				}
			});
        } else {
        	lessonViewDialog.onFullscreen();
        }
        */
    }

    $('#lessonViewIfm').iFrameResize();
    $('#lessonTimeWriteIfm').iFrameResize();
    $('#lessonCntsWriteIfm').iFrameResize();
    $('#attendManageIfm').iFrameResize();
    window.closeModal = function () {
        $('.modal').modal('hide');
    };
</script>
