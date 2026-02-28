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

import knou.framework.common.MainOrgInfo;
import knou.framework.common.SessionInfo;


public class ClickjackFilter implements Filter{
	protected final Log log = LogFactory.getLog(this.getClass());
    private String mode = "DENY";

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
    		FilterChain chain) throws IOException, ServletException {
        HttpServletResponse res = (HttpServletResponse)response;
        
        
        HttpServletRequest req = (HttpServletRequest)request;
        String uri = req.getRequestURI();
        String orgDomain = "";
        
        // URI가 타기관접근인 경우 메인화면의 로그인 페이지로 이동
        if (!SessionInfo.isLogin(req) && !uri.equals("/") && uri.indexOf(".") == -1) {
        	orgDomain = MainOrgInfo.getOrgDomain(req);
        	if (!"".equals(orgDomain)) {
        		res.sendRedirect("/index.do?org="+orgDomain);
        		return;
        	}
        }
        else if (SessionInfo.isLogin(req) && !uri.equals("/") && uri.indexOf(".") == -1) {
        	orgDomain = MainOrgInfo.getOrgDomain(req);
        	if (!"".equals(orgDomain)) {
        		res.sendRedirect("/dashboard/main.do");
        		return;
        	}
        }
        
        res.addHeader("X-FRAME-OPTIONS", mode );
        chain.doFilter(request, res);
    }

    @Override
    public void destroy() {
    	// destroy filter
    }

    @Override
    public void init(FilterConfig filterConfig) {
        String configMode = filterConfig.getInitParameter("mode");
        if ( configMode != null ) {
            mode = configMode;
        }
    }

    public boolean isLoggable(LogRecord logRecord) {
		if (logRecord != null) {
			log.debug(logRecord.getMessage());
		}
		
		return false;
	}

}
