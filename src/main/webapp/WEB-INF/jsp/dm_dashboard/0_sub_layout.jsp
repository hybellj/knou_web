<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="../dm_inc/home_common.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/dm_assets/css/dashboard.css" />

<body class="home colorA "  style=""><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <%@ include file="../dm_inc/home_header.jsp" %>
        <!-- //common header -->
    
        <!-- dashboard -->
        <main class="common">

            <!-- gnb -->
            <%@ include file="../dm_inc/home_gnb_prof.jsp" %>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="dashboard_sub">                                                                      

                    <!-- page_tab -->
                    <%@ include file="../dm_inc/home_page_tab.jsp" %>
                    <!-- //page_tab -->      
                
                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">서브</h2>
                            <div class="navi_bar">                                
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>공통</li>
                                    <li><span class="current">레이아웃</span></li>                                 
                                </ul>                                                                         
                            </div>                             
                        </div>
                      
                        contents area
            
                    </div>   

                </div>
            </div>
            <!-- //content -->

            
            <!-- common footer -->
            <%@ include file="../dm_inc/home_footer.jsp" %>
            <!-- //common footer -->

        </main>
        <!-- //dashboard-->

    </div>


</body>
</html>

