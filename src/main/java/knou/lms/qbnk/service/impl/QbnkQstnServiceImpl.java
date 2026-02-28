package knou.lms.qbnk.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.qbnk.dao.QbnkQstnDAO;
import knou.lms.qbnk.service.QbnkQstnService;
import knou.lms.qbnk.vo.QbnkQstnVO;

@Service("qbnkQstnService")
public class QbnkQstnServiceImpl extends ServiceBase implements QbnkQstnService {

	@Resource(name="qbnkQstnDAO")
	private QbnkQstnDAO qbnkQstnDAO;

	/**
     * 교수문항복사문제은행문항목록조회
     *
     * @param qbnkCtgrId 	문제은행문항아이디
     * @return 문제은행문항목록
     * @throws Exception
     */
    @Override
    public List<EgovMap> profQstnCopyQbnkQstnList(QbnkQstnVO vo) throws Exception {
        return qbnkQstnDAO.profQstnCopyQbnkQstnList(vo);
    }

}
