<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <link rel="stylesheet" type="text/css" href="/webdoc/assets/css/dashboard.css"/>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="module" value=""/>
        <jsp:param name="style" value="dashboard"/>
    </jsp:include>
</head>
<body>
<div style="padding:20px;">

    <h3>알림 수신 유의사항</h3>

    <div style="margin-top:15px; line-height:1.6;">
        <p>1. 알림 수신 동의 시 PUSH, 문자, 이메일 등이 발송될 수 있습니다.</p>
        <p>2. 일부 필수 알림은 동의 여부와 무관하게 발송됩니다.</p>
        <p>3. 설정 변경은 언제든 가능합니다.</p>
    </div>

    <div style="margin-top:30px; text-align:right;">
        <div class="btns">
            <button type="button" class="btn type2" onclick="cancel()">취소</button>
            <button type="button" class="btn type1" onclick="confirmAgree()">확인</button>
        </div>

    </div>
</div>

<script>
    function confirmAgree() {
        // 부모창 함수 호출
        if (window.parent && window.parent.onAlimNoticeConfirm) {
            window.parent.onAlimNoticeConfirm();

        }
    }

    function cancel() {
        if (window.parent && window.parent.onAlimNoticeCancel) {
            window.parent.onAlimNoticeCancel();
        }
    }
</script>

</body>
</html>