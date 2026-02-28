package knou.lms.notification.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.notification.vo.NotificationVO;

public interface NotificationService {
	public ProcessResultVO<NotificationVO> listNotificationAll(NotificationVO vo) throws Exception;
	public ProcessResultVO<NotificationVO> listPush(NotificationVO vo) throws Exception;
	public ProcessResultVO<NotificationVO> listSms(NotificationVO vo) throws Exception;
	public ProcessResultVO<NotificationVO> listMsg(NotificationVO vo) throws Exception;
	public ProcessResultVO<NotificationVO> listTalk(NotificationVO vo) throws Exception;
}
