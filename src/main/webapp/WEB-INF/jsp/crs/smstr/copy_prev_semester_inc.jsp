<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>

<script type="text/javascript">
    var PREV_SMSTR_IMPORT_URL = '<c:out value="${prevSmstrImportUrl}" />';
    var PREV_SMSTR_IMPORT_EPARAM = '<c:out value="${encParams}" />';
    var PREV_SMSTR_IMPORT_ENABLED = [
        null
        , '${type1}', '${type2}', '${type3}', '${type4}', '${type5}'
        , '${type6}', '${type7}', '${type8}', '${type9}'
    ];
    var PREV_SMSTR_IMPORT_STATUS_TEXT = {
        // 처리중
        PROCESSING: '<spring:message code="crs.label.process.processing" />',
        // 성공
        SUCCESS: '<spring:message code="crs.label.process.success" />',
        // 실패
        FAIL: '<spring:message code="crs.label.process.fail" />'
    };

    var PREV_SMSTR_IMPORT_ITEMS = [
        null
        // 공지사항
        , { label: '<spring:message code="common.label.notice" />', importType: 1 }
        // 강의자료실
        , { label: '<spring:message code="common.label.pds" />', importType: 2 }
        // 학습자료
        , { label: '<spring:message code="lesson.label.lesson.cnts" />', importType: 3 }
        // 과제
        , { label: '<spring:message code="common.label.asmnt" />', importType: 4 }
        // 퀴즈
        , { label: '<spring:message code="common.label.question" />', importType: 5 }
        // 설문
        , { label: '<spring:message code="common.label.resh" />', importType: 6 }
        // 토론
        , { label: '<spring:message code="common.label.forum" />', importType: 7 }
        // 연습문제
        , { label: '<spring:message code="common.label.qstn.practice" />', importType: 8 }
        // 돌발퀴즈
        , { label: '<spring:message code="common.label.qstn.pop" />', importType: 9 }
    ];

    // 이전학기 가져오기 처리상태를 화면에 표시한다.
    function prevSmstrSetImportStatus(index, status) {
        var $status = $("#prevSmstrImportStatus" + index);
        if(status == "PROCESSING") {
            $status.html('<span class="state_ing"><i class="xi-spinner-5" aria-hidden="true"></i> ' + PREV_SMSTR_IMPORT_STATUS_TEXT.PROCESSING + '</span>');
            return;
        }

        if(status == "SUCCESS") {
            $status.html('<span class="state_ok"><i class="icon-svg-yes fcBlue" aria-hidden="true"></i> ' + PREV_SMSTR_IMPORT_STATUS_TEXT.SUCCESS + '</span>');
            return;
        }

        if(status == "FAIL") {
            $status.html('<span class="state_no"><i class="icon-svg-no fcRed" aria-hidden="true"></i> ' + PREV_SMSTR_IMPORT_STATUS_TEXT.FAIL + '</span>');
            return;
        }

        $status.empty();
    }

    // 이전학기 가져오기 항목을 Ajax로 실행한다.
    function prevSmstrExecuteImport(index) {
        var defer = $.Deferred();
        var param = {
            encParams: PREV_SMSTR_IMPORT_EPARAM,
            importType: PREV_SMSTR_IMPORT_ITEMS[index].importType
        };

        // 가져오기 요청 전 처리중 상태를 먼저 표시한다.
        prevSmstrSetImportStatus(index, "PROCESSING");

        ajaxCall(PREV_SMSTR_IMPORT_URL, param, function(data) {
            if(data.result == 1) {
                prevSmstrSetImportStatus(index, "SUCCESS");
                defer.resolve(true);
            } else {
                prevSmstrSetImportStatus(index, "FAIL");
                defer.resolve(false);
            }
        }, function() {
            prevSmstrSetImportStatus(index, "FAIL");
            defer.resolve(false);
        });

        return defer.promise();
    }

    // 이전학기 가져오기 개별 항목을 확인 후 실행한다.
    function prevSmstrImportItem(index) {
        if(PREV_SMSTR_IMPORT_ENABLED[index] !== "Y") {
            return;
        }

        var label = PREV_SMSTR_IMPORT_ITEMS[index].label;
        // 가져오기를 실행 하시겠습니까?
        UiComm.showMessage(label + " <spring:message code='crs.confirm.insert.common.import' />", "confirm")
            .then(function(confirmed) {
                if(confirmed) {
                    prevSmstrExecuteImport(index);
                }
            });
    }

    // 이전학기 가져오기 가능한 모든 항목을 순차 실행한다.
    function prevSmstrImportAll() {
        // 전체, 가져오기를 실행 하시겠습니까?
        UiComm.showMessage("<spring:message code='crs.label.all' /> <spring:message code='crs.confirm.insert.common.import' />", "confirm")
            .then(function(confirmed) {
                if(!confirmed) {
                    return;
                }

                var allSucceeded = true;
                prevSmstrSetImportStatus("All", "PROCESSING");

                // 가져오기 가능한 항목만 순차 실행하고 전체 결과를 화면 상태로 반영한다.
                var chain = $.Deferred().resolve().promise();
                for(var i = 1; i <= 9; i++) {
                    (function(idx) {
                        chain = chain.then(function() {
                            if(PREV_SMSTR_IMPORT_ENABLED[idx] !== "Y") {
                                return $.Deferred().resolve(true).promise();
                            }
                            return prevSmstrExecuteImport(idx).then(function(succeeded) {
                                if(!succeeded) {
                                    allSucceeded = false;
                                }
                                return succeeded;
                            });
                        });
                    })(i);
                }

                chain.then(function() {
                    prevSmstrSetImportStatus("All", allSucceeded ? "SUCCESS" : "FAIL");
                });
            });
    }

    $(document).ready(function() {
        var hasEnabledItem = false;
        for(var i = 1; i <= 9; i++) {
            if(PREV_SMSTR_IMPORT_ENABLED[i] === "Y") {
                hasEnabledItem = true;
                break;
            }
        }

        if(!hasEnabledItem) {
            $("#prevSmstrImportAllBtn").prop("disabled", true).addClass("disabled");
        }
    });
