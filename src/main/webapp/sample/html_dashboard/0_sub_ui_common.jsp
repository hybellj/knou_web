<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="dashboard"/>
	</jsp:include>
</head>

<body class="home colorA "><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp"/>
        <!-- //common header -->

        <!-- dashboard -->
        <main class="common">

            <!-- gnb -->
			<jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="dashboard_sub">

                    <div class="sub-content">
						<div class="page-info">
                            <h2 class="page-title">UI 공통 모음</h2>
                        </div>

						<h4 class="sub-title ">로딩 표시</h4>
						<div class="table-wrap">
							<table class="table-type2">
								<colgroup>
									<col style="width:40%">
									<col style="width:45%">
									<col style="width:15%">
								</colgroup>
								<tbody>
									<tr>
										<td class="t_left">
<pre>
로딩 표시
UiComm.showLoading(type, message);
  - type: true/false (보이기/닫기)
  - message: 메시지(생략가능)
</pre>
										</td>
										<td class="t_left">
											로딩 표시 : UiComm.showLoading(true);<br>
											로딩 닫기 : UiComm.showLoading(false);<br>
											로딩 표시(메시지 포함) : UiComm.showLoading(true, "메시지");
										</td>
										<td>
											<button type="button" class="btn gray1" onclick="testLoading1()">로딩 표시</button><br><br>
											<button type="button" class="btn gray1" onclick="testLoading2()">로딩(메시지표시)</button>
										</td>
									</tr>
								</tbody>
							</table>
							<script>
								function testLoading1() {
									// 로딩 보이기
									UiComm.showLoading(true);

									// 5초 후에 로딩 닫기 테스트
									setTimeout(function(){
										UiComm.showLoading(false);
									}, 5000);
								}

								function testLoading2() {
									// 로딩 보이기
									UiComm.showLoading(true, "로딩중 메시지 표시...");

									// 5초 후에 로딩 닫기 테스트
									setTimeout(function(){
										UiComm.showLoading(false);
									}, 5000);
								}
							</script>
						</div>

						<br><br><br>


                        <h4 class="sub-title ">메시지 표시</h4>
                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:30%">
                                    <col style="width:55%">
                                    <col style="width:15%">
                                </colgroup>
                                <tbody>
                                	<tr>
                                    	<td class="t_left" colspan=3>
<pre>
메시지 표시 (메시지 다이얼로그)
UiComm.showMessage(message, type, width);
  - message: 메시지 내용
  - type : 메시지 Type(info:정보(default), success:성공, error:오류, warning:경고, confirm:컨펌)
  - width : 메시지창 너비(생략가능, 기본값 400)
</pre>
                                    	</td>
                                    </tr>
                                	<tr>
                                    	<td class="t_left">
                                    		메시지 호출
                                    	</td>
                                        <td class="t_left">
                                        	정보 메시지 : UiComm.showMessage("메시지 내용입니다.", "info");<br>
                                        	성공 메시지 : UiComm.showMessage("메시지 내용입니다.", "success");<br>
                                        	에러 메시지 : UiComm.showMessage("메시지 내용입니다.", "error");<br>
                                        	경고 메시지 : UiComm.showMessage("메시지 내용입니다.", "warning");
                                        </td>
                                        <td>
                                        	<button type="button" class="btn gray1" onclick="message1('info')">정보</button>
											<button type="button" class="btn gray1" onclick="message1('success')">성공</button>
											<br><br>
											<button type="button" class="btn gray1" onclick="message1('error')">에러</button>
											<button type="button" class="btn gray1" onclick="message1('warning')">경고</button>
                                        <td>
                                    </tr>
                                    <tr>
                                    	<td class="t_left">
                                    		메시지창 닫을때 스크립트 실행
                                    	</td>
                                        <td class="t_left">
