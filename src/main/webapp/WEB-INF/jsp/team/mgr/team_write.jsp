<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

<body class="<%=SessionInfo.getThemeMode(request)%>">
<form id="teamWriteForm" name="" action="" method="POST">
<input type="hidden" name="crsCreCd" id="crsCreCd" value="${vo.crsCreCd}">
<input type="hidden" name="teamCtgrCd" id="teamCtgrCd" value="${vo.teamCtgrCd}" />
<input type="hidden" name="teamCd" id="teamCd" value="${vo.teamCd}" />
<input type="hidden" name="mode" id="mode" value="${mode}" />
<input type="hidden" name="teamCnt" id="teamCnt" />
<input type="hidden" name="teamCtgrNm" id="forumTeamCtgrNm" />
<input type="hidden" name="teamBbsYn" id="forumTeamBbsYn" />
</form>

<input type="hidden" name="totalStdCount" id="totalStdCount" />
<input type="hidden" name="teamListCnt" id="teamListCnt" />
<input type="hidden" id="setStdCount" />

<div id="wrap" class="pusher">
	<%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>

	<div id="container">
		<!-- class_top 인클루드  -->
		<%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>

		<!-- 본문 content 부분 -->
		<!-- 팀 구성 등록 시작 -->
		<div class="content stu_section">
			<%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>

			<div class="ui form">
					<script>
					$(document).ready(function () {
						// set location
						setLocationBar("<spring:message code='team.write.info.subTitle1'/>", "<spring:message code='team.write.info.subTitle4'/>");
					});
					</script>

				<div class="layout2">
					<div id="info-item-box" class="">
						<h2 class="page-title">
							<c:choose>
								<c:when test="${mode eq 'A' }">
									<spring:message code='team.write.info.subTitle2'/><!-- 팀관리 : 팀구성 등록 -->
								</c:when>
								<c:otherwise>
									<spring:message code='team.write.info.subTitle4'/><!-- 팀관리 : 팀구성 등록 -->
								</c:otherwise>
							</c:choose>
						</h2>
						<div class="button-area tr mt40" id="btnButton">
							<c:choose>
								<c:when test="${mode eq 'A' }">
									<%--
										<a href="javascript:void(0)" class="ui blue button" onclick="teamAdd()"><spring:message code='team.common.save'/><!-- 저장 --></a>
									--%>
								</c:when>
								<c:otherwise>
							<a href="javascript:void(0)" class="ui blue button" onclick="teamEdit('${vo.teamCtgrCd}')"><spring:message code='team.common.save'/><!-- 저장 --></a>
								</c:otherwise>
							</c:choose>
							<a href="javascript:void(0)" class="ui blue button" onclick="teamList()"><spring:message code='team.common.list'/><!-- 목록 --></a>
						</div>
					</div>

					<div class="row">
						<div class="col">
							<div class="ui small error message">
								<i class="info circle icon"></i><spring:message code='team.label.error.message'/><!-- 팀구성 미완료시 임시저장됩니다.  -->
							</div>

							<div class="ui segment form">
								<%-- 
								<div class="option-content">
									<button class="ui basic icon button fl" title="<spring:message code='team.common.send'/>"><!-- 보내기 -->
										<i class="file audio outline icon"></i>
										<i class="envelope outline icon"></i>
										<spring:message code='team.common.send'/><!-- 보내기 -->
									</button>
								</div>
								--%>
								<div class="fields inline mt10">
									<label for="teamCtgrNm" class="req"><spring:message code='team.write.field.teamCtgrNm'/><!-- 팀분류 명 --></label>
									<div class="field">
										<div class="ui radio checkbox">
											<input type="text" id="teamCtgrNm" name="teamCtgrNm" value="${vo.teamCtgrNm}">
										</div>
									</div>
								</div>
								<div class="fields inline mt10">
									<label class="req"><spring:message code='team.write.field.teamBbs'/><!-- 팀 게시판 --></label>
									<div class="field">
										<div class="ui radio checkbox">
											<input type="radio" id="teamBbsY" name="teamBbsYn" value="Y" tabindex="0" ${vo.teamBbsYn == "Y" || empty vo.teamBbsYn ? " checked" : "" }>
											<label for="teamBbsY"><spring:message code='team.common.use.yes'/><!-- 사용 --></label>
										</div>
									</div>
									<div class="field">
										<div class="ui radio checkbox">
											<input type="radio" id="teamBbsN" name="teamBbsYn" value="N" tabindex="0" ${vo.teamBbsYn == "N" ? " checked" : "" }>
											<label for="teamBbsN"><spring:message code='team.common.use.not'/><!-- 미사용 --></label>
										</div>
									</div>
								</div>
								<div class="fields inline mt10" style="display: ${totalTeamMember eq vo.totalCnt ? 'none' : '' };">
									<label class="req"><spring:message code='team.write.field.team.create.how'/><!-- 팀 생성방법 --></label>
									<div class="field">
										<div class="ui radio checkbox">
											<input type="radio" id="teamAutoY" name="teamCreateHow" value="Y" tabindex="0" ${mode ne 'U' ? '' : 'readonly'}>
											<label for="teamAutoY"><spring:message code='team.write.field.team.create.auto'/><!-- 팀 자동 생성 --></label>
										</div>
									</div>
									<div class="field">
										<div class="ui radio checkbox">
											<input type="radio" id="teamAutoN" name="teamCreateHow" value="N" tabindex="0" ${mode eq 'U' ? 'checked' : ''}>
											<label for="teamAutoN"><spring:message code='team.write.field.team.create.nomal'/><!-- 팀 수동 생성 --></label>
										</div>
									</div>
								</div>
								<div class="fields inline mt20 p_w100" id="teamAuto" style="display: none;">
									<label for="teamCount" class="req"><spring:message code='team.write.field.teamCount'/><!-- 생성 팀수 --></label>
									<div class="field">
										<select class="ui dropdown" id="teamCount">
											<option value=""><spring:message code="common.select" /><!-- 선택 --></option>
											<fmt:parseNumber var="totalCnt" integerOnly="true" value="${vo.totalCnt / 2}" />
											<c:set var="totalCount" value="${totalCnt > 30 ? 30 : totalCnt}" />
											<c:forEach var="i" begin="2" end="${totalCount}" step="1" >
												<option value="${i}">${i}</option>
											</c:forEach>
										</select>
									</div>
									<label for="sortKey" class="req"><spring:message code='team.write.field.sortKey'/><!-- 수강생 배정 --></label>
									<div class="field">
										<select id="sortKey" class="ui dropdown" onchange="loadStdList();">
											<option value="RANDOM"><spring:message code='team.write.field.random'/><!-- 임의 배정 --></option>
											<option value="USER_NM"><spring:message code='team.write.field.userNm'/><!-- 이름순 배정 --></option>
											<option value="STD_NO"><spring:message code='team.write.field.stdNo'/><!-- 학번순 배정 --></option>
										</select>
									</div>
									<div class="field">
										<a href="javascript:void(0)" class="ui teal button" onclick="teamAutoAdd()"><spring:message code='team.write.field.team.create.auto'/><!-- 팀 자동 생성 --></a>
									</div>
									<div class="mla">
									</div>
								</div>
								<div class="fields inline mt20 p_w100" id="teamNomal" style="display: ${(mode eq 'U') and (totalTeamMember ne vo.totalCnt) ? '' : 'none'};">
									<div class="field">
										<a href="javascript:void(0)" class="ui teal button" onclick="addTeamForm()"><spring:message code='team.write.field.team.create.nomal'/><!-- 팀 수동 생성 --></a>
									</div>
									<div class="mla">
									</div>
								</div>
							</div>
			
							<div class="option-content" id="teamListTitle" style="display:none">
								<div class="more-btn">
									<span class="tit"><spring:message code="team.write.teamListTitle"/><!-- 팀 생성 목록 --></span>
									<span class="tit">(${empty totalTeamMember ? 0 : totalTeamMember}/${vo.totalCnt})</span>
								</div>
								<!-- 
								<div class="select_area">
									<div class="ui action input search-box">
										<input type="text" placeholder="팀명, 팀장명">
										<select class="ui dropdown mr5 fr" id="">
											<option value="10">10</option>
											<option value="9">9</option>
										</select>
									</div>
								</div>
								-->
							</div>

							<div id="teamListDiv"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- 팀 구성 등록 끝 -->

		<!-- 팀 만들기 모달 -->
		<div class="modal fade" id="teamWritePop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code='team.write.field.teamWrite'/>" aria-hidden="false">
			<div class="modal-dialog full" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='team.common.close'/>"><!-- 닫기 -->
							<span aria-hidden="true">&times;</span>
						</button>
						<h4 class="modal-title"><spring:message code='team.write.field.teamWrite'/><!-- 팀 만들기 --></h4>
					</div>
					<div class="modal-body">
						<iframe src="" id="teamWriteIfm" name="teamWriteIfm" width="100%" scrolling="no"></iframe>
					</div>
				</div>
			</div>
		</div>
		<!-- 팀 만들기 모달 -->
		<script>
		$('iframe').iFrameResize();
		window.closeModal = function(){
			$('.modal').modal('hide');
		};
		</script>
		<!-- //본문 content 부분 -->
	<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
	</div>
