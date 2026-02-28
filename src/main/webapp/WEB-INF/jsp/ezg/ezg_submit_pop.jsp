<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.util.Enumeration" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/asmt/common/asmt_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>
</head>

<script type="text/javascript">

    $(document).ready(function () {

        var stdNo = "${vo.stdNo }";

        getAsmnt(stdNo);
    });


    // 과제 평가 참여자 리스트 조회
    function listAsmntUser() {

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

                    html += `<a href="#0" name="ezgTargetUser" id="selectUser" onClick="selectUser(this)"`;
                    html += `   data-userId="\${item.userId}" data-userNm="\${item.userNm}" data-stdNo="\${item.stdNo}" data-deptNm="\${item.deptNm}" data-hy="\${item.hy}" data-bestYn="\${item.bestYn}"`;
                    html += `   data-file="\${item.asmntSubmitStatusCd}"`;
                    if ("${vo.teamAsmntCfgYn}" == 'Y') {
                        html += `   data-teamCd="\${item.teamCd}"`;
                    }
                    html += '   class="card';
                    if ("${vo.teamAsmntCfgYn}" == 'Y') {
                        html += ' pl10';
                    }
                    html += ' active-toggle-btn">';

                    html += `   <div class="content stu_card" id="content stu_card">`;

                    html += `		<div class="icon_box">`;
                    if (item.evalYn == 'Y') {
                        html += `   	<i class="ion-android-done" aria-label="<spring:message code='button.ok.rate' />"></i>`;	// 평가완료
                    }
                    if (item.asmntSubmitStatusCd != 'NO') {
                        html += `   	<i class="file alternate outline icon" id="file alternate outline icon" aria-label="<spring:message code='common.label.asmnt.submit' />"></i>`;	// 과제제출함
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

    // 과제 조회
    function getAsmnt(stdNo) {
        var sendType = "${vo.sendType}"; // 제출형식 F: 파일, T: 텍스트
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

                if (vo.asmntSubmitStatusCd == 'NO') {
                    $("#noData").show();

                    $("#infoView ul:eq(0) dd:eq(3)").text(''); // 제출일시
                    $("#infoView ul:eq(0) dd:eq(4)").html(''); // 제출파일
                    $("#infoView ul:eq(0) dd:eq(5)").text(''); // 코멘트
                } else {
                    var sendCts = vo.sendCts == null ? "" : vo.sendCts;
                    var html = "";

                    $("#totalScore").val(vo.score);
                    var height = $(window).height() - 185;

                    // 제출형식 F: 파일, T: 텍스트

                    /* if(sendType == "T") {
                        // 제출형식 텍스트
                        html += '<div class="ui message p_h100" style="">';
                        html += (vo.sendText || "");
                        html += '</div>';
                        $("#infoView ul:eq(0) dd:eq(3)").text(dateFormat(vo.fileRegDttm)); // 제출일시
                           $("#infoView ul:eq(0) dd:eq(4)").html(''); // 제출파일
                           $("#infoView ul:eq(0) dd:eq(5)").text(sendCts); // 코멘트
                    } else { */
                    if (vo.fileList.length > 0) {
                        var ext = ['pdf', 'txt', 'png', 'gif', 'jpg'];
                        var dHtml = "";
                        var viewType = null;
                        var isView = false;
                        var existImg = false;

                        $("#infoView ul:eq(0) dd:eq(3)").text(dateFormat(vo.fileRegDttm)); // 제출일시
                        $("#infoView ul:eq(0) dd:eq(5)").text(sendCts); // 코멘트
                        $('#mainView .scrollArea').css("cursor", "default");

                        for (var i = 0; i < vo.fileList.length; i++) {
                            dHtml += "<div class='flex-item gap4'>" + vo.fileList[i].fileNm
                            dHtml += "	<button class='ui icon button p4' title='<spring:message code="asmnt.label.attachFile.download" />' onclick=\"fileDown('" + vo.fileList[i].downloadPath + "')\">";	// 파일다운로드
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

                            if (!isImage && !isPdf) {
                                html += "<div class='item pt30 pb30 noview'><p><spring:message code='asmnt.message.no_view'/><p>";
                                html += "<p class='mt10'>" + vo.fileList[i].fileNm + " (" + formatFileSize(vo.fileList[i].fileSize) + ") "
                                html += "<button class='ui icon button basic small' title='<spring:message code='asmnt.label.attachFile.download'/>' onclick=\"fileDown('" + vo.fileList[i].downloadPath + "')\">";
                                html += "	<i class='ion-android-download'></i>";
                                html += "</button>";
                                html += "</p>";
                                html += "</div>";
                            }
                        }

                        $("#infoView ul:eq(0) dd:eq(4)").html(dHtml); // 제출파일
                    } else {
                        $("#infoView ul:eq(0) dd:eq(3)").text(''); // 제출일시
                        $("#infoView ul:eq(0) dd:eq(4)").html(''); // 제출파일
                        $("#infoView ul:eq(0) dd:eq(5)").text(''); // 코멘트
                    }
                    /* } */

                    $("#viewData").empty().append(html);
                    $("#viewData").show();

                    /*         			if (isView) {
                                            if (viewType == "pdf") {
                                                showMediaExtBtn('pdf');
                                            }
                                            else {
                                                showMediaExtBtn('img');
                                            }
                                        } */

                    //$('#mainView .mediaArea iframe').contents().find("#document-container").scrollMove();
                    //$('#mainView .mediaArea iframe').contents().find("html").scrollMove();

                }

                $("#profMemo").val(vo.profMemo);

                $("#fdbkListBtn").html(vo.fdbkCnt + "<spring:message code='common.label.count.feedback' />");	// 개의 피드백
                $("#fdbkListBtn").attr("onClick", "getFdbkList('" + vo.stdNo + "')");

                if ("${vo.evalUseYn}" == 'Y') {
                    $('.ui.rating').rating('set rating', vo.evalScore);
                }
            } else {
                alert(data.message);
            }

        }, function (xhr, status, error) {
            /* 에러가 발생했습니다! */
            alert("<spring:message code='fail.common.msg' />");
        });
    }

    // 저장 확인
    function saveConfirm() {
        var isSubmit = true;
        if ("${jVo.asmntSubmitStatusCd}" != 'NO') {
            isSubmit = window.confirm("다시 제출한 과제가 최종 제출 과제입니다. 제출하시겠습니까?");
        }

        if (isSubmit) {
            if ("${vo.sendType}" == "T") {
                if (editor.isEmpty() || editor.getTextContent().trim() === "") {
                    alert("<spring:message code='asmnt.alert.input.contents' />");/* 내용을 입력하세요. */
                    return false;
                } else {
                    sendAsmnt();
                }
            } else {
                var dx = dx5.get("upload1");

                // 파일이 있으면 업로드 시작
                if (dx.availUpload()) {
                    dx.startUpload();
                }
                // 삭제파일, 이전파일 있는 경우
                else if (dx.getTotalVirtualFileCount() > 0) {
                    sendAsmnt();
                } else {
                    // 제출할 파일이 없습니다.
                    alert("<spring:message code='asmnt.alert.no.submit.file' />");
                }
            }
        }
    }


    // 운영자 학생 파일 업로드 완료
    function stuFinishUpload() {
        var dx = dx5.get("upload1");
        var url = "/file/fileHome/saveFileInfo.do";
        var data = {
            "uploadFiles": dx.getUploadFiles(),
            "copyFiles": dx.getCopyFiles(),
            "uploadPath": dx.getUploadPath()
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                sendAsmnt();
            } else {
                alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
        });
    }

    // 운영자과제 제출
    function sendAsmnt() {
        var dx = dx5.get("upload1");
        var sCd = "SUBMIT";
        var userId = "${vo.ezgUserId}";
        var stdNo = "${vo.stdNo}"
        var url = "/asmt/profAsmtNsbOnslfRegist.do";
        var data = {
            "crsCreCd": "${vo.crsCreCd}"
            , "asmntCd": "${vo.asmntCd}"
            , "asmntSendCd": "${vo.asmntSendCd}"
            , "teamAsmntCfgYn": "${vo.teamAsmntCfgYn}"
            , "asmntSubmitStatusCd": sCd
            <c:if test="${vo.sendType ne 'T'}">
            , "uploadFiles": dx.getUploadFiles()
            , "uploadPath": dx.getUploadPath()
            , "userId": userId
            , "delFileIds": dx.getDelFileIds()
            </c:if>
        };

        $.ajaxSettings.traditional = true;
        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                /* 정상 제출되었습니다. */
                alert("<spring:message code='lesson.alert.message.submit.lesson.cnts'/>");
                self.close();
                parent.ezgReload(stdNo);

            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 제출 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
            alert("<spring:message code='lesson.alert.message.no.submit'/>");
        }, true);
    }

