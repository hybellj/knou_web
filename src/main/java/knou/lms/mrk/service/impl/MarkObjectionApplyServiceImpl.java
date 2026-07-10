package knou.lms.mrk.service.impl;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.common.PageInfo;
import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.framework.exception.BusinessException;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import knou.lms.mrk.dao.MarkObjectionApplyDAO;
import knou.lms.mrk.service.MarkObjectionApplyService;
import knou.lms.mrk.vo.MarkObjectionApplyVO;
import knou.lms.schedule.service.CalendarService;
import knou.lms.schedule.vo.OrgTaskScheduleVO;

@Service("markObjectionApplyService")
public class MarkObjectionApplyServiceImpl extends ServiceBase implements MarkObjectionApplyService {

    private static final Logger log = LoggerFactory.getLogger(MarkObjectionApplyServiceImpl.class);

    @Resource(name = "markObjectionApplyDAO")
    private MarkObjectionApplyDAO markObjectionApplyDAO;

    @Resource(name = "attachFileService")
    private AttachFileService attachFileService;

    @Resource(name = "calendarService")
    private CalendarService calendarService;

    /**
     * 성적 이의신청 기간 조회
     * @param orgId
     * @return
     */
    @Override
    public Map<String, String> mrkObjctAplyPrdSelect(String orgId) {
        OrgTaskScheduleVO schdlVO = calendarService.orgTaskSchdlSelect(orgId, "MRK_OBJCT_APLY_PRD");

        Map<String, String> resultMap = new HashMap<>();

        resultMap.put("taskSdttm", schdlVO == null ? "" : schdlVO.getTaskSdttm());
        resultMap.put("taskEdttm", schdlVO == null ? "" : schdlVO.getTaskEdttm());

        return resultMap;
    }


    /**
     * 성적 이의신청 기간 여부 체크
     * @param orgId
     * @return
     */
    @Override
    public boolean isMrkObjctAplyDate(String orgId) {
        OrgTaskScheduleVO schdlVO = getMrkObjctAplyPrd(orgId);

        DateTimeFormatter format = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime taskSdttm = LocalDateTime.parse(schdlVO.getTaskSdttm(), format);
        LocalDateTime taskEdttm = LocalDateTime.parse(schdlVO.getTaskEdttm(), format);

        return now.isAfter(taskSdttm) && now.isBefore(taskEdttm);
    }

    /**
     * 교수 성적이의신청 목록 조회
     * @param sbjctId
     * @return
     */
    @Override
    public List<EgovMap> profMrkObjctAplyList(String sbjctId) {
        return markObjectionApplyDAO.profMrkObjctAplyList(sbjctId);
    }

    /**
     * 학습자 성적이의신청 목록 조회
     * @param sbjctId
     * @return
     */
    @Override
    public List<EgovMap> stdMrkObjctAplyList(String sbjctId, String userId) {
        List<EgovMap> aplyList = markObjectionApplyDAO.stdMrkObjctAplyList(sbjctId, userId);
        for (EgovMap map : aplyList) {
            String chgDttm = (String) map.get("chgDttm");

            if (StringUtil.isNull(chgDttm)) continue;

            map.replace("chgDttm", DateTimeUtil.getDateType(8, chgDttm)); // yyyy.mm.dd HH:SS
        }
        return markObjectionApplyDAO.stdMrkObjctAplyList(sbjctId, userId);
    }

    /**
     * 학습자 성적이의신청 목록 조회 (페이징)
     * @param vo
     * @return
     */
    @Override
    public ProcessResultVO<EgovMap> mrkObjctAplyListPaging(MarkObjectionApplyVO vo) throws Exception {
        ProcessResultVO<EgovMap> processResultVO = new ProcessResultVO<>();

        // 페이지 정보 설정
        PageInfo pageInfo = new PageInfo(vo);
        processResultVO.setPageInfo(pageInfo);

        // 목록 조회
        List<EgovMap> applyList = markObjectionApplyDAO.markObjctAplyListPaging(vo);

        // 처리일시 날짜 세팅
        for (EgovMap map : applyList) {
            String chgDttm = (String) map.get("chgDttm");

            if (StringUtil.isNull(chgDttm)) continue;

            map.replace("chgDttm", DateTimeUtil.getDateType(8, chgDttm)); // yyyy.mm.dd HH:SS
        }

        // 페이지 전체 건수정보 설정
        pageInfo.setTotalRecord(applyList);

        processResultVO.setReturnList(applyList);
        processResultVO.setPageInfo(pageInfo);

        return processResultVO;
    }

