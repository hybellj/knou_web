<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/asmt/common/asmt_common_inc.jsp" %>
<%-- 에디터 --%>
<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>
<style>
    .tbl > li > dl > dt {
        width: 15%
    }
</style>
<script type="text/javascript">
    var eBoolean = false;
    var gInd = false;

    $(document).ready(function () {

        // 지각제출사용 숨기기
        $("#viewExtdSbmsnPrm").hide();
        // 평가방법 숨기기
        $("#mutEvalDiv").hide();
        // 실기과제 숨기기
        $("#viewPrtc").hide();
        // 팀과제여부 숨기기
        $("#viewTeamAsmnt").hide();
        // 개별과제여부 숨기기
        $("#viewIndAsmnt").hide();
        // 과제 읽기 허용 숨기기
        $("#viewSbasmtOstd").hide();
        // 상호 평가 사용 숨기기
        $("#viewEvalUse").hide();

        // 지각제출 변경시 화면 변경
        $("input[name='extdSbmsnPrmyn']").change(function () {
            var extSendAcpt = $("input[name='extdSbmsnPrmyn']:checked").val();

            if (extSendAcpt == 'Y') {
                $("#viewExtdSbmsnPrm").show();
            } else if (extSendAcpt == 'N') {
                $("#viewExtdSbmsnPrm").hide();
            }
        });

        // 평가방법 변경
        $("input[name='evlScrTycd']").change(function () {
            var evlScrTycd = $("input[name='evlScrTycd']:checked").val();
            if (evlScrTycd == 'RUBRIC_SCR') {
                $("#mutEvalDiv").show();
            } else {
                $("#mutEvalDiv").hide();
            }
        });

        // 루브릭 팝업 닫기
        $('#mutEvalWritePop').on('hidden.bs.modal', function (e) {
            if ($("#asmtEvlId").val() == "") {
                $("input:radio[name='evlScrTycd']:radio[value='SCR']").prop('checked', true);
                $("#mutEvalDiv").hide();
            }
        });

        // 실기과제유무 변경시 화면 변경
        $("input[name='asmtPrctcyn']").change(function () {
            var prtc = $("input[name='asmtPrctcyn']:checked").val();

            if (prtc == 'Y') {
                // 제출형식 숨기기
                $("#viewSbasmtTycd").hide();
                // 실기과제 보이기
                $("#viewPrtc").show();
            } else if (prtc == 'N') {
                // 실기과제 숨기기
                $("#viewPrtc").hide();
                // 제출형식 보이기
                $("#viewSbasmtTycd").show();

            }
        });

        // 제출형식 변경시 화면 변경
        $("input[name='sbasmtTycd']").change(function () {
            var sbasmtTycd = $("input[name='sbasmtTycd']:checked").val();

            if (sbasmtTycd == 'FILE') {
                $("#viewSbasmtTycdFile").show();
            } else if (sbasmtTycd == 'INPUT_TEXT') {
                $("#viewSbasmtTycdFile").hide();
            }
        });

        // 팀과제여부 변경시 화면 변경
        $("input[name='teamAsmtStngyn']").change(function () {
            var team = $("input[name='teamAsmtStngyn']:checked").val();

            if ($("input[name='indvAsmtyn']:checked").val() == 'Y') {
                // 개별 과제 여부 숨기기
                $("#viewIndAsmnt").hide();
                $("#indN").prop("checked", true);
            }

            if (team == 'Y') {
                // 팀 과제 여부 보이기
                $("#viewTeamAsmnt").show();
            } else if (team == 'N') {
                // 팀 과제 여부 숨기기
                $("#viewTeamAsmnt").hide();
            }
        });

        // 개별과제여부 변경시 화면 변경
        $("input[name='indvAsmtyn']").change(function () {
            var ind = $("input[name='indvAsmtyn']:checked").val();

            if ($("input[name='teamAsmtStngyn']:checked").val() == 'Y') {
                // 팀 과제 여부 숨기기
                $("#viewTeamAsmnt").hide();
                $("#teamN").prop("checked", true);
            }

            /*if ($("input:radio[name=evlRfltyn]:checked").val() == 'Y') {
                // 상호평가 미사용
                $("input:radio[name='evlRfltyn']:radio[value='N']").prop('checked', true);
                $("#viewEvalUse").hide();
                $("#evalStartDttmText").val(null);
                $("#evalEndDttmText").val(null);
                $("#evalRsltOpenYnCheck").prop('checked', false);
            }*/

            // 개별 과제 여부 보이기
            if (ind == 'Y') {
                if (!gInd) {
                    getAsmntJoinUser();
                }
                $("#viewIndAsmnt").show();
                $("#mrkRfltN").trigger("click");
            } else if (ind == 'N') {
                $("#viewIndAsmnt").hide();
            }
        });

        // 성적반영 변경시
        $("input[name='mrkRfltyn']").change(function () {
            var aply = $("input[name='mrkRfltyn']:checked").val();
            var ind = $("input[name='indvAsmtyn']:checked").val();

            // 개별 과제 여부 보이기
            if (ind == 'Y' && aply == 'Y') {
                alert("<spring:message code='asmnt.alert.ind.score.aply' />");/* 개별과제는 성적반영 불가능 합니다. */
                $("#mrkRfltN").trigger("click");
            }
        });

        // 과제 읽기 허용 변경시 화면 변경
        $("input[name='sbasmtOstdOyn']").change(function () {
            var sbmtOpen = $("input[name='sbasmtOstdOyn']:checked").val();
            if (sbmtOpen == 'Y') {
                $("#viewSbasmtOstd").show();
                syncOstdOpenDate();
            } else {
                $("#viewSbasmtOstd").hide();
            }

        });


        // 상호 평가 사용 변경시 화면 변경
        /*$("input[name='evlRfltyn']").change(function () {
            var evalUse = $("input[name='evlRfltyn']:checked").val();

            // 개별 과제 여부 보이기
            if ($("input[name='indvAsmtyn']:checked").val() == 'Y') {
                $("input:radio[name='indvAsmtyn'][value='N']").prop('checked', true);
                $("#viewIndAsmnt").hide();
            }

            if (evalUse == 'Y') {
                $("#viewEvalUse").show();
            } else if (evalUse == 'N') {
                $("#viewEvalUse").hide();
            }
        });
*/
        // 제출형식 값 변경
        $('input:radio[name="sbmsnFileMimeTycd"]').change(function () {
            $('input:checkbox[name="preFile"]').each(function () {
                this.checked = false;
            });

            $('input:checkbox[name="docFile"]').each(function () {
                this.checked = false;
            });
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

        // 개별과제 - 수강생 목록
        $('#tg0').change(function () {
            var chk = this.checked;
            $('#indvAsmtList input:checkbox').each(function (i, o) {
                if ($(o).parent().parent().parent().css('display') != 'none') {
                    o.checked = chk;
                }
            });
        });

        // 개별과제 - 할당 목록
        $('#stg0').change(function () {
            var chk = this.checked;
            $('#sindvAsmtList input:checkbox').each(function (i, o) {
                if ($(o).parent().parent().parent().css('display') != 'none') {
                    o.checked = chk;
                }
            });
        });

        // 제출 마감일 캘린더 변경
        $("#asmtSbmsnEdttmText, #calAsmtSbmsnEdttmHH, #calAsmtSbmsnEdttmMM")
            .on("change", syncOstdOpenDate);

        // 연장제출 마감일 캘린더 변경
        $("#extdSbmsnEdttmText, #calExtdSbmsnEdttmHH, #calExtdSbmsnEdttmMM")
            .on("change", syncOstdOpenDate);

        // 타학생공개 시작일시 변경
        function syncOstdOpenDate() {
            if ($("input[name='sbasmtOstdOyn']:checked").val() !== 'Y') {
                return;
            }

            var extdYn = $("input[name='extdSbmsnPrmyn']:checked").val();

            if (extdYn === 'Y') {
                // 연장제출 마감일
                copyCalendarValue(
                    "extdSbmsnEdttmText", "calExtdSbmsnEdttmHH", "calExtdSbmsnEdttmMM",
                    "ostdOpenSdttmText", "calOstdOpenSdttmHH", "calOstdOpenSdttmMM"
                );
            } else {
                // 과제제출 마감일
                copyCalendarValue(
                    "asmtSbmsnEdttmText", "calAsmtSbmsnEdttmHH", "calAsmtSbmsnEdttmMM",
                    "ostdOpenSdttmText", "calOstdOpenSdttmHH", "calOstdOpenSdttmMM"
                );
            }
        }

        // 분반 정보 조회
        getCreCrsList();

        if ("${vo.asmtId}" != "") {
            eBoolean = true;
            getAsmnt("${vo.asmtId}");
        }

        if (${not empty asmtVo.parExamCd && (asmtVo.asmtGbncd eq 'EXAM' || asmtVo.asmtGbncd eq 'SUBS')}) {
            insStdList();
        }

        $("#lctrWknoSchdlId").closest("div").css("z-index", "1000");
    });

    // 분반 정보 조회
    function getCreCrsList() {

        var data = {
            "sbjctId": "${vo.sbjctId}",
            "userId": "${vo.userId}"
        };

        ajaxCall("/asmt/profDvclasList.do", data, function (data) {
            var html = "";
            var html2 = "";

            if (data.returnList.length > 0) {

                html += "<div class='field'>";
                html += "    <div class='ui checkbox'>";
                html += "        <input type='checkbox' id='declsAll' name='dvclasList' value='ALL'";

                if (data.returnList.length == 1) {
                    html += " onclick=\"return false;\" checked";
                }

                html += ">";
                html += "        <label class='toggle_btn' for='dvclasAll'><spring:message code='user.common.search.all' /></label>";
                html += "    </div>";
                html += "</div>";

                $.each(data.returnList, function (i, o) {

                    html += "<div class='field'>";
                    html += "    <div class='ui checkbox'>";
                    html += "        <input type='checkbox' id='dvclas" + i + "' name='dvclasList' value='" + o.sbjctId + "'";

                    if ("${vo.sbjctId}" == o.sbjctId) {
                        html += " onclick=\"return false;\" checked";
                    }

                    html += ">";
                    html += "        <label class='toggle_btn' for='dvclas" + i + "'>" + o.dvclasNo + "<spring:message code='asmnt.label.decls.name' /></label>";
                    html += "    </div>";
                    html += "</div>";

                    html2 += "<div class='ui action fluid input' id='lrnGrpView" + i + "' ";

                    if ("${vo.sbjctId}" != o.sbjctId) {
                        html2 += " style= 'display: none;'";
                    }

                    html2 += ">";
                    html2 += "    <label class='ui basic small label flex-item-center m-w3 m0'>" + o.dvclasNo + "<spring:message code='asmnt.label.decls.name' /> : </label>";
                    html2 += "    <input type='hidden' id='lrnGrpId" + i + "' name='lrnGrpList'";

                    if ("${vo.sbjctId}" != o.sbjctId) {
                        html2 += " disabled='disabled'";
                    }

                    html2 += ">";
                    html2 += "    <input type='text' id='teamCtgr" + i + "' placeholder='<spring:message code="asmnt.alert.select.team.ctgr" />' readonly>";
                    html2 += "    <a class='ui black button' onclick=\"teamCtgrSelectPop('" + i + "','" + o.sbjctId + "')\"><spring:message code='bbs.label.form_assign_team' /></a>";
                    html2 += "</div>";
                });
                /* 성된 팀이 없으면 팀활동 등록 후 팀활동 팀관리 탭에서 팀을 생성해 주세요. */
                html2 += "<div class='ui small warning message'><i class='info icon'></i><spring:message code='team.alert.select.team_manage_tab' /></div>";
            }

            // 분반 목록
            $("#creCrsListView").html(html);
            $("#viewTeamAsmnt").html(html2);

            if (data.returnList.length != 1) {
                $('input:checkbox[name="dvclasList"]').on("click", function (e) {

                    if (e.target.value == 'ALL') {
                        $('input:checkbox[name="dvclasList"]').each(function () {
                            if (this.value != "${vo.sbjctId}") {
                                this.checked = $("#dvclasAll").is(":checked");
                            }
                        });
                    } else {
                        var cnt = 0;
                        $('input:checkbox[name="dvclasList"]').each(function () {
                            if (this.value != 'ALL') {
                                if (this.checked) {
                                    cnt++;
                                }
                            }
                        });

                        if (cnt == $('input:checkbox[name="dvclasList"]').length - 1) {
                            $("#dvclasAll").prop("checked", true);
                        } else {
                            $("#dvclasAll").prop("checked", false);
                        }
                    }
                });
            }

            $("input[name='dvclasList']").change(function () {
                $('input:checkbox[name="dvclasList"]').each(function (i, o) {
                    if (this.value != 'ALL') {
                        if (this.checked) {
                            $("#lrnGrpView" + (i - 1)).show();
                            $("#lrnGrpId" + (i - 1)).removeAttr("disabled");
                        } else {
                            $("#lrnGrpView" + (i - 1)).hide();
                            $("#lrnGrpId" + (i - 1)).attr("disabled", "disabled");
                        }
                    }
                });
            });
        }, function () {

        }, true);
    }

    // 과제 대상자 조회
    function getAsmntJoinUser(aCd) {
        var univGbn = "${creCrsVO.univGbn}";
        var url = "/asmt/profAsmtTrgtrSelect.do";
        var data = {
            "selectType": "LIST",
            "sbjctId": "${vo.sbjctId}",
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var html = "";
                data.returnList.forEach(function (o, i) {
                    html += "<tr>";
                    html += "    <td class='wf5'>";
                    html += "        <div class='ui checkbox'>";
                    html += "            <input type='hidden' value='" + o.userId + "'>";
                    html += "            <input type='checkbox' id='tg" + (i + 1) + "' tabindex='0' class='hidden'>";
                    html += "            <label class='toggle_btn' for='tg" + (i + 1) + "'></label>";
                    html += "        </div>";
                    html += "    </td>";
                    html += "    <td class='wf15'>" + (i + 1) + "</td>";
                    html += "    <td class='tgList'>" + o.deptNm + "</td>";
                    if (univGbn == "3" || univGbn == "4") {
                        html += "<td class='tgList'>" + (o.grscDegrCorsGbnNm || '-') + "</td>"; // TODOO
                    }
                    html += "    <td class='tgList'>" + o.userId + "</td>";
                    html += "    <td class='tgList'>" + o.userNm + "</td>";
                    html += "</tr>";

                });

                $("#indvAsmtList").empty().append(html);

                gInd = true;
                if (aCd != null) {
                    listAsmntUser(aCd);
                }
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 에러가 발생했습니다! */
            alert("<spring:message code='fail.common.msg' />");
        }, true);
    }

    // 과제 평가 참여자 리스트 조회
    function listAsmntUser(asmtId) {
        var univGbn = "${creCrsVO.univGbn}";
        var url = "/asmt/profAsmtSbmsnPtcpntSelect.do";

        var data = {
            "selectType": "LIST",
            "crsCreCd": "${vo.sbjctId}",
            "asmtId": asmtId
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var html = "";
                data.returnList.forEach(function (o, i) {
                    html += "<tr>";
                    html += "    <td class='wf5'>";
                    html += "        <div class='ui checkbox'>";
                    html += "            <input type='hidden' value='" + o.userId + "'>";
                    html += "            <input type='checkbox' id='tgr" + (i + 1) + "' tabindex='0' class='hidden'>";
                    html += "            <label class='toggle_btn' for='tgr" + (i + 1) + "'></label>";
                    html += "        </div>";
                    html += "    </td>";
                    html += "    <td class='wf15'>" + (i + 1) + "</td>";
                    html += "    <td class='tgList'>" + o.deptNm + "</td>";
                    if (univGbn == "3" || univGbn == "4") {
                        html += "<td class='tgList'>" + (o.grscDegrCorsGbnNm || '-') + "</td>";
                    }
                    html += "    <td class='tgList'>" + o.userId + "</td>";
                    html += "    <td class='tgList'>" + o.userNm + "</td>";
                    html += "</tr>";

                    $("#indvAsmtList input[value='" + o.userId + "']").parent().parent().parent().remove();

                });

                $('#indvAsmtList tr').each(function (i, o) {
                    $("#indvAsmtList tr:eq(" + i + ") td:eq(1)").text(i + 1);
                });

                $("#sindvAsmtList").empty().append(html);
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 에러가 발생했습니다! */
            alert("<spring:message code='fail.common.msg' />");
        }, true);
    }

    // 이전 과제 가져오기
    function asmntCopyList() {
        var modalId = "Ap02";
        initModal(modalId);

        var kvArr = [];
        kvArr.push({'key': 'userId', 'val': "${vo.userId}"});
        kvArr.push({'key': 'crsCreCd', 'val': "${crsCreCd}"});

        submitForm("/asmt/profAsmtCopyPopView.do", modalId + "ModalIfm", kvArr);
    }

    // 과제 복사
    function copyAsmnt(asmtId) {
        eBoolean = false;
        getAsmnt(asmtId);
    }

    // 과제 가져오기
    function getAsmnt(asmtId) {
        var url = "/asmt/profAsmtCopy.do";
        var data = {
            "selectType": "OBJECT",
            "asmtId": asmtId
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
            /* 에러가 발생했습니다! */
            alert("<spring:message code='fail.common.msg' />");
        }, true);
    }

    function setData(vo) {
        // 에디터 초기화
        editor.execCommand('selectAll');
        editor.execCommand('deleteLeft');
        editor.execCommand('insertText', "");
        // 과제명
        $("#asmtTtl").val(vo.asmtTtl);
        // 과제 내용
        editor.openHTML($.trim(vo.asmtCts));

        if (eBoolean) {
            $("input[name=asmtId]").val(vo.asmtId);
            $("input[name=prevAsmtId]").val('');
            $("#declsView").hide();

            // 제출기간
            setDataCalendar(vo.asmtSbmsnSdttm, "asmtSbmsnSdttmText", "calAsmtSbmsnSdttmHH", "calAsmtSbmsnSdttmMM");
            setDataCalendar(vo.asmtSbmsnEdttm, "asmtSbmsnEdttmText", "calAsmtSbmsnEdttmHH", "calAsmtSbmsnEdttmMM");

            // 지각제출 사용
            if (vo.extdSbmsnPrmyn == 'Y') {
                $("input:radio[name='extdSbmsnPrmyn'][value='Y']").prop('checked', true);
                setDataCalendar(vo.extdSbmsnEdttm, "extdSbmsnEdttmText", "calExtdSbmsnEdttmHH", "calExtdSbmsnEdttmMM");

                $("#viewExtdSbmsnPrm").show();
            } else {
                $("input:radio[name='extdSbmsnPrmyn'][value='N']").prop('checked', true);
                setDataCalendar(null, "extdSbmsnEdttmText", "calExtdSbmsnEdttmHH", "calExtdSbmsnEdttmMM");
                $("#viewExtdSbmsnPrm").hide();
            }

            // 팀과제
            if (vo.teamAsmtStngyn == "Y") {
                $("input:radio[name=teamAsmtStngyn][value='Y']").prop("checked", true);
                $("input:radio[name=teamAsmtStngyn]").trigger("change");
                $("#lrnGrpId0").val(vo.lrnGrpId + ":" + vo.sbjctId);
                $("#lrnGrpnm0").val(vo.lrnGrpnm);
            } else {
                $("input:radio[name=teamAsmtStngyn][value='N']").prop("checked", true);
            }

            // 과제 구분 변경 못하게
            $("input[name=teamAsmtStngyn]").attr("readonly", true);
            $("input[name=indvAsmtyn]").attr("readonly", true);

        } else {
            $("input[name=asmtId]").val('');
            $("input[name=prevAsmtId]").val(vo.asmtId);
            $("#declsView").show();

            // 제출기간
            setDataCalendar(null, "asmtSbmsnSdttmText", "calAsmtSbmsnSdttmHH", "calAsmtSbmsnEdttmMM");
            setDataCalendar(null, "asmtSbmsnEdttmText", "calAsmtSbmsnEdttmHH", "calAsmtSbmsnEdttmMM");

            // 지각제출 사용
            $("input:radio[name='extdSbmsnPrmyn'][value='N']").prop('checked', true);
            setDataCalendar(null, "extdSbmsnEdttmText", "calExtdSbmsnEdttmHH", "calExtdSbmsnEdttmMM");
            $("#viewExtdSbmsnPrm").hide();

        }

        // 성적반영여부
        if (vo.mrkRfltyn == 'Y' && vo.indvAsmtyn != "Y") {
            $("input:radio[name='mrkRfltyn'][value='Y']").prop('checked', true);
        } else {
            $("input:radio[name='mrkRfltyn'][value='N']").prop('checked', true);
        }

        // 평가방법
        if (vo.evlScrTycd == 'SCR') {
            $("input:radio[name='evlScrTycd'][value='SCR']").prop('checked', true);
        } else if (vo.evlScrTycd == 'RUBRIC_SCR') {
            $("input:radio[name='evlScrTycd'][value='RUBRIC_SCR']").prop('checked', true);
            $("#asmtEvlId").val(vo.asmtEvlId);
            $("#evalTitle").val(vo.evalTitle);
            $("#mutEvalDiv").show();
        }

        // 실기과제 & 제출형식
        $("input[name='prtcFileType']").prop("checked", false);
        $("input[name='preFile']").prop("checked", false);
        $("input[name='docFile']").prop("checked", false);
        if (vo.asmtPrctcyn == 'Y') {
            $("input:radio[name='asmtPrctcyn'][value='Y']").prop('checked', true);
            $("#viewPrtc").show();
            $("#viewSbasmtTycd").hide();

            var fArr = vo.sbmsnFileMimeTycd.split(',');
            for (var i = 0; i < fArr.length; i++) {
                $("input[name='prtcFileType'][value='" + fArr[i] + "']").prop("checked", true);
            }

        } else {
            $("input:radio[name='asmtPrctcyn'][value='N']").prop('checked', true);
            $("#viewPrtc").hide();
            $("#viewSbasmtTycd").show();

            // 제출형식 매핑
            if (vo.sbasmtTycd == 'FILE') {
                $("input:radio[name='sbasmtTycd'][value='FILE']").prop('checked', true);
                $("#viewSbasmtTycdFile").show();

                if (vo.sbmsnFileMimeTycd == '' || vo.sbmsnFileMimeTycd == null) {
                    $("#allFile").prop("checked", true);
                } else {
                    var fArr = vo.sbmsnFileMimeTycd.split(',');

                    for (var i = 0; i < fArr.length; i++) {
                        if (i == 0) {
                            if (fArr[i] == 'img' || fArr[i] == 'pdf' || fArr[i] == 'txt' || fArr[i] == 'soc' || fArr[i] == 'ppt2') {
                                $("#preFile").prop("checked", true);
                            } else if (fArr[i] == 'hwp' || fArr[i] == 'doc' || fArr[i] == 'ppt' || fArr[i] == 'xls' /*|| fArr[i] == 'pdf2' || fArr[i] == 'zip'*/) {
                                $("#docFile").prop("checked", true);
                            }
                        }

                        if (fArr[i] == 'img' || fArr[i] == 'pdf' || fArr[i] == 'txt' || fArr[i] == 'soc' || fArr[i] == 'ppt2') {
                            $("input[name='preFile'][value='" + fArr[i] + "']").prop("checked", true);
                        } else if (fArr[i] == 'hwp' || fArr[i] == 'doc' || fArr[i] == 'ppt' || fArr[i] == 'xls' /*|| fArr[i] == 'pdf2' || fArr[i] == 'zip'*/) {
                            $("input[name='docFile'][value='" + fArr[i] + "']").prop("checked", true);
                        }

                    }
                }

            } else if (vo.sbasmtTycd == 'INPUT_TEXT') {
                $("input:radio[name='sbasmtTycd'][value='INPUT_TEXT']").prop('checked', true);
                $("#viewSbasmtTycdFile").hide();
            }

            // 실시간 피드백 사용여부
            if (vo.pushAlimyn == 'Y') {
                $("input:radio[name=pushAlimyn][value='Y']").prop("checked", true);
            } else {
                $("input:radio[name=pushAlimyn][value='N']").prop("checked", true);
            }
        }

        // 개별과제
        if (eBoolean) {
            if (vo.indvAsmtyn == 'Y') {
                $("input:radio[name='indvAsmtyn'][value='Y']").prop('checked', true);
                // 개별과제 개인 매핑
                $("#viewIndAsmnt").show();
                if (!gInd) {
                    getAsmntJoinUser(vo.asmtId);
                } else {
                    listAsmntUser(vo.asmtId);
                }
            } else {
                $("#viewIndAsmnt").hide();
                $("input:radio[name='indvAsmtyn'][value='N']").prop('checked', true);
            }
        } else {
            $("#viewIndAsmnt").hide();
            $("input:radio[name='indvAsmtyn'][value='N']").prop('checked', true);
        }

        if (eBoolean) {
            // 성적 공개 여부
            if (vo.mrkOyn == 'Y') {
                $("input:radio[name='mrkOyn'][value='Y']").prop('checked', true);
            } else {
                $("input:radio[name='mrkOyn'][value='N']").prop('checked', true);
            }
            // 과제 읽기 허용
            if (vo.sbasmtOstdOyn == 'Y') {
                $("input:radio[name='sbasmtOstdOyn'][value='Y']").prop('checked', true);
                $("#viewSbasmtOstd").show();
                setDataCalendar(vo.sbasmtOstdOpenSdttm, "sbmtStartDttmText", "calOstdOpenSdttmHH", "calSbmtStartMM");
                // setDataCalendar(vo.sbasmtOstdOpenEdttm, "sbmtEndDttmText", "calOstdOpenEdttmHH", "calSbmtEndMM");
            } else {
                $("input:radio[name='sbasmtOstdOyn'][value='N']").prop('checked', true);
                $("#viewSbasmtOstd").hide();
                setDataCalendar(null, "sbmtStartDttmText", "calOstdOpenSdttmHH", "calSbmtStartMM");
                setDataCalendar(null, "sbmtEndDttmText", "calOstdOpenEdttmHH", "calSbmtEndMM");
            }

            // 상호 평가 사용
            if (vo.evlRfltyn == 'Y') {
                $("input:radio[name='evlRfltyn'][value='Y']").prop('checked', true);
                $("#viewEvalUse").show();
                setDataCalendar(vo.evlSdttm, "evalStartDttmText", "calEvalStartHH", "calEvalStartMM");
                setDataCalendar(vo.evlEdttm, "evalEndDttmText", "calEvalEndHH", "calEvalEndMM");

                if (vo.evlRsltOyn == 'Y') {
                    $("#evalRsltOpenYnCheck").prop("checked", true);
                } else {
                    $("#evalRsltOpenYnCheck").prop('checked', false);
                }
            } else {
                $("input:radio[name='evlRfltyn']:radio[value='N']").prop('checked', true);
                $("#viewEvalUse").hide();
                setDataCalendar(null, "evalStartDttmText", "calEvalStartHH", "calEvalStartMM");
                setDataCalendar(null, "evalEndDttmText", "calEvalEndHH", "calEvalEndMM");
                $("#evalRsltOpenYnCheck").prop('checked', false);
            }

            if (vo.asmtOyn == 'Y') {
                $("input:radio[name='asmtOyn'][value='Y']").prop('checked', true);
            } else {
                $("input:radio[name='asmtOyn'][value='N']").prop('checked', true);
            }
        } else {
            // 과제 읽기 허용
            $("input:radio[name='sbasmtOstdOyn'][value='N']").prop('checked', true);
            $("#viewSbasmtOstd").hide();
            setDataCalendar(null, "sbmtStartDttmText", "calOstdOpenSdttmHH", "calSbmtStartMM");
            setDataCalendar(null, "sbmtEndDttmText", "calOstdOpenEdttmHH", "calSbmtEndMM");

            // 상호 평가 사용
            $("input:radio[name='evlRfltyn']:radio[value='N']").prop('checked', true);
            $("#viewEvalUse").hide();
            setDataCalendar(null, "evalStartDttmText", "calEvalStartHH", "calEvalStartMM");
            setDataCalendar(null, "evalEndDttmText", "calEvalEndHH", "calEvalEndMM");
            $("#evalRsltOpenYnCheck").prop('checked', false);
        }

        // 팀내 상호평가 사용
        if (vo.teamEvalYn == 'Y') {
            $("#teamEvalYnCheck").prop("checked", true);
        } else {
            $("#teamEvalYnCheck").prop('checked', false);
        }

        // 가져온 첨부파일 정보
        var dx = dx5.get("upload1");
        if (dx != null) {
            dx.clearItems();

            if (vo.fileList.length > 0) {
                var oldFiles = [];

                vo.fileList.forEach(function (v, i) {
                    oldFiles.push({vindex: v.fileId, name: v.fileNm, size: v.fileSize, saveNm: v.fileSaveNm});
                });

                dx.addOldFileList(oldFiles);
                dx.showResetBtn();
            }
        }
    }

    // 저장 확인
    function saveConfirm() {
        if (validation()) {
            // 파일이 있으면 업로드 시작
            var dx = dx5.get("upload1");
            if (dx.availUpload()) {
                dx.startUpload();
            } else {
                // 저장 호출
                save();
            }
        }
    }

    // 필수값 확인 및 값 적용
    function validation() {

        // 과제명
        var asmtTtl = $("input[name=asmtTtl]").val();
        if (asmtTtl == null || asmtTtl == '') {

            /* 과제명을 입력하세요. */
            alert("<spring:message code='asmnt.alert.input.asmnt_title' />");
            return false;
        }
        // 제출기간
        if (calendarComparison("<spring:message code='asmnt.label.send.date' />"
            , $("#asmtSbmsnSdttmText").val()
            , $("#calAsmtSbmsnSdttmHH").val()
            , $("#calAsmtSbmsnEdttmMM").val()
            , $("#asmtSbmsnEdttmText").val()
            , $("#calAsmtSbmsnEdttmHH").val()
            , $("#calAsmtSbmsnEdttmMM").val()
        )) {
            return false;
        }

        // 제출형식
        if ($("input:radio[name='asmtPrctcyn']:checked").val() == 'Y') {
            if ($("input:checkbox[name=prtcFileType]:checked").length < 1) {

                /* 실기과제 파일형식을 선택하세요. */
                alert("<spring:message code='asmnt.label.prtc.filetype.select' />");
                return false;
            }
        } else {
            if ($("input:radio[name=sbasmtTycd]:checked").length == 0) {

                /* 제출형식을 선택하세요. */
                alert("<spring:message code='asmnt.label.filetype.select' />");
                return false;
            }

            if ($("input:radio[name=sbasmtTycd]:checked").val() == 'FILE') {
                if ($('input:radio[name=sbmsnFileMimeTycd]:checked').val() != 'all') {
                    if ($("input:checkbox[name=preFile]:checked").length + $("input:checkbox[name=docFile]:checked").length < 1) {

                        /* 파일 제출형식을 선택하세요. */
                        alert("<spring:message code='file.label.filetype.select' />");
                        return false;
                    }
                }
            }
        }

        // 팀 과제 여부
        if ($("input[name='teamAsmtStngyn']:checked").val() == 'Y') {
            var checkTeamCtgr = true;
            $('input:checkbox[name="dvclasList"]').each(function (i, o) {
                if (this.value != 'ALL') {
                    if (this.checked) {
                        if ($("#lrnGrpId" + (i - 1)).val() == null || $("#lrnGrpId" + (i - 1)).val() == '') {
                            checkTeamCtgr = false;

                            return false;
                        }
                    } else {
                        // 값 초기화
                        $("#lrnGrpId" + (i - 1)).val("");
                    }
                }
            });

            if (!checkTeamCtgr) {
                /* 팀 분류를 선택하세요. */
                alert("<spring:message code='forum.label.selected' />");
                return false;
            }
        }

        // 개별과제 여부
        if ($("input[name='indvAsmtyn']:checked").val() == 'Y') {
            if ($('#sindvAsmtList tr').length < 1) {

                /* 개별과제 대상자를 선택하시기 바랍니다. */
                alert("<spring:message code='asmnt.label.ezg.noselect.user' />");
                return false;
            }
        }

        // 지각제출사용
        if ($("input:radio[name=extdSbmsnPrmyn]:checked").val() == 'Y') {
            if (calendarCheck("<spring:message code='asmnt.label.late.send.deadline' />"
                , $("#extdSbmsnEdttmText").val()
                , $("#calExtdSbmsnEdttmHH").val()
                , $("#calExtdSbmsnEdttmMM").val()
            )) {
                return false;
            }

            var sendEndDttmCheck = (($("#asmtSbmsnEdttmText").val() || "") + ($("#calAsmtSbmsnEdttmHH").val() || "") + ($("#calAsmtSbmsnEdttmMM").val() || "")).replaceAll(".", "");
            var extSendDttmCheck = (($("#extdSbmsnEdttmText").val() || "") + ($("#calExtdSbmsnEdttmHH").val() || "") + ($("#calExtdSbmsnEdttmMM").val() || "")).replaceAll(".", "");

            if (sendEndDttmCheck.length == 12 && extSendDttmCheck.length == 12) {
                if (sendEndDttmCheck >= extSendDttmCheck) {
                    alert("<spring:message code='asmnt.alert.invalid.ext.send.dttm' />"); // 지각제출 종료일은 과제 종료일보다 크게 입력하세요.
                    return false;
                }
            }
        }

        // 종합성적 산출
        // 지각제출 주석이 이상하게 돼서 일단 삭제

        // 평가방법 - 루브릭
        if ($("input:radio[name=evlScrTycd]:checked").val() == 'RUBRIC_SCR' && !$("#asmtEvlId").val()) {
            alert("<spring:message code='asmnt.alert.empty.rubric' />"); // 평가방법 루브릭을 설정하세요.
            return false;
        }


        // 과제 읽기 허용
        if ($("input:radio[name=sbasmtOstdOyn]:checked").val() == 'Y') {
            if (calendarCheck("<spring:message code='asmnt.label.read.start' />"
                , $("#ostdOpenSdttmText").val()
                , $("#calOstdOpenSdttmHH").val()
                , $("#calSbmtStartMM").val()
            )) {
                return false;
            }
            <%--if (calendarCheck("<spring:message code='asmnt.label.read.end' />"--%>
            <%--    , $("#sbmtEndDttmText").val()--%>
            <%--    , $("#calOstdOpenEdttmHH").val()--%>
            <%--    , $("#calSbmtEndMM").val()--%>
            <%--)) {--%>
            <%--    return false;--%>
            <%--}--%>
        }


        // 상호 평가 사용 -> 상호평가 사용 X
        var evalUse = $("input:radio[name=evlRfltyn]:checked").val();
        if (evalUse == 'Y') {
            if ($("input:radio[name=sbasmtOstdOyn]:checked").val() != 'Y') {
                alert("<spring:message code='asmnt.alert.check.submit.open.y.eval.use' />"); // 상호평가 사용시, 과제읽기 허용여부 [예]로 설정하세요.
                return false;
            }
            // 제출기간
            if (calendarComparison("<spring:message code='forum.label.mut.eval' />"
                , $("#evalStartDttmText").val()
                , $("#calEvalStartHH").val()
                , $("#calEvalStartMM").val()
                , $("#evalEndDttmText").val()
                , $("#calEvalEndHH").val()
                , $("#calEvalEndMM").val()
            )) {
                return false;
            }

            var sbasmtOstdOpenSdttm = $("#sbmtStartDttmText").val().replaceAll(".", "") + $("#calOstdOpenSdttmHH").val() + $("#calSbmtStartMM").val();
            // var sbasmtOstdOpenEdttm = $("#sbmtEndDttmText").val().replaceAll(".", "") + $("#calOstdOpenEdttmHH").val() + $("#calSbmtEndMM").val();

            var evlSdttm = $("#evalStartDttmText").val().replaceAll(".", "") + $("#calEvalStartHH").val() + $("#calEvalStartMM").val();
            var evlEdttm = $("#evalEndDttmText").val().replaceAll(".", "") + $("#calEvalEndHH").val() + $("#calEvalEndMM").val();

            if (sbasmtOstdOpenSdttm > evlSdttm || sbasmtOstdOpenEdttm < evlEdttm) {
                alert("<spring:message code='asmnt.alert.check.submit.open.y.eval.dttm' />"); // 상호평가 사용시, 과제읽기 허용여부 [예]로 설정하세요.
                return false;
            }

            if ($("#evalRsltOpenYnCheck").is(":checked")) {
                $("input[name='evlRsltOyn']").val("Y");
            } else {
                $("input[name='evlRsltOyn']").val("N");
            }
        }


        // 팀내 상호평가 사용
        if ($("#teamEvalYnCheck").is(":checked")) {
            // 팀과제 여부체크
            if ($("input[name='teamAsmtStngyn']:checked").val() != 'Y') {
                alert("<spring:message code='asmnt.alert.unable.team.eval' />"); // 팀내 상호평가는 팀과제일경우 가능합니다.
                return false;
            }

            $("input[name='teamEvalYn']").val("Y");
        } else {
            $("input[name='teamEvalYn']").val("N");
        }
        return true;
    }

    // 저장
    function save() {
        var dx = dx5.get("upload1");
        var url = "";

        if (eBoolean) {
            url = "/asmt/profAsmtModify.do";
        } else {
            url = "/asmt/profAsmtRegist.do";
        }

        /** 과제 구분
         - 과제
         - 과제 팀
         - 실기과제
         - 실기과제 팀
         - 개별과제
         - 중간고사 대체
         - 기말고사 대체
         */
        var fixedAsmtGbncd = "${asmtVo.asmtGbncd}";
        /* 예외 과제 : 서버 값 고정 */
        if (['EXAM_SBST', 'ABSNCE_SBST', 'MID_EXAM_SBST_ASMT', 'LST_EXAM_SBST_ASMT'].includes(fixedAsmtGbncd)) {
            if ($("input[name='indvAsmtyn']:checked").val() === 'Y') {
                setIndividualAsmtList();
            }
            $("input[name='asmtGbncd']").val(fixedAsmtGbncd);
            return;
        }
        var isTeamAsmtStng = $("input[name='teamAsmtStngyn']:checked").val() === 'Y';
        var isIndvAsmt = $("input[name='indvAsmtyn']:checked").val() === 'Y';
        var isAsmtPrctc = $("input[name='asmtPrctcyn']:checked").val() === 'Y';

        var asmtGbncd = "";

        /* 개별과제 */
        if (isIndvAsmt) {
            asmtGbncd = "INDV_ASMT";
            setIndividualAsmtList();

            /* 실기과제 */
        } else if (isAsmtPrctc) {
            asmtGbncd = isTeamAsmtStng ? "PRCTC_ASMT_TEAM" : "PRCTC_ASMT";
            $("input:radio[name='sbasmtTycd'][value='FILE']").prop('checked', true);

            /* 일반과제 */
        } else {
            asmtGbncd = isTeamAsmtStng ? "ASMT_TEAM" : "ASMT";
        }

        $("input[name='asmtGbncd']").val(asmtGbncd);

        /* 개별과제 리스트 처리 */
        function setIndividualAsmtList() {
            var indvAsmtList = [];

            $('#sindvAsmtList tr').each(function (i) {
                indvAsmtList.push(
                    $("#sindvAsmtList tr:eq(" + i + ") input:eq(0)").val()
                )
            });

            $("input[name='indvAsmtList']").val(indvAsmtList.join(','));
        }

        var sFileType = "";
        if ($("input:radio[name='asmtPrctcyn']:checked").val() == 'Y') {
            for (var i = 0; i < $('input:checkbox[name="prtcFileType"]:checked').length; i++) {
                if (i > 0) sFileType += ',';
                sFileType += $('input:checkbox[name="prtcFileType"]:checked').eq(i).val();
            }
            //$("input[name='sbasmtTycd']").attr("checked",false)
        } else {
            if ($("input:radio[name=sbasmtTycd]:checked").val() == 'FILE') {
                var sft = $('input:radio[name=sbmsnFileMimeTycd]:checked').val();

                if (sft == "pre") {
                    for (var i = 0; i < $('input:checkbox[name="preFile"]:checked').length; i++) {
                        if (i > 0) sFileType += ',';
                        sFileType += $('input:checkbox[name="preFile"]:checked').eq(i).val();
                    }
                } else if (sft == "doc") {
                    for (var i = 0; i < $('input:checkbox[name="docFile"]:checked').length; i++) {
                        if (i > 0) sFileType += ',';
                        sFileType += $('input:checkbox[name="docFile"]:checked').eq(i).val();
                    }
                }
            }
        }

        $("input[name='sbmsnFileMimeTycd']").val(sFileType);
        $("input[name='copyFiles']").val(dx.getCopyFiles());
        $("input[name='delFileIdStr']").val(dx.getDelFileIdStr());
        $("input[name='uploadPath']").val(dx.getUploadPath());

        // 제출기간
        $("input[name=asmtSbmsnSdttm]").val($("#asmtSbmsnSdttmText").val().replaceAll('.', '-') + ' ' + $("#calAsmtSbmsnSdttmHH").val() + ':' + $("#calAsmtSbmsnSdttmMM").val());
        $("input[name=asmtSbmsnEdttm]").val(setDateEndDttm($("#asmtSbmsnEdttmText").val().replaceAll('.', '-') + ' ' + $("#calAsmtSbmsnEdttmHH").val() + ':' + $("#calAsmtSbmsnEdttmMM").val(), ":"));

        // 지각제출사용
        if ($("input:radio[name=extdSbmsnPrmyn]:checked").val() == 'Y') {
            // 시작일은 과제제출종료일시
            $("input[name=extdSbmsnSdttm]").val(setDateEndDttm($("#asmtSbmsnEdttmText").val().replaceAll('.', '-') + ' ' + $("#calAsmtSbmsnEdttmHH").val() + ':' + $("#calAsmtSbmsnEdttmMM").val(), ":"));
            $("input[name=extdSbmsnEdttm]").val(setDateEndDttm($("#extdSbmsnEdttmText").val().replaceAll('.', '-') + ' ' + $("#calExtdSbmsnEdttmHH").val() + ':' + $("#calExtdSbmsnEdttmMM").val(), ":"));
        }

        /*
        - 제출과제타학생공개기간
            - 연장제출허용이 ‘Y’일 때 연장제출 마감일로 셋팅
            - 연장제출하용이 ‘N’일 때 제출마감일로 셋팅
         */
        // 제출과제타학생공개여부
        if ($("input:radio[name=sbasmtOstdOyn]:checked").val() == 'Y') {

            $("input[name=sbasmtOstdOpenSdttm]").val($("#ostdOpenSdttmText").val().replaceAll('.', '-') + ' ' + $("#calOstdOpenSdttmHH").val() + ':' + $("#calOstdOpenSdttmMM").val());
            $("input[name=sbasmtOstdOpenEdttm]").val("9999-12-31 23:59");   // 제출과제타학생공개 종료일은 따로 없음
        }

        // 상호 평가 사용
        /*if ($("input:radio[name=evlRfltyn]:checked").val() == 'Y') {
            $("input[name=evlSdttm]").val($("#evalStartDttmText").val().replaceAll('.', '-') + ' ' + $("#calEvalStartHH").val() + ':' + $("#calEvalStartMM").val());
            $("input[name=evlEdttm]").val(setDateEndDttm($("#evalEndDttmText").val().replaceAll('.', '-') + ' ' + $("#calEvalEndHH").val() + ':' + $("#calEvalEndMM").val(), ":"));
        }*/

        $.ajaxSettings.traditional = true;
        ajaxCall(url, $("#asmntWriteForm").serialize(), function (data) {
            if (data.result > 0) {
                if (eBoolean) {
                    /* 수정하였습니다. */
                    alert("<spring:message code='common.modify.success' />");
                } else {
                    /* 저장하였습니다. */
                    alert("<spring:message code='common.alert.ok.save' />");
                }
                viewAsmntList();
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 삭제 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
            alert("<spring:message code='seminar.error.delete' />");
        }, true);
    }

    // 목록
    function viewAsmntList() {
        var kvArr = [];
        kvArr.push({'key': 'sbjctId', 'val': "${vo.sbjctId}"});

        submitForm("/asmt/profAsmtListView.do", "", kvArr);
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
                $("input[name='uploadFiles']").val(dx.getUploadFiles());
                $("input[name='uploadPath']").val(dx.getUploadPath());

                save();
            } else {
                alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
        });
    }

    // 팀 지정 팝업
    function teamCtgrSelectPop(i, sbjctId) {
        var modalId = "Ap05";
        initModal(modalId);

        var kvArr = [];
        kvArr.push({'key': 'sbjctId', 'val': sbjctId});
        kvArr.push({'key': 'searchFrom', 'val': i + ":" + sbjctId});

        submitForm("/team/teamHome/teamCtgrSelectPop.do", modalId + "ModalIfm", kvArr);
    }

    // 팀 분류 선택
    function selectTeam(lrnGrpId, teamCtgrNm, id) {
        var idList = id.split(':');
        $("#lrnGrpId" + idList[0]).val(lrnGrpId + ":" + idList[1]);
        $("#teamCtgr" + idList[0]).val(teamCtgrNm);
    }

    // 개별과제여부 수강생목록 검색
    function indiSearch(type) {
        if (type == 'T') {
            $('#tg0').prop("checked", false);
            $('#indvAsmtList input:checkbox').prop("checked", false);
            $('#indvAsmtList tr').show();
            if ($('#tgSearch').val() != '') {
                $('#indvAsmtList tr').not($("#indvAsmtList .tgList:contains('" + $('#tgSearch').val() + "')").parent()).hide();
            }
        } else if (type == 'S') {
            $('#stg0').prop("checked", false);
            $('#sindvAsmtList input:checkbox').prop("checked", false);
            $('#sindvAsmtList tr').show();
            if ($('#stgSearch').val() != '') {
                $('#sindvAsmtList tr').not($("#sindvAsmtList .tgList:contains('" + $('#stgSearch').val() + "')").parent()).hide();
            }
        }
    }

    // 평가 기준 등록 팝업
    function mutEvalWritePop(type) {
        var asmtEvlId = "";
        if (type == 'edit') {
            asmtEvlId = $("#asmtEvlId").val();
            if (asmtEvlId == "") {
                /* 수정할 평가기준이 없습니다. */
                alert("<spring:message code='forum.alert.evalCd.del' />");
                return false;
            }
        }

        var modalId = "Ap01";
        initModal(modalId);

        var kvArr = [];
        kvArr.push({'key': 'sbjctId', 'val': "${vo.sbjctId}"});
        kvArr.push({'key': 'asmtEvlId', 'val': asmtEvlId});

        submitForm("/mut/mutPop/mutEvalWritePop.do", modalId + "ModalIfm", kvArr);
    }

    // 평가 기준 등록
    function mutEvalWrite(asmtEvlId, evalTitle) {
        $("#asmtEvlId").val(asmtEvlId);
        $("#evalTitle").val(evalTitle);
    }

    // 평가기준 삭제
    function deleteMut() {
        var asmtEvlId = $("#asmtEvlId").val();
        if (asmtEvlId == "") {
            /* 삭제할 평가기준이 없습니다. */
            alert("<spring:message code='forum.alert.evalCd.del' />");
            return false;
        }

        /* 삭제 하시겠습니까? */
        if (window.confirm("<spring:message code='seminar.confirm.delete' />")) {
            var url = "/mut/mutHome/edtDelYn.do";
            var data = {
                "asmtEvlId": asmtEvlId
                , "delYn": 'Y'
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    $("#asmtEvlId").val("");
                    $("#evalTitle").val("");

                    /* 정상적으로 삭제되었습니다. */
                    alert("<spring:message code='success.common.delete'/>");

                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                /* 삭제 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
                alert("<spring:message code='seminar.error.delete' />");
            }, true);
        }
    }

    // 대체평가 대상자 설정 팝업
    function examInsTargetPop(examCd) {
        var endDate = new Date("${fn:substring(asmtVo.parExamEndDttm, 0, 4)}", parseInt("${fn:substring(asmtVo.parExamEndDttm, 4, 6)}") - 2, "${fn:substring(asmtVo.parExamEndDttm, 6, 8)}");
        endDate.setDate(endDate.getDate() + 1);
        var year = endDate.getFullYear();
        var month = ("" + endDate.getMonth()).length == 1 ? "0" + endDate.getMonth() : endDate.getMonth();
        var day = endDate.getDate();
        var date = year + "" + month + "" + day + "07";
        if (date > "${fn:substring(today, 0, 10)}") {
            alert("<spring:message code='exam.alert.exam.applicate.not.date' />");/* 실시간시험일 익일 7시 이후 설정가능합니다. */
        } else {
            var modalId = "Ap15";
            initModal(modalId);

            var kvArr = [];
            kvArr.push({'key': 'examCd', 'val': examCd});
            kvArr.push({'key': 'crsCreCd', 'val': "${asmtVo.crsCreCd}"});

            submitForm("/exam/examInsTargetPop.do", modalId + "ModalIfm", kvArr);
        }
    }

    // 대체평가 대상자 선택 취소
    function examInsTargetCancel(examCd) {
        var userIds = "";
        $("#stdTbody input[name=evalChk]:checked").each(function (i, v) {
            if (i > 0) userIds += ",";
            userIds += $(v).attr("data-userId");
        });

        if (userIds == "") {
            alert("<spring:message code='common.alert.select.student' />");/* 학습자를 선택하세요. */
            return false;
        }

        var url = "/exam/insTargetCancelByStdNos.do";
        var data = {
            "examCd": "${asmtVo.parExamCd}",
            "userIds": userIds
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                alert("<spring:message code='exam.alert.delete' />");/* 정상 삭제 되었습니다. */
                insStdList();
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 삭제 중 에러가 발생하였습니다. */
            alert("<spring:message code='exam.error.delete' />");
        }, true);
    }

    // 대체평가 대상자 목록
    function insStdList() {
        var url = "/exam/listInsTraget.do";
        var data = {
            "examCd": "${asmtVo.parExamCd}",
            "crsCreCd": '${asmtVo.crsCreCd}',
            "searchType": "submit"
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnList = data.returnList || [];
                var html = "";

                if (returnList.length > 0) {
                    returnList.forEach(function (v, i) {
                        var absentNm = v.absentNm;
                        if (v.absentNm == "APPROVE") absentNm = "<spring:message code='exam.label.approve' />";/* 승인 */
                        if (v.absentNm == "APPLICATE") absentNm = "<spring:message code='exam.label.applicate' />";/* 신청 */
                        if (v.absentNm == "RAPPLICATE") absentNm = "<spring:message code='exam.label.rapplicate' />";/* 재신청 */
                        if (v.absentNm == "COMPANION") absentNm = "<spring:message code='exam.label.companion' />";/* 반려 */
                        html += "<tr>";
                        html += "	<td class='tc'>";
                        html += "		<div class='ui checkbox'>";
                        html += "			<input type='checkbox' name='evalChk' id='evalChk" + i + "' data-userId='" + v.userId + "' user_id='" + v.userId + "' user_nm='" + v.userNm + "' mobile='" + v.mobileNo + "' email='" + v.email + "' onchange='checkStd(this)'>";
                        html += "			<label class='toggle_btn' for='evalChk" + i + "'></label>";
                        html += "		</div>";
                        html += "	</td>";
                        html += "	<td>" + v.lineNo + "</td>";
                        html += "	<td>" + v.deptNm + "</td>";
                        html += "	<td>" + v.userId + "</td>";
                        html += "	<td>" + v.userNm + "</td>";
                        html += "	<td>" + v.stareYn + "</td>";
                        html += "	<td>" + v.absentYn + "</td>";
                        html += "	<td>" + absentNm + "</td>";
                        html += "	<td><button type='button' class='ui basic small button' onclick='removeReStare(\"" + v.userId + "\")'>삭제</button></td>";
                        html += "</tr>";
                    });
                }

                $("#stdTbody").empty().html(html);
                $("#stdTable").footable();
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 리스트 조회 중 에러가 발생하였습니다. */
            alert("<spring:message code='exam.error.list' />");
        }, true);
    }

    // 대체평가 대상자 삭제
    function removeReStare(userId) {
        var url = "/exam/insTargetCancel.do";
        var data = {
            "examCd": "${asmtVo.parExamCd}",
            "userId": userId
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                alert("<spring:message code='exam.alert.delete' />");/* 정상 삭제 되었습니다. */
                insStdList();
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 삭제 중 에러가 발생하였습니다. */
            alert("<spring:message code='exam.error.delete' />");
        }, true);
    }

    // 체크박스
    function checkStd(obj) {
        if (obj.value == "all") {
            $("input[name=evalChk]").prop("checked", obj.checked);
        } else {
            $("#evalChkAll").prop("checked", $("input[name=evalChk]").length == $("input[name=evalChk]:checked").length);
        }
    }

    // 메세지 보내기
    function sendMsg(type) {
        var rcvUserInfoStr = "";
        var sbmsnCnt = 0;

        $.each($('#stdTbody').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function () {
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
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
<div id="wrap" class="pusher">

    <!-- class_top 인클루드  -->
    <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>

    <div id="container">

        <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>

        <!-- 본문 content 부분 -->
        <div class="content stu_section">
            <%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>

            <%--                        <form:form id="asmntWriteForm" name="asmntWriteForm" method="post" action="" modelAttribute="asmtVO"--%>
            <form id="asmntWriteForm" name="asmntWriteForm" method="post" action=""
                  onsubmit="saveConfirm(); return false;">
                <input type="hidden" name="asmtId">
                <input type="hidden" name="newAsmtId" value="${vo.newAsmtId}">
                <input type="hidden" name="prevAsmtId">
                <input type="hidden" name="asmtGbncd">
                <input type="hidden" name="indvAsmtList">
                <input type="hidden" name="sbjctId" value="${vo.sbjctId}">
                <input type="hidden" name="sbfileMimeTycd">
                <input type="hidden" name="repoCd" value="ASMNT">
                <input type="hidden" name="uploadPath"/>
                <input type="hidden" name="uploadFiles">
                <input type="hidden" name="delFileIdStr"/>
                <input type="hidden" name="copyFiles">
                <input type="hidden" name="asmtSbmsnSdttm">
                <input type="hidden" name="asmtSbmsnEdttm">
                <input type="hidden" name="sbasmtOstdOpenSdttm">
                <input type="hidden" name="sbasmtOstdOpenEdttm">
                <input type="hidden" name="extdSbmsnSdttm">
                <input type="hidden" name="extdSbmsnEdttm">
                <input type="hidden" name="evlSdttm">
                <input type="hidden" name="evlEdttm">

                <div class="ui form">
                    <div class="layout2">

                        <script>
                            $(document).ready(function () {
                                // set location
                                setLocationBar('<spring:message code='asmnt.label.asmnt'/>', '<spring:message code='asmnt.button.asmnt.add'/>');
                            });
                        </script>

                        <div id="info-item-box">
                            <h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code='asmnt.button.asmnt.add'/>
                            </h2>
                            <div class="button-area">
                                <a href="javascript:saveConfirm();" class="ui blue button">
                                    <spring:message code='asmnt.button.save'/><!-- 저장 --></a>
                                <a href="javascript:asmntCopyList();" class="ui basic button">
                                    <spring:message code='asmnt.button.asmnt.prev'/><!-- 이전 과제 가져오기 --></a>
                                <a href="javascript:viewAsmntList();" class="ui basic button">
                                    <spring:message code='asmnt.button.list'/><!-- 목록 --></a>
                            </div>
                        </div>


                        <div class="row">
                            <div class="col">

                                <div class="ui segment">

                                    <ul class="tbl border-top-grey">
                                        <%--<li>
                                            <dl>
                                                <dt>
                                                    <label for="lctrWknoSchdlId">
                                                        <spring:message code="common.week"/><!-- 주차 -->
                                                    </label>
                                                </dt>
                                                <dd>
                                                    <select class="ui dropdown w300" id="lctrWknoSchdlId"
                                                            name="lctrWknoSchdlId">
                                                        <option value="DEFALUT">
                                                            <spring:message code="common.week"/><!-- 주차 -->
                                                            <spring:message code="common.button.choice"/><!-- 선택 --></option>
                                                        <c:forEach var="item" items="${lessonScheduleList}"
                                                                   varStatus="status">
                                                            <option value="${item.lctrWknoSchdlId}"
                                                                    <c:choose>
                                                                        <c:when test="${not empty asmtVo.asmtId}">
                                                                            <c:if test="${asmtVo.lctrWknoSchdlId eq item.lctrWknoSchdlId}">selected</c:if>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <c:if test="${vo.lctrWknoSchdlId eq item.lctrWknoSchdlId}">selected</c:if>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                            >${item.lessonScheduleNm}</option>
                                                        </c:forEach>
                                                    </select>
                                                </dd>
                                            </dl>
                                        </li>--%>
                                        <li>
                                            <dl>
                                                <dt>
                                                    <label for="subjectLabel" class="req">
                                                        <spring:message code="asmnt.label.asmnt.title"/><!-- 과제명 -->
                                                    </label>
                                                </dt>
                                                <dd>
                                                    <div class="ui fluid input">
                                                        <input type="text" id="asmtTtl" name="asmtTtl">
                                                    </div>
                                                </dd>
                                            </dl>
                                        </li>
                                        <li>
                                            <dl>
                                                <dt>
                                                    <label for="contentTextArea" class="req">
                                                        <spring:message code='asmnt.label.asmnt.content'/><!-- 과제 내용 -->
                                                    </label>
                                                </dt>
                                                <dd style="height:400px">
                                                    <div style="height:100%">
                                                        <textarea name="asmtCts" id="asmtCts"></textarea>
                                                        <script>
                                                            // html 에디터 생성
                                                            var editor = HtmlEditor('asmtCts', THEME_MODE, "/asmt");
                                                        </script>
                                                    </div>
                                                </dd>
                                            </dl>
                                        </li>
                                        <li id="declsView">
                                            <dl>
                                                <dt>
                                                    <label>
                                                        <spring:message code='asmnt.label.grp.crs.all'/><!-- 분반 일괄 등록 -->
                                                    </label>
                                                </dt>
                                                <dd>
                                                    <div class="fields" id="creCrsListView">
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
                                                            <uiex:ui-calendar dateId="asmtSbmsnSdttmText"
                                                                              hourId="calAsmtSbmsnSdttmHH"
                                                                              minId="calAsmtSbmsnSdttmMM"
                                                                              rangeType="start"
                                                                              rangeTarget="asmtSbmsnEdttmText"/>
                                                        </div>
                                                        <div class="field p0 flex-item desktop-elem">~</div>
                                                        <div class="field flex">
                                                            <!-- 종료일시 -->
                                                            <uiex:ui-calendar dateId="asmtSbmsnEdttmText"
                                                                              hourId="calAsmtSbmsnEdttmHH"
                                                                              minId="calAsmtSbmsnEdttmMM"
                                                                              rangeType="end"
                                                                              rangeTarget="asmtSbmsnSdttmText"/>
                                                        </div>
                                                    </div>
                                                </dd>
                                            </dl>
                                        </li>
                                        <li>
                                            <dl>
                                                <dt><label class="req"><spring:message
                                                        code="resh.label.score.aply"/></label></dt><!-- 성적 반영 -->
                                                <dd>
                                                    <div class="fields">
                                                        <div class="field">
                                                            <div class="ui radio checkbox">
                                                                <input type="radio" id="mrkRfltY" name="mrkRfltyn"
                                                                       tabindex="0" class="hidden" value="Y" checked>
                                                                <label for="mrkRfltY"><spring:message
                                                                        code="asmnt.common.yes"/></label><!-- 예 -->
                                                            </div>
                                                        </div>
                                                        <div class="field">
                                                            <div class="ui radio checkbox">
                                                                <input type="radio" id="mrkRfltN" name="mrkRfltyn"
                                                                       tabindex="0" class="hidden" value="N">
                                                                <label for="mrkRfltN"><spring:message
                                                                        code="asmnt.common.no"/></label><!-- 아니오 -->
                                                            </div>
                                                        </div>
                                                    </div>

                                                </dd>
                                            </dl>
                                        </li>
                                        <li>
                                            <dl>
                                                <dt><label><spring:message code="resh.label.score.open"/></label></dt>
                                                <!-- 성적 공개 -->
                                                <dd>
                                                    <div class="fields">
                                                        <div class="field">
                                                            <div class="ui radio checkbox">
                                                                <input type="radio" id="mrkOynY" name="mrkOyn"
                                                                       tabindex="0" class="hidden" value="Y">
                                                                <label for="mrkOynY"><spring:message
                                                                        code="asmnt.common.yes"/></label><!-- 예 -->
                                                            </div>
                                                        </div>
                                                        <div class="field">
                                                            <div class="ui radio checkbox">
                                                                <input type="radio" id="mrkOynN" name="mrkOyn"
                                                                       tabindex="0" class="hidden" value="N" checked>
                                                                <label for="mrkOynN"><spring:message
                                                                        code="asmnt.common.no"/></label><!-- 아니오 -->
                                                            </div>
                                                        </div>
                                                    </div>
                                                </dd>
                                            </dl>
                                        </li>
                                        <li>
                                            <dl>
                                                <dt><label>
                                                    <spring:message code="common.label.submit.lateness" /><!-- 지각제출 --></label>
                                                </dt>
                                                <dd>
                                                    <div class="fields">
                                                        <div class="field">
                                                            <div class="ui radio checkbox">
                                                                <input type="radio" id="extdSbmsnPrmY"
                                                                       name="extdSbmsnPrmyn" tabindex="0" class="hidden"
                                                                       value="Y">
                                                                <label for="extdSbmsnPrmY"><spring:message
                                                                        code="asmnt.common.yes"/></label><!-- 예 -->
                                                            </div>
                                                        </div>
                                                        <div class="field">
                                                            <div class="ui radio checkbox">
                                                                <input type="radio" id="extdSbmsnPrmN"
                                                                       name="extdSbmsnPrmyn" tabindex="0" class="hidden"
                                                                       value="N" checked>
                                                                <label for="extdSbmsnPrmN"><spring:message
                                                                        code="asmnt.common.no"/></label><!-- 아니오 -->
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="ui segment bcLgrey9" id="viewExtdSbmsnPrm">
                                                        <div class="fields">
                                                            <div class="inline field">
                                                                <label for="dateLabel"><spring:message
                                                                        code="forum.label.extEndDttm"/></label>
                                                                <!-- 제출 마감일 -->
                                                                <div class="equal width fields mb0">
                                                                    <div class="field flex">
                                                                        <uiex:ui-calendar dateId="extdSbmsnEdttmText"
                                                                                          hourId="calExtdSbmsnEdttmHH"
                                                                                          minId="calExtdSbmsnEdttmMM"
                                                                                          value=""/>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="ui small warning message"><i class="info icon"></i>
                                                        <spring:message code="asmnt.label.ext.send.info" /><!-- 제출기간 이후 지각 제출 허용시 설정 -->
                                                    </div>

                                                </dd>
                                            </dl>
                                        </li>
                                        <li>
                                            <dl>
                                                <dt><label class="req">
                                                    <spring:message code="crs.label.eval_method" /><!-- 평가 방법 --></label>
                                                </dt>
                                                <dd>
                                                    <div class="fields">
                                                        <div class="field">
                                                            <div class="ui radio checkbox">
                                                                <input type="radio" id="evlScrTycdS" name="evlScrTycd"
                                                                       value="SCR" tabindex="0" class="hidden" checked>
                                                                <label for="evlScrTycdS">
                                                                    <spring:message code="forum.label.evalctgr.score" /><!-- 점수형 --></label>
                                                            </div>
                                                        </div>
                                                        <div class="field">
                                                            <div class="ui radio checkbox">
                                                                <input type="radio" id="evlScrTycdR" name="evlScrTycd"
                                                                       value="RUBRIC_SCR" tabindex="0" class="hidden">
                                                                <label for="evlScrTycdR">
                                                                    <spring:message code="forum.label.evalctgr.rubric" /><!-- 루브릭 --></label>
                                                            </div>
                                                        </div>
                                                        <div class="field" id="mutEvalDiv">
                                                            <div class="ui action input search-box mr5">
                                                                <input type="hidden" name="asmtEvlId" id="asmtEvlId"/>
                                                                <input type="text" name="evalTitle" id="evalTitle">
                                                                <button type="button" class="ui icon button"
                                                                        onclick="mutEvalWritePop('new');"
                                                                        title="<spring:message code="asmnt.label.rubric.reg" />">
                                                                    <i class="pencil alternate icon"></i></button>
                                                                <button type="button" class="ui icon button"
                                                                        onclick="mutEvalWritePop('edit');"
                                                                        title="<spring:message code="asmnt.label.rubric.edit" />">
                                                                    <i class="edit icon"></i></button>
                                                                <button type="button" class="ui icon button"
                                                                        onclick="deleteMut();"
                                                                        title="<spring:message code="asmnt.label.rubric.del" />">
                                                                    <i class="trash icon"></i></button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="ui small warning message"><i
                                                            class="info icon"></i><spring:message
                                                            code="forum.label.evalctgr.rubric.info"/></div>
                                                    <!-- 루브릭 선택시 루브릭 설정 팝업이 활성화 됩니다. -->
                                                </dd>
                                            </dl>
                                        </li>

                                        <li id="viewSbasmtTycd">
                                            <dl>
                                                <dt><label class="req">
                                                    <spring:message code="asmnt.label.asmnt.send.type" /><!-- 제출형식 --></label>
                                                </dt>
                                                <dd>
                                                    <div class="fields">
                                                        <div class="field">
                                                            <div class="ui radio checkbox">
                                                                <input type="radio" id="sbasmtTycdF" tabindex="0"
                                                                       class="hidden" name="sbasmtTycd" value="FILE"
                                                                       checked>
                                                                <label for="sbasmtTycdF">
                                                                    <spring:message code="asmnt.label.file" /><!-- 파일 --></label>
                                                            </div>
                                                        </div>
                                                        <div class="field">
                                                            <div class="ui radio checkbox">
                                                                <input type="radio" id="sbasmtTycdT" tabindex="0"
                                                                       class="hidden" name="sbasmtTycd"
                                                                       value="INPUT_TEXT">
                                                                <label for="sbasmtTycdT"><spring:message
                                                                        code="lesson.label.text"/>(TEXT)</label>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="ui segment bcLgrey9" id="viewSbasmtTycdFile">
                                                        <div class="fields">
                                                            <div class="field">
                                                                <div class="ui radio checkbox">
                                                                    <input type="radio" id="allFile"
                                                                           name="sbmsnFileMimeTycd"
                                                                           value="all" class="hidden" checked>
                                                                    <label for="allFile">
                                                                        <spring:message code="asmnt.label.total.file" /><!-- 모든파일 --></label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="fields">
                                                            <div class="field">
                                                                <div class="ui radio checkbox">
                                                                    <input type="radio" id="preFile"
                                                                           name="sbmsnFileMimeTycd"
                                                                           value="pre" class="hidden">
                                                                    <label for="preFile"><spring:message
                                                                            code="button.preview"/> <spring:message
                                                                            code="message.possible"/> : </label>
                                                                </div>
                                                            </div>
                                                            <div class="field">
                                                                <div class="ui checkbox">
                                                                    <input type="checkbox" id="preFile01" name="preFile"
                                                                           value="img">
                                                                    <label class="toggle_btn"
                                                                           for="preFile01"><spring:message
                                                                            code="lesson.label.img"/> (JPG, GIF,
                                                                        PNG)</label>
                                                                </div>
                                                            </div>
                                                            <div class="field">
                                                                <div class="ui checkbox">
                                                                    <input type="checkbox" id="preFile02" name="preFile"
                                                                           value="pdf">
                                                                    <label class="toggle_btn"
                                                                           for="preFile02">PDF</label>
                                                                </div>
                                                            </div>
                                                            <!-- <div class="field">
                                                                <div class="ui checkbox">
                                                                    <input type="checkbox" id="preFile03" name="preFile" value="txt">
                                                                    <label class="toggle_btn" for="preFile03">TEXT</label>
                                                                </div>
                                                            </div> -->
                                                            <div class="field">
                                                                <div class="ui checkbox">
                                                                    <input type="checkbox" id="preFile04" name="preFile"
                                                                           value="soc">
                                                                    <label class="toggle_btn"
                                                                           for="preFile04"><spring:message
                                                                            code="common.label.program.source"/>(.txt)</label>
                                                                </div>
                                                            </div>
                                                            <!-- <div class="field">
                                                                <div class="ui checkbox">
                                                                    <input type="checkbox" id="preFile03" name="preFile" value="ppt2">
                                                                    <label class="toggle_btn" for="preFile03">PPT(X)</label>
                                                                </div>
                                                            </div> -->
                                                        </div>
                                                        <div class="fields">
                                                            <div class="field">
                                                                <div class="ui radio checkbox">
                                                                    <input type="radio" id="docFile"
                                                                           name="sbmsnFileMimeTycd"
                                                                           value="doc" class="hidden">
                                                                    <label for="docFile"><spring:message
                                                                            code="common.label.type.doc"/> : </label>
                                                                </div>
                                                            </div>
                                                            <div class="field">
                                                                <div class="ui checkbox">
                                                                    <input type="checkbox" id="docFile01" name="docFile"
                                                                           value="hwp">
                                                                    <label class="toggle_btn"
                                                                           for="docFile01">HWP(X)</label>
                                                                </div>
                                                            </div>
                                                            <div class="field">
                                                                <div class="ui checkbox">
                                                                    <input type="checkbox" id="docFile02" name="docFile"
                                                                           value="doc">
                                                                    <label class="toggle_btn"
                                                                           for="docFile02">DOC(X)</label>
                                                                </div>
                                                            </div>
                                                            <div class="field">
                                                                <div class="ui checkbox">
                                                                    <input type="checkbox" id="docFile03" name="docFile"
                                                                           value="ppt">
                                                                    <label class="toggle_btn"
                                                                           for="docFile03">PPT(X)</label>
                                                                </div>
                                                            </div>
                                                            <div class="field">
                                                                <div class="ui checkbox">
                                                                    <input type="checkbox" id="docFile04" name="docFile"
                                                                           value="xls">
                                                                    <label class="toggle_btn"
                                                                           for="docFile04">XLS(X)</label>
                                                                </div>
                                                            </div>
                                                            <%--<div class="field">
                                                                <div class="ui checkbox">
                                                                    <input type="checkbox" id="docFile05" name="docFile"
                                                                           value="pdf2">
                                                                    <label class="toggle_btn"
                                                                           for="docFile05">PDF</label>
                                                                </div>
                                                            </div>--%>
                                                            <%--<div class="field">
                                                                <div class="ui checkbox">
                                                                    <input type="checkbox" id="docFile06" name="docFile"
                                                                           value="zip">
                                                                    <label class="toggle_btn"
                                                                           for="docFile06">ZIP</label>
                                                                </div>
                                                            </div>--%>
                                                        </div>
                                                    </div>
                                                </dd>
                                            </dl>
                                        </li>
                                        <li>
                                            <dl>
                                                <dt><label for="contentTextArea"><spring:message
                                                        code="asmnt.label.file.upload"/></label></dt><!-- 파일 업로드 -->
                                                <dd>
                                                    <uiex:dextuploader
                                                            id="upload1"
                                                            path="${uploadPath}"
                                                            limitCount="5"
                                                            limitSize="1024"
                                                            oneLimitSize="1024"
                                                            listSize="3"
                                                            fileList="${asmtVo.fileList}"
                                                            finishFunc="finishUpload()"
                                                            useFileBox="true"
                                                            allowedTypes="*"
                                                            bigSize="false"
                                                    />
                                                </dd>
                                            </dl>
                                        </li>
                                        <li>
                                            <dl>
                                                <dt><label class="req">
                                                    <spring:message code="asmnt.label.practice.asmnt" /><!-- 실기과제 --></label>
                                                </dt>
                                                <dd>
                                                    <div class="fields">
                                                        <div class="field">
                                                            <div class="ui radio checkbox">
                                                                <input type="radio" id="asmtPrctcY" tabindex="0"
                                                                       class="hidden" name="asmtPrctcyn" value="Y">
                                                                <label for="asmtPrctcY"><spring:message
                                                                        code="asmnt.common.yes"/></label><!-- 예 -->
                                                            </div>
                                                        </div>
                                                        <div class="field">
                                                            <div class="ui radio checkbox">
                                                                <input type="radio" id="asmtPrctcN" tabindex="0"
                                                                       class="hidden" name="asmtPrctcyn" value="N"
                                                                       checked>
                                                                <label for="asmtPrctcN"><spring:message
                                                                        code="asmnt.common.no"/></label><!-- 아니오 -->
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="ui segment bcLgrey9" id="viewPrtc">
                                                        <div class="fields">
                                                            <div class="field">
                                                                <div class="ui">
                                                                    <label for="fileType"><spring:message
                                                                            code="button.manage.file.type"/> : </label>
                                                                    <!-- 파일 형식 -->
                                                                </div>
                                                            </div>
                                                            <div class="field">
                                                                <div class="ui checkbox">
                                                                    <input type="checkbox" id="fileType01"
                                                                           name="prtcFileType" value="img">
                                                                    <label class="toggle_btn" for="fileType01">
                                                                        <spring:message code="common.label.image" /><!-- 이미지 -->
                                                                        (JPG, GIF, PNG)</label>
                                                                </div>
                                                            </div>
                                                            <div class="field">
                                                                <div class="ui checkbox">
                                                                    <input type="checkbox" id="fileType02"
                                                                           name="prtcFileType" value="pdf">
                                                                    <label class="toggle_btn"
                                                                           for="fileType02">PDF</label>
                                                                </div>
                                                            </div>
                                                            <%--<div class="field">
                                                                <div class="ui checkbox">
                                                                    <input type="checkbox" id="fileType03"
                                                                           name="prtcFileType" value="ppt"/>
                                                                    <label class="toggle_btn"
                                                                           for="fileType03">PPT(X)</label>
                                                                </div>
                                                            </div>--%>

                                                        </div>
                                                        <div class="fields">
                                                            <div class="field">
                                                                <div class="ui">
                                                                    <label for="exlnAsmtDwldyn">우수과제 다운로드</label>
                                                                    <!-- 우수과제 다운로드 -->
                                                                </div>
                                                            </div>
                                                            <div class="field">
                                                                <div class="ui radio checkbox">
                                                                    <input type="radio" id="exlnAsmtDwldN" tabindex="0"
                                                                           class="hidden" name="exlnAsmtDwldyn"
                                                                           value="N"
                                                                           checked>
                                                                    <label for="exlnAsmtDwldN"><spring:message
                                                                            code="asmnt.common.no"/></label><!-- 아니오 -->
                                                                </div>
                                                            </div>
                                                            <div class="field">
                                                                <div class="ui radio checkbox">
                                                                    <input type="radio" id="exlnAsmtDwldY" tabindex="0"
                                                                           class="hidden" name="exlnAsmtDwldyn"
                                                                           value="Y">
                                                                    <label for="exlnAsmtDwldY"><spring:message
                                                                            code="asmnt.common.yes"/></label><!-- 예 -->
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </dd>
                                            </dl>
                                        </li>
                                        <%--<li>
                                            <dl>
                                                <dt>
                                                    <spring:message code="asmnt.label.feedback.use.yn" /><!-- 실시간 피드백사용 --></dt>
                                                <dd>
                                                    <div class="inline fields mb0">
                                                        <div class="field">
                                                            <div class="ui radio checkbox">
                                                                <input type="radio" name="pushAlimyn" value="Y"
                                                                       checked/>
                                                                <label>
                                                                    <spring:message code="asmnt.common.yes"/><!-- 예 --></label>
                                                            </div>
                                                        </div>
                                                        <div class="field">
                                                            <div class="ui radio checkbox">
                                                                <input type="radio" name="pushAlimyn" value="N"/>
                                                                <label>
                                                                    <spring:message code="asmnt.common.no"/><!-- 아니오 --></label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="ui small warning message">
                                                        <i class="info icon"></i>
                                                        <spring:message code="asmnt.label.feedback.guide"/>
                                                        <!-- 채점시 피드백을 학생들에게 쪽지, PUSH 실시간 알림 기능 -->
                                                    </div>
                                                </dd>
                                            </dl>
                                        </li>--%>


                                        <li>
                                            <dl>
                                                <dt><label for="teamLabel">
                                                    <spring:message code="asmnt.label.team.asmnt" /><!-- 팀과제 --></label>
                                                </dt>
                                                <dd>
                                                    <div class="fields">
                                                        <div class="field">
                                                            <div class="ui radio checkbox">
                                                                <input type="radio" id="teamY" tabindex="0"
                                                                       class="hidden" name="teamAsmtStngyn"
                                                                       value="Y">
                                                                <label for="teamY"><spring:message
                                                                        code="message.yes"/></label><!-- 예 -->
                                                            </div>
                                                        </div>
                                                        <div class="field">
                                                            <div class="ui radio checkbox">
                                                                <input type="radio" id="teamN" tabindex="0"
                                                                       class="hidden" name="teamAsmtStngyn"
                                                                       value="N" checked>
                                                                <label for="teamN"><spring:message
                                                                        code="message.no"/></label><!-- 아니오 -->
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="ui segment bcLgrey9" id="viewTeamAsmnt"></div>
                                                </dd>
                                            </dl>
                                        </li>


                                        <li>
                                            <dl>
                                                <dt><label for="indLabel"><spring:message
                                                        code="asmnt.label.individual.asmnt"/></label></dt>
                                                <!-- 개별과제 -->
                                                <dd>
                                                    <div class="fields">
                                                        <div class="field">
                                                            <div class="ui radio checkbox">
                                                                <input type="radio" id="indY" tabindex="0"
                                                                       class="hidden" name="indvAsmtyn"
                                                                       value="Y">
                                                                <label for="indY"><spring:message
                                                                        code="message.yes"/></label><!-- 예 -->
                                                            </div>
                                                        </div>
                                                        <div class="field">
                                                            <div class="ui radio checkbox">
                                                                <input type="radio" id="indN" tabindex="0"
                                                                       class="hidden" name="indvAsmtyn"
                                                                       value="N"
                                                                       checked>
                                                                <label for="indN"><spring:message
                                                                        code="message.no"/></label><!-- 아니오 -->
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="ui small warning message">
                                                        <i class="info circle icon"></i>
                                                        <spring:message code="asmnt.label.indi.info"/>
                                                        <!-- 전체 수강생 중 지정된 개별인원에게만 부여되며, 해당과제는 성적반영이 불가합니다. -->

                                                    </div>

                                                    <div class="ui segment bcLgrey9" id="viewIndAsmnt">

                                                        <div class="swapLists">
                                                            <div class="swapListsItem">
                                                                <div class="option-content mb10">
                                                                    <label for="b1" class="mra"><spring:message
                                                                            code="button.list.student"/></label>
                                                                    <!-- 수강생 목록 -->
                                                                    <div class="ui action input search-box">
                                                                        <input type="text" id="tgSearch"
                                                                               placeholder="<spring:message code='team.popup.search.placeholder'/>">
                                                                        <!-- 학과, 학번, 이름 입력 -->
                                                                        <button type="button"
                                                                                class="ui icon button"
                                                                                onclick="indiSearch('T')"><i
                                                                                class="search icon"></i>
                                                                        </button>
                                                                    </div>
                                                                </div>

                                                                <table class="tbl_fix type2">
                                                                    <thead>
                                                                    <tr>
                                                                        <th class="wf5">
                                                                            <div class="ui checkbox">
                                                                                <input type="checkbox" id="tg0"
                                                                                       tabindex="0"
                                                                                       class="hidden">
                                                                                <label class="toggle_btn"
                                                                                       for="tg0"></label>
                                                                            </div>
                                                                        </th>
                                                                        <th class="wf15"><spring:message
                                                                                code="common.number.no"/></th>
                                                                        <!-- NO. -->
                                                                        <spring:message
                                                                                code="asmnt.label.dept.nm"/></th>
                                                                        <!-- 학과 -->
                                                                        <c:if test="${creCrsVO.univGbn eq '3' or creCrsVO.univGbn eq '4'}">
                                                                            <th><spring:message
                                                                                    code="common.label.grsc.degr.cors.gbn2"/></th>
                                                                            <!-- 학위구분 -->
                                                                        </c:if>
                                                                        <spring:message
                                                                                code="asmnt.label.user_id"/></th>
                                                                        <!-- 학번 -->
                                                                        <spring:message
                                                                                code="asmnt.label.user_nm"/></th>
                                                                        <!-- 이름 -->
                                                                    </tr>
                                                                    </thead>
                                                                    <tbody id="indvAsmtList"></tbody>
                                                                </table>
                                                            </div>

                                                            <div class="button-area">
                                                                <button type='button'
                                                                        class="ui basic icon button"
                                                                        data-medi-ui="swap"
                                                                        data-swap-to="right"
                                                                        data-swap-target="tr"
                                                                        data-swap-arrival="tbody"
                                                                        title="<spring:message code='team.popup.button.right'/>">
                                                                    <!-- 오른쪽으로 이동 -->
                                                                    <i class="arrow right icon"></i>
                                                                </button>

                                                                <button type='button'
                                                                        class="ui basic icon button"
                                                                        data-medi-ui="swap"
                                                                        data-swap-to="left"
                                                                        data-swap-target="tr"
                                                                        data-swap-arrival="tbody"
                                                                        title="<spring:message code='team.popup.button.left'/>">
                                                                    <!-- 왼쪽으로 이동 -->
                                                                    <i class="arrow left icon"></i>
                                                                </button>
                                                            </div>
                                                            <div class="swapListsItem">
                                                                <div class="option-content mb10">
                                                                    <label for="b1" class="mra"><spring:message
                                                                            code="asmnt.label.ind.asmnt.user"/></label>
                                                                    <!-- 개별과제 대상자 -->
                                                                    <div class="ui action input search-box">
                                                                        <input type="text" id="stgSearch"
                                                                               placeholder="<spring:message code='team.popup.search.placeholder'/>">
                                                                        <!-- 학과, 학번, 이름 입력 -->
                                                                        <button type="button"
                                                                                class="ui icon button"
                                                                                onclick="indiSearch('S')"><i
                                                                                class="search icon"></i>
                                                                        </button>
                                                                    </div>
                                                                </div>
                                                                <table class="tbl_fix type2">
                                                                    <thead>
                                                                    <tr>
                                                                        <th class="wf5">
                                                                            <div class="ui checkbox">
                                                                                <input type="checkbox" id="stg0"
                                                                                       tabindex="0"
                                                                                       class="hidden">
                                                                                <label class="toggle_btn"
                                                                                       for="stg0"></label>
                                                                            </div>
                                                                        </th>
                                                                        <th class="wf15"><spring:message
                                                                                code="common.number.no"/></th>
                                                                        <!-- NO. -->
                                                                        <spring:message
                                                                                code="asmnt.label.dept.nm"/></th>
                                                                        <!-- 학과 -->
                                                                        <c:if test="${creCrsVO.univGbn eq '3' or creCrsVO.univGbn eq '4'}">
                                                                            <th><spring:message
                                                                                    code="common.label.grsc.degr.cors.gbn2"/></th>
                                                                            <!-- 학위구분 -->
                                                                        </c:if>
                                                                        <spring:message
                                                                                code="asmnt.label.user_id"/></th>
                                                                        <!-- 학번 -->
                                                                        <spring:message
                                                                                code="asmnt.label.user_nm"/></th>
                                                                        <!-- 이름 -->
                                                                    </tr>
                                                                    </thead>
                                                                    <tbody id="sindvAsmtList"></tbody>
                                                                </table>
                                                            </div>
                                                        </div>

                                                    </div>
                                                </dd>
                                            </dl>
                                        </li>
                                    </ul>
                                </div>

                                <div class="ui styled fluid accordion week_lect_list">
                                    <div class="title">
                                        <div class="title_cont">
                                            <div class="left_cont">
                                                <div class="lectTit_box">
                                                    <p class="lect_name"><spring:message
                                                            code="resh.label.added.features"/></p><!-- 추가기능 -->
                                                </div>
                                            </div>
                                        </div>
                                        <i class="dropdown icon ml20"></i>
                                    </div>
                                    <div class="content p0">
                                        <div class="ui segment">
                                            <ul class="tbl border-top-grey">
                                                <li>
                                                    <dl>
                                                        <dt><label><spring:message
                                                                code="asmnt.label.read.allow"/></label></dt>
                                                        <!-- 과제읽기 허용 -->
                                                        <dd>
                                                            <div class="fields">
                                                                <div class="field">
                                                                    <div class="ui radio checkbox">
                                                                        <input type="radio" id="sbasmtOstdY"
                                                                               name="sbasmtOstdOyn" tabindex="0"
                                                                               class="hidden" value="Y">
                                                                        <label for="sbasmtOstdY"><spring:message
                                                                                code="message.yes"/></label><!-- 예 -->
                                                                    </div>
                                                                </div>
                                                                <div class="field">
                                                                    <div class="ui radio checkbox">
                                                                        <input type="radio" id="sbasmtOstdN"
                                                                               name="sbasmtOstdOyn" tabindex="0"
                                                                               class="hidden" value="N" checked>
                                                                        <label for="sbasmtOstdN"><spring:message
                                                                                code="message.no"/></label><!-- 아니오 -->
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <div class="ui segment bcLgrey9" id="viewSbasmtOstd">
                                                                <div class="fields gap4">
                                                                    <div class="field flex">
                                                                        <label for="dateLabel"><spring:message
                                                                                code="asmnt.label.read.allow.dt"/></label>
                                                                        <!-- 과제 읽기 허용기간 -->
                                                                    </div>
                                                                    <div class="field flex">
                                                                        <!-- 시작일시 -->
                                                                        <uiex:ui-calendar
                                                                                dateId="ostdOpenSdttmText"
                                                                                hourId="calOstdOpenSdttmHH"
                                                                                minId="calOstdOpenSdttmMM"
                                                                                rangeType="start"
                                                                                rangeTarget="ostdOpenEdttmText"
                                                                                value="${vo.sbasmtOstdOpenSdttm}"/>
                                                                    </div>
                                                                    <%-- <div class="field p0 flex-item desktop-elem">~</div>
                                                                    <div class="field flex">
                                                                        <!-- 종료일시 -->
                                                                        <uiex:ui-calendar
                                                                                dateId="ostdOpenEdttmText"
                                                                                hourId="calOstdOpenEdttmHH"
                                                                                minId="calOstdOpenEdttmMM"
                                                                                rangeType="end"
                                                                                rangeTarget="ostdOpenSdttmText"
                                                                                value="${vo.sbasmtOstdOpenEdttm}"/>
                                                                    </div>--%>
                                                                </div>
                                                            </div>
                                                            <div class="ui small warning message"><i
                                                                    class="info icon"></i><spring:message
                                                                    code="asmnt.alert.input.submit.stu.read.set"/></div>
                                                            <!-- 제출 과제 학습자 간에 읽을 수 있도록 설정 -->
                                                        </dd>
                                                    </dl>
                                                </li>

                                                <%--<li>
                                                    <dl>
                                                        <dt><label><spring:message
                                                                code="forum.label.mutEvalYn"/></label></dt>
                                                        <!-- 상호평가 사용 -->
                                                        <dd>
                                                            <div class="fields">
                                                                <div class="field">
                                                                    <div class="ui radio checkbox">
                                                                        <input type="radio" id="evalUseY"
                                                                               name="evlRfltyn" tabindex="0"
                                                                               class="hidden" value="Y">
                                                                        <label for=""><spring:message
                                                                                code="message.yes"/></label><!-- 예 -->
                                                                    </div>
                                                                </div>
                                                                <div class="field">
                                                                    <div class="ui radio checkbox">
                                                                        <input type="radio" id="evalUseN"
                                                                               name="evlRfltyn" tabindex="0"
                                                                               class="hidden" value="N" checked>
                                                                        <label for=""><spring:message
                                                                                code="message.no"/></label><!-- 아니오 -->
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <div class="ui segment bcLgrey9" id="viewEvalUse">
                                                                <div class="fields">
                                                                    <div class="field">
                                                                        <div class="ui">
                                                                            <label for="a3">
                                                                                <spring:message code="forum.label.eval.date" /><!-- 평가 기간 --></label>
                                                                        </div>
                                                                    </div>

                                                                    <div class="field flex">
                                                                        <!-- 시작일시 -->
                                                                        <uiex:ui-calendar dateId="evalStartDttmText"
                                                                                          hourId="calEvalStartHH"
                                                                                          minId="calEvalStartMM"
                                                                                          rangeType="start"
                                                                                          rangeTarget="evalEndDttmText"/>
                                                                    </div>
                                                                    <div class="field p0 flex-item desktop-elem">~</div>
                                                                    <div class="field flex">
                                                                        <!-- 종료일시 -->
                                                                        <uiex:ui-calendar dateId="evalEndDttmText"
                                                                                          hourId="calEvalEndHH"
                                                                                          minId="calEvalEndMM"
                                                                                          rangeType="end"
                                                                                          rangeTarget="evalStartDttmText"/>
                                                                    </div>
                                                                </div>
                                                                <div class="fields">
                                                                    <div class="field">
                                                                        <div class="ui">
                                                                            <label for="evalRsltOpenYnCheck"><spring:message
                                                                                    code='asmnt.label.team.mut.eval'/></label>
                                                                            <!-- 팀내 상호평가 -->
                                                                        </div>
                                                                    </div>
                                                                    <div class="field">
                                                                        <div class='ui toggle checkbox'>
                                                                            <input type='checkbox'
                                                                                   id='teamEvalYnCheck'/>
                                                                        </div>
                                                                        <input type='hidden' name='teamEvalYn'
                                                                               value='N'/>
                                                                    </div>
                                                                </div>
                                                                <div class="fields">
                                                                    <div class="field">
                                                                        <div class="ui">
                                                                            <label for="evalRsltOpenYnCheck"><spring:message
                                                                                    code='asmnt.label.result.open'/></label>
                                                                            <!-- 결과공개 -->
                                                                        </div>
                                                                    </div>
                                                                    <div class="field">
                                                                        <div class='ui toggle checkbox'>
                                                                            <input type='checkbox'
                                                                                   id='evalRsltOpenYnCheck'/>
                                                                        </div>
                                                                        <input type='hidden' name='evlRsltOyn'
                                                                               value='N'/>
                                                                    </div>
                                                                </div>
                                                                <div class="ui small warning message"><i
                                                                        class="info icon"></i>
                                                                    <spring:message code='forum.label.mutEval.warning'/><!-- 상호 평가는 별점 5점으로 진행됩니다. 본인/본인 팀 평가는 불가능합니다. -->
                                                                </div>
                                                            </div>
                                                        </dd>
                                                    </dl>
                                                </li>--%>
                                            </ul>
                                        </div>

                                    </div>
                                </div>

                                <div class="option-content mt10 mb15">
                                    <div class="ui basic mla">
                                        <div class="button-area">
                                            <a href="javascript:saveConfirm();" class="ui blue button">
                                                <spring:message code='asmnt.button.save'/><!-- 저장 --></a>
                                            <a href="javascript:asmntCopyList();" class="ui basic button">
                                                <spring:message code='asmnt.button.asmnt.prev'/><!-- 이전 과제 가져오기 --></a>
                                            <a href="javascript:viewAsmntList();" class="ui basic button">
                                                <spring:message code='asmnt.button.list'/><!-- 목록 --></a>
                                        </div>
                                    </div>
                                </div>

                                <c:if test="${not empty asmtVo.parExamCd && asmtVo.asmtGbncd eq 'SUBS' }">
                                    <div class="option-content mt30">
                                        <h3 class="sec_head">
                                            <c:if test="${asmtVo.examStareTypeCd eq 'M' }"><spring:message code="exam.label.mid.exam" /><!-- 중간고사 -->
                                            </c:if>
                                            <c:if test="${asmtVo.examStareTypeCd eq 'L' }"><spring:message code="exam.label.end.exam" /><!-- 기말고사 -->
                                            </c:if>
                                            <spring:message code="exam.label.ins.target" /><!-- 대체평가 대상자 -->
                                        </h3>
                                        <div class="mla">
                                            <a href="javascript:sendMsg()" class="ui basic small button"><i
                                                    class="paper plane outline icon"></i><spring:message
                                                    code="common.button.message"/></a><!-- 메시지 -->
                                            <a href="javascript:examInsTargetPop('${asmtVo.parExamCd }')"
                                               class="ui blue small button"><spring:message
                                                    code="exam.label.ins.target.set"/></a><!-- 대상자 설정 -->
                                            <a href="javascript:examInsTargetCancel('${asmtVo.parExamCd }')"
                                               class="ui blue small button"><spring:message
                                                    code="exam.label.ins.target.cancel"/></a><!-- 대상자 취소 -->
                                        </div>
                                    </div>
                                    <table class="table type2" id="stdTable" data-sorting="true" data-paging="false"
                                           data-empty="<spring:message code='exam.label.exam.ins.target.none' />"
                                           id="examEtcListTable"><!-- '대상자설정' 버튼을 클릭 후 대상자를 설정해주세요. -->
                                        <thead>
                                        <tr>
                                            <th>
                                                <div class="ui checkbox">
                                                    <input type="checkbox" name="evalChkAll" id="evalChkAll" value="all"
                                                           onchange="checkStd(this)">
                                                    <label class="toggle_btn" for="evalChkAll"></label>
                                                </div>
                                            </th>
                                            <th>No</th>
                                            <th><spring:message code="exam.label.dept" /><!-- 학과 --></th>
                                            <th><spring:message code="exam.label.user.no" /><!-- 학번 --></th>
                                            <th><spring:message code="exam.label.user.nm" /><!-- 이름 --></th>
                                            <th><spring:message code="exam.label.exam" /><!-- 시험 -->
                                                <spring:message code="exam.label.yes.stare" /><!-- 응시 --></th>
                                            <th><spring:message code="exam.label.absent" /><!-- 결시원 -->
                                                <spring:message code="exam.label.submit.y" /><!-- 제출 --></th>
                                            <th><spring:message code="exam.label.absent" /><!-- 결시원 -->
                                                <spring:message code="exam.label.approve" /><!-- 승인 --></th>
                                            <th><spring:message code="exam.label.manage" /><!-- 관리 --></th>
                                        </tr>
                                        </thead>
                                        <tbody id="stdTbody">
                                        </tbody>
                                    </table>
                                    <div class="option-content">
                                        <div class="mla">
                                            <a href="javascript:viewAsmntList();" class="ui basic button">
                                                <spring:message code='asmnt.button.list'/><!-- 목록 --></a>
                                        </div>
                                    </div>
                                </c:if>

                            </div><!-- //col -->
                        </div><!-- //row -->
                    </div>
                </div>

            </form>

        </div><!-- //content -->
        <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
    </div><!-- //container -->
</div><!-- //pusher -->
</body>
</html>