<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

<%-- 에디터 --%>
<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>

<script type="text/javascript">
$(document).ready(function() {
	evalCtgrSelect();
	
	if(${not empty forumVo.parExamCd && (forumVo.forumCtgrCd eq 'EXAM' || forumVo.forumCtgrCd eq 'SUBS') }) {
		insStdList();
	}
	
	$("#lessonScheduleId").closest("div").css("z-index", "1000");
});
// 분반 사용 체크
function declsChk(obj) {
	if(obj.checked) {
		if(obj.value == "all") {
			$("input:checkbox[name=crsCreCds]").not(".readonly").prop("checked", true);
		}
	} else {
		if(obj.value == "all") {
			$("input:checkbox[name=crsCreCds]").not(".readonly").prop("checked", false);
		}
		$("input:checkbox[name=allDeclsNo]").prop("checked", false);
	}
	var allLength = $("input:checkbox[name=crsCreCds]").length;
	var chkLength = $("input:checkbox[name=crsCreCds]:checked").length;
	if(allLength == chkLength) {
		$("input:checkbox[name=allDeclsNo]").prop("checked", true);
	}
	
	$("input:checkbox[name=crsCreCds]").each(function(i) {
		if(this.checked) {
			$("#declsNo"+(i+1)).css("display", "");
		} else {
			$("#declsNo"+(i+1)).css("display", "none");
		}
	});
}

// 팀 토론 체크
function teamForumChk() {
	var value = $("input[name=teamForumCfgYn]:checked").val();
	if(value == "Y") {
		$("#teamForumDiv").css("display", "block");
	} else {
		$("#teamForumDiv").css("display", "none");
	}
}

// 지각 제출 사용 체크
function extDivView() {
	var type = $("input[name=periodAfterWriteYn]:checked").val();
	if(type == "Y") {
		$("#periodAfterDiv").css("display", "block");
	} else {
		$("#periodAfterDiv").css("display", "none");
	}
}

// 상호평가 사용 체크
function mutDivView() {
	var type = $("input[name=mutEvalYn]:checked").val();
	if(type == "Y") {
		$("#viewEvalUse").css("display", "block");
	} else {
		$("#viewEvalUse").css("display", "none");
	}
}

//찬반토론설정
function changeProsConsForumCfg() {
	var type = $("input[name=prosConsForum]:checked").val();

	if (type == "Y") {
		$("#prosConsForumDiv").css("display", "block");
		$('input[name=prosConsForumCfg]').val('Y');
	} else {
		$("#prosConsForumDiv").css("display", "none")
		$('input[name=prosConsForumCfg]').val('N');
		$("#prosConsRateOpen").removeAttr("checked");
		$('input[name=prosConsRateOpenYn]').val('N');
		$("#regOpen").removeAttr("checked");
		$('input[name=regOpenYn]').val('N');
		$("#multiAtcl").prop('checked', false);
		$('input[name=multiAtclYn]').val('N');
		$("#prosConsMod").prop('checked', false); 
		$('input[name=prosConsModYn]').val('N');
	}
}

//찬반비율공개
function changeProsConsRateOpenYn() {
	if ($("input[name=prosConsRateOpen]").is(":checked") == true) {
		$('input[name=prosConsRateOpenYn]').val('Y');
	} else {
		$('input[name=prosConsRateOpenYn]').val('N');
	}
}

//작성자비공개설정
function changeRegOpenYn() {
	if ($("input[name=regOpen]").is(":checked") == true) {
		$('input[name=regOpenYn]').val('Y');
	} else {
		$('input[name=regOpenYn]').val('N');
	}
}

// 다른팀 토론내용 읽기설정
function changeOtherTeamViewYn() {
	if ($("input[name=otherTeamView]").is(":checked") == true) {
		$('input[name=otherTeamViewYn]').val('Y');
	} else {
		$('input[name=otherTeamViewYn]').val('N');
	}
}

// 다른팀 댓글작성 여부설정
function changeOtherTeamAplyYn() {
	if ($("input[name=otherTeamAply]").is(":checked") == true) {
		$('input[name=otherTeamAplyYn]').val('Y');
	} else {
		$('input[name=otherTeamAplyYn]').val('N');
	}
}

//의견글 복수 등록
function changeMultiAtclYn() {
	if ($("input[name=multiAtcl]").is(":checked") == true) {
		$('input[name=multiAtclYn]').val('Y');
	} else {
		$('input[name=multiAtclYn]').val('N');
	}
}

//찬반의견 변경
function changeProsConsModYn() {
	if ($("input[name=prosConsMod]").is(":checked") == true) {
		$('input[name=prosConsModYn]').val('Y');
	} else {
		$('input[name=prosConsModYn]').val('N');
	}
}

// 토론등록
function addForum() {
	if(!nullCheck()) {return false;}
	setValue();
	
	var fileUploader = dx5.get("fileUploader");
	$("#uploadFiles").val(fileUploader.getUploadFiles());
	$("#copyFiles").val(fileUploader.getCopyFiles());
	$("#delFileIdStr").val(fileUploader.getDelFileIdStr());
	$("#uploadPath").val("/forum/${forumVo.forumCd}");
	
	var url = "/forum/forumLect/addForum.do";
	var data = $("#forumWriteForm").serialize();

	ajaxCall(url, data, function(data) {
		if (data.result > 0) {
			alert('<spring:message code="common.result.success" />'); // 성공적으로 작업을 완료하였습니다.
			moveListForum();
		} else {
			alert(data.message);
		}
	}, function(xhr, status, error) {
		alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
	}, true);
}

// 토론수정
function editForum() {
	if(!nullCheck()) {return false;}
	setValue();
	
	var fileUploader = dx5.get("fileUploader");
	$("#uploadFiles").val(fileUploader.getUploadFiles());
	$("#copyFiles").val(fileUploader.getCopyFiles());
	$("#delFileIdStr").val(fileUploader.getDelFileIdStr());
	$("#uploadPath").val("/forum/${forumVo.forumCd}");
	
	var url = "/forum/forumLect/editForum.do";
	var data = $("#forumWriteForm").serialize();

	ajaxCall(url, data, function(data) {
		if (data.result > 0) {
			alert('<spring:message code="common.result.success" />'); // 성공적으로 작업을 완료하였습니다.
			moveListForum();
		} else {
			alert(data.message);
		}
	}, function(xhr, status, error) {
		alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
	}, true);
}

//토론 목록페이지 이동
function moveListForum() {
	var url = "/forum/forumLect/Form/forumList.do";
	
	var form = $("<form></form>");
	form.attr("method", "POST");
	form.attr("name", "moveform");
	form.attr("action", url);
	form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${forumVo.crsCreCd}" />'}));
	form.appendTo("body");
	form.submit();
	
	$("form[name='moveform']").remove();
}

