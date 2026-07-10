<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>

    <script type="text/javascript">
        let EPARAM = '<c:out value="${encParams}" />';
        const MRK_PROC_EDTTM = '<c:out value="${sbjctInfo.mrkProcEdttm}"/>';

        $(document).ready(function () {
            getIndivAsmtStdList();
            /**
             * 개별과제 검색 엔터
             */
            $("#tgSearch").on("keydown", function (e) {
                if (e.key === "Enter") {
                    e.preventDefault();
                    indiSearch("T");
                }
            });

            $("#stgSearch").on("keydown", function (e) {
                if (e.key === "Enter") {
                    e.preventDefault();
                    indiSearch("S");
                }
            });
        });

        /**
         * =========================================================
         * 재제출 후보자 목록 조회
         * =========================================================
         */
        function getIndivAsmtStdList() {

            const url = "/asmt2/profResbmsnCandidateListAjax.do";
            const param = {
                "sbjctId": "${asmtVO.sbjctId}",
                "asmtId": "${asmtVO.asmtId}",
            };

            ajaxCall(url, param, function (data) {
                if (data.encParams != null && data.encParams != '') {
                    EPARAM = data.encParams;
                }

                if (data.result > 0) {

                    let html = "";

                    data.returnList.forEach(function (o, i) {
                        html += "<tr>";
                        html += "    <td class='chkbox'>";
                        html += "        <input type='hidden' value='" + o.userId + "'/>";
                        html += "        <span class='custom-input onlychk'>";
                        html += "            <input type='checkbox' id='tg" + (i + 1) + "' tabindex='0' class='hidden'/>";
                        html += "            <label for='tg" + (i + 1) + "'></label>";
                        html += "        </span>";
                        html += "    </td>";
                        html += "    <td>" + (i + 1) + "</td>";
                        html += "    <td class='tgList'>" + UiComm.escapeHtml(o.deptnm || "") + "</td>";
                        html += "    <td class='tgList'>" + UiComm.escapeHtml(o.stdntNo || "") + "</td>";
                        html += "    <td class='tgList'>" + UiComm.escapeHtml(o.usernm || "") + "</td>";
                        html += "</tr>";
                    });

                    $("#indvAsmtList").empty().append(html);

                    getIndivAsmtSbmsnTrgtList();
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }, function () {
                UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");
            }, true);
        }

        /**
         * =========================================================
         * 재제출 대상 목록 조회
         * =========================================================
         */
        function getIndivAsmtSbmsnTrgtList() {

            const url = "/asmt2/profResbmsnTrgtListAjax.do";
            const param = {
                "sbjctId": "${asmtVO.sbjctId}",
                "asmtId": "${asmtVO.asmtId}"
            };

            ajaxCall(url, param, function (data) {
                if (data.encParams != null && data.encParams != '') {
                    EPARAM = data.encParams;
                }

                if (data.result > 0) {

                    let html = "";
                    data.returnList.forEach(function (o, i) {
                        html += "<tr>";
                        html += "    <td class='chkbox'>";
                        html += "        <input type='hidden' value='" + o.userId + "'/>";
                        html += "        <span class='custom-input onlychk'>";
                        html += "            <input type='checkbox' id='tgr" + (i + 1) + "' tabindex='0' class='hidden'/>";
                        html += "            <label for='tgr" + (i + 1) + "'></label>";
                        html += "        </span>";
                        html += "    </td>";
                        html += "    <td>" + (i + 1) + "</td>";
                        html += "    <td class='tgList'>" + UiComm.escapeHtml(o.deptnm || "") + "</td>";
                        html += "    <td class='tgList'>" + UiComm.escapeHtml(o.stdntNo || "") + "</td>";
                        html += "    <td class='tgList'>" + UiComm.escapeHtml(o.usernm || "") + "</td>";
                        html += "</tr>";

                        $("#indvAsmtList input[value='" + o.userId + "']").closest("tr").remove();
                    });

                    $("#indvAsmtList tr").each(function (i) {
                        $("#indvAsmtList tr:eq(" + i + ") td:eq(1)").text(i + 1);
                    });

                    $("#sindvAsmtList").empty().append(html);
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }, function () {
                UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");
            }, true);
        }


        function checkAll1() {
            if ($("#tg0").is(":checked") == false) {
                $("#indList").find("input:checkbox").prop('checked', true);
            } else {
                $("#indList").find("input:checkbox").prop('checked', false);
            }
        }

        function checkAll2() {
            if ($("#stg0").is(":checked") == false) {
                $("#sIndList").find("input:checkbox").prop('checked', true);
            } else {
                $("#sIndList").find("input:checkbox").prop('checked', false);
            }
        }

        // 개별과제여부 수강생목록 검색
        function indiSearch(type) {
            if (type === "T") {
                const keyword = ($("#tgSearch").val() || "").trim().toLowerCase();
                $("#tg0").prop("checked", false);
                $("#indvAsmtList input:checkbox").prop("checked", false);

                $("#indvAsmtList tr").each(function () {
                    const rowText = $(this).text().toLowerCase();

                    if (!keyword || rowText.indexOf(keyword) > -1) {
                        $(this).show();
                    } else {
                        $(this).hide();
                    }
                });
            } else if (type === "S") {
                const keyword = ($("#stgSearch").val() || "").trim().toLowerCase();

                $("#stg0").prop("checked", false);
                $("#sindvAsmtList input:checkbox").prop("checked", false);

                $("#sindvAsmtList tr").each(function () {
                    const rowText = $(this).text().toLowerCase();

                    if (!keyword || rowText.indexOf(keyword) > -1) {
                        $(this).show();
                    } else {
                        $(this).hide();
                    }
                });
            }
        }


        /**
         * 재제출 저장
         */
        function saveResbmsn() {
            let validator = UiValidator("resbmsnForm");
            validator.then(function (result) {
                if (result) {

                    let resbmsnSdttm = fn_getPeriodValue("resbmsnDateSt", "resbmsnTimeSt")
                    let resbmsnEdttm = fn_getPeriodValue("resbmsnDateEd", "resbmsnTimeEd")

                    const mrkProcEdttm = (MRK_PROC_EDTTM || "").replace(/[^0-9]/g, "");

                    if (resbmsnEdttm && resbmsnEdttm > mrkProcEdttm) {
                        UiComm.showMessage("<spring:message code='asmt.alert.submit.end.before.score.end'/><%--과제 제출 종료일시는 성적처리종료 일시 전까지만 등록할 수 있습니다.--%>", "error");
                        return false;
                    }

                    $("input[name=resbmsnSdttm]").val(resbmsnSdttm);
                    $("input[name=resbmsnEdttm]").val(resbmsnEdttm);


                    const indvAsmtList = [];

                    $("#sindvAsmtList tr").each(function () {
                        const userId = $(this).find("input[type='hidden']").val();
                        if (userId) {
                            indvAsmtList.push(userId);
                        }
                    });

                    $("input[name='indvAsmtList']").val(indvAsmtList.join(","));


                    const url = "/asmt2/profAsmtResbmsnModifyAjax.do";

                    $.ajaxSettings.traditional = true;
                    ajaxCall(url, $("#resbmsnForm").serialize(), function (data) {
                        if (data.encParams != null && data.encParams != '') {
                            EPARAM = data.encParams;
                        }
                        if (data.result > 0) {
                            UiComm.showMessage("<spring:message code='common.alert.ok.save' />", "success");
                            window.parent.closeDialog();
                        } else {
                            UiComm.showMessage(data.message, "error");
                        }
                    }, function () {
                        UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");
                    }, true);
                }
            })
        }


        /* 사용기간 값 조합 */
        function fn_getPeriodValue(dateId, timeId) {
            let dateVal = UiComm.getDateTimeVal(dateId, null);
            let timeVal = UiComm.getDateTimeVal(null, timeId);
            return dateVal + timeVal + '00';
        }

    </script>
</head>

<body class="modal-page">
<!--table-type5-->
<div class="table-wrap">
    <form id="resbmsnForm" onsubmit="return false;">
        <input type="hidden" name="indvAsmtList">
        <input type="hidden" name="asmtId" value="${asmtVO.asmtId}">
        <input type="hidden" name="resbmsnSdttm" value="">
        <input type="hidden" name="resbmsnEdttm" value="">
        <table class="table-type5">
            <colgroup>
                <col class="width-20per"/>
                <col class=""/>
            </colgroup>
            <tbody>
            <tr>
                <th><label for="noticeLabel" class="req"><spring:message code='asmt.label.resend.date'/><!-- 재제출기간 --></label></th>
                <td>
                    <div class="form-inline">

                        <div class="date_area">
                            <input id="resbmsnDateSt" type="text" name="resbmsnDateSt" value="<uiex:formatDate value="${asmtVO.resbmsnSdttm}" type="date"/>" class="datepicker" timeId="resbmsnTimeSt" toDate="resbmsnDateEd" placeholder="<spring:message code='asmt.label.start_date'/><%--시작일--%>" required="true">
                            <input id="resbmsnTimeSt" type="text" name="resbmsnTimeSt" value="<uiex:formatDate value="${asmtVO.resbmsnSdttm}" type="time"/>" class="timepicker" dateId="resbmsnDateSt" placeholder="<spring:message code='asmt.label.start.time'/><%--시작시간--%>" required="true">
                            <span class="txt-sort">~</span>
                            <input id="resbmsnDateEd" type="text" name="resbmsnDateEd" value="<uiex:formatDate value="${asmtVO.resbmsnEdttm}" type="date"/>" class="datepicker" timeId="resbmsnTimeEd" fromDate="resbmsnDateSt" placeholder="<spring:message code='asmt.label.end_date'/><%--종료일--%>" required="true">
                            <input id="resbmsnTimeEd" type="text" name="resbmsnTimeEd" value="<uiex:formatDate value="${asmtVO.resbmsnEdttm}" type="time"/>" class="timepicker" dateId="resbmsnDateEd" placeholder="<spring:message code='asmt.label.end.time'/><%--종료시간--%>" required="true">
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <th><label for="resbmsnMrkRfltrt" class="req"><spring:message code='asmt.label.score.aply.rate'/><%--반영비율--%></label></th>
                <td>
                    <div class="form-row">
                        <div class="input_btn">
                            <input class="form-control sm"
                                   id="resbmsnMrkRfltrt"
                                   name="resbmsnMrkRfltrt"
                                   value="${not empty asmtVO.resbmsnMrkRfltrt ? asmtVO.resbmsnMrkRfltrt : '100'}"
                                   type="text"
                                   inputmask="numeric"
                                   inputmode="decimal"
                                   maxVal="100"
                                   required="true">
                            <label>%</label>
                        </div>
                    </div>

                </td>
            </tr>
            <tr>
                <th>
                    <label for="indLabel">
                        <spring:message code='asmt.label.resend.user.setting'/><!-- 재제출자 설정 -->
                    </label>
                </th>
                <td>
                    <div id="viewIndivAsmt">
                        <div class="individualAssignment_list swapLists">
                            <div class="individualAssignment_list_area swapListsItem">
                                <div class="board_top in_table">
                                    <p><spring:message code='asmt.label.nosend.user.list'/><!-- 미제출자 목록 --></p>
                                    <div class="search-typeC">
                                        <input class="form-control"
                                               type="text"
                                               id="tgSearch"
                                               placeholder="<spring:message code='asmt.label.search.user.placeholder'/><%--학과, 학번, 이름 입력--%>">
                                        <button type="button"
                                                class="btn basic icon search"
                                                onclick="indiSearch('T')"
                                                aria-label="<spring:message code='asmt.label.search'/><%--검색--%>">
                                            <i class="icon-svg-search"></i>
                                        </button>
                                    </div>
                                </div>

                                <div class="table-height-scroll">
                                    <table class="table-type2">
                                        <colgroup>
                                            <col style="width:8%">
                                            <col style="width:10%">
                                            <col style="width:34%">
                                            <col style="width:24%">
                                            <col style="width:24%">
                                        </colgroup>
                                        <thead>
                                        <tr>
                                            <th>
                                                    <span class="custom-input onlychk" onclick="checkAll1()">
                                                        <input type="checkbox" id="tg0">
                                                        <label for="tg0"></label>
                                                    </span>
                                            </th>
                                            <th><spring:message code='common.number.no'/></th><!-- NO. -->
                                            <th><spring:message code='asmt.label.dept.nm'/><%--학과--%></th><!-- 학과 -->
                                            <th><spring:message code='asmt.label.stdnt_no'/><%--학번--%></th><!-- 학번 -->
                                            <th><spring:message code='asmt.label.user_nm'/><%--이름--%></th><!-- 이름 -->
                                        </tr>
                                        </thead>
                                        <tbody id="indvAsmtList"></tbody>
                                    </table>
                                </div>
                            </div>

                            <div class="arrowBtn">
                                <button type="button" class="btn basic icon"
                                        data-medi-ui="swap"
                                        data-swap-to="right"
                                        data-swap-target="tr"
                                        data-swap-arrival="tbody"
                                        title="<spring:message code='asmt.button.move.right'/><%--오른쪽으로 이동--%>">
                                    <i class="xi-angle-right"></i>
                                </button>
                                <button type="button" class="btn basic icon"
                                        data-medi-ui="swap"
                                        data-swap-to="left"
                                        data-swap-target="tr"
                                        data-swap-arrival="tbody"
                                        title="<spring:message code='asmt.button.move.left'/><%--왼쪽으로 이동--%>">
                                    <i class="xi-angle-left"></i>
                                </button>
                            </div>

                            <div class="individualAssignment_list_area swapListsItem">
                                <div class="board_top in_table">
                                    <p><spring:message code='asmt.label.resend.user'/><%--재제출자--%></p><!-- 재제출자 -->
                                    <div class="search-typeC">
                                        <input class="form-control"
                                               type="text"
                                               id="stgSearch"
                                               placeholder="<spring:message code='asmt.label.search.user.placeholder'/><%--학과, 학번, 이름 입력--%>">
                                        <button type="button"
                                                class="btn basic icon search"
                                                onclick="indiSearch('S')"
                                                aria-label="<spring:message code='asmt.label.search'/><%--검색--%>">
                                            <i class="icon-svg-search"></i>
                                        </button>
                                    </div>
                                </div>

                                <div class="table-height-scroll">
                                    <table class="table-type2">
                                        <colgroup>
                                            <col style="width:8%">
                                            <col style="width:10%">
                                            <col style="width:34%">
                                            <col style="width:24%">
                                            <col style="width:24%">
                                        </colgroup>
                                        <thead>
                                        <tr>
                                            <th>
                                                    <span class="custom-input onlychk" onclick="checkAll2()">
                                                        <input type="checkbox" id="stg0">
                                                        <label for="stg0"></label>
                                                    </span>
                                            </th>
                                            <th><spring:message code='common.number.no'/></th><!-- NO. -->
                                            <th><spring:message code='asmt.label.dept.nm'/><%--학과--%></th><!-- 학과 -->
                                            <th><spring:message code='asmt.label.stdnt_no'/><%--학번--%></th><!-- 학번 -->
                                            <th><spring:message code='asmt.label.user_nm'/><%--이름--%></th><!-- 이름 -->
                                        </tr>
                                        </thead>
                                        <tbody id="sindvAsmtList"></tbody>
                                    </table>
                                </div>
                            </div>

                        </div>
                    </div>
                </td>
            </tr>
            </tbody>
        </table>
    </form>
</div>

<div class="modal_btns">
    <button type="button" class="btn type1" onclick="saveResbmsn()"><spring:message code='asmt.button.save'/><!-- 저장 --></button>
    <button type="button" class="btn type2" onclick="window.parent.closeDialog();"><spring:message code='asmt.button.close'/><!-- 닫기 --></button>
</div>

</body>
</html>
