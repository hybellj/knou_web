package knou.lms.msg.facade;

import knou.framework.common.CommConst;
import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.FileUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import knou.lms.msg.service.MsgEmlService;
import knou.lms.msg.service.MsgMgrService;
import knou.lms.msg.vo.MsgEmlVO;
import knou.lms.msg.vo.MsgMgrVO;
import knou.lms.msg.web.util.MsgAuthUtil;
import knou.lms.org.service.OrgInfoService;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.user.dao.UserPrfilDAO;
import knou.lms.user.vo.UserPrfilVO;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

@Service("msgEmlFacadeService")
public class MsgEmlFacadeServiceImpl extends ServiceBase implements MsgEmlFacadeService {

    @Resource(name = "msgEmlService")
    private MsgEmlService msgEmlService;

    @Resource(name = "msgMgrService")
    private MsgMgrService msgMgrService;

    @Resource(name = "orgInfoService")
    private OrgInfoService orgInfoService;

    @Resource(name = "userPrfilDAO")
    private UserPrfilDAO userPrfilDAO;

    @Resource(name = "attachFileService")
    private AttachFileService attachFileService;

    /*****************************************************
     * 채널 VO → 공통 MsgMgrVO 변환 (검색 조건)
     * @param s
     * @return MsgMgrVO
     ******************************************************/
    private MsgMgrVO toMgrVO(MsgEmlVO s) {
        MsgMgrVO m = new MsgMgrVO();
        m.setOrgId(s.getOrgId());
        m.setUserId(s.getUserId());
        m.setSbjctId(s.getSbjctId());
        m.setSbjctYr(s.getSbjctYr());
        m.setSbjctSmstr(s.getSbjctSmstr());
        m.setUserIdList(s.getUserIdList());
        m.setAdminYn(s.getAdminYn());
        m.setSndngrId(s.getSndngrId());
        m.setUserTycd(s.getUserTycd());
        m.setSearchText(s.getSearchText());
        m.setGubun(s.getGubun());
        m.setPageIndex(s.getPageIndex());
        m.setListScale(s.getListScale());
        return m;
    }

    /*****************************************************
     * 공통 MsgMgrVO 목록 → 채널 VO 목록 변환 (학사년도/학과/과목 옵션)
     * @param src
     * @return List<MsgEmlVO>
     ******************************************************/
    private List<MsgEmlVO> toEmlList(List<MsgMgrVO> src) {
        List<MsgEmlVO> result = new ArrayList<>();
        if (src == null) {
            return result;
        }
        for (MsgMgrVO m : src) {
            MsgEmlVO p = new MsgEmlVO();
            p.setSbjctYr(m.getSbjctYr());
            p.setSbjctId(m.getSbjctId());
            p.setSbjctnm(m.getSbjctnm());
            result.add(p);
        }
        return result;
    }

    /*****************************************************
     * 공통 MsgMgrVO 수신자 목록 → 채널 VO 목록 변환
     * @param src
     * @return List<MsgEmlVO>
     ******************************************************/
    private List<MsgEmlVO> toEmlRcvrList(List<MsgMgrVO> src) {
        List<MsgEmlVO> result = new ArrayList<>();
        if (src == null) {
            return result;
        }
        for (MsgMgrVO m : src) {
            MsgEmlVO p = new MsgEmlVO();
            p.setUserId(m.getUserId());
            p.setUsernm(m.getUsernm());
            p.setStdntNo(m.getStdntNo());
            p.setMblPhn(m.getMblPhn());
            p.setEml(m.getEml());
            result.add(p);
        }
        return result;
    }

    /*****************************************************
     * 첨부파일 목록 조회
     * @param refId
     * @return List<AtflVO>
     ******************************************************/
    private List<AtflVO> selectAtflListByRefId(String refId) {
        AtflVO atflVO = new AtflVO();
        atflVO.setRefId(refId);
        return attachFileService.selectAtflListByRefId(atflVO);
    }

