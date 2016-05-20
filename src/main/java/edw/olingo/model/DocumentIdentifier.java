package edw.olingo.model;

import javax.persistence.Column;
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
    @Column(name="id")
    private String id;

    @SuppressWarnings("unused")
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
