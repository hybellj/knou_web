package knou.lms.stats.service;

import knou.framework.common.PageInfo;
import knou.lms.common.dto.ResultDTO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.subject.vo.SubjectVO;

import java.util.List;

public interface StatsService {

	public ProcessResultVO<EgovMap> bySubjectLearningProgressListPaging(SubjectVO vo) throws Exception;

    public EgovMap lrnPrgrtStatsSummaryAjax(SubjectVO vo);

    public List<EgovMap> stdntLrnPrgrtList(SubjectVO vo);

//    public ProcessResultVO<EgovMap> stdntLrnPrgrtListPaging(PageInfo pageInfo) throws Exception;
    public ResultDTO<EgovMap> stdntLrnPrgrtListPaging(PageInfo pageInfo);

    public List<EgovMap> listLrnPrgrtStatusByDept(PageInfo pageInfo);

    public ResultDTO<EgovMap> lrnPrgStsListPaging(PageInfo pageInfo);

//    public ResultDTO<EgovMap> admLrnPrgStsAllAvgSelectAjax(PageInfo pageInfo);
}