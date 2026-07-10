<%@page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@page import="com.itextpdf.text.log.SysoCounter" %>
<%@page import="knou.framework.common.MainOrgInfo" %>
<%@page import="org.apache.poi.util.SystemOutLogger" %>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@page import="org.springframework.context.i18n.LocaleContextHolder" %>
<%@page import="knou.lms.org.service.OrgInfoService" %>
<%@page import="knou.lms.org.vo.OrgInfoVO" %>
<%@page import="knou.framework.util.StringUtil" %>
<%@page import="knou.framework.common.CommConst" %>
<%@page import="java.util.Locale" %>
<%@page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="/WEB-INF/jsp/common/common.jsp" %>

<html lang="ko">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">

    <link rel="shortcut icon" href="/favicon.ico"/>
    <title>KNOU-<spring:message code="common.label.classroom"/> [<%=CommConst.SERVER_NAME%>]</title>

    <link rel="stylesheet" type="text/css" href="/webdoc/css/semantic.css?v=2"/>
    <script type="text/javascript" src="/webdoc/js/jquery.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery-ui.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery.form.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/semantic.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/semantic-ui-calendar.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery.mCustomScrollbar.concat.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/sso/popup_util_0.0.3.js"></script>

	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="module" value="table"/>
	</jsp:include>

    <%@ include file="/WEB-INF/jsp/common_new/home_common.jsp" %>
    <link rel="stylesheet" type="text/css" href="/webdoc/dm_assets/css/login.css"/>

    <style>
        #loading_page {
            display: none;
        }

        .flex-container .cont-none .text {
            color: #000;
        }

        .dark .flex-container .cont-none .text {
            color: #fff;
        }
    </style>
</head>