<pre>
UiComm.showMessage("시스템 오류가 발생했습니다.", "error", 500)
.then(function(result) {
	// 메시지 닫은후 실행
	alert("메시지 닫음...");
});
</pre>
                                        </td>
                                        <td>
                                        	<button type="button" class="btn gray1" onclick="message2()">메시지</button>
                                        <td>
                                    </tr>
                                    <tr>
                                    	<td class="t_left">
                                    		컨펌 메시지
                                    	</td>
                                        <td class="t_left">
<pre>
UiComm.showMessage("내용을 삭제하시겠습니까?", "confirm")
.then(function(result) {
	if (result) {
		// '확인' 선택
		alert("선택="+result);
	}
	else {
		// '취소' 선택
		alert("선택="+result);
	}
});
</pre>
										<td>
                                        	<button type="button" class="btn gray1" onclick="confirmMessage()">컨펌</button>
                                        <td>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <script>
                            	function message1(type) {
                            		UiComm.showMessage("메시지 내용입니다.", type);
                            	}

                            	function message2() {
                            		UiComm.showMessage("시스템 오류가 발생했습니다.", "error", 500)
                            		.then(function(result) {
                            			// 메시지 닫은후 처리
                            			alert("메시지 닫음...");
                            		});
                            	}

                            	function confirmMessage() {
                            		let cfm = UiComm.showMessage("내용을 삭제하시겠습니까?", "confirm");
                                	cfm.then(function(result) {
										if (result) {
											// '확인' 선택
											alert("선택="+result);
										}
										else {
											// '취소' 선택
											alert("선택="+result);
										}
									});
                            	}
                            </script>
						</div>

						<br><br><br>

						<h4 class="sub-title ">다이얼로그</h4>
						<div class="table-wrap">
							<table class="table-type2">
								<colgroup>
									<col style="width:30%">
									<col style="width:55%">
									<col style="width:15%">
								</colgroup>
								<tbody>
									<tr>
										<td class="t_left" colspan="3">
<pre>
다이얼로그
let dialog1 = UiDialog("DIALOG_ID", {
	[옵션]
});
  - title: 타이틀
  - width: 너비
  - height: 높이
  - resizable: 리사이즈 여부 (true/false, 기본값:true)
  - draggabe: 드래그 여부 (true/false, 기본값:true)
  - modal: 모달 여부 (true/false, 기본값:true)
  - html: 다이얼로그 html 내용
  - url: 다이얼로그 내용에 url 호출(iframe)
  - autoresize: 자동 사이즈 조절(true/false, 기본값:false, url인 경우 내용 사이즈에 맞게 다이어로그 높이 자동 조절)
  - position:	다이얼로그 포지션 {my:"center top", at:"center top", of:"#TARGET"}

// 다이어로그 닫기
dialog1.close();
</pre>
										</td>
									</tr>
									<tr>
										<td class="t_left">
											다이어로그 URL 열기
										</td>
										<td class="t_left">
<pre>
let dialog1 = UiDialog("dialog1", {
	title: "테스트",
	width: 600,
	height: 500,
	url: "test.jsp"
});

let dialog2 = UiDialog("dialog2", {
	title: "테스트",
	width: 600,
	height: 500,
	url: "test.jsp",
	autoresize: true
});
</pre>
										</td>
										<td>
											<button type="button" class="btn gray1" onclick="dialog1()">다이얼로그</button>
											<br><br>
											<button type="button" class="btn gray1" onclick="dialog2()">autoresize</button>
										</td>
									</tr>
									<tr>
										<td class="t_left">
											다이어로그 내용 넣기
										</td>
										<td class="t_left">
<pre>
let dialog3 = UiDialog("dialog3", {
	title: "테스트",
	width: 600,
	height: 500,
	html: "안녕하세요!&lt;br&gt;찾아주신 수강생분들께 진심으로 감사드립니다."
});
</pre>
										</td>
										<td>
											<button type="button" class="btn gray1" onclick="dialog3()">다이얼로그</button>
										</td>
									</tr>
									<tr>
										<td class="t_left">
											다이어로그 위치 지정
										</td>
										<td class="t_left">
											<div id="posBox1" style="border:1px solid #000;background:rgb(255, 252, 217);width:200px;height:50px;"> 여기에 위치...<br> (id=posBox1) </div>
