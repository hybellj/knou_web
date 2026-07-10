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
           4. 모달 팝업 및 우측 상단 X 버튼 스타일
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
        
        .modal-content { position: relative; background: #fff; width: 520px; max-width: 95%; border-radius: 6px; overflow: visible; box-shadow: 0 4px 15px rgba(0,0,0,0.2); }
        .modal-content.wide { width: 850px; max-width: 95%; } 
        
        /* 우측 상단 X 버튼 */
        .btn-modal-close-x {
            position: absolute;
            top: 15px;
            right: 20px;
            background: transparent;
            border: none;
            font-size: 24px;
            color: #666;
            cursor: pointer;
            z-index: 10;
            padding: 5px;
            line-height: 1;
        }
        .btn-modal-close-x:hover { color: #000; }

        .modal-body { padding: 25px; }
        .modal-title-area { margin-bottom: 15px; border-bottom: 1px solid #eee; padding-bottom: 10px; padding-right: 40px; }
        .modal-title-area h3 { font-size: 18px; font-weight: bold; color: #111; margin: 0; }
        .mb10 { margin-bottom: 10px; }
        .lecture_box { padding: 15px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 4px; line-height: 1.6; color: #475569; font-size: 14px; white-space: pre-wrap; word-break: break-all; }
        
        .modal_btns { margin-top: 20px; text-align: right; }
        .modal_btns .btn { padding: 8px 18px; border-radius: 4px; cursor: pointer; border: 1px solid #cbd5e1; background: #fff; }
        .modal_btns .btn.type1 { background: #2563eb; color: #fff; border-color: #2563eb; margin-right: 5px; }
        .modal_btns .btn.type2 { background: #64748b; color: #fff; border-color: #64748b; }
        .modal_btns .btn.btn-edit { background: #e2e8f0; color: #1e293b; border-color: #cbd5e1; margin-right: 5px; font-weight: bold; }
        .modal_btns .btn.btn-delete { background: #ef4444; color: #fff; border-color: #ef4444; margin-right: 5px; font-weight: bold; }

        /* 팝업 내부 테이블 전용 클래스 */
        .popup-table-wrap { display: block; width: 100%; margin-bottom: 15px; }
        .width-50per { width: 50% !important; }
        .date_area { display: flex; align-items: center; gap: 5px; flex-wrap: wrap; }
        .date_area input { padding: 6px 10px; border: 1px solid #cbd5e1; border-radius: 4px; width: 110px; }
        .date_area .txt-sort { padding: 0 5px; }
        .editor-box { margin-top: 5px; }
        .editor-links { margin-top: 8px; font-size: 13px; }
        .editor-links a { color: #2563eb; text-decoration: underline; margin-right: 10px; }
    </style>

    <script type="text/javascript">
    var currentYear = 2026;
    var currentMonth = 6; 
    var currentDay = 17;        
    var currentViewType = "VIEW_MONTH"; 
    var currentSbjctId = "${vo.sbjctId}"; 
    var smstrChrtId = "${vo.smstrChrtId}"; 
    var weekDayNames = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
    
    window.currentScheduleList = [];
    var currentActiveIdx = null; 
    let editor; 
    var loginUserTycd = "${userCtx.loginUser.userTycd}"; 

    $(document).ready(function() {
        var placeholderText = "<spring:message code='sch.cal_lesson'/><spring:message code='sch.cal_schedule'/><spring:message code='common.label.nm'/><spring:message code='common.label.input'/>";
        $('#searchInputValue').attr('placeholder', placeholderText);

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
        
        /* [교수 권한] 신규 등록(+) 버튼 클릭 */
        $(document).on('click', '.btnPlus', function() {
            currentActiveIdx = null; 
            initDatePicker();
            $('#modal2 .modal-title-area h3').text('수업일정 등록');
            
            // 등록 가동 시 잔존 수정 ID 초기화
            $('#modal2').removeData('schdlId');
            
            $('#name_label').val('');
            $('#datepickerStart').val('');
            $('#timepickerStart').val('');
            $('#datepickerEnd').val('');
            $('#timepickerEnd').val('');
            if (editor && typeof editor.openHTML === "function") {
                editor.openHTML(""); 
            }
            $('#modal2').addClass('active'); 
        });
        
        /* 일정 클릭 -> 상세 팝업 오픈 */
        $(document).on('click', '.cal-day .ev-link', function(e) {
            e.preventDefault(); 
            var idx = $(this).attr('data-idx');
            if(idx === undefined || idx === null) return;
            
            currentActiveIdx = parseInt(idx, 10); 
            var item = window.currentScheduleList[currentActiveIdx];
            if(!item) return;
            
            var title = item.nm || item.NM || "지정된 일정명 없음";
            var typeNm = item.schdlTynm || item.schdl_tynm || item.SCHDL_TYNM || "기타";
            var sDttm = item.sdttm || item.SDTTM || ""; 
            var eDttm = item.edttm || item.EDTTM || ""; 
            var expln = item.expln || item.EXPLN || "등록된 상세 내용이 없습니다.";

            // 🛠️ 교수('PROF') 권한이며 유형 이름이 정확히 '일정'일 경우에만 수정/삭제 개방
            if (loginUserTycd === "PROF" && typeNm === "일정") {
                $('.btn-edit').show();
                $('.btn-delete').show();
                $('.btn-close-pop').hide();
            } else {
                $('.btn-edit').hide();
                $('.btn-delete').hide();
                $('.btn-close-pop').show();
            }

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

            $('#modal-target-title').text("[" + typeNm + "] " + title);
            $('#modal-target-date').text(formatDateTime(sDttm) + " ~ " + formatDateTime(eDttm));
            $('#modal-target-expln').html(expln); 
            $('#modal1').addClass('active'); 
        });

        /* 상세 내 [수정] 버튼 클릭 */
        $('.btn-edit').on('click', function() {
            if(currentActiveIdx === null) return;
            var item = window.currentScheduleList[currentActiveIdx];
            if(!item) return;

            initDatePicker();
            $('#modal2 .modal-title-area h3').text('수업일정 수정');
            
            // 데이터 수정을 위해 고유 ID를 모달 객체 메모리에 바인딩
            $('#modal2').data('schdlId', item.schdlId || item.SCHDL_ID || "");
            $('#name_label').val(item.nm || item.NM || "");

            var parseDateAndTime = function(rawStr) {
                if(!rawStr) return { d: "", t: "" };
                var clean = String(rawStr).replace(/[^0-9]/g, "");
                if(clean.length < 8) return { d: "", t: "" };
                var ymd = clean.substring(0,4) + "-" + clean.substring(4,6) + "-" + clean.substring(6,8);
                var hm = clean.length >= 12 ? clean.substring(8,10) + ":" + clean.substring(10,12) : "00:00";
                return { d: ymd, t: hm };
            };

            var startObj = parseDateAndTime(item.sdttm || item.SDTTM);
            var endObj = parseDateAndTime(item.edttm || item.EDTTM);
            $('#datepickerStart').val(startObj.d);
            $('#timepickerStart').val(startObj.t);
            $('#datepickerEnd').val(endObj.d);
            $('#timepickerEnd').val(endObj.t);

            var expln = item.expln || item.EXPLN || "";
            if (editor && typeof editor.openHTML === "function") {
                editor.openHTML(expln); 
            }
            $('#modal1').removeClass('active');
            $('#modal2').addClass('active');
        });

        /* 상세 내 [삭제] 버튼 클릭 -> Ajax 실연동 연계 */
        $('.btn-delete').on('click', function() {
            if(currentActiveIdx === null) return;
            var item = window.currentScheduleList[currentActiveIdx];
            if(!item) return;
            
            var schdlId = item.schdlId || item.SCHDL_ID || "";

            if(confirm("해당 수업일정을 정말로 삭제하시겠습니까?")) {
                $.ajax({
                    url: "/schedule/profClassScheduleDelete.do",
                    type: "POST",
                    data: {
                        clasSchdlId: schdlId
                    },
                    dataType: "json",
                    success: function(response) {
                        alert("일정이 성공적으로 삭제되었습니다.");
                        $('#modal1').removeClass('active');
                        myScheduleList(); 
                    },
                    error: function(xhr, status, error) {
                        alert("일정 삭제 중 오류가 발생했습니다.");
                    }
                });
            }
        });

        /* 공통 모달 닫기 제어 (X 버튼, 하단 닫기 버튼, 배경 클릭 일원화) */
        $(document).on('click', '.btn-modal-close-x, .modal-overlay .btn.type2', function() {
            $(this).closest('.modal-overlay').removeClass('active');
        });

        $('.modal-overlay').on('click', function(e) {
            if ($(e.target).hasClass('modal-overlay')) {
                $(e.target).removeClass('active');
            }
        });
        
     	// HTML 에디터
        editor = UiEditor({
            targetId: "atclCts",
            uploadPath: "/bbs",
            height: "500px"
        });
    });

    function initDatePicker() {
    	if(typeof $.datepicker !== "undefined") {
            $(".datepicker").datepicker({
                dateFormat:'yy-mm-dd',
                beforeShow:function(){
                    setTimeout(function(){
                        $('#ui-datepicker-div').css('z-index', 100000);
                    },0);
                }
            });
        }
    }

    function checkEditorContens() {
        if (editor.isEmpty()) { alert("비어있다...."); } 
        else { alert($("#atclCts").val()); }
    }

    function insertEditorContens1() {
        editor.execCommand('insertText', "<span style='color:red'>텍스트 넣기 테스트입니다.</span>");
    }

    function insertEditorContens2() {
        editor.openHTML("<span style='color:red'>텍스트 넣기 테스트입니다.</span>");
    }

    /* [등록 및 수정 처리] 저장 버튼 함수 통합 연동 */
    function saveSchedule() {
    	//alert('save');
        var title = $('#name_label').val();
        if(!title.trim()) {
            alert("제목을 입력하세요.");
            $('#name_label').focus();
            return;
        }
        
        //alert('save1');
        
        var sDate = $('#datepickerStart').val().replace(/[^0-9]/g, "");
        var sTime = $('#timepickerStart').val().replace(/[^0-9]/g, "");
        var eDate = $('#datepickerEnd').val().replace(/[^0-9]/g, "");
        var eTime = $('#timepickerEnd').val().replace(/[^0-9]/g, "");
        
        if(sDate.length < 8 || eDate.length < 8) {
            alert("기간을 정확히 입력해주세요.");
            return;
        }
        
        //alert('save2');
        
        console.log("변수체크:", sDate, sTime, eDate, eTime);
        
        var sdttm = sDate + (sTime.length === 4 ? sTime : "0000");
        var edttm = eDate + (eTime.length === 4 ? eTime : "2359");
        
        var expln = "";
        try {
            console.warn("에디터 객체(editor)가 로드되지 않아 textarea 값을 참조합니다.");
            expln = $('#atclCts').val() || "";
        } catch(e) {
            console.error("에디터 에러 발생!! : ", e);
            alert("에디터 객체 오류: " + e.message);
            expln = $('#atclCts').val(); // 에디터 실패 시 일반 textarea 값이라도 대체
        }

        var schdlId = $('#modal2').data('schdlId') || "";
        var requestUrl = (schdlId !== "") ? "/schedule/profClassScheduleModify.do" : "/schedule/profClassScheduleRegist.do";
        
        console.log(requestUrl);
        //alert(requestUrl);

        var param = {
            sbjctId: currentSbjctId,
            clasSchdlId: schdlId,
            smstrChrtId : smstrChrtId,
            clasSchdlTtl: title,
            clasSchdlSdttm: sdttm,
            clasSchdlEdttm: edttm,
            clasSchdlExpln: expln
        };

        $.ajax({
            url: requestUrl,
            type: "POST",
            data: param,
            dataType: "json",
            success: function(data) {
            	
            	if ( data.result > 0 ) {
	            	if (schdlId !== "") 
						alert("수정 되었습니다.");
	            	else 
	            		alert("등록 되었습니다.");
	                $('#modal2').removeClass('active');
	                $('#modal2').removeData('schdlId'); 
	                myScheduleList(); 
            	} else {
            		alert("수업일정 저장 중 오류가 발생했습니다.");
            	}
            },
            error: function(xhr, status, error) {
                alert("수업일정 저장 중 오류가 발생했습니다.");
            }
        });
    }

    function doSearch() {
        var textVal = $('#searchInputValue').val();
        $('#searchValue').val(textVal); 
        myScheduleList();
    }

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
        var sundayDate = currentDay - currentTarget.getDay();
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
            var sundayIdx = currentDay - currentTarget.getDay();
            for (var j = 0; j < 7; j++) {
                var weekDate = new Date(year, month - 1, sundayIdx + j);
                var wYear = weekDate.getFullYear();
                var wMonth = weekDate.getMonth() + 1;
                var wDate = weekDate.getDate();
                var wDayNum = weekDate.getDay(); 
                var dayClass = (wDayNum === 0) ? "sun" : (wDayNum === 6 ? "sat" : "");
                if (wMonth !== month) dayClass += " other-month";
                var today = new Date();
                if (today.getFullYear() === wYear && (today.getMonth() + 1) === wMonth && today.getDate() === wDate) dayClass += " today";
                var matchDateStr = wYear + "" + (wMonth < 10 ? "0" + wMonth : wMonth) + "" + (wDate < 10 ? "0" + wDate : wDate);
                html += '<div class="cal-day ' + dayClass + '" role="gridcell" data-date="' + matchDateStr + '">';
                html += '   <div class="day-header-box"><span class="cal-date">' + wDate + '</span><span class="cal-day-txt">' + weekDayNames[wDayNum] + '</span></div>';
                html += '   <ul class="cal-events"></ul></div>';
            }
            html += '</div>';
        } 
        else {
            var firstDay = new Date(year, month - 1, 1), lastDay = new Date(year, month, 0);       
            var startDayOfWeek = firstDay.getDay(), totalDays = lastDay.getDate();            
            var prevLastDay = new Date(year, month - 1, 0).getDate();
            var dateCounter = 1, nextMonthCounter = 1;
            for (var i = 0; i < 6; i++) {
                if (dateCounter > totalDays) break; 
                html += '<div class="cal-week" role="row">';
                for (var j = 0; j < 7; j++) {
                    var cellIndex = i * 7 + j;
                    if (cellIndex < startDayOfWeek) {
                        var prevDate = prevLastDay - (startDayOfWeek - cellIndex - 1);
                        html += '<div class="cal-day other-month ' + (j===0?"sun":"") + '" role="gridcell"><span class="cal-date">' + prevDate + '</span></div>';
                    } else if (dateCounter > totalDays) {
                        html += '<div class="cal-day other-month ' + (j===6?"sat":"") + '" role="gridcell"><span class="cal-date">' + nextMonthCounter + '</span></div>';
                        nextMonthCounter++;
                    } else {
                        var dayClass = (j===0?"sun":(j===6?"sat":""));
                        var today = new Date();
                        if (today.getFullYear() === year && (today.getMonth() + 1) === month && today.getDate() === dateCounter) dayClass += " today";
                        var matchDateStr = year + "" + (month < 10 ? "0" + month : month) + "" + (dateCounter < 10 ? "0" + dateCounter : dateCounter);
                        html += '<div class="cal-day ' + dayClass + '" role="gridcell" data-date="' + matchDateStr + '"><span class="cal-date">' + dateCounter + '</span><ul class="cal-events"></ul></div>';
                        dateCounter++;
                    }
                }
                html += '</div>';
            }
        }
        $tableWrap.append(html);
        if (scheduleList && scheduleList.length > 0) renderScheduleData(scheduleList);
    }

    function renderScheduleData(list) {
    	$.each(list, function(index, item) {
            var rawDate = item.sdttm || item.SDTTM;
            var typeNm = item.schdlTynm || item.schdl_tynm || item.SCHDL_TYNM || "기타";
            var title = item.nm || item.NM || "지정된 일정명 없음";
            if (rawDate) {
                var cleanDate = String(rawDate).replace(/[^0-9]/g, "").substring(0, 8);
                var $dayCell = $('.cal-day[data-date="' + cleanDate + '"]');
                if ($dayCell.length > 0) {
                    var dotColor = "dot-gray"; 
                    switch(typeNm) {
                        case "과제": dotColor = "dot-red"; break;
                        case "토론": dotColor = "dot-orange"; break;
                        case "시험": case "퀴즈": dotColor = "dot-purple"; break;
                        case "설문": dotColor = "dot-green"; break;
                        case "세미나": dotColor = "dot-blue"; break;
                        case "학사일정": dotColor = "dot-black"; break;
                    }
                    var eventHtml = '<li><span class="dot ' + dotColor + '"></span>' +
                                    '<a href="#0" class="ev-link" title="' + title + '" data-idx="' + index + '">' +
                                    '<span class="ev-label">[' + typeNm + ']</span><span class="ev-title">' + title + '</span></a></li>';
                    $dayCell.find('.cal-events').append(eventHtml);
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
                            <h2 class="page-title"><spring:message code="sch.cal_lesson" /> <spring:message code="sch.cal_schedule" /></h2>
                        </div>
                        
                        <form id="searchForm" name="searchForm" onsubmit="return false;">
                            <input type="hidden" id="searchValue" name="searchValue" value="${vo.searchValue}">
                            <div class="search-typeA">
                                <div class="item">
                                    <span class="item_tit"><label for="searchInputValue"><spring:message code='common.search.keyword'/></label></span>
                                    <div class="itemList">
                                        <input class="form-control wide" type="text" id="searchInputValue" value="${vo.searchValue}" onkeydown="if(event.keyCode==13) { doSearch(); return false; }">
                                    </div>
                                </div>
                                <div class="button-area"><button type="button" class="btn search" onclick="doSearch()"><spring:message code='button.search'/></button></div>
                            </div>
                        </form>
                                
                        <div class="schedule-calendar">
                            <div class="cal-toolbar">
                                <div class="cal-toolbar-left"><button type="button" class="btn btn-today">오늘</button></div>
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
                <button type="button" class="btn-modal-close-x" aria-label="닫기"><i class="xi-close"></i></button>
                <div class="modal-body">
                    <div class="modal-title-area">
                        <h3 id="modal-target-title">수업일정 상세 안내</h3>
                    </div>
                    <div class="search-typeA mb10">
                        <div class="item"><strong>기간</strong> <span id="modal-target-date">-</span></div>
                    </div>
                    <div class="lecture_box" id="modal-target-expln">등록된 세부 내용이 없습니다.</div>
                    <div class="modal_btns">
                        <button type="button" class="btn btn-edit">수정</button>
                        <button type="button" class="btn btn-delete">삭제</button>
                        <button type="button" class="btn type2 btn-close-pop">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal-overlay" id="modal2">
            <div class="modal-content wide">
                <button type="button" class="btn-modal-close-x" aria-label="닫기"><i class="xi-close"></i></button>
                <div class="modal-body">
                    <div class="modal-title-area"><h3>수업일정 등록</h3></div>
                    <div class="popup-table-wrap">
                        <table class="table-type5">
                            <colgroup><col style="width:20%"><col></colgroup>
                            <tbody>
                                <tr><th scope="col">학사년도/학기</th><td data-th="학사년도/학기">2026년 1학기</td></tr>
                                <tr><th scope="col">기관</th><td data-th="기관">대학원</td></tr>
                                <tr><th scope="col">과목</th><td data-th="과목">일한 번역연습</td></tr>
                                <tr><th scope="col" class="req">제목</th><td data-th="제목"><div class="form-row"><input class="form-control width-50per" type="text" name="name" id="name_label" placeholder="제목을 입력하세요" required="true"></div></td></tr>
                                <tr><th scope="col" class="req">기간</th><td data-th="기간">
                                    <div class="date_area">
                                        <input type="text" placeholder="시작일" id="datepickerStart" class="datepicker" value="20260630">
                                        <input type="text" placeholder="시작시간" id="timepickerStart" class="timepicker" value="0900">
                                        <span class="txt-sort">~</span>
                                        <input type="text" placeholder="종료일" id="datepickerEnd" class="datepicker" value="20260630">
                                        <input type="text" placeholder="종료시간" id="timepickerEnd" class="timepicker" value="1800">
                                        
                                        <!--<input id="dateSt" type="text" name="dateSt" class="datepicker" timeId="timeSt" toDate="dateEd">
										<input id="timeSt" type="text" name="timeSt" class="timepicker" dateId="dateSt">
										<span class="txt-sort">~</span>
										<input id="dateEd" type="text" name="dateEd" class="datepicker" timeId="timeEd" fromDate="dateSt">
										<input id="timeEd" type="text" name="timeEd" class="timepicker" dateId="dateEd">-->
                                    </div>
                                </td></tr>
                                <tr>
                                	<th><label for="contTextarea" class="req">설명</label></th>
									<td data-th="입력">
										<li>
											<dl>
												<dd>
													<div class="editor-box">
														<label for="atclCts" class="hide">Content</label>
														<textarea id="atclCts" name="atclCts" required="true" maxLenCheck="자,2000,true,true" style="width:600px;height:100px"></textarea>
													</div>
												</dd>
											</dl>
										</li>
									</td>
								</tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="modal_btns">
                        <button type="button" class="btn type1" onclick="saveSchedule()">저장</button>
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>