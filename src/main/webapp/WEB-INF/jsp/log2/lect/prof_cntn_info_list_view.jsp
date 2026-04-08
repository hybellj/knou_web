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
        // 사용값
        var SEARCH_TEXT	    = '<c:out value="${lectCntnInfoVO.searchText}" />';
        var PAGE_INDEX		= '<c:out value="${lectCntnInfoVO.pageIndex}" />';
        var LIST_SCALE		= '<c:out value="${lectCntnInfoVO.listScale}" />';
        var EPARAM			= '<c:out value="${encParams}" />';

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

            if(!PAGE_INDEX) {
                PAGE_INDEX = 1;
            }

            if(!LIST_SCALE) {
                LIST_SCALE = 10;
            }
        });

        /* ============================================
         * 검색 실행
         * - 검색 조건이 1개라도 빠지면 실행하지 않음
         * ============================================ */
        function listPaging(pageIndex) {
            PAGE_INDEX = pageIndex;

            var searchFrom = UiComm.getDateTimeVal("dateSt", "timeSt") + "00";  // 14자리
            var searchTo   = UiComm.getDateTimeVal("dateEd", "timeEd") + "59";  // 14자리
            var userTycd   = $("input[name='userTycd']:checked").val();

            // 필수 조건 검증
            if (!searchFrom || searchFrom.length < 14) {
                UiComm.showMessage("시작 기간을 입력하세요.", "warning");
                return;
            }
            if (!searchTo || searchTo.length < 14) {
                UiComm.showMessage("종료 기간을 입력하세요.", "warning");
                return;
            }
            if (!userTycd) {
                UiComm.showMessage("사용자구분을 선택하세요.", "warning");
                return;
            }

            var param = {
                sbjctId    : '${lectCntnInfoVO.sbjctId}',
                searchFrom : searchFrom,
                searchTo   : searchTo,
                userTycd   : userTycd,
                searchText : $("#searchValue").val(),
                pageIndex  : pageIndex,
                listScale  : $("#listScale").val()
            };

            UiComm.showLoading(true);

            ajaxCall("/log2/profSbjctStngCntnInfoListAjax.do", param, function(data) {
                if (data.result > 0) {
                    var dataList = createListHtml(data.returnList || [], data.pageInfo);
                    logActvTable.clearData();
                    logActvTable.replaceData(dataList);
                    logActvTable.setPageInfo(data.pageInfo);
                } else {
                    logActvTable.clearData();
                    UiComm.showMessage(data.message, "error");
                }
            }, function() {
                logActvTable.clearData();
                UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
            }, true);
        }

        /* 목록 데이터 생성 */
        function createListHtml(list, pageInfo) {
            let dataList = [];
            list.forEach(function(v) {
                var lineNo = pageInfo.totalRecordCount - v.lineNo + 1;

                let col0 = "";
                let colLabel = "";
                col0 = lineNo;

                dataList.push({
                    no          : col0,
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
                                <span class="item_tit"><label for="dateSt"><spring:message code="common.period"/></label></span><%--기간--%>
                                <div class="itemList">
                                    <div class="date_area">
                                        <input id="dateSt" type="text" name="dateSt" class="datepicker" timeId="timeSt" toDate="dateEd" value="${fn:substring(lectCntnInfoVO.searchFrom,0,8)}" required="true">
                                        <input id="timeSt" type="text" name="timeSt" class="timepicker" dateId="dateSt" value="${fn:substring(lectCntnInfoVO.searchFrom,8,12)}" required="true">
                                        <span class="txt-sort">~</span>
                                        <input id="dateEd" type="text" name="dateEd" class="datepicker" timeId="timeEd" fromDate="dateSt" value="${fn:substring(lectCntnInfoVO.searchTo,0,8)}" required="true">
                                        <input id="timeEd" type="text" name="timeEd" class="timepicker" dateId="dateEd" value="${fn:substring(lectCntnInfoVO.searchTo,8,12)}" required="true">
                                    </div>
                                </div>
                            </div>

                            <%-- 과목 (현재 강의실 고정) --%>
                            <div class="item">
                                <span class="item_tit"><label><spring:message code="common.subject"/></label></span><%--과목--%>
                                <div class="itemList">
                                    <select class="form-select wide" id="sbjctId" name="sbjctId" disabled>
                                        <option value="<c:out value='${lectCntnInfoVO.sbjctId}' />" selected><c:out value='${lectCntnInfoVO.sbjctnm ? lectCntnInfoVO.sbjctnm : lectCntnInfoVO.sbjctId}' /> </option>
                                    </select>
                                </div>
                            </div>
                            <%-- 사용자구분 (필수) --%>
                            <div class="item">
                                <span class="item_tit"><label></label><spring:message code="msg.label.slide.usertype"/></span><%--사용자구분--%>
                                <div class="itemList">
                                    <span class="custom-input">
                                        <input type="radio" name="userTycd" id="userTycdStd"  value="STDNT"  checked>
                                        <label for="userTycdStd"><spring:message code="common.label.students"/></label><%--수강생--%>
                                    </span>
                                    <span class="custom-input ml5">
                                        <input type="radio" name="userTycd" id="userTycdProf" value="PROF">
                                        <label for="userTycdProf"><spring:message code="common.professor"/></label><%--교수--%>
                                    </span>
                                    <span class="custom-input ml5">
                                        <input type="radio" name="userTycd" id="userTycdTut"  value="TUT">
                                        <label for="userTycdTut"><spring:message code="common.label.tutor"/></label><%--튜터--%>
                                    </span>
                                    <span class="custom-input ml5">
                                        <input type="radio" name="userTycd" id="userTycdAssi" value="ASSI">
                                        <label for="userTycdAssi"><spring:message code="common.teaching.assistant"/></label><%--조교--%>
                                    </span>
                                </div>
                            </div>

                            <%-- 검색어 (선택) --%>
                            <div class="item">
                                <span class="item_tit"><label for="searchValue"><spring:message code="common.search.keyword"/></label></span><%--검색어--%>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" id="searchValue"
                                           placeholder="대표아이디 / 학번(교번) / 이름"
                                           onkeydown="if(event.keyCode==13) listPaging(1)">
                                </div>
                            </div>

                            <div class="button-area">
                                <button type="button" class="btn search" onclick="listPaging(1)"><spring:message code="common.button.search"/></button><%--검색--%>
                            </div>
                        </div>
                        <!-- //search typeA -->

                        <input type="hidden" id="listScale" value="20">

                        <div class="board_top">
                            <h3 class="board-title"><spring:message code="common.button.list"/></h3><%--목록--%>
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
                                {title:"No",                                                field:"no",          headerHozAlign:"center", hozAlign:"center", width:55,  minWidth:55},
                                {title:"<spring:message code='common.year'/>",      field:"sbjctYr",     headerHozAlign:"center", hozAlign:"center", width:60,  minWidth:60},   /*년도*/
                                {title:"<spring:message code='common.term'/>",      field:"sbjctSmstr",  headerHozAlign:"center", hozAlign:"center", width:55,  minWidth:55},   /*학기*/
                                {title:"<spring:message code='common.label.org'/>",      field:"orgnm",       headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:70},   /*기관*/
                                {title:"<spring:message code='common.dept_name'/>",      field:"deptNm",      headerHozAlign:"center", hozAlign:"center", width:90,  minWidth:80},   /*학과*/
                                {title:"<spring:message code='common.subject'/>",      field:"sbjctnm",     headerHozAlign:"center", hozAlign:"left",   width:0, minWidth:260},  /*과목*/
                                {title:"<spring:message code='user.title.userinfo.manage.userrprsid'/>", field:"userRprsId",  headerHozAlign:"center", hozAlign:"center", width:110, minWidth:90},   /*대표아이디*/
                                {title:"<spring:message code='common.label.student.number'/>/<spring:message code='common.label.eduno'/>",  field:"stdntNo",     headerHozAlign:"center", hozAlign:"center", width:100, minWidth:90},  /*학번/교번*/
                                {title:"<spring:message code='common.name'/>",      field:"usernm",      headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:70}, /*이름*/
                                {title:"화면",      field:"",    headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:70}, /*화면*/
                                {title:"<spring:message code='common.menu'/>",      field:"userReqMenu", headerHozAlign:"center", hozAlign:"left",   width:160, minWidth:120},    /*메뉴*/
                                {title:"<spring:message code='common.label.action.type'/>",   field:"",  headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:200}, /*액션구분*/
                                {title:"<spring:message code='common.label.action.cts'/>",   field:"userReqCts",  headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:200}, /*액션내용*/
                                {title:"<spring:message code='common.label.connect'/><spring:message code='common.date_time'/>",         field:"actvDttm",    headerHozAlign:"center", hozAlign:"center", width:150, minWidth:140}, /*접속일시*/
                                {title:"<spring:message code='common.label.connect'/>IP",    field:"cntnIp",      headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100} /*접속IP*/
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
