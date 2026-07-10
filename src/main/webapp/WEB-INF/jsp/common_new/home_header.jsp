<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="knou.framework.common.SessionInfo" %>
<%@ page import="knou.framework.context2.UserContext" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<c:if test="${pageType ne 'iframe' or param.view eq 'on'}">

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

	<div class="option-univ">
		<select id="subjectOrgSelect" class="form-select" title="<spring:message code='common.message.select.org'/>"><%-- 기관을 선택하세요. --%>
		</select>
        <select id="subjectUserTypeSelect" class="form-select" title="<spring:message code='common.message.select.user_type'/>"><%-- 사용자 유형을 선택하세요. --%>
        	<option value="">-- <spring:message code='common.usertype.type'/> --</option>
        </select>
		<select id="subjectSmstrSelect" class="form-select" title="<spring:message code='common.alert.select.term'/>"><%-- 학기를 선택하세요. --%>
			<option value="">-- <spring:message code='common.term'/> --</option>
        </select>

		<script type="text/javascript">
		console.log("--- 스크립트 진입 성공 ---");

		let profDashboardUrl = "/dashboard/profDashboard.do";
		let stuDashboardUrl = "/dashboard/stuDashboard.do";

		(function() {
		    // 기관 데이터 로드
		    let subjectOrgData = [
		        <c:forEach var="item" items="${SessionInfo.getUserContext(pageContext.request).getSubjectOrgList()}" varStatus="status">
			        {
			            headerOrgId: "${item.orgId}",
			            headerOrgnm: "${item.orgnm}",
			            headerUserTycd: "${item.userTycd}",
			            headerUserId: "${item.userId}",
			            headerUserTycdList: [
			                <c:forEach var="tycd" items="${item.orgUserTycdList}" varStatus="tycdStatus">
			                    "${tycd}"${!tycdStatus.last ? ',' : ''}
			                </c:forEach>
			            ]
			        } ${!status.last ? ',' : ''}
		        </c:forEach>
		    ];

		    // 학기 데이터 로드
		    let smstrData = [
		    	<c:forEach var="item" items="${SessionInfo.getUserContext(pageContext.request).getSmstrChrtList()}" varStatus="status">
			    	{
			    		smstrChrtId: "${item.smstrChrtId}",
			    		smstrChrtnm: "${item.smstrChrtnm}",
			    		nowSmstryn: "${item.nowSmstryn}",
			    		orgId: "${item.orgId}",
			    		orgShrtnm: "${item.orgShrtnm}",
			    		userTycd: "${item.userTycd}"
			    	} ${!status.last ? ',' : ''}
		    	</c:forEach>
		    ];

		    // 기관 select 생성
		    function drawOrgSelect() {
		        $.each(subjectOrgData, function(index, item) {
					let selected = item.headerOrgId === "${uiex:getParamValue('orgId')}" ? "selected" : "";

		            if (index === 0 && item.headerOrgId === '') {
		                if ("PROF" == "${authrtGrpcd}") {
		                    $('#subjectOrgSelect').append(`<option value="" \${selected}>-- <spring:message code='common.all'/> --</option>`);
		                }
		                else if ("STDNT" == "${authrtGrpcd}") {
		                    $('#subjectOrgSelect').append(`<option value="" \${selected}>-- <spring:message code='common.all'/> --</option>`);
		                }
		            } else {
		                $('#subjectOrgSelect').append(`<option value="\${item.headerOrgId}" \${selected}>\${item.headerOrgnm}</option>`);
		            }
		        });

		        $('#subjectOrgSelect').trigger("chosen:updated");

		    	// 기관 선택
		    	$("#subjectOrgSelect").on("change", function(){
		    		let headerOrgId = $(this).val();
		    		let orgData = subjectOrgData.find(item => item.headerOrgId === headerOrgId);
		            let headerUserTycd = orgData ? orgData.headerUserTycd : "";
		            let typeList = orgData ? orgData.headerUserTycdList : [];

		    		if ("" === headerOrgId) {
		                moveToDashboard(headerOrgId, "", "");
		    		}
		    		else if (typeList.length === 1) {
		                let targetTycd = typeList[0];
		                moveToDashboard(headerOrgId, targetTycd, "");
		            }
		            else if (typeList.length === 0 && headerUserTycd && headerUserTycd !== "null") {
		                moveToDashboard(headerOrgId, headerUserTycd, "");
		            }
		    	});
		    }

		    // 사용자유형 select 생성
		    function drawUserTycdSelect(orgId) {
		    	let orgData = subjectOrgData.find(item => item.headerOrgId === orgId);
		        let typeList = orgData ? orgData.headerUserTycdList : [];
		        let userTycd = "${uiex:getParamValue('userTycd')}";

		        $('#subjectUserTypeSelect').empty();

		        if (typeList.length > 1 || orgId === "") {
		            $('#subjectUserTypeSelect').append(`<option value="">-- <spring:message code='common.usertype.type'/> --</option>`);
		        }
		        //alert("${uiex:getParamValue('userTycd')}");

		        $.each(typeList, function(index, item) {
					let typeNm = "";
		            if (item === 'PROF') typeNm = "<spring:message code='common.usertype.prof'/>";
		            else if (item === 'TUT') typeNm = "<spring:message code='common.usertype.tutor'/>";
		            else if (item === 'ASSI') typeNm = "<spring:message code='common.usertype.assist'/>";
		            else if (item === 'STDNT') typeNm = "<spring:message code='common.usertype.stdnt'/>";

		            $('#subjectUserTypeSelect').append(`<option value="\${item}" \${userTycd === item ? "selected" : ""}>\${typeNm}</option>`);
		        });

		        $('#subjectUserTypeSelect').trigger("chosen:updated");

		     	// 유형 선택
		    	$("#subjectUserTypeSelect").on("change", function(){
		    		let headerOrgId = $('#subjectOrgSelect').val();
		    		let headerUserTycd = $('#subjectUserTypeSelect').val();
		    		moveToDashboard(headerOrgId, headerUserTycd, "");
		    	});
		    }

		    // 학기 선택 select 생성
		    function drawSmstrSelect(orgId, userTycd) {
		        if (smstrData.length > 0) {
			    	$('#subjectSmstrSelect').empty();

				    $.each(smstrData, function(index, item) {
						if (orgId === "" || (orgId != "" && orgId == item.orgId)) {
							let selected = (item.smstrChrtId === "${uiex:getParamValue('smstrChrtId')}") ? "selected" : "";
							let smstrChrtnm = item.smstrChrtnm;

							if (smstrChrtnm === "ALL") {
								smstrChrtnm = "-- 전체(현재학기) --";
							}
							else if (orgId === "") {
								smstrChrtnm = "[" + item.orgShrtnm + "] " + smstrChrtnm;
							}

							$('#subjectSmstrSelect').append(`<option value="\${item.smstrChrtId}" \${selected}>\${smstrChrtnm}</option>`);
						}
				    });

					$('#subjectSmstrSelect').trigger("chosen:updated");
		        }

		        // 학기 선택
		    	$("#subjectSmstrSelect").on("change", function(){
					let headerOrgId = $('#subjectOrgSelect').val();
		    		let headerUserTycd = $('#subjectUserTypeSelect').val();
		    		let selSmstrChrtId = $(this).val();
		    		moveToDashboard(headerOrgId, headerUserTycd, selSmstrChrtId);
		    	});
		    }

			// 기관/사용자유형/학기 선택시 대시보드 이동 함수
			function moveToDashboard(headerOrgId, headerUserTycd, smstrChrtId) {
				let extData = {
		    		headerOrgId: headerOrgId,
		    		headerUserTycd: headerUserTycd,
		    		headerSmstrChrtId: smstrChrtId
				};

				if (!headerUserTycd) {
					headerUserTycd = "${authrtGrpcd}";
				}

		        let targetUrl = (headerUserTycd === 'STDNT') ? stuDashboardUrl : profDashboardUrl;
		        location.href = targetUrl + "?addParams=" + UiComm.makeEncParams(extData);
		    }

		    // 기관 select 생성 호출
		    drawOrgSelect();

		    // 사용자유형 select 생성 호출
		    drawUserTycdSelect("${uiex:getParamValue('orgId')}");

		    // 학기 select 생성 호출
		   	drawSmstrSelect("${uiex:getParamValue('orgId')}", "${uiex:getParamValue('userTycd')}");
		})();
		</script>
	</div>

	<div id="userIdText" style="margin-top: 10px; font-weight: bold; color: #007bff;"></div>

	<ul class="util">
		<%-- 위젯 설정 --%>
		<li class="widget_setting">
			<a href="#0" data-medi-ui="widget"><i class="icon-svg-widget" aria-hidden="true"></i>위젯설정</a>
			<div class="menu">
				<div class="widget_set_group">
					<div class="info-tit">
						<span>사용할 위젯을 선택하세요</span>
					</div>
					<div id="widgetTmplList" class="widget-list"></div>
				</div>
				<div class="info-txt2">
					<i class="icon-svg-move"></i>
					<span>드래그하여 위젯을 원하는 위치로 이동하세요.</span>
				</div>
				<div class="btns">
					<button type="button" class="btn type5" onclick="widgetStngChange1()"><spring:message code='button.save'/><%-- 저장 --%></button>
					<button type="button" class="btn gray2" onclick="closeModal()"><spring:message code='button.cancel'/><%-- 취소 --%></button>
					<button type="button" class="btn gray2" onclick="widgetReset()"><spring:message code='button.reset'/><%-- 초기화 --%></button>
				</div>
			</div>
			<script>
				var WIDGET_SETTING_LIST = [];

				$(document).ready(function() {
					widgetStngPopView();
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

				                $.each(widgetList, function(index, item) {
				                    var checkedAttr = (item.pvsnyn === 'Y') ? "checked" : "";

									html += `<span class="custom-input">`;
									html += `  <input type='checkbox' `;
				                    html += `    id='\${item.widgetId}' `;
				                    html += `    name='widget_chk' `; // 일괄 관리를 위한 name 통일
				                    html += `    data-widget-id='\${item.widgetId}' `;
				                    html += `    data-posx='\${item.posX}' `;
				                    html += `    data-posy='\${item.posY}' `;
				                    html += `    data-posw='\${item.posW}' `;
				                    html += `    data-posh='\${item.posH}' `;
				                    html += `    data-minw='\${item.minW}' `;
				                    html += `    data-minh='\${item.minH}' `;
				                    html += `    data-maxw='\${item.maxW}' `;
				                    html += `    data-maxh='\${item.maxH}' `;
				                    html += `    data-widget-nm='\${item.widgetNm}' \${checkedAttr}>`;
				                    html += `  <label for='\${item.widgetId}' style='margin-left:5px; cursor:pointer;'>\${item.widgetNm}</label>`;
									html += `</span>`;
				                });

				                $("#widgetTmplList").html(html);

				            } else {
				                console.error("데이터가 배열 형태가 아닙니다.", widgetList);
				            }
				        } else {
				            console.error("세션이 만료되었습니다.");
				        }
				    });
				}

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
				    $("#widgetTmplList input[name='widget_chk']").each(function() {
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
				            // 화면에 있으면 실시간 좌표(x, y, w, h), 없으면 input에 심어둔 data 값 사용
				            posX     : layoutItem ? layoutItem.x : $this.data("posx"),
				            posY     : layoutItem ? layoutItem.y : $this.data("posy"),
				            posW     : layoutItem ? layoutItem.w : $this.data("posw"),
				            posH     : layoutItem ? layoutItem.h : $this.data("posh"),
		            		minW     : $this.data("minw"),
				            minH     : $this.data("minh"),
				            maxW     : $this.data("maxw"),
				            maxH     : $this.data("maxh"),
				            pvsnyn   : isChecked ? "Y" : "N"
				        });
				    });

				    var url = "/dashboard/widgetStngChange.do";
				    var data = {
				        userId            : "${userId}",
				        widgetUseId       : "${authrtGrpcd}",
				        widgetId          : "${authrtGrpcd}",
				        widgetNm          : "${authrtGrpcd}",
				        widgetExpln       : "${authrtGrpcd}",
				        orgId             : "${orgId}",
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

		<li class="info_time">
			<%
			UserContext userContext = SessionInfo.getUserContext(request);
			if ( userContext != null ) {
			%>
			<span>
				이전로그인 <uiex:formatDate type="datetime2" value="<%=userContext.getLastLoginDttm()%>"/>
				(<%=userContext.getLastLoginIp()%>)
			</span>
			<% }  %>
		</li>

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

</c:if>