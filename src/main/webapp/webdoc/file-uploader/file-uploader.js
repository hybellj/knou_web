/**
 * File Uploader
 * HTML5 지원(IE10이상, Chrome 등)
 */


// script path
let UPLOADER_SCRIPT_PATH = "";
let CUR_FILE_UPLOADER = null;

/**
 * UI File Uploader
 * @param target
 * @returns
 */
function UiFileUploader(target, varName) {
	var uploaderType = getFileUploaderType();
	var osType = "windows";
	if (navigator.userAgent.toLowerCase().indexOf("windows") == -1) {
		osType = "unix";
	}
	
	var scriptPath = $('script[src*="/file-uploader.js"]').attr('src');
	UPLOADER_SCRIPT_PATH = scriptPath.substr(0, scriptPath.indexOf("file-uploader/file-uploader.js"));

	
	if (typeof UiFileUploader_language == "undefined") {
		var lang = "ko";
		if (typeof localeKey != "undefined" && localeKey != "") {
			lang = localeKey;
		}
		
		$.ajax({async:false, type:'GET', dataType:'script', url:UPLOADER_SCRIPT_PATH+'file-uploader/lang/file-uploader-'+lang+'.js' });
	}
	
	var fileUploaderObj 				= new Object();
	fileUploaderObj.url 				= "";	// 업로드 URL
	fileUploaderObj.path 				= "";	// 업로드 경로
	fileUploaderObj.limitCount 			= 0;	// 업로드 가능 파일 수
	fileUploaderObj.limitSize 			= 0;	// 업로드 가능 파일 사이즈 합계(MB)
	fileUploaderObj.oneLimitSize		= 1024;	// 파일 한개당 최대 크기 (MB, 기본값:1024)
	fileUploaderObj.listSize 			= 0;	// 파일목록 표시수 (창크기)
	fileUploaderObj.allowedTypes 		= "*";	// 업로드 가능 타입 (확장명만 입력, 구분자[,], 전체:*)
	fileUploaderObj.notAllowedTypes		= "exe,com,bat,cmd,jsp,msi,html,htm,js,scr,asp,php,php3,php4,ocx,war,jar"; // 업로드 금지 타입 (생략시 기본값 설정, 확장명만 입력, 구분자[,])
	fileUploaderObj.uploadMessage 		= UiFileUploader_lang['selectFileStr']; // 안내 메시지
	fileUploaderObj.onTopMessage		= true;	// Top 메시지 표시 여부
	fileUploaderObj.finishFunc			= "finishUpload";
	fileUploaderObj.useFileBox			= true;
	fileUploaderObj.uploaderType		= uploaderType;
	fileUploaderObj.uploadObj			= null;
	fileUploaderObj.oldFiles			= "";
	fileUploaderObj.varName				= varName;

	if (typeof uploaderIdCount == 'undefined') {
		uploaderIdCount = 0;
	}
	var uploaderId = "ui-file-uploader-"+(++uploaderIdCount);
	
	// 초기화
	fileUploaderObj.init = function() {
		var uploadBox = $("#"+target);
		uploadBox.addClass("file-uploader-box");
		
		if (uploaderType == 1) {
			// 파일함에서 가져오기 버튼 초기화
			if($("#fileBoxForm1").length == 1) {
				$("#fileBoxForm1").remove();
			}
			
			$.ajax({async:false, type:'GET', dataType:'script', url:UPLOADER_SCRIPT_PATH+'file-uploader/file-uploader-plugin.js' });
			
			var acceptFiles = "";
			if (this.allowedTypes == "*") {
				acceptFiles = "*";
			}
			if (this.allowedTypes != "" && this.allowedTypes != "*") {
				var exts = this.allowedTypes.split(",");
				for (var i = 0; i < exts.length; i++) {
					if (acceptFiles != "") acceptFiles += ",";
					acceptFiles += "."+exts[i];
				}
			}
			
			if (this.url.indexOf("?") > -1) {
				this.url += "&osType="+osType;
			}
			else {
				this.url += "?osType="+osType;
			}
			
			this.uploadObj = $("<div id='"+uploaderId+"' class='file-uploader'></div>").appendTo(uploadBox).uploadFile({
				fileUploaderObj : this,
				url: this.url,
				path: this.path,
				maxFileCount: this.limitCount,
				maxFileSize: (1024*1024*this.limitSize),
				oneLimitSize: (1024*1024*this.oneLimitSize),
				listSize: this.listSize,
				allowedTypes: this.allowedTypes,
				notAllowedTypes: this.notAllowedTypes,
				acceptFiles: acceptFiles,
				uploadMessage: this.uploadMessage,
				onTopMessage: this.onTopMessage,
				oldFiles: this.oldFiles,
				useFileBox: this.useFileBox,
				varName: varName,
				onError: function(files,status,errMsg,pd) {
					UiFileUploader_displayMessage("uploadErrorStr", "");
				},
				afterUploadAll:function(obj) {
					if (obj.uploadComplete == true) {
						if (fileUploaderObj.finishFunc != "") {
							if (fileUploaderObj.finishFunc.indexOf("()") < 0) {
								fileUploaderObj.finishFunc += "()";
							}
							eval(fileUploaderObj.finishFunc);
						}
					}
				}
			});
			this.uploadObj.varName = varName;
		}
		else {
			var objectCont = "<div style='color:red'>현재 브라우져는 지원하지 않습니다.</div>";
			document.getElementById(target).innerHTML = objectCont;
		}
	};
	
	// 업로드 시작
	fileUploaderObj.startUpload = function() {
		if (this.uploaderType == 1) {
			if (this.uploadObj.existingFileNames.length > 0) {
				this.uploadObj.startUpload();
			}
			else {
				var func = fileUploaderObj.finishFunc;
				if (func.indexOf("()") < 0) {
					func += "()";
				}
				eval(func);
			}
		}
		else {
			var fileIdList = [];
			var fileCount = this.uploadObj.GetVariable("listLength");
			if (fileCount > 0) {
				for (var i=0; i<fileCount; i++) {
					fileIdList.push(getNewFileId());
				}
				this.uploadObj.fileIds = fileIdList;
				this.uploadObj.SetVariable("fileIdListStr", fileIdList);
				this.uploadObj.SetVariable("startUpload", "");
			}
			else {
				var func = fileUploaderObj.finishFunc;
				if (func.indexOf("()") < 0) {
					func += "()";
				}
				eval(func);
			}
		}
	};
	
	// 업로드 파일 목록(문자열)
	fileUploaderObj.getFileNames = function() {
		var fileNames = "";
		if (this.uploaderType == 1) {
			for (var i = 0; i < this.uploadObj.existingFileNames.length; i++) {
				if (fileNames != "") fileNames += "|";
				fileNames += this.uploadObj.existingFileNames[i];
			}
		}
		else {
			fileNames = this.uploadObj.GetVariable("uploadedFiles");
		}
		return fileNames;
	};
	
	fileUploaderObj.getFileNameList = function() {
		var fileNameList = [];
		
		(this.uploadObj.existingFileNames || []).forEach(function(existingFileName, i) {
			fileNameList.push(existingFileName);
		});
		
		return fileNameList;
	};
	
	// 업로드 파일 ID 목록(문자열)
	fileUploaderObj.getFileIds = function() {
		return this.uploadObj.fileIds;
	};
	
	// 업로드 파일 사이즈 목록
	fileUploaderObj.getFileSizes = function() {
		var fileSizes = "";
		
		for (var i = 0; i < this.uploadObj.fileSizes.length; i++) {
			if (fileSizes != "") fileSizes += "|";
			fileSizes += this.uploadObj.fileSizes[i];
		}

		return fileSizes;
	};
	
	// 업로드 파일 수
	fileUploaderObj.getFileCount = function() {
		return this.uploadObj.existingFileNames.length + this.uploadObj.copyFiles.length;
	};
	
	// 업로드 파일 정보(json)
	fileUploaderObj.getUploadFiles = function() {
		var upFiles = this.uploadObj.upFiles;
		var fileArray = new Array();
        var fileVO = null;
		
		for (var i=0; i < upFiles.length; i++) {
			fileVO = new Object();
			fileVO.fileId = upFiles[i].fileId;
			fileVO.fileNm = upFiles[i].name;
			fileVO.fileSize = upFiles[i].size;
			fileArray.push(fileVO);
		}
		
		return JSON.stringify(fileArray).replace(/\"/gi, "\\\"");
	};
	
	// 업로드중인지 체크
	fileUploaderObj.uploadCheck = function() {
		if (this.uploaderType == 1) {
			return this.uploadObj.isUpload;
		}
		else {
			return this.uploadObj.GetVariable("uploadCheck");
		}
	};
	
	// 업로드 중지
	fileUploaderObj.stopUpload = function() {
		if (this.uploaderType == 1) {
			this.uploadObj.stopUpload();
		}
		else {
			this.uploadObj.SetVariable("stopUpload", "");
		}
	};
	
	// 이전 업로드된 파일 삭제 체크
	fileUploaderObj.oldDelete = function(fileId, fileSize) {
		var inputObj = document.getElementById("oldid_"+fileId);
		var oldUploadName = $("#oldname_"+fileId);
		var add = true; 
		
		if (inputObj.checked == false) {
			inputObj.checked = true;
			oldUploadName.css("text-decoration", "line-through");
			add = false;
		}
		else {
			inputObj.checked = false;
			oldUploadName.css("text-decoration", "none");
		}
		
		if (UiFileEdit_uploaderObj != null) {
			var obj = this.uploadObj;
			
			if (add) {
				if (obj.maxFileCount > 0 && (obj.selectedFiles+1) > obj.maxFileCount) {
					inputObj.checked = true;
					oldUploadName.css("text-decoration", "line-through");
					UiFileUploader_displayMessage("limitCount", obj.maxFileCount);
					
					return false;
				}
				else if (obj.maxFileSize > 0 && (obj.totalSize+fileSize) > obj.maxFileSize) {
					inputObj.checked = true;
					oldUploadName.css("text-decoration", "line-through");
					UiFileUploader_displayMessage("limitSize", UiFileUploader_getSizeStr(obj.maxFileSize));
					
					return false;
				}
				else {
					obj.totalCount += 1;
					obj.totalSize += fileSize;
				}
			}
			else {
				obj.totalCount -= 1;
				obj.totalSize -= fileSize;
			}
			
			obj.totalSizeStr.html(UiFileUploader_getSizeStr(obj.totalSize));
			obj.totalCountStr.html(obj.totalCount);
		}
		
		return false;
	}
	
	// old 파일 추가
	fileUploaderObj.addOldFile = function(fileId, fileName, fileSize) {
		let fileInfo = `[{"fileNm":"${fileName}","fileId":"${fileId}","fileSize":${fileSize}}]`;
		this.uploadObj.addOldFiles(fileInfo);
	}
	
	// 이전파일 가져오기 파일 추가
	fileUploaderObj.addCopyFileList = function(list) {
		UiFileUploader_addFromFileBox(list, this.uploadObj);
	}
	
	// 파일함에서 가져온 파일 삭제
	fileUploaderObj.copyDelete = function(fileId) {
		let obj = this.uploadObj;
		let cpId = fileId.replace(/\./g,'');
		
		for (var i=0; i<obj.copyFiles.length; i++) {
			let cpFile = obj.copyFiles[i];
			if (cpFile.fileSaveNm == fileId) {
				$("#copyFile_"+cpId).remove();
				obj.copyFiles.splice(i,1);
				obj.totalCount -= 1;
				obj.totalSize -= cpFile.fileSize;
				break;
			}
		}
		
		obj.totalSizeStr.html(UiFileUploader_getSizeStr(obj.totalSize));
		obj.totalCountStr.html(obj.totalCount);
	}
	
	
	// 파일함에서 복사 파일 정보 가져오기
	fileUploaderObj.getCopyFiles = function() {
		var cpFiles = this.uploadObj.copyFiles;
		var fileArray = new Array();
        var fileVO = null;
		
		for (var i=0; i < cpFiles.length; i++) {
			fileVO = new Object();
			fileVO.fileId		= getNewFileId();
			fileVO.fileNm 		= cpFiles[i].fileNm;
			fileVO.fileSaveNm	= cpFiles[i].fileSaveNm;
			fileVO.fileSize 	= cpFiles[i].fileSize;
			fileVO.filePath 	= cpFiles[i].filePath.replace(/\\/g, "\/");
			fileVO.encFileSn	= cpFiles[i].encFileSn;
			fileArray.push(fileVO);
		}
		
		return JSON.stringify(fileArray).replace(/\"/gi, "\\\"");
	};
	
	// Set path
	fileUploaderObj.setPath = function(path) {
		this.uploadObj.options.path = path;
		fileUploaderObj.path = path;
		
		if($("form[formtype='upfile']").length > 0) {
			$.each($("form[formtype='upfile']"), function() {
				var uploadAction = $(this).attr("action");
				
				if(uploadAction) {
					var parts = uploadAction.split('&');
					
					for(var i = 0; i < parts.length; i++) {
					    if(parts[i].indexOf('path=') === 0) {
					        // 원하는 새로운 path 값을 설정
					        parts[i] = 'path=' + path;
					        break;
					    }
					}
					
					$(this).attr("action", parts.join('&'));
				}
			});
		}
	};
	
	UiFileEdit_uploaderObj = fileUploaderObj;
	return fileUploaderObj;
}


