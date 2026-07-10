<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="knou.framework.common.SessionInfo" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/forum2/common/dscs_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
	<jsp:param name="module" value="editor,fileuploader"/>
	<jsp:param name="style" value="classroom"/>
</jsp:include>
<script type="text/javascript">
var EPARAM = '<c:out value="${encParams}" />';
var gStdId = "<c:out value='${initialStdId}' />";
var gTeamId = "<c:out value='${initialTeamId}' />";
var dialog;
$(document).ready(function() {
	getJoinUserOrTeamList();
	// 토론 이전, 다음 버튼 이벤트 (E : 이전, D : 다음)
	$(document).on("keyup", function(e) {
		if(!(document.activeElement.tagName === "INPUT" || document.activeElement.tagName === "TEXTAREA")) {
			if($("#rubric_card [name=ezgTargetUser].card.active-toggle-btn.select").length > 0) {
	    		if(e.keyCode == 68) {
	    			btnNext();
	    		} else if(e.keyCode == 69) {
	    			btnPrev();
	    		}
			}
		}
	});
})

// EZ-Grader 저장 대상 학습자 목록 조회. 팀 제목 선택 시 선택된 팀원 card 전체를 대상으로 한다.
function getSelectedEzgStdIds() {
	var stdIds = [];
	$("[name=ezgTargetUser].card.active-toggle-btn.select").each(function() {
		var stdId = $(this).attr("data-stdId");
		if(stdId && stdIds.indexOf(stdId) < 0) {
			stdIds.push(stdId);
		}
	});
	return stdIds.join(",");
}

// EZ-Grader 목록 재조회 후 복원할 현재 선택 상태를 저장한다.
function getEzgSelectionState() {
	var selectedStdId = $("#selectedStdId").val();
	var selectedTeamId = $("#selectedTeamId").val();
	var selectedCards = $("#rubric_card [name=ezgTargetUser].card.active-toggle-btn.select");
	var selectedTeam = $("#rubric_card [name=ezgTargetUser].temaTitle.active-toggle-btn.select");
	var firstCard = selectedCards.first();

	return {
		"mode" : selectedStdId ? "USER" : (selectedTeamId ? "TEAM" : ""),
		"userId" : $("#selectedUserId").val() || firstCard.attr("data-userId") || "",
		"stdId" : selectedStdId || firstCard.attr("data-stdId") || "",
		"stdIds" : getSelectedEzgStdIds(),
		"teamId" : selectedTeamId || selectedTeam.attr("data-team-id") || firstCard.attr("data-team-id") || "",
		"dscsId" : $("#ezgDscsId").val()
	};
}

// EZ-Grader 대상자 목록 reload 이후 이전 선택 상태를 복원한다.
function restoreEzgSelectionState(selectionState) {
	if(!selectionState || !selectionState.mode) {
		return false;
	}

	if(selectionState.dscsId) {
		$("#ezgDscsId").val(selectionState.dscsId);
	}

	if(selectionState.mode == "USER" && selectionState.stdId) {
		var userCard = $("#rubric_card [name=ezgTargetUser].card").filter(function() {
			return $(this).attr("data-stdId") == selectionState.stdId
				&& (!selectionState.teamId || $(this).attr("data-team-id") == selectionState.teamId);
		}).first();
		if(userCard.length > 0) {
			selectUser(userCard);
			return true;
		}
	}

	if(selectionState.mode == "TEAM" && selectionState.teamId) {
		var teamTitle = $("#rubric_card [name=ezgTargetUser].temaTitle").filter(function() {
			return $(this).attr("data-team-id") == selectionState.teamId;
		}).first();
		if(teamTitle.length > 0) {
			selectTeam(teamTitle);
			return true;
		}
	}

	return false;
}

// 대상 사용자 또는 팀 정렬/필터 변경 후 리스트 조회
function sortAndFilterJoinUser() {
	var selectionState = typeof getEzgSelectionState === "function" ? getEzgSelectionState() : null;
	getJoinUserOrTeamList(selectionState);
	$("#forumContBlock").empty();
}

