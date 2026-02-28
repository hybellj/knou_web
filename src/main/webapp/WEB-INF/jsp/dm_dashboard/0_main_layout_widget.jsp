<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="../dm_inc/home_common.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/dm_assets/css/dashboard.css" />

<body class="home colorA "><!-- 컬러선택시 클래스변경 -->
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
                <div class="dashboard">
                                                    
                    <div class="grid inline"> <!-- 위젯 영역 3분할 -->
                        <!-- Today -->
                        <div class="box">
                            박스 기본1
                        </div>

                        <!-- 일정 -->
                        <div class="box">
                            박스 기본2
                        </div>

                        <!-- 공지 -->
                        <div class="box">
                            박스 기본3
                        </div>
                    </div>
                   

                    <div class="grid"> 
                        <!-- 과목 -->
                        <div class="box span-3"> <!-- span-3은 box영역 100% -->
                            박스 100%
                        </div>
                    </div>

                    <div class="grid divided"><!--위젯 영역 2분할 -->
                        <!-- 과목 -->
                        <div class="box span-2"> <!-- span-2 영역 66%, 높이 자동 맞춤 -->
                            박스 66%, 높이 자동 맞춤(기본)
                        </div>

                        <div class="col-vertical"> <!-- 영역 33% -->
                            <!-- box -->
                            <div class="box">
                                박스 33%
                            </div>

                            <!-- box -->
                            <div class="box">
                                박스 33%
                            </div>
                        </div>
                        
                    </div>

                    <div class="grid divided"><!--위젯 영역 2분할 -->
                       
                        <div class="col-vertical"><!-- 영역 33% -->
                            <!-- box -->
                            <div class="box">
                                박스
                            </div> 
                            <!-- box -->
                            <div class="box">
                                박스
                            </div>                                                 
                        </div>

                         <!-- 과목 -->
                        <div class="box span-2 fit-height"> <!-- 영역 66%, 높이 컨텐츠 크기만큼 -->
                            박스 66%, 높이 컨텐츠 크기만큼 (fit-height 클래스 추가)
                        </div>

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
