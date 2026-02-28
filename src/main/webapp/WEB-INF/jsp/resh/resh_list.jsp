<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<%@ include file="/WEB-INF/jsp/resh/common/resh_common_inc.jsp" %>
	
	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
	
	<script type="text/javascript">
		$(document).ready(function () {
			listResh();
			
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					listResh();
				}
			});
			
			$("#listType").on("click", function() {
				$(this).children("i").toggleClass("list th");
				listResh();
			});
		});
		
		// 리스트 조회
		function listResh() {
			var	url = "/resh/reshList.do";
			var data = {
				"crsCreCd"    : "${vo.crsCreCd}",
				"reschTypeCd" : "LECT",
				"searchValue" : $("#searchValue").val()
			};
			
			showLoading();
			$.ajax({
	            url 	 : url,
	            async	 : false,
	            type 	 : "POST",
	            dataType : "json",
	            data 	 : data,
	        }).done(function(data) {
	        	hideLoading();
	        	if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var html = createReshListHTML(returnList);
	        		
	        		$("#list").empty().html(html);
	        		if($("#listType i").hasClass("th")){
		    			$(".table").footable();
	        		} else {
	        			$(".ui.dropdown").dropdown();
	        			$(".card-item-center .title-box label").unbind('click').bind('click', function(e) {
	        		        $(".card-item-center .title-box label").toggleClass('active');
	        		    });
	        		}
	        		chgScoreRatio(0);
	            } else {
	             	alert(data.message);
	            }
	        }).fail(function() {
	        	hideLoading();
	        	alert("<spring:message code='resh.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
	        });
		}
		
		// 설문 페이지 이동
		function viewResh(tab, reschCd) {
			var urlMap = {
				"1" : "/resh/reshQstnManage.do",	// 설문 문항 관리 페이지
				"2" : "/resh/reshResultManage.do",	// 설문 결과 페이지
				"8" : "/resh/Form/writeResh.do", 	// 설문 등록 페이지
				"9" : "/resh/Form/editResh.do" 		// 설문 수정 페이지
			};
			
			var kvArr = [];
			kvArr.push({'key' : 'reschCd',  'val' : reschCd});
			kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
			
			submitForm(urlMap[tab], "", "", kvArr);
		}
		
		// 설문지 미리보기
		function reshQstnPreview(reschCd, reschSubmitYn) {
			if(reschSubmitYn == "N") {
				alert(`<spring:message code="resh.alert.already.qstn.submit" />`);/* 문항출제가 완료되지 않았습니다.\r\n문항관리에서 문항출제 완료해주세요. */
			} else {
				var kvArr = [];
				kvArr.push({'key' : 'reschCd',  'val' : reschCd});
				
				submitForm("/resh/reshQstnPreviewPop.do", "reshPopIfm", "reshPreview", kvArr);
			}
		}
		
		// 설문 삭제
		function delResh(reschCd) {
			var url  = "/resh/selectReshInfo.do";
			var data = {
				"crsCreCd" : "${vo.crsCreCd}",
				"reschCd"  : reschCd
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var confirm = "";
	        		var reshVO  = data.returnVO;
	        		if(reshVO.reschJoinUserCnt > 0) {
	        			confirm = window.confirm(`<spring:message code="resh.confirm.exist.join.user.y" />`);/* 설문 참여자가 있습니다. 삭제 시 설문결과가 삭제됩니다.\r\n정말 삭제 하시겠습니까? */
	        		} else {
	        			confirm = window.confirm("<spring:message code='resh.confirm.exist.join.user.n' />");/* 설문 참여자가 없습니다. 삭제 하시겠습니까? */
	        		}
	        		if(confirm) {
	        			var kvArr = [];
	        			kvArr.push({'key' : 'reschCd',  'val' : reschCd});
	        			kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
	        			
	        			submitForm("/resh/delResh.do", "", "", kvArr);
	        		}
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='resh.error.delete' />");/* 설문 삭제 중 에러가 발생하였습니다. */
			});
		}
		
		// 설문 리스트 생성
		function createReshListHTML(reshList) {
			var html = '';
			var reschMap = {};
			
			// 값 설정
			reshList.forEach(function(v, i) {
				// 제목
				var reschTitle	   = escapeHtml(v.reschTitle);
				// 시작일자
				var reschStartDttm = dateFormat("date", v.reschStartDttm);
				// 종료일자
				var reschEndDttm   = dateFormat("date", v.reschEndDttm);
				// 설문 문항출제여부
				var reschSubmit	   = v.reschSubmitYn == "Y" ? "<spring:message code='resh.label.qstn.submit' />"/* 출제완료 */ : "<span class='fcRed'><spring:message code='resh.label.qstn.temp.submit' /></span>"/* 임시저장 */;
				// 설문 결과 조회 가능 여부
				var rsltOpenYn	   = v.rsltTypeCd == 'ALL' || v.rsltTypeCd == 'JOIN' ? "<spring:message code='resh.label.allow.y' />"/* 허용 */ : "<spring:message code='resh.label.allow.n' /></i>";/* 비허용 */
				var map = {
					"title" : reschTitle, "startDttm" : reschStartDttm, "endDttm" : reschEndDttm, "status" : reschSubmit, "open" : rsltOpenYn
				};
				reschMap[v.reschCd] = map;
			});
			
			if($("#listType i").hasClass("th")){
				html += `<table class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code='resh.common.empty' />">`;/* 등록된 내용이 없습니다. */
				html += `   <caption class="hide">설문</caption>`;
				html += `	<thead>`;
				html += `		<tr>`;
				html += `			<th scope="col" class="tc">NO.</th>`;
				html += `			<th scope="col" class="tc"><spring:message code="resh.label.title" /></th>`;/* 설문명 */
				html += `			<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code="resh.label.item.cnt" /></th>`;/* 문항수 */
				html += `			<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="resh.label.period" /></th>`;/* 설문기간 */
				html += `			<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="resh.label.score.ratio" /></th>`;/* 성적반영비율 */
				html += `			<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code="resh.label.status.join" /></th>`;/* 참여현황 */
				html += `			<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="resh.label.cnt.eval" />/<spring:message code="resh.label.cnt.join" /></th>`;/* 평가수 *//* 참여수 */
				html += `			<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="resh.label.qstn.submit.status" /></th>`;/* 문항출제상태 */
				html += `			<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="resh.label.score.open.yn" /></th>`;/* 성적공개 */
				html += `			<th scope="col" class="tc"><spring:message code="resh.label.manage" /></th>`;/* 관리 */
				html += `		</tr>`;
				html += `	</thead>`;
				html += `	<tbody>`;
				reshList.forEach(function(v, i) {
					html += `	<tr>`;
					html += `		<td class="tc">\${v.lineNo }</td>`;
					html += `		<td><a href="javascript:viewResh(2, '\${v.reschCd }')" class="header header-icon link">\${reschMap[v.reschCd]["title"] }</a></td>`;
					html += `		<td class="tc"><a href="javascript:viewResh(1, '\${v.reschCd }')" class="fcBlue">\${v.reschQstnCnt }</a></td>`;
					html += `		<td class="tc">\${reschMap[v.reschCd]["startDttm"] } ~<br> \${reschMap[v.reschCd]["endDttm"] }</td>`;
					html += `		<td class="tc">`;
					if(v.scoreAplyYn != 'Y') {
					html += `			0%`;
					} else {
					html += `			<div class="scoreInputDiv ui input">`;
					html += `				<input type="number" class="scoreRatio w50" data-reschCd="\${v.reschCd}" value="\${v.scoreRatio != null ? v.scoreRatio : 0 }" />`;
					html += `			</div>`;
					html += `			<div class="scoreRatioDiv">\${v.scoreRatio != null ? v.scoreRatio : 0 }%</div>`;
					}
					html += `		</td>`;
					html += `		<td class="tc">\${v.reschJoinUserCnt}/\${v.reschTotalUserCnt}</td>`;
					html += `		<td class="tc">\${v.reschEvalCnt}/\${v.reschJoinUserCnt}</td>`;
					html += `		<td class="tc">\${reschMap[v.reschCd]["status"]}</td>`;
					html += `		<td class="tc">`;
					if(v.scoreAplyYn != 'Y') {
					html += `			-`;
					} else {
					html += `			<div class="ui toggle checkbox">`;
					html += `				<input type="checkbox" value="\${v.reschCd}" onclick="chgScoreOpen(this)" \${v.scoreOpenYn == 'Y' ? `checked`:`` }>`;
					html += `				<label></label>`;
					html += `			</div>`;
					}
					html += `		</td>`;
					html += `		<td class="tc">`;
					html += `			<a href="javascript:reshQstnPreview('\${v.reschCd}', '\${v.reschSubmitYn}')" class="ui basic blue small button"><spring:message code="resh.label.preview" />​</a>`;/* 미리보기 */
					html += `		</td>`;
					html += `	</tr>`;
				});
				html += `	</tbody>`;
				html += `</table>`;
			} else {
				if(reshList.length > 0) {
					html += `<div class='ui two stackable cards info-type mt10'>`;
					reshList.forEach(function(v, i) {
						html += `<div class="card">`;
						html += `	<div class="content card-item-center">`;
						html += `		<div class="title-box">`;
						html += `			<label class="ui yellow label active"><spring:message code="resh.label.resh" />​</label>`;/* 설문 */
						html += `			<a href="javascript:viewResh(2, '\${v.reschCd }')" class="header header-icon link">\${reschMap[v.reschCd]["title"] }</a>`;
						html += `		</div>`;
						if(v.reschSubmitYn == "N") {
						html += `		<span class='ui blue label w100'><spring:message code="resh.label.qstn.temp.submit" /></span>`;/* 임시저장 */
						}
						html += `		<div class="ui top right pointing dropdown right-box">`;
						html += `			<span class="bars"><spring:message code="resh.label.menu" /></span>`;/* 메뉴 */
						html += `			<div class="menu">`;
						html += `				<a href="javascript:reshQstnPreview('\${v.reschCd}', '\${v.reschSubmitYn}')" class="item"><spring:message code="resh.label.preview" /></a>`;/* 미리보기 */
						html += `				<a href="javascript:viewResh(1, '\${v.reschCd }')" class="item"><spring:message code="resh.tab.item.manage" /></a>`;/* 문항 관리 */
						html += `				<a href="javascript:viewResh(2, '\${v.reschCd }')" class="item"><spring:message code="resh.tab.result" /></a>`;/* 설문 결과 */
						html += `				<a href="javascript:viewResh(9, '\${v.reschCd }')" class="item"><spring:message code="resh.button.modify" /></a>`;/* 수정 */
						html += `				<a href="javascript:delResh('\${v.reschCd }')" class="item"><spring:message code="resh.button.delete" /></a>`;/* 삭제 */
						html += `			</div>`;
						html += `		</div>`;
						html += `	</div>`;
						html += `	<div class="sum-box">`;
						html += `		<ul class="process-bar">`;
						html += `			<li class="bar-blue" style="width: \${(v.reschJoinUserCnt*100)/v.reschTotalUserCnt}%;">\${v.reschJoinUserCnt }<spring:message code="resh.label.nm" /></li>`;/* 명 */
						html += `			<li class="bar-softgrey" style="width: \${((v.reschTotalUserCnt-v.reschJoinUserCnt)*100)/v.reschTotalUserCnt}%;">\${v.reschTotalUserCnt - v.reschJoinUserCnt }<spring:message code="resh.label.nm" /></li>`;/* 명 */
						html += `		</ul>`;
						html += `		<span class='ui mini blue label'>\${v.reschStatus }</span>`;
						html += `	</div>`;
						html += `	<div class="content ui form equal width">`;
						html += `		<div class="fields">`;
						html += `			<div class="inline field">`;
						html += `				<label class="label-title-lg"><spring:message code="resh.label.period" /></label>`;/* 설문기간 */
						html += `				<i>\${reschMap[v.reschCd]["startDttm"] } ~ \${reschMap[v.reschCd]["endDttm"] }</i>`;
						html += `			</div>`;
						html += `		</div>`;
						html += `		<div class="fields">`;
						html += `			<div class="inline field">`;
						html += `				<label class="label-title-lg"><spring:message code="resh.label.item.cnt" /></label>`;/* 문항수 */
						html += `				<i>\${v.reschQstnCnt }</i>`;
						html += `			</div>`;
						html += `		</div>`;
						html += `		<div class="fields">`;
						html += `			<div class="inline field">`;
						html += `				<label class="label-title-lg"><spring:message code="resh.label.score.open.yn" /></label>`;/* 성적공개 */
						if(v.scoreAplyYn != "Y") {
						html += `				<i>-</i>`;
						} else {
						html += `				<div class="ui toggle checkbox">`;
						html += `					<input type="checkbox" value="\${v.reschCd}" onclick="chgScoreOpen(this)" \${v.scoreOpenYn == 'Y' ? `checked`:`` }>`;
						html += `					<label></label>`;
						html += `				</div>`;
						}
						html += `			</div>`;
						html += `		</div>`;
						html += `		<div class="fields">`;
						html += `			<div class="inline field">`;
						html += `				<label class="label-title-lg"><spring:message code="resh.label.resutl.view" /></label>`;/* 결과조회 */
						html += `				<i>\${reschMap[v.reschCd]["open"]}</i>`;
						html += `			</div>`;
						html += `		</div>`;
						html += `		<div class="fields">`;
						html += `			<div class="inline field">`;
						html += `				<label class="label-title-lg"><spring:message code="resh.label.score.ratio" /></label>`;/* 성적반영비율 */
						if(v.scoreAplyYn != "Y") {
						html += `				<i>0%</i>`;
						} else {
						html += `				<i>\${v.scoreRatio}%</i>`;
						}
						html += `			</div>`;
						html += `		</div>`;
						html += `		<div class="tr">`;
						html += `			<a href="javascript:viewResh(2, '\${v.reschCd}')" class="ui basic small button mra"><spring:message code="resh.label.eval" /> \${v.reschEvalCnt }/\${v.reschJoinUserCnt }</a>`;/* 평가 */
						html += `		</div>`;
						html += `	</div>`;
						html += `</div>`;
					});
					html += `</div>`;
				} else {
					html += "<div class='flex-container'>";
					html += "	<div class='no_content'>";
					html += "		<i class='icon-cont-none ico f170'></i>";
					html += "		<span><spring:message code='resh.common.empty' /></span>";/* 등록된 내용이 없습니다. */
					html += "	</div>";
					html += "</div>";
				}
			}
			
			return html;
		}
		
		// 성적 공개 변경
		function chgScoreOpen(obj) {
			var reschCd 	= $(obj).val();
			var scoreOpenYn = obj.checked ? "Y" : "N";
			var url  = "/resh/editScoreOpenYn.do";
			var data = {
				"reschCd" 	  : reschCd,
				"scoreOpenYn" : scoreOpenYn
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					listResh();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='exam.error.score.open' />");/* 성적 공개 변경 중 에러가 발생하였습니다. */
			});
		}
		
		// 성적 반영비율 입력 폼 변환
		function chgScoreRatio(type) {
			if(type == 1) {
				if($("#listType i").hasClass("list")) {
					$("#listType").trigger("click");
				}
				$("#chgScoreRatioBtn").hide();
				$(".chgScoreRatioDiv").css("display", "inline-block");
				$(".scoreInputDiv").show();
				$(".scoreRatioDiv").hide();
			} else {
				$("#chgScoreRatioBtn").css("display", "inline-block");
				$(".chgScoreRatioDiv").hide();
				$(".scoreInputDiv").hide();
				$(".scoreRatioDiv").show();
			}
		}
		
		// 성적 반영비율 저장
		function saveScoreRatio() {
			var isChk 		= true;
			var scoreRatio  = 0;
			var reschCds 	= "";
			var scoreRatios = "";
			
			$(".scoreRatio").each(function(i) {
				scoreRatio += parseInt($(this).val());
				if(i > 0) {
					reschCds += "|";
					scoreRatios += "|";
				}
				reschCds += $(this).attr("data-reschCd");
				scoreRatios += $(this).val();
				if(Number($(this).val()) < 0 || Number($(this).val()) > 100) {
					alert("<spring:message code='resh.alert.score.max.100' />");/* 점수는 100점 까지 입력 가능 합니다. */
					isChk = false;
					return false;
				}
			});
			if($(".scoreRatio").length == 0) {
				isChk = false;
				listResh();
			}
			
			if(isChk) {
				if(Number(scoreRatio) != 100) {
					alert("["+scoreRatio+"] <spring:message code='resh.alert.score.ratio.100' />");/* 성적 반영 비율 합이 100%이여야 합니다. */
					return false;
				} else {
					var url  = "/resh/editScoreRatio.do";
					var data = {
						"reschCds" 	  : reschCds,
						"scoreRatios" : scoreRatios
					};
					
					ajaxCall(url, data, function(data) {
						if (data.result > 0) {
			        		alert("<spring:message code='resh.alert.insert' />");/* 정상 저장 되었습니다. */
			        		listResh();
			            } else {
			             	alert(data.message);
			            }
		    		}, function(xhr, status, error) {
		    			alert("<spring:message code='resh.error.score.ratio' />");/* 반영 비율 저장 중 에러가 발생하였습니다. */
		    		});
				}
			}
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
            <div class="content stu_section">
            	<%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
        		
        		<div class="ui form">
        			<div class="layout2">
		        		<script>
						$(document).ready(function () {
							// set location
							setLocationBar('<spring:message code="resh.label.resh" />', '<spring:message code="resh.button.list" />');
						});
						</script>
						
		                <div id="info-item-box">
		                	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="resh.label.resh" /><!-- 설문 -->
                            </h2>
		                    <div class="button-area">
		                        <a href="javascript:viewResh(8, '')" class="ui blue button"><spring:message code="resh.label.resh" /> <spring:message code="resh.button.write" /></a><!-- 설문 --><!-- 등록 -->
		                    </div>
		                </div>
		                <div class="row">
		                	<div class="col">
				                <div class="option-content mb10">
				                    <button class="ui basic icon button" id="listType" title="<spring:message code="asmnt.label.title.list" />"><i class="th ul icon"></i></button>
				                    <div class="ui action input search-box mr5">
				                        <input type="text" id="searchValue" placeholder="<spring:message code='resh.label.title' /> <spring:message code='resh.label.input' />"><!-- 설문명 --><!-- 입력 -->
				                        <button class="ui icon button" onclick="listResh()"><i class="search icon"></i></button>
				                    </div>
				                    <div class="mla">
				                    	<div class="option-content">
					                    	<div class="chgScoreRatioDiv">
						                    	<a href="javascript:saveScoreRatio()" class="ui blue button"><spring:message code="resh.button.score.ratio.save" /></a><!-- 성적반영 비율 저장 -->
						                    	<a href="javascript:chgScoreRatio(2)" class="ui basic button"><spring:message code="resh.button.cancel" /></a><!-- 취소 -->
					                    	</div>
					                    	<a href="javascript:chgScoreRatio(1)" id="chgScoreRatioBtn" class="ui blue button"><spring:message code="resh.button.score.ratio.chg" /></a><!-- 성적반영 비율 조정 -->
				                    	</div>
				                    </div>
				                </div>
				                <div id="list"></div>
				                <div class="option-content">
				                	<div class="mla">
				                        <a href="javascript:viewResh(8, '')" class="ui blue button"><spring:message code="resh.label.resh" /> <spring:message code="resh.button.write" /></a><!-- 설문 --><!-- 등록 -->
				                    </div>
				                </div>
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
