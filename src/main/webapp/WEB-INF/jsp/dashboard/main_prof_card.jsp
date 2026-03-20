<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="module" value="widget"/>
		<jsp:param name="style" value="dashboard"/>
	</jsp:include>
</head>

<c:set var="userId" value="${userId}"/>
<c:set var="authrtGrpcd" value="${authrtGrpcd}"/>

<body class="home colorA ">
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp">
            <jsp:param name="userId" value="${userId}" />
      	</jsp:include>
        <!-- //common header -->

        <!-- dashboard -->
        <main class="common">
            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
            	<div id="container" class="ui form">
            		<div id="dashboardWidget" class="dashboard"></div>
		    	</div>
            </div>

            <!-- common footer -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
            <!-- //common footer -->

        </main>
        <!-- //dashboard-->
    </div>

	<script>
    let dashboardWidget = null;
    let userId = "${userId}";

    $(document).ready(function() {
		// 위젯 초기화
		dashboardWidget = UiWidget({
			targetId: "dashboardWidget",
			changeFunc: widgetStngChange
		});

		// 위젯 설정 조회
		widgetStngSelect();
	});

    // 위젯 설정 조회
    function widgetStngSelect() {
	    var url = "/dashboard/widgetStngSelect.do";
	    var data = {
	        userId: "${userId}",
	        authrtGrpcd: "${authrtGrpcd}"
	    };

	    ajaxCall(url, data, function(res) {
	        if (res.result > 0) {
	            let rawData = res.dataList;
	            if (typeof rawData === 'string') {
	                try {
	                    rawData = JSON.parse(rawData);
	                } catch (e) {
	                    console.error("데이터 파싱 중 오류 발생:", e);
	                }
	            }

	            if (!Array.isArray(rawData)) {
	                console.error("dataList가 배열 형식이 아닙니다.");
	                return;
	            }

	            const items = rawData
	                .filter(o => o.pvsnyn === 'Y') // 사용여부가 'Y'인 위젯만 화면에 그리도록 필터링
	                .map(o => {
						let opts = {
							x: o.posX,
							y: o.posY,
							w: o.posW,
							h: o.posH,
							minW: o.minW == undefined ? 4 : o.minW,
							minH: o.minH == undefined ? 4 : o.minH,
							maxW: o.maxW == undefined ? 12 : o.maxW,
							maxH: o.maxH == undefined ? 12 : o.maxH
						};

						// 위젯 추가
						dashboardWidget.addWidget(o.widgetId, o.widgetNm, opts, "");

						// 위젯 내용 로드
						loadWidgetContent(o.widgetId);
	                });


	        } else {
	            alert(res.message);
	        }
	    }, function(xhr, status, error) {
	        UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");
	    }, true);
	}

    // 위젯 변경 상태 저장
    function widgetStngChange(items) {
	    const finalData = items.map(item => {
	        return {
	            widgetId: item.widgetId,
	            widgetNm: item.widgetNm,
	            posX: item.x,
	            posY: item.y,
	            posW: item.w,
	            posH: item.h,
	            minW: item.minW,
				minH: item.minH,
				maxW: item.maxW,
				maxH: item.maxH,
	            userId: "${userId}",
	            pvsnyn: 'Y'
	        };
	    });

	    var url = "/dashboard/widgetStngChange.do";
	  	var data = {
		  			userId      : "${userId}",
		  			widgetUseId : "PROF",
		  			widgetId    : "PROF",
		    	  	widgetNm    : "PROF",
		    	  	orgId       : "LMSBASIC",
		    		widgetUserStngCts  : JSON.stringify(finalData)
		};

  	  	ajaxCall(url, data, function(res) {
  	  		if (res.result > 0) {
				console.log("widget 저장.....");
  	  		} else {
  	  			console.log("저장 실패");
  	        }
		}, function(xhr, status, error) {
			UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");
		}, true);
	}

	// 위젯 내용 로드
	function loadWidgetContent(widgetId) {
		let contentBox = $("#"+widgetId+"_content");

		switch (widgetId) {
			case 'card1': // Today
				contentBox.load("/dashboard/profWidgetToday.do");
				break;

			case 'card2': // 이달의 학사일정
				contentBox.load("/dashboard/profWidgetSchedule.do");
				break;

			case 'card3': // 공지사항
				contentBox.load("/dashboard/profWidgetNotice.do");
				break;

			case 'card4': // 강의Q&A
				contentBox.load("/dashboard/profWidgetQna.do");
				break;

			case 'card5': // 1:1상담
				contentBox.load("/dashboard/profWidgetCounsel.do");
				break;

			case 'card6': // 알림(메시지)
				contentBox.load("/dashboard/profWidgetMsg.do");
				break;

			case 'card7': // 강의과목
				contentBox.load("/dashboard/profWidgetSubject.do");
				break;

   	  	    default:
				break;
		}
	}



	/*
		// 알림 메시지
	var MSG_ALIM_UNREAD = '<spring:message code="msg.alim.label.unread"/>';
	var MSG_ALIM_READ = '<spring:message code="msg.alim.label.read"/>';
	var MSG_ALIM_EMPTY = '<spring:message code="common.content.not_found"/>';

	function widgetNotiList() {
    		    var param = { chnlCd: 'ALL', listCnt: 5 };

		    ajaxCall('/alimChnlListAjax.do', param, function(data) {
		        if (data.result > 0 && data.returnVO) {
		            // 개수 업데이트
		            if (data.returnVO.unreadCnt) {
		                widgetNotiCntUpdate(data.returnVO.unreadCnt);
		            }
		            // 목록 렌더링
		            widgetNotiListRender('PUSH', data.returnVO.pushList, '#widgetPushList', 'push');
		            widgetNotiListRender('SMS', data.returnVO.smsList, '#widgetSmsList', 'sms');
		            widgetNotiListRender('SHRTNT', data.returnVO.msgList, '#widgetMsgList', 'msg');
		            widgetNotiListRender('ALIM_TALK', data.returnVO.talkList, '#widgetTalkList', 'talk');
		        }
		    }, function(xhr, status, error) {
		        console.error('알림 위젯 목록 조회 실패');
		    }, false, {type: 'GET'});
		}

		function widgetNotiCntUpdate(data) {
		    $('#widgetPushCnt').text(data.pushCnt || 0);
		    $('#widgetSmsCnt').text(data.smsCnt || 0);
		    $('#widgetShrtntCnt').text(data.shrtntCnt || 0);
		    $('#widgetAlimtalkCnt').text(data.alimtalkCnt || 0);
		}

		function widgetNotiListRender(chnlCd, list, targetSelector, itemClass) {
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
	*/

    </script>

</body>
</html>
