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

        /**
         * 목록에서 보낸 탭 타입 (버튼)
         * 시험 ID, 시험 방식을 받게 됨.
         * 시험 방식에 따라 보여지는 레이아웃이 다르게 됨.
         */
        var curTabType   = '${vo.tabType}';
        var curExamBscId = '${vo.examBscId}';
        var curTkexamMthdCd = '${vo.tkexamMthdCd}';

        var hasSubSubject = '${examVO.lrnGrpSubsbjctUseyn}';        // 부 주제
        var absnceInfoListTable = null;

        /*****************************************************************************
         * tabulator 관련 기능
         * 1. initAbsnceInfoListTable :    컬럼 정의
         * 2. createAbsnceInfoListHtml :   각 컬럼에 들어갈 데이터 세팅 및 요소 생성
         * 3. loadAbsnceInfoList :         컬럼에 들어갈 데이터 ajax 호출
         *****************************************************************************/
        /* 1 */
        function initAbsnceInfoListTable() {
            if (absnceInfoListTable) return;
            var absnceInfoColumns = [
                {title:"No",       field:"lineNo",     headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:50},
                {title:"학과",     field:"deptnm",      headerHozAlign:"center", hozAlign:"center", width:140, minWidth:140},
                {title:"대표아이디",field:"userRprsId",  headerHozAlign:"center", hozAlign:"center", width:140, minWidth:140},
                {title:"학번",     field:"stdntNo",     headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                {title:"이름",     field:"usernm",      headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:80},
                {title:"신청일시",  field:"regDttm",     headerHozAlign:"center", hozAlign:"center", width:140,  minWidth:140},
                {title:"시험구분",  field:"examGbnnm",   headerHozAlign:"center", hozAlign:"center", width:100,  minWidth:100},
                {title:"처리상태",  field:"aplyStsnm",   headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:80},
                {title:"처리일시",  field:"aprvdttm",    headerHozAlign:"center", hozAlign:"center", width:140,  minWidth:140},
                {title:"담당자",  field:"autzrId",       headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:80},
                {title:"관리",    field:"manage",        headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:200}
            ];
            absnceInfoListTable = UiTable("absnceUserList", {
                lang: "ko",
                selectRow: "checkbox",
                pageFunc: loadAbsnceInfoList,
                columns: absnceInfoColumns
            });
        }
        /* 2 */
        function createAbsnceInfoListHtml(list) {
            let dataList = [];
            if (list.length == 0) {
                return dataList;
            } else {
                list.forEach(function(v, i) {
                    // 학번
                    var stdntNo;
                    if (v.stdntNo == "" || v.stdntNo == null) {
                        stdntNo = "-";
                    } else {
                        stdntNo = v.stdntNo;
                    }
                    // 처리상태
                    var aplyStsnm;
                    if (v.aplyStsnm == "1") {
                        aplyStsnm = "<span class='fcBlue'>신청</span>"
                    } else if (v.aplyStsnm == "2") {
                        aplyStsnm = "<span class='fcOrange'>재신청</span>"
                    } else if (v.aplyStsnm == "3") {
                        aplyStsnm = "<span class='fcBlack'>승인</span>"
                    } else {
                        aplyStsnm = "<span class='fcRed'>거절</span>"
                    }
                    // 신청일시
                    var regDttm = dateFormat("date", v.regDttm);
                    // 승인일시
                    var aprvdttm;
                    if (v.aprvdttm == "" || v.aprvdttm == null) {
                        aprvdttm = "-"
                    } else {
                        aprvdttm = dateFormat("date", v.aprvdttm);
                    }
                    // 승인자
                    var autzrId;
                    if (v.autzrId == "" || v.autzrId == null) {
                        autzrId = "-";
                    } else {
                        autzrId = v.autzrId;
                    }
                    // 관리 버튼
                    var manageBtns = "";
                        manageBtns += "<a href='javascript:examAbsnceRsltPopup(\"" + v.examBscId + "\", \"" + v.userId + "\")' class='btn basic small'>결과보기</a>"
                        manageBtns += "<a href='javascript:examAbsnceHstrPopup(\"" + v.examBscId + "\", \"" + v.userId + "\")' class='btn basic small'>신청이력</a>"

                    dataList.push({
                        lineNo:         v.lineNo
                        , deptnm:       v.deptnm
                        , userRprsId:   v.userRprsId
                        , stdntNo:      stdntNo
                        , usernm:       v.usernm
                        , aplyStsnm:    aplyStsnm
                        , regDttm:      regDttm
                        , examGbnnm:    v.examGbnnm
                        , aprvdttm:     aprvdttm
                        , autzrId:      autzrId
                        , manage:       manageBtns
                        , examBscId:    v.examBscId
                        , userId:       v.userId
                    });
                });
            }
            return dataList;
        }
        /* 3 */
        function loadAbsnceInfoList(pageIndex) {
            initAbsnceInfoListTable();
            PAGE_INDEX = pageIndex || PAGE_INDEX;
            UiComm.showLoading(true);
            $.ajax({
                url: "/exam/examAbsnceUserPaging.do",
                type: "GET",
                data: {
                    examBscId   : curExamBscId,
                    aplyStscd   : $("#aplyStscd").val(),
                    searchValue : $("#searchValue").val(),
                    pageIndex   : PAGE_INDEX,
                    listScale   : LIST_SCALE
                },
                dataType: "json",
                success: function(data) {
                    if (data.result > 0) {
                        var returnList = data.returnList || [];
                        var dataList   = createAbsnceInfoListHtml(returnList);
                        absnceInfoListTable.clearData();
                        absnceInfoListTable.replaceData(dataList);
                        absnceInfoListTable.setPageInfo(data.pageInfo);
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

        /*****************************************************************************
         * 검색 영역 기능
         * 1. examAbsnceListSelect :    결시자 검색
         * 2. resetListSelect :         결시자 전체 검색 및 검색영역 초기화
         *****************************************************************************/
        /* 1 */
        function examAbsnceListSelect (){
            loadAbsnceInfoList(1);
        }
        /* 2 */
        function resetListSelect() {
            $("#aplyStscd").val('').trigger('chosen:updated');
            $("#searchValue").val("");
            examAbsnceListSelect();
        }

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
         * 팝업 관련 기능
         * 1. examAbsnceRsltPopup:      결시자 결시신청 결과 팝업
         * 2. examAbsnceHstrPopup:      결시자 결시신청 이력 팝업
         *****************************************************************************/
        /* 1 */
        function examAbsnceRsltPopup(examBscId, userId) {
            var data = "examBscId="+examBscId+"&userId="+userId;

            dialog = UiDialog("dialog1", {
                title: "결시신청 결과 보기",
                width: 800,
                height: 300,
                url: "/exam/examAbsnceUserRsltPopup.do?"+data,
                autoresize: true
            });
        }
        /* 2 */
        function examAbsnceHstrPopup(examBscId, userId) {
            var data = "examBscId="+examBscId+"&userId="+userId+"&pageIndex="+PAGE_INDEX+"&listScale="+LIST_SCALE;

            dialog = UiDialog("dialog1", {
                title: "결시신청 이력 보기",
                width: 800,
                height: 300,
                url: "/exam/examAbsnceUserHstrPagingPopup.do?"+data,
                autoresize: true
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

        /* 메세지 전송 기능 */
        function sendMsg() {
            var rcvUserInfoStr = "";
            var sendCnt = 0;

            $.each($('#absnceUserList').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
                sendCnt++;
                if (sendCnt > 1) rcvUserInfoStr += "|";
                rcvUserInfoStr += $(this).attr("user_id");
                rcvUserInfoStr += ";" + $(this).attr("user_nm");
                rcvUserInfoStr += ";" + $(this).attr("mobile");
                rcvUserInfoStr += ";" + $(this).attr("email");
            });

            if (absnceInfoListTable.getSelectedData("userId").length == 0) {
                /* 메시지 발송 대상자를 선택하세요. */
                alert("<spring:message code='common.alert.sysmsg.select_user'/>");
                return;
            }

            window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");

            var form = document.alarmForm;
            form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
            form.target = "msgWindow";
            form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
            form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
            form.submit();
        }

        /* 엑셀 다운로드 */
        function examAbsnceStatusExcelDown() {
            var aplyStscdObj = {
                1: "신청"
                , 2: "재신청"
                , 3: "승인"
                , 4: "거절"
            };

            var excelGrid = { colModel: [] };

            excelGrid.colModel.push({label: 'No.',      name: 'lineNo',     align: 'center',    width: '1000'});
            excelGrid.colModel.push({label: '학과',     name: 'deptnm',     align: 'left',      width: '5000'});
            excelGrid.colModel.push({label: '대표아이디', name: 'userRprsId', align: 'left',      width: '5000'});
            excelGrid.colModel.push({label: '학번',     name: 'stdntNo',    align: 'center',    width: '5000'});
            excelGrid.colModel.push({label: '이름',     name: 'usernm',     align: 'center',    width: '5000'});
            excelGrid.colModel.push({label: '신청일시',  name: 'regDttm',    align: 'center',    width: '5000'});
            excelGrid.colModel.push({label: '시험구분',  name: 'examGbnnm',  align: 'center',    width: '5000'});
            excelGrid.colModel.push({label: '처리상태',  name: 'aplyStsnm',  align: 'center',    width: '3000',  codes: aplyStscdObj});
            excelGrid.colModel.push({label: '처리일시',  name: 'aprvdttm',   align: 'center',    width: '5000'});
            excelGrid.colModel.push({label: '담당자',   name: 'autzrId',    align: 'center',    width: '3000'});

            var kvArr = [];
            kvArr.push({'key': 'examBscId',         'val': curExamBscId});
            kvArr.push({'key': 'aplyStscd',         'val': $("#aplyStscd").val()});
            kvArr.push({'key': 'searchValue',       'val': $("#searchValue").val()});
            kvArr.push({'key': 'excelGrid',         'val': JSON.stringify(excelGrid)});

            submitForm("/exam/profAbsnceStatusExcelDown.do", "", "", kvArr);
        }

        $(document).ready(function() {
            loadAbsnceInfoList();

            setAccordion();
            eventAccordion();

            if (hasSubSubject == 'Y') {
                examSubAsmtListAppend();
            }
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
                                            <li class="mw120 select" style = "pointer-events: none;"><a onclick="examViewMv(3)">결시 내용 및 현황</a></li>
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
                                    <h3 class="board-title">결시 내용 및 현황</h3>
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
                                                                    <button type="button" class = "btn basic" onclick="examViewMv(2)">시험 대체</button>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th><label>결시 현황</label></th>
                                                            <td class="t_left" colspan="3">
                                                                <div class = "item_list">
                                                                    ${examVO.absnceTot} 명
                                                                    <button type="button" class = "btn basic" onclick="examViewMv(3)" style="pointer-events: none;">결시 내용 및 현황</button>
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

                                <!-- 결시 내용 및 현황 상단영역 -->
                                <div class="board_top margin-top-4 padding-2">
                                    <h4>[${examVO.examGbnnm}] 결시 내용 및 현황</h4>
                                    <div class="right-area">
                                        <a href="javascript:sendMsg()" class="btn basic small">보내기</a>
                                    </div>
                                </div>
                                <!-- 결시 내용 및 현황 검색영역 -->
                                <div class="search-typeA margin-bottom-4">
                                    <div class="text-center">
                                        <select class="form-select" id="aplyStscd">
                                            <option value="">처리상태</option>
                                            <option value="all"><spring:message code="exam.common.search.all" /><!-- 전체 --></option>
                                            <option value="1">신청</option>
                                            <option value="3">승인</option>
                                            <option value="4">반려</option>
                                        </select>
                                        <input class="form-control" type="text" id="searchValue" value="" placeholder="<spring:message code="message.search.input.dept.user.user.nm" />"><!-- 학과/학번/성명 입력 -->
                                        <button type="button" class="btn type1" onclick="examAbsnceListSelect()">검색</button>
                                        <button type="button" class="btn type1" onclick="resetListSelect()">수강생 전체</button>
                                    </div>
                                </div>
                                <!-- 결시 내용 및 현황 중단영역 -->
                                <div class="board_top">
                                    <div class="right-area">
                                        <a href="javascript:examAbsnceStatusExcelDown()" class="btn type1">엑셀로 다운로드</a>
                                    </div>
                                </div>
                                <div id = "absnceUserArea">
                                    <div id="absnceUserList"></div>
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