</script>

<body class="modal-page">
<div id="wrap">
    <div class="option-content">
        <h2 class="page-title">${cVo.crsCreNm } (${cVo.declsNo }<spring:message code="asmnt.label.decls.name"/>)</h2>
        <!-- 반 -->
        <div class="mla fcBlue">
            <ul class="list_verticalline  ">
                <li>${gVo.deptNm }</li>
                <li>${gVo.userNm }( ${gVo.userId } )</li>
            </ul>
        </div>
        <div class="ui segment p0" id="viewUpload">
            <div id="wrap">
                <div class="ui styled fluid accordion">
                    <div class="content menu_off active">
                        <ul class="tbl">
                            <li>
                                <dl>
                                    <c:choose>
                                        <c:when test="${vo.sendType eq 'T' }">
                                            <dt><label>
                                                <spring:message code="asmnt.label.send.content" /><!-- 제출내용 --></label>
                                            </dt>
                                            <dd style="height:400px">
                                                <div style="height:100%">
                                                    <textarea name="contentTextArea"
                                                              id="contentTextArea">${jVo.sendText }</textarea>
                                                    <script>
                                                        // html 에디터 생성
                                                        var editor = HtmlEditor('contentTextArea', THEME_MODE, '/asmt');
                                                    </script>
                                                </div>
                                            </dd>
                                        </c:when>
                                        <c:otherwise>
                                            <dt><label for="contentTextArea">
                                                <spring:message code="forum.label.file.upload" /><!-- 파일 업로드 --></label>
                                            </dt>
                                            <dd>
                                                <c:set var="sFileType" value=""/>
                                                <c:choose>
                                                    <c:when test="${vo.prtcYn eq 'Y'}"><!-- 실기과제 여부 -->
                                                        <c:forEach items="${fn:split(vo.sbmtFileType,',') }" var="item"
                                                                   varStatus="status">
                                                            <c:if test="${status.index ne 0}"><c:set var="sFileType"
                                                                                                     value="${sFileType},"/></c:if>
                                                            <c:choose>
                                                                <c:when test="${item eq 'img'}"><c:set var="sFileType"
                                                                                                       value="${sFileType}jpg,gif,png"/></c:when>
                                                                <c:when test="${item eq 'pdf'}"><c:set var="sFileType"
                                                                                                       value="${sFileType}pdf"/></c:when>
                                                                <c:when test="${item eq 'ppt'}"><c:set var="sFileType"
                                                                                                       value="${sFileType}ppt,pptx"/></c:when>
                                                            </c:choose>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:when test="${vo.sendType eq 'F'}"><!-- 제출형식이 파일일때 여부 -->
                                                        <c:choose>
                                                            <c:when test="${empty vo.sbmtFileType or vo.sbmtFileType eq ''}"><c:set
                                                                    var="sFileType" value="*"/></c:when>
                                                            <c:otherwise>
                                                                <c:forEach items="${fn:split(vo.sbmtFileType,',') }"
                                                                           var="item" varStatus="status">
                                                                    <c:if test="${fn:contains(sFileType, 'txt') eq false}">
                                                                        <c:if test="${status.index ne 0}"><c:set
                                                                                var="sFileType" value="${sFileType},"/></c:if>
                                                                        <c:choose>
                                                                            <c:when test="${item eq 'img'}"><c:set
                                                                                    var="sFileType"
                                                                                    value="${sFileType}jpg,gif,png"/></c:when>
                                                                            <c:when test="${item eq 'pdf' || item eq 'pdf2'}"><c:set
                                                                                    var="sFileType"
                                                                                    value="${sFileType}pdf"/></c:when>
                                                                            <c:when test="${item eq 'txt' || item eq 'soc'}"><c:set
                                                                                    var="sFileType"
                                                                                    value="${sFileType}txt"/></c:when>
                                                                            <c:when test="${item eq 'hwp'}"><c:set
                                                                                    var="sFileType"
                                                                                    value="${sFileType}hwp,hwpx"/></c:when>
                                                                            <c:when test="${item eq 'doc'}"><c:set
                                                                                    var="sFileType"
                                                                                    value="${sFileType}doc,docx"/></c:when>
                                                                            <c:when test="${item eq 'ppt' || item eq 'ppt2'}"><c:set
                                                                                    var="sFileType"
                                                                                    value="${sFileType}ppt,pptx"/></c:when>
                                                                            <c:when test="${item eq 'xls'}"><c:set
                                                                                    var="sFileType"
                                                                                    value="${sFileType}xls,xlsx"/></c:when>
                                                                            <c:when test="${item eq 'zip'}"><c:set
                                                                                    var="sFileType"
                                                                                    value="${sFileType}zip"/></c:when>
                                                                        </c:choose>
                                                                    </c:if>
                                                                </c:forEach>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:set var="sFileType" value="txt"/>
                                                    </c:otherwise>
                                                </c:choose>
                                                <!-- 파일업로더 -->
                                                <div id="stuUploaderBox">
                                                    <uiex:dextuploader
                                                            id="upload1"
                                                            path="${uploadPath}"
                                                            limitCount="10"
                                                            limitSize="1024"
                                                            oneLimitSize="1024"
                                                            listSize="5"
                                                            fileList="${jVo.fileList}"
                                                            finishFunc="stuFinishUpload()"
                                                            allowedTypes="${sFileType}"
                                                            bigSize="false"
                                                            type="${vo.prtcYn eq 'Y' ? 'PRACTICE' : ''}"
                                                    />
                                                </div>

                                                <div class="mt10">
                                                    <spring:message code="asmnt.alert.oper_submit_msg" /><!-- * 제출한 파일 중 오류가 있는 파일은 삭제하고 업로드하세요. -->
                                                </div>
                                            </dd>
                                        </c:otherwise>
                                    </c:choose>
                                </dl>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="bottom-content">
                    <a class="ui blue black button toggle_btn flex-left-auto" onclick="saveConfirm();"><spring:message
                            code="asmnt.button.reg"/></a><!-- 등록 -->
                </div>
            </div>
        </div>
    </div><!-- option-content -->
</div>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>