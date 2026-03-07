package knou.lms.user.service.impl;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;

import org.imgscalr.Scalr;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataRetrievalFailureException;
import org.springframework.stereotype.Service;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.common.CommConst;
import knou.framework.common.MainOrgInfo;
import knou.framework.common.ServiceBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.ServiceProcessException;
import knou.framework.util.CommonBeanUtils;
import knou.framework.util.CryptoUtil;
import knou.framework.util.JsonUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.OrgAuthGrpVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.org.service.OrgCodeService;
import knou.lms.org.vo.OrgCodeVO;
import knou.lms.user.dao.UsrDeptCdDAO;
import knou.lms.user.dao.UsrLoginDAO;
import knou.lms.user.dao.UsrUserAuthGrpDAO;
import knou.lms.user.dao.UsrUserInfoChgHstyDAO;
import knou.lms.user.dao.UsrUserInfoDAO;
import knou.lms.user.service.UsrUserInfoService;
import knou.lms.user.vo.UsrDeptCdVO;
import knou.lms.user.vo.UsrLoginVO;
import knou.lms.user.vo.UsrUserAuthGrpVO;
import knou.lms.user.vo.UsrUserInfoChgHstyVO;
import knou.lms.user.vo.UsrUserInfoVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

@Service("usrUserInfoService")
public class UsrUserInfoServiceImpl extends ServiceBase implements UsrUserInfoService {

    @Resource(name="usrUserInfoDAO")
    private UsrUserInfoDAO usrUserInfoDAO;
    
    @Resource(name="usrLoginDAO")
    private UsrLoginDAO usrLoginDAO;
    
    @Resource(name="usrUserAuthGrpDAO")
    private UsrUserAuthGrpDAO usrUserAuthGrpDAO;
    
    @Resource(name="usrUserInfoChgHstyDAO")
    private UsrUserInfoChgHstyDAO usrUserInfoChgHstyDAO;
    
    @Resource(name="usrDeptCdDAO")
    private UsrDeptCdDAO usrDeptCdDAO;
    
    @Autowired
    private SysFileService sysFileService;
    
    @Autowired
    private OrgCodeService orgCodeService;
    
    @Override
    public UsrUserInfoVO viewForLogin(UsrUserInfoVO vo) throws Exception {
        //SNS로그인
        /*if(ValidationUtils.isNotEmpty(vo.getSnsKey()) && ValidationUtils.isNotEmpty(vo.getSnsDiv())){
            UsrUserInfoVO uuivo  = usrUserInfoDAO.selectForLogin(vo);
            if(ValidationUtils.isNotEmpty(uuivo)) {
                vo = uuivo;
            } else {
                //SNS로그인이면 통합로그인을 한번더 조회
                if(ValidationUtils.isNotEmpty(vo.getSnsKey()) && ValidationUtils.isNotEmpty(vo.getSnsDiv())){
                    vo.setItgrtMbrUseYn("Y");
                    uuivo = usrUserInfoDAO.selectForLogin(vo);
                    
                    if(ValidationUtils.isNotEmpty(uuivo)) {
                        vo = uuivo;
                    }else{
                        throw new DataRetrievalFailureException("Database Error!, There is no returned data.");
                    }
                }else{
                    throw new DataRetrievalFailureException("Database Error!, There is no returned data.");
                }
            }
            
            //sns 사용자는 패스워드가 없으므로 로직을 통과하기위해 강제로 같게 만듬
            vo.setUserIdEncpswd("0");
            vo.setEncUserPass("0");
        } else {
            UsrUserInfoVO uuivo  = usrUserInfoDAO.selectForLogin(vo);
            if(ValidationUtils.isNotEmpty(uuivo)) {
                String encUserPass = "";
                String encTmpPass = "";
                
                if(!StringUtil.nvl(vo.getUserIdEncpswd()).isEmpty()) {
                    encUserPass = CryptoUtil.encryptSha(vo.getUserIdEncpswd());
                }
                
                if(!StringUtil.nvl(vo.getTmpPswd()).isEmpty()) {
                    encTmpPass = CryptoUtil.encryptSha(vo.getTmpPswd());
                }
                
                uuivo.setEncUserPass(encUserPass);
                uuivo.setEncTmpPass(encTmpPass);
                vo = uuivo;
            }else{
                throw new DataRetrievalFailureException("Database Error!, There is no returned data.");
            }
        }

        // 사진파일 설정
        if (vo.getPhtFileByte() != null && vo.getPhtFileByte().length > 0) {
            vo.setPhotoFileId("data:image/png;base64," + new String(Base64.getEncoder().encode(vo.getPhtFileByte())));
        }
*/
        this.getAuthGrp(vo);


        return vo;
    }
    
    /**
     * 사용자 정보를 가져온다. 로그인시에 사용
     * - 사용자 상태가 U인 사용자만 가져온다.
     * - 입력한 패스워드를 암호화 하여 리턴한다.
     * @param UsrUserInfoVO vo
     * @return  ProcessResultDTO
     */
    @Override
    public UsrUserInfoVO viewForLoginCheck(UsrUserInfoVO vo) throws Exception {
        //SNS로그인
        if(ValidationUtils.isNotEmpty(vo.getSnsKey()) && ValidationUtils.isNotEmpty(vo.getSnsDiv())){
            UsrUserInfoVO uuivo  = usrUserInfoDAO.selectForLoginCheck(vo);
            if(ValidationUtils.isNotEmpty(uuivo)) {
                vo = uuivo;
            } else {
                //SNS로그인이면 통합로그인을 한번더 조회
                if(ValidationUtils.isNotEmpty(vo.getSnsKey()) && ValidationUtils.isNotEmpty(vo.getSnsDiv())){
                    vo.setItgrtMbrUseYn("Y");
                    uuivo = usrUserInfoDAO.selectForLoginCheck(vo);
                    
                    if(ValidationUtils.isNotEmpty(uuivo)) {
                        vo = uuivo;
                    }else{
                        throw new DataRetrievalFailureException("Database Error!, There is no returned data.");
                    }
                }else{
                    throw new DataRetrievalFailureException("Database Error!, There is no returned data.");
                }
            }
            
            //sns 사용자는 패스워드가 없으므로 로직을 통과하기위해 강제로 같게 만듬
            vo.setUserIdEncpswd("0");
            vo.setEncUserPass("0");
        }else{
            UsrUserInfoVO uuivo  = usrUserInfoDAO.selectForLoginCheck(vo);
            if(ValidationUtils.isNotEmpty(uuivo)) {
                String encUserPass = "";
                String encTmpPass = "";
                if(StringUtil.nvl(vo.getUserIdEncpswd()).isEmpty()==false)
                    encUserPass = CryptoUtil.encryptSha(vo.getEncUserId());
                if(StringUtil.nvl(vo.getTmpPswd()).isEmpty()==false)
                    encTmpPass = CryptoUtil.encryptSha(vo.getTmpPswd());
                uuivo.setEncUserPass(encUserPass);
                uuivo.setEncTmpPass(encTmpPass);
                vo = uuivo;
            }else{
                throw new DataRetrievalFailureException("Database Error!, There is no returned data.");
            }
        }
        this.getAuthGrp(vo);
        return vo;
    }
    
