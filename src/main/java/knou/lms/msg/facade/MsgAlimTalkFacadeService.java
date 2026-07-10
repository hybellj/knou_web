package knou.lms.msg.facade;

import knou.framework.context2.UserContext;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.MsgAlimTalkVO;
import knou.lms.org.vo.OrgInfoVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.io.InputStream;
import java.util.List;

public interface MsgAlimTalkFacadeService {

    List<OrgInfoVO> selectActiveOrgListByAuth(String userId, boolean isAdmin) throws Exception;

    List<OrgInfoVO> selectProfSbjctOrgList(String userId);

    ProcessResultVO<MsgAlimTalkVO> selectAlimTalkRcvnListPage(MsgAlimTalkVO vo) throws Exception;

    MsgAlimTalkVO selectAlimTalkRcvnDtl(MsgAlimTalkVO vo);

    int modifyAlimTalkReadDttm(MsgAlimTalkVO vo);

    int modifyAlimTalkRcvrDelyn(MsgAlimTalkVO vo);

    ProcessResultVO<MsgAlimTalkVO> selectAlimTalkSndngListPage(MsgAlimTalkVO vo) throws Exception;

    MsgAlimTalkVO selectAlimTalkSndngDtl(MsgAlimTalkVO vo);

    ProcessResultVO<MsgAlimTalkVO> selectAlimTalkSndngRcvrListPage(MsgAlimTalkVO vo) throws Exception;

    int modifyAlimTalkSndngrDelyn(MsgAlimTalkVO vo);

    void registAlimTalkSndng(MsgAlimTalkVO vo) throws Exception;

    void modifyAlimTalkSndng(MsgAlimTalkVO vo) throws Exception;

    int modifyMsgRsrvCncl(MsgAlimTalkVO vo);

    EgovMap loadEditLinkInfo(String msgId, UserContext userCtx);

    void applyOriginalToFilterOptions(EgovMap filterOptions, MsgAlimTalkVO original);

    List<MsgAlimTalkVO> parseExcelAndSearchRcvr(InputStream excelInputStream, String orgId) throws Exception;

    List<MsgAlimTalkVO> selectMsgRcvTrgtrList(MsgAlimTalkVO vo);

    MsgAlimTalkVO loadListViewInfo(MsgAlimTalkVO vo) throws Exception;

    EgovMap loadFilterOptions(MsgAlimTalkVO vo) throws Exception;

    EgovMap loadStdntFilterOptions(MsgAlimTalkVO vo);

    EgovMap loadSndngRegistViewInfo(String msgId, String userId, boolean hasSndngAuth) throws Exception;

    EgovMap loadSndngRegistFilterOptions(UserContext userCtx) throws Exception;
}
