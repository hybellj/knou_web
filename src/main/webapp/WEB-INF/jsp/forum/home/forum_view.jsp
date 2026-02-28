<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/forum/common/forum_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<script type="text/javascript">
$(document).ready(function () {
	$("#searchValue").on("keyup", function(e) {
		if(e.keyCode == 13) {
			listForum(1);
		}
	});
	
	listForum(1);

	if("${vo.mutEvalYn}" == "Y") {
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
				, actnHstyCts	: "[${vo.forumTitle}] 토론 상호평가"
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
	$(".accordion").accordion();
});

//목록
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

//토론 글쓰기
function forumWritePop(crsCreCd, stdNo) {
	$("#forumWritePopForm > input[name='crsCreCd']").val(crsCreCd);
	$("#forumWritePopForm > input[name='stdNo']").val(stdNo);
	$("#forumWritePopForm > input[name='forumCd']").val("${vo.forumCd}");
	$(".modal-title").text("<spring:message code='forum.label.forum'/> <spring:message code='forum.button.atcl.write'/>"); // 토론 글쓰기
	$("#forumWritePopForm").attr("target", "forumWritePopIfm");
    $("#forumWritePopForm").attr("action", "/forum/forumHome/forumWritePop.do");
    $("#forumWritePopForm").submit();
    $('#forumWriteModal').modal('show');
}

// 토론글 리스트
function listForum(page) {
	var searchValue = "";

	if ($("#searchValue").val() == "찬성") {
		searchValue = "P";
	} else if ($("#searchValue").val() == "반대") {
		searchValue = "C";
	}else if ($("#searchValue").val() == "FeedBack") {
		searchValue = "F";
	} else {
		searchValue = $("#searchValue").val();
	}
	
	var url = "/forum/forumHome/Form/forumBbsViewList.do";
	var data = {
		"pageIndex" : page,
		"listScale" : $("#listScale").val(),
		"searchValue" : searchValue,
		"forumCd" : "${vo.forumCd}",
		"crsCreCd" : "${vo.crsCreCd}",
		"forumCtgrCd" : "${vo.forumCtgrCd}",
		"teamCtgrCd" : "${vo.teamCtgrCd}",
		"userId" : "${userId}",
		"userName" : "${userName}",
		"stdList" : $("#teamStdList").val(),
		"teamNm" : $("#bbsTeamCd").val()
	};
	
	ajaxCall(url, data, function(data) {
		if(data.result > 0) {
			var returnList = data.returnList || [];
			var pageInfo = data.pageInfo;
			var html = createForumListHTML(returnList);
			
			$("#atclList").empty().html(html);
			$("#atclList .dropdown").dropdown();
			$(".comment-write .checkbox").checkbox();
			$(".commentlist").toggle();
			
			var params = {
					totalCount : data.pageInfo.totalRecordCount,
					listScale : data.pageInfo.recordCountPerPage,
					currentPageNo : data.pageInfo.currentPageNo,
					eventName : "listForum"
				};
			gfn_renderPaging(params);
		} else {
			alert(data.message);
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='forum.common.error'/>"); // 에러가 발생했습니다!
	}, true);
}

//토론 글 리스트 생성
function createForumListHTML(forumList) {
	var listHtml = '';
	
	if(forumList.length == 0) {
		listHtml += "	<div class=\"flex-container\">";
		listHtml += "		<div class=\"cont-none\">";
		listHtml += "			<span><spring:message code='forum.common.empty' /></span>"; // 등록된 내용이 없습니다.
		listHtml += "		</div>";
		listHtml += "	</div>";
	} else {
		forumList.forEach(function(v, i) {
			listHtml += "<div class='ui card wmax'>";
			listHtml += "	<div class='content card-item-center'>";
			listHtml += "		<div class='flex fac'>";
			listHtml += "			<span class='label circle mr10'><img src='/webdoc/img/no_user.gif' alt=\"<spring:message code='forum.common.user.img' />\"></span>"; // 학습자이미지
			listHtml += "			<span class='label mr10'>"+ v.regNm +"("+ v.userId +")</span>";
			if(v.delYn != "Y") {
				listHtml += "			<span class='label mr10 fcBlue'><spring:message code='forum.label.length'/> : "+ v.ctsLen +"<spring:message code='forum.label.word'/></span>"; // 글자수, 자
			}
			if(v.atclTypeCd == "NORMAL_N" || v.atclTypeCd == "TEAM_N") {
				if(v.prosConsTypeCd == "F" && v.delYn != "Y") {
					listHtml += "<span class='label mr10 fcOlive'>FeedBack</span>";
				}
			} else {
				if(v.delYn != "Y") {
					if(v.prosConsTypeCd == "P") {
						listHtml += "<span class='label mr10 fcBlue'><spring:message code='forum.label.pros'/></span>"; // 찬성
					} else if(v.prosConsTypeCd == "C") {
						listHtml += "<span class='label mr10 fcRed'><spring:message code='forum.label.cons'/></span>"; // 반대
					} else {
	//					listHtml += "<span class='label mr10 fcOlive'>FeedBack</span>";
					}
				}
			}
			if(v.delYn != "Y") {
				var modDttm = v.modDttm.substring(0, 4) + '.' + v.modDttm.substring(4, 6) + '.' + v.modDttm.substring(6, 8) + ' (' + v.modDttm.substring(8, 10) + ':' + v.modDttm.substring(10, 12) + ')';
				listHtml += "			<span class='label mr10'><spring:message code='forum.label.reg.dttm'/> : "+ modDttm +"</span>"; // 작성일시
				listHtml += "			<span class='label mr10'><spring:message code='forum.label.attachFile'/> : "; // 첨부파일
				v.fileList.forEach(function(item, index){
					if(index > 0) {
						listHtml += " | <a href=\"javascript:fileDown('"+ item.fileSn +"', '"+ item.repoCd +"');\" class=\"link\">"+ item.fileNm +"</a>";
					} else {
						listHtml += "<a href=\"javascript:fileDown('"+ item.fileSn +"', '"+ item.repoCd +"');\" class=\"link\">"+ item.fileNm +"</a>";
					}
				});
				listHtml +="</span>";
			}
			listHtml += "		</div>";
			if(v.rgtrId == "${userId}" && v.delYn == "N") {
				listHtml += "		<div class='ui top right pointing dropdown right-box'>";
				listHtml += "			<span class='bars'><spring:message code='forum.label.menu' /><!-- --></span>"; // 메뉴
				listHtml += "			<div class='menu'>";
				listHtml += "				<a href=\"javascript:editAtclBtn('"+ v.atclSn +"','"+ v.rgtrId +"')\" class='item'><spring:message code='forum.button.mod'/></a>"; // 수정
				listHtml += "				<a href=\"javascript:delAtcl('"+ v.atclSn +"','"+ v.rgtrId +"')\" class='item'><spring:message code='forum.button.del'/></a>"; // 삭제
				listHtml += "			</div>";
				listHtml += "		</div>";
			}
			listHtml += "	</div>";
			listHtml += "	<div class='ui segment ml25 mr25 mt10 mb10 forumView'>";
			if(v.delYn == "Y") {
				listHtml += "<span class=\"ui red label roundrect p2 pl4 pr4 f080\"><spring:message code='forum.label.del.forum.atcl'/> </span>"; // 삭제된 토론 글 입니다.
			} else {
				listHtml += "		<pre id='cts_"+ v.atclSn +"'>"+ v.cts +"</pre>";
			}
			listHtml += "	</div>";
			// 댓글
			listHtml += "	<div class='content comment border0 mt10'>";
			listHtml += "		<div class='ui box flex-item'>";
//			if(v.cmntCount > 0) {
				listHtml += "			<div class='flex-item mra'>";
				listHtml += "				<div class='cur_point' id='cmntOpen"+ i +"' onclick=\"cmntView('"+ v.atclSn +"', '"+ i +"')\">";
				listHtml += "					<i class=\"xi-message-o f120 mr5\" aria-hidden=\"true\"></i>";
				listHtml += "					"+ v.cmntCount +"<span class='desktop_elem'><spring:message code='forum.label.cnt.forum.cmnt'/></span>"; // 개의 댓글이 있습니다.
				listHtml += "					<i class=\"xi-angle-down-min\" aria-hidden=\"true\"></i>";
				listHtml += "				</div>";
				listHtml += "			</div>";
//			} else {
//				listHtml += "			<div class='flex-item mra'></div>";
//			}
			if(($("#bbsTeamCd").val() == "${meTeamNm}") || ($("#bbsTeamCd").val() != "${meTeamNm}" && "${vo.otherTeamAplyYn}" == "Y") || $("#bbsTeamCd").val() == undefined) {
			listHtml += "			<div id='cmntWrite"+ i +"' onclick=\"cmntWirte('"+ v.atclSn +"', '"+ i +"')\" class=\"mla\">";
			listHtml += "${data.pageInfo.currentPageNo}";
			if(PROFESSOR_VIRTUAL_LOGIN_YN != "Y" && "${vo.writeAuth}" == "Y") {
				listHtml += "			<button class=\"ui basic small button toggle_commentwrite\"><spring:message code='forum.button.cmnt'/> <spring:message code='forum.button.write'/></button>"; // 댓글 작성하기
			}
			listHtml += "			</div>";
			}
			listHtml += "		</div>";
			
			// 댓글 폼
			listHtml += "	<div class=\"ui box\">";
			listHtml += "		<div class=\"toggle_box pt10 commentwrite\" id='toggleBox"+ i +"' style=\"display: none;\">";
			listHtml += "			<ul class=\"comment-write bcdark1Alpha05 p8\">";
			listHtml += "				<li><label for='cmntText"+ i +"' class='hide'>comment</label><textarea rows=\"3\" class=\"wmax\" placeholder=\"<spring:message code='forum.label.input.cmnt'/>\" id='cmntText"+ i +"'></textarea></li>"; // 댓글을 입력하세요
			listHtml += "				<li class=\"flex-item flex-wrap\">";
			if(v.aplyAsnYn == "Y") {
			listHtml += "					<div class=\"ui checkbox f080 mra\">";
			listHtml += "						<input type=\"checkbox\" tabindex=\"0\" class=\"hidden\" name='ansReqYn"+ i +"' id='ansReqYn"+ i +"'"+ (v.atclSn == "" ? " checked" : "") +">";
			listHtml += "						<label><spring:message code='forum.checkbox.label.fdbk.request'/> <span class=\"\">( <spring:message code='forum.checkbox.label.fdbk.request.info'/>)</span></label>"; // 피드백 문의, 체크 시 문의로 등록되며 답변을 받을 수 있습니다. 
			listHtml += "					</div>";
			}
			listHtml += "					<a href=\"javascript:addCmnt('"+ v.atclSn +"','','"+ i +"');\" class=\"ui basic grey small button\"><spring:message code='forum.button.reg'/></a>"; // 등록
			listHtml += "				</li>";
			listHtml += "			</ul>";
			listHtml += "		</div>";
			listHtml += "	</div>";
			
//			listHtml += "			<div class='article p10 commentlist' id='article"+ i +"'></div>";
			listHtml += "			<div class='article p10 commentlist' id='article"+ i +"'>";

			v.cmntList.forEach(function(rs, index) {
				//날짜 format변환
				var yyyy = rs.modDttm.substr(0,4);
				var mm = rs.modDttm.substr(4,2);
				var dd = rs.modDttm.substr(6,2);
				var h = rs.modDttm.substr(8,2);
				var m = rs.modDttm.substr(10,2);
				
				var regDate = yyyy + "." + mm + "." + dd + "(" + h + ":" + m + ")";
				var userImg = rs.phtFile != null ? rs.phtFile : "/webdoc/img/icon-hycu-symbol-grey.svg";

				if(rs.level == 1) {
					listHtml += "	<ul>";
					listHtml += "		<li class=\"imgBox\">";
					listHtml += "			<div class=\"label circle\"><img src='"+userImg+"' alt=\"<spring:message code='forum.common.user.img' />\"></div>";
					listHtml += "		</li>";
					listHtml += "		<li>";
					listHtml += "			<ul>";
					listHtml += "				<li class=\"flex-item\">";
					listHtml += "					<em class=\"mra mt0\">"+ rs.regNm;
					listHtml += " 						<code>";
					listHtml += 							regDate;
					if(rs.delYn != "Y") {
						listHtml += " | <em class='fcBlue'><spring:message code='forum.label.length'/> : "+ rs.cmntCtsLen +"<spring:message code='forum.label.word'/></em>"; // 글자수, 자	
					}
					listHtml += "						</code>";
					listHtml += "					</em>";
				
					if(rs.rgtrId == "${userId}" && rs.delYn == "N") {
						if(($("#bbsTeamCd").val() == "${meTeamNm}") || ($("#bbsTeamCd").val() != "${meTeamNm}" && "${vo.otherTeamAplyYn}" == "Y") || $("#bbsTeamCd").val() == undefined) {
							if(PROFESSOR_VIRTUAL_LOGIN_YN != "Y" && "${vo.writeAuth}" == "Y") {
								listHtml += "		<button type=\"button\" class=\"toggle_btn\" onclick=\"btnAddCmnt('"+index+"','"+i+"','"+rs.atclSn+"','"+rs.cmntSn+"')\"><spring:message code='forum.button.cmnt'/></button>"; // 댓글
							}
						}
						listHtml += "				<ul class=\"ui icon top right pointing dropdown\" tabindex=\"0\">";
						listHtml += "					<i class=\"xi-ellipsis-v p5\"></i>";
						listHtml += "					<div class=\"menu\" tabindex=\"-1\">";
						listHtml += "						<button type=\"button\" class=\"item\" onClick=\"editBtnClick('"+rs.atclSn+"','"+rs.rgtrId+"','"+rs.cmntSn+"','"+index+"','"+i+"','"+rs.level+"', '"+ rs.ansReqYn +"')\"><spring:message code='forum.button.mod'/></button>"; // 수정
						listHtml += "						<button type=\"button\" class=\"item\" onClick=\"delCmnt('"+rs.rgtrId+"','"+rs.cmntSn+"')\"><spring:message code='forum.button.del'/></button>"; // 삭제
						listHtml += "					</div>";
						listHtml += "				</ul>";
					}
					listHtml += "				</li>";
					listHtml += "				<li id=\"cmntContents"+index+i+"\">";
					if(rs.delYn == "Y") {
						listHtml += "				<span class=\"ui red label\"><spring:message code='forum.label.del.forum.cmnt'/></span>"; // 삭제된 댓글 입니다.
					} else {
						listHtml += rs.cmntCts;
					}
					listHtml += "				</li>";
					if(rs.delYn != "Y") {
						listHtml += "			<li class=\"toggle_box\" id=\"toggleCmnt"+ index + i +"\" >";
						listHtml += "				<ul class=\"comment-write\">";
						listHtml += "					<li>";
						listHtml += "						<textarea rows=\"3\" class=\"wmax\" id=\"cmntText"+ index + i +"\" placeholder=\"<spring:message code='forum.alert.input.forum_reply'/>\"></textarea>"; // 댓글을 입력하세요
						listHtml += "					</li>";
						listHtml += "					<li id=\"btnCmnt"+index+i+"\">";
						listHtml += "						<a href=\"javascript:addCmnt('"+rs.atclSn+"','"+rs.cmntSn+"','"+index+"','"+i+"')\" class=\"ui basic grey small button\"><spring:message code='forum.button.reg'/></a>"; // 등록
						listHtml += "					</li>";
						listHtml += "				</ul>";
						listHtml += "			</li>";
					}
					listHtml += "			</ul>";
					listHtml += "		</li>";
					listHtml += "	</ul>";
				} else {
					listHtml += "	<ul class=\"co_inner\">";
					listHtml += "		<li class=\"imgBox\">";
					listHtml += "			<div class=\"label circle\"><img src='"+userImg+"' alt=\"<spring:message code='forum.common.user.img' />\"></div>";
					listHtml += "		</li>";
					listHtml += "		<li>";
					listHtml += "			<ul>";
					listHtml += "				<li class=\"flex-item\">";
					listHtml += "					<em class=\"mra mt0\">"+ rs.regNm;
					listHtml += " 						<code>";
					listHtml += 							regDate;
					if(rs.delYn != "Y") {
						listHtml += " | <em class='fcBlue'><spring:message code='forum.label.length'/> : "+ rs.cmntCtsLen +"<spring:message code='forum.label.word'/></em>"; // 글자수, 자	
					}
					listHtml += "						</code>";
					listHtml += "					</em>";
					if(rs.rgtrId == "${userId}" && rs.delYn == "N") {
						if(PROFESSOR_VIRTUAL_LOGIN_YN != "Y" && "${vo.writeAuth}" == "Y") {
							listHtml += "			<button type=\"button\" class=\"toggle_btn\" onclick=\"btnAddCmnt('"+index+"','"+i+"','"+rs.atclSn+"','"+rs.cmntSn+"')\"><spring:message code='forum.button.cmnt'/></button>"; // 댓글
						}
						listHtml += "				<ul class=\"ui icon top right pointing dropdown\" tabindex=\"0\">";
						listHtml += "					<i class=\"xi-ellipsis-v p5\"></i>";
						listHtml += "					<div class=\"menu\" tabindex=\"-1\">";
						listHtml += "						<button type=\"button\" class=\"item\" onClick=\"editBtnClick('"+rs.atclSn+"','"+rs.rgtrId+"','"+rs.cmntSn+"','"+index+"','"+i+"','"+rs.level+"', '"+ rs.ansReqYn +"')\"><spring:message code='forum.button.mod'/></button>"; // 수정
						listHtml += "						<button type=\"button\" class=\"item\" onClick=\"delCmnt('"+rs.rgtrId+"','"+rs.cmntSn+"')\"><spring:message code='forum.button.del'/></button>"; // 삭제
						listHtml += "					</div>";
						listHtml += "				</ul>";
					}
					listHtml += "				</li>";
					listHtml += "				<li id=\"cmntContents"+index+i+"\">";
					if(rs.delYn == "Y") {
						listHtml += "				<span class=\"ui red label\"><spring:message code='forum.label.del.forum.cmnt'/></span>"; // 삭제된 댓글 입니다.
					} else {
						listHtml += "				<em class=\"mra\">@"+ rs.parRegNm +"</em> "+ rs.cmntCts;
					}
					listHtml += "				</li>";
					if(rs.delYn != "Y") {
						listHtml += "			<li class=\"toggle_box\" id=\"toggleCmnt"+ index + i +"\">";
						listHtml += "				<ul class=\"comment-write\">";
						listHtml += "					<li>";
						listHtml += "						<textarea rows=\"3\" class=\"wmax\" id=\"cmntText"+ index + i +"\" placeholder=\"<spring:message code='forum.alert.input.forum_reply'/>\"></textarea>"; // 댓글을 입력하세요
						listHtml += "					</li>";
						listHtml += "					<li id=\"btnCmnt"+index+i+"\">";
						listHtml += "						<a href=\"javascript:addCmnt('"+rs.atclSn+"','"+rs.cmntSn+"','"+index+"','"+i+"')\" class=\"ui basic grey small button\"><spring:message code='forum.button.reg'/></a>"; // 등록
						listHtml += "					</li>";
						listHtml += "				</ul>";
						listHtml += "			</li>";
					}
					listHtml += "			</ul>";
					listHtml += "		</li>";
					listHtml += "	</ul>";
				}
			});

			listHtml += "</div>";
			listHtml += "</div>";

//			listHtml += "		</div>";
			listHtml += "	</div>";
		});
	}
	return listHtml;
}

//댓글 작성 버튼
function cmntWirte(atclSn,index) {
	if(!$("#toggleBox"+index ).hasClass("on")) { // 댓글 폼이 off일 때
		$("#toggleBox"+index ).addClass("on").removeClass("off");
		$("#toggleBox"+index).css("display", "block");
//		$("#cmntWrite"+index).children("i").removeClass("down").addClass("up");
	} else { // 댓글 폼이 on일 때
		$("#toggleBox"+index ).addClass("off").removeClass("on");
		$("#toggleBox"+index).css("display", "none");
//		$("#cmntWrite"+index).children("i").removeClass("up").addClass("down");
	}
}

//댓글 등록	
function addCmnt(atclSn, parCmntSn ,index,i) {
	var ansReqYn = "N";
	var cmntCts ="";
	if(parCmntSn == null || parCmntSn == ''){
		if($("#ansReqYn"+ index).is(":checked") == true) {
			ansReqYn = "Y";
		}
		cmntCts = $("#cmntText" + index).val();
	}else{
		if($("#ansReqYn"+ index + i).is(":checked") == true) {
			ansReqYn = "Y";
		}
		cmntCts = $("#cmntText"+index+i).val().trim();
	}
	if(cmntCts == null || cmntCts == ""){
		alert("<spring:message code='forum.alert.input.reply'/>");//댓글을 입력해주시기 바랍니다.
		$("#toggleBox"+index ).addClass("off").removeClass("on");
	}else{
		$("#cmntText" + index).val('');
		
		var url = "/forum/forumHome/Form/addCmnt.do";
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
			if(data.result > 0) {
				alert("<spring:message code='forum.alert.reg_success.reply'/>");// 댓글 등록에 성공하였습니다.
			} else {
				alert("<spring:message code='forum.alert.reg_fail.reply'/>");// 댓글 등록에 실패하였습니다. 다시 시도해주시기 바랍니다.
			}
			listForum($("#currentIndex").val());
		}, function(xhr, status, error) {
			alert("<spring:message code='forum.common.error'/>"); // 에러가 발생했습니다!
		}, true);
	}
}

