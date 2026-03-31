/**
 * UI Common utilities
 */

// UI 초기화...
$(function(){
	// 자동완성 끄기
	$("input[type=text]").attr("autocomplete","off");

	// select 필드에 chosen 적용
	UiChosen();

	// checkbox, radio 필드에 Switch 적용
	UiSwitcher();

	//입력필드 <input>에 "inputmask" 속성이 정의되어 있으면 입력 제한 적용
	UiInputmask();

	// textarea에 "maxLenCheck" 속성이 정의되어 있으면 입력 제한 적용
	UiInputmaskText();

	// Datepicker, Timepicker 적용
	UiDateTimepicker();
});


/**
 * UI 공통
 */
let UiComm = {
	conf: {
		lang:				"ko",	// 언어
		utf8:				true,	// UTF-8 적용여부 설정(true/false)
		editorUploadUrl:	"/common/editorUpload.do?path=",	// 에디터 첨부파일 업로드 URL
	},


	/**
	 * 암호화 파라메터 생성
	 *
	 * @data	파라메터 데이터(Object)
	 */
	makeEncParams: function(data) {
		const bytes = new TextEncoder().encode(JSON.stringify(data));
		let param = "";
		for (const b of bytes) param += String.fromCharCode(b);
		return btoa(param);
	},


	/**
	 * 날짜/시간 포맷
	 *
	 * @value	문자열(yyyyMMddHHmmss) 또는 Date
	 * @type	출력형식
	 * 		date      : "yyyy-MM-dd" (날짜)
	 * 		time      : "HH:mm:ss" (시간)
	 * 		time2     : "HH:mm" (시간,분)
	 * 		datetime  : "yyyy-MM-dd HH:mm:ss" (날짜시간)
	 * 		datetime2 : "yyyy-MM-dd HH:mm" (날짜시간,분)
	 * 		monthday  : "MM-dd" (월일)
	 */
	formatDate: function(value, type) {
		let dateValue = "";

		if (!value) {
			return "";
		}

		if (!type) {
			type = "datetime";
		}

		// String value
		if (typeof value === "string") {
			dateValue = value.replace(/\D/g, "");

			if (dateValue.length < 14 && dateValue.length >= 8) {
				type = "date";
			}
			else if (dateValue < 8) {
				type = "";
			}
		}
		// Date value
		else if (value instanceof Date) {
			let pad = n => String(n).padStart(2, "0");
			dateValue = date.getFullYear()
				+ pad(date.getMonth() + 1)
				+ pad(date.getDate())
				+ pad(date.getHours())
				+ pad(date.getMinutes())
				+ pad(date.getSeconds());
		}

		if (type === "date") {
			dateValue = dateValue.substring(0, 4) + "-"
					  + dateValue.substring(4, 6) + "-"
					  + dateValue.substring(6, 8);
		}
		else if (type === "time") {
			dateValue = dateValue.substring(8, 10) + ":"
					  + dateValue.substring(10, 12) + ":"
					  + dateValue.substring(12, 14);
		}
		else if (type === "time2") {
			dateValue = dateValue.substring(8, 10) + ":"
					  + dateValue.substring(10, 12);
		}
		else if (type === "datetime") {
			dateValue = dateValue.substring(0, 4) + "-"
					  + dateValue.substring(4, 6) + "-"
					  + dateValue.substring(6, 8) + " "
					  + dateValue.substring(8, 10) + ":"
					  + dateValue.substring(10, 12) + ":"
					  + dateValue.substring(12, 14);
		}
		else if (type === "datetime2") {
			dateValue = dateValue.substring(0, 4) + "-"
					  + dateValue.substring(4, 6) + "-"
					  + dateValue.substring(6, 8) + " "
					  + dateValue.substring(8, 10) + ":"
					  + dateValue.substring(10, 12);
		}
		else if (type === "monthday") {
			dateValue = dateValue.substring(4, 6) + "-"
					  + dateValue.substring(6, 8);
		}

		return dateValue;
	},


	/**
	 * 로딩 표시
	 *
	 * @param type		true/false (보이기/닫기)
	 * @param message	메시지(생략가능)
	 */
	showLoading: function(type, message) {
		if (type === true || type === "true" || type === null) {
			let loadingModal = $(".loading-modal");

			if (loadingModal.length == 0) {
				loadingModal = $("<div class='loading-modal'><div class='loading-msg'></div></div>");
				$("body").append(loadingModal);
			}

			loadingModal.children(".loading-msg").html(message ? "<span>"+message+"</span>" : "");
			$(".loading-modal").show();
			$("body").css("overflow", "hidden");
			this.showTopLayer(loadingModal);
		}
		else {
			$(".loading-modal").hide();
			$("body").css("overflow", "auto");
		}
	},


	/**
	 * 메시지 표시 (메시지 다이얼로그)
	 *
	 * @param message	메시지 내용
	 * @param type		메시지 Type(info:정보(default), success:성공, error:오류, warning:경고, confirm:컨펌)
	 * @param width		메시지창 너비(생략가능, 기본값 400)
	 */
	showMessage: function(message, type, width) {
		let defer = $.Deferred();
		let msgBox = $("#UI_MESSAGE_BOX");
		let uicomm = this;

		if (msgBox.length == 0) {
			msgBox = $("<div id='UI_MESSAGE_BOX'></div>");
			msgBox.isOpen = false;
			$("body").append(msgBox);
		}

		if (!message || msgBox.isOPen) {
			return defer.promise();
		}

		width = !width ? 400 : parseInt(width);

		let winWidth = $(window).width();
		if (width > winWidth) {
			width = winWidth;
		}

		let okBtn = {
			text: this.getMsg("button_ok"),
			click: function() {$(this).dialog("close"); defer.resolve(true);},
			class: 'ok'
		};
		let cancelBtn = {
			text:  this.getMsg("button_cancel"),
			click: function() {$(this).dialog("close"); defer.resolve(false);},
			class: 'cancel'
		};
		let buttons = [okBtn];
		let icon = "";
		let closeDefer = true;

		if (!type) type = "info";
		if (type === "fail") type = "error"

		if (type === "error" || type === "warning") {
			icon = "xi-warning";
		}
		else if (type == "confirm") {
			icon = "xi-help";
			buttons = [okBtn, cancelBtn];
			closeDefer = false;
		}
		else {
			icon = "xi-info";
		}

		message = message.replace(/\\n|\n/gi, '<br>');

		let content = `<div class='message-content'>`
			+ `<div class='message-icon ${type}'><i class='${icon}'></i></div>`
			+ `<div class='message-text'>${message}</div>`
			+ `</div>`;
		msgBox.html(content);

		$("#UI_MESSAGE_BOX").dialog({
			width: width,
			modal: true,
			resizable: false,
			"buttons": buttons,
			open: function(event, ui) {
				let parBox = $(this).parent();
				parBox.addClass("message-box");
				parBox.find('.ui-dialog-title').html("<i class='xi-bars'></i>");
				uicomm.showTopLayer(parBox);
				msgBox.isOpen = true;

				let closeBtn = parBox.find("button.ui-dialog-titlebar-close");
				closeBtn.on('click', function() { defer.resolve(closeDefer); });
				parBox.find(".ui-dialog-buttonset button.ok").focus();
			},
			close: function(event, ui) {
				msgBox.isOpen = false;
			}
		});

		return defer.promise();
	},


	/**
	 * 페이징 표시
	 *
	 * @param target :		페이지정보를 표시할 대상 객체ID
	 * @param opts	:		페이지 옵션
	 * 		{
	 * 			pageInfo: PageInfo,		// 페이지정보 객체
	 * 			pageFunc: func,			// 페이지 이동 Javascript 함수
	 * 			showTotRecord: true,	// 전체 페이지 정보 표시 여부 (true/false), 기본값 true
	 * 			showCurrentPage: true,	// 현재 페이지 정보 표시 여부 (true/false), 기본값 true
	 * 		}
	 */
	showPaging: function(target, opts) {
		if (opts == null || opts == undefined) return;

		let $paginator = $("#"+target);
		let pageInfo = opts.pageInfo;
		let pageNo = pageInfo.currentPageNo;
		let prev = (pageNo > 1) ? pageNo - 1 : 1;
		let next = (pageNo < pageInfo.lastPageNo) ? pageNo + 1 : pageInfo.lastPageNo;
		let firstStatus = pageNo === 1 ? "disabled" : "";
		let prevStatus = pageNo === 1 ? "disabled" : "";
		let nextStatus = pageNo === pageInfo.lastPageNo ? "disabled" : "";
		let lastStatus = pageNo === pageInfo.lastPageNo ? "disabled" : "";
		let showTotRecord = opts.showTotRecord == undefined ? true : !opts.showTotRecord ? false : opts.showTotRecord;
		let showCurrentPage = opts.showCurrentPage == undefined ? true : !opts.showCurrentPage ? false : opts.showCurrentPage;
		let counterCnts = "";
		let pageCnts = "";

		$paginator.addClass("board_foot");
		pageCnts += `<div class='page_info'>`;

		if (showTotRecord) {
		    pageCnts += `<span class='total_page'>${this.getMsg("tot_count", pageInfo.totalRecordCount)}</span>`;
		}

		if (showCurrentPage) {
		    pageCnts += `<span class='${showTotRecord ? "current_page" : "current_page_info"}'>${UiTableUtil.getMsg("cur_page")}`;
		    pageCnts += ` <strong>${pageNo}</strong>/${pageInfo.totalPageCount}</span>`;
		}

		pageCnts += `</div>`;
		pageCnts += `<div class='board_pager'><span class='inner'>`;


		pageCnts += `<button class='page first' type='button' role='button' aria-label='First Page' title='${this.getMsg("first_page")}' data-page='1' ${firstStatus}><i class='icon-page-first'></i></button>`;
		pageCnts += `<button class='page' type='button' role='button' aria-label='Prev Page' title='${this.getMsg("prev_page")}' data-page='${prev}' ${prevStatus}><i class='icon-page-prev'></i></button>`;
		pageCnts += `<span class='pages'>`;

		for (let i = pageInfo.firstPageNoOnPageList; i <= pageInfo.lastPageNoOnPageList; i++) {
		    pageCnts += `<button class='page${i == pageNo ? " active" : ""}' type='button' role='button' aria-label='Page ${i}' title='${this.getMsg("page", i)}' data-page='${i}'>${i}</button> `;
		}

		pageCnts += `</span>`;
		pageCnts += `<button class='page' type='button' role='button' aria-label='Next Page' title='${this.getMsg("next_page")}' data-page='${next}' ${nextStatus}><i class='icon-page-next'></i></button>`;
		pageCnts += `<button class='page' type='button' role='button' aria-label='Last Page' title='${this.getMsg("last_page")}' data-page='${pageInfo.lastPageNo}' ${lastStatus}><i class='icon-page-last'></i></button>`;

		pageCnts += `</span></div>`;
		pageCnts += `</div>`;

		$paginator.html(pageCnts);
		$paginator.find("button").on('click', function () {
		    if (opts.pageFunc && typeof opts.pageFunc === "function") {
		        let page = parseInt($(this).attr("data-page"));
		        if (pageNo !== page) {
		            opts.pageFunc(page);
		        }
		    }
		});
	},


	/**
	 * html 태그 제거
	 *
	 * @param str		html 문자열
	 */
	escapeHtml: function(str) {
		if (!str) return '';
		return str.replace(/&/g, '&amp;')
		          .replace(/</g, '&lt;')
		          .replace(/>/g, '&gt;')
		          .replace(/"/g, '&quot;')
		          .replace(/'/g, '&#039;');
	},


	/**
	 * 날짜/시간 입력창에서 데이터 가져오기
	 *
	 * @param dateId :		날짜입력필드 ID
	 * @param timeId :		시간입력필드 ID
	 */
	getDateTimeVal: function(dateId, timeId) {
		let value = "";

		if (dateId) {
			value = $("#"+dateId).val().replace(/[-.]/g, '');
		}
		if (timeId) {
			value += $("#"+timeId).val().replace(/:/g, '');
		}

		return value;
	},


	/**
	 * 객체를 Top Layer로 표시
	 * @param obj : 대상객체
	 */
	showTopLayer: function(obj) {
		let maxZ = 0;
		$("*").each(function () {
			let z = parseInt($(this).css("z-index"), 10);
			if (!isNaN(z)) maxZ = Math.max(maxZ, z);
		});
		obj.css("z-index", maxZ);
	},


	/**
	 * 문자열 길이(byte) 자르기
	 * @param str :		문자열
	 * @param len :		길이
	 */
	cutText: function(str, len) {
		for (b=i=0; c=str.charCodeAt(i);) {
			b += c >> 7 ? 2 : 1;
			if (b > len) {
				break;
			}
			i++;
		}
		return str.substring(0, i);
	},


	/**
	 * 문자열 길이(byte) 반환
	 * @param str :		문자열
	 */
	getTextSize: function(str) {
		return str.length + (escape(str)+"%u").match(/%u/g).length-1;
	},


	/**
	 * 문자열 길이(byte) 자르기 (UTF-8, 한글 3byte)
	 * @param str :		문자열
	 * @param len :		길이
	 */
	cutTextUni: function(str, len) {
		if (str != null && str != "") {
			var b = 0;
			var c = 0;
			for (var i=0; c=str.charCodeAt(i++);) {
				b += c>>11 ? 3 : c>>7 ? 2 : c==10 ? 2 : 1;
				if (b > len) {
					break;
				}
			}

			return str.substring(0, i-1);
		}
		else {
			return "";
		}
	},

	/**
	 * 문자열 길이(byte) 반환 (UTF-8, 한글 3byte)
	 * @param str :		문자열
	 */
	getTextSizeUni: function(str) {
		var size = 0;
		var char = 0;

		if (str != null && str != "") {
			for(var i=0; char=str.charCodeAt(i++); size += char>>11 ? 3 : char>>7 ? 2 : char==10 ? 2 : 1);
		}

	    return size;
	},


	/**
	 * 문자열 길이(length) 반환 (한글 1자로 계산)
	 * @param str :		문자열
	 */
	getTextLength: function(str) {
		var size = 0;
		var char = 0;

		if (str != null && str != "") {
			for(var i=0; char=str.charCodeAt(i++); size += char==10 ? 2 : 1);
		}

		return size;
	},


	/**
	 * 문자열 길이(length) 자르기 (한글 1자로 계산)
	 * @param str :		문자열
	 * @param len :		길이
	 */
	cutTextLength: function (str, len) {
		if (str != null && str != "") {
			var b = 0;
			var c = 0;
			for (var i=0; c=str.charCodeAt(i++);) {
				b += c==10 ? 2 : 1;
				if (b > len) {
					break;
				}
			}

			return str.substring(0, i-1);
		}
		else {
			return "";
		}
	},


	/**
	 * localStoreate 데이터 관리
	 */
	db: {
		keyPrefix: "KNOULMS:",

		// 데이터 저장
		setItem: function(key, value) {
			window.localStorage.setItem(this.keyPrefix + key, value);
		},

		// 데이터 조회
		getItem: function(key) {
			return window.localStorage.getItem(this.keyPrefix + key);
		},

		// 데이터 삭제
		removeItem: function(key) {
			return window.localStorage.removeItem(this.keyPrefix + key);
		}
	},


	/**
	 * 메시지 가져오기
	 * @param key :		메시지키
	 * @param args :	Augument
	 */
	getMsg: function(key, ...args) {
		let msg = this.messageCode[this.conf.lang][key];
		if (!msg) return "";

		msg = msg.replace(/\{(\d+)\}/g, (match, index) => {
			if (index < args.length && args[index] !== undefined && args[index] !== null) {
				return args[index];
			}
			return match;
		});

		return msg;
	},


	/**
	 * 메시지 코드
	 */
	messageCode: {
		ko: {
			button_ok: "확인",
			button_cancel: "취소",
			no_input_max: "{0} 이상 입력할 수 없습니다.",
			unit_char: "자",
			unit_byte: "byte",
			required_field: "! 필수 입력 항목입니다.",
			required_msg1: "필수 항목을 모두 입력하세요.",
			required_msg2: "표시된 항목을 확인하세요.",
			no_data: "데이터가 없습니다.",
			tot_count: "전체 <b>{0}</b>건",
			page: "{0} 페이지",
			cur_page: "현재 페이지",
			first_page: "처음 페이지",
			prev_page: "이전 페이지",
			next_page: "다음 페이지",
			last_page: "마지막 페이지",
		},
		en: {
			button_ok: "OK",
			button_cancel: "Cancel",
			no_input_max: "Cannot enter more than {0}.",
			unit_char: "",
			unit_byte: "byte",
			required_field: "! This is a required field.",
			required_msg1: "Please fill in all required fields.",
			required_msg2: "indicates the fields you need to check.",
			no_data: "There is no data.",
			tot_count: "Total {0} records",
			page: "Page {0}",
			cur_page: "Current Page",
			first_page: "First Page",
			prev_page: "Prev Page",
			next_page: "Next Page",
			last_page: "Last Page",
		},
		ja: {
			button_ok: "確定",
			button_cancel: "キャンセル",
			no_input_max: "{0}以上入力することはできません。",
			unit_char: "字",
			unit_byte: "byte",
			required_field: "! 必須入力項目です。",
			required_msg1: "必須項目をすべて入力してください。",
			required_msg2: "の印がついている項目を確認してください。",
			no_data: "データがありません。",
			tot_count: "合計{0}件",
			page: "{0} ページ",
			cur_page: "現在のページ",
			first_page: "最初のページ",
			prev_page: "前のページ",
			next_page: "次のページ",
			last_page: "最後のページ",
		},
		zh: {
			button_ok: "确定",
			button_cancel: "取消",
			no_input_max: "您输入的字符数不能超过{0}。",
			unit_char: "字",
			unit_byte: "byte",
			required_field: "! 这是必填项。",
			required_msg1: "请填写所有必填项。",
			required_msg2: "标记的字段，请予以确认。",
			no_data: "没有数据。",
			tot_count: "总计{0}条",
			page: "第{0}页",
			cur_page: "当前页",
			first_page: "第一页",
			prev_page: "上一页",
			next_page: "下一页",
			last_page: "最后一页",
		}
	}
}

// Window 객체로 선언
window.UiComm = UiComm;


// old --> 삭제 예정,
// 이 함수를 사용하는 페이지에서는 UiComm.showPaging() 함수로 변경해야함.
gfn_renderPaging = function(params){
	var divId = "paging"; //페이징이 그려질 div id
	if(params.pagingDivId != undefined) {
		divId = params.pagingDivId;
	}
	var totalCount = params.totalCount; //전체 조회 건수
	var currentIndex = params.currentPageNo //현재 위치
	console.log("currentIndex::" + currentIndex);
	if(gfn_isNull(currentIndex)){
		currentIndex = 1;
	}

	var listScale = params.listScale; //페이지당 레코드 수
	if(gfn_isNull(listScale)){
		listScale = 20;
	}
	var totalIndexCount = Math.ceil(totalCount / listScale); // 전체 인덱스 수
	var eventName = params.eventName;

	$("#"+divId).empty();
	var preStr = "";
	var postStr = "";
	var str = "";

	var first = (parseInt((currentIndex-1) / 10) * 10) + 1;
	var last = (parseInt(totalIndexCount/10) == parseInt(currentIndex/10)) ? totalIndexCount%10 : 10;
	var prev = (parseInt((currentIndex-1)/10)*10) - 9 > 0 ? (parseInt((currentIndex-1)/10)*10) - 9 : 1;
	var next = (parseInt((currentIndex-1)/10)+1) * 10 + 1 < totalIndexCount ? (parseInt((currentIndex-1)/10)+1) * 10 + 1 : totalIndexCount;

	preStr += "<input type='hidden' id='currentIndex' value='" + currentIndex + "'>";
	if(totalIndexCount > 10){ //전체 인덱스가 10이 넘을 경우, 맨앞, 앞 태그 작성
		preStr += "<button type='button' class='pg_first disable' onclick='" + eventName + "(1)'>첫 페이지로 가기</button>" +
				"<button type='button' class='pg_prev disable' onclick='" + eventName + "("+prev+")'>이전 페이지로 가기</button>";

		/*
		preStr += "<a href='#' class='first' onclick='" + eventName + "(1)'>처음</a>" +
				"<a href='#' class='before' onclick='" + eventName + "("+prev+")'>이전</a>";
		*/
	}
	else if(totalIndexCount <=10 && totalIndexCount > 1){ //전체 인덱스가 10보다 작을경우, 맨앞 태그 작성
		preStr += "<button type='button' class='pg_prev disable' onclick='" + eventName + "("+prev+")'>이전 페이지로 가기</button>";
		/*
		preStr += "<a href='#' class='before' onclick='" + eventName + "("+prev+")'>이전</a>";
		*/
	}

	if(totalIndexCount > 10){ //전체 인덱스가 10이 넘을 경우, 맨뒤, 뒤 태그 작성
		postStr += "<button type='button' class='pg_next' onclick='" + eventName + "("+next+")'>다음 페이지로 가기</button>" +
        	     "<button type='button' class='pg_last' onclick='" + eventName + "("+totalIndexCount+")'>마지막 페이지로 가기</button>";

        /*
		postStr += "<a href='#' class='next' onclick='" + eventName + "("+next+")'>다음</a>" +
					"<a href='#' class='last' onclick='" + eventName + "("+totalIndexCount+")'>마지막</a>";
		*/
	}
	else if(totalIndexCount <=10 && totalIndexCount > 1){ //전체 인덱스가 10보다 작을경우, 맨뒤 태그 작성
		postStr += "<button type='button' class='pg_next' onclick='" + eventName + "("+next+")'>다음 페이지로 가기</button>";
		/*
		postStr += "<a href='#' class='next' onclick='" + eventName + "("+next+")'>다음</a>";
		*/
	}

	for(var i=first; i<(first+last); i++){
		//console.log(i + ":::" + currentIndex);
		if(i == currentIndex){
			str += "<a title='현재페이지' href='javascript:;' onclick='" + eventName + "("+i+")' class='current'>"+i+"</a>";
			/*
			str += "<strong><a href='#' onclick='" + eventName + "("+i+")'>"+i+"</a></strong>";
			*/
		} else {
			str += "<a href='javascript:;' onclick='" + eventName + "("+i+")'>"+i+"</a>";
			/*
			str += "<a href='#' onclick='" + eventName + "("+i+")'>"+i+"</a>";
			*/
		}
	}
	$("#"+divId).append(preStr + str + postStr);
}