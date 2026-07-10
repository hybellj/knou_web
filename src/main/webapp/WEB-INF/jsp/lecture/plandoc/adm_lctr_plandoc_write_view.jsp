<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="fileuploader"/>
    </jsp:include>

    <script type="text/javascript">
        let EPARAM = '<c:out value="${encParams}" />';
        let WRITE_MODE = '<c:out value="${writeMode}" />';
        let uploadQueue = [];
        let uploadIndex = 0;

        $(function () {
            renumberTxtbk();
            bindTxtbkEvents();
            calcRateSum();
            bindMrkEvents();
            bindWkChangeDetect();
            bindSupportYnEvents();
            bindRltmExamEvents();

            syncAllMrkOynHidden();
            syncSupportYnHidden();
        });

        /* =========================
         * 교재
         * ========================= */

        /**
         * 교재 영역 이벤트를 바인딩한다.
         * - 전체선택
         */
        function bindTxtbkEvents() {
            $("#txtbkAll").on("change", function () {
                $("#txtbkTbody .txtbkChk").prop("checked", $(this).is(":checked"));
            });
        }

        /**
         * 교재 번호(No) 컬럼을 재정렬한다.
         * - no-data 행은 제외
         */
        function renumberTxtbk() {
            const $rows = $("#txtbkTbody tr").not(".no-data");
            $rows.each(function (idx) {
                $(this).find(".txtbkNo").text(idx + 1);
            });
        }

        /**
         * 교재 리스트 인덱스(txtbkList[x].필드)를 재정렬한다.
         * - 삭제 후 인덱스가 비면 Spring 바인딩이 꼬일 수 있어 저장 직전에 한 번 정리하는 방식
         */
        function renumberTxtbkNames() {
            const $rows = $("#txtbkTbody tr").not(".no-data");

            $rows.each(function (idx) {
                const $tr = $(this);
                const chkId = "txtbkChk_" + idx;

                $tr.find(".txtbkChk").attr("id", chkId);
                $tr.find("label[for^='txtbkChk_']").attr("for", chkId);

                $tr.find("input, select").each(function () {
                    const $el = $(this);
                    const name = $el.attr("name") || "";
                    if (!name) return;
                    if (name.indexOf("txtbkList[") !== 0) return;

                    $el.attr("name", name.replace(/txtbkList\[\d+]/, "txtbkList[" + idx + "]"));
                });
            });
        }

        /**
         * 교재 행을 추가한다.
         * - 신규행은 마지막 인덱스로 생성
         */
        function addTxtbkRow() {
            $("#txtbkTbody .no-data").remove();

            const optionsHtml = (() => {
                let html = "";
                <c:forEach var="c" items="${txtbkGbncdList}">
                html += "<option value='${c.cd}'>${fn:escapeXml(c.cdnm)}</option>";
                </c:forEach>
                return html;
            })();

            const idx = $("#txtbkTbody tr").not(".no-data").length;

            let tr = "";
            tr += "<tr class='txtbk-row'>";
            tr += "  <td class='t_center'>";
            tr += "    <span class='custom-input onlychk'>";
            tr += "      <input type='checkbox' class='txtbkChk' id='txtbkChk_" + idx + "'>";
            tr += "      <label for='txtbkChk_" + idx + "'></label>";
            tr += "    </span>";
            tr += "    <input type='hidden' name='txtbkList[" + idx + "].txtbkId' value=''>";
            tr += "  </td>";
            tr += "  <td class='t_center txtbkNo'></td>";
            tr += "  <td class='t_center'><select class='form-select compact' name='txtbkList[" + idx + "].txtbkGbncd'>" + optionsHtml + "</select></td>";
            tr += "  <td class='t_left'><input type='text' class='form-control width-100per' name='txtbkList[" + idx + "].txtbknm' inputmask='byte' maxLen='300' required='true'></td>";
            tr += "  <td class='t_center'><input type='text' class='form-control width-100per' name='txtbkList[" + idx + "].isbn' inputmask='etc' mask='9{0,30}'></td>";
            tr += "  <td class='t_left'><input type='text' class='form-control width-100per' name='txtbkList[" + idx + "].wrtr' inputmask='byte' maxLen='300'></td>";
            tr += "  <td class='t_left'><input type='text' class='form-control width-100per' name='txtbkList[" + idx + "].pblshr' inputmask='byte' maxLen='300'></td>";
            tr += "</tr>";

            $("#txtbkTbody").append(tr);
            $("#txtbkAll").prop("checked", false);
            renumberTxtbk();
        }

        /**
         * 선택된 교재 행을 삭제한다.
         * - 화면에서 제거만 하고 저장 시 "전체 삭제 후 재등록" 정책으로 서버에서 처리
         */
        function removeCheckedTxtbkRows() {
            const $checked = $("#txtbkTbody .txtbkChk:checked");

            if ($checked.length === 0) {
                UiComm.showMessage("삭제할 교재를 선택하세요.", "info");
                return;
            }

            UiComm.showMessage("선택한 교재를 삭제하시겠습니까?", "confirm").then(function (ok) {
                if (!ok) return;

                $checked.closest("tr").remove();
                $("#txtbkAll").prop("checked", false);

                const left = $("#txtbkTbody tr").not(".no-data").length;
                if (left === 0) {
                    $("#txtbkTbody").append("<tr class='no-data'><td colspan='7' class='t_center'>등록된 교재가 없습니다. 교재 추가를 눌러 입력하세요.</td></tr>");
                }

                renumberTxtbk();
            });
        }

        /* =========================
         * 평가비율
         * ========================= */

        /**
         * 평가비율 영역 이벤트를 바인딩한다.
         * - 비율 입력 시 합계 자동 계산
         * - 성적공개여부 switch -> hidden 동기화
         */
        function bindMrkEvents() {
            $(document).on("blur change input", ".mrk-rate", function () {
                calcRateSum();
            });

            $(document).on("change", ".mrk-oyn", function () {
                syncMrkOynHidden($(this));
            });
        }

        /**
         * 성적공개여부 hidden을 전체 초기 동기화한다.
         * - 공개여부 체크박스가 존재하는 항목만 처리
         */
        function syncAllMrkOynHidden() {
            $(".mrk-oyn").each(function () {
                syncMrkOynHidden($(this));
            });
        }

        /**
         * 성적공개여부 switch 값을 hidden에 동기화한다.
         * - 출석 그룹은 진도/연습문제 hidden을 같은 값으로 맞춘다.
         */
        function syncMrkOynHidden($checkbox) {
            const value = $checkbox.is(":checked") ? "Y" : "N";
            const group = $checkbox.data("mrk-group");
            if (group) {
                $(".mrk-oyn-hidden[data-mrk-group='" + group + "']").val(value);
                return;
            }

            const idx = $checkbox.data("mrk-index");
            $("#mrkOynHidden_" + idx).val(value);
        }

        /**
         * 평가비율 합계를 계산하여 화면에 표시한다.
         * 빈 값은 미평가로 처리하므로 합계에 포함하지 않는다.
         * 숫자가 아닌 입력은 합계에 포함하지 않는다.
         * @returns {number} 합계(숫자)
         */
        function calcRateSum() {
            let sum = 0;

            $(".mrk-rate").each(function () {
                const raw = ($(this).val() || "").toString().trim();
                if (raw === "") return;
                if (!/^\d{1,3}(\.\d{1,2})?$/.test(raw)) return;

                const v = Number(raw);
                if (isNaN(v)) return;

                sum += v;
            });

            sum = Math.round(sum * 100) / 100;
            $("#sumRate").text(sum);
            return sum;
        }

        /* =========================
         * 주차별 강의내용 변경감지
         * ========================= */

        /**
         * 주차 인덱스(data-wk-index)로 주차 대표행(.wk-head)을 조회한다.
         * @param wkIndex 주차 인덱스
         * @returns {*} jQuery object (.wk-head)
         */
        function getWkHeadRowByIndex(wkIndex) {
            return $("#wkTable .wk-head[data-wk-index='" + wkIndex + "']");
        }

        /**
         * 주차 변경 여부를 head row에 표시한다.
         * - 상태 텍스트 변경
         * - hidden(wkChgyn) 변경
         * @param $wkHeadTr 주차 대표행(.wk-head)
         * @param changed   변경 여부(true/false)
         */
        function markWeekChanged($wkHeadTr, changed) {
            $wkHeadTr.find(".wkStsTxt").text(changed ? "변경" : "-");
            $wkHeadTr.find(".wkChgyn").val(changed ? "Y" : "N");
        }

        /**
         * 주차 변경 여부를 판단한다.
         * - 원본값(wkOrig*)과 현재 입력값 비교
         * @param $wkHeadTr 주차 대표행(.wk-head)
         * @returns {boolean} 변경 여부
         */
        function isWeekChanged($wkHeadTr) {
            const wkIndex = $wkHeadTr.data("wk-index");
            const $wkBodyTr = $("#wkTable .wk-body[data-wk-index='" + wkIndex + "']");

            const origTy = ($wkHeadTr.find(".wkOrigTy").val() || "").toString().trim();
            const origTitle = ($wkHeadTr.find(".wkOrigTitle").val() || "").toString().trim();
            const origCts = ($wkHeadTr.find(".wkOrigCts").val() || "").toString().trim();

            const curTy = ($wkHeadTr.find("select.wkWatch").val() || "").toString().trim();
            const curTitle = ($wkHeadTr.find("input.wkWatch").val() || "").toString().trim();
            const curCts = ($wkBodyTr.find("textarea.wkWatch").val() || "").toString().trim();

            return (origTy !== curTy) || (origTitle !== curTitle) || (origCts !== curCts);
        }

        /**
         * 주차별 입력 변경 이벤트를 바인딩한다.
         * - 변경 시 해당 주차의 wkChgyn만 Y로 처리
         */
        function bindWkChangeDetect() {
            $("#wkTable").on("change input", ".wkWatch", function () {
                const $tr = $(this).closest("tr");
                const wkIndex = $tr.data("wk-index");
                const $wkHeadTr = $tr.hasClass("wk-head") ? $tr : getWkHeadRowByIndex(wkIndex);

                markWeekChanged($wkHeadTr, isWeekChanged($wkHeadTr));
            });
        }

        /* =========================
         * 학습지원기능
         * ========================= */


        function bindSupportYnEvents() {
            $("#plyrShrtctKeyPvsnyn, #scrptPvsnyn, #sbttlsPvsnyn, #plyrSpdAdjstPvsnyn").on("change", function () {
                syncSupportYnHidden();
            });
        }

        /**
         * 학습지원 기능(checkbox) 상태를 hidden에 강제 동기화한다.
         */
        function syncSupportYnHidden() {
            const map = [
                {chk: "plyrShrtctKeyPvsnyn", hid: "plyrShrtctKeyPvsnynHidden"},
                {chk: "scrptPvsnyn", hid: "scrptPvsnynHidden"},
                {chk: "sbttlsPvsnyn", hid: "sbttlsPvsnynHidden"},
                {chk: "plyrSpdAdjstPvsnyn", hid: "plyrSpdAdjstPvsnynHidden"}
            ];

            map.forEach(function (x) {
                const $chk = $("#" + x.chk);
                const $hid = $("#" + x.hid);
                if ($chk.length === 0 || $hid.length === 0) return;

                $hid.val($chk.is(":checked") ? "Y" : "N");
            });
        }

        /* =========================
         * 시험정보
         * ========================= */

        /**
         * 시험정보의 종속 입력 상태를 제어한다.
         * - 시험문제출제위임이 아니오이면 출제위임대상자를 비활성화하고 값을 비운다.
         * - 시험지공개가 아니오이면 OPEN_OPTN_GBNCD를 비활성화하고 값을 비운다.
         */
        function bindRltmExamEvents() {
            $(".rltm-qstns-dlgtn-yn").on("change", function () {
                const $row = $(this).closest("tr");
                const $qstnsTrgtrSelect = $row.find(".rltm-qstns-trgtr");
                const dlgtnYn = $row.find(".rltm-qstns-dlgtn-yn:checked").val() === "Y";

                if (!dlgtnYn) {
                    $qstnsTrgtrSelect.val("");
                }
                $qstnsTrgtrSelect.prop("disabled", !dlgtnYn).trigger("chosen:updated");
            });

            $(".rltm-end-examppr-oyn").on("change", function () {
                const $cell = $(this).closest("td");
                const $openOptnArea = $cell.find(".rltm-open-optn-area");
                const openYn = $cell.find(".rltm-end-examppr-oyn:checked").val() === "Y";

                $openOptnArea.find("input[type='radio']").prop("disabled", !openYn);
                if (!openYn) {
                    $openOptnArea.find("input[type='radio']").prop("checked", false);
                }
            });

            $(".rltm-qstns-dlgtn-yn:checked").trigger("change");
            $(".rltm-end-examppr-oyn:checked").trigger("change");
        }

        /* =========================
         * 저장
         * ========================= */

        /**
         * 저장 처리
         * - validate
         */
        function savePlandoc() {
            const validator = UiValidator("plandocSaveForm");

            validator.then(function (result) {
                if (!result) return;

                const $rates = $(".mrk-rate");
                if ($rates.length > 0) {
                    const sum = calcRateSum();
                    if (sum !== 100) {
                        UiComm.showMessage("평가비율 합계는 100%여야 합니다. (현재: " + sum + "%)", "warning");
                        return;
                    }
                }

                renumberTxtbkNames();
                syncAllMrkOynHidden();
                syncSupportYnHidden();

                UiComm.showMessage("저장하시겠습니까?", "confirm").then(function (ok) {
                    if (!ok) return;

                    startPlandocFileUpload();


                });
            });
        }

        /**
         * 강의계획서 첨부파일 업로드 시작
         */
        function startPlandocFileUpload() {
            uploadQueue = [
                {uploaderId: "noteFileUploader"}
                , {uploaderId: "voiceFileUploader"}
                , {uploaderId: "trainingFileUploader"}
            ];

            uploadIndex = 0;
            uploadNextFile();
        }

        /**
         * 다음 파일 업로더 처리
         */
        function uploadNextFile() {
            if (uploadIndex >= uploadQueue.length) {
                plandocSaveAjax();
                return;
            }

            const item = uploadQueue[uploadIndex];
            const dx = dx5.get(item.uploaderId);

            if (dx && dx.availUpload()) {
                dx.startUpload();
                return;
            }

            uploadIndex++;
            uploadNextFile();
        }

        /**
         * 강의노트 업로드 완료
         */
        function finishNoteUpload() {
            checkUploadedFile("noteFileUploader", "noteUploadFiles");
        }

        /**
         * 음성파일 업로드 완료
         */
        function finishVoiceUpload() {
            checkUploadedFile("voiceFileUploader", "voiceUploadFiles");
        }

        /**
         * 실습지도 업로드 완료
         */
        function finishTrainingUpload() {
            checkUploadedFile("trainingFileUploader", "trainingUploadFiles");
        }

        /**
         * 업로드 파일 검증
         */
        function checkUploadedFile(uploaderId, uploadFilesId) {
            const dx = dx5.get(uploaderId);

            const data = {
                uploadFiles: dx.getUploadFiles()
                , uploadPath: dx.getUploadPath()
            };

            ajaxCall("/common/uploadFileCheck.do", data, function (data) {
                if (data.result <= 0) {
                    UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
                    return;
                }

                $("#" + uploadFilesId).val(dx.getUploadFiles());

                uploadIndex++;
                uploadNextFile();
            }, function () {
                UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
            }, true);
        }

        /**
         * 강의계획서 저장
         */
        function plandocSaveAjax() {
            const noteDx = dx5.get("noteFileUploader");
            const voiceDx = dx5.get("voiceFileUploader");
            const trainingDx = dx5.get("trainingFileUploader");

            $("#noteDelFileIdStr").val(noteDx ? noteDx.getDelFileIdStr() : "");
            $("#voiceDelFileIdStr").val(voiceDx ? voiceDx.getDelFileIdStr() : "");
            $("#trainingDelFileIdStr").val(trainingDx ? trainingDx.getDelFileIdStr() : "");

            ajaxCall(
                (WRITE_MODE === "regist" ? "/lctr/plandoc/admLctrPlandocRegistAjax.do" : "/lctr/plandoc/admLctrPlandocModifyAjax.do")
                , $("#plandocSaveForm").serialize()
                , function (data) {
                    if (data.encParams != null && data.encParams != '') {
                        EPARAM = data.encParams;
                    }
                    if (data.result > 0) {
                        UiComm.showMessage("<spring:message code='success.common.save' />", "success")
                        .then(function () {
                            const sbjctId = $("#sbjctId").val();
                            viewPlandoc(sbjctId);
                        });
                    } else {
                        UiComm.showMessage(data.message || "<spring:message code='fail.common.msg' />", "error");
                    }
                }
                , function () {
                    UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");
                }
                , true
            );
        }

        /**
         * 강의계획서 상세 화면 이동
         * @param sbjctId
         */
        function viewPlandoc(sbjctId) {
            const extData = {
                sbjctId: sbjctId
            };

            const url = "/lctr/plandoc/admLctrPlandocView.do";
            document.location.href = url + "?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams(extData);
        }

        function listPlandoc() {
            const extData = {
                sbjctId: ""
            };
            document.location.href = "/lctr/plandoc/admLctrPlandocListView.do?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams(extData);
        }
    </script>
    <style>
        .exam-option-row {
            display: block;
            padding: 6px 0;
        }

        .rltm-open-optn-area {
            margin-top: 4px;
        }
    </style>
