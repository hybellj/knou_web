package knou.lms.msg.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.dao.MsgRcptnAgreDAO;
import knou.lms.msg.service.MsgRcptnAgreService;
import knou.lms.msg.vo.MsgRcptnAgreVO;

@Service("msgRcptnAgreService")
public class MsgRcptnAgreServiceImpl extends ServiceBase implements MsgRcptnAgreService {

    @Resource(name = "msgRcptnAgreDAO")
    private MsgRcptnAgreDAO msgRcptnAgreDAO;

    /**
     * 알림수신동의 목록 조회 (페이징)
     * @param vo
     * @return
     */
    @Override
    public ProcessResultVO<MsgRcptnAgreVO> selectRcptnAgreListPage(MsgRcptnAgreVO vo) {
        ProcessResultVO<MsgRcptnAgreVO> resultVO = new ProcessResultVO<>();

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex() + 1);
        vo.setLastIndex(paginationInfo.getFirstRecordIndex() + vo.getListScale());

        int totalCnt = msgRcptnAgreDAO.selectRcptnAgreCnt(vo);
        paginationInfo.setTotalRecordCount(totalCnt);

        List<MsgRcptnAgreVO> list = msgRcptnAgreDAO.selectRcptnAgreList(vo);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    /**
     * 알림수신동의 엑셀 목록 조회
     * @param vo
     * @return
     */
    @Override
    public List<MsgRcptnAgreVO> selectRcptnAgreExcelList(MsgRcptnAgreVO vo) {
        return msgRcptnAgreDAO.selectRcptnAgreExcelList(vo);
    }

    /**
     * 학사년도 목록 조회
     * @param vo
     * @return
     */
    @Override
    public List<MsgRcptnAgreVO> selectRcptnAgreYrList(MsgRcptnAgreVO vo) {
        return msgRcptnAgreDAO.selectRcptnAgreYrList(vo);
    }

    /**
     * 학기 목록 조회
     * @param vo
     * @return
     */
    @Override
    public List<EgovMap> selectRcptnAgreSmstrList(MsgRcptnAgreVO vo) {
        return msgRcptnAgreDAO.selectRcptnAgreSmstrList(vo);
    }

    /**
     * 학과 목록 조회
     * @param vo
     * @return
     */
    @Override
    public List<MsgRcptnAgreVO> selectRcptnAgreDeptList(MsgRcptnAgreVO vo) {
        return msgRcptnAgreDAO.selectRcptnAgreDeptList(vo);
    }

    /**
     * 운영과목 목록 조회
     * @param vo
     * @return
     */
    @Override
    public List<MsgRcptnAgreVO> selectRcptnAgreSbjctList(MsgRcptnAgreVO vo) {
        return msgRcptnAgreDAO.selectRcptnAgreSbjctList(vo);
    }
}
