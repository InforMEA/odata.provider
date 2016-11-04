/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package edw.olingo.model;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Site name entity
 * 
 * @author Cristian Romanescu {@code cristian.romanescu _at_ eaudeweb.ro}
 * @version 2.0.0, 11/13/2014
 * @since 1.3.3
 */
@Entity
@Table(name = "informea_sites_name")
public class SiteName {

	@Id
	private String id;

	@SuppressWarnings("unused")
	private Site site;

	private String language;
	private String name;

	public String getLanguage() {
		return language;
	}

	public String getName() {
		return name;
	}

	public String getId() {
		return id;
	}
}
