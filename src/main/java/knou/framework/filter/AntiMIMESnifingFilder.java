package knou.framework.filter;

import java.io.IOException;
import java.util.logging.LogRecord;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;


public class AntiMIMESnifingFilder implements Filter{
	protected final Log log = LogFactory.getLog(this.getClass());
	
	@Override
	public void destroy() {
		// destroy filter
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;

		res.addHeader("X-XSS-Protection", "1; mode=block");

		res.addHeader("X-Content-Type-Options", "nosniff");
		chain.doFilter(req,res);
	}

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		// initial filter
	}


	public boolean isLoggable(LogRecord logRecord) {
		if (logRecord != null) {
			log.debug(logRecord.getMessage());
		}
		
		return false;
	}

}

