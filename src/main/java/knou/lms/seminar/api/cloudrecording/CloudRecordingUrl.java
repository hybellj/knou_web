package knou.lms.seminar.api.cloudrecording;

import org.springframework.http.HttpMethod;

import knou.lms.seminar.api.common.ZoomApiUrl;

public enum CloudRecordingUrl implements ZoomApiUrl {
    
    /** API URL : /meetings/{meetingId}/recordings/settings */
    GET_MEETING_RECORDING_SETTINGS(HttpMethod.GET, "/meetings/%s/recordings/settings"),
    /** API URL : /accounts/{accountId}/recordings */
    LIST_RECORDINGS_OF_AN_ACCOUNT(HttpMethod.GET, "/accounts/%s/recordings"),
    /** API URL : /meetings/{meetingId}/recordings */
    GET_MEETING_RECORDINGS(HttpMethod.GET, "/meetings/%s/recordings"),
    /** API URL : /user/{userId}/recordings */
    GET_LIST_ALL_RECORDINGS(HttpMethod.GET, "/users/%s/recordings");

    private HttpMethod method;
    private String url;

    private CloudRecordingUrl(HttpMethod method, String url) {
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
