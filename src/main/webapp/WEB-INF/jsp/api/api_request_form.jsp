<%@ page import="javax.crypto.Cipher"%>
<%@ page import="java.security.KeyFactory"%>
<%@ page import="java.security.PublicKey"%>
<%@ page import="java.security.spec.X509EncodedKeySpec"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.security.MessageDigest"%>
<%!

// 통합메시지 인증 토큰용 공개키
String MSG_PUBKEY = "30820122300d06092a864886f70d01010105000382010f003082010a02820101008645e3710c2b2594aabedc69266c19457b6ed8d91ab5241319cc75dcc44eaa941428f7bba0f0dfd11df0cdae8b2646bfdea48102791933d192ef45f115857d250ffc4728a7a8fd0f96b8948fbbf3b0fb679615574c8d761bce9a21ac0ae71424f853ec7948ed2993e63f80d94b1aea7b7f38f610e54ebcd68757e92db784eb67114e14ea86cda996b169f094968461e0e44e562994092250e26de30458945fb6d39f285e78e9fcac67fc5d35177df513aa8f8ce344a20cc79083d67c9558e16e5f86296a46608ee7d2f2d4146579348737567908dc351de531b9ca1d88334f1b6c1b8257485575fec48cfae5adee2dc4b7f7db6ae959e20d92aa08f3d1b669270203010001";

// 통합메시지 인증 토큰
public String getMsgToken(String userId) {
    String encValue = "";

    try {
        String date = (new SimpleDateFormat("yyyyMMddHHmmss")).format(new Date());
        String value =  userId + "," + date;

        byte[] pubBytes = new byte[MSG_PUBKEY.length() / 2];
        for(int i = 0; i < MSG_PUBKEY.length(); i += 2) {
            pubBytes[(int) Math.floor(i / 2)] = (byte)Integer.parseInt(MSG_PUBKEY.substring(i, i + 2), 16);
        }

        X509EncodedKeySpec keySpec = new X509EncodedKeySpec(pubBytes);
        PublicKey pubKey = (KeyFactory.getInstance("RSA")).generatePublic(keySpec);
        Cipher cipher = Cipher.getInstance("RSA");
        cipher.init(Cipher.ENCRYPT_MODE, pubKey);

        StringBuilder sb = new StringBuilder();
        for(byte b : cipher.doFinal(value.getBytes("utf-8"))) {
            sb.append(String.format("%02x", b&0xff));
        }

        encValue = sb.toString();

    } catch (Exception e) {
        e.printStackTrace();
    }
    return encValue;
}
%>

<%
    String sesId = request.getSession().getId();
    String ssoId = (String)request.getSession().getAttribute("SSO_ID");

    // 세미나
    // ssoId = "2023108740";    // 조교
    // ssoId = "5230021";       // 조교
    // ssoId = "2022200016";    // 수강생_세미나
    // ssoId = "20020051487";   // 수강생
    // ssoId = "2023108740";    // 수강생
    ssoId = "1190006";       // 교수자
    // ssoId = "2023108740";	// 대학교
    // ssoId = "2023200030";	// 대학원
    // ssoId = "1190006";       // 교수자
    // ssoId = "1080005";       // 교수자

    String token = getMsgToken(ssoId);
    // out.println("session.getAttribute(skey) :::" + session.getAttribute(skey));
    // out.println("sesId = "+sesId +"<br>");
    // out.println("ssoId = "+ssoId +"<br>");
    // out.println("token = "+token +"<br>");
