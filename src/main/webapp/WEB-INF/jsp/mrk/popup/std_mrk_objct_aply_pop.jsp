<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="classroom"/>
			<jsp:param name="module" value="table"/>
		</jsp:include>
    </head>
    <style>
        .table_list ul.list > li {
            padding: 0.8rem 0.8rem;!important;
        }
    </style>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<body class="modal-page">
        <div id="wrap">
            <h4><spring:message code="common.label.score.objection.yn"/> <spring:message code="score.label.result"/></h4>
            <%--과목정보--%>
            <div class="table_list" >
                <ul class="list">
                    <li class="head" style="max-height: 30%"><label>학과</label></li>
                    <li>${subjectVO.deptnm}</li>
                    <li class="head"><label>과목번호</label></li>
                    <li>${subjectVO.sbjctId}</li>
                </ul>

                <ul class="list">
                    <li class="head"><label>과목</label></li>
                    <li>${subjectVO.sbjctnm}</li>
                    <li class="head"><label>분반</label></li>
                    <li>${subjectVO.dvclasNo}</li>
                </ul>

                <ul class="list">
                    <li class="head"><label>교수</label></li>
                    <li>홍*수</li>
                    <li class="head"><label>튜터</label></li>
                    <li>홍*동</li>
                </ul>
            </div>

                <%--이의신청정보--%>
                <div class="table_list" style="margin-top: 10px;">
                    <ul class="list">
                        <li class="head"><label>대표아이디</label></li>
                        <li><%--${mrkObjctAplyVO.userRprsId}--%></li>
                        <li class="head"><label>학번</label></li>
                        <li>${mrkObjctAplyVO.stdntNo}</li>
                    </ul>

                    <ul class="list">
                        <li class="head"><label>이름</label></li>
                        <li>${mrkObjctAplyVO.userNm}</li>
                        <li class="head"><label>연락처</label></li>
                        <li>010-1234-45**</li>
                    </ul>

                    <ul class="list" style="min-height: 150px;">
                        <li class="head"><label>신청사유</label></li>
                        <li>${mrkObjctAplyVO.objctAplyCts}</li>
                    </ul>

                    <ul class="list">
                        <li class="head"><label>자료첨부</label></li>
                        <li>
                            <c:if test="${not empty mrkObjctAplyVO.fileList}">
                                <div class="add_file_list">
                                    <uiex:filedownload fileList="${mrkObjctAplyVO.fileList}"/>
                                </div>
                            </c:if>
                            <c:if test="${empty mrkObjctAplyVO.fileList}">
                                <small>첨부된 파일이 없습니다.</small>
                            </c:if>
                        </li>
                    </ul>
                </div>

            <div style="margin-top: 20px; display: flex; justify-content: space-between;">
                <span>처리결과</span>       <small>담당교수: 홍*수 | 등록일 : <uiex:formatDate value="${mrkObjctAplyVO.regDttm}" type="datetime2"/></small>
            </div>
            <div class="table_list">
                <%--처리결과--%>
                <ul class="list" style="min-height: 70px;">
                    <li class="head" style="width: 25%;justify-content: center;"><label>${mrkObjctAplyVO.objctAplySts}</label></li>
                    <li id="objctAplySts">${mrkObjctAplyVO.chgRsn}</li>
                </ul>
            </div>

            <div class="table-wrap" style="margin-top: 5px;">
                <table class="table-type1">
                    <thead>
                        <tr>
                            <th>변경 전 점수</th>
                            <th>변경 후 점수</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>99</td>
                            <td>100</td>
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
