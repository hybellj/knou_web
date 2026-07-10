package knou.lms.msg.facade;

import knou.framework.common.ServiceBase;
import knou.framework.exception.BusinessException;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.service.AutoAlimMsgService;
import knou.lms.msg.vo.AutoAlimMsgVO;
import knou.lms.org.service.OrgInfoService;
import knou.lms.org.vo.OrgInfoVO;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("autoAlimMsgFacadeService")
public class AutoAlimMsgFacadeServiceImpl extends ServiceBase implements AutoAlimMsgFacadeService {

    @Resource(name = "autoAlimMsgService")
    private AutoAlimMsgService autoAlimMsgService;

    @Resource(name = "orgInfoService")
    private OrgInfoService orgInfoService;

    /*****************************************************
     * 운영 기관 목록 조회
     * @return List<OrgInfoVO>
     ******************************************************/
    @Override
    public List<OrgInfoVO> selectActiveOrgList() throws Exception {
        return orgInfoService.listActiveOrg();
    }

    /*****************************************************
     * 자동알림메시지 목록 조회
     * @param vo
     * @return ProcessResultVO<AutoAlimMsgVO>
     ******************************************************/
    @Override
    public ProcessResultVO<AutoAlimMsgVO> selectAutoAlimMsgListPage(AutoAlimMsgVO vo) throws Exception {
        return autoAlimMsgService.selectAutoAlimMsgListPage(vo);
    }

    /*****************************************************
     * 자동알림메시지 상세 조회
     * @param vo
     * @return AutoAlimMsgVO
     ******************************************************/
    @Override
    public AutoAlimMsgVO selectAutoAlimMsgWithTrgt(AutoAlimMsgVO vo) {
        AutoAlimMsgVO resultVo = autoAlimMsgService.selectAutoAlimMsg(vo);
        if (resultVo != null) {
            List<AutoAlimMsgVO> trgtList = autoAlimMsgService.selectAutoAlimMsgTrgtListByMsgId(vo);
            if (trgtList != null && !trgtList.isEmpty()) {
                String[] tycds = new String[trgtList.size()];
                for (int i = 0; i < trgtList.size(); i++) {
                    tycds[i] = trgtList.get(i).getAutoAlimTrgtTycd();
                }
                resultVo.setAutoAlimTrgtTycds(tycds);
            }
        }
        return resultVo;
    }

    /*****************************************************
     * 자동알림메시지 등록
     * @param vo
     ******************************************************/
    @Override
    public void registAutoAlimMsg(AutoAlimMsgVO vo) {
        autoAlimMsgService.insertAutoAlimMsg(vo);
        insertTrgtList(vo);
    }

    /*****************************************************
     * 자동알림메시지 수정
     * @param vo
     ******************************************************/
    @Override
    public void modifyAutoAlimMsg(AutoAlimMsgVO vo) {
        int updated = autoAlimMsgService.updateAutoAlimMsg(vo);
        if (updated == 0) {
            throw new BusinessException("fail.common.update");
        }
        autoAlimMsgService.deleteAutoAlimMsgTrgtByMsgId(vo);
        insertTrgtList(vo);
    }

    /*****************************************************
     * 자동알림메시지 삭제
     * @param vo
     ******************************************************/
    @Override
    public void deleteAutoAlimMsg(AutoAlimMsgVO vo) {
        autoAlimMsgService.deleteAutoAlimMsgTrgtByMsgId(vo);
        int deleted = autoAlimMsgService.deleteAutoAlimMsg(vo);
        if (deleted == 0) {
            throw new BusinessException("fail.common.delete");
        }
    }

    private void insertTrgtList(AutoAlimMsgVO vo) {
        String tycdStr = vo.getAutoAlimTrgtTycdStr();
        if (tycdStr != null && !tycdStr.isEmpty()) {
            String[] tycds = tycdStr.split(",");
            for (String tycd : tycds) {
                if (tycd.trim().isEmpty()) continue;
                AutoAlimMsgVO trgtVo = new AutoAlimMsgVO();
                trgtVo.setAutoAlimMsgId(vo.getAutoAlimMsgId());
                trgtVo.setAutoAlimTrgtTycd(tycd.trim());
                trgtVo.setRgtrId(vo.getRgtrId());
                autoAlimMsgService.insertAutoAlimMsgTrgt(trgtVo);
            }
        }
    }
}
