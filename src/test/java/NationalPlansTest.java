import static org.junit.Assert.assertEquals;

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

import edw.olingo.model.NationalPlan;
import edw.olingo.model.NationalPlanTitle;

@RunWith(BlockJUnit4ClassRunner.class)
public class NationalPlansTest {

	private EntityManagerFactory factory;

	@Before
	public void setUp() throws Exception {
		factory = Persistence.createEntityManagerFactory(AllTests.getPersistenceUnitName());
	}

	@Test
	public void testGetNationalPlans() throws Exception {
		EntityManager em = factory.createEntityManager();
		CriteriaBuilder qb = em.getCriteriaBuilder();
		List<NationalPlan> rows = em.createQuery(qb.createQuery(NationalPlan.class)).getResultList();
		org.junit.Assert.assertTrue(1 <= rows.size());
		em.close();
	}

	@Test
	public void testGetSingleNationalPlan() throws Exception {
		EntityManager em = factory.createEntityManager();
		NationalPlan row = em.find(NationalPlan.class, "4298e0ab-c687-4cbe-b849-f3a16d63284e");

		assertEquals("stockholm", row.getTreaty());
		assertEquals("AL", row.getCountry());
		assertEquals("http://www.cbd.int/doc/world/ve/ve-nbsap-01-es.pdf", row.getUrl());
		assertEquals("nip", row.getType());

		List<NationalPlanTitle> titles = row.getTitles();
		NationalPlanTitle title = titles.get(0);
		assertEquals("Plan National de Mise en oeuvre – Convention de Stockholm", title.getTitle());
		assertEquals("fr", title.getLanguage());
		title = titles.get(1);
		assertEquals("Plan nacional de Aplicación del Convenio de Estocolmo", title.getTitle());
		assertEquals("es", title.getLanguage());
		title = titles.get(2);
		assertEquals("NATIONAL IMPLEMENTATION PLAN (NIP) FOR POLLUTANTS (POPs)", title.getTitle());
		assertEquals("en", title.getLanguage());

		Calendar c = new GregorianCalendar(2007, 1, 12);
		assertEquals(c.getTime(), row.getSubmission());

		c = new GregorianCalendar(2015, 3, 22, 12, 21, 43);
		assertEquals(c.getTime(), row.getUpdated());

		em.close();
	}
}
