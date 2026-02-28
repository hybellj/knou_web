<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
<%@ include file="/WEB-INF/jsp/forum/common/forum_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<script type="text/javascript">
$(document).ready(function() {
	$('.toggle_commentlist').unbind('click').bind('click', function(e) {
	    $(this).closest('.comment').find('.commentlist').toggle();
	});
	$('.toggle_commentwrite').unbind('click').bind('click', function(e) {
	    $(this).closest('.comment').find('.commentwrite').toggle();
	});

	listForum(1);
	if("${forumVo.forumCtgrCd}" == "TEAM") {
		teamList();
	}
	
	$(".accordion").accordion();
});

function forumView(tab) {
	var urlMap = {
		"0" : "/forum/forumLect/Form/infoManage.do",	// 토론정보
		"1" : "/forum/forumLect/Form/bbsManage.do",		// 토론방
		"2" : "/forum/forumLect/Form/scoreManage.do",	// 토론평가
		"3" : "/forum/forumLect/Form/mutEvalResult.do",	// 상호평가
	};

	var url  = urlMap[tab];
	var form = $("<form></form>");
	form.attr("method", "POST");
	form.attr("name", "manageForm");
	form.attr("action", url);
	form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '<c:out value="${forumVo.crsCreCd}" />'}));
	form.append($('<input/>', {type: 'hidden', name: 'forumCd',  value: '<c:out value="${forumVo.forumCd}" />'}));
	form.appendTo("body");
	form.submit();
}

