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

<body class="class"><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">

    <!-- EZ-Grader 마크업 템플릿 -->
    <script type="text/template" id="ezGraderMarkup">
        <div class="modal_EzGarder_area" style="width: 100%; height: 100%; border-radius: 0;">
            <h1 class="EzGarder_title">
                EZ-Grader 쉽고 빠르게 평가
                <button type="button" class="btn_close" onclick="closeDialog6()" aria-label="닫기"><i class="xi-close"></i></button>
            </h1>
            <div class="EzCarder_content">
                <div class="left_list">
                    <div class="left_select_box mb10">
                        <select class="form-select">
                            <option value="">정렬선택</option>
                            <option value="학번순">학번순</option>
                            <option value="이름순">이름순</option>
                            <option value="제출자순">제출자순</option>
                        </select>
                        <select class="form-select">
                            <option value="">필터선택</option>
                            <option value="전체">전체</option>
                            <option value="참여">참여</option>
                            <option value="미참여">미참여</option>
                            <option value="팀장">팀장</option>
                            <option value="팀원">팀원</option>
                        </select>        
                    </div>
                    <div class="stu_list_area">
                        <div class="stu_list">
                            <ul>
                                <li>
                                    <div class="icon_box">
                                        <span><i class="xi-check icon"></i></span>
                                    </div>
                                    <span>소프트웨어학부</span>
                                    <p>학*자1</p>
                                </li>
                                <li class="active">
                                    <div class="icon_box">
                                        <span><i class="xi-check icon"></i></span>
                                    </div>
                                    <span>소프트웨어학부</span>
                                    <p>학*자1</p>
                                </li>
                            </ul>
                        </div>
                        <div class="stu_list">
                            <p class="temaTitle">팀 이름1</p>
                            <ul>
                                <li>
                                    <div class="icon_box">
                                        <span><i class="xi-check icon"></i></span>
                                    </div>
                                    <span>소프트웨어학부</span>
                                    <p>학*자1</p>
                                </li>
                                <li>
                                    <div class="icon_box">
                                        <span><i class="xi-check icon"></i></span>
                                    </div>
                                    <span>소프트웨어학부</span>
                                    <p>학*자2</p>
                                </li>
                                <li>
                                    <div class="icon_box">
                                        <span><i class="xi-check icon"></i></span>
                                    </div>
                                    <span>소프트웨어학부</span>
                                    <p>학*자3</p>
                                </li>

                            </ul>
                        </div>
                    </div>
                </div>

                <div class="center_com width-100per">
                    <!-- 찬성 -->
                    <!-- <button type="button" class="btn width-100per primary"><span class="fcWhite">찬성</span></button> -->
                    <!-- //찬성 -->

                    <!-- 반대 -->
                    <!-- <button type="button" class="btn width-100per bcRed"><span class="fcWhite">반대</span></button> -->
                    <!-- //반대 -->

                    <!-- 댓글 -->
                    <div class="Comment mt10">

                        <!-- 본인 참여글 -->
                            <div class="comment_list">
                                <ul>
                                    <li>
                                        <div class="item">
                                            <div class="cmt_info">
                                                <div class="user">
                                                    <span class="user_img"></span>
                                                </div>
                                                <div>
                                                    <strong class="name">학*자1(901258745)</strong>
                                                    <span class="date">2026.05.02 05:32</span>
                                                </div>
                                            </div>                                                
                                            <span class="comment">최근 우리사회의 가장 큰 화두중 하나는 4차 산업혁명과 일자리문제입니다.최근 우리사회의 가장 큰 화두중 하나는 4차 산업혁명과 일자리문제입니다.최근 우리사회의 가장 큰 화두중 하나는 4차 산업혁명과 일자리문제입니다.</span>                                        
                                            <div class="cmt_detail">
                                                <div>
                                                    <span class="textNum"><i class="xi-paper-o"></i>45</span>
                                                    <span class="comNum"><i class="xi-speech-o"></i>2</span>
                                                    <span class="fileName"><a href="#" download>홍길동 프로필 사진.jpg</a></span>
                                                </div>
                                                <button class="toggle_commentlist mlAuto">4개의 댓글이 있습니다.</button>
                                            </div>
                                        </div>
                                        
                                        <ul class="re_comment_ul dpNone">
                                            <li class="re_comment">
                                                <div class="item">
                                                    <div class="cmt_info">
                                                        <div class="user">
                                                            <div class="user_img">
                                                                <img src="<%=request.getContextPath()%>/webdoc/assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진">
                                                            </div>
                                                        </div>
                                                        <div>
                                                            <strong class="name">나방송</strong>
                                                            <span class="date">2026.05.02 05:32</span>
                                                        </div>
                                                    </div>
                                                    <span class="comment">네. 좋은 의견 감사합니다.</span>
                                                    <div class="cmt_detail">
                                                        <div>
                                                            <span class="textNum"><i class="xi-paper-o"></i>15</span>
                                                        </div>
                                                    </div>
                                                </div>                                                    
                                            </li>
                                            <li class="re_comment">
                                                <div class="item">
                                                    <div class="cmt_info">
                                                        <div class="user">
                                                            <div class="user_img">
                                                            </div>
                                                        </div>
                                                        <div>
                                                            <strong class="name">학*자1</strong>
                                                            <span class="date">2026.05.02 05:32</span>
                                                        </div>
                                                    </div>
                                                    <span class="comment">네. 좋은 의견 감사합니다.</span>
                                                    <div class="cmt_detail">
                                                        <div>
                                                            <span class="textNum"><i class="xi-paper-o"></i>15</span>
                                                        </div>
                                                    </div>
                                                </div>                                                    
                                            </li>
                                            <li class="re_comment">
                                                <div class="item">
                                                    <div class="cmt_info">
                                                        <div class="user">
                                                            <span class="user_img"></span>
                                                        </div>                                                                                                               
                                                        <div>
                                                            <strong class="name">홍길동</strong>
                                                            <span class="date">2026.05.02 05:32</span>
                                                        </div>
                                                    </div>                                                        
                                                    <span class="comment">동의합니다.</span>
                                                    <div class="cmt_detail">
                                                        <div>
                                                            <span class="textNum"><i class="xi-paper-o"></i>6</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </li>
                                            <li class="re_comment">
                                                <div class="item">
                                                    <div class="cmt_info">
                                                        <div class="user">
                                                            <div class="user_img">
                                                            </div>
                                                        </div>
                                                        <div>
                                                            <strong class="name">학*자1</strong>
                                                            <span class="date">2026.05.02 05:32</span>
                                                        </div>
                                                    </div>
                                                    <span class="comment">네. 좋은 의견 감사합니다.</span>
                                                    <div class="cmt_detail">
                                                        <div>
                                                            <span class="textNum"><i class="xi-paper-o"></i>15</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </li>
                                        </ul>
                                    </li>
                                </ul>
                            </div>
                            
                            <div class="comment_list">
                                <ul>
                                    <li>
                                        <div class="item">
                                            <div class="cmt_info">
                                                <div class="user">
                                                    <span class="user_img"></span>
                                                </div>
                                                <div>
                                                    <strong class="name">학*자1(901258745)</strong>
                                                    <span class="date">2026.05.02 05:32</span>
                                                </div>
                                            </div>                                                
                                            <span class="comment">최근 우리사회의 가장 큰 화두중 하나는 4차 산업혁명과 일자리문제입니다.최근 우리사회의 가장 큰 화두중 하나는 4차 산업혁명과 일자리문제입니다.최근 우리사회의 가장 큰 화두중 하나는 4차 산업혁명과 일자리문제입니다.</span>                                        
                                            <div class="cmt_detail">
                                                <div>
                                                    <span class="textNum"><i class="xi-paper-o"></i>45</span>
                                                    <span class="comNum"><i class="xi-speech-o"></i>1</span>
                                                    <span class="fileName"><a href="#" download>홍길동 프로필 사진.jpg</a></span>
                                                </div>
                                                <button class="toggle_commentlist mlAuto">3개의 댓글이 있습니다.</button>
                                            </div>
                                        </div>
                                        
                                        <ul class="re_comment_ul dpNone">
                                            <li class="re_comment">
                                                <div class="item">
                                                    <div class="cmt_info">
                                                        <div class="user">
                                                            <div class="user_img">
                                                                <img src="<%=request.getContextPath()%>/webdoc/assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진">
                                                            </div>
                                                        </div>
                                                        <div>
                                                            <strong class="name">나방송</strong>
                                                            <span class="date">2026.05.02 05:32</span>
                                                        </div>
                                                    </div>
                                                    <span class="comment">네. 좋은 의견 감사합니다.</span>
                                                    <div class="cmt_detail">
                                                        <div>
                                                            <span class="textNum"><i class="xi-paper-o"></i>15</span>
                                                        </div>
                                                    </div>
                                                </div>                                                    
                                            </li>
                                            <li class="re_comment">
                                                <div class="item">
                                                    <div class="cmt_info">
                                                        <div class="user">
                                                            <div class="user_img">
                                                            </div>
                                                        </div>
                                                        <div>
                                                            <strong class="name">학*자1</strong>
                                                            <span class="date">2026.05.02 05:32</span>
                                                        </div>
                                                    </div>
                                                    <span class="comment">네. 좋은 의견 감사합니다.</span>
                                                    <div class="cmt_detail">
                                                        <div>
                                                            <span class="textNum"><i class="xi-paper-o"></i>15</span>
                                                        </div>
                                                    </div>
                                                </div>                                                    
                                            </li>
                                        </ul>
                                    </li>
                                </ul>
                            </div><!-- //본인 참여글 -->

                            <!-- 본인 작성 댓글 목록 -->
                            <div class="comment_list">
                                <ul class="bd0">
                                    <li class="course_history bcLgrey3 mt0">
                                        <div class="item flex">
                                            <div class="cmt_info">
                                                <div class="user">
                                                    <span class="user_img"></span>
                                                </div>
                                                <div>
                                                    <strong class="name">학*자1(901258745)</strong>
                                                </div>
                                            </div>                                                
                                            <div class="cmt_detail mt0 mlAuto">
                                                <button class="toggle_commentlist btn type2">5개의 댓글</button>
                                            </div>
                                        </div>
                                        
                                        <ul class="re_comment_ul dpNone">
                                            <li class="re_comment">
                                                <div class="item">
                                                    <div class="cmt_info">
                                                        <div class="user">
                                                            <div class="user_img">
                                                            </div>
                                                        </div>
                                                        <div>
                                                            <strong class="name">학*자1</strong>
                                                            <span class="date">2026.05.02 05:32</span>
                                                        </div>
                                                    </div>
                                                    <span class="comment">댓글1 댓글1 댓글1 댓글1 댓글1 댓글1 댓글1 댓글1 댓글1 댓글1 댓글1 댓글1 댓글1 댓글1 댓글1 댓글1 댓글1 댓글1 댓글1</span>
                                                    <div class="cmt_detail">
                                                        <div>
                                                            <span class="textNum"><i class="xi-paper-o"></i>110</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </li>
                                            <li class="re_comment">
                                                <div class="item">
                                                    <div class="cmt_info">
                                                        <div class="user">
                                                            <div class="user_img">
                                                            </div>
                                                        </div>
                                                        <div>
                                                            <strong class="name">학*자1</strong>
                                                            <span class="date">2026.05.02 05:32</span>
                                                        </div>
                                                    </div>
                                                    <span class="comment">댓글2 댓글2 댓글2 댓글2 댓글2 댓글2 댓글2 댓글2 댓글2 댓글2 댓글2 댓글2 댓글2 댓글2 댓글2 댓글2 댓글2 댓글2 댓글2</span>
                                                    <div class="cmt_detail">
                                                        <div>
                                                            <span class="textNum"><i class="xi-paper-o"></i>89</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </li>
                                            <li class="re_comment">
                                                <div class="item">
                                                    <div class="cmt_info">
                                                        <div class="user">
                                                            <div class="user_img">
                                                            </div>
                                                        </div>
                                                        <div>
                                                            <strong class="name">학*자1</strong>
                                                            <span class="date">2026.05.02 05:32</span>
                                                        </div>
                                                    </div>
                                                    <span class="comment">댓글3 댓글3 댓글3 댓글3 댓글3 댓글3 댓글3 댓글3 댓글3 댓글3 댓글3</span>
                                                    <div class="cmt_detail">
                                                        <div>
                                                            <span class="textNum"><i class="xi-paper-o"></i>67</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </li>
                                            <li class="re_comment">
                                                <div class="item">
                                                    <div class="cmt_info">
                                                        <div class="user">
                                                            <div class="user_img">
                                                            </div>
                                                        </div>
                                                        <div>
                                                            <strong class="name">학*자1</strong>
                                                            <span class="date">2026.05.02 05:32</span>
                                                        </div>
                                                    </div>
                                                    <span class="comment">네. 좋은 의견 감사합니다.</span>
                                                    <div class="cmt_detail">
                                                        <div>
                                                            <span class="textNum"><i class="xi-paper-o"></i>15</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </li>
                                            <li class="re_comment">
                                                <div class="item">
                                                    <div class="cmt_info">
                                                        <div class="user">
                                                            <div class="user_img">
                                                            </div>
                                                        </div>
                                                        <div>
                                                            <strong class="name">학*자1</strong>
                                                            <span class="date">2026.05.02 05:32</span>
                                                        </div>
                                                    </div>
                                                    <span class="comment">네. 좋은 의견 감사합니다.</span>
                                                    <div class="cmt_detail">
                                                        <div>
                                                            <span class="textNum"><i class="xi-paper-o"></i>15</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </li>
                                        </ul>
                                    </li>
                                </ul>
                            </div>
                            <!-- //본인 작성 댓글 목록 -->
                    </div>
                </div>

                <div class="right_app">
                    <div class="right_top_score">
                        <label for="inputScore"><input type="text" id="inputScore" placeholder="점수"></label>
                        <button type="button" class="btn small type3">저장</button>
                        <button type="button" class="btn small type2">초기화</button>                                
                    </div>
                    <div class="right_memo">
                        <button class="btn basic width-100per">3개의 피드백</button>
                        <div class="memoBox">
                            <label for="inputMemo1" class="width-100per"><textarea id="inputMemo1"></textarea></label>
                            <button type="button" class="btn small type3 width-100per">저장</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </script>

    <script>
        let ezGraderDialog = null;

        function openDialog6() {
            ezGraderDialog = UiDialog("ezGraderDialog", {
                titlebar: false,
                fullscreen: true,
                modal: true,
                html: document.getElementById('ezGraderMarkup').innerHTML
            });
            
            // 다이얼로그 내부 동적 요소 이벤트 초기화
            initEzGraderEvents();
        }

        function closeDialog6() {
            if (ezGraderDialog) {
                ezGraderDialog.close();
            }
        }

        function initEzGraderEvents() {
            // 학생 리스트 클릭 이벤트
            $(document).off('click', '.stu_list ul li').on('click', '.stu_list ul li', function() {
                $(this).toggleClass('active');
            });
        }

        document.addEventListener('DOMContentLoaded', function () {
            document.addEventListener('click', function (e) {

                /* 댓글 목록 토글 */
                const listBtn = e.target.closest('.toggle_commentlist');
                if (listBtn) {
                const parentLi = listBtn.closest('li');
                if (!parentLi) return;

                const ul = parentLi.querySelector('.re_comment_ul');
                if (!ul) return;

                ul.style.display =
                    ul.style.display === 'none' || !ul.style.display
                    ? 'block'
                    : 'none';

                return;
                }
            });
        });

        $(document).ready(function() {
            openDialog6();
        });
    </script>

        <script src="<%=request.getContextPath()%>/webdoc/assets/js/modal.js" defer></script>

        
    </div>

</body>
</html>
