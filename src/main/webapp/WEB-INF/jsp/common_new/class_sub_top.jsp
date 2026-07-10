<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="java.util.List"%>
<%@page import="knou.framework.context2.UserContext"%>
<%@page import="knou.framework.common.ParamInfo"%>
<%@page import="knou.framework.common.SubjectInfo"%>
<%@page import="knou.framework.common.SessionInfo"%>
<%@page import="knou.lms.org.vo.OrgVO"%>
<%@page import="knou.lms.crs.semester.vo.SmstrChrtVO"%>
<%@page import="knou.lms.subject.vo.SubjectVO"%>
<%@include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%
String authrtGrpcd = SessionInfo.getAuthrtGrpcd(request);
String orgId = ParamInfo.getParamValue(request, "orgId");
String sbjctId = ParamInfo.getParamValue(request, "sbjctId");

System.out.println("### [JSP Debug] orgId: " + orgId + ", sbjctId: " + sbjctId);

// 기관목록
List<OrgVO> classOrgList = SubjectInfo.getSubjectOrgList(request);
pageContext.setAttribute("classOrgList", classOrgList);

// 학기목록
List<SmstrChrtVO> classSemesterList = SubjectInfo.getSubjectSemesterList(request, orgId);
pageContext.setAttribute("classSemesterList", classSemesterList);

// 과목목록
List<SubjectVO> classSubjectList = SubjectInfo.getSubjectListBySbjctId(request, orgId, sbjctId);
pageContext.setAttribute("classSubjectList", classSubjectList);

