package edw.olingo.model;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity(name = "MeetingTitle")
@Table(name = "informea_meetings_title")
public class MeetingTitle {

	@Id
	private String id;

	private String language;
	private String title;

	public String getId() {
		return id;
	}

	@SuppressWarnings("unused")
	private Meeting meeting;

	public String getLanguage() {
		return language;
	}

	public String getTitle() {
		return title;
	}
}
