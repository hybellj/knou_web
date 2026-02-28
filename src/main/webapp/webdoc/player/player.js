/**
 * 미디어 플레이어
 * 
 * 사용벙법:
 * <video id="player1" title="제목" data-poster="" lang="ko" continue="true" continueTime="30" speed="true" speedVal="1,1.5,2" speedPlaytime="true">
 *   id : ID
 *   title : 제목
 *   data-poster : 포스트
 *   lang : 언어(ko/en, 기본:ko)
 *   continue : 이어보기 (true/false, 기본:false)
 *   continueTime : 이어보기 시간(초)
 *   speed : 배속지원 (true/false, 기본:false)
 *   speedVal : 배속지원 값
 *   speedPlaytime : 플레이시간에 배속 반영 (true/false, 기본:false)
 * 
 * 	 // 플레이어 초기화
 *	 let player1 = UiMediaPlayer("player1");
 * 
 * @param playerId
 * @returns playerObj
 */
function UiMediaPlayer(playerId) {
	const media = $("#"+playerId);
	const playerObj = new Object();

	// iPhone 체크
	let iPhone = "N";
    var agent = navigator.userAgent.toLowerCase();
    if( agent.indexOf("iphone") > -1 || agent.indexOf("ipad") > -1 || agent.indexOf("ipod") > -1 ) {
    	iPhone = "Y";
    }
	
	// 플레이어 옵션 설정
	playerObj.title			= "";		// 타이틀
	playerObj.lang			= "ko";		// 언어
	playerObj.autoplay		= false;	// 자동재생 (true/false)
	playerObj.continuePlay	= false;	// 이어보기 (true/false)
	playerObj.continueTime	= 0;		// 이어보기 시간
	playerObj.speed			= false;	// 배속지원
	playerObj.speedVal		= [0.5, 0.75, 1, 1.25, 1.5, 1.75, 2];	// 재생속도 범위
	playerObj.speedPlaytime	= false;	// 플레이시간에 배속 반영
	playerObj.quality 		= {default:1080, options:[1080, 720, 576, 560, 480, 360]}; // 비디오 품질 선택
	playerObj.showDuration	= true;		// duration 표시 여부
	playerObj.showChapter	= false;	// chapter 기본 표시 여부
	playerObj.showPageNoOpen	= false;	// OPEN_YN=Y 인 페이지 표시여부
	
	// Player initialize
	playerObj.init = function() {
		this.audio			= false;
		this.totPlayTime	= 0;
		this.totPlayTimeSp	= 0;
		this.checkTime		= 0;
		this.isEnded		= false;
		this.setUi			= true;
		this.isInit			= false;
		this.headerBox		= null;
		this.indexBox		= null;
		this.chapBox		= null;
		this.chapOver		= null;
		this.scriptBox		= null;
		this.scriptText		= "";
		this.enableScript	= false;
		this.progBox		= null;
		this.htmlBox		= null;
		this.htmlFrame		= null;
		this.helpBtn		= null;
		this.helpBox		= null;
		this.startReady		= false;
		this.isShowIndex	= false;
		this.isShowExtbox	= false;
		this.curPageNo		= -1;
		this.checkContinue	= false;
		this.startTimer		= false;
		this.curType		= null;
		this.showProg		= false;
		this.onIndex		= false;
		this.progTime		= 0;
		this.lessonTime		= 0;
		this.startPageIndex = 0;
		this.attendYn		= "Y";
		this.onCaption		= false;
		
		if (media.is("audio")) {
			this.audio = true;
		}		
		
		if (media.attr("title") != undefined) {
			this.title = media.attr("title");
		}
		if (media.attr("lang") != undefined) {
			this.lang = media.attr("lang");
		}
		if (media.attr("continue") != undefined) {
			this.continuePlay = media.attr("continue") == "true" ? true : false;
		}
		if (media.attr("continueTime") != undefined) {
			this.continueTime = parseInt(media.attr("continueTime"));
		}
		if (media.attr("speed") != undefined) {
			this.speed = media.attr("speed") == "true" ? true : false;
			
			if (media.attr("speedVal") != undefined) {
				let vals = media.attr("speedVal").split(",");
				let speedVal = [];
				for (let i=0; i<vals.length; i++) {
					speedVal.push(parseFloat(vals[i]));
				}
				this.speedVal = speedVal;
			}
			
			if (media.attr("speedPlaytime") != undefined) {
				this.speedPlaytime = media.attr("speedPlaytime") == "true" ? true : false;
			}
		}
		
		if (media.attr("showduration") != undefined) {
			this.showDuration = media.attr("showduration") == "true" ? true : false;
		}
		
		if (media.attr("showProg") != undefined) {
			this.showProg = media.attr("showProg") == "true" ? true : false;
		}
		
		if (media.attr("progTime") != undefined) {
			this.progTime = parseInt(media.attr("progTime"));
		}
		
		if (media.attr("lessonTime") != undefined) {
			this.lessonTime = parseInt(media.attr("lessonTime")) * 60;
		}
		
		if (media.attr("showChapter") != undefined) {
			this.showChapter = media.attr("showChapter") == "true" ? true : false;
		}
		
		if (media.attr("showIndex") != undefined) {
			this.onIndex = media.attr("showIndex") == "true" ? true : false;
		}
		
		if (media.attr("startPageIndex") != undefined) {
			this.startPageIndex = parseInt(media.attr("startPageIndex"));
		}
		
		if (media.attr("showPageNoOpen") != undefined) {
			this.showPageNoOpen =  media.attr("showPageNoOpen") == "true" ? true : false;
		}
		
		media.attr({controls:'', style:'--plyr-color-main:#00b3ff'});
		
		let optControl = [
			'play-large',
			'rewind',
			'play',
			'fast-forward',
			'progress',
			'current-time'
		];
		
		if (this.audio) {
			optControl = [
				'play',
				'progress',
				'current-time'
			];
		}
		
		if (this.showDuration) {
			optControl.push('duration');
		}
		
		optControl.push('mute', 'volume');
		
		if (media.find("track").length > 0) {
			optControl.push('captions');
		}
		
		if (DEVICE_TYPE == undefined || DEVICE_TYPE != "mobile") {
			optControl.push('settings',
				/*'pip',*/
				'airplay',
				'fullscreen');
		}
		else {
			optControl.push('settings',
				'airplay',
				'fullscreen');
		}
		
		// 페이지 확인
		let pageListObj = media.children("page_list");
		this.pageList = null;
		this.enablePage = false;
		
		if (pageListObj.length > 0) {
			this.enablePage = true;
			this.pageList = new Array();
			let pages = pageListObj.children("page");
			
			for (let i=0; i<pages.length; i++) {
				let page = $(pages[i]);
				let src = page.children("page_source").html();
				let srcs = [];
				let srcObj = {};
				
				if (src.indexOf(".mp4") > 0) {
					if(src.indexOf("_hd.mp4") > 0) {
						srcObj["src"] = src;
						srcObj["type"] = "video/mp4";
						srcObj["size"] = "1080";
						srcs.push(srcObj);
						
						srcObj = {};
						srcObj["src"] = src.replace("_hd.mp4","_sd.mp4");
						srcObj["type"] = "video/mp4";
						srcObj["size"] = "560";
						srcs.push(srcObj);
					}
					else if(src.indexOf("_sd.mp4") > 0) {
						srcObj["src"] = src;
						srcObj["type"] = "video/mp4";
						srcObj["size"] = "560";
						srcs.push(srcObj);
						
						srcObj = {};
						srcObj["src"] = src.replace("_sd.mp4","_hd.mp4");
						srcObj["type"] = "video/mp4";
						srcObj["size"] = "1080";
						srcs.push(srcObj);
					}
					else {
						srcObj["src"] = src;
						srcObj["type"] = "video/mp4";
						srcObj["size"] = "1080";
						srcs.push(srcObj);
					}
				}
				else {
					srcObj["src"] = src;
					srcObj["type"] = "video/mp4";
					srcObj["size"] = "1080";
					srcs.push(srcObj);					
				}
				
				let sdSrc = page.children("page_source_sd");
				if (sdSrc.length > 0) {
					srcObj = {};
					srcObj["src"] = sdSrc.html();
					srcObj["type"] = "video/mp4";
					srcObj["size"] = "560";
					srcs.push(srcObj);
				}
				
				let extData = null;
				if (page.children("extdata").length > 0) {
					extData = atob(page.children("extdata").html()).split(",");
				}
				
				let pageInfo = {
						pageCnt: page.children("page_cnt").html(),
						title: page.children("page_title").html(), 
						src: srcs, 
						type: page.children("page_type").html(), 
						on: (page.children("on").html() == "true" ? true : false),
						sessionLoc: parseInt(page.children("session_loc").html()),
						studyTm: page.children("study_tm").html(),
						studyCnt: page.children("study_cnt").html(),
						prgrRatio: page.children("prgr_ratio").html(),
						videoTm: parseInt(page.children("videotm").html()),
						attendYn: page.children("attend").html(),
						openYn: page.children("openyn").html(),
						sessionTm: 0,
						sessionTmSp: 0,
						chapterList:null,
						id: playerId+"_page"+(i),
						scriptText: "",
						enableScript: false,
						duration: 0,
						checkContinue: false
					};
				
				if (pageInfo.type == "html") {
					pageInfo.src = src;
				}
				
				if (pageInfo.type == "video/mp4") {
					let srcUri = "";
					if (src != null && src != "") {
						srcUri = src.substr(0, src.lastIndexOf("/")+1);
					}
					
					// 스크립트
					if (page.find("script_text").length > 0) {
						pageInfo["scriptText"] = page.find("script_text").html();
						pageInfo["enableScript"] = true;
					}
					// 스크립트 가져오기
					else {
						let scriptUrl = "";
						let scriptXml = page.find("script_xml");
						if (scriptXml.length > -1) {
							scriptUrl = scriptXml.html();
						}

						// 스크립트 URL 유효성 체크
						if (scriptUrl != "") {
							$.ajax({
								type: 'GET',
								dataType: 'xml',
							    async: false,
							    url : scriptUrl,
							    timeout: 1000,
								success : function(data){
									let url = $(data).find("media_script_list > media_script > uri").html();
									if (url != null && extData != null) {
										url = extData[1] + url + extData[4];
										scriptUrl = extData[0] + aes128Encode(extData[3], extData[2], url);
										pageInfo["scriptText"] = scriptUrl;
										pageInfo["enableScript"] = true;
									}
							    }
							});
						}
					}
					
					// 자막
					let tracksObj = page.find("track");
					if (tracksObj.length > 0) {
						let trackInfo = [];
						for (let t=0; t<tracksObj.length; t++) {
							let track = $(tracksObj[t]);
							let trackItem = {};
							if (track.is("[kind]")) 	trackItem.kind = track.attr("kind");
							if (track.is("[label]")) 	trackItem.label = track.attr("label");
							if (track.is("[srclang]"))	trackItem.srclang = track.attr("srclang");
							if (track.is("[src]")) 		trackItem.src = track.attr("src");
							if (track.is("[default]"))	trackItem.default = true;
							trackInfo.push(trackItem);
						}
						pageInfo["tracks"] = trackInfo;
						
						// 자막이 있는지 체크
						playerObj.onCaption = true;
					}
					// 자막 가져오기
					else {
						let trackUrl = "";
						if (srcUri != "") {
							//trackUrl = srcUri + "caption_list.xml";
						}
						
						let trackXml = page.find("track_xml");
						if (trackXml.length > -1) {
							trackUrl = trackXml.html();
						}
						
						// 자막 URL 유효성 체크
						if (trackUrl != "") {
							$.ajax({
								type: 'GET',
								dataType: 'xml',
							    async: false,
							    url : trackUrl,
							    timeout: 1000,
								success : function(data){
									let caption = $(data).find("caption_list > caption");
									let trackInfo = [];
									
									if (extData != null) {
										for (var t=0; t<caption.length; t++) {
											let trackItem = {};
											let capUri = extData[1] + encodeURIComponent($(caption[t]).children("uri").html()) + extData[4];
											capUri = extData[0] + aes128Encode(extData[3], extData[2], capUri);
											
											trackItem.kind = "captions";
											trackItem.label = $(caption[t]).children("label").html();
											trackItem.srclang = $(caption[t]).children("lang").html();
											trackItem.src = capUri;
											
											if (t==0) {
												trackItem.default = true;
											}
											
											trackInfo.push(trackItem);
											
											// 자막이 있는지 체크
											playerObj.onCaption = true;
										}
									}
									
									pageInfo["tracks"] = trackInfo;
							    }
							});
						}
					}
					
					// 목차
					var chapList = page.find("chapter_list");
					if (chapList.length > 0) {
						let chapterList = new Array();
						let chapters = chapList.children("chapter");
						
						for (let i=0; i<chapters.length; i++) {
							let chapter = $(chapters[i]);
							let time = chapter.children("time");
							let description = chapter.find("description").html().trim();
							if (description == "") {
								description = "Section "+(i+1);
							}
							
							chapterList.push({from:time.attr('from'), to:time.attr('to'), desc:description, thumb:chapter.find("thumbnail_uri").html()});
						}
						
						pageInfo["chapterList"] = chapterList;
					}
					// chapter 목록 가져오기
					else {
						let chapUrl = "";
						
						let chapXml = page.find("chapter_xml");
						if (chapXml.length > -1) {
							chapUrl = chapXml.html();
						}
						
						if (chapUrl != "") {
							$.ajax({
								type: 'GET',
								dataType: 'xml',
							    async: false,
							    url : chapUrl,
							    timeout: 1000,
								success : function(data){
									let chapList = $(data).children("chapter_list");
									if (chapList.length > 0) {
										let chapterList = new Array();
										let chapters = chapList.children("chapter");
										
										for (let i=0; i<chapters.length; i++) {
											let chapter = $(chapters[i]);
											let time = chapter.children("time");
											let thumbnail = chapter.find("thumbnail_uri").html();
											if (thumbnail.indexOf("http") == -1) {
												thumbnail = chapUrl.substr(0, chapUrl.indexOf("chapter.xml")) + thumbnail;
											}
											let description = chapter.find("description").html().trim();
											if (description == "") {
												description = "Section "+(i+1);
											}
											
											chapterList.push({from:time.attr('from'), to:time.attr('to'), desc:description, thumb:thumbnail});
										}
										
										pageInfo["chapterList"] = chapterList;
									}
							    }
							});
						}
					}
				}
				
				this.pageList.push(pageInfo);
			}
		}

		// 페이지 정보가 없을경우만 적용
		if (!this.enablePage) {
			// 스크립트 내용 확인
			let scriptTextObj = media.children("script_text");
			if (scriptTextObj.length > 0) {
				this.scriptText = media.find("script_text").html();
				this.enableScript = true;
				
				if (this.scriptText === "") {
					this.enableScript = false;
				}
			}
			
			// 목차 내용 확인
			let chapterListObj = media.children("chapter_list");
			this.enableChapter = false;
			this.chapterList = null;
			
			if (chapterListObj.length > 0) {
				this.enableChapter = true;
				this.chapterList = new Array();
				let chapters = chapterListObj.children("chapter");
				
				for (let i=0; i<chapters.length; i++) {
					let chapter = $(chapters[i]);
					let time = chapter.children("time");
					let description = chapter.find("description").html().trim();
					if (description == "") {
						description = "Section "+(i+1);
					}
					
					this.chapterList.push({from:time.attr('from'), to:time.attr('to'), desc:description, thumb:chapter.find("thumbnail_uri").html()});
				}
			}
			
			// 일반 스크립트파일 있는 경우
			let videoScriptObj = media.children("video_script");
			if (videoScriptObj.length > 0) {
				playerObj.scriptText = videoScriptObj.html();
				playerObj.enableScript = true;
				
				if (playerObj.scriptText === "") {
					playerObj.enableScript = false;
				}
			}
			
			// 자막이 있는지 체크
			if (media.children("track").length > 0) {
				playerObj.onCaption = true;
			}
		}
		
		// 확장버튼
		let extBtnObj = media.children("ext-btn");
		this.extBtnList = null;
		
		if (extBtnObj.length > 0) {
			this.extBtnList = new Array();
			let extBtns = extBtnObj.children("btn-item");
			
			for (let i=0; i<extBtns.length; i++) {
				let btn = $(extBtns[i]);
				this.extBtnList.push({text:btn.find("text").html(), onclick:btn.find("onclick").html(), cls:btn.find("class").html()});
			}
		}
		
		this.iconUrl = $('script[src*="/player.js"]').attr('src');
		this.iconUrl = this.iconUrl.substr(0, this.iconUrl.indexOf("player.js")) + "plyr.svg";
		
		let optSettings = ['captions', 'quality'];
		if (playerObj.speed) {
			optSettings.push('speed');
		}
		
		let playerOpt = {
				i18n: UiMediaPlayer_lang[playerObj.lang],
				controls: optControl,
				settings: optSettings,
				seekTime: 10,
				speed: {
					selected: 1,
					options: playerObj.speedVal
				},
				tooltips: {
					controls: true,
					seek: true
				},
				keyboard: {
				    focused: true,
				    global: false
				},
				loadSprite: false,
				iconUrl: playerObj.iconUrl,
				quality: playerObj.quality,
				invertTime: false,
				captions: {active: true, language: 'auto', update: true}
			};
		
		if (iPhone == "Y") {
			// iOS fullscreen
			playerOpt["fullscreen"] = {enabled:true, fallback:'force', iosNative:true, container:null};
		}
		
		let player = new Plyr('#'+playerId, playerOpt);
		
		player.playerId = playerId;
		player.curTime = 0;
		player.curChap = 0;
		player.timeArr = null;
		//player.seekedAct = false;
		
		player.on('ready', (event) => {
			if (!playerObj.isInit) {
				playerObj.playerRoot = $("#"+playerId).parent().parent();
				playerObj.playerRoot.attr("id", "MEDIA_"+playerId);
				playerObj.playerRoot.focus();
				playerObj.startReady = false;
				playerObj.isInit = true;
				
				// 키보드 설정
				playerObj.playerRoot.keydown(function(e) {
					if (e.ctrlKey) {
						return;
					}
					
			        if (e.keyCode === 32) {			// 플레이/일시정지, space key
			        	player.togglePlay();
			        } 
			        else if (e.keyCode === 73) {		// 목차 표시, I key
			        	if (playerObj.enableChapter || playerObj.enablePage) {
			        		playerObj.showIndex();
			        	}
			        }
			        else if (e.keyCode === 83) {		// 스크립트 표시, S key
			        	if (playerObj.enableScript) {
			        		playerObj.showScript();
			        	}
			        }
			        else if (e.keyCode === 72) {		// 도움말 표시, H key
			        	playerObj.showHelp();
			        }
			        else if (e.keyCode === 67) {		// 재생속도 빠르게, C key
			        	playerObj.player.toggleCaptions();
			        	
			        	let idx = playerObj.speedVal.indexOf(playerObj.player.speed);
			        	if (idx == playerObj.speedVal.length-1) {
			        		return false;
			        	}
			        	
			        	let spVal = playerObj.speedVal[idx+1];
			        	if (spVal > 0) spVal = 2;
			        	
			        	playerObj.player.speed = spVal;
			        }
			        else if (e.keyCode === 90) {		// 재생속도 보통, Z key
			        	playerObj.player.speed = 1;
			        }
			        else if (e.keyCode === 88) {		// 재생속도 느리게, X key
			        	let idx = playerObj.speedVal.indexOf(playerObj.player.speed);
			        	if (idx == 0) {
			        		return false;
			        	}
			        	
			        	playerObj.player.speed = playerObj.speedVal[idx-1];
			        }
			        else if (e.keyCode === 84) {		// 자막, T key
			        	playerObj.player.toggleCaptions();
			        }
			    });
			}
			
			// player ui init
			playerObj.setPlayerUi();
			
			// 플레이 시간 계산
			if (!playerObj.startTimer) {
				playerObj.startTimer = true;
				playerObj.calcPlayTime();
			}
			
			if (playerObj.startReady) {
				player.play();
				playerObj.startReady = false;
			}
			
			
			
			
			/*
			var page = playerObj.pageList[playerObj.curPageNo];
			if (page != null) {
				var contTime = parseInt(page.sessionLoc);
				var duration = page.duration;
				
				setTimeout(function(){
					duration = event.detail.plyr.duration;
					
					if ((contTime > 10 && contTime < duration - 5)) {
						page.checkContinue = true;
						
						var min = parseInt(contTime / 60);
						var sec = parseInt(contTime % 60);
						var contTmStr = (min < 10 ? "0"+min : min) + ":" + (sec < 10 ? "0"+sec : sec);
						var confirmMsg = playerObj.message('continueMsg').replace("{time}",contTmStr);
						
						if (confirm(confirmMsg)) {
							event.detail.plyr.currentTime = contTime - 5;
					    } 
						else {
							event.detail.plyr.currentTime = 0;
					    }
					}
					else {
						if (event.detail.plyr.currentTime < contTime) {
							event.detail.plyr.currentTime = contTime;
						}
						page.checkContinue = true;
					}
				}, 500);
			}
			*/
		});
		
		player.on('play', (event) => {
			var page = null;
			if (playerObj.enablePage) {
				page = playerObj.pageList[playerObj.curPageNo];
				playerObj.attendYn = page.attendYn;
				
				if (page.videoTm != 0) {
					this.videoTm = page.videoTm;
				}
				else {
					this.videoTm = event.detail.plyr.duration;
				}
				
				if (event.detail.plyr.duration > 0 && this.videoTm > event.detail.plyr.duration) {
					this.videoTm = event.detail.plyr.duration;
				}
			}
			else {
				playerObj.attendYn = "Y";
			}
			
			if (this.chapBox != null) {
				this.chapBox.hide();
			}
			playerObj.isEnded = false;
			
			if (playerObj.enablePage && playerObj.curPageNo === -1) {
				playerObj.changePage(0);
			}
			
			if (event.detail.plyr.currentTime > 0) {
				//playerObj.checkContinue = true;
			}

			if (event.detail.plyr.speed > 2) {
				event.detail.plyr.speed = 2;
			}
			
			// 이어보기
			if (!playerObj.enablePage && playerObj.continuePlay && !playerObj.checkContinue
					&& (playerObj.continueTime > 10 && playerObj.continueTime < this.videoTm - 5)) {
				event.detail.plyr.pause();
				playerObj.checkContinue = true;
				
				var min = parseInt(playerObj.continueTime / 60);
				var sec = parseInt(playerObj.continueTime % 60);
				var contTm = (min < 10 ? "0"+min : min) + ":" + (sec < 10 ? "0"+sec : sec);
				var confirmMsg = playerObj.message('continueMsg').replace("{time}",contTm);
				
				if (confirm(confirmMsg)) {
					event.detail.plyr.currentTime = playerObj.continueTime - 5;
					setTimeout(function(){
						event.detail.plyr.play();	
					},500);
			    } 
				else {
					event.detail.plyr.currentTime = 0;
					setTimeout(function(){
						event.detail.plyr.play();	
					},500);
			    }
			}
			// 이어보기(페이지)
			else if (playerObj.enablePage && page != null && !page.checkContinue) {
				if (page != null && page.sessionLoc != undefined && page.sessionLoc != null && page.sessionLoc != "") {
					var contTime = parseInt(page.sessionLoc);
					var duration = page.videoTm;
					
					setTimeout(function(){
						if (duration == 0) {
							duration = event.detail.plyr.duration;
						}
						
						if ((contTime > 10 && contTime < duration - 5)) {
							page.checkContinue = true;
							event.detail.plyr.pause();
							
							var min = parseInt(contTime / 60);
							var sec = parseInt(contTime % 60);
							var contTmStr = (min < 10 ? "0"+min : min) + ":" + (sec < 10 ? "0"+sec : sec);
							var confirmMsg = playerObj.message('continueMsg').replace("{time}",contTmStr);
							
							if (event.detail.plyr.fullscreen.active) {
								event.detail.plyr.fullscreen.exit();
								//$("body").removeClass("play");
							}
							
							var checkConfirm = playerObj.continueConfirm(confirmMsg);
							setTimeout(function(){
								event.detail.plyr.pause();
								if (event.detail.plyr.fullscreen.active) {
									event.detail.plyr.fullscreen.exit();
								}
								
								checkConfirm.then(function(answer) {
									if (answer) {
										event.detail.plyr.currentTime = contTime - 5;
										event.detail.plyr.play();
									}
									else {
										event.detail.plyr.currentTime = 0;
										event.detail.plyr.play();
									}
							    });	
							},300);
						}
						else {
							if (event.detail.plyr.currentTime < contTime) {
								event.detail.plyr.currentTime = contTime;
							}
							page.checkContinue = true;
						}
					}, 300);
				}
				
			}
			
			playerObj.playerRoot.focus();
			playerObj.scrollChapter(true);
		});
		
		player.on('controlsshown', (event) => {
			if (this.headerBox != null && this.curType != "html") {
				this.headerBox.show();
			}
			
			if (this.backBtn != undefined && this.backBtn != null) {
				this.backBtn.css({opacity:"unset",visibility:"visible"});	
			}
			if (this.nextBtn != undefined && this.nextBtn != null) {
				this.nextBtn.css({opacity:"unset",visibility:"visible"});	
			}
			if (!event.detail.plyr.paused && this.pauseBtn != undefined && this.pauseBtn != null) {
				this.pauseBtn.css({opacity:"unset",visibility:"visible"});
			}
		});
		
		player.on('controlshidden', (event) => {
			if (this.headerBox != null && this.curType != "html") {
				this.headerBox.hide();
			}
			
			if (this.backBtn != undefined && this.backBtn != null) {
				this.backBtn.css({opacity:"0",visibility:"hidden"});
			}
			if (this.nextBtn != undefined && this.nextBtn != null) {
				this.nextBtn.css({opacity:"0",visibility:"hidden"});
			}
			if (this.pauseBtn != undefined && this.pauseBtn != null) {
				this.pauseBtn.css({opacity:"0",visibility:"hidden"});
			}
		});
		
		player.on('enterfullscreen', (event) => {
			if (this.chapBox != null) {
				this.chapBox.hide();
			}

			if (this.headerBox.centerBox != null) {
				this.headerBox.centerBox.hide();
			}
		});
		
		player.on('exitfullscreen', (event) => {
			if (this.chapBox != null) {
				this.chapBox.hide();
			}
			
			if (this.headerBox.centerBox != null) {
				this.headerBox.centerBox.show();
			}
		});
		
		player.on('seeked', (event) => {
			this.curChap = 0;
			playerObj.scrollChapter(true);
			
			setTimeout(function(){
				if (event.detail.plyr.playing) {
					event.detail.plyr.toggleControls(false);
				}
			}, 500);
		});
		
		player.on('pause', (event) => {
			//console.log("pause..........");
			
			if (playerObj.pauseBtn != undefined && this.pauseBtn != null) {
				playerObj.pauseBtn.css({opacity:"0",visibility:"hidden"});
			}
			if (playerObj.backBtn != undefined && playerObj.backBtn != null) {
				playerObj.backBtn.css({opacity:"unset",visibility:"visible"});
			}
			if (playerObj.nextBtn != undefined && playerObj.nextBtn != null) {
				playerObj.nextBtn.css({opacity:"unset",visibility:"visible"});
			}
		});
		
		player.on('ended', (event) => {
			this.curChap = 0;
			playerObj.isEnded = true;

			if (playerObj.enablePage) {
				playerObj.changePage(null);
			}
		});
		
		player.on('timeupdate', (event) => {
			this.curTime = event.detail.plyr.currentTime;
			let newTime = (new Date()).getTime();
			
			if (playerObj.chapScrollTime == undefined) {
				playerObj.chapScrollTime = newTime;
			} 
			else if (((new Date()).getTime() - playerObj.chapScrollTime) > 1000) {
				playerObj.chapScrollTime = newTime;
				playerObj.scrollChapter(false);
			}
			
			// 학습진행율 표시 업데이트
			if (playerObj.lessonTime > 0 && playerObj.showProg 
					&& (playerObj.progChkTime == undefined || (newTime - playerObj.progChkTime) > 2000)) {
				let progTime = playerObj.progTime + (playerObj.totPlayTime / 1000);
				let progRate = (progTime / playerObj.lessonTime) * 100;
				if (progRate > 100) progRate = 100;
				
				playerObj.setProgbar(progRate);
				playerObj.progChkTime = newTime;
			}
		});
		
		player.on('ratechange', (event) => {
			if (event.detail.plyr.speed > 2) {
				event.detail.plyr.speed = 2;
			}
		});
		
		if (playerObj.enablePage) {
			setTimeout(function(){
				playerObj.changePage(playerObj.startPageIndex, true);
			}, 100);
		}
		
		playerObj.player = player;
	};

	// 썸네일,목차 현재 플레이 위치로 스크롤
	playerObj.scrollChapter = function (scroll) {
		if (playerObj.enableChapter) {
			try {
				let curChap = 0;
				let idxConBox = $(playerObj.indexBoxBody);
				let idxHeight = idxConBox.height();
				let idxScroll = idxConBox.scrollTop();
				
				for (let i=0; i<this.timeArr.length; i++) {
					if (this.curTime >= this.timeArr[i][0] && this.curTime < this.timeArr[i][1]) {
						curChap = i+1;
						
						if (this.curChap != curChap) {
							// 썸네일
							let chapThumb = $("#"+playerId+"_chap"+curChap);
							chapThumb.siblings().removeClass("select");
							chapThumb.addClass("select");
							this.curChap = curChap;
							
							let chapConBox = chapThumb.parent();
							let leftPos = chapThumb.position().left - 30;
							let curScroll = chapConBox.scrollLeft();
							
							if (leftPos < 0) {
								chapConBox.scrollLeft(curScroll + leftPos);
							}
							else if ((leftPos + chapThumb.width() + 8) > chapConBox.width()) {
								chapConBox.scrollLeft(curScroll + (leftPos + chapThumb.width() - chapConBox.width()) + 8 );
							}
							
							// 목차
							let idxThumb = $("#"+playerId+"_idx"+curChap);
							idxThumb.siblings().removeClass("select");
							idxThumb.addClass("select");
							
							let topPos = idxThumb.position().top - 34;
							if (topPos < 0) {
								idxConBox.scrollTop(idxScroll + topPos);
							}
							else if ((topPos + idxThumb.height() + 10) > idxHeight) {
								idxConBox.scrollTop(idxScroll + (topPos + idxThumb.height() - idxConBox.height()) + 10);
							}
						}
						
						break;
					}
				}
			} catch (e) { }
		}
		else if (playerObj.enablePage) {
			let page = playerObj.pageList[playerObj.curPageNo];
			if (page.chapterList != null) {
				let curChap = 0;
				let idxConBox = $(playerObj.indexBoxBody);
				let idxHeight = idxConBox.height();
				let idxScroll = idxConBox.scrollTop();
				
				if (page.timeArr != null) {
					for (let i=0; i<page.timeArr.length; i++) {
						if (this.curTime >= page.timeArr[i][0] && this.curTime < page.timeArr[i][1]) {
							curChap = i+1;
							
							let idxThumb = $("#"+page.id+"_idx"+curChap);
							if (idxThumb.length > 0) {
								idxThumb.siblings(".index-item").removeClass("select");
								idxThumb.addClass("select");
								
								if (scroll) {
									let topPos = idxThumb.position().top - 34;
									if (topPos < 0) {
										idxConBox.scrollTop(idxScroll + topPos);
									}
									else if ((topPos + idxThumb.height() + 10) > idxHeight) {
										idxConBox.scrollTop(idxScroll + (topPos + idxThumb.height() - idxHeight) + 10);
									}
								}
							}
							
							break;
						}
					}
				}
			}
		}
	}
	
	
	// 플레이 시간 계산
	playerObj.calcPlayTime = function() {
		let curTime = (new Date()).getTime();
		
		if (playerObj.player.playing && playerObj.player.currentTime > 0) {
			if (playerObj.checkTime === 0 || (curTime - playerObj.checkTime) > 3000 
					|| (curTime - playerObj.checkTime) < 0) {
				playerObj.checkTime = curTime;
			}
			
			let time = curTime - playerObj.checkTime;
			let timeSp = time;
			if (playerObj.speedPlaytime) {
				time = time * playerObj.player.speed;
				timeSp = time;
			}
			else {
				timeSp = time * playerObj.player.speed;
			}
			
			if (this.attendYn == "N") {
				if (playerObj.enablePage) {
					let pageInfo = playerObj.pageList[playerObj.curPageNo];
					
					pageInfo.sessionTm += time; 
					pageInfo.sessionTmSp += timeSp;
				}
			}
			else {
				playerObj.totPlayTime += time;
				playerObj.totPlayTimeSp += timeSp;
				
				if (playerObj.enablePage) {
					let pageInfo = playerObj.pageList[playerObj.curPageNo];
					
					pageInfo.sessionTm += time; 
					pageInfo.sessionTmSp += timeSp;
				}
			}
		}

		playerObj.checkTime = curTime;
		
		this.timer = setTimeout(function(){
			playerObj.calcPlayTime();
		}, 1000);		
	};
	
	
	// 플레이 위치(current time) 설정/가져오기
	playerObj.currentTime = function(time) {
		if (time == undefined) {
			if (playerObj.isEnded) {
				return 0;
			}
			else {
				return Math.floor(playerObj.player.currentTime);
			}
		}
		else {
			playerObj.player.currentTime = time;
		}
	};
	
	// 총 플레이 시간 가져오기
	playerObj.playTime = function() {
		return Math.round(playerObj.totPlayTime / 1000);
	};
	
	// 플레이
	playerObj.play = function() {
		playerObj.player.play();
	};
	
	// 일시정지
	playerObj.pause = function() {
		playerObj.player.pause();
	};
	
	
	// 플레이어 UI 설정
	playerObj.setPlayerUi = function() {
		this.videoWrapper = this.playerRoot.children(".plyr__video-wrapper");
		this.videoWrapper.children("video").attr("id", playerId);
		this.videoWrapper.children("video").attr("crossorigin", "anonymous");
		
		let player = this.player;
		
		if (this.headerBox == null && this.audio == false) {
			this.headerBox = $("<div class='plyr__header'></div>");
			this.headerBox.titleBox = $("<div class='plyr__title'></div>");
			this.headerBox.titleBox.html(playerObj.title);
			this.headerBox.append(this.headerBox.titleBox);
			this.headerBox.rightBox = $("<div class='btn-box-right'></div>");
			this.headerBox.centerBox = $("<div class='btn-box-center'></div>");
			this.headerBox.append(this.headerBox.centerBox);
			this.headerBox.append(this.headerBox.rightBox);
			
			
			if (this.extBtnList != null) {
				for (let i=0; i<this.extBtnList.length; i++) {
					let btn = this.extBtnList[i];
					let btnTxt = "<div><span class='icon'></span><span class='txt'>"+btn.text+"</span></div>";
					
					this.headerBox.centerBox.append($("<button class='plyr__extbtn header-btn "+btn.cls+"' onclick='"+btn.onclick+";return false;' title=\""+btn.text+"\">"+btnTxt+"</button>"));
				}
			}
			
			// 도움말
			this.helpBtn = $("<span class='help-btn' title='"+playerObj.message('help')+"'><span class='icon'></span></span>");
			if (DEVICE_TYPE == undefined || DEVICE_TYPE != "mobile") {
				this.headerBox.rightBox.append(this.helpBtn);
			}
			
			this.helpBox = $("<div class='plyr__help-box'></div>");
			this.helpBox.append($("<div class='help-head'><span class='help-title'>"+playerObj.message('help')+"</span>" 
					+ "<span class='close-btn' title='"+playerObj.message('close')+"'><span class='icon'></span></span></div>"
					+ "<div class='help-body'>"
					+ "<table><caption>Help</caption>"
					+ "<tr><th>"+playerObj.message('helpKey')+"</th><th>"+playerObj.message('helpAction')+"</th></tr>"
					+ "<tr><td>space</td><td>"+playerObj.message('helpSpace')+"</td></tr>"
					+ "<tr><td>←</td><td>"+playerObj.message('helpRewind')+"</td></tr>"
					+ "<tr><td>→</td><td>"+playerObj.message('helpForward')+"</td></tr>"
					+ "<tr><td>↑</td><td>"+playerObj.message('helpVolumeUp')+"</td></tr>"
					+ "<tr><td>↓</td><td>"+playerObj.message('helpVolumeDown')+"</td></tr>"
					+ "<tr><td>M</td><td>"+playerObj.message('helpMute')+"</td></tr>"
					+ "<tr><td>Z</td><td>"+playerObj.message('helpSpeedNormal')+"</td></tr>"
					+ "<tr><td>X</td><td>"+playerObj.message('helpSpeedDown')+"</td></tr>"
					+ "<tr><td>C</td><td>"+playerObj.message('helpSpeedUp')+"</td></tr>"
					+ "<tr><td>F</td><td>"+playerObj.message('helpFullscreen')+"</td></tr>"
					//+ "<tr><td>T</td><td>"+playerObj.message('helpCaption')+"</td></tr>"
					//+ "<tr><td>I</td><td>"+playerObj.message('index')+"</td></tr>"
					//+ "<tr><td>S</td><td>"+playerObj.message('script')+"</td></tr>"
					+ "<tr><td>H</td><td>"+playerObj.message('help')+"</td></tr>"
					+ "</table></div>"));
			
			this.playerRoot.append(this.helpBox);
			
			this.helpBtn.click(function() {
				playerObj.showHelp();
			});
			
			this.helpBox.find(".close-btn").click(function(){
				playerObj.showHelp();
			});
			
			this.playerRoot.prepend(this.headerBox);
		}
		
		var pauseBtn = $(this.playerRoot).find("button.pause-btn");
		if (pauseBtn.length == 0) {
			this.pauseBtn = $('<button type="button" class="plyr__control plyr__control--overlaid pause-btn" data-plyr="pause" aria-label="Pause"><svg aria-hidden="true" focusable="false"><use xlink:href="'+this.iconUrl+'#plyr-pause"></use></svg><span class="plyr__sr-only">Pause</span></button>');
			this.playerRoot.append(this.pauseBtn);
			this.pauseBtn.click(function(){
				playerObj.player.pause();
			});			
		}
		
		// 스크립트 버튼 추가
		if (this.enableScript) {
			this.scriptBtn = $("<button class='plyr__controls__item plyr__control ex-btn script-btn' type='button' data-plyr='script'>"
				+ "<span class='icon'></span><span class='plyr__tooltip'>"+playerObj.message('script')+"</span></button>");
			playerObj.playerRoot.find(".plyr__controls").append(this.scriptBtn);
			
			this.scriptBtn.click(function(){
				playerObj.showScript();
			});
		}
		
		// 목차 box 추가
		if (this.enableChapter || this.enablePage) {
			this.indexBox = $("<div class='plyr__index-box'></div>");
			this.videoWrapper.append(this.indexBox);
			this.indexBox.append($("<div class='index-head'><span class='index-title'>"+playerObj.message('index')+"</span>"
					+ "<span class='close-btn' title='"+playerObj.message('close')+"'><span class='icon'></span></span></div>"));
			this.indexBoxBody = $("<div class='index-body'></div>");
			this.indexBox.append(this.indexBoxBody);
			
			this.indexBox.click(function(event) {
				event.stopPropagation();
			});
			
			this.indexBox.dblclick(function(event) {
				event.stopPropagation();
			});
			
			this.indexBox.mousemove(function(event) {
				if (playerObj.player.playing) {
					if (playerObj.backBtn != undefined && playerObj.backBtn != null) {
						playerObj.backBtn.css({opacity:"0",visibility:"hidden"});
					}
					if (playerObj.nextBtn != undefined && playerObj.nextBtn != null) {
						playerObj.nextBtn.css({opacity:"0",visibility:"hidden"});
					}
					if (playerObj.pauseBtn != undefined && playerObj.pauseBtn != null) {
						playerObj.pauseBtn.css({opacity:"0",visibility:"hidden"});
					}
				}
			});
			
			this.indexBox.find(".close-btn").click(function(){
				playerObj.playerRoot.removeClass("show-extbox");
				playerObj.indexBox.hide();
				playerObj.isShowExtbox = false;
				playerObj.isShowIndex = false;
			});
		}
		
		// 목차/썸네일
		if (this.enableChapter && !this.enablePage) {
			let timeArr = new Array();
			let chapCont = "";
			
			if (this.headerBox.find(".index-btn").length == 0) {
				this.headerBox.rightBox.append($("<span class='index-btn' title='"+playerObj.message('index')+"'><span class='icon'></span></span>"));

				// 목차 버튼 클릭
				this.headerBox.find(".index-btn").click(function(){
					playerObj.showIndex();
				});
			}
			
			for (let i=0; i<this.chapterList.length; i++) {
				let min = parseInt(this.chapterList[i].from / 60);
				let sec = parseInt(this.chapterList[i].from % 60);
				let time = (min < 10 ? '0'+min : min) + ":" + (sec < 10 ? '0'+sec : sec);
				
				timeArr.push([parseFloat(this.chapterList[i].from), parseFloat(this.chapterList[i].to)]);
				chapCont += "<div id='"+playerId+"_chap"+(i+1)+"' class='chap-thumb' from='"+this.chapterList[i].from+"'><div class='thumb-img' style='background-image:url(\""+this.chapterList[i].thumb+"\");'></div><div class='chap-time'>"+time+"</div><div class='chap-num'>"+(i+1)+"</div></div>";
				this.indexBoxBody.append($("<div id='"+playerId+"_idx"+(i+1)+"' class='index-item' from='"+this.chapterList[i].from+"'><div class='index-img' style='background-image:url(\""+this.chapterList[i].thumb+"\");'><div class='index-time'>"+time+"</div><div class='index-num'>"+(i+1)+"</div></div><div class='index-desc'>"+this.chapterList[i].desc+"</div></div>"));
			}
			
			if (this.chapOver == null) {
				this.chapOver = $("<div class='plyr__chap-over'></div>");
				this.playerRoot.append(this.chapOver);
			}
			
			if (this.chapBox == null) {
				this.chapBox = $("<div class='plyr__chap'></div>");
				this.chapBox.append($("<div class='chap-cont-box'>"
						+ "<div class='left-btn'><div class='btn-icon'><div class='icon'></div></div></div>"
						+ "<div class='chap-cont'><div class='chap-cont-list'>"+chapCont+"</div></div>"
						+ "<div class='right-btn'><div class='btn-icon'><div class='icon'></div></div></div>"
						+ "</div>"));
				
				playerObj.playerRoot.append($(this.chapBox));
			}
			
			this.timeArr = timeArr;
			
			// 썸네일 선택
			this.chapBox.find(".chap-thumb").click(function(){
				let from = $(this).attr("from");
				
				if (from != undefined) {
					player.currentTime = parseFloat(from);
					player.play();
				}
				
				$(this).siblings().removeClass("select");
				$(this).addClass("select");
				
				let chapConBox = $(this).parent();
				let leftPos = $(this).position().left - 30;
				let curScroll = chapConBox.scrollLeft();
				
				if (leftPos < 0) {
					chapConBox.scrollLeft(curScroll + leftPos);
				}
				else if ((leftPos + $(this).width() + 8) > chapConBox.width()) {
					chapConBox.scrollLeft(curScroll + (leftPos + $(this).width() - chapConBox.width()) + 8 );
				}
			});
			
			// 썸네일 왼쪽 스크롤
			this.chapBox.find(".left-btn .btn-icon").click(function(){
				let scrollX = playerObj.chapBox.find(".chap-cont-list").scrollLeft() - 94;
				if (scrollX < 0) scrollX = 0;
				playerObj.chapBox.find(".chap-cont-list").scrollLeft(scrollX);
			});
			this.chapBox.find(".left-btn .btn-icon").dblclick(function(event){
				event.stopPropagation();
			});
			
			// 썸네일 오른쪽 스크롤
			this.chapBox.find(".right-btn .btn-icon").click(function(){
				let scrollX = playerObj.chapBox.find(".chap-cont-list").scrollLeft() + 94;
				playerObj.chapBox.find(".chap-cont-list").scrollLeft(scrollX);
			});
			this.chapBox.find(".right-btn .btn-icon").dblclick(function(event){
				event.stopPropagation();
			});
			
			this.chapOver.mouseenter(function(){
				if (playerObj.isShowIndex == true) {
					return;
				}
				
				let menuContainer = playerObj.playerRoot.find(".plyr__controls .plyr__menu__container");
				if (menuContainer.css("display") == "none") {
					playerObj.chapBox.find(".chap-cont-list").css("width", $("#"+playerId).width() - 60);
					playerObj.chapBox.fadeIn();
				}
			});
			
			this.chapBox.mouseleave(function(){
				playerObj.chapBox.fadeOut();
			});
		}
		
		// 스크립트 box 추가
		if (this.enableScript && this.scriptText != "") {
			this.scriptBox = $("<div class='plyr__script-box'></div>")
			this.scriptBox.append($("<div class='script-head'><span class='script-title'>"+playerObj.message('script')+"</span>" 
					+ "<span class='close-btn' title='"+playerObj.message('close')+"'><span class='icon'></span></span></div>"
					+ "<div class='script-body'></div>"));
			this.videoWrapper.append(this.scriptBox);
			
			this.scriptBox.find(".close-btn").click(function(){
				playerObj.showScript();
			});

			this.scriptBox.click(function(event) {
				event.stopPropagation();
			});
			
			this.scriptBox.dblclick(function(event) {
				event.stopPropagation();
			});
			
			this.scriptBox.mousemove(function(event) {
				if (playerObj.player.playing) {
					if (playerObj.backBtn != undefined && playerObj.backBtn != null) {
						playerObj.backBtn.css({opacity:"0",visibility:"hidden"});
					}
					if (playerObj.nextBtn != undefined && playerObj.nextBtn != null) {
						playerObj.nextBtn.css({opacity:"0",visibility:"hidden"});
					}
					if (playerObj.pauseBtn != undefined && playerObj.pauseBtn != null) {
						playerObj.pauseBtn.css({opacity:"0",visibility:"hidden"});
					}
				}
			});
			
			$.ajax({
				type: 'GET',
				dataType: 'text',
			    async: false,
			    url : this.scriptText,
			    timeout: 3000,
				success : function(data){
					data = data.replace(/\r\n/ig, '<br>');
					data = data.replace(/\\n/ig, '<br>');
					data = data.replace(/\n/ig, '<br>');
					playerObj.scriptBox.find(".script-body").html(data);
			    }
			});
		}
		
		// 목차 페이지
		if (this.enablePage) {
			if (this.headerBox.find(".page-btn").length == 0) {
				
				this.headerBox.rightBox.append($("<span class='page-btn' title='"+playerObj.message('index')+"'><span class='icon'></span></span>"));

				// 목차 페이지 버튼 클릭
				this.headerBox.find(".page-btn").click(function(){
					playerObj.showIndex();
				});
			}
			
			for (let i=0; i<this.pageList.length; i++) {
				if (this.showPageNoOpen != true && this.pageList[i].openYn == "N") {
					continue;
				}
				
				let on = "";
				
				if (i == this.curPageNo) {
					if (this.showChapter) {
						on = ' play onchap';
					}
					else {
						on = ' play';
					}
				}
				else if (this.pageList[i].on == true || this.pageList[i].on == 'true') {
					on = ' on';
				}
				
				let chapCont = "";
				if (this.pageList[i].chapterList != null) {
					let chapterList = this.pageList[i].chapterList;
					let timeArr = new Array();
					
					chapCont += "<div  id='"+playerId+"_page"+(i)+"_chap' class='page-chapter "+on+"'>";
					for (let j=0; j<chapterList.length; j++) {
						let min = parseInt(chapterList[j].from / 60);
						let sec = parseInt(chapterList[j].from % 60);
						let time = (min < 10 ? '0'+min : min) + ":" + (sec < 10 ? '0'+sec : sec);
						
						timeArr.push([parseFloat(chapterList[j].from), parseFloat(chapterList[j].to)]);
						chapCont += "<div id='"+playerId+"_page"+(i)+"_idx"+(j+1)+"' class='index-item' from='"+chapterList[j].from+"'><div class='index-desc'>"+chapterList[j].desc+"</div><div class='index-img'><div class='index-time'>"+time+"</div></div></div>";
					}
					chapCont += "</div>";
					
					this.pageList[i].timeArr = timeArr;
				}
				
				let atndMsg = ""; 
				if (this.pageList[i].attendYn == "N") {
					atndMsg = "("+playerObj.message("attendYn")+")"; //(출결대상 아님)
				}
				
				var videoTm = this.timeConvert(this.pageList[i].videoTm); 
				if (this.pageList[i].openYn == "N") {
					videoTm += "&nbsp;&nbsp; OPEN : X";
				}					
				
				// 페이지 아이템
				let pageHead = "<div id='"+playerId+"_page"+(i)+"' idx='"+i+"' class='page-item"+on+"'><div class='page-num'>"
					+ "<div class='progressState' var='"+this.pageList[i].prgrRatio+"' style='--value:"+this.pageList[i].prgrRatio+"' data-value='"+this.pageList[i].prgrRatio+"'><span class='circleLineType'>"+(i+1)+"</span></div>"
					+ "</div>"
					+ "<div class='page-title'><div>"+this.pageList[i].title+"</div>"
					+ "<div class='page-atnd'><span class='page-tm'>"+videoTm+"</span><span class='page-atnd-msg'>"+atndMsg+"</span></div>"
					+ "</div>";
				if (this.pageList[i].chapterList != null) {
					pageHead += "<div class='page-sub'><span class='icon'></span></div>";
				}
				pageHead += "</div>";
				
				this.indexBoxBody.append($(pageHead));
				
				if (this.pageList[i].chapterList != null) {
					this.indexBoxBody.append($(chapCont));
				}
			}
			
			this.indexBoxBody.find(".page-item").click(function(){
				let idx = parseInt($(this).attr("idx"));
				playerObj.changePage(idx);
			});
		}

		if (this.htmlBox == null && this.audio == false) {
			this.htmlBox = $("<div class='plyr__html'></div>");
			this.htmlFrame = $("<iframe class='html_iframe' src='' title='htmlFrame'></iframe>");
			this.htmlBox.append(this.htmlFrame);
			this.htmlBox.append($("<div class='html_bottom'><button class='plyr__extbtn close'>"+playerObj.message('ok')+"</button></div>"));
			this.playerRoot.append(this.htmlBox);
			
			setTimeout(function(){
				playerObj.htmlBox.find(".html_bottom > button.close").click(function(){
					// html 콘텐츠내의 Video 정지
					$.each($(".html_iframe"), function(i, iframe) {
						var iframeDoc = iframe.contentDocument || iframe.contentWindow.document;
						$.each($(iframeDoc).find("video"), function(j, video) {
							video.pause();
						});
					});
					setTimeout(function(){
						playerObj.htmlBox.hide();
						playerObj.changePage(null);
					}, 800)
				});
			}, 800);
		}

		setTimeout(function(){
			if (playerObj.curType != "html") {
				playerObj.videoWrapper.css("aspect-ratio", playerObj.playerRoot.width()+" / "+playerObj.playerRoot.height());
			}
			
			if (playerObj.showProg) {
				playerObj.playerRoot.addClass("show-prog");
			}
		}, 300);
		
		
		// 목차 선택
		if (playerObj.indexBox != null && playerObj.indexBox.find(".index-item").length > 0) {
			playerObj.indexBox.find(".index-item").click(function(){
				let from = $(this).attr("from");
				
				if (from != undefined) {
					player.currentTime = parseFloat(from);
					player.play();
				}
				
				$(this).siblings().removeClass("select");
				$(this).addClass("select");
				
				let idxConBox = $(this).parent();
				let topPos = $(this).position().top - 34;
				let curScroll = idxConBox.scrollTop();
				
				if (topPos < 0) {
					idxConBox.scrollTop(curScroll + topPos);
				}
				else if ((topPos + $(this).height() + 10) > idxConBox.height()) {
					idxConBox.scrollTop(curScroll + (topPos + $(this).height() - idxConBox.height()) + 10);
				}
			});
		}
		
		
		if (this.enablePage) {
			var backBtn = $(this.playerRoot).find("button.page-prev");
			if (backBtn.length == 0) {
				backBtn = $('<button type="button" class="plyr__control plyr__control--overlaid page-prev" data-plyr="prev" aria-label="Prev" title="'+playerObj.message("prevPage")+'"><span class="plyr__sr-only">Prev</span></button>');
				this.playerRoot.append(backBtn);
				this.backBtn = backBtn;
				
				backBtn.click(function(){
					playerObj.changePage(playerObj.curPageNo-1);
				});
			}
			
			var nextBtn = $(this.playerRoot).find("button.page-next");
			if (nextBtn.length == 0) {
				nextBtn = $('<button type="button" class="plyr__control plyr__control--overlaid page-next" data-plyr="next" aria-label="Next" title="'+playerObj.message("nextPage")+'"><span class="plyr__sr-only">Next</span></button>');
				this.playerRoot.append(nextBtn);
				this.nextBtn = nextBtn;
				
				nextBtn.click(function(){
					playerObj.changePage(playerObj.curPageNo+1);
				});
			}
			
			backBtn.prop("disabled", false);
			nextBtn.prop("disabled", false);
			backBtn.removeClass("off");
			nextBtn.removeClass("off");
			
			if (playerObj.curPageNo == 0) {
				backBtn.prop("disabled", true);
				backBtn.addClass("off");
			}
			else if (playerObj.curPageNo == playerObj.pageList.length - 1) {
				nextBtn.prop("disabled", true);
				nextBtn.addClass("off");
			}
		}
		
		// 학습상태 진행바 표시
		if (this.showProg &&  $(this.playerRoot).find(".plyr__prog").length == 0) {
			this.progBox = $("<div class='plyr__prog'><div class='progbg'><span class='progbar' title='"+playerObj.message("progressTitle")+"'></span></div><span class='progicon' title='"+playerObj.message("progressTitle")+"'></span></div>");
			this.videoWrapper.after(this.progBox);
		}
		
		// 목차 기본 표시
		if ((this.enableChapter || this.enablePage) &&  this.onIndex) {
			setTimeout(function(){
				playerObj.showIndex(true);
			}, 300);
		}
		
		// 자막이 있는 경우
		if (this.onCaption) {
			var conBox = $("#MEDIA_"+this.player.playerId).find(".plyr__menu__container");
			var menuBox = $("#"+conBox.attr("id")+"-home").children("div[role=menu]");
			var menu = "";
			menu += '<button data-plyr="settings" type="button" class="plyr__control plyr__control--pressed capSizeBtn" role="menuitem" aria-haspopup="false" onclick="changeCaptionSize(\''+event.detail.plyr.playerId+'\', 0.1)">';
			menu += '	<span>'+playerObj.message("incCapSize")+'</span>';
			menu += '</button>';
			menu += '<button data-plyr="settings" type="button" class="plyr__control plyr__control--pressed capSizeBtn" role="menuitem" aria-haspopup="false" onclick="changeCaptionSize(\''+event.detail.plyr.playerId+'\', -0.1)">';
			menu += '	<span>'+playerObj.message("decCapSize")+'</span>';
			menu += '</button>';
			menu += '<button data-plyr="settings" type="button" class="plyr__control plyr__control--pressed" role="menuitem" aria-haspopup="false" onclick="changeCaptionColor(\''+event.detail.plyr.playerId+'\')">';
			menu += '	<span>'+playerObj.message("capColor")+'</span>';
			menu += '	<span class="caption-status">';
			menu += '		<span class="plyr__badge">'+playerObj.message("captions")+'</span>';
			menu += '	</span>';
			menu += '</button>';
			menuBox.append(menu); 
		}
		
		var plyrConf = localStorage.getItem("plyr");
		if (plyrConf != null) {
			let confData = JSON.parse(plyrConf);
			if (confData.captionSize != null && confData.captionSize != undefined) {
				PLYR_CAP_SIZE = confData.captionSize;
				$("#MEDIA_"+this.player.playerId).find(".plyr__captions").css("font-size", PLYR_CAP_SIZE+"em");
			}
			
			if(this.onCaption && confData.captionColor) {
				changeCaptionColor(event.detail.plyr.playerId, confData.captionColor);
			}
		}
		
		playerObj.playerRoot.focus();
	}
	
	
	// 목차 표시
	playerObj.showIndex = function(type) {
		let vidWidth = this.playerRoot.width();
		
		if (type == true) {
			if (vidWidth > 620) {
				this.playerRoot.addClass("show-extbox");
			}
			this.indexBox.show();
			this.isShowExtbox = true;
			this.isShowIndex = true;
		}
		else {
			if (this.scriptBox != null) {
				this.scriptBox.hide();
			}
			
			if (this.indexBox.css("display") == "none") {
				if (vidWidth > 620) {
					this.playerRoot.addClass("show-extbox");
				}
				this.indexBox.show();
				this.isShowExtbox = true;
				this.isShowIndex = true;
			}
			else {
				this.playerRoot.removeClass("show-extbox");
				this.indexBox.hide();
				this.isShowExtbox = false;
				this.isShowIndex = false;
			}
		}
	}
	
	
	// 스크립트 표시
	playerObj.showScript = function() {
		if (playerObj.indexBox != null && playerObj.indexBox.css("display") != "none") {
			playerObj.indexBox.hide();
			playerObj.isShowIndex = false;
		}
		
		if (!playerObj.scriptBox.is(':visible')) {
			playerObj.playerRoot.addClass("show-extbox");
			playerObj.scriptBox.show();
			playerObj.isShowExtbox = true;
		}
		else {
			playerObj.playerRoot.removeClass("show-extbox");
			playerObj.scriptBox.hide();
			playerObj.isShowExtbox = false;
		}
	}
	
	
	// 페이지 선택
	playerObj.changePage = function(idx, init) {
		if(playerObj.player.captions && playerObj.player.captions.hasOwnProperty("currentTrack")) {
			playerObj.player.captions.currentTrack = -1;
		}
		
		if (idx > -1 && idx == playerObj.curPageNo) {
			var chapBox = $("#"+this.player.playerId+"_page"+idx+"_chap");
			if (chapBox.length > 0) {
				if (chapBox.is(':visible')) {
					chapBox.hide();
					$("#"+this.player.playerId+"_page"+idx).removeClass("onchap");
				}
				else {
					chapBox.show();
					$("#"+this.player.playerId+"_page"+idx).addClass("onchap");
				}
			}
			
			return;
		}
		
		playerObj.startReady = true;
		
		if (idx == -1) {
			idx = null;
			playerObj.startReady = false;
		}
		
		if (init == true) {
			playerObj.startReady = false;
		}
		
		if (idx == null) {
			idx = playerObj.curPageNo + 1;
			if (idx == playerObj.pageList.length) {
				idx = 0;
				playerObj.startReady = false;
			}
			else if (playerObj.pageList.length <= idx) {
				playerObj.curPageNo = -1;
				return;
			}
		}
		
		if (playerObj.scriptBox != null && playerObj.scriptBox.is(':visible')) {
			playerObj.playerRoot.removeClass("show-extbox");
			playerObj.scriptBox.hide();
			playerObj.isShowExtbox = false;
		}
		
		if (playerObj.enablePage && playerObj.curPageNo != -1) {
			let sessionLoc = playerObj.player.currentTime;
			if (sessionLoc >= playerObj.player.duration-5) {
				sessionLoc = 0;
			}
			
			playerObj.pageList[playerObj.curPageNo].sessionLoc = sessionLoc;
		}
		
		if (playerObj.curType == "video" && playerObj.player != null) {
			playerObj.player.pause();
		}
		
		this.enableScript = false;
		this.scriptText = "";
		let page = playerObj.pageList[idx];
		
		// html 콘텐츠내의 Video 정지
		$.each($(".html_iframe"), function(i, iframe) {
			var iframeDoc = iframe.contentDocument || iframe.contentWindow.document;
			$.each($(iframeDoc).find("video"), function(j, video) {
				video.pause();
			});
		});
		
		if (page.type == "video" || page.type == "video/mp4") {
			setTimeout(function(){
				playerObj.curType = "video";
				if (playerObj.htmlBox != null) {
					playerObj.htmlBox.hide();
				}
				
				let source = {type:'video', sources:page.src};
				if (page.tracks != undefined) {
					source["tracks"] = page.tracks;
				}
				
				playerObj.player.source = source;
				playerObj.checkContinue = false;
				
				if (page.sessionLoc != "") {
					setTimeout(function(){
						playerObj.player.currentTime = parseFloat(page.sessionLoc);
					}, 500);
				}
				
				if (page.scriptText != undefined && page.scriptText != "") {
					playerObj.enableScript = true;
					playerObj.scriptText = page.scriptText;
				}
				
				page.on = true;
				playerObj.curPageNo = idx;
			},100);
		}
		else if (page.type == "html") {
			playerObj.curType = "html";
			playerObj.headerBox.show();
			
			let w = playerObj.playerRoot.width();
			let h = playerObj.playerRoot.height();
			
			playerObj.player.source = {type:'video', sources:[{src:'',type: 'video/mp4'}]};
			playerObj.htmlFrame.attr("src", page.src);
			playerObj.htmlBox.show();
			playerObj.curPageNo = idx;
			
			setTimeout(function(){
				playerObj.videoWrapper.css("aspect-ratio", w+" / "+h);
			},100);
		}
		
		playerObj.headerBox.titleBox.html(playerObj.title+" > "+page.title);
	}
	
	// 학습 진행바 업데이트
	playerObj.setProgbar = function(prog) {
		if (this.showProg && this.progBox != null) {
			var progBar = this.progBox.find(".progbar");
			var progIcon = this.progBox.find(".progicon");
			
			if(prog <= 100) {
				progBar.css("width", +prog+"%");
				progIcon.css("left", "calc("+prog+"% - "+(prog == 100 ? 18 : 18)+"px)");
			}
		}
	}
	
	// 도움말 표시
	playerObj.showHelp = function() {
		if (!playerObj.helpBox.is(':visible')) {
			playerObj.helpBox.show();
		}
		else {
			playerObj.helpBox.hide();
		}
	}
	
	
	// 메시지
	playerObj.message = function(code) {
		return UiMediaPlayer_lang[playerObj.lang][code];
	}
	
	// 이어보기 Confirm
	playerObj.continueConfirm = function(message) {
		var defer = $.Deferred();
		
		if (playerObj.confirmBox == null) {
			playerObj.confirmBox = $("<div></div>");
			$("body").append(playerObj.confirmBox);
		}

		var width = 400;
		var bodyWidth = $("body").width();
		if (width > bodyWidth - 20) {
			width = bodyWidth - 20;
		}
		
		var content = "<div class='confirm-content' style='padding:1em;text-align:center;font-size:1.1em'>"
			+ "<div class='confirm-text'>"+message+"</div>"
			+"</div>";
		
		playerObj.confirmBox.html(content);
		
		var confirmDialog = $(playerObj.confirmBox).dialog({
			width: width,
			modal: true,
			resizable: false,
			"buttons": [
				{
					text: playerObj.message('yes'),
					click:function() {$(this).dialog("close"); defer.resolve(true);}
				},
				{
					tabIndex: -1,
					text: playerObj.message('no'),
					click:function() {$(this).dialog("close"); defer.resolve(false);}
				}
			],
			open: function(event, ui){
				$(this).parent().find('.ui-dialog-title').html(playerObj.message('continuePlay'));
				$(this).parent().find('.ui-dialog-titlebar').children("button").remove();
			},
	        close: function() {
	        	$(this).html("");
	        }
		});
		
		return defer.promise();
	}	
	
	playerObj.timeConvert = function(time) {
		let timeStr = (time > 60 ? parseInt(time / 60) : 0) + ":";
		timeStr += parseInt(time % 60) < 10 ? "0" : "";
		timeStr += parseInt(time % 60);
		return timeStr;
	}
	
	playerObj.init();
	
	setTimeout(function(){
		var inputRange = $(".plyr input[type=range]");
		if (inputRange.length > 0) {
			for(var i=0; i<inputRange.length; i++) {
				var id = $(inputRange[i]).prop("id");
				if (id != null) {
					$(inputRange[i]).after($("<label for='"+id+"' class='hide'></lable>"));
				}
				else {
					$(inputRange[i]).attr("id", "plyrInputRange"+i);
					$(inputRange[i]).after($("<label for='plyrInputRange"+i+"' class='hide'></lable>"));
				}
			}
		}
	},500);
	
	return playerObj;
}


