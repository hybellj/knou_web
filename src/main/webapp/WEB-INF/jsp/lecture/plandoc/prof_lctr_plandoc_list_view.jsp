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

<body class="home colorA ${bodyClass}"><!-- 컬러선택시 클래스변경 -->
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
                        <h2 class="page-title">강의계획서</h2>
                        <div class="navi_bar">
                            <ul>
                                <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                <li>공지사항</li>
                                <li><span class="current">과목공지</span></li>
                            </ul>
                        </div>
                    </div>


                    <!-- search typeA -->
                    <div class="search-typeA">
                        <div class="item">
                            <span class="item_tit"><label for="selectDate">학사년도/학기</label></span>
                            <div class="itemList">
                                <select class="form-select chosen" id="selectDate1">
                                    <option value="2025년">2025년</option>
                                    <option value="2024년">2024년</option>
                                </select>
                                <select class="form-select chosen" id="selectDate2">
                                    <option value="2학기">2학기</option>
                                    <option value="1학기">1학기</option>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="selectCourse">운영과목</label></span>
                            <div class="itemList">
                                <select class="form-select chosen" id="selectCourse">
                                    <option value="대학원">대학원</option>
                                    <option value="평생교육">평생교육</option>
                                </select>
                                <select class="form-select wide" id="selectSubject">
                                    <option value="">운영과목 선택</option>
                                    <option value="운영과목1">운영과목1</option>
                                    <option value="운영과목2">운영과목2</option>
                                </select>
                            </div>
                        </div>

                        <div class="button-area">
                            <button type="button" class="btn search">검색</button>
                        </div>
                    </div>

                    <div id="plandocListArea">
                        <div class="board_top">
                            <h3 class="board-title">운영과목</h3>
                            <div class="right-area">
                                <%-- 리스트/카드 선택 버튼 --%>
                                <span class="list-card-button"></span>

                                <%-- 목록 스케일 선택 --%>
                                <uiex:listScale func="changeListScale" value="${lctrPlandocVO.listScale}"/>
                            </div>
                        </div>
                        <%-- 강의계획서 리스트 --%>
                        <div id="plandocList"></div>

                        <%-- 강의계획서 카드 폼 --%>
                        <div id="plandocList_cardForm" style="display:none">
                            <div class="card-header">
                                <div class="card-title">
                                    #[sbjctnm]
                                </div>
                            </div>

                            <div class="card-body">
                                <div class="desc">
                                    <p><label>년도</label><strong>#[sbjctYr]</strong></p>
                                    <p><label>학기</label><strong>#[sbjctSmstr]</strong></p>
                                    <p><label>기관</label><strong>#[orgnm]</strong></p>
                                    <p><label>학과</label><strong>#[deptnm]</strong></p>
                                    <p><label>과목코드</label><strong>#[sbjctCd]</strong></p>
                                    <p><label>과목명</label><strong>#[sbjctnm]</strong></p>
                                    <p><label>분반</label><strong>#[dvclasNo]</strong></p>
                                    <p><label>학점</label><strong>#[crdts]</strong></p>
                                </div>
                                <div class="etc">
                                    <p><label>공동교수</label><strong>#[coprofUsernm]</strong></p>
                                    <p><label>튜터</label><strong>#[tutUsernm]</strong></p>
                                    <p><label>조교</label><strong>#[assiUsernm]</strong></p>
                                    <p><label>강의계획서</label><strong>#[lsnplanyn]</strong></p>
                                </div>
                            </div>

                        </div>

                    </div>
                    <!--//table-type2-->

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
<script type="text/javascript">
    var CTX = "<%=request.getContextPath()%>";
    let PAGE_INDEX = '<c:out value="${plandocVO.pageIndex}" />';
    let LIST_SCALE = '<c:out value="${plandocVO.listScale}" />';
    let plandocListTable;

    $(function () {
        // 강의계획서 리스트 테이블
        plandocListTable = UiTable("plandocList", {
            pageFunc: listPaging,
            columns: [
                {
                    title: "No", field: "no", headerHozAlign: "center", hozAlign: "center", width: 50, minWidth: 50
                },  // No
                {
                    title: "년도", field: "sbjctYr", headerHozAlign: "center", hozAlign: "center", width: 80
                },  // 년도
                {
                    title: "학기", field: "sbjctSmstr", headerHozAlign: "center", hozAlign: "center", width: 80
                },  // 학기
                {
                    title: "기관", field: "orgnm", headerHozAlign: "center", hozAlign: "center", width: 120
                },  // 기관
                {
                    title: "학과", field: "deptnm", headerHozAlign: "center", hozAlign: "center", width: 120
                },  // 학과
                {
                    title: "과목코드", field: "sbjctCd", headerHozAlign: "center", hozAlign: "center", width: 120
                },  // 과목코드
                {
                    title: "과목명", field: "sbjctnm", headerHozAlign: "center", hozAlign: "left", width: 200
                },  // 과목명
                {
                    title: "분반", field: "dvclasNo", headerHozAlign: "center", hozAlign: "center", width: 80
                },  // 분반
                {
                    title: "학점", field: "crdts", headerHozAlign: "center", hozAlign: "center", width: 80
                },  // 학점
                {
                    title: "공동교수", field: "coprofUsernm", headerHozAlign: "center", hozAlign: "center", width: 100
                },  // 공동교수
                {
                    title: "튜터", field: "tutUsernm", headerHozAlign: "center", hozAlign: "center", width: 100
                },  // 튜터
                {
                    title: "조교", field: "assiUsernm", headerHozAlign: "center", hozAlign: "center", width: 100
                },  // 조교
                {
                    title: "강의계획서", field: "lsnplanyn", headerHozAlign: "center", hozAlign: "center", width: 80, formatter: "ynToOx"
                }   // 강의계획서 (O / X)
            ],
            // selectRow: "1",
            // selectRowFunc: checkRowSelect,
        });

        listPaging(1);
    })
    ;

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
        const url = "/lctr/plandoc/profLctrPlandocListAjax.do";

        const param = {
            sbjctYr: "2026"
            , sbjctSmstr: "1"
            , pageIndex: PAGE_INDEX
            , listScale: LIST_SCALE
        };
        ajaxCall(url, param, function (data) {
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

            dataList.push({
                no: lineNo,
                sbjctYr: v.sbjctYr,
                sbjctSmstr: v.sbjctSmstr,
                orgnm: v.orgnm,
                deptnm: v.deptnm,
                sbjctCd: v.sbjctCd,          // 과목코드
                sbjctnm: linkSbjctnm,        // 과목명 (링크)
                dvclasNo: v.dvclasNo,        // 분반
                crdts: v.crdts,              // 학점
                coprofUsernm: v.coprofUsernm,    // 공동교수
                tutUsernm: v.tutUsernm,      // 튜터
                assiUsernm: v.assiUsernm,    // 조교
                lsnplanyn: v.lsnplanyn,      // 강의계획서 (O/X)
                // 값 보관용
                valSbjctId: v.sbjctId
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
        // 상세 페이지로 이동
        location.href = "/lctr/plandoc/profLctrPlandocView.do?sbjctId=" + encodeURIComponent(sbjctId);
    }

</script>
</body>
</html>

