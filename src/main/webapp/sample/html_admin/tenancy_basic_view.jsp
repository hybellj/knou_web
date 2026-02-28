<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="admin"/>
	</jsp:include>
</head>

<body class="admin">
    <div id="wrap" class="main">
        <!-- common header -->
        <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>
        <!-- //common header -->

        <!-- admin -->
        <main class="common">

            <!-- gnb -->
            <%@ include file="/WEB-INF/jsp/common_new/admin_aside.jsp" %>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="admin_sub_top">
                    <div class="date_info">
                        <i class="icon-svg-calendar" aria-hidden="true"></i>2025년 2학기 7주차 : 2025.10.05 (월) ~ 2025.10.16 (목)
                    </div>
                </div>
                <div class="admin_sub">

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">기본 정보 관리</h2>
                        </div>

                        <div class="box">
							<div class="board_top">
								<h3 class="board-title">상세보기</h3>
							</div>
                            <!--table-view-->
                            <div class="table_list">
                                <ul class="list">
                                    <li class="head"><label>기관 ID </label></li>
                                    <li>KONUTESTID001</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>기관 Full Name</label></li>
                                    <li>프라임칼리지 학위과정</li>

                                </ul>
                                <ul class="list">
                                    <li class="head"><label>기관 Short Name</label></li>
                                    <li>학사학위과정</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>기관 유형</label></li>
                                    <li>학위과정</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>홈페이지 URL</label></li>
                                    <li>https://smart.knou.ac.kr/smart/index.do</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>담당자명</label></li>
                                    <li>안길동</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>담당자 연락처</label></li>
                                    <li>010-1254-9874</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>담당자 이메일</label></li>
                                    <li>test003@naver.com</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>사무실 전화번호</label></li>
                                    <li>02-3214-8523</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>기관 로고 PC</label></li>
                                    <li><img src="<%=request.getContextPath()%>/webdoc/assets/img/logo.png" aria-hidden="true" alt="한국방송통신대학교"></li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>기관 로고 Mobile</label></li>
                                    <li><img src="<%=request.getContextPath()%>/webdoc/assets/img/logo_mobile.png" aria-hidden="true" alt="한국방송통신대학교"></li>
                                </ul>
                            </div>
						</div>

						<div class="box">
							<div class="board_top">
								<h3 class="board-title">하단 문구</h3>
							</div>
							<!--table-view-->
                            <div class="table_list">
                                <ul class="list">
                                    <li class="head"><label>주소</label></li>
                                    <li>03087<br>
                                    서울시 종로구 대학로 86 (동숭동)<br>
                                    한국방송통신대학원
                                    </li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>대표전화</label></li>
                                    <li>1588-9995</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>CopyRight</label></li>
                                    <li>COPYRIGHT ©KOREA NATIONAL OPEN UNIVERSITY. ALL RIGHTS RESERVED.</li>
                                </ul>
                                <ul class="list">
                                    <li>
                                        <div class="tb_content">COPYRIGHT ©KOREA NATIONAL OPEN UNIVERSITY. ALL RIGHTS RESERVED.</div>
                                    </li>
                                </ul>
                            </div>
						</div>

                        <div class="btns">
                            <button type="button" class="btn type1">수정</button>
                            <button type="button" class="btn type2">목록</button>
                        </div>


                    </div>
                </div>

            </div>
            <!-- //content -->

        </main>
        <!-- //admin-->

    </div>

</body>
</html>

