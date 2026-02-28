<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table,editor,fileuploader"/>
    </jsp:include>
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
                                <button type="button" class="btn type2" id="btnCopy"><spring:message code="forum.button.copy"/></button>
                            </c:otherwise>
                        </c:choose>
                            <button type="button" class="btn type2" id="btnGoList"><spring:message code="forum.label.list"/></button>
                        </div>
                    </div>

                    <div class="table-wrap">
                        <form id="forumWriteForm" onsubmit="return false;" autocomplete="off">
                            <input type="text" id="dscsId" name="dscsId" value="${not empty forum2VO.dscsId ? forum2VO.dscsId : param.dscsId}"/>
                            <input type="text" id="sourceDscssId" name="sourceDscssId" value="${param.sourceDscssId}"/>
                            <input type="text" id="sbjctId" name="sbjctId" value="${forum2VO.sbjctId}"/>
                            <input type="text" id="dscsGbncd" name="dscsGbncd" value="${forum2VO.dscsGbncd}"/>

                            <!-- TODO : 팀 -->
                            <div id="teamArea" margin-top:12px;">
                                <table class="table-type5">
                                    <colgroup>
                                        <col class="width-20per"/>
                                        <col/>
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th><label for="dscsGrpId">토론그룹ID</label></th>
                                        <td><input type="text" id="dscsGrpId" name="dscsGrpId" class="width-100per" value="<c:out value='${forum2VO.dscsGrpId}'/>"/></td>
                                    </tr>
                                    <tr>
                                        <th><label for="lrnGrpId">학습그룹ID</label></th>
                                        <td><input type="text" id="lrnGrpId" name="lrnGrpId" class="width-100per" value="<c:out value='${forum2VO.lrnGrpId}'/>"/></td>
                                    </tr>
                                    <tr>
                                        <th><label for="dvclsId">분반ID</label></th>
                                        <td><input type="text" id="dvclsId" name="dvclsId" class="width-100per" value="<c:out value='${forum2VO.dvclsId}'/>"/></td>
                                    </tr>
                                    </tbody>
                                </table>
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
                                            <input class="form-control width-100per" type="text" name="dscsTtl" id="dscsTtl" value='${forum2VO.dscsTtl}' placeholder="이름을 입력하세요" required="true">
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
                                                        <label for="dscsCts" class="hide">Content</label>
                                                        <textarea id="dscsCts" name="dscsCts" required="true"><c:out value="${forum2VO.dscsCts}" /></textarea>
                                                        <script>
                                                            // HTML 에디터
                                                            let editor = UiEditor({
                                                                targetId: "dscsCts",
                                                                uploadPath: "/forum",
                                                                height: "300px"
                                                            });
                                                        </script>
                                                    </div>
                                                </dd>
                                            </dl>
                                        </li>
                                        </section>
                                        <!--//섹션 에디터-->
                                    </td>
                                </tr>
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
                                            <input type="radio" name="dscsUnitTycd" id="dscsUnitTycdN" value="NORMAL" onchange="teamynChange(this.value)" ${empty forum2VO.dscsUnitTycd || forum2VO.dscsUnitTycd ne 'TEAM' ? 'checked' : ''}>
                                            <label for="dscsUnitTycdN">아니오</label>
                                        </span>
                                        <span class="custom-input">
                                            <input type="radio" name="dscsUnitTycd" id="dscsUnitTycdY" value="TEAM" onchange="teamynChange(this.value)" ${forum2VO.dscsUnitTycd eq 'TEAM' ? 'checked' : ''}>
                                            <label for="dscsUnitTycdY">예</label>
                                        </span>
                                        <div id="teamQuizDiv" ${empty forum2VO.dscsGrpId || forum2VO.dscsUnitTycd ne 'TEAM' ? 'style="display:block"' : '' }>
                                            <c:forEach var="list" items="${dvclasList }" varStatus="i">
                                                <div class="form-row" id='lrnGrpView${list.dvclasNo}'>
                                                    <div class="input_btn width-100per">
                                                        <label>${list.dvclasNo }반</label>
                                                        <input type='hidden' id='lrnGrpId${list.dvclasNo}' name='lrnGrpIds' value="${empty list.lrnGrpId ? '' : list.lrnGrpId}:${list.sbjctId}">
                                                        <input class="form-control width-60per" type="text" name="name" id="lrnGrpnm${list.dvclasNo}" placeholder="팀 분류를 선택해 주세요." value="${empty forum2VO.examBscId ? '' : list.lrnGrpnm}" readonly="" autocomplete="off">
                                                        <a class="btn type1 small" onclick="teamGrpChcPopup('${list.dvclasNo}','${list.sbjctId }')">학습그룹지정</a>
                                                    </div>
                                                </div>
                                                <c:if test="${i.count eq 1 }">
                                                    <div class="form-inline">
                                                        <small class="note2">! 구성된 팀이 없는 경우 메뉴 “과목설정 > 학습그룹지정”에서 팀을 생성해 주세요</small>
                                                    </div>
                                                </c:if>
                                                <div class="ui segment" id="setQuizDiv${list.dvclasNo }" style="display:none;">
											        		<span class="custom-input">
															    <input type="checkbox" name="lrnGrpSubasmtStngyns" id="lrnGrpSubasmtStngyn_${list.dvclasNo }"
                                                                       data-bscId="${not empty forum2VO.dscsGrpId && list.lrnGrpSubasmtStngyn eq 'Y' ? list.examBscId : '' }"
                                                                       value="Y:${list.sbjctId }"
                                                                       onchange="lrnGrpSubasmtStngynChange(this)" ${not empty forum2VO.dscsGrpId && list.lrnGrpSubasmtStngyn eq 'Y' ? 'checked' : '' }>
															    <label for="lrnGrpSubasmtStngyn_${list.dvclasNo }">학습그룹별 부 과제 설정</label>
															</span>
                                                    <div id="subInfoDiv${list.dvclasNo }" ${not empty forum2VO.dscsGrpId && list.lrnGrpSubasmtStngyn eq 'Y' ? '' : 'style="display: none;"' }></div>
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
                                                                <input type="radio" name="oknokCfgyn" id="oknokCfgynY" value="N" ${forum2VO.oknokCfgyn eq 'N' ? 'checked' : '' }>
                                                                <label for="oknokCfgynY">아니오</label>
                                                                </span>
                                                            <span class="custom-input ml10">
                                                                <input type="radio" name="oknokCfgyn" id="oknokCfgynN" value="Y" ${forum2VO.oknokCfgyn eq 'Y' || empty forum2VO.oknokCfgyn ? 'checked' : '' }>
                                                                <label for="oknokCfgynN">예</label>
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
    });

    function bindEvents() {
        $('#dscsUnitTycd').on('change', function () {
            toggleTeamArea();
        });

        $('#btnSave').on('click', function () {
            saveForum();
        });

        $('#btnCopy').on('click', function () {
            copyForum();
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
            $('#dscsGrpId').val('');
            $('#lrnGrpId').val('');
            $('#dvclsId').val('');
        }
    }

    // 토론등록/저장
    function saveForum() {
        let validator = UiValidator("forumWriteForm");
        validator.then(function(result) {
            syncAllSwitchHidden();
            syncDiscussionDateTimeFields();
            var registUrl = '<c:url value="/forum2/forumLect/profForumRegist.do" />';
            var modifyUrl = '<c:url value="/forum2/forumLect/profForumModify.do" />';
            var isModifyMode = '${mode}' === 'E';
            var url = isModifyMode ? modifyUrl : registUrl;
            var param = $('#forumWriteForm').serialize();

            UiComm.showLoading(true);
            ajaxCall(url, param, function(data) {
                var result = parseResult(data);
                if (String(result.code) !== '1') {
                    UiComm.showMessage(result.message, "error");
                    return;
                }

                var returnVO = data.returnVO || {};
                if (returnVO.dscsId) {
                    $('#dscsId').val(returnVO.dscsId);
                }
                console.log('1:' + result.message);
                UiComm.showMessage(result.message, "success")
                .then(function(result) {
                    console.log('2:' + result);
                    location.href = '<c:url value="/forum2/forumLect/profForumListView.do" />';
                });
            }, function(xhr, status, error) {
                UiComm.showMessage(error.message, "error");
            });
        });
    }

    function copyForum() {
        var sourceDscssId = $('#sourceDscssId').val() || $('#dscsId').val();
        if (!sourceDscssId) {
            UiComm.showMessage("sourceDscssId가 필요합니다.", "warning");
            return;
        }
        var url = '<c:url value="/forum2/forumLect/profForumCopy.do" />';
        var param = {
            sourceDscssId: sourceDscssId,
            targetCrsId: $('#sbjctId').val(),
            targetDvclsId: $('#dvclsId').val(),
            targetLrnGrpId: $('#lrnGrpId').val(),
            targetDscsGrpId: $('#dscsGrpId').val()
        };

        UiComm.showLoading(true);
        ajaxCall(url, param, function(data) {
            var result = parseResult(data);
            if (String(result.code) !== '1') {
                UiComm.showMessage(result.message, "error");
                return;
            }

            var returnVO = data.returnVO || {};
            if (returnVO.dscsId) {
                location.href = '<c:url value="/forum2/forumLect/profForumWriteView.do" />?dscsId=' + encodeURIComponent(returnVO.dscsId);
                return;
            }
            UiComm.showMessage(result.message, "success");
        }, function(xhr, status, error) {
            UiComm.showMessage(error.message, "error");
        });
    }
</script>
</body>
</html>
