package knou.lms.user.facade.impl;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.context2.UserContext;
import knou.framework.util.CryptoUtil;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.lms.cmmn.service.CmmnCdService;
import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.common.dto.ResultDTO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import knou.lms.msg.facade.MsgAlimTalkFacadeService;
import knou.lms.msg.facade.MsgPushFacadeService;
import knou.lms.msg.facade.MsgShrtntFacadeService;
import knou.lms.msg.facade.MsgSmsFacadeService;
import knou.lms.msg.vo.MsgAlimTalkVO;
import knou.lms.msg.vo.MsgPushVO;
import knou.lms.msg.vo.MsgShrtntVO;
import knou.lms.msg.vo.MsgSmsVO;
import knou.lms.org.service.OrgInfoService;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.user.facade.UserMgrFacadeService;
import knou.lms.user.service.UserMgrService;
import knou.lms.user.vo.UserMsgVO;
import knou.lms.user.vo.UserMgrListVO;
import knou.lms.user.vo.UserMgrVO;
import knou.lms.user.web.view.UserMgrFormView;
import knou.lms.user.web.view.UserMgrListView;

@Service("userMgrFacadeService")
public class UserMgrFacadeServiceImpl implements UserMgrFacadeService {

    private static final Log log = LogFactory.getLog(UserMgrFacadeServiceImpl.class);

    private static final String CD_USER_STS = "USER_STSCD";       // 사용자 상태
    private static final String CD_AC_RCD_TY = "AC_RCD_TYCD";     // 학적유형(학적 상태)
    private static final String CD_DSBL_TY = "DSBL_TYCD";      // 장애 유형
    private static final String CD_DSBL_GRD = "DSBL_GRDCD";    // 장애 등급

    private static final int SMS_BYTE_LIMIT = 90;    // SMS 단문 기준 byte (초과 시 LMS), SMS 작성화면과 동일

    @Resource(name = "userMgrService")
    private UserMgrService userMgrService;

    @Resource(name = "orgInfoService")
    private OrgInfoService orgInfoService;

    @Resource(name = "cmmnCdService")
    private CmmnCdService cmmnCdService;

    @Resource(name = "attachFileService")
    private AttachFileService attachFileService;

    @Resource(name = "msgPushFacadeService")
    private MsgPushFacadeService msgPushFacadeService;

    @Resource(name = "msgSmsFacadeService")
    private MsgSmsFacadeService msgSmsFacadeService;

    @Resource(name = "msgAlimTalkFacadeService")
    private MsgAlimTalkFacadeService msgAlimTalkFacadeService;

    @Resource(name = "msgShrtntFacadeService")
    private MsgShrtntFacadeService msgShrtntFacadeService;

    /*****************************************************
     * 사용자 관리 목록 화면 View 조회
     * @param vo
     * @param userCtx
     * @return UserMgrListView
     * @throws Exception
     ******************************************************/
    @Override
    public UserMgrListView userMgrListView(UserMgrListVO vo, UserContext userCtx) throws Exception {
        String orgId = resolveOrgId(vo.getOrgId(), userCtx);
        vo.setOrgId(orgId);

        UserMgrListView view = new UserMgrListView();
        view.setOrgList(getOrgList(userCtx));
        view.setAuthrtGrpList(userMgrService.listAdminGbn());
        view.setUserStscdList(getCodeList(CD_USER_STS, userCtx));
        view.setUserTyList(userMgrService.listUserGbn());
        view.setAcRcdTyList(getCodeList(CD_AC_RCD_TY, userCtx));
        view.setAllOrgYn(isSysAdmin(userCtx) ? "Y" : "N");
        return view;
    }

    /*****************************************************
     * 사용자 목록 조회
     * @param vo
     * @param userCtx
     * @return ResultDTO<EgovMap>
     ******************************************************/
    @Override
    public ResultDTO<EgovMap> listUserMgr(UserMgrListVO vo, UserContext userCtx) {
        vo.setOrgId(resolveOrgId(vo.getOrgId(), userCtx));
        return userMgrService.listUserMgr(vo);
    }

    /*****************************************************
     * 사용자 등록/수정 폼 화면 View 조회
     * @param vo
     * @param userCtx
     * @return UserMgrFormView
     * @throws Exception
     ******************************************************/
    @Override
    public UserMgrFormView userMgrFormView(UserMgrVO vo, UserContext userCtx) throws Exception {
        UserMgrFormView view = new UserMgrFormView();

        UserMgrVO detail = null;

        if (!isBlank(vo.getUserId())) {
            detail = userMgrService.selectUserMgr(vo);
            if (detail != null) {
                decryptDsblCodes(detail);
            }
        }

        view.setDetail(detail);
        view.setPhotoFileList(getPhotoFileList(detail));
        view.setOrgList(getOrgList(userCtx));
        view.setAuthrtList(userMgrService.listAdminGbn());
        view.setUserAuthrtIds(isBlank(vo.getUserId()) ? null : userMgrService.listUserAuthrtId(vo));
        view.setUserTyAuthrtList(userMgrService.listUserGbn());
        view.setAcRcdTyList(getCodeList(CD_AC_RCD_TY, userCtx));
        view.setDsblTyList(getCodeList(CD_DSBL_TY, userCtx));
        view.setDsblGrdList(getCodeList(CD_DSBL_GRD, userCtx));
        view.setAllOrgYn(isSysAdmin(userCtx) ? "Y" : "N");
        return view;
    }

