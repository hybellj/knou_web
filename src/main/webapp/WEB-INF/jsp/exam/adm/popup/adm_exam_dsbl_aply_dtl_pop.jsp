<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="classroom"/>
			<jsp:param name="module" value="table"/>
		</jsp:include>
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
        var midExamSprtAplyId   = '<c:out value="${sprtAplyDtl.midExamSprtAplyId}" />';
        var lstExamSprtAplyId   = '<c:out value="${sprtAplyDtl.lstExamSprtAplyId}" />';

        /* 승인, 반려 기능 */
        function sprtAply(isAccept, isAply) {
            var url = "/exam/admModifySprtAplyStat.do";
            var aplyStscd = isAccept === "Y" ? "APRV" : "RJCT";
            var sprtMidAddMnts = $("input[name='mid-sprt-aply-tycd-rd']:checked").val() === 'Y'
                                    ? $("input[name='mid-sprt-aply-min-rd']:checked").val()
                                    : null;
            var sprtLstAddMnts = $("input[name='lst-sprt-aply-tycd-rd']:checked").val() === 'Y'
                                    ? $("input[name='lst-sprt-aply-min-rd']:checked").val()
                                    : null;
            var data = {
                "aplyStscd"         : aplyStscd,
                "sprtMidAddMnts"    : sprtMidAddMnts,
                "sprtLstAddMnts"    : sprtLstAddMnts,
                "midExamSprtAplyId" : midExamSprtAplyId,
                "lstExamSprtAplyId" : lstExamSprtAplyId
                // "sprtAprvCts"       : sprtAprvCts    /* 추후 추가 가능성 있음 */
            };

            function executeAjax() {
                UiComm.showLoading(true);
                $.ajax({
                    url:            url,
                    async:          false,
                    type:           "POST",
                    dataType:       "json",
                    data:           data,
                }).done(function(data) {
                    UiComm.showLoading(false);
                    if (data.result > 0) {
                        UiComm.showMessage("<spring:message code='exam.alert.insert' />", "info")   /* 정상 저장 되었습니다. */
                            .then(function() {
                                window.parent.loadSprtAplyInfoList(1);
                                window.parent.closeDialog();
                            });
                    } else {
                        UiComm.showMessage(data.message, "error");
                    }
                }).fail(function() {
                    UiComm.showLoading(false);
                    UiComm.showMessage("<spring:message code='exam.error.insert' />", "error"); /* 저장 중 에러가 발생하였습니다. */
                });
            }

            if (isAccept === "Y") {
                UiComm.showMessage("<spring:message code='exam.confirm.approve' />", "confirm") /* 요청 승인 하시겠습니까? */
                    .then(function(result){
                    if (isAply === "N") {
                        UiComm.showMessage("<spring:message code='exam.alert.msg.aply1' />", "confirm") /* 이미 처리완료한 학습자입니다. 수정하시겠습니까?' */
                            .then(function(result) {
                                if (result)
                                    executeAjax();
                            });
                    } else {
                        executeAjax();
                    }
                });
            } else {
                UiComm.showMessage("<spring:message code='exam.confirm.companion' />?", "confirm")  /* 요청 반려 하시겠습니까? */
                    .then(function(result){
                    if (isAply === "N") {
                        UiComm.showMessage("<spring:message code='exam.alert.msg.aply1' />", "confirm") /* 이미 처리완료한 학습자입니다. 수정하시겠습니까?' */
                            .then(function(result) {
                                if (result)
                                    executeAjax();
                            });
                    } else {
                        executeAjax();
                    }
                });
            }

        }

        /* 라디오 버튼 이벤트 */
        function toggleSprtMinRd(prefix) {
            var isTimeExt = $("input[name='" + prefix + "-sprt-aply-tycd-rd']:checked").val() === 'Y';
            $("input[name='" + prefix + "-sprt-aply-min-rd']").prop('disabled', !isTimeExt);
        }

		$(document).ready(function() {
            toggleSprtMinRd('mid');
            toggleSprtMinRd('lst');
		});
	</script>

	<body class="modal-page">
        <div id="wrap">
        	<div class="board_top">
        		<div class="left-area">
	            	<a><strong><spring:message code='exam.label.std.request' /></strong></a><!-- 학생요청사항 -->
        		</div>
                <div class="right-area">
                    <a href="javascript:sprtAply('Y', '${sprtAplyDtl.gubun}')" class="btn type1"><spring:message code='exam.label.approve' /></a><!-- 승인 -->
                    <a href="javascript:sprtAply('N', '${sprtAplyDtl.gubun}')" class="btn type2"><spring:message code='exam.label.companion' /></a><!-- 반려 -->
                </div>
        	</div>
            <fmt:parseDate var="midExamPsblSdttmFmt" pattern="yyyyMMddHHmmss" value="${sprtAplyDtl.midExamPsblSdttm}" />
            <fmt:formatDate var="midExamPsblSdttm" pattern="yyyy.MM.dd HH:mm" value="${midExamPsblSdttmFmt}" />
            <fmt:parseDate var="lstExamPsblSdttmFmt" pattern="yyyyMMddHHmmss" value="${sprtAplyDtl.lstExamPsblSdttm}" />
            <fmt:formatDate var="lstExamPsblSdttm" pattern="yyyy.MM.dd HH:mm" value="${lstExamPsblSdttmFmt}" />
            <!-- 처리내역 Table -->
        	<div class="table-wrap">
                <table class="table-type2">
                    <colgroup>
                        <col class="width-20per" />
                        <col class="" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th><label><spring:message code='exam.label.dept' /></label></th><!-- 학과 -->
                            <td class="t_left"><pre>${sprtAplyDtl.deptnm}</pre></td>
                        </tr>
                        <tr>
                            <th><label><spring:message code='exam.label.crs' /></label></th><!-- 과목 -->
                            <td class="t_left"><pre>${sprtAplyDtl.sbjctnm}</pre></td>
                            <th><label><spring:message code='exam.label.decls.cls' /></label></th><!-- 분반 -->
                            <td class="t_left"><pre>${sprtAplyDtl.dvclasNcknm}</pre></td>
                        </tr>
                        <tr>
                            <th><label>시험구분</label></th><!-- 시험구분 -->
                            <td class="t_left"><pre>${sprtAplyDtl.examGbnnm}</pre></td>
                            <th><label>시험일시</label></th><!-- 시험일시 -->
                            <td class="t_left"><pre>${midExamPsblSdttm} / ${lstExamPsblSdttm}</pre></td>
                        </tr>
                        <tr>
                            <th><label>교수</label></th><!-- 교수 -->
                            <td class="t_left"><pre>${sprtAplyDtl.profnm}</pre></td>
                            <th><label>튜터</label></th><!-- 튜터 -->
                            <td class="t_left"><pre>${sprtAplyDtl.tutnm}</pre></td>
                        </tr>
                        <tr>
                            <th><label><spring:message code='exam.label.user.nm' /></label></th><!-- 이름 -->
                            <td class="t_left"><pre>${sprtAplyDtl.usernm}</pre></td>
                            <th><label><spring:message code='exam.label.user.no' /></label></th><!-- 학번 -->
                            <td class="t_left"><pre>${sprtAplyDtl.stdntNo}</pre></td>
                        </tr>
                        <tr>
                            <th><label><spring:message code='exam.label.mobile.no' /></label></th><!-- 연락처 -->
                            <td class="t_left" colspan="3"><pre>${sprtAplyDtl.mobileNo}</pre></td>
                        </tr>
                        <!-- 고령자 -->
                        <c:if test = "${sprtAplyDtl.userStatus eq 'Seniors'}">
                            <tr>
                                <th><label><spring:message code='exam.label.dsbl' />/<spring:message code='exam.label.snrs' /></label></th><!-- 장애인 --><!-- 고령자 -->
                                <td class="t_left"><pre><spring:message code='exam.label.snrs' /></pre></td><!-- 고령자 -->
                                <th><label>시험지원방식</label></th><!-- 시험지원방식 -->
                                <td class="t_left"><pre>${sprtAplyDtl.examSprtAplyTynm}</pre></td>
                            </tr>
                        </c:if>
                        <!-- 장애인 -->
                        <c:if test = "${sprtAplyDtl.userStatus eq 'Disabled'}">
                            <tr>
                                <th><label><spring:message code='exam.label.dsbl' />/<spring:message code='exam.label.snrs' /></label></th><!-- 장애인 --><!-- 고령자 -->
                                <td class="t_left"><pre><spring:message code='exam.label.dsbl' /></pre></td><!-- 장애인 -->
                                <th><label><spring:message code='exam.label.exam' /><spring:message code='exam.label.sprt' /><spring:message code='exam.label.method' /></label></th><!-- 시험 --><!-- 지원 --><!-- 방식 -->
                                <td class="t_left"><pre>${sprtAplyDtl.examSprtAplyTynm}</pre></td>
                            </tr>
                            <tr>
                                <th><label><spring:message code='exam.label.dsbl.req.type' /></label></th><!-- 장애종류 -->
                                <td class="t_left"><pre>${sprtAplyDtl.dsblTynm}</pre></td>
                                <th><label><spring:message code='exam.label.dsbl.req.grade' /></label></th><!-- 장애 등급 -->
                                <td class="t_left"><pre>${sprtAplyDtl.dsblGrdnm}</pre></td>
                            </tr>
                        </c:if>
                        <tr>
                            <th><spring:message code='exam.label.applicate' /><spring:message code='exam.label.cts' /></th><!-- 신청내용 -->
                            <td colspan="3">
                                <div class="tb_content">
                                    ${sprtAplyDtl.sprtAplyCts}
