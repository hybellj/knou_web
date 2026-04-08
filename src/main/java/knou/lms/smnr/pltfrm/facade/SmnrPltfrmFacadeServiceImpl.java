package knou.lms.smnr.pltfrm.facade;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.smnr.pltfrm.service.OnlnPltfrmUserService;

@Service("smnrPltfrmFacadeService")
public class SmnrPltfrmFacadeServiceImpl extends ServiceBase implements SmnrPltfrmFacadeService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SmnrPltfrmFacadeServiceImpl.class);

	@Resource(name="onlnPltfrmUserService")
	private OnlnPltfrmUserService onlnPltfrmUserService;

	@Override
	public int getPendingOnlnPltfrmUserCntSelect(List<Map<String, Object>> subSmnrs) throws Exception {
		return onlnPltfrmUserService.pendingOnlnPltfrmUserCntSelect(subSmnrs);
	}

}
