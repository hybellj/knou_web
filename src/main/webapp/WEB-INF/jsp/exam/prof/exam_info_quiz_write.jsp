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

        var curTabType   = '${vo.tabType}';
        var curTkexamMthdCd = '${vo.tkexamMthdCd}';

        var curExamBscId = '${vo.examBscId}';
        var curSbjctId = '${examVO.sbjctId}';
        var curMrkRfltrt = '${examVO.mrkRfltrt}';
        var curExamGbncd = '${examVO.examGbncd}';

        var curExamEvlSbstId = '${quizVO.examEvlSbstId}';
        var curAsmtId = '${quizVO.asmtId}';
        var curQuizId = '${quizVO.examBscId}';
        var curExamGrpId = '${quizVO.examGrpId}';

        var curByteamSubrexamUseyn = '${vo.byteamSubrexamUseyn}';   // 팀 여부
        var hasSubSubject = '${examVO.lrnGrpSubsbjctUseyn}';        // 부 주제
        var sbstUserInfoListTable = null;
        var setUrl = "";            // 등록|수정 URL
        var gbn = '${gbn}';         // 과제|퀴즈 판별용
        const editors = {};	        // 에디터 목록 저장용

        /*****************************************************************************
         * 아코디언 관련 기능
         * 1. setAccordion :    아코디언 기능 주입
         * 2. eventAccordion :  아코디언 이벤트 로직
         *****************************************************************************/
        /* 1 */
        function setAccordion() {
            $(".accordion").accordion();
        }
        /* 2 */
        function eventAccordion() {
            const title = document.querySelector('.accordion .title');
            document.querySelector('.accordion .title').addEventListener('click', () => {
                const content = title.nextElementSibling;
                content.classList.toggle('hide');
            });
        }

        /*****************************************************************************
         * 팀 시험일 경우 생성되는 요소 제어 기능
         * 1. examDtlInfoVO 모델 를 JS 배열로 변환
         * 2. 팀 시험 부주제 목록 HTML append
         *****************************************************************************/
        /* 1 */
        var examDtlInfoList = [
            <c:forEach var="dtlInfo" items="${examDtlInfoVO}" varStatus="st">
            {
                lrnGrpId    : '${fn:escapeXml(dtlInfo.lrnGrpId)}',
                lrnGrpnm    : '${fn:escapeXml(dtlInfo.lrnGrpnm)}',
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
                    html += "	<th>" + v.lrnGrpnm + "</th>";
                    html += "	<td>";
                    html += "		<table class='table-type2'>";
                    html += "			<colgroup>";
                    html += "				<col class='width-10per' />";
                    html += "				<col class='' />";
                    html += "			</colgroup>";
                    html += "			<tbody>";
                    html += "				<tr>";
                    html += "					<th>주제</th>";
                    html += "					<td class='t_left'>" + v.examTtl + "</td>";
                    html += "				</tr>";
                    html += "				<tr>";
                    html += "					<th>내용</th>";
                    html += "					<td class='t_left'><pre>" + $("<div>").html(v.examCts).text() + "</pre></td>";
                    html += "				</tr>";
                    html += "			</tbody>";
                    html += "		</table>";
                    html += "	</td>";
                    html += "	<td>" + v.ldrnm + " 외 " + (v.teamMbrTot - 1) + " 명" +"</td>";
                    html += "</tr>";
                });
            }
            $("#examSubsbjctbody").append(html);
        }

        /*****************************************************************************
         * form 요소 제어 함수
         * 1. eventSbstTypeRd :     시험 대체 유형 라디오 버튼 change 이벤트
         * 2. initQuizCheckbox:     퀴즈 체크박스 초기값 세팅
         * 3. eventFlMmTycdRd :     제출파일 유형 라디오 change 이벤트
         * 4. initFlMmTycdRd :      quizVO.sbmsnFileMimeTycd 값 기반 라디오/체크박스 초기값 세팅
         *****************************************************************************/
        /* 1 */
        function eventSbstTypeRd() {
            $('input[name="sbst-type-rd"]').on('change', function() {
                if ($(this).val() === 'SBST_ASMT') {
                    $('#asmt-write').show();
                    $('#quiz-write').hide();
                    $('#quiz-mng-btn').hide();
                } else {
                    $('#quiz-write').show();
                    $('#asmt-write').hide();
                    $('#quiz-mng-btn').show();
                }
            });
        }
        /* 2 */
        function initQuizCheckbox() {
            if ('${quizVO.qstnRndmyn}' === 'Y') {
                $('#quiz-mix-type').trigger('click');
            }
            if ('${quizVO.qstnVwitmRndmyn}' === 'Y') {
                $('#quiz-view-mix-type').trigger('click');
            }
        }
        /* 3 */
        function eventFlMmTycdRd() {
            var $prvCheckboxArea   = $('#tycd-prv');
            var $spcfcCheckboxArea = $('#tycd-spcfc');

            $('input[name="asmt-sbasmt-fl-mm-tycd-rd"]').on('change', function() {
                var val = $(this).val();

                if (val === 'ALL') {
                    $prvCheckboxArea.hide().find('input[type="checkbox"]').prop('checked', false);
                    $spcfcCheckboxArea.hide().find('input[type="checkbox"]').prop('checked', false);
                } else if (val === 'PRVIEW') {
                    $prvCheckboxArea.show();
                    $spcfcCheckboxArea.hide().find('input[type="checkbox"]').prop('checked', false);
                } else if (val === 'SPECIFIC') {
                    $spcfcCheckboxArea.show();
                    $prvCheckboxArea.hide().find('input[type="checkbox"]').prop('checked', false);
                }
            });

            // 초기 상태 반영 (현재 선택된 radio 기준)
            $('input[name="asmt-sbasmt-fl-mm-tycd-rd"]:checked').trigger('change');
        }
        /* 4 */
        function initFlMmTycdRd() {
            var savedVal = '${quizVO.sbmsnFileMimeTycd}';
            if (!savedVal) return;

            var prvValues   = ['img', 'pdf', 'txt', 'exe'];
            var spcfcValues = ['HWP', 'DOC', 'PPT', 'XLS'];
            var savedList   = savedVal.split(',');

            // 저장된 값이 어느 그룹에 속하는지 판별
            var hasPrv   = savedList.some(function(v) { return prvValues.indexOf(v)   !== -1; });
            var hasSpcfc = savedList.some(function(v) { return spcfcValues.indexOf(v) !== -1; });

            var radioVal = hasPrv ? 'PRVIEW' : (hasSpcfc ? 'SPECIFIC' : null);
            if (!radioVal) return;

            // 라디오 선택 후 change 이벤트 발생 (영역 show/hide 처리)
            $('input[name="asmt-sbasmt-fl-mm-tycd-rd"][value="' + radioVal + '"]')
                .prop('checked', true)
                .trigger('change');

            // 해당하는 체크박스 체크
            savedList.forEach(function(v) {
                $('#' + v).prop('checked', true);
            });
        }

        /*****************************************************************************
         * 버튼 기능
         * 1. examQuizSaveBtnEvent :    퀴즈 데이터 [등록|수정] 버튼 이벤트 (ajax)
         * 2. examSbstDeleteBtnEvent :  퀴즈 삭제 버튼 이벤트 (ajax)
         *****************************************************************************/
        /* 1 */
        function examQuizSaveBtnEvent() {
            $("#quizWriteSave").on("click", function() {

                var validator = UiValidator('quiz-write');

                validator.then(function(result) {
                    if (result) {
                        // 등록|수정 URL
                        var url = (gbn === '' || gbn == null)
                            ? "/exam/examSbstRegist.do"
                            : "/exam/examSbstModify.do";

                        // [퀴즈] form 데이터
                        var quizContents = editors['editor_quiz'].getPublishingHtml();
                        var quizSdttm    = UiComm.getDateTimeVal("dateQuizSt", "timeQuizSt") + "00";
                        var quizEdttm    = UiComm.getDateTimeVal("dateQuizEd", "timeQuizEd") + "59";

                        // 공통 데이터
                        var formData = {
                            examBscId:      curQuizId ? curQuizId : curExamBscId,
                            asmtId:         curAsmtId,
                            examEvlSbstId:  curExamEvlSbstId,
                            sbjctId:        curSbjctId,
                            examGbncd:      curExamGbncd,
                            mrkRfltrt:      curMrkRfltrt,
                            examGrpId:      curExamGrpId,
                            examSbstTycd:   'QUIZ',
                            examTtl:        $('#quiz-ttl').val(),
                            examCts:        quizContents,
                            examPsblSdttm:  quizSdttm,
                            examPsblEdttm:  quizEdttm,
                            examMnts:       $('#quizMnts').val(),
                            mrkRfltyn:      $('input[name="quiz-mkr-rfltyn-rd"]:checked').val(),
                            mrkOyn:         $('input[name="quiz-mkr-oyn-rd"]:checked').val(),
                            qstnDsplyGbncd: $('input[name="quiz-view-type-rd"]:checked').val(),
                            qstnRndmyn:     $('#quiz-mix-type').is(':checked') ? 'Y' : 'N',
                            qstnVwitmRndmyn: $('#quiz-view-mix-type').is(':checked') ? 'Y' : 'N'
                        };

                        UiComm.showLoading(true);
                        $.ajax({
                            url:      url,
                            async:    false,
                            type:     "POST",
                            dataType: "json",
                            data:     formData
                        }).done(function(data) {
                            UiComm.showLoading(false);
                            if (data.result > 0) {
                                UiComm.showMessage("저장되었습니다.", "info")
                                    .then(function() {
                                        examViewMv(5);
                                    });
                            } else {
                                UiComm.showMessage(data.message, "error");
                            }
                        }).fail(function() {
                            UiComm.showLoading(false);
                            UiComm.showMessage(
                                gbn !== ''
                                    ? "<spring:message code='exam.error.update' />"
                                    : "<spring:message code='exam.error.insert' />",
                                "error"
                            );
                        });
                        console.log(formData);
                    }
                });
            });
        }
        /* 2 */
        function examSbstDeleteBtnEvent() {
            $("#sbstWriteDelete").on("click", function() {
                UiComm.showMessage("삭제하시겠습니까?", "confirm")
                    .then(function(result) {
                        if (result) {
                            var selectedSbstType = $('input[name="sbst-type-rd"]:checked').val();

                            var formData = {
                                examEvlSbstId:      curExamEvlSbstId
                                , examSbstTycd:     selectedSbstType
                                , quizBscId:        '${quizVO.examBscId}'
                                , examGrpId:        '${quizVO.examGrpId}'
                                , examBscId:        curExamBscId
                            };

                            UiComm.showLoading(true);
                            $.ajax({
                                url:      "/exam/examSbstDelete.do",
                                async:    false,
                                type:     "POST",
                                dataType: "json",
                                data:     formData
                            }).done(function(data) {
                                UiComm.showLoading(false);
                                if (data.result > 0) {
                                    UiComm.showMessage("삭제되었습니다.", "info")
                                        .then(function() {
                                            examViewMv(5);
                                        });
                                } else {
                                    UiComm.showMessage(data.message, "error");
                                }
                            }).fail(function() {
                                UiComm.showLoading(false);
                                UiComm.showMessage("<spring:message code='exam.error.delete' />", "error");
                            });
                            console.log(formData);
                        }
                    });
            });
        }

        /**
         * 시험 화면 이동
         * @param {String}  examBscId           - 시험 기본 ID
         * @param {String}  tkexamMthdCd        - 시험 구분 [RLTM|QUIZ]
         * @param {String}  byteamSubrexamUseyn - 팀 시험여부
         * @param {Integer} tab                 - 탭 번호
         */
        function examViewMv(tab) {
            var urlMap = {
                "1" : "/exam/profExamInfoEvlView.do",   // 시험 상세 [시험 정보 및 평가 탭]
                "2" : "/exam/profExamSbstView.do",      // 시험 상세 [시험 대체 탭]
                "3" : "/exam/profExamAbsnceView.do",    // 시험 상세 [결시 내용 및 현황 탭]
                "4" : "/exam/profExamDsblView.do",      // 시험 상세 [장애인/고령자 지원 현황 탭]
                "5" : "/exam/profExamQuizMngView.do",   // 시험 상세 [퀴즈 관리 탭]
                "8" : "/exam/profExamListView.do",      // 시험 목록
                "9" : "/exam/profExamWriteView.do"      // 시험 [등록|수정] 화면
            };

            var kvArr = [];

            kvArr.push({'key' : 'examBscId',          'val' : '${vo.examBscId}'});
            kvArr.push({'key' : 'tkexamMthdCd',       'val' : '${vo.tkexamMthdCd}'});
            kvArr.push({'key' : 'byteamSubrexamUseyn','val' : '${vo.byteamSubrexamUseyn}'});
            kvArr.push({'key' : 'tabType',            'val' : tab});
            kvArr.push({'key' : 'isModify',           'val' : 'Y'});
            kvArr.push({'key' : 'sbjctId',            'val' : '${sbjctId}'});
            submitForm(urlMap[tab], "", "", kvArr);
        }

        /* 문항관리 팝업 */
        function quizQstnMngPop() {
            var data = "examBscId="+curQuizId;

            dialog = UiDialog("dialog1", {
                title: "응시현황",
                width: 800,
                height: 500,
                url: "/quiz/profQuizQstnMngView.do?"+data,
                autoresize: true
            });
        }


        $(document).ready(function() {

            setAccordion();
            eventAccordion();

            if (hasSubSubject == 'Y') {
                examSubAsmtListAppend();
            }

            initQuizCheckbox();
            eventSbstTypeRd();
            eventFlMmTycdRd();
            initFlMmTycdRd();
            examSbstDeleteBtnEvent();
            examQuizSaveBtnEvent();
        });
	</script>
