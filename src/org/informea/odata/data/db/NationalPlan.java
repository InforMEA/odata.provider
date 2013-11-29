/* Copyright 2011 UNEP (http://www.unep.org)
 * This file is part of InforMEA Toolkit project.
 * InforMEA Toolkit is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option)
 * any later version.
 *
 * InforMEA Toolkit is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 * You should have received a copy of the GNU General Public License along with
 * InforMEA Toolkit. If not, see http://www.gnu.org/licenses/.
 */
package org.informea.odata.data.db;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Set;
import javax.persistence.Cacheable;
import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import org.informea.odata.constants.Treaty;
import org.informea.odata.pojo.AbstractNationalPlan;
import org.informea.odata.pojo.LocalizableString;
import org.informea.odata.producer.InvalidValueException;


/**
 * National plan primary entity
 * <br />
 * @author Cristian Romanescu {@code cristian.romanescu _at_ eaudeweb.ro}
 * @version 1.4.0, 10/28/2011
 * @since 1.3.3
 */
@Entity
@Table(name = "informea_national_plans")
@Cacheable
public class NationalPlan extends AbstractNationalPlan {

    private static final long serialVersionUID = -3594401418854291067L;

    @Id
    private String id;
    private String treaty;
    private String country;
    private String type;
    private String url;

    @Temporal(TemporalType.TIMESTAMP)
    private Date submission;

    @Temporal(TemporalType.TIMESTAMP)
    private Date updated;

    @OneToMany(cascade= CascadeType.ALL, fetch= FetchType.LAZY)
    @JoinColumn(name="national_plan_id")
    private Set<NationalPlanTitle> titles;


    @Override
    public Short getProtocolVersion() {
        return 1;
    }


    @Override
    public String getId() {
        return id;
    }


    @Override
    public Treaty getTreaty() {
        if(treaty == null || treaty.isEmpty()) {
            throw new InvalidValueException(String.format("'treaty' property cannot be null (Affected national plan with ID:%s)", id));
        }
        return Treaty.getTreaty(treaty);
    }


    @Override
    public String getCountry() {
        if(country == null) {
            throw new InvalidValueException(String.format("'country' is invalid. Each national plan must have a valid non-null country. Check informea_national_plans (Affected national plan with ID:%s)", id));
        }
        return country;
    }


    @Override
    public String getType() {
        return type;
    }


    @Override
    public List<LocalizableString> getTitle() {
        List<LocalizableString> ret = new ArrayList<LocalizableString>();
        if (titles.isEmpty()) {
            throw new InvalidValueException(String.format("'title' property is empty. Every national plan must have at least an title in english. Check informea_national_plans_title view. (Affected national plan with ID:%s)", id));
        }
        boolean hasEnglish = false;
        for(NationalPlanTitle t : titles) {
            String tt = t.getTitle();
            String language = t.getLanguage();
            if("en".equalsIgnoreCase(language)) {
                hasEnglish = true;
            }
            if(tt != null && language != null && !"".equals(tt.trim()) && !"".equals(language.trim())) {
                ret.add(new LocalizableString(t.getLanguage(), tt));
            } else {
                throw new InvalidValueException(String.format("'title' is invalid (language/value pairs must be non-null and one of language/value was null). (Affected national plan with ID:%s)", id));
            }
        }
        if(!hasEnglish) {
            throw new InvalidValueException(String.format("Every national plan must have the title in english. Check informea_national_plans_title view. (Affected national plan with ID:%s)", id));
        }
        return ret;
    }


    @Override
    public String getUrl() {
        return url;
    }

    @Override
    public Date getSubmission() {
        return submission;
    }

    @Override
    public Date getUpdated() {
        return updated;
    }
}