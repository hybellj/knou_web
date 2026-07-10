<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="table,editor,fileuploader"/>
	</jsp:include>

	<script type="text/javascript">
        /* Tabulator 공통 페이징 */
        var PAGE_INDEX = 1;
        var LIST_SCALE = 10;

        /**
         * 목록에서 보낸 탭 타입 (버튼)
         * 시험 ID, 시험 방식을 받게 됨.
         * 시험 방식에 따라 보여지는 레이아웃이 다르게 됨.
         */
        var curTabType              = '<c:out value="${vo.tabType}" />';
        var curExamBscId           = '<c:out value="${vo.examBscId}" />';
        var curTkexamMthdCd        = '<c:out value="${vo.tkexamMthdCd}" />';
        var curByteamSubrexamUseyn = '<c:out value="${vo.byteamSubrexamUseyn}" />';   // 팀 여부
        var hasSubSubject          = '<c:out value="${examVO.teamGrpSubsbjctUseyn}" />';  // 부 주제
        var absnceYn               = '<c:out value="${vo.absnceYn}" />';   // 결시여부
        var dsblYn                 = '<c:out value="${vo.dsblYn}" />';     // 장애여부

        /* 과제 제출용 변수 */
        var SBST_TYCD = '<c:out value="${sbstVO.sbasmtTycd}"/>';
        var sbstUploadPath = '<c:out value="${uploadPath}"/>';
        var sbstEditorInited = false;
        var sbmsnEditor = null;
        var submitDialog = null;

        /* 퀴즈 응시용 변수 */
        var QUIZ_BSC_ID      = '<c:out value="${sbstVO.quizBscId}"/>';
        var QUIZ_EXAM_DTL_ID = '<c:out value="${sbstVO.examDtlId}"/>';
        var QUIZ_TKEXAM_CNT  = ${fn:length(quizHstry)};
        var QUIZ_EPARAM      = '<c:out value="${quizEncParams}"/>';
        var quizDialog       = null;

        /*****************************************************************************
         * 팀 시험일 경우 생성되는 요소 제어 기능
         * 1. var examDtlInfoList :     examDtlInfoVO 모델 를 JS 배열로 변환
         * 2. examSubAsmtListAppend :   팀 시험 부주제 목록 HTML append
         *****************************************************************************/
        /* 1 */
		var examDtlInfoList = [
			<c:forEach var="dtlInfo" items="${examDtlInfoVO}" varStatus="st">
                {
                    teamGrpId    : '${fn:escapeXml(dtlInfo.teamGrpId)}',
                    teamGrpnm    : '${fn:escapeXml(dtlInfo.teamGrpnm)}',
                    teamId      : '${fn:escapeXml(dtlInfo.teamId)}',
                    teamnm      : '${fn:escapeXml(dtlInfo.teamnm)}',
                    ldrnm       : '${fn:escapeXml(dtlInfo.ldrnm)}',
                    examTtl     : '${fn:escapeXml(dtlInfo.examTtl)}',
                    examCts     : '${fn:escapeXml(dtlInfo.examCts)}',
                    teamMbrTot  : '${fn:escapeXml(dtlInfo.teamMbrTot)}'
                }
                <c:if test="${!st.last}">,</c:if>
			</c:forEach>
		];
		/* 2 */
		function examSubAsmtListAppend() {
			var html = "";
			if (examDtlInfoList.length > 0) {
				examDtlInfoList.forEach(function(v, i) {
                    html += "<tr>";
                    html += "	<th rowspan='3' class='group-header'><label>" + v.teamGrpnm + "</label></th>";
                    html += "	<th><label><spring:message code='exam.label.team.grp' /> <spring:message code='exam.label.team.members' /></label></th>";   /* 팀 그룹 */ /* 구성원 */
                    html += "	<td>" + v.ldrnm + " <spring:message code='exam.label.and' /> " + (v.teamMbrTot - 1) + "<spring:message code='exam.label.stdnt' /></td>";    /* 외 */ /* 명 */
                    html += "</tr>";
                    html += "<tr>";
                    html += "	<th><label><spring:message code='exam.label.sub.tpc' /></label></th>";  /* 부 주제 */
                    html += "	<td>" + UiComm.escapeHtml(v.examTtl) + "</td>";
                    html += "</tr>";
                    html += "<tr>";
                    html += "	<th><label><spring:message code='exam.label.cts' /></label></th>";  /* 내용 */
                    html += "	<td><pre>" + $("<div>").html(v.examCts).text() + "</pre></td>";
                    html += "</tr>";
				});
			}
			$("#examSubsbjctbody").append(html);
		}

        /*****************************************************************************
         * 학습자 과제 제출기록 관련 기능
         * 1. var asmtSbmsnHstryList :             asmtHstry 모델 -> JS 배열로 변환
         * 2. stdntAsmtSbmsnHstryListAppend :      학습자 과제 제출기록 HTML append
         *****************************************************************************/
        /* 1 */
        var asmtSbmsnHstryList = [
            <c:forEach var="asmtHstryInfo" items="${asmtHstry}" varStatus="st">
            {
                lineNo          : '${fn:escapeXml(asmtHstryInfo.lineNo)}',
                sbmsnDttm       : '${fn:escapeXml(asmtHstryInfo.sbmsnDttm)}',
                filenm          : '${fn:escapeXml(asmtHstryInfo.filenm)}'
            }
            <c:if test="${!st.last}">,</c:if>
            </c:forEach>
        ];
        /* 2 */
        function stdntAsmtSbmsnHstryListAppend() {
            var html = "";
            if (asmtSbmsnHstryList.length > 0) {
                asmtSbmsnHstryList.forEach(function(v, i) {
                    var sbmsnDttm;
                    if (v.sbmsnDttm != '') {
                        sbmsnDttm = dateFormat("date", v.sbmsnDttm);
                    } else {
                        sbmsnDttm = "-";
                    }
                    var isEvl;
                    if (v.lineNo == 1) {
                        isEvl = "<spring:message code='exam.label.evl.trgt' />";    /* 평가대상 */
                    } else {
                        isEvl = "";
                    }
                    html += "<tr>";
                    html += "	<th><label>" + v.lineNo + "</label></th>";
                    html += "	<td><label>" + v.filenm + "</label></td>";
                    html += "	<td><label>" + sbmsnDttm + "</label></td>";
                    html += "	<td><label>" + isEvl + "</label></td>";
                    html += "</tr>";
                });
            }
            $("#tkexam-history").append(html);
        }

        /*****************************************************************************
         * 팝업 관련 기능
         * 1. fdbkPopup:        피드백 팝업
         * 2. openSubmitDialog: 과제 제출 알림창
         *****************************************************************************/
        /* 1 */
        function fdbkPopup() {
            dialog = UiDialog("dialog1", {
                title: "<spring:message code='exam.label.fdbk' />", /* 피드백 */
                width: 800,
                height: 500,
                url: "/exam/sbstAsmtFdbkPopup.do?examBscId=" + curExamBscId + "&encParams=" + EPARAM,
                autoresize: false
            });
        }
        /* 2 */
        function openSubmitDialog() {
            var submitDttm = UiComm.formatDate(getNowDttm(), "datetime2");
            var fileNames = getSubmitFileNames();
            var alimCtnt = getAlimCtnt(submitDttm, fileNames);
            var $submitDialogHtml = $($.parseHTML($("#submitDialogTemplate").html()));

            $submitDialogHtml.find("[data-dialog-submit-dttm]").text(submitDttm);
            $submitDialogHtml.find("[data-dialog-atch-files]").text(fileNames.length > 0 ? fileNames.join(", ") : "-");
            $submitDialogHtml.find("[data-dialog-alim-ctnt]").text(alimCtnt);
            $submitDialogHtml.find("[data-dialog-send-dttm]").text(submitDttm);

            submitDialog = UiDialog("submitDialog", {
                width: 700,
                height: 500,
                title: "<spring:message code='exam.label.asmt' /><spring:message code='exam.label.submit.y' /> <spring:message code='exam.label.ntfc.pop' />",   /* 과제 */ /* 제출 */ /* 알림창 */
                modal: true,
                autoresize: true,
                html: $("<div>").append($submitDialogHtml).html()
            });
        }

        /*****************************************************************************
         * 과제 제출 관련 기능
         * 1. showSbmsnForm:        과제 제출 폼 보이기
         * 2. hideSbmsnForm:        과제 제출 폼 숨기기
         * 3. submitSbst:           과제 제출 (text or file)
         * 4. submitInputTextAsmt:  과제 텍스트 내용 검증
         * 5. submitFileAsmt:       과제 파일 유무 검증
         * 6. completeSubmitDialog: 과제 알림창 닫기 이후 과제 등록
         * 7. closeSubmitDialog:    과제 제출 알림창 닫기
         * 8. getSubmitFileNames:   과제 파일이름 수집
         * 9. getInputTextValue:    과제 텍스트 추출 (제목으로 사용)
         * 10. getAlimCtnt:         과제 알림창 '제출' 시 알림용
         * 11. finishUpload:        과제 파일 업로드
         * 12. registSbstSbmsn:     과제 등록
         *****************************************************************************/
        /* 1 */
        function showSbmsnForm() {
            $("#sbmsnFormWrap").show();
            $("#sbmsnToggleBtn").hide();
            if (SBST_TYCD === "INPUT_TEXT" && !sbstEditorInited) {
                sbmsnEditor = UiEditor({
                    targetId: "sbmsnEditor",
                    uploadPath: sbstUploadPath,
                    height: "300px"
                });
                sbstEditorInited = true;
            }
        }
        /* 2 */
        function hideSbmsnForm() {
            $("#sbmsnFormWrap").hide();
            $("#sbmsnToggleBtn").show();
        }
        /* 3 */
        function submitSbst() {
            if (SBST_TYCD === "INPUT_TEXT") {
                submitInputTextAsmt();
            } else {
                submitFileAsmt();
            }
        }
        /* 4 */
        function submitInputTextAsmt() {
            var sbmsnTxt = getInputTextValue();
            if ($.trim($("<div>").html(sbmsnTxt).text()) === "") {
                UiComm.showMessage("<spring:message code='exam.alert.input.contents' />", "info");  /* 내용을 입력하세요. */
                return;
            }
            $("#sbmsnTxt").val(sbmsnTxt);
            openSubmitDialog();
        }
        /* 5 */
        function submitFileAsmt() {
            var dx = dx5.get("sbstAsmtUploader");
            if (!dx || dx.getFileCount() < 1) {
                UiComm.showMessage("<spring:message code='exam.alert.input.file' />", "info");  /* 제출 할 파일이 없습니다. */
                return;
            }
            openSubmitDialog();
        }
        /* 6 */
        function completeSubmitDialog() {
            if (SBST_TYCD === "INPUT_TEXT") {
                registSbstSbmsn();
                return;
            }
            var dx = dx5.get("sbstAsmtUploader");
            if (dx.availUpload()) {
                dx.startUpload();
            } else {
                registSbstSbmsn();
            }
        }
        /* 7 */
        function closeSubmitDialog() {
            if (submitDialog && typeof submitDialog.close === "function") {
                submitDialog.close();
                submitDialog = null;
            }
        }
        /* 8 */
        function getSubmitFileNames() {
            if (SBST_TYCD === "INPUT_TEXT") {
                return [];
            }
            var dx = dx5.get("sbstAsmtUploader");
            if (!dx || typeof dx.getItems !== "function") {
                return [];
            }
            return $.map(dx.getItems(), function(item) { return item.name; });
        }
        /* 9 */
        function getInputTextValue() {
            if (sbmsnEditor && typeof sbmsnEditor.getPublishingHtml === "function") {
                return sbmsnEditor.getPublishingHtml();
            }
            return $("#sbmsnEditor").val() || "";
        }
        /* 10 */
        function getAlimCtnt(submitDttm, fileNames) {
            var atchFileText = fileNames.length > 0 ? fileNames.join(", ") : "-";
            var sbmsnText = SBST_TYCD === "INPUT_TEXT" ? "<spring:message code='exam.label.submit.type.text' /> <spring:message code='exam.label.submit.y' />" : "<spring:message code='exam.label.file' />: " + atchFileText;    /* 텍스트 */ /* 제출 */ /* 첨부파일 */
            return "1. <spring:message code='exam.label.submit.dttm' />: " + submitDttm + "\n" /* 제출일시 */
                + "2. " + sbmsnText + "\n"
                + "<spring:message code='exam.alert.send.asmt' />";
        }
        /* 11 */
        function finishUpload() {
            var url = "/common/uploadFileCheck.do";
            var dx = dx5.get("sbstAsmtUploader");
            var param = {
                "uploadFiles": dx.getUploadFiles(),
                "uploadPath": dx.getUploadPath()
            };
            ajaxCall(url, param, function(data) {
                if (data.encParams != null && data.encParams !== "") {
                    EPARAM = data.encParams;
                }
                if (data.result > 0) {
                    $("#uploadFiles").val(dx.getUploadFiles());
                    $("#uploadPath").val(dx.getUploadPath());
                    registSbstSbmsn();
                } else {
                    UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
                }
            }, function() {
                UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
            }, true);
        }
        /* 12 */
        function registSbstSbmsn() {
            UiComm.showLoading(true);
            $.ajax({
                url: "/asmt2/stdntAsmtSbmsnRegistAjax.do",
                type: "POST",
                dataType: "json",
                data: $("#sbstAsmtSbmsnForm").serialize()
            }).done(function(data) {
                UiComm.showLoading(false);
                if (data.encParams != null && data.encParams !== "") {
                    EPARAM = data.encParams;
                }
                if (data.result > 0) {
                    closeSubmitDialog();
                    hideSbmsnForm();
                    UiComm.showMessage("<spring:message code='exam.alert.insert' />", "success").then(function() {    /* 정상 저장 되었습니다. */
                        location.reload();
                    });
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }).fail(function() {
                UiComm.showLoading(false);
                UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");
            });
        }

        /*****************************************************************************
         * 퀴즈 응시이력 관련 기능
         * 1. var quizTkexamHstryList :     quizHstry 모델 -> JS 배열로 변환
         * 2. quizTkexamHstryListAppend :   퀴즈 응시이력 HTML append
         *****************************************************************************/
        /* 1 */
        var quizTkexamHstryList = [
            <c:forEach var="hstry" items="${quizHstry}" varStatus="st">
            {
                lineNo         : '${fn:escapeXml(hstry.lineNo)}',
                examHstryGbnnm : '${fn:escapeXml(hstry.examHstryGbnnm)}',
                tkexamSdttm    : '${fn:escapeXml(hstry.tkexamSdttm)}',
                tkexamEdttm    : '${fn:escapeXml(hstry.tkexamEdttm)}',
                tkexamDrtn     : '${fn:escapeXml(hstry.tkexamDrtn)}'
            }
            <c:if test="${!st.last}">,</c:if>
            </c:forEach>
        ];
        /* 2 */
        function quizTkexamHstryListAppend() {
            var html = "";
            if (quizTkexamHstryList.length > 0) {
                quizTkexamHstryList.forEach(function(v, i) {
                    var tkexamSdttm = v.tkexamSdttm !== '' ? UiComm.formatDate(v.tkexamSdttm, "datetime2") : "-";
                    var tkexamEdttm = v.tkexamEdttm !== '' ? UiComm.formatDate(v.tkexamEdttm, "datetime2") : "-";
                    var drtnText = "-";
                    if (v.tkexamDrtn !== '') {
                        var drtn    = parseInt(v.tkexamDrtn, 10);
                        var minutes = Math.floor(drtn / 60);
                        var seconds = drtn % 60;
                        drtnText    = minutes + "<spring:message code='exam.label.min.time' /> " + seconds + "<spring:message code='exam.label.sec' />";   /* 분 */ /* 초 */
                    }
                    html += "<tr>";
                    html += "   <td>" + v.lineNo + "</td>";
                    html += "   <td>" + v.examHstryGbnnm + "</td>";
                    html += "   <td>" + tkexamSdttm + "</td>";
                    html += "   <td>" + tkexamEdttm + "</td>";
                    html += "   <td>" + drtnText + "</td>";
                    html += "</tr>";
                });
            }
            $("#quiz-tkexam-history").append(html);
        }

        /*****************************************************************************
         * 퀴즈 응시 관련 기능
         * 1. quizTkexamConfirm:    퀴즈 응시 확인 (처음/n회차 분기)
         * 2. quizTkexamPopup:      퀴즈 시험지 팝업
         * 3. exampprViewMv:        평가시험지 팝업
         * 4. closeDialog:          퀴즈 응시 팝업 닫기
         * 4. msgPop:               팝업 내부에서 부모창 오류 메시지 표시
         *****************************************************************************/
        /* 1 */
        function quizTkexamConfirm() {
            if (QUIZ_TKEXAM_CNT > 0) {
                quizTkexamPopup(QUIZ_BSC_ID, QUIZ_EXAM_DTL_ID);
            } else {
                var data = "encParams=" + QUIZ_EPARAM + "&examBscId=" + QUIZ_BSC_ID + "&examDtlId=" + QUIZ_EXAM_DTL_ID;
                quizDialog = UiDialog("quizPrepDialog", {
                    title  : "<spring:message code='exam.label.quiz.stare.info' />",   /* 퀴즈 응시 주의사항 */
                    width  : 800,
                    height : 400,
                    url    : "/quiz/stdntQuizTkexamPrepInfoPopup.do?" + data
                });
            }
        }
        /* 2 */
        function quizTkexamPopup(examBscId, examDtlId) {
            var data = "encParams=" + QUIZ_EPARAM + "&examBscId=" + examBscId + "&examDtlId=" + examDtlId;
            quizDialog = UiDialog("quizDialog", {
                title      : "<spring:message code='exam.label.quiz' /> <spring:message code='exam.label.paper' />",    /* 퀴즈 */ /* 시험지 */
                url        : "/quiz/stdntQuizTkexamPopup.do?" + data,
                fullscreen : true
            });
        }
        /* 3 */
        function exampprViewMv() {
            var data = "examBscId=" + QUIZ_BSC_ID + "&examDtlId=" + QUIZ_EXAM_DTL_ID;
            quizDialog = UiDialog("exampprDialog", {
                title      : "<spring:message code='exam.tab.eval' /> <spring:message code='exam.label.paper' />",  /* 평가 */ /* 시험지 */
                url        : "/quiz/stdntQuizEvlExampprPopup.do?" + data,
                fullscreen : true
            });
        }
        /* 4 */
        function closeDialog() {
            if (quizDialog) {
                quizDialog.close();
                quizDialog = null;
            }
        }
        /* 5 */
        function msgPop(msg) {
            closeDialog();
            UiComm.showMessage(msg, "info");
        }

        /* 오늘 날짜 계산 (과제제출 알람 창에서 사용) */
        function getNowDttm() {
            var now = new Date();
            var pad = function(value) { return String(value).padStart(2, "0"); };
            return now.getFullYear()
                + pad(now.getMonth() + 1)
                + pad(now.getDate())
                + pad(now.getHours())
                + pad(now.getMinutes())
                + pad(now.getSeconds());
        }

		$(document).ready(function() {
            if (hasSubSubject == 'Y') {
                examSubAsmtListAppend();
            }

            if ('${sbstVO.gbn}' == 'ASMT') {
                stdntAsmtSbmsnHstryListAppend();
            } else {
                quizTkexamHstryListAppend();
            }
		});
	</script>
</head>

<body class="class ${uiex:getTheme()} "><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <!-- classroom -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
				<!-- class_sub_top -->
				<jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
				<!-- //class_sub_top -->

                <div class="class_sub">
                    <!-- 강의실 상단 -->
                    <jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
                    <!-- 콘텐츠 영역 -->
                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">
                                <spring:message code="exam.label.exam" /><!-- 시험 -->
                            </h2>
                        </div>
                        <!-- 콘텐츠 상단 탭 버튼 영역 -->
                        <div class="listTab">
                            <ul>
                                <!-- 실시간/퀴즈 에 따라 버튼 동적 생성 -->
                                <li class="mw120">
                                    <a onclick="stdntExamViewMv(1)">
                                        <spring:message code="exam.label.info.tkexam" /><!-- 시험정보 및 응시 -->
                                    </a>
                                </li>
                                <c:if test="${vo.tkexamMthdCd eq 'RLTM' and (examVO.examGbncd eq 'EXAM_LST'
                                                                            or examVO.examGbncd eq 'EXAM_LST_TEAM'
                                                                            or examVO.examGbncd eq 'EXAM_MID'
                                                                            or examVO.examGbncd eq 'EXAM_MID_TEAM')}">
                                    <c:if test="${vo.absnceYn eq 'Y'}">
                                        <li class="mw120 select" style="pointer-events: none;">
                                            <a onclick="stdntExamViewMv(2)">
                                                <spring:message code='exam.label.exam' /> <!-- 시험 -->
                                                <spring:message code='exam.label.sub' /><!-- 대체 -->
                                            </a>
                                        </li>
                                    </c:if>
                                    <li class="mw120">
                                        <a onclick="stdntExamViewMv(3)">
                                            <spring:message code="exam.label.absnce.aply.rslt" /><!-- 결시신청 및 결과 -->
                                        </a>
                                    </li>
                                    <c:if test="${vo.dsblYn eq 'Y'}">
                                        <li class="mw120">
                                            <a onclick="stdntExamViewMv(4)">
                                                <spring:message code='exam.label.dsbl' />/<!-- 장애인 -->
                                                <spring:message code='exam.label.snrs' /> <!-- 고령자 -->
                                                <spring:message code='exam.label.sprt' /><!-- 지원 -->
                                            </a>
                                        </li>
                                    </c:if>
                                </c:if>
                            </ul>
                        </div>
                        <!-- 고정 영역 -->
                        <div class="board_top">
                            <i class="icon-svg-openbook"></i>
                            <h3 class="board-title">
                                <spring:message code='exam.label.exam' /> <!-- 시험 -->
                                <spring:message code='exam.label.sub' /><!-- 대체 -->
                            </h3>
                            <div class="right-area">
                                <button type="button" class="btn basic" onclick="stdntExamViewMv(8)">
                                    <spring:message code='exam.button.list' /><!-- 목록 -->
                                </button>
                            </div>
                        </div>
                        <!-- [공통] 시험 정보 영역 -->
                        <!-- accordion -->
                        <div class="elements_wrap">
                            <ul class="accordion">
                                <spring:message code="exam.common.yes" var="yes" /><!-- 예 -->
                                <spring:message code="exam.common.no" var="no" /><!-- 아니오 -->
                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap">
                                        <a class="title" href="#">
                                            <div class="lecture_tit">
                                                <label class="label s_test mr5">${examVO.examGbnnm}</label><strong>${examVO.examTtl}</strong>
                                                <p class="desc">
                                                    <span><strong class="fcBlack">${examVO.tkexamMthdNm}</strong></span>
                                                    <span><spring:message code='exam.button.stare.start' /> <spring:message code='exam.label.period' /> :<strong><uiex:formatDate value="${examVO.examPsblSdttm}" type="datetime2"/> ~ <uiex:formatDate value="${examVO.examPsblEdttm}" type="datetime2"/></strong></span> <!-- 응시 --><!-- 기간 -->
                                                    <span><spring:message code="exam.label.score.aply.y" /><!-- 성적반영 --> :<strong>${examVO.mrkRfltyn eq 'Y' ? yes : no }</strong></span>
                                                    <span><spring:message code="exam.label.score.open.y" /><!-- 성적공개 --> :<strong>${examVO.mrkOyn eq 'Y' ? yes : no }</strong></span>
                                                </p>
                                            </div>
                                            <i class="arrow xi-angle-down"></i>
                                        </a>
                                    </div>
                                    <div class="cont">
                                        <table class="table-type5">
                                            <colgroup>
                                                <col class="width-15per" />
                                                <col class="" />
                                                <col class="width-15per" />
                                                <col class="" />
                                            </colgroup>
                                            <tbody>
                                                <tr>
                                                    <th><spring:message code='exam.label.exam.stare.type' /></th><!-- 시험 구분 -->
                                                    <td colspan="3">${examVO.examGbnnm}</td>
                                                </tr>
                                                <tr>
                                                    <th><spring:message code='exam.label.exam.type' /></th><!-- 시험 유형 -->
                                                    <td colspan="3">${examVO.tkexamMthdNm}</td>
                                                </tr>
                                                <tr>
                                                    <th><spring:message code='exam.label.exam' /> <spring:message code='exam.label.cts' /></th><!-- 시험 --><!-- 내용 -->
                                                    <td colspan="3">
                                                        <div class="tb_content">
                                                            ${examVO.examCts}
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th><spring:message code='exam.label.exam' /> <spring:message code='exam.label.dttm' /></th><!-- 시험 --><!-- 일시 -->
                                                    <td colspan="3"><uiex:formatDate value="${examVO.examPsblSdttm}" type="datetime2"/> ~ <uiex:formatDate value="${examVO.examPsblEdttm}" type="datetime2"/></td>
                                                </tr>
                                                <tr>
                                                    <th><spring:message code='exam.label.exam' /> <spring:message code='exam.label.time' /></th><!-- 시험 --><!-- 시간 -->
                                                    <td colspan="3">${examVO.examMnts} <spring:message code='exam.label.min.time' /></td><!-- 분 -->
                                                </tr>
                                                <tr>
                                                    <th><spring:message code='exam.label.score.aply.y' /></th><!-- 성적 반영 -->
                                                    <td>${examVO.mrkRfltyn eq 'Y' ? yes : no}</td>
                                                    <th><spring:message code='exam.label.grade.score' /> <spring:message code='exam.label.score.aply.rate' /></th><!-- 성적 --><!-- 반영비율 -->
                                                    <td>${examVO.mrkRfltyn eq 'N' ? '-' : examVO.mrkRfltrt} %</td>
                                                </tr>
                                                <tr>
                                                    <th><spring:message code='exam.label.score.open.y' /></th><!-- 성적 공개 -->
                                                    <td colspan="3">${examVO.mrkOyn eq 'Y' ? yes : no}</td>
                                                </tr>
                                                <tr>
                                                    <th><spring:message code='exam.label.paper.open' /></th><!-- 시험지 공개 -->
                                                    <td colspan="3">${examVO.exampprOyn eq 'Y' ? yes : no}</td>
                                                </tr>
                                                <tr>
                                                    <th><spring:message code='exam.label.team' /> <spring:message code='exam.label.exam' /></th><!-- 팀 --><!-- 시험 -->
                                                    <td colspan="3" class="in_table">
                                                        <c:choose>
                                                            <c:when test="${examVO.byteamSubrexamUseyn eq 'Y' and not empty examDtlInfoVO}">
                                                                <div class="view_con">
                                                                    ${yes}<br>
                                                                    <spring:message code='exam.label.team.grp' /> : ${examDtlInfoVO[0].teamGrpnm}<br><!-- 팀 그룹 -->
                                                                    <spring:message code='exam.label.team.by' /> <spring:message code='exam.label.sub.tpc' /> <spring:message code='exam.label.use.yn' /> : ${examVO.teamGrpSubsbjctUseyn eq 'Y' ? yes : no}<!-- 팀별 --><!-- 부 주제 --><!-- 사용여부 -->
                                                                </div>
                                                                <!-- 팀별 부 주제 사용여부 -->
                                                                <c:if test="${examVO.teamGrpSubsbjctUseyn eq 'Y'}">
                                                                    <div class="table-wrap mb30">
                                                                        <table class="table-type5 in-table">
                                                                            <colgroup>
                                                                                <col class="width-5per" />
                                                                                <col class="width-15per" />
                                                                                <col class="" />
                                                                            </colgroup>
                                                                            <tbody id="examSubsbjctbody">
                                                                            </tbody>
                                                                        </table>
                                                                    </div>
                                                                </c:if>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="view_con">${no}</div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                                <c:if test="${vo.tkexamMthdCd eq 'RLTM' and (examVO.examGbncd eq 'EXAM_LST'
                                                                                            or examVO.examGbncd eq 'EXAM_LST_TEAM'
                                                                                            or examVO.examGbncd eq 'EXAM_MID'
                                                                                            or examVO.examGbncd eq 'EXAM_MID_TEAM')}">
                                                    <c:if test="${vo.absnceYn eq 'Y'}">
                                                        <tr>
                                                            <th><spring:message code='exam.label.exam' /> <spring:message code='exam.label.sub' /></th><!-- 시험 --><!-- 대체 -->
                                                            <td colspan="3">
                                                                <div class = "item_list">
                                                                        ${examVO.examSbstTynm}
                                                                    <button type="button" class = "btn basic" onclick="stdntExamViewMv(2)" style = "pointer-events: none;">
                                                                        <spring:message code='exam.label.exam' /> <!-- 시험 -->
                                                                        <spring:message code='exam.label.sub' /><!-- 대체 -->
                                                                    </button>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:if>
                                                    <tr>
                                                        <th><spring:message code='exam.label.absnce.aply.rslt' /></th><!-- 결시신청 및 결과 -->
                                                        <td colspan="3">
                                                            <div class = "item_list">
                                                                <button type="button" class = "btn basic" onclick="stdntExamViewMv(3)">
                                                                    <spring:message code='exam.label.absnce.aply.rslt' /><!-- 결시신청 및 결과 -->
                                                                </button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <c:if test="${vo.dsblYn eq 'Y'}">
                                                        <tr>
                                                            <th>
                                                                <spring:message code='exam.label.dsbl' />/<!-- 장애인 -->
                                                                <spring:message code='exam.label.snrs' /> <!-- 고령자 -->
                                                                <spring:message code='exam.label.sprt' /><!-- 지원 -->
                                                            </th>
                                                            <td colspan="3">
                                                                <div class = "item_list">
                                                                    <button type="button" class = "btn basic" onclick="stdntExamViewMv(4)">
                                                                        <spring:message code='exam.label.dsbl' />/<!-- 장애인 -->
                                                                        <spring:message code='exam.label.snrs' /> <!-- 고령자 -->
                                                                        <spring:message code='exam.label.sprt' /><!-- 지원 -->
                                                                    </button>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:if>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <!-- 시험 대체 상단영역 -->
                        <div>
                            <div class="board_top">
                                <h4 class="sub-title">
                                    <spring:message code='exam.label.exam' /> <!-- 시험 -->
                                    <spring:message code='exam.label.sub' /><!-- 대체 -->
                                </h4>
                            </div>
                            <c:choose>
                                <%-- 대체 과제일 경우 --%>
                                <c:when test="${sbstVO.gbn eq 'ASMT'}">
                                    <table class="table-type5">
                                        <colgroup>
                                            <col class="width-15per" />
                                            <col class="" />
                                            <col class="width-15per" />
                                            <col class="" />
                                        </colgroup>
                                        <tbody>
                                            <tr>
                                                <th><spring:message code='exam.label.asmt.nm' /></th><!-- 과제명 -->
                                                <td colspan="3">${sbstVO.asmtTtl}</td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.asmt.cts' /></th><!-- 과제내용 -->
                                                <td colspan="3">
                                                    <div class="tb_content">
                                                            ${sbstVO.asmtCts}
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.submit.date' /></th><!-- 제출기간 -->
                                                <td colspan="3"><uiex:formatDate value="${sbstVO.asmtSbmsnSdttm}" type="datetime2"/> ~ <uiex:formatDate value="${sbstVO.asmtSbmsnEdttm}" type="datetime2"/></td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.score.aply.y' /></th><!-- 성적반영 -->
                                                <td colspan="3">${sbstVO.mrkRfltyn eq 'Y' ? yes : no}</td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.score.open.y' /></th><!-- 성적공개 -->
                                                <td colspan="3">${sbstVO.mrkOyn eq 'Y' ? yes : no}</td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.eval.ctgr' /></th><!-- 평가방법 -->
                                                <td colspan="3">${sbstVO.evlScrTynm}</td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.submit.type' /></th><!-- 제출형식 -->
                                                <td colspan="3">${sbstVO.sbmsnFileMimeTycd}</td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.file' /></th><!-- 첨부파일 -->
                                                <td colspan="3">
                                                    <c:choose>
                                                        <c:when test="${not empty sbstVO.fileList}">
                                                            <uiex:filedownload fileList="${sbstVO.fileList}"/>
                                                        </c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <div class="board_top margin-top-4">
                                        <h4 class="sub-title">
                                            <spring:message code='exam.label.asmt' /> <!-- 과제 -->
                                            <spring:message code='exam.label.submit.y' /><!-- 제출 -->
                                        </h4>
                                        <div class="right-area">
                                            <a href="javascript:fdbkPopup()" class="btn basic">
                                                <spring:message code='exam.label.fdbk' /> / ${sbstVO.fdbkCnt}<!-- 피드백 -->
                                            </a>
                                        </div>
                                    </div>
                                    <c:choose>
                                    <c:when test="${stdntTkexamStat == 1}">
                                        <%-- case1. 과제 제출 시작 전 레이아웃 --%>
                                        <div class="msg-box margin-top-4">
                                            <p class="txt"><strong><spring:message code='exam.label.fdbk' /><!-- 안내 --> : </strong><spring:message code='exam.asmt.guide.msg1' /><!-- 과제 제출 시작 전입니다. --></p>
                                        </div>
                                    </c:when>
                                    <c:when test="${stdntTkexamStat == 2}">
                                        <%-- case2. 과제 제출 시작 후 레이아웃 --%>
                                        <c:choose>
                                            <c:when test="${empty asmtHstry}">
                                                <div class="msg-box margin-top-4">
                                                    <p class="txt"><strong><spring:message code='exam.label.fdbk' /><!-- 안내 --> : </strong><spring:message code='exam.asmt.guide.msg2' /><!-- 제출된 과제가 없습니다. --> <spring:message code='exam.asmt.guide.msg3' /><!--과제를 제출하시기 바랍니다.--></p>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="table-wrap">
                                                    <table class="table-type1">
                                                        <colgroup>
                                                            <col class="width-5per">
                                                            <col>
                                                            <col>
                                                            <col>
                                                        </colgroup>
                                                        <thead>
                                                        <tr>
                                                            <th><spring:message code='exam.label.line.no' /></th><!-- 번호 -->
                                                            <th><spring:message code='exam.label.submit.y' /><spring:message code='exam.label.submit.type.file' /></th><!-- 제출 --><!-- 파일 -->
                                                            <th><spring:message code='exam.label.submit.dttm' /></th><!-- 제출일시 -->
                                                            <th><spring:message code='exam.label.evl.trgt' /></th><!-- 평가대상 -->
                                                        </tr>
                                                        </thead>
                                                        <tbody id="tkexam-history">
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <%-- 과제 업로드 form --%>
                                        <div class="btns">
                                            <button type="button" class="btn type1" id="sbmsnToggleBtn" onclick="showSbmsnForm()">
                                                <spring:message code='exam.label.submit.y' /><!-- 제출 -->
                                            </button>
                                        </div>
                                        <div id="sbmsnFormWrap" style="display:none; margin-top: 16px;">
                                            <c:choose>
                                                <c:when test="${sbstVO.sbasmtTycd eq 'INPUT_TEXT'}">
                                                    <textarea id="sbmsnEditor" class="form-control width-100per" rows="8"></textarea>
                                                </c:when>
                                                <c:otherwise>
                                                    <uiex:dextuploader
                                                        id="sbstAsmtUploader"
                                                        path="${uploadPath}"
                                                        limitCount="5"
                                                        limitSize="100"
                                                        oneLimitSize="100"
                                                        listSize="3"
                                                        fileList=""
                                                        finishFunc="finishUpload()"
                                                        allowedTypes="${sbstVO.sbmsnFileMimeTycd}"
                                                    />
                                                </c:otherwise>
                                            </c:choose>
                                            <form id="sbstAsmtSbmsnForm" method="post">
                                                <input type="hidden" name="asmtId"      value="${sbstVO.asmtId}"/>
                                                <input type="hidden" name="sbjctId"     value="${vo.sbjctId}"/>
                                                <input type="hidden" name="sbmsnTxt"    id="sbmsnTxt"/>
                                                <input type="hidden" name="uploadFiles" id="uploadFiles"/>
                                                <input type="hidden" name="uploadPath"  id="uploadPath" value="${uploadPath}"/>
                                            </form>
                                            <div class="btns" style="margin-top: 12px;">
                                                <button type="button" class="btn type1" onclick="submitSbst()">
                                                    <spring:message code='exam.label.submit.y' /><!-- 제출 -->
                                                </button>
                                                <button type="button" class="btn basic" onclick="hideSbmsnForm()">
                                                    <spring:message code='exam.button.cancel' /><!-- 취소 -->
                                                </button>
                                            </div>
                                        </div>
                                        <div id="submitDialogTemplate" style="display:none;">
                                            <div class="board_top">
                                                <h4 class="sub-title">
                                                    <spring:message code='exam.label.asmt' /> <!-- 과제 -->
                                                    <spring:message code='exam.label.submit.y' /> <!-- 제출 -->
                                                    <spring:message code='exam.label.cts' /><!-- 내용 -->
                                                </h4>
                                            </div>
                                            <div class="table-wrap">
                                                <table class="table-type5">
                                                    <colgroup>
                                                        <col class="width-20per"/>
                                                        <col/>
                                                    </colgroup>
                                                    <tbody>
                                                    <tr>
                                                        <th><spring:message code='exam.label.submit.dttm' /></th><!-- 제출일시 -->
                                                        <td data-dialog-submit-dttm></td>
                                                    </tr>
                                                    <tr>
                                                        <th><spring:message code='exam.label.file' /></th><!-- 첨부파일 -->
                                                        <td data-dialog-atch-files></td>
                                                    </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                            <div class="board_top">
                                                <h4 class="sub-title">
                                                    <spring:message code='exam.label.ntfc.cntn' /><!-- 알림 발송내용 -->
                                                </h4>
                                            </div>
                                            <div class="table-wrap">
                                                <table class="table-type5">
                                                    <colgroup>
                                                        <col class="width-20per"/>
                                                        <col/>
                                                    </colgroup>
                                                    <tbody>
                                                    <tr>
                                                        <th><spring:message code='exam.label.ntfc.type' /></th><!-- 알림 구분 -->
                                                        <td>
                                                            <span class="custom-input">
                                                                <input type="checkbox" id="alimPushYn" checked="checked" disabled="disabled"/>
                                                                <label for="alimPushYn">
                                                                    <spring:message code='exam.label.ntfc.send' /><!-- PUSH -->
                                                                </label>
                                                            </span>
                                                            <span class="custom-input ml10">
                                                                <input type="checkbox" id="alimEmailYn" checked="checked" disabled="disabled"/>
                                                                <label for="alimEmailYn">
                                                                    <spring:message code='exam.label.email' /><!-- 이메일 -->
                                                                </label>
                                                            </span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th><spring:message code='exam.label.cts' /></th><!-- 내용 -->
                                                        <td>
                                                            <div data-dialog-alim-ctnt style="white-space:pre-line;"></div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th><spring:message code='exam.label.send.dttm' /></th><!-- 발신일시 -->
                                                        <td data-dialog-send-dttm></td>
                                                    </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                            <div class="btns">
                                                <button type="button" class="btn type1" onclick="completeSubmitDialog()">
                                                    <spring:message code='exam.label.ins.submit' /><!-- 제출완료 -->
                                                </button>
                                                <button type="button" class="btn basic" onclick="closeSubmitDialog()">
                                                    <spring:message code='exam.button.close' /><!-- 닫기 -->
                                                </button>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:when test="${stdntTkexamStat == 3}">
                                        <%-- case3. 시험 마감 후 레이아웃 --%>
                                        <c:choose>
                                            <c:when test="${empty asmtRslt.asmtEvlId}">
                                                <div class="msg-box margin-top-4">
                                                    <p class="txt"><strong><spring:message code='exam.label.fdbk' /><!-- 안내 --> : </strong><spring:message code='exam.asmt.guide.msg4' /><!-- 안내 --></p>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="table-wrap">
                                                    <table class="table-type5">
                                                        <colgroup>
                                                            <col class="width-15per">
                                                            <col>
                                                            <col>
                                                            <col>
                                                        </colgroup>
                                                        <thead>
                                                        </thead>
                                                        <tbody>
                                                        <tr>
                                                            <th><spring:message code='exam.label.submit.dttm' /></th><!-- 제출일시 -->
                                                            <td colspan="3"><uiex:formatDate value="${asmtRslt.sbmsnDttm}" type="datetime2"/></td>
                                                        </tr>
                                                        <tr>
                                                            <th><spring:message code='exam.label.submit.y' /><spring:message code='exam.label.submit.type.file' /></th><!-- 제출 --><!-- 파일 -->
                                                            <td colspan="3">
                                                                <c:choose>
                                                                    <c:when test="${not empty asmtRslt.fileList}">
                                                                        <uiex:filedownload fileList="${asmtRslt.fileList}"/>
                                                                    </c:when>
                                                                    <c:otherwise>${asmtRslt.filenm}</c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th><spring:message code='exam.label.eval.score' /></th><!-- 평가점수 -->
                                                            <c:choose>
                                                                <c:when test="${sbstVO.mrkOyn eq 'N'}">
                                                                    <td colspan="3">
                                                                        <spring:message code='exam.asmt.guide.msg5' /><!-- 성적공개가 되지 않는 과제입니다. -->
                                                                    </td>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <td colspan="3">
                                                                        ${asmtRslt.asmtScr} <spring:message code='exam.label.score.point' /><!-- 점 -->
                                                                    </td>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    </c:choose>
                                </c:when>
                                <%-- 대체 퀴즈일 경우 --%>
                                <c:otherwise>
                                    <table class="table-type5">
                                        <colgroup>
                                            <col class="width-15per" />
                                            <col class="" />
                                            <col class="width-15per" />
                                            <col class="" />
                                        </colgroup>
                                        <tbody>
                                            <tr>
                                                <th><spring:message code='exam.label.quiz.ttl' /></th><!-- 퀴즈명 -->
                                                <td colspan="3">${sbstVO.examTtl}</td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.quiz' /><spring:message code='exam.label.cts' /></th><!-- 퀴즈 --><!-- 내용 -->
                                                <td colspan="3">
                                                    <div class="tb_content">
                                                        ${sbstVO.examCts}
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.tkexam.period' /></th><!-- 응시기간 -->
                                                <td colspan="3"><uiex:formatDate value="${sbstVO.examPsblSdttm}" type="datetime2"/> ~ <uiex:formatDate value="${sbstVO.examPsblEdttm}" type="datetime2"/></td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.quiz' /><spring:message code='exam.label.time' /></th><!-- 퀴즈 --><!-- 시간 -->
                                                <td colspan="3">${sbstVO.examMnts}</td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.score.aply.y' /></th><!-- 성적반영 -->
                                                <td colspan="3">${sbstVO.mrkRfltyn eq 'Y' ? yes : no}</td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.score.open.y' /></th><!-- 성적 공개 -->
                                                <td colspan="3">${sbstVO.mrkOyn eq 'Y' ? yes : no}</td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.view.qstn.type' /></th><!-- 문제표시방식 -->
                                                <td colspan="3">${sbstVO.qstnDsplyGbnnm}</td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.qstn.random' /></th><!-- 문제 섞기 -->
                                                <td colspan="3">${sbstVO.qstnRndmyn eq 'Y' ? yes : no}</td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.empl.random' /></th><!-- 보기 섞기 -->
                                                <td colspan="3">${sbstVO.qstnVwitmRndmyn eq 'Y' ? yes : no}</td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.file' /></th><!-- 첨부파일 -->
                                                <td colspan="3">
                                                    <c:choose>
                                                        <c:when test="${not empty sbstVO.fileList}">
                                                            <uiex:filedownload fileList="${sbstVO.fileList}"/>
                                                        </c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <div class="board_top margin-top-4">
                                        <h4 class="sub-title">
                                            <spring:message code='exam.label.quiz' /> <!-- 퀴즈 -->
                                            <spring:message code='exam.button.stare.start' /><!-- 응시 -->
                                        </h4>
                                    </div>
                                    <c:choose>
                                    <c:when test="${stdntTkexamStat == 1}">
                                        <%-- case1. 퀴즈 시작 전 레이아웃 --%>
                                        <div class="msg-box">
                                            <p class="txt"><strong><spring:message code='exam.label.guide' /><!-- 안내 --> : </strong><spring:message code='exam.quiz.guide.msg1' /><!-- 퀴즈 시작 전입니다. --></p>
                                        </div>
                                    </c:when>
                                    <c:when test="${stdntTkexamStat == 2}">
                                        <%-- case2. 퀴즈 시작 후 레이아웃 --%>
                                        <c:choose>
                                            <c:when test="${empty quizHstry}">
                                                <div class="msg-box">
                                                    <p class="txt"><strong><spring:message code='exam.label.guide' /><!-- 안내 --> : </strong><spring:message code='exam.quiz.guide.msg2' /><!-- 응시한 퀴즈가 없습니다. --></p>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="table-wrap">
                                                    <table class="table-type1">
                                                        <colgroup>
                                                            <col class="width-5per">
                                                            <col>
                                                            <col>
                                                            <col>
                                                            <col>
                                                        </colgroup>
                                                        <thead>
                                                            <tr>
                                                                <th><spring:message code='exam.label.line.no' /></th><!-- 번호 -->
                                                                <th><spring:message code='exam.label.hstr.type' /></th><!-- 이력 구분 -->
                                                                <th><spring:message code='exam.label.tkexam.strt' /></th><!-- 시험 시작 -->
                                                                <th><spring:message code='exam.label.tkexam.end' /></th><!-- 시험 종료 -->
                                                                <th><spring:message code='exam.label.tkexam.time' /></th><!-- 응시 시간 -->
                                                            </tr>
                                                        </thead>
                                                        <tbody id="quiz-tkexam-history">
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:if test="${quizRslt == null || quizRslt.tkexamCmptnyn ne 'Y'}">
                                            <div class="btns">
                                                <button type="button" class="btn type1" onclick="quizTkexamConfirm()">
                                                    <spring:message code='exam.button.stare' /><!-- 응시하기 -->
                                                </button>
                                            </div>
                                        </c:if>
                                    </c:when>
                                    <c:when test="${stdntTkexamStat == 3}">
                                        <%-- case3. 시험 마감 후 레이아웃 --%>
                                        <c:choose>
                                            <c:when test="${empty quizRslt}">
                                                <div class="msg-box">
                                                    <p class="txt"><strong><spring:message code='exam.label.guide' /><!-- 안내 --> : </strong><spring:message code='exam.quiz.guide.msg3' /><!-- 퀴즈를 응시하지 않았습니다. --></p>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="table-wrap">
                                                    <table class="table-type5">
                                                        <colgroup>
                                                            <col class="width-15per">
                                                            <col>
                                                            <col class="width-15per">
                                                            <col>
                                                        </colgroup>
                                                        <thead>
                                                        </thead>
                                                        <tbody>
                                                        <tr>
                                                            <th><spring:message code='exam.label.stare.dttm' /></th><!-- 응시일시 -->
                                                            <td colspan="3"><uiex:formatDate value="${quizRslt.tkexamSdttm}" type="datetime2"/></td>
                                                        </tr>
                                                        <tr>
                                                            <th><spring:message code='exam.label.eval.y' /><spring:message code='exam.label.paper' /></th><!-- 평가 --><!-- 시험지 -->
                                                            <c:choose>
                                                                <c:when test="${sbstVO.exampprOyn eq 'Y'}">
                                                                    <td colspan="3">
                                                                        <button type="button" class="btn basic" onclick="exampprViewMv()">
                                                                            <spring:message code='exam.label.eval.y' /><!-- 평가 -->
                                                                            <spring:message code='exam.label.paper' /><!-- 시험지 -->
                                                                        </button>
                                                                    </td>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <td colspan="3"><spring:message code='exam.quiz.guide.msg4' /></td><!-- 퀴즈 시험지 비공개입니다. -->
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </tr>
                                                        <tr>
                                                            <th><spring:message code='exam.label.eval.score' /></th><!-- 평가점수 -->
                                                            <c:choose>
                                                                <c:when test="${sbstVO.mrkOyn eq 'N'}">
                                                                    <td colspan="3"><spring:message code='exam.quiz.guide.msg5' /></td><!-- 성적공개가 되지 않는 퀴즈입니다. -->
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <td colspan="3">${quizRslt.totScr} <spring:message code='exam.label.score.point' /></td><!-- 점 -->
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
            <!-- //content -->
        </main>
        <!-- //classroom-->
    </div>
</body>
</html>
