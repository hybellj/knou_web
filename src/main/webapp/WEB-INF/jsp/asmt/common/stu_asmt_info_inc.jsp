<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<div class="ui styled fluid accordion week_lect_list card" style="border: none;">
    <div class="title active">
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

    <div class="content active p0">
        <div class="ui segment transition visible">
            <ul class="tbl">
                <li>
                    <dl>
                        <dt>
                            <label for="ctsLabel">
                                <spring:message code='asmnt.label.asmnt.content'/><!-- 과제내용 --></label>
                        </dt>
                        <dd>
                            <pre>${vo.asmtCts}</pre>
                        </dd>
                    </dl>
                </li>
                <li>
                    <dl>
                        <dt>
                            <label for="prtcLabel"><spring:message code="asmnt.label.send.date"/><!-- 제출기간 --></label>
                        </dt>
                        <dd>${asmtSbmsnSdttm} ~ ${sendEndDttm}</dd>
                        <dt>
                            <label for="prtcLabel"><spring:message code="asmnt.label.practice.asmnt"/></label>
                        </dt>
                        <dd>
                            <c:choose>
                                <c:when test="${vo.prtcYn eq 'Y'}">
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
                                <spring:message code="common.label.submit.lateness" /><!-- 지각제출 --></label>
                        </dt>
                        <fmt:parseDate var="extSendFmt" pattern="yyyyMMddHHmmss" value="${vo.extSendDttm}"/>
                        <fmt:formatDate var="extSendDttm" pattern="yyyy.MM.dd HH:mm" value="${extSendFmt}"/>
                        <dd>
                            <c:choose>
                                <c:when test="${vo.extSendAcptYn eq 'Y'}">
                                    <spring:message code="asmnt.common.yes"/> | ${extSendDttm}
                                </c:when>
                                <c:otherwise>
                                    <spring:message code="asmnt.label.use.n"/>
                                </c:otherwise>
                            </c:choose>
                        </dd>
                        <dt>
                            <label><spring:message code="asmnt.label.resend.date"/><!-- 재제출기간 --></label>
                        </dt>
                        <fmt:parseDate var="resendStartFmt" pattern="yyyyMMddHHmmss" value="${vo.resbmsnSdttm}"/>
                        <fmt:formatDate var="resbmsnSdttm" pattern="yyyy.MM.dd HH:mm" value="${resendStartFmt}"/>
                        <fmt:parseDate var="resendEndFmt" pattern="yyyyMMddHHmmss" value="${vo.resbmsnEdttm}"/>
                        <fmt:formatDate var="resbmsnEdttm" pattern="yyyy.MM.dd HH:mm" value="${resendEndFmt}"/>
                        <dd>
                            <c:choose>
                                <c:when test="${jVo.resbmsnyn eq 'Y'}">
                                    ${resbmsnSdttm} ~ ${resbmsnEdttm}
                                </c:when>
                                <c:otherwise>
                                    -
                                </c:otherwise>
                            </c:choose>
                        </dd>
                    </dl>
                </li>
                <li>
                    <dl>
                        <dt>
                            <label for="evalCtgrLabel"><spring:message code="crs.common.scoreratetype"/></label>
                        </dt>
                        <dd>
                            <c:choose>
                                <c:when test="${vo.evalCtgr eq 'R'}">
                                    <spring:message code="asmnt.label.rubric"/>
                                    <button type="button" class="ui icon button small p4" onclick="mutEvalInfoPop();"
                                            title="<spring:message code='asmnt.label.rubric'/>"><i
                                            class="info icon"></i></button>
                                </c:when>
                                <c:otherwise>
                                    <spring:message code="asmnt.label.point.type"/>
                                </c:otherwise>
                            </c:choose>
                        </dd>
                        <dt>
                            <label for="teamAsmntCfgLabel">
                                <spring:message code="asmnt.label.team.asmnt"/><!-- 팀 과제 --></label>
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
                            <label for="evalUseLabel"><spring:message code='asmnt.label.mut.eval'/><!-- 상호평가 --></label>
                        </dt>
                        <dd>
                            <c:choose>
                                <c:when test="${vo.evalUseYn eq 'Y'}">
                                    <fmt:parseDate var="evalStartFmt" pattern="yyyyMMddHHmmss"
                                                   value="${vo.evalStartDttm}"/>
                                    <fmt:formatDate var="evalStartDttm" pattern="yyyy.MM.dd HH:mm"
                                                    value="${evalStartFmt}"/>
                                    <fmt:parseDate var="evalEndFmt" pattern="yyyyMMddHHmmss" value="${vo.evalEndDttm}"/>
                                    <fmt:formatDate var="evalEndDttm" pattern="yyyy.MM.dd HH:mm" value="${evalEndFmt}"/>
                                    <spring:message code="lesson.label.period"/> : ${evalStartDttm} ~ ${evalEndDttm}
                                    <br/>
                                    <spring:message code="forum.label.result.open"/> :
                                    <c:choose>
                                        <c:when test="${vo.evalRsltOpenYn eq 'Y'}">
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
                        <dt>
                            <label for="indLabel"><spring:message code="asmnt.label.individual.asmnt"/></label>
                        </dt>
                        <dd>
                            <c:if test="${vo.indvAsmtyn eq 'N'}"><spring:message code="asmnt.common.no"/></c:if>
                            <c:if test="${vo.indvAsmtyn eq 'Y'}">
                                <div id="sindvAsmtList">
                                    <button class='ui grey small button'>${jVo.userNm}(${jVo.userId})</button>
                                </div>
                            </c:if>
                        </dd>
                    </dl>
                </li>
                <li>
                    <dl>
                        <dt>
                            <label for="teamLabel">
                                <spring:message code="asmnt.label.asmnt.send.type" /><!-- 제출형식 --></label>
                        </dt>
                        <dd><c:if test="${vo.sendType ne 'T'}"><spring:message code="common.file"/> |</c:if>
                            <c:choose>
                                <c:when test="${vo.prtcYn eq 'Y'}">
                                    <c:forEach items="${fn:split(vo.sbmtFileType,',')}" var="item" varStatus="status">
                                        <c:if test="${status.index ne 0}">,</c:if>
                                        <c:choose>
                                            <c:when test="${item eq 'img'}">
                                                <spring:message code="common.label.image"/><!-- 이미지 --> (JPG, GIF, PNG)
                                            </c:when>
                                            <c:when test="${item eq 'pdf'}">
                                                PDF
                                            </c:when>
                                            <c:when test="${item eq 'ppt'}">
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
                                            <c:forEach items="${fn:split(vo.sbmtFileType,',')}" var="item"
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
                                                        <spring:message
                                                                code="common.label.image"/><!-- 이미지 --> (JPG, GIF, PNG)
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
                                                    <c:when test="${item eq 'ppt' or item eq 'ppt2'}">
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
                            <label for="sbmtOpenLabel"><spring:message code="asmnt.label.read"/></label><!-- 과제읽기 -->
                        </dt>
                        <dd>
                            <fmt:parseDate var="sbmtStartFmt" pattern="yyyyMMddHHmmss" value="${vo.sbmtStartDttm}"/>
                            <fmt:formatDate var="sbmtStartDttm" pattern="yyyy.MM.dd HH:mm" value="${sbmtStartFmt}"/>
                            <fmt:parseDate var="sbmtEndFmt" pattern="yyyyMMddHHmmss" value="${vo.sbmtEndDttm}"/>
                            <fmt:formatDate var="sbmtEndDttm" pattern="yyyy.MM.dd HH:mm" value="${sbmtEndFmt}"/>
                            <c:choose>
                                <c:when test="${vo.sbmtOpenYn eq 'Y'}">
                                    <spring:message code="asmnt.common.yes"/> | ${sbmtStartDttm} ~ ${sbmtEndDttm}
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
                            <label for="contLabel"><spring:message code="asmnt.label.attach.file"/><!-- 첨부파일 --></label>
                        </dt>
                        <dd>
                            <c:forEach items="${vo.fileList}" var="item" varStatus="status">
                                <button class="ui icon small button" id="file_${item.fileSn}"
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
            </ul>
        </div>
    </div>
</div>