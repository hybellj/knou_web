package knou.lms.msg.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.util.IdGenerator;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.dao.MsgTmpltDAO;
import knou.lms.msg.service.MsgTmpltService;
import knou.lms.msg.vo.MsgTmpltVO;

@Service("msgTmpltService")
public class MsgTmpltServiceImpl implements MsgTmpltService {

    @Resource(name = "msgTmpltDAO")
    private MsgTmpltDAO msgTmpltDAO;

    /**
     * 템플릿 목록 건수 조회
     * @param vo
     * @return
     */
    @Override
    public int selectTmpltCnt(MsgTmpltVO vo) {
        return msgTmpltDAO.selectTmpltCnt(vo);
    }

    /**
     * 템플릿 목록 조회
     * @param vo
     * @return
     */
    @Override
    public List<MsgTmpltVO> selectTmpltList(MsgTmpltVO vo) {
        return msgTmpltDAO.selectTmpltList(vo);
    }

    /**
     * 템플릿 목록 조회 (페이징)
     * @param vo
     * @return
     */
    @Override
    public ProcessResultVO<MsgTmpltVO> selectTmpltListPage(MsgTmpltVO vo) {
        ProcessResultVO<MsgTmpltVO> resultVO = new ProcessResultVO<>();

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex() + 1);
        vo.setLastIndex(paginationInfo.getFirstRecordIndex() + vo.getListScale());

        int totalCnt = msgTmpltDAO.selectTmpltCnt(vo);
        paginationInfo.setTotalRecordCount(totalCnt);

        List<MsgTmpltVO> list = msgTmpltDAO.selectTmpltList(vo);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    /**
     * 템플릿 상세 조회
     * @param vo
     * @return
     */
    @Override
    public MsgTmpltVO selectTmplt(MsgTmpltVO vo) {
        return msgTmpltDAO.selectTmplt(vo);
    }

    /**
     * 템플릿 등록
     * @param vo
     * @return
     */
    @Override
    public int registTmplt(MsgTmpltVO vo) {
        String msgTmpltId = IdGenerator.getNewId(IdPrefixType.MSTML.getCode());
        vo.setMsgTmpltId(msgTmpltId);
        return msgTmpltDAO.registTmplt(vo);
    }

    /**
     * 템플릿 수정
     * @param vo
     * @return
     */
    @Override
    public int modifyTmplt(MsgTmpltVO vo) {
        return msgTmpltDAO.modifyTmplt(vo);
    }

    /**
     * 템플릿 삭제
     * @param vo
     * @return
     */
    @Override
    public int deleteTmplt(MsgTmpltVO vo) {
        int result = 0;
        String[] ids = vo.getMsgTmpltIds();
        if (ids != null && ids.length > 0) {
            for (String id : ids) {
                MsgTmpltVO delVo = new MsgTmpltVO();
                delVo.setMsgTmpltId(id);
                result += msgTmpltDAO.deleteTmplt(delVo);
            }
        } else if (vo.getMsgTmpltId() != null) {
            result = msgTmpltDAO.deleteTmplt(vo);
        }
        return result;
    }

    /**
     * 템플릿 전체 삭제
     * @param vo
     * @return
     */
    @Override
    public int deleteAllTmplt(MsgTmpltVO vo) {
        return msgTmpltDAO.deleteAllTmplt(vo);
    }

    /**
     * 템플릿 엑셀 목록 조회
     * @param vo
     * @return
     */
    @Override
    public List<MsgTmpltVO> selectTmpltExcelList(MsgTmpltVO vo) {
        return msgTmpltDAO.selectTmpltExcelList(vo);
    }
}
