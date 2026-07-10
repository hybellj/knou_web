<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>

<script type="text/javascript">
    let LIST_SCALE = '<c:out value="${vo.listScale}" />';
    let PAGE_INDEX = '<c:out value="${vo.pageIndex}" />';
    let EPARAM = '<c:out value="${encParams}" />';

    // list scale 변경
    function changeListScale(scale) {
        LIST_SCALE = scale;
        listPaging(1);
    }
</script>

<body class="admin">
<div id="wrap" class="main">
    <!-- common header -->
    <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>
    <!-- //common header -->

    <!-- admin -->
    <main class="common">

        <!-- gnb -->
        <%@ include file="/WEB-INF/jsp/common_new/admin_aside.jsp" %>
        <!-- //gnb -->

        <!-- content -->
        <div id="content" class="content-wrap common">
            <div class="admin_sub">

                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                        <uiex:navibar type="admin"/>
                    </div>

                    <!-- search typeA -->
                    <div class="search-typeA">
                        <div class="item">
                            <span class="item_tit"><label for="selectSearch">검색어</label></span>
                            <div class="itemList">
                                <input class="form-control wide" type="text" name="searchValue" id="searchValue" value="" placeholder="기관ID / 기관명 / 담당자입력">
                            </div>
                        </div>
                        <div class="button-area">
                            <button type="button" class="btn search" onclick="listPaging(1)">검색</button>
                        </div>
                    </div>

                    <!-- board top -->
                    <div class="board_top">
                        <h3 class="board-title"><spring:message code="common.button.list"/><%-- 목록 --%></h3>
                        <div class="right-area">
                            <uiex:listScale func="changeListScale" value="${vo.listScale}" />
                        </div>
                    </div>

                    <!--table-type-->
                    <div class="table-wrap">
                        <div id="orgList"> </div>

                        <script type="text/javascript">
                            let orgListTable;

                            $(function () {
                                let cols = [
                                    {title: "<spring:message code='common.no'/>", field: "no", headerHozAlign:"center", hozAlign:"center", width: 50, minWidth: 50},
                                    {title: "<spring:message code='common.label.org.id'/>",  field: "orgId", headerHozAlign: "center", hozAlign: "center", width: 130, minWidth: 130},
                                    {title: "<spring:message code='common.label.org.name.full'/>",  field: "orgnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 150},
                                    {title: "<spring:message code='common.label.org.name.short'/>", field: "orgShrtnm", headerHozAlign:"center", hozAlign:"center", width: 150, minWidth: 150},
                                    {title: "<spring:message code='common.label.org.chrgr.nm'/>",  field: "chrgrnm", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120},
                                    {title: "<spring:message code='common.label.org.chrgr.nm'/> <spring:message code='common.label.contact.info'/>",  field: "chrgrCntct", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120},
                                    {title: "<spring:message code='common.label.org.chrgr.nm'/> <spring:message code='common.email'/>",  field: "chrgrEml", headerHozAlign: "center", hozAlign: "left", width: 250, minWidth: 250},
                                    {title: "<spring:message code='common.label.org.lmsopt'/>",  field: "manageBtn", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120}

                                ];

                                orgListTable = UiTable("orgList", {
                                    lang: "ko",
                                    table: "list",
                                    columns: cols,    // 컬럼정보
                                    pageFunc: listPaging,
                                });

                                listPaging(1);
                            });

                            // 기관정보 페이징 목록 조회
                            function listPaging(pageIndex) {
                                UiComm.showLoading(true);

                                PAGE_INDEX = pageIndex;

                                let extData = {
                                    searchValue : $("#searchValue").val(),
                                    pageIndex: pageIndex,
                                    listScale: LIST_SCALE
                                };
                                let param = {
                                    encParams: EPARAM,
                                    addParams: UiComm.makeEncParams(extData)
                                };

                                $.ajax({
                                    url: "/org/orgMgr/admOrgListAjax.do",
                                    data: param,
                                    type: "GET",
                                    headers: {"X-Requested-With": "XMLHttpRequest"},
                                    success: function (data) {
                                        if (data.encParams != null && data.encParams !== '') {
                                            EPARAM = data.encParams;
                                        }

                                        if (data.result > 0) {
                                            let returnList = data.returnList || [];

                                            // 테이블 데이터 세팅
                                            let dataList = createListHTML(returnList, data.pageInfo);
                                            orgListTable.clearData();
                                            orgListTable.replaceData(dataList);
                                            orgListTable.setPageInfo(data.pageInfo);

                                            $("#totCnt").text(data.pageInfo.totalRecordCount);
                                        } else {
                                            UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
                                        }
                                    },
                                    error: function(xhr, status, error) {
                                        UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
                                    },
                                    complete: function (){
                                        UiComm.showLoading(false);
                                    }
                                });
                            }

                            // 테이블 그리기
                            function createListHTML(list, pageInfo) {
                                let dataList = [];

                                list.forEach(item => {
                                    dataList.push({
                                        // no: item.lineNo,
                                        no: pageInfo.totalRecordCount - item.lineNo + 1,
                                        orgId: item.orgId,
                                        orgnm: item.orgnm,
                                        orgShrtnm: item.orgShrtnm,
                                        orgTycd: item.orgTycd,
                                        chrgrnm: item.chrgrnm,
                                        chrgrCntct: setTelNo(item.chrgrCntct),
                                        chrgrEml: item.chrgrEml,
                                        manageBtn: `<button class="btn basic small settingBtn" onclick="openHaksaLinkManagePop('\${item.orgId}')"><spring:message code='common.label.org.acad'/></button>`

                                    })
                                });

                                return dataList;
                            }

                            // 전화번호 나누기
                            function setTelNo(telNo) {
                                let len = telNo.length;
                                let part1 = "";
                                let part2 = "";
                                let part3 = "";

                                // 앞자리 구분 (서울 02는 2자리, 나머지는 3자리)
                                let prefixLen = telNo.startsWith("02") ? 2 : 3;

                                // 자르기
                                part1 = telNo.substring(0, prefixLen);         // 지역번호/010
                                part2 = telNo.substring(prefixLen, len - 4);   // 국번 (가운데 전부)
                                part3 = telNo.substring(len - 4);              // 뒷번호 (끝 4자리)

                                return part1 + "-" + part2 + "-" + part3;
                            }
                        </script>
                    </div>
                    <!--//table-type-->

                    <%-- modal1 --%>
                    <div class="modal-overlay" id="modal1" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
                        <div class="modal-content modal-lg" tabindex="-1">
                            <div class="modal-header">
                                <h2 id="modal1Title"><spring:message code="common.label.org.lmsopt"/></h2>
                                <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                            </div>
                            <div class="modal-body">
                                <div class="msg-box">
                                    <p class="txt">LMS 옵션설정에서 학사연동 사용일 경우에 학사연동 관리합니다.</p>
                                </div>
                                <input type="hidden" id="orgId" value=""/>
                                <div class="table-wrap">
                                    <table class="table-type2" id="aisLinkList">
                                        <colgroup>
                                            <col style="">
                                            <col style="width:20%">
                                        </colgroup>
                                        <thead>
                                            <tr>
                                                <th>항목</th>
                                                <th>학사연동</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td class="t_left">
                                                    <div class="haksa_option">
                                                        <button class="btn basic small haksa_btn" onclick="openHaksaLinkModifyPop(this)">학과/부서 정보<i class="icon-svg-yes"></i></button>
                                                        <span>1. 학과/부서 정보를 연동 합니다.</span>
                                                    </div>
                                                </td>
                                                <td>Y</td>
                                            </tr>
                                            <tr>
                                                <td class="t_left">
                                                    <div class="haksa_option">
                                                        <button class="btn basic small haksa_btn" onclick="openHaksaLinkModifyPop(this)">학기/주차 정보<i class="icon-svg-yes"></i></button>
                                                        <span>2. 학기/주차(학습목차기간) 정보를 연동 합니다.</span>
                                                    </div>
                                                </td>
                                                <td>Y</td>
                                            </tr>
                                            <tr>
                                                <td class="t_left">
                                                    <div class="haksa_option">
                                                        <button class="btn basic small haksa_btn" onclick="openHaksaLinkModifyPop(this)">강의계획서 정보<i class="icon-svg-yes"></i></button>
                                                        <span>3. 개설과목의 강의계획서 정보를 연동합니다.</span>
                                                    </div>
                                                </td>
                                                <td><span class="fcRed">N</span></td>
                                            </tr>
                                            <tr>
                                                <td class="t_left">
                                                    <div class="haksa_option">
                                                        <button class="btn basic small haksa_btn" onclick="openHaksaLinkModifyPop(this)">학습목차(저작도구)<i class="icon-svg-yes"></i></button>
                                                        <span>4. 개설과목의 학습목차(저작도구)를 연동합니다.</span>
                                                    </div>
                                                </td>
                                                <td>Y</td>
                                            </tr>
                                            <tr>
                                                <td class="t_left">
                                                    <div class="haksa_option">
                                                        <button class="btn basic small haksa_btn" onclick="openHaksaLinkModifyPop(this)">강의노트<i class="icon-svg-yes"></i></button>
                                                        <span>5. 개설과목의 강의노트 정보를 연동합니다.</span>
                                                    </div>
                                                </td>
                                                <td>Y</td>
                                            </tr>
                                            <tr>
                                                <td class="t_left">
                                                    <div class="haksa_option">
                                                        <button class="btn basic small haksa_btn" onclick="openHaksaLinkModifyPop(this)">개설과목 정보<i class="icon-svg-yes"></i></button>
                                                        <span>6. 개설과목 정보를 연동합니다.</span>
                                                    </div>
                                                </td>
                                                <td>Y</td>
                                            </tr>
                                            <tr>
                                                <td class="t_left">
                                                    <div class="haksa_option">
                                                        <button class="btn basic small haksa_btn" onclick="openHaksaLinkModifyPop(this)">평가비중 정보<i class="icon-svg-yes"></i></button>
                                                        <span>7. 개설과목의 평가비중 정보를 연동합니다.</span>
                                                    </div>
                                                </td>
                                                <td>Y</td>
                                            </tr>
                                            <tr>
                                                <td class="t_left">
                                                    <div class="haksa_option">
                                                        <button class="btn basic small haksa_btn" onclick="openHaksaLinkModifyPop(this)">콘텐츠 정보<i class="icon-svg-yes"></i></button>
                                                        <span>8. 개설과목의 콘텐츠 정보를 연동합니다. ( CMS 연동 )</span>
                                                    </div>
                                                </td>
                                                <td>Y</td>
                                            </tr>
                                            <tr>
                                                <td class="t_left">
                                                    <div class="haksa_option">
                                                        <button class="btn basic small haksa_btn" onclick="openHaksaLinkModifyPop(this)">강의맛보기 정보<i class="icon-svg-yes"></i></button>
                                                        <span>9. 개설과목의 강의맛보기 정보를 연동합니다. </span>
                                                    </div>
                                                </td>
                                                <td>Y</td>
                                            </tr>
                                            <tr>
                                                <td class="t_left">
                                                    <div class="haksa_option">
                                                        <button class="btn basic small haksa_btn" onclick="openHaksaLinkModifyPop(this)">교수/공동교수 정보<i class="icon-svg-yes"></i></button>
                                                        <span>10. 사용자 정보 중 교수/공동교수 정보를 연동합니다.</span>
                                                    </div>
                                                </td>
                                                <td>Y</td>
                                            </tr>
                                            <tr>
                                                <td class="t_left">
                                                    <div class="haksa_option">
                                                        <button class="btn basic small haksa_btn" onclick="openHaksaLinkModifyPop(this)">튜터 정보<i class="icon-svg-yes"></i></button>
                                                        <span>11. 사용자 정보 중 튜터 정보를 연동합니다.</span>
                                                    </div>
                                                </td>
                                                <td>Y</td>
                                            </tr>
                                            <tr>
                                                <td class="t_left">
                                                    <div class="haksa_option">
                                                        <button class="btn basic small haksa_btn" onclick="openHaksaLinkModifyPop(this)">조교 정보<i class="icon-svg-yes"></i></button>
                                                        <span>12. 사용자 정보 중 조교 정보를 연동합니다.</span>
                                                    </div>
                                                </td>
                                                <td>Y</td>
                                            </tr>
                                            <tr>
                                                <td class="t_left">
                                                    <div class="haksa_option">
                                                        <button class="btn basic small haksa_btn" onclick="openHaksaLinkModifyPop(this)">수강생 정보<i class="icon-svg-yes"></i></button>
                                                        <span>13. 사용자 정보 중 수강생 정보를 연동합니다.</span>
                                                    </div>
                                                </td>
                                                <td>Y</td>
                                            </tr>
                                            <tr>
                                                <td class="t_left">
                                                    <div class="haksa_option">
                                                        <button class="btn basic small haksa_btn" onclick="openHaksaLinkModifyPop(this)">기타사용자 정보<i class="icon-svg-yes"></i></button>
                                                        <span>14. 사용자 정보 중 기타 사용자 정보를 연동합니다.</span>
                                                    </div>
                                                </td>
                                                <td>Y</td>
                                            </tr>
                                            <tr>
                                                <td class="t_left">
                                                    <div class="haksa_option">
                                                        <button class="btn basic small haksa_btn" onclick="openHaksaLinkModifyPop(this)">학습자 정보<i class="icon-svg-yes"></i></button>
                                                        <span>15. 사용자 정보 중 학습자 정보를 연동합니다.</span>
                                                    </div>
                                                </td>
                                                <td>Y</td>
                                            </tr>
                                            <tr>
                                                <td class="t_left">
                                                    <div class="haksa_option">
                                                        <button class="btn basic small haksa_btn" onclick="openHaksaLinkModifyPop(this)">강의평가<i class="icon-svg-yes"></i></button>
                                                        <span>16. 강의평가를 연동합니다.</span>
                                                    </div>
                                                </td>
                                                <td>Y</td>
                                            </tr>
                                            <tr>
                                                <td class="t_left">
                                                    <div class="haksa_option">
                                                        <button class="btn basic small haksa_btn" onclick="openHaksaLinkModifyPop(this)">수업업무일정 정보<i class="icon-svg-yes"></i></button>
                                                        <span>17. 수업업무일정 정보를 연동합니다.</span>
                                                    </div>
                                                </td>
                                                <td>Y</td>
                                            </tr>
                                            <tr>
                                                <td class="t_left">
                                                    <div class="haksa_option">
                                                        <button class="btn basic small haksa_btn" onclick="openHaksaLinkModifyPop(this)">시험시스템 정보<i class="icon-svg-yes"></i></button>
                                                        <span>18. 시험시스템 정보를 연동합니다.</span>
                                                    </div>
                                                </td>
                                                <td>Y</td>
                                            </tr>
                                            <tr>
                                                <td class="t_left">
                                                    <div class="haksa_option">
                                                        <button class="btn basic small haksa_btn" onclick="openHaksaLinkModifyPop(this)">종합성적 정보<i class="icon-svg-yes"></i></button>
                                                        <span>19. 종합성적 정보를 연동합니다.</span>
                                                    </div>
                                                </td>
                                                <td>Y</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="modal_btns">
                                    <button type="button" class="btn type2 modalClose">닫기</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%-- //modal1 --%>

                    <%-- modal2 --%>
                    <div class="modal-overlay" id="modal2" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal2Title" >
                        <div class="modal-content modal-md" tabindex="-1">
                            <div class="modal-header">
                                <h2 id="modal2Title"><spring:message code="common.label.org.lmsopt"/></h2>
                                <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                            </div>
                            <div class="modal-body">
                                <div class="table-wrap">
                                    <table class="table-type2" id="aisLinkDetail">
                                        <colgroup>
                                            <col style="">
                                            <col style="width:15%">
                                            <col style="width:60%">
                                        </colgroup>
                                        <thead>
                                            <tr>
                                                <th>구분</th>
                                                <th colspan="2">값</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td class="t_left">학사연동 옵션코드</td>
                                                <td class="t_left" colspan="2" name="aisLinkTycd"></td>
                                                <input type="hidden" id="aisLinkTycd">
                                            </tr>
                                            <tr>
                                                <td class="t_left" rowspan="2" name="aisLinkTynm"></td>
                                                <td class="t_left">사용여부</td>
                                                <td class="t_left">
                                                    <div class="form-inline">
                                                        <span class="custom-input">
                                                            <input type="radio" name="autoLinkyn" id="useY" value="Y">
                                                            <label for="useY">사용</label>
                                                        </span>
                                                        <span class="custom-input ml5">
                                                            <input type="radio" name="autoLinkyn" id="useN" value="N">
                                                            <label for="useN">사용 안 함</label>
                                                        </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="t_left">URL</td>
                                                <td><input type="text" id="manlUrl" style="width:100%"></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <div class="modal_btns">
                                        <button type="button" class="btn type1" onclick="onSave()">저장</button>
                                        <button type="button" class="btn type2 modalClose">닫기</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%-- //modal2 --%>

                </div>
            </div>

        </div>
        <!-- //content -->

    </main>
    <!-- //admin-->

</div>
<script type="text/javascript">
    $(function () {
        modalCloseEventBind();
        bindUseYnClick();
    })

    // 학사연동관리 팝업 열기
    function openHaksaLinkManagePop(orgId) {
        const url = "/org/orgMgr/admOrgAisLinkListAjax.do";
        const param = {
            encParams: EPARAM,
            orgId: orgId
        };
        $.ajax({
            url: url,
            data: param,
            type: "GET",
            headers: {"X-Requested-With": "XMLHttpRequest"},
            success: function (data) {
                if (data.result > 0) {
                    $("#orgId").val(orgId);

                    const returnList = data.returnList || [];

                    returnList.forEach((item, i) => {
                        const $targetRow = $('#aisLinkList tbody tr').eq(i); // i번째 tr 찾기
                        const rowData = {
                            btnLabel: item.autoLinkyn === 'Y' ? "YES" : "NO",
                            status: item.autoLinkyn,
                            aisLinkTycd: item.aisLinkTycd
                        }

                        updateRowData($targetRow, rowData);
                    });

                    // 모달 열기
                    $("#modal1").addClass("active");
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            },
            error: function(xhr, status, error) {
                UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
            }
        });
    }

    // 학사연동목록 데이터 변경
    function updateRowData($row, data) {
        const $btn = $row.find('.haksa_btn'); // 학사연동 상세정보 버튼 찾기
        const $icon = $btn.find('i');   // 버튼 내 i태그

        $btn.attr("data-aislinktycd", data.aisLinkTycd);

        // 마지막 td 태그 내 학사연동 Y/N 변경
        const $statusTd = $row.find('td').last();

        if (data.status === 'N') {
            $icon.attr('class', 'icon-svg-no');
            $statusTd.html('<span class="fcRed">N</span>');
        } else {
            $icon.attr('class', 'icon-svg-yes');
            $statusTd.text(data.status); // 'Y' 등 그 외의 값
            $statusTd.removeClass('fcRed'); // 기존에 span이 있었다면 일반 텍스트로 초기화
        }

    }

    // 학사연동 정보 수정 팝업 열기
    function openHaksaLinkModifyPop(element) {
        const aisLinkId = element.dataset.aislinktycd;
        const orgId = $("#orgId").val();

        const url = "/org/orgMgr/admOrgAisLinkDetailAjax.do";
        const param = {
            encParams: EPARAM,
            orgId: orgId,
            aisLinkTycd: aisLinkId
        };
        $.ajax({
            url: url,
            data: param,
            type: "GET",
            headers: {"X-Requested-With": "XMLHttpRequest"},
            success: function (data) {
                if (data.result > 0) {
                    const vo = data.returnVO;
                    $("td[name='aisLinkTycd']").text(vo.aisLinkTycd);
                    $("td[name='aisLinkTynm']").text(vo.aisLinkTynm);

                    $(`input[name='autoLinkyn'][value='\${vo.autoLinkyn}']`).attr("checked", true); // 사용여부

                    $("#manlUrl").val(vo.manlUrl);
                    $("#manlUrl").prop("disabled", vo.autoLinkyn !== 'Y'); //사용여부 Y 일때만 URL 입력창 활성화

                    $("#aisLinkTycd").val(vo.aisLinkTycd);
                    $("#orgId").val(orgId);

                    // 모달 열기
                    $("#modal2").addClass("active");
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            },
            error: function(xhr, status, error) {
                UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
            }
        });

    }

    // 설정 저장
    function onSave() {
        UiComm.showLoading(true);

        const autoLinkyn    = $("input[name='autoLinkyn']:checked").val();
        const manlUrl       = autoLinkyn === 'N' ? "" : $("#manlUrl").val();
        const orgId         = $("#orgId").val();

        const param = {
            encParams: EPARAM,
            orgId    : orgId,
            aisLinkTycd: $("#aisLinkTycd").val(),
            autoLinkyn: autoLinkyn,
            manlUrl: manlUrl
        }

        // console.log("교수 전송 데이터:", profWidgets);
        $.ajax({
            url: "/org/orgMgr/admOrgAisLinkDetailModify.do",
            data: param,
            type: "POST",
            headers: {"X-Requested-With": "XMLHttpRequest"},
            success: function (data) {
                if (data.encParams != null && data.encParams !== '') {
                    EPARAM = data.encParams;
                }
                if (data.result > 0) {
                    UiComm.showMessage(data.message).then(function () {
                        openHaksaLinkManagePop(orgId);
                        $("#modal2 .modalClose").click();

                    });
                } else {
                    UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
                }
            },
            error: function(xhr, status, error) {
                UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
            },
            complete: function (){
                UiComm.showLoading(false);
                $("#orgId").val("");
            }
        });
    }

    // 모달 닫기 이벤트 바인딩
    function modalCloseEventBind() {
        document.addEventListener("click", (e) => {
            const $activeModals = $(".modal-overlay.active"); // 활성화된 모든 모달

            // 활성화되있는 모달이 없다면 패스
            if ($activeModals.length === 0) return;

            // "가장 위에 있는(가장 최근에 열린)" 모달을 선택
            const $targetModal = $activeModals.last();
            const $target = $(e.target);

            if (
                $target.hasClass("modal-overlay") || // 배경클릭
                $target.closest(".modal-close").length > 0 || // 닫기 아이콘을 클릭
                $target.hasClass("modalClose") // 하단 닫기 버튼 클릭
            ) {
                $targetModal.removeClass("active");
                $targetModal.attr("aria-hidden", "true");

                // 3. 바디 스크롤 복구
                // $("body").css("overflow", "");
            }
        });
    }

    // 사용유무 클릭 이벤트 바인딩
    function bindUseYnClick() {
        $("input[name='autoLinkyn']").on("change", function() {
            const selectedVal = $(this).val(); // 선택된 값 (Y 또는 N)

            if (selectedVal === "N") {
                $("#manlUrl").prop("disabled", true).val("");
            } else {
                $("#manlUrl").prop("disabled", false);
            }
        });
    }
</script>

</body>
</html>

