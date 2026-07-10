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
    <style>
        .profMemo {
            width: 100%;
            height: 100px;
            border-style: solid;
            border-color: lightgrey;
            border-width: 1px;
            border-radius: 0.5rem;
        }
    </style>

	<body class="modal-page">
        <div id="loading_page">
            <p><i class="notched circle loading icon"></i></p>
        </div>

        <div id="wrap" class="modal-body">

            <h4 class="title" ><spring:message code="std.label.learner_info" /></h4><%--수강생 정보--%>
            <div class="table_list">
                <ul class="list">
                    <li class="head" style="width: 7%!important;"><label><spring:message code="dashboard.course" /><%--과목--%></label></li>
                    <li>${mrkDetails.sbjctnm}</li>
                    <li class="head" style="width: 10%!important;"><label><spring:message code="user.title.userinfo.manage.userrprsid" /><%--대표아이디--%></label></li>
                    <li>${mrkDetails.userRprsId}</li>
                    <li class="head" style="width: 8%!important;"><label><spring:message code="std.label.user_id" /><%--학번--%></label></li>
                    <li>${mrkDetails.stdntNo}</li>
                    <li class="head" style="width: 8%!important;"><label><spring:message code="user.title.userinfo.manage.user.nm" /><%--성명--%></label></li>
                    <li>${mrkDetails.usernm}</li>
                </ul>
            </div>


            <div style="margin-top: 15px;">
                <div class="table-wrap">
                    <table class="table-type1">
                        <colgroup>
                            <col style="width:10%">
                            <col style="width:10%">
                            <col style="width:10%">
                            <col style="width:10%">
                            <col style="width:10%">
                            <col style="width:10%">
                            <col style="width:10%">
                            <col style="width:10%">
                            <col style="width:10%">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>구분</th>
                                <th>중간고사</th>
                                <th>기말고사</th>
                                <th>출석</th>
                                <th>과제</th>
                                <th>토론</th>
                                <th>퀴즈</th>
                                <th>설문</th>
                                <th>세미나</th>
                                <th>합계</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>평가비중</td>
                                <c:forEach items="${mrkItmStngList}" var="item">
                                <td>${item.mrkRfltrt}%</td>
                                </c:forEach>
                                <td>${totalRatio}%</td>
                            </tr>
                            <tr>
                                <td>취득점수</td>
                                <td>${mrkDetails.midexamAcqsScr}</td>
                                <td>${mrkDetails.lstexamAcqsScr}</td>
                                <td>${mrkDetails.atndAcqsScr}</td>
                                <td>${mrkDetails.asmtAcqsScr}</td>
                                <td>${mrkDetails.dscsAcqsScr}</td>
                                <td>${mrkDetails.quizAcqsScr}</td>
                                <td>${mrkDetails.srvyAcqsScr}</td>
                                <td>${mrkDetails.smnrAcqsScr}</td>
                                <td>${mrkDetails.totAcqsScr}</td>
                            </tr>
                            <tr>
                                <td>산출점수</td>
                                <td>${mrkDetails.midexamDrvtnScr}</td>
                                <td>${mrkDetails.lstexamDrvtnScr}</td>
                                <td>${mrkDetails.atndDrvtnScr}</td>
                                <td>${mrkDetails.asmtDrvtnScr}</td>
                                <td>${mrkDetails.dscsDrvtnScr}</td>
                                <td>${mrkDetails.quizDrvtnScr}</td>
                                <td>${mrkDetails.srvyDrvtnScr}</td>
                                <td>${mrkDetails.smnrDrvtnScr}</td>
                                <td>${mrkDetails.totScr}</td>
                            </tr>
                            <tr>
                                <td>가산점</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>${mrkDetails.adtnScr}</td>
                            </tr>
                            <tr>
                                <td>기타점수</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>${mrkDetails.etcScr}</td>
                            </tr>
                            <tr style="background: #f0f2f6;">
                                <td>최종점수</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>${mrkDetails.lstScr}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <h4 class="title"  style="margin-top: 20px"><spring:message code="user.title.userinfo.memo" /></h4><%-- 메모 --%>
            <textarea class="profMemo" readonly>${mrkDetails.profMemo}</textarea>

			<div class="btns">
                <button class="btn type2" onclick="window.parent.closeDialog2();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
			</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
        <script type="text/javascript">
            $(function () {
                // 테이블 데이터 세팅
                // setTableData();
            });

            // 테이블 초기 데이터 세팅
            function setTableData() {
                mrkDtlTable.clearData();

                let dataList = []; // 테이블에 들어갈 데이터 객체 배열

                // 평가비중
                const mrkItmStngList = ${mrkItmStngListJson} || {};
                dataList.push({
                    rowNm: "평가비중",
                    midExam: mrkItmStngList.MIDEXAM,
                    lstExam: mrkItmStngList.LSTEXAM,
                    atndc: mrkItmStngList.ATNDC,
                    asmt: mrkItmStngList.ASMT,
                    dscs: mrkItmStngList.DSCS,
                    quiz: mrkItmStngList.QUIZ,
                    srvy: mrkItmStngList.SRVY,
                    smnr: mrkItmStngList.SMNR,
                    total: "${totalRatio}"
                });

                // 취득점수
                const mrkDetails = ${mrkDetailJson} || {};
                dataList.push({
                    rowNm: "취득점수",
                    midExam: mrkDetails.midexamAcqsScr,
                    lstExam: mrkDetails.lstexamAcqsScr,
                    atndc: mrkDetails.atndAcqsScr,
                    asmt: mrkDetails.asmtAcqsScr,
                    dscs: mrkDetails.dscsAcqsScr,
                    quiz: mrkDetails.quizAcqsScr,
                    srvy: mrkDetails.srvyAcqsScr,
                    smnr: mrkDetails.smnrAcqsScr,
                    total: mrkDetails.totAcqsScr
                });

                // 산출점수
                dataList.push({
                    rowNm: "취득점수",
                    midExam: mrkDetails.midExamDrvtnScr,
                    lstExam: mrkDetails.lstExamDrvtnScr,
                    atndc: mrkDetails.atndcDrvtnScr,
                    asmt: mrkDetails.asmtDrvtnScr,
                    dscs: mrkDetails.dscsDrvtnScr,
                    quiz: mrkDetails.quizDrvtnScr,
                    srvy: mrkDetails.srvyDrvtnScr,
                    smnr: mrkDetails.smnrDrvtnScr,
                    total: mrkDetails.totScr
                });

                // 가산점
                dataList.push({
                    rowNm: "가산점",
                    midExam: "-",
                    lstExam: "-",
                    atndc: "-",
                    asmt: "-",
                    dscs: "-",
                    quiz: "-",
                    srvy: "-",
                    smnr: "-",
                    total: mrkDetails.adtnScr
                });

                // 기타점수
                dataList.push({
                    rowNm: "기타점수",
                    midExam: "-",
                    lstExam: "-",
                    atndc: "-",
                    asmt: "-",
                    dscs: "-",
                    quiz: "-",
                    srvy: "-",
                    smnr: "-",
                    total: mrkDetails.etcScr
                });

                // 최종점수
                dataList.push({
                    rowNm: "최종점수",
                    midExam: "-",
                    lstExam: "-",
                    atndc: "-",
                    asmt: "-",
                    dscs: "-",
                    quiz: "-",
                    srvy: "-",
                    smnr: "-",
                    total: mrkDetails.lstScr
                });

                mrkDtlTable.replaceData(dataList);
            }
        </script>
	</body>
</html>
