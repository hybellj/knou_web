package knou.lms.msg.service.impl;

import knou.framework.common.ServiceBase;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.dao.MsgSndrDsctnDAO;
import knou.lms.msg.service.MsgSndrDsctnService;
import knou.lms.msg.vo.MsgSndrDsctnVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("msgSndrDsctnService")
public class MsgSndrDsctnServiceImpl extends ServiceBase implements MsgSndrDsctnService {

    @Resource(name = "msgSndrDsctnDAO")
    private MsgSndrDsctnDAO msgSndrDsctnDAO;

    /*****************************************************
     * 발송내역 목록 조회 (페이징)
     * @param vo
     * @return ProcessResultVO<MsgSndrDsctnVO>
     ******************************************************/
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

    /*****************************************************
     * 학사년도 목록 조회
     * @param vo
     * @return List<MsgSndrDsctnVO>
     ******************************************************/
    @Override
    public List<MsgSndrDsctnVO> selectSndrDsctnYrList(MsgSndrDsctnVO vo) {
        return msgSndrDsctnDAO.selectSndrDsctnYrList(vo);
    }

    /*****************************************************
     * 학기 목록 조회
     * @param vo
     * @return List<EgovMap>
     ******************************************************/
    @Override
    public List<EgovMap> selectSndrDsctnSmstrList(MsgSndrDsctnVO vo) {
        return msgSndrDsctnDAO.selectSndrDsctnSmstrList(vo);
    }

    /*****************************************************
     * 학과 목록 조회
     * @param vo
     * @return List<MsgSndrDsctnVO>
     ******************************************************/
    @Override
    public List<MsgSndrDsctnVO> selectSndrDsctnDeptList(MsgSndrDsctnVO vo) {
        return msgSndrDsctnDAO.selectSndrDsctnDeptList(vo);
    }

    /*****************************************************
     * 운영과목 목록 조회
     * @param vo
     * @return List<MsgSndrDsctnVO>
     ******************************************************/
    @Override
    public List<MsgSndrDsctnVO> selectSndrDsctnSbjctList(MsgSndrDsctnVO vo) {
        return msgSndrDsctnDAO.selectSndrDsctnSbjctList(vo);
    }

    @Override
    public String selectOrgNm(String orgId) {
        return msgSndrDsctnDAO.selectOrgNm(orgId);
    }
}
