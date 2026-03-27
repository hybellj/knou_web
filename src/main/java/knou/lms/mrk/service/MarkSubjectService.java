package knou.lms.mrk.service;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface MarkSubjectService {

    List<EgovMap> stdMrkList(EgovMap searchMap) throws Exception;

    int stdMrkListCntSelect(String sbjctId) throws Exception;

    int invalidMrkRfltrtSumQuizSelect(String sbjctId) throws Exception;

    int invalidMrkRfltrtSumAsmtSelect(String sbjctId) throws Exception;

    int invalidMrkRfltrtSumDscsSelect(String sbjctId) throws Exception;

    int invalidMrkRfltrtSumSmnrSelect(String sbjctId) throws Exception;

    int invalidMrkRfltrtSumSrvySelect(String sbjctId) throws Exception;

    void allStdMrkSbjctDelete(String sbjctId) throws Exception;

    void allStdMrkSbjctDtlDelete(String sbjctId) throws Exception;

    List<EgovMap> stdMrkSbjctList(String sbjctId) throws Exception;

    List<EgovMap> attdSummaryList(String sbjctId) throws Exception;

    List<EgovMap> examEvlScoreList(String sbjctId, String searchKey) throws Exception;

    List<EgovMap> smnrScoreEvlList(String sbjctId) throws Exception;

    List<EgovMap> asmtScoreEvlList(String sbjctId) throws Exception;

    List<EgovMap> dscsScoreEvlList(String sbjctId) throws Exception;

    List<EgovMap> quizScoreEvlList(String sbjctId) throws Exception;

    List<EgovMap> srvyScoreEvlList(String sbjctId) throws Exception;


}
