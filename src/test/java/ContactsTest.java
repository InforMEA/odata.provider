import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
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

import edw.olingo.model.Contact;
import edw.olingo.model.ContactTreaty;

@RunWith(BlockJUnit4ClassRunner.class)
public class ContactsTest {

	private EntityManagerFactory factory;

	@Before
	public void setUp() throws Exception {
		factory = Persistence.createEntityManagerFactory(AllTests.getPersistenceUnitName());
	}

	@Test
	public void testGetContacts() throws Exception {
		EntityManager em = factory.createEntityManager();
		CriteriaBuilder qb = em.getCriteriaBuilder();
		List<Contact> rows = em.createQuery(qb.createQuery(Contact.class))
				.getResultList();
		org.junit.Assert.assertTrue(1 <= rows.size());
		em.close();
	}

	@Test
	public void testGetSingleContact() throws Exception {
		EntityManager em = factory.createEntityManager();
		Contact row = em.find(Contact.class, "471d81c2-4a22-4574-9fd1-0341797ec6de");
		assertNotNull(row);
		assertEquals("AL", row.getCountry());
		assertEquals("Mr.", row.getPrefix());
		assertEquals("John", row.getFirstName());
		assertEquals("Doe", row.getLastName());
		assertEquals("Director", row.getPosition());
		assertEquals("Biodiversity Directorate", row.getInstitution());
		assertEquals("department 1", row.getDepartment());
		assertEquals("Primary", row.getType());
		assertEquals("address 1", row.getAddress());

		assertTrue(row.getEmail().contains("email1@moe.gov.al"));
		assertEquals("+4 224 3578", row.getPhoneNumber());

		assertTrue(row.getFax().contains("+355"));
		assertEquals(1, row.getPrimary());


		List<ContactTreaty> treaties = row.getTreaties();
		assertEquals(2, treaties.size());

		ContactTreaty treaty = treaties.get(0);
		assertEquals("cites", treaty.getTreaty());
		treaty = treaties.get(1);
		assertEquals("cms", treaty.getTreaty());

		Calendar c = new GregorianCalendar(2016, 2, 29, 17, 21, 54);
		assertEquals(c.getTime(), row.getUpdated());

		em.close();
	}
}
