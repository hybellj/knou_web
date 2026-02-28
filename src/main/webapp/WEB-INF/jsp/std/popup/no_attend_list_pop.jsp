<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
	
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
   	<script type="text/javascript">
	   	$(document).ready(function() {
	   		// 주차별 미학습자 목록
	   		noAttentStdList();
	   	});
	   	
	 	// 주차 미학습자 목록
	   	function noAttentStdList() {
			var url  = "/std/stdLect/listNoStudyWeek.do";
			var data = {
				  crsCreCd : '<c:out value="${vo.crsCreCd}" />'
				, lessonScheduleId : '<c:out value="${vo.lessonScheduleId}" />'
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					var html = '';
					
					returnList.forEach(function(v, i) {
						html += '<tr>';
						html += '	<td>';
						html += '		<div class="ui checkbox">';
						html += '			<input type="checkbox" name="userIds" value="' + v.userId + '" user_nm="'+v.userNm+'" mobile="'+v.mobileNo+'" email="'+v.email+'" />';
						html += '		</div>';
						html += '	</td>';
						html += '	<td>' + v.lineNo + '</td>';
						html += '	<td>' + (v.deptNm || '') + '</td>';
						html += '	<td>' + v.userId + '</td>';
						html += '	<td>' + (v.hy || '-') + '</td>';
						html += '	<td>';
						html += 		v.userNm;
						html +=			userInfoIcon("<%=SessionInfo.isKnou(request)%>", "userInfoPop('"+v.userId+"')");
						html += '	</td>';
						html += '	<td>' + v.userNm + '</td>';
						html += '</tr>';
					});
					
					$("#noStudyList").empty().html(html);
		  			$("#noStudyListTable").footable();
		  			$("#noStudyListTable").find(".ui.checkbox").checkbox();
		    	} else {
		    		alert(data.message);
		    	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
		}
	 	
	 	// 수강생 전체 선택
		function checkAll(checked) {
			$.each($('#noStudyList').find("input:checkbox[name=userIds]:not(:disabled)"), function() {
				this.checked = checked;
			});
		}
	 	
		// 수강생 메세지 보내기
		function sendMsg() {
			var rcvUserInfoStr = "";
			var sendCnt = 0;
			
			$.each($('#noStudyList').find("input:checkbox[name=userIds]:not(:disabled):checked"), function() {
				sendCnt++;
				if (sendCnt > 1)
					rcvUserInfoStr += "|";
				rcvUserInfoStr += $(this).val();
				rcvUserInfoStr += ";" + $(this).attr("user_nm");
				rcvUserInfoStr += ";" + $(this).attr("mobile");
				rcvUserInfoStr += ";" + $(this).attr("email");
			});
			
			if (sendCnt == 0) {
				/* 메시지 발송 대상자를 선택하세요. */
				alert("<spring:message code='common.alert.sysmsg.select_user'/>");
				return;
			}
			
			var form = window.parent.alarmForm;
			form.action = '<%=CommConst.SYSMSG_URL_SEND%>';
	        form.target = "msgWindow";
	        form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
	        form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
	        form.onsubmit = window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
	        form.submit();
		}
		
		// 주차 미학습자 엑셀 다운로드
		function downExcel() {
			var excelGrid = {
			    colModel:[
		            {label:'<spring:message code="main.common.number.no" />', name:'lineNo', align:'right', width:'1000'}, // NO
		            {label:'<spring:message code="std.label.dept" />', name:'deptNm', align:'left', width:'5000'}, // 학과
		            {label:'<spring:message code="std.label.user_id" />', name:'userId', align:'center', width:'5000'}, // 학번
		            {label:'<spring:message code="std.label.hy" />', name:'hy', align:'center', width:'2500', defaultValue: "-"}, // 학년
		            {label:'<spring:message code="std.label.name" />', name:'userNm',	align:'left', width:'5000'}, // 이름
	    		]
			};
			
			var url  = "/std/stdLect/downExcelNoStudyWeek.do";
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "excelForm");
			form.attr("action", url);
			form.append($('<input/>', {type: 'hidden', name: 'crsCreCd',    		value: '<c:out value="${vo.crsCreCd}" />'}));
			form.append($('<input/>', {type: 'hidden', name: 'lessonScheduleId', 	value: '<c:out value="${vo.lessonScheduleId}" />'}));
			form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   		value: JSON.stringify(excelGrid)}));
			form.appendTo("body");
			form.submit();
			
			$("form[name=excelForm]").remove();
		}
		
   	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<div id="wrap">
		<div class="info-item-box"> <!-- 아이디에 있던 값을 클래스로 옮김_230314 -->
            <h2 class="page-title">•&nbsp;<c:out value="${lessonScheduleVO.lessonScheduleOrder}" /><spring:message code="std.label.lesson_schedule" /><!-- 주차 -->&nbsp;<spring:message code="std.label.nostudy_student" /><!-- 미학습자 --></h2>
            <div class="button-area">
                <a href="javascript:void(0)" onclick="downExcel()" class="ui basic button"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></a>
				<uiex:msgSendBtn func="sendMsg()" styleClass="ui basic button"/><!-- 메시지 -->
            </div>
        </div>
        
        <div class="ui form">
        	<div style="max-height: 390px; overflow: auto;">
				<table id="noStudyListTable" class="table type2" data-sorting="true" data-paging="false" data-empty="<spring:message code="common.content.not_found" />">
					<thead>
						<tr>
							<th scope="col" data-sortable="false" class="chk">
	                            <div class="ui checkbox">
	                                <input type="checkbox" onchange="checkAll(this.checked)" />
	                            </div>
	                        </th>
							<th scope="col" data-type="number" class="num" data-sortable="false" data-breakpoints="xs"><spring:message code="main.common.number.no" /><!-- NO. --></th>
							<th scope="col" data-breakpoints="xs"><spring:message code="std.label.dept" /><!-- 학과 --></th>
							<th scope="col"><spring:message code="std.label.user_id" /><!-- 학번--></th>
							<th scope="col"><spring:message code="std.label.hy" /><!-- 학년--></th>
							<th scope="col"><spring:message code="std.label.name" /><!-- 이름 --></th>
						</tr>
					</thead>
					<tbody id="noStudyList">
						<!-- 
						<tr>
							<td>
								<div class="ui checkbox">
									<input type="checkbox" name="" value="" />
								</div>
							</td>
							<td>1</td>
							<td>Oooo학과</td>
							<td>2021215478</td>
							<td>학습자01</td>
						</tr>
						 -->
					</tbody>
				</table>
			</div>
        </div>
		
		<div class="bottom-content">
			<button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>