<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    <%@ include file="/WEB-INF/jsp/asmt/common/asmt_common_inc.jsp" %>
    <%@ include file="/WEB-INF/jsp/asmt/common/asmt_chart_inc.jsp" %>

    <script src="/webdoc/player/plyr.js" crossorigin="anonymous"></script>
    <script src="/webdoc/player/player.js" crossorigin="anonymous"></script>
    <script src="/webdoc/audio-recorder/audio-recorder.js"></script>

    <link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>
    <link rel="stylesheet" href="/webdoc/player/plyr.css"/>
    <link rel="stylesheet" href="/webdoc/audio-recorder/audio-recorder.css"/>

    <script type="text/javascript">
        var audioRecord = null;
        $(document).ready(function () {

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

            listAsmntUser();

            $("#searchValue").on("keyup", function (e) {
                if (e.keyCode == 13) {
                    listAsmntUser(1);
                }
            });

            $('.toggle-icon').click(function () {
                $(this).toggleClass("ion-plus ion-minus");
            });

            //makePieChart("과제 참여현황 (%)", ["제출", "미제출"], ["${vo.submitCnt}", "${vo.noCnt}"]);
            //makeBarChart("성적 분포 현황", ["평균", "최고", "최저"], ["${vo.avgScore}","${vo.maxScore}" ,"${vo.minScore}"]);
            /*
            $("#ezGraderPop .modal-dialog").css("width", (window.innerWidth - 400 )+"px");
            $( window ).resize(function() {
                $("#ezGraderPop .modal-dialog").css("width", (window.innerWidth - 400 )+"px");
            });
            */

            $(".accordion").accordion();
            $(".audioDiv").hide();
            $("#audioChk").on("change", function () {
                if (this.checked) {
                    $(".audioDiv").show();
                } else {
                    $(".audioDiv").hide();
                }
            });
        });

        function manageAsmnt(tab) {
            var urlMap = {
                "0": "/asmtProfAsmtSelectView.do",	// 과제 상세 정보 페이지
                "1": "/asmtProfAsmtEvlView.do",	// 과제 평가 관리 페이지
                "2": "/asmtProfAsmtMutEvlRsltView.do",	// 상호평가 결과 페이지
            };

            var kvArr = [];
            kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
            kvArr.push({'key': 'asmtId', 'val': "${vo.asmtId}"});

            submitForm(urlMap[tab], "", kvArr);
        }

        // 평가 점수 체크박스
        function evalChk(obj) {
            if (obj.checked) {
                if (obj.value == "all") {
                    $("input:checkbox[name=evalChk]").prop("checked", true);
                }
            } else {
                if (obj.value == "all") {
                    $("input:checkbox[name=evalChk]").prop("checked", false);
                }
                $("input:checkbox[name=allEvalChk]").prop("checked", false);
            }
            var allLength = $("input:checkbox[name=evalChk]").length;
            var chkLength = $("input:checkbox[name=evalChk]:checked").length;
            if (allLength == chkLength) {
                $("input:checkbox[name=allEvalChk]").prop("checked", true);
            }

            addChkOn();
        }

        function addChkOn() {
            $("input:checkbox[name=evalChk]").parent().parent().parent().removeClass('on');
            $("input:checkbox[name=evalChk]:checked").parent().parent().parent().addClass('on');
        }

        // 과제 평가 참여자 리스트 조회
        function listAsmntUser() {
            // 점수편집 비활성화
            cancelScoreEditMode();

            var asmtPrctcyn = "${vo.asmtPrctcyn}";
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
                "searchKey": $("#searchKey").val(),
                "searchValue": $("#searchValue").val(),
                "searchKey2": $("#searchKey2").val(),
                "searchKey3": $("#searchKey3").val(),
                "asmtGbncd": "${vo.asmtGbncd}"
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    var returnList = data.returnList || [];
                    var html = "";
                    var iHtml = "";
                    var univGbn = "${creCrsVO.univGbn}";

                    data.returnList.forEach(function (o, i) {
                        var scr = o.scr != null && o.scr != "" ? o.scr.split(".")[1] == "0" ? o.scr.split(".")[0] : o.scr : "-";
                        var regDt = o.fileRegDttm != null ? dateFormat(o.fileRegDttm) : "";

                        if (o.sbmsnStscd == "LATE") {
                            regDt = o.lateDttm != null ? dateFormat(o.lateDttm) : "";
                        }

                        if (o.sbmsnStscd == "RE") {
                            regDt = o.reDttm != null ? dateFormat(o.reDttm) : "";
                        }

                        var sbmsnStscdnm = "-";
                        if (o.sbmsnStscdnm == "제출") {
                            sbmsnStscdnm = "<spring:message code='asmnt.label.submit.y'/>";
                        } else if (o.sbmsnStscdnm == "미제출") {
                            sbmsnStscdnm = "<spring:message code='asmnt.label.submit.n'/>";
                        } else if (o.sbmsnStscdnm == "지각제출") {
                            sbmsnStscdnm = "<spring:message code='asmnt.label.submit.late2'/>";
                        } else if (o.sbmsnStscdnm == "재제출") {
                            sbmsnStscdnm = "<spring:message code='asmnt.label.resubmit'/>";
                        } else if (o.sbmsnStscdnm == "미재제출") {
                            sbmsnStscdnm = "<spring:message code='asmnt.label.submit.n'/>";
                        } else {
                            sbmsnStscdnm = o.sbmsnStscdnm;
                        }

                        if (asmtPrctcyn == "Y") {
                            html += "<div class='item'>";
                            html += "	<div class='option-content header'>";
                            var fileNm = o.fileNm != null ? o.fileNm : "<spring:message code='common.not.submission'/>";
                            var fileExt = o.fileNm != null ? o.fileExt + "1" : "";
                            fileNm = fileNm.substring(0, fileNm.length - (fileExt.length));
                            html += "		<div class='title ellipsis mra'>" + fileNm + "</div>";
                            html += "		<ul class='extra'>";
                            if (o.exlnAsmtyn == "Y") {
                                html += "			<li class='ui icon top dropdown trophyDropdown' tabindex='0'>";
                                html += "				<i class='trophy icon fcTeal' title='<spring:message code="common.label.excellent.asmnt" />' aria-label='<spring:message code="common.label.excellent.asmnt" />' onclick=\"btnFocused(this,1,'" + o.stdNo + "')\"></i>";
                                html += "				<div class='menu transition hidden' tabindex='-1' style='left:-100px;'>";
                                html += "					<button type='button' class='item active selected' onclick='unSubmitBest(\"" + o.stdNo + "\")'><spring:message code="common.label.excellent.asmnt" /><spring:message code="common.label.cancel.selection" /></button>";
                                html += "				</div>";
                                html += "			</li>";
                            }
                            if ("${vo.evlRfltyn}" == "Y") {
                                html += "			<li>";
                                html += "				<i class='star icon fcYellow' title='<spring:message code="asmnt.label.horoscope" />' aria-label='<spring:message code="asmnt.label.horoscope" />'></i> " + (1 * o.evalScore).toFixed(1);
                                html += "			</li>";
                            }
                            html += "		</ul>";
                            html += "	</div>";
                            html += "	<div class='media'>";
                            if (o.fileNm != null) {
                                if (o.fileExt == "png" || o.fileExt == "gif" || o.fileExt == "jpg") {
                                    if (o.thumbPath != null && o.thumbPath != "") { // 썸네일이미지가 있으면 표시
                                        html += "<div class='img' onclick='btnFocused(this,5,\"" + o.stdNo + "\")'><img src='<%=CommConst.WEBDATA_CONTEXT %>" + o.thumbPath + "' alt='<spring:message code="common.label.image" />'></div>";
                                    } else {
                                        // 썸네일이미지 없으면 이미지아이콘 표시
                                        html += "<div class='img' onclick='btnFocused(this,5,\"" + o.stdNo + "\")'><img src='/webdoc/img/thumb_img.png' alt='<spring:message code="common.label.image" />'></div>";
                                        //html += "<div class='img' onclick='btnFocused(this,5,\""+o.stdNo+"\")'><img src='<%=CommConst.WEBDATA_CONTEXT %>"+o.filePath+"' alt='<spring:message code="common.label.image" />'></div>";
                                    }
                                } else if (o.fileExt == "pdf") {
                                    html += "<div class='img' onclick='btnFocused(this,5,\"" + o.stdNo + "\")'><img src='/webdoc/img/thumb_pdf2.png' alt='<spring:message code="common.label.image" />'></div>";
                                } else if (o.fileExt == "ppt" || o.fileExt == "pptx") {
                                    html += "<div class='img' onclick='btnFocused(this,5,\"" + o.stdNo + "\")'><img src='/webdoc/img/thumb_ppt.png' alt='<spring:message code="common.label.image" />'></div>";
                                } else {
                                    html += "<div class='img' onclick='btnFocused(this,5,\"" + o.stdNo + "\")'><img src='/webdoc/img/thumb_unknown.png' alt='<spring:message code="common.label.image" />'></div>";
                                }
                            } else {
                                html += "		<div class='img' onclick='btnFocused(this,5,\"" + o.stdNo + "\")'><img src='/webdoc/img/image_placeholder_300x300.png' alt='<spring:message code="common.label.image" />'></div>";
                            }
                            html += "		<div class='extra'>";
                            html += "			<div class='ui checkbox mra'>";
                            html += "				<input type='checkbox' name='evalChk' id='evalChk" + i + "' value='" + o.stdNo + "' onchange='addChkOn()'";
                            html += "               	   data-status='" + o.sbmsnStscd + "' user_id='" + o.userId + "'";
                            html += "                	  user_nm='" + o.userNm + "' mobile='" + o.mobileNo + "' email='" + o.email + "'>";
                            html += "				<label class='toggle_btn' for='evalChk" + i + "'></label>";
                            html += "			</div>";
                            html += "			<div class='roundRect bcBlue fcWhite'>";
                            html += "				<div class=\"d-inline-block\" id=\"scoreDisplayDiv" + i + "\" onClick=\"chgScoreRatio(" + i + ");\">";
                            html += "					" + scr;
                            html += "				</div>";
                            html += "				<div class=\"ui input\" id=\"scoreInputDiv" + i + "\" name=\"scoreInputDiv\" style=\"display:none;\">";
                            html += "					<input type=\"number\" min=\"0\" id=\"editScore" + i + "\" name=\"editScore\" data-stdno=\"" + o.stdNo + "\" maxlength=\"3\" value=\"" + o.scr + "\" maxlength=\"3\" onkeyup=\"this.value=this.value.replace(/[^0-9]/g,'');\" onfocus=\"this.select()\">";
                            //html += "					<input type=\"hidden\" name=\"scr\" value=\""+ o.scr +"\">";
                            html += "					<input type=\"hidden\" id=\"originScore" + i + "\" value=\"" + (o.scr || "") + "\">";
                            html += "				</div>";

                            html += "			</div>";
                            html += "		</div>";
                            html += "	</div>";
                            html += "	<div class='option-content'>";
                            html += "		<div class='user mra'>";
                            var userImg = o.phtFile != null ? o.phtFile : "/webdoc/img/icon-hycu-symbol-grey.svg";
                            html += "			<div class='img circle'><img src='" + userImg + "' alt=''></div>"; // 학습자 프로필 이미지
                            html += "			<div class='ml5'>" + o.userNm + "</div>";
                            html += "			<div class='extra'>";
                            html += "				<button type='button' title='<spring:message code="system.fail.alt"/>' aria-label='<spring:message code="system.fail.alt"/>' onclick=\"btnFocused(this,2,'" + o.userId + "')\"><i class='ico icon-info' aria-hidden='true'></i></button>";
                            html += "			</div>";
                            html += "		</div>";
                            html += "		<div class=''>" + sbmsnStscdnm + " " + regDt + "</div>";
                            html += "	</div>";
                            html += "	<div class='option-content'>";
                            html += "		<span>" + o.deptNm + "</span>";
                            html += "		<span class='bullet_slash'>" + o.userId + "</span>";
                            html += "		<div class='extra gap8'>";
                            html += `			<button type='button' class='pl5 pr5' title='<spring:message code="common.feedback"/>' aria-label='<spring:message code="common.feedback"/>' onclick="btnFocused(this,3,'\${o.stdNo}')"><i class='xi-comment-o \${o.fdbkCnt > 0 ? 'on' : ''} f120' aria-hidden='true'></i></button>`;
                            html += `			<button type='button' title='<spring:message code="asmnt.button.asmnt.submit.list"/>' aria-label='<spring:message code="asmnt.button.asmnt.submit.list"/>' onclick="btnFocused(this,4,'\${o.stdNo}')"><i class='folder outline icon f120' aria-hidden='true'></i></button>`;
                            html += "			<button type='button' title='<spring:message code="asmnt.label.memo" />' aria-label='<spring:message code="asmnt.label.memo" />' onclick='btnFocused(this,6,\"" + o.stdNo + "\")'><i class='ico icon-paper-pencil' aria-hidden='true'></i></button>";
                            html += "			<button type='button' title='댓글' aria-label='댓글' onclick='btnFocused(this,7,\"" + o.stdNo + "\")'><i class='xi-message-o f150' aria-hidden='true'></i></button>";
                            html += "		</div>";
                            html += "	</div>";
                            html += "</div>";
                        } else {
                            html += "<tr>";
                            html += "	<td>";
                            html += "		<div class='ui checkbox'>";
                            html += "			<input type='checkbox' name='evalChk' id='evalChk" + i + "' value='" + o.stdNo + "' onchange='addChkOn()'";
                            html += "                  data-status='" + o.sbmsnStscd + "' user_id='" + o.userId + "'";
                            html += "                  user_nm='" + o.userNm + "' mobile='" + o.mobileNo + "' email='" + o.email + "'>";
                            html += "			<label class='toggle_btn' for='evalChk" + i + "'></label>";
                            html += "		</div>";
                            html += "	<td name='lineNo'>" + o.lineNo + "</td>";

                            if ("${vo.teamAsmtStngyn}" == "Y") {
                                html += "	<td data-sort-value='" + o.teamnm + "' class='ellipsis'>" + o.teamnm + "</td>";
                            }

                            html += "	<td data-sort-value='" + o.deptNm + "' class='ellipsis'>" + o.deptNm + "</td>";
                            html += "	<td data-sort-value='" + o.userId + "'>" + o.userId;
                            if (o.exlnAsmtyn == 'Y') {
                                html += "<ul class='ui icon top dropdown trophyDropdown' tabindex='0'>";
                                html += "	<i class='trophy icon fcTeal' aria-label='<spring:message code="common.label.excellent.asmnt" />' onclick=\"btnFocused(this,1,'" + o.stdNo + "')\"></i>";
                                html += "	<div class='menu transition hidden' tabindex='-1'>";
                                html += "		<button type='button' class='item active selected' onclick='unSubmitBest(\"" + o.stdNo + "\")'><spring:message code="common.label.excellent.asmnt" /><spring:message code="common.label.cancel.selection" /></button>";
                                html += "	</div>";
                                html += "</ul>";
                            }
                            html += "	</td>";
                            html += "	<td data-sort-value='" + o.hy + "'>" + o.hy + "</td>";
                            if (univGbn == "3" || univGbn == "4") {
                                html += "<td class='tc word_break_none' data-sort-value='" + (o.grscDegrCorsGbnNm || '-') + "'>" + (o.grscDegrCorsGbnNm || '-') + "</td>";
                            }
                            html += "	<td data-sort-value='" + o.userNm + "' class='word_break_none'>" + o.userNm;
                            html += userInfoIcon("<%=SessionInfo.isKnou(request)%>", "btnFocused(this,2,'" + o.userId + "')");
                            html += "	</td>";
                            html += "	<td data-sort-value='" + o.entrYy + "' class='tc'>" + o.entrYy + "</td>";
                            html += "	<td data-sort-value='" + o.entrHy + "' class='tc'>" + o.entrHy + "</td>";
                            html += "	<td data-sort-value='" + o.entrGbnNm + "' class='tc word_break_none'>" + o.entrGbnNm + "</td>";
                            //html += "	<td data-sort-value='" + (o.konanMaxCopyRate || "-1") + "'>"+ (o.konanMaxCopyRate ? '<a class="fcBlue" href="${konanCopyScoreUrl}?domain=e_asmnt&docId=' + o.asmtSbmsnId + '" target="_blank">' + o.konanMaxCopyRate + '%' + '</a>' : '-') +"</td>";
                            var sortScore = o.scr != null && o.scr != "" ? o.scr : "0";
                            html += "	<td data-sort-value='" + sortScore + "' class='tr word_break_none' style='width: 165px;'>";
                            html += "		<div class=\"d-inline-block\" id=\"scoreDisplayDiv" + i + "\" onClick=\"chgScoreRatio(" + i + ");\">";
                            html += "		" + scr + " <spring:message code='asmnt.label.point' />";
                            html += "		</div>";
                            html += "		<div class=\"ui right labeled small input\" id=\"scoreInputDiv" + i + "\" name=\"scoreInputDiv\" style=\"display:none;\">";
                            html += "			<input type=\"number\" min=\"0\" id=\"editScore" + i + "\" name=\"editScore\" data-stdno=\"" + o.stdNo + "\" class=\"w40 tr\" maxlength=\"3\" value=\"" + o.scr + "\" maxlength=\"3\" onkeyup=\"this.value=this.value.replace(/[^0-9]/g,'');\" onfocus=\"this.select()\" style='min-height: unset; height: 34px;' />";
                            //html += "			<input type=\"hidden\" name=\"scr\" value=\""+ o.scr +"\">";
                            html += "			<input type=\"hidden\" id=\"originScore" + i + "\" value=\"" + (o.scr || "") + "\">";
                            html += "			<div class=\"ui basic label\"><spring:message code='asmnt.label.point' /></div>";
                            html += "		</div>";

                            html += `		<i class="xi-comment-o \${o.fdbkCnt > 0 ? 'on' : ''} f120" onclick="btnFocused(this,3,'\${o.stdNo}')" style="cursor:pointer" title="<spring:message code='forum.label.feedback'/>"></i>`;
                            html += "		<a class='ui button basic mini " + (o.scrMemo ? "on " : "") + " ' style='padding:5px !important;' title='<spring:message code='asmnt.label.memo'/>' href=\"javascript:btnFocused(this,6,'" + o.stdNo + "')\"><spring:message code='asmnt.label.memo'/><a/>"; // 메모
                            html += "	</td>";

                            if (o.sbmsnStscd == "NO") {
                                html += "<td data-sort-value='" + sbmsnStscdnm + "' class='tc'><span class='fcRed'>" + sbmsnStscdnm + "</span></td>";
                            } else {
                                html += "<td data-sort-value='" + sbmsnStscdnm + "' class='tc'>" + sbmsnStscdnm + "</td>";
                            }
                            html += "	<td data-sort-value='" + o.evalYn + "' class='tc'>" + o.evalYn + "</td>";
                            html += "	<td data-sort-value='" + regDt + "' class='word_break_none'>" + regDt + "</td>";
                            html += "	<td class='word_break_none'>";
                            html += "		<a href=\"javascript:;\" onclick=\"btnFocused(this,5,'" + o.stdNo + "')\" class='ui basic mini button'>EZ</a>";
                            html += "		<i class=\"folder outline icon f120\" onclick=\"btnFocused(this,4,'" + o.stdNo + "')\" style=\"cursor:pointer\" title=\"<spring:message code='asmnt.button.asmnt.submit.list'/>\"></i>";
                            if (o.sbmsnStscd == "NO") {
                                html += "		<a href=\"javascript:;\" onclick=\"btnFocused(this,8,'" + o.asmtSbmsnId + "', '" + o.userId + "')\" class='ui basic mini button'><spring:message code='asmnt.button.change.submit' /></a>"; // 제출완료처리
                            }
                            if (o.sbmsnStscd == "SUBMIT" && o.fileCnt === 0) {
                                html += "	<a href=\"javascript:;\" onclick=\"btnFocused(this,9,'" + o.asmtSbmsnId + "')\" class='ui basic mini button'>";
                                html += (o.teamnm ? o.teamnm + " " : "") + "<spring:message code='asmnt.button.change.no.submit' />"; // 미제출처리
                                html += "	</a>";
                            }

                            html += "	</td>";
                            html += "</tr>";

                            if ("${vo.indvAsmtyn}" == "Y") {
                                iHtml += "<button class='ui grey small button'>" + o.userNm + "(" + o.userId + ")" + "</button>";
                            }
                        }
                    });
                    $("#asmntStareUserList").empty().append(html);

                    $("#sindvAsmtList").empty().append(iHtml);

                    if ("${vo.asmtPrctcyn}" != "Y") {
                        $(".table").footable({
                            on: {
                                "after.ft.sorting": function (e, ft, sorter) {
                                    $(".table tbody tr").each(function (z, k) {
                                        $(k).find("td[name=lineNo]").html((z + 1));
                                    });
                                }
                            }
                        });
                    }
                    $(".trophyDropdown").dropdown();

                    $("#totalCntText").text(returnList.length);

                    // 일괄 점수편집 버튼 이벤트
                    $("#changeScoreEditModeBtn").on("click", function () {
                        changeScoreEditMode();
                    });
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

        // 점수 가감 아이콘 표시 확인
        function plusMinusIconControl(scoreType) {
            if (scoreType == 'batch') {
                $(".link.icon.toggle-icon").hide();
            } else if (scoreType == 'addition') {
                $(".link.icon.toggle-icon").show();
            }
        }

        // 점수 저장
        function submitScore() {
            // 성적처리방식
            if ($("input[name='scoreType']:checked").val() == undefined) {
                /* 성적 처리 유형을 선택하세요. */
                alert("<spring:message code='forum.alert.select.score.save.type' />");
                return false;
            }

            // 점수 입력
            if ($("#scoreValue").val() == "" || $("#scoreValue").val() == undefined) {
                /* 점수를 숫자로 입력하세요. */
                alert("<spring:message code='common.pop.insert.score.only.number' />");
                return false;
            }

            if ($("#scoreValue").val() > 100) {
                /* 점수는 100점 까지 입력 가능 합니다. */
                alert("<spring:message code='common.pop.max.score.hundred' />");
                return false;
            }

            // 학습자 선택
            if ($("input[name=evalChk]:checked").length == 0) {
                /* 학습자를 선택해주시기 바립니다. */
                alert("<spring:message code='forum.alert.user.select'/>");
                return false;
            }

            var stdNo = "";
            $("input[name=evalChk]:checked").each(function (i) {
                if (i > 0) stdNo += ",";
                stdNo += $(this).val();
            });

            var scr = $("#scoreValue").val();
            if ($("input[name='scoreType']:checked").val() == "addition") {
                if (!$(".toggle-icon").attr("class").includes("ion-plus")) {
                    scr = scr * (-1);
                }
            }

            var url = "/asmt/profAsmtMrkModify.do";
            var data = {
                "asmtId": "${vo.asmtId}",
                "stdNo": stdNo,
                "scr": scr,
                "scoreType": $("input[name='scoreType']:checked").val()
            };

            if (confirm("<spring:message code='common.save.msg'/>")) {
                ajaxCall(url, data, function (data) {
                    if (data.result > 0) {
                        /* 점수 등록이 완료되었습니다. */
                        alert("<spring:message code='exam.alert.score.finish' />");

                        listAsmntUser();
                        $("#scoreValue").val("");
                    } else {
                        alert(data.message);
                    }
                }, function (xhr, status, error) {
                    /* 에러가 발생했습니다! */
                    alert("<spring:message code='fail.common.msg' />");
                }, true);
            }
        }

        // 피드백 Validation
        function valFdbk() {
            var fileUploader = dx5.get("fileUploader");

            // 피드백 입력
            if ($("#fdbkValue").val() == '') {
                /* 피드백을 입력하시기 바랍니다. */
                alert("<spring:message code='forum.alert.feedback.input'/>");
                return false;
            }

            // 학습자 선택
            if ($("input[name=evalChk]:checked").length == 0) {
                /* 학습자를 선택해주시기 바립니다. */
                alert("<spring:message code='forum.alert.user.select'/>");
                return false;
            }

            if (confirm("<spring:message code='common.save.msg'/>")) {
                if (fileUploader.getFileCount() > 0) {
                    $('#fdbkFileUp').css("visibility", "visible");
                    fileUploader.startUpload();
                } else {
                    submitFdbk();
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
                    $('#fdbkFileUp').css("visibility", "hidden");
                    submitFdbk();
                } else {
                    alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
                }
            }, function (xhr, status, error) {
                alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
            });
        }

        // 피드백 저장
        function submitFdbk() {
            var fileUploader = dx5.get("fileUploader");
            var stdNo = "";
            $("input[name=evalChk]:checked").each(function (i) {
                if (i > 0) stdNo += ",";
                stdNo += $(this).val();
            });

            var url = "/asmt/profAsmtFdbkRegist.do";
            var data = {
                "crsCreCd": "${vo.crsCreCd}",
                "asmtId": "${vo.asmtId}",
                "stdNo": stdNo,
                "fdbkTrgtUnitTycd": "${vo.teamAsmtStngyn}" == 'Y' ? "team" : "std",
                "fdbkCts": $("#fdbkValue").val(),
                "uploadFiles": fileUploader.getUploadFiles(),
                "copyFiles": fileUploader.getCopyFiles(),
                "uploadPath": fileUploader.getUploadPath(),
                "audioData": audioRecord.audioData,
                "audioFile": audioRecord.audioFile
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    $("#fdbkFileUp").css("visibility", "hidden");
                    fileUploader.removeAll();
                    $("#fdbkFileView").empty();
                    $("#fdbkValue").val("");

                    /* 피드백 등록이 완료되었습니다. */
                    alert("<spring:message code='forum.alert.reg_complete.feedback' />");
                    listAsmntUser();

                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                /* 에러가 발생했습니다! */
                alert("<spring:message code='fail.common.msg' />");
            }, true);
        }

        // 과제 수정
        function editAsmnt() {
            var kvArr = [];
            kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
            kvArr.push({'key': 'asmtId', 'val': "${vo.asmtId}"});

            submitForm("/asmtProfAsmtRegistView.do", "", kvArr);
        }

        // 과제 삭제
        function deleteAsmnt() {
            var confirm = "";
            if ("${vo.submitCnt}" > 0) {
                // 제출자가 있습니다 삭제 시 모든정보가 삭제됩니다.
                // 정말 삭제 하시겠습니까?
                confirm = window.confirm("<spring:message code='asmnt.message.presenter.del1'/>\r\n<spring:message code='asmnt.message.presenter.del2'/>");
            } else {
                confirm = window.confirm("<spring:message code='asmnt.message.warning.del2'/>");
            }
            if (confirm) {
                var url = "/asmtProfAsmtDelete.do";
                var data = {
                    "asmtId": "${vo.asmtId}"
                };

                ajaxCall(url, data, function (data) {
                    if (data.result > 0) {
                        /* 정상적으로 삭제되었습니다. */
                        alert("<spring:message code='success.common.delete'/>");
                        viewAsmntList();
                    } else {
                        alert(data.message);
                    }
                }, function (xhr, status, error) {
                    /* 삭제 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
                    alert("<spring:message code='seminar.error.delete' />");
                }, true);
            }
        }

        // 목록
        function viewAsmntList() {
            var kvArr = [];
            kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});

            submitForm("/asmt/profAsmtListView.do", "", kvArr);
        }

        // 피드백 가져오기
        function fdbkList(stdNo) {
            var modalId = "Ap09";
            initModal(modalId);

            var kvArr = [];
            kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
            kvArr.push({'key': 'asmtId', 'val': "${vo.asmtId}"});
            kvArr.push({'key': 'stdNo', 'val': stdNo});

            submitForm("/asmt/profAsmtFdbkPopView.do", modalId + "ModalIfm", kvArr);
        }

        // 피드백 파일첨부 팝업 열기
        function fdbkFilePopOpen() {
            var fileUploader = dx5.get("fileUploader");
            var w = $("#fdbkFileBox").outerWidth();
            var h = $("#fdbkFileBox").outerHeight();
            var bw = $("#fdbkFileUp").find("button.fCloseBtn").outerWidth();

            $("#fdbkFileUp").css({"visibility": "visible", "width": w + "px"});
            $("#fdbkFileUp .fileUpBox").css({"width": (w - bw - 2) + "px"});
            $("#fileUploader-container").css("height", h + "px");
            $("#fdbkFileUp").find("button").css("height", h + "px");
            fileUploader.setUIStyle({itemHeight: h});
        }

        // 피드백 파일첨부 팝업 닫기
        function fdbkFilePopClose() {
            var fileUploader = dx5.get("fileUploader");

            if (fileUploader.getTotalItemCount() > 0) {
                var html = "";
                var items = fileUploader.getItems();

                html += "<i class='paperclip icon f080'></i>";
                html += items[0].name;
                html += "<button type='button' class='del ml10' style='border:1px solid #aaa;width:16px;height:16px' title='Delete' onclick=\"fdbkFileReset();\"></button>";

                $("#fdbkFileView").html(html);
            } else {
                $("#fdbkFileView").empty();
            }

            $('#fdbkFileUp').css("visibility", "hidden");
        }

        // 피드백 음성녹음 팝업 열기
        function fdbkAudioPopOpen() {
            $('#fdbkAudioPop').modal('show');
        }

        // 피드백 음성녹음 팝업 닫기
        function fdbkAudioPopClose() {
            fdbkFileToggle();
            $('#fdbkAudioPop').modal('hide');
        }

        function fdbkFileReset() {
            var fileUploader = dx5.get("fileUploader");
            fileUploader.removeAll();
            $("#fdbkFileView").empty();
        }

        function fdbkAudioReset() {
            audioRecord.reset();
            $("#fdbkAudioView").empty();
        }

        function fdbkFileToggle() {
            var fileUploader = dx5.get("fileUploader");

            if (fileUploader.getTotalItemCount() > 0) {
                var html = "";
                var items = fileUploader.getItems();

                html += "<i class='paperclip icon f080'></i>";
                html += items[0].name;
                html += "<button type='button' class='del ml10' style='border:1px solid #aaa;width:16px;height:16px' title='Delete' onclick='fdbkFileReset();'></button>";

                $("#fdbkFileView").html(html);
            }

            if (audioRecord.audioData != '') {
                var html = "";

                html += "<i class='paperclip icon f080'></i>";
                html += "<spring:message code='forum.label.audio.record.file'/> REC";
                //html += "<button type='button' class='del' title='파일삭제' onclick='fdbkAudioReset();'></button>";

                $("#fdbkAudioView").html(html);
            }
        }

        // 이전과제 제출목록
        function prevAsmntList() {

            var chkCnt = $("input:checkbox[name=evalChk]:checked").length;

            if (chkCnt < 1) {
                /* 학습자를 선택해주시기 바립니다. */
                alert("<spring:message code='forum.alert.user.select'/>");
                return false;
            }

            if (chkCnt > 1) {
                /* 학습자 한명만 선택해주시기 바립니다. */
                alert("<spring:message code='exam.alert.one.select.std'/>");
                return false;
            }

            var modalId = "Ap03";
            initModal(modalId);

            var kvArr = [];
            kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
            kvArr.push({'key': 'asmtId', 'val': "${vo.asmtId}"});
            kvArr.push({'key': 'stdNo', 'val': $("input:checkbox[name=evalChk]:checked").eq(0).val()});

            submitForm("/asmt/profPrevAsmtListPopView.do", modalId + "ModalIfm", kvArr);
        }

        // ezGrader 가져오기
        function ezGrader(stdNo) {
            $('#ezForm input[name="stdNo"]').val(stdNo);
            $("#ezForm").attr("target", "ezIfm");
            $("#ezForm").submit();
            $('#ezGraderPop').modal('show');
        }

        // 엑셀 성적 등록
        function setExcel() {
            var modalId = "Ap08";
            initModal(modalId);

            var kvArr = [];
            kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
            kvArr.push({'key': 'asmtId', 'val': "${vo.asmtId}"});
            kvArr.push({'key': 'asmtGbncd', 'val': "${vo.asmtGbncd}"});

            submitForm("/asmt/profAsmtMrkExcelUploadPopView.do", modalId + "ModalIfm", kvArr);
        }

        // 엑셀 다운로드
        function getExcel() {
            var univGbn = "${creCrsVO.univGbn}";
            var excelGrid = {colModel: []};

            excelGrid.colModel.push({
                label: '<spring:message code="main.common.number.no" />',
                name: 'lineNo',
                align: 'center',
                width: '1000'
            }); // NO
            excelGrid.colModel.push({
                label: '<spring:message code="asmnt.label.dept.nm"/>',
                name: 'deptNm',
                align: 'left',
                width: '5000'
            }); // 학과
            excelGrid.colModel.push({
                label: '<spring:message code="asmnt.label.user_id"/>',
                name: 'userId',
                align: 'left',
                width: '5000'
            }); // 학번
            excelGrid.colModel.push({
                label: '<spring:message code="std.label.hy"/>',
                name: 'hy',
                align: 'left',
                width: '2500'
            }); // 학년
            if (univGbn == "3" || univGbn == "4") {
                excelGrid.colModel.push({
                    label: '<spring:message code="common.label.grsc.degr.cors.gbn" />',
                    name: 'grscDegrCorsGbnNm',
                    align: 'left',
                    width: '4000'
                }); // 학위과정
            }
            excelGrid.colModel.push({
                label: '<spring:message code="asmnt.label.user_nm"/>',
                name: 'userNm',
                align: 'left',
                width: '5000'
            }); // 이름
            excelGrid.colModel.push({
                label: '<spring:message code="asmnt.label.eval.score"/>',
                name: 'scr',
                align: 'right',
                width: '5000'
            }); // 평가점수
            excelGrid.colModel.push({
                label: '<spring:message code="asmnt.label.status"/>',
                name: 'sbmsnStscdnm',
                align: 'left',
                width: '5000'
            }); // 상태
            excelGrid.colModel.push({
                label: '<spring:message code="asmnt.label.submit.dt"/>',
                name: 'submitDttm',
                align: 'center',
                width: '5000'
            }); // 제출일시
            excelGrid.colModel.push({
                label: '<spring:message code="asmnt.label.late.dt"/>',
                name: 'lateDttm',
                align: 'center',
                width: '5000',
                formatter: 'date',
                formatOptions: {srcformat: 'yyyyMMddHHmmss', newformat: 'yyyy.MM.dd HH:mm:ss'}
            }); // 지각제출일시
            excelGrid.colModel.push({
                label: '<spring:message code="asmnt.label.re.dt"/>',
                name: 'reDttm',
                align: 'center',
                width: '5000',
                formatter: 'date',
                formatOptions: {srcformat: 'yyyyMMddHHmmss', newformat: 'yyyy.MM.dd HH:mm:ss'}
            }); // 재제출일시

            var kvArr = [];
            kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
            kvArr.push({'key': 'asmtId', 'val': "${vo.asmtId}"});
            kvArr.push({'key': 'excelGrid', 'val': JSON.stringify(excelGrid)});

            submitForm("/asmt/profAsmtMrkEvlListExcelDwld.do", "", kvArr);
        }

        // 메모 팝업
        function setMemo(stdNo) {
            var modalId = "Ap07";
            initModal(modalId);

            var kvArr = [];
            kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
            kvArr.push({'key': 'asmtId', 'val': "${vo.asmtId}"});
            kvArr.push({'key': 'stdNo', 'val': stdNo});

            submitForm("/asmt/profAsmtMemoPopView.do", modalId + "ModalIfm", kvArr);
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

        // 이전과제 팝업
        function getPrevAsmntFiles(stdNo) {
            var modalId = "Ap03";
            initModal(modalId);

            var kvArr = [];
            kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
            kvArr.push({'key': 'asmtId', 'val': "${vo.asmtId}"});
            kvArr.push({'key': 'stdNo', 'val': stdNo});

            submitForm("/asmt/profPrevAsmtListPopView.do", modalId + "ModalIfm", kvArr);
        }

        // 재제출 관리 팝업
        function resendPop() {
            var modalId = "Ap12";
            initModal(modalId);

            var kvArr = [];
            kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
            kvArr.push({'key': 'asmtId', 'val': "${vo.asmtId}"});

            submitForm("/asmt/profAsmtSbmsnMngPopView.do", modalId + "ModalIfm", kvArr);
            $("#Ap12Modal > div.modal-dialog").addClass("modal-extra-lg");
        }

        // 선택한 파일 다운로드
        function selFileDownload() {
            var chkCnt = $("input:checkbox[name=evalChk]:checked").length;

            if (chkCnt < 1) {
                /* 학습자를 선택해주시기 바립니다. */
                alert("<spring:message code='forum.alert.user.select'/>");
                return false;
            }

            var indvAsmtList = "";
            for (var i = 0; i < $("input:checkbox[name=evalChk]:checked").length; i++) {
                if (i > 0) indvAsmtList += ',';
                indvAsmtList += $("input:checkbox[name=evalChk]:checked").eq(i).val();
            }

            var form = $("<form></form>");
            form.attr("method", "POST");
            form.attr("name", "zipDownForm");
            form.attr("action", "/asmt/profAsmtFileDwld.do");
            form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '<c:out value="${vo.crsCreCd}" />'}));
            form.append($('<input/>', {type: 'hidden', name: 'asmtId', value: '<c:out value="${vo.asmtId}" />'}));
            form.append($('<input/>', {type: 'hidden', name: 'indvAsmtList', value: indvAsmtList}));
            form.appendTo("body");
            form.submit();

            $("form[name=zipDownForm]").remove();
        }

        // 우수과제 선정
        function submitBest(type) {
            var chkCnt = $("input:checkbox[name=evalChk]:checked").length;

            if (chkCnt < 1) {
                /* 학습자를 선택해주시기 바립니다. */
                alert("<spring:message code='forum.alert.user.select'/>");
                return false;
            }

            var indvAsmtList = "";
            for (var i = 0; i < $("input:checkbox[name=evalChk]:checked").length; i++) {
                if ($("input:checkbox[name=evalChk]:checked").eq(i).data('status') == 'NO') {
                    /* 과제 미제출 학습자를 선택하셨습니다. */
                    alert("<spring:message code='asmnt.message.not.submission.select.std'/>");
                    return false;
                }

                if (i > 0) indvAsmtList += ',';
                indvAsmtList += $("input:checkbox[name=evalChk]:checked").eq(i).val();
            }

            var url = "/asmt/profAsmtExlnChcModify.do";
            var data = {
                "asmtId": "${vo.asmtId}",
                "indvAsmtList": indvAsmtList,
                "exlnAsmtyn": "Y"
            };

            /* 우수과제로 선정하시겠습니까? */
            if (confirm("<spring:message code='common.alert.excellent.asmnt.select'/>")) {
                ajaxCall(url, data, function (data) {
                    if (data.result > 0) {
                        /* 우수과제로 선정 되었습니다. */
                        alert("<spring:message code='common.alert.excellent.asmnt.complete'/>");
                        listAsmntUser(1);
                    } else {
                        alert(data.message);
                    }
                }, function (xhr, status, error) {
                    /* 에러가 발생했습니다! */
                    alert("<spring:message code='fail.common.msg' />");
                }, true);
            }
        }

        // 우수과제 선정 취소
        function unSubmitBest(stdNo) {
            var url = "/asmt/profAsmtExlnChcModify.do";
            var data = {
                "asmtId": "${vo.asmtId}",
                "indvAsmtList": stdNo,
                "exlnAsmtyn": "N"
            };

            /* 우수과제 선정을 취소하시겠습니까? */
            if (confirm("<spring:message code='common.alert.no.excellent.asmnt.select'/>")) {
                ajaxCall(url, data, function (data) {
                    if (data.result > 0) {
                        /* 우수과제 선정이 취소 되었습니다. */
                        alert("<spring:message code='common.alert.no.excellent.asmnt.complete'/>");
                        listAsmntUser();
                    } else {
                        alert(data.message);
                    }
                }, function (xhr, status, error) {
                    /* 에러가 발생했습니다! */
                    alert("<spring:message code='fail.common.msg' />");
                }, true);
            }
        }

        // 메세지 보내기
        function sendMsg() {
            var rcvUserInfoStr = "";
            var sbmsnCnt = 0;

            $.each($('#asmntStareUserList').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function () {
                sbmsnCnt++;
                if (sbmsnCnt > 1) rcvUserInfoStr += "|";
                rcvUserInfoStr += $(this).attr("user_id");
                rcvUserInfoStr += ";" + $(this).attr("user_nm");
                rcvUserInfoStr += ";" + $(this).attr("mobile");
                rcvUserInfoStr += ";" + $(this).attr("email");
            });

            if (sbmsnCnt == 0) {
                /* 메시지 발송 대상자를 선택하세요. */
                alert("<spring:message code='common.alert.sysmsg.select_user'/>");
                return;
            }

            window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");

            var form = document.alarmForm;
            form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
            form.target = "msgWindow";
            form[name = 'alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
            form[name = 'rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
            form.submit();
        }

        // 일괄 점수편집 저장
        function submitScoreBatch() {
            var changeScoreList = [];
            var isValid = true;

            // 점수 입력 체크
            $.each($("input[name='editScore']"), function () {
                var index = this.id.replace("editScore", "");

                if (this.value == "") {
                    alert("<spring:message code='forum.alert.input.score' />"); // 점수를 입력하세요.
                    isValid = false;
                    $(this).focus();
                    return false;
                }

                if (Number(this.value) > 100) {
                    alert("<spring:message code='common.pop.max.score.hundred' />"); // 점수는 100점 까지 입력 가능 합니다.
                    isValid = false;
                    $(this).focus();
                    return false;
                }

                var originVal = $("#originScore" + +index).val();

                if (originVal != "") {
                    originVal = "" + Number(originVal);
                }

                if (("" + Number(this.value)) !== originVal) {
                    changeScoreList.push({
                        asmtId: "${vo.asmtId}"
                        , stdNo: $(this).data("stdno")
                        , scr: this.value
                    });
                }
            });

            if (!isValid) return;

            var url = "/asmt/profAsmtMrkBulkModify.do";
            var data = JSON.stringify(changeScoreList);

            $.ajax({
                url: url,
                type: "POST",
                contentType: "application/json",
                data: data,
                dataType: "json",
                beforeSend: function () {
                    showLoading();
                },
                success: function (data) {
                    if (data.result > 0) {
                        // 점수 등록이 완료되었습니다.
                        alert("<spring:message code='exam.alert.score.finish' />");

                        listAsmntUser();
                    } else {
                        alert(data.message);
                    }
                    hideLoading();
                },
                error: function (xhr, status, error) {
                    alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
                },
                complete: function () {
                    hideLoading();
                },
            });
        }

        // 일괄 점수편집 모드전환
        function changeScoreEditMode() {
            var evlScrTycd = "${vo.evlScrTycd}";
            if (evlScrTycd == "RUBRIC_SCR") {
                alert("<spring:message code='asmnt.alert.ctgr.rubric.score' />"); // 루브릭 평가 과제입니다. EZ-Grader에서 루브릭 평가하시기 바랍니다.
                return false;
            }

            // 점수편집 비활성화
            cancelScoreEditMode();

            // 점수 입력 활성화
            $.each($("input[name='editScore']"), function () {
                var index = this.id.replace("editScore", "");

                // 입력창 open
                $("#scoreDisplayDiv" + index).hide();
                $("#scoreDisplayDiv" + index).removeClass("d-inline-block");
                $("#scoreInputDiv" + index).show();

                // 소수점 제거
                if (this.value == "") {
                    this.value = 0;
                } else {
                    this.value = Number(this.value);
                }

                // 단건 입력모드 비활성화
                $("#editScore" + index).off("blur");

                // 탭 이벤트 활성화
                $("#editScore" + index).off("keydown.tab").on("keydown.tab", function (e) {
                    if (e.keyCode == 9 && e.shiftKey) {
                        e.preventDefault();

                        var index = Number(this.id.replace("editScore", ""));
                        var $prev = $("#editScore" + (index - 1));
                        var maxLen = $("input[name='editScore']").length;

                        if ($prev.length != 1 && index == 0) {
                            $prev = $("#editScore" + (maxLen - 1));
                        }

                        if ($prev.length == 1) {
                            $prev.focus().select();
                        }
                    } else if (e.keyCode == 9) {
                        e.preventDefault();

                        var index = Number(this.id.replace("editScore", ""));
                        var $next = $("#editScore" + (index + 1));

                        if ($next.length != 1 && index != 0) {
                            $next = $("#editScore0");
                        }

                        if ($next.length == 1) {
                            $next.focus().select();
                        }
                    }
                });
            });

            // 일괄 점수저장 버튼으로 변경
            $("#changeScoreEditModeBtn").removeClass("basic").removeClass("orange");
            $("#changeScoreEditModeBtn").addClass("orange");
            $("#changeScoreEditModeBtn").text("<spring:message code='common.label.batch.score.save' />"); // 일괄 점수저장
            $("#changeScoreEditModeBtn").off("click").on("click", function () {
                submitScoreBatch();
            });

            // 취소 버튼 보임
            $("#cancelScoreEditModeBtn").show();
        }

        // 일괄 점수편집 모드취소
        function cancelScoreEditMode() {
            // 점수 입력 비활성화
            $.each($("input[name='editScore']"), function () {
                var index = this.id.replace("editScore", "");

                // 입력창 hide
                $("#scoreDisplayDiv" + index).show();
                $("#scoreDisplayDiv" + index).addClass("d-inline-block");
                $("#scoreInputDiv" + index).hide();

                // 입력값 원복
                $(this).val($("#originScore" + +index).val());

                // 단건 입력모드 활성화
                $("#editScore" + index).on("blur", function () {
                    setScoreRatio(index, $("#originScore" + index).val());
                });

                // 탭 이벤트 비활성화
                $("#editScore" + index).off("keydown.tab");
            });

            // 일괄 점수편집 버튼으로 변경
            $("#changeScoreEditModeBtn").removeClass("basic").removeClass("orange");
            $("#changeScoreEditModeBtn").addClass("basic");
            $("#changeScoreEditModeBtn").text("<spring:message code='common.label.batch.score.edit' />"); // 일괄 점수편집
            $("#changeScoreEditModeBtn").off("click").on("click", function () {
                changeScoreEditMode();
            });

            // 취소버튼 숨짐
            $("#cancelScoreEditModeBtn").hide();
        }

        function chgScoreRatio(i) {
            var evlScrTycd = "${vo.evlScrTycd}";
            if (evlScrTycd == "RUBRIC_SCR") {
                alert("<spring:message code='asmnt.alert.ctgr.rubric.score' />"); // 루브릭 평가 과제입니다. EZ-Grader에서 루브릭 평가하시기 바랍니다.
                return false;
            }

            // 전체 비활성화
            cancelScoreEditMode();

            $("#scoreDisplayDiv" + i).hide();
            $("#scoreDisplayDiv" + i).removeClass("d-inline-block");
            $("#scoreInputDiv" + i).show();

            if ($("#editScore" + i).val() != "") {
                $("#editScore" + i).val(Number($("#editScore" + i).val()));
            }

            $("#editScore" + i).focus();

            $("#editScore" + i).off("blur").on("blur", function () {
                setScoreRatio(i, $("#originScore" + i).val());
            });
        }

        // 마우스 아웃시 실행
        function setScoreRatio(i, cScore) {
            var scr = $("#editScore" + i).val();
            var stdNo = $("#editScore" + i).data("stdno");

            if (scr === "" || scr === undefined) {
                alert("<spring:message code='forum.alert.input.score' />");// 점수를 입력하세요.
                setTimeout(function () {
                    $("#edtScore" + i).focus();
                }, 0);
                return false;
            }

            if (scr > 100) {
                alert("<spring:message code='forum.alert.score.max_100' />");// 점수는 100점 까지 입력 가능 합니다.
                $("#edtScore" + i).val(cScore);
                return false;
            }

            $("#scoreDisplayDiv" + i).show();
            $("#scoreDisplayDiv" + i).addClass("d-inline-block");
            $("#scoreInputDiv" + i).hide();

            if (cScore !== scr) {
                var url = "/asmt/profAsmtMrkModify.do";

                var data = {
                    "asmtId": "${vo.asmtId}",
                    "scoreType": "batch",
                    "stdNo": stdNo,
                    "scr": scr,
                };

                ajaxCall(url, data, function (data) {
                    if (data.result > 0) {
                        alert("<spring:message code='forum.alert.mut.setScore' />"); // 평가점수가 정상적으로 수정되었습니다.
                        listAsmntUser();
                    } else {
                        alert(data.message);
                    }
                }, function (xhr, status, error) {
                    alert("<spring:message code='forum.common.error' />"); // 오류가 발생했습니다!
                }, true);
            }
        }

        // 제출 완료 처리
        function setSubmit(asmtSbmsnId, userId) {
            var url = "/asmt/profAsmtSbmsnCmptnProc.do";
            var data = {
                "crsCreCd": "${vo.crsCreCd}",
                "asmtId": "${vo.asmtId}",
                "asmtSbmsnId": asmtSbmsnId,
                "teamAsmtStngyn": "${vo.teamAsmtStngyn}",
                "sbmsnStscd": "SUBMIT",
                "userId": userId
            };

            $.ajaxSettings.traditional = true;
            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    /* 정상 제출되었습니다. */
                    alert("<spring:message code='lesson.alert.message.submit.lesson.cnts'/>");
                    location.reload();
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                /* 제출 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
                alert("<spring:message code='lesson.alert.message.no.submit'/>");
            }, true);
        }

        // 제출 완료 처리 (일괄)
        function setSubmitBatch() {
            var indvAsmtList = "";

            $.each($('#asmntStareUserList').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function (i) {
                if ((i + 1) > 1) indvAsmtList += ",";
                indvAsmtList += $(this).attr("user_id");
            });

            if (!indvAsmtList) {
                // 학습자를 선택해 주세요.
                alert("<spring:message code='asmnt.alert.select.std'/>");
                return;
            }

            var url = "/asmt/profAsmtSbmsnBulkCmptnProc.do";
            var data = {
                "crsCreCd": "${vo.crsCreCd}",
                "asmtId": "${vo.asmtId}",
                "indvAsmtList": indvAsmtList,
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    /* 정상 제출되었습니다. */
                    alert("<spring:message code='lesson.alert.message.submit.lesson.cnts'/>");
                    location.reload();
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                /* 제출 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
                alert("<spring:message code='lesson.alert.message.no.submit'/>");
            }, true);
        }

        // 미제출 처리
        function setNoSubmit(asmtSbmsnId) {
            // 미제출처리 하시겠습니까? 평가점수가 있는경우 초기화 됩니다.
            if (!confirm("<spring:message code='asmnt.alert.change.no.sumit.confirm'/>")) return;

            var url = "/asmt/profAsmtNsbMng.do";
            var data = {
                crsCreCd: "${vo.crsCreCd}"
                , asmtId: "${vo.asmtId}"
                , asmtSbmsnId: asmtSbmsnId
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    alert("<spring:message code='common.result.success'/>"); // 성공적으로 작업을 완료하였습니다.
                    location.reload();
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                alert("<spring:message code='fail.common.msg'/>"); // 에러가 발생했습니다!
            }, true);
        }

        function btnFocused(obj, key, val, val2) {
            $("#asmntStareUserList tr").removeClass('focused');
            $(obj).closest('tr').addClass('focused');

            switch (key) {
                case 2:
                    userInfoPop(val);
                    break;
                case 3:
                    fdbkList(val);
                    break;
                case 4:
                    getPrevAsmntFiles(val);
                    break;
                case 5:
                    ezGrader(val);
                    break;
                case 6:
                    setMemo(val);
                    break;
                case 7:
                    setCmnt(val);
                    break;
                case 8:
                    setSubmit(val, val2);
                    break;
                case 9:
                    setNoSubmit(val);
                    break;
            }

        }

        // 평가 기준 수정 팝업
        function mutEvalWritePop() {
            var modalId = "Ap01";
            initModal(modalId);

            var kvArr = [];
            kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
            kvArr.push({'key': 'asmtEvlId', 'val': "${vo.asmtEvlId}"});

            submitForm("/mut/mutPop/mutEvalWritePop.do", modalId + "ModalIfm", kvArr);
        }

        // 평가 기준 수정
        function mutEvalWrite(asmtEvlId, evalTitle) {
            var url = "/asmtProfAsmtMutEvlModify.do";
            var data = {
                "crsCreCd": "${vo.crsCreCd}",
                "asmtId": "${vo.asmtId}",
                "asmtEvlId": asmtEvlId
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    location.reload();
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                /* 에러가 발생했습니다! */
                alert("<spring:message code='fail.common.msg' />");
            }, true);
        }

        //팀 구성원 보기
        function teamMemberView(lrnGrpId) {
            var modalId = "Ap06";
            initModal(modalId);

            var kvArr = [];
            kvArr.push({'key': 'lrnGrpId', 'val': lrnGrpId});

            submitForm("/forum/forumLect/teamMemberList.do", modalId + "ModalIfm", kvArr);
        }

        function mosaComparePop() {
            var modalId = "Ap18";
            initModal(modalId);

            var kvArr = [];
            kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
            kvArr.push({'key': 'asmtId', 'val': "${vo.asmtId}"});

            submitForm("/asmt/profMosartPopView.do", modalId + "ModalIfm", kvArr);
        }

        function ezgCloseCallback() {
            listAsmntUser();
            $("#ezIfm").attr("src", "");
        }
    </script>
