<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/resh/common/resh_common_inc.jsp" %>
<script type="text/javascript">
	$(document).ready(function() {
		// 카드 형식일때 출력 개수 숨김
		$("#listScaleDiv").hide();
		listResh(1);
		
		$("#searchValue").on("keyup", function(e) {
			if(e.keyCode == 13) {
				listResh(1);
			}
		});
	});
	
	// 리스트 타입 변환
	function listReshType(){
	 	if($("#listType i").hasClass("list")){
			$("#listType i").removeClass("list").addClass("th");
			$("#listScaleDiv").show();
		}else{
			$("#listType i").removeClass("th").addClass("list");
			$("#listScaleDiv").hide();
		}
	 	
	 	listResh(1);
	}
	
	// 리스트 조회
	function listResh(page) {
		var url  = "/resh/reshListPaging.do";
		if($("#listScale").val() == "0" || $("#listType i").hasClass("list")) {
			url = "/resh/reshList.do";
		}
		var data = {
			"reschTypeCd" : "HOME",
			"pageIndex"   : page,
			"listScale"   : $("#listScale").val(),
			"searchValue" : $("#searchValue").val()
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
				var html = createReshListHTML(returnList);
				
				$("#list").empty().html(html);
				if($("#listType i").hasClass("th")){
	    			$(".table").footable();
	    			if($("#listScale").val() != "0") {
		    			var params = {
					    	totalCount 	  : data.pageInfo.totalRecordCount,
					    	listScale 	  : data.pageInfo.pageSize,
					    	currentPageNo : data.pageInfo.currentPageNo,
					    	eventName 	  : "listResh"
					    };
					    
					    gfn_renderPaging(params);
	    			}
        		} else {
        			$(".ui.dropdown").dropdown();
        			$(".card-item-center .title-box label").unbind('click').bind('click', function(e) {
        		        $(".card-item-center .title-box label").toggleClass('active');
        		    });
        		}
				var totalCnt = returnList.length > 0 ? returnList[0].totalCnt : "0";
        		$("#reshTotCnt").text(totalCnt);
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			alert("<spring:message code='resh.error.list' />");/* 설문 리스트 조회 중 에러가 발생하였습니다. */
		});
	}
	
	// 전체설문 리스트 생성
	function createReshListHTML(list) {
		var html = "";
		
		if($("#listType i").hasClass("th")){
			html += `<table class="table" data-sorting="false" data-paging="false" data-empty="<spring:message code='resh.common.empty' />">`;/* 등록된 내용이 없습니다. */
			html += `	<colgroup>`;
			html += `		<col width="3%">`;
			html += `		<col width="13%">`;
			html += `		<col width="20%">`;
			html += `		<col width="5%">`;
			html += `		<col width="8%">`;
			html += `		<col width="10%">`;
			html += `		<col width="8%">`;
			html += `		<col width="*">`;
			html += `	</colgroup>`;
			html += `	<thead>`;
			html += `		<tr>`;
			html += `			<th class="tc"><spring:message code="main.common.number.no" /></th>`;/* NO */
			html += `			<th class="tc"><spring:message code="resh.label.resh.home.title" /></th>`;/* 전체설문명 */
			html += `			<th class="tc"><spring:message code="resh.label.resh.home.period" /></th>`;/* 전체설문 기간 */
			html += `			<th class="tc"><spring:message code="resh.label.item.cnt" /></th>`;/* 문항수 */
			html += `			<th class="tc"><spring:message code="resh.label.resutl.view" /></th>`;/* 결과조회 */
			html += `			<th class="tc"><spring:message code="resh.label.resh.home.open.yn" /></th>`;/* 전체설문공개 */
			html += `			<th class="tc"><spring:message code="resh.label.progress.status" /></th>`;/* 진행상태 */
			html += `			<th class="tc"><spring:message code="resh.label.manage" /></th>`;/* 관리 */
			html += `		</tr>`;
			html += `	</thead>`;
			html += `	<tbody>`;
			list.forEach(function(v, i) {
			var reschStartDttm = dateFormat("date", v.reschStartDttm);
			var reschEndDttm   = dateFormat("date", v.reschEndDttm);
			var rsltOpenYn	   = v.rsltTypeCd == "ALL" || v.rsltTypeCd == "JOIN" ? "<spring:message code='resh.label.allow.y' />"/* 허용 */ : "<span class='fcRed'><spring:message code='resh.label.allow.n' /></span>";/* 비허용 */
			var submitYn	   = v.reschSubmitYn == "Y" ? "<spring:message code='resh.label.open.y' />"/* 공개 */ : "<span class='fcRed'><spring:message code='resh.label.open.n' /></span>";/* 비공개 */
			var qstnClass      = v.reschQstnCnt == 0 ? "grey" : "blue";
			html += `		<tr>`;
			html += `			<td class="tc">\${v.lineNo}</td>`;
			html += `			<td><a href="javascript:viewResh(0, '\${v.reschCd }')" class="fcBlue">\${v.reschTitle}</a></td>`;
			html += `			<td class="tc">\${reschStartDttm} ~ \${reschEndDttm}</td>`;
			html += `			<td class="tc"><a href="javascript:viewResh(1, '\${v.reschCd }')" class="fcBlue">\${v.reschQstnCnt}</a></td>`;
			html += `			<td class="tc">\${rsltOpenYn}</td>`;
			html += `			<td class="tc">\${submitYn}</td>`;
			html += `			<td class="tc">\${v.reschStatus}</td>`;
			html += `			<td class="tc">`;
			html += `				<a href="javascript:reshQstnPreview('\${v.reschCd}')" class="ui blue small button"><spring:message code="resh.label.preview" /></a>`;/* 미리보기 */
			html += `				<a href="javascript:viewResh(1, '\${v.reschCd }')" class="ui \${qstnClass} small button"><spring:message code="resh.tab.item.manage" /></a>`;/* 문항 관리 */
			html += `				<a href="javascript:viewResh(2, '\${v.reschCd }')" class="ui blue small button"><spring:message code="resh.label.resh.home.result" /></a>`;/* 전체설문결과 */
			html += `			</td>`;
			html += `		</tr>`;
			});
			html += `	</tbody>`;
			html += `</table>`;
			html += `<div id="paging" class="paging"></div>`;
		} else {
			if(list.length > 0) {
				html += `<div class='ui two stackable cards info-type mt10'>`;
				list.forEach(function(v, i) {
					var reschStartDttm = dateFormat("date", v.reschStartDttm);
					var reschEndDttm   = dateFormat("date", v.reschEndDttm);
					var submitYn	   = v.reschStatus != '대기' && v.reschSubmitYn == 'Y' ? "<i><spring:message code='resh.label.open.y' /></i>"/* 공개 */ : "<i class='fcRed'><spring:message code='resh.label.open.n' /></i>";/* 비공개 */
					var rsltOpenYn	   = v.rsltTypeCd == 'ALL' || v.rsltTypeCd == 'JOIN' ? "<i><spring:message code='resh.label.allow.y.status' /></i>"/* 가능 */ : "<i class='fcRed'><spring:message code='resh.label.allow.n.status' /></i>";/* 불가능 */
					html += `<div class="card">`;
					html += `	<div class="content card-item-center">`;
					html += `		<div class="title-box">`;
					html += `			<label class="ui yellow label active"><spring:message code="resh.label.resh.home" />​</label>`;/* 전체설문 */
					html += `			<a href="javascript:viewResh(0, '\${v.reschCd }')" class="header header-icon">\${v.reschTitle }</a>`;
					html += `		</div>`;
					html += `		<div class="ui top right pointing dropdown right-box">`;
					html += `			<span class="bars"><spring:message code="resh.label.menu" /></span>`;/* 메뉴 */
					html += `			<div class="menu">`;
					html += `				<a href="javascript:reshQstnPreview('\${v.reschCd}')" class="item"><spring:message code="resh.label.preview" /></a>`;/* 미리보기 */
					html += `				<a href="javascript:viewResh(1, '\${v.reschCd }')" class="item"><spring:message code="resh.tab.item.manage" /></a>`;/* 문항 관리 */
					html += `				<a href="javascript:viewResh(2, '\${v.reschCd }')" class="item"><spring:message code="resh.label.resh.home.result" /></a>`;/* 전체설문결과 */
					html += `				<a href="javascript:viewResh(9, '\${v.reschCd }')" class="item"><spring:message code="resh.button.modify" /></a>`;/* 수정 */
					html += `				<a href="javascript:delResh('\${v.reschCd }')" class="item"><spring:message code="resh.button.delete" /></a>`;/* 삭제 */
					html += `			</div>`;
					html += `		</div>`;
					html += `	</div>`;
					html += `	<div class="sum-box">`;
					html += `		<ul class="process-bar">`;
					html += `			<li class="bar-blue" style="width: \${(v.homeReschJoinUserCnt*100)/v.homeReschTotalUserCnt}%;">\${v.homeReschJoinUserCnt }<spring:message code="resh.label.nm" /></li>`;/* 명 */
					html += `			<li class="bar-softgrey" style="width: \${((v.homeReschTotalUserCnt-v.homeReschJoinUserCnt)*100)/v.homeReschTotalUserCnt}%;">\${v.homeReschTotalUserCnt - v.homeReschJoinUserCnt }<spring:message code="resh.label.nm" /></li>`;/* 명 */
					html += `		</ul>`;
					html += `		<span class='ui mini blue label'>\${v.reschStatus }</span>`;
					html += `	</div>`;
					html += `	<div class="content ui form equal width">`;
					html += `		<div class="fields">`;
					html += `			<div class="inline field">`;
					html += `				<label class="label-title-lg"><spring:message code="resh.label.resh.home.period" /></label>`;/* 전체설문 기간 */
					html += `				<i>\${reschStartDttm } ~ \${reschEndDttm }</i>`;
					html += `			</div>`;
					html += `		</div>`;
					html += `		<div class="fields">`;
					html += `			<div class="inline field">`;
					html += `				<label class="label-title-lg"><spring:message code="resh.label.applicant.cnt" /></label>`;/* 대상인원 */
					html += `				<i>\${v.homeReschTotalUserCnt }<spring:message code="resh.label.nm" /></i>`;/* 명 */
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
					html += `				<label class="label-title-lg"><spring:message code="resh.label.resh.home.open.yn" /></label>`;/* 전체설문공개 */
					html += `				\${submitYn}`;
					html += `			</div>`;
					html += `		</div>`;
					html += `		<div class="fields">`;
					html += `			<div class="inline field">`;
					html += `				<label class="label-title-lg"><spring:message code="resh.label.allow.yn" /></label>`;/* 결과조회허용여부 */
					html += `				\${rsltOpenYn}`;
					html += `			</div>`;
					html += `		</div>`;
					html += `	</div>`;
					html += `</div>`;
				});
				html += `</div>`;
			} else {
				html += "<div class='ui attached segment flex flex-column flex1'>";
				html += "	<div class='flex-item-center flex1'>";
				html += "		<spring:message code='resh.common.empty' />";/* 등록된 내용이 없습니다. */
				html += "	</div>";
				html += "</div>";
			}
		}
		
		return html;
	}
	
	// 설문지 미리보기
	function reshQstnPreview(reschCd) {
		var kvArr = [];
		kvArr.push({'key' : 'reschCd', 'val' : reschCd});
		
		submitForm("/resh/reshQstnPreviewPop.do", "reshPopIfm", "reshPreview", kvArr);
	}
	
	// 설문 삭제
	function delResh(reschCd) {
		var url  = "/resh/selectReshInfo.do";
		var data = {
			"reschTypeCd" : "HOME",
			"reschCd"  	  : reschCd
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				var confirm = "";
        		var reshVO  = data.returnVO;
        		if(reshVO.homeReschJoinUserCnt > 0) {
        			confirm = window.confirm(`<spring:message code="resh.comfirm.home.resh.exist.join.user.y" />`);/* 전체설문 참여자가 있습니다. 삭제 시 전체설문결과가 삭제됩니다.\r\n정말 삭제 하시겠습니까? */
        		} else {
        			confirm = window.confirm("<spring:message code='resh.comfirm.home.resh.exist.join.user.n' />");/* 전체설문 참여자가 없습니다. 삭제 하시겠습니까? */
        		}
        		if(confirm) {
        			var kvArr = [];
        			kvArr.push({'key' : 'reschCd', 'val' : reschCd});
        			
        			submitForm("/resh/reshMgr/delHomeResh.do", "", "", kvArr);
        		}
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='resh.error.delete' />");/* 설문 삭제 중 에러가 발생하였습니다. */
		});
	}
	
	// 설문 정보 페이지
	function viewResh(tab, reschCd) {
		var urlMap = {
			"0" : "/resh/reshMgr/homeReshInfoManage.do",	// 전체설문 정보 상세 페이지
			"1" : "/resh/reshMgr/homeReshQstnManage.do",	// 전체설문 문항 관리 페이지
			"2" : "/resh/reshMgr/homeReshResultManage.do",	// 전체설문 결과 페이지
			"8" : "/resh/reshMgr/Form/writeHomeResh.do", 	// 전체설문 등록 페이지
			"9" : "/resh/reshMgr/Form/editHomeResh.do" 		// 전체설문 수정 페이지
		};
		
		var kvArr = [];
		kvArr.push({'key' : 'reschCd', 'val' : reschCd});
		
		submitForm(urlMap[tab], "", "", kvArr);
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
                                <spring:message code="resh.label.home.resh" /><!-- 전체 설문 -->
                                <div class="ui breadcrumb small">
                                    <small class="section"><spring:message code="resh.button.list" /><!-- 목록 --></small>
                                </div>
                            </h2>
			            </div>
			            <div class="row">
			            	<div class="col">
			            		<div class="option-content mb20">
				            		<h3 class="sec_head inline-block pr20"><spring:message code="resh.label.resh.home" /><!-- 전체설문 --></h3>
				            		<span>[ <spring:message code="resh.label.tot" /> <spring:message code="resh.label.cnt.item" /> : <label id="reshTotCnt" class="fcBlue"></label> ]</span><!-- 총 --><!-- 건수 -->
				            		<div class="mla">
				            			<a href="javascript:viewResh(8, '')" class="ui orange button w100"><spring:message code="resh.label.resh.add" /><!-- 설문등록 --></a>
				            		</div>
			            		</div>
			            		<div class="option-content mb20">
			            			<button class="ui basic icon button" id="listType" title="<spring:message code="asmnt.label.title.list" />" onclick="listReshType()"><i class="list ul icon"></i></button>
					                <div class="ui action input search-box mr5">
					                    <input type="text" class="w250" id="searchValue" placeholder="<spring:message code='resh.label.resh.home.title' /> <spring:message code='resh.label.input' />"><!-- 전체설문명 --><!-- 입력 -->
					                    <button class="ui icon button" onclick="listResh(1)"><i class="search icon"></i></button>
					                </div>
					                <div class="button-area flex-left-auto" id="listScaleDiv">
						                <select class="ui dropdown mr5 list-num" id="listScale" onchange="listResh(1)">
						                    <option value="10">10</option>
						                    <option value="20">20</option>
						                    <option value="50">50</option>
						                    <option value="100">100</option>
						                    <option value="0"><spring:message code="resh.common.search.all" /><!-- 전체 --></option>
						                </select>
					                </div>
			            		</div>
			            		<div id="list"></div>
			            	</div>
			            </div>
					</div>
				</div>
	        </div>
	        <!-- //본문 content 부분 -->
	        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
        </div>
    </div>
</body>
</html>