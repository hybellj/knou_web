package knou.lms.user.vo;

import java.util.List;

public class UserPrfilView {
    private UserPrfilVO userPrfilVO;
    private List<UserPrfilVO> userAuthrtList;
    private List<UserPrfilVO> nowSmstrLectOrgList;

    public UserPrfilVO getUserPrfilVO() {
        return userPrfilVO;
    }

    public void setUserPrfilVO(UserPrfilVO userPrfilVO) {
        this.userPrfilVO = userPrfilVO;
    }

    public List<UserPrfilVO> getUserAuthrtList() {
        return userAuthrtList;
    }

    public void setUserAuthrtList(List<UserPrfilVO> userAuthrtList) {
        this.userAuthrtList = userAuthrtList;
    }

    public List<UserPrfilVO> getNowSmstrLectOrgList() {
        return nowSmstrLectOrgList;
    }

    public void setNowSmstrLectOrgList(List<UserPrfilVO> nowSmstrLectOrgList) {
        this.nowSmstrLectOrgList = nowSmstrLectOrgList;
    }
}
