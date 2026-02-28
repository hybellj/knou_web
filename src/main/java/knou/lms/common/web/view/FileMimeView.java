package knou.lms.common.web.view;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;

/**
 * mime-type 값에 저장된 정보에 맞춰서 처리되는 뷰.
 * @author SungKook
 */
public class FileMimeView extends AbstractView {

	private final Log log = LogFactory.getLog(getClass());
	
	public FileMimeView(){
		this.setContentType("application/octet-stream");
	}
	
	@Override
	protected void renderMergedOutputModel(Map<String, Object> model,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		File file = (File)model.get("downloadFile");
		String mimeType = (String)model.get("mime-type");
		
		OutputStream out = response.getOutputStream();
		FileInputStream fis = null;
		
		try {
			response.setContentType(mimeType);
			response.setContentLength((int) file.length());
			fis = new FileInputStream(file);
			FileCopyUtils.copy(fis, out);
			
			fis.close();
			out.flush();
			out.close();
		} catch (IOException ioe) {
			log.warn("File not fount. cause : " + ioe.getLocalizedMessage());
		} finally {
			if( out != null ) out.close();
			if( fis != null ) fis.close();
		}
	}

}
