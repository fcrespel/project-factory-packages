package org.apereo.services.persondir.support.merger;

import java.util.Arrays;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.validation.constraints.NotNull;

import org.apache.commons.lang3.Validate;
import org.apereo.services.persondir.IPersonAttributes;
import org.apereo.services.persondir.support.NamedPersonImpl;

import lombok.Getter;
import lombok.Setter;

/**
 * Merger that matches pairs of persons by attribute value and
 * delegates actual merging to a nested IAttributeMerger.
 * 
 * If no joining attribute is set, all persons will be merged in the first one.
 * 
 * @author Fabien Crespel (fabien@crespel.net)
 */
@Getter
@Setter
public class JoiningAttributeMerger implements IAttributeMerger {

	private @NotNull IAttributeMerger merger = new MultivaluedAttributeMerger();

	private String joinAttributeName = null;

	protected List<Object> getJoinAttributeValues(final IPersonAttributes person) {
		if (joinAttributeName != null) {
			return person.getAttributeValues(joinAttributeName);
		} else {
			return Arrays.asList((Object) person.getName());
		}
	}

	protected Map<String, List<Object>> buildAttributeMapForMerge(final Map<String, List<Object>> attributes) {
		final Map<String, List<Object>> attributeMap = new LinkedHashMap<>(attributes.size() > 0 ? attributes.size() : 1);
		for (final Map.Entry<String, List<Object>> attrEntry : attributes.entrySet()) {
			final String key = attrEntry.getKey();
			if (joinAttributeName == null || !key.equals(joinAttributeName)) {
				attributeMap.put(key, attrEntry.getValue());
			}
		}
		return attributeMap;
	}

	protected IPersonAttributes findMatchingResult(final Map<Object, IPersonAttributes> toModifyPeople, IPersonAttributes toConsiderPerson) {
		if (joinAttributeName == null) {
			if (!toModifyPeople.isEmpty()) {
				return toModifyPeople.values().iterator().next();
			}
		} else {
			final List<Object> toConsiderNames = getJoinAttributeValues(toConsiderPerson);
			if (toConsiderNames != null) {
				for (Object toConsiderName : toConsiderNames) {
					IPersonAttributes toModifyPerson = toModifyPeople.get(toConsiderName);
					if (toModifyPerson != null) {
						return toModifyPerson;
					}
				}
			}
		}
		return null;
	}

	protected void populateJoinAttributeMap(Map<Object, IPersonAttributes> people, IPersonAttributes person) {
		final List<Object> names = getJoinAttributeValues(person);
		if (names != null) {
			for (Object name : names) {
				people.put(name, person);
			}
		}
	}

	@Override
	public Set<IPersonAttributes> mergeResults(Set<IPersonAttributes> toModify, Set<IPersonAttributes> toConsider) {
		Validate.notNull(toModify, "toModify cannot be null");
		Validate.notNull(toConsider, "toConsider cannot be null");

		// Convert the toModify Set into a Map to allow for easier lookups
		final Map<Object, IPersonAttributes> toModifyPeople = new LinkedHashMap<>();
		for (final IPersonAttributes toModifyPerson : toModify) {
			populateJoinAttributeMap(toModifyPeople, toModifyPerson);
		}

		// Merge in the toConsider people
		for (final IPersonAttributes toConsiderPerson : toConsider) {
			final IPersonAttributes toModifyPerson = findMatchingResult(toModifyPeople, toConsiderPerson);

			// No matching toModify person, just add the new person
			if (toModifyPerson == null) {
				toModify.add(toConsiderPerson);
				populateJoinAttributeMap(toModifyPeople, toConsiderPerson);
			}
			// Matching toModify person, merge their attributes
			else {
				Set<IPersonAttributes> toConsiderForMerge = new HashSet<IPersonAttributes>();
				toConsiderForMerge.add(new NamedPersonImpl(toModifyPerson.getName(), buildAttributeMapForMerge(toConsiderPerson.getAttributes())));
				merger.mergeResults(toModify, toConsiderForMerge);
			}
		}

		return toModify;
	}

	@Override
	public Set<String> mergePossibleUserAttributeNames(Set<String> toModify, Set<String> toConsider) {
		return merger.mergePossibleUserAttributeNames(toModify, toConsider);
	}

	@Override
	public Set<String> mergeAvailableQueryAttributes(Set<String> toModify, Set<String> toConsider) {
		return merger.mergeAvailableQueryAttributes(toModify, toConsider);
	}

	@Override
	public Map<String, List<Object>> mergeAttributes(Map<String, List<Object>> toModify, Map<String, List<Object>> toConsider) {
		return merger.mergeAttributes(toModify, toConsider);
	}

}
