/**
 * Dialog Box 생성
 *
 * let dialog = UiDialog(id, {OPTION});
 * 		id: 	dialog id값
 * 		option: {
 * 			title: 		타이틀
 * 			width: 		너비(숫자)
 * 			height: 	높이(숫자)
 * 			resizable:	리사이즈 여부 (true/false, 기본값:true)
 * 			modal: 		모달 여부 (true/false, 기본값:true)
 * 			draggabe: 	드래그 여부 (true/false, 기본값:true)
 * 			autoresize: 자동 사이즈 조절(true/false, 기본값:false, url인 경우 내용 사이즈에 맞게 다이어로그 높이 자동 조절)
 * 			position:	다이얼로그 포지션 {my:"center top", at:"center top", of:"#TARGET"}
 * 		}
 *
 * dialog.close(): 닫기
 */


/**
 * Dialog 생성
 */
function UiDialog(id, opts) {
	let dialogBox = $("#UI_DIALOG_"+id);
	if (dialogBox.length == 0) {
		dialogBox = $(`<div id="UI_DIALOG_${id}" style="display:none"></div>`);
		$("body").append(dialogBox);
	}

	if (opts.url) {
		dialogBox.html(`<iframe frameborder="0" scrolling="auto" src="${opts.url}" style="border:0;width:100%;height:calc(100% - 10px);"></iframe>`);
	}
	else if (opts.html) {
		dialogBox.html(opts.html);
	}

	let title		= (opts.title === undefined || !opts.title) ? "<i class='xi-bars'></i>" : opts.title;
	let autoresize	= (opts.autoresize === undefined || !opts.autoresize) ? false : opts.autoresize;
	
	/**
	 * Dialog 생성
	 */
	let dialog = dialogBox.dialog({
		autoOpen: 	true,
		width: 		(opts.width === undefined || !opts.width) ? 500 : opts.width,
		height: 	(opts.height === undefined || !opts.height) ? 400 : opts.height,
		resizable: 	(opts.resizable === undefined) ? true : !opts.resizable ? false : opts.resizable,
		modal: 		(opts.modal === undefined || opts.modal === null) ? true : opts.modal,
		draggable: 	(opts.draggable === undefined || opts.draggable === null) ? true : opts.draggable,
		position:	(opts.position === undefined || opts.position === null) ? {my:"center center", at:"center center", of:window} : opts.position,
		open: function(event, ui) {
			$(this).parent().find('.ui-dialog-title').html(title);
			$(this).parent().addClass("dialog-box");
			UiComm.showTopLayer($(this).parent());
			
			if (autoresize && opts.url) {
				let thisDialog = $(this);
				let iframe = $(this).children("iframe");
				if (iframe.length > 0) {
					iframe.on("load", function() {
						thisDialog.dialog("option", "height", ($(this).contents().find("body").height() + 100));
					});
				}
			}
		},
		close: function() {
			$(this).html("");
		}
	});

	/**
	 * Dialog 닫기
	 */
	dialog.close = function() {
		this.dialog("close");
	}

	//dialog.open();
	
	return dialog;
}

