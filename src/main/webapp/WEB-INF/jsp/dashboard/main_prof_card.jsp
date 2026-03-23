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

<c:set var="orgId" value="${orgId}"/>
<c:set var="userId" value="${userId}"/>
<c:set var="authrtGrpcd" value="${authrtGrpcd}"/>

<body class="home colorA ">
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp">
            <jsp:param name="orgId" value="${orgId}" />
            <jsp:param name="userId" value="${userId}" />
            <jsp:param name="authrtGrpcd" value="${authrtGrpcd}" />
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
			case 'wigt_prof_today': // Today
				contentBox.load("/dashboard/profWidgetToday.do");
				break;

			case 'wigt_prof_schedule': // 이달의 학사일정
				contentBox.load("/dashboard/profWidgetSchedule.do");
				break;

			case 'wigt_prof_notice': // 공지사항
				contentBox.load("/dashboard/profWidgetNotice.do");
				break;

			case 'wigt_prof_qna': // 강의Q&A
				contentBox.load("/dashboard/profWidgetQna.do");
				break;

			case 'wigt_prof_counsel': // 1:1상담
				contentBox.load("/dashboard/profWidgetCounsel.do");
				break;

			case 'wigt_prof_msg': // 알림(메시지)
				contentBox.load("/dashboard/profWidgetMsg.do");
				break;

			case 'wigt_prof_subject': // 강의과목
				contentBox.load("/dashboard/profWidgetSubject.do");
				break;

   	  	    default:
				break;
		}
	}
    </script>

</body>
</html>
