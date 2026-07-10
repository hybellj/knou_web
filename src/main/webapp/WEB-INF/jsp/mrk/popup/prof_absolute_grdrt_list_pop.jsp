<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="dashboard"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>

<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>

<body class="modal-page">
<script type="text/javascript">
    $(function () {
        const gradeKeyArr = ["A_PLUS", "A", "B_PLUS", "B", "C_PLUS", "C", "D_PLUS", "D", "F"];

        setGrdTableChart ();

        // 분포표, 차트 세팅
        function setGrdTableChart () {
            const LST_SCR_ARR   = parent.getLstScrArr() || [];
            const totStdCnt     = LST_SCR_ARR.length;
            let totPercent      = 0;

            const gradeMap      = {};
            gradeKeyArr.forEach(key => gradeMap[key] = 0); // 모든 등급 카운트 0 초기화

            // 총 인원
            $("[name='totStdCnt']").text(totStdCnt);

            // 등급 구간별 인원수 계산
            <%--
                 A_PLUS -> 95 ~ 100
                 A      -> 90 ~ 94
                 B_PLUS -> 85 ~ 89
                 B      -> 80 ~ 84
                 C_PLUS -> 75 ~ 79
                 C      -> 70 ~ 74
                 D_PLUS -> 65 ~ 69
                 D      -> 60 ~ 64
                 F      -> 60미만
            --%>

            LST_SCR_ARR.forEach(lstScr => {
                if      (lstScr >= 95) gradeMap["A_PLUS"] += 1
                else if (lstScr >= 90) gradeMap["A"]      += 1
                else if (lstScr >= 85) gradeMap["B_PLUS"] += 1
                else if (lstScr >= 80) gradeMap["B"]      += 1
                else if (lstScr >= 75) gradeMap["C_PLUS"] += 1
                else if (lstScr >= 70) gradeMap["C"]      += 1
                else if (lstScr >= 65) gradeMap["D_PLUS"] += 1
                else if (lstScr >= 60) gradeMap["D"]      += 1
                else                   gradeMap["F"]      += 1
            });

            // 점수 등급별 인원수 세팅 (테이블)
            gradeKeyArr.forEach(grade => {
                let cnt = gradeMap[grade];
                $("#"+grade + "_CNT").html(cnt);

                let percent = totStdCnt > 0 ? (cnt / totStdCnt * 100).toFixed(1) : 0;
                totPercent += percent;

                percent += '%';
                $("#" + grade + "_RATE").text(percent);
                $("#" + grade + "_RATE").next(".progress").find(".bar").css("width", percent);
            })
        }
    });
