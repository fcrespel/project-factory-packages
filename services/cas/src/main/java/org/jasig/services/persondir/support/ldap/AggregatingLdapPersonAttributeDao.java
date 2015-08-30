package org.jasig.services.persondir.support.ldap;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.Validate;
import org.jasig.services.persondir.IPersonAttributes;
import org.jasig.services.persondir.support.NamedPersonImpl;
import org.jasig.services.persondir.support.ldap.LdapPersonAttributeDao;
import org.jasig.services.persondir.support.ldap.LogicalFilterWrapper;
import org.jasig.services.persondir.support.merger.IAttributeMerger;
import org.jasig.services.persondir.support.merger.MultivaluedAttributeMerger;

/**
 * LDAP PersonAttributeDao that will aggregate attribute values from multiple
 * results, e.g. when searching for groups a DN is member of.
 * 
 * The attribute aggregation strategy is pluggable, and defaults to merging attributes
 * coming from multiple results into multivalued attributes of a single result.
 * 
 * @author Fabien Crespel <fabien@crespel.net>
 */
public class AggregatingLdapPersonAttributeDao extends LdapPersonAttributeDao {

	protected IAttributeMerger attrMerger = new MultivaluedAttributeMerger();
	
	/*
	 * (non-Javadoc)
	 * @see org.jasig.services.persondir.support.ldap.LdapPersonAttributeDao#getPeopleForQuery(org.jasig.services.persondir.support.ldap.LogicalFilterWrapper, java.lang.String)
	 */
	@Override
	protected List<IPersonAttributes> getPeopleForQuery(LogicalFilterWrapper queryBuilder, String queryUserName) {
		List<IPersonAttributes> toConsiderPeople = super.getPeopleForQuery(queryBuilder, queryUserName);
		if (toConsiderPeople == null) {
			return null;
		}
		
		List<IPersonAttributes> toModifyPeople = new ArrayList<IPersonAttributes>(toConsiderPeople.size());
		for (IPersonAttributes toConsiderPerson : toConsiderPeople) {
			int index = toModifyPeople.indexOf(toConsiderPerson);
			if (index < 0) {
				// No matching toModify person, just add the new person
				toModifyPeople.add(toConsiderPerson);
			} else {
				// Matching toModify person, merge their attributes
				IPersonAttributes toModifyPerson = toModifyPeople.get(index);
				Map<String, List<Object>> toModifyAttributes = this.buildMutableAttributeMap(toModifyPerson.getAttributes());
				Map<String, List<Object>> mergedAttributes = this.attrMerger.mergeAttributes(toModifyAttributes, toConsiderPerson.getAttributes());
                NamedPersonImpl mergedPerson = new NamedPersonImpl(toConsiderPerson.getName(), mergedAttributes);
              
                // Remove then re-add the mergedPerson entry
				toModifyPeople.remove(index);
				toModifyPeople.add(mergedPerson);
			}
		}

		return toModifyPeople;
	}
	
	/**
     * Do a deep clone of an attribute Map to ensure it is completley mutable.
     */
    protected Map<String, List<Object>> buildMutableAttributeMap(Map<String, List<Object>> attributes) {
        final Map<String, List<Object>> mutableValuesBuilder = this.createMutableAttributeMap(attributes.size());

        for (final Map.Entry<String, List<Object>> attrEntry : attributes.entrySet()) {
            final String key = attrEntry.getKey();
            List<Object> value = attrEntry.getValue();
            
            if (value != null) {
                value = new ArrayList<Object>(value);
            }
            
            mutableValuesBuilder.put(key, value);
        }

        return mutableValuesBuilder;
    }

    /**
     * Create the Map used when merging attributes
     */
    protected Map<String, List<Object>> createMutableAttributeMap(int size) {
        return new LinkedHashMap<String, List<Object>>(size > 0 ? size : 1);
    }

	/**
     * Get the strategy whereby we accumulate attributes.
     * 
     * @return Returns the attrMerger.
     */
    public final IAttributeMerger getMerger() {
        return this.attrMerger;
    }

    /**
     * Set the strategy whereby we accumulate attributes from the results of 
     * polling our delegates.
     * 
     * @param merger The attrMerger to set.
     * @throws IllegalArgumentException If merger is <code>null</code>.
     */
    public final void setMerger(final IAttributeMerger merger) {
        Validate.notNull(merger, "The IAttributeMerger cannot be null");
        this.attrMerger = merger;
    }

}
