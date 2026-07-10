package knou.lms.user.facade;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.context2.UserContext;
import knou.lms.common.dto.ResultDTO;
import knou.lms.user.vo.UserMsgVO;
import knou.lms.user.vo.UserMgrListVO;
import knou.lms.user.vo.UserMgrVO;
import knou.lms.user.web.view.UserMgrFormView;
import knou.lms.user.web.view.UserMgrListView;

public interface UserMgrFacadeService {

    public UserMgrListView userMgrListView(UserMgrListVO vo, UserContext userCtx) throws Exception;

    public ResultDTO<EgovMap> listUserMgr(UserMgrListVO vo, UserContext userCtx);

    public UserMgrFormView userMgrFormView(UserMgrVO vo, UserContext userCtx) throws Exception;

    public ResultDTO<UserMgrVO> selectUserMgr(UserMgrVO vo, UserContext userCtx);

    public ResultDTO<UserMgrVO> selectUserMgrInfo(UserMgrVO vo, UserContext userCtx);

    public ResultDTO<EgovMap> listUserTelnoChgHstry(UserMgrVO vo, UserContext userCtx);

    public ResultDTO<UserMgrVO> countUserMgrId(UserMgrVO vo);

    public ResultDTO<UserMgrVO> countUserMgrStdntNo(UserMgrVO vo);

    public ResultDTO<UserMgrVO> registUserMgr(UserMgrVO vo, UserContext userCtx);

    public ResultDTO<UserMgrVO> modifyUserMgr(UserMgrVO vo, UserContext userCtx);

    public ResultDTO<UserMgrVO> withdrawUserMgr(UserMgrVO vo, UserContext userCtx);

    public ResultDTO<UserMgrVO> modifyUserMgrAuth(UserMgrVO vo, UserContext userCtx);

    public List<EgovMap> listAdminGbn();

    public List<String> listUserAuthrtId(String userId);

    public ResultDTO<UserMsgVO> sendUserMsg(UserMsgVO vo, UserContext userCtx);
}
