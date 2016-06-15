import static org.junit.Assert.assertEquals;

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

import edw.olingo.model.Site;
import edw.olingo.model.SiteName;

@RunWith(BlockJUnit4ClassRunner.class)
public class SitesTest {

	private EntityManagerFactory factory;

	@Before
	public void setUp() throws Exception {
		factory = Persistence.createEntityManagerFactory(AllTests.getPersistenceUnitName());
	}

	@Test
	public void testGetSites() throws Exception {
		EntityManager em = factory.createEntityManager();
		CriteriaBuilder qb = em.getCriteriaBuilder();
		List<Site> rows = em.createQuery(qb.createQuery(Site.class)).getResultList();
		org.junit.Assert.assertTrue(1 <= rows.size());
		em.close();
	}

	@Test
	public void testGetSingleSite() throws Exception {
		EntityManager em = factory.createEntityManager();
		Site row = em.find(Site.class, "4cbc51ee-1b32-49eb-bbf0-6c7b15d33f0f");

		assertEquals("AT", row.getCountry());
		assertEquals("whc", row.getTreaty());
		assertEquals("whc", row.getType());
		assertEquals("http://whc.unesco.org/en/list/1363", row.getUrl());
		assertEquals(new Double(47.278333333), row.getLatitude());
		assertEquals(new Double(8.207500000), row.getLongitude());

		List<SiteName> names = row.getNames();
		assertEquals(3, names.size());
		SiteName name = names.get(0);
		assertEquals("Prehistoric Pile dwellings around the Alps", name.getName());
		assertEquals("en", name.getLanguage());
		name = names.get(1);
		assertEquals("Kluane / Wrangell-St Elias / Glacier Bay / Tatshenshini-Alsek", name.getName());
		assertEquals("es", name.getLanguage());
		name = names.get(2);
		assertEquals("Jesuit Missions of the Guaranis Missoes (Brazil)", name.getName());
		assertEquals("fr", name.getLanguage());

		GregorianCalendar c = new GregorianCalendar(2012, 4, 14, 14, 4, 45);
		assertEquals(c.getTime(), row.getUpdated());

		em.close();
	}
}
