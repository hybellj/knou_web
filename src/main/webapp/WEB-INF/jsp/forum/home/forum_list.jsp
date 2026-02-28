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
	listForum(1);
	
	$("#searchValue").on("keyup", function(e) {
		if(e.keyCode == 13) {
			listForum(1);
		}
	});
	
	$(".ui.dropdown.mr5.listScale").hide();
	// listForumType();
});

// 리스트 타입 변환
function listForumType() {
	if($("#listType i").attr("class") == "list ul icon") {
		// 리스트형
		$("#listType i").attr("class","th ul icon");
		$(".ui.dropdown.mr5.listScale").show();
	} else {
		// 그리드형
		$("#listType i").attr("class","list ul icon");
		$(".ui.dropdown.mr5.listScale").hide();
	} 
 	listForum(1);
}

// 리스트 조회
function listForum(page) {
	var url = "/forum/forumHome/forumList.do";
	
	var listScale = "";
	if($("#listType i").attr("class") == "list ul icon") {
		// 그리드형
		listScale = 9999;
	} else {
		// 리스트형
		// listScale = $("#listScale").val();
		listScale = 9999;
	}

	var data = {
		"crsCreCd" : "${vo.crsCreCd}",
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
    		if($("#listType i").attr("class") != "list ul icon"){
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
    	} else {
    		alert(data.message);
    	}
	}, function(xhr, status, error) {
		/* 오류가 발생했습니다! */
		alert("<spring:message code='forum.common.error'/>");
	}, true);
}

