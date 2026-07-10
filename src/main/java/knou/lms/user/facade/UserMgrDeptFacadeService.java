package knou.lms.user.facade;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.context2.UserContext;
import knou.lms.common.dto.ResultDTO;
import knou.lms.user.vo.UserMgrDeptListVO;
import knou.lms.user.vo.UserMgrDeptVO;
import knou.lms.user.web.view.UserMgrDeptListView;

public interface UserMgrDeptFacadeService {

    public UserMgrDeptListView userMgrDeptListView(UserMgrDeptListVO vo, UserContext userCtx) throws Exception;

    public ResultDTO<EgovMap> listUserMgrDept(UserMgrDeptListVO vo, UserContext userCtx);

    public List<UserMgrDeptVO> listUserMgrDeptCode(UserMgrDeptVO vo, UserContext userCtx);

    public ResultDTO<UserMgrDeptVO> selectUserMgrDept(UserMgrDeptVO vo, UserContext userCtx);

    public ResultDTO<UserMgrDeptVO> registUserMgrDept(UserMgrDeptVO vo, UserContext userCtx);

    public ResultDTO<UserMgrDeptVO> modifyUserMgrDept(UserMgrDeptVO vo, UserContext userCtx);

    public ResultDTO<UserMgrDeptVO> deleteUserMgrDept(UserMgrDeptVO vo, UserContext userCtx);

    public ResultDTO<EgovMap> runUserMgrDeptHaksaSync(UserMgrDeptVO vo, UserContext userCtx);
}
