<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">
		<jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="editor,fileuploader"/>
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
                            <h2 class="page-title">사용자 관리</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>수업운영도구</li>
                                    <li>과정관리</li>
                                    <li><span class="current">사용자 관리</span></li>
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
                                <span class="item_tit"><label for="selectCourse">관리자 구분</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectCourse">
                                        <option value="전체">전체</option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectSearch">사용자 구분</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectSearch1">
                                        <option value="전체">전체</option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="">검색어</label></span>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" name="" id="inputSearch1" value="" placeholder="학번/사번/이름 검색">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search">검색</button>
                            </div>
                        </div>                        


                        <div class="board_top"> 
                            <h3 class="board-title">목록<span class="total_txt fs-16px fw-normal ml5">[ 총 건수 : <b>90</b>건 ]</span></h3>
                            <div class="right-area">
                                <button type="button" class="btn basic">메시지 보내기</button>
                                <button type="button" class="btn basic">엑셀 다운로드</button>
                                <button type="button" class="btn type8">학사연동 가져오기</button>
                                <button type="button" class="btn type2">엑셀로 등록</button>
                                <button type="button" class="btn type2">등록</button>
                                <select class="form-select type-num" id="select" title="페이지당 리스트수를 선택하세요.">
                                    <option value="ALL" selected="selected">10</option>
                                    <option value="20">20</option>
                                    <option value="30">30</option>
                                </select>
                            </div>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type3">
                                <colgroup>
                                    <col style="width: 3%;">
                                    <col style="width: 5%;">
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col style="width: 15%;">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chkAll">
                                                <label for="chkAll"></label>
                                            </span>
                                        </th>
                                        <th scope="col">번호</th>
                                        <th scope="col" class="cursor-pointer">관리자 구분<i class="xi-arrows-v icon"></i></th>
                                        <th scope="col" class="cursor-pointer">사용자 구분<i class="xi-arrows-v icon"></i></th>
                                        <th scope="col" class="cursor-pointer">기관<i class="xi-arrows-v icon"></i></th>
                                        <th scope="col" class="cursor-pointer">학과/부서<i class="xi-arrows-v icon"></i></th>
                                        <th scope="col">학번/사번</th>
                                        <th scope="col" class="cursor-pointer">이름<i class="xi-arrows-v icon"></i></th>
                                        <th scope="col" class="cursor-pointer">학년<i class="xi-arrows-v icon"></i></th>
                                        <th scope="col" class="cursor-pointer">학적상태<i class="xi-arrows-v icon"></i></th>
                                        <th scope="col">관리</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk75">
                                                <label for="chk75"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">75</td>
                                        <td data-th="관리자 구분">전체 시스템 관리자</td>
                                        <td data-th="사용자 구분">교직원</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학과/부서">교육정보화본부</td>
                                        <td data-th="학번/사번" class="fcRed">
                                            598***87
                                        </td>
                                        <td data-th="이름">
                                            <a href="#" class="fcBlue">홍*원</a>
                                        </td>
                                        <td data-th="학년">-</td>
                                        <td data-th="학적상태">-</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn basic small">로그인</button>
                                            <button type="button" class="btn basic small">수정</button>
                                            <button type="button" class="btn basic small">권한변경</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk74">
                                                <label for="chk74"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">74</td>
                                        <td data-th="관리자 구분">전체 시스템 관리자</td>
                                        <td data-th="사용자 구분">교직원</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학과/부서">교육정보화본부</td>
                                        <td data-th="학번/사번" class="fcRed">
                                            598***87
                                        </td>
                                        <td data-th="이름">
                                            <a href="#" class="fcBlue">홍*원</a>
                                        </td>
                                        <td data-th="학년">-</td>
                                        <td data-th="학적상태">-</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn basic small">로그인</button>
                                            <button type="button" class="btn basic small">수정</button>
                                            <button type="button" class="btn basic small">권한변경</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk73">
                                                <label for="chk73"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">73</td>
                                        <td data-th="관리자 구분">전체 시스템 관리자</td>
                                        <td data-th="사용자 구분">교직원</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학과/부서">교육정보화본부</td>
                                        <td data-th="학번/사번" class="fcRed">
                                            598***87
                                        </td>
                                        <td data-th="이름">
                                            <a href="#" class="fcBlue">홍*원</a>
                                        </td>
                                        <td data-th="학년">-</td>
                                        <td data-th="학적상태">-</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn basic small">로그인</button>
                                            <button type="button" class="btn basic small">수정</button>
                                            <button type="button" class="btn basic small">권한변경</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk72">
                                                <label for="chk72"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">72</td>
                                        <td data-th="관리자 구분">전체 시스템 관리자</td>
                                        <td data-th="사용자 구분">교직원</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학과/부서">교육정보화본부</td>
                                        <td data-th="학번/사번" class="fcRed">
                                            598***87
                                        </td>
                                        <td data-th="이름">
                                            <a href="#" class="fcBlue">홍*원</a>
                                        </td>
                                        <td data-th="학년">-</td>
                                        <td data-th="학적상태">-</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn basic small">로그인</button>
                                            <button type="button" class="btn basic small">수정</button>
                                            <button type="button" class="btn basic small">권한변경</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk71">
                                                <label for="chk71"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">71</td>
                                        <td data-th="관리자 구분">전체 시스템 관리자</td>
                                        <td data-th="사용자 구분">교직원</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학과/부서">교육정보화본부</td>
                                        <td data-th="학번/사번" class="fcRed">
                                            598***87
                                        </td>
                                        <td data-th="이름">
                                            <a href="#" class="fcBlue">홍*원</a>
                                        </td>
                                        <td data-th="학년">-</td>
                                        <td data-th="학적상태">-</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn basic small">수정</button>
                                            <button type="button" class="btn basic small">권한변경</button>
                                            <button type="button" class="btn basic small">탈퇴</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk70">
                                                <label for="chk70"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">70</td>
                                        <td data-th="관리자 구분">전체 시스템 관리자</td>
                                        <td data-th="사용자 구분">교직원</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학과/부서">교육정보화본부</td>
                                        <td data-th="학번/사번" class="fcRed">
                                            598***87
                                        </td>
                                        <td data-th="이름">
                                            <a href="#" class="fcBlue">홍*원</a>
                                        </td>
                                        <td data-th="학년">-</td>
                                        <td data-th="학적상태">-</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn basic small">로그인</button>
                                            <button type="button" class="btn basic small">수정</button>
                                            <button type="button" class="btn basic small">권한변경</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk69">
                                                <label for="chk69"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">69</td>
                                        <td data-th="관리자 구분">전체 시스템 관리자</td>
                                        <td data-th="사용자 구분">교직원</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학과/부서">교육정보화본부</td>
                                        <td data-th="학번/사번" class="fcRed">
                                            598***87
                                        </td>
                                        <td data-th="이름">
                                            <a href="#" class="fcBlue">홍*원</a>
                                        </td>
                                        <td data-th="학년">-</td>
                                        <td data-th="학적상태">-</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn basic small">로그인</button>
                                            <button type="button" class="btn basic small">수정</button>
                                            <button type="button" class="btn basic small">권한변경</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk68">
                                                <label for="chk68"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">68</td>
                                        <td data-th="관리자 구분">전체 시스템 관리자</td>
                                        <td data-th="사용자 구분">교직원</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학과/부서">교육정보화본부</td>
                                        <td data-th="학번/사번" class="fcRed">
                                            598***87
                                        </td>
                                        <td data-th="이름">
                                            <a href="#" class="fcBlue">홍*원</a>
                                        </td>
                                        <td data-th="학년">-</td>
                                        <td data-th="학적상태">-</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn basic small">로그인</button>
                                            <button type="button" class="btn basic small">수정</button>
                                            <button type="button" class="btn basic small">권한변경</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk67">
                                                <label for="chk67"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">67</td>
                                        <td data-th="관리자 구분">전체 시스템 관리자</td>
                                        <td data-th="사용자 구분">교직원</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학과/부서">교육정보화본부</td>
                                        <td data-th="학번/사번" class="fcRed">
                                            598***87
                                        </td>
                                        <td data-th="이름">
                                            <a href="#" class="fcBlue">홍*원</a>
                                        </td>
                                        <td data-th="학년">-</td>
                                        <td data-th="학적상태">-</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn basic small">로그인</button>
                                            <button type="button" class="btn basic small">수정</button>
                                            <button type="button" class="btn basic small">권한변경</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk66">
                                                <label for="chk66"></label>
                                            </span>
                                        </td>
                                        <td data-th="번호">66</td>
                                        <td data-th="관리자 구분">전체 시스템 관리자</td>
                                        <td data-th="사용자 구분">교직원</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학과/부서">교육정보화본부</td>
                                        <td data-th="학번/사번" class="fcRed">
                                            598***87
                                        </td>
                                        <td data-th="이름">
                                            <a href="#" class="fcBlue">홍*원</a>
                                        </td>
                                        <td data-th="학년">-</td>
                                        <td data-th="학적상태">-</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn basic small">로그인</button>
                                            <button type="button" class="btn basic small">수정</button>
                                            <button type="button" class="btn basic small">권한변경</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                    </div>
                </div>


                <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                <div class="modal-btn-box mt30">
                    <button type="button" class="btn modal__btn" id="btn-modal1">사용자 정보</button>
                    <button type="button" class="btn modal__btn" id="btn-modal2">연락처 변경이력</button>
                    <button type="button" class="btn modal__btn" id="btn-modal3">권한 변경</button>
                    <button type="button" class="btn modal__btn" id="btn-modal4">알림 바로 보내기</button>
                </div>
                <!--// modal popup 보여주기 버튼(개발시 삭제) -->

            </div>
            <!-- //content -->

        <!-- Modal1 사용자 정보 -->
        <div class="modal-overlay" id="modal1">
            <div class="modal-content">
                <div class="modal-body">

                    <div class="user-wrap">
                        <div class="user-img">
                            <div class="user-photo">
                                <!--프로필 사진-->
                                <img src="/lms_design_sample/webdoc/assets/img/common/default_prof.png" alt="사진">
                            </div>

                        </div>

                        <!--table-type5-->
                        <div class="board_top">
                            <div class="right-area">
                                <button type="button" class="btn small basic">연락처 변경이력</button>
                            </div>
                            <div class="table-wrap">
                                <table class="table-type5">
                                    <colgroup>
                                        <col class="width-25per" />
                                        <col class="" />
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                            <th scope="row">기관</th>
                                            <td data-th="기관">대학원</td>
                                        </tr>
                                        <tr>
                                            <th scope="row">이름</th>
                                            <td data-th="이름">홍*원</td>
                                        </tr>
                                        <tr>
                                            <th scope="row">학번</th>
                                            <td data-th="학번" class="fcRed">598***87</td>
                                        </tr>
                                        <tr>
                                            <th scope="row">아이디</th>
                                            <td data-th="아이디">testi**4</td>
                                        </tr>
                                        <tr>
                                            <th scope="row">휴대폰 번호</th>
                                            <td data-th="휴대폰 번호">010-2222-09**</td>
                                        </tr>
                                        <tr>
                                            <th scope="row">사용 이메일</th>
                                            <td data-th="사용 이메일">k202154**4@knou.ac.kr(연계 이메일)</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="modal_btns">
                        <button type="button" class="btn type2">닫기</button>
                    </div>

                </div>
            </div>
        </div>
        <!-- //Modal1 사용자 정보 -->

        <!-- Modal2 연락처 변경이력 -->
        <div class="modal-overlay" id="modal2">
            <div class="modal-content">
                <div class="modal-body">
                    <div class="table-wrap overflow-y">
                        <table class="table-type3">
                            <colgroup>
                                <col style="width:5%">
                                <col>
                                <col>
                                <col>
                                <col>
                                <col>
                                <col>
                                <col>
                                <col>
                                <col style="width:15%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">번호</th>
                                    <th scope="col">기관</th>
                                    <th scope="col">년도</th>
                                    <th scope="col">학기</th>
                                    <th scope="col">대표ID</th>
                                    <th scope="col">학번/사번</th>
                                    <th scope="col">이름</th>
                                    <th scope="col">변경전 연락처</th>
                                    <th scope="col">변경후 연락처</th>
                                    <th scope="col">변경일시</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td data-th="번호">12</td>
                                    <td data-th="기관">대학원</td>
                                    <td data-th="년도">2026년</td>
                                    <td data-th="학기">1학기</td>
                                    <td data-th="대표ID">testi**4</td>
                                    <td data-th="학번/사번">598***87</td>
                                    <td data-th="이름">홍*원</td>
                                    <td data-th="변경전 연락처">010-1111-22**</td>
                                    <td data-th="변경후 연락처">010-3333-44**</td>
                                    <td data-th="변경일시">2026.01.14 10:23</td>
                                </tr>
                                <tr>
                                    <td data-th="번호">11</td>
                                    <td data-th="기관">대학원</td>
                                    <td data-th="년도">2026년</td>
                                    <td data-th="학기">1학기</td>
                                    <td data-th="대표ID">testi**4</td>
                                    <td data-th="학번/사번">598***87</td>
                                    <td data-th="이름">홍*원</td>
                                    <td data-th="변경전 연락처">010-1111-22**</td>
                                    <td data-th="변경후 연락처">010-3333-44**</td>
                                    <td data-th="변경일시">2026.01.14 10:23</td>
                                </tr>
                                <tr>
                                    <td data-th="번호">10</td>
                                    <td data-th="기관">대학원</td>
                                    <td data-th="년도">2026년</td>
                                    <td data-th="학기">1학기</td>
                                    <td data-th="대표ID">testi**4</td>
                                    <td data-th="학번/사번">598***87</td>
                                    <td data-th="이름">홍*원</td>
                                    <td data-th="변경전 연락처">010-1111-22**</td>
                                    <td data-th="변경후 연락처">010-3333-44**</td>
                                    <td data-th="변경일시">2026.01.14 10:23</td>
                                </tr>
                                <tr>
                                    <td data-th="번호">9</td>
                                    <td data-th="기관">대학원</td>
                                    <td data-th="년도">2026년</td>
                                    <td data-th="학기">1학기</td>
                                    <td data-th="대표ID">testi**4</td>
                                    <td data-th="학번/사번">598***87</td>
                                    <td data-th="이름">홍*원</td>
                                    <td data-th="변경전 연락처">010-1111-22**</td>
                                    <td data-th="변경후 연락처">010-3333-44**</td>
                                    <td data-th="변경일시">2026.01.14 10:23</td>
                                </tr>
                                <tr>
                                    <td data-th="번호">8</td>
                                    <td data-th="기관">대학원</td>
                                    <td data-th="년도">2026년</td>
                                    <td data-th="학기">1학기</td>
                                    <td data-th="대표ID">testi**4</td>
                                    <td data-th="학번/사번">598***87</td>
                                    <td data-th="이름">홍*원</td>
                                    <td data-th="변경전 연락처">010-1111-22**</td>
                                    <td data-th="변경후 연락처">010-3333-44**</td>
                                    <td data-th="변경일시">2026.01.14 10:23</td>
                                </tr>
                                <tr>
                                    <td data-th="번호">7</td>
                                    <td data-th="기관">대학원</td>
                                    <td data-th="년도">2026년</td>
                                    <td data-th="학기">1학기</td>
                                    <td data-th="대표ID">testi**4</td>
                                    <td data-th="학번/사번">598***87</td>
                                    <td data-th="이름">홍*원</td>
                                    <td data-th="변경전 연락처">010-1111-22**</td>
                                    <td data-th="변경후 연락처">010-3333-44**</td>
                                    <td data-th="변경일시">2026.01.14 10:23</td>
                                </tr>
                                <tr>
                                    <td data-th="번호">6</td>
                                    <td data-th="기관">대학원</td>
                                    <td data-th="년도">2026년</td>
                                    <td data-th="학기">1학기</td>
                                    <td data-th="대표ID">testi**4</td>
                                    <td data-th="학번/사번">598***87</td>
                                    <td data-th="이름">홍*원</td>
                                    <td data-th="변경전 연락처">010-1111-22**</td>
                                    <td data-th="변경후 연락처">010-3333-44**</td>
                                    <td data-th="변경일시">2026.01.14 10:23</td>
                                </tr>
                                <tr>
                                    <td data-th="번호">5</td>
                                    <td data-th="기관">대학원</td>
                                    <td data-th="년도">2026년</td>
                                    <td data-th="학기">1학기</td>
                                    <td data-th="대표ID">testi**4</td>
                                    <td data-th="학번/사번">598***87</td>
                                    <td data-th="이름">홍*원</td>
                                    <td data-th="변경전 연락처">010-1111-22**</td>
                                    <td data-th="변경후 연락처">010-3333-44**</td>
                                    <td data-th="변경일시">2026.01.14 10:23</td>
                                </tr>
                                <tr>
                                    <td data-th="번호">4</td>
                                    <td data-th="기관">대학원</td>
                                    <td data-th="년도">2026년</td>
                                    <td data-th="학기">1학기</td>
                                    <td data-th="대표ID">testi**4</td>
                                    <td data-th="학번/사번">598***87</td>
                                    <td data-th="이름">홍*원</td>
                                    <td data-th="변경전 연락처">010-1111-22**</td>
                                    <td data-th="변경후 연락처">010-3333-44**</td>
                                    <td data-th="변경일시">2026.01.14 10:23</td>
                                </tr>
                                <tr>
                                    <td data-th="번호">3</td>
                                    <td data-th="기관">대학원</td>
                                    <td data-th="년도">2026년</td>
                                    <td data-th="학기">1학기</td>
                                    <td data-th="대표ID">testi**4</td>
                                    <td data-th="학번/사번">598***87</td>
                                    <td data-th="이름">홍*원</td>
                                    <td data-th="변경전 연락처">010-1111-22**</td>
                                    <td data-th="변경후 연락처">010-3333-44**</td>
                                    <td data-th="변경일시">2026.01.14 10:23</td>
                                </tr>
                                <tr>
                                    <td data-th="번호">2</td>
                                    <td data-th="기관">대학원</td>
                                    <td data-th="년도">2026년</td>
                                    <td data-th="학기">1학기</td>
                                    <td data-th="대표ID">testi**4</td>
                                    <td data-th="학번/사번">598***87</td>
                                    <td data-th="이름">홍*원</td>
                                    <td data-th="변경전 연락처">010-1111-22**</td>
                                    <td data-th="변경후 연락처">010-3333-44**</td>
                                    <td data-th="변경일시">2026.01.14 10:23</td>
                                </tr>
                                <tr>
                                    <td data-th="번호">1</td>
                                    <td data-th="기관">대학원</td>
                                    <td data-th="년도">2026년</td>
                                    <td data-th="학기">1학기</td>
                                    <td data-th="대표ID">testi**4</td>
                                    <td data-th="학번/사번">598***87</td>
                                    <td data-th="이름">홍*원</td>
                                    <td data-th="변경전 연락처">010-1111-22**</td>
                                    <td data-th="변경후 연락처">010-3333-44**</td>
                                    <td data-th="변경일시">2026.01.14 10:23</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="btns">
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- //Modal2 연락처 변경이력 -->

        <!-- Modal3 권한 변경 -->
        <div class="modal-overlay" id="modal3">
            <div class="modal-content">
                <div class="modal-body">
                    <div class="table-wrap">
                        <table class="table-type3">
                            <colgroup>
                                <col>
                                <col>
                                <col>
                                <col>
                                <col>
                                <col>
                                <col style="width:20%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">관리자 구분</th>
                                    <th scope="col">사용자 구분</th>
                                    <th scope="col">기관</th>
                                    <th scope="col">학과/부서</th>
                                    <th scope="col">학번/사번</th>
                                    <th scope="col">이름</th>
                                    <th scope="col">관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td data-th="관리자 구분">
                                        기관 관리자
                                    </td>
                                    <td data-th="사용자 구분">
                                        교직원
                                    </td>
                                    <td data-th="기관">
                                        대학원
                                    </td>
                                    <td data-th="학과/부서">
                                        교육정보화본부
                                    </td>
                                    <td data-th="학번/사번" class="fcRed">
                                        598**87
                                    </td>
                                    <td data-th="이름" class="fcBlue">
                                        김*원
                                    </td>
                                    <td data-th="관리" class="t_left">
                                        <ul>
                                            <li>
                                                <span class="custom-input">
                                                    <input type="radio" name="userRole" id="roleAdminSystem" value="ROLE_SYSTEM">
                                                    <label for="roleAdminSystem">전체 시스템 관리자</label>
                                                </span>
                                            </li>
                                            <li>
                                                <span class="custom-input">
                                                    <input type="radio" name="userRole" id="roleAdminInst" value="ROLE_INST">
                                                    <label for="roleAdminInst">기관 관리자</label>
                                                </span>
                                            </li>
                                            <li>
                                                <span class="custom-input">
                                                    <input type="radio" name="userRole" id="roleAdminOper" value="ROLE_OPER">
                                                    <label for="roleAdminOper">기관 운영 관리자</label>
                                                </span>
                                            </li>
                                            <li>
                                                <span class="custom-input">
                                                    <input type="radio" name="userRole" id="roleAdminContents" value="ROLE_CONTENTS">
                                                    <label for="roleAdminContents">기관 콘텐츠 관리자</label>
                                                </span>
                                            </li>
                                            <li>
                                                <span class="custom-input">
                                                    <input type="radio" name="userRole" id="roleAdminCourse" value="ROLE_COURSE">
                                                    <label for="roleAdminCourse">과목 관리자</label>
                                                </span>
                                            </li>
                                            <li>
                                                <span class="custom-input">
                                                    <input type="radio" name="userRole" id="roleUser" value="ROLE_USER" checked>
                                                    <label for="roleUser">일반회원</label>
                                                </span>
                                            </li>
                                        </ul>

                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="btns">
                        <button type="button" class="btn type1">저장</button>
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- //Modal3 권한 변경 -->

        <!-- Modal4 알림 바로 보내기 -->
        <div class="modal-overlay" id="modal4">
            <div class="modal-content">
                <div class="modal-body">

                    <div class="checkbox_type mb20">
                        <span class="custom-input">
                            <input type="checkbox" name="name" id="checkType1">
                            <label for="checkType1">PUSH</label>
                        </span>
                        <span class="custom-input">
                            <input type="checkbox" name="name" id="checkType2">
                            <label for="checkType2">쪽지</label>
                        </span>
                        <span class="custom-input">
                            <input type="checkbox" name="name" id="checkType3">
                            <label for="checkType3">알림톡</label>
                        </span>
                        <span class="custom-input">
                            <input type="checkbox" name="name" id="checkType4">
                            <label for="checkType4">문자</label>
                        </span>
                    </div>

                    <div class="table-wrap">
                        <table class="table-type5">
                            <colgroup>
                                <col style="width:15%">
                                <col>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="col" class="req">
                                        <label for="title_label">제목</label>
                                    </th>
                                    <td data-th="제목">
                                        <input class="form-control width-100per" type="text" name="name" id="title_label" value="" placeholder="알림내용" required="true" inputmask="byte" maxLen="10" minLen="4">
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="col" class="req">
                                        <label for="select_fullLabel">내용</label>
                                    </th>
                                    <td data-th="내용">
                                        <textarea class="form-control" style="width:100%;height:100px" maxLenCheck="byte,1000,true,false" required="true"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="col" class="req">발신일시</th>
                                    <td data-th="발신일시">
                                        <div class="date_area">
                                            <input type="text" placeholder="시작일" id="datepicker3" class="datepicker" toDate="datepicker4" timeId="timepicker3">
                                            <input type="text" placeholder="시작시간" id="timepicker3" class="timepicker" dateId="datepicker3">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="col" class="req">발신자</th>
                                    <td data-th="발신자">
                                        <div class="form-inline">
                                            <input class="form-control width-50per" type="text" name="senderName" id="senderName" value="" placeholder="홍길동" required="true" inputmask="byte" maxLen="10" minLen="4">
                                            
                                            <span class="custom-input ml10">
                                                <input type="checkbox" name="chkSameMe" id="chkSameMe">
                                                <label for="chkSameMe">본인 이름 선택</label>
                                            </span>                                                                             
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="col" class="req">발신자 번호</th>
                                    <td data-th="발신자 번호">
                                        <div class="form-inline">
                                            <span class="custom-input">
                                                <input type="radio" name="senderType" id="senderTypeDept" value="DEPT" checked="">
                                                <label for="senderTypeDept">학과 대표번호</label>
                                            </span>
                                            
                                            <span class="custom-input ml5">
                                                <input type="radio" name="senderType" id="senderTypeCharger" value="CHARGER">
                                                <label for="senderTypeCharger">담당자 번호</label>
                                            </span>
                                            
                                            <input class="form-control width-50per" type="text" name="senderPhone" id="senderPhone" placeholder="010-1111-2233" required="true" inputmask="byte" maxLen="15" minLen="9">
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="board_top">
                        <h3 class="sub-title">받는 사람<span class="total_txt fs-16px fw-normal ml5">[ 총 건수 : <b>90</b>건 ]</span></h3>
                        <div class="right-area">
                            <button type="button" class="btn type2"><i class="xi-plus-min"></i> 추가</button>
                            <button type="button" class="btn type2"><i class="xi-minus-min"></i> 삭제</button>
                        </div>
                    </div>
                    <div class="table-wrap">
                        <table class="table-type3">
                            <colgroup>
                                <col style="width:3%">
                                <col style="width:10%">
                                <col>
                                <col>
                                <col>
                                <col>
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">
                                        <span class="custom-input onlychk">
                                            <input type="checkbox" id="chkall">
                                            <label for="chkall"></label>
                                        </span>
                                    </th>
                                    <th scope="col">번호</th>
                                    <th scope="col">수신자</th>
                                    <th scope="col">개인번호</th>
                                    <th scope="col">휴대폰 번호</th>
                                    <th scope="col">이메일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td data-th="선택">
                                        <span class="custom-input onlychk">
                                            <input type="checkbox" id="chk50">
                                            <label for="chk50"></label>
                                        </span>
                                    </td>
                                    <td data-th="번호">50</td>
                                    <td data-th="수신자">김길동</td>
                                    <td data-th="개인번호">010-1111-2222</td>
                                    <td data-th="휴대폰 번호">010-2222-3333</td>
                                    <td data-th="이메일">test01@naver.com</td>
                                </tr>
                                <tr>
                                    <td data-th="선택">
                                        <span class="custom-input onlychk">
                                            <input type="checkbox" id="chk49">
                                            <label for="chk49"></label>
                                        </span>
                                    </td>
                                    <td data-th="번호">49</td>
                                    <td data-th="수신자">김길동</td>
                                    <td data-th="개인번호">010-1111-2222</td>
                                    <td data-th="휴대폰 번호">010-2222-3333</td>
                                    <td data-th="이메일">test01@naver.com</td>
                                </tr>
                                <tr>
                                    <td data-th="선택">
                                        <span class="custom-input onlychk">
                                            <input type="checkbox" id="chk48">
                                            <label for="chk48"></label>
                                        </span>
                                    </td>
                                    <td data-th="번호">48</td>
                                    <td data-th="수신자">김길동</td>
                                    <td data-th="개인번호">010-1111-2222</td>
                                    <td data-th="휴대폰 번호">010-2222-3333</td>
                                    <td data-th="이메일">test01@naver.com</td>
                                </tr>
                                <tr>
                                    <td data-th="선택">
                                        <span class="custom-input onlychk">
                                            <input type="checkbox" id="chk47">
                                            <label for="chk47"></label>
                                        </span>
                                    </td>
                                    <td data-th="번호">47</td>
                                    <td data-th="수신자">김길동</td>
                                    <td data-th="개인번호">010-1111-2222</td>
                                    <td data-th="휴대폰 번호">010-2222-3333</td>
                                    <td data-th="이메일">test01@naver.com</td>
                                </tr>
                                <tr>
                                    <td data-th="선택">
                                        <span class="custom-input onlychk">
                                            <input type="checkbox" id="chk46">
                                            <label for="chk46"></label>
                                        </span>
                                    </td>
                                    <td data-th="번호">46</td>
                                    <td data-th="수신자">김길동</td>
                                    <td data-th="개인번호">010-1111-2222</td>
                                    <td data-th="휴대폰 번호">010-2222-3333</td>
                                    <td data-th="이메일">test01@naver.com</td>
                                </tr>
                                <tr>
                                    <td data-th="선택">
                                        <span class="custom-input onlychk">
                                            <input type="checkbox" id="chk45">
                                            <label for="chk45"></label>
                                        </span>
                                    </td>
                                    <td data-th="번호">45</td>
                                    <td data-th="수신자">김길동</td>
                                    <td data-th="개인번호">010-1111-2222</td>
                                    <td data-th="휴대폰 번호">010-2222-3333</td>
                                    <td data-th="이메일">test01@naver.com</td>
                                </tr>
                                <tr>
                                    <td data-th="선택">
                                        <span class="custom-input onlychk">
                                            <input type="checkbox" id="chk44">
                                            <label for="chk44"></label>
                                        </span>
                                    </td>
                                    <td data-th="번호">44</td>
                                    <td data-th="수신자">김길동</td>
                                    <td data-th="개인번호">010-1111-2222</td>
                                    <td data-th="휴대폰 번호">010-2222-3333</td>
                                    <td data-th="이메일">test01@naver.com</td>
                                </tr>
                                <tr>
                                    <td data-th="선택">
                                        <span class="custom-input onlychk">
                                            <input type="checkbox" id="chk43">
                                            <label for="chk43"></label>
                                        </span>
                                    </td>
                                    <td data-th="번호">43</td>
                                    <td data-th="수신자">김길동</td>
                                    <td data-th="개인번호">010-1111-2222</td>
                                    <td data-th="휴대폰 번호">010-2222-3333</td>
                                    <td data-th="이메일">test01@naver.com</td>
                                </tr>
                                <tr>
                                    <td data-th="선택">
                                        <span class="custom-input onlychk">
                                            <input type="checkbox" id="chk42">
                                            <label for="chk42"></label>
                                        </span>
                                    </td>
                                    <td data-th="번호">42</td>
                                    <td data-th="수신자">김길동</td>
                                    <td data-th="개인번호">010-1111-2222</td>
                                    <td data-th="휴대폰 번호">010-2222-3333</td>
                                    <td data-th="이메일">test01@naver.com</td>
                                </tr>
                                <tr>
                                    <td data-th="선택">
                                        <span class="custom-input onlychk">
                                            <input type="checkbox" id="chk41">
                                            <label for="chk41"></label>
                                        </span>
                                    </td>
                                    <td data-th="번호">41</td>
                                    <td data-th="수신자">김길동</td>
                                    <td data-th="개인번호">010-1111-2222</td>
                                    <td data-th="휴대폰 번호">010-2222-3333</td>
                                    <td data-th="이메일">test01@naver.com</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="btns">
                        <button type="button" class="btn type2">닫기</button>
                    </div>

                </div>
            </div>
        </div>
        <!-- //Modal4 알림 바로 보내기 -->


        </main>
        <!-- //admin-->

    </div>

</body>
</html>



<script>
    //사용자 정보
    $('#btn-modal1').on('click', function() {
        
        var $content = $('#modal1 .modal-body');

        UiDialog("dialog1", {
            title: "사용자 정보",
            width: 800,
            height: 480,
            html: $content
        });
    });

    //연락처 변경이력
    $('#btn-modal2').on('click', function() {
        
        var $content = $('#modal2 .modal-body');

        UiDialog("dialog1", {
            title: "연락처 변경이력",
            width: 1200,
            height: 480,
            html: $content
        });
    });

    //권한 변경
    $('#btn-modal3').on('click', function() {
        
        var $content = $('#modal3 .modal-body');

        UiDialog("dialog1", {
            title: "권한 변경",
            width: 1200,
            height: 360,
            html: $content
        });
    });

    //알림 바로 보내기
    $('#btn-modal4').on('click', function() {
        
        var $content = $('#modal4 .modal-body');

        UiDialog("dialog1", {
            title: "알림 바로 보내기",
            width: 1200,
            height: 800,
            html: $content
        });
    });    
</script>