    /*****************************************************
     * 기관 목록 조회
     * @param userId
     * @param isAdmin
     * @return List<OrgInfoVO>
     ******************************************************/
    @Override
    public List<OrgInfoVO> selectActiveOrgListByAuth(String userId, boolean isAdmin) throws Exception {
        if (isAdmin) {
            return orgInfoService.listActiveOrg();
        }
        if (StringUtil.isNotNull(userId)) {
            return orgInfoService.listActiveOrgByUser(userId);
        }
        return new ArrayList<>();
    }

    /*****************************************************
     * 교수 담당과목 기준 기관 목록 조회
     * @param userId
     * @return List<OrgInfoVO>
     ******************************************************/
    @Override
    public List<OrgInfoVO> selectProfSbjctOrgList(String userId) {
        return msgMgrService.selectProfSbjctOrgList(userId);
    }

    /*****************************************************
     * 이메일 수신 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgEmlVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgEmlVO> selectEmlRcvnListPage(MsgEmlVO vo) throws Exception {
        return msgEmlService.selectEmlRcvnListPage(vo);
    }

    /*****************************************************
     * 이메일 수신 상세 조회 (첨부파일 포함)
     * @param vo
     * @return MsgEmlVO
     ******************************************************/
    @Override
    public MsgEmlVO selectEmlRcvnDtlWithFiles(MsgEmlVO vo) {
        MsgEmlVO detail = msgEmlService.selectEmlRcvnDtl(vo);
        if (detail != null && detail.getFileCnt() > 0) {
            detail.setAtflList(selectAtflListByRefId(detail.getMsgId()));
        }
        return detail;
    }

    /*****************************************************
     * 이메일 읽음 처리
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int modifyEmlReadDttm(MsgEmlVO vo) {
        return msgEmlService.updateEmlReadDttm(vo);
    }

    /*****************************************************
     * 이메일 수신자 삭제
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int modifyEmlRcvrDelyn(MsgEmlVO vo) {
        return msgEmlService.updateEmlRcvrDelyn(vo);
    }

    /*****************************************************
     * 이메일 발신 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgEmlVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgEmlVO> selectEmlSndngListPage(MsgEmlVO vo) throws Exception {
        return msgEmlService.selectEmlSndngListPage(vo);
    }

    /*****************************************************
     * 이메일 발신 상세 조회 (첨부파일 포함)
     * @param vo
     * @return MsgEmlVO
     ******************************************************/
    @Override
    public MsgEmlVO selectEmlSndngDtlWithFiles(MsgEmlVO vo) {
        MsgEmlVO detail = msgEmlService.selectEmlSndngDtl(vo);
        if (detail != null && detail.getFileCnt() > 0) {
            detail.setAtflList(selectAtflListByRefId(detail.getMsgId()));
        }
        return detail;
    }

    /*****************************************************
     * 이메일 발신 수신자 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgEmlVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgEmlVO> selectEmlSndngRcvrListPage(MsgEmlVO vo) throws Exception {
        return msgEmlService.selectEmlSndngRcvrListPage(vo);
    }

    /*****************************************************
     * 이메일 발신자 삭제
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int modifyEmlSndngrDelyn(MsgEmlVO vo) {
        return msgEmlService.updateEmlSndngrDelyn(vo);
    }

    /*****************************************************
     * 이메일 발신 등록 (첨부파일 포함)
     * @param vo
     * @param uploadFiles
     * @param uploadPath
     * @throws Exception
     ******************************************************/
    @Override
    public void registEmlSndngWithFiles(MsgEmlVO vo, String uploadFiles, String uploadPath) throws Exception {
        vo.setDgrsYr(vo.getSbjctYr());
        vo.setSmstr(vo.getSbjctSmstr());

        msgEmlService.registEmlSndng(vo);

        if (StringUtil.isNotNull(uploadFiles)) {
            List<AtflVO> fileList = FileUtil.getUploadAtflList(uploadFiles, uploadPath);
            for (AtflVO atfl : fileList) {
                atfl.setRgtrId(vo.getRgtrId());
                atfl.setAtflRepoId(CommConst.REPO_MSG);
                atfl.setRefId(vo.getMsgId());
            }
            attachFileService.insertAtflList(fileList);
        }
    }

