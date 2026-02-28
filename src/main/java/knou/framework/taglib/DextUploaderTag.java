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
import knou.framework.common.Message;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.lms.file.vo.AtflVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * DEXT 파일 업로더
 *
 * @author shil
 */
public class DextUploaderTag extends TagSupport {
	private static final long serialVersionUID = 1L;
	private static Log log = LogFactory.getLog(DextUploaderTag.class);

	private String id				= "";	// 업로더ID
	private String type				= "";	// 타입 (기본:"", 실습과제:PRACTICE)
	private String url				= "";	// 서버 URL
	private String path				= "";	// 서버 경로
	private int limitCount			= 0;	// 업로드 가능 파일 수
	private int limitSize			= 0;	// 업로드 가능 파일 사이즈 합계(MB)
	private int oneLimitSize		= 1024;	// 파일 한개당 최대 크기 (MB, 기본값:1024)
	private int listSize 			= 1;	// 파일목록 표시수 (창크기)
	private String allowedTypes		= "*";	// 업로드 가능 타입 (확장명만 입력, 구분자[,], 전체:*)
	private String notAllowedTypes	= "";	// 업로드 금지 타입 (생략시 기본값 설정, 확장명만 입력, 구분자[,])
	private String finishFunc		= "finishUpload()";	// 업로드 종료시 호출할 함수명
	private boolean useFileBox		= false; // 파일함 사용여부
	private boolean bigSize		= false; // 대용량 업로드
	private String lang				= "";
	private String style			= "list";	// list, single
	private String uiMode			= "normal"; // normal, simple
	private List<AtflVO> fileList  = null;


	public int doEndTag() throws JspException {
		try {
			StringBuffer tag = new StringBuffer();
			PageContext context = this.pageContext;
            HttpServletRequest req = (HttpServletRequest)context.getRequest();
            Message message = new Message(req);

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
			        uploadUrl = CommConst.PRODUCT_DOMAIN + CommConst.DEXT_FILE_BULK_UPLOAD;
			    } else {
			        uploadUrl = CommConst.PRODUCT_DOMAIN + CommConst.DEXT_FILE_UPLOAD;
			    }
			}
			else {
				uploadUrl = url;
				if (uploadUrl.indexOf("http") == -1) {
					uploadUrl = CommConst.PRODUCT_DOMAIN + uploadUrl;
				}
			}

			if (uploadUrl.indexOf("type=") == -1) {
				if (uploadUrl.indexOf("?") == -1) {
					uploadUrl += "?type="+type;
				}
				else {
					uploadUrl += "&type="+type;
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

			int height = 72 + (listSize * 36);
			if ("single".equals(style)) {
				height = 35;
			}
			if ("simple".equals(uiMode)) {
				height = (listSize * 36);
			}

			String cssStyle = "width:100%;height:"+height+"px;";
			String btnAareaStyle = "";
			String btnClass = "dext5-btn-area";
			String btnStyle = "";
			String resetStyle = "display:none";

			if ("simple".equals(uiMode)) {
				cssStyle += "display:flex";
				btnAareaStyle = "display:flex";
				btnClass += " simple";
				btnStyle = "height:"+height+"px;";
			}

			tag.append("<div id=\""+id+"-container\" class=\"dext5-container\" style=\""+cssStyle+"\"></div>\n");

			if (!"single".equals(style)) {
				if (fileList != null && fileList.size() > 0) {
					resetStyle = "display:inline-block";
				}

				tag.append("<div id=\""+id+"-btn-area\" class=\""+btnClass+"\" style=\""+btnAareaStyle+"\">");

				if ("simple".equals(uiMode)) {
					tag.append("<button type=\"button\" id=\""+id+"_btn-add\" style=\""+btnStyle+"\" title=\""+message.getMessage("button.select.file")+"\"><i class='xi-file-add-o'></i></button>");

					if (useFileBox) {
						tag.append("<button type=\"button\" id=\""+id+"_btn-filebox\" style=\""+btnStyle+"\" title=\""+message.getMessage("button.from_filebox")+"\"><i class='xi-folder-o'></i></button>");
					}
					tag.append("<button type=\"button\" id=\""+id+"_btn-delete\" disabled='true' style=\""+btnStyle+"\" title=\""+message.getMessage("button.delete")+"\"><i class='xi-trash-o'></i></button>");
					tag.append("<button type=\"button\" id=\""+id+"_btn-reset\" style=\""+btnStyle+resetStyle+"\" title=\""+message.getMessage("button.reset")+"\" onclick=\"resetDextFiles('"+id+"')\"><i class='xi-refresh'></i></button>");
				}
				else {
					tag.append("<button type=\"button\" id=\""+id+"_btn-add\" style=\""+btnStyle+"\" title=\""+message.getMessage("button.select.file")+"\">"+ message.getMessage("button.select.file") +"</button>");
					if (useFileBox) {
						tag.append("<button type=\"button\" id=\""+id+"_btn-filebox\" style=\""+btnStyle+"\" title=\""+message.getMessage("button.from_filebox")+"\">"+ message.getMessage("button.from_filebox") +"</button>");
					}
					tag.append("<button type=\"button\" id=\""+id+"_btn-delete\" disabled='true' style=\""+btnStyle+"\" title=\""+message.getMessage("button.delete")+"\">"+ message.getMessage("button.delete") +"</button>");
					tag.append("<button type=\"button\" id=\""+id+"_btn-reset\" style=\""+btnStyle+resetStyle+"\" title=\""+message.getMessage("button.reset")+"\" onclick=\"resetDextFiles('"+id+"')\"><i class='xi-refresh'></i></button>");
				}

				tag.append("</div>\n");
			}

			tag.append("<script>\n");
			tag.append("UiFileUploader({\n");
			tag.append("id:\""+id+"\",\n");
			tag.append("parentId:\""+id+"-container\",\n");
			tag.append("btnFile:\""+id+"_btn-add\",\n");
			tag.append("btnDelete:\""+id+"_btn-delete\",\n");
			tag.append("lang:\""+language+"\",\n");
			tag.append("uploadMode:\""+uploadMode+"\",\n");
			tag.append("maxTotalSize:"+limitSize+",\n");
			tag.append("maxFileSize:"+oneLimitSize+",\n");
			tag.append("extensionFilter:\""+extensionFilter+"\",\n");
			tag.append("noExtension:\""+noExtension+"\",\n");
			tag.append("finishFunc:\""+finishFunc+"\",\n");
			tag.append("uploadUrl:\""+uploadUrl+"\",\n");
			tag.append("path:\""+path+"\",\n");
			if (!"single".equals(style)) {
				tag.append("fileCount:"+limitCount+",\n");
				tag.append("oldFiles:"+oldFiles+",\n");
			}
			tag.append("useFileBox:"+useFileBox+",\n");
			tag.append("style:\""+style+"\",\n");
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

    public void setUseFileBox(boolean useFileBox) {
        this.useFileBox = useFileBox;
    }

	public void setLang(String lang) {
		this.lang = lang;
	}

	public void setType(String type) {
		this.type = type;
	}

	public void setBigSize(boolean bigSize) {
		this.bigSize = bigSize;
	}

	public void setStyle(String style) {
		this.style = style;
	}

	public void setUiMode(String uiMode) {
		this.uiMode = uiMode;
	}

}
