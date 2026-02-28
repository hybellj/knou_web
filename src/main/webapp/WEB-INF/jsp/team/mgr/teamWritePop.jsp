<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
</head>
   
<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>

<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div class="body-content sub-depth">

		<div class="swapLists align-items-stretch">
			<div class="swapListsItem flex flex-column">
				<div class="option-content mb10">
					<label for="b1" class="mra"><spring:message code='team.popup.notMemberList'/></label><!-- 팀 구성이 안된 수강생 목록 -->
					<div class="ui action input search-box">
						<input type="text" placeholder="<spring:message code='team.popup.search.placeholder'/>" id="searchValue"><!-- 학과, 학번, 이름 입력 -->
						<button class="ui icon button" onclick="listStd(1);"><i class="search icon"></i></button>
					</div>
				</div>
				<div id="listStdDiv"></div>
			</div>
		
			<div class="button-area align-self-center">
				<button class="ui basic icon button" data-medi-ui="swap" data-swap-to="right" data-swap-target="tr" data-swap-arrival="tbody" title="<spring:message code='team.popup.button.right'/>"><!-- 오른쪽으로 이동 -->
					<i class="arrow right icon"></i>
				</button>
		
				<button class="ui basic icon button" data-medi-ui="swap" data-swap-to="left" data-swap-target="tr" data-swap-arrival="tbody" title="<spring:message code='team.popup.button.left'/>"><!-- 왼쪽으로 이동 -->
					<i class="arrow left icon"></i>
				</button>
			</div>
		
			<div class="swapListsItem flex flex-column">
				<div class="option-content mb10" style="height:38px">
					<label for="b1"><spring:message code='team.popup.teamMemberList'/></label><!-- 팀원 목록 -->
					<%-- <c:if test="${not empty teamStdList }">
						<div class="field flex flex-wrap gap4 p0 pl10">
	                        <div class="inline-flex-item">팀명</div>
	                        <div class="inline-flex-item">
	                            <div class="ui input">
	                                <input type="text" autocomplete="off" id="teamNm" value="${teamVo.teamNm }">
	                            </div>
	                        </div>
	                    </div>
					</c:if> --%>
					<!--
					<div class="ui action input search-box">
						<input type="text" id="b1" placeholder="<spring:message code='team.popup.search.placeholder'/>">
						<button class="ui icon button"><i class="search icon"></i></button>
					</div>
					-->
					<button class="ui button basic mla" onclick="readerClear();"><spring:message code='team.label.leader.not.use'/><!-- 팀장 사용안함 --></button>
				</div>
				<table id="rightTable" class="table tbl_fix type2" data-sorting="true" data-empty="<spring:message code="common.content.not_found" />">
					<thead>
						<tr>
							<th class="tl wf5" data-sortable="false">
								<div class="ui checkbox">
									<input type="checkbox" name="rightCheck" id="rightCheck" tabindex="0" class="hidden" onchange="rightAll()">
									<label class="" for="rightCheck"></label>
								</div>
							</th>
							<th class="tc wf5" data-sortable="false"><spring:message code="main.common.number.no" /><!-- NO --></th>
							<th class="tl wf15"><spring:message code='team.popup.deptNm'/><!-- 학과 --></th>
							<th class="tc wf20"><spring:message code='team.popup.userId'/><!-- 학번 --></th>
							<th class="tc wf10"><spring:message code='team.popup.hy'/><!-- 학년 --></th>
							<c:if test="${creCrsVO.univGbn eq '3' or creCrsVO.univGbn eq '4'}">
								<th scope="col" class="tc wf15"><spring:message code="common.label.grsc.degr.cors.gbn" /><!-- 학위과정 --></th>
							</c:if>
							<th class="tc wf15"><spring:message code='team.popup.userNm'/><!-- 이름 --></th>
							<th class="tc wf15"><spring:message code='team.popup.score.danger'/><!-- 평점/위험지수 --></th>
							<th class="tc wf15" data-sortable="false"><spring:message code='team.popup.leaderYn'/><!-- 팀장부여 --></th>
						</tr>
					</thead>
					<tbody id="teamTbody" class="h500">
						<c:if test="${not empty teamStdList }">
							<c:forEach items="${teamStdList}" var="item" varStatus="status">
								<tr>
									<td class="tc wf5">
										<div class="ui checkbox">
											<input type="checkbox" name="rCheck" id="${item.stdNo}" value="${item.stdNo}" data-userid="${item.userId}" tabindex="0" class="hidden">
											<label class="" for="${item.stdNo}"></label>
										</div>
									</td>
									<td class="tc wf5 lineNo">${item.lineNo}</td>
									<td class="tl wf15">${item.deptNm}</td>
									<td class="tc wf20">${item.userId}</td>
									<td class="tc wf10">${item.hy}</td>
									<c:if test="${creCrsVO.univGbn eq '3' or creCrsVO.univGbn eq '4'}">
										<td class="tc wf15">${item.grscDegrCorsGbnNm}</td>
									</c:if>
									<td class="tc wf15">${item.userNm}<a href='javascript:userInfoPop("${item.userId}")'><i class='ico icon-info'></i></a></td>
									<td class="tc wf15">${item.avgMrks}/${empty item.riskGrade ? '-' : item.riskGrade}</td>
									<td class="tc wf15">
										<div class="ui slider checkbox">
											<input type="radio" name="leaderCheck" ${item.leaderYn == 'Y' ? ' checked' : ''} value="${item.stdNo}">
											<label></label>
										</div>
									</td>
								</tr>
							</c:forEach>
						</c:if>
					</tbody>
				</table>
			</div>
		</div>
	</div>

	<div class="bottom-content">
	<form autocomplete="off" onsubmit="return false;" id="userForm" action="" method="POST">
		<input type="hidden" name="crsCreCd" id="crsCreCd" value="${crsCreCd }">
		<input type="hidden" name="teamCd" id="teamCd" value="${teamCd}">
		<input type="hidden" name="teamCtgrCd" id="teamCtgrCd" value="${tcVO.teamCtgrCd }">
		<input type="hidden" name="teamCtgrNm" id="teamCtgrNm" value="${tcVO.teamCtgrNm }">
		<input type="hidden" name="stdNo" id="stdNo">
		<input type="hidden" name="memberRole" id="memberRole">
	</form>
		<button class="ui blue cancel button" onclick="saveTeam()"><spring:message code='team.common.save'/><!-- 저장 --></button>
		<button class="ui black cancel button" onclick="window.parent.closeModal();window.parent.editTeamCtgr('${tcVO.teamCtgrCd }');"><spring:message code='team.common.close'/><!-- 닫기 --></button>
	</div>