</script>
<div id="wrap">

    <div class="mScore_gap">
        <div class="col-7">
            <div class="board_top">
                <h3 class="board-title">절대평가</h3>
                <div class="right-area">
                    <span class="total_txt">[ 대상인원 <b name="totStdCnt"></b>명 ]</span>
                </div>
            </div>

            <div class="table-wrap">
                <table class="table-type3">
                    <colgroup>
                        <col style="width:22%">
                        <col style="width:22%">
                        <col style="">
                        <col style="width:20%">
                    </colgroup>
                    <thead>
                    <tr>
                        <th>등급</th>
                        <th>평점</th>
                        <th>점수</th>
                        <th>인원</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <th data-th="등급"><strong class="txt_grade">A+</strong></th>
                        <td data-th="평점">4.5</td>
                        <td data-th="점수">95 ~ 100</td>
                        <td data-th="인원" id="A_PLUS_CNT"></td>
                    </tr>
                    <tr>
                        <th data-th="등급"><strong class="txt_grade">A</strong></th>
                        <td data-th="평점">4.0</td>
                        <td data-th="점수">90 ~ 94</td>
                        <td data-th="인원" id="A_CNT"></td>
                    </tr>
                    <tr>
                        <th data-th="등급"><strong class="txt_grade">B+</strong></th>
                        <td data-th="평점">3.5</td>
                        <td data-th="점수">85 ~ 89</td>
                        <td data-th="인원" id="B_PLUS_CNT"></td>
                    </tr>
                    <tr>
                        <th data-th="등급"><strong class="txt_grade">B</strong></th>
                        <td data-th="평점">3.0</td>
                        <td data-th="점수">80 ~ 84</td>
                        <td data-th="인원" id="B_CNT"></td>
                    </tr>
                    <tr>
                        <th data-th="등급"><strong class="txt_grade">C+</strong></th>
                        <td data-th="평점">2.5</td>
                        <td data-th="점수">75 ~ 79</td>
                        <td data-th="인원" id="C_PLUS_CNT"></td>
                    </tr>
                    <tr>
                        <th data-th="등급"><strong class="txt_grade">C</strong></th>
                        <td data-th="평점">2.5</td>
                        <td data-th="점수">70 ~ 74</td>
                        <td data-th="인원" id="C_CNT"></td>
                    </tr>
                    <tr>
                        <th data-th="등급"><strong class="txt_grade">D+</strong></th>
                        <td data-th="평점">1.5</td>
                        <td data-th="점수">65 ~ 69</td>
                        <td data-th="인원" id="D_PLUS_CNT"></td>
                    </tr>
                    <tr>
                        <th data-th="등급"><strong class="txt_grade">D</strong></th>
                        <td data-th="평점">1</td>
                        <td data-th="점수">60 ~ 64</td>
                        <td data-th="인원" id="D_CNT"></td>
                    </tr>
                    <tr>
                        <th data-th="등급"><strong class="txt_grade">F</strong></th>
                        <td data-th="평점">0.0</td>
                        <td data-th="점수">60미만</td>
                        <td data-th="인원" id="F_CNT"></td>
                    </tr>
                    <tr class="total">
                        <th colspan="3" data-th="합계"><strong>합계</strong></th>
                        <td data-th="인원"><strong name="totStdCnt">50</strong><strong>명</strong></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="col-5">
            <div class="board_top">
                <h3 class="board-title">실시간 등급 분포도 비율</h3>
            </div>
            <div class="table-wrap">
                <table class="table-type3">
                    <colgroup>
                        <col style="width:22%">
                        <col style="">
                    </colgroup>
                    <thead>
                    <tr>
                        <th>등급</th>
                        <th>분포도 비율(%)</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <th data-th="등급"><strong class="txt_grade">A+</strong></th>
                        <td data-th="분포도 비율(%)">
                            <div class="prog_rate">
                                <span class="meta" id="A_PLUS_RATE"></span>
                                <div class="progress">
                                    <div class="bar blue_type" style="width: 20%;"></div>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th data-th="등급"><strong class="txt_grade">A</strong></th>
                        <td data-th="분포도 비율(%)">
                            <div class="prog_rate">
                                <span class="meta" id="A_RATE"></span>
                                <div class="progress">
                                    <div class="bar blue_type" style="width: 20%;"></div>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th data-th="등급"><strong class="txt_grade">B+</strong></th>
                        <td data-th="분포도 비율(%)">
                            <div class="prog_rate">
                                <span class="meta" id="B_PLUS_RATE"></span>
                                <div class="progress">
                                    <div class="bar blue_type" style="width: 20%;"></div>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th data-th="등급"><strong class="txt_grade">B</strong></th>
                        <td data-th="분포도 비율(%)">
                            <div class="prog_rate">
                                <span class="meta" id="B_RATE"></span>
                                <div class="progress">
                                    <div class="bar blue_type" style="width: 20%;"></div>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th data-th="등급"><strong class="txt_grade">C+</strong></th>
                        <td data-th="분포도 비율(%)">
                            <div class="prog_rate">
                                <span class="meta" id="C_PLUS_RATE"></span>
                                <div class="progress">
                                    <div class="bar blue_type" style="width: 10%;"></div>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th data-th="등급"><strong class="txt_grade">C</strong></th>
                        <td data-th="분포도 비율(%)">
                            <div class="prog_rate">
                                <span class="meta" id="C_RATE"></span>
                                <div class="progress">
                                    <div class="bar blue_type" style="width: 7.5%;"></div>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th data-th="등급"><strong class="txt_grade">D+</strong></th>
                        <td data-th="분포도 비율(%)">
                            <div class="prog_rate">
                                <span class="meta" id="D_PLUS_RATE"></span>
                                <div class="progress">
                                    <div class="bar blue_type" style="width: 0%;"></div>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th data-th="등급"><strong class="txt_grade">D</strong></th>
                        <td data-th="분포도 비율(%)">
                            <div class="prog_rate">
                                <span class="meta" id="D_RATE"></span>
                                <div class="progress">
                                    <div class="bar blue_type" style="width: 0%;"></div>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th data-th="등급"><strong class="txt_grade">F</strong></th>
                        <td data-th="분포도 비율(%)">
                            <div class="prog_rate">
                                <span class="meta" id="F_RATE"></span>
                                <div class="progress">
                                    <div class="bar blue_type" style="width: 2.5%;"></div>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr class="total">
                        <th data-th="합계"><strong>합계</strong></th>
                        <td data-th="분포도 비율(%)"><strong>100%</strong></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="btns">
        <button type="button" class="btn sm type4" name="chgButton2" id="btnSave" onclick="window.parent.finalSave()">
            <spring:message code="score.button.save.score"/><%--성적처리저장--%>
        </button>
        <button class="btn type2" onclick="window.parent.closeDialog();">
            <spring:message code="exam.button.close" /><%--닫기--%>
        </button>
    </div>
</div>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
