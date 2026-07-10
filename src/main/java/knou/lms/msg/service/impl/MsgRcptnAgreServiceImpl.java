package knou.lms.msg.service.impl;

import knou.framework.common.PageInfo;
import knou.framework.common.ServiceBase;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.dao.MsgRcptnAgreDAO;
import knou.lms.msg.service.MsgRcptnAgreService;
import knou.lms.msg.vo.MsgRcptnAgreVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("msgRcptnAgreService")
public class MsgRcptnAgreServiceImpl extends ServiceBase implements MsgRcptnAgreService {

    @Resource(name = "msgRcptnAgreDAO")
    private MsgRcptnAgreDAO msgRcptnAgreDAO;

    /*****************************************************
     * 알림수신동의 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgRcptnAgreVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgRcptnAgreVO> selectRcptnAgreListPage(MsgRcptnAgreVO vo) throws Exception {
        ProcessResultVO<MsgRcptnAgreVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<MsgRcptnAgreVO> list = msgRcptnAgreDAO.selectRcptnAgreList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);

        return resultVO;
    }

    /*****************************************************
     * 알림수신동의 엑셀 목록 조회
     * @param vo
     * @return List<MsgRcptnAgreVO>
     ******************************************************/
    @Override
    public List<MsgRcptnAgreVO> selectRcptnAgreExcelList(MsgRcptnAgreVO vo) {
        return msgRcptnAgreDAO.selectRcptnAgreExcelList(vo);
    }

    /*****************************************************
     * 관리자 알림수신동의 목록 조회 (관리자 제외 전체 회원)
     * @param vo
     * @return ProcessResultVO<MsgRcptnAgreVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgRcptnAgreVO> selectAdminRcptnAgreListPage(MsgRcptnAgreVO vo) throws Exception {
        ProcessResultVO<MsgRcptnAgreVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<MsgRcptnAgreVO> list = msgRcptnAgreDAO.selectAdminRcptnAgreList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);

        return resultVO;
    }

    /*****************************************************
     * 관리자 알림수신동의 엑셀 목록 조회 (관리자 제외 전체 회원)
     * @param vo
     * @return List<MsgRcptnAgreVO>
     ******************************************************/
    @Override
    public List<MsgRcptnAgreVO> selectAdminRcptnAgreExcelList(MsgRcptnAgreVO vo) {
        return msgRcptnAgreDAO.selectAdminRcptnAgreExcelList(vo);
    }

}
