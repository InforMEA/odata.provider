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
 * Country report entity
 * 
 * @author Cristian Romanescu {@code cristian.romanescu _at_ eaudeweb.ro}
 * @version 2.1.0, 08/24/2015
 * @since 1.3.3
 */
@Entity
@Table(name = "informea_country_reports")
public class CountryReport {

	@Id
	@Column(name = "id")
	private String id;

	@Column(nullable = false)
	private String treaty;
	@Column(nullable = false)
	private String treatyUUID;
	@Column(nullable = false)
	private String country;

	@Temporal(TemporalType.TIMESTAMP)
	private Date submission;
	private String url;

	@Temporal(TemporalType.TIMESTAMP)
	private Date updated;

	@OneToMany(mappedBy = "country_report", cascade = CascadeType.ALL)
	private List<CountryReportTitle> titles;

	@OneToMany(mappedBy = "country_report", cascade = CascadeType.ALL)
	private List<CountryReportFile> files = new ArrayList<CountryReportFile>();


	public String getTreaty() {
		return treaty;
	}

	public String getCountry() {
		return country;
	}

	public Date getSubmission() {
		return submission;
	}

	public String getUrl() {
		return url;
	}

	public Date getUpdated() {
		return updated;
	}

	public List<CountryReportTitle> getTitles() {
		return titles;
	}

	public List<CountryReportFile> getFiles() {
		return files;
	}

	public String getId() {
		return id;
	}

	public String getTreatyUUID() {
		return treatyUUID;
	}
}