    /*****************************************************
     * 사용자 단건 조회
     * @param vo
     * @param userCtx
     * @return ResultDTO<UserMgrVO>
     ******************************************************/
    @Override
    public ResultDTO<UserMgrVO> selectUserMgr(UserMgrVO vo, UserContext userCtx) {
        ResultDTO<UserMgrVO> resultDTO = new ResultDTO<UserMgrVO>();

        if (isBlank(vo.getUserId())) {
            return resultDTO.setResultFailed("사용자를 선택해 주세요.");
        }

        UserMgrVO detail = userMgrService.selectUserMgr(vo);
        if (detail == null) {
            return resultDTO.setResultFailed("사용자 정보를 확인할 수 없습니다.");
        }
        detail.setUsernm(maskUserNm(detail.getUsernm()));
        detail.setStdntNo(maskStdntNo(detail.getStdntNo()));
        return resultDTO.setData(detail).setResultSuccess();
    }

    /*****************************************************
     * 사용자 정보 모달용 단건 조회
     * @param vo
     * @param userCtx
     * @return ResultDTO<UserMgrVO>
     ******************************************************/
    @Override
    public ResultDTO<UserMgrVO> selectUserMgrInfo(UserMgrVO vo, UserContext userCtx) {
        ResultDTO<UserMgrVO> resultDTO = selectUserMgr(vo, userCtx);

        UserMgrVO detail = resultDTO.getData();
        if (detail != null) {
            detail.setUserId(maskUserId(detail.getUserId()));
            detail.setMobileNo(maskMobile(detail.getMobileNo()));
            detail.setEmail(maskEmail(detail.getEmail()));
        }
        return resultDTO;
    }

    /*****************************************************
     * 사용자전화번호변경이력 조회 (변경전/후 연락처는 마스킹)
     * @param vo
     * @param userCtx
     * @return ResultDTO<EgovMap>
     ******************************************************/
    @Override
    public ResultDTO<EgovMap> listUserTelnoChgHstry(UserMgrVO vo, UserContext userCtx) {
        ResultDTO<EgovMap> resultDTO = new ResultDTO<EgovMap>();

        if (isBlank(vo.getUserId())) {
            return resultDTO.setResultFailed("사용자를 선택해 주세요.");
        }

        List<EgovMap> list = userMgrService.listUserTelnoChgHstry(vo);
        if (list != null) {
            for (EgovMap row : list) {
                row.put("chgbfrMblTelno", maskMobile(strVal(row.get("chgbfrMblTelno"))));
                row.put("chgaftMblTelno", maskMobile(strVal(row.get("chgaftMblTelno"))));
                row.put("stdntNo", maskStdntNo(strVal(row.get("stdntNo"))));
                row.put("usernm", maskUserNm(strVal(row.get("usernm"))));
            }
        }
        return resultDTO.setReturnList(list).setResultSuccess();
    }

    /*****************************************************
     * EgovMap 값 String 변환 (null 안전)
     * @param value
     * @return String
     ******************************************************/
    private String strVal(Object value) {
        return value == null ? "" : String.valueOf(value);
    }

