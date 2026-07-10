package knou.lms.login.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.framework.exception.LoginFailedException;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.login.dao.LoginDAO;
import knou.lms.login.param.LoginParam;
import knou.lms.login.service.LoginService;
import knou.lms.login.vo.LoginVO;
import knou.lms.login.vo.UserLgnHstryVO;
import knou.lms.subject.service.SubjectService;
import knou.lms.subject.vo.SubjectOrgDTO;
import knou.lms.user.service.UserService;
import knou.lms.user.vo.UserVO;

@Service("loginService")
public class LoginServiceImpl extends ServiceBase implements LoginService {

	private static final Logger log = LoggerFactory.getLogger(LoginServiceImpl.class);

    @Resource(name="loginDAO")
    private LoginDAO loginDAO;

    @Autowired
    private UserService userService;

    @Autowired
    private SubjectService subjectService;

    @Override
    @Deprecated
    public List<LoginVO> selectOrgList() throws Exception {
        return loginDAO.selectOrgList();
    }

    /**
     * 전체 로그인 프로세스를 관리합니다.
     */
    public UserContext processLogin(LoginParam param, UserLgnHstryVO userLgnHstryVO) throws Exception {

        // 1. 기본 검증 (ID존재, 비번일치, 유효사용자)
        // 로직 내부에서 실패 시 사용자 정의 Exception을 던지면 컨트롤러가 더 깔끔해집니다.
        validateUser(param);

        // 2. 기본 사용자 정보 로드
        UserVO loginUser = userService.userSelect(param.getUserId());

        // 1.1 로그인 성공이므로 로그인이력에 저장하고
        // => 이력에 기관, 학과/부서, 권한 추가를 위해 사용자 정보 로드 후 이력저장으로 변경
        userLgnHstryVO.setAcsrTycd(loginUser.getAuthrtCd());
        userLgnHstryVO.setOrgId(loginUser.getOrgId());
        userLgnHstryVO.setDeptId(loginUser.getDeptId());
        int insertCnt = userLatestLoginHstryInsert(userLgnHstryVO);

        if(insertCnt == 0)
            ; // throw new InsertFailException();

        return buildUserContext(loginUser);
    }

    /**
     * 사용자 정보(UserVO) 기준으로 UserContext를 구성한다. (정상 로그인/관리자 대리 로그인 공통)
     */
    @Override
    public UserContext buildUserContext(UserVO loginUser) throws Exception {
        UserContext userCtx = new UserContext();
        userCtx.setLoginUser(loginUser);

        if(!userCtx.isAdmin()) { // 관리자가 아닐 경우
            // 교수 운영과목, 학생 수강과목의 기관 목록 조회
            List<SubjectOrgDTO> sbjOrgList = new ArrayList<>();
            List<SubjectOrgDTO> userSubjectOrgList = subjectService.selectUserSubjectOrgList(userCtx.getUserId());

            if(userSubjectOrgList != null && !userSubjectOrgList.isEmpty()) {
                boolean checkOtherType = false;
                String prevUserTycd = null;

                for(SubjectOrgDTO orgDTO : userSubjectOrgList) {
                    String orgId = orgDTO.getOrgId();
                    String userTycd = orgDTO.getUserTycd();
                    String sbjctAdmTycd = orgDTO.getSbjctAdmTycd();

                    if("COPROF".equals(sbjctAdmTycd)) {
                        sbjctAdmTycd = "PROF";
                    }

                    if(!checkOtherType && prevUserTycd != null && !prevUserTycd.equals(userTycd)) {
                        checkOtherType = true;
                    }

                    prevUserTycd = userTycd;

                    SubjectOrgDTO dto = null;
                    boolean isDuplicate = sbjOrgList.stream().anyMatch(odto -> odto.getOrgId().equals(orgId));

                    if(isDuplicate) {
                        dto = sbjOrgList.stream().filter(odto -> orgId.equals(odto.getOrgId())).findFirst().orElse(null);

                        if (!dto.getOrgUserTycdList().contains(sbjctAdmTycd)) {
                        	dto.getOrgUserTycdList().add(sbjctAdmTycd);
                        }
                    } else {
                        dto = new SubjectOrgDTO();
                        dto.setOrgId(orgId);
                        dto.setOrgnm(orgDTO.getOrgnm());
                        dto.setUserTycd(userTycd);
                        dto.setUserId(orgDTO.getUserId());

                        List<String> orgUserTycdList = new ArrayList<>();
                        orgUserTycdList.add(sbjctAdmTycd);
                        dto.setOrgUserTycdList(orgUserTycdList);
                        sbjOrgList.add(dto);
                    }
                }

                if(!checkOtherType && sbjOrgList.size() > 1) {
                    SubjectOrgDTO orgDTO = new SubjectOrgDTO();
                    orgDTO.setOrgId("");
                    orgDTO.setOrgnm("ALL");
                    sbjOrgList.add(0, orgDTO);
                }
            } else {
                SubjectOrgDTO orgDTO = new SubjectOrgDTO();
                orgDTO.setOrgId("");
                orgDTO.setOrgnm("ALL");
                sbjOrgList.add(0, orgDTO);
            }

            // 교수 운영과목, 학생 수강과목의 학기 목록 조회
            List<SmstrChrtVO> userSmstrList = subjectService.selectUserSemesterList(userCtx.getUserId(), "ALL");

    		if (userSubjectOrgList != null &&userSubjectOrgList.size() > 1 && userSmstrList != null && userSmstrList.size() > 1) {
    			SmstrChrtVO smstrVO = new SmstrChrtVO();
    			smstrVO.setSmstrChrtId("");
    			smstrVO.setSmstrChrtnm("ALL");
    			smstrVO.setSmstrChrtnm("ALL");
    			smstrVO.setUserTycd("ALL");
    			userSmstrList.add(0, smstrVO);
    		}

            userCtx.setSmstrChrtList(userSmstrList);
            userCtx.setSubjectOrgList(sbjOrgList);
        }

        return userCtx;
    }

