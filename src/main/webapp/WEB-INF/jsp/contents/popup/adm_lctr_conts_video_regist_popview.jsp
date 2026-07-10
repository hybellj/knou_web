<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin, classroom"/>
        <jsp:param name="module" value="editor,fileuploader"/>
    </jsp:include>
    <script type="text/javascript">
        var ORG_ID = '<c:out value="${lctrContsVO.orgId}" />';
        var SBJCT_ID = '<c:out value="${lctrContsVO.sbjctId}" />';
        var LCTR_WKNO_SCHDL_ID = '<c:out value="${lctrContsVO.lctrWknoSchdlId}" />';
        var LCTR_ID = '<c:out value="${lctrContsVO.lctrId}" />';
        var LCTR_CONTS_ID = '<c:out value="${lctrContsVO.lctrContsId}" />';
        var MODE = '<c:out value="${mode}" />';
        var UPLOAD_PATH = '<c:out value="${lctrContsVO.uploadPath}" />';
        var sddnDialog = null;
        var selectedSddnRowKey = "";
        var sddnQstnRowIndex = ${fn:length(lctrContsVO.childContsList)};
        var srtRowIndex = ${fn:length(lctrContsVO.srtContsList)};
        var lrnTocEditor = null;
        var videoUploaderIds = ["sdVideoUploader", "hdVideoUploader"];
        var videoUploadResults = {};
        var currentVideoUploadIndex = 0;
        var currentVideoUploaderId = "";
        var srtUploaderIds = [];
        var srtUploadResults = {};
        var currentSrtUploadIndex = 0;
        var currentSrtUploaderId = "";
        var MAX_LCTR_CONTS_SECONDS = 9999999;

        $(document).ready(function() {
            initLearningContentEditor();
            initPlayTimeInputs();
            initSddnQstnRows();
            initSrtRows();
        });

        function isEditMode() {
            return MODE == "E";
        }

        // 학습내용 UIEditor를 초기화한다.
        function initLearningContentEditor() {
            lrnTocEditor = UiEditor({
                targetId: "lrnTocCts",
                uploadPath: UPLOAD_PATH,
                height: "170px"
            });
        }

        // 재생시간 입력 변경 시 총 초를 다시 계산한다.
        function initPlayTimeInputs() {
            var totalSeconds = Number($("#vdoMnts").val() || 0);
            if(isNaN(totalSeconds)) {
                totalSeconds = 0;
            }
            $("#vdoPlayMinutes").val(Math.floor(totalSeconds / 60));
            $("#vdoPlaySeconds").val(totalSeconds % 60);
            applyPositiveIntegerInputmask($(".play-time-input"));
            $(".play-time-input").on("keyup change blur", function() {
                updatePlayTimeTotal();
            });
            updatePlayTimeTotal();
        }

        // 분/초 입력값을 총 초로 변환한다.
        function updatePlayTimeTotal() {
            var minutes = parsePositiveInteger($("#vdoPlayMinutes").val());
            var seconds = parsePositiveInteger($("#vdoPlaySeconds").val());
            var totalSeconds = (minutes * 60) + seconds;
            $("#vdoMnts").val(totalSeconds);
            $("#vdoTotalSecondsText").text(totalSeconds).val(totalSeconds);
        }
        // 저장된 돌발퀴즈 데이터를 화면 row로 복원한다.
        function initSddnQstnRows() {
            if(!isEditMode()) {
                return;
            }
            // 수정 모드에서만 저장된 돌발퀴즈 row를 복원한다.
            $("#sddnQstnData .sddn-qstn-data").each(function() {
                addSddnQstnRow({
                    sddnQstnId: $(this).find(".data-sddn-qstn-id").val(),
                    sddnQstnPlySec: $(this).find(".data-sddn-qstn-ply-sec").val(),
                    contsnm: $(this).find(".data-contsnm").val()
                });
            });
        }

        // 저장된 자막 데이터를 화면 row와 동적 업로더로 복원한다.
        function initSrtRows() {
            if(!isEditMode()) {
                return;
            }
            // 수정 모드에서만 저장된 자막 row와 기존 파일을 복원한다.
            $("#srtContsData .srt-conts-data").each(function() {
                var fileList = [];
                $(this).find(".srt-file-data").each(function() {
                    fileList.push({
                        fileId: $(this).find(".data-file-id").val(),
                        fileNm: $(this).find(".data-file-nm").val(),
                        fileSize: Number($(this).find(".data-file-size").val() || 0)
                    });
                });
                addSrtRow({
                    lctrContsId: $(this).find(".data-lctr-conts-id").val(),
                    langCd: $(this).find(".data-lang-cd").val(),
                    fileList: fileList
                });
            });
        }

        // 화면에 노출되지 않는 언어코드 데이터로 select option을 만든다.
        function createLangCdOptions(selectedLangCd) {
            var html = "";
            $("#langCdData .lang-cd-data").each(function() {
                var cd = $(this).find(".data-cd").val();
                var cdnm = $(this).find(".data-cdnm").val();
                var selected = cd == selectedLangCd ? ' selected="selected"' : "";
                html += '<option value="' + escapeHtml(cd) + '"' + selected + '>' + escapeHtml(cdnm) + '</option>';
            });
            return html;
        }

        function escapeHtml(value) {
            return String(value || "")
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/"/g, "&quot;")
                .replace(/'/g, "&#39;");
        }

        function parsePositiveInteger(value) {
            var numberValue = Number(value || 0);
            if(isNaN(numberValue) || numberValue < 0) {
                return 0;
            }
            return Math.floor(numberValue);
        }

        function normalizePositiveIntegerInput(input, allowZero) {
            var $input = $(input);
            var value = String($input.val() || "").replace(/[^0-9]/g, "");
            if(value !== "") {
                var numberValue = parseInt(value, 10);
                var maxValue = Number($input.attr("maxVal") || 0);
                if(isNaN(numberValue)) {
                    value = "";
                } else if(!allowZero && numberValue <= 0) {
                    value = "";
                } else {
                    if(maxValue > 0 && numberValue > maxValue) {
                        numberValue = maxValue;
                    }
                    value = String(numberValue);
                }
            }
            $input.val(value);
        }

        function applyPositiveIntegerInputmask($inputs) {
            $inputs.each(function() {
                var $input = $(this);
                if($input.data("positiveIntegerInputmaskApplied")) {
                    return;
                }
                if($.isFunction($input.inputmask)) {
                    $input.inputmask("numeric", {placeholder: " ", rightAlign: true, showMaskOnFocus: true, allowMinus: false});
                }
                normalizePositiveIntegerInput(this, $input.hasClass("play-time-input"));
                $input.on("keyup change blur", function() {
                    normalizePositiveIntegerInput(this, $(this).hasClass("play-time-input"));
                });
                $input.data("positiveIntegerInputmaskApplied", true);
            });
        }

        // 돌발퀴즈 선택 row를 추가한다.
        function addSddnQstnRow(rowData) {
            rowData = rowData || {};
            var rowKey = "sddnQstnRow" + sddnQstnRowIndex++;
            var plySecInputId = rowKey + "_sddnQstnPlySec";
            var html = "";
            html += '<tr data-row-key="' + rowKey + '">';
            html += '    <th><spring:message code="contents.label.quiz.time"/><%-- 퀴즈시간 --%></th>';
            html += '    <td class="t_left">';
            html += '        <div class="input_btn">';
            html += '            <input class="form-control m sddn-qstn-ply-sec" id="' + plySecInputId + '" type="text" value="' + escapeHtml(rowData.sddnQstnPlySec) + '" maxlength="7" inputmask="numeric" maxVal="' + MAX_LCTR_CONTS_SECONDS + '" style="width:6em">';
            html += '            <label for="' + plySecInputId + '"><spring:message code="contents.label.second.unit"/><%-- 초 --%></label>';
            html += '        </div>';
            html += '    </td>';
            html += '    <th><spring:message code="contents.label.test.paper.select"/><%-- 시험지 선택 --%></th>';
            html += '    <td class="t_left">';
            html += '        <input type="hidden" class="sddn-qstn-id" value="' + escapeHtml(rowData.sddnQstnId) + '">';
            html += '        <div class="search-typeC input_btn full">';
            html += '            <input class="form-control width-100per sddn-qstn-nm" type="text" value="' + escapeHtml(rowData.contsnm) + '" placeholder="<spring:message code='contents.placeholder.sddn.quiz.search'/>" readonly="readonly"><%-- 돌발퀴즈 시험지 선택 --%>';
            html += '            <button type="button" class="btn basic icon search" aria-label="검색" onclick="openSddnQstnListPop(\'' + rowKey + '\');"><i class="icon-svg-search"></i></button>';
            html += '        </div>';
            html += '    </td>';
            html += '    <td><button type="button" class="btn basic small" onclick="removeSddnQstnRow(this);"><spring:message code="common.button.delete"/><%-- 삭제 --%></button></td>';
            html += '</tr>';
            $("#sddnQstnBody").append(html);
            applyPositiveIntegerInputmask($("#" + plySecInputId));
        }

        // 돌발퀴즈 선택 row를 삭제한다.
        function removeSddnQstnRow(button) {
            $(button).closest("tr").remove();
        }

        // 자막 선택 row를 추가한다.
        function addSrtRow(rowData) {
            rowData = rowData || {};
            var rowKey = "srtRow" + srtRowIndex++;
            var uploaderId = "srtFileUploader_" + rowKey;
            var uploaderWrapId = "srtUploaderWrap_" + rowKey;
            var html = "";
            html += '<tr class="srt-conts-row" data-uploader-id="' + uploaderId + '">';
            html += '    <th><spring:message code="contents.label.language.code"/><%-- 언어코드 --%></th>';
            html += '    <td class="t_left">';
            html += '        <input type="hidden" class="srt-conts-id" value="' + escapeHtml(rowData.lctrContsId) + '">';
            html += '        <select class="form-select sm srt-lang-cd">' + createLangCdOptions(rowData.langCd || "") + '</select>';
            html += '    </td>';
            html += '    <th><spring:message code="contents.label.srt.file"/><%-- SRT자막 첨부파일 --%></th>';
            html += '    <td class="t_left"><div id="' + uploaderWrapId + '"></div></td>';
            html += '    <td><button type="button" class="btn basic small" onclick="removeSrtRow(this);"><spring:message code="common.button.delete"/><%-- 삭제 --%></button></td>';
            html += '</tr>';
            $("#srtContsBody").append(html);
            createSrtUploader(uploaderId, uploaderWrapId, rowData.fileList || []);
        }

        // 자막 선택 row를 삭제한다.
        function removeSrtRow(button) {
            var $row = $(button).closest("tr");
            var uploaderId = $row.attr("data-uploader-id");
            srtUploaderIds = srtUploaderIds.filter(function(uid) {
                return uid !== uploaderId;
            });
            delete srtUploadResults[uploaderId];
            $row.remove();
        }

        // 동적으로 추가한 자막 row의 DEXT 업로더를 생성한다.
        function createSrtUploader(uploaderId, uploaderWrapId, fileList) {
            UiFileUploader({
                id: uploaderId,
                targetId: uploaderWrapId,
                path: UPLOAD_PATH,
                limitCount: 1,
                limitSize: 100,
                oneLimitSize: 100,
                listSize: 1,
                fileList: fileList || [],
                finishFunc: completeSrtUpload,
                allowedTypes: "*",
                uiMode: "simple"
            });
            if(srtUploaderIds.indexOf(uploaderId) === -1) {
                srtUploaderIds.push(uploaderId);
            }
        }
        // 돌발퀴즈 선택 팝업을 연다.
        function openSddnQstnListPop(rowKey) {
            selectedSddnRowKey = rowKey;
            sddnDialog = UiDialog("sddnQstnDialog", {
                title: "<spring:message code='contents.label.sudden.quiz'/>", /* 돌발퀴즈 */
                width: 760,
                height: 520,
                url: "/contents/admConts/admLctrContsSddnQstnListPop.do?orgId=" + encodeURIComponent(ORG_ID) + "&sbjctId=" + encodeURIComponent(SBJCT_ID),
                autoresize: true
            });
            return false;
        }
        // 돌발퀴즈 선택값을 선택 row에 반영한다.
        function selectSddnQstn(item) {
            var $row = $("#sddnQstnBody tr[data-row-key='" + selectedSddnRowKey + "']");
            $row.find(".sddn-qstn-id").val(item.exrcsSddnQstnBscId || "");
            $row.find(".sddn-qstn-nm").val(item.qstnTtl || "");
            closeSddnQstnListPop();
        }

        // 돌발퀴즈 선택 팝업을 닫는다.
        function closeSddnQstnListPop() {
            if(sddnDialog) {
                sddnDialog.close();
                sddnDialog = null;
            }
        }

        // 입력값 검증 후 동영상/자막 업로드와 저장을 순차 처리한다.
        function validatePlayTime() {
            updatePlayTimeTotal();
            var totalSeconds = parsePositiveInteger($("#vdoMnts").val());
            if(totalSeconds <= 0) {
                UiComm.showMessage('<spring:message code="contents.msg.input.play.time.positive"/>', "warning"); /* 재생시간은 0보다 큰 숫자로 입력해 주세요. */
                return false;
            }
            if(totalSeconds > MAX_LCTR_CONTS_SECONDS) {
                UiComm.showMessage('<spring:message code="contents.msg.invalid.play.time.max"/>', "warning"); /* 재생시간은 9999999초 이하로 입력해 주세요. */
                return false;
            }
            return true;
        }

        function validateSddnQstnTimes() {
            var isValid = true;
            $("#sddnQstnBody tr").each(function() {
                var quizSeconds = parsePositiveInteger($(this).find(".sddn-qstn-ply-sec").val());
                if(quizSeconds <= 0) {
                    UiComm.showMessage('<spring:message code="contents.msg.input.quiz.time.positive"/>', "warning"); /* 퀴즈시간은 0보다 큰 숫자로 입력해 주세요. */
                    isValid = false;
                    return false;
                }
            });
            return isValid;
        }

        // 콘텐츠 저장.
        function saveLctrContsVideo() {
            var contsnm = $.trim($("#contsnm").val());
            if(!contsnm) {
                UiComm.showMessage('<spring:message code="common.pop.input.title"/>', "warning"); /* 제목을 입력하세요. */
                return false;
            }

            if(!validatePlayTime() || !validateSddnQstnTimes()) {
                return false;
            }

            if(lrnTocEditor && typeof lrnTocEditor.getPublishingHtml === "function") {
                $("#lrnTocCts").val(lrnTocEditor.getPublishingHtml());
            }
            startLctrContsSaveWithoutVideoUpload();
            return false;
        }

        // STEP 1: 동영상 업로드는 CDN 연동 방식 확정 전까지 보류하고 자막 업로드부터 처리한다.
        function startLctrContsSaveWithoutVideoUpload() {
            $("#saveBtn").prop("disabled", true);
            videoUploadResults = {};
            srtUploadResults = {};
            currentVideoUploadIndex = 0;
            currentVideoUploaderId = "";
            currentSrtUploadIndex = 0;
            currentSrtUploaderId = "";

            // TODO: SD/HD 동영상 업로드 방식 확정 후 startVideoUpload() 흐름으로 재연결한다.
            continueSrtUpload(0);
        }

        // STEP 1: Start SD/HD video upload chain.
        function startVideoUpload() {
            $("#saveBtn").prop("disabled", true);
            videoUploadResults = {};
            srtUploadResults = {};
            currentVideoUploadIndex = 0;
            currentVideoUploaderId = "";
            currentSrtUploadIndex = 0;
            currentSrtUploaderId = "";
            uploadVideoByIndex(0);
        }

        // STEP 2: Upload SD video, then HD video in order.
        function uploadVideoByIndex(videoIdx) {
            if(videoIdx >= videoUploaderIds.length) {
                continueSrtUpload(0);
                return;
            }

            var uploaderId = videoUploaderIds[videoIdx];
            var dx = dx5.get(uploaderId);
            currentVideoUploadIndex = videoIdx;
            currentVideoUploaderId = uploaderId;

            if(!dx) {
                videoUploadResults[uploaderId] = {uploadFiles: "", uploadPath: UPLOAD_PATH, delFileIdStr: ""};
                uploadVideoByIndex(videoIdx + 1);
                return;
            }

            if(dx.availUpload()) {
                dx.startUpload();
                return;
            }

            videoUploadResults[uploaderId] = {
                uploadFiles: "",
                uploadPath: dx.getUploadPath ? dx.getUploadPath() : UPLOAD_PATH,
                delFileIdStr: dx.getDelFileIdStr ? dx.getDelFileIdStr() : ""
            };
            uploadVideoByIndex(videoIdx + 1);
        }

        // STEP 3-1: Complete SD video upload.
        function finishSdVideoUpload() {
            finishVideoUpload("sdVideoUploader");
        }

        // STEP 3-2: Complete HD video upload.
        function finishHdVideoUpload() {
            finishVideoUpload("hdVideoUploader");
        }

        // STEP 3-3: Validate completed video upload result.
        function finishVideoUpload(uploaderId) {
            var currentUploaderId = uploaderId || currentVideoUploaderId;
            var videoIdx = videoUploaderIds.indexOf(currentUploaderId);
            if(videoIdx < 0) {
                videoIdx = currentVideoUploadIndex;
            }

            var dx = currentUploaderId ? dx5.get(currentUploaderId) : null;
            if(!dx) {
                uploadVideoByIndex(videoIdx + 1);
                return;
            }

            ajaxCall("/common/uploadFileCheck.do", {
                uploadFiles: dx.getUploadFiles(),
                uploadPath: dx.getUploadPath()
            }, function(res) {
                if(res.result > 0) {
                    videoUploadResults[currentUploaderId] = {
                        uploadFiles: dx.getUploadFiles(),
                        uploadPath: dx.getUploadPath(),
                        delFileIdStr: dx.getDelFileIdStr ? dx.getDelFileIdStr() : ""
                    };
                    uploadVideoByIndex(videoIdx + 1);
                } else {
                    $("#saveBtn").prop("disabled", false);
                    UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); /* 업로드를 실패하였습니다. */
                }
            }, function() {
                $("#saveBtn").prop("disabled", false);
                UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); /* 업로드를 실패하였습니다. */
            });
        }

        // STEP 4: Upload SRT subtitle files in row order.
        function continueSrtUpload(srtIdx) {
            if(srtIdx >= srtUploaderIds.length) {
                doSaveLctrContsVideo();
                return;
            }

            var uploaderId = srtUploaderIds[srtIdx];
            var dx = dx5.get(uploaderId);
            currentSrtUploadIndex = srtIdx;
            currentSrtUploaderId = uploaderId;

            if(!dx) {
                srtUploadResults[uploaderId] = {uploadFiles: "", uploadPath: UPLOAD_PATH, delFileIdStr: ""};
                continueSrtUpload(srtIdx + 1);
                return;
            }

            if(dx.availUpload()) {
                dx.startUpload();
                return;
            }

            srtUploadResults[uploaderId] = {
                uploadFiles: "",
                uploadPath: dx.getUploadPath ? dx.getUploadPath() : UPLOAD_PATH,
                delFileIdStr: dx.getDelFileIdStr ? dx.getDelFileIdStr() : ""
            };
            continueSrtUpload(srtIdx + 1);
        }

        // STEP 5: Validate completed SRT upload result.
        function completeSrtUpload(uploaderId) {
            var currentUploaderId = uploaderId || currentSrtUploaderId;
            var srtIdx = srtUploaderIds.indexOf(currentUploaderId);
            if(srtIdx < 0) {
                srtIdx = currentSrtUploadIndex;
            }

            var dx = currentUploaderId ? dx5.get(currentUploaderId) : null;
            if(!dx) {
                continueSrtUpload(srtIdx + 1);
                return;
            }

            ajaxCall("/common/uploadFileCheck.do", {
                uploadFiles: dx.getUploadFiles(),
                uploadPath: dx.getUploadPath()
            }, function(res) {
                if(res.result > 0) {
                    srtUploadResults[currentUploaderId] = {
                        uploadFiles: dx.getUploadFiles(),
                        uploadPath: dx.getUploadPath(),
                        delFileIdStr: dx.getDelFileIdStr ? dx.getDelFileIdStr() : ""
                    };
                    continueSrtUpload(srtIdx + 1);
                } else {
                    $("#saveBtn").prop("disabled", false);
                    UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); /* 업로드를 실패하였습니다. */
                }
            }, function() {
                $("#saveBtn").prop("disabled", false);
                UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); /* 업로드를 실패하였습니다. */
            });
        }
        // 동영상 콘텐츠와 하위 콘텐츠 저장 요청을 전송한다.
        function doSaveLctrContsVideo() {
            var params = createSaveParams();
            ajaxCall("/contents/admConts/admLctrContsSave.do", params, function(res) {
                $("#saveBtn").prop("disabled", false);
                if(res.result > 0) {
                    showParentMessage(res.message || '<spring:message code="success.common.insert"/>', "success", function() { /* 정상적으로 등록되었습니다. */
                        if(window.parent && window.parent !== window && typeof window.parent.afterLctrContsSave === "function") {
                            window.parent.afterLctrContsSave();
                        } else {
                            closeLctrContsVideoPop();
                        }
                    });
                } else {
                    UiComm.showMessage(res.message || '<spring:message code="fail.common.insert"/>', "error"); /* 생성이 실패하였습니다. */
                }
            }, function() {
                $("#saveBtn").prop("disabled", false);
                UiComm.showMessage('<spring:message code="fail.common.insert"/>', "error"); /* 생성이 실패하였습니다. */
            });
        }

        // 화면 입력값과 업로드 결과를 저장 파라미터로 변환한다.
        function createSaveParams() {
            var sdResult = videoUploadResults.sdVideoUploader || {};
            var hdResult = videoUploadResults.hdVideoUploader || {};
            var params = {
                orgId: ORG_ID,
                sbjctId: SBJCT_ID,
                lctrWknoSchdlId: LCTR_WKNO_SCHDL_ID,
                lctrId: LCTR_ID,
                lctrContsId: LCTR_CONTS_ID,
                lctrContsTycd: "VIDEO",
                // TODO: 동영상 업로드 방식 확정 후 첨부 파일명으로 CONTSNM을 설정한다.
                contsnm: "-",
                atndcRfltyn: $("#atndcRfltyn").is(":checked") ? "Y" : "N",
                oyn: "Y",
                vdoMnts: $("#vdoMnts").val(),
                contsSeqno: $("#contsSeqno").val(),
                lrnTocTtl: $.trim($("#contsnm").val()),
                lrnTocCts: $("#lrnTocCts").val(),
                sdVideoContsId: $("#sdVideoContsId").val(),
                sdVideoUploadFiles: sdResult.uploadFiles || "",
                sdVideoUploadPath: sdResult.uploadPath || UPLOAD_PATH,
                sdVideoDelFileIdStr: sdResult.delFileIdStr || "",
                hdVideoContsId: $("#hdVideoContsId").val(),
                hdVideoUploadFiles: hdResult.uploadFiles || "",
                hdVideoUploadPath: hdResult.uploadPath || UPLOAD_PATH,
                hdVideoDelFileIdStr: hdResult.delFileIdStr || "",
                uploadPath: UPLOAD_PATH
            };

            $("#sddnQstnBody tr").each(function(index) {
                params["childContsList[" + index + "].lctrContsTycd"] = "SDDN_QSTN";
                params["childContsList[" + index + "].sddnQstnId"] = $(this).find(".sddn-qstn-id").val();
                params["childContsList[" + index + "].sddnQstnPlySec"] = $(this).find(".sddn-qstn-ply-sec").val();
                params["childContsList[" + index + "].contsnm"] = $(this).find(".sddn-qstn-nm").val();
            });
            $("#srtContsBody tr.srt-conts-row").each(function(index) {
                var uploaderId = $(this).attr("data-uploader-id");
                var srtResult = srtUploadResults[uploaderId] || {};
                params["srtContsList[" + index + "].lctrContsId"] = $(this).find(".srt-conts-id").val();
                params["srtContsList[" + index + "].langCd"] = $(this).find(".srt-lang-cd").val();
                params["srtContsList[" + index + "].srtUploadFiles"] = srtResult.uploadFiles || "";
                params["srtContsList[" + index + "].srtUploadPath"] = srtResult.uploadPath || UPLOAD_PATH;
                params["srtContsList[" + index + "].srtDelFileIdStr"] = srtResult.delFileIdStr || "";
            });
            return params;
        }

        // 삭제 전 학습 이력 여부에 따라 확인 문구를 분기한다.
        function deleteLctrContsVideo() {
            if(!isEditMode() || !LCTR_CONTS_ID) {
                return false;
            }

            ajaxCall("/contents/admConts/admLctrContsLearningExists.do", {
                orgId: ORG_ID,
                lctrContsId: LCTR_CONTS_ID
            }, function(res) {
                if(res.result < 0) {
                    UiComm.showMessage(res.message || '<spring:message code="fail.common.select"/>', "error"); /* 조회에 실패하였습니다. */
                    return;
                }

                var confirmMessage = res.data
                        ? '<spring:message code="contents.msg.confirm.delete.learning.exists"/>' /* 학습 중인 학습자가 있습니다. 삭제할 경우 모든 학습자의 학습 정보가 삭제됩니다. 그래도 삭제 하시겠습니까? */
                        : '<spring:message code="common.delete.msg"/>'; /* 삭제하시겠습니까? */
                UiComm.showMessage(confirmMessage, "confirm").then(function(ok) {
                    if(ok) {
                        doDeleteLctrContsVideo();
                    }
                });
            }, function() {
                UiComm.showMessage('<spring:message code="fail.common.select"/>', "error"); /* 조회에 실패하였습니다. */
            });
            return false;
        }

        // 사용자가 확인한 콘텐츠를 삭제 상태로 변경한다.
        function doDeleteLctrContsVideo() {
            $("#saveBtn, #deleteBtn").prop("disabled", true);
            ajaxCall("/contents/admConts/admLctrContsDelete.do", {
                orgId: ORG_ID,
                lctrContsId: LCTR_CONTS_ID
            }, function(res) {
                $("#saveBtn, #deleteBtn").prop("disabled", false);
                if(res.result > 0) {
                    showParentMessage(res.message || '<spring:message code="success.common.delete"/>', "success", function() { /* 정상적으로 삭제되었습니다. */
                        if(window.parent && window.parent !== window && typeof window.parent.afterLctrContsSave === "function") {
                            window.parent.afterLctrContsSave();
                        } else {
                            closeLctrContsVideoPop();
                        }
                    });
                } else {
                    UiComm.showMessage(res.message || '<spring:message code="fail.common.delete"/>', "error"); /* 삭제가 실패하였습니다. */
                }
            }, function() {
                $("#saveBtn, #deleteBtn").prop("disabled", false);
                UiComm.showMessage('<spring:message code="fail.common.delete"/>', "error"); /* 삭제가 실패하였습니다. */
            });
        }

        // 부모 화면을 우선으로 메시지를 표시한다.
        function showParentMessage(message, type, callback) {
            var comm = window.parent && window.parent.UiComm ? window.parent.UiComm : UiComm;
            var result = comm.showMessage(message, type);
            if(result && typeof result.then === "function") {
                result.then(callback);
            } else if($.isFunction(callback)) {
                callback();
            }
        }

        // 부모 UiDialog가 있으면 닫고, 단독 창이면 window.close를 시도한다.
        function closeLctrContsVideoPop() {
            if(window.parent && window.parent !== window && typeof window.parent.closeDialog === "function") {
                window.parent.closeDialog();
                return;
            }
            window.close();
        }
    </script>