    /**
     * 학습자의 이의신청 건을 상세조회한다.
     * @param mrkObjctAplyId
     * @return
     * @throws Exception
     */
    @Override
    public MarkObjectionApplyVO mrkObjctAplySelect(String mrkObjctAplyId) {

        MarkObjectionApplyVO vo = markObjectionApplyDAO.mrkObjctAplySelect(mrkObjctAplyId);

        if (ValidationUtils.isNotNull(vo) && vo.getFileCnt() > 0) {
            AtflVO atflVO = new AtflVO();
            atflVO.setRefId(vo.getMrkObjctAplyId());

            List<AtflVO> fileList = attachFileService.selectAtflListByRefId(atflVO);
            vo.setFileList(fileList);
        }

        return vo;
    }



    /**
     * 학습자의 성적 이의신청을 등록한다.
     * @param vo
     * @throws Exception
     */
    @Override
    public void mrkObjctAplyRegist(MarkObjectionApplyVO vo, UserContext userCtx) throws Exception {
        // 이의 신청 기간 여부 체크
        if (!isMrkObjctAplyDate(userCtx.getOrgId())) {
            throw new IllegalStateException("score.alert.no.objt.period"); // 이의 신청 기간이 아닙니다.
        }

        // 기 신청건 체크
        if (!isAlreadyConfirmed(vo.getSbjctId(), userCtx.getUserId())) {
            throw new IllegalStateException("score.alert.exist.objt.applicate"); // 이미 이의신청하였습니다.
        }

        vo.setMrkObjctAplyId(IdGenUtil.genNewId(IdPrefixType.MROBJ));
        vo.setUserId(userCtx.getUserId());

        String uploadPath = vo.getUploadPath();
        String uploadFiles = vo.getUploadFiles();
        List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(uploadFiles, uploadPath);

        try {
            markObjectionApplyDAO.stdMrkObjctAplyRegist(vo);

            // ↓↓ 첨부파일
            String copyFiles = vo.getCopyFiles();


            if (!uploadFileList.isEmpty()) {
                for (AtflVO atflVO : uploadFileList) {
                    atflVO.setAtflId(IdGenUtil.genNewId(IdPrefixType.ATFL));
                    atflVO.setRefId(vo.getMrkObjctAplyId());
                    atflVO.setRgtrId(userCtx.getUserId());
                    atflVO.setAtflRepoId(CommConst.REPO_OBJCT); // 첨부파일 저장소 아이디
                }

                // 첨부파일 저장
                attachFileService.insertAtflList(uploadFileList);
            }

        } catch (Exception e) {
            log.debug("e: ", e);

            if (!uploadFileList.isEmpty()) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }

            throw new RuntimeException("파일 삭제 실패", e);
        }
    }

    /**
     * 학습자의 성적 이의신청을 수정한다.
     * @param vo
     * @throws Exception
     */
    @Override
    public void mrkObjctAplyModify(MarkObjectionApplyVO vo, UserContext userCtx) throws Exception {

        // 이의 신청 기간 여부 체크
        if (!isMrkObjctAplyDate(userCtx.getOrgId())) {
            throw new BusinessException("score.alert.no.objt.period"); // 이의 신청 기간이 아닙니다.
        }

        MarkObjectionApplyVO applyVO = mrkObjctAplySelect(vo.getMrkObjctAplyId());
        if (ValidationUtils.isNull(applyVO)) {
        	throw new BusinessException("존재하지 않는 신청 건입니다.");
        }

        if (!applyVO.getUserId().equals(userCtx.getUserId())) { // 본인 신청건 X
        	throw new BusinessException("유효하지 않은 접근 입니다.");
        }

        //  이미 결정된 건인지 체크
        if (!"APLY".equals(applyVO.getObjctAplyStscd())) {
        	throw new BusinessException("수정할 수 없는 상태입니다.");
        }

        markObjectionApplyDAO.stdMrkObjctAplyModify(vo);

        // ↓↓ 첨부파일
        List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());

        if (!uploadFileList.isEmpty()) {
            for (AtflVO atflVO : uploadFileList) {
                atflVO.setRefId(applyVO.getMrkObjctAplyId());
                atflVO.setRgtrId(applyVO.getRgtrId());
                atflVO.setMdfrId(userCtx.getUserId());
                atflVO.setAtflRepoId(CommConst.REPO_OBJCT);
            }

            // 첨부파일 저장
            attachFileService.insertAtflList(uploadFileList);
        }
        // 첨부파일 삭제
        attachFileService.deleteAtflByAtflIds(vo.getDelFileIds());
    }

    /**
     * 학습자의 이의신청 건을 삭제한다.
     * @param vo
     * @param userCtx
     * @throws Exception
     */
    @Override
    public void mrkObjctAplyDelete(MarkObjectionApplyVO vo, UserContext userCtx) throws Exception {

        // 이의 신청 기간 여부 체크
        if (!isMrkObjctAplyDate(userCtx.getOrgId())) {
        	throw new IllegalStateException("score.alert.no.objt.period"); // 이의 신청 기간이 아닙니다.
        }

        MarkObjectionApplyVO applyVO = mrkObjctAplySelect(vo.getMrkObjctAplyId());
        if (ValidationUtils.isNull(applyVO)) {
        	throw new IllegalStateException("존재하지 않는 신청 건입니다.");
        }

        if (!applyVO.getUserId().equals(userCtx.getUserId())) { // 본인 신청건 X
        	throw new IllegalStateException("유효하지 않은 접근 입니다.");
        }

        //  이미 결정된 건인지 체크
        if (!"APLY".equals(applyVO.getObjctAplyStscd())) {
        	throw new IllegalStateException("수정할 수 없는 상태입니다.");
        }

        // 이의 신청 삭제
        markObjectionApplyDAO.stdMrkObjctAplyDelete(vo.getMrkObjctAplyId());

        // ↓↓ 첨부파일
        String[] delFileIds = new String[]{};
        if (applyVO.getFileCnt() > 0) {
            AtflVO atflVO = new AtflVO();
            atflVO.setRefId(vo.getMrkObjctAplyId());

            List<AtflVO> fileList = attachFileService.selectAtflListByRefId(atflVO);
            delFileIds = fileList.stream().map(AtflVO::getAtflId).toArray(String[]::new); // fileList에서 아이디만 추출

        }
        // 첨부파일 삭제
        attachFileService.deleteAtflByAtflIds(delFileIds);
    }

    /**
     * 성적 이의신청 시작/종료일자 조회
     * @param orgId
     * @return
     */
    private OrgTaskScheduleVO getMrkObjctAplyPrd(String orgId) {

        return calendarService.orgTaskSchdlSelect(orgId, "MRK_OBJCT_APLY_PRD");
    }

    /**
     * 성적 이의신청 기 신청건 존재 여부
     * @param sbjctId
     * @param userId
     * @return
     */
    private boolean isAlreadyConfirmed(String sbjctId, String userId) {

        // 기 신청건 체크
        List<EgovMap> aplyList = stdMrkObjctAplyList(sbjctId, userId);

        if (!aplyList.isEmpty()) { // 기 신청 건 존재하는 경우
            for (EgovMap aplyInfo : aplyList) {
                String stsCd = (String) aplyInfo.get("objctAplyStscd");

                if ("APRV".equals(stsCd) || "CNFM".equals(stsCd) || "APLY".equals(stsCd)) {
                    return false;
                }

            }
        }

        return true;
    }
}
