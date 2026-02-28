package knou.lms.grade.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.grade.vo.GradeStdScoreItemVO;
import knou.lms.grade.vo.GradeVO;

public interface GradeService {

    public ProcessResultVO<GradeVO> selectTermList(GradeVO vo) throws Exception;

    public ProcessResultVO<GradeVO> selectDeptList(GradeVO vo) throws Exception;

    public ProcessResultVO<GradeVO> selectEvlList(GradeVO vo) throws Exception;

    public ProcessResultVO<GradeVO> multiEvlList(GradeVO vo) throws Exception;

    public List<GradeVO> selectEvlExcelList(GradeVO vo) throws Exception;

    public ProcessResultVO<GradeVO> selectEvlStandardList(GradeVO vo) throws Exception;

    public ProcessResultVO<GradeVO> selectStdScoreItemConfInfo(GradeVO vo) throws Exception;

    public ProcessResultVO<GradeStdScoreItemVO> selectEvlReg(GradeVO vo) throws Exception;

    public ProcessResultVO<GradeStdScoreItemVO> multiEvlPopReg(GradeVO vo) throws Exception;

    public ProcessResultVO<GradeVO> selectCreCrsList(GradeVO vo) throws Exception;
    
    public List<GradeVO> listCreCrsGradeStatus(GradeVO vo) throws Exception;
    
    public List<GradeVO> listStdGradeStatus(GradeVO vo) throws Exception;
    
    public ProcessResultVO<EgovMap> selectEvlStandardListByEgov(GradeVO vo) throws Exception;
    
    public ProcessResultVO<EgovMap> listGradeInputExc(GradeVO vo) throws Exception;
    
    public void saveGradeInputExc(GradeVO vo) throws Exception;
}