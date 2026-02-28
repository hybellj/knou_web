package knou.lms.seminar.api.reports.vo;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonProperty;

public class ParticipantVO implements Serializable {

    private static final long serialVersionUID = 2522282338747123939L;
    
    @JsonProperty("customer_key")
    private String customerKey;
    @JsonProperty("duration")
    private String duration;
    @JsonProperty("failover")
    private String failover;
    @JsonProperty("id")
    private String id;
    @JsonProperty("join_time")
    private String joinTime;
    @JsonProperty("leave_time")
    private String leaveTime;
    @JsonProperty("name")
    private String name;
    @JsonProperty("registrant_id")
    private String registrantId;
    @JsonProperty("user_email")
    private String userEmail;
    @JsonProperty("user_id")
    private String userId;
    @JsonProperty("status")
    private String status;
    @JsonProperty("bo_mtg_id")
    private String boMtgId;
    
    public String getCustomerKey() {
        return customerKey;
    }
    public void setCustomerKey(String customerKey) {
        this.customerKey = customerKey;
    }
    public String getDuration() {
        return duration;
    }
    public void setDuration(String duration) {
        this.duration = duration;
    }
    public String getFailover() {
        return failover;
    }
    public void setFailover(String failover) {
        this.failover = failover;
    }
    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }
    public String getJoinTime() {
        return joinTime;
    }
    public void setJoinTime(String joinTime) {
        this.joinTime = joinTime;
    }
    public String getLeaveTime() {
        return leaveTime;
    }
    public void setLeaveTime(String leaveTime) {
        this.leaveTime = leaveTime;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getRegistrantId() {
        return registrantId;
    }
    public void setRegistrantId(String registrantId) {
        this.registrantId = registrantId;
    }
    public String getUserEmail() {
        return userEmail;
    }
    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }
    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }
    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }
    public String getBoMtgId() {
        return boMtgId;
    }
    public void setBoMtgId(String boMtgId) {
        this.boMtgId = boMtgId;
    }
    
    @Override
    public String toString() {
        return "ParticipantVO [customerKey=" + customerKey + ", duration=" + duration + ", failover=" + failover
                + ", id=" + id + ", joinTime=" + joinTime + ", leaveTime=" + leaveTime + ", name=" + name
                + ", registrantId=" + registrantId + ", userEmail=" + userEmail + ", userId=" + userId + ", status="
                + status + ", boMtgId=" + boMtgId + "]";
    }

}
