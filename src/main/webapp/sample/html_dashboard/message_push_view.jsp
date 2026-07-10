<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">
		<jsp:param name="style" value="dashboard"/>
	</jsp:include>
</head>

<body class="home "><!-- 컬러선택시 클래스변경 -->
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
                            <h2 class="page-title"><span>메시지함</span>PUSH</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>메시지함</li>
                                    <li><span class="current">PUSH</span></li>
                                </ul>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">PUSH 수신 내용</h3>
                        </div>

                        <div class="table_list">
                            <ul class="list">
                                <li class="head"><label>기관/학기</label></li>
                                <li>대학원 / 2026년 1학기</li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label>운영과목</label></li>
                                <li>일본어</li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label>이메일</label></li>
                                <li>test@naver.com</li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label>내용</label></li>
                                <li>
                                    <div class="tb_content">
                                        <div class="">
                                            보다 안정적이고 원활한 서비스 제공을 위해 아래와 같이 서버 점검이 진행될 예정입니다.<br>
                                            2025년 11월 4일(월) 02:00 ~ 04:00
                                        </div>
                                    </div>
                                </li>
                            </ul>
                            
                            <ul class="list">
                                <li class="head"><label>첨부파일</label></li>
                                <li>
                                    <div>
                                        <a href="#" class="file_down">
                                            <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                            <span class="text">첨부파일_202254541.mp4</span>
                                            <span class="fileSize">(143.26 KB)</span>
                                        </a>
                                    </div>
                                </li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label>발신일시</label></li>
                                <li>2025.08.04 15:32</li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label>발신자</label></li>
                                <li>관리자</li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label>발신자 번호</label></li>
                                <li>02-000-1234</li>
                            </ul>
                        </div>

                        <div class="btns">
                            <button type="button" class="btn type1">발신하기</button>
                            <button type="button" class="btn type2">수신목록</button>
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

