<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/forum2/common/forum_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="chart, fileUploader"/>
	</jsp:include>
</head>

	<script type="text/javascript">
		var fUploader = {};
		// var aUploader = {};
		// var aRecord = {};
		// var aPlayer = {};
		var edtNo = null;
		var curUploaderId = "";
		var oldFilesMap = {};
		var upType = "";

		// var audioRecord = null;

		$(document).ready(function() {
			fdbkList();
		});

		// 리스트 조회
		function fdbkList(page) {
			fUploader = {};
			// aRecord = {};
			// aPlayer = {};
			// makeAudioRecord(0);

			var url  = "/forum2/forumLect/getFdbk.do";
			var data = {
				"forumCd" : "${forumVo.forumCd}",
				"stdId" : "${stdId}",
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					if(data.returnList.length > 0){
						var rList = data.returnList;
			    		$("#feedbackList").empty().html(createHTML(rList));
					} else {
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
			
			var fileUploaderNewFeedback = dx5.get("fileUploaderNewFeedback");
			if (fileUploaderNewFeedback != null) {
				fileUploaderNewFeedback.clearItems();
			}
			
			if (oldFilesMap[i] != null && oldFilesMap[i].length > 0) {
				var html = "";
				for(var j=0; j<oldFilesMap[i].length; j++){
					html += "<i class='paperclip icon f080'></i>"+oldFilesMap[i][j].name;
					html += "<button type='button' class='del ml10' style='border:1px solid #aaa;width:16px;height:16px' title='Delete' onclick=\"fdbkFileReset("+(i)+");\"></button>";
				}
				$("#upload"+i+"File").html(html);				
				fileUploaderNewFeedback.addOldFileList(oldFilesMap[i]);
			}
			
			fileUploaderNewFeedback.showResetBtn();
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
			
			var fileUploaderNewFeedback = dx5.get("fileUploaderNewFeedback");
			if(fileUploaderNewFeedback.getTotalItemCount() > 0){
				fileUploaderNewFeedback.removeAll();
			}
			$("#uploadBox").css("visibility", "hidden");
		}

		// 피드백 저장 버튼
		function btnFdbkSave(i){
			var fileUploaderNewFeedback = dx5.get("fileUploaderNewFeedback");
			upType = "edit";
			edtNo = i;
			
			// 피드백 등록 버튼
			if (fileUploaderNewFeedback.availUpload()) {
				fileUploaderNewFeedback.startUpload();
			} else {
				// 저장 호출
				edtFdbk();
			}
		};

		// 피드백 저장
		function edtFdbk() {
			var fileUploaderNewFeedback = dx5.get("fileUploaderNewFeedback");
			var delFileIds = [];

			/*if($("#fdbkAudioBox"+edtNo).css("display") != 'none'){
				if(aRecord[`aRecord`+edtNo].audioFile != '' &&
						( $("#fdbkAudioBox" +edtNo+ " input:checkbox[name='delFileIds']").length
							- $("#fdbkAudioBox" +edtNo+ " input:checkbox[name='delFileIds']:checked").length) > 0){
					 /!* 하나의 음성파일만 저장 할 수 있습니다. *!/
					alert("<spring:message code='forum.alert.audio.record.error'/>");
					return false;
				}
				for(var i=0; i<$("#fdbkAudioBox" +edtNo+ " input:checkbox[name='delFileIds']:checked").length; i++ ){
					delFileIds.push($("#fdbkAudioBox" +edtNo+ " input:checkbox[name='delFileIds']:checked").eq(i).val());
				}
			}*/

	 		var url = "/forum2/forumLect/edtFdbk.do";
			var data = {
				"forumFdbkCd" : $("#fdbk"+edtNo).data("fdbkCd"),
				"fdbkCts"     : $("#fdbkValue"+edtNo).val(),
				"uploadFiles" : fileUploaderNewFeedback.getUploadFiles(),
				"uploadPath"  : fileUploaderNewFeedback.getUploadPath(),
				"delFileIds"  : fileUploaderNewFeedback.getDelFileIds(),
				/*"audioData"   : aRecord[`aRecord`+edtNo].audioData,
				"audioFile"   : aRecord[`aRecord`+edtNo].audioFile*/
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
				var url  = "/forum2/forumLect/delFdbk.do";
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
			/*edtNo = i;
			writeOpen();
			$("#audioView"+i).show();*/
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

	            html += "	<textarea id='fdbkValue" + (i+1) + "' rows='3' class='width-100per' style='resize:none;display:none' readonly='readonly'>" + o.fdbkCts + "</textarea>";
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
                // 음성 녹음 기능 막음 처리.
                /*html += "       <div class='fields mr0'>";
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
                html += "       </div>";*/
                html += "   </div>";
			    html += "</div>";
			});

			return html;
		}

	 	// 피드백 파일첨부 팝업 열기
		function fdbkFilePopOpen(id) {
			curUploaderId = id;
			var fileUploaderNewFeedback = dx5.get("fileUploaderNewFeedback");
			var w = $("#upload"+id+"File").parent().outerWidth();
			var bw = $("#uploadBox .fCloseBtn").outerWidth();
			var h = $("#upload"+id+"File").parent().outerHeight();
			var pos = $("#upload"+id+"File").parent().offset();
			
			$("#uploadBox").css({"visibility":"visible"});
			$("#uploadBox").offset({top: pos.top, left: pos.left});
			$("#uploadBox .dext5-container").css({"width":(w-bw)+"px","height":h+"px"});
			$("#uploadBox button").css({"height":h+"px"});
			fileUploaderNewFeedback.setUIStyle({itemHeight: h});
		}

		// 피드백 파일첨부 팝업 닫기
		function fdbkFilePopClose(i) {
			var fileUploaderNewFeedback = dx5.get("fileUploaderNewFeedback");
			
			if(fileUploaderNewFeedback.getTotalItemCount() > 0){
				var html = "";
				var items = fileUploaderNewFeedback.getItems();

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
			
			var fileUploaderNewFeedback = dx5.get("fileUploaderNewFeedback");
			if(fileUploaderNewFeedback.getTotalItemCount() > 0){
				fileUploaderNewFeedback.removeAll();
			}
		}

		// 피드백 파일첨부 팝업 열기
		function fFilePopOpen(id) {
			curUploaderId = id;
			var fileUploaderNewFeedback = dx5.get("fileUploaderNewFeedback");
			var w = $("#upload"+id+"File").parent().outerWidth();
			var bw = $("#uploadBox .fCloseBtn").outerWidth();
			var h = $("#upload"+id+"File").parent().outerHeight();
			var pos = $("#upload"+id+"File").parent().offset();
			
			$("#uploadBox").css({"visibility":"visible"});
			$("#uploadBox").offset({top: pos.top, left: pos.left});
			$("#uploadBox .dext5-container").css({"width":(w-bw)+"px","height":h+"px"});
			$("#uploadBox button").css({"height":h+"px"});
			fileUploaderNewFeedback.setUIStyle({itemHeight: h});
		}

		// 피드백 파일첨부 팝업 닫기
		function fFilePopClose() {
			$("#uploadBox").css("visibility", "hidden");
			fdbkFilePopClose();
		}

		// 피드백 작성 버튼
		function btnAddFdbk(){
			$("#feedbackWrite").show();
			$(".mla.fcBlue button").eq(0).hide();
			$(".mla.fcBlue button").eq(1).show();
			
			$(".editBtn").prop("disabled", true);
			$(".delBtn").prop("disabled", true);
			
			var fileUploaderNewFeedback = dx5.get("fileUploaderNewFeedback");
			if (fileUploaderNewFeedback != null) {
				fileUploaderNewFeedback.clearItems();
				fileUploaderNewFeedback.showResetBtn();
			}
		}

		// 피드백 취소 버튼
		function btnCancelFdbk(){
			$("#feedbackWrite").hide();
			$(".mla.fcBlue button").eq(0).show();
			$(".mla.fcBlue button").eq(1).hide();
			
			$(".editBtn").prop("disabled", false);
			$(".delBtn").prop("disabled", false);
			
			var fileUploaderNewFeedback = dx5.get("fileUploaderNewFeedback");
			if(fileUploaderNewFeedback.getTotalItemCount() > 0){
				fileUploaderNewFeedback.removeAll();
			}
			$("#uploadBox").css("visibility", "hidden");
			$("#upload0File").html("");
		}

		// 피드백 등록 버튼
		function btnRegFdbk(){
			var fileUploaderNewFeedback = dx5.get("fileUploaderNewFeedback");
			upType = "add";
			
			// 피드백 입력
			if($("#fdbkValue").val() == ''){
				alert("<spring:message code='forum.alert.input.feedback'/>"); //피드백을 입력해주시기 바랍니다.
				return false;
			}

			if (fileUploaderNewFeedback.availUpload()) {
				fileUploaderNewFeedback.startUpload();
			} else {
				// 저장 호출
				regFdbk();
			}
		};

	    // 파일 업로드 완료
	    function finishUploadNewFeedback() {
	    	var fileUploaderNewFeedback = dx5.get("fileUploaderNewFeedback");
	    	var url = "/common/uploadFileCheck.do";
	    	var data = {
	    		"uploadFiles" : fileUploaderNewFeedback.getUploadFiles(),
	    		"uploadPath"  : fileUploaderNewFeedback.getUploadPath()
	    	};
	    	ajaxCall(url, data, function(data) {
	    		if(data.result > 0) {
	    			if (upType == "add") { regFdbk(); }
	    			else { edtFdbk(); }
	    		} else {
	    			alert("<spring:message code='success.common.file.transfer.fail'/>");
	    		}
	    	}, function(xhr, status, error) {
	    		alert("<spring:message code='success.common.file.transfer.fail'/>");
	    	});
	    }

		// 피드백 저장
		function regFdbk() {
			var fileUploaderNewFeedback = dx5.get("fileUploaderNewFeedback");
	 		var url = "/forum2/forumLect/Form/regFdbk.do";
			var data = {
					"crsCreCd" : "${forumVo.crsCreCd}",
					"forumCd" : "${forumVo.forumCd}",
					"stdId" : "${stdId}",
					"userId" : "${userId}",
					"userName" : "${userName}",
					"teamCd" : $("#teamCd").val(),
					"fdbkCts" : $("#fdbkValue").val(),
					"uploadFiles" : fileUploaderNewFeedback.getUploadFiles(),
					"uploadPath"  : fileUploaderNewFeedback.getUploadPath(),
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

    <body class="modal-page">
        <div id="wrap">
            <div class="ui form">
                <div class="msg-box basic board_top">
                    <h2 class="page-title">${creCrsVO.crsCreNm } (${creCrsVO.declsNo }<spring:message code="forum.label.decls.name" />)</h2><!-- 반 -->
                    <div class="right-area">
                        <div class="mla fcBlue">
                            <button type="button" class="btn type1 small" onclick="btnAddFdbk();"${student =='STD' ? ' style="display:none;"': ''}><spring:message code="forum.button.feedback.add" /><!-- 피드백 등록 --></button>
                            <button type="button" class="btn type2 small" onclick="btnCancelFdbk();" style="display:none;"><spring:message code="forum.button.feedback.cancel" /><!-- 피드백 취소 --></button>
                            <b>${forumJoinUserVO.deptNm } ${forumJoinUserVO.userId } ${forumJoinUserVO.userNm }
                                <c:if test="${student ne 'STD'}">
                                <span class="f150">${forumJoinUserVO.score}<spring:message code="forum.label.point" /></span><!-- 점 -->
                                </c:if>
                            </b>
                        </div>
                    </div>
                </div>

				<div  id="feedbackWrite" class="" style="display:none;">
					<div class="field ui fluid input">
                    	<textarea id="fdbkValue" style="width:100%;height:100px;resize: none;" rows="3" placeholder="<spring:message code='forum.label.feedback.input'/>"></textarea><!-- 피드백 입력 -->
                    </div>

                    <div id="uploadBox" class="mt10 width-100per">
                        <!-- TODO : 피드백 File Uplaod -->
                        <uiex:dextuploader
                                id="fileUploaderNewFeedback"
                                path="/forum/${forumVo.forumCd}"
                                limitCount="3"
                                limitSize="100"
                                oneLimitSize="100"
                                listSize="1"
                                fileList=""
                                finishFunc="finishUploadNewFeedback()"
                                allowedTypes="*"
                        />
                    </div>
                    <div class="text-center mt10">
                        <a href="javascript:btnRegFdbk()" class="btn type1"><spring:message code='forum.button.save'/><!-- 저장 --></a>
                    </div>
                </div>
                <div id="feedbackList" class="mt10"></div>
            </div>

            <div class="bottom-content text-center mt10">
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code='forum.button.close'/><!-- 닫기 --></button>
            </div>
        </div>

       <%-- <div class="modal fade" id="fdbkAudioPop" tabindex="-1" role="dialog" aria-labelledby="audio modal" data-backdrop="static" data-keyboard="false" aria-hidden="false">
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
        </div>--%>

        <<%--div id="uploadBox" style="position:absolute;top:0;left:0;visibility:hidden;z-index:999">
            <div class="flex1" style="display:inline-block;">
                <div id="fileUploadBlock">
                    <uiex:dextuploader
                        id="fileUploaderNewFeedback"
                        path="/forum/${forumVo.forumCd}"
                        limitCount="1"
                        limitSize="100"
                        oneLimitSize="100"
                        listSize="1"
                        finishFunc="finishUploadNewFeedback()"
                        allowedTypes="*"
                        bigSize="false"
                        uiMode="simple"
                    />
                </div>
            </div>
            <div class="flex1" style="display:inline-block;vertical-align:top">
                <button onclick="fFilePopClose()" class="ui grey small button fCloseBtn" style="margin-left:-4px;"><span aria-hidden="true">&times;</span></button>
            </div>
        </div>--%>

        <script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