</head>

<body class="class colorA "><!-- 컬러선택시 클래스변경 -->
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
                <div class="class_sub_top">
                    <div class="navi_bar">
                        <ul>
                            <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                            <li>강의실</li>
                            <li><span class="current">시험</span></li>
                        </ul>
                    </div>
                    <div class="btn-wrap">
                        <div class="first">
                            <select class="form-select">
                                <option value="2025년 2학기">2025년 2학기</option>
                                <option value="2025년 1학기">2025년 1학기</option>
                            </select>
                            <select class="form-select wide">
                                <option value="">강의실 바로가기</option>
                                <option value="2025년 2학기">2025년 2학기</option>
                                <option value="2025년 1학기">2025년 1학기</option>
                            </select>
                        </div>
                        <div class="sec">
                            <button type="button" class="btn type1"><i class="xi-book-o"></i>교수 매뉴얼</button>
                            <button type="button" class="btn type1"><i class="xi-info-o"></i>학습안내정보</button>
                        </div>
                    </div>
                </div>

                <div class="class_sub">
                    <!-- 강의실 상단 -->
                    <div class="segment class-area">
                        <div class="info-left">
                            <div class="class_info">
                                <h2>데이터베이스의 이해와 활용 1반</h2>
                                <div class="classSection">
                                    <div class="cls_btn">
                                        <a href="#0" class="btn">강의계획서</a>
                                        <a href="#0" class="btn">학습진도관리</a>
                                        <a href="#0" class="btn">평가기준</a>
                                    </div>
                                </div>
                            </div>
                            <div class="info-cnt">
                                <div class="info_iconSet">
                                    <a href="#0" class="info"><span>공지</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>Q&A</span><div class="num_txt point">17</div></a>
                                    <a href="#0" class="info"><span>1:1</span><div class="num_txt point">3</div></a>
                                    <a href="#0" class="info"><span>과제</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>토론</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>세미나</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>퀴즈</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>설문</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>시험</span><div class="num_txt">2</div></a>
                                </div>
                                <div class="info-set">
                                    <div class="info">
                                        <p class="point"><span class="tit">중간고사:</span><span>2025.04.26 16:00</span></p>
                                        <p class="desc"><span class="tit">시간:</span><span>40분</span></p>
                                    </div>
                                    <div class="info">
                                        <p class="point"><span class="tit">기말고사:</span><span>2025.07.26 16:00</span></p>
                                        <p class="desc"><span class="tit">시간:</span><span>40분</span></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="info-right">
                            <div class="flex">
                                <div class="item week">
                                    <div class="item_icon"><i class="icon-svg-calendar-check-02" aria-hidden="true"></i></div>
                                    <div class="item_tit">2025.04.14 ~ 04.20</div>
                                    <div class="item_info"><span class="big">7</span><span class="small">주차</span></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 콘텐츠 영역 -->
                    <div class="box span-2 subject">
                        <div class="box_content">
                            <div class="sub-content">
                                <!-- 콘텐츠 상단 탭 버튼 영역 -->
                                <div class="listTab">
                                    <ul>
                                        <!-- 실시간/퀴즈 에 따라 버튼 동적 생성 -->
                                        <li class="mw120"><a onclick="examViewMv(1)">시험정보 및 평가</a></li>
                                        <c:if test="${vo.tkexamMthdCd eq 'RLTM' and (examVO.examGbncd eq 'EXAM_LST'
                                                                                    or examVO.examGbncd eq 'EXAM_LST_TEAM'
                                                                                    or examVO.examGbncd eq 'EXAM_MID'
                                                                                    or examVO.examGbncd eq 'EXAM_MID_TEAM')}">
                                            <li class="mw120"><a onclick="examViewMv(2)">시험 대체</a></li>
                                            <li class="mw120"><a onclick="examViewMv(3)">결시 내용 및 현황</a></li>
                                            <li class="mw120"><a onclick="examViewMv(4)">장애인/고령자 지원 현황</a></li>
                                        </c:if>
                                        <c:if test="${vo.tkexamMthdCd eq 'QUIZ'}">
                                            <li class="mw120 select" style = "pointer-events: none;"><a onclick="examViewMv(5)">퀴즈 관리</a></li>
                                        </c:if>
                                    </ul>
                                </div>
                                <!-- 고정 영역 -->
                                <div class="board_top">
                                    <i class="icon-svg-openbook"></i>
                                    <h3 class="board-title">퀴즈 관리</h3>
                                    <div class="right-area">
                                        <button type="button" class="btn basic" onclick="examViewMv(8)">목록</button>
                                    </div>
                                </div>
                                <!-- [공통] 시험 정보 영역 -->
                                <div class="accordion">
                                    <div class="title flex">
                                        <div class="title_cont">
                                            <div class="left_cont">
                                                <div class="lectTit_box">
                                                    <spring:message code="exam.common.yes" var="yes" /><!-- 예 -->
                                                    <spring:message code="exam.common.no" var="no" /><!-- 아니오 -->
                                                    <!-- 날짜 포맷 -->
                                                    <fmt:parseDate var="psblSdttmFmt" pattern="yyyyMMddHHmmss" value="${examVO.examPsblSdttm}" />
                                                    <fmt:formatDate var="examPsblSdttm" pattern="yyyy.MM.dd HH:mm" value="${psblSdttmFmt }" />
                                                    <fmt:parseDate var="psblEdttmFmt" pattern="yyyyMMddHHmmss" value="${examVO.examPsblEdttm}" />
                                                    <fmt:formatDate var="examPsblEdttm" pattern="yyyy.MM.dd HH:mm" value="${psblEdttmFmt }" />
                                                    <p class="lect_name"><strong>${examVO.examGbnnm}</strong></p>
                                                    <span class="fcGrey">
                                                        <strong>${examVO.examTtl}</strong> |
                                                        <small>${examVO.tkexamMthdNm}</small> |
                                                        <small>응시 기간 : ${examPsblSdttm} ~ ${examPsblEdttm}</small> |
                                                        <small><spring:message code="exam.label.score.aply.y" /><!-- 성적반영 --> : ${examVO.mrkRfltyn eq 'Y' ? yes : no }</small> |
                                                        <small><spring:message code="exam.label.score.open.y" /><!-- 성적공개 --> : ${examVO.mrkOyn eq 'Y' ? yes : no }</small>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <i class="dropdown icon ml20"></i>
                                    </div>
                                    <div class="content" style="padding:0;">
                                        <!--table-type-->
                                        <div class="table-wrap">
                                            <table class="table-type2">
                                                <colgroup>
                                                    <col class="width-20per" />
                                                    <col class="" />
                                                </colgroup>
                                                <tbody>
                                                    <tr>
                                                        <th><label>시험 구분</label></th>
                                                        <td class="t_left" colspan="3"><pre>${examVO.examGbnnm}</pre></td>
                                                    </tr>
                                                    <tr>
                                                        <th><label>시험 방식</label></th>
                                                        <td class="t_left" colspan="3"><pre>${examVO.tkexamMthdNm}</pre></td>
                                                    </tr>
                                                    <tr>
                                                        <th><label>시험 내용</label></th>
                                                        <td class="t_left" colspan="3"><pre>${examVO.examCts}</pre></td>
                                                    </tr>
                                                    <tr>
                                                        <th><label>시험 일시</label></th>
                                                        <td class="t_left" colspan="3"><pre>${examPsblSdttm} ~ ${examPsblEdttm}</pre></td>
                                                    </tr>
                                                    <tr>
                                                        <th><label>시험 시간</label></th>
                                                        <td class="t_left" colspan="3"><pre>${examVO.examMnts} 분</pre></td>
                                                    </tr>
                                                    <tr>
                                                        <th><label>성적 반영</label></th>
                                                        <td class="t_left"><pre>${examVO.mrkRfltyn eq 'Y' ? yes : no}</pre></td>
                                                        <th><label>성적 반영비율</label></th>
                                                        <td class="t_left"><pre>${examVO.mrkRfltyn eq 'N' ? '-' : examVO.mrkRfltrt} %</pre></td>
                                                    </tr>
                                                    <tr>
                                                        <th><label>성적 공개</label></th>
                                                        <td class="t_left" colspan="3"><pre>${examVO.mrkOyn eq 'Y' ? yes : no}</pre></td>
                                                    </tr>
                                                    <tr>
                                                        <th><label>시험지 공개</label></th>
                                                        <td class="t_left" colspan="3"><pre>${examVO.exampprOyn eq 'Y' ? yes : no}</pre></td>
                                                    </tr>
                                                    <tr>
                                                        <th><label>팀 시험</label></th>
                                                        <td class="t_left" colspan="3">
                                                            <pre>${examVO.byteamSubrexamUseyn eq 'Y' ? yes : no}</pre>
                                                            <!-- 팀 시험인 경우 -->
                                                            <c:if test = "${examVO.byteamSubrexamUseyn eq 'Y' and not empty examDtlInfoVO}">
                                                                <pre>학습그룹 : ${examDtlInfoVO[0].lrnGrpnm}</pre>
                                                                <pre>팀별 부 주제 사용여부 : ${examVO.lrnGrpSubsbjctUseyn eq 'Y' ? yes : no}</pre>
                                                                <c:if test="${examVO.lrnGrpSubsbjctUseyn eq 'Y'}">
                                                                    <table class="table-type2">
                                                                        <colgroup>
                                                                            <col class="width-10per" />
                                                                            <col class="" />
                                                                            <col class="width-20per" />
                                                                        </colgroup>
                                                                        <tbody id="examSubsbjctbody">
                                                                        <tr>
                                                                            <th><label>팀</label></th>
                                                                            <th><label>부주제 + 내용</label></th>
                                                                            <th><label>학습그룹 구성원</label></th>
                                                                        </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </c:if>
                                                            </c:if>
                                                        </td>
                                                    </tr>
                                                    <c:if test="${vo.tkexamMthdCd eq 'RLTM' and (examVO.examGbncd eq 'EXAM_LST'
                                                                                                or examVO.examGbncd eq 'EXAM_LST_TEAM'
                                                                                                or examVO.examGbncd eq 'EXAM_MID'
                                                                                                or examVO.examGbncd eq 'EXAM_MID_TEAM')}">
                                                        <tr>
                                                            <th><label>시험 대체</label></th>
                                                            <td class="t_left" colspan="3">
                                                                <div class = "item_list">
                                                                    ${examVO.examSbstTynm}
                                                                    <button type="button" class = "btn basic" onclick="examViewMv(2)" style = "pointer-events: none;">시험 대체</button>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th><label>결시 현황</label></th>
                                                            <td class="t_left" colspan="3">
                                                                <div class = "item_list">
                                                                    ${examVO.absnceTot} 명
                                                                    <button type="button" class = "btn basic" onclick="examViewMv(3)">결시 내용 및 현황</button>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th><label>장애인/고령자 지원</label></th>
                                                            <td class="t_left" colspan="3">
                                                                <div class = "item_list">
                                                                    ${examVO.dsblTot} 명
                                                                    <button type="button" class = "btn basic" onclick="examViewMv(4)">장애인/고령자 지원</button>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:if>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                                <!-- 퀴즈 설정 상단영역 -->
                                <div class="board_top margin-top-4 padding-2">
                                    <h4>[${examVO.examGbnnm}] 퀴즈 설정</h4>
                                    <div class="right-area">
                                        <button type="button" id="quizWriteSave" class="btn type2">저장</button>
                                        <c:if test="${not empty gbn}">
                                            <button type="button" id="sbstWriteDelete" class="btn type2">삭제</button>
                                        </c:if>
                                        <c:if test="${gbn eq 'QUIZ'}">
                                            <button type="button" id ="quiz-mng-btn" class="btn type2" onclick="quizQstnMngPop()" style="${gbn eq 'QUIZ' ? '' : 'display:none;'}">문항관리</button>
                                        </c:if>
                                        <button type="button" class="btn bsc" onclick="examViewMv(5)">목록</button>
                                    </div>
                                </div>
                                <table class = "table-type5" style="display: none">
                                    <colgroup>
                                        <col class="width-15per" />
                                        <col class="" />
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                            <th>
                                            </th>
                                            <td>
                                                <div class="form-row">
                                                    <span class="custom-input ml5">
                                                        <input type="radio" name="sbst-type-rd" id="sbst-type-quiz-rd" value="QUIZ" checked="">
                                                        <label for="sbst-type-quiz-rd">퀴즈</label>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                                <!-- 퀴즈관리 form 영역 -->
                                <form id = "quiz-write" name = "quiz-write">
                                    <table class = "table-type5">
                                        <colgroup>
                                            <col class="width-15per" />
                                            <col class="" />
                                        </colgroup>
                                        <!-- input 입력 폼 (id 전부 db에 맞게 변경해야 함) -->
                                        <tbody>
                                            <!-- [퀴즈] 퀴즈명 -->
                                            <tr>
                                                <th>
                                                    <label for="quiz-ttl-label" class ="req">퀴즈명</label>
                                                </th>
                                                <td>
                                                    <div class="form-row">
                                                        <input class="form-control width-50per"
                                                               type="text" name="name" id="quiz-ttl" value="${quizVO.examTtl}"
                                                               placeholder="퀴즈명을 입력하세요." required="true" inputmask="byte"
                                                               maxlen="150" autocomplete="off">
                                                    </div>
                                                </td>
                                            </tr>
                                            <!-- [퀴즈] 퀴즈내용 -->
                                            <tr>
                                                <th>
                                                    <label for="contTextarea" class = "req">퀴즈내용</label>
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
                                                    <label for="noticeLabel" class = "req">응시기간</label>
                                                </th>
                                                <td>
                                                    <div class="date_area">
                                                        <input type="text" class="datepicker" id="dateQuizSt" name="dateQuizSt" timeId="timeQuizSt" toDate="dateQuizEd" required="true" placeholder="시작일" value="${fn:substring(quizVO.examPsblSdttm,0,8)}">
                                                        <input type="text" class="timepicker" id="timeQuizSt" name="timeQuizSt" dateId="dateQuizSt" required="true" placeholder="시작시간" value="${fn:substring(quizVO.examPsblSdttm,8,12)}">
                                                        <span class="txt-sort">~</span>
                                                        <input type="text" class="datepicker" id="dateQuizEd" name="dateQuizEd" timeId="timeQuizEd" fromDate="dateQuizSt" required="true" placeholder="종료일" value="${fn:substring(quizVO.examPsblEdttm,0,8)}">
                                                        <input type="text" class="timepicker" id="timeQuizEd" name="timeQuizEd" dateId="dateQuizEd" required="true" placeholder="종료시간" value="${fn:substring(quizVO.examPsblEdttm,8,12)}">
                                                    </div>
                                                </td>
                                            </tr>
                                            <!-- 시험시간 -->
                                            <tr>
                                                <th>
                                                    <label for="timeLabel" class = "req">시험시간</label>
                                                </th>
                                                <td>
                                                    <div class="form-row">
                                                        <div class="input_btn">
                                                            <input class="form-control sm" id="quizMnts" type="text" inputmask="numeric" maxlength="3" required="true" value="${quizVO.examMnts}"><label>분</label>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <!-- [퀴즈] 성적반영 -->
                                            <tr>
                                                <th>
                                                    <label for="quiz-mkr-rfltyn-label">성적반영</label>
                                                </th>
                                                <td>
                                                    <div class="form-inline">
                                                        <span class="custom-input">
                                                            <input type="radio" name="quiz-mkr-rfltyn-rd" id="quiz-mkr-rfltyn-y-rd" value="Y" ${quizVO.mrkRfltyn eq 'Y' || empty gbn ? 'checked' : '' }>
                                                            <label for="quiz-mkr-rfltyn-y-rd">예</label>
                                                        </span>
                                                        <span class="custom-input ml5">
                                                            <input type="radio" name="quiz-mkr-rfltyn-rd" id="quiz-mkr-rfltyn-n-rd" value="N" ${quizVO.mrkRfltyn eq 'N' ? 'checked' : '' }>
                                                            <label for="quiz-mkr-rfltyn-n-rd">아니오</label>
                                                        </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <!-- [퀴즈] 성적공개 -->
                                            <tr>
                                                <th>
                                                    <label for="quiz-mkr-oyn-label">성적공개</label>
                                                </th>
                                                <td>
                                                    <div class="form-inline">
                                                        <span class="custom-input">
                                                            <input type="radio" name="quiz-mkr-oyn-rd" id="quiz-mkr-oyn-y-rd" value="Y" ${quizVO.mrkOyn eq 'Y' || empty gbn ? 'checked' : '' }>
                                                            <label for="quiz-mkr-oyn-y-rd">예</label>
                                                        </span>
                                                        <span class="custom-input ml5">
                                                            <input type="radio" name="quiz-mkr-oyn-rd" id="quiz-mkr-oyn-n-rd" value="N" ${quizVO.mrkOyn eq 'N' ? 'checked' : '' }>
                                                            <label for="quiz-mkr-oyn-n-rd">아니오</label>
                                                        </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <!-- [퀴즈] 문제표시방식 -->
                                            <tr>
                                                <th>
                                                    <label for="quiz-view-type-label">문제표시방식</label>
                                                </th>
                                                <td>
                                                    <div class="form-inline">
                                                        <span class="custom-input">
                                                            <input type="radio" name="quiz-view-type-rd" id="quiz-view-type-all-rd" value="WHOL" ${quizVO.qstnDsplyGbncd eq 'WHOL' || empty gbn ? 'checked' : '' }>
                                                            <label for="quiz-view-type-all-rd">전체 문제표시</label>
                                                        </span>
                                                        <span class="custom-input ml5">
                                                            <input type="radio" name="quiz-view-type-rd" id="quiz-view-type-one-rd" value="EACH" ${quizVO.qstnDsplyGbncd eq 'EACH' ? 'checked' : '' }>
                                                            <label for="quiz-view-type-one-rd">한문제씩 표시</label>
                                                        </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <!-- [퀴즈] 문제 섞기 -->
                                            <tr>
                                                <th>
                                                    <label for="quiz-mix-type-label" class = "req">문제섞기</label>
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
                                                    <label for="quiz-view-mix-type-label" class = "req">보기섞기</label>
                                                </th>
                                                <td>
                                                    <div class="form-row">
                                                        <input type="checkbox" id="quiz-view-mix-type" class="switch yesno">
                                                    </div>
                                                </td>
                                            </tr>
                                            <!-- [퀴즈] 파일첨부 -->
                                            <tr>
                                                <th>
                                                    <label for="quiz-sbmsn-atfl-label">파일첨부</label>
                                                </th>
                                                <td>
                                                    <uiex:dextuploader
                                                        id="quizFileUploader"
                                                        path="/quiz"
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
                                        </tbody>
                                    </table>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- //content -->
        </main>
        <!-- //classroom-->
    </div>
</body>
</html>
