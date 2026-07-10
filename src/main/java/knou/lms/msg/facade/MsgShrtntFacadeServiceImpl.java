package knou.lms.msg.facade;

import knou.framework.common.CommConst;
import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.framework.util.FileUtil;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import knou.lms.msg.service.MsgMgrService;
import knou.lms.msg.service.MsgRcptnAuthService;
import knou.lms.msg.service.MsgShrtntService;
import knou.lms.msg.vo.MsgMgrVO;
import knou.lms.msg.vo.MsgShrtntVO;
import knou.lms.msg.web.util.MsgAuthUtil;
import knou.lms.org.service.OrgInfoService;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.user.dao.UserPrfilDAO;
import knou.lms.user.vo.UserPrfilVO;
import org.apache.poi.ss.usermodel.*;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service("msgShrtntFacadeService")
public class MsgShrtntFacadeServiceImpl extends ServiceBase implements MsgShrtntFacadeService {

    @Resource(name = "msgShrtntService")
    private MsgShrtntService msgShrtntService;

    @Resource(name = "msgMgrService")
    private MsgMgrService msgMgrService;

    @Resource(name = "orgInfoService")
    private OrgInfoService orgInfoService;

    @Resource(name = "attachFileService")
    private AttachFileService attachFileService;

    @Resource(name = "userPrfilDAO")
    private UserPrfilDAO userPrfilDAO;

    @Resource(name = "msgRcptnAuthService")
    private MsgRcptnAuthService msgRcptnAuthService;

