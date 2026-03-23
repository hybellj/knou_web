package knou.lms.bbs.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import knou.lms.bbs.vo.BbsAtclVO;
import knou.lms.bbs.vo.BbsCmntVO;
import knou.lms.bbs.vo.BbsInfoVO;
import knou.lms.common.vo.ProcessResultVO;

public interface BbsCmntService {

    /*****************************************************
     * 댓글 정보
     * @param vo
     * @return BbsCmntVO
     * @throws Exception
     ******************************************************/
    public BbsCmntVO selectBbsCmnt(BbsCmntVO vo) throws Exception;

    /*****************************************************
     * 댓글 목록
     * @param vo
     * @return List<BbsCmntVO>
     * @throws Exception
     ******************************************************/
    public List<BbsCmntVO> listBbsCmnt(BbsCmntVO vo) throws Exception;

    /*****************************************************
     * 댓글 목록 페이징
     * @param vo
     * @return ProcessResultVO<BbsCmntVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<BbsCmntVO> listBbsCmntPaging(BbsCmntVO vo) throws Exception;

    /*****************************************************
     * 댓글 목록 페이징 (수정, 삭제 권한 체크)
     * @param request
     * @param bbsInfoVO
     * @param bbsAtclVO
     * @param vo
     * @return ProcessResultVO<BbsCmntVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<BbsCmntVO> listBbsCmntPagingWithAuth(HttpServletRequest request, BbsInfoVO bbsInfoVO, BbsAtclVO bbsAtclVO, BbsCmntVO vo) throws Exception;

    /*****************************************************
     * 댓글 저장
     * @param vo
     * @throws Exception
     ******************************************************/
    public void insertBbsCmnt(BbsCmntVO vo) throws Exception;

    /*****************************************************
     * 댓글 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    public void updateBbsCmnt(BbsCmntVO vo) throws Exception;

    /*****************************************************
     * 댓글 삭제
     * @param vo
     * @throws Exception
     ******************************************************/
    public void updateBbsCmntDelY(BbsCmntVO vo) throws Exception;

    /*****************************************************
     * 댓글 삭제
     * @param vo
     * @throws Exception
     ******************************************************/
    public void deleteBbsCmnt(BbsCmntVO vo) throws Exception;

    /*****************************************************
     * 댓글 전체 삭제
     * @param vo
     * @throws Exception
     ******************************************************/
    public void deleteBbsCmntAll(BbsCmntVO vo) throws Exception;

    /*****************************************************
     * 피드백 문의 등록
     * @param vo
     * @param bbsAtclVO
     * @throws Exception
     ******************************************************/
    public void insertWithFeedback(BbsCmntVO vo, BbsAtclVO bbsAtclVO) throws Exception;

    /*****************************************************
     * 게시판 게시글 댓글 목록 조회
     * @param vo
     * @return ProcessResultVO<BbsCmntVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<BbsCmntVO> selectBbsAtclCmntList(BbsCmntVO vo) throws Exception;

    /*****************************************************
     * 댓글 저장
     * @param vo
     * @throws Exception
     ******************************************************/
    public void bbsAtclCmntRegist(BbsCmntVO vo) throws Exception;

    /*****************************************************
     * 댓글 삭제
     * @param vo
     * @throws Exception
     ******************************************************/
    public void bbsAtclCmntDelete(BbsCmntVO vo) throws Exception;
}