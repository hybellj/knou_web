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
        const SELECTED_ORG_ID = '<c:out value="${vo.orgId}" />';
        const SELECTED_AUTHRT_GRPCD = '<c:out value="${vo.authrtGrpcd}" />';
        const SELECTED_USER_TYCD = '<c:out value="${vo.userTycd}" />';
        const SELECTED_SEARCH_VALUE = '<c:out value="${vo.searchValue}" />';
        const CURRENT_USER_NM = '<c:out value="${loginUserNm}" />';
        const CURRENT_USER_PHN = '<c:out value="${loginUserMblPhn}" />';

        const DEFAULT_PHOTO = '<c:url value="/webdoc/assets/img/common/default_prof.png"/>';
        const AC_RCD_MAP = {};
        <c:forEach var="item" items="${acRcdTyList}">
        AC_RCD_MAP['<c:out value="${item.cd}" />'] = '<c:out value="${item.cdnm}" />';
        </c:forEach>

        let userTable;
        let dialog;
        let INFO_USER_ID = '';

        $(function() {
            userTable = UiTable('userList', {
                lang: 'ko',
                pageFunc: listPaging,
                selectableRows: 'highlight',
                columns: [
                    {formatter: 'rowSelection', titleFormatter: 'rowSelection', headerHozAlign: 'center', hozAlign: 'center', vertAlign: 'middle', width: '3%', minWidth: 44, headerSort: false, cellClick: function(e, cell) { cell.getRow().toggleSelect(); }},
                    {title: '번호', field: 'no', headerHozAlign: 'center', hozAlign: 'center', width: '5%', minWidth: 50, headerSort: false},
                    {title: '관리자 구분', field: 'authrtGrpnm', headerHozAlign: 'center', hozAlign: 'center', width: '11%', minWidth: 100, headerSort: false},
                    {title: '사용자 구분', field: 'userTynm', headerHozAlign: 'center', hozAlign: 'center', width: '11%', minWidth: 100, headerSort: false},
                    {title: '기관', field: 'orgnm', headerHozAlign: 'center', hozAlign: 'center', width: '15%', minWidth: 100, headerSort: false},
                    {title: '학번/사번', field: 'stdntNo', headerHozAlign: 'center', hozAlign: 'center', width: '13%', minWidth: 90, headerSort: false},
                    {title: '이름', field: 'usernm', headerHozAlign: 'center', hozAlign: 'center', width: '11%', minWidth: 90, headerSort: false, formatter: 'html'},
                    {title: '학적 상태', field: 'acRcdTynm', headerHozAlign: 'center', hozAlign: 'center', width: '12%', minWidth: 90, headerSort: false},
                    {title: '관리', field: 'manage', headerHozAlign: 'center', hozAlign: 'center', width: '19%', minWidth: 180, formatter: 'html', headerSort: false}
                ]
            });

            $('#searchValue').val(SELECTED_SEARCH_VALUE);
            $('#searchValue').on('keydown', function(e) {
                if (e.keyCode === 13) {
                    fn_search();
                }
            });

            listPaging(CURRENT_PAGE);
        });

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
                authrtGrpcd: $('#searchAuthrtGrpcd').val(),
                userTycd: $('#searchUserTycd').val(),
                searchValue: $('#searchValue').val(),
                currentPageNo: pageIndex,
                recordCountPerPage: LIST_SCALE,
                pageSize: PAGE_SIZE
            };
        }

        function listPaging(pageIndex) {
            CURRENT_PAGE = pageIndex;

            ajaxCall(CTX + '/user/userMgr/admListUserMgr.do', {
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

                    userTable.clearData();
                    userTable.replaceData(createListData(res.returnList || [], res.pageInfo));
                    userTable.setPageInfo(res.pageInfo);
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
                const userId = String(item.userId || '');
                const encUserId = encodeURIComponent(userId);
                const usernm = UiComm.escapeHtml(String(item.usernm || '-'));
                const stdntNo = UiComm.escapeHtml(String(item.stdntNo || '-'));
                const userTycd = String(item.userTycd || '');
                const rowOrgId = String(item.orgId || '');

                const nameHtml = '<a href="#none" class="fcBlue" onclick="fn_userInfoModal(\'' + encUserId + '\'); return false;">' + usernm + '</a>';
                const stdntNoHtml = '<span class="fcRed">' + stdntNo + '</span>';

                const adminAuthrtnm = String(item.adminAuthrtnm || '');
                const userTyAuthrtnm = String(item.userTyAuthrtnm || '');
                const adminGbn = adminAuthrtnm || '-';
                const userGbn = userTyAuthrtnm ? userTyAuthrtnm : (adminAuthrtnm ? '교직원' : '-');

                const isGuest = String(item.guestYn || 'N') === 'Y';
                const loginBtn = '<button type="button" class="btn basic small" onclick="fn_login(\'' + encUserId + '\', \'' + userTycd + '\', \'' + rowOrgId + '\')">로그인</button>';
                const editBtn = '<button type="button" class="btn basic small" onclick="fn_edit(\'' + encUserId + '\')">수정</button>';
                const authBtn = '<button type="button" class="btn basic small" onclick="fn_authChange(\'' + encUserId + '\')">권한변경</button>';
                const withdrawBtn = '<button type="button" class="btn basic small" onclick="fn_withdraw(\'' + encUserId + '\')">탈퇴</button>';
                const manageHtml = ''
                    + '<div class="form-inline justify-content-center word_break_none">'
                    + (isGuest ? (editBtn + authBtn + withdrawBtn) : (loginBtn + editBtn + authBtn))
                    + '</div>';

                dataList.push({
                    no: displayNo,
                    authrtGrpnm: UiComm.escapeHtml(adminGbn),
                    userTynm: UiComm.escapeHtml(userGbn),
                    orgnm: UiComm.escapeHtml(String(item.orgnm || '-')),
                    stdntNo: stdntNoHtml,
                    usernm: nameHtml,
                    acRcdTynm: UiComm.escapeHtml(String(AC_RCD_MAP[item.acRcdTycd] || item.acRcdTycd || '-')),
                    manage: manageHtml
                });
            }

            return dataList;
        }

        function fn_regist() {
            location.href = CTX + '/user/userMgr/admUserMgrWriteForm.do?encParams=' + encodeURIComponent(EPARAM);
        }

        function fn_login(encodedUserId, userTycd, orgId) {
            const userId = decodeURIComponent(encodedUserId || '');
            if (!userId) {
                return;
            }

            const tycd = String(userTycd || '').toUpperCase();
            let goUrl;
            if (tycd.indexOf('PROF') > -1) {
                goUrl = '/dashboard/profDashboard.do';
            } else if (tycd.indexOf('STDNT') > -1) {
                goUrl = '/dashboard/stuDashboard.do?orgId=' + encodeURIComponent(orgId || '');
            } else if (tycd.indexOf('ADM') > -1) {
                UiComm.showMessage('관리자는 대리로그인할 수 없습니다.', 'info');
                return;
            } else {
                UiComm.showMessage('대리로그인할 수 없는 사용자입니다.', 'info');
                return;
            }

            const supportWin = window.open('', 'userSupportWin');
            const $form = $('#userMoveForm');
            $form.attr('action', CTX + '/user/userMgr/admLoginAsUser.do');
            $form.find('input[name=userId]').val(userId);
            $form.find('input[name=goUrl]').val(goUrl);
            $form.submit();

            const closeTimer = setInterval(function() {
                if (!supportWin || supportWin.closed) {
                    clearInterval(closeTimer);
                    $.ajax({ url: CTX + '/user/userMgr/restoreAdminContext.do', type: 'POST', timeout: 3000 });
                }
            }, 1000);
        }

        function fn_edit(encodedUserId) {
            const userId = decodeURIComponent(encodedUserId || '');
            if (!userId) {
                return;
            }
            location.href = CTX + '/user/userMgr/admUserMgrWriteForm.do?encParams=' + encodeURIComponent(EPARAM)
                + '&addParams=' + encodeURIComponent(UiComm.makeEncParams({userId: userId}));
        }

        function fn_authChange(encodedUserId) {
            const userId = decodeURIComponent(encodedUserId || '');
            if (!userId) {
                return;
            }

            dialog = UiDialog('dialog1', {
                title: '권한 변경',
                width: 1200,
                height: 360,
                url: CTX + '/user/userMgr/admUserMgrAuthChangePop.do?encParams=' + encodeURIComponent(EPARAM)
                    + '&addParams=' + encodeURIComponent(UiComm.makeEncParams({userId: userId})),
                autoresize: false
            });
        }

        function fn_authChangeCallback() {
            if (dialog) {
                dialog.close();
            }
            listPaging(CURRENT_PAGE);
        }

        function closeDialog() {
            if (dialog) {
                dialog.close();
            }
        }

        function fn_withdraw(encodedUserId) {
            const userId = decodeURIComponent(encodedUserId || '');
            if (!userId) {
                return;
            }

            UiComm.showMessage('해당 손님 사용자를 탈퇴 처리하시겠습니까?', 'confirm').then(function(ok) {
                if (!ok) {
                    return;
                }
                ajaxCall(CTX + '/user/userMgr/admWithdrawUserMgr.do', {
                    encParams: EPARAM,
                    addParams: UiComm.makeEncParams({ userId: userId })
                }, function(res) {
                    if (res.encParams) {
                        EPARAM = res.encParams;
                    }
                    if (res.result > 0) {
                        UiComm.showMessage(res.message || '탈퇴 처리되었습니다.', 'success').then(function() {
                            listPaging(CURRENT_PAGE);
                        });
                    } else {
                        UiComm.showMessage(res.message || '처리 중 오류가 발생하였습니다.', 'error');
                    }
                }, function() {
                    UiComm.showMessage('처리 중 오류가 발생하였습니다.', 'error');
                }, true);
            });
        }

        function fn_userInfoModal(encodedUserId) {
            const userId = decodeURIComponent(encodedUserId || '');
            if (!userId) {
                return;
            }
            INFO_USER_ID = userId;  // 연락처 변경이력 조회용으로 현재 사용자 보관

            ajaxCall(CTX + '/user/userMgr/admSelectUserMgr.do', {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams({ userId: userId })
            }, function(res) {
                if (res.encParams) {
                    EPARAM = res.encParams;
                }
                if (res.result > 0 && res.data) {
                    const $content = $('#modal1 .modal-body').clone();
                    fn_fillUserInfo($content, res.data);
                    dialog = UiDialog('dialog1', {
                        title: '사용자 정보',
                        width: 800,
                        height: 480,
                        html: $content
                    });
                } else {
                    UiComm.showMessage(res.message || '조회 중 오류가 발생하였습니다.', 'error');
                }
            }, function() {
                UiComm.showMessage('조회 중 오류가 발생하였습니다.', 'error');
            }, true);
        }

        function fn_fillUserInfo($scope, v) {
            $scope.find('#infoOrgnm').text(v.orgnm || '-');
            $scope.find('#infoUsernm').text(v.usernm || '-');
            $scope.find('#infoStdntNo').text(v.stdntNo || '-');
            $scope.find('#infoUserId').text(v.userId || '-');
            $scope.find('#infoMobile').text(v.mobileNo || '-');
            $scope.find('#infoEmail').text(v.email || '-');
            fn_renderProfilePhoto($scope.find('#infoPhoto'), v.photoFileId);
        }

        function fn_renderProfilePhoto($img, photoFileId) {
            if (fn_isRenderablePhotoFileId(photoFileId)) {
                $img.off('error').on('error', function() {
                    $(this).attr('src', DEFAULT_PHOTO);
                }).attr('src', photoFileId);
            } else {
                $img.off('error').attr('src', DEFAULT_PHOTO);
            }
        }

        function fn_isRenderablePhotoFileId(photoFileId) {
            if (!photoFileId) {
                return false;
            }
            const s = String(photoFileId).trim();
            if (!s || s === 'user_img') {
                return false;
            }
            if (s.indexOf('photo_user_sample') !== -1 || s.indexOf('user_no_img') !== -1) {
                return false;
            }
            return s.indexOf('data:image') === 0
                || s.indexOf('/') === 0
                || s.indexOf('http://') === 0
                || s.indexOf('https://') === 0
                || s.indexOf('blob:') === 0;
        }

        function fn_contactHistModal() {
            if (!INFO_USER_ID) {
                return;
            }

            ajaxCall(CTX + '/user/userMgr/admListUserTelnoChgHstry.do', {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams({ userId: INFO_USER_ID })
            }, function(res) {
                if (res.encParams) {
                    EPARAM = res.encParams;
                }
                const $content = $('#modal2 .modal-body').clone();
                fn_fillContactHist($content, res.result > 0 ? (res.returnList || []) : []);
                dialog = UiDialog('dialog2', {
                    title: '연락처 변경이력',
                    width: 1200,
                    height: 480,
                    html: $content
                });
            }, function() {
                UiComm.showMessage('조회 중 오류가 발생하였습니다.', 'error');
            }, true);
        }

        function fn_fillContactHist($scope, list) {
            const $tbody = $scope.find('tbody');
            if (!list.length) {
                $tbody.html('<tr><td colspan="9" class="t_center">연락처 변경이력이 없습니다.</td></tr>');
                return;
            }
            let html = '';
            for (let i = 0; i < list.length; i++) {
                const v = list[i];
                html += '<tr>'
                    + '<td>' + (v.rnum || (i + 1)) + '</td>'
                    + '<td>' + UiComm.escapeHtml(String(v.orgnm || '-')) + '</td>'
                    + '<td>' + UiComm.escapeHtml(String(v.dgrsYr || '-')) + '</td>'
                    + '<td>' + UiComm.escapeHtml(String(v.dgrsSmstrChrt || '-')) + '</td>'
                    + '<td>' + UiComm.escapeHtml(String(v.stdntNo || '-')) + '</td>'
                    + '<td>' + UiComm.escapeHtml(String(v.usernm || '-')) + '</td>'
                    + '<td>' + UiComm.escapeHtml(String(v.chgbfrMblTelno || '-')) + '</td>'
                    + '<td>' + UiComm.escapeHtml(String(v.chgaftMblTelno || '-')) + '</td>'
                    + '<td>' + UiComm.formatDate(v.chgDttm, 'datetime2') + '</td>'
                    + '</tr>';
            }
            $tbody.html(html);
        }

        let MSG_BODY = null;
        let MSG_RCVR_LIST = [];
        let MSG_TEMPLATE = null;
        let rcvrDlg;

        function fn_msgModal() {
            MSG_RCVR_LIST = [];
            // 원본 #modal4를 최초 1회 캐싱 후 DOM에서 제거 → id 중복(label-for 오작동) 방지
            if (MSG_TEMPLATE === null) {
                MSG_TEMPLATE = $('#modal4 .modal-body').html();
                $('#modal4').remove();
            }
            MSG_BODY = $('<div class="modal-body"></div>').html(MSG_TEMPLATE);
            dialog = UiDialog('dialog1', {
                title: '알림 바로 보내기',
                width: 1200,
                height: 800,
                html: MSG_BODY
            });
            MSG_BODY.find('#msgSndngrPhn').val(CURRENT_USER_PHN);
            fn_msgRenderRcvr();
            fn_msgByteCount();
        }

        function fn_msgByteCount() {
            if (!MSG_BODY) return;
            const txt = MSG_BODY.find('#msgContent').val() || '';
            let bytes = 0;
            for (let i = 0; i < txt.length; i++) {
                bytes += txt.charCodeAt(i) > 127 ? 2 : 1;
            }
            MSG_BODY.find('#msgByte').text(bytes);
        }

        function fn_msgToggleSelf(el) {
            const $nm = MSG_BODY.find('#msgSndngr');
            if (el.checked) {
                $nm.val(CURRENT_USER_NM).prop('readonly', true);
            } else {
                $nm.prop('readonly', false);
            }
        }

        function fn_msgAddRcvr() {
            rcvrDlg = UiDialog('rcvrDlg', {
                title: '받는 사람 추가',
                width: 1200,
                height: 720,
                url: CTX + '/admMsgMgrRcvrPopView.do'
            });
        }

        function fn_addSelectedRcvrs(selectedList) {
            if (!selectedList || !selectedList.length) return;
            selectedList.forEach(function(r) {
                if (!MSG_RCVR_LIST.some(function(x) { return x.userId === r.userId; })) {
                    MSG_RCVR_LIST.push(r);
                }
            });
            fn_msgRenderRcvr();
            if (rcvrDlg) rcvrDlg.close();
        }

        function fn_msgRenderRcvr() {
            if (!MSG_BODY) return;
            MSG_BODY.find('.msgRcvrCnt').text(MSG_RCVR_LIST.length);
            const $tbody = MSG_BODY.find('.msgRcvrTbody');
            if (!MSG_RCVR_LIST.length) {
                $tbody.html('<tr><td colspan="6" class="t_center">받는 사람을 추가하세요.</td></tr>');
                return;
            }
            let html = '';
            MSG_RCVR_LIST.forEach(function(r, i) {
                html += '<tr>'
                    + '<td class="t_center"><span class="custom-input onlychk"><input type="checkbox" class="msgRcvrChk" value="' + UiComm.escapeHtml(String(r.userId || '')) + '"><label></label></span></td>'
                    + '<td class="t_center">' + (i + 1) + '</td>'
                    + '<td class="t_center">' + UiComm.escapeHtml(String(r.usernm || '-')) + '</td>'
                    + '<td class="t_center">' + UiComm.escapeHtml(String(r.stdntNo || '-')) + '</td>'
                    + '<td class="t_center">' + UiComm.escapeHtml(String(r.mblPhn || '-')) + '</td>'
                    + '<td class="t_center">' + UiComm.escapeHtml(String(r.eml || '-')) + '</td>'
                    + '</tr>';
            });
            $tbody.html(html);
        }

        function fn_msgToggleAll(el) {
            if (!MSG_BODY) return;
            MSG_BODY.find('.msgRcvrChk').prop('checked', el.checked);
        }

        function fn_msgRemoveRcvr() {
            const ids = [];
            MSG_BODY.find('.msgRcvrChk:checked').each(function() { ids.push(String($(this).val())); });
            if (!ids.length) {
                UiComm.showMessage('삭제할 대상을 선택하세요.', 'warning');
                return;
            }
            MSG_RCVR_LIST = MSG_RCVR_LIST.filter(function(r) { return ids.indexOf(String(r.userId)) === -1; });
            fn_msgRenderRcvr();
        }

        function fn_msgSend() {
            const channels = [];
            MSG_BODY.find('.msgCh:checked').each(function() { channels.push($(this).val()); });
            if (!channels.length) {
                UiComm.showMessage('발송 채널을 선택하세요.', 'warning');
                return;
            }

            const ttl = $.trim(MSG_BODY.find('#msgTitle').val());
            const cts = $.trim(MSG_BODY.find('#msgContent').val());
            const sndngr = $.trim(MSG_BODY.find('#msgSndngr').val());
            const sndngrPhn = $.trim(MSG_BODY.find('#msgSndngrPhn').val());
            if (!ttl) { UiComm.showMessage('제목을 입력하세요.', 'warning'); return; }
            if (!cts) { UiComm.showMessage('내용을 입력하세요.', 'warning'); return; }
            if (!sndngr) { UiComm.showMessage('발신자를 입력하세요.', 'warning'); return; }
            if (!sndngrPhn) { UiComm.showMessage('발신자 번호를 입력하세요.', 'warning'); return; }
            if (!MSG_RCVR_LIST.length) { UiComm.showMessage('받는 사람을 추가하세요.', 'warning'); return; }

            UiComm.showMessage('선택한 채널로 발송하시겠습니까?', 'confirm').then(function(ok) {
                if (!ok) return;
                ajaxCall(CTX + '/user/userMgr/admSendUserMsg.do', {
                    encParams: EPARAM,
                    addParams: UiComm.makeEncParams({
                        channels: channels.join(','),
                        ttl: ttl,
                        cts: cts,
                        sndngr: sndngr,
                        sndngrPhn: sndngrPhn,
                        rcvrListJson: JSON.stringify(MSG_RCVR_LIST)
                    })
                }, function(res) {
                    if (res.encParams) EPARAM = res.encParams;
                    if (res.result > 0) {
                        UiComm.showMessage(res.message || '발송되었습니다.', 'success').then(function() { closeDialog(); });
                    } else {
                        UiComm.showMessage(res.message || '발송 중 오류가 발생하였습니다.', 'error');
                    }
                }, function() {
                    UiComm.showMessage('발송 중 오류가 발생하였습니다.', 'error');
                }, true);
            });
        }

        function fn_notReady() {
            UiComm.showMessage('준비 중인 기능입니다.', 'info');
        }
    </script>
</head>

<body class="admin">
<div id="wrap" class="main user-page">
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

                    <!-- 검색 -->
                    <div class="search-typeA">
                        <div class="item">
                            <span class="item_tit"><label for="searchOrgId">기관</label></span>
                            <div class="itemList">
                                <select id="searchOrgId" class="form-select" <c:if test="${allOrgYn ne 'Y'}">disabled="disabled"</c:if>>
                                    <c:if test="${allOrgYn eq 'Y'}">
                                        <option value="">기관 전체</option>
                                    </c:if>
                                    <c:forEach var="org" items="${orgList}">
                                        <option value="${org.orgId}" <c:if test="${org.orgId eq vo.orgId}">selected="selected"</c:if>><c:out value="${org.orgnm}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="searchAuthrtGrpcd">관리자 구분</label></span>
                            <div class="itemList">
                                <select id="searchAuthrtGrpcd" class="form-select">
                                    <option value="">전체</option>
                                    <c:forEach var="item" items="${authrtGrpList}">
                                        <option value="${item.authrtId}" <c:if test="${item.authrtId eq vo.authrtGrpcd}">selected="selected"</c:if>><c:out value="${item.authrtnm}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="searchUserTycd">사용자 구분</label></span>
                            <div class="itemList">
                                <select id="searchUserTycd" class="form-select">
                                    <option value="">전체</option>
                                    <option value="adm" <c:if test="${vo.userTycd eq 'adm'}">selected="selected"</c:if>>교직원</option>
                                    <c:forEach var="item" items="${userTyList}">
                                        <option value="${item.authrtId}" <c:if test="${item.authrtId eq vo.userTycd}">selected="selected"</c:if>><c:out value="${item.authrtnm}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="searchValue">검색어</label></span>
                            <div class="itemList">
                                <input class="form-control wide" type="text" id="searchValue" value="" placeholder="학번/사번/이름 검색">
                            </div>
                        </div>
                        <div class="button-area">
                            <button type="button" class="btn search" onclick="fn_search();">검색</button>
                        </div>
                    </div>

                    <!-- 목록 -->
                    <div class="board_top">
                        <h3 class="board-title">목록<span class="total_txt fs-16px fw-normal ml5">[ 총 건수 : <b id="totalCnt">0</b>건 ]</span></h3>
                        <div class="right-area">
                            <button type="button" class="btn basic" onclick="fn_msgModal();">메시지 보내기</button>
                            <button type="button" class="btn basic" onclick="fn_notReady();">엑셀 다운로드</button>
                            <button type="button" class="btn type8" onclick="fn_notReady();">학사연동 가져오기</button>
                            <button type="button" class="btn type2" onclick="fn_notReady();">엑셀로 등록</button>
                            <button type="button" id="btnRegist" class="btn type2" onclick="fn_regist();">등록</button>
                            <uiex:listScale func="changeListScale" value="${vo.recordCountPerPage}"/>
                        </div>
                    </div>

                    <div class="table-wrap">
                        <div id="userList"></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal1 사용자 정보 -->
        <div class="modal-overlay" id="modal1" style="display:none;">
            <div class="modal-content">
                <div class="modal-body">
                    <div class="user-wrap">
                        <div class="user-img">
                            <div class="user-photo">
                                <img id="infoPhoto" src="<c:url value='/webdoc/assets/img/common/default_prof.png'/>" alt="사진">
                            </div>
                        </div>

                        <div class="board_top">
                            <div class="right-area">
                                <button type="button" class="btn small basic" onclick="fn_contactHistModal();">연락처 변경이력</button>
                            </div>
                            <div class="table-wrap">
                                <table class="table-type5">
                                    <colgroup>
                                        <col class="width-25per"/>
                                        <col/>
                                    </colgroup>
                                    <tbody>
                                        <tr><th scope="row">기관</th><td data-th="기관" id="infoOrgnm">-</td></tr>
                                        <tr><th scope="row">이름</th><td data-th="이름" id="infoUsernm">-</td></tr>
                                        <tr><th scope="row">학번</th><td data-th="학번" class="fcRed" id="infoStdntNo">-</td></tr>
                                        <tr><th scope="row">아이디</th><td data-th="아이디" id="infoUserId">-</td></tr>
                                        <tr><th scope="row">휴대폰 번호</th><td data-th="휴대폰 번호" id="infoMobile">-</td></tr>
                                        <tr><th scope="row">사용 이메일</th><td data-th="사용 이메일" id="infoEmail">-</td></tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="modal_btns">
                        <button type="button" class="btn type2" onclick="closeDialog();">닫기</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- //Modal1 -->

        <!-- Modal2 연락처 변경이력 -->
        <div class="modal-overlay" id="modal2" style="display:none;">
            <div class="modal-content">
                <div class="modal-body">
                    <div class="table-wrap overflow-y">
                        <table class="table-type3">
                            <colgroup>
                                <col style="width:5%"><col><col><col><col><col><col><col><col style="width:15%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">번호</th>
                                    <th scope="col">기관</th>
                                    <th scope="col">년도</th>
                                    <th scope="col">학기</th>
                                    <th scope="col">학번/사번</th>
                                    <th scope="col">이름</th>
                                    <th scope="col">변경전 연락처</th>
                                    <th scope="col">변경후 연락처</th>
                                    <th scope="col">변경일시</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr><td colspan="9" class="t_center">연락처 변경이력 조회 기능은 준비 중입니다.</td></tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="btns">
                        <button type="button" class="btn type2" onclick="closeDialog();">닫기</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- //Modal2 -->

        <!-- Modal4 알림 바로 보내기 -->
        <div class="modal-overlay" id="modal4" style="display:none;">
            <div class="modal-content">
                <div class="modal-body">
                    <div class="checkbox_type mb20">
                        <span class="custom-input"><input type="radio" name="msgCh" class="msgCh" value="PUSH" id="msgChPush" checked><label for="msgChPush">PUSH</label></span>
                        <span class="custom-input"><input type="radio" name="msgCh" class="msgCh" value="SHRTNT" id="msgChShrtnt"><label for="msgChShrtnt">쪽지</label></span>
                        <span class="custom-input"><input type="radio" name="msgCh" class="msgCh" value="ALIMTALK" id="msgChAlimtalk"><label for="msgChAlimtalk">알림톡</label></span>
                        <span class="custom-input"><input type="radio" name="msgCh" class="msgCh" value="SMS" id="msgChSms"><label for="msgChSms">문자</label></span>
                    </div>

                    <div class="table-wrap">
                        <table class="table-type5">
                            <colgroup><col style="width:15%"><col></colgroup>
                            <tbody>
                                <tr>
                                    <th scope="col" class="req"><label for="msgTitle">제목</label></th>
                                    <td data-th="제목"><input class="form-control width-100per" type="text" id="msgTitle" maxlength="100" placeholder="제목을 입력하세요"></td>
                                </tr>
                                <tr>
                                    <th scope="col" class="req"><label for="msgContent">내용</label></th>
                                    <td data-th="내용">
                                        <textarea class="form-control" id="msgContent" style="width:100%;height:120px" maxlength="2000" oninput="fn_msgByteCount();"></textarea>
                                        <div class="t_right"><span id="msgByte">0</span> / 2000 byte</div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="col" class="req"><label for="msgSndngr">발신자</label></th>
                                    <td data-th="발신자">
                                        <div class="form-inline">
                                            <input class="form-control" type="text" id="msgSndngr" placeholder="발신자명">
                                            <span class="custom-input"><input type="checkbox" id="msgSndngrSelf" onclick="fn_msgToggleSelf(this);"><label for="msgSndngrSelf">본인 이름 선택</label></span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="col" class="req">발신자 번호</th>
                                    <td data-th="발신자 번호">
                                        <div class="form-inline">
                                            <input class="form-control" type="text" id="msgSndngrPhn" placeholder="발신자 번호">
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="board_top">
                        <h3 class="sub-title">받는 사람 [ 총건수 : <b class="msgRcvrCnt">0</b>건 ]</h3>
                        <div class="right-area">
                            <button type="button" class="btn type3" onclick="fn_msgAddRcvr();"><i class="xi-plus-min"></i> 추가</button>
                            <button type="button" class="btn type2" onclick="fn_msgRemoveRcvr();">- 삭제</button>
                        </div>
                    </div>
                    <div class="table-wrap">
                        <table class="table-type3">
                            <colgroup><col style="width:5%"><col style="width:8%"><col><col><col><col></colgroup>
                            <thead>
                                <tr>
                                    <th scope="col"><span class="custom-input onlychk"><input type="checkbox" onclick="fn_msgToggleAll(this);"><label></label></span></th>
                                    <th scope="col">No</th>
                                    <th scope="col">수신자</th>
                                    <th scope="col">개인번호</th>
                                    <th scope="col">휴대폰 번호</th>
                                    <th scope="col">이메일</th>
                                </tr>
                            </thead>
                            <tbody class="msgRcvrTbody">
                                <tr><td colspan="6" class="t_center">받는 사람을 추가하세요.</td></tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="btns">
                        <button type="button" class="btn type1" onclick="fn_msgSend();">발송하기</button>
                        <button type="button" class="btn type2" onclick="closeDialog();">닫기</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- //Modal4 -->

        <!-- 대리로그인 새창 전송용 -->
        <form id="userMoveForm" name="userMoveForm" method="post" target="userSupportWin">
            <input type="hidden" name="userId" value=""/>
            <input type="hidden" name="goUrl" value=""/>
        </form>

    </main>
</div>

</body>
</html>
