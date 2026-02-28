package knou.lms.user.service.impl;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import knou.framework.common.CommConst;
import knou.framework.util.CryptoUtil;
import knou.framework.util.JsonUtil;
import knou.framework.util.RedisUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.user.dao.UsrLoginDAO;
import knou.lms.user.dao.UsrUserInfoChgHstyDAO;
import knou.lms.user.dao.UsrUserInfoDAO;
import knou.lms.user.service.UsrLoginService;
import knou.lms.user.vo.UsrLoginVO;
import knou.lms.user.vo.UsrUserInfoChgHstyVO;
import knou.lms.user.vo.UsrUserInfoVO;

/**
 *  <b>사용자 - 사용자의 로그인 관리</b> 영역  Service 클래스
 * @author Jamfam
 *
 */
@Service("usrLoginService")
public class UsrLoginServiceImpl extends EgovAbstractServiceImpl implements UsrLoginService {

    @Resource(name="usrLoginDAO")
    private UsrLoginDAO 			usrLoginDAO;
    
    @Resource(name="usrUserInfoChgHstyDAO")
    private UsrUserInfoChgHstyDAO 	usrUserInfoChgHstyDAO;
    
    @Resource(name="usrUserInfoDAO")
    private UsrUserInfoDAO usrUserInfoDAO;
    
	/**
	 * 사용자 아이디 중복 체크
	 * @param UsrLoginVO
	 * @return  ProcessResultDTO
	 */
	@Override
	public String userIdCheck(UsrLoginVO vo) throws Exception {
		return (String)usrLoginDAO.selectIdCheck(vo);
	}
	
	/**
	 * SSO 사용자 아이디 중복 체크
	 * @param UsrLoginVO
	 * @return  ProcessResultDTO
	 */
	@Override
	public String ssoUserIdCheck(UsrUserInfoVO vo) throws Exception {
		return (String)usrLoginDAO.selectSsoIdCheck(vo);
	}

	/**
	 * 사용자의 로그인 정보 조회
	 * @param UsrLoginVO vo
	 * @return  ProcessResultDTO
	 */
	@Override
	public UsrLoginVO select(UsrLoginVO vo) throws Exception {
		return usrLoginDAO.select(vo);
	}
	/**
	 * 사용자 로그인 등록
	 * @param UsrLoginVO vo
	 * @return  String
	 */
	@Override
	public void add(UsrLoginVO vo) throws Exception {
	    usrLoginDAO.insert(vo);
	}

	/**
	 * 사용자 로그인 수정
	 * @param UsrLoginVO vo
	 * @return  int
	 */
	@Override
	public int edit(UsrLoginVO vo) throws Exception {
		return usrLoginDAO.update(vo);
	}

	/**
	 * 사용자 로그인 삭제
	 * @param UsrLoginVO vo
	 * @return int
	 */
	@Override
	public int remove(UsrLoginVO vo) throws Exception {
		return usrLoginDAO.delete(vo);
	}

	/**
	 * 사용자의 마지막 접속 정보 수정
	 * - 접속횟수 및 마지막 접속일자 수정
	 * - 접속실패에 대한 정보 초기화
	 * @param UsrLoginVO vo
	 * @return  int
	 */
	@Override
	public int editLastLogin(UsrLoginVO vo) throws Exception {
		return usrLoginDAO.updateLoginCount(vo);
	}

	/**
	 * 사용자의 로그인 실패에 대한 기록
	 * - 접속실패에 대한 정보 수정
	 * @param UsrLoginVO vo
	 * @return  ProcessResultDTO
	 */
	@Override
	public UsrLoginVO editFailLogin(UsrLoginVO vo) throws Exception {
	    usrLoginDAO.updateFailInfo(vo);
		return usrLoginDAO.select(vo);
	}

	/**
	 * 사용자의 암호를 변경한다.
	 * @param UsrLoginVO vo
	 * @return  int
	 */
	@Override
	public void editPass(UsrLoginVO vo) throws Exception {
		vo.setUserIdEncpswd(CryptoUtil.encryptSha(vo.getUserIdEncpswd()));
		usrLoginDAO.updatePassword(vo);
	}
	
	/**
	 * 사용자의 암호를 변경한다.
	 * @param UsrLoginVO vo
	 * @return  int
	 */
	@Override
	public void editTmpPass(UsrLoginVO vo) throws Exception {
	    if(!"".equals(StringUtil.nvl(vo.getTmpPswd()))) {
	        vo.setTmpPswd(CryptoUtil.encryptSha(vo.getTmpPswd()));
	    }
	    usrLoginDAO.updateTmpPassword(vo);
	}

