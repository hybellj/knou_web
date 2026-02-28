package knou.lms.seminar.api.users;

public enum UserType {

    BASIC(1),
    LICENSED(2),
    ON_PREM(3),
    NONE(99); // this can only be set with ssoCreate
    
    private int userType;

    private UserType(int userType) {
        this.userType = userType;
    }

    public int getUserType() {
        return userType;
    }
    
}
