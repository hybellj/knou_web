<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
    request.setAttribute("PAGE_FILE_UPLOAD", request.getContextPath() + CommConst.PAGE_FILE_UPLOAD);
%>
<%@page import="knou.framework.util.CommonUtil" %>
<%
    // 아이폰 음성녹음 임시 막기
    String userAgent = request.getHeader("User-Agent") != null ? request.getHeader("User-Agent").toLowerCase() : "";
    String deviceType = CommonUtil.getDeviceType(request);
    String hycuappIos = "N";
    String iPhone = "N";

    if(userAgent.indexOf("iphone") > -1 || userAgent.indexOf("ipad") > -1 || userAgent.indexOf("ipod") > -1) {
        iPhone = "Y";
    }
    if(iPhone == "Y" && userAgent.indexOf("hycuapp") > -1) {
        hycuappIos = "Y";
    }

    String audioRecordUseYn = "Y".equals(iPhone) && "Y".equals(hycuappIos) ? "N" : "Y";
    request.setAttribute("AUDIO_RECORD_USE_YN", audioRecordUseYn);
%>

<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    <%@ include file="/WEB-INF/jsp/asmt/common/asmt_common_inc.jsp" %>
    <link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>
    <link rel="stylesheet" href="/webdoc/player/plyr.css"/>
    <link rel="stylesheet" href="/webdoc/audio-recorder/audio-recorder.css"/>

    <script src="/webdoc/player/plyr.js" crossorigin="anonymous"></script>
    <script src="/webdoc/player/player.js" crossorigin="anonymous"></script>
    <script src="/webdoc/audio-recorder/audio-recorder.js"></script>

    <script type="text/javascript">
        // var fUploader = {};
        var aUploader = {};
        var aRecord = {};
        var aPlayer = {};
        var edtNo = null;
        var audioRecord = null;
        var virtualFileList = new Array();

        $(document).ready(function () {

            if ('${AUDIO_RECORD_USE_YN}' == "Y") {
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
            }
            fdbkList();
        });

        // 리스트 조회
        function fdbkList(page) {
            // fUploader = {};
            aRecord = {};
            aPlayer = {};
            makeAudioRecord(0);

            var url = "/asmt/profAsmtFdbkSelect.do";
            var data = {
                "selectType": "LIST",
                "asmtId": "${gVo.asmtId}",
                "stdNo": "${gVo.stdNo}"
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    if (data.returnList.length > 0) {
                        var rList = data.returnList;
                        $("#feedbackList").empty().html(createHTML(rList));

                        var params = {
                            totalCount: data.pageInfo.totalRecordCount,
                            listScale: data.pageInfo.pageSize,
                            currentPageNo: data.pageInfo.currentPageNo,
                            eventName: "fdbkList"
                        };

                        gfn_renderPaging(params);

                        for (var i = 0; i < rList.length; i++) {
                            // 오디오파일 팝업
                            makeAudioRecord((i + 1));

                            for (var j = 0; j < rList[i].fileList.length; j++) {
                                var fId = rList[i].fileList[j].fileId;
                                var fNm = rList[i].fileList[j].fileNm;
                                var fSize = rList[i].fileList[j].fileSize;
                                var fExt = rList[i].fileList[j].fileExt;

                                if (fExt == "mp3") {
                                    makeAudioPlayer((i + 1), (j + 1));
                                    // 'aUploader[aUploader + (i + 1)]'가 존재하는지 확인
                                    var uploaderKey = 'aUploader' + (i + 1);
                                    if (!aUploader[uploaderKey]) {
                                        // 만약 객체가 정의되지 않았다면 초기화
                                        aUploader[uploaderKey] = {
                                            addOldFile: function (id, name, size) {
                                            }
                                        };
                                    }
                                    // addOldFile 호출
                                    aUploader[uploaderKey].addOldFile(fId, fNm, fSize);
                                } else {
                                    // fUploader[`fUploader`+(i+1)].addOldFile( fId, fNm, fSize );
                                }
                                virtualFileList[i] = fId + ";" + fNm + ";" + fSize;
                                byteConvertor(fSize, fNm, "file_" + rList[i].fileList[j].fileSn);
                            }

                            $("#fdbkAudioBox" + (i + 1) + " .ajax-upload-dragdrop").remove();
                            $("#fdbkAudioBox" + (i + 1) + " .file-uploader-tot-progress").remove();
                            $("#fdbkAudioBox" + (i + 1) + " .ajax-file-upload-container").remove();
                            $("#fdbkAudioBox" + (i + 1)).css('border', '0px');
                            $("#fdbkAudioBox" + (i + 1) + " .file-uploader-edit-box").css('border-top', '0px');
                        }

                        $(".audio-header").remove();
                        $(".audio-btm .btm-btn").remove();
                    } else {
                        var html = "";
                        html += "<div class='flex-container m-hAuto'>";
                        html += "    <div class='no_content'>";
                        html += "        <i class='icon-cont-none ico f170'></i>";
                        html += "        <span><spring:message code='common.nodata.msg'/></span>";
                        html += "    </div>";
                        html += "</div>";

                        $("#feedbackList").empty().html(html);
                    }
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                /* 에러가 발생했습니다! */
                alert("<spring:message code='fail.common.msg' />");
            }, true);
        }

        function makeAudioRecord(i) {
            if ('${AUDIO_RECORD_USE_YN}' == "Y") {
                aRecord[`aRecord` + i] = UiAudioRecorder("audioRecord" + i);
                aRecord[`aRecord` + i].formName = "recordForm";
                aRecord[`aRecord` + i].dataName = "audioData";
                aRecord[`aRecord` + i].fileName = "audioFile";
                aRecord[`aRecord` + i].lang = "ko";
                aRecord[`aRecord` + i].init();
                aRecord[`aRecord` + i].recorderBox.css({"top": "0px", "left": "0px"});
                aRecord[`aRecord` + i].setRecorder();

                $("#audioRecord" + i).height($(".recorder-box").height() + 22);
                aRecord[`aRecord` + i].recorderBox.show();
            }
        }

        function makeAudioPlayer(i, j) {
            if ('${AUDIO_RECORD_USE_YN}' == "Y") {
                aPlayer[`aPlayer` + i] = UiMediaPlayer("audioPlayer" + i + "_" + j);
            }
        }

        // 피드백 수정 버튼
        function btnFdbkEdt(i) {
            $("#fdbkValue" + i).prop("readonly", false);
            $("#aFileView" + i).hide();
            $("#aFileEditView" + i).show();

            $("#fdbk" + i + " .button-area a").eq(0).hide();
            $("#fdbk" + i + " .button-area a").eq(1).hide();
            $("#fdbk" + i + " .button-area a").eq(2).show();
            $("#fdbk" + i + " .button-area a").eq(3).show();
        }

        // 피드백 취소 버튼
        function btnFdbkCancel(i) {
            $("#fdbkValue" + i).val($("#fdbkValue" + i).text());

            $("#fdbkValue" + i).prop("readonly", true);
            $("#aFileView" + i).show();
            $("#aFileEditView" + i).hide();

            $("#fdbk" + i + " .button-area a").eq(0).show();
            $("#fdbk" + i + " .button-area a").eq(1).show();
            $("#fdbk" + i + " .button-area a").eq(2).hide();
            $("#fdbk" + i + " .button-area a").eq(3).hide();
        }

        // 피드백 저장 버튼
        function btnFdbkSave(i) {
            edtNo = i;
            // 피드백 등록 버튼

            if (fUploader[`fUploader` + i].getFileCount() > 0) {
                fUploader[`fUploader` + i].startUpload();
            } else {
                // 저장 호출
                edtFdbk();
            }
        };

        // 파일 업로드 완료
        function edtUpload() {
            edtFdbk();
        }

        // 피드백 저장
        function edtFdbk() {

            var delFileIds = [];
            if ($("#fdbkFileBox" + edtNo).css("display") != 'none') {
                for (var i = 0; i < $("#fdbkFileBox" + edtNo + " input:checkbox[name='delFileIds']:checked").length; i++) {
                    delFileIds.push($("#fdbkFileBox" + edtNo + " input:checkbox[name='delFileIds']:checked").eq(i).val());
                }
            }
            if ($("#fdbkAudioBox" + edtNo).css("display") != 'none') {
                if (aRecord[`aRecord` + edtNo].audioFile != '' &&
                    ($("#fdbkAudioBox" + edtNo + " input:checkbox[name='delFileIds']").length
                        - $("#fdbkAudioBox" + edtNo + " input:checkbox[name='delFileIds']:checked").length) > 0) {

                    /* 하나의 음성파일만 저장 할 수 있습니다. */
                    alert('<spring:message code="common.alert.one.message.save"/>');

                    return false;
                }
                for (var i = 0; i < $("#fdbkAudioBox" + edtNo + " input:checkbox[name='delFileIds']:checked").length; i++) {
                    delFileIds.push($("#fdbkAudioBox" + edtNo + " input:checkbox[name='delFileIds']:checked").eq(i).val());
                }
            }

            var url = "/asmt/profAsmtFdbkModify.do";
            var data = {
                "asmntFdbkId": $("#fdbk" + edtNo).data("fdbkCd"),
                "fdbkCts": $("#fdbkValue" + edtNo).val(),
                // "uploadFiles" : fUploader[`fUploader`+edtNo].getUploadFiles(),
                // "uploadPath"  : fUploader[`fUploader`+edtNo].path,
                // "copyFiles"   : fUploader[`fUploader`+edtNo].getCopyFiles(),
                "uploadFiles": "",
                "uploadPath": "",
                "copyFiles": "",
                "delFileIds": delFileIds,
                "audioData": aRecord[`aRecord` + edtNo].audioData,
                "audioFile": aRecord[`aRecord` + edtNo].audioFile
            };

            edtNo = null;
            $.ajaxSettings.traditional = true;
            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    /* 피드백 수정에 성공하였습니다. */
                    alert("<spring:message code='forum.alert.update_success.feedback' />");
                    location.reload();
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                /* 에러가 발생했습니다! */
                alert("<spring:message code='fail.common.msg' />");
            }, true);
        }

        // 피드백 삭제 버튼
        function btnFdbkDelete(i) {
            if (window.confirm("<spring:message code='seminar.confirm.delete' />")) {/* 삭제 하시겠습니까? */
                var url = "/asmt/profAsmtFdbkModify.do";
                var data = {
                    "asmntFdbkId": $("#fdbk" + i).data("fdbkCd")
                };

                ajaxCall(url, data, function (data) {
                    if (data.result > 0) {
                        /* 정상 삭제되었습니다. */
                        alert("<spring:message code='seminar.alert.delete' />");
                        location.reload();
                    } else {
                        alert(data.message);
                    }
                }, function (xhr, status, error) {
                    /* 삭제 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
                    alert("<spring:message code='seminar.error.delete' />");
                }, true);
            }
        }

        function fdbkFileOpen(i) {
            edtNo = i;
            writeOpen();
            $("#fileView" + i).show();
        }

        function fdbkAudioOpen(i) {
            edtNo = i;
            writeOpen();
            $("#audioView" + i).show();
        }

        function writeOpen() {
            $("#feedbackList").hide();
            $("#feedbackListBtn").hide();
            $("#feedbackWrite").show();
            $("#feedbackWriteBtn").show();

            $("#feedbackWrite .row").hide();
        }

        function writeClose() {
            edtNo = null;

            $("#feedbackWrite").hide();
            $("#feedbackWriteBtn").hide();
            $("#feedbackList").show();
            $("#feedbackListBtn").show();
        }

        function writeSave() {
            btnFdbkSave(edtNo);
        }

        function createHTML(data) {
            var html = "";

            $.each(data, function (i, o) {
                var fCnt = 0;
                var aCnt = 0;

                for (var j = 0; j < o.fileList.length; j++) {
                    if (o.fileList[j].fileExt != "mp3") {
                        fCnt++;
                    } else {
                        aCnt++;
                    }
                }

                html += "<div class='ui segment' id='fdbk" + (i + 1) + "' data-FDBK-CD='" + o.asmntFdbkId + "'>";
                html += "    <div class='option-content mb10'>";
                html += "        <p class='mra'>" + dateFormat(o.regDttm) + "</p>";
                if ("${menuType}" != 'STUDENT') {
                    html += "        <div class='button-area'>";
                    html += "           <a href='javascript:btnFdbkEdt(" + (i + 1) + ")' class='ui basic small button'><spring:message code='forum.button.fdbk.mod'/><!-- 글수정 --></a>";
                    html += "           <a href='javascript:btnFdbkDelete(" + (i + 1) + ")' class='ui basic small button'><spring:message code='forum.button.del'/><!-- 삭제 --></a>";
                    html += "           <a href='javascript:btnFdbkSave(" + (i + 1) + ")' class='ui basic small button' style='display:none;'><spring:message code='forum.button.save'/><!-- 저장 --></a>";
                    html += "        <a href='javascript:btnFdbkCancel(" + (i + 1) + ")' class='ui basic small button' style='display:none;'><spring:message code='forum.button.cancel'/><!-- 취소 --></a>";
                    html += "        </div>";
                }
                html += "    </div>";
                html += "    <div id='fdbkValueDiv" + (i + 1) + "' class='ui segment' style='max-height:200px;overflow:auto'><pre>" + o.fdbkCts + "</pre></div>";

                var aName = "";
                var fName = "";
                html += "   <div class='ui box mt10' id='aFileView" + (i + 1) + "'>";
                html += "       <div class='fields mr0'>";
                html += "           <div class='field'>";
                html += "               <button class='ui basic icon button'><i class='save icon'></i><spring:message code='forum.label.fdbk.file.attach'/></button>";
                html += "           </div>";
                html += "           <div class='field ui segment flex1 flex-item p4'>";
                html += "               <div class='align-items-center gap8'>";

                if (fCnt > 0) {
                    for (var j = 0; j < o.fileList.length; j++) {
                        if (o.fileList[j].fileExt != "mp3") {
                            html += "            <button class='ui icon small button d-block' style='margin-bottom: 2px;' id='file_" + o.fileList[j].fileSn + "' title='<spring:message code="asmnt.label.attachFile.download"/>' onclick=\"fileDown('" + o.fileList[j].fileSn + "', '" + o.fileList[j].repoCd + "')\">";
                            html += "                <i class='paperclip icon f080'></i>";
                            html += "            </button>";

                            fName = o.fileList[j].fileNm;
                            //
                        }
                    }
                }
                html += "               </div>";
                html += "           </div>";
                html += "       </div>";

                if ('${AUDIO_RECORD_USE_YN}' == "Y") {
                    html += "       <div class='fields mr0'>";
                    html += "           <div class='field'>";
                    html += "               <button class='ui basic icon button'><i class='microphone icon'></i><spring:message code='forum.label.fdbk.audio.attach'/></button>";
                    html += "           </div>";
                    html += "           <div class='field ui segment flex1 flex-item p4'>";
                    html += "               <div class='flex align-items-center gap8' style='margin: -3px;'>";
                    if (aCnt > 0) {
                        for (var j = 0; j < o.fileList.length; j++) {
                            if (o.fileList[j].fileExt == "mp3") {
                                html += "            <audio id='audioPlayer" + (i + 1) + "_" + (j + 1) + "' lang='en'>";
                                html += "               <source src='${pageContext.request.contextPath}" + o.fileList[j].filePath + "/" + o.fileList[j].fileSaveNm + "' type='audio/mp3'>";
                                html += "           </audio>";

                                aName = o.fileList[j].fileNm;
                            }
                        }
                    }
                    html += "               </div>";
                    html += "           </div>";
                    html += "       </div>";
                }
                html += "   </div>";

                html += "   <div class='ui box mt10' id='aFileEditView" + (i + 1) + "' style='display:none;'>";
                html += "       <div class='fields mr0'>";
                html += "           <div class='field'>";
                html += "               <button class='ui basic icon button' onclick='fdbkFilePopOpen(" + (i + 1) + ");'><i class='save icon'></i><spring:message code='forum.label.fdbk.file.attach'/></button>";
                html += "           </div>";
                html += "           <div class='field ui segment flex1 flex-item p4'>";
                html += "               <div class='flex align-items-center gap8' id='fdbkEdtFileView" + (i + 1) + "'>";
                if (fName != "") {
                    html += "                   <i class='paperclip icon f080'></i>" + fName;
                }
                html += "               </div>";
                html += "           </div>";
                html += "       </div>";
                html += "       <div class='fields mr0'>";
                html += "           <div class='field'>";
                html += "               <button class='ui basic icon button' onclick='fdbkAudioPopOpen(" + (i + 1) + ");'><i class='microphone icon'></i><spring:message code='forum.label.fdbk.audio.attach'/></button>";
                html += "           </div>";
                html += "           <div class='field ui segment flex1 flex-item p4'>";
                html += "               <div class='flex align-items-center gap8' id='fdbkEdtAudioView" + (i + 1) + "'>";
                if (aName != "") {
                    html += "                   <i class='paperclip icon f080'></i>" + aName;
                }
                html += "               </div>";
                html += "           </div>";
                html += "       </div>";
                html += "   </div>";

                html += "</div>";
            });
            return html;
        }
    </script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>
<div id="wrap" class="flex flex-column">
    <div class="ui form">
        <div class="option-content">
            <h2 class="page-title">${cVo.crsCreNm} (${cVo.declsNo}<spring:message code="asmnt.label.decls.name"/>)</h2>
            <!-- 반 -->
            <div class="mla fcBlue">
                <ul class="list_verticalline  ">
                    <li>${gVo.deptNm}</li>
                    <li>${gVo.userNm}( ${gVo.userId} )</li>
                    <c:if test="${gVo.scr ne '' && gVo.scr ne NULL && gVo.asmntScoreOpenYn eq 'Y'}">
                        <li>
                            ${gVo.scr}<spring:message code="asmnt.label.point" /><!-- 점 -->
                        </li>
                    </c:if>
                </ul>
            </div>
        </div>

        <div id="feedbackList" class="mt10"></div>
    </div>

    <div class="bottom-content">
        <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message
                code="team.common.close"/></button><!-- 닫기 -->
    </div>
</div>

<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>