SubjectVO subjectVO = SubjectInfo.getSubjectInfo(request, sbjctId);
if (subjectVO != null) {
	pageContext.setAttribute("classSmstrChrtId", subjectVO.getSmstrChrtId());
}
%>
<div class="class_sub_top">
	<div class="btn-wrap">
		<div class="first">
			<%-- 기관 --%>
			<select id="classOrgList" class="form-select" onchange="changeClassOrg(this);return false;">
				<c:if test="${not empty classOrgList}">
					<c:forEach items="${classOrgList}" var="org" varStatus="status">
						<option value="${org.orgId}" <c:if test="${org.orgId eq uiex:getParamValue('orgId')}">selected</c:if>>${org.orgnm}</option>
					</c:forEach>
				</c:if>
			</select>

			<%-- 학기 --%>
			<select id="classSemesterList" class="form-select" onchange="changeClassSemester(this);return false;">
				<c:if test="${not empty classSemesterList}">
					<c:forEach items="${classSemesterList}" var="semester" varStatus="status">
						<option value="${semester.smstrChrtId}" <c:if test="${semester.smstrChrtId eq classSmstrChrtId}">selected</c:if>>${semester.smstrChrtnm}</option>
					</c:forEach>
				</c:if>
				<c:if test="${empty classSemesterList}">
					<option value="">학기/기수</option>
				</c:if>
			</select>

			<%-- 과목 --%>
			<select id="classSubjectList" class="form-select wide" onchange="changeClassSubject(this)">
				<option value="">과목선택</option>
				<c:if test="${not empty classSubjectList}">
					<c:forEach items="${classSubjectList}" var="subject" varStatus="status">
						<option value="${subject.sbjctId}" <c:if test="${subject.sbjctId eq uiex:getParamValue('sbjctId')}">selected</c:if>>${subject.sbjctnm}-${empty subject.dvclasNcknm ? subject.dvclasNo : subject.dvclasNcknm}</option>
					</c:forEach>
				</c:if>
			</select>

			<script type="text/javascript">
				// 과목 기관 선택
				function changeClassOrg(obj) {
					let orgId = $(obj).val();
					$("#classSemesterList").empty();
					$("#classSemesterList").trigger("chosen:updated");
					$("#classSubjectList").find("option:not(:first)").remove();
					$("#classSubjectList").trigger("chosen:updated");

					callClassSemesterList(orgId);
				}

				// 과목 학기 선택
				function changeClassSemester(obj) {
					$("#classSubjectList").find("option:not(:first)").remove();
					$("#classSubjectList").trigger("chosen:updated");
					let orgId = $("#classOrgList").val();
					let smstrChrtId = $(obj).val();

					if (smstrChrtId != "") {
						callClassSubjectList(orgId, smstrChrtId);
					}
				}

				// 과목 선택
				function changeClassSubject(obj) {
					let orgId = $("#classOrgList").val();
					let smstrChrtId = $("#classSemesterList").val();
					let sbjctId = $(obj).val();

					if (sbjctId != "") {
						// 과목이동
						document.location.href = "/subject/subject.do?sbjctId="+sbjctId+"&orgId="+orgId;
					}
				}

				// 과목 학기 가져오기
				function callClassSemesterList(orgId) {
					const url = "/subject/classSemesterListAjax.do";
			        const param = {
			            orgId: orgId
			        };

			        ajaxCall(url, param, function (data) {
			            if (data.result > 0) {
			                let semesterList = data.returnList || [];
			                let smstrChrtId = null;

			                semesterList.forEach((semester, index) => {
								if (index === 0) {
									smstrChrtId = semester.smstrChrtId;
								}
			                	$("#classSemesterList").append(new Option(semester.smstrChrtnm, semester.smstrChrtId));
			                });

			                if (semesterList.length == 0) {
			                	$("#classSemesterList").append(new Option("학기/기수", ""));
			                }

			                $("#classSemesterList").val(smstrChrtId);
			                $("#classSemesterList").trigger("chosen:updated");

			                if (smstrChrtId != null) {
			                	$("#classSubjectList").find("option:not(:first)").remove();
								$("#classSubjectList").trigger("chosen:updated");

								// 과목목록 가져오기
			                	callClassSubjectList(orgId, smstrChrtId);
			                }
			            } else {
			                UiComm.showMessage(data.message, "error");
			            }
			        }, function (xhr, status, error) {
			            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
			        }, true);
				}

				// 과목목록 가져오기
				function callClassSubjectList(orgId, smstrChrtId) {
					const url = "/subject/classSubjectListAjax.do";
			        const param = {
			            orgId: orgId,
			            smstrChrtId: smstrChrtId
			        };

			        ajaxCall(url, param, function (data) {
			            if (data.result > 0) {
			                let subjectList = data.returnList || [];
			                let smstrChrtId = null;

			                subjectList.forEach((subject, index) => {
								$("#classSubjectList").append(new Option(subject.sbjctnm, subject.sbjctId));
			                });

			                $("#classSubjectList").trigger("chosen:updated");

			            } else {
			                UiComm.showMessage(data.message, "error");
			            }
			        }, function (xhr, status, error) {
			            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
			        }, true);
				}
			</script>
		</div>
		<div class="sec">
			<c:choose>
				<c:when test="${not empty uiex:getSubjectAuth() and uiex:getSubjectAuth() eq 'PROF'}">
					<button type="button" class="btn type1"><i class="xi-book-o"></i>교수 매뉴얼</button>
					<button type="button" class="btn type2" onclick="document.location.href='/dashboard/profDashboard.do';"><i class="xi-log-out"></i>강의실나가기</button>
				</c:when>
				<c:when test="${not empty uiex:getSubjectAuth() and uiex:getSubjectAuth() eq 'STDNT'}">
					<button type="button" class="btn type1"><i class="xi-info-o"></i>학습안내정보</button>
					<button type="button" class="btn type2" onclick="document.location.href='/dashboard/stuDashboard.do';"><i class="xi-log-out"></i>강의실나가기</button>
				</c:when>
				<c:otherwise>
					<button type="button" class="btn type2" onclick="document.location.href='/';"><i class="xi-log-out"></i>강의실나가기</button>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
</div>
