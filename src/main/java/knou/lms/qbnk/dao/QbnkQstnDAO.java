package knou.lms.qbnk.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.qbnk.vo.QbnkQstnVO;

@Mapper("qbnkQstnDAO")
public interface QbnkQstnDAO {

	/**
     * 교수문항복사문제은행문항목록조회
     *
     * @param qbnkCtgrId 	문제은행문항아이디
     * @return 문제은행문항목록
     * @throws Exception
     */
	public List<EgovMap> profQstnCopyQbnkQstnList(QbnkQstnVO vo) throws Exception;

}
