package knou.lms.smnr.service.impl;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.lms.smnr.dao.SmnrAtndHstryDAO;
import knou.lms.smnr.service.SmnrAtndHstryService;
import knou.lms.smnr.vo.SmnrAtndHstryVO;
import knou.lms.smnr.vo.SmnrVO;

@Service("smnrAtndHstryService")
public class SmnrAtndHstryServiceImpl extends ServiceBase implements SmnrAtndHstryService {

	@Resource(name="smnrAtndHstryDAO")
	private SmnrAtndHstryDAO smnrAtndHstryDAO;

	/**
	 * 세미나참석이력등록
	 *
	 * @param SmnrAtndHstryVO
	 */
	@Override
	public void smnrAtndHstryRegist(SmnrVO vo) {
        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		SmnrAtndHstryVO hstry = new SmnrAtndHstryVO();
		hstry.setSmnrAtndHstryId(IdGenUtil.genNewId(IdPrefixType.SMATH));
		hstry.setSmnrId(vo.getSmnrId());
		hstry.setAtndeId(vo.getUserId());
		hstry.setAtndSdttm(now.format(formatter));
		hstry.setCntnDvcTycd(vo.getSubParam());
		hstry.setAtndeIp(vo.getRegIp());
		hstry.setRgtrId(vo.getUserId());
		smnrAtndHstryDAO.smnrAtndHstryRegist(hstry);
	}

	/**
	 * 세미나참석이력목록
	 *
	 * @param smnrId	세미나아이디
	 * @return 세미나참석이력목록
	 */
	@Override
	public List<EgovMap> smnrAtndHstryList(SmnrVO vo) {
		return smnrAtndHstryDAO.smnrAtndHstryList(vo);
	}

	/**
	 * 사용자세미나참석이력목록
	 *
	 * @param smnrId	세미나아이디
	 * @param userId	사용자아이디
	 * @return 사용자세미나참석이력목록
	 */
	@Override
	public List<EgovMap> userSmnrAtndHstryList(SmnrAtndHstryVO vo) {
		return smnrAtndHstryDAO.userSmnrAtndHstryList(vo);
	}

	/**
	 * 대상자세미나참석이력목록조회 ( Ez-Grader )
	 *
	 * @param smnrId	세미나아이디
	 * @param userId	사용자아이디
	 * @return 대상자세미나참석이력목록
	 */
	@Override
	public List<EgovMap> trgtrSmnrAtndHstryListByEzGrader(Map<String, Object> params) {
		return smnrAtndHstryDAO.trgtrSmnrAtndHstryListByEzGrader(params);
	}

}
