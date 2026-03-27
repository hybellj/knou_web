<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/forum2/common/forum_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table,editor,fileuploader"/>
    </jsp:include>

    <script type="text/javascript">
        var dialog;
        const editors = {};	// 에디터 목록 저장용

        $(document).ready(function() {
            // 부주제 조회
            $("input[name='lrnGrpSubForumSettingyns']:checked").each(function (i, e) {
                var lrnGrpId = $("#lrnGrpId" + e.id.split("_")[1]).val().split(":")[0];	// 학습그룹아이디
                var lrnGrpnm = $("#lrnGrpnm" + e.id.split("_")[1]).val();				// 학습그룹명
                var dvclasNo = e.id.split("_")[1];										// 분반 순서
                var sbjctId = e.value.split(":")[1];									// 과목아이디

                selectTeam(lrnGrpId, lrnGrpnm, dvclasNo + ":" + sbjctId);
            });

            initCheckedDvclas();
        });
    </script>
    <title>교수자 토론 등록/수정</title>
</head>
<body class="class colorA">
<div id="wrap" class="main">
    <!-- common header -->
    <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
    <!-- //common header -->

    <!-- classroom -->
    <main class="common">

        <!-- gnb -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
        <!-- //gnb -->

        <!-- content -->
        <div id="content" class="content-wrap common">
            <jsp:include page="/WEB-INF/jsp/common_new/navi_bar_prof.jsp"/>

            <div class="class_sub">
                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title">토론</h2>
                    </div>

                    <div id="messageArea" style="display:none;color:#b00020;margin-bottom:10px;"></div>

                    <div class="board_top">
                        <c:choose>
                        <c:when test="${mode eq 'E'}">
                                <h4 class="sub-title"><spring:message code="forum.button.mod"/></h4>
                            </c:when>
                            <c:otherwise>
                                <h4 class="sub-title"><spring:message code="forum.button.reg"/></h4>
                            </c:otherwise>
                        </c:choose>
                        <div class="right-area">
                        <c:choose>
                            <c:when test="${mode eq 'E'}">
                                <button type="button" class="btn type2" id="btnSave"><spring:message code="forum.button.save"/><!-- 저장 --></a>
                            </c:when>
                            <c:otherwise>
                                <button type="button" class="btn type2" id="btnSave"><spring:message code="forum.button.save"/><!-- 저장 --></a>
                                <button type="button" class="btn type2" id="btnCopy"><spring:message code="forum.button.copy"/><!-- 이전 토론 가져오기 --></button>
                            </c:otherwise>
                        </c:choose>
                            <button type="button" class="btn type2" id="btnGoList"><spring:message code="forum.label.list"/></button>
                        </div>
                    </div>

                    <div class="table-wrap">
                        <form id="forumWriteForm" onsubmit="return false;" autocomplete="off">
                            <!-- TODO : Hidden field -->
                            <div id="teamArea">
                                <c:choose>
                                    <c:when test="${mode eq 'E'}">
                                        <c:set var="path" value="/forum/${forum2VO.dscsId }" />
                                        <input type="text" id="dscsId" name="dscsId" value="${forum2VO.dscsId}" />
                                        <input type="text" id="dscsGrpId" name="dscsGrpId" value="${forum2VO.dscsGrpId}"/>
                                        <input type="text" id="lrnGrpId" name="lrnGrpId" value="${forum2VO.lrnGrpId}"/>
                                        <input type="text" id="dvclsNo" name="dvclsNo" value="${forum2VO.dvclsNo}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="path" value="/forum" />
                                        <input type="text" id="dscsId" name="dscsId" value="" />
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <table class="table-type5" style="margin-top:12px;">
                                <colgroup>
                                    <col class="width-20per"/>
                                    <col/>
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th><label for="dscsTtl" class="req">토론제목</label></th>
                                        <td>
                                            <div class="form-row">
                                                <input class="form-control width-100per" type="text" name="dscsTtl" id="dscsTtl" value='${forum2VO.dscsTtl}' placeholder="<spring:message code="lesson.label.title.input"/>" required="true">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="dscsCts" class="req">토론내용</label></th>
                                        <td data-th="입력">
                                            <li>
                                                <dl>
                                                    <dd>
                                                        <div class="editor-box">
                                                            <%-- HTML 에디터 --%>
                                                            <textarea id="dscsCts" name="dscsCts" required="true"><c:out value="${forum2VO.dscsCts}"/></textarea>
                                                            <script>
                                                                // HTML 에디터
                                                                let editor = UiEditor({
                                                                    targetId: "dscsCts",
                                                                    uploadPath: "${forum2VO.uploadPath}",
                                                                    height: "300px"
                                                                });
                                                            </script>
                                                        </div>
                                                    </dd>
                                                </dl>
                                            </li>
                                        </td>
                                    </tr>
                                    <c:if test="${empty forum2VO.dscsId}">
                                    <tr>
                                        <th><label for="contLabel" class="req">분반같이 등록</label></th>
                                        <td>
                                            <div class="checkbox_type">
                                        <span class="custom-input">
                                            <input type="checkbox" name="allDeclasNo" value="all" id="allDeclas" onchange="dvclasChcChange(this)">
                                            <label for="allDeclas">전체</label>
                                        </span>
                                                <c:forEach var="list" items="${dvclasList }">
                                                    <c:set var="sbjctChk" value="N" />
                                                    <c:forEach var="item" items="${sbjctList }">
                                                        <c:if test="${item.sbjctId eq list.sbjctId }">
                                                            <c:set var="sbjctChk" value="Y" />
                                                        </c:if>
                                                    </c:forEach>
                                                    <span class="custom-input">
                                                <input type="checkbox" ${list.sbjctId eq sbjctId || sbjctChk eq 'Y' ? 'class="readonly" checked readonly' : '' } name="sbjctIds" id="declas_${list.dvclasNo }" value="${list.sbjctId }" onchange="dvclasChcChange(this)">
                                                <label for="declas_${list.dvclasNo }">${list.dvclasNo }반</label>
                                            </span>
                                                </c:forEach>
                                            </div>
                                        </td>
                                    </tr>
                                    </c:if>

                                    <tr>
                                        <th><label for="dscsSdttm" class="req">참여기간</label></th>
                                        <!-- TODO : 참여기간 일정 날짜 + 시간 조합할 것 -->
                                        <input type="hidden" id="dscsSdttm" name="dscsSdttm" placeholder="yyyyMMddHHmmss" class="width-40per" value="<c:out value='${forum2VO.dscsSdttm}'/>"/>
                                        <input type="hidden" id="dscsEdttm" name="dscsEdttm" placeholder="yyyyMMddHHmmss" class="width-40per" value="<c:out value='${forum2VO.dscsEdttm}'/>"/>

                                        <td>
                                            <div class="date_area">
                                                <input id="dateSt" type="text" name="dateSt" class="datepicker" timeId="timeSt" toDate="dateEd" value="${fn:substring(forum2VO.dscsSdttm,0,8)}" required="true">
                                                <input id="timeSt" type="text" name="timeSt" class="timepicker" dateId="dateSt" value="${fn:substring(forum2VO.dscsSdttm,8,12)}" required="true">
                                                <span class="txt-sort">~</span>
                                                <input id="dateEd" type="text" name="dateEd" class="datepicker" timeId="timeEd" fromDate="dateSt" value="${fn:substring(forum2VO.dscsEdttm,0,8)}" required="true">
                                                <input id="timeEd" type="text" name="timeEd" class="timepicker" dateId="dateEd" value="${fn:substring(forum2VO.dscsEdttm,8,12)}" required="true">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label class="req">성적반영</label></th>
                                        <td>
                                            <span class="custom-input">
                                                <input type="radio" name="mrkRfltyn" id="mrkRfltynY" value="Y" ${forum2VO.mrkRfltyn eq 'Y' || empty forum2VO.dscsId ? 'checked' : '' }>
                                                <label for="mrkRfltynY">예</label>
                                            </span>
                                            <span class="custom-input ml5">
                                                <input type="radio" name="mrkRfltyn" id="mrkRfltynN" value="N" ${forum2VO.mrkRfltyn eq 'N' ? 'checked' : '' }>
                                                <label for="mrkRfltynN">아니오</label>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label class="req">성적공개</label></th>
                                        <td>
                                            <span class="custom-input">
                                                <input type="radio" name="mrkOyn" id="mrkOynY" value="Y" ${forum2VO.mrkOyn eq 'Y' || empty forum2VO.mrkOyn ? 'checked' : '' }>
                                                <label for="mrkOynY">예</label>
                                            </span>
                                            <span class="custom-input ml5">
                                                <input type="radio" name="mrkOyn" id="mrkOynN" value="N" ${forum2VO.mrkOyn eq 'N' ? 'checked' : '' }>
                                                <label for="mrkOynN">아니오</label>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label class="req">평가방법</label></th>
                                        <td>
                                            <span class="custom-input">
                                                <input type="radio" name="evlScrTycd" id="evlScrTycd1" value="SCR" ${forum2VO.evlScrTycd eq 'SCR' || empty forum2VO.evlScrTycd ? 'checked' : '' }>
                                                <label for="evlScrTycd1">점수형</label>
                                            </span>
                                            <span class="custom-input ml5">
                                                <input type="radio" name="evlScrTycd" id="evlScrTycd2" value="PTCP_FULL_SCR" ${forum2VO.evlScrTycd eq 'PTCP_FULL_SCR' ? 'checked' : '' }>
                                                <label for="evlScrTycd2">참여형</label>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="attchFile">파일첨부</label></th>
                                        <td>
                                            <uiex:dextuploader
                                                    id="fileUploader"
                                                    path="/bbs"
                                                    limitCount="5"
                                                    limitSize="100"
                                                    oneLimitSize="100"
                                                    listSize="3"
                                                    fileList=""
                                                    finishFunc="finishUpload()"
                                                    allowedTypes="*"
                                            />
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label>팀 토론</label></th>
                                        <td>
                                            <span class="custom-input ml5">
                                                <input type="radio" name="dscsUnitTycd" id="dscsUnitTycdN" value="N" onchange="teamynChange(this.value)" ${empty forum2VO.dscsUnitTycd || forum2VO.dscsUnitTycd ne 'TEAM' ? 'checked' : ''}>
                                                <label for="dscsUnitTycdN">아니오</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="dscsUnitTycd" id="dscsUnitTycdY" value="Y" onchange="teamynChange(this.value)" ${forum2VO.dscsUnitTycd eq 'TEAM' ? 'checked' : ''}>
                                                <label for="dscsUnitTycdY">예</label>
                                            </span>
                                            <div id="teamForumDiv" ${empty forum2VO.dscsId || forum2VO.dscsUnitTycd ne 'TEAM' ? 'style="display:none"' : '' }>
                                                <c:forEach var="list" items="${dvclasList }" varStatus="i">
                                                    <div class="form-row" id='lrnGrpView${list.dvclasNo}' ${not empty forum2VO.dscsId && list.dvclasNo eq forum2VO.dvclsNo ? '' : 'style="display:none;"'}>
                                                        <div class="input_btn width-100per">
                                                            <label>${list.dvclasNo }반</label>
                                                            <input type='hidden' id='lrnGrpId${list.dvclasNo}' name='lrnGrpIds' value="${empty forum2VO.dscsId ? '' : (list.dvclasNo eq forum2VO.dvclsNo ? forum2VO.lrnGrpId : list.lrnGrpId)}:${list.sbjctId}">
                                                            <input class="form-control width-60per" type="text" name="name" id="lrnGrpnm${list.dvclasNo}" placeholder="팀 분류를 선택해 주세요." value="${empty forum2VO.dscsId ? '' : (list.dvclasNo eq forum2VO.dvclsNo ? forum2VO.dscsGrpnm : '')}" readonly="" autocomplete="off">
                                                            <a class="btn type1 small" onclick="teamCtgrSelectPop('${list.dvclasNo}','${list.sbjctId }')">학습그룹지정</a>
                                                        </div>
                                                    </div>
                                                    <c:if test="${i.count eq 1 }">
                                                    <div class="form-inline">
                                                        <small class="note2">! 구성된 팀이 없는 경우 메뉴 “과목설정 > 학습그룹지정”에서 팀을 생성해 주세요</small>
                                                    </div>
                                                    </c:if>
                                                    <div class="ui segment" id="setForumDiv${list.dvclasNo}" ${not empty forum2VO.dscsId && list.dvclasNo eq forum2VO.dvclsNo && not empty forum2VO.lrnGrpId ? '' : 'style="display:none;"'}>
                                                        <span class="custom-input">
                                                            <input type="checkbox" name="lrnGrpSubForumSettingyns" id="lrnGrpSubForumSettingyn_${list.dvclasNo}" value="Y:${list.sbjctId}" onchange="lrnGrpSubForumSettingynChange(this)" ${not empty forum2VO.dscsId && list.dvclasNo eq forum2VO.dvclsNo && forum2VO.byteamDscsUseyn eq 'Y' ? 'checked' : ''}>
                                                            <label for="lrnGrpSubForumSettingyn_${list.dvclasNo}">학습그룹별 부 주제 설정</label>
                                                        </span>
                                                        <div id="subInfoDiv${list.dvclasNo}" ${not empty forum2VO.dscsId && list.dvclasNo eq forum2VO.dvclsNo && forum2VO.byteamDscsUseyn eq 'Y' ? '' : 'style="display: none;"'}></div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <div class="course_list">
                                <ul class="accordion course_week_">
                                    <li>
                                        <div class="title-wrap">
                                            <a class="title" href="#">
                                                <span>옵션</span>
                                            </a>
                                            <div class="btn_right">
                                                <i class="arrow xi-angle-down"></i>
                                            </div>
                                        </div>

                                        <div class="cont">
                                            <table class="table-type5" >
                                                <colgroup>
                                                    <col class="width-20per"/>
                                                    <col/>
                                                </colgroup>
                                                <tbody>
                                                    <tr>
                                                        <th><label for="contLabel" class="req">참여글 보기 옵션</label></th>
                                                        <td>
                                                            <span class="custom-input">
                                                                <input type="hidden" name="oatclInqyn" id="oatclInqynHidden" value="<c:out value='${empty forum2VO.oatclInqyn ? \"N\" : forum2VO.oatclInqyn}'/>"/>
                                                                <input type="checkbox" id="oatclInqyn" ${forum2VO.oatclInqyn eq 'Y' ? 'checked' : '' }>
                                                                <label for="oatclInqyn"><spring:message code="forum.label.otherViewYn"/></label><!-- 참여글 보기 옵션
 -->
                                                            </span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <!-- 댓글 답변 요청 -->
                                                        <th><label for="contLabel" class="req"><spring:message code="forum.label.aplyAsnYn"/></label></th>
                                                        <td>
                                                            <span class="custom-input">
                                                                <input type="radio" name="cmntRspnsReqyn" id="cmntRspnsReqynY" value="Y" ${forum2VO.cmntRspnsReqyn eq 'Y' || empty forum2VO.cmntRspnsReqyn ? 'checked' : '' }>
                                                                <label for="cmntRspnsReqynY">예</label>
                                                            </span>
                                                            <span class="custom-input ml5">
                                                                <input type="radio" name="cmntRspnsReqyn" id="cmntRspnsReqynN" value="N" ${forum2VO.cmntRspnsReqyn eq 'N' ? 'checked' : '' }>
                                                                <label for="cmntRspnsReqynN">아니오</label>
                                                            </span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <!-- 찬반 토론으로 설정 -->
                                                        <th><label><spring:message code="forum.label.prosCons"/></label></th>
                                                        <td>
                                                            <span class="custom-input">
                                                                <input type="radio" name="oknokStngyn" id="oknokStngynN" value="N" ${forum2VO.oknokStngyn eq 'N' || empty forum2VO.oknokStngyn ? 'checked' : '' }>
                                                                <label for="oknokStngynN">아니오</label>
                                                                </span>
                                                            <span class="custom-input ml10">
                                                                <input type="radio" name="oknokStngyn" id="oknokStngynY" value="Y" ${forum2VO.oknokStngyn eq 'Y'  ? 'checked' : '' }>
                                                                <label for="oknokStngynY">예</label>
                                                            </span>

                                                            <div id="oknok_option_area" class="mt10 ml10">
                                                                <!-- 1) 찬반 비율 공개 -->
                                                                <div class="form-row">
                                                                    <span class="custom-input ml5">
                                                                        <label for="oknokrtOyn">찬반 비율 공개</label>
                                                                        <input type="hidden" name="oknokrtOyn" id="oknokrtOynHidden" value="<c:out value='${empty forum2VO.oknokrtOyn ? \"N\" : forum2VO.oknokrtOyn}'/>"/>
                                                                        <input type="checkbox" class="switch small" id="oknokrtOyn"
                                                                               <c:if test="${forum2VO.oknokrtOyn eq 'Y'}">checked</c:if> />
                                                                    </span>
                                                                </div>

                                                                <!-- 2) 작성자 공개 -->
                                                                <div class="form-row">
                                                                    <span class="custom-input ml5">
                                                                        <label for="oknokRgtrOyn">작성자 공개</label>
                                                                        <input type="hidden" name="oknokRgtrOyn" id="oknokRgtrOynHidden"
                                                                               value="<c:out value='${empty forum2VO.oknokRgtrOyn ? \"N\" : forum2VO.oknokRgtrOyn}'/>"/>
                                                                        <input type="checkbox" class="switch small" id="oknokRgtrOyn"
                                                                               <c:if test="${forum2VO.oknokRgtrOyn eq 'Y'}">checked</c:if> />
                                                                    </span>
                                                                </div>

                                                                <!-- 3) 의견 글 복수 등록 -->
                                                                <div class="form-row">
                                                                    <span class="custom-input ml5">
                                                                        <label for="mltOpnnRegyn">의견 글 복수 등록</label>
                                                                        <input type="hidden" name="mltOpnnRegyn" id="mltOpnnRegynHidden"
                                                                               value="<c:out value='${empty forum2VO.mltOpnnRegyn ? \"N\" : forum2VO.mltOpnnRegyn}'/>"/>
                                                                        <input type="checkbox" class="switch small" id="mltOpnnRegyn"
                                                                               <c:if test="${forum2VO.mltOpnnRegyn eq 'Y'}">checked</c:if> />
                                                                    </span>
                                                                </div>

                                                                <!-- 4) 찬반 의견 변경가능 (기존 oknokModyn 사용) -->
                                                                <div class="form-row">
                                                                    <span class="custom-input ml5">
                                                                        <label for="oknokModyn">찬반 의견 변경가능</label>
                                                                        <input type="hidden" name="oknokModyn" id="oknokModynHidden" value="<c:out value='${empty forum2VO.oknokModyn ? \"N\" : forum2VO.oknokModyn}'/>"/>
                                                                        <input type="checkbox" class="switch small" id="oknokModyn"
                                                                               <c:if test="${forum2VO.oknokModyn eq 'Y'}">checked</c:if> />
                                                                    </span>
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
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
    $(function () {
        bindEvents();
        initSwitchYnFields();
        toggleTeamArea();
        initForumTeamList();
    });

    // 체크된 분반 초기화
    function initCheckedDvclas() {
        $("input[name='sbjctIds']:checked").each(function() {
            dvclasChcChange(this);
        });
    }

    function bindEvents() {
        $('#dscsUnitTycd').on('change', function () {
            toggleTeamArea();
        });

        $('#btnSave').on('click', function () {
            saveForum();
        });

        $('#btnCopy').on('click', function () {
            forumCopy();
        });

        $('#btnGoList').on('click', function () {
            location.href = '<c:url value="/forum2/forumLect/profForumListView.do" />';
        });

        $('#oatclInqyn, #oknokRgtrOyn, #oknokrtOyn, #mltOpnnRegyn, #oknokModyn').on('change', function () {
            syncSwitchHiddenById(this.id);
        });
    }

    function syncSwitchHiddenById(switchId) {
        var $switch = $('#' + switchId);
        var $hidden = $('#' + switchId + 'Hidden');
        if ($hidden.length === 0) {
            return;
        }
        $hidden.val($switch.is(':checked') ? 'Y' : 'N');
    }

    function syncAllSwitchHidden() {
        var switchIds = ['oatclInqyn', 'oknokRgtrOyn', 'oknokrtOyn', 'mltOpnnRegyn', 'oknokModyn'];
        for (var i = 0; i < switchIds.length; i++) {
            syncSwitchHiddenById(switchIds[i]);
        }
    }

    // Switch 버튼들 값 설정
    function initSwitchYnFields() {
        syncAllSwitchHidden();
    }

    // 저장전 date + time 합침.
    function syncDiscussionDateTimeFields() {
        var dscsSdttm = UiComm.getDateTimeVal("dateSt", "timeSt");
        var dscsEdttm = UiComm.getDateTimeVal("dateEd", "timeEd");
        $('#dscsSdttm').val(dscsSdttm);
        $('#dscsEdttm').val(dscsEdttm);
    }

    function parseResult(data) {
        return {
            code: data.resultCode || data.result || data.resultStatus || 0,
            message: data.resultMessage || data.message || '',
            status: data.resultStatus || data.resultCode || data.result || 0
        };
    }

    function showError(message) {
        var msg = message || '처리 중 오류가 발생했습니다.';
        $('#messageArea').text(msg).show();
        alert(msg);
    }

    function toggleTeamArea() {
        if ($('#dscsUnitTycd').val() === 'TEAM') {
            $('#teamArea').show();
        } else {
            $('#teamArea').hide();
            // 수정 모드('E')가 아닐 때만 초기화하도록 조건 추가
            if ('${mode}' !== 'E') {
                $('#dscsGrpId').val('');
                $('#lrnGrpId').val('');
                $('#dvclsNo').val('');
            }
        }
    }

    /**
     * 분반 선택 변경
     * @param {obj}  obj - 선택한 분반 체크박스
     */
    function dvclasChcChange(obj) {
        if(obj.value == "all") {
            $("input[name=sbjctIds]").not(".readonly").prop("checked", obj.checked);

            if(obj.checked) {
                $("div[id^='lrnGrpView']").css("display", "flex");
                $("input[name='lrnGrpSubForumSettingyns']:checked").each(function(i, e) {
                    $("#setForumDiv"+e.id.split("_")[1]).show();
                });
            } else {
                var fixDvclas = $("input[name=sbjctIds]").filter(".readonly")[0].id.split("_")[1];
                $("div[id^='lrnGrpView']").not("#lrnGrpView"+fixDvclas).hide();
                $("div[id^='setForumDiv']").not("#setForumDiv"+fixDvclas).hide();
            }
        } else {
            $("#allDeclas").prop("checked", $("input[name=sbjctIds]").length == $("input[name=sbjctIds]:checked").length);

            if(obj.checked) {
                $("#lrnGrpView" + obj.id.split("_")[1]).css("display", "flex");
                $("#setForumDiv"+obj.id.split("_")[1]).show();
            } else {
                $("#lrnGrpView" + obj.id.split("_")[1]).hide();
                $("#setForumDiv"+obj.id.split("_")[1]).hide();
            }
        }
    }

    /**
     * 팀 퀴즈 여부 변경
     * @param {String}  value - 팀 퀴즈 여부
     */
    function teamynChange(value) {
        if(value == "Y") {
            $("#teamForumDiv").show();
        } else {
            $("#teamForumDiv").hide();
        }
    }

    /**
     * 학습그룹지정 팝업
     * @param {Integer} i 		- 분반 순서
     * @param {String}  sbjctId - 과목아이디
     */
    function teamCtgrSelectPop(i, sbjctId) {
        dialog = UiDialog("dialog1", {
            title: "학습그룹지정",
            width: 600,
            height: 500,
            url: "/team/teamHome/teamCtgrSelectPop.do?sbjctId="+sbjctId+"&searchFrom="+i + ":" + sbjctId,
            autoresize: false
        });
    }

    /**
     * 학습그룹 선택
     * @param {String}  lrnGrpId 	- 학습그룹아이디
     * @param {String}  lrnGrpnm 	- 학습그룹명
     * @param {String}  id 			- 분반 순서:과목개설아이디
     * @returns {list} 팀 목록
     */
    function selectTeam(lrnGrpId, lrnGrpnm, id) {
        var idList = id.split(':');
        $("#lrnGrpId" + idList[0]).val(lrnGrpId + ":" + idList[1]);
        $("#lrnGrpnm" + idList[0]).val(lrnGrpnm);
        $("#setForumDiv" + idList[0]).show();

        loadForumTeamList(lrnGrpId, idList[0]);
    }

    /** 학습그룹 팀 목록 조회 후 subInfoDiv 에 렌더링 */
    function loadForumTeamList(lrnGrpId, dvclasNo) {
        var url  = '<c:url value="/forum2/forumLect/profForumLrnGrpTeamListAjax.do" />';
        var data = {
            lrnGrpId : lrnGrpId,
            upDscsId : '${forum2VO.dscsId}'
        };
        ajaxCall(url, data, function(resp) {
            if (resp.result > 0) {
                var returnList = resp.returnList || [];
                var html = buildForumTeamListHtml(returnList);
                $("#subInfoDiv" + dvclasNo).empty().html(html);
                if (returnList.length > 0) {
                    returnList.forEach(function(v, i) {
                        editors[v.teamId + '_editor' + i] = UiEditor({
                            targetId  : v.teamId + '_contentTextArea_' + i,
                            uploadPath: "/forum",
                            height    : "250px"
                        });
                    });
                }
            } else {
                UiComm.showMessage(resp.message, "error");
            }
        });
    }

    /** 팀 목록 HTML 생성 (appendTeamForumDetailParams 호환 구조) */
    function buildForumTeamListHtml(list) {
        if (!list || list.length === 0) {
            return '<p class="p_gray">팀 정보가 없습니다.</p>';
        }
        var html = "<table class='table-type2'>";
        html += "    <colgroup>";
        html += "        <col class='width-10per' />";
        html += "        <col class='' />";
        html += "        <col class='width-10per' />";
        html += "    </colgroup>";
        html += "    <tbody>";
        html += "        <tr>";
        html += "            <th>팀</th>";
        html += "            <th>부 주제</th>";
        html += "            <th>학습그룹 구성원</th>";
        html += "        </tr>";
        list.forEach(function(v, i) {
            html += "    <tr class='subForumTr' data-team-id='" + escHtml(v.teamId || '') + "' data-team-nm='" + escHtml(v.teamnm || '') + "'>";
            html += "        <th><label>" + escHtml(v.teamnm || '') + "</label></th>";
            html += "        <td>";
            html += "            <table class='table-type5'>";
            html += "                <colgroup>";
            html += "                    <col class='width-10per' />";
            html += "                    <col class='' />";
            html += "                </colgroup>";
            html += "                <tbody>";
            html += "                    <tr>";
            html += "                        <th><label for='" + v.teamId + "_dtlSubjTtl_" + i + "' class='req'>주제</label></th>";
            html += "                        <td><input type='text' id='" + v.teamId + "_dtlSubjTtl_" + i + "' name='teamTtl' value='" + escHtml(v.dscsTtl || '') + "' inputmask='byte' maxLen='200' class='width-100per' /></td>";
            html += "                    </tr>";
            html += "                    <tr>";
            html += "                        <th><label for='" + v.teamId + "_contentTextArea_" + i + "' class='req'>내용</label></th>";
            html += "                        <td>";
            html += "                            <div class='editor-box'>";
            html += "                                <textarea name='" + v.teamId + "_contentTextArea_" + i + "' id='" + v.teamId + "_contentTextArea_" + i + "'>" + escHtml(v.dscsCts || '') + "</textarea>";
            html += "                            </div>";
            html += "                        </td>";
            html += "                    </tr>";
            html += "                </tbody>";
            html += "            </table>";
            html += "        </td>";
            html += "        <th>" + escHtml(v.leaderNm || '-') + " 외 " + Math.max(0, (v.teamMbrCnt || 1) - 1) + "</th>";
            html += "    </tr>";
        });
        html += "    </tbody>";
        html += "</table>";
        return html;
    }

    function escHtml(str) {
        return (str || '').replace(/&/g, '&amp;').replace(/</g, '&lt;')
                          .replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

    /** 수정모드 진입 시 이미 지정된 학습그룹의 팀 목록 초기 로드 */
    function initForumTeamList() {
        if ('${mode}' !== 'E') return;
        $("div[id^='lrnGrpView']").each(function() {
            var dvclasNo = this.id.replace('lrnGrpView', '');
            var lrnGrpRaw = $('#lrnGrpId' + dvclasNo).val() || '';
            var lrnGrpId  = lrnGrpRaw.split(':')[0] || '';
            if (lrnGrpId) {
                loadForumTeamList(lrnGrpId, dvclasNo);
            }
        });
    }

    /**
     * 학습그룹 설정여부 변경
     * @param {obj}  obj - 분반 학습그룹 과제 설정 체크박스
     */
    function lrnGrpSubForumSettingynChange(obj) {
        if(obj.checked) {
            $("#subInfoDiv" + obj.id.split("_")[1]).show();
        } else {
            $("#subInfoDiv" + obj.id.split("_")[1]).hide();
        }
    }

    function resetTeamForumDetailParams() {
        $('#forumWriteForm input.__teamForumDtlParam').remove();
    }

    function resetLrnGrpInfoParams() {
        $('#forumWriteForm input.__lrnGrpInfoParam').remove();
    }

    function resetDvclasSelParams() {
        $('#forumWriteForm input.__dvclasSelParam').remove();
    }

    function appendDvclasSelParam(index, fieldName, value) {
        $('<input>', {
            type: 'hidden',
            name: 'dvclasSelList[' + index + '].' + fieldName,
            value: value || '',
            'class': '__dvclasSelParam'
        }).appendTo('#forumWriteForm');
    }

    function appendDvclasSelParams() {
        resetDvclasSelParams();

        var index = 0;
        $("input[name='sbjctIds']").each(function() {
            var id = this.id || '';
            var dvclasNo = id.indexOf('declas_') === 0 ? id.substring(7) : '';
            var sbjctId = this.value || '';
            var checkedYn = $(this).is(':checked') ? 'Y' : 'N';
            var readonlyYn = ($(this).hasClass('readonly') || $(this).prop('readonly')) ? 'Y' : 'N';

            if (!dvclasNo || !sbjctId) {
                return;
            }

            appendDvclasSelParam(index, 'dvclasNo', dvclasNo);
            appendDvclasSelParam(index, 'sbjctId', sbjctId);
            appendDvclasSelParam(index, 'checkedYn', checkedYn);
            appendDvclasSelParam(index, 'readonlyYn', readonlyYn);
            index++;
        });
    }

    function appendLrnGrpInfoParam(index, fieldName, value) {
        $('<input>', {
            type: 'hidden',
            name: 'lrnGrpInfoList[' + index + '].' + fieldName,
            value: value || '',
            'class': '__lrnGrpInfoParam'
        }).appendTo('#forumWriteForm');
    }

    function appendLrnGrpInfoParams() {
        resetLrnGrpInfoParams();

        var index = 0;
        $("div[id^='lrnGrpView']").each(function() {
            var dvclasNo = (this.id || '').replace('lrnGrpView', '');
            if (!dvclasNo) {
                return;
            }

            var lrnGrpRaw = $('#lrnGrpId' + dvclasNo).val() || '';
            var lrnGrpnm = $.trim($('#lrnGrpnm' + dvclasNo).val() || '');
            if (!lrnGrpRaw) {
                return;
            }

            var tokens = lrnGrpRaw.split(':');
            var lrnGrpId = tokens[0] || '';
            var sbjctId = tokens.length > 1 ? (tokens[1] || '') : '';
            if (!lrnGrpId) {
                return;
            }

            appendLrnGrpInfoParam(index, 'dvclasNo', dvclasNo);
            appendLrnGrpInfoParam(index, 'sbjctId', sbjctId);
            appendLrnGrpInfoParam(index, 'lrnGrpId', lrnGrpId);
            appendLrnGrpInfoParam(index, 'lrnGrpnm', lrnGrpnm);
            appendLrnGrpInfoParam(index, 'byteamDscsUseyn', $('#lrnGrpSubForumSettingyn_' + dvclasNo).is(':checked') ? 'Y' : 'N');
            index++;
        });
    }

    function appendTeamForumDetailParam(index, fieldName, value) {
        $('<input>', {
            type: 'hidden',
            name: 'teamForumDtlList[' + index + '].' + fieldName,
            value: value || '',
            'class': '__teamForumDtlParam'
        }).appendTo('#forumWriteForm');
    }

    function pickFieldValue($scope, selectors) {
        for (var i = 0; i < selectors.length; i++) {
            var $el = $scope.find(selectors[i]).first();
            if ($el.length > 0) {
                return $.trim($el.val() || $el.text() || '');
            }
        }
        return '';
    }

    function appendTeamForumDetailParams() {
        resetTeamForumDetailParams();

        if (!$("input[name='dscsUnitTycd']:checked").length || $("input[name='dscsUnitTycd']:checked").val() !== 'Y') {
            return;
        }

        var index = 0;
        $("div[id^='lrnGrpView']").each(function() {
            var dvclasNo = (this.id || '').replace('lrnGrpView', '');
            if (!dvclasNo) {
                return;
            }

            var lrnGrpRaw = $('#lrnGrpId' + dvclasNo).val() || '';
            if (!lrnGrpRaw) {
                return;
            }
            var lrnGrpTokens = lrnGrpRaw.split(':');
            var lrnGrpId = lrnGrpTokens[0] || '';
            var sbjctId = lrnGrpTokens.length > 1 ? (lrnGrpTokens[1] || '') : '';

            var $subInfoDiv = $('#subInfoDiv' + dvclasNo);
            if ($subInfoDiv.length === 0 || $subInfoDiv.children().length === 0) {
                return;
            }

            var $teamRows = $subInfoDiv.find('[data-team-id], tr.subForumTr');
            if ($teamRows.length === 0) {
                $teamRows = $subInfoDiv.children();
            }

            $teamRows.each(function() {
                var $row = $(this);
                var teamId = $.trim($row.attr('data-team-id') || pickFieldValue($row, [
                    "input[name='teamId']",
                    "input[name='teamid']",
                    "input[name='team_id']"
                ]));
                var teamNm = $.trim($row.attr('data-team-nm') || pickFieldValue($row, [
                    "input[name='teamNm']",
                    "input[name='teamnm']",
                    "input[name='team_name']",
                    ".teamNm",
                    ".teamnm"
                ]));
                var teamTtl = pickFieldValue($row, [
                    "input[name='teamTtl']",
                    "input[name='teamSubject']",
                    "input[name='subForumTtl']",
                    "input[name='subExamTtl']"
                ]);
                var teamCts = pickFieldValue($row, [
                    "textarea[name='teamCts']",
                    "textarea[name='teamDiscussion']",
                    "textarea[name='subForumCts']",
                    "textarea[id*='contentTextArea']"
                ]);
                var attchFileId = pickFieldValue($row, [
                    "input[name='attchFileId']",
                    "input[name='fileSn']",
                    "input[name='fileId']"
                ]);

                // 팀ID/팀명은 필수로 보고, 둘 다 비어있으면 빈 row로 간주한다.
                if (!teamId && !teamNm) {
                    return;
                }

                appendTeamForumDetailParam(index, 'dvclasNo', dvclasNo);
                appendTeamForumDetailParam(index, 'sbjctId', sbjctId);
                appendTeamForumDetailParam(index, 'lrnGrpId', lrnGrpId);
                appendTeamForumDetailParam(index, 'teamId', teamId);
                appendTeamForumDetailParam(index, 'teamNm', teamNm);
                appendTeamForumDetailParam(index, 'dscsTtl', teamTtl);
                appendTeamForumDetailParam(index, 'dscsCts', teamCts);
                appendTeamForumDetailParam(index, 'attchFileId', attchFileId);
                index++;
            });
        });
    }

    // 토론등록/저장
    function saveForum() {
        let validator = UiValidator("forumWriteForm");
        validator.then(function(result) {
            syncAllSwitchHidden();
            syncDiscussionDateTimeFields();
            appendDvclasSelParams();
            appendLrnGrpInfoParams();
            appendTeamForumDetailParams();
            var registUrl = '<c:url value="/forum2/forumLect/profForumRegist.do" />';
            var modifyUrl = '<c:url value="/forum2/forumLect/profForumModify.do" />';
            var isModifyMode = '${mode}' === 'E';
            var url = isModifyMode ? modifyUrl : registUrl;
            var param = $('#forumWriteForm').serialize();

            $.ajax({
                url 	 : url,
                async	 : false,
                type 	 : "POST",
                /*dataType : "json",
                contentType: 'application/json',*/
                data 	 : param,
                beforeSend: function () {
                    UiComm.showLoading(true);
                }
            }).done(function(data) {
                UiComm.showLoading(false);
                if (data.result > 0) {
                    UiComm.showMessage("<spring:message code='success.common.save' />", "success")/* 정상 저장 되었습니다. */
                    .then(function(result) {
                        console.log('2:' + result);
                        location.href = '<c:url value="/forum2/forumLect/profForumListView.do" />';
                    });
                } else {
                    UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
                }
            }).fail(function() {
                UiComm.showLoading(false);
                UiComm.showMessage("<spring:message code='fail.common.msg'/>","error"); // 에러가 발생했습니다!
            });
        });
    }

    // 이전 토론 가져오기
    function forumCopy() {
        /*
        $("#forumCopyForm > input[name='crsCreCd']").val("${forumVo.crsCreCd}");
        $("#forumCopyForm").attr("target", "forumCopyIfm");
        $("#forumCopyForm").attr("action", "/forum/forumLect/Form/forumCopyPop.do");
        $("#forumCopyForm").submit();
        $('#forumCopyPop').modal('show');
        */
        dialog = UiDialog("dialog1", {
            title: "<spring:message code='forum.button.copy'/>",
            width: 800,
            height: 500,
            url: "/forum2/forumLect/Form/forumCopyPop.do?sbjctId=" + '${forum2VO.sbjctId}',
            autoresize: false
        });
    }

    // 이전 토론 가져오기 팝업에서 선택 시 호출 (window.parent.copyForum)
    function copyForum(forumCd) {
        UiComm.showLoading(true);
        $.ajax({
            url     : "/forum2/forumLect/Form/forumCopy.do",
            async   : false,
            type    : "POST",
            dataType: "json",
            data    : { "dscsId": forumCd }
        }).done(function(resp) {
            UiComm.showLoading(false);
            if (resp.result > 0) {
                var v = resp.returnVO;
                if (!v) { UiComm.showMessage("데이터가 없습니다.", "error"); return; }

                // 토론 제목
                $('#dscsTtl').val(v.dscsTtl || '');

                // 토론 내용 (HTML 에디터)
                editor.openHTML(v.dscsCts);

                // 참여기간: dscsSdttm/dscsEdttm = yyyyMMddHHmmss
                var sdttm = v.dscsSdttm || '';
                var edttm = v.dscsEdttm || '';
                $('#dateSt').val(sdttm.substring(0, 8));
                $('#timeSt').val(sdttm.substring(8, 12));
                $('#dateEd').val(edttm.substring(0, 8));
                $('#timeEd').val(edttm.substring(8, 12));
                $('#dscsSdttm').val(sdttm);
                $('#dscsEdttm').val(edttm);

                // 성적반영
                $("input[name='mrkRfltyn'][value='" + (v.mrkRfltyn || 'Y') + "']").prop('checked', true);

                // 성적공개
                $("input[name='mrkOyn'][value='" + (v.mrkOyn || 'Y') + "']").prop('checked', true);

                // 평가방법
                $("input[name='evlScrTycd'][value='" + (v.evlScrTycd || 'SCR') + "']").prop('checked', true);

                // 팀 영역 초기화 (selectTeam 이전 상태로 리셋)
                $("div[id^='lrnGrpView']").each(function() {
                    var dvclasNo = this.id.replace('lrnGrpView', '');
                    $('#lrnGrpId'  + dvclasNo).val('');
                    $('#lrnGrpnm'  + dvclasNo).val('');
                    $('#subInfoDiv' + dvclasNo).empty();
                    $('#lrnGrpSubForumSettingyn_' + dvclasNo).prop('checked', false);
                    $('#lrnGrpView'  + dvclasNo).hide();
                    $('#setForumDiv' + dvclasNo).hide();
                });
                initCheckedDvclas();

                // 팀 토론 여부
                var isTeam = (v.dscsUnitTycd === 'TEAM') ? 'Y' : 'N';
                $("input[name='dscsUnitTycd'][value='" + isTeam + "']").prop('checked', true);
                teamynChange(isTeam);

                // 팀 토론인 경우 학습그룹 정보 복원
                if (isTeam === 'Y' && v.dvclsNo && v.lrnGrpId) {
                    var dvclasNo = v.dvclsNo;
                    var $chk = $('#lrnGrpSubForumSettingyn_' + dvclasNo);
                    if ($chk.length) {
                        var sbjctId = $chk.val().split(':')[1];                    // "Y:sbjctId" → sbjctId
                        $('#lrnGrpView' + dvclasNo).css("display", "flex");        // 분반 행 노출
                        selectTeam(v.lrnGrpId, v.dscsGrpnm || '', dvclasNo + ':' + sbjctId);  // 그룹명/ID 세팅 + 팀목록 로드
                        if (v.byteamDscsUseyn === 'Y') {
                            $chk.prop('checked', true);
                            $('#subInfoDiv' + dvclasNo).show();                    // 부주제 영역 노출
                        }
                    }
                }

                // 참여글 보기 옵션 (checkbox + hidden)
                var oatclInqyn = v.oatclInqyn || 'N';
                $('#oatclInqyn').prop('checked', oatclInqyn === 'Y');
                $('#oatclInqynHidden').val(oatclInqyn);

                // 댓글 답변 요청
                $("input[name='cmntRspnsReqyn'][value='" + (v.cmntRspnsReqyn || 'Y') + "']").prop('checked', true);

                // 찬반 토론 설정
                $("input[name='oknokStngyn'][value='" + (v.oknokStngyn || 'N') + "']").prop('checked', true);

                // 찬반 비율 공개
                var oknokrtOyn = v.oknokrtOyn || 'N';
                $('#oknokrtOyn').prop('checked', oknokrtOyn === 'Y');
                $('#oknokrtOynHidden').val(oknokrtOyn);

                // 작성자 공개
                var oknokRgtrOyn = v.oknokRgtrOyn || 'N';
                $('#oknokRgtrOyn').prop('checked', oknokRgtrOyn === 'Y');
                $('#oknokRgtrOynHidden').val(oknokRgtrOyn);

                // 의견 글 복수 등록
                var mltOpnnRegyn = v.mltOpnnRegyn || 'N';
                $('#mltOpnnRegyn').prop('checked', mltOpnnRegyn === 'Y');
                $('#mltOpnnRegynHidden').val(mltOpnnRegyn);

                // 찬반 의견 변경가능
                var oknokModyn = v.oknokModyn || 'N';
                $('#oknokModyn').prop('checked', oknokModyn === 'Y');
                $('#oknokModynHidden').val(oknokModyn);

                closeDialog();
            } else {
                UiComm.showMessage(resp.message || "<spring:message code='forum.common.error'/>", "error");
            }
        }).fail(function() {
            UiComm.showLoading(false);
            UiComm.showMessage("<spring:message code='forum.common.error'/>", "error");
        });
    }

    // 팝업 dialog 닫기 (window.parent.closeDialog()로 호출됨)
    function closeDialog() {
        if (dialog) {
            dialog.close();
        }
    }

</script>
</body>
</html>
