<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<c:if test="${pageType ne 'iframe' or param.view eq 'on'}">

<div id="key_access">
    <ul>
        <li><a href="#gnb" title="주메뉴 위치로 바로가기">주메뉴 바로가기</a></li>
        <li><a href="#content" title="본문 위치로 바로가기">본문 바로가기</a></li>
        <li><a href="#bottom" title="하단 위치로 바로가기">하단 바로가기</a></li>
    </ul>
</div>

<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>


<header class="common">
	<button type="button" class="btn mobile-elem ctrl-gnb" aria-label="모바일 메뉴 버튼"><i class="icon-svg-menu fs-18px" aria-hidden="true"></i></button>

	<h1 class="logo">
		<a href="#0">
			<img src="<%=request.getContextPath()%>/webdoc/assets/img/logo.png" aria-hidden="true" alt="한국방송통신대학교">
		</a>
	</h1>
	<div class="option-univ"><!-- 버튼 클릭시 on 클래스 추가 -->
		<select class="form-select" style="font-size:15px; border-radius:100em;">
            <option value="">전체</option>
            <option value="대학원">대학원</option>
            <option value="학위과정">학위과정</option>
        </select>
        <select class="form-select wide" style="font-size:15px; margin-left: 5px; border-radius:100em;">
            <option value="">전체</option>
            <option value="관리자">관리자</option>
            <option value="교수">교수</option>
            <option value="학생">학생</option>
        </select>
	</div>

	<ul class="util">
		<li class="widget_setting"><!-- 버튼 클릭시 on 클래스 추가 -->
			<a href="#0" data-medi-ui="widget"><i class="icon-svg-widget" aria-hidden="true"></i>위젯설정</a>

			<div class="menu">
				<div class="widgetStngGrp"></div>
				<div class="widgetStngGrpColr"></div>

				<div class="info-txt2">
					<i class="icon-svg-move"></i>
					<span>드래그하여 위젯을 원하는 위치로 이동하세요.</span>
				</div>
				<div class="btns">
					<button type="button" class="btn type5" onclick="widgetStngChange()">저장</button>
					<button type="button" class="btn gray2" onclick="closeModal()">취소</button>
				</div>
			</div>

		</li>
		<li class="info_time"><span>이전로그인 2022.07.18 15:17 (211.157.234.211)</span></li>
		<li class="zoom-control">
			<div class="icon_btns">
				<div class="zoom_btn" aria-label="확대"><i class="xi-zoom-in"></i></div>
				<div class="zoom_btn" aria-label="축소"><i class="xi-zoom-out"></i></div>
				<div class="zoom_btn" aria-label="새로고침"><i class="xi-refresh"></i></div>
			</div>
			<script>
				var WIDGET_SETTING_LIST = [];

				$(document).ready(function() {
					widgetStngPopView();
					widgetStngColrPopView();
			   	});

				function widgetStngPopView() {
					// 과제 유형에 따라 URL 분기(개인, 팀)
			        var url = "/dashboard/widgetStngPopView.do";
					var data = {};

				   	ajaxCall(url, data, function(res) {
						if(res.sessChkYn == 'Y') {
					        var widgetList = res.data.widgetStngCts;

						    if (typeof widgetList === "string") {
						        widgetList = JSON.parse(widgetList);
						    }

						    if (widgetList && Array.isArray(widgetList)) {
					            var html = "";
						            html += "<div class='info-tit'>";
						            html += "    <span>사용할 위젯을 선택하세요</span>";
						            html += "</div>";
						            html += "<div class='widget-list'>";

					            $.each(widgetList, function(index, item) {
					            	var checked = (item.visibleYn === 'Y') ? "checked" : "";

					                html += "    <span class='custom-input'>";
					                html += "        <input type='checkbox' ";
					                html += "               id='" + item.widgetId + "' ";
					                html += "               name='" + item.widgetId + "' ";
					                html += "               data-posx='" + item.posX + "' ";
					                html += "               data-posy='" + item.posY + "' ";
					                html += "               data-posw='" + item.posW + "' ";
					                html += "               data-posh='" + item.posH + "' ";
					                html += "               data-visible-yn='" + (item.visibleYn || 'N') + "' ";
					                html += "               data-widget-name='" + item.widgetNm + "' " + checked + ">";
					                html += "        <label for='" + item.widgetId + "'>" + item.widgetNm + "</label>";
					                html += "    </span>";
					            });

					            html += "</div>";

					            /* $.each(widgetList, function(index, item) {
					                html += "<span class='custom-input'>";
					                html += "    <input type='checkbox' id='" + item.widgetId + "' data-widget-name='" + item.widgetNm + "'>";
					                html += "    <label for='" + item.widgetId + "'>" + item.widgetNm + "</label>";
					                html += "</span>";
					            }); */

					            $(".widgetStngGrp").empty().append(html);
					        } else {
					            console.error("widgetStngCts가 배열이 아닙니다:", widgetList);
					        }
						} else {
							console.error("세션이 존재하지 않습니다.");
						}
				    });
				};

				function widgetStngColrPopView() {
					// 과제 유형에 따라 URL 분기(개인, 팀)
			        var url = "/dashboard/widgetStngColrPopView.do";
					var data = {};

					ajaxCall(url, data, function(res) {
						if(res.sessChkYn == 'Y') {
						    if (res.result > 0) {
						    	var html = "";
						    		html +="<div class='info-tit'>"
						    		html +="	<span>컬러를 선택하세요</span>"
						    		html +="</div>"
						    		html +="<div class='widget-list'>"
								    html +="	<span class='custom-input'>"
								    html +="		<input type='radio' id='color1' name='color' checked>"
								    html +="		<label for='color1'>기본</label>"
							        html +="	</span>"
							        html +="	<span class='custom-input'>"
							        html +="		<input type='radio' id='color2' name='color'>"
							        html +="		<label for='color2'>블루</label>"
							        html +="	</span>"
							        html +="	<span class='custom-input'>"
							        html +="		<input type='radio' id='color3' name='color'>"
							        html +="		<label for='color3'>민트</label>"
							        html +="	</span>"
							        html +="	<span class='custom-input'>"
									html +="		<input type='radio' id='color4' name='color'>"
									html +="		<label for='color4'>오렌지</label>"
									html +="	</span>"
									html +="	<span class='custom-input'>"
									html +="		<input type='radio' id='color5' name='color'>"
									html +="		<label for='color5'>레드</label>"
									html +="	</span>"
									html +="	<span class='custom-input'>"
									html +="		<input type='radio' id='color6' name='color'>"
									html +="		<label for='color6'>퍼플</label>"
									html +="	</span>"
									html +="</div>"

						        	$(".widgetStngGrpColr").empty().append(html);

						    	    if (res.data.color === 'COLOR1') {
						    	        $("#color1").prop("checked", true);
						    	    } else if (res.data.color === 'COLOR2') {
						    	    	$("#color2").prop("checked", true);
						    	    } else if (res.data.color === 'COLOR3') {
						    	    	$("#color3").prop("checked", true);
						    	    } else if (res.data.color === 'COLOR4') {
						    	    	$("#color4").prop("checked", true);
						    	    } else if (res.data.color === 'COLOR5') {
						    	    	$("#color5").prop("checked", true);
						    	    } else if (res.data.color === 'COLOR6') {
						    	    	$("#color6").prop("checked", true);
						    	    }
						    } else {
						    	console.error(res.message);
						    }
						} else {
							console.error("세션이 존재하지 않습니다.");
						}
					}, function(xhr, status, error) {
					    alert("<spring:message code='fail.common.msg' />");
					}, true);
				}

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

				document.querySelector('[aria-label="확대"]').addEventListener('click', zoomIn);
				document.querySelector('[aria-label="축소"]').addEventListener('click', zoomOut);
				document.querySelector('[aria-label="새로고침"]').addEventListener('click', zoomReset);
			</script>

		</li>
		<li class="alrim"><!-- 버튼 클릭시 on 클래스 추가 -->
			<a href="#0" data-medi-ui="mail" title="알림"><i class="icon-svg-bell-01" aria-hidden="true"></i></a>
			<label class="count" id="headerNotiTotalCnt" style="display:none;">0</label>

            <div class="menu">
                <div class="btn-more"><a href="#0"><i class="icon-svg-plus"></i></a></div>
                <!--tab-type1-->
                <nav class="tab-type1">
                    <a href="#tab1" class="btn current" data-chnl="PUSH"><span>PUSH</span><small class="msg_num" id="headerPushCnt">0</small></a>
                    <a href="#tab2" class="btn" data-chnl="SMS"><span>SMS</span><small class="msg_num" id="headerSmsCnt">0</small></a>
                    <a href="#tab3" class="btn" data-chnl="SHRTNT"><span><spring:message code='msg.title.msg.shrtnt'/></span><small class="msg_num" id="headerShrtntCnt">0</small></a>
                    <a href="#tab4" class="btn" data-chnl="ALIM_TALK"><span><spring:message code='msg.title.msg.alimTalk'/></span><small class="msg_num" id="headerAlimtalkCnt">0</small></a>
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
                var headerNotiData = null;
                var isHeaderNotiLoaded = false;
                var headerNotiPollingId = null;
                var HEADER_NOTI_POLLING_INTERVAL = 120000; // 2분

                $(document).ready(function() {
                    // 페이지 로드 시 읽지 않은 알림 개수만 조회
                    headerNotiUnreadCntSelect();

                    // 알림 드롭다운 클릭 시 목록 조회
                    $('li.alrim > a[data-medi-ui="mail"]').on('click', function() {
                        if (!isHeaderNotiLoaded) {
                            headerNotiList();
                        }
                    });

                    // Polling 시작
                    headerNotiPollingStart();

                    // 탭 활성화/비활성화 감지
                    document.addEventListener('visibilitychange', function() {
                        if (document.hidden) {
                            // 탭 비활성화 시 Polling 중지
                            headerNotiPollingStop();
                        } else {
                            // 탭 활성화 시 즉시 조회 후 Polling 재시작
                            headerNotiUnreadCntSelect();
                            isHeaderNotiLoaded = false; // 목록도 다시 로드하도록
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

                function headerNotiList() {
                    var param = { chnlCd: 'ALL', listCnt: 5 };

                    ajaxCall('/alimChnlListAjax.do', param, function(data) {
                        if (data.result > 0 && data.returnVO) {
                            headerNotiData = data.returnVO;
                            isHeaderNotiLoaded = true;

                            // 개수 업데이트
                            if (data.returnVO.unreadCnt) {
                                headerNotiCntUpdate(data.returnVO.unreadCnt);
                            }

                            // 목록 렌더링
                            headerNotiListRender('PUSH', data.returnVO.pushList, '#headerPushList', 'push');
                            headerNotiListRender('SMS', data.returnVO.smsList, '#headerSmsList', 'sms');
                            headerNotiListRender('SHRTNT', data.returnVO.msgList, '#headerMsgList', 'msg');
                            headerNotiListRender('ALIM_TALK', data.returnVO.talkList, '#headerTalkList', 'talk');
                        }
                    }, function(xhr, status, error) {
                        console.error('알림 목록 조회 실패');
                    }, false, {type: 'GET'});
                }

                function headerNotiListRender(chnlCd, list, targetSelector, itemClass) {
                    var $target = $(targetSelector);
                    var html = '';

                    if (list && list.length > 0) {
                        $.each(list, function(idx, item) {
                            var name = item.sbjctnm || item.sndngnm || '';
                            var date = UiComm.formatDate(item.sndngDttm, "datetime");
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
            </script>
        </li>
        <li class="lang_change"><!-- 버튼 클릭시 on 클래스 추가 -->
            <a href="#0" aria-label="언어선택" data-medi-ui="langs"><i class="icon-svg-globe-01"></i></a>
            <div class="option-wrap">
                <div class="item selected"><a href="#0">한국어</a></div>
                <div class="item"><a href="#0">English</a></div>
                <div class="item"><a href="#0">日本語</a></div>
                <div class="item"><a href="#0">汉语</a></div>
            </div>
        </li>
        <li class="mode">
            <a href="#0" data-medi-ui="mode"><i class="icon-svg-moon-star" aria-hidden="true"></i></a>
        </li>
        <li class="log">
            <a href="/user/userHome/logout.do"><i class="icon-svg-logout" aria-hidden="true"></i></a>
        </li>

    </ul>

</header>

</c:if>