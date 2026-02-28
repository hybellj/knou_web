<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/asmt/common/asmt_common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/asmt/common/asmt_chart_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>
<script type="text/javascript">
    $(document).ready(function () {
        listAsmntUser(1);

        $("#searchValue").on("keyup", function (e) {
            if (e.keyCode == 13) {
                listAsmntUser(1);
            }
        });

        $('.toggle-icon').click(function () {
            $(this).toggleClass("ion-plus ion-minus");
        });

        //makePieChart("과제 참여현황 (%)", ["제출", "미제출"], ["${vo.submitCnt}", "${vo.noCnt}"]);

        $(".accordion").accordion();
    });

    function manageAsmnt(tab) {
        var urlMap = {
            "0": "/asmt/stu/asmtInfoManage.do",	// 과제 상세 정보 페이지
            "1": "/asmt/stu/asmtScoreManage.do"	// 과제 평가 관리 페이지
        };

        var kvArr = [];
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'asmtId', 'val': "${vo.asmtId}"});

        submitForm(urlMap[tab], "", kvArr);
    }

    // 평가 점수 체크박스
    function evalChk(obj) {
        if (obj.checked) {
            if (obj.value == "all") {
                $("input:checkbox[name=evalChk]").prop("checked", true);
            }
        } else {
            if (obj.value == "all") {
                $("input:checkbox[name=evalChk]").prop("checked", false);
            }
            $("input:checkbox[name=allEvalChk]").prop("checked", false);
        }
        var allLength = $("input:checkbox[name=evalChk]").length;
        var chkLength = $("input:checkbox[name=evalChk]:checked").length;
        if (allLength == chkLength) {
            $("input:checkbox[name=allEvalChk]").prop("checked", true);
        }
    }

    // 과제 평가 참여자 리스트 조회
    function listAsmntUser(page) {
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

        if ("${vo.teamAsmtStngyn}" == 'Y' && "${vo.teamEvalYn}" == 'Y') {
            data.searchKey2 = "${jVo.teamId}";
        }

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var html = "";
                data.returnList.forEach(function (o, i) {
                    html += "<tr>";
                    //html += "	<td class='tc'>";
                    //html += "		<div class='ui checkbox'>";
                    //html += "			<input type='checkbox' name='evalChk' id='evalChk'" + i + "' value='" + o.stdNo + "'>";
                    //html += "			<label class='toggle_btn' for='evalChk" + i + "'></label>";
                    //html += "		</div>";
                    //html += "	</td>";
                    html += "	<td class='tc'>" + o.lineNo + "</td>";
                    html += "	<td>" + o.deptNm + "</td>";
                    html += "	<td class='tc'>" + maskingNo(o.userId) + "</td>";
                    html += "	<td class='tc'>" + maskingName(o.userNm) + " </td>";


                    if (o.sbmsnStscd == "NO") {
                        html += "<td class='tc'><span class='fcRed'>" + o.sbmsnStscdnm + "</span></td>";
                    } else {
                        html += "<td class='tc'>" + o.sbmsnStscdnm + "</td>";
                    }
                    if ("${vo.evalRsltOpenYn}" == "Y") {
                        html += "<td class='tc'>"
                        html += "	<div class='ui tiny star rating gap4' data-rating='" + (o.evalScore * 1).toFixed(0) + "' data-max-rating='5'>";
                        html += "		<i class='icon'></i>";
                        html += "		<i class='icon'></i>";
                        html += "		<i class='icon'></i>";
                        html += "		<i class='icon'></i>";
                        html += "		<i class='icon'></i>";
                        html += "	</div>";
                        html += "</td>";
                    }
                    html += "	<td class='tc'>" + o.evalCnt + " <spring:message code='lesson.label.user.cnt' /></td>";
                    html += "	<td class='tc'>";
                    if (o.sbmsnStscd == 'NO') {
                        if (o.userId != "${userId}") {
                            html += "	<a href=\"javascript:alert('<spring:message code="asmnt.alert.input.no.submit.file"/>')\" class='ui basic small button " + (PROFESSOR_VIRTUAL_LOGIN_YN == "Y" ? 'disabled' : '') + "'><spring:message code="exam.button.eval" /></a>";
                        }
                    } else {
                        if (o.userId == "${userId}") {
                            if ("${vo.evalRsltOpenYn}" == "Y") {
                                html += "<a href=\"javascript:asmntMutEvalPop('" + o.asmtSbmsnId + "')\" class='ui primary small button'><spring:message code="common.label.eval.opinion" /></a>"; // 평가의견
                            }
                        } else {
                            html += "	<a href=\"javascript:evalViewPop('" + o.asmtSbmsnId + "','" + o.stdNo + "')\" class='ui basic small button " + (PROFESSOR_VIRTUAL_LOGIN_YN == "Y" ? 'disabled' : '') + "'><spring:message code="exam.button.eval" /></a>";
                        }
                    }
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

    // 상호평가
    function evalViewPop(asmtSbmsnId, stdNo) {
        getJoinIndi().done(function (returnVO) {
            var sbmsnStscd = returnVO && returnVO.sbmsnStscd || "NO";
            ''

            if (sbmsnStscd == "NO") {
                alert("<spring:message code='asmnt.alert.no.submit.eval' />"); // 과제 제출 후 평가가능 합니다.
                return;
            }

            var modalId = "Ap04";
            initModal(modalId, {modalClass: "modal-lg2"});

            var kvArr = [];
            kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
            kvArr.push({'key': 'asmtId', 'val': "${vo.asmtId}"});
            kvArr.push({'key': 'asmtSbmsnId', 'val': asmtSbmsnId});
            kvArr.push({'key': 'stdNo', 'val': stdNo});

            submitForm("/asmt/stu/evalViewPop.do", modalId + "ModalIfm", kvArr);
        });
    }

    function evalViewPopCallBack() {
        listAsmntUser(1);
    }

    // 상호평가 결과
    function asmntMutEvalPop(asmtSbmsnId) {
        var modalId = "Ap19";
        initModal(modalId);

        var kvArr = [];
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'asmtSbmsnId', 'val': asmtSbmsnId});

        submitForm("/asmtstdntAsmtMutEvlPopSelectView.do", modalId + "ModalIfm", kvArr);
    }

    // 목록
    function viewAsmntList() {
        var url = "/asmt/stu/listView.do";
        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "listForm");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: "${vo.crsCreCd}"}));
        form.appendTo("body");
        form.submit();
    }

    function getJoinIndi() {
        var deferred = $.Deferred();

        var url = "/asmt/stu/getJoinIndi.do";
        var data = {
            "selectType": "OBJECT",
            "crsCreCd": "${vo.crsCreCd}",
            "asmtId": "${vo.asmtId}",
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnVO = data.returnVO;

                deferred.resolve(returnVO);
            } else {
                alert(data.message);
                deferred.reject();
            }
        }, function (xhr, status, error) {
            alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
            deferred.reject();
        });

        return deferred.promise();
    }

    // 팀 구성원 보기
    function teamMemberView(lrnGrpId) {
        var modalId = "Ap06";
        initModal(modalId);

        var kvArr = [];
        kvArr.push({'key': 'lrnGrpId', 'val': lrnGrpId});

        submitForm("/forum/forumLect/teamMemberList.do", modalId + "ModalIfm", kvArr);
    }
