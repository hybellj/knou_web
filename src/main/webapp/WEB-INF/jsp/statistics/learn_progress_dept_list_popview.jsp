<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="style" value="table"/>
    </jsp:include>

	<script type="text/javascript">
        $(function() {
			listLrnPrgrtBydept();

            $("#yrSmstr").on("change", function() {listLrnPrgrtBydept();});
		});
		
		// 학과별 전체통계 목록 조회
		function listLrnPrgrtBydept () {
			let url	 = "/stats/lrnPrgrtListByDeptAjax.do";
			let data = {
				orgId	: $("#orgId").val(),
				yrSmstr	: $("#yrSmstr").val(),
                smstrChrtGbncd : $("#yrSmstr option:selected").data("type") || "",
			};
			
			$.ajax({
				url : url,
				data: data,
				type: "GET",
				success: function(data) {
					if (data.result > 0) {
						let returnList = data.returnList || [];
						let html = "";

                        if (returnList.length > 0) {
                            returnList.forEach(function(v, i) {
                                html +=`
                                    <tr>
                                        <td>\${v.lineNo}</td>
                                        <td>\${v.dgrsYr}</td>
                                        <td>\${v.dgrsSmstr}</td>
                                        <td>\${v.orgnm}</td>
                                        <td>\${v.deptnm}</td>
                                        <td>\${v.totStdCnt}</td>
                                        <td>\${v.avgPrgrt}</td>
                                    </tr>
							    `;
                            });
                        } else {
                            html += `
                                <tr><td colspan="7"><spring:message code='common.nodata.msg'/></td></tr>
                            `;
                        }
						
						$("#deptTable").empty().html(html);
					}else {
						alert(data.message);
					}
				},
				error: function(xhr, status, error) {
					alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
				}
			});
		} 
	</script>
</head>

<body class="modal-page">
	<div id="wrap">
            <div class="board_top">
                <select class="form-select" id="orgId" disabled><!-- 기관 -->
                    <option value="">기관</option>
                    <c:forEach var="list" items="${filterOptions.orgList }">
                        <option value="${list.orgId }" ${list.orgId eq filterOptions.orgId ? 'selected' : '' }>${list.orgnm }</option>
                    </c:forEach>
                </select>
                <select class="form-select" id="yrSmstr">
                    <option value=""><spring:message code="msg.common.label.yearSmstr" /></option>
                    <c:forEach var="item" items="${filterOptions.yrSmstrList }" varStatus="i">
                        <option value="${item.dgrsYr}${item.dgrsSmstrChrt}" <%--${i.index eq 0 ? 'selected' : '' }--%> data-type="${item.smstrChrtGbncd}">${item.yrSmstrnm}</option>
                    </c:forEach>
                </select>
            </div>


            <div class="table-wrap">
                <table class="table-type2">
                    <colgroup>
                        <col style="width: 50px">
                        <col style="width: 50px">
                    </colgroup>
                    <thead>
                        <tr>
                            <th class="w30"><spring:message code="common.no" /></th><!-- 번호 -->
                            <th><spring:message code="common.year" /></th><!-- 년도 -->
                            <th><spring:message code="common.term" /></th><!-- 학기 -->
                            <th><spring:message code="common.label.org" /></th><!-- 기관 -->
                            <th><spring:message code="common.dept_name" /></th><!-- 학과 -->
                            <th><spring:message code="crs.learner.count" /></th><!-- 수강생 수 -->
                            <th><spring:message code="exam.label.avg" /> <spring:message code="dashboard.study_prog" /></th><!-- 평균학습진도율 -->
                        </tr>
                    </thead>
                    <tbody id="deptTable"></tbody>
                </table>
            </div>
            <%--<div id="content" class="content-wrap common">
                <div class="dashboard_sub">
                    <div class="sub-content">




                    </div>&lt;%&ndash;//sub-content&ndash;%&gt;
                </div>&lt;%&ndash;//dashboard_sub&ndash;%&gt;
            </div>&lt;%&ndash;//content&ndash;%&gt;--%>
	</div>
	
</body>
</html>