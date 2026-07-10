package knou.lms.msg.facade;

import knou.framework.context2.UserContext;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.MsgPushVO;
import knou.lms.org.vo.OrgInfoVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.io.InputStream;
import java.util.List;

public interface MsgPushFacadeService {

    List<OrgInfoVO> selectActiveOrgListByAuth(String userId, boolean isAdmin) throws Exception;

    List<OrgInfoVO> selectProfSbjctOrgList(String userId);

    ProcessResultVO<MsgPushVO> selectPushRcvnListPage(MsgPushVO vo) throws Exception;

    MsgPushVO selectPushRcvnDtl(MsgPushVO vo);

    int modifyPushReadDttm(MsgPushVO vo);

    int modifyPushRcvrDelyn(MsgPushVO vo);

    ProcessResultVO<MsgPushVO> selectPushSndngListPage(MsgPushVO vo) throws Exception;

    MsgPushVO selectPushSndngDtl(MsgPushVO vo);

    ProcessResultVO<MsgPushVO> selectPushSndngRcvrListPage(MsgPushVO vo) throws Exception;

    int modifyPushSndngrDelyn(MsgPushVO vo);

    void registPushSndng(MsgPushVO vo) throws Exception;

    void modifyPushSndng(MsgPushVO vo) throws Exception;

    int modifyMsgRsrvCncl(MsgPushVO vo);

    EgovMap loadEditLinkInfo(String msgId, UserContext userCtx);

    void applyOriginalToFilterOptions(EgovMap filterOptions, MsgPushVO original);

    List<MsgPushVO> parseExcelAndSearchRcvr(InputStream excelInputStream, String orgId) throws Exception;

    List<MsgPushVO> selectMsgRcvTrgtrList(MsgPushVO vo);

    MsgPushVO loadListViewInfo(MsgPushVO vo) throws Exception;

    EgovMap loadFilterOptions(MsgPushVO vo);

    EgovMap loadStdntFilterOptions(MsgPushVO vo);

    EgovMap loadSndngRegistViewInfo(String msgId, String userId, boolean hasSndngAuth);

    EgovMap loadSndngRegistFilterOptions(UserContext userCtx) throws Exception;
}
