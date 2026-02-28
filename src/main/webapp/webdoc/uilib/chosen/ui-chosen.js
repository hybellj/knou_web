/**
 * Selectbox에 chosen 스타일 적용
 */
function UiChosen() {
	$("select").not(".chosen").addClass("chosen");
	
	let fields = $("select.chosen");
	let chosenNo = 1;
	let rnd = Math.random().toString(36).substring(2,5);
	
	fields.each(function() {
		let field = $(this);
		let id = field.attr("id");
		let placeholder = field.attr("placeholder");
		let dataPlaceholder = field.attr("data-placeholder");
		
		if (id === undefined || !id) {
			id = "select_" + rnd + (chosenNo++);
			field.attr("id", id);
		}
		
		if (dataPlaceholder === undefined && placeholder !== undefined) {
			field.attr("data-placeholder", placeholder);
		}
	
		field.chosen({disable_search: true});		
	});
	
}