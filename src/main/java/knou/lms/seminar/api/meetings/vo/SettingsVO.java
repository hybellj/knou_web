package knou.lms.seminar.api.meetings.vo;

import java.io.Serializable;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import knou.lms.seminar.api.common.vo.CustomKeyVO;
import knou.lms.seminar.api.meetings.ApprovalType;

public class SettingsVO implements Serializable {

    private static final long serialVersionUID = 90602428268927889L;
    @JsonProperty("host_video")
    private boolean hostVideo = false;
    @JsonProperty("participant_video")
    private boolean participantVideo = false;
    @JsonProperty("waiting_room")
    private boolean waitingRoom = false;
    @JsonProperty("join_before_host")
    private boolean joinBeforeHost = false;
    @JsonProperty("mute_upon_entry")
    private boolean muteUponEntry = true;
    @JsonProperty("auto_recording")
    private String autoRecording;
    @JsonProperty("approval_type")
    private int approvalType = ApprovalType.AUTOMATICALLY_APPROVE.getType();
    @JsonProperty("meeting_authentication")
    private boolean meetingAuthentication = false;
    @JsonProperty("authentication_option")
    private String authenticationOption;
    @JsonProperty("authentication_domains")
    private String authenticationDomains;
    @JsonProperty("registrants_email_notification")
    private boolean registrantsEmailNotification = false;
    @JsonProperty("custom_keys")
    private List<CustomKeyVO> customKeys;
    @JsonProperty("alternative_hosts")
    private String alternativeHosts;
    @JsonProperty("alternative_hosts_email_notification")
    private boolean alternativeHostsEmailNotification = false;
    // usePmi의 값을 true로 변경할 경우 시스템상의 오류가 발생하므로 true로 변경을 금지한다.
    @JsonProperty("use_pmi")
    private boolean usePmi = false;
    
    public boolean isHostVideo() {
        return hostVideo;
    }
    public void setHostVideo(boolean hostVideo) {
        this.hostVideo = hostVideo;
    }
    public boolean isParticipantVideo() {
        return participantVideo;
    }
    public void setParticipantVideo(boolean participantVideo) {
        this.participantVideo = participantVideo;
    }
    public boolean isJoinBeforeHost() {
        return joinBeforeHost;
    }
    public void setJoinBeforeHost(boolean joinBeforeHost) {
        this.joinBeforeHost = joinBeforeHost;
    }
    public String getAutoRecording() {
        return autoRecording;
    }
    public void setAutoRecording(String autoRecording) {
        this.autoRecording = autoRecording;
    }
    public int getApprovalType() {
        return approvalType;
    }
    public void setApprovalType(int approvalType) {
        this.approvalType = approvalType;
    }
    public boolean isMeetingAuthentication() {
        return meetingAuthentication;
    }
    public void setMeetingAuthentication(boolean meetingAuthentication) {
        this.meetingAuthentication = meetingAuthentication;
    }
    public String getAuthenticationOption() {
        return authenticationOption;
    }
    public void setAuthenticationOption(String authenticationOption) {
        this.authenticationOption = authenticationOption;
    }
    public String getAuthenticationDomains() {
        return authenticationDomains;
    }
    public void setAuthenticationDomains(String authenticationDomains) {
        this.authenticationDomains = authenticationDomains;
    }
    public boolean isRegistrantsEmailNotification() {
        return registrantsEmailNotification;
    }
    public void setRegistrantsEmailNotification(boolean registrantsEmailNotification) {
        this.registrantsEmailNotification = registrantsEmailNotification;
    }
    public List<CustomKeyVO> getCustomKeys() {
        return customKeys;
    }
    public void setCustomKeys(List<CustomKeyVO> customKeys) {
        this.customKeys = customKeys;
    }
    public String getAlternativeHosts() {
        return alternativeHosts;
    }
    public void setAlternativeHosts(String alternativeHosts) {
        this.alternativeHosts = alternativeHosts;
    }
    public boolean isAlternativeHostsEmailNotification() {
        return alternativeHostsEmailNotification;
    }
    public void setAlternativeHostsEmailNotification(boolean alternativeHostsEmailNotification) {
        this.alternativeHostsEmailNotification = alternativeHostsEmailNotification;
    }
    public boolean isUsePmi() {
        return usePmi;
    }
    public void setUsePmi(boolean usePmi) {
        this.usePmi = usePmi;
    }
    
    @Override
    public String toString() {
        return "SettingsVO [hostVideo=" + hostVideo + ", participantVideo=" + participantVideo + ", joinBeforeHost="
                + joinBeforeHost + ", autoRecording=" + autoRecording + ", approvalType=" + approvalType
                + ", meetingAuthentication=" + meetingAuthentication + ", authenticationOption=" + authenticationOption
                + ", authenticationDomains=" + authenticationDomains + ", registrantsEmailNotification="
                + registrantsEmailNotification + ", customKeys=" + customKeys + ", alternativeHosts=" + alternativeHosts
                + ", alternativeHostsEmailNotification=" + alternativeHostsEmailNotification + ", usePmi=" + usePmi
                + "]";
    }
    public boolean isWaitingRoom() {
        return waitingRoom;
    }
    public void setWaitingRoom(boolean waitingRoom) {
        this.waitingRoom = waitingRoom;
    }
    public boolean isMuteUponEntry() {
        return muteUponEntry;
    }
    public void setMuteUponEntry(boolean muteUponEntry) {
        this.muteUponEntry = muteUponEntry;
    }

}
