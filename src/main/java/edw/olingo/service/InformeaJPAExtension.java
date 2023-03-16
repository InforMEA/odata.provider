package edw.olingo.service;

import java.io.InputStream;
import java.util.logging.Logger;

import org.apache.olingo.odata2.api.edm.EdmMultiplicity;
import org.apache.olingo.odata2.api.edm.provider.Association;
import org.apache.olingo.odata2.jpa.processor.api.model.JPAEdmExtension;
import org.apache.olingo.odata2.jpa.processor.api.model.JPAEdmSchemaView;

/**
 * Created with IntelliJ IDEA. User: miahi Date: 8/25/14 Time: 9:48 PM
 */
public class InformeaJPAExtension implements JPAEdmExtension {

	private static final Logger log = Logger
			.getLogger(InformeaJPAExtension.class.getName());

	@Override
	public void extendWithOperation(JPAEdmSchemaView jpaEdmSchemaView) {
	}

	@Override
	public void extendJPAEdmSchema(JPAEdmSchemaView jpaEdmSchemaView) {
		// Workaround for Olingo multiplicity bug.
		// The JPA OneToMany relationship is translated as 1 to * for some
		// entities and as 1 to 1 for others.
		// This makes olingo throw "Requested entity could not be found" errors
		// when accessing the 1:1 entities.
		// Workaround: if 1:1 multiplicity is found, it forces * on the child.
		// Child is determined by the class prefix (the parent entity name must
		// be a prefix of the child element entity)
		for (Association a : jpaEdmSchemaView.getEdmSchema().getAssociations()) {

			if (a.getEnd1().getMultiplicity() == EdmMultiplicity.ONE
					&& a.getEnd2().getMultiplicity() == EdmMultiplicity.ONE) {
				log.finest("Fixed multiplicity for: " + a.getName() + " "
						+ a.getEnd1().getRole() + "("
						+ a.getEnd1().getMultiplicity() + ")  "
						+ a.getEnd2().getRole() + "("
						+ a.getEnd2().getMultiplicity() + ")");

				if (a.getEnd1().getRole().startsWith(a.getEnd2().getRole())) {
					a.getEnd1().setMultiplicity(EdmMultiplicity.MANY);
				} else if (a.getEnd2().getRole()
						.startsWith(a.getEnd1().getRole())) {
					a.getEnd2().setMultiplicity(EdmMultiplicity.MANY);
				}
			}
		}
		// set the container name (the default is namespace + "Container")
		jpaEdmSchemaView.getJPAEdmEntityContainerView().getEdmEntityContainer()
				.setName("InforMEAService");

	}

	@Override
	public InputStream getJPAEdmMappingModelStream() {
		return null;
	}
}
