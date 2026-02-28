package knou.lms.seminar.api.common.vo;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonProperty;

public class CustomKeyVO implements Serializable {

    private static final long serialVersionUID = -556901477671384102L;
    @JsonProperty("key")
    private String key;
    @JsonProperty("value")
    private String value;
    
    public String getKey() {
        return key;
    }
    public void setKey(String key) {
        this.key = key;
    }
    public String getValue() {
        return value;
    }
    public void setValue(String value) {
        this.value = value;
    }

}
