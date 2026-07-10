<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/asmt2/common/asmt_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>

<body class="class ${uiex:getTheme()} ${bodyClass}"><!-- 컬러선택시 클래스변경 -->
<div id="wrap" class="main">
    <!-- common header -->
    <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
    <!-- //common header -->

    <!-- classroom -->
    <main class="common">

        <!-- gnb -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
        <!-- //gnb -->

        <!-- content -->
        <div id="content" class="content-wrap common">
            <!-- class_sub_top -->
            <jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
            <!-- //class_sub_top -->

            <div class="class_sub">
                <!-- class_info -->
                <jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
                <!-- //class_info -->

                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title"><spring:message code='asmt.label.asmt'/><%--과제--%></h2>
                    </div>
                    <div id="amstListArea">
                        <div class="board_top">
                            <h3 class="board-title"><spring:message code='asmt.label.list'/><%--목록--%></h3>
                            <div class="right-area">
                                <!-- search small -->
                                <div class="search-typeC">
                                    <input class="form-control" type="text" name="" id="searchValue" value="" placeholder="<spring:message code='asmt.label.input.asmt_title'/><%--과제명 입력--%>" autocomplete="off">
                                    <button type="button" class="btn basic icon search" aria-label="<spring:message code='asmt.label.search'/><%--조회--%>" onclick="listPaging(1)"><i class="icon-svg-search"></i></button>
                                </div>

                                <div class="mrkRfltrtFrmTrsfDiv" style="display:none;">
                                    <button type="button" onclick="mrkRfltrtModify()" class="btn basic"><spring:message code='asmt.button.score.ratio.save'/><%--성적반영비율 저장--%></button>
                                    <button type="button" onclick="mrkRfltrtFrmTrsf(2)" class="btn type2"><spring:message code='asmt.button.cancel'/><%--취소--%></button>
                                </div>
                                <button onclick="mrkRfltrtFrmTrsf(1)" id="mrkRfltrtFrmTrsfBtn" type="button" class="btn basic"><spring:message code='asmt.button.score.ratio.chnage'/><%--성적반영비율 조정--%></button>
                                <button onclick="moveAsmtRegistView()" type="button" class="btn type2"><spring:message code='asmt.button.asmt.add'/><%--과제등록--%></button>

                                <%-- 리스트/카드 선택 버튼 --%>
                                <span class="list-card-button"></span>

                                <%-- 목록 스케일 선택 --%>
                                <uiex:listScale func="changeListScale" value="${asmtVO.listScale}"/>
                            </div>
                        </div>
                        <%-- 과제 리스트 --%>
                        <div id="asmtList"></div>
                        <%-- 과제 카드 폼 --%>
                        <div id="asmtList_cardForm" class="lecture_box" style="display:none">
                            <div class="card-header">
                                <label class="label s_c02">#[asmtGbnnm]</label>
                                <div class=card-title">
                                    #[asmtTtl]
                                </div>

                                <div class="btn_right">
                                    <div class="dropdown">
                                        <button type="button" class="btn basic icon set settingBtn" aria-label="<spring:message code='asmt.button.asmt.manage'/><%--과제관리--%>" onclick="this.nextElementSibling.classList.toggle('show')">
                                            <i class="xi-ellipsis-v"></i>
                                        </button>
                                        <div class="option-wrap">
                                            <div class="item"><a href="#0" onclick="moveAsmtEvlView('#[valAsmtId]')"><spring:message code='asmt.button.asmt.eval'/><%--과제평가--%></a></div>
                                            <div class="item"><a href="#0" onclick="moveAsmtModifyView('#[valAsmtId]')"><spring:message code='asmt.button.modify'/><%--수정--%></a></div>
                                            <div class="item"><a href="#0" onclick="deleteAsmt('#[valAsmtId]')"><spring:message code='asmt.button.delete'/><%--삭제--%></a></div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="card-body">
                                <div class="extra">
                                    <ul class="process-bar">
                                        <li class="bar-blue" style="width:20%;">#[sbmsnCntBar]</li>
                                        <li class="bar-grey" style="width:80%;">#[nonSbmsnCntBar]</li>
                                    </ul>
                                    <div class="desc">
                                        <p><label><spring:message code='asmt.label.send.date'/><%--제출기간--%></label><strong>#[sbmsnPeriod]</strong></p>
                                        <p><label><spring:message code='asmt.label.ext.send.deadline'/><%--연장제출마감--%></label><strong>#[extdSbmsnEdttm]</strong></p>
                                        <p><label><spring:message code='asmt.label.score.ratio'/><%--성적반영비율--%></label><strong>#[mrkRfltrt]</strong></p>
                                        <p><label><spring:message code='asmt.label.submit.status'/><%--제출현황--%></label><strong>#[sbmsnStts]</strong></p>
                                        <p><label><spring:message code='asmt.label.eval.status'/><%--평가현황--%></label><strong>#[evlStts]</strong></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <!-- //classroom-->
