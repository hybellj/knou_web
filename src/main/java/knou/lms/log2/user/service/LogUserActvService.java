package knou.lms.log2.user.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.log2.user.vo.LectCntnInfoVO;

public interface LogUserActvService {

    public ProcessResultVO<LectCntnInfoVO> selectProfSbjctStngCntnInfoList(LectCntnInfoVO vo) throws Exception;
}
