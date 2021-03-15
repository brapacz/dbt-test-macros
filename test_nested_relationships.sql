{% macro test_nested_relationships(model, column_name, to, field, path, ignore_nulls) -%}
	WITH validation AS (
		SELECT DISTINCT * FROM
		{{ test_helper_build_query_unnested_path(path|default(column_name),model) }}
	),

	validation_errors AS (
		SELECT *
		FROM validation
		LEFT JOIN {{to}} AS other_table ON(other_table.{{field}} = validation.source)
		WHERE other_table.{{field}} IS NULL
		{% if ignore_nulls %} AND validation.source IS NOT NULL {% endif %}
	)

	SELECT COUNT(*)
	FROM validation_errors
{% endmacro %}

