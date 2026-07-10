package knou.lms.stats.service.impl;

import javax.annotation.Resource;

import knou.lms.common.dto.ResultDTO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import knou.framework.common.PageInfo;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.stats.dao.StatsDAO;
import knou.lms.stats.service.StatsService;
import knou.lms.subject.vo.SubjectVO;

import java.util.List;

@Service("statsService")
public class StatsServiceImpl implements StatsService {

	private static final Logger log = LoggerFactory.getLogger(StatsServiceImpl.class);

	@Resource(name = "statsDAO")
	private StatsDAO statsDAO;

	@Override
	public ProcessResultVO<EgovMap> bySubjectLearningProgressListPaging(SubjectVO vo) throws Exception {
		
		ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();
		
		resultVO.setPageInfo(new PageInfo(vo));
		
		resultVO.getPageInfo().setTotalRecordCount(statsDAO.bySubjectLearningProgressCnt(vo));	//	과목별학습진도수조회  
		
        resultVO.setReturnList( statsDAO.bySubjectLearningProgressListPaging(vo)); 	//	과목별학습진도목록조회페이징
        log.info(resultVO.getPageInfo().toString());
        
        return resultVO;
	}

    /**
     * 학습진도관리 전체/운영과목 현황 조회 (orgId, profId 기준)
     * @param vo
     * @return
     */
    @Override
    public EgovMap lrnPrgrtStatsSummaryAjax(SubjectVO vo) {
        return statsDAO.lrnPrgrtStatsSummarySelect(vo);
    }

    @Override
    public List<EgovMap> stdntLrnPrgrtList(SubjectVO vo) {
        return statsDAO.stdntLrnPrgrtList(vo);
    }



    /**
     * 학습자 학습진도 현황 목록 조회 페이징
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
//    public ProcessResultVO<EgovMap> stdntLrnPrgrtListPaging(PageInfo pageInfo) throws Exception {
    public ResultDTO<EgovMap> stdntLrnPrgrtListPaging(PageInfo pageInfo) {
        ResultDTO<EgovMap> resultDTO = new ResultDTO<>(pageInfo);

        // 목록 조회
        List<EgovMap> list = statsDAO.stdntLrnPrgrtListPaging(pageInfo);
//
//
//        // 페이지 전체 건수 정보 설정
//        pageInfo.setTotalRecord(list);
//
//        resultDTO.setReturnList(list);
//        resultDTO.setPageInfo(pageInfo);
//        resultDTO.setResultSuccess();

        resultDTO.setReturnList(list);

        return resultDTO.setResultSuccess();
    }


    /**
     * 학습진도관리 > 학과별 전체통계 목록 조회
     * @param vo
     * @return
     */
    @Override
    public List<EgovMap> listLrnPrgrtStatusByDept(PageInfo pageInfo){
        return statsDAO.listLrnPrgrtStatusByDept(pageInfo);
    }

    /**
     * 과목별/담당별 학습진도현황 목록 조회
     * @param pageInfo
     * @return
     * @throws Exception
     */
    @Override
    public ResultDTO<EgovMap> lrnPrgStsListPaging(PageInfo pageInfo) {
        ResultDTO<EgovMap> resultDTO = new ResultDTO<>(pageInfo);

        String orgId  = pageInfo.getOrgId();
        String dgrsYr = pageInfo.getDgrsYr();
        String dgrsSmstrChrt = pageInfo.getDgrsSmstrChrt();

        List<EgovMap> returnList = statsDAO.lrnPrgStsListPaging(pageInfo);

        if(!returnList.isEmpty()) {
            resultDTO.getPageInfo().setTotalRecordCount(Integer.parseInt(returnList.get(0).get("totalCnt").toString()));
        } else {
            resultDTO.getPageInfo().setTotalRecordCount(0);
        }

        resultDTO.setReturnList(returnList);
        resultDTO.setData(statsDAO.admLrnPrgStsAllAvgSelect(orgId,dgrsYr,dgrsSmstrChrt));


        return resultDTO.setResultSuccess();
    }

//    @Override
//    public ResultDTO<EgovMap> admLrnPrgStsAllAvgSelectAjax(PageInfo pageInfo) {
//        ResultDTO<EgovMap> resultDTO = new ResultDTO<>();
//
//
//
//        return resultDTO;
//    }
}