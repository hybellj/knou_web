package knou.lms.seminar.api.users;

public enum Action {

    CREATE("create"),
    AUTO_CREATE("autoCreate"),
    CUST_CREATE("custCreate"),
    SSO_CREATE("ssoCreate");
    
    private Action(String action) {
        this.action = action;
    }
    private String action;

    public String getAction() {
        return action;
    }
    
}
