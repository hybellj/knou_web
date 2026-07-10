<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
    <script type="text/javascript">
        var LIST_SCALE = Number('<c:out value="${vo.recordCountPerPage > 0 ? vo.recordCountPerPage : 10}" />') || 10;
        var CURRENT_PAGE = Number('<c:out value="${empty vo.currentPageNo ? 1 : vo.currentPageNo}" />') || 1;
        var EPARAM = '<c:out value="${encParams}" />';
        var MENU_ID = '<c:out value="${vo.menuId}" />';
        var CTX = '<%=request.getContextPath()%>';
        var dialog;

        var SELECTED_ORG_ID = '<c:out value="${vo.orgId}" />';
        var SELECTED_HAKSA_YEAR = '<c:out value="${vo.dgrsYr}" />';
        var SELECTED_HAKSA_TERM = '<c:out value="${vo.dgrsSmstrChrt}" />';
        var SELECTED_CRS_GBNCD = '<c:out value="${vo.crsGbncd}" />';
        var SELECTED_SBJCT_TYCD = '<c:out value="${vo.sbjctTycd}" />';
        var SELECTED_SEARCH_VALUE = '<c:out value="${vo.searchText}" />';

        var searchYearList = [];
        <c:forEach var="year" items="${yearList}">
        searchYearList.push('<c:out value="${year}" />');
        </c:forEach>

        var currentSmstrChrtList = [];
        <c:forEach var="item" items="${smstrChrtList}">
        currentSmstrChrtList.push({
            dgrsYr: '<c:out value="${item.dgrsYr}" />',
            dgrsSmstrChrt: '<c:out value="${item.dgrsSmstrChrt}" />',
            smstrChrtId: '<c:out value="${item.smstrChrtId}" />',
            smstrChrtnm: '<c:out value="${item.smstrChrtnm}" />'
        });
        </c:forEach>

        var reviewPeriodTable;

        $(function() {
            // 검색조건 초기값 구성
            fn_initSearchOptions();

            // 복습기간설정 목록 테이블 구성
            reviewPeriodTable = UiTable('reviewPeriodList', {
                lang: 'ko',
                pageFunc: listPaging,
                columns: [
                    {title: 'No', field: 'no', headerHozAlign: 'center', hozAlign: 'center', width: 50, minWidth: 50, headerSort: false},
                    {title: '기관', field: 'orgNm', headerHozAlign: 'center', hozAlign: 'left', width: 180, minWidth: 170, headerSort: false},
                    {title: '과목분류', field: 'sbjctTycdNm', headerHozAlign: 'center', hozAlign: 'center', width: 90, minWidth: 80, headerSort: false},
                    {title: '과목코드', field: 'crclmnNo', headerHozAlign: 'center', hozAlign: 'center', width: 120, minWidth: 110, headerSort: false},
                    {title: '과목명', field: 'sbjctNm', headerHozAlign: 'center', hozAlign: 'left', minWidth: 150, widthGrow: 1, headerSort: false},
                    {title: '분반', field: 'dvclasNo', headerHozAlign: 'center', hozAlign: 'center', width: 60, minWidth: 55, headerSort: false},
                    {title: '담당교수', field: 'professorNm', headerHozAlign: 'center', hozAlign: 'center', width: 95, minWidth: 85, headerSort: false},
                    {title: '담당튜터', field: 'tutorNm', headerHozAlign: 'center', hozAlign: 'center', width: 95, minWidth: 85, headerSort: false},
                    {title: '복습기간', field: 'reviewPeriodText', headerHozAlign: 'center', hozAlign: 'center', width: 230, minWidth: 190, headerSort: false},
                    {title: '복습기간설정', field: 'manage', headerHozAlign: 'center', hozAlign: 'center', width: 120, minWidth: 110, formatter: 'html', headerSort: false}
                ]
            });

            $('#searchValue').on('keydown', function(e) {
                if (e.keyCode === 13) {
                    fn_search();
                }
            });

            listPaging(CURRENT_PAGE);
        });

        // 검색조건 초기값 렌더링
        function fn_initSearchOptions() {
            renderHaksaYearOptions(SELECTED_HAKSA_YEAR);
            renderHaksaTermOptions(currentSmstrChrtList, $('#searchHaksaYear').val(), SELECTED_HAKSA_TERM);
            renderCodeOptions('#searchCrsGbncd', fn_getInitialCodeOptions('#searchCrsGbncd'), SELECTED_CRS_GBNCD);
            renderCodeOptions('#searchSbjctTycd', fn_getInitialCodeOptions('#searchSbjctTycd'), SELECTED_SBJCT_TYCD);
            $('#searchValue').val(SELECTED_SEARCH_VALUE);
        }

        // 페이지당 건수 변경
        function changeListScale(scale) {
            LIST_SCALE = Number(scale) || 10;
            listPaging(1);
        }

        // 검색 실행
        function fn_search() {
            listPaging(1);
        }

        // 복습기간설정 목록 조회
        function listPaging(pageIndex) {
            CURRENT_PAGE = pageIndex;

            var extData = {
                currentPageNo: pageIndex,
                recordCountPerPage: LIST_SCALE,
                pageSize: 10,
                orgId: $('#searchOrgId').val(),
                dgrsYr: $('#searchHaksaYear').val(),
                dgrsSmstrChrt: $('#searchHaksaTerm').val(),
                crsGbncd: $('#searchCrsGbncd').val(),
                sbjctTycd: $('#searchSbjctTycd').val(),
                searchText: $('#searchValue').val()
            };

            ajaxCall(fn_appendMenuId(CTX + '/review/admListReviewPeriod.do'), {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams(extData)
            }, function(res) {
                if (res.encParams) {
                    EPARAM = res.encParams;
                }

                if (res.result > 0) {
                    $('#totalCnt').text(res.pageInfo ? res.pageInfo.totalRecordCount : 0);
                    reviewPeriodTable.clearData();
                    if (res.pageInfo && res.pageInfo.recordCountPerPage) {
                        LIST_SCALE = Number(res.pageInfo.recordCountPerPage) || LIST_SCALE;
                    }
                    reviewPeriodTable.replaceData(createReviewPeriodListData(res.returnList || [], res.pageInfo));
                    reviewPeriodTable.setPageInfo(res.pageInfo);
                } else {
                    UiComm.showMessage(res.message || '조회 중 오류가 발생했습니다.', 'error');
                }
            }, function() {
                UiComm.showMessage('조회 중 오류가 발생했습니다.', 'error');
            }, true);
        }

        // 서버 응답을 테이블 표시 데이터로 변환
        function createReviewPeriodListData(returnList, pageInfo) {
            var dataList = [];
            var pageScale = pageInfo && pageInfo.recordCountPerPage ? Number(pageInfo.recordCountPerPage) : LIST_SCALE;
            pageScale = pageScale || 10;
            var totalCount = pageInfo && pageInfo.totalRecordCount ? Number(pageInfo.totalRecordCount) : returnList.length;

            for (var i = 0; i < returnList.length; i++) {
                var item = returnList[i];
                var rowNo = Number(item.rn || item.lineNo || 0);
                var displayNo = rowNo > 0 ? totalCount - rowNo + 1 : totalCount - (((pageInfo ? pageInfo.currentPageNo : 1) - 1) * pageScale) - i;
                var sbjctId = encodeURIComponent(item.sbjctId || '');
                var orgId = encodeURIComponent(item.orgId || '');
                var manageHtml = ''
                    + '<div class="form-inline justify-content-center word_break_none">'
                    + '<button type="button" class="btn basic small" onclick="fn_openSettingPop(\'' + sbjctId + '\', \'' + orgId + '\')">설정</button>'
                    + '</div>';

                dataList.push({
                    no: displayNo,
                    orgNm: UiComm.escapeHtml(String(item.orgNm || '-')),
                    sbjctTycdNm: UiComm.escapeHtml(String(item.sbjctTycdNm || '-')),
                    crclmnNo: UiComm.escapeHtml(String(item.crclmnNo || '-')),
                    sbjctNm: UiComm.escapeHtml(String(item.sbjctNm || '-')),
                    dvclasNo: UiComm.escapeHtml(String(item.dvclasNo || '-')),
                    professorNm: UiComm.escapeHtml(String(item.professorNm || '-')),
                    tutorNm: UiComm.escapeHtml(String(item.tutorNm || '-')),
                    reviewPeriodText: UiComm.escapeHtml(String(fn_formatReviewPeriod(item))),
                    manage: manageHtml
                });
            }

            return dataList;
        }

        // 복습 가능 상태를 화면용 텍스트로 변환
        function fn_formatReviewPeriod(item) {
            var status = String(item.reviewStatus || 'RVW_IMPSBL');
            if (status === 'RVW_PSBL') {
                return '영구';
            }
            if (status === 'PRD_STNG') {
                var startText = fn_formatDttm(item.reviewStartDttm);
                var endText = fn_formatDttm(item.reviewEndDttm);
                if (startText === '-' && endText === '-') {
                    return '기간설정';
                }
                return startText + ' ~ ' + endText;
            }
            return '불가';
        }

        // YYYYMMDDHHMISS 값을 표시용 텍스트로 변환
        function fn_formatDttm(value) {
            var digits = String(value || '').replace(/[^0-9]/g, '');
            if (digits.length >= 12) {
                return digits.substring(0, 4) + '.' + digits.substring(4, 6) + '.' + digits.substring(6, 8) + ' '
                    + digits.substring(8, 10) + ':' + digits.substring(10, 12);
            }
            if (digits.length >= 8) {
                return digits.substring(0, 4) + '.' + digits.substring(4, 6) + '.' + digits.substring(6, 8);
            }
            return '-';
        }

        // 학년도 드롭다운 렌더링
        function renderHaksaYearOptions(selectedYear) {
            var html = '<option value="">년도</option>';
            for (var i = 0; i < searchYearList.length; i++) {
                html += '<option value="' + UiComm.escapeHtml(String(searchYearList[i])) + '">' + UiComm.escapeHtml(String(searchYearList[i])) + '</option>';
            }

            $('#searchHaksaYear').html(html);
            $('#searchHaksaYear').val(selectedYear || (searchYearList.length > 0 ? searchYearList[0] : ''));
            fn_refreshChosen('#searchHaksaYear');
        }

        // 학기 드롭다운 렌더링
        function renderHaksaTermOptions(list, year, selectedTerm) {
            var html = '<option value="">전체</option>';
            for (var i = 0; i < list.length; i++) {
                if ((list[i].dgrsYr || '') !== year) {
                    continue;
                }
                var term = list[i].dgrsSmstrChrt || '';
                var termName = list[i].smstrChrtnm || term;
                html += '<option value="' + UiComm.escapeHtml(String(term)) + '">' + UiComm.escapeHtml(String(termName)) + '</option>';
            }

            $('#searchHaksaTerm').html(html);
            $('#searchHaksaTerm').val(selectedTerm || '');
            fn_refreshChosen('#searchHaksaTerm');
        }

        // 기관 변경 시 종속 검색조건 재조회
        function fn_changeOrg() {
            fn_loadHaksaTermOptions($('#searchOrgId').val(), $('#searchHaksaYear').val(), '');
            fn_loadCodeOptions($('#searchOrgId').val());
        }

        // 학년도 변경 시 학기 목록 재조회
        function fn_changeYear() {
            fn_loadHaksaTermOptions($('#searchOrgId').val(), $('#searchHaksaYear').val(), '');
        }

        // 학기 드롭다운 조회
        function fn_loadHaksaTermOptions(orgId, year, selectedTerm) {
            currentSmstrChrtList = [];
            renderHaksaTermOptions([], year, '');

            if (!year) {
                return;
            }

            ajaxCall(fn_appendMenuId(CTX + '/review/admListHaksaTerm.do'), {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams({
                    orgId: orgId,
                    haksaYear: year
                })
            }, function(res) {
                if (res.encParams) {
                    EPARAM = res.encParams;
                }
                if (res.result > 0) {
                    currentSmstrChrtList = fn_normalizeSmstrChrtList(res.returnList || [], year);
                    renderHaksaTermOptions(currentSmstrChrtList, year, selectedTerm || '');
                } else {
                    UiComm.showMessage(res.message || '년도/학기 목록 조회 중 오류가 발생했습니다.', 'error');
                }
            }, function() {
                UiComm.showMessage('년도/학기 목록 조회 중 오류가 발생했습니다.', 'error');
            }, false);
        }

        // 과정구분/과목분류 드롭다운 재조회
        function fn_loadCodeOptions(orgId) {
            renderCodeOptions('#searchCrsGbncd', [], '');
            renderCodeOptions('#searchSbjctTycd', [], '');
            fetchCodeList('CRS_GBNCD', '#searchCrsGbncd', orgId, '');
            fetchCodeList('SBJCT_TYCD', '#searchSbjctTycd', orgId, '');
        }

        // 공통코드 드롭다운 단건 조회
        function fetchCodeList(upCd, selector, orgId, selectedValue) {
            ajaxCall(fn_appendMenuId(CTX + '/review/admReviewPeriodCmmnCdList.do'), {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams({
                    orgId: orgId,
                    upCd: upCd
                })
            }, function(res) {
                if (res.encParams) {
                    EPARAM = res.encParams;
                }
                if (res.result > 0) {
                    renderCodeOptions(selector, res.returnList || [], selectedValue || '');
                } else {
                    UiComm.showMessage(res.message || '코드 목록 조회 중 오류가 발생했습니다.', 'error');
                }
            }, function() {
                UiComm.showMessage('코드 목록 조회 중 오류가 발생했습니다.', 'error');
            }, false);
        }

        // 초기 렌더링 시 서버에서 내려준 코드 option 수집
        function fn_getInitialCodeOptions(selector) {
            var list = [];
            $(selector).find('option').each(function() {
                var value = $(this).val();
                if (!value) {
                    return;
                }
                list.push({
                    cd: value,
                    cdnm: $(this).text()
                });
            });
            return list;
        }

        // 코드 드롭다운 렌더링
        function renderCodeOptions(selector, list, selectedValue) {
            var html = '<option value="">전체</option>';
            for (var i = 0; i < list.length; i++) {
                var code = list[i] || {};
                var cd = code.cd || '';
                if (!cd) {
                    continue;
                }
                html += '<option value="' + UiComm.escapeHtml(String(cd)) + '">' + UiComm.escapeHtml(String(code.cdnm || cd)) + '</option>';
            }

            $(selector).html(html);
            $(selector).val(selectedValue || '');
            fn_refreshChosen(selector);
        }

        // 학기 목록 응답값 표준화
        function fn_normalizeSmstrChrtList(list, year) {
            var result = [];
            for (var i = 0; i < list.length; i++) {
                result.push({
                    dgrsYr: list[i].dgrsYr || year || '',
                    dgrsSmstrChrt: list[i].dgrsSmstrChrt || '',
                    smstrChrtId: list[i].smstrChrtId || '',
                    smstrChrtnm: list[i].smstrChrtnm || list[i].haksaTermNm || list[i].dgrsSmstrChrt || ''
                });
            }
            return result;
        }

        // 복습기간설정 팝업 열기
        function fn_openSettingPop(encodedSbjctId, encodedOrgId) {
            var sbjctId = decodeURIComponent(encodedSbjctId || '');
            var orgId = decodeURIComponent(encodedOrgId || '');
            if (!sbjctId) {
                UiComm.showMessage('과목 정보를 확인할 수 없습니다.', 'warning');
                return;
            }

            var extData = {
                orgId: orgId,
                sbjctId: sbjctId,
                haksaYear: $('#searchHaksaYear').val(),
                haksaTerm: $('#searchHaksaTerm').val()
            };

            dialog = UiDialog('dialog1', {
                title: '복습기간설정',
                width: 720,
                height: 420,
                url: fn_appendMenuId(CTX + '/review/admReviewPeriodSettingPopup.do?encParams=' + encodeURIComponent(EPARAM) + '&addParams=' + encodeURIComponent(UiComm.makeEncParams(extData))),
                autoresize: false
            });
        }

        // menuId 쿼리스트링 유지
        function fn_appendMenuId(url) {
            if (!MENU_ID) {
                return url;
            }
            return url + (url.indexOf('?') > -1 ? '&' : '?') + 'menuId=' + encodeURIComponent(MENU_ID);
        }

        // 저장 후 목록 재조회
        function fn_afterSaveReviewPeriod() {
            closeDialog();
            listPaging(CURRENT_PAGE);
        }

        // 팝업 닫기
        function closeDialog() {
            if (dialog) {
                dialog.close();
            }
        }

        // chosen UI 갱신
        function fn_refreshChosen(selector) {
            if ($.fn.chosen) {
                $(selector).trigger('chosen:updated');
            }
        }
    </script>
