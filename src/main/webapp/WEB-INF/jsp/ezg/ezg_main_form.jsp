<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/asmt/common/asmt_common_inc.jsp" %>

<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>

<script src="/webdoc/player/plyr.js" crossorigin="anonymous"></script>
<script src="/webdoc/player/player.js" crossorigin="anonymous"></script>
<script src="/webdoc/audio-recorder/audio-recorder.js"></script>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2.1"/>
<link rel="stylesheet" href="/webdoc/player/plyr.css"/>
<link rel="stylesheet" href="/webdoc/audio-recorder/audio-recorder.css"/>

<style>
    #imgFullView {
        display: none;
        position: absolute;
        left: 0;
        top: 0;
        width: 100%;
        height: 100vh;
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

    #fullMediaExtBtn {
        position: absolute;
        top: 0;
        text-align: right;
        width: 100%;
    }

    #imgFullView.fullpdf #fullMediaExtBtn {
        top: 40px;
    }

    #imgFullView.fullpdf #fullMediaExtBtn #fullOriginal {
        display: none;
    }

    .mediaArea .item:nth-child(even) {
        border-top: 1px solid #d7d7d7;
    }

    #imgFullViewBox .item:nth-child(even) {
        border-top: 1px solid #d7d7d7;
    }

    #memoBtn.ui.button.on {
        position: relative
    }

    #memoBtn.ui.button.on:after {
        content: "";
        position: absolute;
        display: inline-block;
        width: 5px;
        height: 5px;
        background-color: #dc800a; /* var(--yellow) */
        border-radius: 10em;
        bottom: calc(100% - 7px);
        left: calc(50% - 2px);
    }

    /* 루브릭 짤림 수정 */
    #evalList .ui.dropdown .menu {
        min-width: unset;
        left: -65px;
        width: unset !important;
    }

    #evalList .ui.dropdown .menu > .item {
        white-space: unset;
    }

    .min-height-unset {
        min-height: unset !important;
    }
</style>

