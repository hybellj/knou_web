<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      		uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_lnb.css" />

<script type="text/javascript">
	$(function(){
		userMenuList();
	});
	
	function userMenuList(){
		var reg = /[`~!@#$%^&*()_|+\-=?;:'"<>\{\}\[\]\\\/ ]/gim;

		var lnbOrgId = $("#lnbOrgId").val();
		var lnbMenuType = $("#lnbMenuType").val();
		var lnbAuthGrpCd = $("#lnbAuthGrpCd").val().replace(reg, "");
		
		var url = "<c:url value='/crs/selectCrsHomeMenulist.do'/>";
		var param = {
			orgId     : lnbOrgId
		  , menuType  : lnbMenuType
		  , authGrpCd : lnbAuthGrpCd
		}
		
		ajaxCall(url, param, function(data) {
			var html = "";
			var ulCnt = 0;
			
			$("#lnbDiv").empty();
			
			$.each(data.menuList, function(i, o){
				if(o.menuLvl == "1"){
					html += "<li><a href=\"javascript:moveMenu('" + o.menuUrl + "');\" ><i class='" + o.leftMenuImg + "'></i><span>" + o.menuNm + "</span></a></li>";
					
				} else  
				if(o.menuLvl == "2"){
					if(ulCnt > 0){
						html += "	</ul>";
						ulCnt = 0;
					}
					html += "<li class='sub-menu'>";
					if(!gfn_isNull(o.menuUrl)){
						html += "<a href=\"javascript:moveMenu('" + o.menuUrl + "');\"><i class='" + o.leftMenuImg + "'></i><span>" + o.menuNm + "</span></a>";
					} else {
						html += "<a href=\"javascript:;\"><i class='" + o.leftMenuImg + "'></i><span>" + o.menuNm + "</span></a>";
					}
				} else if(o.menuLvl == "3") {
					ulCnt++;
					if(ulCnt == 1){
						html += "	<ul>";
					}
					html += "		<li><a href=\"javascript:moveMenu('" + o.menuUrl + "');\">" + o.menuNm + "</a></li>";			
				}
			});
			
			$("#lnbDiv").html(html);
			
		}, function(xhr, status, error) {
			alert("에러가 발생했습니다!");
		});
	}
	
	function moveMenu(menuUrl){
		$("#moveForm").attr("action", menuUrl);
		$("#moveForm").submit();
	}
</script>


<div id="class_lnb" class="">
	<form id="moveForm" method="post">
	</form>
	
	<input type="hidden" id="lnbOrgId" value="${orgId}"/>
	<input type="hidden" id="lnbMenuType" value="${menuType}"/>
	<input type="hidden" id="lnbAuthGrpCd" value="${authGrpCd}"/>
	
    <!-- <button type="button" class="menu_btn" title="메뉴 버튼"><i class="chevron right icon"></i></button> -->
    <div class="straight">
        <button class="class_menu_btn"><i class="ion-navicon"></i></button>
    </div>
    <ul id="lnbDiv">
    </ul>
    <script>
        $(function() {
            /********** NAV 메뉴 **********/

            $('#class_lnb > ul > li').each(function() {
                if ($(this).find('ul').length == true) {
                    $(this).addClass('sub-menu');
                };
            });
            $('#class_lnb > ul > li').click(function() {
                if ($(this).hasClass("open") != true) {
                    $('#class_lnb > ul > li').removeClass("open");
                    $(this).addClass("open");
                } else {
                    $('#class_lnb > ul > li').removeClass("open");
                }
            });


            /********** admin menuPush **********/
            var overlay = $('.overlay');

            $('.menu_btn').click(function() {
                $(this).parents().find('#class_lnb').toggleClass('active');
                overlay.show();
            });
            // $('.class_menu_btn').click(function() {
            //     $(this).parents().find('#class_lnb').toggleClass('active');
            //     overlay.show();
            // });
        });
    </script>
</div>
<div class="overlay"></div>