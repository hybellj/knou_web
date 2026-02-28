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
                            <h2 class="page-title">프로필</h2>
                            <div class="navi_bar">                                
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li><span class="current">프로필</span></li>                                 
                                </ul>                                                                         
                            </div>
                             
                        </div>

                        <div class="user-wrap">

                            <div class="user-img">                               
                                <div class="user-photo">
                                    <!--프로필 사진-->                                                                        
                                    <img src="/webdoc/dm_assets/img/common/photo_user_sample.png" alt="사진">                                    
                                </div>                               
                            </div>
                        
                            <!--table-type5-->
                            <div class="table-wrap">
                                <table class="table-type5">
                                    <colgroup>
                                        <col class="width-15per" />
                                        <col class="" />
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                            <th><label for="haksa_label">학사연동</label></th>
                                            <td>
                                                <div class="form-inline">
                                                    <span class="custom-input">
                                                        <input type="radio" name="emailRecv" id="emailRecvY" value="Y" checked="">
                                                        <label for="emailRecvY">YES</label>
                                                    </span>												
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><label for="univ_label" class="req">과정(테넌시)</label></th>
                                            <td>
                                                <div class="form-inline">
                                                    <select class="form-select" id="univ_label" name="univ_label">
                                                        <option value="">과정(테넌시) 선택</option>
                                                        <option value="평생교육">평생교육</option>
                                                    </select>
                                                    <button type="button" class="btn gray1">추가</button>
                                                    <ul class="label_list">
                                                        <li class="addedLabel">
                                                            <label>대학원</label><span class="labelRemove"><i class="xi-close-min"></i></span>                                                                
                                                        </li>
                                                        <li class="addedLabel">
                                                            <label>평생교육</label><span class="labelRemove"><i class="xi-close-min"></i></span>                                                                
                                                        </li>
                                                        <li class="addedLabel">
                                                            <label>학위과정</label><span class="labelRemove"><i class="xi-close-min"></i></span>                                                                
                                                        </li>                                                        
                                                    </ul>
                                                    <script>
                                                        document.addEventListener("DOMContentLoaded", function() {
                                                            const removeButtons = document.querySelectorAll(".labelRemove");

                                                            removeButtons.forEach(function(button) {
                                                                button.addEventListener("click", function() {
                                                                    const labelItem = button.closest("li");
                                                                    labelItem.remove();
                                                                });
                                                            });
                                                        });
                                                    </script>
                                                </div>   
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><label for="name_label" class="req">이름</label></th>
                                            <td>
                                                <div class="form-row">
                                                    <input class="form-control width-50per" type="text" name="name" id="name_label" value="홍길동">
                                                </div>   
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><label for="id_label">아이디</label></th>
                                            <td>
                                                <div class="form-inline">
                                                    hongs1234
                                                    <small class="note2">! 수정불가</small>
                                                </div>   
                                            </td>
                                        </tr>																
                                        <tr>
                                            <th><label for="pw_label2" class="req">비밀번호</label></th>
                                            <td>
                                                <div class="form-inline">
                                                    <input type="password" id="pw_label2" placeholder="비밀번호 입력" />
                                                    <small class="note2">! 정보변경 비밀번호 확인</small>
                                                </div>       
                                            </td>
                                        </tr>									
                                        <tr>
                                            <th><label for="mobileLabel" class="req">휴대폰 번호</label></th>
                                            <td>
                                                <div class="form-row">
                                                    <!-- 번호 -->    
                                                    <div class="num_input">                                                           
                                                        <select name="" id="mobileLabel" class="compact">
                                                            <option value="010">010</option>
                                                            <option value="011">011</option>
                                                            <option value="016">016</option>
                                                            <option value="017">017</option>
                                                            <option value="018">018</option>
                                                            <option value="019">019</option>
                                                        </select>                                        
                                                        <span class="txt-sort">-</span>
                                                        <input type="text" maxlength="4" class="compact" value="1234" />				
                                                        <span class="txt-sort">-</span>											
                                                        <input type="text" maxlength="4" class="compact" value="1234" />												
                                                    </div>

                                                </div>       
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><label for="사용 이메일" class="req">사용 이메일</label></th>
                                            <td>
                                                <div class="form-inline">
                                                    <span class="custom-input">
                                                        <input type="radio" name="emailUse" id="emailUseA" value="Y" checked="">
                                                        <label for="emailUseA">연계 이메일</label>
                                                    </span>
                                                    <span class="custom-input ml5">
                                                        <input type="radio" name="emailUse" id="emailUseB" value="N">
                                                        <label for="emailUseB">추가 이메일</label>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><label for="inputEmailA">연계 이메일</label></th>
                                            <td>
                                                
                                                <div class="form-inline">
                                                    <input class="form-control mr5" type="text" name="name" value="hongs1234" id="inputEmail1" disabled>
                                                    <span class="mr5">@</span>
                                                    <input class="form-control mr5" type="text" name="name" id="inputEmail2" value="knou.ac.kr" title="이메일 주소 뒷자리" disabled>
                                                </div>
                                            </td>
                                        </tr>
                                        
                                        <tr>
                                            <th><label for="inputEmailB">추가 이메일</label></th>
                                            <td>
                                                <div class="form-inline">
                                                    <input class="form-control mr5" type="text" name="name" value="" id="inputEmail3">
                                                    <span class="mr5">@</span>
                                                    <input class="form-control mr5" type="text" name="name" id="inputEmail4" value=""  title="이메일 주소 뒷자리" placeholder="">
                                                    <select class="form-select" id="selectEmail2">
                                                        <option value="-">선택</option>
                                                        <option value="-">naver.com</option>
                                                        <option value="-">daum.net</option>
                                                    </select>
                                                    <button type="button" class="btn gray1">직접입력</button>
                                                </div>    
                                            </td>
                                        </tr>																																										
                                        <tr>
                                            <th><label for="attchFile">프로필사진</label></th>
                                            <td>

                                                <!--업로드-->
                                                <div id="upload">

                                                    <!--파일업로드-->
                                                    <div id="drop">
                                                        파일을 여기에 끌어다 놓거나, 파일 선택 버튼을 클릭하여 업로드하세요.
                                                        <a id="buttonLink" href="javascript:uploderclick('atchuploader');" class="btn type3">파일 선택</a>
                                                        <input type="file" name="atchuploader" id="atchuploader" multiple="" style="display:none">

                                                        <div id="atchprogress" class="progress" style="display: none;">
                                                            <div class="progress-inner"></div>
                                                        </div>
                                                    </div>
                                                    <!--//파일업로드-->												

                                                    <!--파일 목록-->
                                                    <ul id="atchfiles">
                                                        <li id="attachIdx_1">
                                                            <p>홍길동 프로필 사진.jpg<small>20.86 KB</small></p><span aria-label="삭제" href="#_none"></span>
                                                        </li>													
                                                    </ul>
                                                    <!--//파일 목록-->

                                                </div>
                                                <!--//업로드-->
                                                
                                                <small class="note2 flex margin-top-2">! 프로필 사진 첨부시 기존 프로필 사진은 업데이트 됩니다. </small>
                                                <div class="checkbox_type margin-top-4">
                                                    <span class="custom-input">
                                                        <input type="checkbox" name="name" id="checkType1">
                                                        <label for="checkType1">현 프로필 사진 삭제 ( 삭제시 기본 이미지로 교체됩니다. )</label>
                                                    </span>
                                                </div>
                                                    
                                                
                                            </td>
                                        </tr>
                                    </tbody>

                                </table>
                            </div>
                            <!--//table-type5-->
                        
                        </div>
                        
                        <div class="btns">
                            <button type="button" class="btn type1">취소</button>
                            <button type="button" class="btn type2">저장</button>
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

