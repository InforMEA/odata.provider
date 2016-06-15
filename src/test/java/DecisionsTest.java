import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.util.Arrays;
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

import edw.olingo.model.Decision;
import edw.olingo.model.DecisionContent;
import edw.olingo.model.DecisionFile;
import edw.olingo.model.DecisionKeyword;
import edw.olingo.model.DecisionLongTitle;
import edw.olingo.model.DecisionSummary;
import edw.olingo.model.DecisionTitle;

@RunWith(BlockJUnit4ClassRunner.class)
public class DecisionsTest {

	private EntityManagerFactory factory;

	@Before
	public void setUp() throws Exception {
		factory = Persistence.createEntityManagerFactory(AllTests.getPersistenceUnitName());
	}

	@Test
	public void testGetDecisions() throws Exception {
		EntityManager em = factory.createEntityManager();
		CriteriaBuilder qb = em.getCriteriaBuilder();
		List<Decision> rows = em.createQuery(qb.createQuery(Decision.class)).getResultList();
		org.junit.Assert.assertTrue(1 <= rows.size());
		em.close();
	}

	@Test
	public void testGetSingleDecision() throws Exception {
		EntityManager em = factory.createEntityManager();
		Decision row = em.find(Decision.class, "2c776b76-57d3-4a46-a1be-c254976a0ee2");

		assertEquals("http://www.ramsar.org/node/31099", row.getLink());
		assertEquals("resolution", row.getType());
		assertEquals("active", row.getStatus());
		assertEquals("1234", row.getNumber());
		assertEquals("ramsar", row.getTreaty());
		assertEquals(new Integer(3), row.getDisplayOrder());

		Calendar c = new GregorianCalendar(2015, 6, 3, 13, 45, 0);
		assertEquals(c.getTime(), row.getPublished());

		assertEquals("af2078a9-357d-4b12-8f44-fdd1e63ea63f", row.getMeetingId());

		DecisionTitle title = row.getTitles().get(0);
		assertEquals("Doc.C.4.15", title.getTitle());
		assertEquals("en", title.getLanguage());
		title = row.getTitles().get(1);
		assertEquals("Doc.C.4.14", title.getTitle());
		assertEquals("fr", title.getLanguage());

		DecisionLongTitle longTitle = row.getLongTitles().get(0);
		assertEquals("Annex to Doc.C.4.15", longTitle.getLongTitle());
		assertEquals("en", longTitle.getLanguage());
		longTitle = row.getLongTitles().get(1);
		assertEquals("Annex to Doc.C.4.14", longTitle.getLongTitle());
		assertEquals("fr", longTitle.getLanguage());

		assertEquals("af2078a9-357d-4b12-8f44-fdd1e63ea63f", row.getMeetingId());

		assertEquals("meeting1", row.getMeetingTitle());
		assertEquals("http://chm.pops.int/linkclick.aspx?link=404&amp;amp;tabid=276&amp;amp;language=en-us", row.getMeetingUrl());

		c = new GregorianCalendar(2015, 11, 14, 19, 21, 55);
		assertEquals(c.getTime(), row.getUpdated());

		DecisionSummary summary = row.getSummaries().get(0);
		assertEquals("<p>Resolution on the Framework</p>", summary.getSummary());
		assertEquals("en", summary.getLanguage());
		summary = row.getSummaries().get(1);
		assertEquals("<p>adoptées par la Convention sur la diversité biologique (CDB)", summary.getSummary());
		assertEquals("fr", summary.getLanguage());

		DecisionContent content = row.getContents().get(0);
		assertEquals("<p>Resolution on the Framework for the implementation of the Convention and priorities for attention 1991-1993</p>", content.getContent());
		assertEquals("en", content.getLanguage());
		content = row.getContents().get(1);
		assertEquals("<p>adoptées par la Convention sur la diversité biologique (CDB), et leur pertinence pour la Convention de Ramsar</p>", content.getContent());
		assertEquals("fr", content.getLanguage());

		DecisionFile file = row.getFiles().get(0);
		assertEquals("http://chm.pops.int/Portals/0/download.aspx?d=UNEP-POPS-COP.4-SC-4-28.Spanish.doc", file.getUrl());
		assertEquals("application/msword", file.getMimeType());
		assertEquals("en", file.getLanguage());
		assertEquals("UNEP-POPS-COP.4-SC-4-28.Spanish.doc", file.getFilename());
		file = row.getFiles().get(1);
		assertEquals("http://chm.pops.int/Portals/0/download.aspx?d=UNEP-POPS-COP.4-SC-4-28.French.doc", file.getUrl());
		assertEquals("application/msword", file.getMimeType());
		assertEquals("fr", file.getLanguage());
		assertEquals("UNEP-POPS-COP.4-SC-4-28.French.doc", file.getFilename());

		List<DecisionKeyword> tags = row.getKeywords();
		assertEquals(2, tags.size());
		List<String> witness = Arrays.asList(
				"Wetland values",
				"Urbanization"
		);
		DecisionKeyword tag = tags.get(0);
		assertEquals("http://www.ramsar.org/taxonoomy/term/", tag.getNamespace());
		assertTrue(witness.contains(tag.getTerm()));
		tag = tags.get(1);
		assertEquals("http://www.ramsar.org/taxonoomy/term/", tag.getNamespace());
		assertTrue(witness.contains(tag.getTerm()));

		em.close();
	}
}
