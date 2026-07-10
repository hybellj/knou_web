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
                            <h2 class="page-title">성적처리현황</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>수업운영도구</li>
                                    <li>과목관리</li>
                                    <li>성적관리</li>
                                    <li><span class="current">성적처리현황</span></li>
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
                                        <option value="전체">학과</option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectSearch">성적산출단계</label></span>
                                <div class="itemList">
                                    <div class="checkbox_type">
                                        <span class="custom-input">
                                            <input type="checkbox" name="name" id="checkType1">
                                            <label for="checkType1">산출 전</label>
                                        </span>
                                        <span class="custom-input">
                                            <input type="checkbox" name="name" id="checkType2">
                                            <label for="checkType2">선출 중</label>
                                        </span>
                                        <span class="custom-input">
                                            <input type="checkbox" name="name" id="checkType3">
                                            <label for="checkType3">최종확정</label>
                                        </span>
                                        <span class="custom-input">
                                            <input type="checkbox" name="name" id="checkType4">
                                            <label for="checkType4">평가취소</label>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="">검색어</label></span>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" name="" id="inputSearch1" value="" placeholder="과목/과목코드/교수 검색">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search">검색</button>
                            </div>
                        </div>
                        
                        
                        <div class="board_top"> 
                            <h3 class="board-title">목록<span class="total_txt fs-16px fw-normal ml5">[ 총 건수 : <b>12</b>건 ]</span></h3>
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
                                <thead>
                                    <tr>
                                        <th scope="col" rowspan="2">번호</th>
                                        <th scope="col" rowspan="2" class="cursor-pointer">기관<i class="xi-arrows-v icon"></i></th>
                                        <th scope="col" rowspan="2" class="cursor-pointer">년도<i class="xi-arrows-v icon"></i></th>
                                        <th scope="col" rowspan="2" class="cursor-pointer">학기<i class="xi-arrows-v icon"></i></th>
                                        <th scope="col" rowspan="2">학과</th>
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
                                        <th scope="col" rowspan="2">기간 예외</th>
                                        <th scope="col" colspan="4">성적 산출 단계</th>
                                        <th scope="col" rowspan="2">성적<br>처리로그</th>
                                    </tr>
                                    <tr>
                                        <th scope="col">산출 전</th>
                                        <th scope="col">산출 중</th>
                                        <th scope="col">최종확정</th>
                                        <th scope="col">평가취소</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="번호">12</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">유비쿼터스컴퓨팅</td>
                                        <td data-th="분반">1반</td>
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
                                        <td data-th="기간 예외" class="fcRed">Y</td>
                                        <td data-th="산출 전">
                                            <span class="state_ok">●</span>
                                        </td>
                                        <td data-th="산출 중">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="최종확정">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="평가취소">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="성적 처리로그">
                                            <button type="button" class="btn basic small">보기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">11</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">데이터베이스특록</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="교수">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkProf" id="chkProf_11">
                                                <label for="chkProf_11">김*아</label>
                                            </span>                                            
                                        </td>
                                        <td data-th="튜터">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkTutor" id="chkTutor_11">
                                                <label for="chkTutor_11">최*터</label>
                                            </span>
                                        </td>
                                        <td data-th="기간 예외">N</td>
                                        <td data-th="산출 전">
                                            <span class="state_ok">●</span>
                                        </td>
                                        <td data-th="산출 중">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="최종확정">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="평가취소">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="성적 처리로그">
                                            <button type="button" class="btn basic small">보기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">10</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">실용중국어학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">중국어코퍼스언어학</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="교수">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkProf" id="chkProf_10">
                                                <label for="chkProf_10">이*수</label>
                                            </span>                                            
                                        </td>
                                        <td data-th="튜터">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkTutor" id="chkTutor_10">
                                                <label for="chkTutor_10">박*터</label>
                                            </span>
                                        </td>
                                        <td data-th="기간 예외">N</td>
                                        <td data-th="산출 전">
                                            <span class="state_ok">●</span>
                                        </td>
                                        <td data-th="산출 중">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="최종확정">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="평가취소">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="성적 처리로그">
                                            <button type="button" class="btn basic small">보기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">9</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">실용중국어학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">중한통번역연습</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="교수">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkProf" id="chkProf_9">
                                                <label for="chkProf_9">최*수</label>
                                            </span>                                            
                                        </td>
                                        <td data-th="튜터">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkTutor" id="chkTutor_9">
                                                <label for="chkTutor_9">김*터</label>
                                            </span>
                                        </td>
                                        <td data-th="기간 예외">N</td>
                                        <td data-th="산출 전">
                                            <span class="state_ok">●</span>
                                        </td>
                                        <td data-th="산출 중">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="최종확정">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="평가취소">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="성적 처리로그">
                                            <button type="button" class="btn basic small">보기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">8</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">행정학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">정책과정론</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="교수">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkProf" id="chkProf_8">
                                                <label for="chkProf_8">박*수</label>
                                            </span>                                            
                                        </td>
                                        <td data-th="튜터">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkTutor" id="chkTutor_8">
                                                <label for="chkTutor_8">유*터</label>
                                            </span>
                                        </td>
                                        <td data-th="기간 예외">N</td>
                                        <td data-th="산출 전">
                                            <span class="state_ok">●</span>
                                        </td>
                                        <td data-th="산출 중">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="최종확정">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="평가취소">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="성적 처리로그">
                                            <button type="button" class="btn basic small">보기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">7</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">행정학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">인사해정세미나</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="교수">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkProf" id="chkProf_7">
                                                <label for="chkProf_7">염*수</label>
                                            </span>                                            
                                        </td>
                                        <td data-th="튜터">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkTutor" id="chkTutor_7">
                                                <label for="chkTutor_7">송*터</label>
                                            </span>
                                        </td>
                                        <td data-th="기간 예외">N</td>
                                        <td data-th="산출 전">
                                            <span class="state_ok">●</span>
                                        </td>
                                        <td data-th="산출 중">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="최종확정">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="평가취소">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="성적 처리로그">
                                            <button type="button" class="btn basic small">보기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">6</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">평생교육학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">교수설계특론</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="교수">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkProf" id="chkProf_6">
                                                <label for="chkProf_6">최*민</label>
                                            </span>                                            
                                        </td>
                                        <td data-th="튜터">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkTutor" id="chkTutor_6">
                                                <label for="chkTutor_6">홍*터</label>
                                            </span>
                                        </td>
                                        <td data-th="기간 예외">N</td>
                                        <td data-th="산출 전">
                                            <span class="state_ok">●</span>
                                        </td>
                                        <td data-th="산출 중">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="최종확정">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="평가취소">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="성적 처리로그">
                                            <button type="button" class="btn basic small">보기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">5</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">평생교육학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">직업진로설계세미나</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="교수">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkProf" id="chkProf_5">
                                                <label for="chkProf_5">유*수</label>
                                            </span>                                            
                                        </td>
                                        <td data-th="튜터">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkTutor" id="chkTutor_5">
                                                <label for="chkTutor_5">정*터</label>
                                            </span>
                                        </td>
                                        <td data-th="기간 예외">N</td>
                                        <td data-th="산출 전">
                                            <span class="state_ok">●</span>
                                        </td>
                                        <td data-th="산출 중">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="최종확정">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="평가취소">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="성적 처리로그">
                                            <button type="button" class="btn basic small">보기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">4</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">간호학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">간호이론총론</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="교수">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkProf" id="chkProf_4">
                                                <label for="chkProf_4">정*호</label>
                                            </span>                                            
                                        </td>
                                        <td data-th="튜터">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkTutor" id="chkTutor_4">
                                                <label for="chkTutor_4">최*터</label>
                                            </span>
                                        </td>
                                        <td data-th="기간 예외">N</td>
                                        <td data-th="산출 전">
                                            <span class="state_ok">●</span>
                                        </td>
                                        <td data-th="산출 중">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="최종확정">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="평가취소">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="성적 처리로그">
                                            <button type="button" class="btn basic small">보기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">3</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">간호학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">상급건강사정</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="교수">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkProf" id="chkProf_3">
                                                <label for="chkProf_3">남*우</label>
                                            </span>                                            
                                        </td>
                                        <td data-th="튜터">
                                            <span class="custom-input">
                                                <input type="checkbox" name="chkTutor" id="chkTutor_3">
                                                <label for="chkTutor_3">김*터</label>
                                            </span>
                                        </td>
                                        <td data-th="기간 예외">N</td>
                                        <td data-th="산출 전">
                                            <span class="state_ok">●</span>
                                        </td>
                                        <td data-th="산출 중">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="최종확정">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="평가취소">
                                            <span class="state_ok">○</span>
                                        </td>
                                        <td data-th="성적 처리로그">
                                            <button type="button" class="btn basic small">보기</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                    </div>
                </div>


                <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                <div class="modal-btn-box mt30">
                    <button type="button" class="btn modal__btn" id="btn-modal1">성적처리 로그조회</button>
                </div>
                <!--// modal popup 보여주기 버튼(개발시 삭제) -->

            </div>
            <!-- //content -->

            <!-- Modal1 성적처리 로그조회 -->
            <div class="modal-overlay" id="modal1">
                <div class="modal-content">
                    <div class="modal-body">

                        <div class="board_top">
                            <h4 class="sub-title">과목 정보</h4>
                        </div>
                        
                        <div class="table-wrap">
                            <table class="table-type5">
                                <colgroup>
                                    <col style="width:15%">
                                    <col>
                                    <col style="width:15%">
                                    <col>
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th scope="row">과목코드</th>
                                        <td data-th="과목코드">CU254835</td>
                                        <th scope="row">분반</th>
                                        <td data-th="분반">1반</td>
                                    </tr>
                                    <tr>
                                        <th scope="row">과목명(한글)</th>
                                        <td data-th="과목명(한글)">유비쿼터스컴퓨팅</td>
                                        <th scope="row">과목명(영문)</th>
                                        <td data-th="과목명(영문)">CHEMISTRY</td>
                                    </tr>
                                    <tr>
                                        <th scope="row">학과</th>
                                        <td data-th="학과">정보과학과</td>
                                        <th scope="row">학점:강의/실습</th>
                                        <td data-th="학점:강의/실습">3 : 3 / 0</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="board_top">
                            <h4 class="sub-title">수강생
                                <span class="total_txt fs-16px fw-normal ml5">[ 총 건수 : <b>56</b>건 ]</span>
                            </h4>
                            <div class="right-area">
                                <div class="search-typeC">
                                    <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="대표ID/이름 입력" autocomplete="off">
                                    <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                                </div>
                            </div>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type3">
                                <colgroup>
                                    <col style="width:5%">
                                    <col style="width:10%">
                                    <col style="width:7%">
                                    <col style="width:7%">
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
                                    <col style="width:10%">
                                    <col>
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">번호</th>
                                        <th scope="col">학과</th>
                                        <th scope="col">대표ID</th>
                                        <th scope="col">학번</th>
                                        <th scope="col">이름</th>
                                        <th scope="col">변경</th>
                                        <th scope="col">중간</th>
                                        <th scope="col">기말</th>
                                        <th scope="col">출석</th>
                                        <th scope="col">과제</th>
                                        <th scope="col">토론</th>
                                        <th scope="col">퀴즈</th>
                                        <th scope="col">설문</th>
                                        <th scope="col">세미나</th>
                                        <th scope="col">시험</th>
                                        <th scope="col">기타</th>
                                        <th scope="col">최종</th>
                                        <th scope="col">처리일시</th>
                                        <th scope="col">처리자</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="번호" rowspan="2">56</td>
                                        <td data-th="학과" rowspan="2">정보과학과</td>
                                        <td data-th="대표ID" rowspan="2">testi**01</td>
                                        <td data-th="학번" rowspan="2">231548***58</td>
                                        <td data-th="이름" rowspan="2">학*자01</td>
                                        <td data-th="변경">전</td>
                                        <td data-th="중간">90</td>
                                        <td data-th="기말">90</td>
                                        <td data-th="출석">90</td>
                                        <td data-th="과제">90</td>
                                        <td data-th="토론">90</td>
                                        <td data-th="퀴즈">90</td>
                                        <td data-th="설문">90</td>
                                        <td data-th="세미나">90</td>
                                        <td data-th="시험">90</td>
                                        <td data-th="기타">0</td>
                                        <td data-th="최종">90</td>
                                        <td data-th="처리일시" rowspan="2">2026.07.26 17:35</td>
                                        <td data-th="처리자" rowspan="2">홍*수</td>
                                    </tr>
                                    <tr>
                                        <td>후</td>
                                        <td class="fcBlue">95</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">95</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">100</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">5</td>
                                        <td class="fcBlue">92.17</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호" rowspan="2">55</td>
                                        <td data-th="학과" rowspan="2">정보과학과</td>
                                        <td data-th="대표ID" rowspan="2">testi**01</td>
                                        <td data-th="학번" rowspan="2">231548***58</td>
                                        <td data-th="이름" rowspan="2">학*자01</td>
                                        <td data-th="변경">전</td>
                                        <td data-th="중간">90</td>
                                        <td data-th="기말">90</td>
                                        <td data-th="출석">90</td>
                                        <td data-th="과제">90</td>
                                        <td data-th="토론">90</td>
                                        <td data-th="퀴즈">90</td>
                                        <td data-th="설문">90</td>
                                        <td data-th="세미나">90</td>
                                        <td data-th="시험">90</td>
                                        <td data-th="기타">0</td>
                                        <td data-th="최종">90</td>
                                        <td data-th="처리일시" rowspan="2">2026.07.26 17:35</td>
                                        <td data-th="처리자" rowspan="2">홍*수</td>
                                    </tr>
                                    <tr>
                                        <td>후</td>
                                        <td class="fcBlue">95</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">95</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">100</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">5</td>
                                        <td class="fcBlue">92.17</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호" rowspan="2">54</td>
                                        <td data-th="학과" rowspan="2">정보과학과</td>
                                        <td data-th="대표ID" rowspan="2">testi**01</td>
                                        <td data-th="학번" rowspan="2">231548***58</td>
                                        <td data-th="이름" rowspan="2">학*자01</td>
                                        <td data-th="변경">전</td>
                                        <td data-th="중간">90</td>
                                        <td data-th="기말">90</td>
                                        <td data-th="출석">90</td>
                                        <td data-th="과제">90</td>
                                        <td data-th="토론">90</td>
                                        <td data-th="퀴즈">90</td>
                                        <td data-th="설문">90</td>
                                        <td data-th="세미나">90</td>
                                        <td data-th="시험">90</td>
                                        <td data-th="기타">0</td>
                                        <td data-th="최종">90</td>
                                        <td data-th="처리일시" rowspan="2">2026.07.26 17:35</td>
                                        <td data-th="처리자" rowspan="2">홍*수</td>
                                    </tr>
                                    <tr>
                                        <td>후</td>
                                        <td class="fcBlue">95</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">95</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">100</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">5</td>
                                        <td class="fcBlue">92.17</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호" rowspan="2">53</td>
                                        <td data-th="학과" rowspan="2">정보과학과</td>
                                        <td data-th="대표ID" rowspan="2">testi**01</td>
                                        <td data-th="학번" rowspan="2">231548***58</td>
                                        <td data-th="이름" rowspan="2">학*자01</td>
                                        <td data-th="변경">전</td>
                                        <td data-th="중간">90</td>
                                        <td data-th="기말">90</td>
                                        <td data-th="출석">90</td>
                                        <td data-th="과제">90</td>
                                        <td data-th="토론">90</td>
                                        <td data-th="퀴즈">90</td>
                                        <td data-th="설문">90</td>
                                        <td data-th="세미나">90</td>
                                        <td data-th="시험">90</td>
                                        <td data-th="기타">0</td>
                                        <td data-th="최종">90</td>
                                        <td data-th="처리일시" rowspan="2">2026.07.26 17:35</td>
                                        <td data-th="처리자" rowspan="2">홍*수</td>
                                    </tr>
                                    <tr>
                                        <td>후</td>
                                        <td class="fcBlue">95</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">95</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">100</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">5</td>
                                        <td class="fcBlue">92.17</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호" rowspan="2">52</td>
                                        <td data-th="학과" rowspan="2">정보과학과</td>
                                        <td data-th="대표ID" rowspan="2">testi**01</td>
                                        <td data-th="학번" rowspan="2">231548***58</td>
                                        <td data-th="이름" rowspan="2">학*자01</td>
                                        <td data-th="변경">전</td>
                                        <td data-th="중간">90</td>
                                        <td data-th="기말">90</td>
                                        <td data-th="출석">90</td>
                                        <td data-th="과제">90</td>
                                        <td data-th="토론">90</td>
                                        <td data-th="퀴즈">90</td>
                                        <td data-th="설문">90</td>
                                        <td data-th="세미나">90</td>
                                        <td data-th="시험">90</td>
                                        <td data-th="기타">0</td>
                                        <td data-th="최종">90</td>
                                        <td data-th="처리일시" rowspan="2">2026.07.26 17:35</td>
                                        <td data-th="처리자" rowspan="2">홍*수</td>
                                    </tr>
                                    <tr>
                                        <td>후</td>
                                        <td class="fcBlue">95</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">95</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">100</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">5</td>
                                        <td class="fcBlue">92.17</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호" rowspan="2">51</td>
                                        <td data-th="학과" rowspan="2">정보과학과</td>
                                        <td data-th="대표ID" rowspan="2">testi**01</td>
                                        <td data-th="학번" rowspan="2">231548***58</td>
                                        <td data-th="이름" rowspan="2">학*자01</td>
                                        <td data-th="변경">전</td>
                                        <td data-th="중간">90</td>
                                        <td data-th="기말">90</td>
                                        <td data-th="출석">90</td>
                                        <td data-th="과제">90</td>
                                        <td data-th="토론">90</td>
                                        <td data-th="퀴즈">90</td>
                                        <td data-th="설문">90</td>
                                        <td data-th="세미나">90</td>
                                        <td data-th="시험">90</td>
                                        <td data-th="기타">0</td>
                                        <td data-th="최종">90</td>
                                        <td data-th="처리일시" rowspan="2">2026.07.26 17:35</td>
                                        <td data-th="처리자" rowspan="2">홍*수</td>
                                    </tr>
                                    <tr>
                                        <td>후</td>
                                        <td class="fcBlue">95</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">95</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">100</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">5</td>
                                        <td class="fcBlue">92.17</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호" rowspan="2">50</td>
                                        <td data-th="학과" rowspan="2">정보과학과</td>
                                        <td data-th="대표ID" rowspan="2">testi**01</td>
                                        <td data-th="학번" rowspan="2">231548***58</td>
                                        <td data-th="이름" rowspan="2">학*자01</td>
                                        <td data-th="변경">전</td>
                                        <td data-th="중간">90</td>
                                        <td data-th="기말">90</td>
                                        <td data-th="출석">90</td>
                                        <td data-th="과제">90</td>
                                        <td data-th="토론">90</td>
                                        <td data-th="퀴즈">90</td>
                                        <td data-th="설문">90</td>
                                        <td data-th="세미나">90</td>
                                        <td data-th="시험">90</td>
                                        <td data-th="기타">0</td>
                                        <td data-th="최종">90</td>
                                        <td data-th="처리일시" rowspan="2">2026.07.26 17:35</td>
                                        <td data-th="처리자" rowspan="2">홍*수</td>
                                    </tr>
                                    <tr>
                                        <td>후</td>
                                        <td class="fcBlue">95</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">95</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">100</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">5</td>
                                        <td class="fcBlue">92.17</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호" rowspan="2">49</td>
                                        <td data-th="학과" rowspan="2">정보과학과</td>
                                        <td data-th="대표ID" rowspan="2">testi**01</td>
                                        <td data-th="학번" rowspan="2">231548***58</td>
                                        <td data-th="이름" rowspan="2">학*자01</td>
                                        <td data-th="변경">전</td>
                                        <td data-th="중간">90</td>
                                        <td data-th="기말">90</td>
                                        <td data-th="출석">90</td>
                                        <td data-th="과제">90</td>
                                        <td data-th="토론">90</td>
                                        <td data-th="퀴즈">90</td>
                                        <td data-th="설문">90</td>
                                        <td data-th="세미나">90</td>
                                        <td data-th="시험">90</td>
                                        <td data-th="기타">0</td>
                                        <td data-th="최종">90</td>
                                        <td data-th="처리일시" rowspan="2">2026.07.26 17:35</td>
                                        <td data-th="처리자" rowspan="2">홍*수</td>
                                    </tr>
                                    <tr>
                                        <td>후</td>
                                        <td class="fcBlue">95</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">95</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">100</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">5</td>
                                        <td class="fcBlue">92.17</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호" rowspan="2">48</td>
                                        <td data-th="학과" rowspan="2">정보과학과</td>
                                        <td data-th="대표ID" rowspan="2">testi**01</td>
                                        <td data-th="학번" rowspan="2">231548***58</td>
                                        <td data-th="이름" rowspan="2">학*자01</td>
                                        <td data-th="변경">전</td>
                                        <td data-th="중간">90</td>
                                        <td data-th="기말">90</td>
                                        <td data-th="출석">90</td>
                                        <td data-th="과제">90</td>
                                        <td data-th="토론">90</td>
                                        <td data-th="퀴즈">90</td>
                                        <td data-th="설문">90</td>
                                        <td data-th="세미나">90</td>
                                        <td data-th="시험">90</td>
                                        <td data-th="기타">0</td>
                                        <td data-th="최종">90</td>
                                        <td data-th="처리일시" rowspan="2">2026.07.26 17:35</td>
                                        <td data-th="처리자" rowspan="2">홍*수</td>
                                    </tr>
                                    <tr>
                                        <td>후</td>
                                        <td class="fcBlue">95</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">95</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">100</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">5</td>
                                        <td class="fcBlue">92.17</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호" rowspan="2">47</td>
                                        <td data-th="학과" rowspan="2">정보과학과</td>
                                        <td data-th="대표ID" rowspan="2">testi**01</td>
                                        <td data-th="학번" rowspan="2">231548***58</td>
                                        <td data-th="이름" rowspan="2">학*자01</td>
                                        <td data-th="변경">전</td>
                                        <td data-th="중간">90</td>
                                        <td data-th="기말">90</td>
                                        <td data-th="출석">90</td>
                                        <td data-th="과제">90</td>
                                        <td data-th="토론">90</td>
                                        <td data-th="퀴즈">90</td>
                                        <td data-th="설문">90</td>
                                        <td data-th="세미나">90</td>
                                        <td data-th="시험">90</td>
                                        <td data-th="기타">0</td>
                                        <td data-th="최종">90</td>
                                        <td data-th="처리일시" rowspan="2">2026.07.26 17:35</td>
                                        <td data-th="처리자" rowspan="2">홍*수</td>
                                    </tr>
                                    <tr>
                                        <td>후</td>
                                        <td class="fcBlue">95</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">95</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">100</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">90</td>
                                        <td class="fcBlue">5</td>
                                        <td class="fcBlue">92.17</td>
                                    </tr>
                                </tbody>
                            </table>
                            <div class="board_foot">
								<div class="page_info">
									<span class="total_page">전체 <b>12</b>건</span>
									<span class="current_page">현재 페이지 <strong>1</strong>/10</span>
								</div>
								<div class="board_pager">
									<span class="inner">
										<button class="page" type="button" role="button" aria-label="First Page" title="처음 페이지" data-page="1" disabled=""><i class="icon-page-first"></i></button>
										<button class="page" type="button" role="button" aria-label="Prev Page" title="이전 페이지" data-page="1" disabled=""><i class="icon-page-prev"></i></button>
										<span class="pages">
											<button class="page active" type="button" role="button" aria-label="Page 1" title="1 페이지" data-page="1">1</button>
											<button class="page" type="button" role="button" aria-label="Page 2" title="2 페이지" data-page="2">2</button>
											<button class="page" type="button" role="button" aria-label="Page 3" title="3 페이지" data-page="3">3</button>
										</span>
										<button class="page" type="button" role="button" aria-label="Next Page" title="다음 페이지" data-page="2"><i class="icon-page-next"></i></button>
										<button class="page" type="button" role="button" aria-label="Last Page" title="마지막 페이지" data-page="3"><i class="icon-page-last"></i></button>
									</span>
								</div>
							</div>
                        </div>

                        <div class="btns mb30">
                            <button type="button" class="btn type2">닫기</button>
                        </div>

                    </div>
                </div>
            </div>
            <!-- //Modal1 성적처리 로그조회 -->

        </main>
        <!-- //admin-->

    </div>

</body>
</html>

<script>
    //성적처리 로그조회
    $('#btn-modal1').on('click', function() {
        
        var $content = $('#modal1 .modal-body');

        UiDialog("dialog1", {
            title: "성적처리 로그조회",
            width: '90%',
            height: 780,
            html: $content
        });
    });    
</script>
