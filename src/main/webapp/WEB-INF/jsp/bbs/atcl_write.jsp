<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<c:choose>
	<c:when test="${templateUrl eq 'bbsHome' or templateUrl eq 'bbsLect'}">
		<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
	</c:when>
	<c:when test="${templateUrl eq 'bbsMgr'}">
		<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	</c:when>
</c:choose>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%-- 에디터 --%>
<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp"%>
<c:choose>
	<c:when test="${templateUrl eq 'bbsHome'}">
		<link rel="stylesheet" type="text/css" href="/webdoc/css/main_default.css?v=3" />
	</c:when>
	<c:when test="${templateUrl eq 'bbsLect'}">
		<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
	</c:when>
	<c:when test="${templateUrl eq 'bbsMgr'}">
		<link rel="stylesheet" type="text/css" href="/webdoc/css/admin/admin-default.css" />
	</c:when>
</c:choose>
<!-- 게시판 공통 -->
<%@ include file="/WEB-INF/jsp/bbs/common/bbs_common_inc.jsp" %>
<%
	request.setAttribute("PAGE_FILE_UPLOAD", request.getContextPath() + CommConst.PAGE_FILE_UPLOAD);
%>
<script type="text/javascript">
	var BBS_CD 			= '<c:out value="${param.bbsCd}" />';
	var CRS_CRE_CD		= '<c:out value="${param.crsCreCd}" />';
	var TEAM_CTGR_CD	= '<c:out value="${param.teamCtgrCd}" />';
	var TEAM_CD			= '<c:out value="${param.teamCd}" />';
	var SEARCH_VALUE	= '<c:out value="${param.searchValue}" />';
	var PAGE_INDEX		= '<c:out value="${param.pageIndex}" />';
	var LIST_SCALE		= '<c:out value="${param.listScale}" />';
	var TAB 			= '<c:out value="${param.tab}" />';
	var BBS_ID 			= '<c:out value="${param.bbsId}" />';
	var ATCL_ID 		= '<c:out value="${param.atclId}" />';
	var TEMPLATE_URL 	= '<c:out value="${templateUrl}" />';

	$(document).ready(function() {
		var crsCreCd = $("#crsCreCd").val();
		var bbsId = '<c:out value="${bbsInfoVO.bbsId}" />';
		var bbsCd = '<c:out value="${bbsInfoVO.bbsCd}" />';
		var sysUseYn = '<c:out value="${bbsInfoVO.sysUseYn}" />';
		var sysDefaultYn = '<c:out value="${bbsInfoVO.sysDefaultYn}" />';
		var alarmBbsInfo = {
			  NOTICE: true
			, QNA: true
			, SECRET: true
			, PDS: true
		};
		var atclId = '<c:out value="${bbsAtclVO.atclId}" />';
		
		// 강의실
		if(TEMPLATE_URL == "bbsLect") {
			var isAlarmBbs = sysUseYn == "N" && sysDefaultYn == "Y" && alarmBbsInfo[bbsCd];
			
			// 알림터 글쓰기 일경우 (교수자)
			if(isAlarmBbs && !atclId && !bbsCommon.isStudent()) {
				// 알림터 [강의공지, 강의자료실] 라디오 세팅
				changeCrsCreCd(crsCreCd, bbsCd);
			} else {
				if(BBS_CD == "TEAM") {
					if(atclId) {
						// 팀지정 옵션 초기화
						writeOption.initTeamWriteForm();
						initBbsForm(bbsId);
					} else {
						// 팀지정 옵션 초기화
						writeOption.initTeamWriteForm();
					}
				} else {
					initBbsForm(bbsId);
				}
			}
		} else {
			initBbsForm(bbsId);
		}
	});
	
	var writeOption = {
		bbsInfo: null,
		userType: null,
		isEdit: '<c:out value="${bbsAtclVO.atclId}" />' ? true : false,
		// 공지옵션 HTML 생성
		createNotiOptionHtml: function() {
			var html = '';
			var imptYnChecked = '<c:out value="${bbsAtclVO.imptYn}" />' == "Y" ? "checked" : "";
			var noticeYnChecked = '<c:out value="${bbsAtclVO.noticeYn}" />' == "Y" ? "checked" : "";
			
			var noticeText = '<spring:message code="bbs.label.fix_atcl" />'; // 고정글
			
			html += '<dl>';
			html += '	<dt>';
			html += '		<label><spring:message code="bbs.label.form_main_option" /></label>'; // 주요옵션
			html += '	</dt>';
			html += '	<dd>';
			html += '		<div class="fields">';
			html += '			<div class="field">';
			html += '				<div class="ui checkbox">';
			html += '					<label for="imptYn" class="hide">Important</label>';
			html += '					<input type="checkbox" id="imptYn" class="hidden" name="imptYn" value="Y" ' + imptYnChecked + ' />';
			html += '					<label class="toggle_btn" for="imptYn"><spring:message code="bbs.label.impt_atcl" /></label>'; // 중요글
			html += '				</div>';
			html += '			</div>';
			html += '			<div class="field">';
			html += '				<div class="ui checkbox">';
			html += '					<label for="noticeYn" class="hide">Notice</label>';
			html += '					<input type="checkbox" id="noticeYn" class="hidden" name="noticeYn" value="Y" ' + noticeYnChecked + ' />';
			html += '					<label class="toggle_btn" for="noticeYn">' + noticeText + '</label>'; // 고정글
			html += '				</div>';
			html += '			</div>';
			html += '		</div>';
			html += '	</dd>';
			html += '</dl>';
			
			return html;
		},
		// 문의/상담 옵션 HTML 생성
		createSecretOptionHtml: function(councelProflist) {
			var html = '';
			var councelProf =  '<c:out value="${bbsAtclVO.councelProf}" />';
			//var councelProfDisabled = this.isEdit ? "disabled" : ":";
			var councelProfListHtml = "";
			var councelProfSelected;
			
			councelProflist.forEach(function(v, i) {
				councelProfSelected = councelProf == v.userId ? "selected" : "";
				councelProfListHtml += '<option value="' + v.userId + '" ' + councelProfSelected + ' >' + v.userNm + ' (' + v.userId + ')</option>';
			});
			
			html += '<dl>';
			html += '	<dt>';
			html += '		<label><spring:message code="bbs.label.form_main_option" /></label>'; // 주요옵션
			html += '	</dt>';
			html += '	<dd>';
			html += '		<div class="fields">';
			html += '			<div class="field" style="z-index:1000">';
			html += '				<label for="councelProf" class="hide">Professor</label>';
			html += '				<select class="ui dropdown w200" id="councelProf" name="councelProf">';
			html += '					<option value=""><spring:message code="bbs.label.select_secret_prof" /></option>'; // 교수/조교 선택
			html += 					councelProfListHtml;
			html += '				</select>';
			html += '			</div>';
			html += '		</div>';
			html += '	</dd>';
			html += '</dl>';
			
			return html;
		},
		// 팀지정 옵션
		createTeamSelectOptionHtml: function(teamCtgrList) {
			var teamCtgrNm = '<c:out value="${bbsAtclVO.teamCtgrNm}" />';
			var teamNm = '<c:out value="${bbsAtclVO.teamNm}" />';
			
			var html = '';
			var teamCtgrListHtml = '';
			teamCtgrList.forEach(function(v, i) {
				teamCtgrListHtml += '<option value="' + v.teamCtgrCd + '">' + v.teamCtgrNm + '</option>'; 
			});
			
			html += '<dl>';
			html += '	<dt>';
			html += '		<label class="req"><spring:message code="bbs.label.form_assign_team" /></label>'; // 팀지정
			html += '	</dt>';
			html += '	<dd>';
		if(this.isEdit) {
			html += '		<div class="fields">';
			html += '			<div class="field" style="z-index:1000">';
			html += '				<select class="ui dropdown mr5" disabled>';
			html += '					<option value="">' + teamCtgrNm + '</option>';
			html += '				</select>';
			html += '			</div>';
			html += '			<div class="field" style="z-index:1000">';
			html += '				<select class="ui dropdown mr5" disabled>';
			html += '					<option value="">' + teamNm + '</option>';
			html += '				</select>';
			html += '			</div>';
			html += '		</div>';
		} else {
			html += '		<div class="fields">';
			html += '			<div class="field" style="z-index:1000">';
			html += '				<select class="ui dropdown mr5" id="teamCtgrCd">';
			html += '					<option value=""><spring:message code="bbs.label.select_team_ctgr" /></option>'; // >팀 분류 선택
			html += 					teamCtgrListHtml;
			html += '				</select>';
			html += '			</div>';
			html += '			<div class="field" style="z-index:1000">';
			html += '				<select class="ui dropdown mr5" id="teamCd">';
			html += '					<option value=""><spring:message code="bbs.label.select_team" /></option>'; // 팀 선택
			html += '				</select>';
			html += '			</div>';
			html += '		</div>';
		}
			html += '	</dd>';
			html += '</dl>';
			
			return html;
		},
		// 파일첨부 옵션 HTML 생성
		createAtchFileOptionHtml: function() {
			var html = '';
			
			html += '<dl>';
			html += '	<dt>';
			html += '		<label for="uploaderBox"><spring:message code="bbs.label.form_attach_file" /></label>'; // 첨부파일
			html += '	</dt>';
			html += '	<dd>';
			html += '		<div id="upload1-container" class="dext5-container" style="width:100%;height:180px"></div>';
			html += '		<div id="upload1-btn-area" class="dext5-btn-area"><button type="button" id="upload1_btn-add"><spring:message code="button.select.file"/></button>';
			html += '<button type="button" id="upload1_btn-filebox"><spring:message code="button.from_filebox"/></button>';
			html += '<button type="button" id="upload1_btn-delete"><spring:message code="button.delete"/></button></div>';
			html += '	</dd>';
			html += '</dl>';
			
			return html;
		},
		// 부가 옵션 HTML 생성
		createEtcOptionHtml: function() {
			var html = '';
			var cmntUseYnChecked = (!this.isEdit || '<c:out value="${bbsAtclVO.cmntUseYn}" />' == "Y") || '<c:out value="${bbsInfoVO.bbsCd}" />' == "TEAM" ? "checked" : "";
			var goodUseYnChecked = '<c:out value="${bbsAtclVO.goodUseYn}" />' == "Y" ? "checked" : "";
			var bbsCd = this.bbsInfo.bbsCd;
			html += '<dl>';
			html += '	<dt>';
			html += '		<label><spring:message code="bbs.label.form_sub_option" /></label>'; // 부가옵션
			html += '	</dt>';
			html += '	<dd>';
			html += '		<div class="fields">';
		if(this.bbsInfo.cmntUseYn == 'Y') {
			html += '			<div class="field">';
			html += '				<div class="ui checkbox">';
			html += '					<label for="cmntUseYn" class="hide">Comment</label>';
			html += '					<input type="checkbox" id="cmntUseYn" name="cmntUseYn" class="hidden" value="Y" ' + cmntUseYnChecked + ' /> ';
			html += '					<label class="toggle_btn" for="cmntUseYn"><spring:message code="bbs.button.use_comment" /></label>'; // 댓글사용
			html += '				</div>';
			html += '			</div>';
		}
		if(this.bbsInfo.goodUseYn == 'Y' && bbsCd == 'PDS') {
			html += '			<div class="field">';
			html += '				<div class="ui checkbox">';
			html += '					<label for="goodUseYn" class="hide">Good</label>';
			html += '					<input type="checkbox" id="goodUseYn" name="goodUseYn" class="hidden" value="Y" ' + goodUseYnChecked + ' /> ';
			html += '					<label class="toggle_btn" for="goodUseYn"><spring:message code="bbs.button.use_good" /></label>'; // 좋아요 사용
			html += '				</div>';
			html += '			</div>';
		}
			html += '		</div>';
			html += '	</dd>';
			html += '</dl>';
			
			return html;
		},
		// 분반 같이 등록 옵션 HTML 생성
		createDeclsOptionHtml: function(declsList) {
			var html = '';
			var declsListHtml = '';
			var isEdit = this.isEdit;
			
			declsList.forEach(function(v, i) {
				var id = "decls_" + v.crsCreCd;
				var checked = v.crsCreCd == CRS_CRE_CD ? "checked" : "";
				var disabled = v.crsCreCd == CRS_CRE_CD ? "disabled" : "";
				
				declsListHtml += '<div class="fields">';
				declsListHtml += '	<div class="field">';
				declsListHtml += '		<div class="ui checkbox">';
				declsListHtml += '			<label for="' + id + '" class="hide">Division</label>';
				if(isEdit) {
					declsListHtml += '		<input type="checkbox" id="' + id + '" name="" class="hidden" value="" checked disabled /> ';
				} else {
					declsListHtml += '		<input type="checkbox" id="' + id + '" name="declsList" class="hidden" value="' + v.crsCreCd + '" ' + checked + ' ' + disabled + '/> ';
				}
				declsListHtml += '			<label class="toggle_btn" for="' + id + '">';
				declsListHtml +=  				v.crsCreNm + ' (' + v.declsNo + '<spring:message code="bbs.label.class" />)'; // 반
				declsListHtml += '			</label>';
				declsListHtml += '		</div>';
				declsListHtml += '	</div>';
				declsListHtml += '</div>';
			});
			
			html += '<dl>';
			html += '	<dt>';
			html += '		<label><spring:message code="bbs.label.form_decls" /></label>'; // 분반 같이 등록
			html += '	</dt>';
			html += '	<dd>';
			html += 		declsListHtml;
			if(declsList.length > 1) {
				html += '		<div class="ui small warning message">';
				html += '			<i class="info circle icon"></i>';
				html += '			<spring:message code="bbs.label.decls.info" />';/* 선택한 분반에 일괄 적용됩니다. */
				html += '		</div>';
			}
			html += '	</dd>';
			html += '</dl>';
			
			return html;
		},
		// 등록 예약 옵션 HTML 생성
		createWriteResvOptionHtml: function() {
			var html = '';
			var rsrvUseYnChecked = '<c:out value="${bbsAtclVO.rsrvUseYn}" />' == "Y" ? "checked" : "";
			var rsrvDttm = '<c:out value="${bbsAtclVO.rsrvDttm}" />';
			var visibility = rsrvUseYnChecked == "checked" ? "visible" : "hidden";
			
			html += '<dl>';
			html += '	<dt>';
			html += '		<label><spring:message code="bbs.label.form_write_resv" /></label>'; // 등록 예약
			html += '	</dt>';
			html += '	<dd>';
			html += '		<input type="hidden" id="rsrvDttm" name="rsrvDttm" value="' + rsrvDttm + '" />';
			html += '		<div class="fields">';
			html += '			<div class="field">';
			html += '				<div class="ui toggle checkbox">';
			html += '					<label for="rsrvUseYn"></label>';
			html += '					<input type="checkbox" id="rsrvUseYn" name="rsrvUseYn" class="hidden" value="Y" ' + rsrvUseYnChecked + ' />';
			html += '				</div>';
			html += '			</div>';
			html += '			<div class="inline field">';
			html += '				<div class="equal width fields mb0">';
			html += '					<div class="field flex" id="rsrvDttmArea" style="visibility: ' + visibility + ';">';
			html += '						<div class="ui calendar w150 mr5" id="rsrvDttmCal" dateval="'+rsrvDttm+'">';
			html += '							<div class="ui input left icon">';
			html += '								<i class="calendar alternate outline icon"></i>';
			html += '								<label for="rsrvDttmText" class="hide">Reserv date</label>';
			html += '								<input type="text" id="rsrvDttmText" placeholder="<spring:message code="bbs.common.placeholder_write_resv" />" autocomplete="off" value="" />'; // 예약일시
			html += '							</div>';
			html += '						</div>';
			html += '						<label for="rsrvDttmHH" class="hide">Reserv hour</label>';
			html += "                       <select class='ui dropdown list-num flex0 mr5' id='rsrvDttmHH' caltype='hour'>";
			html += "                           <option value=' '><spring:message code='date.hour'/></option>";
			html += "                       </select>";
			html += '						<label for="rsrvDttmMM" class="hide">Reserv min</label>';
			html += "                       <select class='ui dropdown list-num flex0 mr5' id='rsrvDttmMM' caltype='min'>";
			html += "                           <option value=' '><spring:message code='date.minute'/></option>";
			html += "                       </select>";
			html += '					</div>';
			html += '				</div>';
			html += '			</div>';
			html += '		</div>';
			html += '	</dd>';
			html += '</dl>';
			
			return html;
		},
		// 공개여부 옵션 HTML 생성
		createLockOptionHtml: function() {
			var html = '';
			var lockYnChecked;
			var lockYn = '<c:out value="${bbsAtclVO.lockYn}" />';
			
			if(!this.isEdit) {
				// 글쓰기 기본 공개
				lockYnChecked = "checked";
			} else {
				lockYnChecked = lockYn == "N" ? "checked" : "";
			}
			
			html += '<dl>';
			html += '	<dt>';
			html += '		<label><spring:message code="bbs.label.form_public_yn" /></label>'; // 공개여부
			html += '	</dt>';
			html += '	<dd>';
			html += '		<div class="fields">';
			html += '			<div class="field">';
			html += '				<div class="ui toggle checkbox">';
			html += '					<label for="lock" class=""></label>';
			html += '					<input type="checkbox" id="lock" class="hidden" value="N" ' + lockYnChecked + ' />';
			html += '					<input type="hidden" name="lockYn" value="' + lockYn + '"   id="lockYn" />';
			html += '				</div>';
			html += '			</div>';
			html += '		</div>';
			html += '	</dd>';
			html += '</dl>';
			
			return html;
		},
		// 년도/학기 옵션 HTML 생성
		createTermOptionHtml: function() {
			var noticeType = "TERM";
			var haksaYear = '<c:out value="${bbsAtclVO.haksaYear}" />';
			var haksaTerm = '<c:out value="${bbsAtclVO.haksaTerm}" />';
			
			if(this.isEdit && (!haksaYear || !haksaTerm)) {
				noticeType = "ALL";
			}
			
			var html = '';
			
			html += '<dl>';
			html += '	<dt>';
			html += '		<label><spring:message code="bbs.label.notice.period" /></label>'; // 공지기간
			html += '	</dt>';
			html += '	<dd>';
			html += '		<div class="fields">';
			html += '			<div class="field inline-flex-item">';
			html += '				<div class="ui radio checkbox">';
			html += '					<label for="allNotice" class="hide">Term Notice</label>';
			html += '					<input type="radio" value="ALL" name="noticeType" id="allNotice" ' + (noticeType == "ALL" ? "checked" : "") + ' />';
			html += '					<label for="allNotice" style="cursor:pointer;"><spring:message code="common.all" /></label>'; // 전체
			html += '				</div>';
			html += '			</div>';
			html += '			<div class="field inline-flex-item">';
			html += '				<div class="ui radio checkbox">';
			html += '					<label for="termNotice" class="hide">All Notice</label>';
			html += '					<input type="radio" value="TERM" name="noticeType" id="termNotice" ' + (noticeType == "TERM" ? "checked" : "") + ' />';
			html += '					<label for="termNotice" style="cursor:pointer;"><spring:message code="common.term" /></label>'; // 학기
			html += '				</div>';
			html += '			</div>';
			html += '			<div class="field" style="display:none;" id="yearTermSelectDiv">';
			html += '				<div>';
			html += '					<select id="haksaYearSelect" class="ui dropdown mr5">';
			<c:forEach var="item" items="${yearList}">
			html += '						<option value="${item}" ${termVO.haksaYear eq item || bbsAtclVO.haksaYear eq item ? "selected" : ""}>${item}</option>';
			</c:forEach>
			html += '					</select>';
			html += '					<select id="haksaTermSelect" class="ui dropdown">';
			<c:forEach var="item" items="${termList}">
			html += '						<option value="${item.codeCd}" ${termVO.haksaTerm eq item.codeCd || bbsAtclVO.haksaTerm eq item.codeCd ? "selected" : ""}>${item.codeNm}</option>';
			</c:forEach>
			html += '					</select>';
			html += '				</div>';
			html += '			</div>';
			html += '		</div>';
			html += '	</dd>';
			html += '</dl>';
			
			return html;
		},
		// 중요글, 고정글
		useNoti: function() {
			// 공지 사용 여부
			if(this.bbsInfo.notiUseYn != "Y") return;
			
			if(TEMPLATE_URL == "bbsLect") {
				// 교수만 이용가능
				if(!bbsCommon.isProfessor()) return;
			} else {
				// 관리자만 이용가능
				if(!bbsCommon.isAdmin()) return;
			}
			
			$("#notiOptionLi").show().html(this.createNotiOptionHtml());
			
			// 중요글, 고정글 1개만 체크
			$("#imptYn, #noticeYn").on("change", function() {
				if(this.checked) {
					if(this.id == "imptYn") {
						$("#noticeYn").prop("checked", false);
					}
					
					if(this.id == "noticeYn") {
						$("#imptYn").prop("checked", false);
					}
				}
			});
		},
		useSecret: function() {
			var url = "/bbs/bbsLect/councelProflist.do";
			var data = {
				crsCreCd: $("#crsCreCd").val()
			};
			
			// 상담교수 목록 조회
			$.ajax({
	            url : url,
	            type : "get",
	            data: data,
	            async: false, // 동기
	        }).always(function(data) {
	        	var returnList = data && data.returnList || [];
	        	$("#secretOptionLi").show().html(writeOption.createSecretOptionHtml(returnList));
	        });
		},
		useTeamSelectOption: function() {
			var crsCreCd = $("#crsCreCd").val();
			// 팀분류 조회
			var url = "/bbs/bbsLect/listTeamCtgr.do";
			var data = {
				crsCreCd: crsCreCd
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					$("#teamSelectOptionLi").show().html(writeOption.createTeamSelectOptionHtml(returnList));
					$("#teamSelectOptionLi").find(".ui.dropdown").dropdown();
					
					// 팀 카테고리 선택 이벤트
					$("#teamCtgrCd").dropdown("clear");
					$("#teamCtgrCd").on("change", function(){
						$("#bbsId").val(""); // 게시판 선택 초기화
						$("#teamCd").empty();
						$("#teamCd").off("change");
						
						// 팀 조회
						var url = "/bbs/bbsLect/listTeamBbsId.do";
						var data = {
							  crsCreCd: crsCreCd
							, teamCtgrCd: this.value
						};
						
						ajaxCall(url, data, function(data) {
							if(data.result > 0) {
								var returnList = data.returnList || [];
								var html = '';
				        		
								returnList.forEach(function(v, i) {
				        			html += '<option value="' + v.teamCd + '" data-bbs-id="' + v.bbsId + '">' + v.teamNm + '</option>';
				        		});
								
								$("#teamCd").html(html);
								// 팀 선택 이벤트
				        		$("#teamCd").dropdown("clear");
				        		$("#teamCd").on("change", function() {
				        			if(!this.value) return;
				        			
				        			$("#bbsId").val("");  // 게시판 선택 초기화
				        			
				        			// 팀 게시판 생성여부 조회
				        			checkAndCreateTeamBbs(this.value).done(function(bbsId) {
				        				var url = "/bbs/bbsHome/bbsInfo.do";
					    				var data = {
					    					bbsId: bbsId
					    				};
					    				
					    				// 게시판 정보 조회 및 옵션 초기화 
					    				ajaxCall(url, data, function(data) {
					    					if (data.result > 0) {
					    		        		var returnVO = data.returnVO;
					    		        		$("#bbsId").val(returnVO.bbsId);
					    		        		
					    		        		writeOption.setWriteForm(returnVO);
					    		            } else {
					    		             	alert(data.message);
					    		            }
					    				}, function(xhr, status, error) {
					    					/* 에러가 발생했습니다! */
					    					alert('<spring:message code="fail.common.msg" />');
					    				});
				        			});
				        			
				        			$(".displayOptionLi").css("display", "list-item");
				       			});
				        		
				        		// 파라미터 값 세팅
				        		if(TEAM_CD) {
				        			setTimeout(function() {
				        				$("#teamCd").dropdown("set value", TEAM_CD);
									}, 0);
				        		}
				        	} else {
				        		alert(data.message);
				        	}
						}, function(xhr, status, error) {
							/* 에러가 발생했습니다! */
							alert('<spring:message code="fail.common.msg" />');
						});
	       			});
					
					// 파라미터 값 세팅
	        		if(TEAM_CTGR_CD) {
	        			setTimeout(function() {
	        				$("#teamCtgrCd").dropdown("set value", TEAM_CTGR_CD);
						}, 0);
	        		}
				}
			}, function(xhr, status, error) {
				/* 에러가 발생했습니다! */
				alert('<spring:message code="fail.common.msg" />');
			});
		},
		// 첨부파일
		useAtchFile: function() {
			// 첨부 사용 여부
			if(this.bbsInfo.atchUseYn != "Y") return;
			// 게시글 등록할때만 초기화
			if(this.isEdit) return;
			
			$("#atclFileOptionLi").show().html(this.createAtchFileOptionHtml());
			
			DextUploader({
				id:"upload1",
				parentId:"upload1-container",
				btnFile:"upload1_btn-add",
				btnDelete:"upload1_btn-delete",
				lang:"<%=LocaleUtil.getLocale(request)%>",
				uploadMode:"ORAF",
				fileCount:10,
				maxTotalSize:this.bbsInfo.atchFileSizeLimit,
				maxFileSize:this.bbsInfo.atchFileSizeLimit,
				extensionFilter:"*",
				finishFunc:"finishUpload()",
				uploadUrl:"<%=CommConst.PRODUCT_DOMAIN + CommConst.DEXT_FILE_UPLOAD%>",
				path:"/bbs/" + this.bbsInfo.bbsId,
				useFileBox:true
			});
		},
		// 부가 옵션
		useEtc: function() {
			if(!(this.bbsInfo.cmntUseYn == 'Y' || this.bbsInfo.goodUseYn == 'Y')) return;
			
			$("#etcOptionLi").show().html(this.createEtcOptionHtml());
		},
		// 분반 같이 등록
		useDecls: function() {
			// 게시글 수정시 분반정보 표시
			if(this.isEdit) {
				var atclId = '<c:out value="${bbsAtclVO.atclId}" />';
				var declsAtclIds = '<c:out value="${bbsAtclVO.declsAtclIds}" />';
				
				// 분반 등록정보 있는경우
				if(declsAtclIds) {
					var url = "/bbs/bbsLect/listDeclsAtcl.do";
					var data = {
						  crsCreCd: CRS_CRE_CD
						, declsAtclIds: declsAtclIds
					};
					
					// 분반 목록 조회
					$.ajax({
			            url : url,
			            type : "get",
			            data: data,
			        }).always(function(data) {
			        	var returnList = data && data.returnList || [];
			        	
			        	if(returnList.length > 0) {
			        		$("#declsOptionLi").show().html(writeOption.createDeclsOptionHtml(returnList));
			        	}
			        });
				}
			} else {
				// 강의실에서 교수만 이용가능
				if(TEMPLATE_URL != "bbsLect" || !bbsCommon.isProfessor()) return;
				
				// 강의실 기본게시판만 가능
				if(!(this.bbsInfo.sysUseYn == "N" && this.bbsInfo.sysDefaultYn == "Y")) return;
				
				var url = "/bbs/bbsLect/declsList.do";
				var data = {
					crsCreCd: $("#crsCreCd").val()
				};
				
				// 분반 목록 조회
				$.ajax({
		            url : url,
		            type : "get",
		            data: data,
		        }).always(function(data) {
		        	var returnList = data && data.returnList || [];
		        	
	        		$("#declsOptionLi").show().html(writeOption.createDeclsOptionHtml(returnList));
		        });
			}
		},
		// 등록예약
		useWriteResv: function() {
			// 강의실에서 교수만 이용가능
			if(TEMPLATE_URL == "bbsLect") {
				// 교수만 이용가능
				if(!bbsCommon.isProfessor()) return;
			} else {
				// 관리자만 이용가능
				if(!bbsCommon.isAdmin()) return;
			}
			
			$("#writeResvOptionLi").show().html(this.createWriteResvOptionHtml());
			$("#writeResvOptionLi").find(".ui.checkbox").checkbox();
			
			// calendar 설정
			initCalendar();
			
			// 예약일시 영역 show/hide
			$("#rsrvUseYn").on("change", function() {
				if(this.checked) {
					$("#rsrvDttmArea").css("visibility", "visible");
				} else {
					$("#rsrvDttmArea").css("visibility", "hidden");
				}
			});
		},
		// 공개여부
		useLock: function() {
			var lockUseYn = this.bbsInfo.lockUseYn;
			
			// 공개 사용 여부
			if(lockUseYn != "Y") return;
			
			if(TEMPLATE_URL == "bbsLect") {
				// 교수만 이용가능
				if(!bbsCommon.isProfessor()) return;
			} else {
				// 관리자만 이용가능
				if(!bbsCommon.isAdmin()) return;
			}
			
			$("#lockOptionLi").show().html(this.createLockOptionHtml());
			$("#lockOptionLi").find(".ui.checkbox").checkbox();
		},
		// 년도/학기 옵션
		useTerm: function() {
			// 공지 사용 여부
			if(this.bbsInfo.notiUseYn != "Y") return;
			
			if(TEMPLATE_URL == "bbsLect") {
				// 교수만 이용가능
				if(!bbsCommon.isProfessor()) return;
			} else {
				// 관리자만 이용가능
				if(!bbsCommon.isAdmin()) return;
			}
			
			$("#termOptionLi").show().html(this.createTermOptionHtml());
			$("#haksaYearSelect").dropdown();
			$("#haksaTermSelect").dropdown();
			$("#haksaYearSelect").parent().css("z-index", "1002");
			$("#haksaTermSelect").parent().css("z-index", "1002");
			$("input[name='noticeType']").off("change").on("change", function() {
				if(this.value == "ALL") {
					$("#yearTermSelectDiv").hide();
				} else {
					$("#yearTermSelectDiv").show();
				}
			});
			
			$("input[name='noticeType']:checked").trigger("change");
		},
		clearForm: function() {
			$("#notiOptionLi").hide().empty();			// 공지옵션 (중요글, 고정글)
			$("#secretOptionLi").hide().empty();		// 문의/상담 옵션
			if(!this.isEdit) {
				$("#atclFileOptionLi").hide().empty();	// 첨부파일
			}
			$("#etcOptionLi").hide().empty();				// 부가옵션 (댓글사용, 좋아요 사용)
			$("#writeResvOptionLi").hide().empty();	// 등록예약 사용
			$("#declsOptionLi").hide().empty();			// 분반 같이 등록
			$("#lockOptionLi").hide().empty();			// 공개여부
		},
		// 팀게시판일경우 1번 초기화
		initTeamWriteForm: function() {
			if(!this.isEdit) {
				$("#bbsId").val("");
			}
			
			writeOption.useTeamSelectOption();
		},
		setWriteForm: function(bbsInfo) {
			this.bbsInfo = bbsInfo;
			this.clearForm();
			
			// 전체공지
			if(bbsInfo.bbsCd == "NOTICE" && bbsInfo.sysUseYn == "Y" && bbsInfo.sysDefaultYn == "Y") {
				writeOption.useNoti();		// 공지옵션 (중요글, 고정글)
				writeOption.useTerm();		// 년도/학기
				writeOption.useAtchFile(); 	// 첨부파일
				writeOption.useEtc(); 		// 부가옵션 (댓글사용)
				writeOption.useLock();		// 공개여부
				// 전체공지 옵션 생성
			}
			// 공지사항
			else if(bbsInfo.bbsCd == "NOTICE") {
    			writeOption.useNoti();		// 공지옵션 (중요글, 고정글)
    			writeOption.useAtchFile(); 	// 첨부파일
    			writeOption.useEtc(); 		// 부가옵션 (댓글사용)
    			writeOption.useDecls();		// 분반 같이 등록
    			writeOption.useWriteResv();	// 등록예약 사용
    			writeOption.useLock();		// 공개여부
			} 
			// 문의
			else if(bbsInfo.bbsCd == "QNA") {
				writeOption.useAtchFile();	// 첨부파일
				//writeOption.useEtc();		// 부가옵션 (댓글사용)
				writeOption.useLock();		// 공개여부
			}
			// 상담
			else if(bbsInfo.bbsCd == "SECRET") {
				//writeOption.useSecret();		// 상담 옵션
				writeOption.useAtchFile();	// 첨부파일
				//writeOption.useEtc();		// 부가옵션 (댓글사용)
				writeOption.useLock();		// 공개여부
			}
			// 강의자료실
			else if(bbsInfo.bbsCd == "PDS") {
				writeOption.useNoti();		// 공지옵션 (중요글, 고정글)
				writeOption.useAtchFile();	// 첨부파일
				writeOption.useEtc();		// 부가옵션 (댓글사용, 좋아요 사용)
				writeOption.useDecls();		// 분반 같이 등록
				writeOption.useWriteResv();	// 등록예약 사용
				writeOption.useLock();		// 공개여부
			}
			// 자유게시판
			else if(bbsInfo.bbsCd == "FREE") {
				writeOption.useNoti();		// 공지옵션 (중요글, 고정글)
				writeOption.useAtchFile();	// 첨부파일
				writeOption.useEtc();		// 부가옵션 (댓글사용)
				writeOption.useLock();		// 공개여부
			}
			// 팀게시판
			else if(bbsInfo.bbsCd == "TEAM") {
				writeOption.useAtchFile();	// 첨부파일
				writeOption.useEtc();		// 부가옵션 (댓글사용)
				writeOption.useLock();		// 공개여부
			}
			else if(bbsInfo.bbsCd == "PHOTO") {
				writeOption.useAtchFile();	// 첨부파일
			}
		}
	};
	
	// 저장 버튼
	function saveConfirm() {
		if(!$("#bbsId").val()) {
			alert('<spring:message code="bbs.alert.no_select_team" />'); // 팀지정은 필수 항목입니다. 다시 확인 바랍니다.
			return;
		}
		
		//if($("#councelProf").length == 1 && !$("#councelProf").val()) {
		//	alert('<spring:message code="bbs.alert.no_select_councel_prof" />'); // 일대일상담을 선택한경우, 상담교수는 필수 항목입니다. 다시 확인 바랍니다.
		//	$("#councelProf").focus();
		//	return;
		//}
		
		if(!$("#atclTitle").val()) {
			alert('<spring:message code="bbs.alert.empty_title" />'); // 제목은 필수 항목입니다. 다시 확인 바랍니다.
			$("#atclTitle").focus();
			return;
		}
		
		if(editor.isEmpty()) {
			alert('<spring:message code="bbs.alert.empty_content" />'); // 내용은 필수 항목입니다. 다시 확인 바랍니다.
			editor.execCommand('selectAll');
			editor.execCommand('deleteLeft');
			editor.execCommand('insertText', "");
			return;
		}
		
		if($("#rsrvUseYn").is(":checked")) {
			<spring:message code="bbs.common.placeholder_write_resv" var="resvDate" />
			
			var rsrvDttmText = $("#rsrvDttmText").val();
			
			if(!rsrvDttmText) {
				alert('<spring:message code="common.alert.input.eval_date" arguments='${resvDate}' />'); // 날짜를 입력하세요.
				$("#rsrvDttmText").focus();
				return;
			}
			if($("#rsrvDttmHH option:selected").val() == " ") {
				alert('<spring:message code="common.alert.input.eval_hour" arguments='${resvDate}' />'); // 시간을 입력하세요.
				$("#rsrvDttmHH").parent().focus();
				return;
			}
			if($("#rsrvDttmMM option:selected").val() == " ") {
				alert('<spring:message code="common.alert.input.eval_min" arguments='${resvDate}' />'); // 분을 입력하세요.
				$("#rsrvDttmMM").parent().focus();
				return;
			}
			
			var rsrvDttm = $("#rsrvDttmText").val().replaceAll('.','-')+ ' ' + $("#rsrvDttmHH option:selected").val() + ":" + $("#rsrvDttmMM option:selected").val();
			rsrvDttm = bbsCommon.replaceDateToDttm(rsrvDttm);

			if(!rsrvDttm.length == 14) {
				alert('<spring:message code="bbs.alert.invalid_resv_date" />'); // 등록예약 일자가 올바르지 않습니다.
				$("#rsrvDttmText").focus();
				return;
			}
			
			$("#rsrvDttm").val(rsrvDttm)
		}
		
		if($("input[name='noticeType']:checked").val() == "TERM") {
			var haksaYear = $("#haksaYearSelect").val();
			var haksaTerm = $("#haksaTermSelect").val();
			
			$("#haksaYear").val(haksaYear);
			$("#haksaTerm").val(haksaTerm);
		} else {
			$("#haksaYear").val("");
			$("#haksaTerm").val("");
		}
		
		$("#uploadFiles").val("");
		$("#copyFiles").val("");
		$("#uploadPath").val("");
		
		// 비밀글 여부
		$("#lockYn").val($("#lock").is(":checked") ? "N" : "Y");
		
		var dx = dx5.get("upload1");
		if (dx.availUpload()) {
			dx.startUpload();
		} else {
			save();
		}
	}
	
	function save() {
		$("#atclId").val('<c:out value="${bbsAtclVO.atclId}" />');
		
		var url;
		var returnUrl;
		var queryInfo = {};
		var dx = dx5.get("upload1");
		
		$("input[name='copyFiles']").val(dx.getCopyFiles()); // 파일함에서 가져온 파일
		$("#uploadPath").val(dx.getUploadPath());
		
		if($("#atclId").val()) {
			$("input[name='delFileIdStr']").val(dx.getDelFileIdStr()); // 삭제파일 Id			
			
			url = "/bbs/" + TEMPLATE_URL +"/editAtcl.do";
			
			// 수정 후 글보기 이동
    		if(BBS_CD) {
    			queryInfo.bbsCd = BBS_CD;
    		}
    		
    		if(CRS_CRE_CD) {
    			queryInfo.crsCreCd = CRS_CRE_CD;
    		}
    		if(TEAM_CTGR_CD && TEAM_CD) {
    			queryInfo.teamCtgrCd = TEAM_CTGR_CD;
    			queryInfo.teamCd = TEAM_CD;
    		}
    		
    		queryInfo.bbsId = BBS_ID;
    		queryInfo.atclId = ATCL_ID;
    		
    		if(SEARCH_VALUE) {
    			queryInfo.searchValue = SEARCH_VALUE;
    		}
    		
    		if(PAGE_INDEX) {
    			queryInfo.pageIndex = PAGE_INDEX;
    		}
    		
    		if(LIST_SCALE) {
    			queryInfo.listScale = LIST_SCALE;
    		}
    		
    		if(TAB) {
    			queryInfo.tab = TAB;
    		}
    		
    		returnUrl = "/bbs/" + TEMPLATE_URL + "/Form/atclView.do";
		} else {
			url = "/bbs/" + TEMPLATE_URL + "/addAtcl.do";
			
			// 저장 후 목록 이동
    		if(BBS_CD) {
    			queryInfo.bbsCd = BBS_CD;
    		}
    		
    		var crsCreCd = CRS_CRE_CD;
    		if(crsCreCd) {
    			queryInfo.crsCreCd = crsCreCd;
    		}
    		
    		if(TEAM_CTGR_CD && TEAM_CD) {
    			queryInfo.teamCtgrCd = TEAM_CTGR_CD;
    			queryInfo.teamCd = TEAM_CD;
    		}
    		
    		if(BBS_ID) {
    			queryInfo.bbsId = $("#bbsId").val();
    		}
    		
    		if(TAB) {
    			queryInfo.tab = TAB;
    		}
    		
    		returnUrl = "/bbs/" + TEMPLATE_URL + "/atclList.do";
		}
		
		var data = $("#atclWriteForm").serialize();
		
		ajaxCall(url, data, function(data) {
        	if(data.result > 0) {
        		alert(data.message);
        		var queryStr = new URLSearchParams(queryInfo).toString();
        		
        		bbsCommon.movePost(returnUrl, queryStr);
            } else {
            	alert(data.message || "An error occurred while saving."); // 에러 메세지 (방화벽)
            }
		}, function(xhr, status, error) {
			/* 에러가 발생했습니다! */
			alert('<spring:message code="fail.common.msg" />');
		}, true);
	}
	
	// 파일 업로드 완료
    function finishUpload() {
    	var dx = dx5.get("upload1");
    	var url = "/file/fileHome/saveFileInfo.do";
    	var data = {
    		"uploadFiles" : dx.getUploadFiles(),
    		"copyFiles"   : dx.getCopyFiles(),
    		"uploadPath"  : dx.getUploadPath()
    	};
    	
    	ajaxCall(url, data, function(data) {
    		if(data.result > 0) {
    			$("#uploadFiles").val(dx.getUploadFiles());
    	    	$("#copyFiles").val(dx.getCopyFiles());
    	    	$("#uploadPath").val(dx.getUploadPath());
    	    	
    	    	save();
    		} else {
    			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
    		}
    	}, function(xhr, status, error) {
    		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
    	});
    }
	
	// 취소 버튼
	function cancel() {
		var url;
		var queryInfo = {};
		
		if($("#atclId").val()) {
			if(BBS_CD) {
    			queryInfo.bbsCd = BBS_CD;
    		}
    		
    		if(CRS_CRE_CD) {
    			queryInfo.crsCreCd = CRS_CRE_CD;
    		}
    		if(TEAM_CTGR_CD && TEAM_CD) {
    			queryInfo.teamCtgrCd = TEAM_CTGR_CD;
    			queryInfo.teamCd = TEAM_CD;
    		}
    		
    		queryInfo.bbsId = BBS_ID;
    		queryInfo.atclId = ATCL_ID;
    		
    		if(SEARCH_VALUE) {
    			queryInfo.searchValue = SEARCH_VALUE;
    		}
    		
    		if(PAGE_INDEX) {
    			queryInfo.pageIndex = PAGE_INDEX;
    		}
    		
    		if(LIST_SCALE) {
    			queryInfo.listScale = LIST_SCALE;
    		}
    		
    		if(TAB) {
    			queryInfo.tab = TAB;
    		}
    		
    		url = "/bbs/" + TEMPLATE_URL + "/Form/atclView.do";
		} else {
			if(BBS_CD) {
				queryInfo.bbsCd = BBS_CD;
			}
			
			if(CRS_CRE_CD) {
				queryInfo.crsCreCd = CRS_CRE_CD;
			}
			
			if(TEAM_CTGR_CD && TEAM_CD) {
				queryInfo.teamCtgrCd = TEAM_CTGR_CD;
				queryInfo.teamCd = TEAM_CD;
			}
			
			if(BBS_ID) {
				queryInfo.bbsId = BBS_ID;
			}
			
			if(SEARCH_VALUE) {
    			queryInfo.searchValue = SEARCH_VALUE;
    		}
    		
    		if(PAGE_INDEX) {
    			queryInfo.pageIndex = PAGE_INDEX;
    		}
    		
    		if(LIST_SCALE) {
    			queryInfo.listScale = LIST_SCALE;
    		}
			
			if(TAB) {
				queryInfo.tab = TAB;
			}
			
			url = "/bbs/" + TEMPLATE_URL + "/atclList.do";
		}
		
		var queryStr = new URLSearchParams(queryInfo).toString();
		bbsCommon.movePost(url, queryStr);
	}
	
	// 과목선택 변경 (강의실 기본게시판, 글쓰기, 관리자 경우만 가능) 
	function changeCrsCreCd(crsCreCd, defaultBbsCd) {
		var prevCrsCreCd = $("#crsCreCd").val();
		
		// 1. 게시판 옵션 리로딩 (bbsId, bbsCd, bbsNm)
		var url = "/bbs/bbsLect/listCourseDefaultBbs.do";
		var data = {
			crsCreCd: crsCreCd
		};
		
		ajaxCall(url, data, function(data) {
			var returnList = data.returnList || [];
        	
        	if (data.result > 0 && returnList.length > 0) {
        		// 알림터 게시판 코드
        		var alarmBbsCdObj = {
					"NOTICE": true
       				//, "QNA": true
       				//, "SECRET": true
       				, "PDS": true
      			};
      			
        		var isAlarmBbs = alarmBbsCdObj[defaultBbsCd] ? true : false;
        		var alarmBbsObj = {};
        		var bbsList = [];
        		
        		returnList.forEach(function(v, i) {
        			if(isAlarmBbs) {
        				if(alarmBbsCdObj[v.bbsCd]) {
        					alarmBbsObj[v.bbsCd] = v;
        				}
        			} else {
        				if(v.bbsCd == defaultBbsCd) {
        					bbsList.push(v);
        					return false;
        				}
        			}
    			});
        		
        		if(isAlarmBbs) {
        			Object.keys(alarmBbsCdObj).forEach(function(key, i) {
        				if(alarmBbsObj[key]) {
        					bbsList.push(alarmBbsObj[key]);
        				}
        			});
        		}
        		
        		var html = '';
        		var bbsCdRadioHtml = '';
        		
        		bbsList.forEach(function(v, i) {
					var inputId = "bbsCd_" + i;
        			
       				bbsCdRadioHtml += '	<div class="field">';
       				bbsCdRadioHtml += '		<div class="ui radio checkbox">';
       				bbsCdRadioHtml += '			<label for="' + inputId + '" class="hide">bbsCd</label>';
           			bbsCdRadioHtml += '			<input type="radio" id="' + inputId + '" name="bbsCd" value="' + v.bbsCd + '"  onchange="initBbsForm(\'' + v.bbsId + '\')" />';
           			bbsCdRadioHtml += '			<label for="' + inputId + '">' + v.bbsNm + '</label>';
           			bbsCdRadioHtml += '		</div>';
           			bbsCdRadioHtml += '	</div>';
        		});
        		
        		html += '<dl>';
    			html += '	<dt>';
    			html += '		<label class="req"><spring:message code="bbs.label.form_bbs" /></label>'; // 게시판
    			html += '	</dt>';
    			html += '	<dd>';
    			html += '		<div class="fields">';
    			html += 			bbsCdRadioHtml;
    			html += '		</div>';
    			html += '		<div class="fields" id="prevAtclBtnArea">';
    			html += '		</div>';
    			html += '	</dd>';
    			html += '</dl>';
        		
        		$("#bbsOptionLi").empty().html(html);
        		$("#bbsOptionLi").find(".ui.checkbox").checkbox();
        		$("#bbsOptionLi").show();
        		
        		var $bbsCdRadio = $("input[name='bbsCd'][value=" + defaultBbsCd + "]");
        		
        		if($bbsCdRadio.length == 0) {
        			$bbsCdRadio = $("input[name='bbsCd']").eq(0);
        		}
        		
        		$bbsCdRadio.prop("checked", true);
        		$bbsCdRadio.trigger("change");
        		
        		$("#crsCreCd").val(crsCreCd);
            } else {
            	alert('<spring:message code="bbs.error.not_exists_bbs" />'); // 게시판 정보를 찾을 수 없습니다.
            }
        	
        	$('.ui.dropdown').dropdown();
        	
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
		});
	}
		
	// 게시판 정보 조회후 쓰기 폼 세팅
	function initBbsForm(bbsId) {
		var url = "/bbs/bbsHome/bbsInfo.do";
		var data = {
   			bbsId: bbsId
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnVO = data.returnVO;
        		writeOption.setWriteForm(returnVO);
        		$("#bbsId").val(returnVO.bbsId);
        		
        		var bbsId = returnVO.bbsId
        		var bbsCd = returnVO.bbsCd;
        		var sysUseYn = returnVO.sysUseYn;
        		var sysDefaultYn = returnVO.sysDefaultYn;
        		
        		var html = '';
        		var btnText;
        		
        		if(sysDefaultYn == "Y") {
        			if(sysUseYn == "Y") {
            			if(bbsCd == "NOTICE") {
                			btnText = '<spring:message code="bbs.button.prev_system_notice" />'; // 전체 공지 가져오기
                			
                			html += '<div class="fields">';
                   			html += '	<div class="field mt5">';
                   			html += '		<a href="javascript:void(0)" onclick="prevAtclListModal(\'' + bbsId + '\', null, \'' + btnText +'\')" class="ui blue button small">' + btnText + '</a>';
                   			html += '	</div>';
                   			html += '</div>';
                		}
            		} else {
            			if(bbsCd == "NOTICE" || bbsCd == "PDS") {
            				if(bbsCd == "NOTICE") {
            					btnText = '<spring:message code="bbs.button.prev_class_notice" />'; // 강의공지 가져오기
            				} else {
            					btnText = '<spring:message code="bbs.button.prev_class_pds" />'; // 강의자료 가져오기
            				}
                			
                			html += '<div class="fields">';
                   			html += '	<div class="field mt5">';
                   			html += '		<a href="javascript:void(0)" onclick="prevAtclListModal(null, \'' + bbsCd + '\', \'' + btnText +'\')" class="ui blue button small">' + btnText + '</a>';
                   			html += '	</div>';
                   			html += '</div>';
                		}
            		}
        		}
       			
       			$("#prevAtclBtnArea").empty().html(html);
       			$('.ui.dropdown').dropdown();
       			
            } else {
            	alert(data.message);
            }
		}, function(xhr, status, error) {
			/* 에러가 발생했습니다! */
			alert('<spring:message code="fail.common.msg" />');
		}, true);
	}
	
	// 이전게시글 목록 모달
	function prevAtclListModal(bbsId, bbsCd, title) {
		var crsCreCd = CRS_CRE_CD;
		
		$("#prevAtclListModalTitle").html(title);
		$("#prevAtclListForm").attr("target", "prevAtclListIfm");
        $("#prevAtclListForm").attr("action", "/bbs/bbsLect/popup/prevAtclList.do");

        if(bbsId) {
			$("#prevAtclListForm > input[name='bbsId']").val(bbsId);
		} else {
			$("#prevAtclListForm > input[name='crsCreCd']").val(crsCreCd);
			$("#prevAtclListForm > input[name='bbsCd']").val(bbsCd);
		}
		
        $("#prevAtclListForm").submit();
        $('#prevAtclListModal').modal('show');
	}
	
	// 이전게시글 가져오기
	function prevAtclListModalCallback(atclId) {
		var url = "/bbs/bbsHome/atclInfo.do";
		var data = {
			atclId: atclId
		};
		
		ajaxCall(url, data, function(data) {
			var returnVO = data.returnVO;
        	
        	if (data.result > 0 && returnVO) {
        		var atclTitle = returnVO.atclTitle;
        		var atclCts = returnVO.atclCts;
        		
        		// 폼 초기화
        		writeOption.setWriteForm(writeOption.bbsInfo);
        		
        		// 게시글 타이틀 세팅
        		$("#atclTitle").val(atclTitle);
        		
        		// 게시글 내용 세팅
        		editor.execCommand('selectAll');
    			editor.execCommand('deleteLeft');
    			editor.openHTML(atclCts);
    			
    			// 게시판 옵션
    			if(returnVO.bbsCd == "NOTICE") {
    				/* 공지사항 사용 옵션 */
    				// 공지옵션 (중요글, 고정글)
    				// 첨부파일
        			// 부가옵션 (댓글사용)
        			// 분반 같이 등록
        			// 공개여부
        			
        			/* 이전글 세팅 목록 */
        			// 공지옵션 (중요글, 고정글)
        			var imptYn = returnVO.imptYn;
        			var noticeYn = returnVO.noticeYn;
        			
        			// 부가옵션 (댓글사용)
        			var cmntUseYn = returnVO.cmntUseYn;
        			
					if(imptYn == "Y") {
						$("#imptYn").prop("checked", true);
        			}
					
					if(noticeYn == "Y") {
        				$("#noticeYn").prop("checked", true);
        			}
					
					if(cmntUseYn == "Y") {
						$("#cmntUseYn").prop("checked", true);
        			}
    			} else if (returnVO.bbsCd == "PDS") {
    				/* 자료실 사용 옵션 */
    				// 공지옵션 (중요글, 고정글)
    				// 부가옵션 (댓글사용, 좋아요 사용)
    				// 분반 같이 등록
    				// 등록예약 사용
    				// 공개여부
    				
    				/* 이전글 세팅 목록 */
        			// 공지옵션 (중요글, 고정글)
        			var imptYn = returnVO.imptYn;
        			var noticeYn = returnVO.noticeYn;
        			
        			// 부가옵션 (댓글사용, 좋아요 사용)
        			var cmntUseYn = returnVO.cmntUseYn;
        			var goodUseYn = returnVO.goodUseYn;
        			
        			if(imptYn == "Y") {
        				$("#imptYn").prop("checked", true);
        			}
					
					if(noticeYn == "Y") {
						$("#noticeYn").prop("checked", true);
        			}
					
					if(cmntUseYn == "Y") {
						$("#cmntUseYn").prop("checked", true);
        			}
					
					if(goodUseYn == "Y") {
						$("#goodUseYn").prop("checked", true);
        			}
    			}
    			
    			// 이전 파일 가져오기
    			if(returnVO.fileList && returnVO.fileList.length > 0) {
    				setTimeout(function(){
	    				var dx = dx5.get("upload1");
	    				dx.removeAll(true);
	    				dx.addCopyFiles(returnVO.fileList);
    				}, 500);
    			}
            } else {
            	alert('<spring:message code="bbs.error.not_exists_atcl" />'); // 게시글 정보를 찾을 수 없습니다.
            }
		}, function(xhr, status, error) {
			/* 에러가 발생했습니다! */
			alert('<spring:message code="fail.common.msg" />');
		});
	}
	
	// 팀 게시판 생성여부 조회
	function checkAndCreateTeamBbs(teamCd) {
		var deferred = $.Deferred();
		
		var url = "/bbs/bbsLect/checkAndCreateTeamBbs.do";
		var data = {
			teamCd: teamCd
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnVO = data.returnVO;
				var bbsId = returnVO && returnVO.bbsId;
				
				deferred.resolve(bbsId);
        	} else {
        		alert(data.message);
        		deferred.reject();
        	}
		}, function(xhr, status, error) {
			/* 에러가 발생했습니다! */
			alert('<spring:message code="fail.common.msg" />');
			deferred.reject();
		});
	
		return deferred.promise();
	}
