<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<script type="text/javascript">
		var CRE_TCH_TYPE_LIST = [];
		var TCH_SEARCH_LIST = [];
		var TCH_LIST = [];
		
		$(document).ready(function() {
			// 운영자 구분
			<c:forEach var="item" items="${creTchTypeList}">
			CRE_TCH_TYPE_LIST.push({
				  codeCd: '<c:out value="${item.codeCd}" />'
				, codeNm: '<c:out value="${item.codeNm}" />'
			});
			</c:forEach>
			
			$("#searchValue").on("keydown", function(e) {
				if(e.keyCode == 13) {
					listTchSearch(1);
				}
			});
			
			$("#searchValue1").on("keydown", function(e) {
				if(e.keyCode == 13) {
					filterTch();
				}
			});
			
			// 운영자 목록
			listTch();
		});
		
		// 운영자 추가 검색
		function listTchSearch(pageIndex) {
			if(!$("#searchValue").val()) {
				alert("검색어를 입력하세요.");
				return;
			}
			
			var url = "/user/userMgr/userList.do";
			var data = {
				  pageIndex: pageIndex
				, listScale: 10
				, searchValue: $("#searchValue").val()
				, menuTypes: "ADMIN,PROFESSOR"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var returnList = data.returnList || [];
					TCH_SEARCH_LIST = returnList;
					
					setTchSearchList();
					
					var params = {
						totalCount : data.pageInfo.totalRecordCount,
						listScale : data.pageInfo.recordCountPerPage,
						currentPageNo : data.pageInfo.currentPageNo,
						eventName : "listTchSearch"
					};

					gfn_renderPaging(params);
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		// 운영자 추가 목록 세팅
		function setTchSearchList() {
			var html = '';
			
			if(TCH_SEARCH_LIST.length == 0) {
				html += '<div class="flex-container">';
				html += '	<div class="search-none">';
				html += '		<span><spring:message code="sys.common.search.no.result" /></span>'; // 검색 결과가 없습니다.
				html += '	</div>';
				html += '</div>';
			} else {
				html += '<table class="table select-list" data-sorting="false" data-paging="false" id="tchSearchTable">';
				html += '	<tBody>';
				TCH_SEARCH_LIST.forEach(function(v, i) {
					html += '	<tr data-user-no="' + v.userId + '" data-user-nm="' + v.userNm + '" data-dept-nm="' + (v.deptNm || "") + '">';
					html += '		<td class="">';
					html += 			v.userNm + '(' + (v.deptNm || '-') + ')';
					html += '			<br />';
					html +=				(v.mobileNo || '-') + '<span class="ml5 mr5 fcGrey">|</span>' + (v.email || '-')  + '<span  class="ml5 mr5 fcGrey">|</span>' + (v.authGrpNm || '-');
					html += '		</td>';
					html += '	</tr>';
				});
				html += '	<tBody>';
				html += '</table>';
			}
			
			$("#tchSearchList").html(html);
			$("#tchSearchTable").footable();
			
			// 선택 이벤트
			$("[data-user-no]").off("click").on("click", function() {
				//$("[data-user-no]").removeClass("active");
				//$(this).addClass("active");
				$(this).toggleClass("active");
			});
		}
		
		// 운영자 리스트
		function listTch() {
			var url = "/crs/creCrsMgr/listCreTch.do";
			var data = {
				crsCreCd: '<c:out value="${creCrsVO.crsCreCd}" />'
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var returnList = data.returnList || [];
					TCH_LIST = [];
					
					returnList.sort(function(a, b) {
						var tchTypeA = a.tchType == "PROFESSOR" && a.repYn == "N" ? "ASSOCIATE" : a.tchType;
						var tchTypeB = b.tchType == "PROFESSOR" && b.repYn == "N" ? "ASSOCIATE" : b.tchType;
						
						var sortObj = {
							  PROFESSOR: 1
							, ASSOCIATE: 2
							, ASSISTANT: 3
							, MONITORING: 4
						};
						
						if(sortObj[tchTypeA] > sortObj[tchTypeB]) return 1;
						if(sortObj[tchTypeA] < sortObj[tchTypeB]) return -1;
						if(sortObj[tchTypeA] == sortObj[tchTypeB]) {
							if(a.userNm > b.userNm) return 1;
							if(a.userNm < b.userNm) return -1;
						}

						return 0;
					});
					
					returnList.forEach(function(v, i) {
						TCH_LIST.push({
							  userId: v.userId
							, userNm: v.userNm
							, deptNm: v.deptNm
							, tchType: v.tchType == "PROFESSOR" && v.repYn == "N" ? "ASSOCIATE" : v.tchType
							, repYn: v.repYn
						});
					});
					
					setTchList(TCH_LIST);
					setTchSearchList();
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		// 운영자 목록 세팅
		function setTchList(list) {
			var html = '';
			
			list.forEach(function(v, i) {
				var tchType = v.tchType == "PROFESSOR" && v.repYn == "N" ? "ASSOCIATE" : v.tchType;
				
				html += '	<tr>';
				html += '		<td>' + (v.deptNm || '-') + '</td>';
				html += '		<td>' + v.userId + '</td>';
				html += '		<td>' + v.userNm + '</td>';
				html += '		<td>'
				html += '			<select class="ui dropdown w150" onchange="setTchType(\'' + v.userId + '\', this.value)">';
				if(!v.tchType) {
					html += '		<option value=""><spring:message code="common.button.choice" /></option>'; // 선택
				}
				CRE_TCH_TYPE_LIST.forEach(function(vv, j) {
					var selected = "";
					
					if(vv.codeCd == tchType) {
						selected = "selected";
					}
					
					html += '			<option value="' + vv.codeCd + '" ' + selected + '>' + vv.codeNm + '</option>';
				});
				html += '			</select>';
				html += '		</td>';
				html += '		<td>';
				html += '			<a href="javascript:void(0);" class="ui basic small button" onclick="removeTch(\'' + v.userId + '\');"><spring:message code="button.delete"/></a>'; // 삭제
				html += '		</td>';
				html += '	</tr>';
			});
			
			$("#tchList").html(html);
			$("#tchTable").footable();
			$("#tchList").find(".ui.dropdown").dropdown();
		}
		
		// 운영자 구분 설정
		function setTchType(userId, tchType) {
			TCH_LIST.forEach(function(v, i) {
				if(userId == v.userId) {
					v.tchType = tchType;
				}
			});
		}
		
		// 운영자 필터
		function filterTch() {
			var searchValue = $("#searchValue1").val();
			
			if(!searchValue) {
				setTchList(TCH_LIST);
			} else {
				var searchList = [];
				
				TCH_LIST.forEach(function(v, i) {
					if(v.userId.indexOf(searchValue) > -1 || v.userNm.indexOf(searchValue) > -1) {
						searchList.push(v);
					}
				});
				
				setTchList(searchList);
			}
		}
		
		// 운영자 등록
		function addToTchList() {
			var $tr = $("#tchSearchTable > tbody > tr.active");
			
			if($tr.length == 0) {
				alert("추가할 운영자를 선택하세요.");
				return;
			}
			
			$($("#tchSearchTable > tbody > tr.active")).each(function() {
				var userId = $(this).data("userId");
				var userNm = $(this).data("userNm");
				var deptNm = $(this).data("deptNm") || "";
				
				var isExists = false;
				TCH_LIST.forEach(function(v, i) {
					if(userId == v.userId) {
						isExists = true;
						return false;
					}
				});
				
				if(isExists) return true;
				
				TCH_LIST.push({
					  userId: userId
					, userNm: userNm
					, deptNm: deptNm
					, tchType: ""
				});
			});
			
			setTchSearchList();
			setTchList(TCH_LIST);
		}
		
		// 운영자 삭제 
		function removeTch(userId) {
			TCH_LIST = TCH_LIST.filter(function(v, i) {
				return userId != v.userId;
			});
			
			setTchList(TCH_LIST);
		}
		
		// 저장 버튼
		function addCrsCreTchList(crsCreCd) {
			if(TCH_LIST.length == 0) {
				return;
			} else {
				var repCnt = 0;
				var isSetTchType = true;
				
				TCH_LIST.forEach(function(v, i) {
					if(v.tchType == "PROFESSOR") {
						repCnt++;
					}
					
					if(!v.tchType) {
						isSetTchType = false;
						return false;
					}
				});
				
				if(!isSetTchType) {
					alert('운영자 구분을 선택하세요.');
					return;
				}
				
				if(repCnt > 1) {
					// 책임교수는 1명만 설정 가능합니다.
					alert('<spring:message code="user.message.userinfo.crecrs.professor" />');
					return;
				}
				
				var form = $("<form></form>");
				form.attr("method", "POST");
				form.attr("name", "addTchForm");
				form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: crsCreCd}));
				TCH_LIST.forEach(function(v, i) {
					form.append($('<input/>', {type: 'hidden', name: "tchNoArr", value: v.userId}));
					form.append($('<input/>', {type: 'hidden', name: "tchTypeArr", value: v.tchType}));
				});
				
				var url = "/crs/creCrsMgr/addTch.do";
				var data = form.serialize();

				ajaxCall(url, data, function(data) {
					if (data.result > 0) {
						alert("<spring:message code='crs.alert.reg.operator'/>"); // 운영자 등록하였습니다.
						$("#searchValue1").val("");
						listTch();
					} else {
						alert(data.message);
					}
				}, function(xhr, status, error) {
					alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
				}, true);
			}
		}
		
		// 취소 버튼
		function moveCrsCreList() {
			var crsTypeCd = '<c:out value="${creCrsVO.crsTypeCd}" />';
			
			var url = "";
			if(crsTypeCd == "OPEN") {
				 // 공개강좌 개설과목 목록
				 url = "/crs/creCrsMgr/Form/creCrsOpenListForm.do";
			} else if(crsTypeCd == "LEGAL") {
				 // 법정교육 개설과목 목록
				 url = "/crs/creCrsMgr/Form/creCrsLegalListForm.do";
			} else {
				 // 학기제 개설과목 목록
				 url = "/crs/creCrsMgr/Form/creCrsListForm.do";
			}
			
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "moveForm");
			form.attr("action", url);
			form.appendTo("body");
			form.submit();
		}
		
		// 과목 정보 등록 버튼
		function moveCrsCre() {
			var crsTypeCd = '<c:out value="${creCrsVO.crsTypeCd}" />';
			
			var url = "";
			if(crsTypeCd == "OPEN") {
				// 공개 과정 목록
				url = "/crs/creCrsMgr/Form/creCrsOpenWriteForm.do";
			}else if(crsTypeCd == "LEGAL"){
				// 법정교육  등록
				url = "/crs/creCrsMgr/Form/creCrsLegalWriteForm.do";
			} else {
				url = "/crs/creCrsMgr/Form/addForm.do";
			}
			
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "moveForm");
			form.attr("action", url);
			form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${creCrsVO.crsCreCd}" />'}));
			form.appendTo("body");
			form.submit();
		}
		
		// 수강생 이동 버튼
		function moveCrsCreStd() {
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "moveForm");
			form.attr("action", "/crs/creCrsMgr/Form/crsStdForm.do");
			form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${creCrsVO.crsCreCd}" />'}));
			form.append($('<input/>', {type: 'hidden', name: "crsTypeCd", value: '<c:out value="${creCrsVO.crsTypeCd}" />'}));
			form.appendTo("body");
			form.submit();
		}
	</script>
