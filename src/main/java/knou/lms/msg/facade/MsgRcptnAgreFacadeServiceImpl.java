package knou.lms.msg.facade;

import knou.framework.common.ServiceBase;
import knou.framework.util.DateTimeUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.service.MsgMgrService;
import knou.lms.msg.service.MsgRcptnAgreService;
import knou.lms.msg.vo.MsgMgrVO;
import knou.lms.msg.vo.MsgRcptnAgreVO;
import knou.lms.org.service.OrgInfoService;
import knou.lms.org.vo.OrgInfoVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("msgRcptnAgreFacadeService")
public class MsgRcptnAgreFacadeServiceImpl extends ServiceBase implements MsgRcptnAgreFacadeService {

    @Resource(name = "msgRcptnAgreService")
    private MsgRcptnAgreService msgRcptnAgreService;

    @Resource(name = "orgInfoService")
    private OrgInfoService orgInfoService;

    @Resource(name = "msgMgrService")
    private MsgMgrService msgMgrService;

    /*****************************************************
     * 채널 VO → 공통 MsgMgrVO 변환 (검색 조건)
     * @param s
     * @return MsgMgrVO
     ******************************************************/
    private MsgMgrVO toMgrVO(MsgRcptnAgreVO s) {
        MsgMgrVO m = new MsgMgrVO();
        m.setOrgId(s.getOrgId());
        m.setUserId(s.getUserId());
        m.setSbjctYr(s.getSbjctYr());
        m.setSbjctSmstr(s.getSbjctSmstr());
        return m;
    }

    /*****************************************************
     * 알림수신동의 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgRcptnAgreVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<MsgRcptnAgreVO> selectRcptnAgreListPage(MsgRcptnAgreVO vo) throws Exception {
        return msgRcptnAgreService.selectRcptnAgreListPage(vo);
    }

    /*****************************************************
     * 알림수신동의 엑셀 목록 조회
     * @param vo
     * @return List<MsgRcptnAgreVO>
     ******************************************************/
    @Override
    public List<MsgRcptnAgreVO> selectRcptnAgreExcelList(MsgRcptnAgreVO vo) {
        return msgRcptnAgreService.selectRcptnAgreExcelList(vo);
    }

    /*****************************************************
     * 관리자 알림수신동의 목록 조회 (관리자 제외 전체 회원)
     * @param vo
     * @return ProcessResultVO<MsgRcptnAgreVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<MsgRcptnAgreVO> selectAdminRcptnAgreListPage(MsgRcptnAgreVO vo) throws Exception {
        return msgRcptnAgreService.selectAdminRcptnAgreListPage(vo);
    }

    /*****************************************************
     * 관리자 알림수신동의 엑셀 목록 조회 (관리자 제외 전체 회원)
     * @param vo
     * @return List<MsgRcptnAgreVO>
     ******************************************************/
    @Override
    public List<MsgRcptnAgreVO> selectAdminRcptnAgreExcelList(MsgRcptnAgreVO vo) {
        return msgRcptnAgreService.selectAdminRcptnAgreExcelList(vo);
    }

    /*****************************************************
     * 운영 기관 목록 조회
     * @return List<OrgInfoVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<OrgInfoVO> selectActiveOrgList() throws Exception {
        return orgInfoService.listActiveOrg();
    }

    /*****************************************************
     * 활성 기관 목록 조회
     * @param userId
     * @param isAdmin
     * @return List<OrgInfoVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<OrgInfoVO> selectActiveOrgListByAuth(String userId, boolean isAdmin) throws Exception {
        return msgMgrService.selectActiveOrgListByAuth(userId, isAdmin);
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
     * 목록 화면 초기 데이터 조회 및 유효성 검증
     * @param vo
     * @return MsgRcptnAgreVO
     * @throws Exception
     ******************************************************/
    @Override
    public MsgRcptnAgreVO loadListViewInfo(MsgRcptnAgreVO vo) throws Exception {
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

        return vo;
    }

    /*****************************************************
     * 조회 필터 옵션 조회
     * @param vo
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    @Override
    public EgovMap loadFilterOptions(MsgRcptnAgreVO vo) throws Exception {
        EgovMap filterOptions = new EgovMap();

        MsgMgrVO mgr = toMgrVO(vo);
        filterOptions.put("yrList", msgMgrService.selectYrList(mgr));
        filterOptions.put("smstrList", msgMgrService.selectSmstrList(mgr));
        filterOptions.put("sbjctList", msgMgrService.selectSbjctList(mgr));
        filterOptions.put("orgList", selectActiveOrgList());

        return filterOptions;
    }
}
