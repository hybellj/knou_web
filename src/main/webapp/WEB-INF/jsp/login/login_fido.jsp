<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="knou.framework.common.CommConst" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%--
  login_fido.jsp  (2차 인증 화면, 구 total-login-ver04.jsp)

  진입: index.jsp → GET /preLogin.do (EP/LMS 1차 검증) → 이 화면
  전달값:
    - userId  : 1차에서 확인된 아이디
    - userSrc : "EP" | "LMS"

  탭: 모바일 인증 / 아이디 / 인증서 / 패스키

  [아이디 탭] id/pw 입력 후 로그인 → POST /loginProc.do
             → 서버: processLogin() → SSO LOGIN API 호출 (벤더 키트 연결 후 활성화)
--%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>로그인-한국방송통신대학교 2단계 인증 [<%=CommConst.SERVER_NAME%>]</title>
    <link rel="shortcut icon" href="https://www.knou.ac.kr/favicon_new.ico">
    <link type="text/css" href="https://ep.knou.ac.kr/css/core/flick/jquery-ui-1.8.6.custom.css" rel="stylesheet">
    <link href="https://ep.knou.ac.kr/css/core/jquery.dialog.css?ver=20110113" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="https://ep.knou.ac.kr/js/core/jquery-1.4.3.min.js"></script>
    <script type="text/javascript" src="https://ep.knou.ac.kr/js/core/jquery.knouDialog.js?ver=20110109"></script>
    <script type="text/javascript" src="https://ep.knou.ac.kr/js/core/jquery-ui-1.8.6.custom.min.js"></script>

    <%-- 패스키 팝업 호출용 라이브러리 (mSABER 제공) --%>
    <script type="text/javascript" src="/webdoc/js/sso/popup_util_0.0.3.js"></script>

    <link rel="stylesheet" href="https://ep.knou.ac.kr/css/reset.css">
    <link rel="stylesheet" href="/webdoc/dm_assets/css/style-ver04.css">
</head>

<body>

<%-- preLogin 에서 넘어온 값 --%>
<input type="hidden" id="preUserId" value="${userId}"/>
<input type="hidden" id="preUserSrc" value="${userSrc}"/>

<%--
  ★ 아이디 탭 로그인 폼
     id/pw 검증 후 이 폼을 POST /loginProc.do 로 전송.
     loginProc.do 서버에서:
       1) EP→LMS processLogin()
       2) [SSO LOGIN API 호출] ← 벤더 키트(sso_config.jsp + jar) 도착 후 연결
       3) apply/sid redirect → 대시보드
--%>
<form id="idLoginForm" method="POST" action="/loginProc.do">
    <input type="hidden" id="form_userId"        name="userId"        value="${userId}"/>
    <input type="hidden" id="form_userIdEncpswd" name="userIdEncpswd" value=""/>
    <input type="hidden" id="form_orgId"         name="orgId"         value='<c:choose><c:when test="${userSrc eq &quot;EP&quot;}"><%=CommConst.KNOU_ORG_ID%></c:when><c:otherwise></c:otherwise></c:choose>'/>
</form>

