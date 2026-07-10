package knou.lms.msg.facade;

import knou.framework.context2.UserContext;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.MsgShrtntVO;
import knou.lms.org.vo.OrgInfoVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.io.InputStream;
import java.util.List;

public interface MsgShrtntFacadeService {

    List<OrgInfoVO> selectActiveOrgListByAuth(String userId, boolean isAdmin) throws Exception;

    List<OrgInfoVO> selectProfSbjctOrgList(String userId);

    ProcessResultVO<MsgShrtntVO> selectShrtntRcvnListPage(MsgShrtntVO vo) throws Exception;

    MsgShrtntVO selectShrtntRcvnDtlWithFiles(MsgShrtntVO vo);

    int modifyShrtntReadDttm(MsgShrtntVO vo);

    int modifyShrtntRcvrDelyn(MsgShrtntVO vo);

    ProcessResultVO<MsgShrtntVO> selectShrtntSndngListPage(MsgShrtntVO vo) throws Exception;

    MsgShrtntVO selectShrtntSndngDtlWithFiles(MsgShrtntVO vo);

    ProcessResultVO<MsgShrtntVO> selectShrtntSndngRcvrListPage(MsgShrtntVO vo) throws Exception;

    int modifyShrtntSndngrDelyn(MsgShrtntVO vo);

    List<MsgShrtntVO> selectShrtntSndngRcvrExcelList(MsgShrtntVO vo);

    void registShrtntSndngWithFiles(MsgShrtntVO vo, String uploadFiles, String uploadPath) throws Exception;

    void modifyShrtntSndngWithFiles(MsgShrtntVO vo, String uploadFiles, String uploadPath, String[] delFileIds) throws Exception;

    List<MsgShrtntVO> parseExcelAndSearchRcvr(InputStream excelInputStream, String orgId) throws Exception;

    int modifyMsgRsrvCncl(MsgShrtntVO vo);

    List<MsgShrtntVO> selectMsgRcvTrgtrList(MsgShrtntVO vo);

    MsgShrtntVO loadListViewInfo(MsgShrtntVO vo) throws Exception;

    EgovMap loadFilterOptions(MsgShrtntVO vo) throws Exception;

    EgovMap loadStdntFilterOptions(MsgShrtntVO vo);

    EgovMap loadSndngRegistViewInfo(String msgId, String userId, boolean hasSndngAuth);

    EgovMap loadSndngRegistFilterOptions(UserContext userCtx) throws Exception;

    EgovMap loadReplyLinkInfo(String replyMsgShrtntSndngId, UserContext userCtx) throws Exception;

    EgovMap loadEditLinkInfo(String msgId, UserContext userCtx);

    void applyOriginalToFilterOptions(EgovMap filterOptions, MsgShrtntVO original);

    EgovMap selectRcptnRjctCnt(String rcvrListJson) throws Exception;
}
