<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/resh/common/resh_common_inc.jsp" %>
<script type="text/javascript">
	$(document).ready(function() {
		listReshUser(1);
		reshCommon.statusChartSet('status');
		reshCommon.statusChartSet('device');
		$(".accordion").accordion();
		
		$("#searchValue").on("keyup", function(e) {
			if(e.keyCode == 13) {
				listReshUser(1);
			}
		});
	});
	
	// 설문 페이지 이동
	function manageResh(tab) {
		var urlMap = {
			"0" : "/resh/reshMgr/homeReshInfoManage.do",	// 전체설문 정보 상세 페이지
			"1" : "/resh/reshMgr/homeReshQstnManage.do",	// 전체설문 문항 관리 페이지
			"2" : "/resh/reshMgr/homeReshResultManage.do",	// 전체설문 결과 페이지
			"9" : "/resh/reshMgr/Form/homeReshList.do"		// 목록
		};
		
		var kvArr = [];
		kvArr.push({'key' : 'reschCd', 	 'val' : "${vo.reschCd}"});
		
		submitForm(urlMap[tab], "", "", kvArr);
	}
	
	// 설문 참여자 리스트 조회
	function listReshUser(page) {
		var url  = "/resh/reshMgr/homeReshJoinUserList.do";
		var data = {
			"reschCd" 	  : "${vo.reschCd}",
			"pageIndex"   : page,
			"listScale"   : $("#listScale").val(),
			"searchKey"   : $("#searchKey").val(),
			"searchValue" : $("#searchValue").val()
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var html = "";
        		data.returnList.forEach(function(v, i) {
        			var regDttm  = v.regDttm != null ? dateFormat("date", v.regDttm) : "";
        			var submitNm = v.regDttm == null ? '<spring:message code="resh.label.not.join" />'/* 미참여 */ : '<spring:message code="resh.label.join" />';/* 참여 */
        			html += "<tr>";
        			html += "	<td class='tc'>";
        			html += "		<div class='ui checkbox'>";
        			html += `			<input type="checkbox" id="userChk\${i }" name="evalChk" onchange="checkUser(this)">`;
        			html += `			<label class="toggle_btn" for="userChk\${i }">\${v.lineNo }</label>`;
        			html += "		</div>";
        			html += "	</td>";
        			html += `	<td class='tc'>\${v.deptNm }</td>`;
        			html += `	<td class='tc'>\${v.userId }</td>`;
        			html += `	<td class='tc'>\${v.userNm }</td>`;
        			html += `	<td class='tc'>\${submitNm}</td>`;
        			html += `	<td class='tc'>\${regDttm }</td>`;
        			html += "</tr>";
        		});
        		$("#reshJoinUserList").empty().append(html);
        		
		    	$(".table").footable();
		    	var params = {
					totalCount 	  : data.pageInfo.totalRecordCount,
					listScale 	  : data.pageInfo.pageSize,
					currentPageNo : data.pageInfo.currentPageNo,
					eventName 	  : "listReshUser"
				};
				
				gfn_renderPaging(params);
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='resh.error.list' />");/* 설문 리스트 조회 중 에러가 발생하였습니다. */
		});
	}
	
	// 엑셀 다운로드
	function excelDown(type) {
		var urlMap = {
			"submit" : "/resh/reshJoinUserAnswerExcelDown.do",	// 제출설문
			"result" : "/resh/reshResultExcelDown.do"			// 설문결과
		};
		
		var kvArr = [];
		kvArr.push({'key' : 'reschCd', 	 'val' : "${vo.reschCd}"});
		
		submitForm(urlMap[type], "", "", kvArr);
	}
	
	// 사용자 체크박스 이벤트
	function checkUser(obj){
		if(obj.value == "all") {
			$("input[name=evalChk]").prop("checked", obj.checked);
		} else {
			$("#userAllChk").prop("checked", $("input[name=evalChk]").length == $("input[name=evalChk]:checked").length);
		}
	}
</script>

