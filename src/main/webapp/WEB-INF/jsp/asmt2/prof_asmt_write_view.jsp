<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/asmt2/common/asmt_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table,editor,fileuploader"/>
    </jsp:include>

    <script type="text/javascript">
        const SBJCT_ID = '<c:out value="${asmtVO.sbjctId}"/>';
        const ASMT_ID = '<c:out value="${asmtVO.asmtId}"/>';
        const MRK_PROC_EDTTM = '<c:out value="${sbjctInfo.mrkProcEdttm}"/>';
        let EPARAM = '<c:out value="${encParams}" />';

        const SUB_ASMT_EDITORS = {};           // 팀별 부과제 에디터 목록
        let subAsmtUploaderIds = [];           // 팀별 업로더 ID 목록 (순서 보장)
        let subAsmtUploadResults = {};         // { uploaderId : { uploadFiles, uploadPath, delFileIdStr, copyFiles } }

        let isEditMode = false;   // 수정 여부
        let isCopyMode = false;   // 과제복사 여부
        let isIndvListLoaded = false;       // 개별과제 대상자 목록 조회 여부
        let editor = null;
        let dialog;

        $(document).ready(function () {

            /**
             * 수정 여부 설정
             */
            isEditMode = "${mode}" === "E";
            isCopyMode = false;

            initView(); // 초기 화면 제어
            bindEvents(); // 이벤트 바인딩
            bindDvclasEvents(); // 분반 이벤트 바인딩
            applyCurrentView(); // 초기상태반영

            // 수정 모드면 상세 조회
            if (isEditMode && ASMT_ID) {
                getAsmt(ASMT_ID);
            }
        });


        /**
         * =========================================================
         * 초기 화면 처리
         * =========================================================
         */
        function initView() {
            $("#viewExtdSbmsnPrm").hide();
            $("#viewMrkInqSdttm").hide();
            $("#viewPrtc").hide();
            $("#viewSbasmtTycdFile").hide();
            $("#viewTeamAsmt").hide();
            $("#viewIndivAsmt").hide();
            $("#viewSbasmtOstd").hide();
        }

        /**
         * 제출 파일 형식 상세 선택 초기화
         */
        function resetSbmsnFileTypeOptions() {
            $("input[name='sbmsnFileMimeTycdOption'][value='all']").prop("checked", true);
            $("input[name='preFile']").prop("checked", false);
            $("input[name='docFile']").prop("checked", false);
            $("input[name='prtcFileType']").prop("checked", false);
        }


        /**
         * =========================================================
         * 이벤트 바인딩
         * =========================================================
         */
        function bindEvents() {

            /**
             * 버튼 이벤트
             */
            $("#btnSave").on("click", saveConfirm);
            $("#btnCopy").on("click", asmtCopyListPop);
            $("#btnGoList").on("click", moveAsmtList);

            /**
             * 화면 반영이 필요한 항목 묶어서 처리
             */
            $(
                "input[name='extdSbmsnPrmyn']"
                + ", input[name='mrkRfltyn']"
                + ", input[name='mrkOyn']"
                + ", input[name='sbasmtOstdOyn']"
            ).on("change", applyCurrentView);

            /**
             * 루브릭 선택 후 등록 팝업을 바로 표시
             */
            $("input[name='evlScrTycd']").on("change", function () {
                applyCurrentView();
                if (this.checked && this.value === "RUBRIC_SCR" && !$("#rubricId").val()) {
                    rubricPop("new");
                }
            });
            /**
             * 팀과제/개별과제 상호배제
             */
            $("input[name='teamAsmtStngyn']").on("change", function () {
                if ($(this).val() === "Y") {
                    $("input[name='indvAsmtyn'][value='N']").prop("checked", true);
                } else {
                    $("input[name='tmbrIndivSbmsnPrmyn'][value='N']").prop("checked", true);
                }
                applyCurrentView();
            });

            $("input[name='indvAsmtyn']").on("change", function () {
                if ($(this).val() === "Y") {
                    $("input[name='teamAsmtStngyn'][value='N']").prop("checked", true);
                    $("input[name='tmbrIndivSbmsnPrmyn'][value='N']").prop("checked", true);
                }
                applyCurrentView();
            });

            /**
             * 제출 종료일, 연장 종료일 변경 시 과제읽기 허용일 동기화
             */
            $("#asmtSbmsnDateEd, #asmtSbmsnTimeEd, #extdSbmsnDateEd, #extdSbmsnTimeEd").on("change", syncSbasmtOpenDate);

            /**
             * 실기과제 여부 변경 시 제출형식 관련 선택값 초기화
             */
            $("input[name='asmtPrctcyn']").on("change", function () {
                $("input[name='sbasmtTycd'][value='FILE']").prop("checked", true);
                resetSbmsnFileTypeOptions();
                applyCurrentView();
            });

            /**
             * 제출형식 라디오 변경 시 세부 체크 초기화
             */
            $("input[name='sbasmtTycd']").on("change", function () {
                resetSbmsnFileTypeOptions();
                applyCurrentView();
            });

            $("input[name='sbmsnFileMimeTycdOption']").on("change", function () {
                $("input[name='preFile']").prop("checked", false);
                $("input[name='docFile']").prop("checked", false);
                applyCurrentView();
            });

            /**
             * 미리보기 파일 체크 시 문서 파일 체크 해제
             */
            $("input[name='preFile']").on("change", function () {
                $("#preFile").prop("checked", true);
                $("input[name='docFile']").prop("checked", false);
            });

            /**
             * 문서 파일 체크 시 미리보기 파일 체크 해제
             */
            $("input[name='docFile']").on("change", function () {
                $("#docFile").prop("checked", true);
                $("input[name='preFile']").prop("checked", false);
            });

            /**
             * 개별과제 - 수강생 전체 선택
             */
            $("#tg0").on("change", function () {
                const checked = this.checked;

                $("#indvAsmtList input[type='checkbox']").each(function () {
                    if ($(this).closest("tr").css("display") !== "none") {
                        this.checked = checked;
                    }
                });
            });

            /**
             * 개별과제 - 할당목록 전체 선택
             */
            $("#stg0").on("change", function () {
                const checked = this.checked;

                $("#sindvAsmtList input[type='checkbox']").each(function () {
                    if ($(this).closest("tr").css("display") !== "none") {
                        this.checked = checked;
                    }
                });
            });

            /**
             * 개별과제 검색 엔터
             */
            $("#tgSearch").on("keydown", function (e) {
                if (e.key === "Enter") {
                    e.preventDefault();
                    indiSearch("T");
                }
            });

            $("#stgSearch").on("keydown", function (e) {
                if (e.key === "Enter") {
                    e.preventDefault();
                    indiSearch("S");
                }
            });
        }


        /**
         * =========================================================
         * 현재 상태에 맞춰 화면 제어
         * =========================================================
         */
        function applyCurrentView() {

            /**
             * 현재 선택 값 조회
             */
            const extdSbmsnPrmyn = $("input[name='extdSbmsnPrmyn']:checked").val();
            const evlScrTycd = $("input[name='evlScrTycd']:checked").val();
            const asmtPrctcyn = $("input[name='asmtPrctcyn']:checked").val();
            const sbasmtTycd = $("input[name='sbasmtTycd']:checked").val();
            const teamAsmtStngyn = $("input[name='teamAsmtStngyn']:checked").val();
            const indvAsmtyn = $("input[name='indvAsmtyn']:checked").val();
            const mrkRfltyn = $("input[name='mrkRfltyn']:checked").val();
            const mrkOyn = $("input[name='mrkOyn']:checked").val();
            const sbasmtOstdOyn = $("input[name='sbasmtOstdOyn']:checked").val();

            /**
             * 연장제출
             */
            $("#viewExtdSbmsnPrm").toggle(extdSbmsnPrmyn === "Y");

            /**
             * 성적공개 시작일시
             */
            $("#viewMrkInqSdttm").toggle(mrkOyn === "Y");

            /**
             * 평가방법 - 루브릭
             */
            refreshRubricTitle();

            /**
             * 실기과제
             * - 실기과제 선택 시 제출형식 숨김
             */
            if (asmtPrctcyn === "Y") {
                $("#viewPrtc").show();
                $("#viewSbasmtTycd").hide();

                /**
                 * 실기과제는 제출형식 FILE 고정
                 */
                $("input[name='sbasmtTycd'][value='FILE']").prop("checked", true);
            } else {
                $("#viewPrtc").hide();
                $("#viewSbasmtTycd").show();
            }

            /**
             * 제출형식 - 파일 상세
             */
            $("#viewSbasmtTycdFile").toggle(sbasmtTycd === "FILE" && asmtPrctcyn !== "Y");
            $("#preFileList, #docFileList").hide();

            if (sbasmtTycd === "FILE" && asmtPrctcyn !== "Y") {
                const sbmsnFileMimeTycdOption = $("input[name='sbmsnFileMimeTycdOption']:checked").val();

                if (sbmsnFileMimeTycdOption === "pre") {
                    $("#preFileList").show();
                } else if (sbmsnFileMimeTycdOption === "doc") {
                    $("#docFileList").show();
                }
            }

            /**
             * 팀과제 / 개별과제 상호배제
             */
            if (teamAsmtStngyn === "Y") {
                $("#viewTeamAsmt").show();
                $("#viewIndivAsmt").hide();
                toggleTeamGroupView();
            } else if (indvAsmtyn === "Y") {
                $("#viewTeamAsmt").hide();
                $("#viewIndivAsmt").show();


                /**
                 * 개별과제는 성적반영 불가
                 */
                if (mrkRfltyn === "Y") {
                    UiComm.showMessage("<spring:message code='asmt.alert.ind.score.aply' /><%--개별과제는 성적반영 불가능 합니다.--%>", "error");/* 개별과제는 성적반영 불가능 합니다. */
                    $("input[name='mrkRfltyn'][value='N']").prop("checked", true);
                }

                /**
                 * 개별과제 대상자 목록 최초 1회 조회
                 */
                if (!isIndvListLoaded) {
                    getIndivAsmtStdList();
                }
            } else {
                $("#viewTeamAsmt").hide();
                $("#viewIndivAsmt").hide();
            }

            /**
             * 과제읽기 허용
             */
            $("#viewSbasmtOstd").toggle(sbasmtOstdOyn === "Y");

            /**
             * 과제읽기 허용이 Y면 제출 종료일 기준으로 자동 세팅
             */
            if (sbasmtOstdOyn === "Y") {
                syncSbasmtOpenDate();
            }
        }

        /**
         * =========================================================
         * 과제읽기 허용일 동기화
         * - 연장제출 Y면 연장제출 종료일
         * - 아니면 제출 종료일
         * =========================================================
         */
        function syncSbasmtOpenDate() {
            if ($("input[name='sbasmtOstdOyn']:checked").val() !== "Y") {
                return;
            }

            const extdSbmsnPrmyn = $("input[name='extdSbmsnPrmyn']:checked").val();

            if (extdSbmsnPrmyn === "Y") {
                asmtDateUtil.copyDateTimeVal("extdSbmsnDateEd", "extdSbmsnTimeEd", "ostdOpenSdttmDateSt", "ostdOpenSdttmTimeSt");
            } else {
                asmtDateUtil.copyDateTimeVal("asmtSbmsnDateEd", "asmtSbmsnTimeEd", "ostdOpenSdttmDateSt", "ostdOpenSdttmTimeSt");
            }
        }

        /**
         * 분반 체크박스 이벤트
         */
        function bindDvclasEvents() {

            $("input[name='dvclasList']").on("click", function (e) {
                const value = e.target.value;

                if (value === "ALL") {
                    const checked = $("#dvclasAll").is(":checked");

                    $("input[name='dvclasList']").each(function () {
                        if (this.value !== "ALL" && this.value !== SBJCT_ID) {
                            this.checked = checked;
                        }
                    });
                } else {
                    let checkedCount = 0;
                    let totalCount = 0;

                    $("input[name='dvclasList']").each(function () {
                        if (this.value !== "ALL") {
                            totalCount++;
                            if (this.checked) {
                                checkedCount++;
                            }
                        }
                    });

                    $("#dvclasAll").prop("checked", checkedCount === totalCount);
                }

                toggleTeamGroupView();
            });

            toggleTeamGroupView();
        }

        /**
         * =========================================================
         * 팀과제 분반별 학습그룹 영역 표시
         * - 본인 분반은 항상 표시
         * - 추가 선택한 분반도 표시
         * =========================================================
         */
        function toggleTeamGroupView() {

            $("input[name='dvclasList']").each(function () {
                const value = this.value;

                if (value !== "ALL") {
                    const isBaseSbjct = value === SBJCT_ID
                    const viewKey = getViewKeyBySbjctId(value);
                    const $target = $("#teamGrpView" + viewKey);
                    const $setDiv = $("#setSubAsmtDiv" + viewKey);
                    const $teamGrpId = $("#teamGrpId" + viewKey);
                    const $teamGrpnm = $("#teamGrpnm" + viewKey);

                    if (isBaseSbjct || this.checked) {
                        $target.show();
                        $setDiv.show();
                        $teamGrpId.removeAttr("disabled");
                    } else {
                        $target.hide();
                        $setDiv.hide();

                        $teamGrpId.attr("disabled", "disabled").val("");
                        $teamGrpnm.val("");

                        $("#byteamAsmtUseyn_" + viewKey).prop("checked", false);
                        clearSubAsmtInfo(viewKey);
                    }
                }
            });
        }

        /**
         * sbjctId로 화면 key 조회
         * @param sbjctId 과목아이디
         * @returns {string} 화면 key
         */
        function getViewKeyBySbjctId(sbjctId) {
            let viewKey = "";

            $("#viewTeamAsmt [data-sbjct-id='" + sbjctId + "']").each(function () {
                viewKey = String($(this).data("view-key"));
            });

            return viewKey;
        }

        /**
         * sbjctId로 dvclasNo 조회
         * @param sbjctId 과목아이디
         * @returns {string} 분반번호
         */
        function getDvclasNoBySbjctId(sbjctId) {
            let dvclasNo = "";

            $("#viewTeamAsmt [data-sbjct-id='" + sbjctId + "']").each(function () {
                dvclasNo = $(this).data("dvclas-no");
            });

            return dvclasNo;
        }

        /**
         * 학습그룹별 과제 설정 체크 변경
         * @param obj 선택그룹
         */
        function byteamAsmtUseynChange(obj) {
            const $obj = $(obj);
            const checked = $obj.is(":checked");
            const sbjctId = ($obj.val() || "").split(":")[1];
            const viewKey = $obj.data("view-key");
            const teamGrpIdVal = $("#teamGrpId" + viewKey).val() || "";
            const teamGrpId = teamGrpIdVal.split(":")[0];

            /**
             * 학습그룹 미선택 시 체크 불가
             */
            if (!teamGrpId) {
                UiComm.showMessage("<spring:message code='asmt.alert.select.team.grp.first'/><%--먼저 학습그룹을 선택해 주세요.--%>", "error");
                $obj.prop("checked", false);
                return;
            }

            if (checked) {
                $("#subAsmtInfoDiv" + viewKey).show();
                loadAsmtTeamList(teamGrpId, viewKey, sbjctId);
            } else {
                clearSubAsmtInfo(viewKey);
            }
        }

        /**
         * 팀별 부과제 입력 영역 초기화
         * @param viewKey 화면 key
         */
        function clearSubAsmtInfo(viewKey) {
            const $subAsmtInfoDiv = $("#subAsmtInfoDiv" + viewKey);
            const removedUploaderIds = [];

            $subAsmtInfoDiv.find(".subAsmtTr").each(function () {
                const uploaderId = $(this).data("uploader-id");
                const editorId = $(this).data("editor-id");

                if (uploaderId) {
                    removedUploaderIds.push(uploaderId);
                    delete subAsmtUploadResults[uploaderId];
                }

                if (editorId) {
                    delete SUB_ASMT_EDITORS[editorId];
                }
            });

            subAsmtUploaderIds = subAsmtUploaderIds.filter(function (uploaderId) {
                return removedUploaderIds.indexOf(uploaderId) === -1;
            });

            $subAsmtInfoDiv.hide().empty();
        }

        /**
         * =========================================================
         *
         * =========================================================
         */
        /**
         * 학습그룹 팀 목록 조회 후 하위과제 입력영역 렌더링
         * @param teamGrpId 학습그룹아이디
         * @param viewKey 화면 key
         * @param sbjctId 과목아이디
         * @param overrideUpAsmtId - 등록: 없음, 수정: 과제ID, 복사: 이전과제ID
         */
        function loadAsmtTeamList(teamGrpId, viewKey, sbjctId, overrideUpAsmtId) {

            const url = "/asmt2/profAsmtTeamGrpTeamListAjax.do";
            const dvclasNo = getDvclasNoBySbjctId(sbjctId);
            const data = {
                teamGrpId: teamGrpId,
                upAsmtId: overrideUpAsmtId !== undefined ? overrideUpAsmtId : ($("#asmtId").val() || "")
            };

            ajaxCall(url, data, function (data) {
                if (data.encParams != null && data.encParams != '') {
                    EPARAM = data.encParams;
                }
                if (data.result > 0) {
                    const returnList = data.returnList || [];
                    const html = buildAsmtTeamListHtml(returnList, dvclasNo, sbjctId);

                    clearSubAsmtInfo(viewKey);
                    const $subAsmtInfoDiv = $("#subAsmtInfoDiv" + viewKey);
                    $subAsmtInfoDiv.show().html(html);

                    /*
                     * 팀별 에디터 생성
                     */
                    if (returnList.length > 0) {
                        returnList.forEach(function (item, idx) {

                            const editorId = item.teamId + "_subAsmtCts_" + idx;
                            SUB_ASMT_EDITORS[editorId] = UiEditor({
                                targetId: editorId,
                                uploadPath: "${asmtVO.uploadPath}",
                                height: "250px"
                            });
                            SUB_ASMT_EDITORS[editorId].openHTML(item.asmtCts || "");

                            createSubAsmtFileUploader(item.teamId, idx, "${asmtVO.uploadPath}", item.fileList || "");
                        });
                    }
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }, function () {
                UiComm.showMessage("<spring:message code='asmt.alert.team.list.error'/><%--팀 목록 조회 중 오류가 발생했습니다.--%>", "error");
            }, true);
        }


        /**
         * =========================================================
         * 팀별 부과제 파일 업로더 생성
         * =========================================================
         */
        function createSubAsmtFileUploader(teamId, idx, uploadPath, fileList) {

            const uploaderId = "subAsmtFileUploader_" + teamId + "_" + idx;
            const wrapId = "subAsmtUploaderWrap_" + teamId + "_" + idx;
            const normalizedFileList = normalizeSubAsmtUploaderFileList(fileList);

            UiFileUploader({
                id: uploaderId,
                targetId: wrapId,
                path: uploadPath,
                limitCount: 5,
                limitSize: 1024,
                oneLimitSize: 1024,
                listSize: 3,
                fileList: normalizedFileList,
                finishFunc: onSubAsmtUploadComplete,
                allowedTypes: "*"
            });

            if (subAsmtUploaderIds.indexOf(uploaderId) === -1) {
                subAsmtUploaderIds.push(uploaderId);
            }
        }

        /**
         * JS에서 UiFileUploader 호출할 때 각 파일을 DEXT업로더용 형태로 바꿈
         * (변수명 다른 것을 맞추는 용도)
         * @param fileList
         * @returns {*|string}
         */
        function normalizeSubAsmtUploaderFileList(fileList) {
            if (!Array.isArray(fileList)) {
                return "";
            }

            return fileList
            .filter(function (file) {
                return file && (file.fileNm || file.filenm);
            })
            .map(function (file) {
                return {
                    fileNm: file.fileNm || file.filenm,
                    fileId: file.fileId || file.atflId || "",
                    fileSize: file.fileSize || 0
                };
            });
        }

        /**
         * =========================================================
         * 팀별 하위과제 입력 HTML 생성
         * =========================================================
         */
        function buildAsmtTeamListHtml(list, dvclasNo, sbjctId) {

            if (!list || list.length === 0) {
                return '<p class="p_gray"><spring:message code='asmt.label.team.info.empty'/><%--팀 정보가 없습니다.--%></p>';
            }

            let html = "";
            html += "<div class='table-wrap mb30'>";
            html += "    <table class='table-type5 in_table'>";
            html += "        <colgroup>";
            html += "            <col class='width-5per' />";
            html += "            <col class='width-15per' />";
            html += "            <col />";
            html += "        </colgroup>";
            html += "        <tbody>";

            list.forEach(function (item, idx) {

                const teamId = UiComm.escapeHtml(item.teamId || "");
                const teamNm = UiComm.escapeHtml(item.teamnm || "");
                const asmtId = UiComm.escapeHtml(item.asmtId || "");
                const asmtTtl = UiComm.escapeHtml(item.asmtTtl || "");
                const asmtCts = UiComm.escapeHtml(item.asmtCts || "");
                const leadernm = UiComm.escapeHtml(item.leadernm || "-");
                const teamMbrCntRaw = item.teamMbrCnt || 1;
                const teamMbrCnt = Math.max(0, teamMbrCntRaw - 1);
                const editorId = teamId + "_subAsmtCts_" + idx;
                const hiddenId = teamId + "_subAsmtCtsHidden_" + idx;
                const uploaderId = "subAsmtFileUploader_" + teamId + "_" + idx;

                html += "            <tr class='subAsmtTr'";
                html += "                data-team-id='" + teamId + "'";
                html += "                data-team-nm='" + teamNm + "'";
                html += "                data-dvclas-no='" + UiComm.escapeHtml(String(dvclasNo || "")) + "'";
                html += "                data-sbjct-id='" + UiComm.escapeHtml(sbjctId || "") + "'";
                html += "                data-editor-id='" + editorId + "'";
                html += "                data-hidden-id='" + hiddenId + "'";
                html += "                data-uploader-id='" + uploaderId + "'";
                html += "                data-asmt-id='" + asmtId + "'>";
                html += "                <th rowspan='4' class='group-header'>";
                html += "                    <label>" + teamNm + "</label>";
                html += "                </th>";
                html += "                <th><label><spring:message code='asmt.label.team.grp.members'/><%--학습그룹 구성원--%></label></th>";
                html += "                <td>";
                html += "                    " + leadernm + " <spring:message code='asmt.label.other'/><%--외--%> " + teamMbrCnt + "<spring:message code='asmt.label.person'/><%--명--%>";

                /**
                 * 저장용 hidden
                 */
                html += "            <input type='hidden' name='subAsmtSbjctIds' value='" + UiComm.escapeHtml(sbjctId || "") + "' />";
                html += "            <input type='hidden' name='subAsmtTeamIds' value='" + teamId + "' />";
                html += "            <input type='hidden' name='subAsmtIds' value='" + asmtId + "' />";
                html += "            <input type='hidden' name='subAsmtCtsArr' id='" + hiddenId + "' value='' />";
                html += "                </td>";
                html += "            </tr>";

                html += "            <tr>";
                html += "                <th><label for='" + teamId + "_subAsmtTtl_" + idx + "' class='req'><spring:message code='asmt.label.sub.topic'/><%--부주제--%></label></th>";
                html += "                <td>";
                html += "                    <div class='form-row'>";
                html += "                        <input class='form-control width-100per'";
                html += "                               type='text'";
                html += "                               id='" + teamId + "_subAsmtTtl_" + idx + "'";
                html += "                               name='subAsmtTtls'";
                html += "                               value='" + asmtTtl + "'";
                html += "                               placeholder='<spring:message code='asmt.label.input.topic'/><%--주제 입력--%>'>";
                html += "                    </div>";
                html += "                </td>";
                html += "            </tr>";

                html += "            <tr>";
                html += "                <th><label for='" + editorId + "' class='req'><spring:message code='asmt.label.content'/><%--내용--%></label></th>";
                html += "                <td>";
                html += "                    <label class='width-100per'>";
                html += "                        <textarea rows='4'";
                html += "                                  class='form-control resize-none'";
                html += "                                  name='" + editorId + "'";
                html += "                                  id='" + editorId + "'>";
                html += asmtCts;
                html += "                        </textarea>";
                html += "                    </label>";
                html += "                </td>";
                html += "            </tr>";

                html += "            <tr>";
                html += "                <th><label><spring:message code='asmt.label.attach.file'/><%--첨부파일--%></label></th>";
                html += "                <td>";
                html += "                    <div id='subAsmtUploaderWrap_" + teamId + "_" + idx + "'></div>";
                html += "                </td>";
                html += "            </tr>";
            });

            html += "        </tbody>";
            html += "    </table>";
            html += "</div>";

            return html;
        }

        /**
         * =========================================================
         * 부과제 내용 hidden 동기화
         * =========================================================
         */
        function buildSubAsmtCtsArr() {

            $("#asmtWriteForm .subAsmtTr").each(function () {

                const editorId = $(this).data("editor-id");
                const hiddenId = $(this).data("hidden-id");

                let cts = "";
                const $editor = $("#" + editorId);

                if (SUB_ASMT_EDITORS[editorId] && typeof SUB_ASMT_EDITORS[editorId].getPublishingHtml === "function") {
                    cts = SUB_ASMT_EDITORS[editorId].getPublishingHtml();
                } else if ($editor.length > 0) {
                    cts = $editor.val() || "";
                }

                $("#" + hiddenId).val(cts);
            });
        }

        /**
         * =========================================================
         * 팀별 부과제 상세 hidden 제거
         * =========================================================
         */
        function resetSubAsmtDetailParams() {
            $("#asmtWriteForm input.__subAsmtDtlParam").remove();
        }

        /**
         * =========================================================
         * 팀별 부과제 상세 hidden 추가
         * =========================================================
         */
        function appendSubAsmtDetailParam(index, fieldName, value) {
            $("<input>", {
                type: "hidden",
                name: "subAsmtDtlList[" + index + "]." + fieldName,
                value: value || "",
                "class": "__subAsmtDtlParam"
            }).appendTo("#asmtWriteForm");
        }

        /**
         * =========================================================
         * 팀별 부과제 상세 파라미터 조립
         * =========================================================
         */
        function appendSubAsmtDetailParams() {
            resetSubAsmtDetailParams();
            buildSubAsmtCtsArr();

            let index = 0;

            $("#asmtWriteForm .subAsmtTr").each(function () {

                const $row = $(this);

                const sbjctId = ($row.data("sbjct-id") || "").toString();
                const dvclasNo = ($row.data("dvclas-no") || "").toString();
                const teamId = ($row.data("team-id") || "").toString();
                const teamNm = ($row.data("team-nm") || "").toString();
                const subAsmtId = ($row.data("asmt-id") || "").toString();

                const title = ($row.next("tr").find("input[name='subAsmtTtls']").val() || "").trim();
                const hiddenId = ($row.data("hidden-id") || "").toString();
                const cts = ($("#" + hiddenId).val() || "").trim();

                const uploaderId = ($row.data("uploader-id") || "").toString();
                const uploadResult = subAsmtUploadResults[uploaderId] || {};

                if (!sbjctId || !teamId) {
                    return;
                }

                appendSubAsmtDetailParam(index, "sbjctId", sbjctId);
                appendSubAsmtDetailParam(index, "dvclasNo", dvclasNo);
                appendSubAsmtDetailParam(index, "teamId", teamId);
                appendSubAsmtDetailParam(index, "teamNm", teamNm);
                appendSubAsmtDetailParam(index, "asmtId", subAsmtId);
                appendSubAsmtDetailParam(index, "asmtTtl", title);
                appendSubAsmtDetailParam(index, "asmtCts", cts);
                appendSubAsmtDetailParam(index, "uploadFiles", uploadResult.uploadFiles || "");
                appendSubAsmtDetailParam(index, "uploadPath", uploadResult.uploadPath || "${asmtVO.uploadPath}");
                appendSubAsmtDetailParam(index, "delFileIdStr", uploadResult.delFileIdStr || "");
                // appendSubAsmtDetailParam(index, "copyFiles", uploadResult.copyFiles || "");
                index++;
            });
        }


        /**
         * =========================================================
         * 개별과제 수강생 목록 조회
         * =========================================================
         */
        function getIndivAsmtStdList(asmtId) {

            const url = "/asmt2/profIndivAsmtStdListAjax.do";
            const data = {
                sbjctId: SBJCT_ID
            };

            ajaxCall(url, data, function (data) {
                if (data.encParams != null && data.encParams != '') {
                    EPARAM = data.encParams;
                }

                if (data.result > 0) {

                    let html = "";

                    data.returnList.forEach(function (o, i) {
                        html += "<tr>";
                        html += "    <td class='chkbox'>";
                        html += "        <input type='hidden' value='" + o.userId + "'/>";
                        html += "        <span class='custom-input onlychk'>";
                        html += "            <input type='checkbox' id='tg" + (i + 1) + "' tabindex='0' class='hidden'/>";
                        html += "            <label for='tg" + (i + 1) + "'></label>";
                        html += "        </span>";
                        html += "    </td>";
                        html += "    <td>" + (i + 1) + "</td>";
                        html += "    <td class='tgList'>" + UiComm.escapeHtml(o.deptnm || "") + "</td>";
                        html += "    <td class='tgList'>" + UiComm.escapeHtml(o.stdntNo || "") + "</td>";
                        html += "    <td class='tgList'>" + UiComm.escapeHtml(o.usernm || "") + "</td>";
                        html += "</tr>";
                    });

                    $("#indvAsmtList").empty().append(html);
                    isIndvListLoaded = true;

                    if (asmtId) {
                        getIndivAsmtSbmsnTrgtList(asmtId);
                    }
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }, function () {
                UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");
            }, true);
        }


        /**
         * =========================================================
         * 개별 과제 제출 대상 목록 조회
         * =========================================================
         */
        function getIndivAsmtSbmsnTrgtList(asmtId) {

            const url = "/asmt2/profIndivAsmtSbmsnTrgtListAjax.do";
            const data = {
                searchType: "LIST",
                sbjctId: SBJCT_ID,
                asmtId: asmtId
            };

            ajaxCall(url, data, function (data) {
                if (data.encParams != null && data.encParams != '') {
                    EPARAM = data.encParams;
                }

                if (data.result > 0) {

                    let html = "";
                    data.returnList.forEach(function (o, i) {
                        html += "<tr>";
                        html += "    <td class='chkbox'>";
                        html += "        <input type='hidden' value='" + o.userId + "'/>";
                        html += "        <span class='custom-input onlychk'>";
                        html += "            <input type='checkbox' id='tgr" + (i + 1) + "' tabindex='0' class='hidden'/>";
                        html += "            <label for='tgr" + (i + 1) + "'></label>";
                        html += "        </span>";
                        html += "    </td>";
                        html += "    <td>" + (i + 1) + "</td>";
                        html += "    <td class='tgList'>" + UiComm.escapeHtml(o.deptnm || "") + "</td>";
                        html += "    <td class='tgList'>" + UiComm.escapeHtml(o.stdntNo || "") + "</td>";
                        html += "    <td class='tgList'>" + UiComm.escapeHtml(o.usernm || "") + "</td>";
                        html += "</tr>";

                        $("#indvAsmtList input[value='" + o.userId + "']").closest("tr").remove();
                    });

                    $("#indvAsmtList tr").each(function (i) {
                        $("#indvAsmtList tr:eq(" + i + ") td:eq(1)").text(i + 1);
                    });

                    $("#sindvAsmtList").empty().append(html);
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }, function () {
                UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");
            }, true);
        }


        /**
         * =========================================================
         * 이전 과제 가져오기
         * =========================================================
         */
        function asmtCopyListPop() {

            dialog = UiDialog("copyDialog", {
                title: "<spring:message code='asmt.button.asmt.prev'/><%--이전 과제 가져오기--%>",
                width: 800,
                height: 500,
                url: "/asmt2/profAsmtCopyListPop.do?sbjctId=" + SBJCT_ID,
                autoresize: false
            });
        }


        /**
         * =========================================================
         * 이전 과제 가져오기 팝업에서 선택 버튼 클릭 시 호출
         * =========================================================
         */
        function copyAsmt(asmtId) {
            isEditMode = false;
            isCopyMode = true;
            getAsmt(asmtId);

            if (dialog) {
                dialog.close();
            }
        }


        /**
         * =========================================================
         * 과제 조회
         * =========================================================
         */
        function getAsmt(asmtId) {

            const url = "/asmt2/profAsmtSelectAjax.do";
            const data = {
                sbjctId: SBJCT_ID
                , asmtId: asmtId
            };

            ajaxCall(url, data, function (data) {
                if (data.encParams != null && data.encParams != '') {
                    EPARAM = data.encParams;
                }
                if (data.result > 0) {
                    const vo = data.returnVO;
                    setData(vo);

                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }, function () {
                UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");
            }, true);
        }


        /**
         * =========================================================
         * 상세 데이터 바인딩
         * - 수정: 실제 값 세팅
         * - 복사/등록: 날짜/일부 옵션 초기화
         * =========================================================
         */
        function setData(asmtData) {
            /**
             * 기본값
             */
            $("#asmtTtl").val(asmtData.asmtTtl || "");
            editor.openHTML(asmtData.asmtCts || "");
            const currWknoSchdlId = $("#lctrWknoSchdlId option[data-curr-wkno='Y']").val() || "";
            $("#lctrWknoSchdlId").val(isEditMode ? (asmtData.lctrWknoSchdlId || currWknoSchdlId) : currWknoSchdlId);

            /**
             * 등록/수정 공통 초기화
             */
            $("input[name='sbasmtTycd'][value='FILE']").prop("checked", true);
            $("input[name='sbmsnFileMimeTycdOption'][value='all']").prop("checked", true);
            $("input[name='prtcFileType']").prop("checked", false);
            $("input[name='preFile']").prop("checked", false);
            $("input[name='docFile']").prop("checked", false);
            $("#allFile").prop("checked", true);
            $("#preFile").prop("checked", false);
            $("#docFile").prop("checked", false);
            $("#rubricId").val("");
            $("#rubricTtl").val("");

            /**
             * 수정 모드
             */
            if (isEditMode) {
                $("input[name='asmtId']").val(asmtData.asmtId || "");
                $("input[name='prevAsmtId']").val("");
                $("#dvclasView").hide();

                asmtDateUtil.setDateTimeVal("asmtSbmsnDateSt", "asmtSbmsnTimeSt", asmtData.asmtSbmsnSdttm);
                asmtDateUtil.setDateTimeVal("asmtSbmsnDateEd", "asmtSbmsnTimeEd", asmtData.asmtSbmsnEdttm);

                $("input[name='extdSbmsnPrmyn'][value='" + (asmtData.extdSbmsnPrmyn || "N") + "']").prop("checked", true);
                asmtDateUtil.setDateTimeVal("extdSbmsnDateEd", "extdSbmsnTimeEd", asmtData.extdSbmsnEdttm);
                $("#extdSbmsnMrkRfltrt").val(asmtData.extdSbmsnMrkRfltrt || "");

                $("input[name='asmtPrctcyn']").prop("disabled", true);
                $("input[name='teamAsmtStngyn']").prop("disabled", true);
                $("input[name='indvAsmtyn']").prop("disabled", true);
            } else {
                /**
                 * 복사/등록 모드
                 * - 날짜/연장제출/과제읽기허용은 초기화
                 * - 팀/개별/첨부/부과제/대상자 초기화
                 */
                $("input[name='asmtId']").val("");
                $("input[name='prevAsmtId']").val(isCopyMode ? (asmtData.asmtId || "") : "");
                $("#dvclasView").show();

                $("#asmtSbmsnDateSt, #asmtSbmsnTimeSt, #asmtSbmsnDateEd, #asmtSbmsnTimeEd").val("");
                $("#mrkInqSdttmDateSt, #mrkInqSdttmTimeSt").val("");
                $("#extdSbmsnDateEd, #extdSbmsnTimeEd").val("");
                $("#extdSbmsnMrkRfltrt").val("");
                $("#ostdOpenSdttmDateSt, #ostdOpenSdttmTimeSt").val("");

                $("input[name='extdSbmsnPrmyn'][value='N']").prop("checked", true);
                $("input[name='sbasmtOstdOyn'][value='N']").prop("checked", true);

                $("input[name='asmtPrctcyn']").prop("disabled", false);
                $("input[name='teamAsmtStngyn']").prop("disabled", false);
                $("input[name='indvAsmtyn']").prop("disabled", false);

                /**
                 * 기본정보만 복사
                 * -> 팀/개별/팀내개별제출/분반/학습그룹/부과제/첨부/대상자 안 가져옴
                 */
                $("input[name='teamAsmtStngyn'][value='N']").prop("checked", true);
                $("input[name='tmbrIndivSbmsnPrmyn'][value='N']").prop("checked", true);
                $("input[name='indvAsmtyn'][value='N']").prop("checked", true);

                $("input[name='teamGrpIds']").val("");
                $("input[id^='teamGrpnm']").val("");
                $("input[name='byteamAsmtUseyns']").prop("checked", false);
                $("div[id^='subAsmtInfoDiv']").hide().empty();
                subAsmtUploaderIds = [];
                subAsmtUploadResults = {};
                Object.keys(SUB_ASMT_EDITORS).forEach(function (editorId) {
                    delete SUB_ASMT_EDITORS[editorId];
                });

                $("#indvAsmtList").empty();
                $("#sindvAsmtList").empty();
                isIndvListLoaded = false;

                const dx = dx5.get("upload1");
                if (dx) {
                    dx.clearItems();
                }
                $("input[name='uploadFiles']").val("");
                $("input[name='delFileIdStr']").val("");
            }

            /**
             * 성적반영 / 성적공개
             */

            if (isEditMode && asmtData.indvAsmtyn === "Y") {
                $("input[name='mrkRfltyn'][value='N']").prop("checked", true);
            } else {
                $("input[name='mrkRfltyn'][value='" + (asmtData.mrkRfltyn || "Y") + "']").prop("checked", true);
            }
            $("input[name='mrkOyn'][value='" + (asmtData.mrkOyn || "N") + "']").prop("checked", true);
            asmtDateUtil.setDateTimeVal("mrkInqSdttmDateSt", "mrkInqSdttmTimeSt", asmtData.mrkInqSdttm);

            /**
             * 평가방법
             */
            $("input[name='evlScrTycd'][value='" + (asmtData.evlScrTycd || "SCR") + "']").prop("checked", true);

            if (asmtData.evlScrTycd === "RUBRIC_SCR") {
                $("#rubricId").val(asmtData.rubricId || "");
                $("#rubricTtl").val(asmtData.rubricTtl || "");
            }

            /**
             * 제출형식 / 실기과제
             */
            $("input[name='asmtPrctcyn'][value='" + (asmtData.asmtPrctcyn || "N") + "']").prop("checked", true);
            $("input[name='sbasmtTycd'][value='" + (asmtData.sbasmtTycd || "FILE") + "']").prop("checked", true);

            if (asmtData.asmtPrctcyn === "Y") {
                const prtcFileArr = (asmtData.sbmsnFileMimeTycd || "").split(",");

                prtcFileArr.forEach(function (fileTy) {
                    $("input[name='prtcFileType'][value='" + $.trim(fileTy) + "']").prop("checked", true);
                });

                $("input[name='exlnAsmtDwldyn'][value='" + (asmtData.exlnAsmtDwldyn || "N") + "']").prop("checked", true);
            } else {
                const fileArr = (asmtData.sbmsnFileMimeTycd || "").split(",");

                if (!asmtData.sbmsnFileMimeTycd) {
                    $("#allFile").prop("checked", true);
                } else {
                    fileArr.forEach(function (fileTy, idx) {
                        const item = $.trim(fileTy);

                        if (["img", "pdf", "txt", "soc", "ppt2"].includes(item)) {
                            if (idx === 0) {
                                $("#preFile").prop("checked", true);
                            }
                            $("input[name='preFile'][value='" + item + "']").prop("checked", true);
                        } else if (["hwp", "doc", "ppt", "xls", "pdf2", "zip"].includes(item)) {
                            if (idx === 0) {
                                $("#docFile").prop("checked", true);
                            }
                            $("input[name='docFile'][value='" + item + "']").prop("checked", true);
                        }
                    });
                }
            }

            /**
             * 팀과제 / 개별과제
             * - 수정만 복원
             */
            if (isEditMode) {
                $("input[name='teamAsmtStngyn'][value='" + (asmtData.teamAsmtStngyn || "N") + "']").prop("checked", true);
                $("input[name='indvAsmtyn'][value='" + (asmtData.indvAsmtyn || "N") + "']").prop("checked", true);
            }

            /**
             * 수정모드 - 팀과제
             */
            if (isEditMode && asmtData.teamAsmtStngyn === "Y") {
                // const dvclasNo = asmtData.dvclasNo || "";

                const teamGrpId = asmtData.teamGrpId || "";
                const sbjctId = asmtData.sbjctId || "";
                const viewKey = getViewKeyBySbjctId(asmtData.sbjctId || "");
                const dvclasNo = getDvclasNoBySbjctId(asmtData.sbjctId || "");
                const byteamAsmtUseyn = asmtData.byteamAsmtUseyn || "N";
                const teamGrpnm = asmtData.teamGrpnm || "";

                if (viewKey) {
                    $("#teamGrpId" + viewKey).val(teamGrpId + ":" + sbjctId);
                    $("#teamGrpnm" + viewKey).val(teamGrpnm);

                    $("#teamGrpView" + viewKey).show();
                    $("#setSubAsmtDiv" + viewKey).show();

                    if (teamGrpId) {
                        $("#byteamAsmtUseyn_" + viewKey).prop("checked", byteamAsmtUseyn === "Y");

                        if (byteamAsmtUseyn === "Y") {
                            $("#subAsmtInfoDiv" + viewKey).show();
                            loadAsmtTeamList(teamGrpId, viewKey, sbjctId, asmtData.asmtId);
                        }
                    }
                }
            }

            /**
             * 수정모드 - 개별과제
             */
            if (isEditMode && asmtData.indvAsmtyn === "Y") {
                if (!isIndvListLoaded) {
                    getIndivAsmtStdList(asmtData.asmtId);
                } else {
                    getIndivAsmtSbmsnTrgtList(asmtData.asmtId);
                }
            }

            /**
             * 과제읽기 허용
             */
            if (isEditMode) {
                $("input[name='sbasmtOstdOyn'][value='" + (asmtData.sbasmtOstdOyn || "N") + "']").prop("checked", true);
                asmtDateUtil.setDateTimeVal("ostdOpenSdttmDateSt", "ostdOpenSdttmTimeSt", asmtData.sbasmtOstdOpenSdttm);
            } else {
                $("input[name='sbasmtOstdOyn'][value='N']").prop("checked", true);
            }


            /**
             * 화면 상태 반영
             */
            applyCurrentView();
        }

        /**
         * =========================================================
         * 학습그룹별 하위과제 데이터 검증
         * =========================================================
         */
        function validateSubAsmtDetail() {

            let valid = true;

            $("input[name='byteamAsmtUseyns']:checked").each(function () {
                const viewKey = $(this).data("view-key");
                const $rows = $("#subAsmtInfoDiv" + viewKey + " .subAsmtTr");

                if ($rows.length === 0) {
                    UiComm.showMessage("<spring:message code='asmt.alert.team.grp.team.empty'/><%--학습그룹에 등록된 팀이 없습니다.--%>", "error");
                    valid = false;
                    return false;
                }

                $rows.each(function () {
                    const $row = $(this);
                    const ttl = ($row.next("tr").find("input[name='subAsmtTtls']").val() || "").trim();

                    if (!ttl) {
                        UiComm.showMessage("<spring:message code='asmt.alert.input.team.sub.topic'/><%--팀별 부주제를 입력해 주세요.--%>", "error");
                        valid = false;
                        return false;
                    }
                });

                if (!valid) {
                    return false;
                }
            });

            return valid;
        }


        /**
         * =========================================================
         * 저장 전 검증
         * =========================================================
         */
        function validation() {

            const asmtTtl = ($("#asmtTtl").val() || "").trim();

            /**
             * 과제명
             */
            if (!asmtTtl) {
                UiComm.showMessage("<spring:message code='asmt.alert.input.asmt_title' /><%--과제명을 입력하세요.--%>", "error");
                $("#asmtTtl").focus();
                return false;
            }

            /**
             * 제출기간
             */
            if (asmtDateUtil.isEmptyDateTime("asmtSbmsnDateSt", "asmtSbmsnTimeSt") || asmtDateUtil.isEmptyDateTime("asmtSbmsnDateEd", "asmtSbmsnTimeEd")) {
                UiComm.showMessage("<spring:message code='asmt.alert.input.submit.period'/><%--제출기간을 입력하세요--%>", "error");
                return false;
            }

            if (asmtDateUtil.isGreaterDateTime("asmtSbmsnDateSt", "asmtSbmsnTimeSt", "asmtSbmsnDateEd", "asmtSbmsnTimeEd")) {
                UiComm.showMessage("<spring:message code='asmt.alert.submit.start.after.end'/><%--제출시작일이 종료일보다 큽니다.--%>", "error");
                return false;
            }

            const mrkProcEdttm = (MRK_PROC_EDTTM || "").replace(/[^0-9]/g, "");
            const asmtSbmsnEdttm = asmtDateUtil.getDateTimeVal("asmtSbmsnDateEd", "asmtSbmsnTimeEd") + "00";
            const mrkInqSdttm = asmtDateUtil.getDateTimeVal("mrkInqSdttmDateSt", "mrkInqSdttmTimeSt");

            if (mrkProcEdttm && asmtSbmsnEdttm > mrkProcEdttm) {
                UiComm.showMessage("<spring:message code='asmt.alert.submit.end.before.score.end'/><%--과제 제출 종료일시는 성적처리종료 일시 전까지만 등록할 수 있습니다.--%>", "error");
                return false;
            }

            if ($("input[name='mrkOyn']:checked").val() === "Y" && !mrkInqSdttm) {
                UiComm.showMessage("<spring:message code='asmt.alert.input.score.open.sdttm'/><%--성적 공개 일시를 입력하세요.--%>", "error");
                return false;
            }

            /**
             * 실기과제 / 제출형식
             */
            if ($("input[name='asmtPrctcyn']:checked").val() === "Y") {
                if ($("input[name='prtcFileType']:checked").length < 1) {
                    UiComm.showMessage("<spring:message code='asmt.label.prtc.filetype.select' /><%--실기과제 파일형식을 선택하세요.--%>", "error");
                    return false;
                }
            } else {
                if ($("input[name='sbasmtTycd']:checked").length === 0) {
                    UiComm.showMessage("<spring:message code='asmt.label.filetype.select' /><%--제출형식을 선택하세요.--%>", "error");
                    return false;
                }

                if ($("input[name='sbasmtTycd']:checked").val() === "FILE") {
                    if ($("input[name='sbmsnFileMimeTycdOption']:checked").val() !== "all") {
                        if ($("input[name='preFile']:checked").length + $("input[name='docFile']:checked").length < 1) {
                            UiComm.showMessage("<spring:message code='file.label.filetype.select' />", "error");
                            return false;
                        }
                    }
                }
            }

            /**
             * 팀과제
             */
            if ($("input[name='teamAsmtStngyn']:checked").val() === "Y") {
                let checkLrnGrpId = true;

                $("input[name='dvclasList']").each(function (i) {

                    if (this.value !== "ALL") {
                        /*
                         * 분반 체크박스의 data-index와 학습그룹 hidden id의 suffix가 동일하다.
                         * 저장 검증에서는 DOM 재검색보다 현재 체크박스 기준 index를 직접 쓰는 편이 안전하다.
                         */
                        const viewKey = $(this).data("index");
                        const teamGrpIdVal = $("#teamGrpId" + viewKey).val() || "";
                        const teamGrpId = teamGrpIdVal.split(":")[0];

                        if (this.checked && !teamGrpId) {
                            checkLrnGrpId = false;
                            return false;
                        }
                    }
                });

                if (!checkLrnGrpId) {
                    UiComm.showMessage("<spring:message code='asmt.alert.select.team.grp'/><%--학습그룹을 선택해 주세요.--%>", "info");
                    return false;
                }

                if (!validateSubAsmtDetail()) {
                    return false;
                }
            }

            /**
             * 개별과제
             */
            if ($("input[name='indvAsmtyn']:checked").val() === "Y") {
                if ($("#sindvAsmtList tr").length < 1) {
                    UiComm.showMessage("<spring:message code='asmt.label.ezg.noselect.user' /><%--개별과제 대상자를 선택하시기 바랍니다.--%>", "error");
                    return false;
                }
            }

            /**
             * 연장제출
             */
            if ($("input[name='extdSbmsnPrmyn']:checked").val() === "Y") {
                if (asmtDateUtil.isEmptyDateTime("extdSbmsnDateEd", "extdSbmsnTimeEd")) {
                    UiComm.showMessage("<spring:message code='asmt.alert.input.ext.submit.date'/><%--연장제출 허용일을 입력하세요.--%>", "error");
                    return false;
                }

                if (asmtDateUtil.isGreaterDateTime("asmtSbmsnDateEd", "asmtSbmsnTimeEd", "extdSbmsnDateEd", "extdSbmsnTimeEd")) {
                    UiComm.showMessage("<spring:message code='asmt.alert.invalid.ext.send.dttm' /><%--지각제출 종료일은 과제 종료일보다 크게 입력하세요.--%>", "error"); /* 지각제출 종료일은 과제 종료일보다 크게 입력하세요.*/
                    return false;
                }

                const extdSbmsnEdttm = asmtDateUtil.getDateTimeVal("extdSbmsnDateEd", "extdSbmsnTimeEd") + "00";

                if (mrkProcEdttm && extdSbmsnEdttm > mrkProcEdttm) {
                    UiComm.showMessage("<spring:message code='asmt.alert.ext.submit.end.before.score.end'/><%--연장제출 종료일시는 성적처리종료 일시 전까지만 등록할 수 있습니다.--%>", "error");
                    return false;
                }

                const extdSbmsnMrkRfltrt = $.trim($("#extdSbmsnMrkRfltrt").val());
                const extdSbmsnMrkRfltrtNum = Number(extdSbmsnMrkRfltrt);

                if (extdSbmsnMrkRfltrt === "" || isNaN(extdSbmsnMrkRfltrtNum)) {
                    UiComm.showMessage("<spring:message code='asmt.alert.input.ext.submit.score.ratio'/><%--연장제출 성적 반영비율을 입력하세요.--%>", "error");
                    $("#extdSbmsnMrkRfltrt").focus();
                    return false;
                }

                if (extdSbmsnMrkRfltrtNum < 0 || extdSbmsnMrkRfltrtNum > 100) {
                    UiComm.showMessage("<spring:message code='asmt.alert.input.ext.submit.score.ratio.range'/><%--연장제출 성적 반영비율은 0~100까지만 입력 가능합니다.--%>", "error");
                    $("#extdSbmsnMrkRfltrt").focus();
                    return false;
                }
            }

            /**
             * 루브릭
             */
            if ($("input[name='evlScrTycd']:checked").val() === "RUBRIC_SCR" && !$("#rubricId").val()) {
                UiComm.showMessage("<spring:message code='asmt.alert.empty.rubric' /><%--평가방법 루브릭을 설정하세요.--%>", "error");
                return false;
            }

            /**
             * 과제읽기 허용
             */
            if ($("input[name='sbasmtOstdOyn']:checked").val() === "Y") {
                if (asmtDateUtil.isEmptyDateTime("ostdOpenSdttmDateSt", "ostdOpenSdttmTimeSt")) {
                    UiComm.showMessage("<spring:message code='asmt.label.read.start' /><%--과제읽기 시작--%>", "error");
                    return false;
                }
            }

            return true;
        }


        /**
         * =========================================================
         * 저장 확인
         * =========================================================
         */
        function saveConfirm() {
            if (!validation()) {
                return;
            }

            buildSubmitData();
            startUploadChain();
        }


        /**
         * =========================================================
         * 저장 데이터 조립
         * =========================================================
         */
        function buildSubmitData() {
            buildAsmtGbncd();
            buildAsmtCts();
            buildIndvAsmtList();
            buildSbmsnFileMimeTycd();
            buildDateTimeFields();
            appendDvclasInfoParams();

            const dx = dx5.get("upload1");
            if (dx) {
                /*$("input[name='copyFiles']").val(dx.getCopyFiles());*/
                $("input[name='delFileIdStr']").val(dx.getDelFileIdStr());
                $("input[name='uploadPath']").val(dx.getUploadPath());
            }
        }

        /**
         * 과제 내용 HTML 생성
         */
        function buildAsmtCts() {
            if (typeof editor !== "undefined" && editor && typeof editor.getPublishingHtml === "function") {
                $("#asmtCts").val(editor.getPublishingHtml());
            }
        }

        /**
         * 과제구분코드 생성
         */
        function buildAsmtGbncd() {
            const fixedAsmtGbncd = "${asmtVO.asmtGbncd}";
            const isTeamAsmtStng = $("input[name='teamAsmtStngyn']:checked").val() === "Y";
            const isIndvAsmt = $("input[name='indvAsmtyn']:checked").val() === "Y";
            const isAsmtPrctc = $("input[name='asmtPrctcyn']:checked").val() === "Y";

            let asmtGbncd = "";

            if (["EXAM_SBST", "ABSNCE_SBST", "MID_EXAM_SBST_ASMT", "LST_EXAM_SBST_ASMT"].includes(fixedAsmtGbncd)) {
                asmtGbncd = fixedAsmtGbncd;
            } else if (isIndvAsmt) {
                asmtGbncd = "INDV_ASMT";
            } else if (isAsmtPrctc) {
                asmtGbncd = isTeamAsmtStng ? "PRCTC_ASMT_TEAM" : "PRCTC_ASMT";
                $("input[name='sbasmtTycd'][value='FILE']").prop("checked", true);
            } else {
                asmtGbncd = isTeamAsmtStng ? "ASMT_TEAM" : "ASMT";
            }

            $("input[name='asmtGbncd']").val(asmtGbncd);
        }

        /**
         * 개별과제 대상자 문자열 생성
         */
        function buildIndvAsmtList() {
            const indvAsmtList = [];

            $("#sindvAsmtList tr").each(function () {
                const userId = $(this).find("input[type='hidden']").val();
                if (userId) {
                    indvAsmtList.push(userId);
                }
            });

            $("input[name='indvAsmtList']").val(indvAsmtList.join(","));
        }

        /**
         * 제출 파일 형식 문자열 생성
         */
        function buildSbmsnFileMimeTycd() {
            const fileTypeList = [];

            function addFileType(fileType) {
                fileType = $.trim(fileType || "");
                if (fileType && fileTypeList.indexOf(fileType) < 0) {
                    fileTypeList.push(fileType);
                }
            }

            if ($("input[name='asmtPrctcyn']:checked").val() === "Y") {
                $("input[name='prtcFileType']:checked").each(function () {
                    addFileType($(this).val());
                });
            } else {
                const sbasmtTycd = $("input[name='sbasmtTycd']:checked").val();

                if (sbasmtTycd === "FILE") {
                    const sbmsnFileMimeTycd = $("input[name='sbmsnFileMimeTycdOption']:checked").val();

                    if (sbmsnFileMimeTycd === "all") {
                        addFileType("all");
                    } else if (sbmsnFileMimeTycd === "pre") {
                        $("input[name='preFile']:checked").each(function () {
                            addFileType($(this).val());
                        });
                    } else if (sbmsnFileMimeTycd === "doc") {
                        $("input[name='docFile']:checked").each(function () {
                            addFileType($(this).val());
                        });
                    }
                }
            }

            $("input[type='hidden'][name='sbmsnFileMimeTycd']").val(fileTypeList.join(","));
        }

        /**
         * hidden 날짜 필드 생성
         */
        function buildDateTimeFields() {

            const asmtSbmsnSdttm = asmtDateUtil.getDateTimeVal("asmtSbmsnDateSt", "asmtSbmsnTimeSt");
            const asmtSbmsnEdttm = asmtDateUtil.getDateTimeVal("asmtSbmsnDateEd", "asmtSbmsnTimeEd");

            $("input[name='asmtSbmsnSdttm']").val(asmtSbmsnSdttm);
            $("input[name='asmtSbmsnEdttm']").val(asmtSbmsnEdttm);

            if ($("input[name='mrkOyn']:checked").val() === "Y") {
                $("input[name='mrkInqSdttm']").val(asmtDateUtil.getDateTimeVal("mrkInqSdttmDateSt", "mrkInqSdttmTimeSt"));
            } else {
                $("input[name='mrkInqSdttm']").val("");
            }

            if ($("input[name='extdSbmsnPrmyn']:checked").val() === "Y") {
                $("input[name='extdSbmsnSdttm']").val(asmtSbmsnEdttm);
                $("input[name='extdSbmsnEdttm']").val(asmtDateUtil.getDateTimeVal("extdSbmsnDateEd", "extdSbmsnTimeEd"));
            } else {
                $("input[name='extdSbmsnSdttm']").val("");
                $("input[name='extdSbmsnEdttm']").val("");
                $("#extdSbmsnMrkRfltrt").val("");
            }

            if ($("input[name='sbasmtOstdOyn']:checked").val() === "Y") {
                $("input[name='sbasmtOstdOpenSdttm']").val(asmtDateUtil.getDateTimeVal("ostdOpenSdttmDateSt", "ostdOpenSdttmTimeSt"));
                $("input[name='sbasmtOstdOpenEdttm']").val("999912312359");
            } else {
                $("input[name='sbasmtOstdOpenSdttm']").val("");
                $("input[name='sbasmtOstdOpenEdttm']").val("");
            }

            /**
             * 현재 UI에 상호평가 입력 영역이 없으므로 초기화
             */
            $("input[name='evlSdttm']").val("");
            $("input[name='evlEdttm']").val("");
        }

        function appendDvclasInfoParams() {
            $("#asmtWriteForm input.__dvclasInfoParam").remove();

            let index = 0;

            $("input[name='dvclasList']").each(function () {
                if (this.value === "ALL") {
                    return;
                }

                if (!this.checked) {
                    return;
                }

                $("<input>", {
                    type: "hidden",
                    name: "dvclasInfoList[" + index + "].sbjctId",
                    value: this.value,
                    "class": "__dvclasInfoParam"
                }).appendTo("#asmtWriteForm");

                $("<input>", {
                    type: "hidden",
                    name: "dvclasInfoList[" + index + "].dvclasNo",
                    value: $(this).data("dvclas-no"),
                    "class": "__dvclasInfoParam"
                }).appendTo("#asmtWriteForm");

                index++;
            });
        }


        /**
         * =========================================================
         * 저장
         * =========================================================
         */
        function save() {

            const url = isEditMode
                ? "/asmt2/profAsmtModifyAjax.do"
                : "/asmt2/profAsmtRegistAjax.do";

            ajaxCall(url, $("#asmtWriteForm").serialize(), function (data) {
                if (data.encParams != null && data.encParams != '') {
                    EPARAM = data.encParams;
                }
                if (data.result > 0) {
                    let message = "";
                    if (isEditMode) {
                        message = "<spring:message code='common.modify.success' />";
                    } else {
                        message = "<spring:message code='common.alert.ok.save' />";
                    }
                    UiComm.showMessage(message, "success").then(function () {
                        moveAsmtList();
                    });
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }, function () {
                UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");
            }, true);
        }


        /**
         * =========================================================
         * 목록 이동
         * =========================================================
         */
        function moveAsmtList() {
            const extData = {
                sbjctId: SBJCT_ID,
                asmtId: "",
                prevAsmtId: "",
                userId: "",
                teamId: ""
            };
            const kvArr = [];
            kvArr.push({'key': 'encParams', 'val': EPARAM});
            kvArr.push({'key': 'addParams', 'val': UiComm.makeEncParams(extData)});
            submitForm("/asmt2/profAsmtListView.do", "", kvArr);
        }

        /**
         * =========================================================
         * 메인 업로드 시작
         * =========================================================
         */
        function startUploadChain() {
            const dx = dx5.get("upload1");

            if (dx && dx.availUpload()) {
                dx.startUpload();
            } else {
                if (dx) {
                    $("input[name='delFileIdStr']").val(dx.getDelFileIdStr());
                    /*$("input[name='copyFiles']").val(dx.getCopyFiles());*/
                    $("input[name='uploadPath']").val(dx.getUploadPath());
                }
                continueSubAsmtUploadChain(0);
            }
        }

        /**
         * =========================================================
         * 메인 업로드 완료
         * =========================================================
         */
        function finishUpload() {

            const dx = dx5.get("upload1");
            const url = "/common/uploadFileCheck.do";
            const data = {
                uploadFiles: dx.getUploadFiles(),
                /*copyFiles: dx.getCopyFiles(),*/
                uploadPath: dx.getUploadPath()
            };

            ajaxCall(url, data, function (data) {
                if (data.encParams != null && data.encParams != '') {
                    EPARAM = data.encParams;
                }
                if (data.result > 0) {
                    $("input[name='uploadFiles']").val(dx.getUploadFiles());
                    /*$("input[name='copyFiles']").val(dx.getCopyFiles());*/
                    $("input[name='delFileIdStr']").val(dx.getDelFileIdStr());
                    $("input[name='uploadPath']").val(dx.getUploadPath());

                    continueSubAsmtUploadChain(0);
                } else {
                    UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
                }
            }, function () {
                UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
            }, true);
        }

        /**
         * =========================================================
         * 팀별 부과제 업로드 순차 처리
         * =========================================================
         */
        function continueSubAsmtUploadChain(uploadIdx) {

            if (uploadIdx >= subAsmtUploaderIds.length) {
                appendSubAsmtDetailParams();
                save();
                return;
            }

            const uploaderId = subAsmtUploaderIds[uploadIdx];
            const dx = dx5.get(uploaderId);

            if (!dx) {
                subAsmtUploadResults[uploaderId] = {
                    uploadFiles: "",
                    uploadPath: "",
                    delFileIdStr: "",
                    /*copyFiles: ""*/
                };
                continueSubAsmtUploadChain(uploadIdx + 1);
                return;
            }

            if (dx.availUpload()) {
                dx.startUpload();
            } else {
                subAsmtUploadResults[uploaderId] = {
                    uploadFiles: "",
                    uploadPath: dx.getUploadPath(),
                    delFileIdStr: dx.getDelFileIdStr ? dx.getDelFileIdStr() : ""
                    /*copyFiles: dx.getCopyFiles ? dx.getCopyFiles() : ""*/
                };
                continueSubAsmtUploadChain(uploadIdx + 1);
            }
        }

        /**
         * =========================================================
         * 팀별 부과제 업로드 완료 콜백
         * =========================================================
         */
        function onSubAsmtUploadComplete(uploaderId) {

            const uploadIdx = subAsmtUploaderIds.indexOf(uploaderId);
            const dx = dx5.get(uploaderId);

            const url = "/common/uploadFileCheck.do";
            const data = {
                uploadFiles: dx.getUploadFiles(),
                // copyFiles: dx.getCopyFiles ? dx.getCopyFiles() : "",
                uploadPath: dx.getUploadPath()
            };

            ajaxCall(url, data, function (data) {
                if (data.encParams != null && data.encParams != '') {
                    EPARAM = data.encParams;
                }
                if (data.result > 0) {
                    subAsmtUploadResults[uploaderId] = {
                        uploadFiles: dx.getUploadFiles(),
                        uploadPath: dx.getUploadPath(),
                        delFileIdStr: dx.getDelFileIdStr ? dx.getDelFileIdStr() : ""
                        // copyFiles: dx.getCopyFiles ? dx.getCopyFiles() : ""
                    };

                    continueSubAsmtUploadChain(uploadIdx + 1);
                } else {
                    UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
                }
            }, function () {
                UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
            }, true);
        }


        /**
         * 학습그룹 팝업
         * @param i - 화면 key
         * @param sbjctId - 과목아이디
         */
        function teamGrpSelectPop(i, sbjctId) {
            dialog = UiDialog("teamGrpDialog", {
                title: "<spring:message code='asmt.button.team.grp.select'/><%--학습그룹지정--%>",
                width: 600,
                height: 500,
                url: "/team/teamHome/teamCtgrSelectPop.do?sbjctId=" + sbjctId + "&searchFrom=" + i + ":" + sbjctId,
                autoresize: false
            });

        }

        /**
         * 학습그룹 선택
         * @param teamGrpId 학습그룹아이디
         * @param teamGrpnm 학습그룹명
         * @param id
         */
        function selectTeam(teamGrpId, teamGrpnm, id) {
            const idList = id.split(":");
            $("#teamGrpId" + idList[0]).val(teamGrpId + ":" + idList[1]);
            $("#teamGrpnm" + idList[0]).val(teamGrpnm);
            $("#byteamAsmtUseyn_" + idList[0]).prop("checked", false);
            clearSubAsmtInfo(idList[0]);
        }


        /**
         * =========================================================
         * 개별과제 검색
         * =========================================================
         */
        function indiSearch(type) {

            if (type === "T") {
                const keyword = ($("#tgSearch").val() || "").trim().toLowerCase();
                $("#tg0").prop("checked", false);
                $("#indvAsmtList input:checkbox").prop("checked", false);

                $("#indvAsmtList tr").each(function () {
                    const rowText = $(this).text().toLowerCase();

                    if (!keyword || rowText.indexOf(keyword) > -1) {
                        $(this).show();
                    } else {
                        $(this).hide();
                    }
                });
            } else if (type === "S") {
                const keyword = ($("#stgSearch").val() || "").trim().toLowerCase();

                $("#stg0").prop("checked", false);
                $("#sindvAsmtList input:checkbox").prop("checked", false);

                $("#sindvAsmtList tr").each(function () {
                    const rowText = $(this).text().toLowerCase();

                    if (!keyword || rowText.indexOf(keyword) > -1) {
                        $(this).show();
                    } else {
                        $(this).hide();
                    }
                });
            }
        }

        /**
         * =========================================================
         * 루브릭 팝업
         * =========================================================
         */
        function rubricPop(type) {
            let rubricId = "";
            if (type === "edit") {
                rubricId = $("#rubricId").val();

                if (!rubricId) {
                    UiComm.showMessage("<spring:message code='asmt.alert.evalCd.del'/><%--평가방법에서 루브릭을 선택 후 루브릭을 등록해 주세요.--%>", "error");
                    return false;
                }
            }
            dialog = UiDialog("asmtRubricWritePop", {
                title: "<spring:message code='asmt.label.rubric.reg'/><%--루브릭 등록--%>",
                width: 1200,
                height: 800,
                url: "/asmt2/profAsmtRubricWritePopup.do?sbjctId=" + SBJCT_ID
                    + "&rubricId=" + rubricId,
                autoresize: false,
            });
        }

        /**
         * 공통 루브릭 팝업 저장 결과를 과제 입력값에 반영한다.
         */
        function applyRubric(rubricId, rubricTtl) {
            $("#rubricId").val(rubricId);
            $("#rubricTtl").val(rubricTtl);
            $("input[name='evlScrTycd'][value='RUBRIC_SCR']").prop("checked", true);
            applyCurrentView();
        }

        function applyAsmtRubric(rubricId, rubricTtl) {
            applyRubric(rubricId, rubricTtl);
        }

        /**
         * 선택한 루브릭 제목을 라디오 버튼 옆에 표시한다.
         */
        function refreshRubricTitle() {
            const rubricTtl = $("#rubricTtl").val();
            const isRubric = $("input[name='evlScrTycd']:checked").val() === "RUBRIC_SCR";

            $("#rubricTitleBtn")
            .text(rubricTtl || "")
            .toggle(isRubric && !!rubricTtl);
        }

        /**
         * 팝업 dialog 닫기 (window.parent.closeDialog()로 호출됨)
         */
        function closeDialog() {
            if (dialog) {
                dialog.close();
            }
        }

    </script>
</head>

<body class="class ${uiex:getTheme()} ${bodyClass}">
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
                <!-- class_info -->
                <jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
                <!-- //class_info -->

                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title"><spring:message code='asmt.label.asmt'/><%--과제--%></h2>
                    </div>

                    <div class="table-wrap">
                        <form id="asmtWriteForm" name="asmtWriteForm" method="post" action="" onsubmit="saveConfirm(); return false;">
                            <input type="hidden" name="asmtId">
                            <input type="hidden" name="prevAsmtId" value="${asmtVO.prevAsmtId}">
                            <input type="hidden" name="asmtGbncd">
                            <input type="hidden" name="indvAsmtList">
                            <input type="hidden" name="sbjctId" value="${asmtVO.sbjctId}">
                            <input type="hidden" name="sbmsnFileMimeTycd">
                            <input type="hidden" name="repoCd" value="ASMT">
                            <input type="hidden" name="uploadPath" value="${asmtVO.uploadPath}"/>
                            <input type="hidden" name="uploadFiles">
                            <input type="hidden" name="delFileIdStr"/>
                            <%--<input type="hidden" name="copyFiles">--%>
                            <input type="hidden" name="asmtSbmsnSdttm" id="asmtSbmsnSdttm">
                            <input type="hidden" name="asmtSbmsnEdttm" id="asmtSbmsnEdttm">
                            <input type="hidden" name="mrkInqSdttm" id="mrkInqSdttm">
                            <input type="hidden" name="sbasmtOstdOpenSdttm" id="sbasmtOstdOpenSdttm">
                            <input type="hidden" name="sbasmtOstdOpenEdttm" id="sbasmtOstdOpenEdttm">
                            <input type="hidden" name="extdSbmsnSdttm" id="extdSbmsnSdttm">
                            <input type="hidden" name="extdSbmsnEdttm" id="extdSbmsnEdttm">
                            <input type="hidden" name="evlSdttm" id="evlSdttm">
                            <input type="hidden" name="evlEdttm" id="evlEdttm">


                            <table class="table-type5">
                                <colgroup>
                                    <col class="width-15per"/>
                                    <col/>
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th><label for="asmtTtl" class="req"><spring:message code='asmt.label.asmt.title'/><%--과제명--%></label></th>
                                    <td>
                                        <div class="form-row">
                                            <input class="form-control width-100per" type="text" id="asmtTtl" name="asmtTtl" placeholder="<spring:message code='asmt.alert.input.title'/><%--제목을 입력하세요.--%>">
                                        </div>
                                    </td>
                                </tr>

                                <%--과제내용--%>
                                <tr>
                                    <th><label for="asmtCts" class="req"><spring:message code='asmt.label.asmt.content'/><%--과제내용--%></label></th>
                                    <td>
                                        <div class="editor-box">
                                            <textarea id="asmtCts" name="asmtCts" required="true"><c:out value="${asmtVO.asmtCts}"/></textarea>
                                            <script>
                                                // HTML 에디터
                                                editor = UiEditor({
                                                    targetId: "asmtCts",
                                                    uploadPath: "${asmtVO.uploadPath}",
                                                    height: "300px"
                                                });
                                            </script>
                                        </div>
                                    </td>
                                </tr>

                                <c:if test="${empty asmtVO.asmtId}">
                                    <%--분반 일괄 등록--%>
                                    <tr id="dvclasView">
                                        <th><label><spring:message code='asmt.label.grp.crs.all'/><%--분반 일괄 등록--%></label></th>
                                        <td>
                                            <div class="checkbox_type" id="dvclasListView">
                                                        <span class="custom-input">
                                                            <input type="checkbox" id="dvclasAll" name="dvclasList" value="ALL" <c:if test="${fn:length(dvclasList) eq 1}">checked onclick="return false;"</c:if>>
                        <label for="dvclasAll"><spring:message code='asmt.label.all'/><%--전체--%></label>
                                                        </span>

                                                <c:forEach var="item" items="${dvclasList}" varStatus="status">
                                                            <span class="custom-input">
                                                                <input type="checkbox"
                                                                       id="dvclas${status.index}"
                                                                       name="dvclasList"
                                                                       value="${item.sbjctId}"
                                                                       data-index="${status.index}"
                                                                       data-dvclas-no="${item.dvclasNo}"
                                                                       <c:if test="${item.sbjctId eq asmtVO.sbjctId}">checked onclick="return false;"</c:if>>
                            <label for="dvclas${status.index}">${item.dvclasNo}
                                <spring:message code='asmt.label.dvclas'/><%--분반--%></label>
                                                            </span>
                                                </c:forEach>
                                            </div>
                                        </td>
                                    </tr>
                                </c:if>

                                <tr>
                                    <th><label class="req"><spring:message code='asmt.label.lctr.wkno.setting'/><%--강의목록 주차 설정--%></label></th>
                                    <td>
                                        <div class="form-inline">
                                            <select class="form-select" id="lctrWknoSchdlId" name="lctrWknoSchdlId" required="true">
                                                <c:forEach var="item" items="${wknoList}">
                                                    <option value="${item.lctrWknoSchdlId}"
                                                            data-curr-wkno="${item.currWknoYn}"
                                                        ${(not empty asmtVO.lctrWknoSchdlId and asmtVO.lctrWknoSchdlId eq item.lctrWknoSchdlId) or (empty asmtVO.lctrWknoSchdlId and item.currWknoYn eq 'Y') ? 'selected' : ''}>
                                                            ${item.lctrWknonm}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <small class="note2">(! <spring:message code="asmt.label.lctr.wkno.info"/>)</small>
                                        </div>
                                    </td>
                                </tr>

                                <%-- 제출기간 --%>
                                <tr>
                                    <th><label for="asmtSbmsnDateSt" class="req"><spring:message code='asmt.label.send.date'/><%--제출기간--%></label></th>
                                    <td>
                                        <div class="custom-txt">
                                            <input id="asmtSbmsnDateSt" type="text" name="asmtSbmsnDateSt" class="datepicker" timeId="asmtSbmsnTimeSt" toDate="asmtSbmsnDateEd" placeholder="<spring:message code='asmt.label.start_date'/><%--시작일--%>">
                                            <input id="asmtSbmsnTimeSt" type="text" name="asmtSbmsnTimeSt" class="timepicker" dateId="asmtSbmsnDateSt" placeholder="<spring:message code='asmt.label.start.time'/><%--시작시간--%>">
                                            <span class="txt-sort">~</span>
                                            <input id="asmtSbmsnDateEd" type="text" name="asmtSbmsnDateEd" class="datepicker" timeId="asmtSbmsnTimeEd" fromDate="asmtSbmsnDateSt" placeholder="<spring:message code='asmt.label.end_date'/><%--종료일--%>">
                                            <input id="asmtSbmsnTimeEd" type="text" name="asmtSbmsnTimeEd" class="timepicker" dateId="asmtSbmsnDateEd" placeholder="<spring:message code='asmt.label.end.time'/><%--종료시간--%>">
                                        </div>
                                    </td>
                                </tr>

                                <%-- 성적반영 --%>
                                <tr>
                                    <th><label class="req"><spring:message code='asmt.label.score.aply'/><%--성적반영--%></label></th>
                                    <td>
                                        <div class="form-inline">
                                                    <span class="custom-input">
                                                        <input type="radio" name="mrkRfltyn" id="mrkRfltY" value="Y" ${asmtVO.mrkRfltyn eq 'Y' || empty asmtVO.asmtId ? 'checked' : '' }>
                        <label for="mrkRfltY"><spring:message code='asmt.common.yes'/><%--예--%></label>
                                                    </span>
                                            <span class="custom-input ml5">
                                                        <input type="radio" name="mrkRfltyn" id="mrkRfltN" value="N" ${asmtVO.mrkRfltyn eq 'N' ? 'checked' : '' }>
                        <label for="mrkRfltN"><spring:message code='asmt.common.no'/><%--아니오--%></label>
                                                    </span>
                                        </div>
                                    </td>
                                </tr>
                                <%-- 성적공개 --%>
                                <tr>
                                    <th><label><spring:message code='asmt.label.score.open'/><%--성적공개--%></label></th>
                                    <td>
                                        <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" name="mrkOyn" id="mrkOynY" value="Y" ${asmtVO.mrkOyn eq 'Y' || empty asmtVO.asmtId ? 'checked' : ''}>
                        <label for="mrkOynY"><spring:message code='asmt.common.yes'/><%--예--%></label>
                                                </span>
                                            <span class="custom-input ml5">
                                                    <input type="radio" name="mrkOyn" id="mrkOynN" value="N" ${asmtVO.mrkOyn eq 'N' ? 'checked' : '' }>
                        <label for="mrkOynN"><spring:message code='asmt.common.no'/><%--아니오--%></label>
                                                </span>
                                        </div>
                                        <div id="viewMrkInqSdttm" class="mt10">
                                            <div class="custom-txt">
                                                <span class="tit"><spring:message code='asmt.label.score.open.sdttm'/><%--성적 공개 일시--%> :</span>
                                                <input id="mrkInqSdttmDateSt" type="text" name="mrkInqSdttmDateSt" class="datepicker" timeId="mrkInqSdttmTimeSt" value="${fn:substring(asmtVO.mrkInqSdttm,0,8)}" placeholder="<spring:message code='asmt.label.start_date'/><%--시작일--%>" required="true">
                                                <input id="mrkInqSdttmTimeSt" type="text" name="mrkInqSdttmTimeSt" class="timepicker" dateId="mrkInqSdttmDateSt" value="${fn:substring(asmtVO.mrkInqSdttm,8,12)}" placeholder="<spring:message code='asmt.label.start.time'/><%--시작시간--%>" required="true">
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <%-- 연장 제출--%>
                                <tr>
                                    <th><label><spring:message code='asmt.label.ext.send.date'/><%--연장제출--%></label></th>
                                    <td>
                                        <div class="form-inline">
                                            <span class="custom-input">
                                                <input type="radio" name="extdSbmsnPrmyn" id="extdSbmsnPrmN" value="N" ${asmtVO.extdSbmsnPrmyn eq 'N' || empty asmtVO.asmtId ? 'checked' : '' }>
                        <label for="extdSbmsnPrmN"><spring:message code='asmt.common.no'/><%--아니오--%></label>
                                            </span>
                                            <span class="custom-input ml5">
                                                <input type="radio" name="extdSbmsnPrmyn" id="extdSbmsnPrmY" value="Y" ${asmtVO.extdSbmsnPrmyn eq 'Y'  ? 'checked' : '' }>
                        <label for="extdSbmsnPrmY"><spring:message code='asmt.common.yes'/><%--예--%></label>
                                            </span>
                                        </div>
                                        <%-- 제출 마감일 --%>
                                        <div id="viewExtdSbmsnPrm" class="mt10">
                                            <div class="custom-txt">
                                                <span class="tit"><spring:message code='asmt.label.submit.deadline.dttm'/><%--제출 마감일시--%> :</span>
                                                <input id="extdSbmsnDateEd" type="text" name="extdSbmsnDateEd" class="datepicker" timeId="extdSbmsnTimeEd" value="${fn:substring(asmtVO.extdSbmsnEdttm,0,8)}" placeholder="<spring:message code='asmt.label.ext.end.date'/><%--연장 종료일--%>" required="true">
                                                <input id="extdSbmsnTimeEd" type="text" name="extdSbmsnTimeEd" class="timepicker" dateId="extdSbmsnDateEd" value="${fn:substring(asmtVO.extdSbmsnEdttm,8,12)}" placeholder="<spring:message code='asmt.label.end.time'/><%--종료시간--%>" required="true">
                                                <span class="tit ml10"><spring:message code='asmt.label.ext.submit.score.info'/><%--채점점수의--%></span>
                                                <input id="extdSbmsnMrkRfltrt" type="text" name="extdSbmsnMrkRfltrt" class="form-control sm w70" value="${asmtVO.extdSbmsnMrkRfltrt}" inputmask="numeric" maxVal="100" required="true">
                                                <span>%</span>
                                                <small class="note3">! <spring:message code='asmt.label.ext.send.info'/><%--제출기간 이후 지각 제출 허용시 설정--%> </small>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <%-- 평가방법 --%>
                                <tr>
                                    <th><label class="req"><spring:message code='asmt.label.eval.method'/><%--평가방법--%></label></th>
                                    <td>
                                        <div class="form-inline">
                                            <span class="custom-input">
                                                <input type="radio" name="evlScrTycd" id="evlScrTycdS" value="SCR" ${asmtVO.evlScrTycd eq 'SCR' || empty asmtVO.asmtId ? 'checked' : '' }>
                    <label for="evlScrTycdS"><spring:message code='asmt.label.point.type'/><%--점수형--%></label>
                                            </span>
                                            <span class="custom-input ml5">
                                                <input type="radio" name="evlScrTycd" id="evlScrTycdR" value="RUBRIC_SCR" ${asmtVO.evlScrTycd eq 'RUBRIC_SCR' ? 'checked' : '' }>
                    <label for="evlScrTycdR"><spring:message code='asmt.label.rubric'/><%--루브릭--%></label>
                                                <button type="button" id="rubricTitleBtn" class="btn basic small ml5" onclick="rubricPop('edit');" style="display:none;"></button>
                                                <small class="note"><spring:message code='asmt.label.evalctgr.rubric.info'/><%--루브릭 선택시 루브릭 설정 팝업이 활성화 됩니다.--%></small>
                                            </span>
                                        </div>

                                        <input type="hidden" name="rubricId" id="rubricId"/>
                                        <input type="hidden" name="rubricTtl" id="rubricTtl">
                                        <%--<div id="mutEvalDiv" class="mb10">
                                            <div class="ui action input search-box mr5">
                                                <button type="button" class="ui icon button" onclick="rubricPop('new');"><i class="pencil alternate icon"></i></button>
                                                <button type="button" class="ui icon button" onclick="rubricPop('edit');"><i class="edit icon"></i></button>
                                                <button type="button" class="ui icon button" onclick="deleteMut();"><i class="trash icon"></i></button>
                                            </div>
                                        </div>--%>
                                    </td>
                                </tr>


                                <%--제출형식--%>
                                <tr id="viewSbasmtTycd">
                                    <th><label class="req"><spring:message code='asmt.label.asmt.send.type'/><%--제출형식--%></label></th>
                                    <td>
                                        <div class="form-inline">
                                            <span class="custom-input">
                                                <input type="radio" name="sbasmtTycd" id="sbasmtTycdF" value="FILE" ${asmtVO.sbasmtTycd eq 'FILE' || empty asmtVO.asmtId ? 'checked' : '' }>
                                                <label for="sbasmtTycdF"><spring:message code='asmt.label.file'/><!-- 파일 --></label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="sbasmtTycd" id="sbasmtTycdT" value="INPUT_TEXT">
                                                <label for="sbasmtTycdT"><spring:message code='asmt.label.text'/><%--텍스트--%>(TEXT)</label>
                                            </span>
                                        </div>
                                        <div class="sub_item" id="viewSbasmtTycdFile">
                                            <div class="item">
                                                <span class="custom-input">
                                                    <input type="radio" name="sbmsnFileMimeTycdOption" id="allFile" value="all" ${asmtVO.sbmsnFileMimeTycd eq 'all' || empty asmtVO.asmtId ? 'checked' : '' }>
                                                    <label for="allFile"><spring:message code='asmt.label.total.file'/><!-- 모든파일 --></label>
                                                </span>
                                            </div>
                                            <div class="item">
                                                <span class="custom-input">
                                                    <input type="radio" name="sbmsnFileMimeTycdOption" id="preFile" value="pre">
                                                    <label for="preFile"><spring:message code='button.preview'/><%--미리보기--%><spring:message code='message.possible'/><%--가능--%></label>
                                                </span>
                                                <div class="item-list" id="preFileList">
                                                    <span class="custom-input">
                                                        <input type="checkbox" name="preFile" id="preFile01" value="img">
                                                        <label for="preFile01"><spring:message code='lesson.label.img'/> (JPG, GIF, PNG)</label>
                                                    </span>
                                                    <span class="custom-input">
                                                        <input type="checkbox" name="preFile" id="preFile02" value="pdf">
                                                        <label for="preFile02">PDF</label>
                                                    </span>
                                                    <span class="custom-input">
                                                        <input type="checkbox" name="preFile" id="preFile03" value="txt">
                                                        <label for="preFile03">TEXT</label>
                                                    </span>
                                                    <span class="custom-input">
                                                        <input type="checkbox" name="preFile" id="preFile04" value="soc">
                                                        <label for="preFile04"><spring:message code='common.label.program.source'/></label>
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="item">
                                            <span class="custom-input">
                                                    <input type="radio" name="sbmsnFileMimeTycdOption" id="docFile" value="doc">
                        <label for="docFile"><spring:message code='asmt.label.specific.file.possible'/><%--특정파일 가능--%></label>
                                                </span>
                                                <div class="item-list" id="docFileList">
                                                    <span class="custom-input">
                                                        <input type="checkbox" name="docFile" id="docFile01" value="hwp">
                                                        <label for="docFile01">HWP</label>
                                                    </span>
                                                    <span class="custom-input">
                                                        <input type="checkbox" name="docFile" id="docFile02" value="doc">
                                                        <label for="docFile02">DOC</label>
                                                    </span>
                                                    <span class="custom-input">
                                                        <input type="checkbox" name="docFile" id="docFile03" value="ppt">
                                                        <label for="docFile03">PPT</label>
                                                    </span>
                                                    <span class="custom-input">
                                                        <input type="checkbox" name="docFile" id="docFile04" value="xls">
                                                        <label for="docFile04">XLS</label>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>

                                <tr>
                                    <th><label><spring:message code='asmt.label.file.upload'/><%--파일 업로드--%></label></th>
                                    <td>
                                        <uiex:dextuploader
                                                id="upload1"
                                                path="${asmtVO.uploadPath}"
                                                limitCount="5"
                                                limitSize="100"
                                                oneLimitSize="100"
                                                listSize="3"
                                                fileList="${asmtVO.fileList}"
                                                finishFunc="finishUpload()"
                                                allowedTypes="*"
                                        />
                                    </td>

                                </tr>

                                <%--실기과제--%>
                                <tr style="display:none;">
                                    <th><label class="req"><spring:message code='asmt.label.practice.asmt'/><%--실기과제--%></label></th>
                                    <td>
                                        <div class="form-inline">
                                            <span class="custom-input">
                                                <input type="radio" name="asmtPrctcyn" id="asmtPrctcN" value="N" ${asmtVO.asmtPrctcyn eq 'N' || empty asmtVO.asmtId ? 'checked' : '' }>
                                                <label for="asmtPrctcN">
                                                    <spring:message code='asmt.common.no'/><%--아니오--%>
                                                </label>
                                            </span>
                                            <span class="custom-input ml5">
                                                <input type="radio" name="asmtPrctcyn" id="asmtPrctcY" value="Y" ${asmtVO.asmtPrctcyn eq 'Y' ? 'checked' : '' }>
                                                <label for="asmtPrctcY">
                                                    <spring:message code='asmt.common.yes'/><%--예--%>
                                                </label>
                                            </span>
                                        </div>
                                        <div class="sub_item mt10" id="viewPrtc">
                                            <div class="custom-txt">
                                                <span class="tit"><spring:message code='button.manage.file.type'/><%--파일형식--%></span>
                                                <div class="item">
                                                    <div class="item-list">
                                                        <span class="custom-input">
                                                            <input type="checkbox" name="prtcFileType" id="fileType01" value="img">
                                                            <label for="fileType01"><spring:message code='common.label.image'/><%--이미지--%> (JPG, GIF, PNG)</label>
                                                        </span>
                                                        <span class="custom-input">
                                                            <input type="checkbox" name="prtcFileType" id="fileType02" value="pdf">
                                                            <label for="fileType02">PDF</label>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="custom-txt">
                                                <span class="tit"><spring:message code='asmt.label.excellent.asmt.download'/><%--우수과제 다운로드--%></span>
                                                <div class="item">
                                                    <div class="item-list">
                                                    <span class="custom-input">
                                                        <input type="radio" name="exlnAsmtDwldyn" id="exlnAsmtDwldN" value="N" ${asmtVO.exlnAsmtDwldyn eq 'N' || empty asmtVO.asmtId ? 'checked' : '' }>
                                                        <label for="exlnAsmtDwldN">
                                                            <spring:message code='asmt.common.no'/><%--아니오--%>
                                                        </label>
                                                    </span>
                                                        <span class="custom-input ml5">
                                                        <input type="radio" name="exlnAsmtDwldyn" id="exlnAsmtDwldY" value="Y" ${asmtVO.exlnAsmtDwldyn eq 'Y' ? 'checked' : '' }>
                                                        <label for="exlnAsmtDwldY">
                                                            <spring:message code='asmt.common.yes'/><%--예--%>
                                                        </label>
                                                    </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>

                                <tr>
                                    <th>
                                        <label for="teamLabel">
                                            <spring:message code='asmt.label.team.asmt'/><!-- 팀과제 -->
                                        </label>
                                    </th>
                                    <td>
                                        <%-- 팀과제 여부 --%>
                                        <div class="form-inline">
                                        <span class="custom-input">
                                            <input type="radio" name="teamAsmtStngyn" id="teamN" value="N" ${asmtVO.teamAsmtStngyn eq 'N' || empty asmtVO.asmtId ? 'checked' : '' }>
                                                <label for="teamN">
                                                    <spring:message code='asmt.common.no'/><%--아니오--%>
                                                </label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="teamAsmtStngyn" id="teamY" value="Y" ${asmtVO.teamAsmtStngyn eq 'Y' ? 'checked' : '' } >
                                                <label for="teamY">
                                                    <spring:message code='asmt.common.yes'/><%--예--%>
                                                </label>
                                            </span>
                                        </div>


                                        <%-- 팀과제 상세 영역 --%>
                                        <div id="viewTeamAsmt" class="team_item" style="display:none;">
                                            <%--개별제출허용--%>
                                            <div class="form-inline mb10">
                                                <label><spring:message code='asmt.label.individual.submit.allow'/><%--개별제출 허용--%></label>
                                                <span class="custom-input">
                                                    <input type="radio" id="tmbrIndivSbmsnPrmN" name="tmbrIndivSbmsnPrmyn" value="N" ${asmtVO.tmbrIndivSbmsnPrmyn eq 'N' || empty asmtVO.asmtId ? 'checked' : '' }>
                    <label for="tmbrIndivSbmsnPrmN"><spring:message code='asmt.common.no'/><%--아니오--%></label>
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" id="tmbrIndivSbmsnPrmY" name="tmbrIndivSbmsnPrmyn" value="Y">
                    <label for="tmbrIndivSbmsnPrmY"><spring:message code='asmt.common.yes'/><%--예--%></label>
                                                </span>
                                            </div>

                                            <c:forEach var="list" items="${dvclasList}" varStatus="status">
                                                <%-- 분반별 학습그룹 선택 영역 --%>
                                                <div class="item"
                                                     id="teamGrpView${status.index}"
                                                     data-view-key="${status.index}"
                                                     data-dvclas-no="${list.dvclasNo}"
                                                     data-sbjct-id="${list.sbjctId}"
                                                    ${list.sbjctId eq asmtVO.sbjctId ? "" : "style='display:none;'"}>

                                                        <%--                                                    <div class="input_btn width-100per">--%>
                                                    <label class="label_num">${list.dvclasNo}
                                                        <spring:message code='asmt.label.dvclas'/><%--분반--%></label>

                                                        <%-- 선택한 학습그룹 ID:학과목ID --%>
                                                    <input type="hidden"
                                                           id="teamGrpId${status.index}"
                                                           name="teamGrpIds"
                                                           value="">

                                                        <%-- 선택한 학습그룹명 --%>
                                                    <input class="form-control wide"
                                                           type="text"
                                                           id="teamGrpnm${status.index}"
                                                           placeholder="<spring:message code='asmt.alert.select.team.grp'/><%--학습그룹을 선택해 주세요.--%>"
                                                           readonly
                                                           autocomplete="off">
                                                    <button type="button" class="btn basic" onclick="teamGrpSelectPop('${status.index}','${list.sbjctId}')"><spring:message code='asmt.button.team.grp.select'/><%--학습그룹지정--%></button>

                                                </div>

                                                <c:if test="${status.first}">
                                                    <small class="note2">! <spring:message code='asmt.label.team.grp.empty.guide'/><%--구성된 팀이 없는 경우 메뉴 "과목설정 > 학습그룹지정"에서 팀을 생성해 주세요.--%></small>
                                                </c:if>

                                                <%-- 분반별 학습그룹 과제설정 영역 --%>
                                                <div class="item_setting"
                                                     id="setSubAsmtDiv${status.index}"
                                                    ${list.sbjctId eq asmtVO.sbjctId ? "" : "style='display:none;'"}>

                                                    <div class="checkbox_type">
                                                        <span class="custom-input">
                                                            <input type="checkbox"
                                                                   name="byteamAsmtUseyns"
                                                                   id="byteamAsmtUseyn_${status.index}"
                                                                   data-view-key="${status.index}"
                                                                   value="Y:${list.sbjctId}"
                                                                   onchange="byteamAsmtUseynChange(this)">
                                                            <label for="byteamAsmtUseyn_${status.index}">
                <spring:message code='asmt.label.team.grp.asmt.setting'/><%--학습그룹별 과제 설정--%>
                                                            </label>
                                                        </span>
                                                    </div>
                                                </div>

                                                <%-- 팀별 하위과제 입력영역 렌더링 영역 --%>
                                                <div id="subAsmtInfoDiv${status.index}" class="table-wrap mb30" style="display:none;"></div>


                                            </c:forEach>
                                        </div>
                                    </td>
                                </tr>

                                <tr>
                                    <th>
                                        <label for="indLabel">
                                            <spring:message code='asmt.label.individual.asmt'/><!-- 개별과제 -->
                                        </label>
                                    </th>
                                    <td>
                                        <div class="form-inline">
                                            <span class="custom-input">
                                                <input type="radio" name="indvAsmtyn" id="indN" value="N" ${asmtVO.indvAsmtyn eq 'N' || empty asmtVO.asmtId ? 'checked' : '' }>
                                                <label for="indN">
                                                    <spring:message code='message.no'/><!-- 아니오 -->
                                                </label>
                                            </span>
                                            <span class="custom-input ml5">
                                                <input type="radio" name="indvAsmtyn" id="indY" value="Y" ${asmtVO.indvAsmtyn eq 'Y' ? 'checked' : '' }>
                                                <label for="indY">
                                                    <spring:message code='message.yes'/><!-- 예 -->
                                                </label>
                                                <small class="note"><spring:message code='asmt.label.indi.info'/><%--전체 수강생 중 지정된 개별인원에게만 부여되며, 해당과제는 성적반영이 불가합니다.--%></small><!-- 전체 수강생 중 지정된 개별인원에게만 부여되며, 해당과제는 성적반영이 불가합니다. -->
                                            </span>
                                        </div>

                                        <div id="viewIndivAsmt">
                                            <div class="individualAssignment_list swapLists">
                                                <div class="individualAssignment_list_area swapListsItem">
                                                    <div class="board_top in_table">
                                                        <p><spring:message code='asmt.label.student.list'/><%--수강생 목록--%></p>
                                                        <div class="search-typeC">
                                                            <input class="form-control"
                                                                   type="text"
                                                                   id="tgSearch"
                                                                   placeholder="<spring:message code='asmt.label.search.user.placeholder'/><%--학과, 학번, 이름 입력--%>">
                                                            <button type="button"
                                                                    class="btn basic icon search"
                                                                    onclick="indiSearch('T')"
                                                                    aria-label="<spring:message code='asmt.label.search'/><%--조회--%>">
                                                                <i class="icon-svg-search"></i>
                                                            </button>
                                                        </div>
                                                    </div>

                                                    <div class="table-height-scroll">
                                                        <table class="table-type2">
                                                            <colgroup>
                                                                <col style="width:8%">
                                                                <col style="width:10%">
                                                                <col style="width:34%">
                                                                <col style="width:24%">
                                                                <col style="width:24%">
                                                            </colgroup>
                                                            <thead>
                                                            <tr>
                                                                <th>
                                                                    <span class="custom-input onlychk">
                                                                        <input type="checkbox" id="tg0">
                                                                        <label for="tg0"></label>
                                                                    </span>
                                                                </th>
                                                                <th><spring:message code='common.number.no'/></th><!-- NO. -->
                                                                <th><spring:message code='asmt.label.dept.nm'/><%--학과--%></th><!-- 학과 -->
                                                                <th><spring:message code='asmt.label.stdnt_no'/><%--학번--%></th><!-- 학번 -->
                                                                <th><spring:message code='asmt.label.user_nm'/><%--이름--%></th><!-- 이름 -->
                                                            </tr>
                                                            </thead>
                                                            <tbody id="indvAsmtList"></tbody>
                                                        </table>
                                                    </div>
                                                </div>

                                                <div class="arrowBtn">
                                                    <button type="button" class="btn basic icon"
                                                            data-medi-ui="swap"
                                                            data-swap-to="right"
                                                            data-swap-target="tr"
                                                            data-swap-arrival="tbody"
                                                            title="<spring:message code='asmt.button.move.right'/><%--오른쪽으로 이동--%>">
                                                        <i class="xi-angle-right"></i>
                                                    </button>
                                                    <button type="button" class="btn basic icon"
                                                            data-medi-ui="swap"
                                                            data-swap-to="left"
                                                            data-swap-target="tr"
                                                            data-swap-arrival="tbody"
                                                            title="<spring:message code='asmt.button.move.left'/><%--왼쪽으로 이동--%>">
                                                        <i class="xi-angle-left"></i>
                                                    </button>
                                                </div>

                                                <div class="individualAssignment_list_area swapListsItem">
                                                    <div class="board_top in_table">
                                                        <p><spring:message code='asmt.label.ind.asmt.user'/><%--개별과제 대상자--%></p><!-- 개별과제 대상자 -->
                                                        <div class="search-typeC">
                                                            <input class="form-control"
                                                                   type="text"
                                                                   id="stgSearch"
                                                                   placeholder="<spring:message code='asmt.label.search.user.placeholder'/><%--학과, 학번, 이름 입력--%>">
                                                            <button type="button"
                                                                    class="btn basic icon search"
                                                                    onclick="indiSearch('S')"
                                                                    aria-label="<spring:message code='asmt.label.search'/><%--조회--%>">
                                                                <i class="icon-svg-search"></i>
                                                            </button>
                                                        </div>
                                                    </div>

                                                    <div class="table-height-scroll">
                                                        <table class="table-type2">
                                                            <colgroup>
                                                                <col style="width:8%">
                                                                <col style="width:10%">
                                                                <col style="width:34%">
                                                                <col style="width:24%">
                                                                <col style="width:24%">
                                                            </colgroup>
                                                            <thead>
                                                            <tr>
                                                                <th>
                                                                    <span class="custom-input onlychk">
                                                                        <input type="checkbox" id="stg0">
                                                                        <label for="stg0"></label>
                                                                    </span>
                                                                </th>
                                                                <th><spring:message code='common.number.no'/></th><!-- NO. -->
                                                                <th><spring:message code='asmt.label.dept.nm'/><%--학과--%></th><!-- 학과 -->
                                                                <th><spring:message code='asmt.label.stdnt_no'/><%--학번--%></th><!-- 학번 -->
                                                                <th><spring:message code='asmt.label.user_nm'/><%--이름--%></th><!-- 이름 -->
                                                            </tr>
                                                            </thead>
                                                            <tbody id="sindvAsmtList"></tbody>
                                                        </table>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>
                                    </td>
                                </tr>


                                </tbody>
                            </table>
                            <div class="options_wrap">
                                <ul class="accordion">
                                    <li class="">
                                        <div class="title-wrap">
                                            <a class="title" href="#">
                                                <div class="lecture_tit">
                                                    <strong><spring:message code='asmt.label.option'/><%--옵션--%></strong>
                                                </div>
                                                <i class="arrow xi-angle-down"></i>
                                            </a>
                                        </div>

                                        <div class="cont">
                                            <div class="table-wrap">
                                                <table class="table-type5">
                                                    <colgroup>
                                                        <col class="width-15per"/>
                                                        <col/>
                                                    </colgroup>
                                                    <tbody>
                                                    <tr>
                                                        <th><label class="req"><spring:message code='asmt.label.read.allow'/><%--과제읽기 허용--%></label></th><!-- 과제읽기 허용 -->
                                                        <td>
                                                            <div class="form-inline">
                                                                <span class="custom-input">
                                                                    <input type="radio" name="sbasmtOstdOyn" id="sbasmtOstdN" value="N" ${asmtVO.sbasmtOstdOyn eq 'N' || empty asmtVO.asmtId ? 'checked' : '' }>
                                                                    <label for="sbasmtOstdN"><spring:message code='asmt.common.no'/><%--아니오--%></label>
                                                                </span>
                                                                <span class="custom-input ml5">
                                                                    <input type="radio" name="sbasmtOstdOyn" id="sbasmtOstdY" value="Y" ${asmtVO.sbasmtOstdOyn eq 'Y' ? 'checked' : '' }>
                                                                    <label for="sbasmtOstdY"><spring:message code='asmt.common.yes'/><%--예--%></label>
                                                                </span>
                                                            </div>

                                                            <div class="custom-txt mt10" id="viewSbasmtOstd">
                                                                <span class="tit"><spring:message code='asmt.label.read.allow.date'/><%--읽기 허용일--%> :</span>
                                                                <input id="ostdOpenSdttmDateSt" type="text" name="ostdOpenSdttmDateSt" class="datepicker" timeId="ostdOpenSdttmTimeSt" placeholder="<spring:message code='asmt.label.start_date'/><%--시작일--%>">
                                                                <input id="ostdOpenSdttmTimeSt" type="text" name="ostdOpenSdttmTimeSt" class="timepicker" dateId="ostdOpenSdttmDateSt" placeholder="<spring:message code='asmt.label.start.time'/><%--시작시간--%>">
                                                                <small class="note3">! <spring:message code='asmt.alert.input.submit.stu.read.set'/><%--제출 과제 학습자 간에 읽을 수 있도록 설정--%> </small>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </li>
                                </ul>
                            </div>

                        </form>
                        <div class="btns">
                            <button type="button" class="btn type1" id="btnSave"><spring:message code='asmt.button.save'/><%--저장--%></button>
                            <c:if test="${mode ne 'E'}">
                                <button type="button" class="btn type2" id="btnCopy"><spring:message code='asmt.button.asmt.prev'/><%--이전 과제 가져오기--%></button>
                            </c:if>
                            <button type="button" class="btn type2" id="btnGoList"><spring:message code='asmt.button.list'/><%--목록--%></button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>


</body>
</html>