%>
<!DOCTYPE html>
<html lang="ko">
    <head>
        <%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
        <jsp:include page="/WEB-INF/jsp/common/common.jsp" />
        <%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
        <link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
        <script type="text/javascript" src="/webdoc/js/iframe.js"></script>
    <script type="text/javascript">
        $(function(){
            $("#wholeNoticeListDiv").hide();
            $("#stuSubjNoticeListDiv").hide();
            $("#profSubjNoticeListDiv").hide();
            $("#stuSubjQnaListDiv").hide();
            $("#profSubjQnaListDiv").hide();
            $("#staffSubjQnaListDiv").hide();
            $("#realSeminarListDiv").hide();
            $("#departmentAttendListDiv").hide();
            $("#subjectAttendListDiv").hide();
            $("#stdProgListDiv").hide();
            $("#weekListDiv").hide();
            $("#learnListDiv").hide();
            // $("#learnProgressListDiv").hide();
            // $("#historyListDiv").hide();


            // lms Api 테스트 1. 강의공지 읽지않은 건수, 2. Q&A 답변 읽지않은 건수, 3. 1:1 상담 답변 읽지않은 건수, 4. 과제 미제출 건수, 5. 토론 미제출 건수, 6. 퀴즈 미제출 건수, 7. 설문 미제출 건수
            fnLmsStuAlarmApi = function(year, semester, section, courseCode, userId, alarmType) {
                var msg;
                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기
                    , section : section         // 분반
                    , courseCode : courseCode   // 과목코드
                    , userId : userId           // 사용자번호
                    , alarmType : alarmType     // 알림 구분
                    , token : "<%=token%>"      // 토큰 정보(필수)
                };

                //data = JSON.stringify(data);
                //data = btoa(data);

                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data
                    , url : "/api/countStuLessonAlarm.do"
                    , success : function(data){
                        console.log(data);
                        if(data.result > 0) {
                            if(alarmType == 'NOTICE') msg = '강의공지 읽지않은 건수 : ' + data.returnVO.countInfo;
                            else if(alarmType == 'QNA') msg = 'Q&A 답변 읽지않은 건수 : ' + data.returnVO.countInfo;
                            else if(alarmType == 'SECRET') msg = '1:1 상담 답변 읽지않은 건수 : ' + data.returnVO.countInfo;
                            else if(alarmType == 'QUIZ') msg = '퀴즈 미제출 건수 : ' + data.returnVO.countInfo;
                            else if(alarmType == 'RESCH') msg = '설문 미제출 건수 : ' + data.returnVO.countInfo;
                            else if(alarmType == 'ASMT') msg = '과제 미제출 건수 : ' + data.returnVO.countInfo;
                            else if(alarmType == 'FORUM') msg = '토론 미제출 건수 : ' + data.returnVO.countInfo;
                            alert(msg);
                        } else {
                            alert(data.message);
                        }
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };

            //교수.조교  1. 담당과목의 Q&A 미답변 건수, 2. 담당과목의 1:1 상담 미답변 건수
            fnLmsProfAlarmApi = function(year, semester, section, courseCode, userId, alarmType) {
                var msg;
                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기
                    , section : section         // 분반
                    , courseCode : courseCode   // 과목코드
                    , userId : userId           // 사용자번호
                    , alarmType : alarmType     // 알림 구분
                    , token : "<%=token%>"      // 토큰 정보(필수)
                };

                //data = JSON.stringify(data);
                //data = btoa(data);

                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data
                    , url : "/api/countProfLessonAlarm.do"
                    , success : function(data){
                        console.log(data);
                        if(data.result > 0) {
                            if(alarmType == 'QNA') msg = '교수 담당과목의 Q&A 미답변 건수 : ' + data.returnVO.countInfo;
                            else if(alarmType == 'SECRET') msg = '교수 담당과목의 1:1 상담 미답변 건수 : ' + data.returnVO.countInfo;
                            alert(msg);
                        } else {
                            alert(data.message);
                        }
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };

            //교수.조교  신청받은 결시원 개수
            fnLmsProfExamAbsentApi = function(year, semester, section, courseCode, userId) {
                var msg;
                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기
                    , section : section         // 분반
                    , courseCode : courseCode   // 과목코드
                    , userId : userId           // 사용자번호
                    , token : "<%=token%>"      // 토큰 정보(필수)
                };

                //data = JSON.stringify(data);
                //data = btoa(data);

                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data
                    , url : "/api/countProfExamAbsentRequest.do"
                    , success : function(data){
                        console.log(data);
                        if(data.result > 0) {
                            msg = '신청받은 결시원 개수 : ' + data.returnVO.countInfo;

                            alert(msg);
                        } else {
                            alert(data.message);
                        }
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };

            //교수 재확인 신청 받은 건수
            fnLmsProfScoreObjtApi = function(year, semester, section, courseCode, userId) {
                var msg;
                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기
                    , section : section         // 분반
                    , courseCode : courseCode   // 과목코드
                    , userId : userId           // 사용자번호
                    , token : "<%=token%>"      // 토큰 정보(필수)
                };

                //data = JSON.stringify(data);
                //data = btoa(data);

                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data
                    , url : "/api/countProfScoreObjtRequest.do"
                    , success : function(data){
                        console.log(data);
                        if(data.result > 0) {
                            msg = '재확인 신청 받은 건수 : ' + data.returnVO.countInfo;

                            alert(msg);
                        } else {
                            alert(data.message);
                        }
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };

            //장애인 지원 신청 건수 조회
            fnLmsDisabledPersonApi = function(year, semester, section, courseCode, userId) {
                var msg;
                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기
                    , section : section         // 분반
                    , courseCode : courseCode   // 과목코드
                    , userId : userId           // 사용자번호
                    , token : "<%=token%>"      // 토큰 정보(필수)
                };

                //data = JSON.stringify(data);
                //data = btoa(data);

                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data
                    , url : "/api/countDisabledPersonRequest.do"
                    , success : function(data){
                        console.log(data);
                        if(data.result > 0) {
                            msg = '장애인지원 신청 건수 : ' + data.returnVO.countInfo;
    
                            alert(msg);
                        } else {
                            alert(data.message);
                        }
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };

            //강의실 전체 공지사항 내역
            fnWholeNoticeList = function(userId, uniCd) {

                fnListShow(true, false, false, false, false, false, false, false, false, false, false);

                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    , data : { 
                          userId : userId           // 사용자번호
                          , uniCd : uniCd
                          , token : "<%=token%>"    // 토큰 정보(필수)
                             }
                    , url : "/api/wholeNoticeLessionList.do"
                    , success : function(data){
                        console.log(data);

                        var html = "";
                        var title = "";

                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }

                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td>"+ o.atclTitle +"</td>";
                                html += "   <td>"+ o.regDttm +"</td>";
                                html += "   <td>"+ o.regNm +"</td>";
                                html += "   <td><a href='"+ o.viewLink +"' target='_new'>"+ o.viewLink +"</a></td>";
                                html += "</tr>";
                            });
                        }

                        title = "강의실 전체 공지사항 내역";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.returnList.length);
                        $("#wholeNoticeList").empty().html(html);
                        $(".table").footable();
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };

            //학생 강의 공지사항
            fnStuSubjNoticeList = function(year, semester, section, courseCode, userId, alarmType) {

                fnListShow(false, true, false, false, false, false, false, false, false, false, false);

                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기
                    , section : section         // 분반
                    , courseCode : courseCode   // 과목코드
                    , userId : userId           // 사용자번호
                    , alarmType : alarmType     // 알림타입
                    , token : "<%=token%>"      // 토큰 정보(필수)
                };

                //data = JSON.stringify(data);
                //data = btoa(data);

                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data}
                    , data : data
                    , url : "/api/selectStuLessonNoticeList.do"
                    , success : function(data){
                        console.log(data);

                        var html = "";
                        var title = "";

                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }

                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td>"+ o.atclTitle +"</td>";
                                html += "   <td>"+ o.regDttm +"</td>";
                                html += "   <td>"+ o.regNm +"</td>";
                                html += "   <td><a href='"+ o.viewLink +"' target='_new'>"+ o.viewLink +"</a></td>";
                                html += "</tr>";
                            });
                        }
                        title = "학생 강의 공지사항 내역";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.returnList.length);
                        $("#stuSubjNoticeList").empty().html(html);
                        $(".table").footable();
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                }); 
            };

            //교수.조교 강의 공지사항
            fnProfSubjNoticeList = function(year, semester, section, courseCode, userId, alarmType) {

                fnListShow(false, false, true, false, false, false, false, false, false, false, false);

                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기
                    , section : section         // 분반
                    , courseCode : courseCode   // 과목코드
                    , userId : userId           // 사용자번호
                    , alarmType : alarmType     // 알림타입
                    , token : "<%=token%>"      // 토큰 정보(필수)
                };

                //data = JSON.stringify(data);
                //data = btoa(data);

                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data}
                    , data : data
                    , url : "/api/selectProfLessonNoticeList.do"
                    , success : function(data){
                        console.log(data);

                        var html = "";
                        var title = "";

                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }

                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td>"+ o.atclTitle +"</td>";
                                html += "   <td>"+ o.regDttm +"</td>";
                                html += "   <td>"+ o.regNm +"</td>";
                                html += "   <td><a href='"+ o.viewLink +"' target='_new'>"+ o.viewLink +"</a></td>";
                                html += "</tr>";
                            });
                        }
                        title = "교수.조교 강의 공지사항 내역";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.returnList.length);
                        $("#profSubjNoticeList").empty().html(html);
                        $(".table").footable();
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };

            //학생 강의 QNA
            fnStuSubjQnaList = function(year, semester, section, courseCode, userId, alarmType) {

                fnListShow(false, false, false, true, false, false, false, false, false, false, false);

                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기
                    , section : section         // 분반
                    , courseCode : courseCode   // 과목코드
                    , userId : userId           // 사용자번호
                    , alarmType : alarmType     // 알림타입
                    , token : "<%=token%>"      // 토큰 정보(필수)
                };
                
                //data = JSON.stringify(data);
                //data = btoa(data);

                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data
                    , url : "/api/selectStuLessonQnaList.do"
                    , success : function(data){
                        console.log(data);

                        var html = "";
                        var title = "";

                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }

                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td>"+ o.atclTitle +"</td>";
                                html += "   <td>"+ o.regDttm +"</td>";
                                html += "   <td>"+ o.answerYn +"</td>";
                                html += "   <td><a href='"+ o.viewLink +"' target='_new'>"+ o.viewLink+"</a></td>";
                                html += "</tr>";
                            });
                        } 

                        title = "학생 강의 Q&A 내역";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.returnList.length);
                        $("#stuSubjQnaList").empty().html(html);
                        $(".table").footable();
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };

            //교수.조교 과목 Q&A 내역
            fnProfSubjQnaList = function(year, semester, section, courseCode, userId, alarmType) {

                fnListShow(false, false, false, false, true, false, false, false, false, false, false);

                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기
                    , section : section         // 분반
                    , courseCode : courseCode   // 과목코드
                    , userId : userId           // 사용자번호
                    , alarmType : alarmType     // 알림타입
                    , token : "<%=token%>"      // 토큰 정보(필수)
                };

                //data = JSON.stringify(data);
                //data = btoa(data);

                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data
                    , url : "/api/selectProfLessonQnaList.do"
                    , success : function(data){
                        console.log(data);

                        var html = "";
                        var title = "";

                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }

                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td>"+ o.atclTitle +"</td>";
                                html += "   <td>"+ o.regDttm +"</td>";
                                html += "   <td>"+ o.answerYn +"</td>";
                                html += "   <td>"+ o.enquirer +"</td>";
                                html += "   <td><a href='"+ o.viewLink +"' target='_new'>"+ o.viewLink +"</a></td>";
                                html += "</tr>";
                            });
                        }

                        title = "교수.조교 강의 공지사항 내역";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.returnList.length);
                        $("#profSubjQnaList").empty().html(html);
                        $(".table").footable();
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };

            //직원 과목 Q&A 문의 내역
            fnStaffSubjQnaList = function(year, semester, section, courseCode, userId, alarmType) {

                fnListShow(false, false, false, false, false, true, false, false, false, false, false);

                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기
                    , section : section         // 분반
                    , courseCode : courseCode   // 과목코드
                    , userId : userId           // 사용자번호
                    , alarmType : alarmType     // 알림타입
                    , token : "<%=token%>"      // 토큰 정보(필수)
                };

                //data = JSON.stringify(data);
                //data = btoa(data);

                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data
                    , url : "/api/selectStaffLessonQnaList.do"
                    , success : function(data){
                        console.log(data);
                            
                        var html = "";
                        var title = "";
                        
                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }

                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td>"+ o.atclTitle +"</td>";
                                html += "   <td>"+ o.regDttm +"</td>";
                                html += "   <td>"+ o.answerYn +"</td>";
                                html += "   <td>"+ o.enquirer +"</td>";
                                html += "   <td><a href='"+ o.viewLink +"' target='_new'>"+ o.viewLink +"</a></td>";
                                html += "</tr>";
                            });
                        }

                        title = "교수.조교 강의 공지사항 내역";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.returnList.length);
                        $("#staffSubjQnaList").empty().html(html);
                        $(".table").footable();

                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                }); 
            };

            // 교수_실시간 세미나 내역
            fnProfRealSeminarList = function(year, semester, section, courseCode, userId) {

                fnListShow(false, false, false, false, false, false, true, false, false, false, false);

                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기
                    , section : section         // 분반
                    , courseCode : courseCode   // 과목코드
                    , userId : userId           // 사용자번호
                    , token : "<%=token%>"      // 토큰 정보(필수)
                };

                //data = JSON.stringify(data);
                //data = btoa(data);

                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data
                    , url : "/api/selectRealSeminarList.do"
                    , success : function(data){
                        console.log(data);

                        var html = "";
                        var title = "";

                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }

                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td>"+ o.seminarNm +"</td>";
                                html += "   <td>"+ o.seminarTime +"</td>";
                                html += "   <td>"+ o.seminarStartDttm +"</td>";
                                html += "   <td>"+ o.seminarEndDttm +"</td>";
                                html += "   <td><a href='"+ o.viewLink +"' target='_new'>"+ o.viewLink +"</a></td>";
                                html += "</tr>";
                            });
                        }

                        title = "실시간 세미나 내역";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.returnList.length);
                        $("#realSeminarList").empty().html(html);
                        $(".table").footable();

                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                }); 
            };
            
            // 학생_실시간 세미나 내역
            fnRealSeminarList = function(year, semester, section, courseCode, userId) {

                fnListShow(false, false, false, false, false, false, true, false, false, false, false);

                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기
                    , section : section         // 분반
                    , courseCode : courseCode   // 과목코드
                    , userId : userId           // 사용자번호
                    , token : "<%=token%>"      // 토큰 정보(필수)
                };

                //data = JSON.stringify(data);
                //data = btoa(data);

                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data
                    , url : "/api/selectRealSeminarList.do"
                    , success : function(data){
                        console.log(data);

                        var html = "";
                        var title = "";

                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }

                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td>"+ o.seminarNm +"</td>";
                                html += "   <td>"+ o.seminarTime +"</td>";
                                html += "   <td>"+ o.seminarStartDttm +"</td>";
                                html += "   <td>"+ o.seminarEndDttm +"</td>";
                                html += "   <td><a href='"+ o.viewLink +"' target='_new'>"+ o.viewLink +"</a></td>";
                                html += "</tr>";
                            });
                        }

                        title = "실시간 세미나 내역";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.returnList.length);
                        $("#realSeminarList").empty().html(html);
                        $(".table").footable();

                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                }); 
            };

            //학생 학습현황 내역
            fnStdProgressRatio = function(year, semester, userId, progressType, uniCd) {

                var data = {
                    year : year                     // 년도
                    , semester : semester           // 학기
                    //, section : section           // 분반
                    //, courseCode : courseCode     // 과목코드
                    , userId : userId               // 사용자번호
                    , progressType : progressType   // 진도율 구분
                    , uniCd : uniCd                 // 학교 구분
                    , token : "<%=token%>"          // 토큰 정보(필수)
                };

                //data = JSON.stringify(data);
                //data = btoa(data);

                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data
                    , url : "/api/selectStdProgressRatio.do"
                    , success : function(data){
                        console.log(data);

                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }
                        if(progressType == 'A') {
                            alert('나의 진도율 : ' + data.returnVO.stdProgRatio); 
                        } else if(progressType == 'B') {
                            if(uniCd == 'C') {
                                alert('대학교 평균 진도율 : ' + data.returnVO.colleageProgRatio); 
                            } else if(uniCd == 'G') {
                                alert('대학원 평균 진도율 : ' + data.returnVO.gradProgRatio); 
                            } else {
                                alert('학부 평균 진도율 : ' + data.returnVO.colleageProgRatio + ', 대학원 평균 진도율 : ' + data.returnVO.gradProgRatio); 
                            }
                        } else if(progressType == 'C') {

                            fnListShow(false, false, false, false, false, false, false, false, false, true, false);

                            var html = "";
                            var title = "";

                            if(data.returnList.length > 0){
                                $.each(data.returnList, function(i, o){
                                    html += "<tr>";
                                    html += "   <td>"+ o.crsCreNm +"</td>";             // 과정개설명
                                    html += "   <td>"+ o.cmplWeekCnt +"</td>";          // 학습주차주
                                    html += "   <td>"+ o.totWeekCnt +"</td>";           // 전체주차주
                                    html += "   <td>"+ o.progRatio +"</td>";            // 진도율
                                    html += "</tr>";
                                });
                            }
                            title = "수강과목 내역";
                            $("#titleTop").text(title);
                            $("#totalCnt").text("총건수 : " + data.returnList.length);
                            $("#stdProgList").empty().html(html);
                            $(".table").footable(); 
                        }
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                }); 
            }; 

            //교수/조교 학습현황 내역
            fnProfProgressRatio = function(year, semester, userId, progressType, uniCd) {

                var data = {
                    year : year                         // 년도
                    , semester : semester               // 학기
                    , userId : userId                   // 사용자번호
                    , progressType : progressType       // 진도율 구분
                    , uniCd : uniCd                     // 학교 구분
                    , token : "<%=token%>"              // 토큰정보(필수)
                };

                //data = JSON.stringify(data);
                //data = btoa(data);

                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data
                    , url : "/api/selectProfProgressRatio.do"
                    , success : function(data){
                        console.log(data);
                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }
                        if(progressType == 'A') {
                            alert('교수,조교 평균 진도율 : ' + data.returnVO.profProgRatio); 
                        } else if(progressType == 'B') {
                            if(uniCd == 'C') {
                                alert('학부 전체 평균 진도율 : ' + data.returnVO.colleageProgRatio); 
                            } else if(uniCd == 'G') {
                                alert('대학원 전체 평균 진도율 : ' + data.returnVO.gradProgRatio); 
                            } else {
                                alert('학부 평균 진도율 : ' + data.returnVO.colleageProgRatio + ', 대학원 평균 진도율 : ' + data.returnVO.gradProgRatio); 
                            }
                        }
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };

            //진도율 입력
            fnInsertProgRatio = function() {
                var data = {
                };

                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data
                    , url : "/api/insertStdProgressRatio.do"
                    , success : function(data){
                        console.log(data);
                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }
                        alert('저장되었습니다'); 
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                }); 
            };

            //출석율 입력
            fnInsertAttendRatio = function() {
                var data = {
                };

                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data
                    , url : "/api/insertStdAttendRatio.do"
                    , success : function(data){
                        console.log(data);
                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }
                        alert('저장되었습니다');
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };

            //교수, 학과장 학과별 주차별 출석 현황
            fnDepartPerWeekAttend = function(year, semester, userId, progressType) {

                fnListShow(false, false, false, false, false, false, false, true, false, false, false);

                var data = {
                    year : year                     // 년도
                    , semester : semester           // 학기
                    , userId : userId               // 사용자번호
                    , token : "<%=token%>"          // 토큰 정보(필수)
                };

                // data = JSON.stringify(data);
                // data = btoa(data);

                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data 
                    , url : "/api/selectDepartPerWeekAttend.do"
                    , success : function(data){
                        console.log(data);

                        var html = "";
                        var title = "";

                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }

                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td>"+ o.deptNm  +"</td>";
                                html += "   <td>"+ o.lessonScheduleOrder  +"</td>";
                                html += "   <td>"+ o.lastYearAvgAttendRate +"</td>";
                                html += "   <td>"+ o.thisYearAvgAttendRate +"</td>";
                                html += "</tr>";
                            });
                        }

                        title = "학과별 주차별 출석현황 내역";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.returnList.length);
                        $("#departmentAttendList").empty().html(html);
                        $(".table").footable();
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };

            //전체 주차별 출석현황
            fnTotalPerWeekAttend = function(year, semester, section, courseCode, userId, progressType) {

                fnListShow(false, false, false, false, false, false, false, true, false, false, false);

                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기
                    //, section : section       // 분반
                    //, courseCode : courseCode // 과목코드
                    , userId : userId           // 사용자번호
                    , token : "<%=token%>"      // 토큰 정보(필수)
                };

                //data = JSON.stringify(data);
                //data = btoa(data);

                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data
                    , url : "/api/selectTotalPerWeekAttend.do"
                    , success : function(data){
                        console.log(data);

                        var html = "";
                        var title = "";

                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }

                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td></td>";
                                html += "   <td>"+ o.lessonScheduleOrder  +" 주차</td>";
                                html += "   <td>"+ o.colleageAvgAttendRate +"</td>";
                                html += "   <td>"+ o.gradAvgAttendRate +"</td>";
                                html += "</tr>";
                            });
                        }

                        title = "전체 주차별 출석현황 내역";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.returnList.length);
                        $("#departmentAttendList").empty().html(html);
                        $(".table").footable();
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };

            //전체 주차별 출석현황
            fnTotalPerWeekAttend = function(year, semester, section, courseCode, userId, progressType) {

                fnListShow(false, false, false, false, false, false, false, true, false, false, false);

                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기
                    //, section : section       // 분반
                    //, courseCode : courseCode // 과목코드
                    , userId : userId           // 사용자번호
                    , token : "<%=token%>"      // 토큰 정보(필수)
                };

                //data = JSON.stringify(data);
                //data = btoa(data);

                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data
                    , url : "/api/selectTotalPerWeekAttend.do"
                    , success : function(data){
                        console.log(data);

                        var html = "";
                        var title = "";

                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }

                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td></td>";
                                html += "   <td>"+ o.lessonScheduleOrder  +" 주차</td>";
                                html += "   <td>"+ o.lastYearAvgAttendRate +"</td>";
                                html += "   <td>"+ o.thisYearAvgAttendRate +"</td>";
                                html += "</tr>";
                            });
                        }

                        title = "전체 주차별 출석현황 내역";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.returnList.length);
                        $("#departmentAttendList").empty().html(html);
                        $(".table").footable();
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };
            
          	// 주차별 학습현황
            fnPerWeekAttend = function(year, semester, userId) {

                fnListShow(false, false, false, false, false, false, false, true, false, false, false);

                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기
                    , userId : userId           // 사용자번호
                    , token : "<%=token%>"      // 토큰 정보(필수)
                };

                //data = JSON.stringify(data);
                //data = btoa(data);

                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data
                    , url : "/api/selectPerWeekAttend.do"
                    , success : function(data){
                        console.log(data);

                        var html = "";
                        var title = "";

                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }

                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td></td>";
                                html += "   <td>"+ o.lessonScheduleOrder  +" 주차</td>";
                                html += "   <td>"+ o.colleageAvgAttendRate +"</td>";
                                html += "   <td>"+ o.gradAvgAttendRate +"</td>";
                                html += "</tr>";
                            });
                        }

                        title = "주차별 대학교, 대학원 학습현황 내역";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.returnList.length);
                        $("#departmentAttendList").empty().html(html);
                        $(".table").footable();
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };
            
            //교수, 학과장 과목별  주차별 출석현황
            fnSubjectPerWeekAttend = function(year, semester, section, courseCode, userId, progressType) {

                fnListShow(false, false, false, false, false, false, false, false, true, false, false);

                var data = {
                    year : year                     // 년도
                    , semester : semester           // 학기
                    //, section : section           // 분반
                    //, courseCode : courseCode     // 과목코드
                    , userId : userId               // 사용자번호
                    , progressType : progressType   // 출석율 구분 A : 교수, B: 학과장
                    , token : "<%=token%>"          // 토큰 정보(필수)
                };

                //data = JSON.stringify(data);
                //data = btoa(data);

                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data
                    , url : "/api/selectSubjectPerWeekAttend.do"
                    , success : function(data){
                        console.log(data);

                        var html = "";
                        var title = "";

                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }

                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td>"+ o.crsCreNm +"</td>";
                                html += "   <td>"+ o.subjectAttendRate +"</td>";
                                html += "</tr>";
                            });
                        }

                        title = "과목별 출석현황 내역";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.returnList.length);
                        $("#subjectAttendList").empty().html(html);
                        $(".table").footable();

                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                }); 
            };

            //교수 과목별 진도율 조회
            fnProfSubjectProgressRatio = function(year, semester, userId) {

                var data = {
                    year : year             // 년도
                    , semester : semester   // 학기
                    , userId : userId       // 사용자번호
                    , token : "<%=token%>"  // 토큰 정보(필수)
                };

                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data
                    , url : "/api/selectProfSubjectProgressRatio.do"
                    , success : function(data){
                        console.log(data);
                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }

                        fnListShow(false, false, false, false, false, false, false, false, false, true, false);

                        var html = "";
                        var title = "";

                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td>"+ o.crsCreNm +"</td>";     // 과정개설명
                                html += "   <td></td>";                     // 학습주차주
                                html += "   <td></td>";                     // 전체주차주
                                html += "   <td>"+ o.crsProgRatio +"</td>"; // 진도율
                                html += "</tr>";
                            });
                        }

                        title = "교수,조교 과목별 진도율 내역";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.returnList.length);
                        $("#stdProgList").empty().html(html);
                        $(".table").footable(); 
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                }); 
            };

            //학생 과목 목록 조회
            fnStuCrsCreList = function(year, semester, userId) {

                var data = {
                    year : year             // 년도
                    , semester : semester   // 학기
                    , userId : userId       // 사용자번호
                    , token : "<%=token%>"  // 토큰 정보(필수)
                };

                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data
                    , url : "/api/selectStuCrsCreNmList.do"
                    , success : function(data){
                        console.log(data);
                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }

                        fnListShow(false, false, false, false, false, false, false, false, false, true, false);

                        var html = "";
                        var title = "";

                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td>"+ o.crsCreNm +"</td>";         // 과정개설명
                                html += "   <td>"+ o.cmplWeekCnt +"</td>";      // 학습주차주
                                html += "   <td>"+ o.totWeekCnt +"</td>";       // 전체주차주
                                html += "   <td>"+ o.progRatio +"</td>";        // 진도율
                                html += "   <td>"+ o.corsUrl +"</td>";          // 강의실홈URL
                                html += "</tr>";
                            });
                        }

                        title = "학생 과목 목록";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.returnList.length);
                        $("#stdProgList").empty().html(html);
                        $(".table").footable(); 
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                }); 
            };

            /* 상상플러스 */

            // 주차별 수강현황 내역
            fnWeekList = function(year, semester, todayDttm, ltOmitWeek, ltWeek, pageIndex, listScale) {

                fnListShow(false, false, false, false, false, false, false, false, false, false, true);

                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기(1학기:10, 2학기:20, 여름계절학기:11,겨율계절학기:21)
                    , todayDttm : todayDttm     // 현재날짜(년월일)
                    , ltOmitWeek : ltOmitWeek   // 제외주차
                    , ltWeek : ltWeek           // 주차
                    , pageIndex : pageIndex     // 현재 페이지 번호
                    , listScale : listScale     // 한 페이지당 게시되는 게시물 건 수
                };
                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data 
                    , url : "/api/selectWeekList.do"
                    , success : function(data){
                        console.log(data);

                        var html = "";
                        var title = "";

                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }

                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td>"+ o.year  +"</td>";                /* 년도 */
                                html += "   <td>"+ o.semester  +"</td>";            /* 학기 */
                                html += "   <td>"+ o.userId  +"</td>";              /* 사용자 번호 */
                                html += "   <td>"+ o.ltWeek  +"</td>";              /* 주차 */
                                html += "   <td>"+ o.enrHp  +"</td>";               /* 신청학점 */
                                html += "   <td>"+ o.connDay  +"</td>";             /* 접속일수합계 */
                                html += "   <td>"+ o.connDaySum  +"</td>";          /* 접속일수누적합계 */
                                html += "   <td>"+ o.connTm  +"</td>";              /* 접속시간합계 */
                                html += "   <td>"+ o.connTmSum  +"</td>";           /* 접속시간누적합계 */
                                html += "   <td>"+ o.dayTmAvg  +"</td>";            /* 일접속시간 평균 */
                                html += "   <td>"+ o.dayTmDev  +"</td>";            /* 일접속시간 표준편차 */
                                html += "   <td>"+ o.dayTermAvg  +"</td>";          /* 접속일간격 평균 */
                                html += "   <td>"+ o.dayTermDev  +"</td>";          /* 접속일간격 표준편차 */
                                html += "   <td>"+ o.connDayRatio  +"</td>";        /* 주간접속비율 */
                                html += "   <td>"+ o.connWeekdayRatio  +"</td>";    /* 주중접속비율 */
                               // html += "   <td>"+ o.regDttm  +"</td>";             /* 등록일 */
                                html += "   <td>"+ o.modDttm  +"</td>";             /* 수정일 */
                                html += "</tr>";
                            });
                        }

                        title = "주차별 수강현황 내역";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.pageInfo.totalRecordCount);
                        $("#weekList").empty().html(html);
                        $(".table").footable();
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };

            // 과제
            fnAsmntTotalList = function(year, semester, todayDttm, pageIndex, listScale) {

                fnListShow(false, false, false, false, false, false, false, false, false, false, false, true);

                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기(1학기:10, 2학기:20, 여름계절학기:11,겨율계절학기:21)
                    , todayDttm : todayDttm     // 현재날짜(년월일)
                    , pageIndex : pageIndex     // 현재 페이지 번호
                    , listScale : listScale     // 한 페이지당 게시되는 게시물 건 수
                };
    
                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data 
                    , url : "/api/selectTotalAsmntList.do"
                    , success : function(data){
                        console.log(data);

                        var html = "";
                        var title = "";

                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }

                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td>"+ o.creYear  +"</td>";             /* 년도 */
                                html += "   <td>"+ o.creTerm  +"</td>";             /* 학기 */
                                html += "   <td>"+ o.declsNo  +"</td>";             /* 분반 */
                                html += "   <td>"+ o.crsCd  +"</td>";               /* 과목코드 */
                                html += "   <td>"+ o.asmntCd  +"</td>";             /* 학습활동코드 */
                                html += "   <td>"+ o.asmntTitle  +"</td>";          /* 제목 */
                                html += "   <td>"+ o.sendEndDttm  +"</td>";         /* 과제마감일 */
                                html += "   <td>"+ o.delYn  +"</td>";               /* 삭제여부 */
                                html += "</tr>";
                            });
                        }

                        title = "과제 학습활동 내역";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.pageInfo.totalRecordCount);
                        $("#learnList").empty().html(html);
                        $(".table").footable();
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };

            // 토론
            fnForumTotalList = function(year, semester, todayDttm, pageIndex, listScale) {

                fnListShow(false, false, false, false, false, false, false, false, false, false, false, true);

                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기(1학기:10, 2학기:20, 여름계절학기:11,겨율계절학기:21)
                    , todayDttm : todayDttm     // 현재날짜(년월일)
                    , pageIndex : pageIndex     // 현재 페이지 번호
                    , listScale : listScale     // 한 페이지당 게시되는 게시물 건 수
                };
    
                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data 
                    , url : "/api/selectTotalForumList.do"
                    , success : function(data){
                        console.log(data);
                        
                        var html = "";
                        var title = "";

                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }
                        
                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td>"+ o.creYear  +"</td>";             /* 년도 */
                                html += "   <td>"+ o.creTerm  +"</td>";             /* 학기 */
                                html += "   <td>"+ o.declsNo  +"</td>";             /* 분반 */
                                html += "   <td>"+ o.crsCd  +"</td>";               /* 과목코드 */
                                html += "   <td>"+ o.forumCd  +"</td>";             /* 학습활동코드 */
                                html += "   <td>"+ o.forumTitle  +"</td>";          /* 제목 */
                                html += "   <td>"+ o.forumEndDttm  +"</td>";        /* 토론마감일 */
                                html += "   <td>"+ o.delYn  +"</td>";               /* 삭제여부 */
                                html += "</tr>";
                            });
                        }

                        title = "토론 학습활동 내역";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.pageInfo.totalRecordCount);
                        $("#learnList").empty().html(html);
                        $(".table").footable();
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };

            // 퀴즈
            fnQuizTotalList = function(year, semester, todayDttm, pageIndex, listScale) {

               fnListShow(false, false, false, false, false, false, false, false, false, false, false, true);

                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기(1학기:10, 2학기:20, 여름계절학기:11,겨율계절학기:21)
                    , todayDttm : todayDttm     // 현재날짜(년월일)
                    , pageIndex : pageIndex     // 현재 페이지 번호
                    , listScale : listScale     // 한 페이지당 게시되는 게시물 건 수
                };
    
                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data 
                    , url : "/api/selectTotalQuizList.do"
                    , success : function(data){
                        console.log(data);
                        
                        
                        var html = "";
                        var title = "";

                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }
                        
                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td>"+ o.creYear  +"</td>";             /* 년도 */
                                html += "   <td>"+ o.creTerm  +"</td>";             /* 학기 */
                                html += "   <td>"+ o.declsNo  +"</td>";             /* 분반 */
                                html += "   <td>"+ o.crsCd  +"</td>";               /* 과목코드 */
                                html += "   <td>"+ o.examCd  +"</td>";              /* 학습활동코드 */
                                html += "   <td>"+ o.examTitle  +"</td>";           /* 제목 */
                                html += "   <td>"+ o.examEndDttm  +"</td>";         /* 퀴즈마감일 */
                                html += "   <td>"+ o.delYn  +"</td>";               /* 삭제여부 */
                                html += "</tr>";
                            });
                        }

                        title = "퀴즈 학습활동 내역";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.pageInfo.totalRecordCount);
                        $("#learnList").empty().html(html);
                        $(".table").footable();
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };

            // 설문
            fnReschTotalList = function(year, semester, todayDttm, pageIndex, listScale) {

               fnListShow(false, false, false, false, false, false, false, false, false, false, false, true);

                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기(1학기:10, 2학기:20, 여름계절학기:11,겨율계절학기:21)
                    , todayDttm : todayDttm     // 현재날짜(년월일)
                    , pageIndex : pageIndex     // 현재 페이지 번호
                    , listScale : listScale     // 한 페이지당 게시되는 게시물 건 수
                };
    
                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data 
                    , url : "/api/selectTotalReschList.do"
                    , success : function(data){
                        console.log(data);

                        var html = "";
                        var title = "";

                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }
                        
                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td>"+ o.creYear  +"</td>";             /* 년도 */
                                html += "   <td>"+ o.creTerm  +"</td>";             /* 학기 */
                                html += "   <td>"+ o.declsNo  +"</td>";             /* 분반 */
                                html += "   <td>"+ o.crsCd  +"</td>";               /* 과목코드 */
                                html += "   <td>"+ o.reschCd  +"</td>";             /* 학습활동코드 */
                                html += "   <td>"+ o.reschTitle  +"</td>";          /* 제목 */
                                html += "   <td>"+ o.reschEndDttm  +"</td>";        /* 설문마감일 */
                                html += "   <td>"+ o.delYn  +"</td>";               /* 삭제여부 */
                                html += "</tr>";
                            });
                        }

                        title = "설문 학습활동 내역";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.pageInfo.totalRecordCount);
                        $("#learnList").empty().html(html);
                        $(".table").footable();
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };

            // 세미나
            fnSeminarTotalList = function(year, semester, todayDttm, pageIndex, listScale) {

               fnListShow(false, false, false, false, false, false, false, false, false, false, false, true);

                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기(1학기:10, 2학기:20, 여름계절학기:11,겨율계절학기:21)
                    , todayDttm : todayDttm     // 현재날짜(년월일)
                    , pageIndex : pageIndex     // 현재 페이지 번호
                    , listScale : listScale     // 한 페이지당 게시되는 게시물 건 수
                };
    
                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data 
                    , url : "/api/selectTotalSeminarList.do"
                    , success : function(data){
                        console.log(data);

                        var html = "";
                        var title = "";

                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }

                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td>"+ o.creYear  +"</td>";             /* 년도 */
                                html += "   <td>"+ o.creTerm  +"</td>";             /* 학기 */
                                html += "   <td>"+ o.declsNo  +"</td>";             /* 분반 */
                                html += "   <td>"+ o.crsCd  +"</td>";               /* 과목코드 */
                                html += "   <td>"+ o.seminarId  +"</td>";           /* 학습활동코드 */
                                html += "   <td>"+ o.seminarNm  +"</td>";           /* 제목 */
                                html += "   <td>"+ o.seminarEndDttm  +"</td>";      /* 과제마감일 */
                                html += "   <td>"+ o.delYn  +"</td>";               /* 삭제여부 */
                                html += "</tr>";
                            });
                        }

                        title = "세미나 학습활동 내역";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.pageInfo.totalRecordCount);
                        $("#learnList").empty().html(html);
                        $(".table").footable();
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };
            
            // 학습진도목록
            fnSelectLearnList = function(year, semester, todayDttm, pageIndex, listScale) {

                fnListShow(false, false, false, false, false, false, false, false, false, false, false, false, true);

                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기(1학기:10, 2학기:20, 여름계절학기:11,겨율계절학기:21)
                    , todayDttm : todayDttm     // 현재날짜(년월일)
                    , pageIndex : pageIndex     // 현재 페이지 번호
                    , listScale : listScale     // 한 페이지당 게시되는 게시물 건 수
                };
                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data 
                    , url : "/api/selectLearnProgressList.do"
                    , success : function(data){
                        console.log(data);

                        var html = "";
                        var title = "";

                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }

                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td>"+ o.userId  +"</td>";                  /* 학번 */
                                html += "   <td>"+ o.crsCd  +"</td>";                   /* 과목정보(코드) */
                                html += "   <td>"+ o.declsNo  +"</td>";                 /* 분반 */
                                html += "   <td>"+ o.progRatio  +"</td>";               /* 학습진도율 */
                                html += "</tr>";
                            });
                        }

                        title = "학습진도목록";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.pageInfo.totalRecordCount);
                        $("#learnProgressList").empty().html(html);
                        $(".table").footable();
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };

            // 과제
            fnAsmntAcademyList = function(year, semester, todayDttm, pageIndex, listScale) {

                fnListShow(false, false, false, false, false, false, false, false, false, false, false, false, true);

                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기(1학기:10, 2학기:20, 여름계절학기:11,겨율계절학기:21)
                    , todayDttm : todayDttm     // 현재날짜(년월일)
                    , pageIndex : pageIndex     // 현재 페이지 번호
                    , listScale : listScale     // 한 페이지당 게시되는 게시물 건 수
                };
    
                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data 
                    , url : "/api/selectAcademyAsmntList.do"
                    , success : function(data){
                        console.log(data);

                        var html = "";
                        var title = "";

                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }

                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td>"+ o.userId  +"</td>";              /* 학번 */
                                html += "   <td>"+ o.asmntCd  +"</td>";             /* 학습활동ID */
                                html += "   <td>"+ o.regDttm  +"</td>";             /* 등록일 */
                                html += "</tr>";
                            });
                        }

                        title = "과제 학습활동 이력";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.pageInfo.totalRecordCount);
                        $("#historyList").empty().html(html);
                        $(".table").footable();
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };

            // 토론
            fnForumAcademyList = function(year, semester, todayDttm, pageIndex, listScale) {

                fnListShow(false, false, false, false, false, false, false, false, false, false, false, false, true);

                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기(1학기:10, 2학기:20, 여름계절학기:11,겨율계절학기:21)
                    , todayDttm : todayDttm     // 현재날짜(년월일)
                    , pageIndex : pageIndex     // 현재 페이지 번호
                    , listScale : listScale     // 한 페이지당 게시되는 게시물 건 수
                };
    
                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data 
                    , url : "/api/selectAcademyForumList.do"
                    , success : function(data){
                        console.log(data);
                        
                        var html = "";
                        var title = "";

                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }
                        
                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td>"+ o.userId  +"</td>";              /* 학번 */
                                html += "   <td>"+ o.forumCd  +"</td>";             /* 학습활동ID */
                                html += "   <td>"+ o.regDttm  +"</td>";             /* 등록일 */
                                html += "</tr>";
                            });
                        }

                        title = "토론 학습활동 이력";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.pageInfo.totalRecordCount);
                        $("#historyList").empty().html(html);
                        $(".table").footable();
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };

            // 퀴즈
            fnQuizAcademyList = function(year, semester, todayDttm, pageIndex, listScale) {

               fnListShow(false, false, false, false, false, false, false, false, false, false, false, false, true);

                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기(1학기:10, 2학기:20, 여름계절학기:11,겨율계절학기:21)
                    , todayDttm : todayDttm     // 현재날짜(년월일)
                    , pageIndex : pageIndex     // 현재 페이지 번호
                    , listScale : listScale     // 한 페이지당 게시되는 게시물 건 수
                };
    
                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data 
                    , url : "/api/selectAcademyQuizList.do"
                    , success : function(data){
                        console.log(data);
                        
                        
                        var html = "";
                        var title = "";

                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }
                        
                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td>"+ o.userId  +"</td>";              /* 학번 */
                                html += "   <td>"+ o.examCd  +"</td>";              /* 학습활동ID */
                                html += "   <td>"+ o.regDttm  +"</td>";             /* 등록일 */
                                html += "</tr>";
                            });
                        }

                        title = "퀴즈 학습활동 이력";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.pageInfo.totalRecordCount);
                        $("#historyList").empty().html(html);
                        $(".table").footable();
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };

            // 설문
            fnReschAcademyList = function(year, semester, todayDttm, pageIndex, listScale) {

               fnListShow(false, false, false, false, false, false, false, false, false, false, false, false, true);

                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기(1학기:10, 2학기:20, 여름계절학기:11,겨율계절학기:21)
                    , todayDttm : todayDttm     // 현재날짜(년월일)
                    , pageIndex : pageIndex     // 현재 페이지 번호
                    , listScale : listScale     // 한 페이지당 게시되는 게시물 건 수
                };
    
                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data 
                    , url : "/api/selectAcademyReschList.do"
                    , success : function(data){
                        console.log(data);
                        
                        
                        var html = "";
                        var title = "";

                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }
                        
                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td>"+ o.userId  +"</td>";              /* 학번 */
                                html += "   <td>"+ o.reschCd  +"</td>";             /* 학습활동ID */
                                html += "   <td>"+ o.regDttm  +"</td>";             /* 등록일 */
                                html += "</tr>";
                            });
                        }

                        title = "설문 학습활동 이력";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.pageInfo.totalRecordCount);
                        $("#historyList").empty().html(html);
                        $(".table").footable();
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };

            // 세미나
            fnSeminarAcademyList = function(year, semester, todayDttm, pageIndex, listScale) {

               fnListShow(false, false, false, false, false, false, false, false, false, false, false, false, true);

                var data = {
                    year : year                 // 년도
                    , semester : semester       // 학기(1학기:10, 2학기:20, 여름계절학기:11,겨율계절학기:21)
                    , todayDttm : todayDttm     // 현재날짜(년월일)
                    , pageIndex : pageIndex     // 현재 페이지 번호
                    , listScale : listScale     // 한 페이지당 게시되는 게시물 건 수
                };
    
                $.ajax({
                    type : "POST"
                    , async: false
                    , dataType : "json"
                    //, data : { params : data }
                    , data : data 
                    , url : "/api/selectAcademySeminarList.do"
                    , success : function(data){
                        console.log(data);

                        var html = "";
                        var title = "";

                        if(data.result < 0) {
                            alert(data.message);
                            return;
                        }

                        if(data.returnList.length > 0){
                            $.each(data.returnList, function(i, o){
                                html += "<tr>";
                                html += "   <td>"+ o.userId  +"</td>";              /* 학번 */
                                html += "   <td>"+ o.seminarId  +"</td>";           /* 학습활동ID */
                                html += "   <td>"+ o.regDttm  +"</td>";             /* 등록일 */
                                html += "</tr>";
                            });
                        }

                        title = "세미나 학습활동 이력";
                        $("#titleTop").text(title);
                        $("#totalCnt").text("총건수 : " + data.pageInfo.totalRecordCount);
                        $("#historyList").empty().html(html);
                        $(".table").footable();
                    }
                    , beforeSend: function() {
                    }
                    , complete:function(status){
                        console.log(status);
                    }
                    ,error: function(xhr,  Status, error) {
                        console.log(xhr);
                    }
                });
            };
            
            // 화면 보이기 안보이기
            fnListShow = function(
                wholeBoolean, stuNoticeBoolean, profNoticeBoolean, 
                stuQnaBoolean, profQnaBoolean, staffQnaBoolean,
                realSeminarBoolean, departBoolean, subjectBoolean,
                progBoolean, weekBoolean, learnBoolean, 
                learnProgressBoolean, historyBoolean) {

                // 1
                if(wholeBoolean) {
                    $("#wholeNoticeListDiv").show();
                } else {
                    $("#wholeNoticeListDiv").hide();
                    $("#wholeNoticeList > tr").remove();
                }
                // 2
                if(stuNoticeBoolean) {
                    $("#stuSubjNoticeListDiv").show();
                } else {
                    $("#stuSubjNoticeListDiv").hide();
                    $("#stuSubjNoticeList > tr").remove();
                }
                // 3
                if(profNoticeBoolean) {
                    $("#profSubjNoticeListDiv").show();
                } else {
                    $("#profSubjNoticeListDiv").hide();
                    $("#profSubjNoticeList > tr").remove();
                }
                // 4
                if(stuQnaBoolean) {
                    $("#stuSubjQnaListDiv").show();
                } else {
                    $("#stuSubjQnaListDiv").hide();
                    $("#stuSubjQnaList > tr").remove();
                }
                // 5
                if(profQnaBoolean) {
                    $("#profSubjQnaListDiv").show();
                } else {
                    $("#profSubjQnaListDiv").hide();
                    $("#profSubjQnaList > tr").remove();
                }
                // 6
                if(staffQnaBoolean) {
                    $("#staffSubjQnaListDiv").show();
                } else {
                    $("#staffSubjQnaListDiv").hide();
                    $("#staffSubjQnaList > tr").remove();
                }
                // 7
                if(realSeminarBoolean) {
                    $("#realSeminarListDiv").show();
                } else {
                    $("#realSeminarListDiv").hide();
                    $("#realSeminarList > tr").remove();
                }
                // 8
                if(departBoolean) {
                    $("#departmentAttendListDiv").show();
                } else {
                    $("#departmentAttendListDiv").hide();
                    $("#departmentAttendList > tr").remove();
                }
                // 9
                if(subjectBoolean) {
                    $("#subjectAttendListDiv").show();
                } else {
                    $("#subjectAttendListDiv").hide();
                    $("#subjectAttendList > tr").remove();
                }
                // 10
                if(progBoolean) {
                    $("#stdProgListDiv").show();
                } else {
                    $("#stdProgListDiv").hide();
                    $("#stdProgList > tr").remove();
                }
                // 11
                if(weekBoolean) {
                    $("#weekListDiv").show();
                } else {
                    $("#weekListDiv").hide();
                    $("#weekList > tr").remove();
                }
                // 12
                if(learnBoolean) {
                    $("#learnListDiv").show();
                } else {
                    $("#learnListDiv").hide();
                    $("#learnList > tr").remove();
                }
                // 13
                if(learnProgressBoolean) {
                    $("learnProgressListDiv").show();
                } else {
                    $("learnProgressListDiv").hide();
                    $("learnProgressList > tr").remove();
                }
                // 14
                if(historyBoolean) {
                    $("historyListDiv").show();
                } else {
                    $("historyListDiv").hide();
                    $("historyList > tr").remove();
                }
            }

        });
    </script>
    </head>

    <div id="loading_page">
        <p><i class="notched circle loading icon"></i></p>
    </div>

