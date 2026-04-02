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
                    
                    <div class="btn-wrap">
                        <div class="first">
                            <select class="form-select">
                                <option value="2025년 2학기">2025년 2학기</option>
                                <option value="2025년 1학기">2025년 1학기</option>
                            </select>
                            <select class="form-select wide">
                                <option value="">강의실 바로가기</option>
                                <option value="2025년 2학기">2025년 2학기</option>
                                <option value="2025년 1학기">2025년 1학기</option>
                            </select>
                        </div>
                        <div class="sec">
                            <button type="button" class="btn type1"><i class="xi-book-o"></i>교수 매뉴얼</button>
                            <button type="button" class="btn type1"><i class="xi-info-o"></i>학습안내정보</button>
                            <button type="button" class="btn type2"><i class="xi-log-out"></i>강의실나가기</button>
                        </div>
                    </div>
                </div>
                
                <div class="class_sub">                    
                    <!-- 강의실 상단 -->
                    <div class="segment class-area sub">
                        <div class="class_info">
                            <div class="class_tit">
                                <p class="labels">
                                    <label class="label uniA">대학원</label>
                                </p>
                                <h2>데이터베이스의 이해와 활용 1반</h2>
                            </div>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>강의실</li>
                                    <li><span class="current">내강의실</span></li>
                                </ul>
                            </div>                            
                        </div>                        
                    </div>
                    <!-- //강의실 상단 -->

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">교수/튜터/조교정보</h2>
                        </div>
                        <div class="board_top">
                            <h3 class="board-title">담당 교수</h3>
                        </div>
                        <div class="prof-box">
                            <div class="user-wrap">
                                <div class="left_item">
                                    <div class="user-img">
                                        <div class="user-photo">
                                            <!--프로필 사진-->
                                            <img src="/lms_design_sample/webdoc/assets/img/common/photo_user_sample.png" alt="사진">
                                        </div>                                       
                                    </div>  
                                    <div class="user-btn"><button type="button" class="btn type2">정보수정</button></div> 
                                </div>                                               
                                <div class="table_list">                            
                                    <ul class="list">
                                        <li class="head"><label>이름</label></li>
                                        <li>홍길동 교수</li>                             
                                    </ul>
                                    <ul class="list">
                                        <li class="head"><label>이메일</label></li>
                                        <li>k202154774@knou.ac.kr<br>
                                        <small class="note2">! 메일 주소는 공개 여부와 관계없이 공개됩니다.</small>
                                        </li>                                
                                    </ul>                                
                                    <ul class="list">
                                        <li class="head"><label>전화번호</label></li>
                                        <li>(사무실) 02-2365-9854</li>                                
                                    </ul>
                                    <ul class="list">
                                        <li class="head"><label>과목운영자</label></li>
                                        <li>
                                            <select class="form-select" id="selectProf">
                                                <option value="담당교수">담당교수</option>
                                                <option value="공동교수">공동교수</option>                                              
                                            </select>
                                        </li>                                
                                    </ul>  
                                </div>                                                     
                            </div>

                            <div class="user-wrap">
                                <div class="left_item">
                                    <div class="user-img">
                                        <div class="user-photo">
                                            <!--프로필 사진 없을때-->                                            
                                        </div>                                       
                                    </div>  
                                    <div class="user-btn"><button type="button" class="btn type2">정보수정</button></div> 
                                </div>                                             
                                <div class="table_list">                            
                                    <ul class="list">
                                        <li class="head"><label>이름</label></li>
                                        <li>홍길동 교수</li>                             
                                    </ul>
                                    <ul class="list">
                                        <li class="head"><label>이메일</label></li>
                                        <li>k202154774@knou.ac.kr<br>
                                        <small class="note2">! 메일 주소는 공개 여부와 관계없이 공개됩니다.</small>
                                        </li>                                
                                    </ul>                                
                                    <ul class="list">
                                        <li class="head"><label>전화번호</label></li>
                                        <li>(핸드폰) 010-1265-8541</li>                                
                                    </ul>
                                    <ul class="list">
                                        <li class="head"><label>과목운영자</label></li>
                                        <li>
                                            <select class="form-select" id="selectProf">
                                                <option value="공동교수">공동교수</option>                                              
                                            </select>
                                        </li>                                
                                    </ul>  
                                </div>                                                     
                            </div>
                            
                        </div> 
                        

                        <div class="board_top">
                            <h3 class="board-title">튜터/조교</h3>
                        </div>
                        <div class="prof-box">
                            <div class="user-wrap">
                                <div class="left_item">
                                    <div class="user-img">
                                        <div class="user-photo">
                                            <!--프로필 사진-->
                                            <img src="/lms_design_sample/webdoc/assets/img/common/sample.jpg" alt="사진">
                                        </div>                                       
                                    </div>  
                                    <div class="user-btn"><button type="button" class="btn type2">정보수정</button></div> 
                                </div>                                               
                                <div class="table_list">                            
                                    <ul class="list">
                                        <li class="head"><label>이름</label></li>
                                        <li>김튜터</li>                             
                                    </ul>
                                    <ul class="list">
                                        <li class="head"><label>이메일</label></li>
                                        <li>k202154774@knou.ac.kr<br>
                                        <small class="note2">! 메일 주소는 공개 여부와 관계없이 공개됩니다.</small>
                                        </li>                                
                                    </ul>                                
                                    <ul class="list">
                                        <li class="head"><label>전화번호</label></li>
                                        <li>(사무실) 02-2365-9854</li>                                
                                    </ul>
                                    <ul class="list">
                                        <li class="head"><label>과목운영자</label></li>
                                        <li>
                                            <select class="form-select" id="selectProf">
                                                <option value="튜터">튜터</option>                                                                                  
                                            </select>
                                        </li>                                
                                    </ul>  
                                </div>                                                     
                            </div>
                        </div>

                    </div>


                    <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                    <div class="modal-btn-box">
                        <button type="button" class="btn modal__btn" data-modal-open="modal1">교수/튜터/조교 정보수정</button>          
                    </div>
                    <!--// modal popup 보여주기 버튼(개발시 삭제) -->

                </div>
            </div>
            <!-- //content -->


        </main>
        <!-- //classroom-->


        <!-- Modal 1 -->
        <div class="modal-overlay" id="modal1" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content modal-md" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">교수/튜터/조교 정보수정</h2>
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body">  
                    <div class="board_top">
                        <h3 class="board-title">기본 정보 수정</h3>                        
                    </div>                 
                    <div class="user-wrap">
                        <div class="user-img">
                            <div class="user-photo">
                                <!--프로필 사진-->
                                <img src="/lms_design_sample/webdoc/assets/img/common/photo_user_sample.png" alt="사진">
                            </div>
                        </div>
                                             
                        <!--table-type5-->
                        <div class="table-wrap">
                            <table class="table-type5">
                                <colgroup>
                                    <col class="width-25per" />
                                    <col class="" />
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th><label for="name_label">이름</label></th>
                                        <td>
                                            <div class="form-row">
                                                <input class="form-control width-100per" type="text" name="name" id="name_label" value="홍길동">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="inputEmail">이메일</label></th>
                                        <td>
                                            <div class="form-row">
                                                <input class="form-control width-100per" type="text" name="name" id="inputEmail" value="k202154774@knou.ac.kr">
                                            </div>
                                            <small class="note2">! 메일 주소는 공개 여부와 관계없이 공개됩니다.</small>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="telLabel">전화번호</label></th>
                                        <td>
                                            <div class="form-row">
                                                <input class="form-control width-100per" type="text" name="name" id="telLabel" value="02-2365-9854">
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                       
                    </div>
                    
                    <div class="modal_btns">
                        <button type="button" class="btn type1">저장</button>
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="<%=request.getContextPath()%>/webdoc/assets/js/modal.js" defer></script>

    </div>

</body>
</html>

