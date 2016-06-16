import edw.olingo.model.*;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.BlockJUnit4ClassRunner;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.criteria.CriteriaBuilder;

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;

@RunWith(BlockJUnit4ClassRunner.class)
public class DocumentTest {

    private EntityManagerFactory factory;

	@Before
	public void setUp() throws Exception {
		factory = Persistence.createEntityManagerFactory(AllTests.getPersistenceUnitName());
	}


    @Test
    public void testGetDocuments() throws Exception {
        EntityManager em = factory.createEntityManager();
        CriteriaBuilder qb = em.getCriteriaBuilder();
        List<Document> rows = em.createQuery(qb.createQuery(Document.class)).getResultList();
        org.junit.Assert.assertTrue(1 <= rows.size());
        em.close();
    }

    @Test
    public void testGetSingleDocument() throws Exception {
        EntityManager em = factory.createEntityManager();
        Document row = em.find(Document.class, "00cf041a-ac5b-4335-a4cf-0d5d9354015f");
        assertNotNull(row);

        Calendar c = new GregorianCalendar(2008, 9, 2, 12, 34, 56);
		assertEquals(c.getTime(), row.getPublished());

        c = new GregorianCalendar(2014, 5, 16, 13, 5, 13);
		assertEquals(c.getTime(), row.getUpdated());

		assertEquals("cms", row.getTreaty());
		assertEquals("http://www.cms.int/sites/default/filespublication/gorilla_0_3_0_0.jpg", row.getThumbnailUrl());
		assertEquals(new Integer(1), row.getDisplayOrder());
		assertEquals("RO", row.getCountry());

        List<DocumentAuthor> authors = row.getAuthors();
        assertEquals(3, authors.size());
        DocumentAuthor author = authors.get(0);
        assertEquals("Simba Chan (BirdLife International)", author.getName());
        assertEquals("person", author.getType());
        author = authors.get(1);
        assertEquals("Fang Woei-horng (Chinese Wild Bird  Federation)", author.getName());
        assertEquals("company", author.getType());
        author = authors.get(2);
        assertEquals("Lee Ki-sup (Korea Institute of Environmental Ecology)", author.getName());
        assertNull(author.getType());

        List<DocumentDescription> descriptions = row.getDescriptions();
        assertEquals(2, descriptions.size());
        DocumentDescription description = descriptions.get(0);
        assertEquals("description1", description.getValue());
        assertEquals("en", description.getLanguage());
        description = descriptions.get(1);
        assertEquals("description2", description.getValue());
        assertEquals("fr", description.getLanguage());

        List<DocumentIdentifier> identifiers = row.getIdentifiers();
        DocumentIdentifier ident = identifiers.get(0);
        assertEquals("name1", ident.getName());
        assertEquals("value1", ident.getValue());
        ident = identifiers.get(1);
        assertEquals("name2", ident.getName());
        assertEquals("value2", ident.getValue());
        ident = identifiers.get(2);
        assertEquals("name3", ident.getName());
        assertEquals("value3", ident.getValue());

        List<DocumentFile> files = row.getFiles();
        assertEquals(3, files.size());
        DocumentFile file = files.get(0);
        assertEquals("http://www.cms.int/sites/default/files/publication/ts17_Gorilla_E_3_0_0.pdf", file.getUrl());
        assertEquals("content1", file.getContent());
        assertEquals("application/pdf", file.getMimeType());
        assertEquals("en", file.getLanguage());
        assertEquals("ts17_Gorilla_E_3_0_0.pdf", file.getFilename());

        List<DocumentKeyword> keywords = row.getKeywords();
        assertEquals(2, keywords.size());
        DocumentKeyword kw = keywords.get(0);
        assertEquals("http://www.ramsar.org/taxonoomy/term/wetland-values", kw.getTermURI());
        assertEquals("ramsar", kw.getScope());
        assertEquals("access right", kw.getLiteralForm());
        assertEquals("http://odata/Term('uri1')", kw.getSourceURL());

        List<DocumentReference> references = row.getReferences();
        DocumentReference ref = references.get(0);
        assertEquals("meeting", ref.getType());
        assertEquals("5bdb02b0-debe-4689-852d-9d9a96fd63eb", ref.getRefId());
        ref = references.get(1);
        assertEquals("decision", ref.getType());
        assertEquals("2c776b76-57d3-4a46-a1be-c254976a0ee2", ref.getRefId());

        List<DocumentTitle> titles = row.getTitles();
        DocumentTitle title = titles.get(0);
        assertEquals("en", title.getLanguage());
        assertEquals("Safe Flyways for the Siberian Crane", title.getValue());
        title = titles.get(1);
        assertEquals("fr", title.getLanguage());
        assertEquals("Bats around the world", title.getValue());

        List<DocumentType> types = row.getTypes();
        DocumentType type = types.get(0);
        assertEquals("Technical Series", type.getValue());
        type = types.get(1);
        assertEquals("Publication", type.getValue());
        type = types.get(2);
        assertEquals("Leaflets & Brochures", type.getValue());

        List<DocumentTag> tags = row.getTags();
        DocumentTag tag = tags.get(0);
        assertEquals("en", tag.getLanguage());
        assertEquals("ramsar", tag.getScope());
        assertEquals("Wetland values", tag.getValue());
        assertEquals("comment1", tag.getComment());

        tag = tags.get(1);
        assertEquals("fr", tag.getLanguage());
        assertEquals("ramsar", tag.getScope());
        assertEquals("Urbanization", tag.getValue());
        assertEquals("comment2", tag.getComment());

        em.close();
    }
}
