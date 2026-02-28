<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

	<aside id="gnb" class="common gnb-menu expanded">

		<div class="option-control-wrap">
			<button type="button" class="btn border-0 btn-close ctrl-gnb">
				<i class="icon-svg-close mobile-elem" aria-hidden="true"></i>
				<i class="icon-svg-ctrl-collapse desktop-elem" aria-hidden="true"></i>
				<span class="title">메뉴접기</span>
			</button>
		</div>

		<div class="scrollarea">

			<!-- user info -->
			<div class="user-info">
				<div class="box">
					<div class="user-photo">
						<img src="<%=request.getContextPath()%>/webdoc/assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진">
					</div>
					<a href="#0"><div class="btn-setting"><i class="icon-svg-setting" aria-hidden="true"></i></div></a>
					<div class="user-desc">
						<p class="name">나방송 <span class="prof">학생</span></p>
						<p class="major">마케팅·애널리틱스</p>
					</div>
				</div>
			</div>

			<!-- gnb menu -->
			<nav class="gnb">

				<div class="gnb-item">
					<a href="#0" class="current"><i class="icon-svg-home" aria-hidden="true"></i><span>대시보드</span></a>
				</div>

				<div class="gnb-item">
					<a href="#0" ><i class="icon-svg-user-circle" aria-hidden="true"></i><span>프로필</span></a>
				</div>

				<div class="gnb-item">
					<a href="#0" ><i class="icon-svg-inbox" aria-hidden="true"></i><span>메시지함</span></a>
				</div>

				<div class="gnb-item">
					<a href="#0" ><i class="icon-svg-notice" aria-hidden="true"></i><span>공지사항</span></a>
				</div>

				<div class="gnb-item">
					<a href="#0" ><i class="icon-svg-question" aria-hidden="true"></i><span>강의Q&A</span></a>
				</div>

				<div class="gnb-item">
					<a href="#0" ><i class="icon-svg-save" aria-hidden="true"></i><span>강의자료실</span></a>
				</div>

				<div class="gnb-item">
					<a href="#0" ><i class="icon-svg-file" aria-hidden="true"></i><span>강의계획서</span></a>
				</div>

				<div class="gnb-item">
					<a href="#0" ><i class="icon-svg-book-open" aria-hidden="true"></i><span>나의수업현황</span></a>
				</div>

				<div class="gnb-item">
					<a href="#0" ><i class="icon-svg-file-check" aria-hidden="true"></i><span>강의평가</span></a>
				</div>

				<div class="gnb-item">
					<a href="#0" ><i class="icon-svg-pie-chart" aria-hidden="true"></i><span>나의성적</span></a>
				</div>

				<div class="gnb-item">
					<a href="#0" ><i class="icon-svg-check-done" aria-hidden="true"></i><span>일반설문</span></a>
				</div>

				<div class="gnb-item">
					<a href="#0" ><i class="icon-svg-building" aria-hidden="true"></i><span>U-KNOU</span></a>
				</div>

			</nav>
			<!-- //gnb menu -->

		</div>

	</aside>
