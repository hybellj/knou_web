<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>

    <script type="text/javascript">
        var CRS_CRE_CD = '<c:out value="${crsCreCd}" />';
        var PAGE_INDEX = 1;

        $(document).ready(function() {
            $("#searchSdttm, #searchEdttm").datepicker({
                dateFormat: "yyyymmdd",
                maxDate: 0
            });

            $("#searchUserId").on("keydown", function(e) {
                if (e.keyCode == 13) listPaging(1);
            });

            // listPaging(1);
        });

        // 강의실 활동 로그 조회 현황 목록
        function listPaging(pageIndex) {
            PAGE_INDEX = pageIndex;

            var url  = "/lesson/lessonLect/profLogUserActvList.do";
            var data = {
                sbjctId     : CRS_CRE_CD,
                pageIndex   : pageIndex,
                listScale   : $("#listScale").val(),
                userId      : $("#searchUserId").val(),
                searchSdttm : $("#searchSdttm").val(),
                searchEdttm : $("#searchEdttm").val()
            };

            UiComm.showLoading(true);

            ajaxCall(url, data, function(data) {
                if (data.result > 0) {
                    let returnList = data.returnList || [];
                    let dataList   = createListData(returnList);
                    logActvTable.clearData();
                    logActvTable.replaceData(dataList);
                    logActvTable.setPageInfo(data.pageInfo);
                } else {
                    logActvTable.clearData();
                    showMessage(data.message, "error");
                }
            }, function(xhr, status, error) {
                logActvTable.clearData();
                showMessage("<spring:message code='fail.common.msg'/>", "error");
            }, true);
        }

        function createListData(list) {
            let dataList = [];
            list.forEach(function(v) {
                var actvDttmFmt = (v.actvDttm || "").length == 14
                    ? v.actvDttm.substring(0,4)+'.'+v.actvDttm.substring(4,6)+'.'+v.actvDttm.substring(6,8)
                      +' '+v.actvDttm.substring(8,10)+':'+v.actvDttm.substring(10,12)
                    : (v.actvDttm || "");
                var sessSdttmFmt = fmtDttm(v.sessSdttm);
                var sessEdttmFmt = fmtDttm(v.sessEdttm);

                dataList.push({
                    no          : v.lineNo,
                    userId      : v.userId      || "",
                    sbjctId     : v.sbjctId     || "",
                    reqTycd     : v.reqTycd     || "",
                    userReqMenu : v.userReqMenu || "",
                    userReqCts  : v.userReqCts  || "",
                    cntnIp      : v.cntnIp      || "",
                    cntnDvcTycd : v.cntnDvcTycd || "",
                    cntnBrwsr   : v.cntnBrwsr   || "",
                    actvDttm    : actvDttmFmt,
                    sessSdttm   : sessSdttmFmt,
                    sessEdttm   : sessEdttmFmt
                });
            });
            return dataList;
        }

        function fmtDttm(dttm) {
            if (!dttm || dttm.length < 12) return dttm || "";
            return dttm.substring(0,4)+'.'+dttm.substring(4,6)+'.'+dttm.substring(6,8)
                   +' '+dttm.substring(8,10)+':'+dttm.substring(10,12);
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

    <!-- classroom -->
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
                        <div class="class_tit">
                            <p class="labels">
                                <label class="label uniA">대학원</label>
                            </p>
                            <h2>데이터베이스의 이해와 활용 1반</h2>
                        </div>
                        <div class="navi_bar">
                            <ul>
                                <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                <li>강의실</li>
                                <li><span class="current">과목설정</span></li>
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
                            <div class="item">
                                <span class="item_tit"><label for="searchSdttm">활동일시</label></span>
                                <div class="itemList">
                                    <input id="dateSt" type="text" name="dateSt" class="datepicker" timeId="timeSt" toDate="dateEd" value="${fn:substring(vo.searchFrom,0,8)}" required="true">
                                    <input id="timeSt" type="text" name="timeSt" class="timepicker" dateId="dateSt" value="${fn:substring(vo.searchFrom,8,12)}" required="true">
                                    <span class="txt-sort">~</span>
                                    <input id="dateEd" type="text" name="dateEd" class="datepicker" timeId="timeEd" fromDate="dateSt" value="${fn:substring(vo.searchTo,0,8)}" required="true">
                                    <input id="timeEd" type="text" name="timeEd" class="timepicker" dateId="dateEd" value="${fn:substring(vo.searchTo,8,12)}" required="true">
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectCourse">과목</label></span>
                                <div class="itemList">
                                    <select class="form-select wide" id="selectSubject" required="true">
                                        <option value="">과목 선택</option>
                                        <option value="운영과목1">운영과목1</option>
                                        <option value="운영과목2">운영과목2</option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectCourse">담당교수</label></span>
                                <div class="itemList">
                                    <select class="form-select chosen wide" id="selectCourse" required="true">
                                        <option value="홍교수">홍교수</option>
                                        <option value="김교수">김교수</option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectCourse">사용자구분</label></span>
                                <div class="itemList">
                                <span class="custom-input">
                                    <input type="radio" name="userTycd" id="userTycdStd" value="USER_STD" checked="">
                                    <label for="userTycdStd">수강생</label>
                                </span>
                                    <span class="custom-input ml5">
                                    <input type="radio" name="userTycd" id="userTycdProf" value="USER_PROF">
                                    <label for="userTycdProf">담당교수</label>
                                </span>
                                    <span class="custom-input ml5">
                                    <input type="radio" name="userTycd" id="userTycdTut" value="USER_TUT">
                                    <label for="userTycdTut">담당튜터</label>
                                </span>
                                    <span class="custom-input ml5">
                                    <input type="radio" name="userTycd" id="userTycdAssi" value="USER_ASSI">
                                    <label for="userTycdAssi">담당조교</label>
                                </span>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="searchText">검색어</label></span>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" id="searchText" placeholder="대표아이디/학번/이름 검색" required="true">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="listPaging(1)">검색</button>
                            </div>
                        </div>
                        <!-- //search typeA -->

                        <input type="hidden" id="listScale" value="10">

                        <div class="board_top">
                            <h3 class="board-title">활동 로그 목록</h3>
                            <div class="right-area">
                                <%-- 목록 스케일 선택 --%>
                                <uiex:listScale func="changeListScale" value="10" />
                            </div>
                        </div>

                        <%-- 활동 로그 리스트 --%>
                        <div id="logActvList"></div>

                        <script>
                            let logActvTable = UiTable("logActvList", {
                                lang: "ko",
                                pageFunc: listPaging,
                                columns: [
                                    {title:"No",        field:"no",          headerHozAlign:"center", hozAlign:"center", width:60,   minWidth:60},
                                    {title:"사용자ID",   field:"userId",      headerHozAlign:"center", hozAlign:"center", width:120,  minWidth:100},
                                    {title:"교과목ID",   field:"sbjctId",     headerHozAlign:"center", hozAlign:"center", width:120,  minWidth:100},
                                    {title:"요청유형",   field:"reqTycd",     headerHozAlign:"center", hozAlign:"center", width:90,   minWidth:80},
                                    {title:"요청메뉴",   field:"userReqMenu", headerHozAlign:"center", hozAlign:"left",   width:160,  minWidth:120},
                                    {title:"요청내용",   field:"userReqCts",  headerHozAlign:"center", hozAlign:"left",   width:0,    minWidth:150},
                                    {title:"접속IP",     field:"cntnIp",      headerHozAlign:"center", hozAlign:"center", width:120,  minWidth:100},
                                    {title:"기기유형",   field:"cntnDvcTycd", headerHozAlign:"center", hozAlign:"center", width:90,   minWidth:80},
                                    {title:"브라우저",   field:"cntnBrwsr",   headerHozAlign:"center", hozAlign:"left",   width:160,  minWidth:120},
                                    {title:"활동일시",   field:"actvDttm",    headerHozAlign:"center", hozAlign:"center", width:140,  minWidth:130},
                                    {title:"세션시작",   field:"sessSdttm",   headerHozAlign:"center", hozAlign:"center", width:140,  minWidth:130},
                                    {title:"세션종료",   field:"sessEdttm",   headerHozAlign:"center", hozAlign:"center", width:140,  minWidth:130}
                                ]
                            });
                        </script>
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
