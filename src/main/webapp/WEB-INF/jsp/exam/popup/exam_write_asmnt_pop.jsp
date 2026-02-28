<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
    <%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
    <link rel="stylesheet" type="text/css" href="/webdoc/file-uploader/file-uploader.css"/>
    <script type="text/javascript" src="/webdoc/js/jquery.form.min.js"></script>
    <script type="text/javascript" src="/webdoc/file-uploader/lang/file-uploader-ko.js"></script>
    <script type="text/javascript" src="/webdoc/file-uploader/file-uploader.js"></script>
    <script type="text/javascript" src="/webdoc/js/iframe.js"></script>
    <link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>
</head>

<script type="text/javascript">
    var eBoolean = false;

    $(document).ready(function () {

        // 지각제출사용 숨기기
        $("#viewExtSendAcpt").hide();
        // 평가방법 숨기기
        $("#mutEvalDiv").hide();
        // 실기과제 숨기기
        $("#viewPrtc").hide();
        // 상호 평가 사용 숨기기
        $("#viewEvalUse").hide();

        // 지각제출 변경시 화면 변경
        $("input[name='extSendAcptYn']").change(function () {
            var extSendAcpt = $("input[name='extSendAcptYn']:checked").val();

            if (extSendAcpt == 'Y') {
                $("#viewExtSendAcpt").show();
            } else if (extSendAcpt == 'N') {
                $("#viewExtSendAcpt").hide();
            }
        });

        // 평가방법 변경
        $("input[name='evalCtgr']").change(function () {
            var evalCtgr = $("input[name='evalCtgr']:checked").val();
            if (evalCtgr == 'R') {
                $("#mutEvalDiv").show();
            } else {
                $("#mutEvalDiv").hide();
            }
        });

        // 루브릭 팝업 닫기
        $('#mutEvalWritePop').on('hidden.bs.modal', function (e) {
            if ($("#evalCd").val() == "") {
                $("input:radio[name='evalCtgr']:radio[value='P']").prop('checked', true);
                $("#mutEvalDiv").hide();
            }
        });

        // 실기과제유무 변경시 화면 변경
        $("input[name='prtcYn']").change(function () {
            var prtc = $("input[name='prtcYn']:checked").val();

            if (prtc == 'Y') {
                // 제출형식 숨기기
                $("#viewSendType").hide();
                // 실기과제 보이기
                $("#viewPrtc").show();
            } else if (prtc == 'N') {
                // 실기과제 숨기기
                $("#viewPrtc").hide();
                // 제출형식 보이기
                $("#viewSendType").show();
            }
        });

        // 제출형식 변경시 화면 변경
        $("input[name='sendType']").change(function () {
            var sendType = $("input[name='sendType']:checked").val();

            if (sendType == 'F') {
                $("#viewSendTypeFile").show();
            } else if (sendType == 'T') {
                $("#viewSendTypeFile").hide();
            }
        });

        // 결과공개 변경시 값 변경
        $('input:checkbox[name="evalRsltOpenYn"]').change(function () {
            $(this).is(":checked") == true ? $("input[name='evalRsltOpenYn']").val('Y') : $("input[name='evalRsltOpenYn']").val('N')
        });

        // 제출형식 값 변경
        $('input:radio[name="sendFileType"]').change(function () {

            if ($(this).get(0).id == 'allFile') {
                $('input:checkbox[name="preFile"]').each(function () {
                    this.checked = false;
                });

                $('input:checkbox[name="docFile"]').each(function (i, o) {
                    this.checked = false;
                });
            }
        });

        // 제출형식 - 파일 - 미리보기
        $('input:checkbox[name="preFile"]').change(function () {
            $('#preFile').prop("checked", true);

            $('input:checkbox[name="docFile"]').each(function (i, o) {
                this.checked = false;
            });
        });

        // 제출형식 - 파일 - 문서
        $('input:checkbox[name="docFile"]').change(function () {
            $('#docFile').prop("checked", true);

            $('input:checkbox[name="preFile"]').each(function () {
                this.checked = false;
            });
        });

        if ("${asmtVo.asmntCd}" != "") {
            eBoolean = true;
            getAsmnt("${asmtVo.asmntCd}");
        }

        examDateSet();
    });

    // 이전 과제 가져오기
    function asmntCopyList() {
        $("#asmntCopyListForm").attr("target", "asmntCopyListIfm");
        $("#asmntCopyListForm").attr("action", "/asmtProfAsmtCopyPopView.do");
        $("#asmntCopyListForm").submit();
        $('#asmntCopyListPop').modal('show');
    }

    // 과제 복사
    function copyAsmnt(asmntCd) {
        eBoolean = false;
        getAsmnt(asmntCd);
    }

    // 과제 가져오기
    function getAsmnt(asmntCd) {
        var url = "/asmt/profAsmtSelect.do";
        var data = {
            asmntCd: asmntCd
            , crsCreCd: "${creCrsVO.crsCreCd}"
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var vo = data.returnVO;

                setData(vo);

                $('.modal').modal('hide');
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("에러가 발생했습니다!");
        });
    }

    function setData(vo) {
        // 에디터 초기화
        editor.execCommand('selectAll');
        editor.execCommand('deleteLeft');
        editor.execCommand('insertText', "");
        // 과제명
        $("#asmntTitle").val(vo.asmntTitle);
        // 과제 내용
        editor.insertHTML($.trim(vo.asmntCts));

        if (eBoolean) {
            $("input[name=asmntCd]").val(vo.asmntCd);
        } else {
            $("input[name=asmntCd]").val('');
        }

        // 지각 제출 사용
        if (vo.extSendAcptYn == 'Y') {
            $("input:radio[name='extSendAcptYn']:radio[value='Y']").prop('checked', true);
            setDataCalendar(vo.extSendDttm, "extSendDttm", "calExtSendHH", "calExtSendMM");
            $("#viewExtSendAcpt").show();
        } else {
            $("input:radio[name='extSendAcptYn']:radio[value='N']").prop('checked', true);
            setDataCalendar(null, "extSendDttm", "calExtSendHH", "calExtSendMM");
            $("#viewExtSendAcpt").hide();
        }
        // 평가방법
        if (eBoolean) {
            if (vo.evalCtgr == 'P') {
                $("input:radio[name='evalCtgr']:radio[value='P']").prop('checked', true);
            } else if (vo.evalCtgr == 'R') {
                $("input:radio[name='evalCtgr']:radio[value='R']").prop('checked', true);
                $("#evalCd").val(vo.evalCd);
                $("#evalTitle").val(vo.evalTitle);
                $("#mutEvalDiv").show();
            }
        } else {
            $("input:radio[name='evalCtgr']:radio[value='P']").prop('checked', true);
            $("#mutEvalDiv").hide();
        }

        // 실기과제
        if (vo.prtcYn == 'Y') {
            $("input:radio[name='prtcYn']:radio[value='Y']").prop('checked', true);
            $("#viewPrtc").show();
            $("#viewSendType").hide();

            // 파일형식 매핑

        } else {
            $("input:radio[name='prtcYn']:radio[value='N']").prop('checked', true);
            $("#viewPrtc").hide();
            $("#viewSendType").show();

            // 제출형식 매핑
            if (vo.sendType == 'F') {
                $("input:radio[name='sendType']:radio[value='F']").prop('checked', true);
                $("#viewSendTypeFile").show();
            } else if (vo.sendType == 'T') {
                $("input:radio[name='sendType']:radio[value='T']").prop('checked', true);
                $("#viewSendTypeFile").hide();
            }
        }

        // 파일업로드
        $("#searchTo").val(vo.asmntCd);
        var fileSns = new Set();
        if (fileUploader.limitCount < vo.fileList.length) {
            /* 최대 가능 개수를 넘어 파일 가져오기가 취소되었습니다. */
            alert('<spring:message code="exam.alert.max.file.limit.cancel" />');
        } else {
            $(".old-file").remove();
            vo.fileList.forEach(function (v, i) {
                fileUploader.addOldFile(v.fileId, v.fileNm, v.fileSize);
                fileSns.add(v.fileSn);
            });
            $("#fileSns").val(Array.from(fileSns));
        }
        $("#uploadPath").val("/asmt");

        // 성적 반영 여부
        if (vo.scoreAplyYn == 'Y') {
            $("input:radio[name='scoreAplyYn']:radio[value='Y']").prop('checked', true);
        } else {
            $("input:radio[name='scoreAplyYn']:radio[value='N']").prop('checked', true);
        }
        // 성적 공개 여부
        if (vo.scoreOpenYn == 'Y') {
            $("input:radio[name='scoreOpenYn']:radio[value='Y']").prop('checked', true);
        } else {
            $("input:radio[name='scoreOpenYn']:radio[value='N']").prop('checked', true);
        }
    }

    // 저장 확인
    function saveConfirm() {
        // 파일이 있으면 업로드 시작
        if (fileUploader.getFileCount() > 0) {
            fileUploader.startUpload();
        } else {
            // 저장 호출
            save();
        }
    }

    // 필수값 확인 및 값 적용
    function validation() {

        // 과제명
        var asmntTitle = $("input[name=asmntTitle]").val();
        if (asmntTitle == null || asmntTitle == '') {
            /* 과제명을 입력하세요.*/
            alert('<spring:message code="asmnt.alert.input.asmnt_title" />');
            return false;
        }

        // 제출기간
        if (calendarComparison("<spring:message code='common.submission.period' />"
            , $("input[name=sendStartDttm]").val()
            , $("#calSendStartHH").val()
            , $("#calSendStartMM").val()
            , $("input[name=sendEndDttm]").val()
            , $("#calSendEndHH").val()
            , $("#calSendEndMM").val()
        )) {
            return false;
        }

        // 제출형식
        if ($("input:radio[name='prtcYn']:checked").val() == 'Y') {
            if ($("input:checkbox[name=prtcFileType]:checked").length < 1) {

                /* 실기과제 파일형식을 선택하세요. */
                alert("<spring:message code='asmnt.label.prtc.filetype.select' />");
                return false;
            }
        } else {
            if ($("input:radio[name=sendType]:checked").length == 0) {

                /* 제출형식을 선택하세요. */
                alert("<spring:message code='asmnt.label.filetype.select' />");
                return false;
            }

            if ($("input:radio[name=sendType]:checked").val() == 'F') {
                if ($('input:radio[name=sendFileType]:checked').val() != 'all') {
                    if ($("input:checkbox[name=preFile]:checked").length + $("input:checkbox[name=docFile]:checked").length < 1) {

                        /* 파일 제출형식을 선택하세요. */
                        alert("<spring:message code='file.label.filetype.select' />");
                        return false;
                    }
                }
            }
        }

        // 지각제출마감사용
        if ($("input:radio[name=extSendAcptYn]:checked").val() == 'Y') {
            if (calendarCheck("<spring:message code='resh.label.ext.end' />"
                , $("input[name=extSendDttm]").val()
                , $("#calExtSendHH").val()
                , $("#calExtSendMM").val()
            )) {
                return false;
            }
        }
        return true;
    }

    // 저장
    function save() {
        // 에디터 내용
        var _content = editor.getPublishingHtml();

        if (validation()) {
            showLoading();
            var url = "";
            if (eBoolean) {
                url = "/exam/editAsmnt.do";
            } else {
                url = "/exam/addAsmnt.do";
            }
            $.ajax({
                url: url,
                async: false,
                type: "POST",
                dataType: "json",
                data: $("#asmntWriteForm").serialize(),
            }).done(function (data) {
                hideLoading();
                if (data.result > 0) {
                    var startDttm = $("#sendStartDttm").val().replaceAll(".", "") + "" + pad($("#calSendStartHH option:selected").val(), 2) + "" + pad($("#calSendStartMM option:selected").val(), 2);
                    var endDttm = $("#sendEndDttm").val().replaceAll(".", "") + "" + pad($("#calSendEndHH option:selected").val(), 2) + "" + pad($("#calSendEndMM option:selected").val(), 2);

                    var asmtVO = data.returnVO;
                    alert("<spring:message code='exam.alert.insert' />");
                    window.parent.complateWriteType("ASMNT", asmtVO.asmntCd, asmtVO.asmntTitle, startDttm, endDttm);
                    window.parent.closeModal();
                } else {
                    alert(data.message);
                }
            }).fail(function () {
                hideLoading();
                alert("<spring:message code='exam.error.insert' />");
            });
        }
    }

    // 파일 업로드 완료
    function finishUpload() {
        var url = "/file/fileHome/saveFileInfo.do";
        var data = {
            "uploadFiles": fileUploader.getUploadFiles(),
            "copyFiles": fileUploader.getCopyFiles(),
            "uploadPath": fileUploader.path
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                $("#uploadFiles").val(fileUploader.getUploadFiles());
                $("#copyFiles").val(fileUploader.getCopyFiles());
                $("#uploadPath").val("/asmt");

                save();
            } else {
                alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
        });
    }

    // 평가 기준 등록 팝업
    function mutEvalWritePop(type) {
        var evalCd = "";
        if (type == 'edit') {
            evalCd = $("#evalCd").val();
            if (evalCd == "") {
                /* 수정할 평가기준이 없습니다. */
                alert('<spring:message code="forum.alert.evalCd.none" />');
                return false;
            }
        }
        var url = "/mut/mutPop/mutEvalWritePop.do";
        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "writeForm");
        form.attr("target", "mutEvalWriteIfm");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: "${vo.crsCreCd}"}));
        form.append($('<input/>', {type: 'hidden', name: 'evalCd', value: evalCd}));
        form.appendTo("body");
        form.submit();
        $('#mutEvalWritePop').modal('show');
    }

    // 평가 기준 등록
    function mutEvalWrite(evalCd, evalTitle) {
        $("#evalCd").val(evalCd);
        $("#evalTitle").val(evalTitle);
    }

    // 평가기준 삭제
    function deleteMut() {
        var evalCd = $("#evalCd").val();
        if (evalCd == "") {
            /* 삭제할 평가기준이 없습니다. */
            alert('<spring:message code="forum.alert.evalCd.del" />');
            return false;
        }

        /* 삭제 하시겠습니까? */
        if (window.confirm("<spring:message code='seminar.confirm.delete' />")) {
            var url = "/mut/mutHome/edtDelYn.do";
            var data = {
                "evalCd": evalCd
                , "delYn": 'Y'
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    $("#evalCd").val("");
                    $("#evalTitle").val("");
                    /* 정상적으로 삭제되었습니다. */
                    alert("<spring:message code='success.common.delete'/>");
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                /* 삭제 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
                alert("<spring:message code='seminar.error.delete' />");
            });
        }
    }

    // 달력 값 매핑
    function setDataCalendar(dt, ymd, hh, mm) {
        if (dt != null) {
            $("#" + ymd).val(dt.substring(0, 4) + '.' + dt.substring(4, 6) + '.' + dt.substring(6, 8));
            $("#" + hh).dropdown('set selected', dt.substring(8, 10));
            $("#" + mm).dropdown('set selected', dt.substring(10, 12));
        } else {
            $("#" + ymd).val(null);
            $("#" + hh).dropdown('set selected', ' ');
            $("#" + mm).dropdown('set selected', ' ');
        }
    }

    // 달력 비교
    function calendarComparison(msg, dt1, hh1, mm1, dt2, hh2, mm2) {
        if (dt1 == null || dt1 == '') {
            alert("<spring:message code='common.alert.input.eval_start_date' arguments='"+msg+"'/>");
            return true;
        } else if (hh1 == ' ') {
            alert("<spring:message code='common.alert.input.eval_start_hour' arguments='"+msg+"'/>");
            return true;
        } else if (mm1 == ' ') {
            alert("<spring:message code='common.alert.input.eval_start_min' arguments='"+msg+"'/>");
            return true;
        } else if (dt2 == null || dt2 == '') {
            alert("<spring:message code='common.alert.input.eval_end_date' arguments='"+msg+"'/>");
            return true;
        } else if (hh2 == ' ') {
            alert("<spring:message code='common.alert.input.eval_end_hour' arguments='"+msg+"'/>");
            return true;
        } else if (mm2 == ' ') {
            alert("<spring:message code='common.alert.input.eval_end_min' arguments='"+msg+"'/>");
            return true;
        } else if (new Date(dt1 + ' ' + hh1 + ':' + mm1) > new Date(dt2 + ' ' + hh2 + ':' + mm2)) {
            alert("<spring:message code='common.alert.input.eval_start_end_date' arguments='"+msg+"'/>");
            return true;
        }
        return false;
    }

    // 달력 체크
    function calendarCheck(msg, dt, hh, mm) {
        if (dt == null || dt == '') {
            /* 일을 입력하세요. */
            alert(msg + '<spring:message code="ccommon.alert.input.hour" />');
            // alert("<spring:message code='common.alert.input.eval_date' arguments='"+msg+"'/>");
            return true;
        } else if (hh == ' ') {
            /* 시간을 입력하세요. */
            // alert("<spring:message code='common.alert.input.eval_hour' arguments='"+msg+"'/>");
            alert(msg + '<spring:message code="ccommon.alert.input.min" />');
            return true;
        } else if (mm == ' ') {
            /* 분을 입력하세요.  */
            // alert("<spring:message code='common.alert.input.eval_min' arguments='"+msg+"'/>");
            alert(msg + '<spring:message code="ccommon.alert.input.min" />');
            return true;
        }
        return false;
    }

    // 시험 날짜 세팅
    function examDateSet() {
        if ("${dateVO.startDate}" != "") $("#sendStartDttm").val("${dateVO.startDate}");
        if ("${dateVO.startHH}" != "") $("#calSendStartHH option[value=${dateVO.startHH}]").prop("selected", true).trigger("change");
        if ("${dateVO.startMM}" != "") $("#calSendStartMM option[value=${dateVO.startMM}]").prop("selected", true).trigger("change");
        if ("${dateVO.endDate}" != "") $("#sendEndDttm").val("${dateVO.endDate}");
        if ("${dateVO.endHH}" != "") $("#calSendEndHH option[value=${dateVO.endHH}]").prop("selected", true).trigger("change");
        if ("${dateVO.endMM}" != "") $("#calSendEndMM option[value=${dateVO.endMM}]").prop("selected", true).trigger("change");
    }
</script>

<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>

<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
<form id="asmntCopyListForm" name="asmntCopyListForm" action="" method="POST"></form>
<div id="wrap">
    <div class="option-content mb20">
        <div class="mla">
            <a href="javascript:asmntCopyList();" class="ui blue button"><spring:message
                    code="asmnt.button.asmnt.prev"/></a><!-- 이전 과제 가져오기 -->
        </div>
    </div>
    <form name="asmntWriteForm" id="asmntWriteForm" method="POST" autocomplete="off">
        <input type="hidden" name="asmntCd" value=""/>
        <input type="hidden" name="asmntCtgrCd" value="${examTypeCd eq 'EXAM' ? 'SUBS' : 'EXAM' }"/>
        <input type="hidden" name="crsCreCd" value="${creCrsVO.crsCreCd }"/>
        <input type="hidden" name="scoreRatio" value="${empty evo.examCd ? '0' : evo.scoreRatio }"/>
        <input type="hidden" name="declsRegYn" value="N"/>
        <input type="hidden" name="teamAsmntCfgYn" value="N"/>
        <input type="hidden" name="indYn" value="N"/>
        <input type="hidden" name="sbmtOpenYn" value="N"/>
        <input type="hidden" name="evalUseYn" value="N"/>
        <input type="hidden" name="fileSns" value="" id="fileSns"/>
        <input type="hidden" name="searchTo" value="" id="searchTo"/>
        <input type="hidden" name="uploadFiles" value="" id="uploadFiles"/>
        <input type="hidden" name="copyFiles" value="" id="copyFiles"/>
        <input type="hidden" name="uploadPath" value="" id="uploadPath"/>
        <div class="ui form" id="examWriteAsmntDiv">
            <div class="ui segment">
                <ul class="tbl border-top-grey">
                    <li>
                        <dl>
                            <dt><label for="asmntTitle" class="req"><spring:message
                                    code="asmnt.label.asmnt.title"/></label></dt><!-- 과제명 -->
                            <dd>
                                <div class="ui fluid input">
                                    <input type="text" id="asmntTitle" name="asmntTitle">
                                </div>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><label for="contentTextArea" class="req"><spring:message
                                    code="asmnt.label.asmnt.content"/></label></dt><!-- 과제내용 -->
                            <dd style="height:400px">
                                <div style="height:100%">
                                    <textarea name="asmntCts" id="asmntCts"></textarea>
                                    <script>
                                        // html 에디터 생성
                                        var editor = HtmlEditor('asmntCts', THEME_MODE, '/asmt');
                                    </script>
                                </div>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><label for="dateLabel" class="req"><spring:message
                                    code="asmnt.label.send.date"/></label></dt><!-- 제출기간 -->
                            <dd>
                                <div class="fields gap4">
                                    <div class="field flex">
                                        <!-- 시작일시 -->
                                        <uiex:ui-calendar dateId="sendStartDttm" hourId="calSendStartHH"
                                                          minId="calSendStartMM" rangeType="start"
                                                          rangeTarget="sendEndDttm" value="${evo.examStartDttm}"/>
                                    </div>
                                    <div class="field p0 flex-item desktop-elem">~</div>
                                    <div class="field flex">
                                        <!-- 종료일시 -->
                                        <uiex:ui-calendar dateId="sendEndDttm" hourId="calSendEndHH"
                                                          minId="calSendEndMM" rangeType="end"
                                                          rangeTarget="sendStartDttm" value="${evo.examEndDttm}"/>
                                    </div>
                                </div>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><label class="req"><spring:message code="exam.label.score.aply.y"/></label></dt>
                            <!-- 성적반영 -->
                            <dd>
                                <div class="fields">
                                    <div class="field">
                                        <div class="ui radio checkbox">
                                            <input type="radio" id="scoreAplyY" name="scoreAplyYn" tabindex="0"
                                                   class="hidden" value="Y" checked/>
                                            <label for="scoreAplyY"><spring:message code="seminar.common.yes"/></label>
                                            <!-- 예 -->
                                        </div>
                                    </div>
                                    <div class="field">
                                        <div class="ui radio checkbox">
                                            <input type="radio" id="scoreAplyN" name="scoreAplyYn" tabindex="0"
                                                   class="hidden" value="N"/>
                                            <label for="scoreAplyN"><spring:message code="seminar.common.no"/></label>
                                            <!-- 아니오 -->
                                        </div>
                                    </div>
                                </div>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><label class="req"><spring:message code="exam.label.score.open.y"/></label></dt>
                            <!-- 성적공개 -->
                            <dd>
                                <div class="fields">
                                    <div class="field">
                                        <div class="ui radio checkbox">
                                            <input type="radio" id="scoreOpenY" name="scoreOpenYn" tabindex="0"
                                                   class="hidden" value="Y" checked/>
                                            <label for="scoreOpenY"><spring:message code="resh.common.yes"/></label>
                                            <!-- 예 -->
                                        </div>
                                    </div>
                                    <div class="field">
                                        <div class="ui radio checkbox">
                                            <input type="radio" id="scoreOpenN" name="scoreOpenYn" tabindex="0"
                                                   class="hidden" value="N"/>
                                            <label for="scoreOpenN"><spring:message code="resh.common.no"/></label>
                                            <!-- 아니요 -->
                                        </div>
                                    </div>
                                </div>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><label><spring:message code="forum.label.periodAfterWrite"/></label></dt>
                            <!-- 지각 제출 사용 -->
                            <dd>
                                <div class="fields">
                                    <div class="field">
                                        <div class="ui radio checkbox">
                                            <input type="radio" name="extSendAcptYn" id="extSendAcptY" value="Y"
                                                   tabindex="0" class="hidden">
                                            <label for="extSendAcptY"><spring:message code="resh.common.yes"/></label>
                                            <!-- 예 -->
                                        </div>
                                    </div>
                                    <div class="field">
                                        <div class="ui radio checkbox">
                                            <input type="radio" name="extSendAcptYn" id="extSendAcptN" value="N"
                                                   tabindex="0" class="hidden" checked>
                                            <label for="extSendAcptN"><spring:message code="resh.common.no"/></label>
                                            <!-- 아니요 -->
                                        </div>
                                    </div>
                                </div>
                                <div class="ui segment bcLgrey9" id="viewExtSendAcpt">
                                    <div class="fields">
                                        <div class="inline field">
                                            <label for="extSendFmt"><spring:message
                                                    code="forum.label.extEndDttm"/></label><!-- 제출 마감일 -->
                                            <div class="fields gap4">
                                                <uiex:ui-calendar dateId="extSendDttm" hourId="calExtSendHH"
                                                                  minId="calExtSendMM" rangeType="start"
                                                                  value="${asmtVo.extSendDttm}"/>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><label class="req"><spring:message code="resh.label.eval.cg"/></label></dt><!-- 평가방법 -->
                            <dd>
                                <div class="fields">
                                    <div class="field">
                                        <div class="ui radio checkbox">
                                            <input type="radio" id="evalCtgrP" name="evalCtgr" value="P" tabindex="0"
                                                   class="hidden" checked>
                                            <label for="evalCtgrP"><spring:message
                                                    code="asmnt.label.point.type"/></label><!-- 점수형 -->
                                        </div>
                                    </div>
                                    <div class="field">
                                        <div class="ui radio checkbox">
                                            <input type="radio" id="evalCtgrR" name="evalCtgr" value="R" tabindex="0"
                                                   class="hidden">
                                            <label for="evalCtgrR"><spring:message code="asmnt.label.rubric"/></label>
                                            <!-- 루브릭 -->
                                        </div>
                                    </div>
                                    <div class="field" id="mutEvalDiv">
                                        <div class="ui action input search-box mr5">
                                            <input type="hidden" name="evalCd" id="evalCd"/>
                                            <input type="text" name="evalTitle" id="evalTitle">
                                            <button type="button" class="ui icon button"
                                                    onclick="mutEvalWritePop('new');"><i
                                                    class="pencil alternate icon"></i></button>
                                            <button type="button" class="ui icon button"
                                                    onclick="mutEvalWritePop('edit');"><i class="edit icon"></i>
                                            </button>
                                            <button type="button" class="ui icon button" onclick="deleteMut();"><i
                                                    class="trash icon"></i></button>
                                        </div>
                                    </div>
                                </div>
                                <div class="ui small warning message"><i class="info icon"></i><spring:message
                                        code="forum.label.evalctgr.rubric.info"/></div>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><label class="req"><spring:message code="asmnt.label.practice.asmnt"/></label></dt>
                            <!-- 실기과제 -->
                            <dd>
                                <div class="fields">
                                    <div class="field">
                                        <div class="ui radio checkbox">
                                            <input type="radio" id="prtcN" name="prtcYn" value="N" tabindex="0"
                                                   class="hidden" checked>
                                            <label for="prtcN"><spring:message code="asmnt.common.no"/></label>
                                            <!-- 아니오 -->
                                        </div>
                                    </div>
                                    <div class="field">
                                        <div class="ui radio checkbox">
                                            <input type="radio" id="prtcY" name="prtcYn" value="Y" tabindex="0"
                                                   class="hidden">
                                            <label for="prtcY"><spring:message code="asmnt.common.yes"/></label>
                                            <!-- 예 -->
                                        </div>
                                    </div>
                                </div>
                                <div class="ui segment bcLgrey9" id="viewPrtc">
                                    <div class="fields">
                                        <div class="field">
                                            <div class="ui">
                                                <label for="fileType"><spring:message code="button.manage.file.type"/>
                                                    : </label><!-- 파일 형식 -->
                                            </div>
                                        </div>
                                        <div class="field">
                                            <div class="ui checkbox">
                                                <input type="checkbox" id="fileType01">
                                                <label class="toggle_btn" for="fileType01"><spring:message
                                                        code="common.label.image"/> (JPG, GIF, PNG)</label><!-- 이미지 -->
                                            </div>
                                        </div>
                                        <div class="field">
                                            <div class="ui checkbox">
                                                <input type="checkbox" id="fileType02">
                                                <label class="toggle_btn" for="fileType02">PDF</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><label class="req"><spring:message code="button.manage.send"/></label></dt>
                            <!-- 제출 형식 -->
                            <dd>
                                <div class="fields">
                                    <div class="field">
                                        <div class="ui radio checkbox">
                                            <input type="radio" id="sendTypeF" tabindex="0" class="hidden"
                                                   name="sendType" value="F" checked>
                                            <label for="sendTypeF"><spring:message code="common.file"/></label>
                                            <!-- 파일 -->
                                        </div>
                                    </div>
                                    <div class="field">
                                        <div class="ui radio checkbox">
                                            <input type="radio" id="sendTypeT" tabindex="0" class="hidden"
                                                   name="sendType" value="T">
                                            <label for="sendTypeT"><spring:message code="lesson.label.text"/></label>
                                            <!-- 텍스트 -->
                                        </div>
                                    </div>
                                </div>
                                <div class="ui segment bcLgrey9" id="viewSendTypeFile">
                                    <div class="fields">
                                        <div class="field">
                                            <div class="ui radio checkbox">
                                                <input type="radio" id="allFile" name="sendFileType" value="all"
                                                       class="hidden" checked>
                                                <label for="allFile">
                                                    <spring:message code="asmnt.label.total.file" /><!-- 모든파일 --></label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="fields">
                                        <div class="field">
                                            <div class="ui radio checkbox">
                                                <input type="radio" id="preFile" name="sendFileType" value="pre"
                                                       class="hidden">
                                                <label for="preFile"><spring:message code="button.preview"/>
                                                    <spring:message code="message.possible"/> : </label>
                                            </div>
                                        </div>
                                        <div class="field">
                                            <div class="ui checkbox">
                                                <input type="checkbox" id="preFile01" name="preFile" value="img">
                                                <label class="toggle_btn" for="preFile01"><spring:message
                                                        code="common.label.image"/> (JPG, GIF, PNG)</label><!-- 이미지 -->
                                            </div>
                                        </div>
                                        <div class="field">
                                            <div class="ui checkbox">
                                                <input type="checkbox" id="preFile02" name="preFile" value="pdf">
                                                <label class="toggle_btn" for="preFile02">PDF</label>
                                            </div>
                                        </div>
                                        <div class="field">
                                            <div class="ui checkbox">
                                                <input type="checkbox" id="preFile03" name="preFile" value="txt">
                                                <label class="toggle_btn" for="preFile03">TEXT</label>
                                            </div>
                                        </div>
                                        <div class="field">
                                            <div class="ui checkbox">
                                                <input type="checkbox" id="preFile04" name="preFile" value="soc">
                                                <label class="toggle_btn" for="preFile04"><spring:message
                                                        code="common.label.program.source"/>(.txt)</label>
                                            </div>
                                        </div>
                                        <div class="field">
                                            <div class="ui checkbox">
                                                <input type="checkbox" id="preFile05" name="preFile" value="ppt2">
                                                <label class="toggle_btn" for="preFile05">PPT(X)</label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="fields">
                                        <div class="field">
                                            <div class="ui radio checkbox">
                                                <input type="radio" id="docFile" name="sendFileType" value="doc"
                                                       class="hidden">
                                                <label for="docFile"><spring:message code="common.label.type.doc"/>
                                                    : </label>
                                            </div>
                                        </div>
                                        <div class="field">
                                            <div class="ui checkbox">
                                                <input type="checkbox" id="docFile01" name="docFile" value="hwp">
                                                <label class="toggle_btn" for="docFile01">HWP(X)</label>
                                            </div>
                                        </div>
                                        <div class="field">
                                            <div class="ui checkbox">
                                                <input type="checkbox" id="docFile02" name="docFile" value="doc">
                                                <label class="toggle_btn" for="docFile02">DOC(X)</label>
                                            </div>
                                        </div>
                                        <div class="field">
                                            <div class="ui checkbox">
                                                <input type="checkbox" id="docFile03" name="docFile" value="ppt">
                                                <label class="toggle_btn" for="docFile03">PPT(X)</label>
                                            </div>
                                        </div>
                                        <div class="field">
                                            <div class="ui checkbox">
                                                <input type="checkbox" id="docFile04" name="docFile" value="xls">
                                                <label class="toggle_btn" for="docFile04">XLS(X)</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><label for="contentTextArea"><spring:message code="common.upload.file"/></label></dt>
                            <!-- 파일 업로드 -->
                            <dd>
                                <!-- 파일업로더 -->
                                <div id="uploaderBox"></div>
                                <uiex:fileuploader
                                        uploaderName="fileUploader"
                                        target="uploaderBox"
                                        path="/asmt"
                                        limitCount="5"
                                        limitSize="1024"
                                        oneLimitSize="1024"
                                        listSize="3"
                                        fileList="${fileList}"
                                        finishFunc="finishUpload"
                                        useFileBox="true"
                                />
                            </dd>
                        </dl>
                    </li>
                </ul>
            </div>
        </div>
    </form>

    <div class="bottom-content">
        <button class="ui blue button" onclick="saveConfirm();"><spring:message code="exam.button.save"/></button>
        <!-- 저장 -->
        <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message
                code="exam.button.close"/></button><!-- 닫기 -->
    </div>
</div>
<div class="modal fade" id="asmntCopyListPop" tabindex="-1" role="dialog"
     aria-labelledby="<spring:message code="asmnt.button.asmnt.prev" />" aria-hidden="false">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"
                        aria-label="<spring:message code="exam.button.close" />"><!-- 닫기 -->
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title"><spring:message code="asmnt.button.asmnt.prev"/></h4>
            </div>
            <div class="modal-body">
                <iframe src="" id="asmntCopyListIfm" name="asmntCopyListIfm" width="100%" height="1150px"
                        scrolling="no"></iframe>
            </div>
        </div>
    </div>
</div>
<!-- 평가기준 등록 팝업 -->
<div class="modal fade" id="mutEvalWritePop" tabindex="-1" role="dialog"
     aria-labelledby="<spring:message code="crs.label.eval_criteria_reg" />" aria-hidden="false">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"
                        aria-label="<spring:message code="exam.button.close" />"><!-- 닫기 -->
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title"><spring:message code="crs.label.eval_criteria_reg"/></h4><!-- 평가기준 등록 -->
            </div>
            <div class="modal-body">
                <iframe src="" id="mutEvalWriteIfm" name="mutEvalWriteIfm" width="100%" height="1500px"
                        scrolling="no"></iframe>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
