
/**
 * 파일 다운로더
 *
 * @param encParams		첨부파일정보 암호화 파라메터
 * @param filePath		파일경로
 */
function UiFileDownloader(encParams) {
	let downloadUrl = "/common/downloadFile.do";	// 다운로드 URL
	let downloadFrame = $("#file_download_iframe");	// 다운로드 iframe

	if (downloadFrame.length === 0) {
		$("body").append($("<iframe id='file_download_iframe' name='file_download_iframe' title='Download frame' style='visibility:hidden;width:0;height:0;position:absolute;top:0;left:0;' src=''></iframe>"));
	}

	downloadUrl += "?encParams="+encParams;
	$("#file_download_iframe").attr("src", downloadUrl);
}