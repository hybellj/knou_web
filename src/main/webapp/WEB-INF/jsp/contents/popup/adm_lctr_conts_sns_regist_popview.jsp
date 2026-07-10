<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin,classroom"/>
        <jsp:param name="module" value="editor"/>
    </jsp:include>
    <script type="text/javascript">
        var ORG_ID = '<c:out value="${lctrContsVO.orgId}" />';
        var SBJCT_ID = '<c:out value="${lctrContsVO.sbjctId}" />';
        var LCTR_WKNO_SCHDL_ID = '<c:out value="${lctrContsVO.lctrWknoSchdlId}" />';
        var LCTR_ID = '<c:out value="${lctrContsVO.lctrId}" />';
        var LCTR_CONTS_ID = '<c:out value="${lctrContsVO.lctrContsId}" />';
        var MODE = '<c:out value="${mode}" />';
        var UPLOAD_PATH = '<c:out value="${lctrContsVO.uploadPath}" />';
        var CONTENT_TYPE = '<c:out value="${lctrContsVO.lctrContsTycd}" />';
        var selectedSnsType = "";
        var lrnTocEditor = null;
        var SNS_ALLOWED_URL_HOSTS = {
            "youtube.com": true, "www.youtube.com": true, "youtube-nocookie.com": true, "www.youtube-nocookie.com": true,
            "player.vimeo.com": true, "embed.ted.com": true
        };
        var SNS_IFRAME_ALLOWED_ATTRS = {
            "src": true, "title": true, "width": true, "height": true, "allow": true, "allowfullscreen": true,
            "frameborder": true, "referrerpolicy": true, "loading": true, "scrolling": true,
            "webkitallowfullscreen": true, "mozallowfullscreen": true
        };
        var SNS_IFRAME_BOOLEAN_ATTRS = {
            "allowfullscreen": true, "webkitallowfullscreen": true, "mozallowfullscreen": true
        };
        var SNS_IFRAME_ATTR_ORDER = [
            "width", "height", "src", "title", "frameborder", "allow", "referrerpolicy",
            "loading", "scrolling", "allowfullscreen", "webkitallowfullscreen", "mozallowfullscreen"
        ];

        $(document).ready(function() {
            initLearningContentEditor();
            initNumberInput($("#contsSeqno"));
            selectSnsType(CONTENT_TYPE == "SNS_HTML" ? "SNS_HTML" : "SNS_URL");
        });

        // 현재 팝업이 수정 모드인지 확인한다.
        function isEditMode() {
            return MODE == "E";
        }

        // 학습목차 내용을 입력할 에디터를 초기화한다.
        function initLearningContentEditor() {
            lrnTocEditor = UiEditor({
                targetId: "lrnTocCts",
                uploadPath: UPLOAD_PATH,
                height: "170px"
            });
        }

        // 정렬순서는 숫자만 입력하고 허용 최대값을 넘지 않도록 제한한다.
        function initNumberInput($input) {
            $input.on("keyup change blur", function() {
                var value = String(this.value || "").replace(/[^0-9]/g, "");
                var maxValue = Number($(this).attr("maxVal") || 0);
                if(value !== "" && maxValue > 0 && Number(value) > maxValue) {
                    value = String(maxValue);
                }
                this.value = value;
            });
        }

        // 선택한 소셜 등록 방식에 맞춰 입력 영역과 미리보기 영역을 전환한다.
        function selectSnsType(snsType) {
            selectedSnsType = snsType == "SNS_HTML" ? "SNS_HTML" : "SNS_URL";
            $(".sns-type-btn").removeClass("current");
            $(".sns-type-btn[data-sns-type='" + selectedSnsType + "']").addClass("current");
            $("#snsUrlTab").toggle(selectedSnsType == "SNS_URL");
            $("#snsHtmlTab").toggle(selectedSnsType == "SNS_HTML");
            $("#lecturePreviewRow").toggle(false);
            $("#lecturePreviewFrame").attr("srcdoc", "");
            return false;
        }

        // 입력값 검증 후 소셜 콘텐츠 저장을 요청한다.
        function saveLctrContsSns() {
            // 필수 입력값이 비어 있으면 저장을 중단한다.
            if(!$.trim($("#contsnm").val())) {
                UiComm.showMessage('<spring:message code="common.pop.input.title"/>', "warning"); /* 제목을 입력하세요. */
                return false;
            }
            if(selectedSnsType == "SNS_URL" && !$.trim($("#contsUrl").val())) {
                UiComm.showMessage('<spring:message code="contents.msg.input.social.url"/>', "warning"); /* 소셜 URL 주소를 입력해 주세요. */
                return false;
            }
            if(selectedSnsType == "SNS_HTML" && !$.trim($("#htmlSrc").val())) {
                UiComm.showMessage('<spring:message code="contents.msg.input.social.html"/>', "warning"); /* 공유 소스코드를 입력해 주세요. */
                return false;
            }

            // 에디터에 작성된 학습목차 내용을 저장 파라미터로 반영한다.
            if(lrnTocEditor && typeof lrnTocEditor.getPublishingHtml === "function") {
                $("#lrnTocCts").val(lrnTocEditor.getPublishingHtml());
            }

            // 저장 중 중복 요청을 막고 저장 결과를 부모 화면에 반영한다.
            $("#saveBtn").prop("disabled", true);
            ajaxCall("/contents/admConts/admLctrContsSave.do", createSaveParams(), function(res) {
                $("#saveBtn").prop("disabled", false);
                if(res.result > 0) {
                    showParentMessage(res.message || '<spring:message code="success.common.insert"/>', "success", function() { /* 정상적으로 등록되었습니다. */
                        if(window.parent && window.parent !== window && typeof window.parent.afterLctrContsSave === "function") {
                            window.parent.afterLctrContsSave();
                        } else {
                            closeLctrContsSnsPop();
                        }
                    });
                } else {
                    UiComm.showMessage(res.message || '<spring:message code="fail.common.insert"/>', "error"); /* 생성에 실패하였습니다. */
                }
            }, function() {
                $("#saveBtn").prop("disabled", false);
                UiComm.showMessage('<spring:message code="fail.common.insert"/>', "error"); /* 생성에 실패하였습니다. */
            });
            return false;
        }

        // 화면 입력값을 소셜 콘텐츠 저장 파라미터로 구성한다.
        function createSaveParams() {
            var title = $.trim($("#contsnm").val());
            return {
                orgId: ORG_ID,
                sbjctId: SBJCT_ID,
                lctrWknoSchdlId: LCTR_WKNO_SCHDL_ID,
                lctrId: LCTR_ID,
                lctrContsId: LCTR_CONTS_ID,
                lctrContsTycd: selectedSnsType,
                contsnm: title,
                atndcRfltyn: $("#atndcRfltyn").is(":checked") ? "Y" : "N",
                oyn: "Y",
                contsSeqno: $("#contsSeqno").val(),
                contsUrl: selectedSnsType == "SNS_URL" ? $.trim($("#contsUrl").val()) : "",
                htmlSrc: selectedSnsType == "SNS_HTML" ? $("#htmlSrc").val() : "",
                lrnTocTtl: title,
                lrnTocCts: $("#lrnTocCts").val(),
                uploadPath: UPLOAD_PATH
            };
        }

        // 입력한 소셜 공유 코드를 강의미리보기 영역에 표시한다.
        function previewSnsHtml() {
            var htmlSrc = $("#htmlSrc").val();
            if(!$.trim(htmlSrc)) {
                UiComm.showMessage('<spring:message code="contents.msg.input.social.html"/>', "warning"); /* 공유 소스코드를 입력해 주세요. */
                return false;
            }
            var sanitizedHtml = sanitizeSnsPreviewHtml(htmlSrc);
            if(!sanitizedHtml) {
                UiComm.showMessage('<spring:message code="contents.msg.invalid.social.html"/>', "warning"); /* 허용되지 않는 소셜 공유 코드입니다. */
                return false;
            }
            $("#lecturePreviewFrame").attr("srcdoc", createSnsPreviewSrcdoc(sanitizedHtml));
            $("#lecturePreviewRow").show();
            return false;
        }

        // 미리보기 전에 허용된 iframe 공유 코드만 남겨 임의 스크립트 실행 가능성을 줄인다.
        function sanitizeSnsPreviewHtml(htmlSrc) {
            var container = document.createElement("div");
            var sanitizedHtml = "";
            container.innerHTML = htmlSrc;

            for(var i = 0; i < container.childNodes.length; i++) {
                var node = container.childNodes[i];
                if(node.nodeType == 3 && !$.trim(node.nodeValue)) {
                    continue;
                }
                if(node.nodeType != 1 || String(node.tagName).toLowerCase() != "iframe") {
                    return "";
                }

                var sanitizedIframe = sanitizeSnsPreviewIframe(node);
                if(!sanitizedIframe) {
                    return "";
                }
                sanitizedHtml += sanitizedIframe;
            }
            return sanitizedHtml;
        }

        function sanitizeSnsPreviewIframe(sourceIframe) {
            var attrs = {};
            for(var i = 0; i < sourceIframe.attributes.length; i++) {
                var attr = sourceIframe.attributes[i];
                var attrName = String(attr.name || "").toLowerCase();
                var attrValue = attr.value;
                if(!isAllowedSnsPreviewIframeAttribute(attrName, attrValue)) {
                    return "";
                }
                attrs[attrName] = SNS_IFRAME_BOOLEAN_ATTRS[attrName] ? attrName : $.trim(attrValue);
            }

            if(!attrs.src) {
                return "";
            }

            var iframe = document.createElement("iframe");
            for(var j = 0; j < SNS_IFRAME_ATTR_ORDER.length; j++) {
                var orderedName = SNS_IFRAME_ATTR_ORDER[j];
                if(attrs.hasOwnProperty(orderedName)) {
                    iframe.setAttribute(orderedName, attrs[orderedName]);
                }
            }
            return iframe.outerHTML;
        }

        function isAllowedSnsPreviewIframeAttribute(attrName, attrValue) {
            if(!attrName || attrName.indexOf("on") == 0 || !SNS_IFRAME_ALLOWED_ATTRS[attrName]) {
                return false;
            }
            if(SNS_IFRAME_BOOLEAN_ATTRS[attrName]) {
                return attrValue === "" || String(attrValue).toLowerCase() == attrName;
            }
            if(attrValue == null || containsHtmlDelimiter(attrValue)) {
                return false;
            }
            if(attrName == "src") {
                return isAllowedSnsPreviewIframeSrc(attrValue);
            }
            if(attrName == "width" || attrName == "height") {
                return /^[0-9]{1,5}$|^[0-9]{1,3}%$/.test(attrValue);
            }
            if(attrName == "frameborder") {
                return attrValue == "0" || attrValue == "1";
            }
            if(attrName == "referrerpolicy") {
                return /^(no-referrer|no-referrer-when-downgrade|origin|origin-when-cross-origin|same-origin|strict-origin|strict-origin-when-cross-origin|unsafe-url)$/i.test(attrValue);
            }
            if(attrName == "loading") {
                return /^(lazy|eager)$/i.test(attrValue);
            }
            if(attrName == "scrolling") {
                return /^(yes|no|auto)$/i.test(attrValue);
            }
            return true;
        }

        function isAllowedSnsPreviewIframeSrc(url) {
            var parsedUrl = parseSnsPreviewUrl(url);
            if(!parsedUrl || !SNS_ALLOWED_URL_HOSTS[parsedUrl.host]) {
                return false;
            }
            if(parsedUrl.host == "www.youtube.com" || parsedUrl.host == "youtube.com"
                    || parsedUrl.host == "www.youtube-nocookie.com" || parsedUrl.host == "youtube-nocookie.com") {
                return parsedUrl.path.indexOf("/embed/") == 0;
            }
            if(parsedUrl.host == "player.vimeo.com") {
                return parsedUrl.path.indexOf("/video/") == 0;
            }
            if(parsedUrl.host == "embed.ted.com") {
                return parsedUrl.path.indexOf("/talks/") == 0;
            }
            return false;
        }

        function parseSnsPreviewUrl(url) {
            if(!/^https?:\/\//i.test($.trim(url || ""))) {
                return null;
            }
            var anchor = document.createElement("a");
            anchor.href = $.trim(url || "");
            if(!/^https?:$/i.test(anchor.protocol) || !anchor.hostname || anchor.port) {
                return null;
            }
            return {
                host: anchor.hostname.toLowerCase(),
                path: anchor.pathname || ""
            };
        }

        function containsHtmlDelimiter(value) {
            return String(value).indexOf("<") > -1 || String(value).indexOf(">") > -1;
        }

        // 공유 코드 원본은 유지하고 미리보기 화면에서만 매체 영역을 꽉 채운다.
        function createSnsPreviewSrcdoc(htmlSrc) {
            return '<!DOCTYPE html>'
                    + '<html lang="ko"><head><meta charset="utf-8">'
                    + '<style>'
                    + 'html,body{width:100%;height:100%;margin:0;padding:0;overflow:hidden;background:#fff;}'
                    + '.preview-wrap{width:100%;height:100%;}'
                    + '.preview-wrap iframe,.preview-wrap video,.preview-wrap embed,.preview-wrap object{display:block;width:100% !important;height:100% !important;border:0;}'
                    + '</style></head><body><div class="preview-wrap">'
                    + htmlSrc
                    + '</div></body></html>';
        }

        // 학습 이력 존재 여부를 확인한 뒤 소셜 콘텐츠 삭제 여부를 확인한다.
        function deleteLctrContsSns() {
            if(!isEditMode() || !LCTR_CONTS_ID) {
                return false;
            }

            // 학습 중인 학습자가 있으면 삭제 확인 문구를 분기한다.
            ajaxCall("/contents/admConts/admLctrContsLearningExists.do", {
                orgId: ORG_ID,
                lctrContsId: LCTR_CONTS_ID
            }, function(res) {
                if(res.result < 0) {
                    UiComm.showMessage(res.message || '<spring:message code="fail.common.select"/>', "error"); /* 조회가 실패하였습니다. */
                    return;
                }

                var confirmMessage = res.data
                        ? "<spring:message code='contents.msg.confirm.delete.learning.exists'/>" /* 학습 중인 학습자가 있습니다. 삭제할 경우 모든 학습자의 학습 정보가 삭제됩니다. 그래도 삭제 하시겠습니까? */
                        : "<spring:message code='common.delete.msg'/>"; /* 삭제하시겠습니까? */
                UiComm.showMessage(confirmMessage, "confirm").then(function(ok) {
                    if(ok) {
                        doDeleteLctrContsSns();
                    }
                });
            }, function() {
                UiComm.showMessage('<spring:message code="fail.common.select"/>', "error"); /* 조회가 실패하였습니다. */
            });
            return false;
        }

        // 소셜 콘텐츠 삭제 요청을 전송하고 부모 화면을 갱신한다.
        function doDeleteLctrContsSns() {
            $("#saveBtn, #deleteBtn").prop("disabled", true);
            ajaxCall("/contents/admConts/admLctrContsDelete.do", {
                orgId: ORG_ID,
                lctrContsId: LCTR_CONTS_ID
            }, function(res) {
                $("#saveBtn, #deleteBtn").prop("disabled", false);
                if(res.result > 0) {
                    showParentMessage(res.message || '<spring:message code="success.common.delete"/>', "success", function() { /* 정상적으로 삭제되었습니다. */
                        if(window.parent && window.parent !== window && typeof window.parent.afterLctrContsSave === "function") {
                            window.parent.afterLctrContsSave();
                        } else {
                            closeLctrContsSnsPop();
                        }
                    });
                } else {
                    UiComm.showMessage(res.message || '<spring:message code="fail.common.delete"/>', "error"); /* 삭제가 실패하였습니다. */
                }
            }, function() {
                $("#saveBtn, #deleteBtn").prop("disabled", false);
                UiComm.showMessage('<spring:message code="fail.common.delete"/>', "error"); /* 삭제가 실패하였습니다. */
            });
        }

        // 부모 창 메시지 객체가 있으면 부모 창에서 알림을 표시한다.
        function showParentMessage(message, type, callback) {
            var comm = window.parent && window.parent.UiComm ? window.parent.UiComm : UiComm;
            var result = comm.showMessage(message, type);
            if(result && typeof result.then === "function") {
                result.then(callback);
            } else if($.isFunction(callback)) {
                callback();
            }
        }

        // 소셜 콘텐츠 등록 팝업을 닫는다.
        function closeLctrContsSnsPop() {
            if(window.parent && window.parent !== window && typeof window.parent.closeDialog === "function") {
                window.parent.closeDialog();
                return;
            }
            window.close();
        }
    </script>
