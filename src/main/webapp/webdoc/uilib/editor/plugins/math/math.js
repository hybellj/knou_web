
var MATH_EDITOR = {curEditor:null, dialog:null, url:"/webdoc/uilib/editor/externals/math/math.html"};
var pluginName = "math";

var pluginGenerator = function(editor) {
	var iconImg = '<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAARRJREFUOE+l0b0rxWEYxvHPyWQgSXkZxCDZLAYbpYgykEGsBiYpBhmEspBBsiKLBSVZDF6ymJAMpChMlOQP0FOP+sU5h8O9Ptf9fa7rulP+Oaks+63oxT7WM+kyAYrwiEs0oB4X6SCZAANYQAXO0Y+TXABrKEWIkXUyObjCJib+AijAK7qxjUYcxT5a0IZJbGEs6aAKsyhDE3ZxjXG0YxkH6MES5nGXDlCHWuzgASMxRuilD4sY/oyWroMN5KMzkb8wXiO4DO4OswFusYqpKGqO0SpjNzeYw3F4/+qgGM/owF4EhIV7DKEGK3hHdRIQiHk4jb+X4+WnEyYB0xjEG87Q9ZvlJCDcfhQlmMFTroDf6r/pPgCiPTQRbpvSBwAAAABJRU5ErkJggg==" alt="Equation"/>';
	var theme = editor.configuration["editor.ui.theme"];

	if (theme == "dark-gray") {
		iconImg = '<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAACXBIWXMAAAsTAAALEwEAmpwYAAAE72lUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgOS4wLWMwMDAgMTM3LmRhNGE3ZTUsIDIwMjIvMTEvMjctMDk6MzU6MDMgICAgICAgICI+IDxyZGY6UkRGIHhtbG5zOnJkZj0iaHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyI+IDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PSIiIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyIgeG1sbnM6ZGM9Imh0dHA6Ly9wdXJsLm9yZy9kYy9lbGVtZW50cy8xLjEvIiB4bWxuczpwaG90b3Nob3A9Imh0dHA6Ly9ucy5hZG9iZS5jb20vcGhvdG9zaG9wLzEuMC8iIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIiB4bWxuczpzdEV2dD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlRXZlbnQjIiB4bXA6Q3JlYXRvclRvb2w9IkFkb2JlIFBob3Rvc2hvcCAyNC4xIChXaW5kb3dzKSIgeG1wOkNyZWF0ZURhdGU9IjIwMjMtMDMtMjFUMTI6MjI6MjUrMDk6MDAiIHhtcDpNb2RpZnlEYXRlPSIyMDIzLTAzLTIxVDEyOjIzOjA0KzA5OjAwIiB4bXA6TWV0YWRhdGFEYXRlPSIyMDIzLTAzLTIxVDEyOjIzOjA0KzA5OjAwIiBkYzpmb3JtYXQ9ImltYWdlL3BuZyIgcGhvdG9zaG9wOkNvbG9yTW9kZT0iMyIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDozYzYwYzFhMy1mNjdlLTA3NGUtODBkOC1mMzU2NWI3MWIyZDciIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6M2M2MGMxYTMtZjY3ZS0wNzRlLTgwZDgtZjM1NjViNzFiMmQ3IiB4bXBNTTpPcmlnaW5hbERvY3VtZW50SUQ9InhtcC5kaWQ6M2M2MGMxYTMtZjY3ZS0wNzRlLTgwZDgtZjM1NjViNzFiMmQ3Ij4gPHhtcE1NOkhpc3Rvcnk+IDxyZGY6U2VxPiA8cmRmOmxpIHN0RXZ0OmFjdGlvbj0iY3JlYXRlZCIgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDozYzYwYzFhMy1mNjdlLTA3NGUtODBkOC1mMzU2NWI3MWIyZDciIHN0RXZ0OndoZW49IjIwMjMtMDMtMjFUMTI6MjI6MjUrMDk6MDAiIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkFkb2JlIFBob3Rvc2hvcCAyNC4xIChXaW5kb3dzKSIvPiA8L3JkZjpTZXE+IDwveG1wTU06SGlzdG9yeT4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz5l5ffBAAABJUlEQVQ4jaXTsUqcQRQF4G+joI2iMU06bWJnZWMhIYVISJEgWMUXSBfyDFYiFvoCWsk2FmErEawsTAIpU1gESxEbQbMg5KTYUTbJ//8Rc2CKuXPvnXPOnWkl8T941HC2iG2sNHZIUrXGklwlOU7yM8lMTV4tg2UECzjFSB2BwZr4PI5wiakmBXUMZvG5qbCpwQim8aXs53CDr5jAW5xgDb+ZOJlkN8lheugk2UgynGQpyVmSdjF1q+RXejCOLq7Lvos9vCm3b+L9XXbFaNpJPv4RG03yvTB7/q8xzvbphxfYxxC+4YPelCoZPC4aX/bFTpIcJHmW5FWS88JGEq3yF9YxgE/YwVNcVLD7C7cm/sA7vEbnvsX9Ddb0nu4TrN63GHcSHoxfql74Y8eEJgkAAAAASUVORK5CYII=" alt="Equation"/>';
	}

	var label = "수식";
	var title = "수식 입력";
	var lang = editor.configuration['editor.lang'];
	if (lang == "en") {
		label = "Equation";
		title = "Input Equation";
	}


    return {
        buttonDef: {
            label: label,
            iconSVG: iconImg,
            onClickFunc: function () {
            	MATH_EDITOR.curEditor = editor;
            	MATH_EDITOR.dialog = UiDialog("mathEditor", {
					title: title,
					width: 750,
					height: 500,
					url: MATH_EDITOR.url
				});
            }
        }
    };
};

SynapEditor.addPlugin(pluginName, pluginGenerator);

// 생성된 수식 이미지 수신
window.addEventListener('message', function(e) {
	if (e.data == "closeMath") {
		if (MATH_EDITOR.dialog != null) {
			MATH_EDITOR.dialog.close();
			MATH_EDITOR.curEditor = null;
		}
	}
	else if (e.data.indexOf("mathInput:") == 0) {
		if (MATH_EDITOR.curEditor != null) {
			MATH_EDITOR.curEditor.execCommand('insertDrawingObjectByURL', e.data.replace("mathInput:",""), 'Image');
			MATH_EDITOR.dialog.close();
			MATH_EDITOR.curEditor = null;
		}
	}
});