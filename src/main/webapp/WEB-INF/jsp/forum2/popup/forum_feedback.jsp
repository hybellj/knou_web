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
		var edtNo = null;
		var oldFilesMap = {};
		var upType = "";
		var editingFeedbackNo = null;
		var isAddingFeedback = false;
		var feedbackUploaderSeq = 0;
		var currentFeedbackUploaderId = "";
		var currentFeedbackUploaderHostId = "";

		$(document).ready(function() {
			fdbkList();
		});

		function getFeedbackUploader() {
			if (currentFeedbackUploaderId === "") {
				return null;
			}
			return dx5.get(currentFeedbackUploaderId);
		}

		function getFeedbackUploaderContainerSelector() {
			return currentFeedbackUploaderId === "" ? "" : "#" + currentFeedbackUploaderId + "-container";
		}

		function getFeedbackUploaderButtonAreaSelector() {
			return currentFeedbackUploaderId === "" ? "" : "#" + currentFeedbackUploaderId + "-btn-area";
		}

		function createFeedbackUploaderAt(textareaSelector, oldFiles) {
			var $textarea = $(textareaSelector);
			if ($textarea.length === 0) {
				return null;
			}

			removeActiveFeedbackUploader();
			feedbackUploaderSeq += 1;
			currentFeedbackUploaderId = "fileUploaderNewFeedback_" + feedbackUploaderSeq;
			currentFeedbackUploaderHostId = "feedbackUploaderHost_" + feedbackUploaderSeq;
			var wrapId = "feedbackUploaderWrap_" + feedbackUploaderSeq;

			$textarea.after("<div id='" + currentFeedbackUploaderHostId + "' class='mt10 width-100per'><div id='" + wrapId + "'></div></div>");

			UiFileUploader({
				id: currentFeedbackUploaderId,
				targetId: wrapId,
				path: "${dscsVO.uploadPath}",
				limitCount: 3,
				limitSize: 100,
				oneLimitSize: 100,
				listSize: 3,
				fileList: "",
				finishFunc: "finishUploadNewFeedback()",
				allowedTypes: "*"
			});
			var uploader = getFeedbackUploader();
			if (uploader == null) {
				return null;
			}
			if (uploader != null) {
				$(getFeedbackUploaderContainerSelector()).css({
					display: "block",
					visibility: "visible",
					width: "100%",
					height: "180px",
					minHeight: "180px"
				});
				$(getFeedbackUploaderButtonAreaSelector()).css({
					display: "",
					visibility: "visible"
				});
				if (oldFiles != null && oldFiles.length > 0 && typeof uploader.addOldFileList === "function") {
					uploader.addOldFileList(oldFiles);
				}
				if (typeof uploader.showResetBtn === "function") {
					uploader.showResetBtn();
				}
			}

			return uploader;
		}

		function removeActiveFeedbackUploader() {
			var uploader = getFeedbackUploader();
			if (uploader != null) {
				if (typeof uploader.removeAll === "function") {
					uploader.removeAll();
				}
				if (typeof uploader.revokeAllVirtualFiles === "function") {
					uploader.revokeAllVirtualFiles();
				}
			}
			if (currentFeedbackUploaderHostId !== "") {
				$("#" + currentFeedbackUploaderHostId).remove();
			}
			currentFeedbackUploaderId = "";
			currentFeedbackUploaderHostId = "";
		}

		// 리스트 조회
		function fdbkList(page) {
			fUploader = {};

			var url  = "/forum2/forumLect/getFdbk.do";
			var data = {
				"dscsId" : "${dscsVO.dscsId}",
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
			if (isAddingFeedback) {
				alert("피드백 등록 중에는 글수정을 할 수 없습니다.");
				return false;
			}
			if (editingFeedbackNo != null && editingFeedbackNo !== i) {
				alert("이미 다른 피드백을 수정 중입니다.");
				return false;
			}
			editingFeedbackNo = i;

			$("#fdbkValue"+i).prop("readonly",false);
			$("#fdbkValue"+i).show();
			$("#fdbkValueDiv"+i).hide();
			$("#aFileView"+i).hide();

			$("#fdbk"+i+" .button-area button").eq(0).hide();
			$("#fdbk"+i+" .button-area button").eq(1).hide();
			$("#fdbk"+i+" .button-area button").eq(2).show();
			$("#fdbk"+i+" .button-area button").eq(3).show();
			$("#btnAddFdbkMain").prop("disabled", true);
			$(".editBtn").prop("disabled", true);
			$(".delBtn").prop("disabled", true);
			
			createFeedbackUploaderAt("#fdbkValue" + i, oldFilesMap[i]);
		}

		// 피드백 취소 버튼
		function btnFdbkCancel(i){
			$("#fdbkValue"+i).val($("#fdbkValue"+i).text());

			$("#fdbkValue"+i).prop("readonly",true);
			$("#fdbkValue"+i).hide();
			$("#fdbkValueDiv"+i).show();
			$("#aFileView"+i).show();

			$("#fdbk"+i+" .button-area button").eq(0).show();
			$("#fdbk"+i+" .button-area button").eq(1).show();
			$("#fdbk"+i+" .button-area button").eq(2).hide();
			$("#fdbk"+i+" .button-area button").eq(3).hide();
			$("#btnAddFdbkMain").prop("disabled", false);
			$(".editBtn").prop("disabled", false);
			$(".delBtn").prop("disabled", false);
			editingFeedbackNo = null;
			
			removeActiveFeedbackUploader();
		}

		// 피드백 저장 버튼
		function btnFdbkSave(i){
			upType = "edit";
			edtNo = i;
			editingFeedbackNo = i;
			var fileUploaderNewFeedback = getFeedbackUploader();
			
			// 피드백 등록 버튼
			if (fileUploaderNewFeedback != null && fileUploaderNewFeedback.availUpload()) {
				fileUploaderNewFeedback.startUpload();
			} else {
				// 저장 호출
				edtFdbk();
			}
		};

		// 피드백 저장
		function edtFdbk() {
			var fileUploaderNewFeedback = getFeedbackUploader();

	 		var url = "/forum2/forumLect/edtFdbk.do";
			var data = {
				"forumFdbkCd" : $("#fdbk"+edtNo).data("fdbkCd"),
				"fdbkCts"     : $("#fdbkValue"+edtNo).val(),
				"uploadFiles" : fileUploaderNewFeedback != null ? fileUploaderNewFeedback.getUploadFiles() : "",
				"uploadPath"  : fileUploaderNewFeedback != null ? fileUploaderNewFeedback.getUploadPath() : "",
				"delFileIds"  : fileUploaderNewFeedback != null ? fileUploaderNewFeedback.getDelFileIds() : []
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
		            html += "       	<button onclick='btnFdbkEdt("+(i+1)+")' class='btn basic small editBtn'><spring:message code='forum.button.fdbk.mod'/><!-- 글수정 --></button>";
		            html += "       	<button onclick='btnFdbkDelete("+(i+1)+")' class='btn basic small delBtn'><spring:message code='forum.button.del'/><!-- 삭제 --></button>";
		            html += "       	<button onclick='btnFdbkSave("+(i+1)+")' class='btn basic small' style='display:none;'><spring:message code='forum.button.save'/><!-- 저장 --></button>";
		            html += "        	<button onclick='btnFdbkCancel("+(i+1)+")' class='btn basic small cancel' style='display:none;'><spring:message code='forum.button.cancel'/><!-- 취소 --></button>";
		            html += "    	</div>";
	            }
	            html += "	</div>";

	            html += "	<textarea id='fdbkValue" + (i+1) + "' rows='3' class='width-100per' style='resize:none;display:none' readonly='readonly'>" + o.fdbkCts + "</textarea>";
	            html += "	<div id='fdbkValueDiv" + (i+1) + "' class='ui segment' style='max-height:200px;overflow:auto'><pre>" + o.fdbkCts + "</pre></div>";
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
							html += "<a href='#_' onclick=\"UiFileDownloader('"+o.fileList[j].encDownParam+"');return false;\" class='ui icon small button d-block' style='margin-bottom: 2px;'>";
							html += "<i class='paperclip icon f080'></i>";
							html += o.fileList[j].filenm;

							html += "</a>";
						}
					}
                }
                html += "               </div>";
                html += "           </div>";
                html += "       </div>";
                html += "   </div>";
			    html += "</div>";
			});

			return html;
		}

		// 피드백 작성 버튼
		function btnAddFdbk(){
			if (editingFeedbackNo != null) {
				alert("피드백 수정 중에는 등록할 수 없습니다.");
				return false;
			}
			isAddingFeedback = true;

			$("#feedbackWrite").show();
			$(".mla.fcBlue button").eq(0).hide();
			$(".mla.fcBlue button").eq(1).show();
			
			$(".editBtn").prop("disabled", true);
			$(".delBtn").prop("disabled", true);
			
			createFeedbackUploaderAt("#fdbkValue");
		}

		// 피드백 취소 버튼
		function btnCancelFdbk(){
			removeActiveFeedbackUploader();
			isAddingFeedback = false;

			$("#feedbackWrite").hide();
			$(".mla.fcBlue button").eq(0).show();
			$(".mla.fcBlue button").eq(1).hide();
			
			$(".editBtn").prop("disabled", false);
			$(".delBtn").prop("disabled", false);
			
			$("#btnAddFdbkMain").prop("disabled", false);
		}

		// 피드백 등록 버튼
		function btnRegFdbk(){
			upType = "add";
			if (editingFeedbackNo != null) {
				alert("피드백 수정 중에는 등록할 수 없습니다.");
				return false;
			}
			var fileUploaderNewFeedback = getFeedbackUploader();
			
			// 피드백 입력
			if($("#fdbkValue").val() == ''){
				alert("<spring:message code='forum.alert.input.feedback'/>"); //피드백을 입력해주시기 바랍니다.
				return false;
			}

			if (fileUploaderNewFeedback != null && fileUploaderNewFeedback.availUpload()) {
				fileUploaderNewFeedback.startUpload();
			} else {
				// 저장 호출
				regFdbk();
			}
		};

	    // 파일 업로드 완료
	    function finishUploadNewFeedback() {
	    	var fileUploaderNewFeedback = getFeedbackUploader();
	    	if (fileUploaderNewFeedback == null) {
	    		if (upType == "add") { regFdbk(); }
	    		else { edtFdbk(); }
	    		return;
	    	}
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
			var fileUploaderNewFeedback = getFeedbackUploader();
	 		var url = "/forum2/forumLect/Form/regFdbk.do";
			var data = {
					"sbjctId" : "${dscsVO.sbjctId}",
					"dscsId" : "${dscsVO.dscsId}",
					"stdId" : "${stdId}",
					"userId" : "${userId}",
					"userName" : "${userName}",
					"teamId" : "${dscsVO.teamId}",
					"fdbkCts" : $("#fdbkValue").val(),
					"uploadFiles" : fileUploaderNewFeedback != null ? fileUploaderNewFeedback.getUploadFiles() : "",
					"uploadPath"  : fileUploaderNewFeedback != null ? fileUploaderNewFeedback.getUploadPath() : "",
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
                            <button type="button" id="btnAddFdbkMain" class="btn type1 small" onclick="btnAddFdbk();"${student =='STD' ? ' style="display:none;"': ''}><spring:message code="forum.button.feedback.add" /><!-- 피드백 등록 --></button>
                            <button type="button" class="btn type2 small" onclick="btnCancelFdbk();" style="display:none;"><spring:message code="forum.button.feedback.cancel" /><!-- 피드백 취소 --></button>
                            <b>${dscsJoinUserVO.deptNm } ${dscsJoinUserVO.userId } ${dscsJoinUserVO.userNm }
                                <c:if test="${student ne 'STD'}">
                                <span class="f150">${dscsJoinUserVO.score}<spring:message code="forum.label.point" /></span><!-- 점 -->
                                </c:if>
                            </b>
                        </div>
                    </div>
                </div>

                <div  id="feedbackWrite" class="" style="display:none;">
					<div class="field ui fluid input">
                    	<textarea id="fdbkValue" style="width:100%;height:100px;resize: none;" rows="3" placeholder="<spring:message code='forum.label.feedback.input'/>"></textarea><!-- 피드백 입력 -->
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

        <script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
