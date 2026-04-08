<%@ page import="knou.framework.common.SessionInfo" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:if test="${pageType ne 'iframe' or param.view eq 'on'}">

<c:set var="orgId" value="${orgId}"/>
<c:set var="userId" value="${userId}"/>
<c:set var="authrtGrpcd" value="${authrtGrpcd}"/>

<script type="text/javascript">
/* 1. 즉시 실행 로그 - 이게 안 찍히면 스크립트 태그 위치가 잘못된 것입니다. */
console.log("--- 스크립트 진입 성공 ---");

(function() {
    // JSP 데이터 로드
    var userData = [
        <c:forEach var="item" items="${SessionInfo.getUserContext(pageContext.request).getUserOrgIdsFromSubject()}" varStatus="status">
        { 
            orgId: "${item.orgId}".trim(), 
            orgnm: "${item.orgnm}".trim(), 
            userTycd: "${item.userTycd}".trim(), 
            userId: "${item.userId}".trim() 
        }${!status.last ? ',' : ''}
        </c:forEach>
    ];

    console.log("데이터 개수:", userData.length);

    // 문서 로드 후 실행
    window.onload = function() {
        console.log("window.onload 실행됨");
        
        var orgSelect = document.getElementById('orgSelect');
        var typeSelect = document.getElementById('typeSelect');
        var userIdText = document.getElementById('userIdText');

        if (!orgSelect) {
            console.error("ID가 'orgSelect'인 요소를 찾을 수 없습니다.");
            return;
        }

        // 2. 기관 중복 제거 및 채우기
        var orgMap = {};
        var html = '<option value="">기관을 선택하세요</option>';
        
        for (var i = 0; i < userData.length; i++) {
            var item = userData[i];
            if (item.orgId && item.orgId !== 'ALL' && !orgMap[item.orgId]) {
                orgMap[item.orgId] = true;
                html += '<option value="' + item.orgId + '">' + item.orgnm + '</option>';
            }
        }
        orgSelect.innerHTML = html;
        console.log("기관 SelectBox 채우기 완료");

        // 3. 기관 변경 이벤트
        orgSelect.onchange = function() {
            var selectedId = this.value;
            console.log("기관 변경:", selectedId);
            
            typeSelect.innerHTML = '<option value="">타입 선택</option>';
            userIdText.innerText = "-";

            if (!selectedId) return;

            var types = [];
            var typeMap = {};
            
            // 필터링 (해당 기관 + 전체)
            for (var j = 0; j < userData.length; j++) {
                var item = userData[j];
                if (item.orgId === selectedId || item.orgId === 'ALL') {
                    if (!typeMap[item.userTycd]) {
                        typeMap[item.userTycd] = true;
                        types.push(item.userTycd);
                    }
                }
            }

            for (var k = 0; k < types.length; k++) {
                var ty = types[k];
                var name = (ty === 'PROF') ? '교수' : (ty === 'STDNT' ? '학생' : '전체');
                var opt = document.createElement('option');
                opt.value = ty;
                opt.text = name;
                typeSelect.appendChild(opt);
            }
        };

        // 4. 타입 변경 이벤트
        typeSelect.onchange = function() {
            var selectedOrg = orgSelect.value;
            var selectedTy = this.value;
            var foundId = "-";

            for (var m = 0; m < userData.length; m++) {
                var item = userData[m];
                if (selectedTy === 'ALL' && item.orgId === 'ALL') {
                    foundId = item.userId;
                    break;
                } else if (item.orgId === selectedOrg && item.userTycd === selectedTy) {
                    foundId = item.userId;
                    break;
                }
            }
            userIdText.innerText = foundId;
        };
    };
})();
</script>

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
		<a href="/">
			<img src="<%=request.getContextPath()%>/webdoc/assets/img/logo.png" aria-hidden="true" alt="한국방송통신대학교">
		</a>
	</h1>
	
	<div class="option-univ"><!-- 버튼 클릭시 on 클래스 추가 -->
		<select id="orgSelect" class="form-select" style="font-size:15px; border-radius:100em;">
			<option value="">기관을 선택하세요</option>
		</select>
        <select id="typeSelect" class="form-select wide" style="font-size:15px; margin-left: 5px; border-radius:100em;">
        	<option value="">타입 선택</option>
        </select>
	</div>
	
	<div id="userIdText" style="margin-top: 10px; font-weight: bold; color: #007bff;"></div>

	<ul class="util">
		<li class="widget_setting"><!-- 버튼 클릭시 on 클래스 추가 -->
			<a href="#0" data-medi-ui="widget"><i class="icon-svg-widget" aria-hidden="true"></i>위젯설정</a>

			<div class="menu">
				<div class="widgetStngGrp" style="border:1px solid #cdcdcd;" ></div>
				<div class="widgetStngGrpColr"></div>

				<div class="info-txt2">
					<i class="icon-svg-move"></i>
					<span>드래그하여 위젯을 원하는 위치로 이동하세요.</span>
				</div>
				<div class="btns">
					<button type="button" class="btn type5" onclick="widgetStngChange1()">저장</button>
					<button type="button" class="btn gray2" onclick="closeModal()">취소</button>
					<button type="button" class="btn gray2" onclick="widgetReset()">초기화</button>
				</div>
			</div>

		</li>
		<li class="info_time"><span>이전로그인 2026.03.17 15:01 (61.43.234.211)</span></li>
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
				    var url = "/dashboard/widgetStngPopView.do";
				    var data = {
				    	orgId: "${orgId}",
				    	userId: "${userId}",
				        authrtGrpcd: "${authrtGrpcd}"
				    };

				    ajaxCall(url, data, function(res) {
				        if(res.sessChkYn == 'Y') {
				            var widgetList = res.data.widgetStngCts;

				            // 문자열일 경우 파싱 처리
				            if (typeof widgetList === "string") {
				                widgetList = JSON.parse(widgetList);
				            }

				            if (widgetList && Array.isArray(widgetList)) {
				                var html = "";

				                // 상단 타이틀 영역
				                html += "<div class='info-tit'>";
				                html += "    <span>사용할 위젯을 선택하세요</span>";
				                html += "</div>";

				                html += "<div class='widget-list-container' style='margin-top:10px;'>";

				                $.each(widgetList, function(index, item) {
				                    var checkedAttr = (item.pvsnyn === 'Y') ? "checked" : "";

				                    html += "    <div class='widget-item' style='margin-bottom:8px;'>";
				                    html += "        <span class='custom-input'>";
				                    html += "            <input type='checkbox' ";
				                    html += "                   id='" + item.widgetId + "' ";
				                    html += "                   name='widget_chk' "; // 일괄 관리를 위한 name 통일
				                    html += "                   data-widget-id='" + item.widgetId + "' ";
				                    html += "                   data-posx='" + item.posX + "' ";
				                    html += "                   data-posy='" + item.posY + "' ";
				                    html += "                   data-posw='" + item.posW + "' ";
				                    html += "                   data-posh='" + item.posH + "' ";
				                    html += "                   data-widget-nm='" + item.widgetNm + "' " + checkedAttr + ">";
				                    html += "            <label for='" + item.widgetId + "' style='margin-left:5px; cursor:pointer;'>" + item.widgetNm + "</label>";
				                    html += "        </span>";
				                    html += "    </div>";
				                });

				                html += "</div>";

				                // 대상 영역에 렌더링
				                $(".widgetStngGrp").empty().append(html);

				            } else {
				                console.error("데이터가 배열 형태가 아닙니다.", widgetList);
				            }
				        } else {
				            console.error("세션이 만료되었습니다.");
				            // alert("로그인이 필요합니다.");
				        }
				    });
				}

				function widgetStngColrPopView() {
				    var url = "/dashboard/widgetStngColrPopView.do";
				    var data = {
				        orgId: "${orgId}",
				        userId: "${userId}"
				    };

				    ajaxCall(url, data, function(res) {
				        if (res.sessChkYn === 'Y') {
				            if (res.result > 0) {
				                // 1. 컬러 데이터 배열 정의
				                const colorList = [
				                    { id: 'color1', label: '기본', value: 'basic' },
				                    { id: 'color2', label: '블루', value: 'blue' },
				                    { id: 'color3', label: '민트', value: 'mint' },
				                    { id: 'color4', label: '오렌지', value: 'orange' },
				                    { id: 'color5', label: '레드', value: 'red' },
				                    { id: 'color6', label: '퍼플', value: 'purple' }
				                ];

				                // 2. 반복문을 통한 HTML 생성
				                var html = "";
				                html += "<div class='info-tit'><span>컬러를 선택하세요</span></div>";
				                html += "<div class='widget-list'>";

				                colorList.forEach(function(item) {
				                    html += "    <span class='custom-input'>";
				                    html += "        <input type='radio' id='" + item.id + "' name='color' value='" + item.value + "'>";
				                    html += "        <label for='" + item.id + "'>" + item.label + "</label>";
				                    html += "    </span>";
				                });

				                html += "</div>";

				                // DOM 반영
				                $(".widgetStngGrpColr").empty().append(html);

				                // 3. 선택된 컬러 체크 로직 (find 사용)
				                if (res.data && res.data.color) {
				                    const selectedColor = colors.find(c => c.value === res.data.color);
				                    if (selectedColor) {
				                        $("#" + selectedColor.id).prop("checked", true);
				                    }
				                } else {
				                    // 기본값: COLOR1 체크
				                    $("#color1").prop("checked", true);
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

				function widgetStngChange1() {
					let internalGrid = null;

				    $('.grid-stack, .grid-stack-instance, #dashboardWidget div').each(function() {
				        const gridObj = this.gridstack || $(this).data('gridstack') || $(this).data('grid-stack');
				        if (gridObj) {
				            internalGrid = gridObj;
				            return false;
				        }
				    });

				    if (!internalGrid && typeof GridStack !== 'undefined') {
				        try {
				            internalGrid = GridStack.get() || GridStack.engine;
				        } catch(e) {}
				    }

				    if (!internalGrid) {
				        alert("위젯 설정 정보를 불러올 수 없습니다. 화면 로딩 후 다시 시도해주세요.");
				        return;
				    }

				    const currentLayout = internalGrid.save(true);
				    var updatedList = [];

				    // 2. 체크박스 순회
				    $(".widgetStngGrp input[name='widget_chk']").each(function() {
				        var $this = $(this);
				        var widgetId = $this.attr("id");
				        var isChecked = $this.is(":checked");

				        // 3. 이름(widgetNm) 가져오기: data 속성 우선, 없으면 label 텍스트 사용
				        var widgetNm = $this.data("widget-name") || $this.next("label").text();

				        // 4. 현재 화면에 있는 위젯인지 확인하여 좌표 결정
				        var layoutItem = currentLayout.find(item => item.id === widgetId);

				        updatedList.push({
				            widgetId : widgetId,
				            widgetNm : widgetNm,
				            pvsnyn   : isChecked ? "Y" : "N",
				            // 화면에 있으면 실시간 좌표(x, y, w, h), 없으면 input에 심어둔 data 값 사용
				            posX     : layoutItem ? layoutItem.x : $this.data("posx"),
				            posY     : layoutItem ? layoutItem.y : $this.data("posy"),
				            posW     : layoutItem ? layoutItem.w : $this.data("posw"),
				            posH     : layoutItem ? layoutItem.h : $this.data("posh"),
				            userId   : "${userId}",
				            visibleYn: isChecked ? "Y" : "N" // 기존 코드에서 사용하던 visibleYn도 함께 갱신
				        });
				    });

				    var url = "/dashboard/widgetStngChange.do";
				    var data = {
				        userId            : "${userId}",
				        widgetUseId       : "PROF",
				        widgetId          : "PROF",
				        widgetNm          : "PROF",
				        orgId             : "LMSBASIC",
				        widgetUserStngCts : JSON.stringify(updatedList)
				    };

				    ajaxCall(url, data, function(res) {
				        // res.result가 숫자일 수도 있고 "success" 문자열일 수도 있으니 상황에 맞게 조건 수정
				        if (res.result > 0 || res.result === "success") {
				            // 팝업 닫기 (함수명이 다를 수 있으니 확인 필요)
				            if (typeof layerPopClose === 'function') {
				                layerPopClose();
				            }
				            // 화면 새로고침하여 반영
				            location.reload();
				        } else {
				            alert("저장이 실패하였습니다.");
				        }
				    });
				}

				function closeModal() {
				    $(".widget_setting").removeClass("on");
				}

				function widgetReset() {
					UiComm.showMessage("설정하신 내용이 모두 초기화됩니다. 정말 초기화 하시겠습니까?", "confirm", "550")
					.then(function(result) {
						if (result) {
							var url = "/dashboard/widgetStngReset.do";
			    			var data = {
			    				orgId	: "${orgId}",
			    				userId	: "${userId}"
			    			};

			    			ajaxCall(url, data, function(res) {
						       if (res.result > 0 || res.result === "success") {
						           // 화면 새로고침하여 반영
						           location.reload();
						       } else {
						       }
						    });
						} else {
						}
					});
		    	};
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

                /* 헤더 알림 아이템 클릭 */
                $(document).on('click', 'li.alrim .item_txt[data-sndng-tycd]', function(e) {
                    e.preventDefault();
                    let sndngTycd = $(this).data('sndng-tycd');
                    let sndngId = $(this).data('sndng-id');

                    if (!sndngId) return;

                    if (sndngTycd === 'SHRTNT') {
                        location.href = '/profMsgShrtntRcvnSelectView.do?msgShrtntSndngId=' + encodeURIComponent(sndngId);
                    }
                });
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