</script>

<style>
    .starR {
        background: url('http://miuu227.godohosting.com/images/icon/ico_review.png') no-repeat right 0;
        background-size: auto 100%;
        width: 30px;
        height: 30px;
        display: inline-block;
        text-indent: -9999px;
        cursor: pointer;
    }

    .starR.on {
        background-position: 0 0;
    }
</style>

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
                            setLocationBar('<spring:message code="asmnt.label.asmnt"/>', '<spring:message code="forum.label.mut.eval" />');
                        });
                    </script>

                    <div id="info-item-box">
                        <h2 class="page-title flex-item flex-wrap gap4 columngap16">
                            <spring:message code="asmnt.label.asmnt"/><!-- 과제 -->
                        </h2>
                        <div class="button-area">
                            <a href="javascript:viewAsmntList()" class="ui basic button" id="btnList"><spring:message
                                    code="resh.button.list"/></a><!-- 목록 -->
                        </div>
                    </div>

                    <div class="row">
                        <div class="col">

                            <div class="listTab">
                                <ul class="">
                                    <li class="mw120">
                                        <a onclick="manageAsmnt(0)">
                                            <spring:message code="asmnt.label.asmnt.info"/><!-- 과제정보 -->
                                        </a>
                                    </li>

                                    <li class="select mw120">
                                        <a onclick="manageAsmnt(1)"><spring:message code="asmnt.label.mut.eval"/></a>
                                    </li>
                                </ul>
                            </div>
                            <div class="ui segment">
                                <%@ include file="/WEB-INF/jsp/asmt/common/stu_asmnt_info_inc.jsp" %>
                            </div>

                        </div>
                    </div>

                    <!--
						<div class="row">
                            <div class="col">

								<div class="ui segment" style="height:100%;">
									<div class="ui segment">
										<label><spring:message code="std.label.asmnt_peroid" /></label>제출 기간
										<p class="ml15">${asmtSbmsnSdttm } ~ ${sendEndDttm }</p>
									</div>
									<div class="ui segment">
										<label><spring:message code="asmnt.label.eval.target" /></label>평가대상
										<p class="ml15">${vo.targetCnt }<spring:message code="bbs.label.people_cnt" /></p>명
									</div>
								</div>

                            </div>
                            <div class="col">
								<div class="ui segment">
									<p><spring:message code="asmnt.label.asmnt.status" /></p>과제 현황
									<div class="ui stackable grid mt0 mb0 p_w100">
										<div class="sixteen wide column pt0">
											<div class="chart-container">
						                        <canvas id="pieChart" ></canvas>
						                    </div>
					                    </div>
					                </div>
								</div>
                            </div>
                        </div>
                        -->

                    <div class="row">
                        <div class="col">
                            <div class="flex mb10">
                                <h3><spring:message code="common.evaluand.subject.list"/></h3><!-- 평가대상자 목록 -->
                            </div>

                            <table class="table type2" data-sorting="true" data-paging="false"
                                   data-empty="<spring:message code='common.nodata.msg' />">
                                <thead>
                                <tr>
                                    <!-- <th scope="col" class="tc">
                                        <div class="ui checkbox">
                                            <input type="checkbox" name="allEvalChk" id="allChk" value="all" onchange="evalChk(this)">
                                            <label class="toggle_btn" for="allChk"></label>
                                        </div>
                                    </th> -->
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
                                    <c:if test="${vo.evalRsltOpenYn eq 'Y'}">
                                        <th scope="col" data-breakpoints="xs sm md" class="tc"></th>
                                        <spring:message code="asmnt.label.average.horoscope"/><!-- 평균별점 -->
                                    </c:if>
                                    <th scope="col" data-breakpoints="xs sm md" class="tc"></th>
                                    <spring:message code="common.rating.personnel"/><!-- 평가인원 -->
                                    <th scope="col" class="tc"></th>
                                    <spring:message code="common.label.eval"/><!-- 평가 -->
                                </tr>
                                </thead>
                                <tbody id="asmntStareUserList">
                                </tbody>
                            </table>

                        </div><!-- //col -->
                    </div><!-- //row -->

                </div>
            </div>

        </div><!-- //content -->
        <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
    </div><!-- //container -->
</div><!-- //pusher -->
</body>
</html>