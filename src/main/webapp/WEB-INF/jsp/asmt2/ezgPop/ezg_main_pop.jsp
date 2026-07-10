<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/asmt2/common/asmt_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="module" value="editor,fileuploader"/>
        <jsp:param name="style" value="classroom,dashboard"/>
    </jsp:include>

    <style>
        #imgFullView {
            display: none;
            position: fixed;
            left: 0;
            top: 0;
            width: 100%;
            height: 100vh;
            z-index: 1100;
            background: #fff;
        }

        #imgFullViewBox {
            width: 100%;
            height: 100vh;
            overflow: auto;
            text-align: center;
            cursor: all-scroll;
        }

        #imgFullViewBox .item img,
        #viewData .item img {
            width: auto;
            max-width: 100%;
            height: auto;
        }

        #imgFullViewBox iframe,
        #viewData iframe.item {
            width: 100%;
            height: calc(100vh - 120px);
            min-height: 520px;
            border: 0;
        }

        #imgFullViewBox iframe {
            height: calc(100vh - 10px);
            min-height: 0;
        }

        #mainView .scrollArea {
            position: relative;
        }

        #mediaExtBtn {
            position: absolute;
            top: 15px;
            left: 15px;
            z-index: 10;
        }

        #fullMediaExtBtn {
            position: fixed;
            top: 10px;
            left: 10px;
            z-index: 1300;
        }

        .ezg-media-control-btn {
            min-width: 64px;
            height: 30px;
            padding: 0 8px;
            border: 1px solid #333;
            border-radius: 4px;
            background: #fff;
            color: #111;
            font-size: 12px;
            font-weight: 600;
            box-shadow: 0 2px 8px rgba(0, 0, 0, .25);
        }

        #imgFullView.fullpdf #fullOriginal {
            display: none;
        }

    </style>

    <script type="text/javascript">
        let EPARAM = '<c:out value="${encParams}" />';
        // 실제 저장 대상들
        let selectedEvlUsers = [];
        // 화면에 보여줄 대표 사용자
        let selectedViewUser = null;
        // 팀선택인지 개별선택인지 구분
        let selectedTargetType = ""; // USER / TEAM

        const EZG = {
            asmtId: "<c:out value='${asmtVO.asmtId}' />"
            , sbjctId: "<c:out value='${asmtVO.sbjctId}' />"
            , targetUserId: "<c:out value='${targetUserId}' />"
            , teamAsmtStngyn: "<c:out value='${asmtVO.teamAsmtStngyn}' />"
            , tmbrIndivSbmsnPrmyn: "<c:out value='${asmtVO.tmbrIndivSbmsnPrmyn}' />"
            , evlScrTycd: "<c:out value='${asmtVO.evlScrTycd}' />"
            , rubricId: "<c:out value='${asmtVO.rubricId}' />"
            , asmtPrctcyn: "<c:out value='${asmtVO.asmtPrctcyn}' />"
            , sbasmtTycd: "<c:out value='${asmtVO.sbasmtTycd}' />"
            , sbmsnFileMimeTycd: "<c:out value='${asmtVO.sbmsnFileMimeTycd}' />"
        };

        $(document).ready(function () {
            initEzGraderEvents();
            getAsmtEvlList();
        });

        /**
         * 팀전체 여부
         * @returns {boolean}
         * - true: 팀전체 선택 가능 / false: 개별 선택만 가능
         */
        function isTeamBatchMode() {
            return EZG.teamAsmtStngyn === "Y" && EZG.tmbrIndivSbmsnPrmyn !== "Y";
        }

        /**
         * EZ-Grader 대상 목록 선택 이벤트를 초기화한다.
         */
        function initEzGraderEvents() {
            // 학생 클릭
            $(document).off("click", ".stu_list ul li")
            .on("click", ".stu_list ul li", function () {

                $(".stu_list ul li").removeClass("active");
                $(".temaTitle").removeClass("active");

                $(this).addClass("active");

                selectedTargetType = "USER"; // 학생 클릭
                selectedEvlUsers = [getUserDataFromLi(this)];
                selectedViewUser = selectedEvlUsers[0];

                afterSelectTarget();
            });

            // 팀 선택
            $(document).off("click", ".stu_list .temaTitle")
            .on("click", ".stu_list .temaTitle", function () {

                if (!isTeamBatchMode()) {
                    return;
                }

                $(".stu_list ul li").removeClass("active");
                $(".temaTitle").removeClass("active");

                $(this).addClass("active");

                const $teamBox = $(this).closest(".stu_list");
                const $members = $teamBox.find("ul li");

                $members.addClass("active");

                selectedTargetType = "TEAM"; // 팀 클릭
                selectedEvlUsers = [];
                $members.each(function () {
                    selectedEvlUsers.push(getUserDataFromLi(this));
                });

                selectedViewUser = selectedEvlUsers.find(function (item) {
                    return item.ldryn === "Y";
                }) || selectedEvlUsers[0];

                afterSelectTarget();
            });
        }

        /**
         * 선택 유저 Li
         * @param obj
         * @returns {{userId: *|jQuery, usernm: *|jQuery, teamId: *|jQuery, teamnm: *|jQuery, ldryn: *|jQuery, asmtSbmsnId: *|jQuery, exlnAsmtyn: *|jQuery}}
         */
        function getUserDataFromLi(obj) {
            return {
                asmtId: $(obj).data("asmtId")
                , userId: $(obj).data("userId")
                , usernm: $(obj).data("usernm")
                , teamId: $(obj).data("teamId")
                , teamnm: $(obj).data("teamnm")
                , ldryn: $(obj).data("ldryn")
                , asmtSbmsnId: $(obj).data("asmtSbmsnId")
                , exlnAsmtyn: $(obj).data("exlnAsmtyn")
            };
        }

        /**
         * 유저선택
         */
        function afterSelectTarget() {
            $("#totalScore").val("");
            $("#profMemo").val("");
            $("#sbmsnHistArea").hide();
            $("#histToggleBtn").text("<spring:message code='asmt.label.asmt.submit.history.view'/><%--과제 제출 이력 보기--%>");

            getAsmtEvlDetail();
            getAsmtSbmsnHist(false);
        }

        /**
         * 선택 유저 데이터
         * @returns {{asmtId: string, userId: *, teamId, asmtSbmsnId, userIds: string}|null}
         */
        function getSelectedUserParam() {
            if (!selectedViewUser || selectedEvlUsers.length === 0) {
                UiComm.showMessage("<spring:message code='asmt.alert.no.selected.target'/><%--선택된 대상이 없습니다.--%>", "warning");
                return null;
            }

            return {
                asmtId: selectedViewUser.asmtId || EZG.asmtId
                , userId: selectedViewUser.userId
                , teamId: selectedViewUser.teamId || ""
                , asmtSbmsnId: selectedViewUser.asmtSbmsnId || ""
                , userIds: selectedEvlUsers.map(function (item) {
                    return item.userId;
                }).join(",")
            };
        }

        /**
         * 평가 대상 목록
         */
        function getAsmtEvlList() {
            /*
             * 저장/초기화 후 목록을 다시 그릴 때 현재 보고 있던 대상이 바뀌지 않도록
             * 렌더링 전에 선택 대상 정보를 보관한다.
             */
            const keepTarget = selectedViewUser ? {
                targetType: selectedTargetType
                , userId: selectedViewUser.userId
                , teamId: selectedViewUser.teamId || ""
            } : null;

            const extData = {
                asmtId: EZG.asmtId  // 상위과제ID
                , sbjctId: EZG.sbjctId
                , searchType: "LIST"
                , userId: "" // 진입 대상자는 목록 필터가 아니라 렌더링 후 선택 대상으로만 사용한다.
                , teamId: "" // 평가 화면의 팀 필터가 encParams에 남아있어도 EZ-Grader 목록은 전체를 조회한다.
                , searchSort: $("#ezgSearchSort").val()
                , sbmsnStscd: $("#sbmsnStscd").val()
            };

            const param = {
                encParams: EPARAM
                , addParams: UiComm.makeEncParams(extData)
            };

            ajaxCall("/asmt2/profAsmtEvlListAjax.do", param, function (data) {
                if (data.encParams != null && data.encParams != '') {
                    EPARAM = data.encParams;
                }

                const list = data.returnList || [];
                renderEvlUserList(list);

                if (list.length > 0) {
                    /*
                     * 선택 우선순위
                     * 1. 방금 보고 있던 팀/사용자
                     * 2. 최초 팝업 진입 시 전달된 사용자
                     * 3. 첫 팀 또는 첫 사용자
                     */
                    let $selectTarget = $();

                    if (keepTarget && keepTarget.targetType === "TEAM" && keepTarget.teamId) {
                        $selectTarget = $(".stu_list .temaTitle").filter(function () {
                            return $(this).data("teamId") === keepTarget.teamId;
                        }).first();
                    }

                    if ($selectTarget.length === 0 && keepTarget && keepTarget.userId) {
                        $selectTarget = $(".stu_list_area li").filter(function () {
                            return $(this).data("userId") === keepTarget.userId;
                        }).first();
                    }

                    if ($selectTarget.length === 0 && !keepTarget && EZG.targetUserId) {
                        $selectTarget = $(".stu_list_area li").filter(function () {
                            return $(this).data("userId") === EZG.targetUserId;
                        }).first();
                    }

                    if ($selectTarget.length > 0) {
                        $selectTarget.trigger("click");
                        $selectTarget[0].scrollIntoView({block: "center"});
                    } else if (EZG.teamAsmtStngyn === "Y") {
                        $(".stu_list .temaTitle").first().trigger("click");
                    } else {
                        $(".stu_list_area li").first().trigger("click");
                    }
                } else {
                    resetEvlView();
                }
            }, function () {
                UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
            }, true);
        }

        /**
         * 유저 목록
         * @param list
         */
        function renderEvlUserList(list) {
            let html = "";

            if (!list || list.length === 0) {
                html += "<div class='stu_list'>";
                html += "    <ul>";
                html += "        <li><spring:message code='asmt.label.eval.target.empty'/><%--평가 대상이 없습니다.--%></li>";
                html += "    </ul>";
                html += "</div>";
                $(".stu_list_area").html(html);
                return;
            }

            let prevTeamId = "";

            list.forEach(function (item) {
                const isTeam = item.teamId && item.teamId !== "";

                if (isTeam && prevTeamId !== item.teamId) {
                    if (prevTeamId !== "") {
                        html += "    </ul>";
                        html += "</div>";
                    }

                    html += "<div class='stu_list'  data-team-id='" + UiComm.escapeHtml(item.teamId || "") + "'>";
                    html += "    <p class='temaTitle' data-team-id='" + UiComm.escapeHtml(item.teamId || "") + "'>" + UiComm.escapeHtml(item.teamnm || "-") + "</p>";
                    html += "    <ul>";

                    prevTeamId = item.teamId;
                }

                if (!isTeam && prevTeamId !== "__NONE__") {
                    if (prevTeamId !== "") {
                        html += "    </ul>";
                        html += "</div>";
                    }

                    html += "<div class='stu_list'>";
                    html += "    <ul>";

                    prevTeamId = "__NONE__";
                }

                html += "<li"
                    + " data-asmt-id='" + UiComm.escapeHtml(item.asmtId || EZG.asmtId || "") + "'"
                    + " data-user-id='" + UiComm.escapeHtml(item.userId || "") + "'"
                    + " data-user-nm='" + UiComm.escapeHtml(item.usernm || "") + "'"
                    + " data-team-id='" + UiComm.escapeHtml(item.teamId || "") + "'"
                    + " data-team-nm='" + UiComm.escapeHtml(item.teamnm || "") + "'"
                    + " data-ldryn='" + UiComm.escapeHtml(item.ldryn || "N") + "'"
                    + " data-asmt-sbmsn-id='" + UiComm.escapeHtml(item.asmtSbmsnId || "") + "'"
                    + " data-exln-asmtyn='" + UiComm.escapeHtml(item.exlnAsmtyn || "N") + "'"
                    + ">";
                html += "    <div class='icon_box'>";

                if (item.evlyn === "Y") {
                    html += "        <span><i class='xi-check icon' title='<spring:message code='asmt.label.eval.complete'/><%--평가완료--%>'></i></span>";
                }

                if (item.exlnAsmtyn === "Y") {
                    html += "        <span><i class='xi-trophy icon' title='<spring:message code='asmt.label.excellent.asmt'/><%--우수과제--%>'></i></span>";
                }

                html += "    </div>";
                html += "    <span>" + UiComm.escapeHtml(item.deptnm || "-") + "</span>";
                html += "    <p>" + UiComm.escapeHtml(item.usernm || "-") + "</p>";
                html += "</li>";
            });

            if (prevTeamId !== "") {
                html += "    </ul>";
                html += "</div>";
            }

            $(".stu_list_area").html(html);
        }

        /**
         * 평가 초기화
         */
        function resetEvlView() {
            selectedEvlUsers = [];
            selectedViewUser = null;


            $("#totalScore").val("");
            $("#profMemo").val("");
            $("#viewData").hide().empty();
            $("#noData").show();
            $("#asmtSbmsnHistTbody").empty();
            $("#sbmsnHistArea").hide();
            $("#fdbkCntBtn").text("0<spring:message code='asmt.label.cnt.feedback'/><%--개의 피드백--%>");
        }

        /**
         * 평가 상세
         */
        function getAsmtEvlDetail() {
            const extData = getSelectedUserParam();

            if (!extData) return;
            extData.searchType = "OBJECT";

            const param = {
                encParams: EPARAM
                , addParams: UiComm.makeEncParams(extData)
            };

            ajaxCall("/asmt2/profAsmtEvlSelectAjax.do", param, function (data) {
                if (data.encParams != null && data.encParams != '') {
                    EPARAM = data.encParams;
                }
                const vo = data.returnVO || {};

                $("#totalScore").val(vo.scr || "");
                $("#fdbkCntBtn").text((vo.fdbkCnt || 0) + "<spring:message code='asmt.label.cnt.feedback'/><%--개의 피드백--%>");

                if (selectedTargetType === "USER") {
                    $("#profMemo").val(vo.evlMemo || "");
                } else {
                    $("#profMemo").val("");
                }

                renderSubmissionView(vo);
                renderRubric(vo.rubricList || []);
                setSavedScore(vo.scr);
                renderExlnButton(vo);
            }, function () {
                UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
            }, true);
        }

        /**
         * 저장된 최종 점수를 화면에 반영한다.
         * 루브릭 보기 선택값은 별도 저장하지 않으므로 조회 시 최종 점수만 복원한다.
         */
        function setSavedScore(scr) {
            if (scr === null || scr === undefined || scr === "") {
                return;
            }

            $("#totalScore").val(scr);

            if ($("#rubricTotalScore").length > 0) {
                $("#rubricTotalScore").text(scr + "<spring:message code='asmt.label.point'/><%--점--%>");
            }
        }

        /**
         * 과제 화면
         * @param vo
         */
        function renderSubmissionView(vo) {
            $("#viewData").empty();
            $("#mediaExtBtn").hide();
            $("#imgFullView").hide();
            $("#imgFullViewBox").empty();

            if (!vo.asmtSbmsnId) {
                $("#viewData").hide();
                $("#noData").show();
                return;
            }

            $("#noData").hide();
            $("#viewData").show();

            let html = "";

            const inputTextYn = (vo.sbmsnTycd === "INPUT_TEXT" || vo.sbasmtTycd === "INPUT_TEXT") && vo.sbmsnTxt;

            // 텍스트 제출은 등록 시 사용한 에디터 형태로 제출 본문을 표시한다.
            if (inputTextYn) {
                html += "<div class='p20'>";
                html += "    <textarea id='sbmsnTxtViewer'></textarea>";
                html += "</div>";
            }


            const fileList = vo.fileList || [];
            let previewType = "";

            fileList.forEach(function (file) {

                const ext = (file.fileExt || "").toLowerCase();
                const isMaxSize = Number(file.fileSize || 0) > 20 * 1024 * 1024;

                // AS-IS처럼 미리보기 가능 파일도 20MB 초과 시에는 직접 보기 대신 다운로드/보기 선택으로 대체한다.
                // AS-IS처럼 사이냅 문서뷰어 대상 파일은 iframe으로 바로 표시한다.
                if (isSynapViewerFile(file)) {
                    previewType = previewType || "pdf";
                    html += "<iframe class='item' title='<spring:message code='asmt.label.submit.asmt.file'/><%--과제 제출 파일--%>' src='" + UiComm.escapeHtml(file.synapView || "") + "'></iframe>";
                } else if (isPreviewableFile(file) && isMaxSize) {
                    html += renderSbmsnFileFallback(file, true);
                } else if (isPreviewableFile(file)) {
                    previewType = previewType || (ext === "pdf" || ext === "txt" ? "pdf" : "img");
                    if (ext === "pdf" || ext === "txt") {
                        html += "<iframe class='item' title='<spring:message code='asmt.label.submit.asmt.file'/><%--과제 제출 파일--%>' src='" + UiComm.escapeHtml(file.fileView || "") + "'></iframe>";
                    } else {
                        html += "<div class='item tc p10'>";
                        html += "    <img src='" + UiComm.escapeHtml(file.fileView || "") + "' alt='<spring:message code='asmt.label.submit.asmt.image'/><%--과제 제출 이미지--%>'>";
                        html += "</div>";
                    }
                } else {
                    html += renderSbmsnFileFallback(file);
                }
            });

            if (!html) {
                html = "<div class='p20'><spring:message code='asmt.label.submit.content.empty'/><%--제출 내용이 없습니다.--%></div>";
            }

            $("#viewData").html(html);

            if (inputTextYn) {
                renderInputTextViewer(vo.sbmsnTxt);
            }

            if (previewType) {
                showMediaExtBtn(previewType);
            }
        }

        /**
         * 직접입력 제출내용을 에디터로 표시한다.
         * @param sbmsnTxt 제출내용 HTML
         */
        function renderInputTextViewer(sbmsnTxt) {
            const editor = UiEditor({
                targetId: "sbmsnTxtViewer",
                uploadPath: "/asmt",
                height: "400px"
            });

            if (editor && typeof editor.openHTML === "function") {
                editor.openHTML(sbmsnTxt || "");
            } else {
                $("#sbmsnTxtViewer").val(sbmsnTxt || "");
            }

            if (editor && typeof editor.setMode === "function") {
                editor.setMode("readonly");
            } else if (editor && typeof editor.setReadOnly === "function") {
                editor.setReadOnly(true);
            }
        }

        /**
         * 제출 파일이 EZ-Grader 화면에서 바로 미리보기 가능한지 확인한다.
         * @param file 제출 첨부파일
         * @returns {boolean}
         */
        function isPreviewableFile(file) {
            const ext = (file.fileExt || "").toLowerCase();
            const fileMimeTycd = EZG.sbmsnFileMimeTycd || "";

            if (!file.fileView) {
                return false;
            }

            if (["png", "jpg", "jpeg", "gif"].includes(ext)) {
                return EZG.asmtPrctcyn === "Y" || fileMimeTycd === "all" || hasSbmsnFileMimeTycd("img");
            }

            if (ext === "pdf") {
                return EZG.asmtPrctcyn === "Y" || fileMimeTycd === "all" || hasSbmsnFileMimeTycd("pdf") || hasSbmsnFileMimeTycd("pdf2");
            }

            return ext === "txt" && (fileMimeTycd === "all" || hasSbmsnFileMimeTycd("txt") || hasSbmsnFileMimeTycd("soc"));
        }

        function isSynapViewerFile(file) {
            // 서버에서 사이냅 뷰어 URL을 내려준 파일만 문서뷰어 대상으로 처리한다.
            return !!(file && file.synapView);
        }

        /**
         * 제출 허용 파일유형 코드에 특정 코드가 포함되어 있는지 확인한다.
         * @param code 확인할 파일유형 코드
         * @returns {boolean}
         */
        function hasSbmsnFileMimeTycd(code) {
            const fileMimeTycdList = "," + (EZG.sbmsnFileMimeTycd || "") + ",";
            return fileMimeTycdList.indexOf("," + code + ",") > -1;
        }

        /**
         * 미리보기 불가 파일을 다운로드 가능한 제출 과제 텍스트로 표시한다.
         * @param file 제출 첨부파일
         * @returns {string}
         */
        function renderSbmsnFileFallback(file, viewButtonYn) {
            const filenm = file.filenm || file.fileNm || "";
            const encDownParam = file.encDownParam || "";
            let html = "<div class='p20'>";
            // 미리보기 불가 파일도 최종 제출 과제를 확인하고 바로 다운로드할 수 있게 표시한다.
            html += "<spring:message code='asmt.label.submitted.work'/><%--제출과제--%> : ";
            if (encDownParam) {
                html += "<a href='#_' class='link' onclick=\"UiFileDownloader('" + encDownParam + "');return false;\">";
                html += UiComm.escapeHtml(filenm);
                html += "</a>";
            } else {
                html += UiComm.escapeHtml(filenm);
            }
            html += " " + formatSbmsnFileSize(file.fileSize);
            if (viewButtonYn && file.fileView) {
                html += " <button type='button' class='btn basic sm' data-file-view='" + UiComm.escapeHtml(file.fileView || "") + "' data-file-ext='" + UiComm.escapeHtml((file.fileExt || "").toLowerCase()) + "' onclick='viewLargeSbmsnFile(this)'><spring:message code='asmt.label.view'/><%--보기--%></button>";
            }
            html += "</div>";
            return html;
        }

        /**
         * 용량 제한으로 바로 표시하지 않은 제출 파일을 사용자가 요청하면 미리보기 영역에 표시한다.
         * @param obj 보기 버튼
         */
        function viewLargeSbmsnFile(obj) {
            const $item = $(obj).closest(".p20");
            const fileView = $(obj).data("fileView") || "";
            const fileExt = $(obj).data("fileExt") || "";
            const previewType = fileExt === "pdf" || fileExt === "txt" ? "pdf" : "img";
            let html = "";

            if (previewType === "pdf") {
                html += "<iframe class='item' title='<spring:message code='asmt.label.submit.asmt.file'/><%--과제 제출 파일--%>' src='" + UiComm.escapeHtml(fileView) + "'></iframe>";
            } else {
                html += "<div class='item tc p10'>";
                html += "    <img src='" + UiComm.escapeHtml(fileView) + "' alt='<spring:message code='asmt.label.submit.asmt.image'/><%--과제 제출 이미지--%>'>";
                html += "</div>";
            }

            $item.replaceWith(html);
            showMediaExtBtn(previewType);
        }

        /**
         * 미리보기 확대 버튼을 표시한다.
         * @param type 미리보기 유형(img/pdf)
         */
        function showMediaExtBtn(type) {
            $("#imgFullView").removeClass("fullimg fullpdf").addClass(type === "pdf" ? "fullpdf" : "fullimg");
            $("#mediaExtBtn").show();
        }

        /**
         * 제출 파일 미리보기를 전체 화면으로 전환하거나 원래 영역으로 되돌린다.
         * @param type full/close/original
         */
        function viewFullImage(type) {
            if (type === "full") {
                $("#imgFullViewBox").empty().append($("#viewData .item"));
                $("#mediaExtBtn").hide();
                $("#imgFullView").show();
                return;
            }

            if (type === "close") {
                $("#viewData").append($("#imgFullViewBox .item"));
                $("#viewData .item img").css({"width": "auto", "max-width": "100%", "height": "auto"});
                $("#imgFullView").hide();
                $("#mediaExtBtn").show();
                return;
            }

            if (type === "original") {
                const $img = $("#imgFullViewBox .item img");
                const maxWidth = $img.css("max-width");
                $img.css(maxWidth === "100%" ? {"width": "auto", "max-width": "unset", "height": "auto"} : {"width": "auto", "max-width": "100%", "height": "auto"});
                $("#imgFullViewBox").scrollTop(0).scrollLeft(0);
            }
        }

        /**
         * 파일 크기를 화면 표시용 단위로 변환한다.
         * @param fileSize 파일 크기(byte)
         * @returns {string}
         */
        function formatSbmsnFileSize(fileSize) {
            const size = Number(fileSize || 0);
            if (!size) {
                return "";
            }
            if (size < 1024 * 1024) {
                return (Math.round((size / 1024) * 100) / 100) + " KB";
            }
            return (Math.round((size / 1024 / 1024) * 100) / 100) + " MB";
        }

        /**
         * 점수 저장
         */
        function submitScore() {

            let validator = UiValidator("scrForm");
            validator.then(function (result) {
                if (result) {
                    const extData = getSelectedUserParam();
                    if (!extData) return;

                    extData.scr = $("#totalScore").val();

                    const param = {
                        encParams: EPARAM
                        , addParams: UiComm.makeEncParams(extData)
                    };

                    ajaxCall("/asmt2/profAsmtEzgScrModifyAjax.do", param, function (data) {
                        if (data.encParams != null && data.encParams != '') {
                            EPARAM = data.encParams;
                        }
                        UiComm.showMessage("<spring:message code='asmt.alert.score.save_success'/><%--성적 등록이 완료되었습니다.--%>", "success");
                        getAsmtEvlList();
                    }, function () {
                        UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
                    }, true);
                } else {
                    UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
                    return false;
                }
            });
        }

        /**
         * 점수 초기화
         */
        function resetScore() {
            $("#totalScore").val("0");
            submitScore();
        }

        /**
         * 메모 저장
         */
        function saveProfMemo() {
            let validator = UiValidator("memoForm");
            validator.then(function (result) {
                if (!result) {
                    return;
                }

                const extData = getSelectedUserParam();
                if (!extData) return;

                const profMemo = $("#profMemo").val();

                if (!profMemo) {
                    UiComm.showMessage("<spring:message code='asmt.alert.input.memo'/><%--메모를 입력해주세요.--%>", "warning");
                    return;
                }

                extData.evlMemo = profMemo;
                extData.saveTargetType = selectedTargetType;    // USER, TEAM

                const url = "/asmt2/profAsmtMemoModifyAjax.do";
                const param = {
                    encParams: EPARAM
                    , addParams: UiComm.makeEncParams(extData)
                };

                ajaxCall(url, param, function (data) {
                    if (data.encParams != null && data.encParams != '') {
                        EPARAM = data.encParams;
                    }
                    if (data.result > 0) {
                        UiComm.showMessage("<spring:message code='asmt.alert.memo.insert' /><%--메모 저장이 완료되었습니다.--%>", "success");// 메모 저장이 완료되었습니다.
                        getAsmtEvlDetail();
                    } else {
                        UiComm.showMessage(data.message, "error");
                    }
                }, function (xhr, status, error) {
                    UiComm.showMessage("<spring:message code='asmt.alert.memo.error' /><%--메모 저장 중 에러가 발생하였습니다. 잠시 후 다시 진행해 주세요.--%>", "error");// 메모 저장 중 에러가 발생하였습니다.
                }, true);
            });
        }


        /**
         * 피드백 팝업
         */
        function fdbkListPop() {
            if (selectedTargetType === "TEAM") {
                UiComm.showMessage("<spring:message code='asmt.alert.select.std'/><%--학습자를 선택해 주세요.--%>", "warning");
                return false;
            }
            const targetUser = getSelectedUserParam();
            if (!targetUser) {
                return;
            }

            const extData = {
                asmtId: targetUser.asmtId
                , userId: targetUser.userId
                , teamId: targetUser.teamId || ""
            };

            dialog = UiDialog("dialog1", {
                title: "<spring:message code='asmt.label.feedback'/><%--피드백--%>",
                width: 1000,
                height: 350,
                url: "/asmt2/profAsmtFdbkPopup.do?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams(extData),
                autoresize: true
            });
        }

        /**
         * 피드백 저장
         */
        function saveFdbk() {

            let validator = UiValidator("fdbkForm");
            validator.then(function (result) {
                if (!result) {
                    return;
                }
                const extData = getSelectedUserParam();
                if (!extData) return;

                const fdbkCts = $("#fdbkCts").val().trim();

                if (!fdbkCts) {
                    UiComm.showMessage("<spring:message code='asmt.alert.input.feedback'/><%--피드백을 입력해주세요.--%>", "warning");
                    return;
                }

                extData.fdbkCts = fdbkCts;

                const param = {
                    encParams: EPARAM
                    , addParams: UiComm.makeEncParams(extData)
                };

                ajaxCall("/asmt2/profAsmtEzgFdbkRegistAjax.do", param, function (data) {
                    if (data.encParams != null && data.encParams != '') {
                        EPARAM = data.encParams;
                    }
                    UiComm.showMessage("<spring:message code='asmt.alert.reg_success.feedback'/><%--피드백 등록에 성공하였습니다.--%>", "success");
                    $("#fdbkCts").val("");
                    getAsmtEvlDetail();
                }, function () {
                    UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
                }, true);
            });
        }


        /**
         * 우수과제 대상 조회
         */
        function getExlnTargetUser() {
            if (!selectedViewUser) {
                return null;
            }

            /*
             * 일반 팀과제는 팀장만 우수과제 처리
             */
            if (isTeamBatchMode() && selectedViewUser.teamId) {
                const $leader = $(".stu_list ul li[data-team-id='" + selectedViewUser.teamId + "'][data-ldryn='Y']").first();

                if ($leader.length > 0) {
                    return getUserDataFromLi($leader[0]);
                }
            }

            /*
             * 개인/전체과제 또는 팀원개별제출허용 팀과제
             */
            return selectedViewUser;
        }

        /**
         * 우수과제 선정/취소
         */
        function toggleSbmsnBest() {
            const targetUser = getExlnTargetUser();

            if (!targetUser) {
                UiComm.showMessage("<spring:message code='asmt.alert.select.std'/><%--학습자를 선택해 주세요.--%>", "warning");
                return false;
            }

            const currentYn = $("#exlnBtn").data("exlnAsmtyn") || "N";
            const nextYn = currentYn === "Y" ? "N" : "Y";

            const extData = {
                asmtId: targetUser.asmtId || EZG.asmtId
                , userId: targetUser.userId
                , teamId: targetUser.teamId || ""
                , exlnAsmtyn: nextYn
            };
            const param = {
                encParams: EPARAM
                , addParams: UiComm.makeEncParams(extData)
            };

            ajaxCall("/asmt2/profAsmtEzgExlnModifyAjax.do", param, function (data) {
                if (data.encParams != null && data.encParams != '') {
                    EPARAM = data.encParams;
                }
                if (data.result > 0) {
                    UiComm.showMessage(nextYn === "Y"
                            ? "<spring:message code='asmt.alert.excellent.asmt.complete'/><%--우수과제 선정이 완료되었습니다.--%>"
                            : "<spring:message code='asmt.alert.no.excellent.asmt.complete'/><%--우수과제 선정이 취소되었습니다.--%>"
                        , "success");
                    getAsmtEvlList();
                    getAsmtEvlDetail();
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }, function () {
                UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
            }, true);
        }

        /**
         * 우수과제 버튼명 변경
         * @param vo
         */
        function renderExlnButton(vo) {
            const yn = vo.exlnAsmtyn || "N";

            $("#exlnBtn")
            .data("exlnAsmtyn", yn)
            .text(yn === "Y" ? "<spring:message code='asmt.button.excellent.asmt.cancel'/><%--우수과제 선정 취소--%>" : "<spring:message code='asmt.button.excellent.asmt.select'/><%--우수 과제로 선정--%>");
        }


        /**
         * 이전과제제출목록 팝업
         */
        function prevAsmtSbmsnPop() {
            const extData = getSelectedUserParam();
            if (!extData) return;

            const data = "sbjctId=" + extData.sbjctId
                + "&asmtId=" + extData.asmtId
                + "&userId=" + extData.userId;

            dialog = UiDialog("dialog1", {
                title: "<spring:message code='asmt.label.prev.asmt.submit.list'/><%--이전 과제 제출 목록--%>",
                width: 1000,
                height: 300,
                url: "/asmt2/profAsmtPrevSbmsnListPopup.do?" + data + "&encParams=" + EPARAM,
                autoresize: true
            });
        }

        /**
         * 제출 이력 표시/숨김
         */
        function toggleAsmtSbmsnHist() {
            if ($("#sbmsnHistArea").is(":visible")) {
                $("#sbmsnHistArea").hide();
                $("#histToggleBtn").text("<spring:message code='asmt.label.asmt.submit.history.view'/><%--과제 제출 이력 보기--%>");
                return;
            }

            getAsmtSbmsnHist(true);
        }

        /**
         * 과제 제출 이력
         */
        function getAsmtSbmsnHist(showAfterLoad) {
            const extData = getSelectedUserParam();
            if (!extData) return;

            const param = {
                encParams: EPARAM
                , addParams: UiComm.makeEncParams(extData)
            };
            ajaxCall("/asmt2/profAsmtSbmsnHistAjax.do", param, function (data) {
                if (data.encParams != null && data.encParams != '') {
                    EPARAM = data.encParams;
                }

                const list = data.returnList || [];
                renderAsmtSbmsnHist(list);

                if (showAfterLoad) {
                    $("#sbmsnHistArea").show();
                    $("#histToggleBtn").text("<spring:message code='asmt.label.asmt.submit.history.hide'/><%--과제 제출 이력 숨김--%>");
                }
            }, function () {
                UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
            }, true);
        }

        /**
         * 과제제출 이력 렌더링
         * @param list
         */
        function renderAsmtSbmsnHist(list) {
            let html = "";

            if (!list || list.length === 0) {
                html += "<tr>";
                html += "    <td colspan='3'><spring:message code='asmt.label.asmt.submit.history.empty'/><%--조회된 과제 제출 이력이 없습니다.--%></td>";
                html += "</tr>";
                $("#asmtSbmsnHistTbody").html(html);
                return;
            }

            list.forEach(function (item) {
                html += "<tr>";
                html += "    <th><spring:message code='asmt.label.submit.dt'/><%--제출 일시--%></th>";
                html += "    <td>" + UiComm.formatDate(item.sbmsnDttm || "-", "datetime2") + "</td>";
                html += "    <td>" + renderHistFileText(item.fileList || []) + "</td>";
                html += "</tr>";
            });

            $("#asmtSbmsnHistTbody").html(html);
        }

        /**
         * 과제제출이력 파일 렌더링
         * @param fileList
         * @returns {string}
         */
        function renderHistFileText(fileList) {
            if (!fileList || fileList.length === 0) {
                return "-";
            }

            let html = "";

            fileList.forEach(function (file, index) {
                if (index > 0) {
                    html += "<br>";
                }

                html += UiComm.escapeHtml(file.filenm || "");
                html += " ";
                html += file.fileSize || "";
            });

            return html;
        }

        /**
         * 루브릭 렌더링
         */
        function renderRubric(rubricList) {
            const $area = $("#rubricArea");
            $area.empty();

            if (!rubricList || rubricList.length === 0) {
                $area.hide();
                return;
            }

            let html = "";

            html += "<div class='memoBox eval-method-item'>";
            html += "    <p class='title'><spring:message code='asmt.label.rubric'/><%--루브릭--%> 01</p>";

            rubricList.forEach(function (item, index) {
                const evlrt = Number(item.evlrt || 0);
                const isLast = index === rubricList.length - 1;

                html += "    <div class='table-wrap'>";
                html += "        <table class='table-type3'>";
                html += "            <colgroup>";
                html += "                <col width='60px'>";
                html += "                <col>";
                html += "            </colgroup>";
                html += "            <tbody>";
                html += "                <tr>";
                html += "                    <th><spring:message code='asmt.label.criteria'/><%--기준--%></th>";
                html += "                    <td>";
                html += UiComm.escapeHtml(item.rubricQstnTtl || "");
                html += "                        <input type='hidden' name='rubricQstnId' value='" + UiComm.escapeHtml(item.rubricQstnId || "") + "'>";
                html += "                        <input type='hidden' name='evlrt' value='" + evlrt + "'>";
                html += "                    </td>";
                html += "                </tr>";
                html += "                <tr>";
                html += "                    <th><spring:message code='asmt.label.grade'/><%--등급--%></th>";
                html += "                    <td>";
                html += "                        <select class='form-select width-100per rubric-vwitm' data-index='" + index + "' data-evlrt='" + evlrt + "' onchange='calcRubricScore()'>";
                html += "                            <option value='' data-score='0'><spring:message code='asmt.button.select'/><%--선택--%></option>";

                (item.rubricVwitmList || []).forEach(function (rubricVwitm) {
                    const selected = rubricVwitm.selectedYn === "Y" ? " selected" : "";
                    const rubricVwitmPnt = Number(rubricVwitm.rubricVwitmPnt || 0);

                    html += "                        <option value='" + UiComm.escapeHtml(rubricVwitm.rubricVwitmId || "") + "' data-score='" + rubricVwitmPnt + "'" + selected + ">";
                    html += rubricVwitmPnt + "<spring:message code='asmt.label.point'/><%--점--%> " + UiComm.escapeHtml(rubricVwitm.rubricVwitmTtl || "");
                    html += "                        </option>";
                });

                html += "                        </select>";
                html += "                    </td>";
                html += "                </tr>";
                html += "                <tr>";
                html += "                    <th><spring:message code='asmt.label.score'/><%--점수--%></th>";
                html += "                    <td><b class='rubric-score'>0<spring:message code='asmt.label.point'/><%--점--%></b></td>";
                html += "                </tr>";
                if (isLast) {
                    html += "                <tr class='total'>";
                    html += "                    <th><strong><spring:message code='asmt.label.total.score'/><%--총점--%></strong></th>";
                    html += "                    <td><strong><span id='rubricRawTotalScore'>0</span> (<spring:message code='asmt.label.converted.score'/><%--환산점수--%> <span id='rubricTotalScore'>0<spring:message code='asmt.label.point'/><%--점--%></span>)</strong></td>";
                    html += "                </tr>";
                }
                html += "            </tbody>";
                html += "        </table>";
                html += "    </div>";
            });
            html += "</div>";

            $area.html(html).show();
            calcRubricScore();
        }

        /**
         * 루브릭 점수 계산
         */
        function calcRubricScore() {
            let rawTotalScore = 0;
            let cnvsnTotalScore = 0;

            $(".rubric-vwitm").each(function () {
                const rubricVwitmPnt = Number($(this).find("option:selected").data("score") || 0);
                const evlrt = Number($(this).data("evlrt") || 0);
                let maxScore = 0;

                $(this).find("option").each(function () {
                    const optionScore = Number($(this).data("score") || 0);
                    if (maxScore < optionScore) {
                        maxScore = optionScore;
                    }
                });

                const evlScore = maxScore > 0 ? Math.floor(rubricVwitmPnt / maxScore * evlrt) : 0;

                rawTotalScore += rubricVwitmPnt;
                cnvsnTotalScore += evlScore;
                $(this).closest("tbody").find(".rubric-score").text(rubricVwitmPnt + "<spring:message code='asmt.label.point'/><%--점--%>");
            });

            $("#rubricRawTotalScore").text(rawTotalScore);
            $("#rubricTotalScore").text(cnvsnTotalScore + "<spring:message code='asmt.label.point'/><%--점--%>");
            $("#totalScore").val(cnvsnTotalScore);
        }

        /**
         * 루브릭 저장
         */
        function submitMut() {
            const extData = getSelectedUserParam();
            if (!extData) return;

            const rubricVwitmIds = [];
            let isValid = true;

            $(".rubric-vwitm").each(function () {
                const rubricVwitmId = $(this).val();

                if (!rubricVwitmId) {
                    isValid = false;
                    return false;
                }

                rubricVwitmIds.push(rubricVwitmId);
            });

            if (!isValid || rubricVwitmIds.length === 0) {
                UiComm.showMessage("<spring:message code='asmt.alert.select.rubric.grade'/><%--루브릭 등급을 선택해주세요.--%>", "warning");
                return;
            }

            extData.scr = $("#totalScore").val();
            extData.rubricId = EZG.rubricId;
            extData.rubricVwitmIds = rubricVwitmIds.join(",");

            const param = {
                encParams: EPARAM
                , addParams: UiComm.makeEncParams(extData)
            };

            ajaxCall("/asmt2/profAsmtRubricEvlSaveAjax.do", param, function (data) {
                if (data.encParams != null && data.encParams != '') {
                    EPARAM = data.encParams;
                }
                UiComm.showMessage("<spring:message code='asmt.alert.rubric.score.save.success'/><%--루브릭 점수가 저장되었습니다.--%>", "success");
                getAsmtEvlList();
            }, function () {
                UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
            }, true);
        }
    </script>
</head>

<body class="class ${uiex:getTheme()} ${bodyClass}"><!-- 컬러선택시 클래스변경 -->
<div id="wrap" class="main">

    <!-- EZ-Grader 마크업 템플릿 -->
    <div class="modal_EzGarder_area" style="width: 100%; height: 100%; border-radius: 0;">
        <h1 class="EzGarder_title">
            EZ-Grader <spring:message code='asmt_ezg.label.ezg_title'/><%--쉽고 빠르게 평가--%>
            <button type="button" class="btn_close" onclick="window.parent.closeDialog();" aria-label="<spring:message code='asmt.button.close'/><%--닫기--%>"><i class="xi-close"></i></button>
        </h1>
        <div class="EzCarder_content">
            <div class="left_list">
                <div class="left_select_box mb10">
                    <select class="form-select" id="ezgSearchSort" onChange="getAsmtEvlList()">
                        <option value=""><spring:message code='asmt_ezg.label.nm_order'/><%--이름순--%></option>
                        <%--이름순--%>
                        <option value="NO"><spring:message code='asmt_ezg.label.userid_order'/><%--학번순--%></option>
                        <%--학번순--%>
                        <option value="DT"><spring:message code='asmt_ezg.label.submit_order'/><%--제출자순--%></option>
                        <%--제출자순--%>
                    </select>
                    <select class="form-select" id="sbmsnStscd" name="sbmsnStscd" onchange="getAsmtEvlList()">
                        <option value="" selected disabled hidden><spring:message code='asmt_ezg.label.sel_filter'/><%--필터 선택--%></option>
                        <option value="all"><spring:message code='asmt.label.all'/><%--전체--%></option>
                        <c:forEach items="${cmmnCdList.sbmsnStscdList}" var="item">
                            <option value="${item.cd}">${item.cdnm}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="stu_list_area">
                    <!-- JS 렌더링 -->
                </div>
            </div>

            <div class="center_com width-100per">

                <div class="board_top" id="sbmsnHistArea" style="display:none;">
                    <h3 class="board-title"><spring:message code='asmt.label.asmt.submit.history'/><%--과제 제출 이력--%></h3>
                    <div class="table-wrap">
                        <table class="table-type3">
                            <colgroup>
                                <col width="100px">
                                <col>
                                <col>
                            </colgroup>
                            <tbody id="asmtSbmsnHistTbody">
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="pdf-viewer" id="mainView">
                    <div class="flex flex-column p_h100 scrollArea">
                        <div class="flex1 flex-column" id="noData" style="display:none;">
                            <div class="flex-container m-hAuto">
                                <div class="no_content">
                                    <i class="icon-cont-none ico f170" aria-hidden="true"></i>
                                    <span><spring:message code='asmt.label.send.asmt.empty'/><%--제출한 과제가 없습니다.--%></span>
                                </div>
                            </div>
                        </div>

                        <div class="flex1 flex-column mediaArea" id="viewData" style="display:none;">
                        </div>

                        <div id="mediaExtBtn" style="display:none;">
                            <button type="button" class="ezg-media-control-btn" title="<spring:message code='asmt.label.full.view'/><%--전체보기--%>" onclick="viewFullImage('full')">
                                <i class="ion-arrow-expand"></i>
                                <spring:message code='asmt.label.full.view'/><%--전체보기--%>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="right_app">
                <form id="scrForm" name="scrForm">
                    <div class="right_top_score">
                        <label for="totalScore">
                            <input type="text" id="totalScore" placeholder="<spring:message code='asmt.alert.input.score'/><%--점수--%>"
                                   inputmask="numeric" mask="999.9" maxVal="100" required="true">
                        </label>
                        <c:choose>
                            <c:when test="${asmtVO.evlScrTycd eq 'RUBRIC_SCR'}">
                                <button type="button" onclick="submitMut()" class="btn small type3"><spring:message code='asmt.button.add'/><%--저장--%></button>
                                <!-- 저장 -->
                            </c:when>
                            <c:otherwise>
                                <button type="button" onclick="submitScore()" class="btn small type3"><spring:message code='asmt.button.add'/><%--저장--%></button>
                                <!-- 저장 -->
                            </c:otherwise>
                        </c:choose>
                        <button onclick="resetScore()" type="button" class="btn small type2"><spring:message code='asmt.button.init'/><%--초기화--%></button>
                    </div>
                </form>
                <div class="right_memo">
                    <%--TODO: 표절율--%>
                    <div class="btn type8 width-100per mb10 cursorNone"><spring:message code='asmt.label.plagiarism.rate.dev'/><%--표절율--%> 10%(개발 예정)</div>
                    <button class="btn basic width-100per mb5" onclick="prevAsmtSbmsnPop()"><spring:message code='asmt.label.prev.submit.asmt.view'/><%--이전 제출 과제 보기--%></button>
                    <button class="btn basic width-100per mb5" id="histToggleBtn" onclick="toggleAsmtSbmsnHist()"><spring:message code='asmt.label.asmt.submit.history.hide'/><%--과제 제출 이력 숨김--%></button>
                    <button class="btn type4 width-100per mb5" id="exlnBtn" onclick="toggleSbmsnBest()"><spring:message code='asmt.button.excellent.asmt.select'/><%--우수 과제로 선정--%></button>

                    <div id="rubricArea">
                    </div>


                    <button class="btn basic width-100per" id="fdbkCntBtn" onclick="fdbkListPop()">3<spring:message code='asmt.label.cnt.feedback'/><%--개의 피드백--%></button>
                    <div class="memoBox">
                        <form id="fdbkForm" name="fdbkForm">
                            <label for="fdbkCts" class="width-100per">
                                <textarea id="fdbkCts" class="width-100per" maxLenCheck="byte,4000,true,true" placeholder="<spring:message code='asmt.label.input.feedback'/><%--피드백 입력--%>"></textarea>
                            </label>
                            <button type="button" class="btn small type3 width-100per" onclick="saveFdbk()"><spring:message code='asmt.button.save'/><%--저장--%></button>
                        </form>
                    </div>
                    <div class="memoBox">
                        <form id="memoForm" name="memoForm">
                            <label for="profMemo" class="width-100per">
                                <textarea id="profMemo" class="width-100per" maxLenCheck="byte,4000,true,true" placeholder="<spring:message code='asmt.label.input.memo'/><%--메모 입력--%>"></textarea>
                            </label>
                            <button type="button" class="btn small type3 width-100per" onclick="saveProfMemo()"><spring:message code='asmt.button.save'/><%--저장--%></button>
                        </form>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>
<div id="imgFullView">
    <div id="fullMediaExtBtn">
        <button type="button" id="fullClose" class="ezg-media-control-btn" title="<spring:message code='asmt.button.close'/><%--닫기--%>" onclick="viewFullImage('close')">
            <i class="ion-arrow-expand"></i>
            <spring:message code='asmt.button.close'/><%--닫기--%>
        </button>
        <button type="button" id="fullOriginal" class="ui icon button mt5" title="<spring:message code='asmt.label.original.size'/><%--원본크기--%>" onclick="viewFullImage('original')">
            <i class="ion-image"></i>
        </button>
    </div>
    <div id="imgFullViewBox"></div>
</div>
</body>
</html>
