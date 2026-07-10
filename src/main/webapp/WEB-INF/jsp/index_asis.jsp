<%@page import="com.itextpdf.text.log.SysoCounter" %>
<%@page import="knou.framework.common.MainOrgInfo" %>
<%@page import="org.apache.poi.util.SystemOutLogger" %>
<%@page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
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
    <!-- 
    <link rel="stylesheet" type="text/css" href="/webdoc/css/jquery-ui.css" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/jquery-ui-slider-pips.css" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/footable.standalone.css" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/jquery.mCustomScrollbar.min.css" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/ionicons.css" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/xeicon.min.css" />

    <link rel="stylesheet" type="text/css" href="/webdoc/css/reset.css?v=9" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/element-ui.css?v=24" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/element-ui-dark.css?v=2" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/main_default.css" /> 
    -->

    <link rel="stylesheet" type="text/css" href="/webdoc/css/semantic.css?v=2"/>
    <script type="text/javascript" src="/webdoc/js/jquery.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery-ui.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery.form.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/semantic.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/semantic-ui-calendar.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery.mCustomScrollbar.concat.min.js"></script>

    <!-- 신규 -->
    <%@ include file="WEB-INF/jsp/dm_inc/home_common.jsp" %>
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
    $(function () {
        if ($("#loginForm").length > 0) {
            $("#inputId").focus();
            changeOrg();
        }
    });

    function doLogin(id) {
        if (id != null) {
            $("#inputId").val(id);
            $("#inputPwd").val("1111");
        }

        if ($("#inputId").val().trim() == "") return false;
        if ($("#inputPwd").val().trim() == "") return false;

        $("#orgNm").val($("#orgId option:selected").text());
        $("#loginForm").submit();
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
                            <div id="tab01" class="tab-content">
                                <div class="input_area">
                                    <form class="ui form" id="loginForm" method="POST" action="/loginProc.do"
                                          autocomplete="off">
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
                                        <button type="button" class="login-btn" id="btnLogin" onclick="doLogin();">
                                            LOGIN
                                        </button>
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
                                    <form class="ui form" id="loginForm" method="POST" action="/loginProc.do"
                                          autocomplete="off">
                                        <div class="form-row">
                                            <input id="inputId" class="form-control" type="text" name="id"
                                                   placeholder="아이디를 입력해주세요."/>
                                        </div>
                                        <div class="form-row">
                                            <input id="inputPwd" class="form-control" type="password" name="password"
                                                   placeholder="비밀번호를 입력해주세요."/>
                                        </div>
                                        <button type="button" class="login-btn" id="btnLogin" onclick="doLogin();">
                                            LOGIN
                                        </button>
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
                            // relate_site
                            $(".relate_site .title").on("click", function () {
                                $(".relate_site").toggleClass("active");
                            });
                        });

                        /********** tab-btn **********/
                        $('.tab_btn a').on('click', function (e) {
                            e.preventDefault();

                            // 탭 버튼 current 처리
                            $('.tab_btn a').removeClass('current');
                            $(this).addClass('current');

                            // 연결된 콘텐츠 표시
                            let target = $(this).attr('href');
                            $('.tab-content').hide();
                            $(target).show();
                        });
                    </script>
                </div>
            </div>
        </footer>
    </div>
</div>
</body>
</html>