<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="knou.lms.menu.vo.MenuVO"%>
<%@page import="knou.framework.common.AdminMenuInfo"%>
<%@page import="knou.framework.common.SessionInfo"%>
<%@page import="knou.framework.common.ParamInfo"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%
    String orgId = SessionInfo.getOrgId(request);
    String authrtGrpcd = SessionInfo.getAuthrtGrpcd(request);
    String authrtCd = SessionInfo.getAuthrtCd(request);
    //String menuId = ParamInfo.getParamValue(request, "menuId");

    String menuId = (String) request.getAttribute("adminMenuId");


    Map<String, String> menuOnMap = new HashMap<>();

    MenuVO menuVO = new MenuVO();
    menuVO.setOrgId(orgId);
    menuVO.setAuthrtGrpcd(authrtGrpcd);
    menuVO.setAuthrtCd(authrtCd);
    menuVO.setMenuGbncd("ADM");
    //menuVO.setMenuId(menuId);

    List<MenuVO> topMenuList = AdminMenuInfo.getAdminMenuList(request, menuVO);

    MenuVO topMenu = null;
    List<MenuVO> subMenuList = null;

    if (topMenuList != null && !topMenuList.isEmpty()) {

        if (menuId != null && !"".equals(menuId)) {

            MenuVO currentMenu = AdminMenuInfo.getMenu(menuId);

            if (currentMenu != null && currentMenu.getUpMenuIds() != null) {

                String[] upMenuIds = currentMenu.getUpMenuIds().split(",");
                String topMenuId = upMenuIds[0];

                for (MenuVO top : topMenuList) {

                    if (topMenuId.equals(top.getMenuId())) {

                        topMenu = top;
                        subMenuList = top.getSubMenuList();

                        break;
                    }
                }

                List<String> menuIdList = Arrays.asList(upMenuIds);

                if (subMenuList != null) {

                    for (MenuVO sub1 : subMenuList) {

                        if (menuIdList.contains(sub1.getMenuId()) || menuId.equals(sub1.getMenuId())) {

                            menuOnMap.put(sub1.getMenuId(), "Y");
                        }

                        if (sub1.getSubMenuList() != null) {

                            for (MenuVO sub2 : sub1.getSubMenuList()) {

                                if (menuIdList.contains(sub2.getMenuId()) || menuId.equals(sub2.getMenuId())) {
                                    menuOnMap.put(sub2.getMenuId(), "Y");
                                }
                            }
                        }
                    }
                }
            }

        } else {

            topMenu = topMenuList.get(0);

            if (topMenu != null) {
                subMenuList = topMenu.getSubMenuList();
            }
        }
    }

    request.setAttribute("topMenuList", topMenuList);
    request.setAttribute("subMenuList", subMenuList);
    request.setAttribute("curMenuId", menuId);
    request.setAttribute("menuOnMap", menuOnMap);
    request.setAttribute("topMenu", topMenu);
%>
<div id="key_access">
    <ul>
        <li>
            <a href="#gnb" title="주메뉴 위치로 바로가기">
                주메뉴 바로가기
            </a>
        </li>

        <li>
            <a href="#head_menu" title="서브메뉴 위치로 바로가기">
                서브메뉴 바로가기
            </a>
        </li>

        <li>
            <a href="#content" title="본문 위치로 바로가기">
                본문 바로가기
            </a>
        </li>

        <li>
            <a href="#bottom" title="하단 위치로 바로가기">
                하단 바로가기
            </a>
        </li>
    </ul>
</div>

<div id="loading_page">
    <p>
        <i class="notched circle loading icon"></i>
    </p>
</div>

