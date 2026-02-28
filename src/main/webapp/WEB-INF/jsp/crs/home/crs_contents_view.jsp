<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
	
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
   	<link rel="stylesheet" type="text/css" href="/webdoc/player/plyr.css" />
   	<script type="text/javascript" src="/webdoc/js/iframe.js"></script>
   	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
   	
	<script type="text/javascript" src="/webdoc/player/plyr.js" crossorigin="anonymous"></script>
	<script type="text/javascript" src="/webdoc/player/player.js" crossorigin="anonymous"></script>
   	
   	<script type="text/javascript">
   		let curCntsId = "";
   		let curPlayer = null;
   		
	   	$(function() {
	   		// 콘텐츠 타이틀 클릭시 내용 보이기
	        $(".lesson.title").bind("click", function(){
	    	    let idx = $(this).attr("idx");
	    	   
	    	    if (idx === curCntsId) {
		    	    $("#cntsbox_"+idx).slideUp();
		    	    $(this).removeClass("active");
		    	    curCntsId = "";
		    	    curPlayer.pause();
		    	    curPlayer = null;
	    	    }
	    	    else {
	    	    	if (curCntsId !== "") {
	    	    		$("#cntsbox_"+curCntsId).slideUp();
	    	    		$("#cnts_"+curCntsId).removeClass("active");
	    	    		
	    	    		if ($("#cnts_"+curCntsId).attr("cntsgbn") == "VIDEO") {
	    	    			console.log(curPlayer);
		    		    	curPlayer.pause();
	    	    		}
		    	    }
		    	    
	    	    	if ($("#cntsbox_"+idx).css("display") == "block") {
	    	    		$("#cntsbox_"+idx).slideUp();
	    	    		$("#cnts_"+idx).removeClass("active");
	    	    		
	    	    		eval("player_"+idx).pause();
	    	    	}
	    	    	else {
				    	$("#cntsbox_"+idx).slideDown();
				    	$("#cnts_"+idx).addClass("active");
				    	curCntsId = idx;
				    	
				    	if ($("#cnts_"+idx).attr("cntsgbn") == "VIDEO") {
				    		curPlayer = eval("player_"+idx);
	    	    		} else {
				    		curPlayer = null;
				    	}
	    	    	}
	    	    }
	        });

	        $('#attendBase').bind("click", function(){
	            if ($('#attendBase').siblings(".content").css("display") == "none") {
	            	$('#attendBase').siblings(".content").slideDown();
	            	$('#attendBase').addClass("active");
	            }
	            else {
	            	$('#attendBase').siblings(".content").slideUp();
	            	$('#attendBase').removeClass("active");
	            }
	        });
	    });

	   	// 학습종료
	   	function closeLesson() {
	   		if (curPlayer != null) {
	   			curPlayer.player.stop();
	   		}
	   		
	   		window.parent.closeModal();
	   	}

	   	function popQna() {
	   	}

	   	function popMemo() {
	   	}
   	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<div id="wrap">
       <div class="info-item-box">
           <div>
               <h2 class="page-title">
                   ${lessonSchedule.lessonScheduleNm}
                   <div class="ui small label">${lessonTime.lessonTimeNm}</div><!-- 주차명 > 교시명 -->
               </h2>
               <p>
                   <small class="bullet_dot"><spring:message code="std.label.period" /> : ${lessonSchedule.lessonStartDt} ~ ${lessonSchedule.lessonEndDt}</small><!-- 기간 -->
                   <small class="bullet_dot">${lessonSchedule.lbnTm} <spring:message code="seminar.label.min" /></small><!-- 분 -->
                   <!-- <small class="bullet_dot"><spring:message code="lesson.label.stdy.prgr.y" /></small> 출결대상-->
               </p>
           </div>
           <div class="button-area">
               <a href="#0" onclick="closeLesson();return false;" class="ui basic button"><spring:message code="main.mainPopup.notice.exit" /></a><!-- 팝업종료-->
           </div>
       </div>

       <div class="ui divider"></div>	

        <!-- 
        <div class="button-area flex">
            <div class="fields mra">
                <div class="field">
                    <label class="hide">dropdown</label>
                    <select class="ui dropdown" id="taskTypeLabel">
                        <option value="바로가기">바로가기</option>
                        <option value="강의">강의</option>
                        <option value="동영상">동영상</option>
                    </select>
                </div>
            </div>
            <div class="ui buttons">
                <button type="button" class="ui basic button"><i class="angle left icon"></i> 이전 교시</button>
                <button type="button" class="ui basic button">다음 교시 <i class="angle right icon"></i></button>
            </div>
        </div> 
        -->

        <div class="ui form mt20">
		<c:forEach var="cnts" items="${lessonCntsList}" varStatus="status">
        	<div class="ui styled fluid accordion type2">
                <div id="cnts_${status.index}" idx="${status.index}" cntsgbn="${cnts.cntsGbn}" class="lesson title p0 ${status.index eq 0 ? 'active' : ''}" style="cursor:pointer;">
                    <ul class="each_lect_list">
                        <li>
                            <div class="each_lect_box" data-list-num="${cnts.lessonCntsOrder}">
                                <div class="each_lect_tit">
                                    <p>
                                        <span class="ui green small label"><spring:message code="common.label.lecture" /></span><!-- 강의 -->
                                        ${lessonSchedule.crsCreNm} >>> ${cnts.lessonCntsNm}
                                        <!-- <small class="bullet_dot"><spring:message code="lesson.label.stdy.method.seq" /></small> 순차학습-->
                                    </p>
                                    <p class="flex-item mt5">
                                        <small class="bullet_dot"><spring:message code="std.label.period" /> : ${lessonSchedule.lessonStartDt} ~ ${lessonSchedule.lessonEndDt}</small><!-- 기간 -->
                                    </p>
                                </div>
                                <div>
                                    <i class="dropdown icon"></i>
                                </div>
                            </div>
                        </li>                                                       
                    </ul>
                </div>
                
                <div id="cntsbox_${status.index}" class="content active" style="display:${status.index eq 0 ? 'block' : 'none'}">
					<c:choose>
						<c:when test="${cnts.cntsGbn eq 'VIDEO'}">
							<video id="player_${status.index}" 
								title="${cnts.lessonCntsNm}" 
								data-poster="" 
								lang="ko" 
								continue="false" 
								continueTime="" 
								speed="true" 
								speedPlaytime="false">
								<source src="${cnts.lessonCntsUrl} " type="video/mp4" size="720"/>
								
								<c:if test="${not empty cnts.pageInfo and cnts.pageInfo ne ''}">
									${cnts.pageInfo}
								</c:if>
								
								<!-- 확장 버튼 추가 (플레이어 상단) -->
								<!-- 
								<ext-btn>
									<btn-item>
										<text>Q&A</text>
										<onclick>popQna()</onclick>
									</btn-item>
									<btn-item>
										<text>MEMO</text>
										<onclick>popMemo()</onclick>
									</btn-item>
								</ext-btn>
								 -->
							</video>
							<script type="text/javascript">
								// 플레이어 초기화
								var player_${status.index} = UiMediaPlayer("player_${status.index}");
								<c:if test="${status.index eq 0}">
									curPlayer = player_${status.index};
									curCntsId = "${status.index}";
								</c:if>
							</script>
						</c:when>
						<c:otherwise>
						</c:otherwise>
					</c:choose>
                </div>
            </div>
			
		</c:forEach>
		</div>
        
        <div class="bottom-content">
            <a href="#0" onclick="closeLesson();return false;" class="ui basic button"><spring:message code="main.mainPopup.notice.exit" /></a><!-- 팝업종료 -->
        </div>
	</div>
	
</body>
</html>		