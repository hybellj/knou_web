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
                <div class="dashboard_sub">

                    <!-- page_tab -->
                    <jsp:include page="/WEB-INF/jsp/common_new/home_page_tab.jsp"/>
                    <!-- //page_tab -->

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">강의계획서</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li><span class="current">강의계획서</span></li>
                                </ul>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">강의계획서 상세정보</h3>
                        </div>

                        <h4 class="sub-title">과목 정보</h4>                        
                        <div class="table_list">
                            <ul class="list">
                                <li class="head"><label>과목번호</label></li>
                                <li>CM0025</li>
                                <li class="head"><label>분반</label></li>
                                <li>01</li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label>과목명 (한글)</label></li>
                                <li>데이터베이스의 이해 활용</li>
                                <li class="head"><label>과목명 (영문)</label></li>
                                <li>Data base</li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label>학과</label></li>
                                <li>컴퓨터공학과</li>
                                <li class="head"><label>학점 : 강의/실습</label></li>
                                <li>3 : 3 / 0</li>
                            </ul>
                        </div>

                        <h4 class="sub-title">교수 정보</h4>                          
                        <!-- 정보성 테이블 -->
                        <div class="table-wrap">
                            <table class="table-type1">
                                <colgroup>
                                    <col style="width:22%">
                                    <col style="width:22%">
                                    <col style="width:22%">
                                    <col style="">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>교수</th>
                                        <th>소속</th>
                                        <th>연락처</th>
                                        <th>이메일</th>                                   
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="교수">운영교수 : 홍길동</td>
                                        <td data-th="소속">컴퓨터공학과</td>
                                        <td data-th="연락처">02-5214-9853</td>
                                        <td data-th="이메일">test@naver.com</td>                                   
                                    </tr>
                                    <tr>
                                        <td data-th="교수">공동교수 : 김교수</td>
                                        <td data-th="소속">컴퓨터공학과</td>
                                        <td data-th="연락처">02-5214-9853</td>
                                        <td data-th="이메일">test@naver.com</td>                                   
                                    </tr>                                   
                                </tbody>
                            </table>
                        </div>
                        <div class="msg-box basic">                                
                            <ul class="list-asterisk">
                                <li>담당교수 : 해당학기 시험, 과제 등의 실제 수업을 담당하는 교수</li>                                                            
                            </ul>                                                           
                        </div>

                        <h4 class="sub-title">튜터 정보</h4>                        
                        <div class="table-wrap">
                            <table class="table-type1">
                                <colgroup>
                                    <col style="width:22%">
                                    <col style="width:22%">
                                    <col style="width:22%">
                                    <col style="">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>튜터</th>
                                        <th>연락처</th>
                                        <th>핸드폰</th>
                                        <th>이메일</th>                                   
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="튜터">이튜터</td>
                                        <td data-th="연락처">02-9574-9874</td>
                                        <td data-th="핸드폰">010-7536-2587</td>
                                        <td data-th="이메일">test@naver.com</td>                                   
                                    </tr>                                
                                </tbody>
                            </table>
                        </div>

                        <h4 class="sub-title">조교 정보</h4>                        
                        <div class="table-wrap">
                            <table class="table-type1">
                                <colgroup>
                                    <col style="width:22%">
                                    <col style="width:22%">
                                    <col style="width:22%">
                                    <col style="">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>조교</th>
                                        <th>연락처</th>
                                        <th>핸드폰</th>
                                        <th>이메일</th>                                   
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="조교">홍조교</td>
                                        <td data-th="연락처">02-9574-9874</td>
                                        <td data-th="핸드폰">010-7536-2587</td>
                                        <td data-th="이메일">test@naver.com</td>                                   
                                    </tr>                                
                                </tbody>
                            </table>
                        </div>
                        
                        <h4 class="sub-title">강의 개요</h4>                        
                        <div class="table_list">
                            <ul class="list">
                                <li class="head"><label>교과목 개요</label></li>
                                <li>본 교과목은 공학 전공에 필요한 화학의 기본 개념 정립을 위해 자연과학의 기초가 되는 물질과 주위의 환경현상에 대한 변화를 이해하고 물질의 에너지, 
                                    화학결합과 원자 및 분자구조, 화학열역학과 화학평형, 반응속도론 등 화학 기초 지식 습득을 목표로 한다.
                                </li>                           
                            </ul>
                            <ul class="list">
                                <li class="head"><label>강의 목표</label></li>
                                <li>자연과학의 기초가 되는 물질과 그 변화에 대한 이해, 화학결합과 원자 및 분자구조, 화학열역학과 화학평형, 반응속도론 등의 화학의 기본 개념을 이해하고 정립한다.</li>                           
                            </ul>
                            <ul class="list">
                                <li class="head"><label>운영 방침</label></li>
                                <li>대학의 출석/운영/평가 등 일반 정책 및 방침 준수</li>                           
                            </ul>
                            <ul class="list">
                                <li class="head"><label>운영 계획</label></li>
                                <li>
                                    <ul class="list-bullet">
                                        <li>최적 학습 시간 : 주 150분</li>
                                        <li>학습 방법 : 강의 내용과 교재를 학습</li>
                                        <li>학습 규칙 : 학습 순서 준수</li>
                                        <li>학습 절차 : 학습목표 .> 단계별 이론 강의 > 응용 및 문제풀이 > 학습 요약</li>
                                    </ul>
                                </li>                           
                            </ul>
                            <ul class="list">
                                <li class="head"><label>관련 과목 내용</label></li>
                                <li>-</li>                           
                            </ul>
                            <ul class="list">
                                <li class="head"><label>참고 사항</label></li>
                                <li>-</li>                           
                            </ul>                       
                        </div>

                        <h4 class="sub-title">교재</h4>                          
                        <div class="table-wrap">
                            <table class="table-type1">
                                <colgroup>
                                    <col style="width:7%">
                                    <col style="width:10%">
                                    <col style="">
                                    <col style="width:20%">
                                    <col style="width:21%">
                                    <col style="width:16%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>번호</th>
                                        <th>구분</th>
                                        <th>교재명</th>
                                        <th>ISBN</th>   
                                        <th>저자</th>
                                        <th>출판사</th>                                
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="번호">1</td>
                                        <td data-th="구분">주교재</td>
                                        <td data-th="교재명">기본 일반화학</td>
                                        <td data-th="ISBN">9788962184822</td>   
                                        <td data-th="저자">Stieven S. Zumdahl</td>     
                                        <td data-th="출판사">CENGAGE</td>                                     
                                    </tr>   
                                    <tr>
                                        <td data-th="번호">1</td>
                                        <td data-th="구분">부교재</td>
                                        <td data-th="교재명">생활 화학 개론</td>
                                        <td data-th="ISBN">9788962184822</td>   
                                        <td data-th="저자">Stieven S. Zumdahl</td>     
                                        <td data-th="출판사">CENGAGE</td>                                     
                                    </tr>                                
                                </tbody>
                            </table>
                        </div>                    
                        <div class="file-wrap">                              
                            <ul class="add_file">
                                <li>
                                    <div class="tit_area">
                                        <span class="tit">강의노트 :</span>                
                                        <a href="#" class="file_down">                                       
                                            <span class="text">강의노트.zip</span>
                                            <span class="fileSize">(6KB)</span>
                                        </a>  
                                    </div>                  
                                    <span class="link">
                                        <button class="btn s_basic down">다운로드</button>                                         
                                    </span>
                                </li>
                                <li>
                                    <div class="tit_area">
                                        <span class="tit">음성파일 :</span>
                                        <a href="#" class="file_down">                                       
                                            <span class="text">음성파일125.zip</span>
                                            <span class="fileSize">(200KB)</span>
                                        </a>    
                                    </div>                                                               
                                    <span class="link">
                                        <button class="btn s_basic down">다운로드</button>                                         
                                    </span>
                                </li>
                            </ul>
                        </div>
                        <div class="msg-box basic">                                
                            <ul class="list-asterisk">
                                <li>주교재 선정된 경우나 과목 특성에 따라 강의노트가 제공되지 않을 수 있습니다.</li>
                                <li>과목의 특성에 따라 제공여부가 변경/취소 혹은 일부 차시만 제공될 수 있습니다.</li>                                    
                            </ul>                                                           
                        </div>
                        
                        <h4 class="sub-title">평가방법</h4>                         
                        <div class="table_list">                       
                            <ul class="list">
                                <li class="head"><label>평가방법</label></li>
                                <li>상대 평가 : 학업성과를 다른 학생과 비교하여 상대적 위치를 평가하는 방식</li>                           
                            </ul>                                             
                        </div>

                        <h4 class="sub-title">평가비율</h4>                         
                        <div class="table-wrap">
                            <table class="table-type1">
                                <colgroup>                            
                                    <col style="">
                                    <col style="width:10%">
                                    <col style="width:10%">
                                    <col style="width:10%">
                                    <col style="width:10%">
                                    <col style="width:10%">
                                    <col style="width:10%">
                                    <col style="width:10%">
                                    <col style="width:10%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>평가항목</th>
                                        <th>중간고사</th>
                                        <th>기말고사</th>
                                        <th>출석</th>   
                                        <th>과제</th>
                                        <th>토론</th> 
                                        <th>퀴즈</th>  
                                        <th>설문</th>                                 
                                        <th>세미나</th>  
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <th data-th="평가항목">비율 (%)</th>
                                        <td data-th="중간고사">25</td>
                                        <td data-th="기말고사">25</td> 
                                        <td data-th="출석">15</td>   
                                        <td data-th="과제">10</td>                                    
                                        <td data-th="토론">10</td>   
                                        <td data-th="퀴즈">10</td>   
                                        <td data-th="설문">5</td>   
                                        <td data-th="세미나">-</td>   
                                    </tr> 
                                    <tr>
                                        <th data-th="평가항목">성적공개여부</th>
                                        <td data-th="중간고사">공개</td>
                                        <td data-th="기말고사">공개</td> 
                                        <td data-th="출석">비공개</td>   
                                        <td data-th="과제">공개</td>                                    
                                        <td data-th="토론">공개</td>   
                                        <td data-th="퀴즈">공개</td>   
                                        <td data-th="설문">공개</td>   
                                        <td data-th="세미나">-</td>   
                                    </tr>                                                                   
                                </tbody>
                            </table>
                        </div>  
                        <div class="msg-box basic">                                
                            <ul class="list-asterisk">
                                <li>출석 : 출석 마감일까지 중간/기말고사를 제외하고 70%이상 수강해야 하며, 70%미만일 경우 F학점(0점) 처리됩니다.</li>
                                <li>정기시험 (중간/기말)에 모두 미응시 경우 학점(0점) 처리됩니다.</li>                                    
                            </ul>                                                           
                        </div>

                        <h4 class="sub-title">주차별 강의내용</h4>                       
                        <div class="table-wrap">
                            <table class="table-type1">
                                <colgroup>      
                                    <col style="width:10%">                      
                                    <col style="">                                
                                    <col style="width:15%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>주차</th>
                                        <th>강의 내용</th>
                                        <th>담당교수</th>                                    
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <th data-th="주차">1</th>
                                        <td data-th="강의내용" class="t_left">일반화학 개요</td>
                                        <td data-th="담당교수">홍길동</td> 
                                    </tr> 
                                    <tr>
                                        <th data-th="주차">2</th>
                                        <td data-th="강의내용" class="t_left">원소, 원자 및 이온</td>
                                        <td data-th="담당교수">홍길동</td> 
                                    </tr> 
                                                                                                
                                </tbody>
                            </table>
                        </div> 
                        <div class="msg-box basic">                                
                            <ul class="list-asterisk">
                                <li>강의 내용은 사정에 따라 변경될 수 있습니다.</li>                                                      
                            </ul>                                                           
                        </div> 

                        <h4 class="sub-title">장애인/고령자 지원</h4>                            
                        <div class="table-wrap">
                            <table class="table-type1">
                                <colgroup>                                                          
                                                        
                                    <col style="width:20%">
                                    <col style="width:20%">
                                    <col style="width:20%">
                                    <col style="width:20%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th colspan="4">콘텐츠 내
                                        학습지원 기능
                                        </th>
                                    </tr>
                                    <tr>
                                    
                                        <th>플레이어 단축키</th>
                                        <th>스크립트</th>
                                        <th>자막</th>
                                        <th>재생속도 조절</th>                                    
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="플레이어 단축키">제공</td>
                                        <td data-th="스크립트">제공</td> 
                                        <td data-th="자막">제공</td> 
                                        <td data-th="재생속도 조절">제공</td> 
                                    </tr>                                                                                                                               
                                </tbody>
                            </table>
                        </div>
                        <div class="msg-box basic">                                
                            <ul class="list-asterisk">
                                <li>개발 방식에 따라 일부 주차 혹은 페이지는 제공되지 않을 수 있습니다.</li> 
                                <li>미디어 플레이어 단축키</li>                                                     
                            </ul> 
                            <ul class="list-bullet">
                                <li>미디어 일시정지/재생 : Space Bar</li> 
                                <li>재생 속도 : Z (1배속), X (느리게), C (빠르게)</li> 
                                <li>볼륨 : 위쪽 방향키 (크게), 아래쪽 방향키 (작게)</li> 
                                <li>이동 : 왼쪽 방향키 (10초 전), 오른쪽 방향키 (10초 후)</li>    
                                <li>전체 화면 : F</li>                                                 
                            </ul>                                                           
                        </div> 
                        <div class="table_list">                       
                            <ul class="list">
                                <li class="head"><label>시험 지원</label></li>
                                <li>온라인 시험 시간 연장 : 단, 담당교수의 운영방침에 따라 부여되지 않을 수 있습니다.</li>                           
                            </ul>                                             
                        </div>

                        <div class="btns">
                            <button type="button" class="btn type1">수정</button>
                            <button type="button" class="btn type2">목록</button>
                        </div>                                                                   
                        

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