//토론글 리스트
function listForum(page) {
	if("${forumVo.forumCtgrCd}" == "TEAM") {
		var teamNm = $("#selectTeam option:selected").text();
	} else {
		var teamNm = "";
	}
	
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
	
	var url = "/forum/forumLect/Form/forumBbsViewList.do";
	var data = {
		"pageIndex" : page,
		"listScale" : $("#listScale").val(),
		"searchValue" : searchValue,
		"forumCd" : "${forumVo.forumCd}",
		"forumCtgrCd" : "${forumVo.forumCtgrCd}",
		"crsCreCd" : "${forumVo.crsCreCd}",
		"userId" : "${userId}",
		"userName" : "${userName}",
		"stdList" : $("#teamStdList").val(),
		"teamCtgrCd" : "${forumVo.teamCtgrCd}",
		"teamNm" : teamNm,
	};
	
	ajaxCall(url, data, function(data) {
		if(data.result > 0) {
			var returnList = data.returnList || [];
			var pageInfo = data.pageInfo;
			var html = createForumListHTML(returnList);
			
			$("#atclList").empty().html(html);
			$("#atclList .dropdown").dropdown();
			$('.ui.checkbox').checkbox();
			$(".commentlist").toggle();

			var params = {
				totalCount : pageInfo.totalRecordCount
				, listScale : pageInfo.recordCountPerPage
				, currentPageNo : pageInfo.currentPageNo
				, eventName : "listForum"
			};
			gfn_renderPaging(params);
		} else {
			alert(data.message);
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='forum.common.error'/>"); // 오류가 발생했습니다!
	}, true);
}

// 토론 글 리스트 생성
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
			var userImg = v.phtFile != null ? v.phtFile : "/webdoc/img/icon-hycu-symbol-grey.svg";
			listHtml += "<div class='ui card wmax'>";
			listHtml += "	<div class='content card-item-center'>";
			listHtml += "		<div class='flex fac flex-wrap wmax'>";
			listHtml += "			<span class='label circle mr10'><img src='"+userImg+"' alt=\"<spring:message code='forum.common.user.img' />\"></span>"; // 학습자이미지
			listHtml += "			<span class='label mr10'>"+ v.regNm +"("+ v.userId +")</span>";
			listHtml += "			<span class='label mr10 fcBlue'><spring:message code='forum.label.length'/> : "+ v.ctsLen +"<spring:message code='forum.label.word'/></span>"; // 글자수, 자 
			if(v.atclTypeCd == "NORMAL_N" || v.atclTypeCd == "TEAM_N") {
				/*
				if(v.prosConsTypeCd == "F") {
					listHtml += "<span class='label mr10 fcOlive'>FeedBack</span>";
				}
				*/
			} else {
				if(v.prosConsTypeCd == "P") {
					listHtml += "	<span class='label mr10 fcBlue'><spring:message code='forum.label.pros'/></span>"; // 찬성
				} else if(v.prosConsTypeCd == "C") {
					listHtml += "	<span class='label mr10 fcRed'><spring:message code='forum.label.cons'/></span>"; // 반대
				} else {
					//listHtml += "<span class='label mr10 fcOlive'>FeedBack</span>";
				}
			}
			var regDttm = v.regDttm.substring(0, 4) + '.' + v.regDttm.substring(4, 6) + '.' + v.regDttm.substring(6, 8) + ' (' + v.regDttm.substring(8, 10) + ':' + v.regDttm.substring(10, 12) + ')';
			listHtml += "			<span class='label mr10'><spring:message code='forum.label.reg.dttm'/> : "+ regDttm +"</span>"; // 작성일시
			listHtml += "			<span class='label mr10'><spring:message code='forum.label.attachFile'/> : "; // 첨부파일
			v.fileList.forEach(function(item, index){
				if(index > 0) {
					listHtml += " | <a href=\"javascript:fileDown('"+ item.fileSn +"', '"+ item.repoCd +"');\" class=\"link\">"+ item.fileNm +"</a>";
				} else {
					listHtml += "<a href=\"javascript:fileDown('"+ item.fileSn +"', '"+ item.repoCd +"');\" class=\"link\">"+ item.fileNm +"</a>";
				}
			});
			listHtml +="			</span>";
			//listHtml +="			<div class='mla'>";
			//listHtml += "				<span class='label mr10'><spring:message code='common.label.same.rate'/> : " + (v.konanMaxCopyRate ? "<a class='fcBlue' href='${konanCopyScoreUrl}?domain=e_forum&docId=" + v.atclSn + "' target='_blank'>" + v.konanMaxCopyRate + "%</a>" : "-") + "</span>"; // 유사율
			//listHtml +="			</div>";
			listHtml += "		</div>";
			if(v.rgtrId == "${userId}" && v.delYn == "N") {
				listHtml += "	<div class='ui top right pointing dropdown right-box'>";
				listHtml += "		<span class='bars'><spring:message code='forum.label.menu' /></span>"; // 메뉴
				listHtml += "		<div class='menu'>";
				listHtml += "			<a href=\"javascript:editAtclBtn('"+ v.atclSn +"','"+ v.rgtrId +"')\" class='item'><spring:message code='forum.button.mod'/></a>"; // 수정
				listHtml += "			<a href=\"javascript:delAtcl('"+ v.atclSn +"','"+ v.rgtrId +"')\" class='item'><spring:message code='forum.button.del'/></a>"; // 삭제
				listHtml += "		</div>";
				listHtml += "	</div>";
			}
			listHtml += "	</div>";
			listHtml += "	<div class='ui segment ml25 mr25 mt10 mb10 forumView'>";
			//var cts = v.cts.replaceAll("<", "&lt").replaceAll(">", "&gt");
			console.log("${forumVo.prosConsForumCfg}")
			if("${forumVo.prosConsForumCfg}" == "Y") {
				listHtml += "		<pre>" + v.cts + "</pre>";
			} else {
				listHtml += "		" + v.cts;
			}
			if(v.delYn == "Y") {
				listHtml += " <span class=\"ui red label p4 f080\"><spring:message code='forum.label.sapn.del.content'/></span>"; // 삭제됨
			} else {
			}
			listHtml += "	</div>";
			
			// 댓글
			listHtml += "	<div class='content comment border0'>";
			listHtml += "		<div class='ui box flex-item'>";
			listHtml += "			<div class='flex-item mra'>";
			listHtml += "				<div class='cur_point' id='cmntOpen"+ i +"' onclick=\"cmntView('"+ v.atclSn +"', '"+ i +"')\">";
			listHtml += "					<i class=\"xi-message-o f120 mr5\" aria-hidden=\"true\"></i>";
			listHtml += "					"+ v.cmntCount +"<span class='desktop_elem'><spring:message code='forum.label.cnt.forum.cmnt'/></span>"; // 개의 댓글이 있습니다.
			listHtml += "					<i class=\"xi-angle-down-min\" aria-hidden=\"true\"></i>";
			listHtml += "				</div>";
			listHtml += "			</div>";
			listHtml += "			<div id='cmntWrite"+ i +"' onclick=\"cmntWirte('"+ v.atclSn +"', '"+ i +"')\" class=\"mla\">";
			listHtml += "				<button class=\"ui basic small button toggle_commentwrite\"><spring:message code='forum.button.cmnt'/> <spring:message code='forum.button.write'/></button>"; // 댓글 작성하기
			listHtml += "			</div>";
			listHtml += "		</div>";
			
			// 댓글 폼
			listHtml += "	<div class=\"ui box\">";
			listHtml += "		<div class=\"toggle_box pt10 commentwrite\" id='toggleBox"+ i +"' style=\"display: none;\">";
			listHtml += "			<ul class=\"comment-write bcdark1Alpha05 p8\">";
			listHtml += "				<li class=\"flex-item mra\">";
			listHtml += "				<small class=\"pr4\"><spring:message code='forum.button.label.info' /></small>"; // 간편답글
			listHtml += "					<a href=\"javascript:setCts(0, "+ i +");\" id='cts0' class=\"ui basic mini label\"><spring:message code='forum.button.cts0' /></a>"; // 수고했어요.
			listHtml += "					<a href=\"javascript:setCts(1, "+ i +");\" id='cts1' class=\"ui basic mini label\"><spring:message code='forum.button.cts1' /></a>"; // 고생하셨어요.
			listHtml += "					<a href=\"javascript:setCts(2, "+ i +");\" id='cts2' class=\"ui basic mini label\"><spring:message code='forum.button.cts2' /></a>"; // 감사합니다.
			listHtml += "				</li>";
			listHtml += "				<li><textarea rows=\"3\" class=\"wmax\" placeholder=\"<spring:message code='forum.label.input.cmnt'/>\" id='cmntText"+ i +"'></textarea></li>"; // 댓글을 입력하세요
			listHtml += "				<li class=\"flex-item flex-wrap\">";
			listHtml += "					<div class=\"ui checkbox f080 mra\">";
//			listHtml += "						<input type=\"checkbox\" tabindex=\"0\" class=\"hidden\" name='ansReqYn"+ i +"' id='ansReqYn"+ i +"'"+ (v.atclSn == "" ? " checked" : "") +">";
//			listHtml += "						<label><spring:message code='forum.checkbox.label.fdbk.request'/> <span class=\"\">( <spring:message code='forum.checkbox.label.fdbk.request.info'/>)</span></label>"; // 피드백 문의, 체크 시 문의로 등록되며 답변을 받을 수 있습니다.
			listHtml += "					</div>";
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
			
				if(rs.level == 1) {
					var userImg = rs.phtFile != null ? rs.phtFile : "/webdoc/img/icon-hycu-symbol-grey.svg";
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
					
					if(rs.delYn != "Y") {
						listHtml += "				<button type=\"button\" class=\"toggle_btn\" onclick=\"btnAddCmnt('"+index+"','"+i+"','"+rs.atclSn+"','"+rs.cmntSn+"')\"><spring:message code='forum.button.cmnt'/></button>"; // 댓글
						listHtml += "				<ul class=\"ui icon top right pointing dropdown\" tabindex=\"0\">";
						listHtml += "					<i class=\"xi-ellipsis-v p5\"></i>";
						listHtml += "					<div class=\"menu\" tabindex=\"-1\">";
						listHtml += "						<button type=\"button\" class=\"item\" onClick=\"editBtnClick('"+rs.atclSn+"','"+rs.rgtrId+"','"+rs.cmntSn+"','"+index+"','"+i+"','"+rs.level+"', '"+ rs.ansReqYn +"')\"><spring:message code='forum.button.mod'/></button>"; // 수정
						listHtml += "						<button type=\"button\" class=\"item\" onClick=\"delCmnt('"+rs.rgtrId+"','"+rs.cmntSn+"')\"><spring:message code='forum.button.del'/></button>"; // 삭제
						listHtml += "					</div>";
						listHtml += "				</ul>";
					}
					listHtml += "				</li>";
					if(rs.delYn == "Y") {
						listHtml += "			<li><span class=\"ui red label\"><spring:message code='forum.label.del.forum.cmnt'/></span></li>"; // 삭제된 댓글 입니다.
					} else {
						listHtml += "			<li id=\"cmntContents"+index+i+"\">"+ rs.cmntCts + "</li>";
					}
					if(rs.delYn != "Y") {
						listHtml += "			<li class=\"toggle_box\" id=\"toggleCmnt"+ index + i +"\" >";
						listHtml += "				<ul class=\"comment-write\">";
						listHtml += "					<li>";
						listHtml += "						<textarea rows=\"3\" class=\"wmax\" id=\"cmntText"+ index + i +"\" placeholder=\"<spring:message code='forum.alert.input.forum_reply'/>\"></textarea>"; // 댓글을 입력하세요
						listHtml += "					</li>";
						listHtml += "					<li id=\"btnCmnt"+index+i+"\">";
						listHtml += "						<a href=\"javascript:addCmnt('"+rs.atclSn+"','"+rs.cmntSn+"','"+index+"','"+i+"'\" class=\"ui basic grey small button\"><spring:message code='forum.button.reg'/></a>"; // 등록
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
					var userImg = rs.phtFile != null ? rs.phtFile : "/webdoc/img/icon-hycu-symbol-grey.svg";
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
					if(rs.delYn != "Y") {
						listHtml += "				<button type=\"button\" class=\"toggle_btn\" onclick=\"btnAddCmnt('"+index+"','"+i+"','"+rs.atclSn+"','"+rs.cmntSn+"')\"><spring:message code='forum.button.cmnt'/></button>"; // 댓글
						listHtml += "				<ul class=\"ui icon top right pointing dropdown\" tabindex=\"0\">";
						listHtml += "					<i class=\"xi-ellipsis-v p5\"></i>";
						listHtml += "					<div class=\"menu\" tabindex=\"-1\">";
						listHtml += "						<button type=\"button\" class=\"item\" onClick=\"editBtnClick('"+rs.atclSn+"','"+rs.rgtrId+"','"+rs.cmntSn+"','"+index+"','"+i+"','"+rs.level+"', '"+ rs.ansReqYn +"')\"><spring:message code='forum.button.mod'/></button>"; // 수정
						listHtml += "						<button type=\"button\" class=\"item\" onClick=\"delCmnt('"+rs.rgtrId+"','"+rs.cmntSn+"')\"><spring:message code='forum.button.del'/></button>"; // 삭제
						listHtml += "					</div>";
						listHtml += "				</ul>";
					}
					listHtml += "				</li>";
					if(rs.delYn == "Y") {
						listHtml += "			<li><span class=\"ui red label\"><spring:message code='forum.label.del.forum.cmnt'/></span></li>"; // 삭제된 댓글 입니다.
					} else {
						listHtml += "			<li id=\"cmntContents"+index+i+"\"><em class=\"mra\">@"+ rs.parRegNm +"</em> "+ rs.cmntCts + "</li>";
					}
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
//			listHtml += "		</div>";
			listHtml += "	</div>";

			listHtml += "</div>";

		});
	}
	return listHtml;
}

