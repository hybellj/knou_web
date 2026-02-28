package knou.lms.qbnk.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.qbnk.dao.QbnkCtgrDAO;
import knou.lms.qbnk.service.QbnkCtgrService;
import knou.lms.qbnk.vo.QbnkCtgrVO;

@Service("qbnkCtgrService")
public class QbnkCtgrServiceImpl extends ServiceBase implements QbnkCtgrService {

	@Resource(name="qbnkCtgrDAO")
	private QbnkCtgrDAO qbnkCtgrDAO;

	/**
	 * 교수문제은행분류목록조회
	 *
	 * @param sbjctId 		과목아이디
	 * @param upQbnkCtgrId 	상위문제은행분류아이디
	 * @param qbnkQstnGbncd 문제은행문항구분코드
	 * return 문제은행분류 목록
	 * @throws Exception
	 */
	public List<QbnkCtgrVO> profQbnkCtgrList(QbnkCtgrVO vo) throws Exception {
		return qbnkCtgrDAO.profQbnkCtgrList(vo);
	}

}
