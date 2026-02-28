<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/forum/common/forum_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

<script>
$(document).ready(function() {
	listLoad();
	if("${vo.mutEvalYn}" === "Y") {
		listForumUser(1);
	}

	if("${tab}" == "tab2") {
		$(".listTab > ul > li").removeClass("select")
		$("a[href='#tab2']").parent().addClass("select").trigger("click");
	}
	
	$(".listTab > ul > li > a").on("click", function(e) {
		if($(this).attr("href") == "#tab2") {
			var url = "/logLesson/saveLessonActnHsty.do";
			var data = {
				  actnHstyCd	: "FORUM"
				, actnHstyCts	: "[${vo.forumTitle}] <spring:message code='common.label.forum' /> <spring:message code='asmnt.label.mut.eval' />"
				, crsCreCd		: "${vo.crsCreCd}"
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
		}
	});
	
	btnSetting();
	
	$(".accordion").accordion();
});

function btnSetting() {
	// 작성글이 있을 경우 라디오버튼 및 버튼 세팅
	if("${count}" > 0) {
		$("#atclTypeP").prop('readonly', true);
		$("#atclTypeC").prop('readonly', true);
		$("#atclTypeP").prop('disabled', true);
		$("#atclTypeC").prop('disabled', true);
		$(".btnSave").hide();
	}
}

function listLoad(){
	var url = "/forum/forumHome/myAtclCount.do";
	var data = {
		crsCreCd: "${vo.crsCreCd}",
		forumCd : "${vo.forumCd}"
	};
	
	ajaxCall(url, data, function(data) {
		if(data.result > 0) {
			var returnVO = data.returnVO || {};
			var totalCnt = returnVO.totalCnt || 0;
			
			if(totalCnt > 0) {
				// 의견글 복수
				if("${vo.multiAtclYn}" === "Y") {
					var multiUrl = "/forum/forumHome/atclList.do";
					var multiData = {
						"forumCd" : "${vo.forumCd}",
						"userId" : "${userId}"
					};

					ajaxCall(multiUrl, multiData, function(data) {
						if(data.result > 0) {
							var returnList = data.returnList || [];
							
							if(returnList.length > 0) {
								if(returnList[0].prosConsTypeCd == "P") {
									$("#atclTypeP").prop('readonly', false);
									$("#atclTypeC").prop('readonly', false);
									$("#atclTypeP").prop('disabled', false);
									$("#atclTypeC").prop('disabled', false);
									$("#prosConsTypeCd").val("P"); // 찬성
								} else {
									$("#atclTypeP").prop('readonly', false);
									$("#atclTypeC").prop('readonly', false);
									$("#atclTypeP").prop('disabled', false);
									$("#atclTypeC").prop('disabled', false);
									$("#prosConsTypeCd").val("C"); // 반대
								}
								$(".btnSave").show();
							}
						}
					}, function(xhr, status, error) {
						alert("<spring:message code='forum.common.error'/>"); // 에러가 발생했습니다!
					}, true);
				} else {
					$("#atclTypeP").prop('readonly', true);
					$("#atclTypeC").prop('readonly', true);
					$("#atclTypeP").prop('disabled', true);
					$("#atclTypeC").prop('disabled', true);
					$(".btnSave").hide();
				}
				
				// 찬반 조정
				if("${vo.prosConsModYn}" == "Y") {
					$("#addYn").val("N");
				}
				listForum();
			} else {
				if("${vo.multiAtclYn}" == 'Y'){
					$("#atclTypeP").prop('readonly', false);
					$("#atclTypeC").prop('readonly', false);
					$("#atclTypeP").prop('disabled', false);
					$("#atclTypeC").prop('disabled', false);
					$("#atclTypeP").prop('checked', true);
					$("#prosConsTypeCd").val("P");
				}
				//찬반 조정
				if("${vo.prosConsModYn}" == 'Y'){
					$("#addYn").val("Y");
				}
				listForum();
			}
		} else {
			alert(data.message);
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='forum.common.error'/>"); // 에러가 발생했습니다!
	}, true);
}

function listForum(){
	//토론글 리스트
	$("#list").load("/forum/forumHome/forumStuViewList.do", {
		"forumCd" : "${vo.forumCd}",
		"crsCreCd" : "${vo.crsCreCd}",
		"userId" : "${userId}",
		"userName" : "${userName}"
		
	}, // params
	function() {
		$(".ui.dropdown").dropdown();
		$(".commentlist").toggle();
	});
}

//게시글 찬반 라디오 버튼
function checkedRadio(value){
	if(value == "P"){
		$("#prosConsTypeCd").val("P");
	}else{
		$("#prosConsTypeCd").val("C");
	}
}

// 게시글 수정 버튼
function editAtclBtn(atclSn, rgtrId, prosConsType) {
	var cts = $("#cts_"+ atclSn).text();
	
	if("${userId}" != rgtrId) {
		alert("<spring:message code='forum.alert.not.mod.auth.atcl'/>"); // 수정 권한이 없는 게시글 입니다.
		return false;
	} else {
		$("#atclStatus").val("E");
		$("#atclSn").val(atclSn);
		$("#cts").val(cts);
		$("#cts").focus();
		
		// 찬성 반대 수정 여부
		if("${vo.prosConsModYn}" === "Y") {
			$("#atclTypeP").prop('readonly', false);
			$("#atclTypeC").prop('readonly', false);
			$("#atclTypeP").prop('disabled', false);
			$("#atclTypeC").prop('disabled', false);
		} else {
			$("#atclTypeP").prop('readonly', true);
			$("#atclTypeC").prop('readonly', true);
			$("#atclTypeP").prop('disabled', true);
			$("#atclTypeC").prop('disabled', true);
		}
		$("input:radio[name='atclTypeCd']:radio[value='"+ prosConsType +"']").prop('checked', true); // 선택하기
		$("#prosConsTypeCd").val(prosConsType);
		$(".btnSave").show();
	}
}

// 게시글 등록/수정
function addActl(){
	var prosConsTypeCd = $("#prosConsTypeCd").val();
	var cts = $.trim($("#cts").val());
	var atclStatus = $("#atclStatus").val();

	if(cts == null || cts == ""){
		alert("<spring:message code='forum.alert.input.forum.atcl'/>");//게시글을 입력해주시기 바랍니다.
		return false;
	} else {
		if(atclStatus == 'E') {
			$("#cts").val('');
			var atclSn = $("#atclSn").val();
			
			var url = '/forum/forumHome/Form/editAtcl.do';
			var data = {
				"prosConsTypeCd" : prosConsTypeCd,
				"atclSn" : atclSn,
				"cts" : cts,
				"forumCd" : "${vo.forumCd}",
				"userId" : "${userId}",
				"userName" : "${userName}",
				"crsCreCd" : "${vo.crsCreCd}"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					alert("<spring:message code='forum.alert.edit.forum.atcl_success'/>"); //토론 게시글 수정에 성공하였습니다.
					$("#atclStatus").val('A');
					location.reload();
					listLoad();
				} else {
					alert("<spring:message code='forum.alert.edit.forum.atcl_fail'/>"); //토론 게시글에 수정에 실패하였습니다. 다시 시도해주시기 바랍니다.
					location.reload();
					listLoad();
				}
			}, function(xhr, status, error) {
				/* 에러가 발생했습니다! */
				alert("<spring:message code='fail.common.msg' />");
			}, true);
		} else {
			var addYn = $("#addYn").val();
			if(addYn == "N") {
				alert("<spring:message code='forum.alert.only.mod.forum.atcl'/>");//이미 토론글을 작성하셨습니다. 수정만 가능합니다.
				return false;
			} else {
				$("#cts").val('');
				
				var atclTypeCd = "";
				if("${vo.prosConsForumCfg}" == null || "${vo.prosConsForumCfg}" == ""){
					atclTypeCd = "${vo.forumCtgrCd}";
				}else{
					atclTypeCd = "${vo.forumCtgrCd}" + "_"+ "${vo.prosConsForumCfg}";
				}
				
				var atclOdr = 0;
				
				
				if($("input[name=maxOdr]").val() !=null &&  $("input[name=maxOdr]").val() !="" &&  $("input[name=maxOdr]").val() !="undefined" ){
					atclOdr =	Number($("input[name=maxOdr]").val()) + 1;
				}
				
				var url = '/forum/forumHome/Form/addAtcl.do';
				var data = {
					"prosConsTypeCd" : prosConsTypeCd,
					"atclTypeCd"	: atclTypeCd,
					"cts" : cts,
					"forumCd" : "${vo.forumCd}",
					"userId" : "${userId}",
					"userName" : "${userName}",
					"atclOdr" : atclOdr,
					"crsCreCd" : "${vo.crsCreCd}",
				}
				
				ajaxCall(url, data, function(data) {
					if (data.result > 0) {
						$("#wrap").removeClass('dimmed');
						 $(".form1").sidebar("hide");
						alert("<spring:message code='forum.alert.add.forum.atcl_success'/>"); //토론 게시글 등록에 성공하였습니다.
						location.reload();
						listLoad();
					} else {
						alert("<spring:message code='forum.alert.add.forum.atcl_fail'/>"); //토론 게시글에 등록에 실패하였습니다. 다시 시도해주시기 바랍니다.
						location.reload();
						listLoad();
					}
				}, function(xhr, status, error) {
					/* 에러가 발생했습니다! */
					alert("<spring:message code='fail.common.msg' />");
				}, true);
			}
		}
	}
}

