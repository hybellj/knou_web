<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.util.Enumeration" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/asmt/common/asmt_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>
<script type="text/javascript">
    var virtualFileList = new Array();

    $(document).ready(function () {
        if ("${jVo.sbmsnStscd}" == 'NO') {
            $("#btnEdit").hide();
        }

        $("#btnSave").hide();
        $("#btnCancel").hide();
        $(".accordion").accordion();

        <c:if test="${vo.sbmtOpenYn eq 'Y' && today > vo.sbmtStartDttm && today < vo.sbmtEndDttm && vo.prtcYn eq 'Y'}">
        listAsmntUser();
        </c:if>

        $("#viewUpload").attr("style", "overflow: hidden; position: absolute; width: 0; height: 0; line-height: 0; text-indent: -9999px;");
    });

    function manageAsmnt(tab) {
        var urlMap = {
            "0": "/asmt/stu/asmtInfoManage.do",  // 과제 상세 정보 페이지
            "1": "/asmt/stu/asmtScoreManage.do"  // 과제 평가 관리 페이지
        };

        var kvArr = [];
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'asmtId', 'val': "${vo.asmtId}"});

        submitForm(urlMap[tab], "", kvArr);
    }

    // 제출과제 수정
    function editAsmnt() {
        $("#viewData").hide();
        $("#viewNoData").hide();
        $("#btnEdit").hide();
        $("#btnSave").show();
        $("#btnCancel").show();
        // $("#viewUpload").show();
        $("#viewUpload").attr('style', "display:block;");
    }

    // 제출과제 취소
    function cancelAsmnt() {
        var dx = dx5.get("upload1");
        dx.removeAll();
        dx.revokeAllVirtualFiles();

        $("#btnSave").hide();
        $("#btnCancel").hide();
        $("#viewUpload").hide();
        if ("${jVo.sbmsnStscd}" == 'NO') {
            $("#viewNoData").show();
        } else {
            $("#viewData").show();
            $("#btnEdit").show();
        }
    }


    // 과제 제출
    function sendAsmnt() {
        var dx = dx5.get("upload1");
        var sendType = "${vo.sendType}";

        var url = "/asmt/stu/regAsmnt.do";
        var data = {
            "crsCreCd": "${vo.crsCreCd}",
            "asmtId": "${jVo.asmtId}",
            "asmtSbmsnId": "${jVo.asmtSbmsnId}",
            "teamAsmtStngyn": "${vo.teamAsmtStngyn}",
            <c:if test="${vo.sendType ne 'T'}">
            "uploadFiles": dx.getUploadFiles(),
            "uploadPath": dx.getUploadPath(),
            "delFileIds": dx.getDelFileIds(),
            </c:if>
            <c:if test="${vo.sendType eq 'T'}">
            "sendText": editor.getPublishingHtml(),
            </c:if>
            "sbmsnCts": $("#sbmsnCts").val()
        };

        $.ajaxSettings.traditional = true;
        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                // 정상 제출되었습니다.
                alert("<spring:message code='lesson.alert.message.submit.lesson.cnts'/>");
                moveReload();
            } else {
                alert(data.message);
                moveReload();
            }
        }, function (xhr, status, error) {
            // 제출 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요.
            alert("<spring:message code='lesson.alert.message.no.submit'/>");
            location.reload();
        }, true);
    }

    // 목록
    function viewAsmntList() {
        var url = "/asmt/stu/listView.do";
        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "listForm");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: "${vo.crsCreCd}"}));
        form.appendTo("body");
        form.submit();
    }

    // 저장 확인
    function saveConfirm() {
        var isSubmit = true;
        if ("${jVo.sbmsnStscd}" != 'NO') {
            isSubmit = window.confirm("다시 제출한 과제가 최종 제출 과제입니다. 제출하시겠습니까?");
        }

        if (isSubmit) {
            if ("${vo.sendType}" == "T") {
                if (editor.isEmpty() || editor.getTextContent().trim() === "") {
                    // 내용을 입력하세요.
                    alert("<spring:message code='asmnt.alert.input.contents' />");
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

    // 파일 업로드 완료
    function finishUpload() {
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
                console.log(data)
                alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
        });
    }

    // 피드백 가져오기
    function fdbkList(stdNo) {
        var modalId = "Ap10";
        initModal(modalId);

        var kvArr = [];
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'asmtId', 'val': "${vo.asmtId}"});
        kvArr.push({'key': 'stdNo', 'val': "${jVo.stdNo}"});

        submitForm("/asmt/profAsmtFdbkPopView.do", modalId + "ModalIfm", kvArr);
    }

    // 피드백 가져오기
    function fdbkListView(stdNo) {
        var modalId = "Ap10";
        initModal(modalId);

        var kvArr = [];
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'asmtId', 'val': "${vo.asmtId}"});
        kvArr.push({'key': 'stdNo', 'val': "${jVo.stdNo}"});

        submitForm("/asmt/profAsmtFdbkPopListView.do", modalId + "ModalIfm", kvArr);
    }

    // 팀 구성원 보기
    function teamMemberView(lrnGrpId) {
        var modalId = "Ap06";
        initModal(modalId);

        var kvArr = [];
        kvArr.push({'key': 'lrnGrpId', 'val': lrnGrpId});

        submitForm("/forum/forumLect/teamMemberList.do", modalId + "ModalIfm", kvArr);
    }

    // 우수과제
    function getBestView(asmtSbmsnId, stdNo) {
        var modalId = "Ap20";
        initModal(modalId);

        var kvArr = [];
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'asmtId', 'val': "${vo.asmtId}"});
        kvArr.push({'key': 'asmtSbmsnId', 'val': asmtSbmsnId});
        kvArr.push({'key': 'stdNo', 'val': stdNo});

        submitForm("/asmt/stu/bestViewPop.do", modalId + "ModalIfm", kvArr);
        // 우수과제 레이어 팝업 크기 수정
        $("#" + modalId + "Modal").children("div.modal-dialog").removeClass("modal-lg").addClass("modal-extra-lg");
    }

    // 과제 평가 참여자 리스트 조회
    function listAsmntUser() {
        var prtcYn = "${vo.prtcYn}";
        //showLoading();

        // 과제 유형에 따라 URL 분기(개인, 팀)
        var url = "";
        if ("${vo.teamAsmtStngyn}" == 'Y') {
            url = "/asmt/profAsmtTeamPtcpntSelect.do";
        } else {
            url = "/asmt/profAsmtSbmsnPtcpntSelect.do";
        }

        var data = {
            "selectType": "LIST",
            "crsCreCd": "${vo.crsCreCd}",
            "asmtId": "${vo.asmtId}",
        };

        if ("${vo.teamAsmtStngyn}" == 'Y' && "${vo.teamEvalYn}" == 'Y') {
            data.searchKey2 = "${jVo.teamId}";
        }

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var html = "";
                var iHtml = "";
                data.returnList.forEach(function (o, i) {
                    var scr = o.scr != null && o.scr != "" ? o.scr : "-";
                    var regDt = o.fileRegDttm != null ? dateFormat(o.fileRegDttm) : "";

                    if (prtcYn == "Y") {
                        html += "<div class='item'>";
                        html += "   <div class='option-content header'>";
                        var fileNm = o.fileNm != null ? o.fileNm : "<spring:message code='common.not.submission'/>";
                        var fileExt = o.fileNm != null ? o.fileExt + "1" : "";
                        fileNm = fileNm.substring(0, fileNm.length - fileExt.length);
                        html += "       <div class='title ellipsis mra'>" + fileNm + "</div>";
                        html += "       <ul class='extra'>";
                        if (o.exlnAsmtyn == "Y") {
                            html += "           <li class='ui icon top'>";
                            html += "               <i class='trophy icon fcTeal' title='<spring:message code="common.label.excellent.asmnt" />' aria-label='<spring:message code="common.label.excellent.asmnt" />'></i>";
                            html += "           </li>";
                        }
                        if ("${vo.evalUseYn}" == "Y" && "${vo.evalRsltOpenYn}" == "Y") {
                            html += "           <li>";
                            html += "               <i class='star icon fcYellow' title='<spring:message code="asmnt.label.horoscope" />' aria-label='<spring:message code="asmnt.label.horoscope" />'></i>";
                            html += (o.evalScore * 1).toFixed(1);
                            html += "           </li>";
                        }
                        html += "       </ul>";
                        html += "   </div>";
                        html += "   <div class='media'>";
                        if (o.fileNm != null) {
                            if (o.fileExt == "png" || o.fileExt == "gif" || o.fileExt == "jpg") {
                                html += "       <div class='img' onclick='getBestView(\"" + o.asmtSbmsnId + "\", \"" + o.stdNo + "\")''><img src='<%=CommConst.WEBDATA_CONTEXT %>" + o.filePath + "' alt='<spring:message code="common.label.image" />'></div>";
                            } else {
                                html += "       <div class='img' onclick='getBestView(\"" + o.asmtSbmsnId + "\", \"" + o.stdNo + "\")''><iframe class='wmax pushable' style='position:absolute;z-index:-99' scrolling='no' title='<spring:message code="crs.label.asmnt" />' src='<%=CommConst.WEBDATA_CONTEXT %>" + o.filePath + "'></iframe></div>";
                            }
                        } else {
                            html += "       <div class='img'><img src='/webdoc/img/image_placeholder_300x300.png' alt='<spring:message code="common.label.image" />'></div>";
                        }
                        html += "   </div>";
                        html += "   <div class='option-content'>";
                        html += "       <div class='user mra'>";
                        var userImg = o.phtFile != null ? o.phtFile : "/webdoc/img/icon-hycu-symbol-grey.svg";
                        html += "           <div class='img circle'><img src='" + userImg + "' alt=''></div>"; // 학습자 프로필 이미지
                        html += "           <div class='ml5'>" + o.userNm + "</div>";
                        html += "       </div>";
                        html += "       <div class=''>" + o.sbmsnStscdnm + " " + regDt + "</div>";
                        html += "   </div>";
                        html += "   <div class='option-content'>";
                        html += "       <span>" + o.deptNm + "</span>";
                        html += "       <span class='bullet_slash'>" + o.userId + "</span>";
                        html += "       <div class='extra gap8 mla'>";
                        html += "           <button type='button' title='댓글' aria-label='댓글' onclick='setCmnt(\"" + o.stdNo + "\")'><i class='xi-message-o f150' aria-hidden='true'></i></button>";
                        html += "       </div>";
                        html += "   </div>";
                        html += "</div>";
                    } else {
                        html += "<tr>";
                        html += "   <td>" + o.lineNo + "</td>";
                        html += "   <td>" + o.userNm;
                        if (o.exlnAsmtyn == 'Y') {
                            html += "<ul class='ui icon top dropdown trophyDropdown' tabindex='0'>";
                            html += "   <i class='trophy icon fcTeal' aria-label='<spring:message code="common.label.excellent.asmnt" />'></i>";
                            html += "</ul>";
                        }
                        html += "   </td>";
                        var fileNm = o.fileNm != null ? o.fileNm : "<spring:message code='common.not.submission'/>";
                        var fileExt = o.fileNm != null ? o.fileExt + "1" : "";
                        fileNm = fileNm.substring(0, fileNm.length - (fileExt.length));
                        if (o.fileNm != null) {
                            html += "   <td><a class='fcBlue' href='javascript:getBestView(\"" + o.asmtSbmsnId + "\", \"" + o.stdNo + "\")'>" + fileNm + "</a></td>";
                        } else {
                            html += "   <td>" + fileNm + "</td>";
                        }
                        if ("${vo.evalUseYn}" == "Y") {
                            html += "   <td class='tc'>"
                            html += "       <div class='ui tiny star rating gap4' data-rating='" + o.evalScore + "' data-max-rating='5'>";
                            html += "           <i class='icon'></i>";
                            html += "           <i class='icon'></i>";
                            html += "           <i class='icon'></i>";
                            html += "           <i class='icon'></i>";
                            html += "           <i class='icon'></i>";
                            html += "       </div>";
                            html += "   </td>";
                        }
                        html += "</tr>";
                    }
                });
                $("#asmntStareUserList").empty().append(html);

                $("#sindvAsmtList").empty().append(iHtml);

                $(".table").footable();
                $('.ui.rating').rating({interactive: false});
            } else {
                alert(data.message);
            }

            //hideLoading();
        }, function (xhr, status, error) {
            //hideLoading();
            /* 에러가 발생했습니다! */
            alert("<spring:message code='fail.common.msg' />");
        }, true);
    }

    // 댓글 팝업
    function setCmnt(stdNo) {
        var modalId = "Ap14";
        initModal(modalId);

        var kvArr = [];
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'asmtId', 'val': "${vo.asmtId}"});
        kvArr.push({'key': 'stdNo', 'val': stdNo});

        submitForm("/asmt/profAsmtCmntPopView.do", modalId + "ModalIfm", kvArr);
    }

    // 루브릭 정보 팝업
    function mutEvalInfoPop() {
        var modalId = "Ap16";
        initModal(modalId);

        var kvArr = [];
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'asmtEvlId', 'val': "${vo.asmtEvlId}"});
        kvArr.push({'key': 'searchType', 'val': "INFO"});

        submitForm("/mut/mutPop/mutEvalWritePop.do", modalId + "ModalIfm", kvArr);
    }

    function moveReload(asmtId) {
        var urlMap = {
            "0": "/asmt/stu/asmtInfoManage.do",  // 과제 상세 정보 페이지
            "1": "/asmt/stu/asmtScoreManage.do"  // 과제 평가 관리 페이지
        };

        var kvArr = [];
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'asmtId', 'val': "${vo.asmtId}"});

        submitForm(urlMap["0"], "", kvArr);
    }
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">

