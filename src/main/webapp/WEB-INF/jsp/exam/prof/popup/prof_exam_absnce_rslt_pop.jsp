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
        		<div class="left-area fcBlue">
	            	<a>처리내역</a>
        		</div>
        	</div>
            <fmt:parseDate var="aprvdttmFmt" pattern="yyyyMMddHHmmss" value="${absnceRslt.aprvdttm}" />
            <fmt:formatDate var="aprvdttm" pattern="yyyy.MM.dd HH:mm" value="${aprvdttmFmt }" />
            <fmt:parseDate var="psblSdttmFmt" pattern="yyyyMMddHHmmss" value="${absnceRslt.examPsblSdttm}" />
            <fmt:formatDate var="examPsblSdttm" pattern="yyyy.MM.dd HH:mm" value="${psblSdttmFmt }" />
            <!-- 처리내역 Table -->
        	<div class="table-wrap">
                <table class="table-type2">
                    <colgroup>
                        <col class="width-20per" />
                        <col class="" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th><label>처리상태</label></th>
                            <td class="t_left"><pre>${absnceRslt.aplyStscd}</pre></td>
                            <th><label>처리일시</label></th>
                            <td class="t_left"><pre>${aprvdttm}</pre></td>
                        </tr>
                        <tr>
                            <th><label>과목</label></th>
                            <td class="t_left"><pre>${absnceRslt.sbjctnm}</pre></td>
                            <th><label>분반</label></th>
                            <td class="t_left"><pre>${absnceRslt.dvclasNcknm}</pre></td>
                        </tr>
                        <tr>
                            <th><label>처리내용</label></th>
                            <td class="t_left" colspan="3"><pre>${absnceRslt.aprvCts}</pre></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- 결시원 신쳥내역 Table -->
            <div class="board_top margin-top-4">
                <div class="left-area fcBlue">
                    <a>처리내역</a>
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
                        <th><label>학과</label></th>
                        <td class="t_left"><pre>${absnceRslt.deptnm}</pre></td>
                        <th><label>학수번호</label></th>
                        <td class="t_left"><pre>${absnceRslt.smstrChrtId}</pre></td>
                    </tr>
                    <tr>
                        <th><label>교과</label></th>
                        <td class="t_left"><pre>${absnceRslt.sbjctnm}</pre></td>
                        <th><label>분반</label></th>
                        <td class="t_left"><pre>${absnceRslt.dvclasNcknm}</pre></td>
                    </tr>
                    <tr>
                        <th><label>시험구분</label></th>
                        <td class="t_left"><pre>${absnceRslt.examGbnnm}</pre></td>
                        <th><label>시험일시</label></th>
                        <td class="t_left"><pre>${absnceRslt.examPsblSdttm}</pre></td>
                    </tr>
                    <tr>
                        <th><label>교수</label></th>
                        <td class="t_left"><pre>${absnceRslt.profnm}</pre></td>
                        <!-- Todo.. SQL에서 튜터 정보 가져올 수 있는지 확인 후 수정.. -->
                        <th><label>튜터</label></th>
                        <td class="t_left"><pre>${absnceRslt.tutnm}</pre></td>
                    </tr>
                    <tr>
                        <th><label>대표아이디</label></th>
                        <td class="t_left"><pre>${absnceRslt.userRprsId}</pre></td>
                        <th><label>학번</label></th>
                        <td class="t_left"><pre>${absnceRslt.stdntNo}</pre></td>
                    </tr>
                    <tr>
                        <th><label>이름</label></th>
                        <td class="t_left"><pre>${absnceRslt.usernm}</pre></td>
                        <th><label>연락처</label></th>
                        <td class="t_left"><pre>${absnceRslt.mobileNo}</pre></td>
                    </tr>
                    <tr>
                        <th><label>결시사유</label></th>
                        <td class="t_left"><pre>${absnceRslt.absnceTtl}</pre></td>
                        <th><label>적용비율</label></th>
                        <td class="t_left"><pre>${absnceRslt.absnceRfltrt}</pre></td>
                    </tr>
                    <tr>
                        <th><label>결시사유설명</label></th>
                        <td class="t_left" colspan="3"><pre>${absnceRslt.absnceCts}</pre></td>
                    </tr>
                    <tr>
                        <th><label>증빙자료</label></th>
                        <!-- Todo.. 추후 어디에 증빙자료 저장되는지 확인 후 변경 예정 -->
                        <td class="t_left" colspan="3"><pre></pre></td>
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
