<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<%
response.setHeader("X-Frame-Options", "allowall");
%>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
	
   	<link rel="stylesheet" type="text/css" href="/webdoc/player/plyr.css?v=12" />
	<script type="text/javascript" src="/webdoc/player/plyr.js" crossorigin="anonymous"></script>
	<script type="text/javascript" src="/webdoc/player/player.js?v=25" crossorigin="anonymous"></script>
	<script type="text/javascript" src="/webdoc/js/crypto-js.min.js"></script>
	<script type="text/javascript">
		var plyrConf = localStorage.getItem("plyr");
		if (plyrConf == null) {
			localStorage.setItem('plyr', '{"quality":1080}');
		}
	
		$(document).ready(function() {
			hideLoading();
		});
	</script>
</head>
<body class="p20">

	<div id="wrap">
		<div class="p10 fcWhite bcBlue f120 tc">
			콘텐츠 미리보기
		</div>
		
		<div id="cntsbox" class="mt20">
			<c:choose>
				<c:when test="${not empty lessonCnts and (lessonCnts.cntsGbn eq 'VIDEO' or lessonCnts.cntsGbn eq 'VIDEO_LINK')}">
					<video id="previewPlayer" 
						title="${lessonCnts.lessonCntsNm}" 
						data-poster="" 
						lang="ko" 
						continue="false" 
						continueTime="" 
						speed="true" 
						speedPlaytime="false"
						showChapter="false"
						showIndex="true">
						<source src="${lessonCnts.lessonCntsUrl}" type="video/mp4" size="720"/>
						
						<c:if test="${not empty lessonCnts.pageInfo and lessonCnts.pageInfo ne ''}">
							${lessonCnts.pageInfo}
						</c:if>
					</video>
					<script type="text/javascript">
						// 플레이어 초기화
						var previewPlayer = UiMediaPlayer("previewPlayer");
					</script>
				</c:when>
				<c:otherwise>
					<div class="ui error message">
						콘텐츠 정보가 올바르지 않습니다.
					</div>
				</c:otherwise>
			</c:choose>
        </div>
                
	</div>
</body>
</html>		