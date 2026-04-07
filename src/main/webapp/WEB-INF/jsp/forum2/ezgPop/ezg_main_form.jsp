<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/forum/common/forum_common_inc.jsp" %>

<script src="/webdoc/player/plyr.js" crossorigin="anonymous"></script>
<script src="/webdoc/player/player.js" crossorigin="anonymous"></script>
<script src="/webdoc/audio-recorder/audio-recorder.js"></script>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<link rel="stylesheet" href="/webdoc/player/plyr.css" />
<link rel="stylesheet" href="/webdoc/audio-recorder/audio-recorder.css" />

<head>
<script type="text/javascript">
var gStdId = "${vo.stdId}";
$(document).ready(function() {
	getEzgTitle();
	getJoinUserOrTeamSearchView();
	getJoinUserOrTeamList();
	// 토론 이전, 다음 버튼 이벤트 (E : 이전, D : 다음)
	$(document).on("keyup", function(e) {
		if(!(document.activeElement.tagName === "INPUT" || document.activeElement.tagName === "TEXTAREA")) {
			if($("#rubric_card > a[name=ezgTargetUser].card.active-toggle-btn.select").length > 0) {
	    		if(e.keyCode == 68) {
	    			btnNext();
	    		} else if(e.keyCode == 69) {
	    			btnPrev();
	    		}
			}
		}
	});
});

// ezg 각 모듈의 제목조회(과제명 또는 토론명 또는 팀활동명)
function getEzgTitle() {
	var url = "/forum2/ezgPop/forum.do";
	var paramData = {
		"sbjctId" : $("#ezgSbjctId").val()
		, "dscsId" : $("#ezgDscsId").val()
	}; 

	$("#loading_page").show();

	$.ajax({
		type : "POST",
		async: false,
		dataType : "json",
		data : paramData,
		url : url,
		success : function(data) {
			if(data.result >= 0) {
				$('#ezgTitle').html('<span>' + data.returnVO.dscsTtl +'</span>');
				$("#evalScoreBlockEvalCd").val(""+ data.returnVO.evalCd +"");
			} else {
				alert(data.message);
			}
		},
		beforeSend: function() {
		},
		complete:function(status){
			$("#loading_page").hide();
		},
		error: function(xhr,  Status, error) {
			$("#loading_page").hide();
		}
	});
}

// 대상 사용자 또는 팀 search view 로드
function getJoinUserOrTeamSearchView() {
	var url = "/forum2/ezgPop/ezgJoinUserSearchView.do";
	var paramData = {
		"sbjctId" : $("#ezgSbjctId").val()
		, "dscsId" : $("#ezgDscsId").val()
	}; 

	$("#joinuserOrTeamSearchBlock").load(
		url
		, paramData
		, function () {
			$('.ui.dropdown').dropdown();
		}
	);
}

// 대상 사용자 또는 팀 리스트 조회
function getJoinUserOrTeamList() {
	var url = "/forum2/ezgPop/joinUserList.do";

	var paramData = {
		"sbjctId" : $("#ezgSbjctId").val()
		, "dscsId" : $("#ezgDscsId").val()
		, "searchKey" : $("#ezgSearchKey").val()=='SEL_ALL'?'':$("#ezgSearchKey").val()
		, "searchSort" : $("#ezgSearchSort").val()
		, "stdId" : $("#selectedStdId").val()
		, "teamId" : $("#selectedTeamCd").val()
	}; 

	$("#rubric_card").load(
		url
		, paramData
		, function () {
			if(gStdId != "") {
				$("a[data-stdId="+gStdId+"]").click();
				gStdId = "";
			}
		}
	);
}

// 토론 내용(파일) 화면 로드
function getDscsContsView(userId, stdId, teamCd, teamStdIds) {
	if (!stdId && !teamCd) {
		$("#forumContBlock").empty();
		return;
	}

	listDscs(1, userId, stdId, teamStdIds);
}

