<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!-- footer 영역 부분 -->
<footer id="bottom">
	<div class="inner-wrap">
		<ul class="copy">
			<li><address>(04763) <spring:message code="common.wangsimniro.seongdonggu.seoul.republic.of.korea" /> / <spring:message code="common.a.key.number" /> : 02-2290-0114 / <spring:message code="common.fax" /> : 02-2290-0600 / <spring:message code="common.a.registration.number" /> : 206-82-06345 
				<a href="https://www.hycu.ac.kr/user/main/content/inPrPolc.do" target="_blank" class="ui inverted basic small button ml5" onclick="viewPrPolc();return false;"><spring:message code="common.personal.information.processing.policy" /></a></address>
				<script>
                // 개인정보처리방침 보기
                function viewPrPolc() {
                	let url = "https://www.hycu.ac.kr/user/main/content/inPrPolc.do";
                	window.open(url, "prPolc", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
                }
                </script>
			</li>
			<li>COPYRIGHT ©2023 Hanyang Cyber University. All rights reserved.</li>
		</ul>
	</div>
</footer>
<!-- //footer 영역 부분 -->
<!--<a title="컨텐츠 상단으로 이동" class="" id="toTop" style="display:none;" href="#"></a>-->
