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
        var EPARAM         = '<c:out value="${encParams}" />';
        var ORG_ID         = '<c:out value="${orgId}" />';
        var FIXED_ORG_YN   = '<c:out value="${fixedOrgYn}" />';
        var MODE           = '<c:out value="${mode}" />';
        var SBJCT_ID       = '<c:out value="${sbjctVO.sbjctId}" />';
        var SMSTR_CHRT_ID  = '<c:out value="${sbjctVO.smstrChrtId}" />';
        var LCTR_PRVW_WKNO = '<c:out value="${sbjctVO.lctrPrvwWkno}" />';
        var SBJCT_CD       = '<c:out value="${sbjctVO.sbjctCd}" />';
        var CRS_GBNCD      = '<c:out value="${sbjctVO.crsGbncd}" />';
        var SBJCT_TYCD     = '<c:out value="${sbjctVO.sbjctTycd}" />';
        var LCTR_GBNCD     = '<c:out value="${sbjctVO.lctrGbncd}" />';
        var CMCRS_GBNCD    = '<c:out value="${sbjctVO.cmcrsGbncd}" />';
        var EVL_GBNCD      = '<c:out value="${sbjctVO.evlGbncd}" />';
        var LCTR_FRMT_GBNCD = '<c:out value="${sbjctVO.lctrFrmtGbncd}" />';
        var LRN_CNTRL_GBNCD = '<c:out value="${sbjctVO.lrnCntrlGbncd}" />';
        var ATNDLC_APLY_MTHD_CD = '<c:out value="${sbjctVO.atndlcAplyMthdCd}" />';
        var ATNDLC_CERT_STSCD = '<c:out value="${sbjctVO.atndlcCertStscd}" />';
        var RVW_PSBL_GBNCD = '<c:out value="${sbjctVO.rvwPsblGbncd}" />';
        var LIMIT_YN       = '<c:out value="${sbjctVO.atndlcQuota gt 0 ? 'Y' : 'N'}" />';
        var ATNDLC_APLY_SDTTM = '<c:out value="${sbjctVO.atndlcAplySdttm}" />';
        var ATNDLC_APLY_EDTTM = '<c:out value="${sbjctVO.atndlcAplyEdttm}" />';
        var SBJCT_LCTR_SDTTM = '<c:out value="${sbjctVO.sbjctLctrSdttm}" />';
        var SBJCT_LCTR_EDTTM = '<c:out value="${sbjctVO.sbjctLctrEdttm}" />';
        var SBJCT_LATE_RECG_DTTM = '<c:out value="${sbjctVO.sbjctLateRecgDttm}" />';
        var AUDIT_EDTTM    = '<c:out value="${sbjctVO.auditEdttm}" />';
        var MRK_PROC_SDTTM = '<c:out value="${sbjctVO.mrkProcSdttm}" />';
        var MRK_PROC_EDTTM = '<c:out value="${sbjctVO.mrkProcEdttm}" />';
        var RVW_SDTTM      = '<c:out value="${sbjctVO.rvwSdttm}" />';
        var RVW_EDTTM      = '<c:out value="${sbjctVO.rvwEdttm}" />';
        var INITIALIZING   = true;
        var SMSTR_CHRT_READY = false;
        var SMSTR_CHRT_LIST = [];

        var ORG_SELECT_TEXT = '<spring:message code="common.label.org"/> <spring:message code="sys.button.select"/>'; // 기관 선택
        var SMSTR_CHRT_SELECT_TEXT = '<spring:message code="common.term.cohort.name"/> <spring:message code="sys.button.select"/>'; // 학기/기수 명 선택
        var YEAR_SELECT_TEXT = '<spring:message code="std.label.year"/> <spring:message code="sys.button.select"/>'; // 년도 선택
        var TERM_SELECT_TEXT = '<spring:message code="common.term.cohort"/> <spring:message code="sys.button.select"/>'; // 학기/기수 선택
        var SUBJECT_SELECT_TEXT = '<spring:message code="crs.label.crecrs"/> <spring:message code="sys.button.select"/>'; // 과목 선택
        var WEEK_SELECT_TEXT = '<spring:message code="crs.sbjct.ofring.label.week"/> <spring:message code="sys.button.select"/>'; // 주차 선택
        var WEEK_SUFFIX_TEXT = '<spring:message code="crs.sbjct.ofring.label.week.suffix"/>'; // 주차
        var DVCLAS_NCKNM_DEFAULT_TEXT = '<spring:message code="crs.sbjct.ofring.default.dvclas.alias"/>'; // 일반분반
        var SAVE_BEFORE_NEXT_TEXT = '<spring:message code="crs.sbjct.ofring.alert.save.before.next"/>'; // 저장 후 다음으로 이동 가능합니다.
        var APPROVE_CERT_STSCD = "APPROVE";
        var APPROVE_REQUIRED_TEXT = '<spring:message code="crs.sbjct.ofring.alert.approve.required"/>'; // 수강인증상태가 승인이여야 합니다.

        var CODE_GROUPS = [
            {upCd: "CRS_GBNCD", target: "#crsGbncdArea", name: "crsGbncd", prefix: "crsGbncd"},
            {upCd: "SBJCT_TYCD", target: "#sbjctTycdArea", name: "sbjctTycdView", prefix: "sbjctTycd"},
            {upCd: "LCTR_GBNCD", target: "#lctrGbncdArea", name: "lctrGbncd", prefix: "lctrGbncd"},
            {upCd: "CMCRS_GBNCD", target: "#cmcrsGbncdArea", name: "cmcrsGbncd", prefix: "cmcrsGbncd"},
            {upCd: "EVL_GBNCD", target: "#evlGbncdArea", name: "evlGbncd", prefix: "evlGbncd"},
            {upCd: "LCTR_FRMT_GBNCD", target: "#lctrFrmtGbncdArea", name: "lctrFrmtGbncd", prefix: "lctrFrmtGbncd"},
            {upCd: "LRN_CNTRL_GBNCD", target: "#lrnCntrlGbncdArea", name: "lrnCntrlGbncd", prefix: "lrnCntrlGbncd"},
            {upCd: "ATNDLC_APLY_MTHD_CD", target: "#atndlcAplyMthdCdArea", name: "atndlcAplyMthdCd", prefix: "atndlcAplyMthdCd"},
            {upCd: "ATNDLC_CERT_STSCD", target: "#atndlcCertStscdArea", name: "atndlcCertStscd", prefix: "atndlcCertStscd"},
            {upCd: "RVW_PSBL_GBNCD", target: "#rvwPsblGbncdArea", name: "rvwPsblGbncd", prefix: "rvwPsblGbncd"}
        ];

        $(document).ready(function() {
            $("#selectOrg").val(ORG_ID);
            if(FIXED_ORG_YN == "Y") {
                $("#selectOrg").prop("disabled", true);
            }
            refreshChosen($("#selectOrg"));
            clearSubjectOptions();
            initDvclasNcknmDefault();
            initRegistAtndlcAplyPeriod();
            initSbjctOfringModifyValues();

            fetchSmstrChrtList();
            initOfringControls();

            $("#selectOrg").on("change", function() {
                ORG_ID = $(this).val();
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

            $(document).on("change", "input[name=evlGbncd]", function() {
                togglePassfailScore();
            });

            $(document).on("change", "input[name=rvwPsblGbncd]", function() {
                toggleReviewPeriod();
            });

            $(document).on("change", "input[name=limitYn]", function() {
                toggleAtndlcQuota();
            });
        });

        // 저장
        function onSave() {
            syncSbjctOfringForm();
            UiValidator("sbjctOfringWriteForm").then(function(result) {
                if(result) {
                    doSaveSbjctOfring();
                }
            });
        }

        // 과목개설 저장 Ajax를 수행한다.
        function doSaveSbjctOfring() {
            var registUrl = '<c:url value="/crs/sbjctOfring/admSbjctOfringRegist.do" />';
            var modifyUrl = '<c:url value="/crs/sbjctOfring/admSbjctOfringModify.do" />';
            var url = MODE == "E" ? modifyUrl : registUrl;

            $.ajax({
                url: url,
                type: "POST",
                data: $("#sbjctOfringWriteForm").serialize(),
                beforeSend: function() {
                    UiComm.showLoading(true);
                }
            }).done(function(res) {
                UiComm.showLoading(false);
                if(res.result > 0) {
                    var savedSbjctId = res.data ? res.data.sbjctId : "";
                    var savedAtndlcCertStscd = res.data && res.data.atndlcCertStscd ? res.data.atndlcCertStscd : getSelectedAtndlcCertStscd();
                    ATNDLC_CERT_STSCD = savedAtndlcCertStscd;
                    markOfringStepSaved(savedSbjctId);
                    UiComm.showMessage("<spring:message code='success.common.save' />", "success") /* 정상적으로 저장되었습니다. */
                        .then(function() {
                            if(savedAtndlcCertStscd == APPROVE_CERT_STSCD) {
                                viewSbjctOfringSchdlRegist(savedSbjctId);
                            } else {
                                viewSbjctOfringList();
                            }
                        });
                } else {
                    UiComm.showMessage(crsResultMessage(res, "<spring:message code='fail.common.msg'/>"), "error"); // 에러가 발생했습니다!
                }
            }).fail(function(xhr) {
                UiComm.showLoading(false);
                UiComm.showMessage(crsResultMessage(xhr.responseJSON || {}, "<spring:message code='fail.common.msg'/>"), "error"); // 에러가 발생했습니다!
            });
        }

        // 목록이동
        function viewSbjctOfringList() {
            location.href = '/crs/sbjctOfring/admSbjctOfringListView.do?encParams=' + EPARAM;
        }

        // 과목개설 정보등록 화면으로 이동한다.
        function viewSbjctOfringRegist(sbjctId) {
            location.href = '/crs/sbjctOfring/admSbjctOfringRegistView.do?sbjctId=' + encodeURIComponent(sbjctId || '') + '&encParams=' + EPARAM;
        }

        // 주차 기간 설정 화면으로 이동한다.
        function viewSbjctOfringSchdlRegist(sbjctId) {
            location.href = '/crs/sbjctOfring/admSbjctOfringSchdlRegistView.do?sbjctId=' + encodeURIComponent(sbjctId || '') + '&encParams=' + EPARAM;
        }

        // 과목관리자 등록 화면으로 이동한다.
        function viewSbjctOfringAdmRegist(sbjctId) {
            location.href = '/crs/sbjctOfring/admSbjctOfringAdmRegistView.do?sbjctId=' + encodeURIComponent(sbjctId || '') + '&encParams=' + EPARAM;
        }

        // 수강생 등록 화면으로 이동한다.
        function viewSbjctOfringStdntRegist(sbjctId) {
            location.href = '/crs/sbjctOfring/admSbjctOfringStdntRegistView.do?sbjctId=' + encodeURIComponent(sbjctId || '') + '&encParams=' + EPARAM;
        }

        // 과목개설 정보등록 저장 완료 상태와 URL을 보정한다.
        function markOfringStepSaved(sbjctId) {
            if(sbjctId) {
                SBJCT_ID = sbjctId;
                MODE = "E";
                $("#sbjctId").val(sbjctId);
                replaceOfringRegistHistory(sbjctId);
            }
        }

        // 브라우저 히스토리 복원 시에도 수정모드 URL이 유지되도록 현재 URL을 치환한다.
        function replaceOfringRegistHistory(sbjctId) {
            if(!window.history || !window.history.replaceState || !sbjctId) {
                return;
            }
            var url = '/crs/sbjctOfring/admSbjctOfringRegistView.do?sbjctId=' + encodeURIComponent(sbjctId || '') + '&encParams=' + EPARAM;
            window.history.replaceState(null, document.title, url);
        }

        // 선택된 기관의 학기/기수 목록을 조회한다.
        function fetchSmstrChrtList() {
            var orgId = $("#selectOrg").val();

            SMSTR_CHRT_READY = false;
            SMSTR_CHRT_LIST = [];
            clearSmstrChrtSelects();
            if(!orgId) {
                return;
            }

            $.ajax({
                url: "/crs/sbjctOfring/admYrSmstrSelect.do",
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

        // 과목개설 화면에서 사용하는 공통코드를 다시 조회한다.
        function fetchAllCodeLists() {
            CODE_GROUPS.forEach(function(group) {
                fetchCodeList(group);
            });
        }

        // 선택된 기관의 공통코드 목록을 조회한다.
        function fetchCodeList(group) {
            var orgId = $("#selectOrg").val();
            if(!orgId) {
                renderRadioOptions(group, []);
                return;
            }

            $.ajax({
                url: "/crs/sbjctOfring/admOfringCmmnCdList.do",
                data: {
                    orgId: orgId,
                    upCd: group.upCd
                },
                success: function(res) {
                    renderRadioOptions(group, res.result > 0 ? (res.returnList || []) : []);
                },
                error: function() {
                    renderRadioOptions(group, []);
                }
            });
        }

        // 조회된 공통코드를 radio 입력 항목으로 렌더링한다.
        function renderRadioOptions(group, codeList) {
            var html = "";
            var selectedValue = getSelectedCodeValue(group.name);

            codeList.forEach(function(code, index) {
                if(!code.cd || !code.cdnm) {
                    return;
                }
                var id = group.prefix + "_" + index;
                var checked = selectedValue ? code.cd == selectedValue : index == 0;
                var disabled = group.name == "sbjctTycdView" ? ' disabled="disabled"' : '';
                html += '<span class="custom-input ' + (index == 0 ? '' : 'ml5') + '">';
                html += '<input type="radio" name="' + group.name + '" id="' + id + '" value="' + escapeHtml(code.cd) + '"' + (checked ? ' checked' : '') + disabled + '>';
                html += '<label for="' + id + '">' + escapeHtml(code.cdnm) + '</label>';
                html += '</span>';
            });

            $(group.target).html(html);
            if(group.name == "sbjctTycdView") {
                applyFixedSbjctTycd();
            }
            if(group.name == "evlGbncd") {
                togglePassfailScore();
            }
            if(group.name == "rvwPsblGbncd") {
                toggleReviewPeriod();
            }
        }

        // 수정모드에서 저장된 공통코드 값을 반환한다.
        function getSelectedCodeValue(name) {
            var codeMap = {
                crsGbncd: CRS_GBNCD,
                sbjctTycdView: SBJCT_TYCD,
                lctrGbncd: LCTR_GBNCD,
                cmcrsGbncd: CMCRS_GBNCD,
                evlGbncd: EVL_GBNCD,
                lctrFrmtGbncd: LCTR_FRMT_GBNCD,
                lrnCntrlGbncd: LRN_CNTRL_GBNCD,
                atndlcAplyMthdCd: ATNDLC_APLY_MTHD_CD,
                atndlcCertStscd: ATNDLC_CERT_STSCD,
                rvwPsblGbncd: RVW_PSBL_GBNCD
            };
            return MODE == "E" ? (codeMap[name] || "") : "";
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

        // 평가방법과 복습기간의 추가 화면 상태를 초기화한다.
        function initOfringControls() {
            toggleReviewPeriod();
            togglePassfailScore();
            toggleAtndlcQuota();
        }

        // 평가방법 코드가 PASSFAIL일 때만 PASSFAIL 점수 입력 영역을 표시한다.
        function togglePassfailScore() {
            var usePassfailScr = $("input[name=evlGbncd]:checked").val() == "PASSFAIL";
            $("#passfailScrArea").toggle(usePassfailScr);
            $("#passfailScr").prop("disabled", !usePassfailScr);
            if(usePassfailScr) {
                $("#passfailScr").attr("required", "true");
            } else {
                $("#passfailScr").removeAttr("required").removeClass("input_error").val("");
            }
        }

        // 복습기간 코드가 PRD_STNG일 때만 날짜 입력을 활성화한다.
        function toggleReviewPeriod() {
            var isPeriodSetting = $("input[name=rvwPsblGbncd]:checked").val() == "PRD_STNG";
            $("#review_start_dt, #review_end_dt").prop("disabled", !isPeriodSetting);
            if(isPeriodSetting) {
                $("#review_start_dt, #review_end_dt").attr("required", "true");
            } else {
                $("#review_start_dt, #review_end_dt").removeAttr("required").removeClass("input_error").val("");
            }
        }

        // 인원제한 사용 여부에 따라 수강정원 입력 상태를 변경한다.
        function toggleAtndlcQuota() {
            var useLimit = $("input[name=limitYn]:checked").val() == "Y";

            $("#atndlcQuota").prop("readonly", !useLimit);
            if(useLimit) {
                $("#atndlcQuota").attr("required", "true");
                if($("#atndlcQuota").val() == "0") {
                    $("#atndlcQuota").val("");
                }
            } else {
                $("#atndlcQuota").removeAttr("required").removeClass("input_error").val("0");
            }
        }

        // 신규 등록 화면에서 분반별칭 기본값을 세팅한다.
        function initDvclasNcknmDefault() {
            if(!SBJCT_ID && !$.trim($("#dvclasNcknm").val())) {
                $("#dvclasNcknm").val(DVCLAS_NCKNM_DEFAULT_TEXT);
            }
        }

        // 등록 화면 최초 진입 시 기관 업무일정 기준 수강신청기간을 세팅한다.
        function initRegistAtndlcAplyPeriod() {
            if(MODE != "I") {
                return;
            }

            setDateFields(ATNDLC_APLY_SDTTM, "#apply_start_dt", "#atndlcAplySdttm");
            setDateFields(ATNDLC_APLY_EDTTM, "#apply_end_dt", "#atndlcAplyEdttm");
        }

        // 수정모드에서 저장된 과목개설 값을 화면 입력 항목에 세팅한다.
        function initSbjctOfringModifyValues() {
            if(MODE != "E") {
                return;
            }

            $("#selectedSbjctTmpltId").val("");
            $("#sbjctCd").val(SBJCT_CD);
            $("#sel_division").val("<c:out value='${sbjctVO.dvclasNo}' />");
            $("#passfailScr").val("<c:out value='${sbjctVO.passfailScr}' />");
            $("#atndlcQuota").val("<c:out value='${sbjctVO.atndlcQuota}' />");
            setRadioValue("crsGbncd", CRS_GBNCD);
            setRadioValue("sbjctTycdView", SBJCT_TYCD);
            setRadioValue("lctrGbncd", LCTR_GBNCD);
            setRadioValue("cmcrsGbncd", CMCRS_GBNCD);
            setRadioValue("evlGbncd", EVL_GBNCD);
            setRadioValue("lctrFrmtGbncd", LCTR_FRMT_GBNCD);
            setRadioValue("lrnCntrlGbncd", LRN_CNTRL_GBNCD);
            setRadioValue("atndlcAplyMthdCd", ATNDLC_APLY_MTHD_CD);
            setRadioValue("atndlcCertStscd", ATNDLC_CERT_STSCD);
            setRadioValue("rvwPsblGbncd", RVW_PSBL_GBNCD);
            setRadioValue("limitYn", LIMIT_YN);
            setRadioValue("useyn", "<c:out value='${sbjctVO.useyn}' />");
            setRadioValue("lctrEvlyn", "<c:out value='${sbjctVO.lctrEvlyn}' />");
            setRadioValue("crdts", "<c:out value='${sbjctVO.crdts}' />");

            setDateFields(ATNDLC_APLY_SDTTM, "#apply_start_dt", "#atndlcAplySdttm");
            setDateFields(ATNDLC_APLY_EDTTM, "#apply_end_dt", "#atndlcAplyEdttm");
            setDttmFields(AUDIT_EDTTM, "#audit_end_dt", "#audit_end_tm", "#auditEdttm");
            setDateFields(MRK_PROC_SDTTM, "#grade_start_dt", "#mrkProcSdttm");
            setDateFields(MRK_PROC_EDTTM, "#grade_end_dt", "#mrkProcEdttm");
            setDateFields(RVW_SDTTM, "#review_start_dt", "#rvwSdttm");
            setDateFields(RVW_EDTTM, "#review_end_dt", "#rvwEdttm");
            setModifyDttmFields();
            refreshChosen($("#sel_division"));
            initOfringControls();
        }

        // radio 항목을 지정한 값으로 선택한다.
        function setRadioValue(name, value) {
            if(value) {
                $("input[name='" + name + "'][value='" + escapeSelectorValue(value) + "']").prop("checked", true);
            }
        }

        // 과목 선택 박스를 비우고 chosen UI를 갱신한다.
        function clearSubjectOptions() {
            $("#sel_subject").html(buildDefaultOption(SUBJECT_SELECT_TEXT)); // 과목 선택
            refreshChosen($("#sel_subject"));
            if(!(MODE == "E" && INITIALIZING)) {
                clearSubjectAutoFields();
            }
        }

        // 과목 선택 시 자동 입력되는 화면 항목을 초기화한다.
        function clearSubjectAutoFields() {
            $("#selectedSbjctTmpltId").val("");
            $("#sbjctCd").val("");
            $("#sbjctnm").val("");
        }

        // 선택된 학기기수에 등록된 과목템플릿 목록을 조회한다.
        function fetchSubjectOptions() {
            var smstrChrtId = $("#smstrChrtId").val();
            var orgId = $("#selectOrg").val();

            clearSubjectOptions();
            if(!orgId || !smstrChrtId) {
                return;
            }

            $.ajax({
                url: "/crs/sbjctOfring/admSbjctTmpltOfringList.do",
                data: {
                    orgId: orgId,
                    smstrChrtId: smstrChrtId
                },
                success: function(res) {
                    renderSubjectOptions(res.result > 0 ? (res.returnList || []) : []);
                },
                error: function(xhr) {
                    console.log(xhr);
                    clearSubjectOptions();
                }
            });
        }

        // 초기 로딩 중 학기기수가 준비된 뒤 과목 목록을 조회한다.
        function tryFetchInitialSubjectOptions() {
            if(!INITIALIZING || !SMSTR_CHRT_READY) {
                return;
            }
            if(!$("#selectOrg").val() || !$("#smstrChrtId").val()) {
                return;
            }
            fetchSubjectOptions();
        }

        // 조회된 과목템플릿 목록을 과목 선택 박스에 렌더링한다.
        function renderSubjectOptions(subjectList) {
            var html = buildDefaultOption(SUBJECT_SELECT_TEXT); // 과목 선택

            subjectList.forEach(function(v) {
                if(!v.sbjctTmpltId || !v.sbjctnm) {
                    return;
                }
                html += '<option value="' + escapeHtml(v.sbjctTmpltId) + '"';
                html += ' data-sbjctnm="' + escapeHtml(v.sbjctnm) + '"';
                html += ' data-sbjct-cd="' + escapeHtml(v.sbjctCd || '') + '"';
                html += ' data-lctr-gbncd="' + escapeHtml(v.lctrGbncd || '') + '"';
                html += '>';
                if(v.sbjctCd) {
                    html += '[' + escapeHtml(v.sbjctCd) + '] ';
                }
                html += escapeHtml(v.sbjctnm);
                html += '</option>';
            });

            $("#sel_subject").html(html);
            selectCurrentSubjectOption();
            refreshChosen($("#sel_subject"));
            INITIALIZING = false;
        }

        // 수정모드에서 현재 과목코드/과목명과 일치하는 과목템플릿 선택값을 보조로 세팅한다.
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

        // 선택한 과목템플릿의 값을 개설과목 기본 항목에 반영한다.
        function applySelectedSubject() {
            var $selectedOption = $("#sel_subject option:selected");
            var sbjctTmpltId = $("#sel_subject").val();
            var lctrGbncd = $selectedOption.attr("data-lctr-gbncd") || "";

            if(!sbjctTmpltId) {
                clearSubjectAutoFields();
                return;
            }

            $("#selectedSbjctTmpltId").val(sbjctTmpltId);
            $("#sbjctCd").val($selectedOption.attr("data-sbjct-cd") || "");
            $("#sbjctnm").val($selectedOption.attr("data-sbjctnm") || "");
            if(lctrGbncd) {
                $("input[name=lctrGbncd][value='" + escapeSelectorValue(lctrGbncd) + "']").prop("checked", true);
            }
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
                html += ' data-smstr-chrt-gbncd="' + escapeHtml(v.smstrChrtGbncd || '') + '"';
                html += ' data-smstr-chrt-lctr-sdttm="' + escapeHtml(v.smstrChrtLctrSdttm || '') + '"';
                html += ' data-smstr-chrt-lctr-edttm="' + escapeHtml(v.smstrChrtLctrEdttm || '') + '"';
                html += ' data-smstr-chrt-late-recg-dttm="' + escapeHtml(v.smstrChrtLateRecgDttm || '') + '">';
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
                clearSmstrChrtDttmFields();
                clearLctrPrvwWknoOptions();
                clearSubjectOptions();
                $selYrSmstr.html("");
                $selYrSmstr.prop("disabled", true);
                refreshChosen($selYrSmstr);
                return;
            }

            $("#smstrChrtId").val(smstrChrtId || "");
            $("#sbjctYr").val(dgrsYr);
            $("#sbjctSmstr").val(dgrsSmstrChrt);
            applyFixedSbjctTycd();
            if(MODE == "E" && INITIALIZING) {
                setModifyDttmFields();
            } else {
                setSmstrChrtDttmFields($selectedOption);
            }
            $selYrSmstr.html('<option value="' + escapeHtml(smstrChrtId || '') + '">' + escapeHtml(yrSmstrnm) + '</option>');
            $selYrSmstr.val(smstrChrtId || "");
            $selYrSmstr.prop("disabled", true);
            refreshChosen($selYrSmstr);

            fetchLctrPrvwWknoList(smstrChrtId);
            SMSTR_CHRT_READY = true;
            if(INITIALIZING) {
                tryFetchInitialSubjectOptions();
            } else {
                fetchSubjectOptions();
            }
        }

        // 학기유형, 년도, 학기/기수 선택 박스를 초기화한다.
        function clearSmstrChrtSelects() {
            $("#sel_term_type").html(buildDefaultOption(SMSTR_CHRT_SELECT_TEXT)); // 학기/기수 명 선택
            $("#sel_yr_smstr").html("");
            $("#smstrChrtId").val("");
            $("#sbjctYr").val("");
            $("#sbjctSmstr").val("");
            applyFixedSbjctTycd();
            clearSmstrChrtDttmFields();
            clearLctrPrvwWknoOptions();
            clearSubjectOptions();
            $("#sel_yr_smstr").prop("disabled", true);
            refreshChosen($("#sel_term_type"));
            refreshChosen($("#sel_yr_smstr"));
        }

        // 선택된 학기기수의 강의/지각 일시를 화면에 세팅한다.
        function setSmstrChrtDttmFields($selectedOption) {
            setDttmFields($selectedOption.attr("data-smstr-chrt-lctr-sdttm"), "#lec_start_dt", "#lec_start_tm", "#sbjctLctrSdttm");
            setDttmFields($selectedOption.attr("data-smstr-chrt-lctr-edttm"), "#lec_end_dt", "#lec_end_tm", "#sbjctLctrEdttm");
            setDttmFields($selectedOption.attr("data-smstr-chrt-late-recg-dttm"), "#late_end_dt", "#late_end_tm", "#sbjctLateRecgDttm");
        }

        // 수정모드에서 저장된 기간/일시 값을 화면 입력값으로 세팅한다.
        function setModifyDttmFields() {
            setDttmFields(SBJCT_LCTR_SDTTM, "#lec_start_dt", "#lec_start_tm", "#sbjctLctrSdttm");
            setDttmFields(SBJCT_LCTR_EDTTM, "#lec_end_dt", "#lec_end_tm", "#sbjctLctrEdttm");
            setDttmFields(SBJCT_LATE_RECG_DTTM, "#late_end_dt", "#late_end_tm", "#sbjctLateRecgDttm");
        }

        // 학기기수 변경 시 자동 세팅된 강의/지각 일시 값을 초기화한다.
        function clearSmstrChrtDttmFields() {
            $("#lec_start_dt, #lec_start_tm, #lec_end_dt, #lec_end_tm, #late_end_dt, #late_end_tm").val("");
            $("#sbjctLctrSdttm, #sbjctLctrEdttm, #sbjctLateRecgDttm").val("");
        }

        // yyyyMMddHHmmss 값을 날짜와 시간 입력값으로 분리한다.
        function setDttmFields(dttm, dateSelector, timeSelector, hiddenSelector) {
            var parts = splitDttm(dttm);
            $(dateSelector).val(parts.date);
            $(timeSelector).val(parts.time);
            $(hiddenSelector).val(parts.value);
        }

        // yyyyMMddHHmmss 값을 날짜 입력값으로 분리한다.
        function setDateFields(dttm, dateSelector, hiddenSelector) {
            var parts = splitDttm(dttm);
            $(dateSelector).val(parts.date);
            $(hiddenSelector).val(parts.value);
        }

        // yyyyMMddHHmmss 값을 화면 표시용 날짜/시간으로 변환한다.
        function splitDttm(dttm) {
            var value = String(dttm || "").replace(/[^0-9]/g, "");
            if(value.length != 14) {
                return {
                    date: "",
                    time: "",
                    value: ""
                };
            }

            return {
                date: value.substring(0, 4) + "-" + value.substring(4, 6) + "-" + value.substring(6, 8),
                time: value.substring(8, 10) + ":" + value.substring(10, 12),
                value: value
            };
        }

        // 선택된 학기기수의 일정 주차 목록을 조회한다.
        function fetchLctrPrvwWknoList(smstrChrtId) {
            clearLctrPrvwWknoOptions();
            if(!smstrChrtId) {
                return;
            }

            $.ajax({
                url: "/crs/sbjctOfring/admSmstrChrtSchdlWknoList.do",
                method: "POST",
                data: {
                    orgId: $("#selectOrg").val(),
                    smstrChrtId: smstrChrtId
                },
                dataType: "json",
                success: function(res) {
                    renderLctrPrvwWknoOptions(res.result > 0 ? (res.returnList || []) : []);
                },
                error: function(xhr) {
                    console.log(xhr);
                }
            });
        }

        // 강의미리보기주차 선택 박스를 학기기수 일정 주차로 구성한다.
        function renderLctrPrvwWknoOptions(weekList) {
            var html = buildDefaultOption(WEEK_SELECT_TEXT); // 주차 선택
            var optionCount = 0;
            weekList.forEach(function(v) {
                var wkno = v.schdlWkno;
                if(wkno == null || wkno === "") {
                    return;
                }

                html += '<option value="' + escapeHtml(wkno) + '"';
                if(String(wkno) == String(LCTR_PRVW_WKNO)) {
                    html += ' selected';
                }
                html += '>' + escapeHtml(wkno) + escapeHtml(WEEK_SUFFIX_TEXT) + '</option>'; // 주차
                optionCount++;
            });

            $("#lctrPrvwWkno").html(html);
            if(LCTR_PRVW_WKNO) {
                $("#lctrPrvwWkno").val(LCTR_PRVW_WKNO);
            }
            $("#lctrPrvwWkno").prop("disabled", optionCount == 0);
            refreshChosen($("#lctrPrvwWkno"));
        }

        // 강의미리보기주차 선택 박스를 초기화한다.
        function clearLctrPrvwWknoOptions() {
            $("#lctrPrvwWkno").html(buildDefaultOption(WEEK_SELECT_TEXT)); // 주차 선택
            $("#lctrPrvwWkno").prop("disabled", true);
            refreshChosen($("#lctrPrvwWkno"));
        }

        // 저장 전 화면 날짜/시간 입력값을 VO 필드에 맞춘다.
        function syncSbjctOfringForm() {
            var $selectedOption = $("#sel_term_type option:selected");
            $("#orgId").val($("#selectOrg").val());
            $("#smstrChrtId").val($selectedOption.attr("data-smstr-chrt-id") || "");
            $("#sbjctYr").val($selectedOption.attr("data-dgrs-yr") || "");
            $("#sbjctSmstr").val($selectedOption.attr("data-dgrs-smstr-chrt") || "");
            applyFixedSbjctTycd();
            $("#atndlcAplySdttm").val(toDttm($("#apply_start_dt").val(), "0000"));
            $("#atndlcAplyEdttm").val(toDttm($("#apply_end_dt").val(), "2359"));
            $("#sbjctLctrSdttm").val(toDttm($("#lec_start_dt").val(), $("#lec_start_tm").val()));
            $("#sbjctLctrEdttm").val(toDttm($("#lec_end_dt").val(), $("#lec_end_tm").val()));
            $("#sbjctLateRecgDttm").val(toDttm($("#late_end_dt").val(), $("#late_end_tm").val()));
            $("#auditEdttm").val(toDttm($("#audit_end_dt").val(), $("#audit_end_tm").val()));
            $("#mrkProcSdttm").val(toDttm($("#grade_start_dt").val(), "0000"));
            $("#mrkProcEdttm").val(toDttm($("#grade_end_dt").val(), "2359"));
            if($("input[name=rvwPsblGbncd]:checked").val() == "PRD_STNG") {
                $("#rvwSdttm").val(toDttm($("#review_start_dt").val(), "0000"));
                $("#rvwEdttm").val(toDttm($("#review_end_dt").val(), "2359"));
            } else {
                $("#rvwSdttm").val("");
                $("#rvwEdttm").val("");
            }
            if($("input[name=evlGbncd]:checked").val() != "PASSFAIL") {
                $("#passfailScr").val("");
            }
            if($("input[name=limitYn]:checked").val() != "Y") {
                $("#atndlcQuota").val("0");
            }
        }

        // 개설과목 신규등록 전에는 다음 단계로 이동하지 않는다.
        function canMoveOfringStep() {
            return MODE == "E" && !!SBJCT_ID;
        }

        // 선택된 수강인증상태 코드를 반환한다.
        function getSelectedAtndlcCertStscd() {
            return $("input[name=atndlcCertStscd]:checked").val() || ATNDLC_CERT_STSCD;
        }

        // 수강인증상태가 승인인 경우에만 후속 단계로 이동한다.
        function canEnterOfringNextStep() {
            return getSelectedAtndlcCertStscd() == APPROVE_CERT_STSCD;
        }

        // 과목개설 단계 화면으로 이동한다.
        function moveOfringStep(stepNo) {
            if(stepNo == 1) {
                if(SBJCT_ID) {
                    viewSbjctOfringRegist(SBJCT_ID);
                }
                return;
            }
            if(!canMoveOfringStep()) {
                UiComm.showMessage(SAVE_BEFORE_NEXT_TEXT, "warning");
                return;
            }
            if(!canEnterOfringNextStep()) {
                UiComm.showMessage(APPROVE_REQUIRED_TEXT, "warning");
                return;
            }
            if(stepNo == 2) {
                viewSbjctOfringSchdlRegist(SBJCT_ID);
            } else if(stepNo == 3) {
                viewSbjctOfringAdmRegist(SBJCT_ID);
            } else if(stepNo == 4) {
                viewSbjctOfringStdntRegist(SBJCT_ID);
            }
        }

        // 다음 단계로 이동한다.
        function onNext() {
            moveOfringStep(2);
        }

        // yyyy.MM.dd 또는 yyyy-MM-dd와 HH:mm 값을 yyyyMMddHHmmss로 변환한다.
        function toDttm(dateValue, timeValue) {
            var date = String(dateValue || "").replace(/[^0-9]/g, "");
            var time = String(timeValue || "").replace(/[^0-9]/g, "");
            if(!date) {
                return "";
            }
            if(time.length < 4) {
                time = time || "0000";
            }
            return date + time.substring(0, 4) + "00";
        }

        // 학기/기수 응답 객체에서 학기유형 표시명을 가져온다.
        function getSmstrChrtnm(item) {
            return item.smstrChrtnm || item.smstrChrtNm || '';
        }

        // 동적으로 변경된 select 값을 chosen UI에 반영한다.
        function refreshChosen($select) {
            $select.trigger("chosen:updated");
        }

        // 선택 박스의 기본 안내 옵션을 생성한다.
        function buildDefaultOption(text) {
            return '<option value="">' + escapeHtml(text) + '</option>';
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
            var dgrsYr = getDgrsYr(item);
            var dgrsSmstrChrt = getDgrsSmstrChrt(item);
            if(!dgrsYr || !dgrsSmstrChrt) {
                return '';
            }

            if(item.smstrChrtGbncd == 'SMSTR') {
                return dgrsYr + '<spring:message code="common.year"/>' + ' ' + dgrsSmstrChrt + '<spring:message code="common.term"/>'; // 년도, 학기
            }
            return dgrsYr + '<spring:message code="common.year"/>' + ' ' + dgrsSmstrChrt + '<spring:message code="contents.label.cohort.unit"/>'; // 년도, 기수
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

                    <!-- 과목 개설 과정 -->
                    <div class="step-process-wrap mb40">
                        <div class="board_card_list">
                            <div class="card_item active">
                                <a href="javascript:void(0);" onclick="moveOfringStep(1); return false;">
                                    <span class="step-num">1</span>
                                    <spring:message code="crs.sbjct.ofring.step.info.regist"/><%--개설과목 정보등록--%>
                                </a>
                            </div>
                            <div class="card_item">
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

                    <form id="sbjctOfringWriteForm" onsubmit="return false;" autocomplete="off">
                        <input type="hidden" id="sbjctId" name="sbjctId" value="<c:out value='${sbjctVO.sbjctId}' />" />
                        <input type="hidden" id="orgId" name="orgId" value="<c:out value='${orgId}' />" />
                        <input type="hidden" id="smstrChrtId" name="smstrChrtId" value="<c:out value='${sbjctVO.smstrChrtId}' />" />
                        <input type="hidden" id="sbjctYr" name="sbjctYr" value="<c:out value='${sbjctVO.sbjctYr}' />" />
                        <input type="hidden" id="sbjctSmstr" name="sbjctSmstr" value="<c:out value='${sbjctVO.sbjctSmstr}' />" />
                        <input type="hidden" id="sbjctTycd" name="sbjctTycd" value="<c:out value='${sbjctVO.sbjctTycd}' />" />
                        <input type="hidden" id="atndlcAplySdttm" name="atndlcAplySdttm" />
                        <input type="hidden" id="atndlcAplyEdttm" name="atndlcAplyEdttm" />
                        <input type="hidden" id="sbjctLctrSdttm" name="sbjctLctrSdttm" />
                        <input type="hidden" id="sbjctLctrEdttm" name="sbjctLctrEdttm" />
                        <input type="hidden" id="sbjctLateRecgDttm" name="sbjctLateRecgDttm" />
                        <input type="hidden" id="auditEdttm" name="auditEdttm" />
                        <input type="hidden" id="mrkProcSdttm" name="mrkProcSdttm" />
                        <input type="hidden" id="mrkProcEdttm" name="mrkProcEdttm" />
                        <input type="hidden" id="rvwSdttm" name="rvwSdttm" />
                        <input type="hidden" id="rvwEdttm" name="rvwEdttm" />
                        <input type="hidden" id="selectedSbjctTmpltId" name="sbjctTmpltId" />
                        <input type="hidden" id="sbjctCd" name="sbjctCd" value="<c:out value='${sbjctVO.sbjctCd}' />" />

                        <!-- 개설 과목 정보 -->
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
                                            <div class="form-row">
                                                <select class="form-select chosen w200" id="selectOrg" name="selectOrg" title="<spring:message code='common.label.org'/><%--기관--%> <spring:message code='sys.button.select'/><%--선택--%>" required="true">
                                                    <c:forEach var="org" items="${orgList}">
                                                        <option value="${org.orgId}"><c:out value="${org.orgnm}" /></option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="req"><spring:message code="common.term.cohort.name"/><%--학기/기수 명--%></th>
                                        <td>
                                            <div class="form-inline">
                                                <select class="form-select chosen w200" id="sel_term_type" name="sel_term_type" title="<spring:message code='common.term.cohort.name'/><%--학기/기수 명--%> <spring:message code='sys.button.select'/><%--선택--%>" required="true">
                                                    <option value=""><spring:message code='common.term.cohort.name'/><%--학기/기수 명--%> <spring:message code='sys.button.select'/><%--선택--%></option>
                                                </select>
                                                <select class="form-select chosen w200" id="sel_yr_smstr" name="sel_yr_smstr" title="<spring:message code='crs.label.year.term.cohort'/><%--년도/학기(기수)--%>" disabled="disabled"></select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><spring:message code='crs.label.subject.type'/><%--과목분류--%></th>
                                        <td>
                                            <div class="form-inline" id="sbjctTycdArea">
                                                <c:forEach var="code" items="${sbjctTycdList}" varStatus="status">
                                                    <span class="custom-input ${status.first ? '' : 'ml5'}">
                                                        <input type="radio" name="sbjctTycdView" id="sbjctTycd_${status.index}" value="${code.cd}" <c:if test="${code.cd eq sbjctVO.sbjctTycd}">checked</c:if> disabled="disabled">
                                                        <label for="sbjctTycd_${status.index}"><c:out value="${code.cdnm}" /></label>
                                                    </span>
                                                </c:forEach>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="sel_subject" class="req"><spring:message code='crs.label.crecrs'/><%--과목--%></label></th>
                                        <td>
                                            <div class="form-row align-items-center">
                                                <select class="form-select chosen w200" id="sel_subject" required="true">
                                                    <option value=""><spring:message code='crs.label.crecrs'/><%--과목--%> <spring:message code='sys.button.select'/><%--선택--%></option>
                                                </select>
                                                <span class="ml5"><spring:message code='crs.sbjct.ofring.desc.subject.tmplt.list'/><%--( 과목등록에서 등록된 과목 목록 )--%></span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="sbjctnm" class="req"><spring:message code='crs.sbjct.ofring.label.subject.ko'/><%--과목명(KO)--%></label></th>
                                        <td>
                                            <div class="form-row align-items-center">
                                                <input class="form-control" type="text" name="sbjctnm" id="sbjctnm" value="<c:out value='${sbjctVO.sbjctnm}' />" placeholder="<spring:message code='crs.sbjct.ofring.label.subject.ko'/><%--과목명(KO)--%> <spring:message code='crs.sbjct.ofring.label.input'/><%--입력--%>" inputmask="byte" maxLen="200" required="true" />
                                                <span class="ml5"><spring:message code='crs.sbjct.ofring.desc.subject.auto.input'/><%--( 과목 선택 시 자동입력 )--%></span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="sbjctEnnm"><spring:message code='crs.sbjct.ofring.label.subject.en'/><%--과목명(EN)--%></label></th>
                                        <td>
                                            <div class="form-row">
                                                <input class="form-control" type="text" name="sbjctEnnm" id="sbjctEnnm" value="<c:out value='${sbjctVO.sbjctEnnm}' />" placeholder="<spring:message code='crs.sbjct.ofring.label.subject.en'/><%--과목명(EN)--%> <spring:message code='crs.sbjct.ofring.label.input'/><%--입력--%>" inputmask="byte" maxLen="200" />
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="sel_division" class="req"><spring:message code='crs.label.decls'/><%--분반--%></label></th>
                                        <td>
                                            <div class="form-row align-items-center">
                                                <select id="sel_division" name="dvclasNo" class="form-select compact" required="true">
                                                    <option value=""><spring:message code='crs.label.decls'/><%--분반--%> <spring:message code='sys.button.select'/><%--선택--%></option>
                                                    <c:forEach var="no" begin="1" end="10">
                                                        <option value="${no}" ${sbjctVO.dvclasNo eq no ? 'selected' : ''}>${no}<spring:message code='crs.label.dvclas.suffix'/><%--반--%></option>
                                                    </c:forEach>
                                                </select>
                                                <span class="ml5"><spring:message code='crs.sbjct.ofring.desc.dvclas.range'/><%--( 분반 : 1반 ~ 10반까지 사용 가능 )--%></span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="dvclasNcknm" class="req"><spring:message code='crs.sbjct.ofring.label.dvclas.alias'/><%--분반 별칭--%></label></th>
                                        <td>
                                            <div class="form-inline">
                                                <input class="form-control mr5" type="text" name="dvclasNcknm" id="dvclasNcknm" value="<c:out value='${sbjctVO.dvclasNcknm}' />" placeholder="<spring:message code='crs.sbjct.ofring.label.dvclas.alias'/><%--분반 별칭--%> <spring:message code='crs.sbjct.ofring.label.input'/><%--입력--%>" inputmask="byte" maxLen="200" required="true" />
                                                <span class="ml5"><spring:message code='crs.sbjct.ofring.desc.dvclas.alias.default'/><%--( 기본 : 일반분반 )--%></span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="req"><spring:message code='crs.label.course.division'/><%--과정구분--%></th>
                                        <td>
                                            <div class="form-inline" id="crsGbncdArea">
                                                <c:forEach var="code" items="${crsGbncdList}" varStatus="status">
                                                    <span class="custom-input ${status.first ? '' : 'ml5'}">
                                                        <input type="radio" name="crsGbncd" id="crsGbncd_${status.index}" value="${code.cd}" ${status.first ? 'checked' : ''}>
                                                        <label for="crsGbncd_${status.index}"><c:out value="${code.cdnm}" /></label>
                                                    </span>
                                                </c:forEach>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="req"><spring:message code='crs.label.crsopertypecd'/><%--강의형태--%></th>
                                        <td>
                                            <div class="form-inline align-items-center">
                                                <div class="form-inline" id="lctrGbncdArea">
                                                    <c:forEach var="code" items="${lctrGbncdList}" varStatus="status">
                                                        <span class="custom-input ${status.first ? '' : 'ml5'}">
                                                            <input type="radio" name="lctrGbncd" id="lctrGbncd_${status.index}" value="${code.cd}" ${status.first ? 'checked' : ''}>
                                                            <label for="lctrGbncd_${status.index}"><c:out value="${code.cdnm}" /></label>
                                                        </span>
                                                    </c:forEach>
                                                </div>
                                                <span class="ml5"><spring:message code='crs.sbjct.ofring.desc.lctr.gbncd.auto.check'/><%--( 과목 선택 시 자동체크 )--%></span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="sbjctExpln" class="req"><spring:message code='crs.lecture.explain'/><%--과목설명--%></label></th>
                                        <td>
                                            <div class="editor-box">
                                                <textarea id="sbjctExpln" name="sbjctExpln"><c:out value='${sbjctVO.sbjctExpln}' /></textarea>
                                                <script>
                                                    // HTML 에디터
                                                    let editor = UiEditor({
                                                        targetId: "sbjctExpln",
                                                        height: "240px"
                                                    });
                                                </script>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="req"><spring:message code='crs.label.credit'/><%--학점--%></th>
                                        <td>
                                            <div class="form-inline">
                                                <c:forEach var="credit" begin="1" end="4">
                                                    <span class="custom-input ${credit == 1 ? '' : 'ml5'}">
                                                        <input type="radio" name="crdts" id="crdts_${credit}" value="${credit}" ${credit == 1 ? 'checked' : ''}>
                                                        <label for="crdts_${credit}">${credit}<spring:message code='crs.sbjct.ofring.label.credit.point'/><%--점--%></label>
                                                    </span>
                                                </c:forEach>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="req"><spring:message code='crs.label.compdv'/><%--이수구분--%></th>
                                        <td>
                                            <div class="form-inline" id="cmcrsGbncdArea">
                                                <c:forEach var="code" items="${cmcrsGbncdList}" varStatus="status">
                                                    <span class="custom-input ${status.first ? '' : 'ml5'}">
                                                        <input type="radio" name="cmcrsGbncd" id="cmcrsGbncd_${status.index}" value="${code.cd}" ${status.first ? 'checked' : ''}>
                                                        <label for="cmcrsGbncd_${status.index}"><c:out value="${code.cdnm}" /></label>
                                                    </span>
                                                </c:forEach>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="req"><spring:message code='common.use.yn'/><%--사용여부--%></th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" name="useyn" id="useY" value="Y" checked />
                                                    <label for="useY"><spring:message code='common.use'/><%--사용--%></label>
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" name="useyn" id="useN" value="N" />
                                                    <label for="useN"><spring:message code='common.use.not'/><%--사용 안 함--%></label>
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="req"><spring:message code='crs.sbjct.ofring.label.lctr.evl'/><%--강의평가--%></th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" name="lctrEvlyn" id="lctrEvly" value="Y" checked />
                                                    <label for="lctrEvly"><spring:message code='common.use'/><%--사용--%></label>
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" name="lctrEvlyn" id="lctrEvln" value="N" />
                                                    <label for="lctrEvln"><spring:message code='common.use.not'/><%--사용 안 함--%></label>
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- 강의 정보 -->
                        <div class="box">
                            <div class="board_top">
                                <h3 class="board-title"><spring:message code="crs.sbjct.ofring.section.lctr.info"/><%--강의 정보--%></h3>
                            </div>
                            <div class="table-wrap">
                                <table class="table-type5">
                                    <colgroup>
                                        <col class="width-15per" />
                                        <col />
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th class="req"><spring:message code='crs.label.eval.method'/><%--평가방법--%></th>
                                        <td>
                                            <div class="form-inline" id="evlGbncdArea">
                                                <c:forEach var="code" items="${evlGbncdList}" varStatus="status">
                                                    <span class="custom-input ${status.first ? '' : 'ml5'}">
                                                        <input type="radio" name="evlGbncd" id="evlGbncd_${status.index}" value="${code.cd}" ${status.first ? 'checked' : ''}>
                                                        <label for="evlGbncd_${status.index}"><c:out value="${code.cdnm}" /></label>
                                                    </span>
                                                </c:forEach>
                                            </div>
                                            <div class="form-inline mt5" id="passfailScrArea" style="display:none;">
                                                <div class="input_btn">
                                                    <input type="text" id="passfailScr" name="passfailScr" class="form-control w60" value="<c:out value='${sbjctVO.passfailScr}' />" inputmask="numeric" mask="999.9" maxVal="100" disabled="disabled" />
                                                    <label for="passfailScr"><spring:message code="crs.sbjct.ofring.label.credit.point"/><%--점--%></label>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="req"><spring:message code='crs.study.form'/><%--강의 형식--%></th>
                                        <td><div class="form-inline" id="lctrFrmtGbncdArea">
                                            <c:forEach var="code" items="${lctrFrmtGbncdList}" varStatus="status">
                                                <span class="custom-input ${status.first ? '' : 'ml5'}">
                                                    <input type="radio" name="lctrFrmtGbncd" id="lctrFrmtGbncd_${status.index}" value="${code.cd}" ${status.first ? 'checked' : ''}>
                                                    <label for="lctrFrmtGbncd_${status.index}"><c:out value="${code.cdnm}" /></label>
                                                </span>
                                            </c:forEach>
                                        </div></td>
                                    </tr>
                                    <tr>
                                        <th class="req"><spring:message code='crs.study.control'/><%--학습제어--%></th>
                                        <td><div class="form-inline" id="lrnCntrlGbncdArea">
                                            <c:forEach var="code" items="${lrnCntrlGbncdList}" varStatus="status">
                                                <span class="custom-input ${status.first ? '' : 'ml5'}">
                                                    <input type="radio" name="lrnCntrlGbncd" id="lrnCntrlGbncd_${status.index}" value="${code.cd}" ${status.first ? 'checked' : ''}>
                                                    <label for="lrnCntrlGbncd_${status.index}"><c:out value="${code.cdnm}" /></label>
                                                </span>
                                            </c:forEach>
                                        </div></td>
                                    </tr>
                                    <tr>
                                        <th><label for="lctrPrvwWkno" class="req"><spring:message code='crs.sbjct.ofring.label.lctr.prvw.wkno'/><%--강의미리보기주차--%></label></th>
                                        <td>
                                            <div class="form-row align-items-center">
                                                <select class="form-select chosen compact" id="lctrPrvwWkno" name="lctrPrvwWkno" disabled="disabled" required="true">
                                                    <option value=""><spring:message code='crs.sbjct.ofring.label.week'/><%--주차--%> <spring:message code='sys.button.select'/><%--선택--%></option>
                                                </select>
                                                <span class="ml5"><spring:message code='crs.sbjct.ofring.desc.lctr.prvw'/><%--( 설정 주차의 강의동영상이 강의맛보기로 설정됩니다. )--%></span>
                                            </div>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- 수강 신청 정보 -->
                        <div class="box">
                            <div class="board_top">
                                <h3 class="board-title"><spring:message code="crs.sbjct.ofring.section.atndlc.info"/><%--수강 신청 정보--%></h3>
                            </div>
                            <div class="table-wrap">
                                <table class="table-type5">
                                    <colgroup>
                                        <col class="width-15per" />
                                        <col />
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th class="req"><spring:message code='crs.request.method'/><%--신청 방법--%></th>
                                        <td><div class="form-inline" id="atndlcAplyMthdCdArea">
                                            <c:forEach var="code" items="${atndlcAplyMthdCdList}" varStatus="status">
                                                <span class="custom-input ${status.first ? '' : 'ml5'}">
                                                    <input type="radio" name="atndlcAplyMthdCd" id="atndlcAplyMthdCd_${status.index}" value="${code.cd}" ${status.first ? 'checked' : ''}>
                                                    <label for="atndlcAplyMthdCd_${status.index}"><c:out value="${code.cdnm}" /></label>
                                                </span>
                                            </c:forEach>
                                        </div></td>
                                    </tr>
                                    <tr>
                                        <th class="req"><spring:message code='crs.certification.status'/><%--인증상태--%></th>
                                        <td><div class="form-inline" id="atndlcCertStscdArea">
                                            <c:forEach var="code" items="${atndlcCertStscdList}" varStatus="status">
                                                <span class="custom-input ${status.first ? '' : 'ml5'}">
                                                    <input type="radio" name="atndlcCertStscd" id="atndlcCertStscd_${status.index}" value="${code.cd}" ${status.first ? 'checked' : ''}>
                                                    <label for="atndlcCertStscd_${status.index}"><c:out value="${code.cdnm}" /></label>
                                                </span>
                                            </c:forEach>
                                        </div></td>
                                    </tr>
                                    <tr>
                                        <th class="req"><spring:message code='crs.sbjct.ofring.label.limit.yn'/><%--인원제한--%></th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" name="limitYn" id="limitY" value="Y" />
                                                    <label for="limitY"><spring:message code='crs.sbjct.ofring.label.yes'/><%--예--%></label>
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" name="limitYn" id="limitN" value="N" checked />
                                                    <label for="limitN"><spring:message code='crs.sbjct.ofring.label.no'/><%--아니오--%></label>
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="atndlcQuota" class="req"><spring:message code='crs.sbjct.ofring.label.limit.count'/><%--제한 인원--%></label></th>
                                        <td>
                                            <div class="form-row">
                                                <div class="input_btn">
                                                    <input class="form-control sm" id="atndlcQuota" name="atndlcQuota" type="text" value="<c:out value='${sbjctVO.atndlcQuota}' />" maxlength="5" inputmask="integer" required="true" />
                                                    <label for="atndlcQuota"><spring:message code='crs.sbjct.ofring.label.person'/><%--명--%></label>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- 강의 기간 정보 -->
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
                                        <th class="req"><spring:message code='crs.lecture.request.period'/><%--수강 신청 기간--%></th>
                                        <td>
                                            <div class="form-inline">
                                                <div class="date_area">
                                                    <input type="text" placeholder="<spring:message code='crs.sbjct.ofring.placeholder.start.day'/><%--시작일--%>" id="apply_start_dt" class="datepicker" toDate="apply_end_dt" required="true" />
                                                    <span class="txt-sort">~</span>
                                                    <input type="text" placeholder="<spring:message code='crs.sbjct.ofring.placeholder.end.day'/><%--종료일--%>" id="apply_end_dt" class="datepicker" fromDate="apply_start_dt" required="true" />
                                                </div>
                                                <span class="ml5"><spring:message code='crs.sbjct.ofring.desc.atndlc.aply.auto'/><%--( 관리자 > 수업운영도구 > 과정관리 > 업무일정관리 > 수강신청기간 자동설정 )--%></span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="req"><spring:message code='common.label.lecture.period'/><%--강의 기간--%></th>
                                        <td>
                                            <div class="date_area">
                                                <input type="text" placeholder="<spring:message code='crs.sbjct.ofring.placeholder.start.day'/><%--시작일--%>" id="lec_start_dt" class="datepicker" toDate="lec_end_dt" timeId="lec_start_tm" required="true" />
                                                <input type="text" placeholder="<spring:message code='crs.sbjct.ofring.placeholder.hour.minute'/><%--시:분--%>" id="lec_start_tm" class="timepicker" dateId="lec_start_dt" required="true" />
                                                <span class="txt-sort">~</span>
                                                <input type="text" placeholder="<spring:message code='crs.sbjct.ofring.placeholder.end.day'/><%--종료일--%>" id="lec_end_dt" class="datepicker" fromDate="lec_start_dt" timeId="lec_end_tm" required="true" />
                                                <input type="text" placeholder="<spring:message code='crs.sbjct.ofring.placeholder.hour.minute'/><%--시:분--%>" id="lec_end_tm" class="timepicker" dateId="lec_end_dt" required="true" />
                                                <span class="ml5"><spring:message code='crs.sbjct.ofring.desc.lctr.period.auto'/><%--( 학기 정보 > 강의기간 자동설정 )--%></span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="req"><spring:message code='crs.sbjct.ofring.label.late.recg.dttm'/><%--지각 인정 일시--%></th>
                                        <td>
                                            <div class="form-inline">
                                                <div class="date_area">
                                                    <input type="text" placeholder="<spring:message code='crs.sbjct.ofring.placeholder.end.day'/><%--종료일--%>" id="late_end_dt" class="datepicker" timeId="late_end_tm" required="true" />
                                                    <input type="text" placeholder="<spring:message code='crs.sbjct.ofring.placeholder.hour.minute'/><%--시:분--%>" id="late_end_tm" class="timepicker" dateId="late_end_dt" required="true" />
                                                </div>
                                                <span class="ml5"><spring:message code='crs.sbjct.ofring.desc.late.recg.auto'/><%--( 학기 정보 > 지각인정일시 자동설정 )--%></span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="req"><spring:message code='crs.sbjct.ofring.label.audit.end.dttm'/><%--청강 종료 일시--%></th>
                                        <td>
                                            <div class="date_area">
                                                <input type="text" placeholder="<spring:message code='crs.sbjct.ofring.placeholder.end.day'/><%--종료일--%>" id="audit_end_dt" class="datepicker" timeId="audit_end_tm" required="true" />
                                                <input type="text" placeholder="<spring:message code='crs.sbjct.ofring.placeholder.hour.minute'/><%--시:분--%>" id="audit_end_tm" class="timepicker" dateId="audit_end_dt" required="true" />
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="req"><spring:message code='crs.score.process.period'/><%--성적 처리 기간--%></th>
                                        <td>
                                            <div class="form-inline">
                                                <div class="date_area">
                                                    <input type="text" placeholder="<spring:message code='crs.sbjct.ofring.placeholder.start.day'/><%--시작일--%>" id="grade_start_dt" class="datepicker" toDate="grade_end_dt" required="true" />
                                                    <span class="txt-sort">~</span>
                                                    <input type="text" placeholder="<spring:message code='crs.sbjct.ofring.placeholder.end.day'/><%--종료일--%>" id="grade_end_dt" class="datepicker" fromDate="grade_start_dt" required="true" />
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="req"><spring:message code='crs.sbjct.ofring.label.review.period'/><%--복습기간--%></th>
                                        <td>
                                            <div class="form-inline">
                                                <div class="form-inline mr10" id="rvwPsblGbncdArea">
                                                    <c:forEach var="code" items="${rvwPsblGbncdList}" varStatus="status">
                                                        <span class="custom-input ${status.first ? '' : 'ml5'}">
                                                            <input type="radio" name="rvwPsblGbncd" id="rvwPsblGbncd_${status.index}" value="${code.cd}" ${status.first ? 'checked' : ''}>
                                                            <label for="rvwPsblGbncd_${status.index}"><c:out value="${code.cdnm}" /></label>
                                                        </span>
                                                    </c:forEach>
                                                </div>
                                                <div class="date_area">
                                                    <input type="text" placeholder="<spring:message code='crs.sbjct.ofring.placeholder.start.day'/><%--시작일--%>" id="review_start_dt" class="datepicker" toDate="review_end_dt" />
                                                    <span class="txt-sort">~</span>
                                                    <input type="text" placeholder="<spring:message code='crs.sbjct.ofring.placeholder.end.day'/><%--종료일--%>" id="review_end_dt" class="datepicker" fromDate="review_start_dt" />
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
                        <button type="button" class="btn type2" onclick="viewSbjctOfringList();"><spring:message code="button.list"/><%--목록--%></button>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
