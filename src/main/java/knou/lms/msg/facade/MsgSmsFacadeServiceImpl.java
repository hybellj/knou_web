package knou.lms.msg.facade;

import knou.framework.common.CommConst;
import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.api.SmsApiClient;
import knou.lms.msg.service.MsgMgrService;
import knou.lms.msg.service.MsgSmsService;
import knou.lms.msg.vo.MsgMgrVO;
import knou.lms.msg.vo.MsgSmsVO;
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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClientException;

import javax.annotation.Resource;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

@Service("msgSmsFacadeService")
public class MsgSmsFacadeServiceImpl extends ServiceBase implements MsgSmsFacadeService {

    private static final Logger log = LoggerFactory.getLogger(MsgSmsFacadeServiceImpl.class);

    @Resource(name = "msgSmsService")
    private MsgSmsService msgSmsService;

    @Resource(name = "msgMgrService")
    private MsgMgrService msgMgrService;

    @Resource(name = "orgInfoService")
    private OrgInfoService orgInfoService;

    @Resource(name = "userPrfilDAO")
    private UserPrfilDAO userPrfilDAO;

    @Resource(name = "smsApiClient")
    private SmsApiClient smsApiClient;

    /*****************************************************
     * 채널 VO → 공통 MsgMgrVO 변환 (검색 조건)
     * @param s
     * @return MsgMgrVO
     ******************************************************/
    private MsgMgrVO toMgrVO(MsgSmsVO s) {
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
     * @return List<MsgSmsVO>
     ******************************************************/
    private List<MsgSmsVO> toSmsList(List<MsgMgrVO> src) {
        List<MsgSmsVO> result = new ArrayList<>();
        if (src == null) {
            return result;
        }
        for (MsgMgrVO m : src) {
            MsgSmsVO p = new MsgSmsVO();
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
     * @return List<MsgSmsVO>
     ******************************************************/
    private List<MsgSmsVO> toSmsRcvrList(List<MsgMgrVO> src) {
        List<MsgSmsVO> result = new ArrayList<>();
        if (src == null) {
            return result;
        }
        for (MsgMgrVO m : src) {
            MsgSmsVO p = new MsgSmsVO();
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
     * 문자 수신 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgSmsVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgSmsVO> selectSmsRcvnListPage(MsgSmsVO vo) throws Exception {
        return msgSmsService.selectSmsRcvnListPage(vo);
    }

    /*****************************************************
     * 문자 수신 상세 조회
     * @param vo
     * @return MsgSmsVO
     ******************************************************/
    @Override
    public MsgSmsVO selectSmsRcvnDtl(MsgSmsVO vo) {
        return msgSmsService.selectSmsRcvnDtl(vo);
    }

    /*****************************************************
     * 문자 읽음 처리
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int modifySmsReadDttm(MsgSmsVO vo) {
        return msgSmsService.updateSmsReadDttm(vo);
    }

    /*****************************************************
     * 문자 수신자 삭제
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int modifySmsRcvrDelyn(MsgSmsVO vo) {
        return msgSmsService.updateSmsRcvrDelyn(vo);
    }

    /*****************************************************
     * 문자 발신 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgSmsVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgSmsVO> selectSmsSndngListPage(MsgSmsVO vo) throws Exception {
        return msgSmsService.selectSmsSndngListPage(vo);
    }

    /*****************************************************
     * 문자 발신 상세 조회
     * @param vo
     * @return MsgSmsVO
     ******************************************************/
    @Override
    public MsgSmsVO selectSmsSndngDtl(MsgSmsVO vo) {
        return msgSmsService.selectSmsSndngDtl(vo);
    }

    /*****************************************************
     * 문자 발신 수신자 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgSmsVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgSmsVO> selectSmsSndngRcvrListPage(MsgSmsVO vo) throws Exception {
        return msgSmsService.selectSmsSndngRcvrListPage(vo);
    }

    /*****************************************************
     * 문자 발신자 삭제
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int modifySmsSndngrDelyn(MsgSmsVO vo) {
        return msgSmsService.updateSmsSndngrDelyn(vo);
    }

    /*****************************************************
     * 문자 발신 등록
     * @param vo
     * @return ProcessResultVO<MsgSmsVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgSmsVO> registSmsSndng(MsgSmsVO vo) throws Exception {
        ProcessResultVO<MsgSmsVO> resultVO = new ProcessResultVO<>();

        vo.setDgrsYr(vo.getSbjctYr());
        vo.setSmstr(vo.getSbjctSmstr());

        msgSmsService.registSmsSndng(vo);

        String orgTycd = resolveOrgTycd(vo.getOrgId());
        List<MsgSmsVO> rcvrListAll = msgSmsService.selectMsgRcvTrgtrList(vo);
        List<MsgSmsVO> rcvrList = new ArrayList<>();
        int rjctCnt = 0;
        for (MsgSmsVO r : rcvrListAll) {
            if ("Y".equals(r.getSndngYn()) || "RSRV".equals(r.getSndngStscd())) {
                rcvrList.add(r);
            } else if ("RJCT".equals(r.getSndngStscd())) {
                rjctCnt++;
            }
        }

        boolean isReservation = !StringUtil.isNull(vo.getRsrvSndngSdttm());

        SmsApiClient.SmsApiResult apiResult;
        try {
            apiResult = smsApiClient.sendAll(
                    orgTycd, vo.getMblSndngTycd(), vo.getSndngrPhnno(),
                    vo.getTtl(), vo.getTxtCts(), vo.getRsrvSndngSdttm(), rcvrList);
        } catch (RestClientException e) {
            log.error("SMS API 호출 실패", e);
            for (MsgSmsVO rcvr : rcvrList) {
                rcvr.setSndngYn("N");
                rcvr.setSndngStscd("FAIL");
                rcvr.setSndngRsltCts("API 호출 오류");
                rcvr.setMdfrId(vo.getRgtrId());
                msgSmsService.updateMblSndngRslt(rcvr);
            }
            resultVO.setResult(ProcessResultVO.RESULT_SUCC);
            resultVO.setMessage("등록 완료 / 발송 실패 " + rcvrList.size() + "명");
            return resultVO;
        }

        if (isReservation) {
            for (MsgSmsVO rcvr : rcvrList) {
                if ("FAIL".equals(rcvr.getSndngStscd())) {
                    rcvr.setMdfrId(vo.getRgtrId());
                    msgSmsService.updateMblSndngRslt(rcvr);
                }
            }
            int totalFailCnt = apiResult.getFailCnt() + rjctCnt;
            if (totalFailCnt > 0) {
                resultVO.setMessage("실패 " + totalFailCnt + "명");
            }
        } else {
            for (MsgSmsVO rcvr : rcvrList) {
                rcvr.setMdfrId(vo.getRgtrId());
                msgSmsService.updateMblSndngRslt(rcvr);
            }
            resultVO.setMessage("성공 " + apiResult.getSuccCnt() + "명 / 실패 " + (apiResult.getFailCnt() + rjctCnt) + "명");
        }

        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        return resultVO;
    }

    /*****************************************************
     * orgId로 기관 유형코드(ORG_TYCD) 조회
     * @param orgId
     * @return orgTycd
     ******************************************************/
    private String resolveOrgTycd(String orgId) throws Exception {
        if (orgId == null || orgId.isEmpty()) {
            return null;
        }
        OrgInfoVO param = new OrgInfoVO();
        param.setOrgId(orgId);
        OrgInfoVO org = orgInfoService.select(param);
        return org != null ? org.getOrgTycd() : null;
    }

    /*****************************************************
     * 문자 발신 수정
     * @param vo
     ******************************************************/
    @Override
    public void modifySmsSndng(MsgSmsVO vo) {
        vo.setDgrsYr(vo.getSbjctYr());
        vo.setSmstr(vo.getSbjctSmstr());

        msgSmsService.modifySmsSndng(vo);
    }

    /*****************************************************
     * 예약 발신 취소
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int modifyMsgRsrvCncl(MsgSmsVO vo) {
        return msgSmsService.updateMsgRsrvCncl(vo);
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

        MsgSmsVO reqVo = new MsgSmsVO();
        reqVo.setMsgId(msgId);
        reqVo.setMblSndngTycd(CommConst.MSG_CHNL_SMS);
        MsgSmsVO original = selectSmsSndngDtl(reqVo);
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

        MsgSmsVO smstrVo = new MsgSmsVO();
        smstrVo.setUserId(userId);
        smstrVo.setSbjctYr(original.getSbjctYr());
        List<EgovMap> editSmstrList = msgMgrService.selectSmstrList(toMgrVO(smstrVo));
        result.put("smstrList", ensureOriginalSmstr(editSmstrList, original));

        MsgSmsVO sbjctVo = new MsgSmsVO();
        sbjctVo.setUserId(userId);
        sbjctVo.setOrgId(original.getOrgId());
        sbjctVo.setSbjctYr(original.getSbjctYr());
        sbjctVo.setSbjctSmstr(original.getSbjctSmstr());
        List<MsgSmsVO> editSbjctList = toSmsList(msgMgrService.selectSbjctList(toMgrVO(sbjctVo)));
        result.put("sbjctList", ensureOriginalSbjct(editSbjctList, original));

        return result;
    }

    /*****************************************************
     * 원본 과목 보강
     * @param sbjctList
     * @param original
     * @return List<MsgSmsVO>
     ******************************************************/
    private List<MsgSmsVO> ensureOriginalSbjct(List<MsgSmsVO> sbjctList, MsgSmsVO original) {
        if (sbjctList == null || original == null) {
            return sbjctList;
        }
        String origSbjctId = StringUtil.nvl(original.getSbjctId()).trim();
        if (StringUtil.isNull(origSbjctId)) {
            return sbjctList;
        }
        for (MsgSmsVO s : sbjctList) {
            if (origSbjctId.equals(StringUtil.nvl(s.getSbjctId()).trim())) {
                return sbjctList;
            }
        }
        MsgSmsVO keeper = new MsgSmsVO();
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
    private List<EgovMap> ensureOriginalSmstr(List<EgovMap> smstrList, MsgSmsVO original) {
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
     * @return List<MsgSmsVO>
     ******************************************************/
    private List<MsgSmsVO> ensureOriginalYr(List<MsgSmsVO> yrList, MsgSmsVO original) {
        if (yrList == null || original == null) {
            return yrList;
        }
        String origYr = StringUtil.nvl(original.getSbjctYr()).trim();
        if (StringUtil.isNull(origYr)) {
            return yrList;
        }
        for (MsgSmsVO y : yrList) {
            if (origYr.equals(StringUtil.nvl(y.getSbjctYr()).trim())) {
                return yrList;
            }
        }
        MsgSmsVO keeper = new MsgSmsVO();
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
    private List<OrgInfoVO> ensureOriginalOrg(List<OrgInfoVO> orgList, MsgSmsVO original) {
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
    public void applyOriginalToFilterOptions(EgovMap filterOptions, MsgSmsVO original) {
        if (filterOptions == null || original == null) {
            return;
        }
        List<MsgSmsVO> yrList = (List<MsgSmsVO>) filterOptions.get("yrList");
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
     * @return List<MsgSmsVO>
     ******************************************************/
    @Override
    public List<MsgSmsVO> parseExcelAndSearchRcvr(InputStream excelInputStream, String orgId) throws Exception {
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
        return toSmsRcvrList(msgMgrService.selectRcvrByUserIds(mgr));
    }

    /*****************************************************
     * 수신 대상자 목록 조회
     * @param vo
     * @return List<MsgSmsVO>
     ******************************************************/
    @Override
    public List<MsgSmsVO> selectMsgRcvTrgtrList(MsgSmsVO vo) {
        return msgSmsService.selectMsgRcvTrgtrList(vo);
    }

    /*****************************************************
     * 목록 화면 초기 데이터 조회
     * @param vo
     * @return MsgSmsVO
     ******************************************************/
    @Override
    public MsgSmsVO loadListViewInfo(MsgSmsVO vo) throws Exception {
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
     * 문자 발신 화면 발신자 정보 조회
     * @param userId
     * @return EgovMap
     ******************************************************/
    @Override
    public EgovMap loadSndngRegistViewInfo(String userId) throws Exception {
        EgovMap result = new EgovMap();

        UserPrfilVO prfilParam = new UserPrfilVO();
        prfilParam.setUserId(userId);
        UserPrfilVO userPrfil = userPrfilDAO.userPrfilSelect(prfilParam);
        result.put("userNm", userPrfil != null ? StringUtil.nvl(userPrfil.getUsernm()) : "");
        result.put("userMblPhn", userPrfil != null ? StringUtil.nvl(userPrfil.getMblPhn()) : "");

        return result;
    }

    /*****************************************************
     * 조회 필터 옵션 조회
     * @param vo
     * @return EgovMap
     ******************************************************/
    @Override
    public EgovMap loadFilterOptions(MsgSmsVO vo) throws Exception {
        EgovMap filterOptions = new EgovMap();

        MsgMgrVO mgr = toMgrVO(vo);
        filterOptions.put("yrList", toSmsList(msgMgrService.selectYrList(mgr)));
        filterOptions.put("smstrList", msgMgrService.selectSmstrList(mgr));
        filterOptions.put("sbjctList", toSmsList(msgMgrService.selectSbjctList(mgr)));

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

        MsgSmsVO yrVo = new MsgSmsVO();
        yrVo.setUserId(userId);
        List<MsgSmsVO> yrList = toSmsList(msgMgrService.selectYrList(toMgrVO(yrVo)));

        // SMS는 관리자 전용 채널이므로 발신 기관은 전체 활성 기관
        List<OrgInfoVO> orgList = selectActiveOrgListByAuth(userCtx.getUserId(), true);

        EgovMap filterOptions = new EgovMap();
        filterOptions.put("yrList",  yrList);
        filterOptions.put("orgList", orgList);
        return filterOptions;
    }
}
