<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>

<c:if test="${pageType ne 'iframe' or param.view eq 'on'}">

<footer id="bottom" class="footer">
	<button type="button" class="go_top"><i class="xi-angle-up-min"></i><span>TOP</span></button>
	<div class="inner-wrap">
		<div class="footer_btn">
			<a href="#0">개인정보처리방침</a>                
		</div>          
		<ul class="copy">
			<li><address><span>(03087) 서울특별시 종로구 대학로 86 (동숭동) 한국방송통신대학교</span><span>대표전화 : 1577-9995</span></address></li>
			<li>COPYRIGHT(C) KOREA NATIONAL OPEN UNIVERSITY. ALL RIGHTS RESERVED.</li>
		</ul>            
	</div>
</footer>

</c:if>