package org.informea.odata.data.ldap;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.hibernate.criterion.Order;
import org.informea.odata.IContact;
import org.informea.odata.config.Configuration;
import org.informea.odata.config.LDAPConfiguration;
import org.informea.odata.constants.Treaty;
import org.informea.odata.data.IDataProvider;
import org.informea.odata.producer.InvalidValueException;
import org.odata4j.producer.QueryInfo;

import com.unboundid.ldap.sdk.Attribute;
import com.unboundid.ldap.sdk.LDAPConnection;
import com.unboundid.ldap.sdk.LDAPException;
import com.unboundid.ldap.sdk.LDAPSearchException;
import com.unboundid.ldap.sdk.SearchResult;
import com.unboundid.ldap.sdk.SearchResultEntry;
import com.unboundid.ldap.sdk.SearchScope;

public class LDAPDataProvider implements IDataProvider {

    private static final Logger log = Logger.getLogger(LDAPDataProvider.class.getName());

    LDAPConnection conn = null;

    @Override
    public void openResources() {
        if(conn == null) {
            LDAPConfiguration ldapCfg = Configuration.getInstance().getLDAPConfiguration();
            try {
                conn = new LDAPConnection(
                        ldapCfg.getHost(),
                        ldapCfg.getPort());
                conn.bind(ldapCfg.getBindDN(),
                        ldapCfg.getPassword());
            } catch(LDAPException ex) {
                log.log(Level.SEVERE, "Cannot connect to LDAP server", ex);
            }
        }
    }

    @Override
    public void closeResources() {
        if(conn != null) {
            conn.close();
        }
    }

    @Override
    public Integer countPrimaryEntities(Class entityClass, QueryInfo q) {
        int ret = 0;
        try {
            if(conn == null || !conn.isConnected()) {
                openResources();
            }
            LDAPConfiguration ldapCfg = Configuration.getInstance().getLDAPConfiguration();
            SearchResult results = conn.search(
                    ldapCfg.getUserBaseDN(), SearchScope.SUB,
                    ldapCfg.getUsersQueryFilter(),
                    "ldapentrycount"
                    );
            ret = results.getEntryCount();
        } catch(LDAPSearchException ex) {
            log.log(Level.WARNING, "countPrimaryEntities(): Failed to retrieve LDAP search results", ex);
        }
        return ret;
    }

    @Override
    public List getPrimaryEntities(Class entityClass, QueryInfo query,
            int startResult, Integer pageSize, Order orderBy) {
        List<IContact> ret = new ArrayList<IContact>();
        int actualPageSize = getPageSize(pageSize);
        try {
            if(conn == null || !conn.isConnected()) {
                openResources();
            }
            LDAPConfiguration ldapCfg = Configuration.getInstance().getLDAPConfiguration();
            SearchResult results = conn.search(
                    ldapCfg.getUserBaseDN(), SearchScope.SUB,
                    ldapCfg.getUsersQueryFilter());
            List<IContact> items = fromSearchResult(results);
            // Sanity checks
            int start = startResult;
            if(start < 0) {
                start = 0;
            }

            int end = start + actualPageSize;
            if(end > items.size()) {
                end = items.size();
            }
            log.info(String.format("Start result: %s", start));
            log.info(String.format("End result: %s", end));
            ret = items.subList(start, end);
        } catch(LDAPSearchException ex) {
            log.log(Level.WARNING, "countPrimaryEntities(): Failed to retrieve LDAP search results", ex);
        }
        return ret;
    }

    @Override
    public Object getPrimaryEntity(Class entityClass, String id) {
        IContact ret = null;
        try {
            if(conn == null || !conn.isConnected()) {
                openResources();
            }
            LDAPConfiguration ldapCfg = Configuration.getInstance().getLDAPConfiguration();
            String filter = String.format("%s=%s", ldapCfg.getUserIdAttribute(), id);
            SearchResultEntry item = conn.searchForEntry(
                    ldapCfg.getUserBaseDN(), SearchScope.SUB, filter );
            if(item != null) {
                ret = fromSearchResultEntry(item);
            }
        } catch(LDAPSearchException ex) {
            log.log(Level.WARNING, "countPrimaryEntities(): Failed to retrieve LDAP search results", ex);
        }
        return ret;
    }

    @Override
    public Object getEntity(Class entityClass, Object id) {
        log.info("getEntity(): Calling this method on LDAP data provider has no effect");
        return null;
    }

    /**
     * This method is used by test framework
     * @return
     */
    protected LDAPConnection getConnection() {
        return conn;
    }

    /**
     * Sanitize the request pageSize based on defaults to prevent server overload by retrieving a large result set.
     * @param requestedPageSize The requested pageSize
     * @return Sanitized pageSize
     */
    protected int getPageSize(int requestedPageSize) {
        int ret = 100;
        LDAPConfiguration ldapCfg = Configuration.getInstance().getLDAPConfiguration();
        int maxPageSize = ldapCfg.getMaxPageSize();
        if(maxPageSize > 0) {
            ret = maxPageSize;
        }
        if(requestedPageSize > 0 && requestedPageSize < ret) {
            ret = requestedPageSize;
        }
        return ret;
    }

    /**
     * Transform an array from LDAP SearchResultEntry to IContact items
     * @param entries List of entries
     * @return Corresponding IContact entities
     */
    public List<IContact> fromSearchResult(SearchResult entries) {
        List<IContact> ret = new ArrayList<IContact>();
        for(SearchResultEntry row: entries.getSearchEntries()) {
            ret.add(this.fromSearchResultEntry(row));
        }
        return ret;
    }

