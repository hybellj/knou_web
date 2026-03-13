package knou.framework.taglib;

import java.io.IOException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * HTML Editor 태그
 */
public class HtmlEditorTag extends TagSupport {
	private static final long serialVersionUID = 9216972039111953258L;
	private static Log log = LogFactory.getLog(HtmlEditorTag.class);

	private String id;						// textarea 아이디
	private String name;					// textarea 이름
	private String value;					// textarea 내용 (기존값)
	private String uploadPath;				// 파일업로드 경로 (이미지,동영상)
	private boolean videoUpload = false;	// 동영상 업로드 가능 여부 (true/false)
	private int uploadMaxSize = 0;			// 최대업로드 용량
	private String width;					// 에디터 너비(%, px), 기본값 100%
	private String height;					// 에디터 높이(%, px), 기본값 400px
	private boolean required = false;		// 필수입력 여부(true/false, 기본값:false)


	public int doEndTag() throws JspException{
		try {
			StringBuilder tag = new StringBuilder();

			tag.append("<label for=\""+id+"\" class=\"hide\">Content</label>\n");
			tag.append("<textarea name=\""+name+"\" id=\""+id+"\" "+(required ? "required=\"true\"" : "")+">");
			tag.append(value);
			tag.append("</textarea>\n");
			tag.append("<script>");
			tag.append("let "+id+"_editor = UiEditor({\n");
			tag.append("targetId:\""+id+"\",\n");
			tag.append("uploadPath:\""+uploadPath+"\",\n");

			if (uploadMaxSize > 0) {
				tag.append("uploadMaxSize:"+uploadMaxSize+",\n");
			}
			if (videoUpload) {
				tag.append("videoUpload:"+videoUpload+",\n");
			}
			if (width != null && !"".equals(width)) {
				tag.append("width:\""+videoUpload+"\",\n");
			}
			if (height != null && !"".equals(height)) {
				tag.append("height:\""+height+"\",\n");
			}

			tag.append("});\n");
			tag.append("</script>");

			pageContext.getOut().println(tag.toString());
		}
		catch (IOException e) {
			log.error(e.getMessage());
		}

		return EVAL_PAGE;
	}



	public void setId(String id) {
		this.id = id;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public void setUploadPath(String uploadPath) {
		this.uploadPath = uploadPath;
	}

	public boolean isVideoUpload() {
		return videoUpload;
	}

	public void setVideoUpload(boolean videoUpload) {
		this.videoUpload = videoUpload;
	}

	public void setWidth(String width) {
		this.width = width;
	}

	public void setHeight(String height) {
		this.height = height;
	}

	public void setRequired(boolean required) {
		this.required = required;
	}
}
