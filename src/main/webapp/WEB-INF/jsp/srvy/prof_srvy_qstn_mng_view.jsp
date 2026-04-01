<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/srvy/common/srvy_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="editor,fileuploader"/>
	</jsp:include>

	<script type="text/javascript">
		var dialog;

		$(document).ready(function() {
			// 학습그룹부과제설정시 설문 부 과제 목록 조회
			if("${vo.byteamSubsrvyUseyn}" == "Y") {
				srvySubAsmtListSelect();
			}

			if("${vo.srvyGbn}" == "SRVY_TEAM") {
				document.querySelector('button[name="teamButton"][value="${vo.subSrvyId}"]').click();
			} else {
				srvypprQstnListSelect();
			}

			$(".accordion").accordion();
			const title = document.querySelector('.accordion .title');

			document.querySelector('.accordion .title').addEventListener('click', () => {
			  	const content = title.nextElementSibling;
			  	content.classList.toggle('hide');
			});
		});

		var editorMap = {};

		var formOption = {
			/**
			 * 문제 말머리 HTML 추가
			 * @param {String}  srvypprId 	- 설문지아이디
			 * @param {String}  editorId 	- 에디터아이디
			 */
			 createQstnHeaderHTML: function(srvypprId, editorId) {
				var html  = "<form id='" + srvypprId + "QstnForm' onsubmit='return false;'>";
					html += "	<input type='hidden' name='srvypprId' 	value='" + srvypprId + "' />";
					html += "	<input type='hidden' name='srvyQstnId' />";
					html += "	<input type='hidden' name='qstnSeqno' />";
					html += "	<input type='hidden' name='qstnGbncd' 	value='TXT' />";
					html += "	<div class='flex gap-1 margin-bottom-3'>";
	    			html += "		<div class='flex-1'>";
	    			html += "			<input type='text' class='width-100per' inputmask='byte' maxLen='200' name='qstnTtl' required='true'>";
	    			html += "		</div>";
	    			html += "		<select class='form-select' name='qstnRspnsTycd' onchange='qstnRspnsTycdChgChange(\"" + srvypprId + "\")' required='true'>";
	    							<c:forEach var="code" items="${qstnRspnsTycdList }">
	    			html += "			<option value='${code.cd }'>${code.cdnm }</option>";
	    							</c:forEach>
	    			html += "		</select>";
	    			html += "	</div>";
	    			html += "	<p class='fcRed margin-bottom-3'>* 기본 설정된 제목 대신 다른 제목을 넣으시면 좀 더 쉽게 문제를 구분하실 수 있습니다.</p>";
	    			html += "	<div class='editor-box'>";
	    			html += "		<textarea name='qstnCts' id=\"" + editorId + "\" required='true'></textarea>";
	    			html += "	</div>";
		    		html += "	<div class='margin-top-4 qstnTypeDiv'>";
		    		html += "		<table class='table-type2'>";
		    		html += "			<colgroup>";
		    		html += "				<col class='width-20per' />";
		    		html += "				<col class='' />";
		    		html += "			</colgroup>";
		    		html += "			<tbody></tbody>";
		    		html += "		</table>";
		    		html += "	</div>"
		    		html += "</form>";
		    	$('.srvypprDiv[data-id="' + srvypprId + '"]').append(html);
		    	$("#"+srvypprId+"QstnForm select[name=qstnRspnsTycd]").chosen({disable_search: true});
			},
			/**
			 * 문제 버튼 HTML 추가
			 * @param {String}  srvypprId 	- 설문지아이디
			 */
			createQstnBtnHTML: function(srvypprId) {
				var html  = "<div class='btns'>";
		    		html += "	<a href='javascript:qstnRegist(\"" + srvypprId + "\")' class='btn type1 addBtn'><spring:message code='exam.button.save' /></a>";/* 저장 */
		    		html += "	<a href='javascript:qstnAddFrmRemove(\"" + srvypprId + "\")' class='btn type1'><spring:message code='exam.button.cancel' /></a>";/* 취소 */
		    		html += "</div>";
		    	$("#"+srvypprId+"QstnForm").append(html);
			},
			/**
			 * 보기항목 수 HTML 추가
			 * @param {String}  srvypprId 	- 설문지아이디
			 * @param {String}  type 		- 문항답변유형코드
			 */
			createVwitmCntHTML: function(srvypprId, type) {
				var html  = "<tr>";
		    		html += "	<th>보기 개수</th>";
		    		html += "	<td class='t_left'>";
		    		html += "		<select class='form-select' name='vwitmCnt' onchange='createVwitmCntChgHTML(\"" + srvypprId + "\", \"" + type + "\")' required='true'>";
		    						for(var idx = 2; idx <= 10; idx++) {
		    							var selected = (type == "ONE_CHC" || type == "MLT_CHC") && idx == 2 ? "selected" : "";
		    		html += "			<option value=\"" + idx + "\" " + selected + ">" + idx + "개</option>";
		    						}
		    		html += "		</select>";
		    		html += "	</td>";
		    		html += "</tr>";
		    	$("#"+srvypprId+"QstnForm .qstnTypeDiv > table > tbody").append(html);
		    	$("#"+srvypprId+"QstnForm .qstnTypeDiv select[name=vwitmCnt]").chosen({disable_search: true});
			},
			/**
			 * 단일, 다중선택형 문항 HTML 추가
			 * @param {String}  srvypprId 	- 설문지아이디
			 */
			createChgQstnHTML: function(srvypprId) {
				var html  = "<tr>";
		    		html += "	<th>보기 입력</th>";
		    		html += "	<td class='t_left'>";
		    		html += "		<table class='table-type2'>";
		    		html += "			<colgroup>";
		    		html += "				<col class='width-20per' />";
		    		html += "				<col class='' />";
		    		html += "			</colgroup>";
		    		html += "			<tbody class='qstnItemTbody'></tbody>";
		    		html += "		</table>";
		    		html += "	</td>";
		    		html += "</tr>";
		    	$("#"+srvypprId+"QstnForm .qstnTypeDiv > table > tbody").append(html);
			},
			/**
			 * OX선택형 문항 HTML 추가
			 * @param {String}  srvypprId 	- 설문지아이디
			 */
			createOxQstnHTML: function(srvypprId) {
				var html  = "<tr>";
		    		html += "	<th>보기 입력</th>";
		    		html += "	<td class='t_left'>";
		    						for(var idx = 1; idx <= 2; idx++) {
		    							var oxClass = idx == 1 ? "true" : "false";
		    		html += "			<div class='padding-3 flex-item'>";
		    		html += "				<input type='hidden' name='vwitmCts' value='" + (idx == 1 ? "O" : "X") + "' />";
					html += "				<span>" + (idx == 1 ? "O" : "X") + "</span>";
					html += "				<div class='etcSelectDiv margin-left-2'>";
		 	   		html += "					<select class='form-select w150' name='mvmnSrvyQstnId'>";
		 	   		html += "						<option value='NEXT'>다음 페이지로 이동</option>";
		 	   		html += "					</select>";
		 	   		html += "				</div>";
		    		html += "			</div>";
		    						}
		    		html += "	</td>";
		    		html += "</tr>";
		    		$("#"+srvypprId+"QstnForm .qstnTypeDiv > table > tbody").append(html);
		    		$("#"+srvypprId+"QstnForm .qstnTypeDiv select[name=mvmnSrvyQstnId]").chosen({disable_search: true});
		    		$("#"+srvypprId+"QstnForm .qstnTypeDiv .etcSelectDiv").hide();
		    		initSrvypprMvmn(srvypprId, "");	// 다음설문지아이디 초기화
			},
			/**
			 * 레벨형 문항 HTML 추가
			 * @param {String}  srvypprId 	- 설문지아이디
			 */
			createLevelQstnHTML: function(srvypprId) {
				var html  = "<tr>";
					html += "	<th>평가 문항</th>";
					html += "	<td>";
					html += "		<div class='levelInput flex'>";
					html += "			<b class='padding-3 bcLgrey w40'>1</b>";
					html += "			<input type='text' name='vwitmCts' class='width-100per' required='true' />";
					html += "			<button class='btn basic icon' onclick='formOption.createLevelQstnAddHTML(\""+srvypprId+"\")'><i class='xi-plus'></i></button>";
					html += "		</div>";
					html += "	</td>";
					html += "</tr>";
					html += "<tr>";
					html += "	<th>평가 등급</th>";
					html += "	<td>";
					html += "		<div class='flex-item'>";
					html += "			<span class='custom-input'>";
					html += "				<input type='radio' name='vwitmLvl' id='fiveLvl' value='5' onchange='formOption.createLevelChgHTML(\""+srvypprId+"\")' checked='' />";
					html += "				<label for='fiveLvl'>5점 척도</label>";
					html += "			</span>";
					html += "			<span class='custom-input'>";
					html += "				<input type='radio' name='vwitmLvl' id='threeLvl' value='3' onchange='formOption.createLevelChgHTML(\""+srvypprId+"\")' />";
					html += "				<label for='threeLvl'>3점 척도</label>";
					html += "			</span>";
					html += "		</div>";
					html += "		<div class='vwitmLvlDiv'></div>";
					html += "	</td>";
					html += "</tr>";
				$("#"+srvypprId+"QstnForm .qstnTypeDiv > table > tbody").append(html);
			},
			/**
			 * 평가 등급 변경 HTML 추가
			 * @param {String}  srvypprId 	- 설문지아이디
			 */
			createLevelChgHTML: function(srvypprId, itemList) {
				var cnt  = $("#"+srvypprId+"QstnForm input[name=vwitmLvl]:checked").val();
		    	var levelList = <spring:message code='resh.scale.5' />;/* {"5":"매우 그렇다","4":"그렇다","3":"보통","2":"아니다","1":"매우 아니다"} */
		    	if(cnt == 3) {
		    		levelList = <spring:message code='resh.scale.3' />;/* {"3":"그렇다","2":"보통","1":"아니다"} */
		    	}
		    	if(itemList != null) {
		    		levelList = itemList;
		    	}

		    	var html = "";
		    	Object.entries(levelList)
		    		.sort(([a], [b]) => b - a)
		    		.forEach(([key, value]) => {
			    		html += "<div class='flex margin-top-2'>";
			    		html += "	<input type='text' class='text-center width-25per' inputmask='numeric' name='lvlScr' value='"+key+"' required='true' />";
			    		html += "	<p class='padding-3 border-1 w40 margin-right-3'>점</p>";
			    		html += "	<input type='text' class='width-100per' name='lvlCts' value='"+value+"' required='true' />";
			    		html += "</div>";
		    	});
		    	$("#"+srvypprId+"QstnForm .vwitmLvlDiv").empty().append(html);
			},
		    /**
			 * 레벨형 문항 추가 HTML 추가
			 * @param {String}  srvypprId 	- 설문지아이디
			 */
			 createLevelQstnAddHTML: function(srvypprId) {
				var cnt = $(".levelInput").length;

				var html  = "<div class='levelInput flex margin-top-2'>";
					html += "	<b class='padding-3 bcLgrey w40'>" + (cnt + 1) + "</b>";
					html += "	<input type='text' name='vwitmCts' class='width-100per' required='true' />";
					html += "	<button class='btn basic icon' onclick='formOption.levelQstnDelHTML(\""+srvypprId+"\", "+cnt+")'><i class='xi-minus'></i></button>";
					html += "	<button class='btn basic icon' onclick='formOption.createLevelQstnAddHTML(\""+srvypprId+"\")'><i class='xi-plus'></i></button>";
					html += "</div>";
				$("#"+srvypprId+"QstnForm .qstnTypeDiv .levelInput").last().after(html);
			},
			/**
			 * 레벨형 문항 HTML 삭제
			 * @param {String}  srvypprId 	- 설문지아이디
			 * @param {Integer} cnt 		- 삭제할 문항 줄 값
			 */
			levelQstnDelHTML: function(srvypprId, cnt) {
				$("#"+srvypprId+"QstnForm .qstnTypeDiv .levelInput").eq(cnt).remove();
				$("#"+srvypprId+"QstnForm .qstnTypeDiv .levelInput").slice((cnt)).each(function(index, el) {
					$(el).find('b').text(index+cnt+1);
				});
		    },
		    /**
			 * 필수 선택 버튼 HTML 추가
			 * @param {String}  srvypprId 	- 설문지아이디
			 */
		    createEsntlBtnHTML: function(srvypprId) {
		    	var html  = "<tr>";
		    		html += "	<th>필수 선택</th>";
		    		html += "	<td class='t_left'>";
		    		html += "		<input type='checkbox' value='Y' name='esntlRspnsyn' id='"+srvypprId+"esntlRspnsyn' class='switch' />";
		    		html += "	</td>";
		    		html += "</tr>";
		    	$("#"+srvypprId+"QstnForm .qstnTypeDiv > table > tbody").append(html);
		    	UiSwitcher();
		    },
		    /**
			 * 분기 선택 버튼 HTML 추가
			 * @param {String}  srvypprId 	- 설문지아이디
			 */
		    createMvmnBtnHTML: function(srvypprId) {
		    	var html  = "<tr>";
		    		html += "	<th>분기 선택</th>";
		    		html += "	<td class='t_left'>";
		    		html += "		<input type='checkbox' value='Y' name='srvyMvmnUseyn' class='switch' id='"+srvypprId+"srvyMvmnUseyn' onchange='mvmnSelectView(this, \"" + srvypprId + "\")' />";
		    		html += "		<span class='fcRed'>! 한 페이지에 하나의 문항만 분기 가능합니다.</span>";
		    		html += "	</td>";
		    		html += "</tr>";
		    	$("#"+srvypprId+"QstnForm .qstnTypeDiv > table > tbody").append(html);
		    	UiSwitcher();
		    },
		    /**
			 * 기타 보기 버튼 HTML 추가
			 * @param {String}  srvypprId 	- 설문지아이디
			 */
		    createEtcBtnHTML: function(srvypprId) {
		    	var html  = "<tr>";
		    		html += "	<th>기타 보기</th>";
		    		html += "	<td class='t_left'>";
		    		html += "		<input type='checkbox' value='Y' name='etcInptUseyn' class='switch' id='"+srvypprId+"etcInptUseyn' onchange='etcVwitmChgHtml(this, \"" + srvypprId + "\")' />";
		    		html += "	</td>";
		    		html += "</tr>";
		    	$("#"+srvypprId+"QstnForm .qstnTypeDiv > table > tbody").append(html);
		    	UiSwitcher();
		    }
		};

		/**
		 * 설문 부 과제 목록 조회
		 * @param {String}  lrnGrpId 	- 학습그룹아이디
		 * @param {String}  srvyId 		- 설문아이디
		 * @returns {list} 부 과제 목록
		 */
		function srvySubAsmtListSelect() {
			var url  = "/srvy/srvyLrnGrpSubAsmtListAjax.do";
			var data = {
				lrnGrpId  	: "${vo.lrnGrpId}",
				srvyId 		: "${vo.srvyId}"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var returnList = data.returnList || [];
					var html = "";

	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
							html += "<tr>";
							html += "	<th>" + v.teamnm + "</th>";
							html += "	<td>";
							html += "		<table class='table-type2'>";
							html += "			<colgroup>";
							html += "				<col class='width-10per' />";
							html += "				<col class='' />";
							html += "			</colgroup>";
							html += "			<tbody>";
							html += "				<tr>";
							html += "					<th>주제</th>";
							html += "					<td class='t_left'>" + UiComm.escapeHtml(v.srvyTtl) + "</td>";
							html += "				</tr>";
							html += "				<tr>";
							html += "					<th>내용</th>";
							html += "					<td class='t_left'><pre>" + v.srvyCts + "</pre></td>";
							html += "				</tr>";
							html += "			</tbody>";
							html += "		</table>";
							html += "	</td>";
							html += "	<td>" + v.leadernm + " 외 " + (v.teamMbrCnt - 1) + "</td>";
							html += "</tr>";
	        			});
	        		}

	        		$("#srvySubAsmtTbody").append(html);
				}
			}, true);
		}

		/**
		* 설문지문항목록조회
		* @param {String} srvyId 	- 설문아이디
		* @returns {list} 설문지문항목록
		*/
		function srvypprQstnListSelect() {
			var url  = "/srvy/srvypprQstnListAjax.do";
			var data = {
				"srvyId" : $("#srvyId").val()
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					const list = data.returnVO.srvypprList.map(srvyppr => ({
						...srvyppr,
						qstn: data.returnVO.srvyQstnList.filter(qstn => qstn.srvypprId === srvyppr.srvypprId)
					}));
					var qstnCnt = 0;
					if(list.length > 0) {
						qstnCnt = list.reduce((sum, item) => sum + (item.qstn?.length ?? 0), 0);
					}
					$("#qstnCnt").text(qstnCnt);

	        		if(list.length > 0) {
	        			var html = "";
	        			list.forEach(function(v, i) {
							html += "<div class='border-1 margin-bottom-3 srvypprDiv' data-id='" + v.srvypprId + "' data-seqno='" + v.srvySeqno + "'>";
							html += "	<div class='board_top border-1 padding-3'>";
							html += "		<i class='xi-arrows icon-sort ui-sortable-handle'></i>";
							html += "		<span>" + v.srvySeqno + "</span>. " + UiComm.escapeHtml(v.srvyTtl);
							html += "		<div class='right-area'>";
							html += "			<a href='javascript:qstnAddFrmView(\"" + v.srvypprId + "\")' class='btn type7'>문항 추가</a>";
		        			html += "			<a href='javascript:srvypprModifyPopup(\"" + v.srvypprId + "\")' class='btn type7'>페이지수정</a>";
		        			html += "			<a href='javascript:delReshPage(\"" + v.srvyId + "\", \"" + v.srvypprId + "\", \"" + v.srvySeqno + "\")' class='btn type7'>페이지삭제</a>";
							html += "		</div>";
							html += "	</div>";
							html += "	<div class='padding-3 margin-top-0 srvyQstnDiv'>";
							v.qstn.forEach(function(vv, ii) {
								html += "	<div class='sub-content-box board_top sortQstnDiv' data-id='" + vv.srvyQstnId + "' data-seqno='" + vv.qstnSeqno + "' data-pprid='" + vv.srvypprId + "' data-mvmnyn='" + vv.srvyMvmnUseyn + "'>";
	        					html += "		<i class='xi-arrows-v icon-chg'></i>";
	        					html += "		<span>" + v.srvySeqno + ". " + vv.qstnSeqno + "</span>";
	        					html += "		<a href='javascript:qstnModFrmView(\"" + v.srvypprId + "\", \"" + vv.srvyQstnId + "\")'>" + UiComm.escapeHtml(vv.qstnTtl) + "</a>";
	        					html += "		<div class='right-area'>";
	        					html += "			<p>" + vv.qstnRspnsTynm + "</p>";
	        					html += "			<a href='javascript:qstnDelete(\"" + v.srvypprId + "\", \"" + vv.srvyQstnId + "\", \"" + vv.qstnSeqno + "\")' class='btn basic small'>삭제</a>";
	        					html += "		</div>";
	        					html += "	</div>";
							});
							html += "	</div>";
							html += "</div>";
	        			});
	        			$("#srvypprDiv").empty().html(html);

	        			$('#srvypprDiv').sortable({
	        	            connectWith: '#srvypprDiv',
	        	            placeholderClass: '.srvypprDiv',
	        	            placeholder: "portlet-placeholder",
	        	            handle: ".icon-sort",
	        	            opacity: 0.6,
	        	            stop: function(event, ui) {
	        	            	srvySeqnoChange(ui.item);	// 설문지순번 변경
	        	            }
	        	        });

	        			$('.srvyQstnDiv').sortable({
	        	            connectWith: '.srvyQstnDiv',
	        	            placeholderClass: '.sortQstnDiv',
	        	            placeholder: "portlet-placeholder",
	        	            handle: ".icon-chg",
	        	            opacity: 0.6,
	        	            receive: function(event, ui) {
	        	                $(ui.sender).sortable('cancel');
	        	            },
	        	            stop: function(event, ui) {
								qstnSeqnoChange(ui.item);	// 문항순번 변경
	        	            }
	        	        });
	        		} else {
	        			$("#srvypprDiv").empty();
	        		}
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='resh.error.list' />", "error");	/* 설문 리스트 조회 중 에러가 발생하였습니다. */
			});
		}

	 	/**
		* 설문 팀 선택
		* @param {String}  srvyId - 선택 팀에 대한 설문아이디
		*/
	 	function srvyTeamSelect(srvyId) {
			// 팀 버튼 색상 변경
			const teamButtons = document.querySelectorAll('[name="teamButton"]');
			teamButtons.forEach(button => {
			  button.classList.replace('type1', 'type2');
			});
			document.querySelector('button[name="teamButton"][value="' + srvyId + '"]').classList.replace('type2', 'type1');

			$("#srvyId").val(srvyId);
			$("#qstnAddDiv").remove();

			// 문제 관리 버튼 변경
			var html = "";
			<c:forEach var="team" items="${srvyTeamList }">
				if("${team.srvyId}" == srvyId) {
					$("#srvyQstnsCmptnyn").val("${team.srvyQstnsCmptnyn}");
					if("${team.srvyQstnsCmptnyn}" == "Y") {
						html += "<a href='javascript:srvyQstnsCmptnModify(\"edit\", \"dtl\")' class='btn type1'>수정</a>";
					} else {
						html += "<a href='javascript:srvypprRegistPopup()' class='btn type1'>페이지 추가</a>";
						html += "<a href='javascript:qstnCopyPopup()' class='btn type1'>설문 가져오기</a>";
						html += "<a href='javascript:qstnExcelUploadPopup()' class='btn type1'>엑셀 문항등록</a>";
						html += "<a href='javascript:srvyQstnsCmptnModify(\"save\", \"dtl\")' class='btn type1'>출제 완료</a>";
					}
				}
			</c:forEach>
			$("#qstnBtnDiv").empty().html(html);

			srvypprQstnListSelect();
	 	}

		/**
		 * 설문지등록팝업
		 * @param {String}  srvyId - 설문아이디
		 */
	    function srvypprRegistPopup() {
	    	if(!canSrvyEdit()) {
	    		return false;
	    	}

	    	dialog = UiDialog("dialog1", {
				title: "페이지 추가",
				width: 800,
				height: 500,
				url: "/srvy/profSrvypprRegistPopup.do?srvyId="+$("#srvyId").val()
			});
	    }

		/**
		 * 설문지수정팝업
		 * @param {String}  srvyId 		- 설문아이디
		 * @param {String}  srvypprId 	- 설문지아이디
		 */
	    function srvypprModifyPopup(srvypprId) {
	    	if(!canSrvyEdit()) {
	    		return false;
	    	}

	    	var data = "srvyId="+$("#srvyId").val()+"&srvypprId="+srvypprId;

	    	dialog = UiDialog("dialog1", {
				title: "페이지 수정",
				width: 800,
				height: 500,
				url: "/srvy/profSrvypprModifyPopup.do?"+data,
				autoresize: true
			});
	    }

		/**
		 * 설문지삭제
		 * @param {String}  srvyId 		- 설문아이디
		 * @param {String}  srvypprId 	- 설문지아이디
		 * @param {String}  srvySeqno 	- 설문지순번
		 */
		function delReshPage(srvyId, srvypprId, srvySeqno) {
			if(!canSrvyEdit()) {
				return false;
			}

			srvypprPtcpCntSelect(srvyId, srvypprId).done(function(returnVO) {
				var confirm = "";
				if(returnVO.result > 0) {
					confirm = "설문 응시한 학습자가 있습니다. 삭제 시 학습정보가 삭제됩니다. 정말 삭제하시겠습니까?";
		     	} else {
		     		confirm = "설문 응시한 학습자가 없습니다. 삭제 하시겠습니까?";
		     	}
				UiComm.showMessage(confirm, "confirm")
				.then(function(result) {
					if (result) {
						var url  = "/srvy/srvypprDeleteAjax.do";
						var data = {
							"srvyId" 	: srvyId,
							"srvypprId" : srvypprId,
							"srvySeqno"	: srvySeqno
						};

						ajaxCall(url, data, function(data) {
							if (data.result > 0) {
								UiComm.showMessage("<spring:message code='resh.alert.delete' />", "success");	// 정상 삭제되었습니다.
						 		srvypprQstnListSelect();
						     } else {
						      	UiComm.showMessage(data.message, "error");
						     }
						}, function(xhr, status, error) {
							UiComm.showMessage('<spring:message code="resh.error.page.delete" />', "error");	// 설문 페이지 삭제 중 에러가 발생하였습니다.
						});
					}
				});
			});
		}

		// 문제가져오기팝업
		function qstnCopyPopup() {
			if(!canSrvyEdit()) {
				return false;
			}

			var data = "sbjctId=${vo.sbjctId}&srvyId="+$("#srvyId").val();

			dialog = UiDialog("dialog1", {
				title: "설문 가져오기",
				width: 700,
				height: 700,
				url: "/srvy/profSrvyQstnCopyPopup.do?"+data
			});
		}

		/**
		 * 보기항목 수 변경 HTML 추가
		 * @param {String}  srvypprId 	- 설문지아이디
		 * @param {String}  type 		- 문항답변유형코드 ( ONE_CHC : 단일선택형, MLT_CHC : 다중선택형 )
		 */
	    function createVwitmCntChgHTML(srvypprId, type) {
		    var vwitmCnt   = $("#"+srvypprId+"QstnForm .qstnTypeDiv select[name=vwitmCnt]").val();	// 보기 항목 개수 selectBox
		    var vwitmLiCnt = $("#"+srvypprId+"QstnForm .qstnItemTbody .vwitmTr").length;			// 기존 보기항목 수

		    if(vwitmLiCnt < vwitmCnt) {
		 		for(var i = vwitmLiCnt; i < vwitmCnt; i++) {
			 	   	var html  = "<tr class='vwitmTr'>";
			 		   	html += "	<th>";
			 	   		html += "		<span>보기"+(i+1)+"</span>";
			 	   		html += "	</th>";
			 	   		html += "	<td class='t_left flex'>";
			 	   		html += "		<input type='text' class='width-50per' name='vwitmCts' id='"+srvypprId+"Vwitm_"+(i+1)+"' required='true' />";
			 	   		html += "		<div class='etcSelectDiv margin-left-2'>";
			 	   		html += "			<select class='form-select w150' name='mvmnSrvyQstnId' id='"+srvypprId+"Mvmn_"+(i+1)+"'>";
			 	   		html += "				<option value='NEXT'>다음 페이지로 이동</option>";
			 	   		html += "			</select>";
			 	   		html += "		</div>";
			 	   		html += "	</td>";
			 	   		html += "</tr>";

			 	    const lastVwitm = $("#"+srvypprId+"QstnForm .qstnItemTbody .vwitmTr").last();

			 	    if (lastVwitm.length) {
			 	        lastVwitm.after(html);
			 	    } else {
			 	        $("#"+srvypprId+"QstnForm .qstnItemTbody").append(html);
			 	    }
			     	$("#"+srvypprId+"QstnForm .etcSelectDiv select[name=mvmnSrvyQstnId]").chosen({disable_search: true});
			     	if(!$("#"+srvypprId+"QstnForm .qstnTypeDiv input[name=srvyMvmnUseyn]").is(":checked")) {
						$("#"+srvypprId+"QstnForm .qstnTypeDiv .etcSelectDiv").hide();
					}
			     	initSrvypprMvmn(srvypprId, "Y");	// 다음설문지아이디 초기화
		 		}
		    } else if(vwitmLiCnt > vwitmCnt) {
		 		for(var i = vwitmLiCnt; i > vwitmCnt-1; i--) {
		 		 	$("#"+srvypprId+"QstnForm .qstnItemTbody .vwitmTr:eq("+i+")").remove();
		 		}
		    }
	    }

		/**
		* 기타보기항목변경 HTML 추가
		* @param {String}  	srvypprId 	- 설문지아이디
		* @param {obj}  	obj 		- 변경객체
		*/
		function etcVwitmChgHtml(obj, srvypprId) {
			if(obj.checked) {
				var html  = "<tr class='vwitmEtcTr' id='" + srvypprId + "_etc'>";
					html += "	<th>기타</th>";
					html += "	<td class='t_left flex'>";
					html += "		<div class='width-50per'></div>";
					html += "		<div class='etcSelectDiv margin-left-2'>";
					html += "			<select class='form-select w150' name='mvmnSrvyQstnId'>";
		 	   		html += "				<option value='NEXT'>다음 페이지로 이동</option>";
		 	   		html += "			</select>";
					html += "		</div>";
					html += "	</td>";
					html += "</tr>";
				$("#"+srvypprId+"QstnForm .qstnItemTbody").append(html);
				$("#"+srvypprId+"QstnForm .etcSelectDiv select[name=mvmnSrvyQstnId]").chosen({disable_search: true});
				if(!$("#"+srvypprId+"QstnForm .qstnTypeDiv input[name=srvyMvmnUseyn]").is(":checked")) {
					$("#"+srvypprId+"QstnForm .qstnTypeDiv .etcSelectDiv").hide();
				}
				initSrvypprMvmn(srvypprId, "Y");	// 다음설문지아이디 초기화
			} else {
				$("#"+srvypprId+"_etc").remove();
			}
		}

		/**
		* 분기선택보기
		* @param {String}  	srvypprId 	- 설문지아이디
		* @param {obj}  	obj 		- 변경객체
		*/
		function mvmnSelectView(obj, srvypprId) {
			let srvyQstnId = $("#"+srvypprId+"QstnForm input[name=srvyQstnId]").val();
			if(obj.checked) {
				var isMvmn = false;
				$("div.srvypprDiv[data-id='"+srvypprId+"'] div.sortQstnDiv:not([data-id='"+srvyQstnId+"']").each(function(i) {
					if($(this).attr("data-mvmnyn") == "Y") {
						isMvmn = true;
					}
				});
				if(isMvmn) {
					UiSwitcherOff(obj.id);
					UiComm.showMessage("한 페이지에 하나의 문항만 분기 가능합니다.", "info");
					return false;
				}
				$("#"+srvypprId+"QstnForm .qstnTypeDiv .etcSelectDiv").show();
			} else {
				$("#"+srvypprId+"QstnForm .qstnTypeDiv .etcSelectDiv").hide();
			}
		}

		/**
		 * 문항답변유형코드 변경
		 * @param {String} srvypprId 	- 설문지아이디
		 */
	    function qstnRspnsTycdChgChange(srvypprId) {
	    	$("#"+srvypprId+"QstnForm .qstnTypeDiv > table > tbody").empty();				// 문항보기항목 비우기

	        var type = $("#" + srvypprId + "QstnForm select[name=qstnRspnsTycd]").val();	// 문항답변유형코드
	        // 단일선택형, 다중선택형
	        if(type == "ONE_CHC" || type == "MLT_CHC") {
	        	formOption.createVwitmCntHTML(srvypprId, type);								// 보기항목 수 HTML 추가
	        	formOption.createChgQstnHTML(srvypprId);									// 단일, 다중선택형 문항 HTML 추가
	        	createVwitmCntChgHTML(srvypprId, type);										// 보기항목 수 변경 HTML 추가
	        	formOption.createEtcBtnHTML(srvypprId);										// 기타 보기 버튼 HTML 추가
	        	formOption.createMvmnBtnHTML(srvypprId);									// 분기 선택 버튼 HTML 추가

	        // OX선택형
	        } else if(type == "OX_CHC") {
	        	formOption.createOxQstnHTML(srvypprId);										// OX선택형 문항 HTML 추가
	        	formOption.createMvmnBtnHTML(srvypprId);									// 분기 선택 버튼 HTML 추가

	        // 레벨형
	        } else if(type == "LEVEL") {
				formOption.createLevelQstnHTML(srvypprId);									// 레벨형 문항 HTML 추가
				formOption.createLevelChgHTML(srvypprId);									// 평가 등급 변경 HTML 추가
	        }

	        formOption.createEsntlBtnHTML(srvypprId);										// 필수 선택 버튼 HTML 추가
	    }

		/**
		* 문제 추가 폼 보기
		* @param {String} srvypprId - 설문지아이디
		*/
	    function qstnAddFrmView(srvypprId) {
	    	if(!canSrvyEdit()) {
	    		return false;
	    	}

	    	qstnAddFrmInit(srvypprId);	// 문제 추가 폼 초기화
	    	var qstnCnt = $(".sortQstnDiv[data-pprid='" + srvypprId + "']").length + 1
	    	$("#" + srvypprId + "QstnForm input[name=qstnSeqno]").val(qstnCnt);
	    	$("#" + srvypprId + "QstnForm input[name=qstnTtl]").val(qstnCnt + "문항");
	    }

		/**
		* 문제 수정 폼 보기
		* @param {String} srvypprId 	- 설문지아이디
		* @param {String} srvyQstnId	- 설문문항아이디
		*/
	    function qstnModFrmView(srvypprId, srvyQstnId) {
			if(!canSrvyEdit()) {
		    	return false;
		    }

			qstnAddFrmInit(srvypprId);	// 문제 추가 폼 초기화
		    $("#"+srvypprId+"QstnForm .addBtn").attr("href", "javascript:qstnModify(\"" + srvypprId + "\")");
	    	var url  = "/srvy/srvyQstnSelectAjax.do";
			var data = {
				  "srvypprId" : srvypprId
				, "srvyQstnId" : srvyQstnId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var qstn = data.returnVO.srvyQstnVO;				// 설문문항정보
					var vwitmList = data.returnVO.srvyVwitmList;		// 설문보기항목목록
					var lvlList = data.returnVO.srvyQstnVwitmLvlList;	// 설문문항보기항목레벨목록

					// 공통 값 적용
	        		$("#"+srvypprId+"QstnForm input[name=srvyQstnId]").val(qstn.srvyQstnId);
	        		$("#"+srvypprId+"QstnForm input[name=qstnSeqno]").val(qstn.qstnSeqno);
	        		$("#"+srvypprId+"QstnForm input[name=qstnTtl]").val(qstn.qstnTtl);
	        		editorMap["editor"+srvypprId].insertHTML($.trim(qstn.qstnCts) == "" ? " " : qstn.qstnCts);
	        		$("#"+srvypprId+"QstnForm select[name=qstnRspnsTycd]").val(qstn.qstnRspnsTycd).trigger("chosen:updated");
	        		$("#"+srvypprId+"QstnForm select[name=qstnRspnsTycd]").trigger("change");
	        		// 단일, 다중선택형
	        		if(qstn.qstnRspnsTycd == "ONE_CHC" || qstn.qstnRspnsTycd == "MLT_CHC") {
						// 보기내용
						var vwitmCnt = qstn.etcInptUseyn == "Y" ? vwitmList.length - 1 : vwitmList.length;
	        			$("#"+srvypprId+"QstnForm select[name=vwitmCnt]").val(vwitmCnt).trigger("chosen:updated");
	        			$("#"+srvypprId+"QstnForm select[name=vwitmCnt]").trigger("change");
	        			vwitmList.forEach(function(v, i) {
	        				$("#"+srvypprId+"Vwitm_"+v.vwitmSeqno).val(v.vwitmCts);
	        			});
	        			// 필수 선택
	        			if(qstn.esntlRspnsyn == "Y") UiSwitcherOn(srvypprId+"esntlRspnsyn");
	        			// 기타 보기
	        			if(qstn.etcInptUseyn == "Y") {
	        				UiSwitcherOn(srvypprId+"etcInptUseyn");
	        				$("#"+srvypprId+"etcInptUseyn").trigger("change");
	        			}
	        			// 분기 선택
	        			if(qstn.srvyMvmnUseyn == "Y") {
	        				UiSwitcherOn(srvypprId+"srvyMvmnUseyn");
	        				$("#"+srvypprId+"srvyMvmnUseyn").trigger("change");
	        				vwitmList.forEach(function(v, i) {
								$("#"+srvypprId+"QstnForm .etcSelectDiv select[name=mvmnSrvyQstnId]").eq(i).val(v.mvmnSrvyQstnId).trigger('chosen:updated');
		        			});
	        			}
	        		// OX선택형
	        		} else if(qstn.qstnRspnsTycd == "OX_CHC") {
	        			// 필수 선택
	        			if(qstn.esntlRspnsyn == "Y") UiSwitcherOn(srvypprId+"esntlRspnsyn");
	        			// 분기 선택
	        			if(qstn.srvyMvmnUseyn == "Y") {
	        				UiSwitcherOn(srvypprId+"srvyMvmnUseyn");
	        				$("#"+srvypprId+"srvyMvmnUseyn").trigger("change");
	        				vwitmList.forEach(function(v, i) {
								$("#"+srvypprId+"QstnForm .etcSelectDiv select[name=mvmnSrvyQstnId]").eq(i).val(v.mvmnSrvyQstnId).trigger('chosen:updated');
		        			});
	        			}
					// 레벨형
	        		} else if(qstn.qstnRspnsTycd == "LEVEL") {
						// 평가 문항
	        			vwitmList.forEach(function(v, i) {
							if(i > 0) {
								formOption.createLevelQstnAddHTML(srvypprId);	// 레벨형 문항 추가 HTML 추가
							}
							$("#"+srvypprId+"QstnForm input[name=vwitmCts]").eq(i).val(v.vwitmCts);
	        			});
						// 평가 등급
						$("#"+srvypprId+"QstnForm input[name=vwitmLvl][value='"+lvlList.length+"']").prop("checked", true).trigger("change");
						const qstnLvlList = Object.fromEntries(
							lvlList.map(item => [item.lvlScr, item.lvlCts])
						);
						formOption.createLevelChgHTML(srvypprId, qstnLvlList);
	        			// 필수 선택
	        			if(qstn.esntlRspnsyn == "Y") UiSwitcherOn(srvypprId+"esntlRspnsyn");
	        		}
	        	} else {
	        		UiComm.showMessage(data.message, "error");
	        	}
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");	/* 에러가 발생했습니다! */
			});
	    }

	 	// 문제 폼 초기화
	    function qstnAddFrmInit(srvypprId) {
	    	var editorKey = "editor"+srvypprId;						// 문제 내용 에디터 저장 키 값
	    	var editorId = "qstnCts" + $('.srvypprDiv[data-id="' + srvypprId + '"]').data('seqno');	// 문제 내용 에디터 아이디

	    	$("#"+srvypprId+"QstnForm").remove();
	    	formOption.createQstnHeaderHTML(srvypprId, editorId);	// 문제 말머리 HTML 추가
	    	formOption.createQstnBtnHTML(srvypprId);				// 문제 버튼 HTML 추가
	    	editorMap[editorKey] = UiEditor({
				targetId: editorId,
				uploadPath: "/srvy",
				height: "400px"
			});														// 문항내용 html 에디터 생성
			qstnRspnsTycdChgChange(srvypprId);						// 문항답변유형코드 변경 이벤트
	    }

		// 설문지참여수조회
		function srvypprPtcpCntSelect(srvyId, srvypprId) {
			var deferred = $.Deferred();

			var url = "/srvy/srvypprPtcpCntSelectAjax.do";
			var data = {
				"sbjctId" 	: "${vo.sbjctId}",
				"srvyId" 	: srvyId,
				"srvypprId" : srvypprId
			};

			ajaxCall(url, data, function(data) {
				if(data.result >= 0) {
					deferred.resolve(data.result);
			    } else {
			    	UiComm.showMessage(data.message, "error");
			    	deferred.reject();
			    }
			}, function(xhr, status, error) {
				UiComm.showMessage('<spring:message code="fail.common.msg" />', "error");// 에러가 발생했습니다!
				deferred.reject();
			}, true);

			return deferred.promise();
		}

		/**
		* 문항 추가 폼 제거
		* @param {String}  srvypprId - 설문지아이디
		*/
	 	function qstnAddFrmRemove(srvypprId) {
			$("#"+srvypprId+"QstnForm").remove();
	 	}

		/**
		 * 문항 등록
		 * @param {String}  srvypprId - 설문지아이디
		 */
		function qstnRegist(srvypprId) {
			if(!canSrvyEdit()) {
		    	return false;
		    }

			UiValidator(srvypprId+"QstnForm").then(function(result) {
				if (result) {
					if(!isValidSrvyQstn(srvypprId)) {
					 	return false;
					}

					UiComm.showLoading(true);
					var url = "/srvy/srvyQstnRegistAjax.do";

					$.ajax({
						url 	 : url,
					    async	 : false,
					    type 	 : "POST",
					    dataType : "json",
					    data 	 : $("#"+srvypprId+"QstnForm").serialize(),
					}).done(function(data) {
						UiComm.showLoading(false);
					 	if (data.result > 0) {
					 		srvypprQstnListSelect();
					 		$("#"+srvypprId+"QstnForm").remove();
					     } else {
					    	 UiComm.showMessage(data.message, "error");
					     }
					}).fail(function() {
						 UiComm.showLoading(false);
						 UiComm.showMessage("<spring:message code='exam.error.qstn.insert' />", "error");/* 문항 등록 중 에러가 발생하였습니다. */
					});
				}
			});
	    }

		/**
		 * 문항 수정
		 * @param {String}  srvypprId - 설문지아이디
		 */
		function qstnModify(srvypprId) {
			if(!canSrvyEdit()) {
		    	return false;
		    }

			UiValidator(srvypprId+"QstnForm").then(function(result) {
				if (result) {
					if(!isValidSrvyQstn(srvypprId)) {
					 	return false;
					}

					UiComm.showLoading(true);
					var url = "/srvy/srvyQstnModifyAjax.do";

					$.ajax({
						url 	 : url,
					    async	 : false,
					    type 	 : "POST",
					    dataType : "json",
					    data 	 : $("#"+srvypprId+"QstnForm").serialize(),
					}).done(function(data) {
						UiComm.showLoading(false);
					 	if (data.result > 0) {
					 		srvypprQstnListSelect();
					     } else {
					    	 UiComm.showMessage(data.message, "error");
					     }
					}).fail(function() {
						 UiComm.showLoading(false);
						 UiComm.showMessage("<spring:message code='exam.error.qstn.update' />", "error");/* 문항 수정 중 에러가 발생하였습니다. */
					});
				}
			});
		}

		 /**
		 * 문항 삭제
		 * @param {String}  srvypprId 	- 설문지아이디
		 * @param {String}  srvyQstnId 	- 설문문항아이디
		 * @param {String}  qstnSeqno 	- 문항순번
		 */
		function qstnDelete(srvypprId, srvyQstnId, qstnSeqno) {
			if(!canSrvyEdit()) {
		    	return false;
		    }

			var srvyId = $("#srvyId").val();
			srvypprPtcpCntSelect(srvyId, srvypprId).done(function(returnVO) {
				var confirm = "";
				if(returnVO.result > 0) {
					confirm = "설문 응시한 학습자가 있습니다. 삭제 시 학습정보가 삭제됩니다. 정말 삭제하시겠습니까?";
		     	} else {
		     		confirm = "설문 응시한 학습자가 없습니다. 삭제 하시겠습니까?";
		     	}
				UiComm.showMessage(confirm, "confirm")
				.then(function(result) {
					if (result) {
						var url  = "/srvy/srvyQstnDeleteAjax.do";
						var data = {
							"srvypprId" 	: srvypprId,
							"srvyQstnId" 	: srvyQstnId,
							"qstnSeqno"		: qstnSeqno,
							"delyn"			: "Y"
						};

						ajaxCall(url, data, function(data) {
							if (data.result > 0) {
								UiComm.showMessage("<spring:message code='resh.alert.delete' />", "success");	// 정상 삭제되었습니다.
						 		srvypprQstnListSelect();
						     } else {
						      	UiComm.showMessage(data.message, "error");
						     }
						}, function(xhr, status, error) {
							UiComm.showMessage('설문 문항 삭제 중 에러가 발생하였습니다.', "error");
						});
					}
				});
			});
		}

		/**
		* 퀴즈 문항 유효성 검사
		* @param {String}  srvypprId - 설문지아이디
		*/
		function isValidSrvyQstn(srvypprId) {
			var formId = srvypprId+"QstnForm";

			var qstnRspnsTycd = $("#"+formId+" select[name=qstnRspnsTycd]").val();	// 문항답변유형코드
			$("#"+formId).find("input[name=qstns]").remove();
			$("#"+formId).find("input[name=lvls]").remove();

			const qstns = [];	// 문항 등록용
			const lvls = [];	// 레벨 등록용

			// 단일, 다중선택형
			if(qstnRspnsTycd == "ONE_CHC" || qstnRspnsTycd == "MLT_CHC") {
				var vwitmCnt = $("#"+formId+" select[name=vwitmCnt]").val();	// 보기항목수
				for(var i = 1; i <= vwitmCnt; i++) {
					const map = {
						vwitmSeqno: i,
						vwitmCts: $("#"+srvypprId+"Vwitm_"+i).val(),
						mvmnSrvyQstnId: $("#"+formId+" input[name=srvyMvmnUseyn]").prop("checked") ? $("#"+srvypprId+"Mvmn_"+i).val() : ""
					};

					qstns.push(map);
				}

				// 기타 보기 선택시
				if($("#"+formId+" input[name=etcInptUseyn]").prop("checked")) {
					const map = {
						vwitmSeqno: i,
						vwitmCts: "ETC",
						mvmnSrvyQstnId: $("#"+formId+" input[name=srvyMvmnUseyn]").prop("checked") ? $("#"+formId+" select[name=mvmnSrvyQstnId]").last().val() : ""
					};

					qstns.push(map);
				}

			// OX선택형
			} else if(qstnRspnsTycd == "OX_CHC") {
			    for(var i = 1; i <= 2; i++) {
			    	const map = {
			    		vwitmSeqno: i,
			    		vwitmCts: $("#"+formId).find("input[name=vwitmCts]").eq(i-1).val(),
			    		mvmnSrvyQstnId: $("#"+formId+" input[name=srvyMvmnUseyn]").prop("checked") ? $("#"+formId+" select[name=mvmnSrvyQstnId]").val() : ""
			    	};

			    	qstns.push(map);
			    }

			// 레벨형
			} else if(qstnRspnsTycd == "LEVEL") {
				var vwitmCnt = $("#"+formId+" input[name=vwitmCts]").size();	// 보기항목수
				for(var i = 1; i <= vwitmCnt; i++) {
					const map = {
						vwitmSeqno: i,
						vwitmCts: $("#"+formId+" input[name=vwitmCts]").eq(i-1).val()
					};

					qstns.push(map);
				}

				var vwitmLvl = $("#"+formId+" input[name=vwitmLvl]:checked").val();	// 평가등급
				for(var i = 1; i <= vwitmLvl; i++) {
					const map = {
						lvlSeqno: i,
						lvlScr: $("#"+formId+" input[name=lvlScr]").eq(i-1).val(),
						lvlCts: $("#"+formId+" input[name=lvlCts]").eq(i-1).val()
					};

					lvls.push(map);
				}

				$("#"+formId).append("<input type='hidden' name='lvls' />");
				$("#"+formId+" input[name=lvls]").val(JSON.stringify(lvls));
			}

			$("#"+formId).append("<input type='hidden' name='qstns' />");
			$("#"+formId+" input[name=qstns]").val(JSON.stringify(qstns));

			return true;
		}

		/**
		* 설문수정가능여부
		* @param {String} type - (edit : 수정, save : 제출완료)
		*/
		function canSrvyEdit(type) {
			// 출제 완료 여부
			var isSubmit = $("#srvyQstnsCmptnyn").val() == "Y";
			// 시작 전 여부
			var isWait	 = "${today}" > "${vo.srvySdttm}";
			// 제출자 여부
			var isJoin   = parseInt("${vo.ptcpUserCnt}") > 0;
			if(isSubmit && type == undefined) {
				UiComm.showMessage("<spring:message code='exam.alert.click.edit.submit.btn' />", "info");	/* 수정 버튼 클릭 후 문제 수정이 가능합니다. */
				return false;
			}
			if(isSubmit && type == "edit" && isWait && isJoin) {
				UiComm.showMessage("<spring:message code='resh.confirm.answer.user.y.edit.item' />", "confirm")	/* 설문 응시자가 있습니다. 설문 문항을 수정하시겠습니까? */
				.then(function(result) {
					if (result) {
						return true;
					}
					else {
						return false;
					}
				});
			}

			return true;
		}

		/**
		 * 설문지순번 변경
		 * @param {obj}  item - 문항순번 변경할 문항
		 */
	    function srvySeqnoChange(item) {
			if(!canSrvyEdit()) {
		    	return false;
		    }

	    	var seqno 	  	= item.attr("data-seqno");	// 설문지순번
	    	var newSeqno 	= 1;						// 변경할 설문지순번

	    	$("div.srvypprDiv").each(function(i) {
	    		if(seqno == $(this).attr("data-seqno")) {
	    			newSeqno = i + 1;
	    		}
	    	});

	    	if(seqno != newSeqno) {
	    		var url  = "/srvy/srvySeqnoModifyAjax.do";
	    		var data = {
	    			"srvyId"	: $("#srvyId").val(),
	    			"srvySeqno"	: newSeqno,
	    			"searchKey" : seqno
	    		};

	    		ajaxCall(url, data, function(data) {
	    			if (data.result > 0) {
	    				srvypprQstnListSelect();
	                } else {
	                	UiComm.showMessage(data.message, "error");
	                }
	    		}, function(xhr, status, error) {
	    			UiComm.showMessage("설문지순번 변경 중 에러가 발생하였습니다.", "error");
	    		}, true);
	    	}
	    }

		/**
		 * 문항순번 변경
		 * @param {obj}  obj - 문항후보순번 변경할 문항
		 */
		function qstnSeqnoChange(obj) {
			if(!canSrvyEdit()) {
		    	return false;
		    }

			var srvypprId 		= obj.attr("data-pprId");	// 설문지아이디
			var qstnSeqno 		= obj.attr("data-seqno");	// 문항순번
			var newQstnSeqno 	= 1;						// 변경할 문항순번

			// 변경할 순번값 찾기
			$("div.srvypprDiv[data-id='"+srvypprId+"'] div.sortQstnDiv").each(function(i) {
				if(qstnSeqno == $(this).attr("data-seqno")) {
					newQstnSeqno = i + 1;
				}
			});

			if(qstnSeqno != newQstnSeqno) {
				var url  = "/srvy/qstnSeqnoModifyAjax.do";
				var data = {
					"srvypprId"	: srvypprId,
					"qstnSeqno"	: newQstnSeqno,
					"searchKey" : qstnSeqno
				};

				ajaxCall(url, data, function(data) {
					if (data.result > 0) {
						srvypprQstnListSelect();
		            } else {
		            	UiComm.showMessage(data.message, "error");
		            }
				}, function(xhr, status, error) {
					UiComm.showMessage("문항순번 변경 중 에러가 발생하였습니다.", "error");
				}, true);
			}
		}

		// 문항엑셀업로드팝업
		function qstnExcelUploadPopup() {
			if(!canSrvyEdit()) {
		    	return false;
		    }

			dialog = UiDialog("dialog1", {
				title: "엑셀 문항등록",
				width: 600,
				height: 500,
				url: "/srvy/profSrvyQstnExcelUploadPopup.do?srvyId="+$("#srvyId").val(),
				autoresize: true
			});
		}

		/**
		 * 설문출제완료수정
		 * @param {String} type	- 저장 구분 ( save : 저장, edit : 수정 )
		 * @param {String} gbn	- 구분 ( bsc : 전체, dtl : 팀 )
		 */
	    function srvyQstnsCmptnModify(type, gbn) {
			 var isQstn = true;
			 if(type == "save") {
			 	if($(".srvypprDiv").length == 0) {
			 		isQstn = false;
			 	} else {
			 		$('.srvypprDiv').each(function(index) {
			 		    const count = $(this).find('.sortQstnDiv').length;
			 		    if(count == 0) {
			 				isQstn = false;
			 				return;
			 		    }
			 		});
			 	}
			 }

			 if(!isQstn) {
				UiComm.showMessage("<spring:message code='resh.alert.qstn.item.submit' />", "warning");	/* 설문 문항 추가 후 출제완료 가능합니다. */
				return false;
			}

			if(gbn != undefined && gbn == "bsc") {
				if(${not isQstnsCmptn}) {
					UiComm.showMessage("모든 팀의 문제를 출제완료 해주세요.", "info");
					return false;
				}
			}

			if(canSrvyEdit(type)) {
				var confirmMsg = "<spring:message code='exam.confirm.exam.qstn.submit' />"; // 문제를 출제하시겠습니까?
				if(type == "edit") {
					confirmMsg = "<spring:message code='exam.confirm.exam.qstn.edit' />"; // 문제를 수정하시겠습니까?
				}
				UiComm.showMessage(confirmMsg, "confirm")
				.then(function(result) {
					if (result) {
						var url  = "/srvy/srvyQstnsCmptnModifyAjax.do";
						var data = {
							"upSrvyId"   	: "${vo.srvyId}",
							"srvyId"		: $("#srvyId").val(),
							"srvyGbncd"		: "${vo.srvyGbn}",
							"searchGubun" 	: type,
							"searchKey"		: gbn
						};

						$.ajax({
				            url 	 : url,
				            async	 : false,
				            type 	 : "POST",
				            dataType : "json",
				            data 	 : data,
				        }).done(function(data) {
				        	UiComm.showLoading(false);
				        	if (data.result > 0) {
				        		srvyViewMv(1);
				            } else {
				            	UiComm.showMessage(data.message, "error");
				            }
				        }).fail(function() {
				        	UiComm.showLoading(false);
				        	UiComm.showMessage("<spring:message code='exam.error.qstn.submit' />", "error");/* 문항 출제 중 에러가 발생하였습니다. */
				        });
					}
				});
			}
	    }

		// 다음설문지아이디 초기화
		function initSrvypprMvmn(srvypprId, lastyn) {
			var html = "<option value='NEXT'>다음 페이지로 이동</option>";
			let srvySeqno = $(".srvypprDiv[data-id='"+srvypprId+"']").attr("data-seqno");
			$(".srvypprDiv").filter(function () {
				return parseInt($(this).attr("data-seqno"), 10) > srvySeqno;
			}).each(function () {
				let seqno 	= $(this).attr("data-seqno");
				let id		= $(this).attr("data-id");
				html += "<option value='" + id + "'>" + seqno + "페이지로 이동</option>";
			});
			html += "<option value='END'>설문 종료</option>";

			if(lastyn == "Y") {
				$("#"+srvypprId+"QstnForm .etcSelectDiv select[name=mvmnSrvyQstnId]").last().empty().append(html);
				$("#"+srvypprId+"QstnForm .etcSelectDiv select[name=mvmnSrvyQstnId]").last().val('NEXT').trigger('chosen:updated');
			} else {
				$("#"+srvypprId+"QstnForm .etcSelectDiv select[name=mvmnSrvyQstnId]").empty().append(html);
				$("#"+srvypprId+"QstnForm .etcSelectDiv select[name=mvmnSrvyQstnId]").val('NEXT').trigger('chosen:updated');
			}
		}

		/**
		 * 설문화면이동
		 * @param {String}  srvyId 		- 설문아이디
		 * @param {String}  sbjctId 	- 과목아이디
		 */
		function srvyViewMv(tab) {
			var urlMap = {
				"1" : "/srvy/profSrvyQstnMngView.do",	// 설문 문항 관리 화면
				"2" : "/srvy/profSrvyEvlMngView.do",	// 설문 평가 관리 화면
				"9" : "/srvy/profSrvyListView.do" 		// 설문 목록 화면
			};

			var kvArr = [];

			kvArr.push({'key' : 'srvyId',   	'val' : "${vo.srvyId}"});
			kvArr.push({'key' : 'sbjctId', 		'val' : "${vo.sbjctId}"});

			submitForm(urlMap[tab], kvArr);
		}
	</script>
