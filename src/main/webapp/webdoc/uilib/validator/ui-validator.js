
/**
 * 폼 입력필드 검사
 *
 * @param formId : 		폼아이디
 *
 * 사용예)
 * let validator = UiValidator("form1");
 * validator.then(function(result) {
 *     if (result) {
 * 		    // Validate 성공 Submit 처리
 * 	   }
 * 	   else {
 *         // Validate 실패 처리
 * 	       return false;
 * 	   }
 * });
 */
function UiValidator(formId) {
	let defer = $.Deferred();
	let fields = $("#"+formId).find("input[required='true'], textarea[required='true'], select[required='true']");
	let requiredMsgNo = 0;
	let requiredErrorCount = 0;

	fields.each(function () {
		let field = $(this);
		let value = $.trim(field.val());
		requiredMsgNo++;

		// input, textarea 필드 체크
		if (field.is("input") || field.is("textarea")) {
			let valueLength = value.length;
			let isEditor = false;
			let isPicker = false;
			let editorId = field.attr("editor");
			let editor = null;

			if (field.is("textarea") && window.UiEditors && editorId) {
				editor = window.UiEditors[editorId];
				if (editor && editor.isEmpty()) {
					isEditor = true;
					valueLength = 0;
				}
			}
			else if (field.hasClass("hasDatepicker") || field.hasClass("hasDatepicker")) {
				isPicker = true;
			}

			if (valueLength === 0) {
				requiredErrorCount++;

				if (!field.hasClass("input_error")) {
					requiredErrorCount++;
					field.addClass("input_error");

					if (isEditor) {
						$("#"+editorId).addClass("input_error");
						editor.setEventListener('afterEdit', function(e) {
							if (!editor.isEmpty()) {
								field.removeClass("input_error");

								$("#"+editorId).removeClass("input_error");
								editor.removeEventListener('afterEdit');
							}
						});
					}
					else if (isPicker) {
						field.on("change.required, input.required", function(event) {
						    if ($.trim($(this).val()).length > 0) {
								field.off("change.required, input.required");
								field.removeClass("input_error");
							}
						});
					}
					else {
						field.on("input.required", function(event) {
						    if ($.trim($(this).val()).length > 0) {
								field.off("input.required");
								field.removeClass("input_error");
							}
						});
					}
				}
			}
	    }
		// select 필드 체크
		else if (field.is("select")) {
			if (value.length === 0) {
				requiredErrorCount++;

				if (!field.hasClass("input_error")) {
					if (field.parent().is(".form-inline, .form-row")) {
						field.parent().css("flex-wrap", "wrap");
					}

					let chosenObj = null;
					if (field.hasClass("chosen")) {
						let obj = field.next();
						if (obj.length > 0 && obj.hasClass("chosen-container")) {
							chosenObj = obj;
							chosenObj.addClass("input_error");
						}
					}

					field.addClass("input_error");

					field.on("input.required", function(event) {
					    if ($.trim($(this).val()).length > 0) {
							field.off("input.required");
							field.removeClass("input_error");
							if (chosenObj) {
								chosenObj.removeClass("input_error");
							}
						}
					});
				}
			}
		}
	});

	
	
	if (requiredErrorCount > 0) {
		let msg = `${UiComm.getMsg("required_msg1")}<br>`
			+ `<input class='form-control input_error alert' type='text' readonly onfocus='this.blur();'> ${UiComm.getMsg("required_msg2")}`;
		
		defer.resolve(false);
		UiComm.showMessage(msg, "warning")
		.then(function(res){
			let top = $("#"+formId).offset().top;
			let header = $("header.common");
			if (header.length > 0) {
				top = top - header.outerHeight();
			}

			$('html, body').scrollTop(top);
		});
	}
	else {
		defer.resolve(true);
	}

	return defer.promise();
}