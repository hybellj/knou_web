package knou.lms.seminar.api.meetings.vo;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonProperty;

public class RegistrantsVO implements Serializable {

    private static final long serialVersionUID = 3843125772914025161L;
    @JsonProperty("email")
    private String email;
    @JsonProperty("first_name")
    private String firstName;
    @JsonProperty("last_name")
    private String lastName;
    @JsonProperty("auto_approve")
    private boolean autoApprove = true;
    @JsonProperty("join_url")
    private String joinUrl;
    @JsonProperty("registrant_id")
    private String registrantId;
    
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getFirstName() {
        return firstName;
    }
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }
    public String getLastName() {
        return lastName;
    }
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
    public boolean isAutoApprove() {
        return autoApprove;
    }
    public void setAutoApprove(boolean autoApprove) {
        this.autoApprove = autoApprove;
    }
    public String getJoinUrl() {
        return joinUrl;
    }
    public void setJoinUrl(String joinUrl) {
        this.joinUrl = joinUrl;
    }
    public String getRegistrantId() {
        return registrantId;
    }
    public void setRegistrantId(String registrantId) {
        this.registrantId = registrantId;
    }
    
    @Override
    public String toString() {
        return "RegistrantsVO [email=" + email + ", firstName=" + firstName + ", lastName=" + lastName
                + ", autoApprove=" + autoApprove + ", joinUrl=" + joinUrl + ", registrantId=" + registrantId + "]";
    }

}
