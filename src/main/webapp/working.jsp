<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css" />

<body class="">
<!-- 안내 -->
    <section class="extras errorBasic">
        <div class="flex-container">
            <div class="cont-none">
                <img src="/webdoc/img/error_img.png" alt="알림" aria-hidden="true"/>
                <div class="ui large header"><strong>시스템 점검중입니다.</strong></div>
                <div class="text">
                    
                    <div class="fcBlue">
                    	<div>지금은 시스템을 사용할 수 없습니다.</div>
<%--                    	<div>점검시간 : 11일 01:00 ~ 11일 02:00 까지</div> --%>
                    </div>
                    
                    
                    <div class="mt20">
                    	<button type="button" title="홈으로 이동" class="ui button" onclick="document.location.href='/';">강의실 홈</button>
                    </div>
                </div>
                <div class="mt20">
                </div>
            </div>
        </div>
    </section>

</body>

</html>