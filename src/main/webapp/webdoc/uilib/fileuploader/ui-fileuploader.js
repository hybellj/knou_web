
// 기본설정
let dex5Object 	= new Object();
dex5Object.path = "";							// 업로드 경로
dex5Object.finishFunc = "";						// 업로드 종료시 호출
dex5Object.deletelFileId =  new Array();		// 업로드된 파일 정보를 업로드 컴포넌트에서 보여줄때 사용
dex5Object.virtualFileList = "";				// 업로드된 파일 정보를 업로드 컴포넌트에서 보여줄때 사용
dex5Object.uploadMode = "ORAF";					// 업로드 모드 : ORAF(기본), OROF(개별), EXNJ(대용량)
dex5Object.blockSize = (10 * 1024 * 1024);		// 업로드 block 사이즈
dex5Object.fileCount = 1;						// 업로드 파일수
dex5Object.maxTotalSize = (100 * 1024 * 1024);	// 총 업로드 용량
dex5Object.maxFileSize = (100 * 1024 * 1024);	// 1개 파일 제한 용량
dex5Object.minFileSize = 0;						// 최소 파일 용량
dex5Object.extensionFilter = "*";				// 업로드 가능 파일 확장명
dex5Object.noExtension = "exe,com,bat,cmd,jsp,msi,html,htm,js,scr,asp,aspx,php,php3,php4,ocx,jar,war,py"; // 업로드 불가능 파일 확장명
dex5Object.fileUploadTotalCount = 0; 			// 파일 업로드 갯수
dex5Object.fileUploadName = new Array();		// 파일명 목록
dex5Object.fileUploadId = new Array();			// 파일ID 목록
dex5Object.uploadUrl = "/dext/uploadFileDext.up";			// 업로드URL(일반)
dex5Object.uploadUrlBig = "/dext/uploadBulkFileDexts.up";	// 업로드URL(대용량)

let fileInfo = "";
let uplod_result = false;

// 업로더 환경 변수
let DX_ENV = new Object();

