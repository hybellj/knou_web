<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<script type="text/javascript">
	var searchData = {};

	$(document).ready(function() {
		$("#searchValue").on("keydown", function(e) {
			if(e.keyCode == 13) {
				listPaging(1);
			}
		});
		listPaging(1);
	});
	
	function listPaging(pageIndex) {
		searchData = {};
		
		var url = "/resh/stuReshList.do";
		var data = {
			  crsCreCd		: '<c:out value="${param.crsCreCd}" />'
			, reschCtgrCd	: '<c:out value="${reschCtgrCd}" />'
			, reschTypeCd	: "LEVEL"
			, pageIndex		: pageIndex
			, listScale   	: $("#listScale").val()
			, searchValue 	: $("#searchValue").val()
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				searchData = data;
				
				setList();
        	}
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
		});
	}
	
	// 목록/카드형 리스트 생성
	function createLectEvalListHTML(list, pageInfo) {
		var isList = $("#listType i").hasClass("list");
		var menuType = '<c:out value="${menuType}" />';
		var isStudent = menuType.indexOf("STUDENT") > -1;
		
		if(isList) {
			var html = '';
			var listHtml = '';
			
			list.forEach(function(v, i) {
				var lineNo = pageInfo.totalRecordCount - v.lineNo + 1;
				var reschStartDttmFmt = (v.reschStartDttm || "").length == 14 ? v.reschStartDttm.substring(0, 4) + '.' + v.reschStartDttm.substring(4, 6) + '.' + v.reschStartDttm.substring(6, 8) + ' ' + v.reschStartDttm.substring(8, 10) + ':' + v.reschStartDttm.substring(10, 12) : v.reschStartDttm;
				var reschEndDttmFmt = (v.reschEndDttm || "").length == 14 ? v.reschEndDttm.substring(0, 4) + '.' + v.reschEndDttm.substring(4, 6) + '.' + v.reschEndDttm.substring(6, 8) + ' ' + v.reschEndDttm.substring(8, 10) + ':' + v.reschEndDttm.substring(10, 12) : v.reschEndDttm;
								
				listHtml += '<tr>';
				listHtml += '	<td>' + lineNo + '</td>';
				listHtml += '	<td><a href="javascript:void(0)" class="fcBlue" onclick="moveLevelEvalView(\'' + v.reschCd + '\')">' + v.reschTitle + '</a></td>';
				listHtml += '	<td>' + reschStartDttmFmt + ' ~<br />' + reschEndDttmFmt + ' <span style="visibility: hidden">~</span></td>';
				listHtml += '	<td>' + v.reschQstnCnt + '</td>';
				listHtml += '	<td>' + v.reschStatus + '</td>';
				listHtml += '	<td>' + (v.scoreViewYn == "Y" ? '<spring:message code="resh.label.open.y" />' : '<span class="fcRed"><spring:message code="resh.label.open.n" /></span>') + '</td>'; // 공개, 비공개
				listHtml += '	<td>' + (v.reschJoinUserCnt + '/' + v.reschTotalUserCnt) + '</td>';
				if(isStudent && PROFESSOR_VIRTUAL_LOGIN_YN != "Y") {
						listHtml += '	<td>';
					if(isStudent && v.reschStatus == '진행' && v.joinYn == 'N') {
						listHtml += '		<a href="javascript:void(0)" class="ui blue button small" onclick="reshJoinPop(\'' + v.reschCd + '\')"><spring:message code="resh.button.level.eval.join" /></a>'; // 만족도조사 참여
					}
					if(isStudent && v.reschStatus == '진행' && v.joinYn == 'Y') {
						listHtml += '		<a href="javascript:void(0)" class="ui blue button small" onclick="reshJoinPop(\'' + v.reschCd + '\')"><spring:message code="resh.button.level.eval.join" /></a>'; // 만족도조사 수정
					}
						listHtml += '	</td>';
				}
				listHtml += '</tr>';
			});

			html += '<table class="table" id="lectEvalList">';
			html += '	<thead>';
			html += '		<tr>';
			html += '			<th><spring:message code="common.number.no" /></th>'; // NO.
			html += '			<th><spring:message code="resh.label.level.eval.name" /></th>'; // 만족도조사명
			html += '			<th data-breakpoints="xs"><spring:message code="resh.label.level.eval.period" /></th>'; // 만족도조사 기간
			html += '			<th data-breakpoints="xs"><spring:message code="resh.label.item.cnt" /></th>'; // 문항수
			html += '			<th data-breakpoints="xs"><spring:message code="resh.label.progress.status" /></th>'; 	// 진행상태
			html += '			<th data-breakpoints="xs"><spring:message code="resh.label.score.open.yn" /></th>'; // 성적공개
			html += '			<th data-breakpoints="xs"><spring:message code="resh.label.join.status" /></th>'; // 응시현황
		if(isStudent) {
			html += '			<th data-breakpoints="xs"><spring:message code="resh.label.manage" /></th>'; // 관리
		}
			html += '		</tr>';
			html += '	</thead>';
			html += '	<tbody>';
			html += 		listHtml;
			html += '	</tbody>';
			html += '</table>';
			html += '<div id="paging" class="paging"></div>';
		
			return html;
		} else {
			if(list.length == 0 ){
				var html = '';
				
				html += '<div class="flex-container">';
				html += '	<div class="cont-none">';
				html += '		<span><spring:message code="resh.common.empty" /></span>'; // 등록된 내용이 없습니다.
				html += '	</div>';
				html += '</div>';
				
				return html;
			} else {
				var html = '';
				var listHtml = '';
				
				list.forEach(function(v, i) {
					var reschStartDttmFmt = (v.reschStartDttm || "").length == 14 ? v.reschStartDttm.substring(0, 4) + '.' + v.reschStartDttm.substring(4, 6) + '.' + v.reschStartDttm.substring(6, 8) + ' ' + v.reschStartDttm.substring(8, 10) + ':' + v.reschStartDttm.substring(10, 12) : v.reschStartDttm;
					var reschEndDttmFmt = (v.reschEndDttm || "").length == 14 ? v.reschEndDttm.substring(0, 4) + '.' + v.reschEndDttm.substring(4, 6) + '.' + v.reschEndDttm.substring(6, 8) + ' ' + v.reschEndDttm.substring(8, 10) + ':' + v.reschEndDttm.substring(10, 12) : v.reschEndDttm;
					
					listHtml += '<div class="card">';
					listHtml += '	<div class="content card-item-center">';
					listHtml += '		<div class="title-box">';
					listHtml += '			<label class="ui yellow label active"><spring:message code="resh.label.level.eval" /></label>'; // 만족도조사
					listHtml += '			<a href="javascript:void(0)" class="header header-icon" onclick="moveLevelEvalView(\'' + v.reschCd + '\')">' + v.reschTitle + '</a>';
					listHtml += '		</div>';
					listHtml += '	</div>';
					listHtml += '	<div class="sum-box">';
					listHtml += '		<ul class="process-bar">';
				if(v.reschStatus == '대기') {
					listHtml += '			<li class="bar-softgrey"><spring:message code="resh.label.level.eval" /> <spring:message code="resh.label.ready" /></li>'; // 만족도조사 대기
				} else if(v.reschStatus == '진행') {
					listHtml += '			<li class="bar-blue"><spring:message code="resh.label.level.eval" /> <spring:message code="resh.label.inprogress" /></li>'; // 만족도조사 진행
				} else if(v.reschStatus == '완료') {
					listHtml += '			<li class="bar-softgrey"><spring:message code="resh.label.level.eval" /> <spring:message code="resh.label.complete" /></li>'; // 만족도조사 완료
				}
					listHtml += '		</ul>';
					listHtml += '	</div>';
					listHtml += '	<div class="content ui form equal width">';
					listHtml += '		<div class="fields">';
					listHtml += '			<div class="inline field">';
					listHtml += '				<label class="label-title-lg"><spring:message code="resh.label.level.eval.period" /></label>'; // 만족도조사 기간
					listHtml += '				<i>' + reschStartDttmFmt + ' ~ ' + reschEndDttmFmt + '</i>';
					listHtml += '			</div>';
					listHtml += '		</div>';
					listHtml += '		<div class="fields">';
					listHtml += '			<div class="inline field">';
					listHtml += '				<label class="label-title-lg"><spring:message code="resh.label.applicant.cnt" /></label>'; // 대상인원
					listHtml += '				<i>' + v.reschTotalUserCnt + '<spring:message code="resh.label.nm" /></i>'; // 명
					listHtml += '			</div>';
					listHtml += '		</div>';
					listHtml += '		<div class="fields">';
					listHtml += '			<div class="inline field">';
					listHtml += '				<label class="label-title-lg"><spring:message code="resh.label.item.cnt" /></label>'; // 문항수
					listHtml += '				<i>' + v.reschQstnCnt + '</i>';
					listHtml += '			</div>';
					listHtml += '		</div>';
					listHtml += '		<div class="fields">';
					listHtml += '			<div class="inline field">';
					listHtml += '				<label class="label-title-lg"><spring:message code="resh.label.score.open.yn" /></label>'; // 성적공개
					listHtml += '				<i>' + (v.scoreViewYn == "Y" ? '<spring:message code="resh.label.open.y" />' : '<span class="fcRed"><spring:message code="resh.label.open.n" /></span>') + '</i>'; // 공개, 비공개
					listHtml += '			</div>';
					listHtml += '		</div>';
					listHtml += '		<div class="fields mt20">';
					listHtml += '			<div class="field tc">';
				if(isStudent && v.reschStatus == '진행' && v.joinYn == 'N' && PROFESSOR_VIRTUAL_LOGIN_YN != "Y") {
					listHtml += '				<a href="javascript:void(0)" class="ui blue button w150" onclick="reshJoinPop(\'' + v.reschCd + '\')"><spring:message code="resh.button.level.eval.join" /></a>'; // 만족도조사 참여
				}
				if(isStudent && v.reschStatus == '진행' && v.joinYn == 'Y' && PROFESSOR_VIRTUAL_LOGIN_YN != "Y") {
					listHtml += '				<a href="javascript:void(0)" class="ui blue button w150" onclick="reshJoinPop(\'' + v.reschCd + '\')"><spring:message code="resh.button.level.eval.edit" /></a>'; // 만족도조사 수정
				}
					listHtml += '			</div>';
					listHtml += '		</div>';
					listHtml += '	</div>';
					listHtml += '</div>';
				});
				
				html += '<div class="ui two stackable cards info-type mt10">';
				html += 	listHtml;
				html += '</div>';
				html += '<div id="paging" class="paging"></div>';
						
				return html;
			}
		}
	}
	
	// 리스트 타입 변환
	function listType() {
	 	if($("#listType i").hasClass("list")) {
			$("#listType i").removeClass("list").addClass("qrcode");
		} else {
			$("#listType i").removeClass("qrcode").addClass("list");
		}
	 	setList();
	}
	
	// 리스트 세팅
	function setList() {
		var returnList = searchData.returnList || [];
		var pageInfo = searchData.pageInfo;
		var html = createLectEvalListHTML(returnList, pageInfo);
		
		$("#levelEvalList").empty().html(html);
		
		if($("#levelEvalList > table").length != 0) {
			// 리스트형 footable 적용
			$("#levelEvalList > table").footable();
		} else {
			// 카드형 dropdown 적용
			$("#levelEvalList").find(".ui.dropdown").dropdown();
		}
		
		var params = {
			  totalCount : pageInfo.totalRecordCount
			, listScale : pageInfo.recordCountPerPage
			, currentPageNo : pageInfo.currentPageNo
			, eventName : "listPaging"
		};
		
		gfn_renderPaging(params);
	}
	
	// 상세보기 이동
	function moveLevelEvalView(reschCd) {
		var url  = "/resh/Form/levelEvalView.do";
		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "form");
		form.attr("action", url);
		form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '<c:out value="${param.crsCreCd}" />'}));
		form.append($('<input/>', {type: 'hidden', name: 'reschCd',  value: reschCd}));
		form.appendTo("body");
		form.submit();
	}
	
	// 설문 참여 팝업
	function reshJoinPop(reschCd) {
		$("#popReschCd").val(reschCd);
		$("#reshPopForm").attr("target", "reshJoinPopIfm");
        $("#reshPopForm").attr("action", "/resh/evalReshJoinPop.do");
        $("#reshPopForm").submit();
        $('#reshJoinPop').modal('show');
	}
