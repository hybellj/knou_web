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

                    <div class="sub-content">
						<div class="page-info">
                            <h2 class="page-title">모달 샘플</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>게시물</li>
                                    <li><span class="current">현재페이지</span></li>
                                </ul>
                            </div>
                        </div>

                        <h4 class="sub-title">모달 사이즈 </h4>
                        <p>
                            <strong>사이즈 비교</strong><br>
                            <div class="table_list">
                                <ul class="list">
                                    <li class="head"><label>small</label></li>
                                    <li>modal-sm  ( 가로 360px )</li>                          
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>기본(default)</label></li>
                                    <li>modal-default ( 가로 500px )</li>                          
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>medium</label></li>
                                    <li>modal-md ( 가로 640px )</li>                          
                                </ul>
                                 <ul class="list">
                                    <li class="head"><label>Large</label></li>
                                    <li>modal-lg ( 가로 840px )</li>                          
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>Extra Large</label></li>
                                    <li>modal-xl ( 가로 1140px )</li>                          
                                </ul> 
                                <ul class="list">
                                    <li class="head"><label>full</label></li>
                                    <li>modal-full ( 가로 90% , 화면에 가득참 )</li>                          
                                </ul>                                
                            </div>

                            <br><br>

                            <strong>사이즈 적용방법</strong><br>
                            div class="modal-content"  사이즈 클래스명을 아래 파란글씨처럼 추가하면 됨<br>
                            div class="modal-content <span class="fcBlue">modal-md</span>"  (예: modal-md )
                        </p>

                        <br><br><br>
                       
                        <!-- modal popup 보여주기 버튼 -->
                        <div class="modal-btn-box">
                            <button type="button" class="btn modal__btn" data-modal-open="modal1">모달 사이즈 > 기본(default)</button>
                            <button type="button" class="btn modal__btn" data-modal-open="modal2">모달 > small</button>
                            <button type="button" class="btn modal__btn" data-modal-open="modal3">모달 > medium</button>
                            <button type="button" class="btn modal__btn" data-modal-open="modal4">모달 > Large</button>
                            <button type="button" class="btn modal__btn" data-modal-open="modal5">모달 > Extra Large</button>
                            <button type="button" class="btn modal__btn" data-modal-open="modal6">모달 > full</button>
                        </div>   
                        
                        

                        <br><br><br>

                        

                       


                    </div>


                </div>
            </div>
            <!-- //content -->

            <!-- Modal 1 -->
            <div class="modal-overlay" id="modal1" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" > 
                <div class="modal-content" tabindex="-1"> 
                    <div class="modal-header"> 
                        <h2 id="modal1Title">모달 사이즈</h2> 
                        <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button> 
                    </div> 
                    <div class="modal-body"> 
                        사이즈 기본 500px <br><br>
                        모달 내용이 나옵니다.

                        <div class="modal_btns">
                            <button type="button" class="btn type1">수정</button>
                            <button type="button" class="btn type2">닫기</button>
                        </div>
                    </div> 
                </div> 
            </div>

            <!-- Modal 2 -->
            <div class="modal-overlay" id="modal2" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal2Title" > 
                <div class="modal-content modal-sm" tabindex="-1"> 
                    <div class="modal-header"> 
                        <h2 id="modal2Title">모달 사이즈</h2> 
                        <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button> 
                    </div> 
                    <div class="modal-body"> 
                        small 360px <br><br>
                        <p>내용이 길어질 경우 자동으로 스크롤이 생깁니다.</p> 
                        <p>스크롤 테스트용 텍스트</p> 
                        <p>스크롤 테스트용 텍스트</p> 
                        <p>스크롤 테스트용 텍스트</p> 
                        <p>스크롤 테스트용 텍스트</p> 
                        <p>스크롤 테스트용 텍스트</p> 
                        <p>스크롤 테스트용 텍스트</p> 
                        <p>스크롤 테스트용 텍스트</p> 
                        <p>스크롤 테스트용 텍스트</p> 
                        <p>스크롤 테스트용 텍스트</p> 

                        <div class="modal_btns">
                            <button type="button" class="btn type1">수정</button>
                            <button type="button" class="btn type2">닫기</button>
                        </div>
                    </div> 
                </div> 
            </div>

            <!-- Modal 3 -->
            <div class="modal-overlay" id="modal3" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" > 
                <div class="modal-content modal-md" tabindex="-1"> 
                    <div class="modal-header"> 
                        <h2 id="modal1Title">모달 사이즈</h2> 
                        <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button> 
                    </div> 
                    <div class="modal-body"> 
                        medium 640px <br><br>
                        모달 내용이 나옵니다.

                        <div class="modal_btns">
                            <button type="button" class="btn type1">수정</button>
                            <button type="button" class="btn type2">닫기</button>
                        </div>
                    </div> 
                </div> 
            </div>

            <!-- Modal 4 -->
            <div class="modal-overlay" id="modal4" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" > 
                <div class="modal-content modal-lg" tabindex="-1"> 
                    <div class="modal-header"> 
                        <h2 id="modal1Title">모달 사이즈</h2> 
                        <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button> 
                    </div> 
                    <div class="modal-body"> 
                        Large 840px <br><br>
                        모달 내용이 나옵니다.

                        <div class="modal_btns">
                            <button type="button" class="btn type1">수정</button>
                            <button type="button" class="btn type2">닫기</button>
                        </div>
                    </div> 
                </div> 
            </div>

            <!-- Modal 5 -->
            <div class="modal-overlay" id="modal5" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" > 
                <div class="modal-content modal-xl" tabindex="-1"> 
                    <div class="modal-header"> 
                        <h2 id="modal1Title">모달 사이즈</h2> 
                        <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button> 
                    </div> 
                    <div class="modal-body"> 
                        Extra Large 1140px <br><br>
                        모달 내용이 나옵니다.

                        <div class="modal_btns">
                            <button type="button" class="btn type1">수정</button>
                            <button type="button" class="btn type2">닫기</button>
                        </div>
                    </div> 
                </div> 
            </div>

            <!-- Modal 6 -->
            <div class="modal-overlay" id="modal6" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" > 
                <div class="modal-content modal-full" tabindex="-1"> 
                    <div class="modal-header"> 
                        <h2 id="modal1Title">모달 사이즈</h2> 
                        <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button> 
                    </div> 
                    <div class="modal-body"> 
                        Full 가득참<br><br>
                        모달 내용이 나옵니다.

                        <div class="modal_btns">
                            <button type="button" class="btn type1">수정</button>
                            <button type="button" class="btn type2">닫기</button>
                        </div>
                    </div> 
                </div> 
            </div>

            <script src="<%=request.getContextPath()%>/webdoc/assets/js/modal.js" defer></script>


            <!-- common footer -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
            <!-- //common footer -->

        </main>
        <!-- //dashboard-->

    </div>

</body>
</html>

