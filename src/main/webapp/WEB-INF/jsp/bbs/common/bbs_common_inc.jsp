<%@page import="knou.framework.common.CommConst"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="knou.framework.common.SessionInfo"%>
<%@page import="knou.lms.bbs.web.util.BbsAuthUtil"%>
<%
	String adminYn = BbsAuthUtil.isAdmin(request) ? "Y" : "N";
	String professorYn = BbsAuthUtil.isProfessor(request) ? "Y" : "N";
	String studentYn = BbsAuthUtil.isStudent(request) ? "Y" : "N";
	String tutorYn = BbsAuthUtil.isTutor(request) ? "Y" : "N";
	String professorVirtualLoginYn = SessionInfo.getProfessorVirtualLoginYn(request);
	String prevCourseYn = SessionInfo.getPrevCourseYn(request);

	request.setAttribute("ADMIN_YN", adminYn);
	request.setAttribute("PROFESSOR_YN", professorYn);
	request.setAttribute("STUDENT_YN", studentYn);
	request.setAttribute("TUTOR_YN", tutorYn);
	request.setAttribute("USER_ID", SessionInfo.getUserId(request));
	request.setAttribute("BBS_ID_SYSTEM_NOTICE", CommConst.BBS_ID_SYSTEM_NOTICE);
%>
<style type="text/css">
	/* 에디터 모바일 줄어듬 적용 */
	.editor-responsive {
		display: table;
	    table-layout: fixed;
	    width: 100%;
	}
</style>
<script type="text/javascript">
	var bbsCommon = {
		replaceDateToDttm: function(date) {
			var dt = new Date(date);
			var tmpYear = dt.getFullYear().toString();
			var tmpMonth = this.pad(dt.getMonth() + 1, 2);
			var tmpDay = this.pad(dt.getDate(), 2);
			var tmpHourr = this.pad(dt.getHours(), 2);
			var tmpMin = this.pad(dt.getMinutes(), 2);
			var tmpSec = this.pad(dt.getSeconds(), 2);
			var nowDay = tmpYear + tmpMonth + tmpDay + tmpHourr + tmpMin + tmpSec;
			return nowDay;
		},
		pad : function(number, length) {
			var str = number.toString();
			while (str.length < length) {
				str = '0' + str;
			}
			return str;
		},
		getByte : function(str) {
			var byteLen = 0;
			for (var i = 0; i < str.length; ++i) {
				// 기본 한글 2바이트 처리
				(str.charCodeAt(i) > 127) ? byteLen += 2 : byteLen++;
			}

			return byteLen;
		},
		isAdmin : function() {
			return '<c:out value="${ADMIN_YN}" />' == "Y" ? true : false;
		},
		isProfessor : function() {
			return '<c:out value="${PROFESSOR_YN}" />' == "Y" ? true : false;
		},
		isStudent : function() {
			return '<c:out value="${STUDENT_YN}" />' == "Y" ? true : false;
		},
		isTutor : function() {
			return '<c:out value="${TUTOR_YN}" />' == "Y" ? true : false;
		},
		movePost : function(url, queryStr) {
			//location.href=url + "?" + queryStr; return;
			var params = new URLSearchParams(queryStr);
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "bbsForm");
			form.attr("action", url);

			params.forEach(function(value, key) {
				form.append($('<input/>', {type: 'hidden', name: key, value: value}));
			})

			form.appendTo("body");
			form.submit();
		},
		regist : function(url, returnUrl, data) {
			ajaxCall(url, data, function(data) {
            	if(data.result > 0) {
					UiComm.showMessage(data.message, "success")
					.then(function(result) {
						document.location.href = returnUrl;
					});
                } else {
                	UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
                }
    		},
    		function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='fail.common.msg'/>","error"); // 에러가 발생했습니다!
    		}, true);
		},
		modify : function(url, returnUrl, data) {
		},
		delete : function(url, returnUrl, data) {
			ajaxCall(url, data, function(data) {
	        	if (data.result > 0) {
	        		var queryInfo = {};

	        		if(TAB) {
	        			queryInfo.tab = TAB;
	        		}

	        		UiComm.showMessage(data.message, "success")
					.then(function(result) {
						document.location.href = returnUrl;
					});
	            } else {
	            	UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
	            }
			},
    		function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='fail.common.msg'/>","error"); // 에러가 발생했습니다!
    		}, true);
		}
	};
</script>