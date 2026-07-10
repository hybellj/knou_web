package knou.lms.user.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.common.PageInfo;
import knou.lms.common.dto.ResultDTO;
import knou.lms.user.vo.UserMgrDeptVO;

public interface UserMgrDeptService {

    public ResultDTO<EgovMap> listUserMgrDept(PageInfo pageInfo);

    public List<UserMgrDeptVO> listUserMgrDeptCode(UserMgrDeptVO vo);

    public UserMgrDeptVO selectUserMgrDept(UserMgrDeptVO vo);

    public ResultDTO<UserMgrDeptVO> insertUserMgrDept(UserMgrDeptVO vo);

    public ResultDTO<UserMgrDeptVO> updateUserMgrDept(UserMgrDeptVO vo);

    public ResultDTO<UserMgrDeptVO> deleteUserMgrDept(UserMgrDeptVO vo);

    public ResultDTO<EgovMap> mergeUserMgrDeptHaksaSync(UserMgrDeptVO vo);
}
