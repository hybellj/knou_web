<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>
<style>
    .widget-list .custom-input input[disabled] + label {
        color: #aaa !important;
        cursor: not-allowed !important;
    }
</style>

<script type="text/javascript">
    let LIST_SCALE = '<c:out value="${vo.listScale}" />';
    let PAGE_INDEX = '<c:out value="${vo.pageIndex}" />';
    let EPARAM = '<c:out value="${encParams}" />';

    // list scale 변경
    function changeListScale(scale) {
        LIST_SCALE = scale;
        listPaging(1);
    }
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
            <div class="admin_sub">

                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                        <uiex:navibar type="admin"/>
                    </div>

                    <!-- search typeA -->
                    <div class="search-typeA">
                        <div class="item">
                            <span class="item_tit"><label for="selectSearch">검색어</label></span>
                            <div class="itemList">
                                <input class="form-control wide" type="text" name="searchValue" id="searchValue" value="" placeholder="기관ID / 기관명 / 담당자입력">
                            </div>
                        </div>
                        <div class="button-area">
                            <button type="button" class="btn search" onclick="listPaging(1)">검색</button>
                        </div>
                    </div>

                    <!-- board top -->
                    <div class="board_top">
                        <h3 class="board-title"><spring:message code="common.button.list"/><%-- 목록 --%></h3>
                        <div class="right-area">
                            <uiex:listScale func="changeListScale" value="${vo.listScale}" />
                        </div>
                    </div>

                    <!--table-type-->
                    <div class="table-wrap">
                        <div id="orgWidgetList"> </div>

                        <script type="text/javascript">
                            let orgWidgetListTable;

                            $(function () {
                                let cols = [
                                    {title: "<spring:message code='common.no'/>", field: "no", headerHozAlign:"center", hozAlign:"center", width: 50, minWidth: 50},
                                    {title: "<spring:message code='common.label.org.id'/>",  field: "orgId", headerHozAlign: "center", hozAlign: "center", width: 130, minWidth: 130},
                                    {title: "<spring:message code='common.label.org.name.full'/>",  field: "orgnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 150},
                                    {title: "<spring:message code='common.label.org.name.short'/>", field: "orgShrtnm", headerHozAlign:"center", hozAlign:"center", width: 150, minWidth: 150},
                                    {title: "<spring:message code='common.label.org.chrgr.nm'/>",  field: "chrgrnm", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120},
                                    {title: "<spring:message code='common.label.org.chrgr.nm'/> <spring:message code='common.label.contact.info'/>",  field: "chrgrCntct", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120},
                                    {title: "<spring:message code='common.label.org.chrgr.nm'/> <spring:message code='common.email'/>",  field: "chrgrEml", headerHozAlign: "center", hozAlign: "left", width: 250, minWidth: 250},
                                    {title: "<spring:message code='common.button.widgetSetting'/>",  field: "wigetStngBtn", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100}

                                ];

                                orgWidgetListTable = UiTable("orgWidgetList", {
                                    lang: "ko",
                                    table: "list",
                                    columns: cols,    // 컬럼정보
                                    pageFunc: listPaging,
                                });

                                listPaging(1);
                            });

                            // 기관정보 페이징 목록 조회
                            function listPaging(pageIndex) {
                                UiComm.showLoading(true);

                                PAGE_INDEX = pageIndex;

                                let extData = {
                                    searchValue : $("#searchValue").val(),
                                    pageIndex: pageIndex,
                                    listScale: LIST_SCALE
                                };
                                let param = {
                                    encParams: EPARAM,
                                    addParams: UiComm.makeEncParams(extData)
                                };

                                $.ajax({
                                    url: "/org/orgMgr/admOrgDashWgtStngListAjax.do",
                                    data: param,
                                    type: "GET",
                                    headers: {"X-Requested-With": "XMLHttpRequest"},
                                    success: function (data) {
                                        if (data.encParams != null && data.encParams !== '') {
                                            EPARAM = data.encParams;
                                        }

                                        if (data.result > 0) {
                                            let returnList = data.returnList || [];

                                            // 테이블 데이터 세팅
                                            let dataList = createListHTML(returnList, data.pageInfo);
                                            orgWidgetListTable.clearData();
                                            orgWidgetListTable.replaceData(dataList);
                                            orgWidgetListTable.setPageInfo(data.pageInfo);

                                            $("#totCnt").text(data.pageInfo.totalRecordCount);
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

                            // 테이블 그리기
                            function createListHTML(list, pageInfo) {
                                let dataList = [];

                                list.forEach(item => {
                                    dataList.push({
                                        // no: item.lineNo,
                                        no: pageInfo.totalRecordCount - item.lineNo + 1,
                                        orgId: item.orgId,
                                        orgnm: item.orgnm,
                                        orgShrtnm: item.orgShrtnm,
                                        orgTycd: item.orgTycd,
                                        chrgrnm: item.chrgrnm,
                                        chrgrCntct: setTelNo(item.chrgrCntct),
                                        chrgrEml: item.chrgrEml,
                                        wigetStngBtn: `<button class="btn basic small settingBtn" onclick="openWgtStngPop('\${item.orgId}')"><spring:message code='common.button.widgetSetting'/></button>`

                                    })
                                });

                                return dataList;
                            }

                            // 전화번호 나누기
                            function setTelNo(telNo) {
                                let len = telNo.length;
                                let part1 = "";
                                let part2 = "";
                                let part3 = "";

                                // 앞자리 구분 (서울 02는 2자리, 나머지는 3자리)
                                let prefixLen = telNo.startsWith("02") ? 2 : 3;

                                // 자르기
                                part1 = telNo.substring(0, prefixLen);         // 지역번호/010
                                part2 = telNo.substring(prefixLen, len - 4);   // 국번 (가운데 전부)
                                part3 = telNo.substring(len - 4);              // 뒷번호 (끝 4자리)

                                return part1 + "-" + part2 + "-" + part3;
                            }
                        </script>
                    </div>
                    <!--//table-type-->

                    <%-- modal1 --%>
                    <div class="modal-overlay" id="modal1" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
                        <div class="modal-content" tabindex="-1">
                            <div class="modal-header">
                                <h2 id="modal1Title">기관 위젯 설정</h2>
                                <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                            </div>
                            <div class="modal-body">
                                <input type="hidden" id="orgId" value=""/>
                                <div class="widget_setting">
                                    <%--교수 위젯 설정--%>
                                    <div class="setting_box">
                                        <div class="info-tit"><span>교수 위젯</span></div>
                                        <div class="widget-list">
                                            <span class="custom-input">
                                                <input type="checkbox" name="wigt_prof_today" id="wigt_prof_today" value="Y" checked="" disabled>
                                                <label for="wigt_prof_today">TODAY</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="checkbox" name="wigt_prof_msg" id="wigt_prof_msg" value="Y" checked="" disabled>
                                                <label for="wigt_prof_msg">알림</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="checkbox" name="wigt_prof_notice" id="wigt_prof_notice" value="Y" checked="" disabled>
                                                <label for="wigt_prof_notice">공지사항</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="checkbox" name="wigt_prof_schedule" id="wigt_prof_schedule" value="Y" checked="" disabled>
                                                <label for="wigt_prof_schedule">이달의 학사일정</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="checkbox" name="wigt_prof_qna" id="wigt_prof_qna" value="Y" checked="">
                                                <label for="wigt_prof_qna">강의Q&amp;A</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="checkbox" name="wigt_prof_counsel" id="wigt_prof_counsel" value="Y" checked="">
                                                <label for="wigt_prof_counsel">1:1상담</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="checkbox" name="wigt_prof_subject" id="wigt_prof_subject" value="Y" checked="">
                                                <label for="wigt_prof_subject">강의과목</label>
                                            </span>
                                        </div>
                                    </div>

                                    <%--학습자 위젯 설정--%>
                                    <div class="setting_box">
                                        <div class="info-tit"><span>학습자 위젯</span></div>
                                        <div class="widget-list">
                                            <span class="custom-input">
                                                <input type="checkbox" name="wigt_stu_today" id="wigt_stu_today" value="Y" checked="" disabled>
                                                <label for="wigt_stu_today">TODAY</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="checkbox" name="wigt_stu_msg" id="wigt_stu_msg" value="Y" checked="" disabled>
                                                <label for="wigt_stu_msg">알림</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="checkbox" name="wigt_stu_notice" id="wigt_stu_notice" value="Y" checked="" disabled>
                                                <label for="wigt_stu_notice">공지사항</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="checkbox" name="wigt_stu_schedule" id="wigt_stu_schedule" value="Y" checked="" disabled>
                                                <label for="wigt_stu_schedule">이달의 학사일정</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="checkbox" name="wigt_stu_qna" id="wigt_stu_qna" value="Y" checked="">
                                                <label for="wigt_stu_qna">강의Q&amp;A</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="checkbox" name="wigt_stu_pds" id="wigt_stu_pds" value="Y" checked="">
                                                <label for="wigt_stu_pds">강의자료실</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="checkbox" name="wigt_stu_contstdy" id="wigt_stu_contstdy" value="Y" checked="">
                                                <label for="wigt_stu_contstdy">강의 이어보기</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="checkbox" name="wigt_stu_subject" id="wigt_stu_subject" value="Y" checked="">
                                                <label for="wigt_stu_subject">수강과목</label>
                                            </span>
                                        </div>
                                    </div>

                                </div>
                                <div class="modal_btns">
                                    <button type="button" class="btn type1" onclick="onSave()">저장</button>
                                    <button type="button" class="btn type2 modalClose">닫기</button>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>

        </div>
        <!-- //content -->

    </main>
    <!-- //admin-->

</div>
<script type="text/javascript">
    $(function () {
        modalCloseEventBind();
    })
    let dialog;

    // 기관 위젯 설정 팝업 열기
    function openWgtStngPop(orgId) {
        $.ajax({
            url: "/org/orgMgr/admOrgDashWgtStngAjax.do",
            data: {orgId: orgId},
            type: "GET",
            headers: {"X-Requested-With": "XMLHttpRequest"},
            success: function (data) {
                if (data.result > 0) {
                    const returnMap = data.returnVO;
                    let profWgtList = returnMap.profWgtList;
                    let stdWgtList  = returnMap.stdWgtList;

                    // 모달 세팅
                    // 1. 모든 체크박스 초기화 (all 해제)
                    $(".widget_setting input[type='checkbox']").prop("checked", false);

                    // 2. 교수 위젯 체크 세팅
                    if(profWgtList) {
                        profWgtList.forEach(function(item) {
                            $("#" + item.widgetId).prop("checked", true);
                        });
                    }

                    // 3. 학습자 위젯 체크 세팅
                    if(stdWgtList) {
                        stdWgtList.forEach(function(item) {
                            $("#" + item.widgetId).prop("checked", true);
                        });
                    }
                    $("#orgId").val(orgId);

                    // 모달 열기
                    $("#modal1").addClass("active");

                } else {
                    UiComm.showMessage(data.message, "error");
                }
            },
            error: function(xhr, status, error) {
                UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
            }
        });
    }

    // 위젯 설정 저장
    function onSave() {
        UiComm.showLoading(true);

        // 교수 위젯 설정 (disabled 포함)
        const profWidgets = [];
        $(".widget-list input[id^='wigt_prof_']:checked").each(function () { // id="widget_prof_*"
           profWidgets.push({
               widgetId : $(this).attr("id"),
           });
        });

        // 학습자 위젯 설정 (disabled 포함)
        const stdWidgets = [];
        $(".widget-list input[id^='wigt_stu_']:checked").each(function() { // id="widget_stu_*"
            stdWidgets.push({
                widgetId: $(this).attr("id"),
            });
        });

        const param = {
            encParams: EPARAM,
            orgId    : $("#orgId").val(),
            profWidgetListJson : JSON.stringify(profWidgets),
            stdWidgetListJson  : JSON.stringify(stdWidgets),
        }

        // console.log("교수 전송 데이터:", profWidgets);
        $.ajax({
            url: "/org/orgMgr/admOrgDashWgtStngModify.do",
            data: param,
            type: "POST",
            headers: {"X-Requested-With": "XMLHttpRequest"},
            success: function (data) {
                if (data.encParams != null && data.encParams !== '') {
                    EPARAM = data.encParams;
                }
                if (data.result > 0) {
                    UiComm.showMessage(data.message).then(function () {
                        $(".modalClose").click();
                    });
                } else {
                    UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
                }
            },
            error: function(xhr, status, error) {
                UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
            },
            complete: function (){
                UiComm.showLoading(false);
                $("#orgId").val("");
            }
        });
    }

    // 모달 닫기 이벤트 바인딩
    function modalCloseEventBind() {
        document.addEventListener("click", (e) => {
            const $modal = $("#modal1");

            // 활성화되있는 모달이 없다면 패스
            if (!$modal.hasClass("active")) return;

            // 2. 클릭된 대상 확인
            const $target = $(e.target);

            if (
                $target.hasClass("modal-overlay") || // 배경클릭
                $target.closest(".modal-close").length > 0 || // 닫기 아이콘을 클릭
                $target.hasClass("modalClose") // 하단 닫기 버튼 클릭
            ) {
                $modal.removeClass("active");
                $modal.attr("aria-hidden", "true");

                // 3. 바디 스크롤 복구
                $("body").css("overflow", "");
            }
        });
    }

</script>

</body>
</html>