// 토론 리스트 생성
function createForumListHTML(forumList) {
	if(forumList.length == 0) {
		return `
			<div class="flex-container">
				<div class="cont-none">
					<span><spring:message code='forum.common.empty'/></span> <!-- 등록된 내용이 없습니다. -->
				</div>
			</div>
		`;
	} else {
		var listHtml = '';
		var date = new Date();
		var year = date.getFullYear();
		var month = ("0" + (1 + date.getMonth())).slice(-2);
		var day = ("0" + date.getDate()).slice(-2);
		var hours = ("0" + date.getHours()).slice(-2);
		var minutes = ("0" + date.getMinutes()).slice(-2);
		var seconds = ("0" + date.getSeconds()).slice(-2);

		var today = year + month + day + hours + minutes + seconds;
		
		if($("#listType i").attr("class") != "list ul icon") {
			listHtml += `
				<table class="table type2" data-sorting="true" data-paging="false" data-empty="<spring:message code='forum.common.empty'/>"><!-- 등록된 내용이 없습니다. -->
					<thead>
						<tr>
							<th scope="col" data-type="" class="tc num">No</th>
							<th scope="col" class="tc"><spring:message code='forum.label.type' /><!-- 구분 --></th>
							<th scope="col" class="tc" data-breakpoints="xs"><spring:message code='forum.label.forum.title' /><!-- 토론명 --></th>
							<th scope="col" class="tc" data-breakpoints="xs sm"><spring:message code='forum.label.forum.date' /><!-- 토론기간 --></th>
							<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code='forum.label.forum.bbsCnt' /><!-- 토론 글수 --></th>
							<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code='forum.label.forum.commCnt' /><!-- 댓글수 --></th>
							<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code='forum.label.scoreAplyYn' /><!-- 성적 반영 --></th>
							<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code='forum.label.eval.submission' /><!-- 제출/평가현황 --></th>
							<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code='forum.label.feedback' /><!-- 피드백 --></th>
							<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code='forum.label.manage' /><!-- 관리 --></th>
						</tr>
					</thead>
					<tbody>
			`;
			forumList.forEach(function(v, i) {
				var forumStartDttm = v.forumStartDttm.substring(0, 4) + '.' + v.forumStartDttm.substring(4, 6) + '.' + v.forumStartDttm.substring(6, 8) + ' ' + v.forumStartDttm.substring(8, 10) + ':' + v.forumStartDttm.substring(10, 12);
				var forumEndDttm = v.forumEndDttm.substring(0, 4) + '.' + v.forumEndDttm.substring(4, 6) + '.' + v.forumEndDttm.substring(6, 8) + ' ' + v.forumEndDttm.substring(8, 10) + ':' + v.forumEndDttm.substring(10, 12);
			
				if(v.forumStartDttm <= today) { // 오늘보다 이전인 토론만 보여지도록
				listHtml += `
				<tr>
					<td class="tc">\${v.lineNo}</td>`;
					if(v.forumCtgrCd == "TEAM") { // 팀토론
						listHtml += `<td class="tc"><spring:message code='forum.label.type.teamForum' /><!-- 팀토론 --></td>`;
					} else if (v.forumCtgrCd == "EXAM" || v.forumCtgrCd == "SUBS") { // 시험토론, 중간고사/기말고사, 대체토론, 중간대체평가/기말대체평가
						if(v.stareType == "M") {
							listHtml += `<td class='tc'><spring:message code='forum.label.type.exam.M' /><!-- 중간고사 --></td>`;
						} else {
							listHtml += `<td class='tc'><spring:message code='forum.label.type.exam.L' /><!-- 기말고사 --></td>`;
						}
					} else {
						listHtml += `<td class="tc"><spring:message code='forum.label.type.forum' /><!-- 일반토론 --></td>`;
					}
				listHtml += `
					<td><a href="javascript:forumBbs('\${v.forumCd}', '\${v.forumStartDttm}', '\${v.forumEndDttm}', '\${v.periodAfterWriteYn}', '\${v.crsCreCd}');" class="link">\${v.forumTitle}</a></td>
					<td>\${forumStartDttm } ~ \${forumEndDttm }</td>`;
				listHtml += `
					<td class="tc">\${v.forumMyAtclCnt}/\${v.forumAtclCnt}</td>
					<td class="tc">\${v.forumMyCmntCnt}/\${v.forumCmntCnt}</td>`;
					if(v.scoreAplyYn =="Y") {
						listHtml += `<td class="tc"><spring:message code='forum.common.yes' /></td>`; // 예
					} else {
						listHtml += `<td class="tc"><spring:message code='forum.common.no' /></td>`; // 아니오
					}
					
					if("${auditYn}" == "Y") {
						listHtml += `<td class="tc">-</td>`;
					} else if(v.scoreOpenYn === "Y") { // 성적공개
						if(v.forumMyScore > 0) { // 성적이 0점 이상
							listHtml += `<td class="tc">`+ v.forumMyScore +`<spring:message code='forum.label.point'/></td>`; // 점
						} else {
							if(v.forumMyAtclCnt > 0) { // 토론글 작성일 경우
								listHtml += `<td class="tc"><spring:message code='forum.label.completion.join'/></td>`; // 참여완료
							} else {
								listHtml += `<td class="tc"><spring:message code='forum.label.not.join'/></td>`; // 미참여
							}
						}
					} else {
						if(v.forumMyAtclCnt > 0) { // 토론글 작성일 경우
							listHtml += `<td class="tc"><spring:message code='forum.label.completion.join'/></td>`; // 참여완료
						} else {
							listHtml += `<td class="tc"><spring:message code='forum.label.not.join'/></td>`; // 미참여
						}
					}
					listHtml += `<td class="tc"><a href="javascript:void(0);" onclick="fdbkList(this)"
						data-forumCd="\${v.forumCd}"
						data-forumCtgrCd="\${v.forumCtgrCd}"
						data-teamCtgrCd="\${v.teamCtgrCd}"
						data-stdNo="${gStdNo}"><i>\${v.forumMyFdbk}</i></a></td>`;
					listHtml += `<td class="tc">`
					if("${auditYn}" != "Y") {
						if(v.forumCtgrCd == "TEAM") {
							listHtml += `<button class="ui basic small button" onclick="teamMemberView('`+  v.teamCtgrCd +` ')"><spring:message code='forum.label.team.member.view.short'/><!-- 팀원보기 --></button>`;
						}
						if(v.mutEvalYn == "Y") {
							listHtml += `<button class="ui basic small button" onclick="evalView('\${v.forumCd}', '\${v.forumStartDttm}', '\${v.forumEndDttm}', '\${v.periodAfterWriteYn}', '\${v.crsCreCd}')"><spring:message code='forum.label.mut.eval'/><!-- 상호평가 --></button>`;
						}
					}
				listHtml += `</td>
				</tr>
				`;
				}
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
				if(v.forumStartDttm <= today) { // 오늘보다 이전인 토론만 보여지도록
				listHtml += `
					<div class="card">
						<div class="content card-item-center">
							<div class="title-box">`;
							if(v.forumCtgrCd == "TEAM") {
//				listHtml += `<label class="ui orange label m-w30 active"><spring:message code='forum.label.team' /><!-- 팀 --></label>`;
							}
							switch(v.forumCtgrCd) {
							case "NORMAL": // 일반토론
								listHtml += `<label class="ui orange label m-w40 active"><spring:message code='forum.label.type.forum' /><!-- 일반토론 --></label>`;
								break;
							case "TEAM": // 팀토론
								listHtml += `<label class="ui orange label m-w40 active"><spring:message code='forum.label.type.teamForum' /><!-- 팀토론 --></label>`;
								break;
							case "SUBS": // 대체토론, 중간대체평가/기말대체평가
								if(v.stareType == "M") {
									listHtml += `<label class="ui orange label m-w40 active"><spring:message code='forum.label.type.exam.M' /><!-- 중간고사 --></label>`;
								} else {
									listHtml += `<label class="ui orange label m-w40 active"><spring:message code='forum.label.type.exam.L' /><!-- 기말고사 --></label>`;
								}
								break;
							case "EXAM": // 시험토론, 중간고사/기말고사
								if(v.stareType == "M") {
									listHtml += `<label class="ui orange label m-w40 active"><spring:message code='forum.label.type.exam.M' /><!-- 중간고사 --></label>`;
								} else {
									listHtml += `<label class="ui orange label m-w40 active"><spring:message code='forum.label.type.exam.L' /><!-- 기말고사 --></label>`;
								}
								break;
							}
				listHtml += `
								<a href="javascript:forumBbs('\${v.forumCd}', '\${v.forumStartDttm}', '\${v.forumEndDttm}', '\${v.periodAfterWriteYn}', '\${v.crsCreCd}');" class="header header-icon link">\${v.forumTitle}</a>
							</div>`;
							if(v.forumCtgrCd == "TEAM" && "${auditYn}" != "Y") {
				listHtml += `	<a href="#0" class="ui blue button" onclick="teamMemberView('`+  v.teamCtgrCd +` ')"><spring:message code='forum.label.team'/><!-- 팀  --></a>`;
							}
				listHtml += `
						</div>
						<div class="sum-box">
							<ul class="process-bar">`;
							
							if(v.forumStatus == "대기") {
								listHtml += `<li class="wmax bar-basic">`;
							} else if(v.forumStatus == "진행중") {
								listHtml += `<li class="wmax bar-blue">`;
							} else {
								listHtml += `<li class="wmax bar-softgrey">`;
							}
				// 미참여, 참여완료 , scoreOpenYn : 점수(99점)
				listHtml += '<center>'
				if(v.forumStatus == "대기") {
					listHtml += "<spring:message code='common.label.ready'/>";
				} else if(v.forumStatus == "진행중") {
					listHtml += "<spring:message code='common.processing'/>";
				} else if(v.forumStatus == "마감") {
					listHtml += "<spring:message code='common.closed'/>";
				} else {
					listHtml = v.forumStatus;
				}
				listHtml += ' (';
				
					if(v.scoreOpenYn === 'Y') { // 성적공개
						if(v.forumMyScore > 0) { // 성적이 0점 이상일 때
							listHtml += v.forumMyScore +"<spring:message code='forum.label.point'/>"; // 점
						} else {
							if(v.forumMyAtclCnt > 0) { // 토론글 작성일 경우
								listHtml += "<spring:message code='forum.label.completion.join'/>"; // 참여완료
							} else {
								listHtml += "<spring:message code='forum.label.not.join'/>"; // 미참여
							}
						}
					} else {
						if(v.forumMyAtclCnt > 0) { // 토론글 작성일 경우
							listHtml += "<spring:message code='forum.label.completion.join'/>"; // 참여완료
						} else {
							listHtml += "<spring:message code='forum.label.not.join'/>"; // 미참여
						}
					}
				listHtml += `)</center>`;
				listHtml += `
								</li>
							</ul>
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
									<label class="label-title-lg"><spring:message code='forum.label.scoreAplyYn' /><!-- 성적 반영 여부 --></label>
									<i>`;
									
									if(v.scoreAplyYn =="Y") {
										listHtml += `<spring:message code='forum.common.yes' /><!-- 예 -->`;
									} else {
										listHtml += `<spring:message code='forum.common.no' /><!-- 아니오 -->`;
									}
				listHtml += `
									</i>
								</div>
							</div>
							<div class="fields">
								<div class="inline field">
									<label class="label-title-lg"><spring:message code='forum.label.feedback' /><!-- 피드백 --></label>
									<a href="javascript:void(0);" onclick="fdbkList(this)"
									data-forumCd="\${v.forumCd}"
									data-forumCtgrCd="\${v.forumCtgrCd}"
									data-teamCtgrCd="\${v.teamCtgrCd}"
									data-stdNo="${gStdNo}"><i class="fcBlue">\${v.forumMyFdbk}</i></a>
								</div>
							</div>
						</div>
					</div>
				`;
				}
			});
			listHtml += `</div>`;
		}
		return listHtml;
	}
}

