<%@page import="knou.framework.util.SessionUtil"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.2/rollups/aes.js"></script>
<script type="text/javascript">
	window.closeModal = function() {
	    $('.modal').modal('hide');
	};

	// 모달 생성
	function initModal(type) {
		$("#seminarPop").remove();
		var typeMap = {
			"copy"       : "<spring:message code='seminar.button.prev.seminar.copy' />",/* 이전 세미나 가져오기 */
			"stdStat"    : "<spring:message code='seminar.label.student.study.status' />",/* 수강생 학습 현황 */
			"attendStat" : "<spring:message code='seminar.label.attend.detail.log' />",/* 출결 상세 이력 및 출결관리 */
			"selfEmail"	 : "<spring:message code='seminar.label.self.email.input' />",/* 화상회의 이메일 주소 직접 입력 후 참가하기 */
			"recordView" : "<spring:message code='seminar.button.record.view' />",/* 녹화영상 보기 */
			"attendList" : "<spring:message code='seminar.label.zoom.attend.log' />"/* ZOOM 참석로그 보기 */
		};
		var html  = "<div class='modal fade' id='seminarPop' tabindex='-1' role='dialog' aria-labelledby='"+typeMap[type]+" 모달' aria-hidden='false'>";
			html += "	<div class='modal-dialog modal-lg' role='document'>";
			html += "		<div class='modal-content'>";
			html += "			<div class='modal-header'>";
			html += "				<button type='button' class='close' data-dismiss='modal' aria-label='닫기'>";
			html += "					<span aria-hidden='true'>&times;</span>";
			html += "				</button>";
			html += "				<h4 class='modal-title'>"+typeMap[type]+"</h4>";
			html += "			</div>";
			html += "			<div class='modal-body'>";
			html += "				<iframe src='' id='seminarPopIfm' name='seminarPopIfm' width='100%' scrolling='no'></iframe>";
			html += "			</div>";
			html += "		</div>";
			html += "	</div>";
			html += "</div>";
		$("#wrap").append(html);
		$('iframe').iFrameResize();
	}
	
	// 날짜 자리수 채우기
	function pad(number, length){
		var str = number.toString();
		while(str.length < length){
			str = '0' + str;
		}
		return str;
	}
	
	// 파일 다운로드
	function fileDown(fileSn, repoCd) {
		var url  = "/common/fileInfoView.do";
		var data = {
			"fileSn" : fileSn,
			"repoCd" : repoCd
		};
		
		ajaxCall(url, data, function(data) {
			$("#downloadForm").remove();
			// download용 iframe이 없으면 만든다.
			if ( $("#downloadIfm").length == 0 ) {
				$("body").append("<iframe id='downloadIfm' name='downloadIfm' style='visibility: hidden; display: none;'></iframe>");
			}
			
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "downloadForm");
			form.attr("id", "downloadForm");
			form.attr("target", "downloadIfm");
			form.attr("action", data);
			form.appendTo("body");
			form.submit();
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		});
	}
	
	// 파일 바이트 계산
	function byteConvertor(bytes, fileNm, fileSn) {
		bytes = parseInt(bytes);
		var s = ['bytes', 'KB', 'MB', 'GB', 'TB', 'PB'];
		var e = Math.floor(Math.log(bytes)/Math.log(1024));
		if(e == "-Infinity") {
			$("#file_"+fileSn).append(fileNm + " 0 "+s[0]);
		} else {
			$("#file_"+fileSn).append(fileNm + " " + (bytes/Math.pow(1024, Math.floor(e))).toFixed(2)+" "+s[e]);
		}
	}
	
	// 날짜 포맷
	function dateFormat(formatter, date) {
		// HH:mm:ss
		if(formatter == "time") {
			if(date == null) {
				return "00:00:00";
			} else {
				var hour = pad(parseInt(date / 60 / 60), 2);
				var min  = pad(parseInt(date / 60) - 60 * hour, 2);
				var sec  = pad(date % 60, 2);
				return hour + ":" + min + ":" + sec;
			}
		// mm분 : HH시간 mm분
		} else if(formatter == "timeStr") {
			if(parseInt(date / 60) == 0) {
				return date % 60 + "<spring:message code='seminar.label.min' />"/* 분 */;
			} else {
				return parseInt(date / 60) + "<spring:message code='seminar.label.time' /> "/* 시간 */ + date % 60 + "<spring:message code='seminar.label.min' />"/* 분 */;
			}
		// HH:mm:00
		} else if(formatter == "timePad") {
			return pad(parseInt(date / 60), 2) + ":" + pad(date % 60, 2) + ":00";
		// yyyy.MM.dd HH:mm:ss
		} else if(formatter == "date") {
			if(date == null || date == "-") {
				return "-";
			} else {
				return date.substring(0, 4) + "." + date.substring(4, 6) + "." + date.substring(6, 8) + " " + date.substring(8, 10) + ":" + date.substring(10, 12);
			}
		}
	}
	
	// 출석 포맷
	function attendFormat(formatter, date) {
		var attend = formatter == "suspense" ? "<spring:message code='seminar.label.pending' />"/* 미결 */ : "-";
		if(formatter == "attendColor") {
			if(date == "ATTEND") attend = "<span class='fcBlue'><spring:message code='seminar.label.attend' /></span>"/* 출석 */;
			if(date == "LATE")	 attend = "<span class='fcYellow'><spring:message code='seminar.label.late' /></span>"/* 지각 */;
			if(date == "ABSENT") attend = "<span class='fcRed'><spring:message code='seminar.label.absent' /></span>"/* 결석 */;
			if(date == "START")  attend = "-";
		} else {
			if(date == "ATTEND") attend = "<spring:message code='seminar.label.attend' />"/* 출석 */;
			if(date == "LATE")	 attend = "<spring:message code='seminar.label.late' />"/* 지각 */;
			if(date == "ABSENT") attend = "<spring:message code='seminar.label.absent' />"/* 결석 */;
			if(date == "START")  attend = "-";
		}
		return attend;
	}
	
	// null check
	function dataNullCheck(type, data) {
		if(data != null) {
			return data;
		} else {
			return type == "hyphen" ? "-" : "";
		}
	}
	
	// 페이지 이동
	function submitForm(action, target, modal, kvArr){
		if(modal != "") initModal(modal);
		$("form[name='tempForm']").remove();

		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "tempForm");
		form.attr("action", action);
		form.attr("target", target);

		for(var i=0; i<kvArr.length; i++){
			form.append($('<input/>', {type: 'hidden', name: kvArr[i].key, value: kvArr[i].val}));
		}

		form.appendTo("body");
		form.submit();
		if(modal != "") $('#seminarPop').modal('show');
	};
</script>