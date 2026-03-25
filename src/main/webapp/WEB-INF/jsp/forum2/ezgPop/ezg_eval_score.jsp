<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<script type="text/javascript">
$(document).ready(function() {
	<c:if test="${not empty evalRsltVo && not empty evalRsltVo.evalScore}">
	if (typeof setTotalScore == 'function') {
		setTotalScore('${evalRsltVo.evalScore}');
	}
	</c:if>
});

//정수인지 검사
function isIntegerNumber(value) {
	if( value === undefined || value == null || $.trim(value) == '' ) {
		return false;
	}

	var reg = /^\d+$/;
	value += '';
	return reg.test(value.replace(/,/gi,""));
}

// 루브릭 점수 클릭시 문항 총점, total점수 환산점 등 계산
function selectRublicScore(obj) {
	$(obj).closest('tr').find('input[name=qstnScore]').val($(obj).attr('data-score'));
	$(obj).closest('tr').find('td[name=dpQstnScore]').text($(obj).attr('data-score') + '<spring:message code="forum.label.point" />'); // 점
	computeSumScore();
}

// 척도형 점수 클릭시 문항 총점, total점수 환산점 등 계산
function selectScaleScore(obj) {
	$(obj).closest('tr').find('input[name=qstnScore]').val($(obj).val());
	computeSumScore();
}

// 점수형 점수 입력시 검사
function validateScore(obj) {
	var qstnAllotScore = Number($(obj).closest('div').find('input:hidden[name=qstnAllotScore]').val());
	if (isIntegerNumber($(obj).val()) ) {
		if (Number($(obj).val()) > qstnAllotScore) {
			$(obj).val(qstnAllotScore);
		}
	} else {
		$(obj).val('');
	}
	computeSumScore();
}

// 총점, 환산점수  계산
function computeSumScore() {
	var qstrnScoreObjs = $('input[name=qstnScore]');
	var sumScore = 0;
	var totalAllotScore = 0;
	$('input:hidden[name=qstnAllotScore]').each(function (idx) {
		totalAllotScore += Number($(this).val());
		if ($(qstrnScoreObjs[idx]).val() && $.trim($(qstrnScoreObjs[idx]).val()) != '' && isIntegerNumber($(qstrnScoreObjs[idx]).val())) {
			sumScore += Number($(qstrnScoreObjs[idx]).val());
		} else {
			sumScore += 0;
		}
	});

	var exchangeScore = Math.round(sumScore/totalAllotScore*100);
	$("#sumScore").text('<spring:message code="forum.label.total.point" /> : ' + sumScore + ' (<spring:message code="forum.label.exchange.score" /> : ' + exchangeScore + '<spring:message code="forum.label.point" />)' ); // 총점, 환산점수, 점
	if (typeof setTotalScore == 'function') {
		setTotalScore(exchangeScore);
	}
}
</script>

<c:if test="${not empty vo.teamCd && empty vo.stdNo}">
    <div class="ui small negative message mt0">
        <p><i class="warning icon"></i><spring:message code="forum_ezg.label.all_team.apply" /></p><!-- 팀 전체에 적용 됩니다. -->
    </div>
</c:if>
    <div class="ui top attached message">
        <div class="header"><c:out value='${evalInfo.evalTitle}' /></div>
        <input type="hidden" id="evalScoreBlockEvalCd" value="${evalInfo.evalCd}">
        <input type="hidden" id="evalScoreBlockMutEvalCd" value="${evalRsltVo.mutEvalCd}">
        <c:set var="sumAllotScore" value="0"/>
    </div>
    <div class="ui attached segment">
<c:if test="${evalInfo.evalTypeCd == 'R'}">
        <table class="tbl tablet td-sm">
            <thead>
                <tr>
                    <th scope="col" style="width: 25%"><spring:message code="forum.label.standard" /></th><!-- 기준 -->
                    <th scope="col"><spring:message code="forum.label.grade" /></th><!-- 등급 -->
                    <th scope="col" style="width: 100px"><spring:message code="forum.label.record" /></th><!-- 성적 -->
                </tr>
            </thead>
            <tbody>

        <c:if test="${not empty evalQstnList}">
            <c:forEach items="${evalQstnList }" var="item" varStatus="status">
                <c:set var="evalScore" />
                <c:if test="${not empty evalRsltVo && not empty evalRsltVo.qstnCdList}">
                    <c:forEach items="${evalRsltVo.qstnCdList}" var="qstnCdItem" varStatus="qstnCdStatus">
                        <c:if test="${qstnCdItem == item.qstnCd}">
                            <c:set var="evalScore" value="${evalRsltVo.evalScoreList[qstnCdStatus.index]}" />
                        </c:if>
                    </c:forEach>
                </c:if>
                <tr>
                    <td data-title="<spring:message code="forum.label.standard" />"><!-- 기준 -->
                        <c:out value='${item.qstnCts}' />
                        <input type="hidden" name="qstnScore" value="${evalScore}" />
                        <input type="hidden" name="qstnCd" value="${item.qstnCd}"  />
                        <input type="hidden" name="qstnAllotScore" value="${item.allotScore}"  />
                        <c:set var="sumAllotScore" value="${sumAllotScore + item.allotScore}"/>
                    </td>
                    <td class="p-0" data-title="<spring:message code="forum.label.grade" />"><!-- 등급 -->
                <c:if test="${not empty item.grades}">
                         <div class="ratings-column">
                    <c:forEach items="${item.grades}" var="grade" varStatus="gradeStatus">
                            <a href="javascript:;" class="box ${not empty evalScore && evalScore == grade.gradeScore?'select':''}" 
                                data-score="${grade.gradeScore}" onClick="selectRublicScore(this)">
                                <div class="score">${grade.gradeScore }<spring:message code="forum.label.point" /></div><!-- 점 -->
                                <div class="title"><c:out value='${grade.gradeTitle}' /></div>
                                <div class="description"><c:out value='${grade.gradeCts}' /></div>
                            </a>
                    </c:forEach>
                        </div>
                </c:if>
                    </td>
                    <td data-title="<spring:message code="forum.label.record" />" name="dpQstnScore"><!-- 성적 -->
                <c:if test="${not empty evalScore}">
                        ${evalScore}<spring:message code="forum.label.point" /><!-- 점 -->
                </c:if>
                <c:if test="${empty evalScore}">
                        0<spring:message code="forum.label.point" /><!-- 점 -->
                </c:if>
                    </td>
                </tr>
            </c:forEach>
        </c:if>

            </tbody>
        </table>
