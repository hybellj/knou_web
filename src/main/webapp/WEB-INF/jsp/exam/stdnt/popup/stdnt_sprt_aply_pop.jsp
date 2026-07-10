<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
	<head>
        <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
            <jsp:param name="module" value="editor,fileuploader"/>
            <jsp:param name="style" value="classroom"/>
        </jsp:include>
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
        var editors = {};
        var midExamBscId = '<c:out value="${stdntInfo.midExamBscId}" />';   // 중간고사 시험 ID
        var lstExamBscId = '<c:out value="${stdntInfo.lstExamBscId}" />';   // 기말고사 시험 ID
        var userId = '<c:out value="${vo.userId}" />';

        function finishUpload() {
            var url = "/common/uploadFileCheck.do";
            var dx = dx5.get("sprtAplyUploader");
            var param = {
                "uploadFiles": dx.getUploadFiles(),
                "uploadPath": dx.getUploadPath()
            };
            ajaxCall(url, param, function(data) {
                if (data.result > 0) {
                    $("#uploadFiles").val(dx.getUploadFiles());
                    $("#uploadPath").val(dx.getUploadPath());
                    registSprtAply();
                } else {
                    UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
                }
            }, function() {
                UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
            }, true);
        }

        /* 장애인/고령자 시험지원 신청 */
        function stdntSprtApply() {
            var editorHtml = editors['editor'].getPublishingHtml();
            var editorText = $("<div>").html(editorHtml).text().trim();
            if (!editorText) {
                UiComm.showMessage("<spring:message code='exam.sprt.pop.guide.msg1'/>", "info");   /* 신청 내용을 입력하세요. */
                return;
            }
            var dx = dx5.get("sprtAplyUploader");
            if (dx && dx.availUpload()) {
                dx.startUpload();
            } else {
                registSprtAply();
            }
        }

        function registSprtAply() {
            var editorHtml = editors['editor'].getPublishingHtml();
            UiComm.showLoading(true);
            $.ajax({
                url: "/exam/examStdntSprtApply.do",
                type: "POST",
                dataType: "json",
                data: {
                    midExamBscId:   midExamBscId,
                    lstExamBscId:   lstExamBscId,
                    userId:         userId,
                    aplyStscd:      'APLY', /* 신청 */
                    addMnts:        $("#addMnts").val(),
                    sprtAplyCts:    editorHtml,
                    uploadFiles:    $("#uploadFiles").val(),
                    uploadPath:     $("#uploadPath").val()
                }
            }).done(function(data) {
                UiComm.showLoading(false);
                if (data.result > 0) {
                    UiComm.showMessage("<spring:message code='exam.sprt.pop.guide.msg2'/>", "success").then(function() { /* 장애인/고령자 시험지원 신청이 완료되었습니다. */
                        window.parent.closeDialog();
                        window.parent.loadSprtAplyInfoList(1);
                    });
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }).fail(function() {
                UiComm.showLoading(false);
                UiComm.showMessage("<spring:message code='exam.error.insert'/>", "error");   /* 저장 중 에러가 발생하였습니다. */
            });
        }

        $(document).ready(function() {
            $("#addMnts").on("change", function() {
                $("#addMnts_label").text("<spring:message code='exam.error.insert'/> (" + $(this).val() + "<spring:message code='exam.label.min.time'/>)");    /* 시간연장 */ /* 분 */
            });
		});
	</script>

	<body class="class ${uiex:getTheme()}">
        <div class="modal-body">
            <div class="msg-box warning">
                <ul class="list-asterisk">
                    <li class="fw-bold">
                        <spring:message code='exam.sprt.pop.guide.msg3'/><!-- 장애인/고령자 시험지원 작성시 주의사항 -->
                    </li>
                </ul>
                <ul class="list-bullet">
                    <li>
                        <spring:message code='exam.sprt.pop.guide.msg4'/><!-- 장애인/고령자 시험지원 기간 신청 기간에 작성/제출합니다. -->
                    </li>
                    <li>
                        <spring:message code='exam.sprt.pop.guide.msg5'/><!-- 승인여부 확인 : 각 과목 강의실로 이동하여 해당 과목의 시험 메뉴에서 확인하고 응시해야 시험지원을 받을 수 있습니다. -->
                    </li>
                    <li>
                        <spring:message code='exam.sprt.pop.guide.msg6'/><!-- 장애인/고령자 시험지원기간을 준수해야 합니다. -->
                    </li>
                </ul>
            </div>

            <div class="table-wrap mb20">
                <table class="table-type2">
                    <colgroup>
                        <col class="width-15per">
                        <col>
                        <col class="width-15per">
                        <col>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th><spring:message code='exam.label.dept' /></th><!-- 학과 -->
                            <td colspan="3">${stdntInfo.deptnm}</td>
                            <th><spring:message code='exam.label.crs.cd' /></th><!-- 학수번호 -->
                            <td colspan="3">${stdntInfo.smstrChrtId}</td>
                        </tr>
                        <tr>
                            <th><spring:message code='exam.label.subject.nm' /></th><!-- 교과명 -->
                            <td colspan="3">${stdntInfo.sbjctnm}</td>
                            <th><spring:message code='exam.label.decls.cls' /></th><!-- 분반 -->
                            <td colspan="3">${stdntInfo.dvclasNcknm}</td>
                        </tr>
                        <tr>
                            <th><spring:message code='exam.label.exam.stare.type' /></th><!-- 시험구분 -->
                            <td colspan="3">${stdntInfo.examGbnnm}</td>
                            <th><spring:message code='exam.label.exam.dttm' /></th><!-- 시험일시 -->
                            <td colspan="3"><uiex:formatDate value="${stdntInfo.midExamPsblSdttm}" type="datetime2"/> / <uiex:formatDate value="${stdntInfo.lstExamPsblSdttm}" type="datetime2"/></td>
                        </tr>
                        <tr>
                            <th><spring:message code='exam.label.tch' /></th><!-- 교수 -->
                            <td colspan="3">${stdntInfo.profnm}</td>
                            <!-- Todo.. SQL에서 튜터 정보 가져올 수 있는지 확인 후 수정.. -->
                            <th><spring:message code='exam.label.tutor' /></th><!-- 튜터 -->
                            <td colspan="3">${stdntInfo.tutnm}</td>
                        </tr>
                        <tr>
                            <th><spring:message code='exam.label.user.rprs.id' /></th><!-- 대표아이디 -->
                            <td colspan="3">${stdntInfo.userRprsId}</td>
                            <th><spring:message code='exam.label.user.no' /></th><!-- 학번 -->
                            <td colspan="3">${stdntInfo.stdntNo}</td>
                        </tr>
                        <tr>
                            <th><spring:message code='exam.label.user.nm' /></th><!-- 이름 -->
                            <td colspan="3">${stdntInfo.usernm}</td>
                            <th><spring:message code='exam.label.mobile.no' /></th><!-- 연락처 -->
                            <td colspan="3">${stdntInfo.mobileNo}</td>
                        </tr>
                        <tr>
                            <th><spring:message code='exam.label.dsbl' />/<spring:message code='exam.label.snrs' /></th><!-- 장애인 --><!-- 고령자 -->
                            <td colspan="3">
                                <select id="addMnts">
                                    <option value="20">장애인</option>
                                    <option value="30">고령자</option>
                                </select>
                            </td>
                            <th><spring:message code='exam.label.exam.req' /></th><!-- 시험지원 -->
                            <td colspan="3" id="addMnts_label"><spring:message code='exam.label.time.late' /> ( <spring:message code='exam.label.min.time' />)</td><!-- 시간연장 --><!-- 분 -->
                        </tr>
                        <tr>
                            <th><spring:message code='exam.label.applicate' /><spring:message code='exam.label.cts' /></th><!-- 신청 --><!-- 내용 -->
                            <td colspan="7" data-th="입력">
                                <li>
                                    <dl>
                                        <dd>
                                            <div class="editor-box">
                                                <label for="sprtAplyCts" class="hide">Content</label>
                                                <textarea id="sprtAplyCts" name="sprtAplyCts" required="true">
                                                </textarea>
                                                <script>
                                                    // HTML 에디터
                                                    editors['editor'] = UiEditor({
                                                        targetId: "sprtAplyCts",
                                                        uploadPath: "/exam",
                                                        height: "150px"
                                                    });
                                                </script>
                                            </div>
                                        </dd>
                                    </dl>
                                </li>
                                </section>
                                <!--//섹션 에디터-->
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code='exam.label.evidence' /></th><!-- 증빙자료 -->
                            <td colspan="7">
                                <uiex:dextuploader
                                    id="sprtAplyUploader"
                                    path="/exam"
                                    limitCount="5"
                                    limitSize="100"
                                    oneLimitSize="100"
                                    listSize="3"
                                    fileList=""
                                    finishFunc="finishUpload()"
                                    allowedTypes="*"
                                />
                                <input type="hidden" id="uploadFiles" name="uploadFiles"/>
                                <input type="hidden" id="uploadPath"  name="uploadPath" value="/exam"/>
                                <small class="note2">
                                    <spring:message code='exam.sprt.pop.guide.msg7' /><!-- 예) 진단서, 장애진단서 등 -->
                                </small>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="mb50">
                <div class="text-center mt30">
                    <spring:message code='exam.label.applicate.dt' /><!-- 신청일 --> : <uiex:formatDate value="${stdntInfo.nowDttm}" type="datetime2"/><br><spring:message code='exam.label.applicate.y' /><!-- 신청자 --> : ${stdntInfo.usernm}
                </div>
            </div>

			<div class="modal_btns">
                <button class="btn type1" onclick="stdntSprtApply()">
                    <spring:message code="exam.button.save" /><!-- 저장 -->
                </button>
                <button class="btn type2" onclick="window.parent.closeDialog();">
                    <spring:message code="exam.button.close" /><!-- 닫기 -->
                </button>
			</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
