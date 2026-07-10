package knou.lms.login.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.login.vo.LoginVO;
import knou.lms.login.vo.UserLgnHstryVO;

@Mapper("loginDAO")
public interface LoginDAO {

	@Deprecated
    public 	List<LoginVO> selectOrgList() throws Exception;

    public  EgovMap userLatestLoginHstrySelect(String userId) throws Exception;

	public int userLatestLoginHstryInsert(UserLgnHstryVO userLgnHstryVO) throws Exception;

	/**
     * 1차: EP 사용자 조회.
     * TB_EPO_USER 와 TB_EPO_USER_TP 를 조인하여 대표아이디/통합번호/사용자유형을 가져온다.
     * @param param userId(필수), userIdEncpswd, orgId 등을 담은 조회 파라미터
     * @return 일치 사용자 또는 null
     */
	public LoginVO selectEpUser(LoginVO param);

    /**
     * 2차: LMS 사용자 조회.
     * EP 에 데이터가 없을 때 TB_LMS_USER 에서 조회한다.
     * @param param userId(필수), userIdEncpswd, orgId 등
     * @return 일치 사용자 또는 null
     */
	public LoginVO selectLmsUser(LoginVO param);
}
