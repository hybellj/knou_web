<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

						<div class="sub-content">
	                        <div class="page-info">
	                            <h2 class="page-title">교수/튜터/조교정보</h2>
	                        </div>
	                        <div class="board_top">
	                            <h3 class="board-title">담당 교수</h3>
	                        </div>
	                        <div class="prof-box">	                        	
		                        	<c:choose>
		                                <c:when test="${not empty users}">
		                                    <c:forEach var="item" items="${users}">
		                                    	<c:if test="${item.sbjctAdmTycd == 'PROF' or item.sbjctAdmTycd == 'COPROF'}">
		                                    	<!--  user-wrap -->
	                            				<div class="user-wrap">
					                                <div class="left_item">
					                                    <div class="user-img">
					                                        <div class="user-photo">
					                                            <!--프로필 사진-->
					                                            <img src="/lms_design_sample/webdoc/assets/img/common/photo_user_sample.png" alt="사진">
					                                        </div>                                       
					                                    </div>  
					                                    <div class="user-btn"><button type="button" class="btn type2">정보수정</button></div>
					                                </div>                                               
					                                <div class="table_list">                            
					                                    <ul class="list">
					                                        <li class="head"><label>이름</label></li>
					                                        <li>${item.usernm} 교수</li>                             
					                                    </ul>
					                                    <ul class="list">
					                                        <li class="head"><label>이메일</label></li>
					                                        <li>${item.eml}<br>
					                                        <small class="note2">! 메일 주소는 공개 여부와 관계없이 공개됩니다.</small>
					                                        </li>                                
					                                    </ul>                                
					                                    <ul class="list">
					                                        <li class="head"><label>전화번호</label></li>
					                                        <li>(사무실) ${item.offiPhn}</li>                                
					                                    </ul>
					                                    <ul class="list">
					                                        <li class="head"><label>과목운영자</label></li>
					                                        <li>
					                                            <select class="form-select" id="selectProf">
					                                            	<option value="담당교수" ${item.sbjctAdmTycd == 'PROF' ? 'selected' : ''}>담당교수</option>
            														<option value="공동교수" ${item.sbjctAdmTycd == 'COPROF' ? 'selected' : ''}>공동교수</option>
					                                            </select>
					                                        </li>                                
					                                    </ul>  
					                                </div>
					                            </div>
	                           					<!--  //user-wrap -->
					                        </c:if>
					                    </c:forEach>
					                </c:when>
					            </c:choose> 
	                        </div>                     
	
	                        <div class="board_top">
	                            <h3 class="board-title">튜터/조교</h3>
	                        </div>
	                        <div class="prof-box">
		                        <c:choose>
	                                <c:when test="${not empty users}">
	                                    <c:forEach var="item" items="${users}">
	                                    	<c:if test="${item.sbjctAdmTycd == 'TUT' or item.sbjctAdmTycd == 'ASSI'}">
	                                    		<!--  user-wrap -->				                        
					                            <div class="user-wrap">		                            
					                                <div class="left_item">
					                                    <div class="user-img">
					                                        <div class="user-photo"><!--프로필 사진-->
					                                            <img src="/lms_design_sample/webdoc/assets/img/common/sample.jpg" alt="사진">
					                                        </div>                                       
					                                    </div>  
					                                    <div class="user-btn"><button type="button" class="btn type2">정보수정</button></div> 
					                                </div>                                               
					                                <div class="table_list">                            
					                                    <ul class="list">
					                                        <li class="head"><label>이름</label></li>
					                                        <li>${item.usernm}</li>                             
					                                    </ul>
					                                    <ul class="list">
					                                        <li class="head"><label>이메일</label></li>
					                                        <li>${item.eml}<br>
					                                        <small class="note2">! 메일 주소는 공개 여부와 관계없이 공개됩니다.</small>
					                                        </li>                                
					                                    </ul>                                
					                                    <ul class="list">
					                                        <li class="head"><label>전화번호</label></li>
					                                        <li>(사무실) ${item.offiPhn}</li>                                
					                                    </ul>
					                                    <ul class="list">
					                                        <li class="head"><label>과목운영자</label></li>
					                                        <li>
					                                            <select class="form-select" id="selectProf">
					                                                <option value="튜터" ${item.sbjctAdmTycd ==  'TUT' ? 'selected' : ''}>튜터</option>
            														<option value="조교" ${item.sbjctAdmTycd == 'ASSI' ? 'selected' : ''}>조교</option>                                                                                
					                                            </select>
					                                        </li>                                
					                                    </ul>  
					                                </div>					                            	                                                                                  
					                            </div>
						                	</c:if>
						            	</c:forEach>
						        	</c:when>
						    	</c:choose>
					    	</div>
					    </div>
	                    <!-- //sub_content -->
	                    
	                    <!-- Modal 1 -->
				        <div class="modal-overlay" id="modal1" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
				            <div class="modal-content modal-md" tabindex="-1">
				                <div class="modal-header">
				                    <h2 id="modal1Title">교수/튜터/조교 정보수정</h2>
				                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
				                </div>
				                <div class="modal-body">  
				                    <div class="board_top">
				                        <h3 class="board-title">기본 정보 수정</h3>                        
				                    </div>                 
				                    <div class="user-wrap">
				                        <div class="user-img">
				                            <div class="user-photo">
				                                <!--프로필 사진-->
				                                <img src="/lms_design_sample/webdoc/assets/img/common/photo_user_sample.png" alt="사진">
				                            </div>
				                        </div>
				                                             
				                        <!--table-type5-->
				                        <div class="table-wrap">
				                            <table class="table-type5">
				                                <colgroup>
				                                    <col class="width-25per" />
				                                    <col class="" />
				                                </colgroup>
				                                <tbody>
				                                    <tr>
				                                        <th><label for="name_label">이름</label></th>
				                                        <td>
				                                            <div class="form-row">
				                                                <input class="form-control width-100per" type="text" name="name" id="name_label" value="홍길동">
				                                            </div>
				                                        </td>
				                                    </tr>
				                                    <tr>
				                                        <th><label for="inputEmail">이메일</label></th>
				                                        <td>
				                                            <div class="form-row">
				                                                <input class="form-control width-100per" type="text" name="name" id="inputEmail" value="k202154774@knou.ac.kr">
				                                            </div>
				                                            <small class="note2">! 메일 주소는 공개 여부와 관계없이 공개됩니다.</small>
				                                        </td>
				                                    </tr>
				                                    <tr>
				                                        <th><label for="telLabel">전화번호</label></th>
				                                        <td>
				                                            <div class="form-row">
				                                                <input class="form-control width-100per" type="text" name="name" id="telLabel" value="02-2365-9854">
				                                            </div>
				                                        </td>
				                                    </tr>
				                                </tbody>
				                            </table>
				                        </div>
				                       
				                    </div>
				                    
				                    <div class="modal_btns">
				                        <button type="button" class="btn type1">저장</button>
				                        <button type="button" class="btn type2">닫기</button>
				                    </div>
				                </div>
				            </div>
				        </div>
				
				        <script src="/webdoc/assets/js/modal.js" defer></script>
	
	                    <!-- modal popup 보여주기 버튼(개발시 삭제) -->
	                    <div class="modal-btn-box">
	                        <button type="button" class="btn modal__btn" data-modal-open="modal1">교수/튜터/조교 정보수정</button>          
	                    </div>
	                    <!--// modal popup 보여주기 버튼(개발시 삭제) -->