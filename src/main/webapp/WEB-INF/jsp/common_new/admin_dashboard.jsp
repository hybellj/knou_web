<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>
<script type="text/javascript">
    let EPARAM = '<c:out value="${encParams}" />';
</script>

<body class="admin">
<div id="wrap" class="main">
    <!-- common header -->
    <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>
    <!-- //common header -->

    <!-- admin -->
    <main class="common">

        <!-- gnb -->
        <%@ include file="/WEB-INF/jsp/common_new/admin_aside.jsp" %>
        <!-- //gnb -->

        <!-- content -->
        <div id="content" class="content-wrap common">
            <%-- <div class="admin_sub_top">
                <div class="date_info">
                    <i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span><spring:message code="common.label.dashboard"/>대시보드
                </div>
            </div> --%>
            <div class="admin_sub">
                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title">대시보드</h2>
                        <div class="navi_bar">
                            <ul>
                                <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                <li><span class="current">대시보드</span></li>
                            </ul>
                        </div>
                    </div>

                    <%--학생 접속현황--%>
                    <div class="row" id="onlineSts">
                        <div class="box">
                            <div class="listTab">
                                <ul id="onlineStsTab">
                                    <li class="select"><a href="#"><spring:message code="dashboard.connect.stats.std"/><%--학생 접속현황--%> </a></li>
                                    <li><a href="#"><spring:message code="dashboard.connect.stats.prof"/><%--교수/튜터 접속현황--%></a></li>
                                </ul>
                            </div>
                                <div class="inner_boxA" id="cntnCntSummary">
                                </div>

                                <div class="board_top">
                                    <select class="form-select" name="dgrsYr" onchange="changeSmstrChrt('onlineSts')">
                                        <option value=""><spring:message code="std.label.year"/></option><!-- 년도 -->
                                        <c:forEach var="item" items="${filterOptions.yearList }">
                                            <option value="${item }" ${item eq filterOptions.curYear ? 'selected' : '' }>${item }</option>
                                        </c:forEach>
                                    </select>
                                    <select class="form-select" name="dgrsSmstrChrt">
                                        <option value=""><spring:message code="crs.label.open.term"/></option><!-- 개설학기 -->
                                        <c:forEach var="list" items="${filterOptions.smstrChrtList }">
                                            <option smstrChrtnm="${list.smstrChrtId }">${list.smstrChrtnm }</option>
                                        </c:forEach>
                                    </select>
                                    <select class="form-select" name="orgId"><!-- 기관 -->
                                        <option value="">기관</option>
                                        <c:forEach var="list" items="${filterOptions.orgList }">
                                            <option value="${list.orgId }" ${list.orgId eq filterOptions.orgId ? 'selected' : '' }>${list.orgnm }</option>
                                        </c:forEach>
                                    </select>
                                    <select class="form-select" name="deptId" onchange="changeSbjctList()">
                                        <option value=""><spring:message code="exam.label.dept" /></option><!-- 학과 -->
                                        <c:forEach var="list" items="${filterOptions.deptList }">
                                            <option value="${list.deptId }">${list.deptnm }</option>
                                        </c:forEach>
                                    </select>
                                    <select class="form-select wide" name="sbjctId">
                                        <option value=""><spring:message code="common.subject" /></option><!-- 과목 -->
                                    </select>
                                    <input class="form-control wide" type="text" name="searchValue" value="" placeholder="이름/과목 입력">
                                    <input type="hidden" id="userTycd">
                                    <button type="button" class="btn basic icon search" aria-label="검색" onclick="listOnlineSts()"><i class="icon-svg-search"></i></button>

                                    <div class="right-area">
                                        <button type="button" class="btn basic">메시지 보내기</button>
                                    </div>
                                </div>

                                <!--table-type-->
                                <div class="table-wrap" id="stdOnlineListTab">
                                    <div id="stdOnlineList"></div>
                                </div>

                                <div class="table-wrap" id="profOnlineListTab">
                                    <div id="profOnlineList"></div>
                                </div>
                                <script type="text/javascript">
                                    let stdOnlineListTable;
                                    let profOnlineListTable;

                                    $(function () {
                                        stdOnlineListTable = UiTable("stdOnlineList", {
                                            lang: "ko",
                                            table: "list",
                                            columns: [
                                                {title: "<spring:message code='common.no'/>", field: "no", headerHozAlign:"center", hozAlign:"center", width: 50, minWidth: 50},
                                                {title: "학생구분",  field: "stdntGbncd", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100},
                                                {title: "기관",  field: "orgnm", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100},
                                                {title: "학과", field: "deptnm", headerHozAlign:"center", hozAlign:"center", width: 120, minWidth: 120},
                                                {title: "과목(분반)",field: "sbjctnm",headerHozAlign: "center", hozAlign: "left", width: 0, minWidth: 180},
                                                {title: "아이디",  field: "userId", headerHozAlign: "center", hozAlign: "center", width: 90, minWidth: 90},
                                                {title: "학번",  field: "stdntNo", headerHozAlign: "center", hozAlign: "center", width: 90, minWidth: 90},
                                                {title: "이름",  field: "usernm", headerHozAlign: "center", hozAlign: "center", width: 90, minWidth: 90},
                                                {title: "학년",  field: "scyr", headerHozAlign: "center", hozAlign: "center", width: 50, minWidth: 50},
                                                {title: "휴대폰",  field: "cntct", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120},
                                                {title: "접속일시",  field: "actvDttm", headerHozAlign: "center", hozAlign: "center", width: 150, minWidth: 150}
                                            ],
                                            height: 255
                                        });

                                        listOnlineSts("STDNT");

                                        profOnlineListTable = UiTable("profOnlineList", {
                                            lang: "ko",
                                            table: "list",
                                            columns: [
                                                {title: "<spring:message code='common.no'/>", field: "no", headerHozAlign:"center", hozAlign:"center", width: 50, minWidth: 50},
                                                {title: "구분",  field: "profGbncd", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100},
                                                {title: "기관",  field: "orgnm", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100},
                                                {title: "학과", field: "deptnm", headerHozAlign:"center", hozAlign:"center", width: 120, minWidth: 120},
                                                {title: "과목(분반)",field: "sbjctnm",headerHozAlign: "center", hozAlign: "left", width: 0, minWidth: 180},
                                                {title: "아이디",  field: "userId", headerHozAlign: "center", hozAlign: "center", width: 90, minWidth: 90},
                                                {title: "이름",  field: "usernm", headerHozAlign: "center", hozAlign: "center", width: 90, minWidth: 90},
                                                {title: "휴대폰",  field: "cntct", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120},
                                                {title: "접속일시",  field: "actvDttm", headerHozAlign: "center", hozAlign: "center", width: 150, minWidth: 150}
                                            ],
                                            height: 255
                                        });
                                    });

                                    // 학생 접속현황 목록 조회
                                    function listOnlineSts(userTycd) {
                                        UiComm.showLoading(true);
                                        let userType = userTycd || $("#userTycd").val()
                                        let param = {
                                            encParams   : EPARAM,
                                            dgrsYr      : $('#onlineSts [name=dgrsYr]').val() || '',
                                            dgrsSmstrChrt   : $('#onlineSts [name=dgrsSmstrChrt]').val() || '',
                                            orgId       : $('#onlineSts [name=orgId]').val() || '',
                                            deptId      : $('#onlineSts [name=deptId]').val() || '',
                                            sbjctId     : $('#onlineSts [name=sbjctId]').val() || '',
                                            searchValue : $('#onlineSts [name=searchValue]').val() || '',
                                            userTycd    : userType
                                        }

                                        $.ajax({
                                            url: "/log2/admUsrCntnStsListAjax.do",
                                            type: "GET",
                                            data: param,
                                            headers: {"X-Requested-With": "XMLHttpRequest"},
                                            success: function (data) {
                                                if (data.result > 0) {
                                                    // 사용자 접속 인원 통계
                                                    let returnSubList = data.returnListSub || [];
                                                    setCntnCnt(returnSubList, userType);

                                                    // 사용자 접속 목록
                                                    let returnList = data.returnList || [];

                                                    // 테이블 데이터 세팅
                                                    let dataList;
                                                    let table;

                                                    if (userType === 'STDNT') {
                                                        // table = stdOnlineListTable;
                                                        dataList = createOnlineListHTML(returnList, userType);
                                                        stdOnlineListTable.clearData();
                                                        stdOnlineListTable.replaceData(dataList);
                                                    } else {
                                                        // table = profOnlineListTable;
                                                        dataList = createOnlineListHTML(returnList, userType);
                                                        profOnlineListTable.clearData();
                                                        profOnlineListTable.replaceData(dataList);
                                                    }
                                                    // dataList = createOnlineListHTML(returnList, userType);
                                                    // table.clearData();
                                                    // table.replaceData(dataList);
                                                }else {
                                                    UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
                                                }
                                            },error: function(xhr, status, error) {
                                                UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
                                            },complete: function () {
                                                if (userType === 'STDNT') {
                                                    $('#stdOnlineListTab').show();
                                                    $('#profOnlineListTab').hide();
                                                }else {
                                                    $('#stdOnlineListTab').hide();
                                                    $('#profOnlineListTab').show();
                                                }

                                                $("#userTycd").val(userType);
                                                UiComm.showLoading(false);
                                            }
                                        });

                                        // 테이블 그리기
                                        function createOnlineListHTML(list, userTycd) {
                                            let dataList = [];

                                            if (userTycd === 'STDNT') {
                                                list.forEach(item => {
                                                    dataList.push({
                                                        no: item.lineNo,
                                                        stdntGbncd: "대학원생",
                                                        orgnm: item.orgnm,
                                                        deptnm: item.deptnm,
                                                        sbjctnm: item.sbjctnm,
                                                        userId: item.userId,
                                                        stdntNo: item.stdntNo,
                                                        usernm: item.usernm,
                                                        scyr: item.scyr,
                                                        cntct: item.cntct,
                                                        actvDttm: item.actvDttm
                                                    })
                                                });
                                            } else {
                                                list.forEach(item => {
                                                    dataList.push({
                                                        no: item.lineNo,
                                                        orgnm: item.orgnm,
                                                        deptnm: item.deptnm,
                                                        sbjctnm: item.sbjctnm,
                                                        userId: item.userId,
                                                        usernm: item.usernm,
                                                        cntct: item.cntct,
                                                        actvDttm: item.actvDttm
                                                    })
                                                });
                                            }

                                            return dataList;
                                        }
                                    }
                                </script>
                                <!--//table-type-->
                        </div>
                    </div>

                    <%--전체 시스템 오류 현황--%>
                    <div class="row" id="sysErr">
                        <div class="box">
                            <div class="board_top">
                                <h3 class="board-title">전체 시스템 오류현황</h3>
                                <span class="total_num">총 <strong id="totSysErrCnt">114</strong>건</span>

                                <div class="right-area">
                                    <button type="button" class="btn type2" onsubmit="return false;" style="font-size: 1.4rem">엑셀 다운로드</button>
                                </div>
                            </div>
                            <form id="sysErrForm" class="board_top">
                                <select class="form-select" name="dgrsYr" onchange="changeSmstrChrt('sysErr')">
                                    <option value=""><spring:message code="std.label.year"/></option><!-- 년도 -->
                                    <c:forEach var="item" items="${filterOptions.yearList }">
                                        <option value="${item }" ${item eq filterOptions.curYear ? 'selected' : '' }>${item }</option>
                                    </c:forEach>
                                </select>
                                <select class="form-select" name="dgrsSmstrChrt">
                                    <option value=""><spring:message code="crs.label.open.term"/></option><!-- 개설학기 -->
                                    <c:forEach var="list" items="${filterOptions.smstrChrtList }">
                                        <option smstrChrtnm="${list.smstrChrtId}">${list.smstrChrtnm }</option>
                                    </c:forEach>
                                </select>
                                <select class="form-select" name="orgId"><!-- 기관 -->
                                    <option value="">과정(테넌시)</option>
                                    <c:forEach var="list" items="${filterOptions.orgList }">
                                        <option value="${list.orgId }" ${list.orgId eq filterOptions.orgId ? 'selected' : '' }>${list.orgnm }</option>
                                    </c:forEach>
                                </select>
                                <div class="date_area">
                                    <input id="dateSt" type="text" name="dateSt" placeholder="시작일" class="datepicker" timeId="timeSt" toDate="dateEd">
                                    <input id="timeSt" type="text" name="timeSt" placeholder="시작시간" class="timepicker" dateId="dateSt">
                                    <span class="txt-sort">~</span>
                                    <input id="dateEd" type="text" name="dateEd" placeholder="종료일" class="datepicker" timeId="timeEd" fromDate="dateSt">
                                    <input id="timeEd" type="text" name="timeEd" placeholder="종료시간" class="timepicker" dateId="dateEd">
                                    <input type="hidden" id="searchFrom" name="searchFrom" value=""/>
                                    <input type="hidden" id="searchTo" name="searchTo" value=""/>
                                </div>

                                <input class="form-control wide" type="text" name="searchValue" value="" placeholder="이름/과목 입력">
                                <input type="hidden" name="encParams" value="${encParams}">
                                <button type="button" class="btn basic icon search" aria-label="검색" onsubmit="return false;" onclick="onSysErrSearch()"><i class="icon-svg-search"></i></button>
                            </form>

                            <div class="table-wrap">
                                <div class="sysErrList" id="sysErrList"></div>
                            </div>

                            <script type="text/javascript">
                                let sysErrListTable;

                                $(function () {
                                    sysErrListTable = UiTable("sysErrList", {
                                        lang: "ko",
                                        table: "list",
                                        height: 300,
                                        columns: [
                                            {title: "번호", field: "no", headerHozAlign:"center", hozAlign:"center", width: 50, minWidth: 50},
                                            {title: "기관",  field: "orgnm", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120},
                                            {title: "학과",  field: "deptnm", headerHozAlign: "center", hozAlign: "center", width: 140, minWidth: 140},
                                            {title: "과목(분반)",  field: "sbjctnm", headerHozAlign: "center", hozAlign: "center", width: 180, minWidth: 180},
                                            {title: "일시",  field: "regDttm", headerHozAlign: "center", hozAlign: "center", width: 140, minWidth: 140},
                                            {title: "학번/사번",  field: "stdntNo", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100},
                                            {title: "이름",  field: "usernm", headerHozAlign: "center", hozAlign: "center", width: 80, minWidth: 80},
                                            {title: "오류페이지",  field: "sysErrPageNm", headerHozAlign: "center", hozAlign: "left", width: 0, minWidth: 180},
                                            {title: "오류내용",  field: "sysErrMsgId", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100}    // 컬럼정보
                                        ]
                                    });

                                    onSysErrSearch();
                                });

                                // 시스템 오류현황 조회
                                function onSysErrSearch() {
                                    UiComm.showLoading(true);

                                    let searchFrom = UiComm.getDateTimeVal("dateSt", "timeSt");
                                    let searchTo = UiComm.getDateTimeVal("dateEd", "timeEd");

                                    $("#searchFrom").val(searchFrom);
                                    $("#searchTo").val(searchTo);

                                    $.ajax({
                                        url: "/system/manage/admExceptionListAjax.do",
                                        data: $("#sysErrForm").serialize(),
                                        type: "GET",
                                        success: function (data) {

                                            if (data.result > 0) {
                                                let returnList = data.returnList || [];

                                                // 테이블 데이터 세팅
                                                let dataList = createListHTML(returnList);
                                                sysErrListTable.clearData();
                                                sysErrListTable.replaceData(dataList);

                                                $("#totSysErrCnt").text(dataList.length);
                                            } else {
                                                UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
                                            }
                                        },
                                        error: function(xhr, status, error) {
                                            UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
                                        },
                                        complete: function (){
                                            UiComm.showLoading(false);
                                        }
                                    });
                                }

                                // 테이블그리기
                                function createListHTML(list) {
                                    let dataList = [];

                                    list.forEach(function(item, i) {
                                        dataList.push({
                                            no: (list.length - i),
                                            orgnm: item.orgnm,
                                            deptnm: item.deptnm,
                                            sbjctnm: item.sbjctnm,
                                            regDttm: item.regDttm,
                                            stdntNo: item.stdntNo,
                                            usernm: item.usernm,
                                            sysErrPageNm: item.sysErrPageNm,
                                            sysErrMsgId:
                                                `<button type="button"
                                                    class="btn basic small"
                                                    data-modal-open="modal1"
                                                    onclick="goDetail('\${item.sysErrMsgId}')">
                                                    상세보기
                                                </button>`
                                        })
                                    });

                                    return dataList;
                                }

                                /* 상세보기 */
                                function goDetail(sysErrMsgId) {
                                    if(!sysErrMsgId) {
                                        return alert("에러 메시지 ID가 없습니다.");
                                    }

                                    modalClear();

                                    let url = "/system/manage/sysErrDtl.do";
                                    let param = { sysErrMsgId: sysErrMsgId };

                                    $.ajax({
                                        url: url,
                                        type: "GET",
                                        data: param,
                                        dataType: "json",
                                        success: function(data) {
                                            if (data.result > 0) {
                                                let errData = data.returnVO;

                                                $("#errLocation").text(errData.errLocation);

                                                let errCts = "";
                                                errCts += "<pre>" + errData.regDttm + "<br/>";
                                                errCts += errData.errType + "<br/>";
                                                errCts += errData.sysErrMsgCts + "<br/>";
                                                errCts += "</pre>";

                                                $(".error_txt").html(errCts);

                                            } else {
                                                alert(data.message || "상세 정보를 조회할 수 없습니다.");
                                            }
                                        },
                                        error: function(xhr, status, error) {
                                            alert("에러가 발생했습니다!");
                                        }
                                    });
                                }
                            </script>

                            <!--//table-type-->
                        </div>
                    </div>

                    <%--공지들--%>
                    <div class="row-grid">
                        <div class="box">
                            <div class="box_title">
                                <h3 class="h3"><spring:message code="dashboard.notice.system"/> <%--시스템공지--%></h3>
                                <div class="btn-wrap">
                                    <a href="#0" class="btn_more"><i class="xi-plus"></i></a>
                                </div>
                            </div>
                            <div class="box_content">
                                <ul class="dash_item_listA">
                                    <c:forEach items="${sysNoticeList}" var="item">
                                    <li>
                                        <a href="#0" class="item_txt">
                                            <p class="tit">${item.atclTtl}</p>
                                            <p class="desc">
                                                <span class="name">${item.usernm}</span>
                                                <span class="date"><uiex:formatDate value="${item.regDttm}" type=""/></span>
                                            </p>
                                        </a>
                                        <div class="state">
                                            <span class="view_num"><spring:message code="bbs.label.view"/> ${item.inqCnt}</span>
                                        </div>
                                    </li>
                                    </c:forEach>
                                    <c:if test="${empty sysNoticeList}">
                                        <div style="text-align: center;">
                                            <small><spring:message code="common.nodata.msg"/><%--등록된 내용이 없습니다.--%> </small>
                                        </div>
                                    </c:if>
                                </ul>
                            </div>
                        </div>

                        <div class="box">
                            <div class="box_title">
                                <h3 class="h3"><spring:message code="dashboard.all"/><spring:message code="dashboard.notice"/><%--전체 공지사항--%></h3>
                                <div class="btn-wrap">
                                    <a href="#0" class="btn_more"><i class="xi-plus"></i></a>
                                </div>
                            </div>
                            <div class="box_content">
                                <ul class="dash_item_listA">
                                    <c:forEach items="${allNoticeList}" var="item">
                                        <li>
                                            <a href="#0" class="item_txt">
                                                <p class="tit"><span>[${item.orgnm}]</span> ${item.atclTtl}</p>
                                                <p class="desc">
                                                    <span class="date"><uiex:formatDate value="${item.regDttm}" type=""/></span>
                                                </p>
                                            </a>
                                            <div class="state">
                                                <span class="view_num"><spring:message code="bbs.label.view"/>: ${item.inqCnt}</span><%--조회--%>
                                            </div>
                                        </li>
                                    </c:forEach>
                                    <c:if test="${empty allNoticeList}">
                                        <div style="text-align: center;">
                                            <small><spring:message code="common.nodata.msg"/><%--등록된 내용이 없습니다.--%> </small>
                                        </div>
                                    </c:if>
                                </ul>
                            </div>
                        </div>

                        <div class="box">
                            <div class="box_title">
                                <h3 class="h3"><spring:message code="resh.label.home.resh"/> <%--전체 설문--%></h3>
                                <div class="btn-wrap">
                                    <a href="#0" class="btn_more"><i class="xi-plus"></i></a>
                                </div>
                            </div>
                            <div class="box_content">
                                <ul class="dash_item_listA">
                                    <c:forEach items="${allSrvyList}" var="item">
                                        <li>
                                            <a href="#0" class="item_txt">
                                                <p class="tit">${item.srvyTtl}</p>
                                                <p class="desc">
                                                    <span class="name">${item.srvySts}</span>
                                                    <span class="date"><uiex:formatDate value="${item.regDttm}" type=""/></span>
                                                </p>
                                            </a>
                                            <div class="state">
                                                <span class="view_num"><spring:message code="dashboard.act"/>: ${item.ptcpCnt}</span><%--참여--%>
                                            </div>
                                        </li>
                                    </c:forEach>
                                    <c:if test="${empty allSrvyList}">
                                        <div style="text-align: center;">
                                            <small><spring:message code="common.nodata.msg"/><%--등록된 내용이 없습니다.--%> </small>
                                        </div>
                                    </c:if>
                                </ul>
                            </div>
                        </div>

                    </div>

                    <%--과목별 학습현황--%>
                    <div class="row" id="lrnSts">
                        <div class="box">
                            <div class="listTab">
                                <ul>
                                    <li class="select"><a>과목별 학습현황</a></li>
                                    <li><a>학생별 학습현황</a></li>
                                    <li><a>사용자 검색</a></li>
                                </ul>
                            </div>

                            <form class="board_top" id="lrnStsForm">
                                <select class="form-select" name="dgrsYr" onchange="changeSmstrChrt('lrnSts')">
                                    <option value=""><spring:message code="std.label.year"/></option><!-- 년도 -->
                                    <c:forEach var="item" items="${filterOptions.yearList }">
                                        <option value="${item }" ${item eq filterOptions.curYear ? 'selected' : '' }>${item }</option>
                                    </c:forEach>
                                </select>
                                <select class="form-select" name="dgrsSmstrChrt">
                                    <option value=""><spring:message code="crs.label.open.term"/></option><!-- 개설학기 -->
                                    <c:forEach var="list" items="${filterOptions.smstrChrtList }">
                                        <option smstrChrtnm="${list.smstrChrtId }">${list.smstrChrtnm }</option>
                                    </c:forEach>
                                </select>
                                <select class="form-select" name="orgId"><!-- 기관 -->
                                    <option value="">기관</option>
                                    <c:forEach var="list" items="${filterOptions.orgList }">
                                        <option value="${list.orgId }" ${list.orgId eq filterOptions.orgId ? 'selected' : '' }>${list.orgnm }</option>
                                    </c:forEach>
                                </select>
                                <select class="form-select" name="deptId">
                                    <option value=""><spring:message code="exam.label.dept" /></option><!-- 학과 -->
                                    <c:forEach var="list" items="${filterOptions.deptList }">
                                        <option value="${list.deptId }">${list.deptnm }</option>
                                    </c:forEach>
                                </select>
                                <input class="form-control wide" type="text" name="searchValue" value="" placeholder="과목명/교수명/과목코드 입력">
                                <input type="hidden" name="encParams" value="${encParams}">
                                <input type="hidden" name="searchTab" value="sbjctLrnStsTab">
                                <button type="button" class="btn basic icon search" aria-label="검색" onclick="listLrnStsRow()"><i class="icon-svg-search"></i></button>

                                <div class="right-area">
                                    <button type="button" class="btn basic">메시지 보내기</button>
                                    <button type="button" class="btn type2">엑셀 다운로드</button>
                                </div>
                            </form>

                            <!--table-type-->
                            <%--과목별 학습현황--%>
                            <div class="table-wrap" id="sbjctLrnStsTab">
                                <div id="sbjctLrnStsList"></div>
                            </div>

                            <%-- 학생별 학습현황 --%>
                            <div class="table-wrap" id="stdLrnStsTab">
                                <div id="stdLrnStsList"></div>
                            </div>

                            <%-- 사용자 검색 --%>
                            <div class="table-wrap" id="userListTab">
                                <div id="userList"></div>
                            </div>

                            <script type="text/javascript">
                                let sbjctLrnStsListTable;
                                let stdLrnStsListTable;
                                let userListTable;

                                $(function () {
                                    sbjctLrnStsListTable = UiTable("sbjctLrnStsList", {
                                        lang: "ko",
                                        table: "list",
                                        columns: [
                                            {title: "<spring:message code='common.no'/>", field: "no", headerHozAlign:"center", hozAlign:"center", width: 50, minWidth: 50}, // 번호
                                            {title: "과정<br/>(테넌시)",  field: "orgnm", headerHozAlign: "left", hozAlign: "left", width: 100, minWidth: 100, headerSort:true}, // 과정(테넌시)
                                            {title: "학과", field: "deptnm", headerHozAlign:"left", hozAlign:"left", width: 120, minWidth: 120, headerSort:true}, // 학과
                                            {title: "과목아이디",field: "sbjctId",headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 140, headerSort:true}, // 과목아이디
                                            {title: "과목 (분반)",field: "sbjctnm",headerHozAlign: "left", hozAlign: "left", width: 0, minWidth: 180, headerSort:true}, // 과목명(분반)
                                            {title: "교수",  field: "profnm", headerHozAlign: "center", hozAlign: "center", width: 70, minWidth: 70, headerSort:true}, // 교수
                                            {title: "튜터",  field: "tutnm", headerHozAlign: "center", hozAlign: "center", width: 70, minWidth: 70, headerSort:true}, // 튜터
                                            {title: "수강",  field: "stdCnt", headerHozAlign: "center", hozAlign: "center", width: 50, minWidth: 50}, //수강
                                            {title: "청강",  field: "auditCnt", headerHozAlign: "center", hozAlign: "center", width: 50, minWidth: 50}, // 청강
                                            {title: "강의계획서",  field: "lctrPlandoc", headerHozAlign: "center", hozAlign: "center", width: 90, minWidth: 90}, // 강의 계획서
                                            {title:"강의<br/>공지", field:"noticeCnt", headerHozAlign:"center", hozAlign:"center", width:50, minWidth: 50}, // 강의공지
                                            {title:"<spring:message code='dashboard.qna'/>", field:"qnaCnt", headerHozAlign:"center", hozAlign:"center", width:50, minWidth: 50}, // Q&A
                                            {title:"1:1<br/>상담", field:"bbs1on1Cnt", headerHozAlign:"center", hozAlign:"center", width:50, minWidth: 50}, // 1:1상담
                                            {title:"<spring:message code='common.label.tasks'/><br/><spring:message code='common.label.evaluation'/>", field:"asmtCnt", headerHozAlign:"center", hozAlign:"center", width:50, minWidth: 50}, // 과제평가
                                            {title:"<spring:message code='common.label.discussion'/><br/><spring:message code='common.label.evaluation'/>", field:"dscsCnt", headerHozAlign:"center", hozAlign:"center", width:50, minWidth: 50}, // 토론평가
                                            {title:"<spring:message code='common.label.question'/><br/><spring:message code='common.label.evaluation'/>", field:"quizCnt", headerHozAlign:"center", hozAlign:"center", width:50, minWidth: 50}, // 퀴즈평가
                                            {title:"<spring:message code='common.label.resh'/><br/><spring:message code='common.label.evaluation'/>", field:"srvyCnt", headerHozAlign:"center", hozAlign:"center", width:50, minWidth: 50}, // 설문평가
                                            {title:"수시<br/>평가", field:"srvyCnt", headerHozAlign:"center", hozAlign:"center", width:50, minWidth: 50}, // 설문평가
                                            {title:"<spring:message code='dashboard.exam_mid'/>", field:"midExam", headerHozAlign:"center", hozAlign:"center", width:190}, // 중간고사
                                            {title:"<spring:message code='dashboard.exam_end'/>", field:"lstExam", headerHozAlign:"center", hozAlign:"center", width:190} // 기말고사
                                        ]
                                        , height: 255
                                        , rowHeight: 50
                                    });

                                    stdLrnStsListTable = UiTable("stdLrnStsList", {
                                        lang: "ko",
                                        table: "list",
                                        columns: [
                                            {title: "<spring:message code='common.no'/>", field: "no", headerHozAlign:"center", hozAlign:"center", width: 50, minWidth: 50}, //번호
                                            {title: "기관",  field: "orgnm", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100}, // 기관
                                            {title: "학번",  field: "stdntNo", headerHozAlign: "center", hozAlign: "center", width: 90, minWidth: 90}, // 학번
                                            {title: "학과", field: "deptnm", headerHozAlign:"center", hozAlign:"center", width: 120, minWidth: 120, headerSort:true}, // 학과
                                            {title: "과목 (분반)",field: "sbjctnm",headerHozAlign: "center", hozAlign: "left", width: 0, minWidth: 180, headerSort:true}, // 과목명(분반)
                                            {title: "교수",  field: "profnm", headerHozAlign: "center", hozAlign: "center", width: 90, minWidth: 90, headerSort:true}, // 교수
                                            {title: "튜터",  field: "tutnm", headerHozAlign: "center", hozAlign: "center", width: 90, minWidth: 90, headerSort:true}, // 튜터
                                            {title: "이름",  field: "usernm", headerHozAlign: "center", hozAlign: "center", width: 90, minWidth: 90}, // 이름
                                            {title: "학년",  field: "scyr", headerHozAlign: "center", hozAlign: "center", width: 90, minWidth: 90}, // 학년
                                            {
                                                title:"<spring:message code='dashboard.attend.status'/>", headerHozAlign:"center",
                                                columns: [
                                                    {title:"출석", field:"atnd",   headerHozAlign:"center",  hozAlign:"center", width:40, minWidth: 40}, // 출석
                                                    {title:"지각", field:"late",   headerHozAlign:"center",  hozAlign:"center", width:40, minWidth: 40}, // 지각
                                                    {title:"결석", field:"absnce", headerHozAlign:"center",  hozAlign:"center", width:40, minWidth: 40}, // 결석
                                                    {title:"주차", field:"weekCnt",headerHozAlign:"center", hozAlign:"center", width:40, minWidth: 40}, // 주차
                                                ],
                                            },
                                            {title:"<spring:message code='dashboard.prog'/>",       field:"lrnPrgrt",   headerHozAlign:"center", hozAlign:"center", width:40, minWidth:80}, // 진도율
                                            {title:"<spring:message code='dashboard.cor.exam'/>",   field:"examCnt",    headerHozAlign:"center", hozAlign:"center", width:40, minWidth:60}, // 시험
                                            {title:"<spring:message code='dashboard.qna'/>",        field:"qnaCnt",     headerHozAlign:"center", hozAlign:"center", width:40, minWidth:60}, // Q&A
                                            {title:"<spring:message code='dashboard.cor.councel'/>",field:"bbs1on1Cnt", headerHozAlign:"center", hozAlign:"center", width:40, minWidth:60}, // 1:1
                                            {title:"<spring:message code='common.label.asmnt'/>",   field:"asmtCnt",    headerHozAlign:"center", hozAlign:"center", width:40, minWidth:60}, // 과제
                                            {title:"<spring:message code='common.label.forum'/>",   field:"dscsCnt",    headerHozAlign:"center", hozAlign:"center", width:40, minWidth:60}, // 토론
                                            {title:"<spring:message code='common.label.question'/>",field:"quizCnt",    headerHozAlign:"center", hozAlign:"center", width:40, minWidth:60}, // 퀴즈
                                            {title:"<spring:message code='common.label.resh'/>",    field:"srvyCnt",    headerHozAlign:"center", hozAlign:"center", width:40, minWidth:60}, // 설문
                                            {title:"<spring:message code='dashboard.seminar'/>",    field:"smnrCnt", headerHozAlign:"center", hozAlign:"center", width:40, minWidth:60} // 세미나
                                            
                                        ],
                                        height: 255
                                    });

                                    userListTable = UiTable("userList", {
                                        lang: "ko",
                                        table: "list",
                                        columns: [
                                            {title: "<spring:message code='common.no'/>", field: "no", headerHozAlign:"center", hozAlign:"center", width: 50, minWidth: 50}, //번호
                                            {title: "기관",  field: "orgnm", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100}, // 기관
                                            {title: "학과/부서", field: "deptnm", headerHozAlign:"center", hozAlign:"center", width: 0, minWidth: 120, headerSort:true}, // 학과/부서
                                            {title: "구분", field: "authrtnm",headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100, headerSort:true}, // 구분
                                            {title: "대표ID",  field: "userRprsId", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120}, // 대표아이디
                                            {title: "이름",  field: "usernm", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120, headerSort:true}, // 이름
                                            {title:"<spring:message code='common.mobile.number'/>", field:"mblPhn", headerHozAlign:"center", hozAlign:"center", width: 0, minWidth:150}, // 휴대전화번호
                                            {title:"<spring:message code='common.email'/>", field:"indvEml", headerHozAlign:"center", width: 0, minWidth:150}, // 이메일
                                            {title:"<spring:message code='user.button.login'/>", field:"login", headerHozAlign:"center", hozAlign:"center", width:120, minWidth:120} // 로그인
                                        ],
                                        height: 255
                                    });

                                    // listLrnSts();
                                    listLrnStsRow();
                                });

                                // 학습현황 행 리스트 조회
                                function listLrnStsRow() {
                                    UiComm.showLoading(true);

                                    let url, table;
                                    let searchTab = $("#lrnSts [name=searchTab]").val() || 'sbjctLrnStsTab';

                                    if (searchTab === 'sbjctLrnStsTab') {
                                        url = "/dashboard/admLrnStsBySbjctListAjax.do";
                                        table = sbjctLrnStsListTable;
                                    }
                                    else if(searchTab === 'stdLrnStsTab') {
                                        url = "/dashboard/admLrnStsByStdListAjax.do";
                                        table = stdLrnStsListTable;
                                    }
                                    else {
                                        url = "/dashboard/admUserListAjax.do";
                                        table = userListTable;
                                    }

                                    $.ajax({
                                        url: url,
                                        type: "GET",
                                        data: $("#lrnStsForm").serialize(),
                                        headers: {"X-Requested-With": "XMLHttpRequest"},
                                        success: function (data) {
                                            if (data.result > 0) {
                                                let returnList = data.returnList || [];

                                                table.clearData();
                                                table.replaceData(createLrnStsTabListHTML(returnList, searchTab));

                                            } else {
                                                UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>", "error"); // 에러 메세지
                                            }
                                        }, error: function (xhr, status, error) {
                                            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error"); // 에러 메세지
                                        }, complete: function () {
                                            $("#sbjctLrnStsTab, #stdLrnStsTab, #userListTab").hide();
                                            $('#'+searchTab).show();

                                            UiComm.showLoading(false);
                                        }
                                    });
                                }

                                // 학습현황 행 테이블 그리기
                                function createLrnStsTabListHTML(list, tabId) {
                                    let dataList = [];

                                    if (tabId === 'sbjctLrnStsTab') {
                                        list.forEach(function (item, i) {
                                            let sbjctnm = item.dvclasNo ? item.sbjctnm + ' (' + item.dvclasNo + '반)' : item.sbjctnm;

                                            let midExamInfo = {
                                                onlnExamYn  : item.midOnlnExamYn,
                                                examSdttm   : item.midExamSdttm,
                                                examMnts    : item.midExamMnts,
                                                mrkOyn      : item.midMrkOyn,
                                                exampprOyn  : item.midExampprOyn,
                                                examCnt     : item.midExamCnt
                                            }

                                            let lstExamInfo = {
                                                onlnExamYn  : item.lstOnlnExamYn,
                                                examSdttm   : item.lstExamSdttm,
                                                examMnts    : item.lstExamMnts,
                                                mrkOyn      : item.lstMrkOyn,
                                                exampprOyn  : item.lstExampprOyn,
                                                examCnt     : item.lstExamCnt
                                            }

                                            dataList.push({
                                                no: i+1,
                                                orgnm: item.orgnm,
                                                deptnm: item.deptnm,
                                                sbjctId: item.sbjctId,
                                                sbjctnm: sbjctnm,
                                                profnm: item.profnm,
                                                tutnm: item.tutnm || '-',
                                                stdCnt: item.stdCnt,
                                                auditCnt: item.auditCnt,
                                                lctrPlandoc: `<button class="btn basic small" type="button">보기</button>`,
                                                noticeCnt: item.noticeCnt,
                                                qnaCnt: item.qnaCnt,
                                                bbs1on1Cnt: item.bbs1on1Cnt,
                                                asmtCnt: item.asmtCnt,
                                                dscsCnt: item.dscsCnt,
                                                quizCnt: item.quizCnt,
                                                srvyCnt: item.srvyCnt,
                                                normalExam: item.normalExamCnt,
                                                midExam: setExamInfo(midExamInfo),
                                                lstExam: setExamInfo(lstExamInfo)
                                            })
                                        });
                                    } else if(tabId === 'stdLrnStsTab') {
                                        list.forEach(function (item, i) {
                                           dataList.push({
                                               no: i+1,
                                               orgnm: item.orgnm,
                                               stdntNo: item.stdntNo,
                                               deptnm: item.deptnm,
                                               sbjctnm: item.sbjctnm,
                                               profnm: item.profnm,
                                               tutnm: item.tutnm,
                                               usernm: item.usernm,
                                               scyr: item.scyr,
                                               atnd: item.atndCnt,
                                               late: item.lateCnt,
                                               absnce: item.absnceCnt,
                                               weekCnt: item.totWkCnt,
                                               lrnPrgrt: `\${item.lrnPrgrt}%`,
                                               examCnt: `\${item.examSbmtCnt}/\${item.examTotCnt}`,
                                               qnaCnt: `\${item.qnaACnt}/\${item.qnaQCnt}`,
                                               bbs1on1Cnt: `\${item.bbs1on1ACnt}/\${item.bbs1on1QCnt}`,
                                               asmtCnt: `\${item.asmtSbmtCnt}/\${item.asmtTotCnt}`,
                                               dscsCnt: `\${item.dscsSbmtCnt}/\${item.dscsTotCnt}`,
                                               quizCnt: `\${item.quizSbmtCnt}/\${item.quizTotCnt}`,
                                               srvyCnt: `\${item.srvySbmtCnt}/\${item.srvyTotCnt}`,
                                               smnrCnt: `\${item.smnrAtndCnt}/\${item.smnrTotCnt}`
                                           });
                                        });
                                    } else {
                                        list.forEach(function (item, i) {
                                            dataList.push({
                                                no: i+1,
                                                orgnm: item.orgnm,
                                                deptnm: item.deptnm,
                                                authrtnm: item.authrtnm,
                                                userRprsId: item.userRprsId,
                                                usernm: item.usernm,
                                                mblPhn: item.mblPhn,
                                                indvEml: item.indvEml,
                                                login: `<button class="btn basic small" type="button">로그인</button>`,
                                            });
                                        })
                                    }

                                    return dataList;
                                }

                                // 과목별 학습현황 테이블 그리기
                                function createSbjctLrnStsListHTML(list) {
                                    let dataList = [];

                                    list.forEach(function (item, i) {
                                        let sbjctnm = item.dvclasNo ? item.sbjctnm + ' (' + item.dvclasNo + '반)' : item.sbjctnm;

                                        let midExamInfo = {
                                            onlnExamYn  : item.midOnlnExamYn,
                                            examSdttm   : item.midExamSdttm,
                                            examMnts    : item.midExamMnts,
                                            mrkOyn      : item.midMrkOyn,
                                            exampprOyn  : item.midExampprOyn,
                                            examCnt     : item.midExamCnt
                                        }

                                        let lstExamInfo = {
                                            onlnExamYn  : item.lstOnlnExamYn,
                                            examSdttm   : item.lstExamSdttm,
                                            examMnts    : item.lstExamMnts,
                                            mrkOyn      : item.lstMrkOyn,
                                            exampprOyn  : item.lstExampprOyn,
                                            examCnt     : item.lstExamCnt
                                        }

                                        dataList.push({
                                            no: i+1,
                                            orgnm: item.orgnm,
                                            deptnm: item.deptnm,
                                            sbjctId: item.sbjctId,
                                            sbjctnm: sbjctnm,
                                            profnm: item.profnm,
                                            tutnm: item.tutnm || '-',
                                            stdCnt: item.stdCnt,
                                            auditCnt: item.auditCnt,
                                            lctrPlandoc: `<button class="btn basic small" type="button">보기</button>`,
                                            noticeCnt: item.noticeCnt,
                                            qnaCnt: item.qnaCnt,
                                            bbs1on1Cnt: item.bbs1on1Cnt,
                                            asmtCnt: item.asmtCnt,
                                            dscsCnt: item.dscsCnt,
                                            quizCnt: item.quizCnt,
                                            srvyCnt: item.srvyCnt,
                                            normalExam: item.normalExamCnt,
                                            midExam: setExamInfo(midExamInfo),
                                            lstExam: setExamInfo(lstExamInfo)
                                        })
                                    });
                                    return dataList;
                                }

                                // 시험 정보 세팅
                                function setExamInfo(examInfo) {
                                    let onlnExamYn  = examInfo.onlnExamYn;
                                    let mrkOyn      = examInfo.mrkOyn === 'Y' ? '성적공개' : '성적비공개';
                                    let exampprOyn  = examInfo.exampprOyn === 'Y' ? '시험지공개' : '시험지비공개';

                                    if (!onlnExamYn) {
                                        return '-';
                                    } else if (onlnExamYn === 'Y') {
                                        return `<pre style="line-height: 1.2;">\${examInfo.examSdttm} \${examInfo.examMnts}분<br>\${mrkOyn} / \${exampprOyn}</pre>`
                                    } else {
                                        return `기타 (퀴즈: \${examInfo.examCnt})`
                                    }
                                }
                            </script>
                            <!--//table-type-->
                        </div>
                    </div>

                </div>
            </div>
        </div>
        <!-- //content -->
    </main>
    <!-- //admin-->





    <!-- Modal 1 -->
    <div class="modal-overlay" id="modal1" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
        <div class="modal-content modal-md" tabindex="-1">
            <div class="modal-header">
                <h2 id="modal1Title">시스템 오류 내용 상세보기</h2>
                <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
            </div>
            <div class="modal-body">
                <div class="msg-box warning">
                    <strong>오류 위치 : </strong><p id="errLocation"></p>
                </div>
                <div class="error_txt"></div>
                <div class="modal_btns">
                    <button type="button" class="btn type2" onclick="closeModal()">닫기</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal 2 -->
    <div class="modal-overlay" id="modal2" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
        <div class="modal-content modal-lg" tabindex="-1">
            <div class="modal-header">
                <h2 id="modal1Title">강의계획서</h2>
                <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
            </div>
            <div class="modal-body">

                <div class="board_top">
                    <h3 class="board-title">과목 정보</h3>
                </div>
                <div class="table_list">
                    <ul class="list">
                        <li class="head"><label>과목번호</label></li>
                        <li>CM0025</li>
                        <li class="head"><label>분반</label></li>
                        <li>01</li>
                    </ul>
                    <ul class="list">
                        <li class="head"><label>과목명 (한글)</label></li>
                        <li>데이터베이스의 이해 활용</li>
                        <li class="head"><label>과목명 (영문)</label></li>
                        <li>Data base</li>
                    </ul>
                    <ul class="list">
                        <li class="head"><label>학과</label></li>
                        <li>컴퓨터공학과</li>
                        <li class="head"><label>학점 : 강의/실습</label></li>
                        <li>3 : 3 / 0</li>
                    </ul>
                </div>

                <div class="board_top mt30">
                    <h3 class="board-title">교수 정보</h3>
                </div>
                <!-- 정보성 테이블 -->
                <div class="table-wrap">
                    <table class="table-type1">
                        <colgroup>
                            <col style="width:22%">
                            <col style="width:22%">
                            <col style="width:22%">
                            <col style="">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>교수</th>
                            <th>소속</th>
                            <th>연락처</th>
                            <th>이메일</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td data-th="교수">운영교수 : 홍길동</td>
                            <td data-th="소속">컴퓨터공학과</td>
                            <td data-th="연락처">02-5214-9853</td>
                            <td data-th="이메일">test@naver.com</td>
                        </tr>
                        <tr>
                            <td data-th="교수">공동교수 : 김교수</td>
                            <td data-th="소속">컴퓨터공학과</td>
                            <td data-th="연락처">02-5214-9853</td>
                            <td data-th="이메일">test@naver.com</td>
                        </tr>
                        <tr>
                            <td data-th="교수">개발교수 : 이교수</td>
                            <td data-th="소속">컴퓨터공학과</td>
                            <td data-th="연락처">02-5214-9853</td>
                            <td data-th="이메일">test@naver.com</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <div class="msg-box basic">
                    <ul class="list-asterisk">
                        <li>운영교수 : 해당학기 시험, 과제 등의 실제 수업을 담당하는 교수</li>
                        <li>개발교수 : 강의 콘텐츠(학습 동영상)를 제작하는 교수</li>
                    </ul>
                </div>

                <div class="board_top">
                    <h3 class="board-title">튜터 정보</h3>
                </div>
                <div class="table-wrap">
                    <table class="table-type1">
                        <colgroup>
                            <col style="width:22%">
                            <col style="width:22%">
                            <col style="width:22%">
                            <col style="">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>튜터</th>
                            <th>연락처</th>
                            <th>핸드폰</th>
                            <th>이메일</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td data-th="튜터">이튜터</td>
                            <td data-th="연락처">02-9574-9874</td>
                            <td data-th="핸드폰">010-7536-2587</td>
                            <td data-th="이메일">test@naver.com</td>
                        </tr>
                        </tbody>
                    </table>
                </div>

                <div class="board_top">
                    <h3 class="board-title">조교 정보</h3>
                </div>
                <div class="table-wrap">
                    <table class="table-type1">
                        <colgroup>
                            <col style="width:22%">
                            <col style="width:22%">
                            <col style="width:22%">
                            <col style="">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>조교</th>
                            <th>연락처</th>
                            <th>핸드폰</th>
                            <th>이메일</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td data-th="조교">홍조교</td>
                            <td data-th="연락처">02-9574-9874</td>
                            <td data-th="핸드폰">010-7536-2587</td>
                            <td data-th="이메일">test@naver.com</td>
                        </tr>
                        </tbody>
                    </table>
                </div>

                <div class="board_top">
                    <h3 class="board-title">강의 개요</h3>
                </div>
                <div class="table_list">
                    <ul class="list">
                        <li class="head"><label>교과목 개요</label></li>
                        <li>본 교과목은 공학 전공에 필요한 화학의 기본 개념 정립을 위해 자연과학의 기초가 되는 물질과 주위의 환경현상에 대한 변화를 이해하고 물질의 에너지,
                            화학결합과 원자 및 분자구조, 화학열역학과 화학평형, 반응속도론 등 화학 기초 지식 습득을 목표로 한다.
                        </li>
                    </ul>
                    <ul class="list">
                        <li class="head"><label>강의 목표</label></li>
                        <li>자연과학의 기초가 되는 물질과 그 변화에 대한 이해, 화학결합과 원자 및 분자구조, 화학열역학과 화학평형, 반응속도론 등의 화학의 기본 개념을 이해하고 정립한다.</li>
                    </ul>
                    <ul class="list">
                        <li class="head"><label>운영 방침</label></li>
                        <li>대학의 출석/운영/평가 등 일반 정책 및 방침 준수</li>
                    </ul>
                    <ul class="list">
                        <li class="head"><label>운영 계획</label></li>
                        <li>
                            <ul class="list-bullet">
                                <li>최적 학습 시간 : 주 150분</li>
                                <li>학습 방법 : 강의 내용과 교재를 학습</li>
                                <li>학습 규칙 : 학습 순서 준수</li>
                                <li>학습 절차 : 학습목표 .> 단계별 이론 강의 > 응용 및 문제풀이 > 학습 요약</li>
                            </ul>
                        </li>
                    </ul>
                    <ul class="list">
                        <li class="head"><label>관련 과목 내용</label></li>
                        <li>-</li>
                    </ul>
                    <ul class="list">
                        <li class="head"><label>참고 사항</label></li>
                        <li>-</li>
                    </ul>
                </div>

                <div class="board_top">
                    <h3 class="board-title">교재</h3>
                </div>
                <div class="table-wrap">
                    <table class="table-type1">
                        <colgroup>
                            <col style="width:7%">
                            <col style="width:10%">
                            <col style="">
                            <col style="width:20%">
                            <col style="width:21%">
                            <col style="width:16%">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>번호</th>
                            <th>구분</th>
                            <th>교재명</th>
                            <th>ISBN</th>
                            <th>저자</th>
                            <th>출판사</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td data-th="번호">1</td>
                            <td data-th="구분">주교재</td>
                            <td data-th="교재명">기본 일반화학</td>
                            <td data-th="ISBN">9788962184822</td>
                            <td data-th="저자">Stieven S. Zumdahl</td>
                            <td data-th="출판사">CENGAGE</td>
                        </tr>
                        <tr>
                            <td data-th="번호">1</td>
                            <td data-th="구분">부교재</td>
                            <td data-th="교재명">생활 화학 개론</td>
                            <td data-th="ISBN">9788962184822</td>
                            <td data-th="저자">Stieven S. Zumdahl</td>
                            <td data-th="출판사">CENGAGE</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <div class="file-wrap">
                    <ul class="add_file">
                        <li>
                            <div class="tit_area">
                                <span class="tit">강의노트 :</span>
                                <a href="#" class="file_down">
                                    <span class="text">강의노트.zip</span>
                                    <span class="fileSize">(6KB)</span>
                                </a>
                            </div>
                            <span class="link">
                                    <button class="btn s_basic down">다운로드</button>
                                </span>
                        </li>
                        <li>
                            <div class="tit_area">
                                <span class="tit">음성파일 :</span>
                                <a href="#" class="file_down">
                                    <span class="text">음성파일125.zip</span>
                                    <span class="fileSize">(200KB)</span>
                                </a>
                            </div>
                            <span class="link">
                                    <button class="btn s_basic down">다운로드</button>
                                </span>
                        </li>
                    </ul>
                </div>
                <div class="msg-box basic">
                    <ul class="list-asterisk">
                        <li>주교재 선정된 경우나 과목 특성에 따라 강의노트가 제공되지 않을 수 있습니다.</li>
                        <li>과목의 특성에 따라 제공여부가 변경/취소 혹은 일부 차시만 제공될 수 있습니다.</li>
                    </ul>
                </div>

                <div class="board_top">
                    <h3 class="board-title">평가방법</h3>
                </div>
                <div class="table_list">
                    <ul class="list">
                        <li class="head"><label>평가방법</label></li>
                        <li>상대 평가 : 학업성과를 다른 학생과 비교하여 상대적 위치를 평가하는 방식</li>
                    </ul>
                </div>

                <div class="board_top">
                    <h3 class="board-title">평가비율</h3>
                </div>
                <div class="table-wrap">
                    <table class="table-type1">
                        <colgroup>
                            <col style="">
                            <col style="width:10%">
                            <col style="width:10%">
                            <col style="width:10%">
                            <col style="width:10%">
                            <col style="width:10%">
                            <col style="width:10%">
                            <col style="width:10%">
                            <col style="width:10%">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>평가항목</th>
                            <th>중간고사</th>
                            <th>기말고사</th>
                            <th>출석</th>
                            <th>과제</th>
                            <th>토론</th>
                            <th>퀴즈</th>
                            <th>설문</th>
                            <th>세미나</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <th data-th="평가항목">비율 (%)</th>
                            <td data-th="중간고사">25</td>
                            <td data-th="기말고사">25</td>
                            <td data-th="출석">15</td>
                            <td data-th="과제">10</td>
                            <td data-th="토론">10</td>
                            <td data-th="퀴즈">10</td>
                            <td data-th="설문">5</td>
                            <td data-th="세미나">-</td>
                        </tr>
                        <tr>
                            <th data-th="평가항목">성적공개여부</th>
                            <td data-th="중간고사">공개</td>
                            <td data-th="기말고사">공개</td>
                            <td data-th="출석">비공개</td>
                            <td data-th="과제">공개</td>
                            <td data-th="토론">공개</td>
                            <td data-th="퀴즈">공개</td>
                            <td data-th="설문">공개</td>
                            <td data-th="세미나">-</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <div class="msg-box basic">
                    <ul class="list-asterisk">
                        <li>출석 : 출석 마감일까지 중간/기말고사를 제외하고 70%이상 수강해야 하며, 70%미만일 경우 F학점(0점) 처리됩니다.</li>
                        <li>정기시험 (중간/기말)에 모두 미응시 경우 학점(0점) 처리됩니다.</li>
                    </ul>
                </div>

                <div class="board_top">
                    <h3 class="board-title">주차별 강의내용</h3>
                </div>
                <div class="table-wrap">
                    <table class="table-type1">
                        <colgroup>
                            <col style="width:10%">
                            <col style="">
                            <col style="width:15%">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>주차</th>
                            <th>강의 내용</th>
                            <th>담당교수</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <th data-th="주차">1</th>
                            <td data-th="강의내용" class="t_left">일반화학 개요</td>
                            <td data-th="담당교수">홍길동</td>
                        </tr>
                        <tr>
                            <th data-th="주차">2</th>
                            <td data-th="강의내용" class="t_left">원소, 원자 및 이온</td>
                            <td data-th="담당교수">홍길동</td>
                        </tr>

                        </tbody>
                    </table>
                </div>
                <div class="msg-box basic">
                    <ul class="list-asterisk">
                        <li>강의 내용은 사정에 따라 변경될 수 있습니다.</li>
                    </ul>
                </div>

                <div class="board_top">
                    <h3 class="board-title">장애인/고령자 지원</h3>
                </div>
                <div class="table-wrap">
                    <table class="table-type1">
                        <colgroup>

                            <col style="width:20%">
                            <col style="width:20%">
                            <col style="width:20%">
                            <col style="width:20%">
                        </colgroup>
                        <thead>
                        <tr>
                            <th colspan="4">콘텐츠 내
                                학습지원 기능
                            </th>
                        </tr>
                        <tr>

                            <th>플레이어 단축키</th>
                            <th>스크립트</th>
                            <th>자막</th>
                            <th>재생속도 조절</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td data-th="플레이어 단축키">제공</td>
                            <td data-th="스크립트">제공</td>
                            <td data-th="자막">제공</td>
                            <td data-th="재생속도 조절">제공</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <div class="msg-box basic">
                    <ul class="list-asterisk">
                        <li>개발 방식에 따라 일부 주차 혹은 페이지는 제공되지 않을 수 있습니다.</li>
                        <li>미디어 플레이어 단축키</li>
                    </ul>
                    <ul class="list-bullet">
                        <li>미디어 일시정지/재생 : Space Bar</li>
                        <li>재생 속도 : Z (1배속), X (느리게), C (빠르게)</li>
                        <li>볼륨 : 위쪽 방향키 (크게), 아래쪽 방향키 (작게)</li>
                        <li>이동 : 왼쪽 방향키 (10초 전), 오른쪽 방향키 (10초 후)</li>
                        <li>전체 화면 : F</li>
                    </ul>
                </div>
                <div class="table_list">
                    <ul class="list">
                        <li class="head"><label>시험 지원</label></li>
                        <li>온라인 시험 시간 연장 : 단, 담당교수의 운영방침에 따라 부여되지 않을 수 있습니다.</li>
                    </ul>
                </div>


                <div class="modal_btns">
                    <button type="button" class="btn type2">닫기</button>
                </div>
            </div>
        </div>
    </div>

    <script src="<%=request.getContextPath()%>/webdoc/assets/js/modal.js" defer></script>