</div>

<script type="text/javascript">
var stdList = new Map(); 
var lCnt = 0;
var rCnt = 0;

$(document).ready(function() {
	listStd(1);
	
	document.removeEventListener("click",clickUiDataSetHandler);
	document.addEventListener("click", clicktHandler);

	$(".footable-empty").hide();
});

function clicktHandler(e) {
	if( !e.target.closest("[data-medi-ui]") ) return;
	
    let clickElem = e.target.closest("[data-medi-ui]");
	let mediUi = clickElem.dataset.mediUi;
	
	switch( mediUi ) {
	case "customize-layout":
		document.querySelectorAll(".icon-sort").forEach(function(o, i){
			o.classList.toggle("on");
		} );
		break;
	case "swap":
		let swapLists = document.querySelectorAll(".swapLists .swapListsItem");
		let fromList, toList;
		let swapTo = clickElem.dataset.swapTo;
		let swapTarget = clickElem.dataset.swapTarget;
		let swapArrival = clickElem.dataset.swapArrival;
		
		if( swapTo == "right" ){
			fromList = swapLists[0];
			toList = swapLists[1];
		} else {
			fromList = swapLists[1];
			toList = swapLists[0];
		}

		lCnt = $("input[name=lCheck]").length;
		rCnt = $("input[name=rCheck]").length;
		
		fromList.querySelector(swapArrival)
			.querySelectorAll("input[type='checkbox']")
			.forEach(function(o,i){
				if( o.checked ){
					o.checked = false;
					if( swapTo == "right" ){ // =>
						o.closest(swapTarget).append(document.createElement("td"));
						$(o.closest(swapTarget).lastChild).html("<div class=\"ui slider checkbox\"><input type=\"radio\" name=\"leaderCheck\" value=\""+ o.value +"\"><label></label></div>");
						$(o.closest(swapTarget).lastChild).addClass("wf15");
						$(o.closest(swapTarget).lastChild).css("display", "table-cell");

						if($("input[name=lCheck]").length != lCnt) {
							$("input:checkbox[name='leftCheck']").prop("checked", false);
							$("input:checkbox[name='rightCheck']").prop("checked", false);
						}
					} else { // <=
						o.closest(swapTarget).lastElementChild.remove();
						$("#"+ o.value).attr({"name" : "lCheck"});
						if($("input[name=rCheck]").length != rCnt) {
							$("input:checkbox[name='leftCheck']").prop("checked", false);
							$("input:checkbox[name='rightCheck']").prop("checked", false);
						}
					}
					toList.querySelector(swapArrival).append(o.closest(swapTarget));
				}
			});
		
			$("#leftTable").footable();
			$("#rightTable").footable();
		
			var rCheck = $("#rightTable").find("input[name=lCheck]");
			rCheck.attr("name", "rCheck");
			
			var lCheck = $("#leftTable").find("input[name=rCheck]");
			lCheck.attr("name", "lCheck");
			
			var lLine = $("#leftTable").find("td.lineNo");
			for (var i=0; i<lLine.length; i++) {
				$(lLine[i]).html(i+1);
			}
			
			var rLine = $("#rightTable").find("td.lineNo");
			for (var i=0; i<rLine.length; i++) {
				$(rLine[i]).html(i+1);
			}
		
			addCheckEvent();
		break;
	default:
		break;
	}
}

