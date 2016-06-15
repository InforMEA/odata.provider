package edw.olingo.model;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Created by miahi on 5/13/2016.
 */
@Entity
@Table(name = "informea_documents_types")
public class DocumentType {

    @Id
    private String id;

    @SuppressWarnings("unused")
    private Document document;

    private String value;

    public String getId() {
        return id;
    }

    public String getValue() {
        return value;
    }
}
