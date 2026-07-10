package knou.lms.asmt2.dao;

import knou.lms.asmt2.vo.AsmtEvlVO;
import knou.lms.asmt2.vo.AsmtRubricEvlVO;
import knou.lms.asmt2.vo.AsmtSbmsnVO;
import knou.lms.asmt2.vo.AsmtTrgtVO;
import knou.lms.asmt2.vo.AsmtVO;
import knou.lms.subject.vo.SubjectVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("asmt2DAO")
public interface AsmtDAO {

    List<EgovMap> asmtListPaging(AsmtVO vo) throws Exception;

    int mrkRfltrtModify(AsmtVO vo);

    void mrkOynModify(AsmtVO vo) throws Exception;

    EgovMap asmtSelect(AsmtVO asmtVO) throws Exception;

    List<EgovMap> dvclasList(AsmtVO vo) throws Exception;

    List<EgovMap> teamGrpTeamList(AsmtVO vo) throws Exception;

    void asmtGrpRegist(AsmtVO vo) throws Exception;

    void asmtRegist(AsmtVO vo) throws Exception;

    void asmtTrgtListRegist(List<AsmtTrgtVO> insertList) throws Exception;

    List<AsmtTrgtVO> teamTrgtList(AsmtVO vo) throws Exception;

    void subAsmtByCopyRegist(AsmtVO vo) throws Exception;

    List<AsmtTrgtVO> allStdTrgtList(AsmtVO vo) throws Exception;

    void asmtModify(AsmtVO vo) throws Exception;

    void subAsmtModify(AsmtVO subVO) throws Exception;

    List<AsmtVO> subAsmtList(AsmtVO upAsmtVO) throws Exception;

    void asmtDelete(AsmtVO dbVO) throws Exception;

    void asmtSbmsnTrgtDelete(AsmtVO subVO) throws Exception;

    void subAsmtDelete(AsmtVO vo) throws Exception;

    List<EgovMap> asmtCopySmstrChrtList(AsmtVO vo) throws Exception;

    List<EgovMap> asmtCopySbjctList(AsmtVO vo) throws Exception;

    List<EgovMap> asmtCopyList(AsmtVO vo) throws Exception;

    List<EgovMap> asmtEvlList(AsmtVO vo) throws Exception;

    void asmtEvlScrBulkModify(List<AsmtEvlVO> list) throws Exception;

    void asmtEvlScrModify(AsmtEvlVO asmtEvlVO) throws Exception;

    void asmtResbmsnModify(AsmtVO vo) throws Exception;

    void resetResbmsnTarget(AsmtTrgtVO asmtTrgtVO) throws Exception;

    void applyResbmsnTarget(AsmtTrgtVO asmtTrgtVO) throws Exception;

    void resetResbmsnScore(AsmtTrgtVO asmtTrgtVO) throws Exception;

    void resetMrkRfltrt(AsmtVO asmtVO) throws Exception;

    void resetAsmtEvlScrByRubricModify(AsmtVO asmtVO) throws Exception;

    EgovMap asmtEvlSelect(AsmtVO vo) throws Exception;

    List<EgovMap> asmtRubricEvlList(AsmtRubricEvlVO vo) throws Exception;

    List<AsmtRubricEvlVO> asmtRubricEvlScoreList(AsmtRubricEvlVO vo) throws Exception;

    List<EgovMap> bySubjectAsmtList(SubjectVO vo);

    List<EgovMap> stdntAsmtListPaging(AsmtVO vo);

    EgovMap stdntAsmtView(AsmtVO vo);

    EgovMap stdntAsmtAlimInfo(AsmtVO vo);

    List<EgovMap> stdntAsmtSbmsnList(AsmtVO vo);

    List<EgovMap> stdntExlnAsmtList(AsmtVO vo);

    List<EgovMap> stdntAsmtSbmsnTargetList(AsmtSbmsnVO vo);

    void stdntAsmtSbmsnRegist(AsmtSbmsnVO vo);

    void stdntAsmtSbmsnModify(AsmtSbmsnVO vo);
    
    List<EgovMap> lctrWknoSchdlList(AsmtVO vo);
}