// 토론글 리스트
function listDscs(page, userId, stdId, teamStdIds) {
	var searchValue = "";
	var searchKey = "";
	var listScale = $("#listScale").val();
	if (!listScale) {
		listScale = 10;
	}

	if ($("#searchValue").val() == "찬성") {
		searchValue = "P";
	} else if ($("#searchValue").val() == "반대") {
		searchValue = "C";
	}else if ($("#searchValue").val() == "FeedBack") {
		searchValue = "F";
	} else if (stdId && stdId == 'ALL') {
		searchValue = "";
	} else if (stdId) {
		searchValue = userId;
	} else {
		searchValue = $("#searchValue").val();
	} 

	if(searchValue == "" && $("#ezgDscsUnitTycd").val() == "TEAM") {
		$("#mutEvalChart").hide();
		$("#mutEvalTitle").hide();
	}
	
	searchKey = $("#ezgSearchKey").val()=='SEL_ALL'?'':$("#ezgSearchKey").val();
	
	$("#forumContBlock").load(
		"/forum2/forumLect/evalDscsBbsViewList.do"
		, {
			"pageIndex" : page,
			"listScale" : listScale,
			"searchValue" : searchValue,
			"searchKey" : searchKey,
			"goUrl" : "",
			"dscsId" : $("#ezgDscsId").val(),
			"sbjctId" : $("#ezgSbjctId").val(),
			"userId" : "",
			"userName" : "",
			"dscsUnitTycd" : $("#ezgDscsUnitTycd").val(),
			"stdList" : teamStdIds?teamStdIds:"",
			"searchMenu" : "EZG"
		}
		, function() {
			$(".article").toggle();
		}
	);
}

// 전체 점수 입력 화면 로드
function getTotalScoreInputView(userId, stdId, teamId) {
	//	if (!stdId && !teamCd) {
	//		$("#totalScoreInputBlock").empty();
	//		$("#evalScoreInputBlock").empty();
	//		return;
	//	}

	// 평가방식(EVAL_CTGR : R) ==> 루브릭
	/*
	평가방식 루브릭이 참여형으로 바뀜으로 인한 필요없는 로직
	if("${vo.evlScrTycd}" == "R") {
		var url = "/forum2/ezgPop/ezgTotalScoreView.do";
		var paramData = {
			"sbjctId" : $("#ezgSbjctId").val()
			, "dscsId" : $("#ezgDscsId").val()
			, "userId" : userId
			, "stdId" : stdId
			, "teamId" : teamId
			, "evlScrTycd" : "${vo.evlScrTycd}"
		}; 

		$("#totalScoreInputBlock").load(
			url
			, paramData
			, function () {getEvalScoreInputView(userId, stdId, teamId);}
		);
	} else {
	*/
		var url = "/forum2/ezgPop/ezgScoreView.do";
		var paramData = {
			"sbjctId" : $("#ezgSbjctId").val()
			, "dscsId" : $("#ezgDscsId").val()
			, "userId" : userId
			, "stdId" : stdId
			, "teamId" : teamId
			, "evlScrTycd" : "${vo.evlScrTycd}"
		}; 

		$("#totalScoreInputBlock").load(
			url
			, paramData
			, function () {}
		);
	/*
	}
	*/
}

// 문항별 점수 입력 화면 로드
function getEvalScoreInputView(userId, stdId, teamId) {
	//	if (!stdId && !teamId) {
	//		$("#evalScoreInputBlock").empty();
	//		return;
	//	}

	var url = "/forum2/ezgPop/ezgEvalScoreView.do";
	var paramData = {
		"sbjctId" : $("#ezgSbjctId").val()
		, "dscsId" : $("#ezgDscsId").val()
		, "userId" : userId
		, "stdId" : stdId
		, "teamId" : teamId
	};

	$("#evalScoreInputBlock").load(
		url
		, paramData
		, function () {}
	);
}

// 제줄자 정보 화면 로드
function getTargetUserInfoView(userId, stdId) {
	// TODO : Tobe 미포함.
	/*if (!stdId) {
		$("#targetUserInfoBlock").empty();
		return;
	}

	$("#targetUserInfoBlock").load(
		"/forum2/ezgPop/viewStdSumm.do"
		, {
			"userId" : userId
			, "stdId" : stdId
			, "sbjctId" : "${vo.sbjctId}"
			, "searchMenu" : "EZG"
		}
		, function () {}
	);*/
}

