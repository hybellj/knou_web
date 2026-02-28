package knou.lms.seminar.api.users.vo;

import java.io.Serializable;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlElementWrapper;

import knou.lms.seminar.api.common.vo.PagenationVO;

public class UsersVO extends PagenationVO implements Serializable {

	private static final long serialVersionUID = 6705799437941927696L;

	@JacksonXmlElementWrapper(useWrapping = false)
	@JsonProperty("users")
	private List<UsersInfoVO> users;

	public List<UsersInfoVO> getUsers() {
		return users;
	}

    @Override
	@JsonIgnore
	public List<UsersInfoVO> getObjects() {
		return users;
	}

}
