<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
	
	<script type="text/javascript">
		$(document).ready(function () {
			listTeam(1);
			
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					listTeam(1);
				}
			});
		});
		
		// 팀 구성
		function teamWrite() {
			$("#teamForm").attr("action", "/team/teamMgr/teamWrite.do");
			$("#teamForm").submit();
		}
		
		// 리스트 조회
		function listTeam(page) {
			var url = "/team/teamMgr/teamListDiv.do";
			var data = {
				"crsCreCd" : $("#crsCreCd").val(),
				"pageIndex" : page,
				"searchValue" : $("#searchValue").val()
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					var html = createTeamListHTML(returnList);
		
					$("#list").empty().html(html);
					$(".table").footable();
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert("<spring:message code='team.common.error'/>"); // 오류가 발생했습니다!
			}, true);
		}
		
		function createTeamListHTML(teamList) {
			var prevCourseYn = '<c:out value="${prevCourseYn}" />';
			var listHtml = "";
		
			listHtml += "<table class=\"table type2 c_table mt10\" data-sorting=\"true\" data-paging=\"false\" data-empty=\"<spring:message code='team.common.empty' />.\">"; //등록된 내용이 없습니다.
			listHtml += "	<thead>";
			listHtml += "		<tr>";
			listHtml += "			<th scope=\"col\" data-type=\"\" class=\"num\"><spring:message code='main.common.number.no' /></th>";// NO.
			listHtml += "			<th scope=\"col\"><spring:message code='team.table.field.teamCtgrNm' /></th>"; // 팀 분류명
			listHtml += "			<th scope=\"col\" data-breakpoints=\"xs\"><spring:message code='team.table.field.teamCnt' /></th>"; // 팀수
			listHtml += "			<th scope=\"col\" data-breakpoints=\"xs sm\"><spring:message code='team.table.field.regNm' /></th>"; // 등록인
			listHtml += "			<th scope=\"col\" data-breakpoints=\"xs sm md\"><spring:message code='team.table.field.regDttm' /></th>"; // 등록일
			listHtml += "			<th scope=\"col\" data-breakpoints=\"xs sm md\"><spring:message code='team.table.field.states' /></th>"; // 상태
			listHtml += "			<th scope=\"col\" data-breakpoints=\"xs sm md\"><spring:message code='common.use.yn' /></th>"; // 사용여부
			if(prevCourseYn != 'Y') {
				listHtml += "		<th scope=\"col\" data-sortable=\"false\" data-breakpoints=\"xs sm md\"><spring:message code='team.table.field.manage' /></th>"; // 관리	
			}
			listHtml += "		</tr>";
			listHtml += "	</thead>";
			listHtml += "	<tbody>";
			teamList.forEach(function(v, i) {
				listHtml += "		<tr>";
				listHtml += "			<td>";
				listHtml += "				<div class=\"ui checkbox\"><input type=\"checkbox\" tabindex=\"0\" class=\"\"></div>";
				listHtml += "				"+ v.lineNo;
				listHtml += "			</td>";
				listHtml += "			<td><a href=\"javascript:void(o)\" onclick=\"teamView('"+ v.teamCtgrCd +"')\" class=\"link\"><b>"+ v.teamCtgrNm +"</b></a></td>";
				listHtml += "			<td>"+ v.teamCnt +"</td>";
				listHtml += "			<td>"+ v.regNm +"</td>";
				var regDttm = v.regDttm.substring(0, 4) + '.' + v.regDttm.substring(4, 6) + '.' + v.regDttm.substring(6, 8) + ' ' + v.regDttm.substring(8, 10) + ':' + v.regDttm.substring(10, 12);
				listHtml += "			<td>"+ regDttm +"</td>";
				listHtml += "			<td>"+ ((v.teamSetYn == "Y") ? "<spring:message code='team.label.complete' />" : "<div class = \"fcRed\"><spring:message code='team.label.incomplete' /></div>") +"</td>"; // 구성완료, 미완료
				listHtml += "			<td>";
				if(Number(v.asmntCnt) + Number(v.forumCnt) > 0) {
					listHtml += "			Y";
				} else {
					listHtml += "			N";
				}
				listHtml += "			</td>";
				if(prevCourseYn != 'Y') {
					listHtml += "		<td>";
					if(Number(v.asmntCnt) + Number(v.forumCnt) > 0) {
						listHtml += "			<a href=\"javascript:void(0)\" class=\"ui basic small button\" onclick=\"editTeamCtgr('"+ v.teamCtgrCd +"')\">​<spring:message code='team.common.modify' /></a>"; // 수정
					} else {
						listHtml += "			<a href=\"javascript:void(0)\" class=\"ui basic small button\" onclick=\"editTeamCtgr('"+ v.teamCtgrCd +"')\">​<spring:message code='team.common.modify' /></a>"; // 수정
						listHtml += "			<a href=\"javascript:void(0)\" class=\"ui basic small button\" onclick=\"deleteTeamCtgr('"+ v.teamCtgrCd +"')\"><spring:message code='team.common.delete' />​</a>"; //삭제
					}
					listHtml += "		</td>";
				}
				listHtml += "		</tr>";
			});
			listHtml += "	</tbody>";
			listHtml += "</table>";
		
			return listHtml;
		}
		
		// 팀 구성 수정
		function editTeamCtgr(teamCtgrCd) {
			$("#teamCtgrCd").val(teamCtgrCd);
			$("#teamForm").attr("action", "/team/teamMgr/editTeamForm.do");
			$("#teamForm").submit();
		}
		
		// 팀 구성 삭제
		function deleteTeamCtgr(teamCtgrCd) {
			// 삭제 시 팀 활동 내역이 삭제됩니다. 정말 삭제하시겠습니까?
			if(!confirm("<spring:message code='team.write.remove.teamDel.confirm'/>")) return;
			
			var url = "/team/teamMgr/deleteTeamAll.do";
			var data = {
				crsCreCd 	: "${vo.crsCreCd}",
				teamCtgrCd 	: teamCtgrCd
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					listTeam(1);
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert("<spring:message code='team.common.error'/>"); // 오류가 발생했습니다!
			}, true);
		}
		
		function teamView(teamCtgrCd) {
			$("#teamCtgrCd").val(teamCtgrCd);
			$("#teamForm").attr("action", "/team/teamMgr/team_view.do");
			$("#teamForm").submit();
		}
	</script>
