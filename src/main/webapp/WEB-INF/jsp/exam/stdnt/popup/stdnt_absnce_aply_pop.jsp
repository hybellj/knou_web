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
        var isReject = '<c:out value="${isReject}" />';
        var examBscId = '<c:out value="${vo.examBscId}" />';
        var userId = '<c:out value="${vo.userId}" />';

        function finishUpload() {
            var url = "/common/uploadFileCheck.do";
            var dx = dx5.get("sbstAsmtUploader");
            var param = {
                "uploadFiles": dx.getUploadFiles(),
                "uploadPath": dx.getUploadPath()
            };
            ajaxCall(url, param, function(data) {
                if (data.result > 0) {
                    $("#uploadFiles").val(dx.getUploadFiles());
                    $("#uploadPath").val(dx.getUploadPath());
                    registAbsnce();
                } else {
                    UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
                }
            }, function() {
                UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
            }, true);
        }

        function stdntAbsnceApply() {
            var editorHtml = editors['editor'].getPublishingHtml();
            var editorText = $("<div>").html(editorHtml).text().trim();
            if (!editorText) {
                UiComm.showMessage("<spring:message code='exam.absnce.aply.pop.guide.msg1'/>", "info"); /* 결시사유 설명을 입력하세요. */
                return;
            }
            var dx = dx5.get("sbstAsmtUploader");
            if (dx && dx.availUpload()) {
                dx.startUpload();
            } else {
                registAbsnce();
            }
        }

        function registAbsnce() {
            var editorHtml = editors['editor'].getPublishingHtml();
            var editorText = $("<div>").html(editorHtml).text().trim();
            var absnceTtl = editorText.substring(0, 10);
            UiComm.showLoading(true);
            $.ajax({
                url: "/exam/examStdntAbsnceApply.do",
                type: "POST",
                dataType: "json",
                data: {
                    examBscId:       examBscId,
                    userId:          userId,
                    absnceTtl:       absnceTtl,
                    absnceCts:       editorHtml,
                    absnceAplyStscd: '<c:out value="${absnceRslt.absnceAplyStscd}"/>',
                    absnceRfltrt:    $("#absnceRfltrt").val(),
                    uploadFiles:     $("#uploadFiles").val(),
                    uploadPath:      $("#uploadPath").val()
                }
            }).done(function(data) {
                UiComm.showLoading(false);
                if (data.result > 0) {
                    UiComm.showMessage("<spring:message code='exam.absnce.aply.pop.guide.msg2'/>", "success").then(function() {   /* 결시 신청이 완료되었습니다. */
                        window.parent.closeDialog();
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
            $("#absnceRfltrt").on("change", function() {
                $("#rfltrt").text($(this).val() + "%");
            });
		});
	</script>

	<body class="class ${uiex:getTheme()}">
        <div class="modal-body">
            <div class="msg-box warning">
                <ul class="list-asterisk">
                    <li class="fw-bold">
                        <spring:message code='exam.absnce.aply.pop.guide.msg3'/><!-- 결시 작성시 주의사항 -->
                    </li>
                </ul>
                <ul class="list-bullet">
                    <li>
                        <spring:message code='exam.absnce.aply.pop.guide.msg4'/><!-- 결시 사유 발생 : 정해진 일시에 시험에 응시하지 못하는 사유가 발행했을 경우 결시 작성/제출합니다. -->
                    </li>
                    <li>
                        <spring:message code='exam.absnce.aply.pop.guide.msg5'/><!-- 결시 승인여부 확인 및 코멘트 확인 : 각 과목 강의실로 이동하여 해당 과목의 대처 방안(대체과제유무 등)을 반드시 확인하여 응시하여야 성적을 부여 받을 수 있습니다. -->
                    </li>
                    <li>
                        <spring:message code='exam.absnce.aply.pop.guide.msg6'/><!-- 결시 제출기간을 준수해야 합니다. -->
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
                            <td colspan="3">${absnceRslt.deptnm}</td>
                            <th><spring:message code='exam.label.crs.cd' /></th><!-- 학수번호 -->
                            <td colspan="3">${absnceRslt.smstrChrtId}</td>
                        </tr>
                        <tr>
                            <th><spring:message code='exam.label.subject.nm' /></th><!-- 교과명 -->
                            <td colspan="3">${absnceRslt.sbjctnm}</td>
                            <th><spring:message code='exam.label.decls.cls' /></th><!-- 분반 -->
                            <td colspan="3">${absnceRslt.dvclasNcknm}</td>
                        </tr>
                        <tr>
                            <th><spring:message code='exam.label.exam.stare.type' /></th><!-- 시험구분 -->
                            <td colspan="3">${absnceRslt.examGbnnm}</td>
                            <th><spring:message code='exam.label.exam.dttm' /></th><!-- 시험일시 -->
                            <td colspan="3"><uiex:formatDate value="${absnceRslt.examPsblSdttm}" type="datetime2"/></td>
                        </tr>
                        <tr>
                            <th><spring:message code='exam.label.tch' /></th><!-- 교수 -->
                            <td colspan="3">${absnceRslt.profnm}</td>
                            <!-- Todo.. SQL에서 튜터 정보 가져올 수 있는지 확인 후 수정.. -->
                            <th><spring:message code='exam.label.tutor' /></th><!-- 튜터 -->
                            <td colspan="3">${absnceRslt.tutnm}</td>
                        </tr>
                        <tr>
                            <th><spring:message code='exam.label.user.rprs.id' /></th><!-- 대표아이디 -->
                            <td colspan="3">${absnceRslt.userRprsId}</td>
                            <th><spring:message code='exam.label.user.no' /></th><!-- 학번 -->
                            <td colspan="3">${absnceRslt.stdntNo}</td>
                        </tr>
                        <tr>
                            <th><spring:message code='exam.label.user.nm' /></th><!-- 이름 -->
                            <td colspan="3">${absnceRslt.usernm}</td>
                            <th><spring:message code='exam.label.mobile.no' /></th><!-- 연락처 -->
                            <td colspan="3">${absnceRslt.mobileNo}</td>
                        </tr>
                        <tr>
                            <th><spring:message code='exam.label.absent.cts' /></th><!-- 결시사유 -->
                            <td colspan="3">
                                <select id="absnceRfltrt">
                                    <option value="10">10%</option>
                                    <option value="30">30%</option>
                                    <option value="50">50%</option>
                                    <option value="70">70%</option>
                                    <option value="90">90%</option>
                                </select>
                            </td>
                            <th><spring:message code='exam.label.appl.rate' /></th><!-- 적용비율 -->
                            <td colspan="3" id="rfltrt">0%</td>
                        </tr>
                        <tr>
                            <th><spring:message code='exam.label.absent.cts.detail' /></th><!-- 결시사유설명 -->
                            <td colspan="7" data-th="입력">
                                <li>
                                    <dl>
                                        <dd>
                                            <div class="editor-box">
                                                <label for="absnceCts" class="hide">Content</label>
                                                <textarea id="absnceCts" name="absnceCts" required="true">
                                                    <c:out value="${absnceRslt.absnceCts}"/>
                                                </textarea>
                                                <script>
                                                    // HTML 에디터
                                                    editors['editor'] = UiEditor({
                                                        targetId: "absnceCts",
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
                                    id="sbstAsmtUploader"
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
                                    <spring:message code='exam.label.evidence.example.info' /><!-- 예 : 진단서, 입원확인서, 출장확인서, 훈련통지서 등 -->
                                </small>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="mb50">
                <b>
                    <spring:message code='exam.label.absent.msg' /><!-- 이상의 결시사유를 담당 과목 교수님께 보고 드립니다. -->
                </b>
                <div class="text-center mt30">
                    <spring:message code='exam.label.applicate.dt' /><!-- 신청일 --> : <uiex:formatDate value="${absnceRslt.nowDttm}" type="datetime2"/><br><spring:message code='exam.label.applicate.y' /><!-- 신청자 --> : ${absnceRslt.usernm}
                </div>
            </div>

			<div class="modal_btns">
                <button class="btn type1" onclick="stdntAbsnceApply()">
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