// 파일업로더 생성 (Dextuploader)
function UiFileUploader(opts) {
	let id = opts.id;
	let targetId = opts.targetId;
	let uploadMode = (opts.bigSize == undefined || !opts.bigSize) ? "ORAF" : "EXNJ";
	let lang = (opts.lang == undefined ? "ko" : opts.lang);
	let uploadUrl = opts.uploadUrl;

	if (uploadUrl == undefined || uploadUrl == "") {
		if (uploadMode == "ORAF") {
			uploadUrl = dex5Object.uploadUrl;
		}
		else {
			uploadUrl = dex5Object.uploadUrlBig;
		}
	}
	if (uploadUrl.indexOf("http") != 0) {
		uploadUrl = window.location.origin + uploadUrl;
	}

	let uiMode = opts.uiMode == undefined ? "normal" : opts.uiMode;
	let style = opts.style == undefined ? "list" : opts.style;
	let listSize = opts.listSize == undefined ? 1 : opts.listSize;
	let height = style == "single" ? 35 : (72 + (listSize * 36));
	let addBtnMsg = getMsg('select');
	let delBtnMsg = getMsg('delete');
	let btnAareaStyle = "";
	let btnClass = "";
	let cssStyle = "width:100%;height:"+height+"px;";
		
	if (uiMode == "simple") {
		addBtnMsg = "<i class='xi-file-add-o'></i>";
		delBtnMsg = "<i class='xi-trash-o'></i>";
		
		cssStyle += "display:flex";
		btnAareaStyle = "display:flex";
		btnClass += "simple";
		//btnStyle = "height:"+height+"px;";
	}

/*
	tag.append("<button type=\"button\" id=\""+id+"_btn-add\" style=\""+btnStyle+"\" title=\""+message.getMessage("button.select.file")+"\"><i class='xi-file-add-o'></i></button>");
	tag.append("<button type=\"button\" id=\""+id+"_btn-delete\" disabled='true' style=\""+btnStyle+"\" title=\""+message.getMessage("button.delete")+"\"><i class='xi-trash-o'></i></button>");
	tag.append("<button type=\"button\" id=\""+id+"_btn-reset\" style=\""+btnStyle+resetStyle+"\" title=\""+message.getMessage("button.reset")+"\" onclick=\"resetDextFiles('"+id+"')\"><i class='xi-refresh'></i></button>");	
*/


	let container = `
		<div id="${id}-container" class="dext5-container ${btnClass}" style="width:100%;height:${height}px;"></div>
		<div id="${id}-btn-area" class="dext5-btn-area" style="${btnAareaStyle}">
			<button type="button" id="${id}_btn-add" style="" title="${getMsg('select')}">${addBtnMsg}</button>
			<button type="button" id="${id}_btn-delete" disabled='true' style="" title="${getMsg('delete')}">${delBtnMsg}</button>
			<button type="button" id="${id}_btn-reset" style="display:none" title="${getMsg('reset')}" onclick="resetDextFiles('fileUploader')"><i class='xi-refresh'></i></button>
		</div>
	`;

	$("#"+opts.targetId).append(container);

	DX_ENV[id] = {
		totalCount: 0,
		fileUploadNames: new Array(),
		fileUploadIds: new Array(),
		blockSize: dex5Object.blockSize,
		uploadMode: (opts.bigSize == undefined || !opts.bigSize) ? "ORAF" : "EXNJ",
		fileCount: (opts.limitCount == undefined ? dex5Object.fileCount : opts.limitCount),
		maxTotalSize: (opts.limitSize == undefined ? dex5Object.maxTotalSize : (opts.limitSize * 1024 * 1024)),
	    maxFileSize: (opts.oneLimitSize == undefined ? dex5Object.maxFileSize : (opts.oneLimitSize * 1024 * 1024)),
		minFileSize: dex5Object.minFileSize,
		extensionFilter: opts.allowedTypes == undefined ? "*" : opts.allowedTypes,
		noExtension: opts.noExtension == undefined ? dex5Object.noExtension : opts.noExtension,
	    finishFunc: opts.finishFunc == undefined ? "" : opts.finishFunc,
	    uploadUrl: uploadUrl,
	    path: (opts.path == undefined ? "" : opts.path),
		oldFiles: opts.fileList == undefined ? "" : opts.fileList,
		useFileBox: (opts.useFileBox == undefined ? false : opts.useFileBox),
		btnFile: id+"_btn-add",
		btnDelete: id+"_btn-delete",
		lang: (opts.lang == undefined ? "ko" : opts.lang),
		style: style,
		uiMode: uiMode
	};

	dx5.create({
	    mode: "multi",
	    id: id,
	    parentId: id+"-container",
	    btnFile: id+"_btn-add",
	    btnDeleteSelected: id+"_btn-delete",
	    lang: (opts.lang == undefined ? "ko" : opts.lang),
		style: style,
		statusBarVisible:true
	});

	// 메시지
	function getMsg(key, ...args) {
	    let msg = UiFileUploaderMsg[lang][key];
	    msg = msg.replace(/\{(\d+)\}/g, (match, index) => {
	        if (index < args.length && args[index] !== undefined && args[index] !== null) {
	            return args[index];
	        }
	        return match;
	    });

	    return msg;
	}
}


// 파일업로더 생성 (Dextuploader)
function UiFileUploader_old(data) {
	DX_ENV[data.id] = {
		totalCount: 0,
		fileUploadNames: new Array(),
		fileUploadIds: new Array(),
		blockSize: dex5Object.blockSize,
		uploadMode: (data.uploadMode == undefined ? dex5Object.uploadMode : data.uploadMode),
		fileCount: (data.fileCount == undefined ? dex5Object.fileCount : data.fileCount),
		maxTotalSize: (data.maxTotalSize == undefined ? dex5Object.maxTotalSize : (data.maxTotalSize * 1024 * 1024)),
	    maxFileSize: (data.maxFileSize == undefined ? dex5Object.maxFileSize : (data.maxFileSize * 1024 * 1024)),
		minFileSize: (data.minFileSize == undefined ? dex5Object.minFileSize : data.minFileSize),
		extensionFilter: (data.extensionFilter == undefined ? "*" : data.extensionFilter),
		noExtension: (data.noExtension == undefined ? dex5Object.noExtension : data.noExtension),
	    finishFunc: (data.finishFunc == undefined ? "" : data.finishFunc),
	    uploadUrl: (data.uploadUrl == undefined ? "" : data.uploadUrl),
	    path: (data.path == undefined ? "" : data.path),
		oldFiles: (data.oldFiles == undefined ? "" : data.oldFiles),
		useFileBox: (data.useFileBox == undefined ? false : data.useFileBox),
		btnFile: data.btnFile,
		btnDelete: data.btnDelete,
		lang: (data.lang == undefined ? "ko" : data.lang),
		style: (data.style == undefined ? "list" : data.style),
		uiMode: (data.uiMode == undefined ? "normal" : data.uiMode)
	};

	dx5.create({
        mode: (data.mode == undefined ? "multi" : data.mode),
        id: data.id,
        parentId: data.parentId,
        btnFile: data.btnFile,
        btnDeleteSelected: data.btnDelete,
        lang: (data.lang == undefined ? "ko" : data.lang),
		style: (data.style == undefined ? "list" : data.style),
		statusBarVisible:true
    });
}


