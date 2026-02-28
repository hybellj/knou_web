/*******************************************************************************
	입력창 inputmask 적용

	사용법:
		inputmask 속성값 :
			numeric : 숫자
			money	: 금액 (3자리마다 "," 삽입)
			phone	: 전화번호
			email	: 이메일
			date	: 날짜
			time	: 시간
			etc		: 지정된 mask값으로 설정
		mask : mask값 지정 (numeric, phone, etc 일 경우 참조)
		maxVal : 최대입력값 (numeric, money 일 경우)
		maxLen : 초대입력 사이즈(byte, inputmask='text' 일 경우만 참조)


	사용예:
		숫자, (최대 1000) : 			<input inputmask="numeric" maxVal="1000">
		점수 (소수점 2자리, 최대:100) : <input inputmask="numeric" mask="999.99" maxVal="100">
		금액 (최대 100,000) : 			<input inputmask="money" maxVal="100000">
		전화번호 : 						<input inputmask="phone">
		이메일 : 						<input inputmask="email">
		텍스트 (최대 100byte) :			<input inputmask="text" maxLen="100">
		기타 : 							<input inputmask="etc" mask="99-99[9][9]">
*******************************************************************************/


/**
 * 입력창에 inputmask 적용
 */
function UiInputmask() {
	let inputObj = $("input[inputmask]");
	let inputtextMap = new Map();

	for (let i=0; i<inputObj.length; i++) {
		let mskObj		= $(inputObj[i]);
		mskObj.maxVal 	= !mskObj.attr("maxVal") ? 0 : parseFloat(mskObj.attr("maxVal"));
		mskObj.mask		= mskObj.attr("mask");
		mskObj.maskType	= mskObj.attr("inputmask");
		mskObj.maxLen	= mskObj.attr("maxLen");
		mskObj.isDec 	= false;

		let id			= mskObj.attr("id");
		if (!id) {
			id = "uiInputText"+i;
			mskObj.attr("id", id);
		}

		inputtextMap.set(id, mskObj);

		// 숫자
		if (mskObj.maskType === "numeric") {
			if (!mskObj.mask) {
				mskObj.mask = "numeric";
			}
			if (mskObj.mask.indexOf(".") > 0) {
				mskObj.isDec = true;
			}

			mskObj.mask = (mskObj.mask).replace(/9/g,"[9]").replace(/\./g,"[.]");
			mskObj.inputmask(mskObj.mask, {placeholder:" ", rightAlign:true, showMaskOnFocus:true, allowMinus:false});

			mskObj.on("keydown", function(event){
				let inputObj = inputtextMap.get($(this).attr("id"));
				let val = parseFloat($(this).val());

				if (val > inputObj.maxVal && inputObj.maxVal > 0) {
					return false;
				}
				else if (!this.isDec && val == 0 && val.length > 1) {
					return false;
				}
			});

			mskObj.on("keyup", function(){
				let inputObj = inputtextMap.get($(this).attr("id"));
				let val = $(this).val();

				if (parseFloat(val) > inputObj.maxVal && inputObj.maxVal > 0) {
					$(this).val(this.curVal);
				}
				else if (!inputObj.isDec && parseFloat(val) == 0 && val.length > 1) {
					$(this).val(this.curVal);
				}
				else if (!inputObj.isDec && val.length > 1 && val.substr(0,1) == "0") {
					$(this).val(parseFloat(val));
				}
				else if (inputObj.isDec && val.length > 1 && val.substr(0,1) == ".") {
					$(this).val("0"+val);
				}

				else {
					this.curVal = val;
				}
			});

			mskObj.blur(function() {
				let inputObj = inputtextMap.get($(this).attr("id"));
				let val = $(this).val();
				let decIdx = val.indexOf(".");

				if (inputObj.isDec && val != "") {
					if (decIdx == -1) {
						$(this).val(parseFloat(val)+".0");
					}
					else if (val.length == decIdx+1) {
						$(this).val(val+"0");
					}
					else if (decIdx == 0) {
						$(this).val("0"+val);
					}
					else if (val.substr(0,decIdx).length > 0 && parseInt(val.substr(0,decIdx)) == 0) {
						$(this).val("0"+val.substr(decIdx));
					}
					else if (val.substr(decIdx+1).length > 0 && parseInt(val.substr(decIdx+1)) == 0) {
						$(this).val(val.substr(0,decIdx)+".0");
					}
					else {
						$(this).val(parseFloat(val));
					}
				}
				else if (val != "") {
					$(this).val(parseFloat(val));
				}
			});
		}
		// 금액
		else if (mskObj.maskType === "money") {
			mskObj.inputmask("numeric", {showMaskOnFocus:false, placeholder:" ",
				groupSeparator:",", autoGroup:true, integerDigits:10, digits:0, allowMinus:false});

			mskObj.on("keydown", function(event){
				let inputObj = inputtextMap.get($(this).attr("id"));
				let val = $(this).val().replace(/,/g,'');

				if (val > inputObj.maxVal && inputObj.maxVal > 0) {
					return false;
				}
			});

			mskObj.on("keyup", function(){
				let inputObj = inputtextMap.get($(this).attr("id"));
				let val = $(this).val().replace(/,/g,'');
				if (parseFloat(val) > inputObj.maxVal && inputObj.maxVal > 0) {
					$(this).val(this.curVal);
				}
				else {
					this.curVal = val;
				}
			});
		}
		// 전화번호
		else if (mskObj.maskType == "phone") {
			if (mskObj.mask == undefined || mskObj.mask == "") {
				mskObj.mask = "99[9]-999[9]-9999";
			}

			mskObj.inputmask({mask:mskObj.mask, greedy:false, showMaskOnFocus:false, removeMaskOnSubmit:true});
		}
		// 이메일
		else if (mskObj.maskType == "email") {
			mskObj.mask = "*{1,20}[.*{1,20}][.*{1,20}][.*{1,20}]@*{1,20}[.*{1,20}][.*{2,4}][.*{2,4}]";
			mskObj.inputmask({mask:mskObj.mask, greedy:false, showMaskOnFocus:false,
				definitions: {
			      '*': {
			          validator: "[0-9A-Za-z!#$%&'*+/=?^_`{|}~\-]",
			          casing: "lower"
			       }
			    }
			});
		}
		// Byte
		else if (mskObj.maskType == "byte") {
			if (mskObj.maxLen != undefined && mskObj.maxLen != "" && parseInt(mskObj.maxLen) > 0) {
				mskObj.on("keyup", function(){
					let inputObj = inputtextMap.get($(this).attr("id"));
					let val = $(this).val();
					let size = UiComm.conf.utf8 == true ? UiComm.getTextSizeUni(val) : UiComm.getTextSize(val);

					if (size > inputObj.maxLen) {
						val = UiComm.conf.utf8 == true ? UiComm.cutTextUni(val, inputObj.maxLen) : UiComm.cutText(val, inputObj.maxLen);
						$(this).val(val);
					}
				});
			}
		}
		// 길이(length), 글자수
		else if (mskObj.maskType == "length") {
			if (mskObj.maxLen != undefined && mskObj.maxLen != "" && parseInt(mskObj.maxLen) > 0) {
				mskObj.on("keyup", function(){
					let inputObj = inputtextMap.get($(this).attr("id"));
					let val = $(this).val();

					if (val.length > inputObj.maxLen) {
						val = val.substring(0, inputObj.maxLen);
						$(this).val(val);
					}
				});
			}
		}
		// 날짜
		else if (mskObj.maskType == "date") {
			mskObj.inputmask({regex: "^\\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\\d|3[01])$", showMaskOnFocus:false});
		}
		// 시간
		else if (mskObj.maskType == "time") {
			mskObj.inputmask({regex: "^([01]\\d|2[0-3]):[0-5]\\d$", showMaskOnFocus:false});
		}
		// 기타
		else {
			if (mskObj.mask != undefined && mskObj.mask != "") {
				mskObj.inputmask({mask:mskObj.mask, showMaskOnFocus:false});
			}
		}
	}
}


