package knou.lms.msg.service.impl;

import knou.framework.common.CommConst;
import knou.framework.common.ServiceBase;
import knou.lms.msg.dao.MsgRcptnAuthDAO;
import knou.lms.msg.service.MsgRcptnAuthService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Service("msgRcptnAuthService")
public class MsgRcptnAuthServiceImpl extends ServiceBase implements MsgRcptnAuthService {

    @Resource(name = "msgRcptnAuthDAO")
    private MsgRcptnAuthDAO msgRcptnAuthDAO;

    private static final int IN_CHUNK_SIZE = 900;

    private static final String CHNL_EML = "EML";

    // LMS는 PM 확인 후 판정 기준(SMS 비트 공유 여부) 확정되면 추가 예정
    private static final Set<String> SUPPORTED_CHNLS = new HashSet<>(Arrays.asList(
            CommConst.MSG_CHNL_SHRTNT,
            CommConst.MSG_CHNL_SMS,
            CommConst.MSG_CHNL_PUSH,
            CommConst.MSG_CHNL_ALIM_TALK,
            CHNL_EML
    ));

    /*****************************************************
     * 채널별 수신 허용 사용자 ID 목록 반환
     * @param userIds
     * @param chnlCd
     * @return List<String>
     ******************************************************/
    @Override
    public List<String> filterRcptnAllowedUserIds(List<String> userIds, String chnlCd) {
        if (userIds == null || userIds.isEmpty()) {
            return Collections.emptyList();
        }
        Set<String> rejectedSet = new HashSet<>(selectRcptnPrmNoUserIdList(userIds, chnlCd));
        List<String> allowed = new ArrayList<>(userIds.size());
        for (String userId : userIds) {
            if (!rejectedSet.contains(userId)) {
                allowed.add(userId);
            }
        }
        return allowed;
    }

    /*****************************************************
     * 채널별 수신 거부 사용자 ID 목록 반환
     * Oracle IN 1000개 제한 대응을 위해 chunk 단위로 조회
     * @param userIds
     * @param chnlCd
     * @return List<String>
     ******************************************************/
    @Override
    public List<String> selectRcptnPrmNoUserIdList(List<String> userIds, String chnlCd) {
        if (userIds == null || userIds.isEmpty()) {
            return Collections.emptyList();
        }
        validateChnlCd(chnlCd);

        List<String> result = new ArrayList<>();
        int total = userIds.size();
        for (int i = 0; i < total; i += IN_CHUNK_SIZE) {
            List<String> chunk = userIds.subList(i, Math.min(i + IN_CHUNK_SIZE, total));
            Map<String, Object> param = new HashMap<>();
            param.put("userIds", chunk);
            param.put("chnlCd", chnlCd);
            result.addAll(msgRcptnAuthDAO.selectRcptnPrmNoUserIdList(param));
        }
        return result;
    }

    /*****************************************************
     * 단건 수신 허용 여부 판정
     * @param userId
     * @param chnlCd
     * @return boolean
     ******************************************************/
    @Override
    public boolean isRcptnAllowed(String userId, String chnlCd) {
        if (userId == null || userId.isEmpty()) {
            return false;
        }
        validateChnlCd(chnlCd);

        Map<String, Object> param = new HashMap<>();
        param.put("userId", userId);
        param.put("chnlCd", chnlCd);
        return "Y".equals(msgRcptnAuthDAO.selectRcptnPrmYn(param));
    }

    private void validateChnlCd(String chnlCd) {
        if (chnlCd == null || !SUPPORTED_CHNLS.contains(chnlCd)) {
            throw new IllegalArgumentException("Unsupported chnlCd: " + chnlCd);
        }
    }

}
