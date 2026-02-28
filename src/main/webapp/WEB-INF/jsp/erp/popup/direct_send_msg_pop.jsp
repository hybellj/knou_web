<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
   	<script type="text/javascript" src="/webdoc/js/ui-inputmask.js"></script>
   	
   	<script type="text/javascript">
   		let showSmsSubject = false;
   	
	   	$(document).ready(function() {
	   	});
	   	
	   	function sendMsg() {
	   		if (showSmsSubject && $("#smsSubject").val() == '') {
	   	        alert('제목을 입력하세요.');         //제목을 입력하세요.
	   	        $("#smsSubject").focus();
	   	        return;
	   	    }
	   		
	   		if($("#smsCtnt").val() == '') {
	   			alert('<spring:message code="common.empty.msg" />'); // 내용을 입력하세요.
	   			return;
	   		}
	   		
	   		if ($("#sndrPhoneNo").val() == '') {
	   	        alert('발신자번호를 입력하세요.');         //제목을 입력하세요.
	   	        $("#sndrPhoneNo").focus();
	   	        return;
	   	    }
	   		
	   	    var size = UI_COMM.UTF8 == true ? getTextSizeUni($("#smsCtnt").val()) : getTextSize($("#smsCtnt").val());
	   	    if (size > 1000) {
	   	    	alert("내용은 2000자 이상 입력 할 수 없습니다.");
	   	    	return;
	   	    }
	   		
	        let data = {
	                alarmType : $("#alarmType").val()
	                , sysCd : $("#sysCd").val()
	                , orgId : $("#orgId").val() 
	                , bussGbn : $("#bussGbn").val()     
	                , subject : $("#smsSubject").val()
	                , ctnt : $("#smsCtnt").val()
	                , sendDttm : ""
	                , sndrPhoneNo : $("#sndrPhoneNo").val()
	                , logDesc : 'SMS 예약 발송 또는 발송 등록'
	                , courseCd : ""
	                , menuId : ""
	                , smsSndType : $("#smsForm input[id=smsSndType]").val()
	                , rcvUserInfoStr : $("#rcvUserInfoStr").val()
	            };
	        
	        showLoading();
	        
	        $.ajax({
				url : "/erp/directSendMsg.do",
				data: data,
				type: "POST",
				success : function(data, status, xr){
					hideLoading();
					if(data.result > 0) {
						alert('<spring:message code="success.common.insert" />'); // 정상적으로 등록되었습니다.
						window.parent.closeModal();
		        	} else {
		        		alert(data.message);
		        	}					
				},
		        error : function(xhr, status, error){
		        	hideLoading();
		        	alert('<spring:message code="fail.common.msg" />\n\n'+error); // 에러가 발생했습니다!
				},
				timeout:600000
	        });
	   	}
	   	
	   	/**
	   	 * 문자열 길이(byte) 반환
	   	 * @param str
	   	 * @returns size
	   	 */
	   	function getTextSize(str) {
	   		return str.length + (escape(str)+"%u").match(/%u/g).length-1;
	   	}
	   	
	   	/**
	   	 * 문자열 길이(byte) 반환 (UTF-8, 한글 3byte)
	   	 * @param str
	   	 * @returns size
	   	 */
	   	function getTextSizeUni(str) {
	   		var size = 0;
	   		var char = 0;
	   		
	   		if (str != null && str != "") {
	   			for(var i=0; char=str.charCodeAt(i++); size += char>>11 ? 3 : char>>7 ? 2 : char==10 ? 2 : 1);
	   		}
	   		
	   	    return size;
	   	}
   	</script>
</head>
<body class="modal-page>
	<div id="wrap">
	    <form id="smsForm" name="smsForm" method="POST">
	    <input type="hidden" id="alarmType"             name="alarmType"            value="S"/>
        <input type="hidden" id="sysCd"                 name="sysCd"                value="LMS" />
        <input type="hidden" id="orgId"                 name="orgId"                value="KNOU" />
        <input type="hidden" id="bussGbn"               name="bussGbn"              value="LMS" />
	    <input type="hidden" id="smsSndType" name="smsSndType" value="P"/>
	    <input type="hidden" id="rcvUserInfoStr" name="rcvUserInfoStr" value="${vo.rcvUserInfoStr}"/>
    
        <div class="row">
	        <ul class="tbl type2 mt20 mb20">
	            <li>
	                <dl>
	                    <dt>
	                        <label>업무구분<!-- 업무구분 --></label>
	                    </dt>
	                    <dd>
	                        <label>강의실 <!-- 강의실--></label>
	                    </dd>
	                </dl>
	            </li>
                <li id="subjectField" style="display:none">
                    <dl>
                        <dt>
                            <label for="subjectLabel" class="req">제목<!-- 제목 --></label>
                        </dt>
                        <dd>
                            <div class="ui fluid input">
                                <input type="text" id="smsSubject" name="smsSubject" inputmask="byte" maxLen="120" value="">
                            </div>
                        </dd>
                    </dl>
                </li>
	            <li>
	                <dl>
	                    <dt>
	                        <label for="ctntLabel" class="req">문자 내용<!-- 문자내용 --></label>
	                    </dt>
	                    <dd>
	                        <div class="">
	                            <textarea id="smsCtnt" name="smsCtnt" rows="5" maxLenCheck="byte,1000,true,false"></textarea>
	                            <div id="smsCntsMsg" class="fcGrey" style="display:none">※ 90byte 초과시 LMS로 자동전환되어 발송됩니다.</div>
	                            
	                            <script type="text/javascript">
	                                let smsCtnsObj = $("#smsCtnt");
	                                
	                                smsCtnsObj.on("keyup", function(){
	                                    var val = $(this).val();
	                                    var size = UI_COMM.UTF8 == true ? getTextSizeUni(val) : getTextSize(val);
	                                    if (!showSmsSubject && size >= 90) {
	                                        $("#subjectField").show();
	                                        $("#smsCntsMsg").show();
	                                        showSmsSubject = true;
	                                    }
	                                    else if (showSmsSubject && size < 90) {
	                                        $("#subjectField").hide();
	                                        $("#smsCntsMsg").hide();
	                                        showSmsSubject = false;
	                                    }
	                                });
	                            </script>
	                        </div>
	                    </dd>
	                </dl>
	            </li>
                <li>
                    <dl>
                        <dt>
                            <label for="smsSndrPhoneNo" class="req">발신자번호<!-- 발신자번호 --></label>
                        </dt>
                        <dd>
                            <div class="ui input">
                                <input type="text" id="sndrPhoneNo" name="sndrPhoneNo" value="">
                            </div>
                        </dd>
                    </dl>
                </li>
                <li>
                    <dl>
                        <dt>
                            <label>대상자수</label>
                        </dt>
                        <dd>
                            ${vo.sendCnt}명
                        </dd>
                    </dl>
                </li>

	        </ul>

		</div>


		<div class="bottom-content">
			<button type="button" class="ui blue cancel button" onclick="sendMsg();"><spring:message code="common.button.send" /><!-- 보내기 --></button>
			<button type="button" class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>