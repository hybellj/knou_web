package knou.lms.bbs.service.impl;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.bbs.dao.BbsCmntDAO;
import knou.lms.bbs.service.BbsAtclService;
import knou.lms.bbs.service.BbsCmntService;
import knou.lms.bbs.vo.BbsAtclVO;
import knou.lms.bbs.vo.BbsCmntVO;
import knou.lms.bbs.vo.BbsInfoVO;
import knou.lms.bbs.web.util.BbsAuthUtil;
import knou.lms.common.vo.ProcessResultVO;

@Service("bbsCmntService")
public class BbsCmntServiceImpl extends ServiceBase implements BbsCmntService {

    private static final Logger LOGGER = LoggerFactory.getLogger(BbsCmntServiceImpl.class);
    
    @Resource(name = "bbsCmntDAO")
    private BbsCmntDAO bbsCmntDAO;
    
    @Resource(name = "bbsAtclService")
    private BbsAtclService bbsAtclService;

    /***************************************************** 
     * 댓글 정보
     * @param vo
     * @return BbsCmntVO
     * @throws Exception
     ******************************************************/
    @Override
    public BbsCmntVO selectBbsCmnt(BbsCmntVO vo) throws Exception {
        return bbsCmntDAO.selectBbsCmnt(vo);
    }
    
    /***************************************************** 
     * 댓글 목록
     * @param vo
     * @return List<BbsCmntVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<BbsCmntVO> listBbsCmnt(BbsCmntVO vo) throws Exception {
        return bbsCmntDAO.listBbsCmnt(vo);
    }
    
    /***************************************************** 
     * 댓글 목록 페이징
     * @param vo
     * @return ProcessResultVO<BbsCmntVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<BbsCmntVO> listBbsCmntPaging(BbsCmntVO vo) throws Exception {
        ProcessResultVO<BbsCmntVO> processResultVO = new ProcessResultVO<>();
    
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());
        
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        int totCnt = bbsCmntDAO.countBbsCmnt(vo);
        
        paginationInfo.setTotalRecordCount(totCnt);
        
        List<BbsCmntVO> resultList = bbsCmntDAO.listBbsCmntPaging(vo);
        
        processResultVO.setReturnList(resultList);
        processResultVO.setPageInfo(paginationInfo);
        
        // 미삭제 댓글 수 조회
        int delNCnt = bbsCmntDAO.countBbsCmntDelN(vo);
        BbsCmntVO bbsCmntVO = new BbsCmntVO();
        bbsCmntVO.setTotalCnt(delNCnt);
        processResultVO.setReturnVO(bbsCmntVO);
        
        return processResultVO;
    }
    
    /***************************************************** 
     * 댓글 목록 페이징 (수정, 삭제 권한 체크)
     * @param request
     * @param bbsInfoVO
     * @param bbsAtclVO
     * @param vo
     * @return ProcessResultVO<BbsCmntVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<BbsCmntVO> listBbsCmntPagingWithAuth(HttpServletRequest request, BbsInfoVO bbsInfoVO, BbsAtclVO bbsAtclVO, BbsCmntVO vo) throws Exception {
        ProcessResultVO<BbsCmntVO> processResultVO = this.listBbsCmntPaging(vo);
        
        List<BbsCmntVO> resultList = processResultVO.getReturnList();
        
        for(BbsCmntVO bbsCmntVO : resultList) {
            bbsCmntVO.setEditAuthYn(BbsAuthUtil.getCommentEditAuth(request, bbsInfoVO, bbsAtclVO, bbsCmntVO));
            bbsCmntVO.setDeleteAuthYn(BbsAuthUtil.getCommentDeleteAuth(request, bbsInfoVO, bbsAtclVO, bbsCmntVO));
        }
        
        return processResultVO;
    }
    
    /***************************************************** 
     * 댓글 저장
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void insertBbsCmnt(BbsCmntVO vo) throws Exception {
        String cmntId = IdGenerator.getNewId("CMNT");
        vo.setCmntId(cmntId);
        
        if(ValidationUtils.isEmpty(vo.getParCmntId())) {
            vo.setParCmntId(null);
        }
        
        // 스크립트 태그 제거
        vo.setCmntCts(StringUtil.removeScript(vo.getCmntCts()));
        
        bbsCmntDAO.insertBbsCmnt(vo);
    }

    /***************************************************** 
     * 댓글 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void updateBbsCmnt(BbsCmntVO vo) throws Exception {
    	
        // 스크립트 태그 제거
        vo.setCmntCts(StringUtil.removeScript(vo.getCmntCts()));
    	
        bbsCmntDAO.updateBbsCmnt(vo);
    }

    /***************************************************** 
     * 댓글 삭제
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void updateBbsCmntDelY(BbsCmntVO vo) throws Exception {
        bbsCmntDAO.updateBbsCmntDelY(vo);
    }

    /***************************************************** 
     * 댓글 삭제
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void deleteBbsCmnt(BbsCmntVO vo) throws Exception {
        bbsCmntDAO.deleteBbsCmnt(vo);
    }

    /***************************************************** 
     * 댓글 전체 삭제
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void deleteBbsCmntAll(BbsCmntVO vo) throws Exception {
        bbsCmntDAO.deleteBbsCmntAll(vo);
        
    }

    /***************************************************** 
     * 피드백 문의 등록
     * @param vo
     * @param bbsAtclVO
     * @throws Exception
     ******************************************************/
    @Override
    public void insertWithFeedback(BbsCmntVO vo, BbsAtclVO bbsAtclVO) throws Exception {
        int cmntCtsLen = 0;
        String cmntCts = vo.getCmntCts();
        
        if(!"".equals(StringUtil.nvl(cmntCts))) {
            cmntCtsLen = vo.getCmntCts().length();
        }
        
        // 최대 20자
        if(cmntCtsLen > 20) {
            cmntCtsLen = 20;
        }
        
        BbsAtclVO feedBackAtclVO = new BbsAtclVO();
        feedBackAtclVO.setCrsCreCd(bbsAtclVO.getCrsCreCd());
        feedBackAtclVO.setBbsId(bbsAtclVO.getBbsId());
        feedBackAtclVO.setAtclTtl(StringUtil.substring(cmntCts, 0, cmntCtsLen));
        feedBackAtclVO.setAtclCts(vo.getCmntCts());
        feedBackAtclVO.setRgtrId(vo.getRgtrId());
        bbsAtclService.insertBbsAtcl(feedBackAtclVO);
        
        this.insertBbsCmnt(vo);
    }

}