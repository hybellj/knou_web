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

                        <div class="board-top">
                            <h3 class="board-title">등록</h3>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type5">
                                <colgroup>
                                    <col style="width:15%">
                                    <col>
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th scope="col">관리자 구분</th>
                                        <td data-th="관리자 구분">
											<div class="form-inline">
												<select class="form-select" id="admin_label" name="admin_label" required="true">
                                                    <option value="">선택</option>
                                                    <option value="전체 시스템 관리자">전체 시스템 관리자</option>
                                                    <option value="기관 관리자">기관 관리자</option>
                                                    <option value="기관 운영 관리자">기관 운영 관리자</option>
                                                    <option value="기관 콘텐츠 관리자">기관 콘텐츠 관리자</option>
                                                    <option value="과목 관리자">과목 관리자</option>
												</select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="col">사용자 구분</th>
                                        <td data-th="사용자 구분">
											<div class="form-inline">
												<select class="form-select" id="user_label" name="user_label" required="true">
                                                    <option value="">선택</option>
                                                    <option value="교수">교수</option>
                                                    <option value="튜터">튜터</option>
                                                    <option value="조교">조교</option>
                                                    <option value="학습자">학습자</option>
                                                    <option value="교직원">교직원</option>
                                                    <option value="일반회원">일반회원</option>
												</select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="col">기관</th>
                                        <td data-th="기관">
											<div class="form-inline">
												<select class="form-select" id="univ_label" name="univ_label" required="true" disabled>
                                                    <option value="">대학원</option>
												</select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="col">부서/학과</th>
                                        <td data-th="부서/학과">
											<div class="form-inline">
												<select class="form-select" id="deptCode" name="deptCode" required="true">
                                                    <option value="">선택</option>
												</select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="col" class="req">아이디</th>
                                        <td data-th="아이디">
											<div class="form-inline">
                                               <input class="form-control" type="text" id="id_label" placeholder="아이디를 입력하세요" required="true"/>
											   <button type="button" class="btn gray1">중복확인</button>
                                            </div>                                            
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="col" class="req">비밀번호</th>
                                        <td data-th="비밀번호">
											<div class="form-row">
                                                <input class="form-control" type="password" id="pw_label" placeholder="비밀번호 입력" required="true"/>
                                            </div>
											<small class="note fcRed">* 8자 이상 16자 이하로 입력 하세요.</small><br>
											<small class="note fcRed">* 영문(대소문자구분)/숫자/특수문자 중 2가지 이상 조합해 주세요.</small><br>
											<small class="note">* 영문(대소문자구분)/숫자/특수문자 중 2가지 이상조합, 8자~16자</small>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="col">비밀번호 확인</th>
                                        <td data-th="비밀번호 확인">
											<div class="form-inline">
                                                <input class="form-control" type="password" id="pw_label2" placeholder="비밀번호 재입력"/>
                                            </div>                                            
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="col">학번/사번</th>
                                        <td data-th="학번/사번">
											<div class="form-inline">
                                               <input class="form-control" type="text" id="userId" placeholder="학번/사번을 입력하세요" required="true"/>
											   <button type="button" class="btn gray1">중복확인</button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="col" class="req">이름</th>
                                        <td data-th="이름">
											<div class="form-row">
												<input class="form-control width-50per" type="text" name="name" id="name_label" value="" placeholder="이름을 입력하세요" required="true" inputmask="byte" maxLen="10" minLen="4">
											</div>                                            
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="col" class="req">휴대폰번호</th>
                                        <td data-th="휴대폰번호">
                                            <div class="form-row">
                                                <div class="num_input">
                                                    <select name="" id="mobileLabel" class="compact">
                                                        <option value="010">010</option>
                                                        <option value="011">011</option>
                                                        <option value="016">016</option>
                                                        <option value="017">017</option>
                                                        <option value="018">018</option>
                                                        <option value="019">019</option>
                                                    </select>
                                                    <span class="txt-sort">-</span>
                                                    <input type="text" maxlength="4" class="compact" value="1234" />
                                                    <span class="txt-sort">-</span>
                                                    <input type="text" maxlength="4" class="compact" value="1234" />
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="col">개인 이메일</th>
                                        <td data-th="개인 이메일">
                                            <div class="form-inline">
                                                <input class="form-control mr5" type="text" name="name" value="" id="inputEmail3">
                                                <span class="mr5">@</span>
                                                <input class="form-control mr5" type="text" name="name" id="inputEmail4" value=""  title="이메일 주소 뒷자리" placeholder="">
                                                <select class="form-select" id="selectEmail2">
                                                    <option value="-">선택</option>
                                                    <option value="-">naver.com</option>
                                                    <option value="-">daum.net</option>
                                                </select>
                                                <button type="button" class="btn gray1">직접입력</button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="col">학적 상태</th>
                                        <td data-th="학적 상태">
											<div class="form-inline">
												<select class="form-select" id="academicStatus" name="academicStatus" required="true">
                                                    <option value="">선택</option>
                                                    <option value="재학">재학</option>
                                                    <option value="휴학">휴학</option>
                                                    <option value="졸업">졸업</option>
                                                    <option value="수료">수료</option>
                                                    <option value="재적">재적</option>
												</select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="col">장애 유형/등급</th>
                                        <td data-th="장애 유형/등급">
											<div class="form-inline">
												<select class="form-select" id="disabilityType" name="disabilityType" required="true">
                                                    <option value="">장애유형</option>
                                                    <option value="지체장애">지체장애</option>
                                                    <option value="뇌병변장애">뇌병변장애</option>
                                                    <option value="시각장애">시각장애</option>
                                                    <option value="청각장애">청각장애</option>
                                                    <option value="언어장애">언어장애</option>
                                                    <option value="지적장애">지적장애</option>
                                                    <option value="자폐성장애">자폐성장애</option>
                                                    <option value="정신장애">정신장애</option>
                                                    <option value="발달장애">발달장애</option>
                                                    <option value="신장장애">신장장애</option>
                                                    <option value="심장장애">심장장애</option>
												</select>
												<select class="form-select" id="disabilityLevel" name="disabilityLevel" required="true">
                                                    <option value="">장애등급</option>
                                                    <option value="경증장애">경증장애</option>
                                                    <option value="중증장애">중증장애</option>
                                                </select>
                                            </div>                                            
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="col">고령자 유무</th>
                                        <td data-th="고령자 유무">
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" name="seniorYn" id="seniorYnY" value="Y" checked="">
                                                    <label for="seniorYnY">Y</label>
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" name="seniorYn" id="seniorYnN" value="N">
                                                    <label for="seniorYnN">N</label>
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="col">프로필 사진</th>
                                        <td data-th="프로필 사진">
                                            <!--업로드-->
                                            <div id="upload">

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

                                                <!--파일 -->
                                                <ul id="atchfiles">
                                                    <li id="attachIdx_1">
                                                        <p><img src="<%=request.getContextPath()%>/webdoc/assets/img/logo.svg" aria-hidden="true" alt="한국방송통신대학교"></p><span aria-label="삭제" href="#_none"></span>
                                                    </li>
                                                </ul>
                                                <!--//파일 -->
                                            </div><!--//업로드-->
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="btns">
                            <button type="button" class="btn type1">저장</button>
                            <button type="button" class="btn type2">목록</button>
                        </div>

                    </div>
                </div>

            </div>
            <!-- //content -->

        </main>
        <!-- //admin-->

    </div>

</body>
</html>

