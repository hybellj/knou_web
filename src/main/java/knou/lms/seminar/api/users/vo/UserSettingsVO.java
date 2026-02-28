package knou.lms.seminar.api.users.vo;

import java.io.Serializable;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlElementWrapper;

import knou.lms.seminar.api.meetings.vo.AuthenticationOptionVO;

public class UserSettingsVO implements Serializable {

	private static final long serialVersionUID = 8474628725114186747L;

	@JacksonXmlElementWrapper(useWrapping = false)
	@JsonProperty("authentication_options")
	private List<AuthenticationOptionVO> authenticationOptions;

	public List<AuthenticationOptionVO> getAuthenticationOptions() {
		return authenticationOptions;
	}

	public void setAuthenticationOptions(List<AuthenticationOptionVO> authenticationOptions) {
		this.authenticationOptions = authenticationOptions;
	}
}
