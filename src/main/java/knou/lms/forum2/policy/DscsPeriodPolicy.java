package knou.lms.forum2.policy;

import knou.framework.util.DateTimeUtil;
import knou.framework.util.StringUtil;
import knou.lms.forum2.vo.DscsVO;

/**
 * 토론 참여기간 기준의 권한 판단을 담당한다.
 */
public final class DscsPeriodPolicy {

    public static final String MSG_KEY_BEFORE_ONLY = "forum.alert.dscs.before.only";/*토론 참여기간 전에만 가능합니다.*/
    public static final String MSG_KEY_NOT_PERIOD = "forum.alert.dscs.not.period";/*토론 참여기간이 아닙니다.*/

    private DscsPeriodPolicy() {
    }

    /**
     * 현재 시간이 토론 참여기간 시작 전인지 확인한다.
     * @param vo
     * @return
     */
    public static boolean isBeforeStart(DscsVO vo) {
        if (!hasPeriod(vo)) {
            return false;
        }
        return now().compareTo(vo.getDscsSdttm()) < 0;
    }

    /**
     * 현재 시간이 토론 참여기간 내인지 확인한다.
     * @param vo
     * @return
     */
    public static boolean isInPeriod(DscsVO vo) {
        if (!hasPeriod(vo)) {
            return false;
        }
        String now = now();
        return now.compareTo(vo.getDscsSdttm()) >= 0 && now.compareTo(vo.getDscsEdttm()) <= 0;
    }

    /**
     * 현재 시간이 토론 참여기간 종료 후인지 확인한다.
     * @param vo
     * @return
     */
    public static boolean isAfterEnd(DscsVO vo) {
        if (!hasPeriod(vo)) {
            return false;
        }
        return now().compareTo(vo.getDscsEdttm()) > 0;
    }

    /**
     * 토론 참여기간이 시작되었는지 확인한다.
     * @param vo
     * @return
     */
    public static boolean isStarted(DscsVO vo) {
        if (!hasPeriod(vo)) {
            return false;
        }
        return now().compareTo(vo.getDscsSdttm()) >= 0;
    }

    /**
     * 교수가 토론 설정을 수정할 수 있는지 확인한다.
     * @param vo
     * @return
     */
    public static boolean canProfEditDscs(DscsVO vo) {
        return isBeforeStart(vo);
    }

    /**
     * 교수가 토론방에 게시글 또는 댓글을 등록/수정할 수 있는지 확인한다.
     * @param vo
     * @return
     */
    public static boolean canProfWriteBbs(DscsVO vo) {
        return isInPeriod(vo);
    }

    /**
     * 교수가 토론방의 게시글 또는 댓글을 삭제/숨김 처리할 수 있는지 확인한다.
     * @param vo
     * @return
     */
    public static boolean canProfDeleteOrHideBbs(DscsVO vo) {
        return isInPeriod(vo) || isAfterEnd(vo);
    }

    /**
     * 학습자가 토론방에 진입하거나 게시글/댓글을 작성할 수 있는지 확인한다.
     * @param vo
     * @return
     */
    public static boolean canLearnerEnterOrWrite(DscsVO vo) {
        return isInPeriod(vo);
    }

    /**
     * 학습자가 참여현황 화면에 진입할 수 있는지 확인한다.
     * @param vo
     * @return
     */
    public static boolean canLearnerViewPtcpStatus(DscsVO vo) {
        return isInPeriod(vo) || isAfterEnd(vo);
    }

    /**
     * 토론 참여기간 시작/종료 일시가 모두 존재하는지 확인한다.
     * @param vo
     * @return
     */
    private static boolean hasPeriod(DscsVO vo) {
        return vo != null
                && StringUtil.isNotNull(vo.getDscsSdttm())
                && StringUtil.isNotNull(vo.getDscsEdttm());
    }

    /**
     * 현재 일시를 토론 참여기간 비교 형식으로 반환한다.
     * @return
     */
    private static String now() {
        return DateTimeUtil.getCurrentString("yyyyMMddHHmm");
    }
}
