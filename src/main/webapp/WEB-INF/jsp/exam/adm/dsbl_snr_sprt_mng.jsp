<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
    <head>
        <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
            <jsp:param name="style" value="admin"/>
            <jsp:param name="module" value="table"/>
        </jsp:include>
        <script type="text/javascript">
            /* Tabulator 공통 페이징 */
            var PAGE_INDEX = 1;
            var LIST_SCALE = 10;
            var sprtAplyListTable = null;    
            
            /* 기관별 학과/부서 목록 조회 */
            function loadDeptList(orgId) {
                $.ajax({
                    url: "/admByOrgDeptList.do",
                    type: "GET",
                    data: { orgId: orgId || '' },
                    dataType: "json",
                    success: function(data) {

                        var $deptSelect = $("#deptId");
                        $deptSelect.empty();

                        // data.result가 없거나 0이더라도 returnList에 데이터가 있으면 타도록 조건 완화
                        if(data.returnList && data.returnList.length > 0) {

                            $deptSelect.append('<option value=""><spring:message code='exam.common.search.all' /></option>'); /* 전체 */

                            $.each(data.returnList, function(idx, dept) {

                                var deptId = dept.deptId || '';
                                $deptSelect.append(
                                    $('<option>').val(dept.deptId).text(dept.deptnm)
                                );
                            });

                        } else {
                            $deptSelect.append(
                                '<option value=""><spring:message code='exam.dept.list.none' /></option>'    /* 조회된 학과/부서가 없습니다. */
                            );
                        }

                        $deptSelect.trigger("chosen:updated");
                    },
                    error: function(xhr, status, error) {
                        console.error("학과/부서 조회 실패:", error);
                    }
                });
            }

            /* 기관별, 부서별 과목목록조회 */
            function loadSubjectList(orgId, deptId) {
                $.ajax({
                    url: "/subject/admByOrgByDeptSubjectSelect.do",
                    type: "GET",
                    data: {
                        orgId: orgId || '',
                        deptId: deptId || ''
                    },
                    dataType: "json",
                    success: function(data) {
                        var $subjectSelect = $("#sbjctId");
                        $subjectSelect.empty();

                        if(data.returnList && data.returnList.length > 0) {

                            $subjectSelect.append('<option value=""><spring:message code='exam.common.search.all' /></option>');    /* 전체 */

                            $.each(data.returnList, function(idx, subject) {
                                var sbjctCode = subject.sbjctId || '';
                                $subjectSelect.append(
                                    $('<option>').val(sbjctCode).text(subject.sbjctnm)
                                );
                            });

                        } else {
                            $subjectSelect.append(
                                '<option value=""><spring:message code='exam.common.search.all' /></option>'    /* 조회된 과목이 없습니다. */
                            );
                        }
                        $subjectSelect.trigger("chosen:updated");
                        if ($.fn.select2) {
                            $subjectSelect.trigger("change");
                        }
                        // 3. 만약 공통 UI 리프레시 유틸이 존재한다면 (UiComm 등) 호출 예시
                        // UiComm.refreshSelect("#sbjctId");
                    },
                    error: function(xhr, status, error) {
                        console.error("과목조회 조회 실패:", error);
                    }
                });
            }

            function selectBoxChangeEvents() {
                // 기관 선택 변경 시 학과/과목/tabulator 목록 업데이트
                $("#orgId").on("change", function() {
                    var orgId = $(this).val();
                    loadDeptList(orgId);
                    loadSubjectList(orgId, '');
                    loadSprtAplyInfoList(1);
                });

                // 학과 선택 변경 시 과목/tabulator 목록 업데이트
                $("#deptId").on("change", function() {
                    var orgId = $("#orgId").val();
                    var deptId = $(this).val();
                    loadSubjectList(orgId, deptId);
                    loadSprtAplyInfoList(1);
                });

                // 과목 선택 변경 시 tabulator 목록 업데이트
                $("#sbjctId").on("change", function() {
                    loadSprtAplyInfoList(1);
                });

                // 처리상태 선택 변경 시 tabulator 목록 업데이트
                $("#aplyStscd").on("change", function() {
                    loadSprtAplyInfoList(1);
                });

                // 검색어 입력창에서 Enter 키
                $("#searchValue").on("keydown", function(e) {
                    if(e.keyCode == 13) {
                        e.preventDefault();
                        loadSprtAplyInfoList(1);
                    }
                });
            }

            /*****************************************************************************
             * tabulator 관련 기능
             * 1. initSprtAplyInfoListTable :        컬럼 정의 (시험 대체)
             * 2. createSprtAplyInfoListHtml:       각 컬럼에 들어갈 데이터 세팅 및 버튼 요소 생성 (시험 대체)
             * 3. loadSprtAplyInfoList :            컬럼에 들어갈 데이터 ajax 호출 (시험 대체)
             *****************************************************************************/
            /* 1 */
            function initSprtAplyInfoListTable() {
                if (sprtAplyListTable) return;
                var sprtAplyInfoColumns = [
                    {title:"No", field:"lineNo", headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:50},
                    {title:"<spring:message code='exam.label.org' />", field:"orgnm", headerHozAlign:"center", hozAlign:"left", width:120, minWidth:120},                   /* 기관 */
                    {title:"<spring:message code='exam.label.years' />", field:"dgrsYr", headerHozAlign:"center", hozAlign:"center", width:60, minWidth:60},                /* 년도 */
                    {title:"<spring:message code='exam.label.term' />", field:"dgrsSmstrChrt", headerHozAlign:"center", hozAlign:"center", width:60, minWidth:60},          /* 학기 */
                    {title:"<spring:message code='exam.label.dept' />", field:"deptnm", headerHozAlign:"center", hozAlign:"left", width:120, minWidth:120},                 /* 학과 */
                    {title:"<spring:message code='exam.label.crs.code' />", field:"crclmnNo", headerHozAlign:"center", hozAlign:"center", width:120, minWidth:120},         /* 과목 코드 */
                    {title:"<spring:message code='exam.label.crs' />", field:"sbjctnm", headerHozAlign:"center", hozAlign:"left", width:120, minWidth:120},                 /* 과목 */
                    {title:"<spring:message code='exam.label.decls.cls' />", field:"dvclasNcknm", headerHozAlign:"center", hozAlign:"center", width:60, minWidth:60},       /* 분반 */
                    {title:"<spring:message code='exam.label.user.no' />", field:"stdntNo", headerHozAlign:"center", hozAlign:"center", width:120, minWidth:120},           /* 학번 */
                    {title:"<spring:message code='exam.label.user.nm' />", field:"usernm", headerHozAlign:"center", hozAlign:"center", width:120, minWidth:120},            /* 이름 */
                    {title:"<spring:message code='exam.label.stare.type' />", field:"gubun", headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},            /* 구분 */
                    {title:"<spring:message code='exam.label.exam.stare.type' />", field:"examGbnnm", headerHozAlign:"center", hozAlign:"center", width:140, minWidth:140}, /* 시험 구분 */
                    {title:"<spring:message code='exam.label.req' />", field:"examSprtAplyTynm", headerHozAlign:"center", hozAlign:"center", width:120, minWidth:120},      /* 요청사항 */
                    {title:"<spring:message code='exam.label.process.rslt' />", field:"sprtRslt", headerHozAlign:"center", hozAlign:"center", width:0, minWidth:180},       /* 처리결과 */
                    {title:"<spring:message code='exam.label.cancel.request' />", field:"cnclAplyYn", headerHozAlign:"center", hozAlign:"center", width:120, minWidth:120}  /* 취소요청 */
                ];
                sprtAplyListTable = UiTable("sprtList", {
                    lang: "ko",
                    pageFunc: loadSprtAplyInfoList,
                    columns: sprtAplyInfoColumns
                });
            }
            /* 2 */
            function createSprtAplyInfoListHtml(list) {
                let dataList = [];
                if (list.length == 0) {
                    return dataList;
                } else {
                    list.forEach(function(v, i) {
                        // 학번
                        var stdntNo = "<a href='javascript:sprtAplyDtlPop(\"" + v.sbjctId + "\", \"" + v.userId + "\")' class='fcBlue' >" + v.stdntNo + "</a>";
                        // 이름
                        var usernm = "<a href='javascript:sprtAplyDtlPop(\"" + v.sbjctId + "\", \"" + v.userId + "\")' class='fcBlue' >" + v.usernm + "</a>";
                        // 취소 신청
                        var cnclAplyYn;
                        if (v.cnclAplyYn === "Y") {
                            cnclAplyYn = "<a href='javascript:sprtAplyCnclRqst(\"" + v.examSprtAplyGrpId + "\")' class='btn basic small' >" + v.cnclAplyStsnm + "</a>";
                        } else {
                            if (v.cnclAplyStsnm !== "" && v.cnclAplyStsnm !== null) {
                                cnclAplyYn = v.cnclAplyStsnm;
                            } else {
                                cnclAplyYn = "-";
                            }
                        }
                        dataList.push({
                            lineNo:             v.lineNo
                            , orgnm:            v.orgnm
                            , dgrsYr:           v.dgrsYr
                            , dgrsSmstrChrt:    v.dgrsSmstrChrt
                            , deptnm:           v.deptnm
                            , crclmnNo:         v.crclmnNo
                            , sbjctnm:          v.sbjctnm
                            , dvclasNcknm:      v.dvclasNcknm
                            , stdntNo:          stdntNo
                            , usernm:           usernm
                            , gubun:            v.gubun
                            , examGbnnm:        v.examGbnnm
                            , examSprtAplyTynm: v.examSprtAplyTynm
                            , sprtRslt:         v.sprtRslt
                            , cnclAplyYn:       cnclAplyYn
                            , userId:           v.userId
                            , sbjctId:          v.sbjctId
                            , examSprtAplyGrpId:v.examSprtAplyGrpId
                        });
                    });
                }
                return dataList;
            }
            /* 3 */
            function loadSprtAplyInfoList(pageIndex) {
                initSprtAplyInfoListTable();
                PAGE_INDEX = pageIndex || PAGE_INDEX;
                UiComm.showLoading(true);
                $.ajax({
                    url: "/exam/admSprtAplyPaging.do",
                    type: "GET",
                    data: {
                        pageIndex:      PAGE_INDEX
                        , listScale:    LIST_SCALE
                        , orgId:        $("#orgId").val()
                        // , dgrsYr:       $("#dgrsYr").val()
                        // , dgrsSmstrChrt:$("#dgrsSmstrChrt").val()
                        , deptId:       $("#deptId").val()
                        , sbjctId:      $("#sbjctId").val()
                        , aplyStscd:    $("#aplyStscd").val()
                        , searchValue:  $("#searchValue").val()
                    },
                    dataType: "json",
                    success: function(data) {
                        if (data.result > 0) {
                            var returnList = data.returnList || [];
                            var dataList   = createSprtAplyInfoListHtml(returnList);
                            sprtAplyListTable.clearData();
                            sprtAplyListTable.replaceData(dataList);
                            sprtAplyListTable.setPageInfo(data.pageInfo);
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function() {
                        UiComm.showMessage("<spring:message code='exam.error.list' />", "error"); /* 리스트 조회 중 에러가 발생하였습니다. */
                    },
                    complete: function() {
                        UiComm.showLoading(false);
                    }
                });
            }

            /*****************************************************************************
             * 팝업 관련 기능
             * 1. sprtAplyDtlPop:   장애인/고령자 시험지원 상세내용 + 승인,반려 팝업
             * 2. sprtAplyCnclRqst: 장애인/고령자 시험지원 취소 승인,반려 팝업
             * 3. sendMsg:          메세지 전송 기능
             *****************************************************************************/
            /* 1 */
            function sprtAplyDtlPop(sbjctId, userId) {
                var data = "sbjctId="+sbjctId+"&userId="+userId;

                dialog = UiDialog("dialog1", {
                    title: "<spring:message code='exam.label.dsbl' />/<spring:message code='exam.label.snrs' /> <spring:message code='exam.label.exam.req' /> <spring:message code='exam.label.detail.info' />",     /* 장애인/고령자 */ /* 시험지원 */ /* 상세내용 */
                    width: 1000,
                    height: 750,
                    url: "/exam/admSprtAplyPopup.do?"+data,
                    autoresize: true
                });
            }
            /* 2 */
            function sprtAplyCnclRqst(examSprtAplyGrpId) {
                var data = "examSprtAplyGrpId="+examSprtAplyGrpId;

                dialog = UiDialog("dialog1", {
                    title: "<spring:message code='exam.label.dsbl' />/<spring:message code='exam.label.snrs' /> <spring:message code='exam.label.exam.req' /> <spring:message code='exam.label.cancel.request' />",     /* 장애인/고령자 */ /* 시험지원 */ /* 취소요청 */
                    width: 400,
                    height: 200,
                    url: "/exam/admSprtAplyCnclPopup.do?"+data,
                    autoresize: true
                });
            }
            /* 3 */
            function sendMsg() {
                var rcvUserInfoStr = "";
                var sendCnt = 0;

                $.each($('#sbstUserList').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
                    sendCnt++;
                    if (sendCnt > 1) rcvUserInfoStr += "|";
                    rcvUserInfoStr += $(this).attr("user_id");
                    rcvUserInfoStr += ";" + $(this).attr("user_nm");
                    rcvUserInfoStr += ";" + $(this).attr("mobile");
                    rcvUserInfoStr += ";" + $(this).attr("email");
                });

                if (sbstUserInfoListTable.getSelectedData("userId").length == 0) {
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
            function excelDown() {
                var excelGrid = { colModel: [] };

                excelGrid.colModel.push({label: 'No.', name: 'lineNo', align: 'center', width: '1000'});
                excelGrid.colModel.push({label: '<spring:message code='exam.label.org' />', name: 'orgnm', align: 'left',   width: '4000'});                    /* 기관 */
                excelGrid.colModel.push({label: '<spring:message code='exam.label.years' />', name: 'dgrsYr', align: 'center', width: '2000'});                 /* 년도 */
                excelGrid.colModel.push({label: '<spring:message code='exam.label.term' />', name: 'dgrsSmstrChrt', align: 'center', width: '2000'});           /* 학기 */
                excelGrid.colModel.push({label: '<spring:message code='exam.label.dept' />', name: 'deptnm', align: 'left',   width: '5000'});                  /* 학과 */
                excelGrid.colModel.push({label: '<spring:message code='exam.label.crs.code' />",', name: 'crclmnNo', align: 'center', width: '4000'});          /* 과목 코드 */
                excelGrid.colModel.push({label: '<spring:message code='exam.label.crs' />', name: 'sbjctnm', align: 'left',   width: '5000'});                  /* 과목 */
                excelGrid.colModel.push({label: '<spring:message code='exam.label.decls.cls' />', name: 'dvclasNcknm', align: 'center', width: '2000'});        /* 분반 */
                excelGrid.colModel.push({label: '<spring:message code='exam.label.user.no' />', name: 'stdntNo', align: 'center', width: '4000'});              /* 학번 */
                excelGrid.colModel.push({label: '<spring:message code='exam.label.user.nm' />', name: 'usernm', align: 'center', width: '3000'});               /* 이름 */
                excelGrid.colModel.push({label: '<spring:message code='exam.label.stare.type' />', name: 'gubun', align: 'center', width: '3000'});             /* 구분 */
                excelGrid.colModel.push({label: '<spring:message code='exam.label.exam.stare.type' />', name: 'examGbnnm', align: 'center', width: '5000'});    /* 시험 구분 */
                excelGrid.colModel.push({label: '<spring:message code='exam.label.req' />', name: 'examSprtAplyTynm', align: 'center', width: '5000'});         /* 요청사항 */
                excelGrid.colModel.push({label: '<spring:message code='exam.label.process.rslt' />', name: 'sprtRslt', align: 'center', width: '5000'});        /* 처리결과 */
                excelGrid.colModel.push({label: '<spring:message code='exam.label.cancel.request' />', name: 'cnclAplyStsnm', align: 'center', width: '3000'}); /* 취소요청 */

                var kvArr = [];
                kvArr.push({'key': 'orgId',         'val': $("#orgId").val()});
                kvArr.push({'key': 'deptId',        'val': $("#deptId").val()});
                kvArr.push({'key': 'sbjctId',       'val': $("#sbjctId").val()});
                kvArr.push({'key': 'aplyStscd',     'val': $("#aplyStscd").val()});
                // kvArr.push({'key': 'dgrsYr',        'val': $("#dgrsYr").val()});
                // kvArr.push({'key': 'dgrsSmstrChrt', 'val': $("#dgrsSmstrChrt").val()});
                kvArr.push({'key': 'searchValue',   'val': $("#searchValue").val()});
                kvArr.push({'key': 'excelGrid',     'val': JSON.stringify(excelGrid)});

                submitForm("/exam/admSprtAplyExcelDown.do", "", "", kvArr);
            }

            $(document).ready(function() {
                selectBoxChangeEvents();
                loadSprtAplyInfoList(1);

            });
        </script>
    </head>
    <body class="admin">
    <div id="wrap" class="main">

        <!-- 공통 메뉴 이동(moveMenu)용 폼 -->
        <form id="moveForm" method="post"></form>
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/admin_header.jsp"/>
        <!-- //common header -->

        <main class="common">
            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/admin_aside.jsp"/>
            <!-- //gnb -->
            <div id="content" class="content-wrap common">

                <div class="admin_sub">
                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">
                                <spring:message code='exam.label.dsbl' />/<!-- 장애인 -->
                                <spring:message code='exam.label.snrs' /> <!-- 고령자 -->
                                <spring:message code='exam.label.sprt' /><!-- 지원 -->
                                <spring:message code='exam.label.manage' /><!-- 관리 -->
                            </h2>
                            <uiex:navibar type="admin"/>
                        </div>
                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit">
                                    <label for="orgId">
                                        <spring:message code='exam.label.org' /><!-- 기관 -->
                                    </label>
                                </span>
                                <div class="itemList">
                                    <select class="form-select" id="orgId" name="orgId" title="<spring:message code='exam.label.org' />" style="width:300px;"><!-- 기관 -->
                                        <option value=""><spring:message code='exam.common.search.all' /></option><!-- 전체 -->
                                        <c:forEach var="item" items="${orgList}">
                                            <option value="${item.orgId}">${item.orgnm}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit">
                                    <label for="deptId">
                                        <spring:message code='exam.label.dept' />/<spring:message code='exam.label.crs' /><!-- 학과 --><!-- 과목 -->
                                    </label>
                                </span>
                                <div class="itemList">
                                    <select class="form-select chosen" id="deptId" name="deptId" title="<spring:message code='exam.label.dept' />" style=width:300px;"><!-- 학과 -->
                                        <option value=""><spring:message code='exam.common.search.all' /></option><!-- 전체 -->
                                        <c:forEach var="item" items="${deptList}">
                                            <option value="${item.deptId}">${item.deptnm}</option>
                                        </c:forEach>
                                    </select>
                                    <select class="form-select wide chosen" id="sbjctId" name="sbjctId" title="<spring:message code='exam.label.crs' />" style="width:300px;"><!-- 과목 -->
                                        <option value=""><spring:message code='exam.common.search.all' /></option><!-- 전체 -->
                                        <c:forEach var="item" items="${sbjctList}">
                                            <option value="${item.sbjctId}">${item.sbjctnm}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit">
                                    <label for="aplyStscd">
                                        <spring:message code='exam.label.process.status' /><!-- 처리상태 -->
                                    </label>
                                </span>
                                <div class="itemList">
                                    <select class="form-select" id="aplyStscd" name="aplyStscd" title="<spring:message code='exam.label.process.status' />" style="width:300px;"><!-- 처리상태 -->
                                        <option value=""><spring:message code='exam.common.search.all' /></option><!-- 전체 -->
                                        <option value="waiting"><spring:message code='exam.label.process.n' /></option><!-- 처리대기 -->
                                        <option value="complete"><spring:message code='exam.label.process.y' /></option><!-- 처리완료 -->
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit">
                                    <label for="searchValue">
                                        <spring:message code='exam.button.search.key' /><!-- 검색어 -->
                                    </label>
                                </span>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" id="searchValue" name="searchValue" placeholder="<spring:message code='exam.label.user.no' />/<spring:message code='exam.label.user.nm' /> <spring:message code='exam.button.search' />"/><!-- 학번 --><!-- 이름 --><!-- 검색 -->
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="loadSprtAplyInfoList(1);">
                                    <spring:message code='exam.button.search' /><!-- 검색 -->
                                </button>
                            </div>
                        </div>
                        <div class="board_top">
                            <h3 class="board-title">
                                <spring:message code='exam.label.applicate.y' /><!-- 신청자 -->
                            </h3>
                            <div class="right-area">
                                <a href="javascript:sendMsg()" class="btn basic small"><spring:message code='exam.button.eval.send' /></a><!-- 보내기 -->
                                <button type="button" class="btn type1 small" onclick="excelDown();"><spring:message code='exam.button.excel.down' /></button><!-- 엑셀 다운로드 -->
                                <uiex:listScale func="changeListScale" value="10" />
                            </div>
                        </div>
                        <div id="sprtArea">
                            <div id="sprtList"></div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    </body>
</html>