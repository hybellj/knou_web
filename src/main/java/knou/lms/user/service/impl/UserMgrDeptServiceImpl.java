package knou.lms.user.service.impl;

import java.util.Collections;
import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;

import knou.framework.common.PageInfo;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.log.haksa.service.AisLinkLogService;
import knou.lms.log.haksa.vo.AisLinkLogVO;
import knou.lms.user.dao.UserMgrDeptDAO;
import knou.lms.user.service.UserMgrDeptService;
import knou.lms.user.vo.UserMgrDeptVO;

@Service("userMgrDeptService")
public class UserMgrDeptServiceImpl implements UserMgrDeptService {

    private static final Logger LOGGER = LoggerFactory.getLogger(UserMgrDeptServiceImpl.class);

    @Resource(name = "userMgrDeptDAO")
    private UserMgrDeptDAO userMgrDeptDAO;

    @Resource(name = "aisLinkLogService")
    private AisLinkLogService aisLinkLogService;

    /*****************************************************
     * 학과/부서 목록 조회
     * @param pageInfo
     * @return ResultDTO<EgovMap>
     ******************************************************/
    @Override
    public ResultDTO<EgovMap> listUserMgrDept(PageInfo pageInfo) {
        ResultDTO<EgovMap> resultDTO = new ResultDTO<EgovMap>(pageInfo);

        List<EgovMap> list = userMgrDeptDAO.listUserMgrDept(pageInfo);
        resultDTO.setReturnList(list);

        int totalCnt = (list == null || list.isEmpty()) ? 0
                : Integer.parseInt(String.valueOf(list.get(0).get("totalCnt")));
        resultDTO.getPageInfo().setTotalRecordCount(totalCnt);

        return resultDTO.setResultSuccess();
    }

    /*****************************************************
     * 학과/부서 상위 코드 목록 조회
     * @param vo
     * @return List<UserMgrDeptVO>
     ******************************************************/
    @Override
    public List<UserMgrDeptVO> listUserMgrDeptCode(UserMgrDeptVO vo) {
        if (isBlank(vo.getOrgId())) {
            return Collections.emptyList();
        }
        return userMgrDeptDAO.listUserMgrDeptCode(vo);
    }

    /*****************************************************
     * 학과/부서 단건 조회
     * @param vo
     * @return UserMgrDeptVO
     ******************************************************/
    @Override
    public UserMgrDeptVO selectUserMgrDept(UserMgrDeptVO vo) {
        return userMgrDeptDAO.selectUserMgrDept(vo);
    }

    /*****************************************************
     * 학과/부서 등록
     * @param vo
     * @return ResultDTO<UserMgrDeptVO>
     ******************************************************/
    @Override
    public ResultDTO<UserMgrDeptVO> insertUserMgrDept(UserMgrDeptVO vo) {
        ResultDTO<UserMgrDeptVO> resultDTO = new ResultDTO<UserMgrDeptVO>();

        String validationMessage = validateRequired(vo);
        if (validationMessage != null) {
            return resultDTO.setResultFailed(validationMessage);
        }

        if (userMgrDeptDAO.countUserMgrDeptId(vo) > 0) {
            return resultDTO.setResultFailed("이미 등록된 학과/부서 코드입니다.");
        }

        userMgrDeptDAO.insertUserMgrDept(vo);
        return resultDTO.setData(vo).setResultSuccess("저장되었습니다.");
    }

    /*****************************************************
     * 학과/부서 수정
     * @param vo
     * @return ResultDTO<UserMgrDeptVO>
     ******************************************************/
    @Override
    public ResultDTO<UserMgrDeptVO> updateUserMgrDept(UserMgrDeptVO vo) {
        ResultDTO<UserMgrDeptVO> resultDTO = new ResultDTO<UserMgrDeptVO>();

        String validationMessage = validateRequired(vo);
        if (validationMessage != null) {
            return resultDTO.setResultFailed(validationMessage);
        }

        String orgDeptId = StringUtil.nvl(vo.getOrgDeptId());
        if (isBlank(orgDeptId)) {
            vo.setOrgDeptId(vo.getDeptId());
            orgDeptId = vo.getDeptId();
        }

        // 학과/부서 코드(PK) 변경 시 신규 코드 중복 검사
        if (!orgDeptId.equals(vo.getDeptId()) && userMgrDeptDAO.countUserMgrDeptId(vo) > 0) {
            return resultDTO.setResultFailed("이미 등록된 학과/부서 코드입니다.");
        }

        if (userMgrDeptDAO.updateUserMgrDept(vo) == 0) {
            return resultDTO.setResultFailed("수정할 학과/부서 정보를 확인할 수 없습니다.");
        }
        return resultDTO.setData(vo).setResultSuccess("수정되었습니다.");
    }