    /*****************************************************
     * 이메일 발신 수정 (첨부파일 포함)
     * @param vo
     * @param uploadFiles
     * @param uploadPath
     * @param delFileIds
     * @throws Exception
     ******************************************************/
    @Override
    public void modifyEmlSndngWithFiles(MsgEmlVO vo, String uploadFiles, String uploadPath, String[] delFileIds) throws Exception {
        vo.setDgrsYr(vo.getSbjctYr());
        vo.setSmstr(vo.getSbjctSmstr());

        msgEmlService.modifyEmlSndng(vo);

        if (StringUtil.isNotNull(uploadFiles)) {
            List<AtflVO> fileList = FileUtil.getUploadAtflList(uploadFiles, uploadPath);
            for (AtflVO atfl : fileList) {
                atfl.setRgtrId(vo.getMdfrId());
                atfl.setMdfrId(vo.getMdfrId());
                atfl.setAtflRepoId(CommConst.REPO_MSG);
                atfl.setRefId(vo.getMsgId());
            }
            attachFileService.insertAtflList(fileList);
        }

        if (delFileIds != null && delFileIds.length > 0) {
            attachFileService.deleteAtflByAtflIds(delFileIds);
        }
    }

    /*****************************************************
     * 예약 발신 취소
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int modifyMsgRsrvCncl(MsgEmlVO vo) {
        return msgEmlService.updateMsgRsrvCncl(vo);
    }

    /*****************************************************
     * 답장 모드 연계 일괄 조회
     * @param replyMsgEmlSndngId
     * @param userCtx
     * @return EgovMap
     ******************************************************/
    @Override
    public EgovMap loadReplyLinkInfo(String replyMsgEmlSndngId, UserContext userCtx) throws Exception {
        EgovMap result = new EgovMap();
        if (StringUtil.isNull(replyMsgEmlSndngId)) {
            return result;
        }

        MsgEmlVO reqVo = new MsgEmlVO();
        reqVo.setMsgEmlSndngId(replyMsgEmlSndngId);
        reqVo.setRcvrId(userCtx.getUserId());
        MsgEmlVO original = selectEmlRcvnDtlWithFiles(reqVo);
        if (original == null) {
            return result;
        }

        result.put("original",   original);
        result.put("sbjctYr",    StringUtil.nvl(original.getSbjctYr()).trim());
        result.put("sbjctSmstr", StringUtil.nvl(original.getSbjctSmstr()).trim());
        result.put("orgId",      StringUtil.nvl(original.getOrgId()).trim());
        result.put("sbjctId",    StringUtil.nvl(original.getSbjctId()).trim());
        result.put("sbjctnm",    StringUtil.nvl(original.getSbjctnm()));

        boolean isAdmin = MsgAuthUtil.isAdmin(userCtx);
        String userId = isAdmin ? null : userCtx.getUserId();

        MsgEmlVO smstrVo = new MsgEmlVO();
        smstrVo.setUserId(userId);
        smstrVo.setSbjctYr(original.getSbjctYr());
        List<EgovMap> replySmstrList = msgMgrService.selectSmstrList(toMgrVO(smstrVo));
        result.put("smstrList", ensureOriginalSmstr(replySmstrList, original));

        MsgEmlVO sbjctVo = new MsgEmlVO();
        sbjctVo.setUserId(userId);
        sbjctVo.setOrgId(original.getOrgId());
        sbjctVo.setSbjctYr(original.getSbjctYr());
        sbjctVo.setSbjctSmstr(original.getSbjctSmstr());
        List<MsgEmlVO> replySbjctList = toEmlList(msgMgrService.selectSbjctList(toMgrVO(sbjctVo)));
        result.put("sbjctList", ensureOriginalSbjct(replySbjctList, original));

        return result;
    }

