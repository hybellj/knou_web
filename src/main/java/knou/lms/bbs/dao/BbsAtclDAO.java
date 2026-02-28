package knou.lms.bbs.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.bbs.vo.BbsAtclVO;

/**
 * 게시판게시글 DAO
 */
@Mapper("bbsAtclDAO")
public interface BbsAtclDAO {

    /*****************************************************
     * 게시글 목록 수
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    public int countBbsAtcl(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 게시글 목록
     * @param vo
     * @return List<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    public List<BbsAtclVO> listBbsAtcl(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 게시글 목록 페이징
     * @param vo
     * @return List<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    public List<BbsAtclVO> listBbsAtclPaging(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 게시글 정보 저장
     * @param vo
     * @throws Exception
     ******************************************************/
    public void insertBbsAtcl(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 게시글 정보 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    public void updateBbsAtcl(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 게시글 삭제
     * @param vo
     * @throws Exception
     ******************************************************/
    public void updateBbsAtclDelYn(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 게시글 답글 목록
     * @param vo
     * @return List<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    public List<BbsAtclVO> listBbsAtclAnswer(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 게시글 좋아요 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    public void updateBbsAtclGoodCnt(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 게시글 조회수 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    public void updateBbsAtclHits(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 분반 게시글 ID 정보 등록
     * @param vo
     * @throws Exception
     ******************************************************/
    public void updateDeclsAtcl(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 분반 게시글 정보 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listDeclsBbsAtcl(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 게시글 복사
     * @param vo
     * @throws Exception
     ******************************************************/
    public void insertCopyAtcl(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 게시글 수정(선수강과목 이관용)
     * @param BbsAtclVO
     * @throws Exception
     ******************************************************/
    public void updateBbsAtclForTrans(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 이전글 다음글 조회
     * @param vo
     * @return BbsAtclVO
     * @throws Exception
     ******************************************************/
    public BbsAtclVO selectPrevNextAtcl(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 전체공지 최신글 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listRecentNotice(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 최신글 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listRecentBbsAtcl(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * QnA, 1:1상담 미답변수 정보
     * @param vo
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    public EgovMap selectNoAnswerAtclStatus(BbsAtclVO vo) throws Exception;



    /*
    TODO 새로 생성되거나 명칭 변경해서 작업하는 메쏘드는 여기 아래에......
    */


    /*****************************************************
     * 게시판게시글 목록
     * @param vo
     * @return List<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    public List<BbsAtclVO> selectBbsAtclList(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 게시글 정보
     * @param vo
     * @return BbsAtclVO
     * @throws Exception
     ******************************************************/
    public BbsAtclVO selectBbsAtcl(BbsAtclVO vo) throws Exception;

    public List<EgovMap> listRecentBbsToday(BbsAtclVO vo) throws Exception;
    public List<EgovMap> listRecentBbsLctrQna(BbsAtclVO vo) throws Exception;
}