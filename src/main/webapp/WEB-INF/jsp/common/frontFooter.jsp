<%@page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!-- footer 영역 부분 -->
<footer id="bottom">
	<%
	String userAgentFooter = request.getHeader("User-Agent") != null ? request.getHeader("User-Agent").toLowerCase() : "";
	if(userAgentFooter.indexOf("hycuapp") == -1){  
		%>
	    <button class="go_top" data-medi-ui="gotop">
	        <i class="ico icon-upload"></i>
	        <!-- <span class="text">TOP</span> -->
	    </button>		
		<%
	}
	%>
    <div class="inner">
        <div class="fr_cont">
            <ul class="copy">
                <li>
                    <address>(00000) 서울시 강남구 도곡동 000</address>
                    <span class="tel_info">
                        <span class="info_tab">|</span><spring:message code="common.a.key.number" /> : 02-111-2222
                    </span>
                    <span class="tel_info">
                        <span class="info_tab">|</span><spring:message code="common.fax" /> : 02-111-2222
                    </span>
                    <span class="tel_info">
                        <span class="info_tab">|</span><spring:message code="common.a.registration.number" /> : 000-00-00000
                    </span>
                </li>
                <li>COPYRIGHT ©2025 Mediopia Tech. All rights reserved.</li>
            </ul>
            <div class="exc_copy">
                <a href="#_" target="_blank" class="ui basic small blue button" onclick="viewPrPolc();return false;"><spring:message code="common.personal.information.processing.policy" /></a><!-- 개인정보처리방침 -->
                <script>
                // 개인정보처리방침 보기
                function viewPrPolc() {
                	alert("[준비중] 개인정보처리방침");
                }
                </script>
            </div>
        </div>
    </div>
</footer>
<!-- //footer 영역 부분 -->