</head>
<body class="<%=SessionInfo.getThemeMode(request)%>">
	<form id="teamForm" name="teamForm" method="POST">
		<input type="hidden" name="crsCreCd" id="crsCreCd" value="${crsCreCd}" />
		<input type="hidden" name="teamCtgrCd" id="teamCtgrCd" />
	</form>
    <div id="wrap" class="pusher">
        <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>

        <div id="container">
            <!-- class_top 인클루드  -->
        	<%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>
        	
            <!-- 본문 content 부분 -->
			<!-- 팀 구성 목록 시작 -->
			<div class="content stu_section">
		        <%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
		        
		        <div class="ui form">
		            <div class="layout2">
						<script>
						$(document).ready(function () {
							// set location
							setLocationBar("<spring:message code='team.write.info.subTitle1'/>", "<spring:message code='team.write.info.subTitle3'/>");
						});
						</script>
		            
						<div id="info-item-box" class="">
							<h2 class="page-title">
								<spring:message code='team.write.info.subTitle1'/>
							</h2>
							<div class="button-area tr mt40">
								<c:if test="${prevCourseYn ne 'Y'}">
									<a href="javascript:void(0)" class="ui orange button" onclick="teamWrite();"><spring:message code='team.button.teamWrite'/><!-- 팀 구성 --></a>
								</c:if>
								<a href="javascript:void(0)" class="ui green button" onclick="moveMenu('/bbs/bbsLect/atclList.do', null, 'TEAM');return false;"><spring:message code='team.write.field.teamBbs'/><!-- 팀 게시판 --></a>
							</div>
						</div>
		                <div class="row">
		                    <div class="col">
								<div class="ui small error message">
									<i class="info circle icon"></i>
									<spring:message code='team.label.error.message'/><!-- 팀구성 미완료시 임시저장됩니다. -->
								</div>
								<div class="mt10">
									<div class="ui action input search-box">
										<input type="text" id="searchValue" placeholder="<spring:message code='team.label.teamNm.input'/>" class="wf70"><!-- 팀 분류명 입력 -->
										<button class="ui icon button" onclick="listTeam(1)"><i class="search icon"></i></button>
									</div>
								</div>
								<div id="list"></div>
                            </div>
                        </div>
                    </div>
                </div>
			</div>
			<!-- 팀 구성 목록 끝 -->
            <!-- //본문 content 부분 -->
			<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
        </div>
	</div>
</body>
</html>