// 파일함에서 가져오기
function UiFileUploader_addFromFileBox(list, fileUploader) {
	let obj = fileUploader || CUR_FILE_UPLOADER;
	
	for(let i=0; i<list.length; i++) {
		let fileInfo = list[i];
		
		if (obj.totalCount >= obj.maxFileCount) {
			UiFileUploader_displayMessage("limitCount", obj.maxFileCount);
			return;
		}
		
		if (obj.maxFileSize > 0 && (obj.totalSize + fileInfo.fileSize) > obj.maxFileSize) {
			UiFileUploader_displayMessage("limitSize", UiFileUploader_getSizeStr(obj.maxFileSize));
			return;
		}
		
		let cpFile = "<div id='copyFile_"+fileInfo.fileSaveNm.replace(/\./g,'')+"' class='copy-file'>"
			+ "<span class='file-name'>"+fileInfo.fileNm+" <span class='ajax-file-upload-filesize'>("+UiFileUploader_getSizeStr(fileInfo.fileSize)+", "+UiFileUploader_lang['fileBox']+")</span></span>"
			+ "<a href='#_' onclick='"+obj.varName+".copyDelete(\""+fileInfo.fileSaveNm+"\");return false;' title='delete'>"
			+ "<span class='ajax-file-upload-red'><i class='times icon'></i></span></a></div>";
		
		obj.copyFileBox.append($(cpFile));
		obj.totalCount += 1;
		obj.totalSize += fileInfo.fileSize;
		obj.copyFiles.push(fileInfo);
	}
	
	obj.totalSizeStr.html(UiFileUploader_getSizeStr(obj.totalSize));
	obj.totalCountStr.html(obj.totalCount);
}


