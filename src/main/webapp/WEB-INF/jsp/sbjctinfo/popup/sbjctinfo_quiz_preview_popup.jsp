<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>
<body class="modal-page">
<%-- MLT_CHC 미리보기만 로컬 보정 --%>
<style>
    .question_area .question_con .q_cont .q_cont_ans input[type="checkbox"] {
        display: none;
    }

    .question_area .question_con .q_cont .q_cont_ans input[type="checkbox"]:checked + label .ansNum {
        background-color: var(--btn-active);
        color: var(--bc-white);
    }
</style>
<div id="wrap" class="popup_wrap">
<div class="modal-body">

    <%-- 팝업 제목 --%>
    <div class="msg-box basic">
        <h2 class="text-center margin-left-auto margin-right-auto">
            <span class="fcBlue"><i class="xi-alarm fs-26px"></i><spring:message code="crs.title.surprise"/><%-- 돌발 --%></span> <spring:message code="crs.title.quiz"/><%-- 퀴즈 --%>
        </h2>
    </div>

    <c:choose>
        <c:when test="${empty quizInfoList}">
            <div class="table-wrap">
                <table class="table-type2">
                    <tbody>
                    <tr>
                        <td class="t_center"><spring:message code="crs.empty.surprise.quiz.question.info"/><%-- 돌발퀴즈 문항 정보가 없습니다. --%></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </c:when>
        <c:otherwise>
            <c:set var="prevQstnId" value=""/>
            <c:set var="prevCransExpln" value=""/>

            <c:forEach var="row" items="${quizInfoList}" varStatus="st">

                <%-- 새 문항 시작 --%>
                <c:if test="${prevQstnId ne row.qstnId}">

                    <%-- 이전 문항 닫기 --%>
                    <c:if test="${not empty prevQstnId}">
                                        </ol>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="modal_btns" id="confirmWrap_${prevQstnId}">
                            <button type="button" class="btn type2 quizAnswerBtn" data-qstn-id="<c:out value='${prevQstnId}'/>"><spring:message code="common.button.ok"/><%-- 확인 --%></button>
                        </div>

                        <div id="result_${prevQstnId}" class="mt10" style="display:none;">
                            <div id="resultSuccess_${prevQstnId}" class="msg-box success" style="display:none;">
                                <div class="txt">
                                    <strong class="d-block"><i class="xi-check-circle-o"></i><spring:message code="crs.message.correct"/><%-- 정답입니다. --%></strong>
                                    <p class="mt10"><spring:message code="exam.label.answer"/><%-- 정답 --%> : <span id="answerSeqSuccess_${prevQstnId}">-</span></p>
                                    <c:if test="${not empty prevCransExpln}">
                                        <div class="htmlText mt10"><c:out value="${prevCransExpln}" escapeXml="false"/></div>
                                    </c:if>
                                </div>
                            </div>
                            <div id="resultWarning_${prevQstnId}" class="msg-box warning" style="display:none;">
                                <div class="txt">
                                    <strong class="d-block"><i class="xi-close-circle-o"></i><spring:message code="crs.message.incorrect"/><%-- 오답입니다. --%></strong>
                                    <p class="mt10"><spring:message code="exam.label.answer"/><%-- 정답 --%> : <span id="answerSeqWarning_${prevQstnId}">-</span></p>
                                    <c:if test="${not empty prevCransExpln}">
                                        <div class="htmlText mt10"><c:out value="${prevCransExpln}" escapeXml="false"/></div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <%-- 새 문항 영역 열기 --%>
                    <div class="course_history bd0 mb10">
                        <div class="question_area pd0">
                            <div class="question_con">
                                <div class="q_top">
                                    <div class="flex-item width-100per">
                                        <p class="flex-none mr15"><b>Q<c:out value="${empty row.qstnSeqno ? st.count : row.qstnSeqno}"/>.</b></p>
                                        <div class="flex-1 tal htmlText">
                                            <c:choose>
                                                <c:when test="${not empty row.qstnCts}">
                                                    <c:out value="${row.qstnCts}" escapeXml="false"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:out value="${empty row.qstnTtl ? '-' : row.qstnTtl}"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                                <div class="q_cont">
                                    <ol class="q_cont_ans d-block" id="qbox_${row.qstnId}">
                    <c:set var="prevCransExpln" value="${row.cransExpln}"/>
                </c:if>

                <%-- 보기 항목: 문항유형(ONE_CHC/MLT_CHC)에 따라 input 타입 분기 --%>
                <li class="mb15">
                    <input type="${row.qstnRspnsTycd eq 'MLT_CHC' ? 'checkbox' : 'radio'}"
                           name="qstn_${row.qstnId}"
                           id="qstn_${row.qstnId}_${row.qstnVwitmSeqno}"
                           value="${row.qstnVwitmSeqno}"
                           data-crans-yn="${row.cransYn}"/>
                    <label for="qstn_${row.qstnId}_${row.qstnVwitmSeqno}">
                        <span class="ansNum"><c:out value="${row.qstnVwitmSeqno}"/></span><c:out value="${empty row.exCts ? '-' : row.exCts}"/>
                    </label>
                </li>

                <c:set var="prevQstnId" value="${row.qstnId}"/>

                <%-- 마지막 문항 닫기 --%>
                <c:if test="${st.last}">
                                    </ol>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="modal_btns" id="confirmWrap_${row.qstnId}">
                        <button type="button" class="btn type2 quizAnswerBtn" data-qstn-id="<c:out value='${row.qstnId}'/>"><spring:message code="common.button.ok"/><%-- 확인 --%></button>
                    </div>

                    <div id="result_${row.qstnId}" class="mt10" style="display:none;">
                        <div id="resultSuccess_${row.qstnId}" class="msg-box success" style="display:none;">
                            <div class="txt">
                                <strong class="d-block"><i class="xi-check-circle-o"></i><spring:message code="crs.message.correct"/><%-- 정답입니다. --%></strong>
                                <p class="mt10"><spring:message code="exam.label.answer"/><%-- 정답 --%> : <span id="answerSeqSuccess_${row.qstnId}">-</span></p>
                                <c:if test="${not empty row.cransExpln}">
                                    <div class="htmlText mt10"><c:out value="${row.cransExpln}" escapeXml="false"/></div>
                                </c:if>
                            </div>
                        </div>
                        <div id="resultWarning_${row.qstnId}" class="msg-box warning" style="display:none;">
                            <div class="txt">
                                <strong class="d-block"><i class="xi-close-circle-o"></i><spring:message code="crs.message.incorrect"/><%-- 오답입니다. --%></strong>
                                <p class="mt10"><spring:message code="exam.label.answer"/><%-- 정답 --%> : <span id="answerSeqWarning_${row.qstnId}">-</span></p>
                                <c:if test="${not empty row.cransExpln}">
                                    <div class="htmlText mt10"><c:out value="${row.cransExpln}" escapeXml="false"/></div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:if>
            </c:forEach>
        </c:otherwise>
    </c:choose>

    <div class="modal_btns" id="closeWrap" style="display:none;">
        <button type="button" class="btn type2 closeQuizPreviewBtn"><spring:message code="common.button.close"/><%-- 닫기 --%></button>
    </div>