<script type="text/javascript">
    // 현재 선택된 탭 정보 상태값 관리 (STUDENT: 방송대생/직원, GENERAL: 일반회원)
    var currentTab = "STUDENT";

    $(function () {
        if (window.self !== window.top) {
        	window.top.location.href = "/";
        }

    	if ($("#inputId").length > 0) {
            $("#inputId").focus();
        }
    });

    // 탭이 바뀔 때 백엔드가 인식할 'name' 속성을 가진 Input을 동적으로 교체합니다.
    function changeTab(type) {
        currentTab = type;

        if (type === "STUDENT") {
            $("#orgId").val("<%=CommConst.KNOU_ORG_ID%>");

            // 학생 탭 인풋에 name 매핑 활성화, 일반 탭 인풋 name 제거
            $("#inputId").attr("name", "userId");
            $("#inputPwd").attr("name", "userIdEncpswd");
            $("#inputIdGeneral").removeAttr("name");
            $("#inputPwdGeneral").removeAttr("name");

            $("#inputId").focus();
        } else {
            $("#orgId").val("");

            // 일반 탭 인풋에 name 매핑 활성화, 학생 탭 인풋 name 제거
            $("#inputIdGeneral").attr("name", "userId");
            $("#inputPwdGeneral").attr("name", "userIdEncpswd");
            $("#inputId").removeAttr("name");
            $("#inputPwd").removeAttr("name");

            $("#inputIdGeneral").focus();
        }
    }

    // 로그인 실행 및 유효성 검사 함수
    function doLogin() {
        var idVal = "";
        var pwdVal = "";

        // 현재 활성화된 탭의 입력값을 체크
        if (currentTab === "STUDENT") {
            idVal = $("#inputId").val().trim();
            pwdVal = $("#inputPwd").val().trim();
        } else {
            idVal = $("#inputIdGeneral").val().trim();
            pwdVal = $("#inputPwdGeneral").val().trim();
        }

        if (idVal == "") {
            alert("아이디를 입력해주세요.");
            if (currentTab === "STUDENT") $("#inputId").focus();
            else $("#inputIdGeneral").focus();
            return false;
        }
        if (pwdVal == "") {
            alert("비밀번호를 입력해주세요.");
            if (currentTab === "STUDENT") $("#inputPwd").focus();
            else $("#inputPwdGeneral").focus();
            return false;
        }

        // 최종 매핑된 하나의 form 전송
        $("#loginForm").attr("action", "/loginProc.do").submit();
    }

 	// 로그인 실행 및 유효성 검사 함수
    // → 검증 후 id/pw 를 2차 인증 공통 다이얼로그(UiDialog)로 전달
    function doLogin2() {
        var idVal = "";
        var pwdVal = "";

        // 현재 활성화된 탭의 입력값을 체크
        if (currentTab === "STUDENT") {
            idVal = $("#inputId").val().trim();
            pwdVal = $("#inputPwd").val().trim();
        } else {
            idVal = $("#inputIdGeneral").val().trim();
            pwdVal = $("#inputPwdGeneral").val().trim();
        }

        if (idVal == "") {
            alert("아이디를 입력해주세요.");
            if (currentTab === "STUDENT") $("#inputId").focus();
            else $("#inputIdGeneral").focus();
            return false;
        }
        if (pwdVal == "") {
            alert("비밀번호를 입력해주세요.");
            if (currentTab === "STUDENT") $("#inputPwd").focus();
            else $("#inputPwdGeneral").focus();
            return false;
        }

     	// 2차 인증 화면을 공통 다이얼로그(UiDialog)로 띄움
        // preLogin.do 가 GET 으로 id/pw 를 받아 EP→LMS 1차 검증 후 화면 표시
        var param = "userId=" + encodeURIComponent(idVal)
                  + "&userIdEncpswd=" + encodeURIComponent(pwdVal)
                  + "&orgId=" + encodeURIComponent($("#orgId").val());

        var dialog = UiDialog("twoFactorDialog", {
            title: "2단계 인증",
            width: 1200,
            height: 800,
            url: "/preLogin.do?" + param,
            autoresize: false
        });
    }

    var TWOFA_API_BASE = ""; // 같은 도메인이면 "" 로
    var TWOFA_VIEW_URL = "https://mauth.knou.ac.kr/passkey/view/auth"; // 새 창 인증 페이지 (벤더 사양 확인)

    async function openSecondAuth() {

    	var pu = new popup_util();

    	// 현재 활성 탭의 아이디 사용
        var userId = (currentTab === "GENERAL")
            ? $("#inputIdGeneral").val().trim()
            : $("#inputId").val().trim();

        if (userId === "") {
            alert("아이디를 입력해주세요.");
            return;
        }

        try {
            // 1) 우리 서버 래퍼 호출 → challenge 발급
            var res = await fetch(TWOFA_API_BASE + "/api/2fa/option.do", {
			    method: "POST",
			    headers: { "Content-Type": "application/json" },
			    credentials: "include",
			    body: JSON.stringify({ userId: userId })
			});

			// 응답이 정상(2xx)인지 + JSON인지 먼저 확인
			if (!res.ok) {
			    alert("서버 오류 (HTTP " + res.status + "). 엔드포인트가 등록되지 않았을 수 있습니다.");
			    return;
			}
			var ct = res.headers.get("content-type") || "";
			if (ct.indexOf("application/json") === -1) {
			    alert("서버가 JSON이 아닌 응답을 반환했습니다. (경로/매핑 확인 필요)");
			    return;
			}
            var data = await res.json();
            if (!data.ok) {
                alert(data.message || "세션 토큰 발급 실패");
                return;
            }
            var challenge = data.challenge;

            // 2) challenge 로 새 창 인증
            var url = TWOFA_VIEW_URL + "?token=" + encodeURIComponent(challenge);
            var t = await pu.open(url, 480, 540, null);
            console.log("result:", t.result, "token:", t.token, "type:", t.type);

            // 3) 결과 처리 (postMessage 결과는 신뢰하지 말고 백엔드 재검증 권장)
            if (String(t.result) === "1" || String(t.result) === "2") {
                alert("2차 인증 성공");
                // location.href = "/main.do";
            } else {
                alert("2차 인증 실패 (result=" + t.result + ")");
            }
        } catch (err) {
            if (err && err.result === -999) {
                alert("팝업이 차단되었습니다. 팝업 허용 후 다시 시도해주세요.");
            } else if (err && err.result === -1) {
                console.log("사용자가 팝업을 닫음");
            } else {
                console.error(err);
                alert("2차 인증 처리 중 오류가 발생했습니다.");
            }
        }
    }
