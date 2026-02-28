<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<%@ page import="javax.crypto.Cipher"%>
<%@ page import="java.security.KeyFactory"%>
<%@ page import="java.security.PublicKey"%>
<%@ page import="java.security.spec.X509EncodedKeySpec"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.security.MessageDigest"%>
<%!

// 통합메시지 인증 토큰용 공개키
String MSG_PUBKEY = "30820122300d06092a864886f70d01010105000382010f003082010a02820101008645e3710c2b2594aabedc69266c19457b6ed8d91ab5241319cc75dcc44eaa941428f7bba0f0dfd11df0cdae8b2646bfdea48102791933d192ef45f115857d250ffc4728a7a8fd0f96b8948fbbf3b0fb679615574c8d761bce9a21ac0ae71424f853ec7948ed2993e63f80d94b1aea7b7f38f610e54ebcd68757e92db784eb67114e14ea86cda996b169f094968461e0e44e562994092250e26de30458945fb6d39f285e78e9fcac67fc5d35177df513aa8f8ce344a20cc79083d67c9558e16e5f86296a46608ee7d2f2d4146579348737567908dc351de531b9ca1d88334f1b6c1b8257485575fec48cfae5adee2dc4b7f7db6ae959e20d92aa08f3d1b669270203010001";

// 통합메시지 인증 토큰
public String getMsgToken(String sessionId, String userId) {
    String encValue = "";
    
    try {
        String date = (new SimpleDateFormat("yyyyMMddHHmmss")).format(new Date());
        String value = sessionId + "," + userId + "," + date;
        
        byte[] pubBytes = new byte[MSG_PUBKEY.length() / 2];
        for (int i = 0; i < MSG_PUBKEY.length(); i += 2) {
            pubBytes[(int) Math.floor(i / 2)] = (byte)Integer.parseInt(MSG_PUBKEY.substring(i, i + 2), 16);
        }
        
        X509EncodedKeySpec keySpec = new X509EncodedKeySpec(pubBytes);
        PublicKey pubKey = (KeyFactory.getInstance("RSA")).generatePublic(keySpec);
        Cipher cipher = Cipher.getInstance("RSA");
        cipher.init(Cipher.ENCRYPT_MODE, pubKey);
        
        StringBuilder sb = new StringBuilder();
        for (byte b : cipher.doFinal(value.getBytes("utf-8"))) {
            sb.append(String.format("%02x", b&0xff));
        }
        
        encValue = sb.toString();;

    } catch (Exception e) {
        e.printStackTrace();
    }
    
    return encValue;
}


%>
<%
    String sesId = request.getSession().getId();
    String ssoId = SessionInfo.getUserId(request);
    
    String token = getMsgToken(sesId, ssoId);
    //out.println("sesId = "+sesId +"<br>");
    //out.println("ssoId = "+ssoId +"<br>");
    //out.println("token = "+token +"<br>");