// EZ-Grader 대상 목록은 선택된 팀의 자식 토론이 아니라 팝업 진입 시 부모 토론 기준으로 조회한다.
function getEzgListDscsId() {
	return $("#ezgParentDscsId").val() || $("#ezgDscsId").val();
}

// 대상 사용자 또는 팀 리스트 조회
function getJoinUserOrTeamList(selectionState) {
	var url = "/forum2/ezgPop/joinUserList.do";

	var paramData = {
		"sbjctId" : $("#ezgSbjctId").val()
		, "dscsId" : getEzgListDscsId()
		, "searchKey" : $("#ezgSearchKey").val()=='SEL_ALL'?'':$("#ezgSearchKey").val()
		, "searchSort" : $("#ezgSearchSort").val()
		, "stdId" : selectionState && selectionState.mode == "USER" ? selectionState.stdId : $("#selectedStdId").val()
		, "teamId" : selectionState && selectionState.teamId ? selectionState.teamId : $("#selectedTeamId").val()
	}; 

	$("#rubric_card").load(
		url
		, paramData
		, function (response, status, xhr) {
			if(status == "error") {
				$("#rubric_card").html(renderEzgEmpty("<spring:message code='forum.common.error' />"));
				return;
			}
			if(restoreEzgSelectionState(selectionState)) {
				return;
			}
			if(gTeamId != "") {
				var teamTitle = $("#rubric_card [name=ezgTargetUser].temaTitle").filter(function() {
					return $(this).attr("data-team-id") == gTeamId;
				}).first();
				if(teamTitle.length > 0) {
					selectTeam(teamTitle);
					gTeamId = "";
					return;
				}
				gTeamId = "";
			}
			if(gStdId != "") {
				var userCard = $("#rubric_card [name=ezgTargetUser].card").filter(function() {
					return $(this).attr("data-stdId") == gStdId;
				}).first();
				gStdId = "";
				if(userCard.length > 0) {
					selectUser(userCard);
					return;
				}
			}
			var firstTeam = $("#rubric_card [name=ezgTargetUser].temaTitle").first();
			if(firstTeam.length > 0) {
				selectTeam(firstTeam);
				return;
			}
			var firstUser = $("#rubric_card [name=ezgTargetUser].card").first();
			if(firstUser.length > 0) {
				selectUser(firstUser);
			}
		}
	);
}

// 토론 내용(파일) 화면 로드
function getDscsContsView(userId, stdId, teamId, teamStdIds) {
	if (!stdId && !teamId) {
		$("#forumContBlock").empty();
		return;
	}

	listDscs(userId, stdId, teamStdIds);
}

// 토론글 리스트
function listDscs(userId, stdId, teamStdIds) {
	// 팀 전체 선택일 때만 stdList를 전달하고, 개별 학습자 선택은 stdId만 전달한다.
	var isTeamAll = stdId == "ALL";
	var paramData = {
		"dscsId" : $("#ezgDscsId").val(),
		"sbjctId" : $("#ezgSbjctId").val(),
		"stdId" : (!isTeamAll && stdId) ? stdId : "",
		"stdList" : (isTeamAll && teamStdIds) ? teamStdIds : "",
		"dscsUnitTycd" : $("#ezgDscsUnitTycd").val(),
		"oknokStngyn" : $("#ezgOknokStngyn").val() || ""
	};

	if(paramData.stdId == "" && paramData.stdList == "") {
		$("#forumContBlock").empty();
		return;
	}

	ajaxCall("/forum2/ezgPop/dscsActivityList.do", paramData, function(data) {
		if(data.result > 0) {
			$("#forumContBlock").html(renderEzgActivityList(data.returnList || [], data.returnVO || {}));
		} else {
			$("#forumContBlock").html(renderEzgEmpty("<spring:message code='forum.common.empty' />")); // 등록된 내용이 없습니다.
		}
	}, function(xhr, status, error) {
		$("#forumContBlock").html(renderEzgEmpty("<spring:message code='forum.common.error' />")); // 오류가 발생했습니다.
	}, true);
}

