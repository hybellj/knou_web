<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/resh/common/resh_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/admin/admin-default.css">
<script type="text/javascript">
	$(document).ready(function() {
	});
	
	// 설문 정보 페이지
	function manageResh(tab) {
		var urlMap = {
			"0" : "/resh/reshMgr/homeReshInfoManage.do",	// 전체설문 정보 상세 페이지
			"1" : "/resh/reshMgr/homeReshQstnManage.do",	// 전체설문 문항 관리 페이지
			"2" : "/resh/reshMgr/homeReshResultManage.do",	// 전체설문 결과 페이지
			"3" : "/resh/reshMgr/Form/editHomeResh.do",		// 수정 페이지
			"9" : "/resh/reshMgr/Form/homeReshList.do"		// 목록
		};
		
		var kvArr = [];
		kvArr.push({'key' : 'reschCd', 'val' : "${vo.reschCd}"});
		
		submitForm(urlMap[tab], "", "", kvArr);
	}
	
	// 설문 삭제
	function delResh() {
		var url  = "/resh/selectReshInfo.do";
		var data = {
			"reschTypeCd" : "HOME",
			"reschCd"  	  : "${vo.reschCd}"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var confirm = "";
        		var reshVO = data.returnVO;
        		if(reshVO.homeReschJoinUserCnt > 0) {
        			confirm = window.confirm(`<spring:message code="resh.comfirm.home.resh.exist.join.user.y" />`);/* 전체설문 참여자가 있습니다. 삭제 시 전체설문결과가 삭제됩니다.\r\n정말 삭제 하시겠습니까? */
        		} else {
        			confirm = window.confirm("<spring:message code='resh.comfirm.home.resh.exist.join.user.n' />");/* 전체설문 참여자가 없습니다. 삭제 하시겠습니까? */
        		}
        		if(confirm) {
        			var kvArr = [];
        			kvArr.push({'key' : 'reschCd', 'val' : "${vo.reschCd}"});
        			
        			submitForm("/resh/reshMgr/delHomeResh.do", "", "", kvArr);
        		}
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='resh.error.delete' />");/* 설문 삭제 중 에러가 발생하였습니다. */
		});
	}
</script>

<body>
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>

        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>

		<div id="container">
		    <!-- 본문 content 부분 -->
		    <div class="content">
		    	<%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
		       	<div class="ui form">
		       		<div class="layout2">
				        <div id="info-item-box">
				        	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="resh.label.resh.home" /><!-- 전체설문 -->
                                <div class="ui breadcrumb small">
                                    <small class="section"><spring:message code="resh.label.resh.home.info.manage" /><!-- 정보 및 관리 : 전체설문정보 --></small>
                                </div>
                            </h2>
                            <div class="button-area">
                            	<a href="javascript:manageResh(3)" class="ui blue button"><spring:message code="resh.button.modify" /></a><!-- 수정 -->
								<a href="javascript:manageResh(9)" class="ui blue button"><spring:message code="resh.button.list" /></a><!-- 목록 -->
								<a href="javascript:delResh()" class="ui blue button"><spring:message code="resh.button.delete" /></a><!-- 삭제 -->
                            </div>
				        </div>
				        <div class="row">
				        	<div class="col">
				        		<div class="listTab mb20">
					                <ul>
					                    <li class="select mw120"><a onclick="manageResh(0)"><spring:message code="resh.label.resh.home.info" /><!-- 전체설문정보 --></a></li>
					                    <li class="mw120"><a onclick="manageResh(1)"><spring:message code="resh.tab.item.manage" /></a></li><!-- 문항 관리 -->
					                    <li class="mw120"><a onclick="manageResh(2)"><spring:message code="resh.label.resh.home.result" /><!-- 전체설문결과 --></a></li>
					                </ul>
					            </div>
								<div class="ui grid stretched">
									<div class="sixteen wide tablet eight wide computer column">
										<div class="ui segment">
											<table class="tBasic">
												<tbody>
													<tr>
														<th><spring:message code="resh.label.resh.home.title" /><!-- 전체설문명 --></th>
														<td>${vo.reschTitle }</td>
													</tr>
													<tr>
														<th><spring:message code="resh.label.resh.home.cts" /><!-- 전체설문 내용 --></th>
														<td><pre>${vo.reschCts}</pre></td>
													</tr>
													<tr>
														<fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss" value="${vo.reschStartDttm }" />
														<fmt:formatDate var="reschStartDttm" pattern="yyyy.MM.dd HH:mm" value="${startDateFmt }" />
														<fmt:parseDate var="endDateFmt" pattern="yyyyMMddHHmmss" value="${vo.reschEndDttm }" />
														<fmt:formatDate var="reschEndDttm" pattern="yyyy.MM.dd HH:mm" value="${endDateFmt }" />
														<th><spring:message code="resh.label.resh.home.period" /><!-- 전체설문 기간 --></th>
														<td>${reschStartDttm } - ${reschEndDttm }</td>
													</tr>
													<tr>
														<th><spring:message code="resh.label.resh.home.join.trgt" /><!-- 참여대상 --></th>
														<td>
															<c:forEach var="item" items="${userTypeList }">
																<c:if test="${fn:contains(vo.joinTrgt, item.codeCd) }">
																	${item.codeNm }
																</c:if>
															</c:forEach>
														</td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
									<div class="sixteen wide tablet eight wide computer column">
										<div class="ui segment">
											<ul class="tbl-simple">
												<li>
													<dl>
														<dt>
															<label for="taskTypeLabel"><spring:message code="resh.label.added.option" /></label><!-- 옵션 -->
														</dt>
														<dd></dd>
													</dl>
												</li>
											</ul>
											<div class="ui segment">
												<ul class="tbl-simple">
													<li>
														<ul class="num-chk d-inline-block">
															<li><span class="${vo.rsltTypeCd eq 'ALL' || vo.rsltTypeCd eq 'JOIN' ? 'bcGreen' : 'bcLgrey' }"></span></li>
														</ul>
														<label for="taskTypeLabel"><spring:message code="resh.label.resh.home.rslt.open.yn" /><!-- 전체설문결과 조회 가능 --></label>
													</li>
												</ul>
											</div>
										</div>
									</div>
								</div>
				        	</div>
				        </div>
		       		</div>
		       	</div>
			</div>
	        <!-- //본문 content 부분 -->
	        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
	    </div>
    </div>

</body>

</html>