    /*****************************************************
     * 수정 모드 연계 일괄 조회
     * @param msgId
     * @param userCtx
     * @return EgovMap
     ******************************************************/
    @Override
    public EgovMap loadEditLinkInfo(String msgId, UserContext userCtx) {
        EgovMap result = new EgovMap();
        if (StringUtil.isNull(msgId)) {
            return result;
        }

        MsgEmlVO reqVo = new MsgEmlVO();
        reqVo.setMsgId(msgId);
        MsgEmlVO original = selectEmlSndngDtlWithFiles(reqVo);
        if (original == null) {
            return result;
        }

        if (!userCtx.getUserId().equals(StringUtil.nvl(original.getSndngrId()))) {
            return result;
        }

        result.put("original",   original);
        result.put("sbjctYr",    StringUtil.nvl(original.getSbjctYr()).trim());
        result.put("sbjctSmstr", StringUtil.nvl(original.getSbjctSmstr()).trim());
        result.put("orgId",      StringUtil.nvl(original.getOrgId()).trim());
        result.put("sbjctId",    StringUtil.nvl(original.getSbjctId()).trim());
        result.put("sbjctnm",    StringUtil.nvl(original.getSbjctnm()));

        boolean isAdmin = MsgAuthUtil.isAdmin(userCtx);
        String userId = isAdmin ? null : userCtx.getUserId();

        MsgEmlVO smstrVo = new MsgEmlVO();
        smstrVo.setUserId(userId);
        smstrVo.setSbjctYr(original.getSbjctYr());
        List<EgovMap> editSmstrList = msgMgrService.selectSmstrList(toMgrVO(smstrVo));
        result.put("smstrList", ensureOriginalSmstr(editSmstrList, original));

        MsgEmlVO sbjctVo = new MsgEmlVO();
        sbjctVo.setUserId(userId);
        sbjctVo.setOrgId(original.getOrgId());
        sbjctVo.setSbjctYr(original.getSbjctYr());
        sbjctVo.setSbjctSmstr(original.getSbjctSmstr());
        List<MsgEmlVO> editSbjctList = toEmlList(msgMgrService.selectSbjctList(toMgrVO(sbjctVo)));
        result.put("sbjctList", ensureOriginalSbjct(editSbjctList, original));

        return result;
    }

    /*****************************************************
     * 원본 과목 보강
     * @param sbjctList
     * @param original
     * @return List<MsgEmlVO>
     ******************************************************/
    private List<MsgEmlVO> ensureOriginalSbjct(List<MsgEmlVO> sbjctList, MsgEmlVO original) {
        if (sbjctList == null || original == null) {
            return sbjctList;
        }
        String origSbjctId = StringUtil.nvl(original.getSbjctId()).trim();
        if (StringUtil.isNull(origSbjctId)) {
            return sbjctList;
        }
        for (MsgEmlVO s : sbjctList) {
            if (origSbjctId.equals(StringUtil.nvl(s.getSbjctId()).trim())) {
                return sbjctList;
            }
        }
        MsgEmlVO keeper = new MsgEmlVO();
        keeper.setSbjctId(origSbjctId);
        keeper.setSbjctnm(StringUtil.nvl(original.getSbjctnm()));
        sbjctList.add(0, keeper);
        return sbjctList;
    }

    /*****************************************************
     * 원본 학기 보강
     * @param smstrList
     * @param original
     * @return List<EgovMap>
     ******************************************************/
    private List<EgovMap> ensureOriginalSmstr(List<EgovMap> smstrList, MsgEmlVO original) {
        if (smstrList == null || original == null) {
            return smstrList;
        }
        String origSmstr = StringUtil.nvl(original.getSbjctSmstr()).trim();
        if (StringUtil.isNull(origSmstr)) {
            return smstrList;
        }
        for (EgovMap s : smstrList) {
            Object v = s.get("sbjctSmstr");
            if (v != null && origSmstr.equals(StringUtil.nvl(v.toString()).trim())) {
                return smstrList;
            }
        }
        EgovMap keeper = new EgovMap();
        keeper.put("sbjctSmstr", origSmstr);
        smstrList.add(0, keeper);
        return smstrList;
    }

