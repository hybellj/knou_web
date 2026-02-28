<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

<script type="text/javascript">
$(document).ready(function () {
//	listForum(1);
	
	$("#searchValue").on("keyup", function(e) {
		if(e.keyCode == 13) {
			listForum(1);
		}
	});
	listForumType();
});

//리스트 타입 변환
function listForumType(type){
	if($("#listType i").attr("class") == "list ul icon") { // 리스트형
		$("#listType i").attr("class","th ul icon");
		$("#chgScoreRatioBtn").show();
		$(".scoreInputDiv").hide();
		$(".ui.dropdown.mr5.listScale").show()
		$(".chgScoreRatioDiv").hide();
		$("#chgScoreRatioBtn").attr("href","javascript:javascript:chgScoreRatio(1)");
		// 리스트 갯수
		$(".ui.dropdown.mr5.listScale").hide();
	} else { // 그리드형
		$("#listType i").attr("class","list ul icon");
		$(".chgScoreRatioDiv").hide();
		$(".scoreInputDiv").hide();
		$(".ui.dropdown.mr5.listScale").hide();
		$("#chgScoreRatioBtn").attr("href","javascript:javascript:chgScoreRatio(3)");
	} 
	chgScoreRatio(2);
	
	listForum(1);
}

//성적 반영비율 입력 폼 변환
function chgScoreRatio(type) {
	if(type == 1) {
		$("#chgScoreRatioBtn").hide();
		$(".chgScoreRatioDiv").css("display", "inline-block");
		$(".scoreInputDiv").show();
		$(".scoreRatioDiv").hide();
	} else if(type == 2) {
		// $("#chgScoreRatioBtn").hide();
		$("#chgScoreRatioBtn").css("display", "inline-block");
		$(".chgScoreRatioDiv").hide();
		$(".scoreInputDiv").hide();
		$(".scoreRatioDiv").show();
		$("#mode").val("L");
	} else if(type == 3) {
		listForumType(1);
		$("#mode").val("G");
	}
}

