package edw.olingo.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Created by miahi on 5/13/2016.
 */
@Entity
@Table(name = "informea_documents_keywords")
public class DocumentKeyword {
    @Id
    @Column(name="id")
    private String id;

    private Document document;

    private String termURI;
    private String scope;
    private String literalForm;
    private String sourceURL;


    public String getId() {
        return id;
    }

    public String getTermURI() {
        return termURI;
    }

    public String getScope() {
        return scope;
    }

    public String getLiteralForm() {
        return literalForm;
    }

    public String getSourceURL() {
        return sourceURL;
    }

    public Document getDocument() {
        return document;
    }
}
