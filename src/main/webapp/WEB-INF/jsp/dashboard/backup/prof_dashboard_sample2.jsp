<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/main_default_sample.css?v=3" />
<link rel="stylesheet" type="text/css" href="/webdoc/css/gridstack.min.css" />
<script src="/webdoc/js/gridstack-all.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<%@ include file="/WEB-INF/jsp/common/frontGnb_sample.jsp" %>

<style>
header.common {
  background-color: #ffffff;
}

.modal-lg {
  width: 500px !important;
}

/* 🎨 대시보드 카드 디자인 */
body {
  font-family: 'Noto Sans KR', 'Pretendard', sans-serif;
  background-color: #f6f8fa;
  color: #333;
}

.grid-stack {
  margin: 20px;
}

/* 각 위젯 카드 */
.course-card {
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
  padding: 20px;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  transition: all 0.25s ease;
}

.course-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(0,0,0,0.12);
}

/* 제목 */
.card-title {
  font-weight: 700;
  font-size: 1.1rem;
  margin-bottom: 12px;
  color: #1f2d3d;
  padding-bottom: 6px;
}

/* 내용 */
.card-content {
  flex: 1;
  font-size: 0.9rem;
  color: #555;
  line-height: 1.5;
}

/* GridStack 영역 */
.grid-stack-item-content {
  background: transparent;
  border-radius: 16px;
}

/* 모달 창 */
.modal-content {
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0,0,0,0.15);
}

