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

    public List<EgovMap> stdMrkList(EgovMap searchMap)throws Exception;

    public int stdMrkListCntSelect(@Param("sbjctId")String sbjctId)throws Exception;

    public int invalidMrkRfltrtSumAsmtSelect(@Param("sbjctId")String sbjctId)throws Exception;

    public int invalidMrkRfltrtSumQuizSelect(@Param("sbjctId")String sbjctId)throws Exception;

    public int invalidMrkRfltrtSumDscsSelect(@Param("sbjctId")String sbjctId)throws Exception;

    public int invalidMrkRfltrtSumSmnrSelect(@Param("sbjctId")String sbjctId)throws Exception;

    public int invalidMrkRfltrtSumSrvySelect(@Param("sbjctId")String sbjctId)throws Exception;

    public void allStdMrkSbjctDelete(@Param("sbjctId")String sbjctId)throws Exception;

    public void allStdMrkSbjctDtlDelete(@Param("sbjctId")String sbjctId)throws Exception;

    public List<MarkSubjectVO> stdMrkSbjctList(@Param("sbjctId")String sbjctId)throws Exception;

    public List<EgovMap> stdAttdSummaryByWeekSelect(@Param("sbjctId")String sbjctId)throws Exception;

    public List<EgovMap> examEvlScoreList(@Param("sbjctId")String sbjctId, @Param("searchKey")String searchKey)throws Exception;

    public List<EgovMap> smnrEvlScoreList(@Param("sbjctId")String sbjctId)throws Exception;

    public List<EgovMap> asmtEvlScoreList(@Param("sbjctId")String sbjctId)throws Exception;

    public List<EgovMap> dscsEvlScoreList(@Param("sbjctId")String sbjctId)throws Exception;

    public List<EgovMap> quizEvlScoreList(@Param("sbjctId")String sbjctId)throws Exception;

    public List<EgovMap> srvyEvlScoreList(@Param("sbjctId")String sbjctId)throws Exception;

    public List<EgovMap> adtnScoreList(@Param("sbjctId")String sbjctId)throws Exception;

    public int mrkSbjctBatchInsert(List<MarkSubjectVO> mrksbjctList)throws Exception;

    public int mrkSbjctDtlBatchInsert(List<MarkSubjectDetailVO> mrksbjctDtlList)throws Exception;

}
