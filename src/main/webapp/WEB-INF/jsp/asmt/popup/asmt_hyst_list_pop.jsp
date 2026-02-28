<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    <%@ include file="/WEB-INF/jsp/asmt/common/asmt_common_inc.jsp" %>
    <link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>

    <script type="text/javascript">
        $(document).ready(function () {
            getSubmitHyst();
        });

        function getSubmitHyst() {
            var url = "/asmt/profAsmtSbmsnHstrySelect.do";
            var data = {
                "asmtId": "${vo.asmtId}",
                "stdNo": "${vo.stdNo}"
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    var returnList = data.returnList || [];
                    var html = "";

                    html += "<table class='table type2' data-sorting='true' data-paging='false' data-empty='<spring:message code="asmnt.message.empty"/>'>";
                    html += "	<thead>";
                    html += "   	<tr>";
                    html += "       	<th scope='col'><spring:message code='asmnt.label.asmnt.history'/></th>";/* 과제이력 */
                    html += "		</tr>";
                    html += "	</thead>";
                    html += "	<tbody>";
                    returnList.forEach(function (v, i) {
                        var regDttmFmt = (v.regDttm || "").length == 14 ? v.regDttm.substring(0, 4) + '.' + v.regDttm.substring(4, 6) + '.' + v.regDttm.substring(6, 8) + " " + v.regDttm.substring(8, 10) + ":" + v.regDttm.substring(10, 12) + ":" + v.regDttm.substring(12, 14) : v.regDttm;
                        var hstyText = "-";

                        if (v.sbmtFileInfo) {
                            hstyText = v.sbmtFileInfo;
                        } else {
                            hstyText = "<spring:message code='asmnt.label.submit.dt' /> : " + regDttmFmt; // 제출일시
                        }

                        if (v.sbmsnStscd != 'NO') {
                            html += "<tr>";
                            html += "	<td>" + hstyText + "</td>";
                            html += "</tr>";
                        }
                    });
                    html += "	</tbody>";
                    html += "</table>";

                    $("#prevAsmntFiles").empty().append(html);
                    $(".table").footable();
                } else {
                    alert("<spring:message code='fail.common.msg' />"); // 에러가 발생했습니다!
                }
            }, function (xhr, status, error) {
                alert("<spring:message code='fail.common.msg' />"); // 에러가 발생했습니다!
            }, true);
        }
    </script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>
<div id="wrap">
    <div class="option-content">
        <h2 class="page-title">${cVo.crsCreNm } (${cVo.declsNo }<spring:message code="asmnt.label.decls.name"/>)</h2>
        <!-- 반 -->
        <div class="mla fcBlue">
            <ul class="list_verticalline  ">
                <li>${gVo.deptNm }</li>
                <li>${gVo.userNm }( ${gVo.userId } )</li>
                <c:if test="${gVo.scr ne '' && gVo.scr ne NULL}">
                    <li>
                        ${gVo.scr}<spring:message code="asmnt.label.point" /><!-- 점 -->
                    </li>
                </c:if>
            </ul>
        </div>
    </div>

    <div class="ui segment">
        <div id="prevAsmntFiles"></div>
    </div>

    <div class="bottom-content mt70">
        <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message
                code="asmnt.button.close"/></button><!-- 닫기 -->
    </div>
</div>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>