//리스트 조회
function listForum(page) {
	var url = "/forum/forumHome/forumList.do";

	var listScale = "";
	if($("#listType i").attr("class") == "list ul icon") { 
		// 그리드형
		listScale = 9999;
	} else { 
		// 리스트형
		listScale = 9999;
		// listScale = $("#listScale").val();
	}
	
	var data = {
		"crsCreCd" : "${forumVO.crsCreCd}",
		"pageIndex" : page,
		"listScale" : listScale,
		"searchValue" : $("#searchValue").val()
	};
	
	ajaxCall(url, data, function(data) {
		if(data.result > 0) {
			var returnList = data.returnList || [];
			var pageInfo = data.pageInfo;
			var html = createForumListHTML(returnList);
			
			$("#list").empty().html(html);
			if($("#listType i").attr("class") != "list ul icon") {
				$(".table").footable();
				var params = {
					totalCount : data.pageInfo.totalRecordCount,
					listScale : data.pageInfo.recordCountPerPage,
					currentPageNo : data.pageInfo.currentPageNo,
					eventName : "listForum"
				};
				// gfn_renderPaging(params);
			} else {
				$(".ui.dropdown").dropdown();
				$(".card-item-center .title-box label").unbind('click').bind('click', function(e) {
					$(".card-item-center .title-box label").toggleClass('active');
				});
			}
			$("#forumTotalCnt").text(data.pageInfo.totalRecordCount);
			// 성적반영 비율 저장 버튼 처리
			if($("#listType i").attr("class") == "list ul icon") { 
				// 그리드형
				// $("#chgScoreRatioBtn").hide();
			} else { 
				// 리스트형
				if($("#mode").val() == "G") {
					$("#chgScoreRatioBtn").hide();
					$(".chgScoreRatioDiv").css("display", "inline-block");
					$(".scoreInputDiv").css("display", "inline-block");
					$(".scoreRatioDiv").hide();
				} else {
					chgScoreRatio(2);
				}
				// chgScoreRatio(2);
				// $("#chgScoreRatioBtn").show();
				// $(".scoreInputDiv").hide();
			}
		} else {
			alert(data.message);
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='forum.common.error'/>"); // 오류가 발생했습니다!
	}, true);
}

// 토론 리스트 생성
function createForumListHTML(forumList) {
	var listHtml = "";
	if(forumList.length == 0) {
		listHtml += "	<div class=\"flex-container\">";
		listHtml += "		<div class=\"cont-none\">";
		listHtml += "			<span><spring:message code='forum.common.empty' /></span>"; // 등록된 내용이 없습니다.
		listHtml += "		</div>";
		listHtml += "	</div>";
		return listHtml;
	} else {
		
		if($("#listType i").attr("class") != "list ul icon"){
			listHtml += "	<table class=\"table type2\" data-sorting=\"false\" data-paging=\"false\" data-empty=\"<spring:message code='forum.common.empty' />\">"; // 등록된 내용이 없습니다.
			listHtml += "		<thead>";
			listHtml += "			<tr>";
			listHtml += "				<th scope=\"col\" class=\"tc num\">No</th>";
			listHtml += "				<th scope=\"col\" class='tc'><spring:message code='forum.label.type' /></th>"; // 구분
			listHtml += "				<th scope=\"col\" class='tc'><spring:message code='forum.label.forum.title' /></th>"; // 토론명
			listHtml += "				<th scope=\"col\" class='tc' data-breakpoints=\"xs sm\"><spring:message code='forum.label.forum.date' /></th>"; // 토론기간
			listHtml += "				<th scope=\"col\" class='tc' data-breakpoints=\"xs sm md\"><spring:message code='forum.label.forum.gradeRef' /></th>"; // 성적반영 비율
			listHtml += "				<th scope=\"col\" class='tc' data-breakpoints=\"xs sm md\"><spring:message code='forum.label.status.join' /></th>"; // 참여 현황
			listHtml += "				<th scope=\"col\" class='tc' data-breakpoints=\"xs sm md\"><spring:message code='forum.label.eval.status' /></th>"; // 평가 현황
			listHtml += "				<th scope=\"col\" class='tc' data-breakpoints=\"xs sm md\"><spring:message code='forum.label.forum.bbsCnt' /></th>"; // 토론 글수
			listHtml += "				<th scope=\"col\" class='tc' data-breakpoints=\"xs sm md\"><spring:message code='forum.label.forum.commCnt' /></th>"; // 댓글수
			listHtml += "				<th scope=\"col\" class='tc' data-breakpoints=\"xs sm md\"><spring:message code='forum.label.score.open' /></th>"; // 성적 공개
			listHtml += "			</tr>";
			listHtml += "		</thead>";
			listHtml += "		<tbody>";
			forumList.forEach(function(v, i) {
				var forumStartDttm = v.forumStartDttm.substring(0, 4) + '.' + v.forumStartDttm.substring(4, 6) + '.' + v.forumStartDttm.substring(6, 8) + ' ' + v.forumStartDttm.substring(8, 10) + ':' + v.forumStartDttm.substring(10, 12);
				var forumEndDttm = v.forumEndDttm.substring(0, 4) + '.' + v.forumEndDttm.substring(4, 6) + '.' + v.forumEndDttm.substring(6, 8) + ' ' + v.forumEndDttm.substring(8, 10) + ':' + v.forumEndDttm.substring(10, 12);
				listHtml += `
						<tr>
							<td class='tc'>\${v.lineNo}</td>`;
				if(v.forumCtgrCd == "TEAM") {
					listHtml += `<td class='tc'><spring:message code='forum.label.type.teamForum' /></td>`; // 팀토론
				} else if (v.forumCtgrCd == "SUBS" || v.forumCtgrCd == "EXAM") {
					if(v.stareType === "M") { // 중간
						listHtml += `<td class='tc'><label class='ui pink label'><spring:message code='forum.label.type.exam.M' /></label></td>`; // 중간고사
					} else if(v.stareType === "L") { // 기말
						listHtml += `<td class='tc'><label class='ui pink label'><spring:message code='forum.label.type.exam.L' /></label></td>`; // 기말고사
					}
				} else { 
					listHtml += `<td class='tc'><spring:message code='forum.label.type.forum' /></td>`; // 일반토론
				}
				listHtml += `
							<td><a href="javascript:forumView('\${v.forumCd}', '1');" class="link">\${v.forumTitle}</a></td>
							<td class='tc'>\${forumStartDttm } ~ \${forumEndDttm }</td>
							<td class='tc'>`;
				if(v.stareType != 'S') {
					if(v.stareType == 'M') listHtml += `<spring:message code='forum.label.type.exam.M' />`; // 중간고사
					else if(v.stareType == 'L') listHtml += `<spring:message code='forum.label.type.exam.L' />`; // 기말고사
				} else {
					if(v.scoreAplyYn == 'N') {
						listHtml += `0%`;
					} else {
						listHtml += `
								<div class="scoreInputDiv ui right labeled input">
									<input type="number" class="scoreRatio w50" data-scoreRatio="${v.scoreRatio}" data-forumCd="\${v.forumCd}" value="\${v.scoreRatio != null ? v.scoreRatio : 0}" />
									<div class='ui basic label'>%</div>
								</div>
								<div class="scoreRatioDiv">\${v.scoreRatio != null ? v.scoreRatio : 0} %</div>`;
					}
				}
				listHtml += `
							</td>
							<td class='tc'>\${v.forumJoinUserCnt}/\${v.forumUserTotalCnt}</td>
							<td class="tc"><a href="javascript:forumView('\${v.forumCd}',2);" class="fcBlue">\${v.forumEvalCnt }/\${v.forumJoinUserCnt }</a></td>
							<td class='tc'>\${v.forumAtclCnt}</td>
							<td class='tc'>\${v.forumCmntCnt}</td>
							<td class='tc'>
								<div class="ui toggle checkbox">`;
								if(v.scoreOpenYn == 'Y') {
								listHtml += `<input type="checkbox" value="\${v.forumCd}|forumOpen\${i}" onchange="changeOpenYn(this);" name="" id="toggle-\${i}" checked>`;
							} else {
								listHtml += `<input type="checkbox"value="\${v.forumCd }|forumOpen\${i}" onchange="changeOpenYn(this);" name="" id="toggle-\${i}">`;
							}
								listHtml += `<label for="toggle-\${i}"></label>`;
								listHtml += `</div>`;
						listHtml += `
								</div>
							</td>
						</tr>
				`;
			});
			listHtml += `
					</tbody>
				</table>
						<div id="paging" class="paging"></div>
			`;
		} else {
			listHtml += "<div class='ui two stackable cards info-type mt10'>";
			forumList.forEach(function(v, i) {
				var forumStartDttm = v.forumStartDttm.substring(0, 4) + '.' + v.forumStartDttm.substring(4, 6) + '.' + v.forumStartDttm.substring(6, 8) + ' ' + v.forumStartDttm.substring(8, 10) + ':' + v.forumStartDttm.substring(10, 12);
				var forumEndDttm = v.forumEndDttm.substring(0, 4) + '.' + v.forumEndDttm.substring(4, 6) + '.' + v.forumEndDttm.substring(6, 8) + ' ' + v.forumEndDttm.substring(8, 10) + ':' + v.forumEndDttm.substring(10, 12);
				var reforumStartDttm = '';
				var reforumEndDttm = '';
				if(v.reforumYn == 'Y') {
					reforumStartDttm = v.reforumStartDttm.substring(0, 4) + '.' + v.reforumStartDttm.substring(4, 6) + '.' + v.reforumStartDttm.substring(6, 8) + ' ' + v.reforumStartDttm.substring(8, 10) + ':' + v.reforumStartDttm.substring(10, 12);
					reforumEndDttm = v.reforumEndDttm.substring(0, 4) + '.' + v.reforumEndDttm.substring(4, 6) + '.' + v.reforumEndDttm.substring(6, 8) + ' ' + v.reforumEndDttm.substring(8, 10) + ':' + v.reforumEndDttm.substring(10, 12);
				}
				var forumUserCnt = v.forumTotalUserCnt - v.forumJoinUserCnt;
				var scoreRatio = 0;
				if(v.scoreRatio != null) {
					scoreRatio = v.scoreRatio;
				}
				listHtml += `
					<div class="card">
						<div class="content card-item-center">
							<div class="title-box">`;
					if(v.forumCtgrCd == 'TEAM') {
						listHtml += `
							<label class="ui orange label m-w30 active"><spring:message code='forum.label.team' /></label>`; // 팀
					}
					switch(v.forumCtgrCd) {
					case "NORMAL": // 일반토론
						listHtml += `<label class="ui orange label m-w40 active"><spring:message code='forum.label.type.forum' /></label>`; // 일반토론 
						break;
					case "TEAM": // 팀토론
						listHtml += `<label class="ui orange label m-w40 active"><spring:message code='forum.label.type.teamForum' /></label>`; // 팀토론
						break;
					case "SUBS": // 대체토론
						if(v.stareType === "M") { // 중간
							listHtml += `<label class="ui orange label m-w40 active"><spring:message code='forum.label.type.exam.M' /></label>`; // 중간고사
						} else if(v.stareType === "L") { // 기말
							listHtml += `<label class="ui orange label m-w40 active"><spring:message code='forum.label.type.exam.L' /></label>`; // 기말고사
						}
						break;
					case "EXAM": // 시험토론
						if(v.stareType === "M") { // 중간
							listHtml += `<label class="ui orange label m-w40 active"><spring:message code='forum.label.type.exam.M' /></label>`; // 중간고사
						} else if(v.stareType === "L") { // 기말
							listHtml += `<label class="ui orange label m-w40 active"><spring:message code='forum.label.type.exam.L' /></label>`; // 기말고사
						}
						break;
					}
				listHtml += `
								<a href="javascript:forumView('\${v.forumCd}', '1');" class="header header-icon link">\${v.forumTitle}</a>
							</div>
							<div class="ui top right pointing dropdown right-box">
							<span class="bars"><spring:message code='forum.label.menu' /><!--메뉴 --></span> 
							<div class="menu">
								<a href="javascript:forumView('\${v.forumCd}',1);" class="item"><spring:message code='forum.label.forum.bbs'/><!-- 토론방 --></a>
								<a href="javascript:forumView('\${v.forumCd}',2);" class="item"><spring:message code='forum.button.eval'/><!-- 토론평가 --></a>
								<a href="javascript:editForum('\${v.forumCd}','\${v.forumStartDttm}');" class="item"><spring:message code='forum.button.mod'/><!-- 수정 --></a>
								<a href="javascript:delForum('\${v.forumCd}');" class="item"><spring:message code='forum.button.del'/><!-- 삭제 --></a>
							</div>
						</div>
							
						</div>
						<div class="sum-box">
							<ul class="process-bar">
								<li class="bar-blue" style="width: \${(v.forumJoinUserCnt * 100) / v.forumUserTotalCnt}%;">\${v.forumJoinUserCnt }<spring:message code='forum.label.person'/><!-- 명 --></li>
								<li class="bar-softgrey" style="width: \${((v.forumUserTotalCnt - v.forumJoinUserCnt) * 100) / v.forumUserTotalCnt}%;">\${(v.forumUserTotalCnt - v.forumJoinUserCnt)}<spring:message code='forum.label.person'/><!-- 명 --></li>
							</ul>`;
					switch(v.forumStatus) {
						case '대기':
							listHtml += `<div class="ui basic mini label"><spring:message code='common.label.ready'/></div>`;
							break;
						case '진행중':
							listHtml += `<div class="ui blue mini label"><spring:message code='common.processing'/></div>`;
							break;
						default:
							listHtml += `<div class="ui grey mini label"><spring:message code='common.closed'/></div>`;
					}
				listHtml += `
						</div>
						<div class="content ui form equal width">
							<div class="fields">
								<div class="inline field">
									<label class="label-title-lg"><spring:message code='forum.label.forum.date'/><!-- 토론기간 --></label>
									<i>\${forumStartDttm } ~ \${forumEndDttm }</i>
								</div>
							</div>
							<div class="fields">
								<div class="inline field">
									<label class="label-title-lg"><spring:message code='forum.label.score.open'/><!-- 성적공개 --></label>
									<div class="ui toggle checkbox">`;
					if(v.scoreOpenYn == 'Y') {
						listHtml += `<input type="checkbox" value="\${v.forumCd}|forumOpen\${i}" onchange="changeOpenYn(this);" name="" id="toggle-\${i}"  checked>`;
					} else {
						listHtml += `<input type="checkbox"value="\${v.forumCd }|forumOpen\${i}" onchange="changeOpenYn(this);" name="" id="toggle-\${i}">`;
					}
						listHtml += `<label for="toggle-\${i}"></label>`;
						listHtml += `</div>`;
				listHtml += `
								</div>
							</div>
							<div class="fields">
								<div class="inline field">
									<label class="label-title-lg"><spring:message code='forum.label.score.ratio'/><!-- 성적 반영비율 --></label>`;
				if(v.stareType != "S") {
					if(v.stareType == "M") {
						listHtml += `<i><spring:message code='forum.label.type.exam.M' /></i>`; // 중간고사
					} else if(v.stareType == "L") {
						listHtml += `<i><spring:message code='forum.label.type.exam.L' /></i>`; // 기말고사
					}
				} else {
					listHtml += `<i>\${scoreRatio }%</i>`;
				}
				listHtml += `		<div class="ui basic small label fcBlue"><spring:message code='forum.label.eval'/><!-- 평가 --> \${v.forumEvalCnt} / \${v.forumJoinUserCnt}</div>
								</div>
							</div>
						</div>
					</div>
				`;
			});
			listHtml += `</div>`;
		}
		
		return listHtml;
	}
}

// 성적공개 설정
function changeOpenYn(obj){
	if($(obj).is(":checked")){
		fn_forumOpenYn($(obj).val(), "Y");
		var data = new Object();
		var splitVal = $(obj).val().split('|');
		data.forumCd = splitVal[0];
		data.forumOpenCd = splitVal[1];
	}else{
		fn_forumOpenYn($(obj).val(), "N");
		var data = new Object();
		var splitVal = $(obj).val().split('|');
		data.forumCd = splitVal[0];
		data.forumOpenCd = splitVal[1];
	}
}

// 성적 반영비율 저장
function saveScoreRatio() {
	var isChk 		  = true;
	var totScoreRatio = 0;
	var forumCds 	  = "";
	var scoreRatios   = "";
	
	$(".scoreRatio").each(function(i) {
		totScoreRatio += Number($(this).val()) - Number($(this).attr("data-scoreRatio"));
		if(i > 0) {
			forumCds += "|";
			scoreRatios += "|";
		}
		forumCds += $(this).attr("data-forumCd");
		scoreRatios += $(this).val();
		if(Number($(this).val()) < 0 || Number($(this).val()) > 100) {
			alert("<spring:message code='forum.alert.score.limit'/>"); // 점수는 0 ~ 100 점 사이로 입력해주세요.
			isChk = false;
			return false;
		}
	});

	if(isChk) {
		if(Number(totScoreRatio) != 100) {
			alert("["+totScoreRatio+"] <spring:message code='forum.alert.total'/>"); // 성적반영 비율 합이 100% 이이야 합니다.
			return false;
		} else {
			var url  = "/forum/forumLect/editScoreRatioAjax.do";
			var data = {
				"forumCds" 	  : forumCds,
				"scoreRatios" : scoreRatios
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					alert("<spring:message code='forum.alert.success'/>"); // 저장되었습니다.
					listForum(1);
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert("<spring:message code='forum.common.error'/>"); // 오류가 발생했습니다!
			}, true);
		}
	}
}

