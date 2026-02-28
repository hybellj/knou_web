package knou.framework.common;

import javax.annotation.Resource;

import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * Service 공통
 * 
 * @author shil
 */
public class ServiceBase extends EgovAbstractServiceImpl {

	// Transaction manager
	@Resource(name = "txManager") 
	protected DataSourceTransactionManager txManager;
	
	// Transaction status
	private TransactionStatus txStatus;
	
	
	/**
	 * Start transaction
	 */
	public void startTransaction() {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition(); 
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED); 
		txStatus = txManager.getTransaction(def);
	}
	
	/**
	 * Commit transaction
	 */
	public void commit() {
		txManager.commit(txStatus);
	}
	
	/**
	 * Rollback transaction
	 */
	public void rollback() {
		txManager.rollback(txStatus);
	}
	
}
