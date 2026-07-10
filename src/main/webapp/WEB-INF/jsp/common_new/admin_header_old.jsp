<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="knou.lms.user.vo.UsrUserInfoVO"%>
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
    String menuId = ParamInfo.getParamValue(request, "menuId");
    Map<String, String> menuOnMap = new HashMap<>();

	// 메인메뉴 가져 오기
    MenuVO menuVO = new MenuVO();
    menuVO.setOrgId(orgId);
    menuVO.setAuthrtGrpcd(authrtGrpcd);
    menuVO.setMenuGbncd("ADM");
    List<MenuVO> menuList = AdminMenuInfo.getAdminMenuList(request, menuVO);
    List<MenuVO> subMenuList = null;
    MenuVO topMenu = null;

    if (menuList != null && menuList.size() > 0) {
        
    	// 서브메뉴 가져오기
        if (menuId != null && !"".equals(menuId)) {
            MenuVO svo = AdminMenuInfo.getMenuVO(menuId);

            if (svo != null && svo.getUpMenuIds() != null) {
                String[] ids = svo.getUpMenuIds().split(",");
                String subMenuId = ids[0];

                for(MenuVO mvo : menuList) {
                    if (mvo.getMenuId().equals(subMenuId)) {
                        subMenuList = mvo.getSubMenuList();
                        topMenu = mvo;
                        break;
                    }
                }

                // 2단계 서브메뉴
                if (subMenuList != null && subMenuList.size() > 0) {
                    List<String> idsList = Arrays.asList(ids);
                    for(MenuVO mvo : subMenuList) {
                        if (idsList.contains(mvo.getMenuId()) || menuId.equals(mvo.getMenuId())) {
                            menuOnMap.put(mvo.getMenuId(), "Y");
                        }

                        // 3단계 서브메뉴
                        if (mvo.getSubMenuList() != null && mvo.getSubMenuList().size() > 0) {
                            for(MenuVO mvo2 : mvo.getSubMenuList()) {
                                if (idsList.contains(mvo2.getMenuId())) {
                                    menuOnMap.put(mvo2.getMenuId(), "Y");
                                }
                            }
                        }
                    }
                }
            }
        }
        else {
            topMenu = menuList.get(0);
            subMenuList = topMenu.getSubMenuList();
        }
    }

    request.setAttribute("menuList", 	menuList);
    request.setAttribute("subMenuList", subMenuList);
    request.setAttribute("curMenuId", 	menuId);
    request.setAttribute("menuOnMap", 	menuOnMap);
    request.setAttribute("topMenu", 	topMenu);
%>
<div style="font-size:12px; padding:5px; background:#f5f5f5; border:1px solid #ddd; margin:5px;">
	<div>current menuId = <%= menuId %></div>
	<div>topMenu = <%= topMenu != null ? topMenu.getMenunm() : "NULL" %></div>				
    <h3>TOP MENU</h3>				
    <%
    if(menuList != null) {
        for(MenuVO top : menuList) {
    %>
            <div style="margin-bottom:15px; padding:10px; border:1px solid #ccc; background:#fff;">
                <div><strong>[TOP]<%= top.getMenunm() %></strong>/menuId = <%= top.getMenuId() %></div>				
                <%
                List<MenuVO> sub1List = top.getSubMenuList();				
                if(sub1List != null && !sub1List.isEmpty()) {
                %>
                    <ul style="margin-top:10px;">
                    <%
                    for(MenuVO sub1 : sub1List) {
                    %>
                        <li style="margin-bottom:10px;">
                            <div>
                                └ [SUB1]
                                <%= sub1.getMenunm() %>/menuId = <%= sub1.getMenuId() %>
                            </div>

                            <%
                            List<MenuVO> sub2List = sub1.getSubMenuList();

                            if(sub2List != null && !sub2List.isEmpty()) {
                            %>
                                <ul>
                                <%
                                for(MenuVO sub2 : sub2List) {
                                %>
                                    <li>
                                        └-----[SUB2]<%= sub2.getMenunm() %> / menuId = <%= sub2.getMenuId() %> / url = <%= sub2.getMenuUrl() %>
                                    </li>
                                <%
                                }
                                %>
                                </ul>
                            <%
                            }
                            %>
                        </li>
                    <%
                    }
                    %>
                    </ul>
                <%
                }
                %>
            </div>
    <%
        }
    }
    %>
</div>

<div id="key_access">
    <ul>
        <li><a href="#gnb" title="주메뉴 위치로 바로가기">주메뉴 바로가기</a></li>
        <li><a href="#head_menu" title="서브메뉴 위치로 바로가기">서브메뉴 바로가기</a></li>
        <li><a href="#content" title="본문 위치로 바로가기">본문 바로가기</a></li>
        <li><a href="#bottom" title="하단 위치로 바로가기">하단 바로가기</a></li>
    </ul>
</div>

<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>

