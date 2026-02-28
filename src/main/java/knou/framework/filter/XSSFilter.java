package knou.framework.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

public class XSSFilter implements Filter{
	@Override
	public void destroy() {
		// destroy filter
	}

	@Override
	public void doFilter(ServletRequest paramServletRequest, ServletResponse paramServletResponse, FilterChain paramFilterChain) throws IOException, ServletException {
		XSSRequest request = new XSSRequest(paramServletRequest);
		paramFilterChain.doFilter(request, paramServletResponse);
	}

	@Override
	public void init(FilterConfig paramFilterConfig) throws ServletException {
		// initial filter
	}
}