// 팀 리스트
function teamList() {
	var url = "/forum/forumLect/listTeamJson.do";
	
	var data = {
		"crsCreCd" : "${forumVo.crsCreCd}",
		"teamCtgrCd" : "${forumVo.teamCtgrCd}",
		"teamRltnCd" : "${forumVo.forumCd}",
		"teamCtgrRltnDivCd" : "FORUM"
	};
	
	ajaxCall(url, data, function(data) {
		if(data.result > 0) {
			var returnList = data.returnList || [];
			
			var teamListText = "";
			teamListText += '<ul class="flex-tab mt0 mb20">';
			teamListText += '<select class="ui dropdown mr5" id="selectTeam">';
			for(var i=0; i< returnList.length; i++){
				teamListText += '<option value="'+returnList[i].teamCd+'">' + returnList[i].teamNm + '</option>';
			}
			teamListText += '</select>';
			$("#parentDiv").prepend(teamListText);
			$("#selectTeam").dropdown();
			
			if(returnList.length > 0) {
				$("#selectTeam").change(function() {
					var teamCd = $(this).val();
					loadTeamStdList('',teamCd);
				});
				
				loadTeamStdList('', returnList[0].teamCd);
			}
		} else {
			alert("<spring:message code='forum.common.error'/>"); // 오류가 발생했습니다!
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='forum.alert.bring.stu.list_fail'/>"); //수강생 목록 가져오기에 실패하였습니다. 다시 시도해주시기 바랍니다.
	}, true);
}

//팀별 학습자 리스트 조회
function loadTeamStdList(obj,teamCd){
	$("#loadTeamStdList").load(
		"/forum/forumLect/listTeamStdSumm.do",
		{"teamRltnCd" : "${forumVo.forumCd}",
			"teamCd" : teamCd
		},
		function(){
			$.getJSON("/forum/forumLect/listTeamStdJson.do", {
				"teamCd" : teamCd
			}).done(function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					
					var obj = "";
					returnList.forEach(function(v, i) {
						if(i == 0){
							obj += v.stdNo;
						}else{
							obj += "," + v.stdNo;
						}
					});
					$("#teamStdList").val(obj);
				}
				
				listForum();
			});
		}
	);
}

