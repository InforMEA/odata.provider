package edw.olingo.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Created by miahi on 5/13/2016.
 */
@Entity
@Table(name = "informea_documents_references")
public class DocumentReference {

    @Id
    @Column(name="id")
    private String id;

    private Document document;

    private String type;
    private String refId;

    public String getId() {
        return id;
    }

    public Document getDocument() {
        return document;
    }

    public String getType() {
        return type;
    }

    public String getRefId() {
        return refId;
    }
}
