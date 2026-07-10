<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<div class="segment class-area sub">
    <div class="class_info">
        <div class="class_tit">
            <p class="labels">
                <label class="label uniA" style="width:150px">${uiex:getClassOrgnm()}</label> <%-- 기관명 --%>
            </p>
            <h2>${uiex:getClassSbjctnm()}</h2> <%-- 과목명 --%>

            <%-- 권한=${uiex:getSubjectAuth()} --%> <!-- 테스트용, 삭제 -->

        </div>
        <uiex:navibar type="lect"/><%-- 네비게이션바 --%>
    </div>
</div>