//토론방
function forumBbs(forumCd,forumStartDttm, forumEndDttm, periodAfterWriteYn, crsCreCd) {
	var date = new Date();
	var year = date.getFullYear();
    var month = ("0" + (1 + date.getMonth())).slice(-2);
    var day = ("0" + date.getDate()).slice(-2);
    var hours = ("0" + date.getHours()).slice(-2);
    var minutes = ("0" + date.getMinutes()).slice(-2);
    var seconds = ("0" + date.getSeconds()).slice(-2);

    var today = year + month + day + hours + minutes + seconds;
    
	/* if(forumStartDttm <= today && today <= forumEndDttm){
	}else{
		if(periodAfterWriteYn == 'Y'){
		}else{
			alert("<spring:message code='forum.alert.forum.date.no' />"); // 토론기간이 아닙니다.
			return false;
		}
	} */
	
	$("#forumCd").val(forumCd);
	$("#forumListForm").attr("action","/forum/forumHome/Form/forumView.do");
	$("#forumListForm > input[name='crsCreCd']").val(crsCreCd);
	$("#forumListForm").submit();
}

//팀 구성원 보기
function teamMemberView(teamCtgrCd) {
	$("#teamCtgrCd").val(teamCtgrCd);
	$("#teamMemberForm").attr("target", "teamMemberIfm");
	$("#teamMemberForm").attr("action", "/forum/forumHome/teamMemberList.do");
	$("#teamMemberForm").submit();
	$('#teamMemberPop').modal('show');
}

