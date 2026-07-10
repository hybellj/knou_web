package knou.lms.sbjctinfo.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * 과목정보 > 다국어 자막(스크립트) 조회 VO
 */
public class SbjctInfoSrtVO extends DefaultVO {
    private static final long serialVersionUID = -511237665998791592L;

    private String taskTycd;    //업무유형코드
    private String key;         //키값
    private String keyMsg;      //키 메세지
    private String msg;          //실제 메세지(스크립트)


    public String getTaskTycd() { return taskTycd; }
    public void setTaskTycd(String taskTycd) { this.taskTycd = taskTycd; }

    public String getKey() { return key; }
    public void setKey(String key) { this.key = key; }

    public String getKeyMsg() { return keyMsg; }
    public void setKeyMsg(String keyMsg) { this.keyMsg = keyMsg; }

    public String getMsg() { return msg; }
    public void setMsg(String msg) { this.msg = msg; }
}
