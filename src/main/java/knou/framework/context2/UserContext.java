package knou.framework.context2;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.user.vo.UserVO;

public class UserContext {
	
	// 초기 UserContext와의 호환을 위해 유지 2026.04.02 by jinkoon
	public UserContext(String orgId, String userId, String authrtCd
			, String authrtGrpcd, String userRprsId, String userLastLogin) {
		this.orgId = orgId;
		this.userId = userId;
		this.authrtCd = authrtCd;
		this.authrtGrpcd = authrtGrpcd;
		this.userRprsId = userRprsId;
		this.userLastLogin = userLastLogin;
	}
	// 초기 UserContext와의 호환을 위해 유지 2026.04.02 by jinkoon
	public UserContext(String orgId, String userId, String userTycd, String authrtCd
			, String authrtGrpcd, String userRprsId, String userLastLogin) {
		this.orgId = orgId;
		this.userId = userId;
		setUserTycd(userTycd);
		this.authrtCd = authrtCd;
		this.authrtGrpcd = authrtGrpcd;
		this.userRprsId = userRprsId;
		this.userLastLogin = userLastLogin;
	}
	
	public UserContext() {}

	public UserContext(UserVO user) {
		this.loginUser = user;
	}	
	
	public UserVO getLoginUser() {
		return loginUser;
	}
	public void setLoginUser(UserVO loginUser) {
		this.loginUser = loginUser;
	}

	public UserVO getSelectedUser() {
		return selectedUser;
	}
	public void setSelectedUser(UserVO selectedUser) {
		this.selectedUser = selectedUser;
	}

	UserVO 	loginUser;
	UserVO	selectedUser;
	
	Map<String, UserVO> registeredUsers;
	
	List<EgovMap> userOrgIdsFromSubject;
	
	String 	orgId;
	String	userRprsId;
	String 	userId;
	String	userTycd;	
	String	authrtCd;
	String	authrtGrpcd;
	String	userLastLogin;
	String	userDevice;
	String	IP;
	String	lastLoginDttm;	
	String	date;
	String	langCd;
	String	cntnMenuPosition;
	String	preCntnMenuPosition;
	String	preCntnDttm;
	String	preCntnCheckNumber;
	String	deptId;
	
	boolean	professor = false;
	boolean	student = false;
	boolean	admin = false; 
	
	public boolean isProfessor() {
		return professor;
	}
	public void setProfessor(boolean professor) {
		this.professor = professor;
	}
	public boolean isStudent() {
		return student;
	}
	public void setStudent(boolean student) {
		this.student = student;
	}
	public boolean isAdmin() {
		return admin;
	}
	public void setAdmin(boolean admin) {
		this.admin = admin;
	}
	public void setUserTycd(String userTycd) {
		this.userTycd = userTycd;
		if ( "STDNT".equals(userTycd)) {
			setStudent(true);
		}		
		if ( "PROF".equals(userTycd)) {
			setProfessor(true);
		}		
		if ( "ADMIN".equals(userTycd)) {
			setAdmin(true);
		}
	}
	public String getUserLastLogin() {
		return this.userLastLogin;
	}

	public String getUserId() {
		return this.userId;
	}

	public String getOrgId() {
		return orgId;
	}

	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}

	public String getUserRprsId() {
		return userRprsId;
	}

	public void setUserRprsId(String userRprsId) {
		this.userRprsId = userRprsId;
	}

	public String getAuthrtCd() {
		return authrtCd;
	}

	public void setAuthrtCd(String authrtCd) {
		this.authrtCd = authrtCd;
	}

	public String getAuthrtGrpcd() {
		return authrtGrpcd;
	}

	public void setAuthrtGrpcd(String authrtGrpcd) {
		this.authrtGrpcd = authrtGrpcd;
	}

	public String getUserDevice() {
		return userDevice;
	}

	public void setUserDevice(String userDevice) {
		this.userDevice = userDevice;
	}

	public String getIP() {
		return IP;
	}

	public void setIP(String iP) {
		IP = iP;
	}

	public String getLastLoginDttm() {
		return lastLoginDttm;
	}

	public void setLastLoginDttm(String lastLoginDttm) {
		this.lastLoginDttm = lastLoginDttm;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String getLangCd() {
		return langCd;
	}

	public void setLangCd(String langCd) {
		this.langCd = langCd;
	}

	public String getCntnMenuPosition() {
		return cntnMenuPosition;
	}

	public void setCntnMenuPosition(String cntnMenuPosition) {
		this.cntnMenuPosition = cntnMenuPosition;
	}

	public String getPreCntnMenuPosition() {
		return preCntnMenuPosition;
	}

	public void setPreCntnMenuPosition(String preCntnMenuPosition) {
		this.preCntnMenuPosition = preCntnMenuPosition;
	}

	public String getPreCntnDttm() {
		return preCntnDttm;
	}

	public void setPreCntnDttm(String preCntnDttm) {
		this.preCntnDttm = preCntnDttm;
	}

	public String getPreCntnCheckNumber() {
		return preCntnCheckNumber;
	}

	public void setPreCntnCheckNumber(String preCntnCheckNumber) {
		this.preCntnCheckNumber = preCntnCheckNumber;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public void setUserLastLogin(String userLastLogin) {
		this.userLastLogin = userLastLogin;
	}
	public String getUserTycd() {
		return this.userTycd;
	}	
	public List<EgovMap> getUserOrgIdsFromSubject() {
		return userOrgIdsFromSubject;
	}
	public void setUserOrgIdsFromSubject(List<EgovMap> userOrgIdsFromSubject) {
		this.userOrgIdsFromSubject = userOrgIdsFromSubject;
	}
	public void setDeptId(String deptId) {
		this.deptId = deptId;
	}
	public String getDeptId() {		
		return this.deptId;
	}	
	public Map<String, UserVO> getRegisteredUsers() {
		return registeredUsers;
	}	
	
	public void setRegisteredUsers(Map<String, UserVO> users) {
		this.registeredUsers = users;
	}
}