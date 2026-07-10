package knou.lms.msg.facade;

import knou.framework.context2.UserContext;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.MsgSmsVO;
import knou.lms.org.vo.OrgInfoVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.io.InputStream;
import java.util.List;

public interface MsgSmsFacadeService {

    List<OrgInfoVO> selectActiveOrgListByAuth(String userId, boolean isAdmin) throws Exception;

    ProcessResultVO<MsgSmsVO> selectSmsRcvnListPage(MsgSmsVO vo) throws Exception;

    MsgSmsVO selectSmsRcvnDtl(MsgSmsVO vo);

    int modifySmsReadDttm(MsgSmsVO vo);

    int modifySmsRcvrDelyn(MsgSmsVO vo);

    ProcessResultVO<MsgSmsVO> selectSmsSndngListPage(MsgSmsVO vo) throws Exception;

    MsgSmsVO selectSmsSndngDtl(MsgSmsVO vo);

    ProcessResultVO<MsgSmsVO> selectSmsSndngRcvrListPage(MsgSmsVO vo) throws Exception;

    int modifySmsSndngrDelyn(MsgSmsVO vo);

    ProcessResultVO<MsgSmsVO> registSmsSndng(MsgSmsVO vo) throws Exception;

    void modifySmsSndng(MsgSmsVO vo);

    int modifyMsgRsrvCncl(MsgSmsVO vo);

    EgovMap loadEditLinkInfo(String msgId, UserContext userCtx);

    void applyOriginalToFilterOptions(EgovMap filterOptions, MsgSmsVO original);

    List<MsgSmsVO> parseExcelAndSearchRcvr(InputStream excelInputStream, String orgId) throws Exception;

    List<MsgSmsVO> selectMsgRcvTrgtrList(MsgSmsVO vo);

    MsgSmsVO loadListViewInfo(MsgSmsVO vo) throws Exception;

    EgovMap loadFilterOptions(MsgSmsVO vo) throws Exception;

    EgovMap loadSndngRegistViewInfo(String userId) throws Exception;

    EgovMap loadSndngRegistFilterOptions(UserContext userCtx) throws Exception;
}
