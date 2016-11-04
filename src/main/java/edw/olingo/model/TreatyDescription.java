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

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Treaty description entity
 * 
 * @author Cristian Romanescu {@code cristian.romanescu _at_ eaudeweb.ro}
 */
@Entity
@Table(name = "informea_treaties_description")
public class TreatyDescription {

	@Id
	private String id;

	private String language;
	private String description;

	@SuppressWarnings("unused")
	private Treaty treaty;

	public String getLanguage() {
		return language;
	}

	public String getDescription() {
		return description;
	}

	public String getId() {
		return id;
	}
}
