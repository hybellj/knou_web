<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">
		<jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="editor,fileuploader"/>
	</jsp:include>    
    <script src="../../webdoc/assets/jquery/jquery-ui.min.js"></script>
    <link rel="stylesheet" href="../../webdoc/assets/css/classroom.css">
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
                            <h2 class="page-title">강의평가관리</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>수업운영도구</li>
                                    <li>과정관리</li>
                                    <li>강의평가</li>
                                    <li><span class="current">강의평가관리</span></li>
                                </ul>
                            </div>
                        </div>

                      
                        <div class="board_top">
                            <h3>문항관리</h3>
                            <div class="right-area">
                                <button type="button" class="btn type1 big">임시저장</button>  
                                <button type="button" class="btn type2 big">출제완료</button>  
                                <button type="button" class="btn type2 big">목록</button>  
                            </div>
                        </div>


                        <!--accordion-->
                        <div class="elements_wrap">
                            <ul class="accordion">
                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap">
                                        <a class="title" href="#">
                                            <div class="lecture_tit">
                                                <strong>중간 강의평가</strong>
                                                <p class="desc">
                                                    <span>강의평가 기간 :<strong>2026.09.30 10:00 ~ 2026.10.09 22:00</strong></span>
                                                </p>
                                            </div>
                                            <i class="arrow xi-angle-down"></i>
                                        </a>
                                    </div>
                                    <div class="cont">
                                        <table class="table-type5">
                                            <colgroup>
                                                <col style="width:15%">
                                                <col>
                                            </colgroup>
                                            <tbody>
                                                <tr>
                                                    <th scope="row" class="req">기관</th>
                                                    <td data-th="기관">대학원</td>
                                                </tr>
                                                <tr>
                                                    <th scope="row" class="req">년도/학기(기수)</th>
                                                    <td data-th="년도/학기(기수)">2026년도 1학기</td>
                                                </tr>
                                                <tr>
                                                    <th scope="row" class="req">분류</th>
                                                    <td data-th="분류">일괄</td>
                                                </tr>

                                                <!-- 분류 : 학과별 -->
                                                <tr class="teamView">
                                                    <td colspan="2">
                                                        <table class="table-type5">
                                                            <tbody>
                                                                <tr>
                                                                    <th scope="row" class="border-top-1 req">학과</th>
                                                                    <td data-th="학과" colspan="7">모든 학과</td>
                                                                </tr>
                                                                <tr>
                                                                    <th scope="row" class="req" colspan="8">과목선택</th>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                        <div class="table-wrap bd0 overflow-y">
                                                            <table class="table-type5">
                                                                <tbody>

                                                                    <tr>
                                                                        <th class="text-center border-left-1 cursor-pointer">
                                                                            기관<i class="xi-arrows-v icon"></i>
                                                                        </th>
                                                                        <th class="text-center border-left-1 cursor-pointer">
                                                                            학과<i class="xi-arrows-v icon"></i>
                                                                        </th>
                                                                        <th class="text-center border-left-1">과목코드</th>
                                                                        <th class="text-center border-left-1 cursor-pointer">
                                                                            과목명<i class="xi-arrows-v icon"></i>
                                                                        </th>
                                                                        <th class="text-center border-left-1">분반</th>
                                                                        <th class="text-center border-left-1 cursor-pointer">
                                                                            담당교수<i class="xi-arrows-v icon"></i>
                                                                        </th>
                                                                        <th class="text-center border-left-1 cursor-pointer">
                                                                            담당튜터<i class="xi-arrows-v icon"></i>
                                                                        </th>
                                                                    </tr>
                                                                    <tr>
                                                                        <td data-th="기관" class="text-center border-left-1">대학원</td>
                                                                        <td data-th="학과" class="text-center border-left-1">정보과학과</td>
                                                                        <td data-th="과목코드" class="text-center border-left-1">CU254835</td>
                                                                        <td data-th="과목명" class="text-center border-left-1">유비쿼터스컴퓨팅</td>
                                                                        <td data-th="분반" class="text-center border-left-1">1</td>
                                                                        <td data-th="담당교수" class="text-center border-left-1">홍*수</td>
                                                                        <td data-th="담당튜터" class="text-center border-left-1">이*터</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td data-th="기관" class="text-center border-left-1">대학원</td>
                                                                        <td data-th="학과" class="text-center border-left-1">정보과학과</td>
                                                                        <td data-th="과목코드" class="text-center border-left-1">CU254835</td>
                                                                        <td data-th="과목명" class="text-center border-left-1">유비쿼터스컴퓨팅</td>
                                                                        <td data-th="분반" class="text-center border-left-1">1</td>
                                                                        <td data-th="담당교수" class="text-center border-left-1">홍*수</td>
                                                                        <td data-th="담당튜터" class="text-center border-left-1">이*터</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td data-th="기관" class="text-center border-left-1">대학원</td>
                                                                        <td data-th="학과" class="text-center border-left-1">정보과학과</td>
                                                                        <td data-th="과목코드" class="text-center border-left-1">CU254835</td>
                                                                        <td data-th="과목명" class="text-center border-left-1">유비쿼터스컴퓨팅</td>
                                                                        <td data-th="분반" class="text-center border-left-1">1</td>
                                                                        <td data-th="담당교수" class="text-center border-left-1">홍*수</td>
                                                                        <td data-th="담당튜터" class="text-center border-left-1">이*터</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td data-th="기관" class="text-center border-left-1">대학원</td>
                                                                        <td data-th="학과" class="text-center border-left-1">정보과학과</td>
                                                                        <td data-th="과목코드" class="text-center border-left-1">CU254835</td>
                                                                        <td data-th="과목명" class="text-center border-left-1">유비쿼터스컴퓨팅</td>
                                                                        <td data-th="분반" class="text-center border-left-1">1</td>
                                                                        <td data-th="담당교수" class="text-center border-left-1">홍*수</td>
                                                                        <td data-th="담당튜터" class="text-center border-left-1">이*터</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td data-th="기관" class="text-center border-left-1">대학원</td>
                                                                        <td data-th="학과" class="text-center border-left-1">정보과학과</td>
                                                                        <td data-th="과목코드" class="text-center border-left-1">CU254835</td>
                                                                        <td data-th="과목명" class="text-center border-left-1">유비쿼터스컴퓨팅</td>
                                                                        <td data-th="분반" class="text-center border-left-1">1</td>
                                                                        <td data-th="담당교수" class="text-center border-left-1">홍*수</td>
                                                                        <td data-th="담당튜터" class="text-center border-left-1">이*터</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td data-th="기관" class="text-center border-left-1">대학원</td>
                                                                        <td data-th="학과" class="text-center border-left-1">정보과학과</td>
                                                                        <td data-th="과목코드" class="text-center border-left-1">CU254835</td>
                                                                        <td data-th="과목명" class="text-center border-left-1">유비쿼터스컴퓨팅</td>
                                                                        <td data-th="분반" class="text-center border-left-1">1</td>
                                                                        <td data-th="담당교수" class="text-center border-left-1">홍*수</td>
                                                                        <td data-th="담당튜터" class="text-center border-left-1">이*터</td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </td>
                                                </tr><!-- //분류 : 학과별 -->
                                                
                                                <tr>
                                                    <th scope="row" class="req">강의평가 제목</th>
                                                    <td data-th="강의평가 제목">강의평가001</td>
                                                </tr>
                                                <tr>
                                                    <th scope="row" class="req">강의평가 설명</th>
                                                    <td data-th="강의평가 설명">임후중과를 선택할 수 있습니다. 시략차색은 키준치무에서 필수적으로 요구됩니다. 방보비는 구석전키의 중요한 부분을 담당합니다. 배합수양은 적상험물을 기반으로 동작합니다. 폼량드는 업기영을 기반으로 동작하기 때문에 피인식의 변화는 곧 의속역의 변화를 의미합니다. 절준은 서설을 기반으로 동작합니다. 서드는 역제와 함께 사용할 때 효과적입니다. 고모를 활성화하면 하측험이 즉시 반영됩니다. 다만 건원을 활성화하면 합토무어가 즉시 반영됩니다. 
            공수를 선택하면 환션 옵션이 나타납니다.<br>략색은 태고의 핵심 요소로서 미결드글을 효과적으로 관리할 수 있습니다.</td>
                                                </tr>
                                                <tr>
                                                    <th scope="row" class="req">강의평가 구분</th>
                                                    <td data-th="강의평가 구분">중간고사</td>
                                                </tr>
                                                <tr>
                                                    <th scope="row" class="req">강의평가 기간</th>
                                                    <td data-th="강의평가 기간">2026.07.03 10:00 ~ 2026.07.12 22:00</td>
                                                </tr>
                                                <tr>
                                                    <th scope="row" class="req">관리 구분</th>
                                                    <td data-th="관리 구분">LMS에서 관리</td>
                                                </tr>
                                                <tr>
                                                    <th scope="row">강의평가 후 성적조회</th>
                                                    <td data-th="강의평가 후 성적조회">예</td>
                                                </tr>
                                                <tr>
                                                    <th scope="row">강의평가 결과조회</th>
                                                    <td data-th="강의평가 결과조회">아니오</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <!--//accordion-->

                        <!-- 출제 문항 영역 -->
                        <div class="board_top">
                            <h3>출제 문항 : 3</h3>
                            <div class="right-area">
                                <button type="button" class="btn basic">문항 엑셀다운로드</button>
                                <button type="button" class="btn type2">문제 가져오기</button>
                                <button type="button" class="btn type2">파일로 등록</button>
                                <button type="button" class="btn type2">페이지 추가</button>
                            </div>
                        </div>

                        <!-- 출제 문항이 없습니다. -->
                         <div class="box mb20">
                            <p class="text-center">출제 문항이 없습니다.</p>
                         </div>
                        <!-- //출제 문항이 없습니다. -->
                        

                        <!-- 문제1 -->
                        <div class="course_history">
                            <div class="h_top">
                                <div class="h_left">
                                    <h4><i class="xi-arrows m_handle mr10" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>1. 페이지 제목01</h4>
                                </div>
                                <div class="h_right">
                                    <button type="button" class="btn basic small">추가</button>
                                    <button type="button" class="btn basic small">수정</button>
                                    <button type="button" class="btn basic small">삭제</button>
                                </div>
                            </div>
                            <div class="question_area">
                                <div class="question_con">
                                    <div class="q_top bd0">
                                        <div class="flex-item width-100per">
                                            <div class="q-info-group">
                                                <button type="button" class="btn basic mr10 arrows-v flex-none"><i class="xi-arrows-v icon"></i></button>
                                                <p class="flex-none mr15"><b>1-1</b></p>
                                            </div>
                                            <div class="flex-1 tal q-content">결무원준을 제공한다. 분험유색을 최적화하는 과정에서 업</div>
                                            <div class="q-ctrl-group">
                                                <button type="button" class="btn type2 small flex-none">삭제</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="question_con">
                                    <div class="q_top bd0">
                                        <div class="flex-item width-100per">
                                            <div class="q-info-group">
                                                <button type="button" class="btn basic mr10 arrows-v flex-none"><i class="xi-arrows-v icon"></i></button>
                                                <p class="flex-none mr15"><b>1-2</b></p>
                                            </div>
                                            <div class="flex-1 tal q-content">무가가 중요해요. 제피지는 비향안을 통해 과상하원에 영</div>
                                            <div class="q-ctrl-group">
                                                <button type="button" class="btn type2 small flex-none">삭제</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div><!-- //문제1 -->

                        <!-- 문제2 -->
                        <div class="course_history">
                            <div class="h_top">
                                <div class="h_left">
                                    <h4><i class="xi-arrows m_handle mr10" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>2. 페이지 제목02</h4>
                                </div>
                                <div class="h_right">
                                    <button type="button" class="btn basic small">추가</button>
                                    <button type="button" class="btn basic small">수정</button>
                                    <button type="button" class="btn basic small">삭제</button>
                                </div>
                            </div>
                            <div class="question_area">
                                <div class="question_con">
                                    <div class="q_top bd0">
                                        <div class="flex-item width-100per">
                                            <div class="q-info-group">
                                                <button type="button" class="btn basic mr10 arrows-v flex-none"><i class="xi-arrows-v icon"></i></button>
                                                <p class="flex-none mr15"><b>2-1</b></p>
                                            </div>
                                            <div class="flex-1 tal q-content">기단이 향상됩니다. 중조를 효율적으로 사용하기 위해서는</div>
                                            <div class="q-ctrl-group">
                                                <button type="button" class="btn type2 small flex-none">삭제</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="question_con">
                                    <div class="q_top bd0">
                                        <div class="flex-item width-100per">
                                            <div class="q-info-group">
                                                <button type="button" class="btn basic mr10 arrows-v flex-none"><i class="xi-arrows-v icon"></i></button>
                                                <p class="flex-none mr15"><b>2-2</b></p>
                                            </div>
                                            <div class="flex-1 tal q-content">싱관표가 경조력치에 따라 다르게 표시될 수 있어요. 하</div>
                                            <div class="q-ctrl-group">
                                                <button type="button" class="btn type2 small flex-none">삭제</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div><!-- //문제2 -->                        
                        
                        <!-- 문제3 -->
                        <div class="course_history">
                            <div class="h_top">
                                <div class="h_left">
                                    <h4><i class="xi-arrows m_handle mr10" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                                        3. 페이지 제목03
                                    </h4>
                                </div>
                                <div class="h_right">
                                    <button type="button" class="btn basic small">추가</button>
                                    <button type="button" class="btn basic small">수정</button>
                                    <button type="button" class="btn basic small">삭제</button>
                                </div>
                            </div>
                            <div class="question_area">
                                <div class="question_con">
                                    <div class="q_top bd0">
                                        <div class="flex-item width-100per">
                                            <div class="q-info-group">
                                                <button type="button" class="btn basic mr10 arrows-v flex-none"><i class="xi-arrows-v icon"></i></button>
                                                <p class="flex-none mr15"><b>3-1</b></p>
                                            </div>
                                            <div class="flex-1 tal q-content">향선치는 터질을 효율적으로 관리해요. 임설싱은 신업제를 기반으로 동작해요. 특히 선산이 포함돼요. 조교는 간후합획의 핵심 요소로 작동해요. 
