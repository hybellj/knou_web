package knou.lms.msg.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.dao.MsgTmpltDAO;
import knou.lms.msg.service.MsgTmpltService;
import knou.lms.msg.vo.MsgTmpltVO;

@Service("msgTmpltService")
public class MsgTmpltServiceImpl extends ServiceBase implements MsgTmpltService {

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

    private static final String ORG_MSG = "ORG_MSG";

    /**
     * 템플릿 삭제 (권한 검증 포함)
     * @param vo
     * @param userId
     * @param isAdmin
     * @return
     * @throws Exception
     */
    @Override
    public int deleteTmplt(MsgTmpltVO vo, String userId, boolean isAdmin) throws Exception {
        String[] ids = vo.getMsgTmpltIds();
        if (ids == null || ids.length == 0) {
            if (vo.getMsgTmpltId() != null) {
                ids = new String[]{vo.getMsgTmpltId()};
            } else {
                return 0;
            }
        }

        for (String id : ids) {
            MsgTmpltVO checkVo = new MsgTmpltVO();
            checkVo.setMsgTmpltId(id);
            MsgTmpltVO existVo = msgTmpltDAO.selectTmplt(checkVo);
            if (existVo != null) {
                boolean hasAuth = ORG_MSG.equals(existVo.getMsgCtsGbncd()) ? isAdmin : userId.equals(existVo.getRgtrId());
                if (!hasAuth) {
                    throw new IllegalAccessException();
                }
            }
        }

        int result = 0;
        for (String id : ids) {
            MsgTmpltVO delVo = new MsgTmpltVO();
            delVo.setMsgTmpltId(id);
            result += msgTmpltDAO.deleteTmplt(delVo);
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