%>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
    <%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
    <link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    
    <script type="text/javascript" src="/webdoc/js/iframe.js"></script>
    <script type="text/javascript">
        // 요청 승인, 반려
        function absentRequest(examAbsentCd, type) {
            var subject, apprCts, logDesc, ctnt;
            var url = "/jobSchHome/viewSysJobSch.do";
            var data = {
                "crsCreCd"     : "${creCrsVO.crsCreCd}",
                "calendarCtgr" : "00190901",
                "termCd"       : "${termVO.termCd}"
            };
            
            ajaxCall(url, data, function(data) {
                if(data.result > 0) {
                    var returnVO = data.returnVO;
                    if(returnVO != null) {
                        var jobSchPeriodYn = returnVO.jobSchPeriodYn;
                        
                        if(jobSchPeriodYn == "Y") {
                            var confirm = "";
                            if(type == "APPROVE") {
                                subject = "[" + $("#crsCreNm").val() + "] 결시원 [승인] 안내 ";
                                logDesc = "이메일 결시원 승인 발송";
                                ctnt = "[" + $("#userNm").val() + "] 학우님께서 신청하신 \n [" + $("#crsCreNm").val() + "] 결시원이 [승인] 되어 안내드립니다. \n\n 처리내용 \n\n";
                                confirm = window.confirm("<spring:message code='exam.confirm.approve' />");// 요청 승인 하시겠습니까?
                            } else if(type == "COMPANION") {
                                subject = "[" + $("#crsCreNm").val() + "] 결시원 [반려] 안내 ";
                                logDesc = "이메일 결시원 반려 발송";
                                ctnt = "[" + $("#userNm").val() + "] 학우님께서 신청하신 \n [" + $("#crsCreNm").val() + "] 결시원이 [반려] 되어 안내드립니다. \n\n 처리내용 \n\n";
                                confirm = window.confirm("<spring:message code='exam.confirm.companion' />");// 요청 반려 하시겠습니까?
                            }
                            
                            if(confirm) {
                                if(editor.isEmpty() || editor.getTextContent().trim() === "") {
                                    alert("<spring:message code='exam.alert.input.contents' />");// 내용을 입력하세요.
                                    return false;
                                }
                                
                                apprCts = editor.getPublishingHtml();
                                
                                var url  = "/exam/updateExamAbsent.do";
                                var data = {
                                    "examAbsentCd" : examAbsentCd,
                                    "apprStat"     : type,
                                    "apprCts"      : apprCts
                                };
                                
                                ajaxCall(url, data, function(data) {
                                    if (data.result > 0) {
                                        
                                        var url  = "<%=CommConst.SYSMSG_URL_INSERT%>";
                                        var rcvEmailArray = new Array();
                                        
                                        var rcvEmailVO = null;
                                        rcvEmailVO = new Object();
                                        rcvEmailVO.rcvNo = $("#userId").val();                // 수신자 개인번호1
                                        rcvEmailVO.rcvNm = $("#userNm").val();                // 수신자 이름1
                                        rcvEmailVO.rcvEmailAddr = $("#rcvEmailAddr").val();   // 수신자 이메일 주소1

                                        rcvEmailArray.push(rcvEmailVO);
                                        var rcvJsonData = JSON.stringify(rcvEmailArray).replace(/\"/gi, "\\\"");
                                        
                                        var data = {
                                            alarmType         : "E",                      //알림유형
                                            userId            : "<%=SessionInfo.getUserId(request)%>",          //로그인한 사용자 번호
                                            userNm            : "<%=SessionInfo.getUserNm(request)%>",          //로그인한 사용자 이름
                                            sysCd             : "LMS",                    //시스템코드
                                            orgId             : "KNOU",                   //기관코드
                                            bussGbn           : "LMS",                    //업무코드
                                            subject           : subject,                  //제목
                                            ctnt              : ctnt + apprCts,           //내용
                                            sndrPersNo        : "<%=SessionInfo.getUserId(request)%>",      //발송자 개인번호
                                            sndrDeptCd        : "<%=SessionInfo.getUserDeptCd(request)%>",  //발송자 부서번호
                                            sndrNm            : "<%=SessionInfo.getUserNm(request)%>",      //발송자명
                                            sndrEmailAddr     : "no-reply@hycu.ac.kr",    //발송자이메일주소
                                            logDesc           : logDesc,                  //이메일 발송 설명
                                            courseCd          : $("#crsCreCd").val(),      //과목코드
                                            token             : "<%=token%>",             //토큰 정보                        
                                            rcvJsonData       : rcvJsonData               //수신자 정보
                                        };
                                        
                                        ajaxCall(
                                            url
                                            , data
                                            , function(data){
                                                  if (data.result > 0) {
                                                	  console.log('메일 발송 OK!!!');                                                
                                                  }
                                                  else {
                                                      console.log("메일 에러 : " + data.message);
                                                  }                           
                                              }
                                            , function(xhr, status, error) {
                                                console.log(xhr);   
                                            }                         
                                        );

                                        if(type == "APPROVE") {
                                            alert("<spring:message code='exam.alert.approve' />");// 승인이 완료되었습니다.
                                        } else if(type == "COMPANION") {
                                            alert("<spring:message code='exam.alert.companion' />");// 반려가 완료되었습니다.
                                        }
                                        window.parent.listExamAbsent(1);
                                        window.parent.closeModal(); 
                                        
                                    } else {
                                        alert(data.message);
                                    }
                                }, function(xhr, status, error) {
                                    alert("<spring:message code='fail.common.msg' />");// 에러가 발생했습니다!
                                });
                            }
                        } else {
                            alert("<spring:message code='exam.alert.absent.approve.not.datetime' />");// 결시원 승인은 승인기간 안에만 가능합니다.
                        }
                    } else {
                        alert("<spring:message code='sys.alert.already.job.sch' />");/* 등록된 일정이 없습니다. */
                    }
                } else {
                    alert(data.message);
                }
            }, function(xhr, status, error) {
                alert("<spring:message code='exam.error.info' />");/* 정보 조회 중 에러가 발생하였습니다. */
            });
        }
        
        // 결시원 신청이력
        function viewExamAbsentList() {
            $("#absentHistoryForm > input[name='crsCreCd']").val('<c:out value="${creCrsVO.crsCreCd}" />');
            $("#absentHistoryForm > input[name='stdNo']").val('<c:out value="${stdVO.stdNo}" />');
            $("#absentHistoryForm").attr("target", "absentHistoryIfm");
            $("#absentHistoryForm").attr("action", "/exam/examAbsentListPop.do");
            $("#absentHistoryForm").submit();
            $('#absentHistoryModal').modal('show');
        }
        
    </script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
    <div id="loading_page">
        <p><i class="notched circle loading icon"></i></p>
    </div>
    <div id="wrap">
        <div class="option-content pb15">
            <h3 class="sec_head"> <spring:message code="exam.label.applicate.list" /></h3><!-- 신청내역 -->
            <div class="mla">
                <c:if test="${not empty vo }">
                    <%-- <a href="javascript:absentAllCompanion()" class="ui blue button"><spring:message code="exam.label.absent.clean" /></a> --%><!-- 결시원 정리 -->
                    <a href="javascript:absentRequest('${vo.examAbsentCd }', 'APPROVE')" class="ui blue button"><spring:message code="exam.label.approve" /></a><!-- 승인 -->
                    <a href="javascript:absentRequest('${vo.examAbsentCd }', 'COMPANION')" class="ui blue button"><spring:message code="exam.label.companion" /></a><!-- 반려 -->
                </c:if>
            </div>
        </div>
        <ul class="sixteen wide field tbl dt-sm mb20">
            <li>
                <dl>
                    <dt><spring:message code="exam.label.subject.nm" /><!-- 교과명 --></dt>
                    <dd>${vo.crsCreNm }<input type="hidden" id="crsCreNm" name="crsCreNm" value="${vo.crsCreNm}"/><input type="hidden" id="crsCreCd" name="crsCreCd" value="${vo.crsCreCd}"/></dd>
                    <dt><spring:message code="crs.label.decls" /><!-- 분반 --></dt>
                    <dd>${vo.declsNo }<spring:message code="exam.label.decls" /><!-- 반 --></dd>
                </dl>
                <dl>
                    <fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss" value="${vo.examStartDttm }" />
                    <fmt:formatDate var="examStartDttm" pattern="yyyy.MM.dd HH:mm" value="${startDateFmt }" />
                    <dt><spring:message code="exam.label.exam" /><!-- 시험 --><spring:message code="exam.label.stare.type" /><!-- 구분 --></dt>
                    <dd>${vo.examStareTypeNm }</dd>
                    <dt><spring:message code="exam.label.exam" /><!-- 시험 --><spring:message code="exam.label.dttm" /><!-- 일시 --></dt>
                    <dd>${examStartDttm }</dd>
                </dl>
                <dl>
                    <dt><spring:message code="exam.label.tch" /><!-- 교수 --><spring:message code="exam.label.nm" /><!-- 명 --></dt>
                    <dd>${vo.tchNm }</dd>
                    <dt><spring:message code="exam.label.tutor" /><!-- 튜터 --><spring:message code="exam.label.nm" /><!-- 명 --></dt>
                    <dd>${vo.tutorNm }</dd>
                </dl>
            </li>
        </ul>
        <ul class="sixteen wide field tbl dt-sm mb20">
            <li>
                <dl>
                    <dt><spring:message code="exam.label.user.no" /><!-- 학번 --></dt>
                    <dd>${vo.userId}<input type="hidden" id="userId" name="userId" value="${vo.userId}"/><input type="hidden" id="rcvEmailAddr" name="rcvEmailAddr" value="${vo.email}"/></dd>
                    <dt><spring:message code="exam.label.user.nm" /><!-- 이름 --></dt>
                    <dd>
                    	${vo.userNm}<input type="hidden" id="userNm" name="userNm" value="${vo.userNm}"/>
                    	<c:if test="${isKnou eq 'true'}">
                    		<a href="javascript:void(0);" onclick="userInfoPop('${vo.userId}')" class="" title="사용자 정보"><i class="ico icon-info"></i></a>
                    	</c:if>
                    </dd>
                </dl>
                <dl>
                    <dt><spring:message code="exam.label.dept" /><!-- 학과 --></dt>
                    <dd>${vo.deptNm }</dd>
                    <dt><spring:message code="exam.label.mobile.no" /><!-- 연락처 --></dt>
                    <dd>${vo.mobileNo }</dd>
                </dl>
                <dl>
                    <dt><spring:message code="exam.label.exam" /><!-- 시험 --><spring:message code="exam.label.answer.yn" /><!-- 응시여부 --></dt>
                    <dd>${vo.examStareYn }</dd>
                    <dt><spring:message code="exam.label.evidence" /><!-- 증빙자료 --></dt>
                    <dd>
                        <c:forEach var="list" items="${vo.fileList }">
                            <a href="javascript:fileDown(`${list.fileSn }`, `${list.repoCd }`)" id="file_${list.fileSn }" class="wmax"><i class="icon paperclip" style="position:absolute;right:0;"></i></a>
                            <script>
                                byteConvertor("${list.fileSize}", "${list.fileNm}", "${list.fileSn}");
                            </script>
                        </c:forEach>
                    </dd>
                </dl>
                <dl>
                    <dt><spring:message code="exam.label.absent.reason" /><!-- 결시 사유 --></dt>
                    <dd><pre>${vo.absentCts }</pre></dd>
                </dl>
            </li>
        </ul>
        <div class="option-content pb15">
            <h3 class="sec_head"> <spring:message code="exam.label.approve.process" /></h3><!-- 승인처리 -->
            <c:if test="${examAbsentApplicateYnMap.midApplicateYn eq 'Y' and examAbsentApplicateYnMap.lastApplicateYn eq 'Y'}">
            <div class="mla">
                <span class="fcRed">*&nbsp;
                    <spring:message code="exam.label.mid" /><!-- 중간 -->/<spring:message code="exam.label.final" /><!-- 기말 --> <spring:message code="exam.label.has.applicant" /><!-- 신청한 내역이 있습니다. -->
                </span>
            </div>
            </c:if>
        </div>
        <ul class="sixteen wide field tbl dt-sm mb20">
            <li>
                <dl>
                    <dt><spring:message code="exam.label.process.status" /><!-- 처리상태 --></dt>
                    <dd class="flex">
                        <div class="flex-item">
                            <c:choose>
                                <c:when test="${vo.apprStat eq 'APPLICATE' }">
                                    <span class="fcBlue"><spring:message code="exam.label.applicate" /><!-- 신청 --></span>
                                </c:when>
                                <c:when test="${vo.apprStat eq 'RAPPLICATE' }">
                                    <span class="fcBlue"><spring:message code="exam.label.rapplicate" /><!-- 재신청 --></span>
                                </c:when>
                                <c:when test="${vo.apprStat eq 'APPROVE' }">
                                    <span class="fcGreen"><spring:message code="exam.label.approve" /><!-- 승인 --></span>
                                </c:when>
                                <c:when test="${vo.apprStat eq 'COMPANION' }">
                                    <span class="fcRed"><spring:message code="exam.label.companion" /><!-- 반려 --></span>
                                </c:when>
                                <c:otherwise>
                                    <spring:message code="exam.label.applicate.n" /><!-- 신청 전 -->
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="flex-left-auto">
                            <a href="javascript:viewExamAbsentList()" class="ui button basic"><spring:message code="exam.label.applicate.hsty" /><!-- 신청이력 --></a>
                        </div>
                    </dd>
                    <dt><spring:message code="exam.label.process.dttm" /><!-- 처리일시 --></dt>
                    <dd>
                        <c:if test="${vo.apprStat eq 'APPROVE' || vo.apprStat eq 'COMPANION' }">
                            <fmt:parseDate var="modDateFmt" pattern="yyyyMMddHHmmss" value="${vo.modDttm }" />
                            <fmt:formatDate var="modDttm" pattern="yyyy.MM.dd HH:mm" value="${modDateFmt }" />
                        </c:if>
                        ${vo.apprStat eq 'APPROVE' || vo.apprStat eq 'COMPANION' ? modDttm : '-' }
                    </dd>
                </dl>
                <dl>
                    <dt><spring:message code="exam.label.process.manage" /><!-- 처리담당자 --></dt>
                    <dd>${vo.apprStat eq 'APPROVE' || vo.apprStat eq 'COMPANION' ? vo.modNm : '-' }</dd>
                </dl>
                <dl>
                    <dt class="req"><spring:message code="exam.label.process.cts" /><!-- 처리내용 --></dt>
                    <dd style="height:300px;">
                        <div style="height:100%">
                            <textarea name="contentTextArea" id="contentTextArea">${vo.apprStat eq 'APPROVE' || vo.apprStat eq 'COMPANION' ? vo.apprCts : ' ' }</textarea>
                            <script>
                                // html 에디터 생성
                                var editor = HtmlEditor('contentTextArea', THEME_MODE, '/exam');
                            </script>
                        </div>
                    </dd>
                </dl>
            </li>
        </ul>
            
        <div class="bottom-content mt50">
            <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
        </div>
    </div>
    <form id="absentHistoryForm" name="absentHistoryForm">
        <input type="hidden" name="crsCreCd" value="" />
        <input type="hidden" name="stdNo" value="" />
    </form>
    <div class="modal fade in" id="absentHistoryModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="exam.label.absent.apply.hsty" />" aria-hidden="false" style="display: none; padding-right: 17px;">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="common.button.close" />">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title"><spring:message code="exam.label.absent.apply.hsty" /><!-- 결시원 신청이력 --></h4>
                </div>
                <div class="modal-body">
                    <iframe src="" width="100%" id="absentHistoryIfm" name="absentHistoryIfm"></iframe>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
    <script>
        $('iframe').iFrameResize();
        window.closeModal = function() {
            $('.modal').modal('hide');
        };
    </script>
</body>
</html>
