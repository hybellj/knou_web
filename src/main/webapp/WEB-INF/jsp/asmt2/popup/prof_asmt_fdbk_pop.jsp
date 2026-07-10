<%@ page import="knou.framework.common.ParamInfo" %>
<%@ page import="knou.framework.common.SubjectInfo" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="editor,fileuploader"/>
    </jsp:include>


    <div id="loading_page">
        <p><i class="notched circle loading icon"></i></p>
    </div>

    <script type="text/javascript">
        let EPARAM = '<c:out value="${encParams}" />';
        const FDBK_POPUP_MODE = '<c:out value="${fdbkPopupMode}" />';
        const IS_STDNT_MODE = FDBK_POPUP_MODE === "STDNT";
        $(document).ready(function () {
            asmtFdbkList();
        });

        /**
         * 과제피드백목록조회
         * @param {String}  asmtId    - 과제아이디
         * @param {String}  userId    - 사용자아이디
         * @returns {list} 과제피드백목록
         */
        function asmtFdbkList() {
            const url = IS_STDNT_MODE ? "/asmt2/stdntAsmtFdbkListAjax.do" : "/asmt2/profAsmtFdbkListAjax.do";

            const extData = {
                "asmtId": "${asmtVO.asmtId}",
                "userId": "${asmtAtndlcVO.userId}"
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
                    let html = createAsmtFdbkListHTML(returnList);	// 과제 피드백 리스트 HTML 생성
                    $("#fdbkListDiv").empty().html(html);
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }, function (xhr, status, error) {
                /* 에러가 발생했습니다! */
                UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");/* 에러가 발생했습니다! */
            }, true);

        }

        /**
         * 과제 피드백 목록 HTML 생성
         * @param list
         * @returns {string}
         */
        function createAsmtFdbkListHTML(list) {
            let html = "";
            if (!list || list.length === 0) {
                html += "<div class='table_list'>";
                html += "    <ul class='list'>";
                html += "        <li>";
            html += "            <div class='tb_content'><spring:message code='asmt.label.feedback.empty'/><%--등록된 피드백이 없습니다.--%></div>";
                html += "        </li>";
                html += "    </ul>";
                html += "</div>";
                return html;
            }

            list.forEach(function (v, i) {
                html += "<div class='board_top'>";
        html += "    <h5 class='sub-title-sm'><i class='xi-comment-o icon' aria-label='<spring:message code='asmt.label.feedback'/><%--피드백--%>'></i>" + UiComm.formatDate(v.regDttm, "datetime2") + "</h5>";
                if (!IS_STDNT_MODE) {
                    html += "	<div class='right-area'>";
        html += "		<button onclick='fdbkModifyFrm(\"" + v.asmtFdbkId + "\", this)' class='btn basic'><spring:message code='asmt.button.modify'/><%--수정--%></button>";
        html += "		<button onclick='fdbkDelete(\"" + v.asmtFdbkId + "\")' class='btn basic'><spring:message code='asmt.button.delete'/><%--삭제--%></button>";
                    html += "	</div>";
                }
                html += "</div>";
                html += "<div class='table_list' id='" + v.asmtFdbkId + "ViewDiv'>";
                html += "    <ul class='list'>";
        html += "        <li class='head'><label><spring:message code='asmt.label.feedback'/><%--피드백--%></label></li>";
                html += "        <li>";
                html += "            <div class='tb_content'>"
                if (v.fdbkCts != null) {
                    html += v.fdbkCts;
                }

                if (v.fileList != null && v.fileList.length > 0) {
                    html += "<div class='add_file_list mt10'>";
                    html += "    <ul class='add_file'>";
                    v.fileList.forEach(function (vv, ii) {
                        html += "    <li>";
                        html += "        <a href='#_' class='file_down' onclick='UiFileDownloader(\"" + vv.encDownParam + "\");return false;'>";
                        html += "            <i class='icon-svg-paperclip' aria-hidden='true'></i>";
                        html += "            <span class='text'>" + vv.filenm + "</span>";
                        if (vv.fileSize != null && vv.fileSize !== "") {
                            html += "        <span class='fileSize'>(" + vv.fileSize + ")</span>";
                        }
                        html += "        </a>";
                        html += "   </li>";
                    });
                    html += "   </ul>";
                    html += "</div>";
                }
                html += "           </div>";
                html += "       </li>";
                html += "    </ul>";
                html += "</div>";
                html += "<div id='" + v.asmtFdbkId + "EditDiv'></div>";
            });

            return html;
        }

        /**
         * 피드백 수정 폼
         * @param asmtFdbkId
         * @param obj
         */
        function fdbkModifyFrm(asmtFdbkId, obj) {
            $(obj).text("<spring:message code='asmt.button.save'/><%--저장--%>");
            $(obj).attr('onclick', "fdbkSaveConfirm('" + asmtFdbkId + "')");

            const url = "/asmt2/asmtFdbkSelectAjax.do";

            const extData = {
                "asmtFdbkId": asmtFdbkId
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
                    const fdbk = data.returnVO;

                    createFdbkHTML(asmtFdbkId + "EditDiv", asmtFdbkId, fdbk);
                    $("#" + asmtFdbkId + "ViewDiv").hide();
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }, function (xhr, status, error) {
                UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");	/* 에러가 발생했습니다! */
            });
        }

        /**
         * 피드백 등록 토글
         * @param obj
         */
        function fdbkRegistToggle(obj) {
            $(obj).toggleClass("on");
            if ($(obj).hasClass("on")) {
            $(obj).text("<spring:message code='asmt.label.feedback'/><%--피드백--%> <spring:message code='asmt.button.cancel'/><%--취소--%>");
                createFdbkHTML("fdbkInputDiv", "");
            } else {
            $(obj).text("<spring:message code='asmt.label.feedback'/><%--피드백--%> <spring:message code='asmt.button.reg'/><%--등록--%>");
                $("#fdbkInputDiv").empty();
            }
        }

        /**
         * 피드백 HTML 생성
         * @param id
         * @param asmtFdbkId
         * @param fdbkVO
         */
        function createFdbkHTML(id, asmtFdbkId, fdbkVO) {
            const fdbkCts = fdbkVO != null ? fdbkVO.fdbkCts : "";
            let html = "";
            html += "<div class='table-wrap mt10'>";
            html += "    <table class='table-type5 in_table'>";
            html += "        <colgroup>";
            html += "            <col class='width-20per' />";
            html += "            <col />";
            html += "        </colgroup>";
            html += "        <tbody>";
            html += "            <tr>";
        html += "                <th><label for='" + asmtFdbkId + "FdbkFrm_fdbkCts'><spring:message code='asmt.label.feedback'/><%--피드백--%></label></th>";
            html += "                <td>";
            html += "                    <form id='" + asmtFdbkId + "FdbkFrm' onsubmit='return false;'>";
            html += "                        <input type='hidden' name='uploadFiles' />";
            html += "                        <input type='hidden' name='uploadPath' value='${asmtVO.uploadPath}' />";
            html += "                        <input type='hidden' name='delFileIdStr' />";
            html += "                        <input type='hidden' name='asmtId' value='${asmtVO.asmtId}' />";
            html += "                        <input type='hidden' name='userId' value='${asmtAtndlcVO.userId}' />";
            html += "                        <input type='hidden' name='asmtFdbkId' value='" + asmtFdbkId + "' />";

            html += "                        <textarea";
            html += "                             rows='2'";
            html += "                             id='" + asmtFdbkId + "FdbkFrm_fdbkCts'";
            html += "                             name='fdbkCts'";
            html += "                             class='form-control width-100per'";
            html += "                             maxLenCheck='byte,2000,true,true'";
        html += "                             placeholder='<spring:message code='asmt.label.input.feedback'/><%--피드백을 입력하세요--%>'>" + fdbkCts + "</textarea>";
            html += "	                    <div class='upload-file'>";
            html += "		                    <div id='" + asmtFdbkId + "FileUploaderWrap' class='width-85per'></div>";
            if (asmtFdbkId == "") {
        html += "                       <button onclick='fdbkSaveConfirm(\"\")' class='btn type1'><spring:message code='asmt.button.save'/><%--저장--%></button>";
            }
            html += "	                    </div>";
            html += "                    </form>";
            html += "                </td>";
            html += "            </tr>";
            html += "        </tbody>";
            html += "    </table>";
            html += "</div>";

            $("#" + id).empty().html(html);

            const uploaderId = asmtFdbkId + "FileUploader";
            const wrapId = asmtFdbkId + "FileUploaderWrap";
            const fileList = fdbkVO != null && fdbkVO.fileList != null ? fdbkVO.fileList : "";

            UiFileUploader({
                id: uploaderId,
                targetId: wrapId,
                path: "${asmtVO.uploadPath}",
                limitCount: 1,
                limitSize: 1024,
                oneLimitSize: 1024,
                listSize: 1,
                fileList: fileList,
                finishFunc: finishUpload,
                allowedTypes: "*",
                uiMode: "simple"
            });
        }

        // 파일 업로드 완료
        function finishUpload(uploaderId) {
            const url = "/common/uploadFileCheck.do"; // 업로드된 파일 검증 URL
            let dx = dx5.get(uploaderId);
            const param = {
                "uploadFiles": dx.getUploadFiles(),
                "uploadPath": dx.getUploadPath()
            };

            // 업로드된 파일 체크
            ajaxCall(url, param, function (data) {
                if (data.encParams != null && data.encParams != '') {
                    EPARAM = data.encParams;
                }
                if (data.result > 0) {
                    const asmtFdbkId = uploaderId.replace("FileUploader", "").trim();
                    $("#" + asmtFdbkId + "FdbkFrm input[name='uploadFiles']").val(dx.getUploadFiles());

                    save(asmtFdbkId);
                } else {
                    UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
                }
            }, function (xhr, status, error) {
                UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
            }, true);
        }

        /**
         * 피드백 저장 확인
         * @param asmtFdbkId
         * @returns {boolean}
         */
        function fdbkSaveConfirm(asmtFdbkId) {
            const fdbkCts = $.trim($("#" + asmtFdbkId + "FdbkFrm textarea[name=fdbkCts]").val());
            let dx = dx5.get(asmtFdbkId + "FileUploader");
            if (fdbkCts == "" && !dx.availUpload()) {
            UiComm.showMessage("<spring:message code='asmt.alert.input.feedback.content.file'/><%--피드백 내용이나 파일첨부를 해주세요.--%>", "warning");
                return false;
            }

            if (dx.availUpload()) {
                dx.startUpload();
            }
            // 첨부파일 없으면 저장 호출
            else {
                save(asmtFdbkId);
            }
        }

        /**
         * 저장
         * @param asmtFdbkId
         */
        function save(asmtFdbkId) {
            let dx = dx5.get(asmtFdbkId + "FileUploader");
            $("#" + asmtFdbkId + "FdbkFrm input[name='delFileIdStr']").val(dx.getDelFileIdStr());	// 삭제파일 ID 설정

            const url = "/asmt2/asmtFdbkModifyAjax.do";

            $.ajax({
                url: url,
                async: false,
                type: "POST",
                dataType: "json",
                data: $("#" + asmtFdbkId + "FdbkFrm").serialize(),
            }).done(function (data) {
                UiComm.showLoading(false);
                if (data.encParams != null && data.encParams != '') {
                    EPARAM = data.encParams;
                }
                if (data.result > 0) {
                    location.reload();
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }).fail(function () {
                UiComm.showLoading(false);
                UiComm.showMessage("<spring:message code='asmt.error.insert' /><%--저장 중 에러가 발생하였습니다.--%>", "error");	/* 저장 중 에러가 발생하였습니다. */
            });
        }

        /**
         * 피드백 삭제
         * @param asmtFdbkId
         */
        function fdbkDelete(asmtFdbkId) {
            const url = "/asmt2/asmtFdbkDeleteAjax.do";
            const extData = {
                asmtFdbkId: asmtFdbkId
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
                    UiComm.showMessage("<spring:message code='asmt.alert.delete' /><%--정상 삭제 되었습니다.--%>", "success", 500)    /* 정상 삭제 되었습니다. */
                    .then(function (result) {
                        location.reload();
                    });
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }, function (xhr, status, error) {
                UiComm.showMessage("<spring:message code='asmt.error.delete' /><%--삭제 중 에러가 발생하였습니다.--%>", "error");/* 삭제 중 에러가 발생하였습니다. */
            }, true);
        }
    </script>
