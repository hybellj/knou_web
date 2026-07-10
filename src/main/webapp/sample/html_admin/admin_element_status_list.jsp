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
                            <h2 class="page-title">학습요소별 운영현황</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>수업운영도구</li>
                                    <li>과목관리</li>
                                    <li>수업운영</li>
                                    <li><span class="current">학습요소별 운영현황</span></li>
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
                                        <option value="전체">학과</option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="">검색어</label></span>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" name="" id="inputSearch1" value="" placeholder="과목/과목코드 검색">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search">검색</button>
                            </div>
                        </div>


                        <div class="board_top"> 
                            <h3 class="board-title">과목별 운영현황<span class="total_txt fs-16px fw-normal ml5">[ 총 건수 : <b>50</b>건 ]</span></h3>
                            <div class="right-area">
                                <button type="button" class="btn basic">메시지 보내기</button>
                                <button type="button" class="btn type2">엑셀로 다운로드</button>
                            </div>
                        </div>

                        <div class="table-wrap overflow-y overflow-x">
                            <table class="table-type3">
                                <thead>
                                    <tr>
                                        <th scope="col" rowspan="2">번호</th>
                                        <th scope="col" rowspan="2" class="cursor-pointer">기관<i class="xi-arrows-v icon"></i></th>
                                        <th scope="col" rowspan="2">년도</th>
                                        <th scope="col" rowspan="2">학기</th>
                                        <th scope="col" rowspan="2" class="cursor-pointer">학과<i class="xi-arrows-v icon"></i></th>
                                        <th scope="col" rowspan="2">과목코드</th>
                                        <th scope="col" rowspan="2">과목</th>
                                        <th scope="col" rowspan="2">분반</th>
                                        <th scope="col" rowspan="2">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkProfAll" id="chkProfAll">
                                                <label for="chkProfAll">교수</label>
                                            </span>
                                        </th>
                                        <th scope="col" rowspan="2">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkTutorAll" id="chkTutorAll">
                                                <label for="chkTutorAll">튜터</label>
                                            </span>                                            
                                        </th>
                                        <th scope="col" colspan="12">등록 및 개설 현황</th>
                                    </tr>
                                    <tr>
                                        <th scope="col">과목공지</th>
                                        <th scope="col">강의자료실</th>
                                        <th scope="col">강의Q&A</th>
                                        <th scope="col">1:1상담</th>
                                        <th scope="col">과제</th>
                                        <th scope="col">퀴즈</th>
                                        <th scope="col">설문</th>
                                        <th scope="col">토론</th>
                                        <th scope="col">세미나</th>
                                        <th scope="col">시험</th>
                                        <th scope="col">중간고사</th>
                                        <th scope="col">기말고사</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="번호">50</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">유비쿼터스컴퓨팅</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="교수">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkProf" id="chkProf_12">
                                                <label for="chkProf_12">홍*수</label>
                                            </span>                                            
                                        </td>
                                        <td data-th="튜터">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkTutor" id="chkTutor_12">
                                                <label for="chkTutor_12">이*터</label>
                                            </span>
                                        </td>
                                        <td data-th="과목공지">
                                            <span class="cursor-pointer fcBlue">5</span>
                                        </td>
                                        <td data-th="강의자료실">
                                            <span class="cursor-pointer fcBlue">5</span>
                                        </td>
                                        <td data-th="강의Q&A">3/5</td>
                                        <td data-th="1:1상담">3/5</td>
                                        <td data-th="과제">
                                            <span class="cursor-pointer fcBlue">2</span>
                                        </td>
                                        <td data-th="퀴즈">
                                            <span class="fcRed">0</span>
                                        </td>
                                        <td data-th="설문">
                                            <span class="fcRed">사용안함</span>
                                        </td>
                                        <td data-th="토론">
                                            <span class="fcBlue">2</span>
                                        </td>
                                        <td data-th="세미나">
                                            <span class="fcBlue">2</span>
                                        </td>
                                        <td data-th="시험">
                                            <span class="fcRed">사용안함</span>
                                        </td>
                                        <td data-th="중간고사">
                                            <span class="cursor-pointer fcBlue">퀴즈</span>
                                        </td>
                                        <td data-th="기말고사">
                                            <span class="cursor-pointer fcBlue">실시간온라인</span>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td data-th="번호">50</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">유비쿼터스컴퓨팅</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="교수">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkProf" id="chkProf_12">
                                                <label for="chkProf_12">홍*수</label>
                                            </span>                                            
                                        </td>
                                        <td data-th="튜터">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkTutor" id="chkTutor_12">
                                                <label for="chkTutor_12">이*터</label>
                                            </span>
                                        </td>
                                        <td data-th="과목공지">
                                            <span class="cursor-pointer fcBlue">5</span>
                                        </td>
                                        <td data-th="강의자료실">
                                            <span class="cursor-pointer fcBlue">5</span>
                                        </td>
                                        <td data-th="강의Q&A">3/5</td>
                                        <td data-th="1:1상담">3/5</td>
                                        <td data-th="과제">
                                            <span class="cursor-pointer fcBlue">2</span>
                                        </td>
                                        <td data-th="퀴즈">
                                            <span class="fcRed">0</span>
                                        </td>
                                        <td data-th="설문">
                                            <span class="fcRed">사용안함</span>
                                        </td>
                                        <td data-th="토론">
                                            <span class="fcBlue">2</span>
                                        </td>
                                        <td data-th="세미나">
                                            <span class="fcBlue">2</span>
                                        </td>
                                        <td data-th="시험">
                                            <span class="fcRed">사용안함</span>
                                        </td>
                                        <td data-th="중간고사">
                                            <span class="cursor-pointer fcBlue">퀴즈</span>
                                        </td>
                                        <td data-th="기말고사">
                                            <span class="cursor-pointer fcBlue">실시간온라인</span>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td data-th="번호">49</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">유비쿼터스컴퓨팅</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="교수">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkProf" id="chkProf_49">
                                                <label for="chkProf_12">홍*수</label>
                                            </span>                                            
                                        </td>
                                        <td data-th="튜터">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkTutor" id="chkTutor_49">
                                                <label for="chkTutor_12">이*터</label>
                                            </span>
                                        </td>
                                        <td data-th="과목공지">
                                            <span class="cursor-pointer fcBlue">5</span>
                                        </td>
                                        <td data-th="강의자료실">
                                            <span class="cursor-pointer fcBlue">5</span>
                                        </td>
                                        <td data-th="강의Q&A">3/5</td>
                                        <td data-th="1:1상담">3/5</td>
                                        <td data-th="과제">
                                            <span class="cursor-pointer fcBlue">2</span>
                                        </td>
                                        <td data-th="퀴즈">
                                            <span class="fcRed">0</span>
                                        </td>
                                        <td data-th="설문">
                                            <span class="fcRed">사용안함</span>
                                        </td>
                                        <td data-th="토론">
                                            <span class="fcBlue">2</span>
                                        </td>
                                        <td data-th="세미나">
                                            <span class="fcBlue">2</span>
                                        </td>
                                        <td data-th="시험">
                                            <span class="fcRed">사용안함</span>
                                        </td>
                                        <td data-th="중간고사">
                                            <span class="cursor-pointer fcBlue">퀴즈</span>
                                        </td>
                                        <td data-th="기말고사">
                                            <span class="cursor-pointer fcBlue">실시간온라인</span>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td data-th="번호">48</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">유비쿼터스컴퓨팅</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="교수">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkProf" id="chkProf_48">
                                                <label for="chkProf_12">홍*수</label>
                                            </span>                                            
                                        </td>
                                        <td data-th="튜터">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkTutor" id="chkTutor_48">
                                                <label for="chkTutor_12">이*터</label>
                                            </span>
                                        </td>
                                        <td data-th="과목공지">
                                            <span class="cursor-pointer fcBlue">5</span>
                                        </td>
                                        <td data-th="강의자료실">
                                            <span class="cursor-pointer fcBlue">5</span>
                                        </td>
                                        <td data-th="강의Q&A">3/5</td>
                                        <td data-th="1:1상담">3/5</td>
                                        <td data-th="과제">
                                            <span class="cursor-pointer fcBlue">2</span>
                                        </td>
                                        <td data-th="퀴즈">
                                            <span class="fcRed">0</span>
                                        </td>
                                        <td data-th="설문">
                                            <span class="fcRed">사용안함</span>
                                        </td>
                                        <td data-th="토론">
                                            <span class="fcBlue">2</span>
                                        </td>
                                        <td data-th="세미나">
                                            <span class="fcBlue">2</span>
                                        </td>
                                        <td data-th="시험">
                                            <span class="fcRed">사용안함</span>
                                        </td>
                                        <td data-th="중간고사">
                                            <span class="cursor-pointer fcBlue">퀴즈</span>
                                        </td>
                                        <td data-th="기말고사">
                                            <span class="cursor-pointer fcBlue">실시간온라인</span>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td data-th="번호">47</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">유비쿼터스컴퓨팅</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="교수">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkProf" id="chkProf_47">
                                                <label for="chkProf_12">홍*수</label>
                                            </span>                                            
                                        </td>
                                        <td data-th="튜터">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkTutor" id="chkTutor_47">
                                                <label for="chkTutor_12">이*터</label>
                                            </span>
                                        </td>
                                        <td data-th="과목공지">
                                            <span class="cursor-pointer fcBlue">5</span>
                                        </td>
                                        <td data-th="강의자료실">
                                            <span class="cursor-pointer fcBlue">5</span>
                                        </td>
                                        <td data-th="강의Q&A">3/5</td>
                                        <td data-th="1:1상담">3/5</td>
                                        <td data-th="과제">
                                            <span class="cursor-pointer fcBlue">2</span>
                                        </td>
                                        <td data-th="퀴즈">
                                            <span class="fcRed">0</span>
                                        </td>
                                        <td data-th="설문">
                                            <span class="fcRed">사용안함</span>
                                        </td>
                                        <td data-th="토론">
                                            <span class="fcBlue">2</span>
                                        </td>
                                        <td data-th="세미나">
                                            <span class="fcBlue">2</span>
                                        </td>
                                        <td data-th="시험">
                                            <span class="fcRed">사용안함</span>
                                        </td>
                                        <td data-th="중간고사">
                                            <span class="cursor-pointer fcBlue">퀴즈</span>
                                        </td>
                                        <td data-th="기말고사">
                                            <span class="cursor-pointer fcBlue">실시간온라인</span>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td data-th="번호">46</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">유비쿼터스컴퓨팅</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="교수">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkProf" id="chkProf_46">
                                                <label for="chkProf_12">홍*수</label>
                                            </span>                                            
                                        </td>
                                        <td data-th="튜터">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkTutor" id="chkTutor_46">
                                                <label for="chkTutor_12">이*터</label>
                                            </span>
                                        </td>
                                        <td data-th="과목공지">
                                            <span class="cursor-pointer fcBlue">5</span>
                                        </td>
                                        <td data-th="강의자료실">
                                            <span class="cursor-pointer fcBlue">5</span>
                                        </td>
                                        <td data-th="강의Q&A">3/5</td>
                                        <td data-th="1:1상담">3/5</td>
                                        <td data-th="과제">
                                            <span class="cursor-pointer fcBlue">2</span>
                                        </td>
                                        <td data-th="퀴즈">
                                            <span class="fcRed">0</span>
                                        </td>
                                        <td data-th="설문">
                                            <span class="fcRed">사용안함</span>
                                        </td>
                                        <td data-th="토론">
                                            <span class="fcBlue">2</span>
                                        </td>
                                        <td data-th="세미나">
                                            <span class="fcBlue">2</span>
                                        </td>
                                        <td data-th="시험">
                                            <span class="fcRed">사용안함</span>
                                        </td>
                                        <td data-th="중간고사">
                                            <span class="cursor-pointer fcBlue">퀴즈</span>
                                        </td>
                                        <td data-th="기말고사">
                                            <span class="cursor-pointer fcBlue">실시간온라인</span>
                                        </td>
                                    </tr>


                                    <tr>
                                        <td data-th="번호">45</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">유비쿼터스컴퓨팅</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="교수">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkProf" id="chkProf_45">
                                                <label for="chkProf_12">홍*수</label>
                                            </span>                                            
                                        </td>
                                        <td data-th="튜터">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkTutor" id="chkTutor_45">
                                                <label for="chkTutor_12">이*터</label>
                                            </span>
                                        </td>
                                        <td data-th="과목공지">
                                            <span class="cursor-pointer fcBlue">5</span>
                                        </td>
                                        <td data-th="강의자료실">
                                            <span class="cursor-pointer fcBlue">5</span>
                                        </td>
                                        <td data-th="강의Q&A">3/5</td>
                                        <td data-th="1:1상담">3/5</td>
                                        <td data-th="과제">
                                            <span class="cursor-pointer fcBlue">2</span>
                                        </td>
                                        <td data-th="퀴즈">
                                            <span class="fcRed">0</span>
                                        </td>
                                        <td data-th="설문">
                                            <span class="fcRed">사용안함</span>
                                        </td>
                                        <td data-th="토론">
                                            <span class="fcBlue">2</span>
                                        </td>
                                        <td data-th="세미나">
                                            <span class="fcBlue">2</span>
                                        </td>
                                        <td data-th="시험">
                                            <span class="fcRed">사용안함</span>
                                        </td>
                                        <td data-th="중간고사">
                                            <span class="cursor-pointer fcBlue">퀴즈</span>
                                        </td>
                                        <td data-th="기말고사">
                                            <span class="cursor-pointer fcBlue">실시간온라인</span>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td data-th="번호">44</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">유비쿼터스컴퓨팅</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="교수">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkProf" id="chkProf_44">
                                                <label for="chkProf_12">홍*수</label>
                                            </span>                                            
                                        </td>
                                        <td data-th="튜터">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkTutor" id="chkTutor_44">
                                                <label for="chkTutor_12">이*터</label>
                                            </span>
                                        </td>
                                        <td data-th="과목공지">
                                            <span class="cursor-pointer fcBlue">5</span>
                                        </td>
                                        <td data-th="강의자료실">
                                            <span class="cursor-pointer fcBlue">5</span>
                                        </td>
                                        <td data-th="강의Q&A">3/5</td>
                                        <td data-th="1:1상담">3/5</td>
                                        <td data-th="과제">
                                            <span class="cursor-pointer fcBlue">2</span>
                                        </td>
                                        <td data-th="퀴즈">
                                            <span class="fcRed">0</span>
                                        </td>
                                        <td data-th="설문">
                                            <span class="fcRed">사용안함</span>
                                        </td>
                                        <td data-th="토론">
                                            <span class="fcBlue">2</span>
                                        </td>
                                        <td data-th="세미나">
                                            <span class="fcBlue">2</span>
                                        </td>
                                        <td data-th="시험">
                                            <span class="fcRed">사용안함</span>
                                        </td>
                                        <td data-th="중간고사">
                                            <span class="cursor-pointer fcBlue">퀴즈</span>
                                        </td>
                                        <td data-th="기말고사">
                                            <span class="cursor-pointer fcBlue">실시간온라인</span>
                                        </td>
                                    </tr>


                                </tbody>
                            </table>
                        </div>




                    </div>
                </div>

                <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                <div class="modal-btn-box mt30">
                    <button type="button" class="btn modal__btn" id="btn-modal1" data-target="#modal1">학습요소별 운영현황 상세</button>
                </div>
                <!--// modal popup 보여주기 버튼(개발시 삭제) -->


            </div>
            <!-- //content -->


            <!-- Modal1 학습요소별 운영현황 상세 -->
            <div class="modal-overlay" id="modal1">
                <div class="modal-content">
                    <div class="modal-body">

                        <div class="board_top">
                            <i class="icon-svg-openbook"></i>
                            <h3 class="board-title">공지사항
                                <span class="total_txt fs-16px fw-normal ml5">[ 총 건수 : <b>5</b>건 ]</span>
                            </h3>
                        </div>

                        <!--table-type2-->
                        <div class="table-wrap mb40">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:7%">
                                    <col style="">
                                    <col style="width:10%">
                                    <col style="width:7%">
                                    <col style="width:6%">
                                    <col style="width:6%">
                                    <col style="width:6%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>번호</th>
                                        <th>제목</th>
                                        <th>등록일</th>
                                        <th>등록자</th>
                                        <th>읽음</th>
                                        <th>댓글</th>
                                        <th>첨부</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="번호">
                                            <label class="label s_c01">고정</label>
                                        </td>
                                        <td data-th="제목" class="t_left">
                                            <a href="#0" class="title link">공지사항 제목입니다.<i class="xi-new icon" aria-hidden="true"></i><span class="sr-only">새글</span></a>
                                        </td>
                                        <td data-th="등록일">2025.10.20</td>
                                        <td data-th="등록자">운영자</td>
                                        <td data-th="읽음">45</td>
                                        <td data-th="댓글">5</td>
                                        <td data-th="첨부">
                                            <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">
                                            <label class="label s_c02">중요</label>
                                        </td>
                                        <td data-th="제목" class="t_left">
                                            <a href="#0" class="title link">공지사항 제목입니다.</a>
                                        </td>
                                        <td data-th="등록일">2025.10.20</td>
                                        <td data-th="등록자">운영자</td>
                                        <td data-th="읽음">45</td>
                                        <td data-th="댓글">5</td>
                                        <td data-th="첨부">
                                            <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">90</td>
                                        <td data-th="제목" class="t_left">
                                            <a href="#0" class="title link">공지사항 제목입니다.</a>
                                        </td>
                                        <td data-th="등록일">2025.10.20</td>
                                        <td data-th="등록자">운영자</td>
                                        <td data-th="읽음">45</td>
                                        <td data-th="댓글">5</td>
                                        <td data-th="첨부">
                                            <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <!--//table-type2-->

                        <div class="board_top">
                            <h4 class="sub-title">수강생
                                <span class="total_txt fs-16px fw-normal ml5">[ 총 건수 : <b>50</b>건 ]</span>
                            </h4>
                            <div class="right-area">
                                <button class="btn basic">메시지 보내기</button>
                            </div>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type3">
                                <colgroup>
                                    <col width="3%">
                                    <col width="10%">
                                    <col width="">
                                    <col width="">
                                    <col width="">
                                    <col width="">
                                    <col width="10%">
                                    <col width="5%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="subject_chkall">
                                                <label for="subject_chkall"></label>
                                            </span>
                                        </th>
                                        <th scope="col">번호</th>
                                        <th scope="col">기관</th>
                                        <th scope="col">학과/부서</th>
                                        <th scope="col">대표ID</th>
                                        <th scope="col">학번</th>
                                        <th scope="col">이름</th>
                                        <th class="cursor-pointer">읽음<i class="xi-arrows-v icon"></i></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk50"><label for="chk50"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">50</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학과/부서">0000학과</td>
                                        <td data-th="대표ID">testi**1</td>
                                        <td data-th="학번">20212***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="읽음">
                                            <i class="icon-svg-yes fcBlue" aria-hidden="true" aria-label="YES"></i>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk49"><label for="chk49"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">49</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학과/부서">0000학과</td>
                                        <td data-th="대표ID">testi**1</td>
                                        <td data-th="학번">20212***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="읽음">
                                            <i class="icon-svg-no fcRed" aria-hidden="true" aria-label="NO"></i>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk48"><label for="chk48"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">48</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학과/부서">0000학과</td>
                                        <td data-th="대표ID">testi**1</td>
                                        <td data-th="학번">20212***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="읽음">
                                            <i class="icon-svg-no fcRed" aria-hidden="true" aria-label="NO"></i>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk47"><label for="chk47"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">47</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학과/부서">0000학과</td>
                                        <td data-th="대표ID">testi**1</td>
                                        <td data-th="학번">20212***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="읽음">
                                            <i class="icon-svg-no fcRed" aria-hidden="true" aria-label="NO"></i>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk46"><label for="chk46"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">46</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학과/부서">0000학과</td>
                                        <td data-th="대표ID">testi**1</td>
                                        <td data-th="학번">20212***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="읽음">
                                            <i class="icon-svg-no fcRed" aria-hidden="true" aria-label="NO"></i>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk45"><label for="chk45"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">45</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학과/부서">0000학과</td>
                                        <td data-th="대표ID">testi**1</td>
                                        <td data-th="학번">20212***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="읽음">
                                            <i class="icon-svg-no fcRed" aria-hidden="true" aria-label="NO"></i>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk44"><label for="chk44"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">44</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학과/부서">0000학과</td>
                                        <td data-th="대표ID">testi**1</td>
                                        <td data-th="학번">20212***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="읽음">
                                            <i class="icon-svg-no fcRed" aria-hidden="true" aria-label="NO"></i>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk43"><label for="chk43"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">43</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학과/부서">0000학과</td>
                                        <td data-th="대표ID">testi**1</td>
                                        <td data-th="학번">20212***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="읽음">
                                            <i class="icon-svg-no fcRed" aria-hidden="true" aria-label="NO"></i>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk42"><label for="chk42"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">42</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학과/부서">0000학과</td>
                                        <td data-th="대표ID">testi**1</td>
                                        <td data-th="학번">20212***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="읽음">
                                            <i class="icon-svg-no fcRed" aria-hidden="true" aria-label="NO"></i>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk41"><label for="chk41"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">41</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학과/부서">0000학과</td>
                                        <td data-th="대표ID">testi**1</td>
                                        <td data-th="학번">20212***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="읽음">
                                            <i class="icon-svg-no fcRed" aria-hidden="true" aria-label="NO"></i>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btns mb20">
                            <button type="button" class="btn type2">닫기</button>
                        </div>                        

                    </div>
                </div>
            </div>            

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
});
</script>