package knou.lms.bbs.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.bbs.vo.BbsAtclVO;
import knou.lms.bbs.vo.BbsInfoVO;
import knou.lms.bbs.vo.BbsVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.org.vo.OrgInfoVO;

public interface BbsInfoService {

    /*****************************************************
     * 게시판 정보
     * @param vo
     * @return BbsVO
     * @throws Exception
     ******************************************************/
    public BbsVO selectBbsInfo(BbsVO vo) throws Exception;
    public BbsInfoVO selectBbsInfo(BbsInfoVO vo) throws Exception; // 삭제 예정

    /*****************************************************
     * 게시판 목록
     * @param vo
     * @return List<BbsVO>
     * @throws Exception
     ******************************************************/
    public List<BbsVO> listBbsInfo(BbsVO vo) throws Exception;

    /*****************************************************
     * 게시판 목록 페이징
     * @param vo
     * @return ProcessResultVO<BbsVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<BbsVO> listBbsInfoPaging(BbsVO vo) throws Exception;

    /*****************************************************
     * 게시판 정보 저장
     * @param vo
     * @throws Exception
     ******************************************************/
    public void insertBbsInfo(BbsVO vo) throws Exception;

    /*****************************************************
     * 게시판 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    public void updateBbsInfo(BbsVO vo) throws Exception;

    /*****************************************************
     * 게시판 삭제
     * @param vo
     * @throws Exception
     ******************************************************/
    public void deleteBbsInfo(BbsVO vo) throws Exception;

    /*****************************************************
     * 게시판 사용여부 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    public void updateBbsInfoUseYn(BbsVO vo) throws Exception;

    /*****************************************************
     * 게시판 학생 공개 여부 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    public void updateBbsInfoStdViewYn(BbsVO vo) throws Exception;

    /*****************************************************
     * 게시판 강의실 탭
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listBbsInfoCourseTab(HttpServletRequest request) throws Exception;

    /*****************************************************
     * 게시판 강의실 학생 강의공지 탭
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listBbsInfoCourseStudentTab(BbsVO vo) throws Exception;

    /*****************************************************
     * 게시판 선택된 탭 조회
     * @param vo
     * @return String
     * @throws Exception
     ******************************************************/
    public String getSelectedTab(HttpServletRequest request, List<EgovMap> tabList) throws Exception;

    /*****************************************************
     * 게시판 상담교수 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listBbsInfoCouncelProf(BbsVO vo) throws Exception;

    /*****************************************************
     * 게시판 분반 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listBbsInfoDecls(BbsVO vo) throws Exception;

    /*****************************************************
     * 게시판 문의, 상담 현황 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listQnaSecretCountByLsnOdr(BbsVO vo) throws Exception;

    /*****************************************************
     * 팀 게시판 등록
     * @param vo
     * @return BbsVO
     * @throws Exception
     ******************************************************/
    public BbsVO insertTeamBbs(BbsVO vo) throws Exception;

    /*****************************************************
     * 게시판 팀 카테고리 목록
     * @param vo
     * @return List<BbsVO>
     * @throws Exception
     ******************************************************/
    public List<BbsVO> listBbsInfoTeamCtgr(BbsVO vo) throws Exception;

    /*****************************************************
     * 게시판 팀 목록
     * @param vo
     * @return List<BbsVO>
     * @throws Exception
     ******************************************************/
    public List<BbsVO> listTeamBbsId(BbsVO vo) throws Exception;

    /*****************************************************
     * 팀 게시판 조회
     * @param vo
     * @return BbsVO
     * @throws Exception
     ******************************************************/
    public BbsVO selectTeamBbsInfo(BbsVO vo) throws Exception;

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
    public BbsVO selectBbsInfoByOldRegDttm(BbsVO vo) throws Exception;



    /*
    TODO 새로 생성되거나 명칭 변경해서 작업하는 메쏘드는 여기 아래에......
    */



   /*****************************************************
    * 게시판 정보
    * @param vo
    * @return BbsVO
    * @throws Exception
    ******************************************************/
   public BbsVO selectBbs(BbsVO vo) throws Exception;

   /*****************************************************
    * 게시판 정보 확인
    * @param vo
    * @return BbsVO
    * @throws Exception
    ******************************************************/
   public BbsVO isValidBbsInfo(BbsVO vo, boolean isAdmin) throws Exception;

   /*****************************************************
    * 게시판 정보 확인_강의실
    * @param vo
    * @return BbsVO
    * @throws Exception
    ******************************************************/
   public BbsVO isValidBbsLectInfo(BbsVO vo, boolean isAdmin) throws Exception;

   /*****************************************************
    * 게시판 정보 저장
    * @param vo
    * @throws Exception
    ******************************************************/
   public void bbsInfoRegist(BbsVO vo) throws Exception;

   /*****************************************************
    * 게시판 정보 저장
    * @param vo
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
     * @return ProcessResultVO<BbsVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<BbsVO> bbsMngList(BbsVO vo) throws Exception;

    /*****************************************************
     * 게시판 정보 저장
     * @param vo
     * @throws Exception
     ******************************************************/
    public void bbsMngInfoRegist(BbsVO vo) throws Exception;

    /*****************************************************
     * 게시판 정보 > 게시판 유형 조회
     * @param vo
     * @return String
     * @throws Exception
     ******************************************************/
    public String getBbsTycd(BbsVO vo) throws Exception;

    /*****************************************************
     * 게시판 정보 > 게시판 ID 조회
     * @param vo
     * @return String
     * @throws Exception
     ******************************************************/
    public String getBbsId(BbsVO vo) throws Exception;

    /*****************************************************
     * 게시판 정보 > 게시판 사용 여부 수정
     * @param vo
     * @return String
     * @throws Exception
     ******************************************************/
    ProcessResultVO<BbsVO> modifyBbsUseyn(BbsVO vo) throws Exception;

    /*****************************************************
     * 학습그룹 목록 조회
     * @param vo
     * @return List<BbsVO>
     * @throws Exception
     ******************************************************/
    public List<BbsVO> listTeamGrp(BbsVO vo) throws Exception;

    /*****************************************************
     * 학습그룹 팀 목록 조회
     * @param vo
     * @return List<BbsVO>
     * @throws Exception
     ******************************************************/
    public List<BbsVO> listLrnTeam(BbsVO vo) throws Exception;

    /*****************************************************
     * 과제 목록 조회
     * @param vo
     * @return List<BbsVO>
     * @throws Exception
     ******************************************************/
    public List<BbsVO> listLrnElemtList(BbsVO vo) throws Exception;

    /*****************************************************
     * 과제 목록 조회
     * @param vo
     * @return List<BbsVO>
     * @throws Exception
     ******************************************************/
    public List<BbsAtclVO> listWkno(BbsAtclVO vo) throws Exception;

    /*****************************************************
     * 필터 옵션
     * @param vo
     * @return List<BbsVO>
     * @throws Exception
     ******************************************************/
    public List<SmstrChrtVO> selectBbsTermList(BbsVO vo);
    public List<OrgInfoVO> selectBbsOrgList(BbsVO vo);
    public List<BbsVO> selectBbsSubjectList(BbsVO vo);
}