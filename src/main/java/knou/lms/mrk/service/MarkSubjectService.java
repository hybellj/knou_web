package knou.lms.mrk.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.mrk.vo.MarkSubjectDetailVO;
import knou.lms.mrk.vo.MarkSubjectVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;
import java.util.Map;

public interface MarkSubjectService {

    ProcessResultVO<EgovMap> stdMrkList(String orgId, String sbjctId, String searchType) throws Exception;

    int stdMrkListCntSelect(String sbjctId) throws Exception;

    void stdMrkInit(String orgId, String sbjctId, String userId) throws Exception;

//    void allStdMrkSbjctDelete(String sbjctId) throws Exception;

//    void allStdMrkSbjctDtlDelete(String sbjctId) throws Exception;

//    List<MarkSubjectVO> stdMrkSbjctList(String sbjctId) throws Exception;

    List<EgovMap> attdSummaryList(String sbjctId) throws Exception;

    List<EgovMap> getMrkItmStngList(String orgId, String sbjctId) throws Exception;

//    List<EgovMap> examEvlScoreList(String sbjctId, String searchKey) throws Exception;
//
//    List<EgovMap> smnrScoreEvlList(String sbjctId) throws Exception;
//
//    List<EgovMap> asmtScoreEvlList(String sbjctId) throws Exception;
//
//    List<EgovMap> dscsScoreEvlList(String sbjctId) throws Exception;
//
//    List<EgovMap> quizScoreEvlList(String sbjctId) throws Exception;
//
//    List<EgovMap> srvyScoreEvlList(String sbjctId) throws Exception;

//    int mrkSbjctBatchInsert(List<MarkSubjectVO> mrksbjctList)throws Exception;
//
//    int mrkSbjctDtlBatchInsert(List<MarkSubjectDetailVO> vo)throws Exception;

    void stdMrkModify(Map<String, Map<String, String>> stdMrkList,String orgId, String sbjctId, String mdfrId) throws Exception;

}