// Dext uploader 생성후 callback 함수
function onDX5Created(id) {
	var dx = dx5.get(id);
	var env = DX_ENV[id] == undefined ? new Object() : DX_ENV[id];
	dx.env = env;

	if(env.oldFiles != "" && env.oldFiles.length > 0) {
		var virtualFileList = [];
		for(var i = 0; i < env.oldFiles.length; i++) {
			virtualFileList.push({vindex: env.oldFiles[i].fileId, name: env.oldFiles[i].fileNm, size: env.oldFiles[i].fileSize, saveNm: env.oldFiles[i].fileNm});
		}
		dx.addVirtualFileList(virtualFileList);
	}

	if (env.uiMode == "simple") {
		dx.setUIStyle({
			headerVisible:false, statusBarVisible:false
		});
	}

	var uploadMode		= dex5Object.uploadMode;
	var blockSize		= dex5Object.blockSize;
	var fileCount 		= dex5Object.fileCount;
	var maxTotalSize 	= dex5Object.maxTotalSize;
	var maxFileSize 	= dex5Object.maxFileSize;
	var minFileSize 	= dex5Object.minFileSize;
	var extensionFilter = dex5Object.extensionFilter;
	var uploadUrl		= "";

	if (extensionFilter == "") {
		extensionFilter = "*";
	}

	// 개별 설정이 있는 경우
	if (env != null && env != undefined) {
		if (env.uploadMode != undefined)		uploadMode 		= env.uploadMode;
		if (env.blockSize != undefined)			blockSize 		= env.blockSize;
		if (env.fileCount != undefined)			fileCount 		= env.fileCount;
	    if (env.maxTotalSize != undefined)		maxTotalSize 	= env.maxTotalSize;
	    if (env.maxFileSize != undefined)		maxFileSize 	= env.maxFileSize;
	    if (env.extensionFilter != undefined)	extensionFilter = env.extensionFilter;
	    if (env.uploadUrl != undefined)			uploadUrl 		= env.uploadUrl;
	}

	dx.id = id;
	dx.env = env;
	dx.uploadUrl = uploadUrl;
	dx.setUIStyle({checkerVisible: false});	// 체크표시 비활성
	dx.setEnableColumnSorting(false);		// 칼럼 정렬 비활성
	dx.checkDuplication(true);				// 항목이 추가될 때마다 중복 검사
	dx.setUploadMode(uploadMode); 			// 업로드 모드
	dx.setUploadBlockSize(blockSize); 		// block 사이즈
	dx.setMaxTotalSize(maxTotalSize); 		// 파일갯수 합의 용량 넘으면 제한
	dx.setMaxFileSize(maxFileSize); 		// 한 파일의  최대용량
	dx.setMinFileSize(minFileSize); 		// 한 파일의  최소용량
	dx.setExtensionFilter(extensionFilter); // 파일업로드 제한
	dx.copyFiles = [];

	if (env.style != "single") {
		dx.setMaxFileCount(fileCount); 			// 첨부하는 파일의 갯수
	}

	$("#"+id+"-btn-area").show();
	$("#"+id+"-container").prepend($("#"+id+"-btn-area"));

    // 파일함에서 가져오기 모달박스
    if (env.useFileBox == true) {
		var boxTitle = "파일함";
		if (env.lang != "ko") {
			boxTitle = "File Box";
		}

    	if ($("#fileBoxForm1").length == 0) {
        	$("body").append($("<form id='fileBoxForm1' name='fileBoxForm1'><input type='hidden' name='menuType' value='dext'><input type='hidden' name='tabCd' value='"+id+"'></form>"));

            var boxModal = ""
            	   + " <div class='modal fade in' id='fileBoxModal1' tabindex='-1' role='dialog' aria-labelledby='Modal' aria-hidden='false' style='display: none; padding-right: 17px;'>"
            	   + "     <div class='modal-dialog modal-lg' role='document'>"
            	   + "         <div class='modal-content'>"
            	   + "             <div class='modal-header'>"
            	   + "                 <button type='button' class='close' data-dismiss='modal' aria-label='Close'>"
            	   + "                     <span aria-hidden='true'>&times;</span>"
            	   + "                 </button>"
            	   + "                 <h4 class='modal-title'>"+boxTitle+"</h4>"
            	   + "             </div>"
            	   + "             <div class='modal-body'>"
            	   + "                 <iframe src='' width='100%' id='fileBoxIfm1' name='fileBoxIfm1' title='fileBoxIfm1'></iframe>"
            	   + "             </div>"
            	   + "         </div>"
            	   + "     </div>"
            	   + " </div>";
            $("#"+id+"-container").after($(boxModal));

            $("#"+id+"_btn-filebox").bind('click', function() {
        		$("#fileBoxForm1").attr("target", "fileBoxIfm1");
                $("#fileBoxForm1").attr("action", "/file/fileHome/popup/fileBoxCopy.do");
                $("#fileBoxForm1").submit();

                $('#fileBoxModal1').modal('show');
                $('#fileBoxIfm1').iFrameResize();
                window.closeFileBox = function() {
                    $('.modal').modal('hide');
                };
            });
    	}
    }

	$("#"+id+"_btn-delete").on('click',function() {
		$(this).attr("disabled",true);
	});

	// 업로드 시작
	dx.startUpload = function() {
		dx.resetUploadUrl();
		dx.upload();
	};

	// 업로드 파일 정보
	dx.getUploadFiles = function() {
		var res = dx.getResponses();
		var files = [];

		try {
			for (var i=0; i<res.length; i++) {
				var upFiles = eval(res[i]);
				for (var j=0; j<upFiles.length; j++) {
					files.push(upFiles[j]);
				}
			}

			return JSON.stringify(files).replace(/\"/gi, "\\\"");
		}
		catch(e) {
			console.log("File upload error.....\n"+e+"\n\n"+res);
		}
	};

	// 경로
	dx.getUploadPath = function() {
		return dx.env.path;
	};

	// 경로 설정
	dx.setUploadPath = function(path) {
		dx.env.path = path;
	};

	// 삭제파일 ID 목록 (배열)
	dx.getDelFileIds = function() {
		var delFiles = dx.getRemovedFiles();
		var delIds = [];

		if (delFiles.length > 0) {
			 for(var i=0; i<delFiles.length; i++) {
				if (delFiles[i].vindex.indexOf("FILEBOX:") == -1) {
					delIds.push(delFiles[i].vindex);
				}
			}
		}

		return delIds;
	};

	// 삭제파일 ID 목록 (문자열)
	dx.getDelFileIdStr = function() {
		var delFiles = dx.getRemovedFiles();
		var delIdStr = "";

		if (delFiles.length > 0) {
			 for(var i=0; i<delFiles.length; i++) {
				if (delFiles[i].vindex.indexOf("FILEBOX:") == -1) {
					if (i>0) delIdStr += ",";
					delIdStr += delFiles[i].vindex;
				}
			}
		}

		return delIdStr;
	};

	// 파일함에서 가져온 파일 삭제
	dx.deleteCopyFile = function(fileId) {
		for (var i=0; i<dx.copyFiles.length; i++) {
			let cpFile = dx.copyFiles[i];
			if (cpFile.fileId == fileId) {
				dx.copyFiles.splice(i,1);
				break;
			}
		}
	};

	// 파일함에서 가져온 파일 정보
	dx.getCopyFiles = function() {
		var cpFiles = dx.copyFiles;
		var fileArray = new Array();
        var fileVO = null;
		var delFiles = dx.getRemovedFiles();

		for (var i=0; i < cpFiles.length; i++) {
			var addCheck = true;

			if (delFiles.length > 0) {
				for (var j=0; j<delFiles.length; j++) {
					if (delFiles[j].vindex.indexOf(cpFiles[i].fileId) > -1) {
						addCheck = false;
						break;
					}
				}
			}

			if (addCheck) {
				fileVO = new Object();
				fileVO.fileId		= cpFiles[i].fileId;
				fileVO.fileNm 		= cpFiles[i].fileNm;
				fileVO.fileSaveNm	= cpFiles[i].fileSaveNm;
				fileVO.fileSize 	= cpFiles[i].fileSize;
				fileVO.filePath 	= cpFiles[i].filePath.replace(/\\/g, "\/");
				fileVO.encFileSn	= cpFiles[i].encFileSn;
				fileArray.push(fileVO);
			}
		}

		return JSON.stringify(fileArray).replace(/\"/gi, "\\\"");
	};

	// 파일함에서 파일 추가
	dx.addCopyFiles = function(list) {
		var count = 0;
		for(let i=0; i<list.length; i++) {
			count++;
			let fileInfo = list[i];
			fileInfo.fileId = getDextNewFileId();
			dx.copyFiles.push(fileInfo);

			dx.addVirtualFile({
				vindex: "FILEBOX:"+fileInfo.fileId,
				name: fileInfo.fileNm,
				size: fileInfo.fileSize
			});
		}

		onItemAddedFileBox(this.id, count);
	}

	// Old 파일목록 추가
	dx.addOldFileList = function(list) {
		dx.addVirtualFileList(list);
	}

	// 업로드 가능 여부
	dx.availUpload = function() {
		if (dx.hasUploadableItems() && dx.getTotalItemCount() > 0) {
			return true;
		}
		else {
			return false;
		}
	}

	// 업로드 URL 재설정
	dx.resetUploadUrl = function() {
		if(dx.hasUploadableItems() && dx.getTotalItemCount() > 0) {
			let uploadUrl = dx.env.uploadUrl;
			uploadUrl += (uploadUrl.indexOf("?") == -1 ? "?" : "&") + "path=" + dx.env.path;

	    	let fileIds = new Array();
	        for(var i= 0; i<dx.getTotalItemCount(); i++) {
	            fileIds[i] = getDextNewFileId();
	        }

	        uploadUrl += "&fileId=" + fileIds;
	        dx.setUploadURL(uploadUrl);
		}
	}

	// 업로드 파일수
	dx.getFileCount = function() {
		return dx.getTotalLocalFileCount();
	}

	// 초기화버튼 표시 설정
	dx.showResetBtn = function() {
		if (dx.getTotalVirtualFileCount() > 0) {
			$("#"+dx.id+"_btn-reset").css("display","inline-block");
		}
		else {
			$("#"+dx.id+"_btn-reset").hide();
		}
	}
}


