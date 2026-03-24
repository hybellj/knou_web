<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
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
            <jsp:include page="/WEB-INF/jsp/common_new/navi_bar_prof.jsp"/>
            <div class="class_sub">
                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title">수강생정보</h2>
                    </div>
                    <!-- search typeA -->
                    <div class="search-typeA">
                        <div class="item">
                            <span class="item_tit"><label for="selectDate">검색어</label></span>
                            <div class="itemList">
                                <select class="form-select chosen" id="searchKey">
                                    <option value=""><spring:message code="common.all" /><!-- 전체 --></option>
                                    <option value="std"><spring:message code="std.label.learner" /><!-- 수강생 --></option>
                                    <option value="dsbl"><spring:message code="std.label.dis_studend" /><!-- 장애학생 --></option>
                                    <option value="audit"><spring:message code="std.label.auditor" /><!-- 청강생 --></option>
                                </select>
                                <input class="form-control wide" type="text" name="" id="searchValue" value="" placeholder="대표아이디/학번/이름 입력" autocomplete="off">
                            </div>
                        </div>
                        <div class="button-area">
                            <button type="button" class="btn search" onclick="listPaging(1)">검색</button>
                        </div>
                    </div>
                    <%--//search typeA--%>


                    <div id="stdInfoListArea">
                        <div class="board_top">
                            <h3 class="board-title">수강생</h3>
                            <div class="right-area">
                                <button type="button" class="btn type2">발신하기</button>
                                <button type="button" class="btn basic" onclick="downExcel();return false;"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></button>

                                <%-- 리스트/카드 선택 버튼 --%>
                                <span class="list-card-button"></span>

                                <%-- 목록 스케일 선택 --%>
                                <uiex:listScale func="changeListScale" value="${atndlcVO.listScale}"/>
                            </div>
                        </div>
                        <%-- 수강생 리스트 --%>
                        <div id="stdInfoList"></div>

                        <%-- 수강생 카드 폼 --%>
                        <div id="stdInfoList_cardForm" style="display:none">
                            <div class="card-header">
                                <div class="card-title">
                                    #[usernm]
                                </div>
                            </div>

                            <div class="card-body">
                                <div class="desc">
                                    <p><label>학과</label><strong>#[deptnm]</strong></p>
                                    <p><label>대표아이디</label><strong>#[userRprsId]</strong></p>
                                    <p><label>학번</label><strong>#[stdntNo]</strong></p>
                                    <p><label>이름</label><strong>#[usernm]</strong></p>
                                    <p><label>구분</label><strong>#[cmcrsGbncd]</strong></p>
                                    <p><label>학년</label><strong>#[scyr]</strong></p>
                                </div>
                                <div class="bottom_button">
                                    <button type="button" class="btn basic small" onclick="stdLrnStatPopup('#[varUserId]')">학습현황</button>
                                </div>
                            </div>

                        </div>

                    </div>
                    <!--//table-type2-->

                </div>
            </div>

        </div>
        <!-- //content -->

    </main>
    <!-- //classroom-->
