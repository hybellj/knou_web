<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
   	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<%@ include file="/WEB-INF/jsp/seminar/common/seminar_common_inc.jsp" %>
	<script type="text/javascript" src="/webdoc/js/iframe.js"></script>
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
	<script type="text/javascript">
		var IGNORE_ALERT = false;
		
		$(document).ready(function() {
			viewAtnd();
			listHsty();
		});
		
		// 세미나 출결 정보 조회
		function viewAtnd() {
			var url  = "/seminar/seminarHome/seminarStdView.do";
			var data = {
				"stdNo" 	: "${atndVO.stdNo}",
				"seminarId"	: "${seminarVO.seminarId}"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var html = "";
					var returnVO = data.returnVO;
					var seminarStatus = "${seminarVO.seminarStatus}";
					
					if(returnVO != null) {
						html += "<tr>";
						html += "	<td class='tc'>" + dateFormat("date", returnVO.atndDttm)+ " </td>";
						html += "	<td class='tc'>" + dateFormat("timePad", returnVO.seminarTime) + "</td>";
						html += "	<td class='tc'>" + dateFormat("time", returnVO.atndTime) + "</td>";
						html += "	<td class='tc'>" + returnVO.seminarStatus + "</td>";
						html += "	<td class='tc'>" + attendFormat("suspense", returnVO.atndCd) + "</td>";
						html += "	<td class='tc'>";
						if(seminarStatus == "완료") {
							html += "	<a href='javascript:seminarAttendSet(\"ATTEND\")' class='ui small blue button'><spring:message code='seminar.label.attend' /></a>";/* 출석 */
							html += "	<a href='javascript:seminarAttendSet(\"LATE\")' class='ui small grey button'><spring:message code='seminar.label.late' /></a>";/* 지각 */
							html += "	<a href='javascript:seminarAttendSet(\"ABSENT\")' class='ui small red button'><spring:message code='seminar.label.absent' /></a>";/* 결석 */
						} else {
							html += "	-";
						}
						html += "	</td>";
						html += "</tr>";
						$("#seminarAtndId").val(returnVO.seminarAtndId);
					}
					
					$("#seminarAtndList").empty().html(html);
					$("#seminarAtndTable").footable();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='seminar.error.info' />");/* 정보 조회 중 에러가 발생하였습니다. */
			});
		}
		
		// 출결 상태 변경 이력 조회
		function listHsty() {
			var url  = "/seminar/seminarHome/seminarStdAttendLog.do";
			var data = {
				"stdNo" 	: "${atndVO.stdNo}",
				"seminarId"	: "${seminarVO.seminarId}"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var returnList = data.returnList || [];
					var html = "";
					
					returnList.forEach(function(v, i) {
						html += "<tr>";
						html += "	<td class='tc'>"+v.deviceTypeCd+"</td>";
						html += "	<td class='tc'>"+v.regIp+"</td>";
						html += "	<td class='tc'>"+dateFormat("date", v.startDttm)+"</td>";
						html += "	<td class='tc'>"+dateFormat("date", v.endDttm)+"</td>";
						html += "	<td class='tc'>"+dateFormat("time", v.atndTime)+"</td>";
						html += "	<td class='tc'><spring:message code='seminar.label.attend.status.change' /> : "+attendFormat("suspense", v.atndCd)+"</td>";/* 출결상태 변경 */
						html += "</tr>";
					});
					
					$("#seminarLogList").empty().html(html);
					$("#seminarLogTable").footable();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='seminar.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
			});
		}
		
		// 출결 상태 변경
		function seminarAttendSet(type) {
			if("${seminarVO.seminarCtgrCd}" == "online") {
				if("${seminarVO.attProcYn}" == "N") {
					alert("<spring:message code='seminar.alert.first.zoom.attend' />");/* Zoom 출결확정 후 출결상태를 변경하실 수 있습니다. */
					return false;
				}
			}
			
			if(type == "ATTEND" && !$.trim($("#atndMemo").val())) {
				alert("<spring:message code='seminar.message.empty.attent.reason' />"); // 출석인정 사유를 입력하세요.
				return;
			}
			
			var attendStdList = "${atndVO.userId}|${atndVO.stdNo}|"+type+"|"+$("#seminarAtndId").val();
			$("#seminarAttendForm input[name='attendStdList']").val(attendStdList);
			
			var url  = "/seminar/seminarHome/seminarAtndEdit.do";
			var data = $("#seminarAttendForm").serialize();
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					alert("<spring:message code='seminar.alert.change.attend.status' />");/* 출결상태 변경이 완료되었습니다. */
					IGNORE_ALERT = true;
					saveMemoCheck();
					viewAtnd();
					listHsty();
					window.parent.listStd();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='seminar.error.change.attend.status' />");/* 출결상태 변경 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
			}, true);
			
		}
		
		// 부가정보 저장
		function saveMemoCheck() {
			var attendStdList = "${atndVO.userId}|${atndVO.stdNo}|"+$("#seminarAtndId").val();
			$("#seminarAttendForm input[name='attendStdList']").val(attendStdList);
			
			// 파일이 있으면 업로드 시작
			var fileUploader = dx5.get("fileUploader");
			if (fileUploader.getFileCount() > 0) {
				fileUploader.startUpload();
			} else {
				saveMemo();
			}
		}
		
		function finishUpload(){
			var fileUploader = dx5.get("fileUploader");
			var url = "/file/fileHome/saveFileInfo.do";
	    	var data = {
	    		"uploadFiles" : fileUploader.getUploadFiles(),
	    		"copyFiles"   : fileUploader.getCopyFiles(),
	    		"uploadPath"  : fileUploader.getUploadPath()
	    	};
	    	
	    	ajaxCall(url, data, function(data) {
	    		if(data.result > 0) {
	    			$("#seminarAttendForm input[name='uploadFiles']").val(fileUploader.getUploadFiles());
	    			$("#seminarAttendForm input[name='copyFiles']").val(fileUploader.getCopyFiles());
	    			$("#seminarAttendForm input[name='uploadPath']").val(fileUploader.getUploadPath());
	    		   	
	    			saveMemo();
	    		} else {
	    			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    		}
	    	}, function(xhr, status, error) {
	    		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    	});
		}
		
		function saveMemo() {
			var url  = "/seminar/seminarHome/seminarAtndMemoEdit.do";
			var data = $("#seminarAttendForm").serialize();
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					// 성공적으로 작업을 완료하였습니다.
					if(!IGNORE_ALERT) {
						alert('<spring:message code="common.result.success" />');
					}
					
					var form = $("<form></form>");
					form.attr("method", "POST");
					form.attr("name", "bbsForm");
					form.attr("action", "/seminar/seminarHome/seminarAttendStatPop.do");
					form.append($("<input/>", {type: "hidden", name: "stdNo", value: "${atndVO.stdNo}"}));
					form.append($("<input/>", {type: "hidden", name: "crsCreCd", value: "${creCrsVO.crsCreCd}"}));
					form.append($("<input/>", {type: "hidden", name: "seminarId", value: "${seminarVO.seminarId}"}));
					form.appendTo("body");
					form.submit();
					
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				// 에러가 발생했습니다!
				alert('<spring:message code="fail.common.msg" />');
			}, true);
		}
	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<input type="hidden" id="seminarAtndId" value="${atndVO.seminarAtndId}" />
	<div id="wrap">
       	<div class="option-content">
            <h2 class="page-title">${creCrsVO.crsCreNm } (${creCrsVO.declsNo }<spring:message code="seminar.label.decls" /><!-- 반 -->)</h2>
            <div class="mla fcBlue">
            	<b>${atndVO.deptNm } ${atndVO.userId } ${atndVO.userNm }</b>
            </div>
       	</div>
       	<div class="mt20">
       		<fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss" value="${seminarVO.seminarStartDttm }" />
			<fmt:formatDate var="seminarStartDttm" pattern="yyyy.MM.dd(HH:mm)" value="${startDateFmt }" />
			<fmt:parseDate var="endDateFmt" pattern="yyyyMMddHHmmss" value="${seminarVO.seminarEndDttm }" />
			<fmt:formatDate var="seminarEndDttm" pattern="yyyy.MM.dd(HH:mm)" value="${endDateFmt }" />
       		<h2><c:if test="${not empty seminarVO.lessonScheduleOrder }">${seminarVO.lessonScheduleOrder }<spring:message code="seminar.label.schedule" /><!-- 주차 --> | </c:if>${seminarVO.seminarNm }</h2>
       		<p><spring:message code="seminar.label.seminar.dttm" /><!-- 세미나 기간 --> : ${seminarStartDttm } ~ ${seminarEndDttm }</p>
       	</div>
       	<table class="table mt20" data-sorting="false" data-paging="false" data-empty="<spring:message code='seminar.common.empty' />" id="seminarAtndTable"><!-- 등록된 내용이 없습니다. -->
       		<thead>
       			<tr>
       				<th class="tc"><spring:message code="seminar.label.part.date" /><!-- 참여일시 --></th>
       				<th class="tc"><spring:message code="seminar.label.study.time" /><!-- 학습시간 --></th>
       				<th class="tc"><spring:message code="seminar.label.atnd.time" /><!-- 참여시간 --></th>
       				<th class="tc"><spring:message code="seminar.label.study.status" /><!-- 학습현황 --></th>
       				<th class="tc"><spring:message code="seminar.label.attend.situation" /><!-- 출결상태 --></th>
       				<th class="tc"><spring:message code="seminar.label.attend.status.change" /><!-- 출결상태 변경 --></th>
       			</tr>
       		</thead>
       		<tbody id="seminarAtndList">
       		</tbody>
       	</table>
       	<h2><spring:message code="seminar.label.attend.status.change.hsty" /><!-- 출결 상태 변경이력 --></h2>
       	<table class="table mt20" data-sorting="false" data-paging="false" data-empty="<spring:message code='seminar.common.empty' />" id="seminarLogTable"><!-- 등록된 내용이 없습니다. -->
       		<thead>
       			<tr>
       				<th class="tc"><spring:message code="seminar.label.device" /><!-- 디바이스 --></th>
       				<th class="tc"><spring:message code="user.title.manage.userinfo.conn.ip" /><!-- 접속IP --></th>
       				<th class="tc"><spring:message code="seminar.label.start.date" /><!-- 시작일시 --></th>
       				<th class="tc"><spring:message code="seminar.label.end.date" /><!-- 종료일시 --></th>
       				<th class="tc"><spring:message code="seminar.label.atnd.time" /><!-- 참여시간 --></th>
       				<th class="tc"><spring:message code="seminar.label.attend.type" /><!-- 출결구분 --></th>
       			</tr>
       		</thead>
       		<tbody id="seminarLogList">
       		</tbody>
       	</table>
       	<form id="seminarAttendForm" name="seminarAttendForm">
       		<div class="option-content mb10">
	       		<h3 class="mt10"><spring:message code="seminar.label.attent.reason" /><!-- 출석인정 사유 및 증빙 첨부 --></h3>
	       		<div class="flex-left-auto">
	       			<button type="button" class="ui icon blue button" onclick="saveMemoCheck()"><spring:message code="socre.save.button" /></button><!-- 저장 -->
	       		</div>
	       	</div>
	       	<div class="ui input fluid">
	       		<input type="text" id="atndMemo" name="atndMemo" placeholder="<spring:message code="seminar.message.empty.attent.reason" />" value="${atndVO.atndMemo}" /><!-- 메모입력 -->
	       	</div>
	       	<div class="mt10">
	       			<input type="hidden" name="seminarId" value="${seminarVO.seminarId}" />
	       			<input type="hidden" name="seminarAtndId" value="${atndVO.seminarAtndId}" />
	       			<input type="hidden" name="attendStdList" value="" />
	       			<input type="hidden" name="uploadPath" />
					<input type="hidden" name="uploadFiles" />
					<input type="hidden" name="copyFiles" />
					
	       			<!-- 파일업로더 -->
					<uiex:dextuploader
						id="fileUploader"
						path="/seminar/${seminarVO.seminarId}"
						limitCount="3"
						limitSize="100"
						oneLimitSize="100"
						listSize="2"
						finishFunc="finishUpload()"
						useFileBox="false"
						allowedTypes="*"
					/>
	       	</div>
       	</form>
       	<c:if test="${(not empty fileList and fileList.size() > 0)}">
       	<div class="flex_1 mr5 ui segment">
			<ul>
       	<c:forEach items="${fileList}" var="row">
			<li class="mb5 opacity7 file-txt">
				<a href="javascript:void(0)" class="btn border0" onclick="fileDown('<c:out value="${row.fileSn}" />', '<c:out value="${row.repoCd }" />')">
					<i class="xi-download mr3"></i><c:out value="${row.fileNm}" /> (<c:out value="${row.fileSizeStr}" />)
				</a>
			</li>
		</c:forEach>
			</ul>
		</div>
		</c:if>
		<div class="bottom-content">
		    <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="seminar.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
