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
                                    {title: "<spring:message code='common.label.org.lmsopt'/>",  field: "optnBtn", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120}

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
                                        optnBtn: `<button class="btn basic small settingBtn" onclick="openOptnStngPop('\${item.orgId}')"><spring:message code='button.label'/></button>`

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
                                <input type="hidden" id="orgId" value=""/>
                                <div class="table-wrap">
                                    <table class="table-type1">
                                        <colgroup>
                                            <col style="width:7%">
                                            <col style="width:15%">
                                            <col style="width:15%">
                                            <col style="width:15%">
                                            <col style="">
                                        </colgroup>
                                        <thead>
                                        <tr>
                                            <th>번호</th>
                                            <th>옵션코드</th>
                                            <th>옵션명</th>
                                            <th>값</th>
                                            <th></th>
                                        </tr>
                                        </thead>
                                        <tbody id="optnList">
                                            <tr>
                                                <th>1</th>
                                                <td class="t_left" id="">OPTN0001</td>
                                                <input type="hidden" id="ORG_STNG_ID_001"/>
                                                <td class="t_left" id="">학사변동</td>
                                                <td class="t_left" id="">옵션값</td>
                                                <td class="t_left" id="">
                                                    <div class="form-inline">
                                                        <span class="custom-input">
                                                            <input type="radio" name="OPTN0001" id="acdStatusY" value="Y" checked="">
                                                            <label for="acdStatusY">사용</label>
                                                        </span>
                                                        <span class="custom-input ml5">
                                                            <input type="radio" name="OPTN0001" id="acdStatusN" value="N">
                                                            <label for="acdStatusN">사용 안 함</label>
                                                        </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th rowspan="2">2</th>
                                                <input type="hidden" id="ORG_STNG_ID_002"/>
                                                <td rowspan="2" class="t_left">OPTN0002</td>
                                                <td rowspan="2" class="t_left">통합 SSO</td>
                                                <td class="t_left">옵션값</td>
                                                <td class="t_left">
                                                    <div class="form-inline">
                                                        <span class="custom-input">
                                                            <input type="radio" name="OPTN0002" id="ssoY" value="Y" checked="">
                                                            <label for="ssoY">URL링크</label>
                                                        </span>
                                                        <span class="custom-input ml5">
                                                            <input type="radio" name="OPTN0002" id="ssoN" value="N">
                                                            <label for="ssoN">사용 안함</label>
                                                        </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="t_left">URL</td>
                                                <td class="t_left">
                                                    <input type="text" id="sso_url" style="width:90%">
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>3</th>
                                                <input type="hidden" id="ORG_STNG_ID_003"/>
                                                <td class="t_left" id="">OPTN0003</td>
                                                <td class="t_left" id="">다국어</td>
                                                <td class="t_left" id="">옵션값</td>
                                                <td class="t_left" id="">
                                                    <div class="checkbox_type">
                                                        <span class="custom-input">
                                                            <input type="checkbox" name="langcd" id="lang_ko" value="ko">
                                                            <label for="lang_ko">한국어</label>
                                                        </span>
                                                        <span class="custom-input">
                                                            <input type="checkbox" name="langcd" id="lang_en" value="en">
                                                            <label for="lang_en">영어</label>
                                                        </span>
                                                        <span class="custom-input">
                                                            <input type="checkbox" name="langcd" id="lang_ch" value="ch">
                                                            <label for="lang_ch">중국어</label>
                                                        </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>4</th>
                                                <input type="hidden" id="ORG_STNG_ID_004"/>
                                                <td class="t_left" id="">OPTN0004</td>
                                                <td class="t_left" id="">1일 수강 제한</td>
                                                <td class="t_left" id="">옵션값</td>
                                                <td class="t_left" id="">
                                                    <input type="text" id="OPTN0004" style="width:100px" inputmask="numeric" maxVal="100"> %
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="modal_btns">
                                    <button type="button" class="btn type1" onclick="onSave()">저장</button>
                                    <button type="button" class="btn type2 modalClose">닫기</button>
                                </div>
                            </div>
                        </div>
                    </div>

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
    let dialog;

    // LMS옵션설정 팝업 열기
    function openOptnStngPop(orgId) {
        $.ajax({
            url: "/org/orgMgr/admOrgLmsOptnStngAjax.do",
            data: {orgId: orgId},
            type: "GET",
            headers: {"X-Requested-With": "XMLHttpRequest"},
            success: function (data) {
                if (data.result > 0) {
                    const returnMap = data.returnVO;

                    // -- 학사연동
                    if (returnMap["OPTN0001"]) {
                        const val = returnMap["OPTN0001"].stngVl; // Y or N
                        $(`input[name='OPTN0001'][value='\${val}']`).prop("checked", true);
                        $("#ORG_STNG_ID_001").val(returnMap["OPTN0001"].orgStngId);
                    }

                    // -- 통합 SSO
                    if(returnMap["OPTN0002"]) {
                        const ssoObj = JSON.parse(returnMap["OPTN0002"].stngVl);
                        const useyn = ssoObj.useyn;
                        const url = ssoObj.url || "";
                        $("#ORG_STNG_ID_002").val(returnMap["OPTN0002"].orgStngId);

                        $(`input[name='OPTN0002'][value='\${useyn}']`).prop("checked", true);
                        $("#sso_url").val(url);

                        // 사용 여부가 'Y'일 때만 URL 입력창 활성화
                        $("#sso_url").prop("disabled", useyn !== 'Y');
                    }

                    // -- 다국어
                    if(returnMap["OPTN0003"]) {
                        const langObj = JSON.parse(returnMap["OPTN0003"].stngVl);
                        $("#lang_ko").prop("checked", langObj.ko === 'Y');
                        $("#lang_en").prop("checked", langObj.en === 'Y');
                        $("#lang_ch").prop("checked", langObj.ch === 'Y');

                        $("#ORG_STNG_ID_003").val(returnMap["OPTN0003"].orgStngId);
                    }

                    // --- 4. 1일 수강 제한 (기존과 동일) ---
                    if(returnMap["OPTN0004"]) {
                        $("#OPTN0004").val(returnMap["OPTN0004"].stngVl);
                        $("#ORG_STNG_ID_004").val(returnMap["OPTN0004"].orgStngId);
                    }

                    $("#orgId").val(orgId);

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

    // 설정 저장
    function onSave() {
        UiComm.showLoading(true);

        // 다국어 객체화
        const langObj = {
            ko: $("#lang_ko").is(":checked") ? "Y" : "N",
            en: $("#lang_en").is(":checked") ? "Y" : "N",
            ch: $("#lang_ch").is(":checked") ? "Y" : "N"
        }

        // 통합SSO 객체화
        const ssoObj = {
            useyn : $("input[name='OPTN0002']:checked").val(),
            url: $("input[name='OPTN0002']:checked").val() == 'Y' ? $("#sso_url").val() || "" : ""
        }

        // 옵션 목록
        const stngList = [
            {
                orgId:  $("#orgId").val(),
                orgStngId: $("#ORG_STNG_ID_001").val(),
                stngCd: "OPTN0001",
                stngVl: $("input[name='OPTN0001']:checked").val()
            },
            {
                orgId:  $("#orgId").val(),
                orgStngId: $("#ORG_STNG_ID_002").val(),
                stngCd: "OPTN0002",
                stngVl: JSON.stringify(ssoObj),
                stngExpln: $("#sso_url").val() // URL은 설명 컬럼에 저장
            },
            {
                orgId:  $("#orgId").val(),
                orgStngId: $("#ORG_STNG_ID_003").val(),
                stngCd: "OPTN0003",
                stngVl: JSON.stringify(langObj) // 객체 -> 문자열 "{"ko":"Y",...}" 변환
            },
            {
                orgId:  $("#orgId").val(),
                orgStngId: $("#ORG_STNG_ID_004").val(),
                stngCd: "OPTN0004",
                stngVl: $("#OPTN0004").val()
            }
        ]

        const param = {
            encParams: EPARAM,
            orgId    : $("#orgId").val(),
            stngListStr : JSON.stringify(stngList)
        }

        // console.log("교수 전송 데이터:", profWidgets);
        $.ajax({
            url: "/org/orgMgr/admOrgLmsOptnStngModify.do",
            // data: JSON.stringify(param),
            data: param,
            type: "POST",
            headers: {"X-Requested-With": "XMLHttpRequest"},
            // contentType: "application/json", // 중요: JSON 형태로 보낼 때 필수
            success: function (data) {
                if (data.encParams != null && data.encParams !== '') {
                    EPARAM = data.encParams;
                }
                if (data.result > 0) {
                    UiComm.showMessage(data.message).then(function () {
                        $(".modalClose").click();
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
            const $modal = $("#modal1");

            // 활성화되있는 모달이 없다면 패스
            if (!$modal.hasClass("active")) return;

            // 2. 클릭된 대상 확인
            const $target = $(e.target);

            if (
                $target.hasClass("modal-overlay") || // 배경클릭
                $target.closest(".modal-close").length > 0 || // 닫기 아이콘을 클릭
                $target.hasClass("modalClose") // 하단 닫기 버튼 클릭
            ) {
                $modal.removeClass("active");
                $modal.attr("aria-hidden", "true");

                // 3. 바디 스크롤 복구
                $("body").css("overflow", "");
            }
        });
    }

    // 사용유무 클릭 이벤트 바인딩
    function bindUseYnClick() {
        $("input[name='OPTN0002']").on("change", function() {
            const selectedVal = $(this).val(); // 선택된 값 (Y 또는 N)

            if (selectedVal === "N") {
                $("#sso_url").prop("disabled", true).val("");
            } else {
                $("#sso_url").prop("disabled", false);
            }
        });
    }

</script>

</body>
</html>

