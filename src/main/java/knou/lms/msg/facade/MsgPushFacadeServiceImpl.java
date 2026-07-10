package knou.lms.msg.facade;

import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.service.MsgMgrService;
import knou.lms.msg.service.MsgPushService;
import knou.lms.msg.vo.MsgMgrVO;
import knou.lms.msg.vo.MsgPushVO;
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

@Service("msgPushFacadeService")
public class MsgPushFacadeServiceImpl extends ServiceBase implements MsgPushFacadeService {

    @Resource(name = "msgPushService")
    private MsgPushService msgPushService;

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
    private MsgMgrVO toMgrVO(MsgPushVO s) {
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
     * @return List<MsgPushVO>
     ******************************************************/
    private List<MsgPushVO> toPushList(List<MsgMgrVO> src) {
        List<MsgPushVO> result = new ArrayList<>();
        if (src == null) {
            return result;
        }
        for (MsgMgrVO m : src) {
            MsgPushVO p = new MsgPushVO();
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
     * @return List<MsgPushVO>
     ******************************************************/
    private List<MsgPushVO> toPushRcvrList(List<MsgMgrVO> src) {
        List<MsgPushVO> result = new ArrayList<>();
        if (src == null) {
            return result;
        }
        for (MsgMgrVO m : src) {
            MsgPushVO p = new MsgPushVO();
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
     * 푸시 수신 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgPushVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<MsgPushVO> selectPushRcvnListPage(MsgPushVO vo) throws Exception {
        return msgPushService.selectPushRcvnListPage(vo);
    }

    /*****************************************************
     * 푸시 수신 상세 조회
     * @param vo
     * @return MsgPushVO
     ******************************************************/
    @Override
    public MsgPushVO selectPushRcvnDtl(MsgPushVO vo) {
        return msgPushService.selectPushRcvnDtl(vo);
    }

    /*****************************************************
     * 푸시 읽음 처리
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int modifyPushReadDttm(MsgPushVO vo) {
        return msgPushService.updatePushReadDttm(vo);
    }

    /*****************************************************
     * 푸시 수신자 삭제
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int modifyPushRcvrDelyn(MsgPushVO vo) {
        return msgPushService.updatePushRcvrDelyn(vo);
    }

    /*****************************************************
     * 푸시 발신 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgPushVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<MsgPushVO> selectPushSndngListPage(MsgPushVO vo) throws Exception {
        return msgPushService.selectPushSndngListPage(vo);
    }

    /*****************************************************
     * 푸시 발신 상세 조회
     * @param vo
     * @return MsgPushVO
     ******************************************************/
    @Override
    public MsgPushVO selectPushSndngDtl(MsgPushVO vo) {
        return msgPushService.selectPushSndngDtl(vo);
    }

    /*****************************************************
     * 푸시 발신 수신자 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgPushVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<MsgPushVO> selectPushSndngRcvrListPage(MsgPushVO vo) throws Exception {
        return msgPushService.selectPushSndngRcvrListPage(vo);
    }

    /*****************************************************
     * 푸시 발신자 삭제
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int modifyPushSndngrDelyn(MsgPushVO vo) {
        return msgPushService.updatePushSndngrDelyn(vo);
    }

    /*****************************************************
     * 푸시 발신 등록
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void registPushSndng(MsgPushVO vo) throws Exception {
        vo.setDgrsYr(vo.getSbjctYr());
        vo.setSmstr(vo.getSbjctSmstr());

        msgPushService.registPushSndng(vo);
    }

    /*****************************************************
     * 푸시 발신 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void modifyPushSndng(MsgPushVO vo) throws Exception {
        vo.setDgrsYr(vo.getSbjctYr());
        vo.setSmstr(vo.getSbjctSmstr());

        msgPushService.modifyPushSndng(vo);
    }

    /*****************************************************
     * 예약 발신 취소
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int modifyMsgRsrvCncl(MsgPushVO vo) {
        return msgPushService.updateMsgRsrvCncl(vo);
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

        MsgPushVO reqVo = new MsgPushVO();
        reqVo.setMsgId(msgId);
        reqVo.setMblSndngTycd(knou.framework.common.CommConst.MSG_CHNL_PUSH);
        MsgPushVO original = selectPushSndngDtl(reqVo);
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

        MsgPushVO smstrVo = new MsgPushVO();
        smstrVo.setUserId(userId);
        smstrVo.setSbjctYr(original.getSbjctYr());
        List<EgovMap> editSmstrList = msgMgrService.selectSmstrList(toMgrVO(smstrVo));
        result.put("smstrList", ensureOriginalSmstr(editSmstrList, original));

        MsgPushVO sbjctVo = new MsgPushVO();
        sbjctVo.setUserId(userId);
        sbjctVo.setOrgId(original.getOrgId());
        sbjctVo.setSbjctYr(original.getSbjctYr());
        sbjctVo.setSbjctSmstr(original.getSbjctSmstr());
        List<MsgPushVO> editSbjctList = toPushList(msgMgrService.selectSbjctList(toMgrVO(sbjctVo)));
        result.put("sbjctList", ensureOriginalSbjct(editSbjctList, original));

        return result;
    }

    /*****************************************************
     * 원본 과목 보강
     * @param sbjctList
     * @param original
     * @return List<MsgPushVO>
     ******************************************************/
    private List<MsgPushVO> ensureOriginalSbjct(List<MsgPushVO> sbjctList, MsgPushVO original) {
        if (sbjctList == null || original == null) {
            return sbjctList;
        }
        String origSbjctId = StringUtil.nvl(original.getSbjctId()).trim();
        if (StringUtil.isNull(origSbjctId)) {
            return sbjctList;
        }
        for (MsgPushVO s : sbjctList) {
            if (origSbjctId.equals(StringUtil.nvl(s.getSbjctId()).trim())) {
                return sbjctList;
            }
        }
        MsgPushVO keeper = new MsgPushVO();
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
    private List<EgovMap> ensureOriginalSmstr(List<EgovMap> smstrList, MsgPushVO original) {
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
     * @return List<MsgPushVO>
     ******************************************************/
    private List<MsgPushVO> ensureOriginalYr(List<MsgPushVO> yrList, MsgPushVO original) {
        if (yrList == null || original == null) {
            return yrList;
        }
        String origYr = StringUtil.nvl(original.getSbjctYr()).trim();
        if (StringUtil.isNull(origYr)) {
            return yrList;
        }
        for (MsgPushVO y : yrList) {
            if (origYr.equals(StringUtil.nvl(y.getSbjctYr()).trim())) {
                return yrList;
            }
        }
        MsgPushVO keeper = new MsgPushVO();
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
    private List<OrgInfoVO> ensureOriginalOrg(List<OrgInfoVO> orgList, MsgPushVO original) {
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
    public void applyOriginalToFilterOptions(EgovMap filterOptions, MsgPushVO original) {
        if (filterOptions == null || original == null) {
            return;
        }
        List<MsgPushVO> yrList = (List<MsgPushVO>) filterOptions.get("yrList");
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
     * @return List<MsgPushVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<MsgPushVO> parseExcelAndSearchRcvr(InputStream excelInputStream, String orgId) throws Exception {
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
        return toPushRcvrList(msgMgrService.selectRcvrByUserIds(mgr));
    }

    /*****************************************************
     * 수신 대상자 목록 조회
     * @param vo
     * @return List<MsgPushVO>
     ******************************************************/
    @Override
    public List<MsgPushVO> selectMsgRcvTrgtrList(MsgPushVO vo) {
        return msgPushService.selectMsgRcvTrgtrList(vo);
    }

    /*****************************************************
     * 목록 화면 초기 데이터 조회
     * @param vo
     * @return MsgPushVO
     * @throws Exception
     ******************************************************/
    @Override
    public MsgPushVO loadListViewInfo(MsgPushVO vo) throws Exception {
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
        result.put("userMblPhn", userPrfil != null ? StringUtil.nvl(userPrfil.getMblPhn()) : "");

        if (StringUtil.isNotNull(msgId)) {
            if (!hasSndngAuth) {
                MsgPushVO checkVO = new MsgPushVO();
                checkVO.setMsgId(msgId);
                checkVO.setSndngrId(userId);
                MsgPushVO detail = selectPushSndngDtl(checkVO);
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
    public EgovMap loadFilterOptions(MsgPushVO vo) {
        EgovMap filterOptions = new EgovMap();

        MsgMgrVO mgr = toMgrVO(vo);
        filterOptions.put("yrList", toPushList(msgMgrService.selectYrList(mgr)));
        filterOptions.put("smstrList", msgMgrService.selectSmstrList(mgr));
        filterOptions.put("sbjctList", toPushList(msgMgrService.selectSbjctList(mgr)));

        return filterOptions;
    }

    /*****************************************************
     * 학생 수강과목 기준 조회 필터 옵션 조회
     * @param vo
     * @return EgovMap
     ******************************************************/
    @Override
    public EgovMap loadStdntFilterOptions(MsgPushVO vo) {
        EgovMap filterOptions = new EgovMap();

        MsgMgrVO mgr = toMgrVO(vo);
        filterOptions.put("yrList", toPushList(msgMgrService.selectStdntYrList(mgr)));
        filterOptions.put("smstrList", msgMgrService.selectStdntSmstrList(mgr));
        filterOptions.put("sbjctList", toPushList(msgMgrService.selectStdntSbjctList(mgr)));

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

        MsgPushVO yrVo = new MsgPushVO();
        yrVo.setUserId(userId);
        List<MsgPushVO> yrList = toPushList(msgMgrService.selectYrList(toMgrVO(yrVo)));

        List<OrgInfoVO> orgList = isAdmin
                ? selectActiveOrgListByAuth(userCtx.getUserId(), true)
                : selectProfSbjctOrgList(userCtx.getUserId());

        EgovMap filterOptions = new EgovMap();
        filterOptions.put("yrList",  yrList);
        filterOptions.put("orgList", orgList);
        return filterOptions;
    }
}