</head>

<body class="admin">
<div id="wrap" class="main">
    <jsp:include page="/WEB-INF/jsp/common_new/admin_header.jsp"/>

    <main class="common">
        <jsp:include page="/WEB-INF/jsp/common_new/admin_aside.jsp"/>

        <div id="content" class="content-wrap common">
            <div class="admin_sub">
                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title">관리자 강의계획서 <c:out value="${writeMode eq 'regist' ? '등록' : '수정'}"/></h2>
                        <uiex:navibar type="main"/>
                    </div>

                    <form id="plandocSaveForm" name="plandocSaveForm">
                        <input type="hidden" id="sbjctId" name="sbjctId" value="<c:out value='${subjectInfo.sbjctId}'/>"/>
                        <input type="hidden" id="lctrPlandocId" name="lctrPlandocId" value="<c:out value='${lctrPlandocInfo.lctrPlandocId}'/>"/>

                        <!-- 과목 정보 -->
                        <h4 class="sub-title">과목 정보</h4>
                        <div class="table_list">
                            <ul class="list">
                                <li class="head"><label>과목번호</label></li>
                                <li><c:out value="${subjectInfo.crclmnNo}"/></li>
                                <li class="head"><label>분반</label></li>
                                <li><c:out value="${subjectInfo.dvclasNo}"/></li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label>과목명 (한글)</label></li>
                                <li><c:out value="${subjectInfo.sbjctnm}"/></li>
                                <li class="head"><label>과목명 (영문)</label></li>
                                <li><c:out value="${subjectInfo.sbjctEnnm}"/></li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label>학과</label></li>
                                <li><c:out value="${subjectInfo.deptnm}"/></li>
                                <li class="head"><label>학점</label></li>
                                <li><c:out value="${subjectInfo.crdts}"/></li>
                            </ul>
                        </div>

                        <!-- 교수 정보 -->
                        <h4 class="sub-title">교수 정보</h4>
                        <div class="table-wrap">
                            <table class="table-type1">
                                <colgroup>
                                    <col style="width:22%">
                                    <col style="width:22%">
                                    <col style="width:22%">
                                    <col>
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>교수</th>
                                    <th>소속</th>
                                    <th>연락처</th>
                                    <th>이메일</th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <td data-th="교수">담당교수 : <c:out value="${profInfo.usernm}"/></td>
                                    <td data-th="소속"><c:out value="${profInfo.deptnm}"/></td>
                                    <td data-th="연락처">-</td>
                                    <td data-th="이메일"><c:out value="${profInfo.eml}"/></td>
                                </tr>
                                <c:if test="${not empty coprofList}">
                                    <c:forEach var="r" items="${coprofList}">
                                        <tr>
                                            <td data-th="교수">공동교수 : <c:out value="${r.usernm}"/></td>
                                            <td data-th="소속"><c:out value="${r.deptnm}"/></td>
                                            <td data-th="연락처">-</td>
                                            <td data-th="이메일"><c:out value="${r.eml}"/></td>
                                        </tr>
                                    </c:forEach>
                                </c:if>
                                </tbody>
                            </table>
                        </div>
                        <div class="msg-box basic">
                            <ul class="list-asterisk">
                                <li>담당교수 : 해당학기 시험, 과제 등의 실제 수업을 담당하는 교수</li>
                            </ul>
                        </div>

                        <!-- 튜터 정보 -->
                        <h4 class="sub-title">튜터 정보</h4>
                        <div class="table-wrap">
                            <table class="table-type1">
                                <colgroup>
                                    <col style="width:22%">
                                    <col style="width:22%">
                                    <col style="width:22%">
                                    <col>
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>튜터</th>
                                    <th>연락처</th>
                                    <th>핸드폰</th>
                                    <th>이메일</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:choose>
                                    <c:when test="${not empty tutList}">
                                        <c:forEach var="r" items="${tutList}">
                                            <tr>
                                                <td data-th="튜터"><c:out value="${r.usernm}"/></td>
                                                <td data-th="연락처">-</td>
                                                <td data-th="핸드폰">-</td>
                                                <td data-th="이메일"><c:out value="${r.eml}"/></td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="4" class="t_center">데이터가 없습니다.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <!-- 조교 정보 -->
                        <h4 class="sub-title">조교 정보</h4>
                        <div class="table-wrap">
                            <table class="table-type1">
                                <colgroup>
                                    <col style="width:22%">
                                    <col style="width:22%">
                                    <col style="width:22%">
                                    <col>
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>조교</th>
                                    <th>연락처</th>
                                    <th>핸드폰</th>
                                    <th>이메일</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:choose>
                                    <c:when test="${not empty assiList}">
                                        <c:forEach var="r" items="${assiList}">
                                            <tr>
                                                <td data-th="조교"><c:out value="${r.usernm}"/></td>
                                                <td data-th="연락처">-</td>
                                                <td data-th="핸드폰">-</td>
                                                <td data-th="이메일"><c:out value="${r.eml}"/></td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="4" class="t_center">데이터가 없습니다.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <!-- 강의 개요 -->
                        <h4 class="sub-title">강의 개요</h4>
                        <div class="table_list">
                            <ul class="list">
                                <li class="head"><label class="req">교과목 개요</label></li>
                                <li>
                                    <textarea class="form-control" style="width:100%;height:90px"
                                              name="crclmnOtln"
                                              maxLenCheck="byte,4000,true,false"
                                              required="true"><c:out value="${lctrPlandocInfo.crclmnOtln}"/></textarea>
                                </li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label class="req">강의 목표</label></li>
                                <li>
                                    <textarea class="form-control" style="width:100%;height:90px"
                                              name="lctrGoal"
                                              maxLenCheck="byte,4000,true,false"
                                              required="true"><c:out value="${lctrPlandocInfo.lctrGoal}"/></textarea>
                                </li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label class="req">운영 방침</label></li>
                                <li>
                                    <textarea class="form-control" style="width:100%;height:90px"
                                              name="lctrOpGdln"
                                              maxLenCheck="byte,4000,true,false"
                                              required="true"><c:out value="${lctrPlandocInfo.lctrOpGdln}"/></textarea>
                                </li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label class="req">운영 계획</label></li>
                                <li>
                                    <textarea class="form-control" style="width:100%;height:90px"
                                              name="lctrOpPlan"
                                              maxLenCheck="byte,4000,true,false"
                                              required="true"><c:out value="${lctrPlandocInfo.lctrOpPlan}"/></textarea>
                                </li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label>관련 과목 내용</label></li>
                                <li>
                                    <textarea class="form-control" style="width:100%;height:90px"
                                              name="rltdSbjctCts"
                                              maxLenCheck="byte,4000,true,false"><c:out value="${lctrPlandocInfo.rltdSbjctCts}"/></textarea>
                                </li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label>참고 사항</label></li>
                                <li>
                                    <textarea class="form-control" style="width:100%;height:90px"
                                              name="remakrs"
                                              maxLenCheck="byte,4000,true,false"><c:out value="${lctrPlandocInfo.remakrs}"/></textarea>
                                </li>
                            </ul>
                        </div>

                        <!-- 교재 -->
                        <div class="board_top">
                            <h3 class="board-title">교재</h3>
                            <div class="right-area">
                                <button type="button" class="btn type3" onclick="addTxtbkRow()">교재 추가</button>
                                <button type="button" class="btn type2" onclick="removeCheckedTxtbkRows()">교재 삭제</button>
                            </div>
                        </div>
                        <div class="table-wrap">
                            <table class="table-type1" id="txtbkTable">
                                <colgroup>
                                    <col style="width:4%"/>
                                    <col style="width:6%"/>
                                    <col style="width:14%"/>
                                    <col style="width:36%"/>
                                    <col style="width:16%"/>
                                    <col style="width:12%"/>
                                    <col style="width:12%"/>
                                </colgroup>
                                <thead>
                                <tr>
                                    <th class="t_center">
                                        <span class="custom-input onlychk">
                                            <input type="checkbox" id="txtbkAll">
                                            <label for="txtbkAll"></label>
                                        </span>
                                    </th>
                                    <th>No</th>
                                    <th>구분</th>
                                    <th class="req">교재명</th>
                                    <th>ISBN</th>
                                    <th>저자</th>
                                    <th>출판사</th>
                                </tr>
                                </thead>
                                <tbody id="txtbkTbody">
                                <c:choose>
                                    <c:when test="${not empty txtbkList}">
                                        <c:forEach var="r" items="${txtbkList}" varStatus="st">
                                            <tr class="txtbk-row">
                                                <td class="t_center">
                                                    <span class="custom-input onlychk">
                                                        <input type="checkbox" class="txtbkChk" id="txtbkChk_${st.index}">
                                                        <label for="txtbkChk_${st.index}"></label>
                                                    </span>
                                                    <input type="hidden" name="txtbkList[${st.index}].txtbkId" value="<c:out value='${r.txtbkId}'/>">
                                                </td>
                                                <td class="t_center txtbkNo"><c:out value="${st.count}"/></td>
                                                <td data-th="구분" class="t_center">
                                                    <select class="form-select compact" name="txtbkList[${st.index}].txtbkGbncd">
                                                        <c:forEach var="c" items="${txtbkGbncdList}">
                                                            <option value="<c:out value='${c.cd}'/>"
                                                                    <c:if test="${c.cd eq r.txtbkGbncd}">selected</c:if>>
                                                                <c:out value="${c.cdnm}"/>
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </td>
                                                <td data-th="교재명" class="t_left">
                                                    <input type="text" class="form-control width-100per"
                                                           name="txtbkList[${st.index}].txtbknm"
                                                           value="<c:out value='${r.txtbknm}'/>"
                                                           inputmask="byte" maxLen="300" required="true">
                                                </td>
                                                <td data-th="ISBN" class="t_center">
                                                    <input type="text" class="form-control width-100per"
                                                           name="txtbkList[${st.index}].isbn"
                                                           value="<c:out value='${r.isbn}'/>"
                                                           inputmask="etc" mask="9{0,30}">
                                                </td>
                                                <td data-th="저자" class="t_left">
                                                    <input type="text" class="form-control width-100per"
                                                           name="txtbkList[${st.index}].wrtr"
                                                           value="<c:out value='${r.wrtr}'/>"
                                                           inputmask="byte" maxLen="300">
                                                </td>
                                                <td data-th="출판사" class="t_left">
                                                    <input type="text" class="form-control width-100per"
                                                           name="txtbkList[${st.index}].pblshr"
                                                           value="<c:out value='${r.pblshr}'/>"
                                                           inputmask="byte" maxLen="300">
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr class="no-data">
                                            <td colspan="7" class="t_center">등록된 교재가 없습니다. 교재 추가를 눌러 입력하세요.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <!-- 첨부파일 -->
                        <div class="file-wrap">
                            <input type="hidden" name="uploadPath" id="uploadPath" value="${uploadPath}"/>

                            <input type="hidden" name="noteUploadFiles" id="noteUploadFiles" value=""/>
                            <input type="hidden" name="voiceUploadFiles" id="voiceUploadFiles" value=""/>
                            <input type="hidden" name="trainingUploadFiles" id="trainingUploadFiles" value=""/>

                            <input type="hidden" name="noteDelFileIdStr" id="noteDelFileIdStr" value=""/>
                            <input type="hidden" name="voiceDelFileIdStr" id="voiceDelFileIdStr" value=""/>
                            <input type="hidden" name="trainingDelFileIdStr" id="trainingDelFileIdStr" value=""/>

                            <table class="table-type5">
                                <colgroup>
                                    <col class="width-15per"/>
                                    <col class=""/>
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th><label>강의노트</label></th>
                                    <td>
                                        <uiex:dextuploader
                                                id="noteFileUploader"
                                                path="${uploadPath}"
                                                limitCount="1"
                                                limitSize="100"
                                                oneLimitSize="100"
                                                listSize="1"
                                                fileList="${noteFileList}"
                                                finishFunc="finishNoteUpload()"
                                                allowedTypes="*"
                                        />
                                    </td>
                                </tr>
                                <tr>
                                    <th><label>음성파일</label></th>
                                    <td>
                                        <uiex:dextuploader
                                                id="voiceFileUploader"
                                                path="${uploadPath}"
                                                limitCount="1"
                                                limitSize="100"
                                                oneLimitSize="100"
                                                listSize="1"
                                                fileList="${voiceFileList}"
                                                finishFunc="finishVoiceUpload()"
                                                allowedTypes="*"
                                        />
                                    </td>
                                </tr>
                                <tr>
                                    <th><label>실습지도 첨부파일</label></th>
                                    <td>
                                        <uiex:dextuploader
                                                id="trainingFileUploader"
                                                path="${uploadPath}"
                                                limitCount="1"
                                                limitSize="100"
                                                oneLimitSize="100"
                                                listSize="1"
                                                fileList="${trainingFileList}"
                                                finishFunc="finishTrainingUpload()"
                                                allowedTypes="*"
                                        />
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>


                        <div class="msg-box basic">
                            <ul class="list-asterisk">
                                <li>주교재 선정된 경우나 과목 특성에 따라 강의노트가 제공되지 않을 수 있습니다.</li>
                                <li>과목의 특성에 따라 제공여부가 변경/취소 혹은 일부 차시만 제공될 수 있습니다.</li>
                            </ul>
                        </div>

                        <!-- 평가방법 -->
                        <h4 class="sub-title">평가방법</h4>
                        <div class="table_list">
                            <ul class="list">
                                <li class="head"><label>평가방법</label></li>
                                <li>
                                    <c:choose>
                                        <c:when test="${empty mrkEvlInfo}">-</c:when>
                                        <c:otherwise>
                                            <c:out value="${mrkEvlInfo.cdnm}"/> : <c:out value="${mrkEvlInfo.cdExpln}"/>
                                        </c:otherwise>
                                    </c:choose>
                                </li>
                            </ul>
                        </div>

                        <!-- 평가비율 -->
                        <div class="board_top">
                            <h3 class="board-title">평가비율</h3>
                            <div class="right-area">
                                <span>합계: <b id="sumRate">0</b>%</span>
                            </div>
                        </div>
                        <div class="table-wrap">
                            <c:set var="atndcColspan" value="0"/>
                            <c:set var="atndcUseyn" value="N"/>
                            <c:set var="atndcMrkOyn" value="N"/>
                            <c:forEach var="c" items="${mrkItmStngList}">
                                <c:set var="isAtndc" value="${c.grpcd eq 'ATNDC' or c.mrkItmTycd eq 'PRG' or c.mrkItmTycd eq 'EXRCS_QSTN'}"/>
                                <c:if test="${isAtndc}">
                                    <c:set var="atndcColspan" value="${atndcColspan + 1}"/>
                                    <c:if test="${c.mrkItmUseyn eq 'Y'}"><c:set var="atndcUseyn" value="Y"/></c:if>
                                    <c:if test="${c.mrkOyn eq 'Y'}"><c:set var="atndcMrkOyn" value="Y"/></c:if>
                                </c:if>
                            </c:forEach>
                            <table class="table-type1" id="mrkTable">
                                <colgroup>
                                    <col style="width:10%">
                                    <c:forEach var="c" items="${mrkItmStngList}">
                                        <col style="width:10%">
                                    </c:forEach>
                                </colgroup>
                                <thead>
                                <tr>
                                    <th rowspan="2">평가항목</th>
                                    <c:set var="atndcHeaderPrinted" value="N"/>
                                    <c:forEach var="c" items="${mrkItmStngList}" varStatus="st">
                                        <c:set var="isAtndc" value="${c.grpcd eq 'ATNDC' or c.mrkItmTycd eq 'PRG' or c.mrkItmTycd eq 'EXRCS_QSTN'}"/>
                                        <c:choose>
                                            <c:when test="${isAtndc and atndcHeaderPrinted ne 'Y'}">
                                                <th colspan="${atndcColspan}">출석</th>
                                                <c:set var="atndcHeaderPrinted" value="Y"/>
                                            </c:when>
                                            <c:when test="${not isAtndc}">
                                                <th rowspan="2">
                                                    <c:out value="${c.mrkItmTynm}"/>
                                                    <input type="hidden" name="mrkItmStngList[${st.index}].mrkItmTycd" value="<c:out value='${c.mrkItmTycd}'/>"/>
                                                    <input type="hidden" name="mrkItmStngList[${st.index}].mrkItmStngId" value="<c:out value='${c.mrkItmStngId}'/>"/>
                                                    <input type="hidden" name="mrkItmStngList[${st.index}].mrkItmUseyn" value="<c:out value='${c.mrkItmUseyn}'/>"/>
                                                </th>
                                            </c:when>
                                        </c:choose>
                                    </c:forEach>
                                </tr>
                                <tr>
                                    <c:forEach var="c" items="${mrkItmStngList}" varStatus="st">
                                        <c:set var="isAtndc" value="${c.grpcd eq 'ATNDC' or c.mrkItmTycd eq 'PRG' or c.mrkItmTycd eq 'EXRCS_QSTN'}"/>
                                        <c:if test="${isAtndc}">
                                            <th>
                                                <c:out value="${c.mrkItmTynm}"/>
                                                <input type="hidden" name="mrkItmStngList[${st.index}].mrkItmTycd" value="<c:out value='${c.mrkItmTycd}'/>"/>
                                                <input type="hidden" name="mrkItmStngList[${st.index}].mrkItmStngId" value="<c:out value='${c.mrkItmStngId}'/>"/>
                                                <input type="hidden" name="mrkItmStngList[${st.index}].mrkItmUseyn" value="<c:out value='${c.mrkItmUseyn}'/>"/>
                                            </th>
                                        </c:if>
                                    </c:forEach>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <th class="req" data-th="평가항목">비율 (%)</th>
                                    <c:forEach var="c" items="${mrkItmStngList}" varStatus="st">
                                        <td data-th="${c.mrkItmTynm}" class="t_center">
                                            <c:choose>
                                                <c:when test="${c.mrkItmUseyn eq 'Y'}">
                                                    <input class="form-control t_center mrk-rate"
                                                           style="width:80px;display:inline-block;"
                                                           name="mrkItmStngList[${st.index}].mrkRfltrt"
                                                           value="<c:out value='${c.mrkRfltrt}'/>"
                                                           inputmask="numeric"
                                                           mask="999.99"
                                                           maxVal="100"/>
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                    </c:forEach>
                                </tr>
                                <tr>
                                    <th class="req" data-th="평가항목">성적공개여부</th>
                                    <c:set var="atndcOynPrinted" value="N"/>
                                    <c:forEach var="c" items="${mrkItmStngList}" varStatus="st">
                                        <c:set var="isAtndc" value="${c.grpcd eq 'ATNDC' or c.mrkItmTycd eq 'PRG' or c.mrkItmTycd eq 'EXRCS_QSTN'}"/>
                                        <c:choose>
                                            <c:when test="${isAtndc and atndcOynPrinted ne 'Y'}">
                                                <td data-th="출석" class="t_center" colspan="${atndcColspan}">
                                                    <c:choose>
                                                        <c:when test="${atndcUseyn eq 'Y'}">
                                                            <input type="checkbox" id="mrkOyn_ATNDC" class="switch yesno mrk-oyn" data-mrk-group="ATNDC" <c:if test="${atndcMrkOyn eq 'Y'}">checked="checked"</c:if>>
                                                            <c:forEach var="atndc" items="${mrkItmStngList}" varStatus="atndcSt">
                                                                <c:set var="isAtndcSub" value="${atndc.grpcd eq 'ATNDC' or atndc.mrkItmTycd eq 'PRG' or atndc.mrkItmTycd eq 'EXRCS_QSTN'}"/>
                                                                <c:if test="${isAtndcSub}">
                                                                    <input type="hidden" name="mrkItmStngList[${atndcSt.index}].mrkOyn" id="mrkOynHidden_${atndcSt.index}" class="mrk-oyn-hidden" data-mrk-group="ATNDC" value="<c:out value='${atndcMrkOyn}'/>"/>
                                                                </c:if>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <c:set var="atndcOynPrinted" value="Y"/>
                                            </c:when>
                                            <c:when test="${not isAtndc}">
                                                <td data-th="${c.mrkItmTynm}" class="t_center">
                                                    <c:choose>
                                                        <c:when test="${c.mrkItmUseyn eq 'Y'}">
                                                            <input type="checkbox" id="mrkOyn_${st.index}" class="switch yesno mrk-oyn" data-mrk-index="${st.index}" <c:if test="${c.mrkOyn eq 'Y'}">checked="checked"</c:if>>
                                                            <input type="hidden" name="mrkItmStngList[${st.index}].mrkOyn" id="mrkOynHidden_${st.index}" class="mrk-oyn-hidden" value="<c:out value='${c.mrkOyn}'/>"/>
                                                        </c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </c:when>
                                        </c:choose>
                                    </c:forEach>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="msg-box basic">
                            <ul class="list-asterisk">
                                <li>평가비율 합계는 100%여야 저장됩니다.</li>
                                <li>출석 : 출석 마감일까지 중간/기말고사를 제외하고 70%이상 수강해야 하며, 70%미만일 경우 F학점(0점) 처리됩니다.</li>
                                <li>정기시험 (중간/기말)에 모두 미응시 경우 학점(0점) 처리됩니다.</li>
                            </ul>
                        </div>

                        <c:forEach var="exam" items="${rltmExamList}" varStatus="st">
                            <c:set var="examTitle" value="${exam.rltmExamGbncd eq 'EXAM_MID' ? '중간고사 시험정보' : '기말고사 시험정보'}"/>
                            <h4 class="sub-title"><c:out value="${examTitle}"/></h4>
                            <input type="hidden" name="rltmExamList[${st.index}].rltmExamId" value="<c:out value='${exam.rltmExamId}'/>"/>
                            <input type="hidden" name="rltmExamList[${st.index}].rltmExamGbncd" value="<c:out value='${exam.rltmExamGbncd}'/>"/>
                            <div class="table-wrap">
                                <table class="table-type5">
                                    <colgroup>
                                        <col style="width:18%">
                                        <col style="width:28%">
                                        <col style="width:18%">
                                        <col style="width:36%">
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th>시험유형</th>
                                        <td colspan="3">
                                            <c:forEach var="c" items="${examTycdList}">
                                                <span class="custom-input">
                                                    <input type="radio" id="rltmExam_${st.index}_examTycd_${c.cd}"
                                                           name="rltmExamList[${st.index}].examTycd" value="<c:out value='${c.cd}'/>"
                                                           <c:if test="${exam.examTycd eq c.cd or (empty exam.examTycd and c.cd eq 'EXAM')}">checked</c:if>>
                                                    <label for="rltmExam_${st.index}_examTycd_${c.cd}"><c:out value="${c.cdnm}"/></label>
                                                </span>
                                            </c:forEach>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>시험문제출제위임</th>
                                        <td>
                                            <span class="custom-input">
                                                <input type="radio" class="rltm-qstns-dlgtn-yn"
                                                       name="rltmExamList[${st.index}].examQstnsDlgtnyn"
                                                       id="rltmExam_${st.index}_examQstnsDlgtnynY" value="Y"
                                                       <c:if test="${exam.examQstnsDlgtnyn eq 'Y'}">checked</c:if>>
                                                <label for="rltmExam_${st.index}_examQstnsDlgtnynY">예</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" class="rltm-qstns-dlgtn-yn"
                                                       name="rltmExamList[${st.index}].examQstnsDlgtnyn"
                                                       id="rltmExam_${st.index}_examQstnsDlgtnynN" value="N"
                                                       <c:if test="${empty exam.examQstnsDlgtnyn or exam.examQstnsDlgtnyn ne 'Y'}">checked</c:if>>
                                                <label for="rltmExam_${st.index}_examQstnsDlgtnynN">아니오</label>
                                            </span>
                                        </td>
                                        <th>출제위임대상자</th>
                                        <td>
                                            <select class="form-select compact rltm-qstns-trgtr"
                                                    id="rltmExam_${st.index}_qstnsTrgtr"
                                                    name="rltmExamList[${st.index}].qstnsTrgtr" style="width:220px;"
                                                    <c:if test="${empty exam.examQstnsDlgtnyn or exam.examQstnsDlgtnyn ne 'Y'}">disabled="disabled"</c:if>>
                                                <option value="">위임 대상자 선택</option>
                                                <c:forEach var="u" items="${examQstnsTrgtrList}">
                                                    <option value="<c:out value='${u.userId}'/>" <c:if test="${exam.qstnsTrgtr eq u.userId}">selected</c:if>><c:out value="${u.usernm}"/></option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>실시간응시구분</th>
                                        <td colspan="3">
                                            <c:forEach var="c" items="${rltmTkexamGbncdList}">
                                                <span class="custom-input">
                                                    <input type="radio" id="rltmExam_${st.index}_rltmTkexamGbncd_${c.cd}"
                                                           name="rltmExamList[${st.index}].rltmTkexamGbncd" value="<c:out value='${c.cd}'/>"
                                                           <c:if test="${exam.rltmTkexamGbncd eq c.cd or (empty exam.rltmTkexamGbncd and c.cd eq 'RLTM_CNCRNT_EXAM')}">checked</c:if>>
                                                    <label for="rltmExam_${st.index}_rltmTkexamGbncd_${c.cd}"><c:out value="${c.cdnm}"/></label>
                                                    <small class="note"><c:out value="${c.cdExpln}"/></small>
                                                </span>
                                            </c:forEach>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>시험시간</th>
                                        <td colspan="3">
                                            <div class="input_btn">
                                                <input class="form-control sm" type="text" name="rltmExamList[${st.index}].examMnts"
                                                       value="<c:out value='${exam.examMnts}'/>" inputmask="numeric" maxVal="9999999" autocomplete="off"><label>분</label>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>성적공개</th>
                                        <td colspan="3">
                                            <span class="custom-input"><input type="radio" name="rltmExamList[${st.index}].mrkOyn" id="rltmExam_${st.index}_mrkOynY" value="Y"
                                                                              <c:if test="${exam.mrkOyn eq 'Y'}">checked</c:if>><label for="rltmExam_${st.index}_mrkOynY">예</label></span>
                                            <span class="custom-input"><input type="radio" name="rltmExamList[${st.index}].mrkOyn" id="rltmExam_${st.index}_mrkOynN" value="N"
                                                                              <c:if test="${empty exam.mrkOyn or exam.mrkOyn ne 'Y'}">checked</c:if>><label for="rltmExam_${st.index}_mrkOynN">아니오</label></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>시험지공개</th>
                                        <td colspan="3">
                                            <span class="custom-input">
                                                <input type="radio" class="rltm-end-examppr-oyn"
                                                       name="rltmExamList[${st.index}].endExampprOyn"
                                                       id="rltmExam_${st.index}_endExampprOynY" value="Y"
                                                       <c:if test="${exam.endExampprOyn eq 'Y'}">checked</c:if>>
                                                <label for="rltmExam_${st.index}_endExampprOynY">예</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" class="rltm-end-examppr-oyn"
                                                       name="rltmExamList[${st.index}].endExampprOyn"
                                                       id="rltmExam_${st.index}_endExampprOynN" value="N"
                                                       <c:if test="${empty exam.endExampprOyn or exam.endExampprOyn ne 'Y'}">checked</c:if>>
                                                <label for="rltmExam_${st.index}_endExampprOynN">아니오</label>
                                            </span>
                                            <div class="exam-option-row rltm-open-optn-area" id="openOptnGbncdArea_${st.index}">
                                                <c:forEach var="c" items="${openOptnGbncdList}">
                                                    <span class="custom-input">
                                                        <input type="radio" id="rltmExam_${st.index}_openOptnGbncd_${c.cd}"
                                                               name="rltmExamList[${st.index}].openOptnGbncd"
                                                               value="<c:out value='${c.cd}'/>"
                                                               <c:if test="${exam.openOptnGbncd eq c.cd or (empty exam.openOptnGbncd and c.cd eq 'WHOL_OPEN')}">checked</c:if>
                                                               <c:if test="${empty exam.endExampprOyn or exam.endExampprOyn ne 'Y'}">disabled="disabled"</c:if>>
                                                        <label for="rltmExam_${st.index}_openOptnGbncd_${c.cd}"><c:out value="${c.cdnm}"/></label>
                                                    </span>
                                                </c:forEach>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>자동해석방지</th>
                                        <td colspan="3">
                                            <span class="custom-input"><input type="radio" name="rltmExamList[${st.index}].autoTrnsltnPrvntnyn" id="rltmExam_${st.index}_autoTrnsltnPrvntnynY" value="Y"
                                                                              <c:if test="${exam.autoTrnsltnPrvntnyn eq 'Y'}">checked</c:if>><label for="rltmExam_${st.index}_autoTrnsltnPrvntnynY">예</label></span>
                                            <span class="custom-input"><input type="radio" name="rltmExamList[${st.index}].autoTrnsltnPrvntnyn" id="rltmExam_${st.index}_autoTrnsltnPrvntnynN" value="N"
                                                                              <c:if test="${empty exam.autoTrnsltnPrvntnyn or exam.autoTrnsltnPrvntnyn ne 'Y'}">checked</c:if>><label for="rltmExam_${st.index}_autoTrnsltnPrvntnynN">아니오</label></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>음성/동영상 포함</th>
                                        <td colspan="3">
                                            <span class="custom-input"><input type="radio" name="rltmExamList[${st.index}].voiceVdoIncldyn" id="rltmExam_${st.index}_voiceVdoIncldynY" value="Y"
                                                                              <c:if test="${exam.voiceVdoIncldyn eq 'Y'}">checked</c:if>><label for="rltmExam_${st.index}_voiceVdoIncldynY">예</label></span>
                                            <span class="custom-input"><input type="radio" name="rltmExamList[${st.index}].voiceVdoIncldyn" id="rltmExam_${st.index}_voiceVdoIncldynN" value="N"
                                                                              <c:if test="${empty exam.voiceVdoIncldyn or exam.voiceVdoIncldyn ne 'Y'}">checked</c:if>><label for="rltmExam_${st.index}_voiceVdoIncldynN">아니오</label></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>시험운영권한위임</th>
                                        <td colspan="3">
                                            <span class="custom-input"><input type="radio" name="rltmExamList[${st.index}].examOpAuthDlgtnyn" id="rltmExam_${st.index}_examOpAuthDlgtnynY" value="Y"
                                                                              <c:if test="${exam.examOpAuthDlgtnyn eq 'Y'}">checked</c:if>><label for="rltmExam_${st.index}_examOpAuthDlgtnynY">예</label></span>
                                            <span class="custom-input"><input type="radio" name="rltmExamList[${st.index}].examOpAuthDlgtnyn" id="rltmExam_${st.index}_examOpAuthDlgtnynN" value="N"
                                                                              <c:if test="${empty exam.examOpAuthDlgtnyn or exam.examOpAuthDlgtnyn ne 'Y'}">checked</c:if>><label for="rltmExam_${st.index}_examOpAuthDlgtnynN">아니오</label></span>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </c:forEach>

                        <!-- 주차별 강의내용 -->
                        <h4 class="sub-title">주차별 강의내용</h4>
                        <div class="table-wrap">
                            <table class="table-type1" id="wkTable">
                                <colgroup>
                                    <col style="width:8%"/>
                                    <col style="width:8%"/>
                                    <col style="width:14%"/>
                                    <col/>
                                    <col style="width:12%"/>
                                </colgroup>
                                <thead>
                                <tr>
                                    <th rowspan="2">상태</th>
                                    <th rowspan="2">주차</th>
                                    <th>강의 구분</th>
                                    <th>강의 제목</th>
                                    <th rowspan="2">담당교수</th>
                                </tr>
                                <tr>
                                    <th colspan="2">강의 내용</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:choose>
                                    <c:when test="${not empty lectureScheduleList}">
                                        <c:forEach var="r" items="${lectureScheduleList}" varStatus="st">
                                            <tr class="wk-head" data-wk-index="${st.index}">
                                                <td class="t_center" rowspan="2">
                                                    <span class="wkStsTxt">-</span>

                                                    <input type="hidden" name="wkList[${st.index}].wkChgyn" value="N" class="wkChgyn">
                                                    <input type="hidden" name="wkList[${st.index}].lctrWknoSchdlId" value="<c:out value='${r.lctrWknoSchdlId}'/>">
                                                    <input type="hidden" name="wkList[${st.index}].lctrWkno" value="<c:out value='${r.lctrWkno}'/>">

                                                    <input type="hidden" class="wkOrigTy" value="<c:out value='${r.lctrTycd}'/>">
                                                    <input type="hidden" class="wkOrigTitle" value="<c:out value='${r.lctrTtl}'/>">
                                                    <input type="hidden" class="wkOrigCts" value="<c:out value='${r.lctrCts}'/>">
                                                </td>

                                                <td class="t_center" rowspan="2">
                                                    <c:out value="${r.lctrWkno}"/>
                                                </td>

                                                <td class="t_center">
                                                    <select class="form-select compact wkWatch"
                                                            name="wkList[${st.index}].lctrTycd">
                                                        <c:forEach var="c" items="${lctrTycdList}">
                                                            <option value="<c:out value='${c.cd}'/>"
                                                                    <c:if test="${c.cd eq r.lctrTycd}">selected</c:if>>
                                                                <c:out value="${c.cdnm}"/>
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </td>

                                                <td class="t_left">
                                                    <input type="text"
                                                           class="form-control width-100per wkWatch"
                                                           name="wkList[${st.index}].lctrTtl"
                                                           value="<c:out value='${r.lctrTtl}'/>"
                                                           inputmask="byte"
                                                           maxLen="4000">
                                                </td>

                                                <td class="t_center" rowspan="2">
                                                    <c:out value="${profInfo.usernm}"/>
                                                </td>
                                            </tr>

                                            <tr class="wk-body" data-wk-index="${st.index}">
                                                <td colspan="2" class="t_left">
                                                    <textarea class="form-control wkWatch"
                                                              name="wkList[${st.index}].lctrCts"
                                                              style="width:100%; height:80px;"
                                                              maxLenCheck="byte,4000,true,false"><c:out value="${r.lctrCts}"/></textarea>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="5" class="t_center">데이터가 없습니다.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                                </tbody>
                            </table>
                        </div>
                        <div class="msg-box basic">
                            <ul class="list-asterisk">
                                <li>강의 내용은 사정에 따라 변경될 수 있습니다.</li>
                            </ul>
                        </div>

                        <!-- 장애인/고령자 지원 -->
                        <h4 class="sub-title">장애인/고령자 지원</h4>
                        <div class="table-wrap">
                            <table class="table-type1">
                                <colgroup>
                                    <col style="width:25%">
                                    <col style="width:25%">
                                    <col style="width:25%">
                                    <col style="width:25%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th colspan="4">콘텐츠 내 학습지원 기능</th>
                                </tr>
                                <tr>
                                    <th>플레이어 단축키</th>
                                    <th>스크립트</th>
                                    <th>자막</th>
                                    <th>재생속도 조절</th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <td data-th="플레이어 단축키" class="t_center">
                                        <span class="custom-input">
                                            <input type="checkbox" id="plyrShrtctKeyPvsnyn"
                                                   <c:if test="${lctrPlandocInfo.plyrShrtctKeyPvsnyn eq 'Y'}">checked</c:if>>
                                            <label for="plyrShrtctKeyPvsnyn">제공</label>
                                        </span>
                                        <input type="hidden" name="plyrShrtctKeyPvsnyn"
                                               id="plyrShrtctKeyPvsnynHidden"
                                               value="<c:out value='${lctrPlandocInfo.plyrShrtctKeyPvsnyn}'/>"/>
                                    </td>
                                    <td data-th="스크립트" class="t_center">
                                        <span class="custom-input">
                                            <input type="checkbox" id="scrptPvsnyn"
                                                   <c:if test="${lctrPlandocInfo.scrptPvsnyn eq 'Y'}">checked</c:if>>
                                            <label for="scrptPvsnyn">제공</label>
                                        </span>
                                        <input type="hidden" name="scrptPvsnyn"
                                               id="scrptPvsnynHidden"
                                               value="<c:out value='${lctrPlandocInfo.scrptPvsnyn}'/>"/>
                                    </td>
                                    <td data-th="자막" class="t_center">
                                        <span class="custom-input">
                                            <input type="checkbox" id="sbttlsPvsnyn"
                                                   <c:if test="${lctrPlandocInfo.sbttlsPvsnyn eq 'Y'}">checked</c:if>>
                                            <label for="sbttlsPvsnyn">제공</label>
                                        </span>
                                        <input type="hidden" name="sbttlsPvsnyn"
                                               id="sbttlsPvsnynHidden"
                                               value="<c:out value='${lctrPlandocInfo.sbttlsPvsnyn}'/>"/>
                                    </td>
                                    <td data-th="재생속도 조절" class="t_center">
                                        <span class="custom-input">
                                            <input type="checkbox" id="plyrSpdAdjstPvsnyn"
                                                   <c:if test="${lctrPlandocInfo.plyrSpdAdjstPvsnyn eq 'Y'}">checked</c:if>>
                                            <label for="plyrSpdAdjstPvsnyn">제공</label>
                                        </span>
                                        <input type="hidden" name="plyrSpdAdjstPvsnyn"
                                               id="plyrSpdAdjstPvsnynHidden"
                                               value="<c:out value='${lctrPlandocInfo.plyrSpdAdjstPvsnyn}'/>"/>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="msg-box basic">
                            <ul class="list-asterisk">
                                <li>개발 방식에 따라 일부 주차 혹은 페이지는 제공되지 않을 수 있습니다.</li>
                                <li>미디어 플레이어 단축키</li>
                            </ul>
                            <ul class="list-bullet">
                                <li>미디어 일시정지/재생 : Space Bar</li>
                                <li>재생 속도 : Z (1배속), X (느리게), C (빠르게)</li>
                                <li>볼륨 : 위쪽 방향키 (크게), 아래쪽 방향키 (작게)</li>
                                <li>이동 : 왼쪽 방향키 (10초 전), 오른쪽 방향키 (10초 후)</li>
                                <li>전체 화면 : F</li>
                            </ul>
                        </div>

                        <!-- 시험 지원 -->
                        <div class="table_list">
                            <ul class="list">
                                <li class="head"><label>시험 지원</label></li>
                                <li>온라인 시험 시간 연장 : 단, 담당교수의 운영방침에 따라 부여되지 않을 수 있습니다.</li>
                            </ul>
                        </div>

                        <div class="btns">
                            <button type="button" class="btn type1" onclick="savePlandoc()">저장</button>
                            <button type="button" class="btn type2"
                                    onclick="listPlandoc()">취소
                            </button>
                        </div>
                    </form>

                </div>
            </div>
        </div>

    </main>
</div>


</body>
</html>
