package knou.lms.smnr.pltfrm.service.impl;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.CryptoUtil;
import knou.framework.util.IdGenUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.smnr.pltfrm.dao.OnlnPltfrmAuthrtDAO;
import knou.lms.smnr.pltfrm.dao.OnlnPltfrmStngDAO;
import knou.lms.smnr.pltfrm.service.OnlnPltfrmStngService;
import knou.lms.smnr.pltfrm.vo.OnlnPltfrmAuthrtVO;
import knou.lms.smnr.pltfrm.vo.OnlnPltfrmStngVO;
import knou.lms.smnr.pltfrm.zoom.api.common.ZoomTokenClient;

@Service("onlnPltfrmStngService")
public class OnlnPltfrmStngServiceImpl extends ServiceBase implements OnlnPltfrmStngService {

	@Resource(name="onlnPltfrmStngDAO")
	private OnlnPltfrmStngDAO onlnPltfrmStngDAO;

	@Resource(name="onlnPltfrmAuthrtDAO")
	private OnlnPltfrmAuthrtDAO onlnPltfrmAuthrtDAO;

	@Autowired
	private ZoomTokenClient zoomTokenClient;

	/**
	 * 온라인플랫폼설정등록
	 *
	 * @param OnlnPltfrmStngVO
	 */
	@Override
	public ResultDTO<EgovMap> onlnPltfrmStngRegist(OnlnPltfrmStngVO vo) {
		// 토큰발급
		JsonNode tokenJson = zoomTokenClient.fetchToken(vo.getPltfrmCntnId(), vo.getPltfrmCntnClientId(), vo.getPltfrmCntnClientPswd());

		String authrtTkn  	= tokenJson.path("access_token").asText();	// 권한토큰
		int    expiresIn    = tokenJson.path("expires_in").asInt();		// 토큰만료일시 (초)

		// 토큰만료일시계산
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		String tknExpDttm = LocalDateTime.now().plusSeconds(expiresIn).format(formatter);

		// Onwer 정보 조회
		JsonNode onwerInfo = zoomTokenClient.getOnwerInfo(authrtTkn);
		System.out.println(onwerInfo);
		System.out.println(onwerInfo.path("email").asText());
		String authrtEml = onwerInfo.path("email").asText();

		// 온라인플랫폼설정등록
		if(vo.getOnlnPltfrmStngId() == null || "".equals(vo.getOnlnPltfrmStngId())) {
			vo.setOnlnPltfrmStngId(IdGenUtil.genNewId(IdPrefixType.OPSTG));
		}
		try {
			vo.setPltfrmCntnId(CryptoUtil.encryptAes256(vo.getPltfrmCntnId()));
			vo.setPltfrmCntnClientId(CryptoUtil.encryptAes256(vo.getPltfrmCntnClientId()));
			vo.setPltfrmCntnClientPswd(CryptoUtil.encryptAes256(vo.getPltfrmCntnClientPswd()));
		} catch(NoSuchAlgorithmException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (GeneralSecurityException e) {
			e.printStackTrace();
		}
		onlnPltfrmStngDAO.onlnPltfrmStngRegist(vo);

		// 온라인플랫폼권한아이디
		String onlnPltfrmAuthrtId = onlnPltfrmAuthrtDAO.onlnPltfrmAuthrtIdSelect(vo.getOnlnPltfrmStngId(), authrtEml);

		// 온라인플랫폼권한등록
		OnlnPltfrmAuthrtVO authrtVO = new OnlnPltfrmAuthrtVO();
		authrtVO.setOnlnPltfrmAuthrtId(onlnPltfrmAuthrtId != null ? onlnPltfrmAuthrtId : IdGenUtil.genNewId(IdPrefixType.OPLAU));
		authrtVO.setOnlnPltfrmStngId(vo.getOnlnPltfrmStngId());
		authrtVO.setAuthrtTkn(authrtTkn);
		authrtVO.setTknExpDttm(tknExpDttm);
		authrtVO.setAuthrtEml(authrtEml);
		authrtVO.setRgtrId(vo.getRgtrId());
		onlnPltfrmAuthrtDAO.onlnPltfrmAuthrtRegist(authrtVO);

		return new ResultDTO<EgovMap>().setResultSuccess();
	}

	/**
	 * 온라인플랫폼설정삭제
	 *
	 * @param OnlnPltfrmStngVO
	 */
	@Override
	public void onlnPltfrmStngDelete(OnlnPltfrmStngVO vo) {
		onlnPltfrmStngDAO.onlnPltfrmStngDelete(vo);
	}

	/**
	 * 온라인플랫폼설정조회
	 *
	 * @param pltfrmGbncd	플랫폼구분코드
	 * @param orgId			기관아이디
	 * @return 온라인플랫폼설정
	 */
	public OnlnPltfrmStngVO onlnPltfrmStngSelect(String pltfrmGbncd, String orgId) {
		OnlnPltfrmStngVO config = onlnPltfrmStngDAO.onlnPltfrmStngSelect(pltfrmGbncd, orgId);
		try {
			config.setPltfrmCntnId(CryptoUtil.decryptAes256(config.getPltfrmCntnId()));
			config.setPltfrmCntnClientId(CryptoUtil.decryptAes256(config.getPltfrmCntnClientId()));
			config.setPltfrmCntnClientPswd(CryptoUtil.decryptAes256(config.getPltfrmCntnClientPswd()));
		} catch(NoSuchAlgorithmException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (GeneralSecurityException e) {
			e.printStackTrace();
		}

		return config;
	}

}
