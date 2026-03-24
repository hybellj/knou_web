package knou.lms.asmt2.service.impl;

import knou.framework.common.PageInfo;
import knou.lms.asmt2.dao.AsmtDAO;
import knou.lms.asmt2.service.AsmtService;
import knou.lms.asmt2.vo.AsmtVO;
import knou.lms.common.vo.ProcessResultVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("asmt2Service")
public class AsmtServiceImpl extends EgovAbstractServiceImpl implements AsmtService {

    @Resource(name="asmt2DAO")
    private AsmtDAO asmtDAO;


    /**
     * 과제목록 페이징
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<EgovMap> asmtListPaging(AsmtVO vo) throws Exception {
        ProcessResultVO<EgovMap> processResultVO = new ProcessResultVO<>();
        // 페이지 정보 설정
        PageInfo pageInfo = new PageInfo(vo);

        List<EgovMap> asmtList = asmtDAO.asmtListPaging(vo);

        // 페이지 전체 건수정보 설정
        pageInfo.setTotalRecord(asmtList);

        processResultVO.setReturnList(asmtList);
        processResultVO.setPageInfo(pageInfo);

        return processResultVO;
    }

    /**
     * 성적반영비율 수정
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<AsmtVO> mrkRfltrtModify(AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<>();

        try {
            String[] asmtArray = vo.getAsmtArray();
            String[] mrkRfltrtArray = vo.getMrkRfltrtArray();

            if(asmtArray == null || mrkRfltrtArray == null) {
                resultVO.setResult(-1);
                resultVO.setMessage("성적반영비율 수정 대상이 없습니다.");
                return resultVO;
            }

            if(asmtArray.length != mrkRfltrtArray.length) {
                resultVO.setResult(-1);
                resultVO.setMessage("성적반영비율 수정 데이터가 올바르지 않습니다.");
                return resultVO;
            }

            for(int i = 0; i < asmtArray.length; i++) {
                vo.setAsmtId(asmtArray[i]);
                vo.setMrkRfltrt(mrkRfltrtArray[i]);
                asmtDAO.mrkRfltrtModify(vo);
            }

            resultVO.setResult(1);
            resultVO.setMessage("수정하였습니다.");
            resultVO.setReturnVO(vo);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("수정하지 못하였습니다.");
        }

        return resultVO;
    }

    /**
     * 성적공개여부 수정
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<AsmtVO> MrkOynModify(AsmtVO vo) throws Exception {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            asmtDAO.mrkOynModify(vo);

            resultVO.setResult(1);
            resultVO.setMessage("수정하였습니다.");
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("수정하지 못하였습니다.");
        }
        return resultVO;
    }
}
