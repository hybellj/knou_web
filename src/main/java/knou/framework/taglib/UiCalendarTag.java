package knou.framework.taglib;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.TagSupport;

import knou.framework.common.Message;
import knou.framework.util.StringUtil;

/**
 * 달력/시간/분 선택 태그
 *
 * @author Mediopiatech
 */
public class UiCalendarTag extends TagSupport {
	private static final long serialVersionUID = 1L;
	private String dateId;
	private String hourId;
	private String minId;
	private String rangeType;
	private String rangeTarget;
	private String value;

	public int doEndTag() throws JspException {

        try {
            PageContext context = this.pageContext;
            HttpServletRequest req = (HttpServletRequest)context.getRequest();
            Message message = new Message(req);
            value = StringUtil.nvl(value).replace(".","").replace("-","").replace(" ","").replace(":","");
            String msg = "";
            String range = "";
            String tag = "";
            
            rangeType = StringUtil.nvl(rangeType);
            rangeTarget = StringUtil.nvl(rangeTarget);

            if (rangeType.equals("start")) {
                range += "endCalendar";
                rangeType = "rangestart";
                msg = message.getMessage("common.date.start");
            }
            else if (rangeType.equals("end")) {
                range += "startCalendar";
                rangeType = "rangeend";
                msg = message.getMessage("common.date.end");
            }
            else {
                msg = message.getMessage("common.date");
            }
            
            rangeTarget = StringUtil.nvl(rangeTarget);
            if (!"".equals(rangeTarget) && !"".equals(range)) {
                range += ","+rangeTarget+"_cal";
            }
            if (!"".equals(range)) {
                range = "range='"+range+"'";
            }
            
            tag += "<div class='ui calendar "+rangeType+" w150 mr5' id='"+dateId+"_cal' "+range+" dateval='"+value+"'>";
            tag += "<div class='ui input left icon'>";
            tag += "<i class='calendar alternate outline icon'></i>";
            tag += "<input type='text' id='"+dateId+"' name='"+dateId+"' placeholder='"+msg+"' value='"+value+"' title='"+msg+"'>";
            tag += "</div>";
            tag += "</div>";

            if (!"".equals(StringUtil.nvl(hourId))) {
                msg = message.getMessage("date.hour");

                tag += "<select id='"+hourId+"' caltype='hour' class='ui dropdown list-num flex0 mr5 m-w70' title='"+msg+"'>";
                tag += "<option value=' '>"+msg+"</option>";
                
                for (int i = 0; i <= 23; i++) {
                    tag += "<option value='"+(i<10 ? "0"+i : i)+"'>"+(i<10 ? "0"+i : i)+"</option>";
                }
                
                tag += "</select>";
            }
            
            if (!"".equals(StringUtil.nvl(minId))) {
                msg = message.getMessage("date.minute");
                tag += "<select id='"+minId+"' caltype='min' class='ui dropdown list-num flex0 mr5 m-w70' title='"+msg+"'>";
                tag += "<option value=' '>"+msg+"</option>";
                
                for (int i = 0; i <= 55; i+=5) {
                    tag += "<option value='"+(i<10 ? "0"+i : i)+"'>"+(i<10 ? "0"+i : i)+"</option>";
                }
                
                tag += "</select>";
            }

            pageContext.getOut().print(tag);
        } 
        catch (IOException ignored) { }
        
        return EVAL_PAGE;
    }

    public void setDateId(String dateId) {
        this.dateId = dateId;
    }

    public void setRangeType(String rangeType) {
        this.rangeType = rangeType;
    }

    public void setRangeTarget(String rangeTarget) {
        this.rangeTarget = rangeTarget;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public void setHourId(String hourId) {
        this.hourId = hourId;
    }

    public void setMinId(String minId) {
        this.minId = minId;
    }
}
