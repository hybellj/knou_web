package knou.lms.seminar.api.cloudrecording.vo;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonProperty;

public class RecordingSettingsVO implements Serializable {

    private static final long serialVersionUID = -5485498748413922462L;
    
    @JsonProperty("password")
    private String password;

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
    
}
