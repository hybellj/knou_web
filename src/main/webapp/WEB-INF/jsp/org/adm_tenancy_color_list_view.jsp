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
<style>
    .tabulator {
        overflow: visible !important;
    }

    /* 테이블 본문 영역 전체의 가둠 해제 */
    .tabulator .tabulator-tableholder {
        overflow: visible !important;
    }

    /*!* 행(Row) 단정 가둠 해제 *!*/
    /*.tabulator-row {*/
    /*    overflow: visible !important;*/
    /*}*/

    /* 컬러설정 버튼이 있는 '설정' 셀 영역만 선택해서 가둠 해제 */
    .tabulator-cell[tabulator-field="dsgnColrStngBtn"] {
        overflow: visible !important;
    }

    .dropdown {
        line-height: normal !important;
    }
</style>

<script type="text/javascript">
    let RECORD_COUNT_PER_PAGE = '<c:out value="${pageInfo.recordCountPerPage}" />';
    let CURRENT_PAGE_NO = '<c:out value="${pageInfo.currentPageNo}" />';
    let EPARAM = '<c:out value="${encParams}" />';

    // list scale 변경
    function changeRecoredCnt(scale) {
        RECORD_COUNT_PER_PAGE = scale;
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
                            <uiex:listScale func="changeRecoredCnt" value="${pageInfo.recordCountPerPage}" />
                        </div>
                    </div>

                    <!--table-type-->
                    <div class="table-wrap">
                        <div id="orgTmpltList"> </div>

                        <script type="text/javascript">
                            let orgTmpltListTable;

                            $(function () {
                                let cols = [
                                    {title: "<spring:message code='common.no'/>", field: "no", headerHozAlign:"center", hozAlign:"center", width: 50, minWidth: 50},
                                    {title: "<spring:message code='common.label.org.id'/>",  field: "orgId", headerHozAlign: "center", hozAlign: "center", width: 130, minWidth: 130},
                                    {title: "<spring:message code='common.label.org.name.full'/>",  field: "orgnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 150},
                                    {title: "<spring:message code='common.label.org.name.short'/>", field: "orgShrtnm", headerHozAlign:"center", hozAlign:"center", width: 150, minWidth: 150},
                                    {title: "<spring:message code='common.label.org.chrgr.nm'/>",  field: "chrgrnm", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120},
                                    {title: "<spring:message code='common.label.org.chrgr.nm'/> <spring:message code='common.label.contact.info'/>",  field: "chrgrCntct", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120},
                                    {title: "<spring:message code='common.label.org.chrgr.nm'/> <spring:message code='common.email'/>",  field: "chrgrEml", headerHozAlign: "center", hozAlign: "left", width: 250, minWidth: 250},
                                    {title: "<spring:message code='common.label.org.dsgn'/>",  field: "dsgnColrTycd", headerHozAlign: "center", hozAlign: "center", width:100, minWidth: 100},
                                    {title: "<spring:message code='button.label'/>",  field: "dsgnColrStngBtn", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100}
                                    /*{title: "<spring:message code='common.label.org.dsgn'/>", headerHozAlign: "center", hozAlign: "left", width: 250, minWidth: 250,
                                            columns: [
                                                {field:"dsgnColrTycd", headerHozAlign:"center", hozAlign:"center", width:0, headerSort:false, formatter:"html"},
                                                {field:"dsgnColrStngBtn", headerHozAlign:"center", hozAlign:"center", width:0, headerSort:false, formatter:"html"},
                                            ]
                                        }*/
                                ];

                                orgTmpltListTable = UiTable("orgTmpltList", {
                                    lang: "ko",
                                    table: "list",
                                    columns: cols,    // 컬럼정보
                                    pageFunc: listPaging,
                                });

                                listPaging(1);
                            });

                            // 기관정보 페이징 목록 조회
                            function listPaging(pageNo) {
                                UiComm.showLoading(true);

                                CURRENT_PAGE_NO = pageNo;

                                // let extData = {
                                //     searchValue     : $("#searchValue").val(),
                                //     currentPageNo   : CURRENT_PAGE_NO,
                                //     recordCountPerPage: RECORD_COUNT_PER_PAGE
                                // };
                                //
                                // let param = {
                                //     encParams: EPARAM,
                                //     addParams: UiComm.makeEncParams(extData)
                                // };

                                let param = {
                                    searchValue     : $("#searchValue").val(),
                                    currentPageNo   : CURRENT_PAGE_NO,
                                    recordCountPerPage: RECORD_COUNT_PER_PAGE
                                }

                                $.ajax({
                                    url: "/org/orgMgr/admOrgTmpltListViewAjax.do",
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
                                            let dataList = createListHTML(returnList);
                                            orgTmpltListTable.clearData();
                                            orgTmpltListTable.replaceData(dataList);
                                            orgTmpltListTable.setPageInfo(data.pageInfo);

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
                            function createListHTML(list) {
                                let dataList = [];

                                list.forEach(item => {
                                    dataList.push({
                                        no: item.lineNo,
                                        orgId: item.orgId,
                                        orgnm: item.orgnm,
                                        orgShrtnm: item.orgShrtnm,
                                        orgTycd: item.orgTycd,
                                        chrgrnm: item.chrgrnm,
                                        chrgrCntct: setTelNo(item.chrgrCntct),
                                        chrgrEml: item.chrgrEml,
                                        dsgnColrTycd: setColorChip(item.dsgnColrTycd),
                                        dsgnColrStngBtn: getColorInput(item.dsgnColrTycd, item.orgId)
                                    })
                                });

                                return dataList;
                            }

                            // 드롭다운
                            function toggleDropdown(btn, event) {
                                // 1. 부모 클릭 이벤트 전파 차단 (외부 클릭 시 닫히는 기능 오작동 방지)
                                event.stopPropagation();

                                const $btn = $(btn);
                                const $dropdown = $btn.closest('.dropdown');
                                const $menu = $dropdown.find('.optionWrap');

                                // 2. 다른 열려있는 드롭다운 다 닫기
                                $('.optionWrap.show').not($menu).removeClass('show');

                                // 3. 내 드롭다운 토글
                                $menu.toggleClass('show');
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

                            // 디자인 컬러 클래스 설정
                            function setColorChip(dsgnColrTycd) {
                                let color = "";

                                if (dsgnColrTycd === 'DEFAULT') {
                                    color = "default";
                                } else if(dsgnColrTycd === 'BLUE') {
                                    color = "blue";
                                } else if(dsgnColrTycd === 'MINT') {
                                    color = "mint";
                                } else if(dsgnColrTycd === 'ORANGE') {
                                    color = "orange";
                                } else if(dsgnColrTycd === 'RED') {
                                    color = "red";
                                } else if(dsgnColrTycd === 'PURPLE') {
                                    color = "purple";
                                }

                                return `<p class="sm_circular label \${color}"></p>`;
                            }

                            function getColorInput(dsgnColrTycd, orgId) {

                                // 체크 여부 판단
                                const isChecked = (type) => dsgnColrTycd === type ? 'checked' : '';

                                const colors = [
                                    { id: 'wcolor',     value: 'DEFAULT',   label: '기본'  },
                                    { id: 'wcolorA',    value: 'BLUE',      label: '블루'  }, // wclolrA 오타도 수정
                                    { id: 'wcolorB',    value: 'MINT',      label: '민트'  },
                                    { id: 'wcolorC',    value: 'ORANGE',    label: '오렌지'},
                                    { id: 'wcolorD',    value: 'RED',       label: '레드' },
                                    { id: 'wcolorE',    value: 'PURPLE',    label: '퍼플' }
                                ]

                                let html = `<div class="dropdown">
                                                <button type="button" class="btn basic small settingBtn" onclick="toggleDropdown(this, event)">컬러설정</button>
                                                    <div class="optionWrap option-wrap">
                                                        <div class="tit">컬러설정</div>`;

                                // 루프를 돌며 행별 고유 ID와 Name을 부여하여 조립
                                colors.forEach(color => {
                                    const uniqueId = `\${color.id}_\${orgId}`;
                                    const uniqueName = `wcolor_\${orgId}`;

                                    html += `<div class="item">
                                                <span class="custom-input">
                                                    <input type="radio" name="\${uniqueName}" id="\${uniqueId}" value="\${color.value}" \${isChecked(color.value)}>
                                                    <label for="\${uniqueId}">\${color.label}</label>
                                                </span>
                                            </div>`;
                                });

                                html += `</div>
                                    </div>`;

                                return html;
                            }
                        </script>
                    </div>
                    <!--//table-type-->
                </div>
            </div>

        </div>
        <!-- //content -->

    </main>
    <!-- //admin-->

</div>
<script type="text/javascript">
    $(function() {

        // 🌟 이벤트 위임: document가 드롭다운 안의 라디오 버튼 클릭을 감지합니다.
        $(document).on("change", ".tabulator-cell .optionWrap input[type='radio']", function(e) {
            const $radio = $(this);
            const selectedColor = $radio.val(); // 선택된 컬러 코드 (예: DEFAULT, BLUE, MINT 등)

            // 해당 라디오 버튼의 orgId 추출
            // name -> 'wcolor_기관ID' 형식
            const radioName = $radio.attr("name");
            const orgId = radioName.split("_")[1];

            $.ajax({
                url: "/org/orgMgr/admDsgnColrStngModify.do",
                type: "POST",
                headers: {"X-Requested-With": "XMLHttpRequest"},
                data: {
                    orgId: orgId,
                    dsgnColrTycd: selectedColor,
                    encParams: EPARAM
                },
                success: function(data) {
                    if (data.result > 0) {
                        UiComm.showMessage("<spring:message code='success.common.update'/>","info");
                    } else {
                        UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error");
                    }
                    // listPaging(CURRENT_PAGE_NO);
                },
                error: function(xhr, status, error) {
                    UiComm.showMessage('여깁니다', "error"); // 에러가 발생했습니다!
                },
                complete: function() {
                    listPaging(CURRENT_PAGE_NO);
                }
            });
        });

    });
</script>

</body>
</html>

