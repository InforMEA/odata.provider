package edw.olingo.model;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Created by miahi on 5/13/2016.
 */
@Entity
@Table(name = "informea_documents_title")
public class DocumentTitle {

    @Id
    private String id;

    private Document document;

    private String language;
    private String value;

    public String getId() {
        return id;
    }

    public Document getDocument() {
        return document;
    }

    public String getLanguage() {
        return language;
    }

    public String getValue() {
        return value;
    }
}