</c:if>

<c:if test="${evalInfo.evalTypeCd == 'M'}">
    <c:if test="${not empty evalQstnList}">
        <table class="grid-table" summary="<spring:message code="forum.label.multi.choice.grid.list" />"><!-- 객관식 그리드 리스트입니다. -->
            <thead>
                <tr>
                    <th scope="col" class="head"></th>
                <c:forEach items="${evalQstnList[0].grades}" var="grade" varStatus="gradeStatus">
                    <th scope="col" class="col"><c:out value='${grade.gradeTitle}' /></th>
                </c:forEach>
                </tr>
            </thead>
            <tbody>
            <c:forEach items="${evalQstnList }" var="item" varStatus="status">
                <c:set var="evalScore" />
                <c:if test="${not empty evalRsltVo && not empty evalRsltVo.qstnCdList}">
                    <c:forEach items="${evalRsltVo.qstnCdList}" var="qstnCdItem" varStatus="qstnCdStatus">
                        <c:if test="${qstnCdItem == item.qstnCd}">
                            <c:set var="evalScore" value="${evalRsltVo.evalScoreList[qstnCdStatus.index]}" />
                        </c:if>
                    </c:forEach>
                </c:if>
                <tr class="mo">
                    <td><p class="cell"><span><c:out value='${item.qstnCts}' /></span></p></td>
                </tr>
                <tr>
                    <td class="head">
                        <p class="cell"><span><c:out value='${item.qstnCts}' /></span></p>
                        <input type="hidden" name="qstnScore" value="${evalScore}" />
                        <input type="hidden" name="qstnCd" value="${item.qstnCd}"  />
                        <input type="hidden" name="qstnAllotScore" value="${item.allotScore}"  />
                        <c:set var="sumAllotScore" value="${sumAllotScore + item.allotScore}"/>
                    </td>
                <c:forEach items="${item.grades}" var="grade" varStatus="gradeStatus">
                    <td>
                        <input type="radio" name="chkItem_${item.qstnCd}"  value="${grade.gradeScore}" 
                            onChange="selectScaleScore(this)" ${not empty evalScore && evalScore == grade.gradeScore?'checked':''} >
                    </td>
                </c:forEach>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>
</c:if>

<c:if test="${evalInfo.evalTypeCd == 'S'}">
        <div class="grouped fields">
    <c:if test="${not empty evalQstnList}">
        <c:forEach items="${evalQstnList }" var="item" varStatus="status">
            <c:set var="evalScore" />
            <c:if test="${not empty evalRsltVo && not empty evalRsltVo.qstnCdList}">
                <c:forEach items="${evalRsltVo.qstnCdList}" var="qstnCdItem" varStatus="qstnCdStatus">
                    <c:if test="${qstnCdItem == item.qstnCd}">
                        <c:set var="evalScore" value="${evalRsltVo.evalScoreList[qstnCdStatus.index]}" />
                    </c:if>
                </c:forEach>
            </c:if>
            <div class="field">
                <div class="ui labeled input eval-input-box">
                <c:if test="${status.index + 1 < 10}">
                    <div class="ui label">0${status.index+1}</div>
                </c:if>
                <c:if test="${status.index + 1 >= 10}">
                    <div class="ui label">${status.index+1}</div>
                </c:if>
                    <label class="ui basic label"><c:out value='${item.qstnCts}' /></label>
                    <div class="ui input">
                        <input type="text" placeholder="<spring:message code="forum.label.record" />" name="qstnScore" value="${evalScore}" maxlength="3" onFocusOut="validateScore(this)" /><!-- 성적 -->
                        <input type="hidden" name="qstnCd" value="${item.qstnCd}"  />
                        <input type="hidden" name="qstnAllotScore" value="${item.allotScore}" />
                        <c:set var="sumAllotScore" value="${sumAllotScore + item.allotScore}"/>
                    </div>
                </div>
            </div>
        </c:forEach>
    </c:if>
        </div>
</c:if>

    </div>
    <div class="ui bottom attached segment">
        <div class="option-content mb0">
            <c:set var="totalScore" value="${not empty evalRsltVo && not empty evalRsltVo.evalTotal?evalRsltVo.evalTotal:0}" />
            <c:set var="sumAllotScore" value="${sumAllotScore == 0?1:sumAllotScore}"/>
            <c:set var="exchangeScore" value="${totalScore/sumAllotScore*100}" />
            <div class="button-area">
                <strong class="f120" id="sumScore"><spring:message code="forum.label.total.point" /><!-- 총점 --> : ${totalScore} 
            (<spring:message code="forum.label.exchange.score" /><!-- 환산점수 --> : <fmt:formatNumber value="${exchangeScore}" pattern="0" /><spring:message code="forum.label.point" /><!-- 점 -->)</strong>
            </div>
        </div>
    </div>

