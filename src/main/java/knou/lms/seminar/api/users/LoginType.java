package knou.lms.seminar.api.users;

public enum LoginType {
    
    FACEBOOK(0),
    GOOGLE(1),
    API(99),
    ZOOM(100),
    SSO(101);

    private int type;

    private LoginType(int type) {
        this.type = type;
    }

    public int getType() {
        return type;
    }

}
