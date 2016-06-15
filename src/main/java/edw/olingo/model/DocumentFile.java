package edw.olingo.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Created by miahi on 5/13/2016.
 */
@Entity
@Table(name = "informea_documents_files")
public class DocumentFile {

    @Id
    @Column(name="id")
    private String id;

    private Document document;

    private String url;
    private String content;
    private String mimeType;
    private String language;
    private String filename;

    public String getId() {
        return id;
    }

    public Document getDocument() {
        return document;
    }

    public String getUrl() {
        return url;
    }

    public String getContent() {
        return content;
    }

    public String getMimeType() {
        return mimeType;
    }

    public String getLanguage() {
        return language;
    }

    public String getFilename() {
        return filename;
    }
}
