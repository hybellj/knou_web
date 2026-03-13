package knou.lms.forum2.service;

import java.util.List;


import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum.vo.ForumAtclVO;
import knou.lms.forum.vo.ForumMutVO;

public interface ForumAtclService {

    // ��� �Խñ� �� ī����
    public int forumAtclCount(ForumAtclVO vo) throws Exception;

    // ��� �Խñ� ����¡ ��� ��ȸ
    public abstract ProcessResultVO<ForumAtclVO> listPageing(ForumAtclVO vo) throws Exception;

    // ��� �Խñ� ���
    public void insertAtcl(ForumAtclVO vo) throws Exception;

    // ��� �Խñ� ��ȸ
    public ForumAtclVO selectAtcl(ForumAtclVO vo) throws Exception;

    // ��� �Խñ� ����
    public void updateAtcl(ForumAtclVO vo) throws Exception;

    // ��� �Խñ� ����
    public void deleteAtcl(ForumAtclVO vo) throws Exception;

    // ���� ��ȣ�� ���
/*    public ForumAtclVO selectMutResult(ForumAtclVO vo) throws Exception;*/

    // Ư�� �������� ��� �Խñ� ��ȸ
    /*public List<ForumAtclVO> selectAtclUserList(ForumMutVO vo) throws Exception;*/

    // ��� �Խñ� ��� ��ȸ
    public List<ForumAtclVO> forumAtclList(ForumAtclVO vo) throws Exception;

    // ������ ��б� ��� ����
	public int myAtclCnt(ForumAtclVO vo) throws Exception;
	
	// ��� �Խñ� ������� ��ȸ
    public List<ForumAtclVO> forumAtclExcalList(ForumAtclVO vo) throws Exception;

}
