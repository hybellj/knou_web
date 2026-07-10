package knou.framework.taglib;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import knou.framework.common.MenuInfo;
import knou.framework.common.ParamInfo;
import knou.framework.common.SessionInfo;
import knou.framework.common.SubjectInfo;
import knou.framework.context2.UserContext;
import knou.framework.util.LocaleUtil;
import knou.framework.util.MaskUtil;
import knou.lms.menu.vo.MenuVO;

/**
 * 공통 함수 태그
 */
public class CommFunctionTag {
	private CommFunctionTag() {
		throw new IllegalStateException("CommFunctionTag class");
	}


	/**
	 * 암호화 파라메터값 가져오기
	 * @param name
	 * @return String
	 */
	public static String getParamValue(String name) {
		ServletRequestAttributes sra = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
	    HttpServletRequest request = sra.getRequest();

	    return ParamInfo.getParamValue(request, name);
	}

	/**
	 * 사용자 이름 마스킹
	 * @param userNm
	 * @return String
	 */
	public static String maskUserNm(String userNm) {
		return MaskUtil.maskUserNm(userNm);
	}

	/** 전화번호 마스킹
	 * @param phoneNo
	 * @return String
	 */
	public static String maskPhoneNo(String phoneNo) {
		return MaskUtil.maskPhoneNo(phoneNo);
	}

	/** 이메일 마스킹
	 * @param email
	 * @return String
	 */
	public static String maskEmail(String email) {
		return MaskUtil.maskEmail(email);
	}

	/** 주소 마스킹
	 * @param address
	 * @return String
	 */
	public static String maskAddress(String address) {
		return MaskUtil.maskAddress(address);
	}

	/** 주민번호 마스킹
	 * @param juminNo
	 * @return String
	 */
	public static String maskJuminNo(String juminNo) {
		return MaskUtil.maskJuminNo(juminNo);
	}

	/** IP Address 마스킹
	 * @param ipAddress
	 * @return String
	 */
	public static String maskIpAddress(String ipAddress) {
		return MaskUtil.maskIpAddress(ipAddress);
	}

	/**
	 * 사용자아이디 마스킹
	 * @param userId
	 * @return String
	 */
	public static String maskUserId(String userId) {
		return MaskUtil.maskUserId(userId);
	}

	/**
	 * 강의실 과목명 가져오기
	 * @return String
	 */
	public static String getClassSbjctnm() {
		ServletRequestAttributes sra = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
	    HttpServletRequest request = sra.getRequest();
	    String sbjctId = ParamInfo.getParamValue(request, "sbjctId");

	    return SubjectInfo.getSbjctnm(request, sbjctId);
	}

	/**
	 * 강의실 기관명 가져오기
	 * @return String
	 */
	public static String getClassOrgnm() {
		ServletRequestAttributes sra = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
	    HttpServletRequest request = sra.getRequest();
	    String sbjctId = ParamInfo.getParamValue(request, "sbjctId");

	    return SubjectInfo.getOrgnm(request, sbjctId);
	}

	/**
	 * 과목 권한 가져오기
	 * @return String
	 */
	public static String getSubjectAuth() {
		ServletRequestAttributes sra = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
	    HttpServletRequest request = sra.getRequest();
	    String sbjctId = ParamInfo.getParamValue(request, "sbjctId");

	    return SubjectInfo.getSubjectAuth(request, sbjctId);
	}

	/**
	 * 현재 메뉴명 가져오기
	 * @return menunm
	 */
	public static String getCurMenunm() throws Exception {
		ServletRequestAttributes sra = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
	    HttpServletRequest request = sra.getRequest();
	    String menuId = ParamInfo.getParamValue(request, "menuId");
	    String menunm = "";

		MenuVO menuVO = MenuInfo.getMenuVO(menuId);
		if (menuVO != null) {
			menunm = menuVO.getMenunm();
		}

	    return menunm;
	}

	/**
	 * 디자인 테마 가져오기
	 * @return
	 * @throws Exception
	 */
	public static String getTheme() throws Exception {
		ServletRequestAttributes sra = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
	    HttpServletRequest request = sra.getRequest();
	    String themeName = "";

	    UserContext userCtx = SessionInfo.getUserContext(request);
	    if (userCtx != null) {
	    	themeName = userCtx.getUserEnvStngVal("theme");
	    }

	    return themeName;
	}

	/**
	 * 언어 가져오기
	 * @return
	 * @throws Exception
	 */
	public static String getLangCd() throws Exception {
		ServletRequestAttributes sra = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
	    HttpServletRequest request = sra.getRequest();

	    return LocaleUtil.getLangCd(request);
	}

	/**
	 * 사용자 사진 출력
	 * @return
	 * @throws Exception
	 */
	public static String userPhoto() throws Exception {
		ServletRequestAttributes sra = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
	    HttpServletRequest request = sra.getRequest();
	    String photoImg = "";

	    UserContext userCtx = SessionInfo.getUserContext(request);
	    if (userCtx != null) {
	    	String photo = userCtx.getUserPhoto();
	    	if (photo != null && !"".equals(photo)) {
	    		//TODO 사진 경로 등 확인 필요
	    		photoImg = "<img src='"+photo+"' aria-hidden='true' alt='Photo'>";
	    	}
	    }

	    return photoImg;
	}
}
