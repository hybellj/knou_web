<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
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
		$(document).ready(function() {
		});
	</script>

	<body class="modal-page">
        <div id="wrap">
        	<div class="board_top">
        		<div class="left-area">
	            	<a><strong><spring:message code='exam.label.std.request' /></strong></a><!-- 학생요청사항 -->
        		</div>
        	</div>
            <fmt:parseDate var="regDttmFmt" pattern="yyyyMMddHHmmss" value="${dsblDtl.regDttm}" />
            <fmt:formatDate var="regDttm" pattern="yyyy.MM.dd HH:mm" value="${regDttmFmt}" />
            <!-- 처리내역 Table -->
        	<div class="table-wrap">
                <table class="table-type2">
                    <colgroup>
                        <col class="width-20per" />
                        <col class="" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th><label><spring:message code='exam.label.user.no' /></label></th><!-- 학번 -->
                            <td class="t_left"><pre>${dsblDtl.stdntNo}</pre></td>
                            <th><label><spring:message code='exam.label.user.nm' /></label></th><!-- 이름 -->
                            <td class="t_left"><pre>${dsblDtl.usernm}</pre></td>
                        </tr>
                        <tr>
                            <th><label><spring:message code='exam.label.dept' /></label></th><!-- 학과 -->
                            <td class="t_left"><pre>${dsblDtl.deptnm}</pre></td>
                            <th><label><spring:message code='exam.label.mobile.no' /></label></th><!-- 연락처 -->
                            <td class="t_left"><pre>${dsblDtl.mobileNo}</pre></td>
                        </tr>
                        <!-- 고령자 -->
                        <c:if test = "${dsblDtl.userStatus eq 'Seniors'}">
                            <tr>
                                <th><label><spring:message code='exam.label.dsbl' />/<spring:message code='exam.label.snrs' /></label></th><!-- 장애인 --><!-- 고령자 -->
                                <td class="t_left" colspan="3"><pre><spring:message code='exam.label.snrs' /></pre></td><!-- 고령자 -->
                            </tr>
                        </c:if>
                        <!-- 장애인 -->
                        <c:if test = "${dsblDtl.userStatus eq 'Disabled'}">
                            <tr>
                                <th><label><spring:message code='exam.label.dsbl' />/<spring:message code='exam.label.snrs' /></label></th><!-- 장애인 --><!-- 고령자 -->
                                <td class="t_left" colspan="3"><pre><spring:message code='exam.label.dsbl' /></pre></td><!-- 장애인 -->
                            </tr>
                            <tr>
                                <th><label><spring:message code='exam.label.dsbl.req.type' /></label></th><!-- 장애종류 -->
                                <td class="t_left"><pre>${dsblDtl.dsblTynm}</pre></td>
                                <th><label><spring:message code='exam.label.dsbl.req.grade' /></label></th><!-- 장애 등급 -->
                                <td class="t_left"><pre>${dsblDtl.dsblGrdnm}</pre></td>
                            </tr>
                        </c:if>
                        <tr>
                            <th><label><spring:message code='exam.label.crs.code' /></label></th><!-- 과목 코드 -->
                            <td class="t_left"><pre>${dsblDtl.sbjctId}</pre></td>
                            <th><label><spring:message code='exam.label.decls.cls' /></label></th><!-- 분반 -->
                            <td class="t_left"><pre>${dsblDtl.dvclasNcknm}</pre></td>
                        </tr>
                        <tr>
                            <th><label><spring:message code='exam.label.crs' /></label></th><!-- 과목 -->
                            <td class="t_left"><pre>${dsblDtl.sbjctnm}</pre></td>
                            <th><label><spring:message code='exam.label.applicate.dttm' /></label></th><!-- 신청일시 -->
                            <td class="t_left"><pre><spring:message code='exam.label.applicate' /> : ${regDttm}</pre></td><!-- 신청 -->
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
                            <td class="t_left"><pre>${dsblDtl.examSprtAplyTynm}</pre></td>
                            <th><label><spring:message code='exam.label.exam.time' /></label></th><!-- 시험시간 -->
                            <td class="t_left"><pre>${dsblDtl.midExamMnts} <spring:message code='exam.label.min.time' /></pre></td><!-- 분 -->
                        </tr>
                        <tr>
                            <th><label><spring:message code='exam.label.exam.support.detail' /></label></th><!-- 시험지원사항 -->
                            <td class="t_left" colspan="3"><pre>${dsblDtl.examSprtAplyTynm}</pre></td>
                        </tr>
                        <tr>
                            <th><label><spring:message code='exam.label.late.time' /></label></th><!-- 연장시간 -->
                            <td class="t_left" colspan="3"><pre><spring:message code='exam.label.late' /> (${dsblDtl.sprtMidAddMnts} <spring:message code='exam.label.min.time' />)</pre></td><!-- 연장 --><!-- 분 -->
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
                        <td class="t_left"><pre>${dsblDtl.examSprtAplyTynm}</pre></td>
                        <th><label><spring:message code='exam.label.exam.time' /></label></th><!-- 시험시간 -->
                        <td class="t_left"><pre>${dsblDtl.lstExamMnts} <spring:message code='exam.label.min.time' /></pre></td><!-- 분 -->
                    </tr>
                    <tr>
                        <th><label><spring:message code='exam.label.exam.support.detail' /></label></th><!-- 시험지원사항 -->
                        <td class="t_left" colspan="3"><pre>${dsblDtl.examSprtAplyTynm}</pre></td>
                    </tr>
                    <tr>
                        <th><label><spring:message code='exam.label.late.time' /></label></th><!-- 연장시간 -->
                        <td class="t_left" colspan="3"><pre><spring:message code='exam.label.late' /> (${dsblDtl.sprtLstAddMnts} <spring:message code='exam.label.min.time' />)</pre></td><!-- 연장 --><!-- 분 -->
                    </tr>
                    </tbody>
                </table>
            </div>
			<div class="btns">
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
			</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