<header class="common admin">

    <!-- LOGO -->
    <h1 class="logo">

        <a href="/dashboard/adminDashboardV2.do?menuId=ADMORG0000001">

            <img src="<%=request.getContextPath()%>/webdoc/assets/img/logo_w.png"
                 aria-hidden="true"
                 alt="한국방송통신대학교">

        </a>

    </h1>

    <!-- TOP MENU -->
    <ul id="head_menu" class="topmenu">

        <!-- HOME -->
        <li class="depth1">
            <a href="/dashboard/adminDashboardV2.do?menuId=ADMORG0000001"
               title="대시보드">

                <span>
                    <i class="xi-home-o" aria-hidden="true"></i>
                </span>

            </a>
        </li>

        <!-- TOP MENU -->
        <c:forEach items="${topMenuList}" var="menu">

            <li class="depth1 ${topMenu ne null and menu.menuId eq topMenu.menuId ? 'active' : ''}">

                <a href="#0" title="${menu.menunm}" onclick="changeAdminTopmenu(this, '${menu.menuId}'); return false;">
                    <span>${menu.menunm}</span>
                </a>
            </li>
        </c:forEach>

    </ul>

    <!-- UTIL -->
    <ul class="util">

        <!-- 알림 -->
        <li class="alrim"><!-- 버튼 클릭시 on 클래스 추가 -->
            <a href="#0" data-medi-ui="mail" title="알림"><i class="icon-svg-bell-01" aria-hidden="true"></i></a>
            <label class="count" id="headerNotiTotalCnt" style="display:none;">0</label>

            <div class="menu">
                <div class="btn-more"><a href="#0"><i class="icon-svg-plus"></i></a></div>
                <!--tab-type1-->
                <nav class="tab-type1">
                    <a href="#tab1" class="btn current" data-chnl="PUSH"><span><img src="/webdoc/assets/img/common/alrim_icon_push.svg" aria-hidden="true" alt="PUSH"></span><small class="msg_num" id="headerPushCnt">0</small></a>
                    <a href="#tab2" class="btn" data-chnl="SMS"><span><img src="/webdoc/assets/img/common/alrim_icon_sms.svg" aria-hidden="true" alt="SMS"></span><small class="msg_num" id="headerSmsCnt">0</small></a>
                    <a href="#tab3" class="btn" data-chnl="SHRTNT"><span><img src="/webdoc/assets/img/common/alrim_icon_msg.svg" aria-hidden="true" alt="<spring:message code='msg.title.msg.shrtnt'/>"></span><small class="msg_num" id="headerShrtntCnt">0</small></a>
                    <a href="#tab4" class="btn" data-chnl="ALIM_TALK"><span><img src="/webdoc/assets/img/common/alrim_icon_talk.svg" aria-hidden="true" alt="<spring:message code='msg.title.msg.alimTalk'/>"></span><small class="msg_num" id="headerAlimtalkCnt">0</small></a>
                </nav>

                <div class="scrollarea">
                    <div id="tab1" class="tab-content" style="display: block;">
                        <div class="alrim_item_area" id="headerPushList">
                            <div class="item_box push">
                                <p class="item_txt" style="text-align:center; padding:20px 0; color:#999;"><spring:message code='msg.alim.label.loading'/></p>
                            </div>
                        </div>
                    </div>
                    <div id="tab2" class="tab-content" style="display: none;">
                        <div class="alrim_item_area" id="headerSmsList">
                            <div class="item_box sms">
                                <p class="item_txt" style="text-align:center; padding:20px 0; color:#999;"><spring:message code='msg.alim.label.loading'/></p>
                            </div>
                        </div>
                    </div>
                    <div id="tab3" class="tab-content" style="display: none;">
                        <div class="alrim_item_area" id="headerMsgList">
                            <div class="item_box msg">
                                <p class="item_txt" style="text-align:center; padding:20px 0; color:#999;"><spring:message code='msg.alim.label.loading'/></p>
                            </div>
                        </div>
                    </div>
                    <div id="tab4" class="tab-content" style="display: none;">
                        <div class="alrim_item_area" id="headerTalkList">
                            <div class="item_box talk">
                                <p class="item_txt" style="text-align:center; padding:20px 0; color:#999;"><spring:message code='msg.alim.label.loading'/></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                // 알림 메시지
                var MSG_ALIM_UNREAD = '<spring:message code="msg.alim.label.unread"/>';
                var MSG_ALIM_READ = '<spring:message code="msg.alim.label.read"/>';
                var MSG_ALIM_EMPTY = '<spring:message code="common.content.not_found"/>';

                // 헤더 알림 관련 전역 변수
                var headerNotiPollingId = null;
                var headerLoadedChnl = {};
                var HEADER_NOTI_POLLING_INTERVAL = 120000; // 2분

                var HEADER_CHNL_MAP = {
                    'PUSH':      { targetId: '#headerPushList', itemClass: 'push', listKey: 'list' },
                    'SMS':       { targetId: '#headerSmsList',  itemClass: 'sms',  listKey: 'list' },
                    'SHRTNT':    { targetId: '#headerMsgList',  itemClass: 'msg',  listKey: 'list' },
                    'ALIM_TALK': { targetId: '#headerTalkList', itemClass: 'talk', listKey: 'list' }
                };

                $(document).ready(function() {
                    // 페이지 로드 시 읽지 않은 알림 개수만 조회
                    headerNotiUnreadCntSelect();

                    // 알림 드롭다운 클릭 시 PUSH만 조회
                    $('li.alrim > a[data-medi-ui="mail"]').on('click', function() {
                        if (!headerLoadedChnl['PUSH']) {
                            headerNotiLoadChnl('PUSH');
                        }
                    });

                    // 탭 클릭 시 해당 채널만 조회
                    $('li.alrim .tab-type1 a.btn').on('click', function() {
                        var chnlCd = $(this).data('chnl');
                        if (!headerLoadedChnl[chnlCd]) {
                            headerNotiLoadChnl(chnlCd);
                        }
                    });

                    // Polling 시작
                    headerNotiPollingStart();

                    // 브라우저 탭 활성화/비활성화 감지
                    document.addEventListener('visibilitychange', function() {
                        if (document.hidden) {
                            headerNotiPollingStop();
                        } else {
                            headerNotiUnreadCntSelect();
                            headerLoadedChnl = {};
                            headerNotiPollingStart();
                        }
                    });
                });

                function headerNotiPollingStart() {
                    if (headerNotiPollingId) return; // 이미 실행 중이면 무시
                    headerNotiPollingId = setInterval(function() {
                        headerNotiUnreadCntSelect();
                    }, HEADER_NOTI_POLLING_INTERVAL);
                }

                function headerNotiPollingStop() {
                    if (headerNotiPollingId) {
                        clearInterval(headerNotiPollingId);
                        headerNotiPollingId = null;
                    }
                }

                function headerNotiUnreadCntSelect() {
                    ajaxCall('/admAlimUnrdCntSelectAjax.do', {}, function(data) {
                        if (data.result > 0 && data.returnVO) {
                            headerNotiCntUpdate(data.returnVO);
                        }
                    }, function(xhr, status, error) {
                        console.error('알림 개수 조회 실패');
                    }, false, {type: 'GET'});
                }

                function headerNotiCntUpdate(data) {
                    var totalCnt = (data.totalUnrdCnt || 0);
                    var $totalLabel = $('#headerNotiTotalCnt');

                    if (totalCnt > 0) {
                        $totalLabel.text(totalCnt > 99 ? '99+' : totalCnt).show();
                    } else {
                        $totalLabel.hide();
                    }

                    $('#headerPushCnt').text(data.pushCnt || 0);
                    $('#headerSmsCnt').text(data.smsCnt || 0);
                    $('#headerShrtntCnt').text(data.shrtntCnt || 0);
                    $('#headerAlimtalkCnt').text(data.alimtalkCnt || 0);

                    // 위젯 배지도 업데이트
                    $('#widgetPushCnt').text(data.pushCnt || 0);
                    $('#widgetSmsCnt').text(data.smsCnt || 0);
                    $('#widgetShrtntCnt').text(data.shrtntCnt || 0);
                    $('#widgetAlimtalkCnt').text(data.alimtalkCnt || 0);
                }

                function headerNotiLoadChnl(chnlCd) {
                    var info = HEADER_CHNL_MAP[chnlCd];
                    if (!info) return;

                    ajaxCall('/admAlimChnlListAjax.do', { chnlCd: chnlCd, listCnt: 5 }, function(data) {
                        if (data.result > 0 && data.returnVO) {
                            var list = data.returnVO[info.listKey];
                            alimNotiRenderList(chnlCd, list, info.targetId, info.itemClass);
                            headerLoadedChnl[chnlCd] = true;
                        }
                    }, function() {
                        console.error('알림 목록 조회 실패: ' + chnlCd);
                    }, false, {type: 'GET'});
                }

                /* 알림 목록 렌더링 (헤더/위젯 공통) */
                function alimNotiRenderList(chnlCd, list, targetSelector, itemClass) {
                    var $target = $(targetSelector);
                    var html = '';

                    if (list && list.length > 0) {
                        $.each(list, function(idx, item) {
                            var name = item.sbjctnm || item.sndngnm || '';
                            var date = UiComm.formatDate(item.sndngDttm, "datetime2");
                            var title = item.sndngTtl || '';
                            var readLabel = (item.readYn === 'N')
                                ? '<label class="label check_no">' + MSG_ALIM_UNREAD + '</label>'
                                : '<label class="label check_ok">' + MSG_ALIM_READ + '</label>';

                            html += '<div class="item_box ' + itemClass + '">';
                            html += '    <a href="#0" class="item_txt" data-sndng-id="' + (item.sndngId || '') + '" data-sndng-tycd="' + chnlCd + '">';
                            html += '        <p class="desc">';
                            html += '            <span class="name">' + UiComm.escapeHtml(name) + '</span>';
                            html += '            <span class="date">' + date + '</span>';
                            html += '        </p>';
                            html += '        <p class="tit">' + UiComm.escapeHtml(title) + '</p>';
                            html += '    </a>';
                            html += '    <div class="state">' + readLabel + '</div>';
                            html += '</div>';
                        });
                    } else {
                        html = '<div class="item_box ' + itemClass + '">';
                        html += '    <p class="item_txt" style="text-align:center; padding:20px 0; color:#999;">' + MSG_ALIM_EMPTY + '</p>';
                        html += '</div>';
                    }

                    $target.html(html);
                }

                const HEADER_SHRTNT_RCVN_URL = '/admMsgShrtntRcvnSelectView.do';
                const HEADER_PUSH_RCVN_URL = '/';
                const HEADER_ALIM_TALK_RCVN_URL = '/';

                $(document).on('click', 'li.alrim .item_txt[data-sndng-tycd]', function(e) {
                    e.preventDefault();
                    let $item = $(this);
                    let sndngTycd = $item.data('sndng-tycd');
                    let sndngId = $item.data('sndng-id');

                    if (!sndngId) return;

                    // 읽음처리 우선 → 채널 수신 상세 이동
                    let navUrl = null;
                    let idParam = 'msgMblSndngId';
                    if (sndngTycd === 'SHRTNT') {
                        navUrl = HEADER_SHRTNT_RCVN_URL;
                        idParam = 'msgShrtntSndngId';
                    } else if (sndngTycd === 'PUSH') {
                        navUrl = HEADER_PUSH_RCVN_URL;
                    } else if (sndngTycd === 'ALIM_TALK') {
                        navUrl = HEADER_ALIM_TALK_RCVN_URL;
                    }

                    if (navUrl) {
                        let goDetail = function() {
                            location.href = navUrl + '?' + idParam + '=' + encodeURIComponent(sndngId);
                        };
                        ajaxCall('/admAlimReadModifyAjax.do', { sndngId: sndngId, chnlCd: sndngTycd }, goDetail, goDetail, false);
                        return;
                    }

                    // SMS/LMS: 이동 없이 읽음처리만
                    if (sndngTycd === 'SMS') {
                        ajaxCall('/admAlimReadModifyAjax.do', { sndngId: sndngId, chnlCd: sndngTycd }, function(data) {
                            if (data.result > 0) {
                                let $state = $item.closest('.item_box').find('.state .label');
                                $state.removeClass('check_no').addClass('check_ok').text(MSG_ALIM_READ);
                                if (data.returnVO) {
                                    headerNotiCntUpdate(data.returnVO);
                                }
                            }
                        }, function() {
                            console.error('알림 읽음 처리 실패');
                        }, false);
                    }
                });
            </script>
        </li>

        <!-- 로그아웃 -->
        <li class="log">

            <a href="/user/userHome/logout.do">

                <i class="icon-svg-logout" aria-hidden="true"></i>

            </a>

        </li>

        <!-- 사용자 -->
        <li class="user">

            <a href="#0">

                <span class="user_img">

                    <img src="<%=request.getContextPath()%>/webdoc/assets/img/common/photo_user_sample4.jpg"
                         aria-hidden="true"
                         alt="사진">

                </span>

            </a>

        </li>

    </ul>