</div>

<script type="text/javascript">
var stdList = "";
$(document).ready(function () {
	loadStdList();
	teamListDiv();

	// 수정이며 팀 구성인원이 총인원 보다 적을 시에 팀 수동 생성으로 설정
	if("${totalTeamMember}" < "${vo.totalCnt}" && "${mode}" === "U") {
		$("#teamAuto").hide();
		$("#teamNomal").show();
		$("#teamAutoN").attr('checked', true);
	}
	
	// 팀 생성방법에 따른 설정
	$("input[name='teamCreateHow']").change(function() {
		if($("input[name='teamCreateHow']:checked").val() === "Y") {
			$("#teamAuto").show();
			$("#teamNomal").hide();
		} else if($("input[name='teamCreateHow']:checked").val() === "N") {{
			$("#teamAuto").hide();
			$("#teamNomal").show();
		}}
	})
});

// 수강생 목록 가져오기
function loadStdList() {
	if($("#sortKey").val() == "" || $("#sortKey").val() == undefined){
		alert("<spring:message code='team.write.sortkey.alert'/>"); // 생성 방식을 선택하세요.
		return;
	}

	var url = "/std/stdHome/listStdJson.do";
	var data = {
		"crsCreCd" : "${vo.crsCreCd}",
		"sortKey" : $("#sortKey").val(),
		"listScale" : 0
	};

	ajaxCall(url, data, function(data) {
		if(data != null) {
			if(data.length > 0) {
				stdList = data;
				totalCnt = parseInt(data.length / 2);
				$("#totalStdCount").val(totalCnt);
			} else {
				alert("<spring:message code='forum.common.no.std'/>"); // 등록된 수강생이 없습니다.
			}
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='team.common.error'/>"); // 오류가 발생했습니다!
	}, true);
}

// 팀 목록
function teamListDiv() {
	var url = "/team/teamMgr/listTeam.do";
	var data = {
			"crsCreCd" : "${vo.crsCreCd}",
			"teamCtgrCd" : $("#teamCtgrCd").val()
	};

	ajaxCall(url, data, function(data) {
		if(data.result > 0) {
			var returnList = data.returnList || [];

			if(returnList.length == 0) {
				$("#teamCnt").val("0");
			}
			var html = createTeamListDiv(returnList);
			
			$("#teamListDiv").empty().html(html);
			$("#teamListTitle").css("display", "block");
			$(".table").footable();
		} else {
			alert(data.message);
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='team.common.error'/>"); // 오류가 발생했습니다!
	}, true);
}

// 팀 목록 리스트 생성
function createTeamListDiv(teamList) {
	var teamListCnt = 0;
	var setStdCount = 0;
	var listHtml = "";
	
	listHtml += "	<table class=\"table type2 c_table mt10\" data-sorting=\"true\" data-paging=\"false\" data-empty=\"<spring:message code='team.common.empty'/>\">"; // 등록된 내용이 없습니다.
	listHtml += "		<thead>";
	listHtml += "			<tr>";
	listHtml += "				<th scope=\"col\" data-type=\"\" class=\"num\"><spring:message code='main.common.number.no' /></th>"; // NO.
	listHtml += "				<th scope=\"col\"><spring:message code='team.table.teamNm'/></th>"; // 팀명
	listHtml += "				<th scope=\"col\" data-breakpoints=\"xs\"><spring:message code='team.table.leaderNm'/></th>"; // 팀장
	listHtml += "				<th scope=\"col\" data-breakpoints=\"xs sm\"><spring:message code='team.table.teamMbrCnt'/></th>"; // 팀인원수
	listHtml += "				<th scope=\"col\" data-breakpoints=\"xs sm md\"><spring:message code='team.table.manage'/></th>"; // 관리
	listHtml += "			</tr>";
	listHtml += "		</thead>";
	listHtml += "		<tbody>";

	teamList.forEach(function(v, i) {
		teamListCnt++;
		setStdCount += Number(v.teamMbrCnt);
		listHtml += "			<tr>";
		listHtml += "				<td>";
		// listHtml += "					<div class=\"ui checkbox\"><input type=\"checkbox\" tabindex=\"0\"><label></label></div>";
		listHtml += "					"+ v.lineNo;
		listHtml += "				</td>";
		listHtml += "				<td>"+ v.teamNm +"</td>";
		if(v.leaderNm === null) {
			listHtml += "				<td><spring:message code='team.label.leader.none'/></td>"; // 팀장 없음
		} else {
			listHtml += "				<td>"+ v.leaderNm +"</td>";
		}
		listHtml += "				<td>"+ v.teamMbrCnt +"<spring:message code='team.common.memberCnt'/></td>"; // 명
		listHtml += "				<td>";
		listHtml += "					<a href=\"javascript:void(0)\" class=\"ui basic small button\" onclick=\"editTeam('"+ v.teamCd +"','"+ v.teamRltnCd +"')\"><spring:message code='forum.button.mod'/>​</a>"; // 수정
		listHtml += "					<a href=\"javascript:void(0)\" class=\"ui basic small button\" onclick=\"removeTeam('"+ v.teamCd +"','"+ v.teamNm +"')\"><spring:message code='team.common.delete'/>​</a>"; // 삭제
		listHtml += "				</td>";
		listHtml += "			</tr>";
	});
	listHtml += "		</tbody>";
	listHtml += "	</table>";
	$("#teamListCnt").val(teamListCnt);
	$("#setStdCount").val(setStdCount);
	
	return listHtml;
}

// 팀 만들기
function addTeamForm() {
	if($.trim($("#teamCtgrNm").val()) == "") {
		alert("<spring:message code='team.write.form.teamCtgrNm'/>"); // 팀분류 명을 입력하세요.
		return false;
	}

	if($("input[name=teamBbsYn]:checked").length == 0) {
		alert("<spring:message code='team.write.form.teamBbsYn'/>"); // 팀 게시판 사용 여부를 선택하세요.
		return false;
	}

	if($("#mode").val() != "A") {
		$("#btnButton > a").first().remove();
	}
	$("#btnButton").prepend('<a href="javascript:void(0)" class="ui blue button" onclick="teamEdit()"><spring:message code="team.common.save"/></a>'); // 저장

	$("#mode").val("add");
	$("#forumTeamCtgrNm").val($("#teamCtgrNm").val());
	$("#forumTeamBbsYn").val($("input[name=teamBbsYn]:checked").val());
	$("#teamWriteForm").attr("target", "teamWriteIfm");
	$("#teamWriteForm").attr("action", "/team/teamMgr/editTeam.do");
	$("#teamWriteForm").submit();
	$('#teamWritePop').modal('show');

}

// 팀 자동 생성
function teamAutoAdd() {
	if($.trim($("#teamCtgrNm").val()) == "") {
		alert("<spring:message code='team.write.form.teamCtgrNm'/>"); // 팀분류 명을 입력하세요.
		return false;
	}

	if($("input[name=teamBbsYn]:checked").length == 0) {
		alert("<spring:message code='team.write.form.teamBbsYn'/>"); // 팀 게시판 사용 여부를 선택하세요.
		return false;
	}

	var teamListCnt = $("#teamListCnt").val();
	
	if(teamListCnt > 0) {
		var result = confirm("<spring:message code='team.write.autoTeam.confirm'/>"); // 팀 자동 생성 시 모든 팀 활동 내역이 삭제고 새로 팀 구성이 됩니다. 정말 팀 자동 생성을 하시겠습니까?
	
		if(!result){return false;}
	}

	if($("#sortKey").val() == "" || $("#sortKey").val() == undefined){
		alert("<spring:message code='team.write.sortKey'/>"); // 생성 방식을 선택하세요.
		return;
	}
	
	if($("#teamCount").val() == "" || $("#teamCount").val() == undefined){
		alert("<spring:message code='team.write.teamCount'/>"); // 생성 팀 수를 선택하세요.
		return;
	}
	
	var teamCount = $("#teamCount").val() * 1;
	var stdListSize = stdList.length * 1;

	// 팀 인원은 최소 2명 이상
	// if(!(1 < teamCount && teamCount <= (stdListSize / 2))){
	if(!(1 < teamCount)){
		alert("<spring:message code='team.write.limited'/>"); // 가용범위 내의 팀 수를 선택하세요.
		return;
	}

	if($("#mode").val() != "A") {
		$("#btnButton > a").first().remove();
	}
	$("#btnButton").prepend('<a href="javascript:void(0)" class="ui blue button" onclick="teamEdit()"><spring:message code="team.common.save"/></a>'); // 저장

	showLoading();
	var resultChk = 0;
	var stdSizeOfTeam = Math.round(stdListSize / teamCount);
	for(var i = 0; i < teamCount; i++) {
		var stdNo = "";
		var stdRole = "";
		var userId = "";
		var cnt = i * stdSizeOfTeam;
		var jcnt = 0;
		if(i == (teamCount - 1)) {
			jcnt = stdListSize;
		} else {
			jcnt = stdSizeOfTeam * (i + 1);
		}
		
		for(var j = cnt; j < jcnt; j++) {
			if(j == i * stdSizeOfTeam) {
				stdNo += stdList[j].stdNo;
				stdRole = stdList[j].stdNo;
				userId += stdList[j].userId;
			} else {
				stdNo += ",";
				stdNo += stdList[j].stdNo;
				userId += ",";
				userId += stdList[j].userId;
			}
		}
		
		var url = "/team/teamMgr/addAutoTeam.do";
		var data = {
			"crsCreCd" : "${vo.crsCreCd}",
			"teamCtgrCd" : $("#teamCtgrCd").val(),
			"teamCtgrNm" : $("#teamCtgrNm").val(),
			"teamBbsYn" : $("input[name=teamBbsYn]:checked").val(),
			"resultChk" : resultChk,
			"stdNo" : stdNo,
			"stdRole" : stdRole,
			"userId" : userId,
			"lastIndex" : i
		};
		
		$.ajax({
			url : url,
			data: data,
			type: "POST",
			async : false,
			success : function(data, status, xr){
				if(data.result > 0) {
					resultChk = 1;
				}
			},
			error : function(xhr, status, error){
				alert("<spring:message code='team.common.error'/>"); // 오류가 발생했습니다!
			},
			beforeSend: function() {
			},
			complete: function() {
			},
		});
		resultChk = 1;
	}

	if(resultChk) {
		alert("<spring:message code='team.write.autoTeam.success.alert'/>"); // 정상적으로 팀을 자동 생성하였습니다.
		// 팀 자동 생성 후 해당 팀분류코드로 정보 호출
		editTeamCtgr($("#teamCtgrCd").val());
		
		// 팀구성 완료 여부 세팅
		teamSetYn("${vo.crsCreCd}", "${vo.teamCtgrCd}");
		hideLoading();
	} else {
		alert("<spring:message code='team.write.autoTeam.failed.alert'/>"); // 정상적으로 팀을 자동 생성하지  못하였습니다.
		hideLoading();
	}
}

//팀 구성 수정
function editTeamCtgr(teamCtgrCd) {
	$("#teamCtgrCd").val(teamCtgrCd);
	$("#teamWriteForm").attr("action", "/team/teamMgr/editTeamForm.do");
	$("#teamWriteForm").submit();
}

// 목록
function teamList() {
	var url = "/team/teamMgr/teamList.do";
	var form = $("<form></form>");
	form.attr("method", "POST");
	form.attr("name", "teamList");
	form.attr("action", url);
	form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: "${vo.crsCreCd}"}));
	form.appendTo("body");
	form.submit();
}