<pre>
let dialog4 = UiDialog("dialog4", {
	title: "테스트",
	width: 400,
	height: 200,
	html: "안녕하세요!",
	position: {my:"center top", at:"center top", of:"#posBox1"}
});
</pre>
										</td>
										<td>
											<button type="button" class="btn gray1" onclick="dialog4()">다이얼로그</button>
										</td>
									</tr>
								</tbody>
							</table>
							<script>
							function dialog1() {
								let dialog1 = UiDialog("dialog1", {
									title: "테스트",
									width: 600,
									height: 500,
									url: "test.jsp"
								});
							}

							function dialog2() {
								let dialog2 = UiDialog("dialog2", {
									title: "테스트",
									width: 600,
									height: 500,
									url: "test.jsp",
									autoresize: true
								});
							}

							function dialog3() {
								let dialog3 = UiDialog("dialog3", {
									title: "테스트",
									width: 600,
									height: 500,
									html: "안녕하세요!<br>찾아주신 수강생분들께 진심으로 감사드립니다."
								});
							}

							function dialog4() {
								let dialog4 = UiDialog("dialog4", {
									title: "테스트",
									width: 400,
									height: 200,
									html: "안녕하세요!",
									position: {my:"center top", at:"center top", of:"#posBox1"}
								});
							}
							</script>
						</div>

						<br><br><br>

						<h4 class="sub-title ">입력창 제한 설정 (inputmask)</h4>
						<div class="table-wrap">
							<table class="table-type2">
								<colgroup>
									<col style="width:30%">
									<col style="width:70%">
								</colgroup>
								<tbody>
									<tr>
										<td class="t_left">
											<b>숫자 입력, (최대 1000)</b><br>
											<input type="text" style="width:100px" inputmask="numeric" maxVal="1000"><br>
										</td>
										<td class="t_left">
											&lt;input type="text" style="width:100px" inputmask="numeric" maxVal="1000"&gt;
										</td>
									</tr>
									<tr>
										<td class="t_left">
											<b>점수입력 (소수점 2자리, 최대:100)</b><br>
											<input type="text" style="width:100px" inputmask="numeric" mask="999.99" maxVal="100">
										</td>
										<td class="t_left">
											&lt;input type="text" style="width:100px" inputmask="numeric" mask="999.99" maxVal="100"&gt;
										</td>
									</tr>
									<tr>
										<td class="t_left">
											<b>금액 입력 (최대 100,000)</b><br>
											<input type="text" style="width:100px" inputmask="money" maxVal="100000">
										</td>
										<td class="t_left">
											&lt;input type="text" style="width:100px" inputmask="money" maxVal="100000"&gt;
										</td>
									</tr>
									<tr>
										<td class="t_left">
											<b>날짜/시간</b><br>
											<input type="text" style="width:120px;" inputmask="date">
											<input type="text" style="width:80px;" inputmask="time">
										</td>
										<td class="t_left">
											&lt;input type="text" style="width:120px" inputmask="date"&gt;<br>
											&lt;input type="text" style="width:80px" inputmask="time"&gt;
										</td>
									</tr>
									<tr>
										<td class="t_left">
											<b>전화번호 입력</b><br>
											<input type="text" style="width:200px" inputmask="phone">
										</td>
										<td class="t_left">
											&lt;input type="text" style="width:100px" inputmask="phone"&gt;
										</td>
									</tr>
									<tr>
										<td class="t_left">
											<b>이메일주소 입력</b><br>
											<input type="text" style="width:200px" inputmask="email">
										</td>
										<td class="t_left">
											&lt;input type="text" style="width:200px" inputmask="email"&gt;
										</td>
									</tr>
									<tr>
										<td class="t_left">
											<b>입력 길이 제한 (10byte)</b><br>
											<input type="text" style="width:200px" inputmask="byte" maxLen="10">
										</td>
										<td class="t_left">
											&lt;input type="text" style="width:200px" inputmask="byte" maxLen="10"&gt;
											<br>
											한글 : 3byte로 계산
										</td>
									</tr>
									<tr>
										<td class="t_left">
											<b>입력 길이 제한 (10자)</b><br>
											<input type="text" style="width:200px" inputmask="length" maxLen="10">
										</td>
										<td class="t_left">
											&lt;input type="text" style="width:200px" inputmask="length" maxLen="10"&gt;
											<br>
											한글 : 1자로 계산
										</td>
									</tr>
									<tr>
										<td class="t_left">
											<b>기타 입력, mask값으로 정의</b><br>
											<input type="text" style="width:200px" inputmask="etc" mask="a99-99[9][9]">
										</td>
										<td class="t_left">
											&lt;input type="text" style="width:200px" inputmask="etc" mask="a99-99[9][9]"&gt;<br>
										</td>
									</tr>
									<tr>
										<td class="t_left">
											<b>기타 입력, 문자만(10자)</b><br>
											<input type="text" style="width:200px" inputmask="etc" mask="a{1,10}">
										</td>
										<td class="t_left">
											&lt;input type="text" style="width:200px" inputmask="etc" mask="a{1,10}"&gt;
										</td>
									</tr>
									<tr>
										<td class="t_left">
											<b>textarea 입력 길이 제한 (60byte)</b><br>
											<textarea class="form-control" style="width:300px;height:70px" maxLenCheck="byte,60,true,true"></textarea>
										</td>
										<td class="t_left">
											&lt;textarea style="width:300px;height:70px" maxLenCheck="byte,60,true,true"&gt;&lt;/textarea&gt;
											<br>
											한글 : 3byte로 계산
											<br>
											파라메터 : type(byte/length), size, showCount(true/false), showMessage(true/false)
										</td>
									</tr>
									<tr>
										<td class="t_left">
											<b>textarea 입력 길이 제한 (60자)</b><br>
											<textarea class="form-control" style="width:300px;height:70px" maxLenCheck="length,60,true,false"></textarea>
										</td>
										<td class="t_left">
											&lt;textarea style="width:300px;height:70px" maxLenCheck="length,60,true,false"&gt;&lt;/textarea&gt;
											<br>
											한글 : 1자로 계산
											<br>
											파라메터 : type(byte/length), size, showCount(true/false), showMessage(true/false)
										</td>
									</tr>
								</tbody>
							</table>
							<script>

							</script>
						</div>

						<br><br><br>


						<h4 class="sub-title ">Checkbox, Radio</h4>
						<div class="table-wrap">
							<table class="table-type2">
								<colgroup>
									<col style="width:30%">
									<col style="width:70%">
								</colgroup>
								<tbody>
									<tr>
										<td class="t_left">
											<span class="custom-input">
												<input type="checkbox" name="name" id="checkType1">
												<label for="checkType1">옵션A</label>
											</span>
										</td>
										<td class="t_left">
											&lt;span class="custom-input"&gt;<br>
											&nbsp; &nbsp; &lt;input type="checkbox" name="name" id="checkType1"&gt;<br>
											&nbsp; &nbsp; &lt;label for="checkType1">옵션A&lt;/label&gt;<br>
											&lt;/span>
										</td>
									</tr>
									<tr>
										<td class="t_left">
											<span class="custom-input">
												<input type="radio" name="emailRecv" id="emailRecvY" value="Y" checked="">
												<label for="emailRecvY">YES</label>
											</span>
											<span class="custom-input ml5">
												<input type="radio" name="emailRecv" id="emailRecvN" value="N">
												<label for="emailRecvN">NO</label>
											</span>
										</td>
										<td class="t_left">
											&lt;span class="custom-input"&gt;<br>
											&nbsp; &nbsp; &lt;input type="checkbox" name="name" id="checkType1"&gt;<br>
											&nbsp; &nbsp; &lt;label for="checkType1">옵션A&lt;/label&gt;<br>
											&lt;/span&gt;
										</td>
									</tr>
									<tr>
										<td class="t_left">
											<input type="radio" name="emailRecv2" id="emailRecvY2_yes" value="Y" checked="" class="switch">
											<label for="emailRecvY2_yes">YES</label> &nbsp;
											<input type="radio" name="emailRecv2" id="emailRecvY2_no" value="N" class="switch">
											<label for="emailRecvY2_no">NO</label>
										</td>
										<td class="t_left">
											&lt;input type="radio" name="emailRecv2" id="emailRecvY2_yes" value="Y" checked="" class="switch"&gt;<br>
											&lt;label for="emailRecvY2_yes"&gt;YES&lt;/label&gt;<br>
											&lt;input type="radio" name="emailRecv2" id="emailRecvY2_no" value="N" class="switch"&gt;<br>
											&lt;label for="emailRecvY2_no"&gt;NO&lt;/label&gt;
										</td>
									</tr>
									<tr>
										<td class="t_left">
											<input type="checkbox" value="Y" class="switch" checked="checked">
											<input type="checkbox" value="Y" class="switch small" checked="checked">
										</td>
										<td class="t_left">
											&lt;input type="checkbox" value="Y" class="switch" checked="checked"&gt;<br>
											&lt;input type="checkbox" value="Y" class="switch small" checked="checked"&gt;
										</td>
									</tr>
									<tr>
										<td class="t_left">
											<input type="checkbox" value="Y" class="switch yesno" checked="checked">
											<input type="checkbox" value="Y" class="switch yesno small" checked="checked">
										</td>
										<td class="t_left">
											&lt;input type="checkbox" value="Y" class="switch yesno" checked="checked"&gt;<br>
											&lt;input type="checkbox" value="Y" class="switch yesno small" checked="checked"&gt;
										</td>
									</tr>
									<tr>
										<td class="t_left">
											<input id="checkTest1" type="checkbox" value="Y" class="switch onoff">
											<input type="checkbox" value="Y" class="switch onoff small">
											<br>
											<a href="#_" onclick="switchOnTest();return false">[Switch ON]</a>
											<a href="#_" onclick="switchOffTest();return false">[Switch OFF]</a>
											<script>
												function switchOnTest() {
													UiSwitcherOn("checkTest1");
												}

												function switchOffTest() {
													UiSwitcherOff("checkTest1");
												}
											</script>
										</td>
										<td class="t_left">
											&lt;input type="checkbox" value="Y" class="switch onoff"&gt;<br>
											&lt;input type="checkbox" value="Y" class="switch onoff small"&gt;
										</td>
									</tr>
								</tbody>
							</table>
							<script>

							</script>
						</div>

						<br><br><br>

						<h4 class="sub-title ">날짜, 시간 선택</h4>
						<div class="table-wrap">
							<table class="table-type2">
								<colgroup>
									<col style="width:40%">
									<col style="width:60%">
								</colgroup>
								<tbody>
									<tr>
										<td class="t_left">
											날짜/시간 입력<br>
											<input id="date1" type="text" name="date1" placeholder="시작일" class="datepicker" value="20260210">
											<input id="time1" type="text" name="time1" placeholder="시작시간" class="timepicker" value="1030">
										</td>
										<td class="t_left">
											&lt;input type="text" name="date1" class="datepicker" value="20260210"&gt;<br>
											&lt;input type="text" name="time1" class="timepicker" value="1030"&gt;
										</td>
									</tr>
									<tr>
										<td class="t_left">
											날짜 기간 입력<br>
											<input id="startDate" type="text" name="startDate" placeholder="시작일" class="datepicker" toDate="endDate">
											<span class="txt-sort">~</span>
											<input id="endDate" type="text" name="endDate" placeholder="종료일" class="datepicker" fromDate="startDate">
										</td>
										<td class="t_left">
											&lt;input id="startDate" type="text" name="startDate" class="datepicker" toDate="endDate"&gt;<br>
											&lt;span class="txt-sort"&gt;~&lt;/span&gt;<br>
											&lt;input id="endDate" type="text" name="endDate" class="datepicker" fromDate="startDate"&gt;<br>
										</td>
									</tr>
									<tr>
										<td class="t_left">
											날짜/시간 기간 입력<br>
											<input id="dateSt" type="text" name="dateSt" placeholder="시작일" class="datepicker" timeId="timeSt" toDate="dateEd">
											<input id="timeSt" type="text" name="timeSt" placeholder="시작시간" class="timepicker" dateId="dateSt">
											<span class="txt-sort">~</span>
											<input id="dateEd" type="text" name="dateEd" placeholder="종료일" class="datepicker" timeId="timeEd" fromDate="dateSt">
											<input id="timeEd" type="text" name="timeEd" placeholder="종료시간" class="timepicker" dateId="dateEd">
										</td>
										<td class="t_left">
											&lt;input id="dateSt" type="text" name="dateSt" class="datepicker" timeId="timeSt" toDate="dateEd"&gt;<br>
											&lt;input id="timeSt" type="text" name="timeSt" class="timepicker" dateId="dateSt"&gt;<br>
											&lt;span class="txt-sort"&gt;~&lt;/span&gt;<br>
											&lt;input id="dateEd" type="text" name="dateEd" class="datepicker" timeId="timeEd" fromDate="dateSt"&gt;<br>
											&lt;input id="timeEd" type="text" name="timeEd" class="timepicker" dateId="dateEd"&gt;
										</td>
									</tr>
									<tr>
										<td class="t_left" colspan="2">
											<b>날짜/시간 데이터 가져오기</b><br>
											<table>
												<colgroup>
													<col style="width:20%">
													<col style="width:15%">
													<col style="width:10%">
													<col style="width:55%">
												</colgroup>
												<tr>
													<td>날짜/시간 데이터 : </td>
													<td><div id="dataTimeData1" style="width:100%;height:30px;border:1px solid;"></div></td>
													<td><button type="button" class="btn gray1" onclick="getDateTime1()">가져오기</button></td>
													<td>
														let value = UiComm.getDateTimeVal("date1", "time1");
													</td>
												</tr>
												<tr>
													<td>날짜 데이터 : </td>
													<td><div id="dataTimeData2" style="width:100%;height:30px;border:1px solid;"></div></td>
													<td><button type="button" class="btn gray1" onclick="getDateTime2()">가져오기</button></td>
													<td>
														let value = UiComm.getDateTimeVal("date1", null);
													</td>
												</tr>
												<tr>
													<td>시간 데이터 : </td>
													<td><div id="dataTimeData3" style="width:100%;height:30px;border:1px solid;"></div></td>
													<td><button type="button" class="btn gray1" onclick="getDateTime3()">가져오기</button></td>
													<td>
														let value = UiComm.getDateTimeVal(null, "time1");
													</td>
												</tr>
											</table>

											<script>
												function getDateTime1() {
													let value = UiComm.getDateTimeVal("date1", "time1");
													$("#dataTimeData1").html(value);
												}

												function getDateTime2() {
													let value = UiComm.getDateTimeVal("date1", null);
													$("#dataTimeData2").html(value);
												}

												function getDateTime3() {
													let value = UiComm.getDateTimeVal("", "time1");
													$("#dataTimeData3").html(value);
												}

											</script>
										</td>
										<td class="t_left">

										</td>
									</tr>

								</tbody>
							</table>
							<script>

							</script>
						</div>

						<br><br><br>

                    </div>


                </div>
            </div>
            <!-- //content -->


            <!-- common footer -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
            <!-- //common footer -->

        </main>
        <!-- //dashboard-->

    </div>

</body>
</html>

