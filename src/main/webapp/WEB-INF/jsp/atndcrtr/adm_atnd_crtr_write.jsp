<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>

<body class="admin ${bodyClass}">
    <div id="wrap" class="main atndcrtr-page">
        <jsp:include page="/WEB-INF/jsp/common_new/admin_header.jsp"/>

        <main class="common">
            <jsp:include page="/WEB-INF/jsp/common_new/admin_aside.jsp"/>

            <div id="content" class="content-wrap common">
                <div class="admin_sub">
                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                            <uiex:navibar type="admin"/>
                        </div>

                        <div class="box">
                            <div class="board_top">
                                <h3 class="board-title">
                                    <c:choose>
                                        <c:when test="${mode eq 'write'}"><spring:message code="common.button.create"/></c:when>
                                        <c:otherwise><spring:message code="common.button.modify"/></c:otherwise>
                                    </c:choose>
                                </h3>
                            </div>

                            <form id="atndCrtrForm" name="atndCrtrForm" method="post">
                                <input type="hidden" id="encParams" name="encParams" value="<c:out value='${encParams}'/>">
                                <input type="hidden" id="smstrChrtId" name="smstrChrtId" value="<c:out value='${vo.smstrChrtId}'/>">
                                <input type="hidden" id="atndMinPrgrt" name="atndMinPrgrt" value="<c:out value='${vo.atndMinPrgrt}'/>">
                                <input type="hidden" id="lateMinPrgrt" name="lateMinPrgrt" value="<c:out value='${vo.lateMinPrgrt}'/>">
                                <input type="hidden" id="lateRecgRate" name="lateRecgRate" value="<c:out value='${vo.lateRecgRate}'/>">
                                <input type="hidden" id="absentRecgRate" name="absentRecgRate" value="<c:out value='${vo.absentRecgRate}'/>">

                                <c:if test="${basicLockYn eq 'Y'}">
                                    <input type="hidden" name="orgId" value="<c:out value='${vo.orgId}'/>">
                                    <input type="hidden" name="haksaYear" value="<c:out value='${vo.haksaYear}'/>">
                                    <input type="hidden" name="haksaTerm" value="<c:out value='${vo.haksaTerm}'/>">
                                </c:if>

                                <div class="table-wrap">
                                    <table class="table-type5">
                                        <colgroup>
                                            <col class="width-15per"/>
                                            <col/>
                                        </colgroup>
                                        <tbody>
                                            <tr>
                                                <th class="req"><spring:message code="crs.atndc.crtr.label.org"/></th>
                                                <td data-th="<spring:message code='crs.atndc.crtr.label.org'/>">
                                                    <div class="form-inline">
                                                        <select id="orgId" name="orgId" class="form-select type-num w350" <c:if test="${basicLockYn eq 'Y'}">disabled="disabled"</c:if>>
                                                            <c:if test="${allOrgYn eq 'Y'}">
                                                                <option value=""><spring:message code="crs.atndc.crtr.label.select"/></option>
                                                            </c:if>
                                                            <c:forEach var="org" items="${orgInfoList}">
                                                                <option value="${org.orgId}" <c:if test="${org.orgId eq vo.orgId}">selected="selected"</c:if>><c:out value="${empty org.orgNm ? org.orgnm : org.orgNm}"/></option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="req"><spring:message code="crs.atndc.crtr.label.year.term"/></th>
                                                <td data-th="<spring:message code='crs.atndc.crtr.label.year.term'/>">
                                                    <div class="form-inline">
                                                        <select id="haksaYear" name="haksaYear" class="form-select type-num w150" <c:if test="${basicLockYn eq 'Y'}">disabled="disabled"</c:if>>
                                                            <option value=""><spring:message code="crs.atndc.crtr.label.year"/></option>
                                                            <c:forEach var="year" items="${yearList}">
                                                                <option value="${year}" <c:if test="${year eq vo.haksaYear}">selected="selected"</c:if>><c:out value="${year}"/></option>
                                                            </c:forEach>
                                                        </select>
                                                        <select id="haksaTerm" name="haksaTerm" class="form-select type-num w200" <c:if test="${basicLockYn eq 'Y'}">disabled="disabled"</c:if>>
                                                            <option value=""><spring:message code="crs.atndc.crtr.label.term"/></option>
                                                            <c:forEach var="term" items="${haksaTermList}">
                                                                <c:set var="termLabel" value="${empty term.haksaTermNm ? term.haksaTerm : term.haksaTermNm}"/>
                                                                <option value="${term.haksaTerm}" <c:if test="${term.haksaTerm eq vo.haksaTerm}">selected="selected"</c:if>><c:out value="${termLabel}"/></option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                    <c:if test="${mode eq 'write'}">
                                                        <button type="button" class="btn type2" onclick="fn_loadPrev();"><spring:message code="crs.atndc.crtr.button.load.prev"/></button>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>

                                <table class="table-type3">
                                    <colgroup>
                                        <col style="width:8%">
                                        <col style="width:3%">
                                        <col>
                                        <col style="width:15%">
                                        <col>
                                        <col style="width:5%">
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th scope="col" colspan="6"><spring:message code="crs.atndc.crtr.section.criteria"/></th>
                                        </tr>
                                        <tr>
                                            <th scope="col"><spring:message code="crs.atndc.crtr.label.category"/></th>
                                            <th scope="col" colspan="2"><spring:message code="crs.atndc.crtr.label.condition"/></th>
                                            <th scope="col"><spring:message code="crs.atndc.crtr.label.progress.recognition.rate"/></th>
                                            <th scope="col"><spring:message code="crs.atndc.crtr.label.attendance.criteria"/></th>
                                            <th scope="col"><spring:message code="crs.atndc.crtr.label.attendance.mark"/></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <th data-th="<spring:message code='crs.atndc.crtr.label.category'/>">배속 인정</th>
                                            <td data-th="<spring:message code='crs.atndc.crtr.label.category'/>" colspan="5" class="t_left">
                                                <div class="form-inline">
                                                    <span class="custom-input">
                                                        <input type="radio" name="playRateRecgYn" id="playRateRecgYnY" value="Y" <c:if test="${empty vo.playRateRecgYn or vo.playRateRecgYn eq 'Y'}">checked="checked"</c:if>>
                                                        <label for="playRateRecgYnY">예</label>
                                                    </span>
                                                    <span class="custom-input ml5">
                                                        <input type="radio" name="playRateRecgYn" id="playRateRecgYnN" value="N" <c:if test="${vo.playRateRecgYn eq 'N'}">checked="checked"</c:if>>
                                                        <label for="playRateRecgYnN">아니오</label>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th data-th="<spring:message code='crs.atndc.crtr.label.category'/>" rowspan="3"><spring:message code="crs.atndc.crtr.label.each.week"/></th>
                                            <td data-th="<spring:message code='crs.atndc.crtr.label.condition'/>">1</td>
                                            <td data-th="<spring:message code='crs.atndc.crtr.label.condition'/>" class="t_left"><spring:message code="crs.atndc.crtr.label.study.period.progress"/></td>
                                            <td data-th="<spring:message code='crs.atndc.crtr.label.progress.recognition.rate'/>" class="t_left">
                                                <div class="form-row align-items-center gap-1">
                                                    <div class="input_btn">
                                                        <input class="form-control sm" type="number" value="100" readonly="readonly">
                                                        <label>%</label>
                                                    </div>
                                                    <div><spring:message code="crs.atndc.crtr.label.recognition"/></div>
                                                </div>
                                            </td>
                                            <td data-th="<spring:message code='crs.atndc.crtr.label.attendance.criteria'/>" class="t_left">
                                                <div class="form-row align-items-center gap-1 flex-wrap">
                                                    <div><spring:message code="crs.atndc.crtr.label.first.progress"/></div>
                                                    <div class="input_btn">
                                                        <input type="number" id="atndMinPrgrtInput" class="form-control sm tr week-crtr-input" min="0" max="100" step="1" value="<c:out value='${vo.atndMinPrgrt}'/>">
                                                        <label>%</label>
                                                    </div>
                                                    <div><spring:message code="crs.atndc.crtr.label.more.than"/></div>
                                                </div>
                                            </td>
                                            <td data-th="<spring:message code='crs.atndc.crtr.label.attendance.mark'/>"><span class="fcBlue"><spring:message code="crs.atndc.crtr.label.attendance"/></span></td>
                                        </tr>
                                        <tr>
                                            <td data-th="<spring:message code='crs.atndc.crtr.label.condition'/>">2</td>
                                            <td data-th="<spring:message code='crs.atndc.crtr.label.condition'/>" class="t_left"><spring:message code="crs.atndc.crtr.label.late.period.progress"/></td>
                                            <td data-th="<spring:message code='crs.atndc.crtr.label.progress.recognition.rate'/>" class="t_left">
                                                <div class="form-row align-items-center gap-1">
                                                    <div class="input_btn">
                                                        <input type="number" id="lateRecgRateInput" class="form-control sm tr week-crtr-input" min="0" max="100" step="1" value="<c:out value='${vo.lateRecgRate}'/>">
                                                        <label>%</label>
                                                    </div>
                                                    <div><spring:message code="crs.atndc.crtr.label.recognition"/></div>
                                                </div>
                                            </td>
                                            <td data-th="<spring:message code='crs.atndc.crtr.label.attendance.criteria'/>" class="t_left">
                                                <div class="form-row align-items-center gap-1 flex-wrap">
                                                    <div><spring:message code="crs.atndc.crtr.label.first.progress"/></div>
                                                    <div class="input_btn">
                                                        <input type="number" id="atndMinPrgrtMirror" class="form-control sm tr" readonly="readonly">
                                                        <label>%</label>
                                                    </div>
                                                    <div><spring:message code="crs.atndc.crtr.label.less.than"/> &amp; (1+2)<spring:message code="crs.atndc.crtr.label.first.progress"/></div>
                                                    <div class="input_btn">
                                                        <input type="number" id="lateMinPrgrtInput" class="form-control sm tr week-crtr-input" min="0" max="100" step="1" value="<c:out value='${vo.lateMinPrgrt}'/>">
                                                        <label>%</label>
                                                    </div>
                                                    <div><spring:message code="crs.atndc.crtr.label.more.than"/></div>
                                                </div>
                                            </td>
                                            <td data-th="<spring:message code='crs.atndc.crtr.label.attendance.mark'/>"><span class="fcNot"><spring:message code="crs.atndc.crtr.label.late"/></span></td>
                                        </tr>
                                        <tr>
                                            <td data-th="<spring:message code='crs.atndc.crtr.label.condition'/>">3</td>
                                            <td data-th="<spring:message code='crs.atndc.crtr.label.condition'/>" class="t_left"><spring:message code="crs.atndc.crtr.label.other"/> <spring:message code="crs.atndc.crtr.label.study.period.progress"/></td>
                                            <td data-th="<spring:message code='crs.atndc.crtr.label.progress.recognition.rate'/>" class="t_left">
                                                <div class="form-row align-items-center gap-1">
                                                    <div class="input_btn">
                                                        <input type="number" id="absentRecgRateInput" class="form-control sm tr week-crtr-input" min="0" max="100" step="1" value="<c:out value='${vo.absentRecgRate}'/>">
                                                        <label>%</label>
                                                    </div>
                                                    <div><spring:message code="crs.atndc.crtr.label.recognition"/></div>
                                                </div>
                                            </td>
                                            <td data-th="<spring:message code='crs.atndc.crtr.label.attendance.criteria'/>" class="t_left"><spring:message code="crs.atndc.crtr.label.other"/></td>
                                            <td data-th="<spring:message code='crs.atndc.crtr.label.attendance.mark'/>"><span class="fcRed"><spring:message code="crs.atndc.crtr.label.absence"/></span></td>
                                        </tr>
                                    </tbody>
                                </table>

                                <table class="table-type3">
                                    <colgroup>
                                        <col style="width:8%">
                                        <col>
                                        <col>
                                        <col style="width:10%">
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th scope="col" colspan="4"><spring:message code="crs.atndc.crtr.formula.score"/></th>
                                        </tr>
                                        <tr>
                                            <th scope="col"><spring:message code="crs.atndc.crtr.label.category"/></th>
                                            <th scope="col"><spring:message code="crs.atndc.crtr.label.rate.condition"/></th>
                                            <th scope="col"><spring:message code="crs.atndc.crtr.label.attendance.score"/></th>
                                            <th scope="col"><spring:message code="crs.atndc.crtr.label.manage"/></th>
                                        </tr>
                                    </thead>
                                    <tbody id="scoreBody">
                                        <tr>
                                            <th data-th="<spring:message code='crs.atndc.crtr.label.category'/>"><span class="fcBlue"><spring:message code="crs.atndc.crtr.label.attendance"/></span></th>
                                            <td data-th="<spring:message code='crs.atndc.crtr.label.rate.condition'/>" class="t_left"><span class="fcBlue"><spring:message code="crs.atndc.crtr.label.attendance"/></span></td>
                                            <td data-th="<spring:message code='crs.atndc.crtr.label.attendance.score'/>" class="t_left">
                                                <div class="form-row align-items-center gap-1">
                                                    <div class="input_btn">
                                                        <input type="number" id="attendanceScoreInput" name="attendanceScore" class="form-control sm tr" min="0" step="1" value="<c:out value='${vo.attendanceScore}'/>">
                                                        <label><spring:message code="crs.atndc.crtr.label.point"/></label>
                                                    </div>
                                                </div>
                                            </td>
                                            <td data-th="<spring:message code='crs.atndc.crtr.label.manage'/>"></td>
                                        </tr>
                                        <tr>
                                            <th data-th="<spring:message code='crs.atndc.crtr.label.category'/>"><span class="fcNot"><spring:message code="crs.atndc.crtr.label.late"/></span></th>
                                            <td data-th="<spring:message code='crs.atndc.crtr.label.rate.condition'/>" class="t_left"><span class="fcNot"><spring:message code="crs.atndc.crtr.label.late"/></span></td>
                                            <td data-th="<spring:message code='crs.atndc.crtr.label.attendance.score'/>" class="t_left">
                                                <div class="form-row align-items-center gap-1">
                                                    <div class="input_btn">
                                                        <input type="number" id="lateScoreInput" name="lateScore" class="form-control sm tr" min="0" step="1" value="<c:out value='${vo.lateScore}'/>">
                                                        <label><spring:message code="crs.atndc.crtr.label.point"/></label>
                                                    </div>
                                                </div>
                                            </td>
                                            <td data-th="<spring:message code='crs.atndc.crtr.label.manage'/>"></td>
                                        </tr>
                                        <tr>
                                            <th data-th="<spring:message code='crs.atndc.crtr.label.category'/>"><span class="fcRed"><spring:message code="crs.atndc.crtr.label.absence"/></span></th>
                                            <td data-th="<spring:message code='crs.atndc.crtr.label.rate.condition'/>" class="t_left"><span class="fcRed"><spring:message code="crs.atndc.crtr.label.absence"/></span></td>
                                            <td data-th="<spring:message code='crs.atndc.crtr.label.attendance.score'/>" class="t_left">
                                                <div class="form-row align-items-center gap-1">
                                                    <div class="input_btn">
                                                        <input type="number" id="absenceScoreInput" name="absenceScore" class="form-control sm tr" min="0" step="1" value="<c:out value='${vo.absenceScore}'/>">
                                                        <label><spring:message code="crs.atndc.crtr.label.point"/></label>
                                                    </div>
                                                </div>
                                            </td>
                                            <td data-th="<spring:message code='crs.atndc.crtr.label.manage'/>"></td>
                                        </tr>
                                    </tbody>
                                </table>

                                <div class="btns">
                                    <button type="button" class="btn type1" onclick="fn_save();"><spring:message code="common.button.save"/></button>
                                    <button type="button" class="btn type2" onclick="fn_list();"><spring:message code="common.button.list"/></button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script type="text/javascript">
        var MODE = '<c:out value="${mode}" />';
        var EPARAM = '<c:out value="${encParams}" />';
        var MENU_ID = '<c:out value="${vo.menuId}" />';
        var CTX = '<%=request.getContextPath()%>';

        $(function() {
            $('.week-crtr-input').on('input', fn_syncWeekCrtrFields);
            fn_applyWeekCrtr({
                atndMinPrgrt: $('#atndMinPrgrt').val(),
                lateMinPrgrt: $('#lateMinPrgrt').val(),
                lateRecgRate: $('#lateRecgRate').val(),
                absentRecgRate: $('#absentRecgRate').val()
            });
            fn_applyCrtr({
                playRateRecgYn: $('input[name="playRateRecgYn"]:checked').val(),
                attendanceScore: $('#attendanceScoreInput').val(),
                lateScore: $('#lateScoreInput').val(),
                absenceScore: $('#absenceScoreInput').val()
            });

            if (MODE === 'write') {
                $('#orgId, #haksaYear').on('change', function() {
                    fn_loadWriteHaksaTerm('');
                });
            }
        });

        function fn_list() {
            location.href = fn_appendMenuId(CTX + '/atndcrtr/admAtndCrtrList.do?encParams=' + encodeURIComponent(EPARAM));
        }

        function fn_appendMenuId(url) {
            if (!MENU_ID) {
                return url;
            }
            return url + (url.indexOf('?') > -1 ? '&' : '?') + 'menuId=' + encodeURIComponent(MENU_ID);
        }

        function fn_loadWriteHaksaTerm(selectedTerm) {
            var orgId = $('#orgId').val();
            var haksaYear = $('#haksaYear').val();

            renderWriteHaksaTermOptions([], '');
            if (!orgId || !haksaYear) {
                return;
            }

            ajaxCall(CTX + '/atndcrtr/admListHaksaTerm.do', {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams({
                    orgId: orgId,
                    haksaYear: haksaYear
                })
            }, function(res) {
                if (res.encParams) {
                    EPARAM = res.encParams;
                    $('#encParams').val(EPARAM);
                }

                if (res.result > 0) {
                    renderWriteHaksaTermOptions(res.returnList || [], selectedTerm || '');
                } else {
                    UiComm.showMessage(res.message || '<spring:message code="crs.atndc.crtr.message.error.term.load" javaScriptEscape="true"/>', 'error');
                }
            }, function() {
                UiComm.showMessage('<spring:message code="crs.atndc.crtr.message.error.term.load" javaScriptEscape="true"/>', 'error');
            }, true);
        }

        function renderWriteHaksaTermOptions(list, selectedTerm) {
            var html = '<option value=""><spring:message code="crs.atndc.crtr.label.term" javaScriptEscape="true"/></option>';

            for (var i = 0; i < list.length; i++) {
                var term = list[i].haksaTerm || list[i].dgrsSmstrChrt || '';
                var termName = list[i].haksaTermNm || list[i].smstrChrtnm || list[i].smstrChrtNm || '';
                if (!term) {
                    continue;
                }
                html += '<option value="' + UiComm.escapeHtml(term) + '">' + UiComm.escapeHtml(fn_formatHaksaTermText(term, termName)) + '</option>';
            }

            $('#haksaTerm').html(html).val(selectedTerm || '');
        }

        function fn_formatHaksaTermText(term, termName) {
            var nameText = $.trim(termName || '');
            if (nameText) {
                return nameText;
            }
            return $.trim(term || '');
        }

        function fn_formatRateValue(value) {
            if (value === undefined || value === null || value === '') {
                return '';
            }
            var num = Number(value);
            if (isNaN(num)) {
                return value;
            }
            return num % 1 === 0 ? String(num) : String(num.toFixed(2)).replace(/\.?0+$/, '');
        }

        function fn_applyWeekCrtr(vo) {
            var atndMinPrgrt = fn_formatRateValue(vo.atndMinPrgrt);
            var lateMinPrgrt = fn_formatRateValue(vo.lateMinPrgrt);
            var lateRecgRate = fn_formatRateValue(vo.lateRecgRate);
            var absentRecgRate = fn_formatRateValue(vo.absentRecgRate);

            $('#atndMinPrgrt').val(atndMinPrgrt);
            $('#lateMinPrgrt').val(lateMinPrgrt);
            $('#lateRecgRate').val(lateRecgRate);
            $('#absentRecgRate').val(absentRecgRate);
            $('#atndMinPrgrtInput').val(atndMinPrgrt);
            $('#atndMinPrgrtMirror').val(atndMinPrgrt);
            $('#lateMinPrgrtInput').val(lateMinPrgrt);
            $('#lateRecgRateInput').val(lateRecgRate);
            $('#absentRecgRateInput').val(absentRecgRate);
        }

        function fn_syncWeekCrtrFields() {
            var atndMinPrgrt = fn_formatRateValue($('#atndMinPrgrtInput').val());
            var lateMinPrgrt = fn_formatRateValue($('#lateMinPrgrtInput').val());
            var lateRecgRate = fn_formatRateValue($('#lateRecgRateInput').val());
            var absentRecgRate = fn_formatRateValue($('#absentRecgRateInput').val());

            $('#atndMinPrgrt').val(atndMinPrgrt);
            $('#lateMinPrgrt').val(lateMinPrgrt);
            $('#lateRecgRate').val(lateRecgRate);
            $('#absentRecgRate').val(absentRecgRate);
            $('#atndMinPrgrtMirror').val(atndMinPrgrt);
        }

        function fn_validateBasic() {
            if (!$('#orgId').val()) {
                UiComm.showMessage('<spring:message code="crs.atndc.crtr.message.select.org" javaScriptEscape="true"/>', 'error');
                return false;
            }
            if (!$('#haksaYear').val()) {
                UiComm.showMessage('<spring:message code="crs.atndc.crtr.message.select.year" javaScriptEscape="true"/>', 'error');
                return false;
            }
            if (!$('#haksaTerm').val()) {
                UiComm.showMessage('<spring:message code="crs.atndc.crtr.message.select.term" javaScriptEscape="true"/>', 'error');
                return false;
            }
            return true;
        }

        function fn_validateScoreField(selector, label) {
            var value = $.trim($(selector).val());
            if (value === '') {
                UiComm.showMessage(label + '<spring:message code="crs.atndc.crtr.message.required" javaScriptEscape="true"/>', 'error');
                return false;
            }

            var num = Number(value);
            if (isNaN(num)) {
                UiComm.showMessage(label + '<spring:message code="crs.atndc.crtr.message.number" javaScriptEscape="true"/>', 'error');
                return false;
            }
            if (num < 0) {
                UiComm.showMessage(label + '<spring:message code="crs.atndc.crtr.message.row.score.nonnegative" javaScriptEscape="true"/>', 'error');
                return false;
            }
            return true;
        }

        function fn_validate() {
            if (!fn_validateBasic()) {
                return false;
            }
            fn_syncWeekCrtrFields();

            var weekCrtrFields = [
                { value: $('#atndMinPrgrt').val(), label: '<spring:message code="crs.atndc.crtr.label.study.period.progress" javaScriptEscape="true"/>' },
                { value: $('#lateMinPrgrt').val(), label: '<spring:message code="crs.atndc.crtr.label.late.period.progress" javaScriptEscape="true"/>' },
                { value: $('#lateRecgRate').val(), label: '<spring:message code="crs.atndc.crtr.label.late.recognition.progress" javaScriptEscape="true"/>' },
                { value: $('#absentRecgRate').val(), label: '<spring:message code="crs.atndc.crtr.label.absent.late.recognition.progress" javaScriptEscape="true"/>' }
            ];

            for (var i = 0; i < weekCrtrFields.length; i++) {
                var field = weekCrtrFields[i];
                if (field.value === '') {
                    UiComm.showMessage(field.label + '<spring:message code="crs.atndc.crtr.message.required" javaScriptEscape="true"/>', 'error');
                    return false;
                }
                var weekValue = Number(field.value);
                if (isNaN(weekValue)) {
                    UiComm.showMessage(field.label + '<spring:message code="crs.atndc.crtr.message.number" javaScriptEscape="true"/>', 'error');
                    return false;
                }
                if (weekValue < 0 || weekValue > 100) {
                    UiComm.showMessage(field.label + '<spring:message code="crs.atndc.crtr.message.range" javaScriptEscape="true"/>', 'error');
                    return false;
                }
            }

            if (!fn_validateScoreField('#attendanceScoreInput', '출석 점수')) {
                return false;
            }
            if (!fn_validateScoreField('#lateScoreInput', '지각 점수')) {
                return false;
            }
            if (!fn_validateScoreField('#absenceScoreInput', '결석 점수')) {
                return false;
            }

            return true;
        }

        function fn_save() {
            if (!fn_validate()) {
                return;
            }

            UiComm.showMessage('<spring:message code="crs.atndc.crtr.message.confirm.save" javaScriptEscape="true"/>', 'confirm').then(function(ok) {
                if (!ok) {
                    return;
                }

                ajaxCall(CTX + '/atndcrtr/admSaveAtndCrtr.do', $('#atndCrtrForm').serialize(), function(res) {
                    if (res.encParams) {
                        EPARAM = res.encParams;
                        $('#encParams').val(EPARAM);
                    }

                    if (res.result > 0) {
                        UiComm.showMessage(res.message || '<spring:message code="success.common.save"/>', 'success').then(function() {
                            location.href = fn_appendMenuId(CTX + '/atndcrtr/admAtndCrtrList.do?encParams=' + encodeURIComponent(EPARAM));
                        });
                    } else {
                        UiComm.showMessage(res.message || '<spring:message code="crs.atndc.crtr.message.error.save" javaScriptEscape="true"/>', 'error');
                    }
                }, function() {
                    UiComm.showMessage('<spring:message code="crs.atndc.crtr.message.error.save" javaScriptEscape="true"/>', 'error');
                }, true);
            });
        }

        function fn_loadPrev() {
            if (MODE !== 'write') {
                return;
            }
            if (!fn_validateBasic()) {
                return;
            }

            UiComm.showMessage('<spring:message code="crs.atndc.crtr.message.confirm.load.prev" javaScriptEscape="true"/>', 'confirm').then(function(ok) {
                if (!ok) {
                    return;
                }

                var extData = {
                    orgId: $('#orgId').val(),
                    haksaYear: $('#haksaYear').val(),
                    haksaTerm: $('#haksaTerm').val()
                };

                ajaxCall(CTX + '/atndcrtr/admLoadPrevAtndCrtr.do', {
                    encParams: EPARAM,
                    addParams: UiComm.makeEncParams(extData)
                }, function(res) {
                    if (res.encParams) {
                        EPARAM = res.encParams;
                        $('#encParams').val(EPARAM);
                    }

                    if (res.result > 0 && res.returnVO) {
                        fn_applyWeekCrtr(res.returnVO);
                        fn_applyCrtr(res.returnVO);
                    } else {
                        UiComm.showMessage(res.message || '<spring:message code="crs.atndc.crtr.message.empty.prev" javaScriptEscape="true"/>', 'error');
                    }
                }, function() {
                    UiComm.showMessage('<spring:message code="crs.atndc.crtr.message.error.prev.load" javaScriptEscape="true"/>', 'error');
                }, true);
            });
        }

        function fn_applyCrtr(vo) {
            var playRateRecgYn = vo.playRateRecgYn || 'Y';
            $('input[name="playRateRecgYn"][value="' + playRateRecgYn + '"]').prop('checked', true);
            $('#attendanceScoreInput').val(fn_formatRateValue(vo.attendanceScore));
            $('#lateScoreInput').val(fn_formatRateValue(vo.lateScore));
            $('#absenceScoreInput').val(fn_formatRateValue(vo.absenceScore));
        }
    </script>
</body>
</html>
