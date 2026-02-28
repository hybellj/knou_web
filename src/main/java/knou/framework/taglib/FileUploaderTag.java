package knou.framework.taglib;

import java.util.List;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import knou.framework.common.CommConst;
import knou.framework.util.TaglibUtil;
import knou.framework.vo.FileVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 파일 업로더
 *
 */
public class FileUploaderTag extends TagSupport {
	private static final long serialVersionUID = 1L;
	private static Log log = LogFactory.getLog(FileUploaderTag.class);

	private String uploaderName		= "fileUploader";	// 업로더 객체명
	private String target			= "";	// 업로더 객체 대상(위치)
	private String url				= CommConst.PAGE_FILE_UPLOAD;	// 서버 URL
	private String path				= "";	// 서버 경로
	private int limitCount			= 0;	// 업로드 가능 파일 수
	private int limitSize			= 0;	// 업로드 가능 파일 사이즈 합계(MB)
	private int oneLimitSize		= 1024;	// 파일 한개당 최대 크기 (MB, 기본값:1024)
	private int listSize 			= 0;	// 파일목록 표시수 (창크기)
	private String allowedTypes		= "*";	// 업로드 가능 타입 (확장명만 입력, 구분자[,], 전체:*)
	private String notAllowedTypes	= "";	// 업로드 금지 타입 (생략시 기본값 설정, 확장명만 입력, 구분자[,])
	private String uploadMessage	= "";	// 안내 메시지 (메시지코드 or 메시지)
	private String finishFunc		= "finishUpload";	// 업로드 종료시 호출할 함수명
	private boolean useFileBox    = false; // 파일함 사용여부
	private boolean onTopMessage	= true;	// Top 메시지 표시 여부
	private List<FileVO> fileList  = null;


	public int doEndTag() throws JspException {
		try {
			StringBuffer tag = new StringBuffer();
            JSONArray fileObjArray = new JSONArray();
            String oldFiles = "";

			if (fileList != null && fileList.size() > 0) {
                FileVO fileVO = null;
                JSONObject fileObj = null;

                for (int i=0; i < fileList.size(); i++) {
                    fileVO = (FileVO)fileList.get(i);
                    fileObj = new JSONObject();
                    fileObj.put("fileNm", fileVO.getFileNm());
                    fileObj.put("fileId", fileVO.getFileId());
                    fileObj.put("fileSize", fileVO.getFileSize());
                    fileObjArray.add(fileObj);
                }

                oldFiles = fileObjArray.toString().replaceAll("\"", "\\\\\"");
            }

			tag.append("<script type=\"text/javascript\">\n");
			tag.append("let "+uploaderName+" 		= UiFileUploader('"+target+"', '"+uploaderName+"');\n");
			tag.append(uploaderName+".url 			= \""+TaglibUtil.getContextPath(pageContext)+url+"\";\n");
			tag.append(uploaderName+".path 			= \""+path+"\";\n");
			tag.append(uploaderName+".limitCount	= "+limitCount+";\n");
			tag.append(uploaderName+".limitSize		= "+limitSize+";\n");
			tag.append(uploaderName+".oneLimitSize	= "+oneLimitSize+";\n");
			tag.append(uploaderName+".listSize		= "+listSize+";\n");
			tag.append(uploaderName+".allowedTypes	= \""+allowedTypes+"\";\n");
			if (!notAllowedTypes.equals("")) {
				tag.append(uploaderName+".notAllowedTypes = \""+notAllowedTypes+"\";\n");
			}
			tag.append(uploaderName+".uploadMessage	= \""+uploadMessage+"\";\n");
			if (!onTopMessage) {
				tag.append(uploaderName+".onTopMessage 	= "+onTopMessage+";\n");
			}
			if (fileList != null && fileList.size() > 0) {
			    tag.append(uploaderName+".oldFiles  = \""+ oldFiles +"\";\n");
			}
			tag.append(uploaderName+".finishFunc	= \""+finishFunc+"\";\n");
			tag.append(uploaderName+".useFileBox   = "+useFileBox+";\n");

			tag.append(uploaderName+".init();\n");
			tag.append("</script>\n");

			pageContext.getOut().println(tag.toString());
		} catch (Exception e) {
			log.error(e.getMessage());
		}

		return EVAL_PAGE;
	}



	public void setUploaderName(String uploaderName) {
		this.uploaderName = uploaderName;
	}

	public void setTarget(String target) {
		this.target = target;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public void setLimitCount(int limitCount) {
		this.limitCount = limitCount;
	}

	public void setLimitSize(int limitSize) {
		this.limitSize = limitSize;
	}

	public void setOneLimitSize(int oneLimitSize) {
		this.oneLimitSize = oneLimitSize;
	}

	public void setListSize(int listSize) {
		this.listSize = listSize;
	}

	public void setAllowedTypes(String allowedTypes) {
		this.allowedTypes = allowedTypes;
	}

	public void setNotAllowedTypes(String notAllowedTypes) {
		this.notAllowedTypes = notAllowedTypes;
	}

	public void setUploadMessage(String uploadMessage) {
		this.uploadMessage = uploadMessage;
	}

	public void setFinishFunc(String finishFunc) {
		this.finishFunc = finishFunc;
	}

	public void setOnTopMessage(boolean onTopMessage) {
		this.onTopMessage = onTopMessage;
	}

    public void setFileList(List<FileVO> fileList) {
        this.fileList = fileList;
    }

    public void setUseFileBox(boolean useFileBox) {
        this.useFileBox = useFileBox;
    }

}