<script type="text/javascript">
    var audioRecord = null;
    var gStdNo = "${stdNo}";
    var clickType = "";

    $(document).ready(function () {
        // 제출과제 이전, 다음 버튼 이벤트 (E : 이전, D : 다음)
        $(document).on("keyup", function (e) {
            if (!(document.activeElement.tagName === "INPUT" || document.activeElement.tagName === "TEXTAREA")) {
                if (e.keyCode == 68) {
                    btnNext();
                } else if (e.keyCode == 69) {
                    btnPrev();
                }
            }
        });
        audioRecord = UiAudioRecorder("audioRecord");
        audioRecord.formName = "recordForm";
        audioRecord.dataName = "audioData";
        audioRecord.fileName = "audioFile";
        audioRecord.lang = "ko";
        audioRecord.init();

        audioRecord.recorderBox.css({"top": "0px", "left": "0px"});
        audioRecord.setRecorder();

        $("#audioRecord").height($(".recorder-box").height() + 22);

        $(".audio-header").remove();
        $(".audio-btm .btm-btn").remove();

        audioRecord.recorderBox.show();

        viewListHide();

        listAsmntUser();

        $('#mainView .scrollArea').scrollMove();
        $('#imgFullViewBox').scrollMove();
    });

    /* 스크롤 처리 함수 */
    $.fn.scrollMove = function () {
        var controlDown = false;
        var pointer = {
            pageY: 0,
            pageX: 0,
            scrollTop: 0,
            scrollLeft: 0,
        };
        // 마우스 이벤트
        //$(this).css('cursor','all-scroll');
        $(this).on('mousedown', function (e) {
            e.preventDefault();
            controlDown = true;
            pointer.pageX = e.pageX;
            pointer.pageY = e.pageY;
            pointer.scrollTop = $(this).scrollTop();
            pointer.scrollLeft = $(this).scrollLeft();
        });
        $(this).on('mousemove', function (e) {
            if (controlDown) {
                var newPageX = e.pageX;
                var newPageY = e.pageY;
                $(this).scrollLeft(pointer.scrollLeft - newPageX + pointer.pageX);
                $(this).scrollTop(pointer.scrollTop - newPageY + pointer.pageY);
            }
        });
        $(this).on('mouseup', function (e) {
            controlDown = false;
        });
    };

    function viewListHide() {
        $("#noData").hide(); // 과제미제출 화면 숨기기
        $("#viewData").hide(); // 과제 화면 숨기기
        $("#mediaExtBtn").hide();
    }

    // 과제 평가 참여자 리스트 조회
    function listAsmntUser() {
        showLoading();

        var url = "";
        if ("${vo.teamAsmntCfgYn}" == 'Y') {
            url = "/asmt/profAsmtTeamPtcpntSelect.do";
        } else {
            url = "/asmt/profAsmtSbmsnPtcpntSelect.do";
        }

        var data = {
            "selectType": "LIST",
            "crsCreCd": "${vo.crsCreCd}",
            "asmntCd": "${vo.asmntCd}",
            "searchKey": $("#ezgSearchKey").val(),
            "sortType": $("#ezgSearchSort").val(),
            "asmntCtgrCd": "${vo.asmntCtgrCd}"
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var html = "";
                var tCd = "";
                data.returnList.forEach(function (item, i) {

                    if ("${vo.teamAsmntCfgYn}" == 'Y' && tCd != item.teamCd) {
                        tCd = item.teamCd;
                        html += `<div class='ui grey label m0 tr active-toggle-btn flex-none' onClick="selectTeam(this)"`;
                        html += `   data-userId="\${item.userId}" data-userNm="\${item.userNm}" data-stdNo="\${item.stdNo}" data-deptNm="\${item.deptNm}" data-hy="\${item.hy}"`;
                        html += `   data-teamCd="\${item.teamCd}">`;
                        html += `    <div class=''><c:out value='\${item.teamNm}' /></div>`;
                        html += `</div>`;
                    }

                    html += `<a href="#0" name="ezgTargetUser" onClick="selectUser(this)"`;
                    html += `   data-userId="\${item.userId}" data-userNm="\${item.userNm}" data-stdNo="\${item.stdNo}" data-deptNm="\${item.deptNm}" data-hy="\${item.hy}" data-bestYn="\${item.bestYn}"`;
                    if ("${vo.teamAsmntCfgYn}" == 'Y') {
                        html += `   data-teamCd="\${item.teamCd}"`;
                    }
                    html += '   class="card';
                    if ("${vo.teamAsmntCfgYn}" == 'Y') {
                        html += ' pl10';
                    }
                    html += ' active-toggle-btn">';

                    html += `   <div class="content stu_card">`;

                    html += `		<div class="icon_box">`;
                    if (item.evalYn == 'Y') {
                        html += `   	<i class="ion-android-done" aria-label="<spring:message code='button.ok.rate' />"></i>`;	// 평가완료
                    }
                    if (item.asmntSubmitStatusCd != 'NO') {
                        html += `   	<i class="file alternate outline icon" aria-label="<spring:message code='common.label.asmnt.submit' />"></i>`;	// 과제제출함
                    }
                    if (item.bestYn == 'Y') {
                        html += `   	<i class="trophy icon fcBlue mla" aria-label="<spring:message code='common.label.excellent.asmnt' />"></i>`;	// 우수과제
                    }
                    html += `   	</div>`;
                    html += `		<div class="text_box">`;
                    html += `       	<div class="meta"><c:out value='\${item.deptNm}' /></div>`;
                    html += `       	<div class="user"><span><c:out value='\${item.userNm}' /> (<c:out value='\${item.userId}' />)</span></div>`;
                    html += `   	</div>`;
                    html += `	</div>`;
                    html += `</a>`;
                });

                $("#rubric_card").empty().append(html);

                if (gStdNo != "") {
                    $("a[data-stdNo=" + gStdNo + "]").click();
                    gStdNo = "";
                } else {
                    $("#rubric_card a").first().click();
                }
            } else {
                alert(data.message);
            }

            hideLoading();
        }, function (xhr, status, error) {
            hideLoading();
            /* 에러가 발생했습니다! */
            alert("<spring:message code='fail.common.msg' />");
        });
    }

    // 텍스트과제 URL 포함내용 변경
    function changeTextUrl(text, idx) {
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

    // 과제 조회
    function getAsmnt(stdNo) {
        var sendType = "${vo.sendType}"; // 제출형식 F: 파일, T: 텍스트
        $("#mediaExtBtn").hide();

        viewListHide();

        var url = "/asmt/profAsmtSbmsnPtcpntSelect.do";
        var data = {
            "selectType": "OBJECT",
            "crsCreCd": "${vo.crsCreCd}",
            "asmntCd": "${vo.asmntCd}",
            "stdNo": stdNo
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                vo = data.returnVO;

                $("#totalScore").val(vo.score);
                $("#totalScore").attr("preval", vo.score);

                if (vo.profMemo != null) {
                    $("#memoBtn").addClass("on");
                } else {
                    $("#memoBtn").removeClass("on");
                }
                if (vo.asmntSubmitStatusCd == 'NO') {
                    $("#noData").show();

                    $("#infoView ul:eq(0) dd:eq(0)").text(''); // 제출일시
                    $("#infoView ul:eq(0) dd:eq(1)").html(''); // 제출파일
                    $("#infoView ul:eq(0) dd:eq(2)").text(''); // 코멘트
                    //$("#infoView ul:eq(0) dd:eq(3)").text(''); // 유사율
                } else {
                    var sendCts = vo.sendCts == null ? "" : vo.sendCts;
                    var konanMaxCopyRate = vo.konanMaxCopyRate ? '<a class="fcBlue" href="${konanCopyScoreUrl}?domain=e_asmnt&docId=' + vo.asmntSendCd + '" target="_blank">' + vo.konanMaxCopyRate + '%</a>' : '-';
                    var html = "";

                    var height = $(window).height() - 185;

                    // 제출형식 F: 파일, T: 텍스트

                    if (sendType == "T") {
                        if (vo.sendText && (vo.sendText.match("https://") || vo.sendText.match("http://"))) {
                            vo.sendText = changeTextUrl(vo.sendText, 0);
                        }

                        // 제출형식 텍스트
                        html += '<div id="textViewBox" class="ui p_h100 p10" style="">';
                        html += (vo.sendText || "");
                        html += '</div>';
                        var fileRegDttm = vo.fileRegDttm != null ? dateFormat(vo.fileRegDttm) : "";

                        if (vo.asmntSubmitStatusCd == "LATE") {
                            fileRegDttm = vo.lateDttm != null ? dateFormat(vo.lateDttm) : "";
                            fileRegDttm += " (<span class='fcRed'><spring:message code='common.label.lateness' /></span>)"; // 지각
                        } else if (vo.asmntSubmitStatusCd == "RE") {
                            fileRegDttm = vo.reDttm != null ? dateFormat(vo.reDttm) : "";
                            fileRegDttm += " (<span class='fcRed'><spring:message code='asmnt.label.resubmit' /></span>)"; // 재제출
                        }

                        $("#infoView ul:eq(0) dd:eq(0)").html(fileRegDttm); // 제출일시
                        $("#infoView ul:eq(0) dd:eq(1)").html(''); // 제출파일
                        $("#infoView ul:eq(0) dd:eq(2)").text(sendCts); // 코멘트
                        //$("#infoView ul:eq(0) dd:eq(3)").html(konanMaxCopyRate); // 유사율
                    } else {
                        if (vo.fileList.length > 0) {
                            var ext = ['pdf', 'txt', 'png', 'gif', 'jpg'];
                            var dHtml = "";
                            var viewType = null;
                            var isView = false;
                            var existImg = false;
                            var fileRegDttm = vo.fileRegDttm != null ? dateFormat(vo.fileRegDttm) : "";

                            if (vo.asmntSubmitStatusCd == "LATE") {
                                fileRegDttm = vo.lateDttm != null ? dateFormat(vo.lateDttm) : "";
                                fileRegDttm += " (<span class='fcRed'><spring:message code='common.label.lateness' /></span>)"; // 지각
                            } else if (vo.asmntSubmitStatusCd == "RE") {
                                fileRegDttm = vo.reDttm != null ? dateFormat(vo.reDttm) : "";
                                fileRegDttm += " (<span class='fcRed'><spring:message code='asmnt.label.resubmit' /></span>)"; // 재제출
                            }

                            $("#infoView ul:eq(0) dd:eq(0)").html(fileRegDttm); // 제출일시
                            $("#infoView ul:eq(0) dd:eq(2)").text(sendCts); // 코멘트
                            //$("#infoView ul:eq(0) dd:eq(3)").text(''); // 유사율
                            $('#mainView .scrollArea').css("cursor", "default");

                            for (var i = 0; i < vo.fileList.length; i++) {
                                dHtml += "<div class='flex-item gap4'>" + vo.fileList[i].fileNm
                                dHtml += "	<button class='ui icon button p4' title='<spring:message code="asmnt.label.attachFile.download" />' onclick=\"fileDown('" + vo.fileList[i].fileSn + "', '" + vo.fileList[i].repoCd + "')\">";	// 파일다운로드
                                dHtml += "	<i class='ion-android-download'></i>";
                                dHtml += "	</button>";
                                dHtml += "</div>";

                                var fext = vo.fileList[i].fileExt;
                                var isImage = false;
                                var isPdf = false;
                                var isMaxSize = false;
                                var itemType = "";

                                // 미리보기 사이즈 제한, 20M
                                if (vo.fileList[i].fileSize > 20 * 1024 * 1024) {
                                    isMaxSize = true;
                                }

                                /* 개발 TEST 중 */
                                if ("${docViewerUseYn}" == "Y") {
                                    var docConvertExtList = "${docConvertExts}".split(",");
                                    var isViewerFile = false;

                                    docConvertExtList.forEach(function (ext, i) {
                                        if (ext == fext) {
                                            isViewerFile = true;
                                        }
                                    });

                                    if (fext == "png" || fext == "gif" || fext == "jpg") {
                                        if (viewType == null) viewType = "img";
                                        existImg = true;
                                        itemType = "img";
                                        isImage = true;
                                        if (!isMaxSize) {
                                            isView = true;
                                            html += "<div class='item'><img src='" + vo.fileList[i].fileView + "' alt='<spring:message code="common.label.asmnt" />' aria-hidden='true'></div>";	// 과제
                                            $('#mainView .scrollArea').css("cursor", "all-scroll");
                                        }
                                    } else if (isViewerFile) {
                                        html += "<iframe class='item mb5' title='<spring:message code="common.label.asmnt" />' src='/common/docView.do?encFileSn=" + vo.fileList[i].encFileSn + "'></iframe>";
                                    }

                                    if (isImage && isMaxSize) {
                                        html += "<div class='item pt30 pb30 noview'><p><spring:message code='asmnt.message.no_view_big'/></p>";
                                        html += "<p><spring:message code='asmnt.message.confirm_preview'/><p>";
                                        html += "<p class='mt10 fcDarkblue'>" + vo.fileList[i].fileNm + " (" + formatFileSize(vo.fileList[i].fileSize) + ") ";
                                        html += "<button class='ui icon button basic small' title='<spring:message code='asmnt.label.attachFile.download'/>' onclick=\"fileDown('" + vo.fileList[i].fileSn + "', '" + vo.fileList[i].repoCd + "')\">";
                                        html += "	<i class='ion-android-download'></i>";
                                        html += "</button>";
                                        html += "<button class='ui button basic small' onclick='viewBigFile(this, \"" + itemType + "\", \"" + viewType + "\", \"" + vo.fileList[i].fileView + "\")'><spring:message code='button.view'/></button>";
                                        html += "</p>";
                                        html += "</div>";
                                    }

                                    if (!isImage && !isViewerFile) {
                                        html += "<div class='item pt30 pb30 noview'><p><spring:message code='asmnt.message.no_view'/><p>";
                                        html += "<p class='mt10'>" + vo.fileList[i].fileNm + " (" + formatFileSize(vo.fileList[i].fileSize) + ") "
                                        html += "<button class='ui icon button basic small' title='<spring:message code='asmnt.label.attachFile.download'/>' onclick=\"fileDown('" + vo.fileList[i].fileSn + "', '" + vo.fileList[i].repoCd + "')\">";
                                        html += "	<i class='ion-android-download'></i>";
                                        html += "</button>";
                                        html += "</p>";
                                        html += "</div>";
                                    }

                                    continue;
                                }
                                /* 개발 TEST 중 */

                                if (fext == "png" || fext == "gif" || fext == "jpg") {
                                    if (viewType == null) viewType = "img";
                                    existImg = true;
                                    itemType = "img";
                                    isImage = true;
                                    if (!isMaxSize) {
                                        isView = true;
                                        html += "<div class='item'><img src='" + vo.fileList[i].fileView + "' alt='<spring:message code="common.label.asmnt" />' aria-hidden='true'></div>";	// 과제
                                        $('#mainView .scrollArea').css("cursor", "all-scroll");
                                    }
                                } else if (fext == "pdf") {
                                    if (viewType == null) viewType = "pdf";
                                    itemType = "pdf";
                                    isPdf = true;
                                    if (!isMaxSize) {
                                        isView = true;
                                        html += "<iframe class='item' title='<spring:message code="common.label.asmnt" />' src='" + vo.fileList[i].fileView + "'></iframe>";
                                    }
                                }

                                if ((isImage || isPdf) && isMaxSize) {
                                    html += "<div class='item pt30 pb30 noview'><p><spring:message code='asmnt.message.no_view_big'/></p>";
                                    html += "<p><spring:message code='asmnt.message.confirm_preview'/><p>";
                                    html += "<p class='mt10 fcDarkblue'>" + vo.fileList[i].fileNm + " (" + formatFileSize(vo.fileList[i].fileSize) + ") ";
                                    html += "<button class='ui icon button basic small' title='<spring:message code='asmnt.label.attachFile.download'/>' onclick=\"fileDown('" + vo.fileList[i].fileSn + "', '" + vo.fileList[i].repoCd + "')\">";
                                    html += "	<i class='ion-android-download'></i>";
                                    html += "</button>";
                                    html += "<button class='ui button basic small' onclick='viewBigFile(this, \"" + itemType + "\", \"" + viewType + "\", \"" + vo.fileList[i].fileView + "\")'><spring:message code='button.view'/></button>";
                                    html += "</p>";
                                    html += "</div>";
                                }

                                if (!isImage && !isPdf) {
                                    html += "<div class='item pt30 pb30 noview'><p><spring:message code='asmnt.message.no_view'/><p>";
                                    html += "<p class='mt10'>" + vo.fileList[i].fileNm + " (" + formatFileSize(vo.fileList[i].fileSize) + ") "
                                    html += "<button class='ui icon button basic small' title='<spring:message code='asmnt.label.attachFile.download'/>' onclick=\"fileDown('" + vo.fileList[i].fileSn + "', '" + vo.fileList[i].repoCd + "')\">";
                                    html += "	<i class='ion-android-download'></i>";
                                    html += "</button>";
                                    html += "</p>";
                                    html += "</div>";
                                }
                            }

                            $("#infoView ul:eq(0) dd:eq(1)").html(dHtml); // 제출파일
                            //$("#infoView ul:eq(0) dd:eq(3)").html(konanMaxCopyRate); // 유사율
                        } else {
                            $("#infoView ul:eq(0) dd:eq(0)").text(''); // 제출일시
                            $("#infoView ul:eq(0) dd:eq(1)").html(''); // 제출파일
                            $("#infoView ul:eq(0) dd:eq(2)").text(''); // 코멘트
                        }

                        if (isView) {
                            if (viewType == "pdf") {
                                showMediaExtBtn('pdf');
                            } else {
                                showMediaExtBtn('img');
                            }
                        }
                    }

                    $("#viewData").empty().append(html);
                    $("#viewData").show();

                    //$('#mainView .mediaArea iframe').contents().find("#document-container").scrollMove();
                    $('#mainView .mediaArea iframe').contents().find("html").scrollMove();

                    if (sendType == "T") {
                        $('#mainView .scrollArea').off("mousedown");
                        $('#mainView .scrollArea').off("mousemove");
                        $('#mainView .scrollArea').off("mouseup");
                    } else {
                        $('#mainView .scrollArea').scrollMove();
                    }
                }

                var fdbkCntStr = vo.fdbkCnt;
                if (vo.fdbkCnt != 0) {
                    fdbkCntStr = "<span class='fcBlue fwb'>" + vo.fdbkCnt + "</span>";
                }

                $("#fdbkListBtn").html(fdbkCntStr + "<spring:message code='common.label.count.feedback' />");	// 개의 피드백
                $("#fdbkListBtn").attr("onClick", "getFdbkList('" + vo.stdNo + "')");

                if ("${vo.evalUseYn}" == 'Y') {
                    $('.ui.rating').rating('set rating', vo.evalScore);
                }
                $("#mutEvalViewForm > input[name='asmntSendCd']").val(vo.asmntSendCd);
            } else {
                alert(data.message);
            }

        }, function (xhr, status, error) {
            /* 에러가 발생했습니다! */
            alert("<spring:message code='fail.common.msg' />");
        });
    }

    // 이미지 확대 보기 버튼 표시
    function showMediaExtBtn(type, viewType) {
        var right = $(".EG-layout .info-section").width() + 43;

        if (type == "img") {
            $("#imgFullView").removeClass("fullpdf");
            $("#imgFullView").addClass("fullimg");
            $("#mediaExtBtn").css({"right": right + "px", "top": "15px"});
        } else if (type == "pdf") {
            $("#imgFullView").removeClass("fullimg");
            $("#imgFullView").addClass("fullpdf");
            $("#mediaExtBtn").css({"right": right + "px", "top": "50px"});
        }

        $("#mediaExtBtn").show();
    }

    // 용량 큰 파일 보기
    function viewBigFile(obj, itemType, viewType, file) {
        var item = $(obj).parent().parent();
        item.empty();
        item.removeClass("pt30");
        item.removeClass("pb30");
        item.removeClass("noview");

        var html = "";
        if (itemType == "img") {
            html = "<img src='" + file + "' alt='<spring:message code="common.label.asmnt" />' aria-hidden='true'>";
            $('#mainView .scrollArea').css("cursor", "all-scroll");
        } else if (itemType == "pdf") {
            html = "<iframe class='item' title='<spring:message code="common.label.asmnt" />' src='" + file + "'></iframe>";
        }

        item.append(html);
        showMediaExtBtn(itemType, viewType);
    }

    /**
     * 유저 선택 반전
     */
    function selectTeam(obj) {
        $('.active-toggle-btn').removeClass("select");
        $("a[name=ezgTargetUser][data-teamCd=" + $(obj).attr("data-teamCd") + "]").addClass("select");

        $("#totalScore").val('');
        $("#totalScore").attr("preval", "");
        resetRublic();

        getAsmnt($(obj).attr("data-stdNo"));

        let topPos = $(obj).position().top - 69;
        let box = $("#rubric_card");
        if (topPos < 0) {
            box.scrollTop(box.scrollTop() + topPos);
        } else if ((topPos + $(obj).height() + 10) > box.height()) {
            box.scrollTop(box.scrollTop() + (topPos + $(obj).height() - box.height()) + 10);
        }
    }

    /**
     * 유저 선택 반전
     */
    function selectUser(obj) {

        $('.active-toggle-btn').removeClass("select");
        $(obj).addClass("select");

        $("#totalScore").val('');
        $("#totalScore").attr("preval", "");
        resetRublic();
        getRublic($(obj).attr("data-stdNo"));

        getAsmnt($(obj).attr("data-stdNo"));

        let topPos = $(obj).position().top - 69;
        let box = $("#rubric_card");
        if (topPos < 0) {
            box.scrollTop(box.scrollTop() + topPos);
        } else if ((topPos + $(obj).height() + 10) > box.height()) {
            box.scrollTop(box.scrollTop() + (topPos + $(obj).height() - box.height()) + 10);
        }

        if ("${vo.prtcYn}" == "Y") {
            if ($(obj).attr("data-bestYn") == "Y") {
                $("#bestBtn").text("<spring:message code='common.label.excellent.asmnt' /><spring:message code='common.label.cancel.selection' />");	// 우수과제 선정취소
                $("#bestBtn").attr("href", "javascript:unSubmitBest();");
            } else {
                $("#bestBtn").text("<spring:message code='common.label.excellent.asmnt' /><spring:message code='common.label.selection' />");				// 우수과제선정
                $("#bestBtn").attr("href", "javascript:submitBest();");
            }
        }

        $("#fdbkValue").val("");

        //점수입력창 자동포커스 막기
        //document.location.href = "#totalScore";

        // 파일업로드 취소
        fdbkFilePopClose();
    }

    function getPrevAsmntFiles() {
        //var modalId = "Ap03";
        //initModal(modalId);

        //var kvArr = [];
        //kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
        //kvArr.push({'key' : 'asmntCd', 'val' : "${vo.asmntCd}"});
        //kvArr.push({'key' : 'stdNo', 'val' : $(".card.active-toggle-btn.select").attr("data-stdNo")});

        //submitForm("/asmt/profPrevAsmtListPopView.do", modalId+"ModalIfm", kvArr);

        $("#viewAllAsmntForm input[name='crsCreCd']").val("${vo.crsCreCd}");
        $("#viewAllAsmntForm input[name='asmntCd']").val("${vo.asmntCd}");
        $("#viewAllAsmntForm input[name='stdNo']").val($(".card.active-toggle-btn.select").attr("data-stdNo"));
        $("#viewAllAsmntForm").attr("target", "viewAllAsmntIfm");
        $("#viewAllAsmntForm").attr("action", "/asmt/profPrevAsmtListPopView.do");
        $("#viewAllAsmntForm").submit();
        $("#viewAllAsmntPop").modal("show");

        // TODOO
    }

    // 피드백 가져오기
    function getFdbkList(stdNo) {
        var modalId = "Ap09";
        initModal(modalId);

        var kvArr = [];
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'asmntCd', 'val': "${vo.asmntCd}"});
        kvArr.push({'key': 'stdNo', 'val': stdNo});
        kvArr.push({'key': 'searchType', 'val': "EZG"});

        submitForm("/asmt/profAsmtFdbkPopView.do", modalId + "ModalIfm", kvArr);
    }

    function getSubmitHyst() {
        var modalId = "Ap11";
        initModal(modalId);

        var kvArr = [];
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'asmntCd', 'val': "${vo.asmntCd}"});
        kvArr.push({'key': 'stdNo', 'val': $(".card.active-toggle-btn.select").attr("data-stdNo")});

        submitForm("/asmtProfAsmtSbmsnHstryPopListView", modalId + "ModalIfm", kvArr);
    }

    // 루브릭 저장
    function submitMut(type) {
        clickType = type;

        if ($('.active-toggle-btn.select').length < 1) {
            /* 선택된 대상이 없습니다. */
            alert("<spring:message code='forum_ezg.label.select.empty' />");
            return false;
        }

        var score = $("#totalScore").val();

        // 점수 입력
        if (score == "" || score == undefined) {
            /* 점수를 입력하세요. */
            alert("<spring:message code='resh.label.input.score' />");
            return false;
        }

        var stdNo = "";
        var qstnCd = "";
        var gradeCd = "";
        var evalScore = "";
        if ($(".card.active-toggle-btn.select").length > 1) {
            $(".card.pl10.active-toggle-btn.select").each(function (i) {
                if (i > 0) stdNo += ",";
                stdNo += $(this).attr("data-stdNo");
            });
        } else {
            stdNo = $(".card.active-toggle-btn.select").attr("data-stdNo");
        }

        $("input[name='dpQstnScore']").each(function (i, o) {
            var maxScore = 0;
            var isSelected = false;
            $("#evalList tr:eq(" + i + ") .box.item").each(function (j, p) {
                var gSc = $("#evalList tr:eq(" + i + ") .box.item").eq(j).data('score');
                if (Number(maxScore) < Number(gSc)) maxScore = gSc;
                var sco = $("input[name=dpQstnScore]:eq(" + i + ")").val() == "" ? -1 : $("input[name=dpQstnScore]:eq(" + i + ")").val();
                if ($(p).hasClass("active selected") || gSc == sco) {
                    if (gradeCd != "") gradeCd += ",";
                    gradeCd += $(p).attr("data-gradeCd");
                    isSelected = true;
                }
            });

            var qs = $("#evalList tr:eq(" + i + ") input[name=qstnScore]").val();

            if (isSelected) {
                if (qstnCd != "") qstnCd += ",";
                qstnCd += $(o).closest("tr").find("input[name=qstnCd]").val();
                if (evalScore != "") evalScore += ",";
                evalScore += (Math.floor(Number(o.value) / Number(maxScore) * Number(qs)));
            }
        });

        var url = "/asmt/profAsmtRubricRegist.do";
        var data = {
            "evalCd": "${eval.evalCd}",
            "rltnCd": "${vo.asmntCd}",
            "stdNo": stdNo,
            "qstnCd": qstnCd,
            "gradeCd": gradeCd,
            "evalScore": evalScore
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                submitScore(clickType);
                getRublic(stdNo);
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 에러가 발생했습니다! */
            alert("<spring:message code='fail.common.msg' />");
        });
    }

    // 점수 저장
    function submitScore(type) {
        clickType = type;

        if ($('.active-toggle-btn.select').length < 1) {
            /* 선택된 대상이 없습니다. */
            alert("<spring:message code='forum_ezg.label.select.empty' />");
            return false;
        }

        var score = $("#totalScore").val();
        var fdbkVal = $("#fdbkValue").val().trim();

        if ((score == "" || score == undefined) && fdbkVal == "") {
            alert("점수나 피드백을 입력해주세요.");
            return false;
        }
        /* else if ((score == "" || score == undefined) && fdbkVal != "") {
            if (confirm("피드백을 등록하시겠습니까?")) {
                valFdbk("tmp");
            }
        } */

        // 점수 입력
        /*else if(score == "" || score == undefined){
            // 점수를 입력하세요.
            alert("



















        <spring:message code='resh.label.input.score' />");
			return false;
		}
		*/
        if (score != "" && score != undefined && score > 100) {
            /* 점수는 100점 까지 입력 가능 합니다. */
            alert("<spring:message code='resh.alert.score.max.100' />");
            $("#totalScore").val("");
            return false;
        }

        var stdNo = "";
        if ($(".card.active-toggle-btn.select").length > 1) {
            $(".card.pl10.active-toggle-btn.select").each(function (i) {
                if (i > 0) stdNo += ",";
                stdNo += $(this).attr("data-stdNo");
            });
        } else {
            stdNo = $(".card.active-toggle-btn.select").attr("data-stdNo");
        }

        var url = url = "/asmt/profAsmtMrkModify.do";
        var data = {
            "asmntCd": "${vo.asmntCd}",
            "stdNo": stdNo,
            "score": score,
        };

        var confirmStr = false;
        if (clickType == "tmp") {
            confirmStr = true;
        } else {
            var confirmMsg = ""; // "<spring:message code='common.save.msg'/>";

            if ((score == "" || score == undefined) && fdbkVal != "") {
                confirmMsg = "<spring:message code='forum.alert.feedback.confirm'/>";  //피드백을 등록하시겠습니까?
            } else if ((score != "" && score != undefined) && fdbkVal != "") {
                confirmMsg = "<spring:message code='forum.alert.score_feedback.confirm'/>"; //점수와 피드백을 등록하시겠습니까?
            } else {
                confirmStr = true;
            }

            if (!confirmStr) {
                confirmStr = confirm(confirmMsg);
            }
        }

        /* 저장하시겠습니까? */
        if (confirmStr) {
            if (score != "" && score != undefined) {
                ajaxCall(url, data, function (data) {
                    if (data.result > 0) {
                        var html = `<i class="ion-android-done" aria-label="<spring:message code="button.ok.rate" />"></i>`; // 평가완료

                        if ($(".card.active-toggle-btn.select .icon_box .file").length > 0) {
                            html += `<i class="file alternate outline icon" aria-label="<spring:message code='common.label.asmnt.submit' />"></i>`;		// 과제제출함
                        }
                        if ($(".card.active-toggle-btn.select .icon_box .trophy").length > 0) {
                            html += `<i class="trophy icon fcBlue mla" aria-label="<spring:message code="common.label.excellent.asmnt" />"></i>`;		// 우수과제
                        }

                        // 점수 등록이 완료되었습니다.
                        if (clickType == "click") {
                            var fileUploader = dx5.get("fileUploader");
                            //alert("<spring:message code='exam.alert.score.finish' />");
                            if (fdbkVal != "" || fileUploader.getFileCount() > 0) {
                                valFdbk("tmp");
                            }
                        }

                        $(".card.active-toggle-btn.select .icon_box").empty().html(html);
                    } else {
                        //alert(data.message);
                        alert("<spring:message code='fail.common.msg' />");
                    }
                }, function (xhr, status, error) {
                    // 에러가 발생했습니다!
                    alert("<spring:message code='fail.common.msg' />");
                }, true);
            } else if (clickType == "click" && (fdbkVal != "" || fileUploader.getFileCount() > 0)) {
                valFdbk("tmp");
            }
        }
    }

    // 점수 초기화
    function resetScore() {

        if ($('.active-toggle-btn.select').length < 1) {
            /* 선택된 대상이 없습니다. */
            alert("<spring:message code='forum_ezg.label.select.empty' />");
            return false;
        }

        /* 초기화 하시겠습니까? */
        if (confirm('<spring:message code="exam.confirm.init" />')) {
            $("#totalScore").val('0');
            $("#totalScore").attr("preval", "0");

            var stdNo = "";
            if ($(".card.active-toggle-btn.select").length > 1) {
                $(".card.pl10.active-toggle-btn.select").each(function (i) {
                    if (i > 0) stdNo += ",";
                    stdNo += $(this).attr("data-stdNo");
                });
            } else {
                stdNo = $(".card.active-toggle-btn.select").attr("data-stdNo");
            }

            var url = "/asmt/profAsmtMrkModify.do";
            var data = {
                "asmntCd": "${vo.asmntCd}",
                "stdNo": stdNo,
                "score": 0
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    /* 초기화가 완료되었습니다. */
                    alert('<spring:message code="exam.alert.init" />');
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                /* 에러가 발생했습니다! */
                alert("<spring:message code='fail.common.msg' />");
            });
        }
    }

    // 메모 등록
    function submitMemo(type) {

        if ($('.active-toggle-btn.select').length < 1) {
            /* 선택된 대상이 없습니다. */
            alert("<spring:message code='forum_ezg.label.select.empty' />");
            return false;
        }

        var stdNo = "";
        if ($(".card.active-toggle-btn.select").length > 1) {
            $(".card.pl10.active-toggle-btn.select").each(function (i) {
                if (i > 0) stdNo += ",";
                stdNo += $(this).attr("data-stdNo");
            });
        } else {
            stdNo = $(".card.active-toggle-btn.select").attr("data-stdNo");
        }

        var url = "/asmt/profAsmtMemoModify.do";
        var data = {
            "asmntCd": "${vo.asmntCd}",
            "stdNo": stdNo,
            "profMemo": $("#profMemo").val(),
        };

        var confirmStr = "";
        if (type == "click") {
            confirmStr = confirm("<spring:message code='forum.alert.memo.confirm'/>");/* 메모를 저장하시겠습니까? */
        } else {
            confirmStr = true;
        }

        if (confirmStr) {
            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    if (type == "click") {
                        /* 메모 등록이 완료되었습니다. */
                        alert('<spring:message code="lesson.alert.message.insert.memo" />');
                    }
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                /* 에러가 발생했습니다! */
                alert("<spring:message code='fail.common.msg' />");
            });
        }
    }

    function submitBest() {

        if ($('.active-toggle-btn.select').length < 1) {
            /* 선택된 대상이 없습니다. */
            alert("<spring:message code='forum_ezg.label.select.empty' />");
            return false;
        }

        var stdNo = $(".card.active-toggle-btn.select").attr("data-stdNo");
        var url = "/asmt/profAsmtExlnChcModify.do";
        var data = {
            "asmntCd": "${vo.asmntCd}",
            "indList": stdNo,
            "profMemo": $("#profMemo").val(),
            "bestYn": "Y"
        };

        /* 우수과제로 선정하시겠습니까? */
        if (confirm("<spring:message code='common.alert.excellent.asmnt.select'/>")) {
            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    var html = "";

                    if ($(".card.active-toggle-btn.select .icon_box .ion-android-done").length > 0) {
                        html += `<i class="ion-android-done" aria-label="<spring:message code='button.ok.rate' />"></i>`;	// 평가완료
                    }

                    if ($(".card.active-toggle-btn.select .icon_box .file").length > 0) {
                        html += `<i class="file alternate outline icon" aria-label="<spring:message code='common.label.asmnt.submit' />"></i>`;	// 과제제출함
                    }

                    html += `<i class="trophy icon fcBlue mla" aria-label="<spring:message code='common.label.excellent.asmnt' />"></i>`;	// 우수과제

                    /* 우수과제로 선정 되었습니다. */
                    alert("<spring:message code='common.alert.excellent.asmnt.complete'/>");

                    $(".card.active-toggle-btn.select .icon_box").empty().html(html);
                    $(".card.active-toggle-btn.select").attr("data-bestYn", "Y");
                    $("#bestBtn").text("<spring:message code='common.label.excellent.asmnt' /><spring:message code='common.label.cancel.selection' />");	// 우수과제 선정취소
                    $("#bestBtn").attr("href", "javascript:unSubmitBest();");
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                /* 에러가 발생했습니다! */
                alert("<spring:message code='fail.common.msg' />");
            });
        }
    }

    // 우수과제 선정취소
    function unSubmitBest() {
        if ($('.active-toggle-btn.select').length < 1) {
            /* 선택된 대상이 없습니다. */
            alert("<spring:message code='forum_ezg.label.select.empty' />");
            return false;
        }

        var stdNo = $(".card.active-toggle-btn.select").attr("data-stdNo");
        var url = "/asmt/profAsmtExlnChcModify.do";
        var data = {
            "asmntCd": "${vo.asmntCd}",
            "indList": stdNo,
            "profMemo": $("#profMemo").val(),
            "bestYn": "N"
        };

        /* 우수과제 선정을 취소하시겠습니까? */
        if (confirm("<spring:message code='common.alert.no.excellent.asmnt.select'/>")) {
            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    var html = "";

                    if ($(".card.active-toggle-btn.select .icon_box .ion-android-done").length > 0) {
                        html += `<i class="ion-android-done" aria-label="<spring:message code='button.ok.rate' />"></i>`;	// 평가완료
                    }

                    if ($(".card.active-toggle-btn.select .icon_box .file").length > 0) {
                        html += `<i class="file alternate outline icon" aria-label="<spring:message code='common.label.asmnt.submit' />"></i>`;	// 과제제출함
                    }

                    /* 우수과제 선정이 취소 되었습니다. */
                    alert("<spring:message code='common.alert.no.excellent.asmnt.complete'/>");

                    $(".card.active-toggle-btn.select .icon_box").empty().html(html);
                    $(".card.active-toggle-btn.select").attr("data-bestYn", "N");
                    $("#bestBtn").text("<spring:message code='common.label.excellent.asmnt' /><spring:message code='common.label.selection' />");	// 우수과제선정
                    $("#bestBtn").attr("href", "javascript:submitBest();");
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                /* 에러가 발생했습니다! */
                alert("<spring:message code='fail.common.msg' />");
            });
        }
    }

    // 피드백 Validation
    function valFdbk(type) {
        clickType = type;

        if ($('.active-toggle-btn.select').length < 1) {
            /* 선택된 대상이 없습니다. */
            alert("<spring:message code='forum_ezg.label.select.empty' />");
            return false;
        }

        // 피드백 입력
        if ($("#fdbkValue").val() == "" || $("#fdbkValue").val() == undefined) {
            /* 피드백을 입력하시기 바랍니다. */
            alert("<spring:message code='forum.alert.feedback.input'/>");
            return false;
        }

        if ($("#totalScore").val() != "" && clickType == "click") {
            if ("${vo.evalCtgr}" == "R") {
                submitMut("tmp");
            } else {
                submitScore("tmp");
            }
        }

        var confirmStr = "";
        if (type == "click") {
            confirmStr = confirm("<spring:message code='common.save.msg'/>");
        } else {
            confirmStr = true;
        }

        $("#fdbkUploadForm > input[name='uploadFiles']").val("");
        $("#fdbkUploadForm > input[name='copyFiles']").val("");
        $("#fdbkUploadForm > input[name='uploadPath']").val("");

        if (confirmStr) {
            var fileUploader = dx5.get("fileUploader");
            if (fileUploader != null && fileUploader.getFileCount() > 0) {
                fileUploader.startUpload();
            } else {
                submitFdbk(type);
            }
        }
    }


    // 피드백 파일업로드
    function finishUpload() {
        var fileUploader = dx5.get("fileUploader");
        var url = "/file/fileHome/saveFileInfo.do";
        var data = {
            "uploadFiles": fileUploader.getUploadFiles(),
            "copyFiles": fileUploader.getCopyFiles(),
            "uploadPath": fileUploader.getUploadPath()
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                $("#fdbkUploadForm > input[name='uploadFiles']").val(fileUploader.getUploadFiles());
                $("#fdbkUploadForm > input[name='copyFiles']").val(fileUploader.getCopyFiles());
                $("#fdbkUploadForm > input[name='uploadPath']").val(fileUploader.getUploadPath());

                submitFdbk(clickType);
            } else {
                alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
        });
    }

    function submitFdbk(type) {
        var fileUploader = dx5.get("fileUploader");
        var stdNo = "";
        if ($(".card.active-toggle-btn.select").length > 1) {
            $(".card.pl10.active-toggle-btn.select").each(function (i) {
                if (i > 0) stdNo += ",";
                stdNo += $(this).attr("data-stdNo");
            });
        } else {
            stdNo = $(".card.active-toggle-btn.select").attr("data-stdNo");
        }

        var url = "/asmt/profAsmtFdbkRegist.do";
        var data = {
            "crsCreCd": "${vo.crsCreCd}",
            "asmntCd": "${vo.asmntCd}",
            "stdNo": stdNo,
            "fdbkTgtCd": "${vo.teamAsmntCfgYn}" == 'Y' ? "team" : "std",
            "fdbkCts": $("#fdbkValue").val(),
            "uploadFiles": $("#fdbkUploadForm > input[name='uploadFiles']").val(),
            "uploadPath": $("#fdbkUploadForm > input[name='uploadPath']").val(),
            "audioData": audioRecord.audioData,
            "audioFile": audioRecord.audioFile
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                if (fileUploader != null) {
                    fileUploader.removeAll();
                }
                fdbkFilePopClose();

                /* 피드백 등록이 완료되었습니다. */
                if (type == "click") {
                    alert("<spring:message code='forum.alert.reg_complete.feedback' />");
                }

                getAsmnt($(".card.active-toggle-btn.select").attr("data-stdNo"));
                $("#fdbkValue").val("");
                $("#fdbkFileViewPop").empty();

                if ("${vo.evalCtgr}" == "R") {
                    $("#totalScore").val('');
                    $("#totalScore").attr("preval", "");
                    resetRublic();
                    getRublic($(".card.active-toggle-btn.select").attr("data-stdNo"));
                }
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 에러가 발생했습니다! */
            alert("<spring:message code='fail.common.msg' />");
        });
    }

    // 루브릭 점수 클릭시 문항 총점, total점수 환산점 등 계산
    function selectRublicScore() {
        // 총점 변경
        var totScore = 0;
        var excScore = 0;

        $("input[name='dpQstnScore']").each(function (i, o) {
            totScore += Number(o.value);

            var maxScore = 0;
            $("#evalList tr:eq(" + i + ") .box.item").each(function (j) {
                var gSc = $("#evalList tr:eq(" + i + ") .box.item").eq(j).data('score');
                if (Number(maxScore) < Number(gSc)) maxScore = gSc;
            });

            var qs = $("#evalList tr:eq(" + i + ") input[name=qstnScore]").val();
            excScore += Math.floor(Number(o.value) / Number(maxScore) * Number(qs));
            $("p[name=extScore]:eq(" + i + ")").text((Math.floor(Number(o.value) / Number(maxScore) * Number(qs))) + " / " + qs + "<spring:message code='message.score' />");
        });

        $('input[name=totalScore]').val(totScore);
        $('input[name=exchangeScore]').val(excScore);
        // $("#sumScore").text('<spring:message code="exam.label.total.score.point" /> : ' + totScore + '<spring:message code="message.score" /> (<spring:message code="forum.label.exchange.score" /> : ' + excScore + '<spring:message code="message.score" />)' );	// 총점 점 (환산점수 점)
        $("#sumScore").text('<spring:message code="common.label.total.point" /> : ' + excScore + '<spring:message code="message.score" />');        // 총점 점
        $("#totalScore").val(excScore);
        $("#totalScore").attr("preval", excScore);
        $("#totalScore").trigger("change");
    }

    function resetRublic() {
        $("input[name='dpQstnScore']").val("");
        $("#evalList .box.select").removeClass('select');
        $("#evalList .box.item").removeClass('active selected');
        $("#sumScore").text('<spring:message code="common.label.total.point" /> : 0<spring:message code="message.score" />'); // 총점 : 0점
        $("#evalList .text.inline-flex.gap4").text('<spring:message code="common.label.select" />');	// 선택하기
        $("p[name=extScore]").each(function (i, v) {
            $(v).text("0 / " + $(v).text().split(" / ")[1]);
        });
    }

    // 피드백 파일첨부 팝업 열기
    function fdbkFilePopOpen() {
        var w = $("#fdbkFileBox").width();
        //var h = $("#fdbkFileBox").height();
        var h = 45 * 3;
        var bw = $("#fdbkFileBox").children("a.button").outerWidth();
        var pos = $("#fdbkFileBox").offset();

        //$("#fileUpDiv").css({"visibility":"visible","width":(w-bw)+"px"});
        $("#fileUpDiv").css({"visibility": "visible"});
        $("#fileUploader-container").css("height", (h) + "px");
        $("#fileUpDiv").find("button").css("height", (h) + "px");
        $("#fileUpDiv").offset({top: pos.top, left: pos.left});
        $("#fileUploader").css({"position": "absolute", "padding-left": "55px", "left": "-3.5px"});
        $("#fileUploader-btn-area").css({"z-index": "1"});

        var fileUploader = dx5.get("fileUploader");
        if (fileUploader != null) {
            fileUploader.setUIStyle({"itemHeight": 26});
        }

        $("#fdbkFileBox").css("height", h);
    }

    // 피드백 파일첨부 팝업 닫기
    function fdbkFilePopClose() {
        var fileUploader = dx5.get("fileUploader");
        /*
        if(fileUploader && fileUploader.getFileCount() > 0){
            if(fileUploader.getTotalItemCount() > 0){
                var html = "";
                var items = fileUploader.getItems();

                html += "<i class='paperclip icon f080'></i>";
                html += items[0].name;
                html += "<button type='button' class='del ml10' style='border:1px solid #aaa;width:16px;height:16px' title='Delete' onclick=\"fdbkFileReset();\"></button>";

                $("#fdbkFileViewPop").html(html);
            }
        } else {
            $("#fdbkFileViewPop").html("");
        }
        */
        if (fileUploader != null) {
            fileUploader.clearItems();
        }
        $("#fdbkFileViewPop").html("");
        $('#fileUpDiv').css("visibility", "hidden");
        $("#fdbkFileBox").css("height", "");
    }

    // 피드백 파일첨부 취소
    function fdbkFileReset() {
        var fileUploader = dx5.get("fileUploader");
        fileUploader.removeAll();
        $("#fdbkFileViewPop").empty();
    }

    // 피드백 음성녹음 팝업 열기
    function fdbkAudioPopOpen() {
        $('#fdbkAudioPop').modal('show');
    }

    // 피드백 음성녹음 팝업 닫기
    function fdbkAudioPopClose() {
        $('#fdbkAudioPop').modal('hide');
    }

    // 이전 버튼
    function btnPrev() {
        var idx = $("a[name=ezgTargetUser]").index($("a[name=ezgTargetUser].select"));
        if (idx > 0) {
            $("a[name=ezgTargetUser]").eq(idx - 1).click();
        }
    };

    // 다음 버튼
    function btnNext() {
        var idx = $("a[name=ezgTargetUser]").index($("a[name=ezgTargetUser].select"));

        if ($("a[name=ezgTargetUser].select").length == 1) {
            idx = idx + 1;
        }

        if (idx < $("a[name=ezgTargetUser]").length) {
            $("a[name=ezgTargetUser]").eq(idx).click();
        }
    };

    // 입력창 확대/축소
    function expandTextArea(id) {
        var expand = $("#" + id).attr("expand");
        if (expand == null || expand != "true") {
            $("#" + id).css("cssText", "height:20em !important");
            $("#" + id).attr("expand", "true");
        } else {
            $("#" + id).css("cssText", "height:6em !important");
            $("#" + id).attr("expand", "false");
        }
    }

    // 이미지 전체화면으로 보기
    function viewFullImage(type) {
        if (type == "full") {
            $("#imgFullViewBox").empty();
            $("#imgFullViewBox").append($("#viewData .item"));
            $("#imgFullView").show();
        } else if (type == "close") {
            $("#viewData").append($("#imgFullViewBox .item"));
            $("#viewData .item img").css({"width": "auto", "max-width": "100%", "height": "auto"});
            $("#imgFullView").hide();
        } else if (type == "original") {
            var val = $("#imgFullViewBox .item img").css("max-width");
            if (val == "100%") {
                $("#imgFullViewBox .item img").css({"width": "auto", "max-width": "unset", "height": "auto"});
            } else {
                $("#imgFullViewBox .item img").css({"width": "auto", "max-width": "100%", "height": "auto"});
            }

            $("#imgFullViewBox").scrollTop(0);
            $("#imgFullViewBox").scrollLeft(0);
        }
    }

    // 루브릭 평가 연결 가져오기
    function getRublic(stdNo) {
        var url = "/asmt/profAsmtRubricEvlRinkList.do";
        var data = {
            "evalCd": "${eval.evalCd}",
            "rltnCd": "${vo.asmntCd}",
            "stdNo": stdNo
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnList = data.returnList || [];

                if (returnList.length > 0) {
                    returnList.forEach(function (v, i) {
                        $("div.box.item").each(function (ii, vv) {
                            if ($(vv).attr("data-gradeCd") == v.gradeCd) $(vv).trigger("click");
                        });
                    });
                    $("#mutCancelBtn").show();
                } else {
                    $("#mutCancelBtn").hide();
                }
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 에러가 발생했습니다! */
            alert("<spring:message code='fail.common.msg' />");
        });
    }

    // 운영자 학생 과제 제출 등록
    function editAsmnt() {
        $("#viewData").hide();
        $("#viewNoData").hide();
        $("#btnEdit").hide();
        $("#btnSave").show();
        $("#btnCancel").show();
        $("#viewUpload").show();
        $('#stFilePop').modal('show');
    }

    // 피드백 파일첨부 팝업 닫기
    function asmntPopClose() {
        var fileUploader = dx5.get("fileUploader");
        var html = "";

        if (fileUploader.getFileCount() > 0) {

            if (confirm("<spring:message code='common.save.msg'/>")) {
                if (fileUploader.getFileCount() > 0) {
                    fileUploader.startUpload();
                } else {
                    submitFdbk();
                }
            }

        } else {
            $("#stuAsmntFileViewPop").html("");
        }
        $('#stFilePop').modal('hide');
    }

    //과제제출 팝업 새로 호출창
    function ezgReload(stdNo) {
        location.reload();
        getAsmnt(stdNo);
        $("#fdbkValue").val("");
    }

    // 루브릭 채점 취소
    function cancelMutEval() {
        var url = "/asmt/profAsmtRubricEvlCnclRegist.do";
        var data = {
            "asmntCd": "${vo.asmntCd}",
            "stdNo": $(".card.active-toggle-btn.select").attr("data-stdNo")
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                alert("<spring:message code='asmnt.alert.init_success.score' />");/* 평가점수를 초기화하였습니다. */
                $("#totalScore").val('');
                resetRublic();
                getRublic($(".card.active-toggle-btn.select").attr("data-stdNo"));
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 에러가 발생했습니다! */
            alert("<spring:message code='fail.common.msg' />");
        });
    }

    // 점수 자동 저장)
    function saveScore() {
        var score = $("#totalScore").val();
        var preval = $("#totalScore").attr("preval");
        if (score == "" && preval != "") {
            $("#totalScore").val(preval);
        } else if (score != "" && score != "." && score != ".0" && score != preval) {
            if ("${vo.evalCtgr}" == "R") {
                submitMut("tmp");
            } else {
                submitScore("tmp");
            }
        } else if (score == "." || score == ".0") {
            $("#totalScore").val('');
        }
    }

    // 운영자 학생 과제 제출 등록
    function ezgSubmitPop() {
        var modalId = "Ap17";
        initModal(modalId);

        var kvArr = [];
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'asmntCd', 'val': "${vo.asmntCd}"});
        kvArr.push({'key': 'prtcYn', 'val': "${vo.prtcYn}"});
        kvArr.push({'key': 'sendType', 'val': "F"});
        kvArr.push({'key': 'userId', 'val': $(".card.active-toggle-btn.select").attr("data-userid")});
        kvArr.push({'key': 'stdNo', 'val': $(".card.active-toggle-btn.select").attr("data-stdNo")});

        submitForm("/asmt/profEzGraderSbmsnPopView.do", modalId + "ModalIfm", kvArr);
    }

    // 메모 팝업
    function memoPop() {
        var modalId = "Ap07";
        initModal(modalId);

        var kvArr = [];
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'asmntCd', 'val': "${vo.asmntCd}"});
        kvArr.push({'key': 'stdNo', 'val': $(".card.active-toggle-btn.select").attr("data-stdNo")});

        submitForm("/asmt/profAsmtMemoPopView.do", modalId + "ModalIfm", kvArr);
    }

    function checkScoreInputKey() {
        if (event.keyCode == 69 || event.keyCode == 187 || event.keyCode == 189 || event.keyCode == 107 || event.keyCode == 109) {
            return false;
        }
        return true;
    }

    function closeFileSelect() {
        fdbkFilePopClose();
    }

    function asmntMutEvalPop() {
        $("#mutEvalViewForm > input[name='crsCreCd']").val("${vo.crsCreCd}");
        $("#mutEvalViewForm").attr("target", "mutEvalViewIfm");
        $("#mutEvalViewForm").attr("action", "/asmtProfAsmtMutEvlPopSelectView.do");
        $("#mutEvalViewForm").submit();
        $('#mutEvalViewPop').modal('show');
    }

    // 닫기
    function ezgClose() {
        window.parent.closeModal();

        if (typeof window.parent.ezgCloseCallback === "function") {
            window.parent.ezgCloseCallback();
        }
    }
