package knou.lms.qbnk.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.qbnk.vo.QbnkQstnVO;
import knou.lms.qbnk.web.view.QbnkPageInfo;

@Mapper("qbnkQstnDAO")
public interface QbnkQstnDAO {

	// 문제은행문항목록조회
	public List<EgovMap> qbnkQstnList(QbnkPageInfo pageInfo);

	// 교수문항복사문제은행문항목록조회
	public List<EgovMap> profQstnCopyQbnkQstnList(QbnkQstnVO vo);

	// 문제은행문항조회
	public EgovMap qbnkQstnSelect(QbnkQstnVO vo);

	// 문제은행문항등록
	public void qbnkQstnRegist(QbnkQstnVO vo);

	// 문제은행다음문항순번조회
	public int qbnkNextQstnSeqnoSelect(QbnkQstnVO vo);

	// 문제은행문항수정
	public void qbnkQstnModfiy(QbnkQstnVO vo);

	// 문제은행문항삭제여부수정
	public void qbnkQstnDelynModify(QbnkQstnVO vo);

	// 문제은행문항미삭제순번수정
	public void qbnkQstnDelNSeqnoModify(QbnkQstnVO vo);

}
