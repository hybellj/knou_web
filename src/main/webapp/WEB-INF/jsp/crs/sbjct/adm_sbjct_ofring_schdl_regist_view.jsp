<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <!-- 관리자 공통 head -->
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>

    <script type="text/javascript">
        var EPARAM = '<c:out value="${encParams}" />';
        var SBJCT_ID = '<c:out value="${sbjctId}" />';
        var SCHDL_EDITABLE_YN = '<c:out value="${schdlEditableYn}" />';
        var SCHDL_EDITABLE = SCHDL_EDITABLE_YN === 'Y';
        var SCHDL_ROW_SEQ = 0;
        $(function() {
            SCHDL_ROW_SEQ = $("#schdlBody .schdl-row").length;
            reindexSchdlRows();
        });

        // 저장 요청 전 날짜 입력값에서 숫자만 추출한다.
        function onlyDigits(value) {
            return (value || "").replace(/[^0-9]/g, "");
        }

        // 날짜 입력값을 YYYYMMDD 형식으로 검증한다.
        function isValidYmd(value) {
            return /^\d{8}$/.test(value || "");
        }

        // 화면 순서 기준으로 주차 번호와 날짜 입력 ID를 재정렬한다.
        function reindexSchdlRows() {
            var $rows = $("#schdlBody .schdl-row");
            $("#schdlBody .schdl-empty-row").remove();

            $rows.each(function(index) {
                var rowIndex = String(index);
                var weekNo = index + 1;
                var $row = $(this);
                var oldIndex = $row.attr("data-row-index");
                var $periodRow = $("#schdlBody .schdl-period-row[data-row-index='" + oldIndex + "']");

                $row.attr("data-row-index", rowIndex);
                $periodRow.attr("data-row-index", rowIndex);
                $row.find("[name=sbjctSchdlWkno]").val(weekNo);
                $row.find("[name=tocSeqno]").val(weekNo);
                $row.find(".schdl-week-no").text(weekNo);

                if(!SCHDL_EDITABLE) {
                    $periodRow.find(".schdl-date").prop("readonly", true)
                        .attr("readonly", "readonly")
                        .attr("aria-readonly", "true");
                }
            });

            if($rows.length == 0) {
                appendEmptySchdlRow();
            }
        }

        // 주차가 없을 때 안내 행을 표시한다.
        function appendEmptySchdlRow() {
            var colspan = SCHDL_EDITABLE ? 4 : 3;
            $("#schdlBody").append('<tr class="schdl-empty-row"><td colspan="' + colspan + '" class="text-center">' + '<spring:message code="crs.sbjct.ofring.alert.schdl.empty"/>' + '</td></tr>'); // 주차 기간 설정 항목이 없습니다.
        }

        // 마지막 위치에 빈 주차 행을 추가한다.
        function addSchdlRow() {
            if(!SCHDL_EDITABLE) {
                return;
            }

            $("#schdlBody .schdl-empty-row").remove();
            var rowKey = "new_" + SCHDL_ROW_SEQ++;
            var $newRows = $(createSchdlRows(rowKey));
            $("#schdlBody").append($newRows);
            reindexSchdlRows();
            initNewSchdlDatepickers($newRows);
        }

        // 새로 추가한 주차 행의 날짜 입력만 datepicker 적용 대상이 되도록 처리한다.
        function initNewSchdlDatepickers($newRows) {
            if(typeof UiDateTimepicker !== "function" || !$newRows || $newRows.length == 0) {
                return;
            }

            var $newDateInputs = $newRows.find(".schdl-date.datepicker");
            if($newDateInputs.length == 0) {
                return;
            }

            var $existingDateInputs = $("#schdlBody .schdl-date.hasDatepicker").not($newDateInputs);
            $existingDateInputs.removeClass("datepicker");
            try {
                UiDateTimepicker();
            } finally {
                $existingDateInputs.addClass("datepicker");
            }
        }

        // 선택한 주차 행을 삭제하고 화면 번호를 다시 정렬한다.
        function deleteSchdlRow(button) {
            if(!SCHDL_EDITABLE) {
                return;
            }

            var $row = $(button).closest(".schdl-row");
            var rowIndex = $row.attr("data-row-index");
            $("#schdlBody .schdl-period-row[data-row-index='" + rowIndex + "']").remove();
            $row.remove();
            reindexSchdlRows();
        }

        // 새 주차의 2행 HTML을 생성한다.
        function createSchdlRows(rowIndex) {
            return ''
                + '<tr class="schdl-row" data-row-index="' + rowIndex + '">'
                + '    <td class="text-center" rowspan="2">'
                + '        <input type="hidden" name="smstrChrtSchdlId" value="" />'
                + '        <input type="hidden" name="sbjctSchdlWkno" value="" />'
                + '        <input type="hidden" name="tocSeqno" value="" />'
                + '        <span class="schdl-week-no"></span>' + '<spring:message code="crs.sbjct.ofring.label.week.suffix"/>' /* 주차 */
                + '    </td>'
                + '    <td colspan="2" class="text-left">'
                + '        <input type="text" name="sbjctSchdlWknonm" class="w100p" style="width:100%;" maxlength="100" required="true" value="" placeholder="' + '<spring:message code="crs.sbjct.ofring.label.schdl.wknonm"/>' /* 주차명 */ + '" />'
                + '    </td>'
                + '    <td class="text-center" rowspan="2">'
                + '        <button type="button" class="btn basic small" onclick="deleteSchdlRow(this);"><i class="xi-close"></i><span class="blind">' + '<spring:message code="button.delete"/>' /* 삭제 */ + '</span></button>'
                + '    </td>'
                + '</tr>'
                + '<tr class="schdl-period-row" data-row-index="' + rowIndex + '">'
                + '    <td class="text-left">'
                + '        <input type="text" id="sbjctSymd_' + rowIndex + '" name="sbjctSymd" class="datepicker schdl-date" toDate="sbjctEymd_' + rowIndex + '" required="true" value="" placeholder="' + '<spring:message code="crs.sbjct.ofring.placeholder.start.day"/>' /* 시작일 */ + '" />'
                + '        ~'
                + '        <input type="text" id="sbjctEymd_' + rowIndex + '" name="sbjctEymd" class="datepicker schdl-date" fromDate="sbjctSymd_' + rowIndex + '" required="true" value="" placeholder="' + '<spring:message code="crs.sbjct.ofring.placeholder.end.day"/>' /* 종료일 */ + '" />'
                + '    </td>'
                + '    <td class="text-left">'
                + '        <input type="text" id="sbjctAtndcRcgSymd_' + rowIndex + '" name="sbjctAtndcRcgSymd" class="datepicker schdl-date" toDate="sbjctAtndcRcgEymd_' + rowIndex + '" required="true" value="" placeholder="' + '<spring:message code="crs.sbjct.ofring.placeholder.start.day"/>' /* 시작일 */ + '" />'
                + '        ~'
                + '        <input type="text" id="sbjctAtndcRcgEymd_' + rowIndex + '" name="sbjctAtndcRcgEymd" class="datepicker schdl-date" fromDate="sbjctAtndcRcgSymd_' + rowIndex + '" required="true" value="" placeholder="' + '<spring:message code="crs.sbjct.ofring.placeholder.end.day"/>' /* 종료일 */ + '" />'
                + '    </td>'
                + '</tr>';
        }

        // 과목개설 정보등록 화면으로 이동한다.
        function viewSbjctOfringRegist() {
            location.href = '/crs/sbjctOfring/admSbjctOfringRegistView.do?sbjctId=' + encodeURIComponent(SBJCT_ID || '') + '&encParams=' + EPARAM;
        }

        // 과목개설 주차 기간 설정 화면으로 이동한다.
        function viewSbjctOfringSchdlRegist() {
            location.href = '/crs/sbjctOfring/admSbjctOfringSchdlRegistView.do?sbjctId=' + encodeURIComponent(SBJCT_ID || '') + '&encParams=' + EPARAM;
        }

        // 과목관리자 등록 화면으로 이동한다.
        function viewSbjctOfringAdmRegist() {
            location.href = '/crs/sbjctOfring/admSbjctOfringAdmRegistView.do?sbjctId=' + encodeURIComponent(SBJCT_ID || '') + '&encParams=' + EPARAM;
        }

        // 수강생 등록 화면으로 이동한다.
        function viewSbjctOfringStdntRegist() {
            location.href = '/crs/sbjctOfring/admSbjctOfringStdntRegistView.do?sbjctId=' + encodeURIComponent(SBJCT_ID || '') + '&encParams=' + EPARAM;
        }

        // 다음 단계로 이동한다.
        function onNext() {
            viewSbjctOfringAdmRegist();
        }

        // 과목개설 목록으로 이동한다.
        function viewSbjctOfringList() {
            location.href = '/crs/sbjctOfring/admSbjctOfringListView.do?encParams=' + EPARAM;
        }

        // 과목개설 단계 화면으로 이동한다.
        function moveOfringStep(stepNo) {
            if(stepNo == 1) {
                viewSbjctOfringRegist();
            } else if(stepNo == 2) {
                viewSbjctOfringSchdlRegist();
            } else if(stepNo == 3) {
                viewSbjctOfringAdmRegist();
            } else if(stepNo == 4) {
                viewSbjctOfringStdntRegist();
            }
        }

        // 과목개설 주차 기간 설정 저장 전 화면 필수값을 검증한다.
        function onSave() {
            if(!SCHDL_EDITABLE) {
                UiComm.showMessage("<spring:message code='crs.sbjct.ofring.alert.schdl.edit.before.plandoc'/>", "error"); // 강의계획서등록기간 전까지만 주차 일정을 수정할 수 있습니다.
                return;
            }

            reindexSchdlRows();
            UiValidator("sbjctOfringSchdlRegistForm").then(function(result) {
                if(!result) {
                    return;
                }
                saveSbjctOfringSchdl();
            });
        }

        // 과목개설 주차 기간 설정을 저장한다.
        function saveSbjctOfringSchdl() {
            reindexSchdlRows();
            var params = {
                sbjctId: SBJCT_ID
            };
            var schdlCnt = 0;
            var valid = true;

            $("#schdlBody .schdl-row").each(function() {
                if(!valid) {
                    return false;
                }

                var $row = $(this);
                var rowIndex = $row.attr("data-row-index");
                var $periodRow = $("#schdlBody .schdl-period-row[data-row-index='" + rowIndex + "']");
                var sbjctSchdlWknonm = $.trim($row.find("[name=sbjctSchdlWknonm]").val());
                var sbjctSymd = onlyDigits($periodRow.find("[name=sbjctSymd]").val());
                var sbjctEymd = onlyDigits($periodRow.find("[name=sbjctEymd]").val());
                var sbjctAtndcRcgSymd = onlyDigits($periodRow.find("[name=sbjctAtndcRcgSymd]").val());
                var sbjctAtndcRcgEymd = onlyDigits($periodRow.find("[name=sbjctAtndcRcgEymd]").val());

                if(!sbjctSchdlWknonm) {
                    UiComm.showMessage("<spring:message code='crs.sbjct.ofring.alert.input.schdl.wknonm'/>", "error"); // 주차명을 입력해 주세요.
                    $row.find("[name=sbjctSchdlWknonm]").focus();
                    valid = false;
                    return false;
                }
                if(!isValidYmd(sbjctSymd) || !isValidYmd(sbjctEymd)) {
                    UiComm.showMessage("<spring:message code='crs.sbjct.ofring.alert.input.schdl.period'/>", "error"); // 학습 기간의 시작일과 종료일을 입력해 주세요.
                    $periodRow.find("[name=sbjctSymd]").focus();
                    valid = false;
                    return false;
                }
                if(sbjctSymd > sbjctEymd) {
                    UiComm.showMessage("<spring:message code='crs.sbjct.ofring.alert.invalid.date.order'/>", "error"); // 시작일은 종료일보다 늦을 수 없습니다.
                    $periodRow.find("[name=sbjctSymd]").focus();
                    valid = false;
                    return false;
                }
                if(!isValidYmd(sbjctAtndcRcgSymd) || !isValidYmd(sbjctAtndcRcgEymd)) {
                    UiComm.showMessage("<spring:message code='crs.sbjct.ofring.alert.input.atndc.rcg.period'/>", "error"); // 출석 인정 기간의 시작일과 종료일을 입력해 주세요.
                    $periodRow.find("[name=sbjctAtndcRcgSymd]").focus();
                    valid = false;
                    return false;
                }
                if(sbjctAtndcRcgSymd > sbjctAtndcRcgEymd) {
                    UiComm.showMessage("<spring:message code='crs.sbjct.ofring.alert.invalid.date.order'/>", "error"); // 시작일은 종료일보다 늦을 수 없습니다.
                    $periodRow.find("[name=sbjctAtndcRcgSymd]").focus();
                    valid = false;
                    return false;
                }

                params["schdlList[" + schdlCnt + "].smstrChrtSchdlId"] = $row.find("[name=smstrChrtSchdlId]").val();
                params["schdlList[" + schdlCnt + "].sbjctSchdlWkno"] = $row.find("[name=sbjctSchdlWkno]").val();
                params["schdlList[" + schdlCnt + "].tocSeqno"] = $row.find("[name=tocSeqno]").val();
                params["schdlList[" + schdlCnt + "].sbjctSchdlWknonm"] = sbjctSchdlWknonm;
                params["schdlList[" + schdlCnt + "].sbjctSymd"] = sbjctSymd;
                params["schdlList[" + schdlCnt + "].sbjctEymd"] = sbjctEymd;
                params["schdlList[" + schdlCnt + "].sbjctAtndcRcgSymd"] = sbjctAtndcRcgSymd;
                params["schdlList[" + schdlCnt + "].sbjctAtndcRcgEymd"] = sbjctAtndcRcgEymd;
                schdlCnt++;
            });

            if(!valid) {
                return;
            }
            if(schdlCnt == 0) {
                UiComm.showMessage("<spring:message code='crs.sbjct.ofring.alert.schdl.empty'/>", "error"); // 주차 기간 설정 항목이 없습니다.
                return;
            }

            ajaxCall('/crs/sbjctOfring/admSbjctOfringSchdlRegist.do', params,
                function(res) {
                    if(res.result > 0) {
                        UiComm.showMessage(res.message || "<spring:message code='success.common.save'/>", "success") // 정상적으로 저장되었습니다.
                            .then(function() {
                                viewSbjctOfringAdmRegist();
                            });
                    } else {
                        UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error"); // 에러가 발생했습니다!
                    }
                },
                function() {
                    UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error"); // 에러가 발생했습니다!
                },
                true
            );
        }
    </script>
