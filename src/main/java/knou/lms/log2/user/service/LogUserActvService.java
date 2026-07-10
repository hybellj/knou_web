package knou.lms.log2.user.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.scheduling.annotation.Async;

import knou.framework.common.PageInfo;
import knou.lms.common.dto.ResultDTO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.log2.user.vo.LectCntnInfoVO;
import knou.lms.log2.user.vo.LogTutActvVO;
import knou.lms.log2.user.vo.LogUserActvVO;
import knou.lms.log2.user.vo.UserActvHstryVO;

public interface LogUserActvService {

    public ProcessResultVO<LectCntnInfoVO> selectProfSbjctStngCntnInfoList(LectCntnInfoVO vo) throws Exception;

    public List<EgovMap> userCntnStsList(LogUserActvVO vo);

    public List<EgovMap> userCntnCntSummary(LogUserActvVO vo);

    public EgovMap userCntnCnt(LogUserActvVO vo);


    @Async
    public void userActvLogInsert(LogUserActvVO userActv) throws Exception;

    @Async
    public void tutorActvLogInsert(LogTutActvVO logTutActvVO) throws Exception;

    public ProcessResultVO<EgovMap> admCntnLogListPaging(PageInfo pageInfo) throws Exception;

    public ResultDTO<EgovMap> userActvHstryList(UserActvHstryVO vo) throws Exception;

    public List<EgovMap> userActvHstryExcelList(UserActvHstryVO vo) throws Exception;

    public List<EgovMap> userActvHstrySbjctList(UserActvHstryVO vo) throws Exception;
}
