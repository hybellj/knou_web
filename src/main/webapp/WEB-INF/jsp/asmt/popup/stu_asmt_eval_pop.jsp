<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    <%@ include file="/WEB-INF/jsp/asmt/common/asmt_common_inc.jsp" %>
    <link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>
    <style>
        #imgFullView {
            display: none;
            position: absolute;
            left: 0;
            top: 0;
            width: 100%;
            height: 100vh;
            background: white;
        }

        #imgFullViewBox {
            width: 100%;
            height: 100vh;
            background: white;
            overflow: auto;
            text-align: center;
            cursor: all-scroll;
        }

        #imgFullViewBox .item img {
            width: auto;
            max-width: 100%;
            height: auto;
        }

        #imgFullViewBox iframe {
            width: 100%;
            max-width: 100%;
            height: calc(100% - 10px);
        }

        #imgFullViewBox .item.noview {
            display: none;
        }

        .fileItem:not(:last-child)::after {
            content: '';
            display: block;
            width: 100%;
            padding-top: 10px;
            margin-bottom: 10px;
            border-bottom: 1px solid var(--darkC);
        }

        .min-height-unset {
            min-height: unset !important;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            $('.ui.rating').rating();
        });

        function saveEval() {
            if (window.confirm("<spring:message code='common.save.msg'/>")) {
                $("input[name='scr']").val($('.ui.rating').rating('get rating'));

                var url = "/asmt/stu/regEval.do";
                $.ajax({
                    dataType: 'json',
                    type: 'post',
                    url: url,
                    data: $("#evalForm").serialize(),
                    success: function (data) {
                        if (data.result > 0) {
                            /* 저장하였습니다. */
                            alert("<spring:message code='common.alert.ok.save' />");
                            if (typeof window.parent.evalViewPopCallBack === "function") {
                                window.parent.evalViewPopCallBack();
                            }

                            closeModal();
                        } else {
                            alert(data.message);
                        }
                    }
                });
            }
        }

        // 이미지 전체화면으로 보기
        function viewFullImage(type) {
            if (type == "full") {
                $("#imgFullViewBox").empty();
                $("#imgFullViewBox").append($("#viewData .fileItem"));
                $("#imgFullView").show();
            } else if (type == "close") {
                $("#viewData").append($("#imgFullViewBox .fileItem"));
                $("#viewData .item img").css({"width": "auto", "max-width": "100%", "height": "auto"});
                $("#imgFullView").hide();
            }
        }

        // 텍스트과제 URL 포함내용 변경
        function changeTextUrl(text) {
            var cont = $(text);
            var span = cont.find('span');

            if (span.length > 0) {
                for (var i = 0; i < span.length; i++) {
                    var str = $(span[i]).html();

                    if (str.indexOf("https:") > -1 || str.indexOf("http:") > -1) {
                        var parTag = $(span[i]).parent().prop('tagName');
                        if (parTag != null) {
                            parTag = parTag.toLowerCase();
                            if (parTag == "a") {
                                $(span[i]).parent().prop("target", "_blank");
                            } else if (parTag != "a") {
                                var href = $('<a target="_blank" href="' + str + '" style="text-decoration: underline; color: rgb(22, 63, 199);">');
                                $(span[i]).parent().append(href);
                                href.append($(span[i]));
                            }
                        }
                    }
                }
            }

            text = $(cont).clone().wrapAll("<div/>").parent().html();
            return text;
        }

        function closeModal() {
            window.parent.closeModal();
        }
    </script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>
