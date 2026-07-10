<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>

    <script type="text/javascript">
        let PAGE_INDEX = '<c:out value="${plandocVO.pageIndex}" />';
        let LIST_SCALE = '<c:out value="${plandocVO.listScale}" />';
        let EPARAM = '<c:out value="${encParams}" />';
        let PLANDOC_REGIST_PERIOD_YN = '<c:out value="${plandocRegistPeriodYn}" />';
        let PLANDOC_MODIFY_PERIOD_YN = '<c:out value="${plandocModifyPeriodYn}" />';

        $(function () {
            listPaging(1);

            // 검색어 입력 후 Enter 키로 목록을 조회한다.
            $("#searchValue").on("keydown", function (e) {
                if (e.keyCode == 13) {
                    listPaging(1);
                }
            });
        });

        /**
         * 로우 선택 시 강의계획서 확인
         * 사용X => 과목명에 link 넣는 것으로 변경
         * @param data 선택 row
         */
        function checkRowSelect(data) {
            if (data.lsnplanyn !== "Y") {
                UiComm.showMessage("강의계획서가 등록되지 않았습니다.", "info");
                return;
            }
            viewPlandoc(data.valSbjctId);
        }

        /**
         * 페이지 불러오기
         * @param pageIndex
         */
        function listPaging(pageIndex) {
            PAGE_INDEX = pageIndex;
            const url = "/lctr/plandoc/admLctrPlandocListAjax.do";

            const extData = {
                    sbjctYr: $("#sbjctYr").val()
                    , smstrChrtId: $("#sbjctSmstr").val()
                    , orgId: $("#orgId").val()
                    , sbjctId: $("#sbjctId").val()
                    , searchValue: $("#searchValue").val()
                    , pageIndex: PAGE_INDEX
                    , listScale: LIST_SCALE
                }
            ;

            const param = {
                encParams: EPARAM
                , addParams: UiComm.makeEncParams(extData)
            };

            ajaxCall(url, param, function (data) {
                if (data.encParams != null && data.encParams != '') {
                    EPARAM = data.encParams;
                }
                if (data.result > 0) {
                    let returnList = data.returnList || [];

                    // 테이블 데이터 설정
                    let dataList = createPlandocListHTML(returnList, data.pageInfo);
                    plandocListTable.clearData();
                    plandocListTable.replaceData(dataList);
                    plandocListTable.setPageInfo(data.pageInfo);
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }, function (xhr, status, error) {
                UiComm.showMessage("<spring:message code="fail.common.msg" />", "error");
            }, true);

        }

        /**
         * 강의계획서 html 렌더링 데이터 생성
         * @param list
         * @param pageInfo
         * @returns {*[]}
         */
        function createPlandocListHTML(list, pageInfo) {
            let dataList = [];

            if (!list || list.length === 0) {
                return dataList;
            }

            list.forEach(function (v, i) {
                const lineNo = pageInfo.totalRecordCount - v.lineNo + 1;

                // 상세 이동 링크
                let sbjctnm = (v.sbjctnm || "").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll('"', "&quot;");
                let linkSbjctnm = v.lsnplanyn === "Y" ? "<a href='#0' class='link' onclick='viewPlandoc(\"" + v.sbjctId + "\"); return false;'>" + sbjctnm + "</a>" : sbjctnm;
                let manage = "<button type='button' class='btn basic small' onclick='writePlandoc(\"" + v.sbjctId + "\", \"" + v.lsnplanyn + "\")'>" + (v.lsnplanyn === "Y" ? "수정" : "등록") + "</button>";
                if (v.lsnplanyn === "Y" && isPlandocWritePeriod()) {
                    manage += "<button type='button' class='btn basic small' onclick='deletePlandoc(\"" + v.sbjctId + "\")'>삭제</button>";
                }

                dataList.push({
                    no: lineNo,
                    sbjctYr: v.sbjctYr,
                    sbjctSmstr: v.sbjctSmstr,
                    orgnm: v.orgnm,
                    sbjctTynm: v.sbjctTynm, // 과목분류
                    lctrGbnnm: v.lctrGbnnm, // 강의형태
                    crclmnNo: v.crclmnNo,          // 과목코드
                    sbjctnm: linkSbjctnm,        // 과목명 (링크)
                    dvclasNo: v.dvclasNo,        // 분반
                    cmcrsGbnnm: v.cmcrsGbnnm,        // 이수구분
                    profUsernm: v.profUsernm,        // 담당교수
                    tutUsernm: v.tutUsernm,      // 담당튜터
                    manage: manage,
                    // 값 보관용
                    valSbjctId: v.sbjctId,
                    regDttm: v.regDttm
                });
            });

            return dataList;
        }

        /**
         * listScale 변경
         * @param scale
         */
        function changeListScale(scale) {
            LIST_SCALE = scale;
            listPaging(1);
        }

        /**
         * 상세페이지 이동
         * @param sbjctId
         */
        function viewPlandoc(sbjctId) {

            const extData = {
                sbjctId: sbjctId
            };

            // 상세 페이지로 이동
            location.href = "/lctr/plandoc/admLctrPlandocView.do?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams(extData);
        }

        /**
         * 등록/수정 페이지 이동
         * @param sbjctId
         * @param lsnplanyn
         */
        function writePlandoc(sbjctId, lsnplanyn) {
            const isModify = lsnplanyn === "Y";
            const periodYn = isModify ? PLANDOC_MODIFY_PERIOD_YN : PLANDOC_REGIST_PERIOD_YN;
            if (periodYn !== "Y") {
                UiComm.showMessage(isModify ? "강의계획서 수정기간이 아닙니다." : "강의계획서 등록기간이 아닙니다.", "warning");
                return;
            }

            const extData = {
                sbjctId: sbjctId
            };

            const url = isModify ? "/lctr/plandoc/admLctrPlandocModifyView.do" : "/lctr/plandoc/admLctrPlandocRegistView.do";
            location.href = url + "?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams(extData);
        }

        function isPlandocWritePeriod() {
            return PLANDOC_REGIST_PERIOD_YN === "Y" || PLANDOC_MODIFY_PERIOD_YN === "Y";
        }

        /**
         * 강의계획서 삭제.
         * 등록/수정기간 중에만 삭제할 수 있으며, 성공 후 현재 목록 페이지를 다시 조회한다.
         */
        function deletePlandoc(sbjctId) {
            if (!isPlandocWritePeriod()) {
                UiComm.showMessage("강의계획서 등록/수정기간이 아닙니다.", "warning");
                return;
            }

            UiComm.showMessage("삭제하시겠습니까?", "confirm").then(function (result) {
                if (!result) return;

                const param = {
                    encParams: EPARAM,
                    addParams: UiComm.makeEncParams({sbjctId: sbjctId})
                };

                ajaxCall("/lctr/plandoc/admLctrPlandocDeleteAjax.do", param, function (res) {
                    if (res.encParams) {
                        EPARAM = res.encParams;
                    }
                    if (res.result > 0) {
                        UiComm.showMessage(res.message || "삭제되었습니다.", "success").then(function () {
                            listPaging(PAGE_INDEX);
                        });
                    } else {
                        UiComm.showMessage(res.message || "<spring:message code='fail.common.msg' />", "error");
                    }
                }, function () {
                    UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");
                }, true);
            });
        }

        // 학기기수 세팅 변경
        function changeSmstrChrt() {

            const $sbjctSmstr = $("#sbjctSmstr");

            // 초기화
            $sbjctSmstr.off("change");
            $sbjctSmstr.empty();

            const url = "/crs/termMgr/admSmstrListByDgrsYrAjax.do";
            const param = {
                dgrsYr: $("#sbjctYr").val()
            }

            ajaxCall(url, param, function (data) {
                if (data.result > 0) {
                    let resultList = data.returnList || [];
                    // 전체
                    $sbjctSmstr.append(`<option value=""><spring:message code="crs.label.open.term" /></option>`);

                    // 학기 목록
                    $.each(resultList, function (i, item) {
                        $sbjctSmstr.append(`<option value="${item.smstrChrtId}">${item.smstrChrtnm}</option>`);
                    });

                    $sbjctSmstr.trigger("chosen:updated");

                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }, function () {
                UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");
            }, true);
        }

        /**
         * 기관 변경
         */
        function changeOrg() {
            $("#sbjctId").val("");

            loadSbjctList();
        }

        /**
         * 과목 목록 불러오기
         */
        function loadSbjctList() {
            const url = "/lctr/plandoc/sbjctListAjax.do";
            const param = {
                sbjctYr: $("#sbjctYr").val()
                , smstrChrtId: $("#sbjctSmstr").val()
                , orgId: $("#orgId").val()
            }

            ajaxCall(url, param, function (data) {
                if (data.result > 0) {
                    let html = "";
                    html += "<option value=''>운영과목 선택</option>";

                    if (data.result > 0) {
                        $.each(data.returnList, function (i, item) {
                            html += "<option value='" + item.sbjctId + "'>";
                            html += item.sbjctnm;
                            html += "</option>";
                        });
                    }

                    $("#sbjctId").html(html);
                    $("#sbjctId").trigger("chosen:updated");

                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }, function () {
                UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");
            }, true);

        }
    </script>

</head>

<body class="admin">
<div id="wrap" class="main">
    <!-- common header -->
    <jsp:include page="/WEB-INF/jsp/common_new/admin_header.jsp"/>
    <!-- //common header -->

    <!-- dashboard -->
    <main class="common">

        <!-- gnb -->
        <jsp:include page="/WEB-INF/jsp/common_new/admin_aside.jsp"/>
        <!-- //gnb -->

        <!-- content -->
        <div id="content" class="content-wrap common">
            <div class="admin_sub_top">
                <div class="date_info">
                    <i class="icon-svg-calendar" aria-hidden="true"></i>2025년 2학기 7주차 : 2025.10.05 (월) ~ 2025.10.16 (목)
                </div>
            </div>
            <div class="admin_sub">
                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                        <uiex:navibar type="admin"/>
                    </div>


                    <!-- search typeA -->
                    <div class="search-typeA">
                        <div class="item">
                            <span class="item_tit"><label for="orgId"><spring:message code="common.label.org"/><%--기관--%></label></span>
                            <div class="itemList">
                                <select class="form-select chosen" id="orgId" onchange="changeOrg()">
                                    <c:forEach var="item" items="${filterOptions.orgList}">
                                        <option value="${item.orgId}" ${item.orgId eq defaultOrgId ? 'selected' : ''}>${item.orgnm}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="sbjctYrSmstr"><spring:message code="cls.label.academic.year"/>/<spring:message code="common.term"/><%--학사년도/학기--%></label></span>
                            <div class="itemList">
                                <select class="form-select chosen" id="sbjctYr" onchange="changeSmstrChrt()">
                                    <c:forEach var="item" items="${filterOptions.yearList}">
                                        <option value="${item}" ${item eq defaultYear ? 'selected' : ''}>
                                                ${item}
                                        </option>
                                    </c:forEach>
                                </select>
                                <select class="form-select chosen" id="sbjctSmstr">
                                    <option value="">개설학기</option>
                                    <c:forEach var="item" items="${filterOptions.smstrChrtList}">
                                        <option value="${item.smstrChrtId}" <%--${item.dgrsSmstrChrt eq defaultTerm ? 'selected' : ''}--%>>
                                                ${item.smstrChrtnm}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="searchValue"><spring:message code="common.search.keyword"/><%--검색어--%></label></span>
                            <div class="itemList">
                                <input class="form-control" type="text" name="" id="searchValue" value="${plandocVO.searchValue}" placeholder="과목명 검색">
                            </div>
                        </div>

                        <div class="button-area">
                            <button type="button" class="btn search" onclick="listPaging(1)">검색</button>
                        </div>
                    </div>

                    <div id="plandocListArea">
                        <div class="board_top">
                            <h3 class="board-title">운영과목</h3>
                            <div class="right-area">
                                <button type="button" class="btn basic">학사연동 가져오기</button>
                                <%-- 목록 스케일 선택 --%>
                                <uiex:listScale func="changeListScale" value="${plandocVO.listScale}"/>
                            </div>
                        </div>
                        <%-- 강의계획서 리스트 --%>
                        <div id="plandocList"></div>

                        <script>
                            // 강의계획서 리스트 테이블
                            let plandocListTable = UiTable("plandocList", {
                                pageFunc: listPaging,
                                initialSort: [{column: "regDttm", dir: "desc"}],
                                columns: [
                                    {
                                        title: "No", field: "no", headerHozAlign: "center", hozAlign: "center", width: 50, minWidth: 50
                                    },  // No
                                    {
                                        title: "기관", field: "orgnm", headerHozAlign: "center", hozAlign: "center", minWidth: 170, headerSort: true
                                    },  // 기관
                                    {
                                        title: "과목분류", field: "sbjctTynm", headerHozAlign: "center", hozAlign: "center", minWidth: 80
                                    },  // 과목분류
                                    {
                                        title: "강의형태", field: "lctrGbnnm", headerHozAlign: "center", hozAlign: "center", minWidth: 120, headerSort: true
                                    },  // 강의형태
                                    {
                                        title: "과목코드", field: "crclmnNo", headerHozAlign: "center", hozAlign: "center", minWidth: 80
                                    },  // 과목코드
                                    {
                                        title: "과목명", field: "sbjctnm", headerHozAlign: "center", hozAlign: "left", width: 0, minWidth: 220, headerSort: true
                                    },  // 과목명
                                    {
                                        title: "분반", field: "dvclasNo", headerHozAlign: "center", hozAlign: "center", minWidth: 60
                                    },  // 분반
                                    {
                                        title: "이수구분", field: "cmcrsGbnnm", headerHozAlign: "center", hozAlign: "center", minWidth: 100, headerSort: true
                                    },  // 이수구분
                                    {
                                        title: "담당교수", field: "profUsernm", headerHozAlign: "center", hozAlign: "center", minWidth: 100, headerSort: true
                                    },  // 담당교수
                                    {
                                        title: "담당튜터", field: "tutUsernm", headerHozAlign: "center", hozAlign: "center", minWidth: 100, headerSort: true
                                    },  // 담당튜터
                                    {
                                        title: "관리", field: "manage", headerHozAlign: "center", hozAlign: "center", minWidth: 120
                                    }
                                ],
                            });

                        </script>

                    </div>
                    <!--//table-type2-->

                </div>

            </div>
        </div>
        <!-- //content -->


        <!-- common footer -->
    </main>
    <!-- //dashboard-->

</div>
</body>
</html>

