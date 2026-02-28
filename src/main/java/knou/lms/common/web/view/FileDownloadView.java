package knou.lms.common.web.view;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;

public class FileDownloadView extends AbstractView {

	private final static String UTF8_TYPE = "text/html;charset=UTF-8";
	private final static String FILE_NOT_FOUND = "파일이 존재하지 않습니다.";

	public FileDownloadView(){
		this.setContentType("application/octet-stream");
	}

	@Override
	protected void renderMergedOutputModel(Map<String, Object> model,
			HttpServletRequest request, HttpServletResponse response) throws Exception {

		File file = (File)model.get("downloadFile");

		if(isFileNotFound(file))
			execFileDownloadFailed(response);
		else
			execFileDownload(model, request, response, file);
	}

	private boolean isFileNotFound(File file) {
		return file == null || !file.exists();
	}

	private void execFileDownloadFailed(HttpServletResponse response)
			throws IOException {
		// Error Message를 핸들링 해서 PrintWriter를 이용해서 알려준다.
		response.setContentType(UTF8_TYPE);

		PrintWriter pw = response.getWriter();
		StringBuffer msg = new StringBuffer();
		msg.append("<SCRIPT LANGUAGE='JavaScript'>")
			.append("	alert('" + FILE_NOT_FOUND + "');")
			.append("</SCRIPT>");

		pw.write(msg.toString());
		pw.flush();
	}

	private void execFileDownload(Map<String, Object> model,
			HttpServletRequest request, HttpServletResponse response, File file)
			throws Exception, IOException {
		String disposition = getDisposition((String)model.get("fileName"), getBrowser(request));

		response.setHeader("Content-disposition", disposition);
		//response.setHeader("Content-Disposition", "attachment;filename=" + (String)model.get("fileName") + ";");
		response.setHeader("Content-Transfer-Encoding", "binary");

		response.setContentType(getContentType());
		response.setContentLength((int) file.length());

		response.setHeader("Pragma", "no-cache;");
		response.setHeader("Expires", "-1;");

		OutputStream out = response.getOutputStream();
		FileInputStream fis = null;

		try {
			fis = new FileInputStream(file);
			FileCopyUtils.copy(fis, out);
			out.flush();
			out.close();
		} catch (Exception e) {
			//e.printStackTrace();	// 파일 다운로드를 취소하는 경우..
		} finally {
			try { if( out != null ) out.close(); } catch (Exception e) { }
			try { if( fis != null ) fis.close(); } catch (Exception e) { }
		}
	}

    /**
     * 해더에서 브라우져 정보를 구한다.
     * 2016.02.11 IE11 버전의 한글 파일 다운로드 문제로 수정 : header.indexOf("Trident")>0 추가
     * @param request
     * @return "MSIE" or "Chrome" or "Opera" or "Firefox"
     *
     */
	private String getBrowser(HttpServletRequest request) {
		String header = request.getHeader("User-Agent");
		if (header.indexOf("MSIE") > -1 || header.indexOf("Trident")>0 ) {
			return "MSIE";
		} else if (header.indexOf("Chrome") > -1) {
			return "Chrome";
		} else if (header.indexOf("Opera") > -1) {
			return "Opera";
		}
		return "Firefox";
	}


	/**
	 * 해더에 필요한 Content-disposition 문자열을 생성한다.
	 * @param filename : 파일 이름
	 * @param browser : 브라우져 정보 getBrowser() 를 사용
	 * @return : Content-disposition 에 해당되는 문자열
	 * @throws Exception 지원되지 않는 브라우져일 경우 발생한다.
	 */
	private String getDisposition(String filename, String browser) throws Exception {
		String dispositionPrefix = "attachment;filename=";
		String encodedFilename = null;
		if (browser.equals("MSIE")) {
			encodedFilename =
				URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
		} else if (browser.equals("Firefox")) {
			encodedFilename =
				"\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Opera")) {
			encodedFilename =

			"\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Chrome")) {
			StringBuffer sb = new StringBuffer();
			for (int i = 0; i < filename.length(); i++) {
				char c = filename.charAt(i);
				if (c > '~') {
					sb.append(URLEncoder.encode("" + c, "UTF-8"));
				} else {
					sb.append(c);
				}
			}
			encodedFilename = sb.toString();
		} else {
			throw new RuntimeException("Not supported browser");
		}

		return dispositionPrefix + encodedFilename;
	}


}
