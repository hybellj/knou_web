<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">
		<jsp:param name="module" value="widget"/>
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
                <div class="dashboard">
	            	<div id="container" class="ui form">
			    	</div>
                </div>
            </div>
            <!-- //content -->

<script>
	let grid = null;

    $(document).ready(function() {
		/*
		let db = UiIndexeddb();

		db.saveData("TEST", "AAAAAAAAAA");

		db.getData("TEST");
		*/
		UiComm.db.setItem("TEST", "AAAAAAAAAAA");
    });


</script>
            <!-- common footer -->
            <jsp:include page="../common/home_footer.jsp"/>
            <!-- //common footer -->

        </main>
        <!-- //dashboard-->

    </div>
</body>
</html>
