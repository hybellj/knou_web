
/**
 * UI Switcher
 *
 * <input>(checkbox, radio)에 "switch" 클래스가 포함 필드에 Switch 적용
 */
function UiSwitcher() {
	let $fields = $('input[type=checkbox].switch,input[type=radio].switch').not('[switcher]');
	let switchNo = 1;
	let rnd = Math.random().toString(36).substring(2,5);

	$fields.each(function () {
		let $checkbox = $(this);
		$checkbox.attr("switcher","");
		$checkbox.hide();

		let id = $checkbox.attr("id");
		if (id === undefined || !id) {
			id = "uiswitch_" + rnd + (switchNo++);
			$checkbox.attr("id", id);
		}

		let $switcher = $(`<div id="sw_${id}" class="ui-switcher" aria-checked="${$checkbox.is(':checked')}"></div>`);
		let cssClass = $checkbox.attr('class');
		if (cssClass != undefined) {
			$switcher.addClass(cssClass);
		}

		if ($checkbox.attr('disabled') != undefined) {
			$switcher.addClass('disabled');
		}

		if ('radio' === $checkbox.attr('type')) {
			$switcher.attr('data-name', $checkbox.attr('name'));
		}

		let toggleSwitch = function(e) {
			if (e.target.type === undefined) {
				$checkbox.trigger(e.type);
			}
			$switcher.attr('aria-checked', $checkbox.is(':checked'));
			if ('radio' === $checkbox.attr('type')) {
				$('.ui-switcher[data-name=' + $checkbox.attr('name') + ']').not($switcher.get(0)).attr('aria-checked', false);
			}
		};

		$switcher.on('click', toggleSwitch);
		$checkbox.on('click', toggleSwitch);
		$switcher.insertBefore($checkbox);
    });


}


/**
 * Switch ON
 */
function UiSwitcherOn(id) {
	$("#"+id).prop("checked", true);
	$("#sw_"+id).attr('aria-checked', true);
}


/**
 * Switch OFF
 */
function UiSwitcherOff(id) {
	$("#"+id).prop("checked", false);
	$("#sw_"+id).attr('aria-checked', false);
}
