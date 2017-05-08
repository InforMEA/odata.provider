package edw.olingo.service;

import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;

import edw.olingo.model.*;

public class ServiceInformation {

	public static final String UPDATE_URL = "http://www.informea.org/api.properties";
	public static final int VERSION_MAJOR = 2;
	public static final int VERSION_MINOR = 5;
	public static final int VERSION_REVISION = 0;
	public static final boolean VERSION_BETA = true;

	public static String PERSISTENCE_UNIT_NAME = "persistence_unit";

	private static final Logger log = Logger.getLogger(ServiceInformation.class
			.getName());

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static long countEntities(Class entityKlass) {
		long count = 0;
		try {
			EntityManagerFactory factory = Persistence
					.createEntityManagerFactory(PERSISTENCE_UNIT_NAME);
			EntityManager em = factory.createEntityManager();
			CriteriaBuilder qb = em.getCriteriaBuilder();
			CriteriaQuery<Long> query = qb.createQuery(Long.class);
			query.select(qb.count(query.from(entityKlass)));
			count = em.createQuery(query).getSingleResult();
		} catch (Exception ex) {
			// Do not log exception (see issue #6)
		}
		return count;
	}

	public static String getVersion() {
		String ret = String.format("%s.%s.%s", VERSION_MAJOR, VERSION_MINOR,
				VERSION_REVISION);
		if (VERSION_BETA) {
			ret += " beta";
		}
		return ret;
	}

	public static long countMeetings() {
		return ServiceInformation.countEntities(Meeting.class);
	}

	public static long countContacts() {
		return ServiceInformation.countEntities(Contact.class);
	}

	public static long countDecisions() {
		return ServiceInformation.countEntities(Decision.class);
	}

	public static long countCountryReports() {
		return ServiceInformation.countEntities(CountryReport.class);
	}

	public static long countNationalPlans() {
		return ServiceInformation.countEntities(NationalPlan.class);
	}

	public static long countSites() {
		return ServiceInformation.countEntities(Site.class);
	}

	public static long countTreaties() {
		return ServiceInformation.countEntities(Treaty.class);
	}

	public static long countDocuments() {
		return ServiceInformation.countEntities(Document.class);
	}

	public static Map<String, Object> checkProductUpdates() {
		return checkProductUpdates(UPDATE_URL);
	}

	/**
	 * Check for toolkit update
	 * 
	 * @return Structure containing update information
	 */
	@SuppressWarnings("unused")
	public static Map<String, Object> checkProductUpdates(String overrideUpdateUrl) {
		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("needsUpdate", false);
		ret.put("success", false);
		ret.put("remoteVersion", "");
		ret.put("changes", "");
		String updateUrl = (overrideUpdateUrl == null) ? UPDATE_URL : overrideUpdateUrl;
		try {
			URL url = new URL(updateUrl);
			HttpURLConnection.setFollowRedirects(true);
			HttpURLConnection conn = (HttpURLConnection)url.openConnection();
			conn.setConnectTimeout(4000);
			int status = conn.getResponseCode();
			// Handle redirect
			if (status != HttpURLConnection.HTTP_OK
					&& (status == HttpURLConnection.HTTP_MOVED_PERM
					|| status == HttpURLConnection.HTTP_MOVED_TEMP
					|| status == HttpURLConnection.HTTP_SEE_OTHER)) {
				String newUrl = conn.getHeaderField("Location");
				url = new URL(newUrl);
				conn.disconnect();
				conn = (HttpURLConnection) url.openConnection();
				conn.setConnectTimeout(4000);
			}
			java.io.InputStream fis = conn.getInputStream();
			java.util.Properties props = new java.util.Properties();
			props.load(fis);

			int remoteMajor = Integer.parseInt(props.getProperty("MAJOR"));
			int remoteMinor = Integer.parseInt(props.getProperty("MINOR"));
			int remoteRevision = Integer
					.parseInt(props.getProperty("REVISION"));
			boolean remoteBeta = Boolean
					.parseBoolean(props.getProperty("BETA"));
			String changes = props.getProperty("CHANGES");

			boolean needsUpdate = false;
			if (remoteMajor > VERSION_MAJOR) {
				needsUpdate = true;
			} else if (remoteMajor == VERSION_MAJOR) {
				if (remoteMinor > VERSION_MINOR) {
					needsUpdate = true;
				} else if (remoteMinor == VERSION_MINOR) {
					if (remoteRevision > VERSION_REVISION) {
						needsUpdate = true;
					} else if (remoteRevision == VERSION_REVISION) {
						if (VERSION_BETA == true && remoteBeta == false) {
							needsUpdate = true;
						}
					}
				}
			}
			ret.put("remoteVersion", String.format("%s.%s.%s%s", remoteMajor,
					remoteMinor, remoteRevision, remoteBeta ? " beta" : ""));
			ret.put("needsUpdate", needsUpdate);
			ret.put("success", true);
			ret.put("changes", changes);
		} catch (Exception ex) {
			log.log(Level.WARNING, "Cannot check for new version at: " + updateUrl);
		}
		return ret;
	}
}