<%--                                    <textarea class="form-control wmax" rows="4" id="contTextarea" readonly>${sprtAplyDtl.sprtAplyCts}</textarea>--%>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code='exam.label.evidence' /></th><!-- 증빙자료 -->
                            <td colspan="3">
                                <c:choose>
                                    <c:when test="${not empty sprtAplyDtl.fileList}">
                                        <uiex:filedownload fileList="${sprtAplyDtl.fileList}"/>
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <a class = "fcBlue"><pre><spring:message code='exam.label.exam.dsbl.req.info.msg6' /></pre></a><!-- 장애등급에 맞춰 연장시간이 기본으로 설정되어 있습니다. 과목/학생의 특성에 따라 조정이 필요한 경우 조정됩니다. -->
            <!-- 중간고사 -->
            <div class="board_top margin-top-4">
                <div class="left-area">
                    <a><strong><spring:message code='exam.label.mid.exam' /></strong></a><!-- 중간고사 -->
                </div>
            </div>
            <div class="table-wrap">
                <table class="table-type2">
                    <colgroup>
                        <col class="width-20per" />
                        <col class="" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th><label><spring:message code='exam.label.std.applicate.type' /></label></th><!-- 학생신청 지원방식 -->
                            <td class="t_left"><pre>${sprtAplyDtl.examSprtAplyTynm}</pre></td>
                            <th><label><spring:message code='exam.label.exam.time' /></label></th><!-- 시험시간 -->
                            <td class="t_left"><pre>${sprtAplyDtl.midExamMnts} <spring:message code='exam.label.min.time' /></pre></td><!-- 분 -->
                        </tr>
                        <tr>
                            <th><label class="req"><spring:message code='exam.label.exam.support.detail' /></label></th><!-- 시험지원사항 -->
                            <td class="t_left" colspan="3">
                                <div class="form-inline">
                                    <span class="custom-input">
                                        <input type="radio" name="mid-sprt-aply-tycd-rd" id="mid-sprt-aply-tycd-y-rd" value="Y" checked onchange="toggleSprtMinRd('mid')">
                                        <label for="mid-sprt-aply-tycd-y-rd"><spring:message code='exam.label.time.late' /></label><!-- 시간연장 -->
                                    </span>
                                    <span class="custom-input ml5">
                                        <input type="radio" name="mid-sprt-aply-tycd-rd" id="mid-sprt-aply-tycd-n-rd" value="N" onchange="toggleSprtMinRd('mid')">
                                        <label for="mid-sprt-aply-tycd-n-rd"><spring:message code='exam.label.not.late.time' /></label><!-- 부여하지 않음 -->
                                    </span>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th><label class="req"><spring:message code='exam.label.late.time' /></label></th><!-- 연장시간 -->
                            <td class="t_left" colspan="3">
                                <div class="form-inline">
                                    <span class="custom-input">
                                        <input type="radio" name="mid-sprt-aply-min-rd" id="mid-sprt-aply-min-10-rd" value="10" checked>
                                        <label for="mid-sprt-aply-min-10-rd">10 <spring:message code='exam.label.min.time' /></label><!-- 분 -->
                                    </span>
                                    <span class="custom-input ml5">
                                        <input type="radio" name="mid-sprt-aply-min-rd" id="mid-sprt-aply-min-15-rd" value="15">
                                        <label for="mid-sprt-aply-min-15-rd">15 <spring:message code='exam.label.min.time' /></label><!-- 분 -->
                                    </span>
                                    <span class="custom-input ml5">
                                        <input type="radio" name="mid-sprt-aply-min-rd" id="mid-sprt-aply-min-20-rd" value="20">
                                        <label for="mid-sprt-aply-min-20-rd">20 <spring:message code='exam.label.min.time' /></label><!-- 분 -->
                                    </span>
                                    <span class="custom-input ml5">
                                        <input type="radio" name="mid-sprt-aply-min-rd" id="mid-sprt-aply-min-30-rd" value="30">
                                        <label for="mid-sprt-aply-min-30-rd">30 <spring:message code='exam.label.min.time' /></label><!-- 분 -->
                                    </span>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- 기말고사 -->
            <div class="board_top margin-top-4">
                <div class="left-area">
                    <a><strong><spring:message code='exam.label.end.exam' /></strong></a><!-- 기말고사 -->
                </div>
            </div>
            <div class="table-wrap">
                <table class="table-type2">
                    <colgroup>
                        <col class="width-20per" />
                        <col class="" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th><label><spring:message code='exam.label.std.applicate.type' /></label></th><!-- 학생신청 지원방식 -->
                            <td class="t_left"><pre>${sprtAplyDtl.examSprtAplyTynm}</pre></td>
                            <th><label><spring:message code='exam.label.exam.time' /></label></th><!-- 시험시간 -->
                            <td class="t_left"><pre>${sprtAplyDtl.lstExamMnts} <spring:message code='exam.label.min.time' /></pre></td><!-- 분 -->
                        </tr>
                        <tr>
                            <th><label class="req"><spring:message code='exam.label.exam.support.detail' /></label></th><!-- 시험지원사항 -->
                            <td class="t_left" colspan="3">
                                <div class="form-inline">
                                    <span class="custom-input">
                                        <input type="radio" name="lst-sprt-aply-tycd-rd" id="lst-sprt-aply-tycd-y-rd" value="Y" checked onchange="toggleSprtMinRd('lst')">
                                        <label for="lst-sprt-aply-tycd-y-rd"><spring:message code='exam.label.time.late' /></label><!-- 시간연장 -->
                                    </span>
                                    <span class="custom-input ml5">
                                        <input type="radio" name="lst-sprt-aply-tycd-rd" id="lst-sprt-aply-tycd-n-rd" value="N" onchange="toggleSprtMinRd('lst')">
                                        <label for="lst-sprt-aply-tycd-n-rd"><spring:message code='exam.label.not.late.time' /></label><!-- 부여하지 않음 -->
                                    </span>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th><label class="req"><spring:message code='exam.label.late.time' /></label></th><!-- 연장시간 -->
                            <td class="t_left" colspan="3">
                                <div class="form-inline">
                                    <span class="custom-input">
                                        <input type="radio" name="lst-sprt-aply-min-rd" id="lst-sprt-aply-min-10-rd" value="10" checked>
                                        <label for="lst-sprt-aply-min-10-rd">10 <spring:message code='exam.label.min.time' /></label><!-- 분 -->
                                    </span>
                                    <span class="custom-input ml5">
                                        <input type="radio" name="lst-sprt-aply-min-rd" id="lst-sprt-aply-min-15-rd" value="15">
                                        <label for="lst-sprt-aply-min-15-rd">15 <spring:message code='exam.label.min.time' /></label><!-- 분 -->
                                    </span>
                                    <span class="custom-input ml5">
                                        <input type="radio" name="lst-sprt-aply-min-rd" id="lst-sprt-aply-min-20-rd" value="20">
                                        <label for="lst-sprt-aply-min-20-rd">20 <spring:message code='exam.label.min.time' /></label><!-- 분 -->
                                    </span>
                                    <span class="custom-input ml5">
                                        <input type="radio" name="lst-sprt-aply-min-rd" id="lst-sprt-aply-min-30-rd" value="30">
                                        <label for="lst-sprt-aply-min-30-rd">30 <spring:message code='exam.label.min.time' /></label><!-- 분 -->
                                    </span>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
			<div class="btns">
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
			</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js