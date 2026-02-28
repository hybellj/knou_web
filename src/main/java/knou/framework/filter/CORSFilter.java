package knou.framework.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;

@Component
public class CORSFilter implements Filter{
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest request = (HttpServletRequest) req;
		HttpServletResponse response = (HttpServletResponse) res;
		
		response.setHeader("Access-Control-Allow-Methods", "POST, GET");
		response.setHeader("Access-Control-Max-Age", "3600");
		response.setHeader("Access-Control-Allow-Headers", "x-requested-with");

		String method = request.getMethod();
		if ("TRACE".equalsIgnoreCase(method)) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Method not allowed");
            return;
        }
		
		response.setHeader("Access-Control-Allow-Origin", "*");
		response.setHeader("Allow", "POST, GET, HEAD, OPTIONS");
		response.setHeader("Cache-Control", "no-cache");
		response.setHeader("Pragma", "no-cache");
		response.setHeader("Expires", "0");
		chain.doFilter(req, res);
	}
	
	public void init(FilterConfig filterConfig) {
		// Initial filter
	}

	public void destroy() {
		// destroy filter
	}
}
