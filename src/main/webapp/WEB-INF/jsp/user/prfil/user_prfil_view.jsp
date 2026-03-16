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
        <jsp:param name="module" value=""/>
        <jsp:param name="style" value="dashboard"/>
    </jsp:include>

</head>
<body class="home colorA ${bodyClass}"><!-- 컬러선택시 클래스변경 -->
<div id="wrap" class="main">
    <!-- common header -->
    <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp"/>
    <!-- //common header -->

    <!-- dashboard -->
    <main class="common">

        <!-- gnb -->
        <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp"/>
        <!-- //gnb -->

        <!-- content -->
        <div id="content" class="content-wrap common">
            <div class="dashboard_sub">
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
                                    <th><label for="univ_label">기관</label></th>
                                    <td>
                                        <div class="form-inline">
                                            <ul class="label_list">
                                                <c:forEach var="item" items="${userAuthrtList }">
                                                    <li class="addedLabel">
                                                        <label>${item.orgnm}</label>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>

                                <tr>
                                    <th><label for="name_label"><spring:message
                                            code="user.title.userinfo.manage.usernm"/></label></th><!-- 이름 -->
                                    <td>
                                        <div class="form-row">
                                            ${vo.usernm}
                                            <c:choose>
                                                <c:when test="${fn:contains(vo.authrtGrpcd,'PROF')}">(사용자별칭: ${vo.userNcnm})</c:when>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th><label for="name_label">교번</label></th>
                                    <td>
                                        <div class="form-row">
                                            ${vo.stdntNo}
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th><label for="id_label">아이디</label></th>
                                    <td>
                                        <div class="form-inline">
                                            ${vo.userRprsId}
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th><label for="mobileLabel">휴대폰 번호</label></th>
                                    <td>
                                        ${vo.mblPhn}
                                    </td>
                                </tr>
                                <tr>
                                    <th><label for="사용 이메일">사용 <spring:message
                                            code="user.title.userinfo.email"/></label></th>
                                    <td>
                                        <c:choose>
                                            <c:when test="${vo.useEmlGbncd eq 'LNKG' and not empty vo.lnkgEml}">
                                                ${vo.lnkgEml} (연계이메일)
                                            </c:when>
                                            <c:when test="${vo.useEmlGbncd eq 'INDV' and not empty vo.indvEml}">
                                                ${vo.indvEml} (개인이메일)
                                            </c:when>
                                        </c:choose>
                                        <div class="form-row">
                                            <small class="note2">! 다른 이메일을 사용하시려면 “등록/수정”에서 개인 이메일 등록하고 사용설정 하시면
                                                됩니다.</small>
                                        </div>
                                    </td>
                                </tr>

                                </tbody>

                            </table>
                        </div>
                        <!--//table-type5-->
                    </div>

                    <div class="board_top margin-top-4">
                        <div class="right-area">
                        <span class="custom-input">
                            <input type="checkbox" id="alimAgree">
                            <label for="alimAgree">알림 수신 유의사항 읽음</label>
                        </span>
                        </div>
                    </div>

                    <div class="table-wrap">
                        <div class="board_top">
                            <h3 class="board-title">알림수신 동의 설정</h3>
                        </div>
                        <table class="table-type5">
                            <colgroup>
                                <col class="width-15per"/>
                                <col class=""/>
                            </colgroup>
                            <tbody>

                            <tr>
                                <th><label for="pushRcv">PUSH</label></th>
                                <td>
                                    <div class="form-inline">
                                        <div class="form-row alim-setting">
                                            <input id="pushRcv" type="checkbox" class="switch onoff"
                                            ${vo.pushRcvyn eq 'Y' ? 'checked' : ''} disabled>
                                        </div>
                                        <span class="mb15">PUSH 수신동의 합니다.</span>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th><label for="shrtntAlimRcv">쪽지</label></th>
                                <td>
                                    <div class="form-inline">
                                        <div class="form-row alim-setting">
                                            <input id="shrtntAlimRcv" type="checkbox" class="switch onoff"
                                            ${vo.shrtntAlimRcvyn eq 'Y' ? 'checked' : ''} disabled>
                                        </div>
                                        <span class="mb15">쪽지 수신동의 합니다.</span>
                                    </div>
                                </td>
                            </tr>

                            <tr>
                                <th><label for="emlAlimRcv">이메일</label></th>
                                <td>
                                    <div class="form-inline">
                                        <div class="form-row alim-setting">
                                            <input id="emlAlimRcv" type="checkbox" class="switch onoff"
                                            ${vo.emlAlimRcvyn eq 'Y' ? 'checked' : ''} disabled>
                                        </div>
                                        <span class="mb15">이메일 수신동의 합니다.</span>
                                    </div>
                                </td>
                            </tr>

                            <tr>
                                <th><label for="alimTalkRcv">알림톡</label></th>
                                <td>
                                    <div class="form-inline">
                                        <div class="form-row alim-setting">
                                            <input id="alimTalkRcv" type="checkbox" class="switch onoff"
                                            ${vo.alimTalkRcvyn eq 'Y' ? 'checked' : ''} disabled>
                                            <span class="mb15">알림톡 수신동의 합니다.</span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th><label for="smsRcv">문자</label></th>
                                <td>
                                    <div class="form-inline">
                                        <div class="form-row alim-setting">
                                            <input id="smsRcv" type="checkbox" class="switch onoff"
                                            ${vo.smsRcvyn eq 'Y' ? 'checked' : ''} disabled>
                                        </div>
                                        <span class="mb15">문자 수신동의 합니다.</span>
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                        <small class="note2">! 공지 / 강의Q&A / 1:1상담에 대한 알림은 동의여부와 상관없이 발송됩니다.</small>

                    </div>

                    <div class="btns">
                        <button type="button" class="btn type1" id="btn_modify">수정</button>
                    </div>

                </div>

            </div>
        </div>
        <!-- //content -->


        <!-- common footer -->
        <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
        <!-- //common footer -->

    </main>
    <!-- //dashboard-->