// 빈 값 체크
function nullCheck() {
	<spring:message code='forum.label.forum.date' var='forumPeriod'/> // 토론기간
	
	if($.trim($("#forumTitle").val()) == "") {
		alert("<spring:message code='forum.alert.input.forum_title'/>"); // 토론명을 입력하세요.
		return false;
	}
	if(editor.isEmpty() || editor.getTextContent().trim() === "") {
		alert("<spring:message code='forum.alert.input.forum_content'/>"); // 토론 내용을 입력하세요.
		return false;
	}
	if($("#forumStartDttm").val() == "") {
		alert("<spring:message code='common.alert.input.eval_start_date' arguments='${forumPeriod}'/>"); // 토론 시작일을 입력하세요.
		$("#forumStartDttm").focus();
		return false;
	}
	if($("#startHour").val() == " ") {
		alert("<spring:message code='common.alert.input.eval_start_hour' arguments='${forumPeriod}'/>"); // 토론 시작시간을 입력하세요.
		$("#startHour").parent().focus();
		return false;
	}
	if($("#startMin").val() == " ") {
		alert("<spring:message code='common.alert.input.eval_start_min' arguments='${forumPeriod}'/>"); // 토론 시작분을 입력하세요.
		$("#startMin").parent().focus();
		return false;
	}
	if($("#forumEndDttm").val() == "") {
		alert("<spring:message code='common.alert.input.eval_end_date' arguments='${forumPeriod}'/>"); // 토론 종료일을 입력하세요.
		$("#forumEndDttm").focus();
		return false;
	}
	if($("#endHour").val() == " ") {
		alert("<spring:message code='common.alert.input.eval_end_hour' arguments='${forumPeriod}'/>"); // 토론 종료시간을 입력하세요.
		$("#endHour").parent().focus();
		return false;
	}
	if($("#endMin").val() == " ") {
		alert("<spring:message code='common.alert.input.eval_end_min' arguments='${forumPeriod}'/>"); // 토론 종료분을 입력하세요.
		$("#endMin").parent().focus();
		return false;
	}
	if ( ($("#forumStartDttm").val()+$("#startHour").val()+$("#startMin").val()) >
		($("#forumEndDttm").val()+$("#endHour").val()+$("#endMin").val()) ) {
		alert("<spring:message code='common.alert.input.eval_start_end_date' arguments='${forumPeriod}'/>"); // 종료일시를 시작일시 이후로 입력하세요.
		return false;
	}
	if($("input[name=scoreAplyYn]:checked").length == 0) {
		alert("<spring:message code='forum.alert.input.scoreAplyYn'/>"); // 성적 반영 여부를 선택하세요.
		return false;
	}
	if($("input[name=evalCtgr]:checked").length == 0) {
		alert("<spring:message code='forum.alert.input.evalCtgr'/>"); // 평가 방법을 선택하세요.
		return false;
	}
	if($("input[name=periodAfterWriteYn]:checked").val() == "Y") {
		if($("#extEndDttm").val() == "") {
			alert("<spring:message code='resh.alert.ext.end.dt' />"); // 지각 제출 마감일을 입력하세요.
			return false;
		}
		if($("#extEndHour").val() == " ") {
			alert("<spring:message code='resh.alert.ext.end.hh' />"); // 지각 제출 마감 시간을 입력하세요.
			return false;
		}
		if($("#extEndMin").val() == " ") {
			alert("<spring:message code='resh.alert.ext.end.mm' />"); // 지각 제출 마감 분을 입력하세요.
			return false;
		}
		
		var forumEndDttmheck = (($("#forumEndDttm").val() || "") + ($("#endHour").val() || "") + ($("#endMin").val() || "")).replaceAll(".", "");
		var extSendDttmCheck = (($("#extEndDttm").val() || "") + ($("#extEndHour").val() || "") + ($("#extEndMin").val() || "")).replaceAll(".", "");
		
		if(forumEndDttmheck.length == 12 && extSendDttmCheck.length == 12) {
			if(forumEndDttmheck >= extSendDttmCheck) {
				alert("<spring:message code='forum.alert.invalid.ext.send.dttm' />"); // 지각제출 종료일은 과제 종료일보다 크게 입력하세요.
				return false;
			}
		}
	}
	
	if($("input[name=mutEvalYn]:checked").val() == "Y") {
		var evalStartDttmheck = (($("#evalStartDttmText").val() || "") + ($("#evalStartHour").val() || "") + ($("#evalStartMin").val() || "")).replaceAll(".", "");
		var evalEndDttmheck = (($("#evalEndDttmText").val() || "") + ($("#evalEndHour").val() || "") + ($("#evalEndMin").val() || "")).replaceAll(".", "");
	
		if(!evalStartDttmheck || evalStartDttmheck.length != 12) {
			alert("<spring:message code='forum.alert.input.mut_eval_start_date' />"); // 상호평가 시작일을 입력하세요.
			return false;
		}
		
		if(!evalEndDttmheck || evalEndDttmheck.length != 12) {
			alert("<spring:message code='forum.alert.input.mut_eval_end_date' />"); // 상호평가 종료일을 입력하세요.
			return false;
		}
	}
	
	return true;
}

// 값 채우기
function setValue() {
	var forumContents = editor.getPublishingHtml();
	$("#forumArtl").val(forumContents);
	if($("input:checkbox[name=crsCreCds]:checked").length > 0) {
		$("#declsRegYn").val("Y");
	} else {
		$("#declsRegYn").val("N");
	}
	
	// 저장위해 일시값 설정
	$("#forumStartDttm").val($("#forumStartDttm").val().replaceAll('.','-')+ ' ' + $("#startHour").val() + ":" + $("#startMin").val());
	$("#forumEndDttm").val(setDateEndDttm($("#forumEndDttm").val().replaceAll('.','-')+ ' ' + $("#endHour").val() + ":" + $("#endMin").val(), ":"));
	
	if($("input[name=periodAfterWriteYn]:checked").val() == "Y") {
		$("#extEndDttm").val(setDateEndDttm($("#extEndDttm").val().replaceAll('.','-')+ ' ' + $("#extEndHour").val() + ":" + $("#extEndMin").val(), ":"));
	} else {
		$("#extEndDttm").val("");
	}
	
	if($("input[name=mutEvalYn]:checked").val() == "Y") {
		if($("#evalStartDttmText").val()) {
			$("#evalStartDttm").val($("#evalStartDttmText").val().replaceAll('.','-')+ ' ' + $("#evalStartHour").val() + ":" + $("#evalStartMin").val());
		}
		if($("#evalEndDttmText").val()) {
			$("#evalEndDttm").val(setDateEndDttm($("#evalEndDttmText").val().replaceAll('.','-')+ ' ' + $("#evalEndHour").val() + ":" + $("#evalEndMin").val(), ":"));
		}
	} else {
		$("#evalStartDttm").val("");
		$("#evalEndDttm").val("");
	}
	
	if($("#evalRsltOpenYnCheck").is(":checked")) {
		$("input[name='evalRsltOpenYn']").val("Y");
	} else {
		$("input[name='evalRsltOpenYn']").val("N");
	}
}

// 이전 토론 가져오기 팝업
function forumCopy() {
	$("#forumCopyForm > input[name='crsCreCd']").val("${forumVo.crsCreCd}");
	$("#forumCopyForm").attr("target", "forumCopyIfm");
    $("#forumCopyForm").attr("action", "/forum/forumLect/Form/forumCopyPop.do");
    $("#forumCopyForm").submit();
    $('#forumCopyPop').modal('show');
}

// 토론 가져오기
function copyForum(forumCd) {
	var url  = "/forum/forumLect/Form/forumCopy.do";
	var data = {
		"forumCd" : forumCd
	};

	ajaxCall(url, data, function(data) {
		if (data.result > 0) {
			var forumVO = data.returnVO;
			// 토론명
			$("#forumTitle").val(forumVO.forumTitle);
			// 토론 내용
			$("button.se-clickable[name=new]").trigger("click"); // 에디터 새문서
			editor.insertHTML(forumVO.forumArtl);
			// 토론 기간
			var forumStartDttm = forumVO.forumStartDttm.substring(0, 4) + '-' + forumVO.forumStartDttm.substring(4, 6) + '-' + forumVO.forumStartDttm.substring(6, 8) + ' ' + forumVO.forumStartDttm.substring(8, 10) + ':' + forumVO.forumStartDttm.substring(10, 12);
			var forumEndDttm   = forumVO.forumEndDttm.substring(0, 4) + '-' + forumVO.forumEndDttm.substring(4, 6) + '-' + forumVO.forumEndDttm.substring(6, 8) + ' ' + forumVO.forumEndDttm.substring(8, 10) + ':' + forumVO.forumEndDttm.substring(10, 12);
			// 성적 반영 여부
			if(forumVO.scoreAplyYn == "Y") {
				$("#scoreAplyY").trigger("click");
			} else {
				$("#scoreAplyN").trigger("click");
			}
			// 평가 방법
			if(forumVO.evalCtgr == "R") {
				$("#evalCtgr2").trigger("click");
			} else {
				$("#evalCtgr1").trigger("click");
			}
			
			// 첨부파일
			var fileUploader = dx5.get("fileUploader");
			fileUploader.clearItems();
			
			if (forumVO.fileList.length > 0) {
	    		var oldFiles = [];
	    		var fileSns = new Set();

	    		forumVO.fileList.forEach(function(v, i) {
	    			oldFiles.push({vindex:v.fileId, name:v.fileNm, size:v.fileSize, saveNm:v.fileSaveNm});
					fileSns.add(v.fileSn);
				});
	    		
    			fileUploader.addOldFileList(oldFiles);
    			fileUploader.showResetBtn();
    			$("#fileSns").val(Array.from(fileSns));
			}
			
			$("#uploadPath").val("/forum/${forumVO.forumCd}");
			// 팀 토론 여부
			if(forumVO.teamForumCfgYn == "Y") {
				$("#teamForumCfgYnY").trigger("click");
			} else {
				$("#teamForumCfgYnN").trigger("click");
			}
			/*
			팀 토론 팀 분류선택 처리
			*/
			// 성적 공개 여부
			if(forumVO.scoreOpenYn == "Y") {
				$("#scoreOpenY").trigger("click");
			} else {
				$("#scoreOpenN").trigger("click");
			}
			// 댓글 답변 요청
			if(forumVO.aplyAsnYn == "Y") {
				$("#aplyAsnY").trigger("click");
			} else {
				$("#aplyAsnN").trigger("click");
			}
			// 찬반 토론으로 설정
			if(forumVO.prosConsForumCfg == "Y") {
				$("#prosConsForumCfgY").trigger("click");
				$("input[name=prosConsForumCfg]").val("Y");
				// 찬반 비율 공개
				if(forumVO.prosConsRateOpenYn == "Y") {
					$("input[name=prosConsRateOpen]").prop("checked", true);
					$("input[name=prosConsRateOpenYn]").val("Y");
				} else {
					$("input[name=prosConsRateOpen]").prop("checked", false);
					$("input[name=regOpenYn]").val("N");
				}
				// 작성자 공개
				if(forumVO.regOpenYn == "Y") {
					$("input[name=regOpen]").prop("checked", true);
					$("input[name=prosConsRateOpenYn]").val("Y");
				} else {
					$("input[name=regOpen]").prop("checked", false);
					$("input[name=regOpenYn]").val("N");
				}
				// 의견 글 복수 등록
				if (forumVO.multiAtclYn == 'Y') {
					$('input[name=multiAtcl]').prop('checked', true);-
					$('input[name=multiAtclYn]').val('Y');
				} else {
					$('input[name=multiAtcl]').prop('checked', false);
					$('input[name=multiAtclYn]').val('N');
				}
				// 찬반의견 변경 가능
				if (forumVO.prosConsModYn == 'Y') {
					$('input[name=prosConsMod]').prop('checked', true); 
					$('input[name=prosConsModYn]').val('Y');
				} else {
					$('input[name=prosConsMod]').prop('checked', false);
					$('input[name=prosConsModYn]').val('N');
				}
			} else {
				$("#prosConsForumCfgN").trigger("click");
				$("input[name=prosConsForumCfg]").val("N");
			}
			// 상호 평가
			if(forumVO.mutEvalYn == "Y") {
				$("#mutEvalY").trigger("click");
				$("#evalRsltOpenYnCheck").prop("checked", forumVO.evalRsltOpenYn == "Y" ? true : false);
			} else {
				$("#mutEvalN").trigger("click");
				$("#evalRsltOpenYnCheck").prop("checked", false);
			}
			
			$("#searchTo").val(forumVO.forumCd);
			
			$('.modal').modal('hide'); // 모달창 닫기
		} else {
			alert(data.message);
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='forum.common.error'/>"); // 오류가 발생했습니다!
	}, true);
}

// 목록
function forumList() {
	var url  = "/forum/forumLect/Form/forumList.do";
	var form = $("<form></form>");
	form.attr("method", "POST");
	form.attr("name", "listForm");
	form.attr("action", url);
	form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: "${forumVo.crsCreCd}"}));
	form.appendTo("body");
	form.submit();
}

