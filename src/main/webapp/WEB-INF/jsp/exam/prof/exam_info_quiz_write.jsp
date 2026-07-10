<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="table,editor,fileuploader"/>
	</jsp:include>

	<script type="text/javascript">
        /* Tabulator 공통 페이징 */
        var PAGE_INDEX = 1;
        var LIST_SCALE = 10;

        var curTabType              = '<c:out value="${vo.tabType}" />';
        var curTkexamMthdCd         = '<c:out value="${vo.tkexamMthdCd}" />';
        var curExamBscId            = '<c:out value="${vo.examBscId}" />';
        var curByteamSubrexamUseyn  = '<c:out value="${vo.byteamSubrexamUseyn}" />';  // 팀 여부

        var exam_sbjctId    = '<c:out value="${examVO.sbjctId}" />';
        var exam_mrkRfltrt  = '<c:out value="${examVO.mrkRfltrt}" />';
        var exam_examGbncd  = '<c:out value="${examVO.examGbncd}" />';
        var exam_exampprOyn = '<c:out value="${examVO.exampprOyn}" />';
        var hasSubSubject   = '<c:out value="${examVO.teamGrpSubsbjctUseyn}" />';  // 부 주제

        var quiz_examBscId  = '<c:out value="${quizVO.examBscId}" />';

        var sbstUserInfoListTable = null;
        var setUrl = "";            // 등록|수정 URL
        var gbn = '${gbn}';         // 과제|퀴즈 판별용
        const editors = {};	        // 에디터 목록 저장용

        /*****************************************************************************
         * 팀 시험일 경우 생성되는 요소 제어 기능
         * 1. examDtlInfoVO 모델 를 JS 배열로 변환
         * 2. examSubAsmtListAppend:    팀 시험 부주제 목록 HTML append
         * 3. getTeamGrpIds:            팀 id 수집
         * 4. getDtlInfos:              주제 수집
         *****************************************************************************/
        /* 1 */
        var examDtlInfoList = [
            <c:forEach var="dtlInfo" items="${examDtlInfoVO}" varStatus="st">
            {
                teamGrpId    : '${fn:escapeXml(dtlInfo.teamGrpId)}',
                teamGrpnm    : '${fn:escapeXml(dtlInfo.teamGrpnm)}',
                teamId      : '${fn:escapeXml(dtlInfo.teamId)}',
                teamnm      : '${fn:escapeXml(dtlInfo.teamnm)}',
                ldrnm       : '${fn:escapeXml(dtlInfo.ldrnm)}',
                examTtl     : '${fn:escapeXml(dtlInfo.examTtl)}',
                examCts     : '${fn:escapeXml(dtlInfo.examCts)}',
                teamMbrTot  : '${fn:escapeXml(dtlInfo.teamMbrTot)}'
            }
            <c:if test="${!st.last}">,</c:if>
            </c:forEach>
        ];
        /* 2 */
        function examSubAsmtListAppend() {
            var html = "";
            if (examDtlInfoList.length > 0) {
                examDtlInfoList.forEach(function(v, i) {
                    html += "<tr>";
                    html += "	<th rowspan='3' class='group-header'><label>" + v.teamnm + "</label></th>";
                    html += "	<th><label><spring:message code='exam.label.team.grp' /> <spring:message code='exam.label.team.members' /></label></th>";   /* 팀 그룹 */ /* 구성원 */
                    html += "	<td>" + v.ldrnm + " <spring:message code='exam.label.and' /> " + (v.teamMbrTot - 1) + "<spring:message code='exam.label.stdnt' /></td>";    /* 외 */ /* 명 */
                    html += "</tr>";
                    html += "<tr>";
                    html += "	<th><label><spring:message code='exam.label.sub.tpc' /></label></th>";  /* 부 주제 */
                    html += "	<td>" + UiComm.escapeHtml(v.examTtl) + "</td>";
                    html += "</tr>";
                    html += "<tr>";
                    html += "	<th><label><spring:message code='exam.label.cts' /></label></th>";  /* 내용 */
                    html += "	<td><pre>" + $("<div>").html(v.examCts).text() + "</pre></td>";
                    html += "</tr>";
                });
            }
            $("#examSubsbjctbody").append(html);
        }
        /* 3 */
        function getTeamGrpIds() {
            var ids = [];
            var seen = {};
            examDtlInfoList.forEach(function(item) {
                if (item.teamGrpId && !seen[item.teamGrpId]) {
                    seen[item.teamGrpId] = true;
                    ids.push(item.teamGrpId + ":" + exam_sbjctId);
                }
            });
            return ids;
        }
        /* 4 */
        function getDtlInfos() {
            var dtlInfos = [];
            examDtlInfoList.forEach(function(item) {
                if (item.teamId) {
                    dtlInfos.push({
                        id:  item.teamId,
                        ttl: item.examTtl || '',
                        cts: item.examCts || ''
                    });
                }
            });
            return JSON.stringify(dtlInfos);
        }

        /*****************************************************************************
         * 버튼 기능
         * 1. registQuizData :          퀴즈 데이터 [등록|수정] AJAX 실행
         * 2. finishUpload :            파일 업로드 완료 콜백 → registQuizData 호출
         * 3. examQuizSaveBtnEvent :    저장 버튼 이벤트 — 파일 업로드 후 등록
         * 4. examQuizRemoveBtnEvent :  퀴즈 삭제 버튼 이벤트 (ajax)
         *****************************************************************************/
        /* 1 */
        function registQuizData() {
            var url = (gbn === '' || gbn == null)
                ? "/exam/examQuizRegist.do"
                : "/exam/examQuizModify.do";

            var quizContents = editors['editor_quiz'].getPublishingHtml();
            var quizSdttm    = UiComm.getDateTimeVal("dateQuizSt", "timeQuizSt") + "00";
            var quizEdttm    = UiComm.getDateTimeVal("dateQuizEd", "timeQuizEd") + "59";

            var formData = {
                examBscId:                  quiz_examBscId ? quiz_examBscId : curExamBscId,
                sbjctId:                    exam_sbjctId,
                tkexamMthdCd:               curTkexamMthdCd,
                examGbncd:                  exam_examGbncd,
                mrkRfltrt:                  exam_mrkRfltrt,
                exampprOyn:                 exam_exampprOyn,
                examTtl:                    $('#quiz-ttl').val(),
                examCts:                    quizContents,
                "examDtlVO.examPsblSdttm":  quizSdttm,
                "examDtlVO.examPsblEdttm":  quizEdttm,
                "examDtlVO.examMnts":       $('#quizMnts').val(),
                mrkRfltyn:                  $('input[name="quiz-mkr-rfltyn-rd"]:checked').val(),
                mrkOyn:                     $('input[name="quiz-mkr-oyn-rd"]:checked').val(),
                qstnDsplyGbncd:             $('input[name="quiz-view-type-rd"]:checked').val(),
                qstnRndmyn:                 $('#quiz-mix-type').is(':checked') ? 'Y' : 'N',
                qstnVwitmRndmyn:            $('#quiz-view-mix-type').is(':checked') ? 'Y' : 'N',
                byteamSubrexamUseyn:        curByteamSubrexamUseyn,
                teamGrpIds:                 getTeamGrpIds(),
                dtlInfos:                   curByteamSubrexamUseyn === 'Y' ? getDtlInfos() : '',
                uploadFiles:                $('#uploadFiles').val(),
                uploadPath:                 $('#uploadPath').val()
            };

            UiComm.showLoading(true);
            $.ajax({
                url:         url,
                async:       false,
                type:        "POST",
                dataType:    "json",
                traditional: true,
                data:        formData
            }).done(function(data) {
                UiComm.showLoading(false);
                if (data.result > 0) {
                    UiComm.showMessage("<spring:message code='exam.alert.insert' />", "info")   /* 정상 저장 되었습니다. */
                        .then(function() {
                            profExamViewMv(5);
                        });
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }).fail(function() {
                UiComm.showLoading(false);
                UiComm.showMessage(
                    gbn !== ''
                        ? "<spring:message code='exam.error.update' />"     /* 수정 중 에러가 발생하였습니다. */
                        : "<spring:message code='exam.error.insert' />",    /* 저장 중 에러가 발생하였습니다. */
                    "error"
                );
            });
        }
        /* 2 */
        function finishUpload() {
            var dx = dx5.get("quizFileUploader");
            ajaxCall("/common/uploadFileCheck.do",
                { uploadFiles: dx.getUploadFiles(), uploadPath: dx.getUploadPath() },
                function(data) {
                    if (data.result > 0) {
                        $("#uploadFiles").val(dx.getUploadFiles());
                        $("#uploadPath").val(dx.getUploadPath());
                        registQuizData();
                    } else {
                        UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
                    }
                },
                function() {
                    UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
                },
                true
            );
        }
        /* 3 */
        function examQuizSaveBtnEvent() {
            $("#examQuizRegistBtn").on("click", function() {
                UiValidator('quiz-write').then(function(result) {
                    if (result) {
                        var dx = dx5.get("quizFileUploader");
                        if (dx && dx.availUpload()) {
                            dx.startUpload();   // 완료 시 finishUpload() 자동 호출
                        } else {
                            finishUpload();     // 신규 파일 없으면 바로 진행
                        }
                    }
                });
            });
        }
        /* 2 */
        function examQuizRemoveBtnEvent() {
            $("#examQuizRemoveBtn").on("click", function() {
                UiComm.showMessage("<spring:message code='exam.confirm.exist.answer.user.del' />?", "confirm")  /* 삭제하시겠습니까? */
                    .then(function(result) {
                        if (result) {

                            var formData = {
                                examBscId:              '${quizVO.examBscId}'
                                , byteamSubrexamUseyn:  curByteamSubrexamUseyn
                            };

                            UiComm.showLoading(true);
                            $.ajax({
                                url:      "/exam/examQuizRemove.do",
                                async:    false,
                                type:     "POST",
                                dataType: "json",
                                data:     formData
                            }).done(function(data) {
                                UiComm.showLoading(false);
                                if (data.result > 0) {
                                    UiComm.showMessage("<spring:message code='exam.alert.delete' />", "info")   /* 정상 삭제 되었습니다. */
                                        .then(function() {
                                            profExamViewMv(5);
                                        });
                                } else {
                                    UiComm.showMessage(data.message, "error");
                                }
                            }).fail(function() {
                                UiComm.showLoading(false);
                                UiComm.showMessage("<spring:message code='exam.error.delete' />", "error");     /* 삭제 중 에러가 발생하였습니다. */
                            });
                        }
                    });
            });
        }

        /* 퀴즈 체크박스 초기값 세팅 */
        function initQuizCheckbox() {
            if ('${quizVO.qstnRndmyn}' === 'Y') {
                $('#quiz-mix-type').trigger('click');
            }
            if ('${quizVO.qstnVwitmRndmyn}' === 'Y') {
                $('#quiz-view-mix-type').trigger('click');
            }
        }


        /*****************************************************************************
         * 팝업 관련 기능
         * 1. quizQstnMngPop:           문항관리 팝업
         * 2. quizExampprPreviewPopup:  퀴즈 시험지 미리보기 팝업
         *****************************************************************************/
        /* 1 */
        function quizQstnMngPop() {
            var data = "examBscId="+quiz_examBscId;

            dialog = UiDialog("dialog1", {
                title: "<spring:message code='exam.label.item'/><spring:message code='exam.label.manage'/>", /* 문항 */ /* 관리 */
                width: 800,
                height: 500,
                url: "/quiz/profQuizQstnMngView.do?"+data,
                autoresize: true
            });
        }
        /* 2 */
        function quizExampprPreviewPopup(examBscId) {
            dialog = UiDialog("dialog1", {
                title		: "<spring:message code='exam.label.quiz' /><spring:message code='exam.label.paper' /> <spring:message code='exam.label.preview' />", /* 퀴즈 */ /* 시험지 */ /* 미리보기 */
                url			: "/quiz/profQuizExampprPreviewPopup.do?examBscId="+examBscId,
                fullscreen	: true
            });
        }

        /*
         * 퀴즈 시험지 미리보기 버튼생성 기능
         */
        function quizPprBtnAppend() {
            var html = "<a href='javascript:quizExampprPreviewPopup(" + "\"" + quiz_examBscId + "\"" + ")' class='btn type1'><spring:message code='exam.label.paper' /> <spring:message code='exam.label.preview' /></a>";    /* 시험지 */ /* 미리보기 */
            $("#quizPpr").append(html);
        }

        $(document).ready(function() {
            if (hasSubSubject == 'Y') {
                examSubAsmtListAppend();
            }

            initQuizCheckbox();
            examQuizRemoveBtnEvent();
            examQuizSaveBtnEvent();
            quizPprBtnAppend();
        });
	</script>
</head>

<body class="class ${uiex:getTheme()} "><!-- 컬러선택시 클래스변경 -->
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
				<!-- class_sub_top -->
				<jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
				<!-- //class_sub_top -->

                <div class="class_sub">
                    <!-- 강의실 상단 -->
                    <jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
                    <!-- 콘텐츠 영역 -->
                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">
                                <spring:message code="exam.label.exam" /><!-- 시험 -->
                            </h2>
                        </div>
                        <!-- 콘텐츠 상단 탭 버튼 영역 -->
                        <div class="listTab">
                            <ul>
                                <!-- 실시간/퀴즈 에 따라 버튼 동적 생성 -->
                                <li class="mw120">
                                    <a onclick="profExamViewMv(1)">
                                        <spring:message code='exam.label.exam' /><!-- 시험 -->
                                        <spring:message code='exam.label.info.score.manage' /><!-- 정보 및 평가 -->
                                    </a>
                                </li>
                                <c:if test="${vo.tkexamMthdCd eq 'RLTM' and (examVO.examGbncd eq 'EXAM_LST'
                                                                            or examVO.examGbncd eq 'EXAM_LST_TEAM'
                                                                            or examVO.examGbncd eq 'EXAM_MID'
                                                                            or examVO.examGbncd eq 'EXAM_MID_TEAM')}">
                                    <li class="mw120">
                                        <a onclick="profExamViewMv(2)">
                                            <spring:message code='exam.label.exam' /> <!-- 시험 -->
                                            <spring:message code='exam.label.sub' /><!-- 대체 -->
                                        </a>
                                    </li>
                                    <li class="mw120">
                                        <a onclick="profExamViewMv(3)">
                                            <spring:message code='exam.label.info.absence' /><!-- 결시 내용 및 현황 -->
                                        </a>
                                    </li>
                                    <li class="mw120">
                                        <a onclick="profExamViewMv(4)">
                                            <spring:message code='exam.label.dsbl' />/<!-- 장애인 -->
                                            <spring:message code='exam.label.snrs' /> <!-- 고령자 -->
                                            <spring:message code='exam.label.support.stts' /><!-- 지원 현황 -->
                                        </a>
                                    </li>
                                </c:if>
                                <c:if test="${vo.tkexamMthdCd eq 'QUIZ'}">
                                    <li class="mw120 select" style = "pointer-events: none;">
                                        <a onclick="profExamViewMv(5)">
                                            <spring:message code='exam.label.subs.quiz.manage' /><!-- 퀴즈 관리 -->
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </div>
                        <!-- 고정 영역 -->
                        <div class="board_top">
                            <i class="icon-svg-openbook"></i>
                            <h3 class="board-title">
                                <spring:message code='exam.label.subs.quiz.manage' /><!-- 퀴즈 관리 -->
                            </h3>
                            <div class="right-area">
                                <button type="button" class="btn basic" onclick="profExamViewMv(8)"><spring:message code='exam.button.list' /></button><!-- 목록 -->
                            </div>
                        </div>
                        <!-- [공통] 시험 정보 영역 -->
                        <!-- accordion -->
                        <div class="elements_wrap">
                            <ul class="accordion">
                                <spring:message code="exam.common.yes" var="yes" /><!-- 예 -->
                                <spring:message code="exam.common.no" var="no" /><!-- 아니오 -->
                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap">
                                        <a class="title" href="#">
                                            <div class="lecture_tit">
                                                <label class="label s_test mr5">${examVO.examGbnnm}</label><strong>${examVO.examTtl}</strong>
                                                <p class="desc">
                                                    <span><strong class="fcBlack">${examVO.tkexamMthdNm}</strong></span>
                                                    <span><spring:message code='exam.button.stare.start' /> <spring:message code='exam.label.period' /> :<strong><uiex:formatDate value="${examVO.examPsblSdttm}" type="datetime2"/> ~ <uiex:formatDate value="${examVO.examPsblEdttm}" type="datetime2"/></strong></span> <!-- 응시 --><!-- 기간 -->
                                                    <span><spring:message code="exam.label.score.aply.y" /><!-- 성적반영 --> :<strong>${examVO.mrkRfltyn eq 'Y' ? yes : no }</strong></span>
                                                    <span><spring:message code="exam.label.score.open.y" /><!-- 성적공개 --> :<strong>${examVO.mrkOyn eq 'Y' ? yes : no }</strong></span>
                                                </p>
                                            </div>
                                            <i class="arrow xi-angle-down"></i>
                                        </a>
                                    </div>
                                    <div class="cont">
                                        <table class="table-type5">
                                            <colgroup>
                                                <col class="width-15per" />
                                                <col class="" />
                                                <col class="width-15per" />
                                                <col class="" />
                                            </colgroup>
                                            <tbody>
                                            <tr>
                                                <th><spring:message code='exam.label.exam.stare.type' /></th><!-- 시험 구분 -->
                                                <td colspan="3">${examVO.examGbnnm}</td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.exam.type' /></th><!-- 시험 유형 -->
                                                <td colspan="3">${examVO.tkexamMthdNm}</td>
                                            </tr>
                                            <c:choose>
                                                <c:when test="${examVO.tkexamMthdCd eq 'RLTM'}">
                                                    <tr>
                                                        <th><spring:message code='exam.label.onln' /> <spring:message code='exam.label.paper' /></th><!-- 온라인 --> <!-- 시험지 -->
                                                        <td colspan="3" id="onlnPpr"></td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr>
                                                        <th><spring:message code='exam.label.quiz' /> <spring:message code='exam.label.paper' /></th><!-- 퀴즈 --> <!-- 시험지 -->
                                                        <td colspan="3" id="quizPpr"></td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
                                            <tr>
                                                <th><spring:message code='exam.label.exam' /> <spring:message code='exam.label.cts' /></th><!-- 시험 --><!-- 내용 -->
                                                <td colspan="3">
                                                    <div class="tb_content">
                                                        ${examVO.examCts}
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.exam' /> <spring:message code='exam.label.dttm' /></th><!-- 시험 --><!-- 일시 -->
                                                <td colspan="3"><uiex:formatDate value="${examVO.examPsblSdttm}" type="datetime2"/> ~ <uiex:formatDate value="${examVO.examPsblEdttm}" type="datetime2"/></td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.exam' /> <spring:message code='exam.label.time' /></th><!-- 시험 --><!-- 시간 -->
                                                <td colspan="3">${examVO.examMnts} <spring:message code='exam.label.min.time' /></td><!-- 분 -->
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.score.aply.y' /></th><!-- 성적 반영 -->
                                                <td>${examVO.mrkRfltyn eq 'Y' ? yes : no}</td>
                                                <th><spring:message code='exam.label.grade.score' /> <spring:message code='exam.label.score.aply.rate' /></th><!-- 성적 --><!-- 반영비율 -->
                                                <td>${examVO.mrkRfltyn eq 'N' ? '-' : examVO.mrkRfltrt} %</td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.score.open.y' /></th><!-- 성적 공개 -->
                                                <td colspan="3">${examVO.mrkOyn eq 'Y' ? yes : no}</td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.paper.open' /></th><!-- 시험지 공개 -->
                                                <td colspan="3">${examVO.exampprOyn eq 'Y' ? yes : no}</td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.team' /> <spring:message code='exam.label.exam' /></th><!-- 팀 --><!-- 시험 -->
                                                <td colspan="3" class="in_table">
                                                    <c:choose>
                                                        <c:when test="${examVO.byteamSubrexamUseyn eq 'Y' and not empty examDtlInfoVO}">
                                                            <div class="view_con">
                                                                    ${yes}<br>
                                                                <spring:message code='exam.label.team.grp' /> : ${examDtlInfoVO[0].teamGrpnm}<br><!-- 팀 그룹 -->
                                                                <spring:message code='exam.label.team.by' /> <spring:message code='exam.label.sub.tpc' /> <spring:message code='exam.label.use.yn' /> : ${examVO.teamGrpSubsbjctUseyn eq 'Y' ? yes : no}<!-- 팀별 --><!-- 부 주제 --><!-- 사용여부 -->
                                                            </div>
                                                            <!-- 팀별 부 주제 사용여부 -->
                                                            <c:if test="${examVO.teamGrpSubsbjctUseyn eq 'Y'}">
                                                                <div class="table-wrap mb30">
                                                                    <table class="table-type5 in-table">
                                                                        <colgroup>
                                                                            <col class="width-5per" />
                                                                            <col class="width-15per" />
                                                                            <col class="" />
                                                                        </colgroup>
                                                                        <tbody id="examSubsbjctbody">
                                                                        </tbody>
                                                                    </table>
                                                                </div>
                                                            </c:if>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="view_con">${no}</div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                            <c:if test="${vo.tkexamMthdCd eq 'RLTM' and (examVO.examGbncd eq 'EXAM_LST'
                                                                            or examVO.examGbncd eq 'EXAM_LST_TEAM'
                                                                            or examVO.examGbncd eq 'EXAM_MID'
                                                                            or examVO.examGbncd eq 'EXAM_MID_TEAM')}">
                                                <tr>
                                                    <th><spring:message code='exam.label.exam' /> <spring:message code='exam.label.sub' /></th><!-- 시험 --><!-- 대체 -->
                                                    <td colspan="3">
                                                        <div class = "item_list">
                                                            ${examVO.examSbstTynm}
                                                            <button type="button" class = "btn basic" onclick="profExamViewMv(2)" style = "pointer-events: none;">
                                                                <spring:message code='exam.label.exam' /> <!-- 시험 -->
                                                                <spring:message code='exam.label.sub' /><!-- 대체 -->
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <!-- 퀴즈 설정 상단영역 -->
                        <div class="board_top mb0">
                            <h4 class="sub-title">[${examVO.examGbnnm}] <spring:message code='exam.label.quiz.set' /></h4><!-- 퀴즈 설정 -->
                            <div class="right-area">
                                <button type="button" id="examQuizRegistBtn" class="btn type2"><spring:message code='exam.button.save' /></button><!-- 저장 -->
                                <c:if test="${not empty gbn}">
                                    <button type="button" id="examQuizRemoveBtn" class="btn type2"><spring:message code='exam.button.del' /></button><!-- 삭제 -->
                                </c:if>
                                <c:if test="${gbn eq 'QUIZ'}">
                                    <button type="button" id ="quiz-mng-btn" class="btn type2" onclick="quizQstnMngPop()" style="${gbn eq 'QUIZ' ? '' : 'display:none;'}">
                                        <spring:message code='exam.label.item'/><!-- 문항 -->
                                        <spring:message code='exam.label.manage'/><!-- 관리 -->
                                    </button>
                                </c:if>
                                <button type="button" class="btn bsc" onclick="profExamViewMv(5)"><spring:message code='exam.button.list' /></button><!-- 목록 -->
                            </div>
                        </div>
                        <!-- 퀴즈관리 form 영역 -->
                        <form id = "quiz-write" name = "quiz-write">
                            <table class = "table-type5">
                                <colgroup>
                                    <col class="width-15per" />
                                    <col class="" />
                                </colgroup>
                                <tbody>
                                    <!-- [퀴즈] 퀴즈명 -->
                                    <tr>
                                        <th>
                                            <label for="quiz-ttl-label" class ="req"><spring:message code="exam.label.quiz" /><spring:message code="exam.label.nm" /></label><!-- 퀴즈 --><!-- 명 -->
                                        </th>
                                        <td>
                                            <div class="form-row">
                                                <input class="form-control width-50per"
                                                       type="text" name="name" id="quiz-ttl" value="${quizVO.examTtl}"
                                                       placeholder="<spring:message code='exam.alert.input.title'/>" required="true" inputmask="byte"
                                                       maxlen="150" autocomplete="off">
                                                        <!-- 제목을 입력하세요. -->
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- [퀴즈] 퀴즈내용 -->
                                    <tr>
                                        <th>
                                            <label for="contTextarea" class = "req"><spring:message code="exam.label.quiz" /><spring:message code="exam.label.cts" /></label><!-- 퀴즈 --><!-- 내용 -->
                                        </th>
                                        <td data-th="입력">
                                            <li>
                                                <dl>
                                                    <dd>
                                                        <div class="editor-box">
                                                            <label for="quizCts" class="hide">Content</label>
                                                            <textarea id="quizCts" name="quizCts" required="true">
                                                                <c:out value="${quizVO.examCts}"/>
                                                            </textarea>
                                                            <script>
                                                                // HTML 에디터
                                                                editors['editor_quiz'] = UiEditor({
                                                                    targetId: "quizCts",
                                                                    uploadPath: "/quiz",
                                                                    height: "400px"
                                                                });
                                                            </script>
                                                        </div>
                                                    </dd>
                                                </dl>
                                            </li>
                                        </td>
                                    </tr>
                                    <!-- [퀴즈] 응시기간 -->
                                    <tr>
                                        <th>
                                            <label for="noticeLabel" class = "req"><spring:message code="exam.button.stare.start" /><spring:message code="exam.label.period" /></label><!-- 응시 --><!-- 기간 -->
                                        </th>
                                        <td>
                                            <div class="date_area">
                                                <input type="text" class="datepicker" id="dateQuizSt" name="dateQuizSt" timeId="timeQuizSt" toDate="dateQuizEd" required="true" placeholder="<spring:message code='exam.label.start.dt'/>" value="${fn:substring(examVO.examPsblSdttm,0,8)}" disabled><!-- 시작일 -->
                                                <input type="text" class="timepicker" id="timeQuizSt" name="timeQuizSt" dateId="dateQuizSt" required="true" placeholder="<spring:message code='exam.label.start.tm'/>" value="${fn:substring(examVO.examPsblSdttm,8,12)}" disabled><!-- 시작시간 -->
                                                <span class="txt-sort">~</span>
                                                <input type="text" class="datepicker" id="dateQuizEd" name="dateQuizEd" timeId="timeQuizEd" fromDate="dateQuizSt" required="true" placeholder="<spring:message code='exam.label.end.dt'/>" value="${fn:substring(examVO.examPsblEdttm,0,8)}" disabled><!-- 종료일 -->
                                                <input type="text" class="timepicker" id="timeQuizEd" name="timeQuizEd" dateId="dateQuizEd" required="true" placeholder="<spring:message code='exam.label.end.tm'/>" value="${fn:substring(examVO.examPsblEdttm,8,12)}" disabled><!-- 종료시간 -->
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- 시험시간 -->
                                    <tr>
                                        <th>
                                            <label for="timeLabel" class = "req"><spring:message code='exam.label.exam.time'/></label><!-- 시험시간 -->
                                        </th>
                                        <td>
                                            <div class="form-row">
                                                <div class="input_btn">
                                                    <input class="form-control sm" id="quizMnts" type="text" inputmask="numeric" maxlength="3" required="true" value="${examVO.examMnts}" disabled><label><spring:message code='exam.label.min.time'/></label><!-- 분 -->
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- [퀴즈] 성적반영 -->
                                    <tr>
                                        <th>
                                            <label for="quiz-mkr-rfltyn-label"><spring:message code="exam.label.score.aply.y" /></label><!-- 성적반영 -->
                                        </th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" name="quiz-mkr-rfltyn-rd" id="quiz-mkr-rfltyn-y-rd" value="Y" ${examVO.mrkRfltyn eq 'Y' ? 'checked' : '' } disabled>
                                                    <label for="quiz-mkr-rfltyn-y-rd"><spring:message code="exam.common.yes" /></label><!-- 예 -->
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" name="quiz-mkr-rfltyn-rd" id="quiz-mkr-rfltyn-n-rd" value="N" ${examVO.mrkRfltyn eq 'N' ? 'checked' : '' } disabled>
                                                    <label for="quiz-mkr-rfltyn-n-rd"><spring:message code="exam.common.no" /></label><!-- 아니오 -->
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- [퀴즈] 성적공개 -->
                                    <tr>
                                        <th>
                                            <label for="quiz-mkr-oyn-label"><spring:message code="exam.label.score.open.y" /></label><!-- 성적공개 -->
                                        </th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" name="quiz-mkr-oyn-rd" id="quiz-mkr-oyn-y-rd" value="Y" ${examVO.mrkOyn eq 'Y' ? 'checked' : '' } disabled>
                                                    <label for="quiz-mkr-oyn-y-rd"><spring:message code="exam.common.yes" /></label><!-- 예 -->
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" name="quiz-mkr-oyn-rd" id="quiz-mkr-oyn-n-rd" value="N" ${examVO.mrkOyn eq 'N' ? 'checked' : '' } disabled>
                                                    <label for="quiz-mkr-oyn-n-rd"><spring:message code="exam.common.no" /></label><!-- 아니오 -->
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- [퀴즈] 문제표시방식 -->
                                    <tr>
                                        <th>
                                            <label for="quiz-view-type-label"><spring:message code="exam.label.type.view.qstn" /></label><!-- 문제 표시방식 -->
                                        </th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" name="quiz-view-type-rd" id="quiz-view-type-all-rd" value="WHOL" ${quizVO.qstnDsplyGbncd eq 'WHOL' || empty gbn ? 'checked' : '' }>
                                                    <label for="quiz-view-type-all-rd"><spring:message code="exam.label.all.view.qstn" /></label><!-- 전체 문제표시 -->
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" name="quiz-view-type-rd" id="quiz-view-type-one-rd" value="EACH" ${quizVO.qstnDsplyGbncd eq 'EACH' ? 'checked' : '' }>
                                                    <label for="quiz-view-type-one-rd"><spring:message code="exam.label.each.view.qstn" /></label><!-- 페이지별로 1문제씩 표시 -->
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- [퀴즈] 문제 섞기 -->
                                    <tr>
                                        <th>
                                            <label for="quiz-mix-type-label" class = "req"><spring:message code="exam.label.qstn.random" /></label><!-- 문제 섞기 -->
                                        </th>
                                        <td>
                                            <div class="form-row">
                                                <input type="checkbox" id="quiz-mix-type" class="switch yesno">
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- [퀴즈] 보기 섞기 -->
                                    <tr>
                                        <th>
                                            <label for="quiz-view-mix-type-label" class = "req"><spring:message code="exam.label.empl.random" /></label><!-- 보기 섞기 -->
                                        </th>
                                        <td>
                                            <div class="form-row">
                                                <input type="checkbox" id="quiz-view-mix-type" class="switch yesno">
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- [퀴즈] 첨부파일 -->
                                    <tr>
                                        <th>
                                            <label for="quiz-sbmsn-atfl-label"><spring:message code="exam.label.file" /></label><!-- 첨부파일 -->
                                        </th>
                                        <td>
                                            <uiex:dextuploader
                                                id="quizFileUploader"
                                                path="${examVO.uploadPath}"
                                                limitCount="5"
                                                limitSize="100"
                                                oneLimitSize="100"
                                                listSize="3"
                                                fileList="${quizVO.fileList}"
                                                finishFunc="finishUpload()"
                                                allowedTypes="*"
                                            />
                                            <input type="hidden" id="uploadFiles" name="uploadFiles"/>
                                            <input type="hidden" id="uploadPath"  name="uploadPath" value="${examVO.uploadPath}"/>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>
                    </div>
                </div>
            </div>
            <!-- //content -->
        </main>
        <!-- //classroom-->
    </div>
</body>
</html>