// 게시글 삭제
function delAtcl(atclSn, rgtrId) {
	if("${userId}" != rgtrId) {
		alert("<spring:message code='forum.alert.not.del.auth.atcl'/>"); // 삭제 권한이 없는 게시글 입니다.
		return false;
	} else {
		var result = confirm("<spring:message code='forum.button.confirm.del'/>"); // 정말 삭제하시겠습니까?
		if(!result) { return false; }
		
		var url = '/forum/forumHome/Form/delAtcl.do';
		var data = {
			"atclSn" : atclSn,
			"forumCd" : "${vo.forumCd}",
			"userId" : "${userId}"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				alert("<spring:message code='forum.alert.del.forum.atcl_success'/>"); // 게시글 삭제에 성공하였습니다.
				location.reload()
				listLoad();
			} else {
				alert("<spring:message code='forum.alert.del.forum.atcl_fail'/>"); // 게시글 삭제에 실패하였습니다. 다시 시도해주시기 바랍니다.
				listLoad();
			}
		}, function(xhr, status, error) {
			/* 에러가 발생했습니다! */
			alert("<spring:message code='fail.common.msg' />");
		}, true);
	}
}

//댓글 보기
function cmntView(atclSn,index) {
	if(!$("#cmntOpen"+index).hasClass("on")) {
		$("#cmntOpen"+index).addClass("on").removeClass("off");
		$("#article"+index).css("display", "block");
		$("#cmntOpen"+index).children("i").removeClass("down").addClass("up");
	} else {
		$("#cmntOpen"+index).addClass("off").removeClass("on");
		$("#article"+index).css("display", "none");
		$("#cmntOpen"+index).children("i").removeClass("up").addClass("down");
	}
	$("#article"+index).toggleClass("on");
	$("#article"+index).toggle();
}

// 댓글 작성하기 버튼
function cmntWrite(atclSn,index){
	var btn = "";
	btn += "<li id=\"addBtn"+index+"\">";
	btn += "<a class=\"ui basic grey small button\" href=\"javascript:addCmnt('"+atclSn+"','','"+index+"');\" ><spring:message code='forum.button.reg'/></a>"; //등록
	btn += "</li>";
	$("#editBtn"+index).after(btn);
	$("#editBtn"+index).remove();
	$("#cmntText" + index).val('');
	$("#toggleBox"+ index).toggle();
}
/*
function cmntWrite(atclSn,index){
	if($("#toggleBox"+index ).hasClass("on")) { // 댓글 폼이 off일 때
		console.log("BBB");
		$("#toggleBox"+index ).addClass("off").removeClass("on");
		$("#toggleBox"+index).css("display", "none");
		$("#cmntWrite"+index).children("i").removeClass("up").addClass("down");
	} else { // 댓글 폼이 on일 때
console.log("AAA");
		$("#toggleBox"+index ).addClass("on").removeClass("off");
		$("#toggleBox"+index).css("display", "block");
		$("#cmntWrite"+index).children("i").removeClass("down").addClass("up");
	}
}
*/
// 댓글 등록
function addCmnt(atclSn, parCmntSn, index, i) {
	var ansReqYn = "N";
	var cmntCts = "";
	if(parCmntSn == null || parCmntSn == "") {
		if($("#ansReqYn"+ index).is(":checked") == true) {
			ansReqYn = "Y";
		}
		cmntCts = $("#cmntText"+ index).val();
	} else {
		if($("#ansReqYn"+ index + i).is(":checked") == true) {
			ansReqYn = "Y";
		}
		cmntCts = $("#cmntText"+ index + i).val().trim();
	}
	
	if(cmntCts == null || cmntCts == ""){
		alert("<spring:message code='forum.alert.comment.insert.msg'/>"); // 댓글을 입력하세요.
		$("#toggleBox"+index ).addClass("off").removeClass("on");
	}else{
		$("#cmntText" + index).val('');
		
		var url = '/forum/forumHome/Form/addCmnt.do';
		var data = {
			"ansReqYn" : ansReqYn,
			"atclSn" : atclSn,
			"cmntCts" : cmntCts,
			"parCmntSn" : parCmntSn,
			"forumCd" : "${vo.forumCd}",
			"userId" : "${userId}",
			"userName" : "${userName}",
			"crsCreCd" : "${vo.crsCreCd}"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				alert("<spring:message code='forum.alert.reg_success.reply'/>");// 댓글 등록에 성공하였습니다.
				listLoad();
			} else {
				alert("<spring:message code='forum.alert.reg_fail.reply'/>"); // 댓글 등록에 실패하였습니다. 다시 시도해주시기 바랍니다.
				listLoad();
			}
		}, function(xhr, status, error) {
			/* 에러가 발생했습니다! */
			alert("<spring:message code='fail.common.msg' />");
		}, true);
	}
}

