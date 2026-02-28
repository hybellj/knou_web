<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<div class="ui styled fluid accordion week_lect_list card" style="border: none;">
    <div class="title">
        <div class="title_cont">
            <div class="left_cont">
                <div class="lectTit_box">
                    <fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss" value="${vo.asmtSbmsnSdttm }"/>
                    <fmt:formatDate var="asmtSbmsnSdttm" pattern="yyyy.MM.dd HH:mm:ss" value="${startDateFmt }"/>
                    <fmt:parseDate var="endDateFmt" pattern="yyyyMMddHHmmss" value="${vo.sendEndDttm }"/>
                    <fmt:formatDate var="sendEndDttm" pattern="yyyy.MM.dd HH:mm:ss" value="${endDateFmt }"/>
                    <c:set var="yes"><spring:message code="message.yes"/></c:set>
                    <c:set var="no"><spring:message code="message.no"/></c:set>
                    <p class="lect_name">${vo.asmtTtl }</p>
                    <span class="fcGrey"><small><spring:message
                            code="std.label.asmnt_peroid"/> : ${asmtSbmsnSdttm } ~ ${sendEndDttm } | <spring:message
                            code="exam.label.score.aply.y"/> : ${vo.mrkRfltyn eq 'Y' ? yes : no } | <spring:message
                            code="asmnt.label.score.open"/> : ${vo.mrkOyn eq 'Y' ? yes : no }</small></span>
                </div>
            </div>
        </div>
        <i class="dropdown icon ml20"></i>
    </div>

    <div class="content p0">
        <div class="ui segment">
            <ul class="tbl">
                <li>
                    <dl>
                        <dt>
                            <label for="lessonScheduleNm"><spring:message code='common.week'/><!-- 주차 --></label>
                        </dt>
                        <dd>
                            ${vo.lessonScheduleNm}
                        </dd>
                    </dl>
                </li>
                <li>
                    <dl>
                        <dt>
                            <label for="ctsLabel">
                                <spring:message code='asmnt.label.asmnt.content'/><!-- 과제내용 --></label>
                        </dt>
                        <dd>
                            <pre>${vo.asmtCts }</pre>
                        </dd>
                    </dl>
                </li>
                <li>
                    <dl>
                        <dt>
                            <label for="prtcLabel"><spring:message code="asmnt.label.send.date"/><!-- 제출기간 --></label>
                        </dt>
                        <dd>${asmtSbmsnSdttm } ~ ${sendEndDttm }</dd>
                        <dt>
                            <label for="prtcLabel"><spring:message code="asmnt.label.prtc.asmnt"/><!-- 실기과제 --></label>
                        </dt>
                        <dd>
                            <c:choose>
                                <c:when test="${vo.asmtPrctcyn eq 'Y' }">
                                    <spring:message code="asmnt.common.yes"/>
                                </c:when>
                                <c:otherwise>
                                    <spring:message code="asmnt.common.no"/>
                                </c:otherwise>
                            </c:choose>
                        </dd>
                    </dl>
                </li>
                <li>
                    <dl>
                        <dt>
                            <label for="extSendAcptLabel">
                                <spring:message code="common.label.submit.lateness"/><!-- 지각제출 --></label>
                        </dt>
                        <fmt:parseDate var="extSendFmt" pattern="yyyyMMddHHmmss" value="${vo.extdSbmsnSdttm }"/>
                        <fmt:formatDate var="extdSbmsnSdttm" pattern="yyyy.MM.dd HH:mm" value="${extSendFmt }"/>
                        <dd>
                            <c:choose>
                                <c:when test="${vo.extdSbmsnPrmyn eq 'Y' }">
                                    <spring:message code="asmnt.common.yes"/> | ${extdSbmsnSdttm }
                                </c:when>
                                <c:otherwise>
                                    <spring:message code="asmnt.label.use.n"/>
                                </c:otherwise>
                            </c:choose>
                        </dd>
                        <dt>
                            <label for="teamAsmntCfgLabel">
                                <spring:message code="asmnt.label.team.asmnt"/><!--  팀과제 --></label>
                        </dt>
                        <dd>
                            <c:choose>
                                <c:when test="${vo.teamAsmtStngyn eq 'Y'}">
                                    <spring:message code='asmnt.common.yes'/><!-- 예 --> | ${vo.crsCreNm} <spring:message
                                        code='asmnt.label.decls.name'/><!-- 반 --> <spring:message
                                        code='asmnt.label.team.config'/><!-- 팀구성 -->
                                    <button class="ui icon small button" onclick="teamMemberView('${vo.lrnGrpId}')">
                                        <spring:message code='asmnt.label.team.config.view'/><!-- 팀구성원 보기 --></button>
                                </c:when>
                                <c:otherwise>
                                    <spring:message code='asmnt.common.no'/><!-- 아니오 -->
                                </c:otherwise>
                            </c:choose>
                        </dd>
                    </dl>
                </li>
                <li>
                    <dl>
                        <dt>
                            <label for="evalCtgrLabel">
                                <spring:message code="exam.label.eval.ctgr" /><!-- 평가방법 --></label>
                        </dt>
                        <dd>
                            <c:choose>
                                <c:when test="${vo.evalCtgr eq 'R'}">
                                    <spring:message code="crs.label.rubric"/>
                                    <button type="button" class="ui icon button" onclick="mutEvalWritePop();"
                                            title="루브릭 수정"><i class="edit icon"></i></button>
                                </c:when>
                                <c:otherwise>
                                    <spring:message code="crs.label.point"/>
                                </c:otherwise>
                            </c:choose>
                        </dd>
                        <dt>
                            <label for="indLabel">
                                <spring:message code="asmnt.label.individual.asmnt" /><!-- 개별과제 --></label>
                        </dt>
                        <dd>
                            <c:if test="${vo.indvAsmtyn eq 'N'}"><spring:message code="asmnt.common.no"/><!-- 아니오 -->
                            </c:if>
                            <div id="sindvAsmtList"></div>
                        </dd>
                    </dl>
                </li>
                <li>
                    <dl>
                        <dt>
                            <label for="scoreRatioLabel">
                                <spring:message code="asmnt.label.score.ratio"/><!-- 점수 반영 비율 --></label>
                        </dt>
                        <dd>
                            <c:choose>
                                <c:when test="${vo.examStareTypeCd eq 'M' }">
                                    중간고사
                                </c:when>
                                <c:when test="${vo.examStareTypeCd eq 'L' }">
                                    기말고사
                                </c:when>
                                <c:otherwise>
                                    ${vo.mrkRfltyn eq 'Y' ? vo.mrkRfltrt += ' %' : '-' }
                                </c:otherwise>
                            </c:choose>
                        </dd>

                        <dt>
                            <label for="sbmtOpenLabel"><spring:message code="asmnt.label.read"/><!-- 과제읽기 --></label>
                        </dt>
                        <dd>
                            <fmt:parseDate var="sbmtStartFmt" pattern="yyyyMMddHHmmss"
                                           value="${vo.sbasmtOstdOpenSdttm }"/>
                            <fmt:formatDate var="sbasmtOstdOpenSdttm" pattern="yyyy.MM.dd HH:mm"
                                            value="${sbmtStartFmt }"/>
                            <fmt:parseDate var="sbmtEndFmt" pattern="yyyyMMddHHmmss"
                                           value="${vo.sbasmtOstdOpenEdttm }"/>
                            <fmt:formatDate var="sbasmtOstdOpenEdttm" pattern="yyyy.MM.dd HH:mm"
                                            value="${sbmtEndFmt }"/>
                            <c:choose>
                                <c:when test="${vo.sbasmtOstdOyn eq 'Y' }">
                                    <spring:message
                                            code="asmnt.common.yes"/> | ${sbasmtOstdOpenSdttm } ~ ${sbasmtOstdOpenEdttm }
                                </c:when>
                                <c:otherwise>
                                    <spring:message code="asmnt.common.no"/>
                                </c:otherwise>
                            </c:choose>
                        </dd>
                    </dl>
                </li>
                <li>
                    <dl>
                        <dt>
                            <label for="teamLabel">
                                <spring:message code="asmnt.label.asmnt.send.type" /><!-- 제출형식 --></label>
                        </dt>
                        <dd><c:if test="${vo.sendType ne 'T' }"><spring:message code="lesson.label.file"/> |</c:if>
                            <c:choose>
                                <c:when test="${vo.asmtPrctcyn eq 'Y'}">
                                    <c:forEach items="${fn:split(vo.sbmtFileType,',') }" var="item" varStatus="status">
                                        <c:if test="${status.index ne 0}">,</c:if>
                                        <c:choose>
                                            <c:when test="${item eq 'img'}">
                                                <spring:message code="lesson.label.img"/> (JPG, GIF, PNG)
                                            </c:when>
                                            <c:when test="${item eq 'pdf'}">
                                                PDF
                                            </c:when>
                                            <c:when test="${item eq 'ppt' }">
                                                PPT(PPTX)
                                            </c:when>
                                        </c:choose>
                                    </c:forEach>
                                </c:when>
                                <c:when test="${vo.sendType eq 'F'}">
                                    <c:choose>
                                        <c:when test="${vo.sbmtFileType eq null || vo.sbmtFileType eq ''}"><spring:message
                                                code="asmnt.label.total.file"/><!-- 모든파일 --></c:when>
                                        <c:otherwise>
                                            <c:forEach items="${fn:split(vo.sbmtFileType,',') }" var="item"
                                                       varStatus="status">
                                                <c:choose>
                                                    <c:when test="${status.index eq 0}">
                                                        <c:choose>
                                                            <c:when test="${item eq 'img' || item eq 'pdf' || item eq 'txt' || item eq 'soc' || item eq 'ppt2'}">
                                                                <spring:message code="button.preview"/> <spring:message
                                                                    code="message.possible"/> :
                                                            </c:when>
                                                            <c:otherwise>
                                                                <spring:message code="common.label.type.doc"/> :
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>,
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:choose>
                                                    <c:when test="${item eq 'img'}">
                                                        <spring:message code="lesson.label.img"/> (JPG, GIF, PNG)
                                                    </c:when>
                                                    <c:when test="${item eq 'pdf'}">
                                                        PDF
                                                    </c:when>
                                                    <c:when test="${item eq 'pdf2'}">
                                                        PDF
                                                    </c:when>
                                                    <c:when test="${item eq 'txt'}">
                                                        TEXT
                                                    </c:when>
                                                    <c:when test="${item eq 'soc'}">
                                                        <spring:message code="common.label.program.source"/>(.txt)
                                                    </c:when>
                                                    <c:when test="${item eq 'hwp'}">
                                                        HWP(HWPX)
                                                    </c:when>
                                                    <c:when test="${item eq 'doc'}">
                                                        DOC(DOCX)
                                                    </c:when>
                                                    <c:when test="${item eq 'ppt' || item eq 'ppt2'}">
                                                        PPT(PPTX)
                                                    </c:when>
                                                    <c:when test="${item eq 'xls'}">
                                                        XLS(XLSX)
                                                    </c:when>
                                                    <c:when test="${item eq 'zip'}">
                                                        ZIP
                                                    </c:when>
                                                </c:choose>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <spring:message code="lesson.label.text"/>
                                </c:otherwise>
                            </c:choose>
                        </dd>

                        <dt>
                            <label for="evalUseLabel"><spring:message code='asmnt.label.mut.eval'/><!-- 상호평가 --></label>
                        </dt>
                        <dd>
                            <c:choose>
                                <c:when test="${vo.evlRfltyn eq 'Y'}">
                                    <fmt:parseDate var="evalStartFmt" pattern="yyyyMMddHHmmss"
                                                   value="${vo.evlSdttm }"/>
                                    <fmt:formatDate var="evlSdttm" pattern="yyyy.MM.dd HH:mm"
                                                    value="${evalStartFmt }"/>
                                    <fmt:parseDate var="evalEndFmt" pattern="yyyyMMddHHmmss"
                                                   value="${vo.evlEdttm }"/>
                                    <fmt:formatDate var="evlEdttm" pattern="yyyy.MM.dd HH:mm"
                                                    value="${evalEndFmt }"/>
                                    ${evlSdttm } ~ ${evlEdttm }
                                    <br/>
                                    <spring:message code="forum.label.result.open"/><!-- 결과공개 --> :
                                    <c:choose>
                                        <c:when test="${vo.evlRsltOyn eq 'Y'}">
                                            <spring:message code='asmnt.common.yes'/><!-- 예 -->
                                        </c:when>
                                        <c:otherwise>
                                            <spring:message code='asmnt.common.no'/><!-- 아니오 -->
                                        </c:otherwise>
                                    </c:choose>
                                    <c:if test="${vo.teamAsmtStngyn eq 'Y'}">
                                        | <spring:message code='asmnt.label.team.mut.eval'/><!-- 팀내 상호평가 --> :
                                        <c:choose>
                                            <c:when test="${vo.teamEvalYn eq 'Y'}">
                                                <spring:message code='asmnt.common.yes'/><!-- 예 -->
                                            </c:when>
                                            <c:otherwise>
                                                <spring:message code='asmnt.common.no'/><!-- 아니오 -->
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <spring:message code='asmnt.common.no'/><!-- 아니오 -->
                                </c:otherwise>
                            </c:choose>
                        </dd>

                    </dl>
                </li>
                <li>
                    <dl>
                        <dt>
                            <label for="contLabel">
                                <spring:message code="asmnt.label.attach.file" /><!-- 첨부파일 --></label>
                        </dt>
                        <dd>
                            <c:forEach items="${vo.fileList }" var="item" varStatus="status">
                                <button class="ui icon small button" id="file_${item.fileSn }"
                                        title="<spring:message code='asmnt.label.attachFile.download'/>"
                                        onclick="fileDown('${item.fileSn}', '${item.repoCd }')">
                                    <i class="ion-android-download"></i>
                                </button>
                                <script>
                                    byteConvertor("${item.fileSize}", "${item.fileNm}", "file_${item.fileSn}");
                                </script>
                            </c:forEach>
                        </dd>
                    </dl>
                </li>
                <li>
                    <dl>
                        <dt>
                            <label for="">
                                <spring:message code="asmnt.label.feedback.use.yn" /><!-- 실시간 피드백사용 --></label>
                        </dt>
                        <dd>
                            <c:choose>
                                <c:when test="${vo.pushAlimyn eq 'Y'}">
                                    <spring:message code="asmnt.common.yes"/><!-- 사용 -->
                                </c:when>
                                <c:otherwise>
                                    <spring:message code="asmnt.common.no"/><!-- 미사용 -->
                                </c:otherwise>
                            </c:choose>
                        </dd>
                    </dl>
                </li>
            </ul>
        </div>
    </div>
</div>