// 자막 사이즈 변경
let PLYR_CAP_SIZE = 1.2;
function changeCaptionSize(id, type) {
	var newSize = Math.round((PLYR_CAP_SIZE + type) * 10) / 10;
	if (newSize < 0.8 || newSize > 2.5) {
		return;
	}
	
	PLYR_CAP_SIZE = Math.round((PLYR_CAP_SIZE + type) * 10) / 10;
	$("#MEDIA_"+id).find(".plyr__captions").css("font-size", PLYR_CAP_SIZE+"em");
	
	var plyrConf = localStorage.getItem("plyr");
	if (plyrConf != null) {
		let confData = JSON.parse(plyrConf);
		confData.captionSize = PLYR_CAP_SIZE;
		localStorage.setItem("plyr", JSON.stringify(confData));
	}
}

// 자막 색상변경
function changeCaptionColor(id, paramColor) {
	let color = "white";
	
	if(paramColor) {
		if(paramColor == "yellow") {
			$("#MEDIA_"+id).find(".plyr__captions").removeClass("yellow-caption").addClass("yellow-caption");
		}
	} else {
		$("#MEDIA_"+id).find(".plyr__captions").toggleClass("yellow-caption");
	}
	
	if($("#MEDIA_"+id).find(".plyr__captions").hasClass("yellow-caption")) {
		color = "yellow";
	} else {
		color = "white";
	}
	
	$(".caption-status > .plyr__badge").css("color", color);
		
	let plyrConf = localStorage.getItem("plyr");
	if (plyrConf != null) {
		let confData = JSON.parse(plyrConf);
		confData.captionColor = color;
		localStorage.setItem("plyr", JSON.stringify(confData));
	}
}

