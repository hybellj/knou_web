package knou.lms.smnr.pltfrm.zoom.api.common;

import org.springframework.http.HttpMethod;

public interface ZoomApiUrl {
	public static final String ZOOM_API_URL = "https://api.zoom.us/v2";
	public static final String ZOOM_TOKEN_URL = "https://zoom.us/oauth/token";

	public HttpMethod getMethod();

    public String getUrl();
}
