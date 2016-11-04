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

import javax.persistence.Cacheable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Decision document entity
 * 
 * @author Cristian Romanescu {@code cristian.romanescu _at_ eaudeweb.ro}
 * @version 2.0.0, 11/13/2014
 * @since 1.3.3
 */
@Entity
@Table(name = "informea_national_plans_documents")
@Cacheable
public class NationalPlanFile {

	@Id
	private String id;

	@SuppressWarnings("unused")
	private NationalPlan national_plan;

	// private String diskPath;
	private String url;

	@Column(nullable = false)
	private String mimeType;

	@Column(nullable = false)
	private String language;

	private String filename;

	public String getId() {
		return id;
	}

	public String getUrl() {
		return url;
	}

	public String getLanguage() {
		return language;
	}

	public String getFilename() {
		return filename;
	}

	public String getMimeType() {
		return mimeType;
	}
}