// 게시글 등록 버튼
function addAtclBtn(){
	$("#forumListForm").attr("target", "forumAtclIfm");
	$("#forumListForm").attr("action", "/forum/forumLect/Form/addForumBbs.do");
	$("#forumListForm").submit();
	$('#forumAtclPop').modal('show');
}

//게시글 삭제
function delAtcl(atclSn,rgtrId){
	var result = confirm("<spring:message code='forum.button.confirm.del' />"); // 정말 삭제하시겠습니까?
	if(!result) { return false; }

	var url = "/forum/forumLect/Form/delAtcl.do";
	var data = {
		"atclSn" : atclSn,
		"forumCd" : "${forumVo.forumCd}",
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
		alert("<spring:message code='forum.common.error'/>"); // 오류가 발생했습니다!
	}, true);
}

//댓글 보기
function cmntView(atclSn, index) {
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

// 토론 댓글 리스트 생성
function createArticleListHTML(articleList, index) {
	var htmlList = "";

	$.each(articleList, function(i) {
		rs = articleList[i];

		//날짜 format변환
		var yyyy = rs.modDttm.substr(0,4);
		var mm = rs.modDttm.substr(4,2);
		var dd = rs.modDttm.substr(6,2);
		var h = rs.modDttm.substr(8,2);
		var m = rs.modDttm.substr(10,2);
		
		var regDate = yyyy + "." + mm + "." + dd + "(" + h + ":" + m + ")";

		if(rs.level == 1) {
			htmlList += "	<ul>";
			htmlList += "		<li class=\"imgBox\">";
			htmlList += "			<div class=\"initial-img sm c-4\">"+ rs.userNm +"</div>";
			htmlList += "		</li>";
			htmlList += "		<li>";
			htmlList += "			<ul>";
			htmlList += "				<li class=\"flex-item\">";
			htmlList += "					<em class=\"mra\">"+ rs.regNm +" <code>"+ regDate +" | <em class='fcBlue'><spring:message code='forum.label.length'/> : "+ rs.cmntCtsLen +"<spring:message code='forum.label.word'/></em></code></em>"; // 글자수, 자
			htmlList += "					<button type=\"button\" class=\"toggle_btn\" onclick=\"btnAddCmnt('"+index+"','"+i+"','"+rs.atclSn+"','"+rs.cmntSn+"')\"><spring:message code='forum.button.cmnt'/></button>"; // 댓글
			if(rs.delYn != "Y") {
				htmlList += "					<ul class=\"ui icon top right pointing dropdown\" tabindex=\"0\">";
				htmlList += "						<i class=\"xi-ellipsis-v p5\"></i>";
				htmlList += "						<div class=\"menu\" tabindex=\"-1\">";
				htmlList += "							<button type=\"button\" class=\"item\" onClick=\"editBtnClick('"+rs.atclSn+"','"+rs.rgtrId+"','"+rs.cmntSn+"','"+index+"','"+i+"','"+rs.level+"', '"+ rs.ansReqYn +"')\"><spring:message code='forum.button.mod'/></button>"; // 수정
				htmlList += "							<button type=\"button\" class=\"item\" onClick=\"delCmnt('"+rs.rgtrId+"','"+rs.cmntSn+"')\"><spring:message code='forum.button.del'/></button>"; // 삭제
				htmlList += "						</div>";
				htmlList += "					</ul>";
			}
			htmlList += "				</li>";
			htmlList += "				<li id=\"cmntContents"+index+i+"\">"+ rs.cmntCts;
			if(rs.delYn == "Y") {
				htmlList += " <span class=\"ui red label p4 f080\"><spring:message code='forum.label.sapn.del.content'/></span>"; // 삭제됨
			}
			htmlList += "</li>";
			htmlList += "				<li class=\"toggle_box\" id=\"toggleCmnt"+ index + i +"\" >";
			htmlList += "					<ul class=\"comment-write\">";
			htmlList += "						<li>";
			htmlList += "							<textarea rows=\"3\" class=\"wmax\" id=\"cmntText"+ index + i +"\" placeholder=\"<spring:message code='forum.alert.input.forum_reply'/>\"></textarea>"; // 댓글을 입력하세요
			htmlList += "						</li>";
			htmlList += "						<li id=\"btnCmnt"+index+i+"\">";
			htmlList += "							<a href=\"javascript:addCmnt('"+rs.atclSn+"','"+rs.cmntSn+"','"+index+"','"+i+"'\" class=\"ui basic grey small button\"><spring:message code='forum.button.reg'/></a>"; // 등록
			htmlList += "						</li>";
			htmlList += "					</ul>";
			htmlList += "				</li>";
			htmlList += "			</ul>";
			htmlList += "		</li>";
			htmlList += "	</ul>";
		} else {
			htmlList += "	<ul class=\"co_inner\">";
			htmlList += "		<li class=\"imgBox\">";
			htmlList += "			<div class=\"initial-img sm c-4\">"+ rs.userNm +"</div>";
			htmlList += "		</li>";
			htmlList += "		<li>";
			htmlList += "			<ul>";
			htmlList += "				<li class=\"flex-item\">";
			htmlList += "					<em class=\"mra\">"+ rs.regNm +" <code>"+ regDate +" | <em class='fcBlue'><spring:message code='forum.label.length'/> : "+ rs.cmntCtsLen +"<spring:message code='forum.label.word'/></em></code></em>"; // 글자수, 자
			htmlList += "					<button type=\"button\" class=\"toggle_btn\" onclick=\"btnAddCmnt('"+index+"','"+i+"','"+rs.atclSn+"','"+rs.cmntSn+"')\"><spring:message code='forum.button.cmnt'/></button>"; // 댓글
			if(rs.delYn != "Y") {
				htmlList += "					<ul class=\"ui icon top right pointing dropdown\" tabindex=\"0\">";
				htmlList += "						<i class=\"xi-ellipsis-v p5\"></i>";
				htmlList += "						<div class=\"menu\" tabindex=\"-1\">";
				htmlList += "							<button type=\"button\" class=\"item\" onClick=\"editBtnClick('"+rs.atclSn+"','"+rs.rgtrId+"','"+rs.cmntSn+"','"+index+"','"+i+"','"+rs.level+"', '"+ rs.ansReqYn +"')\"><spring:message code='forum.button.mod'/></button>"; // 수정
				htmlList += "							<button type=\"button\" class=\"item\" onClick=\"delCmnt('"+rs.rgtrId+"','"+rs.cmntSn+"')\"><spring:message code='forum.button.del'/></button>"; // 삭제
				htmlList += "						</div>";
				htmlList += "					</ul>";
			}
			htmlList += "				</li>";
			htmlList += "				<li id=\"cmntContents"+index+i+"\"><em class=\"mra\">@"+ rs.parRegNm +"</em> "+ rs.cmntCts;
			if(rs.delYn == "Y") {
				htmlList += " <span class=\"ui red label p4 f080\"><spring:message code='forum.label.sapn.del.content'/></span>"; // 삭제됨
			}
			htmlList += "</li>";
			htmlList += "				<li class=\"toggle_box\" id=\"toggleCmnt"+ index + i +"\">";
			htmlList += "					<ul class=\"comment-write\">";
			htmlList += "						<li>";
			htmlList += "							<textarea rows=\"3\" class=\"wmax\" id=\"cmntText"+ index + i +"\" placeholder=\"<spring:message code='forum.alert.input.forum_reply'/>\"></textarea>"; // 댓글을 입력하세요
			htmlList += "						</li>";
			htmlList += "						<li id=\"btnCmnt"+index+i+"\">";
			htmlList += "							<a href=\"javascript:addCmnt('"+rs.atclSn+"','"+rs.cmntSn+"','"+index+"','"+i+"')\" class=\"ui basic grey small button\"><spring:message code='forum.button.reg'/></a>"; // 등록
			htmlList += "						</li>";
			htmlList += "					</ul>";
			htmlList += "				</li>";
			htmlList += "			</ul>";
			htmlList += "		</li>";
			htmlList += "	</ul>";
		}
	});
	return htmlList;
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
		
		var url = "/forum/forumLect/Form/addCmnt.do";
		var data = {
			"ansReqYn" : ansReqYn,
			"atclSn" : atclSn,
			"cmntCts" : cmntCts,
			"parCmntSn" : parCmntSn,
			"forumCd" : "${forumVo.forumCd}",
			"userId" : "${userId}",
			"userName" : "${userName}",
			"crsCreCd" : "${forumVo.crsCreCd}"
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				alert("<spring:message code='forum.alert.reg_success.reply'/>");// 댓글 등록에 성공하였습니다.
			} else {
				alert("<spring:message code='forum.alert.reg_fail.reply'/>");// 댓글 등록에 실패하였습니다. 다시 시도해주시기 바랍니다.
			}
			listForum($("#currentIndex").val());
		}, function(xhr, status, error) {
			alert("<spring:message code='forum.common.error'/>"); // 오류가 발생했습니다!
		}, true);
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

