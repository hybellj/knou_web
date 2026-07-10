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

<body class="class"><!-- 컬러선택시 클래스변경 -->
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
                            <h2 class="page-title">학습그룹지정</h2>
                        </div>

                        <div class="board_top">
                            <h4 class="sub-title">상세정보</h4>
                            <div class="right-area">
                                <button type="button" class="btn type1">수정</button>
                                <button type="button" class="btn type2">목록</button>
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
                                        <th class="req">학습그룹명</th>
                                        <td>팀 과제 학습그룹지정001</td>
                                    </tr>
                                    <tr>
                                        <th class="req">팀 게시판 사용</th>
                                        <td>예</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="board_top">
                            <h4 class="sub-title">
                                학습그룹 및 팀 구성원
                                <span class="total_txt fw-normal fs-16px">[ 수강생 <b>50</b>명, 총 구성원 <b>50</b>명 ]</span>
                            </h4>
                            <div class="right-area">
                                <button type="button" class="btn basic">메시지 보내기</button>
                            </div>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type3">
                                <colgroup>
                                    <col class="width-5per">
                                    <col class="width-10per">
                                    <col>
                                    <col class="width-10per">
                                    <col class="width-10per">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>
                                        </th>
                                        <th scope="col">번호</th>
                                        <th scope="col">팀 명</th>
                                        <th scope="col">팀장</th>
                                        <th scope="col">팀원</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk1"><label for="chk1"></label></span>
                                        </td>
                                        <td data-th="번호">5</td>
                                        <td data-th="팀명" class="text-left"><a href="#0" class="fcBlue teamName">TEAM5</a></td>
                                        <td data-th="팀장">학*자1</td>
                                        <td data-th="팀원">10</td>
                                    </tr>

                                        <!-- 팀명 클릭시 팀 구성원 보여주기 -->
                                        <tr class="teamView">
                                            <td colspan="5">
                                                <div class="table-wrap overflow-y bd0">
                                                    <table class="table-type3">
                                                        <thead>
                                                            <tr>
                                                                <th scope="col">번호</th>
                                                                <th scope="col">학과</th>
                                                                <th scope="col">대표아이디</th>
                                                                <th scope="col">학번</th>
                                                                <th scope="col">이름</th>
                                                                <th scope="col">구분</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <tr>
                                                                <td data-th="번호">10</td>
                                                                <td data-th="학과">컴퓨터공학과</td>
                                                                <td data-th="대표아이디">testi**1</td>
                                                                <td data-th="학번">22415***52</td>
                                                                <td data-th="이름">학*자01</td>
                                                                <td data-th="구분">팀장</td>
                                                            </tr>
                                                            <tr>
                                                                <td data-th="번호">9</td>
                                                                <td data-th="학과">컴퓨터공학과</td>
                                                                <td data-th="대표아이디">testi**1</td>
                                                                <td data-th="학번">22415***52</td>
                                                                <td data-th="이름">학*자01</td>
                                                                <td data-th="구분">팀원</td>
                                                            </tr>
                                                            <tr>
                                                                <td data-th="번호">8</td>
                                                                <td data-th="학과">컴퓨터공학과</td>
                                                                <td data-th="대표아이디">testi**1</td>
                                                                <td data-th="학번">22415***52</td>
                                                                <td data-th="이름">학*자01</td>
                                                                <td data-th="구분">팀원</td>
                                                            </tr>
                                                            <tr>
                                                                <td data-th="번호">7</td>
                                                                <td data-th="학과">컴퓨터공학과</td>
                                                                <td data-th="대표아이디">testi**1</td>
                                                                <td data-th="학번">22415***52</td>
                                                                <td data-th="이름">학*자01</td>
                                                                <td data-th="구분">팀원</td>
                                                            </tr>
                                                            <tr>
                                                                <td data-th="번호">6</td>
                                                                <td data-th="학과">컴퓨터공학과</td>
                                                                <td data-th="대표아이디">testi**1</td>
                                                                <td data-th="학번">22415***52</td>
                                                                <td data-th="이름">학*자01</td>
                                                                <td data-th="구분">팀원</td>
                                                            </tr>
                                                            <tr>
                                                                <td data-th="번호">5</td>
                                                                <td data-th="학과">컴퓨터공학과</td>
                                                                <td data-th="대표아이디">testi**1</td>
                                                                <td data-th="학번">22415***52</td>
                                                                <td data-th="이름">학*자01</td>
                                                                <td data-th="구분">팀원</td>
                                                            </tr>
                                                            <tr>
                                                                <td data-th="번호">4</td>
                                                                <td data-th="학과">컴퓨터공학과</td>
                                                                <td data-th="대표아이디">testi**1</td>
                                                                <td data-th="학번">22415***52</td>
                                                                <td data-th="이름">학*자01</td>
                                                                <td data-th="구분">팀원</td>
                                                            </tr>
                                                            <tr>
                                                                <td data-th="번호">3</td>
                                                                <td data-th="학과">컴퓨터공학과</td>
                                                                <td data-th="대표아이디">testi**1</td>
                                                                <td data-th="학번">22415***52</td>
                                                                <td data-th="이름">학*자01</td>
                                                                <td data-th="구분">팀원</td>
                                                            </tr>
                                                            <tr>
                                                                <td data-th="번호">2</td>
                                                                <td data-th="학과">컴퓨터공학과</td>
                                                                <td data-th="대표아이디">testi**1</td>
                                                                <td data-th="학번">22415***52</td>
                                                                <td data-th="이름">학*자01</td>
                                                                <td data-th="구분">팀원</td>
                                                            </tr>
                                                            <tr>
                                                                <td data-th="번호">1</td>
                                                                <td data-th="학과">컴퓨터공학과</td>
                                                                <td data-th="대표아이디">testi**1</td>
                                                                <td data-th="학번">22415***52</td>
                                                                <td data-th="이름">학*자01</td>
                                                                <td data-th="구분">팀원</td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr><!-- //팀명 클릭시 팀 구성원 보여주기 -->

                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk2"><label for="chk2"></label></span>
                                        </td>
                                        <td data-th="번호">4</td>
                                        <td data-th="팀명" class="text-left"><a href="#0" class="fcBlue teamName">TEAM4</a></td>
                                        <td data-th="팀장">학*자2</td>
                                        <td data-th="팀원">10</td>
                                    </tr>

                                        <!-- 팀명 클릭시 팀 구성원 보여주기 -->
                                        <tr class="teamView" style="display: none;">
                                            <td colspan="5">
                                                <div class="table-wrap overflow-y bd0">
                                                    <table class="table-type3">
                                                        <thead>
                                                            <tr>
                                                                <th scope="col">번호</th>
                                                                <th scope="col">학과</th>
                                                                <th scope="col">대표아이디</th>
                                                                <th scope="col">학번</th>
                                                                <th scope="col">이름</th>
                                                                <th scope="col">구분</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <tr>
                                                                <td data-th="번호">3</td>
                                                                <td data-th="학과">컴퓨터공학과</td>
                                                                <td data-th="대표아이디">testi**1</td>
                                                                <td data-th="학번">22415***52</td>
                                                                <td data-th="이름">학*자01</td>
                                                                <td data-th="구분">팀장</td>
                                                            </tr>
                                                            <tr>
                                                                <td data-th="번호">2</td>
                                                                <td data-th="학과">컴퓨터공학과</td>
                                                                <td data-th="대표아이디">testi**1</td>
                                                                <td data-th="학번">22415***52</td>
                                                                <td data-th="이름">학*자01</td>
                                                                <td data-th="구분">팀원</td>
                                                            </tr>
                                                            <tr>
                                                                <td data-th="번호">1</td>
                                                                <td data-th="학과">컴퓨터공학과</td>
                                                                <td data-th="대표아이디">testi**1</td>
                                                                <td data-th="학번">22415***52</td>
                                                                <td data-th="이름">학*자01</td>
                                                                <td data-th="구분">팀원</td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr><!-- //팀명 클릭시 팀 구성원 보여주기 -->


                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk3"><label for="chk3"></label></span>
                                        </td>
                                        <td data-th="번호">3</td>
                                        <td data-th="팀명" class="text-left"><a href="#0" class="fcBlue">TEAM3</a></td>
                                        <td data-th="팀장">학*자3</td>
                                        <td data-th="팀원">10</td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk4"><label for="chk4"></label></span>
                                        </td>
                                        <td data-th="번호">2</td>
                                        <td data-th="팀명" class="text-left"><a href="#0" class="fcBlue">TEAM2</a></td>
                                        <td data-th="팀장">학*자2</td>
                                        <td data-th="팀원">10</td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk5"><label for="chk5"></label></span>
                                        </td>
                                        <td data-th="번호">1</td>
                                        <td data-th="팀명" class="text-left"><a href="#0" class="fcBlue">TEAM1</a></td>
                                        <td data-th="팀장">학*자1</td>
                                        <td data-th="팀원">10</td>
                                    </tr>
                                </tbody>
                            </table>
                            <small class="note2 flex margin-top-2">! 학습그룹지정 완료 후 팀 활동에 사용 가능합니다. 학습그룹지정이 미완인 경우  “임시저장” 상태로 표시됩니다.
</small>
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

<script>
    $(function() {
        $('.teamName').on('click', function(e) {
            e.preventDefault();
            $(this).closest('tr').next('.teamView').toggle();
        });
    });
</script>