</div>
<script type="text/javascript">
    let PAGE_INDEX = '<c:out value="${asmtVO.pageIndex}" />';
    let LIST_SCALE = '<c:out value="${asmtVO.listScale}" />';
    let EPARAM = '<c:out value="${encParams}" />';
    const SBJCT_ID = '<c:out value="${asmtVO.sbjctId}" />';
    const ORG_ID = '<c:out value="${asmtVO.orgId}" />';
    let SEARCH_VALUE = '<c:out value="${param.searchValue}" />';

    let asmtListTable;

    $(function () {
        $("#searchValue").on("keyup", function (e) {
            if (e.keyCode == 13) {
                listPaging(1);
            }
        });


        // 과제 리스트 테이블
        asmtListTable = UiTable("asmtList", {
            pageFunc: listPaging,
            changeFunc: changeModeEvent,
            columns: [
                {
                    title: "No", field: "no", headerHozAlign: "center", hozAlign: "center",
                    width: 60, minWidth: 60
                }, // No
                {
                    title: "<spring:message code='asmt.label.type'/><%--구분--%>", field: "asmtGbnnm", headerHozAlign: "center", hozAlign: "center",
                    width: 120, minWidth: 120
                }
                , {
                    title: "<spring:message code='asmt.label.asmt.title'/><%--과제명--%>", field: "asmtTtl", headerHozAlign: "center", hozAlign: "left",
                    width: 0, minWidth: 220
                }
                , {
                    title: "<spring:message code='asmt.label.send.date'/><%--제출기간--%>", field: "sbmsnPeriod", headerHozAlign: "center", hozAlign: "center",
                    width: 280, minWidth: 280
                }
                , {
                    title: "<spring:message code='asmt.label.ext.send.deadline'/><%--연장제출마감--%>", field: "extdSbmsnEdttm", headerHozAlign: "center", hozAlign: "center",
                    width: 140, minWidth: 140
                }
                , {
                    title: "<spring:message code='asmt.label.score.ratio'/><%--성적반영비율--%>", field: "mrkRfltrt", headerHozAlign: "center", hozAlign: "center",
                    width: 90, minWidth: 90
                }
                , {
                    title: "<spring:message code='asmt.label.submit.status'/><%--제출현황--%>", field: "sbmsnStts", headerHozAlign: "center", hozAlign: "center",
                    width: 100, minWidth: 100
                }
                , {
                    title: "<spring:message code='asmt.label.eval.status'/><%--평가현황--%>", field: "evlStts", headerHozAlign: "center", hozAlign: "center",
                    width: 100, minWidth: 100
                }
                , {
                    title: "<spring:message code='asmt.label.resubmit.user'/><%--재제출자--%>", field: "resbmsn", headerHozAlign: "center", hozAlign: "center",
                    width: 90, minWidth: 90
                }
            ],
        });

        listPaging(1);
    });


    /**
     * 과제 목록 테이블 그리기
     * @param list
     * @param pageInfo
     * @returns {*[]}
     */
    function createAsmtListHTML(list, pageInfo) {
        let dataList = [];

        if (!list || list.length === 0) {
            return dataList;
        }

        list.forEach(function (v, i) {
            const lineNo = pageInfo.totalRecordCount - v.lineNo + 1;
            const asmtId = v.asmtId || "";
            const trgtCnt = Number(v.trgtCnt || 0);
            const sbmsnCnt = Number(v.sbmsnCnt || 0);
            const evlCnt = Number(v.evlCnt || 0);
            const resbmsnCnt = Number(v.resbmsnCnt || 0);

            // 과제제목 - 상세 이동 링크
            const asmtTtl = (v.asmtTtl || "").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll('"', "&quot;");
            const startAsmtViewLink = "<a href='#0' class='link' onclick='moveAsmtView(\"" + asmtId + "\"); return false;'>"
            const endAsmtViewLink = "</a>";
            const linkAsmtTtl = startAsmtViewLink + asmtTtl + endAsmtViewLink;

            dataList.push({
                no: lineNo
                , asmtGbnnm: v.asmtGbnnm
                , asmtTtl: linkAsmtTtl
                , sbmsnPeriod: UiComm.formatDate(v.asmtSbmsnSdttm, "datetime2") + " ~ " + UiComm.formatDate(v.asmtSbmsnEdttm, "datetime2")
                , extdSbmsnEdttm: v.extdSbmsnEdttm ? UiComm.formatDate(v.extdSbmsnEdttm, "datetime2") : "-"
                , mrkRfltrt: createMrkRfltrtHtml(v)
                , sbmsnStts: startAsmtViewLink + sbmsnCnt + "/" + trgtCnt + endAsmtViewLink
                , evlStts: startAsmtViewLink + evlCnt + "/" + trgtCnt + endAsmtViewLink
                , resbmsn: resbmsnCnt + "<spring:message code='asmt.label.person'/><%--명--%>"
                , sbmsnCntBar: sbmsnCnt + "<spring:message code='asmt.label.person'/><%--명--%>"
                , nonSbmsnCntBar: Math.max(trgtCnt - sbmsnCnt, 0) + "<spring:message code='asmt.label.person'/><%--명--%>"
                , valAsmtId: v.valAsmtId
            });
        });

        return dataList;
    }

    /**
     * 페이지이동
     * @param pageIndex
     */
    function listPaging(pageIndex) {
        SEARCH_VALUE = $("#searchValue").val();

        const extData = {
            orgId: ORG_ID
            , pageIndex: pageIndex
            , listScale: LIST_SCALE
            , searchValue: SEARCH_VALUE
            , sbjctId: SBJCT_ID
        };

        const url = "/asmt2/profAsmtListAjax.do";
        const param = {
            encParams: EPARAM
            , addParams: UiComm.makeEncParams(extData)
        };

        ajaxCall(url, param, function (data) {
            if (data.encParams != null && data.encParams != '') {
                EPARAM = data.encParams;
            }

            if (data.result > 0) {
                let returnList = data.returnList || [];

                // 테이블 데이터 설정
                let dataList = createAsmtListHTML(returnList, data.pageInfo);
                asmtListTable.clearData();
                asmtListTable.replaceData(dataList);
                asmtListTable.setPageInfo(data.pageInfo);
            } else {
                UiComm.showMessage(data.message, "error");
            }

        }, function (xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);

    }

    /*
    ==========================
    ========성적반영비율========
    ==========================
    */

    let scoreInputMode = false; // 성적비율 입력 모드

    /**
     * 리스트테이블에서 모드 변경 이벤트
     * @param mode card / list
     */
    function changeModeEvent(mode) {
        if (mode === "card") {
            mrkRfltrtFrmTrsf(2);
            return;
        }
        if (scoreInputMode) {
            mrkRfltrtFrmTrsf(1);
        }
    }

    /**
     * 성적 반영비율 입력모드 전환
     * @param {Integer} type 1: 입력모드, 2: 일반모드
     */
    function mrkRfltrtFrmTrsf(type) {
        // 성적반영비율 입력필드 표시
        if (type === 1) {
            // list 모드로 변경
            if (asmtListTable.mode !== "list") {
                asmtListTable.changeMode("list");

                setTimeout(function () {
                    mrkRfltrtFrmTrsf(1);
                }, 100);
                return;
            }

            $("#mrkRfltrtFrmTrsfBtn").hide();
            $(".mrkRfltrtFrmTrsfDiv").css("display", "inline-block");
            $(".mrkInputDiv").show();
            $(".mrkRfltrtDiv").hide();

            UiInputmask();
            scoreInputMode = true;
            return;
        }

        $("#mrkRfltrtFrmTrsfBtn").css("display", "inline-block");
        $(".mrkRfltrtFrmTrsfDiv").hide();
        $(".mrkInputDiv").hide();
        $(".mrkRfltrtDiv").show();

        scoreInputMode = false;
    }

    /**
     * 성적반영비율 저장
     */
    function mrkRfltrtModify() {
        let sumMrkRfltrt = 0;
        let asmtArray = [];
        let mrkRfltrtArray = [];
        let isValid = true;

        $(".mrkRfltrt").each(function () {
            const $input = $(this);
            const value = $.trim($input.val());
            const numValue = Number(value);

            if (value === "" || isNaN(numValue)) {
                UiComm.showMessage("<spring:message code='asmt.alert.input.score.ratio'/><%--성적반영비율을 입력하세요.--%>", "info");
                $input.focus();
                isValid = false;
                return false;
            }

            if (numValue < 0 || numValue > 100) {
                UiComm.showMessage("<spring:message code='asmt.alert.score.ratio.range'/><%--성적반영비율은 0~100까지만 입력 가능합니다.--%>", "info");
                $input.focus();
                isValid = false;
                return false;
            }

            sumMrkRfltrt += numValue;

            asmtArray.push($input.attr("data-asmtId"));
            mrkRfltrtArray.push(numValue);
        });

        if (!isValid) {
            return;
        }

        if (sumMrkRfltrt !== 100) {
            UiComm.showMessage("<spring:message code='asmt.alert.score.ratio.sum100'/><%--성적반영비율 합이 100%가 되어야 합니다.--%> [<spring:message code='asmt.label.current'/><%--현재--%>: " + sumMrkRfltrt + "]", "info");
            return;
        }

        const param = {
            asmtArray: asmtArray
            , mrkRfltrtArray: mrkRfltrtArray
        }

        ajaxCall("/asmt2/profMrkRfltrtModifyAjax.do", param, function (data) {
            if (data.encParams != null && data.encParams != '') {
                EPARAM = data.encParams;
            }
            if (data.result > 0) {
                UiComm.showMessage(data.message || "<spring:message code='asmt.alert.save.success'/><%--정상적으로 저장되었습니다.--%>", "success");
                mrkRfltrtFrmTrsf(2);
                listPaging(1);
            } else {
                UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>", "error");
            }
        }, function () {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    /**
     * 성적반영비율 html 생성
     * @param v 과제정보
     * @returns {string}
     */
    function createMrkRfltrtHtml(v) {
        const asmtId = v.asmtId || "";
        const mrkRfltrt = v.mrkRfltrt == null ? 0 : v.mrkRfltrt;
        const asmtGbncd = v.asmtGbncd || "";

        if (v.mrkRfltyn === "N") {
            return "-";
        }

        // 대체과제는 조정 합산 대상에서 제외한다.
        if (asmtGbncd.indexOf("SBST") > -1) {
            return mrkRfltrt + "%";
        }

        let html = "";
        html += "<span class='mrkInputDiv ui input' style='display:none'>";
        html += "<input type='text' class='mrkRfltrt' data-asmtId='" + asmtId + "' value='" + mrkRfltrt + "' inputmask='numeric' inputmode='decimal' maxVal='100' />";
        html += "</span>";
        html += "<span class='mrkRfltrtDiv'>" + mrkRfltrt + "%</span>";

        return html;
    }


    // list scale 변경
    function changeListScale(scale) {
        LIST_SCALE = scale;
        listPaging(1);
    }

    /**
     * 과제 삭제
     * @param asmtId
     */
    function deleteAsmt(asmtId) {

    }

    /*
        ==========================
        ========화면이동========
        ==========================
    */
    /**
     * 과제등록화면 이동
     */
    function moveAsmtRegistView() {
        const extData = {
            sbjctId: SBJCT_ID,
            asmtId: ""
        };
        const kvArr = [];
        kvArr.push({'key': 'encParams', 'val': EPARAM});
        kvArr.push({'key': 'addParams', 'val': UiComm.makeEncParams(extData)});

        submitForm("/asmt2/profAsmtRegistView.do", "", kvArr);
    }

    /**
     * 과제상세화면 이동
     * @param asmtId
     * @param tab
     */
    function moveAsmtView(asmtId) {
        const extData = {
            sbjctId: SBJCT_ID,
            asmtId: asmtId
        };
        const kvArr = [];
        kvArr.push({'key': 'encParams', 'val': EPARAM});
        kvArr.push({'key': 'addParams', 'val': UiComm.makeEncParams(extData)});

        submitForm("/asmt2/profAsmtEvlMngView.do", "", kvArr);

    }

    /**
     * 과제 수정화면 이동
     * @param asmtId
     */
    function moveAsmtModifyView(asmtId) {
        const extData = {
            sbjctId: SBJCT_ID,
            asmtId: asmtId
        };
        const kvArr = [];
        kvArr.push({'key': 'encParams', 'val': EPARAM});
        kvArr.push({'key': 'addParams', 'val': UiComm.makeEncParams(extData)});

        submitForm("/asmt2/profAsmtModifyView.do", "", kvArr);
    }


</script>
</body>
</html>

