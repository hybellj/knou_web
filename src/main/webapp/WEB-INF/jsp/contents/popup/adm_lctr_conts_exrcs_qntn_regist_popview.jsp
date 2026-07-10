<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin,classroom"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
    <script type="text/javascript">
        var ORG_ID = '<c:out value="${lctrContsVO.orgId}" />';
        var SBJCT_ID = '<c:out value="${lctrContsVO.sbjctId}" />';
        var LCTR_WKNO_SCHDL_ID = '<c:out value="${lctrContsVO.lctrWknoSchdlId}" />';
        var LCTR_ID = '<c:out value="${lctrContsVO.lctrId}" />';
        var LCTR_CONTS_ID = '<c:out value="${lctrContsVO.lctrContsId}" />';
        var LCTR_WKNO = '<c:out value="${lctrContsVO.lctrWkno}" />';
        var MODE = '<c:out value="${mode}" />';
        var exrcsDialog = null;

        $(document).ready(function() {
            initNumberInput($("#contsSeqno"));
            $("#allDeclas").on("change", function() {
                dvclasChcChange(this);
            });
            $("input[name='sbjctIds']").on("change", function() {
                dvclasChcChange(this);
            });
        });

        function isEditMode() {
            return MODE == "E";
        }

        // 정렬순서는 숫자만 입력되도록 제한한다.
        function initNumberInput($input) {
            $input.on("keyup change blur", function() {
                var value = String(this.value || "").replace(/[^0-9]/g, "");
                var maxValue = Number($(this).attr("maxVal") || 0);
                if(value !== "" && maxValue > 0 && Number(value) > maxValue) {
                    value = String(maxValue);
                }
                this.value = value;
            });
        }

        // 분반 전체 선택과 현재 분반 고정 선택을 함께 처리한다.
        function dvclasChcChange(obj) {
            if(obj && obj.id == "allDeclas") {
                $("input[name='sbjctIds']").not(".readonly").not(":disabled").prop("checked", obj.checked);
            }
            $("input[name='sbjctIds'].readonly").prop("checked", true);
            var enabledCount = $("input[name='sbjctIds']:enabled").length;
            $("#allDeclas").prop("checked", enabledCount > 0 && enabledCount == $("input[name='sbjctIds']:enabled:checked").length);
        }

        // 연습문제 선택 팝업을 연다.
        function openExrcsQstnListPop() {
            exrcsDialog = UiDialog("exrcsQstnDialog", {
                title: "<spring:message code='contents.label.quiz'/>", /* 연습문제 */
                width: 900,
                height: 600,
                url: "/contents/admConts/admLctrContsExrcsQstnListPop.do?orgId=" + encodeURIComponent(ORG_ID) + "&sbjctId=" + encodeURIComponent(SBJCT_ID) + "&lctrWkno=" + encodeURIComponent(LCTR_WKNO),
                autoresize: true
            });
            return false;
        }

        // 선택한 연습문제를 현재 팝업 입력값에 반영한다.
        function selectExrcsQstn(item) {
            $("#exrcsQstnId").val(item.exrcsSddnQstnBscId || "");
            $("#exrcsQstnTtl").val(item.qstnTtl || "");
            closeExrcsQstnListPop();
        }

        function closeExrcsQstnListPop() {
            if(exrcsDialog) {
                exrcsDialog.close();
                exrcsDialog = null;
            }
        }

        function saveLctrContsExrcsQstn() {
            if(!$.trim($("#lrnTocTtl").val())) {
                UiComm.showMessage('<spring:message code="common.pop.input.title"/>', "warning"); /* 제목을 입력하세요. */
                return false;
            }
            if(!isEditMode() && $("input[name='sbjctIds']:checked").length == 0) {
                UiComm.showMessage('<spring:message code="contents.msg.select.dvclas"/>', "warning"); /* 등록할 분반을 선택해 주세요. */
                return false;
            }
            if(!$("#exrcsQstnId").val()) {
                UiComm.showMessage('<spring:message code="contents.msg.select.exercise.question"/>', "warning"); /* 연습문제를 선택해 주세요. */
                return false;
            }

            $("#saveBtn").prop("disabled", true);
            ajaxCall("/contents/admConts/admLctrContsSave.do", createSaveParams(), function(res) {
                $("#saveBtn").prop("disabled", false);
                if(res.result > 0) {
                    showParentMessage(res.message || '<spring:message code="success.common.insert"/>', "success", function() { /* 정상적으로 등록되었습니다. */
                        if(window.parent && window.parent !== window && typeof window.parent.afterLctrContsSave === "function") {
                            window.parent.afterLctrContsSave();
                        } else {
                            closeLctrContsExrcsQstnPop();
                        }
                    });
                } else {
                    UiComm.showMessage(res.message || '<spring:message code="fail.common.insert"/>', "error"); /* 생성이 실패하였습니다. */
                }
            }, function() {
                $("#saveBtn").prop("disabled", false);
                UiComm.showMessage('<spring:message code="fail.common.insert"/>', "error"); /* 생성이 실패하였습니다. */
            });
            return false;
        }

        function createSaveParams() {
            var params = {
                orgId: ORG_ID,
                sbjctId: SBJCT_ID,
                lctrWknoSchdlId: LCTR_WKNO_SCHDL_ID,
                lctrWkno: LCTR_WKNO,
                lctrId: LCTR_ID,
                lctrContsId: LCTR_CONTS_ID,
                lctrContsTycd: "EXERC_QSTN",
                // TODO: 연습문제는 첨부 파일이 없으므로 임시 콘텐츠명을 저장한다.
                contsnm: "-",
                atndcRfltyn: $("#atndcRfltyn").is(":checked") ? "Y" : "N",
                oyn: "Y",
                contsSeqno: $("#contsSeqno").val(),
                lrnTocTtl: $.trim($("#lrnTocTtl").val()),
                exrcsQstnId: $("#exrcsQstnId").val()
            };

            if(!isEditMode()) {
                $("input[name='sbjctIds']").each(function(index) {
                    var dvclasNo = (this.id || "").indexOf("declas_") === 0 ? (this.id || "").substring(7) : "";
                    params["dvclasSelList[" + index + "].dvclasNo"] = dvclasNo;
                    params["dvclasSelList[" + index + "].sbjctId"] = this.value || "";
                    params["dvclasSelList[" + index + "].checkedYn"] = $(this).is(":checked") ? "Y" : "N";
                });
            }

            return params;
        }

        function deleteLctrContsExrcsQstn() {
            if(!isEditMode() || !LCTR_CONTS_ID) {
                return false;
            }

            ajaxCall("/contents/admConts/admLctrContsLearningExists.do", {
                orgId: ORG_ID,
                lctrContsId: LCTR_CONTS_ID
            }, function(res) {
                if(res.result < 0) {
                    UiComm.showMessage(res.message || '<spring:message code="fail.common.select"/>', "error"); /* 조회가 실패하였습니다. */
                    return;
                }

                var confirmMessage = res.data
                        ? '<spring:message code="contents.msg.confirm.delete.learning.exists"/>' /* 학습 중인 학습자가 있습니다. 삭제할 경우 모든 학습자의 학습 정보가 삭제됩니다. 그래도 삭제 하시겠습니까? */
                        : '<spring:message code="common.delete.msg"/>'; /* 삭제하시겠습니까? */
                UiComm.showMessage(confirmMessage, "confirm").then(function(ok) {
                    if(ok) {
                        doDeleteLctrContsExrcsQstn();
                    }
                });
            }, function() {
                UiComm.showMessage('<spring:message code="fail.common.select"/>', "error"); /* 조회가 실패하였습니다. */
            });
            return false;
        }

        function doDeleteLctrContsExrcsQstn() {
            ajaxCall("/contents/admConts/admLctrContsDelete.do", {
                orgId: ORG_ID,
                lctrContsId: LCTR_CONTS_ID
            }, function(res) {
                if(res.result > 0) {
                    showParentMessage(res.message || '<spring:message code="success.common.delete"/>', "success", function() { /* 정상적으로 삭제되었습니다. */
                        if(window.parent && window.parent !== window && typeof window.parent.afterLctrContsSave === "function") {
                            window.parent.afterLctrContsSave();
                        } else {
                            closeLctrContsExrcsQstnPop();
                        }
                    });
                } else {
                    UiComm.showMessage(res.message || '<spring:message code="fail.common.delete"/>', "error"); /* 삭제가 실패하였습니다. */
                }
            });
        }

        function showParentMessage(message, type, callback) {
            if(window.parent && window.parent !== window && window.parent.UiComm) {
                window.parent.UiComm.showMessage(message, type).then(function() {
                    if($.isFunction(callback)) {
                        callback();
                    }
                });
                return;
            }
            UiComm.showMessage(message, type).then(function() {
                if($.isFunction(callback)) {
                    callback();
                }
            });
        }

        function closeLctrContsExrcsQstnPop() {
            if(window.parent && window.parent !== window && typeof window.parent.closeDialog === "function") {
                window.parent.closeDialog();
            }
        }
    </script>