<header class="common admin">

    <h1 class="logo">
        <a href="#0">
            <img src="<%=request.getContextPath()%>/webdoc/assets/img/logo_w.png" aria-hidden="true" alt="한국방송통신대학교">
        </a>
    </h1>

    <ul id="head_menu" class="topmenu">
        <li class="depth1">
            <a href="/dashboard/adminDashboardV2.do?menuId=ADMORG0000001" title="대시보드"><span><i class="xi-home-o" aria-hidden="true"></i></span></a>
        </li>
        <c:forEach items="${menuList}" var="menu" varStatus="status">
            <li class="depth1 ${topMenu ne null and menu.menuId eq topMenu.menuId ? 'active' : ''}">
                    <%-- 상위 메뉴 --%>
                <a href="#0" title="${menu.menunm}" onclick="changeAdminTopmenu(this,'${menu.menuId}');return false;"><span>${menu.menunm}</span></a>
            </li>
        </c:forEach>
    </ul>
    
    
    <script>
        // 관리자 Top 메뉴 클릭 시 레프트메뉴[서브메뉴]가 변경됩니다.
        function changeAdminTopmenu(obj, menuId) {
       	    $(".topmenu li").removeClass("active");
       	    $(obj).parent().addClass("active");
       	    let topMenu = ADMIN_MENU_LIST.find(m => m.menuId === menuId);
       	    if (topMenu)
       	        changeAdminSubmenu(topMenu.subMenuList);
       	    }
        }

        // 관리자 서브메뉴 변경
        function changeAdminSubmenu(menuList) {
            if (menuList != null && menuList.length > 0) {
                let menuHtml = "";

                menuList.forEach(function(menu, i) {
                    if (menu.subMenuList != null) {
                        menuHtml += `<li class="has-sub"><a href="#0" title="\${menu.menunm}"><span class="menu-text">\${menu.menunm}</span></a>`;

                        // 2단계 서브메뉴
                        let subList2 = menu.subMenuList;
                        if (subList2 != null && subList2.length > 0) {
                            menuHtml += `<ul class="sub">`;

                            subList2.forEach(function(menu2, j) {
                                // 3단계 서브메뉴
                                let subList3 = menu2.subMenuList;
                                if (subList3 != null && subList3.length > 0) {
                                    menuHtml += `<li class="has-sub"><a href="#0" title="\${menu2.menunm}">\${menu2.menunm}</a>`;
                                    menuHtml += `<ul class="sub_depth">`;

                                    subList3.forEach(function(menu3, j) {
                                        menuHtml += `<li><a href="#0" onclick="adminMoveMenu(this, '\${menu3.menuUrl}', '\${menu3.upMenuId}', '\${menu3.menuId}', '\${menu3.menunm}', '\${menu3.linkTargetTycd}');return false;" title="\${menu3.menunm}">\${menu3.menunm}</a></li>`;
                                    });

                                    menuHtml += `</ul>`;
                                    menuHtml += `</li>`;
                                }
                                else {
                                	menuHtml += `<li><a href="#0" onclick="adminMoveMenu(this, '\${menu2.menuUrl}', '\${menu2.upMenuId}', '\${menu2.menuId}', '\${menu2.menunm}', '\${menu2.linkTargetTycd}');return false;" title="\${menu2.menunm}">\${menu2.menunm}</a></li>`;
                                	//console.log(menuHtml)
                                }
                            });

                            menuHtml += `</ul>`;
                        }

                        menuHtml += `</li>`;
                    }
                    else {
                        menuHtml += `<li><a href="#0" onclick="adminMoveMenu(this, '\${menu.menuUrl}', '\${menu.upMenuId}', '\${menu.menuId}', '\${menu.menunm}', '\${menu.linkTargetTycd}');return false;" title="\${menu.menunm}"><span class="menu-text">\${menu.menunm}</span></a></li>`;
                    }

                });

                $("#navList").html(menuHtml);
                $(window).scrollTop(0);
                procAdminMenuEvent();
            }
        }
    </script>


    <ul class="util">
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
                    ajaxCall('/alimUnrdCntSelectAjax.do', {}, function(data) {
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
                }

                function headerNotiLoadChnl(chnlCd) {
                    var info = HEADER_CHNL_MAP[chnlCd];
                    if (!info) return;

                    ajaxCall('/alimChnlListAjax.do', { chnlCd: chnlCd, listCnt: 5 }, function(data) {
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

                const HEADER_SHRTNT_RCVN_URL = '/mngrMsgShrtntRcvnSelectView.do';
                const HEADER_SHRTNT_MENU = { menuId: 'ADMMSG0000004' , upMenuId: 'ADMMSG0000002' };

                $(document).on('click', 'li.alrim .item_txt[data-sndng-tycd]', function(e) {
                    e.preventDefault();
                    let sndngTycd = $(this).data('sndng-tycd');
                    let sndngId = $(this).data('sndng-id');

                    if (!sndngId) return;

                    if (sndngTycd === 'SHRTNT') {
                        headerShrtntMoveToDetail(sndngId);
                    }
                });

                function headerShrtntMoveToDetail(sndngId) {
                    let $form = $('#headerShrtntMoveForm');
                    if ($form.length === 0) {
                        $form = $('<form id="headerShrtntMoveForm" method="post">'
                            + '<input type="hidden" name="addParams" value="">'
                            + '<input type="hidden" name="msgShrtntSndngId" value="">'
                            + '</form>');
                        $('body').append($form);
                    }

                    $form.attr('action', HEADER_SHRTNT_RCVN_URL);
                    $form.find('input[name=addParams]').val(UiComm.makeEncParams({
                        menuId: HEADER_SHRTNT_MENU.menuId,
                        upMenuId: HEADER_SHRTNT_MENU.upMenuId,
                        menuTarget: 'self'
                    }));
                    $form.find('input[name=msgShrtntSndngId]').val(sndngId);
                    $form.submit();
                }
            </script>
        </li>
        <li class="log">
            <a href="/user/userHome/logout.do"><i class="icon-svg-logout" aria-hidden="true"></i></a>
        </li>
        <li class="user">
            <a href="#0"><span class="user_img"><img src="<%=request.getContextPath()%>/webdoc/assets/img/common/photo_user_sample4.jpg" aria-hidden="true" alt="사진"></span></a>
        </li>
    </ul>

</header>
