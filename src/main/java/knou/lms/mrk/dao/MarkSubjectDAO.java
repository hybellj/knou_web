package knou.lms.mrk.dao;

import knou.lms.mrk.vo.MarkSubjectDetailVO;
import knou.lms.mrk.vo.MarkSubjectVO;
import org.apache.ibatis.annotations.Param;
import org.apache.xmlbeans.impl.xb.xsdschema.Public;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;
import java.util.Map;

@Mapper("markSubjectDAO")
public interface MarkSubjectDAO {

    public List<MarkSubjectVO> mrkSbjctList(String sbjctId)throws Exception;

    public List<MarkSubjectDetailVO> mrkSbjctDtlList(String sbjctId)throws Exception;

    public List<EgovMap> stdMrkList(EgovMap searchMap)throws Exception;

    public int stdMrkListCntSelect(String sbjctId)throws Exception;

    public int invalidMrkRfltrtSumAsmtSelect(String sbjctId)throws Exception;

    public int invalidMrkRfltrtSumQuizSelect(String sbjctId)throws Exception;

    public int invalidMrkRfltrtSumDscsSelect(String sbjctId)throws Exception;

    public int invalidMrkRfltrtSumSmnrSelect(String sbjctId)throws Exception;

    public int invalidMrkRfltrtSumSrvySelect(String sbjctId)throws Exception;

    public void allStdMrkSbjctDelete(String sbjctId)throws Exception;

    public void allStdMrkSbjctDtlDelete(String sbjctId)throws Exception;

    public List<MarkSubjectVO> stdMrkSbjctList(String sbjctId)throws Exception;

    public List<EgovMap> stdAttdSummaryByWeekSelect(String sbjctId)throws Exception;

    public List<EgovMap> examEvlScoreList(@Param("sbjctId")String sbjctId, @Param("searchKey")String searchKey)throws Exception;

    public List<EgovMap> smnrEvlScoreList(String sbjctId)throws Exception;

    public List<EgovMap> asmtEvlScoreList(String sbjctId)throws Exception;

    public List<EgovMap> dscsEvlScoreList(String sbjctId)throws Exception;

    public List<EgovMap> quizEvlScoreList(String sbjctId)throws Exception;

    public List<EgovMap> srvyEvlScoreList(String sbjctId)throws Exception;

    public List<EgovMap> adtnScoreList(String sbjctId)throws Exception;

    public int mrkSbjctBatchInsert(List<MarkSubjectVO> mrksbjctList)throws Exception;

    public int mrkSbjctDtlBatchInsert(List<MarkSubjectDetailVO> mrksbjctDtlList)throws Exception;

    public int mrkSbjctBatchUpdate(List<MarkSubjectVO> mrksbjctList)throws Exception;

    public int mrkSbjctDtlBatchUpdate(List<MarkSubjectDetailVO> mrksbjctList)throws Exception;

}