<body>
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>

        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>

		<div id="container">
	        <!-- 본문 content 부분 -->
	        <div class="content">
	        	<%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
	    		<div class="ui form">
	    			<div class="layout2">
		                <div id="info-item-box">
		                	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="resh.label.resh.home" /><!-- 전체설문 -->
                                <div class="ui breadcrumb small">
                                    <small class="section"><spring:message code="resh.label.resh.home.result" /><!-- 전체설문결과 --></small>
                                </div>
                            </h2>
                            <div class="button-area">
                            	<a href="javascript:excelDown('submit')" class="ui blue button"><spring:message code="resh.button.excel.down.resh" /></a><!-- 제출 설문 엑셀다운로드 -->
								<a href="javascript:excelDown('result')" class="ui blue button"><spring:message code="resh.button.excel.down.result" /></a><!-- 설문 결과 엑셀다운로드 -->
								<a href="javascript:manageResh(9)" class="ui blue button"><spring:message code="resh.button.list" /></a><!-- 목록 -->
                            </div>
		                </div>
		                <div class="row">
		                	<div class="col">
		                		<div class="listTab">
			                        <ul>
			                            <li class="mw120"><a onclick="manageResh(0)"><spring:message code="resh.label.resh.home.info" /><!-- 전체설문정보 --></a></li>
					                    <li class="mw120"><a onclick="manageResh(1)"><spring:message code="resh.tab.item.manage" /></a></li><!-- 문항 관리 -->
					                    <li class="select mw120"><a onclick="manageResh(2)"><spring:message code="resh.label.resh.home.result" /><!-- 전체설문결과 --></a></li>
			                        </ul>
			                    </div>
								<div class="ui styled fluid accordion week_lect_list mt20">
									<div class="title flex">
										<div class="title_cont">
											<div class="left_cont">
												<div class="lectTit_box">
													<p class="lect_name">${vo.reschTitle }</p>
													<fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss" value="${vo.reschStartDttm }" />
													<fmt:formatDate var="reschStartDttm" pattern="yyyy.MM.dd HH:mm" value="${startDateFmt }" />
													<fmt:parseDate var="endDateFmt" pattern="yyyyMMddHHmmss" value="${vo.reschEndDttm }" />
													<fmt:formatDate var="reschEndDttm" pattern="yyyy.MM.dd HH:mm" value="${endDateFmt }" />
													<span class="fcGrey"><small><spring:message code="resh.label.resh.home.period" /><!-- 전체설문 기간 --> : ${reschStartDttm } ~ ${reschEndDttm }</small></span>
												</div>
											</div>
										</div>
										<i class="dropdown icon flex-left-auto"></i>
									</div>
									<div class="content">
										<div class="ui segment">
											<ul class="tbl">
												<li>
													<dl>
														<dt>
															<label for="subjectLabel"><spring:message code="resh.label.resh.home.cts" /><!-- 전체설문 내용 --></label>
														</dt>
														<dd><pre>${vo.reschCts }</pre></dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label for="teamLabel"><spring:message code="resh.label.resh.home.result" /><!-- 전체설문결과 --> <spring:message code="resh.label.open.y" /><!-- 공개 --></label>
														</dt>
														<dd>
															<c:choose>
																<c:when test="${vo.rsltTypeCd eq 'ALL' || vo.rsltTypeCd eq 'JOIN' }">
																	<spring:message code="resh.common.yes" /><!-- 예 -->
																</c:when>
																<c:otherwise>
																	<spring:message code="resh.common.no" /><!-- 아니오 -->
																</c:otherwise>
															</c:choose>
														</dd>
													</dl>
												</li>
											</ul>
										</div>
									</div>
								</div>
		                	</div>
		                </div>
			            <div class="ui segment">
							<div class="option-content mb15">
								<select class="ui dropdown" onchange="listReshUser(1)" id="searchKey">
							        <option value="all"><spring:message code="resh.common.search.all" /></option><!-- 전체 -->
							        <option value="submit"><spring:message code="resh.label.join" /></option><!-- 참여 -->
							        <option value="noSubmit"><spring:message code="resh.label.not.join" /></option><!-- 미참여 -->
							    </select>
							    <div class="ui action input search-box">
							        <input type="text" placeholder="<spring:message code='resh.label.dept.nm' />, <spring:message code='resh.label.user.no' />, <spring:message code='resh.label.user.nm' /> <spring:message code='resh.label.input' />" class="w250" id="searchValue"><!-- 학과 --><!-- 학번 --><!-- 이름 --><!-- 입력 -->
							        <button class="ui icon button" onclick="listReshUser(1)"><i class="search icon"></i></button>
							    </div>
								<select class="ui dropdown flex-left-auto list-num" id="listScale" onchange="listReshUser(1)">
							        <option value="10">10</option>
							        <option value="20">20</option>
							        <option value="50">50</option>
							        <option value="100">100</option>
							    </select>
							</div>
						    <table class="table" data-sorting="false" data-paging="false" data-empty="<spring:message code='resh.common.empty' />"><!-- 등록된 내용이 없습니다. -->
								<thead>
									<tr>
										<th scope="col" class="tc">
											<div class="ui checkbox">
							                    <input type="checkbox" name="allEvalChk" id="userAllChk" value="all" onchange="checkUser(this)">
							                    <label class="toggle_btn" for="userAllChk"></label>
							                </div>
											NO.
										</th>
										<th scope="col" class="tc"><spring:message code="resh.label.dept.nm" /></th><!-- 학과 -->
										<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="resh.label.user.no" /></th><!-- 학번 -->
										<th scope="col" class="tc" data-breakpoints="xs sm"><spring:message code="resh.label.user.nm" /></th><!-- 이름 -->
										<th scope="col" class="tc"><spring:message code="resh.label.join.yn" /></th><!-- 참여여부 -->
										<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code="resh.label.resh.home.dt" /><!-- 전체설문일시 --></th>
									</tr>
								</thead>
								<tbody id="reshJoinUserList">
								</tbody>
							</table>
							<div id="paging" class="paging"></div>
						</div>
			            <div class="ui form mb20">
							<h3><spring:message code="resh.label.status.submit" /></h3><!-- 제출 현황 -->
							<div class="ui segment">
								<div class="ui stackable equal width grid">
									<div class="column">
							            <canvas id="statPieChart" class="chart_wm350" height="250"></canvas>
							        </div>
									<div class="column">
							            <canvas id="devicePieChart" class="chart_wm350" height="250"></canvas>
							        </div>
							    </div>
							</div>
						</div>
						<c:forEach var="pageList" items="${reschAnswerList }">
							<div class="ui form mt10">
								<h4>${pageList.reschPageOdr }/${fn:length(reschAnswerList) }. <spring:message code="resh.label.page" /></h4><!-- 페이지 -->
								<c:forEach var="qstnList" items="${pageList.reschQstnList }">
									<div class="ui card wmax">
										<c:if test="${qstnList.reschQstnTypeCd eq 'SINGLE' || qstnList.reschQstnTypeCd eq 'MULTI' || qstnList.reschQstnTypeCd eq 'OX' }">
											<div class="fields content">
												<div class="field p_w70">
													<p>${pageList.reschPageOdr }-${qstnList.reschQstnOdr } ${qstnList.reschQstnTitle }</p>
													<ul>
														<c:forEach var="qstnItemList" items="${qstnList.reschAnswerList }" varStatus="itemStatus">
															<li class="m10"><label class="mr10 w20 d-inline-block ${colorList[itemStatus.index].title }" style="height:20px;"></label>
																<c:choose>
																    <c:when test="${qstnItemList.reschQstnItemTitle eq 'SINGLE_ETC_ITEM'}">
																    	<spring:message code="resh.label.etc" />
																    </c:when>
																    <c:otherwise>
																        ${fn:escapeXml(qstnItemList.reschQstnItemTitle)}
																    </c:otherwise>
																</c:choose>
															</li>
														</c:forEach>
													</ul>
												</div>
												<div class="field p_w30">
													<div class="column">
											            <canvas id="pieChart${pageList.reschPageOdr }_${qstnList.reschQstnOdr }" class="chart_wm250" height="200"></canvas>
											            <script>
											            	var labelArray = [];
											            	var colorArray = [];
											            	var dataArray  = [];
											            	<c:forEach var="itemList" items="${qstnList.reschAnswerList}" varStatus="itemStatus">
											            		<c:set var="etc"><spring:message code="resh.label.etc" /></c:set>
									                    		labelArray.push("${itemList.reschQstnItemTitle eq 'SINGLE_ETC_ITEM' ? etc : fn:escapeXml(itemList.reschQstnItemTitle)}");
									                    		colorArray.push("${colorList[itemStatus.index].code}");
									                    		dataArray.push("${itemList.joinCnt}");
									                    	</c:forEach>
											                var ctx = document.getElementById("pieChart${pageList.reschPageOdr }_${qstnList.reschQstnOdr}");
											                var myChart = new Chart(ctx, {
											                    type: 'pie',
											                    data: {
											                    labels: labelArray,
											                    datasets: [{
											                        backgroundColor: colorArray,
											                        borderWidth:1,
											                        data: dataArray
											                    }]
											                    },
											                    options: {
											                        pieceLabel: {
											                        render: function (args) {
											                            return args.percentage + '%';
											                        },
											                        fontColor : '#fff'
											                        },
											                        title: {
											                        display: true,
											                        fontSize: 14,
											                        fontColor: "#666",
											                        },
											                        legend: {
											                            display: true,
											                            position: 'bottom',
											                            labels: {
											                                boxWidth: 12,
											                                generateLabels: function(chart) {
											                                    var data = chart.data;
											                                    if (data.labels.length && data.datasets.length) {
											                                        return data.labels.map(function(label, i) {
											                                            var meta = chart.getDatasetMeta(0);
											                                            var ds = data.datasets[0];
											                                            var arc = meta.data[i];
											                                            var custom = arc && arc.custom || {};
											                                            var getValueAtIndexOrDefault = Chart.helpers.getValueAtIndexOrDefault;
											                                            var arcOpts = chart.options.elements.arc;
											                                            var fill = custom.backgroundColor ? custom.backgroundColor : getValueAtIndexOrDefault(ds.backgroundColor, i, arcOpts.backgroundColor);
											                                            var stroke = custom.borderColor ? custom.borderColor : getValueAtIndexOrDefault(ds.borderColor, i, arcOpts.borderColor);
											                                            var bw = custom.borderWidth ? custom.borderWidth : getValueAtIndexOrDefault(ds.borderWidth, i, arcOpts.borderWidth);
											                                            var value = chart.config.data.datasets[arc._datasetIndex].data[arc._index];
											    
											                                            return {
											                                                text: value + "<spring:message code='resh.label.nm' />",/* 명 */
											                                                fillStyle: fill,
											                                                strokeStyle: stroke,
											                                                lineWidth: bw,
											                                                hidden: isNaN(ds.data[i]) || meta.data[i].hidden,
											                                                index: i
											                                            };
											                                        });
											                                    } else {
											                                        return [];
											                                    }
											                                }
											                            }
											                        }
											                    }
											                });
											            </script>
											        </div>
												</div>
											</div>
										</c:if>
										<c:if test="${qstnList.reschQstnTypeCd eq 'SCALE' }">
											<div class="fields content">
						                        <div class="field wf100">
						                            <span>${pageList.reschPageOdr }-${qstnList.reschQstnOdr }.</span> ${qstnList.reschQstnTitle }
						                        </div>
						                    </div>
						                    <div class="content">
							                    <table class="table">
							                    	<thead>
							                    		<tr>
							                    			<th class="tc"><span class="pl10"><spring:message code="resh.label.item" /></span></th><!-- 문항 -->
							                    			<c:forEach var="scaleList" items="${qstnList.reschScaleList }">
								                    			<th class="tc">${scaleList.scaleTitle }</th>
							                    			</c:forEach>
							                    		</tr>
							                    	</thead>
							                    	<tbody>
							                    		<c:forEach var="answerList" items="${qstnList.reschAnswerList }">
								                    		<tr>
								                    			<td class="tl">${answerList.reschQstnItemTitle }</td>
								                    			<c:forEach var="scaleItemList" begin="1" end="${fn:length(qstnList.reschScaleList) }" step="1">
									                    			<c:set var="ratio" value="ratio${scaleItemList}" />
								                    				<td class="tc">${answerList[ratio] }%</td>
								                    			</c:forEach>
								                    		</tr>
							                    		</c:forEach>
							                    	</tbody>
							                    </table>
						                    </div>
										</c:if>
										<c:if test="${qstnList.reschQstnTypeCd eq 'TEXT' }">
											<div class="fields content">
						                        <div class="field wf100">
						                            <span>${pageList.reschPageOdr }-${qstnList.reschQstnOdr }.</span> ${qstnList.reschQstnTitle }
						                        </div>
						                    </div>
						                    <div class="content">
												<c:forEach var="textList" items="${qstnList.reschAnswerList }">
													<div>
														${textList.rnum }. ${textList.etcOpinion }
													</div>
												</c:forEach>
						                    </div>
										</c:if>
									</div>
								</c:forEach>
							</div>
						</c:forEach>
	    			</div>
	    		</div>
			</div>
	    </div>
	    <!-- //본문 content 부분 -->
	    <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
	</div>

</body>

</html>