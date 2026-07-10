package knou.lms.stats.dao;

import java.util.List;

import knou.framework.common.PageInfo;
import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.subject.vo.SubjectVO;

@Mapper("statsDAO")
public interface StatsDAO {

	public List<EgovMap> bySubjectLearningProgressListPaging(SubjectVO vo) ;

	public int bySubjectLearningProgressCnt(SubjectVO vo);

    public EgovMap lrnPrgrtStatsSummarySelect(SubjectVO vo);

    public List<EgovMap> stdntLrnPrgrtList(SubjectVO vo);

//    public List<EgovMap> stdntLrnPrgrtListPaging(SubjectVO vo);
    public List<EgovMap> stdntLrnPrgrtListPaging(PageInfo pageInfo);

    public List<EgovMap> listLrnPrgrtStatusByDept(PageInfo pageInfo);

    public List<EgovMap> lrnPrgStsListPaging(PageInfo pageInfo);

    public EgovMap admLrnPrgStsAllAvgSelect(@Param("orgId")String orgId, @Param("dgrsYr")String dgrsYr, @Param("dgrsSmstrChrt")String dgrsSmstrChrt);
}