</head>
<body>
    <div id="wrap" class="pusher">
		<!-- class_top 인클루드  -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
        <div id="container">
            <div class="content">
            	<div id="info-item-box">
					<h2 class="page-title flex-item">
					    <spring:message code="common.term.subject"/><!-- 학기/과목 -->
					    <div class="ui breadcrumb small">
					        <small class="section"><spring:message code="crs.label.reg.operator"/><!-- 운영자 등록 --></small>
					    </div>
					</h2>
				    <div class="button-area">
				    	<a href="javascript:moveCrsCre();" class="btn"><spring:message code='common.label.previous'/></a><!-- 이전 -->
				        <a href="javascript:moveCrsCreStd();" class="btn"><spring:message code='button.next'/></a><!-- 다음 -->
				        <a href="javascript:addCrsCreTchList('${vo.crsCreCd}');" class="btn btn-primary"><spring:message code='button.add'/></a><!-- 저장 -->
				        <a href="javascript:moveCrsCreList();" class="btn btn-negative"><spring:message code='button.cancel'/></a><!-- 취소 -->
				    </div>
				</div>
				<div class="ui divider mt0"></div>
				
	            <div class="ui form">
					<div class="ui form">
					    <ol class="cd-multi-steps text-bottom count">
					        <li><a href="javascript:moveCrsCre();"><span><spring:message code='crs.lecture.info.regist'/></span></a></li><!-- 과목 정보 등록 -->
					        <li class="current"><a href="javascript:void(0);"><span><spring:message code='crs.label.reg.operator'/></span></a></li><!-- 운영자 등록 -->
							<li><a href="javascript:moveCrsCreStd();"><span><spring:message code='crs.label.learner.regist'/></span></a></li><!-- 수강생 등록 -->
					    </ol>
					    <div class="ui grid stretched row">
						    <div class="sixteen wide tablet six wide computer column">
							    <div class="ui top attached message">
								    <div class="header"><spring:message code="crs.label.add.operator"/></div><!-- 운영자 추가 -->
								</div>
								<div class="ui bottom attached segment">
								    <div class="option-content">
								        <div class="ui action input search-box">
								            <input type="text" placeholder="<spring:message code='crs.label.search.operator'/>" id="searchValue" /><!-- 운영자를 검색하세요 -->
								            <button class="ui icon button" onclick="listTchSearch(1);" type="button"><i class="search icon"></i></button>
								        </div>
								        <div class="button-area">
								            <a href="javascript:addToTchList()" class="ui basic button"><spring:message code="crs.label.reg.operator"/></a><!-- 운영자 등록 -->
								        </div>
								    </div>
								    <div id="tchSearchList">
								    	<div class="flex-container">
									        <div class="search-none">
									            <span><spring:message code="sys.common.search.no.result" /></span><!-- 검색 결과가 없습니다. -->
									        </div>
									    </div>
								    </div>
								    <div id="paging" class="paging mt10"></div>
								</div>
						    </div>
						    <div class="sixteen wide tablet ten wide computer column">
						    	
						    	<div class="ui top attached message">
								    <div class="header"><spring:message code='crs.label.operator.list'/></div><!-- 운영자 목록 -->
								</div>
								<div class="ui bottom attached segment">
								    <div class="option-content">
								        <div class="ui action input search-box">
								            <input type="text" placeholder="<spring:message code='button.search'/>" id="searchValue1" /><!-- 검색 -->
								            <a class="ui icon button" onclick="filterTch()"><i class="search icon"></i></a>
								        </div>
								    </div>
								    <table class="table" data-sorting="true" data-paging="false" data-empty="<spring:message code="common.nodata.msg" />" id="tchTable"><!-- 등록된 내용이 없습니다. -->
									    <thead>
									        <tr>
									            <th scope="col" data-breakpoints="xs"><spring:message code='common.dept_name'/></th><!-- 학과 -->
									            <th scope="col" data-breakpoints="xs"><spring:message code='common.id'/></th><!-- 아이디 -->
									            <th scope="col"><spring:message code='common.name'/></th><!-- 이름 -->
									            <th scope="col"><spring:message code='crs.manager.classification'/></th><!-- 운영자 구분 -->
									            <th scope="col" data-sortable="false" data-breakpoints="xs"><spring:message code='common.mgr'/></th><!-- 관리 -->
									        </tr>
									    </thead>
									    <tbody id="tchList">
									    </tbody>
									</table>
								</div>
						    </div>
					    </div>
					</div>
   		 		</div>
   		 		<!-- //ui form -->
   	 		</div>
   	 		<!-- //본문 content 부분 -->
    	</div>
    	<!-- footer 영역 부분 -->
    	<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
</body>
</html>