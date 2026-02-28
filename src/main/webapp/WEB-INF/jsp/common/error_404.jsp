<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

<body class="">

    <section class="extras errorBasic">
        <div class="flex-container">
            <div class="cont-none">
                <img src="/webdoc/img/error_img.png" alt="알림" aria-hidden="true"/>
                <div class="ui large header"><strong>요청하신 페이지를 처리중에 오류가 발생했습니다.<br>[Error: 404]</strong></div>
                <div class="text">
                    <p class="fcBlue">서비스 이용에 불편을 드려 죄송합니다.<br> 입력하신 주소가 정확한지 확인 후 다시 시도해 주시기 바랍니다.</p>
                    <p>We have encountered a system error while processing your request. We apologize for the inconvenience. Please check URL and try again.</p>
                </div>
                <div class="mt20">
                    <a href="/" onclick="window.history.back();return false;" class="ui grey button" title="Back">이전화면 바로가기</a>
                    <a href="/" class="ui blue button" title="Home">메인화면 바로가기</a>
                </div>
            </div>
        </div>
    </section>


</body>

</html>