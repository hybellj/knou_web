package knou.lms.msg.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.dao.MsgSndrDsctnDAO;
import knou.lms.msg.service.MsgSndrDsctnService;
import knou.lms.msg.vo.MsgSndrDsctnVO;

@Service("msgSndrDsctnService")
public class MsgSndrDsctnServiceImpl implements MsgSndrDsctnService {

    @Resource(name = "msgSndrDsctnDAO")
    private MsgSndrDsctnDAO msgSndrDsctnDAO;

    /**
     * 발송내역 목록 조회 (페이징)
     * @param vo
     * @return
     */
    @Override
    public ProcessResultVO<MsgSndrDsctnVO> selectSndrDsctnListPage(MsgSndrDsctnVO vo) {
        ProcessResultVO<MsgSndrDsctnVO> resultVO = new ProcessResultVO<>();

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex() + 1);
        vo.setLastIndex(paginationInfo.getFirstRecordIndex() + vo.getListScale());

        int totalCnt = msgSndrDsctnDAO.selectSndrDsctnCnt(vo);
        paginationInfo.setTotalRecordCount(totalCnt);

        List<MsgSndrDsctnVO> list = msgSndrDsctnDAO.selectSndrDsctnList(vo);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    /**
     * 발송내역 엑셀 목록 조회
     * @param vo
     * @return
     */
    @Override
    public List<MsgSndrDsctnVO> selectSndrDsctnExcelList(MsgSndrDsctnVO vo) {
        return msgSndrDsctnDAO.selectSndrDsctnExcelList(vo);
    }

    /**
     * 발송내역 채널별 요약 조회
     * @param vo
     * @return
     */
    @Override
    public MsgSndrDsctnVO selectSndrDsctnSummary(MsgSndrDsctnVO vo) {
        return msgSndrDsctnDAO.selectSndrDsctnSummary(vo);
    }

    /**
     * 학사년도 목록 조회
     * @param vo
     * @return
     */
    @Override
    public List<MsgSndrDsctnVO> selectSndrDsctnYrList(MsgSndrDsctnVO vo) {
        return msgSndrDsctnDAO.selectSndrDsctnYrList(vo);
    }

    /**
     * 학기 목록 조회
     * @param vo
     * @return
     */
    @Override
    public List<MsgSndrDsctnVO> selectSndrDsctnSmstrList(MsgSndrDsctnVO vo) {
        return msgSndrDsctnDAO.selectSndrDsctnSmstrList(vo);
    }

    /**
     * 학과 목록 조회
     * @param vo
     * @return
     */
    @Override
    public List<MsgSndrDsctnVO> selectSndrDsctnDeptList(MsgSndrDsctnVO vo) {
        return msgSndrDsctnDAO.selectSndrDsctnDeptList(vo);
    }

    /**
     * 운영과목 목록 조회
     * @param vo
     * @return
     */
    @Override
    public List<MsgSndrDsctnVO> selectSndrDsctnSbjctList(MsgSndrDsctnVO vo) {
        return msgSndrDsctnDAO.selectSndrDsctnSbjctList(vo);
    }
}