//댓글 보기
function cmntView(atclSn, index){
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

//게시글 수정 버튼
function editAtclBtn(atclSn,rgtrId){
	$("#atclSn").val(atclSn);
	$("#forumListForm").attr("target", "forumAtclIfm");
	$("#forumListForm").attr("action", "/forum/forumHome/Form/editForumBbs.do");
	$("#forumListForm").submit();
	$('#forumAtclPop').modal('show');
}

//게시글 삭제
function delAtcl(atclSn,rgtrId){
	var result = confirm("<spring:message code='forum.button.confirm.del' />"); // 정말 삭제하시겠습니까?
	if(!result) { return false; }

	var url = "/forum/forumHome/Form/delAtcl.do";
	var data = {
		"atclSn" : atclSn,
		"forumCd" : "${vo.forumCd}",
		"userId" : "${userId}"
	};

	ajaxCall(url, data, function(data) {
		if(data.result > 0) {
			alert("<spring:message code='forum.alert.del.forum.atcl_success'/>"); // 게시글 삭제에 성공하였습니다.
			listForum();
		} else {
			alert("<spring:message code='forum.alert.del.forum.atcl_fail'/>"); // 게시글 삭제에 실패하였습니다. 다시 시도해주시기 바랍니다.
			listForum();
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='forum.common.error'/>"); // 에러가 발생했습니다!
	}, true);
}

//댓글의 댓글 버튼
function btnAddCmnt(index,i,atclSn,cmntSn){
	if($("#toggleCmnt"+index+i).hasClass("on")){
		$("#toggleCmnt"+index+i).addClass("off").removeClass("on");
//		$("#toggleCmnt"+index+i).css("display", "block");
//		$("#cmntCts"+index+i).find("i").removeClass("down").addClass("up");
		$("#cmntText"+index+i).val('');
		var btn = "";
		btn += "<li id=\"btnCmnt"+index+i+"\">";
		btn += "	<a href=\"javascript:addCmnt('"+atclSn+"','"+cmntSn+"','"+index+"','"+i+"')\" class=\"ui blue button cmntWriteBtn\"><spring:message code='forum.button.cmnt'/> <spring:message code='forum.button.reg'/></a>"; // 댓글, 등록
		btn += "</li>";
		$("#btnCmnt"+index+i).after(btn);
		$("#btnCmnt"+index+i).remove();
	}else{
		$("#toggleCmnt"+index+i).addClass("on").removeClass("off");
//		$("#toggleCmnt"+index+i).css("display", "none");
//		$("#cmntCts"+index+i).find("i").removeClass("up").addClass("down");
		$("#cmntText"+index+i).val('');
		var btn = "";
		btn += "<li id=\"btnCmnt"+index+i+"\">";
		btn += "	<a href=\"javascript:addCmnt('"+atclSn+"','"+cmntSn+"','"+index+"','"+i+"')\" class=\"ui blue button cmntWriteBtn\"><spring:message code='forum.button.cmnt'/> <spring:message code='forum.button.reg'/></a>"; // 댓글, 등록
		btn += "</li>";
		$("#btnCmnt"+index+i).after(btn);
		$("#btnCmnt"+index+i).remove();
	}
}

//댓글 수정 버튼 클릭
function editBtnClick(atclSn,rgtrId,cmntSn,index,i,level, ansReqYn) {
	if(!$("#toggleCmnt"+index+i).hasClass("on")){
		$("#toggleCmnt"+index+i).addClass("on").removeClass("off");
//		$("#toggleCmnt"+index+i).css("display", "block");
//		$("#cmntCts"+index+i).find("i").removeClass("down").addClass("up");
		var cmntCts = $("#cmntContents"+index + i).text();
		$("#cmntText"+index+i).val(cmntCts);
		if(ansReqYn == "Y") {
			$("#ansReqYn"+index+i).prop("checked", true);
		}
		var btn = "";
		btn += "<li id=\"btnCmnt"+index+i+"\">";
		btn += "	<a href=\"javascript:editCmnt('"+atclSn+"','"+cmntSn+"','"+index+"','"+i+"','"+level+"')\" class=\"ui basic grey small button\"><spring:message code='forum.button.mod'/></a>"; // 수정
		btn += "</li>";
		$("#btnCmnt"+index+i).after(btn);
		$("#btnCmnt"+index+i).remove();
	}else{
		$("#toggleCmnt"+index+i).addClass("off").removeClass("on");
//		$("#toggleCmnt"+index+i).css("display", "none");
//		$("#cmntCts"+index+i).find("i").removeClass("up").addClass("down");
		$("#cmntText"+index+i).val('');
		if(ansReqYn == "Y") {
			$("#ansReqYn"+index+i).prop("checked", true);
		}
		var btn = "";
		btn += "<li id=\"btnCmnt"+index+i+"\">";
		btn += "	<a href=\"javascript:addCmnt('"+atclSn+"','"+cmntSn+"','"+index+"','"+i+"','"+level+"')\" class=\"ui basic grey small button\"><spring:message code='forum.button.reg'/></a>"; // 등록
		btn += "</li>";
		$("#btnCmnt"+index+i).after(btn);
		$("#btnCmnt"+index+i).remove();
	}
}

//댓글 수정
function editCmnt(atclSn,cmntSn,index,i,level){
	var ansReqYn = "N";
	var cmntCts = "";
	if(level == null || level == ''){
		if($("#ansReqYn"+ index).is(":checked") == true) {
			ansReqYn = "Y";
		}
		cmntCts= $("#cmntText" + index).val();
		$("#cmntText" + index).val('');
	}else{
		if($("#ansReqYn"+ index + i).is(":checked") == true) {
			ansReqYn = "Y";
		}
		cmntCts = $("#cmntText"+index+i).val().trim();
	}
	if(cmntCts == null || cmntCts == ""){
		alert("<spring:message code='forum.alert.input.reply'/>");//댓글을 입력해주시기 바랍니다.
		return false;
	}

	var url = "/forum/forumHome/Form/editCmnt.do";
	var data = {
		"ansReqYn" : ansReqYn,
		"cmntSn" : cmntSn,
		"cmntCts" : cmntCts
	};

	ajaxCall(url, data, function(data) {
		if (data.result > 0) {
			alert("<spring:message code='forum.alert.mod_success.reply'/>"); // 댓글 수정에 성공하였습니다.
			listForum();
		} else {
			alert("<spring:message code='forum.alert.mod_fail.reply'/>"); // 댓글 수정에 실패하였습니다. 다시 시도해주시기 바랍니다.
			listForum();
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='forum.common.error'/>"); // 에러가 발생했습니다!
	}, true);
}

//댓글 삭제
function delCmnt(rgtrId,cmntSn) {
	var result = confirm("<spring:message code='forum.button.confirm.del' />"); // 정말 삭제하시겠습니까?
	if(!result) { return false; }
	
	var url = "/forum/forumHome/Form/delCmnt.do";
	var data = {
		"cmntSn" : cmntSn,
		"userId" : "${userId}"
	};
	
	ajaxCall(url, data, function(data) {
		if(data.result > 0) {
			alert("<spring:message code='forum.forumBBsManage.alert.del_success'/>"); // 댓글 삭제에 성공하였습니다.
			listForum();
		} else {
			alert("<spring:message code='forum.forumBBsManage.alert.del_fail'/>"); // 댓글 삭제에 실패하였습니다. 다시 시도해주시기 바랍니다.
			listForum();
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='forum.common.error'/>"); // 에러가 발생했습니다!
	}, true);
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
				html += "	<td class=\"tc\">"+ v.lineNo +"</td>";
				html += "	<td>"+ v.deptNm +"</td>";
				// 학번 6~8 자리 *, 이름 2번째 자리 *
				var userId = v.userId;
				var userIdLen = userId.length;
				userId = userId.substring(0, 5) + "***"+ userId.substring(8, userIdLen);
				
				var userNm = v.userNm;
				var userNmLen = userNm.length;
				userNm = userNm.substring(0, 1) + "*"+ userNm.substring(2, userNmLen);
				html += "	<td class=\"tc\">"+ userId +"</td>";
				html += "	<td class=\"tc\">"+ userNm +"</td>";
				html += "	<td class=\"tc\">"+ v.forumMyAtclCnt +"/"+ v.forumAtclCnt +"</td>";
				html += "	<td class=\"tc\">"+ v.forumMyCmntCnt +"/"+ v.forumCmntCnt +"</td>";
				if(v.evalRsltOpenYn == "Y") {
					html += "<td class=\"tc\">";
					var mutAvg = v.mutAvg;
					for(i = 1; i <= 5; i++) {
						if(mutAvg >= i) html += "<i class=\"star icon orange\"></i>";
						else html += "<i class=\"star outline icon\"></i>";
					}
					html += "</td>";
				}
				html += "	<td class=\"tc\">"+ v.mutCnt +"</td>";
				html += "	<td class=\"tc\">";
				if(v.userId != "${userId}") {
					if(v.mutSn == null) {
						if(v.forumMyAtclCnt > 0 || v.forumMyCmntCnt > 0) {
							html += "		<a href=\"javascript:void(0);\" class=\"ui basic small button  " + (PROFESSOR_VIRTUAL_LOGIN_YN == "Y" ? 'disabled' : '') + "\" onclick=\"evalStarModal('${vo.forumCd}','"+ v.stdNo +"','"+ v.userId +"', '')\"><spring:message code='forum.button.eval.do'/></a>"; //평가하기 
						} else {
							html += "		<a href=\"javascript:void(0);\" class=\"ui basic small button  " + (PROFESSOR_VIRTUAL_LOGIN_YN == "Y" ? 'disabled' : '') + "\" onclick=\"alert('<spring:message code='forum.alert.eval.empty'/>')\"><spring:message code='forum.button.eval.do'/></a>"; // 평가할 게시물이 존재하지 않아 평가를 진행할 수 없습니다., 평가하기
						}
						
					} else {
						html += "		<a href=\"#0\" class=\"ui basic small button  " + (PROFESSOR_VIRTUAL_LOGIN_YN == "Y" ? 'disabled' : '') + "\" onclick=\"evalStarModal('${vo.forumCd}','"+ v.stdNo +"','"+ v.userId +"', '"+ v.mutSn +"')\"><spring:message code='forum.button.eval.do'/></a>"; // 수정하기
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

//팀 구성원 보기
function teamMemberView(teamCtgrCd) {
	$("#teamCtgrCd").val(teamCtgrCd);
	$("#teamMemberForm").attr("target", "teamMemberIfm");
	$("#teamMemberForm").attr("action", "/forum/forumHome/teamMemberList.do");
	$("#teamMemberForm").submit();
	$('#teamMemberPop').modal('show');
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
	<form name="forumListForm" id="forumListForm" action="" method="POST">
		<input type="hidden" id="forumCd" name="forumCd" value="${vo.forumCd}" />
		<input type="hidden" id="forumCtgrCd" name="forumCtgrCd" value="${vo.forumCtgrCd}" />
		<input type="hidden" id="prosConsForumCfg" name="prosConsForumCfg" value="${vo.prosConsForumCfg}" />
		<input type="hidden" id="crsCreCd" name="crsCreCd" value="${vo.crsCreCd}" />
		<input type="hidden" id="userId" name="userId" value="${userId}" />
		<input type="hidden" id="teamStdList" name="teamStdList" />
		<input type="hidden" id="userName" name="userName" value="${userName}" />
		<input type="hidden" id="atclSn" name="atclSn" />
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
								<%--
								<div class="ui breadcrumb small">
									<small class="section"><spring:message code='forum.label.info'/><!-- 정보 --></small>
								</div>
								--%>
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

								<div class="ui form">

									<div id="tab1" class="tab_content" style="display: block">
										<div class="flex mt10 mb10">
											<div class="button-area mla">
												<c:if test="${PROFESSOR_VIRTUAL_LOGIN_YN ne 'Y' && vo.writeAuth eq 'Y' }">
												<a href="javascript:void(0)" onclick="forumWritePop('${vo.crsCreCd }', '${stdNo}')" class="ui blue button"><spring:message code='forum.button.atcl.write'/><!-- 글쓰기 --></a>
												</c:if>
												<a href="#0" class="ui basic button" onclick="forumList()"><spring:message code='forum.label.list'/><!-- 목록 --></a>
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
															<%-- 
															<dt>
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
															</dd> 
															--%>
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
																	<button class="ui icon small button" id="file1_${list.fileSn }" title="<spring:message code='forum.label.attachFile.download'/>" onclick="fileDown('${list.fileSn}', '${list.repoCd }')"><i class="ion-android-download"></i> </button><!-- 파일다운로드 -->
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
										
										<!-- 토론 등록 글 시작 -->
										<div class="sixteen wide tablet ten wide computer column mt20">
											<c:if test="${vo.otherTeamViewYn eq 'Y' }">
												<div class="option-content mb5">
													<select class="ui dropdown" tabindex="0" id="bbsTeamCd" onchange="listForum()">
														<c:forEach var="teamItem" items="${teamCtgrList }">
															<option value="${teamItem.teamNm }" ${meTeamNm eq teamItem.teamNm ? 'selected' : '' }>${teamItem.teamNm }</option>
														</c:forEach>
													</select>
												</div>
											</c:if>
											<div class="option-content">
												<div class="ui action input search-box">
													<label for="searchValue" class="hide"><spring:message code='forum.label.user.no'/></label>
													<input type="text" id="searchValue" placeholder="<spring:message code='forum.label.user.no'/>, <spring:message code='forum.label.user_nm'/> <spring:message code='forum.label.input'/>" /><!-- 학번,이름 입력 -->
													<a class="ui icon button" onclick="listForum(1);">
														<i class="search icon"></i>
													</a>
												</div>
												<div class="button-area flex-left-auto">
													<div class="ui dropdown list-num selection" tabindex="0">
														<label for="listScale" class="hide">list scale</label>
														<select id="listScale" onchange="listForum();">
															<option value="10">10</option>
															<option value="20">20</option>
															<option value="50">50</option>
															<option value="100">100</option>
														</select>
														<i class="dropdown icon"></i>
														<div class="text">10</div>
														<div class="menu" tabindex="-1">
															<div class="item active selected" data-value="10">10</div>
															<div class="item" data-value="20">20</div>
															<div class="item" data-value="50">50</div>
															<div class="item" data-value="100">100</div>
														</div>
													</div>
												</div>
											</div>
											<div class="ui attached message element">
												<div id="atclList" class="mt20"></div>
												<div id="paging" class="paging"></div>
											</div>
										</div>
										<!-- 토론 등록 글 끝 -->
									</div>

									<!-- 토론 글쓰기 팝업 --> 
									<form id="forumWritePopForm" name="forumWritePopForm">
										<input type="hidden" name="stdNo" id="stdNo" />
										<input type="hidden" name="forumCd" id="forumCd" />
										<input type="hidden" name="atclSn" id="atclSn" />
										<input type="hidden" name="crsCreCd" id="crsCreCd" />
									</form>
									<div class="modal fade" id="forumWriteModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="forum.label.forum" /><spring:message code="forum.button.atcl.write" />" aria-hidden="false" style="display: none; padding-right: 17px;"><!-- 토론 글쓰기 -->
										<div class="modal-dialog modal-lg forumWrite" role="document">
											<div class="modal-content">
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='forum.button.close' />"><!-- 닫기 -->
														<span aria-hidden="true">&times;</span>
													</button>
													<h4 class="modal-title info"><spring:message code="forum.label.forum" /><spring:message code="forum.button.atcl.write" /><!-- 토론 글쓰기 --></h4>
												</div>
												<div class="modal-body">
													<iframe src="" width="100%" id="forumWritePopIfm" name="forumWritePopIfm" title="write frame"></iframe>
												</div>
											</div>
										</div>
									</div>

									<!-- 토론 글쓰기 팝업 -->
									<div class="modal fade" id="forumAtclPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="forum.label.forum" /><spring:message code="forum.button.atcl.write" />" aria-hidden="false">
										<div class="modal-dialog modal-lg forumWrite" role="document">
											<div class="modal-content">
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='forum.button.close' />"><!-- 닫기 -->
														<span aria-hidden="true">&times;</span>
													</button>
													<h4 class="modal-title"><spring:message code="forum.label.forum" /><spring:message code="forum.button.atcl.write" /><!-- 토론 글쓰기 --></h4>
												</div>
												<div class="modal-body">
													<iframe src="" id="forumAtclIfm" name="forumAtclIfm" width="100%" scrolling="no" title="write frame"></iframe>
												</div>
											</div>
										</div>
									</div>
									<script>
									$('iframe').iFrameResize();
									window.closeModal = function() {
										$('.modal').modal('hide');
									};
									</script>

									<!-- 상호평가 탭 시작 -->
									<div id="tab2" class="tab_content" style="display: none;">
										<%--
										<div id="info-item-box" class="" style="left: 60px;">
											<h2 class="ui header"><spring:message code='forum.label.mut.eval'/> <spring:message code='forum.button.forum.join'/><!-- 상호평가 참여하기 --></h2>
										</div>
										--%>
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
											<%--
											<div class="title active">
												<i class="dropdown icon"></i>
												<div class="title-header">
													<section>${vo.forumTitle}</section>
													<fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss" value="${vo.forumStartDttm }" />
													<fmt:formatDate var="forumStartDttm" pattern="yyyy.MM.dd(HH:mm)" value="${startDateFmt }" />
													<fmt:parseDate var="endDateFmt" pattern="yyyyMMddHHmmss" value="${vo.forumEndDttm }" />
													<fmt:formatDate var="forumEndDttm" pattern="yyyy.MM.dd(HH:mm)" value="${endDateFmt }" />
													<p class="author"><spring:message code='forum.label.forum.date' /><!-- 토론기간 --> : ${forumStartDttm} ~ ${forumEndDttm}</p>
												</div>
											</div>
											--%>

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
															<%--
															<dt>
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
															</dd>
															--%>
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
																	<button class="ui icon small button" id="file2_${list.fileSn }" title="<spring:message code='forum.label.attachFile.download'/>" onclick="fileDown('${list.fileSn}', '${list.repoCd }')"><i class="ion-android-download"></i> </button><!-- 파일다운로드 -->
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

										<%--
										<!-- 상호평가 시작 -->
										<h4 class="ui top attached header"><spring:message code='forum.label.my'/> <spring:message code='forum.label.mut.eval'/> <spring:message code='forum.label.result'/><!-- 나의 상호평가 결과 --></h4>
										<div class="ui bottom attached segment" id="evalInfo">
											<div class="ui stackable two column grid">
												<!-- subParam4 : crsCreStdCnt 개설과정 학생수 -->
												<input type="hidden" id="crsCreStdCnt" name="crsCreStdCnt" value="10">
												<input type="hidden" id="evalTrgtCnt" name="evalTrgtCnt" value="2">
												<!-- <input type="hidden" id="evalCtgr" name="evalCtgr" value="T"> -->
												<input type="hidden" id="forumCtgrCd" name="forumCtgrCd" value="NORMAL">
												<div class="column">
													<div class="field">
														<label class="label-title-lg"><spring:message code='forum.label.eval.date' /><!-- 평가 기간 --></label>
														${forumStartDttm} ~ ${forumEndDttm}
													</div>
													<div class="inline field">
														<label class="label-title-lg"><spring:message code='forum.label.eval.person' /><!-- 평가 인원 --></label>
														${forumMutVO.mutCnt} <spring:message code='forum.label.person' /><!-- 명 -->
													</div>
													<div class="inline field">
														<label class="label-title-lg"><spring:message code='forum.label.mutEval.avg' /><!-- 평균 별점 --></label>
														<c:set var="mutAvg" value="${forumMutVO.mutAvg}" />
														<c:forEach var="i" begin="1" end="5">
															<c:choose>
																<c:when test="${ mutAvg ge i }">
																	<i class="star icon orange"></i>
																</c:when>
																<c:otherwise>
																	<i class="star outline icon"></i>
																</c:otherwise>
															</c:choose>
														</c:forEach>
														(${forumMutVO.mutAvg})
													</div>
												</div>
												<div class="column">
													<canvas id="pieChart" height="150"></canvas>
													<script>
													var ctx = document.getElementById("pieChart");
													var myChart = new Chart(ctx, {
														type: 'pie',
														data: {
														labels: ["<spring:message code='forum.label.partici.yes' />", "<spring:message code='forum.label.partici.non' />"], // 참여자, 미참여자 
														datasets: [{
															backgroundColor: [
																'#36a2eb',
																'#ff6384',
																'#ff9f40'
															],
															borderWidth:1,
															data: ["${vo.forumJoinUserCnt}","${vo.forumUserTotalCnt}"]
														}]
														},

														options: {
															pieceLabel: {
															render: function (args) {
																return args.percentage + '%';
															},
															//precision: 2,
															fontColor : '#fff'
															},
															title: {
															display: true,
															text: '<spring:message code='forum.label.partici.statistic'/> (%)', // 토론 참여 현황
															fontSize: 14,
															fontColor: "#666",
															},

															legend: {
																display: true,
																position: 'bottom',
																labels: {
																	boxWidth: 12,
																	generateLabels: function(chart) {
																		var data = chart.data;
																		if (data.labels.length && data.datasets.length) {
																			return data.labels.map(function(label, i) {
																				var meta = chart.getDatasetMeta(0);
																				var ds = data.datasets[0];
																				var arc = meta.data[i];
																				var custom = arc && arc.custom || {};
																				var getValueAtIndexOrDefault = Chart.helpers.getValueAtIndexOrDefault;
																				var arcOpts = chart.options.elements.arc;
																				var fill = custom.backgroundColor ? custom.backgroundColor : getValueAtIndexOrDefault(ds.backgroundColor, i, arcOpts.backgroundColor);
																				var stroke = custom.borderColor ? custom.borderColor : getValueAtIndexOrDefault(ds.borderColor, i, arcOpts.borderColor);
																				var bw = custom.borderWidth ? custom.borderWidth : getValueAtIndexOrDefault(ds.borderWidth, i, arcOpts.borderWidth);

																				// We get the value of the current label
																				var value = chart.config.data.datasets[arc._datasetIndex].data[arc._index];

																				return {
																					// Instead of `text: label,`
																					// We add the value to the string
																					text: label + " : " + value + "<spring:message code='forum.label.person'/>", // 명
																					fillStyle: fill,
																					strokeStyle: stroke,
																					lineWidth: bw,
																					hidden: isNaN(ds.data[i]) || meta.data[i].hidden,
																					index: i
																				};
																			});
																		} else {
																			return [];
																		}
																	}
																}
															}
														}
													});
													</script>
												</div>
											</div>
										</div>
										<!-- 상호평가 끝 -->
										--%>

										<!-- 평가 대상자 목록 시작 -->
										<h4 class="ui top attached header"><spring:message code='forum.label.eval.user.list' /><!-- 평가 대상자 목록 --></h4>
										<div class="scrollbox mCustomScrollbar _mCS_1" style="height: 680px; position: relative; overflow: visible;">
											<div id="mCSB_1" class="mCustomScrollBox mCS-dark-thin mCSB_vertical mCSB_outside" style="max-height: none;" tabindex="0">
												<div id="mCSB_1_container" class="mCSB_container mCS_y_hidden mCS_no_scrollbar_y" style="position:relative; top:0; left:0;" dir="ltr">
													<div class="ui bottom attached segment" id="evalTargetInfo">
														<h3 class="page-title" id="teamNmTitle"></h3>
														<table class="table type2" data-sorting="true" data-paging="false" data-empty="<spring:message code='forum.common.empty' />" style="display: table;"><!-- 등록된 내용이 없습니다. -->
															<caption class="hide">평가</caption>
															<thead>
																<tr>
																	<th scope="col" data-type="number">No</th>
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
            				</div>
            			</div>
            		</div>
				</div>
			</div>
			<!-- //본문 content 부분 -->
			<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
		</div>
	</div>

	<!-- 팀 구성원 보기 모달 -->
	<div class="modal fade" id="teamMemberPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code='forum.label.team.member.view'/>" aria-hidden="true"><!-- 팀 구성원 보기 -->
		<div class="modal-dialog full" role="document">
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
	<!-- 팀 구성원 보기 모달 -->
	<script>
	$('iframe').iFrameResize();
	window.closeModal = function(){
		$('.modal').modal('hide');
		$("#mutEvalViewIfm").attr("src", "");
	};
	</script>
</body>
</html>
