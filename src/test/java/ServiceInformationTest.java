import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.util.Map;
import java.util.Properties;

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
		Properties remote = getDefaultProperties();
		// Major version
		remote.put("MAJOR", "" + (ServiceInformation.VERSION_MAJOR + 1));
		Map<String, Object> check = ServiceInformation.compareVersion(remote);
		assertTrue((boolean) check.get("needsUpdate"));
		assertTrue((boolean) check.get("success"));
		assertEquals(
				String.format("%s.%s.%s%s",
						(ServiceInformation.VERSION_MAJOR + 1),
						ServiceInformation.VERSION_MINOR,
						ServiceInformation.VERSION_REVISION,
						ServiceInformation.VERSION_BETA ? " beta" : ""),
				check.get("remoteVersion"));
		assertEquals("Test string", check.get("changes"));

		// Minor version
		remote = getDefaultProperties();
		remote.put("MINOR", "" + (ServiceInformation.VERSION_MINOR + 1));
		check = ServiceInformation.compareVersion(remote);
		assertTrue((boolean) check.get("needsUpdate"));
		assertTrue((boolean) check.get("success"));
		assertEquals(
				String.format("%s.%s.%s%s",
						ServiceInformation.VERSION_MAJOR,
						(ServiceInformation.VERSION_MINOR + 1),
						ServiceInformation.VERSION_REVISION,
						ServiceInformation.VERSION_BETA ? " beta" : ""),
				check.get("remoteVersion"));

		// Revision version
		remote = getDefaultProperties();
		remote.put("REVISION", "" + (ServiceInformation.VERSION_REVISION + 1));
		check = ServiceInformation.compareVersion(remote);
		assertTrue((boolean) check.get("needsUpdate"));
		assertTrue((boolean) check.get("success"));
		assertEquals(
				String.format("%s.%s.%s%s",
						ServiceInformation.VERSION_MAJOR,
						ServiceInformation.VERSION_MINOR,
						(ServiceInformation.VERSION_REVISION + 1),
						ServiceInformation.VERSION_BETA ? " beta" : ""),
				check.get("remoteVersion"));

		remote = getDefaultProperties();
		if (ServiceInformation.VERSION_BETA) {
			remote.put("BETA", "false");
			check = ServiceInformation.compareVersion(remote);
			assertTrue((boolean) check.get("needsUpdate"));
			assertTrue((boolean) check.get("success"));
			assertEquals(
					String.format("%s.%s.%s%s",
							ServiceInformation.VERSION_MAJOR,
							ServiceInformation.VERSION_MINOR,
							ServiceInformation.VERSION_REVISION,
							""),
					check.get("remoteVersion"));
		}
		else {
			remote.put("BETA", "true");
			check = ServiceInformation.compareVersion(remote);
			assertFalse((boolean) check.get("needsUpdate"));
			assertTrue((boolean) check.get("success"));
			assertEquals(
					String.format("%s.%s.%s%s",
							ServiceInformation.VERSION_MAJOR,
							ServiceInformation.VERSION_MINOR,
							(ServiceInformation.VERSION_REVISION + 1),
							" beta"),
					check.get("remoteVersion"));
		}
}

	private static Properties getDefaultProperties() {
		Properties remote = new Properties();
		remote.put("MAJOR", "" + ServiceInformation.VERSION_MAJOR);
		remote.put("MINOR", "" + ServiceInformation.VERSION_MINOR);
		remote.put("REVISION", "" + ServiceInformation.VERSION_REVISION);
		remote.put("BETA", "" + ServiceInformation.VERSION_BETA);
		remote.put("CHANGES", "Test string");
		return remote;
	}
}
