import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.criteria.CriteriaBuilder;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.BlockJUnit4ClassRunner;

import edw.olingo.model.Meeting;
import edw.olingo.model.MeetingDescription;
import edw.olingo.model.MeetingTitle;

@RunWith(BlockJUnit4ClassRunner.class)
public class MeetingsTest {

	private EntityManagerFactory factory;

	@Before
	public void setUp() throws Exception {
		factory = Persistence.createEntityManagerFactory(AllTests.getPersistenceUnitName());
	}

	@Test
	public void testGetMeetings() throws Exception {
		EntityManager em = factory.createEntityManager();
		CriteriaBuilder qb = em.getCriteriaBuilder();
		List<Meeting> rows = em.createQuery(qb.createQuery(Meeting.class)).getResultList();
		org.junit.Assert.assertTrue(1 <= rows.size());
		em.close();
	}

	@Test
	public void testGetSingleMeeting() throws Exception {
		EntityManager em = factory.createEntityManager();
		Meeting row = em.find(Meeting.class, "af2078a9-357d-4b12-8f44-fdd1e63ea63f");

		assertEquals("ramsar", row.getTreaty());
		assertEquals("http://www.ramsar.org/node/23897", row.getUrl());

		Calendar c = new GregorianCalendar(2015, 4, 31, 22, 0, 0);
		assertEquals(c.getTime(), row.getStart());

		c = new GregorianCalendar(2015, 5, 8, 22, 0, 0);
		assertEquals(c.getTime(), row.getEnd());

		assertEquals("repetition", row.getRepetition());
		assertEquals("kind", row.getKind());
		assertEquals("cop", row.getType());
		assertEquals("access", row.getAccess());
		assertEquals("status", row.getStatus());
		assertEquals("url1", row.getImageUrl());
		assertEquals("copy1", row.getImageCopyright());
		assertEquals("Punta del Este, Uruguay", row.getLocation());
		assertEquals("city", row.getCity());
		assertEquals("UY", row.getCountry());
		assertEquals(new Double(23.230000000), row.getLatitude());
		assertEquals(new Double(33.440000000), row.getLongitude());
		assertTrue(row.getVirtual());

		c = new GregorianCalendar(2016, 0, 14, 16, 26, 59);
		assertEquals(c.getTime(), row.getUpdated());

		MeetingDescription description = row.getDescriptions().get(0);
		assertEquals("<p>The 12th Meeting of the Conference of the Contracting Parties to the Ramsar Convention on Wetlands (COP12)</p>", description.getDescription());
		assertEquals("en", description.getLanguage());
		description = row.getDescriptions().get(1);
		assertEquals("<p>La 12ª Reunión de la Conferencia de las Partes Contratantes de la Convención de Ramsar sobre los Humedales (COP12)</p>", description.getDescription());
		assertEquals("es", description.getLanguage());
		description = row.getDescriptions().get(2);
		assertEquals("<p>La 12e Session de la Conférence des Parties contractantes à la Convention de Ramsar sur les zones humides (COP12)</p>", description.getDescription());
		assertEquals("fr", description.getLanguage());

		MeetingTitle title = row.getTitles().get(0);
		assertEquals("12th Meeting of the Conference of the Parties", title.getTitle());
		assertEquals("en", title.getLanguage());
		title = row.getTitles().get(1);
		assertEquals("12ª Reunión de la Conferencia de las Partes", title.getTitle());
		assertEquals("es", title.getLanguage());
		title = row.getTitles().get(2);
		assertEquals("12e Session de la Conférence des Parties", title.getTitle());
		assertEquals("fr", title.getLanguage());

		em.close();
	}
}
