package knou.lms.user.service;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.common.PageInfo;
import knou.lms.common.dto.ResultDTO;
import knou.lms.user.vo.UserMgrVO;

public interface UserMgrService {

    public ResultDTO<EgovMap> listUserMgr(PageInfo pageInfo);

    public UserMgrVO selectUserMgr(UserMgrVO vo);

    public int countUserMgrId(UserMgrVO vo);

    public int countUserMgrStdntNo(UserMgrVO vo);

    public ResultDTO<UserMgrVO> insertUserMgr(UserMgrVO vo);

    public ResultDTO<UserMgrVO> updateUserMgr(UserMgrVO vo);

    public ResultDTO<UserMgrVO> withdrawUserMgr(UserMgrVO vo);

    public ResultDTO<UserMgrVO> updateUserMgrAuth(UserMgrVO vo);

    public List<EgovMap> listAdminGbn();

    public List<EgovMap> listUserGbn();

    public List<String> listUserAuthrtId(UserMgrVO vo);

    public EgovMap selectAuthrt(UserMgrVO vo);

    public int insertUserInfoChgHstry(Map<String, Object> param);

    public int insertUserTelnoChgHstry(Map<String, Object> param);

    public int insertUserAuthrtChgHstry(Map<String, Object> param);

    public List<EgovMap> listUserTelnoChgHstry(UserMgrVO vo);
}
