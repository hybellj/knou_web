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
        <%@ include file="/WEB-INF/jsp/common_new/home_header.jsp" %>
        <!-- //common header -->

        <!-- dashboard -->
        <main class="common">

            <!-- gnb -->
            <%@ include file="/WEB-INF/jsp/common_new/home_gnb_prof.jsp" %>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="dashboard_sub">

                    <!-- page_tab -->
                    <%@ include file="/WEB-INF/jsp/common_new/home_page_tab.jsp" %>
                    <!-- //page_tab -->

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title"><span>메시지함</span>PUSH</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>메시지함</li>
                                    <li><span class="current">메시지템플릿</span></li>
                                </ul>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">학과/부서 문구</h3>
                            <div class="right-area">
                                <!-- Tab btn -->
                                <div class="tab_btn">
                                    <a href="#tab01">개인 문구</a>
                                    <a href="#tab02" class="current">학과/부서 문구</a>                                                                      
                                </div>  
                                <!-- search small -->
                                <div class="search-typeC">
                                    <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="제목/내용 검색">
                                    <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                                </div>                                                                                
                            </div>
                        </div>

                        <div class="message_list">
                            <ul class="message_card">
                                <li>
                                    <a href="#0" class="card_item">
                                        <div class="item_header">                                           
                                            <div class="msg_tit">
                                                 학과/부서 안내 메시지
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                학과/부서 안내 메시지입니다. 학과 공지사항 내용 확인해주세요.                                                
                                            </p>
                                        </div>                                        
                                    </a>
                                </li>
                                <li>
                                    <a href="#0" class="card_item">
                                        <div class="item_header">                                            
                                            <div class="msg_tit">
                                                 학과/부서 안내 메시지
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                중간고사 기간이 시작되었습니다. <br>
                                                2026.04.20 09:00 ~ 2026.05.10 23:59 까지 입니다. <br>
                                                자세한 내용은 과목 공지사항을 확인해주세요. <br> 
                                                자세한 내용은 과목 공지사항을 확인해주세요. <br>                                       
                                            </p>
                                        </div>                                        
                                    </a>
                                </li>
                                <li>
                                    <a href="#0" class="card_item">
                                        <div class="item_header">                                           
                                            <div class="msg_tit">
                                                 학과/부서 안내 메시지
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                새로운 학기가 시작되었습니다. 변경된 일정 및 안내사항을 확인해 주세요.                                  
                                            </p>
                                        </div>                                        
                                    </a>
                                </li>
                                <li>
                                    <a href="#0" class="card_item">
                                        <div class="item_header">                                           
                                            <div class="msg_tit">
                                                 학과/부서 안내 메시지
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                1주차 강의자료 업로드 되었습니다. 다운로드 받아주세요.                            
                                            </p>
                                        </div>                                        
                                    </a>
                                </li>
                                <li>
                                    <a href="#0" class="card_item">
                                        <div class="item_header">                                            
                                            <div class="msg_tit">
                                                 학과/부서 안내 메시지
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                과제 제출 기간이 얼마 남지 않았습니다. 기간내에 제출해주세요.                                                
                                            </p>
                                        </div>                                        
                                    </a>
                                </li>
                                <li>
                                    <a href="#0" class="card_item">
                                        <div class="item_header">                                            
                                            <div class="msg_tit">
                                                 학과/부서 안내 메시지
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                중간고사 기간이 시작되었습니다. <br>
                                                2026.04.20 09:00 ~ 2026.05.10 23:59 까지 입니다. <br>
                                                자세한 내용은 과목 공지사항을 확인해주세요. <br> 
                                                자세한 내용은 과목 공지사항을 확인해주세요. <br>                                       
                                            </p>
                                        </div>                                        
                                    </a>
                                </li>
                                <li>
                                    <a href="#0" class="card_item">
                                        <div class="item_header">                                            
                                            <div class="msg_tit">
                                                 학과/부서 안내 메시지
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                새로운 학기가 시작되었습니다. 변경된 일정 및 안내사항을 확인해 주세요.                                  
                                            </p>
                                        </div>                                        
                                    </a>
                                </li>
                                <li>
                                    <a href="#0" class="card_item">
                                        <div class="item_header">                                            
                                            <div class="msg_tit">
                                                 학과/부서 안내 메시지
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                1주차 강의자료 업로드 되었습니다. 다운로드 받아주세요.                            
                                            </p>
                                        </div>                                        
                                    </a>
                                </li>
                                <li>
                                    <a href="#0" class="card_item">
                                        <div class="item_header">                                           
                                            <div class="msg_tit">
                                                 학과/부서 안내 메시지
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                과제 제출 기간이 얼마 남지 않았습니다. 기간내에 제출해주세요.                                                
                                            </p>
                                        </div>                                        
                                    </a>
                                </li>
                                <li>
                                    <a href="#0" class="card_item">
                                        <div class="item_header">                                            
                                            <div class="msg_tit">
                                                 학과/부서 안내 메시지
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                중간고사 기간이 시작되었습니다. <br>
                                                2026.04.20 09:00 ~ 2026.05.10 23:59 까지 입니다. <br>
                                                자세한 내용은 과목 공지사항을 확인해주세요. <br> 
                                                자세한 내용은 과목 공지사항을 확인해주세요. <br>                                       
                                            </p>
                                        </div>                                        
                                    </a>
                                </li>
                                <li>
                                    <a href="#0" class="card_item">
                                        <div class="item_header">                                           
                                            <div class="msg_tit">
                                                 학과/부서 안내 메시지
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                새로운 학기가 시작되었습니다. 변경된 일정 및 안내사항을 확인해 주세요.                                  
                                            </p>
                                        </div>                                        
                                    </a>
                                </li>
                                <li>
                                    <a href="#0" class="card_item">
                                        <div class="item_header">                                           
                                            <div class="msg_tit">
                                                 학과/부서 안내 메시지
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                1주차 강의자료 업로드 되었습니다. 다운로드 받아주세요.                            
                                            </p>
                                        </div>                                        
                                    </a>
                                </li>
                            </ul>
                        </div>                        
                        <div class="btns">
                            <label class="btn basic scroll">scroll down<i class="xi-arrow-down"></i></label>
                        </div>

                    </div>

                </div>
            </div>
            <!-- //content -->


            <!-- common footer -->
            <%@ include file="/WEB-INF/jsp/common_new/home_footer.jsp" %>
            <!-- //common footer -->

        </main>
        <!-- //dashboard-->

    </div>

</body>
</html>

