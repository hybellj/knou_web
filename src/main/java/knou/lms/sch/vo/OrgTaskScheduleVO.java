package knou.lms.sch.vo;

import knou.lms.common.vo.DefaultVO;

public class OrgTaskScheduleVO extends DefaultVO {

    private String taskSchdlId;     // 업무일정아이디
    private String taskSchdlTycd;   // 업무일정유형코드
    private String taskSdttm;       // 업무시작일시
    private String taskEdttm;       // 업무종료일시

    public String getTaskSchdlId() {
        return taskSchdlId;
    }

    public void setTaskSchdlId(String taskSchdlId) {
        this.taskSchdlId = taskSchdlId;
    }

    public String getTaskSchdlTycd() {
        return taskSchdlTycd;
    }

    public void setTaskSchdlTycd(String taskSchdlTycd) {
        this.taskSchdlTycd = taskSchdlTycd;
    }

    public String getTaskSdttm() {
        return taskSdttm;
    }

    public void setTaskSdttm(String taskSdttm) {
        this.taskSdttm = taskSdttm;
    }

    public String getTaskEdttm() {
        return taskEdttm;
    }

    public void setTaskEdttm(String taskEdttm) {
        this.taskEdttm = taskEdttm;
    }
}
