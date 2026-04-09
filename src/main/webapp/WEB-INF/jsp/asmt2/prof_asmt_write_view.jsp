<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/asmt2/common/asmt_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table,editor,fileuploader"/>
    </jsp:include>
</head>

<body class="home colorA ${bodyClass}">
<div id="wrap" class="main">

    <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp"/>

    <main class="common">
        <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>

        <div id="content" class="content-wrap common">
            <div class="class_sub">
                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title">과제</h2>
                    </div>

                    <div id="messageArea" style="display:none;color:#b00020;margin-bottom:10px;"></div>

                    <div class="board_top">
                        <h4 class="sub-title">${mode eq 'E' ? '수정' : '등록' }</h4>
                        <div class="right-area">

                            <div class="btns">
                                <button type="button" class="btn type1" id="btnSave">저장</button>
                                <c:if test="${mode ne 'E'}">
                                    <button type="button" class="btn type2" id="btnCopy">이전과제가저오기</button>
                                </c:if>
                                <button type="button" class="btn type2" id="btnGoList">목록</button>
                            </div>
                        </div>
                    </div>
                    <div class="table-wrap">
                        <form id="asmtWriteForm" name="asmtWriteForm" method="post" action="" onsubmit="saveConfirm(); return false;">
                            <input type="hidden" name="asmtId">
                            <input type="hidden" name="prevAsmtId" value="${asmtVO.prevAsmtId}">
                            <input type="hidden" name="asmtGbncd">
                            <input type="hidden" name="indvAsmtList">
                            <input type="hidden" name="sbjctId" value="${asmtVO.sbjctId}">
                            <input type="hidden" name="sbmsnFileMimeTycd">
                            <input type="hidden" name="repoCd" value="ASMT">
                            <input type="hidden" name="uploadPath"/>
                            <input type="hidden" name="uploadFiles">
                            <input type="hidden" name="delFileIdStr"/>
                            <input type="hidden" name="copyFiles">
                            <input type="hidden" name="asmtSbmsnSdttm" id="asmtSbmsnSdttm">
                            <input type="hidden" name="asmtSbmsnEdttm" id="asmtSbmsnEdttm">
                            <input type="hidden" name="sbasmtOstdOpenSdttm" id="sbasmtOstdOpenSdttm">
                            <input type="hidden" name="sbasmtOstdOpenEdttm" id="sbasmtOstdOpenEdttm">
                            <input type="hidden" name="extdSbmsnSdttm" id="extdSbmsnSdttm">
                            <input type="hidden" name="extdSbmsnEdttm" id="extdSbmsnEdttm">
                            <input type="hidden" name="evlSdttm" id="evlSdttm">
                            <input type="hidden" name="evlEdttm" id="evlEdttm">
                            <input type="hidden" name="subAsmtDtlDummy">

                            <table class="table-type5">
                                <colgroup>
                                    <col class="width-15per"/>
                                    <col/>
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th><label for="asmtTtl" class="req">과제명</label></th>
                                    <td>
                                        <div class="form-row">
                                            <input class="form-control width-100per" type="text" id="asmtTtl" name="asmtTtl" placeholder="제목 입력">
                                        </div>
                                    </td>
                                </tr>

                                <%--과제내용--%>
                                <tr>
                                    <th><label for="asmtCts" class="req"><spring:message code="asmnt.label.asmnt.content"/></label></th>
                                    <td>
                                        <div class="editor-box">
                                            <uiex:htmlEditor
                                                    id="asmtCts"
                                                    name="asmtCts"
                                                    uploadPath="${asmtVO.uploadPath}"
                                                    value="${asmtVO.asmtCts}"
                                                    height="300px"
                                            />
                                        </div>
                                    </td>
                                </tr>

                                <c:if test="${empty asmtVO.asmtId}">
                                    <%--분반 일괄 등록--%>
                                    <tr id="dvclasView">
                                        <th><label><spring:message code="asmnt.label.grp.crs.all"/></label></th>
                                        <td>
                                            <div class="checkbox_type" id="dvclasListView">
                                                    <span class="custom-input">
                                                        <input type="checkbox" id="dvclasAll" name="dvclasList" value="ALL" <c:if test="${fn:length(dvclasList) eq 1}">checked onclick="return false;"</c:if>>
                                                        <label for="dvclasAll">전체</label>
                                                    </span>

                                                <c:forEach var="item" items="${dvclasList}" varStatus="status">
                                                        <span class="custom-input">
                                                            <input type="checkbox"
                                                                   id="dvclas${status.index}"
                                                                   name="dvclasList"
                                                                   value="${item.sbjctId}"
                                                                   data-index="${status.index}"
                                                                   data-dvclas-no="${item.dvclasNo}"
                                                                   <c:if test="${item.sbjctId eq asmtVO.sbjctId}">checked onclick="return false;"</c:if>>
                                                            <label for="dvclas${status.index}">${item.dvclasNo}반</label>
                                                        </span>
                                                </c:forEach>
                                            </div>
                                        </td>
                                    </tr>
                                </c:if>
                                <%-- 제출기간 --%>
                                <tr>
                                    <th><label for="asmtSbmsnDateSt" class="req"><spring:message code="asmnt.label.send.date"/></label></th>
                                    <td>
                                        <div class="date_area">
                                            <input id="asmtSbmsnDateSt" type="text" name="asmtSbmsnDateSt" class="datepicker" timeId="asmtSbmsnTimeSt" toDate="asmtSbmsnDateEd">
                                            <input id="asmtSbmsnTimeSt" type="text" name="asmtSbmsnTimeSt" class="timepicker" dateId="asmtSbmsnDateSt">
                                            <span class="txt-sort">~</span>
                                            <input id="asmtSbmsnDateEd" type="text" name="asmtSbmsnDateEd" class="datepicker" timeId="asmtSbmsnTimeEd" fromDate="asmtSbmsnDateSt">
                                            <input id="asmtSbmsnTimeEd" type="text" name="asmtSbmsnTimeEd" class="timepicker" dateId="asmtSbmsnDateEd">
                                        </div>
                                    </td>
                                </tr>

                                <%-- 성적반영 --%>
                                <tr>
                                    <th><label class="req"><spring:message code="resh.label.score.aply"/></label></th>
                                    <td>
                                        <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" name="mrkRfltyn" id="mrkRfltY" value="Y" ${asmtVO.mrkRfltyn eq 'Y' || empty asmtVO.asmtId ? 'checked' : '' }>
                                                    <label for="mrkRfltY">예</label>
                                                </span>
                                            <span class="custom-input ml5">
                                                    <input type="radio" name="mrkRfltyn" id="mrkRfltN" value="N" ${asmtVO.mrkRfltyn eq 'N' ? 'checked' : '' }>
                                                    <label for="mrkRfltN">아니오</label>
                                                </span>
                                        </div>
                                    </td>
                                </tr>
                                <%-- 성적공개 --%>
                                <tr>
                                    <th><label><spring:message code="resh.label.score.open"/></label></th>
                                    <td>
                                        <div class="form-inline">
                                            <span class="custom-input">
                                                <input type="radio" name="mrkOyn" id="mrkOynY" value="Y" ${asmtVO.mrkOyn eq 'Y' || empty asmtVO.asmtId ? 'checked' : ''}>
                                                <label for="mrkOynY">예</label>
                                            </span>
                                            <span class="custom-input ml5">
                                                <input type="radio" name="mrkOyn" id="mrkOynN" value="N" ${asmtVO.mrkOyn eq 'N' ? 'checked' : '' }>
                                                <label for="mrkOynN">아니오</label>
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <%-- 연장 제출--%>
                                <tr>
                                    <th><label>연장제출</label></th>
                                    <td>
                                        <div class="form-inline mb10">
                                                <span class="custom-input">
                                                    <input type="radio" name="extdSbmsnPrmyn" id="extdSbmsnPrmN" value="N" ${asmtVO.extdSbmsnPrmyn eq 'N' || empty asmtVO.asmtId ? 'checked' : '' }>
                                                    <label for="extdSbmsnPrmN">아니오</label>
                                                </span>
                                            <span class="custom-input ml5">
                                                    <input type="radio" name="extdSbmsnPrmyn" id="extdSbmsnPrmY" value="Y" ${asmtVO.extdSbmsnPrmyn eq 'Y'  ? 'checked' : '' }>
                                                    <label for="extdSbmsnPrmY">예</label>
                                                </span>
                                        </div>
                                        <%-- 제출 마감일 --%>
                                        <div id="viewExtdSbmsnPrm">
                                            <div class="date_area mb10">
                                                <input id="extdSbmsnDateEd" type="text" name="extdSbmsnDateEd" class="datepicker" timeId="extdSbmsnTimeEd" value="${fn:substring(asmtVO.extdSbmsnEdttm,0,8)}" required="true">
                                                <input id="extdSbmsnTimeEd" type="text" name="extdSbmsnTimeEd" class="timepicker" dateId="extdSbmsnDateEd" value="${fn:substring(asmtVO.extdSbmsnEdttm,8,12)}" required="true">
                                            </div>

                                            <div class="msg-box warning">
                                                <p class="txt"><i class="xi-error" aria-hidden="true"></i> <spring:message code="asmnt.label.ext.send.info"/></p>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <%-- 평가방법 --%>
                                <tr>
                                    <th><label class="req"><spring:message code="crs.label.eval_method"/></label></th>
                                    <td>
                                        <div class="form-inline mb10">
                                                <span class="custom-input">
                                                    <input type="radio" name="evlScrTycd" id="evlScrTycdS" value="SCR" ${asmtVO.evlScrTycd eq 'SCR' || empty asmtVO.asmtId ? 'checked' : '' }>
                                                    <label for="evlScrTycdS">점수형</label>
                                                </span>
                                            <span class="custom-input ml5">
                                                    <input type="radio" name="evlScrTycd" id="evlScrTycdR" value="RUBRIC_SCR" ${asmtVO.evlScrTycd eq 'RUBRIC_SCR' ? 'checked' : '' }>
                                                    <label for="evlScrTycdR">루브릭</label>
                                                </span>
                                        </div>

                                        <div id="mutEvalDiv" class="mb10">
                                            <div class="ui action input search-box mr5">
                                                <input type="hidden" name="asmtEvlId" id="asmtEvlId"/>
                                                <input type="text" name="evalTitle" id="evalTitle">
                                                <button type="button" class="ui icon button" onclick="mutEvalWritePop('new');"><i class="pencil alternate icon"></i></button>
                                                <button type="button" class="ui icon button" onclick="mutEvalWritePop('edit');"><i class="edit icon"></i></button>
                                                <button type="button" class="ui icon button" onclick="deleteMut();"><i class="trash icon"></i></button>
                                            </div>
                                        </div>

                                        <div class="msg-box warning">
                                            <p class="txt"><i class="xi-error" aria-hidden="true"></i> <spring:message code="forum.label.evalctgr.rubric.info"/></p><%-- 루브릭 선택시 루브릭 설정 팝업이 활성화 됩니다.--%>
                                        </div>
                                    </td>
                                </tr>


                                <%--제출형식--%>
                                <tr id="viewSbasmtTycd">
                                    <th><label class="req"><spring:message code="asmnt.label.asmnt.send.type"/></label></th>
                                    <td>

                                        <span class="custom-input">
                                            <input type="radio" name="sbasmtTycd" id="sbasmtTycdF" value="FILE" ${asmtVO.sbasmtTycd eq 'FILE' || empty asmtVO.asmtId ? 'checked' : '' }>
                                            <label for="sbasmtTycdF"><spring:message code="asmnt.label.file" /><!-- 파일 --></label>
                                        </span>
                                        <span class="custom-input">
                                            <input type="radio" name="sbasmtTycd" id="sbasmtTycdT" value="INPUT_TEXT">
                                            <label for="sbasmtTycdT"><spring:message code="lesson.label.text"/>(TEXT)</label>
                                        </span>
                                        <div id="viewSbasmtTycdFile">
                                            <span class="custom-input">
                                                <input type="radio" name="sbmsnFileMimeTycd" id="allFile" value="all" ${asmtVO.sbmsnFileMimeTycd eq 'all' || empty asmtVO.asmtId ? 'checked' : '' }>
                                                <label for="allFile"><spring:message code="asmnt.label.total.file" /><!-- 모든파일 --></label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="sbmsnFileMimeTycd" id="preFile" value="pre">
                                                <label for="preFile"><spring:message code="button.preview"/><%--미리보기--%><spring:message code="message.possible"/><%--가능--%></label>
                                            </span>
                                            <div class="checkbox_type">
                                                <span class="custom-input">
                                                    <input type="checkbox" name="preFile" id="preFile01" value="img">
                                                    <label for="preFile01"><spring:message code="lesson.label.img"/> (JPG, GIF, PNG)</label>
                                                </span>
                                                <span class="custom-input">
                                                    <input type="checkbox" name="preFile" id="preFile02" value="pdf">
                                                    <label for="preFile02">PDF</label>
                                                </span>
                                                <span class="custom-input">
                                                    <input type="checkbox" name="preFile" id="preFile03" value="txt">
                                                    <label for="preFile03">TEXT</label>
                                                </span>
                                                <span class="custom-input">
                                                    <input type="checkbox" name="preFile" id="preFile04" value="soc">
                                                    <label for="preFile04"><spring:message code="common.label.program.source"/></label>
                                                </span>
                                            </div>
                                            <span class="custom-input">
                                                <input type="radio" name="sbmsnFileMimeTycd" id="docFile" value="doc">
                                                <label for="docFile">특정파일 가능</label>
                                            </span>
                                            <div>
                                                <span class="custom-input">
                                                    <input type="checkbox" name="docFile" id="docFile01" value="hwp">
                                                    <label for="docFile01">HWP</label>
                                                </span>
                                                <span class="custom-input">
                                                    <input type="checkbox" name="docFile" id="docFile02" value="doc">
                                                    <label for="docFile02">DOC</label>
                                                </span>
                                                <span class="custom-input">
                                                    <input type="checkbox" name="docFile" id="docFile03" value="ppt">
                                                    <label for="docFile03">PPT</label>
                                                </span>
                                                <span class="custom-input">
                                                    <input type="checkbox" name="docFile" id="docFile04" value="xls">
                                                    <label for="docFile04">XLS</label>
                                                </span>

                                            </div>
                                        </div>
                                    </td>
                                </tr>

                                <tr>
                                    <th><label><spring:message code="asmnt.label.file.upload"/></label></th>
                                    <td>
                                        <uiex:dextuploader
                                                id="upload1"
                                                path="${asmtVO.uploadPath}"
                                                limitCount="5"
                                                limitSize="100"
                                                oneLimitSize="100"
                                                listSize="3"
                                                fileList="${asmtVO.fileList}"
                                                finishFunc="finishUpload()"
                                                allowedTypes="*"
                                                bigSize="false"
                                        />
                                    </td>
                                </tr>

                                <%--실기과제--%>
                                <tr>
                                    <th><label class="req"><spring:message code="asmnt.label.practice.asmnt"/></label></th>
                                    <td>
                                        <span class="custom-input">
                                            <input type="radio" name="asmtPrctcyn" id="asmtPrctcN" value="N" ${asmtVO.asmtPrctcyn eq 'N' || empty asmtVO.asmtId ? 'checked' : '' }>
                                            <label for="asmtPrctcN">
                                                <spring:message code="asmnt.common.no"/>
                                            </label>
                                        </span>
                                        <span class="custom-input">
                                            <input type="radio" name="asmtPrctcyn" id="asmtPrctcY" value="Y" ${asmtVO.asmtPrctcyn eq 'Y' ? 'checked' : '' }>
                                            <label for="asmtPrctcY">
                                                <spring:message code="asmnt.common.yes"/>
                                            </label>
                                        </span>
                                        <div id="viewPrtc">
                                            <div>
                                                <label for="fileType01">
                                                    <spring:message code="button.manage.file.type"/> :
                                                </label>
                                            </div>
                                            <div class="checkbox_type">
                                            <span class="custom-input">
                                                <input type="checkbox" name="prtcFileType" id="fileType01" value="img">
                                                <label for="fileType01">
                                                    <spring:message code="common.label.image"/> (JPG, GIF, PNG)
                                                </label>
                                            </span>
                                                <span class="custom-input">
                                                <input type="checkbox" name="prtcFileType" id="fileType02" value="pdf">
                                                <label for="fileType02">PDF</label>
                                            </span>
                                            </div>

                                            <div>
                                                <label for="exlnAsmtDwldN">우수과제 다운로드</label>
                                            </div>
                                            <div>
                                            <span class="custom-input">
                                                <input type="radio" name="exlnAsmtDwldyn" id="exlnAsmtDwldN" value="N" ${asmtVO.exlnAsmtDwldyn eq 'N' || empty asmtVO.asmtId ? 'checked' : '' }>
                                                <label for="exlnAsmtDwldN">
                                                    <spring:message code="asmnt.common.no"/>
                                                </label>
                                            </span>
                                                <span class="custom-input">
                                                <input type="radio" name="exlnAsmtDwldyn" id="exlnAsmtDwldY" value="Y" ${asmtVO.exlnAsmtDwldyn eq 'Y' ? 'checked' : '' }>
                                                <label for="exlnAsmtDwldY">
                                                    <spring:message code="asmnt.common.yes"/>
                                                </label>
                                            </span>
                                            </div>
                                        </div>
                                    </td>
                                </tr>

                                <tr>
                                    <th>
                                        <label for="teamLabel">
                                            <spring:message code="asmnt.label.team.asmnt" /><!-- 팀과제 -->
                                        </label>
                                    </th>
                                    <td>
                                        <%-- 팀과제 여부 --%>
                                        <span class="custom-input">
                                            <input type="radio" name="teamAsmtStngyn" id="teamN" value="N" ${asmtVO.teamAsmtStngyn eq 'N' || empty asmtVO.asmtId ? 'checked' : '' }>
                                            <label for="teamN">
                                                <spring:message code="asmnt.common.no"/>
                                            </label>
                                        </span>
                                        <span class="custom-input">
                                            <input type="radio" name="teamAsmtStngyn" id="teamY" value="Y" ${asmtVO.teamAsmtStngyn eq 'Y' ? 'checked' : '' } >
                                            <label for="teamY">
                                                <spring:message code="asmnt.common.yes"/>
                                            </label>
                                        </span>


                                        <%-- 팀과제 상세 영역 --%>
                                        <div id="viewTeamAsmt" style="display:none;">
                                            <%--개별제출허용--%>
                                            <div class="form-inline mb10">
                                                <label>개별제출 허용</label>
                                                <span class="custom-input">
                                                    <input type="radio" id="tmbrIndivSbmsnPrmN" name="tmbrIndivSbmsnPrmyn" value="N" ${asmtVO.tmbrIndivSbmsnPrmyn eq 'N' || empty asmtVO.asmtId ? 'checked' : '' }>
                                                    <label for="tmbrIndivSbmsnPrmN">아니오</label>
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" id="tmbrIndivSbmsnPrmY" name="tmbrIndivSbmsnPrmyn" value="Y">
                                                    <label for="tmbrIndivSbmsnPrmY">예</label>
                                                </span>
                                            </div>

                                            <c:forEach var="list" items="${dvclasList}" varStatus="status">
                                                <%-- 분반별 학습그룹 선택 영역 --%>
                                                <div class="form-row"
                                                     id="lrnGrpView${list.dvclasNo}"
                                                     data-dvclas-no="${list.dvclasNo}"
                                                     data-sbjct-id="${list.sbjctId}"
                                                    ${list.sbjctId eq asmtVO.sbjctId ? "" : "style='display:none;'"}>

                                                    <div class="input_btn width-100per">
                                                        <label>${list.dvclasNo}반</label>

                                                            <%-- 선택한 학습그룹 ID:학과목ID --%>
                                                        <input type="hidden"
                                                               id="lrnGrpId${list.dvclasNo}"
                                                               name="lrnGrpIds"
                                                               value="">

                                                            <%-- 선택한 학습그룹명 --%>
                                                        <input class="form-control width-60per"
                                                               type="text"
                                                               id="lrnGrpnm${list.dvclasNo}"
                                                               placeholder="학습그룹을 선택해 주세요."
                                                               readonly
                                                               autocomplete="off">

                                                        <a class="btn type1 small"
                                                           onclick="lrnGrpSelectPop('${list.dvclasNo}','${list.sbjctId}')">학습그룹지정</a>
                                                    </div>
                                                </div>

                                                <%-- 분반별 학습그룹 과제설정 영역 --%>
                                                <div class="ui segment"
                                                     id="setSubAsmtDiv${list.dvclasNo}"
                                                    ${list.sbjctId eq asmtVO.sbjctId ? "" : "style='display:none;'"}>

                                                <span class="custom-input">
                                                    <input type="checkbox"
                                                           name="byteamAsmtUseyns"
                                                           id="byteamAsmtUseyn_${list.dvclasNo}"
                                                           value="Y:${list.sbjctId}"
                                                           onchange="byteamAsmtUseynChange(this)">
                                                    <label for="byteamAsmtUseyn_${list.dvclasNo}">
                                                        학습그룹별 과제 설정
                                                    </label>
                                                </span>

                                                        <%-- 팀별 하위과제 입력영역 렌더링 영역 --%>
                                                    <div id="subAsmtInfoDiv${list.dvclasNo}" style="display:none;"></div>
                                                </div>

                                                <c:if test="${status.first}">
                                                    <div class="msg-box warning">
                                                        <p class="txt"><i class="xi-error" aria-hidden="true"></i>구성된 팀이 없는 경우 메뉴 “과목설정 &gt; 학습그룹지정”에서 팀을 생성해 주세요.</p>
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                    </td>
                                </tr>

                                <tr>
                                    <th>
                                        <label for="indLabel">
                                            <spring:message code="asmnt.label.individual.asmnt"/><!-- 개별과제 -->
                                        </label>
                                    </th>
                                    <td>
                                        <div class="form-inline mb10">
                                            <span class="custom-input">
                                                <input type="radio" name="indvAsmtyn" id="indN" value="N" ${asmtVO.indvAsmtyn eq 'N' || empty asmtVO.asmtId ? 'checked' : '' }>
                                                <label for="indN">
                                                    <spring:message code="message.no"/><!-- 아니오 -->
                                                </label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="indvAsmtyn" id="indY" value="Y" ${asmtVO.indvAsmtyn eq 'Y' ? 'checked' : '' }>
                                                <label for="indY">
                                                    <spring:message code="message.yes"/><!-- 예 -->
                                                </label>
                                            </span>
                                        </div>

                                        <div class="msg-box warning">
                                            <p class="txt"><i class="xi-error" aria-hidden="true"></i><spring:message code="asmnt.label.indi.info"/></p><!-- 전체 수강생 중 지정된 개별인원에게만 부여되며, 해당과제는 성적반영이 불가합니다. -->
                                        </div>


                                        <div class="ui segment bcLgrey9" id="viewIndivAsmt">
                                            <div class="swapLists">
                                                <div class="swapListsItem">
                                                    <div class="option-content mb10">
                                                        <label for="b1" class="mra"><spring:message code="button.list.student"/></label>
                                                        <!-- 수강생 목록 -->
                                                        <div class="ui action input search-box">
                                                            <%--                                                                <span class="custom-input">--%>
                                                            <input type="text" id="tgSearch"
                                                                   placeholder="<spring:message code='team.popup.search.placeholder'/>">
                                                            <!-- 학과, 학번, 이름 입력 -->
                                                            <button type="button"
                                                                    class="ui icon button"
                                                                    onclick="indiSearch('T')"><i
                                                                    class="search icon"></i>
                                                            </button>
                                                            <%--                                                                </span>--%>
                                                        </div>
                                                    </div>

                                                    <table class="tbl_fix type2">
                                                        <thead>
                                                        <tr>
                                                            <th class="wf5">
                                                                <div class="ui checkbox">
                                                                    <%--                                                                    <span class="custom-input">--%>
                                                                    <input type="checkbox" id="tg0"
                                                                           tabindex="0"
                                                                           class="hidden">
                                                                    <label class="toggle_btn"
                                                                           for="tg0"></label>
                                                                    <%--                                                                    </span>--%>
                                                                </div>
                                                            </th>
                                                            <!-- NO. -->
                                                            <th class="wf15"><spring:message code="common.number.no"/></th>
                                                            <th><spring:message code="asmnt.label.dept.nm"/></th>
                                                            <!-- 학과 -->
                                                            <th><spring:message code="asmnt.label.user_id"/></th>
                                                            <!-- 학번 -->
                                                            <th><spring:message code="asmnt.label.user_nm"/></th>
                                                            <!-- 이름 -->
                                                        </tr>
                                                        </thead>
                                                        <tbody id="indvAsmtList"></tbody>
                                                    </table>
                                                </div>

                                                <div class="button-area">
                                                    <%--                                                        <span class="custom-input">--%>
                                                    <button type='button'
                                                            class="ui basic icon button"
                                                            data-medi-ui="swap"
                                                            data-swap-to="right"
                                                            data-swap-target="tr"
                                                            data-swap-arrival="tbody"
                                                            title="<spring:message code='team.popup.button.right'/>">
                                                        <!-- 오른쪽으로 이동 -->
                                                        <i class="arrow right icon"></i>
                                                    </button>
                                                    <%--                                                        </span>--%>
                                                    <%--                                                    <span class="custom-input">--%>
                                                    <button type='button'
                                                            class="ui basic icon button"
                                                            data-medi-ui="swap"
                                                            data-swap-to="left"
                                                            data-swap-target="tr"
                                                            data-swap-arrival="tbody"
                                                            title="<spring:message code='team.popup.button.left'/>">
                                                        <!-- 왼쪽으로 이동 -->
                                                        <i class="arrow left icon"></i>
                                                    </button>
                                                    <%--                                                        </span>--%>
                                                </div>
                                                <div class="swapListsItem">
                                                    <div class="option-content mb10">
                                                        <label for="b1" class="mra"><spring:message
                                                                code="asmnt.label.ind.asmnt.user"/></label>
                                                        <!-- 개별과제 대상자 -->
                                                        <div class="ui action input search-box">
                                                            <%--                                                                <span class="custom-input">--%>
                                                            <input type="text" id="stgSearch"
                                                                   placeholder="<spring:message code='team.popup.search.placeholder'/>">
                                                            <!-- 학과, 학번, 이름 입력 -->
                                                            <button type="button"
                                                                    class="ui icon button"
                                                                    onclick="indiSearch('S')"><i
                                                                    class="search icon"></i>
                                                            </button>
                                                            <%--                                                                </span>--%>
                                                        </div>
                                                    </div>
                                                    <table class="tbl_fix type2">
                                                        <thead>
                                                        <tr>
                                                            <th class="wf5">
                                                                <div class="ui checkbox">
                                                                    <%--                                                                        <span class="custom-input">--%>
                                                                    <input type="checkbox" id="stg0"
                                                                           tabindex="0"
                                                                           class="hidden">
                                                                    <label class="toggle_btn"
                                                                           for="stg0"></label>
                                                                    <%--                                                                        </span>--%>
                                                                </div>
                                                            </th>
                                                            <!-- NO. -->
                                                            <th class="wf15"><spring:message code="common.number.no"/></th>
                                                            <th><spring:message code="asmnt.label.dept.nm"/></th>
                                                            <!-- 학과 -->
                                                            <th><spring:message code="asmnt.label.user_id"/></th>
                                                            <!-- 학번 -->
                                                            <th><spring:message code="asmnt.label.user_nm"/></th>
                                                        </tr>
                                                        </thead>
                                                        <tbody id="sindvAsmtList"></tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>


                                </tbody>
                            </table>
                            <div class="options_wrap">
                                <ul class="accordion">
                                    <li class="">
                                        <div class="title-wrap">
                                            <a class="title" href="#">
                                                <div class="lecture_tit">
                                                    <strong>옵션</strong>
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
                                                        <th><label class="req"><spring:message code="asmnt.label.read.allow"/></label></th><!-- 과제읽기 허용 -->
                                                        <td>
                                                            <div class="form-inline mb10">
                                                                <span class="custom-input">
                                                                    <input type="radio" name="sbasmtOstdOyn" id="sbasmtOstdN" value="N" ${asmtVO.sbasmtOstdOyn eq 'N' || empty asmtVO.asmtId ? 'checked' : '' }>
                                                                    <label for="sbasmtOstdN"><spring:message code="asmnt.common.no"/></label>
                                                                </span>
                                                                <span class="custom-input ml5">
                                                                    <input type="radio" name="sbasmtOstdOyn" id="sbasmtOstdY" value="Y" ${asmtVO.sbasmtOstdOyn eq 'Y' ? 'checked' : '' }>
                                                                    <label for="sbasmtOstdY"><spring:message code="asmnt.common.yes"/></label>
                                                                </span>
                                                            </div>

                                                            <div id="viewSbasmtOstd">
                                                                <div class="date_area">
                                                                    <input id="ostdOpenSdttmDateSt" type="text" name="ostdOpenSdttmDateSt" class="datepicker" timeId="ostdOpenSdttmTimeSt">
                                                                    <input id="ostdOpenSdttmTimeSt" type="text" name="ostdOpenSdttmTimeSt" class="timepicker" dateId="ostdOpenSdttmDateSt">
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </li>
                                </ul>
                            </div>
                        </form>
                    </div>

                </div>
            </div>
        </div>
    </main>