</div>

<script type="text/javascript">
    $(function () {
        bindOnlineStsTabEvent();
        bindLrnStsTabEvent();
    });

    // 학기기수 세팅 변경
    function changeSmstrChrt(row) {
        let $dgrsSmstrChrt = $('#' + row + ' [name=dgrsSmstrChrt]');

        $dgrsSmstrChrt.empty();

        $.ajax({
            url  : "/crs/termMgr/admSmstrListByDgrsYrAjax.do",
            data : {
                dgrsYr 	: $('#' + row + ' [name=dgrsYr]').val()
                <%--	,orgId	: $("#orgId").val() --%>
            },
            type : "GET",
            success: function(data) {
                if (data.result > 0) {
                    let resultList = data.returnList;

                    $dgrsSmstrChrt.append( `<option value=''><spring:message code="crs.label.open.term" /></option>`);

                    if (resultList.length > 0) {
                        $.each(resultList, function(i, smstrChrtVO) {
                            $dgrsSmstrChrt.append(`<option value="\${smstrChrtVO.smstrChrtId}">\${smstrChrtVO.smstrChrtnm}</option>`);
                        })
                    }

                    $dgrsSmstrChrt.trigger("chosen:updated");
                }else {
                    UiComm.showMessage(data.message, "error");
                }
            },
            error: function(xhr, status, error) {
                UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
            }
        });
    }

    /*// 학과부서 변경에 따른 개설과목 목록 조회
    function changeSbjctList(row) {
        let $sbjctId = $('#' + row + ' [name=sbjctId]');

        $sbjctId.empty();

        let url = "/crs/creCrsMgr/sbjctListAjax.do";

        let data = {
            dgrsYr		: $('#' + row + ' [name=dgrsYr]').val(),
            smstrChrtId	: $('#' + row + ' [name=dgrsSmstrChrt]').val() == 'ALL' ? '' : $('#' + row + '[name=dgrsSmstrChrt]').val(),
            orgId		: $('#' + row + ' [name=orgId]').val(),
            deptId		: $('#' + row + ' [name=deptId]').val()
        };

        $.ajax({
            url	: url,
            data: data,
            type: "GET",
            success	: function(data) {
                if (data.result > 0) {
                    let resultList = data.returnList;

                    $sbjctId.append(`<option value='ALL'><spring:message code='sch.cal_course' /></option>`);

                    if (resultList.length > 0) {
                        $.each(resultList, function(i, sbjctVO) {
                            $sbjctId.append('<option'+' value="'+sbjctVO.sbjctId+'" >' + sbjctVO.sbjctnm + '</option>');
                        })
                    }

                    $sbjctId.trigger("chosen:updated");
                }else {
                    UiComm.showMessage(data.message, "error");
                }
            }
        });
    }*/

    // 접속인원수 통계 인원수 변경
    function setCntnCnt(dataList) {
        let html = "";
        for (const map of dataList) {
            let orgnm = map.orgShrtnm;
            let cntnCnt = map.cntnCnt;
            let totCnt = map.totCnt;

            html += `
                <a href="#0" class="state">
                    <span class="title">\${orgnm}</span>
                    <span class="data">( \${cntnCnt} / \${totCnt} )</span>
                </a>
            `;
            // console.log(orgnm + ", " + cntnCnt + ", " + totCnt);
        }

        $("#cntnCntSummary").html(html);
    }

    // 접속현황 탭
    function bindOnlineStsTabEvent() {
        // #onlineStsTab 하위의 li 태그들을 클릭했을 때
        $('#onlineStsTab li a').on('click', function(e) {
            e.preventDefault(); // a 태그의 기본 스크롤 튕김 방지

            // 클릭된 탭이 부모(ul) 안에서 몇 번째 자식인지 인덱스를 가져옴 (0부터 시작)
            const tabIndex = $(this).parent().index();

            // 인덱스에 따라 함수 호출 분기
            if (tabIndex === 0) {
                // 첫 번째 li (학생 접속현황) 클릭 시
                listOnlineSts("STDNT");
            } else if (tabIndex === 1) {
                // 두 번째 li (교수/튜터 접속현황) 클릭 시
                listOnlineSts("PROF");
            }
        });
    }

    // 학습현황 탭
    function bindLrnStsTabEvent() {
        // #lrnStsTab 하위의 li 태그들을 클릭했을 때
        $('#lrnSts li a').on('click', function(e) {
            e.preventDefault(); // a 태그의 기본 스크롤 튕김 방지

            // 클릭된 탭이 부모(ul) 안에서 몇 번째 자식인지 인덱스를 가져옴 (0부터 시작)
            const tabIndex = $(this).parent().index();

            // 인덱스에 따라 함수 호출 분기
            if (tabIndex === 0) {
                // 첫 번째 li (과목별 학습현황) 클릭 시
                $("#lrnSts [name=searchTab]").val("sbjctLrnStsTab");
                $("#lrnSts [name=searchValue]").attr("placeholder", "과목명/교수명/과목아이디 입력");
            } else if (tabIndex === 1) {
                // 두 번째 li (학생별 학습현황) 클릭 시
                $("#lrnSts [name=searchTab]").val("stdLrnStsTab");
                $("#lrnSts [name=searchValue]").attr("placeholder", "이름 입력");
            } else {
                // 세 번째 li (사용자 검색) 클릭 시
                $("#lrnSts [name=searchTab]").val("userListTab");
                $("#lrnSts [name=searchValue]").attr("placeholder", "이름 입력");
            }
            listLrnStsRow();
        });
    }

    // 강의계획서 보기 팝업
    function viewLctrPlandocPop(sbjctId) {

        const param = { "sbjctId": sbjctId };

        $("#lctrPlandocDiv").load("/lctr/plandoc/admLctrPlandocPopView.do", param);
    }

    // 모달 내용 비우기
    function modalClear(modal) {
        if (modal == "modal1") {
            $("#errLocation").text("");
            $(".error_txt").html("");
        } else if(modal == "modal2") {
            $("#lctrPlandocDiv").empty();
        }
    }

    // 모달 닫기
    function closeModal(modal) {

        modalClear(modal)

        // 1. 활성화된 모달 찾기 (클래스 기반)
        const activeModal = document.querySelector(".modal-overlay.active");
        if (!activeModal) return;

        // 2. 클래스 제거 및 접근성 속성 변경
        activeModal.classList.remove("active");
        activeModal.setAttribute("aria-hidden", "true");

        // 3. 스크롤 락 해제
        document.body.style.overflow = "";
    }
</script>

</body>
</html>

