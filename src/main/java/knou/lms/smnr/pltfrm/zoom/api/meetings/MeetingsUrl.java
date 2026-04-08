package knou.lms.smnr.pltfrm.zoom.api.meetings;

import org.springframework.http.HttpMethod;

import knou.lms.smnr.pltfrm.zoom.api.common.ZoomApiUrl;

public enum MeetingsUrl implements ZoomApiUrl {

	/** API URL : /users/{userId}/meetings */
    LIST_MEETINGS(HttpMethod.GET, "/users/%s/meetings"),
    /** API URL : /meetings/{meetingId} */
    GET_A_MEETING(HttpMethod.GET, "/meetings/%s"),
    /** API URL : /meetings/{meetingId} */
    GET_PAST_MEETING(HttpMethod.GET, "/past_meetings/%s"),
    /** API URL : /users/{userId}/meetings */
    CREATE_A_MEETING(HttpMethod.POST, "/users/%s/meetings"),
    /** API URL : /meetings/{meetingId} */
    UPDATE_A_MEETING(HttpMethod.PATCH, "/meetings/%s"),
    /** API URL : /meetings/{meetingId} */
    DELETE_A_MEETING(HttpMethod.DELETE, "/meetings/%s"),
    /** API URL : /meetings/{meetingId}/registrants */
    LIST_MEETING_REGISTRANTS(HttpMethod.GET, "/meetings/%s/registrants"),
    /** API URL : /meetings/{meetingId}/registrants/{registrantId} */
    GET_A_MEETING_REGISTRANT(HttpMethod.GET, "/meetings/%s/registrants/%s"),
    /** API URL : /meetings/{meetingId}/registrants */
    ADD_MEETING_REGISTRANT(HttpMethod.POST, "/meetings/%s/registrants"),
    /** API URL : /meetings/{meetingId}/registrants/{registrantId} */
    DELETE_A_MEETING_REGISTRANT(HttpMethod.DELETE, "/meetings/%s/registrants/%s");

    private final HttpMethod method;
    private final String url;

    MeetingsUrl(HttpMethod method, String url) {
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

    // meetingId 1개
    public String getUrl(String meetingId) {
        return ZOOM_API_URL + String.format(url, meetingId);
    }

    // meetingId + registrantId 또는 userId + meetingId
    public String getUrl(String id1, String id2) {
        return ZOOM_API_URL + String.format(url, id1, id2);
    }

}