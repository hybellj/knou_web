<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!-- Header 영역 부분 -->
<header>
    <div class="inner">
        <a href="#0" class="menu-btn">
            <span class="barTop"></span>
            <span class="barMid"></span>
            <span class="barBot"></span>
        </a>
        <h1 class="logo">
            <a href="/">
                <img class="main_logo" src="/webdoc/img/logo.png" alt="LMS">
            </a>
        </h1>
        <div class="h_option">
            <label for="insti_box" class="hide">소속기관</label>
            <select class="ui dropdown select_sm" id="insti_box" name="insti_box">
                <option value="전체">전체</option>
                <option value="대학원">대학원</option>
                <option value="대학교">대학교</option>
            </select>
        </div>
        <ul class="util">
            <li class="mail ui dropdown"> <!--  ui dropdown 클래스 추가_230106 -->
                <a href="#0"><i class="ion-ios-email-outline"></i></a>
                <label class="count">2</label>

                <div class="menu">  <!--  dropdown에 해당하는 menu 추가_230106 -->
                    <div class="item">
                        <a href="#0">test</a>
                    </div>
                    <div class="divider m0"></div>
                    <div class="item">
                        <a href="#0">test test test</a>
                    </div>
                    <div class="divider m0"></div>
                    <div class="item">
                        <a href="#0">test</a>
                    </div>
                </div>

            </li>
            <li class="alrim ui dropdown"> <!--  ui dropdown 클래스 추가_230106 -->
                <a href="#0"><i class="ion-ios-bell-outline"></i></a>
                <label class="count">2</label>

                <div class="menu">  <!--  dropdown에 해당하는 menu 추가_230106 -->
                    <div class="item">
                        <a href="#0">test TEST</a>
                    </div>
                    <div class="divider m0"></div>
                    <div class="item">
                        <a href="#0">test</a>
                    </div>
                </div>
                
            </li>
            <li class="user-img ui dropdown">
                <div class="initial-img sm c-4">석현</div>
                <div class="menu">
                    <div class="item profile">
                        <div class="initial-img sm c-4">석현</div>
                        <ul>
                            <li>김석현 (prof1)</li>
                            <li><a href="#0" class="link">프로필 관리</a></li>
                        </ul>
                    </div>
                    <div class="divider m0"></div>
                    <div class="item"><a href="#0"><i class="user circle icon"></i>마이페이지</a></div>
                    <div class="divider m0"></div>
                    <div class="item"><a href="/user/userHome/logout.do"><i class="sign-out icon"></i>로그아웃</a></div>
                </div>
            </li>
            <script>
                /********** 화면 비율 Controller **********/
                var nowZoom = 100;

                function zoomOut() {
                    nowZoom = nowZoom - 10;
                    if (nowZoom <= 80) nowZoom = 80;
                    zooms();
                }

                function zoomIn() { // 화면크기확대
                    nowZoom = nowZoom + 10;
                    if (nowZoom >= 120) nowZoom = 120;
                    zooms();
                }

                function zoomReset() {
                    nowZoom = 100;
                    zooms();
                }

                function zooms() {
                    document.body.style.zoom = nowZoom + "%";
                }
            </script>
        </ul>
    </div>
    <!-- 통합 메시지폼 -->
	<form id="alarmForm" name="alarmForm" method="post" style="position:absolute;left:1000">
		<input type="hidden" name="rcvUserInfoStr" />
		<input type="hidden" name="sysCd" value="LMS" />
		<input type="hidden" name="orgId" value="KNOU" />
		<input type="hidden" name="bussGbn" value="LMS" />
		<input type="hidden" name="alarmType" value="S"/>
	</form>
</header>