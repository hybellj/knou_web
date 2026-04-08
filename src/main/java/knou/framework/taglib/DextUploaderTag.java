package knou.framework.taglib;

import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.TagSupport;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import knou.framework.common.CommConst;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.lms.file.vo.AtflVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * DEXT 파일 업로더
 *
 */
public class DextUploaderTag extends TagSupport {
	private static final long serialVersionUID = 1L;
	private static Log log = LogFactory.getLog(DextUploaderTag.class);

	private String		id				= "";		// 업로더ID
	private String		url				= "";		// 서버 URL
	private String		path			= "";		// 서버 경로
	private String		lang			= "";		// 언어 (생략시 세션 기본값 적용됨)
	private int 		limitCount		= 1;		// 업로드 가능 파일 수
	private int		limitSize		= 100;		// 업로드 가능 파일 사이즈 합계(MB, 기본값:100Mb)
	private int		oneLimitSize	= 100;		// 파일 한개당 최대 크기 (MB, 기본값:100Mb)
	private int		listSize 		= 1;		// 파일목록 표시수 (창크기)
	private String		allowedTypes	= "*";		// 업로드 가능 타입 (확장명만 입력, 구분자[,], 전체:*)
	private String		notAllowedTypes	= "";		// 업로드 금지 타입 (생략시 기본값 설정, 확장명만 입력, 구분자[,])
	private String		finishFunc		= "";		// 업로드 종료시 호출할 함수명(()는 생략하고 함수명만 입력), finishUpload(id) 와 같이 id 전달
	private boolean	bigSize			= false; 	// 대용량 업로드 ( 생략시 기본값 설정)
	private String		uiMode			= "normal"; // UI 모드 (normal, simple, single)
	private List<AtflVO> fileList  		= null;		// 기존 업로드된 파일 목록(수정화면에서 사용)


	public int doEndTag() throws JspException {
		try {
			StringBuffer tag = new StringBuffer();
			PageContext context = this.pageContext;
            HttpServletRequest req = (HttpServletRequest)context.getRequest();

            JSONArray fileObjArray = new JSONArray();
            String oldFiles = "[]";

			if (fileList != null && fileList.size() > 0) {
                JSONObject fileObj = null;

                for (AtflVO atflVO : fileList) {
                	fileObj = new JSONObject();
                    fileObj.put("fileNm", atflVO.getFilenm());
                    fileObj.put("fileId", atflVO.getAtflId());
                    fileObj.put("fileSize", atflVO.getFileSize());
                    fileObjArray.add(fileObj);
                }

                oldFiles = fileObjArray.toString();
            }

			String language = LocaleUtil.getLocale(req).toString();
			if (!"".equals(StringUtil.nvl(lang))) {
				language = lang;
			}

			String uploadMode = "ORAF";
			if (bigSize) {
				uploadMode = "EXNJ";
			}

			String uploadUrl = "";
			if ("".equals(StringUtil.nvl(url))) {
			    if("EXNJ".equals(uploadMode)) {
			        uploadUrl = CommConst.DEXT_FILE_BULK_UPLOAD;
			    } else {
			        uploadUrl = CommConst.DEXT_FILE_UPLOAD;
			    }
			}

			String extensionFilter = "*";
			if (!"".equals(StringUtil.nvl(allowedTypes))) {
				extensionFilter = allowedTypes.replace(",",";");
				String exts[] = extensionFilter.split(";");

				if (exts.length > 0) {
					extensionFilter = "";

					for (int i=0; i<exts.length; i++) {
						if (i > 0) {
							extensionFilter += ";";
						}

						if (exts[i].indexOf(".") > -1) {
							extensionFilter += exts[i];
						}
						else if ("*".equals(exts[i])) {
							extensionFilter += "*";
						}
						else {
							extensionFilter += "*." + exts[i];
						}
					}
				}
			}


			String noExtension = notAllowedTypes;
			if ("".equals(StringUtil.nvl(noExtension))) {
				noExtension = (Arrays.toString(CommConst.UPLOAD_NO_EXTS)).replace("[","").replace("]","").replace(" ","");
			}

			if (finishFunc.indexOf("()") > -1) {
				finishFunc = finishFunc.replace("()", "");
			}

			tag.append("<div id=\""+id+"_box\"></div>\n");
			tag.append("<script>\n");
			tag.append("UiFileUploader({\n");
			tag.append("id:\""+id+"\",\n");
			tag.append("targetId:\""+id+"_box\",\n");
			tag.append("lang:\""+language+"\",\n");
			tag.append("listSize:"+listSize+",\n");
			tag.append("limitSize:"+limitSize+",\n");
			tag.append("oneLimitSize:"+oneLimitSize+",\n");
			tag.append("allowedTypes:\""+extensionFilter+"\",\n");
			tag.append("noExtension:\""+noExtension+"\",\n");
			tag.append("finishFunc:"+finishFunc+",\n");
			tag.append("uploadUrl:\""+uploadUrl+"\",\n");
			tag.append("path:\""+path+"\",\n");
			tag.append("limitCount:"+limitCount+",\n");
			tag.append("fileList:"+oldFiles+",\n");
			tag.append("uiMode:\""+uiMode+"\"\n");
			tag.append("});\n");
			tag.append("</script>");

			pageContext.getOut().print(tag);
		} catch (Exception e) {
			log.error(e.getMessage());
		}

		return EVAL_PAGE;
	}



	public void setId(String id) {
		this.id = id;
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

	public void setFinishFunc(String finishFunc) {
		this.finishFunc = finishFunc;
	}

    public void setFileList(List<AtflVO> fileList) {
        this.fileList = fileList;
    }

	public void setLang(String lang) {
		this.lang = lang;
	}

	public void setBigSize(boolean bigSize) {
		this.bigSize = bigSize;
	}

	public void setUiMode(String uiMode) {
		this.uiMode = uiMode;
	}

}
