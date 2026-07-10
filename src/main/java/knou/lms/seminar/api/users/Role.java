package knou.lms.seminar.api.users;

// by jinkoon
@Deprecated
public enum Role {
    
    OWNER("Owner"),
    ADMIN("Admin"),
    MEMBER("Member");
    
    private String roleName;

    private Role(String roleName) {
        this.roleName = roleName;
    }

    public String getRoleName() {
        return roleName;
    }

}