<div class="container-main">
    <div class="logo">
        <a href="https://www.knou.ac.kr">
            <img src="https://www.knou.ac.kr/sites/knou/images/logo-header25.png"
                 alt="국립 한국방송통신대학교 Korea National Open University">
        </a>
    </div>

    <div class="total-login">

        <div class="tabs">
            <input type="radio" name="login_tab" id="tab_mobile" data-tab="mobile" value="MOBILE" checked>
            <label for="tab_mobile" tabindex="0">모바일 인증</label>

            <input type="radio" name="login_tab" id="tab_id" data-tab="id" value="WEB">
            <label for="tab_id" tabindex="0">아이디</label>

            <input type="radio" name="login_tab" id="tab_cert" data-tab="cert" value="PKI" class="mobile-hide">
            <label class="mobile-hide" for="tab_cert">인증서</label>

            <input type="radio" name="login_tab" id="tab_passkey" data-tab="passkey" value="PASS" class="mobile-hide">
            <label class="mobile-hide" for="tab_passkey">패스키</label>
        </div>

        <div class="tab-inner">

            <!-- 모바일 -->
            <div class="tab-panel active">
                <div class="content">
                    <div class="section">
                        <h3>모바일 인증 로그인</h3>
                        <div class="input-box"><input id="mobileId" placeholder="아이디"></div>
                        <div class="checkbox">
                            <input type="checkbox" id="saveId-mobile-qr">
                            <label for="saveId-mobile-qr"><span>아이디저장</span></label>
                        </div>
                    </div>
                </div>
                <div class="mobile-btns">
                    <button class="btn mobile-open">모바일 인증</button>
                    <button class="btn qr-open mobile-hide">QR코드 인증</button>
                </div>
            </div>

            <!-- 아이디 탭 -->
            <div class="tab-panel">
                <div class="content">
                    <div class="section min-w">
                        <h3>아이디 로그인</h3>
                        <%-- 아이디: preLogin 에서 넘어온 값으로 채워짐 (읽기전용) --%>
                        <div class="input-box">
                            <input type="text" id="knouId" placeholder="아이디 입력" readonly>
                        </div>
                        <%-- 비밀번호: 이 화면에서 직접 입력 --%>
                        <div class="input-box">
                            <input type="password" id="knouPw" placeholder="비밀번호 입력"
                                   onkeypress="if(event.keyCode==13){doIdLogin();return false}">
                        </div>
                        <div class="checkbox">
                            <input type="checkbox" id="saveId-id">
                            <label for="saveId-id"><span>아이디저장</span></label>
                        </div>
                        <%-- 로그인 버튼 → doIdLogin() → POST /loginProc.do --%>
                        <button class="btn mt14" onclick="doIdLogin();">로그인</button>
                    </div>
                </div>
            </div>

            <!-- 인증서 -->
            <div class="tab-panel">
                <div class="content">
                    <div class="section min-w">
                        <h3>인증서 로그인</h3>
                        <div class="ico-align">
                            <img src="https://ep.knou.ac.kr/images/login-ico.png" alt="인증서 아이콘">
                        </div>
                        <button class="btn">공동인증서 로그인</button>
                    </div>
                </div>
            </div>

            <!-- 패스키 -->
            <div class="tab-panel">
                <div class="content">
                    <div class="section min-w">
                        <h3>패스키 로그인</h3>
                        <div class="input-box"><input id="passId" placeholder="아이디"></div>
                        <div class="checkbox">
                            <input type="checkbox" id="saveId-pass">
                            <label for="saveId-pass"><span>아이디저장</span></label>
                        </div>
                        <button class="btn pass-btn">패스키 인증</button>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <div class="find">
        <a href="#link" id="href_idwrite" class="btn-id-find"><span>ID 등록</span></a>
        <a href="#link" id="href_stnoIdPwdFind" class="btn-id-find"><span>학번·ID·비밀번호 찾기</span></a>
        <a href="#link" class="btn-more"><span>도움말</span></a>
    </div>

    <div class="info" id="infoText"></div>

</div>

<!-- 모바일 인증 모달 -->
<div class="modal" id="mobileModal">
    <div class="modal-card">
        <button class="modal-close mobile-close">×</button>
        <h2>모바일 인증 로그인</h2>
        <p class="desc">방송대 통합인증 앱에서<br>모바일 인증(생체, 패턴, PIN번호)을 진행해 주세요.</p>
        <div class="divider divider-lg"></div>
        <div class="modal-icon">
            <img src="https://www.knou.ac.kr/sites/eist/images/guide/ico-mobile.png" alt="모바일인증 아이콘">
        </div>
        <div class="timer">
            <img src="https://www.knou.ac.kr/sites/eist/images/guide/ico-time.png" alt="시계 아이콘">
            남은 시간 : <span id="mobileTime" class="red">3분 00초</span>
        </div>
        <p class="desc mt12" id="mobileStatusMsg">모바일 인증이 완료되면 자동으로 로그인됩니다.</p>
        <div class="modal-actions">
            <button type="button" class="btn" id="mobileAuthCompleteBtn">인증 완료 확인</button>
        </div>
    </div>
</div>

