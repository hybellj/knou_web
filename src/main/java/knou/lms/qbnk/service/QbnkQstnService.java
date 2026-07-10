package knou.lms.qbnk.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.dto.ResultDTO;
import knou.lms.qbnk.vo.QbnkQstnVO;
import knou.lms.qbnk.web.view.QbnkPageInfo;

public interface QbnkQstnService {

	// 문제은행문항목록조회
	public ResultDTO<EgovMap> qbnkQstnList(QbnkPageInfo pageInfo);

	// 교수문항복사문제은행문항목록조회
	public List<EgovMap> profQstnCopyQbnkQstnList(QbnkQstnVO vo);

	// 문제은행문항조회
	public EgovMap qbnkQstnSelect(QbnkQstnVO vo);

	// 문제은행문항등록
	public void qbnkQstnRegist(QbnkQstnVO vo, String qstnsStr);

	// 문제은행문항수정
	public void qbnkQstnModify(QbnkQstnVO vo, String qstnsStr);

	// 문제은행문항삭제
	public void qbnkQstnDelete(QbnkQstnVO vo);

}
