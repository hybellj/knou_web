<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="dashboard"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>

<body class="home ${uiex:getTheme()} ${bodyClass}"  style=""><!-- 컬러선택시 클래스변경 -->
    <script src="<%=request.getContextPath()%>/webdoc/assets/js/modal.js" defer></script>
    <script type="text/javascript">
        let RECORD_COUNT_PER_PAGE = '<c:out value="${pageInfo.recordCountPerPage}" />';
        let CURRENT_PAGE_NO = '<c:out value="${pageInfo.currentPageNo}" />';
        let EPARAM = "${encParams}";

        let USER_DEPT_LIST = [];
        let CRS_CRE_LIST = [];

        $(function() {
            // 부서정보
            <c:forEach var="item" items="${deptList}">
            USER_DEPT_LIST.push({
                deptCd: '<c:out value="${item.deptId}" />'
                , deptNm: '<c:out value="${item.deptnm}" />'
            });
            </c:forEach>
            setStatus();
            changeSbjctList();

            $("#dgrsYr").on("change", function() {changeSmstrChrt();});
            $("#deptId").on("change", function() {changeSbjctList();});
        });

        // list scale 변경
        function changeRecoredCnt(scale) {
            RECORD_COUNT_PER_PAGE = scale;
            listPaging(1);
        }

        // 전체 학습 현황 조회
        function setStatus() {
            let searchKey = $("#noStudyAll").is(":checked") ? "Y" : "";

            // [전체]
            let url = "/stats/lrnPrgrtStatsSummaryAjax.do";
            let data = {
                dgrsYr		: $("#dgrsYr").val(),
                smstrChrtId	: $("#sbjctSmstr").val(),
                orgId		: $("#orgId").val(),
                deptId		: ($("#deptId").val() || "").replace("ALL", ""),
                sbjctId     : ($("#sbjctId").val() || "").replace("ALL", ""),
                searchKey	: searchKey,
                searchFrom	: $("#searchFrom").val(),
                searchTo	: $("#searchTo").val(),
            };

            $.ajax({
                url	: url,
                type: 'GET',
                data: data,
                success: function(data) {
                    if(data.result > 0) {
                        let returnVO = data.returnVO || {};

                        let wholeStdCnt     = returnVO.wholeStdCnt;				// 전체 수강생 수
                        let wholeAvgLrnPrgrt= returnVO.wholeAvgLrnPrgrt;	// 전체 수강생 기준 평균학습진도율
                        let myStdCnt        = returnVO.myStdCnt;			// 운영과목 수강생 수
                        let myAvgLrnPrgrt   = returnVO.myAvgLrnPrgrt;	// 운영과목 수강생 기준 평균학습진도율

                        // [전체]
                        let wholeStauts = '';
                        wholeStauts += `
                            <p class="desc">
                                <i class="icon-svg-group" aria-hidden="true"></i>
                                <spring:message code="crs.learner.count" /> : <strong> \${wholeStdCnt} <spring:message code="exam.label.nm" /></strong>
                            </p>
                        `;
                        wholeStauts +=`
                            <p class="desc">
                                <i class="icon-svg-bar-chart" aria-hidden="true"></i>
                                <spring:message code="exam.label.avg" /> <spring:message code="dashboard.study_prog" /> : <strong>\${wholeAvgLrnPrgrt} %</strong>
                            </p>
                        `;
                        $("#allLessonDiv").html(wholeStauts);

                        // [운영과목]
                        let myStatus = '';
                        myStatus += `
                            <p class="desc">
                                <i class="icon-svg-group" aria-hidden="true"></i>
                                <spring:message code="crs.learner.count" /> : <strong> \${myStdCnt} <spring:message code="exam.label.nm" /></strong>
                            </p>
                        `;
                        myStatus +=`
                            <p class="desc">
                                <i class="icon-svg-bar-chart" aria-hidden="true"></i>
                                <spring:message code="exam.label.avg" /> <spring:message code="dashboard.study_prog" /> : <strong>\${myAvgLrnPrgrt} %</strong>
                            </p>
                        `;
                        $("#myLessonDiv").html(myStatus);

                    } else {
                        alert(data.message);
                    }
                },
                error: function(xhr, status, error) {
                    alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
                }
            });
        }

        // 학기기수 세팅 변경
        function changeSmstrChrt() {
            let $sbjctSmstr = $('#sbjctSmstr');

            // 기존 옵션 초기화
            $sbjctSmstr.empty();

            $.ajax({
                url  : "/crs/termMgr/admSmstrListByDgrsYrAjax.do",
                data : {
                    dgrsYr 	: $("#dgrsYr").val()
                    <%--	,orgId	: $("#orgId").val() --%>
                },
                type : "GET",
                success: function(data) {
                    if (data.result > 0) {
                        let resultList = data.returnList;

                        $sbjctSmstr.append(`<option value='ALL'><spring:message code="crs.label.open.term" /></option>`);

                        $.each(resultList, function(i, smstrChrtVO) {
                            $sbjctSmstr.append(`<option value="\${smstrChrtVO.smstrChrtId}">\${smstrChrtVO.smstrChrtnm}</option>`);
                            /* $sbjctSmstr.append('<option'+' value="'+smstrChrtVO.smstrChrtId+'" >' + smstrChrtVO.smstrChrtnm + '</option>'); */
                        })

                        $sbjctSmstr.trigger("chosen:updated");
                    }else {
                        alert(data.message);
                    }
                },
                error: function(xhr, status, error) {
                    alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
                }
            });
        }

        // 학과부서 변경에 따른 개설과목 목록 조회
        function changeSbjctList() {
            let $sbjctOfrngId = $('#sbjctOfrngId');

            // 기존 옵션 초기화
            $sbjctOfrngId.empty();

            let url = "/crs/creCrsMgr/sbjctListAjax.do";

            let data = {
                dgrsYr		: $("#dgrsYr").val(),
                smstrChrtId	: $("#sbjctSmstr").val(),
                orgId		: $("#orgId").val(),
                deptId		: $("#deptId").val()
            };

            $.ajax({
                url	: url,
                data: data,
                type: "GET",
                success	: function(data) {
                    if (data.result > 0) {
                        let resultList = data.returnList;

                        $sbjctOfrngId.append(`<option value='ALL'><spring:message code='sch.cal_course' /></option>`);
                        
                        $.each(resultList, function(i, sbjctOfrngVO) {
                            $sbjctOfrngId.append(`<option value="\${sbjctOfrngVO.sbjctOfrngId}">\${sbjctOfrngVO.sbjctnm}</option>`);
                        })

                        $sbjctOfrngId.trigger("chosen:updated");
                    }else {
                        alert(data.message);
                    }
                }
            });
        }

        // 학습현황 목록
        function listPaging(pageNo) {
            UiComm.showLoading(true);

            CURRENT_PAGE_NO = pageNo;

            let searchKey = $("#noStudyAll").is(":checked") ? "Y" : "";
            let param = {
                currentPageNo       : CURRENT_PAGE_NO,
                recordCountPerPage  : RECORD_COUNT_PER_PAGE,
                yrSmstr         : $("#yrSmstr").val() || "",
                smstrChrtGbncd  : $("#yrSmstr option:selected").data("type") || "",
                orgId		    : $("#orgId").val(),
                deptId		    : ($("#deptId").val() || "").replace("ALL", ""),
                sbjctId         : ($("#sbjctOfrngId").val() || "").replace("ALL", ""),
                searchFrom	    : $("#searchFrom").val(),
                searchTo	    : $("#searchTo").val(),
                searchKey       : searchKey,
            };

            $.ajax({
                url	: "/stats/lrnPrgrtStatsListAjax.do",
                data: param,
                type: "GET",
                headers: {"X-Requested-With": "XMLHttpRequest"},
                success: function(data) {
                    if (data.encParams != null && data.encParams !== '') {
                        EPARAM = data.encParams;
                    }

                    if (data.result > 0) {
                        let returnList = data.returnList || [];

                        let dataList = createListHtml(returnList, data.pageInfo)
                        listTable.clearData();
                        listTable.replaceData(dataList);
                        listTable.setPageInfo(data.pageInfo);

                        $("#totStdCnt").text(data.pageInfo.totalRecordCount);

                        setStatus();

                    } else {
                        UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
                    }
                },
                error : function(xhr, status, error) {
                    UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
                },
                complete: function (){
                    UiComm.showLoading(false);
                }
            });
        }

        // 테이블 그리기
        function createListHtml(list) {
            let dataList = [];

            list.forEach(item => {

                dataList.push({
                    no: item.lineNo,
                    dgrsYr      : item.dgrsYr,
                    smstrChrt  : item.smstrChrt,
                    orgnm       : item.orgnm,
                    deptnm      : item.deptnm || '-',
                    sbjctnm     : item.sbjctnm,
                    dvclasNo    : item.dvclasNo || '-',
                    userId      : item.userId,
                    stdntNo     : item.stdntNo,
                    usernm      : item.usernm,
                    orgTycd     : item.orgTycd,
                    openWkCnt   : item.openWkCnt,
                    lrnWkCnt    : item.lrnWkCnt,
                    prgrt       : item.prgrt
                })
            });

            return dataList;
        }

        // 쪽지 보내기
        function sendMsg() {
            if($("#stdTbody").find("input[name=stdChk]:checked").length == 0) {
                /* 체크된 값이 없습니다. */
                alert("<spring:message code='common.alert.input.no.value' />");
                return;
            }
            let rcvUserInfoStr = "";
            let sendCnt = 0;

            $.each($("#stdTbody").find("input[name=stdChk]:checked"), function() {
                sendCnt++;
                if (sendCnt > 1) rcvUserInfoStr += "|";
                rcvUserInfoStr += $(this).attr("user_no");
                rcvUserInfoStr += ";" + $(this).attr("user_nm");
                rcvUserInfoStr += ";" + $(this).attr("mobile");
                rcvUserInfoStr += ";" + $(this).attr("email");
            });

            window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");

            let form = document.alarmForm;
            form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
            form.target = "msgWindow";
            form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
            form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
            form.submit();
        }

        // 엑셀 다운로드
        function excelDown() {
            $("form[name='excelForm']").remove();
            var excelGrid = {
                colModel:[
                    {label:"<spring:message code='common.no' />", name:'lineNo', align:'center', width:'3000'}, /* 번호 */
                    {label:"<spring:message code='common.year' />", name:'dgrsYr', align:'center', width:'3000'}, /* 년도 */
                    {label:"<spring:message code='common.term' />", name:'sbjctSmstr', align:'center', width:'3000'}, /* 학기 */
                    {label:"<spring:message code='common.label.org' />", name:'orgId', align:'center', width:'3000'}, /* 기관 */
                    {label:"<spring:message code='common.dept_name'/>", name:'deptnm', align:'left', width:'8000'}, /* 학과 */
                    {label:"<spring:message code='common.label.crsauth.crsnm'/>", name:'sbjctnm', align:'left', width:'8000'}, /* 개설과목명 */
                    {label:"<spring:message code='common.label.decls.no' />", name:'dvclasNo', align:'center', width:'3000'}, /* 분반 */
                    {label:"<spring:message code='common.id'/>", name:'userNm', align:'center', width:'5000'}, /* 아이디 */
                    {label:"<spring:message code='common.name'/>", name:'userNm', align:'center', width:'5000'}, /* 이름 */
                    {label:"<spring:message code='common.label.userdept.grade' />", name:'scyr', align:'center', width:'3000'}, /* 학년 */
                    {label:"<spring:message code='common.label.lesson.open.week'/> (A)", name:'allScheduleCnt', align:'left', width:'5000'}, /* 오픈주차 */
                    {label:"<spring:message code='common.label.lesson.learn.week'/> (B)", name:'studyScheduleCnt', align:'left', width:'5000'}, /* 학습주차 */
                    {label:"<spring:message code='lesson.label.study.status.complete.yule'/> (A/B)", name:'studyPersent', align:'left', width:'5000'}, /* 출석율 */
                ]
            };
            let searchKey = $("#noStudyAll").is(":checked") ? "Y" : "";

            let form = $("<form></form>");
            form.attr("method", "POST");
            form.attr("name", "excelForm");
            form.attr("action", "/lesson/lessonHome/lessonProgressExcelDown.do");
            form.append($('<input/>', {type: 'hidden', name: 'dgrsYr', 	value: $("#dgrsYr").val()}));
            form.append($('<input/>', {type: 'hidden', name: 'smstrChrtId', value: $("#sbjctSmstr").val()}));
            form.append($('<input/>', {type: 'hidden', name: 'orgId', 		value: $("#orgId").val()}));
            form.append($('<input/>', {type: 'hidden', name: 'deptId', 		value: ($("#deptId").val() || "").replace("ALL", "")}));
            form.append($('<input/>', {type: 'hidden', name: 'smstrChrtId', value: ($("#sbjctSmstr").val() || "").replace("ALL", "")}));
            form.append($('<input/>', {type: 'hidden', name: 'searchKey', 	value: searchKey}));
            form.append($('<input/>', {type: 'hidden', name: 'searchFrom', 	value: $("#searchFrom").val()}));
            form.append($('<input/>', {type: 'hidden', name: 'searchTo', 	value: $("#searchTo").val()}));
            form.append($('<input/>', {type: 'hidden', name: 'excelGrid', 	value: JSON.stringify(excelGrid)}));
            form.appendTo("body");
            form.submit();
        }

        // 학과별 전체통계 팝업
        function allProgressPop() {
            const url = "/stats/lrnPrgrtListByDeptPopView.do";

            // 다이얼로그 호출
            let dialog = UiDialog("totStatusByDept", {
                title: "학과별 전체 통계", // 팝업 제목
                url: url,                       // 호출할 페이지 주소
                width: 1000,                    // 너비
                height: 500,                    // 높이
                // autoresize: true                // 내용에 맞게 높이 자동 조절
            });
        }
    </script>
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp"/> 
        <!-- //common header -->

        <!-- dashboard -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="dashboard_sub">

                    <div class="sub-content">
                        <div class="page-info">
                            <%--타이틀--%>
                            <h2 class="page-title"><spring:message code="common.label.lesson.process.manage"/></h2><%--학습진도관리--%>
                            <%--네비게이션바--%>
                            <uiex:navibar type="main"/> <%-- 네비게이션바 --%>
                        </div>

                        <div class="msg-box info">
                            <p class="txt">운영과목과 수강생의 학습현황을 조회할 수 있습니다. <strong>학습 부진자 관리</strong>에 활용하시기 바랍니다.</p>
                        </div>
                        <div class="msg-box basic">
                            <ul class="list-dot">
                                <li>출석율은 현재 오픈 차시 중 정상 출석한 차시에 대한 비율로 표기됩니다.</li>
                                <li>매 주차별로 부진자 (출석율 100% 미만)에게 알림 발송 가능합니다.</li>
                                <li>운영과목 수강생의 수에 따라 조회에 다소 시간이 걸릴 수 있습니다</li>
                            </ul>
                        </div>

                        <!-- search typeA -->
                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="selectDate">기관</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="orgId" disabled><!-- 기관 -->
                                        <option value="">기관</option>
                                        <c:forEach var="list" items="${filterOptions.orgList }">
                                            <option value="${list.orgId }" ${list.orgId eq filterOptions.orgId ? 'selected' : '' }>${list.orgnm }</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="item">
                                <span class="item_tit"><label for="selectDate">학사년도/학기</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="yrSmstr">
                                        <option value=""><spring:message code="msg.common.label.yearSmstr" /></option>
                                        <c:forEach var="item" items="${filterOptions.yrSmstrList }" varStatus="i">
                                            <option value="${item.dgrsYr}${item.dgrsSmstrChrt}" <%--${i.index eq 0 ? 'selected' : '' }--%> data-type="${item.smstrChrtGbncd}">${item.yrSmstrnm}</option>
                                        </c:forEach>
                                    </select>
                                    <%--<select class="form-select" id="dgrsYr">
                                        <option value=""><spring:message code="crs.label.open.year" /></option><!-- 개설년도 -->
                                        <c:forEach var="item" items="${filterOptions.yearList }">
                                            <option value="${item }" ${item eq filterOptions.curYear ? 'selected' : '' }>${item }</option>
                                        </c:forEach>
                                    </select>
                                    <select class="form-select" id="sbjctSmstr"><!-- 개설학기 -->
                                        <option value=""><spring:message code="crs.label.open.term" /></option>
                                        <c:forEach var="list" items="${filterOptions.smstrChrtList }">
                                            &lt;%&ndash; <option value="${list.smstrChrtId }" ${list.dgrsSmstrChrt eq curSmstrChrtVO.dgrsSmstrChrt ? 'selected' : '' }>${list.smstrChrtnm }</option> &ndash;%&gt;
                                            <option value="${list.smstrChrtId }">${list.smstrChrtnm }</option>
                                        </c:forEach>
                                    </select>--%>
                                </div>
                            </div>

                            <div class="item">
                                <span class="item_tit"><label for="selectCourse">운영과목</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="deptId">
                                        <option value=""><spring:message code="exam.label.dept" /></option><!-- 학과 -->
                                        <c:forEach var="list" items="${filterOptions.deptList }">
                                            <option value="${list.deptId }">${list.deptnm }</option>
                                        </c:forEach>
                                    </select>
                                    <select class="form-select" id="sbjctId">
                                        <option value=""><spring:message code="common.subject" /></option><!-- 과목 -->
                                    </select>
                                </div>
                            </div>

                            <div class="item">
                                <span class="item_tit"><label for="selectSearch">검색 조건</label></span>
                                <div class="itemList">
                                    <span class="custom-input">
                                        <input type="checkbox" id="noStudyAll"/>
                                        <label for="noStudyAll"><spring:message code="std.label.nostudy_student" /><spring:message code="sys.common.search.all" /></label><!-- 미학습자전체 -->
                                    </span>
                                    <div class="percent_area">
                                        <span class="tit"><spring:message code="lesson.label.study.status.complete.yule" /> <!-- 출석율 --></span>
                                        <div class="input_btn">
                                            <input class="form-control sm" type="text" id="searchFrom" inputmask="numeric" maxVal="100"/><label>% <spring:message code="common.label.over" /><!-- 이상 --></label>
                                        </div>
                                        <span class="txt-sort">~</span>
                                        <div class="input_btn">
                                            <input class="form-control sm" type="text" id="searchTo" inputmask="numeric" maxVal="100"/><label>% <spring:message code="common.label.under" /><!-- 미만 --></label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="listPaging(1)"><spring:message code="sys.button.search" /></button>
                            </div>
                        </div>

                        <div class="lecture_status_box">
                            <div class="box_item">
                                <div class="title"><spring:message code="dashboard.all" /><%--전체--%><i class="xi-angle-right-min"></i></div>
                                <div class="item_txt" id="allLessonDiv">
                                    <p class="desc">
                                        <i class="icon-svg-group" aria-hidden="true"></i>
                                        <spring:message code="crs.learner.count" /><%--수강생 수--%> : <strong> - <spring:message code="exam.label.nm" /><%--명--%></strong>
                                    </p>
                                    <p class="desc">
                                        <i class="icon-svg-bar-chart" aria-hidden="true"></i>
                                        <spring:message code="exam.label.avg" /> <spring:message code="dashboard.study_prog" /><%--평균 학습진도율--%> : <strong>- %</strong>
                                    </p>
                                </div>
                            </div>
                            <div class="box_item">
                                <div class="title"><spring:message code="crs.course.crsnm" /><%--운영과목--%><i class="xi-angle-right-min"></i></div>
                                <div class="item_txt" id="myLessonDiv">
                                    <p class="desc">
                                        <i class="icon-svg-group" aria-hidden="true"></i>
                                        <spring:message code="crs.learner.count" /><%--수강생 수--%> : <strong>- <spring:message code="exam.label.nm" /><%--명--%></strong>
                                    </p>
                                    <p class="desc">
                                        <i class="icon-svg-bar-chart" aria-hidden="true"></i>
                                        <spring:message code="exam.label.avg" /> <spring:message code="dashboard.study_prog" /><%--평균 학습진도율--%> : <strong>- %</strong>
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title"><spring:message code="lesson.label.study.status" /></h3><%--학습현황--%>
                            <div class="right-area">
                                <button type="button" class="btn basic" onclick="sendMsg()"><i class="paper plane outline icon"></i><spring:message code="common.button.message" /></button><!-- 메시지 -->
                                <button type="button" class="btn type1" onclick="allProgressPop()">학과별 전체 통계</button>
                                <button type="button" class="btn basic" onclick="excelDown()"><spring:message code="exam.button.excel.down" /></button><!-- 엑셀 다운로드 -->
                                <uiex:listScale func="changeRecoredCnt" value="${pageInfo.recordCountPerPage}" />
                            </div>
                        </div>

                        <div class="table-wrap">
                            <div id="list"></div>
                            <script type="text/javascript">
                                let listTable;
                                $(function () {
                                    let cols = [
                                        {title: "<spring:message code='common.no'/>", field: "no", headerHozAlign:"center", hozAlign:"center", width: 40, minWidth: 40},
                                        {title: "<spring:message code="common.year" />",  field: "dgrsYr", headerHozAlign: "center", hozAlign: "center", width: 70, minWidth: 70},
                                        {title: "<spring:message code="common.term" />",  field: "smstrChrt", headerHozAlign: "center", hozAlign: "center", width: 50, minWidth: 50},
                                        {title: "<spring:message code="common.label.org" />",  field: "orgnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 100},
                                        {title: "<spring:message code="common.dept_name" />",  field: "deptnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 130},
                                        {title: "<spring:message code="common.label.crsauth.crsnm" />",  field: "sbjctnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 180},
                                        {title: "<spring:message code="common.label.decls.no" />",  field: "dvclasNo", headerHozAlign: "center", hozAlign: "center", width: 50, minWidth: 50},
                                        {title: "<spring:message code="common.id" />",  field: "userId", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100},
                                        {title: "<spring:message code="common.label.student.number" />",  field: "stdntNo", headerHozAlign: "center", hozAlign: "center", width: 90, minWidth: 90},
                                        {title: "<spring:message code="common.name" />",  field: "usernm", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100},
                                        {title: "<spring:message code='common.label.lesson.open.week'/> (A)", field: "openWkCnt", headerHozAlign:"center", hozAlign:"center", width: 90, minWidth: 90},
                                        {title: "<spring:message code='common.label.lesson.learn.week'/> (B)", field: "lrnWkCnt", headerHozAlign:"center", hozAlign:"center", width: 90, minWidth: 90},
                                        {title: "<spring:message code="lesson.label.study.status.complete.yule" /> (B/A)", field: "prgrt", headerHozAlign:"center", hozAlign:"center", width: 100, minWidth: 100}
                                    ];

                                    listTable = UiTable("list", {
                                        lang: "ko",
                                        table: "list",
                                        selectRow: "checkbox",
                                        columns: cols,    // 컬럼정보
                                        pageFunc: listPaging,
                                    });

                                    //listPaging(1);
                                });
                            </script>
                        </div>

                        <!-- 학과별 전체통계 모달 -->
                        <div class="modal-overlay" id="stdLessonPop" name="stdLessonPop" aria-modal="true" aria-hidden="true" aria-labelledby="<spring:message code="lesson.label.enrolled.learning.statistics" />">
                            <div class="modal-content modal-full" tabindex="-1">
                                <div class="modal-header">
                                    <h2 id="modal1Title"><spring:message code="lesson.label.enrolled.learning.statistics" /></h2><!-- 재학생 학습진도 전체 통계 -->
                                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                                </div>
                                <div class="modal-body">
                                    <iframe src="" id="stdLessonIfm" name="stdLessonIfm" width="100%" scrolling="no"></iframe>
                                </div>

                                <div class="modal_btns">
                                    <button type="button" class="btn type2 modal-close">닫기</button>
                                </div>
                            </div>
                        </div>
                        <%--//모달--%>

                    </div>


                </div>
            </div>
            <!-- //content -->


            <!-- common footer -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
            <!-- //common footer -->

        </main>
        <!-- //dashboard-->

    </div>


</body>
</html>