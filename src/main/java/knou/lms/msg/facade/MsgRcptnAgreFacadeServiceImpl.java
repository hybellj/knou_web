package knou.lms.msg.facade;

import knou.framework.common.ServiceBase;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.service.MsgRcptnAgreService;
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

    /**
     * 알림수신동의 목록 조회 (페이징)
     */
    @Override
    public ProcessResultVO<MsgRcptnAgreVO> selectRcptnAgreListPage(MsgRcptnAgreVO vo) {
        return msgRcptnAgreService.selectRcptnAgreListPage(vo);
    }

    /**
     * 알림수신동의 엑셀 목록 조회
     */
    @Override
    public List<MsgRcptnAgreVO> selectRcptnAgreExcelList(MsgRcptnAgreVO vo) {
        return msgRcptnAgreService.selectRcptnAgreExcelList(vo);
    }

    /**
     * 학사년도 목록 조회
     */
    @Override
    public List<MsgRcptnAgreVO> selectRcptnAgreYrList(MsgRcptnAgreVO vo) {
        return msgRcptnAgreService.selectRcptnAgreYrList(vo);
    }

    /**
     * 학기 목록 조회
     */
    @Override
    public List<EgovMap> selectRcptnAgreSmstrList(MsgRcptnAgreVO vo) {
        return msgRcptnAgreService.selectRcptnAgreSmstrList(vo);
    }

    /**
     * 학과 목록 조회
     */
    @Override
    public List<MsgRcptnAgreVO> selectRcptnAgreDeptList(MsgRcptnAgreVO vo) {
        return msgRcptnAgreService.selectRcptnAgreDeptList(vo);
    }

    /**
     * 운영과목 목록 조회
     */
    @Override
    public List<MsgRcptnAgreVO> selectRcptnAgreSbjctList(MsgRcptnAgreVO vo) {
        return msgRcptnAgreService.selectRcptnAgreSbjctList(vo);
    }

    /**
     * 운영 기관 목록 조회
     */
    @Override
    public List<OrgInfoVO> selectActiveOrgList() throws Exception {
        return orgInfoService.listActiveOrg();
    }
}
