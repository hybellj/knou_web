package knou.lms.qbnk.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.qbnk.dao.QbnkQstnVwitmDAO;
import knou.lms.qbnk.service.QbnkQstnVwitmService;
import knou.lms.qbnk.vo.QbnkQstnVO;
import knou.lms.qbnk.vo.QbnkQstnVwitmVO;

@Service("qbnkQstnVwitmService")
public class QbnkQstnVwitmServiceImpl extends ServiceBase implements QbnkQstnVwitmService {

	@Resource(name="qbnkQstnVwitmDAO")
	private QbnkQstnVwitmDAO qbnkQstnVwitmDAO;

	/**
	 * 문제은행문항보기항목목록조회
	 *
	 * @param qbnkQstnId 문제은행문항아이디
	 * return 문제은행문항보기항목 목록
	 * @throws Exception
	 */
	@Override
	public List<QbnkQstnVwitmVO> qbnkQstnVwitmList(QbnkQstnVO vo) throws Exception {
		return qbnkQstnVwitmDAO.qbnkQstnVwitmList(vo);
	}

}
