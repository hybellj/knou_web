<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="editor,fileuploader"/>
    </jsp:include>
</head>
<style>
    .table_list ul.list > li {
        padding: 0.8rem 0.8rem;!important;
    }
     #fileUploader_box {
         width: 100%;
     }
</style>

<script type="text/javascript">
    const EPARAM = "${encParams}";

    // 폼 검증 후 저장
    function validateForm() {

        UiValidator("applyForm") // 입력필드 검증
        .then(function(result) {
            if (result) {
                let dx = dx5.get("fileUploader");
                // 첨부파일 있으면 업로드
                // 첨부파일 에러로 인해 임시 주석처리
               /* if (dx.availUpload()) {
                    dx.startUpload();
                }
                // 첨부파일 없으면 저장 호출
                else {
                    applyRegist();
                }*/
                <c:choose>
                <c:when test="${applyInfo.gubun eq 'edit'}">
                applyModify();// 수정
                </c:when>

                <c:otherwise>
                applyRegist(); // 저장
                </c:otherwise>

                </c:choose>
            }
        });
    }

    <c:choose>
    <c:when test="${applyInfo.gubun eq 'edit'}">
    // 수정
    function applyModify() {
        // 첨부파일 에러로 인해 임시 주석처리
        // let dx = dx5.get("fileUploader");
        // $("#delFileIdStr").val(dx.getDelFileIdStr()); // 삭제파일 ID 설정

        const url = "/mrk/stdMrkObjctAplyModifyAjax.do";
        const param = $("#applyForm").serialize();

        $.post(url, param, function (data) {
            if (data.result > 0) {
                UiComm.showMessage(data.message, "success")
                    .then(function (){
                        parent.location.reload(); // 부모창 새로고침
                        parent.closeDialog();
                    });
            } else {
                UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error") // 에러 메세지
            }
        });
    }

    // 삭제
    function applyDelete() {
        const url = "/mrk/stdMrkObjctAplyDeleteAjax.do";
        const param = {
            "encParams": EPARAM,
            // 첨부파일 에러로 인해 임시 주석처리
            // "uploadFiles": dx.getUploadFiles(),
            // "uploadPath": dx.getUploadPath(),
            "mrkObjctAplyId": $("#mrkObjctAplyId").val()
        };

        $.post(url, param, function (data) {
            if (data.result > 0) {
                UiComm.showMessage(data.message, "success")
                    .then(function (){
                        parent.location.reload(); // 부모창 새로고침
                        parent.closeDialog();
                    });
            } else {
                UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error") // 에러 메세지
            }
        });
    }

    </c:when>
    <c:otherwise>

    // 저장
    function applyRegist() {

        // 첨부파일 에러로 인해 임시 주석처리
        // let dx = dx5.get("fileUploader");
        // $("#delFileIdStr").val(dx.getDelFileIdStr()); // 삭제파일 ID 설정

        const url = "/mrk/stdMrkObjctAplyRegistAjax.do";
        const param = $("#applyForm").serialize();

        $.post(url, param, function (data) {
            if (data.result > 0) {
                UiComm.showMessage(data.message, "success")
                .then(function (){
                    parent.location.reload(); // 부모창 새로고침
                    parent.closeDialog();
                });
            } else {
                UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error") // 에러 메세지
            }
        });
    }
    </c:otherwise>
    </c:choose>

    // 파일 업로드 완료
    function finishUpload(uploaderId) {
        let url = "/common/uploadFileCheck.do"; // 업로드된 파일 검증 URL
        let dx = dx5.get(uploaderId);
        let data = {
            "uploadFiles": dx.getUploadFiles(),
            "uploadPath": dx.getUploadPath()
        };

        // 업로드된 파일 체크
        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                $("#uploadFiles").val(dx.getUploadFiles());

                // 이의신청 등록 호출
                applyRegist();
            } else {
                UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
            }
        },
        function (xhr, status, error) {
            UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
        });
    }
</script>

