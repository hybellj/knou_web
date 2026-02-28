<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
   	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
  
  	<script type="text/javascript" src="/webdoc/js/iframe.js"></script>
	<script type="text/javascript">
		// 결시원 신청이력
		function viewExamAbsentList() {
			$("#absentHistoryForm > input[name='crsCreCd']").val('<c:out value="${creCrsVO.crsCreCd}" />');
			$("#absentHistoryForm > input[name='stdNo']").val('<c:out value="${vo.stdNo}" />');
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
       	<h3 class="sec_head"> <spring:message code="exam.label.process.list" /></h3><!-- 처리내역 -->
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
	       					</c:choose>
       					</div>
       					<div class="flex-left-auto">
       						<a href="javascript:viewExamAbsentList()" class="ui button basic"><spring:message code="exam.label.applicate.hsty" /><!-- 신청이력 --></a>
       					</div>
       				</dd>
       				<dt><spring:message code="exam.label.process.dttm" /><!-- 신청일시 --></dt>
       				<fmt:parseDate var="modDateFmt" pattern="yyyyMMddHHmmss" value="${vo.modDttm }" />
					<fmt:formatDate var="modDttm" pattern="yyyy.MM.dd HH:mm" value="${modDateFmt }" />
       				<dd>
       					<c:choose>
       						<c:when test="${vo.apprStat eq 'APPROVE' || vo.apprStat eq 'COMPANION' }">
       							${modDttm }
       						</c:when>
       						<c:otherwise>
       							-
       						</c:otherwise>
       					</c:choose>
       				</dd>
       			</dl>
       			<dl>
       				<dt><spring:message code="exam.label.subject.nm" /><!-- 교과명 --></dt>
       				<dd>${vo.crsCreNm }</dd>
       				<dt><spring:message code="crs.label.decls" /><!-- 분반 --></dt>
       				<dd>${vo.declsNo }<spring:message code="exam.label.decls" /><!-- 반 --></dd>
       			</dl>
       			<dl>
       				<dt><spring:message code="exam.label.process.cts" /><!-- 처리내용 --></dt>
       				<dd><pre>${vo.apprCts }</pre></dd>
       			</dl>
       		</li>
       	</ul>
       	<div class="option-content mt30 mb10">
        	<h3 class="sec_head"> <spring:message code="exam.label.absent" /> <spring:message code="exam.label.applicate.list" /></h3><!-- 결시원 --><!-- 신청내역 -->
        	<div class="mla fcBlue">
        		<spring:message code="exam.label.applicate.hsty" /> : <spring:message code="exam.label.mid.exam" /> (${examAbsentApplicateYnMap.midApplicateYn eq 'Y' ? 'O' : 'X' }), <spring:message code="exam.label.end.exam" /> (${examAbsentApplicateYnMap.lastApplicateYn eq 'Y' ? 'O' : 'X' })<!-- 신청이력 --><!-- 중간고사 --><!-- 기말고사 -->
        	</div>
       	</div>
       	<ul class="sixteen wide field tbl dt-sm mb20">
       		<li>
       			<%-- 
       			<dl>
       				<dt><spring:message code="exam.label.open" /><!-- 개설 --><spring:message code="exam.label.dept" /><!-- 학과 --></dt>
       				<dd>${creCrsVO.deptNm }</dd>
       				<dt><spring:message code="crs.label.crs.cd" /><!-- 학수번호 --></dt>
       				<dd>${creCrsVO.crsCd }</dd>
       			</dl>
       			 --%>
       			<dl>
       				<dt><spring:message code="exam.label.subject.nm" /><!-- 교과명 --></dt>
       				<dd>${creCrsVO.crsCreNm }</dd>
       				<dt><spring:message code="crs.label.decls" /><!-- 분반 --></dt>
       				<dd>${creCrsVO.declsNo }<spring:message code="exam.label.decls" /><!-- 반 --></dd>
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
       				<dt><spring:message code="exam.label.tch" /><!-- 교수 --></dt>
       				<dd>${vo.tchNm }</dd>
       				<dt><spring:message code="exam.label.assist" /><!-- 조교 --></dt>
       				<dd>${vo.tutorNm }</dd>
       			</dl>
       		</li>
       	</ul>
       	<ul class="sixteen wide field tbl dt-sm">
       		<li>
       			<dl>
       				<dt><spring:message code="exam.label.user.no" /><!-- 학번 --></dt>
       				<dd>${vo.userId }</dd>
       				<dt><spring:message code="exam.label.user.nm" /><!-- 이름 --></dt>
       				<dd>${vo.userNm }</dd>
       			</dl>
       			<dl>
       				<dt><spring:message code="exam.label.dept" /><!-- 학과 --></dt>
       				<dd>${vo.deptNm }</dd>
       				<dt><spring:message code="exam.label.mobile.no" /><!-- 연락처 --></dt>
       				<dd>${vo.mobileNo }</dd>
       			</dl>
       			<dl>
       				<dt><spring:message code="exam.label.absent.reason" /><!-- 결시 사유 --></dt>
       				<dd><pre>${vo.absentCts }</pre></dd>
       			</dl>
       			<dl>
       				<dt><spring:message code="exam.label.evidence" /><!-- 증빙자료 --></dt>
       				<dd>
       					<c:forEach var="list" items="${vo.fileList }">
							<button class="ui icon small button" id="file_${list.fileSn }" title="파일다운로드" onclick="fileDown(`${list.fileSn }`, `${list.repoCd }`)"><i class="ion-android-download"></i> </button>
							<script>
								byteConvertor("${list.fileSize}", "${list.fileNm}", "${list.fileSn}");
							</script>
						</c:forEach>
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
        <div class="modal-dialog modal-extra-lg" role="document">
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
