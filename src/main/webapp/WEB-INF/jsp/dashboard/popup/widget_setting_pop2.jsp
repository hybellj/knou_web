<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
	
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
   	
<style>
    body {
      font-family: Arial, sans-serif;
    }
    .container {
      display: flex;
      gap: 20px;
      padding: 20px;
      border: 1px solid #ddd;
      border-radius: 8px;
    }
    .section {
      flex: 1;
    }
    .section h3 {
      margin-bottom: 10px;
      font-size: 14px;
    }
    .checkbox-group label, 
    .radio-group label {
      display: block;
      margin-bottom: 6px;
      font-size: 14px;
    }
    .footer {
      text-align: center;
      margin-top: 10px;
      font-size: 13px;
      color: #555;
    }
    .buttons {
      text-align: center;
      margin-top: 15px;
    }
    .buttons button {
      padding: 6px 14px;
      margin: 0 5px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 14px;
    }
    .buttons .save {
      background-color: #007bff;
      color: white;
    }
    .buttons .cancel {
      background-color: #ccc;
    }
    
  </style>
<script type="text/javascript">
  	var WIDGET_SETTING_LIST = [];
  		
   	$(document).ready(function() {
		widgetSetting();
		widgetSettingColor();
   	});
   	
   	function popLectEvalModal() {
   		setCookie("popLectEvalYn", "Y", 1); // 1일
   		window.parent.closeModal();
   	}
   	
   	function widgetSetting() {
		// 과제 유형에 따라 분기
        var url = "/dashboard/widgetSettingChk.do";
		var data = {
			"userId" 	  : "${vo.userId}"
		};
		
		ajaxCall(url, data, function(data) {
		    if (data.result > 0) {
		    	var html = "";
		    	
        			html +="<label>"
			    	html +="  <input type='checkbox' " + "id='" + data.data.widgetId1 + "' " + "name='" + data.data.widgetId1 + "' " + "data-posx='" + data.data.posX1 + "' " + "data-posy='" + data.data.posY1 + "' " + "data-posw='" + data.data.posW1 + "' " + "data-posh='" + data.data.posH1 + "' " + "data-visible-yn='" + data.data.visibleYn1 + "' " + "data-widget-name='" + data.data.widgetName1 + "'> Today";
					html +="</label>"
 					html +="<label>"
 					html +="  <input type='checkbox' " + "id='" + data.data.widgetId2 + "' " + "name='" + data.data.widgetId2 + "' " + "data-posx='" + data.data.posX2 + "' " + "data-posy='" + data.data.posY2 + "' " + "data-posw='" + data.data.posW2 + "' " + "data-posh='" + data.data.posH2 + "' " + "data-visible-yn='" + data.data.visibleYn2 + "' " + "data-widget-name='" + data.data.widgetName2 + "'> 이달의 학사일정";
					html +="</label>"
					html +="<label>"
					html +="  <input type='checkbox' " + "id='" + data.data.widgetId3 + "' " + "name='" + data.data.widgetId3 + "' " + "data-posx='" + data.data.posX3 + "' " + "data-posy='" + data.data.posY3 + "' " + "data-posw='" + data.data.posW3 + "' " + "data-posh='" + data.data.posH3 + "' " + "data-visible-yn='" + data.data.visibleYn3 + "' " + "data-widget-name='" + data.data.widgetName3 + "'> 공지사항";
					html +="</label>"
					html +="<label>"
					html +="  <input type='checkbox' " + "id='" + data.data.widgetId4 + "' " + "name='" + data.data.widgetId4 + "' " + "data-posx='" + data.data.posX4 + "' " + "data-posy='" + data.data.posY4 + "' " + "data-posw='" + data.data.posW4 + "' " + "data-posh='" + data.data.posH4 + "' " + "data-visible-yn='" + data.data.visibleYn4 + "' " + "data-widget-name='" + data.data.widgetName4 + "'> 강의Q&amp;A";
					html +="</label>"
					html +="<label>"
					html +="  <input type='checkbox' " + "id='" + data.data.widgetId5 + "' " + "name='" + data.data.widgetId5 + "' " + "data-posx='" + data.data.posX5 + "' " + "data-posy='" + data.data.posY5 + "' " + "data-posw='" + data.data.posW5 + "' " + "data-posh='" + data.data.posH5 + "' " + "data-visible-yn='" + data.data.visibleYn5 + "' " + "data-widget-name='" + data.data.widgetName5 + "'> 1:1상담";
					html +="</label>"
					html +="<label>"
					html +="  <input type='checkbox' " + "id='" + data.data.widgetId6 + "' " + "name='" + data.data.widgetId6 + "' " + "data-posx='" + data.data.posX6 + "' " + "data-posy='" + data.data.posY6 + "' " + "data-posw='" + data.data.posW6 + "' " + "data-posh='" + data.data.posH6 + "' " + "data-visible-yn='" + data.data.visibleYn6 + "' " + "data-widget-name='" + data.data.widgetName6 + "'> 알림";
					html +="</label>"
					html +="<label>"
					html +="  <input type='checkbox' " + "id='" + data.data.widgetId7 + "' " + "name='" + data.data.widgetId7 + "' " + "data-posx='" + data.data.posX7 + "' " + "data-posy='" + data.data.posY7 + "' " + "data-posw='" + data.data.posW7 + "' " + "data-posh='" + data.data.posH7 + "' " + "data-visible-yn='" + data.data.visibleYn7 + "' " + "data-widget-name='" + data.data.widgetName7 + "'> 강의과목";
					html +="</label>"
				    
		        	$(".checkbox-group").empty().append(html);

			    	$(".table").footable();
			    	$('.ui.rating').rating({interactive : false});
			    	
			    	for (var i = 1; i <= 7; i++) {
			    	    var key = "visibleYn" + i;
			    	    var widgetId = data.data.widgetId1.slice(0, -1);
			    	    
			    	    if (data.data[key] === 'Y') {
			    	        $("#"+ widgetId + i).prop("checked", true);
			    	    }
			    	}
		    } else {
		        alert(data.message);
		    }
		}, function(xhr, status, error) {
		    alert("<spring:message code='fail.common.msg' />");
		}, true);
	}
   	
   	function widgetSettingColor() {
		// 과제 유형에 따라 URL 분기(개인, 팀)
        var url = "/dashboard/widgetSettingColor.do";
		var data = {};
		
		ajaxCall(url, data, function(data) {
		    if (data.result > 0) {
		    	var html = "";
				    html +="<label>"
				    html +="  <input type='radio' id='color1' name='color'> 기본</label>"
			        html +="<label>"
			        html +="  <input type='radio' id='color2' name='color'> 블루</label>"
			        html +="<label>"
			        html +="  <input type='radio' id='color3' name='color'> 민트</label>"
			        html +="<label>"
			        html +="  <input type='radio' id='color4' name='color'> 오렌지</label>"
			        html +="<label>"
			        html +="  <input type='radio' id='color5' name='color'> 레드</label>"
			        html +="<label>"
			        html +="  <input type='radio' id='color6' name='color'> 퍼플</label>"
					      
		        	$(".radio-group").empty().append(html);

			    	$(".table").footable();
			    	$('.ui.rating').rating({interactive : false});
			    	
		    	    if (data.data.color === 'COLOR1') {
		    	        $("#color1").prop("checked", true);
		    	    } else if (data.data.color === 'COLOR2') {
		    	    	$("#color2").prop("checked", true);
		    	    } else if (data.data.color === 'COLOR3') {
		    	    	$("#color3").prop("checked", true);
		    	    } else if (data.data.color === 'COLOR4') {
		    	    	$("#color4").prop("checked", true);
		    	    } else if (data.data.color === 'COLOR5') {
		    	    	$("#color5").prop("checked", true);
		    	    } else if (data.data.color === 'COLOR6') {
		    	    	$("#color6").prop("checked", true);
		    	    }
		    } else {
		        alert(data.message);
		    }
		}, function(xhr, status, error) {
		    alert("<spring:message code='fail.common.msg' />");
		}, true);
	}
   	
   	function setCookie(name, value, days) {
	    var expires = "";
	    if (days) {
	        var date = new Date();
	        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
	        expires = "; expires=" + date.toUTCString();
	    }
	    document.cookie = name + "=" + value + expires + "; path=/";
	}
	
	function closeModal() {
	    // 부모 모달 닫기
	    window.parent.$('#widgetSettingModal').modal('hide');
	    // 부모 대시보드 리로드
	    window.parent.applyWidgetSettingsParent();
	}
	
	function saveWidgetSetting() {
	  var widgets = [];
	  
	  // 1. 체크박스
	  $(".checkbox-group input[type='checkbox']").each(function() {
		  let widget = {
		    widgetId:   $(this).attr("id"),
		    widgetName: $(this).data("widgetName"),
		    posX:       $(this).data("posx"),
		    posY:       $(this).data("posy"),
		    posW:       $(this).data("posw"),
		    posH:       $(this).data("posh"),
		    visibleYn:  $(this).is(":checked") ? "Y" : "N"
		  };

		  widgets.push(widget);
	  });

	  // 2. 라디오 버튼 값 수집
	  var selectedColor = $(".radio-group input[type='radio']:checked").attr("id");
	  
	  // 3. JSON 데이터 구성
	  var data = {
	    widgets: widgets,
	    color: selectedColor,
	    userId: "${vo.userId}"
	  };

	  // 4. AJAX 전송
	  $.ajax({
	    url: "/dashboard/saveWidgetSetting2.do",
	    type: "POST",
	    data: JSON.stringify(data),
	    contentType: "application/json; charset=utf-8",
	    dataType: "json",
	    success: function(result) {
	    	
	    switch (selectedColor) {
	        case "color1":
	            document.body.style.backgroundColor = "red";  // 바디 배경을 빨간색으로
	            break;
	        case "color2":
	        	alert("1")
	        	document.body.style.backgroundColor = "red";  // 바디 배경을 빨간색으로
	            break;
	        case "color3":
	        	document.body.style.backgroundColor = "red";  // 바디 배경을 빨간색으로
	            break;
	        case "color4":
	        	document.body.style.backgroundColor = "red";  // 바디 배경을 빨간색으로
	            break;
	        case "color5":
	        	document.body.style.backgroundColor = "red";  // 바디 배경을 빨간색으로
	            break;
	        case "color6":
	            baseScore = 60;
	            break;
	        default:
	            break;
	    }

	      alert("변경사항이 저장되었습니다.");
	      console.log("서버 응답:", result);
	      closeModal();
	    },
	    error: function(xhr, status, error) {
	      console.error("저장 실패:", error);
	      alert("저장 중 오류가 발생했습니다.");
	    }
	  });
	}
</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
        <div class="ui form">
			<div class="container">
			  <!-- 위젯 선택 -->
			  <div class="section">
			    <h3>사용할 위젯을 선택하세요</h3>
			    
			    <div class="checkbox-group">
				</div>
			  </div>
			
			  <!-- 컬러 선택 -->
			  <div class="section">
			    <h3>컬러를 선택하세요</h3>
			    <div class="radio-group">
			    </div>
			  </div>
			</div>
			
			<div class="footer">
			  드래그하여 위젯을 원하는 위치로 이동하세요.
			</div>
			
			<div class="buttons">
			  <button class="save" onclick="saveWidgetSetting()">저장</button>
			  <button class="cancel" onclick="closeModal()">취소</button>
			</div>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>