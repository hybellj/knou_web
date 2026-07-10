package knou.lms.smnr.pltfrm.service.impl;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.lms.smnr.pltfrm.dao.OnlnPltfrmAuthrtDAO;
import knou.lms.smnr.pltfrm.service.OnlnPltfrmAuthrtService;
import knou.lms.smnr.pltfrm.service.OnlnPltfrmStngService;
import knou.lms.smnr.pltfrm.vo.OnlnPltfrmAuthrtVO;
import knou.lms.smnr.pltfrm.vo.OnlnPltfrmStngVO;
import knou.lms.smnr.pltfrm.zoom.api.common.ZoomTokenClient;

@Service("onlnPltfrmAuthrtService")
public class OnlnPltfrmAuthrtServiceImpl extends ServiceBase implements OnlnPltfrmAuthrtService {

	@Resource(name="onlnPltfrmStngService")
	private OnlnPltfrmStngService onlnPltfrmStngService;

	@Resource(name="onlnPltfrmAuthrtDAO")
	private OnlnPltfrmAuthrtDAO onlnPltfrmAuthrtDAO;

	@Autowired
	private ZoomTokenClient zoomTokenClient;

	/**
     * 온라인플랫폼권한갱신
     *
     * @param pltfrmGbncd	플랫폼구분코드
     * @param orgId			기관아이디
     * @param userId		사용자아이디
     * @return 온라인플랫폼권한
     */
	@Override
	public OnlnPltfrmAuthrtVO onlnPltfrmAuthrtUpdt(String pltfrmGbncd, String orgId, String userId) {
		// 온라인플랫폼설정조회
		OnlnPltfrmStngVO config = onlnPltfrmStngService.onlnPltfrmStngSelect(pltfrmGbncd, orgId);

		// 온라인플랫폼권한조회
		OnlnPltfrmAuthrtVO authrtVO = onlnPltfrmAuthrtDAO.onlnPltfrmAuthrtSelect(config.getOnlnPltfrmStngId());
		if(authrtVO != null) {
			return authrtVO;
		}

		// 토큰신규발급
		JsonNode tokenJson  = zoomTokenClient.fetchToken(config.getPltfrmCntnId(), config.getPltfrmCntnClientId(), config.getPltfrmCntnClientPswd());
        String authrtTkn  	= tokenJson.path("access_token").asText();	// 권한토큰
        int    expiresIn    = tokenJson.path("expires_in").asInt();		// 토큰만료일시 (초)

        // 토큰만료일시계산
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
        String tknExpDttm = LocalDateTime.now().plusSeconds(expiresIn).format(formatter);

        // Onwer 정보 조회
        JsonNode onwerInfo = zoomTokenClient.getOnwerInfo(authrtTkn);
        String authrtEml = onwerInfo.path("email").asText();

        // 온라인플랫폼권한아이디
        String onlnPltfrmAuthrtId = onlnPltfrmAuthrtDAO.onlnPltfrmAuthrtIdSelect(config.getOnlnPltfrmStngId(), authrtEml);

        // 온라인플랫폼권한등록
        authrtVO = new OnlnPltfrmAuthrtVO();
        authrtVO.setOnlnPltfrmAuthrtId(onlnPltfrmAuthrtId != null ? onlnPltfrmAuthrtId : IdGenUtil.genNewId(IdPrefixType.OPLAU));
        authrtVO.setOnlnPltfrmStngId(config.getOnlnPltfrmStngId());
        authrtVO.setAuthrtTkn(authrtTkn);
        authrtVO.setTknExpDttm(tknExpDttm);
        authrtVO.setAuthrtEml(authrtEml);
        authrtVO.setRgtrId(userId);
        onlnPltfrmAuthrtDAO.onlnPltfrmAuthrtRegist(authrtVO);

		return authrtVO;
	}

	/**
	 * 온라인플랫폼권한목록
	 *
	 * @param orgId 		기관아이디
	 * @param searchValue 	검색어(계정이메일)
	 * @param pltfrmGbncd 	플랫폼구분코드
	 * @return List<EgovMap>
	 */
	@Override
	public List<EgovMap> onlnPltfrmAuthrtList(OnlnPltfrmStngVO vo) {
		return onlnPltfrmAuthrtDAO.onlnPltfrmAuthrtList(vo);
	}

	/**
	 * 온라인플랫폼권한일괄삭제
	 *
	 * @param onlnPltfrmStngId 	온라인플랫폼설정아이디
	 */
	@Override
	public void onlnPltfrmAuthrtBulkDelete(String onlnPltfrmStngId) {
		onlnPltfrmAuthrtDAO.onlnPltfrmAuthrtBulkDelete(onlnPltfrmStngId);
	}

}