</head>

<body class="admin">
<div id="wrap" class="main review-period-page">
    <jsp:include page="/WEB-INF/jsp/common_new/admin_header.jsp"/>

    <main class="common">
        <jsp:include page="/WEB-INF/jsp/common_new/admin_aside.jsp"/>

        <div id="content" class="content-wrap common">
            <div class="admin_sub">
                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                        <uiex:navibar type="admin"/>
                    </div>

                    <div class="search-typeA">
                        <div class="item">
                            <span class="item_tit">기관</span>
                            <div class="itemList">
                                <select id="searchOrgId" class="form-select type-num w350" onchange="fn_changeOrg();">
                                    <c:if test="${allOrgYn eq 'Y'}">
                                        <option value="">전체</option>
                                    </c:if>
                                    <c:forEach var="org" items="${orgList}">
                                        <option value="${org.orgId}" <c:if test="${org.orgId eq vo.orgId}">selected="selected"</c:if>><c:out value="${org.orgnm}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit">년도/학기(기수)</span>
                            <div class="itemList multi">
                                <select id="searchHaksaYear" class="form-select type-num w150" onchange="fn_changeYear();"></select>
                                <select id="searchHaksaTerm" class="form-select type-num w200"></select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit">과정구분</span>
                            <div class="itemList">
                                <select id="searchCrsGbncd" class="form-select type-num w350">
                                    <option value="">전체</option>
                                    <c:forEach var="code" items="${crsGbncdList}">
                                        <option value="${code.cd}" <c:if test="${code.cd eq vo.crsGbncd}">selected="selected"</c:if>><c:out value="${code.cdnm}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit">과목분류</span>
                            <div class="itemList">
                                <select id="searchSbjctTycd" class="form-select type-num w350">
                                    <option value="">전체</option>
                                    <c:forEach var="code" items="${sbjctTycdList}">
                                        <option value="${code.cd}" <c:if test="${code.cd eq vo.sbjctTycd}">selected="selected"</c:if>><c:out value="${code.cdnm}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit">검색어</span>
                            <div class="itemList">
                                <input type="text" id="searchValue" class="form-control w350" placeholder="과목명 검색"/>
                            </div>
                        </div>
                        <div class="button-area">
                            <button type="button" class="btn search" onclick="fn_search();">검색</button>
                        </div>
                    </div>

                    <div class="board_top">
                        <h3 class="board-title">개설 과목 목록</h3>
                        <span class="total_num">총 <strong id="totalCnt">0</strong>건</span>
                        <div class="right-area">
                            <uiex:listScale func="changeListScale" value="${vo.recordCountPerPage > 0 ? vo.recordCountPerPage : 10}"/>
                        </div>
                    </div>

                    <div class="table-wrap">
                        <div id="reviewPeriodList"></div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

</body>
</html>
