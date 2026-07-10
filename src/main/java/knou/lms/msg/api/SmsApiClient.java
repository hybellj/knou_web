package knou.lms.msg.api;

import knou.framework.common.CommConst;
import knou.framework.util.StringUtil;
import knou.lms.msg.vo.MsgSmsVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Component
public class SmsApiClient {

    private static final Logger log = LoggerFactory.getLogger(SmsApiClient.class);

    private static final String URL_SMS = CommConst.SMS_API_BASE_URL + "/api/message/sendSMS.v1.0";
    private static final String URL_LMS = CommConst.SMS_API_BASE_URL + "/api/message/sendLMS.v1.0";

    private static final String STSCD_SCS  = "SCS";
    private static final String STSCD_FAIL = "FAIL";

    @Resource(name = "simpleRestTemplate")
    private RestTemplate restTemplate;

    public static class SmsApiResult {
        private final int succCnt;
        private final int failCnt;

        public SmsApiResult(int succCnt, int failCnt) {
            this.succCnt = succCnt;
            this.failCnt = failCnt;
        }

        public int getSuccCnt() { return succCnt; }
        public int getFailCnt() { return failCnt; }
    }

    /*****************************************************
     * @param orgTycd
     * @param mblSndngTycd
     * @param sender
     * @param subject
     * @param content
     * @param rsrvSndngSdttm
     * @param rcvrList
     * @return SmsApiResult
     ******************************************************/
    public SmsApiResult sendAll(String orgTycd, String mblSndngTycd, String sender,
                                String subject, String content, String rsrvSndngSdttm,
                                List<MsgSmsVO> rcvrList) {
        if (rcvrList == null || rcvrList.isEmpty()) {
            return new SmsApiResult(0, 0);
        }

        String apiKey = CommConst.framework.getString("sms.api.key." + orgTycd);
        if (apiKey == null || apiKey.isEmpty()) {
            for (MsgSmsVO rcvr : rcvrList) {
                rcvr.setSndngYn("N");
                rcvr.setSndngStscd(STSCD_FAIL);
                rcvr.setSndngRsltCts("API KEY 미설정");
            }
            return new SmsApiResult(0, rcvrList.size());
        }

        List<MsgSmsVO> validRcvrs = new ArrayList<>();
        int preFail = 0;
        for (MsgSmsVO rcvr : rcvrList) {
            if (StringUtil.isNull(rcvr.getMblPhn())) {
                rcvr.setSndngYn("N");
                rcvr.setSndngStscd(STSCD_FAIL);
                rcvr.setSndngRsltCts("수신자 전화번호 없음");
                preFail++;
            } else {
                validRcvrs.add(rcvr);
            }
        }

        if (validRcvrs.isEmpty()) {
            return new SmsApiResult(0, preFail);
        }

        String url = "LMS".equals(mblSndngTycd) ? URL_LMS : URL_SMS;

        List<Map<String, Object>> receivers = new ArrayList<>();
        for (MsgSmsVO rcvr : validRcvrs) {
            Map<String, Object> receiver = new LinkedHashMap<>();
            receiver.put("phoneNumber", rcvr.getMblPhn());
            if (!StringUtil.isNull(rcvr.getRcvrnm())) {
                receiver.put("name", rcvr.getRcvrnm());
            }
            receivers.add(receiver);
        }

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("content", content != null ? content : "");
        body.put("sender", sender != null ? sender : "");
        body.put("receivers", receivers);

        if (!StringUtil.isNull(rsrvSndngSdttm)) {
            body.put("scheduled", true);
            body.put("sendDate", rsrvSndngSdttm);
        }

        if ("LMS".equals(mblSndngTycd)) {
            body.put("subject", subject != null ? subject : "");
        }

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("apiKey", apiKey);

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);
        log.info("[SmsApiClient] url={}, request={}", url, body);

        Map<String, Object> response = restTemplate.postForObject(url, entity, Map.class);
        log.info("[SmsApiClient] response={}", response);

        String resultMessage = response != null ? String.valueOf(response.get("resultMessage")) : "no response";

        if (response == null || !"SUCCESS".equals(response.get("result"))) {
            log.warn("일괄 발송 실패: {}", resultMessage);
            for (MsgSmsVO rcvr : validRcvrs) {
                rcvr.setSndngYn("N");
                rcvr.setSndngStscd(STSCD_FAIL);
                rcvr.setSndngRsltCts(resultMessage);
            }
            return new SmsApiResult(0, preFail + validRcvrs.size());
        }

        for (MsgSmsVO rcvr : validRcvrs) {
            rcvr.setSndngYn("Y");
            rcvr.setSndngStscd(STSCD_SCS);
            rcvr.setSndngRsltCts(resultMessage);
        }
        return new SmsApiResult(validRcvrs.size(), preFail);
    }
}
