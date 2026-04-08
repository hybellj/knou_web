package knou.lms.smnr.pltfrm.zoom.api.users.vo;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonProperty;

public class ZoomUserVO implements Serializable {

	private static final long serialVersionUID = -4288006262021919999L;

	@JsonProperty("id")
    private String id;

    @JsonProperty("email")
    private String email;

    @JsonProperty("type")
    private int type;

    @JsonProperty("status")
    private String status;

    public String getId() {
    	return id;
    }
    public void setId(String id) {
    	this.id = id;
    }
    public String getEmail() {
    	return email;
    }
    public void setEmail(String email) {
    	this.email = email;
    }
    public int getType() {
    	return type;
    }
    public void setType(int type) {
    	this.type = type;
    }
    public String getStatus() {
    	return status;
    }
    public void setStatus(String status) {
    	this.status = status;
    }
}
