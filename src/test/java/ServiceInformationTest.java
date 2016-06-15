import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.util.Map;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.BlockJUnit4ClassRunner;

import edw.olingo.model.Meeting;
import edw.olingo.service.ServiceInformation;

@RunWith(BlockJUnit4ClassRunner.class)
public class ServiceInformationTest {

	@Before
	public void setUp() throws Exception {
		ServiceInformation.PERSISTENCE_UNIT_NAME = AllTests.getPersistenceUnitName();
	}

	@Test
	public void testCountEntities() {
		assertTrue(1 <= ServiceInformation.countEntities(Meeting.class));
		assertTrue(1 <= ServiceInformation.countContacts());
		assertTrue(1 <= ServiceInformation.countCountryReports());
		assertTrue(1 <= ServiceInformation.countDecisions());
		assertTrue(1 <= ServiceInformation.countMeetings());
		assertTrue(1 <= ServiceInformation.countNationalPlans());
		assertTrue(1 <= ServiceInformation.countSites());
	}

	@Test
	public void testCheckProductUpdates() {
		String baseDir = "file://" + System.getProperty("user.dir") + "/src/main/webapp/";
		Map<String, Object> data = ServiceInformation.checkProductUpdates(baseDir + "test.needsupdate.api.properties");

		assertTrue((boolean) data.get("needsUpdate"));
		assertTrue((boolean) data.get("success"));
		assertEquals("9.9.1 beta", (String) data.get("remoteVersion"));
		assertTrue(((String) data.get("changes")).length() > 0);

		data = ServiceInformation.checkProductUpdates(baseDir + "test.updated.api.properties");
		assertFalse((boolean) data.get("needsUpdate"));
		assertTrue((boolean) data.get("success"));
		assertEquals("1.5.3", (String) data.get("remoteVersion"));
		assertTrue(((String) data.get("changes")).length() > 0);

		data = ServiceInformation.checkProductUpdates(baseDir + "test.needsupdate.major.api.properties");
		assertTrue((boolean) data.get("needsUpdate"));
		assertTrue((boolean) data.get("success"));
		assertEquals("3.0.0", (String) data.get("remoteVersion"));
		assertTrue(((String) data.get("changes")).length() > 0);

		data = ServiceInformation.checkProductUpdates(baseDir + "test.needsupdate.minor.api.properties");
		assertTrue((boolean) data.get("needsUpdate"));
		assertTrue((boolean) data.get("success"));
		assertEquals("2.9.0", (String) data.get("remoteVersion"));
		assertTrue(((String) data.get("changes")).length() > 0);

		data = ServiceInformation.checkProductUpdates("http://malformed.url/");
		assertFalse((boolean) data.get("success"));
	}
}