</script>

<body class="modal-page EG-grader <%=SessionInfo.getThemeMode(request)%>">
<div id="wrap" class="pusher <%=SessionInfo.getThemeMode(request)%>">

    <form id="asmntFdbkFileForm" name="asmntFdbkFileForm" action="/asmt/pro/fdbkFilePop.do" method="POST"></form>

    <div class="header-title EG-type">
        <div class="center-text">
            <span>${vo.crsCreNm} - ${vo.asmntTitle} </span>
            <input type="hidden" id="ezgCrsCreCd" name="crsCreCd" value="${vo.crsCreCd}"/>
            <p class="tc">
                <small><spring:message code="exam.label.engagement.status"/> : ${vo.evalCnt}/${vo.targetCnt}</small>
                <!-- 채점현황 -->
                <small class="bullet_verticalline"><spring:message code="exam.label.submission.status"/>
                    : ${vo.submitCnt}/${vo.targetCnt}</small><!-- 제출현황 -->
            </p>
        </div>

        <div class="flex-section">
            <div class="group-right">
                <a href="javascript:void(0)" class="ui button" onclick="ezgClose();">
                    <spring:message code="asmnt_ezg.button.back" /><!-- 돌아가기 -->
                </a>
            </div>
        </div>
    </div>
    <!-- 본문 content 부분 -->

    <div id="context" class="">
        <div class="ui form">
            <div class="EG-layout">
                <!-- 왼쪽 -->
                <div class="stu-list-box">
                    <div class="flex-item gap4 mb10" id="joinuserOrTeamSearchBlock">
                        <select class="ui fluid dropdown" id="ezgSearchSort" onChange="listAsmntUser()">
                            <option value=" "><spring:message code="asmnt_ezg.label.nm_order"/></option>
                            <option value="NO"><spring:message code="asmnt_ezg.label.userid_order"/></option>
                            <option value="DT"><spring:message code="asmnt_ezg.label.submit_order"/></option>
                        </select>
                        <select class="ui fluid dropdown mh10" id="ezgSearchKey" onChange="listAsmntUser()">
                            <option value=" "><spring:message code="filebox.common.search.all"/></option><!-- 전체 -->
                            <option value="SUBMIT"><spring:message code="exam.label.submit.y"/></option><!-- 제출 -->
                            <option value="NO"><spring:message code="exam.label.submit.n"/></option><!-- 미제출 -->
                            <option value="LATE"><spring:message code="common.label.submit.lateness"/></option>
                            <!-- 지각제출 -->
                            <option value="EVALY"><spring:message code="asmnt.button.eval"/></option><!-- 평가 -->
                            <option value="EVALN"><spring:message code="asmnt.button.no.eval"/></option><!-- 미평가 -->
                        </select>
                    </div>
                    <div class="tr"><spring:message code="common.shortcut"/>&nbsp; <spring:message
                            code="common.key_up"/>:E, <spring:message code="common.key_down"/>:D
                    </div>
                    <div class="ui cards" id="rubric_card"></div>
                </div>

                <!-- 가운데 -->
                <div class="pdf-viewer" id="mainView">
                    <div class="flex flex-column p_h100 scrollArea">
                        <div class="flex1 flex-column" id="noData" style="display: flex;">
                            <div class="flex-container m-hAuto">
                                <div class="no_content">
                                    <i class="icon-cont-none ico f170" aria-hidden="true"></i>
                                    <span><spring:message code="asmnt.alert.input.no.submit.file"/></span>
                                    <!-- 제출한 과제가 없습니다 -->
                                </div>
                            </div>
                        </div>

                        <div class="flex1 flex-column mediaArea" id="viewData" style="display: flex;">
                        </div>

                        <div id="mediaExtBtn" style='display:none;position:absolute;top:16px;'>
                            <button class="ui icon button" title="<spring:message code="button.expand" />"
                                    onclick="viewFullImage('full')"><i class="ion-arrow-expand"></i></button>
                        </div>
                    </div>
                </div>

                <!-- 오른쪽 -->
                <div class="info-section">
                    <div class="scrollArea pr5">
                        <!-- 점수 화면 -->
                        <div class="flex">
                            <div class="ui input flex1">
                                <input type="number" placeholder="<spring:message code="asmnt.alert.input.score" />"
                                       id="totalScore" preval="" onKeyup="/*saveScore();*/" onblur="saveScore();"
                                       onkeydown="return checkScoreInputKey();"/>
                            </div>
                            <c:choose>
                                <c:when test="${vo.evalCtgr eq 'R'}">
                                    <a href="javascript:submitMut('click');" class="ui blue button m0"><spring:message
                                            code="button.add"/></a><!-- 저장 -->
                                    <a href="javascript:cancelMutEval()" id="mutCancelBtn" class="ui blue button ml10">
                                        <spring:message code="asmnt.label.cancel.grade" /><!-- 채점취소 --></a>
                                </c:when>
                                <c:otherwise>
                                    <a href="javascript:submitScore('click');" class="ui blue button m0"><spring:message
                                            code="button.add"/></a><!-- 저장 -->
                                </c:otherwise>
                            </c:choose>
                            <!-- <a href="javascript:resetScore();" class="ui Lgrey button m0"><spring:message code="button.init" /></a>초기화 -->
                        </div>

                        <div class="flex-item flex-wrap gap4 pt10">
                            <a href="javascript:void(0);" class="ui basic flex1 button" id="fdbkListBtn"
                               title="<spring:message code="forum.label.feedback" />">0<spring:message
                                    code="forum.label.cnt.feedback"/></a><!-- 피드백 개의 피드백-->
                            <a href="javascript:memoPop()" id="memoBtn" class="ui basic button fr">
                                <spring:message code="asmnt.label.memo" /><!-- 메모 --></a>
                        </div>

                        <div id="projSendInfoBlock" class="mt5">
                            <textarea id="fdbkValue" class="resize-textarea"
                                      style="height:6em !important; max-height: unset; resize: vertical !important;"
                                      placeholder="<spring:message code="forum.label.feedback.input2" />"></textarea>
                            <!-- 피드백입력 -->
                            <%-- <div class="tr mb5" style="margin-top:-25px;margin-right:2px">
                                <button class="ui icon button p4" title="<spring:message code="common.button.textarea_expand" />" onclick="expandTextArea('fdbkValue');return false;"><i class="ion-arrow-expand"></i></button>
                            </div> --%>
                            <div id="fdbkFileBox" class="flex-item mt4" style="position:relative;">
                                <button class="ui basic icon button"
                                        title="<spring:message code="forum.label.fdbk.file.attach" />"
                                        onclick="fdbkFilePopOpen();"><i class="save icon"></i></button><!-- 파일첨부 -->
                                <div class="field ui segment flex1 flex-item m0" style="height:39px;">
                                    <div class="flex align-items-center" id="fdbkFileViewPop"></div>
                                </div>
                                <%-- <a href="javascript:valFdbk('click');" class="ui blue button mla"><spring:message code="resh.button.write" /></a><!-- 등록 --> --%>

                                <form id="fdbkUploadForm" name="fdbkUploadForm" method="post">
                                    <input type="hidden" name="uploadFiles" value=""/>
                                    <input type="hidden" name="copyFiles" value=""/>
                                    <input type="hidden" name="uploadPath" value=""/>
                                </form>
                                <div id="fileUpDiv"
                                     style="display:flex;position:absolute;top:0;left:0;visibility:hidden;width: 100%">
                                    <uiex:dextuploader
                                            id="fileUploader"
                                            path="${uploadPath}"
                                            limitCount="5"
                                            limitSize="1024"
                                            oneLimitSize="1024"
                                            listSize="5"
                                            finishFunc="finishUpload()"
                                            allowedTypes="*"
                                            bigSize="false"
                                            useFileBox="false"
                                            uiMode="simple"
                                    />
                                    <div class="flex1"
                                         style="display:inline-block;vertical-align:top;position: relative;">
                                        <button onclick="closeFileSelect()" class="ui grey small button"
                                                style="margin-left:-4px;"><span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>


                        <c:if test="${vo.evalCtgr == 'R'}">
                            <div class="mt10 mb10">
                                <div class="ui attached message">
                                    <div class="pt5 pb5"><c:out value="${eval.evalTitle}"/></div>
                                    <input type="hidden" id="evalCd" value="${eval.evalCd}">
                                </div>
                                <div class="ui attached message">
                                    <table class="tbl tablet td-sm">
                                        <thead>
                                        <tr>
                                            <th scope="col"><spring:message code="common.label.standard"/></th>
                                            <!-- 기준 -->
                                            <th scope="col"><spring:message code="common.label.grade"/></th><!-- 등급 -->
                                            <th scope="col"><spring:message code="common.score"/></th><!-- 점수 -->
                                        </tr>
                                        </thead>
                                        <tbody id="evalList">
                                        <c:forEach items="${eval.evalQstnList}" var="qstn" varStatus="status">
                                            <tr>
                                                <td data-title="<spring:message code="common.label.standard" />">
                                                    <!-- 기준 -->
                                                    <c:out value="${qstn.qstnCts}"/>
                                                    <input type="hidden" name="qstnCd" value="${qstn.qstnCd}"/>
                                                    <input type="hidden" name="qstnScore" value="${qstn.evalScore}"/>
                                                </td>
                                                <td data-title="<spring:message code="common.label.grade" />">
                                                    <!-- 등급 -->
                                                    <div class="ratings-column ui fluid dropdown">
                                                        <input type="hidden" name="dpQstnScore"
                                                               onchange="selectRublicScore()">

                                                        <div class="text inline-flex gap4"><spring:message
                                                                code="common.label.select"/></div>
                                                        <i class="dropdown icon"></i><!-- 선택하기 -->
                                                        <div class="menu p_w100">
                                                            <c:forEach items="${qstn.evalGradeList}" var="grade"
                                                                       varStatus="gradeStatus">
                                                                <div class="box item" data-value="${grade.gradeScore}"
                                                                     data-score="${grade.gradeScore}"
                                                                     data-gradeCd="${grade.gradeCd }">
                                                                    <div class="score">${grade.gradeScore}
                                                                        <spring:message code="resh.label.score"/></div>
                                                                    <!-- 점 -->
                                                                    <div class="title"><c:out
                                                                            value='${grade.gradeTitle}'/></div>
                                                                </div>
                                                            </c:forEach>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td data-title="<spring:message code='common.score' />"><!-- 점수 -->
                                                    <p name="extScore">0 /
                                                        ${qstn.evalScore }<spring:message code="message.score" /><!-- 점 --></p>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="ui attached message">
                                    <div class="option-content mb0">
                                        <div class="button-area">
                                            <input type="hidden" name="totalScore" value="0"/>
                                            <input type="hidden" name="exchangeScore" value="0"/>
                                            <strong class="f120" id="sumScore"><spring:message
                                                    code="forum.label.total.point"/> : 0<spring:message
                                                    code="resh.label.score"/></strong><!-- 총점 : 점 -->
                                            <span class="f080 fcGrey ml10">(
                                                <spring:message code="asmnt.message.rubric_save" /><!-- 등급 선택 후 [저장]버튼을 누르세요. -->)</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <div class="flex-item flex-wrap gap4 pt10">
                            <a href="javascript:getPrevAsmntFiles();" class="ui basic button flex1 m0"><spring:message
                                    code="asmnt.button.all.submit.list"/></a><!-- 전체제출과제보기 -->
                            <a href="javascript:getSubmitHyst();" class="ui basic button flex1 m0"><spring:message
                                    code="asmnt.label.submitted.work"/><spring:message
                                    code="asmnt.label.view.history"/></a><!-- 제출과제이력보기 -->
                        </div>

                        <div class="flex-item flex-wrap gap4 pt5">
                            <c:if test="${vo.prtcYn == 'Y'}">
                                <a href="javascript:submitBest();" id="bestBtn"
                                   class="ui basic button p_w50"><spring:message
                                        code="common.label.excellent.asmnt"/><spring:message
                                        code="common.label.selection"/></a><!-- 우수과제선정 -->
                            </c:if>
                            <c:if test="${vo.evalUseYn == 'Y'}">
                                <div class="flex1  d-block">
                                    <small class="opacity7 f075">
                                        <button type="button" class="ui button small basic f110 fweb"
                                                onclick="asmntMutEvalPop()"><spring:message
                                                code="forum.label.mut.eval.result"/></button>
                                    </small><!-- 상호평가결과 -->
                                    <c:if test="${vo.evalUseYn == 'Y'}">
                                        <div class="ui tiny star rating gap4" style="pointer-events:none;"
                                             data-rating="0" data-max-rating="5">
                                            <i class="icon"></i>
                                            <i class="icon"></i>
                                            <i class="icon"></i>
                                            <i class="icon"></i>
                                            <i class="icon"></i>
                                        </div>
                                    </c:if>
                                </div>
                            </c:if>
                        </div>

                        <div class="mt10 mb10 flex-item">
                            <button type="button" class="ui basic small button boxShadowNone mra" onclick="btnPrev()"><i
                                    class="angle left icon"></i><spring:message code="std.button.prev"/></button>
                            <!-- 이전 -->
                            <button type="button" class="ui basic small button boxShadowNone mla" onclick="btnNext()">
                                <spring:message code="std.button.next"/><i class="angle right icon"></i></button>
                            <!-- 다음 -->
                        </div>

                        <div class="mt10 mb10">
                            <div class="ui attached message">
                                <div class="pt5 pb5"><spring:message code="forum_ezg.label.submit_filter"/></div>
                                <!-- 제출자 -->
                            </div>
                            <div class="ui attached message" id="infoView">
                                <ul class="tbl ">
                                    <li>
                                        <dl>
                                            <dt><spring:message code="common.submission"/><br><spring:message
                                                    code="exam.label.dttm"/></dt> <!-- 제출 일시 -->
                                            <dd></dd>
                                        </dl>
                                    </li>
                                    <li>
                                        <dl>
                                            <dt><spring:message code="common.submission"/><br><spring:message
                                                    code="forum.label.file"/></dt>    <!-- 제출 파일 -->
                                            <dd></dd>
                                        </dl>
                                    </li>
                                    <li>
                                        <dl>
                                            <dt><spring:message code="common.button.comment"/></dt><!-- 코멘트 -->
                                            <dd></dd>
                                        </dl>
                                    </li>
                                    <%-- <li>
                                        <dl>
                                            <dt><spring:message code="common.label.same.rate" /></dt><!-- 유사율 -->
                                            <dd></dd>
                                        </dl>
                                    </li> --%>
                                </ul>
                            </div>
                        </div>
                        <div>
                            <a href="javascript:ezgSubmitPop()" class="ui blue button"><spring:message
                                    code="crs.title.manager"/><spring:message code="exam.label.submit.y"/></a>
                            <!-- 운영자 제출 -->
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</div>