</head>
<body class="modal-page">
    <c:set var="lctrWknoSymdText" value="${lctrContsVO.lctrWknoSymd}" />
    <c:set var="lctrWknoEymdText" value="${lctrContsVO.lctrWknoEymd}" />
    <c:if test="${fn:length(lctrWknoSymdText) eq 8}">
        <c:set var="lctrWknoSymdText" value="${fn:substring(lctrWknoSymdText, 0, 4)}.${fn:substring(lctrWknoSymdText, 4, 6)}.${fn:substring(lctrWknoSymdText, 6, 8)}" />
    </c:if>
    <c:if test="${fn:length(lctrWknoEymdText) eq 8}">
        <c:set var="lctrWknoEymdText" value="${fn:substring(lctrWknoEymdText, 0, 4)}.${fn:substring(lctrWknoEymdText, 4, 6)}.${fn:substring(lctrWknoEymdText, 6, 8)}" />
    </c:if>
    <c:choose>
        <c:when test="${not empty lctrContsVO.modDttm}">
            <c:set var="lastModifiedDttmText" value="${lctrContsVO.modDttm}" />
            <c:set var="lastModifiedUserText" value="${empty lctrContsVO.mdfrNm ? lctrContsVO.mdfrId : lctrContsVO.mdfrNm}" />
        </c:when>
        <c:otherwise>
            <c:set var="lastModifiedDttmText" value="${lctrContsVO.regDttm}" />
            <c:set var="lastModifiedUserText" value="${empty lctrContsVO.rgtrNm ? lctrContsVO.rgtrId : lctrContsVO.rgtrNm}" />
        </c:otherwise>
    </c:choose>
    <c:if test="${fn:length(lastModifiedDttmText) eq 14}">
        <c:set var="lastModifiedDttmText" value="${fn:substring(lastModifiedDttmText, 0, 4)}.${fn:substring(lastModifiedDttmText, 4, 6)}.${fn:substring(lastModifiedDttmText, 6, 8)} ${fn:substring(lastModifiedDttmText, 8, 10)}:${fn:substring(lastModifiedDttmText, 10, 12)}:${fn:substring(lastModifiedDttmText, 12, 14)}" />
    </c:if>
    <div class="wrap">
        <div class="board_top">
            <h3 class="board-title">
                <c:choose>
                    <c:when test="${not empty lctrContsVO.lctrWkno}">
                        <c:out value="${lctrContsVO.lctrWkno}" /><spring:message code="contents.label.week.suffix"/><%-- 주차 --%>
                    </c:when>
                    <c:otherwise>
                        <spring:message code="contents.label.week"/><%-- 주차 --%>
                    </c:otherwise>
                </c:choose>
            </h3>
            <div class="right-area">
                <span class="total_txt"><spring:message code="contents.label.learning.period"/><%-- 학습기간 --%> :<b> <c:out value="${lctrWknoSymdText}" /><c:if test="${not empty lctrWknoSymdText or not empty lctrWknoEymdText}"> ~ </c:if><c:out value="${lctrWknoEymdText}" /></b></span>
            </div>
        </div>

        <div class="table-wrap">
            <table class="table-type5">
                <colgroup>
                    <col style="width: 18%;">
                    <col>
                </colgroup>
                <tbody>
                    <tr>
                        <th class="req"><label for="contsnm"><spring:message code="common.label.title"/><%-- 제목 --%></label></th>
                        <td>
                            <input class="form-control width-100per" type="text" id="contsnm" value="<c:out value='${lctrContsVO.lrnTocTtl}' />" maxlength="300" required="true">
                        </td>
                    </tr>
                    <tr>
                        <th><label for="atndcRfltyn"><spring:message code="contents.label.attendance.target"/><%-- 출석대상 --%></label></th>
                        <td>
                            <span class="custom-input">
                                <input type="checkbox" id="atndcRfltyn" value="Y" <c:if test="${empty lctrContsVO.atndcRfltyn or lctrContsVO.atndcRfltyn eq 'Y'}">checked="checked"</c:if>>
                                <label for="atndcRfltyn"><spring:message code="contents.label.attendance.check.target"/><%-- 출석체크 대상에 포함 --%></label>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="contents.label.learning.toc"/><%-- 학습목차 --%></th>
                        <td>
                            <div class="item_btns">
                                <a href="#0" class="active" onclick="return false;">
                                    <i class="icon-svg-share" aria-hidden="true"></i>
                                    <span><spring:message code="contents.label.social"/><%-- 소셜 --%></span>
                                </a>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th><label for="socialLabel"><spring:message code="contents.label.social"/><%-- 소셜 --%></label></th>
                        <td>
                            <div class="form-tab">
                                <div class="tab_btn">
                                    <a href="#snsUrlTab" class="sns-type-btn current" data-sns-type="SNS_URL" onclick="return selectSnsType('SNS_URL');"><spring:message code="contents.label.social.url"/><%-- URL주소 --%></a>
                                    <a href="#snsHtmlTab" class="sns-type-btn" data-sns-type="SNS_HTML" onclick="return selectSnsType('SNS_HTML');"><spring:message code="contents.label.social.source"/><%-- 소스코드 --%></a>
                                </div>
                                <div id="snsUrlTab" class="tab-content">
                                    <small class="note"><spring:message code="contents.msg.social.url.help"/><%-- * YouTube, TED, Vimeo의 동영상 주소를 입력하여 등록할 수 있습니다. --%></small>
                                    <div class="form-row">
                                        <input class="form-control width-100per" type="text" id="contsUrl" value="<c:out value='${lctrContsVO.contsUrl}' />" maxlength="1000" placeholder="<spring:message code='contents.placeholder.social.url'/>"><%-- 소셜미디어 URL 주소를 붙여 넣으세요. --%>
                                    </div>
                                </div>
                                <div id="snsHtmlTab" class="tab-content" style="display:none;">
                                    <small class="note"><spring:message code="contents.msg.social.html.iframe.help"/><%-- * Iframe 형식 HTML 코드를 등록합니다. --%></small>
                                    <div class="form-row">
                                        <label class="width-100per" for="htmlSrc">
                                            <textarea class="form-control resize-none width-100per" id="htmlSrc" rows="6"><c:out value="${lctrContsVO.htmlSrc}" /></textarea>
                                        </label>
                                    </div>
                                    <div class="msg-txt mt10">
                                        <p class="txt"><spring:message code="contents.msg.social.html.help"/><%-- * 소셜 미디어에서 제공하는 공유 코드를 복사하여 붙여 넣습니다. --%></p>
                                        <button type="button" class="btn gray1" onclick="previewSnsHtml();"><spring:message code="button.preview"/><%-- 미리보기 --%></button>
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr id="lecturePreviewRow" style="display:none;">
                        <th><spring:message code="common.label.lecture.preview"/><%-- 강의미리보기 --%></th>
                        <td>
                            <iframe id="lecturePreviewFrame" title="<spring:message code='common.label.lecture.preview'/>" sandbox="allow-scripts allow-presentation" style="display:block;width:100%;height:auto;aspect-ratio:16 / 9;border:1px solid #ddd;background:#fff;"></iframe><%-- 강의미리보기 --%>
                        </td>
                    </tr>
                    <tr>
                        <th><label for="lrnTocCts"><spring:message code="contents.label.learning.content"/><%-- 학습내용 --%></label></th>
                        <td>
                            <div class="editor-box">
                                <textarea id="lrnTocCts" name="lrnTocCts"><c:out value="${lctrContsVO.lrnTocCts}" /></textarea>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th><label for="contsSeqno"><spring:message code="contents.label.sort.order"/><%-- 정렬순서 --%></label></th>
                        <td>
                            <input class="form-control sm" type="text" id="contsSeqno" value="<c:out value='${empty lctrContsVO.contsSeqno ? 1 : lctrContsVO.contsSeqno}' />" maxlength="2" inputmask="numeric" maxVal="99">
                        </td>
                    </tr>
                    <c:if test="${mode eq 'E'}">
                        <tr>
                            <th><spring:message code="contents.label.last.modified"/><%-- 최종수정 --%></th>
                            <td>
                                <c:out value="${lastModifiedDttmText}" />
                                <c:if test="${not empty lastModifiedUserText}"> (<c:out value="${lastModifiedUserText}" />)</c:if>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
        <div class="btns">
            <button type="button" id="saveBtn" class="btn type1" onclick="saveLctrContsSns();"><spring:message code="common.button.save"/><%-- 저장 --%></button>
            <c:if test="${mode eq 'E'}">
                <button type="button" id="deleteBtn" class="btn type2" onclick="deleteLctrContsSns();"><spring:message code="common.button.delete"/><%-- 삭제 --%></button>
            </c:if>
            <button type="button" class="btn type2" onclick="closeLctrContsSnsPop();"><spring:message code="common.button.close"/><%-- 닫기 --%></button>
        </div>
    </div>
</body>
</html>
