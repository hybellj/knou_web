<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/team/common/team_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>

	<script type="text/javascript">
		var PAGE_INDEX = 1;
		var LIST_SCALE = 10;

        var curSbjctId = '${sbjctId}';
        var lrnGrpInfoListTable = null;

        /*****************************************************************************
         * tabulator 관련 기능
         * 1. initLrnGrpInfoListTable:      컬럼 정의
         * 2. createLrnGrpInfoListHtml:       각 컬럼에 들어갈 데이터 세팅 및 버튼 요소 생성
         * 3. loadLrnGrpInfoList :            컬럼에 들어갈 데이터 ajax 호출
         *****************************************************************************/
        /* 1 */
        function initLrnGrpInfoListTable() {
            if (lrnGrpInfoListTable) return;
            var lrnGrpInfoColumns = [
                {title:"No",           field:"lineNo",        headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:50},
                {title:"학습그룹명",    field:"lrnGrpnm",      headerHozAlign:"center", hozAlign:"left", width:0, minWidth:200},
                {title:"팀수",         field:"teamTot",       headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},
                {title:"등록자",       field:"usernm",        headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                {title:"등록일자",     field:"regDttm",        headerHozAlign:"center", hozAlign:"center", width:140,  minWidth:140},
                {title:"상태",        field:"lrnGrpCmptnyn",  headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                {title:"관리",        field:"manage",         headerHozAlign:"center", hozAlign:"center", width:160, minWidth:160}
            ];
            lrnGrpInfoListTable = UiTable("lrnGrpList", {
                lang: "ko",
                pageFunc: loadLrnGrpInfoList,
                columns: lrnGrpInfoColumns
            });
        }
        /* 2 */
        function createLrnGrpInfoListHtml(list) {
            let dataList = [];
            if (list.length == 0) {
                return dataList;
            } else {
                list.forEach(function(v, i) {
                    // 학습그룹명
                    var lrnGrpnm = "<a href='javascript:quizViewMv(\"" + v.lrnGrpId + "\")' class='header header-icon link'>" + v.lrnGrpnm + "</a>";
                    // 팀수
                    var teamTot;
                    if (v.teamTot === 0) {
                        teamTot = "-";
                    } else {
                        teamTot = v.teamTot + " 팀";
                    }
                    // 등록일자
                    var regDttm = dateFormat("date", v.regDttm);
                    // 상태
                    var lrnGrpCmptnyn;
                    if (v.lrnGrpCmptnyn === "Y") {
                        lrnGrpCmptnyn = "<a>구성완료</a>"
                    } else {
                        lrnGrpCmptnyn = "<a class='fcRed'>임시저장</a>"
                    }
                    // 관리
                    var _p  = "\"" + v.lrnGrpId + "\",\"" + v.sbjctId + "\"";
                    var manage = "<a href='javascript:lrnGrpMgrViewMv(" + _p + ")' class='btn basic small'>수정</a>"
                                + "<a href='javascript:lrnGrpMgrViewMv(" + _p + ")' class='btn basic small'>삭제</a>";

                    dataList.push({
                        lineNo:         v.lineNo
                        , lrnGrpnm:     lrnGrpnm
                        , teamTot:      teamTot
                        , usernm:       v.usernm
                        , regDttm:      regDttm
                        , lrnGrpCmptnyn:lrnGrpCmptnyn
                        , manage:       manage
                        , lrnGrpId:     v.lrnGrpId
                        , sbjctId:      v.sbjctId
                    });
                });
            }
            return dataList;
        }
        /* 3 */
        function loadLrnGrpInfoList(pageIndex) {
            initLrnGrpInfoListTable();
            PAGE_INDEX = pageIndex || PAGE_INDEX;
            UiComm.showLoading(true);
            $.ajax({
                url: "/team/lrnGrpPaging.do",
                type: "GET",
                data: {
                    sbjctId     : curSbjctId
                    , pageIndex : PAGE_INDEX
                    , listScale : LIST_SCALE
                    , lrnGrpnm  : $('#lrnGrpnm').val()
                },
                dataType: "json",
                success: function(data) {
                    if (data.result > 0) {
                        var returnList = data.returnList || [];
                        var dataList   = createLrnGrpInfoListHtml(returnList);
                        lrnGrpInfoListTable.clearData();
                        lrnGrpInfoListTable.replaceData(dataList);
                        lrnGrpInfoListTable.setPageInfo(data.pageInfo);
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

        /**
         * 학습그룹 지정 [등록|수정] 페이지 이동
         * @param lrnGrpId  학습그룹 ID
         * @param sbjctId   과목 ID
         */
        function lrnGrpMgrViewMv(lrnGrpId, sbjctId) {
            var url = "/team/lrnGrpMngWriteView.do";

            var kvArr = [];
            kvArr.push({'key' : 'lrnGrpId', 'val' : lrnGrpId});
            kvArr.push({'key' : 'sbjctId',  'val' : sbjctId});
            submitForm(url, "", "", kvArr);
        }

        $(document).ready(function() {
            loadLrnGrpInfoList();

            /* 검색 영역 엔터키 입력 */
            $("#lrnGrpnm").on("keyup", function(e) {
                if(e.keyCode === 13) {
                    loadLrnGrpInfoList(1);
                }
            });
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
                    <!-- //강의실 상단 -->

                    <div class="sub-content">
                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit">
                                    <label for="searchValue">
                                        <spring:message code='common.search.keyword'/><!-- 검색어 -->
                                    </label>
                                </span>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" name="lrnGrpnm" id="lrnGrpnm" value=""
                                           placeholder = "학습그룹명 입력">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="loadLrnGrpInfoList(1)">
                                    <spring:message code='button.search'/><!-- 검색 -->
                                </button>
                            </div>
                        </div>
                        <!-- 상단 영역 -->
                        <div class="board_top">
                            <i class="icon-svg-openbook"></i>
                            <h3 class="board-title">학습그룹지정</h3>
                            <div class="right-area">
                                <button type="button" class="btn type2" onclick = "lrnGrpMgrViewMv('', curSbjctId)">등록</button>
                                <!-- 목록 스케일 선택 -->
                                <uiex:listScale func="changeListScale" value="10" />
                            </div>
                        </div>
                        <!-- 학습 그룹 목록 (list) -->
                        <div id="lrnGrpListArea">
                            <div id="lrnGrpList"></div>
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
