<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">
		<jsp:param name="style" value="dashboard"/>
	</jsp:include>
</head>

<body class="home"><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="../common/home_header.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
        <!-- //common header -->

        <!-- dashboard -->
        <main class="common">

            <!-- gnb -->
			<jsp:include page="../common/home_gnb_prof.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="dashboard_sub">

                    <!-- page_tab -->
                    <jsp:include page="../common/home_page_tab.jsp"/>
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

                        <div class="user-wrap">

                            <div class="user-img">
                                <div class="user-photo">
                                    <!--프로필 사진-->
                                    <img src="<%=request.getContextPath()%>/webdoc/assets/img/common/default_prof.png" alt="사진">
                                </div>
                            </div>

                            <!--table-type5-->
                            <div class="table-wrap">
                                <table class="table-type5">
                                    <colgroup>
                                        <col class="width-15per" />
                                        <col class="" />
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                            <th><label for="univ_label">기관</label></th>
                                            <td>
                                                <div class="form-inline">
                                                    <ul class="label_list ml0">
                                                        <li class="addedLabel">
                                                            <label>대학원</label>
                                                        </li>
                                                        <li class="addedLabel">
                                                            <label>평생교육</label>
                                                        </li>
                                                        <li class="addedLabel">
                                                            <label>학위과정</label>
                                                        </li>
                                                    </ul>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><label for="name_label">이름</label></th>
                                            <td>홍*동 ( 사용자별칭 : 관리자 )</td>
                                        </tr>
                                        <tr>
                                            <th><label for="id_label">교번</label></th>
                                            <td>K2026*****</td>
                                        </tr>
                                        <tr>
                                            <th><label for="id_label">아이디</label></th>
                                            <td>hfdong1**4</td>
                                        </tr>
                                        <tr>
                                            <th><label for="mobileLabel">휴대폰 번호</label></th>
                                            <td>010-1254-95**</td>
                                        </tr>
                                        <tr>
                                            <th><label for="사용 이메일">사용 이메일</label></th>
                                            <td>testh**g@naver.com (연계 이메일)</td>
                                        </tr>
                                    </tbody>
                                </table>

                                <small class="note2">! 다른 이메일을 사용하시려면 “등록/수정”에서 개인 이메일 등록하고 사용설정 하시면 됩니다.</small>
                            </div>
                            <!--//table-type5-->

                        </div>

                        <div class="btns mb40">
                            <button type="button" class="btn type1">수정</button>
                        </div>

                        <div class="notify-consent-wrap">
                            <div class="board_top">
                                <h4 class="sub-title">알림수신 동의 설정</h4>
                                <div class="right-area">
                                    <div class="tab_btn">
                                        <a href="#tab01" class="">알림수신 유의사항 읽음</a>
                                    </div>
                               </div>
                            </div>
                            <div class="table_list">
                                <ul class="list">
                                    <li class="head"><label>PUSH</label></li>
                                    <li>
                                        <div class="form-row">
                                            <input type="checkbox" id="checkOpenYn" class="switch yesno" checked>
                                        </div>
                                        PUSH 수신 동의 합니다.
                                    </li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>쪽지</label></li>
                                    <li>
                                        <div class="form-row">
                                            <input type="checkbox" id="checkOpenYn" class="switch yesno" checked>
                                        </div>
                                        쪽지 수신 동의 합니다.
                                    </li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>이메일</label></li>
                                    <li>
                                        <div class="form-row">
                                            <input type="checkbox" id="checkOpenYn" class="switch yesno" checked>
                                        </div>
                                        이메일 수신 동의 합니다.
                                    </li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>알림톡</label></li>
                                    <li>
                                        <div class="form-row">
                                            <input type="checkbox" id="checkOpenYn" class="switch yesno">
                                        </div>
                                        알림톡 수신 동의 합니다.
                                    </li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>문자</label></li>
                                    <li>
                                        <div class="form-row">
                                            <input type="checkbox" id="checkOpenYn" class="switch yesno" checked>
                                        </div>
                                        문자(문자) 수신 동의 합니다.
                                    </li>
                                </ul>                                
                            </div>
                            <small class="note2">! 공지 / 강의Q&A / 1:1상담에 대한 알림은 동의여부와 상관없이 발송됩니다.</small>
                        </div>
                    </div>

                </div>
            </div>
            <!-- //content -->


            <!-- common footer -->
            <jsp:include page="../common/home_footer.jsp"/>
            <!-- //common footer -->

        </main>
        <!-- //dashboard-->

    </div>

</body>
</html>