// EZ-Grader 토론 활동 목록 렌더링
function renderEzgActivityList(groups, meta) {
	if(meta.isProsConsForum === true || meta.isProsConsForum === "true") {
		return renderProsConsActivitySections(groups);
	}
	if(groups.length == 0) {
		return renderEzgEmpty("<spring:message code='forum.common.empty' />"); // 등록된 내용이 없습니다.
	}
	return renderActivityGroups(groups);
}

// 찬반토론 활동 목록 영역 렌더링
function renderProsConsActivitySections(groups) {
	var okGroups = [];
	var notOkGroups = [];
	(groups || []).forEach(function(group) {
		if(group.oknokGbncd == "OK") {
			okGroups.push(group);
		} else if(group.oknokGbncd == "NOTOK") {
			notOkGroups.push(group);
		}
	});
	return [
		"<button type='button' class='btn width-100per primary'><span class='fcWhite'><spring:message code='forum.label.pros' /></span></button>", // 찬성
		renderActivityGroups(okGroups),
		"<button type='button' class='btn width-100per bcRed mt20'><span class='fcWhite'><spring:message code='forum.label.cons' /></span></button>", // 반대
		renderActivityGroups(notOkGroups)
	].join('');
}

// EZ-Grader 활동 목록 그룹 렌더링
function renderActivityGroups(groups) {
	if(!groups || groups.length == 0) {
		return renderEzgEmpty("<spring:message code='forum.common.empty' />"); // 등록된 내용이 없습니다.
	}
	var html = ["<div class='Comment mt10'>"];
	groups.forEach(function(group, index) {
		html.push(group.groupType == "OWN_ATCL" ? renderOwnAtclGroup(group, index) : renderCommentOnlyGroup(group, index));
	});
	html.push("</div>");
	return html.join('');
}

// 본인 게시글과 본인 댓글 그룹 렌더링
function renderOwnAtclGroup(group, index) {
	var atcl = group.atcl || {};
	var comments = group.comments || [];
	var commentCount = Number(group.commentCount || comments.length) || 0;
	return [
		"<div class='comment_list'>",
		"<ul>",
		"<li>",
		"  <div class='item'>",
		renderEzgWriterInfo(atcl.usernm, atcl.stdntNo, atcl.regDttm),
		"    <span class='comment'>" + renderAtclBody(atcl) + renderDelynState(atcl.delyn) + "</span>",
		"    <span class='btn_right cmtBtnGroup'></span>",
		"    <div class='cmt_detail'><div>",
		"      <span class='textNum'><i class='xi-paper-o'></i>" + (atcl.atclCtsLen || 0) + "</span>",
		/*"      <span class='comNum'><i class='xi-speech-o'></i>" + commentCount + "</span>",*/ /* 26.5.7 : 자기것만 표시하므로 제거*/
		renderFileLinks(atcl.fileList),
		"    </div>",
		commentCount > 0 ? "<button type='button' class='toggle_commentlist mlAuto' data-target='ezgCmnt" + index + "'>" + commentCount + "<spring:message code='forum.label.cnt.forum.cmnt' /></button>" : "", // 댓글 수
		"    </div>",
		"  </div>",
		renderCommentList(comments, "ezgCmnt" + index),
		"</li>",
		"</ul>",
		"</div>"
	].join('');
}

