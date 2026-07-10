<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/crs/common/crs_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <!-- 관리자 공통 head -->
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="editor"/>
    </jsp:include>

    <script type="text/javascript">
        var EPARAM			= '<c:out value="${encParams}" />';
        var ORG_ID          = '<c:out value="${orgId}" />';
        var FIXED_ORG_YN    = '<c:out value="${fixedOrgYn}" />';
        var MODE            = '<c:out value="${mode}" />';
        var SBJCT_TMPLT_ID  = '<c:out value="${sbjctTmpltVO.sbjctTmpltId}" />';
        var SMSTR_CHRT_ID   = '<c:out value="${sbjctTmpltVO.smstrChrtId}" />';
        var SBJCT_TYCD      = '<c:out value="${sbjctTmpltVO.sbjctTycd}" />';
        var LCTR_GBNCD      = '<c:out value="${sbjctTmpltVO.lctrGbncd}" />';
        var USEYN           = '<c:out value="${sbjctTmpltVO.useyn}" />';
        var SMSTR_CHRT_LIST = [];
        var ORG_SELECT_TEXT = '<spring:message code="common.label.org"/> <spring:message code="sys.button.select"/>'; // 기관 선택
        var SMSTR_CHRT_SELECT_TEXT = '<spring:message code="common.term.cohort.name"/> <spring:message code="sys.button.select"/>'; // 학기/기수 명 선택
        var YEAR_SELECT_TEXT = '<spring:message code="std.label.year"/> <spring:message code="sys.button.select"/>'; // 년도 선택
        var TERM_SELECT_TEXT = '<spring:message code="common.term.cohort"/> <spring:message code="sys.button.select"/>'; // 학기/기수 선택

        $(document).ready(function() {
            $("#selectOrg").val(ORG_ID);
            if(FIXED_ORG_YN == "Y") {
                $("#selectOrg").prop("disabled", true);
            }
            refreshChosen($("#selectOrg"));
            fetchSmstrChrtList();

            $("#selectOrg").on("change", function() {
                unlockSbjctTmpltDupCheckedFields();
                SMSTR_CHRT_ID = "";
                fetchSmstrChrtList();
            });

            $("#sel_term_type").on("change", function() {
                setSelectedSmstrChrt();
            });

            $("#sbjctnm").on("input", function() {
                unlockSbjctTmpltDupField($("#sbjctnm"), $("#btnSbjctNameDup"));
            });

            $("#sbjctCd").on("input", function() {
                var value = $(this).val();
                var cleanValue = value.replace(/[^A-Za-z0-9]/g, "");
                if(value != cleanValue) {
                    $(this).val(cleanValue);
                }
                unlockSbjctTmpltDupField($("#sbjctCd"), $("#btnSbjctCodeDup"));
            });

            applyEditValues();
        });

        // 저장
        function onSave() {
            syncSbjctTmpltForm();
            UiValidator("sbjctWriteForm").then(function(result) {
                if(result) {
                    doSaveSbjctTmplt();
                }
            });
        }

        // 과목 저장 Ajax를 수행한다.
        function doSaveSbjctTmplt() {
            var registUrl = '<c:url value="/crs/sbjctTmplt/admSbjctTmpltRegist.do" />';
            var modifyUrl = '<c:url value="/crs/sbjctTmplt/admSbjctTmpltModify.do" />';
            var url = MODE == "E" ? modifyUrl : registUrl;

            $.ajax({
                url: url,
                type: "POST",
                data: $("#sbjctWriteForm").serialize(),
                beforeSend: function() {
                    UiComm.showLoading(true);
                }
            }).done(function(res) {
                UiComm.showLoading(false);
                if(res.result > 0) {
                    UiComm.showMessage("<spring:message code='success.common.save' />", "success") /* 정상적으로 저장되었습니다. */
                        .then(function() {
                            viewSbjctTmpltList();
                        });
                } else {
                    unlockSbjctTmpltDupCheckedFields();
                    UiComm.showMessage(crsResultMessage(res, "<spring:message code='fail.common.msg'/>"), "error"); // 에러가 발생했습니다!
                }
            }).fail(function(xhr) {
                UiComm.showLoading(false);
                unlockSbjctTmpltDupCheckedFields();
                UiComm.showMessage(crsResultMessage(xhr.responseJSON || {}, "<spring:message code='fail.common.msg'/>"), "error"); // 에러가 발생했습니다!
            });
        }

        // disabled select 값을 hidden 필드로 동기화한다.
        function syncSbjctTmpltForm() {
            var $selectedOption = $("#sel_term_type option:selected");
            $("#orgId").val($("#selectOrg").val());
            $("#smstrChrtId").val($selectedOption.attr("data-smstr-chrt-id") || "");
            $("#sbjctYr").val($selectedOption.attr("data-dgrs-yr") || "");
            $("#sbjctSmstr").val($selectedOption.attr("data-dgrs-smstr-chrt") || "");
            applyFixedSbjctTycd();
            if(editor && $.isFunction(editor.getPublishingHtml)) {
                $("#sbjctExpln").val(editor.getPublishingHtml());
            }
        }

        // 목록이동
        function viewSbjctTmpltList() {
            location.href = '/crs/sbjctTmplt/admSbjctTmpltListView.do?encParams=' + EPARAM;
        }

        // 선택된 기관의 학기/기수 목록을 조회한다.
        function fetchSmstrChrtList() {
            var orgId = $("#selectOrg").val();

            SMSTR_CHRT_LIST = [];
            clearSmstrChrtSelects();

            if(!orgId) {
                return;
            }

            $.ajax({
                url: "/common/admYrSmstrSelect.do",
                data: {
                    orgId: orgId
                },
                success: function(res) {
                    if(res.result > 0) {
                        SMSTR_CHRT_LIST = res.returnList || [];
                    }
                    renderSmstrChrtTypeOptions();
                },
                error: function(xhr) {
                    console.log(xhr);
                }
            });
        }

        // 조회된 학기/기수 목록으로 학기유형 선택 박스를 구성한다.
        function renderSmstrChrtTypeOptions() {
            var html = "";
            var optionCount = 0;

            SMSTR_CHRT_LIST.forEach(function(v) {
                var smstrChrtnm = getSmstrChrtnm(v);
                if(!smstrChrtnm || !getDgrsYr(v) || !getDgrsSmstrChrt(v)) {
                    return;
                }

                html += '<option value="' + escapeHtml(v.smstrChrtId || '') + '"';
                html += ' data-smstr-chrt-id="' + escapeHtml(v.smstrChrtId) + '"';
                html += ' data-dgrs-yr="' + escapeHtml(getDgrsYr(v)) + '"';
                html += ' data-dgrs-smstr-chrt="' + escapeHtml(getDgrsSmstrChrt(v)) + '"';
                html += ' data-yr-smstrnm="' + escapeHtml(getYrSmstrName(v)) + '"';
                html += ' data-smstr-chrt-gbncd="' + escapeHtml(v.smstrChrtGbncd || '') + '">';
                html += escapeHtml(smstrChrtnm);
                html += '</option>';
                optionCount++;
            });

            $("#sel_term_type").html(html);
            if(optionCount > 0) {
                var selectedIndex = 0;
                if(SMSTR_CHRT_ID) {
                    $("#sel_term_type option").each(function(index) {
                        if($(this).attr("data-smstr-chrt-id") == SMSTR_CHRT_ID) {
                            selectedIndex = index;
                        }
                    });
                }
                $("#sel_term_type").prop("selectedIndex", selectedIndex);
                refreshChosen($("#sel_term_type"));
                setSelectedSmstrChrt();
            } else {
                clearSmstrChrtSelects();
            }
        }

        // 학기기수 구분값에 맞는 과목분류 고정 코드를 반환한다.
        function getFixedSbjctTycdBySmstrChrtGbncd(smstrChrtGbncd) {
            return smstrChrtGbncd == "CHRT" ? "CHRT_SYSTEM" : "SMSTR_SYSTEM";
        }

        // 과목분류는 학기기수 구분값 기준으로 고정하고 hidden 전송값만 사용한다.
        function applyFixedSbjctTycd() {
            var $selectedOption = $("#sel_term_type option:selected");
            var smstrChrtId = $selectedOption.attr("data-smstr-chrt-id");
            var fixedSbjctTycd = smstrChrtId ? getFixedSbjctTycdBySmstrChrtGbncd($selectedOption.attr("data-smstr-chrt-gbncd")) : "";

            $("#sbjctTycd").val(fixedSbjctTycd);
            $("input[name=sbjctTycdView]").prop("disabled", true).prop("checked", false);
            if(fixedSbjctTycd) {
                $("input[name=sbjctTycdView][value='" + escapeSelectorValue(fixedSbjctTycd) + "']").prop("checked", true);
            }
        }

        // 선택된 학기유형의 년도와 학기/기수 값을 자동으로 세팅한다.
        function setSelectedSmstrChrt() {
            var $selectedOption = $("#sel_term_type option:selected");
            var $selYrSmstr = $("#sel_yr_smstr");
            var smstrChrtId = $selectedOption.attr("data-smstr-chrt-id");
            var dgrsYr = $selectedOption.attr("data-dgrs-yr");
            var dgrsSmstrChrt = $selectedOption.attr("data-dgrs-smstr-chrt");
            var yrSmstrnm = $selectedOption.attr("data-yr-smstrnm") || "";

            if(!dgrsYr || !dgrsSmstrChrt) {
                $("#smstrChrtId").val("");
                $("#sbjctYr").val("");
                $("#sbjctSmstr").val("");
                applyFixedSbjctTycd();
                $selYrSmstr.html("");
                $selYrSmstr.prop("disabled", true);
                refreshChosen($selYrSmstr);
                return;
            }

            $("#smstrChrtId").val(smstrChrtId || "");
            $("#sbjctYr").val(dgrsYr);
            $("#sbjctSmstr").val(dgrsSmstrChrt);
            applyFixedSbjctTycd();
            $selYrSmstr.html('<option value="' + escapeHtml(smstrChrtId || '') + '">' + escapeHtml(yrSmstrnm) + '</option>');
            $selYrSmstr.val(smstrChrtId || "");
            $selYrSmstr.prop("disabled", true);
            refreshChosen($selYrSmstr);
        }

        // 학기유형, 년도, 학기/기수 선택 박스를 초기화한다.
        function clearSmstrChrtSelects() {
            $("#sel_term_type").html(buildDefaultOption(SMSTR_CHRT_SELECT_TEXT));
            $("#sel_yr_smstr").html("");
            $("#smstrChrtId").val("");
            $("#sbjctYr").val("");
            $("#sbjctSmstr").val("");
            $("#sbjctTycd").val("");
            $("input[name=sbjctTycdView]").prop("disabled", true).prop("checked", false);
            $("#sel_yr_smstr").prop("disabled", true);
            refreshChosen($("#sel_term_type"));
            refreshChosen($("#sel_yr_smstr"));
        }

        // 동적으로 변경된 select 값을 chosen UI에 반영한다.
        function refreshChosen($select) {
            $select.trigger("chosen:updated");
        }

        // 선택 박스의 기본 안내 옵션을 생성한다.
        function buildDefaultOption(text) {
            return '<option value="">' + escapeHtml(text) + '</option>';
        }

        // 과목명 중복체크를 요청한다.
        function checkSbjctTmpltNameDup() {
            checkSbjctTmpltDup("NAME", $("#sbjctnm"), $("#btnSbjctNameDup"), '<spring:message code="crs.sbjct.alert.input.name"/>'); // 과목명을 입력해 주세요.
        }

        // 과목코드 중복체크를 요청한다.
        function checkSbjctTmpltCodeDup() {
            var sbjctCd = $.trim($("#sbjctCd").val());
            if(sbjctCd && !/^[A-Za-z0-9]+$/.test(sbjctCd)) {
                CrsMessage.show('<spring:message code="crs.sbjct.alert.input.code.format"/>', "warning"); // 과목코드는 영문과 숫자만 입력해 주세요.
                $("#sbjctCd").focus();
                return;
            }
            checkSbjctTmpltDup("CODE", $("#sbjctCd"), $("#btnSbjctCodeDup"), '<spring:message code="crs.sbjct.alert.input.code"/>'); // 과목코드를 입력해 주세요.
        }

        // 과목명/과목코드 중복체크 공통 Ajax 처리를 수행한다.
        function checkSbjctTmpltDup(checkType, $input, $button, emptyMessage) {
            var value = $.trim($input.val());
            var orgId = $("#selectOrg").val();
            var smstrChrtId = $("#smstrChrtId").val();

            if(!orgId) {
                CrsMessage.show('<spring:message code="crs.sbjct.alert.select.org"/>', "warning"); // 기관을 선택해 주세요.
                return;
            }

            if(!value) {
                CrsMessage.show(emptyMessage, "warning");
                $input.focus();
                return;
            }
            if(!smstrChrtId) {
                CrsMessage.show('<spring:message code="crs.sbjct.alert.select.smstr.chrt"/>', "warning"); // 학기/기수 명을 선택해 주세요.
                return;
            }
            var params = {
                orgId: orgId,
                smstrChrtId: smstrChrtId,
                sbjctTmpltId: SBJCT_TMPLT_ID,
                checkType: checkType
            };
            if(checkType == "NAME") {
                params.sbjctnm = value;
            } else {
                params.sbjctCd = value;
            }

            $.ajax({
                url: "/crs/sbjctTmplt/admSbjctTmpltDupCheck.do",
                data: params,
                success: function(res) {
                    if(res.result > 0) {
                        lockSbjctTmpltDupField($input, $button);
                        CrsMessage.show(crsResultMessage(res, '<spring:message code="crs.sbjct.alert.dup.available"/>'), "success"); // 사용 가능한 값입니다.
                    } else {
                        unlockSbjctTmpltDupField($input, $button);
                        CrsMessage.show(crsResultMessage(res, '<spring:message code="crs.sbjct.alert.dup.fail"/>'), "error"); // 중복체크 중 오류가 발생했습니다.
                    }
                },
                error: function(xhr) {
                    unlockSbjctTmpltDupField($input, $button);
                    CrsMessage.show(crsResultMessage(xhr.responseJSON || {}, '<spring:message code="crs.sbjct.alert.dup.fail"/>'), "error"); // 중복체크 중 오류가 발생했습니다.
                }
            });
        }

        // 중복체크가 완료된 입력 항목을 수정하지 못하도록 잠근다.
        function lockSbjctTmpltDupField($input, $button) {
            $input.prop("readonly", true);
            $button.prop("disabled", true);
        }

        // 중복체크 잠금 상태를 해제한다.
        function unlockSbjctTmpltDupField($input, $button) {
            $input.prop("readonly", false);
            $button.prop("disabled", false);
        }

        // 기관 변경 시 과목명/과목코드 중복체크 잠금을 모두 해제한다.
        function unlockSbjctTmpltDupCheckedFields() {
            unlockSbjctTmpltDupField($("#sbjctnm"), $("#btnSbjctNameDup"));
            unlockSbjctTmpltDupField($("#sbjctCd"), $("#btnSbjctCodeDup"));
        }

        // 수정 화면에 저장된 radio 값을 반영한다.
        function applyEditValues() {
            if(SBJCT_TYCD) {
                $("input[name=sbjctTycdView]").filter(function() {
                    return $(this).val() == SBJCT_TYCD;
                }).prop("checked", true);
            }
            if(LCTR_GBNCD) {
                $("input[name=lctrGbncd]").filter(function() {
                    return $(this).val() == LCTR_GBNCD;
                }).prop("checked", true);
            }
            if(USEYN) {
                $("input[name=useyn]").filter(function() {
                    return $(this).val() == USEYN;
                }).prop("checked", true);
            }
        }

        // 학기/기수 응답 객체에서 학기유형 표시명을 가져온다.
        function getSmstrChrtnm(item) {
            return item.smstrChrtnm || item.smstrChrtNm || '';
        }

        // 학기/기수 응답 객체에서 년도 값을 가져온다.
        function getDgrsYr(item) {
            return item.yr || item.dgrsYr || '';
        }

        // 학기/기수 응답 객체에서 학기/기수 값을 가져온다.
        function getDgrsSmstrChrt(item) {
            return item.smstr || item.dgrsSmstrChrt || '';
        }

        // 학기/기수 응답 객체에서 년도/학기(기수) 표시명을 가져온다.
        function getYrSmstrName(item) {
            return item.yrSmstrnm || item.yrSmstrNm || '';
        }

        // radio value 선택자에 사용할 문자열을 이스케이프한다.
        function escapeSelectorValue(value) {
            return String(value || '').replace(/\\/g, '\\\\').replace(/'/g, "\\'");
        }

        // 동적 option 생성 시 HTML 특수문자를 이스케이프한다.
        function escapeHtml(value) {
            return String(value || '')
                .replace(/&/g, '&amp;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#39;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;');
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
                <div class="sub-content">

                    <!-- 페이지 타이틀 -->
                    <div class="page-info">
                        <h2 class="page-title">${uiex:getCurMenunm()}</h2> <%-- 현재 메뉴명 --%>
                        <uiex:navibar type="admin"/><%-- 네비게이션바 --%>
                    </div>

                    <!-- 등록 영역 -->
                    <div class="box">

                        <!-- 타이틀 + 우측 버튼(저장/목록) -->
                        <div class="board_top">
                            <h3 class="board-title">등록</h3>
                        </div>

                        <!-- 입력 폼 -->
                        <div class="table-wrap">
                            <form id="sbjctWriteForm" onsubmit="return false;" autocomplete="off">
                                <input type="hidden" id="sbjctTmpltId" name="sbjctTmpltId" value="<c:out value='${sbjctTmpltVO.sbjctTmpltId}' />" />
                                <input type="hidden" id="orgId" name="orgId" value="<c:out value='${orgId}' />" />
                                <input type="hidden" id="smstrChrtId" name="smstrChrtId" value="<c:out value='${sbjctTmpltVO.smstrChrtId}' />" />
                                <input type="hidden" id="sbjctYr" name="sbjctYr" value="<c:out value='${sbjctTmpltVO.sbjctYr}' />" />
                                <input type="hidden" id="sbjctSmstr" name="sbjctSmstr" value="<c:out value='${sbjctTmpltVO.sbjctSmstr}' />" />
                                <input type="hidden" id="sbjctTycd" name="sbjctTycd" value="<c:out value='${sbjctTmpltVO.sbjctTycd}' />" />
                            <table class="table-type5">
                                <colgroup>
                                    <col class="width-15per" />
                                    <col />
                                </colgroup>
                                <tbody>

                                <!-- 기관* -->
                                <tr>
                                    <th><label for="selectOrg" class="req"><spring:message code="common.label.org"/><%--기관--%></label></th>
                                    <td>
                                        <div class="form-row">
                                            <select class="form-select chosen w200" id="selectOrg" name="selectOrg" title="<spring:message code='common.label.org'/> <spring:message code='sys.button.select'/>" required="true"><%--기관 선택--%>
                                                <c:forEach var="org" items="${orgList}">
                                                    <option value="${org.orgId}">
                                                        <c:out value="${org.orgnm}" />
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </td>
                                </tr>

                                <!-- 년도/학기/기수* -->
                                <tr>
                                    <th class="req"><spring:message code="common.term.cohort.name"/><%--학기/기수 명--%></th>
                                    <td>
                                        <div class="form-inline">
                                            <select class="form-select chosen w200" id="sel_term_type" name="sel_term_type" title="<spring:message code='common.term.cohort.name'/> <spring:message code='sys.button.select'/>" required="true"><%--학기/기수 명 선택--%>
                                                <option value=""><spring:message code='common.term.cohort.name'/> <spring:message code='sys.button.select'/></option><%--학기/기수 명 선택--%>
                                            </select>
                                            <select class="form-select chosen w200" id="sel_yr_smstr" name="sel_yr_smstr" title="<spring:message code='crs.label.year.term.cohort'/><%--년도/학기(기수)--%>" disabled="disabled"></select>
                                        </div>
                                    </td>
                                </tr>
                                <!-- 과목 분류* -->
                                <tr>
                                    <th class="req"><spring:message code='crs.label.subject.type'/><%--과목분류--%></th>
                                    <td>
                                        <div class="form-inline">
                                            <c:forEach var="code" items="${sbjctTycdList}" varStatus="status">
                                                <span class="custom-input ${status.first ? '' : 'ml5'}">
                                                    <input type="radio" name="sbjctTycdView" id="sbjctTycd_${status.index}" value="${code.cd}" <c:if test="${code.cd eq sbjctTmpltVO.sbjctTycd}">checked</c:if> disabled="disabled">
                                                    <label for="sbjctTycd_${status.index}"><c:out value="${code.cdnm}" /></label>
                                                </span>
                                            </c:forEach>
                                        </div>
                                    </td>
                                </tr>
                                <!-- 과목명* + 중복확인 -->
                                <tr>
                                    <th><label for="sbjctnm" class="req"><spring:message code='crs.label.crecrs.nm'/><%--과목명--%></label></th>
                                    <td>
                                        <div class="form-inline">
                                            <input class="form-control mr5" type="text" id="sbjctnm" name="sbjctnm"
                                                   value="<c:out value='${sbjctTmpltVO.sbjctnm}' />"
                                                   placeholder="과목명 입력" style="width:320px;" required="true" inputmask="byte" maxLen="200" />
                                            <button type="button" class="btn gray1" id="btnSbjctNameDup" onclick="checkSbjctTmpltNameDup();"><spring:message code='common.label.duplicate.confirm'/><%--중복확인--%></button>
                                        </div>
                                    </td>
                                </tr>

                                <!-- 과목코드* + 중복확인 -->
                                <tr>
                                    <th><label for="sbjctCd" class="req"><spring:message code='common.label.crsauth.crscd'/><%--과목코드--%></label></th>
                                    <td>
                                        <div class="form-inline">
                                            <input class="form-control w200 mr5" type="text" id="sbjctCd" name="sbjctCd"
                                                   value="<c:out value='${sbjctTmpltVO.sbjctCd}' />"
                                                   placeholder="과목코드 입력" style="width:220px;" required="true" inputmask="etc" mask="*{1,30}" maxlength="30" />
                                            <button type="button" class="btn gray1" id="btnSbjctCodeDup" onclick="checkSbjctTmpltCodeDup();"><spring:message code='common.label.duplicate.confirm'/><%--중복확인--%></button>
                                        </div>
                                    </td>
                                </tr>

                                <!-- 강의형태* -->
                                <tr>
                                    <th class="req"><spring:message code='crs.label.crsopertypecd'/><%--강의형태--%></th>
                                    <td>
                                        <div class="form-inline">
                                            <c:forEach var="code" items="${lctrGbncdList}" varStatus="status">
                                                <span class="custom-input ${status.first ? '' : 'ml5'}">
                                                    <input type="radio" name="lctrGbncd" id="lctrGbncd_${status.index}" value="${code.cd}" ${status.first ? 'checked' : ''}>
                                                    <label for="lctrGbncd_${status.index}"><c:out value="${code.cdnm}" /></label>
                                                </span>
                                            </c:forEach>
                                        </div>
                                    </td>
                                </tr>

                                <!-- 사용여부* -->
                                <tr>
                                    <th class="req"><spring:message code='common.use.yn'/><%--사용여부--%></th>
                                    <td>
                                        <div class="form-inline">
                                            <span class="custom-input">
                                                <input type="radio" name="useyn" id="useY" value="Y" checked />
                                                <label for="useY"><spring:message code='common.use.yn'/><%--사용여부--%></label>
                                            </span>
                                            <span class="custom-input ml5">
                                                <input type="radio" name="useyn" id="useN" value="N" />
                                                <label for="useN"><spring:message code='common.use.not'/><%--사용 안 함--%></label>
                                            </span>
                                        </div>
                                    </td>
                                </tr>

                                <!-- 과목설명(에디터 영역은 프로젝트별로 교체 가능) -->
                                <tr>
                                    <th><label for="sbjctExpln"><spring:message code='crs.lecture.explain'/><%--과목설명--%></label></th>
                                    <td>
                                        <div class="form-row">
                                            <div class="editor-box">
                                                <%-- HTML 에디터 --%>
                                                <textarea id="sbjctExpln" name="sbjctExpln"><c:out value="${sbjctTmpltVO.sbjctExpln}"/></textarea>
                                                <script>
                                                    // HTML 에디터
                                                    let editor = UiEditor({
                                                        targetId: "sbjctExpln",
                                                        height: "300px"
                                                    });
                                                </script>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                            </form>
                        </div>
                    </div><!-- //box -->

                    <!-- 하단 중앙 버튼(등록/상세 페이지 공통 패턴) -->
                    <div class="btns" style="margin-top:20px;">
                        <button type="button" class="btn type1" onclick="onSave();">저장</button>
                        <button type="button" class="btn type2" onclick="viewSbjctTmpltList();">목록</button>
                    </div>
                </div>
            </div>

        </div>
    </main>
</div>
</body>
</html>
