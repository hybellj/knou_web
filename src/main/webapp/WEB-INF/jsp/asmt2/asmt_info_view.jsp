<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!--accordion-->
<div class="elements_wrap">
    <ul class="accordion">
        <li class=""><!-- 클릭시 active 추가 -->
            <div class="title-wrap">
                <a class="title" href="#">
                    <div class="lecture_tit">
                        <strong><c:out value="${asmtVO.asmtTtl}"/></strong>
                        <p class="desc">
                            <span><spring:message code='asmt.label.send.date'/><!-- 제출기간 --> : <strong><uiex:formatDate type="datetime2" value="${asmtVO.asmtSbmsnSdttm }"/> ~ <uiex:formatDate type="datetime2" value="${asmtVO.asmtSbmsnEdttm }"/></strong></span>
                            <span><spring:message code='asmt.label.score.yn'/><!-- 성적 반영 여부 --> :
                                                    <strong>
                                                        <c:choose>
                                                            <c:when test="${asmtVO.mrkRfltyn eq 'Y'}">
                                                                <spring:message code='asmt.common.yes'/><!-- 예 -->
                                                            </c:when>
                                                            <c:otherwise>
                                                                <spring:message code='asmt.common.no'/><!-- 아니오 -->
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </strong>
                                                </span>
                            <span><spring:message code='asmt.label.score.open'/><%--성적공개--%> :
                                                    <strong>
                                                        <c:choose>
                                                            <c:when test="${asmtVO.mrkOyn eq 'Y'}">
                                                                <spring:message code='asmt.common.yes'/><!-- 예 -->
                                                            </c:when>
                                                            <c:otherwise>
                                                                <spring:message code='asmt.common.no'/><!-- 아니오 -->
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </strong>
                                                </span>
                        </p>
                    </div>
                    <i class="arrow xi-angle-down"></i>
                </a>
            </div>
            <div class="cont">
                <div class="table-wrap">
                    <table class="table-type5">
                        <colgroup>
                            <col class="width-15per"/>
                            <col/>
                        </colgroup>
                        <tbody>

                        <tr>
                            <th><spring:message code='asmt.label.asmt.content'/><!-- 과제내용 --></th>
                            <td>
                                <div class="tb_content">
                                    <c:out value="${asmtVO.asmtCts}" escapeXml="false"/>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th><label><spring:message code='asmt.label.lctr.wkno.setting'/><%--강의목록 주차 설정--%></label></th>
                            <td>
                                <c:out value="${empty asmtVO.lctrWknonm ? '-' : asmtVO.lctrWknonm}"/>
                            </td>
                        </tr>

                        <tr>
                            <th><spring:message code='asmt.label.send.date'/><%--제출기간--%></th>
                            <td>
                                <uiex:formatDate type="datetime2" value="${asmtVO.asmtSbmsnSdttm}"/>
                                ~
                                <uiex:formatDate type="datetime2" value="${asmtVO.asmtSbmsnEdttm}"/>
                            </td>
                        </tr>

                        <tr>
                            <th><spring:message code='asmt.label.score.aply'/><%--성적반영--%></th>
                            <td>
                                <c:choose>
                                    <c:when test="${asmtVO.mrkRfltyn eq 'Y'}"><spring:message code='asmt.common.yes'/><!-- 예 --></c:when>
                                    <c:otherwise><spring:message code='asmt.common.no'/><!-- 아니오 --></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>

                        <tr>
                            <th><spring:message code='asmt.label.score.ratio'/><%--성적반영비율--%></th>
                            <td>
                                <c:choose>
                                    <c:when test="${asmtVO.mrkRfltyn ne 'Y'}">-</c:when>
                                    <c:otherwise>${asmtVO.mrkRfltrt}%</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>

                        <tr>
                            <th><spring:message code='asmt.label.score.open'/><%--성적공개--%></th>
                            <td>
                                <c:choose>
                                    <c:when test="${asmtVO.mrkOyn eq 'Y'}">
                                        <spring:message code='asmt.common.yes'/><!-- 예 -->
                                        <br/>
                                        <uiex:formatDate type="datetime2" value="${asmtVO.mrkInqSdttm}"/>
                                    </c:when>
                                    <c:otherwise><spring:message code='asmt.common.no'/><!-- 아니오 --></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>

                        <tr>
                            <th><spring:message code='asmt.label.eval.method'/><%--평가방법--%></th>
                            <td>
                                <c:choose>
                                    <c:when test="${asmtVO.evlScrTycd eq 'RUBRIC_SCR'}">
                                        <spring:message code='asmt.label.rubric'/><!-- 루브릭 -->
                                        <c:if test="${not empty asmtVO.rubricTtl}">
                                            <a class="link" onclick="rubricPop();"> (<c:out value="${asmtVO.rubricTtl}"/>)</a>
                                        </c:if>
                                    </c:when>

                                    <c:otherwise><spring:message code='asmt.label.point.type'/><!-- 점수형 --></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code='asmt.label.asmt.send.type'/><%--제출형식--%></th>
                            <td>
                                <c:set var="sbmsnFileTypeText" value=""/>
                                <c:set var="sbmsnFileTypeCodes" value=",${asmtVO.sbmsnFileMimeTycd},"/>
                                <c:forEach items="${fn:split(asmtVO.sbmsnFileMimeTycd, ',')}" var="fileTypeCode">
                                    <c:set var="fileTypeName" value=""/>
                                    <c:choose>
                                        <c:when test="${fileTypeCode eq 'img'}"><c:set var="fileTypeName"><spring:message code='asmt.label.image'/><%--이미지--%></c:set></c:when>
                                        <c:when test="${fileTypeCode eq 'pdf' or fileTypeCode eq 'pdf2'}"><c:set var="fileTypeName" value="PDF"/></c:when>
                                        <c:when test="${fileTypeCode eq 'txt'}"><c:set var="fileTypeName" value="TEXT"/></c:when>
                                        <c:when test="${fileTypeCode eq 'soc'}"><c:set var="fileTypeName"><spring:message code='asmt.label.source.file'/><%--소스파일--%></c:set></c:when>
                                        <c:when test="${fileTypeCode eq 'hwp'}"><c:set var="fileTypeName" value="HWP"/></c:when>
                                        <c:when test="${fileTypeCode eq 'doc'}"><c:set var="fileTypeName" value="DOC"/></c:when>
                                        <c:when test="${fileTypeCode eq 'ppt' or fileTypeCode eq 'ppt2'}"><c:set var="fileTypeName" value="PPT"/></c:when>
                                        <c:when test="${fileTypeCode eq 'xls'}"><c:set var="fileTypeName" value="XLS"/></c:when>
                                        <c:when test="${fileTypeCode eq 'zip'}"><c:set var="fileTypeName" value="ZIP"/></c:when>
                                    </c:choose>
                                    <c:if test="${not empty fileTypeName}">
                                        <c:set var="sbmsnFileTypeText" value="${sbmsnFileTypeText}${empty sbmsnFileTypeText ? '' : ', '}${fileTypeName}"/>
                                    </c:if>
                                </c:forEach>
                                <c:choose>
                                    <c:when test="${asmtVO.sbasmtTycd eq 'INPUT_TEXT'}"><spring:message code='asmt.label.text'/><%--텍스트--%>(TEXT)</c:when>
                                    <c:when test="${asmtVO.asmtPrctcyn eq 'Y'}">
                                        <spring:message code='asmt.label.file'/><%--파일--%><c:if test="${not empty sbmsnFileTypeText}"> (<c:out value="${sbmsnFileTypeText}"/>)</c:if>
                                    </c:when>
                                    <c:when test="${empty asmtVO.sbmsnFileMimeTycd}"><spring:message code='asmt.label.file'/><%--파일--%></c:when>
                                    <c:when test="${asmtVO.sbmsnFileMimeTycd eq 'all'}"><spring:message code='asmt.label.file'/><%--파일--%> (<spring:message code='asmt.label.all.file.possible'/><%--모든파일 가능--%>)</c:when>
                                    <c:when test="${fn:contains(sbmsnFileTypeCodes, ',img,') or fn:contains(sbmsnFileTypeCodes, ',pdf,') or fn:contains(sbmsnFileTypeCodes, ',txt,') or fn:contains(sbmsnFileTypeCodes, ',soc,') or fn:contains(sbmsnFileTypeCodes, ',ppt2,')}">
                                        <spring:message code='asmt.label.file'/><%--파일--%> (<spring:message code='asmt.label.preview.possible'/><%--미리보기 가능--%>: <c:out value="${sbmsnFileTypeText}"/>)
                                    </c:when>
                                    <c:otherwise>
                                        <spring:message code='asmt.label.file'/><%--파일--%> (<spring:message code='asmt.label.specific.file.possible'/><%--특정파일 가능--%>: <c:out value="${sbmsnFileTypeText}"/>)
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>

                        <tr>
                            <th><spring:message code='asmt.label.attach.file'/><%--첨부파일--%></th>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty asmtVO.fileList}">
                                        <div class="add_file_list">
                                            <uiex:filedownload fileList="${asmtVO.fileList}"/>
                                        </div>
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>

                        <tr>
                            <th><spring:message code='asmt.label.practice.asmt'/><%--실기과제--%></th>
                            <td>
                                <c:choose>
                                    <c:when test="${asmtVO.asmtPrctcyn eq 'Y'}">
                                        <spring:message code='asmt.common.yes'/><%--예--%>
                                    </c:when>
                                    <c:otherwise>
                                        <spring:message code='asmt.common.no'/><%--아니오--%>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>

                        <!-- 팀과제 -->
                        <tr>
                            <th><spring:message code='asmt.label.team.asmt'/><%--팀 과제--%></th>
                            <td>
                                <c:choose>
                                    <c:when test="${asmtVO.teamAsmtStngyn eq 'Y'}">
                                        <div class="view_con">
                                            <div><spring:message code='asmt.common.yes'/><!-- 예 --></div>
                                            <div><spring:message code='asmt.label.team.grp'/><%--학습그룹--%> : ${asmtVO.teamGrpnm}</div>
                                            <div>
                                                <spring:message code='asmt.label.team.grp.asmt.setting'/><%--학습그룹별 과제 설정--%> :
                                                <c:choose>
                                                    <c:when test="${asmtVO.byteamAsmtUseyn eq 'Y'}"><spring:message code='asmt.label.use.y'/><!-- 사용 --></c:when>
                                                    <c:otherwise><spring:message code='asmt.label.use.n'/><!-- 미사용 --></c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <!-- 팀 부과제 -->
                                        <c:if test="${asmtVO.byteamAsmtUseyn eq 'Y'}">
                                            <div class="team_item">
                                                <div class="table-wrap mb30">
                                                    <table class="table-type5 in_table">
                                                        <colgroup>
                                                            <col class="width-5per"/>
                                                            <col class="width-15per"/>
                                                            <col/>
                                                        </colgroup>
                                                        <tbody>
                                                        <c:forEach var="item" items="${asmtVO.subAsmtList}">
                                                            <c:set var="cnt" value="${empty item.teamMbrCnt ? 1 : item.teamMbrCnt}"/>

                                                            <tr>
                                                                <th rowspan="4" class="group-header">
                                                                    <label>${item.teamnm}</label>
                                                                </th>
                                                                <th><spring:message code='asmt.label.team.grp.members'/><%--학습그룹 구성원--%></th>
                                                                <td>
                                                                        ${empty item.leadernm ? '-' : item.leadernm}
                                                                    <spring:message code='asmt.label.other'/><%--외--%> ${cnt - 1 < 0 ? 0 : cnt - 1}
                                                                    <spring:message code='asmt.label.person'/><%--명--%>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <th><spring:message code='asmt.label.sub.topic'/><%--부주제--%></th>
                                                                <td>
                                                                    <div class="form-row">
                                                                        <c:out value="${item.asmtTtl}"/>
                                                                    </div>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <th>
                                                                    <label><spring:message code='asmt.label.asmt.content'/><%--과제내용--%></label>
                                                                </th>
                                                                <td>
                                                                    <label class="width-100per">
                                                                        <c:out value="${item.asmtCts}" escapeXml="false"/>
                                                                    </label>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <th>
                                                                    <label><spring:message code='asmt.label.attach.file'/><%--첨부파일--%></label>
                                                                </th>
                                                                <td>
                                                                    <div class="add_file_list">
                                                                        <c:choose>
                                                                            <c:when test="${not empty item.fileList}">
                                                                                <uiex:filedownload fileList="${item.fileList}"/>
                                                                            </c:when>
                                                                            <c:otherwise>-</c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>

                                                        <c:if test="${empty asmtVO.subAsmtList}">
                                                            <tr>
                                                                <td colspan="3"><spring:message code='asmt.label.team.asmt.empty'/><%--등록된 팀별 과제가 없습니다.--%></td>
                                                            </tr>
                                                        </c:if>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </c:if>

                                    </c:when>
                                    <c:otherwise><spring:message code='asmt.common.no'/><!-- 아니오 --></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>

                        <!-- 개별과제 -->
                        <tr>
                            <th><spring:message code='asmt.label.individual.asmt'/><%--개별과제--%></th>
                            <td>
                                <c:choose>
                                    <c:when test="${asmtVO.indvAsmtyn eq 'Y'}">
                                        <spring:message code='asmt.common.yes'/><!-- 예 -->
                                        <c:if test="${not empty asmtVO.indivSbmsnTrgtList}">
                                            <div class="team_item">
                                                <ul class="list-divide">
                                                    <c:forEach var="t" items="${asmtVO.indivSbmsnTrgtList}">
                                                        <li>${t.usernm}(${t.stdntNo})</li>
                                                    </c:forEach>
                                                </ul>
                                            </div>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise><spring:message code='asmt.common.no'/><!-- 아니오 --></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>

                        <tr>
                            <th><spring:message code='asmt.label.read.allow'/><!-- 과제읽기 허용 --></th>
                            <td>
                                <c:choose>
                                    <c:when test="${asmtVO.sbasmtOstdOyn eq 'Y'}">
                                        <spring:message code='asmt.common.yes'/><!-- 예 -->
                                        <c:if test="${not empty asmtVO.sbasmtOstdOpenSdttm}">
                                            <br/>
                                            <uiex:formatDate type="datetime2" value="${asmtVO.sbasmtOstdOpenSdttm}"/><spring:message code='asmt.label.from.possible'/><%--부터 가능--%>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise><spring:message code='asmt.common.no'/><!-- 아니오 --></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </li>
    </ul>
</div>
<!--//accordion-->