</script>
<body>
<div id="login_wrap">
    <div class="login_box">
        <div class="box_wrap">
            <div class="left_box">
                <div class="left_box_img"><img src="/webdoc/dm_assets/img/logo_symbol.png" alt="한국방송통신대학교 로고"/></div>
            </div>
            <div class="right_box">
                <div class="login_content">
                    <div class="login_logo"><img src="/webdoc/dm_assets/img/logo.svg" alt="한국방송통신대학교"/></div>
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

                            <form class="ui form" id="loginForm" method="POST" action="/loginProc.do" autocomplete="off">
                                <input type="hidden" id="orgnm" name="orgnm" value=""/>
                                <input type="hidden" id="orgId" name="orgId" value="<%=CommConst.KNOU_ORG_ID%>"/>

                                <div id="tab01" class="tab-content">
                                    <div class="input_area">
                                        <div class="form-row">
                                            <input id="inputId" class="form-control" type="text" name="userId"
                                                   onkeypress="if(event.keyCode==13){doLogin();return false}"
                                                   placeholder="아이디를 입력해주세요."/>
                                        </div>
                                        <div class="form-row">
                                            <input id="inputPwd" class="form-control" type="password" name="userIdEncpswd"
                                                   onkeypress="if(event.keyCode==13){doLogin();return false}"
                                                   placeholder="비밀번호를 입력해주세요."/>
                                        </div>
                                        <button type="button" class="login-btn" id="btnLoginA" onclick="doLogin();">
                                            LOGIN
                                        </button>
                                        <!-- &nbsp;
                                        <button type="button" class="login-btn" id="btnLoginA" onclick="doLogin2();">
                                            LOGIN2
                                        </button> -->
                                        <div class="link-box">
                                            <p>
												<span class="custom-input">
													<input type="checkbox" name="autoLoginA" id="autoLabelA">
													<label for="autoLabelA">자동 로그인</label>
												</span>
                                            </p>
                                        </div>
                                    </div>
                                </div>

                                <div id="tab02" class="tab-content" style="display:none;">
                                    <div class="input_area">
                                        <div class="form-row">
                                            <input id="inputIdGeneral" class="form-control" type="text"
                                                   onkeypress="if(event.keyCode==13){doLogin();return false}"
                                                   placeholder="아이디를 입력해주세요."/>
                                        </div>
                                        <div class="form-row">
                                            <input id="inputPwdGeneral" class="form-control" type="password"
                                                   onkeypress="if(event.keyCode==13){doLogin();return false}"
                                                   placeholder="비밀번호를 입력해주세요."/>
                                        </div>
                                        <button type="button" class="login-btn" id="btnLoginB" onclick="doLogin();">
                                            LOGIN
                                        </button>
                                        <div class="link-box">
                                            <p>
												<span class="custom-input">
													<input type="checkbox" name="autoLoginB" id="autoLabelB">
													<label for="autoLabelB">자동 로그인</label>
												</span>
                                            </p>
                                            <p class="link_txt">
                                                <a href="#0">회원가입</a>
                                                <a href="#0">아이디/비밀번호 찾기</a>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </form>

                        </div>
                    </div>
                    <%--
                    <div class="sns_wrap">
                        <div class="sns_pc"><div class="sns_title">
                                <div class="title">SNS 로그인</div>
                                <div class="desc">회원가입을 하신 후 SNS계정으로 로그인 하세<a href="#0" onclick="openSecondAuth(); return false;" style="color:inherit; text-decoration:none; cursor:default;">요</a>.</div>
                            </div>
                            <div class="sns_btns">
                                <a href="#0" class="btn kakao" aria-label="카카오 로그인"></a>
                                <a href="#0" class="btn naver" aria-label="네이버 로그인"></a>
                            </div>
                        </div>
                        <div class="sns_mo"><div class="sns_title">
                                <div class="title">다른방법으로 로그인</div>
                            </div>
                            <div class="sns_btns">
                                <a href="#0" class="btn"><i class="i-kakao"></i>카카오 로그인</a>
                                <a href="#0" class="btn"><i class="i-naver"></i>네이버 로그인</a>
                                <a href="#0" class="btn"><i class="icon-svg-passcode"></i>간편비밀번호</a>
                                <a href="#0" class="btn"><i class="icon-svg-fingerprint"></i>지문인식</a>
                            </div>
                        </div>
                        <div class="button-area">
						    <*-- <a id="ssoLoginBtn" href="/sso/CreateRequest.jsp"
						       title="<spring:message code="common.label.sso_login"/>"
						       class="ui fluid large button mt10 sso">
						        <spring:message code="common.label.sso_login"/>
						    </a> --*>
						</div>
                    </div>
                    --%>
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
                        <a href="#" class="title" title="교내 사이트 열기">교내 사이트<i class="xi-caret-down-min"
                                                                             aria-hidden="true"></i></a>
                        <ul class="list">
                            <li><a href="https://www.knou.ac.kr/" target="_blank" title="새창으로 열림">한국방송통신대학교</a></li>
                            <li><a href="https://smart.knou.ac.kr/" target="_blank" title="새창으로 열림">프라임칼리지</a></li>
                            <li><a href="https://prime.knou.ac.kr/" target="_blank" title="새창으로 열림">평생교육과정</a></li>
                        </ul>
                    </div>
                    <script>
                        $(document).ready(function () {
                       	    // [로그인 화면 진입 시 실행]
                       	    // 브라우저가 기억하고 있던 과거 관리자 메뉴의 모든 잔재를 완벽하게 삭제합니다.
                       	    sessionStorage.removeItem("LAST_ADMIN_TOP_MENU_ID");
                       	    sessionStorage.removeItem("LAST_ADMIN_MENU_ID");
                       	    sessionStorage.removeItem("LAST_ADMIN_TOP_MENU_NM");

                            // relate_site
                            $(".relate_site .title").on("click", function () {
                                $(".relate_site").toggleClass("active");
                            });
                        });

                        /********** tab-btn 스위칭 및 상태 연동 **********/
                        $('.tab_btn a').on('click', function (e) {
                            e.preventDefault();

                            // 탭 버튼 current 클래스 제어
                            $('.tab_btn a').removeClass('current');
                            $(this).addClass('current');

                            // 연결된 콘텐츠 토글
                            let target = $(this).attr('href');
                            $('.tab-content').hide();
                            $(target).show();

                            // 상단 자바스크립트의 name 동적 스위칭 함수 호출
                            if (target === "#tab01") {
                                changeTab("STUDENT");
                            } else {
                                changeTab("GENERAL");
                            }
                        });
                    </script>
                </div>
            </div>
        </footer>
    </div>
</div>
</body>
</html>