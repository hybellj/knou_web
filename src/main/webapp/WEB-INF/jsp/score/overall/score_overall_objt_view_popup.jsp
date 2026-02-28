<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/file-uploader/file-uploader.css" />
    	<script type="text/javascript" src="/webdoc/js/jquery.form.min.js"></script>
	    <script type="text/javascript" src="/webdoc/file-uploader/lang/file-uploader-ko.js"></script>
	    <script type="text/javascript" src="/webdoc/file-uploader/file-uploader.js"></script>
	    <script type="text/javascript" src="/webdoc/js/iframe.js"></script>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    
    	<% 
		String deviceType = SessionInfo.getDeviceType(request);
		pageContext.setAttribute("deviceType", deviceType);
		if("mobile".equals(deviceType)) {
			%>
			<style>
	
			</style>		
			<%
		} 
		%>
    </head>
    <script type="text/javascript">
    $(function(){
    	$("[name=procCd]").eq(0).prop("checked", true);
    	$("#procCtnt").val("");
    	$("#objtDttmFmt").val("");
    	$("#objtCtnt").val("");

    	onObjtProcList();
    });

    // 파일 다운로드
    function fileDown(fileSn, repoCd) {
      var url  = "/common/fileInfoView.do";
      var data = {
        "fileSn" : fileSn,
        "repoCd" : repoCd
      };

      ajaxCall(url, data, function(data) {
        $("#downloadForm").remove();
        // download용 iframe이 없으면 만든다.
        if ( $("#downloadIfm").length == 0 ) {
          $("body").append("<iframe id='downloadIfm' name='downloadIfm' style='visibility: hidden; display: none;'></iframe>");
        }

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "downloadForm");
        form.attr("id", "downloadForm");
        form.attr("target", "downloadIfm");
        form.attr("action", data);
        form.appendTo("body");
        form.submit();
      }, function(xhr, status, error) {
        alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
      });
    }


    function onObjtProcList(){
    	var url = "/score/scoreOverall/selectScoreObjtProcList.do";
    	var data = {
    		crsCreCd : "${vo.crsCreCd}"
    	};
    	ajaxCall(url, data, function(data) {
    		var html = "";
    		var totCnt = 0;

    		if(data.returnList != null){
    			totCnt = data.returnList.length;
    		}

    		$("#objtProcTotCnt").text(totCnt);

    		$.each(data.returnList, function(i, o){
    			var addScore = Number(o.addScore);
    			var checked  = "${objtUserId}" == o.userId ? "checked" : "";
    			var procCtnt = gfn_isNull(o.procCtnt) ? "" : o.procCtnt;
    			
    			var objtDttmFmt = gfn_isNull(o.objtDttmFmt) ? "" : "(" + o.objtDttmFmt + ")";
    			var objtCtnt = gfn_isNull(o.objtCtnt) ? "" : o.objtCtnt;

    			if (DEVICE_TYPE != 'mobile' || (DEVICE_TYPE == 'mobile' && checked == "checked")) {
	    			html += "<tr>";
	    			html += "    <td class='checkRow' style='display: none;'><div class='ui-mark' style='display: none;'><input type='radio' name='objtTchChk' "+checked+" procCd='" + o.procCd + "' procCtnt='" + procCtnt + "' objtDttmFmt='" + objtDttmFmt +"' objtCtnt='" + objtCtnt +"' userId='" + o.userId + "' crsCreCd='" + o.crsCreCd + "' stdNo='" + o.stdNo + "' index='" + i + "'><label><i class='ion-android-done'></i></label></div></td>";
	    			if (DEVICE_TYPE == 'pc') {
	    				html += "    <td>" + o.lineNo + "</td>";
	    			}
	                html += "    <td>" + o.deptNm + "</td>";
	                html += "    <td>" + (o.hy || '-') + "</td>";
	                html += "    <td>" + o.userId + "</td>";
	                html += "    <td>";
	                html += 		o.userNm;
	                html += 		userInfoIcon("<%=SessionInfo.isKnou(request)%>", "userInfoPop('"+o.userId+"')");
	                html += "    </td>";
	                html += "    <td>" + o.compDvNm + "</td>";
	                html += "    <td>" + o.totScore + "</td>";
	                html += "    <td>" + addScore + "</td>";
	                html += "    <td>" + o.scoreGrade + "</td>";
	                html += "    <td>" + o.rnkNo + "</td>";
	                html += "    <td>";
					html += "	 	<a href=\"javascript:onScoreDtlPop('" + o.crsCreCd + "', '" + o.stdNo + "', '" + o.userId + "');\" class='ui basic small button'>보기</a>";
	                html += "    </td>";
	                html += "</tr>";
    			}
    		});

    		$("#objtProcList").empty().html(html);
    		$("#objtProcTable").footable({
				"breakpoints": {
			        "xs": 375,
			        "sm": 560,
			        "md": 768,
			        "lg": 1024,
			        "w_lg": 1200
		        }
			});

    		/**** Table CHECKBOX select-list ******/
    	    $('.select-list .ui-mark input:checked').each(function() {
    	    	$(this).closest('tr').addClass('active');
    	    	$("#procCtnt").val($(this).attr("procCtnt"));
    	    	$("#objtDttmFmt").text($(this).attr("objtDttmFmt"));
    	    	
    	    	$("#objtCtnt").text($(this).attr("objtCtnt"));
    	    	$("input[name=procCd][value='"+$(this).attr("procCd")+"']").prop("checked", true);
    	    });

    	    $('.select-list.checkbox .ui-mark').unbind('click').bind('click', function(e) {
    	    	var $checks = $(this).find('input[type=checkbox]');
    	    	if ($checks.prop("checked", !$checks.is(':checked'))) {
    	    		$(this).closest('tr').toggleClass('active');
    	    	}
    	    });

    	    $('.select-list.radiobox .ui-mark').unbind('click').bind('click', function(e) {
    	    	var $checks = $(this).find('input[type=radio]');

    	    	if ($checks.prop('checked', true)) {
    	    		$('.ui-mark label').closest('tr').removeClass('active');
    	    		$(this).closest('tr').addClass('active');

    	    		var stdNo = $checks.attr("stdNo");
    	    		var index = $checks.attr("index");

    	    		$("#objtProcStdNo").val(stdNo);
    	    		$("#procCtnt").val($checks.attr("procCtnt"));
        	    	$("#objtDttmFmt").text($checks.attr("objtDttmFmt"));
        	    	$("#objtCtnt").text($checks.attr("objtCtnt"));
    	    		$("input[name=procCd][value='"+$checks.attr("procCd")+"']").prop("checked", true);
    	    	}
    	    });
    	    
    	    var trHeight = 0;
    	    $.each($("#objtProcList").find(".active"), function() {
    	    	trHeight = $(this).height() * 5;
    	    });
    	    
    	    var margin = $(".footable-header").height() + trHeight;
  
    	    $('.footable_box').animate({
    	        scrollTop: $('.active').offset().top - margin
    	    }, 0);
    	    
    	    $(".checkRow").hide();
    	    
    	    if (DEVICE_TYPE == 'mobile' && $("#objtProcList").find("tr").length > 0) {
    	    	$("#objtProcList").find("tr")[0].click();
    	    }
    	}, function(xhr, status, error) {
    		/* 실패하였습니다. */
    		alert('<spring:message code="common.message.failed" />');
    	});
    }

    function onScoreDtlPop( crsCreCd, stdNo, userId ){
    	$("#modalScoreDtlForm input[name=crsCreCd]").val(crsCreCd);
    	$("#modalScoreDtlForm input[name=stdNo]").val(stdNo);
    	$("#modalScoreDtlForm input[name=objtUserId]").val(userId);
    	$("#modalScoreDtlForm").attr("target", "modalScoreDtlIfm");
        $("#modalScoreDtlForm").attr("action", "/score/scoreOverall/scoreOverallScoreDtlPopup.do");
        $("#modalScoreDtlForm").submit();
        $("#modalScoreDtl").modal('show');
    }

    </script>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
		<input type="hidden" id="objtProcStdNo">
        <div id="wrap">
            <div class="ui form">
                <ul class="tbl dt-sm">
                    <li>
                        <dl>
                            <dt><spring:message code="review.label.crscrenm" /></dt><!-- 과목명 -->
                            <dd>${vo.crsCreNm}</dd>
                            <dt><spring:message code="review.label.decls" /></dt><!-- 분반 -->
                            <dd>${vo.declsNo}</dd>
                        </dl>
                    </li>
                </ul>

                <div class="option-content mt15 mb10 gap4">
                    <div class="mra">
                        <b class="sec_head"><spring:message code="button.list.student" /></b>
                        <small>[ <spring:message code="common.page.total" /> <span id="objtProcTotCnt"></span><spring:message code="common.page.total_count" />  ]</small><!-- 총 건 -->
                    </div>
                    <div class="button-area">
                        <a href="javascript:getExcel()" class="ui basic button"><spring:message code="exam.button.excel.down" /></a>
                    </div>
                </div>

                <div class="footable_box type2 max-height-350">
                    <table id="objtProcTable" class="table select-list radiobox" data-sorting="false" data-paging="false" data-empty="<spring:message code="filebox.common.empty" />">
                        <thead>
                            <tr>
                            	<th scope="col" data-sortable="false" class="chk checkRow" style="display: none;"><div class="ui-mark"><i class="ion-android-done"></i></div></th>
                                <c:if test="${deviceType == 'pc'}">
                                	<th scope="col" data-type="" class="num"><spring:message code="common.number.no"/></th><!-- No -->
                                </c:if>
                                <th scope="col"><spring:message code="exam.label.user.dept" /></th><!-- 소속학과 -->
                                <th scope="col" data-breakpoints="xs"><spring:message code="forum.label.user.grade" /></th><!-- 학년 -->
                                <th scope="col" data-breakpoints="xs sm"><spring:message code="lesson.label.user.no" /></th><!-- 학번 -->
                                <th scope="col"><spring:message code="lesson.label.name" /></th><!-- 이름 -->
                                <th scope="col" data-breakpoints="xs sm "><spring:message code="std.label.comp_div" /></th><!-- 이수구분 -->
                                <th scope="col" data-breakpoints="xs sm "><spring:message code="common.label.exchange.total.point" /></th><!-- 환산총점 -->
                                <th scope="col" data-breakpoints="xs sm "><spring:message code="common.label.total.include.point" /></th><!-- 가산점 -->
                                <th scope="col" data-breakpoints="xs sm "><spring:message code="exam.label.level" /></th><!-- 등급 -->
                                <th scope="col" data-breakpoints="xs sm "><spring:message code="score.label.ranking" /></th><!-- 순위 -->
                                <th scope="col" data-breakpoints="xs sm "><spring:message code="forum.label.score.inquiry" /></th><!-- 성적상세조회 -->
                            </tr>
                        </thead>
                        <tbody id="objtProcList">
                        </tbody>
                    </table>
                </div>

                <div class="option-content mt15 mb10">
                    <b class="sec_head"></b>
                </div>

                <ul class="tbl dt-sm">
                    <li>
                    	<dl>
                            <dt style="width: 170px;">
                            	<spring:message code="score.label.request.reason" /><!-- 신청사유 -->
                            	<br />
                            	<small id="objtDttmFmt" class="word_break_none"></small><!-- 신청일시 -->
                           	</dt>
                            <dd>
                            	<pre id="objtCtnt"></pre>
                            </dd>
                        </dl>
                    </li>
                  <c:if test="${not empty fileList and fileList.size() > 0}">
                    <li>
                      <dl>
                        <dt style="width: 170px;"><spring:message code="common.attachments"/></dt><!-- 첨부파일 -->
                        <dd>
                          <!-- 첨부파일 -->
                          <div class="flex_1 mr5">
                            <ul>
                              <c:forEach items="${fileList}" var="row">
                                <li class="mb5 opacity7 file-txt">
                                  <a href="javascript:void(0)" class="border0"
                                     onclick="fileDown('<c:out value="${row.fileSn}"/>', '<c:out value="${row.repoCd}"/>')">
                                    <i class="xi-download mr3"></i><c:out value="${row.fileNm}"/> (<c:out
                                      value="${row.fileSizeStr}"/>)
                                  </a>
                                </li>
                              </c:forEach>
                            </ul>
                          </div>
                        </dd>
                      </dl>
                    </li>
                  </c:if>
                </ul>

                <div class="option-content mt15 mb10">
                    <b class="sec_head"><spring:message code="score.label.process.status" /></b><!-- 처리상태 및 결과 -->
                </div>

                <div class="">
                    <div class="ui attached message">
                        <div class="flex gap16">
                            <div class="ui radio checkbox">
                                <input type="radio" name="procCd" value="1" disabled="true">
                                <label><spring:message code="exam.label.approve" />(<spring:message code="score.label.additiona" />)</label><!-- 승인(가산점 부여) -->
                            </div>
                            <div class="ui radio checkbox">
                                <input type="radio" name="procCd" value="2" disabled="true">
                                <label><spring:message code="filebox.button.ok" />(<spring:message code="score.label.no.additiona" />)</label><!-- 확인(가산점 미부여) -->
                            </div>
                            <div class="ui radio checkbox">
                                <input type="radio" name="procCd" value="3" disabled="true">
                                <label><spring:message code="std.label.req_reject" />(<spring:message code="score.label.no.additiona" />)</label><!-- 반려(가산점 미부여) -->
                            </div>
                        </div>
                    </div>
                    <div class="ui bottom attached segment">
                        <textarea rows="5" id="procCtnt" placeholder="<spring:message code="exam.label.input" />" readonly="readonly"></textarea>
                    </div>
                </div>
            </div>
            <div class="bottom-content">
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="filebox.button.close" /></button><!-- 닫기 -->
            </div>
        </div>

        <!-- 성적상세조회 팝업 -->
	    <form class="ui form" id="modalScoreDtlForm" name="modalScoreDtlForm" method="POST" action="">
	    	<input type="hidden" name="crsCreCd"/>
	    	<input type="hidden" name="stdNo"/>
	    	<input type="hidden" name="objtUserId"/>
		    <div class="modal fade in" id="modalScoreDtl" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="forum.label.score.inquiry" />" aria-hidden="false">
		        <div class="modal-dialog modal-lg" role="document">
		            <div class="modal-content">
		                <div class="modal-header">
		                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="filebox.button.close" />">
		                        <span aria-hidden="true">&times;</span>
		                    </button>
		                    <h4 id="modalTitleId" class="modal-title"></h4>
		                </div>
		                <div class="modal-body">
		                    <iframe src="" id="modalScoreDtlIfm" name="modalScoreDtlIfm" width="100%" scrolling="no"></iframe>
		                </div>
		            </div>
		        </div>
		    </div>
	    </form>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
		<script>
        $('iframe').iFrameResize();
        window.closeModal = function() {
            $('.modal').modal('hide');
        };
    </script>
	</body>
</html>
