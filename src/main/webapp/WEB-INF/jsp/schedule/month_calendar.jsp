<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>

    <style type="text/css">
        /* [공통] 레이아웃 리셋 및 박스 사이징 규격화 */
        .table-wrap * { box-sizing: border-box; }
        .table-wrap { display: block; width: 100%; border: 1px solid #e1e1e1; background: #fff; }
        .table-wrap .cal-week { display: flex; width: 100%; }

        /* ==========================================
           1. 월별 보기 전용 스타일
           ========================================== */
        .table-wrap.month-mode .cal-weekdays { display: flex; width: 100%; border-bottom: 1px solid #e1e1e1; background: #f9f9f9; }
        .table-wrap.month-mode .cal-weekday { width: calc(100% / 7) !important; flex: 1 0 0; text-align: center; padding: 12px 0; font-weight: bold; border-right: 1px solid #e1e1e1; }
        .table-wrap.month-mode .cal-weekday:last-child { border-right: none; }
        
        .table-wrap.month-mode .cal-week { flex-direction: row; border-bottom: 1px solid #e1e1e1; }
        .table-wrap.month-mode .cal-week:last-child { border-bottom: none; }
        .table-wrap.month-mode .cal-day { width: calc(100% / 7) !important; flex: 1 0 0; min-height: 120px; padding: 10px; border-right: 1px solid #e1e1e1; display: block; }
        .table-wrap.month-mode .cal-day:last-child { border-right: none; }
        .table-wrap.month-mode .cal-events { display: block; margin-top: 5px; padding: 0; list-style: none; }

        /* ==========================================
           2. 주별 보기 전용 스타일 (좌우 분할 구조 적용)
           ========================================== */
        .table-wrap.vertical-mode { display: flex; flex-direction: row; border: none; background: transparent; gap: 15px; align-items: flex-start; }
        .table-wrap.vertical-mode .cal-weekdays { display: none !important; } 
        
        .table-wrap.vertical-mode .cal-week { display: flex; flex-direction: column; flex-grow: 1; gap: 10px; width: auto; }
        
        .table-wrap.vertical-mode .cal-day {
            width: 100% !important; 
            min-height: 90px !important; 
            padding: 15px 20px;
            border: 1px solid #e1e1e1;
            display: flex;
            flex-direction: row; 
            align-items: stretch; 
            border-radius: 4px;
            background: #fff;
        }
        
        .table-wrap.vertical-mode .cal-day .day-header-box {
            width: 140px;
            flex-shrink: 0;
            display: flex;
            flex-direction: row;       
            align-items: center;       
            justify-content: flex-start;
            gap: 8px;
            white-space: nowrap;       
            overflow: visible;
        }
        
        .table-wrap.vertical-mode .cal-day .cal-date {
            font-size: 20px;
            font-weight: bold;
            color: #333;
            display: inline-block;
            line-height: 1;
        }
        
        .table-wrap.vertical-mode .cal-day .cal-day-txt {
            font-size: 13px;
            color: #777;
            display: inline-block;
            line-height: 1;
        }
        
        .table-wrap.vertical-mode .cal-day.sun .cal-date,
        .table-wrap.vertical-mode .cal-day.sun .cal-day-txt { color: #ef4444; }
        .table-wrap.vertical-mode .cal-day.sat .cal-date,
        .table-wrap.vertical-mode .cal-day.sat .cal-day-txt { color: #3b82f6; }
        
        .table-wrap.vertical-mode .cal-day.today .cal-date {
            background: #2563eb !important; 
            color: #fff !important;
            border-radius: 50%;
            width: 32px;
            height: 32px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 16px; 
        }
        
        .table-wrap.vertical-mode .cal-events {
            flex-grow: 1;
            margin: 0 !important;
            padding: 5px 0 5px 25px;
            border-left: 2px solid #eee; 
            display: block;
            list-style: none;
            min-height: 50px; 
        }
        .table-wrap.vertical-mode .cal-events li {
            margin-bottom: 8px;
            display: flex;
            align-items: center;
        }
        .table-wrap.vertical-mode .cal-events li:last-child { margin-bottom: 0; }

        /* ==========================================
           3. 날짜 목록 왼쪽에 고정 배치되는 세로 주차 버튼 그룹
           ========================================== */
        .cal-week-selector { 
            display: none; 
            flex-direction: column; 
            gap: 8px; 
            width: 100px; 
            flex-shrink: 0;
            background: #fff;
            border: 1px solid #e1e1e1;
            padding: 10px;
            border-radius: 4px;
        }
        .cal-week-selector .btn-week { 
            width: 100%;
            padding: 10px 0; 
            font-size: 14px; 
            border: 1px solid #e1e1e1; 
            background: #f9f9f9; 
            color: #555; 
            border-radius: 4px; 
            cursor: pointer; 
            text-align: center;
            transition: all 0.2s ease;
        }
        .cal-week-selector .btn-week:hover { background: #eee; }
        .cal-week-selector .btn-week.active { 
            background: #2563eb; 
            color: #fff; 
            border-color: #2563eb; 
            font-weight: bold; 
        }

        /* ==========================================
           4. 모달 팝업 가시성 및 디테일 스타일링
           ========================================== */
        .modal-overlay {
            display: none; 
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 9999;
            align-items: center;
            justify-content: center;
        }
        .modal-overlay.active { display: flex !important; }
        
        .modal-content { background: #fff; width: 520px; max-width: 95%; border-radius: 6px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.2); }
        .modal-body { padding: 25px; }
        .modal-title-area { margin-bottom: 15px; border-bottom: 1px solid #eee; padding-bottom: 10px; }
        .modal-title-area h3 { font-size: 18px; font-weight: bold; color: #111; margin: 0; }
        .mb10 { margin-bottom: 10px; }
        .lecture_box { padding: 15px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 4px; line-height: 1.6; color: #475569; font-size: 14px; white-space: pre-wrap; word-break: break-all; }
        .modal_btns { margin-top: 20px; text-align: right; }
        .modal_btns .btn { padding: 8px 18px; border-radius: 4px; cursor: pointer; border: 1px solid #cbd5e1; background: #fff; }
        .modal_btns .btn.type2 { background: #64748b; color: #fff; border-color: #64748b; }
    </style>

    <script type="text/javascript">
    var currentYear = 2026;
    var currentMonth = 6; 
    var currentDay = 17;        
    var currentViewType = "VIEW_MONTH"; 

    var currentSbjctId = "${vo.sbjctId}"; 
    var weekDayNames = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
    
    // 전역 배열 백업 공간
    window.currentScheduleList = [];

    $(document).ready(function() {
        var placeholderText = "<spring:message code='sch.cal_lesson'/><spring:message code='sch.cal_schedule'/><spring:message code='common.label.nm'/><spring:message code='common.label.input'/>";
        $('#searchValue').attr('placeholder', placeholderText);

        var today = new Date();
        currentYear = today.getFullYear();
        currentMonth = today.getMonth() + 1;
        currentDay = today.getDate();
        
        myScheduleList();

        $('.btn-today').on('click', function() {
            var now = new Date();
            currentYear = now.getFullYear();
            currentMonth = now.getMonth() + 1;
            currentDay = now.getDate();
            myScheduleList();
        });

        $('.btn-prev').on('click', function() {
            if (currentViewType === "VIEW_MONTH") {
                currentMonth--;
                if (currentMonth < 1) { currentMonth = 12; currentYear--; }
            } else {
                var prevWeek = new Date(currentYear, currentMonth - 1, currentDay - 7);
                currentYear = prevWeek.getFullYear();
                currentMonth = prevWeek.getMonth() + 1;
                currentDay = prevWeek.getDate();
            }
            myScheduleList();
        });

        $('.btn-next').on('click', function() {
            if (currentViewType === "VIEW_MONTH") {
                currentMonth++;
                if (currentMonth > 12) { currentMonth = 1; currentYear++; }
            } else {
                var nextWeek = new Date(currentYear, currentMonth - 1, currentDay + 7);
                currentYear = nextWeek.getFullYear();
                currentMonth = nextWeek.getMonth() + 1;
                currentDay = nextWeek.getDate();
            }
            myScheduleList();
        });

        $('.cal-view-toggle button').on('click', function() {
            $('.cal-view-toggle button').removeClass('type1');
            $(this).addClass('type1');
            
            var viewText = $(this).text().trim();
            currentViewType = (viewText === "월별") ? "VIEW_MONTH" : "VIEW_WEEK";
            
            myScheduleList(); 
        });

        /* 주차 버튼 클릭 이벤트 */
        $(document).on('click', '.btn-week', function() {
            var weekNum = $(this).data('week'); 
            
            var firstDayOfMonth = new Date(currentYear, currentMonth - 1, 1);
            var startDayOfWeek = firstDayOfMonth.getDay(); 
            
            var targetSundayDate = 1 - startDayOfWeek + (weekNum - 1) * 7;
            var targetDate = new Date(currentYear, currentMonth - 1, targetSundayDate + 3);
            
            currentYear = targetDate.getFullYear();
            currentMonth = targetDate.getMonth() + 1;
            currentDay = targetDate.getDate();
            
            myScheduleList();
        });
        
        /* 🛠️ EgovMap 기준(소문자/카멜케이스) 모달 오픈 매핑 */
        $(document).on('click', '.cal-day .ev-link', function(e) {
            e.preventDefault(); 
            
            var idx = $(this).attr('data-idx');
            if(idx === undefined || idx === null) return;
            
            var item = window.currentScheduleList[parseInt(idx, 10)];
            if(!item) return;
            
            // 🛠️ EgovMap 변환 특성(대소문자 혼재 및 카멜케이스) 완전 방어코드
            var title = item.nm || item.NM || "지정된 일정명 없음";
            var typeNm = item.schdlTynm || item.schdl_tynm || item.SCHDL_TYNM || "기타";
            var sDttm = item.sdttm || item.SDTTM || ""; 
            var eDttm = item.edttm || item.EDTTM || ""; 
            var expln = item.expln || item.EXPLN || "등록된 상세 내용이 없습니다.";

            // 날짜 출력 포맷터 (숫자만 추출 후 변환)
            var formatDateTime = function(str) {
                if(!str) return "-";
                str = String(str).replace(/[^0-9]/g, ""); 
                if(str.length < 8) return "-";
                var ymd = str.substring(0,4) + "." + str.substring(4,6) + "." + str.substring(6,8);
                if(str.length >= 12) {
                    return ymd + " " + str.substring(8,10) + ":" + str.substring(10,12);
                }
                return ymd;
            };

            var startFormatted = formatDateTime(sDttm);
            var endFormatted = formatDateTime(eDttm);
            var fullPeriod = startFormatted + " ~ " + endFormatted;

            $('#modal-target-title').text("[" + typeNm + "] " + title);
            $('#modal-target-date').text(fullPeriod);
            $('#modal-target-expln').html(expln.replace(/\n/g, '<br>')); 
            
            $('#modal1').addClass('active'); 
        });

        /* 하단 오리지널 단독 버튼 클릭 시 */
        $('#btn-modal1').on('click', function() {
            $('#modal-target-title').text("수업일정 전체 안내");
            $('#modal-target-date').text("학기 중 상시");
            $('#modal-target-expln').text("본 수업 일정은 학사 운영 사정에 따라 일부 변경될 수 있습니다.");
            $('#modal1').addClass('active');
        });

        /* 모달 내부 '닫기' 버튼 클릭 시 닫기 */
        $('#modal1 .modal_btns .btn.type2').on('click', function() {
            $('#modal1').removeClass('active');
        });

        /* 모달 검은 배경 바탕 클릭 시 닫기 */
        $('#modal1').on('click', function(e) {
            if ($(e.target).is('#modal1')) {
                $('#modal1').removeClass('active');
            }
        });
    });

    function myScheduleList() {
        var strMonth = currentMonth < 10 ? "0" + currentMonth : currentMonth;
        
        var param = {
            sbjctId: currentSbjctId,
            viewTycd: currentViewType,
            searchValue: $('#searchValue').val(),
            encParams: '<c:out value="${encParams}" />'
        };

        $.ajax({
            url: "/schedule/myScheduleList.do",
            type: "POST",
            data: param,
            dataType: "json",
            success: function(response) {
                if (currentViewType === "VIEW_MONTH") {
                    $('.cal-period').text(currentYear + "." + strMonth);
                    $('.table-wrap').removeClass('vertical-mode').addClass('month-mode');
                    $('.cal-week-selector').css('display', 'none'); 
                } else {
                    $('.cal-period').text(currentYear + "." + strMonth + " (주별)");
                    $('.table-wrap').removeClass('month-mode').addClass('vertical-mode');
                    $('.cal-week-selector').css('display', 'flex'); 
                    
                    updateActiveWeekButton();
                }
                
                $('.table-wrap').attr('aria-label', currentYear + "년 " + currentMonth + "월 수업일정");
                
                var list = (response && response.returnList) ? response.returnList : [];
                
                window.currentScheduleList = list;
                buildCalendar(currentYear, currentMonth, list);
            },
            error: function(xhr, status, error) {
                alert("일정 목록을 가져오는 중 오류가 발생했습니다.");
            }
        });
    }

    function updateActiveWeekButton() {
        var firstDayOfMonth = new Date(currentYear, currentMonth - 1, 1);
        var startDayOfWeek = firstDayOfMonth.getDay();
        
        var currentTarget = new Date(currentYear, currentMonth - 1, currentDay);
        var dayOfWeek = currentTarget.getDay();
        var sundayDate = currentDay - dayOfWeek;
        
        var calculatedWeek = Math.floor((sundayDate + startDayOfWeek - 1) / 7) + 1;
        
        $('.btn-week').removeClass('active');
        if(calculatedWeek >= 1 && calculatedWeek <= 5) {
            $('.btn-week[data-week="' + calculatedWeek + '"]').addClass('active');
        }
    }

    function buildCalendar(year, month, scheduleList) {
        var $tableWrap = $('.table-wrap');
        $tableWrap.find('.cal-week').remove();
        var html = "";

        if (currentViewType === "VIEW_WEEK") {
            html += '<div class="cal-week" role="row">';
            
            var currentTarget = new Date(year, month - 1, currentDay);
            var dayOfWeek = currentTarget.getDay(); 
            var sundayIdx = currentDay - dayOfWeek;
            
            for (var j = 0; j < 7; j++) {
                var weekDate = new Date(year, month - 1, sundayIdx + j);
                var wYear = weekDate.getFullYear();
                var wMonth = weekDate.getMonth() + 1;
                var wDate = weekDate.getDate();
                var wDayNum = weekDate.getDay(); 
                
                var dayClass = "";
                if (wDayNum === 0) dayClass = "sun";
                if (wDayNum === 6) dayClass = "sat";
                if (wMonth !== month) dayClass += " other-month";
                
                var today = new Date();
                if (today.getFullYear() === wYear && (today.getMonth() + 1) === wMonth && today.getDate() === wDate) {
                    dayClass += " today";
                }
                
                var matchDateStr = wYear + "" + (wMonth < 10 ? "0" + wMonth : wMonth) + "" + (wDate < 10 ? "0" + wDate : wDate);
                
                html += '<div class="cal-day ' + dayClass + '" role="gridcell" data-date="' + matchDateStr + '">';
                html += '   <div class="day-header-box">';
                html += '       <span class="cal-date">' + wDate + '</span>';
                html += '       <span class="cal-day-txt">' + weekDayNames[wDayNum] + '</span>';
                html += '   </div>';
                html += '   <ul class="cal-events"></ul>'; 
                html += '</div>';
            }
            html += '</div>';
        } 
        else {
            var firstDay = new Date(year, month - 1, 1);
            var lastDay = new Date(year, month, 0);       
            var startDayOfWeek = firstDay.getDay();       
            var totalDays = lastDay.getDate();            
            var prevLastDay = new Date(year, month - 1, 0).getDate();

            var dateCounter = 1;
            var nextMonthCounter = 1;

            for (var i = 0; i < 6; i++) {
                if (dateCounter > totalDays) break; 

                html += '<div class="cal-week" role="row">';
                for (var j = 0; j < 7; j++) {
                    var cellIndex = i * 7 + j;

                    if (cellIndex < startDayOfWeek) {
                        var prevDate = prevLastDay - (startDayOfWeek - cellIndex - 1);
                        var isSun = (j === 0) ? "sun" : "";
                        html += '<div class="cal-day other-month ' + isSun + '" role="gridcell"><span class="cal-date">' + prevDate + '</span></div>';
                    } 
                    else if (dateCounter > totalDays) {
                        var isSat = (j === 6) ? "sat" : "";
                        html += '<div class="cal-day other-month ' + isSat + '" role="gridcell"><span class="cal-date">' + nextMonthCounter + '</span></div>';
                        nextMonthCounter++;
                    } 
                    else {
                        var dayClass = "";
                        if (j === 0) dayClass = "sun";
                        if (j === 6) dayClass = "sat";

                        var today = new Date();
                        if (today.getFullYear() === year && (today.getMonth() + 1) === month && today.getDate() === dateCounter) {
                            dayClass += " today";
                        }

                        var matchDateStr = year + "" + (month < 10 ? "0" + month : month) + "" + (dateCounter < 10 ? "0" + dateCounter : dateCounter);

                        html += '<div class="cal-day ' + dayClass + '" role="gridcell" data-date="' + matchDateStr + '">';
                        html += '   <span class="cal-date">' + dateCounter + '</span>';
                        html += '   <ul class="cal-events"></ul>'; 
                        html += '</div>';

                        dateCounter++;
                    }
                }
                html += '</div>';
            }
        }

        $tableWrap.append(html);

        if (scheduleList && scheduleList.length > 0) {
            renderScheduleData(scheduleList);
        }
    }

    /* 🛠️ EgovMap 맞춤형 렌더러 (하이드레이션 예외처리 및 소문자 우선순위 바인딩) */
    function renderScheduleData(list) {
    	$.each(list, function(index, item) {
            // 🛠️ EgovMap 소문자/카멜케이스 프로퍼티 우선 적용
            var rawDate = item.sdttm || item.SDTTM;
            var typeNm = item.schdlTynm || item.schdl_tynm || item.SCHDL_TYNM || "기타";
            var title = item.nm || item.NM || "지정된 일정명 없음";

            if (rawDate) {
                // 날짜 포맷이 '2026-06-18' 이든 '20260618103000' 이든 숫자만 8자리 깔끔하게 추출
                var cleanDate = String(rawDate).replace(/[^0-9]/g, "");
                if (cleanDate.length >= 8) {
                    var targetDate = cleanDate.substring(0, 8); 
                    var $dayCell = $('.cal-day[data-date="' + targetDate + '"]');
                    
                    if ($dayCell.length > 0) {
                        var dotColor = "dot-gray"; 
                        
                        switch(typeNm) {
                            case "과제": dotColor = "dot-red"; break;
                            case "토론": dotColor = "dot-orange"; break;
                            case "시험":
                            case "퀴즈": dotColor = "dot-purple"; break;
                            case "설문": dotColor = "dot-green"; break;
                            case "세미나": dotColor = "dot-blue"; break;
                            case "학사일정": dotColor = "dot-black"; break;
                            default: dotColor = "dot-gray"; break;
                        }

                        var eventHtml = '<li>' +
                                        '   <span class="dot ' + dotColor + '"></span>' +
                                        '   <a href="#0" class="ev-link" title="' + title + '" data-idx="' + index + '">' +
                                        '       <span class="ev-label">[' + typeNm + ']</span>' +
                                        '       <span class="ev-title">' + title + '</span>' +
                                        '   </a>' +
                                        '</li>';
                        
                        $dayCell.find('.cal-events').append(eventHtml);
                    }
                }
            }
        });
    }
    </script>
</head>

<body class="class ${uiex:getTheme()}">
    <div id="wrap" class="main">
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>

        <main class="common">
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>

            <div id="content" class="content-wrap common">
                <jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>

                <div class="class_sub">
                    <jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">
                                <spring:message code="sch.cal_lesson" />
                                <spring:message code="sch.cal_schedule" />
                            </h2>
                        </div>
                        
                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="searchValue"><spring:message code='common.search.keyword'/></label></span>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" id="searchValue" value="${vo.searchValue}" 
                                           onkeydown="if(event.keyCode==13) { myScheduleList(); return false; }">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="myScheduleList()"><spring:message code='button.search'/></button>
                            </div>
                        </div>
                                
                        <div class="schedule-calendar">
                            <div class="cal-toolbar">
                                <div class="cal-toolbar-left">
                                    <button type="button" class="btn btn-today">오늘</button>
                                </div>
                                <div class="cal-toolbar-center">
                                    <div class="cal-nav">
                                        <button type="button" class="btn-prev prev" aria-label="이전"><i class="xi-angle-left" aria-hidden="true"></i></button>
                                        <strong class="cal-period">2026.06</strong>
                                        <button type="button" class="btn-next" aria-label="다음"><i class="xi-angle-right" aria-hidden="true"></i></button>
                                    </div>
                                </div>
                                <div class="cal-toolbar-right">
                                    <div class="cal-view-toggle" role="tablist" aria-label="보기 전환">
                                        <button type="button" class="btn" role="tab" aria-selected="false">주별</button>
                                        <button type="button" class="btn type1" role="tab" aria-selected="true">월별</button>
                                    </div>
                                    <c:if test="${userCtx.loginUser.userTycd eq 'PROF'}">
                                    	<button type="button" class="btn type1 btnPlus"><i class="xi-plus"></i></button>
                                    </c:if>
                                </div>
                            </div>

                            <div class="table-wrap month-mode" role="grid" aria-label="수업일정">
                                
                                <div class="cal-week-selector">
                                    <button type="button" class="btn-week" data-week="1">1주</button>
                                    <button type="button" class="btn-week" data-week="2">2주</button>
                                    <button type="button" class="btn-week" data-week="3">3주</button>
                                    <button type="button" class="btn-week" data-week="4">4주</button>
                                    <button type="button" class="btn-week" data-week="5">5주</button>
                                </div>

                                <div class="cal-weekdays" role="row">
                                    <div class="cal-weekday sun" role="columnheader">일</div>
                                    <div class="cal-weekday" role="columnheader">월</div>
                                    <div class="cal-weekday" role="columnheader">화</div>
                                    <div class="cal-weekday" role="columnheader">수</div>
                                    <div class="cal-weekday" role="columnheader">목</div>
                                    <div class="cal-weekday" role="columnheader">금</div>
                                    <div class="cal-weekday sat" role="columnheader">토</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <div class="modal-overlay" id="modal1">
            <div class="modal-content">
                <div class="modal-body">
                    <div class="modal-title-area">
                        <h3 id="modal-target-title">수업일정 상세 안내</h3>
                    </div>
                    <div class="search-typeA mb10">
                        <div class="item">
                            <strong>기간</strong> <span id="modal-target-date">-</span>
                        </div>
                    </div>
                    
                    <div class="lecture_box" id="modal-target-expln">
                        등록된 세부 내용이 없습니다.
                    </div>

                    <div class="modal_btns">
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>
        </div>
</body>
</html>