<%@ page import="knou.framework.common.SubjectInfo" %>
<%@ page import="knou.framework.common.ParamInfo" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/forum2/common/dscs_common_inc.jsp" %>
<c:set var="authrtGrpcdStdnt" value="<%=CommConst.AUTHRT_GRPCD_STDNT%>" />
<c:set var="isStdntAuthrtGrpcd" value="${authrtGrpcd eq authrtGrpcdStdnt}" />
<!DOCTYPE html>
<html lang="ko">
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
		var currentFeedbackUploaderWrapId = "";

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
			var textareaId = $textarea.attr("id") || "";
			var uploaderSuffix = textareaId === "fdbkValue" ? "new" : textareaId.replace("fdbkValue", "");
			var hostId = "feedbackUploaderHost_" + uploaderSuffix;
			var wrapId = "feedbackUploaderWrap_" + uploaderSuffix;
			if ($("#" + wrapId).length === 0) {
				return null;
			}

			removeActiveFeedbackUploader();
			feedbackUploaderSeq += 1;
			currentFeedbackUploaderId = "fileUploaderNewFeedback_" + feedbackUploaderSeq;
			currentFeedbackUploaderHostId = hostId;
			currentFeedbackUploaderWrapId = wrapId;
			$("#" + wrapId).empty();

			UiFileUploader({
				id: currentFeedbackUploaderId,
				targetId: wrapId,
				path: "${dscsVO.uploadPath}",
				limitCount: 3,
				limitSize: 100,
				oneLimitSize: 100,
				listSize: 1,
				fileList: oldFiles,
				finishFunc: finishUploadNewFeedback,
				allowedTypes: "*"
			});
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
				$("#" + currentFeedbackUploaderHostId).find("#" + currentFeedbackUploaderWrapId).empty();
			}
			currentFeedbackUploaderId = "";
			currentFeedbackUploaderHostId = "";
			currentFeedbackUploaderWrapId = "";
		}

		// 리스트 조회
		function fdbkList(page) {
			fUploader = {};

			var url  = "${isStdntAuthrtGrpcd ? '/forum2/forumHome/getFdbk.do' : '/forum2/forumLect/getFdbk.do'}";
			// 피드백 목록 조회는 토론 ID와 학습자 ID 기준으로만 조회한다.
			var data = {
				"dscsId" : "${dscsVO.dscsId}",
				"stdId" : "${stdId}"
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
		         	UiComm.showMessage(data.message, "error");
		        }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='forum.common.error' />", "error");// 오류가 발생했습니다!
			}, true);
		}

		// 피드백 수정 버튼
		function btnFdbkEdt(i){
			if (isAddingFeedback) {
				UiComm.showMessage("피드백 등록 중에는 글수정을 할 수 없습니다.", "info");
				return false;
			}
			if (editingFeedbackNo != null && editingFeedbackNo !== i) {
				UiComm.showMessage("이미 다른 피드백을 수정 중입니다.", "info");
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
			$("#fdbkValue"+i).attr("maxLenCheck", "byte,4000,true,false");
			
			createFeedbackUploaderAt("#fdbkValue" + i, oldFilesMap[i]);
			UiInputmaskText();
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
			$("#fdbkValue"+i).removeAttr("maxLenCheck");
			$("#fdbkValue"+i+"_countBox").remove();
			$("#fdbkValue"+i).removeClass("show-count");
			
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
				"dscsFdbkId" : $("#fdbk"+edtNo).data("dscsFdbkId"),
				"dscsFdbkCts" : $("#fdbkValue"+edtNo).val(),
				"uploadFiles" : fileUploaderNewFeedback != null ? fileUploaderNewFeedback.getUploadFiles() : "",
				"uploadPath"  : fileUploaderNewFeedback != null ? fileUploaderNewFeedback.getUploadPath() : "",
				"delFileIds"  : fileUploaderNewFeedback != null ? fileUploaderNewFeedback.getDelFileIds() : []
			};

			edtNo = null;
			$.ajaxSettings.traditional = true;
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					UiComm.showMessage("<spring:message code='forum.alert.mod_success.feedback'/>", "success"); // 피드백 수정에 성공하였습니다.
	        		location.reload();
	            } else {
	             	UiComm.showMessage(data.message, "error");
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='forum.common.error' />", "error"); // 오류가 발생했습니다!

			}, true);
		}

		// 피드백 삭제 버튼
		function btnFdbkDelete(i){
            UiComm.showMessage("<spring:message code='forum.alert.confirm.delete' />", "confirm")/*  정말 토론을 삭제 하시겠습니까?  */
                .then(function(result) {
                    if (result) {
                        var url  = "/forum2/forumLect/delFdbk.do";
                        var data = {
                            "dscsFdbkId" : $("#fdbk"+i).data("dscsFdbkId")
                        };

                        ajaxCall(url, data, function(data) {
                            if (data.result > 0) {
                                if (typeof window.parent.reloadFeedbackView === "function") {
                                    window.parent.reloadFeedbackView();
                                }

                                UiComm.showMessage("<spring:message code='forum.alert.del_success'/>", "success"); // 삭제에 성공하였습니다.
                                location.reload();
                            } else {
                                UiComm.showMessage(data.message, "error");
                            }
                        }, function(xhr, status, error) {
                            UiComm.showMessage("<spring:message code='forum.common.error'/>", "error"); // 오류가 발생했습니다!
                        }, true);
                    }
                });
		}

		// 피드백 작성 버튼
		function btnAddFdbk(){
			if (editingFeedbackNo != null) {
				UiComm.showMessage("피드백 수정 중에는 등록할 수 없습니다.", "info");
				return false;
			}
			isAddingFeedback = true;

			$("#feedbackWrite").show();
			$("#btnAddFdbkMain").hide();
			$("#btnCancelFdbkMain").show();
			
			$(".editBtn").prop("disabled", true);
			$(".delBtn").prop("disabled", true);
			
			createFeedbackUploaderAt("#fdbkValue");
			$("#fdbkValue").attr("maxLenCheck", "byte,4000,true,false");
			UiInputmaskText();
		}

		// 피드백 취소 버튼
		function btnCancelFdbk(){
			removeActiveFeedbackUploader();
			$("#fdbkValue").removeAttr("maxLenCheck");
			$("#fdbkValue_countBox").remove();
			$("#fdbkValue").removeClass("show-count");
			isAddingFeedback = false;

			$("#feedbackWrite").hide();
			$("#btnAddFdbkMain").show();
			$("#btnCancelFdbkMain").hide();
			
			$(".editBtn").prop("disabled", false);
			$(".delBtn").prop("disabled", false);
			
			$("#btnAddFdbkMain").prop("disabled", false);
		}

		// 피드백 등록 버튼
		function btnRegFdbk(){
			upType = "add";
			if (editingFeedbackNo != null) {
				UiComm.showMessage("피드백 수정 중에는 등록할 수 없습니다.", "info");
				return false;
			}
			var fileUploaderNewFeedback = getFeedbackUploader();
			
			// 피드백 입력
			if($("#fdbkValue").val() == ''){
				UiComm.showMessage("<spring:message code='forum.alert.input.feedback'/>", "info"); //피드백을 입력해주시기 바랍니다.
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
	    			UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
	    		}
	    	}, function(xhr, status, error) {
	    		UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
	    	});
	    }

		// 피드백 저장
		function regFdbk() {
			var fileUploaderNewFeedback = getFeedbackUploader();
	 		var url = "/forum2/forumLect/Form/regFdbk.do";
			var data = {
					"dscsId" : "${dscsVO.dscsId}",
					"stdId" : "${stdId}",
					"teamId" : "${dscsVO.teamId}",
					"dscsFdbkCts" : $("#fdbkValue").val(),
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
					
					UiComm.showMessage("<spring:message code='forum.alert.reg_success.feedback'/>", "success"); // 피드백 등록에 성공하였습니다.
	        		location.reload();
	            } else {
	             	UiComm.showMessage(data.message, "error");
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='forum.common.error' />", "error"); // 오류가 발생했습니다!
			}, true);
		}

		function createHTML(data) {
			var html = "";

			$.each(data, function(i, o){
				var fCnt = 0;

				for (var j = 0; j < o.fileList.length; j++) {
					if (o.fileList[j].fileExt != "mp3") {
						fCnt++;
					}
				}

				html += "<div class='feedback-item mt10' id='fdbk" + (i + 1) + "' data-DSCS-FDBK-ID='" + o.dscsFdbkId + "'>";
				html += "	<div class='board_top'>";
				html += "		<h5 class='sub-title-sm'><i class='xi-comment-o icon' aria-hidden='true'></i>" + DscsDate.format(o.regDttm) + "</h5>";
				if ("${isStdntAuthrtGrpcd}" != "true") {
					html += "		<div class='right-area button-area'>";
					html += "			<button type='button' onclick='btnFdbkEdt(" + (i + 1) + ")' class='btn basic small editBtn'><spring:message code='forum.button.fdbk.mod'/></button>";
					html += "			<button type='button' onclick='btnFdbkDelete(" + (i + 1) + ")' class='btn basic small delBtn'><spring:message code='forum.button.del'/></button>";
					html += "			<button type='button' onclick='btnFdbkSave(" + (i + 1) + ")' class='btn basic small' style='display:none;'><spring:message code='forum.button.save'/></button>";
					html += "			<button type='button' onclick='btnFdbkCancel(" + (i + 1) + ")' class='btn basic small cancel' style='display:none;'><spring:message code='forum.button.cancel'/></button>";
					html += "		</div>";
				}
				html += "	</div>";
				html += "	<div class='table_list'>";
				html += "		<ul class='list'>";
				html += "			<li class='head'><label><spring:message code='forum.label.feedback'/></label></li>";/*피드백*/
				html += "			<li>";
				html += "				<div class='tb_content'>";
				if ("${isStdntAuthrtGrpcd}" != "true") {
					html += "					<textarea id='fdbkValue" + (i + 1) + "' class='form-control width-100per' rows='2' style='width:100%;display:none;' readonly='readonly'>" + o.dscsFdbkCts + "</textarea>";
					html += "					<div id='feedbackUploaderHost_" + (i + 1) + "' class='mt10 width-100per'><div id='feedbackUploaderWrap_" + (i + 1) + "'></div></div>";
				}
				html += "					<div id='fdbkValueDiv" + (i + 1) + "' class='view_con' style='white-space:pre-wrap;word-break:break-word;max-height:200px;overflow:auto;'>" + o.dscsFdbkCts + "</div>";
				html += "					<div id='aFileView" + (i + 1) + "' class='mt10'>";
				if (fCnt > 0) {
					html += "						<div class='add_file_list'>";
					html += "							<ul class='add_file'>";
					for (var k = 0; k < o.fileList.length; k++) {
						if (o.fileList[k].fileExt != "mp3") {
							html += "								<li>";
							html += "									<a href='#_' onclick=\"UiFileDownloader('" + o.fileList[k].encDownParam + "');return false;\" class='file_down'>";
							html += "										<i class='icon-svg-paperclip' aria-hidden='true'></i>";
							html += "										<span class='text'>" + o.fileList[k].filenm + "</span>";
							html += "									</a>";
							html += "								</li>";
						}
					}
					html += "							</ul>";
					html += "						</div>";
				}
				html += "					</div>";
				html += "				</div>";
				html += "			</li>";
				html += "		</ul>";
				html += "	</div>";
				html += "</div>";
			});

			return html;
		}
	</script>

	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

    <body class="modal-page ${uiex:getTheme()}">
        <div id="wrap">
            <div class="ui form">
                <div class="board_top class">
                    <%
                        String sbjctnm = SubjectInfo.getSbjctnm(request, ParamInfo.getParamValue(request, "sbjctId"));
                    %>
                    <h3 class="board-title"><%=sbjctnm%></h3>
                    <div class="right-area">
                        <c:if test="${not isStdntAuthrtGrpcd}">
                            <button type="button" id="btnAddFdbkMain" class="btn type2" onclick="btnAddFdbk();"><spring:message code="forum.button.feedback.add" /><!-- 피드백 등록 --></button>
                            <button type="button" id="btnCancelFdbkMain" class="btn type2" onclick="btnCancelFdbk();" style="display:none;"><spring:message code="forum.button.feedback.cancel" /><!-- 피드백 취소 --></button>
                        </c:if>
                        <div class="feedback-info${isStdntAuthrtGrpcd ? ' learner-feedback-info' : ''}">
                            <p class="desc">
                                <span class="dept-info"><strong>${dscsJoinUserVO.deptnm }</strong></span>
                                <span class="user-id-info"><strong>${dscsJoinUserVO.stdntNo }</strong></span>
                                <span class="user-name-info"><strong>${dscsJoinUserVO.userNm }</strong></span>
                                <span class="score">
                                    <strong>
                                        <c:choose>
                                            <c:when test="${not empty dscsJoinUserVO.scr}">
                                                ${dscsJoinUserVO.scr}<spring:message code="forum.label.point" /><!-- 점 -->
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </strong>
                                </span>
                            </p>
                        </div>
                    </div>
                </div>

                <c:if test="${not isStdntAuthrtGrpcd}">
                    <div id="feedbackWrite" class="" style="display:none;">
						<div class="table_list">
							<ul class="list">
								<li class="head"><label><spring:message code='forum.label.feedback'/><%--피드백--%></label></li>
								<li>
									<div class="tb_content">
	                    				<textarea id="fdbkValue" class="form-control width-100per" style="width:100%;"
                                                  rows="2"
                                                  placeholder="<spring:message code='forum.label.feedback.input'/>"></textarea><!-- 피드백 입력 -->
										<div id="feedbackUploaderHost_new" class="mt10 width-100per">
                                            <%--Fileuploader 가 들어가 영역 --%>
                                            <div id="feedbackUploaderWrap_new"></div>
                                        </div>
                                        <div class="text-center mt10">
                                            <a href="javascript:btnRegFdbk()" class="btn type1"><spring:message code='forum.button.save'/><!-- 저장 --></a>
                                        </div>
									</div>
								</li>
							</ul>
						</div>
                    </div>
                </c:if>
                <div id="feedbackList" class="mt10"></div>
            </div>

            <div class="bottom-content text-center mt10">
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code='forum.button.close'/><!-- 닫기 --></button>
            </div>
        </div>

        <script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
