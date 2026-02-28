package knou.lms.seminar.api.meetings.vo;

import java.io.Serializable;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlElementWrapper;

import knou.lms.seminar.api.common.vo.PagenationVO;

public class MeetingsVO extends PagenationVO implements Serializable {

    private static final long serialVersionUID = -4897973919672089121L;
    
    @JacksonXmlElementWrapper(useWrapping = false)
    @JsonProperty("meetings")
    private List<MeetingVO> meetings;
    
    public List<MeetingVO> getMeetings() {
        return meetings;
    }

    @Override
    @JsonIgnore
    public List<MeetingVO> getObjects() {
        return meetings;
    }

}
