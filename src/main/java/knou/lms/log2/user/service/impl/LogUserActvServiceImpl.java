package knou.lms.log2.user.service.impl;

import java.util.List;

import javax.annotation.Resource;

import knou.framework.util.DateTimeUtil;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import knou.framework.common.PageInfo;
import knou.framework.common.ServiceBase;
import knou.lms.common.dto.ResultDTO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.log2.user.dao.LogUserActvDAO;
import knou.lms.log2.user.service.LogUserActvService;
import knou.lms.log2.user.vo.LectCntnInfoVO;
import knou.lms.log2.user.vo.LogTutActvVO;
import knou.lms.log2.user.vo.LogUserActvVO;
import knou.lms.log2.user.vo.UserActvHstryVO;

@Service("logUserActvService")
public class LogUserActvServiceImpl extends ServiceBase implements LogUserActvService {

    private static final Logger log = LoggerFactory.getLogger(LogUserActvServiceImpl.class);

    @Resource(name="logUserActvDAO")
    private LogUserActvDAO logUserActvDAO;

    /*****************************************************
     * 교수강의실과목설정접속정보 목록 페이징
     * @param lectCntnInfoVO
     * @return ProcessResultVO<LectCntnInfoVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<LectCntnInfoVO> selectProfSbjctStngCntnInfoList(LectCntnInfoVO lectCntnInfoVO) throws Exception {
        ProcessResultVO<LectCntnInfoVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(lectCntnInfoVO);
        List<LectCntnInfoVO> list = logUserActvDAO.selectProfSbjctStngCntnInfoList(lectCntnInfoVO);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);
        resultVO.setResultSuccess();

        return resultVO;
    }

    /**
     * 사용자 접속 현황 목록 조회
     *
     * @param vo
     * @return
     */
    @Override
    public List<EgovMap> userCntnStsList(LogUserActvVO vo) {
        List<EgovMap> returnList = logUserActvDAO.userCntnStsList(vo);

        if(returnList.isEmpty()) return null;

        for(EgovMap map : returnList) {
            String actvDttm = (String) map.get("actvDttm");
            actvDttm = DateTimeUtil.getDateType(0, actvDttm);
            map.replace("actvDttm", actvDttm);
        }

        return returnList;
    }

    /**
     * 기관별 사용자 접속 인원수 조회
     *
     * @param vo
     * @return
     */
    @Override
    public List<EgovMap> userCntnCntSummary(LogUserActvVO vo) {
        return logUserActvDAO.userCntnCntByOrgId(vo);
    }

    @Override
    public EgovMap userCntnCnt(LogUserActvVO vo) {
        return null;
    }

    @Async
    @Override
    public void userActvLogInsert(LogUserActvVO userActv) throws Exception {
        log.info(userActv.toString());
        logUserActvDAO.userActvLogInsert(userActv);
    }

    @Async
    @Override
    public void tutorActvLogInsert(LogTutActvVO tutorActv) throws Exception {
        logUserActvDAO.tutorActvLogInsert(tutorActv);
    }

    @Override
    public ProcessResultVO<EgovMap> admCntnLogListPaging(PageInfo pageInfo) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>(pageInfo);

        resultVO.getPageInfo().setTotalRecordCount(logUserActvDAO.admCntnLogListCnt((PageInfo) pageInfo));

        resultVO.setReturnList(logUserActvDAO.admCntnLogListPaging((PageInfo) pageInfo));

        return resultVO;
    }

    /**
     * 사용자접속이력 목록
     */
    @Override
    public ResultDTO<EgovMap> userActvHstryList(UserActvHstryVO vo) throws Exception {
        vo.normalizeSearchParams();

        ResultDTO<EgovMap> resultDTO = new ResultDTO<EgovMap>(vo);
        resultDTO.getPageInfo().setTotalRecordCount(logUserActvDAO.countUserActvHstry(vo));
        resultDTO.setReturnList(logUserActvDAO.listUserActvHstryPaging(vo));
        return resultDTO;
    }

    /**
     * 사용자접속이력 엑셀 목록
     */
    @Override
    public List<EgovMap> userActvHstryExcelList(UserActvHstryVO vo) throws Exception {
        vo.normalizeSearchParams();
        List<EgovMap> list = logUserActvDAO.listUserActvHstry(vo);
        for (int i = 0; i < list.size(); i++) {
            EgovMap item = list.get(i);
            Object actvDttm = item.get("actvDttm");
            item.put("no", list.size() - i);
            item.put("actvDttm", actvDttm == null ? "" : DateTimeUtil.getDateType(8, String.valueOf(actvDttm)));
        }
        return list;
    }

    /**
     * 사용자접속이력 검색조건 과목 목록
     */
    @Override
    public List<EgovMap> userActvHstrySbjctList(UserActvHstryVO vo) throws Exception {
        return logUserActvDAO.listUserActvHstrySbjct(vo);
    }
}