</div>
</div>

<script type="text/javascript">
    $(function () {
        $(".quizAnswerBtn").on("click", function () {
            checkQuizAnswer($(this).attr("data-qstn-id"));
        });
        $(".closeQuizPreviewBtn").on("click", function () {
            window.parent.closeDialog();
        });
    });

    function checkQuizAnswer(qstnId) {
        var $inputs = $("input[name='qstn_" + qstnId + "']");
        var $checked = $inputs.filter(":checked");
        if ($checked.length === 0) {
            UiComm.showMessage("<spring:message code='crs.message.select.choice'/><%-- 보기를 선택하세요. --%>", "warning");
            return;
        }

        var correctValues = [];
        var checkedValues = [];
        var correctSeq = "-";
        var isCorrect = false;

        $inputs.filter("[data-crans-yn='Y']").each(function () {
            correctValues.push($(this).val());
        });
        $checked.each(function () {
            checkedValues.push($(this).val());
        });

        if (correctValues.length > 0) {
            correctSeq = correctValues.join(", ");
        }

        if ($inputs.first().attr("type") === "checkbox") {
            // 복수선택은 정답 집합과 선택 집합이 동일할 때만 정답 처리한다.
            isCorrect = true;

            if (checkedValues.length !== correctValues.length) {
                isCorrect = false;
            } else {
                $.each(checkedValues, function (idx, value) {
                    if ($.inArray(value, correctValues) < 0) {
                        isCorrect = false;
                        return false;
                    }
                });
            }
        } else {
            isCorrect = ($checked.first().data("cransYn") === "Y");
        }

        $("#answerSeqSuccess_" + qstnId).text(correctSeq);
        $("#answerSeqWarning_" + qstnId).text(correctSeq);
        $("#result_" + qstnId).show();
        $("#closeWrap").show();

        if (isCorrect) {
            $("#resultWarning_" + qstnId).hide();
            $("#resultSuccess_" + qstnId).show();
        } else {
            $("#resultSuccess_" + qstnId).hide();
            $("#resultWarning_" + qstnId).show();
        }
    }
</script>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
