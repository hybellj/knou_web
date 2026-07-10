<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
        var EPARAM = '<c:out value="${encParams}" />';
        var ORG_ID = '<c:out value="${orgId}" />';
        var FIXED_ORG_YN = '<c:out value="${fixedOrgYn}" />';
        var MODE = '<c:out value="${mode}" />';
        var SBJCT_ID = '<c:out value="${sbjctVO.sbjctId}" />';
        var SMSTR_CHRT_ID = '<c:out value="${sbjctVO.smstrChrtId}" />';
        var SBJCT_CD = '<c:out value="${sbjctVO.sbjctCd}" />';
        var SBJCT_YR = '<c:out value="${sbjctVO.sbjctYr}" />';
        var SBJCT_SMSTR = '<c:out value="${sbjctVO.sbjctSmstr}" />';
        var SBJCT_LCTR_SDTTM = '<c:out value="${sbjctVO.sbjctLctrSdttm}" />';
        var SBJCT_LCTR_EDTTM = '<c:out value="${sbjctVO.sbjctLctrEdttm}" />';
        var SBJCT_TYCD = 'OPEN_LCTR_SYSTEM';
        var CRS_GBNCD = 'OPEN_CRS';
        var LCTR_GBNCD = '<c:out value="${sbjctVO.lctrGbncd}" />';
        var INITIALIZING = true;
        var SMSTR_CHRT_READY = false;
        var SMSTR_CHRT_LIST = [];
        var SMSTR_CHRT_SELECT_TEXT = '<spring:message code="common.term.cohort.name"/> <spring:message code="sys.button.select"/>'; // 학기/기수 명 선택
        var YEAR_SELECT_TEXT = '<spring:message code="std.label.year"/> <spring:message code="sys.button.select"/>'; // 연도 선택
        var TERM_SELECT_TEXT = '<spring:message code="common.term.cohort"/> <spring:message code="sys.button.select"/>'; // 학기/기수 선택
        var SUBJECT_SELECT_TEXT = '<spring:message code="crs.label.crecrs"/> <spring:message code="sys.button.select"/>'; // 과목 선택
        var SAVE_BEFORE_NEXT_TEXT = '<spring:message code="crs.sbjct.ofring.alert.save.before.next"/>'; // 저장 후 다음으로 이동 가능합니다.
        var CODE_GROUPS = [
            {upCd: "SBJCT_TYCD", target: "#sbjctTycdArea", name: "sbjctTycdView", prefix: "sbjctTycd", fixedValue: SBJCT_TYCD},
            {upCd: "CRS_GBNCD", target: "#crsGbncdArea", name: "crsGbncdView", prefix: "crsGbncd", fixedValue: CRS_GBNCD},
            {upCd: "LCTR_GBNCD", target: "#lctrGbncdArea", name: "lctrGbncd", prefix: "lctrGbncd"}
        ];

        $(document).ready(function() {
            $("#selectOrg").val(ORG_ID);
            if(FIXED_ORG_YN == "Y") {
                $("#selectOrg").prop("disabled", true);
            }
            $("#orgId").val(ORG_ID);
            refreshChosen($("#selectOrg"));
            clearSubjectOptions();
            setInitialPeriod();
            fetchSmstrChrtList();

            $("#selectOrg").on("change", function() {
                ORG_ID = $(this).val();
                $("#orgId").val(ORG_ID);
                SMSTR_CHRT_ID = "";
                INITIALIZING = false;
                SMSTR_CHRT_READY = false;
                fetchSmstrChrtList();
                fetchAllCodeLists();
                clearSubjectOptions();
            });
            $("#sel_term_type").on("change", function() {
                setSelectedSmstrChrt();
            });
            $("#sel_subject").on("change", function() {
                applySelectedSubject();
            });
            $("input[name=lctrPermYn]").on("change", togglePeriodInputs);
        });

        // 화면 입력값을 공개강좌 저장 파라미터로 보정한 뒤 저장한다.
        function onSave() {
            syncOpenLctrForm();
            UiValidator("openLctrOfringWriteForm").then(function(result) {
                if(result) {
                    doSaveOpenLctrOfring();
                }
            });
        }

        // 등록/수정 모드에 맞는 공개강좌 저장 API를 호출한다.
        function doSaveOpenLctrOfring() {
            var registUrl = '<c:url value="/crs/openLctrOfring/admOpenLctrOfringRegist.do" />';
            var modifyUrl = '<c:url value="/crs/openLctrOfring/admOpenLctrOfringModify.do" />';
            var url = MODE == "E" ? modifyUrl : registUrl;
            $.ajax({
                url: url,
                type: "POST",
                data: $("#openLctrOfringWriteForm").serialize(),
                beforeSend: function() { UiComm.showLoading(true); }
            }).done(function(res) {
                UiComm.showLoading(false);
                if(res.result > 0) {
                    var savedSbjctId = res.data ? res.data.sbjctId : SBJCT_ID;
                    markOpenLctrOfringStepSaved(savedSbjctId);
                    UiComm.showMessage("<spring:message code='success.common.save' />", "success") /* 정상적으로 저장되었습니다. */.then(function() {
                        viewOpenLctrOfringAdmRegist(savedSbjctId);
                    });
                } else {
                    UiComm.showMessage(crsResultMessage(res, "<spring:message code='fail.common.msg'/>"), "error"); // 오류가 발생했습니다!
                }
            }).fail(function(xhr) {
                UiComm.showLoading(false);
                UiComm.showMessage(crsResultMessage(xhr.responseJSON || {}, "<spring:message code='fail.common.msg'/>"), "error"); // 오류가 발생했습니다!
            });
        }

        // 공개강좌개설 목록으로 이동한다.
        function viewOpenLctrOfringList() {
            location.href = "/crs/openLctrOfring/admOpenLctrOfringListView.do?encParams=" + EPARAM;
        }

        // 저장 후 공개강좌 관리자 등록 단계로 이동한다.
        function viewOpenLctrOfringAdmRegist(sbjctId) {
            location.href = "/crs/openLctrOfring/admOpenLctrOfringAdmRegistView.do?sbjctId=" + encodeURIComponent(sbjctId || "") + "&encParams=" + EPARAM;
        }

        // 선택 기관의 학기 차트 목록을 조회한다.
        // 공개강좌개설 정보등록 저장 완료 상태를 URL과 화면 변수에 반영한다.
        function markOpenLctrOfringStepSaved(sbjctId) {
            if(sbjctId) {
                SBJCT_ID = sbjctId;
                MODE = "E";
                $("#sbjctId").val(sbjctId);
                replaceOpenLctrOfringRegistHistory(sbjctId);
            }
        }

        // 브라우저 히스토리 복원 시에도 수정모드 URL을 유지하도록 현재 URL을 치환한다.
        function replaceOpenLctrOfringRegistHistory(sbjctId) {
            if(!window.history || !window.history.replaceState || !sbjctId) {
                return;
            }
            var url = "/crs/openLctrOfring/admOpenLctrOfringRegistView.do?sbjctId=" + encodeURIComponent(sbjctId || "") + "&encParams=" + EPARAM;
            window.history.replaceState(null, document.title, url);
        }

        // 공개강좌개설 신규등록 전에는 다음 단계로 이동하지 않는다.
        function canMoveOpenLctrOfringStep() {
            return MODE == "E" && !!SBJCT_ID;
        }

        // 공개강좌개설 단계 화면으로 이동한다.
        function moveOpenLctrOfringStep(stepNo) {
            if(stepNo == 1) {
                if(SBJCT_ID) {
                    location.href = "/crs/openLctrOfring/admOpenLctrOfringRegistView.do?sbjctId=" + encodeURIComponent(SBJCT_ID || "") + "&encParams=" + EPARAM;
                }
                return;
            }
            if(!canMoveOpenLctrOfringStep()) {
                UiComm.showMessage(SAVE_BEFORE_NEXT_TEXT, "warning");
                return;
            }
            if(stepNo == 2) {
                viewOpenLctrOfringAdmRegist(SBJCT_ID);
            }
        }

        // 다음 단계로 이동한다.
        function onNext() {
            moveOpenLctrOfringStep(2);
        }

        function fetchSmstrChrtList() {
            var orgId = $("#selectOrg").val();
            SMSTR_CHRT_READY = false;
            SMSTR_CHRT_LIST = [];
            clearSmstrChrtSelects();
            if(!orgId) {
                return;
            }

            $.ajax({
                url: "/common/admYrSmstrSelect.do",
                data: {orgId: orgId},
                success: function(res) {
                    SMSTR_CHRT_LIST = res.result > 0 ? (res.returnList || []) : [];
                    renderSmstrChrtTypeOptions();
                },
                error: function() {
                    SMSTR_CHRT_LIST = [];
                    clearSmstrChrtSelects();
                }
            });
        }

        // 학기 차트 목록을 등록 화면 선택박스로 출력한다.
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
                html += ' data-yr-smstrnm="' + escapeHtml(getYrSmstrName(v)) + '">';
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

        // 공개강좌 화면에서 사용하는 공통코드 radio 목록을 다시 조회한다.
        function fetchAllCodeLists() {
            CODE_GROUPS.forEach(function(group) {
                fetchCodeList(group);
            });
        }

        // 선택 기관의 공통코드 목록을 조회한다.
        function fetchCodeList(group) {
            var orgId = $("#selectOrg").val();
            if(!orgId) {
                renderRadioOptions(group, []);
                return;
            }

            $.ajax({
                url: "/crs/openLctrOfring/admOfringCmmnCdList.do",
                data: {orgId: orgId, upCd: group.upCd},
                success: function(res) {
                    renderRadioOptions(group, res.result > 0 ? (res.returnList || []) : []);
                },
                error: function() {
                    renderRadioOptions(group, []);
                }
            });
        }

        // 조회한 공통코드를 과목개설 화면과 같은 radio 컨트롤로 렌더링한다.
        function renderRadioOptions(group, codeList) {
            var html = "";
            var selectedValue = group.fixedValue || getSelectedCodeValue(group.name);

            codeList.forEach(function(code, index) {
                if(!code.cd || !code.cdnm) {
                    return;
                }
                var id = group.prefix + "_" + index;
                var checked = selectedValue ? code.cd == selectedValue : index == 0;
                var disabled = group.fixedValue ? ' disabled="disabled"' : '';
                html += '<span class="custom-input ' + (index == 0 ? '' : 'ml5') + '">';
                html += '<input type="radio" name="' + group.name + '" id="' + id + '" value="' + escapeHtml(code.cd) + '"' + (checked ? ' checked' : '') + disabled + '>';
                html += '<label for="' + id + '">' + escapeHtml(code.cdnm) + '</label>';
                html += '</span>';
            });

            $(group.target).html(html);
        }

        // 수정 모드에서는 저장된 공통코드 값을 우선 선택한다.
        function getSelectedCodeValue(name) {
            var codeMap = {
                crsGbncdView: CRS_GBNCD,
                lctrGbncd: LCTR_GBNCD
            };
            return MODE == "E" ? (codeMap[name] || "") : "";
        }

        // 선택한 학기 차트에서 저장에 필요한 연도/학기 값을 hidden 필드에 반영한다.
        function setSelectedSmstrChrt() {
            var $option = $("#sel_term_type option:selected");
            var smstrChrtId = $option.attr("data-smstr-chrt-id");
            var dgrsYr = $option.attr("data-dgrs-yr");
            var dgrsSmstrChrt = $option.attr("data-dgrs-smstr-chrt");
            var yrSmstrnm = $option.attr("data-yr-smstrnm") || "";

            if(!dgrsYr || !dgrsSmstrChrt) {
                $("#smstrChrtId").val("");
                $("#sbjctYr").val("");
                $("#sbjctSmstr").val("");
                clearSubjectOptions();
                $("#sel_yr_smstr").html("");
                $("#sel_yr_smstr").prop("disabled", true);
                refreshChosen($("#sel_yr_smstr"));
                return;
            }

            $("#smstrChrtId").val(smstrChrtId || "");
            $("#sbjctYr").val(dgrsYr);
            $("#sbjctSmstr").val(dgrsSmstrChrt);
            $("#sel_yr_smstr").html('<option value="' + escapeHtml(smstrChrtId || '') + '">' + escapeHtml(yrSmstrnm) + '</option>');
            $("#sel_yr_smstr").val(smstrChrtId || "").prop("disabled", true);
            refreshChosen($("#sel_yr_smstr"));

            SMSTR_CHRT_READY = true;
            if(INITIALIZING) {
                tryFetchInitialSubjectOptions();
            } else {
                fetchSubjectOptions();
            }
        }

        // 학기 차트와 학과가 선택된 경우 개설 가능한 과목템플릿을 조회한다.
        function fetchSubjectOptions() {
            var smstrChrtId = $("#smstrChrtId").val();
            var orgId = $("#selectOrg").val();
            clearSubjectOptions();
            if(!orgId || !smstrChrtId) {
                return;
            }
            $.ajax({
                url: "/crs/openLctrOfring/admSbjctTmpltOfringList.do",
                data: {orgId: orgId, smstrChrtId: smstrChrtId},
                success: function(res) {
                    renderSubjectOptions(res.result > 0 ? (res.returnList || []) : []);
                }
            });
        }

        // 초기 로딩 중에는 학기기수와 학과가 모두 준비된 뒤 과목 목록을 조회한다.
        function tryFetchInitialSubjectOptions() {
            if(!INITIALIZING || !SMSTR_CHRT_READY) {
                return;
            }
            if(!$("#selectOrg").val() || !$("#smstrChrtId").val()) {
                return;
            }
            fetchSubjectOptions();
        }

        // 조회한 과목 템플릿 목록을 과목 선택박스로 렌더링한다.
        function renderSubjectOptions(subjectList) {
            var html = buildDefaultOption(SUBJECT_SELECT_TEXT);

            subjectList.forEach(function(v) {
                if(!v.sbjctTmpltId || !v.sbjctnm) {
                    return;
                }
                html += '<option value="' + escapeHtml(v.sbjctTmpltId) + '"';
                html += ' data-sbjct-cd="' + escapeHtml(v.sbjctCd || '') + '"';
                html += ' data-sbjctnm="' + escapeHtml(v.sbjctnm || '') + '"';
                html += ' data-lctr-gbncd="' + escapeHtml(v.lctrGbncd || '') + '">';
                html += escapeHtml(v.sbjctnm || "");
                html += '</option>';
            });

            $("#sel_subject").html(html);
            selectCurrentSubjectOption();
            refreshChosen($("#sel_subject"));
            INITIALIZING = false;
        }

        // 기관/학과/학기 변경 시 과목템플릿 선택값을 초기화한다.
        function clearSubjectOptions() {
            $("#sel_subject").html(buildDefaultOption(SUBJECT_SELECT_TEXT));
            refreshChosen($("#sel_subject"));
            if(!(MODE == "E" && INITIALIZING)) {
                $("#selectedSbjctTmpltId").val("");
                $("#sbjctCd").val("");
                $("#sbjctnm").val("");
            }
        }

        // 수정 화면에서는 저장된 과목코드와 일치하는 템플릿을 선택 상태로 복원한다.
        function selectCurrentSubjectOption() {
            if(MODE != "E") {
                return;
            }
            var matchedValue = "";
            var currentSbjctnm = $("#sbjctnm").val();
            $("#sel_subject option").each(function() {
                var $option = $(this);
                if(!$option.val()) {
                    return;
                }
                if((SBJCT_CD && $option.attr("data-sbjct-cd") == SBJCT_CD)
                        || (currentSbjctnm && $option.attr("data-sbjctnm") == currentSbjctnm)) {
                    matchedValue = $option.val();
                    return false;
                }
            });

            if(matchedValue) {
                $("#sel_subject").val(matchedValue);
                $("#selectedSbjctTmpltId").val(matchedValue);
            }
        }

        // 선택한 과목템플릿의 과목코드/과목명/강의형태를 공개강좌 입력값에 반영한다.
        function applySelectedSubject() {
            var $option = $("#sel_subject option:selected");
            if(!$option.val()) {
                $("#selectedSbjctTmpltId").val("");
                $("#sbjctCd").val("");
                $("#sbjctnm").val("");
                return;
            }
            $("#selectedSbjctTmpltId").val($option.val() || "");
            $("#sbjctCd").val($option.attr("data-sbjct-cd") || "");
            $("#sbjctnm").val($option.attr("data-sbjctnm") || "");
            var lctrGbncd = $option.attr("data-lctr-gbncd") || "";
            if(lctrGbncd) {
                $("input[name=lctrGbncd][value='" + escapeSelectorValue(lctrGbncd) + "']").prop("checked", true);
            }
        }

        // 학기기수 선택박스와 파생 연도/학기 선택박스를 초기화한다.
        function clearSmstrChrtSelects() {
            $("#sel_term_type").html(buildDefaultOption(SMSTR_CHRT_SELECT_TEXT));
            $("#sel_yr_smstr").html("");
            $("#smstrChrtId").val("");
            $("#sbjctYr").val("");
            $("#sbjctSmstr").val("");
            clearSubjectOptions();
            $("#sel_yr_smstr").prop("disabled", true);
            refreshChosen($("#sel_term_type"));
            refreshChosen($("#sel_yr_smstr"));
        }

        // 학기기수 응답 객체에서 표시명을 가져온다.
        function getSmstrChrtnm(item) {
            return item.smstrChrtnm || item.smstrChrtNm || "";
        }

        // 공개강좌는 기간설정일 때만 시작/종료 시간을 고정하고, 영구일 때는 기간값을 비워 전송한다.
        function syncOpenLctrForm() {
            var $selectedOption = $("#sel_term_type option:selected");
            var permYn = $("input[name=lctrPermYn]:checked").val();
            $("#orgId").val($("#selectOrg").val());
            $("#smstrChrtId").val($selectedOption.attr("data-smstr-chrt-id") || "");
            $("#sbjctYr").val($selectedOption.attr("data-dgrs-yr") || "");
            $("#sbjctSmstr").val($selectedOption.attr("data-dgrs-smstr-chrt") || "");
            $("#crsGbncd").val(CRS_GBNCD);
            if(permYn == "Y") {
                $("#sbjctLctrSdttm").val("");
                $("#sbjctLctrEdttm").val("");
            } else {
                $("#sbjctLctrSdttm").val(normalizeDate($("#lctrStartDt").val()) + "000000");
                $("#sbjctLctrEdttm").val(normalizeDate($("#lctrEndDt").val()) + "235959");
            }
        }

        // 저장된 강의기간으로 영구/기간설정 라디오와 날짜 입력값을 초기화한다.
        function setInitialPeriod() {
            $("#lctrStartDt").val(formatDate(SBJCT_LCTR_SDTTM));
            if(!SBJCT_LCTR_SDTTM && !SBJCT_LCTR_EDTTM) {
                $("input[name=lctrPermYn][value=Y]").prop("checked", true);
            } else {
                $("input[name=lctrPermYn][value=N]").prop("checked", true);
                $("#lctrEndDt").val(formatDate(SBJCT_LCTR_EDTTM));
            }
            togglePeriodInputs();
        }

        // 영구 강의기간 선택 시 날짜 입력 필수 검증과 입력 가능 여부를 함께 전환한다.
        function togglePeriodInputs() {
            var permYn = $("input[name=lctrPermYn]:checked").val();
            var permanent = permYn == "Y";
            $("#lctrStartDt, #lctrEndDt").prop("disabled", permanent);
            if(permanent) {
                $("#lctrStartDt, #lctrEndDt").removeAttr("required");
            } else {
                $("#lctrStartDt, #lctrEndDt").attr("required", "true");
            }
        }

        // 날짜 입력값에서 숫자 8자리만 저장용 날짜로 사용한다.
        function normalizeDate(value) {
            return String(value || "").replace(/[^0-9]/g, "").substring(0, 8);
        }

        // yyyyMMdd 값을 화면 표시용 yyyy.MM.dd 형식으로 변환한다.
        function formatDate(value) {
            value = normalizeDate(value);
            if(value.length != 8) {
                return "";
            }
            return value.substring(0,4) + "." + value.substring(4,6) + "." + value.substring(6,8);
        }

        // chosen 적용 select의 UI 상태를 갱신한다.
        function refreshChosen($target) {
            if($target && $target.trigger) {
                $target.trigger("chosen:updated");
            }
        }

        // 선택박스의 기본 안내 옵션을 생성한다.
        function buildDefaultOption(text) {
            return '<option value="">' + escapeHtml(text) + '</option>';
        }

        // radio value 선택자에 사용할 문자열을 이스케이프한다.
        function escapeSelectorValue(value) {
            return String(value || '').replace(/\\/g, '\\\\').replace(/'/g, "\\'");
        }

        // 학기/기수 응답 객체에서 년도 값을 가져온다.
        function getDgrsYr(item) {
            return item.yr || item.dgrsYr || "";
        }

        // 학기/기수 응답 객체에서 학기/기수 값을 가져온다.
        function getDgrsSmstrChrt(item) {
            return item.smstr || item.dgrsSmstrChrt || "";
        }

        // 학기/기수 응답 객체에서 년도/학기(기수) 표시명을 가져온다.
        function getYrSmstrName(item) {
            return item.yrSmstrnm || item.yrSmstrNm || "";
        }

        // 동적 옵션/테이블 출력 시 HTML 특수문자를 이스케이프한다.
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
    <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>
    <main class="common">
        <%@ include file="/WEB-INF/jsp/common_new/admin_aside.jsp" %>
        <div id="content" class="content-wrap common">
            <div class="admin_sub">
                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                        <uiex:navibar type="admin"/>
                    </div>

                    <div class="step-process-wrap mb40">
                        <div class="board_card_list">
                            <div class="card_item active">
                                <a href="javascript:void(0);" onclick="moveOpenLctrOfringStep(1); return false;">
                                    <span class="step-num">1</span>
                                    <spring:message code="crs.sbjct.ofring.step.info.regist"/><%--개설과목 정보등록--%>
                                </a>
                            </div>
                            <div class="card_item">
                                <a href="javascript:void(0);" onclick="moveOpenLctrOfringStep(2); return false;">
                                    <span class="step-num">2</span>
                                    <spring:message code="crs.sbjct.ofring.step.manager.regist"/><%--과목 관리자 등록--%>
                                </a>
                            </div>
                        </div>
                    </div>

                    <form id="openLctrOfringWriteForm" onsubmit="return false;" autocomplete="off">
                        <input type="hidden" id="sbjctId" name="sbjctId" value="<c:out value='${sbjctVO.sbjctId}' />" />
                        <input type="hidden" id="orgId" name="orgId" value="<c:out value='${orgId}' />" />
                        <input type="hidden" id="selectedSbjctTmpltId" name="sbjctTmpltId" />
                        <input type="hidden" id="sbjctCd" name="sbjctCd" value="<c:out value='${sbjctVO.sbjctCd}' />" />
                        <input type="hidden" id="smstrChrtId" name="smstrChrtId" value="<c:out value='${sbjctVO.smstrChrtId}' />" />
                        <input type="hidden" id="sbjctYr" name="sbjctYr" value="<c:out value='${sbjctVO.sbjctYr}' />" />
                        <input type="hidden" id="sbjctSmstr" name="sbjctSmstr" value="<c:out value='${sbjctVO.sbjctSmstr}' />" />
                        <input type="hidden" name="sbjctTycd" value="OPEN_LCTR_SYSTEM" />
                        <input type="hidden" id="crsGbncd" name="crsGbncd" value="OPEN_CRS" />
                        <input type="hidden" id="sbjctLctrSdttm" name="sbjctLctrSdttm" value="<c:out value='${sbjctVO.sbjctLctrSdttm}' />" />
                        <input type="hidden" id="sbjctLctrEdttm" name="sbjctLctrEdttm" value="<c:out value='${sbjctVO.sbjctLctrEdttm}' />" />

                        <div class="box">
                            <div class="board_top">
                                <h3 class="board-title"><spring:message code="crs.sbjct.ofring.section.info"/><%--개설 과목 정보--%></h3>
                            </div>
                            <div class="table-wrap">
                                <table class="table-type5">
                                    <colgroup>
                                        <col class="width-15per" />
                                        <col />
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th><label for="selectOrg" class="req"><spring:message code="common.label.org"/><%--기관--%></label></th>
                                        <td>
                                        <select class="form-select chosen" id="selectOrg" name="selectOrg" required="true">
                                            <c:forEach var="org" items="${orgList}">
                                                <option value="<c:out value='${org.orgId}' />"><c:out value="${org.orgnm}" /></option>
                                            </c:forEach>
                                        </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="req"><spring:message code="common.term.cohort.name"/><%--학기/기수 명--%></th>
                                        <td>
                                        <select class="form-select chosen w200" id="sel_term_type" name="sel_term_type" required="true"></select>
                                        <select class="form-select chosen w200" id="sel_yr_smstr" name="sel_yr_smstr" title="<spring:message code='crs.label.year.term.cohort'/><%--년도/학기(기수)--%>" disabled="disabled"></select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><spring:message code="crs.label.subject.type"/><%--과목분류--%></th>
                                        <td>
                                        <div class="form-inline" id="sbjctTycdArea">
                                            <c:forEach var="code" items="${sbjctTycdList}" varStatus="status">
                                                <span class="custom-input ${status.first ? '' : 'ml5'}">
                                                    <input type="radio" name="sbjctTycdView" id="sbjctTycd_${status.index}" value="<c:out value='${code.cd}' />" <c:if test="${code.cd eq 'OPEN_LCTR_SYSTEM'}">checked</c:if> disabled="disabled">
                                                    <label for="sbjctTycd_${status.index}"><c:out value="${code.cdnm}" /></label>
                                                </span>
                                            </c:forEach>
                                        </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="sel_subject" class="req"><spring:message code="crs.label.crecrs"/><%--과목--%></label></th>
                                        <td><select class="form-select chosen" id="sel_subject" required="true"></select></td>
                                    </tr>
                                    <tr>
                                        <th><label for="sbjctnm" class="req"><spring:message code="crs.sbjct.ofring.label.subject.ko"/><%--과목명(KO)--%></label></th>
                                        <td><input class="form-control" type="text" id="sbjctnm" name="sbjctnm" value="<c:out value='${sbjctVO.sbjctnm}' />" required="true" /></td>
                                    </tr>
                                    <tr>
                                        <th><label for="sbjctEnnm"><spring:message code="crs.sbjct.ofring.label.subject.en"/><%--과목명(EN)--%></label></th>
                                        <td><input class="form-control" type="text" id="sbjctEnnm" name="sbjctEnnm" value="<c:out value='${sbjctVO.sbjctEnnm}' />" /></td>
                                    </tr>
                                    <tr>
                                        <th class="req"><spring:message code="crs.label.course.division"/><%--과정구분--%></th>
                                        <td>
                                        <div class="form-inline" id="crsGbncdArea">
                                            <c:forEach var="code" items="${crsGbncdList}" varStatus="status">
                                                <span class="custom-input ${status.first ? '' : 'ml5'}">
                                                    <input type="radio" name="crsGbncdView" id="crsGbncd_${status.index}" value="<c:out value='${code.cd}' />" <c:if test="${code.cd eq 'OPEN_CRS'}">checked</c:if> disabled="disabled">
                                                    <label for="crsGbncd_${status.index}"><c:out value="${code.cdnm}" /></label>
                                                </span>
                                            </c:forEach>
                                        </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="req"><spring:message code="crs.label.crsopertypecd"/><%--강의형태--%></th>
                                        <td>
                                        <div class="form-inline" id="lctrGbncdArea">
                                            <c:forEach var="code" items="${lctrGbncdList}" varStatus="status">
                                                <span class="custom-input ${status.first ? '' : 'ml5'}">
                                                    <input type="radio" name="lctrGbncd" id="lctrGbncd_${status.index}" value="<c:out value='${code.cd}' />" <c:if test="${(empty sbjctVO.lctrGbncd and status.first) or code.cd == sbjctVO.lctrGbncd}">checked</c:if>>
                                                    <label for="lctrGbncd_${status.index}"><c:out value="${code.cdnm}" /></label>
                                                </span>
                                            </c:forEach>
                                        </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="sbjctExpln" class="req"><spring:message code="crs.lecture.explain"/><%--과목설명--%></label></th>
                                        <td>
                                            <div class="editor-box">
                                                <textarea id="sbjctExpln" name="sbjctExpln"><c:out value="${sbjctVO.sbjctExpln}" /></textarea>
                                                <script>
                                                    // HTML editor
                                                    let editor = UiEditor({
                                                        targetId: "sbjctExpln",
                                                        height: "240px"
                                                    });
                                                </script>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="req"><spring:message code="common.use.yn"/><%--사용여부--%></th>
                                        <td>
                                        <span class="custom-input">
                                            <input type="radio" name="useyn" id="useY" value="Y" <c:if test="${empty sbjctVO.useyn or sbjctVO.useyn eq 'Y'}">checked</c:if> />
                                            <label for="useY"><spring:message code="common.use"/><%--사용--%></label>
                                        </span>
                                        <span class="custom-input ml5">
                                            <input type="radio" name="useyn" id="useN" value="N" <c:if test="${sbjctVO.useyn eq 'N'}">checked</c:if> />
                                            <label for="useN"><spring:message code="common.use.not"/><%--사용안함--%></label>
                                        </span>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="box">
                            <div class="board_top">
                                <h3 class="board-title"><spring:message code="crs.sbjct.ofring.section.period.info"/><%--강의 기간 정보--%></h3>
                            </div>
                            <div class="table-wrap">
                                <table class="table-type5">
                                    <colgroup>
                                        <col class="width-15per" />
                                        <col />
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th class="req"><spring:message code="common.label.lecture.period"/><%--강의기간--%></th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" name="lctrPermYn" id="lctrPermY" value="Y" />
                                                    <label for="lctrPermY"><spring:message code="crs.sbjct.ofring.label.permanent"/><%--영구--%></label>
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" name="lctrPermYn" id="lctrPermN" value="N" />
                                                    <label for="lctrPermN"><spring:message code="crs.sbjct.ofring.label.period.setting"/><%--기간설정--%></label>
                                                </span>
                                                <div class="date_area ml5">
                                                    <input type="text" id="lctrStartDt" class="datepicker" toDate="lctrEndDt" placeholder="<spring:message code='crs.sbjct.ofring.placeholder.start.day'/><%--시작일--%>" required="true" style="width:120px;" />
                                                    <span class="txt-sort">~</span>
                                                    <input type="text" id="lctrEndDt" class="datepicker" fromDate="lctrStartDt" placeholder="<spring:message code='crs.sbjct.ofring.placeholder.end.day'/><%--종료일--%>" style="width:120px;" />
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </form>

                    <div class="btns">
                        <button type="button" class="btn basic" onclick="onNext();"><spring:message code="button.next"/><%--다음--%></button>
                        <button type="button" class="btn type1" onclick="onSave();"><spring:message code="button.save"/><%--저장--%></button>
                        <button type="button" class="btn type2" onclick="viewOpenLctrOfringList();"><spring:message code="button.list"/><%--목록--%></button>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