<div id="wrap">
    <div class="ui form">
        <c:choose>
            <c:when test="${vo.sbmsnStscd == 'NO'}">
                <div class="fields">
                    <div class="field wf100">
                        <span><spring:message code="asmnt.alert.input.no.submit.file"/></span><!-- 제출한 과제가 없습니다 -->
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="ui stackable two column grid">
                    <div class="column">
                        <div class="pdf-viewer p5" style="max-height: 400px; overflow-y: scroll; min-height: 35em;">
                            <div class="flex1 flex-column mediaArea" id="viewData" style="display: flex;">
                                <c:set var="extBtnUseYn" value="N"/>
                                <c:choose>
                                    <c:when test="${aVo.sendType eq 'T'}">
                                        <div id="textViewBox" class="ui p_h100 p10" style="">
                                                ${vo.sendText}
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${vo.fileList }" var="item" varStatus="status">
                                            <div class="fileItem">
                                                <c:choose>
                                                    <c:when test="${docViewerUseYn eq 'Y'}">
                                                        <c:choose>
                                                            <c:when test="${item.fileExt eq 'png' or item.fileExt eq 'gif' or item.fileExt eq 'jpg'}">
                                                                <div class="item">
                                                                    <img alt="<spring:message code="common.label.asmnt" />"
                                                                         aria-hidden="true" src="${item.fileView}"
                                                                         style="max-width: 100%; width: auto; height: auto;"/>
                                                                </div>
                                                                <c:set var="extBtnUseYn" value="Y"/>
                                                            </c:when>
                                                            <c:when test="${docConvertExts.contains(item.fileExt)}">
                                                                <iframe class="item" style="min-height: 32em;"
                                                                        title='<spring:message code="common.label.asmnt" />'
                                                                        src="/common/docView.do?encFileSn=${item.encFileSn}"></iframe>
                                                                <c:set var="extBtnUseYn" value="Y"/>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="flex-item-center">
                                                                    <div class="item pt5 pb5 noview">
                                                                        <p><spring:message
                                                                                code="asmnt.message.no_view"/></p>
                                                                        <p class="">
                                                                                ${item.fileNm} (${item.fileSizeStr})
                                                                            <button class="ui icon button basic small ml5"
                                                                                    title="<spring:message code='asmnt.label.attachFile.download'/>"
                                                                                    onclick="">
                                                                                <i class="ion-android-download"></i>
                                                                            </button>
                                                                        </p>
                                                                    </div>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:choose>
                                                            <c:when test="${item.fileExt eq 'png' or item.fileExt eq 'gif' or item.fileExt eq 'jpg'}">
                                                                <div class="item">
                                                                    <img alt="<spring:message code="common.label.asmnt" />"
                                                                         aria-hidden="true" src="${item.fileView}"
                                                                         style="max-width: 100%; width: auto; height: auto;"/>
                                                                </div>
                                                                <c:set var="extBtnUseYn" value="Y"/>
                                                            </c:when>
                                                            <c:when test="${item.fileExt eq 'pdf' and item.fileSize lt 20 * 1024 * 1024}">
                                                                <iframe class="item" style="min-height: 430px;"
                                                                        title='<spring:message code="common.label.asmnt" />'
                                                                        src="${item.fileView}"></iframe>
                                                                <c:set var="extBtnUseYn" value="Y"/>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="flex-item-center">
                                                                    <div class="item pt5 pb5 noview">
                                                                        <p><spring:message
                                                                                code="asmnt.message.no_view"/></p>
                                                                        <p class="">
                                                                                ${item.fileNm} (${item.fileSizeStr})
                                                                            <button class="ui icon button basic small ml5"
                                                                                    title="<spring:message code='asmnt.label.attachFile.download'/>"
                                                                                    onclick="">
                                                                                <i class="ion-android-download"></i>
                                                                            </button>
                                                                        </p>
                                                                    </div>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <c:if test="${extBtnUseYn eq 'Y' and deviceType ne 'mobile'}">
                            <div id="mediaExtBtn" class="tr" style="position: absolute; top: 15px; right: 25px;">
                                <button class="ui icon button p10" title="<spring:message code="button.expand" />"
                                        onclick="viewFullImage('full')"><i class="ion-arrow-expand"></i></button>
                            </div>
                        </c:if>
                    </div>
                    <div class="column">
                        <form id="evalForm" name="evalForm" action="" method="POST">
                            <input type="hidden" name="asmtSbmsnId" value="${vo.asmtSbmsnId }">
                            <input type="hidden" name="asmtId" value="${vo.asmtId }">
                            <input type="hidden" name="scr" value="">
                            <!-- 제출파일 -->
                            <ul class='tbl'>
                                <li>
                                    <dl>
                                        <dt><spring:message code="asmnt.label.send.file"/><!-- 제출파일 --></dt>
                                        <dd>
                                            <c:forEach items="${vo.fileList }" var="item" varStatus="status">
                                                <button type="button" class="ui icon small button mb5"
                                                        id="file_${item.fileSn }"
                                                        title="<spring:message code='asmnt.label.attachFile.download'/>"
                                                        onclick="fileDown('${item.fileSn}', '${item.repoCd }')">
                                                    <i class="ion-android-download"></i>
                                                </button>
                                                <script>
                                                    byteConvertor("${item.fileSize}", "${item.fileNm}", "file_${item.fileSn}");
                                                </script>
                                            </c:forEach>
                                        </dd>
                                    </dl>
                                </li>
                                <li>
                                    <dl>
                                        <dt><label for="subjectLabel" class="req">
                                            <spring:message code="forum.label.mutEval.star"/><!-- 별점 평가 --></label></dt>
                                        <dd>
                                            <div class="ui tiny star rating gap4" data-rating="${gVo.scr }"
                                                 data-max-rating="5">
                                                <i class="icon"></i>
                                                <i class="icon"></i>
                                                <i class="icon"></i>
                                                <i class="icon"></i>
                                                <i class="icon"></i>
                                            </div>
                                        </dd>
                                    </dl>
                                </li>
                                <li>
                                    <dl>
                                        <dt><label for="contentTextArea">
                                            <spring:message code="common.reviews"/><!-- 평가의견 --></label></dt>
                                        <dd>
                                            <div>
                                                <textarea name="scoreCmnt">${gVo.scoreCmnt }</textarea>
                                            </div>
                                        </dd>
                                    </dl>
                                </li>
                            </ul>
                        </form>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <div id="imgFullView">
        <div class="tr">
            <button id="fullClose" class="ui icon button" title="<spring:message code="button.expand" />"
                    onclick="viewFullImage('close')"><i class="ion-arrow-expand"></i></button>
        </div>
        <div id="imgFullViewBox"></div>
    </div>

    <div class="bottom-content">
        <button class="ui blue button" onclick="saveEval();"><spring:message code="team.common.save"/></button>
        <!-- 저장 -->
        <button class="ui black cancel button" onclick="closeModal();"><spring:message
                code="team.common.close"/></button><!-- 닫기 -->
    </div>
</div>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>