// 댓글 수정
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

	var url = "/forum/forumLect/Form/editCmnt.do";
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
		alert("<spring:message code='forum.common.error'/>"); // 오류가 발생했습니다!
	}, true);
}

//댓글 삭제
function delCmnt(rgtrId,cmntSn) {
	var result = confirm("<spring:message code='forum.button.confirm.del' />"); // 정말 삭제하시겠습니까?
	if(!result) { return false; }
	
	var url = "/forum/forumLect/Form/delCmnt.do";
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
		alert("<spring:message code='forum.common.error'/>"); // 오류가 발생했습니다!
	});
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
		btn += "	<a href=\"javascript:addCmnt('"+atclSn+"','"+cmntSn+"','"+index+"','"+i+"')\" class=\"ui basic grey small button\"><spring:message code='forum.button.cmnt'/> <spring:message code='forum.button.reg'/></a>"; // 댓글, 등록
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
		btn += "	<a href=\"javascript:addCmnt('"+atclSn+"','"+cmntSn+"','"+index+"','"+i+"')\" class=\"ui basic grey small button\"><spring:message code='forum.button.reg'/></a>"; // 등록
		btn += "</li>";
		$("#btnCmnt"+index+i).after(btn);
		$("#btnCmnt"+index+i).remove();
	}
}

