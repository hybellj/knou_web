package knou.lms.qbnk.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.qbnk.vo.QbnkQstnVO;
import knou.lms.qbnk.vo.QbnkQstnVwitmVO;

@Mapper("qbnkQstnVwitmDAO")
public interface QbnkQstnVwitmDAO {

	// 문제은행문항보기항목일괄등록
	public void qbnkQstnVwitmBulkRegist(List<QbnkQstnVwitmVO> list);

	// 문제은행문항보기항목목록조회
	public List<QbnkQstnVwitmVO> qbnkQstnVwitmList(QbnkQstnVO vo);

	// 문제은행문항보기항목삭제
	public void qbnkQstnVwitmDelete(QbnkQstnVO vo);

}
