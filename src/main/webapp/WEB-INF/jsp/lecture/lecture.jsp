<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@page import="knou.framework.common.ParamInfo"%>
<%@page import="knou.framework.common.SubjectInfo"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>
<!DOCTYPE html>
<body class="class ${uiex:getTheme()} "><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main" style="padding:3px">
    	<div id="content" class="content-wrap common" style="padding:3px"> 
           
           <!-- course_history -->
           <div class="course_history mt0">
           
               <div class="h_top">
                   <div class="h_left">
                       <strong class="tit">[1주차] 2강. 무생물주어의 처리</strong>
                       <p class="desc">
                           <span>학습기간<strong>2025.06.02 ~ 2025.06.10</strong></span>
                           <span><strong>30분</strong></span>
                           <span><strong>출결대상</strong></span>
                       </p>
                   </div>
                   <div class="h_right">
                       <button class="btn s_type2 noAfter">나의 학습기록</button>
                   </div>
               </div>

				
               <div class="padding-4">
                   <!-- 학습개요 -->
                   <h3 class="board-title mb10">학습개요</h3>
                   <div class="board_top class mb40">
                       한국어와 다른 영어의 구문상 가장 큰 특징 중의 하는 무생물주어를 많이 쓴다는 점이다.한국어와 다른 영어의 구문상 가장 큰 특징 중의 하는 무생물주어를 많이 쓴다는 점이다.한국어와 다른 영어의 구문상 가장 큰 특징 중의 하는 무생물주어를 많이 쓴다는 점이다.한국어와 다른 영어의 구문상 가장 큰 특징 중의 하는 무생물주어를 많이 쓴다는 점이다.
                   </div>

                   <!-- 오늘의 학습 -->
                   <h3 class="board-title mb10">오늘의 학습</h3>
                   <div class="flex align-center justify-content-between mb10 gap-2">
                       <p class="flex-shrink-0">학습진행</p>
                       <div class="learning-progress">
                           <span>100% (30분 00초)</span>
                           <div class="bar" style="width: 40%;"></div>
                       </div>
                   </div>
                   <div class="video-wrap">
                       <iframe src="https://v.kr.kollus.com/nf8sE0Rq?" allow="local-network-access" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe>
                   </div>
                   <div class="likeBtn">
                       <button type="button" class="btn"><i class="xi-heart-o"></i>좋아요<span>2,026</span></button>
                   </div>

                   <!-- 연습문제 ① -->
                    <div class="board_top">
                       <h3 class="board-title mb10">연습문제 ①</h3>
                       <div class="right-area" style="position: relative; display: inline-block;">
                           <button type="button" class="btn s_type2 noAfter" aria-expanded="false" aria-controls="ansBox1">정답확인</button>
                           <div class="ansBox" id="ansBox1">
                               <table class="table-type3">
                                   <caption>연습문제 1 정답 정보</caption>
                                   <thead>
                                       <tr>
                                           <th scope="col">문제</th>
                                           <th scope="col">정답</th>
                                       </tr>
                                   </thead>
                                   <tbody>
                                       <tr>
                                           <th data-th="문제">1</th>
                                           <td data-th="정답">2</td>
                                       </tr>
                                       <tr>
                                           <th data-th="문제">2</th>
                                           <td data-th="정답">-</td>
                                       </tr>
                                       <tr>
                                           <th data-th="문제">3</th>
                                           <td data-th="정답">2</td>
                                       </tr>
                                       <tr>
                                           <th data-th="문제">4</th>
                                           <td data-th="정답">1</td>
                                       </tr>
                                       <tr>
                                           <th data-th="문제">5</th>
                                           <td data-th="정답">4</td>
                                       </tr>
                                       <tr>
                                           <th data-th="문제">6</th>
                                           <td data-th="정답">2</td>
                                       </tr>
                                       <tr>
                                           <th data-th="문제">7</th>
                                           <td data-th="정답">1</td>
                                       </tr>
                                       <tr>
                                           <th data-th="문제">8</th>
                                           <td data-th="정답">4</td>
                                       </tr>
                                       <tr>
                                           <th data-th="문제">9</th>
                                           <td data-th="정답">학교</td>
                                       </tr>
                                       <tr>
                                           <th data-th="문제">10</th>
                                           <td data-th="정답">-</td>
                                       </tr>
                                   </tbody>
                               </table>
                           </div>
                       </div>
                    </div>

                   <div class="quiz_paper_wrap">
                       <div class="quiz_paper_list">
                           <ol>
                               <li class="active"><span>1</span></li>
                               <li class="active"><span>2</span></li>
                               <li><span>3</span></li>
                               <li><span>4</span></li>
                               <li><span>5</span></li>
                               <li><span>6</span></li>
                               <li><span>7</span></li>
                               <li><span>8</span></li>
                               <li><span>9</span></li>
                               <li><span>10</span></li>
                           </ol>
                       </div>
                   </div>

                   <div class="course_history bd0">
                       <div class="question_area pd0">
                           <div class="question_con">
                               <div class="q_top">
                                   <div class="flex-item width-100per">
                                       <p class="flex-none mr15"><b>문제1</b></p>
                                       <div class="flex-1 tal"> </div>
                                   </div>
                               </div>
                               <div class="q_cont">
                                   <ol class="q_cont_ans">
                                       <li>
                                           <input type="radio" name="q2_ans" id="q1_ans1">
                                           <label for="q1_ans1"><span class="ansNum">1</span>나무</label>
                                       </li>
                                       <li>
                                           <input type="radio" name="q2_ans" id="q1_ans2">
                                           <label for="q1_ans2"><span class="ansNum">2</span>돌</label>
                                       </li>
                                       <li>
                                           <input type="radio" name="q2_ans" id="q1_ans3" checked="">
                                           <label for="q1_ans3"><span class="ansNum">3</span>바다</label>
                                       </li>
                                       <li>
                                           <input type="radio" name="q2_ans" id="q1_ans4">
                                           <label for="q1_ans4"><span class="ansNum">4</span>산</label>
                                       </li>
                                   </ol>
                               </div>
                           </div>
                       </div>
                   </div>

                   <div class="course_history bd0">
                       <div class="question_area pd0">
                           <div class="question_con">
                               <div class="q_top">
                                   <div class="flex-item width-100per">
                                       <p class="flex-none mr15"><b>문제2</b></p>
                                       <div class="flex-1 tal">다음 문장을 한국어로 번역하세요. 연습문제를 푼 후 구글 클래스룸의 복습하기를 작성하시면 됩니다.<br>
                                           The innovative engine design makes this automobile quieter and more fuel efficient</div>
                                   </div>
                               </div>
                               <div class="q_cont">
                                   <div class="q_cont_ans">
                                   <textarea name="" id="" placeholder="서술형 주관식 입력란" class="width-100per"></textarea>
                                   </div>
                               </div>
                           </div>
                       </div>
                   </div>

                   <div class="h_content pd0">
                       <ul class="accordion course_week">
                           <li><!-- 클릭시 active 추가 -->
                               <div class="title-wrap">                                      
                                   <a class="title" href="#">                                                
                                       <div class="lecture_box work">
                                           <div class="lecture_tit">
                                               <p class="labels">
                                                   <label class="label s_online">강의</label>
                                               </p>
                                               <strong>콘텐츠 제목 1</strong>                                                    
                                           </div>
                                           <p class="desc">
                                               <span>학습기간<strong>2026.03.10 10:00 ~ 2026.03.16 22:00</strong></span>                                    
                                           </p>
                                           <i class="arrow xi-angle-down"></i>
                                       </div>
                                   </a>
                               </div>
                               <div class="cont">
                                   <div class="flex align-center justify-content-between mb10 gap-2">
                                       <p class="flex-shrink-0">학습진행</p>
                                       <div class="learning-progress">
                                           <span>100% (30분 00초)</span>
                                           <div class="bar" style="width: 40%;"></div>
                                       </div>
                                   </div>
                                   <div class="video-wrap">
                                       <video controls="" playsinline="">
                                           <source src="https://www.w3schools.com/html/mov_bbb.mp4" type="video/mp4">
                                       </video>
                                   </div>
                                   <div class="likeBtn mb0">
                                       <button type="button" class="btn"><i class="xi-heart-o"></i>좋아요<span>2,026</span></button>
                                   </div>
                               </div>
                           </li>
                       </ul>
                   </div>

               </div>
               
           </div>
           <!-- //course_history  -->

           <div class="modal_btns">
               <!--<button type="button" class="btn type2" onclick="if(window.parent && window.parent.$){ window.parent.$('.ui-dialog-content:visible').dialog('close'); }">학습종료</button>-->
          		<button type="button" class="btn type2" onclick="window.close();">
           </div>
           
		</div>
		<!-- //content -->
		
	</div>
	<!-- //main -->
        <script src="/webdoc/assets/js/modal.js" defer></script>

        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const likeButton = document.querySelector('.likeBtn .btn');
                if (likeButton) {
                    likeButton.addEventListener('click', function() {
                        const icon = this.querySelector('i');
                        const countSpan = this.querySelector('span');
                        let currentCount = parseInt(countSpan.textContent.replace(/,/g, ''));
                        this.classList.toggle('active');

                        if (icon.classList.contains('xi-heart-o')) {
                            icon.classList.remove('xi-heart-o');
                            icon.classList.add('xi-heart');
                            countSpan.textContent = (currentCount + 1).toLocaleString();
                        } else {
                            icon.classList.remove('xi-heart');
                            icon.classList.add('xi-heart-o');
                            countSpan.textContent = (currentCount - 1).toLocaleString();
                        }
                    });
                }

                // 정답확인 버튼 토글 기능
                const ansBtn = document.querySelector('button[aria-controls="ansBox1"]');
                if (ansBtn) {
                    ansBtn.addEventListener('click', function() {
                        const targetId = this.getAttribute('aria-controls');
                        const targetBox = document.getElementById(targetId);
                        const isVisible = targetBox.style.display !== 'none';

                        targetBox.style.display = isVisible ? 'none' : 'block';
                        this.setAttribute('aria-expanded', !isVisible);
                    });
                }
            });
        </script>
</body>