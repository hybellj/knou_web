package knou.lms.seminar.api.common;

import org.springframework.http.HttpMethod;

public interface ZoomApiUrl {

    public static final String ZOOM_API_URL = "https://api.zoom.us/v2";
    
    public HttpMethod getMethod();
    
    public String getUrl();
    
}
