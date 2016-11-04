package edw.olingo.model;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Created by miahi on 5/13/2016.
 */
@Entity
@Table(name = "informea_documents_identifiers")
public class DocumentIdentifier {

    @Id
    private String id;

    private Document document;

    private String name;
    private String value;

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getValue() {
        return value;
    }

    public Document getDocument() {
        return document;
    }
}
