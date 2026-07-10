package knou.lms.msg.service;

import java.util.List;

public interface MsgRcptnAuthService {

    List<String> filterRcptnAllowedUserIds(List<String> userIds, String chnlCd);

    List<String> selectRcptnPrmNoUserIdList(List<String> userIds, String chnlCd);

    boolean isRcptnAllowed(String userId, String chnlCd);

}
