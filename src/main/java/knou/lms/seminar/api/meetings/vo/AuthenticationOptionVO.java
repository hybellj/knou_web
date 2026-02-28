package knou.lms.seminar.api.meetings.vo;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonProperty;

public class AuthenticationOptionVO implements Serializable {

    private static final long serialVersionUID = -7824872386687081861L;
    @JsonProperty("id")
    private String id;
    @JsonProperty("type")
    private String type;
    @JsonProperty("domains")
    private String domains;
    @JsonProperty("name")
    private String name;

    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }
    public String getType() {
        return type;
    }
    public void setType(String type) {
        this.type = type;
    }
    public String getDomains() {
        return domains;
    }
    public void setDomains(String domains) {
        this.domains = domains;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    
    @Override
    public String toString() {
        return "AuthenticationOptionVO [id=" + id + ", type=" + type + ", domains=" + domains + ", name=" + name + "]";
    }

}