// 플레이어 언어
const UiMediaPlayer_lang = {
	ko : {
	    restart: '재시작',
	    rewind: '되감기 ({seektime}초 전)',
	    play: '플레이',
	    pause: '일시정지',
	    fastForward: '빨리감기 ({seektime}초 후)',
	    seek: 'Seek',
	    seekLabel: '{currentTime} / {duration}',
	    played: '재생 완료',
	    buffered: '버퍼링 완료',
	    currentTime: '재생 위치',
	    duration: '동영상 길이',
	    volume: '볼륨',
	    mute: '음소거',
	    unmute: '음소거 종료',
	    enableCaptions: '자막 켜기',
	    disableCaptions: '자막 끄기',
	    download: '다운로드',
	    enterFullscreen: '전체 화면',
	    exitFullscreen: '전체 화면 종료',
	    frameTitle: '{title} 플레이어',
	    captions: '자막',
	    settings: '설정',
	    pip: '화면 속 화면',
	    menuBack: '이전 메뉴로 이동',
	    speed: '재생 속도',
	    normal: '보통',
	    quality: '비디오 품질',
	    loop: '반복',
	    start: '시작',
	    end: '종료',
	    all: '전체',
	    reset: '초기화',
	    disabled: '비활성',
	    enabled: '활성',
	    advertisement: 'Ad',
	    qualityBadge: {
	      2160: '초고화질',
	      1440: '고화질',
	      1080: '고화질',
	      720: '고화질',
	      576: '저화질',
	      560: '저화질',
	      480: '저화질',
	      360: '저화질'
	    },
	    script: '스크립트',
	    index: '목차',
	    continueMsg: '이전에 시청했던 {time}부터 이어서 보시겠습니까?',
	    close: '닫기',
	    ok: '확인',
	    cancel: '취소',
	    yes: '예',
	    no: '아니오',
	    prevPage: '이전 페이지',
	    nextPage: '다음 페이지',
	    help: '도움말',
	    helpKey: 'Key',
	    helpAction: '동작',
	    helpSpace: '플레이/일시중지',
	    helpRewind: '되감기 (10초 전)',
	    helpForward: '빨리감기 (10초 후)',
	    helpVolumeUp: '볼륨 크게',
	    helpVolumeDown: '볼륨 작게',
	    helpFullscreen: '전체 화면',
	    helpMute: '음소거',
	    helpCaption: '자막',
	    helpSpeedNormal: '재생속도 보통(1배속)',
	    helpSpeedUp: '재생속도 빠르게',
	    helpSpeedDown: '재생속도 느리게',
	    progressTitle: '학습 진행률',
	    progressTitleCmnt: '(권장학습시간 대비 플레이한 시간의 비율)',
	    continuePlay: '이어보기',
	    attendYn: '출결대상 아님',
		incCapSize: '자막크기 증가 +',
		decCapSize: '자막크기 축소 -',
		capColor: '자막색상 변경',
	},
	en : {
	    restart: 'Restart',
	    rewind: 'Rewind (-{seektime}s)',
	    play: 'Play',
	    pause: 'Pause',
	    fastForward: 'Forward (+{seektime}s)',
	    seek: 'Seek',
	    seekLabel: '{currentTime} of {duration}',
	    played: 'Played',
	    buffered: 'Buffered',
	    currentTime: 'Current time',
	    duration: 'Duration',
	    volume: 'Volume',
	    mute: 'Mute',
	    unmute: 'Unmute',
	    enableCaptions: 'Enable captions',
	    disableCaptions: 'Disable captions',
	    download: 'Download',
	    enterFullscreen: 'Enter fullscreen',
	    exitFullscreen: 'Exit fullscreen',
	    frameTitle: 'Player for {title}',
	    captions: 'Captions',
	    settings: 'Settings',
	    pip: 'PIP',
	    menuBack: 'Go back to previous menu',
	    speed: 'Speed',
	    normal: 'Normal',
	    quality: 'Quality',
	    loop: 'Loop',
	    start: 'Start',
	    end: 'End',
	    all: 'All',
	    reset: 'Reset',
	    disabled: 'Disabled',
	    enabled: 'Enabled',
	    advertisement: 'Ad',
	    qualityBadge: {
	      2160: '4K',
	      1440: 'HD',
	      1080: 'HD',
	      720: 'HD',
	      576: 'SD',
	      560: 'SD',
	      480: 'SD',
	      360: 'SD'
	    },
	    script: 'Script',
	    index: 'Index',
	    continueMsg: 'Would you like to continue watching {time} from the previous one?',
	    close: 'Close',
	    ok: 'OK',
	    cancel: 'Cancel',
	    yes: 'Yes',
	    no: 'No',
	    prevPage: 'Previous Page',
	    nextPage: 'Next Page',
	    help: 'Help',
    	helpKey: 'Key',
	    helpAction: 'Action',
	    helpSpace: 'Toggle playback',
	    helpRewind: 'Rewind (-10s)',
	    helpForward: 'Forward (+10s)',
	    helpVolumeUp: 'Increase volume',
	    helpVolumeDown: 'Decrease volume',
	    helpFullscreen: 'Toggle fullscreen',
	    helpMute: 'Toggle mute',
	    helpCaption: 'Toggle captions',
	    helpSpeedNormal: 'Play normal speed(1x)',
	    helpSpeedUp: 'Play speed up',
	    helpSpeedDown: 'Play speed down',
	    progressTitle: 'Learning progress',
	    progressTitleCmnt: '(Percentage of time played versus recommended time)',
	    continuePlay: 'Continue play',
	    attendYn: 'Not attendance',
		incCapSize: 'Increase caption size +',
		decCapSize: 'Reduce caption size -',
		capColor: 'Change caption Color',
	}
};