//댓글의 댓글 수정 버튼
function btnEditCmnt(index,i,level,cmntSn,atclSn){
	var cmntCts = $("#cmntCts"+index+i).text().trim();
	
	if(!$("#toggleCmnt"+index+i).hasClass("on")){
		var btn = "";
		btn += "<li id=\"editBtnCmnt\">";
		btn += "<a class=\"ui basic grey small button\" onclick=\"editCmnt('"+atclSn+"','"+cmntSn+"','"+index+"','"+i+"','"+level+"');\" ><spring:message code='forum.button.mod'/></a>"; // 수정
		btn += "</li>";
		
		$("#toggleCmnt"+index+i).children().find('li#addBtnCmnt').after(btn);
		$("#toggleCmnt"+index+i).children().find('li#addBtnCmnt').remove();
		$("#toggleCmnt"+index+i).children().find('textarea#cmnt'+index+i).val(cmntCts);
		
		$("#toggleCmnt"+index+i).addClass("on").removeClass("off");
	}else{
		var btn = "";
		btn += "<li id=\"addBtnCmnt\">";
		btn += "<a class=\"ui basic grey small button\" onclick=\"addCmnt('"+atclSn+"','"+cmntSn+"','"+index+"','"+i+"');\" ><spring:message code='forum.button.reg'/></a>"; // 등록
		btn += "</li>";
		
		$("#toggleCmnt"+index+i).children().find('li#editBtnCmnt').after(btn);
		$("#toggleCmnt"+index+i).children().find('li#editBtnCmnt').remove();
		
		$("#toggleCmnt"+index+i).addClass("off").removeClass("on");
	} 
}

//게시글 수정 버튼
function editAtclBtn(atclSn,rgtrId){
	$("#atclSn").val(atclSn);
	$("#forumListForm").attr("target", "forumAtclIfm");
	$("#forumListForm").attr("action", "/forum/forumLect/Form/editForumBbs.do");
	$("#forumListForm").submit();
	$('#forumAtclPop').modal('show');
}

// 간편답글 세팅
function setCts(index, i) {
	if(index == 0) {
		$("#cmntText"+ i).val($("#cts0").text());
	} else if(index == 1) {
		$("#cmntText"+ i).val($("#cts1").text());
	} else {
		$("#cmntText"+ i).val($("#cts2").text());
	}
}

//팀 구성원 보기
function teamMemberView(teamCtgrCd) {
	$("#teamCtgrCd").val(teamCtgrCd);
	$("#teamMemberForm").attr("target", "teamMemberIfm");
	$("#teamMemberForm").attr("action", "/forum/forumLect/teamMemberList.do");
	$("#teamMemberForm").submit();
	$('#teamMemberPop').modal('show');
}

//목록
function viewForumList() {
	var url  = "/forum/forumLect/Form/forumList.do";
	var form = $("<form></form>");
	form.attr("method", "POST");
	form.attr("name", "listForm");
	form.attr("action", url);
	form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: "${forumVo.crsCreCd}"}));
	form.appendTo("body");
	form.submit();
}

//토론 수정
function editForum(forumCd,forumStartDttm) {
/*
	var date = new Date();
	var year = date.getFullYear();
	var month = ("0" + (1 + date.getMonth())).slice(-2);
	var day = ("0" + date.getDate()).slice(-2);
	var hours = ("0" + date.getHours()).slice(-2);
	var minutes = ("0" + date.getMinutes()).slice(-2);
	var seconds = ("0" + date.getSeconds()).slice(-2);

	var today = year + month + day + hours + minutes + seconds;

	//토론 시작했으면 수정 X
	if(forumStartDttm <= today ){
		alert("<spring:message code='forum.alert.ontask.not.modify'/>"); // 진행중인 토론은 수정이 불가능합니다.
		return false;
	}else{
*/
		var url  = "/forum/forumLect/Form/editForumForm.do";
		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "editForm");
		form.attr("action", url);
		form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '<c:out value="${forumVo.crsCreCd}" />'}));
		form.append($('<input/>', {type: 'hidden', name: 'forumCd',   value: '<c:out value="${forumVo.forumCd}" />'}));
		form.appendTo("body");
		form.submit();