// 팀 분류 선택 팝업
function teamCtgrSelectPop(id) {
	var url  = "/team/teamHome/teamCtgrSelectPop.do";
	var form = $("<form></form>");
	form.attr("method", "POST");
	form.attr("name", "selectForm");
	form.attr("target", "forumSelectIfm");
	form.attr("action", url);
	form.append($('<input/>', {type: 'hidden', name: 'crsCreCd',   value: "${forumVo.crsCreCd}"}));
	form.append($('<input/>', {type: 'hidden', name: 'searchFrom', value: id}));
	form.appendTo("body");
	form.submit();
	$('#forumSelectPop').modal('show');
}

// 팀 분류 선택
function selectTeam(teamCtgrCd, teamCtgrNm, id) {
	var getTeamCtgrCd = $("#teamCtgrCd").val();
	if(getTeamCtgrCd != "") {
		tmpTeamCtgrCd = getTeamCtgrCd +","+ teamCtgrCd;
		$("#teamCtgrCd").val(tmpTeamCtgrCd);
	} else {
		$("#teamCtgrCd").val(teamCtgrCd);
	}
	var getTeamCtgrNm = $("#teamCtgrNm").val();
	if(getTeamCtgrCd != "") {
		tmpTeamCtgrNm = getTeamCtgrNm +","+ teamCtgrNm;
		$("#teamCtgrNm").val(tmpTeamCtgrNm);
	} else {
		$("#teamCtgrNm").val(teamCtgrNm);
	}
	
	$("#"+id).val(teamCtgrNm);
}

// 평가 방법 선택
function evalCtgrSelect() {
	if($("input[name=evalCtgr]:checked").val() == "R") {
		$("#mutEvalDiv").css("display", "block");
	} else {
		$("#mutEvalDiv").css("display", "none");
	}
}

// 평가 기준 등록 팝업
function mutEvalWritePop(type) {
	var evalCd = "";
	if(type == "edit") {
		evalCd = $("#evalCd").val();
		if(evalCd == "") {
			alert("<spring:message code='forum.alert.evalCd.none'/>"); // 수정할 평가기준이 없습니다.
			return false;
		}
	}
	
	var url  = "/mut/mutPop/mutEvalWritePop.do";
	var form = $("<form></form>");
	form.attr("method", "POST");
	form.attr("name", "writeForm");
	form.attr("target", "mutEvalWriteIfm");
	form.attr("action", url);
//	form.append($('<input/>', {type: 'hidden', name: 'rltnCd',   value: "${forumVo.forumCd}"}));
	form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: "${forumVo.crsCreCd}"}));
	form.append($('<input/>', {type: 'hidden', name: 'evalCd',   value: evalCd}));
	form.appendTo("body");
	form.submit();
	$('#mutEvalWritePop').modal('show');
}

// 평가 기준 등록
function mutEvalWrite(evalCd, evalTitle) {
	$("#evalCd").val(evalCd);
	$("#evalTitle").val(evalTitle);
}

// 평가 기준 삭제
function deleteMut() {
	var evalCd = $("#evalCd").val();
	if(evalCd == "") {
		alert("<spring:message code='forum.alert.evalCd.del'/>"); // 삭제할 평가기준이 없습니다.
		return false;
	}
	
	if(confirm("<spring:message code='forum.button.confirm.del'/>")) { // 정말 삭제하시겠습니까?
		var url = "/mut/mutHome/edtDelYn.do";
		var data = {
			"evalCd" : evalCd,
			"delYn" : "Y"
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				$("#orgEvalCd").val("");
				$("#evalCd").val("");
				$("#evalTitle").val("");
				alert("<spring:message code='forum.alert.del_success'/>"); // 삭제에 성공하였습니다.
			} else {
				alert(data.message);
			}
		}, function(xhr, status, error) {
			alert("<spring:message code='forum.common.error'/>"); // 오류가 발생했습니다!
		}, true);
	}
}

// 저장 확인
function saveConfirm() {
	var fileUploader = dx5.get("fileUploader");
	// 파일이 있으면 업로드 시작
	if (fileUploader.getFileCount() > 0) {
		fileUploader.startUpload();
	}
	else {
		// 저장 호출
		if(${mode eq 'E'} == true) {
			editForum();
		} else {
			addForum();
		}
	}
}

// 파일 업로드 완료
function finishUpload() {
	var fileUploader = dx5.get("fileUploader");
	var url = "/file/fileHome/saveFileInfo.do";
	var data = {
		"uploadFiles" : fileUploader.getUploadFiles(),
		"copyFiles"   : fileUploader.getCopyFiles(),
		"uploadPath"  : fileUploader.getUploadPath()
	};
	
	ajaxCall(url, data, function(data) {
		if(data.result > 0) {
			if(${empty forumVo.forumCd} == true) {
				addForum();
			} else {
				editForum();
			}
		} else {
			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	});
}

//대체평가 대상자 설정 팝업
function examInsTargetPop(examCd) {
	var endDate = new Date("${fn:substring(forumVo.parExamEndDttm, 0, 4)}", parseInt("${fn:substring(forumVo.parExamEndDttm, 4, 6)}") -2, "${fn:substring(forumVo.parExamEndDttm, 6, 8)}");
	endDate.setDate(endDate.getDate()+1);
	var year = endDate.getFullYear();
	var month = (""+endDate.getMonth()).length == 1 ? "0" + endDate.getMonth() : endDate.getMonth();
	var day = endDate.getDate();
	var date = year + "" + month + "" + day + "07";
	if(date > "${fn:substring(today, 0, 10)}") {
		alert("<spring:message code='exam.alert.exam.applicate.not.date' />");/* 실시간시험일 익일 7시 이후 설정가능합니다. */
	} else {
		var kvArr = [];
		kvArr.push({'key' : 'examCd', 	'val' : examCd});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${forumVo.crsCreCd}"});
		
		submitForm("/exam/examInsTargetPop.do", "examPopIfm", "examInsTarget", kvArr);
	}
}

//대체평가 대상자 선택 취소
function examInsTargetCancel(examCd) {
	var stdNos = "";
	$("#stdTbody input[name=evalChk]:checked").each(function(i, v) {
		if(i > 0) stdNos += ",";
		stdNos += $(v).attr("data-stdNo");
	});
	
	if(stdNos == "") {
		alert("<spring:message code='common.alert.select.student' />");/* 학습자를 선택하세요. */
		return false;
	}
	
	var url  = "/exam/insTargetCancelByStdNos.do";
	var data = {
		"examCd"  : "${forumVo.parExamCd}",
		"stdNos"   : stdNos
	};

	ajaxCall(url, data, function(data) {
		if (data.result > 0) {
			alert("<spring:message code='exam.alert.delete' />");/* 정상 삭제 되었습니다. */
			insStdList();
        } else {
         	alert(data.message);
        }
	}, function(xhr, status, error) {
        /* 삭제 중 에러가 발생하였습니다. */
        alert("<spring:message code='exam.error.delete' />");
	}, true);
}

// 대체평가 대상자 목록
function insStdList() {
	var url  = "/exam/listInsTraget.do";
	var data = {
		"examCd"     : "${forumVo.parExamCd}",
		"crsCreCd"   : '${forumVo.crsCreCd}',
		"searchType" : "submit"
	};

	ajaxCall(url, data, function(data) {
		if (data.result > 0) {
			var returnList = data.returnList || [];
			var html = "";
			
			if(returnList.length > 0) {
				returnList.forEach(function(v, i) {
					var absentNm = v.absentNm;
					if(v.absentNm == "APPROVE") absentNm = "<spring:message code='exam.label.approve' />";/* 승인 */
					if(v.absentNm == "APPLICATE") absentNm = "<spring:message code='exam.label.applicate' />";/* 신청 */
					if(v.absentNm == "RAPPLICATE") absentNm = "<spring:message code='exam.label.rapplicate' />";/* 재신청 */
					if(v.absentNm == "COMPANION") absentNm = "<spring:message code='exam.label.companion' />";/* 반려 */
					html += "<tr>";
					html += "	<td class='tc'>";
					html += "		<div class='ui checkbox'>";
					html += "			<input type='checkbox' name='evalChk' id='evalChk"+i+"' data-stdNo='"+v.stdNo+"' user_id='"+v.userId+"' user_nm='"+v.userNm+"' mobile='"+v.mobileNo+"' email='"+v.email+"' onchange='checkStd(this)'>";
					html += "			<label class='toggle_btn' for='evalChk"+i+"'></label>";
					html += "		</div>";
					html += "	</td>";
					html += "	<td>"+v.lineNo+"</td>";
					html += "	<td>"+v.deptNm+"</td>";
					html += "	<td>"+v.userId+"</td>";
					html += "	<td>"+v.userNm+"</td>";
					html += "	<td>"+v.stareYn+"</td>";
					html += "	<td>"+v.absentYn+"</td>";
					html += "	<td>"+absentNm+"</td>";
					html += "	<td><button type='button' class='ui basic small button' onclick='removeReStare(\""+v.stdNo+"\")'>삭제</button></td>";
					html += "</tr>";
				});
			}
			
			$("#stdTbody").empty().html(html);
			$("#stdTable").footable();
        } else {
         	alert(data.message);
        }
	}, function(xhr, status, error) {
        /* 리스트 조회 중 에러가 발생하였습니다. */
        alert("<spring:message code='exam.error.list' />");
	}, true);
}

// 대체평가 대상자 삭제
function removeReStare(stdNo) {
	var url  = "/exam/insTargetCancel.do";
	var data = {
		"examCd"  : "${forumVo.parExamCd}",
		"stdNo"   : stdNo
	};

	ajaxCall(url, data, function(data) {
		if (data.result > 0) {
			alert("<spring:message code='exam.alert.delete' />");/* 정상 삭제 되었습니다. */
			insStdList();
        } else {
         	alert(data.message);
        }
	}, function(xhr, status, error) {
        /* 삭제 중 에러가 발생하였습니다. */
        alert("<spring:message code='exam.error.delete' />");
	}, true);
}

// 체크박스
function checkStd(obj) {
	if(obj.value == "all") {
		$("input[name=evalChk]").prop("checked", obj.checked);
	} else {
		$("#evalChkAll").prop("checked", $("input[name=evalChk]").length == $("input[name=evalChk]:checked").length);
	}
}

// 메세지 보내기
function sendMsg(type) {
	var rcvUserInfoStr = "";
	var sendCnt = 0;
	
	$.each($('#stdTbody').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
		sendCnt++;
		if (sendCnt > 1) rcvUserInfoStr += "|";
		rcvUserInfoStr += $(this).attr("user_id");
		rcvUserInfoStr += ";" + $(this).attr("user_nm"); 
		rcvUserInfoStr += ";" + $(this).attr("mobile");
		rcvUserInfoStr += ";" + $(this).attr("email"); 
	});
	
	if (sendCnt == 0) {
		/* 메시지 발송 대상자를 선택하세요. */
		alert("<spring:message code='common.alert.sysmsg.select_user'/>");
		return;
	}
	
    window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");

    var form = document.alarmForm;
    form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
    form.target = "msgWindow";
    form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
    form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
    form.submit();
}

