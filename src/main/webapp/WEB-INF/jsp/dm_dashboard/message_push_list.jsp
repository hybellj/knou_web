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
                <div class="dashboard_sub">
                                                                        
                    <!-- page_tab -->
                    <%@ include file="../dm_inc/home_page_tab.jsp" %>
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
                       

                        <!-- search typeA -->
                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="selectDate">학사년도/학기</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectDate1">
                                        <option value="2025년">2025년</option>
                                        <option value="2024년">2024년</option>    
                                    </select>
                                    <select class="form-select" id="selectDate2">
                                        <option value="2학기">2학기</option>
                                        <option value="1학기">1학기</option>        
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectCourse">운영과목</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectCourse">
                                        <option value="대학원">대학원</option> 
                                        <option value="평생교육">평생교육</option>                                       
                                    </select>
                                    <select class="form-select wide" id="selectSubject">
                                        <option value="">운영과목 선택</option>
                                        <option value="운영과목1">운영과목1</option>
                                        <option value="운영과목2">운영과목2</option>   
                                    </select>                                   
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectDate">요청 일시</label></span>
                                <div class="itemList">
                                    <div class="date_area wide">
                                        <label class="datepicker">
                                            <input type="text" placeholder="시작일시" id="datetimepicker1">
                                        </label>
                                        <span class="txt-sort">~</span>
                                        <label class="datepicker">
                                            <input type="text" placeholder="종료일시" id="datetimepicker2">
                                        </label>
                                    </div>			
                                    <script>
                                    $.datetimepicker.setLocale('ko');

                                    $('#datetimepicker1').datetimepicker({
                                        format: 'Y-m-d H:i',
                                        step: 10,              // 10분 단위 간격
                                        scrollMonth: false,
                                        scrollTime: true,
                                        scrollInput: false,
                                        theme: '',             
                                        onShow: function(ct){
                                            this.setOptions({
                                                maxDate: $('#datetimepicker2').val() ? $('#datetimepicker2').val() : false
                                            });
                                        }
                                    });

                                    $('#datetimepicker2').datetimepicker({
                                        format: 'Y-m-d H:i',
                                        step: 10,
                                        scrollMonth: false,
                                        scrollTime: true,
                                        scrollInput: false,
                                        onShow: function(ct){
                                            this.setOptions({
                                                minDate: $('#datetimepicker1').val() ? $('#datetimepicker1').val() : false
                                            });
                                        }
                                    });

                                    $(document).on('click', '.xdsoft_month, .xdsoft_year', function(e) {
                                    e.stopPropagation(); 
                                    e.preventDefault(); 
                                    return false;
                                    });
                                    </script>
                                
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectSearch">검색 조건</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectSearch1">
                                        <option value="발신자">발신자</option>
                                        <option value="발신자번호">발신자번호</option> 
                                        <option value="제목">제목</option> 
                                        <option value="내용">내용</option>         
                                    </select>
                                    <input class="form-control wide" type="text" name="" id="inputSearch1" value="" placeholder="검색어를 입력해주세요.">                                    
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search">검색</button>                      
                            </div>                  
                        </div>

                        <!-- Tab btn -->
                        <div class="tabs_top">
                            <div class="tab_btn">
                                <a href="#" class="current">수신목록</a>
                                <a href="#">발신목록</a>                                                                      
                            </div>                            
                            <div class="right-area">
                                <button type="button" class="btn basic icon" aria-label="새로고침"><i class="xi-refresh"></i></button>
                                <button type="button" class="btn basic">삭제</button>
                                <button type="button" class="btn basic">엑셀 다운로드</button>
                            </div>  
                        </div> 
                                                
                        <div class="board_top">
                            <h3 class="board-title">PUSH 수신 목록</h3>
                            <span class="total_num">총 <strong>90</strong>건</span>   
                            <div class="right-area">
                                <button type="button" class="btn type2">발신하기</button>
                            </div>                         
                        </div>
                        
                        <!--table-type2-->
                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:3%">
                                    <col style="width:5%">
                                    <col style="width:7%">
                                    <col style="width:4%">
                                    <col style="width:7%">
                                    <col style="width:10%">
                                    <col style="width:4%">
                                    <col style="width:7%">
                                    <col style="width:11%">
                                    <col style="">
                                    <col style="width:11%">
                                    <col style="width:4%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>
                                            <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>
                                        </th>
                                        <th>번호</th>
                                        <th>년도</th>
                                        <th>학기</th>
                                        <th>과정</th>
                                        <th>운영과목</th>
                                        <th>반</th>
                                        <th>발신자</th>	
                                        <th>발신자번호</th>
                                        <th>제목</th>
                                        <th>발신일시</th>
                                        <th>읽음</th>					
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk1"><label for="chk1"></label></span>
                                        </td>
                                        <td data-th="번호">90</td>
                                        <td data-th="년도">2025년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="과정">대학원</td>
                                        <td data-th="운영과목">일본어</td>
                                        <td data-th="반">1</td>
                                        <td data-th="발신자">홍길동</td>
                                        <td data-th="발신자번호">010-2589-6254</td>
                                        <td data-th="제목" class="t_left">
                                            <a href="#0" class="title text-truncate">알림 제목입니다.</a>
                                        </td>
                                        <td data-th="발신일시">2025.08.04 15:32</td>
                                        <td data-th="읽음">-</td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk2"><label for="chk2"></label></span>
                                        </td>
                                        <td data-th="번호">90</td>
                                        <td data-th="년도">2025년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="과정">대학원</td>
                                        <td data-th="운영과목">일본어</td>
                                        <td data-th="반">1</td>
                                        <td data-th="발신자">홍길동</td>
                                        <td data-th="발신자번호">010-2589-6254</td>
                                        <td data-th="제목" class="t_left">
                                            <a href="#0" class="title text-truncate">알림 제목입니다.</a>
                                        </td>
                                        <td data-th="발신일시">2025.08.04 15:32</td>
                                        <td data-th="읽음">-</td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk2"><label for="chk2"></label></span>
                                        </td>
                                        <td data-th="번호">90</td>
                                        <td data-th="년도">2025년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="과정">대학원</td>
                                        <td data-th="운영과목">일본어</td>
                                        <td data-th="반">1</td>
                                        <td data-th="발신자">홍길동</td>
                                        <td data-th="발신자번호">010-2589-6254</td>
                                        <td data-th="제목" class="t_left">
                                            <a href="#0" class="title text-truncate">알림 제목입니다.</a>
                                        </td>
                                        <td data-th="발신일시">2025.08.04 15:32</td>
                                        <td data-th="읽음">-</td>
                                    </tr>
                                </tbody>
                            
                            </table>
                        </div>
                        <!--//table-type2-->

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