<jsp:useBean id="now" class="java.util.Date"/>
<fmt:formatDate var="nowFmt" pattern="yyyyMMddhhmmss" value="${now}"/>

<div id="wrap" class="pusher">

    <!-- class_top 인클루드  -->
    <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>

    <div id="container">

        <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>

        <!-- 본문 content 부분 -->
        <div class="content stu_section">
            <%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>

            <div class="ui form">
                <div class="layout2">
                    <script>
                        $(document).ready(function () {
                            // set location
                            setLocationBar('<spring:message code="asmnt.label.asmnt"/>', '<spring:message code="asmnt.label.asmnt.info" />');
                        });
                    </script>

                    <div id="info-item-box">
                        <h2 class="page-title flex-item flex-wrap gap4 columngap16">
                            <spring:message code="asmnt.label.asmnt"/><!-- 과제 -->
                        </h2>
                        <div class="button-area">
                            <a href="javascript:viewAsmntList()" class="ui basic button" id="btnList"><spring:message
                                    code="bbs.label.list"/></a><!-- 목록 -->
                        </div>
                    </div>

                    <div class="row">
                        <div class="col">

                            <div class="listTab">
                                <ul class="">
                                    <li class="select mw120">
                                        <a onclick="manageAsmnt(0)">
                                            <spring:message code='asmnt.label.asmnt.info'/><!-- 과제정보 --></a>
                                    </li>

                                    <c:set var="auditYn"><%=SessionInfo.getAuditYn(request) %>
                                    </c:set>
                                    <c:if test="${vo.evalUseYn eq 'Y' && auditYn ne 'Y'}">
                                        <li class="mw120">
                                            <a onclick="manageAsmnt(1)">
                                                <spring:message code="common.label.mut.evaluation" /><!-- 상호평가 --></a>
                                        </li>
                                    </c:if>
                                </ul>
                            </div>
                            <div class="ui segment">
                                <%@ include file="/WEB-INF/jsp/asmt/common/stu_asmnt_info_inc.jsp" %>
                            </div>
                        </div>
                    </div>

                    <c:if test="${auditYn ne 'Y'}">
                        <div class="row">
                            <div class="col">

                                <div class="flex mb10">
                                    <h3><spring:message code="asmnt.button.submit.add"/></h3>
                                    <c:if test="${PROFESSOR_VIRTUAL_LOGIN_YN ne 'Y'}">
                                        <div class="button-area mla">
                                            <c:if test="${nowFmt le vo.sendEndDttm or
                                                                (vo.extSendAcptYn == 'Y' and nowFmt le vo.extSendDttm) or
                                                                (jVo.resbmsnyn == 'Y' and nowFmt ge vo.resbmsnSdttm and nowFmt le vo.resbmsnEdttm)}">
                                                <a href="javascript:editAsmnt()" class="ui blue button" id="btnEdit">
                                                    <spring:message code="asmnt.label.send.restart" /><!-- 다시제출하기 --></a>
                                            </c:if>

                                            <c:choose>
                                                <c:when test="${jVo.userId eq 'test'}">
                                                    <a href="javascript:saveConfirmDext()" class="ui blue button"
                                                       id="btnSave">
                                                        <spring:message code="user.button.save" /><!-- 저장 --></a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="javascript:saveConfirm()" class="ui blue button"
                                                       id="btnSave">
                                                        <spring:message code="user.button.save" /><!-- 저장 --></a>
                                                </c:otherwise>
                                            </c:choose>
                                            <a href="javascript:cancelAsmnt()" class="ui basic button" id="btnCancel">
                                                <spring:message code="user.button.cancel" /><!-- 취소 --></a>
                                        </div>
                                    </c:if>
                                </div>

                                <div class="ui segment p0"
                                     id="viewNoData"  ${jVo.sbmsnStscd eq 'NO' ? '' : 'style="display: none;"'}>
                                    <div class="ui styled fluid accordion">
                                        <!-- 항목 없을 때 -->
                                        <div class="title">
                                            <div class="flex-container" style="min-height: 300px;">
                                                <div class="cont-none">
                                                    <span><spring:message code="asmnt.message.empty"/><!-- 등록된 내용이 없습니다. --></span>
                                                    <br><br>
                                                    <a href="javascript:editAsmnt()" class="ui blue button">
                                                        <spring:message code="asmnt.label.send.start" /><!-- 제출하기 --></a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="ui segment p0"
                                     id="viewData" ${jVo.sbmsnStscd eq 'NO' ? 'style="display: none;"' : ''}>
                                    <div class="ui styled fluid accordion">
                                        <div class="content menu_off active">
                                            <ul class="tbl-simple">
                                                <li>
                                                    <dl>
                                                        <dt>
                                                            <label for="teamLabel">
                                                                <spring:message code="common.label.submit.dttm" /><!-- 제출일시 --></label>
                                                        </dt>
                                                        <dd>
                                                            <fmt:parseDate var="fileRegFmt" pattern="yyyyMMddHHmmss"
                                                                           value="${jVo.fileRegDttm}"/>
                                                            <fmt:formatDate var="fileRegDttm" pattern="yyyy.MM.dd HH:mm"
                                                                            value="${fileRegFmt}"/>
                                                                ${fileRegDttm}
                                                        </dd>
                                                    </dl>
                                                </li>
                                                <li>
                                                    <dl>
                                                        <c:choose>
                                                            <c:when test="${vo.sendType eq 'T'}">
                                                                <dt>
                                                                    <label for="contLabel">
                                                                        <spring:message code="asmnt.label.send.content" /><!-- 제출내용 --></label>
                                                                </dt>
                                                                <dd>
                                                                    <pre>${jVo.sendText}</pre>
                                                                </dd>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <dt>
                                                                    <label for="contLabel">
                                                                        <spring:message code="asmnt.label.send.file"/><!-- 제출파일 --></label>
                                                                </dt>
                                                                <dd>
                                                                    <c:forEach items="${jVo.fileList}" var="item"
                                                                               varStatus="status">
                                                                        <button class="ui icon small button"
                                                                                id="file2_${item.fileSn}"
                                                                                title="<spring:message code='asmnt.label.attachFile.download'/>"
                                                                                onclick="fileDown('${item.fileSn}', '${item.repoCd }')">
                                                                            <i class="ion-android-download"></i>
                                                                        </button>
                                                                        <script>
                                                                            virtualFileList[${status.index}] = "${item.fileSn}" + ";" + "${item.fileNm}" + ";" + "${item.fileSize}" + ";" + "${item.fileSaveNm}";
                                                                            byteConvertor("${item.fileSize}", "${item.fileNm}", "file2_${item.fileSn}");
                                                                        </script>
                                                                    </c:forEach>
                                                                </dd>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </dl>
                                                </li>
                                                <li>
                                                    <dl>
                                                        <dt>
                                                            <label for="contLabel">
                                                                <spring:message code="exam.label.eval.submit.status" /><!-- 제출/평가현황 --></label>
                                                        </dt>
                                                        <dd>
                                                            <c:choose>
                                                                <c:when test="${vo.mrkOyn eq 'Y' and jVo.evalYn eq 'Y'}"> ${jVo.scr}
                                                                    <spring:message code="asmnt.label.point"/></c:when>
                                                                <c:when test="${jVo.sbmsnStscdnm eq '제출'}"><spring:message
                                                                        code='asmnt.label.submit.y'/></c:when>
                                                                <c:when test="${jVo.sbmsnStscdnm eq '미제출'}"><spring:message
                                                                        code='asmnt.label.submit.n'/></c:when>
                                                                <c:when test="${jVo.sbmsnStscdnm eq '지각제출'}"><spring:message
                                                                        code='asmnt.label.submit.late2'/></c:when>
                                                                <c:when test="${jVo.sbmsnStscdnm eq '재제출'}"><spring:message
                                                                        code='asmnt.label.resubmit'/></c:when>
                                                                <c:when test="${jVo.sbmsnStscdnm eq '미재제출'}"><spring:message
                                                                        code='asmnt.label.submit.n'/></c:when>
                                                                <c:otherwise>${jVo.sbmsnStscdnm}</c:otherwise>
                                                            </c:choose>
                                                            <c:if test="${jVo.fdbkCnt > 0}">
                                                                <a href="javascript:fdbkListView()"
                                                                   class="ui blue button">
                                                                    <spring:message code="forum.label.feedback"/><!-- 피드백 --></a>
                                                            </c:if>
                                                        </dd>
                                                    </dl>
                                                </li>
                                                <li>
                                                    <dl>
                                                        <dt>
                                                            <label for="contLabel">
                                                                <spring:message code="asmnt.label.comment" /><!-- 코멘트 --></label>
                                                        </dt>
                                                        <dd>
                                                                ${jVo.sbmsnCts}
                                                        </dd>
                                                    </dl>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>

                                <div class="ui segment p0" id="viewUpload">
                                    <div class="ui styled fluid accordion">
                                        <div class="content menu_off active">
                                            <ul class="tbl">
                                                <li>
                                                    <dl>
                                                        <c:choose>
                                                            <c:when test="${vo.sendType eq 'T'}">
                                                                <dt><label>
                                                                    <spring:message code="asmnt.label.send.content" /><!-- 제출내용 --></label>
                                                                </dt>
                                                                <dd style="height:400px">
                                                                    <div style="height:100%">
                                                                        <textarea name="contentTextArea"
                                                                                  id="contentTextArea">${jVo.sendText}</textarea>
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
                                                                        <c:when test="${vo.prtcYn eq 'Y'}">
                                                                            <c:forEach
                                                                                    items="${fn:split(vo.sbmtFileType,',')}"
                                                                                    var="item" varStatus="status">
                                                                                <c:if test="${status.index ne 0}"><c:set
                                                                                        var="sFileType"
                                                                                        value="${sFileType},"/></c:if>
                                                                                <c:choose>
                                                                                    <c:when test="${item eq 'img'}"><c:set
                                                                                            var="sFileType"
                                                                                            value="${sFileType}jpg,gif,png"/></c:when>
                                                                                    <c:when test="${item eq 'pdf'}"><c:set
                                                                                            var="sFileType"
                                                                                            value="${sFileType}pdf"/></c:when>
                                                                                    <c:when test="${item eq 'ppt'}"><c:set
                                                                                            var="sFileType"
                                                                                            value="${sFileType}ppt,pptx"/></c:when>
                                                                                </c:choose>
                                                                            </c:forEach>
                                                                        </c:when>
                                                                        <c:when test="${vo.sendType eq 'F'}">
                                                                            <c:choose>
                                                                                <c:when test="${empty vo.sbmtFileType or vo.sbmtFileType eq ''}"><c:set
                                                                                        var="sFileType"
                                                                                        value="*"/></c:when>
                                                                                <c:otherwise>
                                                                                    <c:forEach
                                                                                            items="${fn:split(vo.sbmtFileType,',')}"
                                                                                            var="item"
                                                                                            varStatus="status">
                                                                                        <c:if test="${fn:contains(sFileType, 'txt') eq false}">
                                                                                            <c:if test="${status.index ne 0}"><c:set
                                                                                                    var="sFileType"
                                                                                                    value="${sFileType},"/></c:if>
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
                                                                    <uiex:dextuploader
                                                                            id="upload1"
                                                                            path="${uploadPath}"
                                                                            limitCount="10"
                                                                            limitSize="1024"
                                                                            oneLimitSize="1024"
                                                                            listSize="5"
                                                                            fileList="${jVo.fileList}"
                                                                            finishFunc="finishUpload()"
                                                                            allowedTypes="${sFileType}"
                                                                            bigSize="false"
                                                                            type="${vo.asmtGbncd}"
                                                                    />
                                                                    <c:if test="${jVo.sbmsnStscd ne 'NO'}">
                                                                        <div class="ui small error message">
                                                                            <i class="info circle icon"></i>
                                                                            <spring:message code="asmnt.label.submit.info1" /><!-- 기 제출한 과제 삭제 체크하지 않고 저장하면 새 제출과제는 추가 제출과제가 됩니다. -->
                                                                        </div>
                                                                        <div class="ui small error message">
                                                                            <i class="info circle icon"></i>
                                                                            <spring:message code="asmnt.label.submit.info2" /><!-- 과제 재제출시 중복 제출이 되지않게 주의하시기 바랍니다. -->
                                                                        </div>
                                                                    </c:if>
                                                                </dd>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </dl>
                                                </li>
                                                <li>
                                                    <dl>
                                                        <dt><label for="sbmsnCts">
                                                            <spring:message code="asmnt.label.comment" /><!-- 코멘트 --></label>
                                                        </dt>
                                                        <dd><input type="text" class="ui input" id="sbmsnCts"
                                                                   value="${jVo.sbmsnCts}"/></dd>
                                                    </dl>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>

                            </div><!-- //col -->
                        </div>
                        <!-- //row -->
                    </c:if>

                    <%--
                    <c:if test="${bList.size() > 0 && vo.asmtGbncd == 'PRACTICE'}">
                        <div class="row">
                            <div class="col">
                                <div class="flex mb10">
                                    <h3>우수과제</h3>
                                </div>

                                <div class="ui form">
                                    <div class="post_album">
                                        <div class="ui three stackable cards">
                                            <c:forEach items="${bList}" var="item" varStatus="status">

                                                <div class="ui card">
                                                    <p class="view-list-img img-hover-zoom">
                                                        <a href="#0" onclick="getBestView('${item.asmtSbmsnId}','${item.stdNo}')">
                                                            <span class="no_content">
                                                                <i class="info circle icon"></i>
                                                                <span class="txt mt5">No Image</span>
                                                            </span>
                                                        </a>
                                                    </p>
                                                    <div class="content flex fac">
                                                        <span class="label circle mr10"><img src="/webdoc/img/no_user.gif" alt="<spring:message code='team.common.user.img' />"></span>
                                                        <span class="label">${item.userNm}</span>
                                                        <span class="label mla">${item.userId}</span>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                     --%>

                    <c:if test="${vo.sbmtOpenYn eq 'Y' && today > vo.sbmtStartDttm && today < vo.sbmtEndDttm && vo.prtcYn eq 'Y'}">
                        <div class="row">
                            <div class="col">
                                <div class="flex mb10">
                                    <h3>
                                        <spring:message code="asmnt.label.asmnt.list.excellent.asmnt"/><!-- 과제 목록 및 우수과제 --></h3>
                                </div>
                                <c:choose>
                                    <c:when test="${vo.prtcYn eq 'Y'}">
                                        <div class="grid four CardList temp mt20 p20" id="asmntStareUserList"></div>
                                    </c:when>
                                    <c:otherwise>
                                        <table class="table type2" data-sorting="true" data-paging="false"
                                               data-empty="<spring:message code='common.nodata.msg' />">
                                            <thead>
                                            <tr>
                                                <th scope="col" data-type="number" class="w50">
                                                    <spring:message code="common.number.no" /><!-- NO. --></th>
                                                <th scope="col"><spring:message code="std.label.name" /><!-- 이름 --></th>
                                                <th scope="col">
                                                    <spring:message code="asmnt.label.submitted.work" /><spring:message code="asmnt.label.person" /><!-- 제출과제 -->
                                                    <!-- 명 --></th>
                                                <c:if test="${vo.evalUseYn eq 'Y'}">
                                                    <th scope="col">
                                                        <spring:message code="asmnt.label.average.horoscope" /><!-- 평균별점 --></th>
                                                </c:if>
                                            </tr>
                                            </thead>
                                            <tbody id="asmntStareUserList">
                                            </tbody>
                                        </table>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:if>

                </div>
            </div>

        </div><!-- //content -->
        <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
    </div><!-- //container -->
</div><!-- //pusher -->
</body>
</html>