</script>
<body class="<%=SessionInfo.getThemeMode(request)%>">
	<form id="reshPopForm" name="reshPopForm" method="POST">
		<input type="hidden" name="reschCd" value="" id="popReschCd" />
		<input type="hidden" name="reschCtgrCd" value="<c:out value="${reschCtgrCd}" />" />
		<input type="hidden" name="stdNo" value="<c:out value="${stdNo}" />" />
		<input type="hidden" name="searchKey" value="view" />
	</form>
	<div id="wrap" class="pusher">
		<%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>
		
		<div id="container">
			<%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>
			
			<!-- 본문 content 부분 -->
			<div class="content stu_section">
				<%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
			
				<div class="ui form">
		        	<div class="layout2">
		        		<!-- 타이틀 -->
						<div id="info-item-box">
							<script>
								$(document).ready(function () {
									var title1 = '<spring:message code="resh.label.level.eval" />'; // 만족도조사
									var title2 = '<spring:message code="resh.button.list" />'; // 목록
									
									// set location
									setLocationBar(title1, title2);
								});
							</script>
		                    <h2 class="page-title flex-item flex-wrap gap4 columngap16">
		                    	<spring:message code="resh.label.level.eval" /><!-- 만족도조사 -->
	                    	</h2>
		                    <div class="button-area">
		                    </div>
		                </div>
		                
		                <!-- 영역1 -->
                        <div class="row">
                            <div class="col">
                            	<!-- 검색조건 -->
								<div class="option-content mb10">
									<button class="ui grey icon button" id="listType" title="<spring:message code="asmnt.label.title.list" />" onclick="listType()"><i class="qrcode ul icon"></i></button>
									<div class="ui action input search-box" style="max-width: calc(100% - 45px)">
										<input id="searchValue" type="text" placeholder="<spring:message code="resh.label.level.eval.name" />" value="${param.searchValue}" /><!-- 만족도조사명 -->
										<button class="ui icon button" type="button" onclick="listPaging(1)">
											<i class="search icon"></i>
										</button>
									</div>
									<div class="select_area">
										<select class="ui dropdown list-num" id="listScale" onchange="listPaging(1)">
								            <option value="10">10</option>
								            <option value="20">20</option>
								            <option value="50">50</option>
								            <option value="100">100</option>
								        </select>
									</div>
								</div>
								<div id="levelEvalList"></div>
                            </div><!-- //col -->
                    	</div><!-- //row -->
		        	</div><!-- //layout2 -->
	        	</div><!-- //ui form -->
			</div><!-- //content stu_section -->
			<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
		</div><!-- //container -->
		
	</div><!-- //wrap -->
	
	<!-- 만족도조사 참여 팝업 --> 
	<div class="modal fade" id="reshJoinPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="resh.button.level.eval.join" />" aria-hidden="false">
	    <div class="modal-dialog modal-lg" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="sys.button.close" />">
	                    <span aria-hidden="true">&times;</span>
	                </button>
	                <h4 class="modal-title"><spring:message code="resh.button.level.eval.join" /></h4><!-- 만족도조사 참여 -->
	            </div>
	            <div class="modal-body">
	                <iframe src="" id="reshJoinPopIfm" name="reshJoinPopIfm" width="100%" scrolling="no"></iframe>
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
</body>