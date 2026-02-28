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
	    });
	    
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
    </script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
		<div class="ui form">
            <ul class="tbl dt-sm">
                <li>
                    <dl>
                        <dt><spring:message code="exam.label.applicate.dttm" /></dt><!-- 신청일시 -->
                        <dd>${scoreOverallVO.objtDttmFmt}</dd>
                    </dl>
                </li>
                <li>
                    <dl class="min-height-200">
                        <dt><spring:message code="score.label.request.reason" /></dt><!-- 신청사유 -->
                        <dd>
                        	<c:out value="${scoreOverallVO.objtCtnt}" escapeXml="false"/>
                        </dd>
                    </dl>
                </li>
                <c:if test="${not empty fileList and fileList.size() > 0}">
                <li>
                    <dl>
                        <dt><spring:message code="common.attachments" /></dt><!-- 첨부파일 -->
                        <dd>
                        	<!-- 첨부파일 -->
							<div class="flex_1 mr5">
								<ul>
									<c:forEach items="${fileList}" var="row">
									<li class="mb5 opacity7 file-txt">
										<a href="javascript:void(0)" class="btn border0" onclick="fileDown('<c:out value="${row.fileSn}" />', '<c:out value="${row.repoCd}" />')">
											<i class="xi-download mr3"></i><c:out value="${row.fileNm}" /> (<c:out value="${row.fileSizeStr}" />)
										</a>
									</li>
									</c:forEach>
								</ul>
							</div>
                        </dd>
                    </dl>
                </li>
                </c:if>
            </ul>
        </div>
		<div class="bottom-content">
	        <!-- <button class="ui blue button">예</button> -->
	        <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="asmnt.button.close" /></button><!-- 닫기 -->
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