</div>

<script type="text/javascript">
    const SBJCT_ID = '<c:out value="${asmtVO.sbjctId}"/>';
    const ASMT_ID = '<c:out value="${asmtVO.asmtId}"/>';

    const SUB_ASMT_EDITORS = {};           // 팀별 부과제 에디터 목록
    let subAsmtUploaderIds = [];           // 팀별 업로더 ID 목록 (순서 보장)
    let subAsmtUploadResults = {};         // { uploaderId : { uploadFiles, uploadPath, delFileIdStr, copyFiles } }

    let isEditMode = false;   // 수정 여부
    let isIndvListLoaded = false;       // 개별과제 대상자 목록 조회 여부
    let dialog;

    $(document).ready(function () {

        /**
         * 수정 여부 설정
         */
        isEditMode = "${mode}" === "E" || !!ASMT_ID;
        initView(); // 초기 화면 제어
        bindEvents(); // 이벤트 바인딩
        bindDvclasEvents(); // 분반 이벤트 바인딩
        applyCurrentView(); // 초기상태반영

        // 수정 모드면 상세 조회
        if (ASMT_ID) {
            getAsmt(ASMT_ID);
        }
    });


    /**
     * =========================================================
     * 초기 화면 처리
     * =========================================================
     */
    function initView() {
        $("#viewExtdSbmsnPrm").hide();
        $("#mutEvalDiv").hide();
        $("#viewPrtc").hide();
        $("#viewSbasmtTycdFile").hide();
        $("#viewTeamAsmt").hide();
        $("#viewIndivAsmt").hide();
        $("#viewSbasmtOstd").hide();
    }


    /**
     * =========================================================
     * 이벤트 바인딩
     * =========================================================
     */
    function bindEvents() {

        /**
         * 버튼 이벤트
         */
        $("#btnSave").on("click", saveConfirm);
        $("#btnCopy").on("click", copyAsmt);
        $("#btnGoList").on("click", moveAsmtList);

        /**
         * 화면 반영이 필요한 항목 묶어서 처리
         */
        $(
            "input[name='extdSbmsnPrmyn']"
            + ", input[name='evlScrTycd']"
            + ", input[name='asmtPrctcyn']"
            + ", input[name='sbasmtTycd']"
            + ", input[name='mrkRfltyn']"
            + ", input[name='sbasmtOstdOyn']"
        ).on("change", applyCurrentView);

        /**
         * 팀과제/개별과제 상호배제
         */
        $("input[name='teamAsmtStngyn']").on("change", function () {
            if ($(this).val() === "Y") {
                $("input[name='indvAsmtyn'][value='N']").prop("checked", true);
            } else {
                $("input[name='tmbrIndivSbmsnPrmyn'][value='N']").prop("checked", true);
            }
            applyCurrentView();
        });

        $("input[name='indvAsmtyn']").on("change", function () {
            if ($(this).val() === "Y") {
                $("input[name='teamAsmtStngyn'][value='N']").prop("checked", true);
                $("input[name='tmbrIndivSbmsnPrmyn'][value='N']").prop("checked", true);
            }
            applyCurrentView();
        });

        /**
         * 제출 종료일, 연장 종료일 변경 시 과제읽기 허용일 동기화
         */
        $("#asmtSbmsnDateEd, #asmtSbmsnTimeEd, #extdSbmsnDateEd, #extdSbmsnTimeEd").on("change", syncSbasmtOpenDate);

        /**
         * 제출형식 라디오 변경 시 세부 체크 초기화
         */
        $("input[name='sbmsnFileMimeTycd']").on("change", function () {
            $("input[name='preFile']").prop("checked", false);
            $("input[name='docFile']").prop("checked", false);
        });

        /**
         * 미리보기 파일 체크 시 문서 파일 체크 해제
         */
        $("input[name='preFile']").on("change", function () {
            $("#preFile").prop("checked", true);
            $("input[name='docFile']").prop("checked", false);
        });

        /**
         * 문서 파일 체크 시 미리보기 파일 체크 해제
         */
        $("input[name='docFile']").on("change", function () {
            $("#docFile").prop("checked", true);
            $("input[name='preFile']").prop("checked", false);
        });

        /**
         * 루브릭 팝업 닫기 처리
         */
        $("#mutEvalWritePop").on("hidden.bs.modal", function () {
            if (!$("#asmtEvlId").val()) {
                $("input[name='evlScrTycd'][value='SCR']").prop("checked", true);
                applyCurrentView();
            }
        });

        /**
         * 개별과제 - 수강생 전체 선택
         */
        $("#tg0").on("change", function () {
            const checked = this.checked;

            $("#indvAsmtList input[type='checkbox']").each(function () {
                if ($(this).closest("tr").css("display") !== "none") {
                    this.checked = checked;
                }
            });
        });

        /**
         * 개별과제 - 할당목록 전체 선택
         */
        $("#stg0").on("change", function () {
            const checked = this.checked;

            $("#sindvAsmtList input[type='checkbox']").each(function () {
                if ($(this).closest("tr").css("display") !== "none") {
                    this.checked = checked;
                }
            });
        });
    }


    /**
     * =========================================================
     * 현재 상태에 맞춰 화면 제어
     * =========================================================
     */
    function applyCurrentView() {

        /**
         * 현재 선택 값 조회
         */
        const extdSbmsnPrmyn = $("input[name='extdSbmsnPrmyn']:checked").val();
        const evlScrTycd = $("input[name='evlScrTycd']:checked").val();
        const asmtPrctcyn = $("input[name='asmtPrctcyn']:checked").val();
        const sbasmtTycd = $("input[name='sbasmtTycd']:checked").val();
        const teamAsmtStngyn = $("input[name='teamAsmtStngyn']:checked").val();
        const indvAsmtyn = $("input[name='indvAsmtyn']:checked").val();
        const mrkRfltyn = $("input[name='mrkRfltyn']:checked").val();
        const sbasmtOstdOyn = $("input[name='sbasmtOstdOyn']:checked").val();

        /**
         * 연장제출
         */
        $("#viewExtdSbmsnPrm").toggle(extdSbmsnPrmyn === "Y");

        /**
         * 평가방법 - 루브릭
         */
        $("#mutEvalDiv").toggle(evlScrTycd === "RUBRIC_SCR");

        /**
         * 실기과제
         * - 실기과제 선택 시 제출형식 숨김
         */
        if (asmtPrctcyn === "Y") {
            $("#viewPrtc").show();
            $("#viewSbasmtTycd").hide();

            /**
             * 실기과제는 제출형식 FILE 고정
             */
            $("input[name='sbasmtTycd'][value='FILE']").prop("checked", true);
        } else {
            $("#viewPrtc").hide();
            $("#viewSbasmtTycd").show();
        }

        /**
         * 제출형식 - 파일 상세
         */
        $("#viewSbasmtTycdFile").toggle(sbasmtTycd === "FILE" && asmtPrctcyn !== "Y");

        /**
         * 팀과제 / 개별과제 상호배제
         */
        if (teamAsmtStngyn === "Y") {
            $("#viewTeamAsmt").show();
            $("#viewIndivAsmt").hide();
            toggleTeamGroupView();
        } else if (indvAsmtyn === "Y") {
            $("#viewTeamAsmt").hide();
            $("#viewIndivAsmt").show();


            /**
             * 개별과제는 성적반영 불가
             */
            if (mrkRfltyn === "Y") {
                alert("<spring:message code='asmnt.alert.ind.score.aply' />");/* 개별과제는 성적반영 불가능 합니다. */
                $("input[name='mrkRfltyn'][value='N']").prop("checked", true);
            }

            /**
             * 개별과제 대상자 목록 최초 1회 조회
             */
            if (!isIndvListLoaded) {
                getIndivAsmtStdList();
            }
        } else {
            $("#viewTeamAsmt").hide();
            $("#viewIndivAsmt").hide();
        }

        /**
         * 과제읽기 허용
         */
        $("#viewSbasmtOstd").toggle(sbasmtOstdOyn === "Y");

        /**
         * 과제읽기 허용이 Y면 제출 종료일 기준으로 자동 세팅
         */
        if (sbasmtOstdOyn === "Y") {
            syncSbasmtOpenDate();
        }
    }

    /**
     * =========================================================
     * 과제읽기 허용일 동기화
     * - 연장제출 Y면 연장제출 종료일
     * - 아니면 제출 종료일
     * =========================================================
     */
    function syncSbasmtOpenDate() {
        if ($("input[name='sbasmtOstdOyn']:checked").val() !== "Y") {
            return;
        }

        const extdSbmsnPrmyn = $("input[name='extdSbmsnPrmyn']:checked").val();

        if (extdSbmsnPrmyn === "Y") {
            asmtDateUtil.copyDateTimeVal("extdSbmsnDateEd", "extdSbmsnTimeEd", "ostdOpenSdttmDateSt", "ostdOpenSdttmTimeSt");
        } else {
            asmtDateUtil.copyDateTimeVal("asmtSbmsnDateEd", "asmtSbmsnTimeEd", "ostdOpenSdttmDateSt", "ostdOpenSdttmTimeSt");
        }
    }

    /**
     * 분반 체크박스 이벤트
     */
    function bindDvclasEvents() {

        $("input[name='dvclasList']").on("click", function (e) {
            const value = e.target.value;

            if (value === "ALL") {
                const checked = $("#dvclasAll").is(":checked");

                $("input[name='dvclasList']").each(function () {
                    if (this.value !== "ALL" && this.value !== SBJCT_ID) {
                        this.checked = checked;
                    }
                });
            } else {
                let checkedCount = 0;
                let totalCount = 0;

                $("input[name='dvclasList']").each(function () {
                    if (this.value !== "ALL") {
                        totalCount++;
                        if (this.checked) {
                            checkedCount++;
                        }
                    }
                });

                $("#dvclasAll").prop("checked", checkedCount === totalCount);
            }

            toggleTeamGroupView();
        });

        toggleTeamGroupView();
    }

    /**
     * =========================================================
     * 팀과제 분반별 학습그룹 영역 표시
     * - 본인 분반은 항상 표시
     * - 추가 선택한 분반도 표시
     * =========================================================
     */
    function toggleTeamGroupView() {

        $("input[name='dvclasList']").each(function () {
            const value = this.value;

            if (value !== "ALL") {
                const isBaseSbjct = value === SBJCT_ID
                const $target = $("#lrnGrpView" + getDvclasNoBySbjctId(value));
                const $setDiv = $("#setSubAsmtDiv" + getDvclasNoBySbjctId(value));
                const $lrnGrpId = $("#lrnGrpId" + getDvclasNoBySbjctId(value));
                const $lrnGrpnm = $("#lrnGrpnm" + getDvclasNoBySbjctId(value));

                if (isBaseSbjct || this.checked) {
                    $target.show();
                    $setDiv.show();
                    $lrnGrpId.removeAttr("disabled");
                } else {
                    $target.hide();
                    $setDiv.hide();

                    $lrnGrpId.attr("disabled", "disabled").val("");
                    $lrnGrpnm.val("");

                    $("#byteamAsmtUseyn_" + getDvclasNoBySbjctId(value)).prop("checked", false);
                    $("#subAsmtInfoDiv" + getDvclasNoBySbjctId(value)).hide().empty();
                }
            }
        });
    }

    /**
     * sbjctId로 dvclasNo 조회
     * @param sbjctId 과목아이디
     * @returns {string} 분반번호
     */
    function getDvclasNoBySbjctId(sbjctId) {
        let dvclasNo = "";

        $("#viewTeamAsmt [data-sbjct-id='" + sbjctId + "']").each(function () {
            dvclasNo = $(this).data("dvclas-no");
        });

        return dvclasNo;
    }

    /**
     * 학습그룹별 과제 설정 체크 변경
     * @param obj 선택그룹
     */
    function byteamAsmtUseynChange(obj) {
        const $obj = $(obj);
        const checked = $obj.is(":checked");
        const sbjctId = ($obj.val() || "").split(":")[1];
        const dvclasNo = $obj.attr("id").replace("byteamAsmtUseyn_", "");
        const lrnGrpIdVal = $("#lrnGrpId" + dvclasNo).val() || "";
        const lrnGrpId = lrnGrpIdVal.split(":")[0];

        /**
         * 학습그룹 미선택 시 체크 불가
         */
        if (!lrnGrpId) {
            alert("먼저 학습그룹을 선택해 주세요.");
            $obj.prop("checked", false);
            return;
        }

        if (checked) {
            $("#subAsmtInfoDiv" + dvclasNo).show();
            loadAsmtTeamList(lrnGrpId, dvclasNo, sbjctId);
        } else {
            $("#subAsmtInfoDiv" + dvclasNo).hide().empty();
        }
    }

    /**
     * =========================================================
     *
     * =========================================================
     */
    /**
     * 학습그룹 팀 목록 조회 후 하위과제 입력영역 렌더링
     * @param lrnGrpId 학습그룹아이디
     * @param dvclasNo 분반번호
     * @param sbjctId 과목아이디
     * @param overrideUpAsmtId - 등록: 없음, 수정: 과제ID, 복사: 이전과제ID
     */
    function loadAsmtTeamList(lrnGrpId, dvclasNo, sbjctId, overrideUpAsmtId) {

        const url = "/asmt2/profAsmtLrnGrpTeamListAjax.do";
        const data = {
            lrnGrpId: lrnGrpId,
            upAsmtId: overrideUpAsmtId !== undefined ? overrideUpAsmtId : ($("#asmtId").val() || "")
        };

        ajaxCall(url, data, function (resp) {

            if (resp.result > 0) {
                const returnList = resp.returnList || [];
                const html = buildAsmtTeamListHtml(returnList, dvclasNo, sbjctId);

                $("#subAsmtInfoDiv" + dvclasNo).empty().html(html);
                /*
                 * 재조회 시 중복 방지
                 */
                subAsmtUploaderIds = [];
                subAsmtUploadResults = {};

                /*
                 * 팀별 에디터 생성
                 */
                if (returnList.length > 0) {
                    returnList.forEach(function (item, idx) {

                        const editorId = item.teamId + "_subAsmtCts_" + idx;
                        SUB_ASMT_EDITORS[editorId] = UiEditor({
                            targetId: editorId,
                            uploadPath: "${asmtVO.uploadPath}",
                            height: "250px"
                        });

                        createSubAsmtFileUploader(item.teamId, idx, "${asmtVO.uploadPath}");
                    });
                }
            } else {
                alert(resp.message);
            }
        }, function () {
            alert("팀 목록 조회 중 오류가 발생했습니다.");
        }, true);
    }

    /**
     * =========================================================
     * 팀별 부과제 파일 업로더 생성
     * =========================================================
     */
    function createSubAsmtFileUploader(teamId, idx, uploadPath) {

        const uploaderId = "subAsmtFileUploader_" + teamId + "_" + idx;
        const wrapId = "subAsmtUploaderWrap_" + teamId + "_" + idx;

        UiFileUploader({
            id: uploaderId,
            targetId: wrapId,
            path: uploadPath,
            limitCount: 5,
            limitSize: 1024,
            oneLimitSize: 1024,
            listSize: 3,
            fileList: "",
            finishFunc: onSubAsmtUploadComplete,
            allowedTypes: "*"
        });

        if (subAsmtUploaderIds.indexOf(uploaderId) === -1) {
            subAsmtUploaderIds.push(uploaderId);
        }
    }

    /**
     * =========================================================
     * 팀별 하위과제 입력 HTML 생성
     * =========================================================
     */
    function buildAsmtTeamListHtml(list, dvclasNo, sbjctId) {

        if (!list || list.length === 0) {
            return '<p class="p_gray">팀 정보가 없습니다.</p>';
        }

        let html = "";
        html += "<table class='table-type2'>";
        html += "    <colgroup>";
        html += "        <col class='width-10per' />";
        html += "        <col class='' />";
        html += "        <col class='width-10per' />";
        html += "    </colgroup>";
        html += "    <tbody>";
        html += "        <tr>";
        html += "            <th>팀</th>";
        html += "            <th>부주제 / 내용</th>";
        html += "            <th>학습그룹 구성원</th>";
        html += "        </tr>";

        list.forEach(function (item, idx) {

            const teamId = UiComm.escapeHtml(item.teamId || "");
            const teamNm = UiComm.escapeHtml(item.teamnm || "");
            const asmtId = UiComm.escapeHtml(item.asmtId || "");
            const asmtTtl = UiComm.escapeHtml(item.asmtTtl || "");
            const asmtCts = UiComm.escapeHtml(item.asmtCts || "");
            const leadernm = UiComm.escapeHtml(item.leadernm || "-");
            const teamMbrCnt = Math.max(0, (item.teamMbrCnt || 1) - 1);

            html += "    <tr class='subAsmtTr'";
            html += "        data-team-id='" + teamId + "'";
            html += "        data-team-nm='" + teamNm + "'";
            html += "        data-dvclas-no='" + UiComm.escapeHtml(dvclasNo || "") + "'";
            html += "        data-sbjct-id='" + UiComm.escapeHtml(sbjctId || "") + "'";
            html += "        data-asmt-id='" + asmtId + "'>";
            html += "        <th><label>" + teamNm + "</label></th>";
            html += "        <td>";

            /**
             * 저장용 hidden
             */
            html += "            <input type='hidden' name='subAsmtSbjctIds' value='" + UiComm.escapeHtml(sbjctId || "") + "' />";
            html += "            <input type='hidden' name='subAsmtTeamIds' value='" + teamId + "' />";
            html += "            <input type='hidden' name='subAsmtIds' value='" + asmtId + "' />";
            html += "            <input type='hidden' name='subAsmtCtsArr' id='" + teamId + "_subAsmtCtsHidden_" + idx + "' value='' />";

            html += "            <table class='table-type5'>";
            html += "                <colgroup>";
            html += "                    <col class='width-10per' />";
            html += "                    <col class='' />";
            html += "                </colgroup>";
            html += "                <tbody>";
            html += "                    <tr>";
            html += "                        <th><label for='" + teamId + "_subAsmtTtl_" + idx + "' class='req'>부주제</label></th>";
            html += "                        <td>";
            html += "                            <input type='text'";
            html += "                                   id='" + teamId + "_subAsmtTtl_" + idx + "'";
            html += "                                   name='subAsmtTtls'";
            html += "                                   value='" + asmtTtl + "'";
            html += "                                   class='width-100per' />";
            html += "                        </td>";
            html += "                    </tr>";

            html += "                    <tr>";
            html += "                        <th><label for='" + teamId + "_subAsmtCts_" + idx + "' class='req'>내용</label></th>";
            html += "                        <td>";
            html += "                            <div class='editor-box'>";
            html += "                                <textarea";
            html += "                                    name='" + teamId + "_subAsmtCts_" + idx + "'";
            html += "                                    id='" + teamId + "_subAsmtCts_" + idx + "'>";
            html += asmtCts;
            html += "                                </textarea>";
            html += "                            </div>";
            html += "                        </td>";
            html += "                    </tr>";

            html += "                    <tr>";
            html += "                        <th><label>첨부파일</label></th>";
            html += "                        <td>";
            html += "                            <div id='subAsmtUploaderWrap_" + teamId + "_" + idx + "'></div>";
            html += "                        </td>";
            html += "                    </tr>";

            html += "                </tbody>";
            html += "            </table>";
            html += "        </td>";
            html += "        <th>" + leadernm + " 외 " + teamMbrCnt + "</th>";
            html += "    </tr>";
        });

        html += "    </tbody>";
        html += "</table>";

        return html;
    }

    /**
     * =========================================================
     * 부과제 내용 hidden 동기화
     * =========================================================
     */
    function buildSubAsmtCtsArr() {

        $("#asmtWriteForm .subAsmtTr").each(function (idx) {

            const teamId = $(this).data("team-id");
            const editorId = teamId + "_subAsmtCts_" + idx;
            const hiddenId = teamId + "_subAsmtCtsHidden_" + idx;

            let cts = "";
            const $editor = $("#" + editorId);

            if ($editor.length > 0) {
                cts = $editor.val() || "";
            }

            $("#" + hiddenId).val(cts);
        });
    }

    /**
     * =========================================================
     * 팀별 부과제 상세 hidden 제거
     * =========================================================
     */
    function resetSubAsmtDetailParams() {
        $("#asmtWriteForm input.__subAsmtDtlParam").remove();
    }

    /**
     * =========================================================
     * 팀별 부과제 상세 hidden 추가
     * =========================================================
     */
    function appendSubAsmtDetailParam(index, fieldName, value) {
        $("<input>", {
            type: "hidden",
            name: "subAsmtDtlList[" + index + "]." + fieldName,
            value: value || "",
            "class": "__subAsmtDtlParam"
        }).appendTo("#asmtWriteForm");
    }

    /**
     * =========================================================
     * 팀별 부과제 상세 파라미터 조립
     * =========================================================
     */
    function appendSubAsmtDetailParams() {
        resetSubAsmtDetailParams();
        buildSubAsmtCtsArr();

        let index = 0;

        $("#asmtWriteForm .subAsmtTr").each(function (rowIdx) {

            const $row = $(this);

            const sbjctId = ($row.data("sbjct-id") || "").toString();
            const dvclasNo = ($row.data("dvclas-no") || "").toString();
            const teamId = ($row.data("team-id") || "").toString();
            const teamNm = ($row.data("team-nm") || "").toString();
            const subAsmtId = ($row.data("asmt-id") || "").toString();

            const title = ($row.find("input[name='subAsmtTtls']").val() || "").trim();
            const cts = ($("#" + teamId + "_subAsmtCtsHidden_" + rowIdx).val() || "").trim();

            const uploaderId = "subAsmtFileUploader_" + teamId + "_" + rowIdx;
            const uploadResult = subAsmtUploadResults[uploaderId] || {};

            if (!sbjctId || !teamId) {
                return;
            }

            appendSubAsmtDetailParam(index, "sbjctId", sbjctId);
            appendSubAsmtDetailParam(index, "dvclasNo", dvclasNo);
            appendSubAsmtDetailParam(index, "teamId", teamId);
            appendSubAsmtDetailParam(index, "teamNm", teamNm);
            appendSubAsmtDetailParam(index, "asmtId", subAsmtId);
            appendSubAsmtDetailParam(index, "asmtTtl", title);
            appendSubAsmtDetailParam(index, "asmtCts", cts);
            appendSubAsmtDetailParam(index, "uploadFiles", uploadResult.uploadFiles || "");
            appendSubAsmtDetailParam(index, "uploadPath", uploadResult.uploadPath || "${asmtVO.uploadPath}");
            appendSubAsmtDetailParam(index, "delFileIdStr", uploadResult.delFileIdStr || "");
            appendSubAsmtDetailParam(index, "copyFiles", uploadResult.copyFiles || "");
            index++;
        });
    }


    /**
     * =========================================================
     * 개별과제 수강생 목록 조회
     * =========================================================
     */
    function getIndivAsmtStdList(asmtId) {

        const url = "/asmt2/profIndivAsmtStdListAjax.do";
        const data = {
            sbjctId: SBJCT_ID
        };

        ajaxCall(url, data, function (data) {

            if (data.result > 0) {

                let html = "";

                data.returnList.forEach(function (o, i) {
                    html += "<tr>";
                    html += "    <td class='wf5'>";
                    html += "        <div class='ui checkbox'>";
                    html += "        <span class='custom-input'>";
                    html += "            <input type='hidden' value='" + o.userId + "'/>";
                    html += "            <input type='checkbox' id='tg" + (i + 1) + "' tabindex='0' class='hidden'/>";
                    html += "            <label class='toggle_btn' for='tg" + (i + 1) + "'></label>";
                    html += "        </span>";
                    html += "        </div>";
                    html += "    </td>";
                    html += "    <td class='wf15'>" + (i + 1) + "</td>";
                    html += "    <td class='tgList'>" + o.deptnm + "</td>";
                    html += "    <td class='tgList'>" + o.stdntNo + "</td>";
                    html += "    <td class='tgList'>" + o.usernm + "</td>";
                    html += "</tr>";
                });

                $("#indvAsmtList").empty().append(html);
                isIndvListLoaded = true;

                if (asmtId) {
                    getIndivAsmtSbmsnTrgtList(asmtId);
                }
            } else {
                UiComm.showMessage(data.message, "error");
            }
        }, function () {
            UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");
        }, true);
    }


    /**
     * =========================================================
     * 개별 과제 제출 대상 목록 조회
     * =========================================================
     */
    function getIndivAsmtSbmsnTrgtList(asmtId) {

        const url = "/asmt2/profIndivAsmtSbmsnTrgtListAjax.do";
        const data = {
            searchType: "LIST",
            sbjctId: SBJCT_ID,
            asmtId: asmtId
        };

        ajaxCall(url, data, function (data) {

            if (data.result > 0) {

                let html = "";
                data.returnList.forEach(function (o, i) {
                    html += "<tr>";
                    html += "    <td class='wf5'>";
                    html += "        <div class='ui checkbox'>";
                    html += "        <span class='custom-input'>";
                    html += "            <input type='hidden' value='" + o.userId + "'>";
                    html += "            <input type='checkbox' id='tgr" + (i + 1) + "' tabindex='0' class='hidden'>";
                    html += "            <label class='toggle_btn' for='tgr" + (i + 1) + "'></label>";
                    html += "        </span>";
                    html += "        </div>";
                    html += "    </td>";
                    html += "    <td class='wf15'>" + (i + 1) + "</td>";
                    html += "    <td class='tgList'>" + o.deptnm + "</td>";
                    html += "    <td class='tgList'>" + o.stdntNo + "</td>";
                    html += "    <td class='tgList'>" + o.usernm + "</td>";
                    html += "</tr>";

                    $("#indvAsmtList input[value='" + o.userId + "']").closest("tr").remove();
                });

                $("#indvAsmtList tr").each(function (i) {
                    $("#indvAsmtList tr:eq(" + i + ") td:eq(1)").text(i + 1);
                });

                $("#sindvAsmtList").empty().append(html);
            } else {
                UiComm.showMessage(data.message, "error");
            }
        }, function () {
            alert("<spring:message code='fail.common.msg' />");
        }, true);
    }


    /**
     * =========================================================
     * TODO: 이전 과제 가져오기 팝업
     * =========================================================
     */
    function asmtCopyList() {
        const modalId = "Ap02";
        initModal(modalId);

        const kvArr = [];
        kvArr.push({key: "userId", val: "${asmtVO.userId}"});
        kvArr.push({key: "crsCreCd", val: "${crsCreCd}"});

        submitForm("/asmt/profAsmtCopyPopView.do", modalId + "ModalIfm", kvArr);
    }


    /**
     * =========================================================
     * TODO: 이전 과제 복사
     * =========================================================
     */
    function copyAsmt() {
        isEditMode = false;
        dialog = UiDialog("dialog1", {
            title: "이전과제가저오기",
            width: 800,
            height: 500,
            url: "/asmt2/profAsmtCopyPop.do?sbjctId=" + SBJCT_ID,
            autoresize: false
        });
    }


    /**
     * =========================================================
     * 과제 조회
     * =========================================================
     */
    function getAsmt(asmtId) {

        const url = "/asmt2/profAsmtSelectAjax.do";
        const data = {
            sbjctId: SBJCT_ID
            , asmtId: asmtId
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                const vo = data.returnVO;
                setData(vo);

            } else {
                alert(data.message);
            }
        }, function () {
            alert("<spring:message code='fail.common.msg' />");
        }, true);
    }


    /**
     * =========================================================
     * 상세 데이터 바인딩
     * - 수정: 실제 값 세팅
     * - 복사/등록: 날짜/일부 옵션 초기화
     * =========================================================
     */
    function setData(asmtData) {

        /**
         * 에디터
         */
        /* editor.execCommand("selectAll");
         editor.execCommand("deleteLeft");
         editor.execCommand("insertText", "");
         editor.openHTML($.trim(asmtData.asmtCts || ""));*/

        /**
         * 기본값
         */
        $("#asmtTtl").val(asmtData.asmtTtl || "");

        /**
         * 등록/수정 공통 초기화
         */
        $("input[name='sbasmtTycd'][value='FILE']").prop("checked", true);
        $("input[name='sbmsnFileMimeTycd'][value='all']").prop("checked", true);
        $("input[name='prtcFileType']").prop("checked", false);
        $("input[name='preFile']").prop("checked", false);
        $("input[name='docFile']").prop("checked", false);
        $("#allFile").prop("checked", true);
        $("#preFile").prop("checked", false);
        $("#docFile").prop("checked", false);
        $("#asmtEvlId").val("");
        $("#evalTitle").val("");

        /**
         * 수정 모드
         */
        if (isEditMode) {
            $("input[name='asmtId']").val(asmtData.asmtId || "");
            $("input[name='prevAsmtId']").val("");
            $("#dvclasView").hide();

            asmtDateUtil.setDateTimeVal("asmtSbmsnDateSt", "asmtSbmsnTimeSt", asmtData.asmtSbmsnSdttm);
            asmtDateUtil.setDateTimeVal("asmtSbmsnDateEd", "asmtSbmsnTimeEd", asmtData.asmtSbmsnEdttm);

            $("input[name='extdSbmsnPrmyn'][value='" + (asmtData.extdSbmsnPrmyn || "N") + "']").prop("checked", true);
            asmtDateUtil.setDateTimeVal("extdSbmsnDateEd", "extdSbmsnTimeEd", asmtData.extdSbmsnEdttm);

            $("input[name='asmtPrctcyn']").prop("disabled", true);
            $("input[name='teamAsmtStngyn']").prop("disabled", true);
            $("input[name='indvAsmtyn']").prop("disabled", true);
        } else {
            /**
             * 복사/등록 모드
             * - 날짜/연장제출/과제읽기허용은 초기화
             */
            $("input[name='asmtId']").val("");
            $("input[name='prevAsmtId']").val(asmtData.asmtId || "");
            $("#dvclasView").show();

            $("#asmtSbmsnDateSt, #asmtSbmsnTimeSt, #asmtSbmsnDateEd, #asmtSbmsnTimeEd").val("");
            $("#extdSbmsnDateEd, #extdSbmsnTimeEd").val("");
            $("#ostdOpenSdttmDateSt, #ostdOpenSdttmTimeSt").val("");

            $("input[name='extdSbmsnPrmyn'][value='N']").prop("checked", true);
            $("input[name='sbasmtOstdOyn'][value='N']").prop("checked", true);

            $("input[name='teamAsmtStngyn']").prop("disabled", false);
            $("input[name='indvAsmtyn']").prop("disabled", false);
        }

        /**
         * 성적반영 / 성적공개
         */
        if (asmtData.indvAsmtyn === "Y") {
            $("input[name='mrkRfltyn'][value='N']").prop("checked", true);
        } else {
            $("input[name='mrkRfltyn'][value='" + (asmtData.mrkRfltyn || "Y") + "']").prop("checked", true);
        }
        $("input[name='mrkOyn'][value='" + (asmtData.mrkOyn || "N") + "']").prop("checked", true);

        /**
         * 평가방법
         */
        $("input[name='evlScrTycd'][value='" + (asmtData.evlScrTycd || "SCR") + "']").prop("checked", true);

        if (asmtData.evlScrTycd === "RUBRIC_SCR") {
            $("#asmtEvlId").val(asmtData.asmtEvlId || "");
            $("#evalTitle").val(asmtData.evalTitle || "");
        }

        /**
         * 제출형식 / 실기과제
         */
        $("input[name='asmtPrctcyn'][value='" + (asmtData.asmtPrctcyn || "N") + "']").prop("checked", true);
        $("input[name='sbasmtTycd'][value='" + (asmtData.sbasmtTycd || "FILE") + "']").prop("checked", true);

        if (asmtData.asmtPrctcyn === "Y") {
            const prtcFileArr = (asmtData.sbmsnFileMimeTycd || "").split(",");

            prtcFileArr.forEach(function (fileTy) {
                $("input[name='prtcFileType'][value='" + $.trim(fileTy) + "']").prop("checked", true);
            });

            $("input[name='exlnAsmtDwldyn'][value='" + (asmtData.exlnAsmtDwldyn || "N") + "']").prop("checked", true);
        } else {
            const fileArr = (asmtData.sbmsnFileMimeTycd || "").split(",");

            if (!asmtData.sbmsnFileMimeTycd) {
                $("#allFile").prop("checked", true);
            } else {
                fileArr.forEach(function (fileTy, idx) {
                    const item = $.trim(fileTy);

                    if (["img", "pdf", "txt", "soc", "ppt2"].includes(item)) {
                        if (idx === 0) {
                            $("#preFile").prop("checked", true);
                        }
                        $("input[name='preFile'][value='" + item + "']").prop("checked", true);
                    } else if (["hwp", "doc", "ppt", "xls", "pdf2", "zip"].includes(item)) {
                        if (idx === 0) {
                            $("#docFile").prop("checked", true);
                        }
                        $("input[name='docFile'][value='" + item + "']").prop("checked", true);
                    }
                });
            }
        }

        /**
         * 팀과제 / 개별과제
         */
        $("input[name='teamAsmtStngyn'][value='" + (asmtData.teamAsmtStngyn || "N") + "']").prop("checked", true);
        $("input[name='indvAsmtyn'][value='" + (asmtData.indvAsmtyn || "N") + "']").prop("checked", true);

        if (isEditMode && asmtData.teamAsmtStngyn === "Y") {
            $("#lrnGrpId0").val((asmtData.lrnGrpId || "") + ":" + (asmtData.sbjctId || ""));
            $("#lrnGrpnm0").val(asmtData.lrnGrpnm || "");
        }

        if (isEditMode && asmtData.indvAsmtyn === "Y") {
            if (!isIndvListLoaded) {
                getIndivAsmtStdList(asmtData.asmtId);
            } else {
                getIndivAsmtSbmsnTrgtList(asmtData.asmtId);
            }
        }

        /**
         * 과제읽기 허용
         */
        if (isEditMode) {
            $("input[name='sbasmtOstdOyn'][value='" + (asmtData.sbasmtOstdOyn || "N") + "']").prop("checked", true);
            asmtDateUtil.setDateTimeVal("ostdOpenSdttmDateSt", "ostdOpenSdttmTimeSt", asmtData.sbasmtOstdOpenSdttm);
        } else {
            $("input[name='sbasmtOstdOyn'][value='N']").prop("checked", true);
        }

        /**
         * 첨부파일
         */
        const dx = dx5.get("upload1");

        if (dx != null) {
            dx.clearItems();

            if (asmtData.fileList && asmtData.fileList.length > 0) {
                const oldFiles = [];

                asmtData.fileList.forEach(function (file) {
                    oldFiles.push({
                        vindex: file.fileId,
                        name: file.fileNm,
                        size: file.fileSize,
                        saveNm: file.fileSaveNm
                    });
                });

                dx.addOldFileList(oldFiles);
                dx.showResetBtn();
            }
        }

        /**
         * 화면 상태 반영
         */
        applyCurrentView();
    }

    /**
     * =========================================================
     * 학습그룹별 하위과제 데이터 검증
     * =========================================================
     */
    function validateSubAsmtDetail() {

        let valid = true;

        $("input[name='byteamAsmtUseyns']:checked").each(function () {
            const dvclasNo = $(this).attr("id").replace("byteamAsmtUseyn_", "");
            const $rows = $("#subAsmtInfoDiv" + dvclasNo + " .subAsmtTr");

            if ($rows.length === 0) {
                alert("학습그룹에 등록된 팀이 없습니다.");
                valid = false;
                return false;
            }

            $rows.each(function () {
                const ttl = ($(this).find("input[name='subAsmtTtls']").val() || "").trim();

                if (!ttl) {
                    alert("팀별 부주제를 입력해 주세요.");
                    valid = false;
                    return false;
                }
            });

            if (!valid) {
                return false;
            }
        });

        return valid;
    }


    /**
     * =========================================================
     * 저장 전 검증
     * =========================================================
     */
    function validation() {

        const asmtTtl = ($("#asmtTtl").val() || "").trim();

        /**
         * 과제명
         */
        if (!asmtTtl) {
            alert("<spring:message code='asmnt.alert.input.asmnt_title' />");
            $("#asmtTtl").focus();
            return false;
        }

        /**
         * 제출기간
         */
        if (asmtDateUtil.isEmptyDateTime("asmtSbmsnDateSt", "asmtSbmsnTimeSt") || asmtDateUtil.isEmptyDateTime("asmtSbmsnDateEd", "asmtSbmsnTimeEd")) {
            alert("<spring:message code='asmnt.label.send.date' />");
            return false;
        }

        if (asmtDateUtil.isGreaterDateTime("asmtSbmsnDateSt", "asmtSbmsnTimeSt", "asmtSbmsnDateEd", "asmtSbmsnTimeEd")) {
            alert("<spring:message code='asmnt.label.send.date' />");
            return false;
        }

        /**
         * 실기과제 / 제출형식
         */
        if ($("input[name='asmtPrctcyn']:checked").val() === "Y") {
            if ($("input[name='prtcFileType']:checked").length < 1) {
                alert("<spring:message code='asmnt.label.prtc.filetype.select' />");
                return false;
            }
        } else {
            if ($("input[name='sbasmtTycd']:checked").length === 0) {
                alert("<spring:message code='asmnt.label.filetype.select' />");
                return false;
            }

            if ($("input[name='sbasmtTycd']:checked").val() === "FILE") {
                if ($("input[name='sbmsnFileMimeTycd']:checked").val() !== "all") {
                    if ($("input[name='preFile']:checked").length + $("input[name='docFile']:checked").length < 1) {
                        alert("<spring:message code='file.label.filetype.select' />");
                        return false;
                    }
                }
            }
        }

        /**
         * 팀과제
         */
        if ($("input[name='teamAsmtStngyn']:checked").val() === "Y") {
            let checkLrnGrpId = true;

            $("input[name='dvclasList']").each(function (i) {

                if (this.value !== "ALL") {
                    const sbjctId = this.value;
                    const dvclasNo = getDvclasNoBySbjctId(sbjctId);
                    if (this.checked && !$("#lrnGrpId" + dvclasNo).val()) {
                        checkLrnGrpId = false;
                        return false;
                    }
                }
            });

            if (!checkLrnGrpId) {
                UiComm.showMessage("학습그룹을 선택하세요", "info");
                return false;
            }

            if (!validateSubAsmtDetail()) {
                return false;
            }
        }

        /**
         * 개별과제
         */
        if ($("input[name='indvAsmtyn']:checked").val() === "Y") {
            if ($("#sindvAsmtList tr").length < 1) {
                alert("<spring:message code='asmnt.label.ezg.noselect.user' />");
                return false;
            }
        }

        /**
         * 연장제출
         */
        if ($("input[name='extdSbmsnPrmyn']:checked").val() === "Y") {
            if (asmtDateUtil.isEmptyDateTime("extdSbmsnDateEd", "extdSbmsnTimeEd")) {
                alert("<spring:message code='forum.label.extEndDttm' />");
                return false;
            }

            if (asmtDateUtil.isGreaterDateTime("asmtSbmsnDateEd", "asmtSbmsnTimeEd", "extdSbmsnDateEd", "extdSbmsnTimeEd")) {
                alert("<spring:message code='asmnt.alert.invalid.ext.send.dttm' />");
                return false;
            }
        }

        /**
         * 루브릭
         */
        if ($("input[name='evlScrTycd']:checked").val() === "RUBRIC_SCR" && !$("#asmtEvlId").val()) {
            alert("<spring:message code='asmnt.alert.empty.rubric' />");
            return false;
        }

        /**
         * 과제읽기 허용
         */
        if ($("input[name='sbasmtOstdOyn']:checked").val() === "Y") {
            if (asmtDateUtil.isEmptyDateTime("ostdOpenSdttmDateSt", "ostdOpenSdttmTimeSt")) {
                alert("<spring:message code='asmnt.label.read.start' />");
                return false;
            }
        }

        return true;
    }


    /**
     * =========================================================
     * 저장 확인
     * =========================================================
     */
    function saveConfirm() {
        if (!validation()) {
            return;
        }

        buildSubmitData();
        startUploadChain();
    }


    /**
     * =========================================================
     * 저장 데이터 조립
     * =========================================================
     */
    function buildSubmitData() {
        buildAsmtGbncd();
        buildIndvAsmtList();
        buildSbmsnFileMimeTycd();
        buildDateTimeFields();
        buildSubAsmtCtsArr();
        appendDvclasInfoParams();

        const dx = dx5.get("upload1");
        if (dx) {
            $("input[name='copyFiles']").val(dx.getCopyFiles());
            $("input[name='delFileIdStr']").val(dx.getDelFileIdStr());
            $("input[name='uploadPath']").val(dx.getUploadPath());
        }
    }

    /**
     * 과제구분코드 생성
     */
    function buildAsmtGbncd() {
        const fixedAsmtGbncd = "${asmtVO.asmtGbncd}";
        const isTeamAsmtStng = $("input[name='teamAsmtStngyn']:checked").val() === "Y";
        const isIndvAsmt = $("input[name='indvAsmtyn']:checked").val() === "Y";
        const isAsmtPrctc = $("input[name='asmtPrctcyn']:checked").val() === "Y";

        let asmtGbncd = "";

        if (["EXAM_SBST", "ABSNCE_SBST", "MID_EXAM_SBST_ASMT", "LST_EXAM_SBST_ASMT"].includes(fixedAsmtGbncd)) {
            asmtGbncd = fixedAsmtGbncd;
        } else if (isIndvAsmt) {
            asmtGbncd = "INDV_ASMT";
        } else if (isAsmtPrctc) {
            asmtGbncd = isTeamAsmtStng ? "PRCTC_ASMT_TEAM" : "PRCTC_ASMT";
            $("input[name='sbasmtTycd'][value='FILE']").prop("checked", true);
        } else {
            asmtGbncd = isTeamAsmtStng ? "ASMT_TEAM" : "ASMT";
        }

        $("input[name='asmtGbncd']").val(asmtGbncd);
    }

    /**
     * 개별과제 대상자 문자열 생성
     */
    function buildIndvAsmtList() {
        const indvAsmtList = [];

        $("#sindvAsmtList tr").each(function () {
            const userId = $(this).find("input[type='hidden']").val();
            if (userId) {
                indvAsmtList.push(userId);
            }
        });

        $("input[name='indvAsmtList']").val(indvAsmtList.join(","));
    }

    /**
     * 제출 파일 형식 문자열 생성
     */
    function buildSbmsnFileMimeTycd() {
        let sFileType = "";

        if ($("input[name='asmtPrctcyn']:checked").val() === "Y") {
            $("input[name='prtcFileType']:checked").each(function (i) {
                if (i > 0) {
                    sFileType += ",";
                }
                sFileType += $(this).val();
            });
        } else {
            const sbasmtTycd = $("input[name='sbasmtTycd']:checked").val();

            if (sbasmtTycd === "FILE") {
                const sbmsnFileMimeTycd = $("input[name='sbmsnFileMimeTycd']:checked").val();

                if (sbmsnFileMimeTycd === "all") {
                    sFileType = "all";
                } else if (sbmsnFileMimeTycd === "pre") {
                    $("input[name='preFile']:checked").each(function (i) {
                        if (i > 0) {
                            sFileType += ",";
                        }
                        sFileType += $(this).val();
                    });
                } else if (sbmsnFileMimeTycd === "doc") {
                    $("input[name='docFile']:checked").each(function (i) {
                        if (i > 0) {
                            sFileType += ",";
                        }
                        sFileType += $(this).val();
                    });
                }
            }
        }

        $("input[name='sbmsnFileMimeTycd']").val(sFileType);
    }

    /**
     * hidden 날짜 필드 생성
     */
    function buildDateTimeFields() {

        const asmtSbmsnSdttm = asmtDateUtil.getDateTimeVal("asmtSbmsnDateSt", "asmtSbmsnTimeSt");
        const asmtSbmsnEdttm = asmtDateUtil.getDateTimeVal("asmtSbmsnDateEd", "asmtSbmsnTimeEd");

        $("input[name='asmtSbmsnSdttm']").val(asmtSbmsnSdttm);
        $("input[name='asmtSbmsnEdttm']").val(asmtSbmsnEdttm);

        if ($("input[name='extdSbmsnPrmyn']:checked").val() === "Y") {
            $("input[name='extdSbmsnSdttm']").val(asmtSbmsnEdttm);
            $("input[name='extdSbmsnEdttm']").val(asmtDateUtil.getDateTimeVal("extdSbmsnDateEd", "extdSbmsnTimeEd"));
        } else {
            $("input[name='extdSbmsnSdttm']").val("");
            $("input[name='extdSbmsnEdttm']").val("");
        }

        if ($("input[name='sbasmtOstdOyn']:checked").val() === "Y") {
            $("input[name='sbasmtOstdOpenSdttm']").val(asmtDateUtil.getDateTimeVal("ostdOpenSdttmDateSt", "ostdOpenSdttmTimeSt"));
            $("input[name='sbasmtOstdOpenEdttm']").val("999912312359");
        } else {
            $("input[name='sbasmtOstdOpenSdttm']").val("");
            $("input[name='sbasmtOstdOpenEdttm']").val("");
        }

        /**
         * 현재 UI에 상호평가 입력 영역이 없으므로 초기화
         */
        $("input[name='evlSdttm']").val("");
        $("input[name='evlEdttm']").val("");
    }

    function appendDvclasInfoParams() {
        $("#asmtWriteForm input.__dvclasInfoParam").remove();

        let index = 0;

        $("input[name='dvclasList']").each(function () {
            if (this.value === "ALL") {
                return;
            }

            if (!this.checked) {
                return;
            }

            $("<input>", {
                type: "hidden",
                name: "dvclasInfoList[" + index + "].sbjctId",
                value: this.value,
                "class": "__dvclasInfoParam"
            }).appendTo("#asmtWriteForm");

            $("<input>", {
                type: "hidden",
                name: "dvclasInfoList[" + index + "].dvclasNo",
                value: $(this).data("dvclas-no"),
                "class": "__dvclasInfoParam"
            }).appendTo("#asmtWriteForm");

            index++;
        });
    }


    /**
     * =========================================================
     * 저장
     * =========================================================
     */
    function save() {

        const url = isEditMode
            ? "/asmt2/profAsmtModifyAjax.do"
            : "/asmt2/profAsmtRegistAjax.do";

        ajaxCall(url, $("#asmtWriteForm").serialize(), function (data) {
            if (data.result > 0) {
                if (isEditMode) {
                    alert("<spring:message code='common.modify.success' />");
                } else {
                    alert("<spring:message code='common.alert.ok.save' />");
                }
                moveAsmtList();
            } else {
                alert(data.message);
            }
        }, function () {
            alert("<spring:message code='seminar.error.delete' />");
        }, true);
    }


    /**
     * =========================================================
     * 목록 이동
     * =========================================================
     */
    function moveAsmtList() {
        const kvArr = [];
        kvArr.push({key: "sbjctId", val: SBJCT_ID});
        submitForm("/asmt2/profAsmtListView.do", "", kvArr);
    }

    /**
     * =========================================================
     * 메인 업로드 시작
     * =========================================================
     */
    function startUploadChain() {
        const dx = dx5.get("upload1");

        if (dx && dx.availUpload()) {
            dx.startUpload();
        } else {
            if (dx) {
                $("input[name='delFileIdStr']").val(dx.getDelFileIdStr());
                $("input[name='copyFiles']").val(dx.getCopyFiles());
                $("input[name='uploadPath']").val(dx.getUploadPath());
                $("input[name='uploadPath']").val(dx.getUploadPath());
            }
            continueSubAsmtUploadChain(0);
        }
    }

    /**
     * =========================================================
     * 메인 업로드 완료
     * =========================================================
     */
    function finishUpload() {

        const dx = dx5.get("upload1");
        const url = "/common/uploadFileCheck.do";
        const data = {
            uploadFiles: dx.getUploadFiles(),
            copyFiles: dx.getCopyFiles(),
            uploadPath: dx.getUploadPath()
        };

        ajaxCall(url, data, function (resp) {
            if (resp.result > 0) {
                $("input[name='uploadFiles']").val(dx.getUploadFiles());
                $("input[name='copyFiles']").val(dx.getCopyFiles());
                $("input[name='delFileIdStr']").val(dx.getDelFileIdStr());
                $("input[name='uploadPath']").val(dx.getUploadPath());

                continueSubAsmtUploadChain(0);
            } else {
                alert("<spring:message code='success.common.file.transfer.fail'/>");
            }
        }, function () {
            alert("<spring:message code='success.common.file.transfer.fail'/>");
        }, true);
    }

    /**
     * =========================================================
     * 팀별 부과제 업로드 순차 처리
     * =========================================================
     */
    function continueSubAsmtUploadChain(uploadIdx) {

        if (uploadIdx >= subAsmtUploaderIds.length) {
            appendSubAsmtDetailParams();
            save();
            return;
        }

        const uploaderId = subAsmtUploaderIds[uploadIdx];
        const dx = dx5.get(uploaderId);

        if (!dx) {
            subAsmtUploadResults[uploaderId] = {
                uploadFiles: "",
                uploadPath: "",
                delFileIdStr: "",
                copyFiles: ""
            };
            continueSubAsmtUploadChain(uploadIdx + 1);
            return;
        }

        if (dx.availUpload()) {
            dx.startUpload();
        } else {
            subAsmtUploadResults[uploaderId] = {
                uploadFiles: "",
                uploadPath: dx.getUploadPath(),
                delFileIdStr: dx.getDelFileIdStr ? dx.getDelFileIdStr() : "",
                copyFiles: dx.getCopyFiles ? dx.getCopyFiles() : ""
            };
            continueSubAsmtUploadChain(uploadIdx + 1);
        }
    }

    /**
     * =========================================================
     * 팀별 부과제 업로드 완료 콜백
     * =========================================================
     */
    function onSubAsmtUploadComplete(uploaderId) {

        const uploadIdx = subAsmtUploaderIds.indexOf(uploaderId);
        const dx = dx5.get(uploaderId);

        const url = "/common/uploadFileCheck.do";
        const data = {
            uploadFiles: dx.getUploadFiles(),
            copyFiles: dx.getCopyFiles ? dx.getCopyFiles() : "",
            uploadPath: dx.getUploadPath()
        };

        ajaxCall(url, data, function (resp) {
            if (resp.result > 0) {
                subAsmtUploadResults[uploaderId] = {
                    uploadFiles: dx.getUploadFiles(),
                    uploadPath: dx.getUploadPath(),
                    delFileIdStr: dx.getDelFileIdStr ? dx.getDelFileIdStr() : "",
                    copyFiles: dx.getCopyFiles ? dx.getCopyFiles() : ""
                };

                continueSubAsmtUploadChain(uploadIdx + 1);
            } else {
                alert("<spring:message code='success.common.file.transfer.fail'/>");
            }
        }, function () {
            alert("<spring:message code='success.common.file.transfer.fail'/>");
        }, true);
    }


    /**
     * 학습그룹 팝업
     * @param i - 분반 순서
     * @param sbjctId - 과목아이디
     */
    function lrnGrpSelectPop(i, sbjctId) {
        dialog = UiDialog("lrnGrpDialog", {
            title: "학습그룹지정",
            width: 600,
            height: 500,
            url: "/team/teamHome/teamCtgrSelectPop.do?sbjctId=" + sbjctId + "&searchFrom=" + i + ":" + sbjctId,
            autoresize: false
        });

    }

    /**
     * 학습그룹 선택
     * @param lrnGrpId 학습그룹아이디
     * @param lrnGrpnm 학습그룹명
     * @param id
     */
    function selectTeam(lrnGrpId, lrnGrpnm, id) {
        const idList = id.split(":");
        $("#lrnGrpId" + idList[0]).val(lrnGrpId + ":" + idList[1]);
        $("#lrnGrpnm" + idList[0]).val(lrnGrpnm);
    }


    /**
     * =========================================================
     * 개별과제 검색
     * =========================================================
     */
    function indiSearch(type) {
        if (type === "T") {
            $("#tg0").prop("checked", false);
            $("#indvAsmtList input:checkbox").prop("checked", false);
            $("#indvAsmtList tr").show();

            if ($("#tgSearch").val() !== "") {
                $("#indvAsmtList tr").not($("#indvAsmtList .tgList:contains('" + $("#tgSearch").val() + "')").parent()).hide();
            }
        } else if (type === "S") {
            $("#stg0").prop("checked", false);
            $("#sindvAsmtList input:checkbox").prop("checked", false);
            $("#sindvAsmtList tr").show();

            if ($("#stgSearch").val() !== "") {
                $("#sindvAsmtList tr").not($("#sindvAsmtList .tgList:contains('" + $("#stgSearch").val() + "')").parent()).hide();
            }
        }
    }


    /**
     * =========================================================
     * TODO: 루브릭 팝업
     * =========================================================
     */
    function mutEvalWritePop(type) {

        let asmtEvlId = "";

        if (type === "edit") {
            asmtEvlId = $("#asmtEvlId").val();

            if (!asmtEvlId) {
                alert("<spring:message code='forum.alert.evalCd.del' />");
                return false;
            }
        }

        const modalId = "Ap01";
        initModal(modalId);

        const kvArr = [];
        kvArr.push({key: "sbjctId", val: SBJCT_ID});
        kvArr.push({key: "asmtEvlId", val: asmtEvlId});

        submitForm("/mut/mutPop/mutEvalWritePop.do", modalId + "ModalIfm", kvArr);
    }

    function mutEvalWrite(asmtEvlId, evalTitle) {
        $("#asmtEvlId").val(asmtEvlId);
        $("#evalTitle").val(evalTitle);
    }

    function deleteMut() {

        const asmtEvlId = $("#asmtEvlId").val();

        if (!asmtEvlId) {
            alert("<spring:message code='forum.alert.evalCd.del' />");
            return false;
        }

        if (window.confirm("<spring:message code='seminar.confirm.delete' />")) {

            const url = "/mut/mutHome/edtDelYn.do";
            const data = {
                asmtEvlId: asmtEvlId,
                delYn: "Y"
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    $("#asmtEvlId").val("");
                    $("#evalTitle").val("");
                    alert("<spring:message code='success.common.delete'/>");
                    $("input[name='evlScrTycd'][value='SCR']").prop("checked", true);
                    applyCurrentView();
                } else {
                    alert(data.message);
                }
            }, function () {
                alert("<spring:message code='seminar.error.delete' />");
            }, true);
        }
    }

</script>
</body>
</html>