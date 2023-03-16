package edw.olingo.service;

import java.util.TimeZone;

import org.apache.olingo.odata2.api.ODataCallback;
import org.apache.olingo.odata2.jpa.processor.api.ODataJPAContext;
import org.apache.olingo.odata2.jpa.processor.api.exception.ODataJPARuntimeException;
import org.apache.olingo.odata2.jpa.processor.ref.factory.JPAEntityManagerFactory;

public class InformeaODataJPAServiceFactory extends
		org.apache.olingo.odata2.jpa.processor.api.ODataJPAServiceFactory {

	private static final String PUNIT_NAME = "persistence_unit";

	@Override
	public ODataJPAContext initializeODataJPAContext()
			throws ODataJPARuntimeException {
		// Assume that all dates received in InforMEA are given in UTC (OData
		// default?).
		TimeZone.setDefault(TimeZone.getTimeZone("Etc/UTC"));
		ODataJPAContext oDataJPAContext = getODataJPAContext();
		oDataJPAContext.setEntityManagerFactory(JPAEntityManagerFactory
				.getEntityManagerFactory(PUNIT_NAME));
		oDataJPAContext.setPersistenceUnitName(PUNIT_NAME);
		String pageSize = System.getenv("ODATA_PAGESIZE");
		if(pageSize != null) {
			try {
				int pageSizeInt = Integer.parseInt(pageSize);
				if(pageSizeInt > 0) {
					oDataJPAContext.setPageSize(pageSizeInt);
				}
			} catch (Exception e){
				// don't set
			}
		}
		// oDataJPAContext.setDefaultNaming(true);
		setDetailErrors(true);
		oDataJPAContext.setJPAEdmExtension(new InformeaJPAExtension());
		oDataJPAContext.setJPAEdmMappingModel("jpa_edm_mapping.xml");
		return oDataJPAContext;
	}

	@SuppressWarnings("unchecked")
	public <T extends ODataCallback> T getCallback(Class<T> callbackInterface){
		T callback;
		if (callbackInterface.isAssignableFrom(InformeaDebugCallback.class)) {
			callback = (T) new InformeaDebugCallback();
		} else {
			callback = (T) super.getCallback(callbackInterface);
		}
		return callback;
	}
}
