<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="style" value="dashboard"/>
	</jsp:include>
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
                <!-- class_sub_top -->
				<jsp:include page="../common/class_sub_top.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
				<!-- //class_sub_top -->

                <div class="class_sub">
                    <!-- class_info -->
					<jsp:include page="../common/class_info.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
                    <!-- //class_info -->


                    <div class="sub-content">

                        <div class="page-info">
                            <h2 class="page-title">이전학기 불러오기</h2>
                        </div>

                        <h4 class="sub-title">이전 학기 데이터 가져오기</h4>
                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:70px">
                                    <col>
                                    <col style="width:80px">
                                    <col style="width:150px">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>번호</th>
                                        <th>내용</th>
                                        <th>설치현황</th>
                                        <th>관리</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr class="check_yet">
                                        <td>전체</td>
                                        <td class="text-left">하단의 모든 데이터를 현재 과목으로 가져 옵니다.</td>
                                        <td><i class="icon-svg-no fcRed" aria-hidden="true" aria-label="NO"></i></td>
                                        <td>
                                            <button type="button" class="btn type3 w120">전체 가져오기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td class="text-left">이전 학기의 공지사항 전체를 가져옵니다.</td>
                                        <td><i class="icon-svg-yes fcBlue" aria-hidden="true" aria-label="YES"></i></td>
                                        <td>
                                            <button type="button" class="btn basic w120">공지사항</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>2</td>
                                        <td class="text-left">이전 학기의 강의자료실 전체를 가져옵니다.</td>
                                        <td><i class="icon-svg-yes fcBlue" aria-hidden="true" aria-label="YES"></i></td>
                                        <td>
                                            <button type="button" class="btn basic w120">강의자료실</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>3</td>
                                        <td class="text-left">이전 학기의 학습자료 전체를 가져옵니다.</td>
                                        <td><i class="icon-svg-no fcRed" aria-hidden="true" aria-label="NO"></i></td>
                                        <td>
                                            <button type="button" class="btn basic w120">학습자료</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>4</td>
                                        <td class="text-left">이전 학기의 개설 과제 전체를 가져옵니다.</td>
                                        <td><i class="icon-svg-no fcRed" aria-hidden="true" aria-label="NO"></i></td>
                                        <td>
                                            <button type="button" class="btn basic w120">과제</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>5</td>
                                        <td class="text-left">이전 학기의 개설 설문 전체를 가져옵니다.</td>
                                        <td><i class="xi-spinner-5" aria-hidden="true" aria-label="NO"></i></td>
                                        <td>
                                            <button type="button" class="btn basic w120">설문</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>6</td>
                                        <td class="text-left">이전 학기의 개설 토론 전체를 가져옵니다.</td>
                                        <td><i class="icon-svg-no fcRed" aria-hidden="true" aria-label="NO"></i></td>
                                        <td>
                                            <button type="button" class="btn basic w120">토론</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>7</td>
                                        <td class="text-left">이전 학기의 개설 연습문제 전체를 가져옵니다.</td>
                                        <td><i class="icon-svg-no fcRed" aria-hidden="true" aria-label="NO"></i></td>
                                        <td>
                                            <button type="button" class="btn basic w120">연습문제</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>8</td>
                                        <td class="text-left">이전 학기의 개설 돌발 퀴즈 전체를 가져옵니다.</td>
                                        <td><i class="icon-svg-no fcRed" aria-hidden="true" aria-label="NO"></i></td>
                                        <td>
                                            <button type="button" class="btn basic w120">돌발 퀴즈</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
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
