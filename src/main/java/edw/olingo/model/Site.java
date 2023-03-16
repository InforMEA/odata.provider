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

import org.eclipse.persistence.annotations.BatchFetch;
import org.eclipse.persistence.annotations.BatchFetchType;

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
 * Site primary entity
 * 
 * @author Cristian Romanescu {@code cristian.romanescu _at_ eaudeweb.ro}
 * @version 2.0.0, 11/13/2014
 * @since 1.3.3
 */
@Entity
@Table(name = "informea_sites")
public class Site {

	@Id
	private String id;

	@Column(nullable = false)
	private String type;

	@Column(nullable = false)
	private String country;

	@Column(nullable = false)
	private String treaty;

	private String url;
	private Double latitude;
	private Double longitude;

	@OneToMany(mappedBy = "site", cascade = CascadeType.ALL)
	@BatchFetch(BatchFetchType.IN)
	private List<SiteName> names;

	@Temporal(TemporalType.TIMESTAMP)
	private Date updated;

	public String getTreaty() {
		return treaty;
	}

	public String getId() {
		return id;
	}

	public String getType() {
		return type;
	}

	public String getCountry() {
		return country;
	}

	public String getUrl() {
		return url;
	}

	public Double getLatitude() {
		return latitude;
	}

	public Double getLongitude() {
		return longitude;
	}

	public List<SiteName> getNames() {
		return names;
	}

	public Date getUpdated() {
		return updated;
	}
}
