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
	            	<a><strong>요청사항</strong></a>
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
                            <th><label>학번</label></th>
                            <td class="t_left"><pre>${dsblDtl.stdntNo}</pre></td>
                            <th><label>이름</label></th>
                            <td class="t_left"><pre>${dsblDtl.usernm}</pre></td>
                        </tr>
                        <tr>
                            <th><label>학과</label></th>
                            <td class="t_left"><pre>${dsblDtl.deptnm}</pre></td>
                            <th><label>연락처</label></th>
                            <td class="t_left"><pre>${dsblDtl.mobileNo}</pre></td>
                        </tr>
                        <!-- 고령자 -->
                        <c:if test = "${dsblDtl.userStatus eq 'Seniors'}">
                            <tr>
                                <th><label>장애인/고령자</label></th>
                                <td class="t_left" colspan="3"><pre>고령자</pre></td>
                            </tr>
                        </c:if>
                        <!-- 장애인 -->
                        <c:if test = "${dsblDtl.userStatus eq 'Disabled'}">
                            <tr>
                                <th><label>장애인/고령자</label></th>
                                <td class="t_left" colspan="3"><pre>장애인</pre></td>
                            </tr>
                            <tr>
                                <th><label>장애종류</label></th>
                                <td class="t_left"><pre>${dsblDtl.dsblTynm}</pre></td>
                                <th><label>장애등급</label></th>
                                <td class="t_left"><pre>${dsblDtl.dsblGrdnm}</pre></td>
                            </tr>
                            <tr>
                                <th><label>부 장애종류</label></th>
                                <td class="t_left"><pre>${dsblDtl.scndDsblTynm}</pre></td>
                                <th><label>부 장애등급</label></th>
                                <td class="t_left"><pre>${dsblDtl.scndDsblGrdnm}</pre></td>
                            </tr>
                        </c:if>
                        <tr>
                            <th><label>과목코드</label></th>
                            <td class="t_left"><pre>${dsblDtl.sbjctId}</pre></td>
                            <th><label>분반</label></th>
                            <td class="t_left"><pre>${dsblDtl.dvclasNcknm}</pre></td>
                        </tr>
                        <tr>
                            <th><label>과목</label></th>
                            <td class="t_left"><pre>${dsblDtl.sbjctnm}</pre></td>
                            <th><label>신청일시</label></th>
                            <td class="t_left"><pre>신청 : ${regDttm}</pre></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <a class = "fcBlue">장애등급에 맞춰 연장시간이 기본으로 설정되어 있습니다. 과목/학생의 특성에 따라 조정이 필요한 경우 조정됩니다.</a>
            <!-- 중간고사 -->
            <div class="board_top margin-top-4">
                <div class="left-area">
                    <a><strong>중간고사</strong></a>
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
                            <th><label>학생신청 지원방식</label></th>
                            <td class="t_left"><pre>${dsblDtl.examSprtAplyTynm}</pre></td>
                            <th><label>시험시간</label></th>
                            <td class="t_left"><pre>${dsblDtl.midExamMnts}분</pre></td>
                        </tr>
                        <tr>
                            <th><label>시험지원사항</label></th>
                            <td class="t_left" colspan="3"><pre>${dsblDtl.examSprtAplyTynm}</pre></td>
                        </tr>
                        <tr>
                            <th><label>연장시간</label></th>
                            <td class="t_left" colspan="3"><pre>연장 (${dsblDtl.sprtMidAddMnts}분)</pre></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- 기말고사 -->
            <div class="board_top margin-top-4">
                <div class="left-area">
                    <a><strong>기말고사</strong></a>
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
                        <th><label>학생신청 지원방식</label></th>
                        <td class="t_left"><pre>${dsblDtl.examSprtAplyTynm}</pre></td>
                        <th><label>시험시간</label></th>
                        <td class="t_left"><pre>${dsblDtl.lstExamMnts}분</pre></td>
                    </tr>
                    <tr>
                        <th><label>시험지원사항</label></th>
                        <td class="t_left" colspan="3"><pre>${dsblDtl.examSprtAplyTynm}</pre></td>
                    </tr>
                    <tr>
                        <th><label>연장시간</label></th>
                        <td class="t_left" colspan="3"><pre>연장 (${dsblDtl.sprtLstAddMnts}분)</pre></td>
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