</script>

<div class="sub-content">
    <c:if test="${hidePrevSmstrImportTitle ne 'Y'}">
        <div class="page-info">
            <h2 class="page-title"><spring:message code="crs.label.pre.smst.import" /></h2><%-- 이전학기 가져오기 --%>
        </div>

        <h4 class="sub-title"><spring:message code="crs.label.pre.smst.import" /></h4><%-- 이전학기 가져오기 --%>
    </c:if>
    <div class="table-wrap">
        <table class="table-type2">
            <colgroup>
                <col style="width:70px">
                <col>
                <col style="width:100px">
                <col style="width:150px">
            </colgroup>
            <thead>
                <tr>
                    <th>No</th>
                    <th><spring:message code="common.label.contents" /></th><%-- 내용 --%>
                    <th><spring:message code="crs.label.process.status" /></th><%-- 처리상태 --%>
                    <th><spring:message code="common.mgr" /></th><%-- 관리 --%>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><spring:message code="crs.label.all" /></td><%-- 전체 --%>
                    <td class="text-left"><spring:message code="crs.label.import.prev.subject.guide1" /></td><%-- 하단 목록의 모든 데이터를 한 과목으로 가져 옵니다. --%>
                    <td id="prevSmstrImportStatusAll"></td>
                    <td>
                        <button type="button" id="prevSmstrImportAllBtn" class="btn type3 w120" onclick="prevSmstrImportAll();"><spring:message code="crs.label.all.import" /></button><%-- 전체 가져오기 --%>
                    </td>
                </tr>
                <tr>
                    <spring:message code="common.label.notice" var="prevMsg1" /><%-- 공지사항 --%>
                    <td>1</td>
                    <td class="text-left"><spring:message code="crs.label.import.prev.subject.guide2" arguments="${prevMsg1}" /></td><%-- 이전학기의 {0} 전체를 가져옵니다. --%>
                    <td id="prevSmstrImportStatus1"></td>
                    <td>
                        <button type="button" class="btn basic w120 <c:if test="${type1 eq 'N'}">disabled</c:if>" onclick="prevSmstrImportItem(1);" <c:if test="${type1 eq 'N'}">disabled="disabled"</c:if>>${prevMsg1}</button>
                    </td>
                </tr>
                <tr>
                    <spring:message code="common.label.pds" var="prevMsg2" /><%-- 강의자료실 --%>
                    <td>2</td>
                    <td class="text-left"><spring:message code="crs.label.import.prev.subject.guide2" arguments="${prevMsg2}" /></td><%-- 이전학기의 {0} 전체를 가져옵니다. --%>
                    <td id="prevSmstrImportStatus2"></td>
                    <td>
                        <button type="button" class="btn basic w120 <c:if test="${type2 eq 'N'}">disabled</c:if>" onclick="prevSmstrImportItem(2);" <c:if test="${type2 eq 'N'}">disabled="disabled"</c:if>>${prevMsg2}</button>
                    </td>
                </tr>
                <tr>
                    <spring:message code="lesson.label.lesson.cnts" var="prevMsg3" /><%-- 학습자료 --%>
                    <td>3</td>
                    <td class="text-left"><spring:message code="crs.label.import.prev.subject.guide2" arguments="${prevMsg3}" /></td><%-- 이전학기의 {0} 전체를 가져옵니다. --%>
                    <td id="prevSmstrImportStatus3"></td>
                    <td>
                        <button type="button" class="btn basic w120 <c:if test="${type3 eq 'N'}">disabled</c:if>" onclick="prevSmstrImportItem(3);" <c:if test="${type3 eq 'N'}">disabled="disabled"</c:if>>${prevMsg3}</button>
                    </td>
                </tr>
                <tr>
                    <spring:message code="common.label.asmnt" var="prevMsg4" /><%-- 과제 --%>
                    <td>4</td>
                    <td class="text-left"><spring:message code="crs.label.import.prev.subject.guide2" arguments="${prevMsg4}" /></td><%-- 이전학기의 {0} 전체를 가져옵니다. --%>
                    <td id="prevSmstrImportStatus4"></td>
                    <td>
                        <button type="button" class="btn basic w120 <c:if test="${type4 eq 'N'}">disabled</c:if>" onclick="prevSmstrImportItem(4);" <c:if test="${type4 eq 'N'}">disabled="disabled"</c:if>>${prevMsg4}</button>
                    </td>
                </tr>
                <tr>
                    <spring:message code="common.label.question" var="prevMsg5" /><%-- 퀴즈 --%>
                    <td>5</td>
                    <td class="text-left"><spring:message code="crs.label.import.prev.subject.guide2" arguments="${prevMsg5}" /></td><%-- 이전학기의 {0} 전체를 가져옵니다. --%>
                    <td id="prevSmstrImportStatus5"></td>
                    <td>
                        <button type="button" class="btn basic w120 <c:if test="${type5 eq 'N'}">disabled</c:if>" onclick="prevSmstrImportItem(5);" <c:if test="${type5 eq 'N'}">disabled="disabled"</c:if>>${prevMsg5}</button>
                    </td>
                </tr>
                <tr>
                    <spring:message code="common.label.resh" var="prevMsg6" /><%-- 설문 --%>
                    <td>6</td>
                    <td class="text-left"><spring:message code="crs.label.import.prev.subject.guide2" arguments="${prevMsg6}" /></td><%-- 이전학기의 {0} 전체를 가져옵니다. --%>
                    <td id="prevSmstrImportStatus6"></td>
                    <td>
                        <button type="button" class="btn basic w120 <c:if test="${type6 eq 'N'}">disabled</c:if>" onclick="prevSmstrImportItem(6);" <c:if test="${type6 eq 'N'}">disabled="disabled"</c:if>>${prevMsg6}</button>
                    </td>
                </tr>
                <tr>
                    <spring:message code="common.label.forum" var="prevMsg7" /><%-- 토론 --%>
                    <td>7</td>
                    <td class="text-left"><spring:message code="crs.label.import.prev.subject.guide2" arguments="${prevMsg7}" /></td><%-- 이전학기의 {0} 전체를 가져옵니다. --%>
                    <td id="prevSmstrImportStatus7"></td>
                    <td>
                        <button type="button" class="btn basic w120 <c:if test="${type7 eq 'N'}">disabled</c:if>" onclick="prevSmstrImportItem(7);" <c:if test="${type7 eq 'N'}">disabled="disabled"</c:if>>${prevMsg7}</button>
                    </td>
                </tr>
                <tr>
                    <spring:message code="common.label.qstn.practice" var="prevMsg8" /><%-- 연습문제 --%>
                    <td>8</td>
                    <td class="text-left"><spring:message code="crs.label.import.prev.subject.guide2" arguments="${prevMsg8}" /></td><%-- 이전학기의 {0} 전체를 가져옵니다. --%>
                    <td id="prevSmstrImportStatus8"></td>
                    <td>
                        <button type="button" class="btn basic w120 <c:if test="${type8 eq 'N'}">disabled</c:if>" onclick="prevSmstrImportItem(8);" <c:if test="${type8 eq 'N'}">disabled="disabled"</c:if>>${prevMsg8}</button>
                    </td>
                </tr>
                <tr>
                    <spring:message code="common.label.qstn.pop" var="prevMsg9" /><%-- 돌발퀴즈 --%>
                    <td>9</td>
                    <td class="text-left"><spring:message code="crs.label.import.prev.subject.guide2" arguments="${prevMsg9}" /></td><%-- 이전학기의 {0} 전체를 가져옵니다. --%>
                    <td id="prevSmstrImportStatus9"></td>
                    <td>
                        <button type="button" class="btn basic w120 <c:if test="${type9 eq 'N'}">disabled</c:if>" onclick="prevSmstrImportItem(9);" <c:if test="${type9 eq 'N'}">disabled="disabled"</c:if>>${prevMsg9}</button>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