// 메시지 표시
function UiFileUploader_displayMessage(errorCode, msgValue) {
	var errMsg = ""; //"<div class='ajax-file-upload-error'>";
	
	if (errorCode == "allowFileType") {
		errMsg = UiFileUploader_lang['allowTypeStr'];
		errMsg = errMsg.replace("{0}", msgValue);
	}
	else if (errorCode == "fileType") {
		errMsg = UiFileUploader_lang['extErrorStr'];
		errMsg = errMsg.replace("{0}", msgValue);
	}
	else if ( errorCode == "limitSize") {
		errMsg = UiFileUploader_lang['sizeErrorStr'];
		errMsg = errMsg.replace("{0}", msgValue);
	}
	else if ( errorCode == "limitCount") {
		errMsg = UiFileUploader_lang['maxFileCountErrorStr'];
		errMsg = errMsg.replace("{0}", msgValue);
	}
	else if ( errorCode == "version") {
		errMsg = UiFileUploader_lang['flashVersion'];
	}
	else if ( errorCode == "network") {
		errMsg = UiFileUploader_lang['networkError'];
	}
	else if ( errorCode == "io") {
		errMsg = UiFileUploader_lang['ioError'];
	}
	else if ( errorCode == "oneFileLimitSize") {
		errMsg = UiFileUploader_lang['oneLimitError'];
		errMsg = errMsg.replace("{0}", msgValue);
	}
	else {
		errMsg = UiFileUploader_lang['uploadErrorStr'];
		if (msgValue != "") {
			errMsg += "<br>"+msgValue;
		}
	}

	//errMsg += "</div>";

	//UiMessage(errMsg, "error", "", 400);
	alert(errMsg);
}


