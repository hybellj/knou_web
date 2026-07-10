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
    let EPARAM = "${encParams}";
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
                            <h2 class="page-title">${uiex:getCurMenunm()}</h2> <%-- 현재 메뉴명 --%>
                            <uiex:navibar type="admin"/><%-- 네비게이션바 --%>
                        </div>

                        <!-- board top -->
                        <div class="board_top">
                            <select class="form-select" id="orgId" onchange="getMenuList()">
                                <option value="">기관 선택</option>
                                <c:forEach items="${orgList}" var="item">
                                    <option value="${item.orgId}">${item.orgnm}</option>
                                </c:forEach>
                            </select>
                            <!-- <h3 class="board-title">개인 문구</h3> -->
                            <div class="right-area">
                                <!-- Tab btn -->
                                <div class="tab_btn">
                                    <a href="#tab01" data-auth="PROF" data-gbn="MAIN" class="current">교수 글로벌메뉴 설정</a>
                                    <a href="#tab02" data-auth="PROF" data-gbn="LECT">교수 강의실메뉴설정</a>
                                    <a href="#tab03" data-auth="STDNT" data-gbn="MAIN">학습자 글로벌메뉴 설정</a>
                                    <a href="#tab04" data-auth="STDNT" data-gbn="LECT">학습자 강의실메뉴 설정</a>
                                    <input type="hidden" id="menuGbncd" value="${vo.menuGbncd}"/>
                                    <input type="hidden" id="menuAuthTycd" value="${vo.menuAuthTycd}"/>
                                </div>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">교수 글로벌메뉴 설정</h3>
                        </div>
                        <div class="msg-box ">
                            <p class="txt"><span class="fcBlue">"교수 글로벌메뉴"</span> 사용 여부 설정합니다.  </p>
                        </div>

                        <!--table-type-->
                        <div class="table-wrap">
                            <input type="hidden" id="menuDataRaw" value='<c:out value="${menuList}" escapeXml="false" />' />
                            <div id="menuList"></div>
                            <script type="text/javascript">
                                let menuListTable;
                                let langCd = "${langCd}";

                                $(function () {
                                    let cols = [
                                        {title: "<spring:message code='common.no'/>", field: "no",                  headerHozAlign:"center", hozAlign:"center", width: 90, minWidth: 90},
                                        {title: "<spring:message code='common.menu.first'/>",  field: "first",      headerHozAlign:"center", hozAlign: "left", width: 0, minWidth: 150},
                                        {title: "<spring:message code='common.menu.second'/>",  field: "second",    headerHozAlign:"center", hozAlign: "left", width: 0, minWidth: 150},
                                        {title: "<spring:message code='common.menu.third'/>", field: "third",       headerHozAlign:"center", hozAlign:"left", width: 0, minWidth: 150},
                                        {title: "<spring:message code='common.use'/>",field: "useyn",               headerHozAlign:"center", hozAlign: "center", width: 180, minWidth: 180}
                                    ];

                                    menuListTable = UiTable("menuList", {
                                        lang: "ko",
                                        table: "list",
                                        columns: cols    // 컬럼정보
                                    });

                                    getMenuList();
                                });
                                
                                function getMenuList() {
                                    UiComm.showLoading(true);

                                    let param = {
                                        encParams: EPARAM,
                                        orgId: $("#orgId").val(),
                                        menuGbncd: $("#menuGbncd").val(),
                                        menuAuthTycd: $("#menuAuthTycd").val()
                                    };

                                    $.ajax({
                                        url: "/org/orgMgr/admMenuStngListAjax.do",
                                        data: param,
                                        type: "GET",
                                        headers: {"X-Requested-With": "XMLHttpRequest"},
                                        success: function (data) {

                                            if (data.result > 0) {
                                                let returnList = data.returnList || [];

                                                // 테이블 데이터 세팅
                                                menuListTable.clearData();
                                                menuListTable.replaceData(createListHTML(returnList))

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
                                function createListHTML(list) {
                                    let dataList = [];

                                    list.forEach(function (item, i) {
                                        let useyn = item.useyn === "Y" ? "checked=true" : "";
                                        dataList.push({
                                            no: (i + 1),
                                            first: langCd == 'ko' ? item.firstMenunm : item.firstMenuEnnm,
                                            second: langCd == 'ko' ? item.secondMenunm : item.secondMenuEnnm,
                                            third: langCd == 'ko' ? item.thirdMenunm : item.thirdMenuEnnm,
                                            useyn: `<input type="checkbox" class="switch" data-menuuseid="\${item.menuUseId}" \${useyn} />`
                                        })
                                    });
                                    /*<div className="toggle-container">
                                        <input type="checkbox" id="toggle_label" className="toggle-checkbox"/>
                                        <label htmlFor="toggle_label" className="toggle-label"></label>
                                    </div>*/
                                    return dataList;
                                }
                            </script>

                        </div>
                        <!--//table-type-->

                    </div>
                </div>

            </div>
            <!-- //content -->

        </main>
        <!-- //admin-->

    </div>

    <script type="text/javascript">
        $(function () {
            bindTabClick();
            bindSwitchClick();
        });

        // 탭 이동
        function bindTabClick() {
            $(".tab_btn a").on("click", function(e) {
                e.preventDefault(); // 페이지 이동 방지

                // 1. 활성화 표시 변경
                $(".tab_btn a").removeClass("current");
                $(this).addClass("current");

                // 2. 클릭한 탭에서 파라미터 추출
                const authTycd = $(this).data("auth");
                const gbncd = $(this).data("gbn");

                // 3. Hidden 필드 동기화 (필요한 경우)
                $("#menuAuthTycd").val(authTycd);
                $("#menuGbncd").val(gbncd);

                // 4. 서버에 데이터 요청 (목록 조회 함수 호출)
                getMenuList();
            });
        }

        // 사용여부 변경
        function bindSwitchClick() {
            $(document).on("change", ".switch", function() {
                const $checkbox = $(this); // 현재 클릭된 체크박스
                const isChecked = $checkbox.is(":checked");
                const useyn = isChecked ? "Y" : "N";

                // 2. HTML에 심어둔 data-menuuseid 가져오기
                const menuUseId = $checkbox.data("menuuseid");

                console.log(useyn +"   "+ menuUseId);

                modifyMenuUseyn(menuUseId, useyn);
            });
        }

        // 사용여부 수정
        function modifyMenuUseyn(menuUseId, useyn) {
            const url = "/org/orgMgr/admMenuStngModify.do"
            const param = {
                encParmas : EPARAM,
                orgId: $("#orgId").val(),
                menuUseId: menuUseId,
                useyn: useyn
            };

            $.ajax({
                url: "/org/orgMgr/admMenuStngModify.do",
                data: param,
                type: "POST",
                headers: {"X-Requested-With": "XMLHttpRequest"},
                success: function (data) {
                    if (data.result <= 0) {
                        UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
                    }
                },
                error: function(xhr, status, error) {
                    UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
                }
            });
        }


    </script>

</body>
</html>