<body class="modal-page">

    <div id="loading_page">
        <p><i class="notched circle loading icon"></i></p>
    </div>

    <div id="wrap">
        <h4><spring:message code="common.label.score.objection.yn"/></h4> <%--성적 이의 신청--%>
        <%--과목정보--%>
        <div class="table_list">
            <ul class="list">
                <li class="head" style="max-height: 30%"><label>학과</label></li>
                <li>${sbjctInfo.deptnm}</li>
                <li class="head"><label>과목번호</label></li>
                <li>${sbjctInfo.sbjctId}</li>
            </ul>

            <ul class="list">
                <li class="head"><label>과목</label></li>
                <li>${sbjctInfo.sbjctnm}</li>
                <li class="head"><label>분반</label></li>
                <li>${sbjctInfo.dvclasNo}</li>
            </ul>

            <ul class="list">
                <li class="head"><label>교수</label></li>
                <li>홍*수</li>
                <li class="head"><label>튜터</label></li>
                <li>홍*동</li>
            </ul>
        </div>

        <%--이의신청정보--%>
        <form id="applyForm" name="applyForm" onsubmit="return false;">
            <input type="hidden" name="encParams"       value="${encParams}">
            <input type="hidden" name="gubun"           value="${applyInfo.gubun}" />
            <input type="hidden" id="mrkObjctAplyId" name="mrkObjctAplyId"  value="${applyInfo.mrkObjctAplyId}">

            <input type="hidden" name="uploadFiles"  id="uploadFiles" value="" />
            <input type="hidden" name="uploadPath"   id="uploadPath"  value="${uploadPath}" />
            <input type="hidden" name="delFileIdStr" id="delFileIdStr"  value="" />

            <div class="table_list" style="margin-top: 10px;">
                <ul class="list">
                    <li class="head"><label>대표아이디</label></li>
                    <li>${userInfo.userRprsId}</li>
                    <li class="head"><label>학번</label></li>
                    <li>${userInfo.stdntNo}</li>
                </ul>

                <ul class="list">
                    <li class="head"><label>이름</label></li>
                    <li>${userInfo.usernm}</li>
                    <li class="head"><label>연락처</label></li>
                    <li>${userInfo.mblPhn}</li>
                </ul>

                <ul class="list" style="min-height: 150px;">
                    <li class="head"><label>신청사유</label></li>
                    <li>
                        <div class="editor-box" style="width: 100%">
                            <label for="objctAplyCts" class="hide">Content</label>
                            <textarea id="objctAplyCts" name="objctAplyCts" required="true">
                                <c:if test="${not empty applyInfo}">
                                    <c:out value="${applyInfo.objctAplyCts}"/>
                                </c:if>
                            </textarea>
                            <script>
                                // HTML 에디터
                                let editor = UiEditor({
                                    targetId: "objctAplyCts",
                                    uploadPath: "${uploadPath}",
                                    height: "250px"
                                });
                            </script>
                        </div>
                    </li>
                </ul>
                <ul class="list" style="margin-bottom: 10px;">
                    <li class="head"><label><spring:message code="bbs.label.form_attach_file" /></label></li>
                    <li>
                        <%--<uiex:dextuploader
                                id="fileUploader"
                                path="${uploadPath}"
                                fileList="${applyInfo.fileList}"
                                finishFunc="finishUpload"
                                allowedTypes="*"
                                uiMode="normal"
                        />--%>
                    </li>
                </ul>
            </div>
        </form>

        <span>이상의 성적 이의신청을 담당 과목 교수님께 드립니다.</span>
        <p style="text-align: right; margin-bottom: 5px;">신청일 :${applyDttm}</p>
        <p style="text-align: right">신청자 : ${userInfo.usernm}</p>
        <div class="btns">

            <c:choose>
                <c:when test="${applyInfo.gubun eq 'edit'}">
                    <button class="btn type2" onclick="validateForm();"><spring:message code="button.edit" /></button><%--수정--%>
                    <button class="btn type2" onclick="applyDelete();"><spring:message code="button.delete" /></button><%--삭제--%>
                </c:when>
                <c:otherwise>
                    <button class="btn type2" onclick="validateForm();"><spring:message code="user.title.userinfo.date" /></button><%--신청--%>
                </c:otherwise>
            </c:choose>

            <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
        </div>
    </div>
    <script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
