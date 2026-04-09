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
                <!-- class_sub_top -->
				<jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
				<!-- //class_sub_top -->

                <div class="class_sub">
                    <!-- class_info -->
					<jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
                    <!-- //class_info -->

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

