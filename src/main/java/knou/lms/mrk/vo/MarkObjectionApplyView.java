package knou.lms.mrk.vo;

import knou.lms.subject.vo.SubjectVO;
import knou.lms.user.vo.UserPrfilVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;
import java.util.Map;

public class MarkObjectionApplyView {

    private SubjectVO sbjctInfo;
    private UserPrfilVO userInfo;
    private MarkObjectionApplyVO applyInfo;

    public SubjectVO getSbjctInfo() {
        return sbjctInfo;
    }

    public void setSbjctInfo(SubjectVO sbjctInfo) {
        this.sbjctInfo = sbjctInfo;
    }

    public UserPrfilVO getUserInfo() {
        return userInfo;
    }

    public void setUserInfo(UserPrfilVO userInfo) {
        this.userInfo = userInfo;
    }

    public MarkObjectionApplyVO getApplyInfo() {
        return applyInfo;
    }

    public void setApplyInfo(MarkObjectionApplyVO applyInfo) {
        this.applyInfo = applyInfo;
    }
}
