package knou.framework.taglib;

import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import knou.framework.common.Message;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.FileUtil;
import knou.framework.util.JsonUtil;
import knou.framework.util.SecureUtil;
import knou.lms.file.vo.AtflVO;

/**
 * 파일 다운로드 태그
 */
public class FileDownloadTag extends TagSupport {
	private static final long serialVersionUID = 1L;
	private static Log log = LogFactory.getLog(FileDownloadTag.class);

	private AtflVO atflVO = null;
	private List<AtflVO> fileList = null;

	public int doEndTag() throws JspException {
		try {
			StringBuffer tag = new StringBuffer();
            Message message = new Message((HttpServletRequest)(this.pageContext).getRequest());

			if (atflVO != null) {
				if (fileList == null) {
					fileList = new ArrayList<AtflVO>();
				}

				fileList.add(atflVO);
			}

			if (fileList != null && fileList.size() > 0) {
				tag.append("<ul class='add_file'>");

				for (AtflVO vo : fileList) {
					tag.append("<li>");
					tag.append("<a href='#_' class='file_down' onclick='UiFileDownloader(\""+vo.getEncDownParam()+"\");return false;' title='File download'>");
					tag.append("<i class='icon-svg-paperclip' aria-hidden='true'></i>");
					tag.append("<span class='text'>"+vo.getFilenm()+"</span>");
					tag.append("<span class='fileSize'>("+FileUtil.getFileSizeConvertKByte(vo.getFileSize())+")</span>");
					tag.append("</a>");
					tag.append("<span class='link'>");
					tag.append("<button class='btn s_basic down' onclick='UiFileDownloader(\""+vo.getEncDownParam()+"\");return false;'>"+message.getMessage("button.download")+"</button>");
					tag.append("</span>");
					tag.append("</a>");
					tag.append("</li>");
				}

				tag.append("</ul>");
			}

			pageContext.getOut().print(tag);
		} catch (Exception e) {
			log.error(e.getMessage());
		}

		return EVAL_PAGE;
	}

	public void setAtflVO(AtflVO atflVO) {
		this.atflVO = atflVO;
	}

	public void setFileList(List<AtflVO> fileList) {
		this.fileList = fileList;
	}

}
