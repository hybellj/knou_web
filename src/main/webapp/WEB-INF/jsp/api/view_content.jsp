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
		$(document).ready(function() {
			hideLoading();
		});
	</script>
	<style type="text/css">
		body {
			padding:0;
			background:#000;
		}
		.wrap {
			display:table;
			min-height:100vh;
		}
		.cntsbox {
			display:table-cell;
			vertical-align:middle
		}
		.ui.error.message {
			margin:20px;
		}
	</style>
</head>
<body>

<div class="wrap">
	<div id="cntsbox" class="cntsbox">
		<c:choose>
			<c:when test="${result eq 'true'}">
				<video id="previewPlayer" 
					title="${pageVO.pageNm}" 
					data-poster="" 
					lang="ko" 
					continue="false" 
					continueTime="" 
					speed="true" 
					speedPlaytime="false"
					showChapter="false"
					showIndex="false"
					showPageNoOpen="true">
					
					${pageInfo}
					
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
				<script>
					$("body").css("background","white");
				</script>
			</c:otherwise>
		</c:choose>
   </div>
</div>

</body>
</html>		