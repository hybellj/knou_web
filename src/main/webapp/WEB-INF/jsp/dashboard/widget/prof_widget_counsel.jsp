<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<ul class="dash_item_listA">
    <li>
        <div class="user">
           <span class="user_img"><img src="/webdoc/dm_assets/img/common/photo_user_sample3.jpg" aria-hidden="true" alt="사진"></span>
        </div>
        <a href="#0" class="item_txt">
            <p class="tit">교수님~ 평가항목에 대해 궁금한게 있어요​</p>
            <p class="desc">
                <span class="name">[대학원] 경영수리와 통계1반</span>
                <span class="date">2026.05.17</span>
            </p>
        </a>
        <div class="state">
            <label class="label check_no">미답변</label>
        </div>
    </li>
    <li>
        <div class="user">
           <span class="user_img"></span>
        </div>
        <a href="#0" class="item_txt">
            <p class="tit">성적 처리 기준에 대해 질문이 있습니다.</p>
            <p class="desc">
                <span class="name">[대학원] 경영수리와 통계1반</span>
                <span class="date">2026.05.17</span>
            </p>
        </a>
        <div class="state">
            <label class="label check_reply">답변</label>
        </div>
    </li>
    <li>
        <div class="user">
           <span class="user_img"></span>
        </div>
        <a href="#0" class="item_txt">
            <p class="tit">이번 수업 정말 잘 들었습니다. 많은 도움이 되었어요</p>
            <p class="desc">
                <span class="name">[평생교육] New TEPS 실전 연습-기본편</span>
                <span class="date">2026.05.17</span>
            </p>
        </a>
        <div class="state">
            <label class="label check_no">미답변</label>
        </div>
    </li>
</ul>

<script>

// 1:1상담 위젯 설정
function setCounselWidget() {
	let inTitle = ` <small class="msg_num">4</small>`;
	let subTitle = `<div class="btn-wrap">
		<a href="#0" class="btn_more" aria-label="더보기"><i class="xi-plus"></i></a>
		</div>`;

	dashboardWidget.addInTitle("card5", inTitle);
	dashboardWidget.addSubTitle("card5", subTitle);
}

setCounselWidget();

</script>