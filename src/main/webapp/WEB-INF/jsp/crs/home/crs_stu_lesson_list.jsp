<%@ page import="knou.framework.common.SessionInfo" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>

<script type="text/javascript">
    var SORT_ODR = "ASC";						// 강의 주차 정렬
    var IS_SCROLL_TOP_ACTION = false;	// 강의 주차 스크롤 이동 여부
    var LESSON_SCHEDULE_LIST = []; 	// 강의 주차 목록
    var IS_REFERESH_ACTION = false;		// 강의 주차 목록 갱신여부
    var isKnou = "<%=SessionInfo.isKnou(request)%>";
    self.window.name = "";
    localStorage.setItem("STDY_CHEK", 0);

    $(document).ready(function () {
        changeAppNaviBarState("showBar");

        $('.learn_progress .my_average,.learn_progress .all_average').progress({
            duration: 100
            , total: 100
        });

        // 주차 목록 조회
        listLessonSchedule().done(function () {
            var lessonScheduleId = '<c:out value="${viewLessonScheduleId}" />';
            if (lessonScheduleId) {
                // 주차 선택
                selectLessonSchedule(lessonScheduleId);

                LESSON_SCHEDULE_LIST.forEach(function (v, i) {
                    if (v.lessonScheduleId == lessonScheduleId) {
                        var listLessonTime = v.listLessonTime || [];

                        if (listLessonTime.length > 0) {
                            var lessonTimeId = listLessonTime[0].lessonTimeId;

                            // 플레이어 팝업
                            viewLesson(lessonScheduleId, lessonTimeId, 0);
                        }

                        return false;
                    }
                });
            }
        });

        if (DEVICE_TYPE != undefined && DEVICE_TYPE == "mobile") {
            if (document.addEventListener) {
                window.addEventListener('pageshow', function (event) {
                    if (event.persisted || window.performance && window.performance.navigation.type == 2) {
                        location.reload();
                    }
                }, false);
            }
        }
    });

    // 주차별 참여 현황 - 주차 선택
    function selectLessonSchedule(lessonScheduleId) {

        // 주차목록 초기화
        setLessonScheduleList();

        // 해당 주차의 아코디언 펼침
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
        //$("html").scrollTop($(".week-list").offset().top - 70);
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
        }
    }

    // 주차 목록 조회
    function listLessonSchedule() {
        var deferred = $.Deferred();

        var url = "/crs/listCrsHomeLessonSchedule.do";
        var data = {
            crsCreCd: '<c:out value="${crsCreCd}" />'
            , stdNo: '<c:out value="${stdNo}" />'
            , userId: '<c:out value="${userId}" />'
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

                deferred.resolve();
            } else {
                alert(data.message);
                deferred.reject();
            }
        }, function (xhr, status, error) {
            console.log('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
            deferred.reject();
        });

        return deferred.promise();
    }

    // 주차목록 세팅
    function setLessonScheduleList() {
        var html = createLessonScheduleHtml(LESSON_SCHEDULE_LIST);

        $("#lessonScheduleList").empty().html(html);
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
        });
    }

    // 1.주차
    function createLessonScheduleHtml(lessonScheduleList) {
        var html = '';

        if (lessonScheduleList && lessonScheduleList.length > 0) {
            lessonScheduleList.forEach(function (v, i) {
                var listLessonTime = v.listLessonTime || [];
                var listCrsHomeExam = v.studyElementMap && v.studyElementMap.listCrsHomeExam || [];

                var lbnTm = v.lbnTm * 60;
                var studyTotalTm = (v.studyTotalTm || 0);
                var studyAfterTm = (v.studyAfterTm || 0);
                var sumTm = studyTotalTm + studyAfterTm;
                var prgrRatio = lbnTm == 0 ? 0 : (studyTotalTm / lbnTm) * 100;
                prgrRatio = prgrRatio > 100 ? 100 : prgrRatio;
                prgrRatio = Math.floor(prgrRatio);

                var studyTmStr = "0:00";
                var studyTotalStr = "0:00";
                var studyAfterStr = "0:00";

                if (sumTm > 0) {
                    studyTmStr = (parseInt(studyTotalTm / 60)) + ":";
                    if (parseInt(studyTotalTm % 60) < 10) studyTmStr += "0";
                    studyTmStr += parseInt(studyTotalTm % 60);
                }
                if (studyAfterTm > 0) {
                    studyAfterStr = (parseInt(studyAfterTm / 60)) + ":";
                    if (parseInt(studyAfterTm % 60) < 10) studyAfterStr += "0";
                    studyAfterStr += parseInt(studyAfterTm % 60);
                }

                var lessonStartDtFmt = getDateFmt(v.lessonStartDt);
                var lessonEndDtFmt = getDateFmt(v.lessonEndDt);

                var lessonProgressNm = '';
                var scheduleFrDt = getDateFmt(v.ltDetmFrDt) || lessonStartDtFmt;
                var scheduleToDt = getDateFmt(v.ltDetmToDt) || lessonEndDtFmt;

                /*
                if(v.lessonScheduleProgress == "READY") {
                    lessonProgressNm = '대기';
                } else if(v.lessonScheduleProgress == "PROGRESS") {
                    lessonProgressNm = '수업중';
                } else if(v.lessonScheduleProgress == "END") {
                    lessonProgressNm = '마감';
                }
                */

                if (v.lessonScheduleStat == "READY") {
                    lessonProgressNm = "<spring:message code="common.label.ready" />";	// 대기
                } else if (v.lessonScheduleStat == "PROGRESS") {
                    lessonProgressNm = "<spring:message code="lesson.label.status.progress" />";	// 수업중
                } else if (v.lessonScheduleStat == "END") {
                    lessonProgressNm = "<spring:message code="lesson.label.status.end" />";	// 마감
                }

                var openYnHtml = '';

                // 중간/기말 시험 정보
                var examInfo = {};
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
                            examTitle = "<spring:message code='crs.label.final_exam' />";		// 기말고사
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
                    // 1주차 기준 동영상 컨텐츠가 있는경우 (VIDEO_LINK 경우 openY 인것)
                    var listLessonCnts = listLessonTime[0].listLessonCnts || [];

                    firstLessonTimeId = listLessonTime[0].lessonTimeId;

                    listLessonCnts.forEach(function (vv, j) {
                        if (vv.cntsGbn == "VIDEO" || (vv.cntsGbn == "VIDEO_LINK" && v.openYn == "Y")) {
                            hasVideoCnts = true;
                            return false;
                        }
                    });
                }

                // 학습상태 html 설정
                var studyStatusHtml = "";
                if (v.studyStatusCd && (v.wekClsfGbn == "02" || v.wekClsfGbn == "03" || v.prgrVideoCnt > 0)) {
                    //if(v.studyStatusCd == "COMPLETE" || v.studyStatusCd == "LATE") {
                    if (v.studyStatusCd == "COMPLETE") {
                        studyStatusHtml = '<div class="ui green label small">';
                        studyStatusHtml += '	<i class="check circle outline icon "></i><spring:message code="lesson.lecture.atnd_complte"/>'; // 출석완료
                        studyStatusHtml += '</div>';
                    } else if (v.studyStatusCd == "STUDY") {
                        studyStatusHtml = '<small class="fcBlue"><spring:message code="dashboard.state.study" /></small>';	// 학습중
                    }
                }

                html += '<div id="acc_' + v.lessonScheduleId + '" class="ui accordion courseItem mt10">';
                html += '	<div class="title mainInfo ' + activeAccordionClass + '" style="cursor:pointer">';

                if (v.examStareTypeCd) {
                    // 시험주차
                    html += '	<div class="lect">';
                    html += '		<div class="info">';
                    html += '			<p class="lect_name"><span>' + examTitle + '</span>';
                    html += '		      <span class="lectInfo">';
                    html += '			    <span class="ui small label state">' + lessonProgressNm + '</span>';
                    html += openYnHtml + ' <small class="fwb fcDark9">' + lessonStartDtFmt + ' ~ ' + lessonEndDtFmt + '</small>';
                    html += '		      </span>';
                    html += '           </p>';

                    html += '			<ul class="list_verticalline">';
                    html += '				<li>';
                    //html += '					<small class="">일시</small>';
                    //html += '					<small class="">' + lessonStartDtFmt + ' ~ ' + lessonEndDtFmt + '</small>';
                    html += '				</li>';
                    /*
                    if(examInfo.examCd) {
                        html += '			<li>';
                        if(examInfo.examTypeCd == "EXAM" || examInfo.examTypeCd == "QUIZ") {
                            html += '			<small class="">' + (examInfo.examStareTm || ' - ') + '분</small>';
                        } else {
                            html += '			<small class="">성적 : ' + scoreOpenYnText + '</small>';
                        }
                        html += '			</li>';
                    }
                    */
                    html += '    		</ul>';
                    html += '    	</div>'; // info
                    html += '    <div class="button-area">';
                    if (examInfo.examTypeCd == "EXAM") {
                        if (v.lessonScheduleProgress == "PROGRESS") {
                            //html += '<button type="button" class="ui basic small button ml5" type="button" onclick="event.stopPropagation(); submitOathPop(\'' + examInfo.examCd + '\')"><spring:message code="exam.label.oath.submit" /></button>';
                        }
                        if (v.lessonScheduleProgress != "END" && examInfo.examAbsentPeriodYn == "Y") {
                            //html += '<button type="button" class="ui basic small button ml5" type="button" onclick="event.stopPropagation(); examAbsentPop(\'' + examInfo.examCd + '\', \'' + examInfo.examStareTypeCd + '\')"><spring:message code="exam.label.exam.absent.applicate" /></button>';
                        }
                        if (v.lessonScheduleProgress == "PROGRESS") {
                            html += '<button type="button" class="ui orange small button ml5" type="button" onclick="event.stopPropagation(); joinExam(\'' + examInfo.examCd + '\', \'' + examInfo.examStareTypeCd + '\', \'LIVE\')"><spring:message code="crs.button.exam" /><spring:message code="exam.button.stare.start" /></button>';	// 시험응시
                        }
                    }
                    if (examInfo.examTypeCd == "QUIZ" && v.lessonScheduleProgress == "PROGRESS" && examInfo.examQuizCd) {
                        html += '	<button type="button" class="ui basic small button ml5" type="button" onclick="event.stopPropagation(); joinExam(\'' + examInfo.examQuizCd + '\', \'' + examInfo.examStareTypeCd + '\', \'QUIZ\')"><spring:message code="std.label.quiz" /><spring:message code="std.label.forum_join_y" /></button>';// 퀴즈참여
                    } else if (examInfo.examTypeCd == "ASMNT" && v.lessonScheduleProgress == "PROGRESS" && examInfo.examAsmntCd) {
                        html += '	<button type="button" class="ui basic small button ml5" type="button" onclick="event.stopPropagation(); joinExam(\'' + examInfo.examAsmntCd + '\', \'' + examInfo.examStareTypeCd + '\', \'ASMNT\')"><spring:message code="std.label.asmnt" /><spring:message code="std.label.asmnt_submit" /></button>';// 과제제출
                    } else if (examInfo.examTypeCd == "FORUM" && v.lessonScheduleProgress == "PROGRESS" && examInfo.examForumCd) {
                        html += '	<button type="button" class="ui basic small button ml5" type="button" onclick="event.stopPropagation(); joinExam(\'' + examInfo.examForumCd + '\', \'' + examInfo.examStareTypeCd + '\', \'FORUM\')"><spring:message code="std.label.forum" /><spring:message code="std.label.forum_join_y" /></button>';// 토론참여
                    }
                    html += '    </div>';
                    html += '    	<i class="angle down icon"></i>';
                    html += '	</div>'; // lect
                } else {
                    // 일반주차
                    html += '	<div class="lect">';
                    html += '		<div class="info">';
                    html += '			<p class="lect_name"><span>' + convertWeekName(v.lessonScheduleNm) + '</span>';
                    html += '		      <span class="lectInfo">';
                    html += '			    <span class="ui small label state">' + lessonProgressNm + '</span>';
                    html += openYnHtml + ' <!--<small class="fwb fcDark9">' + lessonStartDtFmt + ' ~ ' + lessonEndDtFmt + '</small>-->';
                    html += '		      </span>';
                    html += '           </p>';

                    html += '			<ul class="list_verticalline">';
                    html += '				<li>';
                    //html += '					<small class="">수강</small>';
                    //html += '					<small class="">' + lessonStartDtFmt + ' ~ ' + lessonEndDtFmt + '</small>';
                    html += '					<small class=""><spring:message code="common.label.in.learning.attendance" /> : ' + scheduleFrDt + ' ~ ' + scheduleToDt + '</small>';	// 출석인정기간
                    html += '				</li>';
                    html += '				<li style="white-space:nowrap">';
                    html += '					<small class="">' + v.lbnTm + '<spring:message code="seminar.label.min" /></small>';	// 분
                    html += '				</li>';
                    if (v.startDtYn == "Y") {
                        html += '			<li style="white-space:nowrap">';
                        html += studyStatusHtml;
                        //html += '				<small class="fcBlue">학습시간 : ' + studyTmStr;

                        //if (studyAfterTm > 0) {
                        //	html += ' (기간후 ' + studyAfterStr + ')';
                        //}
                        //html += ' (' + prgrRatio + '%)</small>';
                        html += '			</li>';
                    }
                    html += '    		</ul>';
                    html += '    	</div>'; // info
                    html += '    	<div class="button-area">';
                    if (hasVideoCnts && (v.startDtYn == "Y" || v.allLessonOpenYn == "Y")) {
                        html += '		<button type="button" class="ui basic small button" onclick="event.stopPropagation(); viewLesson(\'' + v.lessonScheduleId + '\', \'' + firstLessonTimeId + '\', 0); return false;" title="<spring:message code="lesson.label.view.lesson" />"><spring:message code="lesson.label.view.lesson" /></button>'; // 강의보기
                    }
                    if (v.ltNote && v.ltNoteOfferYn == "Y" && v.startDtYn == "Y") {
                        html += '		<button type="button" class="ui purple small button" onclick="ltNoteDown(\'' + v.ltNote + '\', \'' + v.lessonScheduleOrder + '\')" title="<spring:message code="contents.label.lcture.note" />"><spring:message code="contents.label.lcture.note" /></button>';
                        //html += '		<a class="ui purple small button" href="' + v.ltNote + '" onclick="event.stopPropagation()" title="강의노트">강의노트</a>';
                    }
                    html += '    	</div>';
                    html += '    	<i class="angle down icon"></i>';
                    html += '	</div>'; // lect
                }
                html += '	</div>'; // title mainInfo
                html += '	<div data-acc-lesson-schedule-id="' + v.lessonScheduleId + '" class="content ui styled fluid itemExtraInfo ' + activeAccordionClass + '">';

                if (v.examStareTypeCd) {
                    html += createExamListHtml(examInfo, v);
                    /*
                    if(v.lessonScheduleProgress == "PROGRESS" || v.lessonScheduleProgress == "END") {
                        html += createLearnListHtml(v.studyElementMap);
                    }
                     */
                } else {
                    if (v.startDtYn == "Y" || v.allLessonOpenYn == "Y") {
                        html += createLessonTimeListHtml(listLessonTime, v);
                    }
                    /*
                    if(v.lessonScheduleProgress == "PROGRESS" || v.lessonScheduleProgress == "END") {
                        html += createLearnListHtml(v.studyElementMap);
                    }
                     */
                }
                html += '	</div>'; // title mainInfo
                html += '</div>'; // ui accordion courseItem
                // 주차별 학습요소 리스트
                if (v.lessonScheduleProgress == "PROGRESS" || v.lessonScheduleProgress == "END") {
                    html += '<div>';
                    html += createLearnListHtml(v.studyElementMap, v);
                    html += '</div>';
                }
            });
        }

        return html;
    }

    // 2.교시
    function createLessonTimeListHtml(listLessonTime, lessonScheduleInfo) {
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
        var html = '';
        var idx = 0;
        if (listLessonCnts && listLessonCnts.length > 0) {
            listLessonCnts.forEach(function (v, i) {
                // 주자 openYn 상태가 N 이고, LCDMS 동영상이면 SKIP
                if (lessonScheduleInfo.openYn != "Y" && v.cntsGbn == "VIDEO_LINK") return true;

                //var lessonStartDttmFmt = getDateFmt(lessonScheduleInfo.lessonStartDt);
                //var lessonEndDttmFmt = getDateFmt(lessonScheduleInfo.lessonEndDt);

                var seqHtml = '<div class="each_lect_box" data-list-num="-">';
                if (lessonTimeInfo.stdyMethod == "SEQ") {
                    seqHtml = '<div class="each_lect_box" data-list-num="' + v.lessonCntsOrder + '">';
                }

                // 강의콘텐츠 표시 여부
                if (lessonScheduleInfo.startDtYn == "Y" || lessonScheduleInfo.allLessonOpenYn == "Y") {
                    html += '<div class="content active">';
                    html += '    <ul class="each_lect_list">';
                    html += '        <li>';
                    html += seqHtml;
                    html += '			<div class="each_lect_tit">';
                    html += '           	<p>';
                    if (v.cntsGbn == "VIDEO" || v.cntsGbn == "VIDEO_LINK") {
                        html += '				<a href="javascript:void(0)" onclick="viewLesson(\'' + lessonScheduleInfo.lessonScheduleId + '\', \'' + lessonTimeInfo.lessonTimeId + '\', ' + idx + ')" title="<spring:message code="lesson.label.view.lesson"/>">';	// 강의보기
                        html += '					<span class="ui green small label">' + (v.cntsGbn == "VIDEO_LINK" ? "VIDEO" : v.cntsGbn) + '</span>';	// 강의
                        html += ' ' + v.lessonCntsNm;
                        html += '				</a>';
                    } else {
                        html += '				<span class="ui green small label">' + (v.cntsGbn == "VIDEO_LINK" ? "VIDEO" : v.cntsGbn) + '</span>';	// 강의
                        html += ' ' + v.lessonCntsNm;
                    }
                    html += '				</p>';
                    html += '				<p>';
                    //html += '               	<small class="bullet_dot">기간 : ' + lessonStartDttmFmt + ' ~ ' + lessonEndDttmFmt + '</small>';
                    if (v.prgrYn == "Y") {
                        html += '				<small class="bullet_dot"><spring:message code="lesson.label.stdy.prgr.y" /></small>';	// 출결대상
                    } else {
                        html += '				<small class="bullet_dot"><spring:message code="lesson.label.stdy.prgr.n" /></small>';	// 출결대상 아님
                    }
                    html += '               </p>';
                    html += '			</div>';

                    html += '			<div class="button-area">';
                    // 다운로드, 링크, 강의보기 버튼
                    if (v.cntsGbn == "FILE" || v.cntsGbn == "PDF") {
                        html += '			<button type="button" class="ui basic small button" onclick="downLessonCnts(\'' + v.lessonCntsId + '\');" title="<spring:message code="button.download" />"><spring:message code="button.download" /></button>'; // 다운로드
                    } else if (v.cntsGbn == "LINK" || (v.cntsGbn == "SOCIAL" && (v.lessonCntsUrl || "").indexOf("iframe") == -1)) {
                        html += '				<button type="button" class="ui basic small button" onclick="window.open(\'' + v.lessonCntsUrl + '\', \'_blank\')" title="<spring:message code="common.button.link" />"><spring:message code="common.button.link" /></button>'; // 링크
                    } else {
                        if (v.cntsGbn == "VIDEO" || v.cntsGbn == "VIDEO_LINK") {
                            //html += '		<button type="button" class="ui basic small button" onclick="viewLesson(\'' + lessonScheduleInfo.lessonScheduleId + '\', \'' + lessonTimeInfo.lessonTimeId + '\', ' + idx + ')"><spring:message code="lesson.label.view.lesson"/></button>';
                        } else {
                            html += '		<button type="button" class="ui basic small button" onclick="viewLesson(\'' + lessonScheduleInfo.lessonScheduleId + '\', \'' + lessonTimeInfo.lessonTimeId + '\', ' + idx + ')"><spring:message code="contents.label.learning" /></button>';// 학습콘텐츠
                        }
                    }
                    html += '			</div>';
                    html += '		</li>';
                    html += '	</ul>';
                    html += '</div>';
                }
                idx++;
            });
        }

        // 교시 세미나
        if (lessonTimeInfo.listSeminar.length > 0) {
            lessonTimeInfo.listSeminar.forEach(function (v, i) {
                var seminarStartDttmFmt = getDateFmt(v.seminarStartDttm);
                var seminarEndDttmFmt = getDateFmt(v.seminarEndDttm);
                var seminarTime = parseInt(v.seminarTime / 60) > 0 ? parseInt(v.seminarTime / 60) + "<spring:message code='date.time' />" + v.seminarTime % 60 + "<spring:message code='lesson.label.min' />" : v.seminarTime % 60 + "<spring:message code='lesson.label.min' />";

                if (v.seminarCtgrCd == "online" || v.seminarCtgrCd == "free") {
                    html += '<div class="content active">';
                    html += '	<ul class="each_lect_list">';
                    html += '		<li>';
                    html += '			<div class="each_lect_tit">';
                    html += '				<div class="ui blue button p20" onclick="seminarStart(\'' + v.seminarId + '\')">';
                    html += '					<i class="laptop icon f150"></i>';
                    html += '					<a class="tl fcWhite" href="javascript:void(0)"><spring:message code="seminar.label.webcam" /><br><spring:message code="common.label.join" /></a>';	// 화상세미나참여하기
                    html += '				</div>';
                    html += '			</div>';
                    html += '			<div class="ml30">';
                    html += '				<p><small class="bullet_dot"><spring:message code="seminar.label.seminar.nm" /> : ' + v.seminarNm + '</small></p>';			// 세미나명
                    html += '				<p><small class="bullet_dot"><spring:message code="seminar.label.start.date" /> : ' + seminarStartDttmFmt + '</small></p>';	// 시작일시
                    html += '				<p><small class="bullet_dot"><spring:message code="seminar.label.progress.time" /> : ' + seminarTime + '</small></p>';			// 진행시간
                    html += '			</div>';
                    html += '		</li>';
                    html += '	</ul>';
                    html += '	<div class="bcBlueAlpha15 mt15 p10">';
                    html += '		<p><spring:message code="seminar.message.zoom.info1" /><!-- * [중요] 반드시 Zoom Meeting 프로그램을 실행하여 참가해 주세요. --></p>';
                    html += '		<p class="fcRed"><spring:message code="seminar.message.zoom.info2" /><!-- Zoom 프로그램이 아닌 브라우저 상의"브라우저에서 참가"를 클릭하여 입장한 경우에는 출결이 기록되지 않습니다. --></p>';
                    html += '	</div>';
                    html += '	<div class="ui segment">';
                    html += '		<p><spring:message code="seminar.message.zoom.info3" /><!-- * 참가에 실패하는 경우 --></p>';
                    html += '		<p><spring:message code="seminar.message.zoom.info4" /><!-- 화상강의 참가가 원할히 진행되지 않을 경우 아래 버튼을 클릭하여 시도할 수 있습니다. --></p>';
                    html += '		<p><spring:message code="seminar.message.zoom.info5" /><!-- 참가 등록 시 아래 표시된 본인 LMS 상의 이메일 주소를 입력해야 자동 출석인정 합니다. --></p>';
                    html += '		<a href="javascript:setEmailJoin(\'' + v.seminarId + '\')" class="ui black button mt10 mb10"><spring:message code="seminar.button.self.input.email.part" /><!-- 이메일 주소 직접 등록하여 참가 --></a>';
                    html += '		<p><spring:message code="seminar.message.zoom.info6" /><!-- 참가 등록시 입력할 이메일 주소 --> : <span class="fcBlue"><spring:message code="seminar.message.zoom.info7" /><!-- 학번@hycu.ac.kr --></span></p>';
                    html += '	</div>';
                    html += '</div>';
                } else if (v.seminarCtgrCd == "offline") {
                    html += '<div class="content active">';
                    html += '	<ul class="each_lect_list">';
                    html += '		<li>';
                    html += '			<div class="each_lect_box" data-list-num="-">';
                    html += '				<div class="each_lect_tit">';
                    html += '					<p>';
                    html += '						<span class="ui deepblue1 small label"><spring:message code="sch.seminar" /></span>';	// 세미나
                    html += '						' + v.seminarNm;
                    html += '                   </p>';
                    html += '                   <p>';
                    html += '                       <small class="bullet_dot"><spring:message code="exam.label.period" /> : ' + seminarStartDttmFmt + ' ~ ' + seminarEndDttmFmt + '</small>';	// 기간
                    html += '                   </p>';
                    html += '               </div>';
                    html += '			</div>';
                    html += '		</li>';
                    html += '	</ul>';
                    html += '</div>';
                }
            });
        }
        return html;
    }

    // 주차별 학습할것 목록
    function createLearnListHtml(data) {
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
            var itemBtnCls = "";

            if (key == "AEXAM") {
                data.listCrsHomeAExam.forEach(function (v, i) {
                    var examStartDttmFmt = getDateFmt(v.examStartDttm);
                    var examEndDttmFmt = getDateFmt(v.examEndDttm);

                    html += '<div class="content active">';
                    html += '    <ul class="each_lect_list">';
                    html += '        <li>';
                    html += '            <div class="each_lect_box" data-list-num="-">';
                    html += '                <div class="each_lect_tit">';
                    html += '                    <p>';
                    html += '                        <span class="ui brown small label"><spring:message code="crs.label.nomal_exam" /></span>';	// 수시평가
                    html += '                        <a href="javascript:joinAdmissionExam()">' + v.examTitle + '</a>';
                    html += '                    </p>';
                    html += '                    <p>';
                    html += '                        <small class="bullet_dot"><spring:message code="exam.label.period" /> : ' + examStartDttmFmt + ' ~ ' + examEndDttmFmt + '</small>';	// 기간
                    html += '                    </p>';
                    html += '                </div>';
                    html += '                <div class="button-area">';
                    if (v.examTypeCd == "QUIZ") {
                        //html += '				<button type="button" class="ui basic button small" onclick="joinAExamQuiz(\'' + v.examCd + '\');return false;">시험 응시</button>';
                        html += '				<button type="button" class="ui basic button small" onclick="joinAdmissionExam();return false;"><spring:message code="crs.button.exam" /><spring:message code="exam.button.stare.start" /></button>';	// 시험응시
                    } else if (v.examTypeCd == "EXAM") {
                        //html += '				<button type="button" class="ui basic button small" onclick="joinLiveExam(\'' + v.examStareTypeCd + '\', \'' + v.examCd + '\');return false;">시험 응시</button>';
                        html += '				<button type="button" class="ui basic button small" onclick="joinAdmissionExam();return false;"><spring:message code="crs.button.exam" /><spring:message code="exam.button.stare.start" /></button>';	// 시험응시
                    }
                    html += '                </div>';
                    html += '            </div>';
                    html += '        </li>';
                    html += '    </ul>';
                    html += '</div>';
                });
            } else if (key == "ASMNT") {
                data.listCrsHomeAsmnt.forEach(function (v, i) {
                    var open = '<spring:message code="message.open" />';			// 공개
                    var privates = '<spring:message code="message.private" />';	// 비공개
                    var sendStartDttmFmt = getDateFmt(v.sendStartDttm);
                    var asmntEndDttmFmt = getDateFmt(v.asmntEndDttm);

                    var scoreOpenYnText = v.scoreOpenYn == "Y" ? open : privates;
                    itemBtnCls = isKnou == "true" ? "pink" : "green";

                    html += '<div class="content active">';
                    html += '    <ul class="each_lect_list">';
                    html += '        <li>';
                    html += '            <div class="each_lect_box" data-list-num="-">';
                    html += '                <div class="each_lect_tit">';
                    html += '                    <p>';
                    html += '                        <span class="ui ' + itemBtnCls + ' small label"><spring:message code="filemgr.label.crsauth.asmt" /></span>';	// 과제
                    html += '                        <a href="javascript:joinAsmnt(\'' + v.asmntCd + '\')">' + v.asmntTitle + '</a>';
                    html += '                    </p>';
                    html += '                    <p>';
                    html += '                        <small class="bullet_dot"><spring:message code="exam.label.period" /> : ' + sendStartDttmFmt + ' ~ ' + asmntEndDttmFmt + '</small>';	// 기간
                    html += '					     <small class="bullet_dot"><spring:message code="asmnt.label.grade" /> : ' + scoreOpenYnText + '</small>';	// 성적
                    html += '                    </p>';
                    html += '                </div>';
                    html += '                <div class="button-area">';
                    html += '					<button type="button" class="ui basic button small" onclick="joinAsmnt(\'' + v.asmntCd + '\');return false;"><spring:message code="std.label.asmnt" /> <spring:message code="std.label.asmnt_submit" /></button>';	// 과제제출
                    html += '                </div>';
                    html += '            </div>';
                    html += '        </li>';
                    html += '    </ul>';
                    html += '</div>';
                });
            } else if (key == "FORUM") {
                data.listCrsHomeForum.forEach(function (v, i) {
                    var open = '<spring:message code="message.open" />';		// 공개
                    var privates = '<spring:message code="message.private" />';	// 비공개
                    var forumStartDttmFmt = getDateFmt(v.forumStartDttm);
                    var forumEndDttmFmt = getDateFmt(v.forumEndDttm);

                    var scoreOpenYnText = v.scoreOpenYn == "Y" ? open : privates;
                    itemBtnCls = isKnou == "true" ? "purple" : "yellow";

                    html += '<div class="content active">';
                    html += '    <ul class="each_lect_list">';
                    html += '        <li>';
                    html += '            <div class="each_lect_box" data-list-num="-">';
                    html += '                <div class="each_lect_tit">';
                    html += '                    <p>';
                    html += '                        <span class="ui ' + itemBtnCls + ' small label"><spring:message code="common.label.discussion" /></span>';	// 토론
                    html += '                        ' + v.forumTitle;
                    html += '                    </p>';
                    html += '                    <p>';
                    html += '                        <small class="bullet_dot"><spring:message code="exam.label.period" /> : ' + forumStartDttmFmt + ' ~ ' + forumEndDttmFmt + '</small>';	// 기간
                    html += '					     <small class="bullet_dot"><spring:message code="asmnt.label.grade" /> : ' + scoreOpenYnText + '</small>';	// 성적
                    html += '                    </p>';
                    html += '                </div>';
                    html += '                <div class="button-area">';
                    html += '					<button type="button" class="ui basic button small" onclick="joinForum(\'' + v.forumCd + '\');return false;"><spring:message code="std.label.forum" /> <spring:message code="std.label.forum_join_y" /></button>';	// 토론참여
                    html += '                </div>';
                    html += '            </div>';
                    html += '        </li>';
                    html += '    </ul>';
                    html += '</div>';
                });
            } else if (key == "QUIZ") {
                data.listCrsHomeQuiz.forEach(function (v, i) {
                    var open = '<spring:message code="message.open" />';			// 공개
                    var privates = '<spring:message code="message.private" />';	// 비공개
                    var examStartDttmFmt = getDateFmt(v.examStartDttm);
                    var examEndDttmFmt = getDateFmt(v.examEndDttm);

                    var scoreOpenYnText = v.scoreOpenYn == "Y" ? open : privates;

                    html += '<div class="content active">';
                    html += '    <ul class="each_lect_list">';
                    html += '        <li>';
                    html += '            <div class="each_lect_box" data-list-num="-">';
                    html += '                <div class="each_lect_tit">';
                    html += '                    <p>';
                    html += '                        <span class="ui orange small label"><spring:message code="std.label.quiz" /></span>';	// 퀴즈
                    if (PROFESSOR_VIRTUAL_LOGIN_YN == "Y") {
                        html += '					' + v.examTitle;
                    } else {
                        html += '					<a href="javascript:joinQuizView(\'' + v.examCd + '\')">' + v.examTitle + '</a>';
                    }
                    html += '                    </p>';
                    html += '                    <p>';
                    html += '                        <small class="bullet_dot"><spring:message code="exam.label.period" /> : ' + examStartDttmFmt + ' ~ ' + examEndDttmFmt + '</small>';	// 기간
                    html += '					     <small class="bullet_dot"><spring:message code="asmnt.label.grade" /> : ' + scoreOpenYnText + '</small>';	// 성적
                    html += '                    </p>';
                    html += '                </div>';
                    if (v.stareYn != "Y") {
                        html += '                <div class="button-area">';
                        html += '					<button type="button" class="ui basic button small ' + (PROFESSOR_VIRTUAL_LOGIN_YN == "Y" ? 'disabled' : '') + '" onclick="joinQuiz(\'' + v.examCd + '\');return false;"><spring:message code="std.label.quiz" /> <spring:message code="std.label.forum_join_y" /></button>';	// 퀴즈참여
                        html += '                </div>';
                    }
                    html += '            </div>';
                    html += '        </li>';
                    html += '    </ul>';
                    html += '</div>';
                });
            } else if (key == "RESCH") {
                data.listCrsHomeResch.forEach(function (v, i) {
                    var reshEdit = '<spring:message code="common.log.resh.edit" />';		// 설문 수정
                    var reshPartic = '<spring:message code="crs.button.resch.partic" />';	// 설문 참여
                    var reschStartDttmFmt = getDateFmt(v.reschStartDttm);
                    var reschEndDttmFmt = getDateFmt(v.reschEndDttm);
                    var reschCtgrCd = v.reschCtgrCd == null ? "" : v.reschCtgrCd;
                    itemBtnCls = isKnou == "true" ? "deepblue1" : "deepblue3";

                    html += '<div class="content active">';
                    html += '    <ul class="each_lect_list">';
                    html += '        <li>';
                    html += '            <div class="each_lect_box" data-list-num="-">';
                    html += '                <div class="each_lect_tit">';
                    html += '                    <p>';
                    html += '                        <span class="ui ' + itemBtnCls + ' small label"><spring:message code="resh.label.resh" /></span>';	// 설문
                    html += '                        <a href="javascript:joinResch(\'' + v.reschCd + '\', \'' + reschCtgrCd + '\', \'' + v.reschTypeCd + '\', \'' + v.reschJoinYn + '\')">' + v.reschTitle + '</a>';
                    html += '                    </p>';
                    html += '                    <p>';
                    html += '                        <small class="bullet_dot"><spring:message code="exam.label.period" /> : ' + reschStartDttmFmt + ' ~ ' + reschEndDttmFmt + '</small>';	// 기간
                    html += '					     <small class="bullet_dot"><spring:message code="resh.label.resh.result" /> : ' + v.reschRsltTypeNm + '</small>';	// 설문결과
                    html += '                    </p>';
                    html += '                </div>';
                    html += '                <div class="button-area">';
                    html += '					<button type="button" class="ui basic button small joinResch_' + v.reschCd + '" onclick="joinResch(\'' + v.reschCd + '\', \'' + reschCtgrCd + '\', \'' + v.reschTypeCd + '\', \'' + v.reschJoinYn + '\');return false;">';
                    html += (v.reschJoinYn == "Y" ? reshEdit : reshPartic);
                    html += '</button>';
                    html += '                </div>';
                    html += '            </div>';
                    html += '        </li>';
                    html += '    </ul>';
                    html += '</div>';
                });
            } else if (key == "SEMINAR") {
                data.listCrsHomeSeminar.forEach(function (v, i) {
                    // 교시에 속하지 않은 세미나만 출력
                    if (v.lessonTimeId != "") {
                        return;
                    }
                    var seminarStartDttmFmt = getDateFmt(v.seminarStartDttm);
                    var seminarEndDttmFmt = getDateFmt(v.seminarEndDttm);
                    var seminarTime = parseInt(v.seminarTime / 60) > 0 ? parseInt(v.seminarTime / 60) + "<spring:message code='seminar.label.time' />" + v.seminarTime % 60 + "<spring:message code='seminar.label.min' />" : v.seminarTime % 60 + "<spring:message code='seminar.label.min' />";	// 시간 분분

                    if (v.seminarCtgrCd == "online") {
                        html += '<div class="content active">';
                        html += '	<ul class="each_lect_list">';
                        html += '		<li>';
                        html += '			<div class="each_lect_tit">';
                        html += '				<div class="ui blue button p20  ' + (PROFESSOR_VIRTUAL_LOGIN_YN == "Y" ? 'disabled' : '') + '" onclick="seminarStart(\'' + v.seminarId + '\')">';
                        html += '					<i class="laptop icon f150"></i>';
                        html += '					<a class="tl fcWhite" href="javascript:void(0)"><spring:message code="seminar.button.video.seminar.part" /></a>';/* 화상세미나 참여하기 */
                        html += '				</div>';
                        html += '			</div>';
                        html += '			<div class="ml30">';
                        html += '				<p><small class="bullet_dot"><spring:message code="seminar.label.seminar.nm" /> : ' + v.seminarNm + '</small></p>';			// 세미나명
                        html += '				<p><small class="bullet_dot"><spring:message code="seminar.label.start.date" /> : ' + seminarStartDttmFmt + '</small></p>';	// 시작일시
                        html += '				<p><small class="bullet_dot"><spring:message code="seminar.label.progress.time" /> : ' + seminarTime + '</small></p>';			// 진행시간
                        html += '			</div>';
                        html += '		</li>';
                        html += '	</ul>';

                        html += '	<div class="bcBlueAlpha15 mt15 p10">';
                        html += '		<p><spring:message code="seminar.message.zoom.info1" /><!-- * [중요] 반드시 Zoom Meeting 프로그램을 실행하여 참가해 주세요. --></p>';
                        html += '		<p class="fcRed"><spring:message code="seminar.message.zoom.info2" /><!-- Zoom 프로그램이 아닌 브라우저 상의"브라우저에서 참가"를 클릭하여 입장한 경우에는 출결이 기록되지 않습니다. --></p>';
                        html += '	</div>';
                        html += '	<div class="ui segment">';
                        html += '		<p><spring:message code="seminar.message.zoom.info3" /><!-- * 참가에 실패하는 경우 --></p>';
                        html += '		<p><spring:message code="seminar.message.zoom.info4" /><!-- 화상강의 참가가 원할히 진행되지 않을 경우 아래 버튼을 클릭하여 시도할 수 있습니다. --></p>';
                        html += '		<p><spring:message code="seminar.message.zoom.info5" /><!-- 참가 등록 시 아래 표시된 본인 LMS 상의 이메일 주소를 입력해야 자동 출석인정 합니다. --></p>';
                        html += '		<a href="javascript:setEmailJoin(\'' + v.seminarId + '\')" class="ui black button mt10 mb10"><spring:message code="seminar.button.self.input.email.part" /><!-- 이메일 주소 직접 등록하여 참가 --></a>';
                        html += '		<p><spring:message code="seminar.message.zoom.info6" /><!-- 참가 등록시 입력할 이메일 주소 --> : <span class="fcBlue"><spring:message code="seminar.message.zoom.info7" /><!-- 학번@hycu.ac.kr --></span></p>';
                        html += '	</div>';


                        html += '	<div class="bcBlueAlpha15 mt15 p10">';
                        html += '		<p><spring:message code="seminar.message.zoom.info1" /><!-- * [중요] 반드시 Zoom Meeting 프로그램을 실행하여 참가해 주세요. --></p>';
                        html += '		<p class="fcRed"><spring:message code="seminar.message.zoom.info2" /><!-- Zoom 프로그램이 아닌 브라우저 상의"브라우저에서 참가"를 클릭하여 입장한 경우에는 출결이 기록되지 않습니다. --></p>';
                        html += '	</div>';
                        html += '	<div class="ui segment">';

                        html += '		<p><spring:message code="seminar.message.zoom.info3" /><!-- * 참가에 실패하는 경우 --></p>';
                        html += '		<p><spring:message code="seminar.message.zoom.info4" /><!-- 화상강의 참가가 원할히 진행되지 않을 경우 아래 버튼을 클릭하여 시도할 수 있습니다. --></p>';
                        html += '		<p><spring:message code="seminar.message.zoom.info5" /><!-- 참가 등록 시 아래 표시된 본인 LMS 상의 이메일 주소를 입력해야 자동 출석인정 합니다. --></p>';
                        html += '		<p class="mt10 mb10"><button type="button" onclick="setEmailJoin(\'' + v.seminarId + '\')" class="ui black small button  ' + (PROFESSOR_VIRTUAL_LOGIN_YN == "Y" ? 'disabled' : '') + '"><spring:message code="seminar.button.self.input.email.part" /><!-- 이메일 주소 직접 등록하여 참가 --></button></p>';
                        html += '		<p><spring:message code="seminar.message.zoom.info6" /><!-- 참가 등록시 입력할 이메일 주소 --> : <span class="fcBlue"><spring:message code="seminar.message.zoom.info7" /><!-- 학번@hycu.ac.kr --></span></p>';
                        html += '	</div>';
                        html += '</div>';
                    } else if (v.seminarCtgrCd == "offline") {
                        html += '<div class="content active">';
                        html += '	<ul class="each_lect_list">';
                        html += '		<li>';
                        html += '			<div class="each_lect_box" data-list-num="-">';
                        html += '				<div class="each_lect_tit">';
                        html += '					<p>';
                        html += '						<span class="ui deepblue1 small label"><spring:message code="sch.seminar" /></span>';	// 세미나
                        html += '						' + v.seminarNm;
                        html += '                   </p>';
                        html += '                   <p>';
                        html += '                       <small class="bullet_dot"><spring:message code="exam.label.period" /> : ' + seminarStartDttmFmt + ' ~ ' + seminarEndDttmFmt + '</small>';	// 기간
                        html += '                   </p>';
                        html += '               </div>';
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
    function createExamListHtml(examInfo, lessonScheduleInfo) {
        var examStartDttmFmt;
        var examEndDttmFmt;

        var examLabel = '';
        var title = '';
        var subTitle = '';
        var scoreOpenYnText = '';
        var examBtn = '';
        var examText = '';

        var html = '';

        // 실시간시험 || 시험(퀴즈, 과제, 토론)
        if (examInfo.examTypeCd == "EXAM" || (examInfo.examTypeCd == "QUIZ" && examInfo.examQuizCd) || (examInfo.examTypeCd == "ASMNT" && examInfo.examAsmntCd) || (examInfo.examTypeCd == "FORUM" && examInfo.examForumCd) || examInfo.examTypeCd == "ETC") {
            // 실시간시험
            if (examInfo.examTypeCd == "EXAM") {
                examStartDttmFmt = getDateFmt(examInfo.examStartDttm);
                examEndDttmFmt = getDateFmt(examInfo.examEndDttm);

                examLabel = "<spring:message code='filemgr.label.crsauth.exam' />";	// 시험
                title = examInfo.examTitle;
                subTitle = examInfo.examStareTm + "<spring:message code='seminar.label.min' />";	// 분
                examBtn = '<button type="button" class="ui button small blue" onclick="joinExam(\'' + examInfo.examCd + '\', \'' + examInfo.examStareTypeCd + '\', \'LIVE\')">시험응시</button>';
                /* 실시간 시험 준비중 (3주차 중 발표 예정) */
                examText = "<spring:message code='crs.label.live.exam' /> <spring:message code='common.ready' />(3<spring:message code='common.schedule.now' /> <spring:message code='common.announce.schedule' />)";
            }
            // 시험 퀴즈
            else if (examInfo.examTypeCd == "QUIZ") {
                examStartDttmFmt = getDateFmt(examInfo.examQuizStartDttm);
                examEndDttmFmt = getDateFmt(examInfo.examQuizEndDttm);

                xamLabel = "<spring:message code='exam.label.exam.quiz' />";		// 시험퀴즈
                title = examInfo.examQuizTitle;
                subTitle = examInfo.examStareTm + "<spring:message code='seminar.label.min' />";	// 분
                examBtn = '<button type="button" class="ui button small blue" onclick="joinExam(\'' + examInfo.examQuizCd + '\', \'' + examInfo.examStareTypeCd + '\', \'QUIZ\')"><spring:message code="std.label.quiz" /><spring:message code="std.label.forum_join_y" /></button>';	// 퀴즈참여
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
                examBtn = '<button type="button" class="ui button small blue" onclick="joinExam(\'' + examInfo.examAsmntCd + '\', \'' + examInfo.examStareTypeCd + '\', \'ASMNT\')"><spring:message code="std.label.asmnt" /><spring:message code="std.label.asmnt_submit" /></button>';
            }
            // 시험 토론
            else if (examInfo.examTypeCd == "FORUM") {
                var open = '<spring:message code="message.open" />';		// 공개
                var privates = '<spring:message code="message.private" />';	// 비공개
                examStartDttmFmt = getDateFmt(examInfo.examForumStartDttm);
                examEndDttmFmt = getDateFmt(examInfo.examForumEndDttm);

                scoreOpenYnText = examInfo.examForumScoreOpenYn == "Y" ? open : privates;

                examLabel = "<spring:message code='forum.label.type.exam' />";	// 시험토론
                title = examInfo.examForumTitle;
                subTitle = '<spring:message code="common.label.score" /> :' + scoreOpenYnText;// 성적
                examBtn = '<button type="button" class="ui button small blue" onclick="joinExam(\'' + examInfo.examForumCd + '\', \'' + examInfo.examStareTypeCd + '\', \'FORUM\')"><spring:message code="std.label.forum" /><spring:message code="std.label.forum_join_y" /></button>';
            }
            // 기타
            else if (examInfo.examTypeCd == "ETC") {
                examLabel = "<spring:message code='resh.label.etc' />";
                title = examInfo.examTitle;
                examText = "<spring:message code='resh.label.etc' />(<spring:message code='common.ready' />)";
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
            if (lessonScheduleInfo.lessonScheduleProgress == "PROGRESS") {
                html += '			<div class="button-area">';
                html += examBtn;
                html += '			</div>';
            }
            html += '		</li>';
            html += '	</ul>';
            html += '</div>';

            // 대체시험 (퀴즈, 과제, 토론)
            if (examInfo.examTypeCd == "EXAM" && examInfo.examAbsentApproveYn == "Y" && (examInfo.examQuizCd || examInfo.examAsmntCd || examInfo.examForumCd)) {
                if (examInfo.examQuizCd) {
                    var open = '<spring:message code="message.open" />';	// 공개
                    var privates = '<spring:message code="message.private" />';	// 비공개
                    examStartDttmFmt = getDateFmt(examInfo.examQuizStartDttm);
                    examEndDttmFmt = getDateFmt(examInfo.examQuizEndDttm);

                    scoreOpenYnText = examInfo.examQuizScoreOpenYn == "Y" ? open : privates;

                    examLabel = "<spring:message code='exam.label.subs.quiz' />";	// 대체퀴즈
                    title = examInfo.examQuizTitle;
                    subTitle = '<spring:message code="common.label.score" /> : ' + scoreOpenYnText;	// 성적
                    examBtn = '<button type="button" class="ui button small basic" onclick="joinExam(\'' + examInfo.examQuizCd + '\', \'' + examInfo.examStareTypeCd + '\', \'QUIZ\')"><spring:message code="std.label.quiz" /><spring:message code="std.label.forum_join_y" /></button>';
                } else if (examInfo.examAsmntCd) {
                    var open = '<spring:message code="message.open" />';	// 공개
                    var privates = '<spring:message code="message.private" />';	// 비공개
                    examStartDttmFmt = getDateFmt(examInfo.examAsmntSendStartDttm);
                    examEndDttmFmt = getDateFmt(examInfo.examAsmntSendEndDttm);

                    scoreOpenYnText = examInfo.examAsmntScoreOpenYn == "Y" ? open : privates;

                    examLabel = "<spring:message code='asmnt.label.subs.asmnt' />";	// 대체과제
                    title = examInfo.examAsmntTitle;
                    subTitle = '<spring:message code="common.label.score" /> : ' + scoreOpenYnText;	// 성적
                    examBtn = '<button type="button" class="ui button small basic" onclick="joinExam(\'' + examInfo.examAsmntCd + '\', \'' + examInfo.examStareTypeCd + '\', \'ASMNT\')"><spring:message code="std.label.asmnt" /><spring:message code="std.label.asmnt_submit" /></button>';
                } else if (examInfo.examForumCd) {
                    var open = '<spring:message code="message.open" />';	// 공개
                    var privates = '<spring:message code="message.private" />';	// 비공개
                    examStartDttmFmt = getDateFmt(examInfo.examForumStartDttm);
                    examEndDttmFmt = getDateFmt(examInfo.examForumEndDttm);

                    scoreOpenYnText = examInfo.examForumScoreOpenYn == "Y" ? open : privates;

                    examLabel = '<spring:message code="forum.label.type.subs" />';	// 대체토론
                    title = examInfo.examForumTitle;
                    subTitle = '<spring:message code="common.label.score" /> : ' + scoreOpenYnText;	// 성적
                    examBtn = '<button type="button" class="ui button small basic" onclick="joinExam(\'' + examInfo.examForumCd + '\', \'' + examInfo.examStareTypeCd + '\', \'FORUM\')"><spring:message code="std.label.forum" /><spring:message code="std.label.forum_join_y" /></button>';
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
                    html += '					<small class="bullet_dot">' + examInfo.examQuizExamStareTm + '<spring:message code="seminar.label.min" /></small>';	// 분
                }
                html += '					</p>';
                html += '				</div>';
                if (lessonScheduleInfo.lessonScheduleProgress == "PROGRESS") {
                    html += '			<div class="button-area">';
                    html += examBtn;
                    html += '			</div>';
                }
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
            html += '					<p class="fcDark9"><spring:message code="exam.label.empty.exam" /></p>';	/* 등록된 시험 정보가 없습니다. */
            html += '				</div>';
            html += '			</div>';
            html += '		</li>';
            html += '	</ul>';
            html += '</div>';
        }

        return html;
    }

    // 순차학습 학습여부 목록 조회
    function listSeqLessonCntsViewYn(lessonTimeId, lessonCntsId) {
        var url = "/lesson/lessonLect/listLessonCntsViewYn.do";
        var data = {
            crsCreCd: '<c:out value="${crsCreCd}" />'
            , stdNo: '<c:out value="${stdNo}" />'
            , lessonTimeId: lessonTimeId
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnList = data.returnList || [];
                var curIndex = 0;
                var isViewAble = true;

                returnList.forEach(function (v, i) {
                    if (v.lessonCntsId == lessonCntsId) {
                        curIndex = i;
                        return false;
                    }
                });

                if (curIndex != 0) {
                    for (var i = 0; i < curIndex; i++) {
                        if (returnList[i].viewYn == "N") {
                            isViewAble = false;

                            var order = i + 1;
                            var lessonCntsNm = returnList[i].lessonCntsNm || "";

                            if (lessonCntsNm) {
                                lessonCntsNm = "[" + lessonCntsNm + "]";
                            }

                            // var message = order + "번째 학습콘텐츠 " + lessonCntsNm + " 을(를) 먼저 학습해야 볼 수 있습니다.";
                            var message = order + "<spring:message code='crs.label.lecture.learn1' />" + lessonCntsNm + " <spring:message code='crs.label.lecture.learn2' />";
                            alert(message);
                            break;
                        }
                    }
                }

                if (!isViewAble) return;

                // TODO 동영상 OPEN
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            console.log('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
        });
    }

    // 퀴즈 참여
    function joinQuiz(examCd) {
        // 퀴즈 참여기간 체크
        checkStdExamStare(examCd).done(function () {
            quizCommon.initModal("joinInfo");
            $("#quizPopForm > input[name='examCd']").val(examCd);
            $("#quizPopForm").attr("target", "quizPopIfm");
            $("#quizPopForm").attr("action", "/quiz/quizJoinAlarmPop.do");
            $("#quizPopForm").submit();
            $('#quizPop').modal('show');
        });
    }

    // 퀴즈 정보
    function joinQuizView(examCd) {
        $("#quizPopForm > input[name='examCd']").val(examCd);
        $("#quizPopForm").attr("action", "/quiz/stuQuizView.do");
        $("#quizPopForm").submit();
    }

    // 과제 제출
    function joinAsmnt(asmntCd) {
        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "viewForm");
        form.attr("action", "/asmt/stu/asmtInfoManage.do");
        form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: 'stdNo', value: '<c:out value="${stdNo}" />'}));
        form.append($('<input/>', {type: 'hidden', name: 'asmntCd', value: asmntCd}));
        form.appendTo("body");
        form.submit();
    }

    // 토론 참여
    function joinForum(forumCd) {
        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "viewForm");
        form.attr("action", "/forum/forumHome/Form/forumView.do");
        form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: 'stdNo', value: '<c:out value="${stdNo}" />'}));
        form.append($('<input/>', {type: 'hidden', name: 'forumCd', value: forumCd}));
        form.appendTo("body");
        form.submit();
    }

    // 설문 참여
    function joinResch(reschCd, reschCtgrCd, reschTypeCd, reschJoinYn) {
        checkReschJoinAble(reschCd).done(function () {
            var reschPopupTitle;
            var url;

            if (reschTypeCd == "EVAL") {
                reschPopupTitle = "<spring:message code='resh.label.lect.eval' />"; // 강의평가
                url = "/resh/evalReshJoinPop.do";
            } else if (reschTypeCd == "LEVEL") {
                reschPopupTitle = "<spring:message code='resh.button.level.eval.join' />"; // 만족도조사 참여
                url = "/resh/evalReshJoinPop.do";
            } else {
                if (reschJoinYn == "Y") {
                    reschPopupTitle = "<spring:message code='common.log.resh.edit' />"; // 설문 수정
                    url = "/resh/reshEditPop.do";
                } else {
                    reschPopupTitle = "<spring:message code='resh.label.resh.join' />"; // 설문 참여
                    url = "/resh/reshJoinPop.do";
                }
            }
            $("#reschPopupTitle").text(reschPopupTitle);

            $("#reshJoinPopForm > input[name='reschCd']").val(reschCd);
            $("#reshJoinPopForm > input[name='reschCtgrCd']").val(reschCtgrCd);
            $("#reshJoinPopForm > input[name='userId']").val('<c:out value="${userId}" />');
            $("#reshJoinPopForm > input[name='stdNo']").val('<c:out value="${stdNo}" />');
            $("#reshJoinPopForm").attr("target", "reshJoinPopIfm");
            $("#reshJoinPopForm").attr("action", url);
            $("#reshJoinPopForm").submit();
            $('#reshJoinPop').modal('show');

            $("#reshJoinPopForm > input[name='reschCd']").val("");
            $("#reshJoinPopForm > input[name='reschCtgrCd']").val("");
            $("#reshJoinPopForm > input[name='userId']").val("");
            $("#reshJoinPopForm > input[name='stdNo']").val("");
        });
    }

    // 설문참여 콜백
    function saveReschCallback(data) {
        /* 설문에 참여하였습니다. */
        alert('<spring:message code="resh.error.resh.join" />');
        $('.modal').modal('hide');

        if (data && data.reschCd) {
            // 설문수정
            $(".joinResch_" + data.reschCd).text('<spring:message code="common.log.resh.edit" />');
            IS_REFERESH_ACTION = true;
        }
    }

    // 중간, 기말 시험 응시
    function joinExam(code, examStareTypeCd, examType) {
        if (examType == "LIVE") {
            var examCd = code;

            joinLiveExam();
        } else if (examType == "QUIZ") {
            //var examCd = code;
            //joinQuiz(examCd);
            joinLiveExam();
        } else if (examType == "ASMNT") {
            var asmntCd = code;
            joinAsmnt(asmntCd);
        } else if (examType == "FORUM") {
            var forumCd = code;
            joinForum(forumCd);
        }
    }

    // 실시간 시험 응시
    function joinLiveExam() {
        var url = "/exam/Form/stuExamList.do";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: "examType", value: "EXAM"}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }


    // 상시시험 응시
    function joinAdmissionExam() {
        var url = "/exam/Form/stuExamList.do";

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "moveform");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: "examType", value: "ADMISSION"}));
        form.appendTo("body");
        form.submit();

        $("form[name='moveform']").remove();
    }

    // 퀴즈/시험 응시가능 여부 체크
    function checkStdExamStare(examCd, reExamYn) {
        var deferred = $.Deferred();

        var url = "/quiz/checkStdExamStare.do";
        var data = {
            crsCreCd: '<c:out value="${crsCreCd}" />'
            , stdNo: '<c:out value="${stdNo}" />'
            , examCd: examCd
            , reExamYn: reExamYn
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                deferred.resolve();
            } else {
                alert(data.message);
                deferred.reject();
            }
        }, function (xhr, status, error) {
            console.log('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
            deferred.reject();
        });

        return deferred.promise();
    }

    // 설문 참여기간 체크
    function checkReschJoinAble(reschCd) {
        var deferred = $.Deferred();

        var url = "/resh/selectReshInfo.do";
        var data = {
            crsCreCd: '<c:out value="${crsCreCd}" />'
            , reschCd: reschCd
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnVO = data.returnVO;

                if (returnVO.reschStatus == "진행") {
                    deferred.resolve();
                } else {
                    /* 진행중인 설문이 아닙니다. */
                    alert('<spring:message code="resh.error.resh.not_ing" />');
                    deferred.reject();
                }
            } else {
                /* 설문 정보 조회중 오류가 발생하였습니다. */
                alert('<spring:message code="resh.error.resh.search.error" />');
                deferred.reject();
            }
        }, function (xhr, status, error) {
            console.log('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
            deferred.reject();
        });

        return deferred.promise();
    }

    // 서약서제출 팝업
    /*
    function submitOathPop(examCd) {
        var url = "/exam/viewOath.do";
        var data = {
            crsCreCd : '<c:out value="${crsCreCd}" />'
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnVO = data.returnVO;
				if(returnVO == null) {
					var kvArr = [];
					kvArr.push({'key' : 'examCd', 	'val' : examCd});
					kvArr.push({'key' : 'stdNo', 	'val' : "${stdNo}"});
					kvArr.push({'key' : 'crsCreCd', 'val' : "${crsCreCd}"});
					
					submitForm("/exam/examOathViewPop.do", "examPopIfm", "examOath", kvArr);
				} else {
					alert("<spring:message code='exam.alert.already.submit.oath' />");// 이미 서약서를 제출하였습니다.
				}
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.info' />");// 정보 조회 중 에러가 발생하였습니다.
		});
	}
	 */

    // 결시원신청 팝업
    function examAbsentPop(examCd, examStareTypeCd) {
        var url = "/jobSchHome/viewSysJobSch.do";
        var data = {
            orgId: '<c:out value="${orgId}" />'
            , crsCreCd: '<c:out value="${crsCreCd}" />'
            , haksaYear: '<c:out value="${termVO.haksaYear}" />'
            , haksaTerm: '<c:out value="${termVO.haksaTerm}" />'
            , calendarCtgr: "00190904"
            , useYn: "Y"
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnVO = data.returnVO;
                var jobSchPeriodYn = returnVO.jobSchPeriodYn;

                if (jobSchPeriodYn == "Y") {
                    examCommon.initModal("absentAppl");
                    $("#examAbsentApplicateForm > input[name=stdNo]").val('<c:out value="${stdNo}" />');
                    $("#examAbsentApplicateForm > input[name=crsCreCd]").val('<c:out value="${crsCreCd}" />');
                    $("#examAbsentApplicateForm > input[name=examCd]").val(examCd);
                    $("#examAbsentApplicateForm > input[name=searchMenu]").val(examStareTypeCd);
                    $("#examAbsentApplicateForm").attr("target", "examPopIfm");
                    $("#examAbsentApplicateForm").attr("action", "/exam/stuExamAbsentApplicatePop.do");
                    $("#examAbsentApplicateForm").submit();
                    $('#examPop').modal('show');

                    $("#examAbsentApplicateForm > input[name=stdNo]").val('');
                    $("#examAbsentApplicateForm > input[name=crsCreCd]").val('');
                    $("#examAbsentApplicateForm > input[name=examCd]").val('');
                    $("#examAbsentApplicateForm > input[name=searchMenu]").val('');
                } else {
                    alert("<spring:message code='exam.alert.absent.applicate.not.datetime' />");/* 결시원 신청은 신청기간 안에만 가능합니다. */
                }
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            console.log("<spring:message code='exam.error.info' />");/* 정보 조회 중 에러가 발생하였습니다. */
        });
    }

    // 결시원 신청 콜백
    function absentApplicateCallback() {
        closeModal();
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
                    url = "/seminar/seminarHome/zoomJoinStart.do";
                    data = {
                        seminarId: seminarId,
                        crsCreCd: "<c:out value='${crsCreCd}'/>",
                        stdNo: "<c:out value='${stdNo}' />"
                    }

                    ajaxCall(url, data, function (data) {
                        if (data.result > 0) {
                            if ("${IPHONE_YN}" == "Y") {
                                window.location.href = data.returnVO.joinUrl;
                            } else {
                                var windowOpener = window.open();
                                windowOpener.location = data.returnVO.joinUrl;
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

    // 이메일 직접 작성 후 참여
    function setEmailJoin(seminarId) {
        $("#selfEmailForm input[name=seminarId]").val(seminarId);
        $("#selfEmailForm input[name=crsCreCd]").val('<c:out value="${crsCreCd}" />');
        $("#selfEmailForm").attr("target", "seminarEmailPopIfm");
        $("#selfEmailForm").attr("action", "/seminar/seminarHome/stuSeminarSelfEmailPop.do");
        $("#selfEmailForm").submit();
        $('#seminarEmailPop').modal('show');
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
            document.location.href = ltNoteUrl
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
        <ul class="flex-tab week justify-content-around">
            <spring:message code="lesson.label.mid_short" var="label_mid_short"/>
            <spring:message code="lesson.label.final_short" var="label_final_short"/>

            <c:forEach items="${lessonScheduleList}" var="row">
                <c:set value="stuSttCd_${row.lessonScheduleId}" var="studyStatusCd"/>
                <c:set value="${row.lessonScheduleOrder}" var="weekTitle"/>
                <c:set var="ingClass" value=""/>
                <c:if test="${row.lessonScheduleProgress eq 'PROGRESS'}">
                    <c:set var="ingClass" value="state_now"/>
                </c:if>
                <c:choose>
                    <c:when test="${row.wekClsfGbn eq '04' || row.wekClsfGbn eq '05'}">
                        <c:choose>
                            <c:when test="${row.wekClsfGbn eq '04'}">
                                <c:set value="${label_mid_short}" var="weekTitle"/>
                            </c:when>
                            <c:when test="${row.wekClsfGbn eq '05'}">
                                <c:set value="${label_final_short}" var="weekTitle"/>
                            </c:when>
                        </c:choose>
                        <li class="<c:out value="${ingClass}"/> state_exam">
                            <a href="javascript:selectLessonSchedule('<c:out value="${row.lessonScheduleId}"/>')"
                               title="<c:out value="${weekTitle}"/>">
                                <span class="week"><c:out value="${weekTitle}"/></span><i class="ico"></i>
                            </a>
                        </li>
                    </c:when>
                    <c:when test="${!(row.wekClsfGbn eq '02' or row.wekClsfGbn eq '03') and row.prgrVideoCnt eq 0}">
                        <c:choose>
                            <c:when test="${row.startDtYn eq 'N'}">
                                <!-- 강의 시작일 전 -->
                                <li class="<c:out value="${ingClass}"/> state_wait">
                                    <a href="javascript:selectLessonSchedule('<c:out value="${row.lessonScheduleId}"/>')"
                                       title="<spring:message code="crs.label.ready" />"><!-- 대기 -->
                                        <span class="week"><c:out value="${weekTitle}"/></span><i class="ico"></i>
                                    </a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${row.startDtYn eq 'Y' and creCrsVO.grdtScYn eq 'Y' and row.videoCnt > 0}">
                                        <!-- 학습가능 -->
                                        <li class="<c:out value="${ingClass}"/> state_open2">
                                            <a href="javascript:selectLessonSchedule('<c:out value="${row.lessonScheduleId}"/>')"
                                               title="<spring:message code="std.label.study.possible" />(<spring:message code="lesson.label.stdy.prgr.n" />)">
                                                <!-- 학습가능 --><!-- 출결대상 아님 -->
                                                <span class="week"><c:out value="${weekTitle}"/></span><i
                                                    class="ico"></i>
                                            </a>
                                        </li>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="<c:out value="${ingClass}"/> state_exam">
                                            <a href="javascript:selectLessonSchedule('<c:out value="${row.lessonScheduleId}"/>')"
                                               title="<spring:message code="contents.label.null" />"><!-- 콘텐츠없음 -->
                                                <span class="week"><c:out value="${weekTitle}"/></span><i
                                                        class="ico"></i>
                                            </a>
                                        </li>
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:when test="${attendInfo.get(studyStatusCd) eq 'COMPLETE'}">
                        <li class="<c:out value="${ingClass}"/> state_ok">
                            <a href="javascript:selectLessonSchedule('<c:out value="${row.lessonScheduleId}"/>')"
                               title="<spring:message code="crs.label.end" />"><!-- 완료 -->
                                <span class="week"><c:out value="${weekTitle}"/></span><i class="ico"></i>
                            </a>
                        </li>
                    </c:when>
                    <c:when test="${attendInfo.get(studyStatusCd) eq 'LATE'}">
                        <li class="<c:out value="${ingClass}"/> state_norm">
                            <a href="javascript:selectLessonSchedule('<c:out value="${row.lessonScheduleId}"/>')"
                               title="<spring:message code="dashboard.state.late" />"><!-- 지각 -->
                                <span class="week"><c:out value="${weekTitle}"/></span><i class="ico"></i>
                            </a>
                        </li>
                    </c:when>
                    <c:when test="${row.startDtYn eq 'N'}">
                        <!-- 강의 시작일 전 -->
                        <li class="<c:out value="${ingClass}"/> state_wait">
                            <a href="javascript:selectLessonSchedule('<c:out value="${row.lessonScheduleId}"/>')"
                               title="<spring:message code="exam.label.ready" />"><!-- 대기 -->
                                <span class="week"><c:out value="${weekTitle}"/></span><i class="ico"></i>
                            </a>
                        </li>
                    </c:when>
                    <c:when test="${row.startDtYn eq 'Y' and row.endDtYn eq 'N'}">
                        <!-- 강의중 -->
                        <c:choose>
                            <c:when test="${row.wekClsfGbn eq '02'}">
                                <li class="<c:out value="${ingClass}"/> state_seminar">
                                    <a href="javascript:selectLessonSchedule('<c:out value="${row.lessonScheduleId}"/>')"
                                       title="<spring:message code="dashboard.online.seminar" />"><!-- 온라인 세미나 -->
                                        <span class="week"><c:out value="${weekTitle}"/></span><i class="ico"></i>
                                    </a>
                                </li>
                            </c:when>
                            <c:when test="${row.wekClsfGbn eq '03'}">
                                <li class="<c:out value="${ingClass}"/> state_seminar">
                                    <a href="javascript:selectLessonSchedule('<c:out value="${row.lessonScheduleId}"/>')"
                                       title="<spring:message code="dashboard.offline.seminar" />"><!-- 오프라인 세미나 -->
                                        <span class="week"><c:out value="${weekTitle}"/></span><i class="ico"></i>
                                    </a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <!-- 학습가능 -->
                                <li class="<c:out value="${ingClass}"/> state_open2">
                                    <a href="javascript:selectLessonSchedule('<c:out value="${row.lessonScheduleId}"/>')"
                                       title="<spring:message code="std.label.study.possible" />"><!-- 학습가능 -->
                                        <span class="week"><c:out value="${weekTitle}"/></span><i class="ico"></i>
                                    </a>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <!-- 강의 종료 -->
                        <c:set var="auditClass"><%="Y".equals(SessionInfo.getAuditYn(request)) ? "state_exam" : "state_bad" %>
                        </c:set>
                        <li class="<c:out value="${ingClass}"/> ${auditClass}">
                            <a href="javascript:selectLessonSchedule('<c:out value="${row.lessonScheduleId}"/>')"
                               title="<spring:message code="std.label.noattend" />">    <!-- 결석 -->
                                <span class="week"><c:out value="${weekTitle}"/></span><i class="ico"></i>
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </ul>
        <div class="learn_progress"
             style="<%=("mobile".equals(SessionInfo.getDeviceType(request)) ? "display:none" : "")%>">
            <div class="prog_box">
                <label for="myAverage_lect01" id="progBox1"><spring:message code="dashboard.my_prog" /><!-- 나의 진도율 -->
                    <i id="myProgInfo" class="icon circle info fcBlue opacity7 mr5" style="cursor: pointer"></i></label>
                <!-- 팝업 -->
                <div class="ui flowing popup left center transition hidden p10" id="myProgInfoPop">
                    <div class="w300">
                        <h3><i class="icon circle info fcBlue opacity7 mr5"></i>
                            <spring:message code="dashboard.my_prog" /><!-- 나의 진도율 --></h3>
                        <div class="ui message m0 mt10 p5">
                            <p class="fweb mb10 pt10 pl5 f080">
                                (<spring:message code="lesson.label.prog.guide1" /><!-- 수강완료 주차/강의오픈 주차 --> ) X 100%
                            </p>
                        </div>
                    </div>
                </div>
                <script>
                    $(function () {
                        $("#myProgInfo").popup({
                            popup: '#myProgInfoPop'
                            , hoverable: true
                            , position: 'top center'
                            , lastResort: true
                            , target: "#progBox1"
                            , on: "click"
                            , offset: -20
                        });
                    });
                </script>
                <fmt:parseNumber var="stdRate" value="${stdLessonProgress.stdRate}" integerOnly="true"/>
                <div class="ui indicating progress my_average" data-value="<c:out value="${stdRate}" />"
                     data-total="100" id="myAverage_lect01">
                    <div class="bar">
                        <div class="progress">0%</div>
                    </div>
                </div>
            </div>
            <div class="prog_box">
                <label for="allAverage_lect01" id="progBox2"><spring:message code="dashboard.all_prog" /><!-- 전체 진도율 -->
                    <i id="allProgInfo" class="icon circle info fcBlue opacity7 mr5"
                       style="cursor: pointer"></i></label>
                <!-- 팝업 -->
                <div class="ui flowing popup left center transition hidden p10" id="allProgInfoPop">
                    <div class="w300">
                        <h3><i class="icon circle info fcBlue opacity7 mr5"></i>
                            <spring:message code="dashboard.all_prog" /><!-- 전체 진도율 --></h3>
                        <div class="ui message m0 mt10 p5">
                            <p class="fweb mb10 pt10 pl5 f080">
                                <spring:message code="lesson.label.prog.guide2" /><!-- 수강생 전체의 --> (
                                <spring:message code="lesson.label.prog.guide1" /><!-- 수강완료 주차/강의오픈 주차 --> ) X 100%
                            </p>
                        </div>
                    </div>
                </div>
                <script>
                    $(function () {
                        $("#allProgInfo").popup({
                            popup: '#allProgInfoPop'
                            , hoverable: true
                            , position: 'top center'
                            , lastResort: true
                            , target: "#progBox2"
                            , on: "click"
                            , offset: -20
                        });
                    });
                </script>
                <fmt:parseNumber var="totalRate" value="${stdLessonProgress.totalRate}" integerOnly="true"/>
                <div class="ui indicating progress all_average" data-value="<c:out value="${totalRate}"/>"
                     data-total="100" id="allAverage_lect01">
                    <div class="bar">
                        <div class="progress">0%</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col">
        <div class="option-content header2"
             style="<%=("mobile".equals(SessionInfo.getDeviceType(request)) ? "display:none" : "")%>">
            <button class="ui basic small button" type="button" id="openCloseBtn" onclick="toggleLessonScheduleOpen()">
                <spring:message code="crs.label.week.all"/></button><!-- 전체주차 -->
            <button title="<spring:message code="crs.label.week.range" />" class="ui basic icon button ml_auto"
                    type="button" onclick="toggleLessonScheduleSortOrder(this)"><i class="sort amount up icon"></i>
            </button>
        </div>

        <!-- 주차 목록 -->
        <div id="lessonScheduleList" class="courseItemList timeline"></div>
    </div>
</div>


<!-- 강의보기 팝업 -->
<form id="lessonViewForm" name="lessonViewForm" method="post">
    <input type="hidden" name="crsCreCd" value="${crsCreCd}"/>
    <input type="hidden" name="lessonScheduleId" value=""/>
    <input type="hidden" name="lessonTimeId" value=""/>
    <input type="hidden" name="lessonCntsIdx" value=""/>
</form>
<div class="modal fade in" id="lessonViewModal" tabindex="-1" role="dialog" aria-labelledby="Dialog" aria-hidden="false"
     style="display: none; padding-right: 17px;">
    <div class="modal-dialog modal-extra-lg" role="document">
        <div class="modal-content">
            <div class="modal-header bcGreen">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title"><spring:message code="lesson.label.view.lesson"/></h4>
            </div>
            <div class="modal-body">
                <iframe src="" width="100%" id="lessonViewIfm" name="lessonViewIfm" style="min-height:800px"
                        title="lessonViewIfm"></iframe>
            </div>
        </div>
    </div>
</div>

<!-- 설문 참여 팝업 -->
<form id="reshJoinPopForm" name="reshJoinPopForm">
    <input type="hidden" name="reschCd" value=""/>
    <input type="hidden" name="reschCtgrCd" value=""/>
    <input type="hidden" name="userId" value=""/>
    <input type="hidden" name="stdNo" value=""/>
</form>
<div class="modal fade" id="reshJoinPop" tabindex="-1" role="dialog" aria-labelledby="" aria-hidden="false">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"
                        aria-label="<spring:message code="resh.button.close" />">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="reschPopupTitle"></h4>
            </div>
            <div class="modal-body">
                <iframe src="" id="reshJoinPopIfm" name="reshJoinPopIfm" width="100%" scrolling="no"
                        title="reshJoinPopIfm"></iframe>
            </div>
        </div>
    </div>
</div>

<!-- 퀴즈 & 상시시험 -->
<form id="quizPopForm" name="quizPopForm" method="POST">
    <input type="hidden" name="examCd" value=""/>
    <input type="hidden" name="stdNo" value="<c:out value="${stdNo}" />"/>
    <input type="hidden" name="crsCreCd" value="<c:out value="${crsCreCd}" />"/>
    <input type="hidden" name="goUrl" value="quizPopForm"/>
</form>

<!-- 결시원신청 -->
<form name="examAbsentApplicateForm" id="examAbsentApplicateForm" method="POST">
    <input type="hidden" name="stdNo"/>
    <input type="hidden" name="examCd"/>
    <input type="hidden" name="crsCreCd"/>
    <input type="hidden" name="searchMenu"/>
</form>

<!-- 서약서제출 -->
<!--
<form id="examOathPopForm" name="examOathPopForm" method="POST">
<input type="hidden" name="examCd" value="" />
<input type="hidden" name="stdNo" value="" />
<input type="hidden" name="crsCreCd" value="" />
</form>
-->

<!-- 세미나 이메일 입력 팝업 -->
<form id="selfEmailForm" method="POST">
    <input type="hidden" name="seminarId" value=""/>
    <input type="hidden" name="crsCreCd" value=""/>
</form>
<div class="modal fade" id="seminarEmailPop" tabindex="-1" role="dialog"
     aria-labelledby="<spring:message code="seminar.label.self.email.input" />" aria-hidden="false">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"
                        aria-label="<spring:message code="resh.button.close" />">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">
                    <spring:message code="seminar.label.self.email.input" /><!-- 화상회의 이메일 주소 직접 입력 후 참가하기 --></h4>
            </div>
            <div class="modal-body">
                <iframe src="" id="seminarEmailPopIfm" name="seminarEmailPopIfm" width="100%" scrolling="no"
                        title="seminarEmailPopIfm"></iframe>
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

        var iframeH = "99%";
        if (DEVICE_TYPE != undefined && DEVICE_TYPE == "mobile") {
            iframeH = "100%";
        }

        var url = "/crs/crsStdLessonView.do?crsCreCd=${crsCreCd}"
            + "&lessonScheduleId=" + lessonScheduleId + "&lessonTimeId=" + lessonTimeId + "&lessonCntsIdx=" + cntsIdx;

        document.location.href = url;

        /*
        lessonViewDialog = UiDialog("lessonView", modalTitle, "width="+popW+",height="+popH+",resizable=true,draggable=true,modal=true,fullscreen=true,fixfull="+fixfull+"", "lesson-view");
        lessonViewDialog.html("<iframe id='lessonViweFrame' frameborder='0' scrolling='auto' style='width:100%;height:"+iframeH+"' src=\""+url+"\" title='lessonViweFrame'></iframe>");
        lessonViewDialog.open();
        
        lessonViewDialog.on("dialogclose", function( event, ui ) {
        	$("#DIALOG_lessonView").remove();
        	
        	var url = "/logLesson/saveLessonActnHsty.do";
			var data = {
				  actnHstyCd	: "LESSON"
				, actnHstyCts	: modalTitle + " 종료"
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					document.location.reload();
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert('

        <spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
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

    $('iframe').iFrameResize([{checkOrigin: false, enablePublicMethods: true, heightCalculationMethod: 'max'}]);
    window.closeModal = function () {
        $('.modal').modal('hide');
    };
</script>