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

@Entity(name = "Meeting")
@Table(name = "informea_meetings")
public class Meeting {

	@Id
	private String id;

	@Column(nullable = false, length = 1024)
	private String treaty;
	private String url;

	@Column(nullable = false)
	@Temporal(TemporalType.TIMESTAMP)
	private Date start;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "\"end\"")
	private Date end;

	private String repetition;
	private String kind;
	private String type;
	private String access;
	private String status;
	private String imageUrl;
	private String imageCopyright;
	private String location;
	private String city;

	@Column(nullable = false)
	private String country;

	private Double latitude;
	private Double longitude;

	@Temporal(TemporalType.TIMESTAMP)
	private Date updated;

	@OneToMany(mappedBy = "meeting", cascade = CascadeType.ALL)
	private List<MeetingDescription> descriptions = new ArrayList<MeetingDescription>();

	@OneToMany(mappedBy = "meeting", cascade = CascadeType.ALL)
	private List<MeetingTitle> titles = new ArrayList<MeetingTitle>();

	public String getId() {
		return id;
	}

	public String getTreaty() {
		return treaty;
	}

	public String getUrl() {
		return url;
	}

	public Date getStart() {
		return start;
	}

	public Date getEnd() {
		return end;
	}

	public String getRepetition() {
		return repetition;
	}

	public String getKind() {
		return kind;
	}

	public String getType() {
		return type;
	}

	public String getAccess() {
		return access;
	}

	public String getStatus() {
		return status;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public String getImageCopyright() {
		return imageCopyright;
	}

	public String getLocation() {
		return location;
	}

	public String getCity() {
		return city;
	}

	public String getCountry() {
		return country;
	}

	public Double getLatitude() {
		return latitude;
	}

	public Double getLongitude() {
		return longitude;
	}

	public Date getUpdated() {
		return updated;
	}

	public List<MeetingTitle> getTitles() {
		return titles;
	}

	public List<MeetingDescription> getDescriptions() {
		return descriptions;
	}
}
