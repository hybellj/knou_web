<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<script type="text/javascript">
	$(document).ready(function() {
		chartSet('status');
		chartSet('device');
	});
	
	// 설문 참여 팝업
	function reshJoinPop(reschCd) {
		$("#popReschCd").val(reschCd);
		$("#reshPopForm").attr("target", "reshJoinPopIfm");
        $("#reshPopForm").attr("action", "/resh/evalReshJoinPop.do");
        $("#reshPopForm").submit();
        $('#reshJoinPop').modal('show');
	}
	
	// 목록
	function viewReshList() {
		var url  = "/resh/Form/lectEvalList.do";
		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "listForm");
		form.attr("action", url);
		form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '<c:out value="${vo.crsCreCd}" />'}));
		form.appendTo("body");
		form.submit();
	}
	
	// 차트 출력
	function chartSet(type) {
		var cntMap = {};
		<c:forEach var="list" items="${joinDeviceList }">
			cntMap["${list.deviceTypeCd}"] = "${list.reshFinCnt}";
		</c:forEach>
		
		var reschJoinUserCnt = '<c:out value="${reshVO.reschJoinUserCnt}" />' || 0;
		var reschTotalUserCnt = '<c:out value="${reshVO.reschTotalUserCnt}" />' || 0;
		
		var typeMap = {
			"status" : {
				"ctx"	 : "statPieChart",
				"text"   : '<spring:message code="resh.label.status.join" />' + " (%)",	// 참여현황
				"labels" : [
					  '<spring:message code="resh.label.user.join.y" />'	// 응답자
					, '<spring:message code="resh.label.user.join.n" />'	// 미응답자
				],
				"datas"  : [reschJoinUserCnt, reschTotalUserCnt - reschJoinUserCnt]
			},
			"device" : {
				"ctx"	 : "devicePieChart",
				"text"   : '<spring:message code="resh.label.join.device" />' + " (%)", // 접속환경
				"labels" : ["PC", '<spring:message code="resh.label.mobile" />'], // 모바일
				"datas"  : [cntMap["PC"], cntMap["MOBILE"]]
			}
		};
		var ctx = document.getElementById(typeMap[type]['ctx']);
		var colorArray = ["#36a2eb", "#ff6384"];
		
        var myChart = new Chart(ctx, {
            type: 'pie',
            data: {
            labels: typeMap[type]['labels'],
            datasets: [{
                backgroundColor: colorArray,
                borderWidth:1,
                data: typeMap[type]['datas']
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
                text: typeMap[type]['text'],
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
                                        text: label + " : " + value + '<spring:message code="resh.label.nm" />',
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
	}
	
	// 다운로드
	function fileDown(fileSn, repoCd) {
		var url  = "/common/fileInfoView.do";
		var data = {
			"fileSn" : fileSn,
			"repoCd" : repoCd
		};
		
		ajaxCall(url, data, function(data) {
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "downloadForm");
			form.attr("id", "downloadForm");
			form.attr("target", "downloadIfm");
			form.attr("action", data);
			form.appendTo("body");
			form.submit();
			
			$("#downloadForm").remove();
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		});
	}
</script>
<body class="<%=SessionInfo.getThemeMode(request)%>">
	<form id="reshPopForm" name="reshPopForm" method="POST">
		<input type="hidden" name="reschCd" value="" id="popReschCd" />
		<input type="hidden" name="reschCtgrCd" value="<c:out value="${reshVO.reschCtgrCd}" />"	 />
		<input type="hidden" name="searchKey" value="view" />
	</form>
	<div id="wrap" class="pusher">
		<%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>
		
		<div id="container">
			<%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>
			
			<!-- 본문 content 부분 -->
			<div class="content stu_section">
				<%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
		
				<div class="ui form">
		        	<div class="layout2">
		        		<!-- 타이틀 -->
						<div id="info-item-box">
							<script>
								$(document).ready(function () {
									var title1 = '<spring:message code="resh.label.lect.eval" />'; // 강의평가
									var title2 = '<spring:message code="resh.label.view.detail" />'; // 상세보기
									
									// set location
									setLocationBar(title1, title2);
								});
							</script>
		                    <h2 class="page-title flex-item flex-wrap gap4 columngap16">
		                    	<spring:message code="resh.label.lect.eval" /><!-- 강의평가 -->
		                    </h2>
		                	<div class="button-area">
			               	<c:if test="${menuType.contains('STUDENT') and reshVO.reschStatus eq '진행' and reshVO.joinYn eq 'N' and PROFESSOR_VIRTUAL_LOGIN_YN ne 'Y'}">
			                    <a href="javascript:reshJoinPop('<c:out value="${reshVO.reschCd}" />')" class="ui blue button"><spring:message code="resh.button.lect.eval.join" /><!-- 강의평가 참여 --></a>
			               	</c:if>
			               	<c:if test="${menuType.contains('STUDENT') and reshVO.reschStatus eq '진행' and reshVO.joinYn eq 'Y' and PROFESSOR_VIRTUAL_LOGIN_YN ne 'Y'}">
			                    <a href="javascript:reshJoinPop('<c:out value="${reshVO.reschCd}" />')" class="ui blue button"><spring:message code="resh.button.lect.eval.edit" /><!-- 강의평가 수정 --></a>
			               	</c:if>
			                	<a href="javascript:viewReshList()" class="ui blue button"><spring:message code="resh.button.list" /><!-- 목록 --></a>
			                </div>
		                </div>
		                
		                <!-- 영역1 -->
                        <div class="row">
                            <div class="col">
                            	<div class="ui segment p0">
									<div class="ui styled fluid accordion week_lect_list card" style="border:none;">
										<div class="title active">
				                            <div class="title_cont">
				                                <div class="left_cont">
				                                    <div class="lectTit_box">
				                                        <p class="lect_name"><c:out value="${reshVO.reschTitle}" /></p>
				                                        <span class="fcGrey"><small><spring:message code="resh.label.lect.eval.period" /><!-- 강의평가 기간 --> : <uiex:formatDate value="${reshVO.reschStartDttm}" pattern="yyyy.MM.dd HH:mm" /> ~ <uiex:formatDate value="${reshVO.reschEndDttm}" pattern="yyyy.MM.dd HH:mm" /></small></span>
				                                    </div>
				                                </div>
				                            </div>
				                            <i class="dropdown icon ml20"></i>
				                        </div>
				                        <div class="content menu_off active">
				                        	<ul class="tbl-simple">
				                        		<li>
													<dl>
														<dt>
															<label for="subjectLabel"><spring:message code="resh.label.lect.eval.content" /><!-- 강의평가 내용 --></label>
														</dt>
														<dd></dd>
													</dl>
													<div class="ui segment">
														<pre>${reshVO.reschCts}</pre>
													</div>
												</li>
												<li>
													<dl>
														<dt>
															<label for="teamLabel"><spring:message code="resh.label.lect.eval.qstn" /><!-- 강의평가 문항 --></label>
														</dt>
														<dd><c:out value="${reshVO.reschQstnCnt}" /></dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label for="contLabel"><spring:message code="resh.label.score.open.yn" /><!-- 성적공개 --></label>
														</dt>
														<dd>
															<c:choose>
																<c:when test="${reshVO.scoreViewYn eq 'Y' }">
																	<spring:message code="resh.label.open.y" /><!-- 공개 -->
																</c:when>
																<c:otherwise>
																	<span class="fcRed"><spring:message code="resh.label.open.n" /><!-- 비공개 --></span>
																</c:otherwise>
															</c:choose>
														</dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label for="contLabel"><spring:message code="resh.label.file" /><!-- 첨부파일 --></label>
														</dt>
														<dd>
														<c:forEach items="${reshVO.fileList}" var="row">
															<button class="ui icon small button" title="<spring:message code="asmnt.label.attachFile.download" />" type="button" onclick="fileDown('<c:out value="${row.fileSn}" />', '<c:out value="${row.repoCd}" />')">
																<i class="ion-android-download"></i>&nbsp;<c:out value="${row.fileNm}" />&nbsp;<c:out value="${row.fileSizeStr}" />
															</button>
														</c:forEach>
														</dd>
													</dl>
												</li>
				                        	</ul>
				                        </div>
									</div>
								</div>
								<div class="ui card wmax">
									<div class="flex content">
				                    	<span class="f110"><spring:message code="resh.label.status.submit" /><!-- 제출 현황 --></span>
					                </div>
					                <div class="ui stackable equal width grid content">
										<div class="column">
								            <canvas id="statPieChart" height="250" style="max-width:350px;margin:auto;"></canvas>
								        </div>
										<div class="column">
								            <canvas id="devicePieChart" height="250" style="max-width:350px;margin:auto;"></canvas>
								        </div>
								    </div>
								</div>
                            </div><!-- //col -->
                        </div><!-- //row -->
		                
		        	</div><!-- //layout2 -->
		        </div><!-- //ui form -->
			</div><!-- //content stu_section -->
			
			<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
		</div><!-- //container -->
		
	</div><!-- //wrap -->
	
	<iframe id="downloadIfm" name="downloadIfm" style="visibility: none; display: none;"></iframe>
	
	<!-- 강의평가 참여 팝업 --> 
	<div class="modal fade" id="reshJoinPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="resh.button.lect.eval.join" />" aria-hidden="false">
	    <div class="modal-dialog modal-lg" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="sys.button.close" />">
	                    <span aria-hidden="true">&times;</span>
	                </button>
	                <h4 class="modal-title"><spring:message code="resh.button.lect.eval.join" /><!-- 강의평가참여 --></h4>
	            </div>
	            <div class="modal-body">
	                <iframe src="" id="reshJoinPopIfm" name="reshJoinPopIfm" width="100%" scrolling="no"></iframe>
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