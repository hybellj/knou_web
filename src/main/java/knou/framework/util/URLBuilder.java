package knou.framework.util;


import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import knou.framework.common.CommConst;
import knou.framework.exception.EncodingException;



public class URLBuilder {

	private final StringBuilder builder;
	private String url;
	String encoding;

	private final Log logger = LogFactory.getLog(this.getClass());

	public URLBuilder() {
		builder = new StringBuilder();
		this.encoding = CommConst.ENCODING_SYSTEM;
	}
	
	public URLBuilder(String url) {
		this.url = url;
		builder = new StringBuilder();
		this.encoding = CommConst.ENCODING_SYSTEM;
	}
	public URLBuilder(String contextName, String url,HttpServletRequest request) {
		//this.url = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/" + contextName + url;
		
		if (url.indexOf("/"+contextName+"/") == 0) {
			this.url = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + url;
		}
		else {
			this.url = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/" + contextName + url;
		}

		builder = new StringBuilder();
		this.encoding = CommConst.ENCODING_SYSTEM;
	}
	
	public URLBuilder setUrl(String url) {
		this.url = url;
		return this;
	}

	public String getEncoding(){
		return this.encoding;
	}
	public void setEncoding(String encoding){
		this.encoding = encoding;
	}

	public URLBuilder addParameter(String parameterName, Object value) {
		return addParameter(parameterName, value, "");
	}
	
	public URLBuilder addParameter(String parameterName, Object value, String defaultValue) {
		StringBuilder localBuilder = makeForehead(parameterName);

		if( ValidationUtils.isNotNull(value))
			localBuilder.append(encode(String.valueOf(value)));
		else if(ValidationUtils.isNotNull(defaultValue))
			localBuilder.append(encode(defaultValue));
		else
			return this;
		builder.append(localBuilder.toString());
		return this;
	}

	private String encode(String string)  {
		try {
			return URLEncoder.encode(string, encoding);
		} catch (UnsupportedEncodingException e) {
			if(logger.isDebugEnabled()){
				logger.debug("[Uniedu]encoding field's value is: <" + encoding + ">");
			}
			throw new EncodingException();
		}
	}

	private StringBuilder makeForehead(String parameterName) {
		StringBuilder localBuilder = new StringBuilder();

		if(builder.length() > 0)
			localBuilder.append("&");
		else
			localBuilder.append("?");

		localBuilder.append(parameterName);
		localBuilder.append("=");
		return localBuilder;
	}

	@Override
	public String toString() {
		if (StringUtil.isNull(url)) return "";
		
		return url + builder.toString();
	}
	
	/**
	 * 전체 URL을 다시 URLEncode처리해서 반환한다.
	 * 파라매터 구분자와 같은 정보도 포함해서 인코딩할 수 있다.
	 * @return
	 */
	public String toStringWithEncode() {
		try {
			return URLEncoder.encode(this.toString(), this.encoding);
		} catch (UnsupportedEncodingException ex) {
			return "";
		}
	}
}
