
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
dex5Object.itemHeight = 30;						// 아이템 기본 높이
dex5Object.extensionFilter = "*";				// 업로드 가능 파일 확장명
dex5Object.noExtension = "exe,com,bat,cmd,jsp,msi,html,htm,js,scr,asp,aspx,php,php3,php4,ocx,jar,war,py"; // 업로드 불가능 파일 확장명
dex5Object.fileUploadTotalCount = 0; 			// 파일 업로드 갯수
dex5Object.lang = "ko";							// 언어
dex5Object.fileUploadName = new Array();		// 파일명 목록
dex5Object.fileUploadId = new Array();			// 파일ID 목록
dex5Object.uploadUrl = "/dext/uploadFileDext.up";			// 업로드URL(일반)
dex5Object.uploadUrlBig = "/dext/uploadBulkFileDexts.up";	// 업로드URL(대용량)

let fileInfo = "";
let uplod_result = false;

// 업로더 환경 변수
let DX_ENV = new Object();



/**
 * 파일업로더(Dextuploader)
 *
 * UiFileUploader({
 * 		id: "uploaderId",			// 파일업로더 ID
 * 		targetId: "targetId",		// 업로더를 넣을 대상객체 ID
 * 		url: "URL",					// 업로드 처리 서버 URL (생략시 기본값)
 * 		path: "/data/path",			// 업로드 경로
 * 		lang: "ko",					// 언어 (생략시 시스템 기본값 적용됨)
 * 		limitCount: 5,				// 업로드 가능 파일 수 (생략시 기본값: 1)
 * 		limitSize: 100,				// 업로드 가능 파일 사이즈 합계(MB, 기본값:100Mb)
 * 		oneLimitSize: 100,			// 파일 한개당 최대 크기 (MB, 기본값:100Mb)
 * 		listSize: 3,				// 파일목록 표시수 (창크기)
 * 		allowedTypes: "*",			// 업로드 가능 타입 (확장명만 입력, 구분자[,], 전체:*)
 * 		notAllowedTypes: "",		// 업로드 금지 타입 (생략시 기본값 설정, 확장명만 입력, 구분자[,])
 * 		finishFunc: finishUpload,	// 업로드 종료시 호출할 함수명(()는 생략하고 함수명만 입력), finishUpload(id) 와 같이 id 전달
 * 		bigSize: false, 			// 대용량 업로드 (기본값 false)
 * 		uiMode: "normal", 			// UI 모드 (normal, simple, single)
 * 		fileList: null				// 기존 업로드된 파일 목록(수정화면에서 사용)
 * });
 *
 * // 업로더 객체 가져오기
 * let dx = dx5.get("uploaderId");
 *
 * // 업로드할 파일이 있는지 확인(true/false 리턴)
 * dx.availUpload()
 *
 * // 업로드 시작
 * dx.startUpload()
 *
 * // 업로드 완료된 파일 정보 가져오기
 * dx.getUploadFiles()
 *
 * // 업로드 경로 가져오기
 * dx.getUploadPath()
 *
 * // 삭제파일 ID 목록 가져오기
 * dx.getDelFileIdStr()
 *
 */
function UiFileUploader(opts) {
	dex5Object.lang = (opts.lang == undefined ? "ko" : opts.lang);

	let id = opts.id;
	let targetId = opts.targetId;
	let uploadMode = (opts.bigSize == undefined || !opts.bigSize) ? "ORAF" : "EXNJ";
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
	let style = uiMode == "single" ? uiMode : "list";
	let fileCount = opts.limitCount == undefined ? dex5Object.fileCount : opts.limitCount;
	let listSize = opts.listSize == undefined ? 1 : opts.listSize;
	let addBtnTxt = getUploaderMsg('select');
	let delBtnTxt = getUploaderMsg('delete');

	if (listSize > fileCount) {
		listSize = fileCount;
	}

	let height = uiMode == "single" ? 35 : (listSize * dex5Object.itemHeight) + 72;
	let containerClass = "dext5-container";
	let containerCss = "height:"+height+"px;";

	if (uiMode == "simple") {
		height = listSize * dex5Object.itemHeight;
		containerClass += " simple";
		addBtnTxt = "<i class='xi-plus-circle-o'></i>";
		delBtnTxt = "<i class='xi-minus-circle-o'></i>";
	}

	let container = `<div id="${id}-container" class="${containerClass}" style="${containerCss}">`;
	if (uiMode !== "single") {
		container += `<div id="${id}-btn-area" class="dext5-btn-area">
				<button type="button" id="${id}_btn-add" title="${getUploaderMsg('select')}">${addBtnTxt}</button>
				<button type="button" id="${id}_btn-delete" disabled='true' title="${getUploaderMsg('delete')}">${delBtnTxt}</button>
				<button type="button" id="${id}_btn-reset" style="display:none;" title="${getUploaderMsg('reset')}" onclick="resetDextFiles('${id}')"><i class='xi-refresh'></i></button>
			</div>`;
	}
	container += `</div>`;

	$("#"+opts.targetId).append(container);

	DX_ENV[id] = {
		totalCount: 0,
		fileUploadNames: new Array(),
		fileUploadIds: new Array(),
		blockSize: dex5Object.blockSize,
		uploadMode: (opts.bigSize == undefined || !opts.bigSize) ? "ORAF" : "EXNJ",
		fileCount: fileCount,
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
		style: uiMode == "single" ? uiMode : "list",
		uiMode: uiMode,
		listSize: listSize
	};

	dx5.create({
	    mode: "multi",
	    id: id,
	    parentId: id+"-container",
	    btnFile: id+"_btn-add",
	    btnDeleteSelected: id+"_btn-delete",
	    lang: (opts.lang == undefined ? "ko" : opts.lang),
		style: style
	});

}


