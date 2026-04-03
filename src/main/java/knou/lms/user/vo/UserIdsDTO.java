package knou.lms.user.vo;

import java.util.List;

public class UserIdsDTO {
	public List<String> profIds;
	public List<String> stdntIds;

	public UserIdsDTO() {
	}

	public List<String> getProfIds() {
		return profIds;
	}

	public void setProfIds(List<String> profIds) {
		this.profIds = profIds;
	}

	public List<String> getStdntIds() {
		return stdntIds;
	}

	public void setStdntIds(List<String> stdntIds) {
		this.stdntIds = stdntIds;
	}
}