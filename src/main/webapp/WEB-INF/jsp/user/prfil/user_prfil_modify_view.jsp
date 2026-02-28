<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common_new/home_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/assets/css/dashboard.css"/>
<head>
    <title></title>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="module" value="file-uploader"/>
        <jsp:param name="style" value="dashboard"/>
    </jsp:include>

    <%--임시 파일업로드 스크립트--%>
    <script type="text/javascript" src="/webdoc/js/dx5/dextuploadx5-configuration.js"></script>
    <script type="text/javascript" src="/webdoc/js/dx5/dextuploadx5.js"></script>
    <script type="text/javascript" src="/webdoc/js/dx5-uploader.js?v=11"></script>

</head>
<body class="home colorA "><!-- 컬러선택시 클래스변경 -->
<div id="wrap" class="main">
    <!-- common header -->
    <%@ include file="/WEB-INF/jsp/common_new/home_header.jsp" %>
    <!-- //common header -->

    <!-- dashboard -->
    <main class="common">

        <!-- gnb -->
        <%@ include file="/WEB-INF/jsp/common_new/home_gnb_prof.jsp" %>
        <!-- //gnb -->

        <!-- content -->
        <div id="content" class="content-wrap common">
            <div class="dashboard_sub">

                <!-- page_tab -->
                <%@ include file="/WEB-INF/jsp/common_new/home_page_tab.jsp" %>
                <!-- //page_tab -->

                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title">프로필</h2>
                        <div class="navi_bar">
                            <ul>
                                <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                <li><span class="current">프로필</span></li>
                            </ul>
                        </div>

                    </div>

                    <form autocomplete="off" onsubmit="return false;" id="frmUserModify" method="POST">

                        <input type="hidden" id="indvEml" name="indvEml" value="${vo.indvEml}"/>
                        <input type="hidden" id="mblPhn" name="mblPhn" value="${vo.mblPhn}"/>
                        <input type="hidden" name="uploadFiles"/>
                        <input type="hidden" name="copyFiles"/>
                        <input type="hidden" name="uploadPath"/>
                        <div class="user-wrap">

                            <div class="user-img">
                                <div class="user-photo">
                                    <!--프로필 사진-->
                                    <img alt="<spring:message code='crs.title.letcuser'/><spring:message code='lesson.label.img'/>"
                                         style="max-width:100%;max-height:100%"
                                         src="${empty photoFileId ? '/webdoc/dm_assets/img/common/photo_user_sample.png' : photoFileId}"/>
                                </div>
                            </div>

                            <!--table-type5-->
                            <div class="table-wrap">
                                <table class="table-type5">
                                    <colgroup>
                                        <col class="width-15per"/>
                                        <col class=""/>
                                    </colgroup>
                                    <tbody>

                                    <tr>
                                        <th><label for="univ_label" class="req">기관</label></th>
                                        <td>
                                            <div class="form-inline">
                                                <select class="form-select" id="univ_label" name="univ_label">
                                                    <option value=""><spring:message
                                                            code="user.common.select"/></option>
                                                    <c:forEach var="item" items="${nowSmstrLectOrgList }">
                                                        <option value="${item.orgId }">${item.orgnm }</option>
                                                    </c:forEach>
                                                </select>
                                                <button type="button" class="btn gray1" id="btn_org_add">추가</button>
                                                <ul class="label_list" id="orgLabelList">
                                                    <c:forEach var="item" items="${userAuthrtList }">
                                                        <li class="addedLabel" data-org-id="${item.orgId}">
                                                            <label>${item.orgnm}</label>
                                                            <span class="labelRemove"><i
                                                                    class="xi-close-min"></i></span>
                                                        </li>
                                                    </c:forEach>
                                                </ul>

                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="usernm" class="req">이름</label></th>
                                        <td>
                                            <div class="form-row">
                                                <input class="form-control width-50per" type="text" name="usernm"
                                                       id="usernm" value="${vo.usernm}">
                                            </div>
                                        </td>
                                    </tr>
                                    <c:choose>
                                        <c:when test="${fn:contains(vo.authrtGrpcd,'PROF')}">
                                            <tr>
                                                <th><label for="userNcnm" class="req">사용자별칭</label></th>
                                                <td>
                                                    <div class="form-inline">
                                                        <input class="form-control width-50per" type="text"
                                                               name="userNcnm"
                                                               id="userNcnm" value="${vo.userNcnm}">
                                                        <small class="note2">! 이름 대신 노출됩니다. 수정 후 사용하세요.</small>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:when>
                                    </c:choose>

                                    <tr>
                                        <th><label for="성별" class="req">성별</label></th>
                                        <td>
                                            <div class="form-inline">
                                            <span class="custom-input">
                                                <input type="radio"
                                                       name="gndrTycd"
                                                       id="gndrTyM" value="M"
                                                ${vo.gndrTycd eq 'M' ? 'checked' : ''}>
                                                <label for="gndrTyM">남자</label>
                                            </span>
                                                <span class="custom-input ml5">
                                                <input type="radio"
                                                       name="gndrTycd"
                                                       id="gndrTyF" value="F"
                                                ${vo.gndrTycd eq 'F' ? 'checked' : ''}>
                                                <label for="gndrTyF">여자</label>
                                            </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <%--학번 또는 교번으로 변경하기--%>
                                        <th><label for="name_label">
                                            <c:choose>
                                                <c:when test="${fn:contains(vo.authrtGrpcd,'PROF')}">
                                                    교번
                                                </c:when>
                                                <c:otherwise>
                                                    <spring:message
                                                            code="user.title.userinfo.manage.userid"/><!-- 학번 -->
                                                </c:otherwise>
                                            </c:choose>

                                        </label>
                                        </th>
                                        <td>
                                            <div class="form-inline">
                                                ${vo.stdntNo}
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="id_label">아이디</label></th>
                                        <td>
                                            <div class="form-inline">
                                                ${vo.userRprsId}
                                                <small class="note2">! 수정불가</small>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="pw_label2" class="req">비밀번호</label></th>
                                        <td>
                                            <div class="form-inline">
                                                <input type="password" id="curPswd" name="curPswd"
                                                       placeholder="<spring:message code='user.message.search.input.userpass' />">
                                                <small class="note2">! 개인정보변경을 위한 비밀번호 체크</small>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="mobileLabel" class="req">휴대폰 번호</label></th>
                                        <td>
                                            <div class="form-row">
                                                <!-- 번호 -->
                                                <div class="num_input">
                                                    <select name="" id="mobileLabel" class="compact">
                                                        <option value="010">010</option>
                                                        <option value="011">011</option>
                                                        <option value="016">016</option>
                                                        <option value="017">017</option>
                                                        <option value="018">018</option>
                                                        <option value="019">019</option>
                                                    </select>
                                                    <span class="txt-sort">-</span>
                                                    <input type="text" maxlength="4"
                                                           onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"
                                                           class="compact" value="${fn:split(vo.mblPhn,'-')[1] }"/>
                                                    <span class="txt-sort">-</span>
                                                    <input type="text" maxlength="4"
                                                           onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"
                                                           class="compact" value="${fn:split(vo.mblPhn,'-')[2] }"/>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="사용 이메일" class="req">사용 이메일</label></th>
                                        <td>
                                            <div class="form-inline">
                                                    <span class="custom-input">
                                                        <input type="radio" name="useEmlGbncd" id="useEmlGbnL"
                                                               value="LNKG"
                                                        ${empty vo.useEmlGbncd or vo.useEmlGbncd eq 'LNKG' ? 'checked' : ''}>
                                                        <label for="useEmlGbnL">연계 이메일</label>
                                                    </span>
                                                <span class="custom-input ml5">
                                                        <input type="radio" name="useEmlGbncd" id="useEmlGbnI"
                                                               value="INDV"
                                                        ${vo.useEmlGbncd eq 'INDV' ? 'checked' : ''}>
                                                        <label for="useEmlGbnI">추가 이메일</label>
                                                    </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="inputEmailA">연계 이메일</label></th>
                                        <td>

                                            <div class="form-inline">
                                                <input class="form-control mr5" type="text"
                                                       value="${fn:split(vo.lnkgEml,'@')[0]}"
                                                       id="lnkgEml1" disabled>
                                                <span class="mr5">@</span>
                                                <input class="form-control mr5" type="text" id="lnkgEml2"
                                                       value="${fn:split(vo.lnkgEml,'@')[1]}" title="이메일 주소 뒷자리"
                                                       disabled>
                                            </div>
                                        </td>
                                    </tr>

                                    <tr>
                                        <th><label for="inputEmailB">개인 이메일</label></th>
                                        <td>
                                            <div class="form-inline">
                                                <input class="form-control mr5" type="text"
                                                       value="${fn:split(vo.indvEml,'@')[0]}"
                                                       id="indvEml1">
                                                <span class="mr5">@</span>
                                                <input class="form-control mr5" type="text" id="indvEml2"
                                                       value="${fn:split(vo.indvEml,'@')[1]}" title="이메일 주소 뒷자리"
                                                       placeholder="">
                                                <select class="form-select" id="selectEmail">
                                                    <option value="">선택</option>
                                                    <option value="naver.com">naver.com</option>
                                                    <option value="daum.net">daum.net</option>
                                                </select>
                                                <button type="button" class="btn gray1" id="btnEmailDirect">직접입력
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="attchFile"><spring:message
                                                code="user.title.userinfo.profile.image"/></label><!--프로필사진--></th>
                                        <td>

                                            <!--업로드-->
                                            <div id="upload">

                                                <!--파일업로드-->
                                                <div id="drop">
                                                    파일을 여기에 끌어다 놓거나, 파일 선택 버튼을 클릭하여 업로드하세요.
                                                    <a id="buttonLink" href="javascript:uploderclick('atchuploader');"
                                                       class="btn type3">파일 선택</a>
                                                    <input type="file" name="atchuploader" id="atchuploader" multiple=""
                                                           style="display:none">

                                                    <div id="atchprogress" class="progress" style="display: none;">
                                                        <div class="progress-inner"></div>
                                                    </div>
                                                </div>
                                                <!--//파일업로드-->

                                                <!--파일 목록-->
                                                <ul id="atchfiles">
                                                    <li id="attachIdx_1">
                                                        <p>홍길동 프로필 사진.jpg<small>20.86 KB</small></p><span
                                                            aria-label="삭제"
                                                            href="#_none"></span>
                                                    </li>
                                                </ul>
                                                <!--//파일 목록-->

                                            </div>
                                            <!--//업로드-->

                                            <small class="note2 flex margin-top-2">! 프로필 사진 첨부시 기존 프로필 사진은 업데이트
                                                됩니다. </small>


                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="attchFile">테스트<spring:message
                                                code="user.title.userinfo.profile.image"/></label><!--프로필사진--></th>
                                        <td>
                                            <uiex:dextuploader
                                                    id="fileUploader"
                                                    path="/user/${vo.userId }"
                                                    limitCount="1"
                                                    limitSize="3"
                                                    oneLimitSize="3"
                                                    listSize="1"
                                                    finishFunc="finishUpload()"
                                                    useFileBox="false"
                                                    allowedTypes="jpg,jpeg,png,gif"
                                                    style="single"
                                            />


                                            <small class="note2 flex margin-top-2">! 프로필 사진 첨부시 기존 프로필 사진은 업데이트
                                                됩니다. </small>

                                            <c:if test="${not empty vo.photoFileId}">
                                                <div class="checkbox_type margin-top-4">
                                                    <span class="custom-input">
                                                        <input type="checkbox"
                                                               id="photoFileDelyn" name="photoFileDelyn">
                                                        <label for="photoFileDelyn">현 프로필 사진 삭제 ( 삭제시 기본 이미지로 교체됩니다. )</label>
                                                    </span>
                                                </div>
                                            </c:if>

                                        </td>
                                    </tr>
                                    </tbody>

                                </table>

                            </div>
                            <!--//table-type5-->
                        </div>
                        <div id="orgHiddenArea"></div>
                    </form>

                    <div class="btns">
                        <button type="button" class="btn type1">취소</button>
                        <button type="button" class="btn type2" onclick="save()">저장</button>
                    </div>

                </div>

            </div>
        </div>
        <!-- //content -->


        <!-- common footer -->
        <%@ include file="/WEB-INF/jsp/common_new/home_footer.jsp" %>
        <!-- //common footer -->

    </main>
    <!-- //dashboard-->

