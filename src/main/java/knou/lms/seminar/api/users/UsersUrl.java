package knou.lms.seminar.api.users;

import org.springframework.http.HttpMethod;

import knou.lms.seminar.api.common.ZoomApiUrl;

public enum UsersUrl implements ZoomApiUrl {
    
    /** API URL : /users */
    CREATE_USERS(HttpMethod.POST, "/users"),
    /** API URL : /users */
    LIST_USERS(HttpMethod.GET, "/users"),
    /** API URL : /users/{userId} */
    DELETE_A_USER(HttpMethod.DELETE, "/users/%s"),
    /** API URL : /users/{userId} */
    UPDATE_A_USER(HttpMethod.PATCH, "/users/%s"),
    /** API URL : /users/{userId} */
    GET_A_USER(HttpMethod.GET, "/users/%s"),
    /** API URL : /users/email */
    CHECK_A_USER_EMAIL(HttpMethod.GET, "/users/email"),
    /** API URL : /users/{userId}/settings */
    GET_USERS_SETTINGS(HttpMethod.GET, "/users/%s/settings"),
    /** API URL :/users/{userId}/password */
    UPDATE_A_USERS_PASSWORD(HttpMethod.PUT, "/users/%s/password");

    private HttpMethod method;
    private String url;
    
    private UsersUrl(HttpMethod method, String url) {
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