    /*****************************************************
     * 원본 학사년도 보강
     * @param yrList
     * @param original
     * @return List<MsgEmlVO>
     ******************************************************/
    private List<MsgEmlVO> ensureOriginalYr(List<MsgEmlVO> yrList, MsgEmlVO original) {
        if (yrList == null || original == null) {
            return yrList;
        }
        String origYr = StringUtil.nvl(original.getSbjctYr()).trim();
        if (StringUtil.isNull(origYr)) {
            return yrList;
        }
        for (MsgEmlVO y : yrList) {
            if (origYr.equals(StringUtil.nvl(y.getSbjctYr()).trim())) {
                return yrList;
            }
        }
        MsgEmlVO keeper = new MsgEmlVO();
        keeper.setSbjctYr(origYr);
        yrList.add(0, keeper);
        return yrList;
    }

    /*****************************************************
     * 원본 기관 보강
     * @param orgList
     * @param original
     * @return List<OrgInfoVO>
     ******************************************************/
    private List<OrgInfoVO> ensureOriginalOrg(List<OrgInfoVO> orgList, MsgEmlVO original) {
        if (orgList == null || original == null) {
            return orgList;
        }
        String origOrgId = StringUtil.nvl(original.getOrgId()).trim();
        if (StringUtil.isNull(origOrgId)) {
            return orgList;
        }
        for (OrgInfoVO o : orgList) {
            if (origOrgId.equals(StringUtil.nvl(o.getOrgId()).trim())) {
                return orgList;
            }
        }
        OrgInfoVO keeper = new OrgInfoVO();
        keeper.setOrgId(origOrgId);
        keeper.setOrgnm(StringUtil.nvl(original.getOrgnm()));
        orgList.add(0, keeper);
        return orgList;
    }

    /*****************************************************
     * filterOptions에 원본 학사년도/기관 보강
     * @param filterOptions
     * @param original
     ******************************************************/
    @SuppressWarnings("unchecked")
    @Override
    public void applyOriginalToFilterOptions(EgovMap filterOptions, MsgEmlVO original) {
        if (filterOptions == null || original == null) {
            return;
        }
        List<MsgEmlVO> yrList = (List<MsgEmlVO>) filterOptions.get("yrList");
        if (yrList != null) {
            ensureOriginalYr(yrList, original);
        }
        List<OrgInfoVO> orgList = (List<OrgInfoVO>) filterOptions.get("orgList");
        if (orgList != null) {
            ensureOriginalOrg(orgList, original);
        }
    }

    /*****************************************************
     * 엑셀 파일 파싱 후 수신자 검색
     * @param excelInputStream
     * @param orgId
     * @return List<MsgEmlVO>
     ******************************************************/
    @Override
    public List<MsgEmlVO> parseExcelAndSearchRcvr(InputStream excelInputStream, String orgId) throws Exception {
        Workbook workbook = WorkbookFactory.create(excelInputStream);
        Sheet sheet = workbook.getSheetAt(0);

        DataFormatter formatter = new DataFormatter();
        List<String> userIdList = new ArrayList<>();

        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
            Row row = sheet.getRow(i);
            if (row == null) continue;
            String userId = formatter.formatCellValue(row.getCell(0)).trim();
            if (!userId.isEmpty()) {
                userIdList.add(userId);
            }
        }
        workbook.close();

        if (userIdList.isEmpty()) {
            return new ArrayList<>();
        }

