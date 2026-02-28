package knou.lms.seminar.api.common.vo;

import java.io.Serializable;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

public abstract class PagenationVO implements Serializable {

    private static final long serialVersionUID = -8684749003374859188L;
    @JsonProperty("page_count")
    private int pageCount;
    @JsonProperty("page_size")
    private int pageSize;
    @JsonProperty("total_records")
    private int totalRecords;
    @JsonProperty("next_page_token")
    private String nextPageToken;

    public int getPageCount() {
        return pageCount;
    }
    public void setPageCount(int pageCount) {
        this.pageCount = pageCount;
    }
    public int getPageSize() {
        return pageSize;
    }
    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }
    public int getTotalRecords() {
        return totalRecords;
    }
    public void setTotalRecords(int totalRecords) {
        this.totalRecords = totalRecords;
    }
    public String getNextPageToken() {
        return nextPageToken;
    }
    public void setNextPageToken(String nextPageToken) {
        this.nextPageToken = nextPageToken;
    }
    
    @JsonIgnore
    @SuppressWarnings("rawtypes")
    public abstract List getObjects();

}
