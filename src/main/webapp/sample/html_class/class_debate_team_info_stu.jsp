<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">        
        <jsp:param name="module" value="editor,fileuploader"/>
        <jsp:param name="module" value="chart"/>
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="style" value="dashboard"/>
	</jsp:include>

    <script src="../../webdoc/uilib/chart/chart4.min.js"></script>
    <script src="../../webdoc/uilib/chart/chart-utils.min.js"></script>
    <script src="../../webdoc/uilib/chart/chartjs-plugin-datalabels.min.js"></script>
</head>

<body class="class colorA "><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="../common/class_header.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
        <!-- //common header -->

        <!-- classroom -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="../common/class_gnb_prof.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
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
                                    <li><span class="current">토론</span></li>
                                </ul>
                            </div>                            
                        </div>                        
                    </div>
                    <!-- //강의실 상단 -->

                    <div class="sub-content">
                        
                        <div class="page-info">
                            <h2 class="page-title">토론</h2>
                        </div>

                        <div class="listTab">
                            <ul>
                                <li class="select"><a href="#">토론정보 및 참여</a></li>
                                <li><a href="#0">토론방</a></li>
                            </ul>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">토론정보 및 참여</h3>
                            <div class="right-area">
                                <button type="button" class="btn type2 big">목록</button>  
                            </div>
                        </div>

                        <!--accordion-->
                        <div class="elements_wrap">
                            <ul class="accordion">
                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap">                                      
                                        <a class="title" href="#">                                                                                            
                                            <div class="lecture_tit">                                                   
                                                <strong>토론 제목입니다.</strong>   
                                                <p class="desc">
                                                    <span>참여기간 :<strong>2026.09.30 10:00 ~ 2026.10.09 22:00</strong></span>
                                                    <span>성적반영 :<strong>예</strong></span>
                                                    <span>성적공개 :<strong>아니오</strong></span>
                                                </p>                                                 
                                            </div>                                                                                        
                                            <i class="arrow xi-angle-down"></i>                                           
                                        </a>                                            
                                    </div>
                                    <div class="cont">
                                        <!-- ul.table-list > table-type5 으로 변경(2026-04-29) -->
                                        <table class="table-type5">
                                            <form id="form1" name="form1">
                                            <colgroup>
                                                <col width="15%">
                                                <col>
                                                <col width="15%">
                                                <col>
                                            </colgroup>
                                            <tbody>
                                                <tr>
                                                    <th>토론내용</th>
                                                    <td colspan="3">
                                                        <div class="tb_content">
                                                            <textarea class="form-control wmax" rows="4" id="contTextarea" readonly="">토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다.
                                                            </textarea>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>참여기간</th>
                                                    <td colspan="3">2026.09.30 10:00 ~ 2026.10.09 22:00</td>
                                                </tr>
                                                <tr>
                                                    <th>성적반영</th>
                                                    <td>예</td>
                                                    <th>성적반영비율</th>
                                                    <td>25%</td>
                                                </tr>
                                                <tr>
                                                    <th>성적공개</th>
                                                    <td colspan="3">참여형<small class="note ml10">(토론 참여 : 100점, 미참여 : 0점 자동배점)</small></td>
                                                </tr>
                                                <tr>
                                                    <th>파일 첨부</th>
                                                    <td colspan="3">
                                                        <div>
                                                            <a href="#" class="file_down">
                                                                <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                                <span class="text">첨부파일명마우스오버 시.doc</span>
                                                                <span class="fileSize">(6KB)</span>
                                                            </a>
                                                        </div>
                                                        <div>
                                                            <a href="#" class="file_down">
                                                                <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                                <span class="text">154873973477000.jpg</span>
                                                                <span class="fileSize">(6KB)</span>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>팀토론</th>
                                                    <td colspan="3">예<br>학습그룹 : 토론 학습그룹 002<br>학습그룹별 토론 설정 : 사용
                                                        <div class="table-wrap mt10">
                                                            <table class="table-type5 in_table">
                                                                <colgroup>
                                                                    <col class="width-5per">
                                                                    <col class="width-15per">
                                                                    <col>
                                                                </colgroup>
                                                                <tbody>                                                            
                                                                    <tr>
                                                                        <th rowspan="4" class="group-header"><label for="viewOption">1팀</label></th>
                                                                        <th><label>학습그룹 구성원</label></th>
                                                                        <td>
                                                                            홍팀장1 외 11명
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th><label for="sub_topic">부주제</label></th>
                                                                        <td>부주제 제목입니다.</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th><label for="contTextarea">내용</label></th>
                                                                        <td>
                                                                            <label class="width-100per"><textarea rows="4" class="form-control resize-none">내용입니다.

                                                                            </textarea></label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th><label for="attchFile">첨부파일</label></th>
                                                                        <td>
                                                                            <div class="add_file_list">                              
                                                                                <ul class="add_file">
                                                                                    <li>
                                                                                        <a href="#" class="file_down">
                                                                                            <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                                                            <span class="text">154873973477000.jpg</span>
                                                                                            <span class="fileSize">(6KB)</span>
                                                                                        </a>                                        
                                                                                    </li>
                                                                                </ul>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th rowspan="4" class="group-header"><label for="viewOption">2팀</label></th>
                                                                        <th><label>학습그룹 구성원</label></th>
                                                                        <td>
                                                                            홍팀장1 외 11명
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th><label for="sub_topic">부주제</label></th>
                                                                        <td>
                                                                            <div class="form-row">
                                                                                <input class="form-control width-100per" type="text" name="name" id="sub_topic" value="" placeholder="주제 입력" autocomplete="off">
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th><label for="contTextarea">내용</label></th>
                                                                        <td>
                                                                            <label class="width-100per"><textarea rows="4" class="form-control resize-none"></textarea></label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th><label for="attchFile">첨부파일</label></th>
                                                                        <td>
                                                                            첨부파일
                                                                        </td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>참여글 보기 옵션</th>
                                                    <td colspan="3">사용 안함</td>
                                                </tr>
                                                <tr>
                                                    <th>댓글 답변요청</th>
                                                    <td colspan="3">아니오</td>
                                                </tr>
                                                <tr>
                                                    <th>찬반 토론으로 설정</th>
                                                    <td colspan="3">
                                                        예<br>
                                                        찬반 비율 공개 : 예<br>
                                                        작성자 공개 : 예<br>
                                                        의견 글 복수 등록 : 아니오<br>
                                                        찬반 의견 변경가능 : 아니오
                                                    </td>
                                                </tr>

                                            </tbody>
                                            </form>
                                        </table>
                                        <!-- //ul.table-list > table-type5 으로 변경(2026-04-29) -->
                                    </div>
                                </li>   
                            </ul>
                        </div>
                        <!--//accordion-->
                        
                        <div class="board_top">
                            <h4 class="sub-title">토론 참여</h4>
                            <div class="right-area">
                                <button type="button" class="btn basic">피드백 0</button>
                            </div>
                        </div>

                        <div class="msg-box">
                            <p class="txt"><strong>안내 : </strong>토론 참여 전입니다. 토론 참여하시기 바랍니다.</p>
                        </div>                        

                        <div class="table-wrap">
                            <table class="table-type5">
                                <colgroup>
                                    <col class="width-10per">
                                    <col>
                                <tbody>
                                    <tr>
                                        <th>참여 일시</th>
                                        <td>2026.03.24 16:00</td>
                                    </tr>
                                    <tr>
                                        <th>참여 현황</th>
                                        <td>토론 글 : 5<br>댓글 : 12</td>
                                    </tr>
                                    <tr>
                                        <th>평가 점수</th>
                                        <td>82점</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="btns">
                            <button type="button" class="btn type1">토론방</button>
                        </div>


                    </div>
                </div>
            </div>
            <!-- //content -->

        </main>
        <!-- //classroom-->
        
    </div>

</body>
</html>

