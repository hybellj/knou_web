<%@page import="knou.framework.util.SecureUtil"%>
<%@page import="java.security.KeyPair"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="javax.crypto.Cipher"%>
<%@page import="java.security.KeyFactory"%>
<%@page import="java.security.PublicKey"%>
<%@page import="java.security.spec.X509EncodedKeySpec"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.security.MessageDigest"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta charset="UTF-8"/>
	<title>테스트</title>
	<script type="text/javascript" src="/webdoc/js/jquery.min.js"></script>
</head>

<body>

<h1>API 테스트</h1>


<h4>콘텐츠 ZIP파일 업로드 테스트</h4>
<button onclick="zipUploadTest()">콘텐츠 ZIP파일 업로드 테스트</button>
<button onclick="zipDownTest()">콘텐츠 다운로드 테스트</button>
<br>
업로드 결과
<div id="resultBox" style="width:400px;height:100px;border:1px solid"></div>

<br>
<hr>
<h4>콘텐츠 미리보기 테스트</h4>
<button onclick="previewTest('lms')">콘텐츠 미리보기 테스트</button>
<button onclick="previewTest('lcdms')">콘텐츠 미리보기 테스트(LCDMS)</button>
<br>

<hr>
<h4>학습현황 테스트</h4>
<button onclick="studyStatusTest()">학습현황 테스트</button>


<hr>
<h4>강의체험 테스트</h4>
<button onclick="courseContents()">강의체험 테스트</button>

<script type="text/javascript">
	var uploadWin = null;
	// 콘텐츠 ZIP파일 업로드 테스트
	function zipUploadTest() {
		var param = {
			p_curri_code : "46PHA",
			p_week : "2",
			p_seq : "1",
			UserId : "220001"
		}

		$.ajax({
			type : "POST",
		    async: true,
		    dataType : "json",
		    data : param,
		    url : "/api/getSecureEncode.do",
		    timeout: 3000,
			success : function(data){
				if (data.result == "1") {
					var params = data.value;
					var url = "https://local.hycu.ac.kr/api/zipContentUploadForm.do?params="+params;
					uploadWin = window.open(url, "uploadWin", "scrollbars=yes,width=600,height=600,location=no,resizable=yes");
				}
				else if (data.result == "-1") {
					console.log("error.............");
				}
		    },
		    error: function(xhr, Status, error) {
		    	console.log("error.............");
		    }
		});
	}
	
	// ZIP 업로드 처리 결과
	window.addEventListener('message', function(evt) {
		if (evt.data.message != undefined && evt.data.message == "zipfileUpload") {
			var result = evt.data.result;
			
			console.log("out_num = " + result.out_num);
			console.log("page = " + result.page);
			console.log("path = " + result.path);
			console.log("etc = " + result.etc);
			
			document.getElementById("resultBox").innerHTML = "out_num = " + result.out_num 
				+ "<br>" + "page = " + result.page 
				+ "<br>" + "path = " + result.path
				+ "<br>" + "etc = " + result.etc;
			
			uploadWin.close();
		}
	});

	
	// 콘텐츠 다운로드 테스트
	function zipDownTest() {
		var param = {
			p_curri_code : "46PHA",
			p_week : "2",
			p_seq : "1",
			UserId : "220001"
		}

		$.ajax({
			type : "POST",
		    async: true,
		    dataType : "json",
		    data : param,
		    url : "/api/getSecureEncode.do",
		    timeout: 3000,
			success : function(data){
				if (data.result == "1") {
					var params = data.value;
					var url = "https://local.hycu.ac.kr/api/zipContentDownloadForm.do?params="+params;
					uploadWin = window.open(url, "uploadWin", "scrollbars=yes,width=600,height=600,location=no,resizable=yes");
				}
				else if (data.result == "-1") {
					console.log("error.............");
				}
		    },
		    error: function(xhr, Status, error) {
		    	console.log("error.............");
		    }
		});
	}
	
	
	// 콘텐츠 미리보기 테스트
	function previewTest(type) {
		var param = {
			year : "2023",
			semester : "20",
			courseCode : "CPE011",
			contCd : "46PEB",
			week : "13"
		};
		
		var url = "http://lms.hycu.ac.kr/api/previewCnts.do?params=";
		if (type == "lcdms") {
			url = "http://lms.hycu.ac.kr/api/previewLcdmsCnts.do?params=";
		}
		
		$.ajax({
			type : "POST",
		    async: true,
		    dataType : "json",
		    data : param,
		    url : "/api/getSecureEncode.do",
		    timeout: 3000,
			success : function(data){
				if (data.result == "1") {
					var params = data.value;
					url = url + params;
					
					var previewWin = window.open(url, "previewWin", "scrollbars=yes,width=1200,height=800,location=no,resizable=yes");
				}
				else if (data.result == "-1") {
					console.log("error.............");
				}
		    },
		    error: function(xhr, Status, error) {
		    	console.log("error.............");
		    }
		}); 
		
		
	}


	// 학습현황 테스트
	function studyStatusTest() {
		var param = {
			year : "2023",
			semester : "20",
			userId : "H202046078"
		};
		
		/*
		var param = {
			year : "2023",
			semester : "20",
			userId : "H202046078",
			courseCode : "",
			section : ""
		};
		*/
		
		$.ajax({
			type : "POST",
		    async: true,
		    dataType : "json",
		    data : param,
		    url : "/api/getSecureEncode.do",
		    timeout: 3000,
			success : function(data){
				if (data.result == "1") {
					var params = data.value;
					var url = "https://lms.hycu.ac.kr/api/learningStatusForm.do?params="+params;
					var studyStatusWin = window.open(url, "studyStatusWin", "scrollbars=yes,width=900,height=600,location=no,resizable=yes");
				}
				else if (data.result == "-1") {
					console.log("error.............");
				}
		    },
		    error: function(xhr, Status, error) {
		    	console.log("error.............");
		    }
		}); 
	}
	
	
	// 강의체험 테스트
	function courseContents() {
		
		//var url = "https://lms.hycu.ac.kr/api/viewContent.do?params=39CAC_01_04";
		//var sampleWin = window.open(url, "sampleWin", "scrollbars=yes,width=1010,height=645,location=no,resizable=yes");
		$("#test1").attr("src", "https://lms.hycu.ac.kr/api/viewContent.do?params=46psa_01_01");
	}

</script>

<iframe id="test1" style="width:800px;height:300px">

</iframe>


</body>
</html>