    private List<String> refineIds(List<String> ids, String defaultId) {
        if(ids == null || ids.isEmpty()) {
            List<String> newList = new ArrayList<>();
            newList.add(defaultId);
            return newList;
        }
        return ids;
    }

    private Map<String, UserVO> convertToMap(List<UserVO> list) {
        Map<String, UserVO> map = new HashMap<>();
        if(list != null) {
            for(UserVO vo : list) {
                if(vo != null) map.put(vo.getUserId(), vo);
            }
        }
        return map;
    }

    private boolean validateUser(LoginParam param) throws Exception {
        // if (!userService.existUserId(param)) throw new LoginFailedException();

        EgovMap result = userService.existUserIdWithPswd(param);

        if("USERID_NOT_EXIST".equals(result.get("loginResult"))) {
            throw new LoginFailedException("사용자 아이디가 존재하지 않습니다.");
        }

        if("WRONG_PSWD".equals(result.get("loginResult"))) {
            ; //throw new AccessDeniedException("아이디와 비밀번호가 일치하지 않습니다.");
        }

        return true;
    }

    @Override
    public EgovMap userLatestLoginHstrySelect(String userId) throws Exception {
        return loginDAO.userLatestLoginHstrySelect(userId);
    }

    @Override
    public int userLatestLoginHstryInsert(UserLgnHstryVO userLgnHstryVO) throws Exception {
        return loginDAO.userLatestLoginHstryInsert(userLgnHstryVO);
    }

    @Override
    public LoginVO authenticate(LoginVO param) throws Exception {

        if (param == null || isBlank(param.getUserId())) {
            throw new IllegalArgumentException("로그인 아이디가 비어 있습니다.");
        }

        final String userId = param.getUserId();

        // ── 1차: EP 조회 (TB_EPO_USER + TB_EPO_USER_TP) ──
        LoginVO epUser = loginDAO.selectEpUser(param);
        if (epUser != null) {
            log.info("[LOGIN] EP 사용자 조회 성공 - userId={}", userId);
            verifyPassword(param, epUser);          // 비밀번호 검증
            epUser.setUserSrcDvcd("EP");
            return epUser;
        }

        log.info("[LOGIN] EP 미존재 → LMS 조회 진행 - userId={}", userId);

        // ── 2차: LMS 조회 (TB_LMS_USER) ──
        LoginVO lmsUser = loginDAO.selectLmsUser(param);
        if (lmsUser != null) {
            log.info("[LOGIN] LMS 사용자 조회 성공 - userId={}", userId);
            verifyPassword(param, lmsUser);
            lmsUser.setUserSrcDvcd("LMS");
            return lmsUser;
        }

        // ── 둘 다 없음 → 실패 ──
        log.warn("[LOGIN] EP/LMS 모두 미존재 - userId={}", userId);
        throw new Exception("아이디 또는 비밀번호가 일치하지 않습니다.");
    }