        MsgMgrVO mgr = new MsgMgrVO();
        mgr.setUserIdList(userIdList);
        mgr.setOrgId(orgId);
        return toEmlRcvrList(msgMgrService.selectRcvrByUserIds(mgr));
    }

    /*****************************************************
     * 수신 대상자 목록 조회
     * @param vo
     * @return List<MsgEmlVO>
     ******************************************************/
    @Override
    public List<MsgEmlVO> selectMsgRcvTrgtrList(MsgEmlVO vo) {
        return msgEmlService.selectMsgRcvTrgtrList(vo);
    }

    /*****************************************************
     * 목록 화면 초기 데이터 조회
     * @param vo
     * @return MsgEmlVO
     ******************************************************/
    @Override
    public MsgEmlVO loadListViewInfo(MsgEmlVO vo) throws Exception {
        if (vo.getSbjctYr() == null || vo.getSbjctYr().isEmpty()) {
            vo.setSbjctYr(DateTimeUtil.getYear());
        }
        if (vo.getOrgId() != null && !"".equals(vo.getOrgId())) {
            OrgInfoVO param = new OrgInfoVO();
            param.setOrgId(vo.getOrgId());
            OrgInfoVO org = orgInfoService.select(param);
            if (org == null) {
                return null;
            }
            vo.setOrgnm(org.getOrgnm());
        }

        if (StringUtil.isNotNull(vo.getUserId())) {
            UserPrfilVO prfilParam = new UserPrfilVO();
            prfilParam.setUserId(vo.getUserId());
            UserPrfilVO userPrfil = userPrfilDAO.userPrfilSelect(prfilParam);
            if (userPrfil != null) {
                vo.setUserNm(userPrfil.getUsernm());
            }
        }

        return vo;
    }

    /*****************************************************
     * 발신 화면 공통 데이터 조회
     * @param msgId
     * @param userId
     * @param hasSndngAuth
     * @return EgovMap
     ******************************************************/
    @Override
    public EgovMap loadSndngRegistViewInfo(String msgId, String userId, boolean hasSndngAuth) throws Exception {
        EgovMap result = new EgovMap();

        UserPrfilVO prfilParam = new UserPrfilVO();
        prfilParam.setUserId(userId);
        UserPrfilVO userPrfil = userPrfilDAO.userPrfilSelect(prfilParam);
        result.put("userNm", userPrfil != null ? StringUtil.nvl(userPrfil.getUsernm()) : "");
        result.put("userEml", userPrfil != null ? StringUtil.nvl(userPrfil.getIndvEml()) : "");

        if (StringUtil.isNotNull(msgId)) {
            if (!hasSndngAuth) {
                MsgEmlVO checkVO = new MsgEmlVO();
                checkVO.setMsgId(msgId);
                checkVO.setSndngrId(userId);
                MsgEmlVO detail = selectEmlSndngDtlWithFiles(checkVO);
                if (detail == null) {
                    result.put("hasAuth", false);
                    return result;
                }
            }
            result.put("hasAuth", true);
            result.put("fileList", selectAtflListByRefId(msgId));
        } else {
            result.put("hasAuth", true);
        }

        return result;
    }

    /*****************************************************
     * 조회 필터 옵션 조회
     * @param vo
     * @return EgovMap
     ******************************************************/
    @Override
    public EgovMap loadFilterOptions(MsgEmlVO vo) throws Exception {
        EgovMap filterOptions = new EgovMap();

        MsgMgrVO mgr = toMgrVO(vo);
        filterOptions.put("yrList", toEmlList(msgMgrService.selectYrList(mgr)));
        filterOptions.put("smstrList", msgMgrService.selectSmstrList(mgr));
        filterOptions.put("sbjctList", toEmlList(msgMgrService.selectSbjctList(mgr)));

        return filterOptions;
    }

    /*****************************************************
     * 발신 화면 필터 옵션 조회
     * @param userCtx
     * @return EgovMap
     ******************************************************/
    @Override
    public EgovMap loadSndngRegistFilterOptions(UserContext userCtx) throws Exception {
        boolean isAdmin = MsgAuthUtil.isAdmin(userCtx);
        String userId  = isAdmin ? null : userCtx.getUserId();

        MsgEmlVO yrVo = new MsgEmlVO();
        yrVo.setUserId(userId);
        List<MsgEmlVO> yrList = toEmlList(msgMgrService.selectYrList(toMgrVO(yrVo)));

        List<OrgInfoVO> orgList = isAdmin
                ? selectActiveOrgListByAuth(userCtx.getUserId(), true)
                : selectProfSbjctOrgList(userCtx.getUserId());

        EgovMap filterOptions = new EgovMap();
        filterOptions.put("yrList",  yrList);
        filterOptions.put("orgList", orgList);
        return filterOptions;
    }
}
