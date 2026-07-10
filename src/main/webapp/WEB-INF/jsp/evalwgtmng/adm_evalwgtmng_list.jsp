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
        let RECORD_COUNT_PER_PAGE = Number('<c:out value="${pageInfo.recordCountPerPage}" />') || 10;
        <%--let PAGE_SIZE = Number('<c:out value="${vo.pageSize > 0 ? vo.pageSize : (vo.pageScale > 0 ? vo.pageScale : 10)}" />') || 10;--%>
        let CURRENT_PAGE_NO = Number('<c:out value="${vo.currentPageNo}" />') || 1;
        let EPARAM = '<c:out value="${encParams}" />';
        <%--let MENU_ID = '<c:out value="${vo.menuId}" />';--%>
        let CTX = '<%=request.getContextPath()%>';
        let dialog;

        let SELECTED_ORG_ID = '<c:out value="${vo.orgId}" />';
        let SELECTED_HAKSA_YEAR = '<c:out value="${vo.dgrsYr}" />';
        let SELECTED_HAKSA_TERM = '<c:out value="${vo.dgrsSmstrChrt}" />';
        let SELECTED_SMSTR_CHRT_GBNCD = '<c:out value="${vo.smstrChrtGbncd}" />';
        let SELECTED_SBJCT_ID = '<c:out value="${vo.sbjctId}" />';
        let SELECTED_SEARCH_VALUE = '<c:out value="${vo.searchValue}" />';
        let HAKSA_SYNC_YN = '<c:out value="${evalWgtHaksaSyncYn}" />';

        <%--let searchYearList = [];--%>
        <%--<c:forEach var="year" items="${yearList}">--%>
        <%--searchYearList.push('<c:out value="${year}" />');--%>
        <%--</c:forEach>--%>

        let currentSmstrChrtList = [];
        <c:forEach var="item" items="${smstrChrtList}">
        currentSmstrChrtList.push({
            dgrsYr: '<c:out value="${item.dgrsYr}" />',
            dgrsSmstrChrt: '<c:out value="${item.dgrsSmstrChrt}" />',
            smstrChrtId: '<c:out value="${item.smstrChrtId}" />',
            smstrChrtnm: '<c:out value="${item.smstrChrtnm}" />'
        });
        </c:forEach>

        let evalWgtMngTable;

        $(function() {
            fn_initSearchOptions();

            evalWgtMngTable = UiTable('evalWgtMngList', {
                lang: 'ko',
                pageFunc: listPaging,
                columns: [
                    {title: 'No', field: 'no', headerHozAlign: 'center', hozAlign: 'center', width: 50, minWidth: 50, headerSort: false},
                    {title: '기관', field: 'orgnm', headerHozAlign: 'center', hozAlign: 'left', minWidth: 140, width: 140, headerSort: false},
                    {title: '과정구분', field: 'cmcrsGbnNm', headerHozAlign: 'center', hozAlign: 'center', minWidth: 80, width: 80, headerSort: false},
                    {title: '과목분류', field: 'sbjctTycdNm', headerHozAlign: 'center', hozAlign: 'center', minWidth: 80, width: 80, headerSort: false},
                    {title: '강의형태', field: 'lctrGbncdNm', headerHozAlign: 'center', hozAlign: 'center', minWidth: 80, width: 80, headerSort: false},
                    {title: '과목코드', field: 'crclmnNo', headerHozAlign: 'center', hozAlign: 'center', minWidth: 95, width: 95, headerSort: false},
                    {title: '과목명', field: 'sbjctNm', headerHozAlign: 'center', hozAlign: 'left', minWidth: 200, widthGrow: 1, headerSort: false},
                    {title: '분반', field: 'dvclasNo', headerHozAlign: 'center', hozAlign: 'center', minWidth: 55, width: 55, headerSort: false},
                    {title: '학년', field: 'schyr', headerHozAlign: 'center', hozAlign: 'center', minWidth: 55, width: 55, headerSort: false},
                    {title: '이수구분', field: 'cmpltnTypeNm', headerHozAlign: 'center', hozAlign: 'center', minWidth: 80, width: 80, headerSort: false},
                    {title: '학점', field: 'crdts', headerHozAlign: 'center', hozAlign: 'center', minWidth: 55, width: 55, headerSort: false},
                    {title: '평가방법', field: 'mrkEvlGbnNm', headerHozAlign: 'center', hozAlign: 'center', minWidth: 80, width: 80, headerSort: false},
                    {title: '담당교수', field: 'professorNm', headerHozAlign: 'center', hozAlign: 'center', minWidth: 95, width: 95, headerSort: false},
                    {title: '담당튜터', field: 'tutorNm', headerHozAlign: 'center', hozAlign: 'center', minWidth: 95, width: 95, headerSort: false},
                    {title: '수강생', field: 'stdntCnt', headerHozAlign: 'center', hozAlign: 'center', minWidth: 70, width: 70, headerSort: false},
                    {title: '청강생', field: 'auditCnt', headerHozAlign: 'center', hozAlign: 'center', minWidth: 70, width: 70, headerSort: false},
                    {title: '사용여부', field: 'useYn', headerHozAlign: 'center', hozAlign: 'center', minWidth: 80, width: 80, headerSort: false},
                    {title: '평가비중관리', field: 'manage', headerHozAlign: 'center', hozAlign: 'center', minWidth: 170, width: 170, formatter: 'html', headerSort: false}
                ]
            });

            $('#searchValue').on('keydown', function(e) {
                if (e.keyCode === 13) {
                    fn_search();
                }
            });

            fn_loadSbjctOptions(SELECTED_SBJCT_ID, function() {
                listPaging(CURRENT_PAGE_NO);
            });
        });

        function fn_initSearchOptions() {
            renderHaksaYearOptions(SELECTED_HAKSA_YEAR);
            renderHaksaTermOptions(currentSmstrChrtList, $('#searchHaksaYear').val(), SELECTED_HAKSA_TERM);
            renderSbjctOptions([], SELECTED_SBJCT_ID);
            $('#searchValue').val(SELECTED_SEARCH_VALUE);
            fn_setHaksaSyncButton(HAKSA_SYNC_YN);
        }

        function fn_setHaksaSyncButton(syncYn) {
            let $button = $('#btnHaksaSync');
            if (syncYn === 'Y') {
                $button.show();
            } else {
                $button.hide();
            }
        }

        function fn_loadHaksaSyncYn(orgId) {
            fn_setHaksaSyncButton('N');

            if (!orgId) {
                return;
            }

            ajaxCall(CTX + '/evalwgtmng/admEvalWgtMngHaksaSyncInfo.do', {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams({orgId: orgId})
            }, function(res) {
                if (res.encParams) {
                    EPARAM = res.encParams;
                }

                let syncYn = res.result > 0 && res.data && res.data.autoLinkyn === 'Y' ? 'Y' : 'N';
                fn_setHaksaSyncButton(syncYn);
            }, function() {
                fn_setHaksaSyncButton('N');
            });
        }

        function changeListScale(scale) {
            RECORD_COUNT_PER_PAGE = Number(scale) || 10;
            listPaging(1);
        }

        function fn_search() {
            listPaging(1);
        }

        function listPaging(pageNo) {
            CURRENT_PAGE_NO = pageNo;

            ajaxCall(CTX + '/evalwgtmng/admListEvalWgtMng.do', {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams(fn_makeListParams(pageNo))
            }, function(res) {
                if (res.encParams) {
                    EPARAM = res.encParams;
                }

                if (res.result > 0) {
                    $('#totalCnt').text(res.pageInfo.totalRecordCount || 0);

                    evalWgtMngTable.clearData();
                    if (res.pageInfo && res.pageInfo.recordCountPerPage) {
                        RECORD_COUNT_PER_PAGE = Number(res.pageInfo.recordCountPerPage) || RECORD_COUNT_PER_PAGE;
                    }
                    // if (res.pageInfo && res.pageInfo.pageSize) {
                    //     PAGE_SIZE = Number(res.pageInfo.pageSize) || PAGE_SIZE;
                    // }
                    evalWgtMngTable.replaceData(createEvalWgtMngListData(res.returnList || [], res.pageInfo));
                    evalWgtMngTable.setPageInfo(res.pageInfo);
                } else {
                    UiComm.showMessage(res.message || '조회 중 오류가 발생하였습니다.', 'error');
                }
            }, function() {
                UiComm.showMessage('조회 중 오류가 발생하였습니다.', 'error');
            }, true);
        }

        function createEvalWgtMngListData(returnList, pageInfo) {
            let dataList = [];
            let pageScale = pageInfo && pageInfo.recordCountPerPage ? Number(pageInfo.recordCountPerPage) : RECORD_COUNT_PER_PAGE;
            pageScale = pageScale || 10;
            let totalCount = pageInfo && pageInfo.totalRecordCount ? Number(pageInfo.totalRecordCount) : returnList.length;
            for (let j = 0; j < returnList.length; j++) {
                let item = returnList[j];
                let rowNo = Number(item.rn || item.lineNo || item.LINE_NO || 0);
                let displayNo = rowNo > 0 ? totalCount - rowNo + 1 : totalCount - (((pageInfo ? pageInfo.currentPageNo : 1) - 1) * pageScale) - j;
                let manageHtml = ''
                    + '<div class="form-inline justify-content-center word_break_none">'
                    + '<button type="button" class="btn basic small" onclick="fn_goWrite(\'' + encodeURIComponent(item.sbjctId || '') + '\', \'view\')">상세보기</button>'
                    + '<button type="button" class="btn basic small" onclick="fn_goWrite(\'' + encodeURIComponent(item.sbjctId || '') + '\', \'modify\')">수정</button>'
                    + '</div>';

                dataList.push({
                    no: displayNo,
                    orgNm: UiComm.escapeHtml(String(item.orgnm || '-')),
                    cmcrsGbnNm: UiComm.escapeHtml(String(item.cmcrsGbnNm || '-')),
                    sbjctTycdNm: UiComm.escapeHtml(String(item.sbjctTycdNm || '-')),
                    lctrGbncdNm: UiComm.escapeHtml(String(item.lctrGbncdNm || '-')),
                    crclmnNo: UiComm.escapeHtml(String(item.crclmnNo || '-')),
                    sbjctNm: UiComm.escapeHtml(String(item.sbjctnm || '-')),
                    dvclasNo: UiComm.escapeHtml(String(item.dvclasNo || '-')),
                    /*schyr: UiComm.escapeHtml(String(item.schyr || '-')),*/
                    cmpltnTypeNm: UiComm.escapeHtml(String(item.cmpltnTypeNm || '-')),
                    crdts: UiComm.escapeHtml(String(item.crdts || '-')),
                    mrkEvlGbnNm: UiComm.escapeHtml(String(item.mrkEvlGbnNm || '-')),
                    professorNm: UiComm.escapeHtml(String(item.professorNm || '-')),
                    tutorNm: UiComm.escapeHtml(String(item.tutorNm || '-')),
                    stdntCnt: UiComm.escapeHtml(String(item.stdntCnt || '0')),
                    auditCnt: UiComm.escapeHtml(String(item.auditCnt || '0')),
                    useYn: UiComm.escapeHtml(String(item.useYn || '-')),
                    manage: manageHtml
                });
            }

            return dataList;
        }

        function renderYrSmstrOptions(selectedYrSmstr) {
            let html = `<option value="">학사년도/학기(기수)</option>`;
        }

        // function renderHaksaYearOptions(selectedYear) {
        //     let html = '<option value="">년도</option>';
        //     for (let j = 0; j < searchYearList.length; j++) {
        //         html += '<option value="' + searchYearList[j] + '">' + searchYearList[j] + '</option>';
        //     }
        //
        //     $('#searchHaksaYear').html(html);
        //
        //     let finalYear = selectedYear;
        //     if (!finalYear && searchYearList.length > 0) {
        //         finalYear = searchYearList[0];
        //     }
        //     $('#searchHaksaYear').val(finalYear);
        //     fn_refreshChosen('#searchHaksaYear');
        // }

        // function renderHaksaTermOptions(list, year, selectedTerm) {
        //     let termList = [];
        //
        //     for (let i = 0; i < list.length; i++) {
        //         if ((list[i].dgrsYr || '') === year) {
        //             termList.push(list[i]);
        //         }
        //     }
        //
        //     let html = '<option value="">전체</option>';
        //     for (let j = 0; j < termList.length; j++) {
        //         let term = termList[j].dgrsSmstrChrt || '';
        //         let termName = termList[j].smstrChrtnm || termList[j].haksaTermNm || '';
        //         html += '<option value="' + UiComm.escapeHtml(term) + '">' + UiComm.escapeHtml(fn_formatTermText(term, termName)) + '</option>';
        //     }
        //
        //     $('#searchHaksaTerm').html(html);
        //
        //     $('#searchHaksaTerm').val(selectedTerm || '');
        //     fn_refreshChosen('#searchHaksaTerm');
        // }

        // function fn_formatTermText(term, termName) {
        //     let nameText = $.trim(termName || '');
        //     if (nameText) {
        //         return nameText;
        //     }
        //     return $.trim(term || '');
        // }

        // function renderSbjctOptions(list, selectedSbjctId) {
        //     let html = '<option value="">전체</option>';
        //
        //     list = list || [];
        //
        //     for (let i = 0; i < list.length; i++) {
        //         let sbjctId = list[i].sbjctId || '';
        //         let label = list[i].sbjctNm || '-';
        //
        //         html += '<option value="' + UiComm.escapeHtml(String(sbjctId)) + '">' + UiComm.escapeHtml(String(label)) + '</option>';
        //     }
        //
        //     $('#searchSbjctId').html(html);
        //     $('#searchSbjctId').val(selectedSbjctId || '');
        //     fn_refreshChosen('#searchSbjctId');
        // }

        function fn_loadSbjctOptions(selectedSbjctId, callback) {
            ajaxCall(CTX + '/evalwgtmng/admListEvalWgtMngSubject.do', {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams({
                    orgId: $('#searchOrgId').val(),
                    haksaYear: $('#searchHaksaYear').val(),
                    haksaTerm: $('#searchHaksaTerm').val()
                })
            }, function(res) {
                if (res.encParams) {
                    EPARAM = res.encParams;
                }

                if (res.result > 0) {
                    renderSbjctOptions(res.returnList || [], selectedSbjctId || '');
                } else {
                    renderSbjctOptions([], '');
                }

                if (typeof callback === 'function') {
                    callback();
                }
            }, function() {
                renderSbjctOptions([], '');
                if (typeof callback === 'function') {
                    callback();
                }
            });
        }

        function fn_refreshChosen(selector) {
            let $select = $(selector);
            if ($select.hasClass('chosen')) {
                $select.trigger('chosen:updated');
            }
        }

        function fn_changeOrg() {
            let orgId = $('#searchOrgId').val();
            SELECTED_SBJCT_ID = '';
            fn_loadHaksaSyncYn(orgId);

            renderHaksaYearOptions($('#searchHaksaYear').val());
            fn_loadHaksaTermOptions(orgId, $('#searchHaksaYear').val(), '', function() {
                fn_loadSbjctOptions('');
            });
        }

        // function fn_changeYear() {
        //     SELECTED_SBJCT_ID = '';
        //     fn_loadHaksaTermOptions($('#searchOrgId').val(), $('#searchHaksaYear').val(), '', function() {
        //         renderSbjctOptions([], '');
        //         fn_loadSbjctOptions('');
        //     });
        // }

        // function fn_changeSubjectCriteria() {
        //     SELECTED_SBJCT_ID = '';
        //     renderSbjctOptions([], '');
        //     fn_loadSbjctOptions('');
        // }

        // function fn_loadHaksaTermOptions(orgId, year, selectedTerm, callback) {
        //     let $term = $('#searchHaksaTerm');
        //     currentSmstrChrtList = [];
        //     renderHaksaTermOptions([], year, '');
        //
        //     if (!year) {
        //         if (typeof callback === 'function') {
        //             callback();
        //         }
        //         return;
        //     }
        //
        //     ajaxCall(CTX + '/evalwgtmng/admListHaksaTerm.do', {
        //         encParams: EPARAM,
        //         addParams: UiComm.makeEncParams({
        //             orgId: orgId,
        //             haksaYear: year
        //         })
        //     }, function(res) {
        //         if (res.encParams) {
        //             EPARAM = res.encParams;
        //         }
        //
        //         if (res.result > 0) {
        //             currentSmstrChrtList = fn_normalizeSmstrChrtList(res.returnList || [], year);
        //             renderHaksaTermOptions(currentSmstrChrtList, year, selectedTerm || '');
        //         } else {
        //             $term.val('');
        //             fn_refreshChosen('#searchHaksaTerm');
        //             UiComm.showMessage(res.message || '년도/학기 목록 조회 중 오류가 발생하였습니다.', 'error');
        //         }
        //
        //         if (typeof callback === 'function') {
        //             callback();
        //         }
        //     }, function() {
        //         $term.val('');
        //         fn_refreshChosen('#searchHaksaTerm');
        //         UiComm.showMessage('년도/학기 목록 조회 중 오류가 발생하였습니다.', 'error');
        //
        //         if (typeof callback === 'function') {
        //             callback();
        //         }
        //     });
        // }

        // function fn_normalizeSmstrChrtList(list, year) {
        //     let result = [];
        //     for (let i = 0; i < list.length; i++) {
        //         result.push({
        //             dgrsYr: list[i].dgrsYr || year || '',
        //             dgrsSmstrChrt: list[i].dgrsSmstrChrt || '',
        //             smstrChrtId: list[i].smstrChrtId || '',
        //             smstrChrtnm: list[i].smstrChrtnm || list[i].haksaTermNm || ''
        //         });
        //     }
        //     return result;
        // }

        function fn_goWrite(encodedSbjctId, mode) {
            let sbjctId = decodeURIComponent(encodedSbjctId || '');
            let extData = {
                orgId: $('#searchOrgId').val(),
                yrSmstr: $('#yrSmstr').val(),
                smstrChrtGbncd: $("#yrSmstr option:selected").data("type") || "",
                sbjctId: sbjctId,
                mode: mode || 'view',
                searchValue: $('#searchValue').val()
            };

            location.href = fn_appendMenuId(CTX + '/evalwgtmng/admEvalWgtMngWrite.do?encParams=' + encodeURIComponent(EPARAM) + '&addParams=' + encodeURIComponent(UiComm.makeEncParams(extData)));
        }

        function fn_goRegist() {
            let extData = {
                orgId: $('#searchOrgId').val(),
                yrSmstr: $('#yrSmstr').val(),
                smstrChrtGbncd: $("#yrSmstr option:selected").data("type") || "",
                sbjctId: '',
                mode: 'regist',
                searchValue: ''
            };

            location.href = fn_appendMenuId(CTX + '/evalwgtmng/admEvalWgtMngWrite.do?encParams=' + encodeURIComponent(EPARAM) + '&addParams=' + encodeURIComponent(UiComm.makeEncParams(extData)));
        }

        // function fn_appendMenuId(url) {
        //     if (!MENU_ID) {
        //         return url;
        //     }
        //     return url + (url.indexOf('?') > -1 ? '&' : '?') + 'menuId=' + encodeURIComponent(MENU_ID);
        // }

        function fn_makeListParams(pageNo) {
            return {
                orgId           : $('#searchOrgId').val(),
                yrSmstr         : $('#searchYrSmstr').val(),
                smstrChrtGbncd  : $("#yrSmstr option:selected").data("type") || "",
                sbjctId         : $('#searchSbjctId').val(),
                searchValue      : $('#searchValue').val(),
                currentPageNo   : pageNo,
                recordCountPerPage: RECORD_COUNT_PER_PAGE,
                // pageSize        : PAGE_SIZE
            };
        }

        function fn_validatePopupBase() {
            if (!$('#searchOrgId').val()) {
                UiComm.showMessage('기관을 선택해 주세요.', 'warning');
                return false;
            }
            if (!$('#searchHaksaYear').val() || !$('#searchHaksaTerm').val()) {
                UiComm.showMessage('년도/학기(기수)를 선택해 주세요.', 'warning');
                return false;
            }
            return true;
        }

        function fn_makePopupAddParams() {
            return UiComm.makeEncParams({
                orgId: $('#searchOrgId').val(),
                haksaYear: $('#searchHaksaYear').val(),
                haksaTerm: $('#searchHaksaTerm').val(),
                sbjctId: $('#searchSbjctId').val(),
                searchValue: $('#searchValue').val()
            });
        }

        function fn_openHaksaSyncPop() {
            if (!fn_validatePopupBase()) {
                return;
            }

            dialog = UiDialog('dialog1', {
                title: '학사연동 가져오기',
                width: 720,
                height: 520,
                url: CTX + '/evalwgtmng/admEvalWgtMngHaksaSyncPopup.do?encParams=' + encodeURIComponent(EPARAM) + '&addParams=' + encodeURIComponent(fn_makePopupAddParams()),
                autoresize: false
            });
        }

        function fn_openExcelUploadPop() {
            if (!fn_validatePopupBase()) {
                return;
            }

            dialog = UiDialog('dialog1', {
                title: '엑셀로 등록',
                width: 760,
                height: 560,
                url: CTX + '/evalwgtmng/admEvalWgtMngExcelUploadPopup.do?encParams=' + encodeURIComponent(EPARAM) + '&addParams=' + encodeURIComponent(fn_makePopupAddParams()),
                autoresize: false
            });
        }

        function closeDialog() {
            if (dialog) {
                dialog.close();
            }
        }
    </script>
