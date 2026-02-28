<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!-- 정규과목 grid형 -->
<ul class="stu_c_grid">
    <li class="st2">
        <div class="ui top attached segment grid_tit">
            <div class="lect_tit"><a href="#0" target="_blank">[사회] 유럽 문화 탐방(1반)</a></div>
            <div class="lect_auth"><span>담당교수</span>김영훈</div>
        </div>
        <div class="ui attached segment grid_cont">
            <div class="exam_date">
                <div class="mid_term">
                    <b class="mr10">중간고사</b>
                    <ul class="list_verticalline">
                        <li>
                            <span class="fcDark3">2022.04.16 18:00</span>
                        </li>
                        <li>
                            <b class="mr5 fcGrey">시간</b>
                            <span class="fcBlack">30분</span>
                        </li>
                    </ul>
                </div>
                <div class="final">
                    <b class="mr10">기말고사</b>
                    <ul class="list_verticalline">
                        <li>
                            <span class="fcDark3">2022.04.16 18:00</span>
                        </li>
                        <li>
                            <b class="mr5 fcGrey">시간</b>
                            <span class="fcBlack">30분</span>
                        </li>
                    </ul>
                </div>
            </div>
            <!-- <div class="ui divider"></div> -->
            <ul class="r_learnInfo">
                <li>
                    <div class="list_slash">
                        <b class="fcBlue">1</b>
                        <span class="fcDarkC">2</span>
                    </div>
                    <div class="l_tit">Q&A</div>
                </li>
                <li>
                    <div class="list_slash">
                        <b class="fcBlue">1</b>
                        <span class="fcDarkC">2</span>
                    </div>
                    <div class="l_tit">시험</div>
                </li>
                <li>
                    <div class="list_slash">
                        <b class="fcBlue">1</b>
                        <span class="fcDarkC">13</span>
                    </div>
                    <div class="l_tit">과제</div>
                </li>
                <li>
                    <div class="list_slash">
                        <b class="fcBlue">1</b>
                        <span class="fcDarkC">2</span>
                    </div>
                    <div class="l_tit">토론</div>
                </li>
                <li>
                    <div class="list_slash">
                        <b class="fcBlue">1</b>
                        <span class="fcDarkC">2</span>
                    </div>
                    <div class="l_tit">퀴즈</div>
                </li>
            </ul>
            <!-- <ul class="sq_week">
                <li class="bcBlue">1</li>
                <li class="bcRed">2</li>
                <li class="bcBlue">3</li>
                <li class="bcYellow">4</li>
                <li class="bcBlue">5</li>
                <li class="bcGreen">6</li>
                <li>7</li>
                <li>중간</li>
                <li>9</li>
                <li>10</li>
                <li>11</li>
                <li>12</li>
                <li>13</li>
                <li>14</li>
                <li>기말</li>
            </ul> -->

            <!-- <div class="ui divider"></div> -->
            <b class="">학습진행현황</b>
            <ul class="sq_week st2">
                <li class="state_ok on">
                    <a href="#0">
                        <span class="week">1</span>
                        <span class="state"><i class="xi-radiobox-blank"></i></span> <!-- 상태 표시 감싸는 괄호 삭제_221214-->
                    </a>
                </li>
                <li class="state_bad">
                    <a href="#0">
                        <span class="week">2</span>
                        <span class="state"><i class="xi-close"></i></span>
                    </a>
                </li>
                <li class="state_norm">
                    <a href="#0">
                        <span class="week">3</span>
                        <span class="state"><i class="ion-ios-play-outline c_rotate"></i></span>
                    </a>
                </li>
                <li class="state_ing">
                    <a href="#0">
                        <span class="week">4</span>
                        <span class="state"><i class="xi-full-moon"></i></span><!-- 아이콘 클래스 변경_221214-->
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">5</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">6</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">7</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">중간</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">9</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">10</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">11</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">12</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">13</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">14</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">기말</span>
                    </a>
                </li>
            </ul>


            <div class="learn_progress"> 
                <div class="prog_box"> <!-- row 클래스 삭제_221208 -->
                    <label for="myAverage_lect01">나의 진도율</label>
                    <div class="ui indicating progress my_average" data-value="50" data-total="100" id="myAverage_lect01">
                        <div class="bar">
                            <div class="progress"></div>
                        </div>
                    </div>
                </div>
                <div class="prog_box"> <!-- row 클래스 삭제_221208 -->
                    <label for="allAverage_lect01">전체 진도율</label>
                    <div class="ui indicating progress all_average" data-value="79" data-total="100" id="allAverage_lect01">
                        <div class="bar">
                            <div class="progress"></div>
                        </div>
                    </div>
                </div>
            </div>


        </div>
    </li>
    <li class="st2">
        <div class="ui top attached segment grid_tit">
            <div class="lect_tit"><a href="#0" target="_blank">[사회] 유럽 문화 탐방(1반)</a></div>
            <div class="lect_auth"><span>담당교수</span>김영훈</div>
        </div>
        <div class="ui attached segment grid_cont">
            <div class="exam_date">
                <div class="mid_term">
                    <b class="mr10">중간고사</b>
                    <ul class="list_verticalline">
                        <li>
                            <span class="fcDark3">2022.04.16 18:00</span>
                        </li>
                        <li>
                            <b class="mr5 fcGrey">시간</b>
                            <span class="fcBlack">30분</span>
                        </li>
                    </ul>
                </div>
                <div class="final">
                    <b class="mr10">기말고사</b>
                    <ul class="list_verticalline">
                        <li>
                            <span class="fcDark3">2022.04.16 18:00</span>
                        </li>
                        <li>
                            <b class="mr5 fcGrey">시간</b>
                            <span class="fcBlack">30분</span>
                        </li>
                    </ul>
                </div>
            </div>
            <!-- <div class="ui divider"></div> -->
            <ul class="r_learnInfo">
                <li>
                    <div class="list_slash">
                        <b class="fcBlue">1</b>
                        <span class="fcDarkC">2</span>
                    </div>
                    <div class="l_tit">Q&A</div>
                </li>
                <li>
                    <div class="list_slash">
                        <b class="fcBlue">1</b>
                        <span class="fcDarkC">2</span>
                    </div>
                    <div class="l_tit">시험</div>
                </li>
                <li>
                    <div class="list_slash">
                        <b class="fcBlue">1</b>
                        <span class="fcDarkC">13</span>
                    </div>
                    <div class="l_tit">과제</div>
                </li>
                <li>
                    <div class="list_slash">
                        <b class="fcBlue">1</b>
                        <span class="fcDarkC">2</span>
                    </div>
                    <div class="l_tit">토론</div>
                </li>
                <li>
                    <div class="list_slash">
                        <b class="fcBlue">1</b>
                        <span class="fcDarkC">2</span>
                    </div>
                    <div class="l_tit">퀴즈</div>
                </li>
            </ul>
            <!-- <ul class="sq_week">
                <li class="bcBlue">1</li>
                <li class="bcRed">2</li>
                <li class="bcBlue">3</li>
                <li class="bcYellow">4</li>
                <li class="bcBlue">5</li>
                <li class="bcGreen">6</li>
                <li>7</li>
                <li>중간</li>
                <li>9</li>
                <li>10</li>
                <li>11</li>
                <li>12</li>
                <li>13</li>
                <li>14</li>
                <li>기말</li>
            </ul> -->

            <!-- <div class="ui divider"></div> -->
            <b class="">학습진행현황</b>
            <ul class="sq_week st2">
                <li class="state_ok on">
                    <a href="#0">
                        <span class="week">1</span>
                        <span class="state"><i class="xi-radiobox-blank"></i></span> <!-- 상태 표시 감싸는 괄호 삭제_221214-->
                    </a>
                </li>
                <li class="state_bad">
                    <a href="#0">
                        <span class="week">2</span>
                        <span class="state"><i class="xi-close"></i></span>
                    </a>
                </li>
                <li class="state_norm">
                    <a href="#0">
                        <span class="week">3</span>
                        <span class="state"><i class="ion-ios-play-outline c_rotate"></i></span>
                    </a>
                </li>
                <li class="state_ing">
                    <a href="#0">
                        <span class="week">4</span>
                        <span class="state"><i class="xi-full-moon"></i></span><!-- 아이콘 클래스 변경_221214-->
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">5</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">6</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">7</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">중간</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">9</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">10</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">11</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">12</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">13</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">14</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">기말</span>
                    </a>
                </li>
            </ul>





            

            <div class="learn_progress">
                <div class="prog_box">
                    <label for="myAverage_lect01">나의 진도율</label>
                    <div class="ui indicating small progress my_average" data-value="84" data-total="100" id="myAverage_lect01">
                        <div class="bar">
                            <div class="progress"></div>
                        </div>
                    </div>
                </div>
                <div class="prog_box">
                    <label for="allAverage_lect01">전체 진도율</label>
                    <div class="ui indicating small progress all_average" data-value="79" data-total="100" id="allAverage_lect01">
                        <div class="bar">
                            <div class="progress"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </li>
    <li class="st2">
        <div class="ui top attached segment grid_tit">
            <div class="lect_tit"><a href="#0" target="_blank">[사회] 유럽 문화 탐방(1반)</a></div>
            <div class="lect_auth"><span>담당교수</span>김영훈</div>
        </div>
        <div class="ui attached segment grid_cont">
            <div class="exam_date">
                <div class="mid_term">
                    <b class="mr10">중간고사</b>
                    <ul class="list_verticalline">
                        <li>
                            <span class="fcDark3">2022.04.16 18:00</span>
                        </li>
                        <li>
                            <b class="mr5 fcGrey">시간</b>
                            <span class="fcBlack">30분</span>
                        </li>
                    </ul>
                </div>
                <div class="final">
                    <b class="mr10">기말고사</b>
                    <ul class="list_verticalline">
                        <li>
                            <span class="fcDark3">2022.04.16 18:00</span>
                        </li>
                        <li>
                            <b class="mr5 fcGrey">시간</b>
                            <span class="fcBlack">30분</span>
                        </li>
                    </ul>
                </div>
            </div>
            <!-- <div class="ui divider"></div> -->
            <ul class="r_learnInfo">
                
                <li>
                    <div class="list_slash">
                        <b class="fcBlue">1</b>
                        <span class="fcDarkC">2</span>
                    </div>
                    <div class="l_tit">시험</div>
                </li>
                <li>
                    <div class="list_slash">
                        <b class="fcBlue">1</b>
                        <span class="fcDarkC">13</span>
                    </div>
                    <div class="l_tit">과제</div>
                </li>
                <li>
                    <div class="list_slash">
                        <b class="fcBlue">1</b>
                        <span class="fcDarkC">2</span>
                    </div>
                    <div class="l_tit">토론</div>
                </li>
                <li>
                    <div class="list_slash">
                        <b class="fcBlue">1</b>
                        <span class="fcDarkC">2</span>
                    </div>
                    <div class="l_tit">퀴즈</div>
                </li>
            </ul>
            <!-- <ul class="sq_week">
                <li class="bcBlue">1</li>
                <li class="bcRed">2</li>
                <li class="bcBlue">3</li>
                <li class="bcYellow">4</li>
                <li class="bcBlue">5</li>
                <li class="bcGreen">6</li>
                <li>7</li>
                <li>중간</li>
                <li>9</li>
                <li>10</li>
                <li>11</li>
                <li>12</li>
                <li>13</li>
                <li>14</li>
                <li>기말</li>
            </ul> -->

            <!-- <div class="ui divider"></div> -->
            <b class="">학습진행현황</b>
            <ul class="sq_week st2">
                <li class="state_ok on">
                    <a href="#0">
                        <span class="week">1</span>
                        <span class="state"><i class="xi-radiobox-blank"></i></span> <!-- 상태 표시 감싸는 괄호 삭제_221214-->
                    </a>
                </li>
                <li class="state_bad">
                    <a href="#0">
                        <span class="week">2</span>
                        <span class="state"><i class="xi-close"></i></span>
                    </a>
                </li>
                <li class="state_norm">
                    <a href="#0">
                        <span class="week">3</span>
                        <span class="state"><i class="ion-ios-play-outline c_rotate"></i></span>
                    </a>
                </li>
                <li class="state_ing">
                    <a href="#0">
                        <span class="week">4</span>
                        <span class="state"><i class="xi-full-moon"></i></span><!-- 아이콘 클래스 변경_221214-->
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">5</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">6</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">7</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">중간</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">9</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">10</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">11</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">12</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">13</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">14</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">기말</span>
                    </a>
                </li>
            </ul>


            <div class="learn_progress"> 
                <div class="prog_box"> <!-- row 클래스 삭제_221208 -->
                    <label for="myAverage_lect01">나의 진도율</label>
                    <div class="ui indicating progress my_average" data-value="50" data-total="100" id="myAverage_lect01">
                        <div class="bar">
                            <div class="progress"></div>
                        </div>
                    </div>
                </div>
                <div class="prog_box"> <!-- row 클래스 삭제_221208 -->
                    <label for="allAverage_lect01">전체 진도율</label>
                    <div class="ui indicating progress all_average" data-value="79" data-total="100" id="allAverage_lect01">
                        <div class="bar">
                            <div class="progress"></div>
                        </div>
                    </div>
                </div>
            </div>


        </div>
    </li>
    <li class="st2">
        <div class="ui top attached segment grid_tit">
            <div class="lect_tit"><a href="#0" target="_blank">[사회] 유럽 문화 탐방(1반)</a></div>
            <div class="lect_auth"><span>담당교수</span>김영훈</div>
        </div>
        <div class="ui attached segment grid_cont">
            <div class="exam_date">
                <div class="mid_term">
                    <b class="mr10">중간고사</b>
                    <ul class="list_verticalline">
                        <li>
                            <span class="fcDark3">2022.04.16 18:00</span>
                        </li>
                        <li>
                            <b class="mr5 fcGrey">시간</b>
                            <span class="fcBlack">30분</span>
                        </li>
                    </ul>
                </div>
                <div class="final">
                    <b class="mr10">기말고사</b>
                    <ul class="list_verticalline">
                        <li>
                            <span class="fcDark3">2022.04.16 18:00</span>
                        </li>
                        <li>
                            <b class="mr5 fcGrey">시간</b>
                            <span class="fcBlack">30분</span>
                        </li>
                    </ul>
                </div>
            </div>
            <!-- <div class="ui divider"></div> -->
            <ul class="r_learnInfo">
                <li>
                    <div class="list_slash">
                        <b class="fcBlue">1</b>
                        <span class="fcDarkC">2</span>
                    </div>
                    <div class="l_tit">Q&A</div>
                </li>
                <li>
                    <div class="list_slash">
                        <b class="fcBlue">1</b>
                        <span class="fcDarkC">2</span>
                    </div>
                    <div class="l_tit">시험</div>
                </li>
                <li>
                    <div class="list_slash">
                        <b class="fcBlue">1</b>
                        <span class="fcDarkC">13</span>
                    </div>
                    <div class="l_tit">과제</div>
                </li>
            </ul>
            <!-- <ul class="sq_week">
                <li class="bcBlue">1</li>
                <li class="bcRed">2</li>
                <li class="bcBlue">3</li>
                <li class="bcYellow">4</li>
                <li class="bcBlue">5</li>
                <li class="bcGreen">6</li>
                <li>7</li>
                <li>중간</li>
                <li>9</li>
                <li>10</li>
                <li>11</li>
                <li>12</li>
                <li>13</li>
                <li>14</li>
                <li>기말</li>
            </ul> -->

            <!-- <div class="ui divider"></div> -->
            <b class="">학습진행현황</b>
            <ul class="sq_week st2">
                <li class="state_ok on">
                    <a href="#0">
                        <span class="week">1</span>
                        <span class="state"><i class="xi-radiobox-blank"></i></span> <!-- 상태 표시 감싸는 괄호 삭제_221214-->
                    </a>
                </li>
                <li class="state_bad">
                    <a href="#0">
                        <span class="week">2</span>
                        <span class="state"><i class="xi-close"></i></span>
                    </a>
                </li>
                <li class="state_norm">
                    <a href="#0">
                        <span class="week">3</span>
                        <span class="state"><i class="ion-ios-play-outline c_rotate"></i></span>
                    </a>
                </li>
                <li class="state_ing">
                    <a href="#0">
                        <span class="week">4</span>
                        <span class="state"><i class="xi-full-moon"></i></span><!-- 아이콘 클래스 변경_221214-->
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">5</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">6</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">7</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">중간</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">9</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">10</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">11</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">12</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">13</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">14</span>
                    </a>
                </li>
                <li>
                    <a href="#0">
                        <span class="week">기말</span>
                    </a>
                </li>
            </ul>





            

            <div class="learn_progress">
                <div class="prog_box">
                    <label for="myAverage_lect01">나의 진도율</label>
                    <div class="ui indicating small progress my_average" data-value="84" data-total="100" id="myAverage_lect01">
                        <div class="bar">
                            <div class="progress"></div>
                        </div>
                    </div>
                </div>
                <div class="prog_box">
                    <label for="allAverage_lect01">전체 진도율</label>
                    <div class="ui indicating small progress all_average" data-value="79" data-total="100" id="allAverage_lect01">
                        <div class="bar">
                            <div class="progress"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </li>

</ul>
<!-- //정규과목 grid형 -->