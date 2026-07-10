<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="classroom"/>
			<jsp:param name="module" value="editor,fileuploader"/>
		</jsp:include>
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
		$(document).ready(function() {
			smnrFdbkListSelect();
		});

		// 세미나피드백목록조회
		function smnrFdbkListSelect() {
			const url  = "/smnr/profSmnrFdbkListAjax.do";
			const data = {
				smnrId 	: "${vo.smnrId}",
				userId 	: "${smnrAtndVO.userId}"
			};

			ajaxCall(url, data, function (data) {
	            if (data.result > 0) {
	            	let html = createSmnrFdbkListHTML(data.returnList);	// 세미나 피드백 리스트 HTML 생성
	        		$("#fdbkListDiv").empty().html(html);
	            } else {
	                UiComm.showMessage(data.message, "error");
	            }
	        }, function (xhr, status, error) {
	        	UiComm.showMessage("<spring:message code='exam.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
	        }, true);
		}

		// 피드백목록HTML추가
		function createSmnrFdbkListHTML(list) {
			if(list.length == 0) {
				return "";
			} else {
				let html = "";
				list.forEach(function(v, i) {
					html += "<div class='board_top'>";
					html += "	<h5 class='sub-title-sm'><i class='xi-comment-o icon'></i>" + UiComm.formatDate(v.regDttm, "datetime2") + "</h5>";
					if("${userTycd}" == "PROF") {
						html += "<div class='right-area'>";
						html += "	<button onclick='fdbkModifyFrm(\"" + v.smnrFdbkId + "\", this)' class='btn basic'>수정</button>";
						html += "	<button onclick='fdbkDelete(\"" + v.smnrFdbkId + "\")' class='btn basic'>삭제</button>";
						html += "</div>";
					}
					html += "</div>";
					html += "<div class='table_list'>";
					html += "	<ul class='list' id='"+v.smnrFdbkId+"ViewDiv'>";
					html += "		<li class='head'><label>피드백</label></li>";
					html += "			<div class='tb_content'>";
					if(v.fdbkCts != null) {
						html += 			v.fdbkCts;
					}
					if(v.fileList != null && v.fileList.size() > 0) {
						html += "			<div class='add_file_list mt10'>";
						html += "				<ul class='add_file'>";
						v.fileList.forEach(function(vv, ii) {
							html += "				<li>";
							html += "					<a href='#_' class='file_down' onclick='UiFileDownloader(\""+vv.encDownParam+"\");return false;' title='File download'>"+vv.filenm+"</a>";
							html += "				</li>";
						});
						html += "				</ul>";
						html += "			</div>";
					}
					html += "			</div>";
					html += "		</li>";
					html += "	</ul>";
					html += "	<div id='"+v.smnrFdbkId+"EditDiv'></div>";
					html += "</div>";
				});

				return html;
			}
		}

		// 피드백수정폼
		function fdbkModifyFrm(smnrFdbkId, obj) {
			$(obj).text("저장");
			$(obj).attr('onclick', "fdbkSaveConfirm('" + smnrFdbkId + "')");

			const url  = "/smnr/smnrFdbkSelectAjax.do";
			const data = {
				smnrFdbkId  : smnrFdbkId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					createFdbkHTML(smnrFdbkId+"EditDiv", smnrFdbkId, data.data);
					$("#"+smnrFdbkId+"ViewDiv").hide();
	        	} else {
	        		UiComm.showMessage(data.message, "error");
	        	}
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");	/* 에러가 발생했습니다! */
			});
		}

		// 피드백등록토글
		function fdbkRegistToggle(obj) {
			$(obj).toggleClass("on");
			if($(obj).hasClass("on")) {
				$(obj).text("피드백 취소");
				createFdbkHTML("fdbkInputDiv", "");
			} else {
				$(obj).text("피드백 등록");
				$("#fdbkInputDiv").empty();
			}
		}

		// 피드백등록HTML추가
		function createFdbkHTML(id, smnrFdbkId, fdbkVO) {
			let html = "";
			if(smnrFdbkId == "") {
				html += "<div class='table_list'>";
			}
			const fdbkCts = fdbkVO != null ? fdbkVO.fdbkCts : "";
			html += "<form id='"+smnrFdbkId+"FdbkFrm' onsubmit='return false;'>";
			html += "	<input type='hidden' name='uploadFiles' />";
			html += "	<input type='hidden' name='uploadPath' 	value='${vo.uploadPath}' />";
			html += "	<input type='hidden' name='delFileIdStr' />";
			html += "	<input type='hidden' name='smnrId' 		value='${vo.smnrId}' />";
			html += "	<input type='hidden' name='userId'		value='${smnrAtndVO.userId}' />";
			html += "	<input type='hidden' name='smnrFdbkId'	value='"+smnrFdbkId+"' />";
			html += "	<ul class='list'>";
			html += "		<li class='head'><label>피드백</label></li>";
			html += "		<li>";
			html += "			<div class='tb_content'>";
			html += "				<textarea name='fdbkCts' style='width:100%;height:70px' placeholder='피드백 입력'>" + fdbkCts + "</textarea>";
			html += "				<div class='upload-file mt10'>";
			html += "					<div id='"+smnrFdbkId+"FileUploaderWrap' class='width-85per'></div>";
			if(smnrFdbkId == "") {
				html += "				<button onclick='fdbkSaveConfirm(\"\")' class='btn type1'>저장</button>";
			}
			html += "				</div>";
			html += "			</div>";
			html += "		</li>";
			html += "	</ul>";
			html += "</form>";
			if(smnrFdbkId == "") {
				html += "</div>";
			}
			$("#"+id).empty().html(html);

			const uploaderId 	= smnrFdbkId + "FileUploader";
			const wrapId		= smnrFdbkId + "FileUploaderWrap";
			const fileList 		= fdbkVO != null && fdbkVO.fileList != null ? fdbkVO.fileList : "";

			UiFileUploader({
		        id: uploaderId,
		        targetId: wrapId,
		        path: "${vo.uploadPath}",
		        limitCount: 1,
		        limitSize: 1024,
		        oneLimitSize: 1024,
		        listSize: 1,
		        fileList: fileList,
		        finishFunc: finishUpload,
		        allowedTypes: "*",
		        uiMode: "simple"
		    });
		}

		// 파일 업로드 완료
	    function finishUpload(uploaderId) {
	    	let url = "/common/uploadFileCheck.do"; // 업로드된 파일 검증 URL
        	let dx = dx5.get(uploaderId);
        	let data = {
        		uploadFiles : dx.getUploadFiles(),
        		uploadPath  : dx.getUploadPath()
        	};

        	// 업로드된 파일 체크
        	ajaxCall(url, data, function(data) {
        		if(data.result > 0) {
        			let smnrFdbkId = uploaderId.replace("FileUploader", "").trim();
        			$("#"+smnrFdbkId+"FdbkFrm input[name='uploadFiles']").val(dx.getUploadFiles());

        	    	save(smnrFdbkId);
        		} else {
					UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
        		}
        	},
        	function(xhr, status, error) {
        		UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
        	});
	    }

		// 피드백저장확인
		function fdbkSaveConfirm(smnrFdbkId) {
			const fdbkCts = $.trim($("#"+smnrFdbkId+"FdbkFrm textarea[name=fdbkCts]").val());
			let dx = dx5.get(smnrFdbkId+"FileUploader");
			if(fdbkCts == "" && !dx.availUpload()) {
				UiComm.showMessage("피드백 내용이나 파일첨부를 해주세요.", "warning");
				return false;
			}

			if (dx.availUpload()) {
    			dx.startUpload();
    		}
			// 첨부파일 없으면 저장 호출
    		else {
    			save(smnrFdbkId);
    		}
		}

		// 저장
		function save(smnrFdbkId) {
			let dx = dx5.get(smnrFdbkId+"FileUploader");
    		$("#"+smnrFdbkId+"FdbkFrm input[name='delFileIdStr']").val(dx.getDelFileIdStr());	// 삭제파일 ID 설정

    		const url = "/smnr/smnrFdbkModifyAjax.do";

    		ajaxCall(url, $("#"+smnrFdbkId+"FdbkFrm").serialize(), function (data) {
	            if (data.result > 0) {
	            	location.reload();
	            } else {
	                UiComm.showMessage(data.message, "error");
	            }
	        }, function (xhr, status, error) {
	        	UiComm.showMessage("<spring:message code='exam.error.insert' />", "error");	/* 저장 중 에러가 발생하였습니다. */
	        }, true);
		}

		// 피드백삭제
		function fdbkDelete(smnrFdbkId) {
			const url  = "/smnr/smnrFdbkDeleteAjax.do";
			const data = {
				smnrFdbkId	: smnrFdbkId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					UiComm.showMessage("<spring:message code='exam.alert.delete' />", "success", 500)	/* 정상 삭제 되었습니다. */
					.then(function(result) {
						location.reload();
					});
			    } else {
			     	UiComm.showMessage(data.message, "error");
			    }
		    }, function(xhr, status, error) {
		    	UiComm.showMessage("<spring:message code='exam.error.delete' />", "error");/* 삭제 중 에러가 발생하였습니다. */
		    }, true);
		}
	</script>

	<body class="modal-body">
	    <div class="board_top class">
	       	<h3 class="board-title">${vo.sbjctnm } ${vo.dvclasNo }반</h3>
	       	<div class="right-area">
	       		<c:if test="${userTycd eq 'PROF' }">
		       		<button type="button" class="btn type2" onclick="fdbkRegistToggle(this)">피드백 등록</button>
	       		</c:if>
	       		<div class="feedback-info">
	                <p class="desc">
	                    <span><strong>${smnrAtndVO.deptnm }</strong></span>
	                    <span><strong>${smnrAtndVO.userId }</strong></span>
	                    <span><strong>${smnrAtndVO.usernm }</strong></span>
	                    <c:if test="${userTycd eq 'PROF' || vo.mrkOyn eq 'Y' }">
		                    <span class="score"><strong>${smnrAtndVO.atndEvlScr }점</strong></span>
	                    </c:if>
	                </p>
	            </div>
	       	</div>
	    </div>

	    <div id="fdbkInputDiv"></div>

	    <div id="fdbkListDiv"></div>

		<div class="modal_btns">
	        <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
		</div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
