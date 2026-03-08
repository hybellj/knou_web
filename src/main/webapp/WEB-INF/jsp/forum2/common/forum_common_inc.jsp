<%@page import="knou.framework.util.SessionUtil"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.2/rollups/aes.js"></script>
<script type="text/javascript">
window.closeModal = function() {
	$('.modal').modal('hide');
};

window.closeDialog = function() {
    dialog.close();
};

var forumCommon = {
	// 모달 생성
	initModal: function(type) {
		$("#forumPop").remove();
		var typeMap = {
			"profMemo"		: "<spring:message code='forum.label.memo' />",/* 메모 */
			"scoreExcel"	: "<spring:message code='forum.button.reg.excel.score' />",/* 엑셀 성적등록 */
			"feedback"		: "<spring:message code='forum.button.feedback.write' />", /* 피드백 작성하기 */
			"allFeedback"	: "<spring:message code='forum.button.all.feedback' />", /* 일괄 피드백 */
			"chartView"		: "<spring:message code='forum.label.submit.status' />", /* 토론현황 */
		};
		var html  = "<div class='modal fade' id='forumPop' tabindex='-1' role='dialog' aria-labelledby='"+typeMap[type]+"' aria-hidden='false'>";
			html += "	<div class='modal-dialog modal-lg' role='document'>";
			html += "		<div class='modal-content'>";
			html += "			<div class='modal-header'>";
			html += "				<button type='button' class='close' data-dismiss='modal' aria-label=\"<spring:message code='forum.button.close'/>\">"; // 닫기
			html += "					<span aria-hidden='true'>&times;</span>";
			html += "				</button>";
			html += "				<h4 class='modal-title'>"+typeMap[type]+"</h4>";
			html += "			</div>";
			html += "			<div class='modal-body'>";
			html += "				<iframe src='' id='forumPopIfm' name='forumPopIfm' width='100%' scrolling='no' title='pop frame'></iframe>";
			html += "			</div>";
			html += "		</div>";
			html += "	</div>";
			html += "</div>";
		$("#wrap").append(html);
		$('iframe').iFrameResize();
	},
	// date객체를 문자로 리턴
	replaceDateToDttm: function(date){
		//2022.10.7 6:00 오전
		var dateList = date.split(/:|\.| /);
		if(dateList[5] == "오후" && dateList[3] != "12") {
			dateList[3] = parseInt(dateList[3]) + 12;
		} else if(dateList[5] == "오전" && dateList[3] == "12") {
			dateList[3] = "00";
		}

		var dt = new Date(this.pad(dateList[0], 4), this.pad(dateList[1], 2)-1, this.pad(dateList[2], 2), this.pad(dateList[3], 2), this.pad(dateList[4], 2));
		var tmpYear  = dt.getFullYear().toString();
		var tmpMonth = this.pad( dt.getMonth()+1, 2);
		var tmpDay   = this.pad( dt.getDate(), 2);
		var tmpHourr = this.pad( dt.getHours(), 2);
		var tmpMin   = this.pad( dt.getMinutes(), 2);
		var tmpSec   = this.pad( dt.getSeconds(), 2);
		var nowDay   = tmpYear+tmpMonth+tmpDay+tmpHourr+tmpMin+tmpSec;
		return nowDay;
	},
	// 날짜 자리수 채우기
	pad: function(number, length){
		var str = number.toString();
		while(str.length < length){
			str = '0' + str;
		}
		return str;
	},
	// 체크박스 이벤트
	changeCheckBox: function(obj, allChkName, chkName) {
		if(obj.checked) {
			if(obj.value == "all") {
				$("input:checkbox[name="+chkName+"]").not(".readonly").prop("checked", true);
			}
		} else {
			if(obj.value == "all") {
				$("input:checkbox[name="+chkName+"]").not(".readonly").prop("checked", false);
			}
			$("input:checkbox[name="+allChkName+"]").prop("checked", false);
		}
		var allLength = $("input:checkbox[name="+chkName+"]").length;
		var chkLength = $("input:checkbox[name="+chkName+"]:checked").length;
		if(allLength == chkLength) {
			$("input:checkbox[name="+allChkName+"]").prop("checked", true);
		}
	}
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
			$("body").append("<iframe id='downloadIfm' name='downloadIfm' style='visibility: hidden; display: none;' title='download frame'></iframe>");
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
		$("#"+fileSn).append(fileNm + " 0 "+s[0]);
	} else {
		var val = (bytes/Math.pow(1024, Math.floor(e)));
		if (bytes > 1000) {
			val = val.toFixed(2);
		}

		$("#"+fileSn).append(fileNm + " (" + val + " "+s[e]+")");
	}
}

// 날짜 형식 변경(YYYY.MM.DD HH24:MI)
function dateFormat(dt){
	return dt.substring(0, 4) + '.' + dt.substring(4, 6) + '.' + dt.substring(6, 8) + ' ' + dt.substring(8, 10) + ':' + dt.substring(10, 12);
}

//쿠키 저장하는 함수
function set_cookie(name, value, unixTime) {
	var date = new Date();
	date.setTime(date.getTime() + unixTime);
	document.cookie = encodeURIComponent(name) + '=' + encodeURIComponent(value) + ';expires=' + date.toUTCString() + ';path=/';
}

//쿠키 값 가져오는 함수
function get_cookie(name) {
	 var value = document.cookie.match('(^|;) ?' + name + '=([^;]*)(;|$)');
	 return value ? value[2] : null;
}

//쿠키 삭제하는 함수
function delete_cookie(name) {
	document.cookie = encodeURIComponent(name) + '=; expires=Thu, 01 JAN 1999 00:00:10 GMT';
}
</script>