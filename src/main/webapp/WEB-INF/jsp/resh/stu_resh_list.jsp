<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<%@ include file="/WEB-INF/jsp/resh/common/resh_common_inc.jsp" %>
	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
	
	<script type="text/javascript">
		$(document).ready(function () {
			listResh();
			
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					listResh();
				}
			});
			
			$("#listType").on("click", function() {
				$(this).children("i").toggleClass("list th");
				listResh();
			});
		});
	
		// 설문 리스트 조회
		function listResh() {
			var	url = "/resh/reshList.do";
			var data = {
				"crsCreCd" 	  : "${vo.crsCreCd}",
				"reschTypeCd" : "LECT",
				"searchValue" : $("#searchValue").val(),
				"searchMenu"  : "LEARNER"
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
	        		var html = createReshListHTML(returnList);
	        		
	        		$("#list").empty().html(html);
	        		if($("#listType i").hasClass("th")){
		    			$(".table").footable();
	        		} else {
	        			$(".ui.dropdown").dropdown();
	        			$(".card-item-center .title-box label").unbind('click').bind('click', function(e) {
	        		        $(".card-item-center .title-box label").toggleClass('active');
	        		    });
	        		}
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert("<spring:message code='resh.error.list' />");/* 설문 리스트 조회 중 에러가 발생하였습니다. */
			});
		}
		
		// 설문 정보 페이지
		function viewResh(reschCd) {
			var kvArr = [];
			kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
			kvArr.push({'key' : 'reschCd',  'val' : reschCd});
			
			submitForm("/resh/stuReshView.do", "", "", kvArr);
		}
		
		// 설문 팝업
		function reshPop(reschCd, type) {
			var typeMap = {
				"join"   : {"modal" : "join",   "url" : "/resh/reshJoinPop.do"},	// 설문 첫 참여
				"edit"   : {"modal" : "join",   "url" : "/resh/reshEditPop.do"},	// 설문 재 참여
				"result" : {"modal" : "result", "url" : "/resh/reshResultPop.do"}	// 설문 결과
			};
			
			var kvArr = [];
			kvArr.push({'key' : 'reschCd',   'val' : reschCd});
			kvArr.push({'key' : 'searchKey', 'val' : "list"});
			kvArr.push({'key' : 'userId',  	 'val' : "${vo.userId }"});
			kvArr.push({'key' : 'stdNo',  	 'val' : "${vo.stdNo }"});
			
			submitForm(typeMap[type]["url"], "reshPopIfm", typeMap[type]["modal"], kvArr);
		}
		
		// 설문 리스트 생성
		function createReshListHTML(reshList) {
			var html = ``;
			var reschMap = {};
			
			// 값 설정
			reshList.forEach(function(v, i) {
				// 제목
				var reschTitle	   = escapeHtml(v.reschTitle);
				// 시작일자
				var reschStartDttm = dateFormat("date", v.reschStartDttm);
				// 종료일자
				var reschEndDttm   = dateFormat("date", v.reschEndDttm);
				// 지각제출마감일자
				var extEndDttm	   = v.extEndDttm != null && v.extEndDttm != "" ? dateFormat("date", v.extEndDttm) : "-";
				// 설문 진행상태
				var reschStatus	   = v.reschStatus == '대기' || v.reschStatus == '진행' ? "<spring:message code='resh.label.resh.proceeding' />"/* 진행중 */ : "<spring:message code='resh.label.resh.deadline' />"/* 마감 */;
				if($("#listType i").hasClass("list")) reschStatus += v.joinYn == "Y" ? v.reschStatus == "완료" && v.scoreOpenYn == "Y" ? "("+v.score+"<spring:message code='resh.label.score' />)"/* 점 */ : "(<spring:message code='resh.label.submit.y' />)"/* 제출완료 */ : "(<spring:message code='resh.label.submit.n' />)"/* 미제출 */;
				// 제출상태(점수포함)
				var submitStatus   = v.joinYn == "Y" ? v.reschStatus == "완료" && v.scoreOpenYn == "Y" ? v.score+"<spring:message code='resh.label.score' />"/* 점 */ : "<spring:message code='resh.label.submit.y' />"/* 제출완료 */ : "<spring:message code='resh.label.submit.n' />"/* 미제출 */;
				// 성적 공개여부
				var scoreOpenYn = v.scoreOpenYn == "Y" ? "<spring:message code='resh.common.yes' />"/* 예 */ : "<spring:message code='resh.common.no' />"/* 아니오 */;
				
				var map = {
					"title" : reschTitle, "startDttm" : reschStartDttm, "endDttm" : reschEndDttm, "extDttm" : extEndDttm, "status" : reschStatus, "submit" : submitStatus, "open" : scoreOpenYn
				};
				reschMap[v.reschCd] = map;
			});
			
			if($("#listType i").hasClass("th")){
				html += `<table class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code='resh.common.empty' />">`;/* 등록된 내용이 없습니다. */
				html += `   <caption class="hide">설문</caption>`;
				html += `	<thead>`;
				html += `		<tr>`;
				html += `			<th scope="col" class="tc">NO.</th>`;
				html += `			<th scope="col" class="tc"><spring:message code="resh.label.type" /></th>`;/* 구분 */
				html += `			<th scope="col" class="tc"><spring:message code="resh.label.title" /></th>`;/* 설문명 */
				html += `			<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="resh.label.period" /></th>`;/* 설문기간 */
				html += `			<th scope="col" class="tc" data-breakpoints="xs sm"><spring:message code="resh.label.ext.end.dt" /></th>`;/* 지각제출마감일 */
				html += `			<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="resh.label.score.open.yn" /></th>`;/* 성적공개 */
				html += `			<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="resh.label.inprogress" /><spring:message code="resh.label.status" /></th>`;/* 진행 *//* 상태 */
				html += `			<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code="resh.label.status.submit.eval" /></th>`;/* 제출/평가현황 */
				html += `			<th scope="col" class="tc"><spring:message code="resh.label.manage" /></th>`;/* 관리 */
				html += `		</tr>`;
				html += `	</thead>`;
				html += `	<tbody>`;
				reshList.forEach(function(v, i) {
					html += `	<tr>`;
					html += `		<td class="tc">\${v.lineNo }</td>`;
					html += `		<td class="tc"><spring:message code="resh.label.basic.resh" />​</td>`;/* 일반설문 */
					html += `		<td><a href="javascript:viewResh('\${v.reschCd }')" class="header header-icon link">\${reschMap[v.reschCd]["title"] }</a></td>`;
					html += `		<td class="tc">\${reschMap[v.reschCd]["startDttm"] } ~<br> \${reschMap[v.reschCd]["endDttm"] }</td>`;
					html += `		<td class="tc">\${reschMap[v.reschCd]["extDttm"] }</td>`;
					html += `		<td class="tc">\${reschMap[v.reschCd]["open"]}</td>`;
					html += `		<td class="tc">\${reschMap[v.reschCd]["status"]}</td>`;
					if("<%=SessionInfo.getAuditYn(request) %>" == "Y") {
					html += `		<td class="tc">-</td>`;
					} else {
					html += `		<td class="tc">\${reschMap[v.reschCd]["submit"] }</td>`;
					}
					html += `		<td class="tc">`;
					if("<%=SessionInfo.getAuditYn(request) %>" != "Y") {
						if(v.reschStatus == '진행' && v.joinYn == 'N' && PROFESSOR_VIRTUAL_LOGIN_YN != "Y") {
					html += `			<a href="javascript:reshPop('\${v.reschCd }', 'join')" class="ui small blue button"><spring:message code="resh.label.resh.join" /></a>`;/* 설문참여 */
						} else if(v.reschStatus == '진행' && v.joinYn == 'Y') {
					html += `			<a href="javascript:reshPop('\${v.reschCd }', 'edit')" class="ui small blue button"><spring:message code="resh.label.resh.edit" /></a>`;/* 설문수정 */
						} else if(v.reschStatus == '완료' && (v.rsltTypeCd == 'ALL' || (v.rsltTypeCd == 'JOIN' && v.joinYn == 'Y')) && v.reschQstnCnt > 0) {
					html += `			<a href="javascript:reshPop('\${v.reschCd }', 'result')" class="ui small basic button"><spring:message code="resh.label.resh.result" /></a>`;/* 설문결과 */
						}
					}
					html += `		</td>`;
					html += `	</tr>`;
				});
				html += `	</tbody>`;
				html += `</table>`;
			} else {
				if(reshList.length > 0) {
					html += `<div class='ui two stackable cards info-type mt10'>`;
					reshList.forEach(function(v, i) {
					html += `<div class="card">`;
					html += `	<div class="content card-item-center">`;
					html += `		<div class="title-box">`;
					html += `			<label class="ui yellow label active"><spring:message code="resh.label.basic.resh" />​</label>`;/* 일반설문 */
					html += `			<a href="javascript:viewResh('\${v.reschCd }')" class="header header-icon link">\${reschMap[v.reschCd]["title"] }</a>`;
					html += `		</div>`;
					html += `	</div>`;
					html += `	<div class="sum-box">`;
					html += `		<ul class="process-bar">`;
					html += `			<li class="wmax \${v.reschStatus == '대기' || v.reschStatus == '진행' ? `bar-blue` : `bar-softgrey`}">\${reschMap[v.reschCd]["status"]}</li>`;
					html += `		</ul>`;
					html += `	</div>`;
					html += `	<div class="content ui form equal width">`;
					html += `		<div class="fields">`;
					html += `			<div class="inline field">`;
					html += `				<label class="label-title-lg"><spring:message code="resh.label.period" /></label>`;/* 설문기간 */
					html += `				<i>\${reschMap[v.reschCd]["startDttm"] } ~ \${reschMap[v.reschCd]["endDttm"] }</i>`;
					html += `			</div>`;
					html += `		</div>`;
					html += `		<div class="fields">`;
					html += `			<div class="inline field">`;
					html += `				<label class="label-title-lg"><spring:message code="resh.label.ext.join.yn" /></label>`;/* 지각제출 */
					html += `				<i>\${reschMap[v.reschCd]["extDttm"] }</i>`;
					html += `			</div>`;
					html += `		</div>`;
					html += `		<div class="fields">`;
					html += `			<div class="inline field">`;
					html += `				<label class="label-title-lg"><spring:message code="resh.label.item.cnt" /></label>`;/* 문항수 */
					html += `				<i>\${v.reschQstnCnt }</i>`;
					html += `			</div>`;
					html += `		</div>`;
					html += `		<div class="fields">`;
					html += `			<div class="inline field">`;
					html += `				<label class="label-title-lg"><spring:message code="resh.label.score.open.yn" /></label>`;/* 성적공개 */
					html += `				<i>\${reschMap[v.reschCd]["open"]}</i>`;
					html += `			</div>`;
					html += `		</div>`;
					html += `		<div class="option-content mt20">`;
					html += `			<div class="mla">`;
					if("<%=SessionInfo.getAuditYn(request) %>" != "Y") {
						if(v.reschStatus == '진행' && v.joinYn == 'N' && PROFESSOR_VIRTUAL_LOGIN_YN != "Y") {
					html += `				<a href="javascript:reshPop('\${v.reschCd }', 'join')" class="ui blue button"><spring:message code="resh.label.resh.join" /></a>`;/* 설문참여 */
						} else if(v.reschStatus == '진행' && v.joinYn == 'Y' && PROFESSOR_VIRTUAL_LOGIN_YN != "Y") {
					html += `				<a href="javascript:reshPop('\${v.reschCd }', 'edit')" class="ui blue button"><spring:message code="resh.label.resh.edit" /></a>`;/* 설문수정 */
						} else if(v.reschStatus == '완료' && (v.rsltTypeCd == 'ALL' || (v.rsltTypeCd == 'JOIN' && v.joinYn == 'Y')) && v.reschQstnCnt > 0) {
					html += `				<a href="javascript:reshPop('\${v.reschCd }', 'result')" class="ui basic button"><spring:message code="resh.label.resh.result" /></a>`;/* 설문결과 */
						}
					}
					html += `			</div>`;
					html += `		</div>`;
					html += `	</div>`;
					html += `</div>`;
				});
				html += `</div>`;
			} else {
				html += "<div class='flex-container'>";
				html += "	<div class='no_content'>";
				html += "		<i class='icon-cont-none ico f170'></i>";
				html += "		<span><spring:message code='resh.common.empty' /></span>";/* 등록된 내용이 없습니다. */
				html += "	</div>";
				html += "</div>";
			}
		}
		
		return html;
	}
</script>
</head>
<body class="<%=SessionInfo.getThemeMode(request)%>">
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>

        <div id="container">
            <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>
            <!-- 본문 content 부분 -->
            <div class="content stu_section">
            	<%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
        		<div class="ui form">
        			<div class="layout2">
        				<script>
						$(document).ready(function () {
							// set location
							setLocationBar('<spring:message code="resh.label.resh" />', '<spring:message code="exam.button.list" />');
						});
						</script>
		                <div id="info-item-box">
		                	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="resh.label.resh" /><!-- 설문 -->
                            </h2>
		                </div>
		                <div class="row">
		                	<div class="col">
				                <div class="option-content mb10">
				                    <button class="ui basic icon button" id="listType" title="리스트형 출력"><i class="list ul icon"></i></button>
				                    <div class="ui action input search-box mr5">
				                    	<label for="searchValue" class="hide"><spring:message code='resh.label.title' /></label>
				                        <input type="text" id="searchValue" placeholder="<spring:message code='resh.label.title' /> <spring:message code='resh.label.input' />"><!-- 설문명 --><!-- 입력 -->
				                        <button class="ui icon button" onclick="listResh()"><i class="search icon"></i></button>
				                    </div>
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
</body>
</html>