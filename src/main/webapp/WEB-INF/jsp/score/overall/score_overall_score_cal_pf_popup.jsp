<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
   	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
   	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
   	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
   	<link rel="stylesheet" type="text/css" href="/webdoc/file-uploader/file-uploader.css" />
   	<script type="text/javascript" src="/webdoc/js/jquery.form.min.js"></script>
    <script type="text/javascript" src="/webdoc/file-uploader/lang/file-uploader-ko.js"></script>
    <script type="text/javascript" src="/webdoc/file-uploader/file-uploader.js"></script>
    <script type="text/javascript" src="/webdoc/js/iframe.js"></script>
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    <script type="text/javascript">
	    $(function(){
	    	//성적환산 버튼 이벤트 주입
	    	$("#scoreBtn").on("click", function(){
	    		onSaveScore();
	    	});
	    });
	    
	    function onSaveScore() {
	    	getBtnStatus().done(function(scoreStatus) {
	    		if(scoreStatus == "3") {
	    			// 기존 성적환산이 초기화됩니다. 진행하시겠습니까?
    	        	if(!confirm('<spring:message code="score.confirm.select.msg3" /> <spring:message code="score.confirm.select.msg4" />')) return;
	    		} else {
	    			/* 성적환산을 하시겠습니까? */
	    	    	if(!confirm('<spring:message code="score.label.match.convert.msg" />')) return;
	    		}
	    		
	    		ajaxCall("/score/scoreOverall/savePfScoreConvert.do",  {crsCreCd : "${vo.crsCreCd}"}, function(data) {
					if(data.result > 0) {
						window.parent.closeModal();
		    			//window.parent.onSearch();
		    			if(typeof window.parent.scoreConvertCallBack === "function") {
		    				window.parent.scoreConvertCallBack();
		   				}
					} else {
						alert(data.message);
					}
				}, function(xhr, status, error) {
					/* 성적환산중 에러가 발생했습니다! */
					alert('<spring:message code="score.label.match.convert.fail.msg" />');
				}, true);
	    	});
	    }
	    
	    function getBtnStatus() {
			var deferred = $.Deferred();
			
			var url  = "/score/scoreOverall/selectBtnStatus.do";
			var param = {
				crsCreCd : "${vo.crsCreCd}"
			};
			
			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					var returnVO = data.returnVO;
					deferred.resolve(returnVO.scoreStatus);
				} else {
					deferred.resolve("");
				}
			}, function(xhr, status, error) {
				deferred.resolve("");
			}, true);
			
			return deferred.promise();
		}
    </script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
		<div class="ui form">
            <div class="flex gap4">
                <table class="tBasic mt20">
                    <thead>
                        <tr>
                            <th colspan="2">P/F <spring:message code="score.label.conversion.stand" /></th><!-- 환산기준 -->
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <th><spring:message code="bbs.label.uni.college" /></th><!-- 학부 -->
                            <td>60 <spring:message code="asmnt.label.point" /></td><!-- 점 -->
                        </tr>
                        <tr>
                            <th><spring:message code="bbs.label.uni.graduate" /></th><!-- 대학원 -->
                            <td>70 <spring:message code="asmnt.label.point" /></td><!-- 점 -->
                        </tr>                            
                    </tbody>
                </table>
            </div>
		</div>
	    <div class="bottom-content">
	        <button type="button" class="ui blue button" id="scoreBtn"><spring:message code="score.label.conversion" /></button>
	        <button type="button" class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="sys.button.close" /></button>
	    </div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>