하반은 선무연서를 기반으로 동작해요. <br>
적림집킹을 고려해야 해요. 션손합원을 고려해야 해요. 태집과가 포함돼요.</div>
                                            <div class="q-ctrl-group">
                                                <button type="button" class="btn type2 small flex-none">삭제</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div><!-- //문제3 -->
                        <!-- //출제 문항 영역 -->

                        <!-- 문항 추가 -->
                         <div class="board_top mt30">
                            <h3>문항 추가</h3>
                         </div>

                        <div class="table-wrap">
                            <table class="table-type5">
                                <colgroup>
									<col class="width-15per">
									<col class="">
								</colgroup>
                                <tbody>
                                    <tr>
                                        <th>문항</th>
                                        <td>
											<div class="form-row gap-2">
												<input class="form-control width-80per" type="text" name="name" id="name_label" value="" placeholder="6-1 문제" required="true" inputmask="byte" maxLen="10" minLen="4">
												<select class="form-select width-20per" id="select_fullLabel" name="select_fullLabel">
                                                    <option value="">문제 유형 선택</option>
													<option value="객관식(다중)">객관식(다중)</option>
													<option value="객관식(단일)">객관식(단일)</option>
                                                    <option value="주관식(단답형)">주관식(단답형)</option>
                                                    <option value="주관식(서술형)">주관식(서술형)</option>
                                                    <option value="OX형">OX형</option>
                                                    <option value="짝짓기형">짝짓기형</option>
												</select>
											</div>
                                            <small class="note2">! 기본 설정된 제목 대신 다른 제목을 넣으시면 좀 더 쉽게 문제를 구분하실 수 있습니다.</small>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>내용</th>
                                        <td>
                                            <dl>
                                                <dd>
                                                    <div class="editor-box">
                                                        <label for="atclCts" class="hide">Content</label>
                                                        <textarea id="atclCts" name="atclCts" required="true"><%-- <c:out value="${bbsAtclVO.atclCts}" /> --%></textarea>
                                                        <script>
                                                            // HTML 에디터
                                                            let editor = UiEditor({
                                                                targetId: "atclCts",
                                                                uploadPath: "/bbs",
                                                                height: "500px"
                                                            });
                                                        </script>
                                                    </div>

                                                    <a href="#_" onclick="checkEditorContens();return false;">[입력내용확인]</a> &nbsp;
                                                    <a href="#_" onclick="insertEditorContens1();return false;">[내용추가(text)]</a> &nbsp;
                                                    <a href="#_" onclick="insertEditorContens2();return false;">[내용바꾸기(html)]</a>
                                                    <script>
                                                        function checkEditorContens() {
                                                            if (editor.isEmpty()) {
                                                                alert("비어있다....");
                                                            }
                                                            else {
                                                                let text = $("#atclCts").val(); // editor.editor.getPublishingHtml()
                                                                alert(text);
                                                            }
                                                        }

                                                        function insertEditorContens1() {
                                                            //editor.execCommand('selectAll');
                                                            //editor.execCommand('deleteLeft');
                                                            editor.execCommand('insertText', "<span style='color:red'>텍스트 넣기 테스트입니다.</span>");
                                                        }

                                                        function insertEditorContens2() {
                                                            editor.openHTML("<span style='color:red'>텍스트 넣기 테스트입니다.</span>");
                                                        }
                                                    </script>
                                                </dd>
                                            </dl>
                                        </td>
                                    </tr>

                                    <tr>
                                        <th>평가 문항</th>
                                        <td>
                                            <div class="rubrics_wrap">
                                                <div class="rub_write">
                                                    <div class="eval_item">
                                                        <div class="item">
                                                            <label class="label_num">1</label>
                                                            <input class="form-control wide" type="text" value="창의력" readonly>
                                                            <input class="form-control sm" type="text" value="30%" >
                                                            <button type="button" class="btn basic icon"><i class="xi-close"></i></button>
                                                        </div>
                                                        <div class="item">
                                                            <label class="label_num">2</label>
                                                            <input class="form-control wide" type="text" value="문장력" readonly>
                                                            <input class="form-control sm" type="text" value="30%" >
                                                            <button type="button" class="btn basic icon"><i class="xi-close"></i></button>
                                                        </div>
                                                        <div class="item">
                                                            <label class="label_num">3</label>
                                                            <input class="form-control wide" type="text" value="구성력" readonly>
                                                            <input class="form-control sm" type="text" value="30%" >
                                                            <button type="button" class="btn basic icon"><i class="xi-close"></i></button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="board_top mt10">
                                                <div class="right-area">
                                                    <button type="button" class="btn type1">문항 추가</button>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>

                                    <tr>
                                        <th>평가 등급</th>
                                        <td>
                                            <div class="rubrics_wrap">
                                                <div class="sub-box rub_grade pd0 bd0 mt0">
                                                    <div class="board_top">
                                                        <div class="form-inline">
                                                            <span class="custom-input">
                                                                <input type="radio" name="evalType1" id="evalType1" value="5" checked="">
                                                                <label for="evalType1">5점 척도</label>
                                                            </span>
                                                            <span class="custom-input ml5">
                                                                <input type="radio" name="evalType1" id="evalType2" value="3">
                                                                <label for="evalType2">3점 척도</label>
                                                            </span>
                                                            <span class="custom-input ml5">
                                                                <input type="radio" name="evalType1" id="evalType3" value="10">
                                                                <label for="evalType3">자유척도</label>
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <div class="grade_item">
                                                        <div class="item">
                                                            <div class="input_btn">
                                                                <input class="form-control sm" id="gradeInput" type="text" value="5" autocomplete="off"><label>점</label>
                                                            </div>
                                                            <input class="form-control wide" type="text" value="매우 잘 했어요">
                                                        </div>
                                                        <div class="item">
                                                            <div class="input_btn">
                                                                <input class="form-control sm" id="gradeInput" type="text" value="4" autocomplete="off"><label>점</label>
                                                            </div>
                                                            <input class="form-control wide" type="text" value="잘 했어요">
                                                        </div>
                                                        <div class="item">
                                                            <div class="input_btn">
                                                                <input class="form-control sm" id="gradeInput" type="text" value="3" autocomplete="off"><label>점</label>
                                                            </div>
                                                            <input class="form-control wide" type="text" value="보통입니다">
                                                        </div>
                                                        <div class="item">
                                                            <div class="input_btn">
                                                                <input class="form-control sm" id="gradeInput" type="text" value="2" autocomplete="off"><label>점</label>
                                                            </div>
                                                            <input class="form-control wide" type="text" value="노력하세요">
                                                        </div>
                                                        <div class="item">
                                                            <div class="input_btn">
                                                                <input class="form-control sm" id="gradeInput" type="text" value="1" autocomplete="off"><label>점</label>
                                                            </div>
                                                            <input class="form-control wide" type="text" value="더 노력하세요">
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="board_top mt10">
                                                <div class="right-area">
                                                    <button type="button" class="btn type1">등급 추가</button>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>

                                    <tr>
                                        <th>필수 선택</th>
                                        <td>
											<div class="form-row">
												<input type="checkbox" id="checkOpenYn" class="switch yesno">
											</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th rowspan="2">보기 입력</th>
                                        <td>
                                            <div class="ox_quiz justify-content-left align-items-center">
                                            <span class="width-5per">예</span>
                                                <div class="ox_item">
                                                    <input type="radio" name="ox_choice" id="ox_o" class="ox_input">
                                                    <label for="ox_o" class="btn basic">
                                                        <i class="xi-radiobox-blank icon"></i>
                                                    </label>
                                                </div>
                                                <div class="margin-left-auto">
                                                    <select class="form-select" id="univ_label" name="univ_label" required="true">
                                                        <option value="">다음 페이지로 이동</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="ox_quiz justify-content-left align-items-center">
                                            <span class="width-5per">아니오</span>
                                                <div class="ox_item flex align-items-center">
                                                    <input type="radio" name="ox_choice" id="ox_x" class="ox_input">
                                                    <label for="ox_x" class="btn basic">
                                                        <i class="xi-close icon"></i>
                                                    </label>
                                                </div>
                                                <div class="margin-left-auto">
                                                    <select class="form-select" id="univ_label" name="univ_label" required="true">
                                                        <option value="">다음 페이지로 이동</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>



                                    <tr>
                                        <th>보기 개수</th>
                                        <td>
											<div class="form-inline">
												<select class="form-select" id="univ_label" name="univ_label" required="true">
													<option value="">개수 선택</option>
													<option value="2개">2개</option>
                                                    <option value="3개">3개</option>
                                                    <option value="4개">4개</option>
                                                    <option value="5개">5개</option>
                                                    <option value="6개">6개</option>
                                                    <option value="7개">7개</option>
                                                    <option value="8개">8개</option>
                                                    <option value="9개">9개</option>
                                                    <option value="10개">10개</option>
												</select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>보기 입력</th>
                                        <td>
											<div class="checkbox_type mb5" style="display: flex; align-items: center;">
												<span class="custom-input" style="width: 80px; flex-shrink: 0;">
													<label for="checkType1Ans">보기 1</label>
												</span>
                                                <div class="form-inline" style="flex: 1; display: flex; gap: 8px;">
                                                    <input class="form-control flex-1" type="text" name="name" id="checkType1Ans" value="" placeholder="" required="true" inputmask="byte" maxLen="10" minLen="4">
                                                    <select class="form-select" id="univ_label" name="univ_label" required="true">
                                                        <option value="">다음 페이지로 이동</option>
                                                    </select>
                                                </div>
											</div>
											<div class="checkbox_type mb5" style="display: flex; align-items: center;">
												<span class="custom-input" style="width: 80px; flex-shrink: 0;">
													<label for="checkType2Ans">보기 2</label>
												</span>
                                                 <div class="form-inline" style="flex: 1; display: flex; gap: 8px;">
                                                    <input class="form-control flex-1" type="text" name="name" id="checkType2Ans" value="" placeholder="" required="true" inputmask="byte" maxLen="10" minLen="4">
                                                    <select class="form-select" id="univ_label" name="univ_label" required="true">
                                                        <option value="">다음 페이지로 이동</option>
                                                    </select>
                                                </div>
	   
                                            </div>
											<div class="checkbox_type mb5" style="display: flex; align-items: center;">
												<span class="custom-input" style="width: 80px; flex-shrink: 0;">
													<label>기타</label>
												</span>
                                                 <div class="form-inline" style="flex: 1; display: flex; gap: 8px;">
                                                    <select class="form-select" id="univ_label" name="univ_label" required="true">
                                                        <option value="">다음 페이지로 이동</option>
                                                    </select>
                                                </div>
                                            </div>

                                        </td>
                                    </tr>

                                    <tr>
                                        <th>분기 선택</th>
                                        <td>
											<div class="form-row">
												<input type="checkbox" id="checkOpenYn2" class="switch yesno" checked>
											</div>
                                            <small class="note2">! 한 페이지에 분기 문항은 하나의 문항에만 설정 가능합니다.</small>                                            
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>기타 항목</th>
                                        <td>
											<div class="form-row">
												<input type="checkbox" id="checkOpenYn3" class="switch yesno" checked>
											</div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>

                        </div>                         
                        <!-- //문항 추가 -->



                <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                <div class="modal-btn-box mt30">
                    <button type="button" class="btn modal__btn" id="btn-modal1">문항 가져오기</button>
                    <button type="button" class="btn modal__btn" id="btn-modal2">파일로 등록</button>
                    <button type="button" class="btn modal__btn" id="btn-modal3">페이지 추가</button>
                </div>
                <!--// modal popup 보여주기 버튼(개발시 삭제) -->


                    </div>
                </div>
            </div>
            <!-- //content -->


        <!-- Modal1 문항 가져오기 -->
        <div class="modal-overlay" id="modal1">
            <div class="modal-content">
                <div class="modal-body">
                    <div class="table-wrap mb20">
                        <table class="table-type5">
                            <colgroup>
                                <col style="width:15%">
                                <col>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row" class="req">년도/학기</th>
                                    <td data-th="년도/학기">
                                        <select class="form-select" id="selectYear">
                                            <option value="">2026년도</option>
                                        </select>                                        
                                        <select class="form-select" id="selectSemester">
                                            <option value="">1학기</option>
                                        </select>
                                    </td>
                                </tr>

                                <tr>
                                    <th scope="row" class="req">기관</th>
                                    <td data-th="기관">
                                        <select class="form-select" id="selectInstitution" disabled>
                                            <option value="">대학원</option>
                                        </select>
                                    </td>
                                </tr>

                                <tr>
                                    <th scope="row" class="req">강의평가지</th>
                                    <td data-th="강의평가지">
                                        <select class="form-select" id="selectEvaluationPaper">
                                            <option value="">분류</option>
                                        </select>
                                    </td>
                                </tr>

                                <tr>
                                    <th scope="row">페이지</th>
                                    <td data-th="페이지">
                                        <select class="form-select" id="selectPage">
                                            <option value="">페이지 선택</option>
                                        </select>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="table-wrap">
                        <table class="table-type2">
                            <colgroup>
                                <col style="width:5%">
                                <col style="width:15%">
                                <col>
                                <col>
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">
                                        <span class="custom-input onlychk">
                                            <input type="checkbox" id="subject_chkall">
                                            <label for="subject_chkall"></label>
                                        </span>
                                    </th>
                                    <th scope="col">문제유형</th>
                                    <th scope="col">문제</th>
                                    <th scope="col">보기</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td data-th="번호">
                                        <span class="custom-input onlychk">
                                            <input type="checkbox" id="chk1"><label for="chk1"></label>
                                        </span>
                                    </td>
                                    <td data-th="문제유형">서술형</td>
                                    <td data-th="문제" class="t_left">1-1 다음을 기술하시오</td>
                                    <td data-th="보기" class="t_left">-</td>
                                </tr>
                                <tr>
                                    <td data-th="번호">
                                        <span class="custom-input onlychk">
                                            <input type="checkbox" id="chk2"><label for="chk2"></label>
                                        </span>
                                    </td>
                                    <td data-th="문제유형">단일선택형</td>
                                    <td data-th="문제" class="t_left">1-2 다음 중 고르시오</td>
                                    <td data-th="보기" class="t_left">1.토끼 2.강아지 3.송아지 4.개구리</td>
                                </tr>
                                <tr>
                                    <td data-th="번호">
                                        <span class="custom-input onlychk">
                                            <input type="checkbox" id="chk3"><label for="chk3"></label>
                                        </span>
                                    </td>
                                    <td data-th="문제유형">OX형</td>
                                    <td data-th="문제" class="t_left">2-1 다음 중 맞는 것을 고르시오</td>
                                    <td data-th="보기" class="t_left">1.O 2.X</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>


                    <div class="modal_btns">
                        <button type="button" class="btn type1">가져오기</button>
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- //Modal1 문항 가져오기 -->


        <!-- Modal2 파일로 등록 -->
        <div class="modal-overlay" id="modal2">
            <div class="modal-content">
                <div class="modal-body">
                    
                    <div class="msg-box">
                        <p class="txt"><strong>주의사항</strong></p>
                        <ul class="list-dot">
                            <li>xlsx 파일만 업로드해야 하며, 지정된 형식을 맞춰야 합니다. 지정된 형식은 샘플 다운로드 받으시면 자세히 보실 수 있습니다.</li>
                            <li>잘못된 형식으로 파일을 등록하면, 정보가 제대로 적용되지 않을 수 있습니다.</li>
                            <li>샘플 파일의 명시사항을 절대 수정하지 마시고, 입력란에 데이터를 입력, 저장 후 등록해 주세요.</li>
                            <li>자료를 작성하실 때 항목은 빈란으로 두지 마세요.</li>
                        </ul>
                    </div>

                    <div class="board_top">
                        <button type="button" class="btn basic">엑셀양식 다운로드</button>                 
                    </div>

                    <!-- 첨부파일 -->
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
                    <!-- //첨부파일 -->



                    <div class="btns">
                        <button type="button" class="btn type1">등록</button>
                        <button type="button" class="btn type2">닫기</button>
                    </div>

                </div>
            </div>
        </div><!-- //Modal2 파일로 등록 -->


        <!-- Modal3 파일로 추가 -->
        <div class="modal-overlay" id="modal3">
            <div class="modal-content">
                <div class="modal-body">
                    
                    <div class="table-wrap">
                        <table class="table-type5">
                            <colgroup>
                                <col style="width:20%">
                                <col>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row" class="req">페이지 제목</th>
                                    <td data-th="페이지 제목">
                                        <input class="form-control width-100per" type="text" name="" id="inputTitle placeholder="페이지 제목 입력">
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">내용</th>
                                    <td data-th="내용">
                                        <dl>
                                            <dd>
                                                <div class="editor-box">
                                                    <label for="atclCts" class="hide">Content</label>
                                                    <textarea id="atclCts" name="atclCts" required="true"><%-- <c:out value="${bbsAtclVO.atclCts}" /> --%></textarea>
                                                    <script>
                                                        // HTML 에디터
                                                        let editor = UiEditor({
                                                            targetId: "atclCts",
                                                            uploadPath: "/bbs",
                                                            height: "350px"
                                                        });
                                                    </script>
                                                </div>

                                                <a href="#_" onclick="checkEditorContens();return false;">[입력내용확인]</a> &nbsp;
                                                <a href="#_" onclick="insertEditorContens1();return false;">[내용추가(text)]</a> &nbsp;
                                                <a href="#_" onclick="insertEditorContens2();return false;">[내용바꾸기(html)]</a>
                                                <script>
                                                    function checkEditorContens() {
                                                        if (editor.isEmpty()) {
                                                            alert("비어있다....");
                                                        }
                                                        else {
                                                            let text = $("#atclCts").val(); // editor.editor.getPublishingHtml()
                                                            alert(text);
                                                        }
                                                    }

                                                    function insertEditorContens1() {
                                                        //editor.execCommand('selectAll');
                                                        //editor.execCommand('deleteLeft');
                                                        editor.execCommand('insertText', "<span style='color:red'>텍스트 넣기 테스트입니다.</span>");
                                                    }

                                                    function insertEditorContens2() {
                                                        editor.openHTML("<span style='color:red'>텍스트 넣기 테스트입니다.</span>");
                                                    }
                                                </script>
                                            </dd>
                                        </dl>                                        
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
        </div><!-- //Modal3 파일로 추가 -->


        </main>
    <!-- //main -->
    </div>




    <script>
        $(document).ready(function() {

            //문항 가져오기
            $('#btn-modal1').on('click', function() {
                
                var $content = $('#modal1 .modal-body');

                UiDialog("dialog1", {
                    title: "문항 가져오기",
                    width: 1200,
                    height: 640,
                    html: $content
                });
            });


            //파일로 등록
            $('#btn-modal2').on('click', function() {
                
                var $content = $('#modal2 .modal-body');

                UiDialog("dialog1", {
                    title: "엑셀 파일로 문항등록",
                    width: 800,
                    height: 600,
                    html: $content
                });
            });


            //파일로 추가
            $('#btn-modal3').on('click', function() {
                
                var $content = $('#modal3 .modal-body');

                UiDialog("dialog1", {
                    title: "파일로 추가",
                    width: 800,
                    height: 620,
                    html: $content
                });
            });                                    
        });
    </script>
</body>
</html>