function onDX5Error(id, code, msg) {
	var dx = dx5.get(id);

	if(code == "ESVG-00038" || code == "ESVG-00050" || code == "ESVG-00044") {
		console.log(id + " => " +  code + "\n" + msg);
	} else {
		console.log(id + " => " +  code + "\n" + msg);

		var errorMsg = "파일 업로드중 에러가 발생했습니다.";
		if (dx.env.lang != "ko") {
			errorMsg = "An error occurred while uploading the file.";
		}

		alert(errorMsg);
	}
}

function onDX5UploadStopped(id) {
	// console.log("업로드가 중단되었습니다.");
}

function onDX5ItemDoubleClick(id, itemIndex, itemId, itemType) {
	// console.log("중복클릭");
}

function onDX5UploadCompleted(id) {
	var dx = dx5.get(id);
	var env = dx.env;

	// 파일업로드 컴포넌트에서 설정한 함수호출
	if (env.finishFunc && typeof env.finishFunc === "function") {
		env.finishFunc(id);
	}
}

// 업로드 파일 수
function getFileCount(id) {
	var dx = dx5.get(id);
	return dx.getTotalLocalFileCount();
}

function onDX5ItemsAdded(id, count, arr) {
	var dx = dx5.get(id);
	var totCount = dx.getTotalItemCount();
	if (totCount > dx.env.fileCount) {
		var errorMsg = "파일의 최대 개수("+dx.env.fileCount+")를 넘었습니다.";
		if (dx.env.lang != "ko") {
			errorMsg = "The maximum number of files ("+dx.env.fileCount+") has been exceeded.";
		}
		alert(errorMsg);

		for (var i=0; i<arr.length; i++) {
			dx.removeById(arr[i], true);
		}
	}
}

