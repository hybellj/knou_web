package knou.lms.msg.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.lms.msg.dao.MsgSndngCostDAO;
import knou.lms.msg.service.MsgSndngCostService;
import knou.lms.msg.vo.MsgSndngCostVO;

@Service("msgSndngCostService")
public class MsgSndngCostServiceImpl extends ServiceBase implements MsgSndngCostService {

    @Resource(name = "msgSndngCostDAO")
    private MsgSndngCostDAO msgSndngCostDAO;

    /*****************************************************
     * 발송단가 목록 조회
     * @return List<MsgSndngCostVO>
     ******************************************************/
    @Override
    public List<MsgSndngCostVO> selectSndngCostList() throws Exception {
        return msgSndngCostDAO.selectSndngCostList(new MsgSndngCostVO());
    }

    /*****************************************************
     * 발송단가 등록
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int insertSndngCost(MsgSndngCostVO vo) throws Exception {
        String sndngCostId = IdGenerator.getNewId(IdPrefixType.MSCOS.getCode());
        vo.setSndngCostId(sndngCostId);
        return msgSndngCostDAO.insertSndngCost(vo);
    }

    /*****************************************************
     * 발송단가 수정
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int updateSndngCost(MsgSndngCostVO vo) throws Exception {
        return msgSndngCostDAO.updateSndngCost(vo);
    }
}
