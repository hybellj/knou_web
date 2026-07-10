<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>

<body class="admin ${bodyClass}">
    <div id="wrap" class="main atndcrtr-page">
        <jsp:include page="/WEB-INF/jsp/common_new/admin_header.jsp"/>

        <main class="common">
            <jsp:include page="/WEB-INF/jsp/common_new/admin_aside.jsp"/>

            <div id="content" class="content-wrap common">
                <div class="admin_sub">
                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">${uiex:getCurMenunm()}</h2> <%-- 메뉴명 --%>
                            <uiex:navibar type="admin"/>
                        </div>

                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><spring:message code="crs.atndc.crtr.label.org"/></span><%-- 기관 --%>
                                <div class="itemList">
                                    <select id="searchOrgId" class="form-select type-num w350">
                                        <c:if test="${allOrgYn eq 'Y'}">
                                            <option value=""><spring:message code="crs.atndc.crtr.label.all"/></option><%-- 전체 --%>
                                        </c:if>
                                        <c:forEach var="org" items="${orgInfoList}">
                                            <option value="${org.orgId}" <c:if test="${org.orgId eq vo.orgId}">selected="selected"</c:if>><c:out value="${empty org.orgNm ? org.orgnm : org.orgNm}"/></option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><spring:message code="crs.atndc.crtr.label.year.term"/></span><%-- 년도/학기(기수) --%>
                                <div class="itemList">
                                    <select id="searchHaksaYear" class="form-select type-num w150">
                                        <option value=""><spring:message code="crs.atndc.crtr.label.all"/></option><%-- 전체 --%>
                                        <c:forEach var="year" items="${yearList}">
                                            <option value="${year}" <c:if test="${year eq vo.haksaYear}">selected="selected"</c:if>><c:out value="${year}"/></option>
                                        </c:forEach>
                                    </select>
                                    <select id="searchHaksaTerm" class="form-select type-num w200">
                                        <option value=""><spring:message code="crs.atndc.crtr.label.all"/></option><%-- 전체 --%>
                                        <c:forEach var="term" items="${haksaTermList}">
                                            <c:set var="termLabel" value="${empty term.haksaTermNm ? term.haksaTerm : term.haksaTermNm}"/>
                                            <option value="${term.haksaTerm}" <c:if test="${term.haksaTerm eq vo.haksaTerm}">selected="selected"</c:if>><c:out value="${termLabel}"/></option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="fn_search();"><spring:message code="common.button.search"/></button><%-- 검색 --%>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title"><spring:message code="crs.atndc.crtr.title.org.list"/></h3><%-- 기관 목록 --%>
                            <span class="total_num">총 <strong id="totalCnt">0</strong>건</span>
                            <div class="right-area">
                                <button type="button" class="btn type2" onclick="fn_goRegist();"><spring:message code="common.button.create"/></button><%-- 등록 --%>
                                <uiex:listScale func="fn_changeListScale" value="${vo.listScale}"/>
                            </div>
                        </div>

                        <div id="atndCrtrList"></div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script type="text/javascript">
        var LIST_SCALE = Number('<c:out value="${vo.listScale}" />') || 20;
        var CURRENT_PAGE = Number('<c:out value="${vo.pageIndex}" />') || 1;
        var EPARAM = '<c:out value="${encParams}" />';
        var MENU_ID = '<c:out value="${vo.menuId}" />';
        var CTX = '<%=request.getContextPath()%>';
        var atndCrtrTable;

        $(function() {
            atndCrtrTable = UiTable('atndCrtrList', {
                lang: 'ko',
                pageFunc: fn_loadList,
                columns: [
                    {title: 'No', field: 'no', headerHozAlign: 'center', hozAlign: 'center', width: 50, minWidth: 50, headerSort: false},
                    {title: '<spring:message code="crs.atndc.crtr.label.year.term"/>', field: 'yearTerm', headerHozAlign: 'center', hozAlign: 'center', width: 175, minWidth: 175, headerSort: false}, <%-- 년도/학기(기수) --%>
                    {title: '<spring:message code="crs.atndc.crtr.label.org.full.name"/>', field: 'orgNm', headerHozAlign: 'center', hozAlign: 'left', minWidth: 220, widthGrow: 2, headerSort: false}, <%-- 기관 Full Name --%>
                    {title: '<spring:message code="crs.atndc.crtr.label.org.short.name"/>', field: 'orgShrtNm', headerHozAlign: 'center', hozAlign: 'left', minWidth: 170, widthGrow: 1, headerSort: false}, <%-- 기관 Short Name --%>
                    {title: '<spring:message code="crs.atndc.crtr.label.org.type"/>', field: 'orgTycdnm', headerHozAlign: 'center', hozAlign: 'center', minWidth: 190, widthGrow: 1, headerSort: false}, <%-- 기관 유형 --%>
                    {title: '<spring:message code="crs.atndc.crtr.label.charger"/>', field: 'chrgPrsnNm', headerHozAlign: 'center', hozAlign: 'center', width: 150, minWidth: 140, headerSort: false}, <%-- 담당자 --%>
                    {title: '<spring:message code="crs.atndc.crtr.label.manage.title"/>', field: 'manage', headerHozAlign: 'center', hozAlign: 'center', width: 270, minWidth: 260, formatter: 'html', headerSort: false} <%-- 출석점수기준관리 --%>
                ]
            });

            $('#searchOrgId, #searchHaksaYear, #searchHaksaTerm').on('keydown', function(e) {
                if(e.keyCode === 13) {
                    fn_search();
                }
            });
            $('#searchOrgId, #searchHaksaYear').on('change', function() {
                fn_loadSearchHaksaTerm('');
            });

            fn_loadList(CURRENT_PAGE);
        });

        function fn_search() {
            fn_loadList(1);
        }

        function fn_loadSearchHaksaTerm(selectedTerm) {
            var orgId = $('#searchOrgId').val();
            var haksaYear = $('#searchHaksaYear').val();

            renderSearchHaksaTermOptions([], '');
            if(!haksaYear) {
                return;
            }

            ajaxCall(CTX + '/atndcrtr/admListHaksaTerm.do', {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams({
                    orgId: orgId,
                    haksaYear: haksaYear
                })
            }, function(res) {
                if(res.encParams) {
                    EPARAM = res.encParams;
                }

                if(res.result > 0) {
                    renderSearchHaksaTermOptions(res.returnList || [], selectedTerm || '');
                } else {
                    UiComm.showMessage(res.message || '<spring:message code="crs.atndc.crtr.message.error.term.load" javaScriptEscape="true"/>', 'error'); <%-- 학기(기수) 목록 조회 중 오류가 발생했습니다. --%>
                }
            }, function() {
                UiComm.showMessage('<spring:message code="crs.atndc.crtr.message.error.term.load" javaScriptEscape="true"/>', 'error'); <%-- 학기(기수) 목록 조회 중 오류가 발생했습니다. --%>
            }, true);
        }

        function renderSearchHaksaTermOptions(list, selectedTerm) {
            var html = '<option value=""><spring:message code="crs.atndc.crtr.label.all" javaScriptEscape="true"/></option>'; <%-- 전체 --%>

            for(var i = 0; i < list.length; i++) {
                var term = list[i].haksaTerm || list[i].dgrsSmstrChrt || '';
                var termName = list[i].haksaTermNm || list[i].smstrChrtnm || list[i].smstrChrtNm || '';
                if(!term) {
                    continue;
                }
                html += '<option value="' + UiComm.escapeHtml(term) + '">' + UiComm.escapeHtml(fn_formatHaksaTermText(term, termName)) + '</option>';
            }

            $('#searchHaksaTerm').html(html).val(selectedTerm || '');
        }

        function fn_formatHaksaTermText(term, termName) {
            var nameText = $.trim(termName || '');
            if(nameText) {
                return nameText;
            }
            return $.trim(term || '');
        }

        function fn_loadList(pageIndex) {
            CURRENT_PAGE = pageIndex;

            var extData = {
                pageIndex: pageIndex,
                listScale: LIST_SCALE,
                haksaYear: $('#searchHaksaYear').val(),
                haksaTerm: $('#searchHaksaTerm').val(),
                orgId: $('#searchOrgId').val()
            };

            ajaxCall(CTX + '/atndcrtr/admListAtndCrtr.do', {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams(extData)
            }, function(res) {
                if(res.encParams) {
                    EPARAM = res.encParams;
                }

                if(res.result > 0) {
                    var dataList = fn_createListData(res.returnList || [], res.pageInfo);
                    $('#totalCnt').text(res.pageInfo ? res.pageInfo.totalRecordCount : 0);

                    atndCrtrTable.clearData();
                    atndCrtrTable.replaceData(dataList);
                    atndCrtrTable.setPageInfo(res.pageInfo);
                } else {
                    UiComm.showMessage(res.message || '<spring:message code="fail.common.select" javaScriptEscape="true"/>', 'error'); <%-- 조회에 실패하였습니다. --%>
                }
            }, function() {
                UiComm.showMessage('<spring:message code="fail.common.select" javaScriptEscape="true"/>', 'error'); <%-- 조회에 실패하였습니다. --%>
            }, true);
        }

        function fn_createListData(returnList, pageInfo) {
            var dataList = [];
            var startNo = pageInfo ? pageInfo.totalRecordCount - ((pageInfo.currentPageNo - 1) * LIST_SCALE) : returnList.length;

            returnList.forEach(function(v, i) {
                var smstrChrtId = v.smstrChrtId || v.atndCrtrId || '';
                var encodedId = encodeURIComponent(smstrChrtId);
                var yearTerm = fn_formatYearTerm(v.haksaYear, v.haksaTerm, v.haksaTermNm || v.smstrChrtnm || v.smstrChrtNm || '');
                var manageHtml = ''
                    + '<div class="form-inline justify-content-center">'
                    + '<button type="button" class="btn basic small" onclick="fn_goView(\'' + encodedId + '\')"><spring:message code="common.button.detailinfo" javaScriptEscape="true"/></button>' <%-- 상세정보 --%>
                    + '<button type="button" class="btn basic small" onclick="fn_goEdit(\'' + encodedId + '\')"><spring:message code="common.button.modify" javaScriptEscape="true"/></button>' <%-- 수정 --%>
                    + '<button type="button" class="btn basic small" onclick="fn_delete(\'' + encodedId + '\')"><spring:message code="common.button.delete" javaScriptEscape="true"/></button>' <%-- 삭제 --%>
                    + '</div>';

                dataList.push({
                    no: startNo - i,
                    yearTerm: UiComm.escapeHtml(yearTerm),
                    orgNm: UiComm.escapeHtml(v.orgNm || v.orgnm || ''),
                    orgShrtNm: UiComm.escapeHtml(v.orgShrtNm || v.orgShrtnm || ''),
                    orgTycdnm: UiComm.escapeHtml(v.orgTycdnm || v.orgTycd || ''),
                    chrgPrsnNm: UiComm.escapeHtml(v.chrgPrsnNm || v.chrgrnm || ''),
                    manage: manageHtml
                });
            });

            return dataList;
        }

        function fn_formatYearTerm(year, term, termName) {
            var yearText = year ? String(year) : '';
            var label = $.trim(termName || term || '');
            if(!yearText) {
                return label;
            }
            if(!label) {
                return yearText;
            }
            if(label.indexOf(yearText) === 0) {
                return label.replace('학년도', '년도');
            }

            return yearText + '<spring:message code="crs.atndc.crtr.label.year" javaScriptEscape="true"/>' + label; <%-- 년도 --%>
        }

        function fn_changeListScale(scale) {
            LIST_SCALE = Number(scale) || 20;
            fn_loadList(1);
        }

        function fn_goRegist() {
            var extData = {
                orgId: $('#searchOrgId').val(),
                haksaYear: $('#searchHaksaYear').val(),
                haksaTerm: $('#searchHaksaTerm').val()
            };
            location.href = fn_appendMenuId(CTX + '/atndcrtr/admAtndCrtrWrite.do?encParams=' + encodeURIComponent(EPARAM) + '&addParams=' + encodeURIComponent(UiComm.makeEncParams(extData)));
        }

        function fn_goRegistBySmstr(encodedId) {
            moveWithSmstr(CTX + '/atndcrtr/admAtndCrtrWrite.do', encodedId);
        }

        function fn_goView(encodedId) {
            moveWithSmstr(CTX + '/atndcrtr/admAtndCrtrView.do', encodedId);
        }

        function fn_goEdit(encodedId) {
            moveWithSmstr(CTX + '/atndcrtr/admAtndCrtrWrite.do', encodedId);
        }

        function moveWithSmstr(url, encodedId) {
            var addParams = UiComm.makeEncParams({ smstrChrtId: decodeURIComponent(encodedId) });
            location.href = fn_appendMenuId(url + '?encParams=' + encodeURIComponent(EPARAM) + '&addParams=' + encodeURIComponent(addParams));
        }

        function fn_appendMenuId(url) {
            if(!MENU_ID) {
                return url;
            }
            return url + (url.indexOf('?') > -1 ? '&' : '?') + 'menuId=' + encodeURIComponent(MENU_ID);
        }

        function fn_delete(encodedId) {
            UiComm.showMessage('<spring:message code="crs.atndc.crtr.message.confirm.delete" javaScriptEscape="true"/>', 'confirm').then(function(ok) { <%-- 출석점수 기준을 삭제하시겠습니까? --%>
                if(!ok) {
                    return;
                }

                ajaxCall(CTX + '/atndcrtr/admDeleteAtndCrtr.do', {
                    encParams: EPARAM,
                    addParams: UiComm.makeEncParams({ smstrChrtId: decodeURIComponent(encodedId) })
                }, function(res) {
                    if(res.encParams) {
                        EPARAM = res.encParams;
                    }

                    if(res.result > 0) {
                        UiComm.showMessage(res.message || '<spring:message code="success.common.delete"/>', 'success').then(function() { <%-- 정상적으로 삭제되었습니다. --%>
                            fn_loadList(CURRENT_PAGE);
                        });
                    } else {
                        UiComm.showMessage(res.message || '<spring:message code="crs.atndc.crtr.message.error.delete" javaScriptEscape="true"/>', 'error'); <%-- 삭제 중 오류가 발생했습니다. --%>
                    }
                }, function() {
                    UiComm.showMessage('<spring:message code="crs.atndc.crtr.message.error.delete" javaScriptEscape="true"/>', 'error'); <%-- 삭제 중 오류가 발생했습니다. --%>
                }, true);
            });
        }
    </script>
</body>
</html>
