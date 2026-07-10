package knou.lms.mrk.dao;

import knou.framework.common.PageInfo;
import knou.lms.mrk.vo.MrkProcExcpProcVO;
import knou.lms.mrk.vo.SubjectMarkDetailVO;
import knou.lms.mrk.vo.MarkSubjectVO;
import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("markSubjectDAO")
public interface MarkSubjectDAO {

    public EgovMap stdMrkSbjctDtlSelect(@Param("sbjctId")String sbjctId, @Param("userId")String userId);

    public List<MarkSubjectVO> mrkSbjctList(@Param("sbjctId") String sbjctId, @Param("targetUserIdArr") String[] targetUserIdArr);

    public List<SubjectMarkDetailVO> mrkSbjctDtlList(@Param("sbjctId")String sbjctId, @Param("targetUserIdArr")String[] targetUserIdArr);

    public List<EgovMap> stdSbjctMrkList(EgovMap searchMap);

    public int stdMrkListCntSelect(String sbjctId);

    public List<String> nonEvlStdList(String sbjctId);

    public int nonEvlStdCnt(String sbjctId);

    public int invalidMrkRfltrtSumAsmtSelect(String sbjctId);

    public int invalidMrkRfltrtSumExamSelect(String sbjctId);

    public int invalidMrkRfltrtSumQuizSelect(String sbjctId);

    public int invalidMrkRfltrtSumDscsSelect(String sbjctId);
 
    public int invalidMrkRfltrtSumSmnrSelect(String sbjctId);

    public int invalidMrkRfltrtSumSrvySelect(String sbjctId);

    public void allStdMrkSbjctDelete(String sbjctId) ;

    public void allStdMrkSbjctDtlDelete(String sbjctId);

    public List<MarkSubjectVO> stdMrkSbjctList(String sbjctId);

    public List<EgovMap> stdAttdSummaryByWeekSelect(String sbjctId);

    public List<SubjectMarkDetailVO> normalExamEvlScoreList(String sbjctId);

    public List<SubjectMarkDetailVO> examEvlScoreList(@Param("sbjctId")String sbjctId, @Param("searchKey")String searchKey);

    public List<SubjectMarkDetailVO> prgScoreList(String sbjctId);

    public List<SubjectMarkDetailVO> exrcsQstnScoreList(String sbjctId);

    public List<SubjectMarkDetailVO> smnrEvlScoreList(String sbjctId);

    public List<SubjectMarkDetailVO> asmtEvlScoreList(String sbjctId);

    public List<SubjectMarkDetailVO> dscsEvlScoreList(String sbjctId);

    public List<SubjectMarkDetailVO> quizEvlScoreList(String sbjctId);

    public List<SubjectMarkDetailVO> srvyEvlScoreList(String sbjctId);

    public List<MarkSubjectVO> adtnScoreList(String sbjctId);

    public int mrkSbjctBatchInsert(List<MarkSubjectVO> mrksbjctList);

    public int mrkSbjctDtlBatchInsert(List<SubjectMarkDetailVO> mrksbjctDtlList);

    public int mrkSbjctBatchUpdate(List<MarkSubjectVO> mrksbjctList);

    public int mrkSbjctDtlBatchUpdate(List<SubjectMarkDetailVO> mrksbjctList);

    public void scrCnvsStsModify(MarkSubjectVO vo);

    public List<EgovMap> AvgScrInfoByMrkItmSelect(String sbjctId);

    public EgovMap mrkRangeStatusSelect(@Param("sbjctId")String sbjctId);

    public List<EgovMap> mrkProcExcpProcListPaging(PageInfo pageInfo);

    public List<EgovMap> allMrkProcExcpProcListPaging(PageInfo pageInfo);

    public void mrkProcExcpProcListBatchInsert(List<MrkProcExcpProcVO> list);

    public void mrkProcExcpProcListBatchDelete(List<MrkProcExcpProcVO> list);
}
