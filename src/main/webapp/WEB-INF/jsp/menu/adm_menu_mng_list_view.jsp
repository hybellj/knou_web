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
                                <a href="#pageTab01" class="current">메뉴 권한 관리</a>
                                <a href="#pageTab02">기관 메뉴 설정</a>
                            </div>
                        </div>

                        <!-- board top -->
                        <div class="board_top">
                            <select class="form-select" id="authrtGrpcd">
                                <option value="ADM"   data-gbn="MAIN">관리자 메뉴</option>
                                <option value="PROF"  data-gbn="MAIN">교수 글로벌메뉴</option>
                                <option value="PROF"  data-gbn="LECT">교수 강의실메뉴</option>
                                <option value="STDNT" data-gbn="MAIN">학생 글로벌메뉴</option>
                                <option value="STDNT" data-gbn="LECT">학생 강의실메뉴</option>
                            </select>
                            <div class="right-area">
                                <!-- 권한 탭 -->
                                <div class="tab_btn" id="authTabArea">
                                    <c:forEach items="${authrtTabList}" var="tab" varStatus="status">
                                        <a href="#tab0${status.index+1}"
                                           data-authrtid="${tab.authrtId}"
                                           class="${status.first ? 'current' : ''}">
                                            ${tab.menunm}
                                        </a>
                                    </c:forEach>
                                    <input type="hidden" id="menuGbncd"    value="MAIN"/>
                                    <input type="hidden" id="menuAuthTycd" value="ADM"/>
                                    <input type="hidden" id="authrtId"     value="${authrtTabList[0].authrtId}"/>
                                </div>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title" id="boardTitle">메뉴 권한 관리</h3>
                        </div>
                        <div class="msg-box">
                            <p class="txt"><span class="fcBlue" id="msgTitle">"관리자 메뉴"</span> 사용 여부 설정합니다.</p>
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
                {title: "<spring:message code='common.no'/>",          field: "no",      headerHozAlign:"center", hozAlign:"center", width: 90,  minWidth: 90},
                {title: "<spring:message code='common.menu.first'/>",   field: "first",   headerHozAlign:"center", hozAlign:"left",   width: 0,   minWidth: 150},
                {title: "<spring:message code='common.menu.second'/>",  field: "second",  headerHozAlign:"center", hozAlign:"left",   width: 0,   minWidth: 150},
                {title: "<spring:message code='common.menu.third'/>",   field: "third",   headerHozAlign:"center", hozAlign:"left",   width: 0,   minWidth: 150},
                {title: "<spring:message code='common.menu.fourth'/>",  field: "fourth",  headerHozAlign:"center", hozAlign:"left",   width: 0,   minWidth: 150},
                {title: "<spring:message code='common.menu.useyn'/>",   field: "useyn",   headerHozAlign:"center", hozAlign:"center", width: 180, minWidth: 180},
                {title: "<spring:message code='common.menu.writeyn'/>", field: "writeyn", headerHozAlign:"center", hozAlign:"center", width: 180, minWidth: 180}
            ];

            menuListTable = UiTable("menuList", {
                lang: "ko",
                table: "list",
                columns: cols
            });

            // 페이지 탭 이벤트
            bindPageTabClick();

            // select 변경 이벤트
            $("#authrtGrpcd").on("change", function() {
                var authrtGrpcd = $(this).val();
                var menuGbncd   = $(this).find("option:selected").data("gbn");

                $("#menuAuthTycd").val(authrtGrpcd);
                $("#menuGbncd").val(menuGbncd);

                updateBoardTitle();
                getAuthrtTabList(authrtGrpcd, menuGbncd);
            });

            // 권한 탭 클릭 이벤트
            bindTabClick();

            // 스위치 클릭 이벤트
            bindSwitchClick();

            // 초기 목록 조회
            getMenuList();

            // 사용 여부 설정 명칭 변경
            updateBoardTitle();
        });

        // URL 파라미터 가져오기
        function getUrlParam(name) {
            var results = new RegExp("[?&]" + name + "=([^&#]*)").exec(window.location.href);
            return results ? results[1] : "";
        }

        // 페이지 상단 메인 탭 클릭 이벤트
        function bindPageTabClick() {
            $("#pageTabArea a").off("click").on("click", function(e) {
                e.preventDefault();

                $("#pageTabArea a").removeClass("current");
                $(this).addClass("current");

                var href = $(this).attr("href");
                if (href === "#pageTab02") {
                    // Form에 데이터 세팅 후 submit
                    $("#pageTabForm input[name=menuId]").val("ADMMNG0000003");
                    $("#pageTabForm input[name=myTopMenuId]").val("ADMMNG0000001");
                    $("#pageTabForm input[name=menunm]").val("기관 메뉴 설정");
                    $("#pageTabForm input[name=linkTargetTycd]").val("self");
                    $("#pageTabForm input[name=menuGbncd]").val("ADM");
                    $("#pageTabForm").attr("action", "/menu/menuMgr/admMenuStngView.do");
                    $("#pageTabForm").submit();
                } else {
                    resetPage();
                }
            });
        }

        // 메뉴 권한 관리 탭 초기화
        function resetPage() {
            $("#authrtGrpcd").val("ADM");
            getAuthrtTabList("ADM", "MAIN");
        }

        // 권한 탭 목록 조회
        function getAuthrtTabList(authrtGrpcd, menuGbncd) {
            var url  = "/menu/menuMgr/admAuthrtTabList.do";
            var data = {
                encParams   : EPARAM,
                authrtGrpcd : authrtGrpcd,
                menuGbncd   : menuGbncd
            };

            ajaxCall(url, data, function(data) {
                var html = "";
                $.each(data, function(idx, tab) {
                    var current = idx === 0 ? "current" : "";
                    html += "<a href='#tab0" + (idx+1) + "' data-authrtid='" + tab.authrtId + "' class='" + current + "'>" + tab.menunm + "</a>";
                });
                // 권한 탭 영역만 교체
                $("#authTabArea").find("a").remove();
                $("#authTabArea").prepend(html);
                // 첫 번째 탭 기준 hidden 세팅
                $("#menuAuthTycd").val(authrtGrpcd);
                $("#menuGbncd").val(menuGbncd);
                $("#authrtId").val(data[0].authrtId);
                // 권한 탭 이벤트 재바인딩
                bindTabClick();
                // 목록 재조회
                getMenuList();
            }, function(xhr, status, error) {
                UiComm.showMessage('<spring:message code="fail.common.msg" />', "error");
            });
        }

        // 메뉴 목록 조회
        function getMenuList() {
            UiComm.showLoading(true);

            var param = {
                encParams    : EPARAM,
                menuGbncd    : $("#menuGbncd").val(),
                menuAuthTycd : $("#menuAuthTycd").val(),
                authrtId     : $("#authrtId").val()
            };

            $.ajax({
                url: "/menu/menuMgr/admMenuStngListAjax.do",
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
                var useyn   = item.useyn   === "Y" ? "checked=true" : "";
                var writeyn = item.writeyn  === "Y" ? "checked=true" : "";

                dataList.push({
                    no:      (i + 1),
                    first:   langCd == 'ko' ? item.firstMenunm  : item.firstMenuEnnm,
                    second:  langCd == 'ko' ? item.secondMenunm : item.secondMenuEnnm,
                    third:   langCd == 'ko' ? item.thirdMenunm  : item.thirdMenuEnnm,
                    fourth:  langCd == 'ko' ? item.fourthMenunm : item.fourthMenuEnnm,
                    useyn:   "<input type='checkbox' class='switch useyn'   " +
                             "data-authrtmenuid='"   + item.authrtMenuId     + "' " +
                             "data-menuid='"         + item.menuId           + "' " +
                             "data-authrtid='"       + item.authrtId         + "' " +
                             "data-gbncd='"          + item.menuGbncd  + "' " +
                             "data-type='useyn' "    + useyn + " />",
                    writeyn: "<input type='checkbox' class='switch writeyn' " +
                             "data-authrtmenuid='"   + item.authrtMenuId     + "' " +
                             "data-menuid='"         + item.menuId           + "' " +
                             "data-authrtid='"       + item.authrtId         + "' " +
                             "data-menugbncd='"      + item.menuGbncd  + "' " +
                             "data-useyn='"          + item.useyn  + "' " +
                             "data-type='writeyn' "  + writeyn + " />"
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

                $("#authrtId").val($(this).data("authrtid"));

                getMenuList();
            });
        }

        // 스위치(체크박스) 이벤트 바인딩
        function bindSwitchClick() {
            $(document).on("change", ".switch", function() {
                var $checkbox    = $(this);
                var isChecked    = $checkbox.is(":checked");
                var authrtMenuId = $checkbox.data("authrtmenuid");
                var menuId       = $checkbox.data("menuid");
                var authrtId     = $checkbox.data("authrtid");
                var menuGbncd    = $checkbox.data("menugbncd");
                var type         = $checkbox.data("type");
                var val          = isChecked ? "Y" : "N";
                var useyn        = $checkbox.data("useyn");

                if (type === 'useyn') {
                    modifyMenuUseyn(authrtMenuId, menuId, authrtId, menuGbncd, val);
                } else {
                    modifyMenuWriteyn(authrtMenuId, menuId, authrtId, menuGbncd, val, useyn);
                }
            });
        }

        // 사용여부 수정
        function modifyMenuUseyn(authrtMenuId, menuId, authrtId, menuGbncd, val) {
            var param = {
                encParams       : EPARAM,
                authrtMenuId    : authrtMenuId,
                menuId          : menuId,
                authrtId        : authrtId,
                menuGbncd       : menuGbncd,
                useyn           : val
            };

            $.ajax({
                url: "/menu/menuMgr/admMenuStngModify.do",
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

        // 쓰기허용 수정
        function modifyMenuWriteyn(authrtMenuId, menuId, authrtId, menuGbncd, val, useyn) {
            var param = {
                encParams       : EPARAM,
                authrtMenuId    : authrtMenuId,
                menuId          : menuId,
                authrtId        : authrtId,
                menuGbncd       : menuGbncd,
                writeyn         : val === "Y" ? "W" : "R",
                useyn           : useyn
            };

            $.ajax({
                url: "/menu/menuMgr/admMenuWriteynChgHstry.do",
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

        function updateBoardTitle() {
            var selectedText = $("#authrtGrpcd option:selected").text();
            $(".board-title").text(selectedText);
            $(".msg-box .fcBlue").text('"' + selectedText + '"');
        }
    </script>

</body>
</html>