// 댓글 수정 버튼 클릭
function editBtnClick(atclSn,rgtrId,cmntSn,index,i,level, ansReqYn) {
	if(!$("#toggleBox"+index ).hasClass("on")) {
		if(ansReqYn == "Y") {
			$("#ansReqYn"+index).prop("checked", true);
		}
		var btn = "";
		btn += "<li id=\"editBtn"+index+"\">";
		btn += "<a class=\"ui basic grey small button\" href=\"javascript:editCmnt('"+atclSn+"','"+cmntSn+"','"+index+"','"+i+"','"+level+"');\" ><spring:message code='forum.button.mod'/></a>"; // 수정
		btn += "</li>";
		$("#addBtn"+index).after(btn);
		$("#addBtn"+index).remove();

		var cmntCts = $("#cmntCts"+index + i).text();
		$("#cmntText" + index).val(cmntCts);
			
		$("#toggleBox"+index ).addClass("on").removeClass("off");
		$("#toggleBox"+index).css("display", "block");
		$("#cmntWrite"+index).children("i").removeClass("down").addClass("up");
	} else {
		if(ansReqYn == "Y") {
			$("#ansReqYn"+index+i).prop("checked", true);
		}
		var btn = "";
		btn += "<li id=\"addBtn"+index+"\">";
		btn += "<a class=\"ui basic grey small button\" href=\"javascript:addCmnt('"+atclSn+"','','"+index+"','"+i+"','"+level+"');\" ><spring:message code='forum.button.reg'/></a>"; // 등록
		btn += "</li>";
		$("#editBtn"+index).after(btn);
		$("#editBtn"+index).remove();
		
		$("#toggleBox"+index ).addClass("off").removeClass("on");
		$("#toggleBox"+index).css("display", "none");
		$("#cmntWrite"+index).children("i").removeClass("up").addClass("down");
	} 
}

// 댓글 수정
function editCmnt(atclSn,cmntSn,index,i,level) {
	var ansReqYn = "N";
	var cmntCts = "";
	if(level == null || level == ''){
		if($("#ansReqYn"+ index + i).is(":checked") == true) {
			ansReqYn = "Y";
		}
		cmntCts= $("#cmntText" + index + i).val();
		$("#cmntText" + index + i).val('');
	} else {
		if($("#ansReqYn"+ index + i).is(":checked") == true) {
			ansReqYn = "Y";
		}
//		cmntCts = $("#cmnt"+index+i).val().trim();
		cmntCts = $("#cmntText"+index + i).val().trim();
	}
	
	if(cmntCts == null || cmntCts == ""){
		alert("<spring:message code='forum.alert.input.reply'/>");//댓글을 입력해주시기 바랍니다.
		return false;
	}
	
	var url = '/forum/forumHome/Form/editCmnt.do';
	var data = {
		"ansReqYn" : ansReqYn,
		"cmntSn" : cmntSn,
		"cmntCts" : cmntCts
	};

	ajaxCall(url, data, function(data) {
		if (data.result > 0) {
			alert("<spring:message code='forum.alert.mod_success.reply'/>"); // 댓글 수정에 성공하였습니다.
			listLoad();
		} else {
			alert("<spring:message code='forum.alert.mod_fail.reply'/>");//댓글 수정에 실패하였습니다. 다시 시도해주시기 바랍니다.
			listLoad();
		}
	}, function(xhr, status, error) {
		/* 에러가 발생했습니다! */
		alert("<spring:message code='fail.common.msg' />");
	}, true);
}

// 댓글 삭제
function delCmnt(rgtrId,cmntSn) {
	var result = confirm("<spring:message code='forum.button.confirm.del'/>"); // 정말 삭제하시겠습니까?
	if(!result) { return false; }
	
	var url = '/forum/forumHome/Form/delCmnt.do';
	var data = {
		"cmntSn" : cmntSn,
		"userId" : "${userId}"
	};

	ajaxCall(url, data, function(data) {
		if (data.result > 0) {
			alert("<spring:message code='forum.alert.del_success'/>");// 삭제에 성공하였습니다.
			listLoad();
		} else {
			alert("<spring:message code='forum.alert.del_fail'/>");//삭제에 실패하였습니다. 다시 시도해주시기 바랍니다.
			listLoad();
		}
	}, function(xhr, status, error) {
		/* 에러가 발생했습니다! */
		alert("<spring:message code='fail.common.msg' />");
	}, true);
}

// 댓글의 댓글 버튼
function btnAddCmnt(index,i,atclSn,cmntSn){
	if($("#toggleCmnt"+index+i ).hasClass("on")){
		$("#toggleCmnt"+index+i ).addClass("off").removeClass("on");
	}else{
		var btn = "";
		btn += "<li id=\"addBtnCmnt\">";
		btn += "<a class=\"ui basic grey small button\" onclick=\"addCmnt('"+atclSn+"','"+cmntSn+"','"+index+"','"+i+"');\" ><spring:message code='forum.button.reg'/></a>"; // 등록
		btn += "</li>";

		$("#toggleCmnt"+index+i).children().find('li#editBtnCmnt').after(btn);
		$("#toggleCmnt"+index+i).children().find('li#editBtnCmnt').remove();
		$("#toggleCmnt"+index+i).children().find('textarea#cmntText'+index).val('');
		
		$("#toggleCmnt"+index+i ).addClass("on").removeClass("off");
	}
}

// 댓글의 댓글 수정 버튼
function btnEditCmnt(index,i,level,cmntSn,atclSn) {
	var cmntCts = $("#cmntCts"+index+i).text().trim();
	if(!$("#toggleCmnt"+index+i).hasClass("on")) {
		var btn = "";
		btn += "<li id=\"editBtnCmnt\">";
		btn += "<a class=\"ui basic grey small button\" onclick=\"editCmnt('"+atclSn+"','"+cmntSn+"','"+index+"','"+i+"','"+level+"');\" ><spring:message code='forum.button.mod'/></a>"; // 수정
		btn += "</li>";
		
		$("#toggleCmnt"+index+i).children().find('li#addBtnCmnt').after(btn);
		$("#toggleCmnt"+index+i).children().find('li#addBtnCmnt').remove();
		$("#toggleCmnt"+index+i).children().find('textarea#cmntText'+index+i).val(cmntCts);
		
		$("#toggleCmnt"+index+i).addClass("on").removeClass("off");
	} else {
		var btn = "";
		btn += "<li id=\"addBtnCmnt\">";
		btn += "<a class=\"ui basic grey small button\" onclick=\"addCmnt('"+atclSn+"','"+cmntSn+"','"+index+"','"+i+"');\" ><spring:message code='forum.button.reg'/></a>"; // 등록
		btn += "</li>";
		
		$("#toggleCmnt"+index+i).children().find('li#editBtnCmnt').after(btn);
		$("#toggleCmnt"+index+i).children().find('li#editBtnCmnt').remove();
		
		$("#toggleCmnt"+index+i).addClass("off").removeClass("on");
	} 
}

//좋아요 ,추천 버튼
function recomBtn(atclSn, recomStatus){
	$.getJSON("/forum/forumHome/Form/recom.do", {
		"atclSn" : atclSn,
		"recomStatus" : recomStatus,
		"userId" : "${userId}"
	}).done(function(data) {
		if (data.result > 0) {
			listLoad();
		} else {
			listLoad();
		}
	});
}

// 목록
function forumList() {
	var url  = "/forum/forumHome/Form/forumList.do";
	var form = $("<form></form>");
	form.attr("method", "POST");
	form.attr("name", "listForm");
	form.attr("action", url);
	form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: "${vo.crsCreCd}"}));
	form.appendTo("body");
	form.submit();
}

