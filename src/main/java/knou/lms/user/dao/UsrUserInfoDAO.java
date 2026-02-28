package knou.lms.user.dao;


import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.common.vo.OrgAuthGrpVO;
import knou.lms.user.vo.UsrDeptCdVO;
import knou.lms.user.vo.UsrUserInfoVO;

@Mapper("usrUserInfoDAO")
public interface UsrUserInfoDAO {
    
    /**
     * 사용자 회원 정보의 로그인용 상세 정보를 조회한다.
     * @param  UsrUserInfoVO 
     * @return UsrUserInfoVO
     * @throws Exception
     */
    public UsrUserInfoVO selectForLogin(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 사용자 회원 정보의 로그인용 상세 정보를 조회한다.
     * @param  UsrUserInfoVO 
     * @return UsrUserInfoVO
     * @throws Exception
     */
    public UsrUserInfoVO selectForLoginCheck(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 사용자 회원 정보 수정
     * @param  UsrUserInfoVO 
     * @return void
     * @throws Exception
     */
    public void update(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 사용자 페이징 목록
     * @param  UsrUserInfoVO 
     * @return List<UsrUserInfoVO>
     * @throws Exception
     */
    public List<UsrUserInfoVO> listPaging(UsrUserInfoVO vo) throws Exception;
    public int totalCount(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 사용자 정보 조회
     * @param  UsrUserInfoVO 
     * @return UsrUserInfoVO
     * @throws Exception
     */
    public UsrUserInfoVO select(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 사용자 엑셀업로드 할떄 등록가능한 권한 목록
     * @param  OrgAuthGrpVO 
     * @return List<OrgAuthGrpVO>
     * @throws Exception
     */
    public List<OrgAuthGrpVO> listExcelUploadAuthGrp(OrgAuthGrpVO vo) throws Exception;
    
    /**
     * 사용자 정보 등록
     * @param  UsrUserInfoVO 
     * @return void
     * @throws Exception
     */
    public void insert(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 사용자 회원 정보의 로그인용 상세 정보를 조회한다.
     * @param  UsrUserInfoVO 
     * @return UsrUserInfoVO
     * @throws Exception
     */
    public UsrUserInfoVO selectForCompare(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 사용자의 이름과 이메일로 사용자 정보 검색
     * @param  UsrUserInfoVO 
     * @return UsrUserInfoVO
     * @throws Exception
     */
    public UsrUserInfoVO selectSearchId(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 사용자 목록 검색 ( 학생 )
     * @param  UsrUserInfoVO 
     * @return List<UsrUserInfoVO>
     * @throws Exception
     */
    public List<UsrUserInfoVO> listSearchByStudent(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 사용자 목록 검색 ( 교직원 )
     * @param  UsrUserInfoVO 
     * @return List<UsrUserInfoVO>
     * @throws Exception
     */
    public List<UsrUserInfoVO> listSearchByProfessor(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 사용자 탈퇴 ZOOM 값 제거
     * @param  UsrUserInfoVO 
     * @return void
     * @throws Exception
     */
    public void updateWithdrawal(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 학생 탈퇴 수정
     * @param  UsrUserInfoVO 
     * @return void
     * @throws Exception
     */
    public void updateWithdrawalStd(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 특정 tcId 사용자 정보 조회
     * @param  UsrUserInfoVO 
     * @return UsrUserInfoVO
     * @throws Exception
     */
    public UsrUserInfoVO selectByTcId(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 사용자 환경설정 수정
     * @param  UsrUserInfoVO 
     * @return void
     * @throws Exception
     */
    public void updateUserConf(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 사용자 정보의 검색된 수를 카운트 한다. 
     * @param  UsrDeptCdVO 
     * @return int
     * @throws Exception
     */
    public int count(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 사용자 정보의 전체 목록을 조회한다. 
     * @param  UsrDeptCdVO 
     * @return List
     * @throws Exception
     */
    public List<UsrUserInfoVO> listPageing(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 장애인 시험지원 취소 신청 여부 조회
     * @param  UsrUserInfoVO 
     * @return UsrUserInfoVO
     * @throws Exception
     */
    public UsrUserInfoVO selectUserByDisabilityCancelGbn(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 장애인 시험지원 수정
     * @param  UsrUserInfoVO 
     * @return void
     * @throws Exception
     */
    public void updateDisability(UsrUserInfoVO vo) throws Exception;

    // 학과관리 사용여부
	public int editUseYn(UsrDeptCdVO vo) throws Exception;
	
	/**
     * 사용가능한 사용자 조회
     * @param  UsrUserInfoVO 
     * @return void
     * @throws Exception
     */
    public List<UsrUserInfoVO> listAvailableUser(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 재학생 중 대학생 or 학부생 조회
     * @param  UsrUserInfoVO 
     * @return List<UsrUserInfoVO>
     * @throws Exception
     */
    public List<UsrUserInfoVO> listStudentByUniCd(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 사용자 수신정보 조회
     * @param  UsrUserInfoVO 
     * @return UsrUserInfoVO
     * @throws Exception
     */
    public UsrUserInfoVO selectUserRecvInfo(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 사용자 수신정보 목록 조회
     * @param  UsrUserInfoVO 
     * @return List<UsrUserInfoVO>
     * @throws Exception
     */
    public List<UsrUserInfoVO> listUserRecvInfo(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 임시 사용자(학생) 등록
     * @param vo
     * @throws Exception
     */
    public void insertTmpUser(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 메뉴 구분별 사용자 목록 수
     * @param vo
     * @return int
     * @throws Exception
     */
    public int countUserByMenuType(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 메뉴 구분별 사용자 목록 
     * @param vo
     * @return List<UsrUserInfoVO>
     * @throws Exception
     */
    public List<UsrUserInfoVO> listUserByMenuType(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 메뉴 구분별 사용자 목록 페이징
     * @param vo
     * @return List<UsrUserInfoVO>
     * @throws Exception
     */
    public List<UsrUserInfoVO> listPagingUserByMenuType(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 한사대 사용자 목록 검색(운영자,교수)
     * @param  UsrUserInfoVO 
     * @return List<UsrUserInfoVO>
     * @throws Exception
     */
    public List<UsrUserInfoVO> listSearchByKnouUser(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 기관사용자 한사대 사용자 연결 조회
     * @param  UsrUserInfoVO 
     * @param  UsrUserInfoVO
     * @throws Exception
     */
    public UsrUserInfoVO selectUserOrgRltn(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 기관사용자 한사대 사용자 연결 저장
     * @param  UsrUserInfoVO 
     * @throws Exception
     */
    public void insertUserOrgRltn(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 기관사용자 한사대 사용자 연결 수정
     * @param  UsrUserInfoVO 
     * @throws Exception
     */
    public void updateUserOrgRltn(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 기관사용자 한사대 사용자 연결 조회 (by 한사대계정)
     * @param  UsrUserInfoVO 
     * @return List<UsrUserInfoVO>
     * @throws Exception
     */
    public List<UsrUserInfoVO> selectUserOrgRltnByKnouUser(UsrUserInfoVO vo) throws Exception;
}
