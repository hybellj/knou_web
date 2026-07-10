<%@ page import="knou.framework.common.SessionInfo" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<div id="key_access">
    <ul>
    	<li><a href="#header" title="헤더 위치로 바로가기">헤더 위치로 바로가기</a></li>
        <li><a href="#gnb" title="주메뉴 위치로 바로가기">주메뉴 바로가기</a></li>
        <li><a href="#content" title="본문 위치로 바로가기">본문 바로가기</a></li>
        <li><a href="#bottom" title="하단 위치로 바로가기">하단 바로가기</a></li>
    </ul>
</div>

<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>

<header id="header" class="common">
	<button type="button" class="btn mobile-elem ctrl-gnb" aria-label="모바일 메뉴 버튼"><i class="icon-svg-menu fs-18px" aria-hidden="true"></i></button>

	<h1 class="logo">
		<a href="/">
			<img src="<%=request.getContextPath()%>/webdoc/assets/img/logo.svg" aria-hidden="true" alt="한국방송통신대학교">
		</a>
	</h1>

	<ul class="util">

		<li class="zoom-control">
			<div class="icon_btns">
				<div class="zoom_btn" aria-label="zoomin" title="<spring:message code='button.zoomin'/>"><i class="xi-zoom-in"></i></div><%-- 확대 --%>
				<div class="zoom_btn" aria-label="zoomout" title="<spring:message code='button.zoomout'/>"><i class="xi-zoom-out"></i></div><%-- 축소 --%>
				<div class="zoom_btn" aria-label="zoomreset" title="<spring:message code='button.default'/>"><i class="xi-refresh"></i></div><%-- 기본 --%>
			</div>
			<script>
				window.currentZoom = 100;
				function zoomIn() {
					if (window.currentZoom < 110) window.currentZoom += 5;
					console.log("Zoom In:", window.currentZoom);
					updateZoomClass();
				}

				function zoomOut() {
					if (window.currentZoom > 90) window.currentZoom -= 5;
					console.log("Zoom Out:", window.currentZoom);
					updateZoomClass();
				}

				function zoomReset() {
					window.currentZoom = 100;
					console.log("Zoom Reset:", window.currentZoom);
					updateZoomClass();
				}

				function updateZoomClass() {
					console.log("updateZoomClass called");

					document.body.classList.remove(
						"zoom-90","zoom-95","zoom-100","zoom-105","zoom-110"
					);

					const zoomClass = "zoom-" + window.currentZoom;
					console.log("Adding class:", zoomClass);
					document.body.classList.add(zoomClass);
				}

				document.querySelector('[aria-label="zoomin"]').addEventListener('click', zoomIn);
				document.querySelector('[aria-label="zoomout"]').addEventListener('click', zoomOut);
				document.querySelector('[aria-label="zoomreset"]').addEventListener('click', zoomReset);
			</script>

		</li>


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

                    // 위젯 배지도 업데이트
                    $('#widgetPushCnt').text(data.pushCnt || 0);
                    $('#widgetSmsCnt').text(data.smsCnt || 0);
                    $('#widgetShrtntCnt').text(data.shrtntCnt || 0);
                    $('#widgetAlimtalkCnt').text(data.alimtalkCnt || 0);
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

                const HEADER_SHRTNT_RCVN_URL = '<c:choose><c:when test="${fn:contains(authrtGrpcd, \'STDNT\')}">/stdntMsgShrtntRcvnSelectView.do</c:when><c:otherwise>/profMsgShrtntRcvnSelectView.do</c:otherwise></c:choose>';
                const HEADER_PUSH_RCVN_URL = '/profMsgPushRcvnSelectView.do';
                const HEADER_ALIM_TALK_RCVN_URL = '/profMsgAlimTalkRcvnSelectView.do';

                // 학생은 교수(PROMAIN) 메뉴 매핑이 다르므로 LNB active 처리 제외
                const HEADER_IS_STDNT = <c:choose><c:when test="${fn:contains(authrtGrpcd, 'STDNT')}">true</c:when><c:otherwise>false</c:otherwise></c:choose>;
                const HEADER_MENU_MAP = {
                    'SHRTNT':    { menuId: 'PROMAIN000005', upMenuId: 'PROMAIN000003', menunm: '<spring:message code="msg.title.msg.shrtnt"/>' },
                    'PUSH':      { menuId: 'PROMAIN000004', upMenuId: 'PROMAIN000003', menunm: 'PUSH' },
                    'ALIM_TALK': { menuId: 'PROMAIN000007', upMenuId: 'PROMAIN000003', menunm: '<spring:message code="msg.title.msg.alimTalk"/>' }
                };

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
                        let detailUrl = navUrl + '?' + idParam + '=' + encodeURIComponent(sndngId);
                        let menuInfo = HEADER_IS_STDNT ? null : HEADER_MENU_MAP[sndngTycd];
                        let goDetail = menuInfo
                            // 탭/LNB active를 위해 mainTabpage.do를 경유 (moveMenu tab 분기)
                            ? function() {
                                moveMenu(null, detailUrl, menuInfo.upMenuId, menuInfo.menuId, menuInfo.menunm, 'tab');
                                // 탭 페이지 내 재클릭 시 addTabMenu는 LNB active를 갱신하지 않으므로 직접 갱신
                                if (typeof TAB_MENU !== 'undefined' && TAB_MENU && TAB_MENU.resetMenuStatus) {
                                    TAB_MENU.resetMenuStatus(menuInfo.menuId);
                                }
                              }
                            : function() { location.href = detailUrl; };
                        ajaxCall('/alimReadModifyAjax.do', { sndngId: sndngId, chnlCd: sndngTycd }, goDetail, goDetail, false);
                        return;
                    }

                    // SMS/LMS: 이동 없이 읽음처리만
                    if (sndngTycd === 'SMS') {
                        ajaxCall('/alimReadModifyAjax.do', { sndngId: sndngId, chnlCd: sndngTycd }, function(data) {
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

        <%-- 언어 설정 --%>
        <li class="lang_change">
            <a href="#0" aria-label="Language" data-medi-ui="langs" title="Language"><i class="icon-svg-globe-01"></i></a>
            <div class="option-wrap">
                <div class="item ${uiex:getLangCd() eq 'ko' ? 'selected' : ''}"><a href="/common/changeLang.do?language=ko" title="한국어">한국어</a></div>
                <div class="item ${uiex:getLangCd() eq 'en' ? 'selected' : ''}"><a href="/common/changeLang.do?language=en" title="English">English</a></div>
            </div>
        </li>

        <%-- 컬러 테마 설정 --%>
        <li class="mode">
			<a href="#0" data-medi-ui="mode" title="<spring:message code='main.theme.color'/>"><i class="icon-svg-palette" aria-hidden="true"></i></a><%-- 컬러 테마 --%>
			<div class="menu">
				<div class="widget_set_group">
					<div class="info-tit2" style="text-align:center;">
						<span><spring:message code='main.theme.color'/></span><%-- 컬러 테마 --%>
					</div>
					<div class="widget-list">
						<span class="custom-input">
							<input type="radio" name="wcolor" id="wcolor" data-theme="default" value="default">
							<label for="wcolor"><spring:message code='main.theme.default'/></label><%-- 기본 --%>
							<span class="theme-color"></span>
						</span>
						<span class="custom-input">
							<input type="radio" name="wcolor" id="wcolorA" data-theme="colorA" value="colorA">
							<label for="wcolorA"><spring:message code='main.theme.blue'/></label><%-- 블루 --%>
							<span class="theme-color wcolorA"></span>
						</span>
						<span class="custom-input">
							<input type="radio" name="wcolor" id="wcolorB" data-theme="colorB" value="colorB">
							<label for="wcolorB"><spring:message code='main.theme.mint'/></label><%-- 민트 --%>
							<span class="theme-color wcolorB"></span>
						</span>
						<span class="custom-input">
							<input type="radio" name="wcolor" id="wcolorC" data-theme="colorC" value="colorC">
							<label for="wcolorC"><spring:message code='main.theme.orange'/></label><%-- 오렌지 --%>
							<span class="theme-color wcolorC"></span>
						</span>
						<span class="custom-input">
							<input type="radio" name="wcolor" id="wcolorD" data-theme="colorD" value="colorD">
							<label for="wcolorD"><spring:message code='main.theme.red'/></label><%-- 레드 --%>
							<span class="theme-color wcolorD"></span>
						</span>
						<span class="custom-input">
							<input type="radio" name="wcolor" id="wcolorE" data-theme="colorE" value="colorE">
							<label for="wcolorE"><spring:message code='main.theme.purple'/></label><%-- 퍼플 --%>
							<span class="theme-color wcolorE"></span>
						</span>
						<span class="custom-input">
							<input type="radio" name="wcolor" id="wcolorDark" data-theme="darkmode" value="darkmode">
							<label for="wcolorDark"><spring:message code='main.theme.dark'/></label><%-- 다크모드 --%>
							<span class="theme-color wcolorDark"></span>
						</span>
					</div>
				</div>
				<div class="btns mt10">
					<button type="button" class="btn type5" onclick="saveTheme()"><spring:message code='button.save'/><%-- 저장 --%></button>
					<button type="button" class="btn gray2" onclick="cancelTheme()"><spring:message code='button.cancel'/><%-- 취소 --%></button>
				</div>
			</div>
			<script>
				let prevTheme = "";
				let isSaving = false;

				$(document).ready(function() {
					prevTheme = "${uiex:getTheme()}";
					$(`.util .mode .menu input[name="wcolor"][value="\${prevTheme}"]`).prop('checked', true);

					const targetNode = document.querySelector('.util .mode');
					if (targetNode) {
						const observer = new MutationObserver(function(mutationsList) {
							for (const mutation of mutationsList) {
								if (mutation.type === 'attributes' && mutation.attributeName === 'class') {
									const hasOn = targetNode.classList.contains('on');
									if (!hasOn) {
										if (isSaving) {
											isSaving = false;
										} else {
											cancelTheme();
										}
									}
								}
							}
						});
						observer.observe(targetNode, { attributes: true });
					}
				});

				// 테마 저장
				function saveTheme() {
					let theme = $('.util .mode .menu input[name="wcolor"]:checked').val();
				    let url = "/user/userHome/setUserConf.do";
				    let data = {
				    	confType: "theme",
				    	confVal: theme
				    };

					isSaving = true;

				    ajaxCall(url, data, function(res) {
			            if (res.result > 0) {
							console.log("테마 변경 성공 : "+theme);
							prevTheme = theme;
			            }
			            else {
			            	UiComm.showMessage("<spring:message code='fail.common.msg' />","error");
				        }
				    }, function(xhr, status, error) {
				    	UiComm.showMessage("<spring:message code='fail.common.msg' />","error");
				    }, true);

					$(".util .mode").removeClass("on");
				}

				// 테마 적용 취소
				function cancelTheme() {
					let theme = $('.util .mode .menu input[name="wcolor"]:checked').val();
				    let themeClasses = ["default", "colorA", "colorB", "colorC", "colorD", "colorE", "darkmode"];

				    if (prevTheme != theme) {
						$("body").removeClass(themeClasses.join(' '));
				    	$("body").addClass(prevTheme);

				        $("iframe").each(function () {
				            try {
				                const iframeBody = $(this.contentDocument || this.contentWindow.document).find("body");
				                if (iframeBody.length) iframeBody.removeClass(themeClasses.join(' '));
				            } catch (err) { }
				        });
				    }

				    $(`.util .mode .menu input[name="wcolor"][value="\${prevTheme}"]`).prop('checked', true);
					$(".util .mode").removeClass("on");
				}
			</script>
		</li>
        <li class="log">
        	<a href="/user/userHome/logout.do" title="<spring:message code='button.logout'/>"><i class="icon-svg-logout" aria-hidden="true"></i></a><%-- 로그아웃 --%>
        </li>

    </ul>

</header>