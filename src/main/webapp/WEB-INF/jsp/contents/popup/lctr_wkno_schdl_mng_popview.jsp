<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin, classroom"/>
    </jsp:include>
    <script type="text/javascript">
        var ORG_ID = '<c:out value="${lctrWknoSchdlVO.orgId}" />';
        var SBJCT_ID = '<c:out value="${lctrWknoSchdlVO.sbjctId}" />';
        var LCTR_WKNO_SCHDL_ID = '<c:out value="${lctrWknoSchdlVO.lctrWknoSchdlId}" />';

        $(document).ready(function() {
            if("${empty message ? '' : message}" != "") {
                UiComm.showMessage("${message}", "warning").then(function() {
                    closeLctrWknoSchdlPop();
                });
                return;
            }
            setYmdValue("#lctrWknoSymd", "<c:out value='${lctrWknoSchdlVO.lctrWknoSymd}' />");
            setYmdValue("#lctrWknoEymd", "<c:out value='${lctrWknoSchdlVO.lctrWknoEymd}' />");
            setYmdValue("#wknoAtndcRcgSymd", "<c:out value='${lctrWknoSchdlVO.wknoAtndcRcgSymd}' />");
            setYmdValue("#wknoAtndcRcgEymd", "<c:out value='${lctrWknoSchdlVO.wknoAtndcRcgEymd}' />");
        });

        // yyyyMMdd 값을 yyyy.MM.dd 형식으로 입력칸에 표시한다.
        function setYmdValue(selector, value) {
            var ymd = normalizeYmd(value);
            if(ymd.length == 8) {
                $(selector).val(ymd.substring(0, 4) + "." + ymd.substring(4, 6) + "." + ymd.substring(6, 8));
            }
        }

        // 날짜 입력값에서 숫자만 남긴다.
        function normalizeYmd(value) {
            return String(value || "").replace(/[^0-9]/g, "");
        }

        // 입력값 검증 후 강의주차일정을 저장한다.
        function saveLctrWknoSchdl() {
            var lctrWknonm = $.trim($("#lctrWknonm").val());
            var lctrWknoSymd = normalizeYmd($("#lctrWknoSymd").val());
            var lctrWknoEymd = normalizeYmd($("#lctrWknoEymd").val());
            var wknoAtndcRcgSymd = normalizeYmd($("#wknoAtndcRcgSymd").val());
            var wknoAtndcRcgEymd = normalizeYmd($("#wknoAtndcRcgEymd").val());

            if(!lctrWknonm) {
                UiComm.showMessage('<spring:message code="contents.msg.input.week.name"/>', "warning"); /* 주차명을 입력해 주세요. */
                return false;
            }
            if(!isYmd(lctrWknoSymd) || !isYmd(lctrWknoEymd)) {
                UiComm.showMessage('<spring:message code="contents.msg.input.week.period"/>', "warning"); /* 주차 기간을 입력해 주세요. */
                return false;
            }
            if(lctrWknoSymd > lctrWknoEymd) {
                UiComm.showMessage('<spring:message code="contents.msg.invalid.week.period"/>', "warning"); /* 주차 시작일은 종료일보다 클 수 없습니다. */
                return false;
            }
            if(!isYmd(wknoAtndcRcgSymd) || !isYmd(wknoAtndcRcgEymd)) {
                UiComm.showMessage('<spring:message code="contents.msg.input.week.attendance.period"/>', "warning"); /* 출석인정기간을 입력해 주세요. */
                return false;
            }
            if(wknoAtndcRcgSymd > wknoAtndcRcgEymd) {
                UiComm.showMessage('<spring:message code="contents.msg.invalid.week.attendance.period"/>', "warning"); /* 출석인정 시작일은 종료일보다 클 수 없습니다. */
                return false;
            }

            $("#saveBtn").prop("disabled", true);
            ajaxCall("/contents/admConts/admLctrWknoSchdlModify.do", {
                orgId: ORG_ID,
                sbjctId: SBJCT_ID,
                lctrWknoSchdlId: LCTR_WKNO_SCHDL_ID,
                lctrWknonm: lctrWknonm,
                lctrWknoSymd: lctrWknoSymd,
                lctrWknoEymd: lctrWknoEymd,
                wknoAtndcRcgSymd: wknoAtndcRcgSymd,
                wknoAtndcRcgEymd: wknoAtndcRcgEymd
            }, function(res) {
                $("#saveBtn").prop("disabled", false);
                if(res.result > 0) {
                    showParentMessage(res.message || '<spring:message code="success.common.update"/>', "success", function() { /* 정상적으로 수정되었습니다. */
                        if(window.parent && window.parent !== window && typeof window.parent.afterLctrWknoSchdlSave === "function") {
                            window.parent.afterLctrWknoSchdlSave();
                        } else {
                            closeLctrWknoSchdlPop();
                        }
                    });
                } else {
                    UiComm.showMessage(res.message || '<spring:message code="fail.common.update"/>', "error"); /* 수정이 실패하였습니다. */
                }
            }, function() {
                $("#saveBtn").prop("disabled", false);
                UiComm.showMessage('<spring:message code="fail.common.update"/>', "error"); /* 수정이 실패하였습니다. */
            });
            return false;
        }

        // yyyyMMdd 형식인지 확인한다.
        function isYmd(value) {
            return /^[0-9]{8}$/.test(value);
        }

        // 부모 화면을 우선으로 메시지를 표시한다.
        function showParentMessage(message, type, callback) {
            var comm = window.parent && window.parent.UiComm ? window.parent.UiComm : UiComm;
            var result = comm.showMessage(message, type);
            if(result && typeof result.then === "function") {
                result.then(callback);
            } else if($.isFunction(callback)) {
                callback();
            }
        }

        // 부모 UiDialog가 있으면 닫고, 단독 창이면 window.close를 시도한다.
        function closeLctrWknoSchdlPop() {
            if(window.parent && window.parent !== window && typeof window.parent.closeDialog === "function") {
                window.parent.closeDialog();
                return;
            }
            window.close();
        }
    </script>
