<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="dashboard"/>
    </jsp:include>
</head>
<style>
    /* 부모 컨테이너: 박스들을 가로로 배치 */
    .summary-container {
        display: flex;
        gap: 20px; /* 박스 사이의 간격 */
        margin-bottom: 20px;
    }

    /* 개별 박스 공통 스타일 */
    .summary-box {
        flex: 1; /* 부모 너비를 동일하게 나눠 가짐 */
        display: flex;
        align-items: center; /* 세로 중앙 정렬 */
        border: 1px solid #adc1d6; /* 파란 계열 테두리 */
        height: 50px;
    }

    /* 왼쪽 파란색 제목 부분 */
    .label {
        width: 100px;
        height: 100%;
        background-color: #6a89a7; /* 이미지의 진한 하늘/파란색 */
        color: white;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    /* 오른쪽 데이터 내용 부분 */
    .content {
        padding-left: 20px;
        font-size: 14px;
        color: #333;
    }

    .value {
        font-weight: bold;
    }
</style>

<body class="home colorA "  style=""><!-- 컬러선택시 클래스변경 -->
    <script src="<%=request.getContextPath()%>/webdoc/assets/js/modal.js" defer></script>
    <script type="text/javascript">
        var USER_DEPT_LIST = [];
        var CRS_CRE_LIST = [];

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

            $("#sbjctYr").on("change", function() {changeSmstrChrt();});
            $("#deptId").on("change", function() {changeSbjctList();});
        });

        // 전체 학습 현황 조회
        function setStatus() {
            let searchKey = $("#noStudyAll").is(":checked") ? "Y" : "";

            // [전체]
            //var url = "/lesson/lessonMgr/selectLessonProgressTotalStatus.do";
            let url = "/stats/LrnPrgrtStatusAjax.do";
            let data = {
                sbjctYr		: $("#sbjctYr").val(),
                smstrChrtId	: $("#sbjctSmstr").val(),
                orgId		: $("#orgId").val(),
                deptId		: ($("#deptId").val() || "").replace("ALL", ""),
                sbjctOfrngId: ($("#sbjctOfrngId").val() || "").replace("ALL", ""),
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
                        wholeStauts += `<spring:message code='crs.learner.count' /> : \${wholeStdCnt} <spring:message code='exam.label.nm' />, `;
                        wholeStauts += `<spring:message code='exam.label.avg' /><spring:message code='dashboard.study_prog' /> : \${wholeAvgLrnPrgrt} %`;
                        $("#allLessonDiv").html(wholeStauts);

                        // [운영과목]
                        let myStatus = '';
                        myStatus += `<spring:message code='crs.learner.count' /> : \${myStdCnt} <spring:message code='exam.label.nm' />, `;
                        myStatus += `<spring:message code='exam.label.avg' /><spring:message code='dashboard.study_prog' /> : \${myAvgLrnPrgrt} %`;
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
                url  : "/crs/termMgr/smstrListByDgrsYr.do",
                data : {
                    dgrsYr 	: $("#sbjctYr").val()
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

            let url = "/crs/creCrsMgr/sbjctOfrngList.do";
            /* var url = "/crs/creCrsHome/creCrsList.do"; */
            let data = {
                sbjctYr		: $("#sbjctYr").val(),
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
        function listStd() {
            let searchKey = $("#noStudyAll").is(":checked") ? "Y" : "";

            let url  = "/stats/lrnPrgrtStatusListAjax.do";
            let data = {
                sbjctYr		: $("#sbjctYr").val(),
                smstrChrtId	: $("#sbjctSmstr").val(),
                orgId		: $("#orgId").val(),
                deptId		: ($("#deptId").val() || "").replace("ALL", ""),
                sbjctOfrngId: ($("#sbjctOfrngId").val() || "").replace("ALL", ""),
                searchKey	: searchKey,
                searchFrom	: $("#searchFrom").val(),
                searchTo	: $("#searchTo").val(),
            };

            $.ajax({
                url	: url,
                data: data,
                type: "GET",
                success: function(data) {
                    if (data.result > 0) {
                        let returnList = data.returnList || [];
                        let html = "";
                        if (returnList.length > 0) {
                            returnList.forEach(function(v, i) {
                                html +=`
                                        <tr>
                                            <td>
                                                <div class='ui checkbox'>
        /* 											<input type='checkbox' name='stdChk' onchange='checkStd(this)' id='stdChk\${i}' userNo='\${v.userNo}' userNm='\${v.userNm}' email='\${v.email}' mobile='\${v.mobileNo}' /> */
                                                    <input type='checkbox' name='stdChk' onchange='checkStd(this)' id='stdChk\${i}' userId='\${v.userId}' usernm='\${v.usernm}' email='\${v.email}' mobile='\${v.mobileNo}' />
                                                    <label for='stdChk\${i}'></label>
                                                </div>
                                            </td>
                                            <td>\${v.lineNo}</td>
                                            <td>\${v.sbjctYr}</td>
                                            <td>\${v.sbjctSmstr}</td>
                                            <td>\${v.orgnm}</td>
                                            <td>\${v.deptnm}</td>
                                            <td>\${v.sbjctnm}</td>
                                            <td>\${v.dvclasNo}</td>
                                            <td>\${v.userId}</td>
                                            <td>\${v.stdntNo}</td>
                                            <td>\${v.usernm}</td>
                                            <td>\${v.scyr}</td>
                                            <td>\${v.openWkCnt}</td>
                                            <td>\${v.lrnWkCnt}</td>
                                            <td>\${v.prgrt}%</td>
                                        </tr>
                                    `;
                            });

                        }else {
                            html = `<tr><td colspan="15">조회된 데이터가 없습니다.</td></tr>`;
                        }

                        $("#totStdCnt").text(returnList.length);
                        $("#stdTbody").empty().html(html);
                        /*$("#stdTable").footable();*/

                        setStatus();

                        /* if(data.returnVO != null) {
                            var lessonVO = data.returnVO;
                            $("#allLessonDiv").html("<spring:message code='crs.learner.count' /> : "+lessonVO.allStdCnt+" <spring:message code='exam.label.nm' />, <spring:message code='exam.label.avg' /><spring:message code='dashboard.study_prog' /> : "+lessonVO.allLessonAvg+" %");
                                $("#myLessonDiv").html("<spring:message code='crs.learner.count' /> : "+lessonVO.myStdCnt+" <spring:message code='exam.label.nm' />, <spring:message code='exam.label.avg' /><spring:message code='dashboard.study_prog' /> : "+lessonVO.myLessonAvg+" %");
                            } */
                    } else {
                        alert(data.message);
                    }
                },
                error : function(xhr, status, error) {
                    alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
                }
            });
        }

        // 체크박스 이벤트
        function checkStd(obj) {
            if($(obj).attr("id") == "allChk") {
                $("input[name=stdChk]").prop("checked", $(obj).is(":checked"));
                if($(obj).is(":checked")) {
                    $("input[name=stdChk]").closest("tr").addClass("on");
                } else {
                    $("input[name=stdChk]").closest("tr").removeClass("on");
                }
            } else {
                if($(obj).is(":checked")) {
                    $(obj).closest("tr").addClass("on");
                } else {
                    $(obj).closest("tr").removeClass("on");
                }
                $("#allChk").prop("checked", $("input[name=stdChk]").length == $("input[name=stdChk]:checked").length);
            }
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
                    {label:"<spring:message code='common.year' />", name:'sbjctYr', align:'center', width:'3000'}, /* 년도 */
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
            form.append($('<input/>', {type: 'hidden', name: 'sbjctYr', 	value: $("#sbjctYr").val()}));
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

                    <!-- page_tab -->
                    <jsp:include page="/WEB-INF/jsp/common_new/home_page_tab.jsp"/>
                    <!-- //page_tab -->

                    <div class="sub-content">
                        <div class="page-info">
                            <%--타이틀--%>
                            <h2 class="page-title"><spring:message code="common.label.lesson.process.manage"/></h2><%--학습진도관리--%>
                            <%--네비게이션바--%>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li><span class="current"><spring:message code="common.label.lesson.process.manage"/></span></li><%--학습진도관리--%>
                                </ul>
                            </div>
                        </div>

                        <!-- search typeA -->
                        <div class="search-typeA">
                            <div class="item">
                                <div class="itemList" style="width: 100%!important;">
                                    <select class="form-select" id="sbjctYr">
                                        <option value=""><spring:message code="crs.label.open.year" /></option><!-- 개설년도 -->
                                        <c:forEach var="item" items="${filterOptions.yearList }">
                                            <option value="${item }" ${item eq filterOptions.curYear ? 'selected' : '' }>${item }</option>
                                        </c:forEach>
                                    </select>
                                    <select class="form-select" id="sbjctSmstr"><!-- 개설학기 -->
                                        <option value=""><spring:message code="crs.label.open.term" /></option>
                                        <c:forEach var="list" items="${filterOptions.smstrChrtList }">
                                            <%-- <option value="${list.smstrChrtId }" ${list.dgrsSmstrChrt eq curSmstrChrtVO.dgrsSmstrChrt ? 'selected' : '' }>${list.smstrChrtnm }</option> --%>
                                            <option value="${list.smstrChrtId }">${list.smstrChrtnm }</option>
                                        </c:forEach>
                                    </select>
                                    <select class="form-select" id="orgId" disabled><!-- 기관 -->
                                        <option value="">기관</option>
                                        <c:forEach var="list" items="${filterOptions.orgList }">
                                            <option value="${list.orgId }" ${list.orgId eq filterOptions.orgId ? 'selected' : '' }>${list.orgnm }</option>
                                        </c:forEach>
                                    </select>
                                    <select class="form-select" id="deptId">
                                        <option value=""><spring:message code="exam.label.dept" /></option><!-- 학과 -->
                                        <c:forEach var="list" items="${filterOptions.deptList }">
                                            <option value="${list.deptId }">${list.deptnm }</option>
                                        </c:forEach>
                                    </select>
                                    <select class="form-select" id="sbjctOfrngId">
                                        <option value=""><spring:message code="common.subject" /></option><!-- 과목 -->
                                    </select>
                                    <span class="custom-input">
                                        <input type="checkbox" id="noStudyAll"/>
                                        <label for="noStudyAll"><spring:message code="std.label.nostudy_student" /><spring:message code="sys.common.search.all" /></label><!-- 미학습자전체 -->
                                    </span>
                                    <div>
                                        <spring:message code="lesson.label.study.status.complete.yule" /> <!-- 출석율 -->
                                            <input type="text" id="searchFrom" inputmask="numeric" maxVal="100" style="width: 50px" />% <spring:message code="common.label.over" /><!-- 이상 -->
                                        ~
                                            <input type="text" id="searchTo" inputmask="numeric" maxVal="100" style="width: 50px" />% <spring:message code="common.label.under" /><!-- 미만 -->
                                    </div>
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="listStd()"><spring:message code="sys.button.search" /></button>
                            </div>
                        </div>

                        <%--<div class="table_list">
                            <ul class="list">
                                <li class="head"><label><spring:message code="dashboard.all" /></label></li>&lt;%&ndash;전체&ndash;%&gt;
                                <li id="allLessonDiv"><spring:message code="crs.learner.count" /><!-- 수강생 수 --> : - <spring:message code="exam.label.nm" /><!-- 명 -->, <spring:message code="exam.label.avg" /> <spring:message code="dashboard.study_prog" /><!-- 평균 학습진도율 --> : - %</li>
                                <li class="head"><label><spring:message code="crs.course.crsnm" /></label></li>&lt;%&ndash;운영과목&ndash;%&gt;
                                <li id="myLessonDiv"><spring:message code="crs.learner.count" /><!-- 수강생 수 --> : - <spring:message code="exam.label.nm" /><!-- 명 -->, <spring:message code="exam.label.avg" /> <spring:message code="dashboard.study_prog" /><!-- 평균 학습진도율 --> : - %</li>
                            </ul>
                        </div>--%>

                        <div class="summary-container">
                            <div class="summary-box">
                                <div class="label total"><spring:message code="dashboard.all" /></div><%--전체--%>
                                <div class="content" id="allLessonDiv">
                                    <spring:message code="crs.learner.count" /><%--수강생 수--%> : - <spring:message code="exam.label.nm" /><%--명--%>, <spring:message code="exam.label.avg" /> <spring:message code="dashboard.study_prog" /><%--평균 학습진도율--%> : - %
                                </div>
                            </div>

                            <div class="summary-box">
                                <div class="label active"><spring:message code="crs.course.crsnm" /></div><%--운영과목--%>
                                <div class="content" id="myLessonDiv">
                                    <spring:message code="crs.learner.count" /><%--수강생 수--%> : - <spring:message code="exam.label.nm" /><%--명--%>, <spring:message code="exam.label.avg" /> <spring:message code="dashboard.study_prog" /><%--평균 학습진도율--%> : - %
                                </div>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title"><spring:message code="lesson.label.study.status" /></h3><%--학습현황--%>
                            <span>[ <spring:message code="user.title.total.count" /><!-- 총건수 --> : <span class="fcBlue" id="totStdCnt">0</span>]</span>
                            <div class="right-area">
                                <button type="button" class="btn basic" onclick="sendMsg()"><i class="paper plane outline icon"></i><spring:message code="common.button.message" /></button><!-- 메시지 -->
                                <button type="button" class="btn type1" onclick="allProgressPop()">학과별 전체 통계</button>
                                <button type="button" class="btn basic" onclick="excelDown()"><spring:message code="exam.button.excel.down" /></button><!-- 엑셀 다운로드 -->
                            </div>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width: 50px">
                                    <col style="width: 50px">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th><span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span></th>
                                        <th><spring:message code="common.no" /></th><%--번호--%>
                                        <th><spring:message code="common.year" /></th><%--년도--%>
                                        <th><spring:message code="common.term" /></th><%--학기--%>
                                        <th><spring:message code="common.label.org" /></th><%--기관--%>
                                        <th><spring:message code="common.dept_name" /></th><%--학과--%>
                                        <th><spring:message code="common.label.crsauth.crsnm" /></th><%--개설과목명--%>
                                        <th><spring:message code="common.label.decls.no" /></th><%--분반--%>
                                        <th><spring:message code="common.id" /></th><%--아이디--%>
                                        <th><spring:message code="common.label.student.number" /></th><%--학번--%>
                                        <th><spring:message code="common.name" /></th><%--이름--%>
                                        <th><spring:message code="common.label.userdept.grade" /></th><%--학년--%>
                                        <th><spring:message code='common.label.lesson.open.week'/> (A)</th><%--오픈주차--%>
                                        <th><spring:message code='common.label.lesson.learn.week'/> (B)</th><%--학습주차--%>
                                        <th><spring:message code="lesson.label.study.status.complete.yule" /> (B/A)</th><%--출석율--%>
                                    </tr>
                                </thead>
                                <tbody id="stdTbody">
                                    <tr><td colspan="15">조회된 데이터가 없습니다.</td></tr>
                                </tbody>
                            </table>
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