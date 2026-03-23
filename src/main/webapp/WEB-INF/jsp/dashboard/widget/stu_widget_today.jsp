<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

    <div class="today_stu">
        <div class="chart_wrap" style="max-width:140px">
            <div id="arc" class="donut_chart"></div>
            <div class="middle_text">
                <span class="chart_value"></span>
                <span>진도율</em></span>
            </div>
        </div>

        <div class="info_wrap">
            
            <ul class="sec_list">
                <li>
                    <span class="tit">Today</span>
                    <span class="desc">${todayDate}</span>
                </li>
                <li>
                    <div class="sec_item_tit">
                       <span>접속</span>
                        <!-- 접속 현황 레이어 -->
                        <div class="user-option-wrap">
                                                
                        </div> 
                    </div>
                    <span class="desc"><strong>37</strong>250</span>
                </li>
                <li>
                    <span class="tit">결시원신청</span>
                    <span class="desc"><strong>2</strong>10</span>
                </li>
                <li>
                    <span class="tit">장애인지원신청</span>
                    <span class="desc"><strong>5</strong>5</span>
                </li>
                <li>
                    <span class="tit help" data-tooltip="이의신청 미처리 건수가 있습니다." data-position="top center">성적이의신청<small class="msg_num"></small></span>
                    <span class="desc"><strong>3</strong>5</span>
                </li>
            </ul>
        </div>
    </div>
                                
                                

<script>

// Today 위젯 설정
function setTodayWidget() {

	// Today 차트 그리기
    function drawChart() {
        // 컨테이너 크기에 맞게 크기 조절 (최대 158px)
        var containerWidth = $('#arc').width();
        var size = Math.min(containerWidth, 140);
        var width = size;
        var height = size;

        // 반지름 계산 (size 기준 비율로)
        var outerRadius = size / 2 * 0.98; // 90% 크기
        var innerRadius = outerRadius * 0.7;

        // 기존 svg 삭제 (다시 그리기 대비)
        d3.select("#arc").selectAll("svg").remove();

        // arc 함수 다시 정의 (반지름 반영)
        function fn_getArc(ammount, total) {
            return d3.arc()
                .innerRadius(innerRadius)
                .outerRadius(outerRadius)
                .startAngle(0)
                .endAngle(fn_getPercent_pie(ammount, total))
                .cornerRadius(100);
        }

        // pie 각도 함수
        function fn_getPercent_pie(ammount, total) {
            var ratio = ammount / total;
            return Math.PI * 2 * ratio;
        }

        // 데이터
        var data = { cnt: 60, all: 100 };

        var svg = d3.select("#arc")
            .append("svg")
            .attr("width", width)
            .attr("height", height)
            .append("g")
            .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

        // 그라데이션 정의
        var defs = svg.append("defs");

        var gradient = defs.append("linearGradient")
            .attr("id", "attendanceGradient")
            .attr("x1", "0%").attr("y1", "0%")
            .attr("x2", "100%").attr("y2", "100%");

        gradient.append("stop")
            .attr("offset", "0%")
            .attr("stop-color", "#41A5EC");

        gradient.append("stop")
            .attr("offset", "100%")
            .attr("stop-color", "#84C2EE");

        // 배경
        svg.append("path")
            .attr("class", "arc")
            .attr("d", fn_getArc(100, 100))
            .attr("fill", "#EBEBEB");

        // 실제 데이터
        svg.append("path")
            .attr("class", "arc")
            .attr("d", fn_getArc(data.cnt, data.all))
            .attr("fill", "url(#attendanceGradient)");

        // 중앙 텍스트 업데이트
        $('.chart_value').text(data.cnt + '%');
    }

    drawChart();

    // 창 크기 변경 시 다시 그리기
    $(window).resize(function () {
        drawChart();
    });
}

setTodayWidget();

</script>