</head>
<body class="modal-page">
    <c:set var="lctrWknoSymdText" value="${lctrContsVO.lctrWknoSymd}" />
    <c:set var="lctrWknoEymdText" value="${lctrContsVO.lctrWknoEymd}" />
    <c:if test="${fn:length(lctrWknoSymdText) eq 8}">
        <c:set var="lctrWknoSymdText" value="${fn:substring(lctrWknoSymdText, 0, 4)}.${fn:substring(lctrWknoSymdText, 4, 6)}.${fn:substring(lctrWknoSymdText, 6, 8)}" />
    </c:if>
    <c:if test="${fn:length(lctrWknoEymdText) eq 8}">
        <c:set var="lctrWknoEymdText" value="${fn:substring(lctrWknoEymdText, 0, 4)}.${fn:substring(lctrWknoEymdText, 4, 6)}.${fn:substring(lctrWknoEymdText, 6, 8)}" />
    </c:if>
    <c:choose>
        <c:when test="${not empty lctrContsVO.modDttm}">
            <c:set var="lastModifiedDttmText" value="${lctrContsVO.modDttm}" />
            <c:set var="lastModifiedUserText" value="${empty lctrContsVO.mdfrNm ? lctrContsVO.mdfrId : lctrContsVO.mdfrNm}" />
        </c:when>
        <c:otherwise>
            <c:set var="lastModifiedDttmText" value="${lctrContsVO.regDttm}" />
            <c:set var="lastModifiedUserText" value="${empty lctrContsVO.rgtrNm ? lctrContsVO.rgtrId : lctrContsVO.rgtrNm}" />
        </c:otherwise>
    </c:choose>
    <c:if test="${fn:length(lastModifiedDttmText) eq 14}">
        <c:set var="lastModifiedDttmText" value="${fn:substring(lastModifiedDttmText, 0, 4)}.${fn:substring(lastModifiedDttmText, 4, 6)}.${fn:substring(lastModifiedDttmText, 6, 8)} ${fn:substring(lastModifiedDttmText, 8, 10)}:${fn:substring(lastModifiedDttmText, 10, 12)}:${fn:substring(lastModifiedDttmText, 12, 14)}" />
    </c:if>
    <spring:message code="contents.label.sort.order.no" var="sortOrderNoMsg"/>
    <spring:message code="contents.label.division" var="divisionMsg"/>
    <spring:message code="common.label.title" var="titleMsg"/>
    <spring:message code="forum.label.dvclas.same.reg" var="dvclasSameRegMsg"/>
    <spring:message code="contents.label.attendance.target" var="attendanceTargetMsg"/>
    <spring:message code="contents.label.sort.order" var="sortOrderMsg"/>
    <spring:message code="contents.label.exercise.test.paper" var="exerciseTestPaperMsg"/>
    <spring:message code="contents.label.last.modified" var="lastModifiedMsg"/>
    <div class="wrap">
        <div class="board_top">
            <h3 class="board-title">
                <c:choose>
                    <c:when test="${not empty lctrContsVO.lctrWkno}">
                        <c:out value="${lctrContsVO.lctrWkno}" /><spring:message code="contents.label.week.suffix"/><%-- 주차 --%>
                    </c:when>
                    <c:otherwise>
                        <spring:message code="contents.label.week"/><%-- 주차 --%>
                    </c:otherwise>
                </c:choose>
            </h3>
            <div class="right-area">
                <span class="total_txt"><spring:message code="contents.label.learning.period"/><%-- 학습기간 --%> :<b> <c:out value="${lctrWknoSymdText}" /><c:if test="${not empty lctrWknoSymdText or not empty lctrWknoEymdText}"> ~ </c:if><c:out value="${lctrWknoEymdText}" /></b></span>
            </div>
        </div>

        <div class="board_top">
            <h4 class="sub-title"><spring:message code="contents.lecture.content.list"/><%-- 콘텐츠 목록 --%></h4>
        </div>
        <div class="table-wrap">
            <table class="table-type3">
                <caption><spring:message code="contents.lecture.content.list"/><%-- 콘텐츠 목록 --%></caption>
                <colgroup>
                    <col style="width:5%">
                    <col style="width:20%">
                    <col>
                </colgroup>
                <thead>
                    <tr>
                        <th scope="col"><spring:message code="contents.label.sort.order.no"/><%-- 정렬 순번 --%></th>
                        <th scope="col"><spring:message code="contents.label.division"/><%-- 구분 --%></th>
                        <th scope="col"><spring:message code="common.label.title"/><%-- 제목 --%></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty weekContsList}">
                            <tr>
                                <td colspan="3"><spring:message code="contents.msg.no.learning.material"/><%-- 등록된 학습자료가 없습니다. --%></td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="item" items="${weekContsList}">
                                <tr>
                                    <td data-th="${sortOrderNoMsg}"><c:out value="${item.contsSeqno}"/></td>
                                    <td data-th="${divisionMsg}">
                                        <c:choose>
                                            <c:when test="${item.lctrContsTycd eq 'VIDEO'}"><spring:message code="contents.label.video"/><%-- 동영상 --%></c:when>
                                            <c:when test="${item.lctrContsTycd eq 'EXERC_QSTN'}"><spring:message code="contents.label.quiz"/><%-- 연습문제 --%></c:when>
                                            <c:when test="${item.lctrContsTycd eq 'SNS_URL' or item.lctrContsTycd eq 'SNS_HTML'}"><spring:message code="contents.label.social"/><%-- 소셜 --%></c:when>
                                            <c:otherwise><c:out value="${item.lctrContsTycd}"/></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td data-th="${titleMsg}" class="t_left"><c:out value="${empty item.lrnTocTtl ? '-' : item.lrnTocTtl}"/></td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <div class="board_top">
            <h4 class="sub-title"><spring:message code="contents.label.quiz.add"/><%-- 연습문제 추가 --%></h4>
        </div>
        <div class="table-wrap">
            <table class="table-type5">
                <caption><spring:message code="contents.label.quiz.add"/><%-- 연습문제 추가 --%></caption>
                <colgroup>
                    <col style="width:15%">
                    <col>
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row"><spring:message code="contents.label.division"/><%-- 구분 --%></th>
                        <td data-th="${divisionMsg}"><spring:message code="contents.label.quiz"/><%-- 연습문제 --%></td>
                    </tr>
                    <tr>
                        <th scope="row" class="req"><label for="lrnTocTtl"><spring:message code="common.label.title"/><%-- 제목 --%></label></th>
                        <td data-th="${titleMsg}">
                            <input type="text" class="form-control width-50per" id="lrnTocTtl" value="<c:out value='${lctrContsVO.lrnTocTtl}'/>" maxlength="200" required="true"/>
                        </td>
                    </tr>
                    <c:if test="${mode ne 'E'}">
                        <tr>
                            <th scope="row" class="req"><spring:message code="forum.label.dvclas.same.reg"/><%-- 분반같이 등록 --%></th>
                            <td data-th="${dvclasSameRegMsg}">
                                <div class="checkbox_type">
                                    <span class="custom-input">
                                        <input type="checkbox" name="allDeclasNo" value="all" id="allDeclas"/>
                                        <label for="allDeclas"><spring:message code="contents.label.all"/><%-- 전체 --%></label>
                                    </span>
                                    <c:forEach var="list" items="${dvclasList}">
                                        <span class="custom-input">
                                            <input type="checkbox" ${list.sbjctId eq lctrContsVO.sbjctId ? 'class="readonly" checked readonly' : ''} <c:if test="${list.registYn ne 'Y'}">disabled="disabled"</c:if> name="sbjctIds" id="declas_${list.dvclasNo}" value="${list.sbjctId}"/>
                                            <label for="declas_${list.dvclasNo}"><c:out value="${list.dvclasNo}"/><spring:message code="crs.label.dvclas.suffix"/><%-- 반 --%></label>
                                        </span>
                                    </c:forEach>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                    <tr>
                        <th scope="row"><label for="atndcRfltyn"><spring:message code="contents.label.attendance.target"/><%-- 출결대상 --%></label></th>
                        <td data-th="${attendanceTargetMsg}">
                            <span class="custom-input">
                                <input type="checkbox" id="atndcRfltyn" value="Y" <c:if test="${empty lctrContsVO.atndcRfltyn or lctrContsVO.atndcRfltyn eq 'Y'}">checked="checked"</c:if>>
                                <label for="atndcRfltyn"><spring:message code="contents.label.attendance.check.target"/><%-- 출결체크 대상에 포함 --%></label>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><label for="contsSeqno"><spring:message code="contents.label.sort.order"/><%-- 정렬순서 --%></label></th>
                        <td data-th="${sortOrderMsg}">
                            <input type="text" class="form-control sm" id="contsSeqno" value="<c:out value='${empty lctrContsVO.contsSeqno ? 1 : lctrContsVO.contsSeqno}'/>" maxlength="2" inputmask="numeric" maxVal="99"/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row" class="req"><label for="exrcsQstnTtl"><spring:message code="contents.label.exercise.test.paper"/><%-- 연습문제 시험지 --%></label></th>
                        <td data-th="${exerciseTestPaperMsg}">
                            <input type="hidden" id="exrcsQstnId" value="<c:out value='${lctrContsVO.exrcsQstnId}'/>"/>
                            <div class="search-typeC">
                                <input type="text" class="form-control" id="exrcsQstnTtl" value="<c:out value='${lctrContsVO.exrcsQstnTtl}'/>" placeholder="<spring:message code='contents.placeholder.exercise.test.paper.search'/>" readonly="readonly" autocomplete="off" style="width:30em"/><%-- 연습문제 시험지 선택 --%>
                                <button type="button" class="btn basic icon search" aria-label="검색" onclick="openExrcsQstnListPop();"><i class="icon-svg-search"></i></button>
                            </div>
                        </td>
                    </tr>
                    <c:if test="${mode eq 'E'}">
                        <tr>
                            <th scope="row"><spring:message code="contents.label.last.modified"/><%-- 최종수정 --%></th>
                            <td data-th="${lastModifiedMsg}">
                                <c:out value="${lastModifiedDttmText}" />
                                <c:if test="${not empty lastModifiedUserText}"> (<c:out value="${lastModifiedUserText}" />)</c:if>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <div class="btns">
            <button type="button" class="btn type1" id="saveBtn" onclick="saveLctrContsExrcsQstn();"><spring:message code="common.button.save"/><%--저장--%></button>
            <c:if test="${mode eq 'E'}">
                <button type="button" class="btn type2" onclick="deleteLctrContsExrcsQstn();"><spring:message code="common.button.delete"/><%--삭제--%></button>
            </c:if>
            <button type="button" class="btn type2" onclick="closeLctrContsExrcsQstnPop();"><spring:message code="common.button.close"/><%--닫기--%></button>
        </div>
    </div>
</body>
</html>
