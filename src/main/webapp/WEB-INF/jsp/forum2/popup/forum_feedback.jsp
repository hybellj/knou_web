<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
		<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
		<%@ include file="/WEB-INF/jsp/forum/common/forum_common_inc.jsp" %>

		<script src="/webdoc/js/iframe.js"></script>
    	<script src="/webdoc/js/jquery.form.min.js"></script>

	    <script src="/webdoc/file-uploader/lang/file-uploader-ko.js"></script>
	    <script src="/webdoc/file-uploader/file-uploader.js"></script>

	    <script src="/webdoc/player/plyr.js" crossorigin="anonymous"></script>
		<script src="/webdoc/player/player.js" crossorigin="anonymous"></script>

		<script src="/webdoc/audio-recorder/audio-recorder.js"></script>

		<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    	<link rel="stylesheet" type="text/css" href="/webdoc/file-uploader/file-uploader.css" />
    	<link rel="stylesheet" href="/webdoc/player/plyr.css" />
		<link rel="stylesheet" href="/webdoc/audio-recorder/audio-recorder.css" />
    </head>
<%
	request.setAttribute("PAGE_FILE_UPLOAD", request.getContextPath() + CommConst.PAGE_FILE_UPLOAD);
%>
	<script type="text/javascript">
		var fUploader = {};
		var aUploader = {};
		var aRecord = {};
		var aPlayer = {};
		var edtNo = null;
		var curUploaderId = "";
		var oldFilesMap = {};
		var upType = "";

		var audioRecord = null;

		$(document).ready(function() {

			audioRecord = UiAudioRecorder("audioRecord");
			audioRecord.formName = "recordForm";
			audioRecord.dataName = "audioData";
			audioRecord.fileName = "audioFile";
			audioRecord.lang	 = "ko";
			audioRecord.init();

			audioRecord.recorderBox.css({"top":"0px", "left":"0px"});
			audioRecord.setRecorder();

			$("#audioRecord").height($(".recorder-box").height()+22);

			$(".audio-header").remove();
			$(".audio-btm .btm-btn").remove();

			audioRecord.recorderBox.show();

			fdbkList();
		});

		// 리스트 조회
		function fdbkList(page) {
			fUploader = {};
			aRecord = {};
			aPlayer = {};
			makeAudioRecord(0);

			var url  = "/forum/forumLect/getFdbk.do";
			var data = {
				"forumCd" : "${forumVo.forumCd}",
				"stdNo" : "${stdNo}",
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					if(data.returnList.length > 0){
						var rList = data.returnList;
			    		$("#feedbackList").empty().html(createHTML(rList));

	        			for (var i = 0; i < rList.length; i++){
	        				var oldFiles = [];
	        				makeAudioRecord((i+1));
	        				
	        				for(var j = 0; j <rList[i].fileList.length; j++){
	        					var oldFile = {};
	        					var fId = rList[i].fileList[j].fileId;
	        					var fNm = rList[i].fileList[j].fileNm;
	        					var fSize = rList[i].fileList[j].fileSize;
	        					var fExt = rList[i].fileList[j].fileExt;
	        					var fSaveNm = rList[i].fileList[j].fileSaveNm;

	        					if(fExt == "mp3"){
	        						makeAudioPlayer((i+1),(j+1));

	        						aUploader[`aUploader`+(i+1)].addOldFile( fId, fNm, fSize );
	        					}else{
	        						oldFiles.push({vindex:fId, name:fNm, size:fSize, saveNm:fSaveNm});
	        					}

	        					byteConvertor(fSize, fNm, "file_" + rList[i].fileList[j].fileSn);
	        				}
	        				
	        				oldFilesMap[i+1] = oldFiles;

        					$("#fdbkAudioBox"+(i+1)+" .ajax-upload-dragdrop").remove();
        					$("#fdbkAudioBox"+(i+1)+" .file-uploader-tot-progress").remove();
        					$("#fdbkAudioBox"+(i+1)+" .ajax-file-upload-container").remove();

        					$("#fdbkAudioBox"+(i+1)).css('border','0px');
        					$("#fdbkAudioBox"+(i+1)+" .file-uploader-edit-box").css('border-top','0px');
	        			}


	        			$(".audio-header").remove();
	        			$(".audio-btm .btm-btn").remove();
					}else{
						var html = "";
						html += "<div class='flex-container m-hAuto'>";
						html += "    <div class='no_content'>";
						html += "        <i class='icon-cont-none ico f170'></i>";
						html += "        <span><spring:message code='team.common.empty' /></span>"; // 등록된 내용이 없습니다.
						html += "    </div>";
						html += "</div>";

						$("#feedbackList").empty().html(html);
					}
		        } else {
		         	alert(data.message);
		        }
			}, function(xhr, status, error) {
				alert("<spring:message code='forum.common.error' />");// 오류가 발생했습니다!
			}, true);
		}

		function makeAudioRecord(i){
			aRecord[`aRecord`+i] = UiAudioRecorder("audioRecord"+i);
			aRecord[`aRecord`+i].formName = "recordForm";
			aRecord[`aRecord`+i].dataName = "audioData";
			aRecord[`aRecord`+i].fileName = "audioFile";
			aRecord[`aRecord`+i].lang	 = "ko";
			aRecord[`aRecord`+i].init();

			aRecord[`aRecord`+i].recorderBox.css({"top":"0px", "left":"0px"});
			aRecord[`aRecord`+i].setRecorder();

			$("#audioRecord"+i).height($(".recorder-box").height()+22);

			aRecord[`aRecord`+i].recorderBox.show();
		}

		function makeAudioPlayer(i,j){
			aPlayer[`aPlayer`+i] = UiMediaPlayer("audioPlayer" + i + "_" + j);
		}

		// 피드백 수정 버튼
		function btnFdbkEdt(i){
			$("#fdbkValue"+i).prop("readonly",false);
			$("#fdbkValue"+i).show();
			$("#fdbkValueDiv"+i).hide();
			$("#aFileView"+i).hide();
			$("#aFileEditView"+i).show();

			$("#fdbk"+i+" .button-area button").eq(0).hide();
			$("#fdbk"+i+" .button-area button").eq(1).hide();
			$("#fdbk"+i+" .button-area button").eq(2).show();
			$("#fdbk"+i+" .button-area button").eq(3).show();
			$(".addBtn").prop("disabled", true);
			$(".editBtn").prop("disabled", true);
			$(".delBtn").prop("disabled", true);
			
			var fileUploader = dx5.get("fileUploader");
			if (fileUploader != null) {
				fileUploader.clearItems();
			}
			
			if (oldFilesMap[i] != null && oldFilesMap[i].length > 0) {
				var html = "";
				for(var j=0; j<oldFilesMap[i].length; j++){
					html += "<i class='paperclip icon f080'></i>"+oldFilesMap[i][j].name;
					html += "<button type='button' class='del ml10' style='border:1px solid #aaa;width:16px;height:16px' title='Delete' onclick=\"fdbkFileReset("+(i)+");\"></button>";
				}
				$("#upload"+i+"File").html(html);				
				fileUploader.addOldFileList(oldFilesMap[i]);
			}
			
			fileUploader.showResetBtn();
		}

		// 피드백 취소 버튼
		function btnFdbkCancel(i){
			$("#fdbkValue"+i).val($("#fdbkValue"+i).text());

			$("#fdbkValue"+i).prop("readonly",true);
			$("#fdbkValue"+i).hide();
			$("#fdbkValueDiv"+i).show();
			$("#aFileView"+i).show();
			$("#aFileEditView"+i).hide();

			$("#fdbk"+i+" .button-area button").eq(0).show();
			$("#fdbk"+i+" .button-area button").eq(1).show();
			$("#fdbk"+i+" .button-area button").eq(2).hide();
			$("#fdbk"+i+" .button-area button").eq(3).hide();
			$(".addBtn").prop("disabled", false);
			$(".editBtn").prop("disabled", false);
			$(".delBtn").prop("disabled", false);
			
			var fileUploader = dx5.get("fileUploader");
			if(fileUploader.getTotalItemCount() > 0){
				fileUploader.removeAll();
			}
			$("#uploadBox").css("visibility", "hidden");
		}

		// 피드백 저장 버튼
		function btnFdbkSave(i){
			var fileUploader = dx5.get("fileUploader");
			upType = "edit";
			edtNo = i;
			
			// 피드백 등록 버튼
			if (fileUploader.getFileCount() > 0) {
				fileUploader.startUpload();
			} else {
				// 저장 호출
				edtFdbk();
			}
		};

		// 피드백 저장
		function edtFdbk() {
			var fileUploader = dx5.get("fileUploader");
			var delFileIds = [];

			if($("#fdbkAudioBox"+edtNo).css("display") != 'none'){
				if(aRecord[`aRecord`+edtNo].audioFile != '' &&
						( $("#fdbkAudioBox" +edtNo+ " input:checkbox[name='delFileIds']").length
							- $("#fdbkAudioBox" +edtNo+ " input:checkbox[name='delFileIds']:checked").length) > 0){
					 /* 하나의 음성파일만 저장 할 수 있습니다. */
					alert("<spring:message code='forum.alert.audio.record.error'/>");
					return false;
				}
				for(var i=0; i<$("#fdbkAudioBox" +edtNo+ " input:checkbox[name='delFileIds']:checked").length; i++ ){
					delFileIds.push($("#fdbkAudioBox" +edtNo+ " input:checkbox[name='delFileIds']:checked").eq(i).val());
				}
			}

	 		var url = "/forum/forumLect/edtFdbk.do";
			var data = {
				"forumFdbkCd" : $("#fdbk"+edtNo).data("fdbkCd"),
				"fdbkCts"     : $("#fdbkValue"+edtNo).val(),
				"uploadFiles" : fileUploader.getUploadFiles(),
				"uploadPath"  : fileUploader.getUploadPath(),
				"copyFiles"   : fileUploader.getCopyFiles(),
				"delFileIds"  : fileUploader.getDelFileIds(),
				"audioData"   : aRecord[`aRecord`+edtNo].audioData,
				"audioFile"   : aRecord[`aRecord`+edtNo].audioFile
			};

			edtNo = null;
			$.ajaxSettings.traditional = true;
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					alert("<spring:message code='forum.alert.mod_success.feedback'/>"); // 피드백 수정에 성공하였습니다.
	        		location.reload();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='forum.common.error' />"); // 오류가 발생했습니다!

			}, true);
		}

		// 피드백 삭제 버튼
		function btnFdbkDelete(i){
			if(window.confirm("<spring:message code='forum.button.confirm.del'/>")) { // 정말 삭제하시겠습니까?
				var url  = "/forum/forumLect/delFdbk.do";
				var data = {
					"forumFdbkCd" : $("#fdbk"+i).data("fdbkCd")
				};

				ajaxCall(url, data, function(data) {
					if (data.result > 0) {
						if (typeof window.parent.reloadFeedbackView === "function") {
							window.parent.reloadFeedbackView();
						}
						
						alert("<spring:message code='forum.alert.del_success'/>"); // 삭제에 성공하였습니다.
		        		location.reload();
		            } else {
		             	alert(data.message);
		            }
				}, function(xhr, status, error) {
					alert("<spring:message code='forum.common.error'/>"); // 오류가 발생했습니다!
				}, true);
			}
		}

		function fdbkFileOpen(i){
			edtNo = i;
			writeOpen();
			$("#fileView"+i).show();
		}

		function fdbkAudioOpen(i){
			edtNo = i;
			writeOpen();
			$("#audioView"+i).show();
		}

		function writeOpen(){
			$("#feedbackList").hide();
			$("#feedbackListBtn").hide();
			$("#feedbackWrite").show();
			$("#feedbackWriteBtn").show();

			$("#feedbackWrite .row").hide();
		}

		function writeClose(){
			edtNo = null;

			$("#feedbackWrite").hide();
			$("#feedbackWriteBtn").hide();
			$("#feedbackList").show();
			$("#feedbackListBtn").show();
		}

		function writeSave(){
			btnFdbkSave(edtNo);
		}


		function createHTML(data) {
			var html = "";

			$.each(data, function(i, o){
				var fCnt = 0;
				var aCnt = 0;

				for(var j=0; j<o.fileList.length; j++){
					if(o.fileList[j].fileExt != "mp3"){
						fCnt++;
					}else{
						aCnt++;
					}
				}

				html += "<div class='ui segment' id='fdbk"+(i+1)+"' data-FDBK-CD='"+o.forumFdbkCd+"'>";
                html += "	<div class='option-content mb10'>";
	            html += "		<p class='mra'>"+dateFormat(o.regDttm)+"</p>";
	            if("${menuType}" != 'STUDENT'){}
	            if("${student}" != 'STD') {
		            html += "		<div class='button-area'>";
		            html += "       	<button onclick='btnFdbkEdt("+(i+1)+")' class='ui basic small button editBtn'><spring:message code='forum.button.fdbk.mod'/><!-- 글수정 --></button>";
		            html += "       	<button onclick='btnFdbkDelete("+(i+1)+")' class='ui basic small button delBtn'><spring:message code='forum.button.del'/><!-- 삭제 --></button>";
		            html += "       	<button onclick='btnFdbkSave("+(i+1)+")' class='ui basic small button' style='display:none;'><spring:message code='forum.button.save'/><!-- 저장 --></button>";
		            html += "        	<button onclick='btnFdbkCancel("+(i+1)+")' class='ui basic small button' style='display:none;'><spring:message code='forum.button.cancel'/><!-- 취소 --></button>";
		            html += "    	</div>";
	            }
	            html += "	</div>";

	            html += "	<textarea id='fdbkValue" + (i+1) + "' rows='10' class='' style='resize:auto;display:none' readonly='readonly'>" + o.fdbkCts + "</textarea>";
	            html += "	<div id='fdbkValueDiv" + (i+1) + "' class='ui segment' style='max-height:200px;overflow:auto'><pre>" + o.fdbkCts + "</pre></div>";

	            var aName = "";
                var fName = "";

	            html += "   <div class='ui box mt10' id='aFileView"+(i+1)+"'>";
                html += "       <div class='fields mr0'>";
                html += "           <div class='field'>";
                html += "               <button class='ui basic icon button'><i class='save icon'></i><spring:message code='forum.label.fdbk.file.attach'/></button>"; // 파일첨부
                html += "           </div>";
                html += "           <div class='field ui segment flex1 flex-item p4'>";
                html += "               <div class='flex align-items-center'>";
                if(fCnt > 0){
					for(var j=0; j<o.fileList.length; j++){
						if(o.fileList[j].fileExt != "mp3"){
							html += "<button class='ui icon small button d-block' style='margin-bottom: 2px;' title='<spring:message code='button.download'/>' onclick=\"fileDown('"+o.fileList[j].fileSn+"','"+o.fileList[j].repoCd+"');return false;\">";
							html += "<i class='paperclip icon f080'></i>";
							html += o.fileList[j].fileNm;
							html += " ("+sizeToByte(o.fileList[j].fileSize)+")";
							html += "</button>";
						}
					}
				}
                html += "               </div>";
                html += "           </div>";
                html += "       </div>";
                html += "       <div class='fields mr0'>";
                html += "           <div class='field'>";
                html += "               <button class='ui basic icon button'><i class='microphone icon'></i><spring:message code='forum.label.fdbk.audio.attach'/></button>"; // 음성녹음
                html += "           </div>";
                html += "           <div class='field ui segment flex1 flex-item p4'>";
                html += "               <div class='flex align-items-center gap8' style='margin: -3px;'>";
                if(aCnt > 0){
					for(var j=0; j<o.fileList.length; j++){
						if(o.fileList[j].fileExt == "mp3"){
							html += "			<audio id='audioPlayer" + (i+1) + "_" + (j+1) +"' lang='en'>";
							html += "           	<source src='${pageContext.request.contextPath}"+o.fileList[j].filePath +"/"+ o.fileList[j].fileSaveNm+"' type='audio/mp3'>";
							html += "           </audio>";

							aName = o.fileList[j].fileNm;
						}
					}
				}
                html += "               </div>";
                html += "           </div>";
                html += "       </div>";
                html += "   </div>";

				html += "   <div class='ui box mt10' id='aFileEditView"+(i+1)+"' style='display:none;'>";
                html += "       <div class='fields mr0'>";
                html += "           <div class='field'>";
                html += "               <button class='ui basic icon button' onclick='fdbkFilePopOpen("+(i+1)+");'><i class='save icon'></i><spring:message code='forum.label.fdbk.file.attach' /></button>";
                html += "           </div>";
                html += "           <div class='field ui segment flex1 flex-item p4' style='position:relative'>";
                html += "               <div class='flex align-items-center' id='upload"+(i+1)+"File'>";
                html += "               </div>";
                html += "           </div>";
                html += "       </div>";
                html += "       <div class='fields mr0'>";
                html += "           <div class='field'>";
                html += "               <button class='ui basic icon button' onclick='fdbkAudioPopOpen("+(i+1)+");'><i class='microphone icon'></i><spring:message code='forum.label.fdbk.audio.attach' /></button>";
                html += "           </div>";
                html += "           <div class='field ui segment flex1 flex-item p4'>";
                html += "               <div class='flex align-items-center gap8' id='fdbkEdtAudioView"+(i+1)+"'>";
                if(aName != ""){
	                html += "                   <i class='paperclip icon f080'></i>" + aName;
                }
                html += "               </div>";
                html += "           </div>";
                html += "       </div>";
                html += "   </div>";

			    html += "<div class='modal fade' id='fdbkAudioPop"+(i+1)+"' tabindex='-1' role='dialog' aria-labelledby='<spring:message code='forum.label.fdbk.audio.attach'/>' data-backdrop='static' data-keyboard='false' aria-hidden='false'>";
			    html += "    <div class='modal-dialog modal-dialog' role='document'>";
			    html += "        <div class='modal-content'>";
				html += "			<div class='modal-header'>";
			    html += "                <button type='button' class='close' aria-label='<spring:message code='forum.button.close'/>' onclick='fdbkAudioPopClose("+(i+1)+");'>"; // 닫기
			    html += "                    <span aria-hidden='true'>&times;</span>";
			    html += "                </button>";
			    html += "                <h4 class='modal-title'><spring:message code='forum.label.fdbk.audio.attach'/><!-- 피드백 음성녹음 --></h4>";
			    html += "            </div>";
			    html += "            <div class='modal-body'>";
			    html += "            	<div class='modal-page'>";
			    html += "            		<div id='wrap'>";
				html += "                		<div class='ui form' style='height:50px'>";
				html += "							<div id='audioRecord"+(i+1)+"'></div>";
				html += "						</div>";
				html += "                		<div class='ui form mt20' style='height:5px'>";
				html += "							<div id='fdbkAudioBox" + (i+1) + "' style='min-height: 0;'></div>";
				html += "						</div>";
				html += "						<div class='bottom-content'>";
				html += "			           		<a class='ui blue button toggle_btn flex-left-auto' onclick='fdbkAudioPopClose("+(i+1)+");'><spring:message code='forum.button.attaching'/><!-- 첨부하기 --></a>";
				html += "			            </div>";
				html += "			    	</div>";
			    html += "            	</div>";
			    html += "            </div>";
			    html += "        </div>";
			    html += "    </div>";
			    html += "</div>";
			    html += "</div>";
			});

			return html;
		}

	 	// 피드백 파일첨부 팝업 열기
		function fdbkFilePopOpen(id) {
			curUploaderId = id;
			var fileUploader = dx5.get("fileUploader");
			var w = $("#upload"+id+"File").parent().outerWidth();
			var bw = $("#uploadBox .fCloseBtn").outerWidth();
			var h = $("#upload"+id+"File").parent().outerHeight();
			var pos = $("#upload"+id+"File").parent().offset();
			
			$("#uploadBox").css({"visibility":"visible"});
			$("#uploadBox").offset({top: pos.top, left: pos.left});
			$("#uploadBox .dext5-container").css({"width":(w-bw)+"px","height":h+"px"});
			$("#uploadBox button").css({"height":h+"px"});
			fileUploader.setUIStyle({itemHeight: h});
		}

		// 피드백 파일첨부 팝업 닫기
		function fdbkFilePopClose(i) {
			var fileUploader = dx5.get("fileUploader");
			
			if(fileUploader.getTotalItemCount() > 0){
				var html = "";
				var items = fileUploader.getItems();

				html += "<i class='paperclip icon f080'></i>";
				html += items[0].name;
				html += "<button type='button' class='del ml10' style='border:1px solid #aaa;width:16px;height:16px' title='Delete' onclick=\"fdbkFileReset('"+curUploaderId+"');\"></button>";

				$("#upload"+curUploaderId+"File").html(html);
			}
			else {
				$("#upload"+curUploaderId+"File").empty();
			}
			
			$("#uploadBox").css("visibility", "hidden");
		}
		
		// 파일삭제
		function fdbkFileReset(id){
			curUploaderId = id;
			
			$("#upload"+id+"File").empty();
			
			var fileUploader = dx5.get("fileUploader");
			if(fileUploader.getTotalItemCount() > 0){
				fileUploader.removeAll();
			}
		}

	 	// 피드백 음성녹음 팝업 열기
		function fdbkAudioPopOpen(i) {
			$('#fdbkAudioPop'+i).modal('show');
		}

		// 피드백 음성녹음 팝업 닫기
		function fdbkAudioPopClose(i) {

			var html = "";
			if(aRecord[`aRecord`+i].audioData != ''){
				if($("#fdbkAudioBox"+i+" input:checkbox[name='delFileIds']").length > 0){
					if($("#fdbkAudioBox"+i+" input:checkbox[name='delFileIds']:checked").length < 1){

						 /* 하나의 음성파일만 저장 할 수 있습니다. */
						alert("<spring:message code='forum.alert.audio.record.error'/>");
						return false;
					}
				}
				html += "<i class='paperclip icon f080'></i>";
				html += "<spring:message code='forum.label.audio.record.file'/> REC";
			}else{
				if($("#fdbkAudioBox"+i+" input:checkbox[name='delFileIds']").length > 0){
					if($("#fdbkAudioBox"+i+" input:checkbox[name='delFileIds']:checked").length < 1){
						html += "<i class='paperclip icon f080'></i>";
						html += $("#fdbkAudioBox"+i+" .file-name").html().split(' ')[0];
					}
				}
			}

			$("#fdbkEdtAudioView"+i).html(html);
			$('#fdbkAudioPop'+i).modal('hide');
		}

		// 피드백 파일첨부 팝업 열기
		function fFilePopOpen(id) {
			curUploaderId = id;
			var fileUploader = dx5.get("fileUploader");
			var w = $("#upload"+id+"File").parent().outerWidth();
			var bw = $("#uploadBox .fCloseBtn").outerWidth();
			var h = $("#upload"+id+"File").parent().outerHeight();
			var pos = $("#upload"+id+"File").parent().offset();
			
			$("#uploadBox").css({"visibility":"visible"});
			$("#uploadBox").offset({top: pos.top, left: pos.left});
			$("#uploadBox .dext5-container").css({"width":(w-bw)+"px","height":h+"px"});
			$("#uploadBox button").css({"height":h+"px"});
			fileUploader.setUIStyle({itemHeight: h});
		}

		// 피드백 파일첨부 팝업 닫기
		function fFilePopClose() {
			$("#uploadBox").css("visibility", "hidden");
			fdbkFilePopClose();
		}

	 	// 피드백 음성녹음 팝업 열기
		function fAudioPopOpen() {
			$('#fdbkAudioPop').modal('show');
		}

		// 피드백 음성녹음 팝업 닫기
		function fAudioPopClose() {
			var html = "";
			if(audioRecord.audioData  != ''){
				html += "<i class='paperclip icon f080'></i>";
				html += "<spring:message code='forum.label.audio.record.file'/> REC"; // 음성녹음파일
			}

			$("#fAudioUpload").html(html);
			$('#fdbkAudioPop').modal('hide');
		}

		// 피드백 작성 버튼
		function btnAddFdbk(){
			$("#feedbackWrite").show();
			$(".mla.fcBlue button").eq(0).hide();
			$(".mla.fcBlue button").eq(1).show();
			
			$(".editBtn").prop("disabled", true);
			$(".delBtn").prop("disabled", true);
			
			var fileUploader = dx5.get("fileUploader");
			if (fileUploader != null) {
				fileUploader.clearItems();
				fileUploader.showResetBtn();
			}
		}

		// 피드백 취소 버튼
		function btnCancelFdbk(){
			$("#feedbackWrite").hide();
			$(".mla.fcBlue button").eq(0).show();
			$(".mla.fcBlue button").eq(1).hide();
			
			$(".editBtn").prop("disabled", false);
			$(".delBtn").prop("disabled", false);
			
			var fileUploader = dx5.get("fileUploader");
			if(fileUploader.getTotalItemCount() > 0){
				fileUploader.removeAll();
			}
			$("#uploadBox").css("visibility", "hidden");
			$("#upload0File").html("");
		}

		// 피드백 등록 버튼
		function btnRegFdbk(){
			var fileUploader = dx5.get("fileUploader");
			upType = "add";
			
			// 피드백 입력
			if($("#fdbkValue").val() == ''){
				alert("<spring:message code='forum.alert.input.feedback'/>"); //피드백을 입력해주시기 바랍니다.
				return false;
			}

			if (fileUploader.getFileCount() > 0) {
				fileUploader.startUpload();
			} else {
				// 저장 호출
				regFdbk();
			}
		};

	    // 파일 업로드 완료
	    function finishUpload() {
	    	if (upType == "add") {
	    		regFdbk();
	    	}
	    	else {
		    	edtFdbk();
		    }
	    }

		// 피드백 저장
		function regFdbk() {
			var fileUploader = dx5.get("fileUploader");
	 		var url = "/forum/forumLect/Form/regFdbk.do";
			var data = {
					"crsCreCd" : "${forumVo.crsCreCd}",
					"forumCd" : "${forumVo.forumCd}",
					"stdNo" : "${stdNo}",
					"userId" : "${userId}",
					"userName" : "${userName}",
					"teamCd" : $("#teamCd").val(),
					"fdbkCts" : $("#fdbkValue").val(),
					"uploadFiles" : fileUploader.getUploadFiles(),
					"copyFiles"   : fileUploader.getCopyFiles(),
					"uploadPath"  : fileUploader.getUploadPath(),
					"audioData"   : audioRecord.audioData,
					"audioFile"   : audioRecord.audioFile
				};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					if (typeof window.parent.listForumUser === "function") {
						window.parent.listForumUser(1);	
					}
					else if (typeof window.parent.reloadFeedbackView === "function") {
						window.parent.reloadFeedbackView();
					}
					
					alert("<spring:message code='forum.alert.reg_success.feedback'/>"); // 피드백 등록에 성공하였습니다.
	        		location.reload();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='forum.common.error' />"); // 오류가 발생했습니다!
			}, true);
		}
	</script>

	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap" class="flex flex-column">
            <div class="ui form">
            	<div class="option-content">
                    <h2 class="page-title">${creCrsVO.crsCreNm } (${creCrsVO.declsNo }<spring:message code="forum.label.decls.name" />)</h2><!-- 반 -->
                    <div class="mla fcBlue">
                        <button type="button" class="ui blue small button addBtn" onclick="btnAddFdbk();"${student =='STD' ? ' style="display:none;"': ''}><spring:message code="forum.button.feedback.add" /><!-- 피드백 등록 --></button>
                        <button type="button" class="ui basic small button" onclick="btnCancelFdbk();" style="display:none;"><spring:message code="forum.button.feedback.cancel" /><!-- 피드백 취소 --></button>
                        <b>${forumJoinUserVO.deptNm } ${forumJoinUserVO.userId } ${forumJoinUserVO.userNm }
                            <c:if test="${student ne 'STD'}">
                            <span class="f150">${forumJoinUserVO.score}<spring:message code="forum.label.point" /></span><!-- 점 -->
                            </c:if>
                        </b>
                    </div>
                </div>

				<div  id="feedbackWrite" class="flex1" style="display:none;">
					<div class="field ui fluid input">
                    	<textarea id="fdbkValue" rows="10" class=""  placeholder="<spring:message code='forum.label.feedback.input'/>"></textarea><!-- 피드백 입력 -->
                    </div>

                    <div class="ui box">
                        <div class="fields mr0">
                            <div class="field">
                                <button class="ui basic icon button" onclick="fFilePopOpen(0);"><i class="save icon"></i> <spring:message code='forum.label.fdbk.file.attach'/><!-- 파일첨부 --></button>
                            </div>
                            <div class="field ui segment flex1 flex-item p4" style="position:relative">
                                <div class="flex align-items-center" id="upload0File"></div>
                            </div>
                            
                        </div>

                        <div class="fields  mr0">
                            <div class="field">
                                <button class="ui basic icon button" onclick="fAudioPopOpen();"><i class="microphone icon"></i> <spring:message code='forum.label.fdbk.audio.attach'/><!-- 음성녹음 --></button>
                            </div>
                            <div class="field ui segment flex1 flex-item p4">
                                <div class="flex align-items-center" id="fAudioUpload"></div>
                            </div>
                        </div>
                    </div>
                    <div class="fields mt10 ml0 mr0 tr">
                        <a href="javascript:btnRegFdbk()" class="ui blue button"><spring:message code='forum.button.save'/><!-- 저장 --></a>
                    </div>
                </div>
                <div id="feedbackList" class="mt10"></div>
            </div>

            <div class="bottom-content">
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code='forum.button.close'/><!-- 닫기 --></button>
            </div>
        </div>

    <div class="modal fade" id="fdbkAudioPop" tabindex="-1" role="dialog" aria-labelledby="audio modal" data-backdrop="static" data-keyboard="false" aria-hidden="false">
        <div class="modal-dialog modal-dialog" role="document">
            <div class="modal-content">
				<div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='forum.button.close'/>" onclick="fAudioPopClose();"><!-- 닫기 -->
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title"><spring:message code='forum.label.fdbk.audio.attach'/><!-- 피드백 음성녹음 --></h4>
                </div>
                <div class="modal-body">
                	<div class="modal-page">
                		<div id="wrap">
	                		<div class="ui form" style="height:50px">
								<div id="audioRecord"></div>
							</div>
							<div class="bottom-content">
				           		<a class="ui blue button toggle_btn flex-left-auto" onclick="fAudioPopClose();"><spring:message code='forum.button.attaching'/><!-- 첨부하기 --></a>
				            </div>
				    	</div>
                	</div>
                </div>
            </div>
        </div>
    </div>
    
	<div id="uploadBox" style="position:absolute;top:0;left:0;visibility:hidden;z-index:999">
		<div class="flex1" style="display:inline-block;">
	    	<uiex:dextuploader
				id="fileUploader"
				path="/forum/${forumVO.forumCd}"
				limitCount="1"
				limitSize="1024"
				oneLimitSize="1024"
				listSize="1"
				finishFunc="finishUpload()"
				allowedTypes="*"
				bigSize="false"
				useFileBox="true"
				uiMode="simple"
			/>
		</div>
		<div class="flex1" style="display:inline-block;vertical-align:top">
			<button onclick="fFilePopClose()" class="ui grey small button fCloseBtn" style="margin-left:-4px;"><span aria-hidden="true">&times;</span></button>
		</div>
	</div>
	
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
