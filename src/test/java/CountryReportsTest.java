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

import edw.olingo.model.Contact;
import edw.olingo.model.CountryReport;
import edw.olingo.model.CountryReportFile;
import edw.olingo.model.CountryReportTitle;

@RunWith(BlockJUnit4ClassRunner.class)
public class CountryReportsTest {

	private EntityManagerFactory factory;

	@Before
	public void setUp() throws Exception {
		factory = Persistence.createEntityManagerFactory(AllTests.getPersistenceUnitName());
	}

	@Test
	public void testGetCountryReports() throws Exception {
		EntityManager em = factory.createEntityManager();
		CriteriaBuilder qb = em.getCriteriaBuilder();
		List<Contact> rows = em.createQuery(qb.createQuery(Contact.class)).getResultList();
		org.junit.Assert.assertTrue(1 <= rows.size());
		em.close();
	}

	@Test
	public void testGetSingleCountryReport() throws Exception {
		EntityManager em = factory.createEntityManager();
		CountryReport row = em.find(CountryReport.class, "96e420cc-fb81-426b-a0e1-4571c255a5d0");

		assertEquals("AL", row.getCountry());
		assertEquals("ramsar", row.getTreaty());
		assertEquals("0cf90a8c-84fd-4bea-8299-ad56c0d3a463", row.getTreatyUUID());
		assertEquals("http://www.ramsar.org/node/14398", row.getUrl());

		List<CountryReportTitle> titles = row.getTitles();
		CountryReportTitle title = titles.get(0);
		assertEquals("COP11 National Reports: Albania - Section 4", title.getTitle());
		assertEquals("en", title.getLanguage());

		title = titles.get(1);
		assertEquals("Rapports nationaux COP11 : Algérie", title.getTitle());
		assertEquals("fr", title.getLanguage());

		Calendar c = new GregorianCalendar(2012, 0, 1, 0, 0, 0);
		assertEquals(c.getTime(), row.getSubmission());

		c = new GregorianCalendar(2015, 04, 27, 11, 07, 01);
		assertEquals(c.getTime(), row.getUpdated());

		List<CountryReportFile> files = row.getFiles();
		CountryReportFile file = files.get(0);
		assertEquals("http://www.ramsar.org/sites/default/files/documents/pdf/cop10/cop10_nr_antigua.pdf", file.getUrl());
		assertEquals("application/pdf", file.getMimeType());
		assertEquals("en", file.getLanguage());
		assertEquals("cop10_nr_antigua.pdf", file.getFilename());
		file = files.get(1);
		assertEquals("http://www.ramsar.org/sites/default/files/documents/pdf/cop10/cop10_nr_algeria.pdf", file.getUrl());
		assertEquals("application/pdf", file.getMimeType());
		assertEquals("fr", file.getLanguage());
		assertEquals("cop10_nr_algeria.pdf", file.getFilename());
		
		em.close();
	}
}