/*
	}
*/
}

//토론삭제
function delForum(forumCd) {
	var result = confirm("<spring:message code='forum.alert.confirm.delete'/>"); // 정말 토론을 삭제 하시겠습니까?

	if(!result){return false;}

	var form = $("<form></form>");
	form.attr("method", "POST");
	form.attr("name", "forumForm");
	form.attr("action", "/forum/forumLect/Form/delForum.do");
	form.append($('<input/>', {type: 'hidden', name: 'forumCd', value: forumCd}));
	form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '<c:out value="${forumVo.crsCreCd}" />'}));
	form.appendTo("body");
	form.submit();
}

function downExcel() {
	var excelGrid = {
	    colModel:[
            {label:'<spring:message code="common.number.no" />', 			name:'lineNo', 		align:'right', 	width:'1000'}, // NO
            {label:'<spring:message code="score.label.crs.cre.nm" />', 		name:'crsCreNm', 	align:'left', 	width:'7000'}, // 과목명
            {label:'<spring:message code="common.label.decls.no" />', 		name:'declsNo', 	align:'center', width:'2500'}, // 분반
            {label:'<spring:message code="forum.label.user.no" />', 		name:'rgtrId', 		align:'center', width:'4000'}, // 학번
            {label:'<spring:message code="forum.label.user_nm" />', 		name:'userNm', 		align:'left', 	width:'5000'}, // 이름
            {label:'<spring:message code="forum.label.forum.joinCnt" />', 	name:'cts', 		align:'left', 	width:'20000', wrapText: true}, // 참여글
            {label:'<spring:message code="forum.label.length" />', 			name:'ctsLen', 		align:'right', 	width:'2500'}, // 글자수
            {label:'<spring:message code="forum.label.attachFile" />', 		name:'fileNm', 		align:'left', 	width:'5000'}, // 첨부파일
            {label:'<spring:message code="forum.label.reg.dttm" />', 		name:'regDttm', 	align:'center', width:'5000', formatter: 'date', formatOptions: {srcformat:'yyyyMMddHHmmss', newformat: 'yyyy.MM.dd HH:mm'}}, // 작성일시
		]
	};
	
	var url  = "/forum/forumLect/downExcelForumAtclList.do";
	var form = $("<form></form>");
	form.attr("method", "POST");
	form.attr("name", "excelForm");
	form.attr("action", url);
	
	form.append($('<input/>', {type: 'hidden', name: 'forumCd',		value: "${forumVo.forumCd}"}));
	form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   value: JSON.stringify(excelGrid)}));
	form.appendTo("body");
	form.submit();
	
	$("form[name=excelForm]").remove();
}
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
    <form id="teamMemberForm" name="teamMemberForm" action="" method="POST">
    <input type="hidden" name="teamCtgrCd" id="teamCtgrCd">
    </form>
    <form name="forumListForm" id="forumListForm" action="" method="POST">
        <input type="hidden" id="forumCd" name="forumCd" value="${forumVo.forumCd}" />
        <input type="hidden" id="forumCtgrCd" name="forumCtgrCd" value="${forumVo.forumCtgrCd}" />
        <input type="hidden" id="prosConsForumCfg" name="prosConsForumCfg" value="${forumVo.prosConsForumCfg}" />
        <input type="hidden" id="crsCreCd" name="crsCreCd" value="${forumVo.crsCreCd}" />
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
                               <spring:message code='forum.label.forum'/><!-- 토론 -->
                            </h2>
                            
                            <div class="button-area">
                                <%--
                                <a href="javascript:void(0)" class="ui blue button"
                                    onclick="addAtclBtn()"><spring:message code='forum.label.join.bbs.insert'/><!-- 참여글 등록 --></a>
                                --%>
                                <a href="javascript:void(0)" class="ui blue button" onclick="editForum('${forumVo.forumCd}','${forumVo.forumStartDttm}')"><spring:message code='forum.button.mod'/><!-- 수정 --></a>
                                <a href="javascript:void(0)" class="ui basic button" onclick="delForum('${forumVo.forumCd}');"><spring:message code='forum.button.del'/><!-- 삭제 --></a>
                                <a href="javascript:void(0)" class="ui basic button" onclick="viewForumList()"><spring:message code='forum.label.list'/><!-- 목록 --></a>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col">
                                <div class="listTab">
                                    <ul class="">  
                                        <%-- <li class="mw120"><a href="javascript:void(0)" onclick="forumView(0)"><spring:message code='forum.label.forum.info'/><!-- 토론정보 --></a></li> --%>
                                        <li class="select mw120"><a  href="javascript:void(0)" onclick="forumView(1)"><spring:message code='forum.label.forum.bbs'/><!-- 토론방 --></a></li>
                                        <li class="mw120"><a href="javascript:void(0)" onclick="forumView(2)"><spring:message code='forum.label.forum.info.score'/><!-- 토론정보 및 평가 --></a></li>
                                    	<c:if test="${forumVo.mutEvalYn eq 'Y'}">
                                   		<li class="mw120"><a href="javascript:void(0)" onclick="forumView(3)"><spring:message code='forum.label.mut.eval' /><!-- 상호평가 --></a></li>
                                    	</c:if>
                                    </ul>
                                </div>

                                <!-- 토론정보 시작 -->
                                <div class="ui segment">
                                	<%@ include file="/WEB-INF/jsp/forum/common/forum_info_inc.jsp" %>
                                </div>

                                <c:if test="${forumVo.forumCtgrCd eq 'TEAM'}">
                                    <div class="option-content mt20" id="parentDiv">
                                    </div>
                                </c:if>

                                <c:if test="${forumVo.prosConsForumCfg eq 'Y'}">
                                    <!-- 찬반 토론일 경우 출력 시작  -->
                                    <div class="ui segment">
                                        <div class="inline field">
                                            <div class="ui checkbox read-only info">
                                                <input type="checkbox" checked> <label><spring:message
                                                        code='forum.label.pros.cons.forum.config' /></label>
                                                <!-- 찬반 토론을 설정합니다. -->
                                            </div>
                                        </div>
                                        <div class="field">
                                            <div id="graph-01" class="ui blue progress">
                                                <div class="bar">
                                                    <div class="progress"></div>
                                                </div>
                                                <div class="label">
                                                    <spring:message code='forum.label.pros.status' />
                                                </div>
                                                <!-- 찬성 현황 -->
                                            </div>
                                            <script>
                                        $('#graph-01').progress({
                                            percent:"${(forumVo.forumAtclPorsCnt / forumVo.forumAtclCnt)*100}"
                                        });
                                        </script>
                                        </div>
                                        <div class="field">
                                            <div id="graph-02" class="ui red progress">
                                                <div class="bar">
                                                    <div class="progress"></div>
                                                </div>
                                                <div class="label">
                                                    <spring:message code='forum.label.cons.status' />
                                                </div>
                                                <!-- 반대 현황 -->
                                            </div>
                                            <script>
                                        $('#graph-02').progress({
                                            percent:"${(forumVo.forumAtclConsCnt / forumVo.forumAtclCnt)*100}"
                                        });
                                        </script>
                                        </div>
                                    </div>
                                    <!-- 찬반 토론일 경우 출력 끝  -->
                                </c:if>
                                <!-- 팀별 학습자 리스트 시작 -->
                                <div id="loadTeamStdList"></div>
                                <!-- 팀별 학습자 리스트 끝 -->
                                <!-- 토론정보 끝 -->

                                <!-- 토론 참여글 시작 -->
                                <div class="ui segment">
                                    <div class="option-content mb15">
                                        <div class="ui action input search-box">
                                            <input type="text" placeholder="<spring:message code='forum.label.user.no' />, <spring:message code='forum.label.user_nm' /> <spring:message code='forum.label.input' />" class="w250"
                                                id="searchValue"><!-- 학번, 이름 입력 -->
                                            <button class="ui icon button" onclick="listForum(1)">
                                                <i class="search icon"></i>
                                            </button>
                                        </div>
                                        <div class="flex-left-auto">
                                        	<a href="javascript:void(0)" onclick="downExcel();" class="ui green button"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></a>
	                                        <select class="ui dropdown list-num" id="listScale" onchange="listForum();">
	                                            <option value="10">10</option>
	                                            <option value="20">20</option>
	                                            <option value="50">50</option>
	                                            <option value="100">100</option>
	                                        </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="ui attached message element">
                                    <div id="atclList" class="mt20"></div>
                                    <div id="paging" class="paging"></div>
                                </div>
                                <!-- 토론 참여글 끝-->
                            </div>
                            </div>
                        </div>
                    </div>
                </div>
                <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
            </div>
        </div>
        <!-- 토론 글쓰기 팝업 -->
        <div class="modal fade" id="forumAtclPop" tabindex="-1"
            role="dialog"
            aria-labelledby="<spring:message code="forum.label.forum" /><!-- 토론 --> <spring:message code="forum.button.atcl.write" /><!-- 글쓰기 -->"
            aria-hidden="false">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal"
                            aria-label="<spring:message code='forum.button.close' />">
                            <!-- 닫기 -->
                            <span aria-hidden="true">&times;</span>
                        </button>
                        <h4 class="modal-title">
                            <spring:message code="forum.label.forum" />
                            <!-- 토론 -->
                            <spring:message code="forum.button.atcl.write" />
                            <!-- 글쓰기 -->
                        </h4>
                    </div>
                    <div class="modal-body">
                        <iframe src="" id="forumAtclIfm" name="forumAtclIfm" width="100%" scrolling="no"></iframe>
                    </div>
                </div>
            </div>
        </div>
        <!-- 토론 글쓰기 팝업 -->
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
                        <iframe src="" id="teamMemberIfm" name="teamMemberIfm" width="100%" scrolling="no"></iframe>
                    </div>
                </div>
            </div>
        </div>
        <!-- 팀 구성원 보기 모달 -->
        <script>
        $('iframe').iFrameResize();
        window.closeModal = function(){
            $('.modal').modal('hide');
        };
        </script>
</body>
</html>