</head>

<body class="admin">
<div id="wrap" class="main evalwgtmng-page">
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
                                <%--<select id="searchOrgId" class="form-select type-num w350" onchange="fn_changeOrg();">
                                    <c:if test="${allOrgYn eq 'Y'}">
                                        <option value="">전체</option>
                                    </c:if>
                                    <c:forEach var="org" items="${orgList}">
                                        <option value="${org.orgId}" <c:if test="${org.orgId eq vo.orgId}">selected="selected"</c:if>><c:out value="${empty org.orgNm ? org.orgnm : org.orgNm}"/></option>
                                    </c:forEach>
                                </select>--%>
                                <select class="form-select" id="searchOrgId" ${disabled}><!-- 기관 -->
                                    <option value="">기관</option>
                                    <c:forEach var="list" items="${filterOptions.orgList }">
                                        <option value="${list.orgId }" ${list.orgId eq filterOptions.orgId ? 'selected' : '' }>${list.orgnm }</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit">년도/학기(기수)</span>
                            <%--<div class="itemList multi">
                                <select id="searchHaksaYear" class="form-select type-num w150" onchange="fn_changeYear();" placeholder="년도"></select>
                                <select id="searchHaksaTerm" class="form-select type-num w200" onchange="fn_changeSubjectCriteria();" placeholder="학기"></select>
                            </div>--%>
                            <select class="form-select" id="searchYrSmstr">
                                <option value=""><spring:message code="msg.common.label.yearSmstr" /></option>
                                <c:forEach var="item" items="${filterOptions.yrSmstrList }" varStatus="i">
                                    <option value="${item.dgrsYr}${item.dgrsSmstrChrt}" <%--${i.index eq 0 ? 'selected' : '' }--%> data-type="${item.smstrChrtGbncd}">${item.smstrChrt}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="item">
                            <span class="item_tit">과목</span>
                            <div class="itemList">
                                <%--<select id="searchSbjctId" class="form-select type-num w300" placeholder="과목"></select>--%>
                                    <select class="form-select" id="searchSbjctId">
                                        <option value=""><spring:message code="common.subject" /></option><!-- 과목 -->
                                        <c:forEach var="list" items="${filterOptions.sbjctList }">
                                            <option value="${list.sbjctId }">${list.sbjctnm }</option>
                                        </c:forEach>
                                    </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit">검색어</span>
                            <div class="itemList">
                                <input type="text" id="searchValue" class="form-control w350" placeholder="과목코드/과목명/교수 검색"/>
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
                            <button type="button" class="btn type2" onclick="fn_openExcelUploadPop();">엑셀로 등록</button>
                            <button type="button" id="btnHaksaSync" class="btn type1" style="display:none;" onclick="fn_openHaksaSyncPop();">학사연동 가져오기</button>
                            <button type="button" class="btn type2" onclick="fn_goRegist();">등록</button>
                            <uiex:listScale func="changeListScale" value="${vo.recordCountPerPage > 0 ? vo.recordCountPerPage : (vo.listScale > 0 ? vo.listScale : 10)}"/>
                        </div>
                    </div>

                    <div class="table-wrap">
                        <div id="evalWgtMngList"></div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

</body>
</html>
