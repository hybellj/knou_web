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
        <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp"/>

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
                            <c:choose>
                                <c:when test="${mode eq 'E'}">
                                    <button type="button" class="btn type2" id="btnSave">저장</button>
                                </c:when>
                                <c:otherwise>
                                    <button type="button" class="btn type2" id="btnSave">저장</button>
                                    <button type="button" class="btn type2" id="btnCopy">이전과제가저오기</button>
                                </c:otherwise>
                            </c:choose>
                            <button type="button" class="btn type2" id="btnGoList">목록</button>
                        </div>
                    </div>


                    <form id="asmntWriteForm" name="asmntWriteForm" method="post" action=""
                          onsubmit="saveConfirm(); return false;">
                        <input type="hidden" name="asmtId">
                        <input type="hidden" name="newAsmtId" value="${vo.newAsmtId}">
                        <input type="hidden" name="prevAsmtId">
                        <input type="hidden" name="asmtGbncd">
                        <input type="hidden" name="indvAsmtList">
                        <input type="hidden" name="sbjctId" value="${vo.sbjctId}">
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


                        <div class="table_list">
                            <ul class="list">
                                <li class="head"><label class="req">과제명</label></li>
                                <li>
                                    <label for="asmtTtl"></label>
                                    <input type="text" id="asmtTtl" name="asmtTtl">
                                </li>
                            </ul>
                            <%--과제내용--%>
                            <ul class="list">
                                <li class="head">
                                    <label for="contentTextArea" class="req">
                                        <spring:message code="asmnt.label.asmnt.content"/>
                                    </label>
                                </li>
                                <li>
                                    <div>
                                        <div class="editor-box">
                                            <%-- HTML 에디터 --%>
                                            <uiex:htmlEditor
                                                    id="asmtCts"
                                                    name="asmtCts"
                                                    uploadPath="${asmtVO.uploadPath}"
                                                    value="${asmtVO.asmtCts}"
                                                    height="300px"
                                            />
                                        </div>
                                    </div>
                                </li>
                            </ul>
                            <%--분반 일괄 등록--%>
                            <ul class="list" id="declsView">
                                <li class="head">
                                    <label>
                                        <spring:message code="asmnt.label.grp.crs.all"/>
                                    </label>
                                </li>
                                <li>
                                    <div class="fields" id="creCrsListView"></div>
                                </li>
                            </ul>
                            <%-- 제출기간 --%>
                            <ul class="list">
                                <li class="head">
                                    <label for="dateLabel" class="req">
                                        <spring:message code="asmnt.label.send.date"/>
                                    </label>
                                </li>
                                <li>
                                    <div class="date_area">
                                        <label for="dateSt"></label>
                                        <input id="dateSt" type="text" name="dateSt" class="datepicker" timeId="timeSt" toDate="dateEd" value="${fn:substring(asmtVO.asmtSbmsnSdttm,0,8)}" required="true">
                                        <label for="timeSt"></label>
                                        <input id="timeSt" type="text" name="timeSt" class="timepicker" dateId="dateSt" value="${fn:substring(asmtVO.asmtSbmsnSdttm,8,12)}" required="true">
                                        <span class="txt-sort">~</span>
                                        <label for="dateEd"></label>
                                        <input id="dateEd" type="text" name="dateEd" class="datepicker" timeId="timeEd" fromDate="dateSt" value="${fn:substring(asmtVO.asmtSbmsnEdttm,0,8)}" required="true">
                                        <label for="timeEd"></label>
                                        <input id="timeEd" type="text" name="timeEd" class="timepicker" dateId="dateEd" value="${fn:substring(asmtVO.asmtSbmsnEdttm,8,12)}" required="true">
                                    </div>
                                </li>
                            </ul>
                            <%-- 성적반영 --%>
                            <ul class="list">
                                <li class="head">
                                    <label class="req">
                                        <spring:message code="resh.label.score.aply"/>
                                    </label>
                                </li>
                                <li>
                                    <span class="custom-input">
                                        <input type="radio" name="mrkRfltyn" id="mrkRfltY" value="Y" ${asmtVO.mrkRfltyn eq 'Y' || empty asmtVO.asmtId ? 'checked' : '' }>
                                        <label for="mrkRfltY">예</label>
                                    </span>
                                    <span class="custom-input">
                                        <input type="radio" name="mrkRfltyn" id="mrkRfltN" value="N" ${asmtVO.mrkRfltyn eq 'N' ? 'checked' : '' }>
                                        <label for="mrkRfltN">아니오</label>
                                    </span>
                                </li>
                            </ul>
                            <%-- 성적공개 --%>
                            <ul class="list">
                                <li class="head">
                                    <label><spring:message code="resh.label.score.open"/></label>
                                </li>
                                <li>
                                    <span class="custom-input">
                                        <input type="radio" name="mrkOyn" id="mrkOynY" value="Y" ${asmtVO.mrkOyn eq 'Y' || empty asmtVO.asmtId ? 'checked' : '' }>
                                        <label for="mrkOynY">예</label>
                                    </span>
                                    <span class="custom-input">
                                        <input type="radio" name="mrkOyn" id="mrkOynN" value="N" ${asmtVO.mrkOyn eq 'N' ? 'checked' : '' }>
                                        <label for="mrkOynN">아니오</label>
                                    </span>
                                </li>
                            </ul>

                            <%-- 연장 제출--%>
                            <ul class="list">
                                <li class="head">
                                    <label>
                                        연장제출
                                    </label>
                                </li>
                                <li>
                                    <span class="custom-input">
                                        <input type="radio" name="extdSbmsnPrmyn" id="extdSbmsnPrmY" value="Y" ${asmtVO.extdSbmsnPrmyn eq 'Y' || empty asmtVO.asmtId ? 'checked' : '' }>
                                        <label for="extdSbmsnPrmY">예</label>
                                    </span>
                                    <span class="custom-input">
                                        <input type="radio" name="extdSbmsnPrmyn" id="extdSbmsnPrmN" value="N" ${asmtVO.extdSbmsnPrmyn eq 'N' ? 'checked' : '' }>
                                        <label for="extdSbmsnPrmN">아니오</label>
                                    </span>
                                    <%-- 제출 마감일 --%>
                                    <div class="list" id="viewExtdSbmsnPrm">
                                        <div class="date_area">
                                            <label for="extdSbmsnDateEd"></label>
                                            <input id="extdSbmsnDateEd" type="text" name="extdSbmsnDateEd" class="datepicker" timeId="extdSbmsnTimeEd" value="${fn:substring(asmtVO.extdSbmsnEdttm,0,8)}" required="true">
                                            <label for="extdSbmsnTimeEd"></label>
                                            <input id="extdSbmsnTimeEd" type="text" name="extdSbmsnTimeEd" class="timepicker" dateId="extdSbmsnDateEd" value="${fn:substring(asmtVO.extdSbmsnEdttm,8,12)}" required="true">
                                        </div>

                                        <div class="ui small warning message">
                                            <i class="info icon"></i>
                                            <spring:message code="asmnt.label.ext.send.info"/>
                                        </div>
                                    </div>
                                </li>
                            </ul>


                            <%-- 평가방법 --%>
                            <ul class="list">
                                <li class="head">
                                    <label class="req">
                                        <spring:message code="crs.label.eval_method"/>
                                    </label>
                                </li>
                                <li>
                                    <span class="custom-input">
                                        <input type="radio" name="evlScrTycd" id="evlScrTycdS" value="SCR" ${asmtVO.evlScrTycd eq 'SCR' || empty asmtVO.evlScrTycd ? 'checked' : '' }>
                                        <label for="evlScrTycdS">점수형</label>
                                    </span>
                                    <span class="custom-input">
                                        <input type="radio" name="evlScrTycd" id="evlScrTycdR" value="RUBRIC_SCR" ${asmtVO.evlScrTycd eq 'RUBRIC_SCR' ? 'checked' : '' }>
                                        <label for="evlScrTycdR">루브릭</label>
                                    </span>

                                    <div class="field" id="mutEvalDiv">
                                        <div class="ui action input search-box mr5">
                                            <input type="hidden" name="asmtEvlId" id="asmtEvlId"/>
                                            <input type="text" name="evalTitle" id="evalTitle">
                                            <button type="button" class="ui icon button" onclick="mutEvalWritePop('new');">
                                                <i class="pencil alternate icon"></i>
                                            </button>
                                            <button type="button" class="ui icon button" onclick="mutEvalWritePop('edit');">
                                                <i class="edit icon"></i>
                                            </button>
                                            <button type="button" class="ui icon button" onclick="deleteMut();">
                                                <i class="trash icon"></i>
                                            </button>
                                        </div>
                                    </div>

                                    <div class="ui small warning message">
                                        <i class="info icon"></i>
                                        <spring:message code="forum.label.evalctgr.rubric.info"/>
                                    </div>
                                </li>
                            </ul>

                            <ul class="list" id="viewSbasmtTycd">
                                <li class="head">
                                    <label class="req">
                                        <spring:message code="asmnt.label.asmnt.send.type" /><!-- 제출형식 -->
                                    </label>
                                </li>
                                <li>

                                    <span class="custom-input">
                                        <input type="radio" name="sbasmtTycd" id="sbasmtTycdF" value="FILE" checked>
                                        <label for="sbasmtTycdF"><spring:message code="asmnt.label.file" /><!-- 파일 --></label>
                                    </span>
                                    <span class="custom-input">
                                        <input type="radio" name="sbasmtTycd" id="sbasmtTycdT" value="INPUT_TEXT">
                                        <label for="sbasmtTycdT"><spring:message code="lesson.label.text"/>(TEXT)</label>
                                    </span>
                                    <div id="viewSbasmtTycdFile">
                                        <span class="custom-input">
                                            <input type="radio" name="sbmsnFileMimeTycd" id="allFile" value="all" checked>
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
                                </li>
                            </ul>

                            <ul class="list">
                                <li class="head">
                                    <label for="contentTextArea">
                                        <spring:message code="asmnt.label.file.upload"/>
                                    </label>
                                </li>
                                <li>
                                    <uiex:dextuploader
                                            id="upload1"
                                            path="${uploadPath}"
                                            limitCount="5"
                                            limitSize="1024"
                                            oneLimitSize="1024"
                                            listSize="3"
                                            fileList="${asmtVo.fileList}"
                                            finishFunc="finishUpload()"
                                            allowedTypes="*"
                                            bigSize="false"
                                    />
                                </li>
                            </ul>

                            <ul class="list">
                                <li class="head">
                                    <label class="req">
                                        <spring:message code="asmnt.label.practice.asmnt" /><!-- 실기과제 -->
                                    </label>
                                </li>
                                <li>
                                    <span class="custom-input">
                                        <input type="radio" name="asmtPrctcyn" id="asmtPrctcY" value="Y">
                                        <label for="asmtPrctcY">
                                            <spring:message code="asmnt.common.yes"/>
                                        </label>
                                    </span>
                                    <span class="custom-input">
                                        <input type="radio" name="asmtPrctcyn" id="asmtPrctcN" value="N" checked>
                                        <label for="asmtPrctcN">
                                            <spring:message code="asmnt.common.no"/>
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
                                                <input type="radio" name="exlnAsmtDwldyn" id="exlnAsmtDwldN" value="N" checked>
                                                <label for="exlnAsmtDwldN">
                                                    <spring:message code="asmnt.common.no"/>
                                                </label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="exlnAsmtDwldyn" id="exlnAsmtDwldY" value="Y">
                                                <label for="exlnAsmtDwldY">
                                                    <spring:message code="asmnt.common.yes"/>
                                                </label>
                                            </span>
                                        </div>
                                    </div>
                                </li>
                            </ul>

                            <ul class="list">
                                <li class="head">
                                    <label for="teamLabel">
                                        <spring:message code="asmnt.label.team.asmnt" /><!-- 팀과제 -->
                                    </label>
                                </li>
                                <li>

                                    <span class="custom-input">
                                        <input type="radio" name="teamAsmtStngyn" id="teamN" value="N" checked>
                                        <label for="teamN">
                                            <spring:message code="asmnt.common.no"/>
                                        </label>
                                    </span>
                                    <span class="custom-input">
                                        <input type="radio" name="teamAsmtStngyn" id="teamY" value="Y">
                                        <label for="teamY">
                                            <spring:message code="asmnt.common.yes"/>
                                        </label>
                                    </span>

                                    <div class="list" id="viewTeamAsmnt"></div>
                                </li>
                            </ul>

                            <ul class="list">
                                <li class="head">
                                    <label for="indLabel">
                                        <spring:message code="asmnt.label.individual.asmnt"/><!-- 개별과제 -->
                                    </label>
                                </li>
                                <li>
                                    <span class="custom-input">
                                        <input type="radio" name="indvAsmtyn" id="indN" value="N" checked>
                                        <label for="indN">
                                            <spring:message code="message.no"/>
                                        </label>
                                    </span>
                                    <span class="custom-input">
                                        <input type="radio" name="indvAsmtyn" id="indY" value="Y">
                                        <label for="indY">
                                            <spring:message code="message.yes"/>
                                        </label>
                                    </span>

                                    <div class="ui small warning message">
                                        <i class="info circle icon"></i>
                                        <spring:message code="asmnt.label.indi.info"/>
                                    </div>

                                    <div class="list" id="viewIndAsmnt">

                                        <div class="swapLists">
                                            <div class="swapListsItem">
                                                <div class="option-content mb10">
                                                    <label for="b1" class="mra"><spring:message code="button.list.student"/></label>
                                                    <!-- 수강생 목록 -->
                                                    <div class="ui action input search-box">
                                                        <input type="text" id="tgSearch"
                                                               placeholder="<spring:message code='team.popup.search.placeholder'/>">
                                                        <!-- 학과, 학번, 이름 입력 -->
                                                        <button type="button"
                                                                class="ui icon button"
                                                                onclick="indiSearch('T')"><i
                                                                class="search icon"></i>
                                                        </button>
                                                    </div>
                                                </div>

                                                <table class="tbl_fix type2">
                                                    <thead>
                                                    <tr>
                                                        <th class="wf5">
                                                            <div class="ui checkbox">
                                                                <input type="checkbox" id="tg0"
                                                                       tabindex="0"
                                                                       class="hidden">
                                                                <label class="toggle_btn"
                                                                       for="tg0"></label>
                                                            </div>
                                                        </th>
                                                        <!-- NO. -->
                                                        <th class="wf15"><spring:message code="common.number.no"/></th>
                                                        <th><spring:message code="asmnt.label.dept.nm"/></th>
                                                        <!-- 학과 -->
                                                        <c:if test="${creCrsVO.univGbn eq '3' or creCrsVO.univGbn eq '4'}">
                                                            <th><spring:message code="common.label.grsc.degr.cors.gbn2"/></th>
                                                            <!-- 학위구분 -->
                                                        </c:if>
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
                                            </div>
                                            <div class="swapListsItem">
                                                <div class="option-content mb10">
                                                    <label for="b1" class="mra"><spring:message
                                                            code="asmnt.label.ind.asmnt.user"/></label>
                                                    <!-- 개별과제 대상자 -->
                                                    <div class="ui action input search-box">
                                                        <input type="text" id="stgSearch"
                                                               placeholder="<spring:message code='team.popup.search.placeholder'/>">
                                                        <!-- 학과, 학번, 이름 입력 -->
                                                        <button type="button"
                                                                class="ui icon button"
                                                                onclick="indiSearch('S')"><i
                                                                class="search icon"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                                <table class="tbl_fix type2">
                                                    <thead>
                                                    <tr>
                                                        <th class="wf5">
                                                            <div class="ui checkbox">
                                                                <input type="checkbox" id="stg0"
                                                                       tabindex="0"
                                                                       class="hidden">
                                                                <label class="toggle_btn"
                                                                       for="stg0"></label>
                                                            </div>
                                                        </th>
                                                        <!-- NO. -->
                                                        <th class="wf15"><spring:message code="common.number.no"/></th>
                                                        <th><spring:message code="asmnt.label.dept.nm"/></th>
                                                        <!-- 학과 -->
                                                        <c:if test="${creCrsVO.univGbn eq '3' or creCrsVO.univGbn eq '4'}">
                                                            <th><spring:message code="common.label.grsc.degr.cors.gbn2"/></th>
                                                            <!-- 학위구분 -->
                                                        </c:if>
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
                                </li>
                            </ul>


                            <div class="page-info">
                                <h2 class="page-title">옵션</h2>
                            </div>
                            <div class="ui styled fluid accordion week_lect_list">
                                <i class="dropdown icon ml20"></i>

                                <ul class="list">
                                    <li class="head">
                                        <label class="req">
                                            <spring:message code="asmnt.label.read.allow"/><!-- 과제읽기 허용 -->
                                        </label>
                                    </li>
                                    <li>
                                        <span class="custom-input">
                                            <input type="radio" name="sbasmtOstdOyn" id="sbasmtOstdN" value="N" checked>
                                            <label for="sbasmtOstdN"><spring:message code="asmnt.common.no"/></label>
                                        </span>
                                        <span class="custom-input">
                                            <input type="radio" name="sbasmtOstdOyn" id="sbasmtOstdY" value="Y">
                                            <label for="sbasmtOstdY"><spring:message code="asmnt.common.yes"/></label>
                                        </span>
                                        <div class="list" id="viewSbasmtOstd">
                                            <%-- 과제 읽기 허용기간 --%>
                                            <div class="date_area">
                                                <label for="ostdOpenSdttmDateSt"></label>
                                                <input id="ostdOpenSdttmDateSt" type="text" name="ostdOpenSdttmDateSt" class="datepicker" timeId="ostdOpenSdttmTimeSt" value="${fn:substring(asmtVO.sbasmtOstdOpenSdttm,0,8)}" required="true">
                                                <label for="ostdOpenSdttmTimeSt"></label>
                                                <input id="ostdOpenSdttmTimeSt" type="text" name="ostdOpenSdttmTimeSt" class="timepicker" dateId="ostdOpenSdttmDateSt" value="${fn:substring(asmtVO.sbasmtOstdOpenSdttm,8,12)}" required="true">
                                            </div>
                                        </div>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>
