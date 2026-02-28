package knou.lms.seminar.api.reports;

import org.springframework.http.HttpMethod;

import knou.lms.seminar.api.common.ZoomApiUrl;

public enum ReportsUrl implements ZoomApiUrl {
    
    /** API URL : /report/meetings/{meetingId}/participants */
    GET_MEETING_PARTICIPANT_REPORTS(HttpMethod.GET, "/report/meetings/%s/participants");
    
    private HttpMethod method;
    private String url;

    private ReportsUrl(HttpMethod method, String url) {
        this.method = method;
        this.url = url;
    }

    @Override
    public HttpMethod getMethod() {
        return method;
    }

    @Override
    public String getUrl() {
        return ZOOM_API_URL + url;
    }

}
