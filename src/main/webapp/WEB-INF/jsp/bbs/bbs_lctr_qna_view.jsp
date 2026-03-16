<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="${
			templateUrl eq 'bbsHome' ? 'dashboard'
			: templateUrl eq 'bbsLect' ? 'classroom'
			: templateUrl eq 'bbsMgr' ? 'admin' : ''}"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>

	<!-- 게시판 공통 -->
	<%@ include file="/WEB-INF/jsp/bbs/common/bbs_common_inc.jsp" %>

	<script type="text/javascript">
        // 게시글 목록 이동
        function moveAtclList() {
            document.location.href = "/bbs/${templateUrl}/bbsLctrQnaListView.do?eparam=${eparam}";
        }
	</script>
</head>

<body class="home colorA ${bodyClass}"  style=""><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <%@ include file="/WEB-INF/jsp/common_new/home_header.jsp" %>
        <!-- //common header -->

        <!-- dashboard -->
        <main class="common">

            <!-- gnb -->
            <%@ include file="/WEB-INF/jsp/common_new/home_gnb_prof.jsp" %>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="dashboard_sub">
                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title"><span>강의Q&A</span>상세</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>공지사항</li>
                                    <li><span class="current">전체공지</span></li>
                                </ul>
                            </div>
                        </div>

                        <%-- <div class="board_top">
                            <h3 class="board-title">게시글</h3>
                        </div>

                        <div class="table_list">

                            제목: ${bbsAtclVO.atclTtl}<br>
							작성자: ${bbsAtclVO.rgtrnm}<br>
							작성일: ${bbsAtclVO.regDttm}<br>
							조회수: ${bbsAtclVO.inqCnt}<br>
							댓글: ${bbsAtclVO.cmntCnt}
                        </div> --%>

						<div class="tstyle_view">
                            <div class="table_list">
                                <ul class="list">
                                    <li class="head"><label>운영과목</label></li>
                                    <li>대학원 > 학과 > 일한 번역연습 1반</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>제목</label></li>
                                    <li>제목제목제목제목제목제목제목제목</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>내용</label></li>
                                    <li>학사학위과정</li>
                                </ul>
                            </div>

                            <div class="add_file_list">
                                <ul class="add_file">
                                    <li>
                                        <a href="#" class="file_down">
                                            <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                            <span class="text">첨부파일명마우스오버 시.doc</span>
                                            <span class="fileSize">(6KB)</span>
                                        </a>
                                        <span class="link">
                                            <button class="btn s_basic down">다운로드</button>
                                        </span>
                                    </li>
                                    <li>
                                        <a href="#" class="file_down">
                                            <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                            <span class="text">154873973477000.jpg</span>
                                            <span class="fileSize">(6KB)</span>
                                        </a>
                                        <span class="link">
                                            <button class="btn s_basic down">다운로드</button>
                                        </span>
                                    </li>
                                </ul>
                            </div>

                            <div class="btns">
                                <button type="button" class="btn type1">수정</button>
                                <button type="button" class="btn type2">삭제</button>
                                <button type="button" class="btn type2">목록</button>
                            </div>


                            <!-- 답변 -->
                            <div class="answer">
                                <div class="title_area">
                                    <strong class="title">답변입니다.</strong>
                                    <span class="date"><b>관리자</b><em>2025.10.28</em></span>
                                </div>
                                <div class="cont">
                                     <label class="width-100per"><textarea rows="5" class="form-control resize-none"></textarea></label>
                                     <div class="bottom_btn">
                                        <div class="simple_answer">
                                            <span>간편 답변</span>
                                            <div class="answer_btn">
                                                <a href="#0" class="current">수고했어요</a><!--간편답변 선택시 클래스추가-->
                                                <a href="#0">고생하셨어요.</a>
                                                <a href="#0">감사합니다.</a>
                                            </div>
                                        </div>
                                        <div class="right-area">
                                            <button type="button" class="btn type2">저장</button>
                                        </div>
                                     </div>
                                </div>
                            </div>

                            <div class="answer">
                                <div class="title_area">
                                    <strong class="title">답변입니다.</strong>
                                    <span class="date"><b>관리자</b><em>2025.10.28</em></span>
                                </div>
                                <div class="cont">
                                    이 문제는 다른 문제에 비해서는 많이 어려운 편에 속하는 문제이니, 풀지 못했다고 해도 크게 상심하실 필요가 없습니다. <br>
                                    답변드린 내용 중 더 궁금하신 점 있으시다면 언제든 편하게 질문주세요! 감사합니다.
                                    <div class="bottom_btn">
                                        <div class="right-area">
                                            <button type="button" class="btn basic">수정</button>
                                            <button type="button" class="btn basic">삭제</button>
                                        </div>
                                     </div>
                                </div>
                            </div>

                            <!-- 댓글 -->
                            <div class="Comment">
                                <div class="top_area">
                                    <button class="toggle_commentlist"><i class="icon-svg-message"></i>2개의 댓글이 있습니다. <i class="icon-svg-arrow-down"></i></button>
                                    <button class="toggle_commentwrite btn basic">댓글 작성</button>
                                </div>

                                <div class="comment_list">
                                    <div class="recmt_form">
                                        <fieldset>
                                            <legend class="sr_only">댓글등록</legend>
                                            <div class="memo">
                                                <div class="simple_answer">
                                                    <span>간편 댓글</span>
                                                    <div class="answer_btn">
                                                        <a href="#0" class="current">수고했어요</a><!--간편답변 선택시 클래스추가-->
                                                        <a href="#0">고생하셨어요.</a>
                                                        <a href="#0">감사합니다.</a>
                                                    </div>
                                                </div>
                                                <textarea title="댓글을 등록하세요." class="comment" name="c_comment" rows="3" cols="76" placeholder="댓글을 입력해 주세요"></textarea>
                                                <div class="bottom_btn">
                                                    <span class="custom-input">
                                                        <input type="checkbox" name="" id="feedbackLabel">
                                                        <label for="feedbackLabel">피드백 문의 <span class="small">( 체크 시 문의로 등록되며 답변을 받을 수 있습니다. )</span></label>
                                                    </span>
                                                    <div class="right-area">
                                                        <button type="button" class="btn type2">댓글 등록</button>
                                                    </div>
                                                </div>

                                            </div>
                                        </fieldset>
                                    </div>
                                    <ul>
                                        <li>
                                            <div class="item">
                                                <div class="cmt_info">
                                                    <strong class="name">홍길동</strong>
                                                    <span class="date">2026.05.02 05:32</span>
                                                </div>
                                                <span class="comment">최근 우리사회의 가장 큰 화두중 하나는 4차 산업혁명과 일자리문제입니다.</span>
                                                <span class="cmtBtnGroup">
                                                    <button class="cmtUpt">수정</button>
                                                    <button class="cmtDel">삭제</button>
                                                    <button class="cmtWri">댓글</button>
                                                </span>
                                            </div>
                                            <div class="recmt_form">
                                                <fieldset>
                                                    <legend class="sr_only">댓글등록</legend>
                                                    <div class="memo">
                                                        <textarea title="댓글을 등록하세요." class="comment" name="c_comment" rows="3" cols="76" placeholder="댓글을 입력해 주세요"></textarea>
                                                        <button type="button" class="cmt_create">댓글 등록</button>
                                                    </div>
                                                </fieldset>
                                            </div>
                                            <ul class="re_comment_ul">
                                                <li class="re_comment">
                                                    <div class="item">
                                                        <div class="cmt_info">
                                                            <strong class="name">나방송</strong>
                                                            <span class="date">2026.05.02 05:32</span>
                                                        </div>
                                                        <span class="comment">네. 좋은 의견 감사합니다.</span>
                                                        <span class="cmtBtnGroup">
                                                            <button class="cmtUpt">수정</button>
                                                            <button class="cmtDel">삭제</button>
                                                        </span>
                                                    </div>
                                                </li>
                                                <li class="re_comment">
                                                    <div class="item">
                                                        <div class="cmt_info">
                                                            <strong class="name">홍길동</strong>
                                                            <span class="date">2026.05.02 05:32</span>
                                                        </div>
                                                        <span class="comment">동의합니다.</span>
                                                        <span class="cmtBtnGroup">
                                                            <button class="cmtUpt">수정</button>
                                                            <button class="cmtDel">삭제</button>
                                                        </span>
                                                    </div>
                                                </li>

                                            </ul>
                                        </li>

                                        <li>
                                            <div class="item">
                                                <div class="cmt_info">
                                                    <strong class="name">나방송</strong>
                                                    <span class="date">2024.05.02 05:32</span>
                                                </div>
                                                <span class="comment">질문의 효과를 최대화 시키기 위해서는 올바른 질문을 하는 것이 중요</span>
                                                <span class="cmtBtnGroup">
                                                    <button class="cmtUpt">수정</button>
                                                    <button class="cmtDel">삭제</button>
                                                    <button class="cmtWri">댓글</button>
                                                </span>
                                            </div>

                                        </li>
                                    </ul>
                                </div>

                            </div>

                            <script>
                                document.addEventListener('DOMContentLoaded', function () {

                                    document.addEventListener('click', function (e) {

                                    /* 댓글 목록 토글 */
                                    const listBtn = e.target.closest('.toggle_commentlist');
                                    if (listBtn) {
                                    const comment = listBtn.closest('.Comment');
                                    if (!comment) return;

                                    const ul = comment.querySelector('.comment_list > ul');
                                    if (!ul) return;

                                    ul.style.display =
                                        ul.style.display === 'none' || !ul.style.display
                                        ? 'block'
                                        : 'none';

                                    return;
                                    }

                                    /* 상단 댓글 작성 폼 토글 */
                                    const writeBtn = e.target.closest('.toggle_commentwrite');
                                    if (writeBtn) {
                                    const comment = writeBtn.closest('.Comment');
                                    if (!comment) return;

                                    const form = comment.querySelector('.comment_list > .recmt_form');
                                    if (!form) return;

                                    form.style.display =
                                        form.style.display === 'none' || !form.style.display
                                        ? 'block'
                                        : 'none';

                                    if (form.style.display === 'block') {
                                        form.querySelector('textarea')?.focus();
                                    }

                                    return;
                                    }

                                    /* 댓글 목록 안 대댓글 폼 토글 */
                                    const replyBtn = e.target.closest('.cmtWri');
                                    if (replyBtn) {
                                    const li = replyBtn.closest('li');
                                    if (!li) return;

                                    const comment = replyBtn.closest('.Comment');
                                    const replyForm = li.querySelector('.recmt_form');
                                    if (!replyForm) return;

                                    // 같은 Comment 안의 다른 대댓글 폼 닫기
                                    comment
                                        .querySelectorAll('.comment_list ul li .recmt_form')
                                        .forEach(function (form) {
                                        if (form !== replyForm) {
                                            form.style.display = 'none';
                                        }
                                        });

                                    replyForm.style.display =
                                        replyForm.style.display === 'none' || !replyForm.style.display
                                        ? 'block'
                                        : 'none';

                                    if (replyForm.style.display === 'block') {
                                        replyForm.querySelector('textarea')?.focus();
                                    }
                                    }

                                    });

                                });
                            </script>

                        </div>

                        <div class="btns">
                        	<c:if test="${not empty bbsAtclVO.beforeAtclId }">
                           		<a href="javascript:moveAtclPost('${bbsAtclVO.beforeAtclId }')" class="btn type2"><spring:message code="bbs.label.prev_atcl" /><!-- 이전글 --></a>
                           	</c:if>
                           	<c:if test="${not empty bbsAtclVO.afterAtclId }">
                           		<a href="javascript:moveAtclPost('${bbsAtclVO.afterAtclId }')" class="btn type2"><spring:message code="bbs.label.next_atcl" /><!-- 다음글 --></a>
                           	</c:if>
                               <c:if test="${atclEditAuth eq 'Y'}">
		                        <a href="javascript:moveEditAtcl()" class="btn type2"><spring:message code="common.button.modify" /></a><!-- 수정 -->
							</c:if>
							<c:if test="${atclDeleteAuth eq 'Y'}">
		                        <a href="javascript:removeAtcl()" class="btn type2"><spring:message code="common.button.delete" /></a><!-- 삭제 -->
		                    </c:if>
	                    	<a href="#0" onclick="moveAtclList();return false;" class="btn type2"><spring:message code="common.button.list" /></a><!-- 목록 -->
                        </div>


                    </div>

                </div>
            </div>
            <!-- //content -->


            <!-- common footer -->
            <%@ include file="/WEB-INF/jsp/common_new/home_footer.jsp" %>
            <!-- //common footer -->

        </main>
        <!-- //dashboard-->

    </div>


</body>
</html>