    /**
     * 아이디 존재 여부만 EP → LMS 순으로 확인 (비밀번호 검증 안 함).
     * @return "EP" | "LMS" | null
     */
    @Override
    public String checkUserSource(LoginVO param) throws Exception {
        if (param == null || isBlank(param.getUserId())) {
            return null;
        }
        // 비밀번호는 채우지 않음 → 매퍼가 id 만으로 조회
        param.setUserIdEncpswd(null);

        if (loginDAO.selectEpUser(param) != null) {
            return "EP";
        }
        if (loginDAO.selectLmsUser(param) != null) {
            return "LMS";
        }
        return null;
    }

    /**
     * 비밀번호 검증.
     *
     * 주의: 실제 환경에 맞춰 교체하세요.
     *  - DB에 평문 저장이면 단순 equals
     *  - 단방향 해시(SHA-256 등) 저장이면 입력값을 같은 방식으로 해싱 후 비교
     *  - 양방향 암호화 저장이면 복호화 후 비교 또는 입력값 암호화 후 비교
     *
     * 가장 권장: DB 조회 SQL 자체에서 ID+PW 조건으로 필터링(아래 매퍼처럼)하여,
     *           조회 결과 존재 자체를 인증 성공으로 보는 방식. 그 경우 이 메서드는
     *           추가 안전장치(혹은 no-op)로만 둔다.
     */
    private void verifyPassword(LoginVO input, LoginVO found) throws Exception {
        // 매퍼에서 PW 조건까지 걸어 조회했다면 found != null 자체가 검증 통과이므로 통과 처리.
        // 별도 애플리케이션 레벨 검증이 필요하면 아래 주석을 해제/수정하세요.
        //
        // String encPw = encrypt(input.getUserIdEncpswd());
        // if (found.getUserIdEncpswd() == null || !found.getUserIdEncpswd().equals(encPw)) {
        //     throw new Exception("비밀번호가 일치하지 않습니다.");
        // }
        return;
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    // ================================================================
    // 패스키(FIDO) 인증 로그인
    //   mSABER REST API 직접 호출 (암호화 없음, x-www-form-urlencoded)
    //   API 문서: 2_FIDO_API_Document_v2_8_0_4.pdf §1(패스키 연동) p17~20
    // ================================================================

    private static final String MSABER_BASE      = "https://mauth.knou.ac.kr";
    // siteCode 출처: 2_FIDO_API_Document_v2_8_0_4.pdf p3 및 MSABER_API_Document_v2_8_0_006방통대.pdf p3
    //   → 공통: siteCode = KNOU, subsystem = 2(포털)
    // (문서 curl 예시의 sd=msaber 는 단순 샘플값이며 실제 값 아님)
    private static final String PASSKEY_SITE_CD  = "KNOU";

    private final RestTemplate passkeyRestTemplate = new RestTemplate();
    private final ObjectMapper passkeyObjectMapper = new ObjectMapper();

    @Override
    public Map<String, Object> requestPasskeyAuthOption(String userId) {
        MultiValueMap<String, String> form = new LinkedMultiValueMap<>();
        form.add("ud", userId);
        form.add("sd", PASSKEY_SITE_CD);
        return callMsaberPasskey("/passkey/restAPI/auth/option", form);
    }

    @Override
    public Map<String, Object> verifyPasskeyAuth(String token) {
        MultiValueMap<String, String> form = new LinkedMultiValueMap<>();
        form.add("tk", token);
        return callMsaberPasskey("/passkey/restAPI/auth/verify/ch", form);
    }

    /**
     * mSABER 패스키 REST API 공통 호출.
     * x-www-form-urlencoded POST, JSON 응답을 Map 으로 변환.
     */
    @SuppressWarnings("unchecked")
    private Map<String, Object> callMsaberPasskey(String path, MultiValueMap<String, String> form) {
        String url = MSABER_BASE + path;

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(form, headers);

        try {
            ResponseEntity<String> response = passkeyRestTemplate.postForEntity(url, entity, String.class);
            log.info("[Passkey] {} status={} body={}", path, response.getStatusCode(), response.getBody());

            JsonNode node = passkeyObjectMapper.readTree(response.getBody());
            return passkeyObjectMapper.convertValue(node, Map.class);

        } catch (org.springframework.web.client.HttpStatusCodeException he) {
            log.warn("[Passkey] {} ERROR status={} body={}", path, he.getStatusCode(), he.getResponseBodyAsString());
            Map<String, Object> err = new HashMap<>();
            err.put("result", -999);
            err.put("msg", "mSABER " + he.getStatusCode() + " 응답");
            return err;

        } catch (Exception e) {
            log.error("[Passkey] " + path + " 호출 실패", e);
            Map<String, Object> err = new HashMap<>();
            err.put("result", -999);
            err.put("msg", e.getMessage());
            return err;
        }
    }

    // ================================================================
    // 모바일 인증(생체/QR) 로그인 — mSABER /module/v2/* 연동
    //   API 문서: MSABER_API_Document_v2_8_0_006방통대.pdf p3~6
    //   ※ option(challenge 발급)은 기존 LoginController.issueChallenge() 가 처리.
    //     여기서는 auth(푸시발송)/result(결과조회)만 다룬다.
    // ================================================================

    @Override
    public Map<String, Object> requestMobileAuth(String challenge) {
        // C. 로그인 인증 요청 — challenge 하나만 그대로 전달 (문서 예시: ?challenge=세션토큰)
        MultiValueMap<String, String> form = new LinkedMultiValueMap<>();
        form.add("challenge", challenge);
        return callMsaberMobile("/module/v2/auth", form);
    }

    @Override
    public Map<String, Object> checkMobileAuthResult(String challenge) {
        MultiValueMap<String, String> form = new LinkedMultiValueMap<>();
        form.add("challenge", challenge);

        Map<String, Object> raw = callMsaberMobile("/module/v2/result", form);

        Map<String, Object> out = new HashMap<>();
        Object resultObj = raw.get("result");

        // ⚠ 문서(p5 "D. 로그인 인증 승인 결과 조회"): 반환값 "result" 는 암호화된 문자열.
        //   복호화 방식은 "별도 제공" 이라고만 명시되어 있고, 현재 프로젝트에서
        //   knou.framework.util.AESCryptor 에 대응되는 복호화 메서드(decryptForMsaber 등)를
        //   확인하지 못했다. 벤더로부터 결과값 복호화 방법을 받는 즉시 아래 TODO 를 채울 것.
        //
        //   참고: 벤더 샘플(common.encrypt.AESCryptor, 프로젝트 내 AESCryptor.java)에는
        //   decryptAES128(key, encryptedText) 가 존재하므로, 동일 방식이라면
        //   AESCryptor.decryptAES128(ConstantSecureKeys.passphrase, (String) resultObj) 형태가 될 가능성이 있음.
        //
        // TODO: 복호화 적용 필요
        // String decrypted = AESCryptor.decryptForMsaber((String) resultObj);
        // out.put("status", Integer.parseInt(decrypted));

        out.put("rawResult", resultObj);     // 복호화 전 원본값 (임시)
        out.put("description", raw.get("description"));
        log.warn("[MobileAuth] result 복호화 미구현 - 벤더 제공 복호화 방식 확인 필요. raw={}", raw);

        return out;
    }

    /**
     * mSABER 생체인증(WEB(CS) TO APP) REST API 공통 호출.
     * x-www-form-urlencoded POST, JSON 응답을 Map 으로 변환.
     */
    @SuppressWarnings("unchecked")
    private Map<String, Object> callMsaberMobile(String path, MultiValueMap<String, String> form) {
        // 출처: MSABER_API_Document_v2_8_0_006방통대.pdf p3 "API URL https://{도메인}:21443/..."
        String url = "https://mauth.knou.ac.kr:21443" + path;

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(form, headers);

        try {
            ResponseEntity<String> response = passkeyRestTemplate.postForEntity(url, entity, String.class);
            log.info("[MobileAuth] {} status={} body={}", path, response.getStatusCode(), response.getBody());

            JsonNode node = passkeyObjectMapper.readTree(response.getBody());
            return passkeyObjectMapper.convertValue(node, Map.class);

        } catch (org.springframework.web.client.HttpStatusCodeException he) {
            log.warn("[MobileAuth] {} ERROR status={} body={}", path, he.getStatusCode(), he.getResponseBodyAsString());
            Map<String, Object> err = new HashMap<>();
            err.put("result", -999);
            err.put("description", "mSABER " + he.getStatusCode() + " 응답");
            return err;

        } catch (Exception e) {
            log.error("[MobileAuth] " + path + " 호출 실패", e);
            Map<String, Object> err = new HashMap<>();
            err.put("result", -999);
            err.put("description", e.getMessage());
            return err;
        }
    }
}