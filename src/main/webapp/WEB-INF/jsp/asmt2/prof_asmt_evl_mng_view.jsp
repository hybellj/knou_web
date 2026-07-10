<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/asmt2/common/asmt_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="module" value="table,editor,fileuploader,chart"/>
        <jsp:param name="style" value="classroom"/>
    </jsp:include>

    <script type="text/javascript">

        const ASMT_ID = '<c:out value="${asmtVO.asmtId}" />';
        const SBJCT_ID = '<c:out value="${asmtVO.sbjctId}" />';
        const RUBRIC_ID = '<c:out value="${asmtVO.rubricId}" />';
        const IS_TEAM_ASMT = "${asmtVO.teamAsmtStngyn}" === "Y";
        const IS_PRCTC_ASMT = "${asmtVO.asmtPrctcyn}" === "Y";
        const SBMSN_FILE_MIME_TYCD = '<c:out value="${asmtVO.sbmsnFileMimeTycd}" />';
        let EPARAM = '<c:out value="${encParams}" />';
        let dialog;

        $(document).ready(function () {
            initPage();
            bindEvents();
        });

        function initPage() {
            getAsmtEvlList();
            appendTeamLeaderOptions();
            $("#scoreBatch").trigger("click");
        }

        function bindEvents() {
            bindSearchEvents();
            bindScoreBatchToggleEvent();
            bindInlineScoreEvents();
        }

        function bindSearchEvents() {

            $("#searchValue").on("keyup", function (e) {
                if (e.keyCode == 13) {
                    getAsmtEvlList();
                }
            });

        }

        function bindScoreBatchToggleEvent() {
            // 일괄 성적처리 아이콘 변경
            $('#scr-toggle-icon').click(function () {
                $(this).children("i").toggleClass("xi-plus xi-minus");
            });
        }

        function bindInlineScoreEvents() {
            /**
             * 점수 input 변경
             */
            $(document).on("click", ".scrTextDiv", function (e) {
                const $text = $(this);
                const $wrap = $text.closest(".tabulator-cell");

                $text.hide();
                $wrap.find(".scrInputDiv").show();

                //UiInputmask();
                $wrap.find(".scrInput").focus().select();
            });

            $(document).on("blur", ".scrInput", function () {
                const $input = $(this);
                const $cell = $input.closest(".tabulator-cell");
                const $inputDiv = $cell.find(".scrInputDiv");
                const $textDiv = $cell.find(".scrTextDiv");

                const asmtId = $input.attr("data-asmtId");
                const asmtSbmsnId = $input.attr("data-asmtSbmsnId") || null;
                const asmtEvlId = $input.attr("data-asmtEvlId") || null;
                const userId = $input.attr("data-userId");
                const teamId = $input.attr("data-teamId") || null;
                const sbmsnStscd = $input.attr("data-sbmsnStscd") || null;

                const newScr = $.trim($input.val());
                const oldScrText = $.trim($textDiv.text());
                const oldScr = oldScrText === "-" ? "" : oldScrText;

                if (newScr === oldScr) {
                    $inputDiv.hide();
                    $textDiv.show();
                    return;
                }

                if (newScr === "" || isNaN(newScr)) {
                    UiComm.showMessage("<spring:message code='asmt.alert.score.input_num'/><%--점수는 숫자만 입력할 수 있습니다.--%>", "error");
                    $input.val(oldScr);
                    $inputDiv.hide();
                    $textDiv.show();
                    return;
                }

                if (Number(newScr) < 0 || Number(newScr) > 100) {
                    UiComm.showMessage("<spring:message code='asmt.alert.score.max_100'/><%--점수는 100점까지 입력 가능합니다.--%>", "error");
                    $input.val(oldScr);
                    $inputDiv.hide();
                    $textDiv.show();
                    return;
                }

                const param = {
                    asmtId: asmtId
                    , asmtSbmsnId: asmtSbmsnId
                    , userId: userId
                    , teamId: teamId
                    , asmtEvlId: asmtEvlId
                    , sbmsnStscd: sbmsnStscd
                    , scr: Number(newScr)
                };

                $input.prop("disabled", true);
                ajaxCall("/asmt2/profAsmtEvlScrModifyAjax.do", param, function (data) {
                    if (data.encParams != null && data.encParams != '') {
                        EPARAM = data.encParams;
                    }
                    if (data.result > 0) {
                        getAsmtEvlList();
                    } else {
                        UiComm.showMessage(data.message, "error");
                        $input.val(oldScr);
                    }

                    $input.prop("disabled", false);
                    $inputDiv.hide();
                    $textDiv.show();
                }, function () {
                    UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
                    $input.val(oldScr);

                    $input.prop("disabled", false);
                    $inputDiv.hide();
                    $textDiv.show();
                }, true);

            });

        }

        /**
         * 재제출 관리 팝업
         */
        function resbmsnPop() {

            const extData = {
                "asmtId": ASMT_ID,
                "sbjctId": SBJCT_ID
            };

            dialog = UiDialog("resbmsnDialog1", {
                title: "<spring:message code='asmt.label.resubmit.manage'/><%--재제출 관리--%>",
                width: 1200,
                height: 650,
                url: "/asmt2/profAsmtResbmsnPopup.do?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams(extData),
                autoresize: true
            });
        }

        /**
         * 과제 평가 목록 가져오기
         */
        function getAsmtEvlList() {

            const url = "/asmt2/profAsmtEvlListAjax.do";
            const extData = {
                "asmtId": ASMT_ID,
                "teamId": $("#teamId").val() || "",
                "sbmsnStscd": $("#sbmsnStscd").val(),
                "evlYn": $("#evlYn").val(),
                "searchValue": $("#searchValue").val(),
                "searchType": "LIST"
            };

            const param = {
                encParams: EPARAM
                , addParams: UiComm.makeEncParams(extData)
            };

            ajaxCall(url, param, function (data) {
                if (data.encParams != null && data.encParams != '') {
                    EPARAM = data.encParams;
                }
                if (data.result > 0) {
                    const returnList = data.returnList || [];
                    const dataList = buildAsmtEvlListHtml(returnList);

                    asmtEvlListTable.clearData();
                    asmtEvlListTable.replaceData(dataList);

                    UiInputmask();

                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }, function () {
                UiComm.showMessage("<spring:message code='asmt.alert.eval.list.error'/><%--과제 평가 목록 조회 중 오류가 발생했습니다.--%>", "error");
            }, true);
        }

        /**
         * 과제 평가 목록 HTML 생성
         * @param returnList
         * @returns {*[]}
         */
        function buildAsmtEvlListHtml(returnList) {
            let dataList = [];
            if (returnList.length == 0) {
                return dataList;
            }

            returnList.forEach(function (v) {
                dataList.push(buildAsmtEvlRow(v));
            });

            return dataList;
        }

        /**
         * 과제 평가 목록 행 생성
         * @param v
         * @returns {{}}
         */
        function buildAsmtEvlRow(v) {
            const sbmsnSdttmHtml = v.sbmsnStscd === "NON_SBMSN" || !v.sbmsnDttm ? "-" : UiComm.formatDate(v.sbmsnDttm, "datetime2");

            return {
                no: v.lineNo,
                sbmsnThumbHtml: createSbmsnThumbHtml(v),
                deptnm: v.deptnm,
                userIdHtml: createUserIdHtml(v),
                stdntNo: v.stdntNo,
                usernm: v.usernm,
                scr: createScrHtml(v),
                maxMosartHtml: v.evlyn === "N" ? "-" : v.maxMosart,
                fdbkHtml: createFdbkHtml(v),
                prevSbmsnHtml: createPrevSbmsnHtml(v),
                sbmsnStsnm: v.sbmsnStsnm,
                sbmsnSdttm: sbmsnSdttmHtml,
                evlyn: v.evlyn,
                mng: createMngHtml(v),
                ldryn: v.ldryn === "Y" ? "<spring:message code='asmt.label.team.leader'/><%--팀장--%>" : "<spring:message code='asmt.label.team.member'/><%--팀원--%>",
                teamnm: v.teamnm,
                teamId: v.teamId,
                userId: v.userId,
                asmtId: v.asmtId,
                asmtSbmsnId: v.asmtSbmsnId,
                sbmsnStscd: v.sbmsnStscd,
                asmtEvlId: v.asmtEvlId,
            };
        }

        /**
         * 대표 아이디 표시 HTML 생성
         * @param v
         * @returns {string}
         */
        function createSbmsnThumbHtml(v) {
            if (!IS_PRCTC_ASMT) {
                return "-";
            }

            const fileList = v.fileList || [];
            const file = fileList[0] || {};
            const filenm = file.fileNm || file.filenm || "";
            const ext = (file.fileExt || "").toLowerCase();
            const isImage = ["png", "gif", "jpg", "jpeg"].includes(ext);
            const iconBasePath = "/webdoc/assets/img/common/";
            const placeholderPath = iconBasePath + "image_placeholder_300x300.png";
            let thumbPath = placeholderPath;

            function createThumbButton(src) {
                return "<button type='button' class='btn p0' style='border:0;background:transparent;' onclick='ezGraderPop(\"" + v.asmtId + "\", \"" + v.userId + "\")'>"
                    + "<div class='thumb'>"
                    + "<img src='" + src + "' aria-hidden='true' alt='<spring:message code='asmt.label.photo'/><%--사진--%>'>"
                    + "</div>"
                    + "</button>";
            }

            if (!filenm) {
                return createThumbButton(placeholderPath);
            }

            // 이미지 파일은 실제 파일/썸네일을 우선 사용하고, 문서 파일은 AS-IS와 동일한 대표 아이콘을 사용한다.
            if (isImage) {
                thumbPath = file.thumbView || iconBasePath + "thumb_img.png";
            } else if (ext === "pdf") {
                thumbPath = iconBasePath + "thumb_pdf2.png";
            } else if (["ppt", "pptx"].includes(ext)) {
                thumbPath = iconBasePath + "thumb_ppt.png";
            } else {
                thumbPath = iconBasePath + "thumb_unknown.png";
            }

            // 썸네일 클릭 시 해당 학습자의 제출정보를 EZ-Grader에서 확인한다.
            return createThumbButton(thumbPath);
        }

        function createUserIdHtml(v) {
            const isExln = v.exlnAsmtyn === "Y";
            const isTeam = v.teamAsmtStngyn === "Y";
            const isTeamIndiv = v.tmbrIndivSbmsnPrmyn === "Y";
            const isLeader = v.ldryn === "Y";
            const showExlnIcon = IS_PRCTC_ASMT && isExln && (!isTeam || isTeamIndiv || isLeader);
            return v.userId + (showExlnIcon ? "<i class='xi-trophy icon ml5'></i>" : "");
        }

        /**
         * 피드백 아이콘 HTML 생성
         * @param v
         * @returns {string}
         */
        function createFdbkHtml(v) {
            return "<i class='xi-comment-o icon cursor-pointer " + (v.fdbkCnt && v.fdbkCnt > 0 ? "on" : "") + "' onclick='fdbkPopup(\"" + v.asmtId + "\", \"" + v.userId + "\", this)'></i>";
        }

        /**
         * 이전 제출 아이콘 HTML 생성
         * @param v
         * @returns {string}
         */
        function createPrevSbmsnHtml(v) {
            return "<i class='xi-file-o icon cursor-pointer" + (v.asmtSbmsnId == null || v.asmtSbmsnId == "" ? "" : "on") + "' onclick='prevAsmtSbmsnPop(\"" + v.asmtId + "\", \"" + v.userId + "\", this)'></i>";
        }

        /**
         * 관리 버튼 HTML 생성
         * @param v
         * @returns {string}
         */
        function createMngHtml(v) {
            let mngHtml = "";
            mngHtml += "<button onclick='ezGraderPop(\"" + v.asmtId + "\", \"" + v.userId + "\")' class='btn basic small'><spring:message code='asmt.label.submit.info'/><%--제출정보--%></button>";
            mngHtml += "<button onclick='memoPopup(\"" + v.asmtId + "\", \"" + v.userId + "\")' class='btn basic small'><spring:message code='asmt.label.memo'/><%--메모--%></button>";
            if (IS_PRCTC_ASMT && v.exlnAsmtyn === "Y") {
                mngHtml += "<button onclick='cancleSbmsnBest(\"" + v.asmtId + "\", \"" + v.userId + "\")' class='btn basic small'><spring:message code='asmt.button.excellent.asmt.cancel'/><%--우수과제 취소--%></button>";
            }
            return mngHtml;
        }

        /**
         * 과제 평가 목록 컬럼 생성
         * @returns {*[]}
         */
        function buildAsmtEvlColumns() {
            const columns = [
                {title: "No", field: "no", headerHozAlign: "center", hozAlign: "center", width: 40, minWidth: 40}
            ];

            if (IS_PRCTC_ASMT) {
                columns.push({title: "<spring:message code='asmt.label.submitted.work'/><%--제출과제--%>", field: "sbmsnThumbHtml", headerHozAlign: "center", hozAlign: "center", width: 80, minWidth: 80});
            }

            if (IS_TEAM_ASMT) {
                columns.push({title: "<spring:message code='asmt.label.team.name'/><%--팀명--%>", field: "teamnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 80});
            }

            columns.push(
                {title: "<spring:message code='asmt.label.dept.nm'/><%--학과--%>", field: "deptnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 130},
                {title: "<spring:message code='asmt.label.rprs.id'/><%--대표아이디--%>", field: "userIdHtml", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 140},
                {title: "<spring:message code='asmt.label.stdnt_no'/><%--학번--%>", field: "stdntNo", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 100},
                {title: "<spring:message code='asmt.label.user_nm'/><%--이름--%>", field: "usernm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 100}
            );

            if (IS_TEAM_ASMT) {
                columns.push({title: "<spring:message code='asmt.label.role'/><%--역할--%>", field: "ldryn", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 80});
            }

            columns.push(
                {title: "<spring:message code='asmt.label.eval.score'/><%--평가점수--%>", field: "scr", headerHozAlign: "center", hozAlign: "center", width: 80, minWidth: 80},
                {title: "<spring:message code='asmt.label.plagiarism.rate'/><%--표절율--%>", field: "maxMosartHtml", headerHozAlign: "center", hozAlign: "center", width: 80, minWidth: 80},
                {title: "<spring:message code='asmt.label.feedback'/><%--피드백--%>", field: "fdbkHtml", headerHozAlign: "center", hozAlign: "center", width: 80, minWidth: 80},
                {title: "<spring:message code='asmt.label.prev.submit'/><%--이전제출--%>", field: "prevSbmsnHtml", headerHozAlign: "center", hozAlign: "center", width: 80, minWidth: 80},
                {title: "<spring:message code='asmt.label.submit.status'/><%--제출상태--%>", field: "sbmsnStsnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 150},
                {title: "<spring:message code='asmt.label.submit.dt'/><%--제출일시--%>", field: "sbmsnSdttm", headerHozAlign: "center", hozAlign: "center", width: 150, minWidth: 150},
                {title: "<spring:message code='asmt.label.eval.yn'/><%--평가여부--%>", field: "evlyn", headerHozAlign: "center", hozAlign: "center", width: 80, minWidth: 80},
                {title: "<spring:message code='asmt.label.manage'/><%--관리--%>", field: "mng", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 240}
            );

            return columns;
        }

        /**
         * 팀과제 SELECT Option 추가
         */
        function appendTeamLeaderOptions() {
            let $sbmsnStscd = $("#sbmsnStscd");

            $sbmsnStscd.find("option[value='LEADER_Y'], option[value='LEADER_N']").remove();

            if (IS_TEAM_ASMT) {
                $sbmsnStscd.append('<option value="LEADER_Y"><spring:message code='asmt.label.team.leader'/><%--팀장--%></option>');
                $sbmsnStscd.append('<option value="LEADER_N"><spring:message code='asmt.label.team.member'/><%--팀원--%></option>');
            }
        }

        /**
         * 점수 가감 아이콘 표시 변경
         * @param scoreType
         */
        function plusMinusIconControl(scoreType) {
            if (scoreType == 'batch') {
                $("#scr-toggle-icon").hide();
            } else if (scoreType == 'addition') {
                $("#scr-toggle-icon").show();
            }
        }

        /**
         * 수강생 전체 버튼 클릭
         * - 검색 초기화
         */
        function searchAll() {
            $("#sbmsnStscd").val('all').trigger('chosen:updated');
            $("#evlYn").val('all').trigger("chosen:updated");
            $("#teamId").val('all').trigger("chosen:updated");
            $("#searchValue").val("");
            getAsmtEvlList();
        }

        /**
         * 엑셀 성적등록 팝업
         */
        function setExcel() {
            const data = "asmtId=" + ASMT_ID;

            dialog = UiDialog("dialog1", {
                title: "<spring:message code='asmt.button.reg.excel.score'/><%--엑셀로 성적등록--%>",
                width: 600,
                height: 500,
                url: "/asmt2/profAsmtExcelScrRegistPopup.do?" + data,
                autoresize: true
            });
        }

        /**
         * 엑셀 다운로드
         */
        function getExcel() {
            const evlynObj = {
                Y: "<spring:message code='asmt.button.eval'/><%--평가--%>",
                N: "<spring:message code='asmt.button.no.eval'/><%--미평가--%>"
            };

            const columns = [
                {label: "No.", name: "lineNo", align: "center", width: "1000"}
            ];

            if (IS_TEAM_ASMT) {
                columns.push({label: "<spring:message code='asmt.label.team.name'/><%--팀명--%>", name: "teamnm", align: "left", width: "4000"});
            }

            columns.push(
                {label: "<spring:message code='asmt.label.dept.nm'/><%--학과--%>", name: "deptnm", align: "left", width: "5000"},
                {label: "<spring:message code='asmt.label.rprs.id'/><%--대표아이디--%>", name: "userId", align: "left", width: "5000"},
                {label: "<spring:message code='asmt.label.stdnt_no'/><%--학번--%>", name: "stdntNo", align: "center", width: "5000"},
                {label: "<spring:message code='asmt.label.user_nm'/><%--이름--%>", name: "usernm", align: "center", width: "5000"}
            );

            if (IS_TEAM_ASMT) {
                columns.push({label: "<spring:message code='asmt.label.role'/><%--역할--%>", name: "memberRole", align: "center", width: "3000"});
            }

            columns.push(
                {label: "<spring:message code='asmt.label.eval.score'/><%--평가점수--%>", name: "scr", align: "center", width: "3000"},
                {label: "<spring:message code='asmt.label.plagiarism.rate'/><%--표절율--%>", name: "maxMosart", align: "center", width: "3000"},
                {label: "<spring:message code='asmt.label.feedback.count'/><%--피드백수--%>", name: "fdbkCnt", align: "center", width: "3000"},
                {label: "<spring:message code='asmt.label.submit.status'/><%--제출상태--%>", name: "sbmsnStsnm", align: "center", width: "5000"},
                {
                    label: "<spring:message code='asmt.label.submit.dt'/><%--제출일시--%>",
                    name: "sbmsnDttm",
                    align: "center",
                    width: "5000",
                    formatter: "date",
                    formatOptions: {srcformat: "yyyyMMddHHmmss", newformat: "yyyy.MM.dd HH:mm:ss", defaultValue: "-"}
                },
                {label: "<spring:message code='asmt.label.eval.yn'/><%--평가여부--%>", name: "evlyn", align: "center", width: "3000", codes: evlynObj},
                /*{label: "평가메모", name: "evlMemo", align: "left", width: "8000"}*/
            );

            const teamId = $("#teamId").val();
            const kvArr = [
                {key: "asmtId", val: ASMT_ID},
                {key: "teamId", val: teamId === "all" ? "" : (teamId || "")},
                {key: "sbmsnStscd", val: $("#sbmsnStscd").val()},
                {key: "evlYn", val: $("#evlYn").val()},
                {key: "searchValue", val: $("#searchValue").val()},
                {key: "excelGrid", val: JSON.stringify({colModel: columns})}
            ];

            submitForm("/asmt2/profAsmtEvlListExcelDown.do", "", kvArr);
        }

        /**
         * 제출과제 다운로드
         */
        function selFileDownload() {
            const selectedRows = asmtEvlListTable.getSelectedRows();

            if (selectedRows.length < 1) {
                UiComm.showMessage("<spring:message code='asmt.alert.select.std'/><%--학습자를 선택해주시기 바랍니다.--%>", "info");
                return false;
            }

            const userIdList = [];
            const sbmsnIdList = [];

            for (let i = 0; i < selectedRows.length; i++) {
                const row = selectedRows[i].getData();
                userIdList.push(row.userId);

                if (row.asmtSbmsnId != null && row.asmtSbmsnId !== "") {
                    sbmsnIdList.push(row.asmtSbmsnId);
                }
            }

            if (sbmsnIdList.length < 1) {
                UiComm.showMessage("<spring:message code='asmt.message.not.submission.select.std'/><%--과제 미제출 학습자를 선택하셨습니다.--%>", "error");
                return false;
            }

            const form = $("<form></form>");
            form.attr("method", "POST");
            form.attr("name", "zipDownForm");
            form.attr("action", "/asmt2/profAsmtFileDwld.do");
            form.append($("<input/>", {type: "hidden", name: "asmtId", value: ASMT_ID}));
            form.append($("<input/>", {type: "hidden", name: "userIds", value: userIdList.join(",")}));
            form.append($("<input/>", {type: "hidden", name: "asmtSbmsnIds", value: sbmsnIdList.join(",")}));
            form.appendTo("body");
            form.submit();

            $("form[name=zipDownForm]").remove();
        }

        function createScrHtml(v) {

            const scrVal = (v.evlyn === "N" || v.scr == null || v.scr === "") ? "" : v.scr;

            let scrHtml = "";
            scrHtml += "<span class='scrInputDiv ui input' style='display:none'>";
            scrHtml += "    <input type='text'"
                + " class='scrInput w70'"
                + " data-asmtId='" + v.asmtId + "'"
                + " data-asmtEvlId='" + (v.asmtEvlId || "") + "'"
                + " data-asmtSbmsnId='" + (v.asmtSbmsnId || "") + "'"
                + " data-sbmsnStscd='" + (v.sbmsnStscd || "") + "'"
                + " data-userId='" + v.userId + "'"
                + " data-teamId='" + (v.teamId || "") + "'"
                + " value='" + scrVal + "'"
                + " inputmask='numeric'"
                + " mask='999.9'"
                + " maxVal='100'"
                + " />";

            scrHtml += "</span>";
            scrHtml += "<span class='scrTextDiv'>" + (scrVal === "" ? "-" : scrVal) + "</span>";

            return scrHtml;
        }

        /**
         * 일괄 성적 저장
         */
        function submitScoreBatch() {
            let validator = UiValidator("scoreForm");
            validator.then(function (result) {
                if (result) {
                    const selectedRows = asmtEvlListTable.getSelectedRows();
                    if (selectedRows.length == 0) {
                        UiComm.showMessage("<spring:message code='asmt.alert.select.batch.score.user'/><%--일괄 성적처리할 학습자를 선택해주세요.--%>", "info");
                        return;
                    }

                    const scoreType = $("input[name='scoreType']:checked").val();
                    let score = $("#scoreValue").val();
                    if (scoreType == "addition") {
                        if (!$("#scr-toggle-icon").children("i").attr("class").includes("xi-plus")) {
                            score = score * (-1);
                        }
                    }

                    let scrList = [];	// 점수 목록

                    for (let i = 0; i < selectedRows.length; i++) {
                        const row = selectedRows[i].getData();
                        const scr = {
                            asmtId: row.asmtId,
                            asmtSbmsnId: row.asmtSbmsnId,
                            asmtEvlId: row.asmtEvlId || null,
                            sbmsnStscd: row.sbmsnStscd,
                            userId: row.userId,
                            teamId: row.teamId,
                            scr: score,
                            scoreType: scoreType
                        };
                        scrList.push(scr);
                    }

                    $.ajax({
                        url: "/asmt2/profAsmtEvlScrBulkModifyAjax.do",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify(scrList),
                        dataType: "json",
                        beforeSend: function () {
                            UiComm.showLoading(true);
                        },
                        success: function (data) {
                            if (data.encParams != null && data.encParams != '') {
                                EPARAM = data.encParams;
                            }
                            if (data.result > 0) {
                                UiComm.showMessage("<spring:message code='asmt.alert.batch.score.save.success'/><%--일괄 점수 등록이 완료되었습니다.--%>", "success");
                                $("#scoreValue").val("");
                                getAsmtEvlList();
                            } else {
                                UiComm.showMessage(data.message, "error");
                            }
                            UiComm.showLoading(false);
                        },
                        error: function (xhr, status, error) {
                            UiComm.showMessage("<spring:message code='asmt.alert.batch.score.save.error'/><%--일괄 점수 등록 중 에러가 발생하였습니다.--%>", "error");
                        },
                        complete: function () {
                            UiComm.showLoading(false);
                        },
                    });

                }
            });
        }

        /*
         * ========피드백=========
         */
        /**
         * 피드백 저장 확인
         */
        function fdbkSaveConfirm() {
            let validator = UiValidator("fdbkForm");
            validator.then(function (result) {
                if (result) {
                    if (asmtEvlListTable.getSelectedRows().length == 0) {
                        UiComm.showMessage("<spring:message code='asmt.alert.select.batch.feedback.user'/><%--일괄 피드백할 학습자를 선택해주세요.--%>", "info");
                        return;
                    }

                    let dx = dx5.get("fileUploader");
                    // 첨부파일 있으면 업로드
                    if (dx.availUpload()) {
                        dx.startUpload();
                    }
                    // 첨부파일 없으면 저장 호출
                    else {
                        fdbkRegist();
                    }
                }
            });
        }

        /**
         * 파일 업로드 완료 처리
         */
        function finishUpload() {
            let url = "/common/uploadFileCheck.do"; // 업로드된 파일 검증 URL
            let dx = dx5.get("fileUploader");
            let param = {
                "uploadFiles": dx.getUploadFiles(),
                "uploadPath": dx.getUploadPath()
            };

            // 업로드된 파일 체크
            ajaxCall(url, param, function (data) {
                if (data.encParams != null && data.encParams != '') {
                    EPARAM = data.encParams;
                }
                if (data.result > 0) {
                    $("#uploadFiles").val(dx.getUploadFiles());
                    fdbkRegist();

                } else {
                    UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
                }
            }, function (xhr, status, error) {
                UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
            }, true);
        }

        /**
         * 피드백 등록
         */
        function fdbkRegist() {
            const fdbkUsers = [];	// 사용자 목록
            const selectedRows = asmtEvlListTable.getSelectedRows();

            for (let i = 0; i < selectedRows.length; i++) {
                const row = selectedRows[i].getData();
                fdbkUsers.push({
                    userId: row.userId,	// 사용자아이디
                    teamId: row.teamId, // 팀아이디
                    asmtId: row.asmtId // 과제아이디
                });
            }

            $("#fdbkUsers").val(JSON.stringify(fdbkUsers));

            UiComm.showLoading(true);
            let dx = dx5.get("fileUploader");

            $.ajax({
                url: "/asmt2/asmtFdbkRegistAjax.do",
                async: false,
                type: "POST",
                dataType: "json",
                data: $("#fdbkForm").serialize(),
            }).done(function (data) {
                UiComm.showLoading(false);
                if (data.encParams != null && data.encParams != '') {
                    EPARAM = data.encParams;
                }
                if (data.result > 0) {
                    UiComm.showMessage("<spring:message code='asmt.alert.reg_success.feedback'/><%--피드백 등록이 완료되었습니다.--%>", "success")
                    .then(function (result) {
                        dx.removeAll();
                        $("#fdbkForm textarea[name=fdbkCts]").val("");
                        getAsmtEvlList();
                    });
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }).fail(function () {
                UiComm.showLoading(false);
                UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");	/* 에러가 발생했습니다! */
            });
        }


        /**
         * 피드백 팝업
         * @param asmtId
         * @param userId
         * @param obj
         */
        function fdbkPopup(asmtId, userId, obj) {
            // 선택된 피드백의 아이콘 색상 초기화 및 변경
            if ($(".xi-comment-o").parents().hasClass("focused")) {
                $(".xi-comment-o").parents().removeClass("focused");
            }
            $(obj).parents().addClass("focused");

            const param = "asmtId=" + asmtId + "&userId=" + userId;
            dialog = UiDialog("dialog1", {
                title: "<spring:message code='asmt.label.feedback'/><%--피드백--%>",
                width: 1000,
                height: 350,
                url: "/asmt2/profAsmtFdbkPopup.do?" + param + "&encParams=" + EPARAM,
                autoresize: true
            });
        }

        /**
         * 메모 팝업
         * @param asmtId
         * @param userId
         */
        function memoPopup(asmtId, userId) {
            const data = "asmtId=" + asmtId + "&userId=" + userId;
            dialog = UiDialog("dialog1", {
                title: "<spring:message code='asmt.label.memo'/><%--메모--%>",
                width: 800,
                height: 300,
                url: "/asmt2/profAsmtMemoPopup.do?" + data + "&encParams=" + EPARAM,
                autoresize: true
            });
        }

        /**
         * 이전과제제출목록 팝업
         * @param userId
         */
        function prevAsmtSbmsnPop(asmtId, userId) {

            const data = "sbjctId=" + SBJCT_ID + "&asmtId=" + asmtId + "&userId=" + userId;
            dialog = UiDialog("dialog1", {
                title: "<spring:message code='asmt.label.prev.asmt.submit.list'/><%--이전 과제 제출 목록--%>",
                width: 1000,
                height: 300,
                url: "/asmt2/profAsmtPrevSbmsnListPopup.do?" + data + "&encParams=" + EPARAM,
                autoresize: true
            });
        }


        /**
         * 우수과제 선정
         */
        function sbmsnBest() {
            if (!IS_PRCTC_ASMT) {
                UiComm.showMessage("<spring:message code='asmt.alert.excellent.asmt.practice.only'/><%--우수과제 선정은 실기과제만 가능합니다.--%>", "info");
                return false;
            }

            let exlnList = [];

            const selectedRows = asmtEvlListTable.getSelectedRows();

            if (selectedRows.length < 1) {
                UiComm.showMessage("<spring:message code='asmt.alert.select.std'/><%--학습자를 선택해주시기 바랍니다.--%>");
                return false;
            }

            for (let i = 0; i < selectedRows.length; i++) {
                const row = selectedRows[i].getData();

                if (!row.asmtSbmsnId) {
                    UiComm.showMessage("<spring:message code='asmt.message.not.submission.select.std'/><%--과제 미제출 학습자를 선택하셨습니다.--%>", "error"); /* 과제 미제출 학습자를 선택하셨습니다. */
                    return;
                }

                exlnList.push({
                    asmtId: row.asmtId,
                    userId: row.userId,
                    asmtSbmsnId: row.asmtSbmsnId,
                    asmtEvlId: row.asmtEvlId,
                    exlnAsmtyn: "Y"
                });
            }

            $.ajax({
                url: "/asmt2/profAsmtExlnBulkModifyAjax.do",
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(exlnList),
                dataType: "json",
                beforeSend: function () {
                    UiComm.showLoading(true);
                },
                success: function (data) {
                    if (data.encParams != null && data.encParams != '') {
                        EPARAM = data.encParams;
                    }
                    if (data.result > 0) {
                        UiComm.showMessage("<spring:message code='asmt.alert.excellent.asmt.complete'/><%--우수과제 선정이 완료되었습니다.--%>", "success");
                        getAsmtEvlList();
                    } else {
                        UiComm.showMessage(data.message, "error");
                    }
                    UiComm.showLoading(false);
                },
                error: function (xhr, status, error) {
                    UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");
                },
                complete: function () {
                    UiComm.showLoading(false);
                },
            });

        }

        /**
         * 우수과제 취소
         * @param asmtId
         * @param userId
         */
        function cancleSbmsnBest(asmtId, userId) {
            const param = {
                asmtId: asmtId,
                userId: userId,
                exlnAsmtyn: 'N'
            };

            ajaxCall("/asmt2/profAsmtExlnModifyAjax.do", param, function (data) {
                if (data.encParams != null && data.encParams != '') {
                    EPARAM = data.encParams;
                }
                if (data.result > 0) {
                    UiComm.showMessage("<spring:message code='asmt.alert.no.excellent.asmt.complete'/><%--우수과제 선정이 취소되었습니다.--%>", "success");/* 우수과제 선정이 취소 되었습니다. */
                    getAsmtEvlList();
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }, function () {
                UiComm.showMessage("<spring:message code='asmt.alert.process.error'/><%--처리 중 오류가 발생했습니다.--%>", "error");
            }, true);
        }


        /**
         * 과제 삭제
         */
        function deleteAsmt() {
            let confirmMessage = "";
            if (Number("${asmtVO.sbmsnCnt}") > 0) {
                // 학습중인 수강생이 있습니다. 삭제할 경우 수강생의 학습정보가 삭제됩니다.
                // 정말 삭제 하시겠습니까?
                confirmMessage = "<spring:message code='asmt.message.presenter.del.learners'/><%--학습중인 수강생이 있습니다. 삭제할 경우 수강생의 학습정보가 삭제됩니다.--%> \r\n <spring:message code='asmt.message.presenter.del2'/><%--정말 삭제 하시겠습니까?--%>";
            } else {
                // 학습중인 수강생이 없습니다.
                // 정말 삭제 하시겠습니까?
                confirmMessage = "<spring:message code='asmt.message.presenter.del.no.learners'/><%--학습중인 수강생이 없습니다.--%> \r\n <spring:message code='asmt.message.presenter.del2'/><%--정말 삭제 하시겠습니까?--%>";
            }

            UiComm.showMessage(confirmMessage, "confirm")
            .then(function (result) {
                if (result) {
                    const extData = {
                        "asmtId": ASMT_ID,
                        "sbjctId": SBJCT_ID,
                        "asmtGbncd": '<c:out value="${asmtVO.asmtGbncd}" />'
                    };

                    const url = "/asmt2/profAsmtDeleteAjax.do";
                    const param = {
                        encParams: EPARAM
                        , addParams: UiComm.makeEncParams(extData)
                    };

                    ajaxCall(url, param, function (data) {
                        if (data.encParams != null && data.encParams != '') {
                            EPARAM = data.encParams;
                        }
                        if (data.result > 0) {
                            /* 정상적으로 삭제되었습니다. */
                            UiComm.showMessage("<spring:message code='success.common.delete'/>", "success");
                            moveAsmtList();
                        } else {
                            UiComm.showMessage(data.message, "error");
                        }
                    }, function (xhr, status, error) {
                        /* 삭제 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
                        UiComm.showMessage("<spring:message code='seminar.error.delete' />", "error");
                    }, true);
                }
            });
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
                userId: "",
                teamId: ""
            };
            const kvArr = [];
            kvArr.push({'key': 'encParams', 'val': EPARAM});
            kvArr.push({'key': 'addParams', 'val': UiComm.makeEncParams(extData)});
            submitForm("/asmt2/profAsmtListView.do", "", kvArr);
        }

        /**
         * 팝업 dialog 닫기 (window.parent.closeDialog()로 호출됨)
         */
        function closeDialog() {
            if (dialog) {
                dialog.close();
            }
        }

        /**
         * 과제 수정화면 이동
         * @param asmtId
         */
        function moveAsmtModifyView() {
            const extData = {
                sbjctId: SBJCT_ID,
                asmtId: ASMT_ID
            };
            const kvArr = [];
            kvArr.push({'key': 'encParams', 'val': EPARAM});
            kvArr.push({'key': 'addParams', 'val': UiComm.makeEncParams(extData)});

            submitForm("/asmt2/profAsmtModifyView.do", "", kvArr);
        }

        /**
         * 이지그레이더 팝업
         */
        function ezGraderPop(asmtId, userId) {
            const extData = {
                "asmtId": asmtId || ASMT_ID,
                "userId": userId || ""
            };

            dialog = UiDialog("dialog1", {
                title: "EZ-Grader",
                url: "/asmt2/profAsmtEzGraderPopup.do?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams(extData),
                titlebar: false,
                fullscreen: true
            });

            // 화면 상단부터 열리도록 다이얼로그 외곽 위치를 고정한다.
            setTimeout(function () {
                dialog.dialog("option", "position", {my: "left top", at: "left top", of: window});
                dialog.dialog("widget").css({position: "fixed", top: 0, left: 0});
            }, 0);

        }

        /**
         * =========================================================
         * 루브릭 팝업
         * =========================================================
         */
        function rubricPop() {
            if (!RUBRIC_ID) {
                UiComm.showMessage("<spring:message code='asmt.alert.evalCd.del'/><%--평가방법에서 루브릭을 선택 후 루브릭을 등록해 주세요.--%>", "error");
                return false;
            }

            dialog = UiDialog("asmtRubricWritePop", {
                title: "<spring:message code='asmt.label.rubric.view'/><%--루브릭 조회--%>",
                width: 1000,
                height: 600,
                url: "/asmt2/profAsmtRubricWritePopup.do?sbjctId=" + SBJCT_ID
                    + "&rubricId=" + RUBRIC_ID
                    + "&readOnlyYn=Y",
                autoresize: false,
            });
        }
    </script>
</head>

<body class="class ${uiex:getTheme()} ${bodyClass}"><!-- 컬러선택시 클래스변경 -->
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
                        <h2 class="page-title"><spring:message code='asmt.label.asmt'/><%--과제--%></h2><%--과제--%>
                    </div>


                    <div class="board_top">
                        <h3 class="board-title"><spring:message code='asmt.label.asmt.info.eval'/><%--과제정보 및 평가--%></h3>
                        <div class="right-area">
                            <%--과제제출 && 연장제출 기간 이후 && 대체과제 아닐 때 활성화--%>
                            <c:if test="${asmtVO.resbmsnMngyn eq 'Y' and not fn:contains(asmtVO.asmtGbncd, 'SBST')}">
                                <button type="button" class="btn type1 big" onclick="resbmsnPop()"><spring:message code='asmt.label.resubmit.manage'/><!-- 재제출 관리 --><!-- 수정 --></button>
                            </c:if>
                            <button type="button" class="btn type1 big" onclick="moveAsmtModifyView()"><spring:message code='asmt.button.mod'/><!-- 수정 --></button>
                            <button type="button" class="btn type2 big" onclick="deleteAsmt()"><spring:message code='asmt.button.del'/><!-- 삭제 --></button>
                            <button type="button" class="btn type2 big" onclick="moveAsmtList()"><spring:message code='asmt.button.list'/><!-- 목록 --></button>
                        </div>
                    </div>

                    <%--과제 정보--%>
                    <jsp:include page="/WEB-INF/jsp/asmt2/asmt_info_view.jsp"/>
                    <%--과제 정보--%>

                    <div class="board_top mb0">
                        <h4 class="sub-title"><spring:message code='asmt.label.asmt.eval'/><%--과제평가--%></h4>
                        <div class="right-area">
                            <button type="button" class="btn type2" onclick="ezGraderPop()">EZ-Grader</button>
                            <button type="button" class="btn type2" onclick="setExcel()"><spring:message code='asmt.button.reg.excel.score'/><%--엑셀로 성적등록--%></button>
                            <button type="button" class="btn basic" onclick="sendMsg()"><spring:message code='asmt.button.message.send'/><%--메시지 보내기--%></button>
                        </div>
                    </div>
                    <div class="board_top in_table">
                        <%--제출여부--%>
                        <select class="form-select" id="sbmsnStscd" name="sbmsnStscd" onchange="getAsmtEvlList()">
                            <option value="" selected disabled hidden><spring:message code='asmt.label.submit.yn'/><%--제출여부--%></option>
                            <option value="all"><spring:message code='asmt.label.all'/><%--전체--%></option>
                            <c:forEach items="${cmmnCdList.sbmsnStscdList}" var="item">
                                <option value="${item.cd}">${item.cdnm}</option>
                            </c:forEach>
                        </select>
                        <%--평가여부--%>
                        <select class="form-select" id="evlYn" name="evlYn" onchange="getAsmtEvlList()">
                            <option value="" selected disabled hidden><spring:message code='asmt.label.eval.yn'/><%--평가여부--%></option>
                            <option value="all"><spring:message code='asmt.label.all'/><%--전체--%></option>
                            <option value="Y"><spring:message code='asmt.button.eval'/><%--평가--%></option>
                            <option value="N"><spring:message code='asmt.button.no.eval'/><%--미평가--%></option>
                        </select>
                        <c:if test="${asmtVO.teamAsmtStngyn eq 'Y'}">
                            <select class="form-select" id="teamId" name="teamId" onchange="getAsmtEvlList()">
                                <option value="" selected disabled hidden><spring:message code='asmt.label.team.select'/><%--팀선택--%></option>
                                <option value="all"><spring:message code='asmt.label.all'/><%--전체--%></option>
                            </select>
                        </c:if>
                        <!-- search small -->
                        <div class="search-typeC">
                            <input class="form-control" type="text" id="searchValue" value="" placeholder="<spring:message code='asmt.label.search.user.placeholder'/><%--학과, 학번, 이름 입력--%>">
                            <button type="button" class="btn basic icon search" aria-label="<spring:message code='asmt.label.search'/><%--검색--%>" onclick="getAsmtEvlList()"><i class="icon-svg-search"></i></button>
                        </div>
                        <button type="button" class="btn search" onclick="searchAll()"><spring:message code='asmt.label.all.student'/><%--수강생 전체--%></button>

                    </div>

                    <!--table-type-->
                    <div class="table-wrap">
                        <table class="table-type5">
                            <colgroup>
                                <col class="width-15per"/>
                                <col class=""/>
                            </colgroup>
                            <tbody>
                            <tr>
                                <th><label for="scoreInputMode"><spring:message code='asmt.label.batch.score.process'/><!-- 일괄 점수처리 --></label></th>
                                <td>
                                    <form id="scoreForm" onsubmit="return false;">
                                        <div class="form-inline">
                                        <span class="custom-input">
                                            <input type="radio" id="scoreBatch" name="scoreType" value="batch" onchange="plusMinusIconControl('batch')" required="true">
                                            <label for="scoreBatch"><spring:message code='asmt.label.score.reg'/><!-- 점수 등록 --></label>
                                        </span>
                                            <span class="custom-input ml5">
                                            <input type="radio" id="scoreAddition" name="scoreType" value="addition" onchange="plusMinusIconControl('addition')" required="true">
                                            <label for="scoreAddition"><spring:message code='asmt.label.score.plus.minus'/><!-- 점수 가감 --></label>
                                        </span>
                                            <div class="custom-txt">
                                                <span class="tit"><spring:message code='asmt.label.score'/><!-- 점수 --> :</span>
                                                <button class='btn small basic icon' id="scr-toggle-icon"><i class="xi-plus"></i></button>
                                                <div class="input_btn">
                                                    <input id="scoreValue" class="form-control sm" inputmask="numeric" mask="999.9" maxVal="100">
                                                    <label for="scoreValue"><spring:message code='asmt.label.point'/><!-- 점 --></label>
                                                </div>
                                            </div>

                                            <button type="button" class="btn type1" onclick="submitScoreBatch()"><spring:message code='asmt.button.save'/><!-- 저장 --></button>
                                        </div>
                                    </form>
                                </td>
                            </tr>
                            <tr>
                                <th><label for="bulkFeedback"><spring:message code='asmt.label.batch.feedback'/><%--일괄 피드백--%></label></th>
                                <td>
                                    <form id="fdbkForm" onsubmit="return false;">
                                        <input type="hidden" id="uploadFiles" name="uploadFiles"/>
                                        <input type="hidden" id="uploadPath" name="uploadPath" value="${asmtVO.uploadPath}"/>
                                        <input type="hidden" id="fdbkUsers" name="fdbkUsers"/>
                                        <textarea rows="2" id="fdbkCts" class="form-control width-100per" maxLenCheck="byte,4000,true,false"></textarea>
                                        <div id="uploaderBox" class="mt10 width-100per">
                                            <uiex:dextuploader
                                                    id="fileUploader"
                                                    path="${asmtVO.uploadPath}"
                                                    limitCount="3"
                                                    limitSize="100"
                                                    oneLimitSize="100"
                                                    listSize="2"
                                                    fileList=""
                                                    finishFunc="finishUpload()"
                                                    allowedTypes="*"
                                            />
                                        </div>
                                        <button type="button" class="btn type1 mt10" onclick="fdbkSaveConfirm()"><spring:message code='asmt.button.save'/><%--저장--%></button>
                                    </form>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="board_top">
                        <div class="right-area">
                            <c:if test="${asmtVO.asmtPrctcyn eq 'Y'}">
                                <button type="button" class="btn type2" onclick="sbmsnBest()"><spring:message code='asmt.label.excellent.asmt'/><%--우수과제--%> <spring:message code='asmt.label.selection'/><!-- 우수과제 선정 --></button>
                            </c:if>
                            <button type="button" class="btn type2" onclick="selFileDownload()"><spring:message code='asmt.label.submitted.work'/><%--제출과제--%> <spring:message code='asmt.label.download'/><!-- 제출과제 다운로드 --></button>
                            <button type="button" class="btn type2" onclick="getExcel()"><spring:message code='asmt.label.excel.download'/><!-- 엑셀 다운로드 --></button>
                        </div>
                    </div>


                    <div>
                        <div id="asmtEvlList"></div>
                        <script>

                            let asmtEvlListTable = UiTable("asmtEvlList", {
                                lang: "ko",
                                selectRow: "checkbox",
                                columns: buildAsmtEvlColumns()
                            });
                        </script>

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

