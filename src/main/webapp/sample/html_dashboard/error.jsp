<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
	</jsp:include>
</head>
<body>

    <section class="extras errorBasic">
        <div class="flex-container">
            <div class="cont-none">
                <img src="<%=request.getContextPath()%>/webdoc/assets/img/error_img.png" alt="에러" aria-hidden="true"/>
                <div class="tit-header"><strong>페이지를 찾을 수 없습니다.</strong></div>
                <div class="text">
                    <p class="fcBlue">정상적인 홈페이지 접속이 아니거나 세션이 종료 되었습니다.</p>
                    <p>확인버튼을 클릭하여 다시 접속해 주세요.</p>
                </div>
                <div class="btns center mt30">
                    <a href="#0" class="btn">홈으로</a>
                    <a href="#0" class="btn gray2">이전화면 바로가기</a>
                    <a href="#0" class="btn type4">메인화면 바로가기</a>
                </div>
            </div>
        </div>
    </section>
</body>

</html>