</head>
<body class="<%=SessionInfo.getThemeMode(request)%>">
<div id="wrap" class="pusher">

    <!-- class_top 인클루드  -->
    <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>

    <div id="container">
        <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>

        <div class="content stu_section">
            <%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>

            <form id="ezForm" name="ezForm" action="/asmt/profEzGraderView.do" method="POST">
                <input type="hidden" name="crsCreCd" value="${vo.crsCreCd }">
                <input type="hidden" name="asmtId" value="${vo.asmtId }">
                <input type="hidden" name="stdNo" value="">
            </form>

            <div class="ui form">
                <div class="layout2">
                    <script>
                        $(document).ready(function () {
                            // set location
                            setLocationBar('<spring:message code='asmnt.label.asmnt'/>', '<spring:message code="common.label.info.manage" />'); // 과제정보 및 평가
                        });
                    </script>

                    <div id="info-item-box">
                        <h2 class="page-title flex-item flex-wrap gap4 columngap16">
                            <spring:message code="asmnt.label.asmnt"/><!-- 과제 -->
                        </h2>
                        <div class="button-area">
                            <c:if test="${vo.examInsYn eq 'N' }">
                                <a href="javascript:resendPop()" class="ui blue button">
                                    <spring:message code="common.label.resubmit" /><spring:message code="common.mgr" /><!-- 재제출 관리 --></a>
                            </c:if>
                            <a href="javascript:editAsmnt()" class="ui blue button">
                                <spring:message code='asmnt.button.mod'/><!-- 수정 --></a>
                            <a href="javascript:deleteAsmnt()" class="ui basic button">
                                <spring:message code='asmnt.button.del'/><!-- 삭제 --></a>
                            <a href="javascript:viewAsmntList()" class="ui basic button"><spring:message
                                    code="asmnt.button.list"/></a><!-- 목록 -->
                        </div>
                    </div>

                    <div class="row">
                        <div class="col">

                            <div class="listTab">
                                <ul class="">
                                    <li class="select mw120">
                                        <a onclick="manageAsmnt(1)"><spring:message
                                                code="common.label.info.manage"/></a><!-- 정보 및 평가 -->
                                    </li>
                                    <c:if test="${vo.evlRfltyn eq 'Y'}">
                                        <li class="mw120">
                                            <a onclick="manageAsmnt(2)"><spring:message
                                                    code="asmnt.label.mut.eval"/></a><!-- 상호평가 -->
                                        </li>
                                    </c:if>
                                </ul>
                            </div>

                            <div class="ui segment">
                                <%@ include file="/WEB-INF/jsp/asmt/common/asmt_info_inc.jsp" %>
                            </div>

                            <div class="option-content mb15">
                                <select class="ui dropdown mr5" id="searchKey" onchange="listAsmntUser();">
                                    <option value=" "><spring:message code="crs.label.all"/></option><!-- 전체 -->
                                    <option value="SUBMIT"><spring:message code="common.submission"/></option>
                                    <!-- 제출 -->
                                    <option value="NO"><spring:message code="common.not.submission"/></option>
                                    <!-- 미제출 -->
                                    <option value="NO_RE"><spring:message code="common.not.re.submission"/></option>
                                    <!-- 미재제출 -->
                                    <option value="LATE"><spring:message code="common.label.submit.lateness"/></option>
                                    <!--지각제출 -->
                                    <option value="RESEND"><spring:message code="asmnt.label.resubmit"/></option>
                                    <!--재제출 -->
                                </select>
                                <select class="ui dropdown mr5" id="searchKey3" onchange="listAsmntUser();">
                                    <option value=" "><spring:message code="crs.label.all"/></option><!-- 전체 -->
                                    <option value="Y"><spring:message code="button.rate"/></option><!-- 평가 -->
                                    <option value="N"><spring:message code="exam.label.eval.n"/></option><!-- 미평가 -->
                                </select>

                                <c:if test="${vo.teamAsmtStngyn eq 'Y'}">
                                    <select class="ui dropdown mr5" id="searchKey2" onchange="listAsmntUser();">
                                        <option value=" "><spring:message code="crs.label.all"/></option><!-- 전체 -->
                                        <c:forEach items="${teamList }" var="tl" varStatus="status">
                                            <option value="${tl.teamId}">${tl.teamnm}</option>
                                        </c:forEach>
                                    </select>
                                </c:if>

                                <div class="ui action input search-box mra">
                                    <input type="text"
                                           placeholder="<spring:message code='team.popup.search.placeholder'/>"
                                           class="w250" id="searchValue"><!-- 학과, 학번, 이름 입력 -->
                                    <button class="ui icon button" onclick="listAsmntUser();"><i
                                            class="search icon"></i></button>
                                </div>

                                <div class="button-area">
                                    <a href="javascript:ezGrader();" class="ui basic button ezgraderBtn">EZ-Grader</a>
                                    <a href="javascript:mosaComparePop();" class="ui basic button ezgraderBtn">
                                        <spring:message code="common.button.copy.rate.compare" /><!-- 답안유사율 비교 --></a>
                                    <a href="javascript:setExcel();" class="ui basic button"><spring:message
                                            code="asmnt.button.reg.excel.score"/></a><!-- 엑셀 성적등록 -->
                                    <uiex:msgSendBtn func="sendMsg()"/><!-- 메시지 -->
                                </div>
                            </div>

                            <c:if test="${vo.evlScrTycd ne 'RUBRIC_SCR' && !fn:contains(authGrpCd, 'TUT') }">
                                <div class="ui segment">
                                    <div class="fields">
                                        <div class="field flex-item">
                                            <spring:message code="common.label.batch.score.process" /><!-- 일괄 점수처리 -->
                                            <div class="ui radio checkbox pl10 pr10"
                                                 onclick="plusMinusIconControl('batch');">
                                                <input type="radio" name="scoreType" value="batch" tabindex="0"
                                                       class="hidden" checked>
                                                <label for="scoreBatch">
                                                    <spring:message code="exam.label.reg.scoring" /><!-- 점수 등록 --></label>
                                            </div>
                                            <div class="ui radio checkbox" onclick="plusMinusIconControl('addition');">
                                                <input type="radio" name="scoreType" value="addition" tabindex="0"
                                                       class="hidden">
                                                <label for="scoreAddition">
                                                    <spring:message code="exam.label.plus.minus.scoring" /><!-- 점수 가감 --></label>
                                            </div>
                                        </div>
                                        <div class="field ml15">
                                            <spring:message code="forum.label.score" /><!-- 점수 -->
                                            <div class="ui left icon input p_w60">
                                                <i class="ion-plus link icon toggle-icon" style="display:none;"></i>
                                                <input type="number" id="scoreValue" class="w100"/>
                                            </div>
                                            <spring:message code="asmnt.label.point" /><!-- 점 -->
                                        </div>
                                        <a href="javascript:submitScore()"
                                           class="ui blue small button flex-item"><spring:message
                                                code="common.label.batch.score.save"/></a><!-- 일괄 점수저장 -->
                                    </div>
                                </div>
                            </c:if>

                            <div class="ui segment">
                                <div class="ui stackable two column grid">
                                    <div class="column flex1">
                                        <div class="ui two column grid">
                                            <div class="column wauto">
                                                <div class="row">
                                                    <label for="fdbkValue" class="mt5 mr10"><spring:message
                                                            code="forum.label.feedback"/> : </label><!-- 피드백 -->
                                                </div>
                                                <div class="row pt10">
                                                    <!-- 음성녹음 -->
                                                    <div class="ui checkbox">
                                                        <input type="checkbox" id="audioChk"/><label for="audioChk"
                                                                                                     class="d-inline-block"><spring:message
                                                            code="asmnt.label.voice"/><br><spring:message
                                                            code="asmnt.label.transcription"/></label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="column flex1 pb0">
                                                <div class="row flex-column">
                                                    <div class="field ui fluid input">
                                                        <input type="text" id="fdbkValue" maxlength="3000"
                                                               placeholder="<spring:message code="forum.label.feedback.input" />">
                                                        <!-- 피드백 입력 -->
                                                    </div>
                                                </div>
                                                <div class="row flex-column">
                                                    <div class="ui box">
                                                        <div class="fields mr0">
                                                            <div class="field">
                                                                <button class="ui basic icon button"
                                                                        onclick="fdbkFilePopOpen();"><i
                                                                        class="save icon"></i><spring:message
                                                                        code="forum.label.fdbk.file.attach"/></button>
                                                                <!-- 파일첨부 -->
                                                            </div>
                                                            <div id="fdbkFileBox"
                                                                 class="field ui segment flex1 flex-item p4"
                                                                 style="position:relative;z-index:100">
                                                                <div class="flex align-items-center"
                                                                     id="fdbkFileView"></div>
                                                                <div id="fdbkFileUp"
                                                                     style="position:absolute;top:0;left:0;visibility:hidden;">
                                                                    <div class="flex1 fileUpBox"
                                                                         style="display:inline-block;width:450px">
                                                                        <uiex:dextuploader
                                                                                id="fileUploader"
                                                                                path="${uploadPath}"
                                                                                limitCount="1"
                                                                                limitSize="1024"
                                                                                oneLimitSize="1024"
                                                                                listSize="1"
                                                                                finishFunc="finishUpload()"
                                                                                allowedTypes="*"
                                                                                bigSize="false"
                                                                                useFileBox="true"
                                                                                uiMode="simple"
                                                                        />
                                                                    </div>
                                                                    <div class="flex1"
                                                                         style="display:inline-block;vertical-align:top">
                                                                        <button onclick="fdbkFilePopClose()"
                                                                                class="ui grey small button fCloseBtn"
                                                                                style="margin-left:-4px;"><span
                                                                                aria-hidden="true">&times;</span>
                                                                        </button>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <div class="fields mr0 audioDiv" id="fdbkFileView"
                                                             style="position:relative">
                                                            <div class="field">
                                                                <button class="ui basic icon button"
                                                                        onclick="fdbkAudioPopOpen();"><i
                                                                        class="microphone icon"></i><spring:message
                                                                        code="forum.label.fdbk.audio.attach"/></button>
                                                                <!-- 음성녹음 -->
                                                            </div>
                                                            <div class="field ui segment flex1 flex-item p4">
                                                                <div class="flex align-items-center gap8"
                                                                     id="fdbkAudioView"></div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="column flex wauto">
                                        <div class="flex-left-auto flex pt15 pb10">
                                            <a href="javascript:valFdbk()"
                                               class="ui blue button inline-flex-item"><spring:message
                                                    code="common.label.batch.feedback.save"/></a><!-- 일괄 피드백 저장 -->
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="option-content mb10">
                                <c:if test="${vo.asmtPrctcyn eq 'Y' }">
                                    <div class="ui checkbox">
                                        <input type="checkbox" name="allEvalChk" id="allChk" value="all"
                                               onchange="evalChk(this)" tabindex="0" class="hidden">
                                        <label class="toggle_btn" for="allChk">
                                            <spring:message code="asmnt.label.all" /><!-- 전체 -->
                                            <spring:message code="asmnt.label.select" /><!-- 선택 --></label>
                                    </div>
                                </c:if>
                                <c:if test="${vo.asmtPrctcyn eq 'Y'}">
                                    <a href="javascript:submitBest();" class="ui basic button ml10"><spring:message
                                            code="common.label.excellent.asmnt"/> <spring:message
                                            code="common.label.selection"/></a><!-- 우수과제 선정 -->
                                </c:if>
                                <a href="javascript:selFileDownload();" class="ui blue button"><spring:message
                                        code="asmnt.label.submitted.work"/> <spring:message
                                        code="asmnt.label.download"/></a><!-- 제출과제 다운로드 -->
                                <h4 class="ml5">(<spring:message code="common.page.total" /><!-- 총 -->&nbsp;:&nbsp;<span
                                        id="totalCntText">0</span><spring:message code="message.person" /><!-- 명 -->)
                                </h4>
                                <div class="mla">
                                    <c:if test="${vo.teamAsmtStngyn ne 'Y' and (fn:contains(vo.crsCreCd, 'CHY164') or fn:contains(vo.crsCreCd, 'CE_230827T194710c550004'))}">
                                        <a href="javascript:setSubmitBatch();" class="ui basic button">
                                            <spring:message code="asmnt.button.change.submit.batch" /><!-- 일괄 제출완료처리 --></a>
                                    </c:if>
                                    <a href="javascript:void(0);" class="ui basic button"
                                       id="changeScoreEditModeBtn"><spring:message
                                            code="common.label.batch.score.edit"/></a><!-- 일괄 점수편집 -->
                                    <a href="javascript:cancelScoreEditMode();" class="ui basic button"
                                       id="cancelScoreEditModeBtn" style="display: none;"><spring:message
                                            code="common.button.cancel"/></a><!-- 일괄 점수편집 -->
                                    <a href="javascript:getExcel()" class="ui blue button"><spring:message
                                            code="asmnt.label.excel.download"/></a><!-- 엑셀 다운로드 -->
                                </div>
                            </div>

                            <c:choose>
                                <c:when test="${vo.asmtPrctcyn eq 'Y' }">
                                    <div class="grid four CardList temp mt20 p20" id="asmntStareUserList"></div>
                                </c:when>
                                <c:otherwise>
                                    <table class="table type2" data-sorting="true" data-paging="false"
                                           data-empty="<spring:message code='common.nodata.msg' />">
                                        <thead>
                                        <tr>
                                            <th scope="col" data-sortable="false">
                                                <div class="ui checkbox">
                                                    <input type="checkbox" name="allEvalChk" id="allChk" value="all"
                                                           onchange="evalChk(this)">
                                                    <label class="toggle_btn" for="allChk"></label>
                                                </div>
                                            </th>
                                            <th scope="col" data-type="number" data-sortable="false">
                                                <spring:message code="common.number.no" /><!-- NO. --></th>
                                            <c:if test="${vo.teamAsmtStngyn eq 'Y'}">
                                                <th scope="col"><spring:message code="common.team" /><!-- 팀 --></th>
                                            </c:if>
                                            <th scope="col" data-breakpoints="xs" class="tc">
                                                <spring:message code="std.label.dept" /><!-- 학과 --></th>
                                            <th scope="col" data-breakpoints="xs" class="tc">
                                                <spring:message code="std.label.user_id" /><!-- 학번 --></th>
                                            <th scope="col" data-breakpoints="xs" class="tc">
                                                <spring:message code="std.label.hy" /><!-- 학년 --></th>
                                            <c:if test="${creCrsVO.univGbn eq '3' or creCrsVO.univGbn eq '4'}">
                                                <th scope="col" data-breakpoints="xs" class="tc">
                                                    <spring:message code="common.label.grsc.degr.cors.gbn" /><!-- 학위과정 --></th>
                                            </c:if>
                                            <th scope="col" class="tc">
                                                <spring:message code="std.label.name" /><!-- 이름 --></th>
                                            <th scope="col" data-breakpoints="xs sm" class="tc">
                                                <spring:message code="std.label.enter.year" /><!-- 입학년도 --></th>
                                            <th scope="col" data-breakpoints="xs sm" class="tc">
                                                <spring:message code="std.label.enter.hy" /><!-- 입학학년 --></th>
                                            <th scope="col" data-breakpoints="xs sm" class="tcc">
                                                <spring:message code="std.label.enter.gbn" /><!-- 입학구분 --></th>
                                                <%-- <th scope="col" data-breakpoints="xs sm md" class=""><spring:message code="common.label.same.rate" /><!-- 유사율 --></th> --%>
                                            <th scope="col" data-breakpoints="xs sm md" class="tc">
                                                <spring:message code="exam.label.eval.score" /><!-- 평가점수 --></th>
                                            <th scope="col" class="tc">
                                                <spring:message code="exam.label.submit.status" /><!-- 제출상태 --></th>
                                            <th scope="col" class="tc">
                                                <spring:message code="exam.label.eval.status" /><!-- 평가상태 --></th>
                                            <th scope="col" data-breakpoints="xs sm md" class="tc">
                                                <spring:message code="forum.label.submit.dt" /><!-- 제출일시 --></th>
                                            <th scope="col" data-breakpoints="xs sm md" data-sortable="false"
                                                class="tc"><spring:message code="forum.label.manage" /><!-- 관리 --></th>
                                        </tr>
                                        </thead>
                                        <tbody id="asmntStareUserList">
                                        </tbody>
                                    </table>
                                </c:otherwise>
                            </c:choose>

                        </div><!-- //col -->
                    </div><!-- //row -->

                </div>
            </div>

        </div><!-- //content -->
        <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
    </div><!-- //container -->
