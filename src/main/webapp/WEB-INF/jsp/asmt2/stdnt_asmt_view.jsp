<%@ page import="knou.framework.common.ParamInfo" %>
<%@ page import="knou.framework.common.SubjectInfo" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/asmt2/common/asmt_common_inc.jsp" %>
<%
    pageContext.setAttribute("sbjctnm", SubjectInfo.getSbjctnm(request, ParamInfo.getParamValue(request, "sbjctId")));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="editor,fileuploader"/>
    </jsp:include>
    <script type="text/javascript">
        const ASMT_ID = '<c:out value="${asmtVO.asmtId}" />';
        const TARGET_ASMT_ID = '<c:out value="${stdntAsmtVO.targetAsmtId}" />';
        const TARGET_ASMT_TTL = '<c:out value="${stdntAsmtVO.targetAsmtTtl}" />';
        const TEAM_ID = '<c:out value="${stdntAsmtVO.teamId}" />';
        const SBJCTNM = '<c:out value="${sbjctnm}" />';
        const SBJCT_ID = '<c:out value="${asmtVO.sbjctId}" />';
        const ASMT_PRGRS_STS = '<c:out value="${stdntAsmtVO.asmtPrgrsSts}" />';
        const MRK_INQ_PSBL_YN = '<c:out value="${asmtVO.mrkInqPsblYn}" />';
        const EVLYN = '<c:out value="${stdntAsmtVO.evlyn}" />';
        const SCR = '<c:out value="${stdntAsmtVO.scr}" />';
        const SBASMT_TYCD = '<c:out value="${asmtVO.sbasmtTycd}" />';
        let EPARAM = '<c:out value="${encParams}" />';
        let sbmsnEditor = null;
        let submitDialog = null;
        let teamMbrDialog = null;
        let dialog = null;

        $(function () {
            $("#scrText").text(getScrText());
            $(".closedScrText").text(getScrText());
            renderInputTextSummary();

            if (SBASMT_TYCD === "INPUT_TEXT" && $("#sbmsnEditor").length > 0) {
                sbmsnEditor = UiEditor({
                    targetId: "sbmsnEditor",
                    uploadPath: '<c:out value="${stdntAsmtVO.uploadPath}" />',
                    height: "300px"
                });
            }
        });

        /**
         * 목록 화면 이동
         */
        function moveAsmtList() {
            const extData = {
                sbjctId: SBJCT_ID
            };
            location.href = "/asmt2/stdntAsmtListView.do?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams(extData);
        }

        /**
         * 과제 제출 처리
         */
        function submitAsmt() {
            if (ASMT_PRGRS_STS === "CLOSED" && EVLYN === "Y") {
                UiComm.showMessage("<spring:message code='asmt.alert.eval.complete.no.submit'/><%--평가 완료되었습니다. 과제 제출 불가합니다.--%>", "info");
                return;
            }

            if (!isSubmittable()) {
                UiComm.showMessage("<spring:message code='asmt.alert.not.send.date'/><%--과제 제출기간이 아닙니다.--%>", "info");
                return;
            }

            if (SBASMT_TYCD === "INPUT_TEXT") {
                submitInputTextAsmt();
                return;
            }

            submitFileAsmt();
        }

        /**
         * 제출 가능 상태 여부
         */
        function isSubmittable() {
            return ASMT_PRGRS_STS === "PROGRESS"
                || ASMT_PRGRS_STS === "EXT_PROGRESS"
                || ASMT_PRGRS_STS === "RESBMSN_PROGRESS";
        }

        /**
         * 평가점수 표시문구 반환
         */
        function getScrText() {
            if (MRK_INQ_PSBL_YN !== "Y") {
                return "-";
            }

            if (ASMT_PRGRS_STS === "CLOSED" && EVLYN === "Y" && SCR !== "") {
                return SCR + "<spring:message code='asmt.label.point'/><%--점--%>";
            }

            return "-<spring:message code='asmt.label.point'/><%--점--%>";
        }

        /**
         * 피드백 팝업 호출
         */
        function fdbkPopup() {
            const extData = {
                asmtId: TARGET_ASMT_ID
            };

            UiDialog("dialog1", {
                title: "<spring:message code='asmt.label.feedback'/><%--피드백--%>",
                width: 1000,
                height: 750,
                url: "/asmt2/stdntAsmtFdbkPopup.do?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams(extData),
                autoresize: true
            });
        }

        /**
         * 팀 구성원 팝업 표시
         */
        function openTeamMbrDialog() {
            const extData = {
                teamId: TEAM_ID
            };

            teamMbrDialog = UiDialog("teamMbrDialog", {
                width: 600,
                height: 430,
                title: "<spring:message code='asmt.label.team.members'/><%--팀 구성원--%>",
                modal: true,
                autoresize: true,
                url: "/asmt2/stdntAsmtTeamMbrPopup.do?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams(extData)
            });
        }

        /**
         * 팝업 dialog 닫기 (window.parent.closeDialog()로 호출됨)
         */
        function closeTeamMbrDialog() {
            if (teamMbrDialog) {
                teamMbrDialog.close();
            }
        }

        /**
         * 직접입력 제출내용 수정 화면 표시
         */
        function openInputText(asmtSbmsnId) {
            const value = $("#sbmsnTxt_" + asmtSbmsnId).val() || "";
            $("#sbmsnEditorWrap").show();

            if (sbmsnEditor && typeof sbmsnEditor.openHTML === "function") {
                sbmsnEditor.openHTML(value);
            } else {
                $("#sbmsnEditor").val(value);
            }
        }

        /**
         * 직접입력 제출 목록 요약문 표시
         */
        function renderInputTextSummary() {
            $(".sbmsnTxtSummary").each(function () {
                const asmtSbmsnId = $(this).data("sbmsnId");
                const value = $("#sbmsnTxt_" + asmtSbmsnId).val() || "";

                $(this).text(getInputTextSummary(value));
            });

            $(".exlnSbmsnTxtSummary").each(function () {
                const index = $(this).data("index");
                const value = $("#exlnSbmsnTxt_" + index).val() || "";

                $(this).text(getInputTextSummary(value));
            });
        }

        /**
         * 직접입력 HTML 요약문 반환
         */
        function getInputTextSummary(html) {
            const text = $("<div>").html(html || "").text().replace(/\s+/g, " ").trim();

            if (text.length > 30) {
                return text.substring(0, 30) + "...";
            }

            return text || "-";
        }

        /**
         * 파일 업로드 완료 후 파일 검증 처리
         */
        function finishUpload() {
            const url = "/common/uploadFileCheck.do";
            let dx = dx5.get("stdntAsmtUploader");
            const param = {
                "uploadFiles": dx.getUploadFiles(),
                "uploadPath": dx.getUploadPath()
            };

            ajaxCall(url, param, function (data) {
                if (data.encParams != null && data.encParams !== "") {
                    EPARAM = data.encParams;
                }
                if (data.result > 0) {
                    $("#uploadFiles").val(dx.getUploadFiles());
                    $("#uploadPath").val(dx.getUploadPath());
                    registAsmtSbmsn();
                } else {
                    UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
                }
            }, function () {
                UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
            }, true);
        }

        /**
         * 직접입력 과제 제출 확인
         */
        function submitInputTextAsmt() {
            if ($("#sbmsnEditorWrap").is(":hidden")) {
                UiComm.showMessage("<spring:message code='asmt.alert.select.submit.content'/><%--제출내용을 선택해주세요.--%>", "info");
                return;
            }

            const sbmsnTxt = getInputTextValue();
            if ($.trim($("<div>").html(sbmsnTxt).text()) === "") {
                UiComm.showMessage("<spring:message code='asmt.alert.input.contents'/><%--내용을 입력하세요.--%>", "info");
                return;
            }

            $("#sbmsnTxt").val(sbmsnTxt);
            openSubmitDialog();
        }

        /**
         * 파일 과제 제출 확인
         */
        function submitFileAsmt() {
            let dx = dx5.get("stdntAsmtUploader");

            if (!dx || dx.getFileCount() < 1) {
                UiComm.showMessage("<spring:message code='asmt.alert.no.submit.file'/><%--제출할 파일이 없습니다.--%>", "info");
                return;
            }

            openSubmitDialog();
        }

        /**
         * 과제 제출 알림창 표시
         */
        function openSubmitDialog() {
            const submitDttm = UiComm.formatDate(getNowDttm(), "datetime2");
            const fileNames = getSubmitFileNames();
            const alimSubject = getAlimTitle();
            const alimCtnt = getAlimCtnt(submitDttm, fileNames);
            const $submitDialogHtml = $($.parseHTML($("#submitDialogTemplate").html()));

            $submitDialogHtml.find("[data-dialog-submit-dttm]").text(submitDttm);
            $submitDialogHtml.find("[data-dialog-atch-files]").text(fileNames.length > 0 ? fileNames.join(", ") : "-");
            $submitDialogHtml.find("[data-dialog-alim-subject]").text(alimSubject);
            $submitDialogHtml.find("[data-dialog-alim-ctnt]").text(alimCtnt);
            $submitDialogHtml.find("[data-dialog-send-dttm]").text(submitDttm);

            submitDialog = UiDialog("submitDialog", {
                width: 900,
                height: 800,
                title: "<spring:message code='asmt.label.asmt.submit.alert'/><%--과제 제출 알림창--%>",
                modal: true,
                autoresize: true,
                html: $("<div>").append($submitDialogHtml).html()
            });
        }

        /**
         * 과제 제출 알림창 제출완료 처리
         */
        function completeSubmitDialog() {
            if (SBASMT_TYCD === "INPUT_TEXT") {
                registAsmtSbmsn();
                return;
            }

            let dx = dx5.get("stdntAsmtUploader");
            if (dx.availUpload()) {
                dx.startUpload();
            } else {
                registAsmtSbmsn();
            }
        }

        /**
         * 과제 제출 알림창 닫기
         */
        function closeSubmitDialog() {
            if (submitDialog && typeof submitDialog.close === "function") {
                submitDialog.close();
                submitDialog = null;
            }
        }

        /**
         * 현재일시 문자열 반환
         */
        function getNowDttm() {
            const now = new Date();
            const pad = function (value) {
                return String(value).padStart(2, "0");
            };

            return now.getFullYear()
                + pad(now.getMonth() + 1)
                + pad(now.getDate())
                + pad(now.getHours())
                + pad(now.getMinutes())
                + pad(now.getSeconds());
        }

        /**
         * 제출 첨부파일명 목록 반환
         */
        function getSubmitFileNames() {
            if (SBASMT_TYCD === "INPUT_TEXT") {
                return [];
            }

            const dx = dx5.get("stdntAsmtUploader");
            if (!dx || typeof dx.getItems !== "function") {
                return [];
            }

            return $.map(dx.getItems(), function (item) {
                return item.name;
            });
        }

        /**
         * 알림 제목 반환
         */
        function getAlimTitle() {
            return TARGET_ASMT_TTL;
        }

        /**
         * 알림 내용 반환
         */
        function getAlimCtnt(submitDttm, fileNames) {
            const atchFileText = fileNames.length > 0 ? fileNames.join(", ") : "-";
            const sbmsnText = SBASMT_TYCD === "INPUT_TEXT" ? "<spring:message code='asmt.label.text.submit'/><%--텍스트 제출--%>" : "<spring:message code='asmt.label.attach.file'/><%--첨부파일--%>: " + atchFileText;

            return "1. <spring:message code='asmt.label.course'/><%--과목--%>: " + SBJCTNM + "\n"
                + "2. <spring:message code='asmt.label.submit.dt'/><%--제출일시--%>: " + submitDttm + "\n"
                + "3. " + sbmsnText + "\n"
                + "<spring:message code='asmt.label.asmt.submit'/><%--과제를 제출하였습니다.--%>";
        }

        /**
         * 직접입력 에디터 값 반환
         */
        function getInputTextValue() {
            if (sbmsnEditor && typeof sbmsnEditor.getPublishingHtml === "function") {
                return sbmsnEditor.getPublishingHtml();
            }

            return $("#sbmsnEditor").val() || "";
        }

        /**
         * 과제 제출 저장
         */
        function registAsmtSbmsn() {
            UiComm.showLoading(true);

            $.ajax({
                url: "/asmt2/stdntAsmtSbmsnRegistAjax.do",
                type: "POST",
                dataType: "json",
                data: $("#stdntAsmtSbmsnForm").serialize()
            }).done(function (data) {
                UiComm.showLoading(false);
                if (data.encParams != null && data.encParams !== "") {
                    EPARAM = data.encParams;
                }
                if (data.result > 0) {
                    closeSubmitDialog();
                    UiComm.showMessage("<spring:message code='asmt.alert.save.success'/><%--정상적으로 저장되었습니다.--%>", "success")
                    .then(function () {
                        location.reload();
                    });
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }).fail(function () {
                UiComm.showLoading(false);
                UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");
            });
        }
    </script>
</head>

<body class="class ${uiex:getTheme()} ${bodyClass}">
<div id="wrap" class="main">
    <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>

    <main class="common">
        <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_stu.jsp"/>

        <div id="content" class="content-wrap common">
            <jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>

            <div class="class_sub">
                <jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>

                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title"><spring:message code='asmt.label.asmt'/><%--과제--%></h2>
                    </div>

                    <div class="board_top">
                        <h3 class="board-title"><spring:message code='asmt.label.asmt.info.submit'/><%--과제정보 및 과제제출--%></h3>
                        <div class="right-area">
                            <c:if test="${asmtVO.teamAsmtStngyn eq 'Y' and not empty stdntAsmtVO.teamId}">
                                <button type="button" class="btn type2 big" onclick="openTeamMbrDialog()"><spring:message code='asmt.label.team.members'/><%--팀 구성원--%></button>
                            </c:if>
                            <button type="button" class="btn type2 big" onclick="moveAsmtList()"><spring:message code='asmt.button.list'/><%--목록--%></button>
                        </div>
                    </div>

                    <%--과제 정보--%>
                    <jsp:include page="/WEB-INF/jsp/asmt2/asmt_info_view.jsp"/>
                    <%--과제 정보--%>

                    <c:set var="sbmsnOpen" value="${stdntAsmtVO.asmtPrgrsSts eq 'PROGRESS' or stdntAsmtVO.asmtPrgrsSts eq 'EXT_PROGRESS' or stdntAsmtVO.asmtPrgrsSts eq 'RESBMSN_PROGRESS'}"/>
                    <c:set var="sbmsnClosed" value="${stdntAsmtVO.asmtPrgrsSts eq 'CLOSED'}"/>
                    <c:set var="inputTextYn" value="${asmtVO.sbasmtTycd eq 'INPUT_TEXT'}"/>

                    <div class="board_top">
                        <h4 class="sub-title"><spring:message code='asmt.label.asmt.submission'/><%--과제제출--%></h4>
                        <div class="right-area">
                            <button type="button" class="btn basic small" onclick="fdbkPopup()"><spring:message code='asmt.label.feedback'/><%--피드백--%> ${stdntAsmtVO.fdbkCnt}</button>
                        </div>
                    </div>
                    <div class="table-wrap">
                        <c:choose>
                            <c:when test="${sbmsnClosed}">
                                <table class="table-type5">
                                    <colgroup>
                                        <col class="width-15per"/>
                                        <col/>
                                    </colgroup>
                                    <tbody>
                                    <c:forEach var="item" items="${sbmsnList}" varStatus="status">
                                        <c:if test="${status.first}">
                                            <tr>
                                                <th><spring:message code='asmt.label.submit.dt'/><%--제출일시--%></th>
                                                <td><uiex:formatDate type="datetime2" value="${item.sbmsnDttm}"/></td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='asmt.label.send.file'/><%--제출파일--%></th>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${inputTextYn}">
                                                            <span class="sbmsnTxtSummary" data-sbmsn-id="${item.asmtSbmsnId}"></span>
                                                            <textarea id="sbmsnTxt_${item.asmtSbmsnId}" style="display:none;"><c:out value="${item.sbmsnTxt}"/></textarea>
                                                        </c:when>
                                                        <c:when test="${not empty item.fileList}">
                                                            <uiex:filedownload fileList="${item.fileList}"/>
                                                        </c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='asmt.label.eval.score'/><%--평가점수--%></th>
                                                <td><span class="closedScrText">-<spring:message code='asmt.label.point'/><%--점--%></span></td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${empty sbmsnList}">
                                        <tr>
                                            <td colspan="2"><spring:message code='asmt.label.send.asmt.empty'/><%--제출 과제가 없습니다.--%></td>
                                        </tr>
                                    </c:if>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <table class="table-type2">
                                    <colgroup>
                                        <col style="width:8%"/>
                                        <col/>
                                        <col style="width:20%"/>
                                        <col style="width:18%"/>
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th>No</th>
                                        <th><spring:message code='asmt.label.send.content'/><%--제출내용--%></th>
                                        <th><spring:message code='asmt.label.submit.dt'/><%--제출일시--%></th>
                                        <th><spring:message code='asmt.label.eval.target'/><%--평가대상--%></th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="item" items="${sbmsnList}" varStatus="status">
                                        <tr>
                                            <td>${status.count}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${inputTextYn}">
                                                        <span class="sbmsnTxtSummary" data-sbmsn-id="${item.asmtSbmsnId}" onclick="openInputText('${item.asmtSbmsnId}')"></span>
                                                        <textarea id="sbmsnTxt_${item.asmtSbmsnId}" style="display:none;"><c:out value="${item.sbmsnTxt}"/></textarea>
                                                    </c:when>
                                                    <c:when test="${not empty item.fileList}">
                                                        <uiex:filedownload fileList="${item.fileList}"/>
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><uiex:formatDate type="datetime2" value="${item.sbmsnDttm}"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${status.first}"><spring:message code='asmt.label.eval.target'/><%--평가대상--%></c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty sbmsnList}">
                                        <tr>
                                            <td colspan="4"><spring:message code='asmt.label.send.asmt.empty'/><%--제출 과제가 없습니다.--%></td>
                                        </tr>
                                    </c:if>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="table-wrap" id="sbmsnInputWrap" <c:if test="${not sbmsnOpen}">style="display:none;"</c:if>>
                        <table class="table-type5">
                            <colgroup>
                                <col/>
                            </colgroup>
                            <tbody>
                            <c:choose>
                                <c:when test="${inputTextYn}">
                                    <tr>
                                        <td>
                                            <div id="sbmsnEditorWrap" <c:if test="${not empty sbmsnList}">style="display:none;"</c:if>>
                                                <textarea id="sbmsnEditor" class="form-control width-100per" rows="8"></textarea>
                                            </div>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td>
                                            <uiex:dextuploader
                                                    id="stdntAsmtUploader"
                                                    path="${stdntAsmtVO.uploadPath}"
                                                    limitCount="5"
                                                    limitSize="100"
                                                    oneLimitSize="100"
                                                    listSize="3"
                                                    fileList=""
                                                    finishFunc="finishUpload()"
                                                    allowedTypes="${stdntAsmtVO.allowedFileTypes}"
                                            />
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <form id="stdntAsmtSbmsnForm" method="post">
                        <input type="hidden" name="asmtId" value="${stdntAsmtVO.targetAsmtId}"/>
                        <input type="hidden" name="sbjctId" value="${asmtVO.sbjctId}"/>
                        <input type="hidden" name="sbmsnTxt" id="sbmsnTxt"/>
                        <input type="hidden" name="uploadFiles" id="uploadFiles"/>
                        <input type="hidden" name="uploadPath" id="uploadPath" value="${stdntAsmtVO.uploadPath}"/>
                    </form>

                    <div class="btns">
                        <button type="button" class="btn type1" onclick="submitAsmt()"><spring:message code='asmt.button.submit'/><%--제출--%></button>
                    </div>

                    <div id="submitDialogTemplate" style="display:none;">
                        <div class="board_top">
                            <h4 class="sub-title"><spring:message code='asmt.label.asmt.submit.content'/><%--과제 제출 내용--%></h4>
                        </div>
                        <div class="table-wrap">
                            <table class="table-type5">
                                <colgroup>
                                    <col class="width-20per"/>
                                    <col/>
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th><spring:message code='asmt.label.submit.dt'/><%--제출일시--%></th>
                                    <td data-dialog-submit-dttm></td>
                                </tr>
                                <tr>
                                    <th><spring:message code='asmt.label.attach.file'/><%--첨부파일--%></th>
                                    <td data-dialog-atch-files></td>
                                </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="board_top">
                            <h4 class="sub-title"><spring:message code='asmt.label.alim.send.content'/><%--알림 발송 내용--%></h4>
                        </div>
                        <div class="table-wrap">
                            <table class="table-type5">
                                <colgroup>
                                    <col class="width-20per"/>
                                    <col/>
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th><spring:message code='asmt.label.alim.type'/><%--알림 구분--%></th>
                                    <td>
                                        <span class="custom-input">
                                            <input type="checkbox" id="alimPushYn" checked="checked" disabled="disabled"/>
                                            <label for="alimPushYn">PUSH</label>
                                        </span>
                                        <span class="custom-input ml10">
                                            <input type="checkbox" id="alimEmailYn" checked="checked" disabled="disabled"/>
                                            <label for="alimEmailYn"><spring:message code='asmt.label.email'/><%--이메일--%></label>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th><spring:message code='asmt.label.subject'/><%--제목--%></th>
                                    <td data-dialog-alim-subject></td>
                                </tr>
                                <tr>
                                    <th><spring:message code='asmt.label.content'/><%--내용--%></th>
                                    <td>
                                        <div data-dialog-alim-ctnt style="white-space:pre-line;"></div>
                                    </td>
                                </tr>
                                <tr>
                                    <th><spring:message code='asmt.label.send.dttm'/><%--발신일시--%></th>
                                    <td data-dialog-send-dttm></td>
                                </tr>
                                <tr>
                                    <th><spring:message code='asmt.label.sender'/><%--발신자--%></th>
                                    <td><c:out value="${stdntAlimVO.usernm}"/></td>
                                </tr>
                                <tr>
                                    <th><spring:message code='asmt.label.receiver.no'/><%--수신자번호--%></th>
                                    <td><c:out value="${stdntAlimVO.mobileNo}"/></td>
                                </tr>
                                <tr>
                                    <th><spring:message code='asmt.label.receiver.email'/><%--수신자이메일--%></th>
                                    <td><c:out value="${stdntAlimVO.email}"/></td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btns">
                            <button type="button" class="btn type1" onclick="completeSubmitDialog()"><spring:message code='asmt.button.submit.complete'/><%--제출완료--%></button>
                        </div>
                    </div>


                    <c:if test="${asmtVO.asmtPrctcyn eq 'Y' and asmtVO.sbasmtOstdOyn eq 'Y' and asmtVO.exlnAsmtDwldyn eq 'Y'}">
                        <div class="board_top">
                            <h4 class="sub-title"><spring:message code='asmt.label.excellent.asmt.list'/><%--우수과제 목록--%></h4>
                        </div>
                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:8%"/>
                                    <col style="width:18%"/>
                                    <col/>
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>No</th>
                                    <th><spring:message code='asmt.label.team.name.user'/><%--팀/이름--%></th>
                                    <th><spring:message code='asmt.label.send.content'/><%--제출내용--%></th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="item" items="${exlnAsmtList}" varStatus="status">
                                    <tr>
                                        <td>${status.count}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty item.teamnm}">
                                                    <c:out value="${item.teamnm}"/> / <c:out value="${item.usernm}"/>
                                                </c:when>
                                                <c:otherwise><c:out value="${item.usernm}"/></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${asmtVO.sbasmtTycd eq 'INPUT_TEXT'}">
                                                    <span class="exlnSbmsnTxtSummary" data-index="${status.index}"></span>
                                                    <textarea id="exlnSbmsnTxt_${status.index}" style="display:none;"><c:out value="${item.sbmsnTxt}"/></textarea>
                                                </c:when>
                                                <c:when test="${not empty item.fileList}">
                                                    <uiex:filedownload fileList="${item.fileList}"/>
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty exlnAsmtList}">
                                    <tr>
                                        <td colspan="3"><spring:message code='asmt.label.excellent.asmt.empty'/><%--등록된 우수과제가 없습니다.--%></td>
                                    </tr>
                                </c:if>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </main>
</div>


</body>
</html>
