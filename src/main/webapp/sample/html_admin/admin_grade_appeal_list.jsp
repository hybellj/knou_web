<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">
		<jsp:param name="style" value="admin"/>
	</jsp:include>
</head>

<body class="admin">
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="../common/admin_header.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
        <!-- //common header -->

        <!-- admin -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="../common/admin_aside.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="admin_sub_top">
                    <div class="date_info">
                        <i class="icon-svg-calendar" aria-hidden="true"></i>2025년 2학기 7주차 : 2025.10.05 (월) ~ 2025.10.16 (목)
                    </div>
                </div>
                <div class="admin_sub">

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">성적이의 신청관리</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>수업운영도구</li>
                                    <li>과목관리</li>
                                    <li>성적관리</li>
                                    <li><span class="current">성적이의 신청관리</span></li>
                                </ul>
                            </div>
                        </div>

                        <!-- search typeA -->
                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="selectDate">기관</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectDate1" disabled>
                                        <option value="대학원">대학원</option>
                                    </select>
                                    <select class="form-select" id="selectDate2">
                                        <option value="부서/학과">부서/학과</option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectCourse">년도/학기(기수)</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectCourse">
                                        <option value="2026년">2026년</option>
                                    </select>
                                    <select class="form-select" id="selectCourse">
                                        <option value="1학기">1학기</option>
                                    </select>                                    
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectSearch">학과</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectSearch1">
                                        <option value="전체">전체</option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectSearch">과목</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectSearch1">
                                        <option value="전체">전체</option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="">검색어</label></span>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" name="" id="inputSearch1" value="" placeholder="대표ID/학번/이름 검색">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search">검색</button>
                            </div>
                        </div>

                        <!-- 성적이의 신청기간 -->
                        <div class="msg-box warning mt20">
                            <div class="txt_group">
                                <p class="txt ct"><strong>성적이의 신청기간 : </strong>2026.03.03 00:00 ~ 2026.05.10 23:59</p>
                            </div>
                        </div><!-- //성적이의 신청기간 -->

                        <div class="board_top">
                            <h3 class="board-title">신청자</h3>
                            <div class="right-area">
                                <button type="button" class="btn basic">메시지 보내기</button>
                                <button type="button" class="btn type2">엑셀로 다운로드</button>
                                <select class="form-select type-num" id="select" title="페이지당 리스트수를 선택하세요.">
                                    <option value="ALL" selected="selected">10</option>
                                    <option value="20">20</option>
                                    <option value="30">30</option>
                                </select>                                
                            </div>
                        </div>

                        <div class="table-wrap overflow-y">
                            <table class="table-type3">
                                <colgroup> 
                                    <col style="width:3%">
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col style="width:7%">
                                    <col>
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col" rowspan="2">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="subject_chkall">
                                                <label for="subject_chkall"></label>
                                            </span>
                                        </th>
                                        <th scope="col" rowspan="2">번호</th>
                                        <th scope="col" rowspan="2" class="cursor-pointer">기관<i class="xi-arrows-v icon"></i></th>
                                        <th scope="col" rowspan="2" class="cursor-pointer">년도<i class="xi-arrows-v icon"></i></th>
                                        <th scope="col" rowspan="2" class="cursor-pointer">학기<i class="xi-arrows-v icon"></i></th>
                                        <th scope="col" rowspan="2">학과</th>
                                        <th scope="col" rowspan="2">과목코드</th>
                                        <th scope="col" rowspan="2">과목</th>
                                        <th scope="col" rowspan="2">분반</th>
                                        <th scope="col" colspan="5">수강생정보</th>
                                        <th scope="col" rowspan="2">사유</th>
                                        <th scope="col" rowspan="2">변경 전 점수</th>
                                        <th scope="col" rowspan="2">변경 후 점수</th>
                                        <th scope="col" rowspan="2">성적이의<br>신청처리</th>
                                        <th scope="col" rowspan="2">처리상태</th>
                                    </tr>
                                    <tr>
                                        <th scope="col">학과</th>
                                        <th scope="col">대표ID</th>
                                        <th scope="col">학번</th>
                                        <th scope="col">이름</th>
                                        <th scope="col">학년</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk11"><label for="chk11"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">11</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년도</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">유비쿼터스컴퓨팅</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="학과">사회복지학과</td>
                                        <td data-th="대표ID">testi**1</td>
                                        <td data-th="학번">20241***75</td>
                                        <td data-th="이름">학*자1</td>
                                        <td data-th="학년">2</td>
                                        <td data-th="사유">
                                            <button type="button" class="btn basic small">사유</button>
                                        </td>
                                        <td data-th="변경 전 점수">78.2</td>
                                        <td data-th="변경 후 점수">-</td>
                                        <td data-th="성적이의 신청처리">
                                            <button type="button" class="btn basic small">처리하기</button>
                                        </td>
                                        <td data-th="처리상태" class="fcRed">
                                            신청
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk10"><label for="chk10"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">11</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년도</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">유비쿼터스컴퓨팅</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="학과">사회복지학과</td>
                                        <td data-th="대표ID">testi**1</td>
                                        <td data-th="학번">20241***75</td>
                                        <td data-th="이름">학*자1</td>
                                        <td data-th="학년">2</td>
                                        <td data-th="사유">
                                            <button type="button" class="btn basic small">사유</button>
                                        </td>
                                        <td data-th="변경 전 점수">78.2</td>
                                        <td data-th="변경 후 점수">85.5</td>
                                        <td data-th="성적이의 신청처리">
                                            <button type="button" class="btn basic small">처리하기</button>
                                        </td>
                                        <td data-th="처리상태">승인(가산점 부여)</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="btns mb40">
                            <button type="button" class="btn type1">등록</button>
                        </div>

                        <div class="box">
                            <div class="board_top">
                                <h4>▣ 성적이의신청 안내</h4>
                            </div>
                            <p>성적이의 신청기간에 학생이 성적을 확인 후 성적이의신청한 내역이 본 화면에 조회된다.</p>
                            <p class="mb20">성적이의신청 학생을 조회하고, 성적이의신청사유를 확인하여 사유가 타당하면 성적을 정정하고 그렇지 않으면 반려처리 한다.</p>
                            
                            <strong class="mb10">1. 사유</strong>
                            <ul class="list-bullet mb20">
                                <li>학생의 성적이의신청 사유를 조회한다.</li>
                            </ul>

                            <strong class="mb10">2. 성적변경하기</strong>
                            <ul class="list-bullet mb20">
                                <li>성적이의신청사유가 타당한 경우 성적을 변경하고 승인처리 한다. 처리상태가 승인으로 나타난다.</li>
                                <li>성적이의신청사유가 부당한 경우는 반려사유를 입력 후 반려처리 한다. 처리상태가 반려로 나타난다.</li>
                                <li>성적변경처리 팝업화면이 나타나고, 성적이의신청 학생에 포커스가 자동으로 설정되어 변경이 필요하면 <strong>"가산점"</strong>항목을 통해서 점수를 변경한다.</li>
                            </ul>

                            <strong class="mb10">3. 추가, 삭제, 저장</strong>
                            <ul class="list-bullet mb20">
                                <li>성적이의신청이 시스템으로 등록할 수 없는 경우에 불가피하게 관리자가 직접 신청사유를 입력하여 등록하고, 성적이의신청처리를 할 수 있다.</li>
                            </ul>

                        </div>
                    </div>
                </div>

                <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                <div class="modal-btn-box mt30">
                    <button type="button" class="btn modal__btn" id="btn-modal1" data-target="#modal1">성적이의 신청자 등록</button>
                    <button type="button" class="btn modal__btn" id="btn-modal2" data-target="#modal2">성적이의 신청처리</button>
                    <button type="button" class="btn modal__btn" id="btn-modal3" data-target="#modal3">학습요소별 성적</button>
                </div>
                <!--// modal popup 보여주기 버튼(개발시 삭제) -->


            </div>
            <!-- //content -->


            <!-- Modal1 성적처리 로그조회 -->
            <div class="modal-overlay" id="modal1">
                <div class="modal-content">
                    <div class="modal-body">

                        <div class="board_top">
                            <h4 class="sub-title">
                                수강생
                                <span class="total_txt fs-16px fw-normal ml5">[ 총 건수 : <b>50</b>건 ]</span>
                            </h4>
                            <div class="right-area">
                                <select class="form-select" id="selectDate1" disabled>
                                    <option value="대학원">대학원</option>
                                </select>
                                <select class="form-select" id="selectDate2">
                                    <option value="2025년">2025년</option>
                                    <option value="2024년">2024년</option>
                                </select>
                                <select class="form-select" id="selectDate3">
                                    <option value="2학기">2학기</option>
                                    <option value="1학기">1학기</option>
                                </select>
                                <select class="form-select wide" id="selectSubject">
                                    <option value="">학과</option>
                                </select>
                                <select class="form-select wide" id="selectSubject2">
                                    <option value="">과목</option>
                                </select>
                                <div class="search-typeC">
                                    <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="이름/아이디/사번 입력">
                                    <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                                </div>
                            </div>
                        </div>

                        <div class="table-wrap overflow-y">
                            <table class="table-type3">
                                <colgroup>
                                    <col style="width:3%">
                                    <col style="width:5%">
                                    <col>
                                    <col>
                                    <col>
                                    <col style="width:10%">
                                    <col style="width:10%">
                                    <col style="width:10%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="row">선택</th>
                                        <th scope="row">번호</th>
                                        <th scope="row">학과</th>
                                        <th scope="row">과목</th>
                                        <th scope="row">대표ID</th>
                                        <th scope="row">학번</th>
                                        <th scope="row">이름</th>
                                        <th scope="row">점수</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr class="check_yet">
                                        <td data-th="선택">
                                            <span class="custom-input type-regist">
                                                <input type="radio" name="applySeqs" id="chk_50" checked>
                                                <label for="chk_50"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">50</td>
                                        <td data-th="학과">0000학과</td>
                                        <td data-th="과목">일본어 회화 01반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="학번">20241***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="점수">86.03</td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input type-regist">
                                                <input type="radio" name="applySeqs" id="chk_49">
                                                <label for="chk_49"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">49</td>
                                        <td data-th="학과">0000학과</td>
                                        <td data-th="과목">일본어 회화 01반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="학번">20241***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="점수">86.03</td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input type-regist">
                                                <input type="radio" name="applySeqs" id="chk_48">
                                                <label for="chk_48"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">48</td>
                                        <td data-th="학과">0000학과</td>
                                        <td data-th="과목">일본어 회화 01반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="학번">20241***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="점수">86.03</td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input type-regist">
                                                <input type="radio" name="applySeqs" id="chk_47">
                                                <label for="chk_47"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">47</td>
                                        <td data-th="학과">0000학과</td>
                                        <td data-th="과목">일본어 회화 01반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="학번">20241***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="점수">86.03</td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input type-regist">
                                                <input type="radio" name="applySeqs" id="chk_46">
                                                <label for="chk_46"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">46</td>
                                        <td data-th="학과">0000학과</td>
                                        <td data-th="과목">일본어 회화 01반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="학번">20241***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="점수">86.03</td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input type-regist">
                                                <input type="radio" name="applySeqs" id="chk_45">
                                                <label for="chk_45"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">45</td>
                                        <td data-th="학과">0000학과</td>
                                        <td data-th="과목">일본어 회화 01반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="학번">20241***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="점수">86.03</td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input type-regist">
                                                <input type="radio" name="applySeqs" id="chk_44">
                                                <label for="chk_44"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">44</td>
                                        <td data-th="학과">0000학과</td>
                                        <td data-th="과목">일본어 회화 01반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="학번">20241***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="점수">86.03</td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input type-regist">
                                                <input type="radio" name="applySeqs" id="chk_43">
                                                <label for="chk_43"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">43</td>
                                        <td data-th="학과">0000학과</td>
                                        <td data-th="과목">일본어 회화 01반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="학번">20241***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="점수">86.03</td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input type-regist">
                                                <input type="radio" name="applySeqs" id="chk_42">
                                                <label for="chk_42"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">42</td>
                                        <td data-th="학과">0000학과</td>
                                        <td data-th="과목">일본어 회화 01반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="학번">20241***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="점수">86.03</td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input type-regist">
                                                <input type="radio" name="applySeqs" id="chk_41">
                                                <label for="chk_41"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">41</td>
                                        <td data-th="학과">0000학과</td>
                                        <td data-th="과목">일본어 회화 01반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="학번">20241***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="점수">86.03</td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input type-regist">
                                                <input type="radio" name="applySeqs" id="chk_40">
                                                <label for="chk_40"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">40</td>
                                        <td data-th="학과">0000학과</td>
                                        <td data-th="과목">일본어 회화 01반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="학번">20241***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="점수">86.03</td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input type-regist">
                                                <input type="radio" name="applySeqs" id="chk_39">
                                                <label for="chk_39"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">39</td>
                                        <td data-th="학과">0000학과</td>
                                        <td data-th="과목">일본어 회화 01반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="학번">20241***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="점수">86.03</td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input type-regist">
                                                <input type="radio" name="applySeqs" id="chk_38">
                                                <label for="chk_38"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">38</td>
                                        <td data-th="학과">0000학과</td>
                                        <td data-th="과목">일본어 회화 01반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="학번">20241***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="점수">86.03</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                            <table class="table-type5">
                                <colgroup>
                                    <col style="width:15%">
                                    <col>
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th scope="col" class="req">신청사유</th>
                                        <td data-th="신청사유">
                                            <textarea name="" id="" style="width:100%;height:150px"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="col">자료첨부</th>
                                        <td data-th="자료첨부">
											<div id="fileUploader-container" class="dext5-container" style="width:100%;height:180px;"></div>
											<div id="fileUploader-btn-area" class="dext5-btn-area" style=""><button type="button" id="fileUploader_btn-add" style="" title="파일선택">파일선택</button><button type="button" id="fileUploader_btn-delete" disabled='true' style="" title="삭제">삭제</button><button type="button" id="fileUploader_btn-reset" style="display:none" title="초기화" onclick="resetDextFiles('fileUploader')"><i class='xi-refresh'></i></button></div>
											<script>
											UiFileUploader({
												id:"fileUploader",
												parentId:"fileUploader-container",
												btnFile:"fileUploader_btn-add",
												btnDelete:"fileUploader_btn-delete",
												lang:"ko",
												uploadMode:"ORAF",
												maxTotalSize:100,
												maxFileSize:100,
												extensionFilter:"*",
												noExtension:"exe,com,bat,cmd,jsp,msi,html,htm,js,scr,asp,aspx,php,php3,php4,ocx,jar,war,py",
												finishFunc:"finishUpload()",
												uploadUrl:"https://localhost/dext/uploadFileDext.up?type=",
												path:"/bbs",
												fileCount:5,
												oldFiles:[],
												useFileBox:false,
												style:"list",
												uiMode:"normal"
											});
											</script>                                            
                                        </td>
                                    </tr>
                                </tbody>
                            </table>

                        <div class="btns">
                            <button type="button" class="btn type1">저장</button>
                            <button type="button" class="btn type2">닫기</button>
                        </div>
                    </div>
                </div>
            </div><!-- //Modal1 성적처리 로그조회 -->

            <!-- Modal2 성적이의 신청처리 -->
            <div class="modal-overlay" id="modal2">
                <div class="modal-content">
                    <div class="modal-body">

                        <div class="board_top">
                            <h4 class="sub-title">
                                성적이의 신청자
                                <span class="total_txt fs-16px fw-normal ml5">[ 총 건수 : <b>11</b>건 ]</span>
                            </h4>
                            <div class="right-area">
                                <button type="button" class="btn type2 small">엑셀로 다운로드</button>
                            </div>
                        </div>

                        <div class="table-wrap overflow-y">
                            <table class="table-type3">
                                <colgroup>
                                    <col style="width:3%">
                                    <col style="width:5%">
                                    <col>
                                    <col>
                                    <col>
                                    <col style="width:10%">
                                    <col style="width:10%">
                                    <col style="width:10%">
                                    <col style="width:5%">
                                    <col style="width:5%">
                                    <col style="width:5%">
                                    <col style="width:5%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="row">선택</th>
                                        <th scope="row">번호</th>
                                        <th scope="row">학과</th>
                                        <th scope="row">과목</th>
                                        <th scope="row">대표ID</th>
                                        <th scope="row">학번</th>
                                        <th scope="row">이름</th>
                                        <th scope="row">점수</th>
                                        <th scope="row">가산점</th>
                                        <th scope="row">최종점수</th>
                                        <th scope="row">순위</th>
                                        <th scope="row">성적상세</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr class="check_yet">
                                        <td data-th="선택">
                                            <span class="custom-input type-regist">
                                                <input type="radio" name="applySeqs" id="chk_11" checked>
                                                <label for="chk_11"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">11</td>
                                        <td data-th="학과">0000학과</td>
                                        <td data-th="과목">일본어 회화 01반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="학번">20241***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="점수">86.03</td>
                                        <td data-th="가산점">
												<input class="form-control width-100per" type="text" name="addScore" id="addScore" value="" required="true" inputmask="byte" maxLen="10" minLen="4">
                                        </td>
                                        <td data-th="최종점수">91.03</td>
                                        <td data-th="순위">12</td>
                                        <td data-th="성적상세">
                                            <button type="button" class="btn basic small">보기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input type-regist">
                                                <input type="radio" name="applySeqs" id="chk_10" checked>
                                                <label for="chk_10"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">10</td>
                                        <td data-th="학과">0000학과</td>
                                        <td data-th="과목">일본어 회화 01반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="학번">20241***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="점수">89.03</td>
                                        <td data-th="가산점">0</td>
                                        <td data-th="최종점수">89.03</td>
                                        <td data-th="순위">15</td>
                                        <td data-th="성적상세">
                                            <button type="button" class="btn basic small">보기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input type-regist">
                                                <input type="radio" name="applySeqs" id="chk_9" checked>
                                                <label for="chk_9"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">9</td>
                                        <td data-th="학과">0000학과</td>
                                        <td data-th="과목">일본어 회화 01반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="학번">20241***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="점수">89.03</td>
                                        <td data-th="가산점">0</td>
                                        <td data-th="최종점수">89.03</td>
                                        <td data-th="순위">21</td>
                                        <td data-th="성적상세">
                                            <button type="button" class="btn basic small">보기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input type-regist">
                                                <input type="radio" name="applySeqs" id="chk_8" checked>
                                                <label for="chk_8"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">8</td>
                                        <td data-th="학과">0000학과</td>
                                        <td data-th="과목">일본어 회화 01반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="학번">20241***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="점수">89.03</td>
                                        <td data-th="가산점">0</td>
                                        <td data-th="최종점수">89.03</td>
                                        <td data-th="순위">21</td>
                                        <td data-th="성적상세">
                                            <button type="button" class="btn basic small">보기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input type-regist">
                                                <input type="radio" name="applySeqs" id="chk_7" checked>
                                                <label for="chk_7"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">7</td>
                                        <td data-th="학과">0000학과</td>
                                        <td data-th="과목">일본어 회화 01반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="학번">20241***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="점수">89.03</td>
                                        <td data-th="가산점">0</td>
                                        <td data-th="최종점수">89.03</td>
                                        <td data-th="순위">21</td>
                                        <td data-th="성적상세">
                                            <button type="button" class="btn basic small">보기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input type-regist">
                                                <input type="radio" name="applySeqs" id="chk_6" checked>
                                                <label for="chk_6"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">6</td>
                                        <td data-th="학과">0000학과</td>
                                        <td data-th="과목">일본어 회화 01반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="학번">20241***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="점수">89.03</td>
                                        <td data-th="가산점">0</td>
                                        <td data-th="최종점수">89.03</td>
                                        <td data-th="순위">21</td>
                                        <td data-th="성적상세">
                                            <button type="button" class="btn basic small">보기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input type-regist">
                                                <input type="radio" name="applySeqs" id="chk_5" checked>
                                                <label for="chk_5"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">5</td>
                                        <td data-th="학과">0000학과</td>
                                        <td data-th="과목">일본어 회화 01반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="학번">20241***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="점수">89.03</td>
                                        <td data-th="가산점">0</td>
                                        <td data-th="최종점수">89.03</td>
                                        <td data-th="순위">21</td>
                                        <td data-th="성적상세">
                                            <button type="button" class="btn basic small">보기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input type-regist">
                                                <input type="radio" name="applySeqs" id="chk_4" checked>
                                                <label for="chk_4"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">4</td>
                                        <td data-th="학과">0000학과</td>
                                        <td data-th="과목">일본어 회화 01반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="학번">20241***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="점수">89.03</td>
                                        <td data-th="가산점">0</td>
                                        <td data-th="최종점수">89.03</td>
                                        <td data-th="순위">21</td>
                                        <td data-th="성적상세">
                                            <button type="button" class="btn basic small">보기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input type-regist">
                                                <input type="radio" name="applySeqs" id="chk_3" checked>
                                                <label for="chk_3"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">3</td>
                                        <td data-th="학과">0000학과</td>
                                        <td data-th="과목">일본어 회화 01반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="학번">20241***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="점수">89.03</td>
                                        <td data-th="가산점">0</td>
                                        <td data-th="최종점수">89.03</td>
                                        <td data-th="순위">21</td>
                                        <td data-th="성적상세">
                                            <button type="button" class="btn basic small">보기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input type-regist">
                                                <input type="radio" name="applySeqs" id="chk_2" checked>
                                                <label for="chk_2"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">2</td>
                                        <td data-th="학과">0000학과</td>
                                        <td data-th="과목">일본어 회화 01반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="학번">20241***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="점수">89.03</td>
                                        <td data-th="가산점">0</td>
                                        <td data-th="최종점수">89.03</td>
                                        <td data-th="순위">21</td>
                                        <td data-th="성적상세">
                                            <button type="button" class="btn basic small">보기</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <table class="table-type5">
                            <colgroup>
                                <col style="width:15%">
                                <col>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="col" rowspan="2">처리상태 및 처리결과</th>
                                    <td>
                                        <div class="form-inline">
                                            <span class="custom-input">
                                                <input type="radio" name="procStatus" id="proc_APPROVE" value="APPROVE" checked>
                                                <label for="proc_APPROVE">승인(가산점 부여)</label>
                                            </span>
                                            <span class="custom-input ml5">
                                                <input type="radio" name="procStatus" id="proc_CONFIRM" value="CONFIRM">
                                                <label for="proc_CONFIRM">확인(가산점 미부여)</label>
                                            </span>
                                            <span class="custom-input ml5">
                                                <input type="radio" name="procStatus" id="proc_REJECT" value="REJECT">
                                                <label for="proc_REJECT">반려(가산점 미부여)</label>
                                            </span>
                                        </div>                                            
                                    </td>
                                </tr>
                                <tr>
                                    <td data-th="처리상태 및 처리결과">
                                        수고 많았습니다
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <div class="btns">
                            <button type="button" class="btn type1">저장</button>
                            <button type="button" class="btn type2">닫기</button>
                        </div>
                    </div>
                </div>
            </div><!-- //Modal2 성적이의 신청처리 -->

            <!-- Modal3 학습요소별 성적 -->
            <div class="modal-overlay" id="modal3">
                <div class="modal-content">
                    <div class="modal-body">

                        <div class="board_top">
                            <h4 class="sub-title">수강생 정보</h4>
                        </div>

                        <div class="table-wrap mb20">
                            <table class="table-type5">
                                <colgroup>
                                    <col style="width: 10%;">
                                    <col>
                                    <col style="width: 10%;">
                                    <col>
                                    <col style="width: 10%;">
                                    <col>
                                    <col style="width: 10%;">
                                    <col>
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th scope="col">학과</th>
                                        <td data-th="학과">000학과</td>
                                        <th scope="col">대표ID</th>
                                        <td data-th="대표ID">testi**10</td>
                                        <th scope="col">학번</th>
                                        <td data-th="학번">20241***61</td>
                                        <th scope="col">성명</th>
                                        <td data-th="성명">학*자10</td>
                                    </tr>                                    
                                </tbody>
                            </table>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type3">
                                <thead>
                                    <tr>
                                        <th scope="col">구분</th>
                                        <th scope="col">중간고사</th>
                                        <th scope="col">기말고사</th>
                                        <th scope="col">출석</th>
                                        <th scope="col">과제</th>
                                        <th scope="col">토론</th>
                                        <th scope="col">퀴즈</th>
                                        <th scope="col">설문</th>
                                        <th scope="col">세미나</th>
                                        <th scope="col">합계</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="구분">평가비중</td>
                                        <td data-th="중간고사">20%</td>
                                        <td data-th="기말고사">30%</td>
                                        <td data-th="출석">20%</td>
                                        <td data-th="과제">10%</td>
                                        <td data-th="토론">10%</td>
                                        <td data-th="퀴즈">-</td>
                                        <td data-th="설문">-</td>
                                        <td data-th="세미나">10%</td>
                                        <td data-th="합계">100%</td>
                                    </tr>
                                    <tr>
                                        <td data-th="구분">취득점수</td>
                                        <td data-th="중간고사">80.00</td>
                                        <td data-th="기말고사">80.00</td>
                                        <td data-th="출석">80.00</td>
                                        <td data-th="과제">80.00</td>
                                        <td data-th="토론">80.00</td>
                                        <td data-th="퀴즈">-</td>
                                        <td data-th="설문">-</td>
                                        <td data-th="세미나">80.00</td>
                                        <td data-th="합계">480.00</td>
                                    </tr>
                                    <tr>
                                        <td data-th="구분">산출점수</td>
                                        <td data-th="중간고사">16.00</td>
                                        <td data-th="기말고사">24.00</td>
                                        <td data-th="출석">16.00</td>
                                        <td data-th="과제">8.00</td>
                                        <td data-th="토론">8.00</td>
                                        <td data-th="퀴즈">-</td>
                                        <td data-th="설문">-</td>
                                        <td data-th="세미나">8.00</td>
                                        <td data-th="합계">80.00</td>
                                    </tr>
                                    <tr>
                                        <td data-th="구분">가산점</td>
                                        <td data-th="중간고사">-</td>
                                        <td data-th="기말고사">-</td>
                                        <td data-th="출석">-</td>
                                        <td data-th="과제">-</td>
                                        <td data-th="토론">-</td>
                                        <td data-th="퀴즈">-</td>
                                        <td data-th="설문">-</td>
                                        <td data-th="세미나">-</td>
                                        <td data-th="합계">5.00</td>
                                    </tr>
                                    <tr>
                                        <td data-th="구분">기타점수</td>
                                        <td data-th="중간고사">-</td>
                                        <td data-th="기말고사">-</td>
                                        <td data-th="출석">-</td>
                                        <td data-th="과제">-</td>
                                        <td data-th="토론">-</td>
                                        <td data-th="퀴즈">-</td>
                                        <td data-th="설문">-</td>
                                        <td data-th="세미나">-</td>
                                        <td data-th="합계">0.00</td>
                                    </tr>
                                    <tr class="total">
                                        <th data-th="구분">최종점수</th>
                                        <th data-th="중간고사">-</th>
                                        <th data-th="기말고사">-</th>
                                        <th data-th="출석">-</th>
                                        <th data-th="과제">-</th>
                                        <th data-th="토론">-</th>
                                        <th data-th="퀴즈">-</th>
                                        <th data-th="설문">-</th>
                                        <th data-th="세미나">-</th>
                                        <th data-th="합계">85.00</th>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="board_top">
                            <h4 class="sub-title">메모</h4>
                        </div>
                        <div class="form-row">
                            <textarea class="form-control" style="width:100%;height:100px" maxLenCheck="byte,1000,true,false" required="true"></textarea>
                        </div>

                        <div class="btns">
                            <button type="button" class="btn type2">닫기</button>
                        </div>
                    </div>
                </div>
            </div><!-- //Modal3 학습요소별 성적 -->            

        </main>
        <!-- //admin-->
    </div>
</body>
</html>


<script>
$(document).ready(function() {

    $('.modal__btn').on('click', function() {
        const targetModal = $(this).data('target'); 
        const $content = $(targetModal).find('.modal-body');
        
        const title = $(this).text().trim(); 

        UiDialog("dialog1", {
            title: title,
            width: '90%',
            height: 780,
            html: $content
        });
    });


    // 리스트 라디오 버튼 클릭 시 행(tr) 배경색 변경
    $('input[type="radio"][name="applySeqs"]').on('change', function() {
        $('tr.check_yet').removeClass('check_yet');
        
        if ($(this).is(':checked')) {
            $(this).closest('tr').addClass('check_yet');
        }
    });

});
</script>