</div><!-- //pusher -->

<!-- 팝업 -->
<div class="modal fade" id="ezGraderPop" tabindex="-1" role="dialog" aria-labelledby="ezGrader모달" data-backdrop="static"
     data-keyboard="false" aria-hidden="false">
    <div class="modal-dialog full" role="document">
        <div class="modal-content">
            <div class="modal-body">
                <iframe src="" id="ezIfm" name="ezIfm" width="100%" scrolling="no"></iframe>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="fdbkAudioPop" tabindex="-1" role="dialog" aria-labelledby="audio" data-backdrop="static"
     data-keyboard="false" aria-hidden="false">
    <div class="modal-dialog modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"
                        aria-label="<spring:message code='team.common.close'/>" onclick="fdbkAudioPopClose();">
                    <!-- 닫기 -->
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title"><spring:message code="forum.label.feedback"/> <spring:message
                        code="forum.label.fdbk.audio.attach"/></h4><!-- 피드백 --><!-- 음성녹음 -->
            </div>
            <div class="modal-body">
                <div class="modal-page">
                    <div id="wrap">
                        <div class="ui form" style="height:50px">
                            <div id="audioRecord"></div>
                        </div>
                        <div class="bottom-content">
                            <a class="ui blue button toggle_btn flex-left-auto" onclick="fdbkAudioPopClose();">
                                <spring:message code="forum.button.attaching" /><!-- 첨부하기 --></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $('iframe').iFrameResize();
    window.closeModal = function () {
        $('.modal').modal('hide');
    };
</script>
</body>
</html>