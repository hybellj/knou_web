package knou.lms.log2.user.service.impl;

import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.framework.util.ValidationUtils;
import knou.lms.log2.user.dao.LogLrnActvDAO;
import knou.lms.log2.user.service.LogLrnActvService;
import knou.lms.log2.user.vo.LogLrnActvInqHstryVO;
import knou.lms.user.CurrentUser;
import knou.lms.user.vo.UserVO;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service("logLrnActvService")
public class LogLrnActvServiceImpl extends ServiceBase implements LogLrnActvService {

    @Resource(name="logLrnActvDAO")
    private LogLrnActvDAO logLrnActvDAO;

    /**
     * 학습활동조회이력 등록
     * 필수 PARAM: lrnActvId, lrnActvTycd, userId
     *
     * @param vo
     * @throws Exception
     */
    @Override
    public void lrnActvInqHstryRegist(LogLrnActvInqHstryVO vo, @CurrentUser UserContext userCtx) throws Exception {
        if(vo == null
                || ValidationUtils.isEmpty(vo.getLrnActvId())
                || ValidationUtils.isEmpty(vo.getLrnActvTycd())
                || ValidationUtils.isEmpty(vo.getUserId())) {
            return;
        }
        UserVO loginUser = userCtx.getLoginUser();
        vo.setOrgnm(loginUser.getOrgnm());
        vo.setDeptId(loginUser.getDeptId());

        logLrnActvDAO.mergeLrnActvInqHstry(vo);
    }
}