// 댓글 보기
function cmntView(atclSn,index) {
	$("#article"+index).toggle();
}

// feedback 화면 로드
function getDscsFeedbackView(userId, stdId, teamId) {
	if(stdId) {
		$("#forumFeedbackBlock").load(
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

function reloadFeedbackView() {
	getDscsFeedbackView($("#selectedUserId").val(), $("#selectedStdId").val(), $("#selectedTeamCd").val());
}

// 피드백 작성/ 수정하기 
function addFdbkCts(forumFdbkCd, parForumFdbkCd){
	var fdbkCts = $("#fdbkCts").val();

	if(fdbkCts == null || fdbkCts == "") {
		alert("<spring:message code='forum.alert.input.feedback' />"); // 피드백을 입력해주시기 바랍니다.
		$("#toggleBox"+index ).addClass("off").removeClass("on");
	} else {
		$("#fdbkCts").val('');
		if(forumFdbkCd == "" ||forumFdbkCd == null ) {
			$.getJSON("/forum2/forumLect/addFdbkCts.do", {
				"fdbkCts" : fdbkCts,
				"parForumFdbkCd" : parForumFdbkCd,
				"dscsId" : $("#ezgDscsId").val(),
				"stdId" : $("#selectedStdId").val(),
				"userId" : $("#selectedUserId").val(),
				"userName" : $("#selectedUserNm").val(),
				"teamId" : $("#selectedTeamCd").val()
			}).done(function(data) {
				if (data.result > 0) {
					alert("<spring:message code='forum.alert.reg_success.feedback' />"); // 피드백 등록에 성공하였습니다.
					getDscsFeedbackView($("#selectedUserId").val(), $("#selectedStdId").val(), $("#selectedTeamCd").val());
				} else {
					alert("<spring:message code='forum.alert.reg_fail.feedback' />"); // 피드백 등록에 실패하였습니다. 다시 시도해주시기 바랍니다.
					getDscsFeedbackView($("#selectedUserId").val(), $("#selectedStdId").val(), $("#selectedTeamCd").val());
				}
			});
		} else {
			$.getJSON("/forum2/forumLect/editFdbkCts.do", {
				"fdbkCts" : fdbkCts,
				"forumFdbkCd" : forumFdbkCd,
				"dscsId" : $("#ezgDscsId").val(),
				"stdId" : $("#selectedStdId").val(),
				"userId" : $("#selectedUserId").val(),
				"userName" : $("#selectedUserNm").val(),
				"teamId" : $("#selectedTeamCd").val()
			}).done(function(data) {
				if (data.result > 0) {
					alert("<spring:message code='forum.alert.mod_success.feedback' />"); // 피드백 수정에 성공하였습니다.
					getDscsFeedbackView($("#selectedUserId").val(), $("#selectedStdId").val(), $("#selectedTeamCd").val());
				} else {
					alert("<spring:message code='forum.alert.mod_fail.feedback' />"); // 피드백 수정에 실패하였습니다. 다시 시도해주시기 바랍니다.
					getDscsFeedbackView($("#selectedUserId").val(), $("#selectedStdId").val(), $("#selectedTeamCd").val());
				}
			});
		}
	}
}

// 피드백 작성하기 버튼 
function btnAddFdbk() {
	var btn = "";
	btn += "<li id=\"addBtn\">";
	btn += "<a class=\"ui basic grey small button\" onclick=\"addFdbkCts();\" ><spring:message code="forum.button.write" /></a>"; // 등록
	btn += "</li>";
	$("#editBtn").after(btn);
	$("#editBtn").remove();
	$("#fdbkCts").val('');
	$("#toggle").toggle();
}

// 피드백 수정버튼 클릭
function btnEditFdbk(index, forumFdbkCd){
	var fdbkCts = $("#cts"+index).text().trim();

	if(!$("#toggle").hasClass("on")) {
		var btn = "";
		btn += "<li id=\"editBtn\">";
		btn += "<a class=\"ui basic grey small button\" onclick=\"addFdbkCts('"+forumFdbkCd+"');\" ><spring:message code="forum.button.mod" /></a>"; // 수정
		btn += "</li>";
		$("#addBtn").after(btn);
		$("#addBtn").remove();
		
		$("#fdbkCts").val(fdbkCts);
		$("#toggle").addClass("on").removeClass("off");
	} else {
		var btn = "";
		btn += "<li id=\"addBtn\">";
		btn += "<a class=\"ui basic grey small button\" onclick=\"addFdbkCts();\" ><spring:message code="forum.button.write" /></a>"; // 등록
		btn += "</li>";
		$("#editBtn").after(btn);
		$("#editBtn").remove();
		
		$("#toggle").addClass("off").removeClass("on");
	} 
}

// 피드백 댓글 버튼
function btnAddFCmnt(index,forumFdbkCd) {
	var btn = "";
	btn += "<li id=\"addBtnFCmnt\">";
	btn += "<a class=\"ui basic grey small button\" onclick=\"addFCmntCts('"+index+"','','"+forumFdbkCd+"');\" ><spring:message code="forum.button.write" /></a>"; // 등록
	btn += "</li>";

	$("#toggle"+index).children().find('li#editBtnFCmnt').after(btn);
	$("#toggle"+index).children().find('li#editBtnFCmnt').remove();
	$("#toggle"+index).children().find('textarea#fdbkCmnt'+index).val('');
}

// 피드백 댓글 수정 버튼
function btnEditFCmnt(index,forumFdbkCd){
	var fdbkCts = $("#cts"+index).text().trim();
	
	if(!$("#toggle"+index).hasClass("on")){
		var btn = "";
		btn += "<li id=\"editBtnFCmnt\">";
		btn += "<a class=\"ui basic grey small button\" onclick=\"addFCmntCts('"+index+"','"+forumFdbkCd+"');\" ><spring:message code="forum.button.mod" /></a>"; // 수정
		btn += "</li>";
		
		$("#toggle"+index).children().find('li#addBtnFCmnt').after(btn);
		$("#toggle"+index).children().find('li#addBtnFCmnt').remove();
		$("#toggle"+index).children().find('textarea#fdbkCmnt'+index).val(fdbkCts);
		
		$("#toggle"+index).addClass("on").removeClass("off");
	} else {
		var btn = "";
		btn += "<li id=\"addBtnFCmnt\">";
		btn += "<a class=\"ui basic grey small button\" onclick=\"addFCmntCts('"+index+"','','"+forumFdbkCd+"');\" ><spring:message code="forum.button.write" /></a>"; // 등록
		btn += "</li>";
		
		$("#toggle"+index).children().find('li#editBtnFCmnt').after(btn);
		$("#toggle"+index).children().find('li#editBtnFCmnt').remove();
		
		$("#toggle"+index).addClass("off").removeClass("on");
	} 
}

// 피드백  댓글 작성/ 수정하기 
function addFCmntCts(index,forumFdbkCd,parForumFdbkCd) {
	var fCmnt = $("#toggle"+index).children().find('textarea#fdbkCmnt'+index).val();
	
	if(fCmnt == null || fCmnt == "") {
		alert("<spring:message code='forum.alert.input.reply' />"); // 댓글을 입력해주시기 바랍니다.
		$("#toggle"+index ).addClass("off").removeClass("on");
	} else {
		$("#toggle"+index).children().find('textarea#fdbkCmnt'+index).val('');
		if(forumFdbkCd == "" ||forumFdbkCd == null ) {
			$.getJSON("/forum2/forumLect/addFdbkCts.do", {
				"fdbkCts" : fCmnt,
				"parForumFdbkCd" : parForumFdbkCd,
				"dscsId" : $("#ezgDscsId").val(),
				"stdId" : $("#selectedStdId").val(),
				"userId" : $("#selectedUserId").val(),
				"userName" : $("#selectedUserNm").val(),
				"teamId" : $("#selectedTeamCd").val()
			}).done(function(data) {
				if (data.result > 0) {
					alert("<spring:message code='forum.alert.reg_success.reply' />"); // 댓글 등록에 성공하였습니다.
					getDscsFeedbackView($("#selectedUserId").val(), $("#selectedStdId").val(), $("#selectedTeamCd").val());
				} else {
					alert("<spring:message code='forum.alert.reg_fail.reply' />"); // 댓글 등록에 실패하였습니다. 다시 시도해주시기 바랍니다.
					getDscsFeedbackView($("#selectedUserId").val(), $("#selectedStdId").val(), $("#selectedTeamCd").val());
				}
			});
		} else {
			$.getJSON("/forum2/forumLect/editFdbkCts.do", {
				"fdbkCts" : fCmnt,
				"forumFdbkCd" : forumFdbkCd,
				"dscsId" : $("#ezgDscsId").val(),
				"stdId" : $("#selectedStdId").val(),
				"userId" : $("#selectedUserId").val(),
				"userName" : $("#selectedUserNm").val(),
				"teamId" : $("#selectedTeamCd").val()
			}).done(function(data) {
				if (data.result > 0) {
					alert("<spring:message code='forum.alert.mod_success.reply' />"); // 댓글 수정에 성공하였습니다.
					getDscsFeedbackView($("#selectedUserId").val(), $("#selectedStdId").val(), $("#selectedTeamCd").val());
				} else {
					alert("<spring:message code='forum.alert.mod_fail.reply' />"); // 댓글 수정에 실패하였습니다. 다시 시도해주시기 바랍니다.
					getDscsFeedbackView($("#selectedUserId").val(), $("#selectedStdId").val(), $("#selectedTeamCd").val());
				}
			});
		}
	}
}

// 피드백 삭제
function delFdbk(forumFdbkCd) {
	alert("<spring:message code='forum.alert.edit.feedback.del.confirm'/>"); // 피드백을 삭제하시겠습니까?
	$("#alertOk").on('click', function(e) {
		$.getJSON("/forum2/forumLect/delFdbkCts.do", {
			"forumFdbkCd" : forumFdbkCd,
			"stdId" : $("#selectedStdId").val(),
			"dscsId" : $("#ezgDscsId").val(),
			"userId" : $("#selectedUserId").val(),
			"teamId" : $("#selectedTeamCd").val()
		}).done(function(data) {
			if (data.result > 0) {
				alert("<spring:message code='forum.alert.del_success' />"); // 삭제에 성공하였습니다.
				getDscsFeedbackView($("#selectedUserId").val(), $("#selectedStdId").val(), $("#selectedTeamCd").val());
			} else {
				alert("<spring:message code='forum.alert.del_fail' />"); // 삭제에 실패하였습니다. 다시 시도해주시기 바랍니다.
				getDscsFeedbackView($("#selectedUserId").val(), $("#selectedStdId").val(), $("#selectedTeamCd").val());
			}
		});
	});

	$("#alertNo").on('click', function(e) {
		$('#alert-box').removeClass('on');
	});
}

// feedback 화면 로드
function displayNoselectuserBlock(isDisplay) {
	$("#noSelectUserBlock").hide();
	if (isDisplay) {
		$("#noSelectUserBlock").show();
	} 
}

// 피드백 파일첨부 팝업 열기
function fdbkFilePopOpen() {
	if($('.active-toggle-btn.select').length < 1){
		alert("<spring:message code='forum_ezg.label.select.empty' />"); // 선택된 대상이 없습니다.
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

	// 피드백 음성녹음 팝업 열기
function fdbkAudioPopOpen() {
	if($('.active-toggle-btn.select').length < 1){
		alert("<spring:message code='forum_ezg.label.select.empty' />"); // 선택된 대상이 없습니다.
		return false;
	}
	$('#fdbkAudioPop').modal('show');
}

// 피드백 음성녹음 팝업 닫기
function fdbkAudioPopClose() {
	$('#fdbkAudioPop').modal('hide');
}

// 피드백 Validation
function valFdbk(){
	if($('.active-toggle-btn.select').length < 1){
		alert("<spring:message code='forum_ezg.label.select.empty' />"); // 선택된 대상이 없습니다.
		return false;
	}

	// 피드백 입력
	if($("#fdbkValue").val() == "" || $("#fdbkValue").val() == undefined){
		alert("<spring:message code='forum.label.input.feedback'/>"); // 피드백을 입력하세요
		return false;
	}
	
	$("#fdbkUploadForm > input[name='uploadFiles']").val("");
	$("#fdbkUploadForm > input[name='copyFiles']").val("");
	$("#fdbkUploadForm > input[name='uploadPath']").val("");

	if(confirm('<spring:message code='forum.alert.feedback.confirm'/>')) { // 피드백을 저장하시겠습니까?
		// 26.4.3 : Tobe 에 ezgrader 에서 파일 첨부 없음.
		/*var fileUploader = dx5.get("fdbkFileUploader");
		if (fileUploader.getFileCount() > 0) {
			fileUploader.startUpload();
		}else{
			submitFdbk();
		}*/
		submitFdbk();
	}
}

// 피드백 파일업로드
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
			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	});
}

function submitFdbk() {
	var fileUploader = dx5.get("fdbkFileUploader");
	var stdId = "";
	var teamId = "";
	
	if($(".card.active-toggle-btn.select").length > 1){
		$(".card.active-toggle-btn.select").each(function(i) {
		if(i > 0) stdId += ",";
		stdId += $(this).attr("data-stdId");
		teamId = $(this).attr("data-team-id");
	});
	}else{
		stdId = $(".card.active-toggle-btn.select").attr("data-stdId");
		teamId = $(".card.active-toggle-btn.select").attr("data-team-id");
	}
	
	var url = "/forum2/forumLect/Form/regFdbk.do";
	var data = {
		"sbjctId"       : "${vo.sbjctId}",
		"dscsId"		: "${vo.dscsId}",
		"stdId"			: stdId,
		"teamId"		: teamId,
		"fdbkCts"		: $("#fdbkValue").val(),
		"uploadFiles"	: $("#fdbkUploadForm > input[name='uploadFiles']").val(),
		"uploadPath"	: $("#fdbkUploadForm > input[name='uploadPath']").val(),
		"audioData"		: audioRecord.audioData,
		"audioFile"		: audioRecord.audioFile
	};
debugger;
	ajaxCall(url, data, function(data) {
		if (data.result > 0) {
			alert("<spring:message code='forum.alert.reg_success.feedback'/>"); // 피드백 등록에 성공하였습니다.
			getDscsFeedbackView($("#selectedUserId").val(), $("#selectedStdId").val(), $("#selectedTeamCd").val());
		} else {
			alert("<spring:message code='forum.alert.reg_fail.feedback'/>"); // 피드백 등록에 실패하였습니다. 다시 시도해주시기 바랍니다.
		}
		
		var fileUploader = dx5.get("fdbkFileUploader");
		if(fileUploader.getFileCount() > 0){
			fileUploader.removeAll();
		}
		$('#fileUpDiv').css("visibility","hidden");
		
	}, function(xhr, status, error) {
		alert("<spring:message code='forum.common.error' />");/* 오류가 발생했습니다! */
	}, true);
}

function submitMemo() {
	if($('.active-toggle-btn.select').length < 1){
		alert("<spring:message code='forum_ezg.label.select.empty' />"); // 선택된 대상이 없습니다.
		return false;
	}

	// 팀 선택 OR 개인선택 확인 후 분기
	var stdId = $(".card.active-toggle-btn.select").attr("data-stdId");
	var url = "/forum2/forumLect/editDscsProfMemo.do";
	var data = {
		"dscsId"     : "${vo.dscsId}",
		"stdId"  	  : stdId,
		"profMemo"    : $("#profMemo").val(),
	};
	
	if(confirm('<spring:message code='forum.alert.memo.confirm' />')) { // 메모를 저장하시겠습니까?
		/*ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				alert("<spring:message code='forum.alert.memo.insert' />"); // 메모 저장이 완료되었습니다.
			} else {
				alert(data.message);
			}
		}, function(xhr, status, error) {
			alert("<spring:message code='forum.alert.memo.error' />");// 메모 저장 중 에러가 발생하였습니다.
		}, true);*/
		// TODO : 26.4.3 : 퍼블리싱 완료 후 common_new.jsp inclue 후 ajaxCall 로 처리
		$.ajax({
			url 	 : url,
			async	 : false,
			type 	 : "POST",
			data 	   : data,
			beforeSend: function () {
				// TODO : 26.4.3 : 퍼블리싱 완료 후 common_new.jsp inclue 후 ajaxCall 로 처리
				// UiComm.showLoading(true);
			}
		}).done(function(data) {
			// TODO : 26.4.3 : 퍼블리싱 완료 후 common_new.jsp inclue 후 ajaxCall 로 처리
			// UiComm.showLoading(false);
			if (data.result > 0) {
				alert("<spring:message code='forum.alert.memo.insert' />"); // 메모 저장이 완료되었습니다.
			} else {
				alert(data.message || "<spring:message code='fail.common.msg'/>");
			}
		}).fail(function() {
			// TODO : 26.4.3 : 퍼블리싱 완료 후 common_new.jsp inclue 후 ajaxCall 로 처리
			// UiComm.showLoading(false);
			//UiComm.showMessage("<spring:message code='fail.common.msg'/>","error");
			alert("<spring:message code='fail.common.msg'/>");
		});
	}
}

// 참여형 일괄평가
function partiScore() {
	if(window.confirm(`<spring:message code="forum.confirm.parti.score" />`)) {/* 기존 점수는 초기화되고\r\n토론 참여글 등록 수강생은 100점,\r\n미등록 수강생과 댓글만 작성한 수강생은 0점 처리됩니다.\r\n처리하시겠습니까? */
		var url = "/forum2/forumLect/participateScore.do";
		
		var data = {
			"dscsId" : "${vo.dscsId}",
			"sbjctId" : "${vo.sbjctId}",
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				alert("<spring:message code='forum.alert.evalctgr.participate.all' />"); // 참여형 일괄평가가 완료되었습니다.
				getEzgTitle();
				getJoinUserOrTeamSearchView();
				getJoinUserOrTeamList();
			} else {
				alert(data.message);
			}
		}, function(xhr, status, error) {
			alert("<spring:message code='forum.common.error' />"); // 오류가 발생했습니다!
		}, true);
	}
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

function closeFileSelect() {
	fdbkFilePopClose();
}
</script>

<body class="modal-page EG-grader">
<input type="hidden" id="ezgSbjctId" name="sbjctId" value="${vo.sbjctId}" />
<input type="hidden" id="ezgDscsId" name="dscsId" value="${vo.dscsId}" />
<input type="hidden" id="evalScoreBlockEvalCd" name="evalCd" />
	<div id="wrap" class="pusher <%=SessionInfo.getThemeMode(request)%>">
		<div class="header-title EG-type">
			<div class="center-text" id="ezgTitle">
			</div>
			<div class="flex-section">
				<div class="group-right">
					<a href="javascript:window.parent.onCloseEzGraderPop();" class="ui button"><spring:message code="forum_ezg.button.exit" /></a><!-- 나가기 -->
				</div>
			</div>
		</div>

		<div id="context">
			<div class="ui form">
				<div class="EG-layout">
					<!-- 왼쪽 영역 -->
					<div class="stu-list-box">
						<div id="joinuserOrTeamSearchBlock" class="flex-item gap4 mb10">
						</div>
						<div class="ui cards" id="rubric_card">
						</div>
					</div>
					<!-- 왼쪽 영역 -->

					<!-- 중앙 영역 -->
					<div class="chat-viewer">
						<div class="scrollArea" id="forumContBlock" >
						</div>
					</div>
					<!-- 중앙 영역 -->

					<!-- 오른쪽 영역 -->
					<div class="info-section">
						<div class="scrollArea pr10">
							<div class="element" style="display:none" id="noSelectUserBlock">
								<div class="ui small error message">
									<i class="info circle icon"></i>
									<spring:message code="forum_ezg.label.noselect_user" /><!-- 평가 대상자를 선택하시기 바랍니다. -->
								</div>
							</div>
							<div class="element" id="totalScoreInputBlock">
							</div>
							<div class="ui small negative message mt0" id="teamAlert" style="display: none;">
								<p><i class="warning icon"></i><spring:message code="forum_ezg.label.all_team.apply" /></p><!-- 팀 전체에 적용 됩니다. -->
							</div>
								
							<!-- 루브릭 정보 -->
							<!-- <div class="element" id="evalScoreInputBlock">
							</div> -->
							<!-- 루브릭 정보 -->
							
							<div class="element" >
								<!-- 제출자 정보 -->
								<div id="targetUserInfoBlock">
								</div>
								<!-- 제출자 정보 -->
								<!--  -->
								<div id="forumSendInfoBlock">
								</div>
								<!--  -->
								<!-- 피드백, 메모 -->
								<div id="forumFeedbackBlock">
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
									path="/forum/${vo.dscsId}"
									limitCount="1"
									limitSize="1024"
									oneLimitSize="1024"
									listSize="1"
									finishFunc="finishUpload()"
									allowedTypes="*"
									bigSize="false"
									uiMode="simple"
									style="single"
								/>
								<div class="flex1" style="display:inline-block;vertical-align:top">
									<button onclick="closeFileSelect()" class="ui grey small button" style="margin-left:-4px;"><span aria-hidden="true">&times;</span></button>
								</div>
							</div>
						</div>
					</div>
					<!-- 오른쪽 영역 -->
				</div>
				<script>
				// EG-layout asidePush
				function responsive() {
					var width = $(window).width();
					var viewer_height = $('.chat-viewer').height();
					if (width > 1280){
						$('.stu-list-box, .info-section').css('height', 'auto');
				
						$('.slide-left-btn').unbind('click').bind('click', function(e) {
							$(this).parents().find('.stu-list-box').toggleClass('active');
							$(this).find('i').toggleClass('ion-chevron-left ion-chevron-right')
						});
				
						$('.slide-right-btn').unbind('click').bind('click', function(e) {
							$(this).parents().find('.info-section').toggleClass('active');
							$(this).find('i').toggleClass('ion-chevron-right ion-chevron-left')
						});
					} else {
						$('.stu-list-box, .info-section').css('height', viewer_height);
				
						$('.user-btn').unbind('click').bind('click', function(e) {
							$('.info-btn').html('<spring:message code="forum_ezg.button.sender.info" />'); // 제출자 정보 보기
							$('.EG-layout .info-section').removeClass('active');
							$(this).parents().find('.stu-list-box').toggleClass('active');
							$(this).text($(this).text() == '<spring:message code="forum_ezg.button.sender.list" />' ? '<spring:message code="forum_ezg.button.sender.list_colse" />' : '<spring:message code="forum_ezg.button.sender.list" />');
							// 제출자 리스트 보기, 제출자 리스트 닫기, 제출자 리스트 보기
						});
				
						$('.info-btn').unbind('click').bind('click', function(e) {
							$('.user-btn').html('<spring:message code="forum_ezg.button.sender.list" />'); // 제출자 리스트 보기
							$('.EG-layout .stu-list-box').removeClass('active');
							$(this).parents().find('.info-section').toggleClass('active');
							$(this).text($(this).text() == '<spring:message code="forum_ezg.button.sender.info" />' ? '<spring:message code="forum_ezg.button.sender.info_colse" />' : '<spring:message code="forum_ezg.button.sender.info" />');
							// 제출자 정보 보기, 제출자 정보 닫기, 제출자 정보 보기
						});
					}
				};
				$(function() {
//					responsive();
					
					$(window).resize(function() {
//						responsive();
					});
				});
				</script>
			</div>
		</div>

	</div>

	<a href="#0" id="note-btn" class="ui red button note-btn" style="display: none;"><spring:message code="forum_ezg.button.alert.note" /></a><!-- 확인 경고창 -->
	<div id="note-box" class=""><p></p><a id="close"><i class="ion-ios-close-empty"></i></a></div>
	<a href="#0" id="alert-btn" class="ui red button alert-btn" style="display: none;"><spring:message code="forum.common.confirm.pop" /></a><!-- 선택 경고창 -->
	<div id="alert-box" class="warning"><p style="display: inline-block;"></p>
		<a href="#0" id="alertOk" class="ui inverted small button w80 ml20"><spring:message code="forum.common.yes" /></a><!-- 네 -->
		<a href="#0" id="alertNo" class="ui inverted small button w80"><spring:message code="forum.common.no" /></a><!-- 아니오 -->
		<a id="close2"><i class="ion-ios-close-empty"></i></a>
    </div>
<script>
$('iframe').iFrameResize();
window.closeModal = function() {
	$('.modal').modal('hide');
	$("#mutEvalViewIfm").attr("src", "");
};
</script>

</body>
</html>
