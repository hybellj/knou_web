<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
$(function(){
	listForum(1);
	
	$("#searchValue").on("keyup", function(e) {
		if(e.keyCode == 13) {
			listForum(1);
		}
	});
});


//성적 반영비율 입력 폼 변환
function chgScoreRatio(type) {
	if(type == 1) {
		$("#chgScoreRatioBtn").hide();
		$(".chgScoreRatioDiv").css("display", "inline-block");
		$(".scoreInputDiv").show();
		$(".scoreRatioDiv").hide();
	} else if(type == 2) {
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
	var data = {
		"crsCreCd" : "${vo.crsCreCd2}",
		"pageIndex" : page,
		"searchValue" : $("#searchValue1").val()
	};
	
	ajaxCall(url, data, function(data) {
		if(data.result > 0) {
			var returnList = data.returnList || [];
			var html = createForumListHTML(returnList);
			
			$("#list").empty().html(html);
			$(".table").footable();
			var params = {
				totalCount : data.pageInfo.totalRecordCount,
				listScale : data.pageInfo.pageSize,
				currentPageNo : data.pageInfo.currentPageNo,
				eventName : "listForum"
			};
			gfn_renderPaging(params);
			
			$("#forumTotalCnt").text(data.pageInfo.totalRecordCount);
			// 성적반영 비율 저장 버튼 처리
			if($("#listType i").attr("class") == "list ul icon") { // 그리드형
				// $("#chgScoreRatioBtn").hide();
			} else { // 리스트형
				if($("#mode").val() == "G") {
					$("#chgScoreRatioBtn").hide();
					$(".chgScoreRatioDiv").css("display", "inline-block");
					$(".scoreInputDiv").css("display", "inline-block");
					$(".scoreRatioDiv").hide();
				} else {
					chgScoreRatio(2);
				}
			}
		} else {
			alert(data.message);
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='forum.common.error'/>"); // 오류가 발생했습니다!
	});
}

//토론 리스트 생성
function createForumListHTML(forumList) {
	var listHtml = "";
	listHtml += "	<table class=\"table\" data-sorting=\"false\" data-paging=\"false\" data-empty=\"<spring:message code='forum.common.empty' />\"><!-- 등록된 내용이 없습니다. -->";
	listHtml += "		<thead>";
	listHtml += "			<tr>";
	listHtml += "				<th scope=\"col\" class=\"tc num\"><spring:message code='common.number.no' /></th>";
	listHtml += "				<th scope=\"col\"><spring:message code='forum.label.type' /><!-- 구분 --></th>";
	listHtml += "				<th scope=\"col\"><spring:message code='forum.label.forum.title' /><!-- 토론명 --></th>";
	listHtml += "				<th scope=\"col\"><spring:message code='forum.label.forum.date' /><!-- 토론기간 --></th>";
	listHtml += "				<th scope=\"col\"><spring:message code='forum.label.forum.gradeRef' /><!-- 성적반영 비율 --></th>";
	listHtml += "				<th scope=\"col\"><spring:message code='forum.label.status.join' /><!-- 참여 현황 --></th>";
	listHtml += "				<th scope=\"col\"><spring:message code='forum.label.eval.status' /><!-- 평가 현황 --></th>";
	listHtml += "				<th scope=\"col\"><spring:message code='forum.label.forum.bbsCnt' /><!-- 토론 글수 --></th>";
	listHtml += "				<th scope=\"col\"><spring:message code='forum.label.forum.commCnt' /><!-- 댓글수 --></th>";
	listHtml += "				<th scope=\"col\"><spring:message code='forum.label.score.open' /><!-- 성적 공개 --></th>";
	listHtml += "			</tr>";
	listHtml += "		</thead>";
	listHtml += "		<tbody>";
	forumList.forEach(function(v, i) {
		var forumStartDttm = v.forumStartDttm.substring(0, 4) + '.' + v.forumStartDttm.substring(4, 6) + '.' + v.forumStartDttm.substring(6, 8) + ' ' + v.forumStartDttm.substring(8, 10) + ':' + v.forumStartDttm.substring(10, 12);
		var forumEndDttm = v.forumEndDttm.substring(0, 4) + '.' + v.forumEndDttm.substring(4, 6) + '.' + v.forumEndDttm.substring(6, 8) + ' ' + v.forumEndDttm.substring(8, 10) + ':' + v.forumEndDttm.substring(10, 12);
		listHtml += `
				<tr>
					<td>\${v.lineNo }</td>`;
		if(v.forumCtgrCd == "TEAM") {
			listHtml += `<td><spring:message code='forum.label.type.teamForum' /><!-- 팀토론 --></td>`;
		} else {
			listHtml += `<td><spring:message code='forum.label.type.forum' /><!-- 일반토론 --></td>`;
		}
		listHtml += `
					<td>\${v.forumTitle}</td>
					<td>\${forumStartDttm } ~ \${forumEndDttm }</td>
					<td>`;
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
		listHtml += `
					</td>
					<td>\${v.forumJoinUserCnt}/\${v.forumUserTotalCnt}</td>
					<td class="tc">\${v.forumEvalCnt }/\${v.forumUserTotalCnt }</td>
					<td>\${v.forumAtclCnt}</td>
					<td>\${v.forumCmntCnt}</td>
					<td>
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
					</td>
				</tr>
		`;
	});
	listHtml += `
			</tbody>
		</table>
				<div id="paging" class="paging"></div>
	`;
	
	return listHtml;
}

//성적공개 설정
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

//성적 반영비율 저장
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
			/* 점수는 0 ~ 100 점 사이로 입력해주세요. */
			alert('<spring:message code="forum.alert.score.limit" />');
			isChk = false;
			return false;
		}
	});

	if(isChk) {
		if(Number(totScoreRatio) != 100) {
			/* 성적반영 비율 합이 100% 이이야 합니다. */
			alert("<spring:message code='forum.alert.total'/>");
			return false;
		} else {
			var url  = "/forum/forumLect/editScoreRatioAjax.do";
			var data = {
				"forumCds" 	  : forumCds,
				"scoreRatios" : scoreRatios
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					/* 저장되었습니다.*/
					alert("<spring:message code='forum.alert.success'/>");
					listForum(1);
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				/* 오류가 발생했습니다! */
				alert("<spring:message code='forum.common.error'/>");
			});
		}
	}
}

