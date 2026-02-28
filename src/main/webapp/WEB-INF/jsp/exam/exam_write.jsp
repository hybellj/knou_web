<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
	<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
	
	<script type="text/javascript">
		var DECLS_LIST = [];
		var editor;
		
		$(document).ready(function () {
			if(${not empty vo.examCd}) {
				insStdList();
			}
			
			getDeclsList();
		});
		
		// 분반 정보 조회
		function getDeclsList() {
			var url = '/asmtProfDvclasList.do';
			var param = {
				crsCreCd: "${vo.crsCreCd}"
			};
			
			ajaxCall("/asmtprofDvclasList.do", param, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					
					DECLS_LIST = returnList;
					
					examTypeChk();
				}
			}, function(xhr, status, error) {

			}, true);
		}
		
		// 시험 유형 체크
		function examTypeChk() {
			var type = $("input[name=examTypeCd]:checked").val();
			if(type != undefined) {
				insWriteForm(type);
				$("#insWriteDiv").show();
			}
		}
		
		// 대체과제 등록 폼
		function insWriteForm(type) {
			var path  = "";
			var ctsId = "insCts";
			var insTypeCd = "${vo.examTypeCd}" == "EXAM" ? "SUBS" : "EXAM";
			var html  = "<input type='hidden' name='insTypeCd' value='"+insTypeCd+"' />";
			if(type == "QUIZ") {
				path = "/quiz";
				html += "<input type='hidden' name='repoCd' value='EXAM_CD' />";
				html += "<div class='ui form'>";
				html += "	<div class='ui '>";
				html += "		<ul class='tbl border-top-grey'>";
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt><label for='insTitle' class='req'><spring:message code='exam.label.quiz' /><spring:message code='exam.label.nm' /></label></dt>";/* 퀴즈 *//* 명 */
				html += "					<dd>";
				html += "						<div class='ui fluid input'>";
				html += "							<input type='text' name='insTitle' id='insTitle' value='${quizVO.examTitle }'>";
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt><label for='"+ctsId+"' class='req'><spring:message code='exam.label.quiz' /> <spring:message code='exam.label.cts' /></label></dt>";/* 퀴즈 *//* 내용 */
				html += "					<dd style='height:400px'>";
				html += "						<div style='height:100%'>";
				html += `							<textarea name='insCts' id='\${ctsId}'>${quizVO.examCts }</textarea>`;
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt><label for='insStartFmt' class='req'><spring:message code='exam.label.quiz' /> <spring:message code='exam.label.period' /> </label></dt>";/* 퀴즈 *//* 기간 */
				html += "					<dd>";
				html += "						<div class='fields gap4'>";
				html += "							<div class='field flex'>";
				html += `								<uiex:ui-calendar dateId="insStartFmt" hourId="insStartHH" minId="insStartMM" rangeType="start" rangeTarget="insEndFmt" value="${quizVO.examStartDttm}"/>`;
				html += "							</div>";
				html += "							<div class='field p0 flex-item desktop-elem'>~</div>";
				html += "							<div class='field flex'>";
				html += `								<uiex:ui-calendar dateId="insEndFmt" hourId="insEndHH" minId="insEndMM" rangeType="end" rangeTarget="insStartFmt" value="${quizVO.examEndDttm}"/>`;
				html += "							</div>";
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt><label for='examStareTm' class='req'><spring:message code='exam.label.quiz' /> <spring:message code='exam.label.time' /></label></dt>";/* 퀴즈 *//* 시간 */
				html += "					<dd>";
				html += "						<div class='fields'>";
				html += "							<div class='field'>";
				html += "								<div class='ui input num'>";
				html += "									<input type='text' name='examStareTm' id='examStareTm' class='w50' value='${quizVO.examStareTm }'>";
				html += "								</div>";
				html += "								<spring:message code='exam.label.stare.min' />";/* 분 */
				html += "							</div>";
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt class='req'><spring:message code='exam.label.score.aply.y' /></dt>";/* 성적반영 */
				html += "					<dd>";
				html += "						<div class='fields'>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' id='scoreAplyY' name='insScoreAplyYn' value='Y' tabindex='0' class='hidden' ${empty quizVO || quizVO.scoreAplyYn eq 'Y' ? 'checked' : '' }>";
				html += "									<label for='scoreAplyY'><spring:message code='exam.common.yes' /></label>";/* 예 */
				html += "								</div>";
				html += "							</div>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' id='scoreAplyN' name='insScoreAplyYn' value='N' tabindex='0' class='hidden' ${quizVO.scoreAplyYn eq 'N' ? 'checked' : '' }>";
				html += "									<label for='scoreAplyN'><spring:message code='exam.common.no' /></label>";/* 아니오 */
				html += "								</div>";
				html += "							</div>";
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt class='req'><spring:message code='exam.label.score.open.y' /></dt>";/* 성적공개 */
				html += "					<dd>";
				html += "						<div class='fields'>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' id='scoreOpenY' name='insScoreOpenYn' value='Y' tabindex='0' class='hidden' ${empty quizVO || quizVO.scoreOpenYn eq 'Y' ? 'checked' : '' }>";
				html += "									<label for='scoreOpenY'><spring:message code='exam.common.yes' /></label>";/* 예 */
				html += "								</div>";
				html += "							</div>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' id='scoreOpenN' name='insScoreOpenYn' value='N' tabindex='0' class='hidden' ${quizVO.scoreOpenYn eq 'N' ? 'checked' : '' }>";
				html += "									<label for='scoreOpenN'><spring:message code='exam.common.no' /></label>";/* 아니오 */
				html += "								</div>";
				html += "							</div>";
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt class='req'><spring:message code='exam.label.paper.open' /></dt>";/* 시험지 공개 */
				html += "					<dd>";
				html += "						<div class='fields'>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' id='gradeViewY' name='gradeViewYn' value='Y' tabindex='0' class='hidden' ${empty quizVO || quizVO.gradeViewYn eq 'Y' ? 'checked' : '' }>";
				html += "									<label for='gradeViewY'><spring:message code='exam.common.yes' /></label>";/* 예 */
				html += "								</div>";
				html += "							</div>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' id='gradeViewN' name='gradeViewYn' value='N' tabindex='0' class='hidden' ${quizVO.gradeViewYn eq 'N' ? 'checked' : '' }>";
				html += "									<label for='gradeViewN'><spring:message code='exam.common.no' /></label>";/* 아니오 */
				html += "								</div>";
				html += "							</div>";
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt><label class='req'><spring:message code='exam.label.view.qstn.type' /></label></dt>";/* 문제표시방식 */
				html += "					<dd>";
				html += "						<div class='fields'>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' id='allViewQstn' name='viewQstnTypeCd' value='ALL' tabindex='0' class='hidden' ${quizVO.viewQstnTypeCd eq 'ALL' || empty quizVO ? 'checked' : '' }>";
				html += "									<label for='allViewQstn'><spring:message code='exam.label.all.view.qstn' /></label>";/* 전체문제 표시 */
				html += "								</div>";
				html += "							</div>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' id='eachViewQstn' name='viewQstnTypeCd' value='EACH' tabindex='0' class='hidden' ${quizVO.viewQstnTypeCd eq 'EACH' ? 'checked' : '' }>";
				html += "									<label for='eachViewQstn'><spring:message code='exam.label.each.view.qstn' /></label>";/* 페이지별로 1문제씩 표시 */
				html += "								</div>";
				html += "							</div>";
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt><label for='teamLabel'><spring:message code='exam.label.empl.random' /></label></dt>";/* 보기 섞기 */
				html += "					<dd>";
				html += "						<div class='fields'>";
				html += "							<div class='inline field'>";
				html += "								<div class='ui toggle checkbox'>";
				html += "									<input type='checkbox' name='emplRandomYnChk' id='emplRandomYnChk' ${quizVO.emplRandomYn eq 'Y' || empty quizVO ? 'checked' : '' }>";
				html += "									<label for='emplRandomYnChk'></label>";
				html += "								</div>";
				html += "							</div>";
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				var reExamYn = "${quizVO.reExamYn}" || "Y";
				html += '			<li>';
				html += '				<dl>';
				html += '					<dt><label><spring:message code="exam.tab.reexam.manage" /></label></dt><!-- 미응시 관리 -->';
				html += '					<dd>';
				html += '						<div class="fields">';
				html += '							<div class="field flex-item">';
				html += '								<div class="ui radio checkbox">';
				html += '									<input type="radio" id="reExamYnY" name="reExamYnCheck" value="Y" tabindex="0" class="hidden" ' + (reExamYn == "Y" ? 'checked' : '') + ' />';
				html += '									<label for="reExamYnY"><spring:message code="exam.common.yes" /></label><!-- 예 -->';
				html += '								</div>';
				html += '							</div>';
				html += '							<div class="field flex-item">';
				html += '								<div class="ui radio checkbox">';
				html += '									<input type="radio" id="reExamYnN" name="reExamYnCheck" value="N" tabindex="0" class="hidden" ' + (reExamYn == "N" ? 'checked' : '') + ' />';
				html += '									<label for="reExamYnN"><spring:message code="exam.common.no" /></label><!-- 아니오 -->';
				html += '								</div>';
				html += '							</div>';
				html += '						</div>';
				html += '						<div class="ui message info p10"><spring:message code="exam.label.re.exam.info" /></div>';
				html += '					</dd>';
				html += '				</dl>';
				html += '			</li>';
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt><label for='contentTextArea'><spring:message code='exam.label.file' /></label></dt>";/* 첨부파일 */
				html += "					<dd>";
				html += "						<div id='fileUploader-container' class='dext5-container' style='width:100%;height:180px;'></div>";
				html += "						<div id='fileUploader-btn-area' class='dext5-btn-area' style=''>";
				html += "						<button type='button' id='fileUploader_btn-add' style='' title='<spring:message code='button.select.file'/>'><spring:message code='button.select.file'/></button>";
				html += "						<button type='button' id='fileUploader_btn-filebox' style='' title='<spring:message code='button.from_filebox'/>'><spring:message code='button.from_filebox'/></button>";
				html += "						<button type='button' id='fileUploader_btn-delete' disabled='true' style='' title='<spring:message code='button.delete'/>'><spring:message code='button.delete'/></button>";
				html += "						<button type='button' id='fileUploader_btn-reset' style='display:none' title='<spring:message code='button.reset'/>' onclick=\"resetDextFiles('fileUploader')\"><i class='ion-refresh'></i></button>";
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				html += "		</ul>";
				html += "	</div>";
				html += "</div>";
			} else if(type == "ASMNT") {
				path = "/asmt";
				html += "<input type='hidden' name='repoCd'			value='ASMNT' />";
				//html += "<input type='hidden' name='teamAsmntCfgYn' value='N' />";
				html += "<input type='hidden' name='indYn'	  	    value='N' />";
				html += "<input type='hidden' name='sbmtOpenYn'     value='N' />";
				html += "<input type='hidden' name='sbmtFileType'   />";
				html += "<input type='hidden' name='evalUseYn'	    value='N' />";
				html += "<input type='hidden' name='gradeViewYn'	value='${vo.gradeViewYn}' />";
				html += "<div class='ui form'>";
				html += "	<div class='ui '>";
				html += "		<ul class='tbl border-top-grey'>";
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt><label for='insTitle' class='req'><spring:message code='asmnt.label.asmnt.title' /></label></dt>";	// 과제명
				html += "					<dd>";
				html += "						<div class='ui fluid input'>";
				html += "							<input type='text' id='insTitle' name='insTitle' value='${asmtVO.asmntTitle}'>";
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt><label for='"+ctsId+"' class='req'><spring:message code='asmnt.label.asmnt.content' /></label></dt>";	// 과제내용
				html += "					<dd style='height:400px'>";
				html += "						<div style='height:100%'>";
				html += `							<textarea name='insCts' id='\${ctsId}'>${asmtVO.asmntCts }</textarea>`;
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt><label for='insStartFmt' class='req'><spring:message code='asmnt.label.send.date' /> </label></dt>";	// 제출기간
				html += "					<dd>";
				html += "						<div class='fields gap4'>";
				html += "							<div class='field flex'>";
				html += `								<uiex:ui-calendar dateId='insStartFmt' hourId='insStartHH' minId='insStartMM' rangeType='start' rangeTarget='insEndFmt' value='${asmtVO.sendStartDttm}'/>`;
				html += "							</div>";
				html += "							<div class='field p0 flex-item desktop-elem'>~</div>";
				html += "							<div class='field flex'>";
				html += `								<uiex:ui-calendar dateId='insEndFmt' hourId='insEndHH' minId='insEndMM' rangeType='end' rangeTarget='insStartFmt' value='${asmtVO.sendEndDttm}'/>`;
				html += "							</div>";
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt><label class='req'><spring:message code='forum.label.scoreAply' /></label></dt>";	// 성적반영
				html += "					<dd>";
				html += "						<div class='fields'>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' id='scoreAplyY' name='insScoreAplyYn' tabindex='0' class='hidden' value='Y' ${empty asmtVO || asmtVO.scoreAplyYn eq 'Y' ? 'checked' : ''} />";
				html += "									<label for='scoreAplyY'><spring:message code='exam.common.yes' /></label>";
				html += "								</div>";
				html += "							</div>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' id='scoreAplyN' name='insScoreAplyYn' tabindex='0' class='hidden' value='N' ${asmtVO.scoreAplyYn eq 'N' ? 'checked' : ''} />";
				html += "									<label for='scoreAplyN'><spring:message code='asmnt.common.no'/></label>";
				html += "								</div>";
				html += "							</div>";
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				/*html += "			<li>";
				html += "				<dl>";
				html += "					<dt><label class='req'><spring:message code='resh.label.score.open' /></label></dt>"; // 성적공개
				html += "					<dd>";
				html += "						<div class='fields'>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' id='scoreOpenY' name='insScoreOpenYn' tabindex='0' class='hidden' value='Y' ${empty asmtVO || asmtVO.scoreOpenYn eq 'Y' ? 'checked' : ''} />";
				html += "									<label for='scoreOpenY'><spring:message code='exam.common.yes' /></label>";
				html += "								</div>";
				html += "							</div>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' id='scoreOpenN' name='insScoreOpenYn' tabindex='0' class='hidden' value='N' ${asmtVO.scoreOpenYn eq 'N' ? 'checked' : ''} />";
				html += "									<label for='scoreOpenN'><spring:message code='asmnt.common.no'/></label>";
				html += "								</div>";
				html += "							</div>";
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";*/
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt><label><spring:message code='forum.label.periodAfterWrite' /></label></dt>";	// 지각 제출 사용
				html += "					<dd>";
				html += "						<div class='fields'>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' name='extSendAcptYn' id='extSendAcptY' onchange='extDivView()' value='Y' tabindex='0' class='hidden' ${asmtVO.extSendAcptYn eq 'Y' ? 'checked' : ''}>";
				html += "									<label for='extSendAcptY'><spring:message code='exam.common.yes' /></label>";
				html += "								</div>";
				html += "							</div>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' name='extSendAcptYn' id='extSendAcptN' onchange='extDivView()' value='N' tabindex='0' class='hidden' ${empty asmtVO || asmtVO.extSendAcptYn eq 'N' ? 'checked' : ''}>";
				html += "									<label for='extSendAcptN'><spring:message code='asmnt.common.no'/></label>";
				html += "								</div>";
				html += "							</div>";
				html += "						</div>";
				html += "						<div class='ui segment bcLgrey9' id='periodAfterDiv' ${empty asmtVO || asmtVO.extSendAcptYn eq 'N' ? 'style=\'display:none;\'' : '' }>";
				html += "							<div class='fields'>";
				html += "								<div class='inline field'>";
				html += "									<label for='extSendFmt'><spring:message code='forum.label.extEndDttm' /></label>";	// 제출 마감일
				html += "									<div class='fields gap4 pl20'>";
				html += `										<uiex:ui-calendar dateId='extSendFmt' hourId='calExtSendHH' minId='calExtSendMM' rangeType='end' value='${asmtVO.extSendDttm}'/>`;
				html += "									</div>";
				html += "								</div>";
				html += "							</div>";
				html += "						</div>";
				html += "						<div class='ui small warning message'><i class='info icon'></i><spring:message code='asmnt.label.ext.send.info' /></div>";/* 제출기간 이후 지각 제출 허용시 설정 */
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt><label class='req'><spring:message code='resh.label.eval.ctgr' /></label></dt>";	// 평가 방법
				html += "					<dd>";
				html += "						<div class='fields'>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' id='evalCtgrP' name='evalCtgr' onchange='mutDivView()' value='P' tabindex='0' class='hidden' ${empty asmtVO || asmtVO.evalCtgr eq 'P' ? 'checked' : ''}>";
				html += "									<label for='evalCtgrP'><spring:message code='asmnt.label.point.type' /></label>";
				html += "								</div>";
				html += "							</div>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' id='evalCtgrR' name='evalCtgr' onchange='mutDivView()' value='R' tabindex='0' class='hidden' ${asmtVO.evalCtgr eq 'R' ? 'checked' : ''}>";
				html += "									<label for='evalCtgrR'><spring:message code='crs.label.rubric' /></label>";
				html += "								</div>";
				html += "							</div>";
				html += "							<div class='field' id='mutEvalDiv' ${empty asmtVO || asmtVO.evalCtgr eq 'P' ? 'style=\'display:none;\'' : ''}>";
				html += "								<div class='ui action input search-box mr5'>";
				html += "									<input type='hidden' name='evalCd' id='evalCd' value='${asmtVO.evalCd}'/>";
				html += "									<input type='text' name='evalTitle' id='evalTitle' value='${asmtVO.evalTitle}'>";
				html += "									<button type='button' class='ui icon button' onclick='mutEvalWritePop(\"new\");'><i class='pencil alternate icon'></i></button>";
				html += "									<button type='button' class='ui icon button' onclick='mutEvalWritePop(\"edit\");'><i class='edit icon'></i></button>";
				html += "									<button type='button' class='ui icon button' onclick='deleteMut();'><i class='trash icon'></i></button>";
				html += "								</div>";
				html += "							</div>";
				html += "						</div>";
				html += "						<div class='ui small warning message'><i class='info icon'></i><spring:message code='forum.label.evalctgr.rubric.info' /></div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt><label class='req'><spring:message code='asmnt.label.practice.asmnt' /></label></dt>";	// 실기과제
				html += "					<dd>";
				html += "						<div class='fields'>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' id='prtcY' name='prtcYn' onchange='prtcDivView()' value='Y' tabindex='0' class='hidden' ${asmtVO.prtcYn eq 'Y' ? 'checked' : ''}>";
				html += "									<label for='prtcY'><spring:message code='exam.common.yes' /></label>";
				html += "								</div>";
				html += "							</div>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' id='prtcN' name='prtcYn' onchange='prtcDivView()' value='N' tabindex='0' class='hidden' ${empty asmtVO || asmtVO.prtcYn eq 'N' ? 'checked' : ''}>";
				html += "									<label for='prtcN'><spring:message code='asmnt.common.no'/></label>";
				html += "								</div>";
				html += "							</div>";
				html += "						</div>";
				html += "						<div class='ui segment bcLgrey9' id='viewPrtc' ${empty asmtVO || asmtVO.prtcYn eq 'N' ? 'style=\'display:none;\'' : ''}>";
				html += "							<div class='fields'>";
				html += "								<div class='field'>";
				html += "									<div class='ui'>";
				html += "										<label for='fileType'><spring:message code='button.manage.file.type' /> : </label>";
				html += "									</div>";
				html += "								</div>";
				html += "								<div class='field'>";
				html += "									<div class='ui checkbox'>";
				html += "										<input type='checkbox' id='fileType01' name='prtcFileType' value='img'>";
				html += "										<label class='toggle_btn' for='fileType01'><spring:message code='common.label.image' /> (JPG, GIF, PNG)</label>";
				html += "									</div>";
				html += "								</div>";
				html += "								<div class='field'>";
				html += "									<div class='ui checkbox'>";
				html += "										<input type='checkbox' id='fileType02' name='prtcFileType' value='pdf'>";
				html += "										<label class='toggle_btn' for='fileType02'>PDF</label>";
				html += "									</div>";
				html += "								</div>";
				html += "								<div class='field'>";
				html += "									<div class='ui checkbox'>";
				html += "										<input type='checkbox' id='fileType03' name='prtcFileType' value='ppt'>";
				html += "										<label class='toggle_btn' for='fileType03'>PPT(X)</label>";
				html += "									</div>";
				html += "								</div>";
				html += "							</div>";
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				html += "			<li id='viewSendType' ${asmtVO.prtcYn eq 'Y' ? 'style=\'display:none;\'' : ''}>";
				html += "				<dl>";
				html += "					<dt><label class='req'><spring:message code='button.manage.send' /></label></dt>";	// 제출 형식
				html += "					<dd>";
				html += "						<div class='fields'>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' id='sendTypeF' tabindex='0' class='hidden' onchange='sendDivView()' name='sendType' value='F' ${empty asmtVO || asmtVO.sendType eq 'F' ? 'checked' : ''}>";
				html += "									<label for='sendTypeF'><spring:message code='common.file' /></label>";
				html += "								</div>";
				html += "							</div>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' id='sendTypeT' tabindex='0' class='hidden' onchange='sendDivView()' name='sendType' value='T' ${asmtVO.sendType eq 'T' ? 'checked' : ''}>";
				html += "									<label for='sendTypeT'><spring:message code='lesson.label.text' />(TEXT)</label>";
				html += "								</div>";
				html += "							</div>";
				html += "						</div>";
				html += "						<div class='ui segment bcLgrey9' id='viewSendTypeFile' ${asmtVO.sendType eq 'T' ? 'style=\'display:none;\'' : ''}>";
				html += "							<div class='fields'>";
				html += "								<div class='field'>";
				html += "									<div class='ui radio checkbox'>";
				html += "										<input type='radio' id='allFile' onchange='sendFileChk()' name='sendFileType' value='all' class='hidden' checked>";
				html += "										<label for='allFile'><spring:message code='asmnt.label.total.file' /></label>";
				html += "									</div>";
				html += "								</div>";
				html += "							</div>";
				html += "							<div class='fields'>";
				html += "								<div class='field'>";
				html += "									<div class='ui radio checkbox'>";
				html += "										<input type='radio' id='preFile' onchange='sendFileChk()' name='sendFileType' value='pre' class='hidden'>";
				html += "										<label for='preFile'><spring:message code='resh.label.preview' /><spring:message code='common.label.possibility' /> : </label>";
				html += "									</div>";
				html += "								</div>";
				html += "								<div class='field'>";
				html += "									<div class='ui checkbox'>";
				html += "										<input type='checkbox' id='preFile01' onchange='fileChk(\"pre\")' name='preFile' value='img'>";
				html += "										<label class='toggle_btn' for='preFile01'><spring:message code='lesson.label.img' /> (JPG, GIF, PNG)</label>";
				html += "									</div>";
				html += "								</div>";
				html += "								<div class='field'>";
				html += "									<div class='ui checkbox'>";
				html += "										<input type='checkbox' id='preFile02' onchange='fileChk(\"pre\")' name='preFile' value='pdf'>";
				html += "										<label class='toggle_btn' for='preFile02'>PDF</label>";
				html += "									</div>";
				html += "								</div>";
				//html += "								<div class='field'>";
				//html += "									<div class='ui checkbox'>";
				//html += "										<input type='checkbox' id='preFile03' onchange='fileChk(\"pre\")' name='preFile' value='txt'>";
				//html += "										<label class='toggle_btn' for='preFile03'>TEXT</label>";
				//html += "									</div>";
				//html += "								</div>";
				html += "								<div class='field'>";
				html += "									<div class='ui checkbox'>";
				html += "										<input type='checkbox' id='preFile04' onchange='fileChk(\"pre\")' name='preFile' value='soc'>";
				html += "										<label class='toggle_btn' for='preFile04'><spring:message code='common.label.program.source' />(.txt)</label>";
				html += "									</div>";
				html += "								</div>";
				//html += "								<div class='field'>";
				//html += "									<div class='ui checkbox'>";
				//html += "										<input type='checkbox' id='preFile05' onchange='fileChk(\"pre\")' name='preFile' value='ppt2'>";
				//html += "										<label class='toggle_btn' for='preFile05'>PPT(X)</label>";
				//html += "									</div>";
				//html += "								</div>";
				html += "							</div>";
				html += "							<div class='fields'>";
				html += "								<div class='field'>";
				html += "									<div class='ui radio checkbox'>";
				html += "										<input type='radio' id='docFile' onchange='sendFileChk()' name='sendFileType' value='doc' class='hidden'>";
				html += "										<label for='docFile'><spring:message code='common.label.type.doc' /> : </label>";
				html += "									</div>";
				html += "								</div>";
				html += "								<div class='field'>";
				html += "									<div class='ui checkbox'>";
				html += "										<input type='checkbox' id='docFile01' onchange='fileChk(\"doc\")' name='docFile' value='hwp'>";
				html += "										<label class='toggle_btn' for='docFile01'>HWP(X)</label>";
				html += "									</div>";
				html += "								</div>";
				html += "								<div class='field'>";
				html += "									<div class='ui checkbox'>";
				html += "										<input type='checkbox' id='docFile02' onchange='fileChk(\"doc\")' name='docFile' value='doc'>";
				html += "										<label class='toggle_btn' for='docFile02'>DOC(X)</label>";
				html += "									</div>";
				html += "								</div>";
				html += "								<div class='field'>";
				html += "									<div class='ui checkbox'>";
				html += "										 <input type='checkbox' id='docFile03' onchange='fileChk(\"doc\")' name='docFile' value='ppt'>";
				html += "										<label class='toggle_btn' for='docFile03'>PPT(X)</label>";
				html += "									</div>";
				html += "								</div>";
				html += "								<div class='field'>";
				html += "									<div class='ui checkbox'>";
				html += "										<input type='checkbox' id='docFile04' onchange='fileChk(\"doc\")' name='docFile' value='xls'>";
				html += "										<label class='toggle_btn' for='docFile04'>XLS(X)</label>";
				html += "									</div>";
				html += "								</div>";
				html += "								<div class='field'>";
				html += "									<div class='ui checkbox'>";
				html += "										<input type='checkbox' id='docFile05' onchange='fileChk(\"doc\")' name='docFile' value='pdf2'>";
				html += "										<label class='toggle_btn' for='docFile05'>PDF</label>";
				html += "									</div>";
				html += "								</div>";
				html += "								<div class='field'>";
				html += "									<div class='ui checkbox'>";
				html += "										<input type='checkbox' id='docFile06' onchange='fileChk(\"zip\")' name='docFile' value='zip'>";
				html += "										<label class='toggle_btn' for='docFile06'>ZIP</label>";
				html += "									</div>";
				html += "								</div>";
				html += "							</div>";
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt><label for='contentTextArea'><spring:message code='asmnt.label.file.upload' /></label></dt>";	// 파일 업로드
				html += "					<dd>";
				html += "						<div id='fileUploader-container' class='dext5-container' style='width:100%;height:180px;'></div>";
				html += "						<div id='fileUploader-btn-area' class='dext5-btn-area' style=''>";
				html += "						<button type='button' id='fileUploader_btn-add' style='' title='<spring:message code='button.select.file'/>'><spring:message code='button.select.file'/></button>";
				html += "						<button type='button' id='fileUploader_btn-filebox' style='' title='<spring:message code='button.from_filebox'/>'><spring:message code='button.from_filebox'/></button>";
				html += "						<button type='button' id='fileUploader_btn-delete' disabled='true' style='' title='<spring:message code='button.delete'/>'><spring:message code='button.delete'/></button>";
				html += "						<button type='button' id='fileUploader_btn-reset' style='display:none' title='<spring:message code='button.reset'/>' onclick=\"resetDextFiles('fileUploader')\"><i class='ion-refresh'></i></button>";
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				html += "		</ul>";
				html += "	</div>";
				html += '	<div class="ui styled fluid accordion week_lect_list">';
				html += '		<div class="title active">';
				html += '			<div class="title_cont">';
				html += '				<div class="left_cont">';
				html += '					<div class="lectTit_box">';
				html += '						<p class="lect_name"><spring:message code="resh.label.added.features" /></p>'; // 추가기능
				html += '					</div>';
				html += '				</div>';
				html += '			</div>';
				html += '			<i class="dropdown icon ml20"></i>';
				html += '		</div>';
				html += '		<div class="content p0 active">';
				html += '			<div class="ui segment">';
				html += '				<ul class="tbl border-top-grey">';
				html += '					<li>';
				html += '						<dl>';
				html += '							<dt><label for="teamLabel"><spring:message code="asmnt.label.team.asmnt" /><!-- 팀과제 --></label></dt>';
				html += '							<dd>';
				html += '								<div class="fields">';
				html += '									<div class="field">';
				html += '										<div class="ui radio checkbox">';
				html += '											<input type="radio" id="teamY" tabindex="0" class="hidden" name="teamAsmntCfgYn" value="Y" />';
				html += '											<label for="teamY"><spring:message code="message.yes"/></label><!-- 예 -->';
				html += '										</div>';
				html += '									</div>';
				html += '									<div class="field">';
				html += '										<div class="ui radio checkbox">';
				html += '											<input type="radio" id="teamN" tabindex="0" class="hidden" name="teamAsmntCfgYn" value="N" checked />';
				html += '											<label for="teamN"><spring:message code="message.no"/></label><!-- 아니오 -->';
				html += '										</div>';
				html += '									</div>';
				html += '								</div>';
				html += '								<div class="ui segment bcLgrey9" id="viewTeam" style="display:none"></div>';
				html += '							</dd>';
				html += '						</dl>';
				html += '					</li>';
				html += '				</ul>';
				html += '			</div>';
				html += '		</div>';
				html += '	</div>';
				html += "</div>";
			} else if(type == "FORUM") {
				path = "/forum";
				html += "<input type='hidden' name='repoCd'			    value='FORUM' />";
				html += "<input type='hidden' name='prosConsForumCfg'   value='${forumVO.prosConsForumCfg eq 'N' || empty forumVO.prosConsForumCfg ? 'N' : 'Y'}' />";
				html += "<input type='hidden' name='multiAtclYn'		value='N' />";
				html += "<input type='hidden' name='teamForumCfgYn'	    value='N' id='teamForumCfgYn' />";
				html += "<input type='hidden' name='teamCtgrCd'		    value='' id='teamCtgrCd' />";
				html += "<input type='hidden' name='gradeViewYn'		value='${vo.gradeViewYn}' />";
				html += "<input type='hidden' name='evalStartDttm'		value='${forumVO.evalStartDttm}' />";
				html += "<input type='hidden' name='evalEndDttm'		value='${forumVO.evalEndDttm}' />";
				html += "<div class='ui form'>";
				html += "	<div class='ui '>";
				html += "		<ul class='tbl border-top-grey'>";
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt><label for='insTitle' class='req'><spring:message code='forum.label.forum.title' /></label></dt>";
				html += "					<dd>";
				html += "						<div class='ui fluid input'>";
				html += "							<input type='text' name='insTitle' id='insTitle' value='${forumVO.forumTitle }'>";
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt><label for='"+ctsId+"' class='req'><spring:message code='forum.label.forum.content' /></label></dt>";
				html += "					<dd style='height:400px'>";
				html += "						<div style='height:100%'>";
				html += `							<textarea name='insCts' id='\${ctsId}'>${forumVO.forumArtl }</textarea>`;
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt><label for='insStartFmt' class='req'><spring:message code='forum.label.forum.date' /> </label></dt>";
				html += "					<dd>";
				html += "						<div class='fields gap4'>";
				html += "							<div class='field flex'>";
				html += `								<uiex:ui-calendar dateId='insStartFmt' hourId='insStartHH' minId='insStartMM' rangeType='start' rangeTarget='insEndFmt' value='${forumVO.forumStartDttm}'/>`;
				html += "							</div>";
				html += "							<div class='field p0 flex-item desktop-elem'>~</div>";
				html += "							<div class='field flex'>";
				html += `								<uiex:ui-calendar dateId='insEndFmt' hourId='insEndHH' minId='insEndMM' rangeType='end' rangeTarget='insStartFmt' value='${forumVO.forumEndDttm}'/>`;
				html += "							</div>";
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt><label class='req'>성적 반영</label></dt>";
				html += "					<dd>";
				html += "						<div class='fields'>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' name='insScoreAplyYn' id='scoreAplyY' value='Y' tabindex='0' class='hidden' ${empty forumVO || forumVO.scoreAplyYn eq 'Y' ? 'checked' : '' }>";
				html += "									<label for='scoreAplyY'><spring:message code='exam.common.yes' /></label>";
				html += "								</div>";
				html += "							</div>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' name='insScoreAplyYn' id='scoreAplyN' value='N' tabindex='0' class='hidden' ${forumVO.scoreAplyYn eq 'N' ? 'checked' : '' }>";
				html += "									<label for='scoreAplyN'><spring:message code='exam.common.no' /></label>";
				html += "								</div>";
				html += "							</div>";
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt><label class='req'>성적 공개</label></dt>";
				html += "					<dd>";
				html += "						<div class='fields'>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' name='insScoreOpenYn' id='scoreOpenY' value='Y' tabindex='0' class='hidden' ${empty forumVO || forumVO.scoreOpenYn eq 'Y' ? 'checked' : '' }>";
				html += "									<label for='scoreOpenY'><spring:message code='exam.common.yes' /></label>";
				html += "								</div>";
				html += "							</div>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' name='insScoreOpenYn' id='scoreOpenN' value='N' tabindex='0' class='hidden' ${forumVO.scoreOpenYn eq 'N' ? 'checked' : '' }>";
				html += "									<label for='scoreOpenN'><spring:message code='exam.common.no' /></label>";
				html += "								</div>";
				html += "							</div>";
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt><label>지각 제출 사용</label></dt>";
				html += "					<dd>";
				html += "						<div class='fields'>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' name='periodAfterWriteYn' id='periodAfterWriteY' onchange='extDivView()' value='Y' tabindex='0' class='hidden' ${forumVO.periodAfterWriteYn eq 'Y' ? 'checked' : ''}>";
				html += "									<label for='periodAfterWriteY'><spring:message code='exam.common.yes' /></label>";
				html += "								</div>";
				html += "							</div>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' name='periodAfterWriteYn' id='periodAfterWriteN' onchange='extDivView()' value='N' tabindex='0' class='hidden' ${empty forumVO || forumVO.periodAfterWriteYn eq 'N' ? 'checked' : ''}>";
				html += "									<label for='periodAfterWriteN'><spring:message code='asmnt.common.no'/></label>";
				html += "								</div>";
				html += "							</div>";
				html += "						</div>";
				html += "						<div class='ui segment bcLgrey9' id='periodAfterDiv' ${empty forumVO || forumVO.periodAfterWriteYn eq 'N' ? 'style=\'display:none;\'' : ''}>";
				html += "							<div class='fields'>";
				html += "								<div class='inline field'>";
				html += "									<label for='extSendFmt'><spring:message code='forum.label.extEndDttm' /></label>";
				html += "									<div class='fields gap4 pl20'>";
				html += `										<uiex:ui-calendar dateId='extSendFmt' hourId='calExtSendHH' minId='calExtSendMM' rangeType='end' value='${forumVO.extEndDttm}'/>`;
				html += "									</div>";
				html += "								</div>";
				html += "							</div>";
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt><label class='req'>평가 방법</label></dt>";
				html += "					<dd>";
				html += "						<div class='fields'>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' name='evalCtgr' id='evalCtgr2' value='R' tabindex='0' class='hidden' ${forumVO.evalCtgr eq 'R' || empty forumVO ? 'checked' : '' }>";
				html += "									<label for='evalCtgr2'>참여형</label>";
				html += "								</div>";
				html += "							</div>";
				html += "							<div class='field'>";
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' name='evalCtgr' id='evalCtgr1' value='P' tabindex='0' class='hidden' ${forumVO.evalCtgr eq 'P' ? 'checked' : '' }>";
				html += "									<label for='evalCtgr1'><spring:message code='asmnt.label.point.type' /></label>";
				html += "								</div>";
				html += "							</div>";
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				html += "			<li>";
				html += "				<dl>";
				html += "					<dt><label for='contentTextArea'><spring:message code='asmnt.label.file.upload' /></label></dt>";	// 파일 업로드
				html += "					<dd>";
				html += "						<div id='fileUploader-container' class='dext5-container' style='width:100%;height:180px;'></div>";
				html += "						<div id='fileUploader-btn-area' class='dext5-btn-area' style=''>";
				html += "						<button type='button' id='fileUploader_btn-add' style='' title='<spring:message code='button.select.file'/>'><spring:message code='button.select.file'/></button>";
				html += "						<button type='button' id='fileUploader_btn-filebox' style='' title='<spring:message code='button.from_filebox'/>'><spring:message code='button.from_filebox'/></button>";
				html += "						<button type='button' id='fileUploader_btn-delete' disabled='true' style='' title='<spring:message code='button.delete'/>'><spring:message code='button.delete'/></button>";
				html += "						<button type='button' id='fileUploader_btn-reset' style='display:none' title='<spring:message code='button.reset'/>' onclick=\"resetDextFiles('fileUploader')\"><i class='ion-refresh'></i></button>";
				html += "						</div>";
				html += "					</dd>";
				html += "				</dl>";
				html += "			</li>";
				html += "		</ul>";
				html += "	</div>";
				html += '	<div class="ui styled fluid accordion week_lect_list">';
				html += '		<div class="title active">';
				html += '			<div class="title_cont">';
				html += '				<div class="left_cont">';
				html += '					<div class="lectTit_box">';
				html += '						<p class="lect_name"><spring:message code="resh.label.added.features" /></p>'; // 추가기능
				html += '					</div>';
				html += '				</div>';
				html += '			</div>';
				html += '			<i class="dropdown icon ml20"></i>';
				html += '		</div>';
				html += '		<div class="content p0 active">';
				html += '			<div class="ui segment">';
				html += '				<ul class="tbl border-top-grey">';
				html += '					<li>';
				html += '						<dl>';
				html += '							<dt><label for="indLabel"><spring:message code="forum.label.aplyAsnYn"/><!-- 댓글 답변 요청 --></label></dt>';
				html += '							<dd>';
				html += '								<div class="fields">';
				html += '									<div class="field">';
				html += '										<div class="ui radio checkbox checked">';
				html += '											<input type="radio" id="aplyAsnY" name="aplyAsnYn" value="Y" tabindex="0" class="hidden" ${forumVO.aplyAsnYn eq "Y" ? " checked" : ""} />';
				html += '											<label for="aplyAsnY"><spring:message code="forum.common.yes"/><!-- 예 --></label>';
				html += '										</div>';
				html += '									</div>';
				html += '									<div class="field">';
				html += '										<div class="ui radio checkbox">';
				html += '											<input type="radio" id="aplyAsnN" name="aplyAsnYn" value="N" tabindex="0" class="hidden" ${forumVO.aplyAsnYn eq "N" || empty forumVO.aplyAsnYn ? " checked" : ""} />';
				html += '											<label for="aplyAsnN"><spring:message code="forum.common.no"/><!-- 아니오 --></label>';
				html += '										</div>';
				html += '									</div>';
				html += '								</div>';
				html += '							</dd>';
				html += '						</dl>';
				html += '					</li>';
				html += '					<li>';
				html += '						<dl>';
				html += '							<dt><label><spring:message code="forum.label.prosCons"/><!-- 찬반 토론으로 설정 --></label></dt>';
				html += '							<dd>';
				html += '								<div class="fields">';
				html += '									<div class="field">';
				html += '										<div class="ui radio checkbox">';
				html += '											<input type="radio" name="prosConsForum" id="prosConsForumCfgY" value="Y" onchange="changeProsConsForumCfg()" tabindex="1" class="hidden" ${forumVO.prosConsForumCfg eq "Y" ? " checked" : ""} ${forumVO.prosConsForumCfg eq "Y" ? "readonly" : "" }>';
				html += '											<label for="prosConsForumCfgY"><spring:message code="forum.common.yes"/><!-- 예 --></label>';
				html += '										</div>';
				html += '									</div>';
				html += '									<div class="field">';
				html += '										<div class="ui radio checkbox">';
				html += '											<input type="radio" name="prosConsForum" id="prosConsForumCfgN" value="N" onchange="changeProsConsForumCfg()" tabindex="0" class="hidden" ${forumVO.prosConsForumCfg eq "N" || empty forumVO.prosConsForumCfg ? " checked" : ""} ${forumVO.prosConsForumCfg eq "Y" ? "readonly" : "" }>';
				html += '											<label for="prosConsForumCfgN"><spring:message code="forum.common.no"/><!-- 아니오 --></label>';
				html += '										</div>';
				html += '									</div>';
				html += '								</div>';
				html += '								<div class="ui segment bcLgrey9" id="prosConsForumDiv" style="display:${forumVO.prosConsForumCfg eq "Y" ? "block" : "none"};">';
				html += '									<div class="fields">';
				html += '										<div class="inline field">';
				html += '											<label class="" for="prosConsRateOpen"><spring:message code="forum.label.prosConsRate"/><!-- 찬반 비율 공개 --></label>';
				html += '											<div class="ui toggle checkbox">';
				if('${forumVO.prosConsRateOpenYn}' == "Y") {
					html += '											<input type="checkbox" id="prosConsRateOpen" name="prosConsRateOpen" value="Y" onchange="changeProsConsRateOpenYn()" checked>';
					html += '											<input type="hidden" name="prosConsRateOpenYn" value="Y" />';
				} else {
					html += '											<input type="checkbox" id="prosConsRateOpen" name="prosConsRateOpen" value="N" onchange="changeProsConsRateOpenYn()">';
					html += '											<input type="hidden" name="prosConsRateOpenYn" value="N" />';
				}
				html += '											</div>';
				html += '										</div>';
				html += '									</div>';
				html += '									<div class="fields">';
				html += '										<div class="inline field">';
				html += '											<label class="" for="regOpen"><spring:message code="forum.label.regOpen"/><!-- 작성자 공개 --></label>';
				html += '											<div class="ui toggle checkbox">';
				if('${forumVO.regOpenYn eq "Y" || empty forumVO.regOpenYn}' == 'true') {
					html += '											<input type="checkbox" id="regOpen" name="regOpen" value="Y" onchange="changeRegOpenYn()" checked>';
					html += '											<input type="hidden" name="regOpenYn" value="Y" />';
				} else {
					html += '											<input type="checkbox" id="regOpen" name="regOpen" value="N" onchange="changeRegOpenYn()">';
					html += '											<input type="hidden" name="regOpenYn" value="N" />';
				}
				html += '											</div>';
				html += '										</div>';
				html += '									</div>';
				html += '									<div class="fields">';
				html += '										<div class="inline field">';
				html += '											<label class="" for="prosConsMod"><spring:message code="forum.label.prosConsMod"/><!-- 찬반의견 변경 --></label>';
				html += '											<div class="ui toggle checkbox">';
				if('${forumVO.prosConsModYn eq "Y" || empty forumVO.prosConsModYn}' == 'true') {
					html += '											<input type="checkbox" id="prosConsMod" name="prosConsMod" value="Y" onchange="changeProsConsModYn()" checked>';
					html += '											<input type="hidden" name="prosConsModYn" value="Y" />';
				} else {
					html += '											<input type="checkbox" id="prosConsMod" name="prosConsMod" value="N" onchange="changeProsConsModYn()">';
					html += '											<input type="hidden" name="prosConsModYn" value="N" />';
				}
				html += '											</div>';
				html += '										</div>';
				html += '									</div>';
				html += '								</div>';
				html += '							</dd>';
				html += '						</dl>';
				html += '					</li>';
				html += '					<li>';
				html += '						<dl>';
				html += '							<dt><label><spring:message code="forum.label.mutEvalYn"/><!-- 상호평가 사용 --></label></dt>';
				html += '							<dd>';
				html += '								<div class="fields">';
				html += '									<div class="field">';
				html += '										<div class="ui radio checkbox">';
				html += '											<input type="radio" id="mutEvalY" name="mutEvalYn" onchange="mutDivViewForum()" value="Y" tabindex="0" class="hidden" ${forumVO.mutEvalYn eq "Y" ? " checked" : ""}>';
				html += '											<label for="mutEvalY"><spring:message code="forum.common.yes"/><!-- 예 --></label>';
				html += '										</div>';
				html += '									</div>';
				html += '									<div class="field">';
				html += '										<div class="ui radio checkbox checked">';
				html += '											<input type="radio" id="mutEvalN" name="mutEvalYn" onchange="mutDivViewForum()" value="N" tabindex="0" class="hidden" ${forumVO.mutEvalYn eq "N" || empty forumVO.mutEvalYn ? " checked" : ""}>';
				html += '											<label for="mutEvalN"><spring:message code="forum.common.no"/><!-- 아니오 --></label>';
				html += '										</div>';
				html += '									</div>';
				html += '								</div>';
				html += '								<div class="ui segment bcLgrey9" id="viewEvalUse" style="display: ${forumVO.mutEvalYn eq "Y" ? "block" : "none"};">';
				html += '									<div class="fields align-items-center">';
				html += '										<div class="field">';
				html += '											<label for="a3"><spring:message code="forum.label.eval.date"/><!-- 평가 기간 --></label>';
				html += '										</div>';
				html += '										<div class="field fields gap4">';
				html += '											<div class="field flex ">';
				html += `												<uiex:ui-calendar dateId="evalStartDttmText" hourId="evalStartHour" minId="evalStartMin" rangeType="start" rangeTarget="evalEndDttmText" value="${forumVO.evalStartDttm}"/>`;
				html += '											</div>';
				html += '											<div class="field p0 flex-item desktop-elem">~</div>';
				html += '											<div class="field flex ">';
				html += `												<uiex:ui-calendar dateId="evalEndDttmText" hourId="evalEndHour" minId="evalEndMin" rangeType="end" rangeTarget="evalStartDttmText" value="${forumVO.evalEndDttm}"/>`;
				html += '											</div>';
				html += '										</div>';
				html += '									</div>';
				html += '									<div class="fields">';
				html += '										<div class="field">';
				html += '											<label for="evalRsltOpenYn"><spring:message code="forum.label.result.open"/><!-- 결과 공개 --></label>';
				html += '										</div>';
				html += '										<div class="field">';
				html += '											<div class="ui toggle checkbox">';
				html += `												<input type="checkbox" id="evalRsltOpenYnCheck" class="hidden" <c:if test="${forumVO.evalRsltOpenYn eq 'Y'}">checked</c:if> />`;
				html += '											</div>';
				html += '											<input type="hidden" name="evalRsltOpenYn" value="${forumVO.evalRsltOpenYn}" />';
				html += '										</div>';
				html += '									</div>';
				html += '								</div>';
				html += '								<div class="ui small warning message"><i class="info circle icon"></i><spring:message code="forum.label.mutEval.warning"/></div>';
				html += '							</dd>';
				html += '						</dl>';
				html += '					</li>';
				html += '				</ul>';
				html += '			</div>';
				html += '		</div>';
				html += '	</div>';
				
				html += "</div>";
			}
			$("#insWriteDiv").empty().html(html);
			// html 에디터 생성
		  	editor = HtmlEditor(ctsId, THEME_MODE, path);
			$("#new_insCts").css("z-index", "3");
			
			// 파일업로더 생성
			DextUploader({
				id:"fileUploader",
				parentId:"fileUploader-container",
				btnFile:"fileUploader_btn-add",
				btnDelete:"fileUploader_btn-delete",
				lang:"ko",
				uploadMode:"ORAF",
				maxTotalSize:1024,
				maxFileSize:1024,
				finishFunc:"finishUpload()",
				uploadUrl:"<%=CommConst.PRODUCT_DOMAIN + CommConst.DEXT_FILE_UPLOAD%>?type=",
				path:path,
				fileCount:5,
				oldFiles:[],
				useFileBox:true,
				style:"list",
				uiMode:"normal"
			});
			
			// 달력 설정
			initExamCalendar("insStartFmt_cal", "insEndFmt_cal", "start");
			initExamCalendar("insEndFmt_cal", "insStartFmt_cal", "end");
			if(type != "QUIZ") {
				initExamCalendar("extSendFmt_cal", "", "start");
			}
			var selectHtml = "<option value='59'>59</option>";
			$("select[caltype='min']").append(selectHtml);
			// 시, 분 드롭다운
			$("#insWriteDiv .dropdown").dropdown();
			var startDttm = type == "QUIZ" ? "${quizVO.examStartDttm}" : type == "ASMNT" ? "${asmtVO.sendStartDttm}" : "${forumVO.forumStartDttm}";
			var endDttm = type == "QUIZ" ? "${quizVO.examEndDttm}" : type == "ASMNT" ? "${asmtVO.sendEndDttm}" : "${forumVO.forumEndDttm}";
			var extDttm = type == "ASMNT" ? "${asmtVO.extSendDttm}" : type == "FORUM" ? "${forumVO.extEndDttm}" : "";
			if(startDttm != "") {
				$("#insStartFmt").val(startDttm.substring(0,4)+"."+startDttm.substring(4,6)+"."+startDttm.substring(6,8));
				$("#insStartHH").dropdown('set selected', startDttm.substring(8, 10));
				$("#insStartMM").dropdown('set selected', startDttm.substring(10, 12));
			}
			if(endDttm != "") {
				$("#insEndFmt").val(endDttm.substring(0,4)+"."+endDttm.substring(4,6)+"."+endDttm.substring(6,8));
				$("#insEndHH").dropdown('set selected', endDttm.substring(8, 10));
				$("#insEndMM").dropdown('set selected', endDttm.substring(10, 12));
			}
			if(type != "QUIZ" && extDttm != "") {
				$("#extSendFmt").val(extDttm.substring(0,4)+"."+extDttm.substring(4,6)+"."+extDttm.substring(6,8));
				$("#calExtSendHH").dropdown('set selected', extDttm.substring(8, 10));
				$("#calExtSendMM").dropdown('set selected', extDttm.substring(10, 12));
			}
			
			if(type == "ASMNT") {
				// 팀과제여부 변경시 화면 변경
			    $("input[name='teamAsmntCfgYn']").change(function(e){
			    	var team = $("input[name='teamAsmntCfgYn']:checked").val();

			    	if(team == 'Y'){
			    		// 팀 과제 여부 보이기
			    		$("#viewTeam").show();
			    	} else if(team == 'N') {
			    		// 팀 과제 여부 숨기기
			    		$("#viewTeam").hide();
			    	}
			    });
				
			    createTeamSelectOption();
			    
			    if("${asmtVO.asmntCd}") {
			    	// 팀과제
					if("${asmtVO.teamAsmntCfgYn}" == "Y") {
						$("input:radio[name=teamAsmntCfgYn][value='Y']").prop("checked", true);
						$("input:radio[name=teamAsmntCfgYn]").trigger("change");
						$("#teamCtgrCd0").val("${asmtVO.teamCtgrCd}"+":"+"${vo.crsCreCd}");
						$("#teamCtgr0").val("${asmtVO.teamCtgrNm}");
					} else {
						$("input:radio[name=teamAsmntCfgYn][value='N']").prop("checked", true); 
					}
			    	
					$("input[name=teamAsmntCfgYn]").attr("readonly", true);
					$("input[name=teamAsmntCfgYn]").parent(".ui.checkbox").checkbox("can change");
			    
			    	if("${asmtVO.prtcYn}" == "Y") {
			    		$("input:radio[name='prtcYn'][value='Y']").prop('checked', true);
						$("#viewPrtc").show();
			    		$("#viewSendType").hide();
			    		
			    		var fArr = "${asmtVO.sbmtFileType}".split(',');
			    		for(var i=0; i<fArr.length; i++){
			    			$("input[name='prtcFileType'][value='"+fArr[i]+"']").prop("checked",true);
			    		}
			    	}else{
			    		$("input:radio[name='prtcYn'][value='N']").prop('checked', true);
			    		$("#viewPrtc").hide();
			    		$("#viewSendType").show();
			    		
			    		// 제출형식 매핑
			    		if("${asmtVO.sendType}" == 'F'){
			    			$("input:radio[name='sendType'][value='F']").prop('checked', true);
			    			$("#viewSendTypeFile").show();

			    			if("${asmtVO.sbmtFileType}" == '' || "${asmtVO.sbmtFileType}" == null){
			    				$("#allFile").prop("checked",true);
			    			}else{
			    				var fArr = "${asmtVO.sbmtFileType}".split(',');

			            		for(var i=0; i<fArr.length; i++){
			            			if(i==0){
			            				if(fArr[i] == 'img' || fArr[i] == 'pdf' ||  fArr[i] == 'txt' ||  fArr[i] == 'soc' ||  fArr[i] == 'ppt2'){
			            					$("#preFile").prop("checked",true);
			            				}else if(fArr[i] == 'hwp' || fArr[i] == 'doc' ||  fArr[i] == 'ppt' ||  fArr[i] == 'xls' || fArr[i] == 'pdf2' || fArr[i] == 'zip'){
			            					$("#docFile").prop("checked",true);
			            				}
			            			}

			            			if(fArr[i] == 'img' || fArr[i] == 'pdf' ||  fArr[i] == 'txt' ||  fArr[i] == 'soc' ||  fArr[i] == 'ppt2'){
			            				$("input[name='preFile'][value='"+fArr[i]+"']").prop("checked",true);
			        				}else if(fArr[i] == 'hwp' || fArr[i] == 'doc' ||  fArr[i] == 'ppt' ||  fArr[i] == 'xls' || fArr[i] == 'pdf2' || fArr[i] == 'zip'){
			        					$("input[name='docFile'][value='"+fArr[i]+"']").prop("checked",true);
			        				}

			            		}
			    			}

			    		}else if("${asmtVO.sendType}" == 'T'){
			    			$("input:radio[name='sendType'][value='T']").prop('checked', true);
			    			$("#viewSendTypeFile").hide();
			    		}
			    		
			    		// 평가방법
			    		if("${asmtVO.evalCtgr}" == 'P'){
			    			$("input:radio[name='evalCtgr'][value='P']").prop('checked', true);
			    		}else if("${asmtVO.evalCtgr}" == 'R'){
			    			$("input:radio[name='evalCtgr'][value='R']").prop('checked', true);
			    			$("#evalCd").val("${asmtVO.evalCd}");
			    			$("#evalTitle").val("${asmtVO.evalTitle}");
			    			$("#mutEvalDiv").show();
			    		}
			    	}
			    }
			}
			
			if(type == "FORUM") {
				initExamCalendar("evalStartDttmText_cal", "evalEndDttmText_cal", "start");
				initExamCalendar("evalEndDttmText_cal", "evalStartDttmText_cal", "end");
				
				var evalStartDttm = "${forumVO.evalStartDttm}";
				var evalEndDttm = "${forumVO.evalEndDttm}";
				if(evalStartDttm != "") {
					$("#evalStartDttmText").val(evalStartDttm.substring(0,4)+"."+evalStartDttm.substring(4,6)+"."+evalStartDttm.substring(6,8));
					$("#evalStartHour").dropdown('set selected', evalStartDttm.substring(8, 10));
					$("#evalStartMin").dropdown('set selected', evalStartDttm.substring(10, 12));
				}
				if(evalEndDttm != "") {
					$("#evalEndDttmText").val(evalEndDttm.substring(0,4)+"."+evalEndDttm.substring(4,6)+"."+evalEndDttm.substring(6,8));
					$("#evalEndHour").dropdown('set selected', evalEndDttm.substring(8, 10));
					$("#evalEndMin").dropdown('set selected', evalEndDttm.substring(10, 12));
				}
			}
			
			$('.ui.checkbox').checkbox();
		}
		
		// 상호평가 사용 체크
		function mutDivViewForum() {
			var type = $("input[name=mutEvalYn]:checked").val();
			if(type == "Y") {
				$("#viewEvalUse").css("display", "block");
			} else {
				$("#viewEvalUse").css("display", "none");
			}
		}
		
		//찬반토론설정
		function changeProsConsForumCfg() {
			var type = $("input[name=prosConsForum]:checked").val();

			if (type == "Y") {
				$("#prosConsForumDiv").css("display", "block");
				$('input[name=prosConsForumCfg]').val('Y');
			} else {
				$("#prosConsForumDiv").css("display", "none")
				$('input[name=prosConsForumCfg]').val('N');
				$("#prosConsRateOpen").removeAttr("checked");
				$('input[name=prosConsRateOpenYn]').val('N');
				$("#regOpen").removeAttr("checked");
				$('input[name=regOpenYn]').val('N');
				$("#multiAtcl").prop('checked', false);
				$('input[name=multiAtclYn]').val('N');
				$("#prosConsMod").prop('checked', false); 
				$('input[name=prosConsModYn]').val('N');
			}
		}
		
		//찬반비율공개
		function changeProsConsRateOpenYn() {
			if ($("input[name=prosConsRateOpen]").is(":checked") == true) {
				$('input[name=prosConsRateOpenYn]').val('Y');
			} else {
				$('input[name=prosConsRateOpenYn]').val('N');
			}
		}
		
		//찬반의견 변경
		function changeProsConsModYn() {
			if ($("input[name=prosConsMod]").is(":checked") == true) {
				$('input[name=prosConsModYn]').val('Y');
			} else {
				$('input[name=prosConsModYn]').val('N');
			}
		}
		
		//작성자비공개설정
		function changeRegOpenYn() {
			if ($("input[name=regOpen]").is(":checked") == true) {
				$('input[name=regOpenYn]').val('Y');
			} else {
				$('input[name=regOpenYn]').val('N');
			}
		}
		
		// 지각제출 변경
		function extDivView() {
			var extYn = "";
			if($("input[name=examTypeCd]:checked").val() == "ASMNT") extYn = $("input[name=extSendAcptYn]:checked").val();
			if($("input[name=examTypeCd]:checked").val() == "FORUM") extYn = $("input[name=periodAfterWriteYn]:checked").val();
			if(extYn == "Y") {
				$("#periodAfterDiv").show();
			} else {
				$("#periodAfterDiv").hide();
			}
		}
		
		// 평가방법 변경
		function mutDivView() {
			if($("input[name=evalCtgr]:checked").val() == "R") {
				$("#mutEvalDiv").show();
			} else {
				$("#mutEvalDiv").hide();
			}
		}
		
		// 제출형식 변경
		function sendDivView() {
			if($("input[name=sendType]:checked").val() == "F") {
				$("#viewSendTypeFile").show();
			} else {
				$("#viewSendTypeFile").hide();
			}
		}
		
		// 실기과제 변경
		function prtcDivView() {
			if($("input[name=prtcYn]:checked").val() == "Y") {
				$("#viewPrtc").show();
				$("#viewSendType").hide();
			} else {
				$("#viewPrtc").hide();
				$("#viewSendType").show();
			}
		}
		
		// 제출형식 변경
		function sendFileChk() {
			$('input:checkbox[name="preFile"]').each(function() {
				this.checked = false;
			});
	
			$('input:checkbox[name="docFile"]').each(function() {
				this.checked = false;
			});
		}
		
		// 파일형식 변경
		function fileChk(type) {
			if(type == "pre") {
				$("#preFile").prop("checked", true);
				$('input:checkbox[name="docFile"]').each(function() {
					this.checked = false;
				});
			} else {
				$("#docFile").prop("checked", true);
				$('input:checkbox[name="preFile"]').each(function() {
					this.checked = false;
				});
			}
		}
		
		// 평가 기준 등록 팝업
	    function mutEvalWritePop(type) {
			var evalCd = "";
			if(type == 'edit'){
				evalCd = $("#evalCd").val();
				if(evalCd == ""){
					/* 수정할 평가기준이 없습니다. */
					alert("<spring:message code='forum.alert.evalCd.none' />");
					return false;
				}
			}
	
			var kvArr = [];
			kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
			kvArr.push({'key' : 'evalCd',   'val' : evalCd});
	
			submitForm("/mut/mutPop/mutEvalWritePop.do", "examPopIfm", "addMutEval", kvArr);
	    }
	
	    // 평가 기준 등록
	    function mutEvalWrite(evalCd, evalTitle) {
	    	$("#evalCd").val(evalCd);
	    	$("#evalTitle").val(evalTitle);
	    }
	
	  	// 평가기준 삭제
	    function deleteMut() {
	  		var evalCd = $("#evalCd").val();
			if(evalCd == ""){
				/* 삭제할 평가기준이 없습니다. */
				alert("<spring:message code='forum.alert.evalCd.del' />");
				return false;
			}
	
			/* 삭제 하시겠습니까? */
	    	if(window.confirm("<spring:message code='seminar.confirm.delete' />")) {
	    		var url  = "/mut/mutHome/edtDelYn.do";
	    		var data = {
	    			"evalCd" : evalCd
	    			,"delYn" : 'Y'
	    		};
	
	    		ajaxCall(url, data, function(data) {
	    			if (data.result > 0) {
	    				$("#evalCd").val("");
	                	$("#evalTitle").val("");
	
						/* 정상적으로 삭제되었습니다. */
		        		alert("<spring:message code='success.common.delete'/>");
	
	                } else {
	                 	alert(data.message);
	                }
	    		}, function(xhr, status, error) {
	                /* 삭제 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
	                alert("<spring:message code='seminar.error.delete' />");
	    		}, true);
	    	}
	    }
	  	
	 	// 저장 확인
	    function saveConfirm() {
	    	if(nullCheck()){
	    		var fileUploader = dx5.get("fileUploader");
	        	// 파일이 있으면 업로드 시작
	     		if (fileUploader.getFileCount() > 0) {
	    			fileUploader.startUpload();
	    		} else {
	    			// 저장 호출
	    			save();
	    		}
	 		}
	    }
	 	
	 	// 파일 업로드 완료
	    function finishUpload() {
	    	var fileUploader = dx5.get("fileUploader");
	    	var url = "/file/fileHome/saveFileInfo.do";
	    	var data = {
	    		"uploadFiles" : fileUploader.getUploadFiles(),
	    		"copyFiles"   : fileUploader.getCopyFiles(),
	    		"uploadPath"  : fileUploader.getUploadPath()
	    	};
	    	
	    	ajaxCall(url, data, function(data) {
	    		if(data.result > 0) {
	    			$("input[name='uploadFiles']").val(fileUploader.getUploadFiles());
	    	    	$("input[name='uploadPath']").val(fileUploader.getUploadPath());
	
	    	    	save();
	    		} else {
	    			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    		}
	    	}, function(xhr, status, error) {
	    		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    	});
	    }
		
	 	// 등록, 수정
	 	function save() {
	 		if(!nullCheck()) {
	    		return false;
	    	}
	    	setValue();
	    	
	    	showLoading();
	    	var url = "";
	    	if(${not empty vo.examCd} || "${vo.examStareTypeCd}" == "M" || "${vo.examStareTypeCd}" == "L") {
	    		url = "/exam/editExam.do";
	    	} else {
	    		url = "/exam/writeExam.do";
	    	}
	    	$.ajax({
	            url 	 : url,
	            async	 : false,
	            type 	 : "POST",
	            dataType : "json",
	            data 	 : $("#writeExamForm").serialize(),
	        }).done(function(data) {
	        	hideLoading();
	        	if (data.result > 0) {
	        		if("${vo.examStareTypeCd}" == "A") {
	        			//alert("<spring:message code='exam.alert.insert.stare.a' />");/* 수시평가가 정상적으로 등록되었습니다. */
	        			alert("<spring:message code='exam.alert.already.quiz.qstn.submit' />");/* 퀴즈 문제관리에서 문제를 출제 해 주세요. */
	        		} else if("${vo.examStareTypeCd}" == "M") {
	        			var alertStr = "";
	        			if("${orgId}" != "ORG0000001") {
	        				if("${vo.examTypeCd}" == "EXAM") {
	        					alertStr = "[대체평가] ";
	        				} else {
	        					alertStr = "[기타] ";
	        				}
	        			}
	        			alertStr += "<spring:message code='forum.label.type.exam.M' /><spring:message code='exam.alert.insert' />";	// 중간고사 정상 저장되었습니다.
		        		alert(alertStr);
	        		} else if("${vo.examStareTypeCd}" == "L") {
	        			var alertStr = "";
	        			if("${orgId}" != "ORG0000001") {
	        				if("${vo.examTypeCd}" == "EXAM") {
	        					alertStr = "[<spring:message code='common.label.alternate.assessment' />] ";	// 대체평가
	        				} else {
	        					alertStr = "[<spring:message code='exam.label.etc' />] ";	// 기타
	        				}
	        			}
	        			alertStr += "<spring:message code='forum.label.type.exam.L' /><spring:message code='exam.alert.insert' />";	// 기말고사 정상 저장되었습니다
	        			alert(alertStr);
	        		}
	        		if("${vo.examStareTypeCd}" == "A") {
	        			insQuizPageView(data.returnVO.examCd);
	        		} else {
	        			viewExamList();
	        		}
	            } else {
	             	alert(data.message);
	            }
	        }).fail(function() {
	        	hideLoading();
	        	if("${vo.examStareTypeCd}" == "A") {
	        		alert("<spring:message code='exam.error.insert.stare.a' />");/* 수시평가 등록 중 에러가 발생하였습니다. */
	        	} else {
		        	alert("<spring:message code='exam.error.insert.ins.ref' />");/* 대체평가 등록 중 에러가 발생하였습니다. */
	        	}
	        });
	 	}
	 	
	 	// 빈 값 체크
	 	function nullCheck() {
	 		<spring:message code='exam.label.quiz' var='quiz'/> // 퀴즈
	 		<spring:message code='asmnt.label.asmnt' var='asmnt'/> // 과제
	 		<spring:message code='forum.label.forum' var='forum'/> // 토론
	 		
	 		// 수시평가
	 		if("${examType}" == "ADMISSION") {
		 		if($.trim($("#examTitle").val()) == "") {
		    		alert("<spring:message code='exam.alert.input.title' />");/* 제목을 입력하세요. */
		    		return false;
		    	}
	 		}
	 		
	 		// 공통
	 		var examTypeCd = $("input[name=examTypeCd]:checked").val();
	 		if(examTypeCd == undefined) {
	 			alert("시험 유형을 선택하세요.");
	 			return false;
	 		}
	 		if($.trim($("#insTitle").val()) == "") {
	 			alert("<spring:message code='exam.alert.input.title' />");/* 제목을 입력하세요. */
	    		return false;
	 		}
	 		if(editor.isEmpty() || editor.getTextContent().trim() === "") {
	 			alert("<spring:message code='exam.alert.input.contents' />");/* 내용을 입력하세요. */
	 			return false;
	 		}
	 		var typeStr = examTypeCd == "QUIZ" ? "${quiz}" : examTypeCd == "ASMNT" ? "${asmnt}" : "${forum}";
	 		if($("#insStartFmt").val() == "") {
				alert("<spring:message code='common.alert.input.eval_start_date' arguments='"+typeStr+"'/>");/* [시험] 시작일을 입력하세요. */
				return false;
			}
			if($("#insStartHH").val() == " ") {
				alert("<spring:message code='common.alert.input.eval_start_hour' arguments='"+typeStr+"'/>");/* [시험] 시작시간을 입력하세요. */
				return false;
			}
			if($("#insStartMM").val() == " ") {
				alert("<spring:message code='common.alert.input.eval_start_min' arguments='"+typeStr+"'/>");/* [시험] 시작분을 입력하세요. */
				return false;
			}
	    	if($("#insEndFmt").val() == "") {
				alert("<spring:message code='common.alert.input.eval_end_date' arguments='"+typeStr+"'/>");/* [시험] 종료일을 입력하세요. */
				return false;
			}
			if($("#insEndHH").val() == " ") {
				alert("<spring:message code='common.alert.input.eval_end_hour' arguments='"+typeStr+"'/>");/* [시험] 종료시간을 입력하세요. */
				return false;
			}
			if($("#insEndMM").val() == " ") {
				alert("<spring:message code='common.alert.input.eval_end_min' arguments='"+typeStr+"'/>");/* [시험] 종료분을 입력하세요. */
				return false;
			}
			if ( ($("#insStartFmt").val()+$("#insStartHH").val()+$("#insStartMM").val()) >
				($("#insEndFmt").val()+$("#insEndHH").val()+$("#insEndMM").val()) ) {
				alert("<spring:message code='common.alert.input.eval_start_end_date' arguments='${exam}'/>"); // 종료일시를 시작일시 이후로 입력하세요.
				return false;
			}
	 		
	 		// 퀴즈
	 		if(examTypeCd == "QUIZ") {
	 			if($("#examStareTm").val() == "") {
	 				alert("<spring:message code='exam.alert.input.time' />");/* 시간을 입력하세요. */
	 				return false;
	 			}
	 		// 과제, 토론
	 		} else {
	 			var extYn = examTypeCd == "ASMNT" ? $("input[name=extSendAcptYn]:checked").val() : $("input[name=periodAfterWriteYn]:checked").val();
	 			if(extYn == "Y") {
	 				if($("#extSendFmt").val() == "") {
	 					alert("<spring:message code='common.alert.input.eval_start_date' arguments='"+typeStr+"'/>");/* [시험] 시작일을 입력하세요. */
	 					return false;
	 				}
	 				if($("#calExtSendHH").val() == " ") {
	 					alert("<spring:message code='common.alert.input.eval_start_hour' arguments='"+typeStr+"'/>");/* [시험] 시작시간을 입력하세요. */
	 					return false;
	 				}
	 				if($("#calExtSendMM").val() == " ") {
	 					alert("<spring:message code='common.alert.input.eval_start_min' arguments='"+typeStr+"'/>");/* [시험] 시작분을 입력하세요. */
	 					return false;
	 				}
	 			}
	 			
	 			// 과제
	 			if(examTypeCd == "ASMNT") {
	 				// 제출형식
	 				if($("input:radio[name='prtcYn']:checked").val() == 'Y'){
	 					if($("input:checkbox[name=prtcFileType]:checked").length < 1){
	
	 						/* 실기과제 파일형식을 선택하세요. */
	 						alert("<spring:message code='asmnt.label.prtc.filetype.select' />");
	 						return false;
	 					}
	 				}else{
	 					if($("input:radio[name=sendType]:checked").length == 0){
	
	 						/* 제출형식을 선택하세요. */
	 						alert("<spring:message code='asmnt.label.filetype.select' />");
	 						return false;
	 					}
	
	 					if($("input:radio[name=sendType]:checked").val() == 'F'){
	 						if($('input:radio[name=sendFileType]:checked').val() != 'all'){
	 							if($("input:checkbox[name=preFile]:checked").length + $("input:checkbox[name=docFile]:checked").length < 1) {
	
	 								/* 파일 제출형식을 선택하세요. */
	 								alert("<spring:message code='file.label.filetype.select' />");
	 								return false;
	 							}
	 						}
	 					}
	 				}
	 				
	 				// 팀 과제 여부
	 				if($("input[name='teamAsmntCfgYn']:checked").val() == 'Y'){
	 					var checkTeamCtgr = true;
	 					
	 					$.each($("input[name='teamCtgrList']"), function() {
	 						if(!this.value) {
	 							checkTeamCtgr = false;
	 						}
	 					});
	 					
	 					if(!checkTeamCtgr) {
	 		    			/* 팀 분류를 선택하세요. */
	 						alert("<spring:message code='forum.label.selected' />");
	 						return false;
	 		    		}
	 				}
	 				
	 				// 평가방법 - 루브릭
	 				if($("input:radio[name=evalCtgr]:checked").val() == 'R' && !$("#evalCd").val()) {
	 					alert("<spring:message code='asmnt.alert.empty.rubric' />"); // 평가방법 루브릭을 설정하세요.
	 					return false;
	 				}
	 				
	 				// 지각제출사용
	 				if($("input:radio[name=extSendAcptYn]:checked").val() == 'Y'){
	 					var sendEndDttmCheck = setDateEndDttm($("#insEndFmt").val().replaceAll(".","") + "" + pad($("#insEndHH option:selected").val(),2) + "" + pad($("#insEndMM option:selected").val(),2), "");
	 					var extSendDttmCheck = setDateEndDttm($("#extSendFmt").val().replaceAll(".","") + "" + pad($("#calExtSendHH option:selected").val(),2) + "" + pad($("#calExtSendMM option:selected").val(),2), "");
	 					
	 					if(sendEndDttmCheck.length == 14 && extSendDttmCheck.length == 14) {
	 						if(sendEndDttmCheck >= extSendDttmCheck) {
	 							alert("<spring:message code='asmnt.alert.invalid.ext.send.dttm' />"); // 지각제출 종료일은 과제 종료일보다 크게 입력하세요.
	 							return false;
	 						}
	 					}
	 				}
	 				
	 				// 종합성적 산출기간 체크
	 				if(("${sysJobSchVO.schEndDt}" || "").length >= 12) {
	 					var endDttm = setDateEndDttm($("#insEndFmt").val().replaceAll(".","") + "" + pad($("#insEndHH option:selected").val(),2) + "" + pad($("#insEndMM option:selected").val(),2), "");
	 					var scoreProcDttm = "${sysJobSchVO.schEndDt}";
	 					var scoreProcDttmFmt = scoreProcDttm.substring(0, 4) + "." + scoreProcDttm.substring(4, 6) + "." + scoreProcDttm.substring(6, 8) + " " + scoreProcDttm.substring(8, 10) + ":" + scoreProcDttm.substring(10, 12) + ":" + scoreProcDttm.substring(12, 14);
	 					
	 					if(endDttm > scoreProcDttm.substring(0, 12)) {
	 						// 과제 제출기간은 종합성적 산출/입력 마감일 이전까지로 설정 가능합니다.
	 						alert("<spring:message code='asmnt.alert.invalid.send.end.dttm' />" + "\n" + scoreProcDttmFmt);
	 						return false;
	 					}
	 					
	 					// 지각제출사용
	 					if($("input:radio[name=extSendAcptYn]:checked").val() == 'Y') {
	 						var extSendDttmCheck = setDateEndDttm($("#extSendFmt").val().replaceAll(".","") + "" + pad($("#calExtSendHH option:selected").val(),2) + "" + pad($("#calExtSendMM option:selected").val(),2), "");
	 						
	 						if(extSendDttmCheck.substring(0, 12) > scoreProcDttm.substring(0, 12)) {
	 							// 과제 제출기간은 종합성적 산출/입력 마감일 이전까지로 설정 가능합니다.
	 							alert("<spring:message code='asmnt.alert.invalid.send.end.dttm' />" + "\n" + scoreProcDttmFmt);
	 							return false;
	 						}
	 					}
	 				}
	 			} else if (examTypeCd == "FORUM") {
	 				if($("input[name=mutEvalYn]:checked").val() == "Y") {
	 					var evalStartDttmheck = (($("#evalStartDttmText").val() || "") + ($("#evalStartHour").val() || "") + ($("#evalStartMin").val() || "")).replaceAll(".", "");
	 					var evalEndDttmheck = (($("#evalEndDttmText").val() || "") + ($("#evalEndHour").val() || "") + ($("#evalEndMin").val() || "")).replaceAll(".", "");
	 				
	 					if(!evalStartDttmheck || evalStartDttmheck.length != 12) {
	 						alert("<spring:message code='forum.alert.input.mut_eval_start_date' />"); // 상호평가 시작일을 입력하세요.
	 						return false;
	 					}
	 					
	 					if(!evalEndDttmheck || evalEndDttmheck.length != 12) {
	 						alert("<spring:message code='forum.alert.input.mut_eval_end_date' />"); // 상호평가 종료일을 입력하세요.
	 						return false;
	 					}
	 				}
	 				
	 				if($("input[name=mutEvalYn]:checked").val() == "Y") {
	 					if($("#evalStartDttmText").val()) {
	 						$("input[name='evalStartDttm']").val($("#evalStartDttmText").val().replaceAll('.','-')+ ' ' + $("#evalStartHour").val() + ":" + $("#evalStartMin").val());
	 					}
	 					if($("#evalEndDttmText").val()) {
	 						$("input[name='evalEndDttm']").val(setDateEndDttm($("#evalEndDttmText").val().replaceAll('.','-')+ ' ' + $("#evalEndHour").val() + ":" + $("#evalEndMin").val(), ":"));
	 					}
	 				} else {
	 					$("input[name='evalStartDttm']").val("");
	 					$("input[name='evalEndDttm']").val("");
	 				}
	 				
	 				if($("#evalRsltOpenYnCheck").is(":checked")) {
	 					$("input[name='evalRsltOpenYn']").val("Y");
	 				} else {
	 					$("input[name='evalRsltOpenYn']").val("N");
	 				}
				}
	 		}
	 		
	 		return true;
	 	}
	 	
	 	// 값 채우기
	    function setValue() {
	 		var fileUploader = dx5.get("fileUploader");
	 		
	 		// 시작일자
			if ($("#insStartFmt").val() != null && $("#insStartFmt").val() != "") {
				$("#insStartDttm").val($("#insStartFmt").val().replaceAll(".","") + "" + pad($("#insStartHH option:selected").val(),2) + "" + pad($("#insStartMM option:selected").val(),2) + "00");
			}
			// 종료일자
			if ($("#insEndFmt").val() != null && $("#insEndFmt").val() != "") {
				$("#insEndDttm").val(setDateEndDttm($("#insEndFmt").val().replaceAll(".","") + "" + pad($("#insEndHH option:selected").val(),2) + "" + pad($("#insEndMM option:selected").val(),2), ""));
			}
			
			// 재시험여부(퀴즈)
			if($("input[name=examTypeCd]:checked").val() == "QUIZ") {
				$("#reExamYn").val($("input[name='reExamYnCheck']:checked").val());
				// 보기 섞기
				$("#emplRandomYn").val($("#emplRandomYnChk").is(":checked") ? "Y" : "N");
			} else {
				$("#reExamYn").val("N");
				var extYn = $("input[name=examTypeCd]:checked").val() == "ASMNT" ? $("input[name=extSendAcptYn]:checked").val() : $("input[name=periodAfterWriteYn]:checked").val();
				if(extYn == "Y") {
					if($("#extSendFmt").val() != null && $("#extSendFmt").val() != "") {
						$("#extSendDttm").val($("#extSendFmt").val().replaceAll(".","") + "" + pad($("#calExtSendHH option:selected").val(),2) + "" + pad($("#calExtSendMM option:selected").val(),2) + "00");
					}
				}
			}
			
			// 과제
			if($("input[name=examTypeCd]:checked").val() == "ASMNT") {
				var sFileType = "";
				if($("input:radio[name='prtcYn']:checked").val() == 'Y'){
					for(var i = 0; i < $('input:checkbox[name="prtcFileType"]:checked').length; i++){
					if(i>0) sFileType += ',';
					sFileType += $('input:checkbox[name="prtcFileType"]:checked').eq(i).val();
				}
					//$("input[name='sendType']").attr("checked",false)
				}else{
					if($("input:radio[name=sendType]:checked").val() == 'F'){
						var sft = $('input:radio[name=sendFileType]:checked').val();
	
						if(sft == "pre"){
							for(var i = 0; i < $('input:checkbox[name="preFile"]:checked').length; i++){
								if(i>0) sFileType += ',';
								sFileType += $('input:checkbox[name="preFile"]:checked').eq(i).val();
							}
						} else if(sft == "doc"){
							for(var i = 0; i < $('input:checkbox[name="docFile"]:checked').length; i++){
								if(i>0) sFileType += ',';
								sFileType += $('input:checkbox[name="docFile"]:checked').eq(i).val();
							}
						}
					}
				}
	
				$("input[name='sbmtFileType']").val(sFileType);
				$("input[name='copyFiles']").val(fileUploader.getCopyFiles());
			}
	    }
	    
		// 목록
		function viewExamList() {
			var kvArr = [];
			kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
			kvArr.push({'key' : 'examType', 'val' : "${examType}"});
			
			submitForm("/exam/Form/examList.do", "", "", kvArr);
		}
		
		// 대체평가 대상자 설정 팝업
		function examInsTargetPop(examCd) {
			var endDate = new Date("${fn:substring(vo.examEndDttm, 0, 4)}", parseInt("${fn:substring(vo.examEndDttm, 4, 6)}") -2, "${fn:substring(vo.examEndDttm, 6, 8)}");
			endDate.setDate(endDate.getDate()+1);
			var year = endDate.getFullYear();
			var month = (""+endDate.getMonth()).length == 1 ? "0" + endDate.getMonth() : endDate.getMonth();
			var day = endDate.getDate();
			var date = year + "" + month + "" + day + "07";
			if(date > "${fn:substring(today, 0, 10)}") {
				alert("<spring:message code='exam.alert.exam.applicate.not.date' />");/* 실시간시험일 익일 7시 이후 설정가능합니다. */
			} else {
				var kvArr = [];
				kvArr.push({'key' : 'examCd', 	'val' : examCd});
				kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
				
				submitForm("/exam/examInsTargetPop.do", "examPopIfm", "examInsTarget", kvArr);
			}
		}
		
		// 대체평가 대상자 선택 취소
		function examInsTargetCancel(examCd) {
			var stdNos = "";
			$("#stdTbody input[name=evalChk]:checked").each(function(i, v) {
				if(i > 0) stdNos += ",";
				stdNos += $(v).attr("data-stdNo");
			});
			
			if(stdNos == "") {
				alert("<spring:message code='common.alert.select.student' />");/* 학습자를 선택하세요. */
				return false;
			}
			
			var url  = "/exam/insTargetCancelByStdNos.do";
			var data = {
				"examCd"  : "${vo.examCd}",
				"stdNos"   : stdNos
			};
	
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					alert("<spring:message code='exam.alert.delete' />");/* 정상 삭제 되었습니다. */
					insStdList();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
	            /* 삭제 중 에러가 발생하였습니다. */
	            alert("<spring:message code='exam.error.delete' />");
			}, true);
		}
		
		// 대체평가 대상자 목록
		function insStdList() {
			var url  = "/exam/listInsTraget.do";
			var data = {
				"examCd"     : "${vo.examCd}",
				"crsCreCd"   : '${vo.crsCreCd}',
				"searchType" : "submit"
			};
	
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var returnList = data.returnList || [];
					var html = "";
					
					if(returnList.length > 0) {
						returnList.forEach(function(v, i) {
							var absentNm = v.absentNm;
							if(v.absentNm == "APPROVE") absentNm = "<spring:message code='exam.label.approve' />";/* 승인 */
							if(v.absentNm == "APPLICATE") absentNm = "<spring:message code='exam.label.applicate' />";/* 신청 */
							if(v.absentNm == "RAPPLICATE") absentNm = "<spring:message code='exam.label.rapplicate' />";/* 재신청 */
							if(v.absentNm == "COMPANION") absentNm = "<spring:message code='exam.label.companion' />";/* 반려 */
							html += "<tr>";
							html += "	<td class='tc'>";
							html += "		<div class='ui checkbox'>";
							html += "			<input type='checkbox' name='evalChk' id='evalChk"+i+"' data-stdNo='"+v.stdNo+"' user_id='"+v.userId+"' user_nm='"+v.userNm+"' mobile='"+v.mobileNo+"' email='"+v.email+"' onchange='checkStd(this)'>";
							html += "			<label class='toggle_btn' for='evalChk"+i+"'></label>";
							html += "		</div>";
							html += "	</td>";
							html += "	<td>"+v.lineNo+"</td>";
							html += "	<td>"+v.deptNm+"</td>";
							html += "	<td>"+v.userId+"</td>";
							html += "	<td>"+v.userNm+"</td>";
							html += "	<td>"+v.stareYn+"</td>";
							html += "	<td>"+v.absentYn+"</td>";
							html += "	<td>"+absentNm+"</td>";
							html += "	<td><button type='button' class='ui basic small button' onclick='removeReStare(\""+v.stdNo+"\")'><spring:message code='button.delete'/></button></td>";
							html += "</tr>";
						});
					}
					
					$("#stdTbody").empty().html(html);
					$("#stdTable").footable();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
	            /* 리스트 조회 중 에러가 발생하였습니다. */
	            alert("<spring:message code='exam.error.list' />");
			}, true);
		}
		
		// 대체평가 대상자 삭제
		function removeReStare(stdNo) {
			var url  = "/exam/insTargetCancel.do";
			var data = {
				"examCd"  : "${vo.examCd}",
				"stdNo"   : stdNo
			};
	
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					alert("<spring:message code='exam.alert.delete' />");/* 정상 삭제 되었습니다. */
					insStdList();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
	            /* 삭제 중 에러가 발생하였습니다. */
	            alert("<spring:message code='exam.error.delete' />");
			}, true);
		}
		
		// 체크박스
		function checkStd(obj) {
			if(obj.value == "all") {
				$("input[name=evalChk]").prop("checked", obj.checked);
			} else {
				$("#evalChkAll").prop("checked", $("input[name=evalChk]").length == $("input[name=evalChk]:checked").length);
			}
		}
		
		// 메세지 보내기
		function sendMsg(type) {
			var rcvUserInfoStr = "";
			var sendCnt = 0;
			
			$.each($('#stdTbody').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
				sendCnt++;
				if (sendCnt > 1) rcvUserInfoStr += "|";
				rcvUserInfoStr += $(this).attr("user_id");
				rcvUserInfoStr += ";" + $(this).attr("user_nm"); 
				rcvUserInfoStr += ";" + $(this).attr("mobile");
				rcvUserInfoStr += ";" + $(this).attr("email"); 
			});
			
			if (sendCnt == 0) {
				/* 메시지 발송 대상자를 선택하세요. */
				alert("<spring:message code='common.alert.sysmsg.select_user'/>");
				return;
			}
			
	        window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
	
	        var form = document.alarmForm;
	        form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
	        form.target = "msgWindow";
	        form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
	        form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
	        form.submit();
		}
		
		// 수시평가 퀴즈 문항관리
		function insQuizPageView(examCd) {
			var url = "/quiz/quizQstnManage.do";
			var kvArr = [];
			kvArr.push({'key' : 'examCd',   'val' : examCd});
			kvArr.push({'key' : 'crsCreCd', 'val' : "${crsCreCd}"});
			
			submitForm(url, "", "", kvArr);
		}
		
		// 팀선택 옵션 설정
		function createTeamSelectOption() {
			var html = '';
			
			DECLS_LIST.forEach(function(v, i) {
				html += "<div class='ui action fluid input' id='teamCtgrView" + i + "' ";

				if("${vo.crsCreCd}" != v.crsCreCd){
					html += " style= 'display: none;'";
				}

				html += ">";
				html += "    <label class='ui basic small label flex-item-center m-w3 m0'>" + v.declsNo + "<spring:message code='asmnt.label.decls.name' /> : </label>";
				html += "    <input type='hidden' id='teamCtgrCd" + i + "' name='teamCtgrList'";

				if("${vo.crsCreCd}" != v.crsCreCd){
					html += " disabled='disabled'";
				}

				html += ">";
				html += "    <input type='text' id='teamCtgr" + i + "' placeholder='<spring:message code="asmnt.alert.select.team.ctgr" />' readonly>";
				html += "    <a class='ui black button' onclick=\"teamCtgrSelectPop('"+i+"','"+v.crsCreCd+"')\"><spring:message code='bbs.label.form_assign_team' /></a>";
				html += "</div>";
			});
			
			$("#viewTeam").html(html);
		}
		
		// 팀 지정 팝업
	    function teamCtgrSelectPop(i, crsCreCd) {
			var title = "<spring:message code='bbs.label.select_team_ctgr'/>"; // 팀 분류 선택
			var kvArr = [];
			kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
			kvArr.push({'key' : 'searchFrom', 'val' : i + ":" + crsCreCd});
	
			submitForm("/team/teamHome/teamCtgrSelectPop.do", "examPopIfm", title, kvArr);
		}
		
	 	// 팀 분류 선택
	    function selectTeam(teamCtgrCd, teamCtgrNm, id) {
	    	var idList = id.split(':');
	    	$("#teamCtgrCd" + idList[0]).val(teamCtgrCd + ":" + idList[1]);
	    	$("#teamCtgr" + idList[0]).val(teamCtgrNm);
	    }
	</script>