    /*****************************************************
     * 학번/사번 마스킹 (끝 5자리 기준 앞3 + *** + 뒤2, 목록과 동일 규칙)
     * @param stdntNo
     * @return 마스킹된 값
     ******************************************************/
    private String maskStdntNo(String stdntNo) {
        String s = StringUtil.nvl(stdntNo);
        int len = s.length();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < len; i++) {
            int posFromEnd = len - i;
            sb.append(posFromEnd >= 3 && posFromEnd <= 5 ? '*' : s.charAt(i));
        }
        return sb.toString();
    }

    /*****************************************************
     * 이름 마스킹 (두 번째 글자만 마스킹)
     * @param nm
     * @return 마스킹된 값
     ******************************************************/
    private String maskUserNm(String nm) {
        String s = StringUtil.nvl(nm);
        if (s.length() < 2) {
            return s;
        }
        return s.charAt(0) + "*" + s.substring(2);
    }

    /*****************************************************
     * 아이디 마스킹 (뒤 1자리 평문, 뒤에서 2·3번째 마스킹, 그 앞 평문)
     * @param userId
     * @return 마스킹된 값
     ******************************************************/
    private String maskUserId(String userId) {
        String s = StringUtil.nvl(userId);
        int len = s.length();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < len; i++) {
            int posFromEnd = len - i;
            sb.append(posFromEnd >= 2 && posFromEnd <= 3 ? '*' : s.charAt(i));
        }
        return sb.toString();
    }

    /*****************************************************
     * 휴대폰번호 마스킹 (끝 2자리만 마스킹)
     * @param phone
     * @return 마스킹된 값
     ******************************************************/
    private String maskMobile(String phone) {
        String s = StringUtil.nvl(phone);
        int len = s.length();
        if (len < 2) {
            return s;
        }
        return s.substring(0, len - 2) + "**";
    }

    /*****************************************************
     * 이메일 마스킹 (@앞 로컬부는 아이디 규칙, 도메인은 평문)
     * @param email
     * @return 마스킹된 값
     ******************************************************/
    private String maskEmail(String email) {
        String s = StringUtil.nvl(email);
        int at = s.indexOf('@');
        if (at <= 0) {
            return s;
        }
        return maskUserId(s.substring(0, at)) + s.substring(at);
    }

    /*****************************************************
     * 사용자 등록
     * @param vo
     * @param userCtx
     * @return ResultDTO<UserMgrVO>
     ******************************************************/
    @Override
    public ResultDTO<UserMgrVO> registUserMgr(UserMgrVO vo, UserContext userCtx) {
        vo.setOrgId(resolveRequiredOrgId(vo.getOrgId(), userCtx));
        vo.setRgtrId(getUserId(userCtx));
        vo.setMdfrId(getUserId(userCtx));

        String pswdMessage = applyNewPassword(vo, true);
        if (pswdMessage != null) {
            return new ResultDTO<UserMgrVO>().setResultFailed(pswdMessage);
        }

        applyDsblYn(vo);
        encryptDsblCodes(vo);

        List<AtflVO> photoFiles = buildPhotoAtflList(vo);
        ResultDTO<UserMgrVO> result = userMgrService.insertUserMgr(vo);
        finalizePhotoFiles(result, vo, photoFiles);
        return result;
    }

    /*****************************************************
     * 사용자 수정
     * @param vo
     * @param userCtx
     * @return ResultDTO<UserMgrVO>
     ******************************************************/
    @Override
    public ResultDTO<UserMgrVO> modifyUserMgr(UserMgrVO vo, UserContext userCtx) {
        vo.setOrgId(resolveRequiredOrgId(vo.getOrgId(), userCtx));
        vo.setRgtrId(getUserId(userCtx));
        vo.setMdfrId(getUserId(userCtx));

        String pswdMessage = applyNewPassword(vo, false);
        if (pswdMessage != null) {
            return new ResultDTO<UserMgrVO>().setResultFailed(pswdMessage);
        }

        UserMgrVO before = userMgrService.selectUserMgr(vo);
        if (before != null) {
            decryptDsblCodes(before);
            vo.setOrgId(before.getOrgId());
            vo.setStdntNo(before.getStdntNo());
        }
        List<Map<String, Object>> infoChgRows = (before == null) ? new ArrayList<Map<String, Object>>()
                : buildUserInfoChgRows(before, vo, userCtx);
        Map<String, Object> telnoChgRow = (before != null && isMobileChanged(before, vo))
                ? buildUserTelnoChgRow(before, vo, userCtx) : null;

        Set<String> admAuthrtIds = toAuthrtIdSet(userMgrService.listAdminGbn());
        List<String> beforeAuthrtIds = userMgrService.listUserAuthrtId(vo);
        String beforeAdmAuthrtId = pickAuthrtId(beforeAuthrtIds, admAuthrtIds, true);
        String beforeUserTyAuthrtId = pickAuthrtId(beforeAuthrtIds, admAuthrtIds, false);
        String afterAdmAuthrtId = StringUtil.nvl(vo.getAuthrtId());
        String afterUserTyAuthrtId = StringUtil.nvl(vo.getUserTyAuthrtId());

        applyDsblYn(vo);
        encryptDsblCodes(vo);

        String oldPhotoFileId = StringUtil.nvl(vo.getPhotoFileId());

        List<AtflVO> photoFiles = buildPhotoAtflList(vo);
        ResultDTO<UserMgrVO> result = userMgrService.updateUserMgr(vo);
        finalizePhotoFiles(result, vo, photoFiles);
        cleanupOldPhoto(result, photoFiles, oldPhotoFileId, vo.getPhotoFileId());

        if (before != null) {
            addInfoChgRow(infoChgRows, vo, userCtx, "USER_PRFIL_008", "프로필사진", before.getPhotoFileId(), vo.getPhotoFileId(), true);
        }

        if (result.getResult() == ResultDTO.RESULT_SUCC) {
            for (Map<String, Object> row : infoChgRows) {
                userMgrService.insertUserInfoChgHstry(row);
            }
            if (telnoChgRow != null) {
                userMgrService.insertUserTelnoChgHstry(telnoChgRow);
            }
            if (before != null) {
                registAuthChgHstry(before, vo, beforeAdmAuthrtId, afterAdmAuthrtId, userCtx);
                registAuthChgHstry(before, vo, beforeUserTyAuthrtId, afterUserTyAuthrtId, userCtx);
            }
        }
        return result;
    }

    /*****************************************************
     * 사용자정보변경이력 행 목록 생성
     * @param before
     * @param after
     * @param userCtx
     * @return 이력 INSERT 파라미터 목록
     ******************************************************/
    private List<Map<String, Object>> buildUserInfoChgRows(UserMgrVO before, UserMgrVO after, UserContext userCtx) {
        List<Map<String, Object>> rows = new ArrayList<Map<String, Object>>();
        addInfoChgRow(rows, after, userCtx, "USER_PRFIL_002", "이름",       before.getUsernm(),   after.getUsernm(),   true);
        addInfoChgRow(rows, after, userCtx, "USER_AC_RCD_004","학적상태",   before.getAcRcdTycd(), after.getAcRcdTycd(), true);
        addInfoChgRow(rows, after, userCtx, "USER_PRFIL_010", "장애유형",   before.getDsblTycd(),  after.getDsblTycd(),  true);
        addInfoChgRow(rows, after, userCtx, "USER_PRFIL_011", "장애등급",   before.getDsblGrdcd(), after.getDsblGrdcd(), true);
        addInfoChgRow(rows, after, userCtx, "USER_PRFIL_015", "고령자유무", before.getSnryn(),     after.getSnryn(),     true);
        addInfoChgRow(rows, after, userCtx, "USER_CNTCT_002", "휴대폰번호", before.getMobileNo(),  after.getMobileNo(),  false);
        addInfoChgRow(rows, after, userCtx, "USER_CNTCT_002", "이메일",     before.getEmail(),     after.getEmail(),     false);
        return rows;
    }

    /*****************************************************
     * 변경된 경우에만 정보변경이력 행 추가
     * @param rows
     * @param after
     * @param userCtx
     * @param chgTycd
     * @param label
     * @param beforeVal
     * @param afterVal
     * @param applyWhenBlank
     ******************************************************/
    private void addInfoChgRow(List<Map<String, Object>> rows, UserMgrVO after, UserContext userCtx,
            String chgTycd, String label, String beforeVal, String afterVal, boolean applyWhenBlank) {
        String oldVal = StringUtil.nvl(beforeVal);
        String newVal = StringUtil.nvl(afterVal);
        if (!applyWhenBlank && newVal.isEmpty()) {
            return;
        }
        if (oldVal.equals(newVal)) {
            return;
        }

        Map<String, Object> row = new HashMap<String, Object>();
        row.put("userInfoChgHstryId", IdGenerator.getNewId(IdPrefixType.USCHG.getCode()));
        row.put("userId", after.getUserId());
        row.put("userinfoChgTycd", chgTycd);
        row.put("chgbfrCts", toJsonArray(label, oldVal));
        row.put("chgaftCts", toJsonArray(label, newVal));
        putConnInfo(row, after);
        row.put("rgtrId", getUserId(userCtx));
        rows.add(row);
    }

    /*****************************************************
     * 사용자전화번호변경이력 행 생성
     * @param before
     * @param after
     * @param userCtx
     * @return 이력 INSERT 파라미터
     ******************************************************/
    private Map<String, Object> buildUserTelnoChgRow(UserMgrVO before, UserMgrVO after, UserContext userCtx) {
        Map<String, Object> row = new HashMap<String, Object>();
        row.put("userTelnoChgHstryId", IdGenerator.getNewId(IdPrefixType.USTHS.getCode()));
        row.put("userId", after.getUserId());
        row.put("chgbfrMblTelno", StringUtil.nvl(before.getMobileNo()));
        row.put("chgaftMblTelno", StringUtil.nvl(after.getMobileNo()));
        row.put("orgId", StringUtil.nvl(after.getOrgId()));
        row.put("stdntNo", after.getStdntNo());
        row.put("rgtrId", getUserId(userCtx));
        return row;
    }

    /*****************************************************
     * 휴대폰번호 변경 여부
     * @param before
     * @param after
     * @return boolean
     ******************************************************/
    private boolean isMobileChanged(UserMgrVO before, UserMgrVO after) {
        String oldM = StringUtil.nvl(before.getMobileNo());
        String newM = StringUtil.nvl(after.getMobileNo());
        if (oldM.isEmpty() || newM.isEmpty()) {
            return false;
        }
        return !oldM.equals(newM);
    }

    /*****************************************************
     * 라벨:값을 JSON 배열 문자열로 변환 (예: 이름, 홍길동 → ["이름:홍길동"])
     * @param label
     * @param value
     * @return JSON 배열 문자열
     ******************************************************/
    private String toJsonArray(String label, String value) {
        String v = StringUtil.nvl(label) + ":" + StringUtil.nvl(value);
        v = v.replace("\\", "\\\\").replace("\"", "\\\"");
        return "[\"" + v + "\"]";
    }

    /*****************************************************
     * 접속정보(IP/브라우저/기기유형) 파라미터 세팅 (NOT NULL 보장 위해 기본값 처리)
     * @param row
     * @param vo
     ******************************************************/
    private void putConnInfo(Map<String, Object> row, UserMgrVO vo) {
        String ip = StringUtil.nvl(vo.getCntnIp());
        String brwsr = StringUtil.nvl(vo.getCntnBrwsr());
        String dvc = StringUtil.nvl(vo.getCntnDvcTycd());
        if (brwsr.length() > 1000) {
            brwsr = brwsr.substring(0, 1000);
        }
        row.put("cntnIp", ip.isEmpty() ? "-" : ip);
        row.put("cntnBrwsr", brwsr.isEmpty() ? "-" : brwsr);
        row.put("cntnDvcTycd", dvc.isEmpty() ? "PC" : dvc);
    }

    /*****************************************************
     * 권한변경이력 적재
     * @param target
     * @param connSrc
     * @param beforeAuthrtId
     * @param afterAuthrtId
     * @param userCtx
     ******************************************************/
    private void registAuthChgHstry(UserMgrVO target, UserMgrVO connSrc, String beforeAuthrtId, String afterAuthrtId, UserContext userCtx) {
        String beforeId = StringUtil.nvl(beforeAuthrtId);
        String afterId = StringUtil.nvl(afterAuthrtId);
        if (afterId.isEmpty() || beforeId.equals(afterId)) {
            return;
        }

        UserMgrVO param = new UserMgrVO();
        param.setAuthrtId(afterId);
        EgovMap authrt = userMgrService.selectAuthrt(param);
        if (authrt == null) {
            return;
        }

        Map<String, Object> row = new HashMap<String, Object>();
        row.put("orgId", StringUtil.nvl(target.getOrgId()));
        row.put("userId", target.getUserId());
        row.put("usernm", StringUtil.nvl(target.getUsernm()));
        row.put("authrtId", afterId);
        row.put("authrtCd", strVal(authrt.get("authrtCd")));
        row.put("authrtnm", strVal(authrt.get("authrtnm")));
        row.put("authrtChgCts", "권한 변경");
        row.put("rgtrId", getUserId(userCtx));
        userMgrService.insertUserAuthrtChgHstry(row);

        Map<String, Object> infoRow = new HashMap<String, Object>();
        infoRow.put("userInfoChgHstryId", IdGenerator.getNewId(IdPrefixType.USCHG.getCode()));
        infoRow.put("userId", target.getUserId());
        infoRow.put("userinfoChgTycd", "USER_ACNT_AUTHRT_001");
        infoRow.put("chgbfrCts", toJsonArray("권한", resolveAuthrtNm(beforeId)));
        infoRow.put("chgaftCts", toJsonArray("권한", strVal(authrt.get("authrtnm"))));
        putConnInfo(infoRow, connSrc);
        infoRow.put("rgtrId", getUserId(userCtx));
        userMgrService.insertUserInfoChgHstry(infoRow);
    }

    /*****************************************************
     * 권한 ID로 권한명 조회 (없으면 빈 문자열)
     * @param authrtId
     * @return 권한명
     ******************************************************/
    private String resolveAuthrtNm(String authrtId) {
        if (isBlank(authrtId)) {
            return "";
        }
        UserMgrVO param = new UserMgrVO();
        param.setAuthrtId(authrtId);
        EgovMap authrt = userMgrService.selectAuthrt(param);
        return authrt == null ? "" : strVal(authrt.get("authrtnm"));
    }

    /*****************************************************
     * 관리자구분(AUTHRT_GRPCD = 'ADM') 권한 ID 집합 생성
     * @param admGbnList
     * @return 관리자구분 권한 ID Set
     ******************************************************/
    private Set<String> toAuthrtIdSet(List<EgovMap> admGbnList) {
        Set<String> set = new HashSet<String>();
        if (admGbnList != null) {
            for (EgovMap row : admGbnList) {
                set.add(strVal(row.get("authrtId")));
            }
        }
        return set;
    }

    /*****************************************************
     * 보유 권한 ID 목록에서 관리자구분/사용자구분 권한 ID 1건 선택
     * @param authrtIds
     * @param admAuthrtIds
     * @param wantAdm
     * @return 해당 구분의 권한 ID (없으면 빈 문자열)
     ******************************************************/
    private String pickAuthrtId(List<String> authrtIds, Set<String> admAuthrtIds, boolean wantAdm) {
        if (authrtIds == null) {
            return "";
        }
        for (String id : authrtIds) {
            if (admAuthrtIds.contains(id) == wantAdm) {
                return id;
            }
        }
        return "";
    }

    /*****************************************************
     * 기존 프로필 사진 첨부 조회
     * @param detail
     * @return List<AtflVO>
     ******************************************************/
    private List<AtflVO> getPhotoFileList(UserMgrVO detail) {
        if (detail == null || isBlank(detail.getPhotoFileId())) {
            return Collections.emptyList();
        }

        AtflVO param = new AtflVO();
        param.setAtflId(detail.getPhotoFileId());
        AtflVO photo = attachFileService.selectAtfl(param);
        if (photo == null) {
            return Collections.emptyList();
        }

        List<AtflVO> photoFiles = new ArrayList<AtflVO>();
        photoFiles.add(photo);
        return photoFiles;
    }

    /*****************************************************
     * 업로드된 프로필 사진 파싱 후 photoFileId 세팅
     * @param vo
     * @return 저장 대상 첨부 목록 (없으면 빈 목록)
     ******************************************************/
    private List<AtflVO> buildPhotoAtflList(UserMgrVO vo) {
        if (isBlank(vo.getUploadFiles())) {
            return Collections.emptyList();
        }

        List<AtflVO> uploadList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
        if (uploadList == null || uploadList.isEmpty()) {
            return Collections.emptyList();
        }

        AtflVO atfl = uploadList.get(0);
        atfl.setRefId(vo.getUserId());
        atfl.setRgtrId(vo.getRgtrId());
        atfl.setMdfrId(vo.getMdfrId());
        atfl.setAtflRepoId(CommConst.REPO_USER);
        vo.setPhotoFileId(atfl.getAtflId());

        List<AtflVO> photoFiles = new ArrayList<AtflVO>();
        photoFiles.add(atfl);
        return photoFiles;
    }

    /*****************************************************
     * 저장 결과에 따른 첨부 후처리 (성공 시 적재 / 실패 시 임시파일 정리)
     * @param result
     * @param vo
     * @param photoFiles
     ******************************************************/
    private void finalizePhotoFiles(ResultDTO<UserMgrVO> result, UserMgrVO vo, List<AtflVO> photoFiles) {
        if (result.getResult() == ResultDTO.RESULT_SUCC) {
            if (!photoFiles.isEmpty()) {
                attachFileService.insertAtflList(photoFiles);
            }
            return;
        }

        if (!isBlank(vo.getUploadFiles())) {
            try {
                FileUtil.delUploadFileList(vo.getUploadFiles(), vo.getUploadPath());
            } catch (Exception e) {
                log.error("프로필 사진 임시파일 정리 실패", e);
            }
        }
    }

    /*****************************************************
     * 사진 교체 시 이전 프로필 사진 ATFL 정리
     * @param result
     * @param photoFiles
     * @param oldPhotoFileId
     * @param newPhotoFileId
     ******************************************************/
    private void cleanupOldPhoto(ResultDTO<UserMgrVO> result, List<AtflVO> photoFiles, String oldPhotoFileId, String newPhotoFileId) {
        if (result.getResult() != ResultDTO.RESULT_SUCC || photoFiles.isEmpty()) {
            return;
        }
        if (isBlank(oldPhotoFileId) || oldPhotoFileId.equals(StringUtil.nvl(newPhotoFileId))) {
            return;
        }
        try {
            attachFileService.deleteAtflByAtflIds(new String[] { oldPhotoFileId });
        } catch (Exception e) {
            log.error("이전 프로필 사진 ATFL 정리 실패", e);
        }
    }

    /*****************************************************
     * 장애여부(DSBLYN) 결정
     * @param vo
     ******************************************************/
    private void applyDsblYn(UserMgrVO vo) {
        boolean hasDsbl = !isBlank(vo.getDsblTycd()) || !isBlank(vo.getDsblGrdcd());
        vo.setDsblyn(hasDsbl ? "Y" : "N");
    }

    /*****************************************************
     * 장애유형/등급 코드 AES256 암호화 (저장 전)
     * @param vo
     ******************************************************/
    private void encryptDsblCodes(UserMgrVO vo) {
        try {
            vo.setDsblTycd(CryptoUtil.encryptAes256(vo.getDsblTycd()));
            vo.setDsblGrdcd(CryptoUtil.encryptAes256(vo.getDsblGrdcd()));
        } catch (GeneralSecurityException | UnsupportedEncodingException e) {
            log.error("장애유형/등급 암호화 실패", e);
        }
    }

    /*****************************************************
     * 장애유형/등급 코드 AES256 복호화 (폼 표시용)
     * @param detail
     ******************************************************/
    private void decryptDsblCodes(UserMgrVO detail) {
        try {
            detail.setDsblTycd(CryptoUtil.decryptAes256(detail.getDsblTycd()));
            detail.setDsblGrdcd(CryptoUtil.decryptAes256(detail.getDsblGrdcd()));
        } catch (GeneralSecurityException | UnsupportedEncodingException e) {
            log.error("장애유형/등급 복호화 실패", e);
        }
    }

    /*****************************************************
     * 비밀번호 검증 후 SHA 암호화하여 VO에 세팅
     * @param vo
     * @param required
     * @return 검증 실패 메시지 (정상 시 null)
     ******************************************************/
    private String applyNewPassword(UserMgrVO vo, boolean required) {
        String rawPswd = StringUtil.nvl(vo.getUserIdEncpswd()).trim();

        if (isBlank(rawPswd)) {
            if (required) {
                return "비밀번호를 입력해 주세요.";
            }
            vo.setUserIdEncpswd(null);
            return null;
        }

        String policyMessage = validatePasswordPolicy(rawPswd);
        if (policyMessage != null) {
            return policyMessage;
        }

        vo.setUserIdEncpswd(CryptoUtil.encryptSha(rawPswd));
        return null;
    }

    /*****************************************************
     * 비밀번호 정책 검증 (8~16자, 영문/숫자/특수문자 중 2가지 이상 조합)
     * @param rawPswd
     * @return 검증 실패 메시지 (정상 시 null)
     ******************************************************/
    private String validatePasswordPolicy(String rawPswd) {
        if (rawPswd.length() < 8 || rawPswd.length() > 16) {
            return "비밀번호는 8자 이상 16자 이하로 입력해 주세요.";
        }

        int kinds = 0;
        if (rawPswd.matches(".*[a-zA-Z].*")) {
            kinds++;
        }
        if (rawPswd.matches(".*[0-9].*")) {
            kinds++;
        }
        if (rawPswd.matches(".*[^a-zA-Z0-9].*")) {
            kinds++;
        }
        if (kinds < 2) {
            return "비밀번호는 영문/숫자/특수문자 중 2가지 이상을 조합해 주세요.";
        }
        return null;
    }

    /*****************************************************
     * 사용자 아이디 중복 확인
     * @param vo
     * @return ResultDTO<UserMgrVO> (data.userId 사용 가능 여부는 message로 전달)
     ******************************************************/
    @Override
    public ResultDTO<UserMgrVO> countUserMgrId(UserMgrVO vo) {
        ResultDTO<UserMgrVO> resultDTO = new ResultDTO<UserMgrVO>();

        if (isBlank(vo.getUserId())) {
            return resultDTO.setResultFailed("아이디를 입력해 주세요.");
        }

        if (userMgrService.countUserMgrId(vo) > 0) {
            return resultDTO.setResultFailed("이미 사용 중인 아이디입니다.");
        }
        return resultDTO.setResultSuccess("사용 가능한 아이디입니다.");
    }

    /*****************************************************
     * 학번/사번 중복 확인 (수정 시 본인 제외)
     * @param vo
     * @return ResultDTO<UserMgrVO> (사용 가능 여부는 message로 전달)
     ******************************************************/
    @Override
    public ResultDTO<UserMgrVO> countUserMgrStdntNo(UserMgrVO vo) {
        ResultDTO<UserMgrVO> resultDTO = new ResultDTO<UserMgrVO>();

        if (isBlank(vo.getStdntNo())) {
            return resultDTO.setResultFailed("학번/사번을 입력해 주세요.");
        }

        if (userMgrService.countUserMgrStdntNo(vo) > 0) {
            return resultDTO.setResultFailed("이미 사용 중인 학번/사번입니다.");
        }
        return resultDTO.setResultSuccess("사용 가능한 학번/사번입니다.");
    }

    /*****************************************************
     * 사용자 관리자구분(권한) 변경
     * @param vo
     * @param userCtx
     * @return ResultDTO<UserMgrVO>
     ******************************************************/
    @Override
    public ResultDTO<UserMgrVO> modifyUserMgrAuth(UserMgrVO vo, UserContext userCtx) {
        vo.setRgtrId(getUserId(userCtx));
        vo.setMdfrId(getUserId(userCtx));

        UserMgrVO target = userMgrService.selectUserMgr(vo);
        Set<String> admAuthrtIds = toAuthrtIdSet(userMgrService.listAdminGbn());
        String beforeAdmAuthrtId = pickAuthrtId(userMgrService.listUserAuthrtId(vo), admAuthrtIds, true);

        ResultDTO<UserMgrVO> resultDTO = userMgrService.updateUserMgrAuth(vo);

        if (resultDTO.getResult() == ResultDTO.RESULT_SUCC && target != null) {
            registAuthChgHstry(target, vo, beforeAdmAuthrtId, vo.getAuthrtId(), userCtx);
        }
        return resultDTO;
    }

    /*****************************************************
     * 사용자 탈퇴 처리 (손님 대상, 관리자 대리 탈퇴)
     * @param vo
     * @param userCtx
     * @return ResultDTO<UserMgrVO>
     ******************************************************/
    @Override
    public ResultDTO<UserMgrVO> withdrawUserMgr(UserMgrVO vo, UserContext userCtx) {
        vo.setMdfrId(getUserId(userCtx));
        return userMgrService.withdrawUserMgr(vo);
    }

    /*****************************************************
     * 사용자 알림 바로 보내기 (선택 채널별 메시지 발송 모듈 위임)
     * @param vo
     * @param userCtx
     * @return ResultDTO<UserMsgVO>
     ******************************************************/
    @Override
    public ResultDTO<UserMsgVO> sendUserMsg(UserMsgVO vo, UserContext userCtx) {
        ResultDTO<UserMsgVO> resultDTO = new ResultDTO<UserMsgVO>();

        String channels = StringUtil.nvl(vo.getChannels());
        if (channels.isEmpty()) {
            return resultDTO.setResultFailed("발송 채널을 선택해 주세요.");
        }
        if (isBlank(vo.getTtl())) {
            return resultDTO.setResultFailed("제목을 입력해 주세요.");
        }
        if (isBlank(vo.getCts())) {
            return resultDTO.setResultFailed("내용을 입력해 주세요.");
        }
        if (needsSndngrPhn(channels) && isBlank(vo.getSndngrPhn())) {
            return resultDTO.setResultFailed("발신자 번호를 입력해 주세요.");
        }
        if (isBlank(vo.getRcvrListJson())) {
            return resultDTO.setResultFailed("받는 사람을 추가해 주세요.");
        }

        String adminId = getUserId(userCtx);
        String orgId = getOrgId(userCtx);
        List<String> sent = new ArrayList<String>();
        List<String> failed = new ArrayList<String>();

        for (String ch : channels.split(",")) {
            String c = ch.trim();
            try {
                if ("PUSH".equals(c)) {
                    sendMsgPush(vo, adminId, orgId);
                    sent.add("PUSH");
                } else if ("SHRTNT".equals(c)) {
                    sendMsgShrtnt(vo, adminId, orgId);
                    sent.add("쪽지");
                } else if ("ALIMTALK".equals(c)) {
                    sendMsgTalk(vo, adminId, orgId);
                    sent.add("알림톡");
                } else if ("SMS".equals(c)) {
                    sendMsgSms(vo, adminId, orgId);
                    sent.add("문자");
                }
            } catch (Exception e) {
                log.error("알림 발송 실패 (채널=" + c + ")", e);
                failed.add(c);
            }
        }

        if (sent.isEmpty()) {
            return resultDTO.setResultFailed("발송에 실패하였습니다.");
        }
        String msg = String.join(", ", sent) + " 발송되었습니다.";
        if (!failed.isEmpty()) {
            msg += " (실패: " + String.join(", ", failed) + ")";
        }
        return resultDTO.setResultSuccess(msg);
    }

    /*****************************************************
     * PUSH 발송 (메시지 PUSH 발송 모듈 위임)
     * @param vo
     * @param adminId
     * @param orgId
     * @throws Exception
     ******************************************************/
    private void sendMsgPush(UserMsgVO vo, String adminId, String orgId) throws Exception {
        MsgPushVO p = new MsgPushVO();
        p.setMblSndngTycd(CommConst.MSG_CHNL_PUSH);
        p.setTtl(vo.getTtl());
        p.setTxtCts(vo.getCts());
        p.setSndngnm(vo.getSndngr());
        p.setSndngrPhnno(vo.getSndngrPhn());
        p.setRcvrListJson(vo.getRcvrListJson());
        p.setSndngrId(adminId);
        p.setRgtrId(adminId);
        p.setOrgId(orgId);
        msgPushFacadeService.registPushSndng(p);
    }

    /*****************************************************
     * 문자(SMS) 발송 (메시지 SMS 발송 모듈 위임)
     * @param vo
     * @param adminId
     * @param orgId
     * @throws Exception
     ******************************************************/
    private void sendMsgSms(UserMsgVO vo, String adminId, String orgId) throws Exception {
        MsgSmsVO s = new MsgSmsVO();
        boolean isLms = smsByteLength(vo.getCts()) > SMS_BYTE_LIMIT;
        s.setMblSndngTycd(isLms ? CommConst.MSG_CHNL_LMS : CommConst.MSG_CHNL_SMS);
        s.setTtl(vo.getTtl());
        s.setTxtCts(vo.getCts());
        s.setSndngnm(vo.getSndngr());
        s.setSndngrPhnno(vo.getSndngrPhn());
        s.setRcvrListJson(vo.getRcvrListJson());
        s.setSndngrId(adminId);
        s.setRgtrId(adminId);
        s.setOrgId(orgId);
        msgSmsFacadeService.registSmsSndng(s);
    }

    /*****************************************************
     * 알림톡 발송 (메시지 알림톡 발송 모듈 위임)
     * @param vo
     * @param adminId
     * @param orgId
     * @throws Exception
     ******************************************************/
    private void sendMsgTalk(UserMsgVO vo, String adminId, String orgId) throws Exception {
        MsgAlimTalkVO a = new MsgAlimTalkVO();
        a.setMblSndngTycd(CommConst.MSG_CHNL_ALIM_TALK);
        a.setTtl(vo.getTtl());
        a.setTxtCts(vo.getCts());
        a.setSndngnm(vo.getSndngr());
        a.setSndngrPhnno(vo.getSndngrPhn());
        a.setRcvrListJson(vo.getRcvrListJson());
        a.setSndngrId(adminId);
        a.setRgtrId(adminId);
        a.setOrgId(orgId);
        msgAlimTalkFacadeService.registAlimTalkSndng(a);
    }

    /*****************************************************
     * 쪽지 발송 (메시지 쪽지 발송 모듈 위임)
     * @param vo
     * @param adminId
     * @param orgId
     * @throws Exception
     ******************************************************/
    private void sendMsgShrtnt(UserMsgVO vo, String adminId, String orgId) throws Exception {
        MsgShrtntVO s = new MsgShrtntVO();
        s.setTtl(vo.getTtl());
        s.setTxtCts(vo.getCts());
        s.setSndngnm(vo.getSndngr());
        s.setRcvrListJson(vo.getRcvrListJson());
        s.setSndngrId(adminId);
        s.setRgtrId(adminId);
        s.setOrgId(orgId);
        msgShrtntFacadeService.registShrtntSndngWithFiles(s, null, null);
    }

    /*****************************************************
     * 관리자 구분 목록 조회
     * @return List<EgovMap>
     ******************************************************/
    @Override
    public List<EgovMap> listAdminGbn() {
        return userMgrService.listAdminGbn();
    }

    /*****************************************************
     * 사용자가 보유한 권한 ID 목록 조회
     * @param userId
     * @return List<String>
     ******************************************************/
    @Override
    public List<String> listUserAuthrtId(String userId) {
        UserMgrVO vo = new UserMgrVO();
        vo.setUserId(userId);
        return userMgrService.listUserAuthrtId(vo);
    }

    /*****************************************************
     * 공통코드 하위 목록 조회 (TB_LMS_CMMN_CD UP_CD 기준, 사용 코드만)
     * @param ctgrCd
     * @return List<CmmnCdVO>
     * @throws Exception
     ******************************************************/
    private List<CmmnCdVO> getCodeList(String ctgrCd, UserContext userCtx) throws Exception {
        List<CmmnCdVO> list = cmmnCdService.listCode(getOrgId(userCtx), ctgrCd).getReturnList();
        if (list == null) {
            return new ArrayList<CmmnCdVO>();
        }

        list.removeIf(item -> item.getCdSeqno() != null && item.getCdSeqno() == 0);
        return list;
    }

    /*****************************************************
     * 목록/조회 경로 기관 ID 결정 (비관리자는 본인 기관 강제)
     * @param orgId
     * @param userCtx
     * @return String
     ******************************************************/
    private String resolveOrgId(String orgId, UserContext userCtx) {
        if (!isSysAdmin(userCtx)) {
            return getOrgId(userCtx);
        }
        return StringUtil.nvl(orgId);
    }

    /*****************************************************
     * 저장 경로 기관 ID 결정 (비관리자는 본인 기관 강제)
     * @param orgId
     * @param userCtx
     * @return String
     ******************************************************/
    private String resolveRequiredOrgId(String orgId, UserContext userCtx) {
        if (!isSysAdmin(userCtx)) {
            return getOrgId(userCtx);
        }
        return StringUtil.nvl(orgId);
    }

    /*****************************************************
     * 사용자 권한 기준 기관 목록 조회
     * @param userCtx
     * @return List<OrgInfoVO>
     * @throws Exception
     ******************************************************/
    private List<OrgInfoVO> getOrgList(UserContext userCtx) throws Exception {
        List<OrgInfoVO> orgList = orgInfoService.listActiveOrg();
        if (isSysAdmin(userCtx)) {
            return orgList;
        }
        return filterOrgList(orgList, getOrgId(userCtx));
    }

    /*****************************************************
     * 단일 기관 관리자용 기관 목록 필터링
     * @param orgList
     * @param orgId
     * @return List<OrgInfoVO>
     ******************************************************/
    private List<OrgInfoVO> filterOrgList(List<OrgInfoVO> orgList, String orgId) {
        List<OrgInfoVO> filteredList = new ArrayList<OrgInfoVO>();
        String value = StringUtil.nvl(orgId);
        if (value.isEmpty() || orgList == null) {
            return filteredList;
        }
        for (OrgInfoVO orgInfoVO : orgList) {
            if (orgInfoVO != null && value.equals(StringUtil.nvl(orgInfoVO.getOrgId()))) {
                filteredList.add(orgInfoVO);
            }
        }
        return filteredList;
    }

    /*****************************************************
     * 전체시스템관리자 여부 (권한코드 ADM)
     * @param userCtx
     * @return boolean
     ******************************************************/
    private boolean isSysAdmin(UserContext userCtx) {
        String authrtCd = userCtx != null ? StringUtil.nvl(userCtx.getAuthrtCd()) : "";
        return CommConst.AUTHRT_CD_ADM.equals(authrtCd);
    }

    /*****************************************************
     * 현재 사용자 ID 조회
     * @param userCtx
     * @return String
     ******************************************************/
    private String getUserId(UserContext userCtx) {
        return userCtx != null ? StringUtil.nvl(userCtx.getUserId()) : "";
    }

    /*****************************************************
     * 현재 기관 ID 조회
     * @param userCtx
     * @return String
     ******************************************************/
    private String getOrgId(UserContext userCtx) {
        return userCtx != null ? StringUtil.nvl(userCtx.getOrgId()) : "";
    }

    private boolean isBlank(String value) {
        return StringUtil.nvl(value).trim().length() == 0;
    }

    /*****************************************************
     * 발신자 번호 필수 여부 (쪽지 외 채널 선택 시 필수)
     * @param channels
     * @return boolean
     ******************************************************/
    private boolean needsSndngrPhn(String channels) {
        for (String ch : StringUtil.nvl(channels).split(",")) {
            if (!CommConst.MSG_CHNL_SHRTNT.equals(ch.trim()) && !ch.trim().isEmpty()) {
                return true;
            }
        }
        return false;
    }

    /*****************************************************
     * 문자 본문 byte 길이 계산 (SMS 작성화면과 동일: 비ASCII 2byte, 그 외 1byte)
     * @param str
     * @return int
     ******************************************************/
    private int smsByteLength(String str) {
        String s = StringUtil.nvl(str);
        int bytes = 0;
        for (int i = 0; i < s.length(); i++) {
            bytes += s.charAt(i) > 127 ? 2 : 1;
        }
        return bytes;
    }
}
