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

        /* */
		var asmtEditor = null;
		var quizEditor = null;
        var quizManageEditor = null;

        /*
         * 목록에서 보낸 탭 타입 (버튼)
         * 시험 ID, 시험 방식을 받게 됨.
         * 시험 방식에 따라 보여지는 레이아웃이 다르게 됨.
         */
        var curTabType   = '${vo.tabType}';
        var curExamBscId = '${vo.examBscId}';
        var curTkexamMthdCd = '${vo.tkexamMthdCd}';

        /* 팀 여부 */
        var curByteamSubrexamUseyn = '${vo.byteamSubrexamUseyn}';

        /* 시험정보 및 평가 Tabulator - 탭 최초 활성화 시 생성 */
        var examInfoListTable = null;

        function initExamInfoListTable() {
            if (examInfoListTable) return;
            var examInfoColumns = curByteamSubrexamUseyn === 'Y' ? [
                {title:"No",       field:"lineNo",        headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:50},
                {title:"팀명",     field:"teamnm",        headerHozAlign:"center", hozAlign:"left",   width:120, minWidth:120},
                {title:"학과",     field:"deptnm",        headerHozAlign:"center", hozAlign:"center", width:120, minWidth:120},
                {title:"대표아이디",field:"userRprsId",    headerHozAlign:"center", hozAlign:"center", width:120, minWidth:120},
                {title:"학번",     field:"stntNo",        headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                {title:"이름",     field:"usernm",        headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:80},
                {title:"역할",     field:"ldryn",         headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:80},
                {title:"시험점수", field:"examScr",       headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                {title:"평가점수", field:"totScr",        headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                {title:"응시상태", field:"tkexamCmptnyn", headerHozAlign:"center", hozAlign:"center", width:140, minWidth:140},
                {title:"응시횟수", field:"tkexamCnt",     headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                {title:"평가여부", field:"evlyn",         headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100}
            ] : [
                {title:"No",       field:"lineNo",        headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:50},
                {title:"학과",     field:"deptnm",        headerHozAlign:"center", hozAlign:"center", width:120, minWidth:120},
                {title:"대표아이디",field:"userRprsId",    headerHozAlign:"center", hozAlign:"center", width:120, minWidth:120},
                {title:"이름",     field:"usernm",        headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:80},
                {title:"시험점수", field:"examScr",       headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                {title:"평가점수", field:"totScr",        headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                {title:"응시상태", field:"tkexamCmptnyn", headerHozAlign:"center", hozAlign:"center", width:140, minWidth:140},
                {title:"응시횟수", field:"tkexamCnt",     headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                {title:"평가여부", field:"evlyn",         headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100}
            ];
            examInfoListTable = UiTable("examInfoList", {
                lang: "ko",
                pageFunc: loadExamInfoList,
                columns: examInfoColumns
            });
        }

        function loadExamInfoList(pageIndex) {
            PAGE_INDEX = pageIndex || PAGE_INDEX;
            UiComm.showLoading(true);
            $.ajax({
                url: "/exam/tkexamUserPaging.do",
                type: "GET",
                data: {
                    examBscId: curExamBscId,
                    byteamSubrexamUseyn: curByteamSubrexamUseyn,
                    pageIndex: PAGE_INDEX,
                    listScale: LIST_SCALE
                },
                dataType: "json",
                success: function(data) {
                    if (data.result > 0) {
                        examInfoListTable.clearData();
                        examInfoListTable.replaceData(data.returnList || []);
                        examInfoListTable.setPageInfo(data.pageInfo);
                    } else {
                        alert(data.message);
                    }
                },
                error: function() {
                    alert("에러가 발생했습니다!");
                },
                complete: function() {
                    UiComm.showLoading(false);
                }
            });
        }

        function changeInfoListScale(scale) {
            LIST_SCALE = scale;
            loadExamInfoList(1);
        }

        /* 탭 변경시 텍스트 에디터 호출 로직 */
		function initSbstEditors() {
			if (!asmtEditor) {
				asmtEditor = UiEditor({ targetId: "asmt-cts", uploadPath: "/asmt", height: "250px" });
			}
			if (!quizEditor) {
				quizEditor = UiEditor({ targetId: "quiz-cts", uploadPath: "/quiz", height: "250px" });
			}
            if (!quizManageEditor) {
                quizManageEditor = UiEditor({ targetId: "quiz-manage-cts", uploadPath: "/quiz", height: "250px" });
            }
		}

        // 점수 가감 아이콘 표시 확인
        function plusMinusIconControl(scoreType){
            if(scoreType == 'batch'){
                $("#scr-toggle-icon").hide();
            }else if(scoreType == 'addition'){
                $("#scr-toggle-icon").show();
            }
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

            submitForm(urlMap[tab], "", "", kvArr);
        }

		$(document).ready(function() {
            /*
             * 아코디언 관련 로직
             * 1. 아코디언 기능 include
             * 2. 아코디언 select 로직
             */
            // 1
            $(".accordion").accordion();
            // 2
            const title = document.querySelector('.accordion .title');
            document.querySelector('.accordion .title').addEventListener('click', () => {
                const content = title.nextElementSibling;
                content.classList.toggle('hide');
            });

            /*
             * 일괄 성적처리 로직
             * 1. 일괄 성적처리 +- 아이콘 변경
             * 2. 초기 Radio 버튼 클릭 이벤트
             */
            // 1
            $('#scr-toggle-icon').click(function() {
                $(this).children("i").toggleClass("xi-plus xi-minus");
            });
            // 2
            $("#scoreBatch").trigger("click");

			// /* 탭 목록 동적 생성 (examGbncd 기준) */
			// var examTabs = [
			// 	{ href: '#exam-info',         label: '시험정보 및 평가' },
			// 	{ href: '#exam-evl-sbst',    label: '시험 대체' },
			// 	{ href: '#exam-absnce',      label: '결시 내용 및 현황' },
			// 	{ href: '#exam-dsbl',        label: '장애인/고령자 지원현황' }
			// ];
			// var quizTabs = [
			// 	{ href: '#exam-info',         label: '시험정보 및 평가' },
			// 	{ href: '#exam-quiz-manage', label: '퀴즈관리' }
			// ];
			// var tabs = String(curTkexamMthdCd).includes('RLTM') ? examTabs : quizTabs;
			// var $nav = $(".tab-type1");
			// $.each(tabs, function(i, tab) {
			// 	$nav.append('<a href="' + tab.href + '" class="btn"><span>' + tab.label + '</span></a>');
			// });
            //
			// /*
            //  * gnb.js 가 .tab-type1 클릭 시 e.stopImmediatePropagation() 를 호출하여
            //  * document 레벨 위임 이벤트가 동작하지 않음.
            //  * MutationObserver 로 각 탭 콘텐츠의 display 변경을 감지하여 처리.
            //  */
			// var examInfoEl = document.getElementById('exam-info');
			// if (examInfoEl) {
			// 	new MutationObserver(function() {
			// 		if (examInfoEl.style.display === 'block') {
			// 			initExamInfoListTable();
			// 			loadExamInfoList(1);
			// 		}
			// 	}).observe(examInfoEl, { attributes: true, attributeFilter: ['style'] });
			// }
            //
			// var examEvlSbstEl = document.getElementById('exam-evl-sbst');
			// if (examEvlSbstEl) {
			// 	new MutationObserver(function() {
			// 		if (examEvlSbstEl.style.display === 'block') {
			// 			initSbstEditors();
			// 		}
			// 	}).observe(examEvlSbstEl, { attributes: true, attributeFilter: ['style'] });
			// }
            //
			// /* tabType → tab href 매핑 후 초기 탭 활성화 */
			// var tabMap = {
			// 	'evl-sbst': '#exam-evl-sbst'
            //     , 'dsbl': '#exam-dsbl'
            //     , 'absnce': '#exam-absnce'
            //     , 'quiz': '#exam-quiz-manage'
			// };
			// var activeTab = tabMap[curTabType] || '#exam-info';
			// $(".tab-content").hide();
			// $(activeTab).show(); /* show() 호출 시 style 변경 → MutationObserver 발화 */
			// $('.tab-type1 a.btn[href="' + activeTab + '"]').addClass("current");
            //
			// /* [대체과제] 라디오 버튼 선택에 따라 과제/퀴즈 폼 표시 */
			// function toggleAbsntForm() {
			// 	var val = $('input[name="absnt-type-rd"]:checked').val();
			// 	$("#asmt-write").toggle(val === 'Y');
			// 	$("#quiz-write").toggle(val === 'N');
			// 	$("#quiz-mng-btn").toggle(val === 'N');
			// }
            //
			// $('input[name="absnt-type-rd"]').on("change", toggleAbsntForm);
			// toggleAbsntForm(); // 초기 상태 적용
            //
            // /* 목록 버튼 */
            // $("#into-exam-list-btn").on("click", function() {
            //     UiComm.showMessage("목록으로 돌아가시겠습니까?", "confirm")
            //         .then(function(result) {
            //             if (result) {
            //                 location.href = "/exam/Form/examList.do";
            //             }
            //         });
            // });
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
                            <div class="segment">
                                <!-- 콘텐츠 상단 탭 버튼 영역 -->
                                <div class="listTab">
                                    <ul>
                                        <!-- 실시간/퀴즈 에 따라 버튼 동적 생성 -->
                                        <li class="mw120 select" style = "pointer-events: none;"><a onclick="examViewMv(1)">시험정보 및 평가</a></li>
                                        <c:if test="${vo.tkexamMthdCd eq 'RLTM'}">
                                            <li class="mw120"><a onclick="examViewMv(2)">시험 대체</a></li>
                                            <li class="mw120"><a onclick="examViewMv(3)">결시 내용 및 현황</a></li>
                                            <li class="mw120"><a onclick="examViewMv(4)">장애인/고령자 지원 현황</a></li>
                                        </c:if>
                                        <c:if test="${vo.tkexamMthdCd eq 'QUIZ'}">
                                            <li class="mw120"><a onclick="examViewMv(5)">퀴즈 관리</a></li>
                                        </c:if>
                                    </ul>
                                </div>
                                <!-- 고정 영역 -->
                                <div class="board_top">
                                    <i class="icon-svg-openbook"></i>
                                    <!-- 탭에 따라서 메인 제목을 바꾸는 로직이 필요하다 -->
                                    <h3 class="board-title">시험정보 및 평가</h3>
                                    <div class="right-area">
                                        <!-- 탭에 따라서 버튼 숨기는 로직이 필요하다 -->
                                        <button type="button" class="btn type2" onclick="examViewMv(9)">수정</button>
                                        <button type="button" id = "delete-exam-info-btn" class="btn type2">삭제</button>
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
                                                        <td class="t_left" colspan="3">
                                                            <pre>
                                                                <div class="editor-box">
                                                                    <uiex:htmlEditor
                                                                        id = "dtl-exam-cts"
                                                                        name = "dtl-exam-cts"
                                                                        uploadPath = "${examVO.uploadPath}"
                                                                        value = "${examVO.examCts}"
                                                                        height = "400px"
                                                                        required="true"
                                                                    />
                                                                </div>
                                                            </pre>
                                                        </td>
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
                                                        <td class="t_left"><pre>${examVO.mrkRfltyn eq 'N' ? '-' : examVO.mrkRfltrt}</pre></td>
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
                                                        <td class="t_left" colspan="3"><pre>${examVO.byteamSubrexamUseyn eq 'Y' ? yes : no}</pre></td>
                                                    </tr>
                                                    <tr>
                                                        <th><label>시험 대체</label></th>
                                                        <td class="t_left" colspan="3">
                                                            <div class = "item_list">
                                                                ${examVO.examSbstTynm}
                                                                <c:if test="${vo.tkexamMthdCd eq 'RLTM'}">
                                                                    <button type="button" class = "btn basic">시험 대체</button>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th><label>결시 현황</label></th>
                                                        <td class="t_left" colspan="3">
                                                            <div class = "item_list">
                                                                ${examVO.absnceTot} 명
                                                                <c:if test="${vo.tkexamMthdCd eq 'RLTM'}">
                                                                    <button type="button" class = "btn basic">결시 내용 및 현황</button>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th><label>장애인/고령자 지원</label></th>
                                                        <td class="t_left" colspan="3">
                                                            <div class = "item_list">
                                                                ${examVO.dsblTot} 명
                                                                <c:if test="${vo.tkexamMthdCd eq 'RLTM'}">
                                                                    <button type="button" class = "btn basic">장애인/고령자 지원</button>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                                <!-- 시험정보 및 평가 상단영역 -->
                                <div class="board_top margin-top-4 padding-2">
                                    <h4>시험평가</h4>
                                    <div class="right-area">
                                        <a href="javascript:callScoreExcelUpload()" class="btn basic small"><spring:message code="exam.button.reg.excel.score" /></a><!-- 엑셀 성적등록 -->
                                        <a href="javascript:sendMsg()" class="btn basic small">보내기</a>
                                    </div>
                                </div>
                                <!-- 시험정보 및 평가 검색영역 -->
                                <div class="search-typeA margin-bottom-4">
                                    <div class="text-center">
                                        <select class="form-select" id="tkexamCmptnyn" onchange="quizTkexamListSelect()">
                                            <option value="">응시여부</option>
                                            <option value="all"><spring:message code="exam.common.search.all" /><!-- 전체 --></option>
                                            <option value="N">미응시</option>
                                            <option value="Y">응시완료</option>
                                        </select>
                                        <select class="form-select" id="evlyn" onchange="quizTkexamListSelect()">
                                            <option value="">평가여부</option>
                                            <option value="all"><spring:message code="exam.common.search.all" /><!-- 전체 --></option>
                                            <option value="Y">평가</option>
                                            <option value="N">미평가</option>
                                        </select>
                                        <input class="form-control" type="text" id="searchValue" value="" placeholder="<spring:message code="message.search.input.dept.user.user.nm" />"><!-- 학과/학번/성명 입력 -->
                                        <button type="button" class="btn type1" onclick="quizTkexamListSelect()">검색</button>
                                        <button type="button" class="btn type1" onclick="resetListSelect()">수강생 전체</button>
                                    </div>
                                </div>
                                <table class="table-type1 fs-14px">
                                    <colgroup>
                                        <col class="width-20per" />
                                        <col class="" />
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th>일괄 성적처리</th>
                                        <td>
                                            <form id="scoreForm" onsubmit="return false;">
                                                <div class="form-inline">
												<span class="custom-input">
													<input type="radio" name="scoreType" id="scoreBatch" onchange="plusMinusIconControl(this.value)" value="batch" required="true" />
													<label for="scoreBatch">점수 등록</label>
												</span>
                                                    <span class="custom-input">
													<input type="radio" name="scoreType" id="scoreAddition" onchange="plusMinusIconControl(this.value)" value="addition" required="true" />
													<label for="scoreAddition">점수 가감</label>
												</span>
                                                    점수
                                                    <button class='btn small basic icon' id="scr-toggle-icon"><i class='xi-plus'></i></button>
                                                    <input type="text" id="scoreValue" class="w100" inputmask="numeric" mask="999.99" maxVal="100" required="true" />
                                                    점
                                                    <a href="javascript:EvlScrBulkModify()" class="btn type7">저장</a>
                                                </div>
                                            </form>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                                <div class="board_top">
                                    <div class="right-area">
                                        <button type="button" id="info-ppl-prnt" class="btn type2">시험지 일괄 인쇄</button>
                                        <button type="button" id="info-ppl-xlsx-dnld" class="btn type1">시험지 일괄 엑셀 다운로드</button>
                                        <button type="button" id="info-xlsx-dnld" class="btn type1">엑셀로 다운로드</button>
                                        <button type="button" data-btn-type = "RLTM" id="info-scr-rltm-chrt" class="btn type2">성적분포도</button>
                                        <button type="button" data-btn-type = "QUIZ" id="info-scr-quiz-chrt" class="btn type2">응시현황 그래프</button>
                                        <uiex:listScale func="changeInfoListScale" value="10" />
                                    </div>
                                </div>
                                <div id = "info-list-area">
                                    <div id="examInfoList"></div>
                                </div>
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
