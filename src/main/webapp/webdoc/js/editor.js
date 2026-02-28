
/**
 * HTML 에디터 생성 (Synap Editor)
 * @param id
 * @param theme
 * @param uploadPath
 * @param videoUpYn : 비디오 업로드 여부(Y/N)
 * @param uploadMaxSize : 업로드 사이즈 (Mbyte)
 * @returns
 */
function HtmlEditor(id, theme, uploadPath, videoUpYn, uploadMaxSize) {
	let eventListeners = {
	    initialized: function (e) {
	        var editor = e.editor;
	    },
	    initializedSync: function (e) {
	        var editor = e.editor;
	        
	        $("button[name=source].se-button").on('click', function(){
	        	$("#"+id).find(".se-code-viewer").css("max-width", $("#"+id).width()+"px");
	        });
	    },
	    afterUploadVideo: function (e) {
	    	var path = e.path;
	    	if (path.toLowerCase().indexOf(".mp3") > 0) {
		    	var video = e.editor.getAPIModelById(e.elementId);
		    	var audio = '<audio controls style="width:300px;height:40px;"><source src="'+path+'" type="audio/mpeg"></audio>';
		    	video.replace(audio);
	    	}
	    }
	};

	let text = "";
	let tagName = $("#"+id).prop('tagName').toLowerCase();
	if (tagName === "div" || tagName === "span") {
		text = $("#"+id).html();
	}
	
	if (theme == "dark") { 
		//synapEditorConfig["editor.ui.theme"] = "dark-gray";
	}

	if (uploadPath == null) {
		uploadPath = "";
	}
	
	// 이미지 업로드 설정
	synapEditorConfig["editor.upload.image.api"] = "/common/editorUpload.do?path="+uploadPath;
	
	// 동영상 업로드 설정
	if (videoUpYn == "Y") {
		synapEditorConfig["editor.upload.video.api"] = "/common/editorUpload.do?path="+uploadPath;
	}
	
	// 업로드 MAX 사이즈 설정
	if (uploadMaxSize != null && uploadMaxSize != "") {
		synapEditorConfig["editor.upload.maxSize"] = uploadMaxSize * 1024 * 1024;
	}
	
	// 언어 설정
	if (LANG != undefined) {
		synapEditorConfig["editor.lang"] = LANG; 
	}
	
	// 에디터 설정
	let snapEditor = new SynapEditor(id, synapEditorConfig, text, eventListeners);
  	
	$(".se-classic-editor").css("z-index", 999);
	
  	return snapEditor;
}