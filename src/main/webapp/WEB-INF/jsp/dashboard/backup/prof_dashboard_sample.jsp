<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/main_default_sample.css?v=3" />
<link rel="stylesheet" type="text/css" href="/webdoc/css/gridstack.min.css" />
<script src="/webdoc/js/gridstack-all.js"></script>

<%@ include file="/WEB-INF/jsp/common/frontGnb_sample.jsp" %>
	
<style>
header.common {
  background-color: #ffffff;
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
          
          <a href="javascript:void(0)" class="ui bcWhite button mb5" onclick="widgetSettingModal()"><spring:message code="common.button.widgetSetting" /></a><!-- 위젯 설정 -->
	        
	      <div class="grid-stack" id="grid-stack-first">
		  </div>
	
		  <div class="grid-stack-all">
		      <div class="grid-stack" id="grid-stack-second">
		      </div>
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
	      let grid1, grid2;
	   
	      $(document).ready(function() {
	    	// 최초 init
    	    grid1 = GridStack.init({ handle: '.card-title, .star-handle' }, '#grid-stack-first');
    	    grid2 = GridStack.init({ handle: '.card-title, .star-handle' }, '#grid-stack-second');
			
    	    // 리사이즈 규칙 바인딩
    	    bindResizeRules(grid1);
    	    bindResizeRules(grid2);

    	    // 첫 로딩
    	    loadProfDashboard();
    	    
    	    // 특정 이벤트 감지
  		    
	  		// 이벤트 바인딩
	  		grid1.on('change', function(event, items) {
	  		    changeWidgetSetting(items, 1);
	  		});
	  		grid2.on('change', function(event, items) {
	  			changeWidgetSetting(items, 2);
	  		});
    	    
	  		function changeWidgetSetting(items, gridLv) {
	  		    items.forEach(item => {
	  		        const node = item.gridstackNode || item;
	  		        
	  		        var data = {
	  		            userId: "${userId}",
	  		            widgetId: node.el.querySelector('.card-title')?.id,
	  		            posX: node.x,
	  		            posY: node.y,
	  		            posW: node.w,
	  		            posH: node.h,
	  		            visibleYn: node.visibleYn,
	  		            gridLv: gridLv
	  		        };

	  		        $.ajax({
	  		            url: "/dashboard/changeWidgetSetting.do",
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

	    	var url = "/dashboard/loadProfDashboard.do";
    	    var data = { "userId": "${vo.userId}" };
    	    
    	    ajaxCall(url, data, function(res) {
   	    	  if (res.result > 0) {
			  
   	    		const items1 = res.returnList.map(o => {
   	    		  // 카드 안쪽 내용
   	    		  const courseCard = document.createElement('div');
   	    		  courseCard.className = 'course-card';

   	    		  const inner = document.createElement('div');
   	    		  inner.className = 'card-title';
   	    		  inner.id = o.widgetId || '';
   	    		  inner.textContent = o.widgetName || o.widgetId || '';

   	    		  courseCard.appendChild(inner);

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
    	      
    	      const items2 = res.returnListSub.map(o => {
    	    	  // 카드 안쪽 내용
    	    	  const courseCard = document.createElement('div');
    	    	  courseCard.className = 'course-card';

    	    	  const inner = document.createElement('div');
    	    	  inner.className = 'card-title';
    	    	  inner.id = o.widgetId || '';
    	    	  inner.textContent = o.widgetName || o.widgetId || '';

    	    	  courseCard.appendChild(inner);

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

    	    	grid2.removeAll();
    	    	grid2.load(items2);

   	    	  } else {
   	    	    alert(res.message);
   	    	  }
   	    	}, function(xhr, status, error) {
   	    	  alert("<spring:message code='fail.common.msg' />");
   	    	}, true);
   	  	}
	      
	  	// 위젯 설정 모달
		function widgetSettingModal() {
			var crsCreCd = '<c:out value="${crsCreCd}" />';
	
			$("#widgetSettingForm > input[name='crsCreCd']").val(crsCreCd);
			$("#widgetSettingForm").attr("target", "widgetSettingIfm");
	        $("#widgetSettingForm").attr("action", "/dashboard/widgetSettingPop.do");
	        $("#widgetSettingForm").submit();
	        $('#widgetSettingModal').modal('show');
	
	        $("#widgetSettingForm > input[name='crsCreCd']").val("");
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
	        } else if (cardId === 'CARD7') {
	          const W = [3, 6, 9, 12], H = [3, 6];
	          snapToAllowed(grid, el, node, W, H);
	        } else if (cardId === 'CARD8') {
	          const W = [3, 6], H = [3, 6];
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