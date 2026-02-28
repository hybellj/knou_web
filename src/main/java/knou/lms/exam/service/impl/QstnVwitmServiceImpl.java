package knou.lms.exam.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.exam.dao.QstnVwitmDAO;
import knou.lms.exam.service.QstnVwitmService;
import knou.lms.exam.vo.QstnVwitmVO;

@Service("qstnVwitmService")
public class QstnVwitmServiceImpl extends ServiceBase implements QstnVwitmService {

	@Resource(name="qstnVwitmDAO")
	private QstnVwitmDAO qstnVwitmDAO;

	/**
	 * 문항보기항목목록조회
	 *
	 * @param qstnId 문항아이디
	 * return 문항보기항목 목록
	 * @throws Exception
	 */
	@Override
	public List<QstnVwitmVO> qstnVwitmList(QstnVwitmVO vo) throws Exception {
		return qstnVwitmDAO.qstnVwitmList(vo);
	}

	/**
	 * 문항보기항목일괄목록조회
	 *
	 * @param examDtlId 시험상세아이디
	 * return 문항보기항목 목록
	 * @throws Exception
	 */
	@Override
	public List<QstnVwitmVO> qstnVwitmBulkList(String examDtlId) throws Exception {
		return qstnVwitmDAO.qstnVwitmBulkList(examDtlId);
	}

}