//성적 공개 비공개 설정 ajax
function fn_forumOpenYn(id, value) {
	var data = new Object();
	var splitVal = id.split('|');
	data.forumCd = splitVal[0];

	var url = "/forum/forumLect/editForumOpen.do";
	var data = {
		"forumCd" : data.forumCd,
		"scoreOpenYn" : value
	};
	
	ajaxCall(url, data, function(data) {
	});
}

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
</script>

<body>
	<form name="forumListForm" id="forumListForm" action="" method="POST">
		<input type="hidden" id="forumCd" name="forumCd" /> 
		<input type="hidden" id="crsCreCd" name="crsCreCd" value="${vo.crsCreCd2}"/>
		<input type="hidden" id="userId" name="userId" value="${userId}"/>
		<input type="hidden" id="userName" name="userName" value="${userName}"/>
		<input type="hidden" id="mode" name="mode" value="L"/>
	</form>
	
	<!-- 토론 목록 -->
	<div class="ui form">
		<div class="option-content mb10">
			<div class="ui action input search-box mr5">
				<input type="text" id="searchValue1" placeholder="<spring:message code='forum.button.forumNm.input'/>"><!-- 토론명 입력 -->
				<button class="ui icon button" onclick="listForum(1)"><i class="search icon"></i></button>
			</div>
			<div class="button-area flex-left-auto">
				<div class="chgScoreRatioDiv" style="display:none;">
					<a href="javascript:saveScoreRatio()" class="ui basic button"><spring:message code='forum.button.scoreRatio.save'/><!-- 성적반영 비율 저장 --></a>
					<a href="javascript:chgScoreRatio(2)" class="ui basic button"><spring:message code='forum.button.cancel'/><!-- 취소 --></a>
				</div>
				<a href="javascript:chgScoreRatio(1)" id="chgScoreRatioBtn" class="ui blue button" style="display:none;"><spring:message code='forum.button.scoreRatio.change'/><!-- 성적반영 비율 조정 --></a>
				<select class="ui dropdown mr5" id="listScale" onchange="listForum(1)">
					<option value="10">10</option>
					<option value="20">20</option>
					<option value="50">50</option>
				</select>
			</div>
		</div>
		<div id="list"></div>
	</div>
	<!-- 토론 목록 -->
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>							
</body>
</html>