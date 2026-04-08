package knou.lms.smnr.pltfrm.zoom.api.users;

import org.springframework.http.HttpMethod;

import knou.lms.smnr.pltfrm.zoom.api.common.ZoomApiUrl;

public enum UsersUrl implements ZoomApiUrl {

	/** API URL : /users/me */
	GET_OWNER_INFO(HttpMethod.GET, "/users/me"),
	/** API URL : /users */
    LIST_USERS(HttpMethod.GET, "/users"),
    /** API URL : /users/{userId} */
    GET_A_USER(HttpMethod.GET, "/users/%s"),
    /** API URL : /users */
    CREATE_A_USER(HttpMethod.POST, "/users"),
    /** API URL : /users/{userId} */
    UPDATE_A_USER(HttpMethod.PATCH, "/users/%s"),
    /** API URL : /users/{userId} */
    DELETE_A_USER(HttpMethod.DELETE, "/users/%s");

    private final HttpMethod method;
    private final String url;

    UsersUrl(HttpMethod method, String url) {
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

    // userId 필요한 경우
    public String getUrl(String userId) {
        return ZOOM_API_URL + String.format(url, userId);
    }

}
