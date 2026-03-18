
/**
 * HTML 에디터 생성 (Synap Editor)
 *
 * @param option		에디터 옵션
 * {
 * 		targetId:		대상 <textarea> 아이디
 * 		videoUpload:	비디오 업로드 여부(true/false, 기본값:false)
 * 		uploadMaxSize:	업로드 사이즈(Mbyte, 기본값 5)
 * 		width:			너비 (%/px, 기본값:100%)
 * 		height:			높이 (%/px, 기본값:400px)
 * 		required:		필수입력 여부(true/false, 기본값:false)
 * }
 *
 * let editor = UiEditor({옵션});
 *
 * editor.isEmpty() : 에디터 내용이 빈값인지 확인 (return true/false)
 * editor.execCommand('selectAll') : 내용 전체 선택
 * editor.execCommand('deleteLeft') : 내용 삭제
 * editor.execCommand('insertText', "내용") : 내용 넣기 (HTML 태그 적용 안됨, 기존 내용에 추가)
 * editor.openHTML("내용") : 내용 넣기 (HTML 태그 적용, 기존 내용 삭제하고 추가)
 */
function UiEditor(option) {
	let eventListeners = {
	    initialized: function (e) {
	        let editor = e.editor;
	    },
	    initializedSync: function (e) {
	        let editor = e.editor;

	        $("button[name=source].se-button").on('click', function(){
	        	$("#"+option.targetId).find(".se-code-viewer").css("max-width", $("#"+option.targetId).width()+"px");
	        });
	    },
	    afterUploadVideo: function (e) {
	    	let path = e.path;
	    	if (path.toLowerCase().indexOf(".mp3") > 0) {
		    	let video = e.editor.getAPIModelById(e.elementId);
		    	let audio = '<audio controls style="width:300px;height:40px;"><source src="'+path+'" type="audio/mpeg"></audio>';
		    	video.replace(audio);
	    	}
	    }
	};

	let targetObj = $("#"+option.targetId);
	let text = "";
	let tagName = targetObj.prop('tagName').toLowerCase();
	if (tagName === "div" || tagName === "span") {
		text = targetObj.html();
	}

	/*
	if (theme == "dark") {
		synapEditorConfig["editor.ui.theme"] = "dark-gray";
	}
	*/

	if (option.uploadPath == null) {
		option.uploadPath = "";
	}

	// 이미지 업로드 설정
	synapEditorConfig["editor.upload.image.api"] = UiComm.conf.editorUploadUrl+option.uploadPath;

	// 동영상 업로드 설정
	if (option.videoUpload === true) {
		synapEditorConfig["editor.upload.video.api"] = UiComm.conf.editorUploadUrl+option.uploadPath;
	}

	// 업로드 MAX 사이즈 설정
	let uploadMaxSize = (option.uploadMaxSize === undefined || !option.uploadMaxSize) ? 5 : parseInt(option.uploadMaxSize);
	synapEditorConfig["editor.upload.maxSize"] = uploadMaxSize * 1024 * 1024;

	// 언어 설정
	if (UiComm.conf.lang != undefined) {
		synapEditorConfig["editor.lang"] = UiComm.conf.lang;
	}

	synapEditorConfig["editor.size.width"] = (option.width === undefined || !option.width) ? "100%" : option.width;
	synapEditorConfig["editor.size.height"] = (option.height === undefined || !option.height) ? "400px" : option.height;
	synapEditorConfig["editor.external.container.selector"] = "body";

	// 에디터 설정
	let snapEditor = new SynapEditor(option.targetId, synapEditorConfig, text, eventListeners);

	$(".se-classic-editor").css("z-index", 999);

	// 전역변수에 생성된 에디터 저장
	window.UiEditors = window.UiEditors || {};
	window.UiEditors["new_"+option.targetId] = snapEditor;
	$("#"+option.targetId).attr("editor","new_"+option.targetId);

  	return snapEditor;
}