    private void getAuthGrp(UsrUserInfoVO vo) throws Exception {
        UsrUserAuthGrpVO uuavo = new UsrUserAuthGrpVO();
		/*
		 * uuavo.setOrgId(vo.getOrgId()); 
		 * uuavo.setUserId(vo.getUserId());
		 */
        
        /*
        uuavo.setOrgId(vo.getOrgId());
        uuavo.setUserId(vo.getUserId());

        List<UsrUserAuthGrpVO> authGrpList = usrUserAuthGrpDAO.selectUserAuthList(uuavo);
        String authrtGrpCd = "";	// 권한 그룹 코드
        String authrtCd = "";		// 권한 코드
        
        for(int i=0; i < authGrpList.size(); i++) {
            UsrUserAuthGrpVO iuagvo = authGrpList.get(i);
            authrtGrpCd = authrtGrpCd+"|"+iuagvo.getAuthrtGrpcd();
            authrtCd = authrtCd+"|"+iuagvo.getAuthrtCd();
        }
        
        if(authrtGrpCd.indexOf("ADM") > -1) {
            vo.setAdminAuthYn("Y");
        } else {
            vo.setAdminAuthYn("N");
        }

        vo.setAuthrtGrpcd(authrtGrpCd);
        vo.setAuthrtCd(authrtCd);
        */

        // TODO : Test Code by hybellj.
        uuavo.setOrgId("ORG0000001");
        uuavo.setUserId("prof1");
        vo.setAuthrtGrpcd("PROF");
        vo.setAuthrtCd("PROF");

//        vo.setWwwAuthrtCd(authrtCd);
    }

