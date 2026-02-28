package knou.lms.seminar.api.cloudrecording.vo;

import java.io.Serializable;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlElementWrapper;

import knou.lms.seminar.api.common.vo.PagenationVO;

public class RecordingsVO extends PagenationVO implements Serializable {

    private static final long serialVersionUID = -6910112126139708160L;

    @JsonProperty("meetings")
    @JacksonXmlElementWrapper(useWrapping = false)
    private List<RecordingVO> recordings;

    public List<RecordingVO> getRecordings() {
        return recordings;
    }

    @Override
    @JsonIgnore
    public List getObjects() {
        return recordings;
    }

}
