
/**
 * 날짜/시간 입력
 * <input> 필드에 'datepicker', 'timepicker' 속성이 정의된 필드에 날짜/선택 UI 적용
 *
 * 날짜선택 설정 : <input id='date1' type='text' class='datepicker'>
 * 시간선택 설정 : <input id='time1' type='text' class='timepicker'>
 *
 * 날짜 기간 입력
 *   <input id='date1' type='text' class='datepicker' toDate='date2'> ~
 *   <input id='date2' type='text' class='datepicker' fromDate='date1'>
 *
 * 날짜/시간 기간 입력
 *   <input id='date1' type='text' class='datepicker' toDate='date2' timeId='time1'>
 * 	 <input id='time1' type='text' class='timepicker' dateId='date1'> ~
 *   <input id='date2' type='text' class='datepicker' fromDate='date1' timeId='time2'>
 *   <input id='time2' type='text' class='timepicker' dateId='date2'>
 */
function UiDateTimepicker() {
	UiDateTimepickerLang(UiComm.conf.lang); // 언어 설정

	const minTimeVal = {minTime: {hour:0, minute:0}};
	const maxTimeVal = {maxTime: {hour:60, minute:60}};

	// Datepicker
	let dateInputs = $('input.datepicker:not([type="checkbox"], [type="radio"])');
	dateInputs.each(function() {
		let dateInput = $(this);
		let pickerLabel = null;
		let year = (new Date()).getFullYear();
		let toDate = dateInput.attr("toDate");
		let fromDate = dateInput.attr("fromDate");
		let timeId = dateInput.attr("timeId");

		if (dateInput.parent().hasClass("datepicker-label")) {
			pickerLabel = dateInput.parent();
		}
		else {
			pickerLabel = $("<label class='datepicker-label'></label>");
			dateInput.after(pickerLabel);
			pickerLabel.append(dateInput)
		}

		let option = {
			changeMonth: true,
			changeYear: true,
			dateFormat: "yy-mm-dd",
			yearRange: (year-3)+":"+(year+3)
		};

		if (toDate) {
			let toDateObj = $("#"+toDate);
			let toTimeId = toDateObj.attr("timeId");

			option.toDate = toDate;
			option.maxDate = toDateObj.val();
			option.onClose = function(sDate) {
				toDateObj.datepicker('option', 'minDate', sDate);

				if (timeId && toTimeId) {
					let timeObj = $("#"+timeId);
					let timeVal = timeObj.val();
					let toTimeObj = $("#"+toTimeId);
					let toTimeVal = toTimeObj.val();

					if (sDate == toDateObj.val()) {
						if (timeVal != "") {
							let times = timeVal.split(":");
							toTimeObj.timepicker('option', {minTime: {hour:parseInt(times[0]), minute:parseInt(times[1])+1}});

							if (toTimeVal != "" && timeVal >= toTimeVal) {
								toTimeObj.val("");
							}
						}
						else {
							toTimeObj.timepicker('option', minTimeVal);
						}

						timeObj.timepicker('option', maxTimeVal);
						timeObj.timepicker('option', minTimeVal);
						toTimeObj.timepicker('option', maxTimeVal);
					}
					else {
						timeObj.timepicker('option', maxTimeVal);
						timeObj.timepicker('option', minTimeVal);
						toTimeObj.timepicker('option', maxTimeVal);
						toTimeObj.timepicker('option', minTimeVal);
					}
				}
			}
		}

		if (fromDate) {
			let fromDateObj = $("#"+fromDate)
			let fromTimeId = $("#"+fromDate).attr("timeId");

			option.fromDate = fromDate;
			option.minDate = fromDateObj.val();
			option.onClose = function(sDate) {
				fromDateObj.datepicker('option', 'maxDate', sDate);

				if (timeId && fromTimeId) {
					let timeObj = $("#"+timeId);
					let timeVal = timeObj.val();
					let fromTimeObj = $("#"+fromTimeId);
					let fromTimeVal = fromTimeObj.val();

					if (sDate == fromDateObj.val()) {
						if (fromTimeVal != "") {
							let times = fromTimeVal.split(":");
							timeObj.timepicker('option', {minTime: {hour:parseInt(times[0]), minute:parseInt(times[1])+1}});

							if (timeVal != "" && fromTimeVal >= timeVal) {
								timeObj.val("");
							}
						}
						else {
							timeObj.timepicker('option', minTimeVal);
						}

						fromTimeObj.timepicker('option', maxTimeVal);
						fromTimeObj.timepicker('option', minTimeVal);
						timeObj.timepicker('option', maxTimeVal);
					}
					else {
						timeObj.timepicker('option', maxTimeVal);
						timeObj.timepicker('option', minTimeVal);
						fromTimeObj.timepicker('option', maxTimeVal);
						fromTimeObj.timepicker('option', minTimeVal);
					}
				}
			};
		}

		dateInput.on('focus', function() {
			if (!$(this).hasClass("hasDatepicker")) {
				$(this).datepicker(option);
			}
			$(this).datepicker("show");
		});

		dateInput.inputmask({regex: "^\\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\\d|3[01])$", showMaskOnFocus:false});
		dateInput.datepicker(option);
	});

	// Timepicker
	let timeInputs = $('input.timepicker:not([type="checkbox"], [type="radio"])');
	timeInputs.each(function() {
		let timeInput = $(this);
		let pickerLabel = null;
		let dateId = timeInput.attr("dateId");

		if (timeInput.parent().hasClass("timepicker-label")) {
			pickerLabel = timeInput.parent();
		}
		else {
			pickerLabel = $("<label class='timepicker-label'></label>");
			timeInput.after(pickerLabel);
			pickerLabel.append(timeInput)
		}

		let option = {
			showPeriodLabels:false,
			defaultTime:'00:00',
			minutes: {
				starts: 0,
				ends: 55,
			    interval: 5,
			    manual: [59]
			}
		};

		if (dateId) {
			let dateObj     = $("#"+dateId);
			let toDate      = dateObj.attr("toDate");
			let toDateObj   = $("#"+toDate);
			let fromDate    = dateObj.attr("fromDate");
			let fromDateObj = $("#"+fromDate);
			let timeId      = toDateObj.attr("timeId");
			let timeObj		= $("#"+timeId);

			if (toDate && timeId) {
				option.onClose = function(sTime) {
					if (dateObj.val() == toDateObj.val()) {
						let times = sTime.split(":");
						timeObj.timepicker('option', {minTime: {hour: parseInt(times[0]), minute: parseInt(times[1])+1}});
					}
				}
			}

			if (fromDate && timeId) {
				option.onClose = function(sTime) {
					if (dateObj.val() == fromDateObj.val()) {
						let times = sTime.split(":");
						timeObj.timepicker('option', {maxTime: {hour: parseInt(times[0]), minute: parseInt(times[1])-1}});
					}
				}
			}
		}

		timeInput.on('focus', function() {
			if (!$(this).hasClass("hasTimepicker")) {
				$(this).timepicker(option);
			}
			$(this).timepicker("show");
		});

		timeInput.inputmask({regex: "^([01]\\d|2[0-3]):[0-5]\\d$", showMaskOnFocus:false});
		timeInput.timepicker(option);
	});
}


