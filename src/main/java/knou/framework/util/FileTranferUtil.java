package knou.framework.util;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.HttpStatusCodeException;
import org.springframework.web.client.RestTemplate;

import knou.lms.common.vo.TransferResultVO;



/*************************************************** 
 * <pre> 
 * 업무 그룹명 : 공통 유틸
 * 서부 업무명 : 파일변환
 * 설         명 : 문서 파일을 PDF 파일로 변환 요청 및 정보 조회
 * 작   성   자 : gilgam
 * 작   성   일 : 2021. 8. 9.
 * Copyright ⓒ MediopiaTec All Right Reserved
 * ======================================
 * 작성자/작성일 : gilgam / 2021. 8. 9.
 * 변경사유/내역 : 최초 작성
 * --------------------------------------
 * 변경자/변경일 :  
 * 변경사유/내역 : 
 * ======================================
 * </pre> 
 ***************************************************/


public class FileTranferUtil {

    /***************************************************** 
     * TODO 변환 서버에 작업(변환작업  또는 정보조회 등) 요청.
     * @param uri
     * @param requestEntity
     * @return ApiResultVO
     * @throws Exception
     ******************************************************/ 
    public static TransferResultVO requestTransferServer(String uri, HttpEntity<?> requestEntity, HttpMethod httpMethod) throws Exception
    {
        TransferResultVO apiResultVO = new TransferResultVO();
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> responseEntity;

        try {
            responseEntity = restTemplate.exchange(uri, httpMethod, requestEntity, String.class);

            apiResultVO.setStatusCd(responseEntity.getStatusCode());
            apiResultVO.setResultCd("S");
            apiResultVO.setResultMsg("success");
            apiResultVO.setResultJsonString(responseEntity.getBody());

        } catch(HttpStatusCodeException ce ) {
            apiResultVO.setStatusCd(ce.getStatusCode());
            apiResultVO.setResultCd("F");
            apiResultVO.setResultMsg(ce.getStatusText());
        }

        return apiResultVO;
    }

}
