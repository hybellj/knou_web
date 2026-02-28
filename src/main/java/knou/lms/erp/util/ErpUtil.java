package knou.lms.erp.util;

import java.util.Base64;

import knou.framework.common.CommConst;
import knou.framework.util.ValidationUtils;

public class ErpUtil {

    /**
     * 학생 강의평가 URL 생성
     * @param year
     * @param semester
     * @param userId
     * @return String
     * @throws Exception
     */
    public static String getStuLectEvalUrl(String year, String semester, String userId) {
        String lectEvalUrl = null;
        
        if(ValidationUtils.isNotEmpty(year) && ValidationUtils.isNotEmpty(semester) && ValidationUtils.isNotEmpty(userId)) {
            // 강의평가 URL 생성
            String sGbn = "U";
            String sSmt = semester.length() < 2 ? semester+"0" : semester;
            String lectEvalParam = "{\"sYear\":\""+year+"\",\"sSmt\":\""+sSmt+"\",\"sStudentCD\":\""+userId+"\",\"sGbn\":\""+sGbn+"\"}";
            lectEvalUrl = CommConst.LECT_EVAL_POP_URL + new String((Base64.getEncoder()).encode(lectEvalParam.getBytes()));
        }
        
        return lectEvalUrl;
    }
}