function onDX5UploadBegin(id) {
	//alert("onDX5UploadBegin");
}

function onDX5UploadItemEnd(id, itemId) {
	// alert("onDX5UploadItemEnd");
}

function onDX5UploadItemStart(id, itemId) {
	// alert("onDX5UploadItemStart");

	var dx = dx5.get(id);
	var uploadMode = dx.getUploadMode();
	var uploadUrl = dx.getUploadURL();

	// 대용량 업로드 블럭(청크) 단위로 업로드 요청
	if(uploadMode == "EXNJ") {
		var url = new URL(uploadUrl);
		var urlParams = new URLSearchParams(url.search);
		var paramsObj = Object.fromEntries(urlParams.entries());

		paramsObj.itemIndex = dx.getItemIndex(itemId);

		var queryStr = new URLSearchParams(paramsObj).toString();
		var newUrl = url.origin + url.pathname + "?" + queryStr;

		dx.setUploadURL(newUrl);
	}
}

function onDX5DragAndDrop(id) {
	// alert("onDX5DragAndDrop");
}

function onDX5BeforeItemsAdd(id, count) {
	//alert(id, count);
}

function onDX5ItemSelect(id, itemIndex, itemId, itemType) {
	$("#"+id+"_btn-delete").attr("disabled",false);
}