<!-- QR 모달 -->
<div class="modal" id="qrModal">
    <div class="modal-card">
        <button class="modal-close qr-close">×</button>
        <h2>QR 로그인</h2>
        <p class="desc">방송대 통합인증 앱에서 아래 QR코드를 스캔해주세요.</p>
        <div class="divider divider-lg"></div>
        <div class="modal-body">
            <div class="Qr-img"><img src="https://www.knou.ac.kr/sites/eist/images/guide/QR-eximg.png" alt="QR-샘플이미지"></div>
        </div>
        <div class="timer">
            <img src="https://www.knou.ac.kr/sites/eist/images/guide/ico-time.png" alt="시계 아이콘">
            남은 시간 : <span id="qrTime" class="red">2분 55초</span>
        </div>
        <p class="desc mt12">QR코드 인증이 완료되면 [인증 완료] 버튼을 클릭해주세요.</p>
        <div class="modal-actions">
            <button class="btn">인증 완료</button>
            <button class="btn light-btn">QR코드 갱신</button>
        </div>
    </div>
</div>

<!-- 아이디 로그인 추가인증 모달 (OTP - 향후 연동) -->
<div class="modal" id="idLoginModal">
    <div class="modal-card">
        <button class="modal-close id-close">×</button>
        <h2>추가 인증</h2>
        <div class="divider divider-sm"></div>
        <div class="modal-body">
            <span class="modal-h4">아이디</span>
            <div class="input-box mb20">
                <input type="text" id="modalUserId" placeholder="아이디" disabled>
            </div>
            <div class="auth-row">
                <div class="auth-label">인증번호확인방법 <span>*</span></div>
                <div class="auth-options">
                    <label><input type="radio" name="modalAuth" checked> 이메일</label>
                    <label><input type="radio" name="modalAuth"> 방송대 통합인증 앱</label>
                </div>
            </div>
            <div class="auth-input">
                <input type="text" id="modalEmail" placeholder="이메일">
                <button class="btn-send">인증번호 전송</button>
            </div>
            <div class="input-box mb10">
                <input type="text" placeholder="인증번호 입력">
            </div>
            <button class="btn mt14">인증 확인</button>
            <div class="box-Browser browser-check">
                <input type="checkbox" id="modalBrowser">
                <label for="modalBrowser">이 브라우저에서 추가 인증 사용 안함</label>
            </div>
        </div>
    </div>
</div>