// 팀 분류 저장
function teamAdd() {
	if($.trim($("#teamCtgrNm").val()) == "") {
		alert("<spring:message code='team.write.form.teamCtgrNm'/>"); // 팀분류 명을 입력하세요.
		return false;
	}

	if($("input[name=teamBbsYn]:checked").length == 0) {
		alert("<spring:message code='team.write.form.teamBbsYn'/>"); // 팀 게시판 사용 여부를 선택하세요.
		return false;
	}
	
	var url = "/team/teamMgr/teamAdd.do";
	var data = {
		"crsCreCd" : "${vo.crsCreCd}",
		"teamCtgrCd" : $("#teamCtgrCd").val(),
		"teamCount" : $("#teamCount").val(),
		"sortKey" : $("#sortKey").val(),
		"teamCtgrNm": $("#teamCtgrNm").val(),
		"teamBbsYn" : $("input[name=teamBbsYn]:checked").val()
	};

	ajaxCall(url, data, function(data) {
		if(data.result > 0) {
			$("#mode").val('U');
			$("#teamCtgrCd").val(data.returnVO.teamCtgrCd);

			alert("<spring:message code='team.write.teamAdd.success.alert'/>"); // 정상적으로 저장되었습니다.
			$("#btnButton > a").first().remove();
			$("#btnButton").prepend('<a href="javascript:void(0)" class="ui blue button" onclick="teamEdit()"><spring:message code="team.common.save"/></a>'); // 저장
		} else {
			alert("<spring:message code='team.write.teamAdd.failed.alert'/>"); // 정상적으로 저장하지 못하였습니다.
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='team.common.error'/>"); // 오류가 발생했습니다!
	}, true);
}

// 팀 분류 수정
function teamEdit() {
	if($.trim($("#teamCtgrNm").val()) == "") {
		alert("<spring:message code='team.write.form.teamCtgrNm'/>"); // 팀분류 명을 입력하세요.
		return false;
	}
	
	if($("input[name=teamBbsYn]:checked").length == 0) {
		alert("<spring:message code='team.write.form.teamBbsYn'/>"); // 팀 게시판 사용 여부를 선택하세요.
		return false;
	}
	
	if($("#setStdCount").val() != "${vo.totalCnt}") {
		alert("팀구성이 완료되지 않았습니다.");
		return false;
	}

	var url = "/team/teamMgr/teamEdit.do";
	var data = {
		"crsCreCd" : "${crsCreCd}",
		"teamCtgrCd" : $("#teamCtgrCd").val(),
		"teamCount" : $("#teamCount").val(),
		"sortKey" : $("#sortKey").val(),
		"teamCtgrNm": $("#teamCtgrNm").val(),
		"teamBbsYn" : $("input[name=teamBbsYn]:checked").val()
	};

	ajaxCall(url, data, function(data) {
		if(data.result > 0) {
			$("#teamCtgrCd").val(data.returnVO.teamCtgrCd);
			alert("<spring:message code='team.write.teamEdit.success.alert'/>"); // 정상적으로 수정되었습니다.
			teamSetYn("${vo.crsCreCd}", "${vo.teamCtgrCd}");
			// $("#btnButton > a").first().remove();
			// $("#btnButton").prepend('<a href="javascript:void(0)" class="ui blue button" onclick="teamEdit()">저장</a>');
		} else {
			alert("<spring:message code='team.write.teamEdit.failed.alert'/>"); // 정상적으로 수정하지 못하였습니다.
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='team.common.error'/>"); // 오류가 발생했습니다!
	}, true);
}

//빈 값 체크
function nullCheck() {
	if($.trim($("#teamCtgrNm").val()) == "") {
		alert("<spring:message code='team.write.form.teamCtgrNm'/>"); // 팀분류 명을 입력하세요.
		return false;
	}
	return true;
}

// 팀 수정
function editTeam(teamCd, teamRltnCd) {
	$("#mode").val("edit");
	$("#teamCd").val(teamCd);
	$("#teamWriteForm").attr("target", "teamWriteIfm");
	$("#teamWriteForm").attr("action", "/team/teamMgr/editTeam.do");
	$("#teamWriteForm").submit();
	$('#teamWritePop').modal('show');
}

// 팀 삭제
function removeTeam(teamCd, teamNm) {
	var result = confirm("'"+ teamNm +"' <spring:message code='team.write.remove.confirm'/>"); // 팀을 정말  삭제하시겠습니까?

	if(!result) {		return false;	}

	var url = "/team/teamMgr/removeTeam.do";
	var data = {
		"teamCd" : teamCd
	};
	
	ajaxCall(url, data, function(data) {
		if(data.result > 0) {
			alert("<spring:message code='team.write.remove.success.alert'/>"); // 팀 삭제에 성공하였습니다.
			//teamListDiv();
			// 팀구성 완료 여부 세팅
			teamSetYn("${vo.crsCreCd}", "${vo.teamCtgrCd}");
			location.reload();
		} else {
			alert("<spring:message code='team.write.remove.failed.alert'/>"); // 팀 삭제에 실패하였습니다. 다시 시도해주시기 바랍니다.
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='team.common.error'/>"); // 오류가 발생했습니다!
	}, true);
}

function teamEditForm(teamCtgrCd) {
	var url = "/team/teamMgr/editTeamForm.do";
	var form = $("<form></form>");
	form.attr("method", "POST");
	form.attr("name", "teamList");
	form.attr("action", url);
	form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: "${vo.crsCreCd}"}));
	form.append($('<input/>', {type: 'hidden', name: 'teamCtgrCd', value: teamCtgrCd}));
	form.appendTo("body");
	form.submit();
}

// 팀구성 완료 여부 세팅
function teamSetYn(crsCreCd, teamCtgrCd) {
	var url = "/team/teamMgr/teamSetYn.do";
	var data = {
		"crsCreCd" : crsCreCd,
		"teamCtgrCd" : teamCtgrCd,
	};
	
	ajaxCall(url, data, function(data) {
	}, function(xhr, status, error) {
		alert("<spring:message code='team.common.error'/>"); // 오류가 발생했습니다!
	}, true);
}
</script>
</body>

</html>