	/**
	 * 사용자의 사용상태를 변경한다.
	 * @param UsrLoginVO vo
	 * @return  int
	 */
	@Override
	public int editUserSts(UsrLoginVO vo, String userInfoChgDivCd) throws Exception {

		UsrUserInfoChgHstyVO uuichv = new UsrUserInfoChgHstyVO();
		uuichv.setUserId(vo.getUserId());
		uuichv.setRgtrId(vo.getRgtrId());
		uuichv.setUserInfoChgDivCd(userInfoChgDivCd); //-- 관리자 수정
		uuichv.setUserInfoCts(JsonUtil.getJsonString(vo));
		usrUserInfoChgHstyDAO.insert(uuichv);

		return usrLoginDAO.updateStatus(vo);
	}
	
	/**
	 * 사용자의 사용상태를 변경한다.
	 * @param UsrLoginVO vo
	 * @return  int
	 */
	@Override
	public void WithdrawalUser(UsrLoginVO vo) throws Exception {
		
		UsrUserInfoChgHstyVO uuichv = new UsrUserInfoChgHstyVO();
		uuichv.setUserId(vo.getUserId());
		uuichv.setRgtrId(vo.getMdfrId());
		uuichv.setUserInfoChgDivCd("AW"); //-- 관리자 수정
		uuichv.setUserInfoCts(JsonUtil.getJsonString(vo));
		usrUserInfoChgHstyDAO.insert(uuichv);
		
		usrLoginDAO.updateWithdrawal(vo);
		
		// 학적상태 수정
		UsrUserInfoVO usrUserInfoVO = new UsrUserInfoVO();
		usrUserInfoVO.setUserId(vo.getUserId());
		usrUserInfoDAO.updateWithdrawalStd(usrUserInfoVO);
		
	}

	/**
	 * 사용자의 비밀번호의 암호화 처리
	 * @param UsrLoginVO vo
	 * @return  ProcessResultDTO
	 */
	@Override
	public void editEncriptPass(UsrLoginVO vo) throws Exception {
		if(ValidationUtils.isNotEmpty(vo.getUserIdEncpswd()))
			vo.setUserIdEncpswd(
//					KISASeed.seed256HashEncryption(vo.getUserPass())
					vo.getUserIdEncpswd()
					);
		usrLoginDAO.updatePassword(vo);
	}


	/**
	 * 사용자의 비밀번호 변경일자 연장 처리
	 * @param UsrLoginVO vo
	 * @return  ProcessResultDTO
	 */
	@Override
	public int editPassChgDate(UsrLoginVO vo) throws Exception {
		return usrLoginDAO.updatePassDate(vo);
	}
	
	/**
	 * 사용자 아이디 중복 체크
	 * @param UsrLoginVO
	 * @return  ProcessResultDTO
	 */
	@Override
	public String snsDivCheck(UsrLoginVO vo) throws Exception {
		return (String)usrLoginDAO.selectIdCheck(vo);
	}

    @Override
    public String getNewPass() {
        return StringUtil.generateKeyString(8).toLowerCase();
    }
    
    
    /**
     * 사용자 세션ID 조회
     * @param UsrLoginVO vo
     * @return  String
     */
    @Override
    public UsrLoginVO selectSessionId(UsrLoginVO vo) throws Exception {
    	// Redis에서 조회
        if (CommConst.REDIS_USE && !"".equals(StringUtil.nvl(vo.getUserId())) 
        		&& RedisUtil.exists("UserSession:"+vo.getUserId())) {
        	vo.setSessionId(RedisUtil.getValue("UserSession:"+vo.getUserId()));
        }
        else {
        	vo = usrLoginDAO.selectSessionId(vo);
        	
        	// Redis에 값 저장
            if (CommConst.REDIS_USE && !"".equals(StringUtil.nvl(vo.getUserId()))) {
            	RedisUtil.setValue("UserSession:"+vo.getUserId(), vo.getSessionId(), (24 * 60 * 60));
            }
        }
        
        return vo;
    }
    
    /**
     * 사용자 세션ID 저장
     * @param UsrLoginVO vo
     * @return  String
     */
    @Override
    public void insertSessionId(UsrLoginVO vo) throws Exception {
        if (vo.getUserId() != null && vo.getSessionId() != null) {
        	UsrLoginVO usrLoginVO = usrLoginDAO.selectSessionId(vo);
        	if (usrLoginVO == null) {
        		usrLoginDAO.insertSessionId(vo);
        	}
        	else {
        		usrLoginDAO.updateSessionId(vo);
        	}
        	
        	// Redis에 값 저장
            if (CommConst.REDIS_USE) {
            	RedisUtil.setValue("UserSession:"+vo.getUserId(), vo.getSessionId(), (24 * 60 * 60));
            }
        }
    }
}
