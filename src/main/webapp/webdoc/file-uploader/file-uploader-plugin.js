/**
 * jQuery Upload File Plugin
 * version: 4.0.10
 * Copyright (c) 2013 Ravishanker Kusuma
 * http://hayageek.com/
 * 
 * customized by Mediopia Tech (2023.02.24)
 */
(function ($) {
	if (getFileUploaderType() != 1) {
		return;
	}
	
	if($.fn.ajaxForm == undefined) {
    	$.ajax({async:false, type:'GET', dataType:'script', url:UPLOADER_SCRIPT_PATH+'/jquery-form/jquery.form.min.js' });
    }
    
    var feature = {};
    feature.fileapi = $("<input type='file'/>").get(0).files !== undefined;
    feature.formdata = window.FormData !== undefined;
    $.fn.uploadFile = function (options) {
        // This is the easiest way to have default options.
        var s = $.extend({
            // These are the defaults.
            url: "",
            method: "POST",
            enctype: "multipart/form-data",
            returnType: null,
            allowDuplicates: false,
            duplicateStrict: false,
            allowedTypes: "*",
            notAllowedTypes: "exe,com,bat,cmd,jsp,msi,html,htm,js,scr,asp,php,php3,php4,ocx",
            acceptFiles: "*",
            fileName: "file",
            formData: false,
            dynamicFormData:false,
            maxFileSize: -1,
            oneLimitSize: 1024,
            maxFileCount: -1,
            multiple: true,
            dragDrop: true,
            autoSubmit: false,
            showCancel: true,
            showAbort: false,
            showDone: false,
            showDelete: false,
            showError: true,
            showStatusAfterSuccess: true,
            showStatusAfterError: true,
            showFileCounter: false,
            fileCounterStyle: "). ",
            showFileSize: true,
            showProgress: false,
            nestedForms: true,
            showDownload: false,
            onLoad: function (obj) {},
            onSelect: function (files) { return true; },
            onSubmit: function (files, xhr) {},
            onSuccess: function (files, response, xhr, pd) {},
            onError: function (files, status, message, pd) {},
            onCancel: function (files, pd) {},
            onAbort: function (files, pd) {},
            downloadCallback: false,
            deleteCallback: false,
            afterUploadAll: false,
            serialize:true,
            sequential:true,
            sequentialCount:1,
            customProgressBar: false,
            abortButtonClass: "ajax-file-upload-abort",
            cancelButtonClass: "ajax-file-upload-cancel",
            dragDropContainerClass: "ajax-upload-dragdrop",
            dragDropHoverClass: "state-hover",
            errorClass: "ajax-file-upload-error",
            uploadButtonClass: "ajax-file-upload",
            dragDropStr: UiFileUploader_lang['dragDropStr'],
            uploadStr: UiFileUploader_lang['uploadStr'],
            abortStr: "Abort",
            cancelStr: "<i class='times icon'></i>",
            deletelStr: "Delete",
            doneStr: "Done",
            extErrorStr: UiFileUploader_lang['extErrorStr'],
            sizeErrorStr: UiFileUploader_lang['sizeErrorStr'],
            uploadErrorStr: "Upload is not allowed",
            maxFileCountErrorStr: UiFileUploader_lang['maxFileCountErrorStr'],
            uploadCountStr: UiFileUploader_lang['uploadCountStr'],
            downloadStr: "Download",
            customErrorKeyStr: "jquery-upload-file-error",
            allowTypeStr: UiFileUploader_lang['allowTypeStr'],
            notAllowTypeStr: UiFileUploader_lang['notAllowTypeStr'],
            allowSizeStr: UiFileUploader_lang['allowSizeStr'],
            allowFileCountStr: UiFileUploader_lang['allowFileCountStr'],
            allowTypeStr: UiFileUploader_lang['allowTypeStr'],
            statusBarWidth: "100%",
            dragdropWidth: "100%",
            uploadQueueOrder: 'bottom',
            headers: {},
            listSize: 1,
            path: "",
            uploadMessage: "",
            onTopMessage: true,
            oldCount: 0,
            oldSize: 0,
            oldFiles: "",
            useFileBox: false,
            varName: ""
        }, options);
        
        this.url = s.url;
        this.fileCounter = 1;
        this.selectedFiles = 0;
        this.selectedSizes = 0;
        this.totalSize = 0; //options.oldSize;
        this.totalCount = 0; //options.oldCount;
        this.oldFiles = options.oldFiles;
        this.progressSize = 0;
        this.uploadCount = 0;
        var formGroup = "ajax-file-upload-" + (new Date().getTime());
        this.formGroup = formGroup;
        this.errorLog = $("<div></div>"); //Writing errors
        this.responses = [];
        this.uploadComplete = false;
        this.existingFileNames = [];
        this.fileIds = [];
        this.fileSizes = [];
        this.isUpload = "false"; 
        this.maxFileCount = s.maxFileCount;
        this.maxFileSize = s.maxFileSize;
        this.upFiles = [];
        this.copyFiles = [];
        this.editBox = null;
        this.options = s;
        if(!feature.formdata) {
            s.dragDrop = false;
        }
        if(!feature.formdata || s.maxFileCount === 1) {
            s.multiple = false;
        }

		var oldFilesObj = null;
		if (options.oldFiles != "") {
			oldFilesObj = JSON.parse(options.oldFiles);
			this.totalCount = oldFilesObj.length;
			var totSize = 0;
			
			$.each(oldFilesObj, function(key, value) {
				totSize += Number(value.fileSize);
			});
			this.totalSize = totSize;
		}
        
        $(this).html("");
        var obj = this;
        var uploadLabel = $('<div>' + s.uploadStr + '</div>');

        $(uploadLabel).addClass(s.uploadButtonClass);
        this.uploadBtn = uploadLabel;

        // wait form ajax Form plugin and initialize
        (function checkAjaxFormLoaded() {
            if($.fn.ajaxForm) {
            	var containerHeight = (parseInt(s.listSize) * 31) + 0;
            	
            	obj.totalDiv = $("<div class='ajax-file-upload-total'></div>");
            	obj.totalSizeStr = $("<span>"+getSizeStr(obj.totalSize)+"</span>").appendTo(obj.totalDiv);
            	if (s.maxFileSize > 0) {
                	$("<span> / "+getSizeStr(s.maxFileSize)+"</span>").appendTo(obj.totalDiv);
                }
            	$("<span> ("+UiFileUploader_lang['totalStr']+" </span>").appendTo(obj.totalDiv);
            	obj.totalCountStr = $("<span>"+obj.totalCount+"</span>").appendTo(obj.totalDiv);
            	if (s.maxFileCount > 0) {
                	$("<span> / "+s.maxFileCount+"</span>").appendTo(obj.totalDiv);
                }
            	$("<span> "+UiFileUploader_lang['countStr']+")</span>").appendTo(obj.totalDiv);

                var dragDrop = $('<div class="' + s.dragDropContainerClass + '" title="'+s.dragDropStr+'"></div>');
                $(obj).append(dragDrop);
                $(dragDrop).append(uploadLabel);
                
                // 파일함에서 가져오기 모달박스
                if (s.useFileBox == true) {
                	if ($("#fileBoxForm1").length == 0) {
	                	$("body").append($("<form id='fileBoxForm1' name='fileBoxForm1'></form>"));
	                	
		                var boxModal = ""
		                	   + " <div class='modal fade in' id='fileBoxModal1' tabindex='-1' role='dialog' aria-labelledby='Modal' aria-hidden='false' style='display: none; padding-right: 17px;'>"
		                	   + "     <div class='modal-dialog modal-lg' role='document'>"
		                	   + "         <div class='modal-content'>"
		                	   + "             <div class='modal-header'>"
		                	   + "                 <button type='button' class='close' data-dismiss='modal' aria-label='Close'>"
		                	   + "                     <span aria-hidden='true'>&times;</span>"
		                	   + "                 </button>"
		                	   + "                 <h4 class='modal-title'>"+UiFileUploader_lang['fileBox']+"</h4>"
		                	   + "             </div>"
		                	   + "             <div class='modal-body'>"
		                	   + "                 <iframe src='' width='100%' id='fileBoxIfm1' name='fileBoxIfm1' title='fileBoxIfm1'></iframe>"
		                	   + "             </div>"
		                	   + "         </div>"
		                	   + "     </div>"
		                	   + " </div>";
		                $(obj).after($(boxModal));
		                
		                var fileBoxBtn = $("<button type='button' class='ajax-file-upload' style='margin-left:5px'>"+UiFileUploader_lang['addFromFileBox']+"</button>");
		                $(dragDrop).append(fileBoxBtn);
		                fileBoxBtn.bind('click', function() {
		                	CUR_FILE_UPLOADER = obj;
		            		$("#fileBoxForm1").attr("target", "fileBoxIfm1");
		                    $("#fileBoxForm1").attr("action", "/file/fileHome/popup/fileBoxCopy.do");
		                    $("#fileBoxForm1").submit();
		                	
		                    $('#fileBoxModal1').modal('show');
		                    $('#fileBoxIfm1').iFrameResize();
		                    window.closeFileBox = function() {
		                        $('.modal').modal('hide');
		                    };
		                });
                	}
                }
                
                
                if (s.onTopMessage) {
                	$(dragDrop).append($("<span class='select-file-message'>"+s.dragDropStr+"</span>"));
                }
                $(dragDrop).append(obj.totalDiv);
                setDragDropHandlers(obj, s, dragDrop);

                $(obj).append(obj.errorLog);
   				
    			obj.container = $("<div class='ajax-file-upload-container'></div>").insertAfter($(obj)).height(containerHeight);
    			obj.uploadMsgDiv = $("<div class='uploader-message'></div>").appendTo($(obj.container));
    			obj.uploadMsgDiv.html(s.uploadMessage.replace('\n','<br>'));
	            
    			obj.uploadBox = $("<div></div>");
    			obj.container.append(obj.uploadBox);
    			
	            // total progress bar
	            obj.totProgress = $("<div class='file-uploader-tot-progress'></div>").insertAfter($(obj)).height(containerHeight+30);
	            obj.totProgressBox = $("<div class='progress-box'></div>").appendTo(obj.totProgress);
	            obj.totProgressSt1 = $("<div style='display:table;width:100%'></div>").appendTo(obj.totProgressBox);
	            obj.totProgressSt1_div = $("<div class='ajax-file-upload-progress tot-pro-div'></div>").appendTo(obj.totProgressSt1);
	            obj.totProgressSt1_bar = $("<div class='ajax-file-upload-bar'></div>").appendTo(obj.totProgressSt1_div);
	            obj.totProgressSt1_text = $("<div class='tot-state-text'></div>").appendTo(obj.totProgressSt1);
	            obj.totProgressSt2 = $("<div style='display:table;width:100%;margin-top:4px'></div>").appendTo(obj.totProgressBox);
	            obj.totProgressSt2_file = $("<div class='tot-file-name'></div>").appendTo(obj.totProgressSt2);
	            obj.totProgressSt2_fileName = $("<div class='name-text'></div>").appendTo(obj.totProgressSt2_file);
	            obj.totProgressSt2_text = $("<div class='tot-file-text'></div>").appendTo(obj.totProgressSt2);
   				
	            obj.totProgressBox.css("margin-top", ((containerHeight-20)/2)+"px");
	            
   				if(s.dragDrop) {
   					setDragDropHandlers(obj, s, obj.container);
   				}
   				
                s.onLoad.call(this, obj);
                createCustomInputFile(obj, formGroup, s, uploadLabel);

               	obj.copyFileBox = $("<div class='file-uploader-copy-file'></div>");
               	obj.container.append(obj.copyFileBox);
                
                
                if (oldFilesObj != null && oldFilesObj.length > 0) {
                	obj.editBox = $("<div class='file-uploader-edit-box'></div>").insertAfter($(obj.container));
                	var fileSize = 0;
                	
                	$.each(oldFilesObj, function(key, value) {
                		fileSize = UiFileUploader_getSizeStr(Number(value.fileSize));
                		
        				$("<div class='old-file'><input id='oldid_"+value.fileId+"' type='checkbox' name='delFileIds' title='File "+(key+1)+"' "
                    			+ "value='"+value.fileId+"' style='display:none;'><span id='oldname_"+value.fileId+"' class='file-name'>"+value.fileNm+" ("+fileSize+")</span>"
                    			+ "<a href='#_' onclick='"+options.varName+".oldDelete(\""+value.fileId+"\", "+value.fileSize+");return false;' title='delete'>"
                    			+ "<span class='ajax-file-upload-red'><i class='times icon'></i></span></a></div>").appendTo(obj.editBox);
        			});
                }
                
            } 
            else {
            	window.setTimeout(checkAjaxFormLoaded, 10);
            }
        })();

        // start
	    this.startUpload = function () {
	    	this.isUpload = "true";
	    	$("form[formtype=upfile]").each(function(i,items) {
	   			if($(this).hasClass(obj.formGroup)) {
					mainQ.push($(this));
	   			}
	   		});

            if(mainQ.length >= 1 ) {
            	obj.uploadBtn.bind('click', false);
            	obj.totProgress.show();
	 			submitPendingUploads();
            }		   
        }

        this.getFileCount = function () {
            return obj.selectedFiles;

        }
        this.stopUpload = function () {
        	this.isUpload = "false";
            $("." + s.abortButtonClass).each(function (i, items) {
                if($(this).hasClass(obj.formGroup)) $(this).click();
            });
            $("." + s.cancelButtonClass).each(function (i, items) {
                if($(this).hasClass(obj.formGroup)) $(this).click();
            });
        }
        this.cancelAll = function () {
            $("." + s.cancelButtonClass).each(function (i, items) {
                if($(this).hasClass(obj.formGroup)) $(this).click();
            });
        }
        this.update = function (settings) {
            s = $.extend(s, settings);
        }
        this.reset = function (removeStatusBars) {
			obj.fileCounter = 1;
			obj.selectedFiles = 0;
			obj.errorLog.html("");
			
			if(removeStatusBars != false) {
				obj.container.html("");
			}
        }
		this.remove = function() {
			obj.container.html("");
			$(obj).remove();
		}
        
        this.createProgress = function (filename,filepath,filesize) {
            var pd = new createProgressDiv(this, s);
            pd.progressDiv.show();
            pd.progressbar.width('100%');

            var fileNameStr = "";
            if(s.showFileCounter)
            	fileNameStr = obj.fileCounter + s.fileCounterStyle + filename;
            else fileNameStr = filename;

            if(s.showFileSize)
				fileNameStr += " ("+getSizeStr(filesize)+")";

            pd.filename.html(fileNameStr);
            obj.fileCounter++;
            obj.selectedFiles++;

            if(s.showDownload) {
                pd.download.show();
                pd.download.click(function () {
                    if(s.downloadCallback) s.downloadCallback.call(obj, [filename], pd);
                });
            }
            if(s.showDelete) {
	            pd.del.show();
    	        pd.del.click(function () {
        	        pd.statusbar.hide().remove();
            	    var arr = [filename];
                	if(s.deleteCallback) s.deleteCallback.call(this, arr, pd);
	                obj.selectedFiles -= 1;
    	            updateFileCounter(s, obj);
        	    });
            }

            return pd;
        }

        this.getResponses = function () {
            return this.responses;
        }
        
        // add old files
        this.addOldFiles = function(files) {
        	if (files != "") {
    			var oldFilesObj = JSON.parse(files);
    			obj.totalCount += oldFilesObj.length;
    			var totSize = 0;
    			
    			$.each(oldFilesObj, function(key, value) {
    				totSize += Number(value.fileSize);
    			});
    			obj.totalSize += totSize;
    			
    			if (obj.editBox == null) {
    				obj.editBox = $("<div class='file-uploader-edit-box'></div>").insertAfter($(obj.container));
    			}
    			
            	$.each(oldFilesObj, function(key, value) {
            		let fileSize = UiFileUploader_getSizeStr(Number(value.fileSize));
            		let fileDiv = $("<div class='old-file'><input id='oldid_"+value.fileId+"' type='checkbox' name='delFileIds' title='File "+(key+1)+"' "
                			+ "value='"+value.fileId+"' style='display:none;'><span id='oldname_"+value.fileId+"' class='file-name'>"+value.fileNm+" ("+fileSize+")</span>"
                			+ "<a href='#_' onclick='"+options.varName+".oldDelete(\""+value.fileId+"\", "+value.fileSize+");return false;' title='delete'>"
                			+ "<span class='ajax-file-upload-red'><i class='times icon'></i></span></a></div>");
                	
            		obj.editBox.append(fileDiv);
    			});
            	
            	obj.totalDiv.html("");
            	obj.totalSizeStr = $("<span>"+getSizeStr(obj.totalSize)+"</span>").appendTo(obj.totalDiv);
            	if (s.maxFileSize > 0) {
                	$("<span> / "+getSizeStr(s.maxFileSize)+"</span>").appendTo(obj.totalDiv);
                }
            	$("<span> ("+UiFileUploader_lang['totalStr']+" </span>").appendTo(obj.totalDiv);
            	obj.totalCountStr = $("<span>"+obj.totalCount+"</span>").appendTo(obj.totalDiv);
            	if (s.maxFileCount > 0) {
                	$("<span> / "+s.maxFileCount+"</span>").appendTo(obj.totalDiv);
                }
            	$("<span> "+UiFileUploader_lang['countStr']+")</span>").appendTo(obj.totalDiv);
    		}
        }
        
        var mainQ=[];
        var progressQ=[]
        var running = false;
        function submitPendingUploads() {
			if(running) return;
			running = true;
            (function checkPendingForms() {
            	//if not sequential upload all files
            	if(!s.sequential) s.sequentialCount=99999;

				if(mainQ.length == 0 &&   progressQ.length == 0) {
					if(s.afterUploadAll) s.afterUploadAll(obj);
					running= false;
				}
				else {
					if( progressQ.length < s.sequentialCount) {
						var frm = mainQ.shift();
						if(frm != undefined) {
			    	    	progressQ.push(frm);
			    	    	//Remove the class group.
			    	    	frm.removeClass(obj.formGroup);
	    					frm.submit();
    					}
					}
					window.setTimeout(checkPendingForms, 100);
				}
            })();
        }

        function setDragDropHandlers(obj, s, ddObj) {
            ddObj.on('dragenter', function (e) {
                e.stopPropagation();
                e.preventDefault();
                $(obj).parent().addClass(s.dragDropHoverClass);
            });
            ddObj.on('dragover', function (e) {
                e.stopPropagation();
                e.preventDefault();
                var that = $(obj).parent();
                if (that.hasClass(s.dragDropContainerClass) && !that.hasClass(s.dragDropHoverClass)) {
                    that.addClass(s.dragDropHoverClass);
                }
            });
            ddObj.on('drop', function (e) {
                e.preventDefault();
                $(this).removeClass(s.dragDropHoverClass);
                obj.errorLog.html("");
                var files = e.originalEvent.dataTransfer.files;
                if(s.onSelect(files) == false) return;
                serializeAndUploadFiles(s, obj, files);
            });
            ddObj.on('dragleave', function (e) {
            	$(obj).parent().removeClass(s.dragDropHoverClass);
            });

            $(document).on('dragenter', function (e) {
                e.stopPropagation();
                e.preventDefault();
            });
            $(document).on('dragover', function (e) {
                e.stopPropagation();
                e.preventDefault();
                var that = $(obj).parent();
                if (!that.hasClass(s.dragDropContainerClass)) {
                    that.removeClass(s.dragDropHoverClass);
                }
            });
            $(document).on('drop', function (e) {
                e.stopPropagation();
                e.preventDefault();
                $(obj).parent().removeClass(s.dragDropHoverClass);
            });

        }

        function getSizeStr(size) {
            var sizeStr = "";
            var sizeKB = size / 1024;
            if(parseInt(sizeKB) > 1024) {
                var sizeMB = sizeKB / 1024;
                sizeStr = sizeMB.toFixed(1) + "MB";
            } else {
                sizeStr = sizeKB.toFixed() + "KB";
            }
            return sizeStr;
        }

        function serializeData(extraData) {
            var serialized = [];
            if(jQuery.type(extraData) == "string") {
                serialized = extraData.split('&');
            } else {
                serialized = $.param(extraData).split('&');
            }
            var len = serialized.length;
            var result = [];
            var i, part;
            for(i = 0; i < len; i++) {
                serialized[i] = serialized[i].replace(/\+/g, ' ');
                part = serialized[i].split('=');
                result.push([decodeURIComponent(part[0]), decodeURIComponent(part[1])]);
            }
            return result;
        }

        // add file
		function serializeAndUploadFiles(s, obj, files) {
			var errMsg = "";
			var errorCode = "";
			var errorValue = "";
			
			if (files.length > 0) {
				obj.uploadMsgDiv.hide();
			}
			
			for(var i = 0; i < files.length; i++) {
				if(!s.allowDuplicates && isFileDuplicate(obj, files[i].name)) {
					continue;
				}
				else if(!isFileTypeAllowed(obj, s, files[i].name)) {
					if(s.showError) {
						errorCode = "allowFileType";
						errorValue = s.allowedTypes;
					}
					continue;
				}
				else if(!isNotFileTypeAllowed(obj, s, files[i].name)) {
					if(s.showError) {
						errorCode = "fileType";
						errorValue = s.notAllowedTypes;
					}
					continue;
				}
				else if(s.maxFileSize > 0 && (obj.totalSize + files[i].size) > s.maxFileSize) {
					if(s.showError) {
						errorCode = "limitSize";
						errorValue = getSizeStr(s.maxFileSize);
					}                        
					continue;
				}
				else if(files[i].size > s.oneLimitSize) {
					if(s.showError) {
						errorCode = "oneFileLimitSize";
						errorValue = getSizeStr(s.oneLimitSize);
					}                        
					continue;
				}
				else if(s.maxFileCount > 0 && (obj.totalCount) >= s.maxFileCount) {
					if(s.showError) {
						errorCode = "limitCount";
						errorValue = s.maxFileCount;
					}
					continue;
				}

				obj.selectedFiles++;
				obj.selectedSizes += files[i].size;
				obj.totalSize += files[i].size;
				obj.totalCount++;
				
				files[i].fileId = getNewFileId();
				obj.fileIds.push(files[i].fileId);
				obj.existingFileNames.push(files[i].name);
				obj.fileSizes.push(files[i].size);
				obj.upFiles.push(files[i]);
				
				var ts = s;
				var fd = new FormData();
				var fileName = s.fileName.replace("[]", "");
				fd.append(fileName, files[i]);
				var extraData = s.formData;
				if(extraData) {
					var sData = serializeData(extraData);
					for(var j = 0; j < sData.length; j++) {
						if(sData[j]) {
							fd.append(sData[j][0], sData[j][1]);
						}
					}
				}
				ts.fileData = fd;

				var pd = new createProgressDiv(obj, s);
				var fileNameStr = "";
				if(s.showFileCounter) fileNameStr = obj.fileCounter + s.fileCounterStyle + files[i].name
				else fileNameStr = files[i].name;

				if(s.showFileSize) fileNameStr += " <span class='ajax-file-upload-filesize'>("+getSizeStr(files[i].size)+")</span>";

				pd.filename.html(fileNameStr);

				var url = addUrl(s.url, "path", s.path);
				url = addUrl(url, "fileId", files[i].fileId);
				
				var form = $("<form style='display:block;position:absolute;left:150px;' formtype='upfile' class='" + obj.formGroup + "' method='" + s.method + "' action='" +
						url + "' enctype='" + s.enctype + "'></form>");
				
				form.appendTo('body');
				var fileArray = [];
				fileArray.push(files[i].name);

				ajaxFormSubmit(form, ts, pd, fileArray, obj, files[i]);
				obj.fileCounter++;

				obj.totalSizeStr.html(getSizeStr(obj.totalSize));
				obj.totalCountStr.html(obj.totalCount);
			}

			// display error message
			if (errorCode != "") {
				UiFileUploader_displayMessage(errorCode, errorValue);
			}
		}

        function isFileTypeAllowed(obj, s, fileName) {
            var fileExtensions = s.allowedTypes.toLowerCase().split(/[\s,]+/g);
            var ext = fileName.split('.').pop().toLowerCase();
            if(s.allowedTypes != "*" && jQuery.inArray(ext, fileExtensions) < 0) {
                return false;
            }
            return true;
        }
        
        function isNotFileTypeAllowed(obj, s, fileName) {
            var fileExtensions = s.notAllowedTypes.toLowerCase().split(/[\s,]+/g);
            var ext = fileName.split('.').pop().toLowerCase();
            if(s.notAllowedTypes != "" && jQuery.inArray(ext, fileExtensions) > -1) {
                return false;
            }
            return true;
        }

        function isFileDuplicate(obj, filename) {
            var duplicate = false;
            if (obj.existingFileNames.length) {
                for (var x=0; x<obj.existingFileNames.length; x++) {
                    if (obj.existingFileNames[x] == filename
                        || s.duplicateStrict && obj.existingFileNames[x].toLowerCase() == filename.toLowerCase()) {
                        duplicate = true;
                    }
                }
            }
            return duplicate;
        }

        function removeExistingFileName(obj, fileArr) {
            if (obj.existingFileNames.length) {
                for (var x=0; x<fileArr.length; x++) {
                    var pos = obj.existingFileNames.indexOf(fileArr[x]);
                    if (pos != -1) {
                        obj.existingFileNames.splice(pos, 1);
                    }
                }
            }
        }
        
        function removeFileIds(obj, fileId) {
            if (obj.fileIds.length) {
                var pos = obj.fileIds.indexOf(fileId);
                if (pos != -1) {
                    obj.fileIds.splice(pos, 1);
                    obj.fileSizes.splice(pos, 1);
                }
            }
        }

        function updateFileCounter(s, obj) {
            if(s.showFileCounter) {
                var count = $(obj.container).find(".ajax-file-upload-filename").length;
                obj.fileCounter = count + 1;
                $(obj.container).find(".ajax-file-upload-filename").each(function (i, items) {
                    var arr = $(this).html().split(s.fileCounterStyle);
                    var fileNum = parseInt(arr[0]) - 1; //decrement;
                    var name = count + s.fileCounterStyle + arr[1];
                    $(this).html(name);
                    count--;
                });
            }
        }

        function createCustomInputFile (obj, group, s, uploadLabel) {
            var fileUploadId = "ajax-upload-id-" + (new Date().getTime());
            var form = $("<form method='" + s.method + "' action='" + s.url + "' enctype='" + s.enctype + "'></form>");
            var fileInputStr = "<input type='file' id='" + fileUploadId + "' name='" + s.fileName + "' accept='" + s.acceptFiles + "'/>";

            if(s.multiple) {
                if(s.fileName.indexOf("[]") != s.fileName.length - 2) { // if it does not endwith
                    s.fileName += "[]";
                }
                fileInputStr = "<input type='file' id='" + fileUploadId + "' name='" + s.fileName + "' accept='" + s.acceptFiles + "' multiple/>";
            }
            
            form.append($("<label for='"+fileUploadId+"' style='display:none'>file</label>"));
            
            var fileInput = $(fileInputStr).appendTo(form);

            fileInput.change(function () {
                obj.errorLog.html("");
                var fileExtensions = s.allowedTypes.toLowerCase().split(",");
                var fileArray = [];
                if(this.files) {
                    for(i = 0; i < this.files.length; i++) {
                        fileArray.push(this.files[i].name);
                    }

                    if(s.onSelect(this.files) == false) return;
                } else {
                    var filenameStr = $(this).val();
                    var flist = [];
                    fileArray.push(filenameStr);
                    if(!isFileTypeAllowed(obj, s, filenameStr)) {
                    	UiFileUploader_displayMessage("allowFileType", s.allowedTypes);
                        return;
                    }
                    //fallback for browser without FileAPI
                    flist.push({
                        name: filenameStr,
                        size: 'NA'
                    });
                    if(s.onSelect(flist) == false) return;

                }
                updateFileCounter(s, obj);

                uploadLabel.unbind("click");
                form.hide();
                createCustomInputFile(obj, group, s, uploadLabel);
                form.addClass(group);
                if(s.serialize && feature.fileapi && feature.formdata) { //use HTML5 support and split file submission
                    form.removeClass(group); //Stop Submitting when.
                    var files = this.files;
                    form.remove();
                    serializeAndUploadFiles(s, obj, files);
                }
            });

            if(s.nestedForms) {
                form.css({
                    'margin': 0,
                    'padding': 0
                });
                uploadLabel.css({
                    position: 'relative',
                    overflow: 'hidden',
                    _cursor: 'default'
                });
                fileInput.css({
                    position: 'absolute',
                    'cursor': 'pointer',
                    'top': '0px',
                    'width': '100%',
                    'height': '100%',
                    'left': '0px',
                    'z-index': '100',
                    'opacity': '0.0',
                    'filter': 'alpha(opacity=0)',
                    '-ms-filter': "alpha(opacity=0)",
                    '-khtml-opacity': '0.0',
                    '-moz-opacity': '0.0'
                });
                form.appendTo(uploadLabel);

            } else {
                form.appendTo($('body'));
                form.css({
                    margin: 0,
                    padding: 0,
                    display: 'block',
                    position: 'absolute',
                    left: '-250px'
                });
                if(navigator.appVersion.indexOf("MSIE ") != -1) { //IE Browser
                    uploadLabel.attr('for', fileUploadId);
                } else {
                    uploadLabel.click(function () {
                        fileInput.click();
                    });
                }
            }
        }

		function defaultProgressBar(obj,s) {
			this.statusbar = $("<div class='ajax-file-upload-statusbar'></div>");
            this.filename = $("<div class='ajax-file-upload-filename'></div>").appendTo(this.statusbar);
            this.cancel = $("<div>" + s.cancelStr + "</div>").appendTo(this.statusbar).hide();
            this.cancel.addClass("ajax-file-upload-red");

			return this;
		}
		
        function createProgressDiv(obj, s) {
	        var bar = new defaultProgressBar(obj,s);
            bar.cancel.addClass(obj.formGroup);
            bar.cancel.addClass(s.cancelButtonClass);

            if(s.uploadQueueOrder == 'bottom')
				//$(obj.container).append(bar.statusbar);
            	$(obj.uploadBox).append(bar.statusbar);
			else
				//$(obj.container).prepend(bar.statusbar);
				$(obj.uploadBox).prepend(bar.statusbar);
            return bar;
        }


        function ajaxFormSubmit(form, s, pd, fileArray, obj, file) {
            var currentXHR = null;

            var options = {
                cache: false,
                contentType: false,
                processData: false,
                forceSync: false,
                type: s.method,
                data: s.formData,
                formData: s.fileData,
                dataType: s.returnType,
                headers: s.headers,
                beforeSubmit: function (formData, $form, options) {
                    if(s.onSubmit.call(this, fileArray) != false) {
                        return true;
                    }
                    pd.cancel.show()
                    form.remove();
                    pd.cancel.click(function () {
                    	mainQ.splice(mainQ.indexOf(form), 1);
                        removeExistingFileName(obj, fileArray);
                        pd.statusbar.remove();
                        s.onCancel.call(obj, fileArray, pd);
                        obj.selectedFiles -= fileArray.length; //reduce selected File count
                        updateFileCounter(s, obj);
                    });
                    return false;
                },
                beforeSend: function (xhr, o) {
                    pd.cancel.hide();
                },
                // upload progress
                uploadProgress: function (event, position, total, percentComplete) {
                    //Fix for smaller file uploads in MAC
                    if(percentComplete > 98) percentComplete = 98;
                    
                    var upPercent = 0;
                    var upSize = obj.progressSize + position;
                    if ((obj.progressSize+position) < obj.selectedSizes) {
                    	upPercent = parseInt(upSize / obj.selectedSizes * 100);
                    }
                    else if (upSize >= obj.selectedSizes) {
                    	upPercent = 100;
                    	upSize = obj.selectedSizes;
                    }
                    
                    if (upPercent > 1) {
                    	obj.totProgressSt1_bar.width(upPercent+"%");
                    }
                    
                    obj.totProgressSt1_text.html("(" + getSizeStr(upSize) + " / "+ getSizeStr(obj.selectedSizes) + ")");
                    obj.totProgressSt1_bar.html(upPercent+"%");

                    if (position == total) {
                    	obj.progressSize += total;
                    	if (obj.progressSize > obj.selectedSizes) {
                    		obj.progressSize = obj.selectedSizes;
                    	}
                    }
                    
                    obj.totProgressSt2_fileName.html(file.name);
                    obj.totProgressSt2_text.html( "("+s.uploadCountStr+" : " + (obj.uploadCount+1) +" / "+ obj.selectedFiles + ")" );
                },
                success: function (data, message, xhr) {
                	progressQ.pop();
                    obj.responses.push(data);
                    
                    obj.uploadCount++;
                    
                    if (obj.uploadCount >= obj.fileIds.length) {
                    	obj.totProgressSt1_bar.width("100%");
                		obj.totProgressSt1_bar.html("100%");
                		obj.totProgressSt1_text.html("(" + getSizeStr(obj.selectedSizes) + " / "+ getSizeStr(obj.selectedSizes) + ")");
                		obj.totProgressSt2_fileName.html(UiFileUploader_lang['completeStr']);
                	}

                    s.onSuccess.call(this, fileArray, data, xhr, pd);
                    form.remove();
                    obj.uploadComplete = true;
                    obj.isUpload = "false";
                },
                error: function (xhr, status, errMsg) {
                	obj.uploadComplete = false;
                	obj.isUpload = "false";
                	obj.stopUpload();
                	pd.cancel.remove();
                	progressQ.pop();
                	obj.selectedFiles -= fileArray.length;
                	obj.totProgressSt2_fileName.html("upload error");
                    form.remove();
                    
                    UiFileUploader_displayMessage("uploadErrorStr", errMsg);
                }
            };

        	if(s.showCancel) {
        		pd.cancel.show();
        		pd.cancel.click(function () {
        			mainQ.splice(mainQ.indexOf(form), 1);
        			removeFileIds(obj, file.fileId);
        			removeExistingFileName(obj, fileArray);
        			form.remove();
        			pd.statusbar.remove();
        			s.onCancel.call(obj, fileArray, pd);
        			obj.selectedFiles -= fileArray.length;
        			updateFileCounter(s, obj);
        			
        			obj.totalCount -= 1;
        			obj.totalSize -= file.size;
        			obj.selectedSizes -= file.size;
        			
        			obj.totalSizeStr.html(getSizeStr(obj.totalSize));
    				obj.totalCountStr.html(obj.totalCount);
        			    				
                    var filePos = obj.upFiles.indexOf(file);
                    if (filePos != -1) {
                    	obj.upFiles.splice(filePos, 1);
                    }
    				
    				if (obj.selectedFiles <= 0) {
    					obj.uploadMsgDiv.show();
    				}
        		});
        	}
            form.ajaxForm(options);

        }
        
        function addUrl(url, param, value) {
        	if (url.indexOf("?") == -1) {
        		url += "?";
        	}
        	else {
        		url += "&";
        	}
        	return url + param + "=" + value;
        }
        
        return this;

    }
}(jQuery));