    /**
     * 사용자 페이징 목록
     * @param UsrUserInfoVO vo
     * @return  ProcessResultVO<UsrUserInfoVO>
     */
    @Override
    public ProcessResultVO<UsrUserInfoVO> listPaging(UsrUserInfoVO vo) throws Exception {

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        int totalCount = usrUserInfoDAO.totalCount(vo);
        paginationInfo.setTotalRecordCount(totalCount);

        List<UsrUserInfoVO> userList = usrUserInfoDAO.listPaging(vo);

        ProcessResultVO<UsrUserInfoVO> resultVO = new ProcessResultVO<UsrUserInfoVO>();

        resultVO.setReturnList(userList);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    /**
     * 사용자 정보를 가져온다.
     * 사용자 상태가 U인 사용자만 가져온다.
     * 입력한 패스워드를 암호화 하여 리턴한다.
     * @param UsrUserInfoVO vo
     * @return  UsrUserInfoVO
     */
    @Override
    public UsrUserInfoVO viewUser(UsrUserInfoVO vo) throws Exception {
        UsrUserInfoVO uuivo  = usrUserInfoDAO.select(vo);
        if(ValidationUtils.isNotEmpty(uuivo)) {
            vo = uuivo;
        }else{
            throw new DataRetrievalFailureException("Database Error!, There is no returned data.");
        }
        
        // 사진파일이 있으면 변환
        if (uuivo.getPhtFileByte() != null && uuivo.getPhtFileByte().length > 0) {
            uuivo.setPhotoFileId("data:image/png;base64," + new String(Base64.getEncoder().encode(uuivo.getPhtFileByte())));
        }
        this.getAuthGrp(vo);

        return vo;
    }

    /**
     * 사용자 엑셀업로드 할떄 등록가능한 권한 목록
     * @param OrgAuthGrpVO
     * @return  List<OrgAuthGrpVO>
     */
    @Override
    public List<OrgAuthGrpVO> listExcelUploadAuthGrp(OrgAuthGrpVO vo) throws Exception {
        return usrUserInfoDAO.listExcelUploadAuthGrp(vo);
    }

    /**
     * 사용자 정보 엑셀 업로드
     * @param UsrUserInfoVO
     * @return  void
     */
    @Override
    public void userExcelUpload(HttpServletRequest request, UsrUserInfoVO vo, List<Map<String, Object>> list) throws Exception {
        boolean isKnou = SessionInfo.isKnou(request);
        
        UsrUserInfoVO usrUserInfoVO;
        int line = 4;  // 샘플 엑셀파일 row 시작위치
        String errPrefix;
        
        String regexPass1   = "^(?=.*[A-Za-z])(?=.*[0-9])[A-Za-z[0-9]$@$!%*#?&]{8,16}$";        // 영문 + 숫자
        String regexPass2   = "^(?=.*[A-Za-z])(?=.*[$@$!%*#?&])[A-Za-z[0-9]$@$!%*#?&]{8,16}$";  // 영문 + 특수문자
        String regexPass3   = "^(?=.*[0-9])(?=.*[$@$!%*#?&])[A-Za-z[0-9]$@$!%*#?&]{8,16}$";     // 숫자 + 특수문자
        String regexMail    = "^[_a-z0-9-]+(.[_a-z0-9-]+)*@(?:\\w+\\.)+\\w+$";                  // 이메일 유효성 체크
        
        String userId;      // 아이디
        String userPass;    // 비밀번호
        String userNm;      // 이름
        String authGrpCdNm; // 사용자구분
        String deptCdNm;    // 학과
        //String userGradeNm; // 학년
        String mobileNo;    // 전화번호
        String email;       // 이메일
        
        // 사용자구분
        OrgAuthGrpVO orgAuthGrpVO = new OrgAuthGrpVO();
        orgAuthGrpVO.setOrgId(vo.getOrgId());
        List<OrgAuthGrpVO> authGrpList = usrUserInfoDAO.listExcelUploadAuthGrp(orgAuthGrpVO);
        Map<String, Object> userTypeMap = new HashMap<>();
        Set<String> adminSet = new HashSet<>();
        Set<String> professorSet = new HashSet<>();
        Set<String> studentSet = new HashSet<>();
        
        for(OrgAuthGrpVO item : authGrpList) {
            if("ADM".equals(item.getAuthrtGrpcd())) adminSet.add(item.getAuthrtGrpnm());
            if("PROF".equals(item.getAuthrtGrpcd())) professorSet.add(item.getAuthrtGrpnm());
            if("USR".equals(item.getAuthrtGrpcd())) studentSet.add(item.getAuthrtGrpnm());
            userTypeMap.put(item.getAuthrtGrpnm(), item.getAuthrtCd());
        }
        
        // 학과
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(vo.getOrgId());
        List<UsrDeptCdVO> deptCdList = usrDeptCdDAO.list(usrDeptCdVO);
        Map<String, Object> deptCdMap = new HashMap<>();
        for(UsrDeptCdVO item : deptCdList) {
            deptCdMap.put(item.getDeptnm(), item.getDeptId());
        }
        
        // 학년
        /*
        List<OrgCodeVO> userGradeList = orgCodeService.selectOrgCodeList("USER_GRADE");
        Map<String, Object> userGradeMap = new HashMap<>();
        for(OrgCodeVO item : userGradeList) {
            userGradeMap.put(item.getCodeNm(), item.getCodeCd());
        }
        */
        
        // 엑셀 데이터 저장
        for(Map<String, Object> map : list) {
            errPrefix = line + "번 행의 ";
            
            usrUserInfoVO = new UsrUserInfoVO();
            usrUserInfoVO.setOrgId(vo.getOrgId());
            usrUserInfoVO.setRgtrId(vo.getRgtrId());
            usrUserInfoVO.setMdfrId(vo.getMdfrId());
            
            userId      = (String) map.get("A");    // 필수, 중복체크
            userPass    = (String) map.get("B");    // 필수, 패턴체크
            userNm      = (String) map.get("C");    // 필수
            authGrpCdNm = (String) map.get("D");    // 필수, 코드명으로 유효한 코드인지 검증
            deptCdNm    = (String) map.get("E");    // 필수, 코드명으로 유효한 코드인지 검증
            //userGradeNm = (String) map.get("F");    // 코드명으로 유효한 코드인지 검증
            mobileNo    = (String) map.get("F");    // 필수
            email       = (String) map.get("G");    // 필수, 패턴체크
            
            // 공백 체크
            Map<String, Object> emptyCheckMap = new HashMap<String, Object>();
            emptyCheckMap.put("아이디",    userId);
            emptyCheckMap.put("비밀번호",   userPass);
            emptyCheckMap.put("이름",     userNm);
            emptyCheckMap.put("구분",     authGrpCdNm);
            if(isKnou) {
                emptyCheckMap.put("학과명",    deptCdNm);
                emptyCheckMap.put("전화번호",   mobileNo);
                emptyCheckMap.put("이메일",    email);
            }
           
            for(Map.Entry<String, Object> elem : emptyCheckMap.entrySet()) {
                if("".equals(StringUtil.nvl(elem.getValue()))) {
                    throw new ServiceProcessException(errPrefix + "'" + elem.getKey() + "' (은)는 필수입력항목입니다.");
                }
            }
            
            // 아이디 중복체크
            UsrLoginVO usrLoginVO = new UsrLoginVO();
            usrLoginVO.setUserId(userId);
            String result = usrLoginDAO.selectIdCheck(usrLoginVO);
            if("N".equals(StringUtil.nvl(result))) {
                throw new ServiceProcessException(errPrefix + "'" + userId + "' 이미 사용중인 아이디입니다. 다른 아이디를 입력해주세요.");
            }
            
            if(isKnou) {
                // 비밀번호 패턴 체크
                if(!(userPass.matches(regexPass1) || userPass.matches(regexPass2) || userPass.matches(regexPass3))) {
                    throw new ServiceProcessException(errPrefix + "비밀번호가 조건에 맞지 않습니다.");
                }
                
                // 이메일 형식 체크
                if(!email.matches(regexMail)) {
                    throw new ServiceProcessException(errPrefix + "이메일 형식이 잘못되었습니다.");
                }
                
                // 학과 체크 (엑셀에서 입력한 코드명이 부서코드명과 일치하는 경우만 등록)
                if(deptCdMap.containsKey(deptCdNm)) {
                    usrUserInfoVO.setDeptCd((String) deptCdMap.get(deptCdNm));
                } else {
                    throw new ServiceProcessException(errPrefix + "학과가 올바르지 않습니다.");
                }
            } else {
                if(ValidationUtils.isEmpty(userPass) || userPass.length() != 6) {
                    if(userPass.length() != 6) {
                        throw new ServiceProcessException(errPrefix + "생년월일이 조건에 맞지 않습니다. [" + userPass + "]");
                    } else {
                        throw new ServiceProcessException(errPrefix + "생년월일을 입력하세요.");
                    }
                }
            }
            
            // 사용자구분 체크
            String [] authGrpNmList = authGrpCdNm.split(",");
            StringBuilder wwwAuthGrpCdSb = new StringBuilder();
            StringBuilder profAuthGrpCdSb = new StringBuilder();
            StringBuilder mngAuthGrpCdSb = new StringBuilder();
            
            if(authGrpCdNm.contains("교수") && (authGrpCdNm.contains("조교") || authGrpCdNm.contains("학생"))) {
                throw new ServiceProcessException(errPrefix + "교수, 조교, 학생은동시 적용 불가능합니다.");
            }
            
            int adminCnt = 0;
            int stdCnt = 0;
            for(int i = 0; i < authGrpNmList.length; i++) {
                String authGrpNm = authGrpNmList[i];
                
                // 엑셀에서 입력한 코드명이 시스템 코드명과 일치하는 경우만 권한 등록
                if(userTypeMap.containsKey(authGrpNm)) {
                    if(adminSet.contains(authGrpNm)) {
                        mngAuthGrpCdSb.append("/" + userTypeMap.get(authGrpNm));
                        adminCnt++;
                    }
                    if(professorSet.contains(authGrpNm)) {
                        profAuthGrpCdSb.append("/" + userTypeMap.get(authGrpNm));
                    }
                    if(studentSet.contains(authGrpNm)) {
                        wwwAuthGrpCdSb.append("/" + userTypeMap.get(authGrpNm));
                        usrUserInfoVO.setSchregGbnCd("01");
                        usrUserInfoVO.setSchregGbn("재학");
                        stdCnt++;
                    }
                } else {
                    throw new ServiceProcessException(errPrefix + "구분이 올바르지 않습니다.");
                }
            }
            
            if(adminCnt > 1) {
                throw new ServiceProcessException(errPrefix + "관리자 구분은 하나만 입력 가능합니다.");
            }
            
            if(stdCnt > 0 && adminCnt > 0) {
                throw new ServiceProcessException(errPrefix + "학생은 관리자 구분과 동시 적용 불가능합니다.");
            }
           
            usrUserInfoVO.setWwwAuthrtCd(wwwAuthGrpCdSb.toString());
            usrUserInfoVO.setProfAuthGrpCd(profAuthGrpCdSb.toString());
            usrUserInfoVO.setMngAuthGrpCd(mngAuthGrpCdSb.toString());
                      
            usrUserInfoVO.setUserId(userId);
            if(isKnou) {
                usrUserInfoVO.setUserIdEncpswd(userPass);
            } else {
                usrUserInfoVO.setUserIdEncpswd(userPass + "knou!!");
            }
            usrUserInfoVO.setUserNm(userNm);
            usrUserInfoVO.setMobileNo(mobileNo);
            usrUserInfoVO.setEmail(email);
            
            this.addUserInfo(usrUserInfoVO, "AI");
            
            line++;
        }
    }

    /**
     * 사용자 정보 등록
     * @param UsrUserInfoVO
     * @return  ProcessResultVO<UsrUserInfoVO>
     */
    @Override
    public ProcessResultVO<UsrUserInfoVO> addUserInfo(UsrUserInfoVO vo, String userInfoChgDivCd) throws Exception {
        ProcessResultVO<UsrUserInfoVO> resultVO = new ProcessResultVO<UsrUserInfoVO>();
        try {
            vo.setUserId(StringUtil.nvl(vo.getUserId()));
            if ("".equals(StringUtil.nvl(vo.getUserConf()))){
            	String lang = MainOrgInfo.getOrgLang(vo.getOrgId());
            	vo.setUserConf("{\"lang\":\""+lang+"\"}");
            }
            usrUserInfoDAO.insert(vo);
            
            if(ValidationUtils.isEmpty(vo.getRgtrId())) vo.setRgtrId(vo.getUserId());
            if(ValidationUtils.isEmpty(vo.getMdfrId())) vo.setMdfrId(vo.getUserId());
            UsrLoginVO loginVO = new UsrLoginVO();
            loginVO.setUserId(vo.getUserId());
            loginVO.setUserId(vo.getUserId());
            loginVO.setUserIdEncpswd(CryptoUtil.encryptSha(vo.getUserIdEncpswd()));
            loginVO.setAdminLoginAcptDivCd("ACNT");
            loginVO.setUserSts("U");
            loginVO.setRgtrId(vo.getRgtrId());
            loginVO.setMdfrId(vo.getMdfrId());
            usrLoginDAO.insert(loginVO);
            
            if(!"".equals(StringUtil.nvl(vo.getWwwAuthrtCd(),""))) {
                String[] wwwAuth = StringUtil.split(vo.getWwwAuthrtCd(),"/");
                for(int i=1; i < wwwAuth.length; i++) {
                    UsrUserAuthGrpVO uagDTO = new UsrUserAuthGrpVO();
                    uagDTO.setAuthrtGrpcd("USR");
                    uagDTO.setAuthrtCd(wwwAuth[i]);
                    uagDTO.setUserId(vo.getUserId());
                    uagDTO.setRgtrId(vo.getRgtrId());
                    uagDTO.setMdfrId(vo.getMdfrId());
                    uagDTO.setAtfl_maxsz(1024);
                    usrUserAuthGrpDAO.insert(uagDTO);
                }
            }
            
            if(!"".equals(StringUtil.nvl(vo.getProfAuthGrpCd(),""))) {
                String[] admAuth = StringUtil.split(vo.getProfAuthGrpCd(),"/");
                for(int i=1; i < admAuth.length; i++) {
                    UsrUserAuthGrpVO uagDTO = new UsrUserAuthGrpVO();
                    uagDTO.setAuthrtGrpcd("PROF");
                    uagDTO.setAuthrtCd(admAuth[i]);
                    uagDTO.setUserId(vo.getUserId());
                    uagDTO.setRgtrId(vo.getRgtrId());
                    uagDTO.setMdfrId(vo.getMdfrId());
                    uagDTO.setAtfl_maxsz(1024);
                    usrUserAuthGrpDAO.insert(uagDTO);
                }
            }
            
            if(!"".equals(StringUtil.nvl(vo.getMngAuthGrpCd(),""))) {
                String[] mngAuth = StringUtil.split(vo.getMngAuthGrpCd(),"/");
                for(int i=1; i < mngAuth.length; i++) {
                    UsrUserAuthGrpVO uagDTO = new UsrUserAuthGrpVO();
                    uagDTO.setAuthrtGrpcd("ADM");
                    uagDTO.setAuthrtCd(mngAuth[i]);
                    uagDTO.setUserId(vo.getUserId());
                    uagDTO.setRgtrId(vo.getRgtrId());
                    uagDTO.setMdfrId(vo.getMdfrId());
                    uagDTO.setAtfl_maxsz(1024);
                    usrUserAuthGrpDAO.insert(uagDTO);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setMessage("사용자 정보 등록 중 에러가 발생하였습니다.");
            resultVO.setResult(-1);
            return resultVO;
        }
        
        UsrUserInfoChgHstyVO uuichv = new UsrUserInfoChgHstyVO();
        uuichv.setUserId(vo.getUserId());
        uuichv.setRgtrId(vo.getRgtrId());
        uuichv.setUserInfoChgDivCd(userInfoChgDivCd); //-- 관리자가 등록
        uuichv.setUserInfoCts(JsonUtil.getJsonString(vo));
        usrUserInfoChgHstyDAO.insert(uuichv);
        
        resultVO.setReturnVO(vo);
        resultVO.setResult(1);
        return resultVO;
    }
    
    /**
     * 사용자 정보 수정
     * @param UsrUserInfoVO
     * @return  ProcessResultVO<UsrUserInfoVO>
     */
    @Override
    public ProcessResultVO<UsrUserInfoVO> editUserInfo(UsrUserInfoVO vo, String userInfoChgDivCd, String connIp)
            throws Exception {
        ProcessResultVO<UsrUserInfoVO> resultVO = new ProcessResultVO<UsrUserInfoVO>();
        UsrUserInfoVO beforeUuiVO = usrUserInfoDAO.selectForCompare(vo);
        this.getAuthGrp(beforeUuiVO);
        try {
            usrUserInfoDAO.update(vo);
            
            if(ValidationUtils.isEmpty(vo.getRgtrId())) vo.setRgtrId(vo.getUserId());
            if(ValidationUtils.isEmpty(vo.getMdfrId())) vo.setMdfrId(vo.getUserId());
            
            if("AE".equals(userInfoChgDivCd) && !"SIMPLE".equals(StringUtil.nvl(vo.getSubParam()))) {
                UsrUserAuthGrpVO uuagVo = new UsrUserAuthGrpVO();
                uuagVo.setUserId(vo.getUserId());
                usrUserAuthGrpDAO.deleteAllUser(uuagVo);
                
                if(!"".equals(StringUtil.nvl(vo.getWwwAuthrtCd(),""))) {
                    String[] wwwAuth = StringUtil.split(vo.getWwwAuthrtCd(),"/");
                    for(int i=1; i < wwwAuth.length; i++) {
                        UsrUserAuthGrpVO uagDTO = new UsrUserAuthGrpVO();
                        uagDTO.setAuthrtGrpcd("USR");
                        uagDTO.setAuthrtCd(wwwAuth[i]);
                        uagDTO.setUserId(vo.getUserId());
                        uagDTO.setRgtrId(vo.getRgtrId());
                        uagDTO.setMdfrId(vo.getMdfrId());
                        usrUserAuthGrpDAO.insert(uagDTO);
                    }
                }
                
                if(!"".equals(StringUtil.nvl(vo.getProfAuthGrpCd(),""))) {
                    String[] admAuth = StringUtil.split(vo.getProfAuthGrpCd(),"/");
                    for(int i=1; i < admAuth.length; i++) {
                        UsrUserAuthGrpVO uagDTO = new UsrUserAuthGrpVO();
                        uagDTO.setAuthrtGrpcd("PROF");
                        uagDTO.setAuthrtCd(admAuth[i]);
                        uagDTO.setUserId(vo.getUserId());
                        uagDTO.setRgtrId(vo.getRgtrId());
                        uagDTO.setMdfrId(vo.getMdfrId());
                        usrUserAuthGrpDAO.insert(uagDTO);
                    }
                }
                
                if(!"".equals(StringUtil.nvl(vo.getMngAuthGrpCd(),""))) {
                    String[] mngAuth = StringUtil.split(vo.getMngAuthGrpCd(),"/");
                    for(int i=1; i < mngAuth.length; i++) {
                        UsrUserAuthGrpVO uagDTO = new UsrUserAuthGrpVO();
                        uagDTO.setAuthrtGrpcd("ADM");
                        uagDTO.setAuthrtCd(mngAuth[i]);
                        uagDTO.setUserId(vo.getUserId());
                        uagDTO.setRgtrId(vo.getRgtrId());
                        uagDTO.setMdfrId(vo.getMdfrId());
                        usrUserAuthGrpDAO.insert(uagDTO);
                    }
                }
            } else if("UE".equals(userInfoChgDivCd)) {
                UsrUserInfoVO uuivo = new UsrUserInfoVO();
                uuivo.setUserId(vo.getUserId());
                uuivo.setUserNm(vo.getUserNm());
                
                String uploadFiles = StringUtil.nvl(vo.getUploadFiles());
                String uploadPath = StringUtil.nvl(vo.getUploadPath());
                
                // 사진파일을 올렸을 경우 변환
                if (!"".equals(uploadFiles)) {
                    uploadFiles = StringUtil.nvl(uploadFiles.replaceAll("\\\\", ""));
                    JSONArray fileArray = (JSONArray) JSONSerializer.toJSON(uploadFiles);
                    if (fileArray.size() > 0) {
                        JSONObject fileObj = (JSONObject) fileArray.get(0);
                        FileInputStream inputStream = null;
                        try {
                            String fExt = StringUtil.getExtNoneDot(fileObj.getString("fileNm")).toLowerCase();
                            File phtFile = new File(CommConst.WEBDATA_PATH + uploadPath + "/" + fileObj.getString("fileId") + "." + fExt);
                            
                            BufferedImage im = null;
                            try {
                                im = ImageIO.read(phtFile);
                            } catch(IOException e) {
                                //log.error("get error");
                            }
                            
                            // 사진 이미지를 썸네일 이미지로 변경
                            if(im != null) {
                                int width = 156;
                                int height = 156;
                                if (im.getWidth() < width) {
                                    width = im.getWidth();
                                }
                                if (im.getHeight() < height) {
                                    height = im.getHeight();
                                }
                                
                                BufferedImage thumbImg = Scalr.resize(im, Scalr.Method.AUTOMATIC, Scalr.Mode.FIT_TO_WIDTH, width);
                                if (thumbImg.getHeight() > height) {
                                    thumbImg = Scalr.resize(im, Scalr.Method.AUTOMATIC, Scalr.Mode.FIT_TO_HEIGHT, height);
                                }
                                
                                ByteArrayOutputStream os = new ByteArrayOutputStream();
                                if(fExt.endsWith("png")) {
                                    ImageIO.write(thumbImg, "PNG", os);
                                } else if(fExt.endsWith("jpeg") || fExt.endsWith("jpg")) {
                                    ImageIO.write(thumbImg, "JPG", os);
                                } else {
                                    ImageIO.write(thumbImg, "GIF", os);
                                }
                                
                                uuivo.setPhtFileByte(os.toByteArray());
                            }
                            else {
                                byte[] phtFileByte = new byte[(int) phtFile.length()];
                                inputStream = new FileInputStream(phtFile);
                                inputStream.read(phtFileByte);
                                uuivo.setPhtFileByte(phtFileByte);
                            }
                        }
                        catch (Exception e) {
                            
                        }
                        finally {
                            if (inputStream != null) {
                                    inputStream.close();
                            }
                            inputStream = null;
                        }
                    }
                    
                    // 수정된 사진을 세션에 반영하기 위해..
                    resultVO.setReturnVO(uuivo);
                }
                
                usrUserInfoDAO.update(uuivo);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            return resultVO;
        }
        
        beforeUuiVO.setWwwAuthrtCd(StringUtil.nvl(beforeUuiVO.getWwwAuthrtCd(),"").replace("|", "/"));
        beforeUuiVO.setMngAuthGrpCd(StringUtil.nvl(beforeUuiVO.getMngAuthGrpCd(),"").replace("|", "/"));
        beforeUuiVO.setAdminAuthGrpCd(StringUtil.nvl(beforeUuiVO.getAdminAuthGrpCd(),"").replace("|", "/"));
        
        Map<String, String> compareBean = CommonBeanUtils.compareBean(beforeUuiVO, vo);
        String updateData = "";
        for(int i=0; i<compareBean.size(); i++) {
            if(i!=0) {
                updateData += ",";
            }
            updateData += ((String)compareBean.keySet().toArray()[i]).toUpperCase();
        }
        
        UsrUserInfoChgHstyVO uuichv = new UsrUserInfoChgHstyVO();
        uuichv.setUserId(vo.getUserId());
        uuichv.setRgtrId(vo.getRgtrId());
        uuichv.setChgTarget(updateData);
        uuichv.setConnIp(connIp);
        uuichv.setUserInfoChgDivCd(userInfoChgDivCd); //-- 관리자가 수정
        try {
            uuichv.setUserInfoCts(JsonUtil.getJsonString(vo));
            usrUserInfoChgHstyDAO.insert(uuichv);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return resultVO;
    }

    /**
     * 사용자 정보 변경 이력 페이징
     * @param UsrUserInfoChgHstyVO
     * @return  ProcessResultVO<UsrUserInfoChgHstyVO>
     */
    @Override
    public ProcessResultVO<UsrUserInfoChgHstyVO> userChgHstyListPageing(UsrUserInfoChgHstyVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        int totalCnt = usrUserInfoChgHstyDAO.count(vo);
        paginationInfo.setTotalRecordCount(totalCnt);

        List<UsrUserInfoChgHstyVO> userChgList = usrUserInfoChgHstyDAO.listPageing(vo);

        ProcessResultVO<UsrUserInfoChgHstyVO> resultVO = new ProcessResultVO<UsrUserInfoChgHstyVO>();

        resultVO.setReturnList(userChgList);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    /**
     * 수정된 사용자 정보 컬럼을 반환
     * @param UsrUserInfoChgHstyVO
     * @return  List<UsrUserInfoChgHstyVO>
     */
    @Override
    public List<UsrUserInfoChgHstyVO> setChgTargetCode(List<UsrUserInfoChgHstyVO> voList, String orgId) throws Exception {
        for (int i = 0; i < voList.size(); i++) {
            if(!"".equals(StringUtil.nvl(voList.get(i).getChgTarget(),""))) {
                String chgTargetList = "";
                for (int j = 0; j < StringUtil.split(voList.get(i).getChgTarget(), ",").length; j++) {
                    String codeCd = StringUtil.split(voList.get(i).getChgTarget(), ",")[j];
                    
                    OrgCodeVO ocvo = null;
                    try { 
                        //ocvo = orgCodeService.viewCode(orgId, "USER_INFO_CFG", codeCd);
                    	
                    	// 임시설정
                    	ocvo = new OrgCodeVO();
                    	ocvo.setOrgId(orgId);
                    	ocvo.setUpCd("USER_INFO_CFG");
                    	ocvo.setCd(codeCd);
                    	
                    } catch(Exception e) {
                        e.printStackTrace();
                        System.out.println("코드 결과 없음");
                    }
                    
                    if(ocvo != null) {
                        if(ocvo.getCdnm() != null) {
                            chgTargetList += (ocvo.getCdnm())+",";
                        }
                    }
                }
                voList.get(i).setChgTarget(StringUtil.substring(chgTargetList, 0, chgTargetList.length()-1));
            }
            if(!"".equals(StringUtil.nvl(voList.get(i).getUserInfoChgDivCd(), ""))) {
                OrgCodeVO ocvo = orgCodeService.viewCode(orgId, "CHG_DIV_CD", voList.get(i).getUserInfoChgDivCd());
                voList.get(i).setUserInfoChgDivNm(StringUtil.nvl(ocvo.getCdnm()));
            }
        }
        return voList;
    }

    /**
     * 사용자의 이름과 이메일로 사용자 정보 검색
     * @param UsrUserInfoVO vo
     * @return  UsrUserInfoVO
     */
    @Override
    public UsrUserInfoVO searchUserId(UsrUserInfoVO vo) throws Exception {
        return usrUserInfoDAO.selectSearchId(vo);
    }

    /**
     * 사용자 목록 검색 ( 학생 )
     * @param UsrUserInfoVO vo
     * @return  ProcessResultVO<UsrUserInfoVO>
     */
    @Override
    public ProcessResultVO<UsrUserInfoVO> listSearchByStudent(UsrUserInfoVO vo) throws Exception {
        ProcessResultVO<UsrUserInfoVO> resultVO = new ProcessResultVO<UsrUserInfoVO>();
        List<UsrUserInfoVO> userList = usrUserInfoDAO.listSearchByStudent(vo);
        resultVO.setReturnList(userList);
        return resultVO;
    }

    /**
     * 사용자 목록 검색 ( 교직원 )
     * @param UsrUserInfoVO vo
     * @return  ProcessResultVO<UsrUserInfoVO>
     */
    @Override
    public ProcessResultVO<UsrUserInfoVO> listSearchByProfessor(UsrUserInfoVO vo) throws Exception {
        ProcessResultVO<UsrUserInfoVO> resultVO = new ProcessResultVO<UsrUserInfoVO>();
        List<UsrUserInfoVO> userList = usrUserInfoDAO.listSearchByProfessor(vo);
        resultVO.setReturnList(userList);
        return resultVO;
    }
    
    public FileVO insertFileInfo(UsrUserInfoVO vo, String nSn, String oSn, String delYn) throws Exception {
        FileVO fVo = new FileVO();
        fVo.setOrgId(vo.getOrgId());
        fVo.setUserId(vo.getUserId());
        fVo.setRepoCd(vo.getRepoCd());
        fVo.setFilePath(vo.getUploadPath());

        fVo.setFileBindDataSn(nSn);
        fVo.setCopyFileBindDataSn(oSn);
        fVo.setUploadFiles(vo.getUploadFiles());
        fVo.setCopyFiles(vo.getCopyFiles());
        fVo.setDelFileIds(vo.getDelFileIds());

        fVo.setAudioData(vo.getAudioData());
        fVo.setAudioFile(vo.getAudioFile());

        fVo.setOrginDelYn(delYn);
        sysFileService.insertFileInfo(fVo);

        return fVo;
    }

    /**
     * 사용자 환경설정 수정
     * @param vo
     * @throws Exception
     */
    public void updateUserConf(UsrUserInfoVO vo) throws Exception {
        usrUserInfoDAO.updateUserConf(vo);
    }
    
    // 학과관리 사용여부
	@Override
	public int editUseYn(UsrDeptCdVO vo) throws Exception {
		return usrUserInfoDAO.editUseYn(vo);
	}

	/**
     * 관리자 권한변경
     * @param vo 
     * @return 
     * @throws Exception
     */
    public void saveAdminAuthGrp(UsrUserInfoVO vo) throws Exception {
        String orgId = vo.getOrgId();
        String userId = vo.getUserId();
        String authGrpCd = vo.getAuthrtCd();
        String rgtrId = vo.getRgtrId();
        String mdfrId = vo.getMdfrId();
        
        // 1.관리자 권한코드 조회
        List<OrgCodeVO> userTypeSearchList = orgCodeService.selectOrgCodeList("USER_TYPE");
        Set<String> adminAuthGrpCdSet = new HashSet<>();
        for(OrgCodeVO orgCodeVO : userTypeSearchList) {
            String codeOptn = orgCodeVO.getCodeOptn();
        
            if("ADM".equals(StringUtil.nvl(codeOptn))) {
                adminAuthGrpCdSet.add(orgCodeVO.getCd());
            }
        }
        
        // 2.사용자의 현재 권한목록 조회
        UsrUserAuthGrpVO userAuthGrpVO = new UsrUserAuthGrpVO();
        userAuthGrpVO.setOrgId(orgId);
        userAuthGrpVO.setUserId(userId);
        List<UsrUserAuthGrpVO> userAuthList = usrUserAuthGrpDAO.selectUserAuthList(userAuthGrpVO);
        
        // 해당없음 선택인경우
        if("".equals(StringUtil.nvl(authGrpCd))) {
            // 3.관리자 제외 권한 가지고 있는지 체크
            boolean hasNonAuthGrpCd = false;
           
            for(UsrUserAuthGrpVO usrUserAuthGrpVO : userAuthList) {
                if(!adminAuthGrpCdSet.contains(usrUserAuthGrpVO.getAuthrtCd())) {
                    hasNonAuthGrpCd = true;
                    break;
                }
            }
            
            if(!hasNonAuthGrpCd) {
                throw processException("user.message.userinfo.auth.group.admin.empty"); // 해당없음은 교수만 선택 가능합니다.
            }
            
            // 4.관리자 권한 삭제
            UsrUserAuthGrpVO deleteAuthGrpVO = new UsrUserAuthGrpVO();
            deleteAuthGrpVO.setAuthrtGrpcd("ADM");
            deleteAuthGrpVO.setUserId(userId);
            usrUserAuthGrpDAO.deleteAll(deleteAuthGrpVO);
        } else {
            // 3.관리자 권한 삭제
            UsrUserAuthGrpVO deleteAuthGrpVO = new UsrUserAuthGrpVO();
            deleteAuthGrpVO.setAuthrtGrpcd("ADM");
            deleteAuthGrpVO.setUserId(userId);
            usrUserAuthGrpDAO.deleteAll(deleteAuthGrpVO);
            
            // 4.관리자 권한 등록
            UsrUserAuthGrpVO insertAuthGrpVO = new UsrUserAuthGrpVO();
            insertAuthGrpVO.setAuthrtGrpcd("ADM");
            insertAuthGrpVO.setUserId(userId);
            insertAuthGrpVO.setAuthrtCd(authGrpCd);
            insertAuthGrpVO.setRgtrId(rgtrId);
            insertAuthGrpVO.setMdfrId(mdfrId);
            usrUserAuthGrpDAO.insert(insertAuthGrpVO);
        }
    }

    /**
     * 재학생 중 대학생 or 학부생 조회
     * @param vo 
     * @return ProcessResultVO<UsrUserInfoVO>
     * @throws Exception
     */
    @Override
    public ProcessResultVO<UsrUserInfoVO> listStudentByUniCd(UsrUserInfoVO vo) throws Exception {
        ProcessResultVO<UsrUserInfoVO> resultVO = new ProcessResultVO<UsrUserInfoVO>();
        
        try {
            List<UsrUserInfoVO> userList = usrUserInfoDAO.listStudentByUniCd(vo);
            resultVO.setReturnList(userList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
        }
        
        return resultVO;
    }
    
    /**
     * 사용자 수신정보 조회
     * @param  UsrUserInfoVO 
     * @return UsrUserInfoVO
     * @throws Exception
     */
    public UsrUserInfoVO selectUserRecvInfo(UsrUserInfoVO vo) throws Exception {
        return usrUserInfoDAO.selectUserRecvInfo(vo);
    }
    
    /**
     * 사용자 수신정보 목록 조회
     * @param  UsrUserInfoVO 
     * @return List<UsrUserInfoVO>
     * @throws Exception
     */
    public List<UsrUserInfoVO> listUserRecvInfo(UsrUserInfoVO vo) throws Exception {
        String[] sqlForeach = vo.getSqlForeach();
        
        if(vo.getSqlForeach() != null && vo.getSqlForeach().length > 0) {
            List<UsrUserInfoVO> listResvUserInfo = new ArrayList<>();
            
            List<String> userIdList = Arrays.asList(sqlForeach);
            
            UsrUserInfoVO usrUserInfoVO = new UsrUserInfoVO();
            usrUserInfoVO.setOrgId(vo.getOrgId());
            int searchSize = 500;
            for (int i = 0; i < userIdList.size(); i += searchSize) {
                int endIndex = Math.min(i + searchSize, userIdList.size());
                List<String> sublist = userIdList.subList(i, endIndex);
                
                usrUserInfoVO.setSqlForeach(sublist.toArray(new String[sublist.size()]));
                List<UsrUserInfoVO> listResvUserInfoSub = usrUserInfoDAO.listUserRecvInfo(usrUserInfoVO);
                
                listResvUserInfo.addAll(listResvUserInfoSub);
            }
            
            return listResvUserInfo;
        } else {
            return new ArrayList<>();
        }
    }
    
    @Override
    public void setTmpUser(UsrUserInfoVO vo) throws Exception {
    	UsrUserInfoVO uuivo  = usrUserInfoDAO.selectForLogin(vo);
    	if (uuivo == null) {
    		usrUserInfoDAO.insertTmpUser(vo);
    	}
    }
    
    /**
     * 메뉴 구분별 사용자 목록 
     * @param vo
     * @return ProcessResultVO<UsrUserInfoVO>
     * @throws Exception
     */
    @Override
    public List<UsrUserInfoVO> listUserByMenuType(UsrUserInfoVO vo) throws Exception {
        return usrUserInfoDAO.listUserByMenuType(vo);
    }
    
    /**
     * 메뉴 구분별 사용자 페이징 목록 
     * @param vo
     * @return ProcessResultVO<UsrUserInfoVO>
     * @throws Exception
     */
    @Override
    public ProcessResultVO<UsrUserInfoVO> listPagingUserByMenuType(UsrUserInfoVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        int totalCount = usrUserInfoDAO.countUserByMenuType(vo);
        paginationInfo.setTotalRecordCount(totalCount);

        List<UsrUserInfoVO> userList = usrUserInfoDAO.listPagingUserByMenuType(vo);

        ProcessResultVO<UsrUserInfoVO> resultVO = new ProcessResultVO<>();

        resultVO.setReturnList(userList);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }
    
    /**
     * 한사대 사용자 목록 검색(운영자,교수)
     * @param  UsrUserInfoVO 
     * @return List<UsrUserInfoVO>
     * @throws Exception
     */
    @Override
    public List<UsrUserInfoVO> listSearchByKnouUser(UsrUserInfoVO vo) throws Exception {
    	return usrUserInfoDAO.listSearchByKnouUser(vo);
    }
    
    /**
     * 기관사용자 한사대 사용자 연결 조회
     * @param  UsrUserInfoVO 
     * @param  UsrUserInfoVO
     * @throws Exception
     */
    @Override
    public UsrUserInfoVO selectUserOrgRltn(UsrUserInfoVO vo) throws Exception {
    	return usrUserInfoDAO.selectUserOrgRltn(vo);
    }
    
    /**
     * 기관사용자 한사대 사용자 연결 저장
     * @param  UsrUserInfoVO 
     * @throws Exception
     */
    @Override
    public void insertUserOrgRltn(UsrUserInfoVO vo) throws Exception {
    	usrUserInfoDAO.insertUserOrgRltn(vo);
    }
    
    /**
     * 기관사용자 한사대 사용자 연결 수정
     * @param  UsrUserInfoVO 
     * @throws Exception
     */
    @Override
    public void updateUserOrgRltn(UsrUserInfoVO vo) throws Exception {
    	usrUserInfoDAO.updateUserOrgRltn(vo);
    }
    
    /**
     * 기관사용자 한사대 사용자 연결 조회 (by 한사대계정)
     * @param  UsrUserInfoVO 
     * @return List<UsrUserInfoVO>
     * @throws Exception
     */
    @Override
    public List<UsrUserInfoVO> selectUserOrgRltnByKnouUser(UsrUserInfoVO vo) throws Exception {
    	return usrUserInfoDAO.selectUserOrgRltnByKnouUser(vo);
    }
}
