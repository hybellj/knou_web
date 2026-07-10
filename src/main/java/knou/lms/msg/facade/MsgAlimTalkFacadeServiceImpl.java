package knou.lms.msg.facade;

import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.service.MsgMgrService;
import knou.lms.msg.service.MsgAlimTalkService;
import knou.lms.msg.vo.MsgMgrVO;
import knou.lms.msg.vo.MsgAlimTalkVO;
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

@Service("msgAlimTalkFacadeService")
public class MsgAlimTalkFacadeServiceImpl extends ServiceBase implements MsgAlimTalkFacadeService {

    @Resource(name = "msgAlimTalkService")
    private MsgAlimTalkService msgAlimTalkService;

    @Resource(name = "msgMgrService")
    private MsgMgrService msgMgrService;

    @Resource(name = "orgInfoService")
    private OrgInfoService orgInfoService;

    @Resource(name = "userPrfilDAO")
    private UserPrfilDAO userPrfilDAO;

    /*****************************************************
     * 채널 VO → 공통 MsgMgrVO 변환 (검색 조건)
     * @param s
     * @return MsgMgrVO
     ******************************************************/
    private MsgMgrVO toMgrVO(MsgAlimTalkVO s) {
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
     * @return List<MsgAlimTalkVO>
     ******************************************************/
    private List<MsgAlimTalkVO> toAlimTalkList(List<MsgMgrVO> src) {
        List<MsgAlimTalkVO> result = new ArrayList<>();
        if (src == null) {
            return result;
        }
        for (MsgMgrVO m : src) {
            MsgAlimTalkVO p = new MsgAlimTalkVO();
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
     * @return List<MsgAlimTalkVO>
     ******************************************************/
    private List<MsgAlimTalkVO> toAlimTalkRcvrList(List<MsgMgrVO> src) {
        List<MsgAlimTalkVO> result = new ArrayList<>();
        if (src == null) {
            return result;
        }
        for (MsgMgrVO m : src) {
            MsgAlimTalkVO p = new MsgAlimTalkVO();
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
     * 알림톡 수신 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgAlimTalkVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgAlimTalkVO> selectAlimTalkRcvnListPage(MsgAlimTalkVO vo) throws Exception {
        return msgAlimTalkService.selectAlimTalkRcvnListPage(vo);
    }

    /*****************************************************
     * 알림톡 수신 상세 조회
     * @param vo
     * @return MsgAlimTalkVO
     ******************************************************/
    @Override
    public MsgAlimTalkVO selectAlimTalkRcvnDtl(MsgAlimTalkVO vo) {
        return msgAlimTalkService.selectAlimTalkRcvnDtl(vo);
    }

    /*****************************************************
     * 알림톡 읽음 처리
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int modifyAlimTalkReadDttm(MsgAlimTalkVO vo) {
        return msgAlimTalkService.updateAlimTalkReadDttm(vo);
    }

    /*****************************************************
     * 알림톡 수신자 삭제
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int modifyAlimTalkRcvrDelyn(MsgAlimTalkVO vo) {
        return msgAlimTalkService.updateAlimTalkRcvrDelyn(vo);
    }

    /*****************************************************
     * 알림톡 발신 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgAlimTalkVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgAlimTalkVO> selectAlimTalkSndngListPage(MsgAlimTalkVO vo) throws Exception {
        return msgAlimTalkService.selectAlimTalkSndngListPage(vo);
    }

    /*****************************************************
     * 알림톡 발신 상세 조회
     * @param vo
     * @return MsgAlimTalkVO
     ******************************************************/
    @Override
    public MsgAlimTalkVO selectAlimTalkSndngDtl(MsgAlimTalkVO vo) {
        return msgAlimTalkService.selectAlimTalkSndngDtl(vo);
    }

    /*****************************************************
     * 알림톡 발신 수신자 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgAlimTalkVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgAlimTalkVO> selectAlimTalkSndngRcvrListPage(MsgAlimTalkVO vo) throws Exception {
        return msgAlimTalkService.selectAlimTalkSndngRcvrListPage(vo);
    }

    /*****************************************************
     * 알림톡 발신자 삭제
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int modifyAlimTalkSndngrDelyn(MsgAlimTalkVO vo) {
        return msgAlimTalkService.updateAlimTalkSndngrDelyn(vo);
    }

    /*****************************************************
     * 알림톡 발신 등록
     * @param vo
     ******************************************************/
    @Override
    public void registAlimTalkSndng(MsgAlimTalkVO vo) throws Exception {
        vo.setDgrsYr(vo.getSbjctYr());
        vo.setSmstr(vo.getSbjctSmstr());

        msgAlimTalkService.registAlimTalkSndng(vo);
    }

    /*****************************************************
     * 알림톡 발신 수정
     * @param vo
     ******************************************************/
    @Override
    public void modifyAlimTalkSndng(MsgAlimTalkVO vo) throws Exception {
        vo.setDgrsYr(vo.getSbjctYr());
        vo.setSmstr(vo.getSbjctSmstr());

        msgAlimTalkService.modifyAlimTalkSndng(vo);
    }

    /*****************************************************
     * 예약 발신 취소
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int modifyMsgRsrvCncl(MsgAlimTalkVO vo) {
        return msgAlimTalkService.updateMsgRsrvCncl(vo);
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

        MsgAlimTalkVO reqVo = new MsgAlimTalkVO();
        reqVo.setMsgId(msgId);
        reqVo.setMblSndngTycd(knou.framework.common.CommConst.MSG_CHNL_ALIM_TALK);
        MsgAlimTalkVO original = selectAlimTalkSndngDtl(reqVo);
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

        MsgAlimTalkVO smstrVo = new MsgAlimTalkVO();
        smstrVo.setUserId(userId);
        smstrVo.setSbjctYr(original.getSbjctYr());
        List<EgovMap> editSmstrList = msgMgrService.selectSmstrList(toMgrVO(smstrVo));
        result.put("smstrList", ensureOriginalSmstr(editSmstrList, original));

        MsgAlimTalkVO sbjctVo = new MsgAlimTalkVO();
        sbjctVo.setUserId(userId);
        sbjctVo.setOrgId(original.getOrgId());
        sbjctVo.setSbjctYr(original.getSbjctYr());
        sbjctVo.setSbjctSmstr(original.getSbjctSmstr());
        List<MsgAlimTalkVO> editSbjctList = toAlimTalkList(msgMgrService.selectSbjctList(toMgrVO(sbjctVo)));
        result.put("sbjctList", ensureOriginalSbjct(editSbjctList, original));

        return result;
    }

    /*****************************************************
     * 원본 과목 보강
     * @param sbjctList
     * @param original
     * @return List<MsgAlimTalkVO>
     ******************************************************/
    private List<MsgAlimTalkVO> ensureOriginalSbjct(List<MsgAlimTalkVO> sbjctList, MsgAlimTalkVO original) {
        if (sbjctList == null || original == null) {
            return sbjctList;
        }
        String origSbjctId = StringUtil.nvl(original.getSbjctId()).trim();
        if (StringUtil.isNull(origSbjctId)) {
            return sbjctList;
        }
        for (MsgAlimTalkVO s : sbjctList) {
            if (origSbjctId.equals(StringUtil.nvl(s.getSbjctId()).trim())) {
                return sbjctList;
            }
        }
        MsgAlimTalkVO keeper = new MsgAlimTalkVO();
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
    private List<EgovMap> ensureOriginalSmstr(List<EgovMap> smstrList, MsgAlimTalkVO original) {
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
     * @return List<MsgAlimTalkVO>
     ******************************************************/
    private List<MsgAlimTalkVO> ensureOriginalYr(List<MsgAlimTalkVO> yrList, MsgAlimTalkVO original) {
        if (yrList == null || original == null) {
            return yrList;
        }
        String origYr = StringUtil.nvl(original.getSbjctYr()).trim();
        if (StringUtil.isNull(origYr)) {
            return yrList;
        }
        for (MsgAlimTalkVO y : yrList) {
            if (origYr.equals(StringUtil.nvl(y.getSbjctYr()).trim())) {
                return yrList;
            }
        }
        MsgAlimTalkVO keeper = new MsgAlimTalkVO();
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
    private List<OrgInfoVO> ensureOriginalOrg(List<OrgInfoVO> orgList, MsgAlimTalkVO original) {
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
    public void applyOriginalToFilterOptions(EgovMap filterOptions, MsgAlimTalkVO original) {
        if (filterOptions == null || original == null) {
            return;
        }
        List<MsgAlimTalkVO> yrList = (List<MsgAlimTalkVO>) filterOptions.get("yrList");
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
     * @return List<MsgAlimTalkVO>
     ******************************************************/
    @Override
    public List<MsgAlimTalkVO> parseExcelAndSearchRcvr(InputStream excelInputStream, String orgId) throws Exception {
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
        return toAlimTalkRcvrList(msgMgrService.selectRcvrByUserIds(mgr));
    }

    /*****************************************************
     * 수신 대상자 목록 조회
     * @param vo
     * @return List<MsgAlimTalkVO>
     ******************************************************/
    @Override
    public List<MsgAlimTalkVO> selectMsgRcvTrgtrList(MsgAlimTalkVO vo) {
        return msgAlimTalkService.selectMsgRcvTrgtrList(vo);
    }

    /*****************************************************
     * 목록 화면 초기 데이터 조회
     * @param vo
     * @return MsgAlimTalkVO
     ******************************************************/
    @Override
    public MsgAlimTalkVO loadListViewInfo(MsgAlimTalkVO vo) throws Exception {
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
        result.put("userMblPhn", userPrfil != null ? StringUtil.nvl(userPrfil.getMblPhn()) : "");

        if (StringUtil.isNotNull(msgId)) {
            if (!hasSndngAuth) {
                MsgAlimTalkVO checkVO = new MsgAlimTalkVO();
                checkVO.setMsgId(msgId);
                checkVO.setSndngrId(userId);
                MsgAlimTalkVO detail = selectAlimTalkSndngDtl(checkVO);
                if (detail == null) {
                    result.put("hasAuth", false);
                    return result;
                }
            }
            result.put("hasAuth", true);
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
    public EgovMap loadFilterOptions(MsgAlimTalkVO vo) throws Exception {
        EgovMap filterOptions = new EgovMap();

        MsgMgrVO mgr = toMgrVO(vo);
        filterOptions.put("yrList", toAlimTalkList(msgMgrService.selectYrList(mgr)));
        filterOptions.put("smstrList", msgMgrService.selectSmstrList(mgr));
        filterOptions.put("sbjctList", toAlimTalkList(msgMgrService.selectSbjctList(mgr)));

        return filterOptions;
    }

    /*****************************************************
     * 학생 수강과목 기준 조회 필터 옵션 조회
     * @param vo
     * @return EgovMap
     ******************************************************/
    @Override
    public EgovMap loadStdntFilterOptions(MsgAlimTalkVO vo) {
        EgovMap filterOptions = new EgovMap();

        MsgMgrVO mgr = toMgrVO(vo);
        filterOptions.put("yrList", toAlimTalkList(msgMgrService.selectStdntYrList(mgr)));
        filterOptions.put("smstrList", msgMgrService.selectStdntSmstrList(mgr));
        filterOptions.put("sbjctList", toAlimTalkList(msgMgrService.selectStdntSbjctList(mgr)));

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

        MsgAlimTalkVO yrVo = new MsgAlimTalkVO();
        yrVo.setUserId(userId);
        List<MsgAlimTalkVO> yrList = toAlimTalkList(msgMgrService.selectYrList(toMgrVO(yrVo)));

        List<OrgInfoVO> orgList = isAdmin
                ? selectActiveOrgListByAuth(userCtx.getUserId(), true)
                : selectProfSbjctOrgList(userCtx.getUserId());

        EgovMap filterOptions = new EgovMap();
        filterOptions.put("yrList",  yrList);
        filterOptions.put("orgList", orgList);
        return filterOptions;
    }
}