</div>
<script type="text/javascript">
    let PAGE_INDEX = '<c:out value="${atndlcVO.pageIndex}" />';
    let LIST_SCALE = '<c:out value="${atndlcVO.listScale}" />';
    const SBJCT_ID = '<c:out value="${atndlcVO.sbjctId}" />';
    let stdInfoListTable;

    $(function () {
        $("#searchValue").on("keyup", function (e) {
            if (e.keyCode == 13) {
                listPaging(1);
            }
        });


        // 강의계획서 리스트 테이블
        stdInfoListTable = UiTable("stdInfoList", {
            pageFunc: listPaging,
            columns: [
                {
                    title: "No", field: "no", headerHozAlign: "center", hozAlign: "center",
                    width: 60, minWidth: 60
                }, // No
                {
                    title: "학과", field: "deptnm", headerHozAlign: "center", hozAlign: "center",
                    width: 200, minWidth: 120
                }, // 학과
                {
                    title: "대표아이디", field: "userRprsId", headerHozAlign: "center", hozAlign: "center",
                    width: 140, minWidth: 120
                }, // 대표아이디
                {
                    title: "학번", field: "stdntNo", headerHozAlign: "center", hozAlign: "center",
                    width: 170, minWidth: 110
                }, // 학번
                {
                    title: "이름", field: "usernm", headerHozAlign: "center", hozAlign: "center",
                    width: 120, minWidth: 100
                }, // 이름
                {
                    title: "구분", field: "stdGbnnm", headerHozAlign: "center", hozAlign: "center",
                    width: 160, minWidth: 110
                }, // 구분(코드명)
                {
                    title: "학년", field: "scyr", headerHozAlign: "center", hozAlign: "center",
                    width: 80, minWidth: 70
                }, // 학년
                {
                    title: "관리", field: "mgmt", headerHozAlign: "center", hozAlign: "center",
                    width: 0, minWidth: 110
                }  // 관리(학습현황 버튼)
            ],
            selectRow: "checkbox",
        });

        listPaging(1);
    })
    ;

    /**
     * 페이지이동
     * @param pageIndex
     */
    function listPaging(pageIndex) {
        PAGE_INDEX = pageIndex;
        const url = "/std/info/profStdInfoListAjax.do";

        const param = {
            sbjctId: SBJCT_ID
            , pageIndex: PAGE_INDEX
            , listScale: LIST_SCALE
            , searchKey: $('#searchKey').val()
            , searchValue: $('#searchValue').val()
        };
        ajaxCall(url, param, function (data) {
            if (data.result > 0) {
                let returnList = data.returnList || [];

                // 테이블 데이터 설정
                let dataList = createStdInfoListHTML(returnList, data.pageInfo);
                stdInfoListTable.clearData();
                stdInfoListTable.replaceData(dataList);
                stdInfoListTable.setPageInfo(data.pageInfo);
            } else {
                UiComm.showMessage(data.message, "error");
            }
        }, function (xhr, status, error) {
            UiComm.showMessage("<spring:message code="fail.common.msg" />", "error");
        }, true);

    }

    /**
     * 수강 구분명 셋팅
     * 수강생, 청강생, 장애학생
     * @param v 입력데이터
     * @returns {string} 조합된 구분명
     */
    function getStdGbnNm(v) {
        const labels = [];
        labels.push(v.audityn === "Y" ? "청강생" : "수강생");
        if (v.dsblyn === "Y") labels.push("장애학생");
        return labels.join("/");
    }

    /**
     * 학생정보 목록 테이블 그리기
     * @param list
     * @param pageInfo
     * @returns {*[]}
     */
    function createStdInfoListHTML(list, pageInfo) {
        let dataList = [];

        if (!list || list.length === 0) {
            return dataList;
        }

        list.forEach(function (v, i) {
            const lineNo = pageInfo.totalRecordCount - v.lineNo + 1;
            const stdGbnnm = getStdGbnNm(v);

            dataList.push({
                no: lineNo,
                deptnm: v.deptnm,
                userRprsId: v.userRprsId,
                stdntNo: v.stdntNo,
                usernm: v.usernm,
                stdGbnnm: stdGbnnm,
                scyr: (v.scyr == null ? "-" : v.scyr),
                mgmt: "<button type='button' class='btn basic small' onclick=\"stdLrnStatPopup('" + (v.userId || "") + "')\">학습현황</button>",
                varUserId: v.userId,
            });
        });

        return dataList;
    }

    /**
     * 수강생 학습 상태 팝업
     * @param atndlcId
     */
    function stdLrnStatPopup(userId) {
        if (!userId || !SBJCT_ID) {
            UiComm.showMessage("학습현황 조회 정보가 없습니다.", "info");
            return;
        }

        const url = "/cls/selectStdntWkPopupView.do"
            + "?sbjctId=" + encodeURIComponent(SBJCT_ID)
            + "&userId=" + encodeURIComponent(userId);

        const stdLrnStatDialog = UiDialog("stdLrnStatDialog", {
            title: "수강생 학습현황"
            , width: 1100
            , height: 800
            , modal: true
            , resizable: true
            , draggable: true
            , autoresize: false
            , url: url
        });
    }

    // list scale 변경
    function changeListScale(scale) {
        LIST_SCALE = scale;
        listPaging(1);
    }

    /**
     * 엑셀 다운로드
     */
    function downExcel() {
        const excelGrid = {
            colModel: [
                {label: '<spring:message code="main.common.number.no" />', name: 'lineNo', align: 'right', width: '1000'}
                , {label: '<spring:message code="std.label.dept" />', name: 'deptnm', align: 'left', width: '5000'}
                , {label: '대표아이디', name: 'userRprsId', align: 'center', width: '5000'}
                , {label: '학번', name: 'stdntNo', align: 'center', width: '5000'}
                , {label: '<spring:message code="std.label.name" />', name: 'usernm', align: 'left', width: '5000'}
                , {label: '<spring:message code="std.label.type" />', name: 'stdGbnnm', align: 'left', width: '5000'}
                , {label: '<spring:message code="std.label.hy" />', name: 'scyr', align: 'center', width: '2500'}
            ]
        };


        const url = "/std/info/profStdInfoListExcelDownload.do";
        const form = $("<form></form>").attr({method: "POST", action: url, name: "excelForm"});

        form.append($("<input/>", {type: "hidden", name: "sbjctId", value: SBJCT_ID}));
        form.append($("<input/>", {type: "hidden", name: "searchKey", value: ($("#searchKey").val() || "")}));
        form.append($("<input/>", {type: "hidden", name: "searchValue", value: ($("#searchValue").val() || "")}));
        form.append($("<input/>", {type: "hidden", name: "excelGrid", value: JSON.stringify(excelGrid)}));

        form.appendTo("body").submit().remove();
    }
</script>
</body>
</html>