</head>
<body class="modal-page">
    <div class="wrap">
        <c:if test="${empty message}">
            <spring:message code="contents.placeholder.start.date" var="startDatePlaceholder"/><%-- 시작일 --%>
            <spring:message code="contents.placeholder.end.date" var="endDatePlaceholder"/><%-- 종료일 --%>
            <div class="table-wrap">
                <table class="table-type5">
                    <colgroup>
                        <col style="width: 18%;">
                        <col>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="req"><spring:message code="contents.label.week.name"/><%-- 주차명 --%></th>
                            <td>
                                <div class="form-row">
                                    <input class="form-control width-80per" type="text" id="lctrWknonm" name="lctrWknonm" value="<c:out value='${lctrWknoSchdlVO.lctrWknonm}' />" maxlength="200" required="true">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="req"><spring:message code="contents.label.week.period"/><%-- 주차 기간 --%></th>
                            <td>
                                <div class="date_area">
                                    <input type="text" id="lctrWknoSymd" class="datepicker" toDate="lctrWknoEymd" placeholder="${startDatePlaceholder}" required="true">
                                    <span class="txt-sort">~</span>
                                    <input type="text" id="lctrWknoEymd" class="datepicker" fromDate="lctrWknoSymd" placeholder="${endDatePlaceholder}" required="true">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="req"><spring:message code="contents.label.week.attendance.period"/><%-- 출석인정기간 --%></th>
                            <td>
                                <div class="date_area">
                                    <input type="text" id="wknoAtndcRcgSymd" class="datepicker" toDate="wknoAtndcRcgEymd" placeholder="${startDatePlaceholder}" required="true">
                                    <span class="txt-sort">~</span>
                                    <input type="text" id="wknoAtndcRcgEymd" class="datepicker" fromDate="wknoAtndcRcgSymd" placeholder="${endDatePlaceholder}" required="true">
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="btns">
                <button type="button" id="saveBtn" class="btn type1" onclick="saveLctrWknoSchdl();"><spring:message code="common.button.save"/><%-- 저장 --%></button>
                <button type="button" class="btn type2" onclick="closeLctrWknoSchdlPop();"><spring:message code="common.button.close"/><%-- 닫기 --%></button>
            </div>
        </c:if>
    </div>
</body>
</html>