</header>

<script type="text/javascript">

    /**
     * LEFT MENU HTML CACHE
     */
    const ADMIN_MENU_HTML_MAP = {};

    <c:forEach items="${topMenuList}" var="top">

        ADMIN_MENU_HTML_MAP["${top.menuId}"] = '';

        <c:forEach items="${top.subMenuList}" var="menu">

            <c:if test="${empty menu.subMenuList}">

                ADMIN_MENU_HTML_MAP["${top.menuId}"] +=
                    '<li>' +
                        '<a href="#0" ' +
                           'onclick="adminMoveMenu(' +
                               'this,' +
                               '\'${menu.menuUrl}\',' +
                               '\'${menu.myTopMenuId}\',' +
                               '\'${menu.menuId}\',' +
                               '\'${menu.menunm}\',' +
                               '\'${menu.linkTargetTycd}\'' +
                           '); return false;" ' +
                           'title="${menu.menunm}">' +
                            '<span class="menu-text">${menu.menunm}</span>' +
                        '</a>' +
                    '</li>';

            </c:if>

            <c:if test="${not empty menu.subMenuList}">

                ADMIN_MENU_HTML_MAP["${top.menuId}"] +=
                    '<li class="has-sub">' +
                        '<a href="#0" title="${menu.menunm}">' +
                            '<span class="menu-text">${menu.menunm}</span>' +
                        '</a>' +
                        '<ul class="sub">';

                <c:forEach items="${menu.subMenuList}" var="menu2">

                    <c:if test="${empty menu2.subMenuList}">

                        ADMIN_MENU_HTML_MAP["${top.menuId}"] +=
                            '<li>' +
                                '<a href="#0" ' +
                                   'onclick="adminMoveMenu(' +
                                       'this,' +
                                       '\'${menu2.menuUrl}\',' +
                                       '\'${menu2.myTopMenuId}\',' +
                                       '\'${menu2.menuId}\',' +
                                       '\'${menu2.menunm}\',' +
                                       '\'${menu2.linkTargetTycd}\'' +
                                   '); return false;" ' +
                                   'title="${menu2.menunm}">' +
                                    '${menu2.menunm}' +
                                '</a>' +
                            '</li>';

                    </c:if>

                    <c:if test="${not empty menu2.subMenuList}">

                        ADMIN_MENU_HTML_MAP["${top.menuId}"] +=
                            '<li class="has-sub">' +
                                '<a href="#0" title="${menu2.menunm}">' +
                                    '${menu2.menunm}' +
                                '</a>' +
                                '<ul class="sub_depth">';

                        <c:forEach items="${menu2.subMenuList}" var="menu3">

                            ADMIN_MENU_HTML_MAP["${top.menuId}"] +=
                                '<li>' +
                                    '<a href="#0" ' +
                                       'onclick="adminMoveMenu(' +
                                           'this,' +
                                           '\'${menu3.menuUrl}\',' +
                                           '\'${menu3.myTopMenuId}\',' +
                                           '\'${menu3.menuId}\',' +
                                           '\'${menu3.menunm}\',' +
                                           '\'${menu3.linkTargetTycd}\'' +
                                       '); return false;" ' +
                                       'title="${menu3.menunm}">' +
                                        '${menu3.menunm}' +
                                    '</a>' +
                                '</li>';

                        </c:forEach>

                        ADMIN_MENU_HTML_MAP["${top.menuId}"] +=
                                '</ul>' +
                            '</li>';

                    </c:if>

                </c:forEach>

                ADMIN_MENU_HTML_MAP["${top.menuId}"] +=
                        '</ul>' +
                    '</li>';

            </c:if>

        </c:forEach>

    </c:forEach>

    /**
     * TOP MENU 클릭
     */
    function changeAdminTopmenu(obj, menuId) {
        $(".topmenu li").removeClass("active");
        $(obj).parent().addClass("active");
        let menuName = $(obj).find("span").text();
        $("#navSubTitle").text(menuName);
        $("#navList").html(ADMIN_MENU_HTML_MAP[menuId]);
        procAdminMenuEvent();
    }

    /**
     * 첫번째 메뉴 자동 이동
     */
    function moveFirstMenu() {
        let $firstMenu = $("#navList")
            .find("a[onclick*='adminMoveMenu']")
            .first();
        if ($firstMenu.length > 0) {
            $firstMenu.trigger("click");
        }
    }
</script>