    /**
     * Transform a single entity from LDAP SearchResultEntry into IContact entity.
     * It is based on <code>Configuration</code> defined mappings (<code>Configuration.LDAP_MAPPING_*</code>)
     * @param ob The LDAP entry
     * @return Corresponding IContact object
     */
    public IContact fromSearchResultEntry(SearchResultEntry ob) {
        if(ob == null) {
            return null;
        }
        LDAPConfiguration ldapCfg = Configuration.getInstance().getLDAPConfiguration();
        LDAPContact ret = new LDAPContact();

        String idAttribute = ldapCfg.getUserIdAttribute();
        if(!ob.hasAttribute(idAttribute)) {
            throw new InvalidValueException(
                    String.format("LDAP entry does not have attribute %s marked as primary key! Entry %s", idAttribute, ob.getDN()));
        } else {
            ret.setId(ob.getAttributeValue(idAttribute));
        }

        String fieldValue = getFieldValue(ob, ldapCfg.getMapping(LDAPConfiguration.LDAP_MAPPING_PREFIX));
        ret.setPrefix(fieldValue);

        fieldValue = getFieldValue(ob, ldapCfg.getMapping(LDAPConfiguration.LDAP_MAPPING_FIRST_NAME));
        ret.setFirstName(fieldValue);

        fieldValue = getFieldValue(ob, ldapCfg.getMapping(LDAPConfiguration.LDAP_MAPPING_LAST_NAME));
        ret.setLastName(fieldValue);

        fieldValue = getFieldValue(ob, ldapCfg.getMapping(LDAPConfiguration.LDAP_MAPPING_ADDRESS));
        ret.setAddress(fieldValue);

        fieldValue = getFieldValue(ob, ldapCfg.getMapping(LDAPConfiguration.LDAP_MAPPING_COUNTRY));
        ret.setCountry(fieldValue);

        fieldValue = getFieldValue(ob, ldapCfg.getMapping(LDAPConfiguration.LDAP_MAPPING_DEPARTMENT));
        ret.setDepartment(fieldValue);

        fieldValue = getFieldValue(ob, ldapCfg.getMapping(LDAPConfiguration.LDAP_MAPPING_EMAIL));
        ret.setEmail(fieldValue);

        fieldValue = getFieldValue(ob, ldapCfg.getMapping(LDAPConfiguration.LDAP_MAPPING_FAX));
        ret.setFax(fieldValue);

        fieldValue = getFieldValue(ob, ldapCfg.getMapping(LDAPConfiguration.LDAP_MAPPING_INSTITUTION));
        ret.setInstitution(fieldValue);

        fieldValue = getFieldValue(ob, ldapCfg.getMapping(LDAPConfiguration.LDAP_MAPPING_PHONE));
        ret.setPhoneNumber(fieldValue);

        fieldValue = getFieldValue(ob, ldapCfg.getMapping(LDAPConfiguration.LDAP_MAPPING_POSITION));
        ret.setPosition(fieldValue);

        fieldValue = getFieldValue(ob, ldapCfg.getMapping(LDAPConfiguration.LDAP_MAPPING_PRIMARY_NFP));
        try {
            ret.setPrimary(Boolean.parseBoolean(fieldValue));
        } catch(Exception ex) {
            log.log(Level.WARNING, "Failed to parse boolean for 'primary' NFP", ex);
        }

        String key = ldapCfg.getMapping(LDAPConfiguration.LDAP_MAPPING_UPDATED);
        if(key != null && ob.hasAttribute(key)) {
            java.util.Date d = ob.getAttributeValueAsDate(key);
            ret.setUpdated(d);
        }

        key = ldapCfg.getMapping(LDAPConfiguration.LDAP_MAPPING_TREATIES);
        List<Treaty> treaties = new ArrayList<Treaty>();
        if(key != null && ob.hasAttribute(key)) {
            String[] items = ob.getAttributeValues(key);
            for(String row: items) {
                try {
                    Treaty t = Treaty.getTreaty(row);
                    treaties.add(t);
                } catch(Exception ex) {
                    log.log(Level.WARNING,
                            String.format("Unable to parse %s property with value %s", key, row),
                            ex);
                }
            }
            if(treaties.size() == 0) {
                log.warning(
                        String.format("Entry with DN:%s does not have any treaty set!", ret.getId()));
            }
            ret.setTreaties(treaties);
        }
        return ret;
    }

    /**
     * Retrieve a single-valued attribute from an entry. Supports variable substitution, like
     * "Address ${address}" equals to "Address 5th Avenue st.", where address is attribute of the search
     * result entry. For single attributes, <code>${...}</code> may be omitted. "address" will return "5th Avenue st.".
     * @param entry Entry to extract data from
     * @param value A string containing the patterns to extract from attributes.
     * @return Value with all variables substituted, as described in above.
     */
    protected String getFieldValue(SearchResultEntry entry, String value) {
        String ret = value;
        if(value == null || entry == null) {
            return null;
        }

        // For a single word attribute, assume it's an single property
        if(ret.matches("^\\w+$")) {
            if(entry.hasAttribute(ret)) {
                return entry.getAttributeValue(ret);
            }
        }

        Collection<Attribute> attributes = entry.getAttributes();
        Iterator<Attribute> it = attributes.iterator();
        while(it.hasNext()) {
            Attribute attr = it.next();
            String name = String.format("${%s}", attr.getName());
            ret = ret.replace(name, attr.getValue());
        }
        return ret;
    }
}