</div>

<script type="text/javascript">
    $(function () {

        // 기관 삭제
        $('#orgLabelList').on('click', '.labelRemove', function () {
            $(this).closest('li').remove();
        });

        // 기관 추가
        $('#btn_org_add').on('click', function () {

            var orgId = $('#univ_label').val();
            if (!orgId) return;

            var orgnm = $('#univ_label option:selected').text();

            // 중복 방지
            if ($('#orgLabelList li.addedLabel[data-org-id="' + orgId + '"]').length > 0) {
                return;
            }

            var html = '';
            html += '<li class="addedLabel" data-org-id="' + orgId + '">';
            html += '    <label>' + orgnm + '</label>';
            html += '    <span class="labelRemove"><i class="xi-close-min"></i></span>';
            html += '</li>';

            $('#orgLabelList').append(html);
        });

        // 이메일 도메인 select 선택 시 indvEml2 자동 세팅
        $('#selectEmail').on('change', function () {
            var domain = $(this).val();
            if (domain) {
                $('#indvEml2').val(domain).prop('readonly', true);
            }
        });

        // 이메일 도메인 직접입력 버튼
        $('#btnEmailDirect').on('click', function () {
            $('#selectEmail').val('');
            $('#indvEml2').val('').prop('readonly', false).focus();
        });


    });

    // 파일 업로드 완료
    function finishUpload() {
        var fileUploader = dx5.get("fileUploader");
        var url = "/file/fileHome/saveFileInfo.do";
        var data = {
            "uploadFiles": fileUploader.getUploadFiles(),
            "copyFiles": fileUploader.getCopyFiles(),
            "uploadPath": fileUploader.getUploadPath()
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                $("#frmUserModify input[name=uploadFiles]").val(fileUploader.getUploadFiles());
                $("#frmUserModify input[name=copyFiles]").val(fileUploader.getCopyFiles());
                $("#frmUserModify input[name=uploadPath]").val(fileUploader.getUploadPath());

                saveUserProfileAjax();
            } else {
                alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
        }, true);
    }


    function saveUserProfileAjax() {

        var url = "/user/userHome/userPrfilModifyAjax.do";
        var data = $('#frmUserModify').serialize(); // orgIdList도 hidden으로 들어가 있어야 함

        ajaxCall(url, data, function (res) {
            if (res.result > 0) {
                alert('<spring:message code="success.common.save" />')
            } else {
                alert(res.message || '<spring:message code="fail.common.msg" />');
            }
            location.href = "/user/userHome/userPrfilView.do";
        }, function () {
            alert('<spring:message code="fail.common.msg" />');
        }, true);
    }


    /**
     * 전송 데이터 셋팅
     */
    function setData() {
        // 등록할 기관 목록 추가
        $('#orgHiddenArea').empty();
        $('#orgLabelList li.addedLabel').each(function () {
            $('<input>', {
                type: 'hidden',
                name: 'orgIdList',
                value: $(this).data('org-id')
            }).appendTo('#orgHiddenArea');
        });

        // 휴대폰
        buildMobilePhone();
        // 개인이메일 조합
        buildIndvEmail();

    }

    /**
     * 개인이메일 조합
     * @returns {string} 개인이메일주소
     */
    function buildIndvEmail() {
        var a = $.trim($('#indvEml1').val());
        var b = $.trim($('#indvEml2').val());

        if (!a && !b) {
            $('#indvEml').val('');
            return '';
        }

        var email = a + '@' + b;
        $('#indvEml').val(email);
        return email;
    }

    /**
     * 휴대폰 번호 조합 (010-1234-5678)
     * @returns {string} 휴대폰번호 조합 결과
     */
    function buildMobilePhone() {
        var p1 = $('#mobileLabel').val();
        var p2 = $.trim($('#mobileLabel').nextAll('input').eq(0).val());
        var p3 = $.trim($('#mobileLabel').nextAll('input').eq(1).val());

        if (!p1 || !p2 || !p3) {
            $('#mblPhn').val('');
            return '';
        }

        var phone = p1 + '-' + p2 + '-' + p3;
        $('#mblPhn').val(phone);
        return phone;
    }

    /**
     * 비밀번호 일치 확인
     * @param successFn 비밀번호 일치 시 function
     */
    function checkPswdMtch(successFn) {
        let url = '/user/userHome/userPrfilPswdChkAjax.do';
        let data = {
            "userIdEncpswd": $('#curPswd').val()
        }
        ajaxCall(url, data, function (res) {
            if (res.result !== 1) {
                alert(res.message || '<spring:message code="fail.common.msg" />');
                return;
            }

            if (res.returnVO && res.returnVO.pswdMtchyn === 'Y') {
                successFn();
            } else {
                alert("<spring:message code='user.message.userjoin.validate.password.check' />");/* 비밀번호 확인이 일치하지 않습니다. */
            }
        }, function (xhr, status, error) {
            alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
        }, true);

    }

    /**
     * 이메일 유효성 검사
     * @param email 이메일
     * @returns {boolean} true/false
     */
    function isValidEmail(email) {
        var regEmail = /^([0-9a-zA-Z_\.-]+)@([0-9a-zA-Z_-]+)(\.[0-9a-zA-Z_-]+){1,2}$/;
        return regEmail.test(email);
    }


    /**
     * 빈값 체크
     * @returns {boolean}
     */
    function validateForm() {
        // 기관 1개 이상 선택(요구사항이면)
        if ($('#orgLabelList li.addedLabel').length === 0) {
            alert('기관을 1개 이상 추가하세요.');
            return false;
        }

        if (!$.trim($('#usernm').val())) {
            alert('이름을 입력하세요.');
            $('#usernm').focus();
            return false;
        }
        if (!$.trim($('#userNcnm').val())) {
            alert('사용자별칭을 입력하세요.');
            $('#userNcnm').focus();
            return false;
        }

        if (!$('input[name=gndrTycd]:checked').val()) {
            alert('성별을 선택하세요.');
            return false;
        }

        if (!$.trim($('#curPswd').val())) {
            alert('비밀번호를 입력하세요.');
            $('#curPswd').focus();
            return false;
        }

        if (!$('#mblPhn').val()) {
            alert('휴대폰 번호를 입력하세요.');
            return false;
        }

        // 사용 이메일 선택 여부
        var useEmlGbncd = $('input[name=useEmlGbncd]:checked').val();

        if (!useEmlGbncd) {
            alert('사용 이메일을 선택하세요.');
            return false;
        }

        // 사용 이메일 구분에 따라 개인 이메일 검증(INDV일 때만 필수/검증)
        if (useEmlGbncd === 'INDV') {
            var email = $('#indvEml').val(); // setData에서 조립됨

            if (!email) {
                alert('개인 이메일을 입력하세요.');
                $('#indvEml1').focus();
                return false;
            }

            if (!isValidEmail(email)) {
                alert('개인 이메일 형식이 올바르지 않습니다.');
                $('#indvEml1').focus();
                return false;
            }
        }

        return true;
    }

    function save() {
        // 데이터 조립
        setData();

        // 유효성 체크
        if (!validateForm()) {
            return;
        }

        // 패스워드 체크 -> 파일업로드 -> 저장
        checkPswdMtch(function () {
            var fileUploader = dx5.get("fileUploader");

            if (fileUploader.getFileCount() > 0) {
                fileUploader.startUpload(); // finishUpload로 이어짐
            } else {
                saveUserProfileAjax();  // 파일 없이 저장
            }
        });
    }


</script>
</body>
</html>

