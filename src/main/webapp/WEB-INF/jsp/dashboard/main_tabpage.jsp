<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="module" value="tabmenu"/>
		<jsp:param name="style" value="dashboard"/>
	</jsp:include>

	<script type="text/javascript">
		let TAB_MENU = null;

		$(function(){
			let menuUrl = "${menuUrl}";
			let menunm = "${menunm}";
			let upMenuId = "${upMenuId}";
			let menuId = "${menuId}";

			if (menuUrl != "") {
				menuUrl += (menuUrl.indexOf("?") === -1 ? "?" : "&") + "encParams=${encParams}";

				TAB_MENU = UiTabMenu("pageTabs", "pageFrames");
				TAB_MENU.addTabMenu(menunm, menuUrl, upMenuId, menuId);
			}

			// 탭메뉴 왼쪽 이동
			$("#moveLeftBtn").on('click', function () {
				TAB_MENU.scrollLeft();
        	});

			// 탭메뉴 오른쪽 이동
			$("#moveRightBtn").on('click', function () {
				TAB_MENU.scrollRight();
        	});

			if (menuId != "") {
				$("#MENU_"+menuId).addClass("current");
				$("#SUBMENU_"+menuId).addClass("current");
				$("#SUB_"+upMenuId).show();
			}
		});

		function moveMain() {
			document.location.href = "/";
		}

	</script>
</head>

<body class="home colorA "  style=""><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp?view=on"/>
        <!-- //common header -->

        <!-- dashboard -->
        <main class="common">

            <!-- gnb -->
            <c:choose>
            	<c:when test="${authrtGrpcd eq 'PROF'}">
            		<jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp?view=on"/>
            	</c:when>
            	<c:when test="${authrtGrpcd eq 'STDNT'}">
            		<jsp:include page="/WEB-INF/jsp/common_new/home_gnb_stu.jsp?view=on"/>
            	</c:when>
            	<c:when test="${authrtGrpcd eq 'ADM'}">
            		<jsp:include page="/WEB-INF/jsp/common_new/home_gnb_adm.jsp?view=on"/>
            	</c:when>
            </c:choose>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="dashboard_sub">



					<div class="page-menu">
						<button id="moveLeftBtn" class="btn_arrow"><i class="xi-angle-left"></i></button>
						<ul id="pageTabs" class="page_tab">
						</ul>
                        <div class="right-buttons">
                            <button id="moveRightBtn" class="btn_arrow2"><i class="xi-angle-right"></i></button>
                            <button id="closeAllBtn" class="btn_close" onclick="moveMain()"><i class="xi-close"></i></button>
                        </div>
					</div>

					<div id="pageFrames" class="sub-content">
					</div>

                </div>
            </div>
            <!-- //content -->


            <!-- common footer -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp?view=on"/>
            <!-- //common footer -->

        </main>
        <!-- //dashboard-->

    </div>


</body>
</html>