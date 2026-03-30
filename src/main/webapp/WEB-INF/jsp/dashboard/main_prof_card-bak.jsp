<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="module" value="widget"/>
		<jsp:param name="style" value="dashboard"/>
	</jsp:include>

	<style>
	.course-card {
		height: 100%;
		overflow: auto;
	}
	</style>
</head>

<c:set var="userId" value="${userId}"/>
<c:set var="authrtGrpcd" value="${authrtGrpcd}"/>

<body class="home colorA "><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp">
            <jsp:param name="userId" value="${userId}" />
      	</jsp:include>
        <!-- //common header -->

        <!-- dashboard -->
        <main class="common">
            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
            	<div id="container" class="ui form">
            		<div class="grid-stack" id="grid-stack-first"></div>
		    	</div>
            </div>

            <!-- common footer -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
            <!-- //common footer -->

        </main>
        <!-- //dashboard-->
    </div>

	<script>
    let grid;
    let isResizing = false; // 전역 플래그 선언

    $(document).ready(function() {
	  grid = GridStack.init({
	   	    handle: '.xi-arrows m_handle, .star-handle',
	   	    column: 12, // 12 컬럼 유지
	   	    cellHeight: 124, // 💡 셀 높이를 125px로 설정 (1컬럼의 최소 높이/너비로 간주됨)
	   	    resizable: {
	   	        cellPixelWidth: 475.66
	   	    }
	   	    /* disableOneColumnMode: true, */
	  }, '#grid-stack-first');

   	  window.dispatchEvent(new Event('resize'));

   	  // 위젯 설정 조회
   	  widgetStngSelect();

   	  // 이벤트 바인딩
  	  grid.on('change', function(event, items) {
  		if (isResizing) {
  	        return;
  	    }
		// 위젯 설정 변경
  	    widgetStngChange(items, 1);
  	  });

      // 윈도우 크기 변경 시 실행
      $(window).on('resize', function() {
          gridColumnsModify();
      });

      function widgetStngSelect() {
    	    var url = "/dashboard/widgetStngSelect.do";
    	    var data = {
    	        userId: "${userId}",
    	        authrtGrpcd: "${authrtGrpcd}"
    	    };

    	    ajaxCall(url, data, function(res) {
    	        if (res.result > 0) {
    	            let rawData = res.dataList;
    	            if (typeof rawData === 'string') {
    	                try {
    	                    rawData = JSON.parse(rawData);
    	                } catch (e) {
    	                    console.error("데이터 파싱 중 오류 발생:", e);
    	                }
    	            }

    	            if (!Array.isArray(rawData)) {
    	                console.error("dataList가 배열 형식이 아닙니다.");
    	                return;
    	            }

    	            const items = rawData
    	                .filter(o => o.pvsnyn === 'Y') // 사용여부가 'Y'인 위젯만 화면에 그리도록 필터링
    	                .map(o => {
    	                    const courseCard = document.createElement('div');
    	                    courseCard.className = 'course-card';

    	                    const widgetId = o.widgetId;
    	                    const widgetNm = o.widgetNm;
    	                    const posX = o.posX;
    	                    const posY = o.posY;
    	                    const posW = o.posW;
    	                    const posH = o.posH;

    	                    const content = document.createElement('div');
    	                    content.className = 'card-content';
    	                    // 중요: 나중에 위치 저장 시 이름을 찾을 수 있도록 data-nm 속성 부여
    	                    content.setAttribute('data-nm', widgetNm);
    	                    courseCard.appendChild(content);

    	                    widgetContsCreate(widgetId, content, res);

    	                    const contentWrapper = document.createElement('div');
    	                    contentWrapper.className = 'grid-stack-item-content';
    	                    contentWrapper.appendChild(courseCard);

    	                    const gridItem = document.createElement('div');
    	                    gridItem.className = 'grid-stack-item';
    	                    // GridStack의 ID 매칭을 위해 속성 추가
    	                    gridItem.setAttribute('gs-id', widgetId);
    	                    gridItem.appendChild(contentWrapper);

    	                    return {
    	                        id: widgetId, // grid.save() 시 식별자로 사용
    	                        widgetId: widgetId,
    	                        widgetNm: widgetNm,
    	                        x: posX,
    	                        y: posY,
    	                        w: posW,
    	                        h: posH,
    	                        minW: 1,
    	                        maxW: 12,
    	                        el: gridItem
    	                    };
    	                });

    	            grid.removeAll();
    	            grid.load(items);

    	            setTimeout(() => {
    	                $('.slider_list li').not('.slick-initialized').slick({
    	                	infinite: false,
    	                    arrows: true,
    	                    dots: false,
    	                    autoplay: true,
    	                    vertical: true,
    	                    autoplaySpeed: 5000,
    	                    slidesToShow: 1,
    	                    slidesToScroll: 1,
    	                })

    	                $('.sche_list').not('.slick-initialized').slick({
    	                    infinite: true,
    	                    arrows: false,
    	                    dots: true,
    	                    autoplay: true,
    	                    vertical: true,
    	                    autoplaySpeed: 5000,
    	                    slidesToShow: 3,
    	                    slidesToScroll: 1,
    	                    responsive: [
    	                        {
    	                            breakpoint: 1024,
    	                            settings: {
    	                                dots: true,
    	                                slidesToShow: 3
    	                            }
    	                        },
    	                    ]
    	                });
    	            }, 50);
    	        } else {
    	            alert(res.message);
    	        }
    	    }, function(xhr, status, error) {
    	        alert("<spring:message code='fail.common.msg' />");
    	    }, true);
    	};

        function widgetStngChange(items) {
    	    const currentLayout = grid.save(true);
    	    const finalData = currentLayout.map(item => {
    	        const el = document.querySelector(`.grid-stack-item[gs-id="${item.id}"]`) ||
    	                   document.querySelector(`[gs-id="${item.id}"]`)?.closest('.grid-stack-item');

    	        const nmElement = el ? el.querySelector('[data-nm]') : null;
    	        const widgetNm = nmElement ? nmElement.getAttribute('data-nm') : '';

    	        return {
    	            widgetId: item.widgetId,
    	            widgetNm: item.widgetNm,
    	            posX: item.x,
    	            posY: item.y,
    	            posW: item.w,
    	            posH: item.h,
    	            userId: "${userId}",
    	            pvsnyn: 'Y'
    	        };
    	    });

    	    console.log("전체 레이아웃 데이터 확인:", finalData);

    	    var url = "/dashboard/widgetStngChange.do";
    	  	var data = {
			  			userId      : "${userId}",
			  			widgetUseId : "PROF",
			  			widgetId    : "PROF",
			    	  	widgetNm    : "PROF",
			    	  	orgId       : "LMSBASIC",
			    		widgetUserStngCts  : JSON.stringify(finalData)
    		};

	  	  	ajaxCall(url, data, function(res) {
	  	  		if (res.result > 0) {
	  				widgetStngSelect();
	  	  		} else {
	  	  			console.log("저장 실패");
	  	        }
	  		  }, function(xhr, status, error) {
	  		  	alert("<spring:message code='fail.common.msg' />");
	  		  }, true);
    	  };
        });

    	// 각 위젯별 내용 생성
   	  	function widgetContsCreate(widgetId, container, data) {
   	  	  switch (widgetId) {
	   	  	case 'card1': // Today
	   	     container.setAttribute('gs-id', 'CARD1');
	   	     container.setAttribute('data-nm', 'TODAY');

	   	     var lgnUsrCnt = (data && data.lgnUsrCnt) ? data.lgnUsrCnt : [];
	   	     // lgnUsrCnt = JSON.stringify(lgnUsrCnt)
			 var totStdntCnt = (data && data.totStdntCnt) ? data.totStdntCnt : [];
			 // totStdntCnt = JSON.stringify(totStdntCnt);
	   	     var sbjctList = (data && data.sbjctList) ? data.sbjctList : [];
	   	     var todayDate = new Date().toISOString().slice(0, 10).replace(/-/g, '.');

	   	     var html = `
			    <div class="box">
			        <div class="box_title">
			            <i class="xi-arrows m_handle" aria-label="위젯 이동" role="button"></i>
			            <h3 class="h3">TODAY</h3>
			        </div>
			        <div class="box_content">
			            <div class="today_line">
			                <div class="item today" style="padding: .6rem 2rem .6rem 2rem;">
			                    <div class="item_tit">Today</div>
			                    <div class="item_info">\${todayDate}</div>
			                </div>
			                <div class="item user" style="padding: .6rem 2rem .6rem 2rem;">
			                    <div class="item_tit">
			                        <a href="#0" class="btn">접속 <i class="xi-angle-down-min"></i></a>
			                        <div class="user-option-wrap">
			                            <div class="option_head">
			                                <p class="user_num">접속: 1</p>
			                                <button type="button" class="btn-close"><i class="icon-svg-close"></i></button>
			                            </div>
			                            <ul class="user_area"></ul>
			                        </div>
			                    </div>
			                    <div class="item_info">
			                        <span class="big">1</span>
			                        <span class="small">1</span>
			                    </div>
			                </div>
			            </div>
			            <div class="today_subject" style="padding:.4rem 2rem 0rem 2rem">
			                <ul class="slider_list">
				                <li>
		                            <div class="slide">
		                                <div class="item_tit">데이터베이스의 이해와 활용 1반</div>
		                                <div class="item_info">
		                                    <span class="big">37</span>
		                                    <span class="small">250</span>
		                                    <span class="txt">미달</span>
		                                </div>
		                            </div>

		                            <div class="slide">
		                                <div class="item_tit">경영수리와 통계1반</div>
		                                <div class="item_info">
		                                    <span class="big">22</span>
		                                    <span class="small">200</span>
		                                    <span class="txt">미달</span>
		                                </div>
		                            </div>

		                            <div class="slide">
		                                <div class="item_tit">데이터베이스의 이해와 활용 1반</div>
		                                <div class="item_info">
		                                    <span class="big">37</span>
		                                    <span class="small">250</span>
		                                    <span class="txt">미달</span>
		                                </div>
		                            </div>
	                        	</li>
			                </ul>
			            </div>
			        </div>
			    </div>
			`;
	   	     container.innerHTML = html;
	   	     break;

   	  		case 'card2': // 강의Q&A
   	  		  container.setAttribute('gs-id', 'CARD2');
 	  	 	  container.setAttribute('data-nm', '강의Q&A');
 	  	      container.innerHTML = `
 	  	    	<div class="box">
                  <div class="box_title">
                      <i class="xi-arrows m_handle" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                      <h3 class="h3">강의 Q&A <small class="msg_num">1</small></h3>
                      <div class="btn-wrap">
                          <a href="#0" class="btn_more" aria-label="더보기"><i class="xi-plus"></i></a>
                      </div>
                  </div>
                  <div class="box_content">
                      <ul class="dash_item_listA">
                          <li>
                              <div class="user">
                                 <span class="user_img"></span>
                              </div>
                              <a href="#0" class="item_txt">
                                  <p class="tit">과제 제출 언제까지 인가요?</p>
                                  <p class="desc">
                                      <span class="name">[대학원] 경영수리와 통계1반</span>
                                      <span class="date">2026.05.17</span>
                                  </p>
                              </a>
                              <div class="state">
                                  <label class="label check_no">미답변</label>
                              </div>
                          </li>
                          <li>
                              <div class="user">
                                 <span class="user_img"><img src="/webdoc/dm_assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진"></span>
                              </div>
                              <a href="#0" class="item_txt">
                                  <p class="tit">강의 내용 중에 이해가 안되는 부분이 있습니다.</p>
                                  <p class="desc">
                                      <span class="name">[대학원] 경영수리와 통계1반</span>
                                      <span class="date">2026.05.17</span>
                                  </p>
                              </a>
                              <div class="state">
                                  <label class="label check_reply">답변</label>
                              </div>
                          </li>
                          <li>
                              <div class="user">
                                 <span class="user_img"></span>
                              </div>
                              <a href="#0" class="item_txt">
                                  <p class="tit">과제 제출 언제까지 인가요?</p>
                                  <p class="desc">
                                      <span class="name">[평생교육] 광고와 이미지 마케팅</span>
                                      <span class="date">2026.05.17</span>
                                  </p>
                              </a>
                              <div class="state">
                                  <label class="label check_reply">답변</label>
                              </div>
                          </li>
                      </ul>
					</div>
              </div>
 	  	      `;
 	  	      break;

   	  		case 'card3': // 1:1상담
   	  		  container.setAttribute('gs-id', 'CARD3');
	  	 	  container.setAttribute('data-nm', '1:1상담');
 	  	      container.innerHTML = `
 	  	    	<div class="box">
                  <div class="box_title">
                      <i class="xi-arrows m_handle" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                      <h3 class="h3">1:1 상담 <small class="msg_num">2</small></h3>
                      <div class="btn-wrap">
                          <a href="#0" class="btn_more" aria-label="더보기"><i class="xi-plus"></i></a>
                      </div>
                  </div>
                  <div class="box_content">
                      <ul class="dash_item_listA">
                          <li>
                              <div class="user">
                                 <span class="user_img"><img src="/webdoc/dm_assets/img/common/photo_user_sample3.jpg" aria-hidden="true" alt="사진"></span>
                              </div>
                              <a href="#0" class="item_txt">
                                  <p class="tit">교수님~ 평가항목에 대해 궁금한게 있어요​</p>
                                  <p class="desc">
                                      <span class="name">[대학원] 경영수리와 통계1반</span>
                                      <span class="date">2026.05.17</span>
                                  </p>
                              </a>
                              <div class="state">
                                  <label class="label check_no">미답변</label>
                              </div>
                          </li>
                          <li>
                              <div class="user">
                                 <span class="user_img"></span>
                              </div>
                              <a href="#0" class="item_txt">
                                  <p class="tit">성적 처리 기준에 대해 질문이 있습니다.</p>
                                  <p class="desc">
                                      <span class="name">[대학원] 경영수리와 통계1반</span>
                                      <span class="date">2026.05.17</span>
                                  </p>
                              </a>
                              <div class="state">
                                  <label class="label check_reply">답변</label>
                              </div>
                          </li>
                          <li>
                              <div class="user">
                                 <span class="user_img"></span>
                              </div>
                              <a href="#0" class="item_txt">
                                  <p class="tit">이번 수업 정말 잘 들었습니다. 많은 도움이 되었어요</p>
                                  <p class="desc">
                                      <span class="name">[평생교육] New TEPS 실전 연습-기본편</span>
                                      <span class="date">2026.05.17</span>
                                  </p>
                              </a>
                              <div class="state">
                                  <label class="label check_no">미답변</label>
                              </div>
                          </li>
                      </ul>
                  </div>
              </div>
          </div>
 	  	      `;
 	  	      break;

   	  	    case 'card4': // 알림
   	  	      container.setAttribute('gs-id', 'CARD4');
	  	 	  container.setAttribute('data-nm', '알림');
   	  	      container.innerHTML = `
   	  	    	<div class="grid divided">
                  <div class="col-vertical">
                      <div class="box alrim">
                          <div class="box_title">
                              <i class="xi-arrows m_handle" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                              <h3 class="h3">알림</h3>
                              <nav class="tab-type1">
                                  <a href="#tab11" class="btn current"><span>PUSH</span><small class="msg_num" id="widgetPushCnt">0</small></a>
                                  <a href="#tab12" class="btn"><span>SMS</span><small class="msg_num" id="widgetSmsCnt">0</small></a>
                                  <a href="#tab13" class="btn"><span><spring:message code='msg.title.msg.shrtnt'/></span><small class="msg_num" id="widgetShrtntCnt">0</small></a>
                                  <a href="#tab14" class="btn"><span><spring:message code='msg.title.msg.alimTalk'/></span><small class="msg_num" id="widgetAlimtalkCnt">0</small></a>
                              </nav>

                              <div class="btn-wrap">
                                  <a href="#0" class="btn_more" aria-label="더보기"><i class="xi-plus"></i></a>
                              </div>
                          </div>
                          <div class="box_content">
                              <div id="tab11" class="tab-content" style="display: block;">
                                  <div class="alrim_item_area" id="widgetPushList">
                                      <div class="item_box push">
                                          <p class="item_txt" style="text-align:center; padding:20px 0; color:#999;"><spring:message code='msg.alim.label.loading'/></p>
                                      </div>
                                  </div>
                              </div>
                              <div id="tab12" class="tab-content" style="display: none;">
                                  <div class="alrim_item_area" id="widgetSmsList">
                                      <div class="item_box sms">
                                          <p class="item_txt" style="text-align:center; padding:20px 0; color:#999;"><spring:message code='msg.alim.label.loading'/></p>
                                      </div>
                                  </div>
                              </div>
                              <div id="tab13" class="tab-content" style="display: none;">
                                  <div class="alrim_item_area" id="widgetMsgList">
                                      <div class="item_box msg">
                                          <p class="item_txt" style="text-align:center; padding:20px 0; color:#999;"><spring:message code='msg.alim.label.loading'/></p>
                                      </div>
                                  </div>
                              </div>
                              <div id="tab14" class="tab-content" style="display: none;">
                                  <div class="alrim_item_area" id="widgetTalkList">
                                      <div class="item_box talk">
                                          <p class="item_txt" style="text-align:center; padding:20px 0; color:#999;"><spring:message code='msg.alim.label.loading'/></p>
                                      </div>
                                  </div>
                              </div>
                          </div>
                      </div>

   	  	      `;
   	  	      // 알림 위젯 데이터 로드
   	  	      widgetNotiList();
   	  	      break;

   	  	    case 'card5': // 공지사항
   	  	      container.setAttribute('gs-id', 'CARD5');
	  	 	  container.setAttribute('data-nm', '공지사항');
   	  	      container.innerHTML = `
   	  	    	<div class="box notice">
                  <div class="box_title">
                      <i class="xi-arrows m_handle" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                      <h3 class="h3">공지사항</h3>
                      <nav class="tab-type1">
                          <a href="#tab21" class="btn current"><span>전체</span></a>
                          <a href="#tab22" class="btn "><span>전체공지</span></a>
                          <a href="#tab23" class="btn "><span>과목공지</span></a>
                      </nav>
                      <div class="btn-wrap">
                          <a href="/bbs/bbsHome/bbsAtclListView.do?bbsId=LMSBASIC_NOTICE" class="btn_more" aria-label="더보기"><i class="xi-plus"></i></a>
                      </div>
                  </div>
                  <div class="box_content">
                      <div id="tab21" class="tab-content" style="display: block;">
                          <ul class="dash_item_listA">
                              <li>
                                  <div class="noti_label">
                                      <label class="labelA">전체</label>
                                  </div>
                                  <a href="#0" class="item_txt">
                                      <p class="tit">1학기 성적처리 기준 안내입니다.</p>
                                      <p class="desc">
                                          <span class="date">2026.05.17</span>
                                      </p>
                                  </a>
                                  <div class="state">
                                      <label class="label check_no">읽지않음</label>
                                  </div>
                              </li>
                              <li>
                                  <div class="noti_label">
                                      <label class="labelB">과목</label>
                                  </div>
                                  <a href="#0" class="item_txt">
                                      <p class="tit">성적 처리 기준에 대해 질문이 있습니다.</p>
                                      <p class="desc">
                                          <span class="name">[대학원] 경영수리와 통계1반</span>
                                          <span class="date">2026.05.17</span>
                                      </p>
                                  </a>
                                  <div class="state">
                                      <label class="label check_ok">읽음</label>
                                  </div>
                              </li>
                              <li>
                                  <div class="noti_label">
                                      <label class="labelB">과목</label>
                                  </div>
                                  <a href="#0" class="item_txt">
                                      <p class="tit">이번 수업 정말 잘 들었습니다. 많은 도움이 되었어요</p>
                                      <p class="desc">
                                          <span class="name">[평생교육] New TEPS 실전 연습-기본편</span>
                                          <span class="date">2026.05.17</span>
                                      </p>
                                  </a>
                                  <div class="state">
                                      <label class="label check_ok">읽음</label>
                                  </div>
                              </li>
                          </ul>
                      </div>

                      <div id="tab22" class="tab-content" style="display: none;">
                          <ul class="dash_item_listA">
                              <li>
                                  <div class="noti_label">
                                      <label class="labelA">전체</label>
                                  </div>
                                  <a href="#0" class="item_txt">
                                      <p class="tit">1학기 성적처리 기준 안내입니다.</p>
                                      <p class="desc">
                                          <span class="date">2026.05.17</span>
                                      </p>
                                  </a>
                                  <div class="state">
                                      <label class="label check_no">읽지않음</label>
                                  </div>
                              </li>
                              <li>
                                  <div class="noti_label">
                                      <label class="labelA">전체</label>
                                  </div>
                                  <a href="#0" class="item_txt">
                                      <p class="tit">1학기 성적처리 기준 안내입니다.</p>
                                      <p class="desc">
                                          <span class="date">2026.05.17</span>
                                      </p>
                                  </a>
                                  <div class="state">
                                      <label class="label check_ok">읽음</label>
                                  </div>
                              </li>
                              <li>
                                  <div class="noti_label">
                                      <label class="labelA">전체</label>
                                  </div>
                                  <a href="#0" class="item_txt">
                                      <p class="tit">1학기 성적처리 기준 안내입니다.</p>
                                      <p class="desc">
                                          <span class="date">2026.05.17</span>
                                      </p>
                                  </a>
                                  <div class="state">
                                      <label class="label check_ok">읽음</label>
                                  </div>
                              </li>
                          </ul>
                      </div>

                      <div id="tab23" class="tab-content" style="display: none;">
                          <ul class="dash_item_listA">
                              <li>
                                  <div class="noti_label">
                                      <label class="labelB">과목</label>
                                  </div>
                                  <a href="#0" class="item_txt">
                                      <p class="tit">이번 수업 정말 잘 들었습니다. 많은 도움이 되었어요</p>
                                      <p class="desc">
                                          <span class="name">[평생교육] New TEPS 실전 연습-기본편</span>
                                          <span class="date">2026.05.17</span>
                                      </p>
                                  </a>
                                  <div class="state">
                                      <label class="label check_ok">읽음</label>
                                  </div>
                              </li>
                              <li>
                                  <div class="noti_label">
                                      <label class="labelB">과목</label>
                                  </div>
                                  <a href="#0" class="item_txt">
                                      <p class="tit">성적 처리 기준에 대해 질문이 있습니다.</p>
                                      <p class="desc">
                                          <span class="name">[대학원] 경영수리와 통계1반</span>
                                          <span class="date">2026.05.17</span>
                                      </p>
                                  </a>
                                  <div class="state">
                                      <label class="label check_ok">읽음</label>
                                  </div>
                              </li>
                              <li>
                                  <div class="noti_label">
                                      <label class="labelB">과목</label>
                                  </div>
                                  <a href="#0" class="item_txt">
                                      <p class="tit">이번 수업 정말 잘 들었습니다. 많은 도움이 되었어요</p>
                                      <p class="desc">
                                          <span class="name">[평생교육] New TEPS 실전 연습-기본편</span>
                                          <span class="date">2026.05.17</span>
                                      </p>
                                  </a>
                                  <div class="state">
                                      <label class="label check_ok">읽음</label>
                                  </div>
                              </li>
                          </ul>
                      </div>

                  </div>
              </div>

   	  	      `;
   	  	      break;

   	  	    case 'card6': // 학사일정
   	  	      container.setAttribute('gs-id', 'CARD6');
	  	 	  container.setAttribute('data-nm', '이달의 학사일정');
	  	      container.innerHTML = `
	  	    	<div class="box">
                  <div class="box_title padding-right-0">
                      <i class="xi-arrows m_handle" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                      <h3 class="h3"><em>이달의</em> 학사일정</h3>
                      <div class="btn-wrap">
                          <div class="schedule-head">
                              <a class="btn-prev" href="#" aria-label="이전달"><i class="xi-angle-left-min"></i></a>
                              <div class="this-month">3<small>월</small></div>
                              <a class="btn-next" href="#" aria-label="다음달"><i class="xi-angle-right-min"></i></a>
                          </div>
                      </div>
                  </div>
                  <div class="box_content">
                      <ul class="sche_list">
                          <li>
                              <div class="item_box">
                                  <div class="s_date">03.04 ~ 03.10</div>
                                  <div class="s_txt">
                                      <p class="tit">중간고사 시험문제 등록/출제/검수</p>
                                      <p class="desc">[대학원] 데이터베이스의 이해와 활용</p>
                                  </div>
                              </div>
                          </li>
                          <li>
                              <div class="item_box">
                                  <div class="s_date">03.05 ~ 03.12</div>
                                  <div class="s_txt">
                                      <p class="tit">결시원 승인</p>
                                      <p class="desc">[대학원] 경영수리와 통계1반</p>
                                  </div>
                              </div>
                          </li>
                          <li>
                              <div class="item_box">
                                  <div class="s_date">03.12 ~ 03.15</div>
                                  <div class="s_txt">
                                      <p class="tit">2026학년도 1학기 중간고사</p>
                                      <p class="desc">[대학원] 경영수리와 통계1반</p>
                                  </div>
                              </div>
                          </li>
                          <li>
                              <div class="item_box">
                                  <div class="s_date">03.18 ~ 03.22</div>
                                  <div class="s_txt">
                                      <p class="tit">시험문제 등록/출제/검수</p>
                                      <p class="desc">[대학원] 데이터베이스의 이해와 활용</p>
                                  </div>
                              </div>
                          </li>
                      </ul>
                  </div>
               </div>
            </div>
	  	    `;
	  	    break;

   	  	    case 'card7': // 강의과목
   	  	      container.setAttribute('gs-id', 'CARD7');
	  	 	  container.setAttribute('data-nm', '강의과목');
   	  	      container.innerHTML = `
   	  	    	<!-- 강의과목 -->
                  <div class="box span-2 subject">
                      <div class="box_title">
                          <i class="xi-arrows m_handle" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                          <h3 class="h3">강의과목</h3>
                          <!--tab-type1-->
                          <nav class="tab-type1">
                              <a href="#tab31" class="btn current"><span>전체</span></a>
                              <a href="#tab32" class="btn "><span>대학원</span></a>
                              <a href="#tab33" class="btn "><span>학위과정</span></a>
                              <a href="#tab34" class="btn "><span>평생교육</span></a>
                          </nav>

                          <div class="btn-wrap">
                              <select class="form-select" style="font-weight:600">
                                  <option value="2026년 2학기">2026년 2학기</option>
                                  <option value="2026년 1학기">2026년 1학기</option>
                              </select>
                              <a href="#0" class="btn_list_type btn_list" aria-label="리스트형 보기"><i class="icon-svg-list" aria-hidden="true"></i></a>
                              <a href="#0" class="btn_list_type btn_card on" aria-label="카드형 보기"><i class="icon-svg-grid" aria-hidden="true"></i></a><!-- 버튼 선택 on 클래스 추가 -->
                          </div>
                      </div>

                      <div id="tab31" class="tab-content" style="display: block;">
                      	<div class="box_content view_card">
                          <ul class="lecture_list">
                              <li>
                                  <div class="card_item">
                                      <div class="item_header">
                                          <div class="title_area">
                                              <p class="info_detail">
                                                  <span class="label uniA">대학원</span>
                                                  <span class="info_txt">수강 50명</span>
                                                  <span class="info_txt">튜터 김하늘</span>
                                                  <span class="info_txt">3학점</span>
                                              </p>

                                              <p class="tit">
                                              	<a href="/subject.do?sbjctId=SBJCT20260001">자바 프로그래밍 초급</a>
                                              </p>
                                          </div>
                                      </div>
                                      <div class="extra">
                                          <div class="info">
                                              <p class="point">
                                                  <span class="tit">중간고사:</span>
                                                  <span>2026.04.26 16:00</span>
                                              </p>
                                              <p class="desc">
                                                  <span class="tit">시간:</span>
                                                  <span>40분</span>
                                              </p>
                                          </div>
                                          <div class="info">
                                              <p class="point">
                                                  <span class="tit">기말고사:</span>
                                                  <span>2026.06.07 17:00</span>
                                              </p>
                                              <p class="desc">
                                                  <span class="tit">시간:</span>
                                                  <span>40분</span>
                                              </p>
                                          </div>
                                          <div class="my_prog_rate">
                                              <div class="progress">
                                                  <div class="bar blue_type" style="width: 40%;"></div>
                                              </div>
                                              <span class="prog_num">평균 진도율</span><span class="meta">40%</span>
                                          </div>
                                      </div>
                                      <div class="bottom_button">
                                         <div class="card_btns">
                                              <a href="#0">공지<span>2</span></a>
                                              <a href="#0">Q&A<span>2</span></a>
                                              <a href="#0">1 : 1<span>2</span></a>
                                              <a href="#0">과제<span>2</span></a>
                                              <a href="#0">토론<span>2</span></a>
                                              <a href="#0">세미나<span>2</span></a>
                                              <a href="#0">퀴즈<span>2</span></a>
                                              <a href="#0">설문<span>2</span></a>
                                              <a href="#0">시험<span>2</span></a>
                                          </div>
                                      </div>
                                  </div>
                              </li>
                              <li>
                              <div class="card_item">
                                  <div class="item_header">
                                      <div class="title_area">
                                          <p class="info_detail">
                                              <span class="label uniA">대학원</span>
                                              <span class="info_txt">수강 50명</span>
                                              <span class="info_txt">튜터 김하늘</span>
                                              <span class="info_txt">3학점</span>
                                          </p>
                                          <p class="tit"><a href="/subject/subject.do?sbjctId=SBJCT20260001">데이터베이스의 이해와 활용</a></p>
                                      </div>
                                  </div>
                                  <div class="extra">
                                      <div class="info">
                                          <p class="point">
                                              <span class="tit">중간고사:</span>
                                              <span>2026.04.26 16:00</span>
                                          </p>
                                          <p class="desc">
                                              <span class="tit">시간:</span>
                                              <span>40분</span>
                                          </p>
                                      </div>
                                      <div class="info">
                                          <p class="point">
                                              <span class="tit">기말고사:</span>
                                              <span>2026.06.07 17:00</span>
                                          </p>
                                          <p class="desc">
                                              <span class="tit">시간:</span>
                                              <span>40분</span>
                                          </p>
                                      </div>
                                      <div class="my_prog_rate">
                                          <div class="progress">
                                              <div class="bar blue_type" style="width: 40%;"></div>
                                          </div>
                                          <span class="prog_num">평균 진도율</span><span class="meta">40%</span>
                                      </div>
                                  </div>
                                  <div class="bottom_button">
                                     <div class="card_btns">
                                          <a href="#0">공지<span>2</span></a>
                                          <a href="#0">Q&A<span>2</span></a>
                                          <a href="#0">1 : 1<span>2</span></a>
                                          <a href="#0">과제<span>2</span></a>
                                          <a href="#0">토론<span>2</span></a>
                                          <a href="#0">세미나<span>2</span></a>
                                          <a href="#0">퀴즈<span>2</span></a>
                                          <a href="#0">설문<span>2</span></a>
                                          <a href="#0">시험<span>2</span></a>
                                      </div>
                                  </div>
                              </div>
                          </li>
                          <li>
                              <div class="card_item">
                                  <div class="item_header">
                                      <div class="title_area">
                                          <p class="info_detail">
                                              <span class="label uniB">평생교육</span>
                                              <span class="info_txt">수강 200명</span>
                                              <span class="info_txt">튜터 한여름</span>
                                              <span class="info_txt">3학점</span>
                                          </p>
                                          <p class="tit"><a href="#0">간결하고 힘찬 영어 쓰기 - 품격 있는 영작</a></p>
                                      </div>
                                  </div>
                                  <div class="extra">
                                      <div class="info">
                                          <p class="point">
                                              <span class="tit">과제제출:</span>
                                              <span>2026.04.26 16:00</span>
                                          </p>

                                      </div>
                                      <div class="info">
                                          <p class="point">
                                              <span class="tit">기말고사:</span>
                                              <span>2026.06.07 17:00</span>
                                          </p>
                                          <p class="desc">
                                              <span class="tit">시간:</span>
                                              <span>40분</span>
                                          </p>
                                      </div>
                                      <div class="my_prog_rate">
                                          <div class="progress">
                                              <div class="bar blue_type" style="width: 40%;"></div>
                                          </div>
                                          <span class="prog_num">평균 진도율</span><span class="meta">40%</span>
                                      </div>
                                  </div>
                                  <div class="bottom_button">
                                     <div class="card_btns">
                                          <a href="#0">공지<span>2</span></a>
                                          <a href="#0">Q&A<span>2</span></a>
                                          <a href="#0">1 : 1<span>2</span></a>
                                          <a href="#0">과제<span>2</span></a>
                                          <a href="#0">설문<span>2</span></a>
                                          <a href="#0">시험<span>2</span></a>
                                      </div>
                                  </div>
                              </div>
                          </li>
                          <li>
                              <div class="card_item">
                                  <div class="item_header">
                                      <div class="title_area">
                                          <p class="info_detail">
                                              <span class="label uniB">평생교육</span>
                                              <span class="info_txt">수강 200명</span>
                                              <span class="info_txt">온라인</span>
                                              <span class="info_txt">3학점</span>
                                          </p>
                                          <p class="tit"><a href="#0">New TEPS 실전 연습-기본편</a></p>
                                      </div>
                                  </div>
                                  <div class="extra">
                                      <div class="info">
                                          <p class="point">
                                              <span class="tit">중간고사:</span>
                                              <span>2026.04.26 16:00</span>
                                          </p>
                                          <p class="desc">
                                              <span class="tit">시간:</span>
                                              <span>40분</span>
                                          </p>
                                      </div>
                                      <div class="info">
                                          <p class="point">
                                              <span class="tit">기말고사:</span>
                                              <span>2026.06.07 17:00</span>
                                          </p>
                                          <p class="desc">
                                              <span class="tit">시간:</span>
                                              <span>40분</span>
                                          </p>
                                      </div>
                                      <div class="my_prog_rate">
                                          <div class="progress">
                                              <div class="bar blue_type" style="width: 40%;"></div>
                                          </div>
                                          <span class="prog_num">평균 진도율</span><span class="meta">40%</span>
                                      </div>
                                  </div>
                                  <div class="bottom_button">
                                     <div class="card_btns">
                                          <a href="#0">공지<span>2</span></a>
                                          <a href="#0">Q&A<span>2</span></a>
                                          <a href="#0">1 : 1<span>2</span></a>
                                          <a href="#0">설문<span>2</span></a>
                                          <a href="#0">시험<span>2</span></a>
                                      </div>
                                  </div>
                              </div>
                          </li>
                          <li>
                              <div class="card_item">
                                  <div class="item_header">
                                      <div class="title_area">
                                          <p class="info_detail">
                                              <span class="label uniC">학위과정</span>
                                              <span class="info_txt">수강 50명</span>
                                              <span class="info_txt">튜터 김하늘</span>
                                              <span class="info_txt">3학점</span>
                                          </p>
                                          <p class="tit"><a href="#0">AI와 빅데이터 경영입문 2반</a></p>
                                      </div>
                                  </div>
                                  <div class="extra">
                                      <div class="info">
                                          <p class="point">
                                              <span class="tit">중간고사:</span>
                                              <span>2026.04.26 16:00</span>
                                          </p>
                                          <p class="desc">
                                              <span class="tit">시간:</span>
                                              <span>40분</span>
                                          </p>
                                      </div>
                                      <div class="info">
                                          <p class="point">
                                              <span class="tit">기말고사:</span>
                                              <span>2026.06.07 17:00</span>
                                          </p>
                                          <p class="desc">
                                              <span class="tit">시간:</span>
                                              <span>40분</span>
                                          </p>
                                      </div>
                                      <div class="my_prog_rate">
                                          <div class="progress">
                                              <div class="bar blue_type" style="width: 40%;"></div>
                                          </div>
                                          <span class="prog_num">평균 진도율</span><span class="meta">40%</span>
                                      </div>
                                  </div>
                                  <div class="bottom_button">
                                     <div class="card_btns">
                                          <a href="#0">공지<span>2</span></a>
                                          <a href="#0">Q&A<span>2</span></a>
                                          <a href="#0">1 : 1<span>2</span></a>
                                          <a href="#0">과제<span>2</span></a>
                                          <a href="#0">토론<span>2</span></a>
                                          <a href="#0">세미나<span>2</span></a>
                                          <a href="#0">퀴즈<span>2</span></a>
                                          <a href="#0">설문<span>2</span></a>
                                          <a href="#0">시험<span>2</span></a>
                                      </div>
                                  </div>
                              </div>
                          </li>
                          <li>
                              <div class="card_item">
                                  <div class="item_header">
                                      <div class="title_area">
                                          <p class="info_detail">
                                              <span class="label uniC">학위과정</span>
                                              <span class="info_txt">수강 50명</span>
                                              <span class="info_txt">튜터 김하늘</span>
                                              <span class="info_txt">3학점</span>
                                          </p>
                                          <p class="tit"><a href="#0">AI와 빅데이터 경영입문 2반</a></p>
                                      </div>
                                  </div>
                                  <div class="extra">
                                      <div class="info">
                                          <p class="point">
                                              <span class="tit">중간고사:</span>
                                              <span>2026.04.26 16:00</span>
                                          </p>
                                          <p class="desc">
                                              <span class="tit">시간:</span>
                                              <span>40분</span>
                                          </p>
                                      </div>
                                      <div class="info">
                                          <p class="point">
                                              <span class="tit">기말고사:</span>
                                              <span>2026.06.07 17:00</span>
                                          </p>
                                          <p class="desc">
                                              <span class="tit">시간:</span>
                                              <span>40분</span>
                                          </p>
                                      </div>
                                      <div class="my_prog_rate">
                                          <div class="progress">
                                              <div class="bar blue_type" style="width: 40%;"></div>
                                          </div>
                                          <span class="prog_num">평균 진도율</span><span class="meta">40%</span>
                                      </div>
                                  </div>
                                  <div class="bottom_button">
                                     <div class="card_btns">
                                          <a href="#0">공지<span>2</span></a>
                                          <a href="#0">Q&A<span>2</span></a>
                                          <a href="#0">1 : 1<span>2</span></a>
                                          <a href="#0">과제<span>2</span></a>
                                          <a href="#0">토론<span>2</span></a>
                                      </div>
                                  </div>
                              </div>
                          </li>
                          </ul>
                      </div>
                      <div class="box_content view_list" style="display: none;">
                          <!-- 강의목록 -->
                          <ul class="lecture_list2">
                              <li>
                                  <div class="card_item">
                                      <div class="item_header">
                                          <span class="label uniA">대학원</span>
                                          <div class="title_area">
                                              <p class="info_detail">
                                                  <span class="info_txt">수강 50명</span>
                                                  <span class="info_txt">튜터 김하늘</span>
                                                  <span class="info_txt">3학점</span>
                                              </p>
                                              <p class="tit"><a href="/subject/subject.do?sbjctId=SBJCT20260001">데이터베이스의 이해와 활용</a></p>
                                          </div>
                                          <div class="extra">
                                              <div class="my_prog_rate">
                                                  <span class="prog_num">평균 진도율</span><span class="meta">40%</span>
                                                  <div class="progress">
                                                      <div class="bar blue_type" style="width: 40%;"></div>
                                                  </div>
                                              </div>
                                              <div class="info">
                                                  <p class="point">
                                                      <span class="tit">중간고사:</span>
                                                      <span>2026.04.26 16:00</span>
                                                  </p>
                                                  <p class="desc">
                                                      <span class="tit">시간:</span>
                                                      <span>40분</span>
                                                  </p>
                                              </div>
                                              <div class="info">
                                                  <p class="point">
                                                      <span class="tit">기말고사:</span>
                                                      <span>2026.06.07 17:00</span>
                                                  </p>
                                                  <p class="desc">
                                                      <span class="tit">시간:</span>
                                                      <span>40분</span>
                                                  </p>
                                              </div>

                                          </div>
                                      </div>

                                      <div class="bottom_button">
                                         <div class="card_btns">
                                              <a href="#0">공지<span>2</span></a>
                                              <a href="#0">Q&A<span>2</span></a>
                                              <a href="#0">1 : 1<span>2</span></a>
                                              <a href="#0">과제<span>2</span></a>
                                              <a href="#0">토론<span>2</span></a>
                                              <a href="#0">세미나<span>2</span></a>
                                              <a href="#0">퀴즈<span>2</span></a>
                                              <a href="#0">설문<span>2</span></a>
                                              <a href="#0">시험<span>2</span></a>
                                          </div>
                                      </div>
                                  </div>
                              </li>
                              <li>
                              <div class="card_item">
                                  <div class="item_header">
                                      <span class="label uniA">대학원</span>
                                      <div class="title_area">
                                          <p class="info_detail">
                                              <span class="info_txt">수강 50명</span>
                                              <span class="info_txt">튜터 김하늘</span>
                                              <span class="info_txt">3학점</span>
                                          </p>
                                          <p class="tit"><a href="#0">AI와 빅데이터 경영입문 1반</a></p>
                                      </div>
                                      <div class="extra">
                                          <div class="my_prog_rate">
                                              <span class="prog_num">평균 진도율</span><span class="meta">40%</span>
                                              <div class="progress">
                                                  <div class="bar blue_type" style="width: 40%;"></div>
                                              </div>
                                          </div>
                                          <div class="info">
                                              <p class="point">
                                                  <span class="tit">중간고사:</span>
                                                  <span>2026.04.26 16:00</span>
                                              </p>
                                              <p class="desc">
                                                  <span class="tit">시간:</span>
                                                  <span>40분</span>
                                              </p>
                                          </div>
                                          <div class="info">
                                              <p class="point">
                                                  <span class="tit">기말고사:</span>
                                                  <span>2026.06.07 17:00</span>
                                              </p>
                                              <p class="desc">
                                                  <span class="tit">시간:</span>
                                                  <span>40분</span>
                                              </p>
                                          </div>

                                      </div>
                                  </div>

                                  <div class="bottom_button">
                                     <div class="card_btns">
                                          <a href="#0">공지<span>2</span></a>
                                          <a href="#0">Q&A<span>2</span></a>
                                          <a href="#0">1 : 1<span>2</span></a>
                                          <a href="#0">과제<span>2</span></a>
                                          <a href="#0">토론<span>2</span></a>
                                          <a href="#0">세미나<span>2</span></a>
                                          <a href="#0">퀴즈<span>2</span></a>
                                          <a href="#0">설문<span>2</span></a>
                                          <a href="#0">시험<span>2</span></a>
                                      </div>
                                  </div>
                              </div>
                          </li>
                          <li>
                              <div class="card_item">
                                  <div class="item_header">
                                      <span class="label uniB">평생<br>교육</span>
                                      <div class="title_area">
                                          <p class="info_detail">
                                              <span class="info_txt">수강 200명</span>
                                              <span class="info_txt">튜터 한여름</span>
                                              <span class="info_txt">3학점</span>
                                          </p>
                                          <p class="tit"><a href="#0">간결하고 힘찬 영어 쓰기 - 품격 있는 영작</a></p>
                                      </div>
                                      <div class="extra">
                                          <div class="my_prog_rate">
                                              <span class="prog_num">평균 진도율</span><span class="meta">40%</span>
                                              <div class="progress">
                                                  <div class="bar blue_type" style="width: 40%;"></div>
                                              </div>
                                          </div>
                                          <div class="info">
                                              <p class="point">
                                                  <span class="tit">과제제출:</span>
                                                  <span>2026.04.26 16:00</span>
                                              </p>
                                          </div>
                                          <div class="info">
                                              <p class="point">
                                                  <span class="tit">기말고사:</span>
                                                  <span>2026.06.07 17:00</span>
                                              </p>
                                              <p class="desc">
                                                  <span class="tit">시간:</span>
                                                  <span>40분</span>
                                              </p>
                                          </div>

                                      </div>
                                  </div>

                                  <div class="bottom_button">
                                     <div class="card_btns">
                                          <a href="#0">공지<span>2</span></a>
                                          <a href="#0">Q&A<span>2</span></a>
                                          <a href="#0">1 : 1<span>2</span></a>
                                          <a href="#0">과제<span>2</span></a>
                                          <a href="#0">설문<span>2</span></a>
                                          <a href="#0">시험<span>2</span></a>
                                      </div>
                                  </div>
                              </div>
                          </li>
                          <li>
                              <div class="card_item">
                                  <div class="item_header">
                                      <span class="label uniB">평생<br>교육</span>
                                      <div class="title_area">
                                          <p class="info_detail">
                                              <span class="info_txt">수강 200명</span>
                                              <span class="info_txt">온라인</span>
                                              <span class="info_txt">3학점</span>
                                          </p>
                                          <p class="tit"><a href="#0">New TEPS 실전 연습-기본편</a></p>
                                      </div>
                                      <div class="extra">
                                          <div class="my_prog_rate">
                                              <span class="prog_num">평균 진도율</span><span class="meta">40%</span>
                                              <div class="progress">
                                                  <div class="bar blue_type" style="width: 40%;"></div>
                                              </div>
                                          </div>
                                          <div class="info">
                                              <p class="point">
                                                  <span class="tit">중간고사:</span>
                                                  <span>2026.04.26 16:00</span>
                                              </p>
                                              <p class="desc">
                                                  <span class="tit">시간:</span>
                                                  <span>40분</span>
                                              </p>
                                          </div>
                                          <div class="info">
                                              <p class="point">
                                                  <span class="tit">기말고사:</span>
                                                  <span>2026.06.07 17:00</span>
                                              </p>
                                              <p class="desc">
                                                  <span class="tit">시간:</span>
                                                  <span>40분</span>
                                              </p>
                                          </div>

                                      </div>
                                  </div>

                                  <div class="bottom_button">
                                     <div class="card_btns">
                                          <a href="#0">공지<span>2</span></a>
                                          <a href="#0">Q&A<span>2</span></a>
                                          <a href="#0">1 : 1<span>2</span></a>
                                          <a href="#0">설문<span>2</span></a>
                                          <a href="#0">시험<span>2</span></a>
                                      </div>
                                  </div>
                              </div>
                          </li>
                          <li>
                              <div class="card_item">
                                  <div class="item_header">
                                      <span class="label uniC">학위<br>과정</span>
                                      <div class="title_area">
                                          <p class="info_detail">
                                              <span class="info_txt">수강 50명</span>
                                              <span class="info_txt">튜터 김하늘</span>
                                              <span class="info_txt">3학점</span>
                                          </p>
                                          <p class="tit"><a href="#0">AI와 빅데이터 경영입문 2반</a></p>
                                      </div>
                                      <div class="extra">
                                          <div class="my_prog_rate">
                                              <span class="prog_num">평균 진도율</span><span class="meta">40%</span>
                                              <div class="progress">
                                                  <div class="bar blue_type" style="width: 40%;"></div>
                                              </div>
                                          </div>
                                          <div class="info">
                                              <p class="point">
                                                  <span class="tit">중간고사:</span>
                                                  <span>2026.04.26 16:00</span>
                                              </p>
                                              <p class="desc">
                                                  <span class="tit">시간:</span>
                                                  <span>40분</span>
                                              </p>
                                          </div>
                                          <div class="info">
                                              <p class="point">
                                                  <span class="tit">기말고사:</span>
                                                  <span>2026.06.07 17:00</span>
                                              </p>
                                              <p class="desc">
                                                  <span class="tit">시간:</span>
                                                  <span>40분</span>
                                              </p>
                                          </div>

                                      </div>
                                  </div>

                                  <div class="bottom_button">
                                     <div class="card_btns">
                                          <a href="#0">공지<span>2</span></a>
                                          <a href="#0">Q&A<span>2</span></a>
                                          <a href="#0">1 : 1<span>2</span></a>
                                          <a href="#0">과제<span>2</span></a>
                                          <a href="#0">토론<span>2</span></a>
                                          <a href="#0">세미나<span>2</span></a>
                                          <a href="#0">퀴즈<span>2</span></a>
                                          <a href="#0">설문<span>2</span></a>
                                          <a href="#0">시험<span>2</span></a>
                                      </div>
                                  </div>
                              </div>
                          </li>
                          <li>
                              <div class="card_item">
                                  <div class="item_header">
                                      <span class="label uniC">학위<br>과정</span>
                                      <div class="title_area">
                                          <p class="info_detail">
                                              <span class="info_txt">수강 50명</span>
                                              <span class="info_txt">튜터 김하늘</span>
                                              <span class="info_txt">3학점</span>
                                          </p>
                                          <p class="tit"><a href="#0">AI와 빅데이터 경영입문 2반</a></p>
                                      </div>
                                      <div class="extra">
                                          <div class="my_prog_rate">
                                              <span class="prog_num">평균 진도율</span><span class="meta">40%</span>
                                              <div class="progress">
                                                  <div class="bar blue_type" style="width: 40%;"></div>
                                              </div>
                                          </div>
                                          <div class="info">
                                              <p class="point">
                                                  <span class="tit">중간고사:</span>
                                                  <span>2026.04.26 16:00</span>
                                              </p>
                                              <p class="desc">
                                                  <span class="tit">시간:</span>
                                                  <span>40분</span>
                                              </p>
                                          </div>
                                          <div class="info">
                                              <p class="point">
                                                  <span class="tit">기말고사:</span>
                                                  <span>2026.06.07 17:00</span>
                                              </p>
                                              <p class="desc">
                                                  <span class="tit">시간:</span>
                                                  <span>40분</span>
                                              </p>
                                          </div>

                                      </div>
                                  </div>

                                  <div class="bottom_button">
                                     <div class="card_btns">
                                          <a href="#0">공지<span>2</span></a>
                                          <a href="#0">Q&A<span>2</span></a>
                                          <a href="#0">1 : 1<span>2</span></a>
                                          <a href="#0">과제<span>2</span></a>
                                          <a href="#0">토론<span>2</span></a>
                                      </div>
                                  </div>
                              </div>
                          </li>
                          </ul>
                      </div>
					</div>
                      <div id="tab32" class="tab-content" style="display: none;">
                      	<div class="box_content view_card">
                          <div class="no_content">
                              <div class="no_text">
                                  <i class="icon-cont-none ico f170"></i>
                                  <span>등록된 강의가 없습니다.</span>
                              </div>
                          	</div>
                         </div>
                         <div class="box_content view_list" style="display: none;">
	                         <div class="no_content">
		                         <div class="no_text">
		                             <i class="icon-cont-none ico f170"></i>
		                             <span>등록된 강의가 없습니다.</span>
		                         </div>
		                     </div>
                         </div>
                      </div>

                      <div id="tab33" class="tab-content" style="display: none;">
                      	<div class="box_content view_card">
                          학위과정 강의리스트
                        </div>
                        <div class="box_content view_list" style="display: none;">
                          학위과정 강의리스트
                        </div>
                      </div>

                      <div id="tab34" class="tab-content" style="display: none;">
	                      <div class="box_content view_card">
	                          평생교육 강의리스트
	                      </div>
	                      <div class="box_content view_list" style="display: none;">
	                          평생교육 강의리스트
	                      </div>
                      </div>
                  </div>

              </div>
   	  	      `;
   	  	      break;

   	  	    default:
   	  	      container.innerHTML = '<div class="empty">내용 없음</div>';
   	  	  }
   	  	}

	  function snapToAllowed(grid, el, node, allowedW, allowedH) {
	    let closestW = allowedW.reduce((p, c) => Math.abs(c - node.w) < Math.abs(p - node.w) ? c : p);
	    let closestH = allowedH.reduce((p, c) => Math.abs(c - node.h) < Math.abs(p - node.h) ? c : p);
	    if (node.w !== closestW || node.h !== closestH) {
	      grid.update(el, { w: closestW, h: closestH, x: node.x, y: node.y });
	    }
	  }

	  // grid-stack 안에서 tab-type1 클릭 이벤트 위임
	  $(".grid-stack").on("click", ".tab-type1 a", function(e){
	     e.preventDefault();
	     const a = this;
	     const box = $(a).closest(".box");
	     const targetId = a.hash;
	     if(!targetId) return;

	     // 모든 탭 비활성화 & 컨텐츠 숨기기
	     $(box).find(".tab-type1 a").removeClass("current");
	     $(box).find(".tab-content").hide().removeClass("active");

	     // 클릭한 탭 활성화 & 컨텐츠 표시
	     $(a).addClass("current");
	     $(box).find(targetId).show().addClass("active");
	  });

	  $(".grid-stack").on("click", ".btn_list", function(e){
	      e.preventDefault();

	      const box = $(this).closest(".box");

	      // 버튼 상태
	      box.find(".btn_list_type").removeClass("on");
	      $(this).addClass("on");

	      // 리스트형 표시
	      box.find(".view_card").hide();
	      box.find(".view_list").show();
	  });

	  $(".grid-stack").on("click", ".btn_card", function(e){

	      e.preventDefault();

	      const box = $(this).closest(".box");
	      $(this).closest(".box");

	      box.find(".btn_list_type").removeClass("on");
	      $(this).addClass("on");

	      // 카드형 표시
	      box.find(".view_list").hide();
	      box.find(".view_card").show();
	  });

		function gridColumnsModify() {
		    isResizing = true;
		    let newColumn;
		    let shouldUpdateW = false; // w 값을 변경할지 여부 플래그
		    const width = window.innerWidth;

		    // 현재 로직 유지:
		    if (width > 1200) {
		        newColumn = 12;
		    } else if (width <= 1200 && width > 950) {
		        newColumn = 8;
		    }
		    // 950px 이하 (1개 카드로 보이도록)
		    else if (width <= 950 && width > 600) {
		        newColumn = 4;
		        shouldUpdateW = true; // 4컬럼 모드일 때 w=4
		    }
		    // 600px 이하 (모바일 대응)
		    else {
		        newColumn = 1;
		        shouldUpdateW = true; // 1컬럼 모드일 때 w=1
		    }

		    // GridStack의 현재 컬럼 수가 다를 경우에만 업데이트
		    if (grid.opts.column !== newColumn) {
		        grid.column(newColumn); // 1. 컬럼 수 변경

		        if (shouldUpdateW) {
		             // 2. 모든 위젯을 새로운 컬럼 수에 맞춰 꽉 채우도록 w 값을 변경
		            grid.getAll().forEach(el => {
		                const node = el.gridstackNode;
		                // 새로운 컬럼 수(4 또는 1)에 맞춰 위젯의 w를 강제 변경
		                grid.update(el, { w: newColumn });
		            });
		        }
		    }

		    setTimeout(() => {
		        isResizing = false;
		    }, 100);
		}

		// 알림 메시지
	var MSG_ALIM_UNREAD = '<spring:message code="msg.alim.label.unread"/>';
	var MSG_ALIM_READ = '<spring:message code="msg.alim.label.read"/>';
	var MSG_ALIM_EMPTY = '<spring:message code="common.content.not_found"/>';

	function widgetNotiList() {
    		    var param = { chnlCd: 'ALL', listCnt: 5 };

		    ajaxCall('/alimChnlListAjax.do', param, function(data) {
		        if (data.result > 0 && data.returnVO) {
		            // 개수 업데이트
		            if (data.returnVO.unreadCnt) {
		                widgetNotiCntUpdate(data.returnVO.unreadCnt);
		            }
		            // 목록 렌더링
		            widgetNotiListRender('PUSH', data.returnVO.pushList, '#widgetPushList', 'push');
		            widgetNotiListRender('SMS', data.returnVO.smsList, '#widgetSmsList', 'sms');
		            widgetNotiListRender('SHRTNT', data.returnVO.msgList, '#widgetMsgList', 'msg');
		            widgetNotiListRender('ALIM_TALK', data.returnVO.talkList, '#widgetTalkList', 'talk');
		        }
		    }, function(xhr, status, error) {
		        console.error('알림 위젯 목록 조회 실패');
		    }, false, {type: 'GET'});
		}

		function widgetNotiCntUpdate(data) {
		    $('#widgetPushCnt').text(data.pushCnt || 0);
		    $('#widgetSmsCnt').text(data.smsCnt || 0);
		    $('#widgetShrtntCnt').text(data.shrtntCnt || 0);
		    $('#widgetAlimtalkCnt').text(data.alimtalkCnt || 0);
		}

		function widgetNotiListRender(chnlCd, list, targetSelector, itemClass) {
		    var $target = $(targetSelector);
		    var html = '';

		    if (list && list.length > 0) {
		        $.each(list, function(idx, item) {
		            var name = item.sbjctnm || item.sndngnm || '';
		            var date = UiComm.formatDate(item.sndngDttm, "datetime");
		            var title = item.sndngTtl || '';
		            var readLabel = (item.readYn === 'N')
		                ? '<label class="label check_no">' + MSG_ALIM_UNREAD + '</label>'
		                : '<label class="label check_ok">' + MSG_ALIM_READ + '</label>';

		            html += '<div class="item_box ' + itemClass + '">';
		            html += '    <a href="#0" class="item_txt" data-sndng-id="' + (item.sndngId || '') + '" data-sndng-tycd="' + chnlCd + '">';
		            html += '        <p class="desc">';
		            html += '            <span class="name">' + UiComm.escapeHtml(name) + '</span>';
		            html += '            <span class="date">' + date + '</span>';
		            html += '        </p>';
		            html += '        <p class="tit">' + UiComm.escapeHtml(title) + '</p>';
		            html += '    </a>';
		            html += '    <div class="state">' + readLabel + '</div>';
		            html += '</div>';
		        });
		    } else {
		        html = '<div class="item_box ' + itemClass + '">';
		        html += '    <p class="item_txt" style="text-align:center; padding:20px 0; color:#999;">' + MSG_ALIM_EMPTY + '</p>';
		        html += '</div>';
		    }

		    $target.html(html);
		}

    </script>

</body>
</html>
