<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<div class="box_content">
	<ul class="dash_item_listA">		
		<c:choose>
		    <c:when test="${empty dashVM.profDashLctrQnaList}">
		        <li>강의Q&A가 없습니다</li>
		    </c:when>
            <c:otherwise>
            	<c:forEach var="item" items="${dashVM.profDashLctrQnaList}">
					<c:set var="cnt" value="0"/>
					<c:if test="${item.topic eq 'PROF_DASH_LCTR_QNA' and cnt lt 3}">
	                    <li>
	                        <div class="user">
	                           <span class="${item.userThumbnail}"></span>
	                        </div>
	                        <a class="item_txt"
								   href="javascript:void(0)"
								   onclick='moveMenu(
								       this,
								       "/bbs/bbsHome/bbsAtclView.do?bbsTycd=QNA&bbsId=${item.bbsId}&atclId=${item.atclId}&templateUrl=bbsHome",
								       "ROOT",
								       "PROMAIN000017",
								       "강의Q&A",
								       "tab"
								   )'
								   title="Q&A" style="color: currentColor;">			   
	                            <p class="tit">${item.atclTtl}</p>
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

// Q&A 위젯 설정
function setQnaWidget() {
	let inTitle = 	`<c:choose>
					        <c:when test="${subjectVM.badge.qnaNoreplyCnt eq '0'}">
					        </c:when>
					    <c:otherwise>
					        <small class="msg_num">${subjectVM.badge.qnaNoreplyCnt}</small>
					    </c:otherwise>
					</c:choose>`;
	let subTitle = `
		<div class="btn-wrap">
			<a href="#0" class="btn_more" aria-label="더보기" onclick="moveQnaWidgetMore();return false;"><i class="xi-plus"></i></a>
		</div>`;

	dashboardWidget.addInTitle("wigt_prof_qna", inTitle);
	dashboardWidget.addSubTitle("wigt_prof_qna", subTitle);
}

// 더보기 이동
function moveQnaWidgetMore() {
	moveMenu(this, "/bbs/bbsHome/bbsAtclListView.do?bbsTycd=QNA", "ROOT", "PROMAIN000017", "강의Q&A", "tab");
}

setQnaWidget();

</script>