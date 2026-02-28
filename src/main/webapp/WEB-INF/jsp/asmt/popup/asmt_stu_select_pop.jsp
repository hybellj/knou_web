<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

    <link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>
    <script type="text/javascript">
        $(document).ready(function () {
            setTimeout(function () {
                listAsmntUser();
            }, 200);
        });

        // 과제 평가 참여자 리스트 조회
        function listAsmntUser() {
            // 과제 유형에 따라 URL 분기(개인, 팀)
            var url = "";
            if ("${aVo.teamAsmtStngyn}" == 'Y') {
                url = "/asmt/profAsmtTeamPtcpntSelect.do";
            } else {
                url = "/asmt/profAsmtSbmsnPtcpntSelect.do";
            }

            var data = {
                "selectType": "LIST",
                "crsCreCd": "${vo.crsCreCd}",
                "asmtId": "${vo.asmtId}",
                "searchValue": "${vo.searchValue}",
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    var returnList = data.returnList || [];
                    var html = '';

                    returnList.forEach(function (v, i) {
                        var sbmsnStscdnm = v.sbmsnStscdnm;
                        var fileRegDttm = v.fileRegDttm || "";
                        var lateDttm = v.lateDttm || "";

                        var regDt = fileRegDttm.length >= 12 ? fileRegDttm.substring(0, 4) + "." + fileRegDttm.substring(4, 6) + "." + fileRegDttm.substring(6, 8) + " " + fileRegDttm.substring(8, 10) + ":" + fileRegDttm.substring(10, 12) : fileRegDttm;

                        if (v.sbmsnStscd == "LATE") {
                            regDt = lateDttm.length >= 12 ? lateDttm.substring(0, 4) + "." + lateDttm.substring(4, 6) + "." + lateDttm.substring(6, 8) + " " + lateDttm.substring(8, 10) + ":" + lateDttm.substring(10, 12) : lateDttm;
                        }

                        if (v.sbmsnStscd == "NO") {
                            sbmsnStscdnm = '<span class="fcRed">' + v.sbmsnStscdnm + '</span>';
                        }

                        html += '<tr>';
                        html += '	<td class="" data-sort-value="' + (i + 1) + '">' + (i + 1) + '</td>';
                        html += '	<td class="" data-sort-value="">' + (v.deptNm || '') + '</td>';
                        html += '	<td class="" data-sort-value="' + v.userId + '">' + v.userId + '</td>';
                        html += '	<td class="" data-sort-value="' + v.userNm + '">' + v.userNm + '</td>';
                        html += '	<td class="" data-sort-value="' + (v.scr != null && v.scr != "" ? Number(v.scr) : '-1') + '">' + (v.scr != null && v.scr != "" ? Number(v.scr) : ' - ') + ' <spring:message code="asmnt.label.point" /></td>';
                        html += '	<td class="" data-sort-value="' + v.sbmsnStscdnm + '">' + sbmsnStscdnm + '</td>';
                        html += '	<td class="" data-sort-value="' + regDt + '">' + regDt + '</td>';
                        html += '	<td class=""><a class="ui button blue small" href="javascript:selectStudent(\'' + v.userId + '\', \'' + v.stdNo + '\')">선택</a></td>';
                        html += '</tr>';
                    });

                    $("#stuList").empty().html(html);
                    $("#stuTable").footable();
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                alert("<spring:message code='fail.common.msg' />"); // 에러가 발생했습니다!
            }, true);
        }

        function selectStudent(userId, stdNo) {
            if (typeof window.parent.asmntStuSelectPopCallback === "function") {
                window.parent.asmntStuSelectPopCallback({
                    userId: userId
                    , stdNo: stdNo
                });
            }
            window.parent.closeModal();
        }
    </script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>" style="max-height: 400px;">
<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>
<div id="wrap">
    <div class="ui form">
        <div class="footable_box type2 max-height-300">
            <table class="table type2" data-sorting="true" data-paging="false"
                   data-empty="<spring:message code='common.content.not_found' />" id="stuTable"><!-- 등록된 내용이 없습니다. -->
                <thead class="sticky top0">
                <tr>
                    <th scope="col" class="tc" data-type="number"><spring:message code="common.number.no"/></th>
                    <th scope="col" class="tc"><spring:message code="std.label.dept" /><!-- 학과 --></th>
                    <th scope="col" class="tc"><spring:message code="std.label.user_id" /><!-- 학번 --></th>
                    <th scope="col" class="tc"><spring:message code="std.label.name" /><!-- 이름 --></th>
                    <th scope="col" class="tc"><spring:message code="exam.label.eval.scr" /><!-- 평가점수 --></th>
                    <th scope="col" class="tc"><spring:message code="exam.label.submit.status" /><!-- 제출상태 --></th>
                    <th scope="col" class="tc"><spring:message code="forum.label.submit.dt" /><!-- 제출일시 --></th>
                    <th scope="col" class="tc" data-sortable="false"></th>
                </tr>
                </thead>
                <tbody id="stuList"></tbody>
            </table>
        </div>
    </div>
    <div class="bottom-content">
        <button class="ui black cancel button" onclick="window.parent.closeModal();">
            <spring:message code="common.button.close" /><!-- 닫기 --></button>
    </div>
</div>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>