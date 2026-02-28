<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    <link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>
</head>

<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        getAsmntJoinUser();
    });

    //과제 대상자 조회
    function getAsmntJoinUser() {
        var url = "/asmtProfAsmtTrgtrSelect.do";
        var data = {
            "selectType": "LIST",
            "crsCreCd": "${vo.crsCreCd}",
            "asmtId": "${vo.asmtId}",
            "searchKey": "NOSUBMIT"
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var html = "";
                data.returnList.forEach(function (o, i) {
                    html += "<tr>";
                    html += "    <td class='wf10'>";
                    html += "        <div class='ui checkbox'>";
                    html += "            <input type='hidden' value='" + o.stdNo + "'>";
                    html += "            <input type='checkbox' id='tg" + (i + 1) + "' tabindex='0' class='hidden'>";
                    html += "            <label class='toggle_btn' for='tg" + (i + 1) + "'></label>";
                    html += "        </div>";
                    html += "    </td>";
                    html += "    <td class='wf15'>" + (i + 1) + "</td>";
                    html += "    <td class='tgList'>" + o.deptNm + "</td>";
                    html += "    <td class='tgList'>" + o.userId + "</td>";
                    html += "    <td class='tgList'>" + o.userNm + "</td>";
                    html += "</tr>";

                });

                $("#indvAsmtList").empty().append(html);

                listAsmntUser();
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 에러가 발생했습니다! */
            alert("<spring:message code='fail.common.msg' />");
        }, true);
    }

    // 개별과제여부 수강생목록 검색
    function indiSearch(type) {
        if (type == 'T') {
            $('#tg0').prop("checked", false);
            $('#indvAsmtList input:checkbox').prop("checked", false);
            $('#indvAsmtList tr').show();
            if ($('#tgSearch').val() != '') {
                $('#indvAsmtList tr').not($("#indvAsmtList .tgList:contains('" + $('#tgSearch').val() + "')").parent()).hide();
            }
        } else if (type == 'S') {
            $('#stg0').prop("checked", false);
            $('#sindvAsmtList input:checkbox').prop("checked", false);
            $('#sindvAsmtList tr').show();
            if ($('#stgSearch').val() != '') {
                $('#sindvAsmtList tr').not($("#sindvAsmtList .tgList:contains('" + $('#stgSearch').val() + "')").parent()).hide();
            }
        }
    }

    function listAsmntUser() {
        var url = "/asmt/profAsmtSbmsnPtcpntSelect.do";

        var data = {
            "selectType": "LIST",
            "crsCreCd": "${vo.crsCreCd}",
            "asmtId": "${vo.asmtId}"
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var html = "";
                var idx = 0;
                data.returnList.forEach(function (o, i) {
                    if (o.resbmsnyn == 'Y') {
                        html += "<tr>";
                        html += "    <td class='wf10'>";
                        html += "        <div class='ui checkbox'>";
                        html += "            <input type='hidden' value='" + o.stdNo + "'>";
                        html += "            <input type='checkbox' id='tgr" + (idx + 1) + "' tabindex='0' class='hidden'>";
                        html += "            <label class='toggle_btn' for='tgr" + (idx + 1) + "'></label>";
                        html += "        </div>";
                        html += "    </td>";
                        html += "    <td class='wf15'>" + (idx + 1) + "</td>";
                        html += "    <td class='tgList'>" + o.deptNm + "</td>";
                        html += "    <td class='tgList'>" + o.userId + "</td>";
                        html += "    <td class='tgList'>" + o.userNm + "</td>";
                        html += "</tr>";

                        $("#indvAsmtList input[value='" + o.stdNo + "']").parent().parent().parent().remove();
                        idx++;
                    }
                });

                $('#indvAsmtList tr').each(function (i, o) {
                    $("#indvAsmtList tr:eq(" + i + ") td:eq(1)").text(i + 1);
                });

                $("#sindvAsmtList").empty().append(html);
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 에러가 발생했습니다! */
            alert("<spring:message code='fail.common.msg' />");
        }, true);
    }

    function saveResend() {

        var url = "/asmt/profAsmtResbModify.do";

        // 시작일 체크
        if (!$("#resendStartDttmText").val()) {
            var msg = '<spring:message code="common.date.start" /> <spring:message code="common.required.msg" />'; // 시작일 (은)는 필수입력항목입니다.
            alert(msg);
            $("#resendStartDttmText").focus();
            return;
        }

        // 시작일 시간 체크
        if ($("#calSendStartHH option:selected").val() == " ") {
            var msg = '<spring:message code="common.date.start" />'; // 시작일
            alert('<spring:message code="common.alert.input.eval_hour" arguments="' + msg + '" />'); // 시간을 입력하세요.
            $("#calSendStartHH").parent().focus();
            return;
        }

        // 시작일 분 체크
        if ($("#calSendStartMM option:selected").val() == " ") {
            var msg = '<spring:message code="common.date.start" />'; // 시작일
            alert('<spring:message code="common.alert.input.eval_min" arguments="' + msg + '" />'); // 분을 입력하세요.
            $("#calSendStartMM").parent().focus();
            return;
        }

        // 종료일 체크
        if (!$("#resendEndDttmText").val()) {
            var msg = '<spring:message code="common.date.end" /> <spring:message code="common.required.msg" />'; // 종료일 (은)는 필수입력항목입니다.
            alert(msg);
            $("#resendEndDttmText").focus();
            return;
        }

        // 종료일 시간 체크
        if ($("#calSendEndHH option:selected").val() == " ") {
            var msg = '<spring:message code="common.date.end" />'; // 종료일
            alert('<spring:message code="common.alert.input.eval_hour" arguments="' + msg + '" />'); // 시간을 입력하세요.
            $("#calSendEndHH").parent().focus();
            return;
        }

        // 종료일 분 체크
        if ($("#calSendEndMM option:selected").val() == " ") {
            var msg = '<spring:message code="common.date.end" />'; // 종료일
            alert('<spring:message code="common.alert.input.eval_min" arguments="' + msg + '" />'); // 분을 입력하세요.
            $("#calSendEndMM").parent().focus();
            return;
        }

        var resbmsnSdttm = replaceDateToDttm($("#resendStartDttmText").val().replaceAll('.', '-') + ' ' + $("#calSendStartHH").val() + ':' + $("#calSendStartMM").val());
        var resbmsnEdttm = replaceDateToDttm($("#resendEndDttmText").val().replaceAll('.', '-') + ' ' + $("#calSendEndHH").val() + ':' + $("#calSendEndMM").val());

        // 종합성적 산출기간 체크
        if (("${sysJobSchVO.schEndDt}" || "").length >= 12) {
            var endDttm = resbmsnEdttm.replaceAll("-", "");
            var scoreProcDttm = "${sysJobSchVO.schEndDt}";
            var scoreProcDttmFmt = scoreProcDttm.substring(0, 4) + "." + scoreProcDttm.substring(4, 6) + "." + scoreProcDttm.substring(6, 8) + " " + scoreProcDttm.substring(8, 10) + ":" + scoreProcDttm.substring(10, 12) + ":" + scoreProcDttm.substring(12, 14);

            if (endDttm.substring(0, 12) > scoreProcDttm.substring(0, 12)) {
                // 과제 제출기간은 종합성적 산출/입력 마감일 이전까지로 설정 가능합니다.
                alert("<spring:message code='asmnt.alert.invalid.send.end.dttm' />" + "\n" + scoreProcDttmFmt);
                return;
            }
        }

        $("input[name=resbmsnSdttm]").val(resbmsnSdttm);
        $("input[name=resbmsnEdttm]").val(resbmsnEdttm);

        var indvAsmtList = "";
        $('#sindvAsmtList tr').each(function (i, o) {
            if (i > 0) indvAsmtList += ',';
            indvAsmtList += $("#sindvAsmtList tr:eq(" + i + ") input:eq(0)").val();
        });
        $("input[name='indvAsmtList']").val(indvAsmtList);

        $.ajaxSettings.traditional = true;
        ajaxCall(url, $("#resendForm").serialize(), function (data) {
            if (data.result > 0) {
                /* 저장하였습니다. */
                alert("<spring:message code='common.alert.ok.save' />");
                window.parent.closeModal();
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 저장 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
            alert("<spring:message code='seminar.error.insert' />");
        }, true);
    }


    function checkAll1() {
        if ($("#tg0").is(":checked") == false) {
            $("#indvAsmtList").find("input:checkbox").prop('checked', true);
        } else {
            $("#indvAsmtList").find("input:checkbox").prop('checked', false);
        }
    }

    function checkAll2() {
        if ($("#stg0").is(":checked") == false) {
            $("#sindvAsmtList").find("input:checkbox").prop('checked', true);
        } else {
            $("#sindvAsmtList").find("input:checkbox").prop('checked', false);
        }
    }

    function replaceDateToDttm(date) {
        var dt = new Date(date);
        var tmpYear = dt.getFullYear().toString();
        var tmpMonth = this.pad(dt.getMonth() + 1, 2);
        var tmpDay = this.pad(dt.getDate(), 2);
        var tmpHourr = this.pad(dt.getHours(), 2);
        var tmpMin = this.pad(dt.getMinutes(), 2);
        var tmpSec = this.pad(dt.getSeconds(), 2);
        var nowDay = tmpYear + tmpMonth + tmpDay + tmpHourr + tmpMin + tmpSec;
        return nowDay;
    }
</script>

<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
<div id="wrap">
    <div class="">
        <div class="ui attached message">
            <div class="flex">
                <div class="mra">${vo.asmtTtl }</div>
            </div>
        </div>

        <form:form id="resendForm" name="resendForm" method="post" action="" modelAttribute="asmtVO">
            <input type="hidden" name="indvAsmtList">
            <input type="hidden" name="asmtId" value="${vo.asmtId}">
            <input type="hidden" name="resbmsnSdttm" value="">
            <input type="hidden" name="resbmsnEdttm" value="">

            <div class="ui bottom attached segment">
                <ul class="tbl">
                    <li>
                        <dl>
                            <dt><label for="dateLabel" class="req"><spring:message
                                    code="asmnt.label.resend.date"/></label></dt> <!-- 재제출기간 -->
                            <dd>
                                <div class="fields gap4">
                                    <div class="field flex">
                                        <!-- 시작일시 -->
                                        <uiex:ui-calendar dateId="resendStartDttmText" hourId="calSendStartHH"
                                                          minId="calSendStartMM" rangeType="start"
                                                          rangeTarget="resbmsnEdttm" value="${vo.resbmsnSdttm}"/>
                                    </div>
                                    <div class="field p0 flex-item desktop-elem">~</div>
                                    <div class="field flex">
                                        <!-- 종료일시 -->
                                        <uiex:ui-calendar dateId="resendEndDttmText" hourId="calSendEndHH"
                                                          minId="calSendEndMM" rangeType="end"
                                                          rangeTarget="resbmsnSdttm" value="${vo.resbmsnEdttm}"/>
                                    </div>
                                </div>
                            </dd>
                        </dl>
                    </li>
                    <c:choose>
                        <c:when test="${serverMode eq 'production'}">
                            <input type="hidden" name="resbmsnMrkRfltrt" class="w50" value="100"/>
                        </c:when>
                        <c:otherwise>
                            <li>
                                <dl>
                                    <dt>
                                        <label for="rescoreLabel" class="req"><spring:message
                                                code="exam.label.scr.aply.rate"/></label><!-- 반영비율 -->
                                    </dt>
                                    <dd>
                                        <div class="ui input"><input type="text" name="resbmsnMrkRfltrt" class="w50"
                                                                     value="${not empty vo.resbmsnMrkRfltrt ? vo.resbmsnMrkRfltrt : '100'}">%
                                        </div>
                                    </dd>
                                </dl>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
                <div class="ui divider"></div>
                <ul class="tbl">
                    <li>
                        <dl>
                            <dt>
                                <label for="prtcLabel"><spring:message code="asmnt.label.resend.user.setting"/></label>
                                <!-- 재제출자 설정 -->
                            </dt>
                        </dl>
                    </li>
                </ul>
                <div class="swapLists mt10">
                    <div class="swapListsItem">
                        <div class="option-content mb10">
                            <label for="b1" class="mra"><spring:message code="asmnt.label.nosend.user.list"/></label>
                            <!-- 미제출자 목록 -->
                            <div class="ui action input search-box">
                                <input type="text" id="tgSearch"
                                       placeholder="<spring:message code='team.popup.search.placeholder'/>">
                                <!-- 학과, 학번, 이름 입력 -->
                                <button type="button" class="ui icon button" onclick="indiSearch('T')"><i
                                        class="search icon"></i></button>
                            </div>
                        </div>

                        <table class="tbl_fix type2">
                            <thead>
                            <tr>
                                <th class="wf10">
                                    <div class="ui checkbox" onclick="checkAll1()">
                                        <input type="checkbox" id="tg0" tabindex="0" class="hidden">
                                        <label class="toggle_btn" for="tg0"></label>
                                    </div>
                                </th>
                                <th class="wf15"><spring:message code="common.number.no"/></th><!-- NO. -->
                                <th><spring:message code="asmnt.label.dept.nm"/></th><!-- 학과 -->
                                <th><spring:message code="asmnt.label.user_id"/></th><!-- 학번 -->
                                <th><spring:message code="asmnt.label.user_nm"/></th><!-- 이름 -->
                            </tr>
                            </thead>
                            <tbody id="indvAsmtList"></tbody>
                        </table>
                    </div>

                    <div class="button-area">
                        <button type='button' class="ui basic icon button"
                                data-medi-ui="swap"
                                data-swap-to="right"
                                data-swap-target="tr"
                                data-swap-arrival="tbody" title="<spring:message code='team.popup.button.right'/>">
                            <!-- 오른쪽으로 이동 -->
                            <i class="arrow right icon"></i>
                        </button>

                        <button type='button' class="ui basic icon button"
                                data-medi-ui="swap"
                                data-swap-to="left"
                                data-swap-target="tr"
                                data-swap-arrival="tbody" title="<spring:message code='team.popup.button.left'/>">
                            <!-- 왼쪽으로 이동 -->
                            <i class="arrow left icon"></i>
                        </button>
                    </div>
                    <div class="swapListsItem">
                        <div class="option-content mb10">
                            <label for="b1" class="mra"><spring:message code="asmnt.label.resend.user"/></label>
                            <!-- 재제출자 -->
                            <div class="ui action input search-box">
                                <input type="text" id="stgSearch"
                                       placeholder="<spring:message code='team.popup.search.placeholder'/>">
                                <!-- 학과, 학번, 이름 입력 -->
                                <button type="button" class="ui icon button" onclick="indiSearch('S')"><i
                                        class="search icon"></i></button>
                            </div>
                        </div>
                        <table class="tbl_fix type2">
                            <thead>
                            <tr>
                                <th class="wf10">
                                    <div class="ui checkbox" onclick="checkAll2()">
                                        <input type="checkbox" id="stg0" tabindex="0" class="hidden">
                                        <label class="toggle_btn" for="stg0"></label>
                                    </div>
                                </th>
                                <th class="wf15"><spring:message code="common.number.no"/></th><!-- NO. -->
                                <th><spring:message code="asmnt.label.dept.nm"/></th><!-- 학과 -->
                                <th><spring:message code="asmnt.label.user_id"/></th><!-- 학번 -->
                                <th><spring:message code="asmnt.label.user_nm"/></th><!-- 이름 -->
                            </tr>
                            </thead>
                            <tbody id="sindvAsmtList"></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </form:form>
    </div>
    <div class="bottom-content mt70">
        <button class="ui blue button" onclick="saveResend()"><spring:message code="asmnt.button.save"/></button>
        <!-- 저장 -->
        <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message
                code="asmnt.button.close"/></button><!-- 닫기 -->
    </div>
</div>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>