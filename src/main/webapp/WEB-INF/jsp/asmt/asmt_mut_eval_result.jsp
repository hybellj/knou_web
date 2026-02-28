<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    <%@ include file="/WEB-INF/jsp/asmt/common/asmt_common_inc.jsp" %>

    <link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>

    <script type="text/javascript">
        $(document).ready(function () {
            listAsmntUser();
        });

        // 과제 평가 참여자 리스트 조회
        function listAsmntUser() {
            // 과제 유형에 따라 URL 분기(개인, 팀)
            var url = "";
            if ("${vo.teamAsmtStngyn}" == 'Y') {
                url = "/asmt/profAsmtTeamPtcpntSelect.do";
            } else {
                url = "/asmt/profAsmtSbmsnPtcpntSelect.do";
            }

            var data = {
                "selectType": "LIST",
                "crsCreCd": "${vo.crsCreCd}",
                "asmtId": "${vo.asmtId}",
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    var html = "";
                    data.returnList.forEach(function (o, i) {
                        html += "<tr>";
                        html += "	<td class='tc'>" + o.lineNo + "</td>";
                        html += "	<td>" + o.deptNm + "</td>";
                        html += "	<td class='tc'>" + o.userId + "</td>";
                        html += "	<td class='tc'>" + o.userNm + " </td>";

                        if (o.sbmsnStscd == "NO") {
                            html += "<td class='tc'><span class='fcRed'>" + o.sbmsnStscdnm + "</span></td>";
                        } else {
                            html += "<td class='tc'>" + o.sbmsnStscdnm + "</td>";
                        }

                        html += "	<td class='tc'>"
                        html += "		<div class='ui tiny star rating gap4' data-rating='" + (o.evalScore * 1).toFixed(0) + "' data-max-rating='5'>";
                        html += "			<i class='icon'></i>";
                        html += "			<i class='icon'></i>";
                        html += "			<i class='icon'></i>";
                        html += "			<i class='icon'></i>";
                        html += "			<i class='icon'></i>";
                        html += "		</div>";
                        html += "   </td>";
                        html += "	<td class='tc'>" + o.evalCnt + " <spring:message code='lesson.label.user.cnt' /></td>";
                        html += "	<td class='tc'>";
                        html += "		<a href='javascript:asmntMutEvalPop(\"" + o.asmtSbmsnId + "\")' class='ui button small basic'><spring:message code='common.label.eval.opinion' /></a>"; // 평가의견
                        html += "	</td>";
                        html += "</tr>";

                    });
                    $("#asmntStareUserList").empty().append(html);

                    $(".table").footable();
                    $('.ui.rating').rating({interactive: false});
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                /* 에러가 발생했습니다! */
                alert("<spring:message code='fail.common.msg' />");
            }, true);
        }

        function manageAsmnt(tab) {
            var urlMap = {
                "1": "/asmtProfAsmtEvlView.do",	// 과제 평가 관리 페이지
                "2": "/asmtProfAsmtMutEvlRsltView.do",	// 상호평가 결과 페이지
            };

            var kvArr = [];
            kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
            kvArr.push({'key': 'asmtId', 'val': "${vo.asmtId}"});

            submitForm(urlMap[tab], "", kvArr);
        }

        function asmntMutEvalPop(asmtSbmsnId) {
            var modalId = "Ap19";
            initModal(modalId);

            var kvArr = [];
            kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
            kvArr.push({'key': 'asmtSbmsnId', 'val': asmtSbmsnId});

            submitForm("/asmtProfAsmtMutEvlPopSelectView.do", modalId + "ModalIfm", kvArr);
        }
    </script>
</head>
<body class="<%=SessionInfo.getThemeMode(request)%>">
<div id="wrap" class="pusher">
    <!-- class_top 인클루드  -->
    <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>

    <div id="container">
        <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>

        <div class="content stu_section">
            <%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>

            <div class="ui form">
                <div class="layout2">
                    <script>
                        $(document).ready(function () {
                            // set location
                            setLocationBar('<spring:message code='asmnt.label.asmnt'/>', '<spring:message code="common.label.info.manage" />'); // 과제정보 및 평가
                        });
                    </script>

                    <div id="info-item-box">
                        <h2 class="page-title flex-item flex-wrap gap4 columngap16">
                            <spring:message code="asmnt.label.asmnt"/><!-- 과제 -->
                        </h2>
                        <div class="button-area">
                        </div>
                    </div>

                    <div class="row">
                        <div class="col">
                            <div class="listTab">
                                <ul class="">
                                    <li class="mw120">
                                        <a onclick="manageAsmnt(1)"><spring:message
                                                code="common.label.info.manage"/></a><!-- 정보 및 평가 -->
                                    </li>
                                    <li class="select mw120">
                                        <a onclick="manageAsmnt(2)"><spring:message code="asmnt.label.mut.eval"/></a>
                                        <!-- 상호평가 -->
                                    </li>
                                </ul>
                            </div>

                            <div class="ui segment">
                                <%@ include file="/WEB-INF/jsp/asmt/common/asmt_info_inc.jsp" %>
                            </div>

                            <div class="ui segment">
                                <h4 class="ui top attached header">
                                    <spring:message code="common.evaluand.subject.list" /><!-- 평가 대상자 목록 --></h4>
                                <div class="ui bottom attached segment">
                                    <table class="table type2" data-sorting="true" data-paging="false"
                                           data-empty="<spring:message code='common.nodata.msg' />">
                                        <thead>
                                        <tr>
                                            <th scope="col" class='tc'><spring:message code="common.number.no"/></th>
                                            <!-- NO. -->
                                            <th scope="col" data-breakpoints="xs" class='tc'><spring:message
                                                    code="asmnt.label.dept.nm"/></th><!-- 학과 -->
                                            <th scope="col" class="tc"><spring:message code="asmnt.label.user_id"/></th>
                                            <!-- 학번 -->
                                            <th scope="col" class="tc"><spring:message code="asmnt.label.user_nm"/></th>
                                            <!-- 이름 -->
                                            <th scope="col" data-breakpoints="xs sm" class="tc"><spring:message
                                                    code="asmnt.label.status"/></th><!-- 상태 -->
                                            <th scope="col" data-breakpoints="xs sm md" class="tc">
                                                <spring:message code="asmnt.label.average.horoscope"/><!-- 평균별점 --></th>
                                            <th scope="col" data-breakpoints="xs sm md" class="tc">
                                                <spring:message code="common.rating.personnel"/><!-- 평가인원 --></th>
                                            <th scope="col" data-breakpoints="xs sm md" class="tc">
                                                <spring:message code="common.label.eval.opinion"/><!-- 평가의견 --></th>
                                        </tr>
                                        </thead>
                                        <tbody id="asmntStareUserList">
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- 피드백 작성  모달 -->
<script type="text/javascript">
    $('iframe').iFrameResize();
    window.closeModal = function () {
        $('.modal').modal('hide');
    };
</script>
</body>
</html>