// 타인 게시글에 작성한 댓글 그룹 렌더링
function renderCommentOnlyGroup(group, index) {
	var comments = group.comments || [];
	var commentCount = Number(group.commentCount || comments.length) || 0;
	return [
		"<div class='comment_list'>",
		"<ul class='bd0'>",
		"<li class='course_history bcLgrey3 mt0'>",
		"  <div class='item flex'>",
		renderEzgWriterInfo(group.userNm, group.stdntNo, ""),
		/*"    <span class='comment'><spring:message code='forum.button.cmnt' /> <spring:message code='forum.label.join' /></span>",*/
		"    <div class='cmt_detail mt0 mlAuto'>",/*<div><span class='comNum'><i class='xi-speech-o'></i>" + commentCount + "</span></div>*/
		commentCount > 0 ? "<button type='button' class='toggle_commentlist btn type2' data-target='ezgCmntOnly" + index + "'>" + commentCount + "<spring:message code='forum.label.cnt.forum.cmnt' /></button>" : "", // 댓글 수
		"    </div>",
		"  </div>",
		renderCommentList(comments, "ezgCmntOnly" + index),
		"</li>",
		"</ul>",
		"</div>"
	].join('');
}

// 활동 댓글 목록 렌더링
function renderCommentList(comments, id) {
	if(!comments || comments.length == 0) {
		return "";
	}
	var html = ["<ul class='re_comment_ul dpNone' id='" + id + "'>"];
	comments.forEach(function(item) {
		html.push([
			"<li class='re_comment'>",
			"  <div class='item'>",
			renderEzgWriterInfo(item.usernm, "", item.regDttm || item.modDttm),
			"    <span class='comment'>" + (item.cmntCts || "") + renderDelynState(item.delyn) + "</span>",
			"    <div class='cmt_detail'>",
			"      <div>",
			"        <span class='textNum'><i class='xi-paper-o'></i>" + (item.cmntCtsLen || 0) + "</span>",
			"      </div>",
			"    </div>",
			"  </div>",
			"</li>"
		].join(''));
	});
	html.push("</ul>");
	return html.join('');
}

// 활동 작성자 정보 렌더링
function renderEzgWriterInfo(name, stdntNo, dttm) {
	var userName = escapeHtml(name || stdntNo || "");
	var userNo = stdntNo ? " (" + escapeHtml(stdntNo) + ")" : "";
	return [
		"<div class='cmt_info'>",
		"  <div class='user'><span class='user_img'></span></div>",
		"  <div><strong class='name'>" + userName + userNo + "</strong>",
		dttm ? "<span class='date'>" + formatDttm(dttm) + "</span>" : "",
		"  </div>",
		"</div>"
	].join('');
}

// 게시글 본문 렌더링
function renderAtclBody(item) {
	return item.delyn == "Y" ? "" : (item.atclCts || "");
}

// 삭제/숨김 상태 표시
function renderDelynState(delyn) {
	if(delyn == "Y") {
		return " <span class='label s_c02'><spring:message code='forum.label.sapn.del.content' /></span>"; // 삭제된 글입니다.
	}
	if(delyn == "H") {
		return " <span class='label s_c01'><spring:message code='forum.button.hide.applied' /></span>"; // 숨김적용
	}
	return "";
}

// 첨부파일 링크 렌더링
function renderFileLinks(fileList) {
	var html = [];
	(fileList || []).forEach(function(item) {
		var encDownParam = item.encDownParam || "";
		var fileName = escapeHtml(item.filenm || item.fileNm || item.orgnlFileNm || "");
		if(encDownParam && fileName) {
			html.push("<span class='fileName'><a href='#0' onclick=\"UiFileDownloader('" + escapeJs(encDownParam) + "');return false;\">" + fileName + "</a></span>");
		}
	});
	return html.join(' ');
}

// 빈 활동 목록 표시
function renderEzgEmpty(message) {
	return "<div class='Comment mt10'><div class='comment_list'><ul><li><div class='item'><span class='comment'>" + message + "</span></div></li></ul></div></div>";
}

// 일시 표시 형식 변환
function formatDttm(dttm) {
	dttm = String(dttm || "");
	if(dttm.length < 12) {
		return "";
	}
	return dttm.substring(0, 4) + "." + dttm.substring(4, 6) + "." + dttm.substring(6, 8)
		+ " (" + dttm.substring(8, 10) + ":" + dttm.substring(10, 12) + ")";
}