<div class="modal fade" id="fdbkAudioPop" tabindex="-1" role="dialog"
     aria-labelledby="<spring:message code="forum.label.feedback" /><spring:message code="forum.label.fdbk.audio.attach" />"
     aria-hidden="false">
    <div class="modal-dialog modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"
                        aria-label="<spring:message code="resh.button.close" />"><!-- 닫기 -->
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title"><spring:message code="forum.label.feedback"/><spring:message
                        code="forum.label.fdbk.audio.attach"/></h4><!-- 피드백 음성녹음 -->
            </div>
            <div class="modal-body">
                <div class="modal-page">
                    <div id="wrap">
                        <div class="ui form" style="height:50px">
                            <div id="audioRecord"></div>
                        </div>
                        <div class="bottom-content">
                            <a class="ui blue black button toggle_btn flex-left-auto"
                               onclick="fdbkAudioPopClose();"><spring:message code="forum.button.attaching"/></a>
                            <!-- 첨부하기 -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<div id="imgFullView">
    <div id="fullMediaExtBtn">
        <div style="display:table;float:right">
            <div style="display:table-row">
                <button id="fullClose" class="ui icon button" title="<spring:message code="button.expand" />"
                        onclick="viewFullImage('close')"><i class="ion-arrow-expand"></i></button>
            </div>
            <div style="display:table-row;">
                <button id="fullOriginal" class="ui icon button mt5"
                        title="<spring:message code="button.image_oraginal" />" onclick="viewFullImage('original')"><i
                        class="ion-image"></i></button>
            </div>
        </div>
    </div>
    <div id="imgFullViewBox"></div>
