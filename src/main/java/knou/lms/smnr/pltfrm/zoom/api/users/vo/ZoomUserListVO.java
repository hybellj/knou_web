package knou.lms.smnr.pltfrm.zoom.api.users.vo;

import java.io.Serializable;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

import knou.lms.smnr.pltfrm.zoom.api.common.vo.ZoomPagenationVO;

public class ZoomUserListVO extends ZoomPagenationVO implements Serializable {

	private static final long serialVersionUID = -5919466230505513076L;

	@JsonProperty("users")
    private List<ZoomUserVO> users;

    @Override
    @JsonIgnore
    public List<ZoomUserVO> getObjects() {
        return users;
    }

    public void setUsers(List<ZoomUserVO> users) {
        this.users = users;
    }
}