// textarea 입력제한 적용
function UiInputmaskText() {
	var textareaObj = $("textarea[maxLenCheck]");
	var textareaMap = new Map();

	for (var i=0; i<textareaObj.length; i++) {
		var mskObj		 = $(textareaObj[i]);
		mskObj.chkType	 = "byte";
		mskObj.maxLen	 = 0;
		mskObj.showCount = false;
		mskObj.showMsg	 = false;

		var attrs	= mskObj.attr("maxLenCheck").toLowerCase().replaceAll(" ","").split(",");
		var id		= mskObj.attr("id");
		if (id == undefined) {
			id = "textareaBox"+i;
			mskObj.attr("id", id);
		}

		textareaMap.set(id, mskObj);

		if (attrs.length >= 1) {
			mskObj.chkType = attrs[0];
		}
		if (attrs.length >= 2) {
			mskObj.maxLen = Number(attrs[1]);
		}
		if (attrs.length >= 3 && (attrs[2] == "true" || attrs[2] == "yes" || attrs[2] == "y")) {
			mskObj.showCount = true;
		}
		if (attrs.length >= 4 && (attrs[3] == "true" || attrs[3] == "yes" || attrs[3] == "y")) {
			mskObj.showMsg = true;
		}

		mskObj.unit = UiComm.getMsg('unit_char');
		if (mskObj.chkType == "byte") {
			mskObj.unit = UiComm.getMsg('unit_byte');
		}

		if (mskObj.showCount == true) {
			var limit = "";
			if (mskObj.maxLen > 0) {
				limit = " / "+mskObj.maxLen;
			}

			let width = "100%";
			let styleString = mskObj.attr('style');
			let widthValue = styleString.split(';').find(s => s.includes('width')).split(':')[1].trim();
			if (widthValue) {
				width = widthValue;
			}

			mskObj.addClass("show-count");
			var box = $(`<div style='display:inline-block;width:${width}'></div>`);
			mskObj.before(box);
			box.append(mskObj);

			var size = 0;
			if (mskObj.chkType === "byte") {
				size = UiComm.conf.utf8 == true ? UiComm.getTextSizeUni(mskObj.val()) : getTextSize(mskObj.val());
			}
			else {
				size = mskObj.val().length;
			}

			var countBox = $(`<div id='${id}_countBox' class='textarea-count'></div>`);
			var countIn = $(`<span id='${id}_countIn'>${size}</span>`);
			countBox.append(countIn);
			countBox.append($(`<span>${limit} ${mskObj.unit}</span>`));
			box.append(countBox);
			mskObj.countIn = $("#"+id+"_countIn");
		}

		mskObj.on("keyup", function(){
			var id = $(this).attr("id");
			var mskObj = textareaMap.get(id);
			var val = $(this).val();
			var size = 0;

			if (mskObj.chkType == "byte") {
				size = UiComm.conf.utf8 == true ? UiComm.getTextSizeUni(val) : getTextSize(val);
			}
			else {
				size = val.length;
			}

			if (mskObj.maxLen > 0 && size > mskObj.maxLen) {
				if (mskObj.chkType == "byte") {
					val = UiComm.conf.utf8 == true ? UiComm.cutTextUni(val, mskObj.maxLen) : cutText(val, mskObj.maxLen);
					size = UiComm.conf.utf8 == true ? UiComm.getTextSizeUni(val) : getTextSize(val);
				}
				else {
					val = val.substring(0, mskObj.maxLen);
					size = val.length;
				}

				$(this).val(val);

				if (mskObj.showMsg) {
					var message = UiComm.getMsg('no_input_max', mskObj.maxLen + mskObj.unit);
					UiComm.showMessage(message, "warning");
				}
			}

			if (mskObj.countIn != null) {
				mskObj.countIn.html(size);
			}
		});
	}
}