// HTML 이스케이프
function escapeHtml(text) {
	return String(text || '').replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#39;');
}

// JavaScript 문자열 이스케이프
function escapeJs(value) {
	return String(value || '').replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/\r?\n/g, ' ');
}

$(document).off("click", ".toggle_commentlist[data-target]").on("click", ".toggle_commentlist[data-target]", function() {
	$("#" + $(this).attr("data-target")).toggle();
});

// EZ-Grader 점수 입력 화면 로드
function getScoreInputView(userId, stdId, teamId) {
		var url = "/forum2/ezgPop/ezgScoreView.do";
		var paramData = {
			"sbjctId" : $("#ezgSbjctId").val()
			, "dscsId" : $("#ezgDscsId").val()
			, "userId" : userId
			, "stdId" : stdId
			, "teamId" : teamId
			, "evlScrTycd" : "<c:out value='${dscsVO.evlScrTycd}' />"
		}; 

		$("#totalScoreInputBlock").load(
			url
			, paramData
			, function () {}
		);
}

// 문항별 점수 입력 화면 로드
// 제줄자 정보 화면 로드
// 댓글 보기
function cmntView(atclSn,index) {
	$("#article"+index).toggle();
}

// feedback 화면 로드
function getDscsFeedbackView(userId, stdId, teamId) {
	if(stdId || teamId) {
		$("#dscsFeedbackBlock").load(
			"/forum2/ezgPop/forumScoreEvalFeedBack.do"
			, {
				"sbjctId" : $("#ezgSbjctId").val()
				, "dscsId" : $("#ezgDscsId").val()
				, "userId" : userId
				, "stdId" : stdId
				, "teamId" : teamId
				, "searchMenu" : "EZG"
			}
			, function (response, status, xhr) {
				console.log(status);
			}
		);
	}
}

// 현재 선택 대상 기준으로 피드백/메모 영역을 다시 조회한다.
function reloadFeedbackView() {
	getDscsFeedbackView($("#selectedUserId").val(), $("#selectedStdId").val(), $("#selectedTeamId").val());
}

// 피드백 화면 로드
function displayNoselectuserBlock(isDisplay) {
	$("#noSelectUserBlock").hide();
	if (isDisplay) {
		$("#noSelectUserBlock").show();
	} 
}

// 피드백 파일첨부 팝업 열기
function fdbkFilePopOpen() {
	if($('.active-toggle-btn.select').length < 1){
		UiComm.showMessage("<spring:message code='forum_ezg.label.select.empty' />", "info"); // 선택된 대상이 없습니다.
		return false;
	}

	var w = $("#fdbkFileBox").width();
	var h = $("#fdbkFileBox").height();
	var bw = $("#fdbkFileBox").children("a.button").outerWidth();
	var pos = $("#fdbkFileBox").offset();
	
	$("#fileUpDiv").css({"visibility":"visible","width":(w-bw)+"px"});
	$("#fdbkFileUploader-container").css("height",h+"px");
	$("#fileUpDiv").find("button").css("height",h+"px");
	$("#fileUpDiv").offset({top:pos.top, left:pos.left});
}

// 피드백 파일첨부 취소
function fdbkFileReset(){
	var fileUploader = dx5.get("fdbkFileUploader");
	fileUploader.removeAll();
	$("#fdbkFileViewPop").empty();
}

