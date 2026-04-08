package knou.lms.bbs.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.bbs.vo.BbsInfoVO;
import knou.lms.bbs.vo.BbsVO;

@Mapper("bbsInfoDAO")
public interface BbsInfoDAO {

    /*****************************************************
     * 게시판 정보
     * @param vo
     * @return BbsInfoVO
     * @throws Exception
     ******************************************************/
    public BbsInfoVO selectBbsInfo(BbsInfoVO vo) throws Exception;

    /*****************************************************
     * 게시판 목록 수
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    public int countBbsInfo(BbsInfoVO vo) throws Exception;

    /*****************************************************
     * 게시판 목록
     * @param vo
     * @return List<BbsInfoVO>
     * @throws Exception
     ******************************************************/
    public List<BbsInfoVO> listBbsInfo(BbsInfoVO vo) throws Exception;

    /*****************************************************
     * 게시판 목록 페이징
     * @param vo
     * @return List<BbsInfoVO>
     * @throws Exception
     ******************************************************/
    public List<BbsInfoVO> listBbsInfoPaging(BbsInfoVO vo) throws Exception;

    /*****************************************************
     * 게시판 정보 저장
     * @param vo
     * @throws Exception
     ******************************************************/
    public void insertBbsInfo(BbsInfoVO vo) throws Exception;

    /*****************************************************
     * 게시판 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    public void updateBbsInfo(BbsInfoVO vo) throws Exception;

    /*****************************************************
     * 게시판 삭제
     * @param vo
     * @throws Exception
     ******************************************************/
    public void deleteBbsInfo(BbsInfoVO vo) throws Exception;

    /*****************************************************
     * 게시판 학생 공개 여부 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    public void updateBbsInfoStdViewYn(BbsInfoVO vo) throws Exception;

    /*****************************************************
     * 게시판 사용여부 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    public void updateBbsInfoUseYn(BbsInfoVO vo) throws Exception;

    /*****************************************************
     * 게시판 강의실 탭
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listBbsInfoCourseTab(EgovMap vo) throws Exception;

    /*****************************************************
     * 게시판 강의실 알림터 탭
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listBbsInfoCourseAlarmTab(EgovMap vo) throws Exception;

    /*****************************************************
     * 게시판 강의실 학생 강의공지 탭
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listBbsInfoCourseStudentTab(BbsInfoVO vo) throws Exception;

    /*****************************************************
     * 게시판 상담교수 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listBbsInfoCouncelProf(BbsInfoVO vo) throws Exception;

    /*****************************************************
     * 게시판 분반 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listBbsInfoDecls(BbsInfoVO vo) throws Exception;

    /*****************************************************
     * 게시판 문의, 상담 현황 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listQnaSecretCountByLsnOdr(BbsInfoVO vo) throws Exception;

    /*****************************************************
     * 게시판 팀 카테고리 목록
     * @param vo
     * @return List<BbsInfoVO>
     * @throws Exception
     ******************************************************/
    public List<BbsInfoVO> listBbsInfoTeamCtgr(BbsInfoVO vo) throws Exception;

    /*****************************************************
     * 게시판 팀 목록
     * @param vo
     * @return List<BbsInfoVO>
     * @throws Exception
     ******************************************************/
    public List<BbsInfoVO> listTeamBbsId(BbsInfoVO vo) throws Exception;

    /*****************************************************
     * 팀 게시판 조회
     * @param vo
     * @return BbsInfoVO
     * @throws Exception
     ******************************************************/
    public BbsInfoVO selectTeamBbsInfo(BbsInfoVO vo) throws Exception;

    /*****************************************************
     * 게시판 팀원여부 체크
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    public int countTeamBbsMember(EgovMap vo) throws Exception;

    /*****************************************************
     * 게시판 코드별 생성일 빠른 게시판 조회
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    public BbsInfoVO selectBbsInfoByOldRegDttm(BbsInfoVO vo) throws Exception;




    /*
    TODO 새로 생성되거나 명칭 변경해서 작업하는 메쏘드는 여기 아래에......
    */


    /*****************************************************
     * 게시판 정보
     * @param vo
     * @return BbsInfoVO
     * @throws Exception
     ******************************************************/
    public BbsVO selectBbs(BbsVO vo) throws Exception;

    /*****************************************************
     * 게시판 정보_강의실
     * @param vo
     * @return BbsInfoVO
     * @throws Exception
     ******************************************************/
    public BbsVO selectBbsLect(BbsVO vo) throws Exception;

    /*****************************************************
     * 게시판 정보 저장
     * @param vo
     * @return BbsVO
     * @throws Exception
     ******************************************************/
    public void bbsInfoRegist(BbsVO vo) throws Exception;

    /*****************************************************
     * 게시판 정보 옵션 저장
     * @param vo
     * @return BbsVO
     * @throws Exception
     ******************************************************/
    public void bbsInfoOptnRegist(BbsVO vo) throws Exception;

    /*****************************************************
     * 강의실 메뉴의 게시판 목록 조회
     * @param vo
     * @return List<BbsVO>
     * @throws Exception
     ******************************************************/
    public List<BbsVO> selectBbsForSbjctMenu(BbsVO vo) throws Exception;

    /*****************************************************
     * 게시판 목록 페이징
     * @param vo
     * @return List<BbsInfoVO>
     * @throws Exception
     ******************************************************/
    public List<BbsVO> countBbsInfo(BbsVO vo) throws Exception;

    /*****************************************************
     * 게시판 목록 페이징
     * @param vo
     * @return List<BbsVO>
     * @throws Exception
     ******************************************************/
    public List<BbsVO> listBbsMngInfoPaging(BbsVO vo) throws Exception;

    /*****************************************************
     * 게시판 정보 저장
     * @param vo
     * @throws Exception
     ******************************************************/
    public void bbsMngInfoRegist(BbsVO vo) throws Exception;

    /*****************************************************
     * 게시판 옵션 정보 저장
     * @param vo
     * @throws Exception
     ******************************************************/
    public void bbsMngInfoOptnRegist(BbsVO vo) throws Exception;

    /*****************************************************
     * 게시판 정보 > 게시판 유형 조회
     * @param vo
     * @return BbsVO
     * @throws Exception
     ******************************************************/
    public String getBbsTycd(BbsVO vo) throws Exception;

    /*****************************************************
     * 게시판 정보 > 게시판 ID 조회
     * @param vo
     * @return BbsVO
     * @throws Exception
     ******************************************************/
    public String getBbsId(BbsVO vo) throws Exception;
}