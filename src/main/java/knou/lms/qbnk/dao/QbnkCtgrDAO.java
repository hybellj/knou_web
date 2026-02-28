package knou.lms.qbnk.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.qbnk.vo.QbnkCtgrVO;

@Mapper("qbnkCtgrDAO")
public interface QbnkCtgrDAO {

	/**
	 * 교수문제은행분류목록조회
	 *
	 * @param sbjctId 		과목아이디
	 * @param upQbnkCtgrId 	상위문제은행분류아이디
	 * @param qbnkQstnGbncd 문제은행문항구분코드
	 * return 문제은행분류 목록
	 * @throws Exception
	 */
	public List<QbnkCtgrVO> profQbnkCtgrList(QbnkCtgrVO vo) throws Exception;

}
