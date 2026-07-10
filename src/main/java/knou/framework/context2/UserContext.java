package knou.framework.context2;

import java.util.ArrayList;
import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import knou.framework.common.CommConst;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.subject.vo.SubjectOrgDTO;
import knou.lms.user.param.UserMetaParam;
import knou.lms.user.vo.UserVO;

public class UserContext {

	public UserContext() {}

	public UserContext(UserVO user) {
		this.loginUser = user;
	}
	public UserVO getLoginUser() {
		return loginUser;
	}
	public void setLoginUser(UserVO loginUser) {
		this.loginUser = loginUser;
		initDefaultUser(loginUser);
	}

	UserVO 	loginUser;

	UserMetaParam loginUserMeta;

	//Map<String, UserVO> registeredUsers;

	List<EgovMap> userOrgIdsFromSubject;

	List<SubjectOrgDTO> subjectOrgList; // 사용자의 과목 기관 목록
	List<SmstrChrtVO> smstrChrtList;	// 사용자의 학기/기수 목록

	List<String> profIds;
	List<String> stdntIds;

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
	String	lastLoginIp;
	String	date;
	String	langCd;
	String	cntnMenuPosition;
	String	preCntnMenuPosition;
	String	preCntnDttm;
	String	preCntnCheckNumber;
	String	deptId;
	String	userPhoto;

	boolean	professor = false;
	boolean	student = false;
	boolean	admin = false;
	boolean tutor = false;

	public List<String> getProfIds() {
		return profIds;
	}

	public void setProfIds(List<String> profIds) {
		this.profIds = profIds;
	}

	public List<String> getStdntIds() {
		return stdntIds;
	}

	public void setStdntIds(List<String> stdntIds) {
		this.stdntIds = stdntIds;
	}

	public UserMetaParam getLoginUserMeta() {
		return loginUserMeta;
	}

	public void setLoginUserMeta(UserMetaParam loginUserMeta) {
		this.loginUserMeta = loginUserMeta;
	}

	public boolean isTutor() {
		return tutor;
	}

	public void setTutor(boolean tutor) {
		this.tutor = tutor;
	}

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

	    // 초기화
	    this.student = false;
	    this.professor = false;
	    this.admin = false;

	    if (userTycd == null) return;

	    switch (userTycd) {
	        case CommConst.AUTHRT_GRPCD_STDNT:
	            this.student = true;
	            break;
	        case CommConst.AUTHRT_GRPCD_PROF:
	            this.professor = true;
	            break;
	        case CommConst.AUTHRT_GRPCD_ADM:
	            this.admin = true;
	            break;
	        default:
	            // 정의되지 않은 타입일 경우 별도 처리 가능
	            break;
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

	@Deprecated
	public void setAuthrtCd(String authrtCd) { this.authrtCd = authrtCd; }

	public String getAuthrtGrpcd() {
		return authrtGrpcd;
	}

	@Deprecated
	public void setAuthrtGrpcd(String authrtGrpcd) { this.authrtGrpcd = authrtGrpcd; }

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

	public void initDefaultUser(UserVO userVO) {
		this.orgId = userVO.getOrgId();
		this.userId = userVO.getUserId();
		this.setUserTycd(userVO.getUserTycd());
		this.authrtCd = userVO.getAuthrtCd();
		this.authrtGrpcd = userVO.getAuthrtGrpcd();
	}

	/**
	 * 사용자 환경설정값 가져오기
	 * @param name
	 * @return
	 */
	public String getUserEnvStngVal(String name) {
		String val = "";

		try {
			if (this.getLoginUser() != null) {
				String userEnvStngCts = this.getLoginUser().getUserEnvStngCts();
				if (userEnvStngCts != null && !"".equals(userEnvStngCts)) {
					JSONParser parser = new JSONParser();
					JSONObject jsonObject = (JSONObject) parser.parse(userEnvStngCts);

					if (jsonObject.containsKey(name)) {
						val = (String) jsonObject.get(name);
					}
				}
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}

		return val;
	}

	/**
	 * 사용자 환경설정값 세팅
	 * @param name
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public void setUserEnvStngVal(String name, String value) {

		try {
			if (this.getLoginUser() != null) {
				String userEnvStngCts = this.getLoginUser().getUserEnvStngCts();
				if (userEnvStngCts != null && !"".equals(userEnvStngCts)) {
					userEnvStngCts = "{}";
				}

				JSONParser parser = new JSONParser();
				JSONObject jsonObject = (JSONObject) parser.parse(userEnvStngCts);
				jsonObject.put(name, value);
				this.getLoginUser().setUserEnvStngCts(jsonObject.toJSONString());

			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
	}

	public String getLastLoginIp() {
		return lastLoginIp;
	}

	public void setLastLoginIp(String lastLoginIp) {
		this.lastLoginIp = lastLoginIp;
	}

	public String getUserPhoto() {
		return userPhoto;
	}

	public void setUserPhoto(String userPhoto) {
		this.userPhoto = userPhoto;
	}

	public List<SubjectOrgDTO> getSubjectOrgList() {
		return subjectOrgList;
	}

	public void setSubjectOrgList(List<SubjectOrgDTO> subjectOrgList) {
		this.subjectOrgList = subjectOrgList;
	}

	public List<SmstrChrtVO> getSmstrChrtList() {
		return smstrChrtList;
	}

	public List<SmstrChrtVO> getSmstrChrtList(String orgId, String userTycd) {
		List<SmstrChrtVO> list = new ArrayList<>();

		if (!"STDNT".equals(userTycd)) {
			userTycd = "PROF";
		}

		if (smstrChrtList != null && !smstrChrtList.isEmpty() && orgId != null && !orgId.isEmpty() && !"ALL".equals(orgId)) {
			for (SmstrChrtVO vo : smstrChrtList) {
				if (orgId.equals(vo.getOrgId()) && vo.getUserTycd().equals(userTycd)) {
					list.add(vo);
				}
			}
		}
		else {
			for (SmstrChrtVO vo : smstrChrtList) {
				if ("ALL".equals(vo.getSmstrChrtnm()) || vo.getUserTycd().equals(userTycd)) {
					list.add(vo);
				}
			}
		}

		return list;
	}

	public void setSmstrChrtList(List<SmstrChrtVO> smstrChrtList) {
		this.smstrChrtList = smstrChrtList;
	}
}