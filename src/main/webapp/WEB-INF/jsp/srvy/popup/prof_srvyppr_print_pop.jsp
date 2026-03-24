<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="classroom"/>
		</jsp:include>
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
		// 인쇄
		function srvypprPrint() {
			window.print();

			//$("#srvypprModal").print({
			//	globalStyles : true,
			//	stylesheet : null,
			//	rejectWindow : true,
			//	noPrintSelector : ".no-print",
			//	append : null,
			//	prepend : null
			//});
		}

		// 워터마크
		function watermarkedDataURL (text,watermarkDiv) {
			var watermarkDiv = $("#srvypprModal");				//워터마크 적용될 영역
			var tempCanvas=document.createElement('canvas');	//워터마크 사용될 임의의 캔버스
			var tempCtx=tempCanvas.getContext('2d');			//캔버스 2d 컨텐츠
			var cw,ch;
			cw=tempCanvas.width=watermarkDiv.outerWidth(true);	//영역의 넓이
			ch=tempCanvas.height=watermarkDiv.outerHeight(true);//영역의 높이
			// height is font size
			tempCtx.font="24px verdana";						//폰트 및 글꼴
			var metrics   = tempCtx.measureText(text);			//가변글자 객체
			var textWidth = metrics.width;						//가변글자 넓이
			var height    = 24;									//글자 높이

			tempCtx.fillStyle   ='gray'							//글자 색상
			tempCtx.globalAlpha = "0.2";						//글자 투명도

			//각도 45도 임으로 피타고라스정의에의해 밑에식 구현
			var xStep = Math.sqrt(textWidth * textWidth/2);

			//시계반대방향 45도 기울임
			tempCtx.rotate(Math.PI / 180 * -45);

			for (var y = 0; y < ch; y += xStep) {
				var x = 0
		        for (; x < cw; x += xStep) {
					tempCtx.translate(xStep, xStep);
					tempCtx.strokeText(text,-xStep,y);
		        }
		        tempCtx.translate(-x-xStep*2, -(x-xStep));
			}

			var dataUrl = tempCanvas.toDataURL();				//data Url화
			watermarkDiv.attr("style","background:url("+dataUrl+"); -webkit-print-color-adjust:exact;");
			srvypprPrint();
		}
	</script>

	<body class="modal-page">
		<div id="wrap">
			<form id="srvypprPrintForm" name="srvypprPrintForm" method="POST">
				<div id="srvypprModal">
					<div class="msg-box">
	                    <p class="txt"><strong>${srvyPtcpnt.usernm}</strong>의 설문지</p>
	                </div>
					<div id="srvyPreviewQstnList">
						<jsp:include page="/WEB-INF/jsp/srvy/common/srvy_qstn_inc.jsp" />
					</div>
					<script type="text/javascript">watermarkedDataURL("${srvyPtcpnt.userId}"+"_"+"${srvyPtcpnt.usernm}",$("div.cpn"));</script>
				</div>
			</form>
		</div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
