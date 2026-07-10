<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>

<aside id="admin_menu" class="menu gnb-menu expanded">
  <div class="inner">
    <div class="option-control">
      <button type="button" class="btn border-0 btn-close ctrl-lnb">
        <i class="icon-svg-close mobile-elem" aria-hidden="true"></i>
        <i class="icon-svg-ctrl-collapse desktop-elem" aria-hidden="true"></i>
        <span class="title">메뉴접기</span>
      </button>
    </div>

    <!-- admin user -->
    <div class="admin_user">
        <ul>
            <li><i class="icon-svg-layout-alt" aria-hidden="true"></i></li>
             <li><span class="current" id="navSubTitle">${topMenu.menunm}</span></li>
         </ul>
    </div>

    <div class="lnb">
		<ul id="navList" class="navList">
       		<c:forEach items="${subMenuList}" var="menu" varStatus="status">
				<c:if test="${empty menu.subMenuList}">
					<li class="${menuOnMap.containsKey(menu.menuId) ? "on" : ""}">
						<a href="#0" onclick="adminMoveMenu(this, '${menu.menuUrl}', '${menu.upMenuId}', '${menu.menuId}', '${menu.menunm}', '${menu.linkTargetTycd}');return false;" title="${menu.menunm}"><span class="menu-text">${menu.menunm}</span></a>
					</li>
				</c:if>
				<c:if test="${not empty menu.subMenuList}">
					<li class="has-sub ${menuOnMap.containsKey(menu.menuId) ? "on active" : ""}">
						<a href="#0" title="${menu.menunm}"><span class="menu-text">${menu.menunm}</span></a>
						<ul class="sub ${menuOnMap.containsKey(menu.menuId) ? "open" : ""}">
							<c:forEach items="${menu.subMenuList}" var="menu2" varStatus="status2">
								<c:if test="${empty menu2.subMenuList}">
									<li class="has-sub ${menu2.menuId eq curMenuId ? "active" : ""}">
										<a href="#0" onclick="adminMoveMenu(this, '${menu2.menuUrl}', '${menu2.upMenuId}', '${menu2.menuId}', '${menu2.menunm}', '${menu2.linkTargetTycd}');return false;" title="${menu2.menunm}">${menu2.menunm}</a>
									</li>
								</c:if>
								<c:if test="${not empty menu2.subMenuList}">
									<li class="has-sub ${menuOnMap.containsKey(menu2.menuId) ? "on active" : ""}">
										<a href="#0" title="${menu.menunm}">${menu2.menunm}</a>
										<ul class="sub_depth ${menuOnMap.containsKey(menu2.menuId) ? "open" : ""}">
											<c:forEach items="${menu2.subMenuList}" var="menu3" varStatus="status2">
												<li class="${menu3.menuId eq curMenuId ? "active" : ""}">
													<a href="#0" onclick="adminMoveMenu(this, '${menu3.menuUrl}', '${menu3.upMenuId}', '${menu3.menuId}', '${menu3.menunm}', '${menu3.linkTargetTycd}');return false;" title="${menu3.menunm}">${menu3.menunm}</a>
												</li>
											</c:forEach>
										</ul>
									</li>
								</c:if>
							</c:forEach>
						</ul>
					</li>
				</c:if>
       		</c:forEach>
       </ul>
    </div>

   </div>

</aside>