// 파일 확장명 체크
function onDX5ItemAdding(id, obj) {
	var dx = dx5.get(id);
	var noExtension = dx.env.noExtension;
	var lastDot = obj.name.lastIndexOf('.');
	var check = true;

	if (lastDot > -1 && noExtension != "") {
		var noExts = noExtension.split(",");
		var ext = obj.name.substring(lastDot+1, obj.name.length).toLowerCase();

		for (var i=0; i<noExts.length; i++) {
			if (ext == noExts[i]) {
				check = false;
				break;
			}
		}
	}

	if (!check) {
		var msg = "업로드할 수 없는 파일입니다.";
		if (dx.env.lang != "ko") {
			msg = "This file cannot be uploaded.";
		}
		alert("["+obj.name+"] "+msg);
	}

	return check;
}

// 파일함에서 파일 추가
function addDextFromFileBox(id, list) {
	var dx = dx5.get(id);
	dx.addCopyFiles(list);
}

function onItemAddedFileBox(id, count) {
	//alert(id, count);
}

// 삭제파일 초기화
function resetDextFiles(id) {
	var dx = dx5.get(id);
	dx.removeAll();
	dx.revokeAllVirtualFiles();
}

// File ID 생성
function getDextNewFileId() {
	var digits = [
		'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
		'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
		'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
	var newId = "";

	for (var i = 0; i < 4; i++) {
		newId += digits[Math.floor(Math.random() * 52)];
	}

	var	nowDate	= new Date();
	newId += digits[(nowDate.getYear() % 100)-1];
	newId += digits[nowDate.getMonth()];
	newId += digits[nowDate.getDate()];
	newId += digits[nowDate.getHours()];
	newId += digits[nowDate.getMinutes()];
	newId += digits[nowDate.getSeconds()];

	var randStr = 'xxxxxxxxxxxx'.replace(/[x]/g, function(c) {
		var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 3 | 8);
	    return v.toString(16);
	});

	return newId + randStr;
}


// 파일업로더 메시지
const UiFileUploaderMsg = {
    ko: {
        select: "파일선택",
        delete: "삭제",
        reset: "초기화"
    },
    en: {
		select: "Select",
		delete: "Delete",
		reset: "Reset"
    },
    ja: {
		select: "ファイル選択",
		delete: "削除",
		reset: "初期化"
    },
    zh: {
		select: "选择文件",
		delete: "删除",
		reset: "重置"
    }
};