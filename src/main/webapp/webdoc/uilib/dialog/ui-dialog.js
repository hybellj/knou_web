/**
 * Dialog Box 생성
 *
 * let dialog = UiDialog(id, {OPTION});
 * 		id: 	dialog id값
 * 		option: {
 * 			title: 		타이틀
 * 			titlebar:	타이틀바 표시여부(true/false, 기본값:true)
 * 			width: 		너비(숫자)
 * 			height: 	높이(숫자)
 * 			resizable:	리사이즈 여부 (true/false, 기본값:true)
 * 			modal: 		모달 여부 (true/false, 기본값:true)
 * 			draggabe: 	드래그 여부 (true/false, 기본값:true)
 * 			autoresize: 자동 사이즈 조절(true/false, 기본값:false, url인 경우 내용 사이즈에 맞게 다이어로그 높이 자동 조절)
 * 			position:	다이얼로그 포지션 {my:"center top", at:"center top", of:"#TARGET"}
 * 			url:		다이얼로그 url, iframe에 url 호출
 * 			html:		다이얼로그 html 내용
 * 			fullscreen:	전체화면 표시(true/false, 기본값:false, 전체화면 적용할 경우 다른 옵션들은 모두 비활성)
 * 		}
 *
 * dialog.close(): 닫기
 */


/**
 * Dialog 생성
 */
function UiDialog(id, opts) {
	let dialogId = "UI_DIALOG_"+id;
	let dialogBox = $("#"+dialogId);
	if (dialogBox.length == 0) {
		dialogBox = $(`<div id="${dialogId}" style="display:none"></div>`);
		$("body").append(dialogBox);
	}
	else {
		dialogBox.parent().css({"position":"absolute"});
	}

	if (opts.url) {
		dialogBox.html(`<iframe frameborder="0" scrolling="auto" src="about:blank" style="border:0;width:100%;height:calc(100% - 10px);"></iframe>`);
	}
	else if (opts.html) {
		dialogBox.html(opts.html);
	}

	let title		= (opts.title === undefined || !opts.title) ? "<i class='xi-bars'></i>" : opts.title;
	let titlebar	= (opts.titlebar === undefined) ? true : opts.titlebar;
	let autoresize	= (opts.autoresize === undefined || !opts.autoresize) ? false : opts.autoresize;
	let fullscreen	= (opts.fullscreen === undefined || !opts.fullscreen) ? false : opts.fullscreen;
	let fullBodyOverflow = "";

	if (fullscreen) {
		fullBodyOverflow = $("body").css("overflow");
		$("body").css("overflow","hidden");

		opts.modal = true;
		opts.resizable = false;
		opts.draggable = false;
		opts.position = null;
		autoresize = false;
	}

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
			if (titlebar) {
				$(this).parent().find('.ui-dialog-title').html(title);
			}
			else {
				$(this).parent().find('.ui-dialog-titlebar').hide();
			}

			$(this).parent().addClass("dialog-box");
			UiComm.showTopLayer($(this).parent());

			if (opts.url) {
				let thisDialog = $(this);
				let iframe = $(this).children("iframe");
				let addH = titlebar ? 80 : 40;

				if (iframe.length > 0) {
					iframe.attr("src", opts.url);

					// 부모의 darkmode 상태를 iframe body에 미러링
					iframe.on("load", function () {
						let frameBody = this.contentWindow.document.body;
						$(frameBody).toggleClass("darkmode", $("body").hasClass("darkmode"));

						if ($("body").hasClass("darkmode")) {
							$(frameBody).find('.tb_contents').css('color', '#ffffff');
						}
					});

					// 자동 높이 조절
					if (autoresize) {
						let maxHeight = $(window).height() - 50;

						iframe.on("load", function() {
							let frameBody = this.contentWindow.document.body;
							let lastHeight = 0;
							let updateTimer = null;

							let updateHeight = () => {
								let newHeight = $(frameBody).outerHeight(true) + addH;
								if (newHeight > maxHeight) {
									newHeight = maxHeight;
								}

						        if (newHeight !== lastHeight && newHeight > lastHeight) {
						            thisDialog.dialog("option", "height", newHeight);
						            lastHeight = newHeight;
						        }
							};

							updateHeight();

							let observer = new MutationObserver(() => {
						        if (updateTimer) {
						            cancelAnimationFrame(updateTimer);
						        }
						        updateTimer = requestAnimationFrame(updateHeight);
						    });

							observer.observe(frameBody, {
						        childList: true,
						        subtree: true,
						        attributes: true,
						        attributeFilter: ['style', 'class', 'height']
						    });
						});
					}
				}
			}

			if (fullscreen) {
				$("#"+dialogId).dialog("option", {
		            width: $(window).width(),
		            height: $(window).height()
		        });

				$(window).resize(function() {
				    if ($("#"+dialogId).dialog("isOpen")) {
				        $("#"+dialogId).dialog("option", {
				            width: $(window).width(),
				            height: $(window).height()
				        });
				    }
				});
			}
			else {
				let $dialog = $(this).closest('.ui-dialog');
				let fixedTop = parseFloat($dialog.css('top')) - $(window).scrollTop();

				$(this).closest('.ui-dialog').css({
				    'position': 'fixed',
					'top': fixedTop + 'px'
				});
			}

		},
		close: function() {
			$(this).html("");

			if (fullscreen) {
				$("body").css("overflow",fullBodyOverflow);
			}
		}
	});

	/**
	 * Dialog 닫기
	 */
	dialog.close = function() {
		this.dialog("close");
	}

	return dialog;
}