</head>

<body class="admin">
<div id="wrap" class="main">

    <!-- 공통 메뉴 이동(moveMenu)용 폼 -->
    <form id="moveForm" method="post"></form>

    <%-- 관리자 상단 헤더 --%>
    <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>

    <main class="common">
        <%-- 관리자 좌측 메뉴(aside) --%>
        <%@ include file="/WEB-INF/jsp/common_new/admin_aside.jsp" %>

        <div id="content" class="content-wrap common">
            <div class="admin_sub">
                <div class="cont">

                    <!-- 페이지 타이틀 -->
                    <div class="page-info">
                        <h2 class="page-title">${uiex:getCurMenunm()}</h2> <%-- 현재 메뉴명 --%>
                        <uiex:navibar type="admin"/><%-- 네비게이션바 --%>
                    </div>

                    <!-- 과목 개설 과정 -->
                    <div class="step-process-wrap mb40">
                        <div class="board_card_list">
                            <div class="card_item">
                                <a href="javascript:void(0);" onclick="moveOfringStep(1); return false;">
                                    <span class="step-num">1</span>
                                    <spring:message code="crs.sbjct.ofring.step.info.regist"/><%--개설과목 정보등록--%>
                                </a>
                            </div>
                            <div class="card_item active">
                                <a href="javascript:void(0);" onclick="moveOfringStep(2); return false;">
                                    <span class="step-num">2</span>
                                    <spring:message code="crs.sbjct.ofring.step.week.setting"/><%--주차 기간 설정--%>
                                </a>
                            </div>
                            <div class="card_item">
                                <a href="javascript:void(0);" onclick="moveOfringStep(3); return false;">
                                    <span class="step-num">3</span>
                                    <spring:message code="crs.sbjct.ofring.step.manager.regist"/><%--과목 관리자 등록--%>
                                </a>
                            </div>
                            <div class="card_item">
                                <a href="javascript:void(0);" onclick="moveOfringStep(4); return false;">
                                    <span class="step-num">4</span>
                                    <spring:message code="crs.sbjct.ofring.step.learner.regist"/><%--수강생 등록--%>
                                </a>
                            </div>
                        </div>
                    </div>

                    <form id="sbjctOfringSchdlRegistForm" onsubmit="return false;" autocomplete="off">
                        <input type="hidden" id="sbjctId" name="sbjctId" value="<c:out value='${sbjctId}' />" />

                        <div class="box">
                            <div class="board_top">
                                <h3 class="board-title"><spring:message code="crs.course.info"/><%--개설 과목 정보--%></h3>
                            </div>

                            <div class="table-wrap mb20">
                                <table class="table-type5">
                                    <colgroup>
                                        <col style="width: 160px;">
                                        <col>
                                        <col style="width: 160px;">
                                        <col>
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th><spring:message code="crs.label.crecrs"/><%--과목--%></th>
                                        <td><c:out value="${sbjctVO.sbjctnm}" /></td>
                                        <th><spring:message code="crs.label.subject.code"/><%--과목코드--%></th>
                                        <td><c:out value="${sbjctVO.sbjctCd}" /></td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>

                            <div class="table-wrap">
                                <table class="table-type2">
                                    <colgroup>
                                        <col style="width: 90px;">
                                        <col>
                                        <col>
                                        <c:if test="${schdlEditableYn eq 'Y'}">
                                            <col style="width: 80px;">
                                        </c:if>
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th rowspan="2"><spring:message code="crs.sbjct.ofring.label.week"/><%--주차--%></th>
                                        <th colspan="2" class="req"><spring:message code="crs.sbjct.ofring.label.schdl.wknonm"/><%--주차명--%></th>
                                        <c:if test="${schdlEditableYn eq 'Y'}">
                                            <th rowspan="2"><spring:message code="button.delete"/><%--삭제--%></th>
                                        </c:if>
                                    </tr>
                                    <tr>
                                        <th class="req"><spring:message code="crs.sbjct.ofring.label.sbjct.period"/><%--학습 기간--%></th>
                                        <th class="req"><spring:message code="crs.sbjct.ofring.label.atndc.rcg.period"/><%--출석 인정 기간--%></th>
                                    </tr>
                                    </thead>
                                    <tbody id="schdlBody">
                                    <c:choose>
                                        <c:when test="${empty schdlList}">
                                            <tr class="schdl-empty-row">
                                                <td colspan="${schdlEditableYn eq 'Y' ? 4 : 3}" class="text-center"><spring:message code="crs.sbjct.ofring.alert.schdl.empty"/><%--주차 기간 설정 항목이 없습니다.--%></td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="schdl" items="${schdlList}" varStatus="status">
                                                <c:set var="sbjctSymdText" value="${schdl.sbjctSymd}" />
                                                <c:set var="sbjctEymdText" value="${schdl.sbjctEymd}" />
                                                <c:set var="sbjctAtndcRcgSymdText" value="${schdl.sbjctAtndcRcgSymd}" />
                                                <c:set var="sbjctAtndcRcgEymdText" value="${schdl.sbjctAtndcRcgEymd}" />
                                                <c:if test="${fn:length(schdl.sbjctSymd) eq 8}">
                                                    <c:set var="sbjctSymdText" value="${fn:substring(schdl.sbjctSymd, 0, 4)}-${fn:substring(schdl.sbjctSymd, 4, 6)}-${fn:substring(schdl.sbjctSymd, 6, 8)}" />
                                                </c:if>
                                                <c:if test="${fn:length(schdl.sbjctEymd) eq 8}">
                                                    <c:set var="sbjctEymdText" value="${fn:substring(schdl.sbjctEymd, 0, 4)}-${fn:substring(schdl.sbjctEymd, 4, 6)}-${fn:substring(schdl.sbjctEymd, 6, 8)}" />
                                                </c:if>
                                                <c:if test="${fn:length(schdl.sbjctAtndcRcgSymd) eq 8}">
                                                    <c:set var="sbjctAtndcRcgSymdText" value="${fn:substring(schdl.sbjctAtndcRcgSymd, 0, 4)}-${fn:substring(schdl.sbjctAtndcRcgSymd, 4, 6)}-${fn:substring(schdl.sbjctAtndcRcgSymd, 6, 8)}" />
                                                </c:if>
                                                <c:if test="${fn:length(schdl.sbjctAtndcRcgEymd) eq 8}">
                                                    <c:set var="sbjctAtndcRcgEymdText" value="${fn:substring(schdl.sbjctAtndcRcgEymd, 0, 4)}-${fn:substring(schdl.sbjctAtndcRcgEymd, 4, 6)}-${fn:substring(schdl.sbjctAtndcRcgEymd, 6, 8)}" />
                                                </c:if>
                                                <tr class="schdl-row" data-row-index="<c:out value='${status.index}' />">
                                                    <td class="text-center" rowspan="2">
                                                        <input type="hidden" name="smstrChrtSchdlId" value="<c:out value='${schdl.smstrChrtSchdlId}' />" />
                                                        <input type="hidden" name="sbjctSchdlWkno" value="<c:out value='${schdl.sbjctSchdlWkno}' />" />
                                                        <input type="hidden" name="tocSeqno" value="<c:out value='${schdl.tocSeqno}' />" />
                                                        <span class="schdl-week-no"><c:out value="${schdl.sbjctSchdlWkno}" /></span><spring:message code="crs.sbjct.ofring.label.week.suffix"/><%--주차--%>
                                                    </td>
                                                    <td colspan="2" class="text-left">
                                                        <input type="text" name="sbjctSchdlWknonm" class="w100p" style="width:100%;" maxlength="100" required="true" value="<c:out value='${schdl.sbjctSchdlWknonm}' />" placeholder="<spring:message code='crs.sbjct.ofring.label.schdl.wknonm'/><%--주차명--%>" <c:if test="${schdlEditableYn ne 'Y'}">readonly="readonly"</c:if> />
                                                    </td>
                                                    <c:if test="${schdlEditableYn eq 'Y'}">
                                                        <td class="text-center" rowspan="2">
                                                            <button type="button" class="btn basic small" onclick="deleteSchdlRow(this);"><i class="xi-close"></i><span class="blind"><spring:message code="button.delete"/><%--삭제--%></span></button>
                                                        </td>
                                                    </c:if>
                                                </tr>
                                                <tr class="schdl-period-row" data-row-index="<c:out value='${status.index}' />">
                                                    <td class="text-left">
                                                        <input type="text" id="sbjctSymd_${status.index}" name="sbjctSymd"
                                                               class="${schdlEditableYn eq 'Y' ? 'datepicker ' : ''}schdl-date" toDate="sbjctEymd_${status.index}"
                                                               required="true"
                                                               value="<c:out value='${sbjctSymdText}' />"
                                                               placeholder="<spring:message code='crs.sbjct.ofring.placeholder.start.day'/><%--시작일--%>"
                                                               <c:if test="${schdlEditableYn ne 'Y'}">readonly="readonly" aria-readonly="true"</c:if> />
                                                        ~
                                                        <input type="text" id="sbjctEymd_${status.index}" name="sbjctEymd"
                                                               class="${schdlEditableYn eq 'Y' ? 'datepicker ' : ''}schdl-date" fromDate="sbjctSymd_${status.index}"
                                                               required="true" value="<c:out value='${sbjctEymdText}' />"
                                                               placeholder="<spring:message code='crs.sbjct.ofring.placeholder.end.day'/><%--종료일--%>"
                                                               <c:if test="${schdlEditableYn ne 'Y'}">readonly="readonly" aria-readonly="true"</c:if> />
                                                    </td>
                                                    <td class="text-left">
                                                        <input type="text" id="sbjctAtndcRcgSymd_${status.index}" name="sbjctAtndcRcgSymd"
                                                               class="${schdlEditableYn eq 'Y' ? 'datepicker ' : ''}schdl-date" toDate="sbjctAtndcRcgEymd_${status.index}"
                                                               required="true" value="<c:out value='${sbjctAtndcRcgSymdText}' />"
                                                               placeholder="<spring:message code='crs.sbjct.ofring.placeholder.start.day'/><%--시작일--%>"
                                                               <c:if test="${schdlEditableYn ne 'Y'}">readonly="readonly" aria-readonly="true"</c:if> />
                                                        ~
                                                        <input type="text" id="sbjctAtndcRcgEymd_${status.index}" name="sbjctAtndcRcgEymd"
                                                               class="${schdlEditableYn eq 'Y' ? 'datepicker ' : ''}schdl-date" fromDate="sbjctAtndcRcgSymd_${status.index}"
                                                               required="true" value="<c:out value='${sbjctAtndcRcgEymdText}' />"
                                                               placeholder="<spring:message code='crs.sbjct.ofring.placeholder.end.day'/><%--종료일--%>"
                                                               <c:if test="${schdlEditableYn ne 'Y'}">readonly="readonly" aria-readonly="true"</c:if> />
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                    </tbody>
                                </table>
                                <c:if test="${schdlEditableYn eq 'Y'}">
                                    <div class="btns">
                                        <button type="button" class="btn type2" onclick="addSchdlRow();"><spring:message code="crs.sbjct.ofring.button.add.week"/><%--주차 추가--%></button>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </form>

                    <div class="btns">
                        <button type="button" class="btn basic" onclick="viewSbjctOfringRegist();"><spring:message code="button.previous"/><%--이전--%></button>
                        <button type="button" class="btn basic" onclick="onNext();"><spring:message code="button.next"/><%--다음--%></button>
                        <c:if test="${schdlEditableYn eq 'Y'}">
                            <button type="button" class="btn type1" onclick="onSave();"><spring:message code="button.save"/><%--저장--%></button>
                        </c:if>
                        <button type="button" class="btn type2" onclick="viewSbjctOfringList();"><spring:message code="button.list"/><%--목록--%></button>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
