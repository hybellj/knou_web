<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table,fileuploader"/>
    </jsp:include>
    <script type="text/javascript">
        let EPARAM = '<c:out value="${encParams}" />';
        const LIST_EPARAM = '<c:out value="${encParams}" />';
        const CTX = '<%=request.getContextPath()%>';
        const EDIT_MODE = '<c:out value="${editMode}" />' === 'true';
        const ALL_ORG_YN = '<c:out value="${allOrgYn}" />';
        const ORG_USER_ID = '<c:out value="${detail.userId}" />';
        let ID_CHECKED = false;
        let STDNT_CHECKED = EDIT_MODE;

        $(function() {
            $('#formOrgId').trigger('chosen:updated');
            $('#formUserId').on('input', function() {
                ID_CHECKED = false;
            });
            $('#formStdntNo').on('input', function() {
                STDNT_CHECKED = false;
            });
            fn_initMobile();
            fn_initEmail();
            fn_syncUserTycd();
        });

        function fn_syncUserTycd() {
            const authrtId = $('#formAuthrtId').val();
            const userTycd = $('#formUserTycd').val();
            if (authrtId) {
                if (!userTycd) {
                    $('#formUserTycd').val('adm').trigger('chosen:updated');
                }
            } else if (userTycd === 'adm') {
                $('#formUserTycd').val('').trigger('chosen:updated');
            }
        }

        function fn_initMobile() {
            const mobile = '<c:out value="${detail.mobileNo}" />';
            if (!mobile) {
                return;
            }
            let prefix = '';
            let mid = '';
            let last = '';
            const parts = mobile.split('-');
            if (parts.length === 3) {
                prefix = parts[0];
                mid = parts[1];
                last = parts[2];
            } else {
                const digits = mobile.replace(/[^0-9]/g, '');
                if (digits.length >= 10) {
                    prefix = digits.substring(0, 3);
                    mid = digits.substring(3, digits.length - 4);
                    last = digits.substring(digits.length - 4);
                }
            }
            if (prefix && $('#formMobilePrefix option[value="' + prefix + '"]').length === 0) {
                $('#formMobilePrefix').append('<option value="' + UiComm.escapeHtml(prefix) + '">' + UiComm.escapeHtml(prefix) + '</option>');
            }
            $('#formMobilePrefix').val(prefix || '010');
            $('#formMobile2').val(mid);
            $('#formMobile3').val(last);
        }

        function fn_initEmail() {
            const email = '<c:out value="${detail.email}" />';
            if (!email) {
                return;
            }
            const at = email.indexOf('@');
            if (at > -1) {
                $('#formEmail').val(email.substring(0, at));
                $('#formEmailDomain').val(email.substring(at + 1));
            } else {
                $('#formEmail').val(email);
            }
        }

        function fn_selectEmailDomain() {
            const domain = $('#formEmailDomainSel').val();
            if (domain) {
                $('#formEmailDomain').val(domain);
            }
        }

        function fn_directEmailDomain() {
            $('#formEmailDomainSel').val('');
            $('#formEmailDomain').val('').focus();
        }

        function fn_validateForm() {
            if (!$('#formOrgId').val()) {
                UiComm.showMessage('기관을 선택해 주세요.', 'warning');
                return false;
            }
            if (!$.trim($('#formUserId').val())) {
                UiComm.showMessage('아이디를 입력해 주세요.', 'warning');
                return false;
            }
            if (!EDIT_MODE && !ID_CHECKED) {
                UiComm.showMessage('아이디 중복확인을 해주세요.', 'warning');
                return false;
            }
            if (!EDIT_MODE && $.trim($('#formStdntNo').val()) && !STDNT_CHECKED) {
                UiComm.showMessage('학번/사번 중복확인을 해주세요.', 'warning');
                return false;
            }
            if (!$.trim($('#formUsernm').val())) {
                UiComm.showMessage('이름을 입력해 주세요.', 'warning');
                return false;
            }
            if (!$('#formUserTycd').val()) {
                UiComm.showMessage('사용자 구분을 선택해 주세요.', 'warning');
                return false;
            }
            if (!fn_validatePassword()) {
                return false;
            }
            return true;
        }

        function fn_validatePassword() {
            const pw = $('#formPw').val();
            const pw2 = $('#formPw2').val();

            if (!EDIT_MODE && !pw) {
                UiComm.showMessage('비밀번호를 입력해 주세요.', 'warning');
                return false;
            }
            if (!pw) {
                return true;
            }
            if (pw.length < 8 || pw.length > 16) {
                UiComm.showMessage('비밀번호는 8자 이상 16자 이하로 입력해 주세요.', 'warning');
                return false;
            }
            let kinds = 0;
            if (/[a-zA-Z]/.test(pw)) kinds++;
            if (/[0-9]/.test(pw)) kinds++;
            if (/[^a-zA-Z0-9]/.test(pw)) kinds++;
            if (kinds < 2) {
                UiComm.showMessage('비밀번호는 영문/숫자/특수문자 중 2가지 이상을 조합해 주세요.', 'warning');
                return false;
            }
            if (pw !== pw2) {
                UiComm.showMessage('비밀번호가 일치하지 않습니다.', 'warning');
                return false;
            }
            return true;
        }

        function fn_checkPw() {
            const pw = $('#formPw').val();

            // 8자 이상 16자 이하
            $('#pwMsgLen').css('display', (pw.length > 0 && (pw.length < 8 || pw.length > 16)) ? 'block' : 'none');

            // 영문/숫자/특수문자 중 2가지 이상 조합
            let kinds = 0;
            if (/[a-zA-Z]/.test(pw)) kinds++;
            if (/[0-9]/.test(pw)) kinds++;
            if (/[^a-zA-Z0-9]/.test(pw)) kinds++;
            $('#pwMsgCombo').css('display', (pw.length > 0 && kinds < 2) ? 'block' : 'none');

            // 비밀번호 변경 시 확인 입력과의 일치 여부도 갱신
            fn_checkPwMatch();
        }

        function fn_checkPwMatch() {
            const pw = $('#formPw').val();
            const pw2 = $('#formPw2').val();
            const $msg = $('#pwMsgMatch');

            if (!pw2) {
                $msg.css('display', 'none');
                return;
            }
            if (pw === pw2) {
                $msg.text('* 비밀번호가 일치합니다.').removeClass('fcRed').addClass('fcBlue').css('display', 'block');
            } else {
                $msg.text('* 비밀번호가 일치하지 않습니다.').removeClass('fcBlue').addClass('fcRed').css('display', 'block');
            }
        }

        function fn_checkId() {
            const userId = $.trim($('#formUserId').val());
            if (!userId) {
                UiComm.showMessage('아이디를 입력해 주세요.', 'warning');
                return;
            }

            ajaxCall(CTX + '/user/userMgr/admCountUserMgrId.do', {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams({userId: userId})
            }, function(res) {
                if (res.encParams) {
                    EPARAM = res.encParams;
                }
                if (res.result > 0) {
                    ID_CHECKED = true;
                    UiComm.showMessage(res.message || '사용 가능한 아이디입니다.', 'success');
                } else {
                    ID_CHECKED = false;
                    UiComm.showMessage(res.message || '이미 사용 중인 아이디입니다.', 'warning');
                }
            }, function() {
                UiComm.showMessage('처리 중 오류가 발생하였습니다.', 'error');
            }, true);
        }

        function fn_checkStdntNo() {
            const stdntNo = $.trim($('#formStdntNo').val());
            if (!stdntNo) {
                UiComm.showMessage('학번/사번을 입력해 주세요.', 'warning');
                return;
            }

            ajaxCall(CTX + '/user/userMgr/admCountUserMgrStdntNo.do', {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams({stdntNo: stdntNo, userId: EDIT_MODE ? ORG_USER_ID : ''})
            }, function(res) {
                if (res.encParams) {
                    EPARAM = res.encParams;
                }
                if (res.result > 0) {
                    STDNT_CHECKED = true;
                    UiComm.showMessage(res.message || '사용 가능한 학번/사번입니다.', 'success');
                } else {
                    STDNT_CHECKED = false;
                    UiComm.showMessage(res.message || '이미 사용 중인 학번/사번입니다.', 'warning');
                }
            }, function() {
                UiComm.showMessage('처리 중 오류가 발생하였습니다.', 'error');
            }, true);
        }

        function fn_makeMobile() {
            const prefix = $('#formMobilePrefix').val();
            const mid = $.trim($('#formMobile2').val());
            const last = $.trim($('#formMobile3').val());
            if (!mid && !last) {
                return '';
            }
            return prefix + '-' + mid + '-' + last;
        }

        function fn_makeEmail() {
            const id = $.trim($('#formEmail').val());
            const domain = $.trim($('#formEmailDomain').val());
            if (!id) {
                return '';
            }
            return domain ? (id + '@' + domain) : id;
        }

        function fn_save() {
            if (!fn_validateForm()) {
                return;
            }
            fn_startUploadOrSave();
        }

        function fn_startUploadOrSave() {
            const dx = dx5.get('photoAtfl');
            if (dx && dx.availUpload()) {
                dx.startUpload();
            } else {
                fn_doSave();
            }
        }

        function fn_finishUpload() {
            const dx = dx5.get('photoAtfl');
            const data = {
                uploadFiles: dx.getUploadFiles(),
                uploadPath: dx.getUploadPath()
            };
            ajaxCall(CTX + '/common/uploadFileCheck.do', {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams(data)
            }, function(res) {
                if (res.encParams) {
                    EPARAM = res.encParams;
                }
                if (res.result > 0) {
                    $('#uploadFiles').val(dx.getUploadFiles());
                    fn_doSave();
                } else {
                    UiComm.showMessage(res.message || '처리 중 오류가 발생하였습니다.', 'error');
                }
            }, function() {
                UiComm.showMessage('처리 중 오류가 발생하였습니다.', 'error');
            }, true);
        }

        function fn_doSave() {
            const url = EDIT_MODE
                ? CTX + '/user/userMgr/admModifyUserMgr.do'
                : CTX + '/user/userMgr/admRegistUserMgr.do';

            const userTyVal = $('#formUserTycd').val();
            const params = {
                orgId: $('#formOrgId').val(),
                userId: $.trim($('#formUserId').val()),
                stdntNo: $.trim($('#formStdntNo').val()),
                usernm: $.trim($('#formUsernm').val()),
                userTycd: $('#formUserTycd option:selected').data('grpcd') || '',
                userTyAuthrtId: userTyVal === 'adm' ? '' : userTyVal,
                authrtId: $('#formAuthrtId').val(),
                acRcdTycd: $('#formAcRcdTycd').val(),
                mobileNo: fn_makeMobile(),
                email: fn_makeEmail(),
                userIdEncpswd: EDIT_MODE ? '' : $('#formPw').val(),
                dsblTycd: $('#formDsblTycd').val(),
                dsblGrdcd: $('#formDsblGrdcd').val(),
                snryn: $('input[name=formSnryn]:checked').val() || 'N',
                photoFileId: $('#formPhotoFileId').val(),
                uploadFiles: $('#uploadFiles').val(),
                uploadPath: $('#uploadPath').val()
            };

            ajaxCall(url, {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams(params)
            }, function(res) {
                if (res.encParams) {
                    EPARAM = res.encParams;
                }
                if (res.result > 0) {
                    UiComm.showMessage(res.message || '저장되었습니다.', 'success').then(function() {
                        fn_goList();
                    });
                } else {
                    UiComm.showMessage(res.message || '처리 중 오류가 발생하였습니다.', 'error');
                }
            }, function() {
                UiComm.showMessage('처리 중 오류가 발생하였습니다.', 'error');
            }, true);
        }

        function fn_goList() {
            location.href = CTX + '/user/userMgr/admUserMgrList.do?encParams=' + encodeURIComponent(LIST_EPARAM);
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

                    <div class="board_top">
                        <h3 class="board-title"><c:choose><c:when test="${editMode}">수정</c:when><c:otherwise>등록</c:otherwise></c:choose></h3>
                    </div>

                    <div class="table-wrap">
                        <table class="table-type5">
                            <colgroup>
                                <col style="width:15%">
                                <col>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="col">관리자 구분</th>
                                    <td data-th="관리자 구분">
                                        <div class="form-inline">
                                            <select class="form-select" id="formAuthrtId" onchange="fn_syncUserTycd();">
                                                <option value="">선택</option>
                                                <c:forEach var="item" items="${authrtList}">
                                                    <c:set var="selYn" value="N"/>
                                                    <c:forEach var="ownId" items="${userAuthrtIds}">
                                                        <c:if test="${ownId eq item.authrtId}"><c:set var="selYn" value="Y"/></c:if>
                                                    </c:forEach>
                                                    <option value="${item.authrtId}" <c:if test="${selYn eq 'Y'}">selected="selected"</c:if>><c:out value="${item.authrtnm}"/></option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="col" class="req">사용자 구분</th>
                                    <td data-th="사용자 구분">
                                        <div class="form-inline">
                                            <select class="form-select" id="formUserTycd">
                                                <option value="">선택</option>
                                                <option value="adm" data-grpcd="ADM">교직원</option>
                                                <c:forEach var="item" items="${userTyAuthrtList}">
                                                    <c:set var="utSelYn" value="N"/>
                                                    <c:forEach var="ownId" items="${userAuthrtIds}">
                                                        <c:if test="${ownId eq item.authrtId}"><c:set var="utSelYn" value="Y"/></c:if>
                                                    </c:forEach>
                                                    <option value="${item.authrtId}" data-grpcd="${item.authrtGrpcd}" <c:if test="${utSelYn eq 'Y'}">selected="selected"</c:if>><c:out value="${item.authrtnm}"/></option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="col" class="req">기관</th>
                                    <td data-th="기관">
                                        <div class="form-inline">
                                            <select class="form-select type-num" id="formOrgId" <c:if test="${editMode or allOrgYn ne 'Y'}">disabled="disabled"</c:if>>
                                                <c:if test="${allOrgYn eq 'Y'}">
                                                    <option value="">선택</option>
                                                </c:if>
                                                <c:forEach var="org" items="${orgList}">
                                                    <option value="${org.orgId}" <c:if test="${org.orgId eq detail.orgId}">selected="selected"</c:if>><c:out value="${org.orgnm}"/></option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="col" class="req">아이디</th>
                                    <td data-th="아이디">
                                        <div class="form-inline">
                                            <c:choose>
                                                <c:when test="${editMode}">
                                                    <span class="form-value"><c:out value='${detail.userId}'/></span>
                                                    <input type="hidden" id="formUserId" value="<c:out value='${detail.userId}'/>"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <input class="form-control" type="text" id="formUserId" maxlength="30" placeholder="아이디를 입력하세요" value="<c:out value='${detail.userId}'/>"/>
                                                    <button type="button" class="btn gray1" onclick="fn_checkId();">중복확인</button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                                <c:if test="${not editMode}">
                                <tr>
                                    <th scope="col" class="req">비밀번호</th>
                                    <td data-th="비밀번호">
                                        <div class="form-row">
                                            <input class="form-control" type="password" id="formPw" placeholder="비밀번호 입력" autocomplete="new-password" oninput="fn_checkPw();"/>
                                        </div>
                                        <small class="note fcRed" id="pwMsgLen" style="display:none;">* 8자 이상 16자 이하로 입력 하세요.</small>
                                        <small class="note fcRed" id="pwMsgCombo" style="display:none;">* 영문(대소문자구분)/숫자/특수문자 중 2가지 이상 조합해 주세요.</small>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="col">비밀번호 확인</th>
                                    <td data-th="비밀번호 확인">
                                        <div class="form-row">
                                            <input class="form-control" type="password" id="formPw2" placeholder="비밀번호 재입력" autocomplete="new-password" oninput="fn_checkPwMatch();"/>
                                        </div>
                                        <small class="note" id="pwMsgMatch" style="display:none;"></small>
                                    </td>
                                </tr>
                                </c:if>
                                <tr>
                                    <th scope="col">학번/사번</th>
                                    <td data-th="학번/사번">
                                        <div class="form-inline">
                                            <c:choose>
                                                <c:when test="${editMode}">
                                                    <span class="form-value"><c:out value='${detail.stdntNo}'/></span>
                                                    <input type="hidden" id="formStdntNo" value="<c:out value='${detail.stdntNo}'/>"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <input class="form-control" type="text" id="formStdntNo" maxlength="30" placeholder="학번/사번을 입력하세요" value="<c:out value='${detail.stdntNo}'/>"/>
                                                    <button type="button" class="btn gray1" onclick="fn_checkStdntNo();">중복확인</button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="col" class="req">이름</th>
                                    <td data-th="이름">
                                        <div class="form-row">
                                            <input class="form-control width-50per" type="text" id="formUsernm" maxlength="200" placeholder="이름을 입력하세요" value="<c:out value='${detail.usernm}'/>"/>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="col">휴대폰번호</th>
                                    <td data-th="휴대폰번호">
                                        <div class="form-row">
                                            <div class="num_input">
                                                <select id="formMobilePrefix" class="compact">
                                                    <option value="010">010</option>
                                                    <option value="011">011</option>
                                                    <option value="016">016</option>
                                                    <option value="017">017</option>
                                                    <option value="018">018</option>
                                                    <option value="019">019</option>
                                                </select>
                                                <span class="txt-sort">-</span>
                                                <input type="text" id="formMobile2" maxlength="4" class="compact" inputmask="numeric"/>
                                                <span class="txt-sort">-</span>
                                                <input type="text" id="formMobile3" maxlength="4" class="compact" inputmask="numeric"/>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="col">개인 이메일</th>
                                    <td data-th="개인 이메일">
                                        <div class="form-inline">
                                            <input class="form-control mr5" type="text" id="formEmail">
                                            <span class="mr5">@</span>
                                            <input class="form-control mr5" type="text" id="formEmailDomain" title="이메일 주소 뒷자리" placeholder="">
                                            <select class="form-select mr5" id="formEmailDomainSel" onchange="fn_selectEmailDomain();">
                                                <option value="">선택</option>
                                                <option value="naver.com">naver.com</option>
                                                <option value="daum.net">daum.net</option>
                                                <option value="gmail.com">gmail.com</option>
                                                <option value="knou.ac.kr">knou.ac.kr</option>
                                            </select>
                                            <button type="button" class="btn gray1" onclick="fn_directEmailDomain();">직접입력</button>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="col">학적 상태</th>
                                    <td data-th="학적 상태">
                                        <div class="form-inline">
                                            <select class="form-select" id="formAcRcdTycd">
                                                <option value="">선택</option>
                                                <c:forEach var="item" items="${acRcdTyList}">
                                                    <option value="${item.cd}" <c:if test="${item.cd eq detail.acRcdTycd}">selected="selected"</c:if>><c:out value="${item.cdnm}"/></option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="col">장애 유형/등급</th>
                                    <td data-th="장애 유형/등급">
                                        <div class="form-inline">
                                            <select class="form-select" id="formDsblTycd">
                                                <option value="">장애 유형</option>
                                                <c:forEach var="item" items="${dsblTyList}">
                                                    <option value="${item.cd}" <c:if test="${item.cd eq detail.dsblTycd}">selected="selected"</c:if>><c:out value="${item.cdnm}"/></option>
                                                </c:forEach>
                                            </select>
                                            <select class="form-select" id="formDsblGrdcd">
                                                <option value="">장애 등급</option>
                                                <c:forEach var="item" items="${dsblGrdList}">
                                                    <option value="${item.cd}" <c:if test="${item.cd eq detail.dsblGrdcd}">selected="selected"</c:if>><c:out value="${item.cdnm}"/></option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="col">고령자 유무</th>
                                    <td data-th="고령자 유무">
                                        <div class="form-inline">
                                            <span class="custom-input">
                                                <input type="radio" name="formSnryn" id="formSnrynY" value="Y" <c:if test="${detail.snryn eq 'Y'}">checked="checked"</c:if>/>
                                                <label for="formSnrynY">Y</label>
                                            </span>
                                            <span class="custom-input ml5">
                                                <input type="radio" name="formSnryn" id="formSnrynN" value="N" <c:if test="${empty detail.snryn or detail.snryn eq 'N'}">checked="checked"</c:if>/>
                                                <label for="formSnrynN">N</label>
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="col">프로필 사진</th>
                                    <td data-th="프로필 사진">
                                        <!-- 업로드 -->
                                        <div id="upload">
                                            <uiex:dextuploader
                                                    id="photoAtfl"
                                                    path="${uploadPath}"
                                                    limitCount="1"
                                                    limitSize="10"
                                                    oneLimitSize="10"
                                                    listSize="1"
                                                    allowedTypes="jpg,jpeg,png,gif"
                                                    fileList="${photoFileList}"
                                                    finishFunc="fn_finishUpload()"
                                            />
                                            <small class="note">* 이미지 파일(jpg, jpeg, png, gif)만 업로드할 수 있습니다.</small>
                                        </div>
                                        <!-- //업로드 -->
                                        <input type="hidden" id="uploadFiles" value=""/>
                                        <input type="hidden" id="uploadPath" value="<c:out value='${uploadPath}'/>"/>
                                        <input type="hidden" id="formPhotoFileId" value="<c:out value='${detail.photoFileId}'/>"/>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="btns">
                        <button type="button" id="btnSave" class="btn type1" onclick="fn_save();">저장</button>
                        <button type="button" id="btnList" class="btn type2" onclick="fn_goList();">목록</button>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

</body>
</html>
