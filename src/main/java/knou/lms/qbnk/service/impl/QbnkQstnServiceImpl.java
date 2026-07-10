package knou.lms.qbnk.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.qbnk.dao.QbnkQstnDAO;
import knou.lms.qbnk.dao.QbnkQstnVwitmDAO;
import knou.lms.qbnk.service.QbnkQstnService;
import knou.lms.qbnk.vo.QbnkQstnVO;
import knou.lms.qbnk.vo.QbnkQstnVwitmVO;
import knou.lms.qbnk.web.view.QbnkPageInfo;

@Service("qbnkQstnService")
public class QbnkQstnServiceImpl extends ServiceBase implements QbnkQstnService {

	@Resource(name="qbnkQstnDAO")
	private QbnkQstnDAO qbnkQstnDAO;

	@Resource(name="qbnkQstnVwitmDAO")
	private QbnkQstnVwitmDAO qbnkQstnVwitmDAO;

	/**
	* 문제은행문항목록조회
	*
	* @param upQbnkCtgrId 	상위문제은행분류아이디
    * @param qbnkCtgrId 	문제은행분류아이디
    * @param sbjctId 		과목아이디
    * @param userId	 		사용자아이디
    * @param searchValue 	검색어(문항제목)
    * @param searchKey 		검색키(현재 과목아이디)
	* @return 문제은행문항목록
	*/
	@Override
	public ResultDTO<EgovMap> qbnkQstnList(QbnkPageInfo pageInfo) {
        ResultDTO<EgovMap> resultDto = new ResultDTO<EgovMap>(pageInfo);
		resultDto.setReturnList(qbnkQstnDAO.qbnkQstnList(pageInfo));
		if(resultDto.getReturnList().size() > 0) {
			resultDto.getPageInfo().setTotalRecordCount(Integer.parseInt(resultDto.getReturnList().get(0).get("totalCnt").toString()));
		} else {
			resultDto.getPageInfo().setTotalRecordCount(0);
		}

        return resultDto;
	}

	/**
     * 교수문항복사문제은행문항목록조회
     *
     * @param qbnkCtgrId 	문제은행문항아이디
     * @param sbjctId 		과목아이디
     * @return 문제은행문항목록
     */
    @Override
    public List<EgovMap> profQstnCopyQbnkQstnList(QbnkQstnVO vo) {
        return qbnkQstnDAO.profQstnCopyQbnkQstnList(vo);
    }

    /**
     * 문제은행문항조회
     *
     * @param qbnkCtgrId 	문제은행문항아이디
     * @return 문제은행문항
     */
	public EgovMap qbnkQstnSelect(QbnkQstnVO vo) {
		return qbnkQstnDAO.qbnkQstnSelect(vo);
	}

	/**
     * 문제은행문항등록
     *
     * @param QbnkQstnVO
     */
    @Override
    public void qbnkQstnRegist(QbnkQstnVO vo, String qstnsStr) {
    	ObjectMapper mapper = new ObjectMapper();
    	List<Map<String, Object>> qstns = new ArrayList<Map<String,Object>>();
    	try {
    		qstns = mapper.readValue(qstnsStr, new TypeReference<List<Map<String, Object>>>() {});	// 문항보기항목정보
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

    	// 1. 문항 등록
    	vo.setQbnkQstnId(IdGenUtil.genNewId(IdPrefixType.QBQSN));
    	vo.setQstnSeqno(qbnkQstnDAO.qbnkNextQstnSeqnoSelect(vo));
    	qbnkQstnDAO.qbnkQstnRegist(vo);

    	// 2. 문항보기항목 일괄등록
    	if (qstns != null && !qstns.isEmpty()) {
            List<QbnkQstnVwitmVO> vwitmList = new ArrayList<QbnkQstnVwitmVO>();

            for (Map<String, Object> map : qstns) {
            	QbnkQstnVwitmVO vwitm = new QbnkQstnVwitmVO();

            	vwitm.setQbnkQstnId(vo.getQbnkQstnId());
            	vwitm.setRgtrId(vo.getRgtrId());
            	vwitm.setQbnkQstnVwitmId(IdGenUtil.genNewId(IdPrefixType.QBQVW));
            	vwitm.setVwitmCts((String) map.get("qstnVwitmCts"));
            	vwitm.setCransyn((String) map.get("cransYn"));
            	vwitm.setVwitmSeqno((Integer) map.get("qstnVwitmSeqno"));

                vwitmList.add(vwitm);
            }
            qbnkQstnVwitmDAO.qbnkQstnVwitmBulkRegist(vwitmList);
        }
    }

    /**
     * 문제은행문항수정
     *
     * @param QbnkQstnVO
     */
    @Override
    public void qbnkQstnModify(QbnkQstnVO vo, String qstnsStr) {
    	ObjectMapper mapper = new ObjectMapper();
    	List<Map<String, Object>> qstns = new ArrayList<Map<String,Object>>();
    	try {
    		qstns = mapper.readValue(qstnsStr, new TypeReference<List<Map<String, Object>>>() {});	// 문항보기항목정보
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

    	// 1. 문항 수정
    	qbnkQstnDAO.qbnkQstnModfiy(vo);

    	// 2. 기존 문항보기항목 삭제
    	qbnkQstnVwitmDAO.qbnkQstnVwitmDelete(vo);

    	// 3. 신규 문항보기항목 일괄등록
    	if (qstns != null && !qstns.isEmpty()) {
    		List<QbnkQstnVwitmVO> vwitmList = new ArrayList<QbnkQstnVwitmVO>();

    		for (Map<String, Object> map : qstns) {
    			QbnkQstnVwitmVO vwitm = new QbnkQstnVwitmVO();

    			vwitm.setQbnkQstnId(vo.getQbnkQstnId());
    			vwitm.setRgtrId(vo.getRgtrId());
    			vwitm.setQbnkQstnVwitmId(IdGenUtil.genNewId(IdPrefixType.QBQVW));
    			vwitm.setVwitmCts((String) map.get("qstnVwitmCts"));
    			vwitm.setCransyn((String) map.get("cransYn"));
    			vwitm.setVwitmSeqno((Integer) map.get("qstnVwitmSeqno"));

    			vwitmList.add(vwitm);
    		}
    		qbnkQstnVwitmDAO.qbnkQstnVwitmBulkRegist(vwitmList);
    	}
    }

    /**
	 * 문제은행문항삭제
	 *
	 * @param QbnkQstnVO
	 */
	public void qbnkQstnDelete(QbnkQstnVO vo) {
		// 1. 문제은행문항 삭제여부 수정
		qbnkQstnDAO.qbnkQstnDelynModify(vo);

		// 2. 문제은행문항 미삭제 순번 수정
		qbnkQstnDAO.qbnkQstnDelNSeqnoModify(vo);
	}

}
