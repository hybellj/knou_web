package knou.lms.smnr.pltfrm.zoom.api.meetings.vo;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class ZoomRegistrantVO implements Serializable {

	private static final long serialVersionUID = -1670322820013191149L;

	/** 사전등록자 ID (응답) */
    @JsonProperty("registrant_id")
    private String registrantId;

    /** 미팅 ID (응답) */
    @JsonProperty("id")
    private Long id;

    /** 이메일 (필수) */
    @JsonProperty("email")
    private String email;

    /** 이름 (필수) */
    @JsonProperty("first_name")
    private String firstName;

    /** 성 */
    @JsonProperty("last_name")
    private String lastName;

    /** 승인타입 0=자동승인, 1=수동승인, 2=등록불필요 */
    @JsonProperty("approval_type")
    private int approvalType = 0;  // 자동승인 (기본값)

    /** 참가 URL (응답) */
    @JsonProperty("join_url")
    private String joinUrl;

    /** 주제 (응답) */
    @JsonProperty("topic")
    private String topic;

    /** 시작일시 (응답) */
    @JsonProperty("start_time")
    private String startTime;

	public String getRegistrantId() {
		return registrantId;
	}

	public Long getId() {
		return id;
	}

	public String getEmail() {
		return email;
	}

	public String getFirstName() {
		return firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public int getApprovalType() {
		return approvalType;
	}

	public String getJoinUrl() {
		return joinUrl;
	}

	public String getTopic() {
		return topic;
	}

	public String getStartTime() {
		return startTime;
	}

	public void setRegistrantId(String registrantId) {
		this.registrantId = registrantId;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public void setApprovalType(int approvalType) {
		this.approvalType = approvalType;
	}

	public void setJoinUrl(String joinUrl) {
		this.joinUrl = joinUrl;
	}

	public void setTopic(String topic) {
		this.topic = topic;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

}