/**
 * 날짜/시간 선택 UI 언어 설정
 */
function UiDateTimepickerLang(lang) {
	// Datepicker 언어
	const dateLang = {
		ko: {
			closeText: '닫기',
			prevText: '이전달',
			nextText: '다음달',
			currentText: '오늘',
			monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
			monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
			dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'],
			dayNamesShort: ['일','월','화','수','목','금','토'],
			dayNamesMin: ['일','월','화','수','목','금','토'],
			weekHeader: '주',
			dateFormat: 'yy-mm-dd',
			firstDay: 0,
			isRTL: false,
			showMonthAfterYear: true,
			yearSuffix: '<span class="year-label">년</span>',
			invalidDate: '날짜가 올바르지 않습니다.'
		},
		ja: {
			closeText: '閉じる',
			prevText: '&#x3C;前',
			nextText: '次&#x3E;',
			currentText: '今日',
			monthNames: ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月'],
			monthNamesShort: ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月'],
			dayNames: ['日曜日','月曜日','火曜日','水曜日','木曜日','金曜日','土曜日'],
			dayNamesShort: ['日','月','火','水','木','金','土'],
			dayNamesMin: ['日','月','火','水','木','金','土'],
			weekHeader: '週',
			dateFormat: 'yy/mm/dd',
			firstDay: 0,
			isRTL: false,
			showMonthAfterYear: true,
			yearSuffix: '<span class="year-label">年</span>',
			invalidDate: '日付が正しくありません。'
		},
		zh: {
			closeText: '关闭',
			prevText: '&#x3C;上月',
			nextText: '下月&#x3E;',
			currentText: '今天',
			monthNames: ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月'],
			monthNamesShort: ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月'],
			dayNames: ['星期日','星期一','星期二','星期三','星期四','星期五','星期六'],
			dayNamesShort: ['周日','周一','周二','周三','周四','周五','周六'],
			dayNamesMin: ['日','一','二','三','四','五','六'],
			weekHeader: '周',
			dateFormat: 'yy/mm/dd',
			firstDay: 1,
			isRTL: false,
			showMonthAfterYear: true,
			yearSuffix: '<span class="year-label">年</span>',
			invalidDate: '日期不正确。'
		}
	}

	// Timepicker 언어
	const timeLang = {
		ko: {
			hourText: '시간',
			minuteText: '분',
			amPmText: ['오전', '오후'],
			closeButtonText: '닫기',
			nowButtonText: '현재',
			deselectButtonText: '선택취소'
		},
		ja: {
			hourText: '時間',
			minuteText: '分',
			amPmText: ['午前', '午後'],
			closeButtonText: '閉じる',
			nowButtonText: '現時',
			deselectButtonText: '選択解除'
		},
		zh: {
			hourText: '小时',
			minuteText: '分钟',
			amPmText: ['上午', '下午'],
			closeButtonText: '关闭',
			nowButtonText: '现在',
			deselectButtonText: '取消选择'
		}
	}

	$.datepicker.setDefaults(dateLang[lang]);
	$.timepicker.setDefaults(timeLang[lang]);
}