<script>
    // ============================================================
    // 아이디 탭 로그인 → fetch POST /loginProc.do
    //   성공: 팝업(다이얼로그) 닫기 + 부모창 대시보드로 이동
    //   실패: 오류 메시지 표시
    // ============================================================
    function doIdLogin() {
        var userId = $("#knouId").val().trim();
        var pw     = $("#knouPw").val().trim();

        if (!userId) {
            alert("아이디를 입력해주세요.");
            $("#knouId").focus();
            return false;
        }
        if (!pw) {
            alert("비밀번호를 입력해주세요.");
            $("#knouPw").focus();
            return false;
        }

        // FormData 로 POST 구성
        var formData = new FormData();
        formData.append("userId",        userId);
        formData.append("userIdEncpswd", pw);
        formData.append("orgId",         $("#form_orgId").val());

        fetch("/loginProc.do", {
            method: "POST",
            headers: { "X-Requested-With": "XMLHttpRequest" },  // Ajax 식별용
            credentials: "include",
            body: formData
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.ok) {
                // 로그인 성공 → 부모창 이동 + 팝업(다이얼로그) 닫기
                if (window.parent && window.parent !== window) {
                    // UiDialog(iframe) 환경
                    window.parent.location.href = data.redirectUrl;
                } else if (window.opener && !window.opener.closed) {
                    // window.open 팝업 환경
                    window.opener.location.href = data.redirectUrl;
                    window.close();
                } else {
                    // 일반 환경(직접 접근 등)
                    window.location.href = data.redirectUrl;
                }
            } else {
                alert(data.message || "로그인에 실패했습니다.");
            }
        })
        .catch(function(err) {
            console.error("[loginProc] 오류:", err);
            alert("로그인 처리 중 오류가 발생했습니다.");
        });
    }

    // ============================================================
    // 팝업/다이얼로그 환경 처리
    // UiDialog 안에서 loginProc.do 가 redirect 를 내려도
    // 다이얼로그 컨텍스트에서 처리됩니다.
    // ============================================================

    const infoText = document.getElementById("infoText");

    const infoMessages = {
        mobile: [
            {
                title: "모바일 인증 로그인이란?",
                text: "방송대 통합인증 앱을 이용하여 모바일에 등록된 생체정보(지문, 페이스), 패턴, PIN 번호 인증 또는 QR코드 스캔을 통해 비밀번호 없이 로그인할 수 있습니다. 모바일 인증을 이용 하시려면 방송대 통합인증 앱 설치가 필요합니다.",
                link: "https://"
            },
            {
                title: "모바일 인증 절차",
                text: "① 모바일 인증 버튼 클릭 ② 방송대 통합인증 앱에서 생체인증, 패턴, PIN 중 선택하여 인증 ③ 인증완료 버튼 클릭",
                link: "https://"
            },
            {
                title: "QR코드 인증 절차",
                text: "① QR 코드 인증 버튼 클릭 ② 방송대 통합인증 앱에서 QR코드 스캔 ③ 인증완료 버튼 클릭",
                link: "https://",
                type: "qr",
                className: "mobile-hide"
            }
        ],
        id: {
            title: "아이디 로그인이란?",
            text: "아이디와 비밀번호를 입력 후 이메일 또는 방송대 통합인증 앱을 통해 전송된 인증번호(OTP번호)를 추가로 입력(인증)하여 로그인할 수 있습니다.",
            link: "https://"
        },
        cert: {
            title: "인증서 로그인 안내",
            text: "EPKI 또는 공동인증서를 이용하여 로그인할 수 있는 기능입니다. 인증서 로그인을 위해서는 인증서 등록이 필요합니다.",
            link: "https://"
        },
        passkey: {
            title: "패스키 로그인이란?",
            text: "PC에 등록된 지문, 얼굴 스캔 또는 PIN번호 입력으로 간편하고 안전하게 로그인 할 수 있는 기능입니다. 패스키 로그인을 위해서는 패스키 등록이 필요합니다.",
            link: "https://"
        }
    };

    function createInfoItem(item) {
        var cls = item.className || '';
        var linkHtml = item.link
            ? '<a href="' + item.link + '" class="info-more" target="_blank">자세히보기 +</a>'
            : '';
        return ''
            + '<div class="info-inner ' + cls + '">'
            + '  <span class="info-icon"></span>'
            + '  <div class="info-content">'
            + '    <div class="info-title-row">'
            + '      <strong class="info-title">' + item.title + '</strong>'
            +        linkHtml
            + '    </div>'
            + '    <p class="info-text">' + item.text + '</p>'
            + '  </div>'
            + '</div>';
    }

    function renderInfo(key) {
        var data = infoMessages[key];
        var items = Array.isArray(data) ? data : [data];
        if (key === "mobile") {
            infoText.innerHTML = ''
                + '<div class="mobile-info-grid">'
                + '  <div>' + createInfoItem(items[0]) + '</div>'
                + '  <div class="mobile-info-right">'
                +      createInfoItem(items[1])
                +      createInfoItem(items[2])
                + '  </div>'
                + '</div>';
        } else {
            infoText.innerHTML = items.map(function(item) { return createInfoItem(item); }).join('');
        }
    }

    /* 탭 변경 감지 */
    const radioTabs = document.querySelectorAll(".tabs input[name='login_tab']");
    const panels    = document.querySelectorAll(".tab-panel");

    radioTabs.forEach(function(radio, index) {
        radio.addEventListener("change", function() {
            panels.forEach(function(p) { p.classList.remove("active"); });
            panels[index].classList.add("active");
            renderInfo(radio.dataset.tab);
        });
    });

    /* 모달 닫기 */
    document.querySelectorAll(".modal-close").forEach(function(btn) {
        btn.addEventListener("click", function() {
            btn.closest(".modal").classList.remove("active");
        });
    });
    document.querySelectorAll(".modal").forEach(function(modal) {
        modal.addEventListener("click", function(e) {
            if (e.target === modal) modal.classList.remove("active");
        });
    });

    /* jQuery 초기화 */
    $(function () {
        // preLogin 에서 넘어온 아이디 자동 채움
        var preUserId = $("#preUserId").val();
        if (preUserId) {
            $("#mobileId").val(preUserId);
            $("#knouId").val(preUserId);
            $("#passId").val(preUserId);
            $("#modalUserId").val(preUserId);
        }

        // 모바일 인증 버튼
        $(".mobile-open").click(function () {
            var mobileId = $("#mobileId").val();
            if (!mobileId || mobileId.trim() === "") {
                $.knouDialog.alert("알림", "ID를 입력하세요.", function() { $("#mobileId").focus(); });
                return false;
            }
            startMobileAuth(mobileId.trim());
        });

        // QR 버튼
        $(".qr-open").click(function () {
            document.getElementById("qrModal").classList.add("active");
        });

        // 패스키 인증 버튼 → 패스키 로그인 흐름 시작
        $(".pass-btn").click(function () {
            var passId = $("#passId").val();
            if (!passId || passId.trim() === "") {
                $.knouDialog.alert("알림", "ID를 입력하세요.", function() { $("#passId").focus(); });
                return false;
            }
            doPasskeyAuth(passId.trim());
        });
    });

    // ============================================================
    // 패스키 인증 로그인
    //   1) /passkey/auth/option.do  → token(challenge) 발급
    //   2) popup_util 로 /passkey/view/auth?token=... 팝업
    //   3) 콜백 result=1 → /passkey/auth/verify.do → 최종 검증
    //   4) 성공 → loginProc(SSO 자리) → 부모창 이동
    // ============================================================
    function doPasskeyAuth(userId) {
        // 1) 세션토큰(challenge) 발급 요청
        // ※ jQuery 1.4.3 은 Deferred(.done/.fail) 미지원 → success/error 콜백 사용
        $.ajax({
            url: "/passkey/auth/option.do",
            type: "POST",
            data: { ud : userId },
            dataType: "json",
            success: function (res) {
                if (!res || res.result != 1 || !res.token) {
                    alert((res && res.msg) ? res.msg : "패스키 세션 토큰 발급 실패");
                    return;
                }
                var token = res.token;

                // 2) 패스키 인증 팝업 호출
                var url = "https://mauth.knou.ac.kr/passkey/view/auth?token=" + encodeURIComponent(token);
                var pu = new popup_util();
                pu.open(url, 480, 540, null)
                    .then(function (t) {
                        // t.result(1:성공), t.token, t.type(2:인증)
                        if (String(t.result) !== "1") {
                            alert("패스키 인증에 실패했거나 취소되었습니다. (result=" + t.result + ")");
                            return;
                        }
                        // 3) 백엔드 최종 검증
                        verifyPasskeyAuth(t.token, userId);
                    })
                    .catch(function (err) {
                        if (err && err.result === -999) {
                            alert("팝업이 차단되었습니다. 팝업 허용 후 다시 시도해주세요.");
                        } else if (err && err.result === -1) {
                            // 사용자가 팝업 닫음
                        } else {
                            console.error("[passkey] popup error:", err);
                            alert("패스키 인증 처리 중 오류가 발생했습니다.");
                        }
                    });
            },
            error: function () {
                alert("패스키 세션 토큰 요청 중 오류가 발생했습니다.");
            }
        });
    }

    // 패스키 인증 결과 백엔드 검증
    function verifyPasskeyAuth(token, userId) {
        $.ajax({
            url: "/passkey/auth/verify.do",
            type: "POST",
            data: { token: token, userId: userId },
            dataType: "json",
            success: function (res) {
                if (res && res.result == 1) {
                    // 인증 확인 → 최종 로그인 처리 (loginProc 의 SSO 자리로 연결 예정)
                    finishPasskeyLogin(res.userId || userId);
                } else {
                    alert((res && res.msg) ? res.msg : "패스키 인증 검증 실패");
                }
            },
            error: function () {
                alert("패스키 인증 검증 중 오류가 발생했습니다.");
            }
        });
    }

    // 패스키 인증 성공 → 최종 로그인 (loginProc.do)
    function finishPasskeyLogin(userId) {
        finishLogin(userId, "PASSKEY");
    }

    // ============================================================
    // 공통: 최종 로그인 처리 (패스키/모바일 인증 공용)
    //   → POST /loginProc.do → 부모창 이동 + 팝업/다이얼로그 닫기
    // ============================================================
    function finishLogin(userId, loginType) {
        var formData = new FormData();
        formData.append("userId", userId);
        formData.append("loginType", loginType);   // 인증 경유 방식 표시 (PASSKEY / MOBILE)

        fetch("/loginProc.do", {
            method: "POST",
            headers: { "X-Requested-With": "XMLHttpRequest" },
            credentials: "include",
            body: formData
        })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            if (data.ok) {
                if (window.parent && window.parent !== window) {
                    window.parent.location.href = data.redirectUrl;
                } else if (window.opener && !window.opener.closed) {
                    window.opener.location.href = data.redirectUrl;
                    window.close();
                } else {
                    window.location.href = data.redirectUrl;
                }
            } else {
                alert(data.message || "로그인에 실패했습니다.");
            }
        })
        .catch(function (err) {
            console.error("[" + loginType + "] loginProc error:", err);
            alert("로그인 처리 중 오류가 발생했습니다.");
        });
    }

    // ============================================================
    // 모바일 인증(생체/PIN/패턴) 로그인
    //   1) /api/2fa/option.do  → challenge 발급 (기존 issueChallenge)
    //   2) /api/2fa/auth.do    → M세이버 앱으로 푸시 발송
    //   3) /api/2fa/result.do  → 폴링으로 승인 결과 확인 (0:진행중/1:성공/2:취소/3:실패)
    //   4) 성공 → finishLogin()
    // ============================================================
    var mobileAuthState = {
        challenge: null,
        pollTimer: null,
        countdownTimer: null,
        remainSec: 180   // 세션토큰 유효시간 3분 (문서 기준)
    };

    function startMobileAuth(userId) {
        // 모달 초기 상태로 표시
        $("#mobileStatusMsg").text("인증 요청을 준비하고 있습니다...");
        document.getElementById("mobileModal").classList.add("active");

        // 1) challenge 발급 (기존 2FA option API 재사용)
        $.ajax({
            url: "/api/2fa/option.do",
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify({ userId: userId }),
            dataType: "json",
            success: function (res) {
                if (!res || !res.ok || !res.challenge) {
                    $("#mobileStatusMsg").text((res && res.message) ? res.message : "세션 토큰 발급에 실패했습니다.");
                    return;
                }
                mobileAuthState.challenge = res.challenge;

                // 2) 인증 요청(푸시 발송)
                requestMobileAuthPush();
            },
            error: function () {
                $("#mobileStatusMsg").text("세션 토큰 요청 중 오류가 발생했습니다.");
            }
        });
    }

    function requestMobileAuthPush() {
        $.ajax({
            url: "/api/2fa/auth.do",
            type: "POST",
            data: { challenge: mobileAuthState.challenge },
            dataType: "json",
            success: function (res) {
                if (!res || res.result != 1) {
                    $("#mobileStatusMsg").text((res && res.description) ? res.description : "인증 요청에 실패했습니다.");
                    return;
                }
                $("#mobileStatusMsg").text("모바일 인증이 완료되면 자동으로 로그인됩니다.");
                startMobilePolling();
                startMobileCountdown();
            },
            error: function () {
                $("#mobileStatusMsg").text("인증 요청 중 오류가 발생했습니다.");
            }
        });
    }

    // 승인 결과 폴링 (2초 간격)
    function startMobilePolling() {
        stopMobilePolling();
        mobileAuthState.pollTimer = setInterval(function () {
            $.ajax({
                url: "/api/2fa/result.do",
                type: "POST",
                data: { challenge: mobileAuthState.challenge },
                dataType: "json",
                success: function (res) {
                    // ⚠ 백엔드 result 복호화가 아직 미구현 상태(TODO).
                    //   복호화 완료 전까지는 status 값이 정확하지 않을 수 있음.
                    var status = res ? res.status : null;

                    if (status === 1) {
                        stopMobilePolling();
                        stopMobileCountdown();
                        $("#mobileStatusMsg").text("인증이 완료되었습니다. 로그인 중...");
                        var userId = $("#mobileId").val();
                        finishLogin(userId, "MOBILE");
                    } else if (status === 2) {
                        stopMobilePolling();
                        stopMobileCountdown();
                        $("#mobileStatusMsg").text("인증이 취소되었습니다.");
                    } else if (status === 3) {
                        stopMobilePolling();
                        stopMobileCountdown();
                        $("#mobileStatusMsg").text("인증에 실패했습니다.");
                    }
                    // status === 0 (진행중) 이면 계속 폴링
                },
                error: function () {
                    // 일시적 오류는 폴링을 계속 유지 (다음 주기에 재시도)
                }
            });
        }, 2000);
    }

    function stopMobilePolling() {
        if (mobileAuthState.pollTimer) {
            clearInterval(mobileAuthState.pollTimer);
            mobileAuthState.pollTimer = null;
        }
    }

    // 남은시간 카운트다운 표시 (3분)
    function startMobileCountdown() {
        stopMobileCountdown();
        mobileAuthState.remainSec = 180;
        updateMobileTimeDisplay();

        mobileAuthState.countdownTimer = setInterval(function () {
            mobileAuthState.remainSec--;
            if (mobileAuthState.remainSec <= 0) {
                stopMobileCountdown();
                stopMobilePolling();
                $("#mobileStatusMsg").text("인증 유효시간이 만료되었습니다. 다시 시도해주세요.");
                return;
            }
            updateMobileTimeDisplay();
        }, 1000);
    }

    function stopMobileCountdown() {
        if (mobileAuthState.countdownTimer) {
            clearInterval(mobileAuthState.countdownTimer);
            mobileAuthState.countdownTimer = null;
        }
    }

    function updateMobileTimeDisplay() {
        var m = Math.floor(mobileAuthState.remainSec / 60);
        var s = mobileAuthState.remainSec % 60;
        $("#mobileTime").text(m + "분 " + (s < 10 ? "0" + s : s) + "초");
    }

    // "인증 완료 확인" 버튼: 폴링이 늦을 때 수동으로 즉시 1회 재확인
    $(document).on("click", "#mobileAuthCompleteBtn", function () {
        if (!mobileAuthState.challenge) return;
        $("#mobileStatusMsg").text("인증 결과를 확인하고 있습니다...");

        $.ajax({
            url: "/api/2fa/result.do",
            type: "POST",
            data: { challenge: mobileAuthState.challenge },
            dataType: "json",
            success: function (res) {
                var status = res ? res.status : null;
                if (status === 1) {
                    stopMobilePolling();
                    stopMobileCountdown();
                    var userId = $("#mobileId").val();
                    finishLogin(userId, "MOBILE");
                } else {
                    $("#mobileStatusMsg").text("아직 인증이 완료되지 않았습니다. 모바일 앱에서 인증을 진행해주세요.");
                }
            },
            error: function () {
                $("#mobileStatusMsg").text("결과 확인 중 오류가 발생했습니다.");
            }
        });
    });

    // 모바일 모달 닫기 시 진행 중인 폴링/타이머 정리
    $(document).on("click", ".mobile-close", function () {
        stopMobilePolling();
        stopMobileCountdown();
    });

    /* 탭 키보드 접근성 */
    var kbTabs = document.querySelectorAll(".tabs input[name='login_tab']:not(.mobile-hide)");
    kbTabs.forEach(function(tab, index) {
        tab.addEventListener("keydown", function(e) {
            var nextIndex;
            if (e.key === "ArrowRight") nextIndex = (index + 1) % kbTabs.length;
            if (e.key === "ArrowLeft")  nextIndex = (index - 1 + kbTabs.length) % kbTabs.length;
            if (nextIndex !== undefined) {
                e.preventDefault();
                kbTabs[nextIndex].checked = true;
                kbTabs[nextIndex].focus();
                kbTabs[nextIndex].dispatchEvent(new Event("change"));
            }
        });
    });

    // 초기 실행
    renderInfo("mobile");
</script>

</body>
</html>