// 상호평가 보기
function evalView(forumCd,forumStartDttm, forumEndDttm, periodAfterWriteYn, crsCreCd) {
	var date = new Date();
	var year = date.getFullYear();
	var month = ("0" + (1 + date.getMonth())).slice(-2);
	var day = ("0" + date.getDate()).slice(-2);
	var hours = ("0" + date.getHours()).slice(-2);
	var minutes = ("0" + date.getMinutes()).slice(-2);
	var seconds = ("0" + date.getSeconds()).slice(-2);

	var today = year + month + day + hours + minutes + seconds;

	if(forumStartDttm <= today && today <= forumEndDttm){
	}else{
		if(periodAfterWriteYn == 'Y'){
		}else{
			alert("<spring:message code='forum.alert.forum.date.no' />"); // 토론기간이 아닙니다.
			return false;
		}
	}
	
	$("#forumCd").val(forumCd);
	$("#forumListForm").attr("action","/forum/forumHome/Form/forumView.do?tab=tab2");
	$("#forumListForm > input[name='crsCreCd']").val(crsCreCd);
	$("#forumListForm").submit();
	
	$(".listTab > ul > li").removeClass("select")
	$("a[href='#tab2']").parent().addClass("select").trigger("click");
}

//피드백 작성 팝업
function fdbkList(obj) {
	var forumCd = $(obj).data("forumcd");
	var forumCtgrCd = $(obj).attr("data-forumctgrcd");
	var teamCtgrCd = $(obj).data("teamctgrcd");
	var stdNo = $(obj).data("stdno");

	$("form[name='forumCreCrsStdForm'] input[name='forumCd']").val(forumCd);
	$("form[name='forumCreCrsStdForm'] input[name='forumCtgrCd']").val(forumCtgrCd);
	$("form[name='forumCreCrsStdForm'] input[name='teamCtgrCd']").val(teamCtgrCd);
	$("form[name='forumCreCrsStdForm'] input[name='stdNo']").val(stdNo);
	$("#forumCreCrsStdForm").attr("target", "fdbkIfm");
	$("#forumCreCrsStdForm").attr("action", "/forum/forumLect/forumFdbkPop.do");
	$("#forumCreCrsStdForm").submit();
	$("#fdbkPop").modal("show");
}
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
<form name="forumCreCrsStdForm" id="forumCreCrsStdForm" method="POST">
	<input type="hidden" name="forumCd" value="">
	<input type="hidden" name="forumCtgrCd" value="">
	<input type="hidden" name="teamCtgrCd" value="">
	<input type="hidden" name="stdNo" value="">
	<input type="hidden" name="crsCreCd" value="${crsCreCd}">
