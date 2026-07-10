<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

					
                          <!-- box_content -->
                          <div class="box_content">
                              <ul class="dash_item_listA">
                              <c:choose>
								    <c:when test="${empty dashVM.stdntDashDatarmList}">
								        <li>강의자료가 없습니다</li>
								    </c:when>
	                               	<c:otherwise>
	                               		<c:set var="cnt" value="0"/>
	                                	<c:forEach var="item" items="${dashVM.stdntDashDatarmList}">                                	
											<c:if test="${item.topic eq 'STDNT_DASH_DATARM' and cnt lt 3}">
			                                    <li>
			                                        <div class="user">
			                                           <span class="user_img"></span>
			                                        </div>   
												    	<a class="item_txt"
														   href="javascript:void(0)"
														   onclick='moveMenu(
														       this,
														       "/bbs/bbsHome/bbsAtclView.do?bbsTycd=DATARM&bbsId=${item.bbsId}&atclId=${item.atclId}&templateUrl=bbsHome",
														       "ROOT",
														       "STDMAIN000011",
														       "강의자료실",
														       "tab"
														   )'
														   title="강의자료실" style="color: currentColor;">
			                                            <p class="tit">${item.atclTtl}</p>
			                                            <p class="desc">
			                                                <span class="name">[${item.orgnm}] ${item.sbjctnm}</span>
			                                                <span class="date" style="display:inline-block; width:90px;"><uiex:formatDate value="${item.regDttm}" type="date"/>
			                                            </p>
			                                        </a>
			                                        <div class="state">
				                                        <a href="#0" class="btn btn_down">다운로드</a>
										         	</div>
			                                    </li>
			                                    <c:set var="cnt" value="${cnt + 1}"/>
		                                    </c:if>
	                                  	</c:forEach>
								    </c:otherwise>
								</c:choose>
                              	</ul>
                          </div>
                          <!--//box_content -->

<script>

// 강의자료실 위젯 설정
function setPdsWidget() {
	let inTitle = ``;
	let subTitle = `
		<div class="btn-wrap">
			<a href="#0" class="btn_more" aria-label="더보기" onclick="movePdsWidgetMore();return false;"><i class="xi-plus"></i></a>
		</div>`;

	dashboardWidget.addInTitle("wigt_stu_pds", inTitle);
	dashboardWidget.addSubTitle("wigt_stu_pds", subTitle);
}

// 더보기 이동
function movePdsWidgetMore() {
	// 강의자료실
	moveMenu(this, "/bbs/bbsHome/bbsAtclListView.do?bbsTycd=DATARM", "ROOT", "STDMAIN000011", "강의자료실", "tab");
}

setPdsWidget();

</script>