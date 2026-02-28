<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<%@ include file="/WEB-INF/jsp/forum/common/forum_common_inc.jsp" %>
	
	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
	
	<script type="text/javascript">
		$(document).ready(function () {
			listForumUser();
		});
		
		//평가 대상자 리스트 조회
		function listForumUser() {
			var url  = "/forum/forumHome/forumJoinUserList.do";
			var data = {
				"forumCd" 	  : "${forumVo.forumCd}",
				"crsCreCd"	  : "${forumVo.crsCreCd}",
				//"searchKey"   : $("#searchKey").val(),
				//"searchValue" : $("#searchValue").val()
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
						var userNm = v.userNm;
						
						html += "	<td class=\"tc\">"+ userId +"</td>";
						html += "	<td class=\"tc\">"+ userNm +"</td>";
						html += "	<td class=\"tc\">"+ v.forumMyAtclCnt +"</td>";
						html += "	<td class=\"tc\">"+ v.forumMyCmntCnt +"</td>";
						html += "	<td class=\"tc\">";
						var mutAvg = v.mutAvg;
						for(i = 1; i <= 5; i++) {
							if(mutAvg >= i) html += "<i class=\"star icon orange\"></i>";
							else html += "<i class=\"star outline icon\"></i>";
						}
						html += "</td>";
						html += "	<td class=\"tc\">"+ v.mutCnt +"</td>";
						html += "	<td class=\"tc\">";
						html += "		<a href='javascript:forumMutEvalPop(\"" + v.stdNo + "\")' class='ui button small basic'><spring:message code='common.label.eval.opinion' /></a>"; // 평가의견
						html += "	</td>";
						html += "</tr>";
					});
					$("#mutEvalResultList").empty().append(html);
					$("#mutEvalResultTable").footable();
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert("<spring:message code='forum.common.error' />");/* 오류가 발생했습니다! */
			}, true);
		}
	
		function forumView(tab) {
			var urlMap = {
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
		
		function forumMutEvalPop(stdNo) {
			$("#mutEvalViewForm > input[name='crsCreCd']").val("${forumVo.crsCreCd}");
			$("#mutEvalViewForm > input[name='forumCd']").val("${forumVo.forumCd}");
			$("#mutEvalViewForm > input[name='stdNo']").val(stdNo);
			$("#mutEvalViewForm").attr("target", "mutEvalViewIfm");
			$("#mutEvalViewForm").attr("action", "/forum/forumLect/mutEvalViewPop.do");
			$("#mutEvalViewForm").submit();
			$('#mutEvalViewPop').modal('show');
		}
	</script>
</head>
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
            			<div id="info-item-box"> <!--  class="ui sticky" -->
                        	<script>
								// set location
								setLocationBar("<spring:message code='forum.label.forum'/>", "<spring:message code='forum.label.forum.info.score'/>");
							</script>
							
                            <h2 class="page-title flex-item flex-wrap gap4 columngap16">
                               <spring:message code='forum.label.forum'/><!-- 토론 -->
                            </h2>
                            <div class="button-area">
                            </div>
                        </div>
            		
	            		<div class="row">
	            			<div class="col">
								<div class="listTab">
									<ul class="">  
										<li class="mw120"><a  href="javascript:void(0)" onclick="forumView(1)"><spring:message code='forum.label.forum.bbs'/><!-- 토론방 --></a></li>
										<li class="mw120"><a href="javascript:void(0)" onclick="forumView(2)"><spring:message code='forum.label.forum.info.score'/><!-- 토론정보 및 평가 --></a></li>
	                                  	<li class="select mw120"><a href="javascript:void(0)" onclick="forumView(3)"><spring:message code='forum.label.mut.eval' /><!-- 상호평가 --></a></li>
	     							</ul>
								</div>
								
								<div class="ui segment">
									<%@ include file="/WEB-INF/jsp/forum/common/forum_info_inc.jsp" %>
								</div>
								<div class="ui segment">
									<h4 class="ui top attached header"><spring:message code='forum.label.eval.user.list' /><!-- 평가 대상자 목록 --></h4>
									<div class="ui bottom attached segment">
										<table class="table type2" data-sorting="true" data-paging="false" data-empty="<spring:message code='forum.common.empty' />" style="display: table;" id="mutEvalResultTable"><!-- 등록된 내용이 없습니다. -->
											<caption class="hide"><spring:message code='forum.label.eval.user.list' /><!-- 평가 대상자 목록 --></caption>
											<thead>
												<tr>
													<th scope="col" data-type="number">No</th>
													<th scope="col" data-breakpoints="xs" class="tc"><spring:message code="forum.label.dept.nm" /><!-- 학과 --></th>
													<th scope="col" data-breakpoints="xs" class="tc"><spring:message code="forum.label.user.no" /><!-- 학번 --></th>
													<th scope="col" class="tc"><spring:message code="forum.label.user_nm" /><!-- 이름 --></th>
													<th scope="col" data-breakpoints="xs" class="tc"><spring:message code="forum.label.forum.bbsCnt" /><!-- 토론 글수 --></th>
													<th scope="col" data-breakpoints="xs" class="tc"><spring:message code="forum.label.forum.commCnt" /><!-- 댓글수 --></th>
													<th scope="col" data-breakpoints="xs" class="tc"><spring:message code="forum.label.mutEval.avg" /><!-- 평균 별점 --></th>
													<th scope="col" data-breakpoints="xs" class="tc"><spring:message code="forum.label.eval.person" /><!-- 평가 인원 --></th>
													<th scope="col" class="tc"><spring:message code="common.label.eval.opinion" /><!-- 평가의견 --></th>
												</tr>
											</thead>
											<tbody id="mutEvalResultList">
											</tbody>
										</table>
									</div>
								</div>
	            			</div>
	            		</div>
            		</div>
            	</div>
            </div>
			<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>			
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
	<!-- 피드백 작성  모달 -->
	<script type="text/javascript">
	$('iframe').iFrameResize();
	window.closeModal = function() {
		$('.modal').modal('hide');
		$("#mutEvalViewIfm").attr("src", "");
	};
	</script>
</body>
</html>