</head>

<body class="modal-page">
<div class="board_top class">
    <h3 class="board-title">
        <%
            String sbjctnm = SubjectInfo.getSbjctnm(request, ParamInfo.getParamValue(request, "sbjctId"));
        %>
        <%=sbjctnm%><%--과목명--%>
        ${asmtVO.dvclasNo }
        <spring:message code='asmt.label.decls.name'/><%--반--%>
    </h3>
    <div class="right-area">
        <c:if test="${fdbkPopupMode ne 'STDNT'}">
    <button type="button" class="btn type2" onclick="fdbkRegistToggle(this)"><spring:message code='asmt.label.feedback'/><%--피드백--%> <spring:message code='asmt.button.reg'/><%--등록--%></button>
        </c:if>
        <div class="feedback-info">
            <p class="desc">
                <span><strong>${asmtAtndlcVO.deptnm }</strong></span>
                <span><strong>${asmtAtndlcVO.userId }</strong></span>
                <span><strong>${asmtAtndlcVO.usernm }</strong></span>
                <c:if test="${asmtAtndlcVO.scr ne '' && asmtAtndlcVO.scr ne NULL && ((fdbkPopupMode ne 'STDNT' && asmtVO.mrkOyn eq 'Y') or (fdbkPopupMode eq 'STDNT' && asmtVO.mrkInqPsblYn eq 'Y'))}">
                    <span class="score"><strong>${asmtAtndlcVO.scr}<spring:message code='asmt.label.point'/><!-- 점 --></strong></span>
                </c:if>

            </p>
        </div>
    </div>
</div>

<div id="fdbkInputDiv"></div>

<div id="fdbkListDiv"></div>

<div class="modal_btns">
    <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code='asmt.button.close'/><%--닫기--%></button><!-- 닫기 -->
</div>
</body>
</html>
