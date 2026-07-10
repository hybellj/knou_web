<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="knou.framework.common.CommConst" %>
<%@ page import="knou.framework.util.SessionUtil" %>
<%
Object dscsResultMessage = SessionUtil.getSessionValue(request, CommConst.SSN_COMMON_RESULT_MSG);
String dscsResultScriptMessage = null;
if (dscsResultMessage != null && dscsResultMessage.toString().length() > 0) {
    String message = dscsResultMessage.toString();
    // redirect 이후 표시할 결과 메시지를 JavaScript 문자열로 안전하게 변환한다.
    dscsResultScriptMessage = message
            .replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\r", "\\r")
            .replace("\n", "\\n")
            .replace("</", "<\\/");
    // flash 메시지는 한 번만 노출되도록 session 값을 제거한다.
    SessionUtil.removeSessionValue(request, CommConst.SSN_COMMON_RESULT);
    SessionUtil.removeSessionValue(request, CommConst.SSN_COMMON_RESULT_MSG);
}
%>
<%-- forum2 화면의 UiComm.makeEncParams 사용에 필요합니다. --%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.2/rollups/aes.js"></script>
<script type="text/javascript">
// 팝업 화면에서 공통으로 사용하는 dialog 닫기 함수입니다.
window.closeDialog = function() {
    dialog.close();
};

// serializeArray 파라미터를 다룰 때 사용합니다. 중복되면 안 되는 값은 set()을 사용합니다.
var DscsParam = {
    remove: function(params, name) {
        if (!params || !name) {
            return params;
        }
        for (var i = params.length - 1; i >= 0; i--) {
            if (params[i] && params[i].name === name) {
                params.splice(i, 1);
            }
        }
        return params;
    },
    set: function(params, name, value) {
        params = params || [];
        this.remove(params, name);
        params.push({name: name, value: value});
        return params;
    },
    add: function(params, name, value) {
        params = params || [];
        params.push({name: name, value: value});
        return params;
    }
};

// yyyyMMddHHmm 형식의 일시 문자열을 화면 표시 형식으로 변환합니다.
var DscsDate = {
    format: function(dt) {
        if (!dt) {
            return "";
        }
        // Ex) 2026.05.07 13:27
        return dt.substring(0, 4) + "." + dt.substring(4, 6) + "." + dt.substring(6, 8) + " " + dt.substring(8, 10) + ":" + dt.substring(10, 12);
    }
};

var DscsMessage = window.DscsMessage || {};
// AJAX 실패 응답에 서버 메시지가 있으면 우선 사용하고, 없으면 화면별 기본 메시지를 사용한다.
DscsMessage.result = function(data, fallbackMessage) {
    return data && data.message ? data.message : fallbackMessage;
};
DscsMessage.show = function(message, type) {
    if (message && window.UiComm && UiComm.showMessage) {
        UiComm.showMessage(message, type || "warning");
    }
};
// redirect 직후 session flash 메시지를 UiComm.showMessage()로 표시한다.
DscsMessage.showFlash = function(messageHtml) {
    if (!messageHtml) {
        return;
    }
    var messageBox = document.createElement("div");
    messageBox.innerHTML = messageHtml;
    DscsMessage.show(messageBox.textContent || messageBox.innerText || messageHtml, "warning");
};
window.DscsMessage = DscsMessage;
window.dscsResultMessage = DscsMessage.result;

<% if (dscsResultScriptMessage != null) { %>
(function() {
    var flashMessage = "<%= dscsResultScriptMessage %>";
    var showFlashMessage = function() {
        DscsMessage.showFlash(flashMessage);
    };
    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", showFlashMessage);
    } else {
        showFlashMessage();
    }
})();
<% } %>
</script>