//팀 구성원 보기
function teamMemberView(teamCtgrCd) {
	$("#teamCtgrCd").val(teamCtgrCd);
	$("#teamMemberForm").attr("target", "teamMemberIfm");
	$("#teamMemberForm").attr("action", "/forum/forumHome/teamMemberList.do");
	$("#teamMemberForm").submit();
	$('#teamMemberPop').modal('show');
}

//평가 대상자 리스트 조회
function listForumUser(page) {
	var url  = "/forum/forumHome/forumJoinUserList.do";
	var data = {
		"forumCd" 	  : "${vo.forumCd}",
		"crsCreCd"	  : "${vo.crsCreCd}",
		"teamCd"	  : $("#teamCd").val(),
		//"pageIndex"   : page,
		//"listScale"   : $("#listScale").val(),
		"searchKey"   : $("#searchKey").val(),
		"searchValue" : $("#searchValue").val()
	};
	
	ajaxCall(url, data, function(data) {
		if (data.result > 0) {
			var html = "";
			data.returnList.forEach(function(v, i) {
				html += "<tr>";
				html += "	<td class=\"tc footable-first-visible\" style=\"display: table-cell;\">"+ v.lineNo +"</td>";
				html += "	<td style=\"display: table-cell;\">"+ v.deptNm +"</td>";
				html += "	<td class=\"tc\" style=\"display: table-cell;\">"+ v.userId +"</td>";
				html += "	<td class=\"tc\" style=\"display: table-cell;\">"+ v.userNm +"</td>";
				html += "	<td class=\"tc\" style=\"display: table-cell;\">"+ v.forumMyAtclCnt +"/"+ v.forumAtclCnt +"</td>";
				html += "	<td class=\"tc\" style=\"display: table-cell;\">"+ v.forumMyCmntCnt +"/"+ v.forumCmntCnt +"</td>";
				if(v.evalRsltOpenYn == "Y") {
					html += "<td class=\"tc\" style=\"display: table-cell;\">";
					var mutAvg = v.mutAvg;
					for(i = 1; i <= 5; i++) {
						if(mutAvg >= i/*  && v.evalRsltOpenYn === 'N' */) html += "<i class=\"star icon orange\"></i>";
						else html += "<i class=\"star outline icon\"></i>";
					}
					html += "</td>";
				}
				html += "	<td class=\"tc\" style=\"display: table-cell;\">"+ v.mutCnt +"</td>";
				html += "	<td class=\"tc\" class=\"footable-last-visible\" style=\"display: table-cell;\">";
				if(v.userId != "${userId}") {
					if(v.mutSn == null) {
						if(v.actlCnt > 0) {
							html += "		<a href=\"javascript:void(0);\" class=\"ui basic small button " + (PROFESSOR_VIRTUAL_LOGIN_YN == "Y" ? 'disabled' : '') + "\" onclick=\"evalStarModal('${vo.forumCd}','"+ v.stdNo +"','"+ v.userId +"', '', '"+ v.evalStartDttm +"', '"+ v.evalEndDttm +"')\"><spring:message code='forum.button.eval.do'/></a>"; //평가하기 
						} else {
							html += "		<a href=\"javascript:void(0);\" class=\"ui basic small button " + (PROFESSOR_VIRTUAL_LOGIN_YN == "Y" ? 'disabled' : '') + "\" onclick=\"alert('<spring:message code='forum.alert.eval.empty'/>')\"><spring:message code='forum.button.eval.do'/></a>"; // 평가할 게시물이 존재하지 않아 평가를 진행할 수 없습니다., 평가하기
						}
					} else {
						html += "		<a href=\"#0\" class=\"ui basic small button " + (PROFESSOR_VIRTUAL_LOGIN_YN == "Y" ? 'disabled' : '') + "\" onclick=\"evalStarModal('${vo.forumCd}','"+ v.stdNo +"','"+ v.userId +"', '"+ v.mutSn +"', '"+ v.evalStartDttm +"', '"+ v.evalEndDttm +"')\"><spring:message code='forum.button.eval.do'/></a>"; // 수정하기
					}
				} else {
					if(v.evalRsltOpenYn == "Y") {
						html += "		<a href='javascript:forumMutEvalPop(\"" + v.stdNo + "\")' class='ui button small primary'><spring:message code='common.label.eval.opinion' /></a>"; // 평가의견
					}
				}
				html += "	</td>";
				html += "</tr>";
			});
			$("#forumStareUserList").empty().append(html);
			
			$(".table").footable();
			/*
			var params = {
				totalCount 	  : data.pageInfo.totalRecordCount,
				listScale 	  : data.pageInfo.recordCountPerPage,
				currentPageNo : data.pageInfo.currentPageNo,
				eventName 	  : "listExamUser"
			};
			
			gfn_renderPaging(params);
			*/
			$("input[name='check']").each(function(){
				if(stdList.size > 0){
					if(stdList.has($(this).val().split('|')[0])){
						$(this).prop('checked','checked');
					}else{
						$(this).removeAttr('checked');
					}
				}
			});
		} else {
			alert(data.message);
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='forum.common.error' />");/* 오류가 발생했습니다! */
	}, true);
}

// 상호평가 모달
function evalStarModal(forumCd, stdNo, userId, mutSn) {
	getMyAtclCnt().done(function(myAtclCnt) {
		if(myAtclCnt == 0) {
			alert('<spring:message code="forum.alert.no.atcl.mut.eval" />'); // 토론 참여후 평가가능 합니다.
			return;
		}
		
		$("#evalStarForm > input[name='forumCd']").val(forumCd);
		$("#evalStarForm > input[name='stdNo']").val(stdNo);
		$("#evalStarForm > input[name='userId']").val(userId);
		$("#evalStarForm > input[name='mutSn']").val(mutSn);
		$(".modal-title").text("평가하기");
		$("#evalStarForm").attr("target", "forumWritePopIfm");
		$("#evalStarForm").attr("action", "/forum/forumHome/evalStar.do");
		$("#evalStarForm").submit();
		$('#forumWriteModal').modal('show');
	});
}

function getMyAtclCnt() {
	var deferred = $.Deferred();
	
	var url = "/forum/forumHome/myAtclCount.do";
	var data = {
		crsCreCd: "${vo.crsCreCd}",
		forumCd : "${vo.forumCd}"
	};
	
	ajaxCall(url, data, function(data) {
		if(data.result > 0) {
			var returnVO = data.returnVO;
			
			deferred.resolve(returnVO.totalCnt);
    	} else {
    		alert(data.message);
    		deferred.reject();
    	}
	}, function(xhr, status, error) {
		alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
		deferred.reject();
	});

	return deferred.promise();
}

function forumMutEvalPop(stdNo) {
	$("#mutEvalViewForm > input[name='crsCreCd']").val("${vo.crsCreCd}");
	$("#mutEvalViewForm > input[name='forumCd']").val("${vo.forumCd}");
	$("#mutEvalViewForm > input[name='stdNo']").val(stdNo);
	$("#mutEvalViewForm").attr("target", "mutEvalViewIfm");
	$("#mutEvalViewForm").attr("action", "/forum/forumHome/mutEvalViewPop.do");
	$("#mutEvalViewForm").submit();
	$('#mutEvalViewPop').modal('show');
}
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
<form id="teamMemberForm" name="teamMemberForm" action="" method="POST">
<input type="hidden" name="teamCtgrCd" id="teamCtgrCd">
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
								// set location
								setLocationBar("<spring:message code='forum.label.forum'/>", "<spring:message code='forum.label.forum.bbs'/>");
							});
							</script>
                        	
                            <h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code='forum.label.forum'/>
                                <%-- <div class="ui breadcrumb small">
                                    <small class="section"><spring:message code='forum.label.info'/><!-- 정보 --></small>
                                </div> --%>
                            </h2>
                            <div class="button-area">
                                
                            </div>
                        </div>
                    
                        <div class="row">
                            <div class="col">
				
                                <div class="listTab">
                                    <ul class="">  
                                        <li class="select mw120">
                                            <a href="#tab1"><spring:message code='forum.label.forum.bbs'/><!-- 토론방 --></a>
                                        </li>
                                        
			                            <c:if test="${vo.mutEvalYn eq 'Y'}">
											<li class="mw120">
												<a  href="#tab2"><spring:message code='forum.label.mut.eval'/><!-- 상호평가 --></a>
											</li>
										</c:if>
                                    </ul>
                                </div>

				<!-- ui form start -->
				<div class="ui form">
					
					
					<div id="tab1" class="tab_content" style="display: block">
						<div class="flex mt10 mb10">
							<div class="button-area mla">
								<c:if test="${PROFESSOR_VIRTUAL_LOGIN_YN ne 'Y' && vo.writeAuth eq 'Y'}">
								<a href="javascript:void(1)" class="ui blue button btnSave" onclick="addActl();"><spring:message code='forum.button.save'/><!-- 저장 --></a>
								</c:if>
								<a href="#0" class="ui blue button" onclick="forumList()"><spring:message code='forum.label.list'/><!-- 목록 --></a>
							</div>
						</div>
						
						
						<!-- 토론 내용 시작 -->
						<div class="ui styled fluid accordion week_lect_list" style="border: none;">
							<div class="title active">
								<div class="title_cont">
									<div class="left_cont">
										<div class="lectTit_box">
											<p class="lect_name">${vo.forumTitle}</p>
											<fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss" value="${vo.forumStartDttm }" />
											<fmt:formatDate var="forumStartDttm" pattern="yyyy.MM.dd(HH:mm)" value="${startDateFmt }" />
											<fmt:parseDate var="endDateFmt" pattern="yyyyMMddHHmmss" value="${vo.forumEndDttm }" />
											<fmt:formatDate var="forumEndDttm" pattern="yyyy.MM.dd(HH:mm)" value="${endDateFmt }" />
											<span class="fcGrey"><small><spring:message code='forum.label.forum.date' /><!-- 토론기간 --> : ${forumStartDttm} ~ ${forumEndDttm}</small>
											| <spring:message code='forum.label.scoreAplyYn' /><!-- 성적 반영 --> :
												<c:choose>
													<c:when test="${vo.scoreAplyYn eq 'Y'}">
														<spring:message code='forum.common.yes'/><!-- 예 -->
													</c:when>
													<c:otherwise>
														<spring:message code='forum.common.no'/><!-- 아니오 -->
													</c:otherwise>
												</c:choose>
											| <spring:message code='forum.label.scoreOpen'/><!-- 성적 공개 --> : 
												<c:choose>
													<c:when test="${vo.scoreOpenYn eq 'Y'}">
														<spring:message code='forum.common.yes'/><!-- 예 -->
													</c:when>
													<c:otherwise>
														<spring:message code='forum.common.no'/><!--아니오 -->
													</c:otherwise>
												</c:choose>
											</span>
										</div>
									</div>
								</div>
								<i class="dropdown icon ml20"></i>
							</div>
							
							<div class="content active">
								<div class="ui segment">
								<ul class="tbl">
									<li>
										<dl>
											<dt>
												<label><spring:message code='forum.label.forum.content' /><!-- 토론내용 --></label>
											</dt>
											<dd><pre>${vo.forumArtl}</pre></dd>
										</dl>
									</li>
									<li>
										<dl>
											<dt>
												<label><spring:message code='forum.label.forum.date' /><!-- 토론기간 --></label>
											</dt>
											<dd>${forumStartDttm} ~ ${forumEndDttm}</dd>
											<dt>
												<label><spring:message code='forum.label.aplyAsnYn' /><!-- 댓글 답변 요청 --></label>
											</dt>
											<dd>
												<c:choose>
													<c:when test="${vo.aplyAsnYn eq 'Y'}">
														<spring:message code='forum.common.yes'/><!-- 예 -->
													</c:when>
													<c:otherwise>
														<spring:message code='forum.common.no'/><!--아니오 -->
													</c:otherwise>
												</c:choose>
											</dd>
										</dl>
									</li>
									<li>
										<dl>
											<dt>
												<label><spring:message code='forum.label.period.after'/><!-- 지각제출 --></label>
											</dt>
											<dd>
												<c:choose>
													<c:when test="${vo.periodAfterWriteYn eq 'Y'}">
														<spring:message code='forum.common.yes'/><!-- 예 -->
														<fmt:parseDate var="extEndDttm" pattern="yyyyMMddHHmmss" value="${vo.extEndDttm }" />
														<fmt:formatDate var="extEndDttm" pattern="yyyy.MM.dd(HH:mm)" value="${extEndDttm }" />
														| ${extEndDttm}
													</c:when>
													<c:otherwise>
														<spring:message code='forum.common.no'/><!--아니오 -->
													</c:otherwise>
												</c:choose>
											</dd>
											<dt>
												<label><spring:message code='forum.label.otherViewYn' /><!-- 본인의 토론글 등록 후 다른 참여글 보기 --></label>
											</dt>
											<dd>
												<c:choose>
													<c:when test="${vo.otherViewYn eq 'Y'}">
														<spring:message code='forum.common.yes'/><!-- 예 -->
													</c:when>
													<c:otherwise>
														<spring:message code='forum.common.no'/><!-- 아니오 -->
													</c:otherwise>
												</c:choose>
											</dd>
										</dl>
									</li>
									<li>
										<dl>
											<dt>
												<label for="test"><spring:message code='forum.label.evalCtgr'/><!-- 평가 방법 --></label>
											</dt>
											<dd>
												<c:choose>
													<c:when test="${vo.evalCtgr eq 'P'}">
														<spring:message code='forum.label.evalctgr.score'/><!-- 점수형 -->
													</c:when>
													<c:otherwise>
														<spring:message code='forum.label.evalctgr.participate'/><!-- 참여형 -->
													</c:otherwise>
												</c:choose>
											</dd>
											<dt>
												<label for="test"><spring:message code='forum.label.yesno' /><!-- 찬반토론 --></label>
											</dt>
											<dd>
												<c:choose>
													<c:when test="${vo.prosConsForumCfg eq 'Y'}">
												<c:if test="${vo.prosConsRateOpenYn eq 'Y'}">
													<div><spring:message code='forum.label.prosConsRate'/><!-- 찬반 비율 공개 --> : <spring:message code='forum.common.yes'/><!-- 예 --></div>
												</c:if>
												<c:if test="${vo.regOpenYn eq 'Y'}">
													<div><spring:message code='forum.label.regOpen'/><!-- 작성자 공개 --> : <spring:message code='forum.common.yes'/><!-- 예 --></div>
												</c:if>
												<c:if test="${vo.prosConsModYn eq 'Y'}"> 
													<div><spring:message code='forum.label.prosConsMod'/><!-- 찬반의견 변경 --> : <spring:message code='forum.common.yes'/><!-- 예 --></div>
												</c:if> 
													</c:when>
													<c:otherwise>
														<spring:message code='forum.common.no'/><!-- 아니오 -->
													</c:otherwise>
												</c:choose>
											</dd>
										</dl>
									</li>
									<li>
										<dl>
											<%-- <dt>
												<label for="test"><spring:message code='forum.label.forum.gradeRef' /><!-- 성적반영비율 --></label>
											</dt>
											<dd>
												<c:choose>
													<c:when test="${empty vo.scoreRatio || vo.scoreRatio eq ''}">
														-
													</c:when>
													<c:otherwise>
														${vo.scoreRatio}%
													</c:otherwise>
												</c:choose>
											</dd> --%>
											<dt>
												<label for="test"><spring:message code='forum.label.mut.eval' /><!-- 상호평가 --></label>
											</dt>
											<dd>
												<c:choose>
													<c:when test="${vo.mutEvalYn eq 'Y' }">
												<fmt:parseDate var="evalStartDateFmt" pattern="yyyyMMddHHmmss" value="${vo.evalStartDttm}" />
												<fmt:formatDate var="evalStartDttm" pattern="yyyy.MM.dd(HH:mm)" value="${evalStartDateFmt}" />
												<fmt:parseDate var="evalEndDateFmt" pattern="yyyyMMddHHmmss" value="${vo.evalEndDttm}" />
												<fmt:formatDate var="evalEndDttm" pattern="yyyy.MM.dd(HH:mm)" value="${evalEndDateFmt}" />
												<div>
												<spring:message code='forum.label.date'/><!-- 기간 --> : ${evalStartDttm} ~ ${evalEndDttm}
												</div>
												<div>
												<spring:message code='forum.label.result.open'/><!-- 결과공개 --> : 
													<c:choose>
														<c:when test="${vo.evalRsltOpenYn eq 'Y'}">
															<spring:message code='forum.common.yes'/><!-- 예 -->
														</c:when>
														<c:otherwise>
															<spring:message code='forum.common.no'/><!-- 아니오 -->
														</c:otherwise>
													</c:choose>
												</div> 
													</c:when>
													<c:otherwise>
														<spring:message code='forum.common.no'/><!-- 아니오 -->
													</c:otherwise>
												</c:choose>
											</dd>
											<dt>
												<label for="test"><spring:message code='forum.label.type.teamForum' /><!-- 팀토론 --></label>
											</dt>
											<dd>
												<c:choose>
													<c:when test="${vo.forumCtgrCd eq 'TEAM'}">
														<spring:message code='forum.common.yes'/><!-- 예 -->
														| ${vo.crsCreNm}<spring:message code='forum.label.team.member.info'/><!-- 반 팀구성 --> <button class="ui icon small button" onclick="teamMemberView('${vo.teamCtgrCd}')"><spring:message code='forum.label.team.member.view'/><!-- 팀 구성원 보기 --></button>
													</c:when>
													<c:otherwise>
														<spring:message code='forum.common.no'/><!-- 아니오 -->
													</c:otherwise>
												</c:choose>
											</dd>
										</dl>
									</li>
									<li>
										<dl>
											<dt>
												<label for="contLabel"><spring:message code='forum.label.attachFile'/><!-- 첨부파일 --></label>
											</dt>
											<dd>
												<c:forEach var="list" items="${vo.fileList }">
													<button class="ui icon small button" id="file1_${list.fileSn }" title="<spring:message code='forum.label.attachFile.download'/>" onclick="fileDown('${list.fileSn}', '${list.repoCd}')"><i class="ion-android-download"></i> </button><!-- 파일다운로드 -->
													<script>
														byteConvertor("${list.fileSize}", "${list.fileNm}", "file1_${list.fileSn}");
													</script>
												</c:forEach>
											</dd>
										</dl>
									</li>
								</ul>
								</div>
							</div>
						</div>
						<!-- 토론 내용 끝 -->
						
						<!-- 찬반의견 등록 폼 -->
						<form id="forumListForm" name="forumListForm" action="" method="POST">
							<input type="hidden" id="forumCd" name="forumCd"/>
							<input type="hidden" id="goUrl" name="goUrl"/>
							<input type="hidden" id="crsCreCd" name="crsCreCd" value="${vo.crsCreCd}"/>
							<input type="hidden" id="userId" name="userId" value="${userId}"/>
							<input type = hidden id = "prosConsTypeCd" value="P"/>
							<input type = hidden id = "atclStatus" value="A"/>
							<input type = hidden id = "atclSn" value=""/>
							<input type = hidden id = "addYn" value="Y"/>
									<div class="column mt20">
										<c:if test="${PROFESSOR_VIRTUAL_LOGIN_YN ne 'Y' && vo.writeAuth eq 'Y'}">
											<div class="inline fields">
												<label><spring:message code='forum.label.pros.cons.opinion'/></label><!-- 찬반 의견 -->
												<div class="field">
													<div class="ui radio checkbox">
														<input type="radio" id="atclTypeP" name="atclTypeCd" checked="checked" onchange="checkedRadio('P')" value="P">
														<label><spring:message code='forum.label.pros'/></label><!-- 찬성 -->
													</div>
												</div>
												<div class="field">
													<div class="ui radio checkbox">
														<input type="radio" id="atclTypeC" name="atclTypeCd" onchange="checkedRadio('C')" value="C">
														<label><spring:message code='forum.label.cons'/></label><!-- 반대 -->
													</div>
												</div>
												<c:if test="${vo.prosConsModYn eq 'Y'}">
												<div class="field">
													<div class="ui small error message">
														<i class="info circle icon"></i>
														<spring:message code='forum.label.atcltype.message'/><!-- 재투표 가능하며 기존 의견은 무시됩니다. -->
													</div>
												</div>
												</c:if>
											</div>
											<textarea rows="5" id="cts"></textarea>
										</c:if>
										<div class="option-content mt5">
											<div class="button-area mla">
												<c:if test="${PROFESSOR_VIRTUAL_LOGIN_YN ne 'Y' && vo.writeAuth eq 'Y'}">
												<a href="javascript:void(1)" class="ui blue button btnSave" onclick="addActl();"><spring:message code='forum.button.save'/><!-- 저장 --></a>
												</c:if>
												<a href="#0" class="ui blue button" onclick="forumList()"><spring:message code='forum.label.list'/><!-- 목록 --></a>
											</div>
										</div>
									</div>
							
									<div class="ui divider"></div>
									<div id = "list"></div>
						</form>
						<!-- 찬반의견 등록 폼 -->
					</div>

					<!-- 상호평가 탭 시작 -->
					<div id="tab2" class="tab_content" style="display: none;">
						<div class="ui styled fluid accordion week_lect_list" style="border: none;">
							<div class="title active">
								<div class="title_cont">
									<div class="left_cont">
										<div class="lectTit_box">
											<p class="lect_name">${vo.forumTitle}</p>
											<fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss" value="${vo.forumStartDttm }" />
											<fmt:formatDate var="forumStartDttm" pattern="yyyy.MM.dd(HH:mm)" value="${startDateFmt }" />
											<fmt:parseDate var="endDateFmt" pattern="yyyyMMddHHmmss" value="${vo.forumEndDttm }" />
											<fmt:formatDate var="forumEndDttm" pattern="yyyy.MM.dd(HH:mm)" value="${endDateFmt }" />
											<span class="fcGrey"><small><spring:message code='forum.label.forum.date' /><!-- 토론기간 --> : ${forumStartDttm} ~ ${forumEndDttm}</small>
											| <spring:message code='forum.label.scoreAplyYn' /><!-- 성적 반영 --> :
												<c:choose>
													<c:when test="${vo.scoreAplyYn eq 'Y'}">
														<spring:message code='forum.common.yes'/><!-- 예 -->
													</c:when>
													<c:otherwise>
														<spring:message code='forum.common.no'/><!-- 아니오 -->
													</c:otherwise>
												</c:choose>
											| <spring:message code='forum.label.scoreOpen'/><!-- 성적 공개 --> : 
												<c:choose>
													<c:when test="${vo.scoreOpenYn eq 'Y'}">
														<spring:message code='forum.common.yes'/><!-- 예 -->
													</c:when>
													<c:otherwise>
														<spring:message code='forum.common.no'/><!--아니오 -->
													</c:otherwise>
												</c:choose>
											</span>
										</div>
									</div>
								</div>
								<i class="dropdown icon ml20"></i>
							</div>
							
							<div class="content active p0">
								<div class="ui segment">
								<ul class="tbl">
									<li>
										<dl>
											<dt>
												<label><spring:message code='forum.label.forum.content' /><!-- 토론내용 --></label>
											</dt>
											<dd><pre>${vo.forumArtl}</pre></dd>
										</dl>
									</li>
									<li>
										<dl>
											<dt>
												<label><spring:message code='forum.label.forum.date' /><!-- 토론기간 --></label>
											</dt>
											<dd>${forumStartDttm} ~ ${forumEndDttm}</dd>
											<dt>
												<label><spring:message code='forum.label.aplyAsnYn' /><!-- 댓글 답변 요청 --></label>
											</dt>
											<dd>
												<c:choose>
													<c:when test="${vo.aplyAsnYn eq 'Y'}">
														<spring:message code='forum.common.yes'/><!-- 예 -->
													</c:when>
													<c:otherwise>
														<spring:message code='forum.common.no'/><!--아니오 -->
													</c:otherwise>
												</c:choose>
											</dd>
										</dl>
									</li>
									<li>
										<dl>
											<dt>
												<label><spring:message code='forum.label.period.after'/><!-- 지각제출 --></label>
											</dt>
											<dd>
												<c:choose>
													<c:when test="${vo.periodAfterWriteYn eq 'Y'}">
														<spring:message code='forum.common.yes'/><!-- 예 -->
														<fmt:parseDate var="extEndDttm" pattern="yyyyMMddHHmmss" value="${vo.extEndDttm }" />
														<fmt:formatDate var="extEndDttm" pattern="yyyy.MM.dd(HH:mm)" value="${extEndDttm }" />
														| ${extEndDttm}
													</c:when>
													<c:otherwise>
														<spring:message code='forum.common.no'/><!--아니오 -->
													</c:otherwise>
												</c:choose>
											</dd>
											<dt>
												<label><spring:message code='forum.label.otherViewYn' /><!-- 본인의 토론글 등록 후 다른 참여글 보기 --></label>
											</dt>
											<dd>
												<c:choose>
													<c:when test="${vo.otherViewYn eq 'Y'}">
														<spring:message code='forum.common.yes'/><!-- 예 -->
													</c:when>
													<c:otherwise>
														<spring:message code='forum.common.no'/><!-- 아니오 -->
													</c:otherwise>
												</c:choose>
											</dd>
										</dl>
									</li>
									<li>
										<dl>
											<dt>
												<label for="test"><spring:message code='forum.label.evalCtgr'/><!-- 평가 방법 --></label>
											</dt>
											<dd>
												<c:choose>
													<c:when test="${vo.evalCtgr eq 'P'}">
														<spring:message code='forum.label.evalctgr.score'/><!-- 점수형 -->
													</c:when>
													<c:otherwise>
														<spring:message code='forum.label.evalctgr.participate'/><!-- 참여형 -->
													</c:otherwise>
												</c:choose>
											</dd>
											<dt>
												<label for="test"><spring:message code='forum.label.yesno' /><!-- 찬반토론 --></label>
											</dt>
											<dd>
												<c:choose>
													<c:when test="${vo.prosConsForumCfg eq 'Y'}">
												<c:if test="${vo.prosConsRateOpenYn eq 'Y'}">
													<div><spring:message code='forum.label.prosConsRate'/><!-- 찬반 비율 공개 --> : <spring:message code='forum.common.yes'/><!-- 예 --></div>
												</c:if>
												<c:if test="${vo.regOpenYn eq 'Y'}">
													<div><spring:message code='forum.label.regOpen'/><!-- 작성자 공개 --> : <spring:message code='forum.common.yes'/><!-- 예 --></div>
												</c:if>
												<c:if test="${vo.prosConsModYn eq 'Y'}"> 
													<div><spring:message code='forum.label.prosConsMod'/><!-- 찬반의견 변경 --> : <spring:message code='forum.common.yes'/><!-- 예 --></div>
												</c:if> 
													</c:when>
													<c:otherwise>
														<spring:message code='forum.common.no'/><!-- 아니오 -->
													</c:otherwise>
												</c:choose>
											</dd>
										</dl>
									</li>
									<li>
										<dl>
											<%-- <dt>
												<label for="test"><spring:message code='forum.label.forum.gradeRef' /><!-- 성적반영비율 --></label>
											</dt>
											<dd>
												<c:choose>
													<c:when test="${empty vo.scoreRatio || vo.scoreRatio eq ''}">
														-
													</c:when>
													<c:otherwise>
														${vo.scoreRatio}%
													</c:otherwise>
												</c:choose>
											</dd> --%>
											<dt>
												<label for="test"><spring:message code='forum.label.mut.eval' /><!-- 상호평가 --></label>
											</dt>
											<dd>
												<c:choose>
													<c:when test="${vo.mutEvalYn eq 'Y' }">
												<fmt:parseDate var="evalStartDateFmt" pattern="yyyyMMddHHmmss" value="${vo.evalStartDttm}" />
												<fmt:formatDate var="evalStartDttm" pattern="yyyy.MM.dd(HH:mm)" value="${evalStartDateFmt}" />
												<fmt:parseDate var="evalEndDateFmt" pattern="yyyyMMddHHmmss" value="${vo.evalEndDttm}" />
												<fmt:formatDate var="evalEndDttm" pattern="yyyy.MM.dd(HH:mm)" value="${evalEndDateFmt}" />
												<div>
												<spring:message code='forum.label.date'/><!-- 기간 --> : ${evalStartDttm} ~ ${evalEndDttm}
												</div>
												<div>
												<spring:message code='forum.label.result.open'/><!-- 결과공개 --> : 
													<c:choose>
														<c:when test="${vo.evalRsltOpenYn eq 'Y'}">
															<spring:message code='forum.common.yes'/><!-- 예 -->
														</c:when>
														<c:otherwise>
															<spring:message code='forum.common.no'/><!-- 아니오 -->
														</c:otherwise>
													</c:choose>
												</div> 
													</c:when>
													<c:otherwise>
														<spring:message code='forum.common.no'/><!-- 아니오 -->
													</c:otherwise>
												</c:choose>
											</dd>
											<dt>
												<label for="test"><spring:message code='forum.label.type.teamForum' /><!-- 팀토론 --></label>
											</dt>
											<dd>
												<c:choose>
													<c:when test="${vo.forumCtgrCd eq 'TEAM'}">
														<spring:message code='forum.common.yes'/><!-- 예 -->
														| ${vo.crsCreNm}<spring:message code='forum.label.team.member.info'/><!-- 반 팀구성 --> <button class="ui icon small button" onclick="teamMemberView('${vo.teamCtgrCd}')"><spring:message code='forum.label.team.member.view'/><!-- 팀 구성원 보기 --></button>
													</c:when>
													<c:otherwise>
														<spring:message code='forum.common.no'/><!-- 아니오 -->
													</c:otherwise>
												</c:choose>
											</dd>
										</dl>
									</li>
									<li>
										<dl>
											<dt>
												<label for="contLabel"><spring:message code='forum.label.attachFile'/><!-- 첨부파일 --></label>
											</dt>
											<dd>
												<c:forEach var="list" items="${vo.fileList }">
													<button class="ui icon small button" id="file2_${list.fileSn }" title="파일다운로드" onclick="fileDown('${list.fileSn}', '${list.repoCd }')"><i class="ion-android-download"></i> </button>
													<script>
														byteConvertor("${list.fileSize}", "${list.fileNm}", "file2_${list.fileSn}");
													</script>
												</c:forEach>
											</dd>
										</dl>
									</li>
								</ul>
								</div>
							</div>
						</div>
						
					<!-- 평가 대상자 목록 시작 -->
					<h4 class="ui top attached header"><spring:message code='forum.label.eval.user.list' /><!-- 평가 대상자 목록 --></h4>
					<div class="scrollbox mCustomScrollbar _mCS_1" style="height: 680px; position: relative; overflow: visible;">
						<div id="mCSB_1" class="mCustomScrollBox mCS-dark-thin mCSB_vertical mCSB_outside" style="max-height: none;" tabindex="0">
							<div id="mCSB_1_container" class="mCSB_container mCS_y_hidden mCS_no_scrollbar_y" style="position:relative; top:0; left:0;" dir="ltr">
								<div class="ui bottom attached segment" id="evalTargetInfo">
									<h3 class="page-title" id="teamNmTitle"></h3>
									<table class="table type2" data-sorting="true" data-paging="false" data-empty="<spring:message code='forum.common.empty' />"><!-- 등록된 내용이 없습니다. -->
										<thead>
											<tr>
												<th scope="col" data-type="number" class="tc num">No</th>
												<th scope="col" data-breakpoints="xs" class="tc"><spring:message code="forum.label.dept.nm" /><!-- 학과 --></th>
												<th scope="col" data-breakpoints="xs" class="tc"><spring:message code="forum.label.user.no" /><!-- 학번 --></th>
												<th scope="col" class="tc"><spring:message code="forum.label.user_nm" /><!-- 이름 --></th>
												<th scope="col" data-breakpoints="xs" class="tc"><spring:message code="forum.label.forum.bbsCnt" /><!-- 토론 글수 --></th>
												<th scope="col" data-breakpoints="xs" class="tc"><spring:message code="forum.label.forum.commCnt" /><!-- 댓글수 --></th>
												<c:if test="${vo.evalRsltOpenYn eq 'Y'}">
												<th scope="col" data-breakpoints="xs" class="tc"><spring:message code="forum.label.mutEval.avg" /><!-- 평균 별점 --></th>
												</c:if>
												<th scope="col" data-breakpoints="xs" class="tc"><spring:message code="forum.label.eval.person" /><!-- 평가 인원 --></th>
												<th scope="col" class="tc"><spring:message code="forum.label.eval" /><!-- 평가 --></th>
											</tr>
										</thead>
										<tbody id="forumStareUserList">
										</tbody>
									</table>
								</div>
							</div>
						</div>
						
						<!-- 상호평가 별점주기 시작 -->
						<form id="evalStarForm" name="evalStarForm">
							<input type="hidden" name="forumCd" id="forumCd" />
							<input type="hidden" name="stdNo" id="stdNo" />
							<input type="hidden" name="userId" id="userId" />
							<input type="hidden" name="mutSn" id="mutSn" />
						</form>
						<!-- 상호평가 별점주기 끝 -->
					</div>
					<!-- 평가 대상자 목록 끝 -->
						
					</div>
				</div>
				<!-- ui form end -->
            	
                            </div>
                        </div>
                     </div>

                </div>
            </div>
			<!-- //본문 content 부분 -->
			<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
		</div>
	</div>
	
