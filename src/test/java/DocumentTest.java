import edw.olingo.model.*;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.BlockJUnit4ClassRunner;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.criteria.CriteriaBuilder;

import java.util.Arrays;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertNotNull;

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
        Document row = em.find(Document.class, "00000000-0000-0000-0000-000000000000");
        assertNotNull(row);

        Calendar c = new GregorianCalendar(2008, 9, 2, 12, 34, 56);
        assertEquals(c.getTime(), row.getPublished());

        c = new GregorianCalendar(2014, 5, 16, 13, 5, 13);
        assertEquals(c.getTime(), row.getUpdated());

        assertEquals("cms", row.getTreaty());
        assertEquals("http://www.cms.int/sites/default/filespublication/gorilla_0_3_0_0.jpg", row.getThumbnailUrl());
        assertEquals(new Integer(2), row.getDisplayOrder());
        assertEquals("RO", row.getCountry());

        List<DocumentTreaty> treaties = row.getTreaties();
        DocumentTreaty t0 = treaties.get(0);
        assertTrue(Arrays.asList(new String[] {"cms", "aewa"}).contains(t0.getTreaty()));
        DocumentTreaty t1 = treaties.get(1);
        assertTrue(Arrays.asList(new String[] {"cms", "aewa"}).contains(t1.getTreaty()));

        List<DocumentAuthor> authors = row.getAuthors();
        assertEquals(2, authors.size());
        DocumentAuthor author = authors.get(0);
        assertEquals("Cristian Romanescu", author.getName());
        assertEquals("Person", author.getType());

        author = authors.get(1);
        assertEquals("John Doe", author.getName());
        assertEquals("Company", author.getType());

        List<DocumentDescription> descriptions = row.getDescriptions();
        DocumentDescription description = descriptions.get(0);
        assertEquals("Description english", description.getValue());
        assertEquals("en", description.getLanguage());
        description = descriptions.get(1);
        assertEquals("Description french", description.getValue());
        assertEquals("fr", description.getLanguage());

        List<DocumentIdentifier> identifiers = row.getIdentifiers();
        DocumentIdentifier ident = identifiers.get(0);
        assertEquals("Identifier 1", ident.getName());
        assertEquals("Value 1", ident.getValue());
        ident = identifiers.get(1);
        assertEquals("Identifier 2", ident.getName());
        assertEquals("Value 2", ident.getValue());

        List<DocumentFile> files = row.getFiles();
        assertEquals(3, files.size());
        DocumentFile file = files.get(0);
        assertTrue(Arrays.asList(new String[] {"Url 1", "Url 2", "Url 3"}).contains(file.getUrl()));
        assertTrue(Arrays.asList(new String[] {"Content 1", "Content 2", "Content 3"}).contains(file.getContent()));
        assertTrue(Arrays.asList(new String[] {"Mime 1", "Mime 2", "Mime 3"}).contains(file.getMimeType()));
        assertTrue(Arrays.asList(new String[] {"en", "fr"}).contains(file.getLanguage()));
        assertTrue(Arrays.asList(new String[] {"filename1.pdf", "filename2.doc", "filename3.pdf"}).contains(file.getFilename()));

        List<DocumentKeyword> keywords = row.getKeywords();
        assertEquals(2, keywords.size());
        DocumentKeyword kw = keywords.get(0);
        assertEquals("http://www.informea.org/term/acceptance", kw.getTermURI());
        assertEquals("InforMEA", kw.getScope());
        assertEquals("Acceptance", kw.getLiteralForm());
        assertEquals("http://www.informea.org/taxonomy/term/1135", kw.getSourceURL());

        List<DocumentGoal> goals = row.getGoals();
        assertEquals(2, goals.size());
        DocumentGoal g1 = goals.get(0);
        assertEquals("aichi", g1.getSource());
        assertEquals("goal", g1.getType());
        assertEquals("20", g1.getIdentifier());

        List<DocumentReference> references = row.getReferences();
        DocumentReference ref = references.get(0);
        assertEquals("meeting", ref.getType());
        assertEquals("00000000-0000-0000-0000-000000000001", ref.getRefId());
        ref = references.get(1);
        assertEquals("decision", ref.getType());
        assertEquals("00000000-0000-0000-0000-000000000002", ref.getRefId());

        List<DocumentTitle> titles = row.getTitles();
        DocumentTitle title = titles.get(0);
        assertTrue(Arrays.asList(new String[] {"en", "fr"}).contains(title.getLanguage()));
        assertTrue(Arrays.asList(new String[] {"Title english", "Title french"}).contains(title.getValue()));
        title = titles.get(1);
        assertTrue(Arrays.asList(new String[] {"en", "fr"}).contains(title.getLanguage()));
        assertTrue(Arrays.asList(new String[] {"Title english", "Title french"}).contains(title.getValue()));

        List<DocumentType> types = row.getTypes();
        DocumentType type = types.get(0);
        assertEquals("Technical Series", type.getValue());
        type = types.get(1);
        assertEquals("Publication", type.getValue());

        List<DocumentTag> tags = row.getTags();
        DocumentTag tag = tags.get(0);
        assertEquals("en", tag.getLanguage());
        assertEquals("BRS", tag.getScope());
        assertTrue(Arrays.asList(new String[] {"Chemical", "DDT"}).contains(tag.getValue()));
        assertTrue(Arrays.asList(new String[] {"Custom term", "Test term"}).contains(tag.getComment()));

        tag = tags.get(1);
        assertEquals("en", tag.getLanguage());
        assertEquals("BRS", tag.getScope());
        assertTrue(Arrays.asList(new String[] {"Chemical", "DDT"}).contains(tag.getValue()));
        assertTrue(Arrays.asList(new String[] {"Custom term", "Test term"}).contains(tag.getComment()));

        em.close();
    }
}
