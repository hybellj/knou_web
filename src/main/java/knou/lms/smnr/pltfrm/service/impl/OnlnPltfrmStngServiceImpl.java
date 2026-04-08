package knou.lms.smnr.pltfrm.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.CryptoUtil;
import knou.framework.util.IdGenUtil;
import knou.lms.smnr.pltfrm.dao.OnlnPltfrmStngDAO;
import knou.lms.smnr.pltfrm.service.OnlnPltfrmStngService;
import knou.lms.smnr.pltfrm.vo.OnlnPltfrmStngVO;

@Service("onlnPltfrmStngService")
public class OnlnPltfrmStngServiceImpl extends ServiceBase implements OnlnPltfrmStngService {

	@Resource(name="onlnPltfrmStngDAO")
	private OnlnPltfrmStngDAO onlnPltfrmStngDAO;

	/**
	 * 온라인플랫폼설정등록
	 *
	 * @param OnlnPltfrmStngVO
	 * @throws Exception
	 */
	@Override
	public void onlnPltfrmStngRegist(OnlnPltfrmStngVO vo) throws Exception {
		vo.setOnlnPltfrmStngId(IdGenUtil.genNewId(IdPrefixType.OPSTG));
		vo.setPltfrmCntnId(CryptoUtil.encryptAes256(vo.getPltfrmCntnId()));
		vo.setPltfrmCntnClientId(CryptoUtil.encryptAes256(vo.getPltfrmCntnClientId()));
		vo.setPltfrmCntnClientPswd(CryptoUtil.encryptAes256(vo.getPltfrmCntnClientPswd()));
		onlnPltfrmStngDAO.onlnPltfrmStngRegist(vo);
	}

	/**
	 * 온라인플랫폼설정수정
	 *
	 * @param OnlnPltfrmStngVO
	 * @throws Exception
	 */
	@Override
	public void onlnPltfrmStngModify(OnlnPltfrmStngVO vo) throws Exception {
		vo.setPltfrmCntnId(CryptoUtil.encryptAes256(vo.getPltfrmCntnId()));
		vo.setPltfrmCntnClientId(CryptoUtil.encryptAes256(vo.getPltfrmCntnClientId()));
		vo.setPltfrmCntnClientPswd(CryptoUtil.encryptAes256(vo.getPltfrmCntnClientPswd()));
		onlnPltfrmStngDAO.onlnPltfrmStngModify(vo);
	}

	/**
	 * 온라인플랫폼설정삭제
	 *
	 * @param OnlnPltfrmStngVO
	 * @throws Exception
	 */
	@Override
	public void onlnPltfrmStngDelete(OnlnPltfrmStngVO vo) throws Exception {
		onlnPltfrmStngDAO.onlnPltfrmStngDelete(vo);
	}

	/**
	 * 온라인플랫폼설정조회
	 *
	 * @param pltfrmGbncd	플랫폼구분코드
	 * @param orgId			기관아이디
	 * @return 온라인플랫폼설정
	 * @throws Exception
	 */
	public OnlnPltfrmStngVO onlnPltfrmStngSelect(String pltfrmGbncd, String orgId) throws Exception {
		OnlnPltfrmStngVO config = onlnPltfrmStngDAO.onlnPltfrmStngSelect(pltfrmGbncd, orgId);
		config.setPltfrmCntnId(CryptoUtil.decryptAes256(config.getPltfrmCntnId()));
		config.setPltfrmCntnClientId(CryptoUtil.decryptAes256(config.getPltfrmCntnClientId()));
		config.setPltfrmCntnClientPswd(CryptoUtil.decryptAes256(config.getPltfrmCntnClientPswd()));
		return config;
	}

}