// 성적 공개 비공개 설정 ajax
function fn_forumOpenYn(id, value) {
	var data = new Object();
	var splitVal = id.split('|');
	data.forumCd = splitVal[0];

	var url = "/forum/forumLect/editForumOpen.do";
	var data = {
		"forumCd" : data.forumCd,
		// "forumOpenYn" : value // 토론 공개비공개
		"scoreOpenYn" : value
	};
	
	ajaxCall(url, data, function(data) {
	}, true);
}

/*
// 탭으로 포커스 이동시 드랍다운의 a태그 클릭 기능
function dropDownTabKeyDown(event,obj){
	if (event.keyCode == '13') {
		var url = $(obj).children().children("a.active").attr("href");
		location.href=url;
	}
}
*/

function forumView(forumCd,tab) {
	$("#forumCd").val(forumCd);
	if(tab == "0" ){
		//토론정보상세보기
		$("#forumListForm").attr("action","/forum/forumLect/Form/infoManage.do?tab=0");
	}else if(tab == "1" ){
		//토론방
		$("#forumListForm").attr("action","/forum/forumLect/Form/bbsManage.do?tab=1");
	}else if(tab == "2" ){
		//토론평가
		$("#forumListForm").attr("action","/forum/forumLect/Form/scoreManage.do?tab=3");
	}
	
	$("#forumListForm").submit();
}