/**
 * 날짜선택/시간선택/분선택 calendar 설정
 */
function initCalendar() {
	$(".ui.calendar").each(function(index, item){
		let dateVal = $(item).attr("dateval");
		let hour = " ";
		let min = " ";
		
		if (dateVal != undefined && dateVal != null && dateVal != "") {
			dateVal = dateVal.replace("-","").replace(".","").replace(" ","").replace(":","");
			
			if (dateVal.length >= 10) {
				hour = dateVal.substr(8,2);
			}
			
			if (dateVal.length >= 12) {
				min = dateVal.substr(10,2);
			}
			
			$(item).find("input[type=text]").val(dateVal.substr(0,4)+"."+dateVal.substr(4,2)+"."+dateVal.substr(6,2));
		}
		
		let opt = {
			type: 'date',
	        formatter: {
	            date: function (date, settings) {
	               if (!date) return '';
	               let day = date.getDate();
	               let month = settings.text.monthsShort[date.getMonth()];
	               let year = date.getFullYear();
	               return year + '.' + (month<10 ? '0'+month : month) + '.' + (day<10 ? '0'+day : day);
	            }
			}
		}
		
		let range = $(item).attr("range");
		if (range !== undefined) {
			let ranges = range.split(",");
			opt[ranges[0]] = $("#"+ranges[1]);
		}
		
		$(item).calendar(opt);

		// 시간선택 select 설정
		let calHour = $(item).parent().find("select[caltype='hour']");
		if (calHour.length > 0) {
			for (let i=0; i<=23; i++) {
				let val = i<10 ? '0'+i : i;
				
				if (i == 0 && $(calHour).find("option[value=' ']").length == 0) {
					$(calHour).append($("<option value=' '>시</option>"));
				}
				
				if ($(calHour).find("option[value='"+val+"']").length == 0) {
					$(calHour).append($("<option value='"+val+"'>"+val+"</option>"));
				}
			}
			$(calHour).val(hour).prop("selected", true);
		}
		
		// 분선택 select 설정
		let calMin = $(item).parent().find("select[caltype='min']");
		if (calMin.length > 0) {
			for (let i=0; i<=55; i+=5) {
				let val = i<10 ? '0'+i : i;
				
				if (i == 0 && $(calMin).find("option[value=' ']").length == 0) {
					$(calMin).append($("<option value=' '>분</option>"));
				}
				
				if ($(calMin).find("option[value='"+val+"']").length == 0) {
					$(calMin).append($("<option value='"+val+"'>"+val+"</option>"));
				}
			}
			$(calMin).append($("<option value='59'>59</option>"));
			$(calMin).val(min).prop("selected", true);
		}
	});
	
	$('.ui.dropdown').dropdown();
}
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
<form id="forumCopyForm" name="forumCopyForm" action="" method="POST">
	<input type="hidden" name="crsCreCd" value="" />
