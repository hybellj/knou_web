package knou.lms.log2.user.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.log2.user.vo.LogUserActvVO;

public interface LogUserActvService {

	/**
     * 사용자과목개설활동이력목록조회
     * @param 	sbjctId	과목아이디
     * @param 	timeRange	시간범위 - 30분전
     * @throws 	Exception
     */
	//public Object userSbjctOfrngActvHstryList(String sbjctId, int timeRange) throws Exception;

    /*****************************************************
     * 강의실 활동 로그 조회 현황 목록 페이징 (TB_LMS_LOG_USER_ACTV)
     * @param LogUserActvVO
     * @return ProcessResultVO<LogUserActvVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<LogUserActvVO> selectLogUserActvList(LogUserActvVO vo) throws Exception;
}