//토론등록 폼
function addForum() {
	$("#forumListForm").attr("action","/forum/forumLect/Form/addForumForm.do");
	$("#forumListForm").submit();
}

//토론수정폼
function editForum(forumCd,forumStartDttm) {
	var date = new Date();
	var year = date.getFullYear();
	var month = ("0" + (1 + date.getMonth())).slice(-2);
	var day = ("0" + date.getDate()).slice(-2);
	var hours = ("0" + date.getHours()).slice(-2);
	var minutes = ("0" + date.getMinutes()).slice(-2);
	var seconds = ("0" + date.getSeconds()).slice(-2);

	var today = year + month + day + hours + minutes + seconds;

	// 과제가 시작했으면 수정 X
	if(forumStartDttm <= today) {
		// $("#note-box").prop("class", "warning");
		// $("#note-box p").text("진행중인 토론은 수정이 불가능합니다."); //진행중인 토론은 수정이 불가능합니다.
		// $("#note-btn").trigger("click");
		alert("<spring:message code='forum.alert.ontask.not.modify'/>"); // 진행중인 토론은 수정이 불가능합니다.
		return false;
	} else {
		$("#forumCd").val(forumCd);
		$("#forumListForm").attr("action","/forum/forumLect/Form/editForumForm.do");
		$("#forumListForm").submit();
	}
}