</form>
    <div id="wrap" class="pusher">
    	<%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>
    	
        <div id="container">
            <!-- class_top 인클루드  -->
        	<%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>
            
            <!-- 본문 content 부분 -->
            <div class="content stu_section">
		        <%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
		        
                <div class="ui form">
                    <div class="layout2">
                    
                        <div id="info-item-box"> <!--  class="ui sticky" -->
                        	<script>
							$(document).ready(function () {
                                <c:choose>
									<c:when test="${empty forumVo.forumCd}">
										var loc2 = "<spring:message code="forum.button.reg"/>"; // 등록
									</c:when>
									<c:otherwise>
										var loc2 = "<spring:message code="forum.button.mod"/>"; // 수정
									</c:otherwise>
								</c:choose>
							
								// set location
								setLocationBar("<spring:message code='forum.label.forum'/>", loc2); // 토론
							});
							</script>
                        
                            <h2 class="page-title flex-item flex-wrap gap4 columngap16">
                               <spring:message code='forum.label.forum'/><!-- 토론 -->
                            </h2>
                            <div class="button-area">
			                    <c:choose>
			                    	<c:when test="${mode eq 'E'}">
			                    		<a href="javascript:void(0)" class="ui blue button" onclick="saveConfirm();return false;"><spring:message code="forum.button.save"/><!-- 저장 --></a>
			                    	</c:when>
			                    	<c:otherwise>
				                    	<a href="javascript:void(0)" class="ui blue button" onclick="saveConfirm();return false;"><spring:message code="forum.button.save"/><!-- 저장 --></a>
				                    	<a href="javascript:void(0)" class="ui basic button" onclick="forumCopy()"><spring:message code='forum.button.copy'/><!-- 이전 토론 가져오기 --></a>
			                    	</c:otherwise>
			                    </c:choose>
		                        <a href="javascript:void(0)" class="ui basic button" onclick="forumList()"><spring:message code='forum.label.list'/><!-- 목록 --></a>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col">

                                <!-- 토론 등록 -->
                                <form name="forumWriteForm" id="forumWriteForm" action="" method="POST">
                                    <c:choose>
                                        <c:when test="${mode eq 'E'}">
                                            <c:set var="path" value="/forum/${forumVo.forumCd }" />
                                        <input type="hidden" id="forumCd" name="forumCd" value="${forumVo.forumCd}" />
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="path" value="/forum" />
                                        <input type="hidden" id="forumCd" name="forumCd" value="" />
                                        </c:otherwise>
                                    </c:choose>
                                    <input type="hidden" id="crsCreCd" name="crsCreCd" value="${forumVo.crsCreCd}"/>
                                    <input type="hidden" id="crsCd" name="crsCd" value=""/>
                                    <input type="hidden" id="userId" name="userId" value="${userId}"/>
                                    <input type="hidden" id="userName" name="userName" value="${userName}"/>
                                    <input type="hidden" id="teamCtgrCd" name="teamCtgrCd" value="">
                                    <input type="hidden" id="teamCtgrNm" name="teamCtgrNm" value="">
                                    <input type="hidden" name="repoCd" value="FORUM" />
                                    <input type="hidden" name="uploadFiles" id="uploadFiles" value="" />
                                    <input type="hidden" name="copyFiles" id="copyFiles" value="" />
                                    <input type="hidden" name="delFileIdStr" id="delFileIdStr" value="" />
                                    <input type="hidden" name="uploadPath" id="uploadPath" value="${path}" />
                                    <input type="hidden" name="fileSns" id="fileSns" value="" />
                                    <input type="hidden" name="tabCd" value=""/>
                                    <input type="hidden" name="declsRegYn" id="declsRegYn" />
                                    <input type="hidden" name="evalStartDttm" id="evalStartDttm" />
                                    <input type="hidden" name="evalEndDttm" id="evalEndDttm" />
                                    <input type="hidden" name="searchTo" id="searchTo" value="" />
                                    
                                    <div class="ui segment">
                                        <div class="ui form">

                                            <ul class="tbl border-top-grey">
                                            	<li>
					                                <dl>
					                                    <dt>
					                                    	<label for="lessonScheduleId">
					                                    		<spring:message code="common.week"/><!-- 주차 -->
					                                    	</label>
					                                    </dt>
					                                    <dd>
				                                            <select class="ui dropdown w300" id="lessonScheduleId" name="lessonScheduleId">
																<option value="DEFALUT"><spring:message code="common.week"/><!-- 주차 --><spring:message code="common.button.choice"/><!-- 선택 --></option>
																<c:forEach var="item" items="${lessonScheduleList}" varStatus="status">
																	<option value="${item.lessonScheduleId}" 
																		<c:choose>
																			<c:when test="${mode eq 'E'}">
																				<c:if test="${forumVo.lessonScheduleId eq item.lessonScheduleId}">selected</c:if>
																			</c:when>
																			<c:otherwise>
																				<c:if test="${lessonScheduleId eq item.lessonScheduleId}">selected</c:if>
																			</c:otherwise>
																		</c:choose>
																	>${item.lessonScheduleNm}</option>
																</c:forEach>
															</select>
					                                    </dd>
					                                </dl>
					                            </li>
                                                <li>
                                                    <dl>
                                                        <dt><label for="forumTitle" class="req"><spring:message code='forum.label.forum.title'/><!-- 토론명 --></label></dt>
                                                        <dd>
                                                            <div class="ui fluid input">
                                                                <input type="text" id="forumTitle" name="forumTitle" value="${forumVo.forumTitle}">
                                                            </div>
                                                        </dd>
                                                    </dl>
                                                </li>
                                                <li>
                                                    <dl>
                                                        <dt><label for="forumArtl" class="req"><spring:message code='forum.label.forum.artl'/><!-- 토론 내용 --></label></dt>
                                                        <dd style="height:400px">
                                                            <div style="height:100%">
                                                                <textarea name="forumArtl" id="forumArtl">${forumVo.forumArtl}</textarea>
                                                                <script>
                                                                // html 에디터 생성
                                                                var editor = HtmlEditor('forumArtl', THEME_MODE, '${path}');
                                                                </script>
                                                            </div>
                                                        </dd>
                                                    </dl>
                                                </li>
                                                <c:if test="${empty forumVo.forumCd}">
                                                <li>
                                                    <dl>
                                                        <dt><label><spring:message code='forum.label.decls.add'/><!-- 분반 일괄 등록 --></label></dt>
                                                        <dd>
                                                            <div class="equal width fields mb0">
                                                                <div class="fields">
                                                                    <div class="field">
                                                                        <div class="ui checkbox">
                                                                            <input type="checkbox" id="allDecls" name="allDeclsNo" value="all" tabindex="0" class="hidden" onchange="declsChk(this)">
                                                                            <label class="toggle_btn" for="allDecls"><spring:message code='forum.common.search.all'/><!-- 전체 --></label>
                                                                        </div>
                                                                    </div>
                                                                    <c:forEach var="list" items="${declsList}">
                                                                        <div class="field">
                                                                            <div class="ui checkbox">
                                                                               <input type="checkbox"
                                                                                name="crsCreCds" id="decls_${list.declsNo}"
                                                                                value="${list.crsCreCd}"
                                                                                data-decls="${list.declsNo}"
                                                                                ${list.crsCreCd eq forumVo.crsCreCd ? 'checked readonly' : ''}
                                                                                ${list.crsCreCd eq forumVo.crsCreCd ? 'class="readonly"' : ''}
                                                                                onchange="declsChk(this)">
                                                                               <label class="toggle_btn" for="decls_${list.declsNo}">${list.declsNo}<spring:message code='forum.label.decls.name'/><!-- 반 --></label>
                                                                            </div>
                                                                        </div>
                                                                    </c:forEach>
                                                                </div>
                                                            </div>
                                                        </dd>
                                                    </dl>
                                                </li>
                                                </c:if>
                                                <li>
                                                    <dl>
                                                        <dt><label for="dateLabel" class="req"><spring:message code='forum.label.forum.date'/><!-- 토론기간 --> </label></dt>
                                                        <dd>

                                                            <div class="fields gap4">
                                                                <div class="field flex">
                                                                   <!-- 시작일시 -->
                                                                   <c:choose>
                                                                       <c:when test="${empty forumVo.forumStartDttm}">
                                                                           <!-- 값이 없을 때 시작일은 00시 00분, 종료일은 23시 55분 으로 초기화 -->
                                                                           <c:set var="now" value="<%=new java.util.Date()%>" />
                                                                           <c:set var="startDttm"><fmt:formatDate value="${now}" pattern="yyyyMMdd000000" /></c:set>
                                                                           <c:set var="endDttm"><fmt:formatDate value="${now}" pattern="yyyyMMdd235959" /></c:set>
                                                                       </c:when>
                                                                       <c:otherwise>
                                                                           <c:set var="startDttm" value="${forumVo.forumStartDttm}" />
                                                                           <c:set var="endDttm" value="${forumVo.forumEndDttm}" />
                                                                       </c:otherwise>
                                                                   </c:choose>
                                                                   <uiex:ui-calendar dateId="forumStartDttm" hourId="startHour" minId="startMin" rangeType="start" rangeTarget="" value="${startDttm}"/>
                                                                </div>
                                                                <div class="field p0 flex-item desktop-elem">~</div>
                                                                <div class="field flex">
                                                                   <!-- 종료일시 -->
                                                                   <uiex:ui-calendar dateId="forumEndDttm" hourId="endHour" minId="endMin" rangeType="end" rangeTarget="forumStartDttm" value="${endDttm}"/>
                                                                </div>
                                                            </div>
                                                        </dd>
                                                    </dl>
                                                </li>
                                                <li>
                                                    <dl>
                                                        <dt><label class="req"><spring:message code='forum.label.scoreAplyYn'/><!-- 성적 반영 --></label></dt>
                                                        <dd>
                                                            <div class="fields">
                                                                <div class="field">
                                                                    <div class="ui radio checkbox">
                                                                        <input type="radio" id="scoreAplyY" name="scoreAplyYn" value="Y" tabindex="0" class="hidden" ${forumVo.scoreAplyYn eq 'Y' || empty forumVo.scoreAplyYn ? ' checked' : ''}>
                                                                        <label for="scoreAplyY"><spring:message code='forum.common.yes'/><!-- 예 --></label>
                                                                    </div>
                                                                </div>
                                                                <div class="field">
                                                                    <div class="ui radio checkbox">
                                                                        <input type="radio" id="scoreAplyN" name="scoreAplyYn" value="N" tabindex="0" class="hidden" ${forumVo.scoreAplyYn eq 'N' ? ' checked' : ''}>
                                                                        <label for="scoreAplyN"><spring:message code='forum.common.no'/><!-- 아니오 --></label>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            
                                                        </dd>
                                                    </dl>
                                                </li>
                                                <li>
                                                    <dl>
                                                        <dt><label><spring:message code='forum.label.scoreOpenYn'/><!-- 성적 공개 --></label></dt>
                                                        <dd>
                                                            <div class="fields">
                                                                <div class="field">
                                                                    <div class="ui radio checkbox">
                                                                        <input type="radio" id="scoreOpenY" name="scoreOpenYn" value="Y" tabindex="0" class="hidden" ${forumVo.scoreOpenYn eq 'Y' ? ' checked' : ''}>
                                                                        <label for="scoreOpenY"><spring:message code='forum.common.yes'/><!-- 예 --></label>
                                                                    </div>
                                                                </div>
                                                                <div class="field">
                                                                    <div class="ui radio checkbox">
                                                                        <input type="radio" id="scoreOpenN" name="scoreOpenYn" value="N" tabindex="0" class="hidden" ${forumVo.scoreOpenYn eq 'N' || empty forumVo.scoreOpenYn ? ' checked' : ''}>
                                                                        <label for="scoreOpenN"><spring:message code='forum.common.no'/><!-- 아니오 --></label>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            
                                                        </dd>
                                                    </dl>
                                                </li>
                                                <li>
                                                    <dl>
                                                        <dt><label><spring:message code='forum.label.periodAfterWrite'/><!-- 지각 제출 사용 --></label></dt>
                                                        <dd>
                                                            <div class="fields">
                                                                <div class="field">
                                                                    <div class="ui radio checkbox checked">
                                                                        <input type="radio" id="periodAfterWriteY" name="periodAfterWriteYn" onchange="extDivView()" tabindex="0" class="hidden" value="Y" ${forumVo.periodAfterWriteYn eq 'Y' ? ' checked' : ''}>
                                                                        <label for="periodAfterWriteY"><spring:message code='forum.common.yes'/><!-- 예 --></label>
                                                                    </div>
                                                                </div>
                                                                <div class="field">
                                                                    <div class="ui radio checkbox">
                                                                        <input type="radio" id="periodAfterWriteN" name="periodAfterWriteYn" onchange="extDivView()" tabindex="0" class="hidden" value="N" ${forumVo.periodAfterWriteYn eq 'N' || empty forumVo.periodAfterWriteYn ? ' checked' : ''}>
                                                                        <label for="periodAfterWriteN"><spring:message code='forum.common.no'/><!-- 아니오 --></label>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="ui segment bcLgrey9" id="periodAfterDiv" style="display: ${forumVo.periodAfterWriteYn eq 'Y' ? 'block' : 'none'};">
                                                                <div class="fields align-items-center">
                                                                    <div class="inline field">
                                                                        <label for="extEndDttm"><spring:message code='forum.label.extEndDttm'/><!-- 제출 마감일 --></label>
                                                                    </div>
                                                                    <div class="field fields gap4">
                                                                        <div class="field flex ">
                                                                            <uiex:ui-calendar dateId="extEndDttm" hourId="extEndHour" minId="extEndMin" rangeType="end" rangeTarget="forumEndDttm" value="${forumVo.extEndDttm}"/>
                                                                        </div>
                                                                    </div>
                                                                    <!-- //달력_기간설정_ ui변경_230417 -->
                                                                </div>
                                                            </div>
                                                        </dd>
                                                    </dl>
                                                </li>
                                                <li>
                                                    <dl>
                                                        <dt><label class="req"><spring:message code='forum.label.evalCtgr'/><!-- 평가 방법 --></label></dt>
                                                        <dd>
                                                            <div class="fields">
                                                                <div class="field">
                                                                    <div class="ui radio checkbox">
                                                                        <%-- <input type="radio" name="evalCtgr" id="evalCtgr2" value="R" tabindex="1" onchange="evalCtgrSelect()" class="hidden" ${forumVo.evalCtgr eq 'R' ? ' checked' : ''}> --%>
                                                                        <input type="radio" name="evalCtgr" id="evalCtgr2" value="R" tabindex="1" class="hidden" ${forumVo.evalCtgr eq 'R' || empty forumVo.evalCtgr ? ' checked' : ''}>
                                                                        <label for="evalCtgr2"><spring:message code='forum.label.evalctgr.participate'/><!-- 참여형 --></label>
                                                                    </div>
                                                                </div>
                                                                <div class="field">
                                                                    <div class="ui radio checkbox">
                                                                        <%-- <input type="radio" name="evalCtgr" id="evalCtgr1" value="P" tabindex="0" onchange="evalCtgrSelect()" class="hidden" ${forumVo.evalCtgr eq 'P' || empty forumVo.evalCtgr ? ' checked' : ''}> --%>
                                                                        <input type="radio" name="evalCtgr" id="evalCtgr1" value="P" tabindex="0" class="hidden" ${forumVo.evalCtgr eq 'P' ? ' checked' : ''}>
                                                                        <label for="evalCtgr1"><spring:message code='forum.label.evalctgr.score'/><!-- 점수형 --></label>
                                                                    </div>
                                                                </div>
                                                                <%--
                                                                <div class="field" style="display:none;" id="mutEvalDiv">
                                                                    <div class="ui action input search-box mr5">
                                                                        <input type="hidden" name="orgEvalCd" id="orgEvalCd" value="${forumVo.evalCd}" />
                                                                        <input type="hidden" name="evalCd" id="evalCd" value="${forumVo.evalCd}" />
                                                                        <input type="text" name="evalTitle" id="evalTitle" value="${forumVo.evalTitle}" />
                                                                        <button type="button" class="ui icon button" onclick="mutEvalWritePop('new');" title="<spring:message code='forum.button.reg'/>"><i class="pencil alternate icon"></i></button><!-- 등록 -->
                                                                        <button type="button" class="ui icon button" onclick="mutEvalWritePop('edit');" title="<spring:message code='forum.button.mod'/>"><i class="edit icon"></i></button><!-- 수정 -->
                                                                        <button type="button" class="ui icon button" onclick="deleteMut();" title="<spring:message code='forum.button.del'/>"><i class="trash icon"></i></button><!-- 삭제 -->
                                                                    </div>
                                                                </div>
                                                                --%>
                                                                <div class="field">
                                                                    <c:if test="${forumVo.evalCtgr eq 'R'}">
                                                                    <%--
                                                                    <a href="javascript:void(0)" class="ui blue button" onclick="delForum('${forumVo.forumCd}');"><spring:message code='forum.button.mod'/><!-- 수정 --></a> 
                                                                    --%>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                            <%-- <div class="ui small warning message"><i class="info icon"></i><spring:message code='forum.label.evalctgr.rubric.info'/><!-- 루브릭 선택시 루브릭 설정 팝업이 활성화 됩니다. --></div> --%>
                                                        </dd>
                                                    </dl>
                                                </li>
                                                <li>
                                                    <dl>
                                                        <dd>
                                                            <input type="checkbox" id="otherViewYn" name="otherViewYn" value="Y" tabindex="0" class="hidden"${forumVo.otherViewYn eq 'Y' || empty forumVo.otherViewYn ? " checked" : ""}>
                                                            <spring:message code='forum.label.otherViewYn'/><!-- 본인의 토론글 등록 후 다른 참여글 보기 가능 -->
                                                        </dd>
                                                    </dl>
                                                </li>
                                                <li>
                                                    <dl>
                                                        <dt><label for="contentTextArea"><spring:message code='forum.label.attachFile'/><!-- 첨부파일 --></label></dt>
                                                        <dd>
                                                            <!-- 파일업로더 -->
                                                            <uiex:dextuploader
																id="fileUploader"
																path="${path}"
																limitCount="5"
																limitSize="1024"
																oneLimitSize="1024"
																listSize="3"
																fileList="${fileList}"
																finishFunc="finishUpload()"
																useFileBox="true"
																allowedTypes="*"
																bigSize="false"
															/>
                                                        </dd>
                                                    </dl>
                                                </li>
                                            </ul> 
                                        </div>
                                    </div>
                                    <!-- 추가 기능 -->
                                    <div class="ui styled fluid accordion week_lect_list">
                                        <div class="title">
                                            <div class="title_cont">
                                                <div class="left_cont">
                                                    <div class="lectTit_box">
                                                        <p class="lect_name"><spring:message code='forum.label.additional.function'/><!-- 추가기능 --></p>
                                                    </div>
                                                </div>
                                            </div>
                                            <i class="dropdown icon ml20"></i>
                                        </div>
                                        <div class="content p0">
                                            <div class="ui segment transition visible" style="display: block !important;">
                                                <ul class="tbl border-top-grey">
                                                    <c:if test="${forumVo.forumCtgrCd ne 'SUBS' and forumVo.forumCtgrCd ne 'EXAM'}">
                                                    <li>
                                                        <dl>
                                                            <dt><label for="teamLabel"><spring:message code='forum.label.teamForumYn'/><!-- 팀 토론 --></label></dt>
                                                            <dd>
                                                                <div class="fields">
                                                                    <div class="field">
                                                                        <div class="ui radio checkbox ${forumVo.teamForumCfgYn eq 'Y' ? 'disabled' : ''}">
                                                                            <input type="radio" id="teamForumCfgYnY" name=teamForumCfgYn value="Y" onchange="teamForumChk()" tabindex="1" class="hidden" ${forumVo.teamForumCfgYn eq 'Y' ? ' checked' : ''}>
                                                                            <label for="teamForumCfgYnY"><spring:message code='forum.common.yes'/><!-- 예 --></label>
                                                                        </div>
                                                                    </div>
                                                                    <div class="field">
                                                                        <div class="ui radio checkbox checked ${forumVo.teamForumCfgYn eq 'Y' ? 'disabled' : ''}">
                                                                            <input type="radio" id="teamForumCfgYnN" name="teamForumCfgYn" value="N" onchange="teamForumChk()" tabindex="0" class="hidden" ${forumVo.teamForumCfgYn eq 'N' || empty forumVo.teamForumCfgYn ? ' checked' : ''}>
                                                                            <label for="teamForumCfgYnN"><spring:message code='forum.common.no'/><!-- 아니오 --></label>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="ui segment gap4 bcLgrey9" id="teamForumDiv" style="display: ${forumVo.teamForumCfgYn eq 'Y' ? 'block' : 'none'};">
                                                                    <c:forEach var="list" items="${declsList}" varStatus="status">
                                                                    <div class="ui action labeled fluid input" id="declsNo${status.count}" style="display: ${list.crsCreCd eq forumVo.crsCreCd ? '' : 'none'};"> 
                                                                        <label class="ui basic small label flex-item-center m-w3 m0">${list.declsNo}<spring:message code='forum.label.decls.name'/><!-- 반 --></label>  
                                                                        <input type="text" id="declsTeam${list.declsNo}" name="teamCtgrList" placeholder="<spring:message code='forum.alert.select.team.ctgr'/>" readonly value="${forumVo.teamCtgrNm}"><!-- 팀 분류를 선택해 주세요 -->
                                                                        <a class="ui black button" onclick="teamCtgrSelectPop('declsTeam${list.declsNo}')"><spring:message code='forum.label.teamSelect'/><!-- 팀 분류선택 --></a>
                                                                    </div>
                                                                    </c:forEach>
                                                                    <div class="ui small warning message">
                                                                        <i class="info circle icon"></i><spring:message code='forum.label.teamSelect.warning'/><!-- 팀관리 메뉴에서 팀 생성 후 팀 지정 사용이 가능합니다. -->
                                                                    </div>
                                                                    <div class="fields">
                                                                        <div class="inline field">
                                                                            <label class="mr10" for="otherTeamView"><spring:message code="forum.label.other.team.view" /><!-- 다른팀 토론내용 읽기 --></label>
                                                                            <div class="ui toggle checkbox">
                                                                                <input type="checkbox" id="otherTeamView" name="otherTeamView" onchange="changeOtherTeamViewYn()" ${forumVo.otherTeamViewYn eq 'Y' ? 'checked' : '' }>
                                                                                <input type="hidden" name="otherTeamViewYn" value="${empty forumVo.otherTeamViewYn ? 'N' : forumVo.otherTeamViewYn }" />
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="fields">
                                                                        <div class="inline field">
                                                                            <label class="mr10" for="otherTeamView"><spring:message code="forum.label.other.team.aply" /><!-- 다른팀 토론 댓글 작성여부 --></label>
                                                                            <div class="ui toggle checkbox">
                                                                                <input type="checkbox" id="otherTeamAply" name="otherTeamAply" onchange="changeOtherTeamAplyYn()" ${forumVo.otherTeamAplyYn eq 'Y' ? 'checked' : '' }>
                                                                                <input type="hidden" name="otherTeamAplyYn" value="${empty forumVo.otherTeamAplyYn ? 'N' : forumVo.otherTeamAplyYn }" />
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </dd>
                                                        </dl>
                                                    </li>
                                                    </c:if>
                                                    <li>
                                                        <dl>
                                                            <dt><label for="indLabel"><spring:message code='forum.label.aplyAsnYn'/><!-- 댓글 답변 요청 --></label></dt>
                                                            <dd>
                                                                <div class="fields">
                                                                    <div class="field">
                                                                        <div class="ui radio checkbox checked">
                                                                            <input type="radio" id="aplyAsnY" name="aplyAsnYn" value="Y" tabindex="0" class="hidden" ${forumVo.aplyAsnYn eq 'Y' ? ' checked' : ''}>
                                                                            <label for="aplyAsnY"><spring:message code='forum.common.yes'/><!-- 예 --></label>
                                                                        </div>
                                                                    </div>
                                                                    <div class="field">
                                                                        <div class="ui radio checkbox">
                                                                            <input type="radio" id="aplyAsnN" name="aplyAsnYn" value="N" tabindex="0" class="hidden" ${forumVo.aplyAsnYn eq 'N' || empty forumVo.aplyAsnYn ? ' checked' : ''}>
                                                                            <label for="aplyAsnN"><spring:message code='forum.common.no'/><!-- 아니오 --></label>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </dd>
                                                        </dl>
                                                    </li>
                                                    <li>
                                                        <dl>
                                                            <dt><label><spring:message code='forum.label.prosCons'/><!-- 찬반 토론으로 설정 --></label></dt>
                                                            <dd>
                                                                <div class="fields">
                                                                    <div class="field">
                                                                        <div class="ui radio checkbox">
                                                                            <input type="radio" name="prosConsForum" id="prosConsForumCfgY" value="Y" onchange="changeProsConsForumCfg()" tabindex="1" class="hidden" ${forumVo.prosConsForumCfg eq 'Y' ? ' checked' : ''} ${forumVo.prosConsForumCfg eq 'Y' ? 'readonly' : '' }>
                                                                            <label for="prosConsForumCfgY"><spring:message code='forum.common.yes'/><!-- 예 --></label>
                                                                        </div>
                                                                    </div>
                                                                    <div class="field">
                                                                        <div class="ui radio checkbox">
                                                                            <input type="radio" name="prosConsForum" id="prosConsForumCfgN" value="N" onchange="changeProsConsForumCfg()" tabindex="0" class="hidden" ${forumVo.prosConsForumCfg eq 'N' || empty forumVo.prosConsForumCfg ? ' checked' : ''} ${forumVo.prosConsForumCfg eq 'Y' ? 'readonly' : '' }>
                                                                            <label for="prosConsForumCfgN"><spring:message code='forum.common.no'/><!-- 아니오 --></label>
                                                                        </div>
                                                                    </div>
                                                                    <input type="hidden" name="prosConsForumCfg" value="${forumVo.prosConsForumCfg eq 'N' || empty forumVo.prosConsForumCfg ? 'N' : 'Y'}" />
                                                                </div>
                                                                <div class="ui segment bcLgrey9" id="prosConsForumDiv" style="display:${forumVo.prosConsForumCfg eq 'Y' ? 'block' : 'none'};">
                                                                    <div class="fields">
                                                                        <div class="inline field">
                                                                            <label class="" for="prosConsRateOpen"><spring:message code='forum.label.prosConsRate'/><!-- 찬반 비율 공개 --></label>
                                                                            <div class="ui toggle checkbox">
                                                                                <c:choose>
                                                                                    <c:when test="${forumVo.prosConsRateOpenYn eq 'Y'}">
                                                                                <input type="checkbox" id="prosConsRateOpen" name="prosConsRateOpen" value="Y" onchange="changeProsConsRateOpenYn()" checked>
                                                                                <input type="hidden" name="prosConsRateOpenYn" value="Y" />
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                <input type="checkbox" id="prosConsRateOpen" name="prosConsRateOpen" value="N" onchange="changeProsConsRateOpenYn()">
                                                                                <input type="hidden" name="prosConsRateOpenYn" value="N" />
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="fields">
                                                                        <div class="inline field">
                                                                            <label class="" for="regOpen"><spring:message code='forum.label.regOpen'/><!-- 작성자 공개 --></label>
                                                                            <div class="ui toggle checkbox">
                                                                                <c:choose>
                                                                                    <c:when test="${forumVo.regOpenYn eq 'Y' || empty forumVo.regOpenYn}">
                                                                                <input type="checkbox" id="regOpen" name="regOpen" value="Y" onchange="changeRegOpenYn()" checked>
                                                                                <input type="hidden" name="regOpenYn" value="Y" />
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                <input type="checkbox" id="regOpen" name="regOpen" value="N" onchange="changeRegOpenYn()">
                                                                                <input type="hidden" name="regOpenYn" value="N" />
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </div>
                                                                            
                                                                        </div>
                                                                    </div>
                                                                    <%--
                                                                    <div class="fields">
                                                                        <div class="inline field">
                                                                            <label class="" for="multiAtcl"><spring:message code='forum.label.multiAtcl'/><!-- 의견글 복수 등록 --></label>
                                                                            <div class="ui toggle checkbox">
                                                                                <c:choose>
                                                                                    <c:when test="${forumVo.multiAtclYn eq 'Y' || empty forumVo.multiAtclYn}">
                                                                                <input type="checkbox" id="multiAtcl" name="multiAtcl" value="Y" onchange="changeMultiAtclYn()" checked>
                                                                                <input type="hidden" name="multiAtclYn" value="Y" />
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                <input type="checkbox" id="multiAtcl" name="multiAtcl" value="N" onchange="changeMultiAtclYn()">
                                                                                <input type="hidden" name="multiAtclYn" value="N" />
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </div>
                                                                            
                                                                        </div>
                                                                    </div> 
                                                                    --%>
                                                                    <div class="fields">
                                                                        <div class="inline field">
                                                                            <label class="" for="prosConsMod"><spring:message code='forum.label.prosConsMod'/><!-- 찬반의견 변경 --></label>
                                                                            <div class="ui toggle checkbox">
                                                                                <c:choose>
                                                                                    <c:when test="${forumVo.prosConsModYn eq 'Y' || empty forumVo.prosConsModYn}">
                                                                                <input type="checkbox" id="prosConsMod" name="prosConsMod" value="Y" onchange="changeProsConsModYn()" checked>
                                                                                <input type="hidden" name="prosConsModYn" value="Y" />
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                <input type="checkbox" id="prosConsMod" name="prosConsMod" value="N" onchange="changeProsConsModYn()">
                                                                                <input type="hidden" name="prosConsModYn" value="N" />
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </dd>
                                                        </dl>
                                                    </li>
                                                    <li>
                                                        <dl>
                                                            <dt><label><spring:message code='forum.label.mutEvalYn'/><!-- 상호평가 사용 --></label></dt>
                                                            <dd>
                                                                <div class="fields">
                                                                    <div class="field">
                                                                        <div class="ui radio checkbox">
                                                                            <input type="radio" id="mutEvalY" name="mutEvalYn" onchange="mutDivView()" value="Y" tabindex="0" class="hidden" ${forumVo.mutEvalYn eq 'Y' ? ' checked' : ''}>
                                                                            <label for="mutEvalY"><spring:message code='forum.common.yes'/><!-- 예 --></label>
                                                                        </div>
                                                                    </div>
                                                                    <div class="field">
                                                                        <div class="ui radio checkbox checked">
                                                                        <input type="radio" id="mutEvalN" name="mutEvalYn" onchange="mutDivView()" value="N" tabindex="0" class="hidden" ${forumVo.mutEvalYn eq 'N' || empty forumVo.mutEvalYn ? ' checked' : ''}>
                                                                        <label for="mutEvalN"><spring:message code='forum.common.no'/><!-- 아니오 --></label>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="ui segment bcLgrey9" id="viewEvalUse" style="display: ${forumVo.mutEvalYn eq 'Y' ? 'block' : 'none'};">
                                                                    <div class="fields align-items-center">
                                                                        <div class="field">
                                                                            <label for="a3"><spring:message code='forum.label.eval.date'/><!-- 평가 기간 --></label>
                                                                        </div>
                                                                        <div class="field fields gap4">
                                                                            <div class="field flex ">
                                                                                <uiex:ui-calendar dateId="evalStartDttmText" hourId="evalStartHour" minId="evalStartMin" rangeType="start" rangeTarget="evalEndDttmText" value="${forumVo.evalStartDttm}"/>
                                                                            </div>
                                                                            <div class="field p0 flex-item desktop-elem">~</div>
                                                                            <div class="field flex ">
                                                                                <uiex:ui-calendar dateId="evalEndDttmText" hourId="evalEndHour" minId="evalEndMin" rangeType="end" rangeTarget="evalStartDttmText" value="${forumVo.evalEndDttm}"/>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="fields">
                                                                        <div class="field">
                                                                            <label for="evalRsltOpenYn"><spring:message code='forum.label.result.open'/><!-- 결과 공개 --></label>
                                                                        </div>
                                                                        <div class="field">
                                                                        	<div class='ui toggle checkbox'>
                                                                        		<input type="checkbox" id="evalRsltOpenYnCheck" class="hidden" <c:if test="${forumVo.evalRsltOpenYn eq 'Y'}">checked</c:if> />
                                                                         	</div>
                                                                         	<input type="hidden" name="evalRsltOpenYn" value="${forumVo.evalRsltOpenYn}" />
                                                                        </div>
                                                                    </div>
																</div>
																<div class="ui small warning message"><i class="info circle icon"></i><spring:message code='forum.label.mutEval.warning'/><!-- 상호 평가는 별점 5점으로 진행됩니다. 본인/본인 팀 평가는 불가능합니다. --></div>
                                                            </dd>
                                                        </dl>
                                                    </li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- 추가 기능 -->
                                </form>
                                <!-- 토론 등록 -->
								<div class="option-content mt20">
					                <div class="mla">
								        <c:choose>
								        	<c:when test="${mode eq 'E'}">
								        		<a href="javascript:void(0)" class="ui blue button" onclick="saveConfirm();return false;"><spring:message code="forum.button.save"/><!-- 저장 --></a>
								        	</c:when>
								        	<c:otherwise>
									        	<a href="javascript:void(0)" class="ui blue button" onclick="saveConfirm();return false;"><spring:message code="forum.button.save"/><!-- 저장 --></a>
									        	<a href="javascript:void(0)" class="ui basic button" onclick="forumCopy()"><spring:message code='forum.button.copy'/><!-- 이전 토론 가져오기 --></a>
								        	</c:otherwise>
								        </c:choose>
							            <a href="javascript:void(0)" class="ui basic button" onclick="forumList()"><spring:message code='forum.label.list'/><!-- 목록 --></a>
					                </div>
								</div>
								
								<c:if test="${not empty forumVo.parExamCd && forumVo.forumCtgrCd eq 'SUBS' }">
				                    <div class="option-content mt30">
				                    	<h3 class="sec_head">
				                    		<c:if test="${forumVo.examStareTypeCd eq 'M' }"><spring:message code="exam.label.mid.exam" /><!-- 중간고사 --></c:if>
				                    		<c:if test="${forumVo.examStareTypeCd eq 'L' }"><spring:message code="exam.label.end.exam" /><!-- 기말고사 --></c:if>
				                    		<spring:message code="exam.label.ins.target" /><!-- 대체평가 대상자 -->
				                    	</h3>
				                    	<div class="mla">
				                    		<a href="javascript:sendMsg()" class="ui basic small button"><i class="paper plane outline icon"></i><spring:message code="common.button.message" /></a><!-- 메시지 -->
				                    		<a href="javascript:examInsTargetPop('${forumVo.parExamCd }')" class="ui blue small button"><spring:message code="exam.label.ins.target.set" /></a><!-- 대상자 설정 -->
				                    		<a href="javascript:examInsTargetCancel('${forumVo.parExamCd }')" class="ui blue small button"><spring:message code="exam.label.ins.target.cancel" /></a><!-- 대상자 취소 -->
				                    	</div>
				                    </div>
				                    <table class="table type2" id="stdTable" data-sorting="true" data-paging="false" data-empty="<spring:message code='exam.label.exam.ins.target.none' />" id="examEtcListTable"><!-- '대상자설정' 버튼을 클릭 후 대상자를 설정해주세요. -->
				                    	<thead>
				                    		<tr>
				                    			<th>
				                    				<div class="ui checkbox">
											             <input type="checkbox" name="evalChkAll" id="evalChkAll" value="all" onchange="checkStd(this)">
											             <label class="toggle_btn" for="evalChkAll"></label>
											        </div>
				                    			</th>
				                    			<th><spring:message code="common.number.no" /><!-- NO --></th>
				                    			<th><spring:message code="exam.label.dept" /><!-- 학과 --></th>
				                    			<th><spring:message code="exam.label.user.no" /><!-- 학번 --></th>
				                    			<th><spring:message code="exam.label.user.nm" /><!-- 이름 --></th>
				                    			<th><spring:message code="exam.label.exam" /><!-- 시험 --><spring:message code="exam.label.yes.stare" /><!-- 응시 --></th>
				                    			<th><spring:message code="exam.label.absent" /><!-- 결시원 --><spring:message code="exam.label.submit.y" /><!-- 제출 --></th>
				                    			<th><spring:message code="exam.label.absent" /><!-- 결시원 --><spring:message code="exam.label.approve" /><!-- 승인 --></th>
				                    			<th><spring:message code="exam.label.manage" /><!-- 관리 --></th>
				                    		</tr>
				                    	</thead>
				                    	<tbody id="stdTbody">
				                    	</tbody>
				                    </table>
				                    <div class="option-content">
				                    	<div class="mla">
				                    		<a href="javascript:void(0)" class="ui basic button" onclick="forumList()"><spring:message code='forum.label.list'/><!-- 목록 --></a>
				                    	</div>
				                    </div>
			                    </c:if>
			                    
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 팀지정 모달 -->
                <div class="modal fade" id="forumSelectPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code='forum.label.team.appoint'/>" aria-hidden="true">
                    <div class="modal-dialog modal-lg" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='forum.button.close'/>"><!-- 닫기 -->
                                    <span aria-hidden="true">&times;</span>
                                </button>
                                <h4 class="modal-title"><spring:message code='forum.label.teamSelect'/><!-- 팀 분류 선택 --></h4>
                            </div>
                            <div class="modal-body">
                                <iframe src="" id="forumSelectIfm" name="forumSelectIfm" width="100%" scrolling="no"></iframe>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- 팀지정 모달 -->

                <!-- 이전 토론 가져오기 팝업 -->
                <div class="modal fade" id="forumCopyPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code='forum.button.copy'/>" aria-hidden="false">
                    <div class="modal-dialog modal-lg" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='forum.button.close'/>"><!-- 닫기 -->
                                    <span aria-hidden="true">&times;</span>
                                </button>
                                <h4 class="modal-title"><spring:message code='forum.button.copy'/><!-- 이전 토론 가져오기 --></h4>
                            </div>
                            <div class="modal-body">
                                <iframe src="" id="forumCopyIfm" name="forumCopyIfm" width="100%" scrolling="no"></iframe>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- 이전 토론 가져오기 팝업 -->

                <!-- 평가기준 등록 팝업 -->
                <div class="modal fade" id="mutEvalWritePop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code='forum.label.mutEval'/>" aria-hidden="false">
                    <div class="modal-dialog modal-lg" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='forum.button.close'/>"><!-- 닫기 -->
                                    <span aria-hidden="true">&times;</span>
                                </button>
                                <h4 class="modal-title"><spring:message code='forum.label.mutEval'/><!-- 평가 기준 등록 --></h4>
                            </div>
                            <div class="modal-body">
                                <iframe src="" id="mutEvalWriteIfm" name="mutEvalWriteIfm" width="100%" scrolling="no"></iframe>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- 평가기준 등록 팝업 -->
                <script>
                $('iframe').iFrameResize();
                window.closeModal = function(){
                    $('.modal').modal('hide');
                };
                </script>
                <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
		</div>
	</div>
	<!-- //본문 content 부분 -->
</body>
</html>
