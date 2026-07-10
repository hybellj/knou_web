package knou.lms.asmt2.service;

import knou.lms.asmt2.vo.AsmtEvlVO;
import knou.lms.asmt2.vo.AsmtRubricEvlVO;
import knou.lms.asmt2.vo.AsmtSbmsnVO;
import knou.lms.asmt2.vo.AsmtVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.subject.vo.SubjectVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface AsmtService {

    ProcessResultVO<EgovMap> asmtListPaging(AsmtVO vo) throws Exception;

    ProcessResultVO<AsmtVO> mrkRfltrtModify(AsmtVO vo) throws Exception;

    ProcessResultVO<AsmtVO> mrkOynModify(AsmtVO vo) throws Exception;

    EgovMap asmtSelect(AsmtVO asmtVO) throws Exception;

    List<EgovMap> dvclasList(AsmtVO vo) throws Exception;

    List<EgovMap> teamGrpTeamList(AsmtVO vo) throws Exception;

    List<EgovMap> indivStdList(AsmtVO vo) throws Exception;

    ProcessResultVO<EgovMap> indivSbmsnTrgt(AsmtVO vo) throws Exception;

    void profAsmtRegist(AsmtVO vo) throws Exception;

    void profAsmtModify(AsmtVO vo) throws Exception;

    List<EgovMap> asmtCopySmstrChrtList(AsmtVO vo) throws Exception;

    List<EgovMap> asmtCopySbjctList(AsmtVO vo) throws Exception;

    List<EgovMap> asmtCopyList(AsmtVO vo) throws Exception;

    ProcessResultVO<EgovMap> asmtEvlList(AsmtVO vo) throws Exception;

    List<EgovMap> asmtSbmsnZipFileList(AsmtVO vo) throws Exception;

    void asmtScrExcelUpload(AsmtVO vo) throws Exception;

    void profAsmtEvlScrBulkModify(List<AsmtEvlVO> list) throws Exception;

    void profAsmtEvlScrModify(AsmtEvlVO asmtEvlVO) throws Exception;

    ProcessResultVO<EgovMap> resbmsnCandidateList(AsmtVO vo) throws Exception;

    ProcessResultVO<EgovMap> resbmsnTrgtList(AsmtVO vo) throws Exception;

    void profAsmtResbmsnModify(AsmtVO asmtVO) throws Exception;

    String resbmsnMngyn(EgovMap vo) throws Exception;

    ProcessResultVO<EgovMap> asmtDelete(AsmtVO asmtVO) throws Exception;

    void resetAsmtMrkRfltrt(AsmtVO asmtVO) throws Exception;

    void resetAsmtEvlScrByRubricModify(AsmtVO asmtVO) throws Exception;

    void asmtMemoModify(AsmtEvlVO vo) throws Exception;

    ProcessResultVO<EgovMap> prevAsmtSbmsnList(AsmtVO vo) throws Exception;

    void asmtExlnBulkModify(List<AsmtEvlVO> list) throws Exception;

    void asmtExlnModify(AsmtEvlVO vo) throws Exception;

    List<EgovMap> asmtSbmsnHistList(AsmtVO vo) throws Exception;

    void asmtEzgScrModify(AsmtEvlVO vo) throws Exception;

    void asmtEzgRubricEvlSave(AsmtRubricEvlVO vo) throws Exception;

    void asmtEzgExlnModify(AsmtEvlVO vo) throws Exception;

    List<EgovMap> bySubjectAsmtList(SubjectVO vo);

    ProcessResultVO<EgovMap> stdntAsmtListPaging(AsmtVO vo) throws Exception;

    int mrkRfltrtSingleModify(AsmtVO vo);

    ProcessResultVO<EgovMap> stdntAsmtView(AsmtVO vo) throws Exception;

    ProcessResultVO<EgovMap> stdntAsmtAlimInfo(AsmtVO vo) throws Exception;

    ProcessResultVO<EgovMap> stdntAsmtSbmsnList(AsmtVO vo) throws Exception;

    ProcessResultVO<EgovMap> stdntExlnAsmtList(AsmtVO vo) throws Exception;

    ProcessResultVO<EgovMap> stdntAsmtSbmsnRegist(AsmtSbmsnVO vo) throws Exception;

    List<EgovMap> lctrWknoSchdlList(AsmtVO vo);
}
