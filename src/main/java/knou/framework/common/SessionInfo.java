package knou.framework.common;

import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.Stack;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import knou.framework.util.LocaleUtil;
import knou.framework.util.SessionUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.user.vo.UsrUserInfoVO;

/**
 * 세션 정보
 */
public class SessionInfo {

    private SessionInfo() {
        throw new IllegalStateException(getClass().getName());
    }

    /**
     * 사용자 구분 삭제
     *
     * @param request
     * @param value
     */
    public static final void removeLoginGbn(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.LOGIN_GNB);
    }

    /**
     * 사용자 구분 가져오기
     *
     * @param request
     * @return
     */
    public static String getLoginGbn(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.LOGIN_GNB);
    }

    /**
     * 사용자 구분 Set
     *
     * @param request
     * @param value
     */
    public static final void setLoginGbn(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_GNB, value);
    }

    /**
     * 사용자 대표 ID 가져오기
     *
     * @param request
     * @return
     */
    public static String getUserRprsId(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.LOGIN_USERRPRSID);
    }

    /**
     * UserPrfilId Set
     *
     * @param request
     * @param value
     */
    public static final void setUserRprsId(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_USERRPRSID, value);
    }

    /**
     * 사용자NO 가져오기
     *
     * @param request
     * @return
     */
    public static String getUserId(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.LOGIN_USERID);
    }

    /**
     * 사용자 번호 Set
     *
     * @param request
     * @param value
     */
    public static final void setUserId(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_USERID, value);
    }

    /**
     * 사용자명 가져오기
     *
     * @param request
     * @return
     */
    public static String getUserNm(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.LOGIN_USERNAME);
    }

    /**
     * 사용자 이름 Set
     *
     * @param request
     * @param value
     */
    public static final void setUserNm(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_USERNAME, value);
    }

    /**
     * 관리자타입 가져오기
     *
     * @param request
     * @return
     */
    public static String getMngType(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.LOGIN_MNGTYPE);
    }

    /**
     * 사이트 관리자 타입 Set
     *
     * @param request
     * @param value
     */
    public static final void setMngType(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_MNGTYPE, value);
    }

    /**
     * 파일함 사용 권한 여부를 가져온다 .
     *
     * @param request return
     */
    public static String getFileBoxUseAuthYn(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.LOGIN_MNGTYPE);
    }

    /**
     * 파일함 사용 권한 여부 Set
     *
     * @param request
     * @param value
     */
    public static final void setFileBoxUseAuthYn(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_FILEBOXUSEAUTHYN, value);
    }

    /**
     * 사용자 타입을 가져온다.
     *
     * @param request
     */
    public static String getAuthrtCd(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.LOGIN_AUTHRTCD);
    }

    /**
     * 사용자 타입 Set
     *
     * @param request
     * @param value
     */
    public static final void setAuthrtCd(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_AUTHRTCD, value);
    }

    /**
     * 사용자 타입을 가져온다.
     *
     * @param request
     */
    public static String getLoginIp(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.LOGIN_IP_ADDR);
    }

    /**
     * 사용자 로그인 IP 값 Set
     *
     * @param request
     * @param value
     */
    public static final void setLoginIp(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_IP_ADDR, value);
    }

    /**
     * ***************************************************
     * 현재학기 설정
     *
     * @param request
     * @param termCd  ****************************************************
     */
    public static void setCurTerm(HttpServletRequest request, String termCd) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_CUR_TERM, termCd);
    }

    /**
     * **************************************************
     * 현재 학기 가져오기
     *
     * @param request
     * @return ****************************************************
     */
    public static String getCurTerm(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.LOGIN_CUR_TERM);
    }

    /**
     * ***************************************************
     * 현재학기 설정(목록)
     *
     * @param request
     * @param termCd  ****************************************************
     */
    public static void setCurTermList(HttpServletRequest request, String[] termCds) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_CUR_TERM_LIST, termCds);
    }

    /**
     * **************************************************
     * 현재 학기 가져오기 (목록)
     *
     * @param request
     * @return ****************************************************
     */
    public static String[] getCurTermList(HttpServletRequest request) {
        return (String[]) SessionUtil.getSessionValue(request, CommConst.LOGIN_CUR_TERM_LIST);
    }

    /**
     * 세션의 메뉴코드를 가져온다.
     *
     * @param request
     * @return
     */
    public static final String getMenuCode(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.CUR_MENU_CODE);
    }

    /**
     * 세션의 메뉴코드 Set
     *
     * @param request
     * @param value
     */
    public static final void setMenuCode(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.CUR_MENU_CODE, value);
    }

    /**
     * 세션의 권한코드를 가져온다.
     *
     * @param request
     * @return
     */
    public static final String getAuthrtGrpcd(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.CUR_AUTHRT_CD);
    }

    /**
     * 세션에 권한코드 Set
     * : 로그인 시 권한 세팅
     * ex) ADM / PROF / COPROF /STDNT
     *
     * @param request
     * @param value
     */
    public static final void setAuthrtGrpcd(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.CUR_AUTHRT_CD, value);
    }

    /**
     * 세션의 최상위 메뉴코드를 가져온다.
     *
     * @param request
     * @return
     */
    public static final String getRotMenuCode(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.ROT_MENU_CODE);
    }

    /**
     * 세션의 최상위 메뉴코드 Set
     *
     * @param request
     * @param value
     */
    public static final void setRotMenuCode(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.ROT_MENU_CODE, value);
    }

    /**
     * 세션의 메뉴명을 가져온다.
     *
     * @param request
     * @return
     */
    public static final String getMenuName(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.CUR_MENU_NAME);
    }

    /**
     * 세션의 메뉴명 Set
     *
     * @param request
     * @param value
     */
    public static final void setMenuName(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.CUR_MENU_NAME, value);
    }

    /**
     * 세션의 메뉴명을 가져온다.
     *
     * @param request
     * @return
     */
    public static final String getMenuLocation(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.MENU_LOCATION);
    }

    /**
     * 세션의 메뉴명 Set
     *
     * @param request
     * @param value
     */
    public static final void setMenuLocation(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.MENU_LOCATION, value);
    }

    /**
     * 세션의 메뉴타이틀을 가져온다.
     *
     * @param request
     * @return
     */
    public static final String getMenuTitle(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.CUR_MENU_TITLE);
    }

    /**
     * 세션의 메뉴타이틀 Set
     *
     * @param request
     * @param value
     */
    public static final void setMenuTitle(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.CUR_MENU_TITLE, value);
    }

    /**
     * 세션의 메뉴타이틀을 가져온다.
     *
     * @param request
     * @return
     */
    public static final String getMenuChrgDept(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.CUR_MENU_CHRG_DEPT);
    }

    /**
     * 세션의 메뉴타이틀 Set
     *
     * @param request
     * @param value
     */
    public static final void setMenuChrgDept(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.CUR_MENU_CHRG_DEPT, value);
    }

    /**
     * 세션의 메뉴타이틀을 가져온다.
     *
     * @param request
     * @return
     */
    public static final String getMenuChrgName(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.CUR_MENU_CHRG_NAME);
    }

    /**
     * 세션의 메뉴타이틀 Set
     *
     * @param request
     * @param value
     */
    public static final void setMenuChrgName(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.CUR_MENU_CHRG_NAME, value);
    }

    /**
     * 세션의 메뉴타이틀을 가져온다.
     *
     * @param request
     * @return
     */
    public static final String getMenuChrgPhone(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.CUR_MENU_CHRG_PHONE);
    }

    /**
     * 세션의 메뉴타이틀 Set
     *
     * @param request
     * @param value
     */
    public static final void setMenuChrgPhone(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.CUR_MENU_CHRG_PHONE, value);
    }

    /**
     * 세션의 임시 메뉴코드를 가져온다.
     *
     * @param request
     * @return
     */
    public static final String getTempMenuCode(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.TEMP_CUR_MENU_CODE);
    }

    /**
     * 세션의 임시 메뉴코드 Set
     *
     * @param request
     * @param value
     */
    public static final void setTempMenuCode(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.TEMP_CUR_MENU_CODE, value);
    }

    /**
     * 세션의 임시 메뉴명을 가져온다.
     *
     * @param request
     * @return
     */
    public static final String getTempMenuName(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.TEMP_CUR_MENU_NAME);
    }

    /**
     * 세션의 임시 메뉴명 Set
     *
     * @param request
     * @param value
     */
    public static final void setTempMenuName(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.TEMP_CUR_MENU_NAME, value);
    }

    /**
     * 세션의 임시 메뉴 위치을 가져온다.
     *
     * @param request
     * @return
     */
    public static final String getTempMenuLocation(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.TEMP_MENU_LOCATION);
    }

    /**
     * 세션의 임시 메뉴위치 Set
     *
     * @param request
     * @param value
     */
    public static final void setTempMenuLocation(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.TEMP_MENU_LOCATION, value);
    }

    /**
     * 로그인 여부를 반환한다. (USERNO로 판단한다.)
     *
     * @param request
     * @return true : 로그인, false : 비로그인.
     */
    public static final boolean isLogin(HttpServletRequest request) {
        return StringUtil.isNotNull((String) SessionUtil.getSessionValue(request, CommConst.LOGIN_USERID));
    }

    /**
     * 언어키를 가져온다.
     *
     * @param request
     * @return
     */
    public static final String getLocaleKey(HttpServletRequest request) {
        Locale locale = LocaleUtil.getLocale(request);
        String localeKey = locale.getLanguage();
        if (ValidationUtils.isEmpty(localeKey)) localeKey = CommConst.LANG_DEFAULT;
        return localeKey;
    }

    /**
     * 세션의 강의실 권한 그룹 코드를 가져온다.
     *
     * @param request
     * @return
     */
    public static final String getClassUserType(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.LOGIN_CLASSUSERTYPE);
    }

    /**
     * 세션의 강의실 권한 그룹 코드 set.
     *
     * @param request
     * @param value
     * @return
     */
    public static final void setClassUserType(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_CLASSUSERTYPE, value);
    }

    /**
     * 개설 과정 명 가져온다.
     *
     * @param request
     * @return
     */
    public static final String getCrsCreNm(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.LOGIN_CRSCRENM);
    }

    /**
     * 개설 과정 코드를 가져온다.
     *
     * @param request
     * @return
     */
    public static final String getCrsCreCd(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.LOGIN_CRSCRECD);
    }

    /**
     * 개설 과정 코드 Set
     *
     * @param request
     * @return value
     */
    public static final void setCrsCreCd(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_CRSCRECD, value);
    }

    /**
     * 개설 과정 명 Set
     *
     * @param request
     * @return value
     */
    public static final void setCrsCreNm(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_CRSCRENM, value);
    }

    /**
     * 개설 과정 강의형식을 가져온다.
     *
     * @param request
     * @return
     */
    public static final String getProgressTypeCd(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.LOGIN_PROGESSTYPECD);
    }

    /**
     * 개설 과정 강의형식을 Set
     *
     * @param request
     * @return value
     */
    public static final void setProgressTypeCd(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_PROGESSTYPECD, value);
    }

    /**
     * 개설 과정 강의형식을 가져온다.
     *
     * @param request
     * @return
     */
    public static final String getCrsTypeCd(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.LOGIN_CRSTYPECD);
    }

    /**
     * 개설 과정 강의형식을 Set
     *
     * @param request
     * @return value
     */
    public static final void setCrsTypeCd(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_CRSTYPECD, value);
    }

    /**
     * 사용자의 수강 번호를 가져온다.
     *
     * @param request
     * @return
     */
    public static final String getStudentNo(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.LOGIN_STUDENTNO);
    }

    /**
     * 기관명 Set
     *
     * @param request
     * @param value
     */
    public static final void setOrgNm(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_ORGNM, value);
    }

    /**
     * 기관명을 반환한다
     *
     * @param request
     * @return
     */
    public static final String getOrgNm(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.LOGIN_ORGNM);
    }

    /**
     * 기관코드 Set
     *
     * @param request
     * @param value
     */
    public static final void setOrgId(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_ORGID, value);
    }

    /**
     * 기관코드을 반환한다
     *
     * @param request
     * @return
     */
    public static final String getOrgId(HttpServletRequest request) {
        return StringUtil.nvl((String) SessionUtil.getSessionValue(request, CommConst.LOGIN_ORGID));
    }

    /**
     * 기관 사이트 타입 코드 set
     *
     * @param request
     * @param value
     */
    public static final void setOrgTypeCd(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_ORGTYPECD, value);
    }

    /**
     * 기관 사이트 타입 코드를 반환한다
     *
     * @param request
     * @return
     */
    public static final String getOrgTypeCd(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.LOGIN_ORGTYPECD);
    }

    /**
     * 기본 언어키값 Set
     *
     * @param request
     * @param value
     */
    public static final void setSysLocalkey(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.SYSTEM_LOCALEKEY, value);
    }

    /**
     * 기본 언어키값을 반환한다
     *
     * @param request
     * @return
     */
    public static final String getSysLocalkey(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.SYSTEM_LOCALEKEY);
    }

    /**
     * 메뉴 세션 유지 유무 Set
     *
     * @param request
     * @param value
     */
    public static final void setMaintainMenuSession(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.MAINTAIN_MENU_SESSION, value);
    }

    /**
     * 메뉴 세션 유지 유무 값을 반환한다
     *
     * @param request
     * @return
     */
    public static final String getMaintainMenuSession(HttpServletRequest request) {
        return StringUtil.nvl((String) SessionUtil.getSessionValue(request, CommConst.MAINTAIN_MENU_SESSION), "NO");
    }

    /**
     * UserId Remove
     *
     * @param request
     * @param value
     */
    public static final void removeUserId(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.LOGIN_USERID);
    }

    /**
     * 관리자 타입 Remove
     *
     * @param request
     * @param value
     */
    public static final void removeAdmType(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.LOGIN_ADMTYPE);
    }

    /**
     * 사이트 관리자 타입 Remove
     *
     * @param request
     * @param value
     */
    public static final void removeMngType(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.LOGIN_MNGTYPE);
    }

    /**
     * 사용자 타입 Remove
     *
     * @param request
     * @param value
     */
    public static final void removeAuthrtCd(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.LOGIN_AUTHRTCD);
    }

    /**
     * 사용자 이름 Remove
     *
     * @param request
     * @param value
     */
    public static final void removeUserName(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.LOGIN_USERNAME);
    }

    /**
     * 세션의 메뉴코드 Remove
     *
     * @param request
     * @param value
     */
    public static final void removeMenuCode(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.CUR_MENU_CODE);
    }

    /**
     * 세션의 메뉴유형 Remove
     *
     * @param request
     * @param value
     */
    public static final void removeMenuType(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.CUR_AUTHRT_CD);
    }

    /**
     * 세션의 최상위 메뉴코드 Remove
     *
     * @param request
     * @param value
     */
    public static final void removeRotMenuCode(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.ROT_MENU_CODE);
    }

    /**
     * 세션의 메뉴명 Remove
     *
     * @param request
     * @param value
     */
    public static final void removeMenuName(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.CUR_MENU_NAME);
    }

    /**
     * 세션의 메뉴명 Remove
     *
     * @param request
     * @param value
     */
    public static final void removeMenuLocation(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.MENU_LOCATION);
    }

    /**
     * 세션의 메뉴타이틀 Remove
     *
     * @param request
     * @param value
     */
    public static final void removeMenuTitle(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.CUR_MENU_TITLE);
    }

    /**
     * 세션의 메뉴타이틀 Remove
     *
     * @param request
     * @param value
     */
    public static final void removeMenuChrgDept(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.CUR_MENU_CHRG_DEPT);
    }

    /**
     * 세션의 메뉴타이틀 Remove
     *
     * @param request
     * @param value
     */
    public static final void removeMenuChrgName(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.CUR_MENU_CHRG_NAME);
    }

    /**
     * 세션의 메뉴타이틀 Remove
     *
     * @param request
     * @param value
     */
    public static final void removeMenuChrgPhone(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.CUR_MENU_CHRG_PHONE);
    }

    /**
     * 세션의 임시 메뉴코드 Remove
     *
     * @param request
     * @param value
     */
    public static final void removeTempMenuCode(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.TEMP_CUR_MENU_CODE);
    }

    /**
     * 세션의 임시 메뉴명 Remove
     *
     * @param request
     * @param value
     */
    public static final void removeTempMenuName(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.TEMP_CUR_MENU_NAME);
    }

    /**
     * 세션의 임시 메뉴위치 Remove
     *
     * @param request
     * @param value
     */
    public static final void removeTempMenuLocation(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.TEMP_MENU_LOCATION);
    }

    /**
     * 개설 과정 코드 Remove
     *
     * @param request
     * @return value
     */
    public static final void removeCrsCreCd(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.LOGIN_CRSCRECD);
    }

    /**
     * 기관명 Remove
     *
     * @param request
     * @param value
     */
    public static final void removeOrgNm(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.LOGIN_ORGNM);
    }

    /**
     * 기관코드 Remove
     *
     * @param request
     * @param value
     */
    public static final void removeOrgId(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.LOGIN_ORGID);
    }

    /**
     * 기관 사이트 타입 코드 remove
     *
     * @param request
     * @param value
     */
    public static final void removeOrgTypeCd(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.LOGIN_ORGTYPECD);
    }

    /**
     * 기본 언어키값 Remove
     *
     * @param request
     * @param value
     */
    public static final void removeSysLocalkey(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.SYSTEM_LOCALEKEY);
    }

    /**
     * 메뉴 세션 유지 유무 Remove
     *
     * @param request
     * @param value
     */
    public static final void removeMaintainMenuSession(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.MAINTAIN_MENU_SESSION);
    }

    /**
     * 사용자 로그인 IP 값 Remove
     *
     * @param request
     * @param value
     */
    public static final void removeLoginIp(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.LOGIN_IP_ADDR);
    }

    /**
     * stdNo을 가져온다.
     *
     * @param request
     */
    public static final String getStdNo(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.LOGIN_STUDENTNO);
    }

    /**
     * stdNo Set
     *
     * @param request
     * @param value
     */
    public static final void setStdNo(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_STUDENTNO, value);
    }

    /**
     * 파일함 사용 권한 여부 값 Remove
     *
     * @param request
     * @param value
     */
    public static final void removeFileBoxUseAuthYn(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.LOGIN_FILEBOXUSEAUTHYN);
    }

    /**
     * 관리자권한 유무를 가져온다.
     *
     * @param request
     */
    public static final String getAdmYn(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.LOGIN_ADMYN);
    }

    /**
     * 관리자권한 유무를 Set
     *
     * @param request
     * @param value
     */
    public static final void setAdmYn(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_ADMYN, value);
    }

    /**
     * 관리자 타입을 가져온다.
     *
     * @param request
     */
    public static final String getAdmType(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.LOGIN_ADMTYPE);
    }

    /**
     * 관리자 타입 Set
     *
     * @param request
     * @param value
     */
    public static final void setAdmType(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_ADMTYPE, value);
    }

    /**
     * 탬플릿타입코드를 Set
     *
     * @param request
     * @param value
     */
    public static final void setTplTypeCd(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.TPL_TYPE_CD, value);
    }

    /**
     * 탬플릿타입코드를 반환한다
     *
     * @param request
     * @return
     */
    public static final String getTplTypeCd(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.TPL_TYPE_CD);
    }

    /**
     * 장애인여부 Set
     *
     * @param request
     * @param value
     */
    public static final void setDisablilityYn(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_DISABLILITYYN, value);
    }

    /**
     * 장애인여부 반환한다
     *
     * @param request
     * @return
     */
    public static final String getDisablilityYn(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.LOGIN_DISABLILITYYN);
    }

    /**
     * 장애인시험지원신청여부 Set
     *
     * @param request
     * @param value
     */
    public static final void setDisablilityExamYn(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_DISABLILITYEXAMYN, value);
    }

    /**
     * 장애인시험지원신청여부 반환한다
     *
     * @param request
     * @return
     */
    public static final String getDisablilityExamYn(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.LOGIN_DISABLILITYEXAMYN);
    }

    /**
     * 사용자 모드 전환시 원 사용자의 userId이 담겨있는 스택을 가져온다 .
     * (사용자 전환을 중첩으로 할수 있다는 가정. 예: A사용자 -> B사용자 -> C사용자)
     *
     * @param request
     */
    public static final Stack<Map<String, Object>> getModChgSrcUserStack(HttpServletRequest request) {
        Stack<Map<String, Object>> modChgUsrStack =
                (Stack<Map<String, Object>>) SessionUtil.getSessionValue(request, CommConst.LOGIN_MOD_CHG_STACK);

        return modChgUsrStack;
    }

    /**
     * 사용자 모드 전환시 원 사용자의 userId이 담겨있는 스택을 저장한다.
     * (사용자 전환을 중첩으로 할수 있다는 가정. 예: A사용자 -> B사용자 -> C사용자)
     *
     * @param request
     * @param value
     */
    public static final void setModChgSrcUserStack(HttpServletRequest request, Stack<Map<String, Object>> stack) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_MOD_CHG_STACK, stack);
    }

    /**
     * 사용자 모드 전환시 원 사용자의 userId이 담겨있는 스택 Remove
     *
     * @param request
     * @param value
     */
    public static final void removeModChgSrcUserStack(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.LOGIN_MOD_CHG_STACK);
    }

    /**
     * 현재 사용자홈 정보 저장
     *
     * @param request
     * @param value
     */
    public static final void setCurUserHome(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.CUR_USER_HOME, value);
    }

    /**
     * 현재 사용자홈 정보 반환
     *
     * @param request
     * @return
     */
    public static final String getCurUserHome(HttpServletRequest request) {
        String home = StringUtil.nvl((String) SessionUtil.getSessionValue(request, CommConst.CUR_USER_HOME));
        if ("".equals(home)) home = "/dashboard/main.do";

        return home;
    }

    /**
     * 현재 과목홈 정보 저장
     *
     * @param request
     * @param value
     */
    public static final void setCurCorHome(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.CUR_COR_HOME, value);
    }

    /**
     * 현재 과목홈 정보 반환
     *
     * @param request
     * @return
     */
    public static final String getCurCorHome(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.CUR_COR_HOME);
    }

    /**
     * ***************************************************
     * 현재 접속과목 설정
     *
     * @param request
     * @param termCd  ****************************************************
     */
    public static void setCurCrsCreCd(HttpServletRequest request, String termCd) {
        SessionUtil.setSessionValue(request, "CUR_CRS_CRE_CD", termCd);
    }

    /**
     * **************************************************
     * 현재 접속과목 가져오기
     *
     * @param request
     * @return ****************************************************
     */
    public static String getCurCrsCreCd(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, "CUR_CRS_CRE_CD");
    }

    private static final void setSessionValue(HttpServletRequest request, String key, String value) {

        HttpSession session = request.getSession();
        // session.setAttribute(key, value);
        session.getServletContext().getContext("/home").setAttribute(key + "-" + session.getId(), value);
    }

    /**
     * requestURI Set
     *
     * @param request
     * @param value
     */
    public static final void setRequestURI(HttpServletRequest request, String value) {
        setSessionValue(request, CommConst.URI, value);
    }

    /**
     * 기관명 Set
     *
     * @param request
     * @param value
     */
    public static final void setSaasOrgNm(HttpServletRequest request, String value) {
        setSessionValue(request, CommConst.SAAS_ORGNM, value);
    }

    /**
     * 기관아이디 Set
     *
     * @param request
     * @param value
     */
    public static final void setSaasOrgId(HttpServletRequest request, String value) {
        setSessionValue(request, CommConst.SAAS_ORGID, value);
    }

    /**
     * 기관 사이트 타입 코드 set
     *
     * @param request
     * @param value
     */
    public static final void setSaasOrgTypeCd(HttpServletRequest request, String value) {
        setSessionValue(request, CommConst.SAAS_ORGTYPECD, value);
    }

    /**
     * 탬플릿코드 Set
     *
     * @param request
     * @param value
     */
    public static final void setTplCd(HttpServletRequest request, String value) {
        setSessionValue(request, CommConst.TPL_CD, value);
    }

    public static final void removeSession(HttpServletRequest request, String key) {

        HttpSession session = request.getSession();
        // session.removeAttribute(key);
        session.getServletContext().getContext("/home").removeAttribute(key + "-" + session.getId());
    }


    /**
     * 과목세션정보 삭제
     *
     * @param request
     */
    public static final void removeCourseInfo(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, CommConst.LOGIN_CRSCRECD);
        SessionUtil.removeSessionValue(request, CommConst.CUR_COR_HOME);
        SessionUtil.removeSessionValue(request, "CUR_CRS_CRE_CD");
        SessionUtil.removeSessionValue(request, CommConst.LOGIN_CLASSUSERTYPE);
    }

    /**
     * ***************************************************
     * 수업계획서 URL 설정
     *
     * @param request
     * @param termCd  ****************************************************
     */
    public static void setLessonPlanUrl(HttpServletRequest request, String url) {
        SessionUtil.setSessionValue(request, "LESSON_PLAN_URL", url);
    }

    /**
     * **************************************************
     * 수업계획서 URL 가져오기
     *
     * @param request
     * @return ****************************************************
     */
    public static String getLessonPlanUrl(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, "LESSON_PLAN_URL");
    }

    /**
     * ***************************************************
     * 사용자 사진 설정
     *
     * @param request
     * @param termCd  ****************************************************
     */
    public static void setUserPhoto(HttpServletRequest request, String phtFile) {
        SessionUtil.setSessionValue(request, "USER_PHTOTO", phtFile);
    }

    /**
     * **************************************************
     * 사용자 사진  가져오기
     *
     * @param request
     * @return ****************************************************
     */
    public static String getUserPhoto(HttpServletRequest request) {
        return StringUtil.nvl((String) SessionUtil.getSessionValue(request, "USER_PHTOTO"));
    }

    /**
     * ***************************************************
     * 사용자 사진 삭제
     *
     * @param request ****************************************************
     */
    public static void removeUserPhoto(HttpServletRequest request) {
        SessionUtil.removeSessionValue(request, "USER_PHTOTO");
    }

    /**
     * ***************************************************
     * 테마모드 설정
     *
     * @param request
     * @param termCd  ****************************************************
     */
    public static void setThemeMode(HttpServletRequest request, String themeMode) {
        SessionUtil.setSessionValue(request, "THEME_MODE", themeMode);
    }

    /**
     * **************************************************
     * 테마모드  가져오기
     *
     * @param request
     * @return ****************************************************
     */
    public static String getThemeMode(HttpServletRequest request) {
        String themeMode = StringUtil.nvl((String) SessionUtil.getSessionValue(request, "THEME_MODE"));
        if ("".equals(themeMode)) {
            //themeMode = "dark";
            themeMode = "";
        }

        if (!isKnou(request)) { // 외부기관인 경우
            if ("".equals(themeMode)) {
                themeMode = "org-uni";
            } else {
                themeMode += " org-uni";
            }
        }

        return themeMode;
    }

    /**
     * ***************************************************
     * 과목 학과명 설정
     *
     * @param request
     * @param termCd  ****************************************************
     */
    public static void setCreDeptNm(HttpServletRequest request, String phtFile) {
        SessionUtil.setSessionValue(request, "CRE_DEPT_NM", phtFile);
    }

    /**
     * **************************************************
     * 과목 학과명  가져오기
     *
     * @param request
     * @return ****************************************************
     */
    public static String getCreDeptNm(HttpServletRequest request) {
        String themeMode = StringUtil.nvl((String) SessionUtil.getSessionValue(request, "CRE_DEPT_NM"));
        if ("".equals(themeMode)) {
            themeMode = "dark";
        }
        return themeMode;
    }

    /**
     * ***************************************************
     * 사용자 장치 설정
     *
     * @param request
     * @param device  ****************************************************
     */
    public static void setDeviceType(HttpServletRequest request) {
        String agent = request.getHeader("User-Agent");
        String deviceType = "pc";

        if (agent != null && CommConst.MOBILE_DEVICE != null) {
            for (int i = 0; i < CommConst.MOBILE_DEVICE.length; i++) {
                if (agent.indexOf(CommConst.MOBILE_DEVICE[i]) > -1) {
                    deviceType = "mobile";
                    break;
                }
            }
        }

        SessionUtil.setSessionValue(request, "DEVICE_TYPE", deviceType);
    }

    /**
     * **************************************************
     * 사용자 장치 가져오기
     *
     * @param request
     * @return ****************************************************
     */
    public static String getDeviceType(HttpServletRequest request) {
        String device = StringUtil.nvl((String) SessionUtil.getSessionValue(request, "DEVICE_TYPE"));
        if ("".equals(device)) {
            setDeviceType(request);
            device = StringUtil.nvl((String) SessionUtil.getSessionValue(request, "DEVICE_TYPE"));
        }
        return device;
    }

    /**
     * ***************************************************
     * 마지막 로그인 정보 설정
     *
     * @param request
     * @param termCd  ****************************************************
     */
    public static void setLastLogin(HttpServletRequest request, String loginInfo) {
        SessionUtil.setSessionValue(request, "LAST_LOGIN_INFO", loginInfo);
    }

    /**
     * **************************************************
     * 마지막 로그인 정보 가져오기
     *
     * @param request
     * @return ****************************************************
     */
    public static String getLastLogin(HttpServletRequest request) {
        return StringUtil.nvl((String) SessionUtil.getSessionValue(request, "LAST_LOGIN_INFO"));
    }

    /**
     * ***************************************************
     * 사용자 학부/대학원 구분 설정
     *
     * @param request
     * @param termCd  ****************************************************
     */
    public static void setUniCd(HttpServletRequest request, String uniCd) {
        SessionUtil.setSessionValue(request, "UNI_CD", uniCd);
    }

    /**
     * **************************************************
     * 사용자 학부/대학원 구분 가져오기
     *
     * @param request
     * @return ****************************************************
     */
    public static String getUniCd(HttpServletRequest request) {
        return StringUtil.nvl((String) SessionUtil.getSessionValue(request, "UNI_CD"));
    }

    /**
     * ***************************************************
     * 사용자 학부/대학원 구분 설정
     *
     * @param request
     * @param termCd  ****************************************************
     */
    public static void setUnivGbn(HttpServletRequest request, String uniCd) {
        SessionUtil.setSessionValue(request, "UNIV_GBN", uniCd);
    }

    /**
     * **************************************************
     * 사용자 학부/대학원 구분 가져오기
     *
     * @param request
     * @return ****************************************************
     */
    public static String getUnivGbn(HttpServletRequest request) {
        return StringUtil.nvl((String) SessionUtil.getSessionValue(request, "UNIV_GBN"));
    }

    /**
     * ***************************************************
     * 사용자상세구분 설정
     *
     * @param request
     * @param termCd  ****************************************************
     */
    public static void setUserTypeDetail(HttpServletRequest request, String uniCd) {
        SessionUtil.setSessionValue(request, "USER_TYPE_DETAIL", uniCd);
    }

    /**
     * **************************************************
     * 사용자상세구분 가져오기
     *
     * @param request
     * @return ****************************************************
     */
    public static String getUserTypeDetail(HttpServletRequest request) {
        return StringUtil.nvl((String) SessionUtil.getSessionValue(request, "USER_TYPE_DETAIL"));
    }


    /**
     * ***************************************************
     * 사용자유형코드저장
     *
     * @param request
     * @param termCd  ****************************************************
     */
    public static void setUserTycd(HttpServletRequest request, String userTycd) {
        SessionUtil.setSessionValue(request, "USER_TYCD", userTycd);
    }

    /**
     * **************************************************
     * 사용자유형코드가져오기
     *
     * @param request
     * @return ****************************************************
     */
    public static String getUserTycd(HttpServletRequest request) {
        return StringUtil.nvl((String) SessionUtil.getSessionValue(request, "USER_TYCD"));
    }


    /**
     * ***************************************************
     * 과목 학부/대학원 구분 설정
     *
     * @param request
     * @param termCd  ****************************************************
     */
    public static void setCourseUniCd(HttpServletRequest request, String uniCd) {
        SessionUtil.setSessionValue(request, "COURSE_UNI_CD", uniCd);
    }

    /**
     * **************************************************
     * 과목 학부/대학원 구분 가져오기
     *
     * @param request
     * @return ****************************************************
     */
    public static String getCourseUniCd(HttpServletRequest request) {
        return StringUtil.nvl((String) SessionUtil.getSessionValue(request, "COURSE_UNI_CD"));
    }

    /**
     * ***************************************************
     * 가상모드 스택 설정
     *
     * @param request
     * @param termCd  ****************************************************
     */
    public static void setVirtualLoginStack(HttpServletRequest request, Stack<Map<String, Object>> stack) {
        SessionUtil.setSessionValue(request, "VIRTUAL_LOGIN_STACK", stack);
    }

    /**
     * **************************************************
     * 가상모드 스택 가져오기
     *
     * @param request
     * @return ****************************************************
     */
    @SuppressWarnings("unchecked")
    public static Stack<Map<String, Object>> getVirtualLoginStack(HttpServletRequest request) {
        return (Stack<Map<String, Object>>) SessionUtil.getSessionValue(request, "VIRTUAL_LOGIN_STACK");
    }

    /**
     * ***************************************************
     * 가상모드 설정
     *
     * @param request
     * @param termCd  ****************************************************
     */
    public static void setVirtualLoginInfo(HttpServletRequest request, Map<String, Object> map) {
        SessionUtil.setSessionValue(request, "VIRTUAL_LOGIN_INFO", map);
    }

    /**
     * **************************************************
     * 가상모드 세션 가져오기
     *
     * @param request
     * @return ****************************************************
     */
    @SuppressWarnings("unchecked")
    public static Map<String, Object> getVirtualLoginInfo(HttpServletRequest request) {
        return (Map<String, Object>) SessionUtil.getSessionValue(request, "VIRTUAL_LOGIN_INFO");
    }

    /**
     * **************************************************
     * 가상모드 여부 가져오기
     *
     * @param request
     * @return ****************************************************
     */
    @SuppressWarnings("unchecked")
    public static boolean isVirtualLogin(HttpServletRequest request) {
        boolean isVirtualMode = false;
        Map<String, Object> info = (Map<String, Object>) SessionUtil.getSessionValue(request, "VIRTUAL_LOGIN_INFO");
        if (info != null && info.get("userId") != null) {
            isVirtualMode = true;
        }
        return isVirtualMode;
    }

    /**
     * **************************************************
     * 교수 학생화면보기 가상모드 여부 가져오기
     *
     * @param request
     * @return ****************************************************
     */
    @SuppressWarnings("unchecked")
    public static String getProfessorVirtualLoginYn(HttpServletRequest request) {
        boolean isVirtualMode = false;
        Map<String, Object> info = (Map<String, Object>) SessionUtil.getSessionValue(request, "VIRTUAL_LOGIN_INFO");
        if (info != null && info.get("userId") != null && "PROF".equals(StringUtil.nvl(info.get("modChgType")))) {
            isVirtualMode = true;
        }
        return isVirtualMode ? "Y" : "N";
    }

    /**
     * ***************************************************
     * 관리자 과목지원 정보 설정
     *
     * @param request
     * @param termCd  ****************************************************
     */
    public static void setAdminCrsInfo(HttpServletRequest request, Map<String, Object> map) {
        SessionUtil.setSessionValue(request, "ADMIN_CRS_INFO", map);
    }

    /**
     * **************************************************
     * 관리자 과목지원 정보 가져오기
     *
     * @param request
     * @return ****************************************************
     */
    @SuppressWarnings("unchecked")
    public static Map<String, Object> getAdminCrsInfo(HttpServletRequest request) {
        return (Map<String, Object>) SessionUtil.getSessionValue(request, "ADMIN_CRS_INFO");
    }

    /**
     * **************************************************
     * 관리자 과목지원 정보 여부 가져오기
     *
     * @param request
     * @return ****************************************************
     */
    @SuppressWarnings("unchecked")
    public static boolean isAdminCrsInfo(HttpServletRequest request) {
        boolean isAdminCrs = false;
        Map<String, Object> info = (Map<String, Object>) SessionUtil.getSessionValue(request, "ADMIN_CRS_INFO");
        if (info != null && info.get("userId") != null) {
            isAdminCrs = true;
        }
        return isAdminCrs;
    }

    /**
     * 사용자의 부서코드 가져오기
     *
     * @param request
     * @return
     */
    public static String getUserDeptId(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, "USER_DEPT_ID");
    }

    /**
     * 사용자의 부서코드 Set
     *
     * @param request
     * @param value
     */
    public static final void setUserDeptId(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, "USER_DEPT_ID", value);
    }

    /**
     * 학습자 청강생 여부 가져오기
     *
     * @param request
     */
    public static String getAuditYn(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.LOGIN_AUDITYN);
    }

    /**
     * 학습자 청강생 여부 Set
     *
     * @param request
     * @param value
     */
    public static final void setAuditYn(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_AUDITYN, value);
    }

    /**
     * 팝업공지 OPEN 여부 가져오기
     *
     * @param request
     */
    @SuppressWarnings("unchecked")
    public static String getPopNoticeOpenYn(HttpServletRequest request, String value) {
        Set<String> set = (Set<String>) SessionUtil.getSessionValue(request, "POP_NOTICE_OPEN");
        String popNoticeOpenYn = "N";


        if (set != null && set.contains(value)) {
            popNoticeOpenYn = "Y";
        }

        return popNoticeOpenYn;
    }

    /**
     * 팝업공지 OPEN 여부  Set
     *
     * @param request
     * @param value
     */
    public static final void setPopNoticeOpenYn(HttpServletRequest request, String value) {
        @SuppressWarnings("unchecked")
        Set<String> set = (Set<String>) SessionUtil.getSessionValue(request, "POP_NOTICE_OPEN");

        if (set == null) {
            set = new HashSet<>();
        }
        set.add(value);

        SessionUtil.setSessionValue(request, "POP_NOTICE_OPEN", set);
    }

    /**
     * 학습자 재수강 여부 가져오기
     *
     * @param request
     */
    public static String getRepeatYn(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, "LECT_REPEAT_YN");
    }

    /**
     * 학습자 재수강 여부 Set
     *
     * @param request
     * @param value
     */
    public static final void setRepeatYn(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, "LECT_REPEAT_YN", value);
    }

    /**
     * 선수과목 여부 가져오기
     *
     * @param request
     */
    public static String getPreCrsYn(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, "TMSW_PRE_SC_YN");
    }

    /**
     * 선수과목 여부 Set
     *
     * @param request
     * @param value
     */
    public static final void setPreCrsYn(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, "TMSW_PRE_SC_YN", value);
    }

    /**
     * 상위메뉴CD 가져오기
     *
     * @param request
     */
    public static String getCurUpMenuId(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, "CUR_UP_MENU_ID");
    }

    /**
     * 상위메뉴CD Set
     *
     * @param request
     * @param value
     */
    public static final void setCurUpMenuId(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, "CUR_UP_MENU_ID", value);
    }

    /**
     * 상위메뉴CD 가져오기
     *
     * @param request
     */
    public static String getCurParMenuCd(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, "CUR_PAR_MENU_CD");
    }

    /**
     * 상위메뉴CD Set
     *
     * @param request
     * @param value
     */
    public static final void setCurParMenuCd(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, "CUR_PAR_MENU_CD", value);
    }

    /**
     * 메뉴CD 가져오기
     *
     * @param request
     */
    public static String getCurMenuId(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, "CUR_MENU_ID");
    }

    /**
     * 메뉴CD Set
     *
     * @param request
     * @param value
     */
    public static final void setCurMenuId(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, "CUR_MENU_ID", value);
    }

    /**
     * 메뉴CD 가져오기
     *
     * @param request
     */
    public static String getCurMenuCd(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, "CUR_MENU_CD");
    }

    /**
     * 메뉴CD Set
     *
     * @param request
     * @param value
     */
    public static final void setCurMenuCd(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, "CUR_MENU_CD", value);
    }

    /**
     * 학습자 수강포기 여부 가져오기
     *
     * @param request
     */
    public static String getGvupYn(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, "ENRL_GVUP_YN");
    }

    /**
     * 학습자 수강포기 여부 Set
     *
     * @param request
     * @param value
     */
    public static final void setGvupYn(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, "ENRL_GVUP_YN", value);
    }

    /**
     * 이전학기 과목여부 가져오기
     *
     * @param request
     */
    public static String getPrevCourseYn(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, "PREV_COUSER_YN");
    }

    /**
     * 이전학기 과목여부 여부 Set
     *
     * @param request
     * @param value
     */
    public static final void setPrevCourseYn(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, "PREV_COUSER_YN", value);
    }

    /**
     * 기관이 한사대인지 확인
     * @param request
     * @return
     */
    /* public static final boolean isKnou(HttpServletRequest request) {
    	if (getOrgId(request).equals(CommConst.KNOU_ORG_ID)) {
    		return true;
    	}
    	else {
    		return false;
    	}
    }
    */

    /**
     * 기관이 방통대인지 확인
     *
     * @param request
     * @return
     */
    public static final boolean isKnou(HttpServletRequest request) {
        return getOrgId(request).equals(CommConst.KNOU_ORG_ID);
    }
    /**
     * 기관이 LMS기본조직인지 확인
     *
     * @param request
     * @return
     */
    public static final boolean isLmsBasic(HttpServletRequest request) {
        return getOrgId(request).equals(CommConst.LMSBASIC_ORG_ID);
    }

    /**
     * ***************************************************
     * 현재 과목 년도학기 설정
     *
     * @param request
     * @param yearTerm ****************************************************
     */
    public static void setCurCrsYearTerm(HttpServletRequest request, String yearTerm) {
        SessionUtil.setSessionValue(request, "CUR_CRS_YEARTERM", yearTerm);
    }

    /**
     * **************************************************
     * 현재 과목 년도학기 설정 가져오기
     *
     * @param request
     * @return ****************************************************
     */
    public static String getCurCrsYearTerm(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, "CUR_CRS_YEARTERM");
    }

    /**
     * 도메인 가져오기
     *
     * @param request
     */
    public static String getOrgDomain(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, "ORG_DOMAIN");
    }

    /**
     * 도메인 Set
     *
     * @param request
     * @param value
     */
    public static final void setOrgDomain(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, "ORG_DOMAIN", value);
    }

    /**
     * 기관목록 가져오기
     *
     * @param request
     */
    @SuppressWarnings("unchecked")
    public static List<OrgInfoVO> getOrgList(HttpServletRequest request) {
        return (List<OrgInfoVO>) SessionUtil.getSessionValue(request, "ORG_LIST");
    }

    /**
     * 기관목록 Set
     *
     * @param request
     * @param value
     */
    public static final void setOrgList(HttpServletRequest request, List<OrgInfoVO> value) {
        SessionUtil.setSessionValue(request, "ORG_LIST", value);
    }

    /**
     * 사용자 연결정보 가져오기
     *
     * @param request
     */
    @SuppressWarnings("unchecked")
    public static List<UsrUserInfoVO> getUserRltnList(HttpServletRequest request) {
        return (List<UsrUserInfoVO>) SessionUtil.getSessionValue(request, "USER_RLTL_LIST");
    }

    /**
     * 사용자 연결정보 Set
     *
     * @param request
     * @param value
     */
    public static final void setUserRltnList(HttpServletRequest request, List<UsrUserInfoVO> value) {
        SessionUtil.setSessionValue(request, "USER_RLTL_LIST", value);
    }

    /**
     * 강의평가 URL 가져오기
     *
     * @param request
     */
    public static String getLectEvalUrl(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, "LECT_EVAL_URL");
    }

    /**
     * 강의평가 URL Set
     *
     * @param request
     * @param value
     */
    public static final void setLectEvalUrl(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, "LECT_EVAL_URL", value);
    }

    /**
     * 사용자 타입을 가져온다.
     * @param request
     */
    public static String getUserType(HttpServletRequest request) {
        return (String) SessionUtil.getSessionValue(request, CommConst.LOGIN_USERTYPE);
    }

    /**
     * 사용자 타입 Set
     * @param request
     * @param value
     */
    public static final void setUserType(HttpServletRequest request, String value) {
        SessionUtil.setSessionValue(request, CommConst.LOGIN_USERTYPE, value);
    }
}
