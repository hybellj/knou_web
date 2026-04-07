<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style"  value="classroom"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>

    <script type="text/javascript">
        var CRS_CRE_CD = '<c:out value="${crsCreCd}" />';

        $(document).ready(function() {
            // 기간 기본값: 오늘 기준 -7일 ~ 오늘
            var today  = new Date();
            var before = new Date(today); before.setDate(today.getDate() - 7);
            var fmt = function(d) {
                return d.getFullYear()
                    + ('0'+(d.getMonth()+1)).slice(-2)
                    + ('0'+d.getDate()).slice(-2);
            };
            $("#dateSt").val(fmt(before));
            $("#dateEd").val(fmt(today));
        });

        /* ============================================
         * 검색 실행
         * - 검색 조건이 1개라도 빠지면 실행하지 않음
         * ============================================ */
        function listPaging(pageIndex) {
            var dateSt    = $("#dateSt").val();
            var timeSt    = ($("#timeSt").val() || "00") + ($("#timeMSt").val() || "00");
            var dateEd    = $("#dateEd").val();
            var timeEd    = ($("#timeEd").val() || "23") + ($("#timeMEd").val() || "50");
            var sbjctId   = CRS_CRE_CD;
            var userTycd  = $("input[name='userTycd']:checked").val();

            // 필수 조건 검증
            if (!dateSt || !dateEd) {
                showMessage("기간을 입력하세요.", "warning");
                return;
            }
            if (!sbjctId) {
                showMessage("과목 정보가 없습니다.", "warning");
                return;
            }
            if (!userTycd) {
                showMessage("사용자구분을 선택하세요.", "warning");
                return;
            }

            // YYYYMMDDHHMM00 (14자리)
            var searchSdttm = dateSt + timeSt + "00";
            var searchEdttm = dateEd + timeEd + "59";

            var data = {
                sbjctId     : sbjctId,
                searchSdttm : searchSdttm,
                searchEdttm : searchEdttm,
                userTycd    : userTycd,
                searchValue : $("#searchValue").val(),
                pageIndex   : pageIndex,
                listScale   : $("#listScale").val()
            };

            UiComm.showLoading(true);

            ajaxCall("/lesson/lessonLect/profLogUserActvList.do", data, function(res) {
                if (res.result > 0) {
                    var dataList = createListData(res.returnList || []);
                    logActvTable.clearData();
                    logActvTable.replaceData(dataList);
                    logActvTable.setPageInfo(res.pageInfo);
                } else {
                    logActvTable.clearData();
                    showMessage(res.message, "error");
                }
            }, function() {
                logActvTable.clearData();
                showMessage("<spring:message code='fail.common.msg'/>", "error");
            }, true);
        }

        /* 목록 데이터 생성 */
        function createListData(list) {
            var dataList = [];
            list.forEach(function(v) {
                dataList.push({
                    no          : v.lineNo        || "",
                    sbjctYr     : v.sbjctYr       || "",
                    sbjctSmstr  : v.sbjctSmstr     || "",
                    orgnm       : v.orgnm          || "",
                    deptNm      : v.deptNm         || "",
                    sbjctnm     : (v.sbjctnm || "") + (v.dvclasNo ? " " + v.dvclasNo + "반" : ""),
                    userRprsId  : v.userRprsId     || "",
                    stdntNo     : v.stdntNo        || "",
                    usernm      : v.usernm         || "",
                    userTycd    : v.userTycd       || "",
                    userReqMenu : v.userReqMenu    || "",
                    userReqCts  : v.userReqCts     || "",
                    actvDttm    : fmtDttm(v.actvDttm),
                    cntnIp      : v.cntnIp         || ""
                });
            });
            return dataList;
        }

        /* YYYYMMDDHH24MISS → YYYY.MM.DD HH:MM:SS */
        function fmtDttm(dttm) {
            if (!dttm || dttm.length < 14) return dttm || "";
            return dttm.substring(0,4) + '.' + dttm.substring(4,6) + '.' + dttm.substring(6,8)
                 + ' ' + dttm.substring(8,10) + ':' + dttm.substring(10,12) + ':' + dttm.substring(12,14);
        }

        function changeListScale(scale) {
            $("#listScale").val(scale);
            listPaging(1);
        }
    </script>
