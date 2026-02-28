<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
	</jsp:include>
</head>

<body class="class colorA "><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <!-- classroom -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="class_sub_top">
                    <div class="navi_bar">
                        <ul>
                            <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                            <li>강의실</li>
                            <li><span class="current">레이아웃</span></li>
                        </ul>
                    </div>
                    <div class="btn-wrap">
                        <select class="form-select">
                            <option value="2025년 2학기">2025년 2학기</option>
                            <option value="2025년 1학기">2025년 1학기</option>
                        </select>
                        <select class="form-select wide">
                            <option value="">강의실 바로가기</option>
                            <option value="2025년 2학기">2025년 2학기</option>
                            <option value="2025년 1학기">2025년 1학기</option>
                        </select>
                        <button type="button" class="btn type1"><i class="xi-book-o"></i>교수 매뉴얼</button>
                        <button type="button" class="btn type1"><i class="xi-info-o"></i>학습안내정보</button>
                    </div>
                </div>
                <div class="class_sub">

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">서브</h2>

                        </div>

                        contents area

                    </div>
                </div>


            </div>
            <!-- //content -->


        </main>
        <!-- //classroom-->

    </div>

</body>
</html>

