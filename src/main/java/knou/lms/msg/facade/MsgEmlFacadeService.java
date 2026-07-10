package knou.lms.msg.facade;

import knou.framework.context2.UserContext;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.MsgEmlVO;
import knou.lms.org.vo.OrgInfoVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.io.InputStream;
import java.util.List;

public interface MsgEmlFacadeService {

    List<OrgInfoVO> selectActiveOrgListByAuth(String userId, boolean isAdmin) throws Exception;

    List<OrgInfoVO> selectProfSbjctOrgList(String userId);

    ProcessResultVO<MsgEmlVO> selectEmlRcvnListPage(MsgEmlVO vo) throws Exception;

    MsgEmlVO selectEmlRcvnDtlWithFiles(MsgEmlVO vo);

    int modifyEmlReadDttm(MsgEmlVO vo);

    int modifyEmlRcvrDelyn(MsgEmlVO vo);

    ProcessResultVO<MsgEmlVO> selectEmlSndngListPage(MsgEmlVO vo) throws Exception;

    MsgEmlVO selectEmlSndngDtlWithFiles(MsgEmlVO vo);

    ProcessResultVO<MsgEmlVO> selectEmlSndngRcvrListPage(MsgEmlVO vo) throws Exception;

    int modifyEmlSndngrDelyn(MsgEmlVO vo);

    void registEmlSndngWithFiles(MsgEmlVO vo, String uploadFiles, String uploadPath) throws Exception;

    void modifyEmlSndngWithFiles(MsgEmlVO vo, String uploadFiles, String uploadPath, String[] delFileIds) throws Exception;

    int modifyMsgRsrvCncl(MsgEmlVO vo);

    EgovMap loadReplyLinkInfo(String replyMsgEmlSndngId, UserContext userCtx) throws Exception;

    EgovMap loadEditLinkInfo(String msgId, UserContext userCtx);

    void applyOriginalToFilterOptions(EgovMap filterOptions, MsgEmlVO original);

    List<MsgEmlVO> parseExcelAndSearchRcvr(InputStream excelInputStream, String orgId) throws Exception;

    List<MsgEmlVO> selectMsgRcvTrgtrList(MsgEmlVO vo);

    MsgEmlVO loadListViewInfo(MsgEmlVO vo) throws Exception;

    EgovMap loadFilterOptions(MsgEmlVO vo) throws Exception;

    EgovMap loadSndngRegistViewInfo(String msgId, String userId, boolean hasSndngAuth) throws Exception;

    EgovMap loadSndngRegistFilterOptions(UserContext userCtx) throws Exception;
}