</script>
<body class="<%=SessionInfo.getThemeMode(request)%>">

	<div id="wrap" class="main">
	
		<!-- class_top 인클루드  -->
		<c:choose>
			<c:when test="${templateUrl eq 'bbsHome'}">
				<%@ include file="/WEB-INF/jsp/common/frontLnb.jsp"%>
			</c:when>
			<c:when test="${templateUrl eq 'bbsLect'}">
				<%@ include file="/WEB-INF/jsp/common/class_lnb.jsp"%>
			</c:when>
			<c:when test="${templateUrl eq 'bbsMgr'}">
				<%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
			</c:when>
		</c:choose>

		<div id="container">
		
			<c:choose>
				<c:when test="${templateUrl eq 'bbsHome'}">
					<%@ include file="/WEB-INF/jsp/common/frontGnb.jsp"%>
				</c:when>
				<c:when test="${templateUrl eq 'bbsLect'}">
					<%@ include file="/WEB-INF/jsp/common/class_header.jsp"%>
				</c:when>
				<c:when test="${templateUrl eq 'bbsMgr'}">
					<%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
				</c:when>
			</c:choose>

			<!-- 본문 content 부분 -->
			<div class="content stu_section">
				<c:choose>
					<c:when test="${templateUrl eq 'bbsHome'}">
					</c:when>
					<c:when test="${templateUrl eq 'bbsLect'}">
		        		<%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
					</c:when>
					<c:when test="${templateUrl eq 'bbsMgr'}">
					</c:when>
				</c:choose>
		        
		        <!-- 영역1 -->
		        <div class="ui form">
			        <div class="layout2">
                    	<script>
	                    	$(document).ready(function (){
								var templateUrl = '<c:out value="${templateUrl}" />';
								
								var bbsTitle;
								if(templateUrl == "bbsHome") {
									bbsTitle = '<spring:message code="bbs.label.bbs_lect_home" />'; 			// 강의실 홈
								} else if(templateUrl == "bbsLect") {
									bbsTitle = '<spring:message code="bbs.label.bbs_alarm" />';					// 알림터
								} else if(templateUrl == "bbsMgr") {
									bbsTitle = '<spring:message code="bbs.label.bbs_manager_home" />';		// 관리자
								}
								
								var bbsSubTitle;
								var bbsCd = '<c:out value="${param.bbsCd}" />';
								var bbsNm = '<c:out value="${bbsInfoVO.bbsNm}" />';
								var tab = '<c:out value="${param.tab}" />';
								
								if(bbsCd == "TEAM") {
									bbsSubTitle = '<spring:message code="bbs.label.bbs_team" />';	// 팀게시판
								} else if(bbsCd == "ALARM") {
									bbsSubTitle = '<spring:message code="bbs.label.alarm.bbs" />';	// 통합게시판
								} else {
									bbsSubTitle = bbsNm;
								}
								
								// set location
								if(typeof setLocationBar === "function") {
									setLocationBar(bbsTitle, bbsSubTitle);
								}
							});
						</script>
						
						<!-- 템플릿 별 ID, 클래스 --> 
						<c:choose>
                        	<c:when test="${templateUrl eq 'bbsHome'}">
                        		<c:set var="titleId" value="" />
                        		<c:set var="titleClass" value="classInfo" />
                        	</c:when>
                        	<c:when test="${templateUrl eq 'bbsLect'}">
                        		<c:set var="titleId" value="info-item-box" />
                        		<c:set var="titleClass" value="" />
                        	</c:when>
                        	<c:when test="${templateUrl eq 'bbsMgr'}">
                        		<c:set var="titleId" value="info-item-box" />
                        		<c:set var="titleClass" value="" />
                        	</c:when>
                        </c:choose>
                        
                        <div id="<c:out value="${titleId}" />" class="<c:out value="${titleClass}" />">
                            <h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                 <c:choose>
	                            	<c:when test="${templateUrl eq 'bbsHome'}">
	                            		<spring:message code="bbs.label.bbs_lect_home" /><!-- 강의실 홈 -->
	                            	</c:when>
	                            	<c:when test="${templateUrl eq 'bbsLect'}">
	                            		<c:choose>
	                            			<c:when test="${param.bbsCd eq 'TEAM'}">
	                            				<spring:message code="bbs.label.bbs_team" /><!-- 팀게시판 -->
	                            			</c:when>
	                            			<c:when test="${param.bbsCd eq 'ALARM'}">
	                            				<spring:message code="bbs.label.alarm.bbs" /><!-- 통합게시판 -->
	                            			</c:when>
	                            			<c:otherwise>
	                            				<c:out value="${bbsInfoVO.bbsNm}" />
	                            			</c:otherwise>
	                            		</c:choose>
	                            	</c:when>
	                            	<c:when test="${templateUrl eq 'bbsMgr'}">
	                            		<spring:message code="bbs.label.bbs_manager_home" /><!-- 관리자 -->
	                            	</c:when>
	                            </c:choose>
                            </h2>
                            <div class="button-area">
                            	<c:choose>
	                            	<c:when test="${templateUrl eq 'bbsHome'}">
	                            		<c:set var="btnColor1" value="blue" />
	                            		<c:set var="btnColor2" value="bcDarkblueAlpha85" />
	                            	</c:when>
	                            	<c:when test="${templateUrl eq 'bbsLect'}">
	                            		<c:set var="btnColor1" value="basic" />
	                            		<c:set var="btnColor2" value="basic" />
	                            	</c:when>
	                            	<c:when test="${templateUrl eq 'bbsMgr'}">
	                            		<c:set var="btnColor1" value="basic" />
	                            		<c:set var="btnColor2" value="basic" />
	                            	</c:when>
	                            </c:choose>
                            
                                <a href="javascript:void(0)" onclick="saveConfirm();" class="ui <c:out value="${btnColor1}" /> button"><spring:message code="common.button.save" /></a><!-- 저장 -->
		                        <a href="javascript:void(0)" onclick="cancel();" class="ui <c:out value="${btnColor2}" /> button"><spring:message code="common.button.cancel" /></a><!-- 취소 -->
                            </div>
                        </div>

		                <!-- 영역1 -->
                        <div class="row">
                            <div class="col">
                           	<c:if test="${templateUrl eq 'bbsLect' and bbsInfoVO.bbsCd eq 'QNA' and STUDENT_YN eq 'Y'}">
								<div class="ui message bcLYellow">
		                        	<b class=""><spring:message code="bbs.label.qna.guide" /><!-- ※강의 관련 문의사항을 등록하는 게시판입니다. 수강생 전체에게 내용이 공유됩니다. --></b>
								</div>
							</c:if>
							<c:if test="${templateUrl eq 'bbsLect' and bbsInfoVO.bbsCd eq 'SECRET' and STUDENT_YN eq 'Y'}">
								<div class="ui message bcLYellow">
		                        	<b class=""><spring:message code="bbs.label.secret.guide" /><!-- ※교수자와 1:1로 상담을 요청하는 게시판입니다. 작성자와 답변자만 내용을 볼 수 있습니다. 강의 및 행정 관련 문의는 강의 Q&A에 올려주시기 바랍니다. --></b>
								</div>
							</c:if>
                            
                            <!-- 게시판 탭 -->
							<c:if test="${templateUrl eq 'bbsLect'}">
								<%@ include file="/WEB-INF/jsp/bbs/common/bbs_tab_inc.jsp" %>
							</c:if>
								
								<form id="atclWriteForm" name="atclWriteForm">
									<input type="hidden" name="crsCreCd" 	value="<c:out value="${vo.crsCreCd}" />" 		id="crsCreCd" />
									<input type="hidden" name="bbsId" 		value="<c:out value="${vo.bbsId}" />" 			id="bbsId" />
									<input type="hidden" name="atclId" 		value="<c:out value="${bbsAtclVO.atclId}" />" 	id="atclId" />
									<input type="hidden" name="haksaYear"   value="" id="haksaYear" />
									<input type="hidden" name="haksaTerm"   value="" id="haksaTerm" />
									
									<input type="hidden" name="uploadFiles" value="" id="uploadFiles" />
									<input type="hidden" name="copyFiles"   value="" id="copyFiles" />
									<input type="hidden" name="uploadPath"  value="" id="uploadPath" />
									<input type="hidden" name="delFileIdStr" value=""/>
									
									
									<div class="ui segment">
										<ul class="tbl border-top-grey">
										<c:if test="${bbsInfoVO.bbsId eq BBS_ID_SYSTEM_NOTICE}">
											<li>
												<dl>
													<dt>
														<label class="req"><spring:message code="bbs.label.uni.type" /></label><!-- 대학구분 -->
													</dt>
													<dd>
														<div class="fields">
															<div class="field">
																<div class="ui radio checkbox">
																	<label for="univGbn" class="hide">Common</label>
																	<input type="radio" value="0" name="univGbn" id="univGbn" ${empty bbsAtclVO || empty bbsAtclVO.univGbn ? 'checked' : '' } />
																	<label for="univGbn" style="cursor: pointer;"><spring:message code="bbs.label.uni.common" /><!-- 공통 --></label>
																</div>
															</div>
															<c:forEach var="row" items="${univGbnList}">
																<div class="field">
																	<div class="ui radio checkbox">
																		<label for="univGbn${row.codeCd}" class="hide">${row.codeNm}</label>
																		<input type="radio" value="${row.codeCd}" name="univGbn" id="univGbn${row.codeCd}" ${bbsAtclVO.univGbn eq row.codeCd ? 'checked' : '' } />
																		<label for="univGbn${row.codeCd}" style="cursor: pointer;">${row.codeNm}</label>
																	</div>
																</div>
															</c:forEach>
														</div>
													</dd>
												</dl>
											</li>
										</c:if>
										<c:if test="${param.bbsCd ne 'TEAM'}">
											<li id="bbsOptionLi">
												<dl>
													<dt>
														<label class="req"><spring:message code="bbs.label.form_bbs" /></label><!-- 게시판 -->
													</dt>
													<dd>
														<div class="fields">
															<div class="field">
																<div class="ui radio checkbox">
																	<input type="radio" id="bbsCd_1" value="<c:out value="${bbsInfoVO.bbsCd}" />" checked="checked" disabled="disabled" />
																	<label for="bbsCd_1">
																		<c:out value="${bbsInfoVO.bbsNm}" />
																	</label>
																</div>
															</div>
														</div>
													</dd>
												</dl>
											</li>
										</c:if>
											<li id="notiOptionLi" style="display: none;"></li>
											<li id="termOptionLi" style="display: none;"></li>
											<li id="secretOptionLi" style="display: none;"></li>
											<li id="teamSelectOptionLi" style="display: none;"></li>
											<li class="displayOptionLi" ${bbsInfoVO.bbsCd eq 'TEAM' && empty bbsAtclVO.atclId ? 'style="display:none;"' : '' }>
												<dl>
													<dt>
														<label for="atclTitle" class="req"><spring:message code="bbs.label.form_title" /></label><!-- 제목 -->
													</dt>
													<dd>
														<div class="ui fluid input">
															<input type="text" id="atclTitle" name="atclTitle" autocomplete="off" value="${bbsAtclVO.atclTitle}" />
														</div>
													</dd>
												</dl>
											</li>
											<li class="editor-responsive displayOptionLi" ${bbsInfoVO.bbsCd eq 'TEAM' && empty bbsAtclVO.atclId ? 'style="display:none;"' : '' }>
												<dl>
													<dd style="height:400px">
														<div style="height:100%">
															<label for="contentTextArea" class="hide">Content</label>
															<textarea name="atclCts" id="contentTextArea">
																<c:out value="${bbsAtclVO.atclCts}" />
															</textarea>
															<script>
																// html 에디터 생성
																var editor = HtmlEditor('contentTextArea', THEME_MODE, "/bbs/${bbsInfoVO.bbsId}");
															</script>
														</div>
													</dd>
												</dl>
											</li>
									<c:choose>
										<c:when test="${not empty bbsAtclVO.atclId}">
											<li id="atclFileOptionLi">
												<dl>
													<dt>
														<label><spring:message code="bbs.label.form_attach_file" /></label><!-- 첨부파일 -->
													</dt>
													<dd>
														<uiex:dextuploader
															id="upload1"
															path="/bbs/${bbsInfoVO.bbsId}"
															limitCount="10"
															limitSize="${bbsInfoVO.atchFileSizeLimit}"
															oneLimitSize="${bbsInfoVO.atchFileSizeLimit}"
															listSize="3"
															fileList="${bbsAtclVO.fileList}"
															finishFunc="finishUpload()"
															useFileBox="true"
															allowedTypes="*"
														/>
													</dd>
												</dl>
											</li>
										</c:when>
										<c:otherwise>
											<li id="atclFileOptionLi" style="display: none;"></li>
										</c:otherwise>
									</c:choose>
											<li id="etcOptionLi" style="display: none;"></li>
											<li id="declsOptionLi" style="display: none;"></li>
											<li id="writeResvOptionLi" style="display: none;"></li>
											<li id="lockOptionLi" style="display: none;"></li>
										</ul>
										
										<div class="tr mt10">
											<a href="javascript:void(0)" onclick="saveConfirm();" class="ui blue button"><spring:message code="common.button.save" /></a><!-- 저장 -->
					                        <a href="javascript:void(0)" onclick="cancel();" class="ui basic button"><spring:message code="common.button.cancel" /></a><!-- 취소 -->
										</div>
									</div>
								</form>
                            </div><!-- //col -->
                        </div><!-- //row -->
                        
			        </div><!-- //layout2 -->
			    </div><!-- //ui form -->
			</div><!-- //content stu_section -->
			
			<c:choose>
				<c:when test="${templateUrl eq 'bbsHome'}">
					<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp"%>
				</c:when>
				<c:when test="${templateUrl eq 'bbsLect'}">
					<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp"%>
				</c:when>
				<c:when test="${templateUrl eq 'bbsMgr'}">
					<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp"%>
				</c:when>
			</c:choose>
		
		</div><!-- //container -->		
	</div><!-- //wrap -->
	
	<!-- 이전 목록 팝업 --> 
	<form id="prevAtclListForm" name="prevAtclListForm">
		<input type="hidden" name="crsCreCd" value="" />
		<input type="hidden" name="bbsId" />
		<input type="hidden" name="bbsCd" />
	</form>
    <div class="modal fade in" id="prevAtclListModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="common.modal.field" />" aria-hidden="false" style="display: none; padding-right: 17px;">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="team.common.close"/>">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title" id="prevAtclListModalTitle"><!-- 이전 목록 --></h4>
                </div>
                <div class="modal-body">
                    <iframe src="" width="100%" id="prevAtclListIfm" name="prevAtclListIfm" title="prevAtclListIfm"></iframe>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        $('iframe').iFrameResize();
        window.closeModal = function() {
            $('.modal').modal('hide');
        };
    </script>
</body>
</html>