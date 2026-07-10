package knou.lms.mrk.service;

import knou.framework.context2.UserContext;
import knou.lms.bbs.vo.BbsAtclVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.mrk.vo.MarkObjectionApplyVO;
import knou.lms.user.CurrentUser;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;
import java.util.Map;

public interface MarkObjectionApplyService {

    Map<String, String> mrkObjctAplyPrdSelect(String orgId);

    boolean isMrkObjctAplyDate(String orgId);

    List<EgovMap> profMrkObjctAplyList(String sbjctId);

    List<EgovMap> stdMrkObjctAplyList(String sbjctId, String userId);

    ProcessResultVO<EgovMap> mrkObjctAplyListPaging(MarkObjectionApplyVO vo) throws Exception;

    MarkObjectionApplyVO mrkObjctAplySelect(String mrkObjctAplyId);

    void mrkObjctAplyRegist(MarkObjectionApplyVO vo, UserContext userCtx) throws Exception;

    void mrkObjctAplyModify(MarkObjectionApplyVO vo, UserContext userCtx) throws Exception;

    void mrkObjctAplyDelete(MarkObjectionApplyVO vo, UserContext userCtx) throws Exception;
}