</form>
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
						<script>
						$(document).ready(function () {
							// set location
							setLocationBar("<spring:message code='forum.label.forum'/>", "<spring:message code='forum.label.list'/>");
						});
						</script>
						
                        <div class="row">
                            <div class="col">

								<form name="forumListForm" id="forumListForm" action="" method="POST">
									<input type="hidden" id="forumCd" name="forumCd" />
									<input type="hidden" id="rltnCd" name="rltnCd" />
									<input type="hidden" name="crsCreCd" />
									<input type="hidden" id="userId" name="userId" value="${userId}" />
									<input type="hidden" id="teamCd" name="teamCd" />
									<input type="hidden" id="stdNo" name="stdNo" />
									<input type="hidden" id="userName" name="userName" value="${userName}" />
								</form>
				                <div class="option-content mb10">
				                    <button class="ui basic icon button" id="listType" title="" onclick="listForumType()"><i class="list ul icon"></i></button>
				                    <div class="ui action input search-box mr5">
				                    	<label for="searchValue" class="hide"><spring:message code='forum.button.forumNm.input'/></label>
				                        <input type="text" id="searchValue" placeholder="<spring:message code='forum.button.forumNm.input'/>"><!-- 토론명 입력 -->
				                        <button class="ui icon button" onclick="listForum(1)"><i class="search icon"></i></button>
				                    </div>
				                    <!-- 
				                    <div class="button-area flex-left-auto">
					                    <select class="ui dropdown mr5 listScale list-num selection" id="listScale" onchange="listForum(1)">
					                        <option value="10">10</option>
					                        <option value="20">20</option>
					                        <option value="50">50</option>
					                    </select>
				                    </div> 
				                    -->
				                </div>
				                <div id="list"></div>
			                </div>
            				</div>
            			</div>
            		</div>
            	</div>
        		<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
        	</div>
        	<!-- //본문 content 부분 -->
    	</div>

		<!-- 팀 구성원 보기 모달 -->
		<div class="modal fade" id="teamMemberPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code='forum.label.team.member.view'/>" aria-hidden="true">
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
		<!-- 피드백 보기 모달 -->
		<div class="modal fade" id="fdbkPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code='forum.label.feedback.view'/>" aria-hidden="true">
			<div class="modal-dialog modal-lg" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='forum.button.close'/>"><!-- 닫기 -->
							<span aria-hidden="true">&times;</span>
						</button>
						<h4 class="modal-title"><spring:message code='forum.label.feedback.view'/><!-- 피드백 보기 --></h4>
					</div>
					<div class="modal-body">
						<iframe src="" id="fdbkIfm" name="fdbkIfm" width="100%" scrolling="no" title="feedback frame"></iframe>
					</div>
				</div>
			</div>
		</div>
		<!-- 피드백 보기 모달 -->
		<script>
		$('iframe').iFrameResize();
		window.closeModal = function(){
			$('.modal').modal('hide');
		};
		</script>
</body>
</html>
