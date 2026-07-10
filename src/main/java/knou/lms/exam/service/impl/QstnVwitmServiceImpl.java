package knou.lms.exam.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.exam.dao.QstnVwitmDAO;
import knou.lms.exam.service.QstnVwitmService;
import knou.lms.exam.vo.QstnVO;
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
	 */
	@Override
	public List<QstnVwitmVO> qstnVwitmList(QstnVwitmVO vo) {
		return qstnVwitmDAO.qstnVwitmList(vo);
	}

	/**
	 * 문항보기항목일괄목록조회
	 *
	 * @param examDtlId 			시험상세아이디
	 * @param exrcsSddnQstnBscId 	연습돌발문항기본아이디
	 * return 문항보기항목 목록
	 */
	@Override
	public List<QstnVwitmVO> qstnVwitmBulkList(QstnVO vo) {
		return qstnVwitmDAO.qstnVwitmBulkList(vo);
	}

	/**
	 * 교수미리보기문항보기항목목록조회
	 *
	 * @param qstnId 		문항아이디
	 * @param qstnSeqno 	문항순번
	 * @param searchValue 	검색조건(문항보기항목순번@#문항보기항목순번)
	 * return 문항보기항목목록
	 */
	@Override
	public List<QstnVwitmVO> profPreviewQstnVwitmList(List<Map<String, Object>> list) {
		return qstnVwitmDAO.profPreviewQstnVwitmList(list);
	}

}
