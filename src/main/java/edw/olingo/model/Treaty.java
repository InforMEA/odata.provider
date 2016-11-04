package edw.olingo.model;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity(name = "Treaty")
@Table(name = "informea_treaties")
public class Treaty {

	@Id
	private String id;

	@Column(nullable = false)
	private String uuid;

	private String url;
	private String treatyWebsiteURL;

	@Column(nullable = false, length = 1024)
	private String titleEnglish;

	private String officialNameEnglish;

	@OneToMany(mappedBy = "treaty", cascade = CascadeType.ALL)
	private List<TreatyDescription> descriptions = new ArrayList<TreatyDescription>();

	@OneToMany(mappedBy = "treaty", cascade = CascadeType.ALL)
	private List<TreatyTitle> titles = new ArrayList<TreatyTitle>();

	public String getId() {
		return id;
	}
	public String getUuid() {
		return uuid;
	}
	public String getUrl() {
		return url;
	}
	public String getTitleEnglish() {
		return titleEnglish;
	}
	public String getOfficialNameEnglish() {
		return officialNameEnglish;
	}
	public String getTreatyWebsiteURL() {
		return treatyWebsiteURL;
	}
	public List<TreatyDescription> getDescriptions() {
		return descriptions;
	}
	public List<TreatyTitle> getTitles() {
		return titles;
	}
}
