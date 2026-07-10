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

                    	<form id="pageTabForm" method="post">
						    <input type="hidden" name="encParams"      value="${encParams}"/>
						    <input type="hidden" name="menuId"         value=""/>
						    <input type="hidden" name="myTopMenuId"    value=""/>
						    <input type="hidden" name="menunm"         value=""/>
						    <input type="hidden" name="linkTargetTycd" value=""/>
						    <input type="hidden" name="menuGbncd"      value=""/>
						</form>

                        <div class="page-info">
                            <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                            <uiex:navibar type="admin"/>
                        </div>

                        <!-- 페이지 탭 -->
                        <div class="board_top">
                            <div class="tab_btn" id="pageTabArea">
                                <a href="#pageTab01">메뉴 권한 관리</a>
                                <a href="#pageTab02" class="current">기관 메뉴 설정</a>
                            </div>
                        </div>

                        <!-- board top -->
                        <div class="board_top">
                            <select class="form-select" id="orgId">
                                <option value="">기관 선택</option>
                                <c:forEach items="${orgList}" var="item">
                                    <option value="${item.orgId}">${item.orgnm}</option>
                                </c:forEach>
                            </select>
                            <div class="right-area">
                                <!-- 권한 탭 -->
                                <div class="tab_btn" id="authTabArea">
                                    <a href="#tab01" data-auth="PROF"  data-gbn="MAIN" class="current">교수 글로벌메뉴 설정</a>
                                    <a href="#tab02" data-auth="PROF"  data-gbn="LECT">교수 강의실메뉴 설정</a>
                                    <a href="#tab03" data-auth="STDNT" data-gbn="MAIN">학습자 글로벌메뉴 설정</a>
                                    <a href="#tab04" data-auth="STDNT" data-gbn="LECT">학습자 강의실메뉴 설정</a>
                                    <input type="hidden" id="menuGbncd"    value="${vo.menuGbncd}"/>
                                    <input type="hidden" id="menuAuthTycd" value="${vo.menuAuthTycd}"/>
                                </div>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">기관 메뉴 설정</h3>
                        </div>
                        <div class="msg-box">
                            <p class="txt"><span class="fcBlue" id="boardTitle">"교수 글로벌메뉴"</span> 사용 여부 설정합니다.</p>
                        </div>

                        <!--table-type-->
                        <div class="table-wrap">
                            <div id="menuList"></div>
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
        let menuListTable;
        let langCd = "${langCd}";

        $(function () {
            // 테이블 초기화
            let cols = [
                {title: "<spring:message code='common.no'/>",         field: "no",     headerHozAlign:"center", hozAlign:"center", width: 90,  minWidth: 90},
                {title: "<spring:message code='common.menu.first'/>",  field: "first",  headerHozAlign:"center", hozAlign:"left",   width: 0,   minWidth: 150},
                {title: "<spring:message code='common.menu.second'/>", field: "second", headerHozAlign:"center", hozAlign:"left",   width: 0,   minWidth: 150},
                {title: "<spring:message code='common.menu.third'/>",  field: "third",  headerHozAlign:"center", hozAlign:"left",   width: 0,   minWidth: 150},
                {title: "<spring:message code='common.use'/>",         field: "useyn",  headerHozAlign:"center", hozAlign:"center", width: 180, minWidth: 180}
            ];

            menuListTable = UiTable("menuList", {
                lang: "ko",
                table: "list",
                columns: cols
            });

            // 페이지 탭 이벤트
            bindPageTabClick();

            // orgId 변경 이벤트
            $("#orgId").on("change", function() {
            	updateBoardTitle();
                getMenuList();
            });

            // 권한 탭 클릭 이벤트
            bindTabClick();

            // 스위치 클릭 이벤트
            bindSwitchClick();

            // 사용 여부 설정 명칭 변경
            updateBoardTitle();

            // 초기 목록 조회
            getMenuList();
        });

        // URL 파라미터 가져오기
        function getUrlParam(name) {
            var results = new RegExp("[?&]" + name + "=([^&#]*)").exec(window.location.href);
            return results ? results[1] : "";
        }

        // 페이지 탭 클릭 이벤트
        function bindPageTabClick() {
            $("#pageTabArea a").off("click").on("click", function(e) {
                e.preventDefault();

                $("#pageTabArea a").removeClass("current");
                $(this).addClass("current");

                var href = $(this).attr("href");
                if (href === "#pageTab01") {
                    $("#pageTabForm input[name=menuId]").val("ADMMNG0000003");
                    $("#pageTabForm input[name=myTopMenuId]").val("ADMMNG0000001");
                    $("#pageTabForm input[name=menunm]").val("메뉴 권한 관리");
                    $("#pageTabForm input[name=linkTargetTycd]").val("self");
                    $("#pageTabForm input[name=menuGbncd]").val("ADM");
                    $("#pageTabForm").attr("action", "/menu/menuMgr/admMenuMngListView.do");
                    $("#pageTabForm").submit();
                }
            });
        }

        // 메뉴 목록 조회
        function getMenuList() {
            UiComm.showLoading(true);

            var param = {
                encParams    : EPARAM,
                orgId        : $("#orgId").val(),
                menuGbncd    : $("#menuGbncd").val(),
                menuAuthTycd : $("#menuAuthTycd").val()
            };

            $.ajax({
                url: "/org/orgMgr/admMenuStngListAjax.do",
                data: param,
                type: "GET",
                headers: {"X-Requested-With": "XMLHttpRequest"},
                success: function(data) {
                    if (data.result > 0) {
                        menuListTable.clearData();
                        menuListTable.replaceData(createListHTML(data.returnList || []));
                    } else {
                        UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>", "error");
                    }
                },
                error: function() {
                    UiComm.showMessage('<spring:message code="fail.common.msg" />', "error");
                },
                complete: function() {
                    UiComm.showLoading(false);
                }
            });
        }

        // 테이블 데이터 생성
        function createListHTML(list) {
            var dataList = [];

            list.forEach(function(item, i) {
                var useyn = item.useyn === "Y" ? "checked=true" : "";
                dataList.push({
                    no:     (i + 1),
                    first:  langCd == 'ko' ? item.firstMenunm  : item.firstMenuEnnm,
                    second: langCd == 'ko' ? item.secondMenunm : item.secondMenuEnnm,
                    third:  langCd == 'ko' ? item.thirdMenunm  : item.thirdMenuEnnm,
                    useyn:  "<input type='checkbox' class='switch' data-menuuseid='" + item.menuUseId + "' " + useyn + " />"
                });
            });

            return dataList;
        }

        // 권한 탭 클릭 이벤트 바인딩
        function bindTabClick() {
		    $("#authTabArea a").off("click").on("click", function(e) {
		        e.preventDefault();

		        $("#authTabArea a").removeClass("current");
		        $(this).addClass("current");

		        $("#menuAuthTycd").val($(this).data("auth"));
		        $("#menuGbncd").val($(this).data("gbn"));

		        updateBoardTitle(); // ✅ 추가
		        getMenuList();
		    });
		}

        // 스위치(체크박스) 이벤트 바인딩
        function bindSwitchClick() {
            $(document).on("change", ".switch", function() {
                var $checkbox = $(this);
                var isChecked = $checkbox.is(":checked");
                var menuUseId = $checkbox.data("menuuseid");
                var useyn     = isChecked ? "Y" : "N";

                modifyMenuUseyn(menuUseId, useyn);
            });
        }

        // 사용여부 수정
        function modifyMenuUseyn(menuUseId, useyn) {
            var param = {
                encParams : EPARAM,
                orgId     : $("#orgId").val(),
                menuUseId : menuUseId,
                useyn     : useyn
            };

            $.ajax({
                url: "/org/orgMgr/admMenuStngModify.do",
                data: param,
                type: "POST",
                headers: {"X-Requested-With": "XMLHttpRequest"},
                success: function(data) {
                    if (data.result <= 0) {
                        UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>", "error");
                    }
                },
                error: function() {
                    UiComm.showMessage('<spring:message code="fail.common.msg" />', "error");
                }
            });
        }

     // 타이틀 업데이트
        function updateBoardTitle() {
            var tabText = $("#authTabArea a.current").text().trim();
            var orgText = $("#orgId option:selected").text().trim();
            var title   = "";

            if (orgText && orgText !== "기관 선택") {
                title = orgText + " - " + tabText;
            } else {
                title = tabText;
            }

            $("#boardTitle").text('"' + title + '"');
        }
    </script>

</body>
</html>