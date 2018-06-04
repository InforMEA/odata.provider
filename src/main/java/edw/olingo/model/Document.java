package edw.olingo.model;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by miahi on 5/13/2016.
 */
@Entity
@Table(name = "informea_documents")
public class Document {

    @Id
    private String id;

    private Integer displayOrder;

    private String schemaVersion;

    @Temporal(javax.persistence.TemporalType.TIMESTAMP)
    private Date published;

    @Temporal(javax.persistence.TemporalType.TIMESTAMP)
    private Date updated;

    // private String treaty;
    private String thumbnailUrl;
    private String country;

    @OneToMany(mappedBy = "document", cascade = CascadeType.ALL)
    private List<DocumentTreaty> treaties = new ArrayList<>();

    @OneToMany(mappedBy = "document", cascade = CascadeType.ALL)
    private List<DocumentAuthor> authors = new ArrayList<>();

    @OneToMany(mappedBy = "document", cascade = CascadeType.ALL)
    private List<DocumentDescription> descriptions = new ArrayList<>();

    @OneToMany(mappedBy = "document", cascade = CascadeType.ALL)
    private List<DocumentFile> files = new ArrayList<>();

    @OneToMany(mappedBy = "document", cascade = CascadeType.ALL)
    private List<DocumentIdentifier> identifiers = new ArrayList<>();

    @OneToMany(mappedBy = "document", cascade = CascadeType.ALL)
    private List<DocumentKeyword> keywords = new ArrayList<>();

    @OneToMany(mappedBy = "document", cascade = CascadeType.ALL)
    private List<DocumentGoal> goals = new ArrayList<>();

    @OneToMany(mappedBy = "document", cascade = CascadeType.ALL)
    private List<DocumentReference> references = new ArrayList<>();

    @OneToMany(mappedBy = "document", cascade = CascadeType.ALL)
    private List<DocumentTag> tags = new ArrayList<>();

    @OneToMany(mappedBy = "document", cascade = CascadeType.ALL)
    private List<DocumentTitle> titles = new ArrayList<>();

    @OneToMany(mappedBy = "document", cascade = CascadeType.ALL)
    private List<DocumentType> types = new ArrayList<>();

//    @ManyToOne
//    @JoinColumn(name="treaty")
//    private TreatyMachineName treatyMachineName;
    private String treaty;

    public String getId() {
        return id;
    }

    public Integer getDisplayOrder() {
        return displayOrder;
    }

    public String getSchemaVersion() {
        return schemaVersion;
    }

    public Date getPublished() {
        return published;
    }

    public Date getUpdated() {
        return updated;
    }

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    public List<DocumentAuthor> getAuthors() {
        return authors;
    }

    public List<DocumentType> getTypes() {
        return types;
    }

    public String getCountry() {
        return country;
    }

    public List<DocumentDescription> getDescriptions() {
        return descriptions;
    }

    public List<DocumentFile> getFiles() {
        return files;
    }

    public List<DocumentIdentifier> getIdentifiers() {
        return identifiers;
    }

    public List<DocumentKeyword> getKeywords() {
        return keywords;
    }

    public List<DocumentGoal> getGoals() {
        return goals;
    }

    public List<DocumentReference> getReferences() {
        return references;
    }

    public List<DocumentTag> getTags() {
        return tags;
    }

    public List<DocumentTitle> getTitles() {
        return titles;
    }

    public List<DocumentTreaty> getTreaties() {
        return treaties;
    }

    public String getTreaty() {
        return treaty;
    }

}
