package knou.lms.msg.service.impl;

import knou.framework.common.PageInfo;
import knou.framework.common.ServiceBase;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.dao.MsgSndrDsctnDAO;
import knou.lms.msg.service.MsgSndrDsctnService;
import knou.lms.msg.vo.MsgSndrDsctnVO;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("msgSndrDsctnService")
public class MsgSndrDsctnServiceImpl extends ServiceBase implements MsgSndrDsctnService {

    @Resource(name = "msgSndrDsctnDAO")
    private MsgSndrDsctnDAO msgSndrDsctnDAO;

    /*****************************************************
     * 발송내역 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgSndrDsctnVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgSndrDsctnVO> selectSndrDsctnListPage(MsgSndrDsctnVO vo) throws Exception {
        ProcessResultVO<MsgSndrDsctnVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<MsgSndrDsctnVO> list = msgSndrDsctnDAO.selectSndrDsctnList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);

        return resultVO;
    }

    /*****************************************************
     * 발송내역 엑셀 목록 조회
     * @param vo
     * @return List<MsgSndrDsctnVO>
     ******************************************************/
    @Override
    public List<MsgSndrDsctnVO> selectSndrDsctnExcelList(MsgSndrDsctnVO vo) {
        return msgSndrDsctnDAO.selectSndrDsctnExcelList(vo);
    }

    /*****************************************************
     * 발송내역 채널별 요약 조회
     * @param vo
     * @return MsgSndrDsctnVO
     ******************************************************/
    @Override
    public MsgSndrDsctnVO selectSndrDsctnSmry(MsgSndrDsctnVO vo) {
        return msgSndrDsctnDAO.selectSndrDsctnSmry(vo);
    }

}
