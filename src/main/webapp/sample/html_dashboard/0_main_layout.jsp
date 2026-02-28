<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="dashboard"/>
	</jsp:include>
</head>

<body class="home colorA "><!-- 컬러선택시 클래스변경 -->
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
                <div class="dashboard">

                    <div class="grid inline"> <!-- 첫 번째 줄 (3등분) -->
                        <div class="box">Today</div>
                        <div class="box">강의Q&A</div>
                        <div class="box">1:1상담</div>
                    </div>

                    <div class="grid divided"><!-- 두 번째 줄 (2등분) -->
                        <!-- 일반 박스 세로 묶음 -->
                        <div class="col-vertical">
                            <div class="box">일반</div>
                            <div class="box">일반</div>
                            <div class="box">일반</div>
                        </div>
                        <div class="box span-2">일반</div>
                    </div>
                    <div class="grid"><!-- 세 번째 줄 (100%)  -->
                        <div class="box span-3">강의과목</div>
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

</body>
</html>
