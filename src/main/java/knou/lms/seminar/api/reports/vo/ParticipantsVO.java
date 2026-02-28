package knou.lms.seminar.api.reports.vo;

import java.io.Serializable;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlElementWrapper;

import knou.lms.seminar.api.common.vo.PagenationVO;

public class ParticipantsVO extends PagenationVO implements Serializable {

    private static final long serialVersionUID = 3713659177848872076L;
    
    @JacksonXmlElementWrapper(useWrapping = false)
    @JsonProperty("participants")
    private List<ParticipantVO> participants;

    public List<ParticipantVO> getParticipants() {
        return participants;
    }

    @Override
    @JsonIgnore
    public List<ParticipantVO> getObjects() {
        return participants;
    }

}