//토론삭제
function delForum(forumCd) {
	var result = confirm("<spring:message code='forum.alert.confirm.delete'/>"); // 정말 토론을 삭제 하시겠습니까?

	if(!result){return false;}

	$("#forumCd").val(forumCd);
	$("#forumListForm").attr("action","/forum/forumLect/Form/delForum.do");
	$("#forumListForm").submit();
}
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
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
                    	<script>
						$(document).ready(function () {
							// set location
							setLocationBar("<spring:message code='forum.label.forum'/>", "<spring:message code='forum.label.list'/>");
						});
						</script>
                	    <div id="info-item-box">
                            <h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code='forum.label.forum'/><!-- 토론 -->
                            </h2>
                            <div class="button-area">
                                <a href="javascript:void(0)" onclick="addForum()" class="ui blue button"><spring:message code='forum.button.addForm'/><!-- 토론등록 --></a>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col">
								<form name="forumListForm" id="forumListForm" action="" method="POST">
									<input type="hidden" id="forumCd" name="forumCd" /> 
									<input type="hidden" id="crsCreCd" name="crsCreCd" value="${forumVO.crsCreCd}"/>
									<input type="hidden" id="userId" name="userId" value="${userId}"/>
									<input type="hidden" id="userName" name="userName" value="${userName}"/>
									<input type="hidden" id="mode" name="mode" value="L"/>
								</form>
								<!-- 토론 목록 -->
			                    <div class="option-content mb10">
				                    <button class="ui basic icon button" id="listType" title="" onclick="listForumType()"><i class="list ul icon"></i></button>
				                    <div class="ui action input search-box mr5">
				                    	<label for="searchValue" class="hide"><spring:message code='forum.button.forumNm.input'/></label>
				                        <input type="text" id="searchValue" placeholder="<spring:message code='forum.button.forumNm.input'/>"><!-- 토론명 입력 -->
				                        <button class="ui icon button" onclick="listForum(1)"><i class="search icon"></i></button>
				                    </div>
				                    <div class="button-area flex-left-auto">
				                    	<div class="chgScoreRatioDiv" style="display:none;">
					                    	<a href="javascript:saveScoreRatio()" class="ui blue button"><spring:message code='forum.button.scoreRatio.save'/><!-- 성적반영 비율 저장 --></a>
					                    	<a href="javascript:chgScoreRatio(2)" class="ui basic button"><spring:message code='forum.button.cancel'/><!-- 취소 --></a>
				                    	</div>
				                    	<a href="javascript:chgScoreRatio(1)" id="chgScoreRatioBtn" class="ui blue button" style="display:none;"><spring:message code='forum.button.scoreRatio.change'/><!-- 성적반영 비율 조정 --></a>
					                    <select class="ui dropdown mr5 list-num listScale" id="listScale" onchange="listForum(1)">
					                        <option value="10">10</option>
					                        <option value="20">20</option>
					                        <option value="50">50</option>
					                        <option value="100">100</option>
					                    </select>
				                    </div>
			                    </div>
			                    <div id="list"></div>
								<!-- 토론 목록 -->
            				</div>
            			</div>
            		</div>
            	</div>
        	</div>
        	<!-- //본문 content 부분 -->
			<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
    	</div>
	</div>
</body>
</html>