</head>
<body class="modal-page">
    <c:set var="vdoTotalSeconds" value="${empty lctrContsVO.vdoMnts ? 0 : lctrContsVO.vdoMnts}" />
    <c:set var="lctrWknoSymdText" value="${lctrContsVO.lctrWknoSymd}" />
    <c:set var="lctrWknoEymdText" value="${lctrContsVO.lctrWknoEymd}" />
    <c:if test="${fn:length(lctrWknoSymdText) eq 8}">
        <c:set var="lctrWknoSymdText" value="${fn:substring(lctrWknoSymdText, 0, 4)}.${fn:substring(lctrWknoSymdText, 4, 6)}.${fn:substring(lctrWknoSymdText, 6, 8)}" />
    </c:if>
    <c:if test="${fn:length(lctrWknoEymdText) eq 8}">
        <c:set var="lctrWknoEymdText" value="${fn:substring(lctrWknoEymdText, 0, 4)}.${fn:substring(lctrWknoEymdText, 4, 6)}.${fn:substring(lctrWknoEymdText, 6, 8)}" />
    </c:if>
    <c:choose>
        <c:when test="${not empty lctrContsVO.modDttm}">
            <c:set var="lastModifiedDttmText" value="${lctrContsVO.modDttm}" />
            <c:set var="lastModifiedUserText" value="${empty lctrContsVO.mdfrNm ? lctrContsVO.mdfrId : lctrContsVO.mdfrNm}" />
        </c:when>
        <c:otherwise>
            <c:set var="lastModifiedDttmText" value="${lctrContsVO.regDttm}" />
            <c:set var="lastModifiedUserText" value="${empty lctrContsVO.rgtrNm ? lctrContsVO.rgtrId : lctrContsVO.rgtrNm}" />
        </c:otherwise>
    </c:choose>
    <c:if test="${fn:length(lastModifiedDttmText) eq 14}">
        <c:set var="lastModifiedDttmText" value="${fn:substring(lastModifiedDttmText, 0, 4)}.${fn:substring(lastModifiedDttmText, 4, 6)}.${fn:substring(lastModifiedDttmText, 6, 8)} ${fn:substring(lastModifiedDttmText, 8, 10)}:${fn:substring(lastModifiedDttmText, 10, 12)}:${fn:substring(lastModifiedDttmText, 12, 14)}" />
    </c:if>
    <div class="wrap">
        <input type="hidden" id="sdVideoContsId" value="<c:out value='${lctrContsVO.sdVideoContsId}' />">
        <input type="hidden" id="hdVideoContsId" value="<c:out value='${lctrContsVO.hdVideoContsId}' />">
        <input type="hidden" id="vdoMnts" value="<c:out value='${vdoTotalSeconds}' />">
        <div id="langCdData" class="blind">
            <c:forEach var="item" items="${langCdList}">
                <div class="lang-cd-data">
                    <input type="hidden" class="data-cd" value="<c:out value='${item.cd}' />">
                    <input type="hidden" class="data-cdnm" value="<c:out value='${item.cdnm}' />">
                </div>
            </c:forEach>
        </div>
        <div id="sddnQstnData" class="blind">
            <c:forEach var="item" items="${lctrContsVO.childContsList}">
                <div class="sddn-qstn-data">
                    <input type="hidden" class="data-sddn-qstn-id" value="<c:out value='${item.sddnQstnId}' />">
                    <input type="hidden" class="data-sddn-qstn-ply-sec" value="<c:out value='${item.sddnQstnPlySec}' />">
                    <input type="hidden" class="data-contsnm" value="<c:out value='${item.contsnm}' />">
                </div>
            </c:forEach>
        </div>
        <div id="srtContsData" class="blind">
            <c:forEach var="item" items="${lctrContsVO.srtContsList}">
                <div class="srt-conts-data">
                    <input type="hidden" class="data-lctr-conts-id" value="<c:out value='${item.lctrContsId}' />">
                    <input type="hidden" class="data-lang-cd" value="<c:out value='${item.langCd}' />">
                    <c:forEach var="file" items="${item.srtFileList}">
                        <div class="srt-file-data">
                            <input type="hidden" class="data-file-id" value="<c:out value='${file.atflId}' />">
                            <input type="hidden" class="data-file-nm" value="<c:out value='${file.filenm}' />">
                            <input type="hidden" class="data-file-size" value="<c:out value='${file.fileSize}' />">
                        </div>
                    </c:forEach>
                </div>
            </c:forEach>
        </div>

        <div class="board_top">
            <h3 class="board-title">
                <c:choose>
                    <c:when test="${not empty lctrContsVO.lctrWkno}">
                        <c:out value="${lctrContsVO.lctrWkno}" /><spring:message code="contents.label.week.suffix"/><%-- 주차 --%>
                    </c:when>
                    <c:otherwise>
                        <spring:message code="contents.label.week"/><%-- 주차 --%>
                    </c:otherwise>
                </c:choose>
            </h3>
            <div class="right-area">
                <span class="total_txt"><spring:message code="contents.label.learning.period"/><%-- 학습기간 --%> :<b> <c:out value="${lctrWknoSymdText}" /><c:if test="${not empty lctrWknoSymdText or not empty lctrWknoEymdText}"> ~ </c:if><c:out value="${lctrWknoEymdText}" /></b></span>
            </div>
        </div>

        <div class="table-wrap">
            <table class="table-type5">
                <colgroup>
                    <col style="width: 18%;">
                    <col>
                </colgroup>
                <tbody>
                    <tr>
                        <th class="req"><label for="contsnm"><spring:message code="common.label.title"/><%-- 제목 --%></label></th>
                        <td>
                            <input class="form-control width-100per" type="text" id="contsnm" value="<c:out value='${lctrContsVO.lrnTocTtl}' />" maxlength="300" required="true">
                        </td>
                    </tr>
                    <tr>
                        <th><label for="atndcRfltyn"><spring:message code="contents.label.attendance.target"/><%-- 출결대상 --%></label></th>
                        <td>
                            <span class="custom-input">
                                <input type="checkbox" id="atndcRfltyn" value="Y" <c:if test="${empty lctrContsVO.atndcRfltyn or lctrContsVO.atndcRfltyn eq 'Y'}">checked="checked"</c:if>>
                                <label for="atndcRfltyn"><spring:message code="contents.label.attendance.check.target"/><%-- 출결체크 대상에 포함 --%></label>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="contents.label.learning.toc"/><%-- 학습목차 --%></th>
                        <td>
                            <div class="item_btns">
                                <a href="#0" class="active" onclick="return false;">
                                    <i class="icon-svg-play-circle" aria-hidden="true"></i>
                                    <span><spring:message code="contents.label.video"/><%-- 동영상 --%></span>
                                </a>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="contents.label.low.quality.upload"/><%-- 저화질 업로드 --%></th>
                        <td>
                            <uiex:dextuploader
                                    id="sdVideoUploader"
                                    path="${lctrContsVO.uploadPath}"
                                    limitCount="1"
                                    limitSize="500"
                                    oneLimitSize="500"
                                    listSize="1"
                                    fileList="${lctrContsVO.sdVideoFileList}"
                                    finishFunc="finishSdVideoUpload"
                                    allowedTypes="*"
                                    uiMode="simple"
                            />
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="contents.label.high.quality.upload"/><%-- 고화질 업로드 --%></th>
                        <td>
                            <uiex:dextuploader
                                    id="hdVideoUploader"
                                    path="${lctrContsVO.uploadPath}"
                                    limitCount="1"
                                    limitSize="500"
                                    oneLimitSize="500"
                                    listSize="1"
                                    fileList="${lctrContsVO.hdVideoFileList}"
                                    finishFunc="finishHdVideoUpload"
                                    allowedTypes="*"
                                    uiMode="simple"
                            />
                        </td>
                    </tr>
                    <tr>
                        <th><label for="lrnTocCts"><spring:message code="contents.label.learning.content"/><%-- 학습내용 --%></label></th>
                        <td>
                            <div class="editor-box">
                                <textarea id="lrnTocCts" name="lrnTocCts"><c:out value="${lctrContsVO.lrnTocCts}" /></textarea>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="contents.label.play.time"/><%-- 재생시간 --%></th>
                        <td>
                            <div class="input_btn">
                                <input class="form-control md play-time-input" type="text" id="vdoPlayMinutes" value="0" maxlength="6" inputmask="numeric" maxVal="166666"><label for="vdoPlayMinutes"><spring:message code="contents.label.minute.unit"/><%-- 분 --%></label>
                            </div>
                            <div class="input_btn mr15">
                                <input class="form-control sm play-time-input" type="text" id="vdoPlaySeconds" value="0" maxlength="2" inputmask="numeric" maxVal="59"><label for="vdoPlaySeconds"><spring:message code="contents.label.second.unit"/><%-- 초 --%></label>
                            </div>
                            <div class="input_btn">
                                <span class="mr10">(<spring:message code="contents.label.total.seconds"/><%-- 총 --%> :</span>
                                <input class="form-control lg" type="text" id="vdoTotalSecondsText" value="0" readonly="readonly" style="width:7em"><label for="vdoTotalSecondsText"><spring:message code="contents.label.second.unit"/><%-- 초 --%></label>
                                <span class="ml10">)</span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th><label for="contsSeqno"><spring:message code="contents.label.sort.order"/><%-- 정렬순서 --%></label></th>
                        <td>
                            <input class="form-control sm" type="text" id="contsSeqno" value="<c:out value='${lctrContsVO.contsSeqno}' />" maxlength="2" inputmask="numeric" maxVal="99">
                        </td>
                    </tr>
                    <c:if test="${mode eq 'E'}">
                        <tr>
                            <th><spring:message code="contents.label.last.modified"/><%-- 최종수정 --%></th>
                            <td>
                                <c:out value="${lastModifiedDttmText}" />
                                <c:if test="${not empty lastModifiedUserText}"> (<c:out value="${lastModifiedUserText}" />)</c:if>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <div class="board_top mt20">
            <h4 class="sub-title"><spring:message code="contents.label.sudden.quiz"/><%-- 돌발퀴즈 --%></h4>
            <div class="right-area">
                <button type="button" class="btn type1" onclick="addSddnQstnRow();"><spring:message code="common.button.add"/><%-- 추가 --%></button>
            </div>
        </div>
        <div class="table-wrap">
            <table class="table-type3">
                <colgroup>
                    <col style="width: 90px;">
                    <col style="width: 140px;">
                    <col style="width: 140px;">
                    <col>
                    <col style="width: 86px;">
                </colgroup>
                <tbody id="sddnQstnBody"></tbody>
            </table>
        </div>
        <div class="board_top mt20">
            <h4 class="sub-title"><spring:message code="contents.label.multilingual.subtitle"/><%-- 다국어 자막(스크립트) --%></h4>
            <div class="right-area">
                <button type="button" class="btn type1" onclick="addSrtRow();"><spring:message code="common.button.add"/><%-- 추가 --%></button>
            </div>
        </div>
        <div class="table-wrap">
            <table class="table-type3">
                <colgroup>
                    <col style="width: 90px;">
                    <col style="width: 140px;">
                    <col style="width: 140px;">
                    <col>
                    <col style="width: 86px;">
                </colgroup>
                <tbody id="srtContsBody"></tbody>
            </table>
        </div>
        <div class="btns">
            <button type="button" id="saveBtn" class="btn type1" onclick="saveLctrContsVideo();"><spring:message code="common.button.save"/><%-- 저장 --%></button>
            <c:if test="${mode eq 'E'}">
                <button type="button" id="deleteBtn" class="btn type2" onclick="deleteLctrContsVideo();"><spring:message code="common.button.delete"/><%-- 삭제 --%></button>
            </c:if>
            <button type="button" class="btn type2" onclick="closeLctrContsVideoPop();"><spring:message code="common.button.close"/><%-- 닫기 --%></button>
        </div>
    </div>
</body>
</html>
