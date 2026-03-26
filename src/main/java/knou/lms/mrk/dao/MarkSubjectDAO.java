package knou.lms.mrk.dao;

import knou.lms.mrk.vo.MarkSubjectDetailVO;
import knou.lms.mrk.vo.MarkSubjectVO;
import org.apache.ibatis.annotations.Param;
import org.apache.xmlbeans.impl.xb.xsdschema.Public;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

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

    public List<EgovMap> stdMrkSbjctList(@Param("sbjctId")String sbjctId)throws Exception;

    public EgovMap stdAttdSummaryByWeekSelect(@Param("sbjctId")String sbjctId, @Param("userId")String userId)throws Exception;

    public List<MarkSubjectDetailVO> examScoreList(@Param("sbjctId")String sbjctId, @Param("searchKey")String searchKey)throws Exception;
//
//    public double asmtScoreList(String sbjctId) throws Exception;
//
//    public double dscsScoreList(String sbjctId) throws Exception;
//
//    public double quizScoreList(String sbjctId) throws Exception;
//
//    public double srvyScoreList(String sbjctId) throws Exception;
//
//    public double smnrScoreList(String sbjctId) throws Exception;

}
