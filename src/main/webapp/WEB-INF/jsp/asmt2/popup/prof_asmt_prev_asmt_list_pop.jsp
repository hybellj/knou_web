<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table,fileuploader,editor"/>
    </jsp:include>


    <script type="text/javascript">
        let EPARAM = '<c:out value="${encParams}" />';
        let prevSbmsnTextMap = {};
        let prevSbmsnTextEditor = null;

        $(document).ready(function () {
            getPrevAsmtList();
        });

        /**
         * 이전과제 제출 목록
         */
        function getPrevAsmtList() {
            const extData = {
                "asmtId": "${asmtVO.asmtId}",
                "userId": "${asmtVO.userId}",
                "sbjctId": "${asmtVO.sbjctId}",
            };

            const url = "/asmt2/profPrevAsmtSbmsnListAjax.do";
            const param = {
                encParams: EPARAM
                , addParams: UiComm.makeEncParams(extData)
            };


            ajaxCall(url, param, function (data) {
                if (data.encParams != null && data.encParams != '') {
                    EPARAM = data.encParams;
                }
                const returnList = data.returnList || [];
                prevSbmsnTextMap = {};
                closePrevSbmsnCts();

                let html = "";

                if (!returnList || returnList.length === 0) {
                    html += "<tr>";
                    html += "    <td colspan='8'><spring:message code='asmt.label.prev.asmt.submit.empty'/><%--조회된 이전 과제 제출이 없습니다.--%></td>";
                    html += "</tr>";

                    $("#prevAsmtSbmsnTbody").html(html);
                    return;
                }

                returnList.forEach(function (item) {
                    const fileList = item.fileList || [];
                    const rowSpan = Math.max(fileList.length, 1);

                    const lineNo = item.lineNo || "";
                    const totalCnt = item.totalCnt || "";
                    const displayNo = totalCnt - lineNo + 1;
                    const asmtGbnnm = item.asmtGbnnm || "-";
                    const asmtTtl = item.asmtTtl || "-";
                    const sbmsnDttm = item.sbmsnDttm ? UiComm.formatDate(item.sbmsnDttm, "datetime2") : "-";
                    const scr = (item.scr == null || item.scr === "") ? "-" : item.scr;
                    const scoreInputVal = (item.scr == null || item.scr === "") ? "" : item.scr;
                    const asmtId = item.asmtId ? item.asmtId : "";
                    const userId = item.userId ? item.userId : "";
                    const asmtEvlId = item.asmtEvlId ? item.asmtEvlId : "";

                    if (fileList.length > 0) {
                        fileList.forEach(function (file, idx) {
                            html += "<tr>";

                            if (idx === 0) {
                                html += "    <td data-th='No' rowspan='" + rowSpan + "'>" + displayNo + "</td>";
                                html += "    <td data-th='<spring:message code='asmt.label.asmt.type'/><%--과제구분--%>' rowspan='" + rowSpan + "'>" + asmtGbnnm + "</td>";
                                html += "    <td data-th='<spring:message code='asmt.label.asmt.title'/><%--과제명--%>' rowspan='" + rowSpan + "'>" + UiComm.escapeHtml(asmtTtl) + "</td>";
                            }

                            html += "    <td data-th='<spring:message code='asmt.label.send.file'/><%--제출파일--%>'>";
                            html += "        <a href='javascript:void(0);'>" + UiComm.escapeHtml(file.filenm || file.fileNm || "-") + "</a>";
                            html += "    </td>";

                            html += "    <td data-th='<spring:message code='asmt.label.download'/><%--다운로드--%>'>";
                            html += "       <a href='#_' class='link' onclick=\"UiFileDownloader('" + file.encDownParam + "');return false;\">";
                            html += "            <i class='xi-download icon'></i>";
                            html += "       </a>";
                            html += "    </td>";

                            html += "    <td data-th='<spring:message code='asmt.label.submit.dt'/><%--제출일시--%>'>" + sbmsnDttm + "</td>";
                            html += "    <td data-th='<spring:message code='asmt.label.score'/><%--점수--%>'>" + scr + (scr === "-" ? "" : "<spring:message code='asmt.label.point'/><%--점--%>") + "</td>";

                            if (idx === 0) {
                                html += "    <td data-th='<spring:message code='asmt.label.score.change'/><%--점수변경--%>' rowspan='" + rowSpan + "'>";
                                html += "        <input class='t_num3 prev-asmt-score' type='text'";
                                html += "               id='prevScore_" + asmtId + "'";
                                html += "               value='" + scoreInputVal + "'";
                                html += "               inputmask=\"numeric\" mask=\"999.9\" maxVal=\"100\">";
                                html += "        <button type='button' class='btn type1 small'";
                                html += "                onclick='savePrevAsmtScore(\"" + asmtId + "\", \"" + userId + "\", \"" + asmtEvlId + "\")'><spring:message code='asmt.button.save'/><%--저장--%></button>";
                                html += "    </td>";
                            }

                            html += "</tr>";
                        });
                    } else {
                        html += "<tr>";
                        html += "    <td data-th='No'>" + displayNo + "</td>";
                        html += "    <td data-th='<spring:message code='asmt.label.asmt.type'/><%--과제구분--%>'>" + asmtGbnnm + "</td>";
                        html += "    <td data-th='<spring:message code='asmt.label.asmt.title'/><%--과제명--%>'>" + UiComm.escapeHtml(asmtTtl) + "</td>";

                        if (item.sbmsnTycd === "TEXT" || item.sbmsnTycd === "INPUT_TEXT") {
                            const asmtSbmsnId = item.asmtSbmsnId || asmtId;
                            prevSbmsnTextMap[asmtSbmsnId] = item.sbmsnTxt || "";
                            html += "    <td data-th='<spring:message code='asmt.label.send.file'/><%--제출파일--%>'>";
                            html += "        <button type='button' class='btn basic sm' onclick='viewPrevSbmsnCts(\"" + UiComm.escapeHtml(asmtSbmsnId) + "\")'><spring:message code='asmt.label.content.view'/><%--내용보기--%></button>";
                            html += "    </td>";
                            html += "    <td data-th='<spring:message code='asmt.label.download'/><%--다운로드--%>'>-</td>";
                        } else {
                            html += "    <td data-th='<spring:message code='asmt.label.send.file'/><%--제출파일--%>'>-</td>";
                            html += "    <td data-th='<spring:message code='asmt.label.download'/><%--다운로드--%>'>-</td>";
                        }

                        html += "    <td data-th='<spring:message code='asmt.label.submit.dt'/><%--제출일시--%>'>" + sbmsnDttm + "</td>";
                        html += "    <td data-th='<spring:message code='asmt.label.score'/><%--점수--%>'>" + scr + (scr === "-" ? "" : "<spring:message code='asmt.label.point'/><%--점--%>") + "</td>";
                        html += "    <td data-th='<spring:message code='asmt.label.score.change'/><%--점수변경--%>'>";
                        html += "        <input class='t_num3 prev-asmt-score' type='text'";
                        html += "               id='prevScore_" + asmtId + "'";
                        html += "               value='" + scoreInputVal + "'";
                        html += "               inputmask=\"numeric\" mask=\"999.9\" maxVal=\"100\">";
                        html += "        <button type='button' class='btn type1 small'";
                        html += "                onclick='savePrevAsmtScore(\"" + asmtId + "\", \"" + userId + "\", \"" + asmtEvlId + "\")'><spring:message code='asmt.button.save'/><%--저장--%></button>";
                        html += "    </td>";
                        html += "</tr>";
                    }
                });

                $("#prevAsmtSbmsnTbody").html(html);


            }, function (xhr, status, error) {
                /* 에러가 발생했습니다! */
                UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
            }, true);
        }

        /**
         * 이전과제점수 저장
         * @param asmtId
         * @param userId
         * @param asmtEvlId
         */
        function savePrevAsmtScore(asmtId, userId, asmtEvlId) {
            const $score = $("#prevScore_" + asmtId);
            const score = $.trim($score.val());

            if (score === "" || isNaN(score)) {
                UiComm.showMessage("<spring:message code='asmt.alert.score.input_num'/><%--점수를 숫자로 입력하세요.--%>", "error");
                return;
            }

            if (Number(score) > 100) {
                UiComm.showMessage("<spring:message code='asmt.alert.score.max_100'/><%--점수는 100점까지 입력 가능합니다.--%>", "error");
                return;
            }

            const param = {
                asmtId: asmtId,
                userId: userId,
                asmtEvlId: asmtEvlId,
                scr: score,
                scoreType: "batch"
            };

            ajaxCall("/asmt2/profAsmtEvlScrModifyAjax.do", param, function (data) {
                if (data.encParams != null && data.encParams != '') {
                    EPARAM = data.encParams;
                }

                if (data.result > 0) {
                    UiComm.showMessage("<spring:message code='asmt.alert.score.save.success'/><%--점수 등록이 완료되었습니다.--%>", "success");
                    location.reload();
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }, function () {
                UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
            }, true);
        }


        /**
         * 제출 내용을 현재 팝업의 상세 영역에 표시한다.
         * @param asmtSbmsnId 과제제출아이디
         */
        function viewPrevSbmsnCts(asmtSbmsnId) {
            const text = prevSbmsnTextMap[asmtSbmsnId] || "";
            $("#prevSbmsnCtsArea").show();
            renderPrevSbmsnTextEditor(text);
            $("#prevSbmsnCtsArea")[0].scrollIntoView({block: "nearest"});
        }

        /**
         * 에디터로 제출한 내용을 읽기 전용 에디터에 표시한다.
         * @param text 제출내용 HTML
         */
        function renderPrevSbmsnTextEditor(text) {
            if (!prevSbmsnTextEditor) {
                prevSbmsnTextEditor = UiEditor({
                    targetId: "prevSbmsnCtsEditor",
                    uploadPath: "/asmt",
                    height: "320px"
                });
            }

            if (prevSbmsnTextEditor && typeof prevSbmsnTextEditor.openHTML === "function") {
                prevSbmsnTextEditor.openHTML(text || "<p><spring:message code='asmt.label.submit.content.empty'/><%--제출내용이 없습니다.--%></p>");
            } else {
                $("#prevSbmsnCtsEditor").val(text || "<spring:message code='asmt.label.submit.content.empty'/><%--제출내용이 없습니다.--%>");
            }

            if (prevSbmsnTextEditor && typeof prevSbmsnTextEditor.setMode === "function") {
                prevSbmsnTextEditor.setMode("readonly");
            } else if (prevSbmsnTextEditor && typeof prevSbmsnTextEditor.setReadOnly === "function") {
                prevSbmsnTextEditor.setReadOnly(true);
            }
        }

        /**
         * 제출 내용 상세 영역을 닫는다.
         */
        function closePrevSbmsnCts() {
            if (prevSbmsnTextEditor && typeof prevSbmsnTextEditor.openHTML === "function") {
                prevSbmsnTextEditor.openHTML("");
            } else {
                $("#prevSbmsnCtsEditor").val("");
            }
            $("#prevSbmsnCtsArea").hide();
        }
    </script>
</head>

<body class="modal-page">
<div class="table-wrap">
    <table class="table-type2">
        <colgroup>
            <col style="width:5%">
            <col style="width:10%">
            <col>
            <col>
            <col style="width:7%">
            <col style="width:15%">
            <col style="width:7%">
            <col style="width:10%">
        </colgroup>
        <thead>
        <tr>
            <th>No</th>
            <th><spring:message code='asmt.label.asmt.type'/><%--과제구분--%></th>
            <th><spring:message code='asmt.label.asmt.title'/><%--과제명--%></th>
            <th><spring:message code='asmt.label.send.file'/><%--제출파일--%></th>
            <th><spring:message code='asmt.label.download'/><%--다운로드--%></th>
            <th><spring:message code='asmt.label.submit.dt'/><%--제출일시--%></th>
            <th><spring:message code='asmt.label.score'/><%--점수--%></th>
            <th><spring:message code='asmt.label.score.change'/><%--점수변경--%></th>
        </tr>
        </thead>
        <tbody id="prevAsmtSbmsnTbody">
        </tbody>
    </table>
</div>

<div class="board_top mt20" id="prevSbmsnCtsArea" style="display:none;">
        <h3 class="sub-title m0"><spring:message code='asmt.label.submit.content'/><%--제출내용--%></h3>
        <div class="right-area">
            <button type="button" class="btn basic sm mla" onclick="closePrevSbmsnCts()"><spring:message code='asmt.button.close'/><%--닫기--%></button>
        </div>
    <textarea id="prevSbmsnCtsEditor"></textarea>
</div>

<div class="modal_btns">
    <button type="button" class="btn type2" onclick="window.parent.closeDialog();"><spring:message code='asmt.button.close'/><%--닫기--%></button>
</div>
</body>
</html>