</div>
<script type="text/javascript">

    var alimNoticeDialog = null;
    var alimAgreeOk = false;


    $(function () {
        setAlimToggleEnabled(false);

        $('#alimAgree').on('change', function () {

            if ($(this).is(':checked')) {
                $(this).prop('checked', false);
                alimAgreeOk = false;
                setAlimToggleEnabled(false);
                openAlimNoticeDialog();
            } else {
                alimAgreeOk = true;
                setAlimToggleEnabled(false);
            }
        });
    });


    function setAlimToggleEnabled(enabled) {
        $('.alim-setting input[type=checkbox]').each(function () {
            var id = this.id;
            $(this).prop('disabled', !enabled);

            $('#sw_' + id).toggleClass('disabled', !enabled);
            $('#sw_' + id).attr('aria-disabled', enabled ? 'false' : 'true');
        });
    }

    function openAlimNoticeDialog() {
        alimNoticeDialog = UiDialog("alim_notice", {
            title: "알림 수신 유의사항",
            width: 700,
            height: 600,
            url: "/user/userHome/alimNoticePopview.do",
            modal: true,
            resizable: true,
            autoresize: true
        });
    }

    // 모달에서 '확인' 눌렀을 때 호출됨
    function onAlimNoticeConfirm() {
        $('#alimAgree').prop('checked', true);
        setAlimToggleEnabled(true);
        alimAgreeOk = true;

        if (alimNoticeDialog) {
            alimNoticeDialog.close()
        }
    }

    // 모달에서 '취소' 눌렀을 때 호출됨
    function onAlimNoticeCancel() {
        $('#alimAgree').prop('checked', false);
        setAlimToggleEnabled(false);
        alimAgreeOk = false;
        if (alimNoticeDialog) {
            alimNoticeDialog.close()
        }
    }


    /**
     * 알림수신 체크 여부
     * @param $el 알림수신여부 대상
     * @returns {string} 'Y' / 'N'
     */
    function yn($el) {
        return $el.is(':checked') ? 'Y' : 'N';
    }

    /**
     * 알림 변경 할 데이터 리턴
     * @returns {{emlAlimRcvyn: string, pushRcvyn: string, shrtntAlimRcvyn: string, alimTalkRcvyn: string, smsRcvyn: string}}
     */
    function collectAlimData() {
        return {
            emlAlimRcvyn: yn($('#emlAlimRcv')),
            pushRcvyn: yn($('#pushRcv')),
            shrtntAlimRcvyn: yn($('#shrtntAlimRcv')),
            alimTalkRcvyn: yn($('#alimTalkRcv')),
            smsRcvyn: yn($('#smsRcv'))
        };
    }

    $('.alim-setting').on('click', function (e) {
        if (!alimAgreeOk) {
            UiComm.showMessage("알림 수신 유의사항에 먼저 동의해주세요.", "warning");
            e.preventDefault();
            e.stopPropagation();
            return false;
        }
    });


    let alimTimer = null; // 알림 저장 딜레이 타이머

    // 마지막 변경 후 0.3초간 변화 없을 때 저장
    $('.alim-setting input[type=checkbox]').on('change', function () {
        if (!alimAgreeOk) return;

        clearTimeout(alimTimer);
        alimTimer = setTimeout(function () {
            ajaxCall('/user/userHome/userPrfilAlimChangeAjax.do', collectAlimData(), function (data) {
            }, function (xhr, status, error) {
                alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
            }, true);
        }, 300);
    });

    $('#btn_modify').on('click', function () {
        location.href = '/user/userHome/userPrfilModifyView.do';
    });

</script>
</body>

</html>
