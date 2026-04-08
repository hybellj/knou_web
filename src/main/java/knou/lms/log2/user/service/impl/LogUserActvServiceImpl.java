package knou.lms.log2.user.service.impl;

import java.util.List;

import javax.annotation.Resource;

import knou.framework.common.PageInfo;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.log2.user.dao.LogUserActvDAO;
import knou.lms.log2.user.service.LogUserActvService;
import knou.lms.log2.user.vo.LectCntnInfoVO;

@Service("logUserActvService")
public class LogUserActvServiceImpl extends ServiceBase implements LogUserActvService {

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
}
