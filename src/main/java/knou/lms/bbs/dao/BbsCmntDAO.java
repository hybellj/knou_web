package knou.lms.bbs.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.bbs.vo.BbsCmntVO;

@Mapper("bbsCmntDAO")
public interface BbsCmntDAO {

    /*****************************************************
     * 댓글 정보
     * @param vo
     * @return BbsCmntVO
     * @throws Exception
     ******************************************************/
    public BbsCmntVO selectBbsCmnt(BbsCmntVO vo) throws Exception;

    /*****************************************************
     * 댓글 목록 수
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    public int countBbsCmnt(BbsCmntVO vo) throws Exception;

    /*****************************************************
     * 미삭제 댓글 목록 수
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    public int countBbsCmntDelN(BbsCmntVO vo) throws Exception;

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
     * @return List<BbsCmntVO>
     * @throws Exception
     ******************************************************/
    public List<BbsCmntVO> listBbsCmntPaging(BbsCmntVO vo) throws Exception;

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
     * 게시판 게시글 댓글 목록
     * @param vo
     * @return List<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    public List<BbsCmntVO> selectBbsAtclCmntList(BbsCmntVO vo) throws Exception;

    /*****************************************************
     * 게시판 답변 여부 조회
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    public int bbsAtclCmntCnt(BbsCmntVO vo) throws Exception;

    /*****************************************************
     * 게시판 댓글 등록
     * @param vo
     * @return BbsAtclVO
     * @throws Exception
     ******************************************************/
    public void bbsAtclCmntRegist(BbsCmntVO vo) throws Exception;

    /*****************************************************
     * 게시판 댓글 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    public void bbsAtclCmntModify(BbsCmntVO vo) throws Exception;

    /*****************************************************
     * 게시글 삭제
     * @param vo
     * @throws Exception
     ******************************************************/
    public void updateBbsAtclCmntDelYn(BbsCmntVO vo) throws Exception;
}