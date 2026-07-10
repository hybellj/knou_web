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
                <h4 class="sub-title">
                    <spring:message code='exam.label.process.list' /><!-- 처리내역 -->
                </h4>
            </div>
        </div>
        <!-- 처리내역 Table -->
        <div class="table-wrap">
            <table class="table-type2">
                <colgroup>
                    <col class="width-15per" />
                    <col class="" />
                    <col class="width-15per" />
                    <col class="" />
                </colgroup>
                <tbody>
                    <tr>
                        <th><spring:message code='exam.label.process.status' /></th><!-- 처리상태 -->
                        <td>${absnceRslt.absnceAplyStsnm}</td>
                        <th><spring:message code='exam.label.process.dttm' /></th><!-- 처리일시 -->
                        <td><uiex:formatDate value="${absnceRslt.aprvdttm}" type="datetime2"/></td>
                    </tr>
                    <tr>
                        <th><spring:message code='exam.label.crs' /></th><!-- 과목 -->
                        <td>${absnceRslt.sbjctnm}</td>
                        <th><spring:message code='exam.label.decls.cls' /></th><!-- 분반 -->
                        <td>${absnceRslt.dvclasNcknm}</td>
                    </tr>
                    <tr>
                        <th><spring:message code='exam.label.process.cts' /></th><!-- 처리내용 -->
                        <td colspan="3">
                            <div class="tb_content">
                                <textarea class="form-control wmax" rows="4" id="contTextarea" readonly>${absnceRslt.aprvCts}</textarea>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <!-- 결시원 신쳥내역 Table -->
        <div class="board_top margin-top-4">
            <div class="left-area fcBlue">
                <h4 class="sub-title">
                    <spring:message code='exam.label.exam.absent.applicate.details' /><!-- 결시원 신쳥내역 -->
                </h4>
            </div>
        </div>
        <div class="table-wrap">
            <table class="table-type2">
                <colgroup>
                    <col class="width-15per" />
                    <col class="" />
                    <col class="width-15per" />
                    <col class="" />
                </colgroup>
                <tbody>
                    <tr>
                        <th><spring:message code='exam.label.dept' /></th><!-- 학과 -->
                        <td>${absnceRslt.deptnm}</td>
                        <th><spring:message code='exam.label.crs.cd' /></th><!-- 학수번호 -->
                        <td>${absnceRslt.smstrChrtId}</td>
                    </tr>
                    <tr>
                        <th><spring:message code='exam.label.subject.nm' /></th><!-- 교과명 -->
                        <td>${absnceRslt.sbjctnm}</td>
                        <th><spring:message code='exam.label.decls.cls' /></th><!-- 분반 -->
                        <td>${absnceRslt.dvclasNcknm}</td>
                    </tr>
                    <tr>
                        <th><spring:message code='exam.label.exam.stare.type' /></th><!-- 시험구분 -->
                        <td>${absnceRslt.examGbnnm}</td>
                        <th><spring:message code='exam.label.exam.dttm' /></th><!-- 시험일시 -->
                        <td><uiex:formatDate value="${absnceRslt.examPsblSdttm}" type="datetime2"/></td>
                    </tr>
                    <tr>
                        <th><spring:message code='exam.label.tch' /></th><!-- 교수 -->
                        <td>${absnceRslt.profnm}</td>
                        <!-- Todo.. SQL에서 튜터 정보 가져올 수 있는지 확인 후 수정.. -->
                        <th><spring:message code='exam.label.tutor' /></th><!-- 튜터 -->
                        <td>${absnceRslt.tutnm}</td>
                    </tr>
                    <tr>
                        <th><spring:message code='exam.label.user.rprs.id' /></th><!-- 대표아이디 -->
                        <td>${absnceRslt.userRprsId}</td>
                        <th><spring:message code='exam.label.user.no' /></th><!-- 학번 -->
                        <td>${absnceRslt.stdntNo}</td>
                    </tr>
                    <tr>
                        <th><spring:message code='exam.label.user.nm' /></th><!-- 이름 -->
                        <td>${absnceRslt.usernm}</td>
                        <th><spring:message code='exam.label.mobile.no' /></th><!-- 연락처 -->
                        <td>${absnceRslt.mobileNo}</td>
                    </tr>
                    <tr>
                        <th><spring:message code='exam.label.absent.cts' /></th><!-- 결시사유 -->
                        <td>${absnceRslt.absnceTtl}</td>
                        <th><spring:message code='exam.label.appl.rate' /></th><!-- 적용비율 -->
                        <td>${absnceRslt.absnceRfltrt} %</td>
                    </tr>
                    <tr>
                        <th><spring:message code='exam.label.absent.cts.detail' /></th><!-- 결시사유설명 -->
                        <td colspan="3">
                            <div class="tb_content">
                                ${absnceRslt.absnceCts}
<%--                                <textarea class="form-control wmax" rows="4" id="contTextarea" readonly>${absnceRslt.absnceCts}</textarea>--%>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code='exam.label.evidence' /></th><!-- 증빙자료 -->
                        <td colspan="3">
                            <c:choose>
                                <c:when test="${not empty absnceRslt.fileList}">
                                    <uiex:filedownload fileList="${absnceRslt.fileList}"/>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
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