</div>

<script type="text/javascript">

    let eBoolean = false;   // 수정 여부
    let gInd = false;       // 개별과제 대상자 목록 조회 여부

    $(document).ready(function () {

        /**
         * 수정 여부 설정
         */
        eBoolean = "${mode}" === "E" || "${vo.asmtId}" !== "";

        /**
         * 초기 화면 제어
         */
        initView();

        /**
         * 이벤트 바인딩
         */
        bindEvents();

        /**
         * 초기 상태 반영
         */
        applyCurrentView();

        /**
         * 분반 목록 조회
         */
        getCreCrsList();

        /**
         * 수정 모드면 상세 조회
         */
        if ("${vo.asmtId}" !== "") {
            getAsmnt("${vo.asmtId}");
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
        $("#viewTeamAsmnt").hide();
        $("#viewIndAsmnt").hide();
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
        $("#btnSave").on("click", function () {
            saveConfirm();
        });

        $("#btnCopy").on("click", function () {
            asmntCopyList();
        });

        $("#btnGoList").on("click", function () {
            viewAsmntList();
        });

        /**
         * 라디오/체크박스 공통 상태 반영
         */
        $(document).on("change", "input[type='radio'], input[type='checkbox']", function () {
            applyCurrentView();
        });

        /**
         * 제출 종료일, 연장 종료일 변경 시 과제읽기 허용일 동기화
         */
        $("#dateEd, #timeEd, #extdSbmsnDateEd, #extdSbmsnTimeEd").on("change", function () {
            syncSbasmtOpenDate();
        });

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
            $("input[name='indvAsmtyn'][value='N']").prop("checked", true);
            $("#viewTeamAsmnt").show();
            $("#viewIndAsmnt").hide();
        } else if (indvAsmtyn === "Y") {
            $("input[name='teamAsmtStngyn'][value='N']").prop("checked", true);
            $("#viewTeamAsmnt").hide();
            $("#viewIndAsmnt").show();

            /**
             * 개별과제는 성적반영 불가
             */
            if (mrkRfltyn === "Y") {
                alert("<spring:message code='asmnt.alert.ind.score.aply' />");
                $("input[name='mrkRfltyn'][value='N']").prop("checked", true);
            }

            /**
             * 개별과제 대상자 목록 최초 1회 조회
             */
            if (!gInd) {
                getAsmntJoinUser();
            }
        } else {
            $("#viewTeamAsmnt").hide();
            $("#viewIndAsmnt").hide();
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
     * 날짜 문자열 유틸
     * =========================================================
     */

    /**
     * datepicker + timepicker 값을 YYYYMMDDHHmm 형식으로 반환
     */
    function getDateTimeValue(dateId, timeId) {
        const dateVal = ($("#" + dateId).val() || "").trim().replace(/[-.]/g, "");
        const timeVal = ($("#" + timeId).val() || "").trim().replace(/:/g, "");

        return dateVal + timeVal;
    }

    /**
     * 서버 값(YYYYMMDDHHmm / YYYY-MM-DD HH:mm 등)을 datepicker/timepicker에 세팅
     */
    function setDateTimeValue(dateId, timeId, value) {
        const digits = (value || "").replace(/[^0-9]/g, "");

        if (digits.length < 8) {
            $("#" + dateId).val("");
            $("#" + timeId).val("");
            return;
        }

        const ymd = digits.substring(0, 8);
        const hm = digits.length >= 12 ? digits.substring(8, 12) : "0000";

        $("#" + dateId).val(ymd.substring(0, 4) + "-" + ymd.substring(4, 6) + "-" + ymd.substring(6, 8));
        $("#" + timeId).val(hm.substring(0, 2) + ":" + hm.substring(2, 4));
    }

    /**
     * 값이 있는지 확인
     */
    function isEmptyDateTime(dateId, timeId) {
        return !getDateTimeValue(dateId, timeId);
    }

    /**
     * 날짜 비교
     * - start > end 이면 true
     */
    function isGreaterDateTime(startDateId, startTimeId, endDateId, endTimeId) {
        return getDateTimeValue(startDateId, startTimeId) > getDateTimeValue(endDateId, endTimeId);
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
            $("#ostdOpenSdttmDateSt").val($("#extdSbmsnDateEd").val());
            $("#ostdOpenSdttmTimeSt").val($("#extdSbmsnTimeEd").val());
        } else {
            $("#ostdOpenSdttmDateSt").val($("#dateEd").val());
            $("#ostdOpenSdttmTimeSt").val($("#timeEd").val());
        }
    }


    /**
     * =========================================================
     * 분반 정보 조회
     * =========================================================
     */
    function getCreCrsList() {

        const data = {
            sbjctId: "${vo.sbjctId}",
            userId: "${vo.userId}"
        };

        ajaxCall("/asmt/profDvclasList.do", data, function (data) {

            let html = "";
            let html2 = "";

            if (data.returnList.length > 0) {

                html += "<div class='field'>";
                html += "    <div class='ui checkbox'>";
                html += "        <input type='checkbox' id='declsAll' name='dvclasList' value='ALL'";

                if (data.returnList.length === 1) {
                    html += " onclick=\"return false;\" checked";
                }

                html += ">";
                html += "        <label class='toggle_btn' for='declsAll'><spring:message code='user.common.search.all' /></label>";
                html += "    </div>";
                html += "</div>";

                $.each(data.returnList, function (i, o) {

                    html += "<div class='field'>";
                    html += "    <div class='ui checkbox'>";
                    html += "        <input type='checkbox' id='dvclas" + i + "' name='dvclasList' value='" + o.sbjctId + "'";

                    if ("${vo.sbjctId}" === o.sbjctId) {
                        html += " onclick=\"return false;\" checked";
                    }

                    html += ">";
                    html += "        <label class='toggle_btn' for='dvclas" + i + "'>" + o.dvclasNo + "<spring:message code='asmnt.label.decls.name' /></label>";
                    html += "    </div>";
                    html += "</div>";

                    html2 += "<div class='ui action fluid input' id='lrnGrpView" + i + "'";

                    if ("${vo.sbjctId}" !== o.sbjctId) {
                        html2 += " style='display:none;'";
                    }

                    html2 += ">";
                    html2 += "    <label class='ui basic small label flex-item-center m-w3 m0'>" + o.dvclasNo + "<spring:message code='asmnt.label.decls.name' /> : </label>";
                    html2 += "    <input type='hidden' id='lrnGrpId" + i + "' name='lrnGrpList'";

                    if ("${vo.sbjctId}" !== o.sbjctId) {
                        html2 += " disabled='disabled'";
                    }

                    html2 += ">";
                    html2 += "    <input type='text' id='teamCtgr" + i + "' placeholder='<spring:message code="asmnt.alert.select.team.ctgr" />' readonly>";
                    html2 += "    <a class='ui black button' onclick=\"teamCtgrSelectPop('" + i + "','" + o.sbjctId + "')\"><spring:message code='bbs.label.form_assign_team' /></a>";
                    html2 += "</div>";
                });

                html2 += "<div class='ui small warning message'><i class='info icon'></i><spring:message code='team.alert.select.team_manage_tab' /></div>";
            }

            $("#creCrsListView").html(html);
            $("#viewTeamAsmnt").html(html2);

            if (data.returnList.length !== 1) {
                $("input[name='dvclasList']").on("click", function (e) {

                    if (e.target.value === "ALL") {
                        $("input[name='dvclasList']").each(function () {
                            if (this.value !== "${vo.sbjctId}") {
                                this.checked = $("#declsAll").is(":checked");
                            }
                        });
                    } else {
                        let cnt = 0;

                        $("input[name='dvclasList']").each(function () {
                            if (this.value !== "ALL" && this.checked) {
                                cnt++;
                            }
                        });

                        $("#declsAll").prop("checked", cnt === $("input[name='dvclasList']").length - 1);
                    }
                });
            }

            $("input[name='dvclasList']").on("change", function () {
                $("input[name='dvclasList']").each(function (i) {
                    if (this.value !== "ALL") {
                        if (this.checked) {
                            $("#lrnGrpView" + (i - 1)).show();
                            $("#lrnGrpId" + (i - 1)).removeAttr("disabled");
                        } else {
                            $("#lrnGrpView" + (i - 1)).hide();
                            $("#lrnGrpId" + (i - 1)).attr("disabled", "disabled").val("");
                            $("#teamCtgr" + (i - 1)).val("");
                        }
                    }
                });
            });
        }, function () {
        }, true);
    }


    /**
     * =========================================================
     * 개별과제 대상자 목록 조회
     * =========================================================
     */
    function getAsmntJoinUser(asmtId) {

        const univGbn = "${creCrsVO.univGbn}";
        const url = "/asmt/profAsmtTrgtrSelect.do";
        const data = {
            selectType: "LIST",
            sbjctId: "${vo.sbjctId}"
        };

        ajaxCall(url, data, function (data) {

            if (data.result > 0) {

                let html = "";

                data.returnList.forEach(function (o, i) {
                    html += "<tr>";
                    html += "    <td class='wf5'>";
                    html += "        <div class='ui checkbox'>";
                    html += "            <input type='hidden' value='" + o.userId + "'>";
                    html += "            <input type='checkbox' id='tg" + (i + 1) + "' tabindex='0' class='hidden'>";
                    html += "            <label class='toggle_btn' for='tg" + (i + 1) + "'></label>";
                    html += "        </div>";
                    html += "    </td>";
                    html += "    <td class='wf15'>" + (i + 1) + "</td>";
                    html += "    <td class='tgList'>" + o.deptNm + "</td>";

                    if (univGbn === "3" || univGbn === "4") {
                        html += "<td class='tgList'>" + (o.grscDegrCorsGbnNm || "-") + "</td>";
                    }

                    html += "    <td class='tgList'>" + o.userId + "</td>";
                    html += "    <td class='tgList'>" + o.userNm + "</td>";
                    html += "</tr>";
                });

                $("#indvAsmtList").empty().append(html);
                gInd = true;

                if (asmtId) {
                    listAsmntUser(asmtId);
                }
            } else {
                alert(data.message);
            }
        }, function () {
            alert("<spring:message code='fail.common.msg' />");
        }, true);
    }


    /**
     * =========================================================
     * 개별과제 할당 목록 조회
     * =========================================================
     */
    function listAsmntUser(asmtId) {

        const univGbn = "${creCrsVO.univGbn}";
        const url = "/asmt/profAsmtSbmsnPtcpntSelect.do";
        const data = {
            selectType: "LIST",
            crsCreCd: "${vo.sbjctId}",
            asmtId: asmtId
        };

        ajaxCall(url, data, function (data) {

            if (data.result > 0) {

                let html = "";

                data.returnList.forEach(function (o, i) {
                    html += "<tr>";
                    html += "    <td class='wf5'>";
                    html += "        <div class='ui checkbox'>";
                    html += "            <input type='hidden' value='" + o.userId + "'>";
                    html += "            <input type='checkbox' id='tgr" + (i + 1) + "' tabindex='0' class='hidden'>";
                    html += "            <label class='toggle_btn' for='tgr" + (i + 1) + "'></label>";
                    html += "        </div>";
                    html += "    </td>";
                    html += "    <td class='wf15'>" + (i + 1) + "</td>";
                    html += "    <td class='tgList'>" + o.deptNm + "</td>";

                    if (univGbn === "3" || univGbn === "4") {
                        html += "<td class='tgList'>" + (o.grscDegrCorsGbnNm || "-") + "</td>";
                    }

                    html += "    <td class='tgList'>" + o.userId + "</td>";
                    html += "    <td class='tgList'>" + o.userNm + "</td>";
                    html += "</tr>";

                    $("#indvAsmtList input[value='" + o.userId + "']").closest("tr").remove();
                });

                $("#indvAsmtList tr").each(function (i) {
                    $("#indvAsmtList tr:eq(" + i + ") td:eq(1)").text(i + 1);
                });

                $("#sindvAsmtList").empty().append(html);
            } else {
                alert(data.message);
            }
        }, function () {
            alert("<spring:message code='fail.common.msg' />");
        }, true);
    }


    /**
     * =========================================================
     * 이전 과제 가져오기 팝업
     * =========================================================
     */
    function asmntCopyList() {
        const modalId = "Ap02";
        initModal(modalId);

        const kvArr = [];
        kvArr.push({key: "userId", val: "${vo.userId}"});
        kvArr.push({key: "crsCreCd", val: "${crsCreCd}"});

        submitForm("/asmt/profAsmtCopyPopView.do", modalId + "ModalIfm", kvArr);
    }


    /**
     * =========================================================
     * 이전 과제 복사
     * =========================================================
     */
    function copyAsmnt(asmtId) {
        eBoolean = false;
        getAsmnt(asmtId);
    }


    /**
     * =========================================================
     * 과제 조회
     * =========================================================
     */
    function getAsmnt(asmtId) {

        const url = "/asmt/profAsmtCopy.do";
        const data = {
            selectType: "OBJECT",
            asmtId: asmtId
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                const vo = data.returnVO;
                setData(vo);
                $(".modal").modal("hide");
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
    function setData(vo) {

        /**
         * 에디터
         */
        editor.execCommand("selectAll");
        editor.execCommand("deleteLeft");
        editor.execCommand("insertText", "");
        editor.openHTML($.trim(vo.asmtCts || ""));

        /**
         * 기본값
         */
        $("#asmtTtl").val(vo.asmtTtl || "");

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
        if (eBoolean) {
            $("input[name='asmtId']").val(vo.asmtId || "");
            $("input[name='prevAsmtId']").val("");
            $("#declsView").hide();

            setDateTimeValue("dateSt", "timeSt", vo.asmtSbmsnSdttm);
            setDateTimeValue("dateEd", "timeEd", vo.asmtSbmsnEdttm);

            $("input[name='extdSbmsnPrmyn'][value='" + (vo.extdSbmsnPrmyn || "N") + "']").prop("checked", true);
            setDateTimeValue("extdSbmsnDateEd", "extdSbmsnTimeEd", vo.extdSbmsnEdttm);

            $("input[name='teamAsmtStngyn']").prop("disabled", true);
            $("input[name='indvAsmtyn']").prop("disabled", true);
        } else {
            /**
             * 복사/등록 모드
             * - 날짜/연장제출/과제읽기허용은 초기화
             */
            $("input[name='asmtId']").val("");
            $("input[name='prevAsmtId']").val(vo.asmtId || "");
            $("#declsView").show();

            $("#dateSt, #timeSt, #dateEd, #timeEd").val("");
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
        if (vo.indvAsmtyn === "Y") {
            $("input[name='mrkRfltyn'][value='N']").prop("checked", true);
        } else {
            $("input[name='mrkRfltyn'][value='" + (vo.mrkRfltyn || "Y") + "']").prop("checked", true);
        }
        $("input[name='mrkOyn'][value='" + (vo.mrkOyn || "N") + "']").prop("checked", true);

        /**
         * 평가방법
         */
        $("input[name='evlScrTycd'][value='" + (vo.evlScrTycd || "SCR") + "']").prop("checked", true);

        if (vo.evlScrTycd === "RUBRIC_SCR") {
            $("#asmtEvlId").val(vo.asmtEvlId || "");
            $("#evalTitle").val(vo.evalTitle || "");
        }

        /**
         * 제출형식 / 실기과제
         */
        $("input[name='asmtPrctcyn'][value='" + (vo.asmtPrctcyn || "N") + "']").prop("checked", true);
        $("input[name='sbasmtTycd'][value='" + (vo.sbasmtTycd || "FILE") + "']").prop("checked", true);

        if (vo.asmtPrctcyn === "Y") {
            const prtcFileArr = (vo.sbmsnFileMimeTycd || "").split(",");

            prtcFileArr.forEach(function (fileTy) {
                $("input[name='prtcFileType'][value='" + $.trim(fileTy) + "']").prop("checked", true);
            });

            $("input[name='exlnAsmtDwldyn'][value='" + (vo.exlnAsmtDwldyn || "N") + "']").prop("checked", true);
        } else {
            const fileArr = (vo.sbmsnFileMimeTycd || "").split(",");

            if (!vo.sbmsnFileMimeTycd) {
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
        $("input[name='teamAsmtStngyn'][value='" + (vo.teamAsmtStngyn || "N") + "']").prop("checked", true);
        $("input[name='indvAsmtyn'][value='" + (vo.indvAsmtyn || "N") + "']").prop("checked", true);

        if (eBoolean && vo.teamAsmtStngyn === "Y") {
            $("#lrnGrpId0").val((vo.lrnGrpId || "") + ":" + (vo.sbjctId || ""));
            $("#teamCtgr0").val(vo.lrnGrpnm || "");
        }

        if (eBoolean && vo.indvAsmtyn === "Y") {
            if (!gInd) {
                getAsmntJoinUser(vo.asmtId);
            } else {
                listAsmntUser(vo.asmtId);
            }
        }

        /**
         * 과제읽기 허용
         */
        if (eBoolean) {
            $("input[name='sbasmtOstdOyn'][value='" + (vo.sbasmtOstdOyn || "N") + "']").prop("checked", true);
            setDateTimeValue("ostdOpenSdttmDateSt", "ostdOpenSdttmTimeSt", vo.sbasmtOstdOpenSdttm);
        } else {
            $("input[name='sbasmtOstdOyn'][value='N']").prop("checked", true);
        }

        /**
         * 첨부파일
         */
        const dx = dx5.get("upload1");

        if (dx != null) {
            dx.clearItems();

            if (vo.fileList && vo.fileList.length > 0) {
                const oldFiles = [];

                vo.fileList.forEach(function (file) {
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
        if (isEmptyDateTime("dateSt", "timeSt") || isEmptyDateTime("dateEd", "timeEd")) {
            alert("<spring:message code='asmnt.label.send.date' />");
            return false;
        }

        if (isGreaterDateTime("dateSt", "timeSt", "dateEd", "timeEd")) {
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
            let checkTeamCtgr = true;

            $("input[name='dvclasList']").each(function (i) {
                if (this.value !== "ALL") {
                    if (this.checked && !$("#lrnGrpId" + (i - 1)).val()) {
                        checkTeamCtgr = false;
                        return false;
                    }
                }
            });

            if (!checkTeamCtgr) {
                alert("<spring:message code='forum.label.selected' />");
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
            if (isEmptyDateTime("extdSbmsnDateEd", "extdSbmsnTimeEd")) {
                alert("<spring:message code='forum.label.extEndDttm' />");
                return false;
            }

            if (isGreaterDateTime("dateEd", "timeEd", "extdSbmsnDateEd", "extdSbmsnTimeEd")) {
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
            if (isEmptyDateTime("ostdOpenSdttmDateSt", "ostdOpenSdttmTimeSt")) {
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

        const dx = dx5.get("upload1");

        if (dx && dx.availUpload()) {
            dx.startUpload();
        } else {
            save();
        }
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

        $("input[name='copyFiles']").val(dx5.get("upload1").getCopyFiles());
        $("input[name='delFileIdStr']").val(dx5.get("upload1").getDelFileIdStr());
        $("input[name='uploadPath']").val(dx5.get("upload1").getUploadPath());
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

        const asmtSbmsnSdttm = getDateTimeValue("dateSt", "timeSt");
        const asmtSbmsnEdttm = getDateTimeValue("dateEd", "timeEd");

        $("input[name='asmtSbmsnSdttm']").val(asmtSbmsnSdttm);
        $("input[name='asmtSbmsnEdttm']").val(asmtSbmsnEdttm);

        if ($("input[name='extdSbmsnPrmyn']:checked").val() === "Y") {
            $("input[name='extdSbmsnSdttm']").val(asmtSbmsnEdttm);
            $("input[name='extdSbmsnEdttm']").val(getDateTimeValue("extdSbmsnDateEd", "extdSbmsnTimeEd"));
        } else {
            $("input[name='extdSbmsnSdttm']").val("");
            $("input[name='extdSbmsnEdttm']").val("");
        }

        if ($("input[name='sbasmtOstdOyn']:checked").val() === "Y") {
            $("input[name='sbasmtOstdOpenSdttm']").val(getDateTimeValue("ostdOpenSdttmDateSt", "ostdOpenSdttmTimeSt"));
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


    /**
     * =========================================================
     * 저장
     * =========================================================
     */
    function save() {

        const url = eBoolean
            ? "/asmt/profAsmtModify.do"
            : "/asmt/profAsmtRegist.do";

        ajaxCall(url, $("#asmntWriteForm").serialize(), function (data) {
            if (data.result > 0) {
                if (eBoolean) {
                    alert("<spring:message code='common.modify.success' />");
                } else {
                    alert("<spring:message code='common.alert.ok.save' />");
                }
                viewAsmntList();
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
    function viewAsmntList() {
        const kvArr = [];
        kvArr.push({key: "sbjctId", val: "${vo.sbjctId}"});
        submitForm("/asmt/profAsmtListView.do", "", kvArr);
    }


    /**
     * =========================================================
     * 업로드 완료 후 저장
     * =========================================================
     */
    function finishUpload() {

        const dx = dx5.get("upload1");
        const url = "/file/fileHome/saveFileInfo.do";
        const data = {
            uploadFiles: dx.getUploadFiles(),
            copyFiles: dx.getCopyFiles(),
            uploadPath: dx.getUploadPath()
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                $("input[name='uploadFiles']").val(dx.getUploadFiles());
                $("input[name='uploadPath']").val(dx.getUploadPath());
                save();
            } else {
                alert("<spring:message code='success.common.file.transfer.fail'/>");
            }
        }, function () {
            alert("<spring:message code='success.common.file.transfer.fail'/>");
        });
    }


    /**
     * =========================================================
     * 팀 분류 팝업
     * =========================================================
     */
    function teamCtgrSelectPop(i, sbjctId) {
        const modalId = "Ap05";
        initModal(modalId);

        const kvArr = [];
        kvArr.push({key: "sbjctId", val: sbjctId});
        kvArr.push({key: "searchFrom", val: i + ":" + sbjctId});

        submitForm("/team/teamHome/teamCtgrSelectPop.do", modalId + "ModalIfm", kvArr);
    }

    function selectTeam(lrnGrpId, teamCtgrNm, id) {
        const idList = id.split(":");
        $("#lrnGrpId" + idList[0]).val(lrnGrpId + ":" + idList[1]);
        $("#teamCtgr" + idList[0]).val(teamCtgrNm);
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
     * 루브릭 팝업
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
        kvArr.push({key: "sbjctId", val: "${vo.sbjctId}"});
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