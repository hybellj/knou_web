<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="login"/>
	</jsp:include>
</head>
<body >
    <div id="login_wrap">
		<div class="login_box">
			<div class="box_wrap">
				<div class="left_box">
					<div class="left_box_img"><img src="<%=request.getContextPath()%>/webdoc/assets/img/logo_symbol.png" alt="한국방송통신대학교 로고" /></div>
				</div>
				<div class="right_box">
					<div class="login_content">
						<div class="login_logo"><img src="<%=request.getContextPath()%>/webdoc/assets/img/logo.png" alt="한국방송통신대학교" /></div>
						<div class="login_wrap">
							<div class="login_input">
								<div class="login_title">
									<div class="title">한국방송통신대학교 <span>통합 LMS 로그인</span></div>
									<div class="desc">강의를 학습하기 위해서는 로그인이 필요합니다.</div>
								</div>

								<div class="tab_btn">
									<a href="#tab01" class="current">방송대 학생/직원</a>
									<a href="#tab02" class="">일반/기관회원</a>
								</div>
								<div id="tab01" class="tab-content">
									<div class="input_area">
										<form class="ui form" id="loginForm">
											<div class="form-row">
												<input class="form-control" type="text" name="id" placeholder="아이디를 입력해주세요." />
											</div>
											<div class="form-row">
												<input class="form-control" type="password" name="password" placeholder="비밀번호를 입력해주세요." />
											</div>
											<button type="button" class="login-btn">LOGIN</button>
											<div class="link-box">
												<p>
													<span class="custom-input">
														<input type="checkbox" name="" id="autoLabelA">
														<label for="autoLabelA">자동 로그인</label>
													</span>
												</p>
											</div>
										</form>
									</div>
								</div>
                        		<div id="tab02" class="tab-content" style="display:none;">
									<div class="input_area">
										<form class="ui form" id="loginForm">
											<div class="form-row">
												<input class="form-control" type="text" name="id" placeholder="아이디를 입력해주세요." />
											</div>
											<div class="form-row">
												<input class="form-control" type="password" name="password" placeholder="비밀번호를 입력해주세요." />
											</div>
											<button type="button" class="login-btn">LOGIN</button>
											<div class="link-box">
												<p>
													<span class="custom-input">
														<input type="checkbox" name="" id="autoLabelB">
														<label for="autoLabelB">자동 로그인</label>
													</span>
												</p>
												<p class="link_txt">
													<a href="#0">회원가입</a>
													<a href="#0">아이디/비밀번호 찾기</a>
												</p>
											</div>
										</form>
									</div>
								</div>
							</div>
						</div>
						<div class="sns_wrap">
							<div class="sns_pc"><!-- SNS_login PC -->
								<div class="sns_title">
									<div class="title">SNS 로그인</div>
									<div class="desc">회원가입을 하신 후 SNS계정으로 로그인 하세요.</div>
								</div>
								<div class="sns_btns">
									<a href="#0" class="btn kakao" aria-label="카카오 로그인"></a>
									<a href="#0" class="btn naver" aria-label="네이버 로그인"></a>
								</div>
							</div>
							<div class="sns_mo"><!-- SNS_login mobile -->
								<div class="sns_title">
									<div class="title">다른방법으로 로그인</div>
								</div>
								<div class="sns_btns">
									<a href="#0" class="btn"><i class="i-kakao"></i>카카오 로그인</a>
									<a href="#0" class="btn"><i class="i-naver"></i>네이버 로그인</a>
									<a href="#0" class="btn"><i class="icon-svg-passcode"></i>간편비밀번호</a>
									<a href="#0" class="btn"><i class="icon-svg-fingerprint"></i>지문인식</a>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="login_banner">
				<a href="#0">
					<div class="banner_area">
						<p class="title">한국방송통신대학교 강의맛보기<i class="icon-svg-arrow2" aria-hidden="true"></i></p>
						<p class="desc">
							<span>로그인하지 않아도 일부 강의를 미리 볼 수 있습니다.</span>
							<span>수강 전, 강의 내용을 미리 확인해보세요.</span>
						</p>
					</div>
				</a>
			</div>
			<footer id="bottom">
				<div class="inner-wrap">
					<ul>
						<li>
							<address>(03087) 서울특별시 종로구 대학로 86 (동숭동) 한국방송통신대학교</address>
							<span>대표전화 : 1577-9995</span>
						</li>
						<li class="copyright">COPYRIGHT(C) KOREA NATIONAL OPEN UNIVERSITY. ALL RIGHTS RESERVED.</li>
					</ul>
					<div class="inner-right">
						<div class="btn_area">
							<a href="#0">개인정보처리방침</a>
						</div>
						<div class="relate_site">
							<a href="#" class="title" title="교내 사이트 열기">교내 사이트<i class="xi-caret-down-min" aria-hidden="true"></i></a>
							<ul class="list">
								<li><a href="https://www.knou.ac.kr/" target="_blank" title="새창으로 열림">한국방송통신대학교</a></li>
								<li><a href="https://smart.knou.ac.kr/" target="_blank" title="새창으로 열림">프라임칼리지</a></li>
								<li><a href="https://prime.knou.ac.kr/" target="_blank" title="새창으로 열림">평생교육과정</a></li>
							</ul>
						</div>
						<script>
							$(document).ready(function () {
								// relate_site
								$(".relate_site .title").on("click", function () {
									$(".relate_site").toggleClass("active");
								});
							});
						</script>
					</div>
				</div>
			</footer>
		</div>
	</div>

</body>
</html>
