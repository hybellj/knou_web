<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script>

	//let EPARAM = '<c:out value="${encParams}" />';	
	
</script>
							<div class="box_content">
                            	<ul class="dash_item_listA">
		                            <c:choose>
									    <c:when test="${empty dashVM.profDashOneOnOneList}">
									        <li>1:1 상담이 없습니다</li>
									    </c:when>
									    <c:otherwise>
		                                	<c:forEach var="item" items="${dashVM.profDashOneOnOneList}">
		                                		<c:set var="cnt" value="0"/>	
												<c:if test="${item.topic eq 'PROF_DASH_1ON1' and cnt lt 3}">
				                                    <li>
				                                        <div class="user">
				                                           <span class="${item.userThumbnail}"><img src="<%=request.getContextPath()%>/webdoc/assets/img/common/photo_user_sample3.jpg" aria-hidden="true" alt="사진"></span>
				                                        </div>		
				                                                                                												
														<a class="item_txt"
														   href="javascript:void(0)"
														   onclick='moveMenu(
														       this,
														       "/bbs/bbsHome/bbsAtclView.do?bbsTycd=1ON1&bbsId=${item.bbsId}&atclId=${item.atclId}&templateUrl=bbsHome",
														       "ROOT",
														       "PROMAIN000018",
														       "1:1 상담",
														       "tab"
														   )'
														   style="color: currentColor;">
														   <p class="tit">${item.atclTtl}​</p>
				                                            <p class="desc">
				                                                <span class="name">[${item.orgnm}] ${item.sbjctnm}</span>
				                                                <span class="date" style="display:inline-block; width:90px;"><uiex:formatDate value="${item.regDttm}" type="date"/></span>
				                                            </p>
				                                        </a>
				                                        <div class="state">
					                                        <c:choose>
					                                            <c:when test="${empty item.answerAtclId}">
			                                            			<label class="label check_no">미답변</label>
			                                            		</c:when>
				                                            	<c:otherwise>
				                                           			<label class="label check_reply">답변</label>
				                                           		</c:otherwise>
				                                           	</c:choose>
				                                        </div>
				                                    </li>
				                                    <c:set var="cnt" value="${cnt + 1}"/>
			                                    </c:if>
			                                </c:forEach>
	                               		</c:otherwise>
	                            	</c:choose>
	                            </ul>
                            </div>

<script>

// 1:1상담 위젯 설정
function setCounselWidget() {
	let inTitle = `<c:choose>
						<c:when test="${subjectVM.badge.oneOnOneNoreplyCnt eq 0}">
						</c:when>
						<c:otherwise>
							<small class="msg_num">${subjectVM.badge.oneOnOneNoreplyCnt}</small>
						</c:otherwise>
					</c:choose>`;
	let subTitle = `<div class="btn-wrap">
		<a href="#_" class="btn_more" aria-label="더보기" onclick="moveCounselWidgetMore();return false;"><i class="xi-plus"></i></a>
		</div>`;

	dashboardWidget.addInTitle("wigt_prof_counsel", inTitle);
	dashboardWidget.addSubTitle("wigt_prof_counsel", subTitle);
}

//더보기 이동
function moveCounselWidgetMore() {
	moveMenu(this, "/bbs/bbsHome/bbsAtclListView.do?bbsTycd=1ON1", "ROOT", "PROMAIN000018", "1:1상담", "tab");
}

setCounselWidget();

</script>