</head>

<body class="class colorA ">
<div id="wrap" class="main">
    <!-- common header -->
    <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
    <!-- //common header -->

    <main class="common">

        <!-- gnb -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
        <!-- //gnb -->

        <!-- content -->
        <div id="content" class="content-wrap common">
            <div class="class_sub_top">
                <div class="btn-wrap">
                    <div class="sec">
                        <button type="button" class="btn type2"><i class="xi-log-out"></i>강의실나가기</button>
                    </div>
                </div>
            </div>

            <div class="class_sub">
                <!-- 강의실 상단 -->
                <div class="segment class-area sub">
                    <div class="class_info">
                        <div class="navi_bar">
                            <ul>
                                <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                <li>강의실</li>
                                <li><span class="current">접속정보</span></li>
                            </ul>
                        </div>
                    </div>
                </div>
                <!-- //강의실 상단 -->

                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title">접속정보</h2>
                    </div>

                    <div class="tstyle_view">
                        <!-- search typeA -->
                        <div class="search-typeA">

                            <%-- 기간 (필수) --%>
                            <div class="item">
                                <span class="item_tit"><label for="dateSt">기간</label></span>
                                <div class="itemList">
                                    <input id="dateSt" type="text" name="dateSt" class="datepicker" toDate="dateEd" placeholder="YYYYMMDD">
                                    <select id="timeSt" name="timeSt" class="form-select">
                                        <option value="00">00</option><option value="01">01</option><option value="02">02</option>
                                        <option value="03">03</option><option value="04">04</option><option value="05">05</option>
                                        <option value="06">06</option><option value="07">07</option><option value="08">08</option>
                                        <option value="09">09</option><option value="10">10</option><option value="11">11</option>
                                        <option value="12">12</option><option value="13">13</option><option value="14">14</option>
                                        <option value="15">15</option><option value="16">16</option><option value="17">17</option>
                                        <option value="18">18</option><option value="19">19</option><option value="20">20</option>
                                        <option value="21">21</option><option value="22">22</option><option value="23">23</option>
                                    </select>
                                    <select id="timeMSt" name="timeMSt" class="form-select">
                                        <option value="00">00</option><option value="10">10</option><option value="20">20</option>
                                        <option value="30">30</option><option value="40">40</option><option value="50">50</option>
                                    </select>
                                    <span class="txt-sort">~</span>
                                    <input id="dateEd" type="text" name="dateEd" class="datepicker" fromDate="dateSt" placeholder="YYYYMMDD">
                                    <select id="timeEd" name="timeEd" class="form-select">
                                        <option value="00">00</option><option value="01">01</option><option value="02">02</option>
                                        <option value="03">03</option><option value="04">04</option><option value="05">05</option>
                                        <option value="06">06</option><option value="07">07</option><option value="08">08</option>
                                        <option value="09">09</option><option value="10">10</option><option value="11">11</option>
                                        <option value="12">12</option><option value="13">13</option><option value="14">14</option>
                                        <option value="15">15</option><option value="16">16</option><option value="17">17</option>
                                        <option value="18">18</option><option value="19">19</option><option value="20">20</option>
                                        <option value="21">21</option><option value="22">22</option><option value="23" selected>23</option>
                                    </select>
                                    <select id="timeMEd" name="timeMEd" class="form-select">
                                        <option value="00">00</option><option value="10">10</option><option value="20">20</option>
                                        <option value="30">30</option><option value="40">40</option><option value="50" selected>50</option>
                                    </select>
                                </div>
                            </div>

                            <%-- 과목 (현재 강의실 고정) --%>
                            <div class="item">
                                <span class="item_tit"><label>과목</label></span>
                                <div class="itemList">
                                    <input type="text" class="form-control wide" value="<c:out value='${sbjctnm}' />" readonly>
                                </div>
                            </div>

                            <%-- 사용자구분 (필수) --%>
                            <div class="item">
                                <span class="item_tit"><label>사용자구분</label></span>
                                <div class="itemList">
                                    <span class="custom-input">
                                        <input type="radio" name="userTycd" id="userTycdStd"  value="USER_STD"  checked>
                                        <label for="userTycdStd">수강생</label>
                                    </span>
                                    <span class="custom-input ml5">
                                        <input type="radio" name="userTycd" id="userTycdProf" value="USER_PROF">
                                        <label for="userTycdProf">담당교수</label>
                                    </span>
                                    <span class="custom-input ml5">
                                        <input type="radio" name="userTycd" id="userTycdTut"  value="USER_TUT">
                                        <label for="userTycdTut">담당튜터</label>
                                    </span>
                                    <span class="custom-input ml5">
                                        <input type="radio" name="userTycd" id="userTycdAssi" value="USER_ASSI">
                                        <label for="userTycdAssi">담당조교</label>
                                    </span>
                                </div>
                            </div>

                            <%-- 검색어 (선택) --%>
                            <div class="item">
                                <span class="item_tit"><label for="searchValue">검색어</label></span>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" id="searchValue"
                                           placeholder="대표아이디 / 학번(교번) / 이름"
                                           onkeydown="if(event.keyCode==13) listPaging(1)">
                                </div>
                            </div>

                            <div class="button-area">
                                <button type="button" class="btn search" onclick="listPaging(1)">검색</button>
                            </div>
                        </div>
                        <!-- //search typeA -->

                        <input type="hidden" id="listScale" value="20">

                        <div class="board_top">
                            <h3 class="board-title">목록</h3>
                            <div class="right-area">
                                <uiex:listScale func="changeListScale" value="20" />
                            </div>
                        </div>

                        <%-- 활동 로그 리스트 --%>
                        <div id="logActvList"></div>

                        <script>
                        let logActvTable = UiTable("logActvList", {
                            lang    : "ko",
                            pageFunc: listPaging,
                            columns : [
                                {title:"No",       field:"no",          headerHozAlign:"center", hozAlign:"center", width:55,  minWidth:55},
                                {title:"년도",      field:"sbjctYr",     headerHozAlign:"center", hozAlign:"center", width:60,  minWidth:60},
                                {title:"학기",      field:"sbjctSmstr",  headerHozAlign:"center", hozAlign:"center", width:55,  minWidth:55},
                                {title:"기관",      field:"orgnm",       headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:70},
                                {title:"학과",      field:"deptNm",      headerHozAlign:"center", hozAlign:"center", width:90,  minWidth:80},
                                {title:"과목",      field:"sbjctnm",     headerHozAlign:"center", hozAlign:"left",   width:160, minWidth:120},
                                {title:"대표아이디", field:"userRprsId",  headerHozAlign:"center", hozAlign:"center", width:110, minWidth:90},
                                {title:"학번/교번",  field:"stdntNo",     headerHozAlign:"center", hozAlign:"center", width:100, minWidth:90},
                                {title:"이름",      field:"usernm",      headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:70},
                                {title:"화면",      field:"userTycd",    headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:70},
                                {title:"메뉴",      field:"userReqMenu", headerHozAlign:"center", hozAlign:"left",   width:160, minWidth:120},
                                {title:"액션구분",   field:"userReqCts",  headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:200},
                                {title:"접속일시",   field:"actvDttm",    headerHozAlign:"center", hozAlign:"center", width:150, minWidth:140},
                                {title:"접속IP",    field:"cntnIp",      headerHozAlign:"center", hozAlign:"center", width:130, minWidth:110}
                            ]
                        });
                        </script>

                    </div>
                </div>
            </div>
        </div>
        <!-- //content -->

    </main>
</div>

</body>
</html>
