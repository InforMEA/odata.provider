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
package edw.olingo.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * National plan entity
 * 
 * @author Cristian Romanescu {@code cristian.romanescu _at_ eaudeweb.ro}
 * @version 2.1.0, 08/24/2015
 * @since 1.3.3
 */
@Entity
@Table(name = "informea_national_plans")
public class NationalPlan {

	@Id
	private String id;

	@Column(nullable = false, length = 1024)
	private String treaty;

	@Column(nullable = false)
	private String country;

	@Column(nullable = false)
	private String type;

	private String url;

	@Temporal(TemporalType.TIMESTAMP)
	private Date submission;

	@Temporal(TemporalType.TIMESTAMP)
	private Date updated;

	@OneToMany(mappedBy = "national_plan", cascade = CascadeType.ALL)
	private List<NationalPlanTitle> titles;

	@OneToMany(mappedBy = "national_plan", cascade = CascadeType.ALL)
	private List<NationalPlanFile> files = new ArrayList<NationalPlanFile>();

	public String getTreaty() {
		return treaty;
	}

	public String getCountry() {
		return country;
	}

	public String getType() {
		return type;
	}

	public String getUrl() {
		return url;
	}

	public Date getSubmission() {
		return submission;
	}

	public Date getUpdated() {
		return updated;
	}

	public List<NationalPlanTitle> getTitles() {
		return titles;
	}

	public List<NationalPlanFile> getFiles() {
		return files;
	}

	public String getId() {
		return id;
	}
}
