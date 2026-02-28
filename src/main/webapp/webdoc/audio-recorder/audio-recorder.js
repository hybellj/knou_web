
/**
 * 음성 녹음기
 * 
 * 사용법:
 * 
 *  <div id='recorder1'></div>   	// 녹음기 표시할 객체
 *  
 *	var recorder1 = UiAudioRecorder("recorder1");
 *	record1.formName 	= "recordForm";	// 폼명
 *	record1.dataName	= "audioData";	// 녹음 데이터 필드명
 *	record1.fileName	= "audioFile";	// 녹음 파일 필드명
 * 	record1.lang		= "ko";			// 언어
 *	record1.init();						// 초기화
 * 
 * @param targetId
 * @returns recorder
 */
function UiAudioRecorder(targetId) {
	var recorder = new Object();
	recorder.formName	= "";	// 폼명
	recorder.dataName	= "";	// 음성데이터 필드명
	recorder.fileName	= "";	// 음성 파일명
	recorder.lang		= "ko";	// 언어
	
	// 초기화
	recorder.init = function() {
		this.availRecord = false;
		this.onRecorder = false;
		this.audioData = "";
		this.audioFile = "";
		this.inputData = $("form[name="+this.formName+"] input[name="+this.dataName+"]");
		this.inputFile = $("form[name="+this.formName+"] input[name="+this.fileName+"]");

		this.recBox = $("<div class='audio-recorder'></div>");
		this.headBox = $("<div class='audio-header'><div class='head-btn'></div><div class='rec-file'></div><div class='del-rec-file'></div></div>");
		this.recBox.append(this.headBox);
		$("#"+targetId).append(this.recBox);
		
		this.recorderBox = $("<div class='recorder-box'></div>");
		this.recBox.append(this.recorderBox);
		
		this.audioBtn = $("<button class='recorder-btn audio-btn' title='"+UiAudioRecorder_lang[recorder.lang]['voice_recorder']+"'><span class='icon'></span></button>");
		this.recDelBtn = $("<button class='recorder-btn del-btn' title='"+UiAudioRecorder_lang[recorder.lang]['delete_record']+"'><span class='icon'></span></button>");
		this.headBox.children(".head-btn").append(this.audioBtn);
		this.headBox.children(".del-rec-file").append(this.recDelBtn);
		
		this.audioBtn.click(function(e) {
			var top = e.clientY - 10;
			var left = e.clientX - 10;
			recorder.recorderBox.css({"top":top+"px", "left":left+"px"});
			
			if (!recorder.availRecord && recorder.onRecorder) {
				recorder.recorderBox.html("");
				recorder.setRecorder();
			}
			else if (!recorder.onRecorder) {
				recorder.setRecorder();
			}

			recorder.recorderBox.show();
			
			return false;
		});
		
		this.recDelBtn.click(function() {
			recorder.inputData.val("");
			recorder.inputFile.val("");
			recorder.headBox.children(".rec-file").html("");
			recorder.recDelBtn.hide();
			return false;
		});
	};
	
	// 음성녹음기 ui 설정
	recorder.setRecorder = function() {
		const audioCtx 		= new(window.AudioContext || window.webkitAudioContext)();
		const analyser 		= audioCtx.createAnalyser();
		this.dataType 		= "audio/mp3 codecs=opus";
		this.availRecord 	= true;
		this.onRecorder		= true;
		
		const audioId = "REC"+new Date().getTime();
		this.audio = $("<audio id='"+audioId+"' controls='controls' showduration='false'></audio>");
		this.recorderBox.append(this.audio);
		var mediaRecorder = null;
		
		// Player 초기화
		var audioPlayer = UiMediaPlayer(audioId);
		
		this.recorderBox.children(".plyr").prepend($("<div class='recorder-title'>"+UiAudioRecorder_lang[recorder.lang]['title']+"</div>"));
		
		this.audioBtm = $("<div class='audio-btm'><div class='btm-file'></div></div>");
		this.okBtn = $("<button class='btm-btn' disabled>"+UiAudioRecorder_lang[recorder.lang]['ok']+"</button>");
		this.cancelBtn = $("<button class='btm-btn'>"+UiAudioRecorder_lang[recorder.lang]['cancel']+"</button>");
		
		this.okBtn.click(function() {
			recorder.inputData.val(recorder.audioData);
			recorder.inputFile.val(recorder.audioFile);
			recorder.headBox.children(".rec-file").html(recorder.audioFile);
			recorder.recDelBtn.show();
			recorder.recorderBox.hide();
			return false;
		});
		
		this.cancelBtn.click(function() {
			if (mediaRecorder != null && mediaRecorder.state == 'recording') {
				mediaRecorder.stop();
				setTimeout(function() {
					recorder.reset();
				}, 300);
			}
			
			recorder.recorderBox.hide();
			return false;
		});
		
		this.audioBtm.append(this.cancelBtn);
		this.audioBtm.append(this.okBtn);
		$("#"+audioId).parent().append(this.audioBtm);
		
		this.controls = $("#"+audioId).parent().find(".plyr__controls");
		this.controls.find("input").attr("disabled", true);
		this.controls.find("button[data-plyr=play]").attr("disabled", true);
		this.controls.find("button[data-plyr=mute]").attr("disabled", true);
		
		this.recordBtn = $("<button class='plyr__controls__item plyr__control ex-btn record-start' type='button'>"
				+ "<span class='icon'></span><span class='plyr__tooltip'>"+UiAudioRecorder_lang[recorder.lang]['start_record']+"</span></button>");
		
		this.recordBtn.click(function() {
			if (mediaRecorder != null) {
				if (mediaRecorder.state == 'recording') {
					return false;
				}
				
				mediaRecorder.start();
			
				recorder.audioBtm.children(".btm-file").html("<span class='recording'>"+UiAudioRecorder_lang[recorder.lang]['recording']+"</span>");
			}
			
			recorder.stopBtn.show();
			recorder.stopBtn.attr("disabled", false);
			recorder.recordBtn.addClass("blink");
			recorder.resetBtn.hide();
			return false;
		});

		this.stopBtn = $("<button class='plyr__controls__item plyr__control ex-btn record-stop' type='button' disabled>"
				+ "<span class='icon'></span><span class='plyr__tooltip'>"+UiAudioRecorder_lang[recorder.lang]['stop_record']+"</span></button>");
		
		this.stopBtn.click(function() {
			if (mediaRecorder != null) {
				mediaRecorder.stop();				
			}
			
			recorder.recordBtn.attr("disabled", true);
			recorder.stopBtn.hide();
			recorder.resetBtn.show();
			recorder.recordBtn.removeClass("blink");
			recorder.okBtn.attr("disabled", false);
			return false;
		});

		this.resetBtn = $("<button class='plyr__controls__item plyr__control ex-btn record-reset' type='button'>"
				+ "<span class='icon'></span><span class='plyr__tooltip'>"+UiAudioRecorder_lang[recorder.lang]['reset_record']+"</span></button>");
		this.resetBtn.hide();
		
		this.resetBtn.click(function() {
			recorder.reset();
			return false;
		});
		
		this.controls.prepend($("<div class='control-line'></div>"));
		this.controls.prepend(this.resetBtn);
		this.controls.prepend(this.stopBtn);				
		this.controls.prepend(this.recordBtn);
		
		if (navigator.mediaDevices) {
			var chunks = [];
			const constraints = {audio: true};

			navigator.mediaDevices.getUserMedia(constraints).then(stream => {
				mediaRecorder = new MediaRecorder(stream);
				
				mediaRecorder.onstop = evt => {
					var recData = new Blob(chunks, {'type': recorder.dataType});
					recorder.audio.attr("src", URL.createObjectURL(recData));
					recorder.controls.find("input").attr("disabled", false);
					recorder.controls.find("button[data-plyr=play]").attr("disabled", false);
					recorder.controls.find("button[data-plyr=mute]").attr("disabled", false);
					
					chunks = [];
					var reader = new FileReader();
		    		reader.onload = function(event){
		    			recorder.audio.stop();
		    			var fileName = "REC_" + new Date().getTime() + (Math.random().toString(36).substring(2,6)) + ".mp3";
		    			var audioData = event.target.result.substr(("data:"+recorder.dataType+";base64,").length);

		    			recorder.audioData = audioData;
		    			recorder.audioFile = fileName;
		    			recorder.audioBtm.children(".btm-file").html(fileName);
		    		};
		    		reader.readAsDataURL(recData);
			    }
			
				mediaRecorder.ondataavailable = evt => {
					chunks.push(evt.data);
				}

			}).catch(err => {
				this.availRecord = false;
				this.recordBtn.addClass("notavail");
				this.recordBtn.attr("disabled", true);
				recorder.audioBtm.children(".btm-file").html("<span class='error-msg'>"+UiAudioRecorder_lang[recorder.lang]['error1']+"</span>");
				console.log(err);
			});
		}
		else {
			this.availRecord = false;
			this.recordBtn.addClass("notavail");
			this.recordBtn.attr("disabled", true);
			recorder.audioBtm.children(".btm-file").html("<span class='error-msg'>"+UiAudioRecorder_lang[recorder.lang]['error1']+"</span>");
		}		
	};
	
	// 녹음 초기화
	recorder.reset = function() {
		this.audio.attr("src", "");
		this.stopBtn.show();
		this.resetBtn.hide();
		this.recordBtn.attr("disabled", false);
		this.stopBtn.attr("disabled", true);
		this.okBtn.attr("disabled", true);
		this.recordBtn.removeClass("blink");
		
		this.controls.find("input").attr("disabled", true);
		this.controls.find("button[data-plyr=play]").attr("disabled", true);
		this.controls.find("button[data-plyr=mute]").attr("disabled", true);
		
		this.audioData = "";
		this.audioFile = "";
		this.audioBtm.children(".btm-file").html("");
	}
	
	return recorder;
}


// 음성 녹음기 언어
var UiAudioRecorder_lang = {
	ko : {
		title : "음성 녹음기",
		voice_recorder : "음성녹음",
		start_record : "녹음 시작",
		stop_record : "녹음 중지",
		delete_record : "삭제",
		reset_record : "초기화",
		recording : "녹음중...",
		ok : "확인",
		cancel : "취소",
	    error1 : "음성녹음을 지원하지 않습니다."
	},
	
	en : {
		title : "Voice recorder",
		voice_recorder : "Voice record",
		start_record : "Start recording",
		stop_record : "Stop recording",
		delete_record : "Delete",
		reset_record : "Reset",
		recording : "Recording...",
		ok : "OK",
		cancel : "Cancel",
		error1 : "Voice recording is not supported."
	}
	
};