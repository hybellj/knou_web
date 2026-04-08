<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<script type="text/javascript">
	window.closeDialog = function() {
		dialog.close();
	};

	// 페이지 이동
	function submitForm(action, kvArr){
		$("form[name='tempForm']").remove();

		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "tempForm");
		form.attr("action", action);

		for(var i=0; i<kvArr.length; i++){
			form.append($('<input/>', {type: 'hidden', name: kvArr[i].key, value: kvArr[i].val}));
		}

		form.appendTo("body");
		form.submit();
	};
</script>