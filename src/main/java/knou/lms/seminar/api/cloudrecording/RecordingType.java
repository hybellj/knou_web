package knou.lms.seminar.api.cloudrecording;

public enum RecordingType {
    
    SHARED_SCREEN_WITH_SPEAKER_VIEW_CC("shared_screen_with_speaker_view(CC)"),
    SHARED_SCREEN_WITH_SPEAKER_VIEW("shared_screen_with_speaker_view"),
    SHARED_SCREEN_WITH_GALLERY_VIEW("shared_screen_with_gallery_view"),
    SPEAKER_VIEW("speaker_view"),
    GALLERY_VIEW("gallery_view"),
    SHARED_SCREEN("shared_screen"),
    AUDIO_ONLY("audio_only"),
    AUDIO_TRANSCRIPT("audio_transcript"),
    CHAT_FILE("chat_file"),
    ACTIVE_SPEAKER("active_speaker"),
    POLL("poll"),
    TIMELINE("timeline"),
    CLOSED_CAPTION("closed_caption");

    private String value;

    private RecordingType(String value) {
        this.value = value;
    }

    public String getValue() {
        return this.value;
    }

}
