<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="knou.lms.menu.vo.MenuVO"%>
<%@page import="java.util.List"%>
<%@include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<% 
    // common_inc.jsp와의 자바 변수명 충돌을 피하기 위해 고유 명칭 사용
    String currentLeftMenuId = (String) request.getAttribute("adminMenuId"); 
%>
<script type="text/javascript">
    /**
     * TOP MENU 별 LEFT MENU HTML 캐시
     */
    let ADMIN_MENU_MAP = {};

    <%
    List<MenuVO> leftTopMenuList = (List<MenuVO>)request.getAttribute("topMenuList");

    if(leftTopMenuList != null) {
        for(MenuVO top : leftTopMenuList) {
    %>

    ADMIN_MENU_MAP['<%=top.getMenuId()%>'] = "";

    <%
        List<MenuVO> sub1List = top.getSubMenuList();

        if(sub1List != null) {
            for(MenuVO menu : sub1List) {
                boolean hasSub1 = menu.getSubMenuList() != null && !menu.getSubMenuList().isEmpty();

                if(!hasSub1) {
    %>

    ADMIN_MENU_MAP['<%=top.getMenuId()%>'] +=
        "<li>" +
            "<a href=\"#0\" " +
               "onclick=\"adminMoveMenu(this, '<%=menu.getMenuUrl()%>', '<%=menu.getMyTopMenuId()%>', '<%=menu.getMenuId()%>', '<%=menu.getMenunm()%>', '<%=menu.getLinkTargetTycd()%>'); return false;\" " +
               "title=\"<%=menu.getMenunm()%>\">" +
                "<span class='menu-text'>" +
                    "<%=menu.getMenunm()%>" +
                "</span>" +
            "</a>" +
        "</li>";

    <%
                } else {
    %>

    ADMIN_MENU_MAP['<%=top.getMenuId()%>'] +=
        "<li class='has-sub'>" +
            "<a href='#0' title='<%=menu.getMenunm()%>'>" +
                "<span class='menu-text'>" +
                    "<%=menu.getMenunm()%>" +
                "</span>" +
            "</a>" +
            "<ul class='sub'>";

    <%
                for(MenuVO menu2 : menu.getSubMenuList()) {
                    boolean hasSub2 = menu2.getSubMenuList() != null && !menu2.getSubMenuList().isEmpty();

                    if(!hasSub2) {
    %>

    ADMIN_MENU_MAP['<%=top.getMenuId()%>'] +=
        "<li>" +
            "<a href=\"#0\" " +
               "onclick=\"adminMoveMenu(this, '<%=menu2.getMenuUrl()%>', '<%=menu2.getMyTopMenuId()%>', '<%=menu2.getMenuId()%>', '<%=menu2.getMenunm()%>', '<%=menu2.getLinkTargetTycd()%>'); return false;\" " +
               "title=\"<%=menu2.getMenunm()%>\">" +
                "<%=menu2.getMenunm()%>" +
            "</a>" +
        "</li>";

    <%
                    } else {
    %>

    ADMIN_MENU_MAP['<%=top.getMenuId()%>'] +=
        "<li class='has-sub'>" +
            "<a href='#0' title='<%=menu2.getMenunm()%>'>" +
                "<%=menu2.getMenunm()%>" +
            "</a>" +
            "<ul class='sub_depth'>";

    <%
                        for(MenuVO menu3 : menu2.getSubMenuList()) {
    %>

    ADMIN_MENU_MAP['<%=top.getMenuId()%>'] +=
        "<li>" +
            "<a href=\"#0\" " +
               "onclick=\"adminMoveMenu(this, '<%=menu3.getMenuUrl()%>', '<%=menu3.getMyTopMenuId()%>', '<%=menu3.getMenuId()%>', '<%=menu3.getMenunm()%>', '<%=menu3.getLinkTargetTycd()%>'); return false;\" " +
               "title=\"<%=menu3.getMenunm()%>\">" +
                "<%=menu3.getMenunm()%>" +
            "</a>" +
        "</li>";

    <%
                        }
    %>

    ADMIN_MENU_MAP['<%=top.getMenuId()%>'] +=
            "</ul>" +
        "</li>";

    <%
                    }
                }
    %>

    ADMIN_MENU_MAP['<%=top.getMenuId()%>'] +=
            "</ul>" +
        "</li>";

    <%
                }
            }
        }
    %>

    <%
        }
    }
    %>

     /**
      * TOP MENU 클릭 (★ 사용자가 상단 메뉴를 직접 클릭할 때만 세션 초기화)
      */
     function changeAdminTopmenu(obj, menuId) {
         $(".topmenu li").removeClass("active");
         $(obj).parent().addClass("active");
         let menuName = $(obj).find("span").text();

         $("#navSubTitle").text(menuName);
         $("#navList").html(ADMIN_MENU_MAP[menuId]);
         
         // ★ 직접 대메뉴를 클릭해 이동할 때는 기존에 저장된 세션 상태를 완전히 지웁니다.
         sessionStorage.removeItem("LAST_ADMIN_TOP_MENU_ID");
         sessionStorage.removeItem("LAST_ADMIN_MENU_ID");
         sessionStorage.removeItem("LAST_ADMIN_TOP_MENU_NM");

         if(typeof procAdminMenuEvent === 'function') {
             procAdminMenuEvent();
         }
     }

    /**
     * 첫 메뉴 자동 이동
     */
    function moveFirstMenu() {
        let $firstMenu = $("#navList").find("a[onclick*='adminMoveMenu']").first();
        if($firstMenu.length > 0) {
            $firstMenu.trigger("click");
        }
    }

    /**
     * 최초 LEFT MENU 렌더링 및 페이지 복원 실행
     */
    $(document).ready(function() {
        // 1. 주소창 및 서버 데이터 확보
        let currentPath = window.location.pathname;
        let isListPage = currentPath.indexOf("List") > -1;

        let serverTopMenuId = '${topMenu.menuId}';
        let serverLeftMenuId = '<%= currentLeftMenuId != null ? currentLeftMenuId : "" %>'; 

        // 최종 제어할 변수
        let topMenuId = '';
        let currentLeftMenuId = '';

        // 2. 세션 스토리지에 백업된 데이터 먼저 확인
        let sessionTopId = sessionStorage.getItem("LAST_ADMIN_TOP_MENU_ID");
        let sessionLeftId = sessionStorage.getItem("LAST_ADMIN_MENU_ID");

        // 3. ★ [초강력 보안 필터] 
        // 서버 데이터가 존재하더라도, 기존 세션 정보가 있다면 세션을 "절대 우선"합니다.
        // (컨트롤러가 등록/수정/목록 화면에서 대소문자 오타나 엉뚱한 기본 메뉴ID를 던지는 버그 방어)
        if (sessionTopId && sessionTopId !== '') {
            // 이전에 보던 메뉴가 세션에 있다면 서버 데이터는 과감히 무시하고 세션값 복원
            topMenuId = sessionTopId;
            currentLeftMenuId = sessionLeftId;

            // 단, 목록 화면이면서 서버가 준 소메뉴 ID가 현재 대메뉴 맵 안에 실제로 존재하는 정상적인 데이터인 경우에만 세션 갱신 허용
            if (isListPage && serverTopMenuId && serverLeftMenuId && ADMIN_MENU_MAP[serverTopMenuId]) {
                // 현재 맵에 해당 소메뉴 링크 코드가 들어있는지 확실히 검증 후 세션 동기화
                if (ADMIN_MENU_MAP[serverTopMenuId].indexOf(serverLeftMenuId) > -1) {
                    topMenuId = serverTopMenuId;
                    currentLeftMenuId = serverLeftMenuId;
                    sessionStorage.setItem("LAST_ADMIN_TOP_MENU_ID", topMenuId);
                    sessionStorage.setItem("LAST_ADMIN_MENU_ID", currentLeftMenuId);
                    sessionStorage.setItem("LAST_ADMIN_TOP_MENU_NM", '${topMenu.menunm}');
                }
            }
        } else {
            // 세션이 아예 없는 경우 (로그인 후 최초 메인 진입 시) 서버 데이터를 차선책으로 채움
            topMenuId = serverTopMenuId;
            currentLeftMenuId = serverLeftMenuId;

            if (topMenuId && topMenuId !== '' && ADMIN_MENU_MAP[topMenuId]) {
                sessionStorage.setItem("LAST_ADMIN_TOP_MENU_ID", topMenuId);
                sessionStorage.setItem("LAST_ADMIN_MENU_ID", currentLeftMenuId);
                sessionStorage.setItem("LAST_ADMIN_TOP_MENU_NM", '${topMenu.menunm}');
            }
        }

        // 4. 주소창 파라미터(QueryString)에 명시적으로 박혀서 온 경우는 최우선 순위 부여
        let urlParams = new URLSearchParams(window.location.search);
        topMenuId = urlParams.get('topMenuId') || topMenuId;
        currentLeftMenuId = urlParams.get('adminMenuId') || currentLeftMenuId;

        // 5. [최종 안전장치] 데이터가 오염되었거나 아예 비어있다면 권한 있는 첫 번째 대메뉴 활성화
        let menuKeys = Object.keys(ADMIN_MENU_MAP);
        if (!topMenuId || topMenuId === '' || !ADMIN_MENU_MAP[topMenuId]) {
            if (menuKeys.length > 0) {
                topMenuId = menuKeys[0]; 
                sessionStorage.setItem("LAST_ADMIN_TOP_MENU_ID", topMenuId);
            }
        }

        // 6. 메뉴 엘리먼트 실제 렌더링
        if (topMenuId && topMenuId !== '') {
            let menuTitle = sessionStorage.getItem("LAST_ADMIN_TOP_MENU_NM");
            if (!menuTitle || menuTitle === '' || (isListPage && serverTopMenuId == topMenuId)) {
                menuTitle = '${topMenu.menunm}' || '관리자 메뉴';
            }
            $("#navSubTitle").text(menuTitle);
            
            if (ADMIN_MENU_MAP[topMenuId]) {
                $("#navList").html(ADMIN_MENU_MAP[topMenuId]);
            }

            if (typeof procAdminMenuEvent === 'function') {
                procAdminMenuEvent();
            }

            // 7. 소메뉴 active 하이라이트 활성화 및 트리 오픈
            if (currentLeftMenuId && currentLeftMenuId !== '') {
                let $targetA = $("#navList").find("a[onclick*='" + currentLeftMenuId + "']");

                if ($targetA && $targetA.length > 0) {
                    $targetA.addClass("on active");
                    $targetA.closest("li").addClass("on active");

                    let parentsLi = $targetA.parents("li.has-sub");
                    let parentsUl = $targetA.parents("ul.sub, ul.sub_depth");

                    parentsLi.addClass("on active");
                    parentsUl.addClass("open");

                    parentsLi.children("a").find(".icon-svg-arrow").css('transform', 'rotate(90deg)');
                }
            }
        }
    });
</script>
<aside id="admin_menu" class="menu gnb-menu expanded">
    <div class="inner">
        <div class="option-control">
            <button type="button" class="btn border-0 btn-close ctrl-lnb">
                <i class="icon-svg-close mobile-elem" aria-hidden="true"></i>
                <i class="icon-svg-ctrl-collapse desktop-elem" aria-hidden="true"></i>
                <span class="title">메뉴접기</span>
            </button>
        </div>

        <div class="admin_user">
            <ul>
                <li><i class="icon-svg-layout-alt" aria-hidden="true"></i></li>
                <li><span class="current" id="navSubTitle"></span></li>
            </ul>
        </div>

        <div class="lnb">
            <ul id="navList" class="navList"></ul>
        </div>
    </div>
</aside>