</head>

<body class="class colorA">
    <div id="wrap" class="main">
		<!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <!-- classroom -->
        <main class="common">

        	<!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
            	<div class="class_sub_top">
					<div class="navi_bar">
						<ul>
							<li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
							<li>강의실</li>
							<li><span class="current">내강의실</span></li>
						</ul>
					</div>
					<div class="btn-wrap">
						<div class="first">
							<select class="form-select">
								<option value="2025년 2학기">2025년 2학기</option>
								<option value="2025년 1학기">2025년 1학기</option>
							</select>
							<select class="form-select wide">
								<option value="">강의실 바로가기</option>
								<option value="2025년 2학기">2025년 2학기</option>
								<option value="2025년 1학기">2025년 1학기</option>
							</select>
						</div>
						<div class="sec">
							<button type="button" class="btn type1"><i class="xi-book-o"></i>교수 매뉴얼</button>
							<button type="button" class="btn type1"><i class="xi-info-o"></i>학습안내정보</button>
						</div>
					</div>
				</div>

				<div class="class_sub">
					<div class="sub-content qstn">
						<div class="page-info">
				        	<h2 class="page-title">
                                <spring:message code="resh.label.resh" /><!-- 설문 -->
                            </h2>
				        </div>
				        <div class="board_top">
					        <div class="right-area">
					        	<a href="javascript:srvyViewMv(9)" class="btn type2"><spring:message code="exam.button.list" /></a><!-- 목록 -->
					        </div>
				        </div>

						<div class="listTab">
					        <ul>
					            <li class="mw120"><a onclick="srvyViewMv(2)">설문정보 및 평가</a></li>
					            <li class="select mw120"><a onclick="srvyViewMv(1)">문항관리</a></li>
					        </ul>
					    </div>

					    <div class="accordion">
							<div class="title flex">
								<div class="title_cont">
									<div class="left_cont">
										<div class="lectTit_box">
											<spring:message code="exam.common.yes" var="yes" /><!-- 예 -->
											<spring:message code="exam.common.no" var="no" /><!-- 아니오 -->
											<p class="lect_name">${fn:escapeXml(vo.srvyTtl) }</p>
											<span class="fcGrey">
												<small>설문 기간 : <uiex:formatDate type="datetime" value="${vo.srvySdttm }"/> ~ <uiex:formatDate type="datetime" value="${vo.srvyEdttm }"/></small> |
												<small><spring:message code="exam.label.score.aply.y" /><!-- 성적반영 --> : ${vo.mrkRfltyn eq 'Y' ? yes : no }</small> |
												<small><spring:message code="exam.label.score.open.y" /><!-- 성적공개 --> : ${vo.mrkOyn eq 'Y' ? yes : no }</small>
											</span>
										</div>
									</div>
								</div>
								<i class="dropdown icon ml20"></i>
							</div>
							<div class="content" style="padding:0;">
								<!--table-type-->
				        		<div class="table-wrap">
				        			<table class="table-type2">
				        				<colgroup>
				        					<col class="width-20per" />
				        					<col class="" />
				        				</colgroup>
				        				<tbody>
				        					<tr>
				        						<th><label>설문내용</label></th>
				        						<td class="t_left" colspan="3"><pre>${vo.srvyCts }</pre></td>
				        					</tr>
				        					<tr>
				        						<th><label>응시기간</label></th>
				        						<td class="t_left" colspan="3"><uiex:formatDate type="datetime" value="${vo.srvySdttm }"/> ~ <uiex:formatDate type="datetime" value="${vo.srvyEdttm }"/></td>
				        					</tr>
				        					<tr>
				        						<th><label>성적반영</label></th>
				        						<td class="t_left">${vo.mrkRfltyn eq 'Y' ? yes : no }</td>
				        						<th><label>성적 반영비율</label></th>
				        						<td class="t_left">${vo.mrkRfltyn eq 'Y' ? vo.mrkRfltrt : '0' }%</td>
				        					</tr>
				        					<tr>
				        						<th><label>성적공개</label></th>
				        						<td class="t_left" colspan="3">${vo.mrkOyn eq 'Y' ? yes : no }</td>
				        					</tr>
				        					<tr>
				        						<th><label>평가방법</label></th>
				        						<td class="t_left" colspan="3">
				        							<c:choose>
														<c:when test="${vo.evlScrTycd eq 'SCR' }">
															점수형
														</c:when>
														<c:otherwise>
															참여형 <span class="fcBlue">( 설문 참여 : 100점, 미참여 : 0점 자동배점 )</span>
														</c:otherwise>
													</c:choose>
				        						</td>
				        					</tr>
				        					<tr>
				        						<th><label>설문결과 조회가능</label></th>
				        						<td class="t_left" colspan="3">${vo.rsltOpenTycd eq 'WHOL_OPEN' ? yes : no }</td>
				        					</tr>
				        					<tr>
				        						<th><label>팀 설문</label></th>
				        						<td class="t_left" colspan="3">
				        							<c:choose>
														<c:when test="${vo.examGbn eq 'SRVY_TEAM' }">

															<p>학습그룹 : ${vo.lrnGrpnm }</p>
															<p>학습그룹별 부 과제 설정 : ${vo.byteamSubsrvyUseyn eq 'Y' ? '사용' : '미사용' }</p>
															<c:if test="${vo.byteamSubsrvyUseyn eq 'Y' }">
																<table class="table-type2">
											        				<colgroup>
											        					<col class="width-10per" />
											        					<col class="" />
											        					<col class="width-20per" />
											        				</colgroup>
											        				<tbody id="srvySubAsmtTbody">
											        					<tr>
											        						<th><label>팀</label></th>
											        						<th><label>부주제</label></th>
											        						<th><label>학습그룹 구성원</label></th>
											        					</tr>
											        				</tbody>
											        			</table>
															</c:if>
														</c:when>
														<c:otherwise>${no }</c:otherwise>
													</c:choose>
				        						</td>
				        					</tr>
				        				</tbody>
				        			</table>
				        		</div>
							</div>
						</div>

						<div class="board_top margin-top-4">
							<input type="hidden" id="srvyId" value="${vo.subSrvyId }" />
							<input type="hidden" id="srvyQstnsCmptnyn" value="${vo.srvyQstnsCmptnyn }" />
							<c:if test="${vo.srvyGbn eq 'SRVY_TEAM' }">
								<c:forEach var="item" items="${srvyTeamList }">
									<button class="btn type2" name="teamButton" value="${item.srvyId }" onclick="srvyTeamSelect('${item.srvyId }')">${item.teamnm }</button>
								</c:forEach>
								<div class="right-area">
									<c:choose>
										<c:when test="${vo.srvyQstnsCmptnyn eq 'Y' }">
											<a href="javascript:srvyQstnsCmptnModify('edit', 'bsc')" class="btn type1">수정</a>
										</c:when>
										<c:otherwise>
											<a href="javascript:srvyQstnsCmptnModify('save', 'bsc')" class="btn type1">출제 완료</a>
										</c:otherwise>
									</c:choose>
								</div>
							</c:if>
						</div>

						<div class="">
							<div class="board_top">
								<h3>출제 문항 : <span id="qstnCnt">0</span>문항</h3>
								<c:if test="${vo.srvyQstnsCmptnyn ne 'Y' || vo.srvyGbn ne 'SRVY_TEAM' }">
									<div class="right-area" id="qstnBtnDiv">
										<c:choose>
											<c:when test="${vo.srvyQstnsCmptnyn eq 'Y'}">
												<a href="javascript:srvyQstnsCmptnModify('edit', 'dtl')" class="btn type1">수정</a>
											</c:when>
											<c:otherwise>
												<a href="javascript:srvypprRegistPopup()" class="btn type1">페이지 추가</a>
												<a href="javascript:qstnCopyPopup()" class="btn type1">설문 가져오기</a>
										        <a href="javascript:qstnExcelUploadPopup()" class="btn type1">엑셀 문항등록</a>
										        <a href="javascript:srvyQstnsCmptnModify('save', 'dtl')" class="btn type1">출제 완료</a>
											</c:otherwise>
										</c:choose>
									</div>
								</c:if>
							</div>

							<div class="ui-sortable" id="srvypprDiv"></div>
						</div>

						<div class="fcBlue examQstnsCmptnClass">
							<p>* 출제완료 클릭 전에는 “임시저장” 상태입니다.</p>
							<p>* 문항 출제 완료되면 “출제완료” 버튼을 반드시 클릭해 주세요.</p>
						</div>
					</div>
				</div>
			</div>
			<!-- //content -->
		</main>
		<!-- //classroom-->
    </div>
</body>
</html>