function listStd(page) {
	var searchForm = "teamWrite";
	var teamCnt = "${teamCnt}";
	var stdNoStr = "${stdNoStr}";

	if(stdNoStr == "") {
		searchForm = "";
	}

	var url = "/std/stdHome/listStd.do";
	var data = {
		"pageIndex" : page,
		"listScale" : "0",
		"crsCreCd" : "${tcVO.crsCreCd}",
		"searchValue" : $("#searchValue").val(),
		"searchFrom" : searchForm,
		// "searchFrom" : "attendMain",
		"searchKey" : "${stdNoStr}"
	};

	ajaxCall(url, data, function(data) {
		if(data.result > 0) {
			var returnList = data.returnList || [];
			var pageInfo = data.pageInfo;
			var html = createTeamMemberListHtml(returnList);
			
			$("#listStdDiv").empty().html(html);
			
			$(".ui.checkbox").checkbox();
			
			var params = {
				totalCount : data.pageInfo.totalRecordCount,
				listScale : data.pageInfo.recordCountPerPage,
				currentPageNo : data.pageInfo.currentPageNo,
				eventName : "listStd"
			};
			gfn_renderPaging(params);
			
			$("#leftTable").footable();
			addCheckEvent();
		} else {
			alert(data.message);
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='team.common.error'/>"); // 오류가 발생했습니다!
	}, true);
}

function createTeamMemberListHtml(teamMemberList) {
	var univGbn = "${creCrsVO.univGbn}";
	var listHtml = "";

	listHtml += "	<table id=\"leftTable\" class=\"table tbl_fix type2\" data-sorting=\"true\">";
	listHtml += "		<thead>";
	listHtml += "			<tr>";
	listHtml += "				<th class=\"tl wf5\" data-sortable=\"false\">";
	listHtml += "					<div class=\"ui checkbox\" id=\"leftAllDiv\">";
	listHtml += "						<input type=\"checkbox\" name=\"leftCheck\" id=\"leftCheck\" tabindex=\"0\" class=\"hidden\" onchange=\"leftAll();\">";
	listHtml += "						<label class=\"\" for=\"leftCheck\"></label>";
	listHtml += "					</div>";
	listHtml += "				</th>";
	listHtml += "				<th class=\"tc wf5\" data-sortable=\"false\"><spring:message code='common.number.no' /></th>"; // NO.
	listHtml += "				<th class=\"tc wf15\"><spring:message code='team.popup.deptNm'/></th>"; // 학과
	listHtml += "				<th class=\"tc wf20\"><spring:message code='team.popup.userId'/></th>"; // 학번
	listHtml += "				<th class=\"tc wf10\"><spring:message code='team.popup.hy'/></th>"; // 학년
	if(univGbn == "3" || univGbn == "4") {
		listHtml += "			<th class=\"tc wf15\"><spring:message code='common.label.grsc.degr.cors.gbn'/></th>"; // 학위과정 
	}
	listHtml += "				<th class=\"tc wf15\"><spring:message code='team.popup.userNm'/></th>"; // 이름
	listHtml += "				<th class=\"tc wf15\"><spring:message code='team.popup.score.danger'/></th>"; // 평점/위험지수
	listHtml += "			</tr>";
	listHtml += "		</thead>"; 
	listHtml += "		<tbody class=\"h500\">";
	teamMemberList.forEach(function(v, i) {
		listHtml += "			<tr>";
		listHtml += "				<td class=\"tl wf5\">";
		listHtml += "					<div class=\"ui checkbox\">";
		listHtml += "						<input type=\"checkbox\" name=\"lCheck\" id=\""+ v.stdNo +"\" value=\""+ v.stdNo +"\" data-userid=\""+ v.userId +"\" tabindex=\"0\" class=\"hidden\">";
		listHtml += "						<label class=\"\" for=\""+ v.stdNo +"\"></label>";
		listHtml += "					</div>";
		listHtml += "				</td>";
		listHtml += "				<td class=\"tc wf5 lineNo\">"+ v.lineNo +"</td>";
		listHtml += "				<td class=\"tl wf15\" style='white-space:nowrap;'>"+ v.deptNm +"</td>";
		listHtml += "				<td class=\"tc wf20\">"+ v.userId +"</td>";
		listHtml += "				<td class=\"tc wf10\">"+ v.hy +"</td>";
		if(univGbn == "3" || univGbn == "4") {
			listHtml += "			<td class=\"tc wf15\">"+ (v.grscDegrCorsGbnNm || '-') +"</td>";
		}
		listHtml += "				<td class=\"tc wf15\">"+ v.userNm +"<a href='javascript:userInfoPop(\""+ v.userId +"\")'><i class='ico icon-info'></i></a></td>";
		listHtml += "				<td class=\"tc wf15\">"+ v.avgMrks +"/" + (v.riskGrade || '-') + "</td>";
		listHtml += "			</tr>";
	});
	listHtml += "		</tbody>";
	listHtml += "	</table>";
	
	return listHtml;
}

function addCheckEvent() {
	$(".ui.checkbox").off("change");
	
	//전체 체크박스 선택중 체크박스 하나를 풀었을때 "전체" 체크해제
	$("input[name='lCheck']").change(function() {
		lCnt = $("input[name=lCheck]").length;
		
		if ($("input[name='lCheck']:checked").length == 0) {
			$("#leftCheck").prop("checked", false);
		} else if ($("input[name='lCheck']:checked").length == lCnt) {
			$("#leftCheck").prop("checked", true);
		} else {
			$("#leftCheck").prop("checked", false);
		}
	});

	// 전체 체크박스 선택중 체크박스 하나를 풀었을때 "전체" 체크해제
	$("input[name='rCheck']").change(function() {
		rCnt = $("input[name=rCheck]").length;
		
		if ($("input[name='rCheck']:checked").length == 0) {
			$("#rightCheck").prop("checked", false);
		} else if ($("input[name='rCheck']:checked").length == rCnt) {
			$("#rightCheck").prop("checked", true);
		} else {
			$("#rightCheck").prop("checked", false);
		}
	});
}

// 왼쪽 전체 선택
function leftAll() {
	lCnt = $("input[name=lCheck]").length;

	if(lCnt == 0) {
		alert("<spring:message code='forum.alert.data.empty'/>"); // 선택할 데이터가 없습니다.
		$("input:checkBox[name='leftCheck']").prop("checked", true);
		return;
	} 
	if(!$("#leftCheck").is(":checked")) {
		$("input[name=lCheck]").prop("checked", false);
	} else {
		$("input[name=lCheck]").prop("checked", true);
	}
}

// 오른쪽 전체 선택
function rightAll() { 
	rCnt = $("input[name=rCheck]").length;
	if(rCnt == 0) {
		alert("<spring:message code='forum.alert.data.empty'/>"); // 선택할 데이터가 없습니다.
		$("input:checkbox[name='rightCheck']").prop("checked", true);
		return;
	}
	if(!$("#rightCheck").is(":checked")) {
		$("input[name=rCheck]").prop("checked", false);
	} else {
		$("input[name=rCheck]").prop("checked", true);
	}
}

function saveTeam() {
	$("input[name=rCheck]").each(function(idx) {
		// var value = $(this).val();
		var eqValue = $("input[name=rCheck]:eq(" + idx + ")").val();
		
		stdList.set(eqValue, this);
	});

	if(stdList.size == 0 && $("#teamCd").val() == "") {
		alert("<spring:message code='team.popup.addTeamMember'/>"); // 팀원을 추가하세요.
		return;
	}

	/*
	if(!$("input[name=leaderCheck]").is(':checked')) {
		alert("<spring:message code='team.popup.leaderChk'/>"); // 팀장여부를 체크하세요.
		return;
	}
	*/

	var stdNo = "";
	var userId = "";
	var i = 0;
	$("input:checkbox[name='rCheck']").each(function() {
		if(i == 0) {
			stdNo += this.value;
			// userId += this.data("userid");
			userId += $("#"+ this.value).data("userid");
		} else {
			stdNo += ","+ this.value;
			userId += ","+ $("#"+ this.value).data("userid");
		}
		i++;
	});
	
	/*
	var userId = "";
	var i = 0;
	$("input[name='userId']").each(function() {
		if(i == 0) {
			userId += this.value;
		} else {
			userId += ","+ this.value;
		}
		i++;
	});
	*/

	var url = "/team/teamMgr/addTeam.do";
	var data = {
		"crsCreCd" : "${tcVO.crsCreCd}",
		"teamCtgrCd" : "${tcVO.teamCtgrCd}",
		"teamCd" : $("#teamCd").val(),
		"teamNm" : $("#teamNm").val(),
		"stdNo" : stdNo,
		"userId" : userId,
		"stdRole" : $("input[name='leaderCheck']:checked").val()
	};

	ajaxCall(url, data, function(data) {
		if(data.result > 0) {
			alert("<spring:message code='team.write.teamAdd.success.alert1'/>\n<spring:message code='team.write.teamAdd.success.alert2'/>"); // 정상적으로 팀 추가 되었습니다. 다음 팀 추가 진행합니다.
			// 팀구성 완료 여부 세팅
			window.parent.teamSetYn("${tcVO.crsCreCd}", "${tcVO.teamCtgrCd}");
			//window.parent.teamEditForm("${crsCreCd}")
			window.parent.teamListDiv();
			if($("#teamCd").val() != "") {
				window.parent.closeModal();
				//window.parent.location.reload();
			}
			window.parent.editTeamCtgr('${tcVO.teamCtgrCd}');
			window.parent.addTeamForm();
		} else {
			alert(data.message);
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='team.common.error'/>"); // 오류가 발생했습니다!
	}, true);
}

//사용자 정보 팝업
function userInfoPop(userId) {
	var userInfoUrl = "${userInfoPopUrl}" + btoa(`{"stuno":"\${userId}"}`);
	var options = 'top=100, left=150, width=1200, height=800';
	window.open(userInfoUrl, "", options);
}

// 팀장 해제
function readerClear() {
	$("input[type=radio][name=leaderCheck]").prop('checked', false);
}
</script>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>