</div>
<!-- 팀 구성원 보기 모달 -->
<div class="modal fade" id="teamMemberPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code='forum.label.team.member.view'/>" aria-hidden="true"><!-- 팀 구성원 보기 -->
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='forum.button.close'/>"><!-- 닫기 -->
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title"><spring:message code='forum.label.team.member.view'/><!-- 팀 구성원 보기 --></h4>
			</div>
			<div class="modal-body">
				<iframe src="" id="teamMemberIfm" name="teamMemberIfm" width="100%" scrolling="no" title="member frame"></iframe>
			</div>
		</div>
	</div>
</div>
<!-- 팀 구성원 보기 모달 -->
<div class="modal fade" id="forumWriteModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code='forum.button.atcl.write' />" aria-hidden="false" style="display: none; padding-right: 17px;"><!-- 토론 글쓰기 -->
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='forum.button.close' />"><!-- 닫기 -->
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title info"><spring:message code='forum.label.forum' /> <spring:message code='forum.button.atcl.write' /><!-- 토론 글쓰기 --></h4>
			</div>
			<div class="modal-body">
				<iframe src="" width="100%" id="forumWritePopIfm" name="forumWritePopIfm" title="member frame"></iframe>
			</div>
		</div>
	</div>
</div>
<form id="mutEvalViewForm" name="mutEvalViewForm" method="post">
	<input type="hidden" name="crsCreCd" />
	<input type="hidden" name="forumCd" />
	<input type="hidden" name="stdNo" />
</form>
<div class="modal fade" id="mutEvalViewPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code='forum.button.feedback.write' />" aria-hidden="true"><!-- 피드백 작성하기 -->
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='forum.button.close'/>"><!-- 닫기 -->
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title"><spring:message code="common.label.eval.user.list" /><!-- 평가자 목록 --></h4>
			</div>
			<div class="modal-body">
				<iframe src="" id="mutEvalViewIfm" name="mutEvalViewIfm" width="100%" scrolling="no"></iframe>
			</div>
		</div>
	</div>
</div>
<script>
$('iframe').iFrameResize();
window.closeModal = function(){
	$('.modal').modal('hide');
	$("#mutEvalViewIfm").attr("src", "");
};
</script>
</body>

</html>
