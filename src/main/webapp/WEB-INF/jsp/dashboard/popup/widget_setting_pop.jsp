<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
	
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
   	
   	<script type="text/javascript">
   		var WIDGET_SETTING_LIST = [];
   		
	   	$(document).ready(function() {
	   		
			listWidgetSettingUser();
	   	});
	   	
	   	function popLectEvalModal() {
	   		setCookie("popLectEvalYn", "Y", 1); // 1일
	   		window.parent.closeModal();
	   	}
	   	
	   	function listWidgetSettingUser() {
			// 과제 유형에 따라 URL 분기(개인, 팀)
	        var url = "/dashboard/widgetSettingPopList.do";
			var data = {
				"userId" 	  : "${vo.userId}"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					WIDGET_SETTING_LIST = data.returnList;
	        		var html = "";
	        		WIDGET_SETTING_LIST.forEach(function(o, i) {
	        			var widOdr = (i + 1);
	        		    html += "<tr>";
	        		    html += "  <td id='" + o.widgetId + "'>" + o.widgetId + "</td>";
	        		    html += "  <td>" + o.widgetName + "</td>";
	        		    html += "  <td>" + o.posX + "</td>";
	        		    html += "  <td>" + o.posY + "</td>";
	        		    html += "  <td>" + o.posW + "</td>";
	        		    html += "  <td>" + o.posH + "</td>";
	        		    html += "  <td>" + o.gridLv + "</td>";
	        		    html += "	<td class='img-button'><button type='button' class='icon_cancel' onclick='delWidgetSetting(\"" + o.userId + "\", \"" + o.widgetId + "\", \"" + o.posX + "\", \"" + o.posY + "\", \"" + o.posW + "\", \"" + o.posH + "\", \"" + o.visibleYn + "\", \"" + o.gridLv + "\")'></button></td> ";
	        		    html += "</tr>";
	        		});

	        		$("#widgetSettingPopList").empty().append(html);

			    	$(".table").footable();
			    	$('.ui.rating').rating({interactive : false});
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
	   	
	 	// 삭제 버튼
	   	function delWidgetSetting(userId, widgetId, posX, posY, posW, posH, visibleYn, gridLv) {
	   	    var url = "/dashboard/delWidgetSetting.do";
	   	    
	   	    var data = {
	   	        "userId"   : userId,
	   	        "widgetId" : widgetId,
	   	        "posX"     : posX,
	   	        "posY"     : posY,
	   	        "posW"     : posW,
	   	        "posH"     : posH,
	   	        "gridLv"   : gridLv
	   	    };
	   	    
	   	    ajaxCall(url, data, function(data) {
	   	        if (data.result > 0) {
	   	            listWidgetSettingUser();
	   	            
	   	            // 부모창 UI에서도 바로 제거
	   	            window.parent.applyWidgetSettings([widgetId]); 

	   	        } else {
	   	            alert(data.message);
	   	        }
	   	    }, function(xhr, status, error) {
	   	        alert("<spring:message code='fail.common.msg' />");
	   	    }, true);
	   	}
		
		function addWidgetSetting() {
			
	        var url = "/dashboard/widgetSettingNextId.do";
			var data = {
				"userId" 	  : "${vo.userId}"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var html = "";
	        		html += "<tr data-new='true'>";   // 신규 행 표시
	    		    html += "  <td><input type='text' name='widgetId'></td>";
	    		    html += "  <td><input type='text' name='widgetName'></td>";
	    		    html += "  <td><input type='text' name='posX'></td>";
	    		    html += "  <td><input type='text' name='posY'></td>";
	    		    html += "  <td><input type='text' name='posW'></td>";
	    		    html += "  <td><input type='text' name='posH'></td>";
	    		    html += "  <td><input type='text' name='gridLv'></td>";
	    		    html += "  <td class='img-button'><button type='button' class='icon_cancel' onclick='$(this).closest(\"tr\").remove()'></button></td>";
	    		    html += "</tr>";

	    		    $("#widgetSettingPopList").append(html);

			    	$(".table").footable();
			    	$('.ui.rating').rating({interactive : false});
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");
			}, true);
			
		    var html = "";
		}

		function saveWidgetSetting() {
		    var widgets = [];
			
		    $("#widgetSettingPopList tr").each(function() {
		        if ($(this).attr("data-new") === "true") {   // 신규만
		            var widget = {
		        		userId: "${vo.userId}",
		                widgetId:  $(this).find("input[name=widgetId]").val(),
		                widgetName:  $(this).find("input[name=widgetName]").val(),
		                posX:      $(this).find("input[name=posX]").val(),
		                posY:      $(this).find("input[name=posY]").val(),
		                posW:      $(this).find("input[name=posW]").val(),
		                posH:      $(this).find("input[name=posH]").val(),
		                gridLv:    $(this).find("input[name=gridLv]").val()
		            };

		            if (widget.widgetId) {
		                widgets.push(widget);
		            }
		        }
		    });

		    var data = {
		        userId: "${vo.userId}",   // 서버에서 세션 유저 넘버 바인딩
		        widgets: widgets
		    };
		    
		    $.ajax({
		        url: "/dashboard/saveWidgetSetting.do",
		        type: "POST",
		        data: JSON.stringify(data),
		        contentType: "application/json; charset=UTF-8",
		        processData: false,
		        success: function(res) {
		            alert("저장되었습니다.");
		            
		            closeModal();
		            
		        },
		        error: function(xhr) {
		            console.log("실패", xhr.responseText);
		        }
		    });
		}
		
		function closeModal() {
		    // 부모 모달 닫기
		    window.parent.$('#widgetSettingModal').modal('hide');
		    // 부모 대시보드 리로드
		    window.parent.applyWidgetSettingsParent();
		}
   	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
        <div class="ui form">
			<table class="tBasic">
				<thead>
					<tr>
	        			<th>위젯 ID</th>
	        			<th>위젯 명</th>
	        			<th>X</th>
	        			<th>Y</th>
	        			<th>W</th>
	        			<th>H</th>
	        			<th>LV</th>
	        			<th>삭제</th>
	        		</tr>
				</thead>
				<tbody id="widgetSettingPopList">
				</tbody>
			</table>
		</div>
		<div class="bottom-content tc">
			<button class="ui black button" type="button" onclick="addWidgetSetting()"><spring:message code="common.button.add" /><!-- 추가 --></button>
			<button class="ui black button" type="button" onclick="saveWidgetSetting()"><spring:message code="common.button.save" /><!-- 저장 --></button>
			<button class="ui black button" type="button" onclick="closeModal()"><spring:message code="common.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>