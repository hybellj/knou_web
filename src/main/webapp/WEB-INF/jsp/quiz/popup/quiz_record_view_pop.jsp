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

	<script type="text/javascript">
		$(document).ready(function() {
			divShow(1);
		});

		// 로그 화면 선택
		function divShow(idx) {
			$(".logDiv").hide();
			if(idx == 1) {
				$("#eventDiv").show();
			} else {
				$("#ansrDiv").show();
			}
		}

		// 문제 답안 로그
		function selectQstnNo(obj) {
			var url  = "/quiz/listPaperHstyLog.do";
			var data = {
				"examCd" : "${vo.examCd}",
				"stdNo"  : "${vo.stdNo}",
				"qstnNo" : $(obj).val()
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var returnList = data.returnList || [];
					var html = "";

					if(returnList.length > 0) {
						returnList.forEach(function(v, i) {
							var regDttm = v.regDttm.substring(0, 4) + "." + v.regDttm.substring(4, 6) + "." + v.regDttm.substring(6, 8) + " " + v.regDttm.substring(8, 10) + ":" + v.regDttm.substring(10, 12) + ":" + v.regDttm.substring(12, 14);
							html += "<tr>";
							html += "	<td class='tc'>"+v.lineNo+"</td>";
							html += "	<td class='tc'>"+v.stareAnsr+"</td>";
							html += "	<td class='tc'>"+v.hstyTypeNm+"</td>";
							html += "	<td class='tc'>"+regDttm+"</td>";
							html += "	<td class='tc'>"+v.connIp+"</td>";
							html += "</tr>";
						});
					}

					$("#logTbody").empty().html(html);
					$("#logTable").footable();
	            } else {
	             	alert(data.message);
	            }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
    		});
		}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<div class="option-content">
	            <h2 class="page-title">${creCrsVO.crsCreNm } (${creCrsVO.declsNo }<spring:message code="exam.label.decls" />)</h2><!-- 반 -->
	            <div class="mla fcBlue">
	            	<b>${stareVO.deptNm } ${stareVO.userId } ${stareVO.userNm } <span class="f150">${stareVO.totGetScore }<spring:message code="exam.label.score.point" /></span></b><!-- 점 -->
	            </div>
        	</div>
			<hr/>
			<div class="option-content m10">
	            <h3>${vo.examTitle }</h3>
			</div>
			<div class="mb10">
				<button class="ui basic small button" onclick="divShow(1)"><spring:message code="exam.button.event.log" /><!-- 이벤트 로그 --></button>
				<button class="ui basic small button" onclick="divShow(2)"><spring:message code="exam.button.ansr.log" /><!-- 답안 로그 --></button>
			</div>
			<div id="eventDiv" class="logDiv">
				<table class="table" data-sorting="true" data-paging="false" data-empty="<spring:message code='exam.common.empty' />"><!-- 등록된 내용이 없습니다. -->
					<thead>
						<tr>
							<th scope="col" class="num tc"><spring:message code="common.number.no" /><!-- NO. --></th>
							<th scope="col" class="tc"><spring:message code="exam.label.dept" /></th><!-- 학과 -->
							<th scope="col" class="tc"><spring:message code="exam.label.user.no" /></th><!-- 학번 -->
							<th scope="col" class="tc"><spring:message code="exam.label.user.nm" /></th><!-- 이름 -->
							<th scope="col" class="tc"><spring:message code="exam.label.log" /></th><!-- 로그 -->
							<th scope="col" class="tc"><spring:message code="exam.label.reg.dttm" /></th><!-- 등록일시 -->
							<th scope="col" class="tc">IP</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="list" items="${recordList }">
							<fmt:parseDate var="regDateFmt" pattern="yyyyMMddHHmmss" value="${list.regDttm }" />
							<fmt:formatDate var="regDttm" pattern="yyyy.MM.dd HH:mm" value="${regDateFmt }" />
							<tr>
								<td>${list.lineNo }</td>
								<td>${list.deptNm }</td>
								<td>${list.userId }</td>
								<td>${list.userNm }</td>
								<td>
									<c:choose>
										<c:when test="${list.reExamYn eq 'Y' }">
											<c:choose>
												<c:when test="${list.hstyTypeCd eq 'COMPLETE' }">
													<spring:message code="exam.label.reexam" /> <spring:message code="exam.label.complete" /><!-- 재응시 --><!-- 완료 -->
												</c:when>
												<c:otherwise>
													${list.hstyTypeNm }
												</c:otherwise>
											</c:choose>
										</c:when>
										<c:otherwise>
											${list.hstyTypeNm }
										</c:otherwise>
									</c:choose>
								</td>
								<td>${regDttm }</td>
								<td>${list.connIp }</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<div id="ansrDiv" class="logDiv">
				<select class="ui dropdown" id="qstnNo" onchange="selectQstnNo(this)">
					<option value=""><spring:message code="exam.label.sel.qstn" /><!-- 문제 선택 --></option>
					<c:forEach var="item" items="${paperList }">
						<option value="${item.qstnNo }">${item.qstnNo }<spring:message code="exam.label.no" /><!-- 번 --></option>
					</c:forEach>
				</select>
				<table class="table mt20" id="logTable" data-sorting="true" data-paging="false" data-empty="<spring:message code='exam.common.empty' />"><!-- 등록된 내용이 없습니다. -->
					<thead>
						<tr>
							<th scope="col" class="num tc"><spring:message code="common.number.no" /><!-- NO. --></th>
							<th scope="col" class="tc"><spring:message code="exam.button.select" /></th><!-- 선택 -->
							<th scope="col" class="tc"><spring:message code="exam.label.log" /></th><!-- 로그 -->
							<th scope="col" class="tc"><spring:message code="exam.label.dttm" /></th><!-- 일시 -->
							<th scope="col" class="tc">IP</th>
						</tr>
					</thead>
					<tbody id="logTbody"></tbody>
				</table>
			</div>

            <div class="bottom-content">
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
