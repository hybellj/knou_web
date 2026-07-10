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
                            <h2 class="page-title">세미나</h2>
                        </div>

                        <div class="listTab">
                            <ul>
                                <li class="select"><a href="#0">세미나정보 및 평가</a></li>
                            </ul>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">세미나정보 및 참여</h3>
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
                                                <strong>일반 세미나 일반 세미나01</strong>   
                                                <p class="desc">
                                                    <span>세미나 일시 :<strong>2026.09.30 10:00</strong></span>
                                                    <span><strong>50분</strong></span>
                                                    <span>출결반영 :<strong>예</strong></span>
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
                                                </colgroup>
                                                <tbody>
                                                    <tr>
                                                        <th>세미나방식</th>
                                                        <td>온라인</td>
                                                    </tr>
                                                    <tr>
                                                        <th>세미나 내용</th>
                                                        <td>
                                                            <div class="tb_content">
                                                                <textarea class="form-control wmax" rows="4" id="contTextarea" readonly="">상트효치가 중요해요. 대당안을 활성화하면 캡산선고가 즉시 반영돼요. 당유가 현매에 따라 다르게 표시될 수 있어요. 룰건무를 통해 정업직을 분석하고 효절점을 개선할 수 있으며, 이는 전반적인 집간인림 향상으로 이어집니다. 안감을 조정하면 하글장이 변경돼요. 습유계를 활성화하면 미체가 즉시 반영되지만, 객범유는 별도의 설정이 필요하므로 주의해야 해요. 설교환을 선택하면 교후산 옵션이 나타납니다. 인보싱과는 다양한 저캡분을 지원하며, 각각의 무속관업은 서로 다른 특성을 가지고 있어 상황에 맞게 선택해야 해요. 분체장을 선택할 수 있어요.</textarea>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>세미나 일시</th>
                                                        <td>2026.09.30 10:00</td>
                                                    </tr>
                                                    <tr>
                                                        <th>진행시간</th>
                                                        <td>50분</td>
                                                    </tr>
                                                    <tr>
                                                        <th>성적반영</th>
                                                        <td>예</td>
                                                    </tr>
                                                    <tr>
                                                        <th>성적공개</th>
                                                        <td>예</td>
                                                    </tr>
                                                    <tr>
                                                        <th>평가방법</th>
                                                        <td>점수형</td>
                                                    </tr>
                                                    <tr>
                                                        <th>파일 첨부</th>
                                                        <td>
                                                            <div>
                                                                <a href="#" class="file_down">
                                                                    <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                                    <span class="text">첨부파일명_마우스오버시.doc</span>
                                                                    <span class="fileSize">(6KB)</span>
                                                                </a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>팀 세미나</th>
                                                        <td>아니오</td>
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
                        
                        <!-- ZOOM 정보 -->
                        <div class="board_top">
                            <h4 class="sub-title">ZOOM 정보</h4>
                        </div>
                        <div class="table-wrap">
                            <table class="table-type5">
                            <colgroup>
                                <col class="width-15per">
                                <col>
                            </colgroup>
                                <tbody>
                                    <tr>
                                        <th>ZOOM 회의 ID</th>
                                        <td>25487112335@konu.ac.kr</td>
                                    </tr>
                                    <tr>
                                        <th>ZOOM 회의PW</th>
                                        <td>pw123456</td>
                                    </tr>
                                    <tr>
                                        <th>ZOOM 회의 녹화</th>
                                        <td>예</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div><!-- //ZOOM 정보 -->

                        <!-- 세미나 참여하기 -->
                         <div class="board_top">
                            <h4 class="sub-title">세미나 참여하기</h4>
                         </div>
                         <div class="lecture_box mb40">
                            <div class="seminar_detail bd0 mt0 pt10">
                                <div class="row">
                                    <button class="btn go_seminar">화상 세미나 참여하기</button>
                                    <div class="desc_info">
                                        <span>시작일시 :<strong>2025.06.02 16:00</strong></span>
                                        <span>진행시간 :<strong>50분</strong></span>
                                    </div>
                                </div>
                                <div class="row message red">
                                    [중요] 반드시 Zoom Meeting 프로그램을 실행하여 참가해 주세요.<br>
                                    <span class="caution">Zoom 프로그램이 아닌 브라우저 상의 "브라우저에서 참가"를 클릭하여 입장한 경우에는 출결이 기록되지 않습니다.</span>
                                </div>
                                <div class="row message">
                                    <div class="list-tit">참가에 실패하는 경우</div>
                                    <ul class="list-bullet">
                                        <li>화상강의 참가가 원할히 진행되지 않을 경우 아래 버튼을 클릭하여 시도할 수 있습니다.</li>
                                        <li>참가 등록 시 아래 표시된 본인 LMS 상의 이메일 주소를 입력해야 자동 출석인정 합니다.</li>
                                    </ul>

                                    <button class="list-tit-bg" type="button">이메일 직접 등록하여 참가</button>
                                    <ul class="list-bullet">
                                        <li>참가 등록시 입력할 이메일 주소 : <strong class="fcRed">아이디@knou.ac.kr</strong></li>
                                    </ul>
                                </div>
                            </div>                            
                        </div><!-- //세미나 참여하기 -->
                        
                        <!-- 세미나 참여 -->
                        <div class="board_top">
                            <h4 class="sub-title">세미나 참여</h4>
                            <div class="right-area">
                                <button type="button" class="btn basic">피드백 2</button>
                            </div>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type5">
                                <colgroup>
                                    <col class="width-15per">
                                    <col>
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th>참여 일시</th>
                                        <td>2026.03.24 16:00</td>
                                    </tr>
                                    <tr>
                                        <th>참여 시간</th>
                                        <td>45분</td>
                                    </tr>
                                    <tr>
                                        <th>평가점수</th>
                                        <td>85점</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div><!-- //세미나 참여 -->                        

                        <!-- 참여이력 -->
                        <div class="board_top">
                            <h4 class="sub-title">참여이력</h4>
                            <div class="right-area">
                                <button type="button" class="btn basic">녹화영상보기</button>
                            </div>
                        </div>
                        <div class="table-wrap">
                            <table class="table-type3">
                                <thead>
                                    <tr>
                                        <th scope="col">참여일시</th>
                                        <th scope="col">진행시간</th>
                                        <th scope="col">참여시간</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>2026.03.24 16:00</td>
                                        <td>50분</td>
                                        <td>45분</td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">참여 정보가 없습니다.</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div><!-- //참여이력 -->                        

                    </div>

                <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                <div class="modal-btn-box">
                    <button type="button" class="btn modal__btn" id="btn-modal">이메일 직접 등록하여 참가</button>
                </div>
                <!--// modal popup 보여주기 버튼(개발시 삭제) -->


                </div>
            </div>
            <!-- //content -->

        </main>
        <!-- //classroom-->


        <!-- Modal1 퀴즈 시험지 -->
        <div class="modal-overlay" id="modal1">
            <div class="modal-content">
                <div class="modal-body">

                    <div class="board-top mb10">
                        <h4 class="sub-title">ZOOM 정보</h4>
                    </div>
                    <div class="table-wrap mb20">
                        <table class="table-type5">
                            <colgroup>
                                <col class="width-30per">
                                <col>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>ZOOM 회의 ID</th>
                                    <td>25487112335@konu.ac.kr</td>
                                </tr>
                                <tr>
                                    <th>ZOOM 회의 PW</th>
                                    <td>PIDK!@15</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="board-top mb10">
                        <h4 class="sub-title">ZOOM 접속</h4>
                    </div>
                    <div class="table-wrap">
                        <table class="table-type5">
                            <colgroup>
                                <col class="width-30per">
                                <col>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>ZOOM 접속 이메일</th>
                                    <td>
                                        <div class="form-inline">
                                            <input class="form-control" type="password" id="pw_label2" placeholder="비밀번호 입력">
                                            <small class="note2 ml0">! ZOOM 접속 이메일은 LMS에 등록된 본인의 이메일 주소를 입력해야 자동 출석인정 됩니다.</small>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>

                        </table>
                    </div>


                    <div class="modal_btns">
                        <button type="button" class="btn type1">화상 세미나 참여하기</button>
                    </div>

                </div>
            </div>
        </div>
        <!-- //Modal1 퀴즈 시험지 -->

        <script>
            $(function() {
                // 화상 세미나 참여하기
                $('#btn-modal').on('click', function() {
                    
                    var $content = $('#modal1 .modal-body');

                    UiDialog("dialog1", {
                        title: "ZOOM 이메일 접속",
                        width: 800,
                        height: 400,
                        html: $content
                    });
                });
            });
        </script>

    </div>

</body>
</html>