<body class="modal-page p20" style="max-width:1280px; margin-left:auto; margin-right:auto">

    <div id="wrap">

        <!-- 본문 content 부분 -->
        <div class="content stu_section">
            <div class="ui form">

                <div class="ui medium header tc bcBlue p20 mb0 fcWhite"><b>LMS API 서비스</b></div> 
                <div class="ui divider pt1 bcLBlue2 mt0"></div>


                학생 메뉴<br />
                <div class="button-area tc mt20 mb20">
                    <a onclick="fnLmsStuAlarmApi('2023', '21', '', '', '2023108740', 'NOTICE');" class="ui basic small button">LMS 강의공지 읽지않은 건수</a>
                    <a onclick="fnLmsStuAlarmApi('2023', '21', '', '', '2023108740', 'QNA');" class="ui basic small button">Q&A 답변 읽지않은 건수</a>
                    <a onclick="fnLmsStuAlarmApi('2023', '21', '', '', '2023108740', 'SECRET');" class="ui basic small button">1:1 상담 답변 읽지않은 건수</a>
                    <a onclick="fnLmsStuAlarmApi('2023', '21', '', '', '2023108740', 'ASMT');" class="ui basic small button">과제 미제출 건수</a>
                    <a onclick="fnLmsStuAlarmApi('2023', '21', '', '', '2023108740 ', 'FORUM');" class="ui basic small button">토론 미제출 건수</a>
                    <a onclick="fnLmsStuAlarmApi('2023', '21', '', '', '2023108740 ', 'QUIZ');" class="ui basic small button">퀴즈 미제출 건수</a>
                    <a onclick="fnLmsStuAlarmApi('2023', '21', '', '', '2023108740 ', 'RESCH');" class="ui basic small button">설문 미제출 건수</a>
                </div>
                <div class="button-area tc mt20 mb20">
                    <a onclick="fnWholeNoticeList('2023108740', 'G');" class="ui basic small button">대학원 강의실 전체 공지사항 내역</a>
                    <a onclick="fnWholeNoticeList('2023108740', 'C');" class="ui basic small button">학부 강의실 전체 공지사항 내역</a>
                    <a onclick="fnStuSubjNoticeList('2023', '20', '', '', '2023108740', 'NOTICE');" class="ui basic small button">학생 강의 공지사항 내역</a>
                    <a onclick="fnStuSubjQnaList('2023', '20', '', '', '2023108740', 'QNA');" class="ui basic small button">학생 과목 Q&A 내역</a>
                    <a onclick="fnStuCrsCreList('2023', '20', '2023108740');" class="ui basic small button">학생 과목 목록 조회</a>
                </div>


                학생 메뉴<br />
                <div class="button-area tc mt20 mb20">
                    <a onclick="fnStdProgressRatio('2023', '20', '2023108740', 'A', '');" class="ui basic small button">학생 나의 평균 진도율</a>
                    <a onclick="fnStdProgressRatio('2023', '20', '2023108740', 'B', 'C');" class="ui basic small button">대학교 전체 평균 진도율</a>
                    <a onclick="fnStdProgressRatio('2023', '20', '2023200030', 'B', 'G');" class="ui basic small button">대학원 전체 평균 진도율</a>
                    <a onclick="fnStdProgressRatio('2023', '20', '2023108740', 'C', 'C');" class="ui basic small button">대학교 나의 수강과목 정보 및 진도율</a>
                    <a onclick="fnStdProgressRatio('2023', '20', '2023200030', 'C', 'G');" class="ui basic small button">대학원 나의 수강과목 정보 및 진도율</a> 
                </div>


                교수자 메뉴<br />
                <div class="button-area tc mt20 mb20">
                    <a onclick="fnLmsProfAlarmApi('2023', '20', '', '', '1190006', 'QNA');" class="ui basic small button">교수 담당과목의 Q&A 미답변 건수</a>
                    <a onclick="fnLmsProfAlarmApi('2023', '20', '', '', '1190006', 'SECRET');" class="ui basic small button">교수 담당과목의 1:1 상담 미답변 건수</a>
                    <a onclick="fnLmsProfExamAbsentApi('2023', '20', '', '', '5220019');" class="ui basic small button">신청받은 결시원 건수</a>
                    <a onclick="fnLmsProfScoreObjtApi('2023', '20', '', '', '1190006');" class="ui basic small button">성적 재확인 신청 받은 건수</a>
                    <a onclick="fnLmsDisabledPersonApi('2023', '20', '', '', '1190006');" class="ui basic small button">장애인지원 신청 건수</a>
                </div>
                <div class="button-area tc mt20 mb20">
                    <a onclick="fnProfSubjNoticeList('2023', '20', '', '', '1190006', 'NOTICE');" class="ui basic small button">교수.조교 과목 공지사항 내역</a>
                    <a onclick="fnProfSubjQnaList('2023', '20', '', '', '1190006', 'QNA');" class="ui basic small button">교수, 조교 과목 Q&A 내역</a>
                    <a onclick="fnStaffSubjQnaList('2023', '20', '', '', '1190006', 'QNA');" class="ui basic small button">직원 과목 Q&A 내역</a>
                </div>


                교수자 메뉴<br />
                <div class="button-area tc mt20 mb20">
                    <a onclick="fnProfProgressRatio('2023', '20', '1190006', 'B', 'C');" class="ui basic small button">교수 대학교 전체 평균 진도율</a>
                    <a onclick="fnProfProgressRatio('2023', '20', '1190006', 'B', 'G');" class="ui basic small button">교수 대학원 전체 평균 진도율</a>
                    <a onclick="fnProfSubjectProgressRatio('2023', '20', '1190006');" class="ui basic small button">교수,조교 과목별 수강생 평균 진도율</a>
                </div>
                <div class="button-area tc mt20 mb20">
                    <a onclick="fnDepartPerWeekAttend( '2023', '21', '1190006', 'A');" class="ui basic small button">교수 학과별 주차별 출석 현황</a>
                    <a onclick="fnDepartPerWeekAttend( '2023', '21', '1190006', 'B');" class="ui basic small button">학과장 학과별 주차별 출석현황</a>
                    <a onclick="fnSubjectPerWeekAttend('2023', '21', '', '', '1190006', 'A');" class="ui basic small button">교수 과목별 출석현황</a>
                    <a onclick="fnSubjectPerWeekAttend('2023', '21', '', '', '1190006', 'B');" class="ui basic small button">학과장 과목별 출석현황</a>
                </div>


                교수자, 학생 겸용 메뉴<br />
                <div class="button-area tc mt20 mb20">
                    <a onclick="fnProfRealSeminarList('2023', '20', '', '', '5230021');" class="ui basic small button">교수 실시간 세미나 내역</a>
                    <a onclick="fnRealSeminarList('2023', '20', '', '', '2022200016');" class="ui basic small button">학생 실시간 세미나 내역</a>
                    <a onclick="fnTotalPerWeekAttend('2023', '20', '', '', '1190006');" class="ui basic small button">전체 주차별 출석현황</a>
                    <a onclick="fnPerWeekAttend('2023', '20', '1190006');" class="ui basic small button">주차별 학습현황</a>
                </div>


                입력 메뉴<br />
                <div class="button-area tc mt20 mb20">
                    <a onclick="fnInsertProgRatio();" class="ui basic small button">학생 평균 진도율 입력</a>
                    <a onclick="fnInsertAttendRatio();" class="ui basic small button">학생 출석율 입력</a>
                </div>


                상상플러스<br />
                <div class="button-area tc mt20 mb20">
                    <a onclick="fnWeekList('2023', '20', '20201227', '1', '', '1', '100');" class="ui basic small button">주차별 수강현황 내역</a>
                    <br />
                    <br />

                    <a onclick="fnAsmntTotalList('2023', '20', '', '0', '100');" class="ui basic small button">과제 학습활동 내역</a>
                    <a onclick="fnForumTotalList('2023', '20', '', '0', '100');" class="ui basic small button">토론 학습활동 내역</a>
                    <a onclick="fnQuizTotalList('2023', '20', '', '1', '100');" class="ui basic small button">퀴즈 학습활동 내역</a>
                    <a onclick="fnReschTotalList('2023', '20', '', '1', '100');" class="ui basic small button">설문 학습활동 내역</a>
                    <a onclick="fnSeminarTotalList('20244', '40', '20231227',  '1', '100');" class="ui basic small button">세미나 학습활동 내역</a>
                    <br />
                    <br />

                    <a onclick="fnSelectLearnList('2023', '20', '20231115',  '0', '100');" class="ui basic small button">학습진도 목록</a>
                    <br />
                    <br />

                    <a onclick="fnAsmntAcademyList('2023', '20', '', '1', '10');" class="ui basic small button">과제 학습활동 이력</a>
                    <a onclick="fnForumAcademyList('2023', '20', '', '1', '10');" class="ui basic small button">토론 학습활동 이력</a>
                    <a onclick="fnQuizAcademyList('2023', '20', '', '1', '10');" class="ui basic small button">퀴즈 학습활동 이력</a>
                    <a onclick="fnReschAcademyList('2023', '20', '', '1', '10');" class="ui basic small button">설문 학습활동 이력</a>
                    <a onclick="fnSeminarAcademyList('2023', '20', '20221201',  '1', '5000');" class="ui basic small button">세미나 학습활동 이력</a>
                </div>

                <form id="alarmForm" name="alarmForm">
                    <input type="hidden" id="rcvUserInfoStr"   name="rcvUserInfoStr"  value="" />        <!-- 보내는사람         순서대로 셋팅 해주세요 -->
                    <input type="hidden" id="userId"           name="userId"          value="" />        <!-- 사용자번호 -->
                    <input type="hidden" id="userNm"           name="userNm"          value="" />        <!-- 사용자명 -->
                    <input type="hidden" id="userEmail"        name="userEmail"       value="" />        <!-- 이메일주소 -->
                    <input type="hidden" id="deptCd"           name="deptCd"          value="" />        <!-- 부서코드 -->
                    <input type="hidden" id="userGbn"          name="userGbn"         value="" />        <!-- 사용자구분 -->
                    <input type="hidden" id="sysCd"            name="sysCd"           value="" />        <!-- 시스템코드(필수) -->
                    <input type="hidden" id="orgId"            name="orgId"           value="" />        <!-- 기관코드(필수) -->
                    <input type="hidden" id="bussGbn"          name="bussGbn"         value="" />        <!-- 업무구분(필수) -->
                    <input type="hidden" id="alarmType"        name="alarmType"       value=""/>         <!-- 알림구분(필수) -->
                    <input type="hidden" id="pageIndex"        name="pageIndex"       value=""/>         <!-- 현재 페이지 번호 -->
                    <input type="hidden" id="listScale"        name="listScale"       value=""/>         <!-- 한 페이지당 게시되는 게시물 건 수 -->
                    <input type="hidden" id="pageScale"        name="pageScale"       value=""/>         <!-- 페이지 리스트에 게시되는 페이지 건수 -->
                    
                <div class="ui segment">
                    <div class="ui stackable four column grid">

                    </div>
                        <!--
                        <div class="button-area tc">
                        <a onclick="fnUserSearch();" class="ui blue button">조회</a>
                        </div> 
                        -->
                </div>
                
                <div class="option-content mt10 mb10">   
                    <div class="sec_head" id="titleTop"></div>
                    <div class="ui small label ml5" id="totalCnt"></div>
                </div>

                <!-- list table형 강의실 전체 공지사항 내역 -->
                <div  class="verticalScrollarea maxheight500 mb20" id="wholeNoticeListDiv"> 
                    <table id="" class="table c_table table-layout-fixed" data-sorting="true" data-paging="false" data-empty="등록된 내용이 없습니다.">
                        <thead>
                            <tr>
                                <th scope="col" class="wf7">제목</th>
                                <th scope="col" class="wf8">등록일시</th>
                                <th scope="col" class="wf8">등록자</th>
                                <th scope="col" class="wf7">링크주소</th>
                            </tr>
                        </thead>
                        <tbody id="wholeNoticeList">
                        </tbody>
                    </table>
                </div> 
                <!-- //list table형 -->
   
                <!-- list table형 학생 과목 공지사항 내역 -->
                <div  class="verticalScrollarea maxheight500 mb20" id="stuSubjNoticeListDiv"> 
                    <table id="" class="table c_table table-layout-fixed" data-sorting="true" data-paging="false" data-empty="등록된 내용이 없습니다.">
                        <thead>
                            <tr>
                                <th scope="col" class="wf7">제목</th>
                                <th scope="col" class="wf8">등록일시</th>
                                <th scope="col" class="wf8">등록자</th>
                                <th scope="col" class="wf7">링크주소</th>
                            </tr>
                        </thead>
                        <tbody id="stuSubjNoticeList">
                        </tbody>
                    </table>
                </div>
                <!-- //list table형 -->
                
                <!-- list table형 조교, 교수 과목 공지사항 내역 -->
                <div  class="verticalScrollarea maxheight500 mb20" id="profSubjNoticeListDiv"> 
                    <table id="" class="table c_table table-layout-fixed" data-sorting="true" data-paging="false" data-empty="등록된 내용이 없습니다.">
                        <thead>
                            <tr>
                                <th scope="col" class="wf7">제목</th>
                                <th scope="col" class="wf8">등록일시</th>
                                <th scope="col" class="wf8">등록자</th>
                                <th scope="col" class="wf7">링크주소</th>
                            </tr>
                        </thead>
                        <tbody id="profSubjNoticeList">
                        </tbody>
                    </table>
                </div>
                <!-- //list table형 -->

                <!-- list table형 학생 과목 QNA 내역 -->
                <div  class="verticalScrollarea maxheight500 mb20" id="stuSubjQnaListDiv"> 
                    <table id="" class="table c_table table-layout-fixed" data-sorting="true" data-paging="false" data-empty="등록된 내용이 없습니다.">
                        <thead>
                            <tr>
                                <th scope="col" class="wf7">제목</th>
                                <th scope="col" class="wf8">등록일시</th>
                                <th scope="col" class="wf8">답변등록여부</th>
                                <th scope="col" class="wf7">링크주소</th>
                            </tr>
                        </thead>
                        <tbody id="stuSubjQnaList">
                        </tbody>
                    </table>
                </div>
                <!-- //list table형 -->

                <!-- list table형 조교,교수 과목 QNA 내역 -->
                <div  class="verticalScrollarea maxheight500 mb20" id="profSubjQnaListDiv"> 
                    <table id="" class="table c_table table-layout-fixed" data-sorting="true" data-paging="false" data-empty="등록된 내용이 없습니다.">
                        <thead>
                            <tr>
                                <th scope="col" class="wf7">제목</th>
                                <th scope="col" class="wf8">등록일시</th>
                                <th scope="col" class="wf8">답변등록여부</th>
                                <th scope="col" class="wf8">문의자</th>
                                <th scope="col" class="wf7">링크주소</th>
                            </tr>
                        </thead>
                        <tbody id="profSubjQnaList">
                        </tbody>
                    </table>
                </div>
                <!-- //list table형 -->

                <!-- list table형 조교,교수 과목 QNA 내역 -->
                <div  class="verticalScrollarea maxheight500 mb20" id="staffSubjQnaListDiv"> 
                    <table id="" class="table c_table table-layout-fixed" data-sorting="true" data-paging="false" data-empty="등록된 내용이 없습니다.">
                        <thead>
                            <tr>
                                <th scope="col" class="wf7">제목</th>
                                <th scope="col" class="wf8">등록일시</th>
                                <th scope="col" class="wf8">답변등록여부</th>
                                <th scope="col" class="wf8">문의자</th>
                                <th scope="col" class="wf7">링크주소</th>
                            </tr>
                        </thead>
                        <tbody id="staffSubjQnaList">
                        </tbody>
                    </table>
                </div>
                <!-- //list table형 -->

                <!-- list table형 실시간 세미나 내역 -->
                <div  class="verticalScrollarea maxheight500 mb20" id="realSeminarListDiv"> 
                    <table id="" class="table c_table table-layout-fixed" data-sorting="true" data-paging="false" data-empty="등록된 내용이 없습니다.">
                        <thead>
                            <tr>
                                <th scope="col" class="wf7">제목</th>
                                <th scope="col" class="wf8">시간(분)</th>
                                <th scope="col" class="wf8">시작일시</th>
                                <th scope="col" class="wf8">종료일시</th>
                                <th scope="col" class="wf7">링크주소</th>
                            </tr>
                        </thead>
                        <tbody id="realSeminarList">
                        </tbody>
                    </table>
                </div>
                <!-- //list table형 -->

                <!-- list table형 실시간 세미나 내역 -->
                <div  class="verticalScrollarea maxheight500 mb20" id="departmentAttendListDiv"> 
                    <table id="" class="table c_table table-layout-fixed" data-sorting="true" data-paging="false" data-empty="등록된 내용이 없습니다.">
                        <thead>
                            <tr>
                                <th scope="col" class="">학과</th>
                                <th scope="col" class="wf20">주차</th>
                                <th scope="col" class="">작년 평균 출석율</th>
                                <th scope="col" class="">올해 평균 출석율</th>
                            </tr>
                        </thead>
                        <tbody id="departmentAttendList">
                        </tbody>
                    </table>
                </div>
                <!-- //list table형 -->

                <!-- list table형 실시간 세미나 내역 -->
                <div  class="verticalScrollarea maxheight500 mb20" id="subjectAttendListDiv"> 
                    <table id="" class="table c_table table-layout-fixed" data-sorting="true" data-paging="false" data-empty="등록된 내용이 없습니다.">
                        <thead>
                            <tr>
                                <th scope="col" class="wf40">과목</th>
                                <th scope="col" class="">평균출석율</th>
                            </tr>
                        </thead>
                        <tbody id="subjectAttendList">
                        </tbody>
                    </table>
                </div>
                <!-- //list table형 -->

                <!-- list table형 실시간 세미나 내역 -->
                <div  class="verticalScrollarea maxheight500 mb20" id="stdProgListDiv"> 
                    <table id="" class="table c_table table-layout-fixed" data-sorting="true" data-paging="false" data-empty="등록된 내용이 없습니다.">
                        <thead>
                            <tr>
                                <th scope="col" class="">과목명</th>
                                <th scope="col" class="">학습주차주</th>
                                <th scope="col" class="">전체주차주</th>
                                <th scope="col" class="">진도율</th>
                            </tr>
                        </thead>
                        <tbody id="stdProgList">
                        </tbody>
                    </table>
                </div>
                <!-- //list table형 -->
                
               <!-- list table형 주차별 수강현황 내역 -->
                <div  class="verticalScrollarea maxheight500 mb50" id="weekListDiv"> 
                    <table id="" class="table c_table table-layout-fixed" data-sorting="true" data-paging="false" data-empty="등록된 내용이 없습니다.">
                        <thead>
                            <tr>
                                <th scope="col" class="">년도</th>
                                <th scope="col" class="">학기</th>
                                <th scope="col" class="">사용자 번호</th>
                                <th scope="col" class="wf20">주차</th>
                                <th scope="col" class="">신청학점</th>
                                <th scope="col" class="">접속일수합계</th>
                                <th scope="col" class="">접속일수누적합계</th>
                                <th scope="col" class="">접속시간합계</th>
                                <th scope="col" class="">접속시간누적합계</th>
                                <th scope="col" class="">일접속시간 평균</th>
                                <th scope="col" class="">일접속시간 표준편차</th>
                                <th scope="col" class="">접속일간격 평균</th>
                                <th scope="col" class="">접속일간격 표준편차</th>
                                <th scope="col" class="">주간접속비율</th>
                                <th scope="col" class="">주중접속비율</th>
                                <!-- <th scope="col" class="">등록일</th> -->
                                <th scope="col" class="">수정일</th>
                            </tr>
                        </thead>
                        <tbody id="weekList">
                        </tbody>
                    </table>
                </div>
                <!-- //list table형 -->
                
                <!-- list table형 주차별 수강현황 내역 -->
                <div  class="verticalScrollarea maxheight500 mb50" id="learnListDiv"> 
                    <table id="" class="table c_table table-layout-fixed" data-sorting="true" data-paging="false" data-empty="등록된 내용이 없습니다.">
                        <thead>
                            <tr>
                                <th scope="col" class="">년도</th>
                                <th scope="col" class="">학기</th>
                                <th scope="col" class="">분반</th>
                                <th scope="col" class="wf20">과목코드</th>
                                <th scope="col" class="">학습활동코드</th>
                                <th scope="col" class="">제목</th>
                                <th scope="col" class="">과제마감일</th>
                                <th scope="col" class="">삭제여부</th>
                            </tr>
                        </thead>
                        <tbody id="learnList">
                        </tbody>
                    </table>
                </div>
                <!-- //list table형 -->

                <!-- list table형 학습진도 목록 -->
                <div  class="verticalScrollarea maxheight500 mb20" id="learnProgressListDiv"> 
                    <table id="" class="table c_table table-layout-fixed" data-sorting="true" data-paging="false" data-empty="등록된 내용이 없습니다.">
                        <thead>
                            <tr>
                                <th scope="col" class="wf7">학번</th>
                                <th scope="col" class="wf8">과목정보(코드)</th>
                                <th scope="col" class="wf8">분반</th>
                                <th scope="col" class="wf8">주차정보</th>
                                <th scope="col" class="wf8">주차별출석여부</th>
                                <th scope="col" class="wf7">학습진도율</th>
                                <th scope="col" class="wf7">등록일</th>
                            </tr>
                        </thead>
                        <tbody id="learnProgressList">
                        </tbody>
                    </table>
                </div> 
                <!-- //list table형 -->
                
                <!-- list table형 주차별 수강현황 내역 -->
                <div  class="verticalScrollarea maxheight500 mb50" id="historyListDiv"> 
                    <table id="" class="table c_table table-layout-fixed" data-sorting="true" data-paging="false" data-empty="등록된 내용이 없습니다.">
                        <thead>
                            <tr>
                                <th scope="col" class="">학번</th>
                                <th scope="col" class="">학습활동ID</th>
                                <th scope="col" class="">등록일</th>
                            </tr>
                        </thead>
                        <tbody id="historyList">
                        </tbody>
                    </table>
                </div>
                <!-- //list table형 -->
                
                </form>
            </div>
        </div>
    </div>
    <!-- //본문 content 부분 -->

    <script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>

</html>