/* 빈 콘텐츠 표시용 */
.empty, .no_content {
  text-align: center;
  color: #999;
  padding: 40px 0;
  font-size: 0.9rem;
}
</style>

    <body class="<%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap" class="main">
            
			<%
			// 기관:방송대
            if (SessionInfo.isKnou(request)) {
				%>
				<jsp:include page="/WEB-INF/jsp/common/frontLnb_sample.jsp">
					<jsp:param name="coList" value="${coList}" />
				</jsp:include>
				<%
            }
			%>

          <div id="container2" class="ui form">
          
	      <div class="grid-stack" id="grid-stack-first">
		  </div>
	
		  <form id="widgetSettingForm" name="widgetSettingForm" method="post" style="position:absolute">
			<input type="hidden" name="crsCreCd" value="" />
		  </form>

		  <div class="modal fade in" id="widgetSettingModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="common.button.widgetSetting" />" aria-hidden="false" >
		    <div class="modal-dialog modal-lg" role="document">
		        <div class="modal-content">
		            <div class="modal-header">
		                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="common.button.close" />">
		                    <span aria-hidden="true">×</span>
		                </button>
		                <h4 class="modal-title"><spring:message code="common.button.widgetSetting" /></h4>
		            </div>
		            <div class="modal-body">
		                <iframe src="" width="100%" scrolling="no" id="widgetSettingIfm" name="widgetSettingIfm" title="widgetSettingIfm"></iframe>
		            </div>
		        </div>
		    </div>
		  </div>
	
	      <script>
	      let grid1;
	      
	      $(document).ready(function() {
	    	// 최초 init
    	    grid1 = GridStack.init({ handle: '.card-title, .star-handle' }, '#grid-stack-first');
			
    	    // 리사이즈 규칙 바인딩
    	    bindResizeRules(grid1);

    	    // 첫 로딩
    	    loadProfDashboard();
    	    
	  		// 이벤트 바인딩
	  		grid1.on('change', function(event, items) {
	  		    changeWidgetSetting(items, 1);
	  		});
    	    
	  		function changeWidgetSetting(items) {
	  		    items.forEach(item => {
	  		        const node = item.gridstackNode || item;
	  		        
	  		        var data = {
	  		            userId: "${userId}",
	  		            widgetId: node.el.querySelector('.card-title')?.id,
	  		            posX: node.x,
	  		            posY: node.y,
	  		            posW: node.w,
	  		            posH: node.h,
	  		            visibleYn: node.visibleYn
	  		        };

	  		        $.ajax({
	  		            url: "/dashboard/changeWidgetSetting.do?sample=2",
	  		            type: "POST",
	  		            data: JSON.stringify(data),
	  		            contentType: "application/json; charset=UTF-8",
	  		            processData: false,
	  		            success: function(res) {
	  		                closeModal();
	  		            },
	  		            error: function(xhr) {
	  		                console.log("실패", xhr.responseText);
	  		            }
	  		        });
	  		    });
	  		}
	   	  });
   	  	
   	 function loadProfDashboard() {
   	  	  var url = "/dashboard/loadProfDashboard.do?sample=2";
   	  	  var data = { "userId": "${vo.userId}" };

   	  	  ajaxCall(url, data, function(res) {
   	  	    if (res.result > 0) {

   	  	      const items1 = res.returnList.map(o => {
   	  	        const courseCard = document.createElement('div');
   	  	        courseCard.className = 'course-card';

   	  	        // 카드 제목
   	  	        const title = document.createElement('div');
   	  	        title.className = 'card-title';
   	  	        title.id = o.widgetId || '';
   	  	        title.textContent = o.widgetName || o.widgetId || '';
   	  	   		/* title.innerHTML = `<i class="fa-solid fa-up-down-left-right" style="margin-right:6px; color:#555;"></i> ${o.widgetName}`; */

   	  	        courseCard.appendChild(title);
   	  	   	
   	  	        // 내용 영역
   	  	        const content = document.createElement('div');
   	  	        content.className = 'card-content';
   	  	        courseCard.appendChild(content);

   	  	        // widgetId별로 내용 채우기
   	  	        fillWidgetContent(o.widgetId, content);

   	  	        // grid wrapper
   	  	        const contentWrapper = document.createElement('div');
   	  	        contentWrapper.className = 'grid-stack-item-content';
   	  	        contentWrapper.appendChild(courseCard);

   	  	        const gridItem = document.createElement('div');
   	  	        gridItem.className = 'grid-stack-item';
   	  	        gridItem.appendChild(contentWrapper);

   	  	        return {
   	  	          x: o.posX,
   	  	          y: o.posY,
   	  	          w: o.posW,
   	  	          h: o.posH,
   	  	          el: gridItem
   	  	        };
   	  	      });

   	  	      grid1.removeAll();
   	  	      grid1.load(items1);

   	  	    } else {
   	  	      alert(res.message);
   	  	    }
   	  	  }, function(xhr, status, error) {
   	  	    alert("<spring:message code='fail.common.msg' />");
   	  	  }, true);
   	  	}

   	  	// 각 위젯별로 다른 내용 넣기
   	  	function fillWidgetContent(widgetId, container) {
   	  	  switch (widgetId) {
   	  	    case 'CARD1': // Today
   	  	      container.innerHTML = `
   	  	      	
   	  	      `;
   	  	      break;
   	  	      
   	  		case 'CARD2': // 이달의 학사일정
 	  	      container.innerHTML = `
 	  	    	
 	  	      `;
 	  	      break;
 	  	      
   	  		case 'CARD3': // 공지사항
 	  	      container.innerHTML = `
 	  	       
 	  	      `;
 	  	      break;

   	  	    case 'CARD4': // 강의 Q&A
   	  	      container.innerHTML = `
   	  	       
   	  	      `;
   	  	      break;

   	  	    case 'CARD5': // 1:1 상담
   	  	      container.innerHTML = `
   	  	       
   	  	      `;
   	  	      break;

   	  		case 'CARD6': // 알림
	  	      container.innerHTML = `
  	          
	  	      `;
	  	      break;
	  	      
   	  	    case 'CARD7': // 강의과목
   	  	      container.innerHTML = `
   	  	        
   	  	      `;
   	  	      break;

   	  	    default:
   	  	      container.innerHTML = '<div class="empty">내용 없음</div>';
   	  	  }
   	  	}

	    
	  	// 위젯 설정 모달
		function widgetSettingModal() {
			$("#widgetSettingForm").attr("target", "widgetSettingIfm");
	        $("#widgetSettingForm").attr("action", "/dashboard/widgetSettingPop2.do");
	        $("#widgetSettingForm").submit();
	        $('#widgetSettingModal').modal('show');
		}
		
	  	$('#widgetSettingIfm').iFrameResize();
	  	
	  	function applyWidgetSettings(hiddenCards) {
	  	  // 전달받은 ID 카드 DOM에서 제거
	  	  hiddenCards.forEach(id => {
	  	    const el = document.getElementById(id);
	  	    if (el) {
	  	      el.closest(".grid-stack-item").remove();
	  	    }
	  	  });
	  	}
	  	
	 	// resizestop 제약 규칙
	    function bindResizeRules(grid) {
	      grid.on('resizestop', function (event, el) {
	        const node = el.gridstackNode;
	        if (!node) return;
	        const cardId = el.querySelector('.card-title')?.id;

	        if (cardId === 'CARD1' || cardId === 'CARD5') {
	          const W = [4, 8, 12], H = [2, 4, 6];
	          snapToAllowed(grid, el, node, W, H);
	        } 
	      });
	    }

	    function snapToAllowed(grid, el, node, allowedW, allowedH) {
	      let closestW = allowedW.reduce((p, c) => Math.abs(c - node.w) < Math.abs(p - node.w) ? c : p);
	      let closestH = allowedH.reduce((p, c) => Math.abs(c - node.h) < Math.abs(p - node.h) ? c : p);
	      if (node.w !== closestW || node.h !== closestH) {
	        grid.update(el, { w: closestW, h: closestH, x: node.x, y: node.y });
	      }
	    }

	    function applyWidgetSettingsParent() {
	      loadProfDashboard();
	    }
	  	
	    </script>
    </div>
  </div>
</body>
<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
</html>