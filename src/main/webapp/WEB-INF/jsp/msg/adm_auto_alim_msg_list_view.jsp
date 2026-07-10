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

<script type="text/javascript">
    const PAGE_INDEX = '<c:out value="${vo.pageIndex}" />' || 1;
    let LIST_SCALE   = '<c:out value="${vo.listScale}" />';
    let EPARAM       = '<c:out value="${encParams}" />';
    let TOTAL_CNT    = 0;
    let CURRENT_PAGE = PAGE_INDEX;

    const TRGT_MAP = {
        'WHOL_PROF': '전체교수',
        'WHOL_TUT': '전체튜터',
        'WHOL_ASSI': '전체조교',
        'WHOL_STDNT': '전체수강생',
        'CHRG_PROF': '담당교수',
        'CHRG_TUT': '담당튜터',
        'CHRG_ASSI': '담당조교',
        'SBJCT_STDNT': '해당과목수강생',
        'STDNT': '해당수강생'
    };

    $(document).ready(function() {
        fn_initSearch();
        fn_loadList(PAGE_INDEX);
    });

    function fn_initSearch() {
        $('#inputSearch1').on('keydown', function(e) {
            if (e.keyCode === 13) fn_search();
        });
    }

    function fn_search() {
        fn_loadList(1);
    }

    function fn_loadList(pageIndex) {
        CURRENT_PAGE = pageIndex;

        const extData = {
            pageIndex: pageIndex,
            listScale: LIST_SCALE,
            orgId: $('#searchOrgId').val(),
            searchText: $('#inputSearch1').val()
        };

        const param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams(extData)
        };

        ajaxCall('/admAutoAlimMsgListAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0) {
                fn_renderList(res.returnList, res.pageInfo);
                TOTAL_CNT = res.pageInfo ? res.pageInfo.totalRecordCount : 0;
                $('#totalCntText').text(TOTAL_CNT)
                UiComm.showPaging('pagingArea', { pageInfo: res.pageInfo, pageFunc: fn_loadList });
            } else {
                UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error");
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    function fn_renderList(list, pageInfo) {
        const $tbody = $('#listTbody');
        $tbody.empty();

        if (!list || list.length === 0) {
            $tbody.append('<tr><td colspan="8" class="txt-center"><spring:message code="common.content.not_found" text="등록된 내용이 없습니다."/></td></tr>');
            return;
        }

        const total = pageInfo ? pageInfo.totalRecordCount : 0;

        list.forEach(function(v, i) {
            const rnum = total - ((CURRENT_PAGE - 1) * LIST_SCALE) - i;
            const trgtStr = fn_convertTrgtStr(v.autoAlimTrgtTycdStr);
            let msgCts = UiComm.escapeHtml(v.autoAlimMsgCts || '');
            if (msgCts.length > 50) msgCts = msgCts.substring(0, 50) + '...';

            const html = '<tr>'
                + '<td class="txt-center">' + rnum + '</td>'
                + '<td class="txt-center">' + (v.autoAlimMsgId || '') + '</td>'
                + '<td class="txt-center">' + UiComm.escapeHtml(v.orgnm || '-') + '</td>'
                + '<td>' + UiComm.escapeHtml(v.autoAlimnm || '') + '</td>'
                + '<td>' + msgCts + '</td>'
                + '<td>' + UiComm.escapeHtml(v.sndngCndtnCts || '') + '</td>'
                + '<td>' + UiComm.escapeHtml(trgtStr) + '</td>'
                + '<td class="txt-center">'
                + '<button type="button" class="btn type5 btn-xs" onclick="fn_goModify(\'' + v.autoAlimMsgId + '\')">수정</button> '
                + '<button type="button" class="btn type5 btn-xs" onclick="fn_delete(\'' + v.autoAlimMsgId + '\')">삭제</button>'
                + '</td>'
                + '</tr>';
            $tbody.append(html);
        });
    }

    function fn_convertTrgtStr(trgtStr) {
        if (!trgtStr) return '';
        const codes = trgtStr.split(',');
        const names = [];
        codes.forEach(function(code) {
            if (TRGT_MAP[code]) names.push(TRGT_MAP[code]);
        });
        return names.join(', ');
    }

    function fn_changeListScale(scale) {
        LIST_SCALE = scale;
        fn_loadList(1);
    }

    function fn_excelDown() {
        // TODO: 엑셀 다운로드 구현
    }

    function fn_delete(autoAlimMsgId) {
        UiComm.showMessage('삭제하시겠습니까?', 'confirm').then(function(result) {
            if (!result) return;
            const extData = { autoAlimMsgId: autoAlimMsgId };
            const param = {
                  encParams: EPARAM
                , addParams: UiComm.makeEncParams(extData)
            };
            ajaxCall('/admAutoAlimMsgDeleteAjax.do', param, function(res) {
                if (res.encParams) EPARAM = res.encParams;
                if (res.result > 0) {
                    UiComm.showMessage('삭제되었습니다.', 'success');
                    fn_loadList(CURRENT_PAGE);
                } else {
                    UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error");
                }
            }, function() {
                UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
            }, true);
        });
    }

    function fn_goRegist() {
        const form = $('<form></form>');
        form.attr('method', 'POST');
        form.attr('action', '/admAutoAlimMsgRegistView.do');
        form.append($('<input/>', { type: 'hidden', name: 'encParams', value: EPARAM }));
        form.appendTo('body');
        form.submit();
    }

    function fn_goModify(autoAlimMsgId) {
        const extData = { autoAlimMsgId: autoAlimMsgId };
        const form = $('<form></form>');
        form.attr('method', 'POST');
        form.attr('action', '/admAutoAlimMsgSelectView.do');
        form.append($('<input/>', { type: 'hidden', name: 'encParams', value: EPARAM }));
        form.append($('<input/>', { type: 'hidden', name: 'addParams', value: UiComm.makeEncParams(extData) }));
        form.appendTo('body');
        form.submit();
    }
</script>

<body class="admin">
    <div id="wrap" class="main">
        <!-- common header -->
        <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>

        <!-- admin -->
        <main class="common">

            <!-- gnb -->
            <%@ include file="/WEB-INF/jsp/common_new/admin_aside.jsp" %>

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="admin_sub">

                    <div class="sub-content">
                        <!-- page info -->
                        <div class="page-info">
                            <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                            <uiex:navibar type="admin"/>
                        </div>

                        <!-- search typeA -->
                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="searchOrgId">기관</label></span>
                                <div class="itemList">
                                    <select class="form-control" id="searchOrgId">
                                        <option value="">전체</option>
                                        <c:forEach var="org" items="${orgList}">
                                            <option value="${org.orgId}"><c:out value="${org.orgnm}"/></option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="inputSearch1">검색 조건</label></span>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" id="inputSearch1" value="<c:out value="${vo.searchText}"/>" placeholder="검색어 입력" onkeypress="if(event.keyCode==13) fn_search();">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="fn_search()">검색</button>
                            </div>
                        </div>

                        <!-- board top -->
                        <div class="board_top">
                            <h3 class="board-title"><spring:message code="msg.common.label.list" text="목록"/>
                                [<spring:message code="msg.sndrDsctn.label.totalCnt" text="총건수"/> : <b
                                        id="totalCntText">0</b><spring:message code="msg.sndrDsctn.label.cnt" text="건"/> ]
                            </h3>
                            <div class="right-area">
                                <button type="button" class="btn basic" onclick="fn_excelDown()">엑셀 다운로드</button>
                                <button type="button" class="btn type2" onclick="fn_goRegist()">등록</button>
                                <uiex:listScale func="fn_changeListScale" value="${vo.listScale}" />
                            </div>
                        </div>

                        <!-- list table -->
                        <div class="table-wrap">
                            <table class="table-type1">
                                <colgroup>
                                    <col style="width:5%;" />
                                    <col style="width:8%;" />
                                    <col style="width:8%;" />
                                    <col style="width:15%;" />
                                    <col style="width:22%;" />
                                    <col style="width:15%;" />
                                    <col style="width:15%;" />
                                    <col style="width:12%;" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>번호</th>
                                        <th>코드</th>
                                        <th>기관</th>
                                        <th>자동 알림 구분</th>
                                        <th>사용 문구 예시</th>
                                        <th>발신 조건</th>
                                        <th>알림 대상</th>
                                        <th>관리</th>
                                    </tr>
                                </thead>
                                <tbody id="listTbody">
                                </tbody>
                            </table>
                        </div>

                        <!-- board foot -->
                        <div id="pagingArea" class="board_foot"></div>

                    </div>
                </div>
            </div>
            <!-- //content -->

        </main>
        <!-- //admin -->
    </div>
</body>
</html>
