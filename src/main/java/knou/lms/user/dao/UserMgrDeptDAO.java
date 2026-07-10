package knou.lms.user.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.common.PageInfo;
import knou.lms.user.vo.UserMgrDeptVO;

@Mapper("userMgrDeptDAO")
public interface UserMgrDeptDAO {

    public List<EgovMap> listUserMgrDept(PageInfo pageInfo);

    public List<UserMgrDeptVO> listUserMgrDeptCode(UserMgrDeptVO vo);

    public UserMgrDeptVO selectUserMgrDept(UserMgrDeptVO vo);

    public int countUserMgrDeptId(UserMgrDeptVO vo);

    public int insertUserMgrDept(UserMgrDeptVO vo);

    public int updateUserMgrDept(UserMgrDeptVO vo);

    public int deleteUserMgrDept(UserMgrDeptVO vo);

    public int mergeUserMgrDeptHaksaSync(UserMgrDeptVO vo);

    public int countHaksaSyncAdd(UserMgrDeptVO vo);

    public int countHaksaSyncMod(UserMgrDeptVO vo);

    public List<String> selectHaksaSyncStaleDeptIds(UserMgrDeptVO vo);
}
