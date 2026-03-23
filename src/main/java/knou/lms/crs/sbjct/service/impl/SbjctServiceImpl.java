package knou.lms.crs.sbjct.service.impl;

import java.util.List;

import javax.annotation.Resource;

import knou.framework.common.PageInfo;
import knou.framework.common.ServiceBase;
import knou.lms.bbs.vo.BbsAtclVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.sbjct.vo.*;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Service;

import knou.lms.crs.sbjct.dao.SbjctDAO;
import knou.lms.crs.sbjct.service.SbjctService;

@Service("sbjctService")
public class SbjctServiceImpl extends ServiceBase implements SbjctService {

    @Resource(name = "sbjctDAO")
    private SbjctDAO sbjctDAO;

    /**
     * 과목목록조회
     * @param sbjctListVO
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<SbjctListVO> selectSbjctList(SbjctListVO sbjctListVO) throws Exception {
        ProcessResultVO<SbjctListVO> processResultVO = new ProcessResultVO<>();

        // 페이지 정보 설정
        PageInfo pageInfo = new PageInfo(sbjctListVO);

        // 목록 조회
        List<SbjctListVO> sbjctList = sbjctDAO.selectSbjctList(sbjctListVO);

        // 페이지 전체 건수정보 설정
        pageInfo.setTotalRecord(sbjctList);

        processResultVO.setReturnList(sbjctList);
        processResultVO.setPageInfo(pageInfo);

        return processResultVO;
    }

    /**
     * 과목사용유무변경
     * @param sbjctListVO
     * @return
     * @throws Exception
     */
    @Override
    public int updateSbjctUseYn(SbjctListVO sbjctListVO) throws Exception {
        return sbjctDAO.updateSbjctUseYn(sbjctListVO);
    }

    /**
     * 과목삭제
     * @param sbjctListVO
     * @return
     * @throws Exception
     */
    @Override
    public int deleteSbjct(SbjctListVO sbjctListVO) throws Exception {
        return sbjctDAO.deleteSbjct(sbjctListVO);
    }

    @Override
    public List<DgrsYrChrtVO> selectDgrsYrChrtList(String orgId) throws Exception {
        return sbjctDAO.selectDgrsYrChrtList(orgId);
    }

    /*****************************************************
     * 학과(부서) 목록 조회
     *
     * @param SbjctVO
     * @return List<SbjctVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<SbjctVO> list(SbjctVO vo) throws Exception {
        return sbjctDAO.list(vo);
    }
}
