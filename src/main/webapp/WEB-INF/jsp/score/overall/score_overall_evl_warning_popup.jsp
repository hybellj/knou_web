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
    </head>
    <script type="text/javascript">
    $(document).ready(function(){
    });
    </script>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
            <div class="ui form">
            	 <div class="ui segment">
            	 	<p class="bullet_design1">
            	 		<spring:message code="score.label.process.new.msg1" />
            	 	</p>
            	 	<p class="bullet_design1 mt10">
            	 		<spring:message code="score.label.process.new.msg2" />
            	 	</p>
            	 	<p class="bullet_dot pl10 mt5">
            	 		<span class="fcBlue"><spring:message code="score.label.process.new.msg3" /></span>
            	 		<small class="ui error message d-inline-block p5 f070 mt7"><i class="icon circle info"></i><spring:message code="score.label.process.new.msg4" /></small>
            	 	</p>
                    <div class="ui info message">
                        <i class="icon circle info"></i><spring:message code="score.label.process.msg15" /><a href="tel:02-2290-0043">02-2290-0043</a>
                    </div>
                    <p class="bullet_design1 mt4">
                        <spring:message code="score.label.process.msg16" />
                    </p>
                    <p class="pl10">
                        <strong class="fcBlue">${curDateFmt}</strong> <spring:message code="score.label.process.msg17" />
                    </p>
                </div>
            </div>
            <div class="tc mt20 ">
                <strong class="f110"><spring:message code="score.label.process.msg18" /></strong>
            </div>
            <div class="bottom-content tc">
                <button type="button" class="ui blue button" onclick="window.parent.onScoreCal();"><spring:message code="asmnt.common.yes" /></button>
                <button type="button" class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="asmnt.common.no" /></button>
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