/**
 * Get uploader type
 * @returns
 */
function getFileUploaderType() {
	var uploaderType = 1;
	var agent = navigator.userAgent.toLowerCase();
	if (agent.indexOf('msie 9') > -1 || agent.indexOf('msie 8') > -1 || agent.indexOf('msie 7') > -1) {
		uploaderType = 0;
	}
	return uploaderType;
}


/**
 * 사이즈 표시 변환
 * @param size
 * @returns {String}
 */
function UiFileUploader_getSizeStr(size) {
	var sizeStr = "";

	if (size > 0 && size < 1024) {
		sizeStr = "1KB";
	}
	else {
		var sizeKB = size / 1024;
		if(parseInt(sizeKB) > 1024) {
			var sizeMB = sizeKB / 1024;
			sizeStr = sizeMB.toFixed(1) + "MB";
		} else {
			sizeStr = sizeKB.toFixed() + "KB";
		}
	}

	return sizeStr;
}


var digits = [ 
	'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
	'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
	'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

var HOST_ID = null;

/**
 * File ID 생성
 * @returns {String}
 */
function getNewFileId() {
	if (HOST_ID == null) {
		HOST_ID = "";

		for (var i = 0; i < 4; i++) {
			HOST_ID += digits[Math.floor(Math.random() * 52)];
		}
	}
	
	var newId = HOST_ID;
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
