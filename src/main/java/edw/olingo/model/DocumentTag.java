package edw.olingo.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Created by miahi on 5/13/2016.
 */
@Entity
@Table(name = "informea_documents_tags")
public class DocumentTag {

    @Id
    @Column(name="id")
    private String id;

    private Document document;

    private String language;
    private String scope;
    private String value;
    private String comment;

    public String getId() {
        return id;
    }

    public Document getDocument() {
        return document;
    }

    public String getLanguage() {
        return language;
    }

    public String getScope() {
        return scope;
    }

    public String getValue() {
        return value;
    }

    public String getComment() {
        return comment;
    }
}