// Dext uploader 생성후 callback 함수
function onDX5Created(id) {
	let dx = dx5.get(id);
	let env = DX_ENV[id] == undefined ? new Object() : DX_ENV[id];
	dx.env = env;

	if(env.oldFiles != "" && env.oldFiles.length > 0) {
		let virtualFileList = [];
		for(let i = 0; i < env.oldFiles.length; i++) {
			virtualFileList.push({vindex: env.oldFiles[i].fileId, name: env.oldFiles[i].fileNm, size: env.oldFiles[i].fileSize, saveNm: env.oldFiles[i].fileNm});
		}
		dx.addVirtualFileList(virtualFileList);
	}

	let uploadMode		= dex5Object.uploadMode;
	let blockSize		= dex5Object.blockSize;
	let fileCount 		= dex5Object.fileCount;
	let maxTotalSize 	= dex5Object.maxTotalSize;
	let maxFileSize 	= dex5Object.maxFileSize;
	let minFileSize 	= dex5Object.minFileSize;
	let extensionFilter = dex5Object.extensionFilter;
	let itemHeight		= dex5Object.itemHeight;
	let uploadUrl		= "";

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

	if (env.uiMode == "simple") {
		dx.setUIStyle({headerVisible:false, statusBarVisible:false, itemHeight:itemHeight});
		$("#"+id+"-container").css("height", (env.listSize * itemHeight)+"px");
		$("#"+id+"-btn-area").css("display","flex");
	}
	else {
		dx.setUIStyle({_headerHeight:itemHeight, footerHeight:itemHeight, itemHeight:itemHeight});
		$("#"+id+"-btn-area").css("display","block");
	}

	$("#"+id+"_btn-delete").on('click',function() {
		$(this).attr("disabled",true);
	});

	// 업로드 시작
	dx.startUpload = function() {
		dx.resetUploadUrl();
		dx.upload();
	}

	// 업로드 파일 정보
	dx.getUploadFiles = function() {
		let res = dx.getResponses();
		let files = [];

		try {
			for (let i=0; i<res.length; i++) {
				let upFiles = eval(res[i]);
				for (let j=0; j<upFiles.length; j++) {
					files.push(upFiles[j]);
				}
			}

			return JSON.stringify(files).replace(/\"/gi, "\\\"");
		}
		catch(e) {
			console.log("File upload error.....\n"+e+"\n\n"+res);
		}
	}

	// 경로
	dx.getUploadPath = function() {
		return dx.env.path;
	}

	// 경로 설정
	dx.setUploadPath = function(path) {
		dx.env.path = path;
	}

	// 삭제파일 ID 목록 (배열)
	dx.getDelFileIds = function() {
		let delFiles = dx.getRemovedFiles();
		let delIds = [];

		if (delFiles.length > 0) {
			 for(let i=0; i<delFiles.length; i++) {
				if (delFiles[i].vindex.indexOf("FILEBOX:") == -1) {
					delIds.push(delFiles[i].vindex);
				}
			}
		}

		return delIds;
	}

	// 삭제파일 ID 목록 (문자열)
	dx.getDelFileIdStr = function() {
		let delFiles = dx.getRemovedFiles();
		let delIdStr = "";

		if (delFiles.length > 0) {
			 for(let i=0; i<delFiles.length; i++) {
				if (delFiles[i].vindex.indexOf("FILEBOX:") == -1) {
					if (i>0) delIdStr += ",";
					delIdStr += delFiles[i].vindex;
				}
			}
		}

		return delIdStr;
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
	        for(let i= 0; i<dx.getTotalItemCount(); i++) {
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
	let dx = dx5.get(id);

	if(code == "ESVG-00038" || code == "ESVG-00050" || code == "ESVG-00044") {
		console.log(id + " => " +  code + "\n" + msg);
	} else {
		console.log(id + " => " +  code + "\n" + msg);
		UiComm.showMessage(getUploaderMsg("err_upload"), "error"); // 파일 업로드중 에러가 발생했습니다.
	}
}

function onDX5UploadStopped(id) {
	// console.log("업로드가 중단되었습니다.");
}

function onDX5ItemDoubleClick(id, itemIndex, itemId, itemType) {
	// console.log("중복클릭");
}

function onDX5UploadCompleted(id) {
	let dx = dx5.get(id);
	let env = dx.env;

	// 파일업로드 컴포넌트에서 설정한 함수호출
	if (env.finishFunc && typeof env.finishFunc === "function") {
		env.finishFunc(id);
	}
}

// 업로드 파일 수
function getFileCount(id) {
	let dx = dx5.get(id);
	return dx.getTotalLocalFileCount();
}

function onDX5ItemsAdded(id, count, arr) {
	let dx = dx5.get(id);
	let totCount = dx.getTotalItemCount();
	if (totCount > dx.env.fileCount) {
		UiComm.showMessage(getUploaderMsg("err_file_count"), "warning"); // 파일의 최대 개수(0)를 넘었습니다.

		for (let i=0; i<arr.length; i++) {
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

	let dx = dx5.get(id);
	let uploadMode = dx.getUploadMode();
	let uploadUrl = dx.getUploadURL();

	// 대용량 업로드 블럭(청크) 단위로 업로드 요청
	if(uploadMode == "EXNJ") {
		let url = new URL(uploadUrl);
		let urlParams = new URLSearchParams(url.search);
		let paramsObj = Object.fromEntries(urlParams.entries());

		paramsObj.itemIndex = dx.getItemIndex(itemId);

		let queryStr = new URLSearchParams(paramsObj).toString();
		let newUrl = url.origin + url.pathname + "?" + queryStr;

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
	let dx = dx5.get(id);
	let noExtension = dx.env.noExtension;
	var lastDot = obj.name.lastIndexOf('.');
	let check = true;

	if (lastDot > -1 && noExtension != "") {
		let noExts = noExtension.split(",");
		let ext = obj.name.substring(lastDot+1, obj.name.length).toLowerCase();

		for (let i=0; i<noExts.length; i++) {
			if (ext == noExts[i]) {
				check = false;
				break;
			}
		}
	}

	if (!check) {
		UiComm.showMessage(getUploaderMsg("err_file_ext", obj.name), "warning"); // 업로드할 수 없는 파일입니다.
	}

	return check;
}


function onItemAddedFileBox(id, count) {
	//alert(id, count);
}

// 삭제파일 초기화
function resetDextFiles(id) {
	let dx = dx5.get(id);
	dx.removeAll();
	dx.revokeAllVirtualFiles();
}

// File ID 생성
function getDextNewFileId() {
	let digits = [
		'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
		'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
		'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
	let newId = "";

	for (let i = 0; i < 4; i++) {
		newId += digits[Math.floor(Math.random() * 52)];
	}

	let	nowDate	= new Date();
	newId += digits[(nowDate.getYear() % 100)-1];
	newId += digits[nowDate.getMonth()];
	newId += digits[nowDate.getDate()];
	newId += digits[nowDate.getHours()];
	newId += digits[nowDate.getMinutes()];
	newId += digits[nowDate.getSeconds()];

	let randStr = 'xxxxxxxxxxxx'.replace(/[x]/g, function(c) {
		let r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 3 | 8);
	    return v.toString(16);
	});

	return newId + randStr;
}

// 메시지
function getUploaderMsg(key, ...args) {
    let msg = UiFileUploaderMsg[dex5Object.lang][key];
    msg = msg.replace(/\{(\d+)\}/g, (match, index) => {
        if (index < args.length && args[index] !== undefined && args[index] !== null) {
            return args[index];
        }
        return match;
    });

    return msg;
}


// 파일업로더 메시지
const UiFileUploaderMsg = {
    ko: {
        select: "파일선택",
        delete: "삭제",
        reset: "초기화",
		err_upload: "파일 업로드중 에러가 발생했습니다.",
		err_file_ext: "[{0}] 업로드할 수 없는 파일입니다.",
		err_file_count: "파일의 최대 개수({0})를 넘었습니다."
    },
    en: {
		select: "Select",
		delete: "Delete",
		reset: "Reset",
		err_upload: "An error occurred while uploading the file.",
		err_file_ext: "[{0}] This file cannot be uploaded.",
		err_file_count: "The maximum number of files ({0}) has been exceeded."
    },
    ja: {
		select: "ファイル選択",
		delete: "削除",
		reset: "初期化",
		err_upload: "ファイルのアップロード中にエラーが発生しました。",
		err_file_ext: "[{0}] アップロードできないファイルです。",
		err_file_count: "ファイルの最大数（{0}）を超えました。"
    },
    zh: {
		select: "选择文件",
		delete: "删除",
		reset: "重置",
		err_upload: "上传文件时发生错误。",
		err_file_ext: "[{0}] 文件无法上传。",
		err_file_count: "文件数量已超过最大值 ({0})。"
    }
};