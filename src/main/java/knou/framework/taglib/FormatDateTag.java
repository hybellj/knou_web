package knou.framework.taglib;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.TagSupport;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import knou.framework.util.LocaleUtil;


/**
 * 날짜/시간 포맷
 *
 * value : 문자열(yyyyMMddHHmmss) 또는 Date
 * type : 출력형식
 * 		date(날짜) : "yyyy-MM-dd"
 * 		time(시간) : "HH:mm:ss"
 * 		datetime(날짜시간) : "yyyy-MM-dd HH:mm:ss"
 */
public class FormatDateTag extends TagSupport {
	private static final long serialVersionUID = 7464535428125890961L;
	private static Log log = LogFactory.getLog(FormatDateTag.class);

	private static final String DATE_PATTEN_KO = "yyyy-MM-dd";
	private static final String DATE_PATTEN_EN = "MM-dd-yyyy";
	private static final String TIME_PATTEN = "HH:mm:ss";

	private Object value;
	private String type;

	public int doEndTag() throws JspException{
		try {
			PageContext context = this.pageContext;
			HttpServletRequest req = (HttpServletRequest)context.getRequest();
			String lang = LocaleUtil.getLocale(req).toString();
			String formatted = "";

			if (value == null) {
				formatted = "";
			}
			else {
				String dateValue = "";
				String datePtn = "yyyyMMddHHmmss";
				String dateFormat = "en".equals(lang) ? DATE_PATTEN_EN : DATE_PATTEN_KO;

				if (value instanceof String) {
					dateValue = value.toString().replaceAll("\\D", "");
				}
				else if (value instanceof Date) {
					dateValue = (new SimpleDateFormat("yyyyMMddHHmmss")).format((Date)value);
				}

				if (dateValue.length() < 14 && dateValue.length() >= 8) {
					datePtn = "yyyyMMdd";
				}

				if ("time".equals(type)) {
					dateFormat = TIME_PATTEN;
				}
				else if ("datetime".equals(type)) {
					dateFormat += " " + TIME_PATTEN;
				}

				DateTimeFormatter inputFmt = DateTimeFormatter.ofPattern(datePtn);
				LocalDateTime dateTime = LocalDateTime.parse(dateValue, inputFmt);
				formatted = dateTime.format(DateTimeFormatter.ofPattern(dateFormat));
			}

			pageContext.getOut().println(formatted);
		}
		catch (Exception e) {
			log.error(e.getMessage());
		}

		return EVAL_PAGE;
	}


	public void setValue(Object value) {
		this.value = value;
	}

	public void setType(String type) {
		this.type = type;
	}

}