</div>

<form id="viewAllAsmntForm" name="viewAllAsmntForm">
    <input type="hidden" name="crsCreCd"/>
    <input type="hidden" name="asmntCd"/>
    <input type="hidden" name="stdNo"/>
    <input type="hidden" name="hstyCd"/>
</form>
<div class="modal fade" id="viewAllAsmntPop" tabindex="-1" role="dialog" aria-labelledby="audio" data-backdrop="static"
     data-keyboard="false" aria-hidden="false" style="display: none;">
    <div class="modal-dialog modal-lg2" role="document" style="margin: 20px auto;">
        <div class="modal-content p10">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"
                        aria-label="<spring:message code='team.common.close'/>"><!-- 닫기 -->
                    <span aria-hidden="true">&times;</span>
                </button>
                <%-- <h4 class="modal-title"><spring:message code="asmt.label.send.content" /><!-- 제출내용 --></h4> --%>
            </div>
            <div class="modal-body">
                <iframe src="" width="100%" id="viewAllAsmntIfm" name="viewAllAsmntIfm"></iframe>
            </div>
        </div>
    </div>
</div>
<form id="mutEvalViewForm" name="mutEvalViewForm" method="post">
    <input type="hidden" name="crsCreCd"/>
    <input type="hidden" name="asmntSendCd"/>
</form>
<div class="modal fade" id="mutEvalViewPop" tabindex="-1" role="dialog"
     aria-labelledby="<spring:message code='forum.button.feedback.write' />" aria-hidden="true"><!-- 피드백 작성하기 -->
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"
                        aria-label="<spring:message code='forum.button.close'/>"><!-- 닫기 -->
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title"><spring:message code="common.label.eval.user.list" /><!-- 평가자 목록 --></h4>
            </div>
            <div class="modal-body">
                <iframe src="" id="mutEvalViewIfm" name="mutEvalViewIfm" width="100%" scrolling="no"></iframe>
            </div>
        </div>
    </div>
</div>
<script>
    $('iframe').iFrameResize();
    window.closeModal = function () {
        $('.modal').modal('hide');

        $("#viewAllAsmntIfm").attr("src", "");
        $("#mutEvalViewIfm").attr("src", "");
    };
</script>
</body>
</html>