    /*****************************************************
     * 학과/부서 삭제
     * @param vo
     * @return ResultDTO<UserMgrDeptVO>
     ******************************************************/
    @Override
    public ResultDTO<UserMgrDeptVO> deleteUserMgrDept(UserMgrDeptVO vo) {
        ResultDTO<UserMgrDeptVO> resultDTO = new ResultDTO<UserMgrDeptVO>();

        if (isBlank(vo.getDeptId())) {
            return resultDTO.setResultFailed("삭제할 학과/부서를 선택해 주세요.");
        }

        userMgrDeptDAO.deleteUserMgrDept(vo);
        return resultDTO.setResultSuccess("삭제되었습니다.");
    }

    /*****************************************************
     * 학사연동 뷰 기준 학과/부서 Upsert (성공/실패 TB_LMS_LOG_AIS_LINK 로그 적재)
     * @param vo
     * @return ResultDTO<EgovMap>
     ******************************************************/
    @Override
    public ResultDTO<EgovMap> mergeUserMgrDeptHaksaSync(UserMgrDeptVO vo) {
        ResultDTO<EgovMap> resultDTO = new ResultDTO<EgovMap>();

        boolean success = true;
        int addCnt = 0;
        int modCnt = 0;
        int delCnt = 0;
        String rsltCts;
        try {
            addCnt = userMgrDeptDAO.countHaksaSyncAdd(vo);
            modCnt = userMgrDeptDAO.countHaksaSyncMod(vo);
            delCnt = deleteStaleDepts(vo);
            userMgrDeptDAO.mergeUserMgrDeptHaksaSync(vo);
            rsltCts = "학사연동이 완료되었습니다. (신규 " + addCnt + ", 수정 " + modCnt + ", 삭제 " + delCnt + "건)";
        } catch (DataAccessException e) {
            success = false;
            addCnt = 0;
            modCnt = 0;
            delCnt = 0;
            rsltCts = StringUtil.nvl(e.getMessage());
            LOGGER.error("학과/부서 학사연동 실패 (orgId=" + vo.getOrgId() + ")", e);
        }

        writeHaksaSyncLog(vo, success, rsltCts, addCnt, modCnt, delCnt);

        if (!success) {
            return resultDTO.setResultFailed("학사연동 중 오류가 발생하였습니다.");
        }

        EgovMap data = new EgovMap();
        data.put("execDttm", DateTimeUtil.getCurrentString("yyyy.MM.dd(HH:mm:ss)"));
        data.put("syncCnt", addCnt + modCnt + delCnt);
        data.put("message", rsltCts);

        return resultDTO.setData(data).setResultSuccess(rsltCts);
    }

    /*****************************************************
     * 학사 뷰에 없는 기존 학과/부서 건별 삭제 (FK 참조 건은 삭제하지 않고 남김)
     * @param vo (orgId 기준)
     * @return 실제 삭제 건수
     ******************************************************/
    private int deleteStaleDepts(UserMgrDeptVO vo) {
        List<String> staleDeptIds = userMgrDeptDAO.selectHaksaSyncStaleDeptIds(vo);
        int deleted = 0;
        for (String deptId : staleDeptIds) {
            try {
                UserMgrDeptVO delVo = new UserMgrDeptVO();
                delVo.setOrgId(vo.getOrgId());
                delVo.setDeptId(deptId);
                userMgrDeptDAO.deleteUserMgrDept(delVo);
                deleted++;
            } catch (DataIntegrityViolationException e) {
                LOGGER.warn("학사연동 학과/부서 삭제 건너뜀 (FK 참조 존재, deptId=" + deptId + ")");
            }
        }
        return deleted;
    }

    /*****************************************************
     * 학사연동 로그 적재 (공통 AisLinkLogService 위임)
     * @param vo
     * @param success
     * @param rsltCts
     * @param addCnt
     * @param modCnt
     * @param delCnt
     ******************************************************/
    private void writeHaksaSyncLog(UserMgrDeptVO vo, boolean success,
            String rsltCts, int addCnt, int modCnt, int delCnt) {
        AisLinkLogVO logVo = new AisLinkLogVO();
        logVo.setOrgId(vo.getOrgId());
        logVo.setAisLinkTycd("OPTN0001_001");
        logVo.setSuccess(success);
        logVo.setAisLinkRsltCts(rsltCts);
        logVo.setAddCnt(addCnt);
        logVo.setModCnt(modCnt);
        logVo.setDelCnt(delCnt);
        logVo.setRgtrId(vo.getRgtrId());
        aisLinkLogService.writeAisLinkLog(logVo);
    }

    /*****************************************************
     * 필수값 검증
     * @param vo
     * @return 검증 실패 메시지 (정상 시 null)
     ******************************************************/
    private String validateRequired(UserMgrDeptVO vo) {
        if (isBlank(vo.getOrgId())) {
            return "기관을 선택해 주세요.";
        }
        if (isBlank(vo.getDeptId())) {
            return "학과/부서 코드를 입력해 주세요.";
        }
        if (isBlank(vo.getDeptnm())) {
            return "학과/부서명(KR)을 입력해 주세요.";
        }
        return null;
    }

    private boolean isBlank(String value) {
        return StringUtil.nvl(value).trim().length() == 0;
    }
}
