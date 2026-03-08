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
                            <h2 class="page-title">강의실 메뉴설정</h2>
                        </div>                        

                        <!-- board top -->
                        <div class="board_top">
                            <select class="form-select" id="selectDate1">
                                <option value="기관 선택">기관 선택</option>
                                <option value="프라임칼리지 평생교육과정">프라임칼리지 평생교육과정</option>
                            </select>
                            <!-- <h3 class="board-title">개인 문구</h3> -->
                            <div class="right-area">
                                <!-- Tab btn -->
                                <div class="tab_btn">
                                    <a href="#tab01" class="current">교수 글로벌메뉴 설정</a>
                                    <a href="#tab02">교수 강의실메뉴설정</a>  
                                    <a href="#tab03">학습자 글로벌메뉴 설정</a>       
                                    <a href="#tab04">학습자 강의실메뉴 설정</a>                                                                           
                                </div>                                                                                                                     
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">교수 글로벌메뉴 설정</h3>                            
                        </div>
                        <div class="msg-box "> 
                            <p class="txt"><span class="fcBlue">"교수 글로벌메뉴"</span> 사용 여부 설정합니다.  </p>                                                                                                                                              
                        </div>

                        <!--table-type-->
                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:5%">
                                    <col style="">
                                    <col style="width:12%">
                                    <col style="width:12%">
                                    <col style="width:7%">                                    
                                    <col style="width:7%">
                                    <col style="width:7%">                                                                        
                                    <col style="width:7%">
                                    <col style="width:7%">                                    
                                    <col style="width:7%">
                                    <col style="width:7%">                                                                        
                                    <col style="width:7%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>번호</th>
                                        <th>1차 메뉴</th>
                                        <th>2차 메뉴</th>
                                        <th>3차 메뉴</th>                                        
                                        <th class="bcLYellow">교수</th>
                                        <th class="bcLYellow">공동교수</th>
                                        <th class="bcLYellow">외부강사</th>
                                        <th class="bcLYellow">관찰자</th>
                                        <th class="bcLYellow">튜터</th>
                                        <th class="bcLYellow">조교</th>
                                        <th class="bcLYellow">학생</th>
                                        <th class="bcLYellow">청강생</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="번호">6</td>
                                        <td data-th="1차 메뉴">대시보드</td>
                                        <td data-th="2차 메뉴">대시보드 메뉴</td>
                                        <td data-th="3차 메뉴">-</td>                                        
                                        <td data-th="교수">홍길동</td>
                                        <td data-th="공동교수">
                                            <input type="checkbox" value="Y" class="switch small" checked="checked">
                                        </td>
                                        <td data-th="외부강사">
                                            <input type="checkbox" value="Y" class="switch small" checked="checked">
                                        </td>
                                        <td data-th="관찰자">
                                            <input type="checkbox" value="Y" class="switch small" checked="checked">
                                        </td>
                                        <td data-th="튜터">
                                            <input type="checkbox" value="Y" class="switch small" checked="checked">
                                        </td>
                                        <td data-th="조교">
                                            <input type="checkbox" value="Y" class="switch small" checked="checked">     
                                        </td>
                                        <td data-th="학생">
                                            <input type="checkbox" value="N" class="switch small">                                        
                                        </td>
                                        <td data-th="청강생">
                                            <input type="checkbox" value="N" class="switch small"> 
                                        </td>
                                    </tr>   
                                    <tr>
                                        <td data-th="번호">6</td>
                                        <td data-th="1차 메뉴">대시보드</td>
                                        <td data-th="2차 메뉴">대시보드 메뉴</td>
                                        <td data-th="3차 메뉴">-</td>                                        
                                        <td data-th="교수">홍길동</td>
                                        <td data-th="공동교수">
                                            <input type="checkbox" value="Y" class="switch small" checked="checked">
                                        </td>
                                        <td data-th="외부강사">
                                            <input type="checkbox" value="Y" class="switch small" checked="checked">
                                        </td>
                                        <td data-th="관찰자">
                                            <input type="checkbox" value="Y" class="switch small" checked="checked">
                                        </td>
                                        <td data-th="튜터">
                                            <input type="checkbox" value="Y" class="switch small" checked="checked">
                                        </td>
                                        <td data-th="조교">
                                            <input type="checkbox" value="Y" class="switch small" checked="checked">     
                                        </td>
                                        <td data-th="학생">
                                            <input type="checkbox" value="N" class="switch small">                                        
                                        </td>
                                        <td data-th="청강생">
                                            <input type="checkbox" value="N" class="switch small"> 
                                        </td>
                                    </tr>  
                                    <tr>
                                        <td data-th="번호">6</td>
                                        <td data-th="1차 메뉴">대시보드</td>
                                        <td data-th="2차 메뉴">대시보드 메뉴</td>
                                        <td data-th="3차 메뉴">-</td>                                        
                                        <td data-th="교수">홍길동</td>
                                        <td data-th="공동교수">
                                            <input type="checkbox" value="Y" class="switch small" checked="checked">
                                        </td>
                                        <td data-th="외부강사">
                                            <input type="checkbox" value="Y" class="switch small" checked="checked">
                                        </td>
                                        <td data-th="관찰자">
                                            <input type="checkbox" value="Y" class="switch small" checked="checked">
                                        </td>
                                        <td data-th="튜터">
                                            <input type="checkbox" value="Y" class="switch small" checked="checked">
                                        </td>
                                        <td data-th="조교">
                                            <input type="checkbox" value="Y" class="switch small" checked="checked">     
                                        </td>
                                        <td data-th="학생">
                                            <input type="checkbox" value="N" class="switch small">                                        
                                        </td>
                                        <td data-th="청강생">
                                            <input type="checkbox" value="N" class="switch small"> 
                                        </td>
                                    </tr>                                                                      
                                </tbody>
                            </table>
                        </div>
                        <!--//table-type-->                        

                    </div>
                </div>              

            </div>
            <!-- //content -->

        </main>
        <!-- //admin-->        

    </div>

</body>
</html>

