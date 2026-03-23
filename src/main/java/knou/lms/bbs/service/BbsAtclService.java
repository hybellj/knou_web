package knou.lms.bbs.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.bbs.vo.BbsAtclVO;
import knou.lms.common.vo.ProcessResultVO;

public interface BbsAtclService {

    /*****************************************************
     * 게시글 정보
     * @param vo
     * @return BbsAtclVO
     * @throws Exception
     ******************************************************/
    public BbsAtclVO selectBbsAtcl(BbsAtclVO vo) throws Exception;

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
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<BbsAtclVO> listBbsAtclPaging(BbsAtclVO vo) throws Exception;

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
    public void deleteBbsAtcl(BbsAtclVO vo) throws Exception;

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
     * @return BbsAtclVO
     * @throws Exception
     ******************************************************/
    public BbsAtclVO viewBbsAtcl(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 게시글 조회수 수정
     * @param vo
     * @return BbsAtclVO
     * @throws Exception
     ******************************************************/
    public BbsAtclVO updateBbsAtclGoodCnt(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 분반 게시글 정보 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listDeclsBbsAtcl(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 강의실 게시글 복사
     * @param vo
     * @return
     * @throws Exception
     ******************************************************/
    public void copyAtclToNewCourse(BbsAtclVO vo) throws Exception;

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
     * 게시판게시글 목록 조회
     * @param vo
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<BbsAtclVO> selectBbsAtclList(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 대시보드 카드 목록
     * @param vo
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listRecentBbsToday(BbsAtclVO vo) throws Exception;
    public List<EgovMap> listRecentBbsLctrQna(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 답변 저장
     * @param vo
     * @throws Exception
     ******************************************************/
    public void bbsAtclRspnsRegist(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 메뉴 > 글로벌메뉴 > 과목공지 저장
     * @param vo
     * @throws Exception
     ******************************************************/
    public void bbsAtclSbjctRegist(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 메뉴 > 글로벌메뉴 > 과목공지 상세 불러오기 (단일 조회)
     * @param vo
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<BbsAtclVO> selectBbsSbjctDtlView(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 게시판 > 과목공지 > 그룹 공지 사항
     * @param vo
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<BbsAtclVO> selectBbsAtclGrpNtcList(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 게시판 > 과목공지 > 그룹 공지 사항 팝업
     * @param vo
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<BbsAtclVO> selectBbsAtclGrpNtcPopView(BbsAtclVO vo) throws Exception;
}