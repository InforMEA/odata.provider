package edw.olingo.model;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Created by miahi on 5/13/2016.
 */
@Entity
@Table(name = "informea_treaty_machine_name")
public class TreatyMachineName {

    private String nid;
    private String uuid;

    @Id
    private String treaty;
    private String title;

    public String getNid() {
        return nid;
    }

    public String getUuid() {
        return uuid;
    }

    public String getTreaty() {
        return treaty;
    }

    public String getTitle() {
        return title;
    }
}