    /*****************************************************
     * 채널 VO → 공통 MsgMgrVO 변환 (검색 조건)
     * @param s
     * @return MsgMgrVO
     ******************************************************/
    private MsgMgrVO toMgrVO(MsgShrtntVO s) {
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
     * @return List<MsgShrtntVO>
     ******************************************************/
    private List<MsgShrtntVO> toShrtntList(List<MsgMgrVO> src) {
        List<MsgShrtntVO> result = new ArrayList<>();
        if (src == null) {
            return result;
        }
        for (MsgMgrVO m : src) {
            MsgShrtntVO p = new MsgShrtntVO();
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
     * @return List<MsgShrtntVO>
     ******************************************************/
    private List<MsgShrtntVO> toShrtntRcvrList(List<MsgMgrVO> src) {
        List<MsgShrtntVO> result = new ArrayList<>();
        if (src == null) {
            return result;
        }
        for (MsgMgrVO m : src) {
            MsgShrtntVO p = new MsgShrtntVO();
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
     * 기관 목록 조회
     * @param userId
     * @param isAdmin
     * @return List<OrgInfoVO>
     * @throws Exception
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
     * 쪽지 수신 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<MsgShrtntVO> selectShrtntRcvnListPage(MsgShrtntVO vo) throws Exception{
        return msgShrtntService.selectShrtntRcvnListPage(vo);
    }

    /*****************************************************
     * 쪽지 수신 상세 조회
     * @param vo
     * @return MsgShrtntVO
     ******************************************************/
    @Override
    public MsgShrtntVO selectShrtntRcvnDtlWithFiles(MsgShrtntVO vo) {
        MsgShrtntVO detail = msgShrtntService.selectShrtntRcvnDtl(vo);
        if (detail != null && detail.getFileCnt() > 0) {
            detail.setAtflList(selectAtflListByRefId(detail.getMsgId()));
        }
        return detail;
    }

    /*****************************************************
     * 쪽지 읽음 처리
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int modifyShrtntReadDttm(MsgShrtntVO vo) {
        return msgShrtntService.updateShrtntReadDttm(vo);
    }

    /*****************************************************
     * 쪽지 수신자 삭제
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int modifyShrtntRcvrDelyn(MsgShrtntVO vo) {
        return msgShrtntService.updateShrtntRcvrDelyn(vo);
    }

    /*****************************************************
     * 쪽지 발신 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<MsgShrtntVO> selectShrtntSndngListPage(MsgShrtntVO vo) throws Exception {
        return msgShrtntService.selectShrtntSndngListPage(vo);
    }

    /*****************************************************
     * 쪽지 발신 상세 조회
     * @param vo
     * @return MsgShrtntVO
     ******************************************************/
    @Override
    public MsgShrtntVO selectShrtntSndngDtlWithFiles(MsgShrtntVO vo) {
        MsgShrtntVO detail = msgShrtntService.selectShrtntSndngDtl(vo);
        if (detail != null && detail.getFileCnt() > 0) {
            detail.setAtflList(selectAtflListByRefId(detail.getMsgId()));
        }
        return detail;
    }

    /*****************************************************
     * 쪽지 발신 수신자 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<MsgShrtntVO> selectShrtntSndngRcvrListPage(MsgShrtntVO vo) throws Exception {
        return msgShrtntService.selectShrtntSndngRcvrListPage(vo);
    }

    /*****************************************************
     * 쪽지 발신자 삭제
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int modifyShrtntSndngrDelyn(MsgShrtntVO vo) {
        return msgShrtntService.updateShrtntSndngrDelyn(vo);
    }

    /*****************************************************
     * 쪽지 발신 수신자 엑셀 목록 조회
     * @param vo
     * @return List<MsgShrtntVO>
     ******************************************************/
    @Override
    public List<MsgShrtntVO> selectShrtntSndngRcvrExcelList(MsgShrtntVO vo) {
        return msgShrtntService.selectShrtntSndngRcvrExcelList(vo);
    }

    /*****************************************************
     * 쪽지 발신 등록
     * @param vo
     * @param uploadFiles
     * @param uploadPath
     * @throws Exception
     ******************************************************/
    @Override
    public void registShrtntSndngWithFiles(MsgShrtntVO vo, String uploadFiles, String uploadPath) throws Exception {
        vo.setDgrsYr(vo.getSbjctYr());
        vo.setSmstr(vo.getSbjctSmstr());

        msgShrtntService.registShrtntSndng(vo);

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
     * 쪽지 발신 수정
     * @param vo
     * @param uploadFiles
     * @param uploadPath
     * @param delFileIds
     * @throws Exception
     ******************************************************/
    @Override
    public void modifyShrtntSndngWithFiles(MsgShrtntVO vo, String uploadFiles, String uploadPath, String[] delFileIds) throws Exception {
        vo.setDgrsYr(vo.getSbjctYr());
        vo.setSmstr(vo.getSbjctSmstr());

        msgShrtntService.modifyShrtntSndng(vo);

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
     * 엑셀 파일 파싱 후 수신자 검색
     * @param excelInputStream
     * @param orgId
     * @return List<MsgShrtntVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<MsgShrtntVO> parseExcelAndSearchRcvr(InputStream excelInputStream, String orgId) throws Exception {
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
        return toShrtntRcvrList(msgMgrService.selectRcvrByUserIds(mgr));
    }

    /*****************************************************
     * 예약 발신 취소
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int modifyMsgRsrvCncl(MsgShrtntVO vo) {
        return msgShrtntService.updateMsgRsrvCncl(vo);
    }

    /*****************************************************
     * 수신 대상자 목록 조회
     * @param vo
     * @return List<MsgShrtntVO>
     ******************************************************/
    @Override
    public List<MsgShrtntVO> selectMsgRcvTrgtrList(MsgShrtntVO vo) {
        return msgShrtntService.selectMsgRcvTrgtrList(vo);
    }

    /*****************************************************
     * 목록 화면 초기 데이터 조회
     * @param vo
     * @return MsgShrtntVO
     * @throws Exception
     ******************************************************/
    @Override
    public MsgShrtntVO loadListViewInfo(MsgShrtntVO vo) throws Exception {
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
    public EgovMap loadSndngRegistViewInfo(String msgId, String userId, boolean hasSndngAuth) {
        EgovMap result = new EgovMap();

        UserPrfilVO prfilParam = new UserPrfilVO();
        prfilParam.setUserId(userId);
        UserPrfilVO userPrfil = userPrfilDAO.userPrfilSelect(prfilParam);
        result.put("userNm", userPrfil != null ? StringUtil.nvl(userPrfil.getUsernm()) : "");

        if (StringUtil.isNotNull(msgId)) {
            if (!hasSndngAuth) {
                MsgShrtntVO checkVO = new MsgShrtntVO();
                checkVO.setMsgId(msgId);
                checkVO.setSndngrId(userId);
                MsgShrtntVO detail = selectShrtntSndngDtlWithFiles(checkVO);
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
    public EgovMap loadFilterOptions(MsgShrtntVO vo) {
        EgovMap filterOptions = new EgovMap();

        MsgMgrVO mgr = toMgrVO(vo);
        filterOptions.put("yrList", toShrtntList(msgMgrService.selectYrList(mgr)));
        filterOptions.put("smstrList", msgMgrService.selectSmstrList(mgr));
        filterOptions.put("sbjctList", toShrtntList(msgMgrService.selectSbjctList(mgr)));

        return filterOptions;
    }

    /*****************************************************
     * 학생 수강과목 기준 조회 필터 옵션 조회
     * @param vo
     * @return EgovMap
     ******************************************************/
    @Override
    public EgovMap loadStdntFilterOptions(MsgShrtntVO vo) {
        EgovMap filterOptions = new EgovMap();

        MsgMgrVO mgr = toMgrVO(vo);
        filterOptions.put("yrList", toShrtntList(msgMgrService.selectStdntYrList(mgr)));
        filterOptions.put("smstrList", msgMgrService.selectStdntSmstrList(mgr));
        filterOptions.put("sbjctList", toShrtntList(msgMgrService.selectStdntSbjctList(mgr)));

        return filterOptions;
    }

    /*****************************************************
     * 발신 화면 필터 옵션 조회
     * @param userCtx
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    @Override
    public EgovMap loadSndngRegistFilterOptions(UserContext userCtx) throws Exception {
        boolean isAdmin = MsgAuthUtil.isAdmin(userCtx);
        String userId  = isAdmin ? null : userCtx.getUserId();

        MsgShrtntVO yrVo = new MsgShrtntVO();
        yrVo.setUserId(userId);
        List<MsgShrtntVO> yrList = toShrtntList(msgMgrService.selectYrList(toMgrVO(yrVo)));

        List<OrgInfoVO> orgList = isAdmin
                ? selectActiveOrgListByAuth(userCtx.getUserId(), true)
                : selectProfSbjctOrgList(userCtx.getUserId());

        EgovMap filterOptions = new EgovMap();
        filterOptions.put("yrList",  yrList);
        filterOptions.put("orgList", orgList);
        return filterOptions;
    }

    /*****************************************************
     * 답장 모드 연계 일괄 조회
     * @param replyMsgShrtntSndngId
     * @param userCtx
     * @return EgovMap
     ******************************************************/
    @Override
    public EgovMap loadReplyLinkInfo(String replyMsgShrtntSndngId, UserContext userCtx) {
        EgovMap result = new EgovMap();
        if (StringUtil.isNull(replyMsgShrtntSndngId)) {
            return result;
        }

        MsgShrtntVO reqVo = new MsgShrtntVO();
        reqVo.setMsgShrtntSndngId(replyMsgShrtntSndngId);
        reqVo.setRcvrId(userCtx.getUserId());
        MsgShrtntVO original = selectShrtntRcvnDtlWithFiles(reqVo);
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

        MsgShrtntVO smstrVo = new MsgShrtntVO();
        smstrVo.setUserId(userId);
        smstrVo.setSbjctYr(original.getSbjctYr());
        List<EgovMap> replySmstrList = msgMgrService.selectSmstrList(toMgrVO(smstrVo));
        result.put("smstrList", ensureOriginalSmstr(replySmstrList, original));

        MsgShrtntVO sbjctVo = new MsgShrtntVO();
        sbjctVo.setUserId(userId);
        sbjctVo.setOrgId(original.getOrgId());
        sbjctVo.setSbjctYr(original.getSbjctYr());
        sbjctVo.setSbjctSmstr(original.getSbjctSmstr());
        List<MsgShrtntVO> replySbjctList = toShrtntList(msgMgrService.selectSbjctList(toMgrVO(sbjctVo)));
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

        MsgShrtntVO reqVo = new MsgShrtntVO();
        reqVo.setMsgId(msgId);
        MsgShrtntVO original = selectShrtntSndngDtlWithFiles(reqVo);
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

        MsgShrtntVO smstrVo = new MsgShrtntVO();
        smstrVo.setUserId(userId);
        smstrVo.setSbjctYr(original.getSbjctYr());
        List<EgovMap> editSmstrList = msgMgrService.selectSmstrList(toMgrVO(smstrVo));
        result.put("smstrList", ensureOriginalSmstr(editSmstrList, original));

        MsgShrtntVO sbjctVo = new MsgShrtntVO();
        sbjctVo.setUserId(userId);
        sbjctVo.setOrgId(original.getOrgId());
        sbjctVo.setSbjctYr(original.getSbjctYr());
        sbjctVo.setSbjctSmstr(original.getSbjctSmstr());
        List<MsgShrtntVO> editSbjctList = toShrtntList(msgMgrService.selectSbjctList(toMgrVO(sbjctVo)));
        result.put("sbjctList", ensureOriginalSbjct(editSbjctList, original));

        return result;
    }

    /*****************************************************
     * 원본 과목 보강
     * @param sbjctList
     * @param original
     * @return List<MsgShrtntVO>
     ******************************************************/
    private List<MsgShrtntVO> ensureOriginalSbjct(List<MsgShrtntVO> sbjctList, MsgShrtntVO original) {
        if (sbjctList == null || original == null) {
            return sbjctList;
        }
        String origSbjctId = StringUtil.nvl(original.getSbjctId()).trim();
        if (StringUtil.isNull(origSbjctId)) {
            return sbjctList;
        }
        for (MsgShrtntVO s : sbjctList) {
            if (origSbjctId.equals(StringUtil.nvl(s.getSbjctId()).trim())) {
                return sbjctList;
            }
        }
        MsgShrtntVO keeper = new MsgShrtntVO();
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
    private List<EgovMap> ensureOriginalSmstr(List<EgovMap> smstrList, MsgShrtntVO original) {
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
     * @return List<MsgShrtntVO>
     ******************************************************/
    private List<MsgShrtntVO> ensureOriginalYr(List<MsgShrtntVO> yrList, MsgShrtntVO original) {
        if (yrList == null || original == null) {
            return yrList;
        }
        String origYr = StringUtil.nvl(original.getSbjctYr()).trim();
        if (StringUtil.isNull(origYr)) {
            return yrList;
        }
        for (MsgShrtntVO y : yrList) {
            if (origYr.equals(StringUtil.nvl(y.getSbjctYr()).trim())) {
                return yrList;
            }
        }
        MsgShrtntVO keeper = new MsgShrtntVO();
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
    private List<OrgInfoVO> ensureOriginalOrg(List<OrgInfoVO> orgList, MsgShrtntVO original) {
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
    public void applyOriginalToFilterOptions(EgovMap filterOptions, MsgShrtntVO original) {
        if (filterOptions == null || original == null) {
            return;
        }
        List<MsgShrtntVO> yrList = (List<MsgShrtntVO>) filterOptions.get("yrList");
        if (yrList != null) {
            ensureOriginalYr(yrList, original);
        }
        List<OrgInfoVO> orgList = (List<OrgInfoVO>) filterOptions.get("orgList");
        if (orgList != null) {
            ensureOriginalOrg(orgList, original);
        }
    }

    /*****************************************************
     * 쪽지 수신거부 건수 조회
     * @param rcvrListJson
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    @Override
    public EgovMap selectRcptnRjctCnt(String rcvrListJson) throws Exception {
        EgovMap result = new EgovMap();
        result.put("totalCnt", 0);
        result.put("allowedCnt", 0);
        result.put("rejectedCnt", 0);

        if (StringUtil.isNull(rcvrListJson)) {
            return result;
        }

        JSONParser parser = new JSONParser();
        JSONArray rcvrArr = (JSONArray) parser.parse(rcvrListJson);

        List<String> userIds = new ArrayList<>(rcvrArr.size());
        Set<String> dedup = new HashSet<>();
        for (int i = 0; i < rcvrArr.size(); i++) {
            JSONObject rcvr = (JSONObject) rcvrArr.get(i);
            String userId = (String) rcvr.get("userId");
            if (StringUtil.isNotNull(userId) && dedup.add(userId)) {
                userIds.add(userId);
            }
        }

        int total = userIds.size();
        int rejected = msgRcptnAuthService.selectRcptnPrmNoUserIdList(userIds, CommConst.MSG_CHNL_SHRTNT).size();

        result.put("totalCnt", total);
        result.put("allowedCnt", total - rejected);
        result.put("rejectedCnt", rejected);
        return result;
    }
}
