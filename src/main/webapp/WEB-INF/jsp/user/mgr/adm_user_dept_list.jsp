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
        let LIST_SCALE = Number('<c:out value="${vo.recordCountPerPage}" />') || 10;
        let PAGE_SIZE = Number('<c:out value="${vo.pageSize}" />') || 10;
        let CURRENT_PAGE = Number('<c:out value="${vo.currentPageNo}" />') || 1;
        let EPARAM = '<c:out value="${encParams}" />';
        const MENU_ID = '<c:out value="${vo.menuId}" />';
        const CTX = '<%=request.getContextPath()%>';
        const ALL_ORG_YN = '<c:out value="${allOrgYn}" />';
        const HAKSA_SYNC_YN = '<c:out value="${haksaSyncYn}" />';
        const SELECTED_ORG_ID = '<c:out value="${vo.orgId}" />';
        const SELECTED_SEARCH_VALUE = '<c:out value="${vo.searchValue}" />';

        let CURRENT_DEPT_CODE_LIST = [];
        <c:forEach var="item" items="${deptCodeList}">
        CURRENT_DEPT_CODE_LIST.push({
            deptId: '<c:out value="${item.deptId}" />',
            deptnm: '<c:out value="${item.deptnm}" />'
        });
        </c:forEach>

        let EDIT_MODE = false;
        let userDeptTable;
        let dialog;

        $(function() {
            userDeptTable = UiTable('userDeptList', {
                lang: 'ko',
                pageFunc: listPaging,
                columns: [
                    {title: 'No', field: 'no', headerHozAlign: 'center', hozAlign: 'center', width: 60, minWidth: 60, headerSort: false},
                    {title: '기관', field: 'orgnm', headerHozAlign: 'center', hozAlign: 'left', minWidth: 120, width: 140, headerSort: false},
                    {title: '상위 학과/부서코드', field: 'upDeptId', headerHozAlign: 'center', hozAlign: 'center', minWidth: 130, width: 150, headerSort: false},
                    {title: '학과/부서코드', field: 'deptId', headerHozAlign: 'center', hozAlign: 'center', minWidth: 120, width: 140, headerSort: false},
                    {title: '학과/부서명 (KR)', field: 'deptnm', headerHozAlign: 'center', hozAlign: 'left', minWidth: 200, widthGrow: 1, headerSort: false},
                    {title: '학과/부서명 (EN)', field: 'deptEnnm', headerHozAlign: 'center', hozAlign: 'left', minWidth: 200, widthGrow: 1, headerSort: false},
                    {title: '관리', field: 'manage', headerHozAlign: 'center', hozAlign: 'center', minWidth: 150, width: 150, formatter: 'html', headerSort: false}
                ]
            });

            renderUpDeptOptions(CURRENT_DEPT_CODE_LIST);

            $('#searchValue').val(SELECTED_SEARCH_VALUE);
            $('#searchValue').on('keydown', function(e) {
                if (e.keyCode === 13) {
                    fn_search();
                }
            });

            fn_setHaksaSyncButton(HAKSA_SYNC_YN);
            listPaging(CURRENT_PAGE);
        });

        function fn_setHaksaSyncButton(syncYn) {
            const $button = $('#btnHaksaSync');
            if (syncYn === 'Y') {
                $button.show();
            } else {
                $button.hide();
            }
        }

        function renderUpDeptOptions(list) {
            let html = '<option value="">ROOT</option>';
            for (let i = 0; i < list.length; i++) {
                const code = UiComm.escapeHtml(String(list[i].deptId || ''));
                const name = UiComm.escapeHtml(String(list[i].deptnm || list[i].deptId || ''));
                html += '<option value="' + code + '">' + code + (name ? ' (' + name + ')' : '') + '</option>';
            }
            $('#formUpDeptId').html(html).trigger('chosen:updated');
        }

        function fn_changeFormOrg() {
            const orgId = $('#formOrgId').val();
            if (!orgId) {
                CURRENT_DEPT_CODE_LIST = [];
                renderUpDeptOptions([]);
                return;
            }

            ajaxCall(CTX + '/user/userMgrDept/admListUserMgrDeptCode.do', {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams({orgId: orgId})
            }, function(res) {
                if (res.encParams) {
                    EPARAM = res.encParams;
                }
                if (res.result > 0) {
                    CURRENT_DEPT_CODE_LIST = res.returnList || [];
                    renderUpDeptOptions(CURRENT_DEPT_CODE_LIST);
                } else {
                    CURRENT_DEPT_CODE_LIST = [];
                    renderUpDeptOptions([]);
                }
            }, function() {
                UiComm.showMessage('조회 중 오류가 발생하였습니다.', 'error');
            });
        }

        function changeListScale(scale) {
            LIST_SCALE = Number(scale) || 10;
            listPaging(1);
        }

        function fn_search() {
            listPaging(1);
        }

        function fn_makeListParams(pageIndex) {
            return {
                orgId: $('#searchOrgId').val(),
                searchValue: $('#searchValue').val(),
                currentPageNo: pageIndex,
                recordCountPerPage: LIST_SCALE,
                pageSize: PAGE_SIZE
            };
        }

        function listPaging(pageIndex) {
            CURRENT_PAGE = pageIndex;

            ajaxCall(CTX + '/user/userMgrDept/admListUserMgrDept.do', {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams(fn_makeListParams(pageIndex))
            }, function(res) {
                if (res.encParams) {
                    EPARAM = res.encParams;
                }

                if (res.result > 0) {
                    $('#totalCnt').text(res.pageInfo ? res.pageInfo.totalRecordCount : 0);

                    if (res.pageInfo && res.pageInfo.recordCountPerPage) {
                        LIST_SCALE = Number(res.pageInfo.recordCountPerPage) || LIST_SCALE;
                    }
                    if (res.pageInfo && res.pageInfo.pageSize) {
                        PAGE_SIZE = Number(res.pageInfo.pageSize) || PAGE_SIZE;
                    }

                    userDeptTable.clearData();
                    userDeptTable.replaceData(createListData(res.returnList || [], res.pageInfo));
                    userDeptTable.setPageInfo(res.pageInfo);
                } else {
                    UiComm.showMessage(res.message || '조회 중 오류가 발생하였습니다.', 'error');
                }
            }, function() {
                UiComm.showMessage('조회 중 오류가 발생하였습니다.', 'error');
            }, true);
        }

        function createListData(returnList, pageInfo) {
            const dataList = [];
            const totalCount = pageInfo && pageInfo.totalRecordCount ? Number(pageInfo.totalRecordCount) : returnList.length;

            for (let j = 0; j < returnList.length; j++) {
                const item = returnList[j];
                const rowNo = Number(item.lineNo || item.LINE_NO || 0);
                const displayNo = rowNo > 0 ? totalCount - rowNo + 1 : returnList.length - j;
                const deptId = String(item.deptId || '');
                const manageHtml = ''
                    + '<div class="form-inline justify-content-center word_break_none">'
                    + '<button type="button" class="btn basic small" onclick="fn_edit(\'' + encodeURIComponent(deptId) + '\')">수정</button>'
                    + '<button type="button" class="btn basic small" onclick="fn_delete(\'' + encodeURIComponent(deptId) + '\')">삭제</button>'
                    + '</div>';

                dataList.push({
                    no: displayNo,
                    orgnm: UiComm.escapeHtml(String(item.orgnm || '-')),
                    upDeptId: UiComm.escapeHtml(String(item.upDeptId || 'ROOT')),
                    deptId: UiComm.escapeHtml(deptId),
                    deptnm: UiComm.escapeHtml(String(item.deptnm || '-')),
                    deptEnnm: UiComm.escapeHtml(String(item.deptEnnm || '-')),
                    manage: manageHtml
                });
            }

            return dataList;
        }

        function fn_validateForm() {
            if (!$('#formOrgId').val()) {
                UiComm.showMessage('기관을 선택해 주세요.', 'warning');
                return false;
            }
            if (!$.trim($('#formDeptId').val())) {
                UiComm.showMessage('학과/부서 코드를 입력해 주세요.', 'warning');
                return false;
            }
            if (!$.trim($('#formDeptnm').val())) {
                UiComm.showMessage('학과/부서명(KR)을 입력해 주세요.', 'warning');
                return false;
            }
            return true;
        }

        function fn_save() {
            if (!fn_validateForm()) {
                return;
            }

            const isEdit = EDIT_MODE;
            const url = isEdit
                ? CTX + '/user/userMgrDept/admModifyUserMgrDept.do'
                : CTX + '/user/userMgrDept/admRegistUserMgrDept.do';

            const params = {
                orgId: $('#formOrgId').val(),
                upDeptId: $('#formUpDeptId').val(),
                deptId: $.trim($('#formDeptId').val()),
                deptnm: $.trim($('#formDeptnm').val()),
                deptEnnm: $.trim($('#formDeptEnnm').val())
            };
            if (isEdit) {
                params.orgDeptId = $('#formOrgDeptId').val();
            }

            ajaxCall(url, {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams(params)
            }, function(res) {
                if (res.encParams) {
                    EPARAM = res.encParams;
                }
                if (res.result > 0) {
                    UiComm.showMessage(res.message || '저장되었습니다.', 'success');
                    fn_clearForm();
                    listPaging(isEdit ? CURRENT_PAGE : 1);
                } else {
                    UiComm.showMessage(res.message || '처리 중 오류가 발생하였습니다.', 'error');
                }
            }, function() {
                UiComm.showMessage('처리 중 오류가 발생하였습니다.', 'error');
            }, true);
        }

        function fn_edit(encodedDeptId) {
            const deptId = decodeURIComponent(encodedDeptId || '');
            if (!deptId) {
                return;
            }

            ajaxCall(CTX + '/user/userMgrDept/admSelectUserMgrDept.do', {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams({deptId: deptId})
            }, function(res) {
                if (res.encParams) {
                    EPARAM = res.encParams;
                }
                if (res.result > 0 && res.data) {
                    const data = res.data;
                    $('#formOrgId').val(data.orgId || '').trigger('chosen:updated');
                    fn_loadUpDeptForEdit(data.orgId, data.upDeptId);
                    $('#formOrgDeptId').val(data.deptId || '');
                    $('#formDeptId').val(data.deptId || '');
                    $('#formDeptnm').val(data.deptnm || '');
                    $('#formDeptEnnm').val(data.deptEnnm || '');
                    EDIT_MODE = true;
                    $('#btnSave').text('수정');
                } else {
                    UiComm.showMessage(res.message || '조회 중 오류가 발생하였습니다.', 'error');
                }
            }, function() {
                UiComm.showMessage('조회 중 오류가 발생하였습니다.', 'error');
            });
        }

        function fn_loadUpDeptForEdit(orgId, upDeptId) {
            if (!orgId) {
                renderUpDeptOptions([]);
                return;
            }

            ajaxCall(CTX + '/user/userMgrDept/admListUserMgrDeptCode.do', {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams({orgId: orgId})
            }, function(res) {
                if (res.encParams) {
                    EPARAM = res.encParams;
                }
                CURRENT_DEPT_CODE_LIST = res.result > 0 ? (res.returnList || []) : [];
                renderUpDeptOptions(CURRENT_DEPT_CODE_LIST);
                $('#formUpDeptId').val(upDeptId || '').trigger('chosen:updated');
            }, function() {
                renderUpDeptOptions([]);
            });
        }

        function fn_delete(encodedDeptId) {
            const deptId = decodeURIComponent(encodedDeptId || '');
            if (!deptId) {
                return;
            }

            UiComm.showMessage('정말 삭제하시겠습니까?', 'confirm').then(function(ok) {
                if (!ok) {
                    return;
                }

                ajaxCall(CTX + '/user/userMgrDept/admDeleteUserMgrDept.do', {
                    encParams: EPARAM,
                    addParams: UiComm.makeEncParams({deptId: deptId})
                }, function(res) {
                    if (res.encParams) {
                        EPARAM = res.encParams;
                    }
                    if (res.result > 0) {
                        UiComm.showMessage(res.message || '정상적으로 삭제되었습니다.', 'success');
                        fn_clearForm();
                        listPaging(CURRENT_PAGE);
                    } else {
                        UiComm.showMessage(res.message || '삭제 중 오류가 발생하였습니다.', 'error');
                    }
                }, function() {
                    UiComm.showMessage('삭제 중 오류가 발생하였습니다.', 'error');
                }, true);
            });
        }

        function fn_clearForm() {
            EDIT_MODE = false;
            $('#formOrgDeptId').val('');
            $('#formUpDeptId').val('').trigger('chosen:updated');
            $('#formDeptId').val('');
            $('#formDeptnm').val('');
            $('#formDeptEnnm').val('');
            $('#btnSave').text('저장');
        }

        function fn_openHaksaSyncPop() {
            const orgId = $('#formOrgId').val();
            if (!orgId) {
                UiComm.showMessage('기관을 선택해 주세요.', 'warning');
                return;
            }

            dialog = UiDialog('dialog1', {
                title: '학사연동 가져오기',
                width: 720,
                height: 480,
                url: CTX + '/user/userMgrDept/admUserMgrDeptHaksaSyncPopup.do?encParams=' + encodeURIComponent(EPARAM)
                    + '&addParams=' + encodeURIComponent(UiComm.makeEncParams({orgId: orgId})),
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
<div id="wrap" class="main user-dept-page">
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

                    <!-- 목록/등록/수정 -->
                    <div class="board_top">
                        <h3 class="board-title">목록/등록/수정</h3>
                        <div class="right-area">
                            <button type="button" id="btnHaksaSync" class="btn type2" style="display:none;" onclick="fn_openHaksaSyncPop();">학사연동 가져오기</button>
                            <button type="button" id="btnSave" class="btn type1" onclick="fn_save();">저장</button>
                        </div>
                    </div>

                    <div class="table-wrap">
                        <table class="table-type5">
                            <colgroup>
                                <col class="width-15per"/>
                                <col/>
                                <col class="width-15per"/>
                                <col/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th class="req">기관</th>
                                    <td data-th="기관">
                                        <div class="form-inline">
                                            <select id="formOrgId" class="form-select type-num" onchange="fn_changeFormOrg();" <c:if test="${allOrgYn ne 'Y'}">disabled="disabled"</c:if>>
                                                <c:if test="${allOrgYn eq 'Y'}">
                                                    <option value="">선택하세요</option>
                                                </c:if>
                                                <c:forEach var="org" items="${orgList}">
                                                    <option value="${org.orgId}" <c:if test="${org.orgId eq vo.orgId}">selected="selected"</c:if>><c:out value="${org.orgnm}"/></option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </td>
                                    <th class="req">상위 학과/부서 코드</th>
                                    <td data-th="상위 학과/부서 코드">
                                        <div class="form-inline">
                                            <select id="formUpDeptId" class="form-select" required="true"></select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="req">학과/부서 코드</th>
                                    <td data-th="학과/부서 코드">
                                        <div class="form-inline">
                                            <input type="text" id="formDeptId" class="form-control" maxlength="30"/>
                                        </div>
                                    </td>
                                    <th class="req">학과/부서명(KR)</th>
                                    <td data-th="학과/부서명(KR)">
                                        <div class="form-inline">
                                            <input type="text" id="formDeptnm" class="form-control" maxlength="200"/>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>학과/부서명(EN)</th>
                                    <td data-th="학과/부서명(EN)" colspan="3">
                                        <div class="form-inline">
                                            <input type="text" id="formDeptEnnm" class="form-control" maxlength="200"/>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <input type="hidden" id="formOrgDeptId"/>
                    </div>

                    <!-- 검색 -->
                    <div class="board_top in_table">
                        <select id="searchOrgId" class="form-select type-num" onchange="fn_search();" <c:if test="${allOrgYn ne 'Y'}">disabled="disabled"</c:if>>
                            <c:if test="${allOrgYn eq 'Y'}">
                                <option value="">전체</option>
                            </c:if>
                            <c:forEach var="org" items="${orgList}">
                                <option value="${org.orgId}" <c:if test="${org.orgId eq vo.orgId}">selected="selected"</c:if>><c:out value="${org.orgnm}"/></option>
                            </c:forEach>
                        </select>
                        <div class="search-typeC">
                            <input type="text" id="searchValue" class="form-control" placeholder="코드/학과명/부서명 검색"/>
                            <button type="button" class="btn basic icon search" aria-label="검색" onclick="fn_search();"><i class="icon-svg-search"></i></button>
                        </div>
                        <div class="right-area">
                            <span class="total_num">총 <strong id="totalCnt">0</strong>건</span>
                            <uiex:listScale func="changeListScale" value="${vo.recordCountPerPage}"/>
                        </div>
                    </div>

                    <div class="table-wrap">
                        <div id="userDeptList"></div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

</body>
</html>