// 피드백 등록 전 입력값 확인
function valFdbk(){
	if($('.active-toggle-btn.select').length < 1){
		UiComm.showMessage("<spring:message code='forum_ezg.label.select.empty' />", "info"); // 선택된 대상이 없습니다.
		return false;
	}

	// 피드백 입력
	if($("#fdbkValue").val() == "" || $("#fdbkValue").val() == undefined){
		UiComm.showMessage("<spring:message code='forum.label.input.feedback'/>", "info"); // 피드백을 입력하세요.
		return false;
	}
	
	$("#fdbkUploadForm > input[name='uploadFiles']").val("");
	$("#fdbkUploadForm > input[name='copyFiles']").val("");
	$("#fdbkUploadForm > input[name='uploadPath']").val("");

	UiComm.showMessage("<spring:message code='forum.alert.feedback.confirm'/>", "confirm") // 피드백 저장 확인
		.then(function(isConfirm) {
			if(isConfirm) {
				submitFdbk();
			}
		});
}
// 피드백 파일 업로드 완료 후 저장 처리
function finishUpload(){
	var fileUploader = dx5.get("fdbkFileUploader");
	var url = "/file/fileHome/saveFileInfo.do";
	var data = {
		"uploadFiles" : fileUploader.getUploadFiles(),
		"copyFiles"   : fileUploader.getCopyFiles(),
		"uploadPath"  : fileUploader.getUploadPath()
	};
	
	ajaxCall(url, data, function(data) {
		if(data.result > 0) {
			$("#fdbkUploadForm > input[name='uploadFiles']").val(fileUploader.getUploadFiles());
			$("#fdbkUploadForm > input[name='copyFiles']").val(fileUploader.getCopyFiles());
			$("#fdbkUploadForm > input[name='uploadPath']").val(fileUploader.getUploadPath());
			submitFdbk();
		} else {
			UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
		}
	}, function(xhr, status, error) {
		UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
	}, true);
}
// 선택 학습자에게 피드백을 등록한다.
function submitFdbk() {
	var fileUploader = dx5.get("fdbkFileUploader");
	var stdIds = getSelectedEzgStdIds();
	var teamId = "";
	// 팀토론은 선택된 팀의 자식토론ID로 피드백을 저장한다.
	var dscsId = $("#ezgDscsId").val();
	
	$('[name=ezgTargetUser].card.active-toggle-btn.select').each(function() {
		teamId = $(this).attr("data-team-id");
		return false;
	});
	
	var url = "/forum2/forumLect/Form/regFdbk.do";
	var data = {
		"sbjctId"       : $("#ezgSbjctId").val(),
		"dscsId"        : dscsId,
		"stdIds"        : stdIds,
		"teamId"        : teamId,
		"dscsFdbkCts"   : $("#fdbkValue").val(),
		"uploadFiles"   : $("#fdbkUploadForm > input[name='uploadFiles']").val(),
		"uploadPath"    : $("#fdbkUploadForm > input[name='uploadPath']").val()
	};
	ajaxCall(url, data, function(data) {
		if (data.result > 0) {
			UiComm.showMessage("<spring:message code='forum.alert.reg_success.feedback'/>", "success"); // 피드백 등록이 성공하였습니다.
			getDscsFeedbackView($("#selectedUserId").val(), $("#selectedStdId").val(), $("#selectedTeamId").val());
		} else {
			UiComm.showMessage("<spring:message code='forum.alert.reg_fail.feedback'/>", "error"); // 피드백 등록에 실패하였습니다.
		}
		
		if(fileUploader.getFileCount() > 0){
			fileUploader.removeAll();
		}
		$('#fileUpDiv').css("visibility","hidden");
		
	}, function(xhr, status, error) {
		UiComm.showMessage("<spring:message code='forum.common.error' />", "error"); // 오류가 발생했습니다.
	}, true);
}
// 선택 학습자의 교수자 메모를 저장한다.
function submitMemo() {
	if($('.active-toggle-btn.select').length < 1){
		UiComm.showMessage("<spring:message code='forum_ezg.label.select.empty' />", "info"); // 선택된 대상이 없습니다.
		return false;
	}

	// 팀 선택 OR 개인선택 확인 후 분기
	var stdId = $('[name=ezgTargetUser].card.active-toggle-btn.select').attr("data-stdId");
	// 팀토론은 선택된 팀의 자식토론ID로 교수자 메모를 저장한다.
	var dscsId = $("#ezgDscsId").val();
	var url = "/forum2/forumLect/editDscsProfMemo.do";
	var data = {
		"dscsId"     : dscsId,
		"stdId"      : stdId,
		"profMemo"   : $("#profMemo").val()
	};
	
	UiComm.showMessage("<spring:message code='forum.alert.memo.confirm' />", "confirm") // 메모 저장 확인
		.then(function(isConfirm) {
			if(!isConfirm) {
				return;
			}

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					UiComm.showMessage("<spring:message code='forum.alert.memo.insert' />", "success"); // 메모 저장이 완료되었습니다.
				} else {
					UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>", "error"); // 에러가 발생했습니다.
				}
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error"); // 에러가 발생했습니다.
			}, true);
		});
}
// 선택 학습자의 참여형 점수를 일괄 처리한다.
function partiScore() {
	UiComm.showMessage(`<spring:message code="forum.confirm.parti.score" />`, "confirm") // 참여형 일괄평가 확인
		.then(function(isConfirm) {
			if(!isConfirm) {
				return;
			}

			var url = "/forum2/forumLect/participateScore.do";
			// 참여형 일괄평가는 부모 토론ID 기준으로 백엔드에서 팀토론 자식토론까지 처리한다.
			var selectionState = typeof getEzgSelectionState === "function" ? getEzgSelectionState() : null;
			var data = {
				"sbjctId" : $("#ezgSbjctId").val(),
				"dscsId" : $("#ezgParentDscsId").val() || $("#ezgDscsId").val()
			};

			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					UiComm.showMessage("<spring:message code='forum.alert.evalctgr.participate.all' />", "success"); // 참여형 일괄평가가 완료되었습니다.
					getJoinUserOrTeamList(selectionState);
				} else {
					UiComm.showMessage(data.message || "<spring:message code='forum.common.error' />", "error"); // 오류가 발생했습니다.
				}
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='forum.common.error' />", "error"); // 오류가 발생했습니다.
			}, true);
		});
}
//피드백 파일첨부 팝업 닫기
function fdbkFilePopClose() {
	var fileUploader = dx5.get("fdbkFileUploader");
	
	if(fileUploader.getFileCount() > 0){
		if(fileUploader.getTotalItemCount() > 0){
			var html = "";
			var items = fileUploader.getItems();

			html += "<i class='paperclip icon f080'></i>";
			html += items[0].name;
			html += "<button type='button' class='del ml10' style='border:1px solid #aaa;width:16px;height:16px' title='Delete' onclick=\"fdbkFileReset();\"></button>";

			$("#fdbkFileViewPop").html(html);
		}
	} else {
		$("#fdbkFileViewPop").html("");
	}
	$('#fileUpDiv').css("visibility","hidden");
}

