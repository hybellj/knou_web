package knou.lms.user.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.PageInfo;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.user.dao.UserMgrDAO;
import knou.lms.user.service.UserMgrService;
import knou.lms.user.vo.UserMgrVO;

@Service("userMgrService")
public class UserMgrServiceImpl implements UserMgrService {

    @Resource(name = "userMgrDAO")
    private UserMgrDAO userMgrDAO;

    /*****************************************************
     * 사용자 목록 조회
     * @param pageInfo
     * @return ResultDTO<EgovMap>
     ******************************************************/
    @Override
    public ResultDTO<EgovMap> listUserMgr(PageInfo pageInfo) {
        ResultDTO<EgovMap> resultDTO = new ResultDTO<EgovMap>(pageInfo);

        List<EgovMap> list = userMgrDAO.listUserMgr(pageInfo);
        maskStdntNoList(list);
        resultDTO.setReturnList(list);

        int totalCnt = (list == null || list.isEmpty()) ? 0
                : Integer.parseInt(String.valueOf(list.get(0).get("totalCnt")));
        resultDTO.getPageInfo().setTotalRecordCount(totalCnt);

        return resultDTO.setResultSuccess();
    }

    /*****************************************************
     * 학번/사번 마스킹
     * @param list
     ******************************************************/
    private void maskStdntNoList(List<EgovMap> list) {
        if (list == null) {
            return;
        }
        for (EgovMap row : list) {
            row.put("stdntNo", maskStdntNo(strVal(row.get("stdntNo"))));
            row.put("usernm", maskUserNm(strVal(row.get("usernm"))));
        }
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
     * 학번/사번 마스킹 (뒤 2자리 평문, 뒤에서 3~5번째 마스킹, 그 앞 평문)
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
     * 사용자 단건 조회
     * @param vo
     * @return UserMgrVO
     ******************************************************/
    @Override
    public UserMgrVO selectUserMgr(UserMgrVO vo) {
        return userMgrDAO.selectUserMgr(vo);
    }

    /*****************************************************
     * 사용자 아이디 중복 건수 조회
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int countUserMgrId(UserMgrVO vo) {
        return userMgrDAO.countUserMgrId(vo);
    }

    /*****************************************************
     * 학번/사번 중복 건수 조회
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int countUserMgrStdntNo(UserMgrVO vo) {
        return userMgrDAO.countUserMgrStdntNo(vo);
    }

    /*****************************************************
     * 사용자 등록
     * @param vo
     * @return ResultDTO<UserMgrVO>
     ******************************************************/
    @Override
    public ResultDTO<UserMgrVO> insertUserMgr(UserMgrVO vo) {
        ResultDTO<UserMgrVO> resultDTO = new ResultDTO<UserMgrVO>();

        String validationMessage = validateRequired(vo);
        if (validationMessage != null) {
            return resultDTO.setResultFailed(validationMessage);
        }

        if (userMgrDAO.countUserMgrId(vo) > 0) {
            return resultDTO.setResultFailed("이미 등록된 아이디입니다.");
        }

        userMgrDAO.insertUserMgr(vo);
        saveUserCntct(vo);
        saveUserAuthrt(vo);
        return resultDTO.setData(vo).setResultSuccess("저장되었습니다.");
    }

    /*****************************************************
     * 사용자 수정
     * @param vo
     * @return ResultDTO<UserMgrVO>
     ******************************************************/
    @Override
    public ResultDTO<UserMgrVO> updateUserMgr(UserMgrVO vo) {
        ResultDTO<UserMgrVO> resultDTO = new ResultDTO<UserMgrVO>();

        String validationMessage = validateRequired(vo);
        if (validationMessage != null) {
            return resultDTO.setResultFailed(validationMessage);
        }

        if (userMgrDAO.updateUserMgr(vo) == 0) {
            return resultDTO.setResultFailed("수정할 사용자 정보를 확인할 수 없습니다.");
        }
        saveUserCntct(vo);
        userMgrDAO.deleteUserMgrAuthAll(vo);
        saveUserAuthrt(vo);
        return resultDTO.setData(vo).setResultSuccess("수정되었습니다.");
    }

    /*****************************************************
     * 사용자 권한 등록
     * @param vo
     ******************************************************/
    private void saveUserAuthrt(UserMgrVO vo) {
        insertUserAuthrt(vo, vo.getAuthrtId());
        insertUserAuthrt(vo, vo.getUserTyAuthrtId());
    }

    /*****************************************************
     * 사용자 권한 단건 등록 (authrtId가 있을 때만)
     * @param vo
     * @param authrtId
     ******************************************************/
    private void insertUserAuthrt(UserMgrVO vo, String authrtId) {
        if (isBlank(authrtId)) {
            return;
        }
        vo.setUserAuthrtId(IdGenerator.getNewId(IdPrefixType.USAUT.getCode()));
        vo.setAuthrtId(authrtId);
        userMgrDAO.insertUserMgrAuth(vo);
    }

    /*****************************************************
     * 사용자 연락처 저장 (휴대폰/개인이메일)
     * @param vo
     ******************************************************/
    private void saveUserCntct(UserMgrVO vo) {
        mergeCntct(vo, "MBL_PHN", vo.getMobileNo());
        mergeCntct(vo, "INDV_EML", vo.getEmail());
    }

    /*****************************************************
     * 연락처 단건 MERGE
     * @param vo
     * @param cntctTycd
     * @param cntct
     ******************************************************/
    private void mergeCntct(UserMgrVO vo, String cntctTycd, String cntct) {
        if (isBlank(cntct)) {
            return;
        }
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("userCntctId", IdGenerator.getNewId(IdPrefixType.USCTT.getCode()));
        param.put("userId", vo.getUserId());
        param.put("cntctTycd", cntctTycd);
        param.put("cntct", cntct);
        param.put("rgtrId", vo.getMdfrId());
        param.put("mdfrId", vo.getMdfrId());
        userMgrDAO.mergeUserMgrCntct(param);
    }

    /*****************************************************
     * 사용자 탈퇴 처리 (손님 대상)
     * @param vo
     * @return ResultDTO<UserMgrVO>
     ******************************************************/
    @Override
    public ResultDTO<UserMgrVO> withdrawUserMgr(UserMgrVO vo) {
        ResultDTO<UserMgrVO> resultDTO = new ResultDTO<UserMgrVO>();

        if (isBlank(vo.getUserId())) {
            return resultDTO.setResultFailed("대상 사용자를 확인할 수 없습니다.");
        }
        if (userMgrDAO.countUserGuestAuthrt(vo) == 0) {
            return resultDTO.setResultFailed("손님 권한 사용자만 탈퇴 처리할 수 있습니다.");
        }
        if (userMgrDAO.withdrawUserMgr(vo) == 0) {
            return resultDTO.setResultFailed("탈퇴할 사용자 정보를 확인할 수 없습니다.");
        }
        return resultDTO.setData(vo).setResultSuccess("탈퇴 처리되었습니다.");
    }

    /*****************************************************
     * 사용자 관리자구분(권한) 변경
     * @param vo
     * @return ResultDTO<UserMgrVO>
     ******************************************************/
    @Override
    public ResultDTO<UserMgrVO> updateUserMgrAuth(UserMgrVO vo) {
        ResultDTO<UserMgrVO> resultDTO = new ResultDTO<UserMgrVO>();

        if (isBlank(vo.getUserId())) {
            return resultDTO.setResultFailed("대상 사용자를 확인할 수 없습니다.");
        }
        if (isBlank(vo.getAuthrtId())) {
            return resultDTO.setResultFailed("관리자 구분을 선택해 주세요.");
        }

        userMgrDAO.deleteUserMgrAuth(vo);
        vo.setUserAuthrtId(IdGenerator.getNewId(IdPrefixType.USAUT.getCode()));
        userMgrDAO.insertUserMgrAuth(vo);
        return resultDTO.setData(vo).setResultSuccess("권한이 변경되었습니다.");
    }

    /*****************************************************
     * 관리자 구분 목록 조회
     * @return List<EgovMap>
     ******************************************************/
    @Override
    public List<EgovMap> listAdminGbn() {
        return userMgrDAO.listAdminGbn();
    }

    /*****************************************************
     * 사용자 구분 목록 조회
     * @return List<EgovMap>
     ******************************************************/
    @Override
    public List<EgovMap> listUserGbn() {
        return userMgrDAO.listUserGbn();
    }

    /*****************************************************
     * 사용자가 보유한 권한 ID 목록 조회
     * @param vo
     * @return List<String>
     ******************************************************/
    @Override
    public List<String> listUserAuthrtId(UserMgrVO vo) {
        return userMgrDAO.listUserAuthrtId(vo);
    }

    /*****************************************************
     * 권한 단건 조회 (권한코드/권한명/권한그룹)
     * @param vo
     * @return EgovMap
     ******************************************************/
    @Override
    public EgovMap selectAuthrt(UserMgrVO vo) {
        return userMgrDAO.selectAuthrt(vo);
    }

    /*****************************************************
     * 사용자정보변경이력 등록 (변경 항목 1건)
     * @param param
     * @return int
     ******************************************************/
    @Override
    public int insertUserInfoChgHstry(Map<String, Object> param) {
        return userMgrDAO.insertUserInfoChgHstry(param);
    }

    /*****************************************************
     * 사용자전화번호변경이력 등록
     * @param param
     * @return int
     ******************************************************/
    @Override
    public int insertUserTelnoChgHstry(Map<String, Object> param) {
        return userMgrDAO.insertUserTelnoChgHstry(param);
    }

    /*****************************************************
     * 권한변경이력 등록
     * @param param
     * @return int
     ******************************************************/
    @Override
    public int insertUserAuthrtChgHstry(Map<String, Object> param) {
        return userMgrDAO.insertUserAuthrtChgHstry(param);
    }

    /*****************************************************
     * 사용자전화번호변경이력 조회
     * @param vo
     * @return List<EgovMap>
     ******************************************************/
    @Override
    public List<EgovMap> listUserTelnoChgHstry(UserMgrVO vo) {
        return userMgrDAO.listUserTelnoChgHstry(vo);
    }

    /*****************************************************
     * 필수값 검증
     * @param vo
     * @return 검증 실패 메시지 (정상 시 null)
     ******************************************************/
    private String validateRequired(UserMgrVO vo) {
        if (isBlank(vo.getOrgId())) {
            return "기관을 선택해 주세요.";
        }
        if (isBlank(vo.getUserId())) {
            return "아이디를 입력해 주세요.";
        }
        if (isBlank(vo.getUsernm())) {
            return "이름을 입력해 주세요.";
        }
        if (isBlank(vo.getUserTycd())) {
            return "사용자 구분을 선택해 주세요.";
        }
        return null;
    }

    private boolean isBlank(String value) {
        return StringUtil.nvl(value).trim().length() == 0;
    }
}