</head>
<body class="<%=SessionInfo.getThemeMode(request)%>">
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>

        <div id="container">
            <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>
            <!-- 본문 content 부분 -->
            <div class="content">
            	<%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
        		<div class="ui form">
        			<div class="layout2">
        				<c:set var="examTypeStr"><spring:message code="exam.label.mid.end.exam" /><!-- 중간/기말 --></c:set>
        				<c:if test="${examType eq 'ADMISSION' }"><c:set var="examTypeStr"><spring:message code="exam.label.always.exam" /><!-- 수시평가 --></c:set></c:if>
        				<script>
						$(document).ready(function () {
							// set location
							setLocationBar('${examTypeStr}', '<spring:message code="exam.button.reg" />');
						});
						</script>
		                <div id="info-item-box">
		                	<h2 class="page-title flex-item flex-wrap gap4 columngap16">${examTypeStr }</h2>
		                    <div class="button-area">
		                    	<c:if test="${!(examType eq 'ADMISSION' && vo.examTypeCd eq 'EXAM') }">
			                    	<a href="javascript:saveConfirm()" class="ui blue button"><spring:message code="exam.button.save" /></a><!-- 저장 -->
		                    	</c:if>
		                        <a href="javascript:viewExamList()" class="ui blue button"><spring:message code="exam.button.list" /></a><!-- 목록 -->
		                    </div>
		                </div>
		                <div class="row">
		                	<div class="col">
				                <form name="writeExamForm" id="writeExamForm" method="POST" autocomplete="off">
				                	<input type="hidden" name="crsCreCd" 		value="${vo.crsCreCd }" />
				                	<input type="hidden" name="examCd" 			value="${vo.examCd }" />
				                	<input type="hidden" name="declsRegYn" 		value="N" />
				                	<input type="hidden" name="scoreRatio" 		value="${empty vo.examCd ? '0' : vo.scoreRatio }" />
				                	<input type="hidden" name="dsbdYn" 			value="N" />
				                	<input type="hidden" name="dsbdTm" 			value="0" />
				                	<input type="hidden" name="stareLimitCnt" 	value="99" />
				                	<input type="hidden" name="tmLimitYn"		value="Y" />
				                	<input type="hidden" name="reExamYn"		value="${empty vo.reExamYn ? 'N' : vo.reExamYn }"				id="reExamYn" />
				                	<input type="hidden" name="examStartDttm" 	value="${vo.examStartDttm }"   									id="examStartDttm" />
				                	<input type="hidden" name="examEndDttm" 	value="${vo.examEndDttm }"     									id="examEndDttm" />
				                	<input type="hidden" name="avgScoreOpenYn" 	value="${empty quizVO.avgScoreOpenYn ? empty vo.avgScoreOpenYn ? 'N' : vo.avgScoreOpenYn : quizVO.avgScoreOpenYn }"  	id="avgScoreOpenYn" />
				                	<input type="hidden" name="qstnSetTypeCd" 	value="RANDOM" />
				                	<input type="hidden" name="emplRandomYn" 	value="${quizVO.emplRandomYn }"    								id="emplRandomYn" />
				                	<input type="hidden" name="reExamStartDttm" value="${quizVO.reExamStartDttm }" 								id="reExamStartDttm" />
				                	<input type="hidden" name="reExamEndDttm" 	value="${quizVO.reExamEndDttm }"   								id="reExamEndDttm" />
				                	<input type="hidden" name="insRefCd" 		value="${vo.insRefCd }" 	   									id="insRefCd" />
				                	<input type="hidden" name="scoreAplyYn"		value="Y" />
				                	<input type="hidden" name="scoreOpenYn"		value="Y" />
				                	<input type="hidden" name="examStareTypeCd" value="${vo.examStareTypeCd }" />
				                	<input type="hidden" name="fileSns"		    value="" id="fileSns" />
						            <input type="hidden" name="searchTo"	    value="" id="searchTo"/>
						            <input type="hidden" name="uploadFiles"	    value="" id="uploadFiles"/>
						            <input type="hidden" name="copyFiles"	    value="" id="copyFiles" />
						            <input type="hidden" name="uploadPath"	    value="" id="uploadPath" />
						            <input type="hidden" name="insStartDttm"	value="" id="insStartDttm" />
						            <input type="hidden" name="insEndDttm"		value="" id="insEndDttm" />
						            <input type="hidden" name="extSendDttm"		value="" id="extSendDttm" />
						            <input type="hidden" name="goUrl"			value="EXAM" />
					                <div class="ui form" id="examWriteDiv">
										<div class="ui segment">
											<c:set var="stareTypeNm">
												<c:if test="${(vo.examStareTypeCd eq 'M' || vo.examStareTypeCd eq 'L') && orgId ne 'ORG0000001' }">
													<c:choose>
														 <c:when test="${vo.examTypeCd eq 'EXAM' }">
														 	[<spring:message code="exam.label.subs" /><!-- 대체평가 -->]
														 </c:when>
														 <c:otherwise>
														 	[<spring:message code="exam.label.etc" /><!-- 기타 -->]
														 </c:otherwise>
													</c:choose>
												</c:if>
												<c:if test="${vo.examStareTypeCd eq 'M' }"><spring:message code="exam.label.mid.exam" /><!-- 중간고사 --></c:if>
												<c:if test="${vo.examStareTypeCd eq 'L' }"><spring:message code="exam.label.end.exam" /><!-- 기말고사 --></c:if>
												<c:if test="${vo.examStareTypeCd eq 'A' }"><spring:message code="exam.label.always.exam" /><!-- 수시평가 --> <spring:message code="exam.label.subs" /><!-- 대체평가 --></c:if>
												<c:if test="${empty vo.insRefCd }"><spring:message code="exam.button.reg" /><!-- 등록 --></c:if>
												<c:if test="${not empty vo.insRefCd }"><spring:message code="exam.button.mod" /><!-- 수정 --></c:if>
											</c:set>
											<h3 class="mb10">${stareTypeNm }</h3>
										    <ul class="tbl border-top-grey">
										    	<c:choose>
											    	<c:when test="${examType eq 'ADMISSION' }">
												        <li>
												            <dl>
												                <dt><label for="examTitle" class="req"><spring:message code="exam.label.admission.nm" /></label></dt><!-- 수시평가명 -->
												                <dd>
												                    <div class="ui fluid input">
												                        <input type="text" name="examTitle" id="examTitle" value="${vo.examTitle }" ${(vo.examStareTypeCd eq 'M' || vo.examStareTypeCd eq 'L') && vo.examTypeCd eq 'EXAM' ? 'readonly' : '' }>
												                    </div>
												                </dd>
												            </dl>
												        </li>
											    	</c:when>
										    		<c:otherwise>
										    			<c:choose>
										    				<c:when test="${empty vo.examTitle }">
										    					<c:if test="${vo.examStareTypeCd eq 'M' }">
											    					<input type="hidden" name="examTitle" value="중간고사" />
										    					</c:if>
										    					<c:if test="${vo.examStareTypeCd eq 'L' }">
										    						<input type="hidden" name="examTitle" value="기말고사" />
										    					</c:if>
										    				</c:when>
										    				<c:otherwise>
										    					<input type="hidden" name="examTitle" value="${vo.examTitle }" />
										    				</c:otherwise>
										    			</c:choose>
										    		</c:otherwise>
										    	</c:choose>
										        <li>
										            <dl>
										                <dt><label class="req"><spring:message code="exam.label.exam" /> <spring:message code="exam.label.type" /></label></dt><!-- 시험 --><!-- 유형 -->
										                <dd>
										                    <div class="fields">
										                        <div class="field">
										                            <div class="ui radio checkbox">
										                                <input type="radio" name="examTypeCd" tabindex="0" value="QUIZ" class="hidden" onChange="examTypeChk()" ${not empty quizVO ? 'checked' : '' }>
										                                <label><spring:message code="exam.label.quiz" /></label><!-- 퀴즈 -->
										                            </div>
										                        </div>
										                        <c:if test="${vo.examStareTypeCd eq 'M' || vo.examStareTypeCd eq 'L' }">
											                        <div class="field">
											                            <div class="ui radio checkbox">
											                                <input type="radio" name="examTypeCd" tabindex="0" value="ASMNT" class="hidden" onChange="examTypeChk()" ${not empty asmtVO ? 'checked' : '' }>
											                                <label><spring:message code="asmnt.label.asmnt" /></label><!-- 과제 -->
											                            </div>
											                        </div>
											                        <div class="field">
											                            <div class="ui radio checkbox">
											                                <input type="radio" name="examTypeCd" tabindex="0" value="FORUM" class="hidden" onChange="examTypeChk()" ${not empty forumVO ? 'checked' : '' }>
											                                <label><spring:message code="forum.label.forum" /></label><!-- 토론 -->
											                            </div>
											                        </div>
										                        </c:if>
										                    </div>
										                </dd>
										            </dl>
										        </li>
										    </ul>
										    <div class="ui segment" id="insWriteDiv" style="display:none;">
										    </div>
										</div>
					                </div>
				                </form>
			                	<div class="option-content mt20">
			                		<div class="mla">
				                    	<a href="javascript:saveConfirm()" class="ui blue button"><spring:message code="exam.button.save" /></a><!-- 저장 -->
				                        <a href="javascript:viewExamList()" class="ui blue button"><spring:message code="exam.button.list" /></a><!-- 목록 -->
			                		</div>
			                    </div>
			                    <c:if test="${not empty vo.examCd && vo.examTypeCd eq 'EXAM' }">
				                    <div class="option-content mt30">
				                    	<h3 class="sec_head">
				                    		<c:if test="${vo.examStareTypeCd eq 'M' }"><spring:message code="exam.label.mid.exam" /><!-- 중간고사 --></c:if>
				                    		<c:if test="${vo.examStareTypeCd eq 'L' }"><spring:message code="exam.label.end.exam" /><!-- 기말고사 --></c:if>
				                    		<spring:message code="exam.label.ins.target" /><!-- 대체평가 대상자 -->
				                    	</h3>
				                    	<div class="mla">
				                    		<uiex:msgSendBtn func="sendMsg()" styleClass="ui basic small button"/><!-- 메시지 -->
				                    		<a href="javascript:examInsTargetPop('${vo.examCd }')" class="ui blue small button"><spring:message code="exam.label.ins.target.set" /></a><!-- 대상자 설정 -->
				                    		<a href="javascript:examInsTargetCancel('${vo.examCd }')" class="ui blue small button"><spring:message code="exam.label.ins.target.cancel" /></a><!-- 대상자 취소 -->
				                    	</div>
				                    </div>
				                    <table class="table type2" id="stdTable" data-sorting="true" data-paging="false" data-empty="<spring:message code='exam.label.exam.ins.target.none' />" id="examEtcListTable"><!-- '대상자설정' 버튼을 클릭 후 대상자를 설정해주세요. -->
				                    	<thead>
				                    		<tr>
				                    			<th>
				                    				<div class="ui checkbox">
											             <input type="checkbox" name="evalChkAll" id="evalChkAll" value="all" onchange="checkStd(this)">
											             <label class="toggle_btn" for="evalChkAll"></label>
											        </div>
				                    			</th>
				                    			<th><spring:message code="common.number.no" /><!-- NO --></th>
				                    			<th><spring:message code="exam.label.dept" /><!-- 학과 --></th>
				                    			<th><spring:message code="exam.label.user.no" /><!-- 학번 --></th>
				                    			<th><spring:message code="exam.label.user.nm" /><!-- 이름 --></th>
				                    			<th><spring:message code="exam.label.exam" /><!-- 시험 --><spring:message code="exam.label.yes.stare" /><!-- 응시 --></th>
				                    			<th><spring:message code="exam.label.absent" /><!-- 결시원 --><spring:message code="exam.label.submit.y" /><!-- 제출 --></th>
				                    			<th><spring:message code="exam.label.absent" /><!-- 결시원 --><spring:message code="exam.label.approve" /><!-- 승인 --></th>
				                    			<th><spring:message code="exam.label.manage" /><!-- 관리 --></th>
				                    		</tr>
				                    	</thead>
				                    	<tbody id="stdTbody">
				                    	</tbody>
				                    </table>
				                    <div class="option-content">
				                    	<div class="mla">
				                    		<a href="javascript:viewExamList()" class="ui blue button"><spring:message code="exam.button.list" /></a><!-- 목록 -->
				                    	</div>
				                    </div>
			                    </c:if>
		                	</div>
		                </div>
        			</div>
        		</div>
            </div>
            <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
        </div>
        <!-- //본문 content 부분 -->
    </div>
    
</body>
</html>