// 파일 선택 레이어를 닫고 선택한 파일명을 표시한다.
function closeFileSelect() {
	fdbkFilePopClose();
}
</script>
</head>

<body class="class ${uiex:getTheme()}">
	<%-- Hidden values --%>
	<input type="hidden" id="ezgSbjctId" name="sbjctId" value="${dscsVO.sbjctId}" />
	<input type="hidden" id="ezgParentDscsId" value="${dscsVO.dscsId}" />
	<input type="hidden" id="ezgDscsId" name="dscsId" value="${dscsVO.dscsId}" />
	<input type="hidden" id="ezgDscsUnitTycd" value="${dscsVO.dscsUnitTycd}" />
	<input type="hidden" id="ezgOknokStngyn" value="${dscsVO.oknokStngyn}" />

	<div id="wrap" class="main pusher <%=SessionInfo.getThemeMode(request)%>">
		<div class="modal_EzGarder_area" style="width: 100%; height: 100%; border-radius: 0;">
			<h1 class="EzGarder_title">
				EZ-Grader
				<button type="button" class="btn_close" onclick="window.parent.onCloseEzGraderPop();" aria-label="close"><i class="xi-close"></i></button>
			</h1>
			<div id="context">
			<div class="ui form">
				<div class="EzCarder_content">
					<!-- 왼쪽 영역 -->
					<div class="left_list">
						<div id="joinuserOrTeamSearchBlock" class="left_select_box mb10">
							<select class="form-select" id="ezgSearchSort" onChange="sortAndFilterJoinUser()">
								<option value=""><spring:message code="forum_ezg.label.sel_order" /></option><!-- 정렬 선택 -->
								<option value="STDNT_NO"><spring:message code="forum_ezg.label.userid_order" /></option><!-- 학번순 -->
								<option value="USER_NM"><spring:message code="forum_ezg.label.nm_order" /></option><!-- 이름순 -->
								<option value="SUBMIT_DT"><spring:message code="forum_ezg.label.submit_order" /></option><!-- 제출자순 -->
							</select>
							<select class="form-select" id="ezgSearchKey" onChange="sortAndFilterJoinUser()">
								<option value="SEL_ALL"><spring:message code="forum_ezg.label.sel_filter" /></option><!-- 필터 선택 -->
								<option value="JOIN"><spring:message code="forum.label.join" /></option><!-- 참여 -->
								<option value="NOTJOIN"><spring:message code="forum.label.not.join" /></option><!-- 미참여 -->
							</select>
						</div>
						<div class="stu_list_area" id="rubric_card">
						</div>
					</div>
					<!-- 왼쪽 영역 -->

					<!-- 중앙 영역 -->
					<div class="center_com width-100per" id="mainView">
						<div class="scrollArea" id="forumContBlock" >
						</div>
					</div>
					<!-- 중앙 영역 -->

					<!-- 오른쪽 영역 -->
					<div class="right_app">
						<div>
							<div class="element" style="display:none" id="noSelectUserBlock">
								<div class="ui small error message">
									<i class="info circle icon"></i>
									<spring:message code="forum_ezg.label.noselect_user" /><!-- 평가 대상자를 선택하시기 바랍니다. -->
								</div>
							</div>
							<div class="right_top_score" id="totalScoreInputBlock">
							</div>
							<div id="totalScoreActionBlock">
							</div>
								
							<!-- 루브릭 정보 -->
							<!-- 루브릭 정보 -->
							
							<div class="element" >
								<div id="forumSendInfoBlock">
								</div>
								<!-- 피드백, 메모 -->
								<div class="right_memo" id="dscsFeedbackBlock">
								</div>
								<!-- 피드백, 메모 -->
							</div>
							
							<div id="fileUpDiv" style="display:flex;position:absolute;top:0;left:0;width:300px;visibility:hidden">
								<form id="fdbkUploadForm" name="fdbkUploadForm">
									<input type="hidden" name="uploadFiles" value="" />
									<input type="hidden" name="copyFiles"   value="" />
									<input type="hidden" name="uploadPath"  value="" />
								</form>
								<uiex:dextuploader
									id="fdbkFileUploader"
									path="/forum/${dscsVO.dscsId}"
									limitCount="1"
									limitSize="1024"
									oneLimitSize="1024"
									listSize="1"
									finishFunc="finishUpload()"
									allowedTypes="*"
									bigSize="false"
									uiMode="simple"
								/>
								<div class="flex1" style="display:inline-block;vertical-align:top">
									<button onclick="closeFileSelect()" class="ui grey small button" style="margin-left:-4px;"><span aria-hidden="true">&times;</span></button>
								</div>
							</div>
						</div>
					</div>
					<!-- 오른쪽 영역 -->
				</div>
			</div>
			<%--Top 버튼--%>
			<button type="button" class="go_top"><i class="xi-angle-up-min"></i><span>TOP</span></button>
		</div>

	</div>
	</div>
<script>
// UiDialog 팝업 닫기
window.closeDialog = function() {
	if (dialog) {
		dialog.close();
		dialog = null;
	}
};
</script>

</body>
</html>
