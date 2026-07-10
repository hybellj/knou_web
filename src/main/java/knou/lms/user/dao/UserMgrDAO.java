package knou.lms.user.dao;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.common.PageInfo;
import knou.lms.user.vo.UserMgrVO;

@Mapper("userMgrDAO")
public interface UserMgrDAO {

    public List<EgovMap> listUserMgr(PageInfo pageInfo);

    public UserMgrVO selectUserMgr(UserMgrVO vo);

    public int countUserMgrId(UserMgrVO vo);

    public int countUserMgrStdntNo(UserMgrVO vo);

    public int insertUserMgr(UserMgrVO vo);

    public int updateUserMgr(UserMgrVO vo);

    public int countUserGuestAuthrt(UserMgrVO vo);

    public int withdrawUserMgr(UserMgrVO vo);

    public int mergeUserMgrCntct(Map<String, Object> param);

    public List<EgovMap> listAdminGbn();

    public List<EgovMap> listUserGbn();

    public List<String> listUserAuthrtId(UserMgrVO vo);

    public EgovMap selectAuthrt(UserMgrVO vo);

    public int deleteUserMgrAuth(UserMgrVO vo);

    public int deleteUserMgrAuthAll(UserMgrVO vo);

    public int insertUserMgrAuth(UserMgrVO vo);

    public int insertUserInfoChgHstry(Map<String, Object> param);

    public int insertUserTelnoChgHstry(Map<String, Object> param);

    public int insertUserAuthrtChgHstry(Map<String, Object> param);

    public List<EgovMap> listUserTelnoChgHstry(UserMgrVO vo);
}
