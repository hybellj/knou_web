package knou.lms.msg.service.impl;

import knou.framework.common.IdPrefixType;
import knou.framework.common.PageInfo;
import knou.framework.common.ServiceBase;
import knou.framework.exception.AccessDeniedException;
import knou.framework.util.IdGenerator;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.dao.MsgTmpltDAO;
import knou.lms.msg.service.MsgTmpltService;
import knou.lms.msg.vo.MsgTmpltVO;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("msgTmpltService")
public class MsgTmpltServiceImpl extends ServiceBase implements MsgTmpltService {

    @Resource(name = "msgTmpltDAO")
    private MsgTmpltDAO msgTmpltDAO;

    /*****************************************************
     * 템플릿 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgTmpltVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgTmpltVO> selectTmpltListPage(MsgTmpltVO vo) throws Exception {
        ProcessResultVO<MsgTmpltVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<MsgTmpltVO> list = msgTmpltDAO.selectTmpltList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);

        return resultVO;
    }

    /*****************************************************
     * 템플릿 상세 조회
     * @param vo
     * @return MsgTmpltVO
     ******************************************************/
    @Override
    public MsgTmpltVO selectTmplt(MsgTmpltVO vo) {
        return msgTmpltDAO.selectTmplt(vo);
    }

    /*****************************************************
     * 템플릿 등록
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int insertTmplt(MsgTmpltVO vo) {
        String msgTmpltId = IdGenerator.getNewId(IdPrefixType.MSTML.getCode());
        vo.setMsgTmpltId(msgTmpltId);
        return msgTmpltDAO.insertTmplt(vo);
    }

    /*****************************************************
     * 템플릿 수정
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updateTmplt(MsgTmpltVO vo) {
        return msgTmpltDAO.updateTmplt(vo);
    }

    private static final String ORG_MSG = "ORG_MSG";

    /*****************************************************
     * 템플릿 삭제
     * @param vo
     * @param userId
     * @param isAdmin
     * @return int
     ******************************************************/
    @Override
    public int deleteTmplt(MsgTmpltVO vo, String userId, boolean isAdmin) {
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
                    throw new AccessDeniedException();
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

    /*****************************************************
     * 템플릿 전체 삭제
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int deleteAllTmplt(MsgTmpltVO vo) {
        return msgTmpltDAO.deleteAllTmplt(vo);
    }

    /*****************************************************
     * 템플릿 엑셀 목록 조회
     * @param vo
     * @return List<MsgTmpltVO>
     ******************************************************/
    @Override
    public List<MsgTmpltVO> selectTmpltExcelList(MsgTmpltVO vo) {
        return msgTmpltDAO.selectTmpltExcelList(vo);
    }
}
