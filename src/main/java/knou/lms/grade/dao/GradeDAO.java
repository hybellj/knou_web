package knou.lms.grade.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.grade.vo.GradeStdScoreItemVO;
import knou.lms.grade.vo.GradeVO;

@Mapper("gradeDAO")
public interface GradeDAO {

    public List<GradeVO> selectTermList(GradeVO vo) throws Exception;

    public List<GradeVO> selectDeptList(GradeVO vo) throws Exception;

    public List<GradeVO> selectEvlList(GradeVO vo) throws Exception;

    public void multiEvlList(GradeVO vo) throws Exception;

    public List<GradeVO> selectEvlStandardList(GradeVO vo) throws Exception;

    public GradeVO selectStdScoreItemConfInfo(GradeVO vo) throws Exception;

    public int selectScoreItemConfCnt(GradeVO vo) throws Exception;

    public List<GradeStdScoreItemVO> selectStdScoreItemConfList(GradeVO vo) throws Exception;

    public List<GradeStdScoreItemVO> selectStdOrgScoreItemConfInitList(GradeVO vo) throws Exception;

    public String selectCrsTypeCdToCrsCreCd(GradeVO vo) throws Exception;

    public void insertStdScoreItemConf(GradeStdScoreItemVO paramVo) throws Exception;

    public void multiStdScoreItemConf(GradeStdScoreItemVO paramVo) throws Exception;

    public List<GradeVO> selectCreCrsList(GradeVO vo) throws Exception;
    
    public List<GradeVO> listCreCrsGradeStatus(GradeVO vo) throws Exception;
    
    public List<GradeVO> listStdGradeStatus(GradeVO vo) throws Exception;
    
    public List<EgovMap> selectEvlStandardListByEgov(GradeVO vo) throws Exception;
    
    public List<EgovMap> listGradeInputExc(GradeVO vo) throws Exception;
}
